program UI;

uses
  Vcl.Forms,
  FormView in 'FormView.pas' {Form2},
  CandyTypes in 'CandyTypes.pas',
  FileWork in 'FileWork.pas',
  ChooseType in 'ChooseType.pas' {Choose};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TChoose, Choose);
  Application.Run;
end.
