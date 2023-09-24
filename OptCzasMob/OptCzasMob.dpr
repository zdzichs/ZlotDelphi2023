program OptCzasMob;

uses
  System.StartUpCopy,
  //FMX.MobilePreview,
  FMX.Forms,
  UOptCzasMobMain in 'UOptCzasMobMain.pas' {FOptCzasMobMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFOptCzasMobMain, FOptCzasMobMain);
  Application.Run;
end.
