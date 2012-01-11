unit FaceCube;

interface
uses CubeDefs,Windows,Graphics,extctrls;
type
//++++++++++++++Classe for Cube on the Facelet Level++++++++++++++++++++++++++++
  FaceletCube = Class
  public
    Face1,Face2,FaceOrig,FaceOrigOpt,goalFace: FaceletColor;
    PFace,PFaceTemp,swap: ^FaceletColor;
    size: Integer;//3*size gives pixelnumber for one square in cube picture
    x,y: Integer;
    cv:TCanvas;//
    tripSearch: TObject;//for the two phase search;
    optSearch: TObject;// for the optimal search
    running,solver,runOptimal,selected,displayGoal,goalIsId:Boolean;
    patName,maneuver,optManeuver,hintInfo: string;
    optStartTime:TDateTime;//for measuring optimal solver time
    optLength:Integer;//Length of optimal Maneuver
    phase2Length:Integer;//Initial length of loaded maneuver

    procedure Move(x:TurnAxis);
    procedure Conjugate(s:Symmetry);
    procedure DrawCube(xOff,yOff:Integer);
    procedure Empty;
    procedure Clean;
    procedure SetFacelets(cCube:TObject);//cannot declare cCube as CubieCube here
    //because we cannot put CubiCube into the "uses"-section of interface part
    procedure Check(fc:Face);
    function InverseManeuver:String;
    function InverseOptManeuver:String;
    function IsIsomorphic(f:FaceletCube):Boolean;
    function HasSameGoal(f:FaceletCube):Boolean;
    function TwistOk:Boolean;
    function FlipOk:Boolean;

    constructor Create(cvas:TCanvas);overload;
    constructor Create(fc:FaceletCube;cvas:TCanvas;x,y,size:Integer);overload;
    constructor Create(man:String;cvas:TCanvas{pbox:TPaintBox});overload;
    end;

implementation

//+++++++++ FaceletCube +++++++++

uses  classes,SysUtils,RubikMain,CubiCube,Forms;



//+++++++++++++++++++++Draw parallelogram type 1 in cube picture++++++++++++++++
procedure drawPara1(c:TCanvas;x,y,l:Longint);
var p: Array[1..4] of TPoint;
begin
  p[1].X:=x;p[1].Y:=y;p[2].X:=x+3*l;p[2].Y:=y;p[3].X:=p[2].x-2*l;p[3].y:=p[2].y+2*l;
  p[4].X:=p[3].X -3*l;p[4].Y:=p[3].Y;
  c.Polygon(p);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++draw parralelogram type 2 in cube picture+++++++++++++
procedure drawPara2(c:TCanvas;x,y,l:Longint);
var p: Array[1..4] of TPoint;
begin
  p[1].X:=x;p[1].Y:=y;p[2].X:=x+2*l;p[2].Y:=y-2*l;p[3].X:=p[2].x;p[3].y:=p[2].y+3*l;
  p[4].X:=p[1].X;p[4].Y:=p[1].Y+3*l;
  c.Polygon(p);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++draw square in cube picture+++++++++++++++++++++++++++++++++
procedure drawSquare(c:TCanvas;x,y,l:Longint);
var p: Array[1..4] of TPoint;
begin
  p[1].X:=x;p[1].Y:=y;p[2].X:=x+3*l;p[2].Y:=y;p[3].X:=p[2].x;p[3].y:=p[2].y+3*l;
  p[4].X:=p[3].X -3*l;p[4].Y:=p[3].Y;
  c.Polygon(p);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++Constructor saves Canvas where the faceletcube draws itself+++++++++++++
constructor FaceletCube.Create(cvas:TCanvas);
begin
  cv:=cvas;//pb:=pbox;
  PFace:= @Face1;
  PFaceTemp:=@Face2;
  Clean;
  size:=10;
  x:=0;
  y:=0;
  tripSearch:=nil;
  optSearch:=nil;
  runOptimal:=false;
  selected:=false;
  phase2Length:=31;
  optManeuver:='Status: Not Running';
  optLength:= 30;//will allways be shorter
  displayGoal:=false;goalIsId:=true;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++Move on the facelet level+++++++++++++++++++++++++++++++++
procedure FaceletCube.Move(x: TurnAxis);
var i: Face;
begin
  swap:= PFace; PFace:= PFaceTemp; PFaceTemp:=swap;
  for i:=U1 to B9 do PFace^[FaceletMove[x,i]]:=PFaceTemp^[i];
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++conjugation by basic symmetry+++++++++++++++++++++++++
procedure FaceletCube.Conjugate(s: Symmetry);
var i: Face;
    reColor: array[UCol..BCol] of ColorIndex;
begin
  swap:= PFace;PFace:= PFaceTemp;PFaceTemp:=swap;
  case s of
  S_URF3:
  begin
  reColor[UCol]:=RCol;reColor[RCol]:=FCol;reColor[FCol]:=UCol;
  reColor[DCol]:=LCol;reColor[LCol]:=BCol;reColor[BCol]:=DCol;
  for i:=U1 to B9 do PFace^[FaceletSym[s,i]]:= reColor[PFaceTemp^[i]];
  end;
  S_F2:
  begin
  reColor[UCol]:=DCol;reColor[RCol]:=LCol;reColor[FCol]:=FCol;
  reColor[DCol]:=UCol;reColor[LCol]:=RCol;reColor[BCol]:=BCol;
  for i:=U1 to B9 do PFace^[FaceletSym[s,i]]:= reColor[PFaceTemp^[i]];
  end;
  S_U4:
  begin
  reColor[UCol]:=UCol;reColor[RCol]:=FCol;reColor[FCol]:=LCol;
  reColor[DCol]:=DCol;reColor[LCol]:=BCol;reColor[BCol]:=RCol;
  for i:=U1 to B9 do PFace^[FaceletSym[s,i]]:= reColor[PFaceTemp^[i]];
  end;
  S_LR2:
  begin
  reColor[UCol]:=UCol;reColor[RCol]:=LCol;reColor[FCol]:=FCol;
  reColor[DCol]:=DCol;reColor[LCol]:=RCol;reColor[BCol]:=BCol;
  for i:=U1 to B9 do PFace^[FaceletSym[s,i]]:= reColor[PFaceTemp^[i]];
  end;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++draw Cube on canvas++++++++++++++++++++++++++++++++++++++++++++
procedure FaceletCube.DrawCube(xOff,yOff:Integer);
var a,b,d:Integer;
    c:TCanvas;
    i:Face;
begin
  a:=0;b:=0;
  c:=cv;//cv is initialized in the constructor
  d:=size;
  for i:=U1 to B9 do
  begin
    c.Brush.Color:= Color[PFace^[i]];
    case i of
    L1..L9: drawSquare(c,x-xOff+d*3*a,y-yOff+d*(3*b+6),d);
    F1..F9: drawSquare(c,x-xOff+d*(3*a+9),y-yOff+d*(3*b+6),d);
    D1..D9: drawSquare(c,x-xOff+d*(3*a+9),y-yOff+d*(3*b+15),d);
    U1..U9: drawPara1(c,x-xOff+d*(3*a-2*b+15),y-yOff+d*2*b,d);
    R1..R9: drawPara2(c,x-xOff+d*(2*a+18),y-yOff+d*(-2*a+3*b+6),d);
    B1..B9: drawSquare(c,x-xOff+d*(3*a+24),y-yOff+d*3*b,d);
    end;
    inc(a);
    if a mod 3= 0 then begin a:=0; inc(b); end;
    if b = 3 then b:=0;
  end;

  if displayGoal then
  for i:=U1 to B9 do
  begin
    c.Brush.Color:= Color[goalFace[i]];
    case i of
    L1..L9: drawSquare(c,39*d+x-xOff+d*3*a,y-yOff+d*(3*b+6),d);
    F1..F9: drawSquare(c,39*d+x-xOff+d*(3*a+9),y-yOff+d*(3*b+6),d);
    D1..D9: drawSquare(c,39*d+x-xOff+d*(3*a+9),y-yOff+d*(3*b+15),d);
    U1..U9: drawPara1(c,39*d+x-xOff+d*(3*a-2*b+15),y-yOff+d*2*b,d);
    R1..R9: drawPara2(c,39*d+x-xOff+d*(2*a+18),y-yOff+d*(-2*a+3*b+6),d);
    B1..B9: drawSquare(c,39*d+x-xOff+d*(3*a+24),y-yOff+d*3*b,d);
    end;
    inc(a);
    if a mod 3= 0 then begin a:=0; inc(b); end;
    if b = 3 then b:=0;
    c.MoveTo(24*d+x-xOff,15*d+y-yOff);
    c.LineTo(34*d+x-xOff,15*d+y-yOff);
    c.LineTo(33*d+x-xOff,15*d+y-yOff-d);
    c.MoveTo(34*d+x-xOff,15*d+y-yOff);
    c.LineTo(33*d+x-xOff,15*d+y-yOff+d);
  end;
  c.Brush.Color:= clWhite;
end;
//++++++++++++++End draw cube on canvas+++++++++++++++++++++++++++++++++++++++++

//++++++++++++++Clear the facelet colors++++++++++++++++++++++++++++++++++++++++
procedure FaceletCube.Empty;
var i: Face;
begin
  for i:=U1 to U4 do PFace^[i]:=NoCol;
  for i:=R1 to R4 do PFace^[i]:=NoCol;
  for i:=F1 to F4 do PFace^[i]:=NoCol;
  for i:=D1 to D4 do PFace^[i]:=NoCol;
  for i:=L1 to L4 do PFace^[i]:=NoCol;
  for i:=B1 to B4 do PFace^[i]:=NoCol;

  for i:=U6 to U9 do PFace^[i]:=NoCol;
  for i:=R6 to R9 do PFace^[i]:=NoCol;
  for i:=F6 to F9 do PFace^[i]:=NoCol;
  for i:=D6 to D9 do PFace^[i]:=NoCol;
  for i:=L6 to L9 do PFace^[i]:=NoCol;
  for i:=B6 to B9 do PFace^[i]:=NoCol;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++Reset to clean cube+++++++++++++++++++++++++++++++++++++++++
procedure FaceletCube.Clean;
var i: Face;
begin
  for i:=U1 to U9 do PFace^[i]:=UCol;
  for i:=R1 to R9 do PFace^[i]:=RCol;
  for i:=F1 to F9 do PFace^[i]:=FCol;
  for i:=D1 to D9 do PFace^[i]:=DCol;
  for i:=L1 to L9 do PFace^[i]:=LCol;
  for i:=B1 to B9 do PFace^[i]:=BCol;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//facelet editor check for consistent coloring of cube each time facelet is set+
procedure FaceletCube.Check(fc:Face);
var i,j,k: Corner;
    i1,j1,k1: Edge;
    f: Face;
    freeCol,n,m,faceletMatch,ori: Integer;
    ci:ColorIndex;
    cCube:CubieCube;
begin
  if (Ord(fc) + Ord(fc) div 9) mod 2 = 0 then //check a corner
  begin
    for i:= URF to DRB do //get the involved corner
      if (CF[i,0]=fc) or (CF[i,1]=fc) or (CF[i,2]=fc) then break;
    freeCol:=0;//check how many facelets of the corner still are free
    for n:=0 to 2 do if PFace^[CF[i,n]]=NoCol then Inc(freeCol);
    case freeCol of
    1://check first, if corner exists
      begin
        for j:= URF to DRB do
        begin
          for m:=0 to 2 do
          begin
            faceletMatch:=0;
            for n:=0 to 2 do if (PFace^[CF[i,n]]=CCI[j,(n+m) mod 3]) then Inc(faceletMatch);
            if faceletMatch=2 then begin ori:=m; break; end;
          end;
          if faceletMatch=2 then break;
        end;
        if faceletMatch<>2 then //clear the other facelets assuming something is wrong
          begin for n:=0 to 2 do if CF[i,n]<>fc then PFace^[CF[i,n]]:= noCol; end
        else //now check if there is not already another cubie like this one
        begin
          for k:= URF to DRB do
          begin
            if k=i then continue;
            for m:=0 to 2 do
            begin
              faceletMatch:=0;
              for n:=0 to 2 do if
                (PFace^[CF[i,n]]<>noCol) and
                (PFace^[CF[i,n]]=PFace^[CF[k,(n+m) mod 3]]) then Inc(faceletMatch);
              if faceletMatch=2 then break;
            end;
            if faceletMatch=2 then break;
          end;
          if faceletMatch=2 then //clear the other cubie
            for n:=0 to 2 do PFace^[CF[k,n]]:= noCol;
          for n:=0 to 2 do PFace^[CF[i,n]]:=CCI[j,(n+ori) mod 3];//complete 3. facelet
        end;

      end;//1:
    0:
      begin
        for j:= URF to DRB do
        begin
          for m:=0 to 2 do
          begin
            faceletMatch:=0;
            for n:=0 to 2 do if (PFace^[CF[i,n]]=CCI[j,(n+m) mod 3]) then Inc(faceletMatch);
            if faceletMatch=3 then break;
          end;
          if faceletMatch=3 then break;
        end;
        if faceletMatch<>3 then //clear the other facelets assuming something is wrong
          begin for n:=0 to 2 do if CF[i,n]<>fc then PFace^[CF[i,n]]:= noCol; end
        else //now check if there is not already another cubie like this one
        begin
          for k:= URF to DRB do
          begin
            if k=i then continue;
            for m:=0 to 2 do
            begin
              faceletMatch:=0;
              for n:=0 to 2 do if
                (PFace^[CF[i,n]]<>noCol) and
                (PFace^[CF[i,n]]=PFace^[CF[k,(n+m) mod 3]]) then Inc(faceletMatch);
              if faceletMatch>1 then break;
            end;
            if faceletMatch>1 then break;
          end;
          if faceletMatch>1 then //clear the other cubie
            for n:=0 to 2 do PFace^[CF[k,n]]:= noCol;
        end;
       end;
    end;//case
  end
  else
  begin
    for i1:= UR to BR do //get the involved edge
      if (EF[i1,0]=fc) or (EF[i1,1]=fc) then break;
    freeCol:=0;//check how many facelets of the corner still are free
    for n:=0 to 1 do if PFace^[EF[i1,n]]=NoCol then Inc(freeCol);
    case freeCol of
    0:
      begin
        for j1:= UR to BR do
        begin
          for m:=0 to 1 do
          begin
            faceletMatch:=0;
            for n:=0 to 1 do if (PFace^[EF[i1,n]]=ECI[j1,(n+m) mod 2]) then Inc(faceletMatch);
            if faceletMatch=2 then break;
          end;
          if faceletMatch=2 then break;
        end;
        if faceletMatch<>2 then //clear the other facelets assuming something is wrong
          begin for n:=0 to 1 do if EF[i1,n]<>fc then PFace^[EF[i1,n]]:= noCol; end
        else //now check if there is not already another cubie like this one
        begin
          for k1:= UR to BR do
          begin
            if k1=i1 then continue;
            for m:=0 to 1 do
            begin
              faceletMatch:=0;
              for n:=0 to 1 do if
                (PFace^[EF[i1,n]]<>noCol) and
                (PFace^[EF[i1,n]]=PFace^[EF[k1,(n+m) mod 2]]) then Inc(faceletMatch);
              if faceletMatch>1 then break;
            end;
            if faceletMatch>1 then break;
          end;
          if faceletMatch>1 then //clear the other cubie
            for n:=0 to 1 do PFace^[EF[k1,n]]:= noCol;
        end;
       end;
    end;//case
  end;
  //check if all facelets are set
  faceletMatch:=0;
  for f:=U1 to B9 do if PFace^[f]=noCol then Inc(faceletMatch);
  if faceletMatch=0 then
  begin
    cCube:= CubieCube.Create(fCube.PFace^);
    n:= cCube.CornOriMod3;  //check orientations of corners
    if n>0 then
    begin
      Application.MessageBox(PChar(Err[1]),'Facelet Editor',MB_ICONWARNING);
      for m:= 1 to n do
      begin
        ci:=PFace^[CF[URF,0]];
        PFace^[CF[URF,0]]:=PFace^[CF[URF,1]];
        PFace^[CF[URF,1]]:=PFace^[CF[URF,2]];
        PFace^[CF[URF,2]]:=ci;
      end;
    end;
    n:= cCube.EdgeOriMod2;  //check orientations of edges
    if n=1 then
    begin
      Application.MessageBox(PChar(Err[2]),'Facelet Editor',MB_ICONWARNING);
      ci:=PFace^[EF[UF,0]];
      PFace^[EF[UF,0]]:=PFace^[EF[UF,1]];
      PFace^[EF[UF,1]]:=ci;
    end;
    if (cCube.EdgeParityEven and not cCube.CornParityEven) or
       (cCube.CornParityEven and not cCube.EdgeParityEven) then
    begin
      Application.MessageBox(PChar(Err[3]),'Facelet Editor',MB_ICONWARNING);
      ci:=PFace^[EF[UF,0]];
      PFace^[EF[UF,0]]:=PFace^[EF[DF,0]];
      PFace^[EF[DF,0]]:=ci;
      ci:=PFace^[EF[UF,1]];
      PFace^[EF[UF,1]]:=PFace^[EF[DF,1]];
      PFace^[EF[DF,1]]:=ci;
    end;
    cCube.Free;
  end;
end;
//End facelet editor check for consistent coloring of cube each time facelet is set

//+++++color facelelet cube according to a cube on the cubie level++++++++++++++
procedure FaceletCube.SetFacelets(cCube: TObject);
var cc:CubieCube; i: Corner; j: Edge; n: Integer;
begin
  cc:= cCube as CubieCube;
  for i:= URF to DRB do
  for n:= 0 to 2 do
   PFace^[CF[i,n]]:= CCI[cc.PCorn^[i].c,(n+3-cc.PCorn^[i].o) mod 3];
  for j:= UR to BR do
  for n:= 0 to 1 do PFace^[EF[j,n]]:= ECI[cc.PEdge^[j].e,(n+cc.PEdge^[j].o) mod 2];
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++sort of copy-constructor+++++++++++++++++++++++++++++++
constructor FaceletCube.Create(fc: FaceletCube; cvas:TCanvas;x,y,size:Integer);
var i:Face;
begin
 Create(cvas);
 for i:=U1 to B9 do PFace^[i]:=fc.PFace^[i];
 self.size:=size;self.x:=x;self.y:=y;
 runOptimal:=fc.runOptimal;
 optManeuver:=fc.optManeuver;
 maneuver:=fc.maneuver;
 patName:=fc.patName;
 phase2Length:=fc.phase2Length;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++create facelet cube from maneuver string++++++++++++++++++++++
constructor FaceletCube.Create(man:String;cvas:TCanvas);
var n,i,j,pow: integer;t:TurnAxis;
begin
  Create(cvas);
  n:= Pos('//',man);
  if n>0 then
  begin
    patName:=Trim(Copy(man,n+2,Length(man)));//all after '   ' is patName
    man:=Trim(Copy(man,1,n-1));
  end;
  if Pos('*)',man)>0 then
  begin
    optManeuver:=Copy(man,1,Pos('*)',man)+1);
    optManeuver:=InverseOptManeuver;//we need a solver
    runOptimal:=true;
  end
  else
  begin
    maneuver:=man;
    maneuver:=InverseManeuver;
  end;
  if Pos('(',man)>0 then man:=Copy(man,1,Pos('(',man)-1);
  man:=Trim(man);
  n:=Length(man);
  phase2Length:=0;
  t:=U;
  for i:= 1 to n do
  begin
    case man[i] of
      'U','u': t:=U;
      'R','r': t:=R;
      'F','f': t:=F;
      'D','d': t:=D;
      'L','l': t:=L;
      'B','b': t:=B;
    else
      continue;
    end;
    Inc(phase2Length);
    if i=n then begin Move(t); break; end;
    case man[i+1] of
      '3','''': pow:=3;
      '2': pow:=2;
    else
      pow:=1;
    end;
    for j:= 1 to pow do Move(t);
  end;
  if runOptimal=true then phase2Length:=31;//we have no 2-phase maneuver yet
end;

function FaceletCube.InverseManeuver: String;
var s:String;i,n:Integer;
begin
  n:=Length(maneuver);
  if n=0 then begin Result:='';exit;end;
  for i:=n downto 1 do
  begin
    case maneuver[i] of
      'U','R','F','D','L','B': s:=s+maneuver[i];
    else
      continue;
    end;
    if i=n then s:= s+''' '
    else
    begin
      case maneuver[i+1] of
        '3','''': s:=s+' ';
        '2': s:= s+'2 ';
      else
        s:=s+''' ';
      end;
    end;
  end;

  n:=Pos('(',maneuver);
  if n>0 then s:= s+' '+Copy(maneuver,n,Pos(')',maneuver)+1-n);
  Result:= s;
end;

function FaceletCube.InverseOptManeuver: String;
var s:String;i,n:Integer;
begin
  n:=Length(optManeuver);
  if n=0 then begin Result:='';exit;end;
  if Pos('Status',optManeuver)>0 then begin Result:=optManeuver;exit;end;
  for i:=n downto 1 do
  begin
    case optManeuver[i] of
      'U','R','F','D','L','B': s:=s+optManeuver[i];
    else
      continue;
    end;
    if i=n then s:= s+''' '
    else
    begin
      case optManeuver[i+1] of
        '3','''': s:=s+' ';
        '2': s:= s+'2 ';
      else
        s:=s+''' ';
      end;
    end;
  end;
  n:=Pos('(',optManeuver);
  if n>0 then s:= s+' '+Copy(optManeuver,n,Pos(')',optManeuver)+1-n);
  Result:=s;
end;
//++++++++++++End create facelet cube from maneuver string++++++++++++++++++++++

//+++++++++++++++++check if two faceletcubes are isomorohic+++++++++++++++++++++
function FaceletCube.IsIsomorphic(f: FaceletCube): Boolean;
var urf3,f2,u4,lr2:Integer; i:Face; isEqual:Boolean;
label ende;
begin
   for i:=U1 to B9 do FaceOrig[i]:= PFace^[i];
   for urf3:= 0 to 2 do //generate all 48 symmetries
   begin
     for f2:= 0 to 1 do
     begin
       for u4:= 0 to 3 do
       begin
         for lr2:= 0 to 1 do
         begin
           isEqual:=true;
           for i:=U1 to B9 do
             if PFace^[i]<>f.PFace^[i] then begin isEqual:=false;break;end;
           if isEqual and HasSameGoal(f) then begin Result:=true; goto ende;end;
           Conjugate(S_LR2);
         end;
          Conjugate(S_U4);
       end;
       Conjugate(S_F2);
     end;
     Conjugate(S_URF3);
   end;
   Result:=false;
ende:
  for i:=U1 to B9 do PFace^[i]:=FaceOrig[i];//restore
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++test if faceletcube f has the same goalcube++++++++++++++++++++++++++
function FaceletCube.HasSameGoal(f: FaceletCube): Boolean;
var isEqual:Boolean; i: Face;
begin
  isEqual:=true;
  for i:=U1 to B9 do
  if goalFace[i]<>f.goalFace[i] then begin isEqual:=false;break;end;
  Result:=isEqual;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++check if corner twist are ok++++++++++++++++++++++++++
function FaceletCube.TwistOk: Boolean;
var ori,j: Integer; i:Corner;
begin
  ori:=0;
  for i:= URF to DRB do
    for j:= 0 to 2 do
      if (PFace^[CF[i,j]]=UCol) or (PFace^[CF[i,j]]=DCol)then
      begin ori:=ori+j;break;end;
  if ori mod 3 = 0 then Result:=true else Result:=false;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++check if edge flip is ok++++++++++++++++++++++++++++
function FaceletCube.FlipOk: Boolean;
var ori: Integer; i:Edge;
begin
  ori:=0;
  for i:=UR to BR do
  begin
    if (PFace^[EF[i,0]]=UCol) or (PFace^[EF[i,0]]=DCol)then continue
    else if (PFace^[EF[i,1]]=UCol) or (PFace^[EF[i,1]]=DCol)then Inc(ori)
    else if (PFace^[EF[i,1]]=FCol) or (PFace^[EF[i,1]]=BCol)then Inc(ori);
  end;
  if ori mod 2 = 0 then Result:=true else Result:=false;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.



