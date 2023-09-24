unit UPogodaMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.TabControl, REST.Types, FMX.Controls.Presentation,
  FMX.StdCtrls, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, FMX.ListBox, FMX.Layouts,
  System.Actions, FMX.ActnList, FMX.Edit;

type
  TFPogodaMain = class(TForm)
    TabControlMain: TTabControl;
    TabItemResults: TTabItem;
    TabItemForecast: TTabItem;
    ListViewForecast: TListView;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapterForecast: TRESTResponseDataSetAdapter;
    FDMemTableForecast: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    FDMemTableDetails: TFDMemTable;
    RESTResponseDataSetAdapterDetails: TRESTResponseDataSetAdapter;
    ListBoxDetails: TListBox;
    ListBoxItemTemp: TListBoxItem;
    LabelTemp: TLabel;
    ListBoxItemCisn: TListBoxItem;
    LabelCisn: TLabel;
    ListBoxItemTmin: TListBoxItem;
    LabelTmin: TLabel;
    ListBoxItemTmax: TListBoxItem;
    LabelTmax: TLabel;
    ListBoxItemWilg: TListBoxItem;
    LabelWilg: TLabel;
    BindSourceDB2: TBindSourceDB;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkPropertyToFieldText3: TLinkPropertyToField;
    LinkPropertyToFieldText4: TLinkPropertyToField;
    LinkPropertyToFieldText5: TLinkPropertyToField;
    ActionList1: TActionList;
    NextTabActionDetails: TNextTabAction;
    ToolBar1: TToolBar;
    LabelDetails: TLabel;
    ButtonWroc: TButton;
    PreviousTabActionDetails: TPreviousTabAction;
    ToolBar2: TToolBar;
    Label1: TLabel;
    EditSearch: TEdit;
    ButtonClearEditSearch: TButton;
    ButtonSearch: TButton;
    TimerTyping: TTimer;
    AniIndicator1: TAniIndicator;
    procedure ListViewForecastItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure ButtonWrocClick(Sender: TObject);
    procedure ListBoxDetailsItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure EditSearchChangeTracking(Sender: TObject);
    procedure ButtonClearEditSearchClick(Sender: TObject);
    procedure TimerTypingTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPogodaMain: TFPogodaMain;

implementation

{$R *.fmx}

procedure TFPogodaMain.ButtonClearEditSearchClick(Sender: TObject);
begin
 EditSearch.Text :='';
 ButtonSearch.Visible :=true;
 EditSearch.SetFocus;
end;

procedure TFPogodaMain.ButtonWrocClick(Sender: TObject);
begin
 PreviousTabActionDetails.Execute;
end;

procedure TFPogodaMain.EditSearchChangeTracking(Sender: TObject);
begin
   TimerTyping.Enabled  := false;
   TimerTyping.Interval := 1200;
   TimerTyping.Enabled  := true;
   ButtonSearch.Visible := (EditSearch.Text='');
end;

procedure TFPogodaMain.ListBoxDetailsItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
 ListBoxDetails.ItemIndex := -1;
 ListBoxDetails.RealignContent;
end;

procedure TFPogodaMain.ListViewForecastItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
 LabelDetails.Text := EditSearch.Text+' '+ListViewForecast.Items[ItemIndex].Text;
 RESTResponseDataSetAdapterDetails.RootElement:='list['+ItemIndex.ToString+'].main';
 RESTResponseDataSetAdapterDetails.UpdateDataSet;
 ListViewForecast.Selected:=nil;
 NextTabActionDetails.Execute;
end;

procedure TFPogodaMain.TimerTypingTimer(Sender: TObject);
begin
  TimerTyping.Enabled := false;

//  RESTResponseDataSetAdapterForecast.AutoUpdate := false;
//  RESTResponseDataSetAdapterDetails.AutoUpdate := false;
  ListViewForecast.Items.Clear;
  AniIndicator1.Enabled := true;
  AniIndicator1.Visible := true;

  RESTRequest1.Params[0].Value := EditSearch.Text;
  RESTRequest1.ExecuteAsync(
    procedure()
    begin
      FPogodaMain.AniIndicator1.Enabled := false;
      FPogodaMain.AniIndicator1.Visible := false;
      if RESTResponse1.StatusCode = 200 then
      begin
        RESTResponseDataSetAdapterForecast.UpdateDataSet;
      end;

    end
  );
end;

end.
