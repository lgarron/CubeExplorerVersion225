unit CubiCube;

interface
uses Graphics, CubeDefs, FaceCube, Symmetries;
type
//++++++++++Class representing the Cube on the Cubie Level++++++++++++++++++++++
  CubieCube = Class
  public
     Corn1,Corn2: CornerCubie;//a move applied to Corn1 is saved in Corn2 and vica versa
     Edge1,Edge2: EdgeCubie;
     PCorn,PCornTemp,cSwap: ^CornerCubie;
     PEdge,PEdgeTemp,eSwap: ^EdgeCubie;
     procedure Move(x:TurnAxis);
     procedure Conjugate(s:Symmetry);overload;
     procedure Conjugate(n:SymIdx);overload;

     constructor Create; overload;
     constructor Create(PFace: FaceletColor); overload;
     constructor Create(cp,co,ep,eo:Integer); overload;
     procedure Print(c:TCanvas;x,y:Longint);

     //++++++++++corner orientation raw-coordinate++++++++++++++++++++++++++++++
     function CornOriCoord: Word;

     //++++++++++Set corners that the corner orientation coordinate is w++++++++
     procedure InvCornOriCoord(w:Word);

     //++++++++++Get the sum of all corner twists mod 3+++++++++++++++++++++++++
     function CornOriMod3: Integer;

     //++++++++++++++edge orientation raw-coordinate+++++++++++++++++++++++++++
     function EdgeOriCoord: Word;

     //++++++++++Set edges that the corner orientation coordinate is w++++++++++
     procedure InvEdgeOriCoord(w:Word);

     //++++++++++Get the sum of all edge flips mod 2++++++++++++++++++++++++++++
     function EdgeOriMod2: Integer;

     //+++++++++Get phase 1 UDSlice raw-coordinate+++++++++++++++++++++++++++++
     function UDSliceCoord: Word;

     //+++++++++Set the UDslice edges, so that UDSlice coordinate is w++++++++++
     procedure InvUDSliceCoord(w: Word);

     //+++++The same as above, but also regard the order of the four edges++++++
     function UDSliceSortedCoord: Word;
     procedure InvUDSliceSortedCoord(w: Word);

     //++++++++the sym-coordinate version of the UDSliceSorted coordinate+++++++
     function UDSliceSortedSymCoord: Integer;
     procedure InvUDSliceSortedSymCoord(n: Integer);

     //+++++++++++sym-coordinate FlipUDSlice++++++++++++++++++++++++++++++++++++
     function FlipUDSliceCoord: Integer;
     procedure InvFlipUDSliceCoord(n: Integer);

     //+++++++++++++++raw-coordinate corner permutation+++++++++++++++++++++++++
     function CornPermCoord: Word;
     procedure InvCornPermCoord(w:Word);

     //+++++++++++++++Phase 2 edge permutation coordinate+++++++++++++++++++++++
     function Phase2EdgePermCoord: Word;
     procedure InvPhase2EdgePermCoord(w:Word);

     //+++++++++++++++++++Edge permutation coordinate for 12 edges++++++++++++++
     function EdgePermCoord: Integer;//only used for random cube
     procedure InvEdgePermCoord(w:Integer);

     //++++++++++Parity Checks for corner and edge permutations+++++++++++++++++
     function CornParityEven: Boolean;
     function EdgeParityEven: Boolean;
     function UDSliceParityEven: Boolean;//not used in Cube Explorer

     //Look if the raw-FlipUDSlice coordinate n is in the
     //FlipUDSliceToRawFlipUDSlice array of representants. Return the classindex
     //if so, or -1 if not.
     
     function FlipUDSliceRawCoordClassIndex(n: Integer): Integer;
     //Return true, if the raw-FlipUDSlice coordinate is in the representant array
     function IsFlipUDSliceCoordRep: Boolean;

     //++++++Sorted version of above for Big Optimal Solver+++++++++++++++++++++
     function UDSliceSortedRawCoordClassIndex(n: Integer): Integer;
     function IsUDSliceSortedCoordRep: Boolean;

  end;
//++++++++++End Class representing the Cube on the Cubie Level++++++++++++++++++

//+++++++++++++++++++++++ClassIndexToRepresentant arrays++++++++++++++++++++++++
  var FlipUDSliceToRawFlipUDSlice: array[0..64430-1] of Integer;
    UDSliceSortedSymToUDSliceSorted: array[0..788-1] of Integer;
    SymCornPosToCornPos: array[0..2768-1] of Word;

//because we need the sym-corner permutation coordinate from the raw coordinate
//each time we compute the pruning depth in phase 2, we use this array++++++++++
    CornPosToSymCornPos: array[0..40320-1] of Integer;

  procedure CreateClassIndexToRepresentantTables;

implementation

uses MathFuncs, classes, SysUtils, RubikMain, Forms;

//++++++++Do a move on the cubie-level++++++++++++++++++++++++++++++++++++++++++
procedure CubieCube.Move(x: TurnAxis);
begin
  cSwap:= PCorn; PCorn:= PCornTemp; PCornTemp:=cSwap;
  eSwap:= PEdge; PEdge:= PEdgeTemp; PEdgeTemp:=eSwap;
  CornMult(PCornTemp^,CornerCubieMove[x],PCorn^);
  EdgeMult(PEdgeTemp^,EdgeCubieMove[x],PEdge^);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++Do conjugation with symmetry++++++++++++++++++++++++++++++++
procedure CubieCube.Conjugate(s: Symmetry);
begin
  cSwap:= PCorn; PCorn:= PCornTemp; PCornTemp:=cSwap;
  eSwap:= PEdge; PEdge:= PEdgeTemp; PEdgeTemp:=eSwap;
  CornMult(PCornTemp^,CornerCubieSym[s],PCorn^);
  EdgeMult(PEdgeTemp^,EdgeCubieSym[s],PEdge^);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++Do conjuation with symmetry++++++++++++++++++++++++++++++++++++++
procedure CubieCube.Conjugate(n: SymIdx);
begin
  cSwap:= PCorn; PCorn:= PCornTemp; PCornTemp:=cSwap;
  eSwap:= PEdge; PEdge:= PEdgeTemp; PEdgeTemp:=eSwap;
  CornMult(PCornTemp^,CornSym[n],PCorn^);
  EdgeMult(PEdgeTemp^,EdgeSym[n],PEdge^);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++Default constructor+++++++++++++++++++++++++++++++++++++++++++
constructor CubieCube.Create;
  var i: Corner; j: Edge;
begin
  PCorn:= @Corn1; PCornTemp:=@Corn2;
  PEdge:= @Edge1; PEdgeTemp:=@Edge2;

  for i:= URF to DRB do begin PCorn^[i].c:= i; PCorn^[i].o:= 0; end;
  for j:= UR to BR do begin PEdge^[j].e:= j; PEdge^[j].o:= 0; end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++Construct a CubieCube from facelet colors++++++++++++++++++++++
constructor CubieCube.Create(PFace:FaceletColor);//(fc: FaceletCube);
  var ori,o1,o2: ShortInt; i,j: Corner; XCol1,XCol2: ColorIndex; k,m: Edge;
begin
  PCorn:= @Corn1; PCornTemp:=@Corn2;
  PEdge:= @Edge1; PEdgeTemp:=@Edge2;

  for i:=URF to DRB do
  begin
    ori:=0;
    while (PFace[CF[i,ori]]<>UCol) and (PFace[CF[i,ori]]<>DCol) do inc(ori);
    o1:=ori+1; if o1=3 then o1:=0; XCol1:=PFace[CF[i,o1]];
    o2:=o1+1;  if o2=3 then o2:=0; XCol2:=PFace[CF[i,o2]];
    for j:=URF to DRB do if (XCol1=CCI[j,1]) and (XCol2=CCI[j,2]) then
    begin
      PCorn^[i].c:=j;//corner j sits in corner i's clean cube position
      PCorn^[i].o:=ori;//twist of corner j
      break;//j
    end;
  end;
  for k:=UR to BR do
  for m:=UR to BR do
  begin
    if (PFace[EF[k,0]]=ECI[m,0]) and (PFace[EF[k,1]]=ECI[m,1]) then
    begin
      PEdge^[k].e:=m;//edge m sits in edge k's clean cube position;
      PEdge^[k].o:=0;//no flip
      break;
    end;
    if (PFace[EF[k,0]]=ECI[m,1]) and (PFace[EF[k,1]]=ECI[m,0]) then
    begin
      PEdge^[k].e:=m;
      PEdge^[k].o:=1;//flip
      break;
    end;
  end;
end;
//+++++++++++End Construct a CubieCube from facelet colors++++++++++++++++++++++

//+++++++++++Create a CubieCube from coordinates++++++++++++++++++++++++++++++++
constructor CubieCube.Create(cp,co,ep,eo:Integer);
begin
  PCorn:= @Corn1; PCornTemp:=@Corn2;
  PEdge:= @Edge1; PEdgeTemp:=@Edge2;
  InvCornPermCoord(cp);
  InvCornOriCoord(co);
  InvEdgePermCoord(ep);
  InvEdgeOriCoord(eo);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++Print CubieCube (debugging only)++++++++++++++++++++++++++++
procedure CubieCube.Print(c:TCanvas;x,y:Longint);
var i: Corner; var j: Edge; s: string;
begin
  c.Brush.Color:=clRed;
  s:='                                                                                             ';
  c.TextOut(x,y,s);
  c.TextOut(x,y+20,s);
  s:='';
  for i:= URF to DRB do
  begin
    s:=s+' '+CornerToString[PCorn^[i].c];
    case PCorn^[i].o of
    0:  s:=s+' ';
    1:  s:=s+'+ ';
    2:  s:=s +'- ';
    3:  s:=s+'* ';
    4:  s:=s+'+* ';
    5:  s:=s +'-* ';
    end;
  end;

  c.TextOut(x,y,s);
  s:='';
  for j:= UR to BR do
  begin
    s:=s+' '+EdgeToString[PEdge^[j].e];
    case PEdge^[j].o of
    0:  s:=s+' ';
    1:  s:=s+'+';
    end;
  end;
  c.TextOut(x,y+20,s);
end;
//++++++++++++++End Print CubieCube (debugging only)++++++++++++++++++++++++++++

//+++++++++++++++corner orientation raw-coordinate++++++++++++++++++++++++++++++
function CubieCube.CornOriCoord:Word;
var co: Corner; s: Word;//orientations must be 0..2
begin
  s:=0;
  for co:= URF to Pred(DRB) do s:= 3*s + PCorn^[co].o;
  Result:= s;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++Inverse function of above+++++++++++++++++++++++++++++++++
procedure CubieCube.InvCornOriCoord(w:Word);
var co: Corner; parity: ShortInt;
begin
  parity:=0;
  for co:=Pred(DRB) downto URF do
  begin
    parity:= parity + w mod 3;
    PCorn^[co].o:= w mod 3;
    w:= w div 3;
  end;
  parity:= parity mod 3;
  case parity of
  0: PCorn^[DRB].o:= 0;
  1: PCorn^[DRB].o:= 2;
  2: PCorn^[DRB].o:= 1;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++Get the sum of all corner twists mod3++++++++++++++++++++
function CubieCube.CornOriMod3: Integer;
var co: Corner; s: Word;
begin
  s:=0;
  for co:= URF to DRB do s:= s + PCorn^[co].o;
  Result:= s mod 3;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++edge orientation raw-coordinate+++++++++++++++++++++++++++
function CubieCube.EdgeOriCoord:Word;
var ed: Edge; s: Word;
begin
  s:=0;
  for ed:= UR to Pred(BR) do s:= 2*s + PEdge^[ed].o;
  Result:= s;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++++++++inverse of above+++++++++++++++++++++++++++++++++
procedure CubieCube.InvEdgeOriCoord(w:Word);
var ed: Edge; parity: ShortInt;
begin
  parity:=0;
  for ed:=Pred(BR) downto UR do
  begin
    parity:= parity + w mod 2;
    PEdge^[ed].o:= w mod 2;
    w:= w div 2;
  end;
  PEdge^[BR].o:= parity mod 2;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++Get the sum of all edge flips mod 2++++++++++++++++++++++++++++
function CubieCube.EdgeOriMod2: Integer;
var ed: Edge; s: Word;
begin
  s:=0;
  for ed:= UR to BR do s:= s + PEdge^[ed].o;
  Result:= s mod 2;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++Get phase 1 UDSlice raw-coordinate+++++++++++++++++++++++++++++
function CubieCube.UDSliceCoord;
var s: Word; k,n: Integer; occupied: array[0..11] of boolean; ed: Edge;
begin
  for n:= 0 to 11 do occupied[n]:=false;
  for ed:=UR to BR do if PEdge^[ed].e >= FR then occupied[Word(ed)]:=true;

  s:=0; k:=3; n:=11;
  while k>= 0 do
  begin
    if occupied[n] then Dec(k)
    else s:= s + Cnk(n,k);
    Dec(n);
  end;
  Result:= s;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++inverse of above++++++++++++++++++++++++++++++++++++
procedure CubieCube.InvUDSliceCoord(w: Word);
var n,k,v: Integer; udSliceEdge,ed,i: Edge; occupied: array[0..11] of boolean;
begin
  for n:= 0 to 11 do occupied[n]:=false;
  n:= 11; k:= 3;
  while k>=0 do
  begin
    v:= Cnk(n,k);
    if w<v then begin Dec(k); occupied[n]:= true; end
    else w:= w-v;
    Dec(n);
  end;
  uDSliceEdge:=FR;
  for ed:=UR to BR do if occupied[Ord(ed)] then
  begin
    for i:= UR to BR do
      if PEdge^[i].e= udSLiceEdge then
      begin PEdge^[i].e := PEdge^[ed].e; break; end;
    PEdge^[ed].e:= udSliceEdge;
    if udSliceEdge<BR then Inc(udSliceEdge);
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++UDSliceSorted raw-coordinate++++++++++++++++++++++++++++++
function CubieCube.UDSliceSortedCoord: Word;

var j,k,s,x: Integer; i,e: Edge; arr: array[0..3] of Edge;
begin
  j:=0;
  for i:= UR to BR do
  begin
    e:=PEdge^[i].e;
    if (e=FR) or (e=FL) or (e=BL) or (e=BR) then begin arr[j]:= e; Inc(j); end;
  end;

  x:= 0;
  for j:= 3 downto 1 do
  begin
    s:=0;
    for k:= j-1 downto 0 do
    begin
      if arr[k]>arr[j] then Inc(s);
    end;
    x:= (x+s)*j;
  end;
  Result:= UDSliceCoord*24 + x;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++inverse of above+++++++++++++++++++++++++++++++++++++++
procedure CubieCube.InvUDSliceSortedCoord(w: Word);
var x: Word; order: array[0..3] of Integer; used: array[FR..BR] of Boolean;
    j,k,e: Edge; i,m: Integer;
begin
  x:= w mod 24;
  InvUDSliceCoord(w div 24);

  for j:= FR to BR do used[j]:=false;
  for i:= 0 to 3 do
  begin
    order[i]:= x mod (i+1);
    x:= x div (i+1);
  end;

  for i:= 3 downto 0 do
  begin
    k:=BR; while used[k] do Dec(k);
    while order[i]>0 do
    begin
      Dec(order[i]);
      repeat
       Dec(k);
      until not used[k];
    end;

    m:=-1;
    for j:= UR to BR do //search the i. UD-slice edge
    begin
      e:= PEdge^[j].e;
      if (e=FR) or (e=FL) or (e=BL) or (e=BR) then Inc(m);
      if m=i then
      begin
        PEdge^[j].e:=k;
        used[k]:=true;
        break;
      end;
    end;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++the sym-coordinate version of the UDSliceSorted coordinate+++++++
function CubieCube.UDSliceSortedSymCoord: Integer;
var k,n,coord: Integer; c:CubieCube;
begin
  Result:=-1;
  c:=CubieCube.Create;
  for k:= 0 to 15 do
  begin
    EdgeMult(EdgeSym[k],PEdge^,c.PEdgeTemp^);
    EdgeMult(c.PEdgeTemp^,EdgeSym[InvIdx[k]],c.PEdge^);
    n:= c.UDSliceSortedCoord;
    coord:= UDSliceSortedRawCoordClassIndex(n);
    if coord<>-1 then
    begin
      Result:= coord shl 4 + k;
      break;
    end;
  end;
  assert(Result<>-1);
  c.Free;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++inverse of above+++++++++++++++++++++++++++++++++++++++++
procedure CubieCube.InvUDSliceSortedSymCoord(n: Integer);
var idx,k,m: Integer;
begin
  idx:= n shr 4;
  k:= n and 15;
  m:= UDSliceSortedSymToUDSliceSorted[idx];
  InvUDSliceSortedCoord(m);
  EdgeMult(EdgeSym[InvIdx[k]],PEdge^,PEdgeTemp^);
  EdgeMult(PEdgeTemp^,EdgeSym[k],PEdge^);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++sym-coordinate FlipUDSlice++++++++++++++++++++++++++++++++++
function CubieCube.FlipUDSliceCoord: Integer;
var k,n,coord: Integer; prod: EdgeCubie; c,d: CubieCube;
begin
  c:= CubieCube.Create;
  d:= CubieCube.Create;
  c.InvUDSliceCoord(UDSliceCoord);
  c.InvEdgeOriCoord(EdgeOriCoord);
  Result:=-1;
  for k:= 0 to 15 do
  begin
    EdgeMult(EdgeSym[k],c.PEdge^,prod);
    EdgeMult(prod,EdgeSym[InvIdx[k]],d.PEdge^);
    n:= 2048*d.UDSliceCoord + d.EdgeOriCoord;//raw coordinate
    coord:= FlipUDSliceRawCoordClassIndex(n);
    if coord<>-1 then
    begin
      Result:= coord shl 4 + k;
      break;
    end;
  end;
  assert(Result<>-1);
  c.Free;
  d.Free;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++++++++++++Inverse of above+++++++++++++++++++++++++++++
procedure CubieCube.InvFlipUDSliceCoord(n: Integer);
var idx,k,m: Integer; prod: EdgeCubie;
begin
  idx:= n shr 4;
  k:= n and 15;
  m:= FlipUDSliceToRawFlipUDSlice[idx];
  InvUDSLiceCoord(m div 2048);
  InvEdgeOriCoord(m mod 2048);
  EdgeMult(EdgeSym[InvIdx[k]],PEdge^,prod);
  EdgeMult(prod,EdgeSym[k],PEdge^);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++raw-coordinate corner permutation+++++++++++++++++++++++++
function CubieCube.CornPermCoord: Word;
var i,j: Corner; x,s: Integer;
begin
  x:= 0;
  for i:= DRB downto Succ(URF) do
  begin
    s:=0;
    for j:= Pred(i) downto URF do
    begin
      if PCorn^[j].c>PCorn^[i].c then Inc(s);
    end;
    x:= (x+s)*Ord(i);
  end;
  Result:=x;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++++++inverse of above+++++++++++++++++++++++++++++++++++
procedure CubieCube.InvCornPermCoord(w: Word);
var used: array[URF..DRB] of boolean; i,k: Corner; order: array[URF..DRB] of Integer;
begin
  for i:= URF to DRB do
  begin
    used[i]:=false;
    order[i]:= w mod (Ord(i)+1);
    w:= w div (Ord(i)+1);
  end;
  for i:= DRB downto URF do
  begin
    k:=DRB; while used[k] do Dec(k);
    while order[i]>0 do
    begin
      Dec(order[i]);
      repeat
       Dec(k);
      until not used[k];
    end;
    PCorn^[i].c:=k;
    used[k]:=true;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++Phase 2 edge permutation coordinate+++++++++++++++++++++++
function CubieCube.Phase2EdgePermCoord: Word;
var i,j: Edge; x,s: Integer;
begin
  x:= 0;
  for i:= DB downto Succ(UR) do
  begin
    s:=0;
    for j:= Pred(i) downto UR do
    begin
      if PEdge^[j].e>PEdge^[i].e then Inc(s);
    end;
    x:= (x+s)*Ord(i);
  end;
  Result:=x;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++inverse of above++++++++++++++++++++++++++++++++++
procedure CubieCube.InvPhase2EdgePermCoord(w: Word);
var used: array[UR..DB] of boolean; i,k: Edge; order: array[UR..DB] of Integer;
begin
  for i:= UR to DB do
  begin
    used[i]:=false;
    order[i]:= w mod (Ord(i)+1);
    w:= w div (Ord(i)+1);
  end;
  for i:= DB downto UR do
  begin
    k:=DB; while used[k] do Dec(k);
    while order[i]>0 do
    begin
      Dec(order[i]);
      repeat
       Dec(k);
      until not used[k];
    end;
    PEdge^[i].e:=k;
    used[k]:=true;
  end;
  for i:= FR to BR do PEdge^[i].e:=i;//fill up UD-slice
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++Phase 2 edge permutation coordinate++++++++++++++++++++++++
function CubieCube.EdgePermCoord: Integer;
var i,j: Edge; x,s: Integer;
begin
  x:= 0;
  for i:= BR downto Succ(UR) do
  begin
    s:=0;
    for j:= Pred(i) downto UR do
    begin
      if PEdge^[j].e>PEdge^[i].e then Inc(s);
    end;
    x:= (x+s)*Ord(i);
  end;
  Result:=x;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++inverse of above++++++++++++++++++++++++++++++++++++
procedure CubieCube.InvEdgePermCoord(w: Integer);
var used: array[UR..BR] of boolean; i,k: Edge; order: array[UR..BR] of Integer;
begin
  for i:= UR to BR do
  begin
    used[i]:=false;
    order[i]:= w mod (Ord(i)+1);
    w:= w div (Ord(i)+1);
  end;
  for i:= BR downto UR do
  begin
    k:=BR; while used[k] do Dec(k);
    while order[i]>0 do
    begin
      Dec(order[i]);
      repeat
       Dec(k);
      until not used[k];
    end;
    PEdge^[i].e:=k;
    used[k]:=true;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++check corner permutation parity++++++++++++++++++++++++++++
function CubieCube.CornParityEven: Boolean;
var i,j: Corner; s: Integer;
begin
  s:= 0;
  for i:= DRB downto Succ(URF) do
  for j:= Pred(i) downto URF do
    if PCorn^[j].c>PCorn^[i].c then Inc(s);
  if odd(s) then Result:= false else Result:= true;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++check edge permutation parity+++++++++++++++++++++++++++
function CubieCube.EdgeParityEven: Boolean;
var i,j: Edge; s: Integer;
begin
  s:= 0;
  for i:= BR downto Succ(UR) do
  for j:= Pred(i) downto UR do
    if PEdge^[j].e>PEdge^[i].e then Inc(s);
  if odd(s) then Result:= false else Result:= true;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++check parity of udslice edges (not used)+++++++++++++++++++
function CubieCube.UDSliceParityEven: Boolean;
var j,k,s: Integer; i,e: Edge; arr: array[0..3] of Edge;
begin
  j:=0;
  for i:= UR to BR do
  begin
    e:=PEdge^[i].e;
    if (e=FR) or (e=FL) or (e=BL) or (e=BR) then begin arr[j]:= e; Inc(j); end;
  end;
  s:=0;
  for j:= 0 to 2 do
  for k:=j+1 to 3 do
    if arr[j]>arr[k] then Inc(s);
  if Odd(s) then Result:= false
  else Result:= true;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Look if the raw-FlipUDSlice coordinate n is in the
//FlipUDSliceToRawFlipUDSlice array of representants. Return the classindex
//if so, or -1 if not.
function CubieCube.FlipUDSliceRawCoordClassIndex(n: Integer): Integer;
var rBound,lBound,a,aOld : Integer;
begin
  Result:= -1;
  if n<=FlipUDSliceToRawFlipUDSlice[64429] then
  begin
    rBound:=64430;
    lBound:=0;
    a:=-1;
    repeat
      aOld:=a;
      a:= (rBound + lBound) div 2;
      if n< FlipUDSliceToRawFlipUDSlice[a] then rBound:= a
      else
        if n > FlipUDSliceToRawFlipUDSlice[a] then lBound:= a
        else begin Result:= a; break; end;
    until (a=aOld);
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//Return true, if the raw-FlipUDSlice coordinate is in the representant array
function CubieCube.IsFlipUDSliceCoordRep: Boolean;
var n,coord: Integer;
begin
  n:= 2048*UDSliceCoord + EdgeOriCoord;//raw coordinate
  coord:=FlipUDSliceRawCoordClassIndex(n);
  if coord=-1 then Result:= false else Result:=true;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++analogous to FlipUDSliceRawCoordClassIndex++++++++++++++++++++++++++
function CubieCube.UDSliceSortedRawCoordClassIndex(n: Integer): Integer;
var rBound,lBound,a,aOld : Integer;
begin
  Result:= -1;
  if n<= UDSliceSortedSymToUDSliceSorted[788-1] then
  begin
    rBound:=788;
    lBound:=0;
    a:=-1;
    repeat
      aOld:=a;
      a:= (rBound + lBound) div 2;
      if n< UDSliceSortedSymToUDSliceSorted[a] then rBound:= a
      else
        if n > UDSliceSortedSymToUDSliceSorted[a] then lBound:= a
        else begin Result:= a; break; end;
    until (a=aOld);
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Return true, if the raw-UDSliceSorted coordinate is in the representant array
function CubieCube.IsUDSliceSortedCoordRep: Boolean;
var n,coord: Integer;
begin
  n:= UDSliceSortedCoord;
  coord:=UDSliceSortedRawCoordClassIndex(n);
  if coord=-1 then Result:= false else Result:=true;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++Create ClassIndexToRepresentantArray for FlipUDSlice coordinate+++++++++
procedure CreateFlipUDSliceToRawFlipUDSliceTable;
var  c,d: CubieCube; i,j,k,n,classIdx,sym,byteOffset:Integer; prod: EdgeCubie;
     occupied: array of byte;
     fs: TFileStream;
const filename = 'RawFlipSlice';
//64430 classes, FlipSliceToRawFlipSlice[64429]=919506
const FREE = -1;
begin
  if FileExists(filename) then
  begin
    Application.ProcessMessages;
    fs := TFileStream.Create(filename, fmOpenRead);
    fs.ReadBuffer(FlipUDSliceToRawFlipUDSlice,64430*4);
    Form1.ProgressBar.Position:=10;
  end
  else
  begin
    SetLength(occupied,126720);//495*2048/8
    c:= CubieCube.Create;
    d:= CubieCube.Create;
    classIdx:=0;
    for i:=0 to 126720-1 do occupied[i]:= 0;
    Form1.SetUpProgressBar(0,495-1,'Creating '+filename+' (252 KB)');
    for i:=0 to 495-1 do
    begin
      Form1.ProgressBar.Position:=i;
      Application.ProcessMessages;
      c.InvUDSliceCoord(i);
      for j:= 0 to 256-1 do//256=2048/8
      begin
        byteOffset:=256*i+j;
        for k:= 0 to 7 do
        begin
          if (occupied[byteOffset] and (1 shl k))=0 then
          begin
            c.InvEdgeOriCoord(j shl 3 + k);
            FlipUDSliceToRawFlipUDSlice[classIdx]:= byteOffset shl 3 + k;
            Inc(classIdx);
            for sym:= 0 to 15 do //conjugate with all symmtries which preserve UD-slice
            begin
              EdgeMult(EdgeSym[InvIdx[sym]],c.PEdge^,prod);
              EdgeMult(prod,EdgeSym[sym],d.PEdge^);
              n:= 2048*d.UDSliceCoord + d.EdgeOriCoord;
              occupied[n shr 3]:= occupied[n shr 3] or (1 shl (n and 7));
            end;
          end;
        end;
      end;
    end;
    fs := TFileStream.Create(filename, fmCreate);
    fs.WriteBuffer(FlipUDSliceToRawFlipUDSlice,64430*4);//Integer has 4 Bytes
    c.Free;
    d.Free;
    Form1.SetUpProgressBar(0,100,'Loading...');
  end;
  fs.Free;
end;
//++++++End Create ClassIndexToRepresentantArray for FlipUDSlice coordinate+++++

//++++++Create ClassIndexToRepresentantArray for UDSliceSorted coordinate+++++++
procedure CreateSymUDSliceSortedToUDSliceSortedTable;
var  c,d: CubieCube; i,j,sym,n,idx:Integer;
     occupied: array of byte;
//788 classes
begin
  SetLength(occupied,1485);//11880/8
  c:= CubieCube.Create;
  d:= CubieCube.Create;
  Idx:=0;
  for i:= 0 to 1485-1 do occupied[i]:=0;
  for i:= 0 to 1485-1 do
  for j:= 0 to 7 do
  begin
    if (occupied[i] and (1 shl j))=0 then
    begin
      UDSliceSortedSymToUDSliceSorted[idx]:=i shl 3 +j;
      Inc(idx);
      c.InvUDSliceSortedCoord(i shl 3+j);
      for sym:= 0 to 15 do
      begin
        EdgeMult(EdgeSym[sym],c.PEdge^,d.PEdgeTemp^);
        EdgeMult(d.PEdgeTemp^,EdgeSym[InvIdx[sym]],d.PEdge^);
        n:=d.UDSliceSortedCoord;
        occupied[n shr 3]:= occupied[n shr 3] or (1 shl (n and 7));
      end;
    end;
  end;
  c.Free;
  d.Free;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//because we need the sym-corner permutation coordinate from the raw coordinate
//each time we compute the pruning depth in phase 2, we use this array++++++++++
procedure CreateSymCornPosToCornPosTable;
var prod: CornerCubie; c,d: CubieCube;
    classIdx,i,k,n: Integer;
const FREE = -1;
//2768 Klassen
begin
  c:= CubieCube.Create;
  d:= CubieCube.Create;
  classIdx:=0;
  for i:=0 to 40320-1 do CornPosToSymCornPos[i]:= FREE;
  for i:=0 to 40320-1 do
  begin
    if i and $ff=0 then Application.ProcessMessages;
    c.InvCornPermCoord(i);
    if CornPosToSymCornPos[i]=FREE then
    begin
      for k:= 0 to 15 do //conjugate with all symmtries which preserve UD-slice
      begin
        CornMult(CornSym[InvIdx[k]],c.PCorn^,prod);
        CornMult(prod,CornSym[k],d.PCorn^);
        n:= d.CornPermCoord;
        if CornPosToSymCornPos[n]=FREE then
           CornPosToSymCornPos[n]:= classIdx shl 4 + k;//pack classIdx and symmetry
        if k=0 then SymCornPosToCornPos[classIdx]:=n;
      end;
      Inc(classIdx);
    end;
  end;
  c.Free;
  d.Free;
  Form1.ProgressBar.Position:=20;
end;
//++++++++++++++++++++End CreateSymCornPosToCornPosTable++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure CreateClassIndexToRepresentantTables;
begin
  CreateFlipUDSliceToRawFlipUDSliceTable;
  CreateSymUDSliceSortedToUDSliceSortedTable;
  CreateSymCornPosToCornposTable;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.
