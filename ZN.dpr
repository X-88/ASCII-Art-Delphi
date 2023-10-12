program ZN;

uses
  Forms,
  Unit1 in 'Unit1.pas' {FZSN};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFZSN, FZSN);
  Application.Run;
end.
