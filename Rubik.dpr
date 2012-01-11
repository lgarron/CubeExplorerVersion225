program Rubik;

uses
  Forms,
  RubikMain in 'RubikMain.pas' {Form1},
  CubeDefs in 'CubeDefs.pas',
  FaceCube in 'FaceCube.pas',
  CubiCube in 'CubiCube.pas',
  CordCube in 'CordCube.pas',
  Symmetries in 'Symmetries.pas',
  MathFuncs in 'MathFuncs.pas',
  Search in 'Search.pas',
  OptSearch in 'OptSearch.pas',
  TripSearch in 'TripSearch.pas',
  About in 'About.pas' {AboutForm},
  Options in 'Options.pas' {OptionForm},
  PatternSearch in 'PatternSearch.pas',
  hh_funcs in 'hh_funcs.pas',
  hh in 'hh.pas',
  OptOptions in 'OptOptions.pas' {OptOptionForm},
  D6OnHelpFix in 'D6OnHelpFix.pas';

{$R *.RES}
{$R cursors.RES}
begin
  Application.Initialize;
  Application.Title := '';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TOptionForm, OptionForm);
  Application.CreateForm(TOptOptionForm, OptOptionForm);
  Application.Run;
end.
