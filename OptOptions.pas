unit OptOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
//+++++++++++++Delphi Form for the Huge Optimal Solver++++++++++++++++++++++++++
  TOptOptionForm = class(TForm)
    Button1: TButton;
    CheckUseHuge: TCheckBox;
    Panel1: TPanel;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckUseHugeClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

var
  OptOptionForm: TOptOptionForm;

implementation

uses CordCube, CubeDefs, RubikMain;

{$R *.DFM}

//+++++++++++++++++++++++++++++Click OK on Form+++++++++++++++++++++++++++++++++
procedure TOptOptionForm.Button1Click(Sender: TObject);
begin
  if (CheckUseHuge.Checked=true) and(Length(PruningBigP)<705886618) then
  begin
    OptOptionForm.Hide;
    Form1.HugeSolver.Enabled:=false;

    makesTables:=true;//for TForm1.OnCloseQuery
    Form1.RunPatButton.Enabled:=false;
    Form1.ButtonAddSolve.Enabled:=false;
    Form1.ButtonAddGen.Enabled:=false;
    Form1.ProgressLabel.Visible:=true;
    Form1.Progressbar.Visible:=true;
    CreateFlipConjugateTable;
    CreateBigPruningTable;
    Form1.ProgressLabel.Visible:=false;
    Form1.Progressbar.Visible:=false;
    Form1.ButtonAddSolve.Enabled:=true;
    Form1.ButtonAddGen.Enabled:=true;
    Form1.RunPatButton.Enabled:=true;
    makesTables:=false;
    Form1.HugeSolver.Enabled:=true;
    Exit;
  end;
  if CheckUseHuge.Checked=false then USES_BIG:=false else USES_BIG:=true;
  OptOptionForm.Hide;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TOptOptionForm.FormCreate(Sender: TObject);
begin
  Label1.Caption:=
   #13+'To use the Huge Optimal Solver you need:'+#13+#13+
       'At least 1GB of RAM.'+#13+
       'Room for a 673 MB table in your Cube Explorer directory.'+#13+
       'An empty Main Window.'+#13+#13+
       'It is a good idea to run the Huge Optimal Solver only with'+#13+
       'a fresh (rebooted) system, else even with 1GB of RAM'+#13+
                  'extensive file swapping could occur.'+#13+#13+
       'The Huge Optimal Solver runs about 5x faster compared'+#13+
       'with the (already fast) Standard Optimal Solver.'
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++Click CheckBox on Form+++++++++++++++++++++++++++++++++++++++
procedure TOptOptionForm.CheckUseHugeClick(Sender: TObject);
begin
  If CheckUseHuge.Checked=true then USES_BIG:=true
  else USES_BIG:=false
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.
