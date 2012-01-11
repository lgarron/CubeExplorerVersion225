unit Options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,CubeDefs;

type
//++++++++++++++++++++Form for Options/Two-Phase-Algorithm++++++++++++++++++++++
  TOptionForm = class(TForm)
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    GroupBox2: TGroupBox;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    Button1: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure RBMaxMovesClick(Sender: TObject);
    procedure RBStopAtClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
var
  OptionForm: TOptionForm;

implementation

{$R *.DFM}

//++++++++++++++Hit OK-Button+++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TOptionForm.Button1Click(Sender: TObject);
begin
  OptionForm.Hide;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++Enter maximal maneuver length before displaying results++++++++++++
procedure TOptionForm.RBMaxMovesClick(Sender: TObject);
begin
  maxMoves:=(Sender as TRadioButton).Tag;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++Enter Stop Lenght++++++++++++++++++++++++++++++++++++++++++++++
procedure TOptionForm.RBStopAtClick(Sender: TObject);
begin
   stopAt:=(Sender as TRadioButton).Tag;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++Check Triple Search Checkbox+++++++++++++++++++++++++++++++++++
procedure TOptionForm.CheckBox1Click(Sender: TObject);
begin
  useTriple:=CheckBox1.Checked;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TOptionForm.FormCreate(Sender: TObject);
begin
{$IF QTM}
RadioButton5.Checked:=true;//24 moves stop length default
{$ELSE}
RadioButton2.Checked:=true;//21 moves stop length default
{$IFEND}
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.
