unit UOptCzasMobMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  generics.defaults, generics.collections, FMX.ScrollBox, FMX.Memo,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts , Math,
  FMX.Memo.Types;

type
  TFOptCzasMobMain = class(TForm)
    BtnRunTest: TButton;
    MemoLog: TMemo;
    EditIters: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EditShowIters: TEdit;
    SwitchUsePL: TSwitch;
    Panel1: TPanel;
    Label3: TLabel;
    AniIndicator1: TAniIndicator;
    Label4: TLabel;
    EditSeedValue: TEdit;
    VertScrollBox1: TVertScrollBox;
    LayoutMain: TLayout;
    procedure BtnRunTestClick(Sender: TObject);
    procedure MemoLogResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TMyStringComparer = class(TComparer<String>)
  public
    function Compare(const Left, Right: String): Integer; override;
  end;



var
  FOptCzasMobMain : TFOptCzasMobMain;
  tabstr          : array of String;
  DeviceModel     : String = '';

implementation
 uses System.Diagnostics
 {$IFDEF ANDROID}
  ,Androidapi.JNI.Os, Androidapi.Helpers
 {$ENDIF}
 {$IFDEF IOS}
  ,iOSapi.UIKit
  ,Posix.SysSysctl
  ,Posix.StdDef
 {$ENDIF}
 ;

{$R *.fmx}


function TMyStringComparer.Compare(const Left, Right: String): Integer;
var
  LeftTerm, RightTerm: Integer;
begin
  result := AnsiCompareStr(Left,Right);
end;






procedure DoTest(maxv : Integer=10; showlastresults: Integer=0; usePL:boolean=true; seedvalue:Integer=1234);
begin
 TThread.CreateAnonymousThread(
 procedure
 var
  i,j       : Integer;
  stp       : TStopWatch;
  RandSeed  : Integer;
// Random integer, implemented as a deterministic linear congruential generator
// with 134775813 as a and 1 as c.
    function Random(const ARange: Integer): Integer;
    var
      Temp: Integer;
    begin
      Temp := RandSeed * $08088405 + 1;
      RandSeed := Temp;
      // Result:=Temp;
      Result := (UInt64(Cardinal(ARange)) * UInt64(Cardinal(Temp))) shr 32;
    end;


 begin
      RandSeed:=seedvalue;
      //TThread.CurrentThread.Priority := tpTimeCritical;
      TThread.Synchronize(TThread.CurrentThread,
       procedure()
       var
        i: integer;
       begin
          FOptCzasMobMain.BtnRunTest.Enabled := false;
          FOptCzasMobMain.AniIndicator1.Enabled:=true;
          FOptCzasMobMain.AniIndicator1.Visible:=true;
       end
      );


     if showlastresults>maxv then
       showlastresults:=maxv;

     SetLength(tabstr, 0);
     SetLength(tabstr, maxv);
     //Randomize;

     for i := 0 to maxv-1 do
     begin
        for j := 1 to Random(8)+1 do
         tabstr[i]:=tabstr[i]+Char(65+Random(26));//{$IFDEF WIN32}AnsiChar{$ELSE}Char{$ENDIF}(65+Random(26));
     end;

      tabstr[maxv - 3] := '¯Ó£WIK';
      tabstr[maxv - 2] := '¯ABA';
      tabstr[maxv - 1] := '¯ONA';
      tabstr[maxv - 4] := '£¥KA';
      tabstr[maxv - 5] := '£ANIA';
      tabstr[maxv - 6] := 'LADA';
      tabstr[maxv - 7] := 'LOS';
      tabstr[maxv - 8] := 'ZONA';
     stp:=TStopWatch.StartNew;
     if usePL then
       TArray.Sort<String>(tabstr, TMyStringComparer.Create)
     else
       TArray.Sort<String>(tabstr);
     stp.Stop;
      TThread.Synchronize(TThread.CurrentThread,
       procedure()
       var
        i: integer;
       begin
         FOptCzasMobMain.AniIndicator1.Visible:=false;
         FOptCzasMobMain.AniIndicator1.Enabled:=false;
         FOptCzasMobMain.MemoLog.Lines.Add('Elapsed time: '+FloatToStr((stp.ElapsedMilliseconds)/1000)+' s.');
         if showlastresults>0 then
           for i := maxv-showlastresults to maxv-1 do
              FOptCzasMobMain.Memolog.Lines.Add(tabstr[i]);
         FOptCzasMobMain.BtnRunTest.Enabled := true;
       end
      );

 end
 ).Start;
end;


procedure TFOptCzasMobMain.BtnRunTestClick(Sender: TObject);
begin
 MemoLog.Lines.Clear;
 MemoLog.Lines.Add('Compiler: RAD Studio 11');
 MemoLog.Lines.Add('Device: ' + DeviceModel);
 DoTest(StrToInt(EditIters.Text), StrToInt(EditShowIters.Text), SwitchUsePL.IsChecked, StrToInt(EditSeedValue.Text));
end;

procedure TFOptCzasMobMain.FormCreate(Sender: TObject);
{$IFDEF IOS}
function GetDeviceModelString: String;
var
  Size: size_t;
  DeviceModelBuffer: array of Byte;
begin
  sysctlbyname('hw.machine', nil, @Size, nil, 0);

  if Size > 0 then
  begin
    SetLength(DeviceModelBuffer, Size);
    sysctlbyname('hw.machine', @DeviceModelBuffer[0], @Size, nil, 0);
    Result := UTF8ToString(MarshaledAString(DeviceModelBuffer));
  end
  else
    Result := EmptyStr;
end;
{$ENDIF}

begin
{$IFDEF ANDROID}
 DeviceModel:=JStringToString(TJBuild.JavaClass.MODEL);
 if DeviceModel = 'HUAWEI WATCH' then LayoutMain.Margins.Top := 60;

{$ENDIF}
{$IFDEF IOS}
 DeviceModel := GetDeviceModelString;
{$ENDIF}

 DeviceModel := DeviceModel + ' ' + TOSVersion.ToString;

end;

procedure TFOptCzasMobMain.MemoLogResize(Sender: TObject);
begin
 MemoLog.Height:=max(ClientHeight-(BtnRunTest.Position.Y+BtnRunTest.Height+
    BtnRunTest.Margins.Bottom+ MemoLog.Margins.Top)-5,100);
end;

end.
