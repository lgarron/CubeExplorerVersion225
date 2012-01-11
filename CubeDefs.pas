unit CubeDefs;


interface

uses Graphics,syncobjs;

const curVersion = 'Cube Explorer 2.25';

//Set QTM to TRUE if you want to use Quarter-Turn-Metric
//instead of Face-Turn-Metric. But keep in mind, that the
//Two-Phase-Algorithm is best suited for the FTM.
const QTM = FALSE;

type
  TurnAxis =(U,R,F,D,L,B);
  Move=(Ux1,Ux2,Ux3,Rx1,Rx2,Rx3,Fx1,Fx2,Fx3,Dx1,Dx2,Dx3,Lx1,Lx2,Lx3,Bx1,Bx2,Bx3);
  ColorIndex = (UCol,RCol,FCol,DCol,LCol,BCol,NoCol);

  Corner = (URF,UFL,ULB,UBR,DFR,DLF,DBL,DRB);
  OrientedCorner = record c:Corner; o: ShortInt; end;
  Edge = (UR,UF,UL,UB,DR,DF,DL,DB,FR,FL,BL,BR);
  OrientedEdge = record e:Edge; o: ShortInt; end;
  Face =
(U1,U2,U3,U4,U5,U6,U7,U8,U9,R1,R2,R3,R4,R5,R6,R7,R8,R9,F1,F2,F3,F4,F5,F6,F7,F8,F9,
 D1,D2,D3,D4,D5,D6,D7,D8,D9,L1,L2,L3,L4,L5,L6,L7,L8,L9,B1,B2,B3,B4,B5,B6,B7,B8,B9);

  SingleFace = array[1..9] of ColorIndex;
  Symmetry = (S_URF3,S_F2,S_U4,S_LR2);
  SymIdx = 0..47;

  CornerColorIndex = array [URF..DRB,0..2] of ColorIndex;
  CornerFacelet = array [URF..DRB,0..2] of Face;
  EdgeColorIndex = array [UR..BR,0..1] of ColorIndex;
  EdgeFacelet = array [UR..BR,0..1] of Face;
  FaceletColor = array [U1..B9] of ColorIndex;
  EdgeNeighbour=array[UR..BR,0..1] of Corner;

  Facelet = array [U1..B9] of Face;
  CornerCubie = array [URF..DRB] of OrientedCorner;
  EdgeCubie = array [UR..BR] of OrientedEdge;

  procedure CornMult(a,b:CornerCubie;var prod:CornerCubie);
  procedure EdgeMult(a,b:EdgeCubie;var prod:EdgeCubie);
  procedure CornInv(a:CornerCubie;var inv:CornerCubie);
  procedure EdgeInv(a:EdgeCubie;var inv:EdgeCubie);


const
 CornerToString: array [URF..DRB] of String =
 ('URF','UFL','ULB','UBR','DFR','DLF','DBL','DRB');
 EdgeToString: array [UR..BR] of String =
 ('UR','UF','UL','UB','DR','DF','DL','DB','FR','FL','BL','BR');

//+++++++++++++the colors of the corner cubies++++++++++++++++++++++++++++++++++
  CCI: CornerColorIndex =
  ((UCol,RCol,FCol),(UCol,FCol,LCol),(UCol,LCol,BCol),(UCol,BCol,RCol),
  (DCol,FCol,RCol),(DCol,LCol,FCol),(DCol,BCol,LCol),(DCol,RCol,BCol));

//+++++++++++++the involved facelets of the corner cubies+++++++++++++++++++++++
  CF: CornerFacelet =
  ((U9,R1,F3),(U7,F1,L3),(U1,L1,B3),(U3,B1,R3),
   (D3,F9,R7),(D1,L9,F7),(D7,B9,L7),(D9,R9,B7));

//+++++++++++++++++++++++the colors of the edge cubies++++++++++++++++++++++++++
  ECI: EdgeColorIndex =
  ((UCol,RCol),(UCol,FCol),(UCol,LCol),(UCol,BCol),(DCol,RCol),(DCol,FCol),
   (DCol,LCol),(DCol,BCol),(FCol,RCol),(FCol,LCol),(BCol,LCol),(BCol,RCol));

//+++++++++++++++++++the involved facelets of the edge cubies+++++++++++++++++++
  EF: EdgeFacelet =
  ((U6,R2),(U8,F2),(U4,L2),(U2,B2),(D6,R8),(D2,F8),
   (D4,L8),(D8,B8),(F6,R4),(F4,L6),(B6,L4),(B4,R6));

//+++++++++++++++++++++the neighbour corners of the edges+++++++++++++++++++++++
  EN: EdgeNeighbour =
  ((URF,UBR),(UFL,URF),(ULB,UFL),(UBR,ULB),(DRB,DFR),(DFR,DLF),
   (DLF,DBL),(DBL,DRB),(URF,DFR),(DLF,UFL),(DBL,ULB),(UBR,DRB));

//+++++++++++++++the permutations of the facelets by faceturns++++++++++++++++++
  FaceletMove: array [U..B] of Facelet =
(
(U3,U6,U9,U2,U5,U8,U1,U4,U7,F1,F2,F3,R4,R5,R6,R7,R8,R9,L1,L2,L3,F4,F5,F6,F7,F8,F9, //U
 D1,D2,D3,D4,D5,D6,D7,D8,D9,B1,B2,B3,L4,L5,L6,L7,L8,L9,R1,R2,R3,B4,B5,B6,B7,B8,B9),
(U1,U2,B7,U4,U5,B4,U7,U8,B1,R3,R6,R9,R2,R5,R8,R1,R4,R7,F1,F2,U3,F4,F5,U6,F7,F8,U9, //R
 D1,D2,F3,D4,D5,F6,D7,D8,F9,L1,L2,L3,L4,L5,L6,L7,L8,L9,D9,B2,B3,D6,B5,B6,D3,B8,B9),
(U1,U2,U3,U4,U5,U6,R1,R4,R7,D3,R2,R3,D2,R5,R6,D1,R8,R9,F3,F6,F9,F2,F5,F8,F1,F4,F7, //F
 L3,L6,L9,D4,D5,D6,D7,D8,D9,L1,L2,U9,L4,L5,U8,L7,L8,U7,B1,B2,B3,B4,B5,B6,B7,B8,B9),
(U1,U2,U3,U4,U5,U6,U7,U8,U9,R1,R2,R3,R4,R5,R6,B7,B8,B9,F1,F2,F3,F4,F5,F6,R7,R8,R9, //D
 D3,D6,D9,D2,D5,D8,D1,D4,D7,L1,L2,L3,L4,L5,L6,F7,F8,F9,B1,B2,B3,B4,B5,B6,L7,L8,L9),
(F1,U2,U3,F4,U5,U6,F7,U8,U9,R1,R2,R3,R4,R5,R6,R7,R8,R9,D1,F2,F3,D4,F5,F6,D7,F8,F9, //L
 B9,D2,D3,B6,D5,D6,B3,D8,D9,L3,L6,L9,L2,L5,L8,L1,L4,L7,B1,B2,U7,B4,B5,U4,B7,B8,U1),
(L7,L4,L1,U4,U5,U6,U7,U8,U9,R1,R2,U1,R4,R5,U2,R7,R8,U3,F1,F2,F3,F4,F5,F6,F7,F8,F9, //B
 D1,D2,D3,D4,D5,D6,R9,R6,R3,D7,L2,L3,D8,L5,L6,D9,L8,L9,B3,B6,B9,B2,B5,B8,B1,B4,B7)
);

//+++++++++++++++the permutations by basic symmetrytransformations++++++++++++++
  FaceletSym: array [S_URF3..S_LR2] of Facelet =
(
(R9,R8,R7,R6,R5,R4,R3,R2,R1,F3,F6,F9,F2,F5,F8,F1,F4,F7,U3,U6,U9,U2,U5,U8,U1,U4,U7, //S_URF3
 L1,L2,L3,L4,L5,L6,L7,L8,L9,B7,B4,B1,B8,B5,B2,B9,B6,B3,D3,D6,D9,D2,D5,D8,D1,D4,D7),
(D9,D8,D7,D6,D5,D4,D3,D2,D1,L9,L8,L7,L6,L5,L4,L3,L2,L1,F9,F8,F7,F6,F5,F4,F3,F2,F1, //S_F2
 U9,U8,U7,U6,U5,U4,U3,U2,U1,R9,R8,R7,R6,R5,R4,R3,R2,R1,B9,B8,B7,B6,B5,B4,B3,B2,B1),
(U3,U6,U9,U2,U5,U8,U1,U4,U7,F1,F2,F3,F4,F5,F6,F7,F8,F9,L1,L2,L3,L4,L5,L6,L7,L8,L9, //S_U4
 D7,D4,D1,D8,D5,D2,D9,D6,D3,B1,B2,B3,B4,B5,B6,B7,B8,B9,R1,R2,R3,R4,R5,R6,R7,R8,R9),
(U3,U2,U1,U6,U5,U4,U9,U8,U7,L3,L2,L1,L6,L5,L4,L9,L8,L7,F3,F2,F1,F6,F5,F4,F9,F8,F7, //S_LR2
 D3,D2,D1,D6,D5,D4,D9,D8,D7,R3,R2,R1,R6,R5,R4,R9,R8,R7,B3,B2,B1,B6,B5,B4,B9,B8,B7)
 );

//+++++++++++the positional changes of the cornercubies by faceturns++++++++++++
  CornerCubieMove: array[U..B] of CornerCubie =
  (((c:UBR;o:0),(c:URF;o:0),(c:UFL;o:0),(c:ULB;o:0),  //U
    (c:DFR;o:0),(c:DLF;o:0),(c:DBL;o:0),(c:DRB;o:0)),
   ((c:DFR;o:2),(c:UFL;o:0),(c:ULB;o:0),(c:URF;o:1),  //R
    (c:DRB;o:1),(c:DLF;o:0),(c:DBL;o:0),(c:UBR;o:2)),
   ((c:UFL;o:1),(c:DLF;o:2),(c:ULB;o:0),(c:UBR;o:0),  //F
    (c:URF;o:2),(c:DFR;o:1),(c:DBL;o:0),(c:DRB;o:0)),
   ((c:URF;o:0),(c:UFL;o:0),(c:ULB;o:0),(c:UBR;o:0),  //D
    (c:DLF;o:0),(c:DBL;o:0),(c:DRB;o:0),(c:DFR;o:0)),
   ((c:URF;o:0),(c:ULB;o:1),(c:DBL;o:2),(c:UBR;o:0),  //L
    (c:DFR;o:0),(c:UFL;o:2),(c:DLF;o:1),(c:DRB;o:0)),
   ((c:URF;o:0),(c:UFL;o:0),(c:UBR;o:1),(c:DRB;o:2),  //B
    (c:DFR;o:0),(c:DLF;o:0),(c:ULB;o:2),(c:DBL;o:1)));

//+the positional changes of the cornercubies by basic symmetrytransformations++
  CornerCubieSym: array [S_URF3..S_LR2]  of CornerCubie =
(
  ((c:URF;o:1),(c:DFR;o:2),(c:DLF;o:1),(c:UFL;o:2),   //S_URF3
   (c:UBR;o:2),(c:DRB;o:1),(c:DBL;o:2),(c:ULB;o:1)),
  ((c:DLF;o:0),(c:DFR;o:0),(c:DRB;o:0),(c:DBL;o:0),   //S_F2
   (c:UFL;o:0),(c:URF;o:0),(c:UBR;o:0),(c:ULB;o:0)),
  ((c:UBR;o:0),(c:URF;o:0),(c:UFL;o:0),(c:ULB;o:0),   //S_U4
   (c:DRB;o:0),(c:DFR;o:0),(c:DLF;o:0),(c:DBL;o:0)),
  ((c:UFL;o:3),(c:URF;o:3),(c:UBR;o:3),(c:ULB;o:3),   //S_LR2
   (c:DLF;o:3),(c:DFR;o:3),(c:DRB;o:3),(c:DBL;o:3))
////////////////////////////////////////////////////////////////////////////////
//++++o>=3: increment the orientation by o-3 and apply a reflection then++++++//
////////////////////////////////////////////////////////////////////////////////
);

//+++++++++++++++the positional changes of the edgecubies by faceturns++++++++++
  EdgeCubieMove: array[U..B] of EdgeCubie =
(
  ((e:UB;o:0),(e:UR;o:0),(e:UF;o:0),(e:UL;o:0),(e:DR;o:0),(e:DF;o:0),  //U
   (e:DL;o:0),(e:DB;o:0),(e:FR;o:0),(e:FL;o:0),(e:BL;o:0),(e:BR;o:0)),
  ((e:FR;o:0),(e:UF;o:0),(e:UL;o:0),(e:UB;o:0),(e:BR;o:0),(e:DF;o:0),  //R
   (e:DL;o:0),(e:DB;o:0),(e:DR;o:0),(e:FL;o:0),(e:BL;o:0),(e:UR;o:0)),
  ((e:UR;o:0),(e:FL;o:1),(e:UL;o:0),(e:UB;o:0),(e:DR;o:0),(e:FR;o:1),  //F
   (e:DL;o:0),(e:DB;o:0),(e:UF;o:1),(e:DF;o:1),(e:BL;o:0),(e:BR;o:0)),
  ((e:UR;o:0),(e:UF;o:0),(e:UL;o:0),(e:UB;o:0),(e:DF;o:0),(e:DL;o:0),  //D
   (e:DB;o:0),(e:DR;o:0),(e:FR;o:0),(e:FL;o:0),(e:BL;o:0),(e:BR;o:0)),
  ((e:UR;o:0),(e:UF;o:0),(e:BL;o:0),(e:UB;o:0),(e:DR;o:0),(e:DF;o:0),  //L
   (e:FL;o:0),(e:DB;o:0),(e:FR;o:0),(e:UL;o:0),(e:DL;o:0),(e:BR;o:0)),
  ((e:UR;o:0),(e:UF;o:0),(e:UL;o:0),(e:BR;o:1),(e:DR;o:0),(e:DF;o:0),  //B
   (e:DL;o:0),(e:BL;o:1),(e:FR;o:0),(e:FL;o:0),(e:UB;o:1),(e:DB;o:1))
);

//++the positional changes of the edgecubies by basic symmetrytransformations+++
  EdgeCubieSym: array[S_URF3..S_LR2] of EdgeCubie =
(
  ((e:UF;o:1),(e:FR;o:0),(e:DF;o:1),(e:FL;o:0),(e:UB;o:1),(e:BR;o:0),  //S_URF3
   (e:DB;o:1),(e:BL;o:0),(e:UR;o:1),(e:DR;o:1),(e:DL;o:1),(e:UL;o:1)),
  ((e:DL;o:0),(e:DF;o:0),(e:DR;o:0),(e:DB;o:0),(e:UL;o:0),(e:UF;o:0),  //S_F2
   (e:UR;o:0),(e:UB;o:0),(e:FL;o:0),(e:FR;o:0),(e:BR;o:0),(e:BL;o:0)),
  ((e:UB;o:0),(e:UR;o:0),(e:UF;o:0),(e:UL;o:0),(e:DB;o:0),(e:DR;o:0),  //S_U4
   (e:DF;o:0),(e:DL;o:0),(e:BR;o:1),(e:FR;o:1),(e:FL;o:1),(e:BL;o:1)),
  ((e:UL;o:0),(e:UF;o:0),(e:UR;o:0),(e:UB;o:0),(e:DL;o:0),(e:DF;o:0),  //S_LR2
   (e:DR;o:0),(e:DB;o:0),(e:FL;o:0),(e:FR;o:0),(e:BR;o:0),(e:BL;o:0))
);

//++++++++++++++++++++++++++++++++Error Messages++++++++++++++++++++++++++++++++
  Err: array[1..20] of String =
(
  'Twist Error. The twist of the URF-Corner will be changed.',
  'Flip Error. The flip of the UF-Corner will be changed.',
  'Parity Error. The UF-Edge and the DF-Edge will be exchanged.',
  'The maneuver already is optimal. If you proceed you may loose optimality. Proceed?',
  'The Two-Phase-Algorithm can not find a better solution.',
  'All patterns without generators in the Output Window will be discarded. Continue anyway?',
  'Before the first run, Cube Explorer needs to create files in your Cube Explorer folder. This may take up to 15 minutes and about 65 MB of space on your harddisk. Proceed?',
  'There are less than 65 MB disk space left in your Cube Explorer folder. The program will exit.',
  'Cube Explorer is busy. Please wait.',
  'Do you want to save the cubes in the Main Window before exiting Cube Explorer?',
  'All changes to the Main Window will be discarded. Proceed?',
  'Do you want to discard the Cubes in the Main Window before loading the maneuvers?',
  'You must define colours for all facelets!',
  'There are still undefined facelets in the Facelet Editor.',
  'You only have',' MB of RAM installed on your machine. You need at least 90 MB. The program will exit.',
  'Not enough RAM. Cube Explorer needs 850 MB. Please close all other applications.',
  'Unable to load the 673 MB Huge Optimal Solver Table.',
  'Unable to write the 673 MB Huge Optimal Solver Table.',
  'Cube Explorer will now create a 673 MB file in your Cube Explorer folder. This will take up to 4 hours. Proceed?'
);


var Color: array [UCol..NoCol] of TColor;
    maxMoves,stopAt: Integer;//Two Phase Algorithm Options dialog
    useTriple:Boolean;//flag for triple search
    checkIsomorphics,USES_BIG: Boolean;

implementation

//+++++++++++++++++++++Multiplication of corner permutations++++++++++++++++++++
procedure CornMult(a,b:CornerCubie;var prod:CornerCubie);
var co: Corner; oriA,oriB,ori: ShortInt;
begin
  ori:=0;
  for co:=URF to DRB do
  begin
    prod[co].c:= a[b[co].c].c;
    oriA:= a[b[co].c].o; oriB:= b[co].o;
    if (oriA<3) and (oriB<3) then
    begin
      ori:= oriA + oriB;
      if ori >=3 then ori:=ori-3;
    end
    else
    if (oriA<3) and (oriB>=3) then//reflections involved
    begin
      ori:= oriA + oriB;
      if ori>=6 then ori:= ori-3;
    end
    else
    if (oriA>=3) and (oriB<3) then//reflections involved
    begin
      ori:= oriA - oriB;
      if ori<3 then ori:=ori+3;
    end
    else
    if (oriA>=3) and (oriB>=3) then////reflections involved
    begin
      ori:= oriA  - oriB;
      if ori<0 then ori:=ori+3;
    end;
    prod[co].o:=ori;
  end;
end;
//++++++++++++++++++End Multiplication of corner permutations+++++++++++++++++++

//+++++++++++++++++++++Multiplication of edge permutations++++++++++++++++++++++
procedure EdgeMult(a,b:EdgeCubie; var prod:EdgeCubie);
var ed: Edge; ori:ShortInt;
begin
  for ed:=UR to BR do
  begin
    prod[ed].e:= a[b[ed].e].e;
    ori:= b[ed].o+a[b[ed].e].o;
    if ori=2 then ori:=0;
    prod[ed].o:=ori;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++Compute the Inverse of an Edge Permutation++++++++++++++++++++++++
procedure EdgeInv(a:EdgeCubie;var inv:EdgeCubie);
var ed: Edge;
begin
  for ed:=UR to BR do inv[a[ed].e].e:=ed;
  for ed:=UR to BR do inv[ed].o:= a[inv[ed].e].o;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++Compute the Inverse of a Corner Permutation++++++++++++++++++++++++
procedure CornInv(a:CornerCubie;var inv:CornerCubie);
var co: Corner; ori:ShortInt;
begin
 for co:= URF to DRB do inv[a[co].c].c:=co;
 for co:= URF to DRB do
 begin
   ori:= a[inv[co].c].o;
   if ori>=3 then  //just for completeness, we do not invert "reflection states"
     inv[co].o:=ori//in Cube Explorer
   else
   begin //the usual case;
     inv[co].o:=-ori;
     if inv[co].o<0 then inv[co].o:=inv[co].o+3;
   end;
 end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.
