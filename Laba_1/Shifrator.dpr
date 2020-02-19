program Shifrator;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Encrypter};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TEncrypter, Encrypter);
  Application.Run;
end.
