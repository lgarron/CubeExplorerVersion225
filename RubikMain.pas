unit RubikMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,  FaceCube, ComCtrls, ExtCtrls,CubeDefs, Buttons,syncobjs, Menus,
  hh,hh_funcs,Printers,
  {$IFDEF VER140}
  D6OnHelpFix,
{$EndIf}
CubiCube,CordCube, Spin;

const
    WM_NEXTSEARCH=WM_APP+1111;
    WM_NEXTLEVEL=WM_APP+1112;
    WM_CREATETABLES=WM_APP+1113;

type
  TForm1 = class(TForm)
    PageCtrl: TPageControl;
    TabSheet1: TTabSheet;
    ButtonU: TButton;
    ButtonR: TButton;
    ButtonF: TButton;
    ButtonD: TButton;
    ButtonL: TButton;
    ButtonB: TButton;
    FacePaint: TPaintBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ButtonEmpty: TButton;
    ButtonClear: TButton;
    ButtonRandom: TButton;
    ButtonCustomize: TButton;
    GroupBox3: TGroupBox;
    ButtonAddSolve: TButton;
    ButtonAddGen: TButton;
    Bevel1: TBevel;
    ColorDialog: TColorDialog;
    LSelColor: TLabel;
    CheckBoxA1: TCheckBox;
    CheckBoxF1: TCheckBox;
    CheckBoxR1: TCheckBox;
    CheckBoxU1: TCheckBox;
    CheckBoxD1: TCheckBox;
    CheckBoxL1: TCheckBox;
    CheckBoxB1: TCheckBox;
    CheckBoxA2: TCheckBox;
    CheckBoxU2: TCheckBox;
    CheckBoxD2: TCheckBox;
    CheckBoxR2: TCheckBox;
    CheckBoxL2: TCheckBox;
    CheckBoxF2: TCheckBox;
    CheckBoxB2: TCheckBox;
    CheckBoxA3: TCheckBox;
    CheckBoxU3: TCheckBox;
    CheckBoxD3: TCheckBox;
    CheckBoxR3: TCheckBox;
    CheckBoxL3: TCheckBox;
    CheckBoxF3: TCheckBox;
    CheckBoxB3: TCheckBox;
    CheckBoxA4: TCheckBox;
    CheckBoxU4: TCheckBox;
    CheckBoxD4: TCheckBox;
    CheckBoxR4: TCheckBox;
    CheckBoxL4: TCheckBox;
    CheckBoxF4: TCheckBox;
    CheckBoxB4: TCheckBox;
    CheckBoxA5: TCheckBox;
    CheckBoxU5: TCheckBox;
    CheckBoxD5: TCheckBox;
    CheckBoxR5: TCheckBox;
    CheckBoxL5: TCheckBox;
    CheckBoxF5: TCheckBox;
    CheckBoxB5: TCheckBox;
    PatBox1: TGroupBox;
    PatBox2: TGroupBox;
    PatBox3: TGroupBox;
    PatBox4: TGroupBox;
    PatBox5: TGroupBox;
    CheckBoxContinuous: TCheckBox;
    SbVert: TScrollBar;
    SbHor: TScrollBar;
    Panel1: TPanel;
    OutPut: TPaintBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Options1: TMenuItem;
    Help1: TMenuItem;
    LoadWorkspace1: TMenuItem;
    SaveWorkspace1: TMenuItem;
    N2: TMenuItem;
    PrinterSetup1: TMenuItem;
    PrintMainWindow: TMenuItem;
    N3: TMenuItem;
    Exit1: TMenuItem;
    TwoPhaseAlgorithm1: TMenuItem;
    Contents1: TMenuItem;
    N4: TMenuItem;
    About1: TMenuItem;
    SDWorkSpace: TSaveDialog;
    ODWorkspace: TOpenDialog;
    ProgressBar: TProgressBar;
    ProgressLabel: TLabel;
    PopupMenu1: TPopupMenu;
    DeleteselectedCubes1: TMenuItem;
    CubePopupMenu: TPopupMenu;
    N1: TMenuItem;
    ClearMainWindow1: TMenuItem;
    rotUD: TMenuItem;
    RotURF: TMenuItem;
    RefRL: TMenuItem;
    N5: TMenuItem;
    RemoveCube1: TMenuItem;
    N6: TMenuItem;
    TransferCubetoFaceletEditor1: TMenuItem;
    RotFB: TMenuItem;
    Bevel2: TBevel;
    GroupBox4: TGroupBox;
    PatShape1: TShape;
    PatShape2: TShape;
    PatShape3: TShape;
    PatShape4: TShape;
    PatShape5: TShape;
    PatShape6: TShape;
    CurShape: TShape;
    Label1: TLabel;
    PatClear: TButton;
    RunPatButton: TButton;
    PrinterSetupDialog: TPrinterSetupDialog;
    FindGenerators: TCheckBox;
    PrintSelectedCubes: TMenuItem;
    Invert1: TMenuItem;
    Edit1: TMenuItem;
    DeleteselectedCubes2: TMenuItem;
    N7: TMenuItem;
    ClearMainWindow2: TMenuItem;
    GoalTab: TTabSheet;
    GoalPaint: TPaintBox;
    goalcopy: TButton;
    ClearGoal: TButton;
    Bevel3: TBevel;
    TransferCubetoGoal1: TMenuItem;
    Label2: TLabel;
    SaveasHtml1: TMenuItem;
    SaveHtml: TSaveDialog;
    HugeSolver: TMenuItem;
    procedure FormCreate(Sender: TObject);

    procedure FacePaintPaint(Sender: TObject);
    procedure ButtonEmptyClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonCustomizeClick(Sender: TObject);
    procedure FacePaintMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FacePaintMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonRandomClick(Sender: TObject);
    procedure ButtonAddSolveClick(Sender: TObject);
    procedure OutputPaint(Sender: TObject);
    procedure SbVertScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure FormResize(Sender: TObject);
    procedure RunPatButtonClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure TwoPhaseAlgorithm1Click(Sender: TObject);
    procedure SaveWorkspace1Click(Sender: TObject);
    procedure LoadWorkspace1Click(Sender: TObject);
    procedure OutPutMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SbHorScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DeleteselectedCubes1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ClearMainWindow1Click(Sender: TObject);
    procedure RemoveCube1Click(Sender: TObject);
    procedure TransferCubetoFaceletEditor1Click(Sender: TObject);
    procedure rotUDClick(Sender: TObject);
    procedure RotURFClick(Sender: TObject);
    procedure RotFBClick(Sender: TObject);
    procedure RefRLClick(Sender: TObject);
    procedure CheckBoxOnClick(Sender: TObject);
    procedure CheckBoxAOnClick(Sender: TObject);
    procedure PatShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PatClearClick(Sender: TObject);
    procedure PrinterSetup1Click(Sender: TObject);
    procedure PrintMainWindowClick(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure InvertClick(Sender: TObject);
    procedure GoalPaintClick(Sender: TObject);
    procedure ClearGoalClick(Sender: TObject);
    procedure goalcopyClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure TransferCubetoGoal1Click(Sender: TObject);
    procedure SaveasHtml1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure HugeSolverClick(Sender: TObject);
//    procedure Button1Click(Sender: TObject);
    procedure ButtonXClick(Sender: TObject);
    procedure ButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    { Private declarations }
  private

  procedure DoNextSearch(var Message: TMessage); message WM_NEXTSEARCH;
  procedure ShowNextLevel(var Message: TMessage); message WM_NEXTLEVEL;
  procedure CreateTables(var Message: TMessage); message WM_CREATETABLES;


  procedure PatSearchTerminate(Sender: TObject);


  public
  BmRun,BmStop: TBitmap;
  lowOLd,highOld:Integer;
  dirty:Boolean;
  curFileName:String;

  procedure AddCube(f:FaceletCube;isSolver,startSearch,askIsomorphics:Boolean);
  procedure ButClick(Sender: TObject);
  procedure ButSolveClick(Sender: TObject);
  procedure OptBoxClick(Sender: TObject);
  procedure EdNameChange(Sender: TObject);
  procedure SquareMouseDown(Sender: TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
  procedure SetUpProgressBar(min,max:Integer;lab:String);
  procedure DeleteSelectedCubes;
  end;


const MAXNUM=15;//maximal number of cubes on visible part of Main Window
      CSIZE=4;//size of cube unit in output window
      UBORD=8;//offset from top
      LBORD=5;//left offset of cubes in main window
      EDMAXLENGTH=30;//maximal length of name for pattern
      HORSIZE=650;//horizontal size of output window

var
  Form1: TForm1;
  fCube: FaceletCube;
  goalCube: FaceletCube;
  curCol:ColorIndex;
  curPatCol:Integer;
  fc: Array of FaceletCube;//for the cubes in the Main Window
  fcN: Integer;//Highest Index for the fcubes used
  xOffset,yOffset: Integer;//offset of the scrollwindow
  h: Integer;//Height of Output-Window
  ButRun,ButSolve: array[0..MAXNUM] of TSpeedButton;
  EdName: array[0..MAXNUM] of TEdit;
  OptBox: array[0..MAXNUM] of TCheckBox;
  CheckBox: array[U..B,1..5] of TCheckBox;
  ACheckBox:array[1..5] of TCheckBox;
  Square: array[1..5,1..9] of TShape;
  PatSelector : array[1..6] of TShape;
  lastSelected: Integer;//index of last selected Cube
  makesTables: Boolean;//during table generation
  var mHHelp: THookHelpSystem;//for html help
  buf: TBitmap;

implementation

uses Math,Symmetries,Search,OptSearch,TripSearch, About,
  Options,PatternSearch, OptOptions;
var  ps:PatSearch;usedRightButton:Boolean;


{$R *.DFM}

//++++++++++++++++++++++++++Initialize the Form+++++++++++++++++++++++++++++++++
procedure TForm1.FormCreate(Sender: TObject);
var fs: TFileStream; i,j: Integer;prnt:TWinControl;
const filename = 'colors.cust';
begin
    Application.ShowHint:=true;
    Application.Title := curVersion;
    Application.HintHidePause:=30000;//show hint max. 30 seconds
    PostMessage(Handle,WM_CreateTables,0,0);//build the tables

   buf:=TBitmap.Create;//double buffer the Output
   Output.ControlStyle:=Output.ControlStyle+[csOpaque];//prevent flicker
   usedRightButton:=false;

   fcube := FaceletCube.Create(FacePaint.Canvas);
   goalcube:= FaceletCube.Create(GoalPaint.Canvas);
   mHHelp := THookHelpSystem.Create('cube.chm', '', htHHAPI);
   curCol:=UCol;
   Screen.Cursors[1]:=LoadCursor(HInstance,'Eimer');//cursor for filling
   Screen.Cursors[2]:=LoadCursor(HInstance,'Pipette');//cursor for colorpicking
   FacePaint.Cursor:=1;
   LSelColor.Cursor:=1;
   Randomize;
  if FileExists(filename) then//load custom color scheme if it exists
  begin
    fs := TFileStream.Create(filename, fmOpenRead);
    fs.ReadBuffer(Cubedefs.Color[UCol],7*SizeOf(Cubedefs.Color[UCol]));
    fs.Free;
  end
  else
  begin
    Cubedefs.Color[UCol]:=clBlue;
    Cubedefs.Color[RCol]:=clYellow;
    Cubedefs.Color[FCol]:=clRed;
    Cubedefs.Color[DCol]:=clGreen;
    Cubedefs.Color[LCol]:=clWhite;
    Cubedefs.Color[BCol]:=RGB(255,128,0);//orange
    Cubedefs.Color[NoCol]:=clGray;
  end;
  SetLength(fc,10);fcN:=0;xOffset:=0;yOffset:=0;lowOld:=-1;highOld:=-1;

  BMRun:=TBitmap.Create;
  BMRun.LoadFromResourceName(HInstance,'Run');//load green run bitmap
  BMStop:=TBitmap.Create;
  BMStop.LoadFromResourceName(HInstance,'Stop');//load red stop bitmap
  for i:= 0 to MAXNUM do//create the dynamic objects in the main window
  begin
    ButRun[i]:=TSpeedButton.Create(Form1);
    ButRun[i].Visible:=false;
    ButRun[i].Parent:=Panel1;
    ButRun[i].Width:=23;
    ButRun[i].Height:=22;
    ButRun[i].Caption:='';
    ButRun[i].Flat:=True;
    ButRun[i].Left:=410;
    ButRun[i].OnClick:= ButClick;

    ButSolve[i]:=TSpeedButton.Create(Form1);
    ButSolve[i].Visible:=false;
    ButSolve[i].Parent:=Panel1;
    ButSolve[i].Width:=58;
    ButSolve[i].Height:=22;
    ButSolve[i].Flat:=True;
    ButSolve[i].Left:=220;
    ButSolve[i].OnClick:= ButSolveClick;

    EdName[i]:=TEdit.Create(Form1);
    EdName[i].Parent:=Panel1;
    EdName[i].Width:=150;
    EdName[i].Left:=180;
    EdName[i].Visible:=false;
    EdName[i].MaxLength:=EDMAXLENGTH;
    EdName[i].OnChange:=EdNameChange;

    OptBox[i]:=TCheckBox.Create(Form1);
    OptBox[i].Parent:=Panel1;
    OptBox[i].Width:=60;
    OptBox[i].Left:=350;
    OptBox[i].Visible:=false;
    OptBox[i].OnClick:= OptBoxClick;
    OptBox[i].Caption:='optimal';
  end;
  for i:= 1 to 5 do//create the objects in the pattern-editor
  begin
    prnt:=nil;
    case i of
    1: prnt:=PatBox1;
    2: prnt:=PatBox2;
    3: prnt:=PatBox3;
    4: prnt:=PatBox4;
    5: prnt:=PatBox5;
    end;
    for j:= 1 to 9 do
    begin
      Square[i,j]:= TShape.Create(Form1);
      Square[i,j].Width:=26;
      Square[i,j].Height:=26;
      Square[i,j].Brush.Color:=Cubedefs.Color[NoCol];
      Square[i,j].Tag:=6;//Nr 6 in palette
      Square[i,j].Parent:=prnt;
      Square[i,j].Left:=2+((j-1) mod 3)*25;
      Square[i,j].Top:=7+((j-1) div 3)*25;
      Square[i,j].Cursor:=1;
      Square[i,j].OnMouseDown:=SquareMouseDown;
    end;
  end;

  //initialize the checkboxes in the pattern editor
  CheckBox[U,1]:=CheckBoxU1;CheckBox[R,1]:=CheckBoxR1;CheckBox[F,1]:=CheckBoxF1;
  CheckBox[D,1]:=CheckBoxD1;CheckBox[L,1]:=CheckBoxL1;CheckBox[B,1]:=CheckBoxB1;
  CheckBox[U,2]:=CheckBoxU2;CheckBox[R,2]:=CheckBoxR2;CheckBox[F,2]:=CheckBoxF2;
  CheckBox[D,2]:=CheckBoxD2;CheckBox[L,2]:=CheckBoxL2;CheckBox[B,2]:=CheckBoxB2;
  CheckBox[U,3]:=CheckBoxU3;CheckBox[R,3]:=CheckBoxR3;CheckBox[F,3]:=CheckBoxF3;
  CheckBox[D,3]:=CheckBoxD3;CheckBox[L,3]:=CheckBoxL3;CheckBox[B,3]:=CheckBoxB3;
  CheckBox[U,4]:=CheckBoxU4;CheckBox[R,4]:=CheckBoxR4;CheckBox[F,4]:=CheckBoxF4;
  CheckBox[D,4]:=CheckBoxD4;CheckBox[L,4]:=CheckBoxL4;CheckBox[B,4]:=CheckBoxB4;
  CheckBox[U,5]:=CheckBoxU5;CheckBox[R,5]:=CheckBoxR5;CheckBox[F,5]:=CheckBoxF5;
  CheckBox[D,5]:=CheckBoxD5;CheckBox[L,5]:=CheckBoxL5;CheckBox[B,5]:=CheckBoxB5;
  ACheckBox[1]:=CheckBoxA1;ACheckBox[2]:=CheckBoxA2;ACheckBox[3]:=CheckBoxA3;
  ACheckBox[4]:=CheckBoxA4;ACheckBox[5]:=CheckBoxA5;

  PatShape1.Cursor:=2;PatShape2.Cursor:=2;PatShape3.Cursor:=2;
  PatShape4.Cursor:=2;PatShape5.Cursor:=2;PatShape6.Cursor:=2;
  PatSelector[1]:=PatShape1;PatSelector[2]:=PatShape2;PatSelector[3]:=PatShape3;
  PatSelector[4]:=PatShape4;PatSelector[5]:=PatShape5;PatSelector[6]:=PatShape6;
  {$IF not QTM}
  maxMoves:=21;//default Number of moves in Two-Phase-Algorithm before returning
  {$ELSE}
  maxMoves:=24;
  {$IFEND}
  stopAt:=20;
  lastSelected:=-1;
  makesTables:=false;
  dirty:=false;
  curFileName:='untitled.txt';//name of last loaded or save file
  Caption:=ExtractFileName(curFilename)+' - '+curVersion;
  checkIsomorphics:=true;//check for isomorphic cubes before adding to Main-Window
  curPatCol:=1;//current color in Pattern Editor
end;
//+++++++++++++++++++++++End initialize the Form++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++Draw the Facelet Editor++++++++++++++++++++++++++++++++
procedure TForm1.FacePaintPaint(Sender: TObject);
begin
  fCube.DrawCube(0,0);
  FacePaint.Canvas.Brush.Color:= CubeDefs.Color[curCol];
  FacePaint.Canvas.Rectangle(228,150,293,215);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++Reset to Empty++++++++++++++++++++++++++++++++++++++++
procedure TForm1.ButtonEmptyClick(Sender: TObject);
begin
  fcube.Empty;
  FacePaint.Invalidate;
end;
//++++++++++++++++++++++++Reset to Clean++++++++++++++++++++++++++++++++++++++++
procedure TForm1.ButtonClearClick(Sender: TObject);
begin
  fcube.Clean;//reset to clean
  FacePaint.Invalidate;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++Reset to Random+++++++++++++++++++++++++++++++++++
procedure TForm1.ButtonRandomClick(Sender: TObject);
var c: CubieCube;
begin
  repeat
    c:=CubieCube.Create(Random(40320-1),Random(2187-1),Random(479001600-1),Random(2048-1));
    if (c.CornParityEven and not c.EdgeParityEven) or
       (not c.CornParityEven and c.EdgeParityEven) then begin c.Free; c:=nil;end;
  until assigned(c);
  fCube.SetFacelets(c);
  FacePaint.Invalidate;
  c.Free;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++++Customize Selected Color+++++++++++++++++++++++++++++
procedure TForm1.ButtonCustomizeClick(Sender: TObject);
var fs: TFileStream;
const filename = 'colors.cust';//user defined colors are stored here
begin
 ColorDialog.Color:=Cubedefs.Color[curCol];
 if ColorDialog.Execute= true then
 begin
   Cubedefs.Color[curCol]:=ColorDialog.Color;
   FacePaint.Invalidate;Output.Invalidate;
   fs := TFileStream.Create(filename, fmCreate);
   fs.WriteBuffer(Cubedefs.Color[UCol],7*SizeOf(Cubedefs.Color[UCol]));
   fs.Free;
 end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++Change cursor according position on Cube in Pattern Editor+++++++++++
procedure TForm1.FacePaintMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var xr,yr,a,b: Real; s: Integer;
begin
  s:=fCube.size;
  if (x>3*s) and (x<6*s) and (y>9*s) and (y<12*s) then FacePaint.Cursor:=2
  else if (x>12*s) and (x<15*s) and (y>9*s) and (y<12*s) then FacePaint.Cursor:=2
  else if (x>27*s) and (x<30*s) and (y>3*s) and (y<6*s) then FacePaint.Cursor:=2
  else if (x>12*s) and (x<15*s) and (y>18*s) and (y<21*s) then FacePaint.Cursor:=2
  else
  begin
    xr:=x-16*s;
    yr:=y-2*s;
    b:=yr/2;a:=(xr+yr)/3;
    if (a>0) and (a<s)and (b>0) and (b<s) then FacePaint.Cursor:=2
    else
    begin
      xr:=x-20*s;
      yr:=y-7*s;
       b:=(xr+yr)/3;a:=xr/2;
      if (a>0) and (a<s)and (b>0) and (b<s) then FacePaint.Cursor:=2
      else  FacePaint.Cursor:=1;
    end
  end
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++Change the color of the facelets in the Facelet Editor+++++++++++
procedure TForm1.FacePaintMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
label ende,noChange;
var xr,yr,a,b: Real;fc: Face;
begin
  xr:=x/fCube.size-15;
  yr:=y/fCube.size;
  b:=yr/2;a:=(xr+yr)/3;
  if (a>0) and (a<3) and (b>0) and (b<3) then
  begin
    fc:=Face(3*Floor(b)+Floor(a)); //U-face facelet
    goto ende;
  end;
  xr:=x/fCube.size-18;
  yr:=y/fCube.size-6;
  b:=(xr+yr)/3;a:=xr/2;
  if (a>0) and (a<3) and (b>0) and (b<3) then
  begin
      fc:=Face(3*Floor(b)+Floor(a)+9); //R-face facelet
      goto ende;
  end;
  xr:=x/fCube.size;
  yr:=y/fCube.size-6;
  b:=yr/3;a:=xr/3;
  if (a>0) and (a<3) and (b>0) and (b<3) then
  begin
      fc:=Face(3*Floor(b)+Floor(a)+36);//L-face facelet
      goto ende;
  end;
  xr:=x/fCube.size-9;
  yr:=y/fCube.size-6;
  b:=yr/3;a:=xr/3;
  if (a>0) and (a<3) and (b>0) and (b<3) then
  begin
      fc:=Face(3*Floor(b)+Floor(a)+18);//F-face facelet
      goto ende;
  end;
  xr:=x/fCube.size-9;
  yr:=y/fCube.size-15;
  b:=yr/3;a:=xr/3;
  if (a>0) and (a<3) and (b>0) and (b<3) then
  begin
      fc:=Face(3*Floor(b)+Floor(a)+27);//D-face  facelet
      goto ende;
  end;
  xr:=x/fCube.size-24;
  yr:=y/fCube.size;
  b:=yr/3;a:=xr/3;
  if (a>0) and (a<3) and (b>0) and (b<3) then
  begin
      fc:=Face(3*Floor(b)+Floor(a)+45);//B-face
      goto ende;
  end;
  goto noChange;
ende:
  if (fc<>U5) and  (fc<>R5) and (fc<>F5) and (fc<>D5) and (fc<>L5) and (fc<>B5)then
  begin
    if Button=mbLeft then//set a color
    begin
      fCube.PFace^[fc]:= curCol;
      fCube.Check(fc);

      fCube.DrawCube(0,0);
      FacePaint.Invalidate;
    end
    else//clear a color
    begin
      fCube.PFace^[fc]:= noCol;
      fCube.DrawCube(0,0);
      FacePaint.Invalidate;
    end;
  end
  else curCol:= fCube.PFace^[fc];
  FacePaint.Invalidate;
noChange:
end;
//++++++++++End Change the color of the facelets in the Facelet Editor++++++++++


//+++++++++++++++++++++++++++++Add and Solve++++++++++++++++++++++++++++++++++++
procedure TForm1.ButtonAddSolveClick(Sender: TObject);
var isSolver:Boolean;i:Face;
begin
 for i:= U1 to B9 do
 if fCube.PFace^[i]=NoCol then
 begin
   Application.MessageBox(PChar(Err[13]),'Facelet Editor',MB_ICONWARNING);
   exit;
 end;
 if Sender=ButtonAddSolve then isSolver:=true
 else isSolver:=false;
 AddCube(fCube,isSolver,true,true);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++Add the Cube to the Main Window+++++++++++++++++++++++++++
procedure TForm1.AddCube(f: FaceletCube;isSolver,startSearch,askIsomorphics:Boolean);
//isSolver true: generate Solver
//startSearch true: Automatically start search after adding
//askIsomorphics true: Ask if adn isomorphic cube should be added
var hi,j:Integer;i:Face;
begin
 for i:=U1 to B9 do  f.goalFace[i]:= goalCube.PFace^[i];//usually the ID-cube
 if checkIsomorphics and askIsomorphics then
 for j:= 0 to fcN-1 do
   if f.IsIsomorphic(fc[j]) then
   if Application.MessageBox(PChar('Cube '+IntToStr(j+1)+' is isomorphic to the Cube you want to add. Proceed?'),'Maneuver Window',MB_ICONWARNING or MB_YESNO)
   <>IDYES then exit else break;

 if checkIsomorphics and not askIsomorphics then
 for j:= 0 to fcN-1 do
   if f.IsIsomorphic(fc[j]) then exit;
   fc[fcN]:= FaceletCube.Create(f,buf.Canvas,LBORD,fcN*CSIZE*27+UBORD,CSIZE);//buffering
 if startSearch then fc[fcN].running:=true else fc[fcN].running:=false;
 if isSolver then fc[fcN].solver:=true
 else fc[fcN].solver:=false;
 dirty:=true;
 Inc(fcN);
 h:=Max(Output.Height+yOffset,CSIZE*27*fcN+2*UBORD);
 SbVert.Position:= Round(yOffset/Max(1,(h-OutPut.Height))*SbVert.Max);
 if (h-OutPut.Height>0)then
   begin
   SbVert.SmallChange:=Min(32767,Round(27.0*CSIZE*SbVert.Max/(h-OutPut.Height)/10));
   SbVert.LargeChange:= Min(32767,Round(0.95*Output.Height*SbVert.Max/(h-OutPut.Height)));
 end
 else begin SbVert.SmallChange:=1; SbVert.LargeChange:=1;end;
 hi:=High(fc);
 if fcN>High(fc) then SetLength(fc,hi+10);
 Output.Invalidate;
 for i:=U1 to B9 do  fc[fcN-1].goalFace[i]:= goalCube.PFace^[i];
 if not goalCube.goalIsId then fc[fcN-1].displayGoal:=true;
 if startSearch then
 begin
   for i:=U1 to B9 do //need a copy if we want to restore
   fc[fcN-1].faceOrig[i]:= f.PFace^[i];
   fc[fcN-1].tripSearch:=TripleSearch.Create(fc[fcN-1]);
   (fc[fcN-1].tripSearch as TripleSearch).NextSolution;
 end;
end;
//++++++++++++++++++End Add the Cube to the Main Window+++++++++++++++++++++++++

//++++++++++++++++++++++++++Paint the Main Windows++++++++++++++++++++++++++++++
procedure TForm1.OutputPaint(Sender: TObject);
var i,low,high,diff,outX,outy: Integer;s:String;
begin
  outX:=Output.ClientWidth;//write on Tbitmap buf and copy to Output
  outY:=Output.ClientHeight;
  buf.Width:=outX;
  buf.Height:=outY;
  buf.Canvas.FillRect(Rect(0,0,outX,outY));
  if fcN=0 then
  begin
    for i:= 0 to MAXNUM do
    begin
      ButRun[i].visible:=false;
      ButSolve[i].visible:=false;
      EdName[i].visible:=false;
      OptBox[i].visible:=false;
    end;
    Output.Canvas.CopyRect(Rect(0,0,outX,outY),buf.Canvas,Rect(0,0,outX,outY));
    exit;
  end;
  low:=Min(Max((yOffset-UBORD) div (27*CSIZE),0),fcN-1);
  high:=Min(Max((yOffset-UBORD+buf.Height) div (27*CSIZE),0),fcN-1);

  for i:=low to high do
  begin
    fc[i].DrawCube(xOffset,yOffset);
    buf.Canvas.Brush.Color:=clWindow;
    buf.Canvas.TextOut(3-xOffset,i*CSIZE*27+UBORD-yOffset,IntToStr(i+1)+'.');
    if not fc[i].displayGoal then
    buf.Canvas.TextOut(103-xOffset,i*CSIZE*27+UBORD-yOffset+60,'Pattern Name:');

    if fc[i].selected then
    with buf.Canvas do
    begin
      MoveTo(-xOffset+LBORD-2,i*CSIZE*27+UBORD-yOffset-2);
      LineTo(-xOffset+33*CSIZE+LBORD+2,i*CSIZE*27+UBORD-yOffset-2);
      LineTo(-xOffset+33*CSIZE+LBORD+2,i*CSIZE*27+CSIZE*24+UBORD-yOffset+2);
      LineTo(-xOffset+LBORD-2,i*CSIZE*27+CSIZE*24+UBORD-yOffset+2);
      LineTo(-xOffset+LBORD-2,i*CSIZE*27+UBORD-yOffset-2);
    end;

    if fc[i].runOptimal then
    begin
      if fc[i].solver  or fc[i].displayGoal then s:=fc[i].optManeuver else s:=fc[i].InverseOptManeuver;
      if fc[i].displayGoal then
        buf.Canvas.TextOut(310-xOffset,i*CSIZE*27+UBORD-yOffset+24,s)
      else
        buf.Canvas.TextOut(160-xOffset,i*CSIZE*27+UBORD-yOffset+24,s)
    end
    else
    begin
      if fc[i].solver or fc[i].displayGoal then s:=fc[i].maneuver else s:=fc[i].InverseManeuver;
      if fc[i].displayGoal then
        buf.Canvas.TextOut(310-xOffset,i*CSIZE*27+UBORD-yOffset+24,s)
      else
        buf.Canvas.TextOut(160-xOffset,i*CSIZE*27+UBORD-yOffset+24,s)
    end;
    diff:=i-low;
    ButRun[diff].Top:= i*CSIZE*27+UBORD+60-yOffset-2;
    ButRun[diff].Visible:=true;
    ButRun[diff].Tag:=i;
    ButRun[diff].Left:=410-xOffset;

    ButSolve[diff].Top:= i*CSIZE*27+UBORD-yOffset;
    ButSolve[diff].Tag:=i;
    ButSolve[diff].Left:=220-xOffset;

    EdName[diff].Top:= i*CSIZE*27+UBORD+60-yOffset;
    EdName[diff].Tag:=i;
    EdName[diff].Text:=fc[i].patName;
    EdName[diff].Left:=180-xOffset;

    if fc[i].displayGoal then
    begin
      ButSolve[diff].Visible:=false;
      EdName[diff].Visible:=false
    end else
    begin
      ButSolve[diff].Visible:=true;
      EdName[diff].Visible:=true;
    end;

    OptBox[diff].Top:= i*CSIZE*27+UBORD+60-yOffset;
    OptBox[diff].Visible:=true;
    OptBox[diff].Tag:=i;
    OptBox[diff].Checked:=fc[i].runOptimal;
    OptBox[diff].Left:=350-xOffset;
    If fc[i].runOptimal then
    begin
      OptBox[diff].ShowHint:=true;
      OptBox[diff].Hint:=fc[i].hintInfo;
    end
    else OptBox[diff].ShowHint:=false;

   if (lowOld<>low) or (highOld<>high) then
   begin
   if fc[i].running then ButRun[diff].Glyph:=BMStop
      else
      ButRun[diff].Glyph:=BMRun;

   end;
    if fc[i].solver then ButSolve[i-low].Caption:= 'Solver:'
      else ButSolve[diff].Caption:= 'Generator:'
  end;
  lowOld:=low;highOld:=high;

  for i:= high-low+1 to MAXNUM do
  begin
    ButRun[i].Visible:=false;
    ButRun[i].Tag:=-1;
    ButSolve[i].Visible:=false;
    EdName[i].Visible:=false;
    OptBox[i].Visible:=false;
  end;
  Output.Canvas.CopyRect(Rect(0,0,outX,outY),buf.Canvas,Rect(0,0,outX,outY));
end;
//++++++++++++++++++++++End Paint the Main Windows++++++++++++++++++++++++++++++

//++++++++++++++++Scroll Main Window horizontally+++++++++++++++++++++++++++++++
procedure TForm1.SbHorScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
var hdiff:Integer;
begin
  hdiff:=HORSIZE-Output.Width;
  if hdiff>0 then
  begin
    xOffset:= Round(SbHor.Position/SbHor.Max*(HORSIZE-Output.Width));
    Output.Invalidate;
  end
   else begin xOffset:=0;SbHor.Position:=0;end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++Scroll Main Window vertically++++++++++++++++++++++++++++
procedure TForm1.SbVertScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
var hdiff:Integer;
begin
  hdiff:=h-Output.Height;
  if hdiff>0 then
  begin
    yOffset:= Round(SbVert.Position/SbVert.Max*(h-Output.Height));
    Output.Invalidate;
    SbHor.Invalidate;//some strange effects else
  end
   else begin yOffset:=0;SbVert.Position:=0;end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++++++Resize Main Form+++++++++++++++++++++++++++++++++++
procedure TForm1.FormResize(Sender: TObject);
begin
  SbVert.Left:=PageCtrl.Left-17;
  SbVert.Top:= PageCtrl.Top;
  SbVert.Height:=ClientHeight-17;
  SbHor.Left:=0;
  SbHor.Top:= ClientHeight-17;
  SbHor.Width:=PageCtrl.Left-17;
  Panel1.Left:=0;
  Panel1.Top:=SbVert.Top;;
  Panel1.Height:=ClientHeight-17;
  Panel1.Width:=SbHor.Width;
  OutPut.Height:=Panel1.Height-1;

  h:=Max(Output.Height+yOffset,CSIZE*27*fcN+2*UBORD);
  SbVert.Position:= Round(yOffset/Max(1,(h-OutPut.Height))*SbVert.Max);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++Handler for clicking on Run Button im Main Window++++++++++++++++
procedure TForm1.ButClick(Sender: TObject);
var i:Face;
begin
 with Sender as TSpeedbutton do
 begin
   if fc[TSpeedButton(Sender).Tag].running then
   begin
     if fc[Tag].runOptimal then OptimalSearch(fc[Tag].optSearch).Kill
     else TripleSearch(fc[Tag].tripSearch).Kill;
     Glyph:=BMRun;
   end
   else
   begin
     if (fc[Tag].runOptimal)
        and (Pos('*',fc[Tag].optManeuver)<>0) then//Maneuver already is optimal
          if Application.MessageBox(PChar(Err[4]),'Maneuver Window',MB_YESNO)=IDNO then exit;
     if fc[Tag].runOptimal then
     begin
       if (fc[Tag].optSearch=nil) then
       begin
         fc[Tag].optSearch:=OptimalSearch.Create(fc[Tag]);
         fc[Tag].optStartTime:=Now;
       end;
       (fc[Tag].optSearch as OptimalSearch).NextSolution
     end
     else
     begin
       if (fc[Tag].tripSearch=nil) then
       begin
         for i:=U1 to B9 do fc[Tag].faceOrig[i]:= fc[Tag].PFace^[i];
         fc[Tag].tripSearch:=TripleSearch.Create(fc[Tag]);
       end;
       if (fc[Tag].tripSearch as TripleSearch).length=-1 then //no better solution
       begin
         Application.MessageBox(PChar(Err[5]),'Maneuver Window',MB_ICONWARNING);
         exit;
       end
       else
        (fc[Tag].tripSearch as TripleSearch).NextSolution;
     end;
     fc[Tag].running:=true;
     Glyph:=BMStop;
   end;
 end;
end;
//+++++++++++End Handler for clicking on Run Button im Main Window++++++++++++++

//+++++++++++++++++++++Toggle between Solver and Generator++++++++++++++++++++++
procedure TForm1.ButSolveClick(Sender: TObject);
begin
 with Sender as TSpeedButton do
 begin
   if fc[Tag].solver=true then fc[Tag].solver:=false
   else fc[Tag].solver:=true;
   Output.Invalidate;
 end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++Edit the patternname++++++++++++++++++++++++++++++++
procedure TForm1.EdnameChange(Sender: TObject);
begin
  with Sender as TEdit do fc[Tag].patName:=Text;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++Find next Two-Phase-Solution++++++++++++++++++++++++++++
procedure TForm1.DoNextSearch(var Message: TMessage);
begin
  TripleSearch(Message.LParam).NextSolution;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++Start Search in the Pattern Editor++++++++++++++++++++++++
procedure TForm1.RunPatButtonClick(Sender: TObject);
var i:TurnAxis;j:Integer;
begin
   if RunPatButton.Caption='Start Search' then
   begin
     RunPatButton.Caption:='Cancel Search';
     CheckBoxContinuous.Enabled:=false;
     PatClear.Enabled:=false;
     for i:= U to B do
     for j:= 1 to 5 do
       CheckBox[i,j].Enabled:=false;
     for j:= 1 to 5 do ACheckBox[j].Enabled:=false;

     ps:=PatSearch.Create(true);
     ps.FreeOnTerminate:=true;
     ps.OnTerminate:= PatSearchTerminate;
     ps.Resume;
   end
   else ps.Terminate;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++Click the Optimal Box in the Main Window++++++++++++++++++
procedure TForm1.OptBoxClick(Sender: TObject);
begin
   with Sender as TCheckBox do
   begin
     fc[Tag].runOptimal:=Checked;
     if not Checked and (fc[Tag].optSearch<>nil) then OptimalSearch(fc[Tag].optSearch).Kill
     else if checked and  (fc[Tag].tripSearch<>nil) then TripleSearch(fc[Tag].tripSearch).Kill;
     if not Checked and (Pos('*)',fc[Tag].optManeuver)>0) then
        begin Checked:=True; fc[Tag].runOptimal:=Checked;end;
  end;
  Output.Invalidate;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++Called when Optimal Solver enters next searching depth+++++++++++++++
procedure TForm1.ShowNextLevel(var Message: TMessage);
var ia:Ida;d,i,x1,x2:Integer; d1,s,ret:String;

tt:TDateTime;

begin
  ia:=Ida(Message.wParam);
  d:=Message.lParam;
  for i:=0 to fcN-1 do
  if fc[i].optSearch<>nil
  then
  if (OptimalSearch(fc[i].optSearch).idaU=ia)
     and (Pos('Status:',fc[i].optManeuver)<>0) and (d>8)
  then
  begin
    if d>99 then d1:= Format('depth %2.2d: ',[d-99])else  //solution found
      d1:= Format('depth %2.2d: ',[d-1]);
    if Pos(d1,fc[i].hintInfo)=0 then //prevent duplicates
    begin
      if fc[i].hintInfo='' then ret:='' else ret:=Chr(13);
      tt:=Now-fc[i].optStartTime;
      fc[i].hintInfo:=fc[i].hintInfo+ret+ d1+Format('%3.2f min ',[tt*24*60])
                 +' nodes: ' + IntToStr(ia.nodeCount);
    end;
    if d>99 then exit;

    s:= fc[i].maneuver;
    x1:=Pos('(',s);//extract maneuver length
    x2:=Pos(')',s);
    if (x1<>0) and (x2<>0) then
    begin
      if  (Pos('q)',s)<>0) or (Pos('f)',s)<>0) then
        d1:=Copy(s,x1+1,x2-x1-2)//-2 because of q/f
      else
        d1:=Copy(s,x1+1,x2-x1-1);//compatibility to version<=2.21
      if StrToInt(d1)<=d then    //use 2 phase solution if shorter
      begin
        Insert('*',s,Length(s));
        fc[i].optManeuver:=s;
        OptimalSearch(fc[i].optSearch).Kill;
        exit;
      end
    end;

    fc[i].optManeuver:='Status: Searching depth ' + IntToStr(d) + '...';
    Output.Invalidate;
  end;//if
end;
//+++++++++End Called when Optimal Solver enters next searching depth+++++++++++

//++++++++++++++++Click on About Menu Item++++++++++++++++++++++++++++++++++++++
procedure TForm1.About1Click(Sender: TObject);
begin
  AboutForm.Show;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++Click on Two-Phase Algorithm Options+++++++++++++++++++++++++++++++
procedure TForm1.TwoPhaseAlgorithm1Click(Sender: TObject);
begin
  OptionForm.Show;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++Click on Save Maneuvers++++++++++++++++++++++++++++++++
procedure TForm1.SaveWorkspace1Click(Sender: TObject);
var i:Integer; fs: TFileStream; s,delim:String;
begin
  if curFileName<>'' then SDWorkSpace.FileName:=curFileName;
  if SDWorkspace.Execute= true then
  begin
    fs := TFileStream.Create(SDWorkSpace.FileName, fmCreate);
    curFileName:= SDWorkSpace.FileName;
    for i:= 0 to fcN-1 do
    begin
      with fc[i] do
      begin
        if (Length(optManeuver)>0) and (Pos('Status',optManeuver)=0) then
        begin
          if Length(patName)>0 then delim:='   //' else delim:=' ';
          s:=InverseOptManeuver+delim+patName+''#13#10'';
          fs.WriteBuffer(PChar(s)^,Length(s));
        end
        else
        if (Length(maneuver)>0) then
        begin
          if Length(patName)>0 then delim:='   //' else delim:=' ';
          s:=InverseManeuver+delim+patName+''#13#10'';
          fs.WriteBuffer(PChar(s)^,Length(s));
        end;
      end
    end;
    fs.Free;
  end;
  dirty:=false;
  Caption:=ExtractFileName(curFilename)+' - '+curVersion;
end;
//++++++++++++++++++++End click on Save Maneuvers+++++++++++++++++++++++++++++++

//++++++++++++++++++++Click on Load Maneuvers++++++++++++++++++++++++++++++++++
procedure TForm1.LoadWorkspace1Click(Sender: TObject);
var i,j,n,ret,bufsize:Integer; fs: TFileStream; buf,cubeMan: String;
    f:FaceletCube;
label load;
begin
  if curFileName<>'' then ODWorkSpace.FileName:=curFileName;
  if ODWorkspace.Execute= true then//Load File Dialog executed
  begin
    fs := TFileStream.Create(ODWorkSpace.FileName, fmOpenRead);
    curFileName:= ODWorkSpace.FileName;
    if fcN>0 then//at least one cube in Main Window
    begin
      ret:=Application.MessageBox(PChar(Err[12]),'',MB_ICONWARNING or MB_YESNOCANCEL);
      if ret=IDCANCEL then begin fs.free; exit; end;
      if ret = IDNO then goto load;
    end;

    for i:=0 to fcN-1 do
    with fc[i] do
    begin
      if (Length(maneuver)=0) and (Length(optManeuver)=0) then
      begin
        if Application.MessageBox(PChar(Err[6]),'Maneuver Window',MB_ICONWARNING or MB_YESNO)
         <>IDYES then begin fs.free;exit;end;
      end;
    end;
    for i:=0 to fcN-1 do
    with fc[i] do
    begin
      if optSearch<>nil then (optSearch as OptimalSearch).Kill;
      if tripSearch<>nil then (tripSearch as TripleSearch).Kill;
    end;
    for j:= 0 to 1000 do //app might crash if we free before killing thread
      Application.ProcessMessages;//allow the notify procedures to work
    for i:=0 to fcN-1 do
    with fc[i] do
    begin
      if optSearch<>nil then (optSearch as OptimalSearch).idaU.Free;
      if tripSearch<>nil then
      begin
        (tripSearch as TripleSearch).idaU.Free;
        (tripSearch as TripleSearch).idaR.Free;
        (tripSearch as TripleSearch).idaF.Free;
      end;
    end;
    for i:= 0 to fcN-1 do fc[i].Free;
    fcN:=0;
    lowOld:=-1;
    lastSelected:=-1;
    dirty:=false;
    Caption:=ExtractFileName(curFilename)+' - '+curVersion;
    for i:= 0 to MAXNUM do
    begin
      ButRun[i].Visible:=false;
      ButRun[i].Tag:=-1;
      ButSolve[i].Visible:=false;
      EdName[i].Visible:=false;
      OptBox[i].Visible:=false;
    end;
    OutPut.Invalidate;
load:
    ClearGoalClick(nil);
    bufSize:= fs.Size;
    SetLength(buf,bufSize);
    for i:= 1 to bufSize do
      fs.ReadBuffer(buf[i],1);
    fs.Free;
    repeat
      n:=Pos(#13#10,buf);
      if n=0 then cubeMan:=buf
      else
      begin
        cubeMan:= Copy(buf,0,n-1);
        buf:= Copy(buf,n+2,Length(buf));
      end;
      f:=FaceletCube.Create(cubeMan,Output.Canvas);
      AddCube(f,false,false,false);
      Output.Invalidate;
      f.Free;
    until Pos(#13#10,buf)=0;
  end;
end;
//+++++++++++++++++++++End Click on Load Maneuvers++++++++++++++++++++++++++++++


//++++++++++++++++++Create the Move and Pruning Tables++++++++++++++++++++++++++
procedure TForm1.CreateTables(var Message: TMessage);
var mem:MemoryStatus;msize:LongWord;
begin
  Application.ProcessMessages;//to paint the Main Window
  if not FileExists('RawFlipSlice') then
  begin
    if Application.MessageBox(PChar(Err[7]),'',MB_ICONWARNING or MB_YESNO)<>IDYES
    then
    begin
      SendMessage(Handle,WM_CLOSE,0,0);
      exit;
    end;
  end;

 {$IF QTM}
  If (DiskFree(0)<70000000) and (not FileExists('phase1PQ.prun')) then
 {$ELSE}
  If (DiskFree(0)<70000000) and (not FileExists('phase1PF.prun')) then
 {$IFEND}

  begin
    Application.MessageBox(PChar(Err[8]),'',MB_ICONSTOP);
    SendMessage(Handle,WM_CLOSE,0,0);
    exit;
  end;
  mem.dwLength:=SizeOf(MemoryStatus);
  GlobalMemoryStatus(mem);
  msize:=Round((mem.dwTotalPhys+598016)/(1024*1024));
  if msize<90 then
  begin
    Application.MessageBox(PChar(Err[15]+IntToStr(msize)+Err[16]),'',MB_ICONSTOP);
    SendMessage(Handle,WM_CLOSE,0,0);
    exit;
  end;
  makesTables:=true;
  RunPatButton.Enabled:=false;//disable parts of User-Interface
  ButtonAddSolve.Enabled:=false;
  ButtonAddGen.Enabled:=false;
  File1.Enabled:=false;
  ProgressLabel.Caption:='Loading...';
  Application.ProcessMessages;
  CreateSymmetryTables;
  CreateGetPackedTable;

  CreateClassIndexToRepresentantTables;
  CreateMoveTables;
  CreateConjugateTables;
  CreatePruningTables;

  CreateGetPruningLengthTable;
  CreateGetEdge8PermTable;
  Form1.ProgressBar.Position:=0;
  Form1.ProgressBar.Visible:= false;
  Form1.ProgressLabel.Visible:=false;
  ButtonAddSolve.Enabled:=true;
  ButtonAddGen.Enabled:=true;
  File1.Enabled:=true;
  HugeSolver.Enabled:=true;
  RunPatButton.Enabled:=true;
  makesTables:=false;
  USES_BIG:=false;//small optimal solver by default
  Application.ProcessMessages;
end;
//++++++++++++++End Create the Move and Pruning Tables++++++++++++++++++++++++++



//+++++++++++Initialize the Progress Bar for Table Generation+++++++++++++++++++
procedure TForm1.SetUpProgressBar(min, max: Integer; lab: String);
begin
  ProgressBar.Min:=min;
  ProgressBar.Max:=max;
  ProgressBar.Position:=Min;
  ProgressLabel.Caption:=lab;
  ProgressLabel.Update;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//+++++++++++++++Handle Mouseclicks in the Main Window++++++++++++++++++++++++++
procedure TForm1.OutPutMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,j: Integer; PopupPos: TPoint;en:Boolean;
begin
   PopupPos.x:=x; PopupPos.y:=y;
   i:=(y+yOffset-UBORD) div (27*CSIZE);//index of cube eventually clicked on
   if ((y+yOffset-UBORD) mod (27*CSIZE) > 24*CSIZE)
   or ((x+xOffset<LBORD) or (x+xOffset>LBORD+33*CSIZE) or (i>fcN-1))then
   begin//click outside of a cube in the Main Window
     if Button=mbLeft then
     begin
       for j:=0 to fcN-1 do fc[j].selected:= false;
       lastSelected:=-1;
       OutPut.Invalidate;
       DeleteSelectedCubes1.Enabled:=false;
       exit
     end;
   end;
   if (x+xOffset<LBORD) or (x+xOffset>LBORD+33*CSIZE) then exit;
   if (i>=0) and (i<fcN) then
   begin//click on cube in the Main Windows
     if Button=mbRight then
     begin
       CubePopUpMenu.Tag:=i;//save the choosen cube in tag property
       PopUpPos:=Output.ClientToScreen(PopupPos);
       if  fc[i].displayGoal then en:=false else en:=true;
       RotUD.Enabled:=en;
       RotURF.Enabled:=en;
       RotFB.Enabled:=en;
       RefRL.Enabled:=en;
       Invert1.Enabled:=en;
       CubePopUpMenu.Popup(PopupPos.x,PopupPos.y);
       exit;
     end;

     //implement some windows explorer like features to select or deselect cubes
     DeleteSelectedCubes1.Enabled:=true;
     if lastSelected=-1 then
     begin
       if fc[i].selected=true then fc[i].selected:=false
       else
       begin
         fc[i].selected:=true;
         lastSelected:=i;
       end;
       Output.Invalidate;
       exit;
     end;
     if (ssCtrl in Shift) and (ssShift in Shift) then
     begin
       for j:=lastSelected to i do fc[j].selected:=true;
       for j:=i to lastSelected do fc[j].selected:=true;
     end
     else
     if ssCtrl in Shift then
       if fc[i].selected then
       begin fc[i].selected:=false; lastSelected:=-1; end
       else begin fc[i].selected:=true; lastSelected:=i; end
     else
     if ssShift in Shift then
     begin
       for j:= 0 to fcN-1 do fc[j].selected:=false;
       for j:=lastSelected to i do fc[j].selected:=true;
       for j:=i to lastSelected do fc[j].selected:=true;
       lastSelected:=i;
     end
     else //just plain click
     begin
       for j:= 0 to fcN-1 do fc[j].selected:=false;
       fc[i].selected:=true; lastSelected:=i;
     end;
   end;
   Output.Invalidate;
end;
//+++++++++++End Handle Mouseclicks in the Main Window++++++++++++++++++++++++++

//+++++++++++++++Delete the selected cubes in the Main Window+++++++++++++++++++
procedure TForm1.DeleteSelectedCubes;
var i,j: Integer;
begin
for i:=0 to fcN-1 do
  with fc[i] do
  begin
    if fc[i].selected=false then continue;
    if optSearch<>nil then (optSearch as OptimalSearch).Kill;
    if tripSearch<>nil then (tripSearch as TripleSearch).Kill;
  end;
  for j:=0 to 1000 do //app might crash if we free before killing thread
    Application.ProcessMessages;//allow the notify procedures to work
  for i:=0 to fcN-1 do
  with fc[i] do
  begin
    if fc[i].selected=false then continue;
    if optSearch<>nil then (optSearch as OptimalSearch).idaU.Free;
    if tripSearch<>nil then
    begin
      (tripSearch as TripleSearch).idaU.Free;
      (tripSearch as TripleSearch).idaR.Free;
      (tripSearch as TripleSearch).idaF.Free;
    end;
  end;

  i:=0;
  while i<=fcN-1 do
  begin
    if fc[i].selected then
    begin
      fc[i].Free;
      for j:= i+1 to fcN-1 do begin fc[j-1]:=fc[j]; fc[j-1].y:=fc[j-1].y-27*CSIZE; end;
      fc[fcN-1]:=nil;
      Dec(fcN);
      lowOld:=-1;
      lastSelected:=-1;
      Dec(i);
    end;
    Inc(i);
  end;
  DeleteSelectedCubes1.Enabled:=false;
  if fcN=0 then begin
    dirty:=false;
    Caption:=ExtractFileName(curFilename)+' - '+curVersion;
    SbVert.Position:=0;
    yOffset:=0;
    end;

  FormResize(nil);

  Output.Invalidate;
end;
//+++++++++++End Delete the selected cubes in the Main Window+++++++++++++++++++

//+++++++++++Delete Key also deletes the selected Cubes+++++++++++++++++++++++++
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key=VK_DELETE then DeleteSelectedCubes;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++Delete selected cubes from popup menu+++++++++++++++++++++++++
procedure TForm1.DeleteselectedCubes1Click(Sender: TObject);
begin
  DeleteSelectedCubes;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++++++Clear the Main Window++++++++++++++++++++++++++++++
procedure TForm1.ClearMainWindow1Click(Sender: TObject);
var i,ret: Integer;
begin
  ret:=IDYES;
  if dirty then
   ret:=Application.MessageBox(PChar(Err[11]),'',MB_ICONWARNING or MB_YESNO);
  if ret=IDYES then
  begin
    for i:=0 to fcN-1 do fc[i].selected:=true;
    SbVert.Position:=0;
    DeleteSelectedCubes;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++Remove rightclicked cube from the Popup Menu+++++++++++++++++++++
procedure TForm1.RemoveCube1Click(Sender: TObject);
var i,j: Integer;
begin
  i:= CubePopUpMenu.Tag;
  with fc[i] do//tag holds cube
  begin
    if optSearch<>nil then (optSearch as OptimalSearch).Kill;
    if tripSearch<>nil then (tripSearch as TripleSearch).Kill;
    for j:=0 to 1000 do //app might crash if we free before killing thread
      Application.ProcessMessages;//allow the notify procedures to work
    if optSearch<>nil then (optSearch as OptimalSearch).idaU.Free;
    if tripSearch<>nil then
    begin
      (tripSearch as TripleSearch).idaU.Free;
      (tripSearch as TripleSearch).idaR.Free;
      (tripSearch as TripleSearch).idaF.Free;
    end;
  end;

  fc[i].Free;
  for j:= i+1 to fcN-1 do begin fc[j-1]:=fc[j]; fc[j-1].y:=fc[j-1].y-27*CSIZE; end;
  fc[fcN-1]:=nil;
  Dec(fcN);
  lowOld:=-1;
  lastSelected:=-1;
  if fcN=0 then
  begin
    dirty:=false;
    Caption:=ExtractFileName(curFilename)+' - '+curVersion;
  end;
  DeleteSelectedCubes1.Enabled:=false;
  for i:=0 to fcN-1 do
     if fc[i].selected= true then   DeleteSelectedCubes1.Enabled:=true;

  FormResize(nil);

  Output.Invalidate;
end;
//+++++++++++End Remove rightclicked cube(Popup Menu)+++++++++++++++++++++++++++

//++++++++Transfer rightlicked cube(Popup Menu)+++++++++++++++++++++++++++++++++
procedure TForm1.TransferCubetoFaceletEditor1Click(Sender: TObject);
var i: Face;
begin
  for i:= U1 to B9 do
    fCube.PFace^[i]:= fc[CubePopUpMenu.Tag].PFace^[i];
    FacePaint.Invalidate;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++Rotate rightclicked cube about UD-Axis+++++++++++++++++++++++
procedure TForm1.rotUDClick(Sender: TObject);
begin
  with fc[CubePopUpMenu.Tag] do
  begin
    Conjugate(S_U4);
    maneuver:=MT(maneuver,S_U4);
    if Pos('Status',optManeuver)=0 then
    optManeuver:=MT(optManeuver,S_U4);
  end;
  Output.Invalidate;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TForm1.RotURFClick(Sender: TObject);
begin
  with fc[CubePopUpMenu.Tag] do
  begin
    Conjugate(S_URF3);
    maneuver:=MT(maneuver,S_URF3);
    if Pos('Status',optManeuver)=0 then
    optManeuver:=MT(optManeuver,S_URF3);
  end;
  Output.Invalidate;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TForm1.RotFBClick(Sender: TObject);
begin
  with fc[CubePopUpMenu.Tag] do
  begin
    Conjugate(S_F2);
    maneuver:=MT(maneuver,S_F2);
    if Pos('Status',optManeuver)=0 then
    optManeuver:=MT(optManeuver,S_F2);
  end;
  Output.Invalidate;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TForm1.RefRLClick(Sender: TObject);
begin
  with fc[CubePopUpMenu.Tag] do
  begin
    Conjugate(S_LR2);
    maneuver:=MT(maneuver,S_LR2);
    if Pos('Status',optManeuver)=0 then
    optManeuver:=MT(optManeuver,S_LR2);
  end;
  Output.Invalidate;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++Invert rightclicked Cube (Popup Menu)+++++++++++++++++++++++++
procedure TForm1.InvertClick(Sender: TObject);
var c: CubieCube; fcube:FaceletCube; j: Integer;
label ende;
begin
  c:=CubieCube.Create(fc[CubePopUpMenu.Tag].PFace^);
  fcube:=FaceletCube.Create(nil);
  with fc[CubePopUpMenu.Tag] do
  begin
    CornInv(c.PCorn^,c.PCornTemp^);
    EdgeInv(c.PEdge^,c.PEdgeTemp^);
    c.cSwap:=c.PCorn;c.PCorn:=c.PCornTemp;c.PCornTemp:=c.cSwap;
    c.eSwap:=c.PEdge;c.PEdge:=c.PEdgeTemp;c.PEdgeTemp:=c.eSwap;
    fcube.SetFacelets(c);
    for j:= 0 to fcN-1 do
    if fcube.IsIsomorphic(fc[j]) and (CubePopUpMenu.Tag<>j) then
    if Application.MessageBox(PChar('Cube '+IntToStr(j+1)+' is isomorphic to the inverted cube. Proceed?'),'Maneuver Window',MB_ICONWARNING or MB_YESNO)
    <>IDYES then goto ende;
    SetFacelets(c);
    fc[CubePopUpMenu.Tag].maneuver:=fc[CubePopUpMenu.Tag].InverseManeuver;
    if Pos('Status',optManeuver)=0 then
    optManeuver:=InverseOptManeuver;
    Output.Invalidate;
  end;
ende:
  fcube.Free;
  c.Free;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++Click checkbox U,R,... in Pattern Editor+++++++++++++++++++++
procedure TForm1.CheckBoxOnClick(Sender: TObject);
var i:TurnAxis; j, count: Integer;
label found;
begin
  for i:= U to B do
  for j:= 1 to 5 do//5 different patterns
    if CheckBox[i,j]= Sender then goto found;
found:
  count:=0;
  for i:= U to B do if CheckBox[i,j].Checked then Inc(Count);
  case count of
    0: ACheckBox[j].State:= cbUnchecked;
    6: ACheckBox[j].State:= cbChecked;
  else
    ACheckBox[j].State:= cbGrayed;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++press "All" checkbox in Pattern Editor++++++++++++++++++++++++++++
procedure TForm1.CheckBoxAOnClick(Sender: TObject);
var i: TurnAxis; j,count: Integer;
begin
for j:= 1 to 5 do
  if Sender=ACheckBox[j] then
  begin
    case  ACheckBox[j].State of
    cbChecked: for i:=U to B do CheckBox[i,j].Checked:=true;//calls CheckBoxOnClick!
    cbGrayed:
    begin
      count:=0;
      for i:= U to B do if CheckBox[i,j].Checked then Inc(Count);
      if count=0 then ACheckBox[j].State:=cbChecked;//callsCheckBoxAOnClick again!

    end;
    cbUnchecked:  for i:=U to B do CheckBox[i,j].Checked:=false;
    end;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++Select a new color in the Pattern Editor++++++++++++++++++++++
procedure TForm1.PatShapeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  curPatCol:= (Sender as TShape).Tag;
  curShape.Brush.Color:= patSelector[curPatCol].Brush.Color;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++Color a square in the Pattern Editor++++++++++++++++++++++++++
procedure TForm1.SquareMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  with Sender as TShape do
  begin
    Brush.Color:=curShape.Brush.Color;
    tag:=curPatCol;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++Clear all patterns in the Pattern Editor++++++++++++++++++
procedure TForm1.PatClearClick(Sender: TObject);
var i,j: Integer;
begin
  for i:=1 to 5 do
  for j:=1 to 9 do
  begin
    Square[i,j].Tag:=6;
    Square[i,j].Brush.Color:=patSelector[6].Brush.Color;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++Cancel the search in the Pattern Editor+++++++++++++++++++++++
procedure TForm1.PatSearchTerminate(Sender: TObject);
var i:TurnAxis;j:Integer;
begin
  RunPatButton.Caption:='Start Search';
  CheckBoxContinuous.Enabled:=true;
   for i:= U to B do
   for j:= 1 to 5 do
     CheckBox[i,j].Enabled:=true;
   for j:= 1 to 5 do ACheckBox[j].Enabled:=true;
   PatClear.Enabled:=true;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++Select Printer Setup from File menu++++++++++++++++++++++++++++++++++
procedure TForm1.PrinterSetup1Click(Sender: TObject);
begin
 PrinterSetupDialog.Execute;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++Print the Main Window++++++++++++++++++++++++++++++++++++
procedure TForm1.PrintMainWindowClick(Sender: TObject);
var i,j,ph,sSave,xSave,ySave,dpCmV,size: Integer; cSave:TCanvas;s:String;
    isSelection: Boolean;
begin
  isSelection:=false;
  if Sender=PrintSelectedCubes then isSelection:=true;
  Printer.BeginDoc;
  dpCmV:=Round(GetDeviceCaps(Printer.Handle,LOGPIXELSY)/2.54);
  ph:=Printer.PageHeight-2*dpCmV;
  size:=ph div(30*6-6);//6 cubes, 24 units for one cube + 6 units space
 // Printer.Canvas.Font.Height:=-Round(size*3*3/4);//-6 because no space for last cube
  j:=0;
  for i:= 0 to fcN-1 do
  begin
    if isSelection and (fc[i].selected=false) then continue;
    cSave:=fc[i].cv;
    sSave:=fc[i].size;
    xSave:=fc[i].x;
    ySave:=fc[i].y;
    fc[i].cv:= Printer.Canvas;
    fc[i].size:=size;
    fc[i].x:=0;fc[i].y:=0;
    if (j<>0) and (j mod 6=0) then Printer.NewPage;
    Printer.Canvas.TextOut(2*dpCmV,(j mod 6)*30*size+dpCmV,IntToStr(j+1)+'.');
    if fc[i].displayGoal then
    if fc[i].runOptimal then s:=fc[i].optManeuver else s:=fc[i].maneuver
    else
    if fc[i].runOptimal then s:=fc[i].InverseOptManeuver else s:=fc[i].InverseManeuver;

    if not fc[i].displayGoal then
    begin
      Printer.Canvas.Font.Height:=-Round(size*3*3/4);
      Printer.Canvas.TextOut(2*dpCmV+36*size,(j mod 6)*30*size+dpCmV+12*size,s);
      Printer.Canvas.TextOut(2*dpCmV+36*size,(j mod 6)*30*size+dpCmV,fc[i].patName);
    end
    else
    begin
      Printer.Canvas.Font.Height:=-Round(size*2*3/4);
      Printer.Canvas.TextOut(2*dpCmV+59*size,(j mod 6)*30*size+dpCmV+16*size,s);
    end;
    fc[i].DrawCube(-2*dpCmV,-dpCmV-(j mod 6)*30*size);//left border 2cm
    fc[i].cv:=cSave;
    fc[i].size:=sSave;
    fc[i].x:=xSave;
    fc[i].y:=ySave;
    Inc(j);
  end;
  Printer.EndDoc;
end;
//++++++++++++++++++++++++++End Print the Main Window+++++++++++++++++++++++++++

//+++++++++++++++++++++++++++++Open the File Menu+++++++++++++++++++++++++++++++
procedure TForm1.File1Click(Sender: TObject);
var i: Integer;
begin
 if fcN=0 then
 begin
   PrintMainWindow.Enabled:=false;
   SaveWorkspace1.Enabled:=false;
   SaveasHtml1.Enabled:=false;
   end
 else
 begin
   PrintMainWindow.Enabled:=true;
   SaveWorkspace1.Enabled:=true;
   SaveasHtml1.Enabled:=true;
   end;
 PrintSelectedCubes.Enabled:=false;
 for i:= 0 to fcN-1 do
 if fc[i].selected=true then begin  PrintSelectedCubes.Enabled:=true;Break;end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++Close Help System before shutdown+++++++++++++++++++++++++++++++
procedure TForm1.FormDestroy(Sender: TObject);
begin
  mHHelp.Free;
  HHCloseAll;     //Close help before shutdown or big trouble
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++++Select Contents from Help Menu+++++++++++++++++++++++
procedure TForm1.Contents1Click(Sender: TObject);
begin
HtmlHelp(0, 'cube.chm', HH_DISPLAY_TOPIC, 0);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++Paint Routine for Goal Tabbedsheet++++++++++++++++++++++++
procedure TForm1.GoalPaintClick(Sender: TObject);
begin
 goalCube.DrawCube(0,0);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++Reset Goal to Clean Cube++++++++++++++++++++++++++++++++
procedure TForm1.ClearGoalClick(Sender: TObject);
begin
  goalCube.Clean;
  goalPaint.Invalidate;
   goalCube.goalIsID:=true;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++Copy Goal from Facelet Editor+++++++++++++++++++++++++++++++++
procedure TForm1.goalcopyClick(Sender: TObject);
var i: Face; //isID: Boolean;
begin
  for i:= U1 to B9 do //check if complete
  begin
    if fCube.PFace^[i]=NoCol then
    begin
     Application.MessageBox(PChar(Err[14]),'Facelet Editor',MB_ICONWARNING);
     exit
    end;
  end;

  for i:= U1 to B9 do
    goalCube.PFace^[i]:= fCube.PFace^[i];
  GoalPaint.Invalidate;
  //check if ID-Cube, the default
  goalCube.goalIsID:=true;
  with goalcube do
  begin
    for i:=U1 to U9 do if PFace^[i]<>UCol then goalIsId:= false;
    for i:=R1 to R9 do if PFace^[i]<>RCol then goalIsId:= false;
    for i:=F1 to F9 do if PFace^[i]<>FCol then goalIsId:= false;
    for i:=D1 to D9 do if PFace^[i]<>DCol then goalIsId:= false;
    for i:=L1 to L9 do if PFace^[i]<>LCol then goalIsId:= false;
    for i:=B1 to B9 do if PFace^[i]<>BCol then goalIsId:= false;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++Select Edit from Main Menu++++++++++++++++++++++++++++
procedure TForm1.Edit1Click(Sender: TObject);
var i: Integer;
begin
 if fcN=0 then ClearMainWindow2.Enabled:=false
 else ClearMainWindow2.Enabled:=true;
 DeleteSelectedCubes2.Enabled:=false;
 for i:= 0 to fcN-1 do
 if fc[i].selected=true then begin  DeleteSelectedCubes2.Enabled:=true;Break;end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++Transfer rightclicked Cube to Goal (Popup Menu++++++++++++++++++++++
procedure TForm1.TransferCubetoGoal1Click(Sender: TObject);
var i: Face;
begin
  for i:= U1 to B9 do
    goalCube.PFace^[i]:= fc[CubePopUpMenu.Tag].PFace^[i];
    GoalPaint.Invalidate;
    //check if ID-Cube, the default
  goalCube.goalIsID:=true;
  with goalcube do
  begin
    for i:=U1 to U9 do if PFace^[i]<>UCol then goalIsId:= false;
    for i:=R1 to R9 do if PFace^[i]<>RCol then goalIsId:= false;
    for i:=F1 to F9 do if PFace^[i]<>FCol then goalIsId:= false;
    for i:=D1 to D9 do if PFace^[i]<>DCol then goalIsId:= false;
    for i:=L1 to L9 do if PFace^[i]<>LCol then goalIsId:= false;
    for i:=B1 to B9 do if PFace^[i]<>BCol then goalIsId:= false;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++Select  File/Save as HTML from Main Menu+++++++++++++++++++++++++
procedure TForm1.SaveasHtml1Click(Sender: TObject);
var ss:TStringStream;fs:TFilestream;s,patGroup: String; i:Integer;
begin
  if SaveHtml.Execute= true then
  begin
    s:=ExtractFileName(SaveHtml.FileName);
    patGroup:= Copy(s,1,Pos('.',s)-1);
    ss := TStringStream.Create('');
    ss.WriteString('<HTML>'+#13#10+'<HEAD><TITLE>'+patGroup+'</TITLE></HEAD>'
       +#13#10+'<BODY BGCOLOR="#F0F0F0"><div align ="center"><H1>'+patGroup+'</H1>'+#13#10
       +'<p>&nbsp;</p></div>'+#13#10+'<table border="1" align="center">'+#13#10);
    for i:= 0 to fcN-1 do
    begin
      ss.WriteString('<tr><td width="120"><applet code="cube.class" width=120 height=120>'+#13+
      '<param name=bgColor value="ffffff">'+#13#10+'<param name=maneuver value="');

      with fc[i] do
      begin
        if (Length(optManeuver)>0) and (Pos('Status',optManeuver)=0) then
        begin
          s:=InverseOptManeuver;
          ss.WriteString(s+'">'+#13#10+'</applet></td>'+#13#10+
          '<td width=500><table border="1" width="100%" bordercolor="#CCCCCC">'
          +#13#10+'<tr><td width="17%"><div align="center">Name</div></td>'
          +#13#10+'<td width="83%">'+patName+'</td></tr><tr><td width="17%">'
          +#13#10+'<div align="center">Generator</div></td><td width="83%">'
          +s+'</td></tr></table></td></tr>'+#13#10);
        end
        else
        if (Length(maneuver)>0) then
        begin
          //if Length(patName)>0 then delim:='   //' else delim:=' ';
          s:=InverseManeuver;
          ss.WriteString(s+'">'+#13#10+'</applet></td>'+#13#10+
          '<td width=500><table border="1" width="100%" bordercolor="#CCCCCC">'
          +#13#10+'<tr><td width="17%"><div align="center">Name</div></td>'
          +#13#10+'<td width="83%">'+patName+'</td></tr><tr><td width="17%">'
          +#13#10+'<div align="center">Generator</div></td><td width="83%">'
          +s+'</td></tr></table></td></tr>'+#13#10);
        end;
      end
    end;
    ss.WriteString('</table><p>&nbsp;</p></body>'+#13#10+'</HTML>');
    fs := TFileStream.Create(SaveHtml.FileName, fmCreate);
    fs.WriteBuffer(PChar(ss.DataString)^,ss.Size);
    fs.Free;
    ss.Free;
  end;
end;
//+++++++++++++++++End Select File/Save as HTML from Main Menu++++++++++++++++++


//++++++++++++++++Select File/Exit from Main Menu+++++++++++++++++++++++++++++++
procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++Click on Options/Huge Optimal Solver+++++++++++++++++++++++++
procedure TForm1.HugeSolverClick(Sender: TObject);
var mem:MemoryStatus;msize:LongWord;need:Integer;
begin
  need:=0;
  mem.dwLength:=SizeOf(MemoryStatus);
  GlobalMemoryStatus(mem);
  msize:=Round((mem.dwTotalPhys+598016)/(1024*1024));
  SetCurrentDir(ExtractFilePath(Paramstr(0)));//Cube Explorer directory
 {$IF QTM}
  if not FileExists('bigPQ.prun') then need:=need+710000000;
 {$ELSE}
  if not FileExists('bigPF.prun') then need:=need+710000000;
 {$IFEND}

  if (msize>=1000) and (fcN=0) and (diskfree(0)>need)
  then OptOptionForm.CheckUseHuge.Enabled:=true
   else OptOptionForm.CheckUseHuge.Enabled:=false;
  OptOptionForm.Show;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//procedure TForm1.Button1Click(Sender: TObject);
//begin
// CreateBigPruningTable;
//end;

//++++++++++++++++Click one of the six Apply Move Buttons+++++++++++++++++++++++
procedure TForm1.ButtonXClick(Sender: TObject);
begin
   if not usedRightButton then
  begin
    if Sender=ButtonU then fCube.Move(U);
    if Sender=ButtonR then fCube.Move(R);
    if Sender=ButtonF then fCube.Move(F);
    if Sender=ButtonD then fCube.Move(D);
    if Sender=ButtonL then fCube.Move(L);
    if Sender=ButtonB then fCube.Move(B);
    FacePaint.Invalidate;
  end;
  usedRightButton:=false;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++Click one of the six Apply Move Buttons++++++++++++++++++++++
procedure TForm1.ButtonMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If Button=mbRight then
  begin
    PostMessage((Sender as TWinControl).Handle,WM_LBUTTONDOWN,MK_LBUTTON,0);
    (Sender as TButton).Caption:=(Sender as TButton).Caption+'''';
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++Transform mouse message in WM.LBUTTONUP message+++++++++++++++++
procedure TForm1.ButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If Button=mbRight then
  begin
  PostMessage((Sender as TWinControl).Handle,WM_LBUTTONUP,MK_LBUTTON,0);
  if Sender=ButtonU then
    Begin fCube.Move(U);fCube.Move(U);fCube.Move(U);FacePaint.Invalidate;end;
  if Sender=ButtonR then
    Begin fCube.Move(R);fCube.Move(R);fCube.Move(R);FacePaint.Invalidate;end;
  if Sender=ButtonF then
    Begin fCube.Move(F);fCube.Move(F);fCube.Move(F);FacePaint.Invalidate;end;
  if Sender=ButtonD then
    Begin fCube.Move(D);fCube.Move(D);fCube.Move(D);FacePaint.Invalidate;end;
  if Sender=ButtonL then
    Begin fCube.Move(L);fCube.Move(L);fCube.Move(L);FacePaint.Invalidate;end;
  if Sender=ButtonB then
    Begin fCube.Move(B);fCube.Move(B);fCube.Move(B);FacePaint.Invalidate;end;
  usedRightButton:=true;
  (Sender as TButton).Caption:=Copy((Sender as TButton).Caption,0,1);
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++Prevent closing of program when the tables are generated+++++++++++++
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if makesTables then
  begin
    Application.MessageBox(PChar(Err[9]),'',MB_ICONWARNING);
    CanClose:=false;
  end;
  if dirty then
    if Application.MessageBox(PChar(Err[10]),'',MB_ICONWARNING or MB_YESNO)=IDYES then
      SaveWorkspace1Click(nil);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++Free resources on closing+++++++++++++++++++++++++++++++++++
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var i: Integer;
begin
 HH.HtmlHelp(0, nil, HH_CLOSE_ALL, 0);
 for i:=0 to fcN-1 do fc[i].Selected:=true;
 DeleteSelectedCubes;

 SetLength(PruningP,0);
 SetLength(PruningPhase2P,0);
 SetLength(FlipSliceMove,0);
 SetLength(FlipConjugate,0);
 //SetLength(PruningBigP,0); //Internal compiler error L594 with Delphi 6.0
 //Finalize(PruningBigP);    //the same problem
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.
