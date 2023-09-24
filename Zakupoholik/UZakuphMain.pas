unit UZakuphMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ListView, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.DialogService, System.Math,
  FireDAC.Comp.UI, FMX.Objects, FMX.Layouts, FMX.Edit, FMX.Gestures,
  System.Notification, FMX.SearchBox, System.Threading
{$IFDEF IOS}
  ,iOSapi.UIKit,iOSapi.foundation, Macapi.Helpers
  ,FMX.VirtualKeyboard.iOS, iOSapi.UserNotifications
{$ENDIF}
  ;

type
  TFZakupoholikMain = class(TForm)
    ToolBar1: TToolBar;
    ButtonDodaj: TButton;
    ListView1: TListView;
    FDConnection1: TFDConnection;
    FDQueryListaZakupow: TFDQuery;
    BindingsList1: TBindingsList;
    FDQueryDodaj: TFDQuery;
    FDQueryUsun: TFDQuery;
    LinkListControlToField1: TLinkListControlToField;
    BindSourceDB1: TBindSourceDB;
    FDQueryKupione: TFDQuery;
    LabelTitleMain: TLabel;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    LayoutDodaj: TLayout;
    RoundRect1: TRoundRect;
    Rectangle1: TRectangle;
    ButtonAnuluj: TButton;
    ButtonZrobDodaj: TButton;
    EditCoKupic: TEdit;
    EditIleKupic: TEdit;
    RoundRect2: TRoundRect;
    GestureManager1: TGestureManager;
    Layout1: TLayout;
    NotificationCenter1: TNotificationCenter;
    FDQueryIleNieKupionych: TFDQuery;
    ButtonFiltruj: TButton;
    TimerStart: TTimer;
    procedure ButtonDodajClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1DeletingItem(Sender: TObject; AIndex: Integer;
      var ACanDelete: Boolean);
    procedure ListView1DeleteItem(Sender: TObject; AIndex: Integer);
    procedure LinkListControlToField1FilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure FDConnection1AfterConnect(Sender: TObject);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure ListView1UpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ButtonZrobDodajClick(Sender: TObject);
    procedure ButtonAnulujClick(Sender: TObject);
    procedure FormVirtualKeyboardChange(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure ListView1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure UpdateInfo;
    procedure ButtonFiltrujClick(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
{$IFDEF IOS}
    procedure RequestAuthorizationHandler(granted: Boolean; error: NSError);

{$ENDIF}
  private
    { Private declarations }
    iddousuniecia : Integer;
  public
    { Public declarations }
  end;


TListViewHelper = class helper for TListViewBase
  procedure ClearSearchEdit;
  procedure SearchEditSetFocus;
end;


var
  FZakupoholikMain: TFZakupoholikMain;

implementation

uses
  System.IOUtils, FMX.Ani, FMX.Platform;

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

procedure TFZakupoholikMain.ButtonAnulujClick(Sender: TObject);
begin
  EditCoKupic.Text := '';
  EditIleKupic.Text := '';
  TAnimator.AnimateFloat(LayoutDodaj,'Position.Y',ListView1.Position.Y+ListView1.Height+1,0.8,TAnimationType.InOut,TInterpolationType.Exponential);

  TTask.Run(
  procedure
  begin
    Sleep(850);
    TThread.Synchronize(nil,
           procedure
           begin
             LayoutDodaj.Visible := false;
             ButtonDodaj.Enabled := true;
           end
      );

  end
 );

end;

procedure TFZakupoholikMain.ButtonDodajClick(Sender: TObject);
begin
 LayoutDodaj.Position.Y := ListView1.Position.Y+ListView1.Height;
 LayoutDodaj.Visible := true;
 ButtonDodaj.Enabled := false;
 TAnimator.AnimateFloat(LayoutDodaj,'Position.Y',LayoutDodaj.Position.Y-LayoutDodaj.Height,0.8,TAnimationType.InOut,TInterpolationType.Exponential);

// TDialogService.InputQuery('Nowy zakup', ['Co kupiæ?', 'Ile kupiæ?'], ['',''],
//  procedure(const AResult: TModalResult; const AValues: array of string)
//  begin
//    if Aresult = mrOK then
//    begin
//      FDQueryDodaj.Close;
//      FDQueryDodaj.ParamByName('co').AsString := AValues[0];
//      FDQueryDodaj.ParamByName('ile').AsInteger := AValues[1].ToInteger;
//      FDQueryDodaj.ExecSQL;
//      FDQueryListaZakupow.Close;
//      FDQueryListaZakupow.Open;
//
//
//    end;
//  end
// );
end;

procedure TFZakupoholikMain.ButtonFiltrujClick(Sender: TObject);
begin
 if LayoutDodaj.Visible then
   ButtonAnulujClick(self);
 ListView1.SearchVisible := not ListView1.SearchVisible;
 if not ListView1.SearchVisible then
   ListView1.ClearSearchEdit
 else
   ListView1.SearchEditSetFocus;


end;

procedure TFZakupoholikMain.ButtonZrobDodajClick(Sender: TObject);
var
  ilekupic : integer;

begin
  if EditCoKupic.Text <> '' then
  begin

      if TryStrToInt(EditIleKupic.Text, ilekupic) then
      begin
          FDQueryDodaj.Close;
          FDQueryDodaj.ParamByName('co').AsString := EditCoKupic.Text;
          FDQueryDodaj.ParamByName('ile').AsInteger := ilekupic;
          FDQueryDodaj.ExecSQL;
          UpdateInfo;
          EditCoKupic.Text := '';
          EditIleKupic.Text := '';
          TAnimator.AnimateFloat(LayoutDodaj,'Position.Y',ListView1.Position.Y+ListView1.Height+1,0.8,TAnimationType.InOut,TInterpolationType.Exponential);

          TTask.Run(
            procedure
            begin
              Sleep(850);
              TThread.Synchronize(nil,
                     procedure
                     begin
                       LayoutDodaj.Visible := false;
                       ButtonDodaj.Enabled := true;
                     end
                );

            end
           );
      end
       else
      TDialogService.ShowMessage('Podaj iloœæ!');
  end
   else
      TDialogService.ShowMessage('Wpisz co chcesz kupiæ!');

end;

procedure TFZakupoholikMain.FDConnection1AfterConnect(Sender: TObject);
begin
  FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS listazakupow (cokupic TEXT NOT NULL, ilekupic NUMBER, kupione INTEGER)');
end;

procedure TFZakupoholikMain.FDConnection1BeforeConnect(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
   var sciezka := TPath.Combine(ExtractFilePath(paramstr(0)),'db');
    if not DirectoryExists(sciezka) then
        TDirectory.CreateDirectory(sciezka);

    FDConnection1.Params.Values['Database'] :=TPath.Combine(sciezka,'zakupy.sdb');
{$ELSE}
  FDConnection1.Params.Values['Database'] :=
      TPath.Combine(TPath.GetDocumentsPath, 'zakupy.sdb');
{$ENDIF}

end;

procedure TFZakupoholikMain.FormCreate(Sender: TObject);
begin
 FDConnection1.Connected := true;
 FDQueryListaZakupow.Active := true;
 //ButtonFiltruj.StyleLookup := 'detailstoolbutton';


end;

procedure TFZakupoholikMain.FormVirtualKeyboardChange(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
var
  ToolbarHeight : Integer;
begin
  ToolbarHeight := 0;
{$IFDEF IOS}
  ToolbarHeight := 44;
{$ENDIF}

 if KeyboardVisible and LayoutDodaj.IsVisible then
  TAnimator.AnimateFloat(LayoutDodaj,'Position.Y',Bounds.Top-ToolbarHeight-LayoutDodaj.Height+1,0.8,TAnimationType.InOut,TInterpolationType.Exponential)
 else
  TAnimator.AnimateFloat(LayoutDodaj,'Position.Y',ListView1.Position.Y+ListView1.Height-LayoutDodaj.Height,0.8,TAnimationType.InOut,TInterpolationType.Exponential);

end;

procedure TFZakupoholikMain.LinkListControlToField1FilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
begin
 (AEditor.CurrentObject as TListItem).Tag :=
     FDQueryListaZakupow.FieldByName('rowid').AsInteger;
 (AEditor.CurrentObject as TListItem).TagString :=
     FDQueryListaZakupow.FieldByName('kupione').AsInteger.ToString;

end;

procedure TFZakupoholikMain.ListView1DeleteItem(Sender: TObject; AIndex: Integer);
begin
  FDQueryUsun.Close;
  FDQueryUsun.ParamByName('rid').AsInteger := iddousuniecia;
  FDQueryUsun.ExecSQL;
  UpdateInfo;
end;

procedure TFZakupoholikMain.ListView1DeletingItem(Sender: TObject; AIndex: Integer;
  var ACanDelete: Boolean);
begin
 iddousuniecia := listView1.Items[aIndex].Tag;
 ACandelete:=true;
end;

procedure TFZakupoholikMain.ListView1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
 Handled := True;
end;

procedure TFZakupoholikMain.ListView1ItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  //(Sender as TListView).ItemIndex := -1;
  //(Sender as TListView).Selected := nil;
  (Sender as TListView).Items[ItemIndex].Objects.AccessoryObject.Visible := not (Sender as TListView).Items[ItemIndex].Objects.AccessoryObject.Visible;
  FDQueryKupione.Close;
  FDQueryKupione.ParamByName('rid').AsInteger := (Sender as TListView).Items[ItemIndex].Tag;
  FDQueryKupione.ParamByName('czykup').AsInteger := IfThen((Sender as TListView).Items[ItemIndex].Objects.AccessoryObject.Visible,1,0);
  FDQueryKupione.ExecSQL;
  UpdateInfo;

end;

procedure TFZakupoholikMain.ListView1UpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
 AItem.Objects.AccessoryObject.Visible := (AItem.TagString = '1');
end;

procedure TFZakupoholikMain.UpdateInfo;
begin
  FDQueryListaZakupow.Close;
  FDQueryListaZakupow.Open;

  FDQueryIleNieKupionych.Close;
  FDQueryIleNieKupionych.Open;
  var ile:Integer :=  FDQueryIleNieKupionych.Fields[0].AsInteger;
  FZakupoholikMain.Caption := 'Zakupoholik ('+ile.ToString+')';
  LabelTitleMain.Text := FZakupoholikMain.Caption;
  NotificationCenter1.ApplicationIconBadgeNumber:=ile;
end;

{$IFDEF IOS}
procedure TFZakupoholikMain.RequestAuthorizationHandler(granted: Boolean;
  error: NSError);
begin
  //SharedApplication.registerForRemoteNotifications;
  TThread.Synchronize(nil,
                     procedure
                     begin
                       UpdateInfo;
                     end
                );


end;


{$ENDIF}

procedure TFZakupoholikMain.TimerStartTimer(Sender: TObject);
begin
 TimerStart.Enabled := false;
 {$IFDEF IOS}
  TUNUserNotificationCenter.OCClass.currentNotificationCenter.requestAuthorizationWithOptions(
      UNAuthorizationOptionBadge {or UNAuthorizationOptionSound or UNAuthorizationOptionAlert}, RequestAuthorizationHandler);
  //TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication).setApplicationIconBadgeNumber(ile);
{$ELSE}
  UpdateInfo;
{$ENDIF IOS}

end;

{ TListViewHelper }

procedure TListViewHelper.ClearSearchEdit;
begin
  for var i := 0 to self.controls.Count - 1 do
  begin
    if self.controls[i].ClassType = TSearchBox then
    begin
      TEdit(self.controls[i]).Text:='';
    end;
  end;
end;

procedure TListViewHelper.SearchEditSetFocus;
begin
  for var i := 0 to self.controls.Count - 1 do
  begin
    if self.controls[i].ClassType = TSearchBox then
    begin
      TEdit(self.controls[i]).SetFocus;
    end;
  end;
end;

end.
