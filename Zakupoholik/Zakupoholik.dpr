program Zakupoholik;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Types,
  UZakuphMain in 'UZakuphMain.pas' {FZakupoholikMain};

{$R *.res}

begin
  //GlobalUseMetal := true;
  Application.Initialize;
  Application.CreateForm(TFZakupoholikMain, FZakupoholikMain);
  Application.Run;
end.
