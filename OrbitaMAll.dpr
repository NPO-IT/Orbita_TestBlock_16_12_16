program Project1;

uses
  Forms,
  OrbitaAll in 'OrbitaAll.pas' {Form1},
  ExitForm in 'ExitForm.pas' {Form2},
  TLMUnit in 'TLMUnit.pas',
  LibUnit in 'LibUnit.pas',
  ACPUnit in 'ACPUnit.pas',
  UnitM16 in 'UnitM16.pas',
  OutUnit in 'OutUnit.pas',
  UnitMoth in 'UnitMoth.pas',
  TestUnit_N1_1 in 'TestUnit_N1_1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

