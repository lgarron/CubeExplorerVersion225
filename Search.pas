unit Search;

interface

uses CubeDefs,Symmetries,CordCube,graphics,classes;

type
//+++++++++++++++Node in search tree++++++++++++++++++++++++++++++++++++++++++++
  Node = record
    axis:TurnAxis;
    power,UDIdx,UDSym,UDTwist,RLIdx,
    RLSym,RLTwist,FBIdx,FBSym,FBTwist: Integer;
    UDPrun,RLPrun,FBPrun:Integer;

    UDSliceSorted,RLSliceSorted,FBSliceSorted,
    edge8Pos,cornPos: Integer;//phase2 coordinates

    UDSliceSortedSymIdx,RLSliceSortedSymIdx,FBSliceSortedSymIdx,
    UDSliceSortedSymSym,RLSliceSortedSymSym,FBSliceSortedSymSym : Integer;
    UDPrunBig,RLPrunBig,FBPrunBig:Integer;
    UDFlip,RLFlip,FBFlip:Integer;
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++IDA object does the search+++++++++++++++++++++++++++++++++++++
  IDA = class(TThread)
  public
    n: array[0..31] of Node;//30 moves suffice!
    nodeCount,idCount: Int64;
    depth,depth2,maxLength,inValid,returnLength: Integer;
    runOptimal:Boolean;
    constructor Create(cc:CoordCube);overload;
    constructor Create(ia:Ida);overload;
    function Next2PhaseSolution:Integer;
    function NextSolution(maxLen:Integer):Integer;
    procedure NextPhase2Id;
    function IsIdCube:Boolean;

    function SolverString:String;

    procedure Execute; override;//for the thread
  end;

var GetPruningLength: array [0..18,0..2] of Integer;
procedure CreateGetPruningLengthTable;


implementation

uses RubikMain,CubiCube,SysUtils,Windows;

//+++++++++++create an IDA-object from a cube on coordinate level+++++++++++++++
constructor IDA.Create(cc: CoordCube);
begin

  inherited Create(true);//thread issues
  Priority:=tpLower;
  n[0].UDIdx:= cc.flipUDSlice.n;//initialize node
  n[0].UDSym:= cc.flipUDSlice.s;
  n[0].RLIdx:= cc.flipRLSlice.n;
  n[0].RLSym:= cc.flipRLSlice.s;
  n[0].FBIdx:= cc.flipFBSlice.n;
  n[0].FBSym:= cc.flipFBSlice.s;
  n[0].UDPrun:= cc.GetPrun(0);
  n[0].RLPrun:= cc.GetPrun(1);
  n[0].FBPrun:= cc.GetPrun(2);

  n[0].UDTwist:=cc.UDTwist;
  n[0].RLTwist:=cc.RLTwist;
  n[0].FBTwist:=cc.FBTwist;
  n[0].axis:=U;
  n[0].power:=0;

  depth:= 0;
  depth2:= 0;//in case we use two phase algorithm
  nodeCount:= 0;
  idCount:= 0;
  inValid:=0;

  maxLength:=31;
  returnLength:=-1;
  runOptimal:=false;//use two phase algorithm as default

  n[0].cornPos:= cc.cornPos;
  n[0].UDSliceSorted:=cc.UDSliceSorted;
  n[0].RLSliceSorted:=cc.RLSliceSorted;
  n[0].FBSliceSorted:=cc.FBSliceSorted;

//big solver coordinates

  n[0].UDSliceSortedSymIdx:=cc.UDSliceSortedSym.n;
  n[0].RLSliceSortedSymIdx:=cc.RLSliceSortedSym.n;
  n[0].FBSliceSortedSymIdx:=cc.FBSliceSortedSym.n;
  n[0].UDSliceSortedSymSym:=cc.UDSliceSortedSym.s;
  n[0].RLSliceSortedSymSym:=cc.RLSliceSortedSym.s;
  n[0].FBSliceSortedSymSym:=cc.FBSliceSortedSym.s;

  n[0].UDFlip:=cc.UDFlip;
  n[0].RLFlip:=cc.RLFlip;
  n[0].FBFlip:=cc.FBFlip;
  if USES_BIG then
  begin
    n[0].UDPrunBig:= cc.GetPrunBig(0);
    n[0].RLPrunBig:= cc.GetPrunBig(1);
    n[0].FBPrunBig:= cc.GetPrunBig(2);
  end;
end;
//+++++++End create IDA-object from cube on coordinate level++++++++++++++++++++

//+++++++++++++++++++find next solution of optimal solver+++++++++++++++++++++++
function IDA.NextSolution(maxLen: Integer):Integer;
var np,np1,np2: ^Node;
    x,r_depth: Integer;
    m: Move;
label incPower,turn,right,incAxis,checkNeighbourAxis,left,ende;
begin
  PostMessage(Form1.Handle,WM_NEXTLEVEL,Integer(self),depth+1);
  maxLength:=maxLen;
  np:= @n[depth];
  r_depth:=0;

incPower:
  Inc(np^.power);
  {$IF QTM}
  np1:=np; Dec(np1);
  if (np^.power=2) then Inc(np^.power);
  if (depth<>r_depth){have left neigbour} and (np1^.axis=np^.axis)
       and ((np1^.power=3) or (np^.power=3)) then goto incAxis;
   //only X*X, not X*X',X'*X or X'*X'
  {$IFEND}
  if (np^.power>3) then goto incAxis;

turn:
  np1:=np;
  Inc(np1);
  Inc(NodeCount);

  m:= Move(3*Ord(np^.axis) + np^.power - 1);

  if USES_BIG then
  begin
    np1^.UDTwist:= TwistMove[np^.UDTwist,m];
    x:= UDSliceSortedSymMove[np^.UDSliceSortedSymIdx,SymMove[np^.UDSliceSortedSymSym,m]];
    np1^.UDSliceSortedSymSym:=SymMult[x and 15,np^.UDSliceSortedSymSym];
    np1^.UDSliceSortedSymIdx:= x shr 4;
    np1^.UDFlip:= FlipMove[np^.UDFlip,m];

    m:= SymMove[16,m];
    np1^.RLTwist:= TwistMove[np^.RLTwist,m];
    x:= UDSliceSortedSymMove[np^.RLSliceSortedSymIdx,SymMove[np^.RLSliceSortedSymSym,m]];
    np1^.RLSliceSortedSymSym:=SymMult[x and 15,np^.RLSliceSortedSymSym];
    np1^.RLSliceSortedSymIdx:= x shr 4;
    np1^.RLFlip:= FlipMove[np^.RLFlip,m];

    m:= SymMove[16,m];
    np1^.FBTwist:= TwistMove[np^.FBTwist,m];
    x:= UDSliceSortedSymMove[np^.FBSliceSortedSymIdx,SymMove[np^.FBSliceSortedSymSym,m]];
    np1^.FBSliceSortedSymSym:=SymMult[x and 15,np^.FBSliceSortedSymSym];
    np1^.FBSliceSortedSymIdx:= x shr 4;
    np1^.FBFlip:= FlipMove[np^.FBFlip,m];

    np1^.UDPrunBig:= GetPruningLength[np^.UDPrunBig,
    GetPruningBigP((Int64(np1^.UDSliceSortedSymIdx)*2048+
    FlipConjugate[np1^.UDFlip,np1^.UDSliceSortedSymSym,np1^.UDSliceSortedSymIdx])*2187+
    TwistConjugate[np1^.UDTwist,np1^.UDSliceSortedSymSym])];

    np1^.RLPrunBig:= GetPruningLength[np^.RLPrunBig,
    GetPruningBigP((Int64(np1^.RLSliceSortedSymIdx)*2048+
    FlipConjugate[np1^.RLFlip,np1^.RLSliceSortedSymSym,np1^.RLSliceSortedSymIdx])*2187+
    TwistConjugate[np1^.RLTwist,np1^.RLSliceSortedSymSym])];

    np1^.FBPrunBig:= GetPruningLength[np^.FBPrunBig,
    GetPruningBigP((Int64(np1^.FBSliceSortedSymIdx)*2048+
    FlipConjugate[np1^.FBFlip,np1^.FBSliceSortedSymSym,np1^.FBSliceSortedSymIdx])*2187+
    TwistConjugate[np1^.FBTwist,np1^.FBSliceSortedSymSym])];

    if not Terminated then
    begin
//if we do the three possibles move on some fixed face in FTM, the three pruning value
//can only differ by 1, in QTM the pruning values for the two possible moves can
//differ by two. So the decision, when a new axis can be taken is different.

      if (r_depth>0) and (np1^.UDPrunBig=np1^.RLPrunBig)
                     and (np1^.RLPrunBig=np1^.FBPrunBig) then
      begin

    {$IF  QTM}
        if (np1^.UDPrunBig>r_depth+1)  then goto incAxis;
    {$ELSE}
        if (np1^.UDPrunBig>r_depth)  then goto incAxis;
    {$IFEND}

        if (np1^.UDPrunBig>r_depth-1)  then goto incPower;
      end;

    {$IF  QTM}
      if (np1^.UDPrunBig>r_depth+2) or (np1^.RLPrunBig>r_depth+2) or (np1^.FBPrunBig>r_depth+2) then goto incAxis;
    {$ELSE}
      if (np1^.UDPrunBig>r_depth+1) or (np1^.RLPrunBig>r_depth+1) or (np1^.FBPrunBig>r_depth+1) then goto incAxis;
    {$IFEND}

      if (np1^.UDPrunBig>r_depth) or (np1^.RLPrunBig>r_depth) or (np1^.FBPrunBig>r_depth) then goto incPower;
    end;
  end
  else//standard optimal solver
  begin
    np1^.UDTwist:= TwistMove[np^.UDTwist,m];
    x:= flipSliceMove[np^.UDIdx,Ord(SymMove[np^.UDSym,m])];
    np1^.UDSym:=SymMult[x and 15,np^.UDSym];
    np1^.UDIdx:= x shr 4;

    m:= SymMove[16,m];
    np1^.RLTwist:= TwistMove[np^.RLTwist,m];
    x:= flipSliceMove[np^.RLIdx,Ord(SymMove[np^.RLSym,m])];
    np1^.RLSym:=SymMult[x and 15,np^.RLSym];
    np1^.RLIdx:= x shr 4;

    m:= SymMove[16,m];
    np1^.FBTwist:= TwistMove[np^.FBTwist,m];

    x:= flipSliceMove[np^.FBIdx,Ord(SymMove[np^.FBSym,m])];
    np1^.FBSym:=SymMult[x and 15,np^.FBSym];
    np1^.FBIdx:= x shr 4;

    np1^.UDPrun:= GetPruningLength[np^.UDPrun,GetPruningP(2187*np1^.UDIdx + TwistConjugate[np1^.UDTwist,np1^.UDSym])];
    np1^.RLPrun:= GetPruningLength[np^.RLPrun,GetPruningP(2187*np1^.RLIdx + TwistConjugate[np1^.RLTwist,np1^.RLSym])];
    np1^.FBPrun:= GetPruningLength[np^.FBPrun,GetPruningP(2187*np1^.FBIdx + TwistConjugate[np1^.FBTwist,np1^.FBSym])];

    if not Terminated then
    begin
//if we do the three possibles move on some fixed face in FTM, the three pruning value
//can only differ by 1, in QTM the pruning values for the two possible moves can
//differ by two. So the decision, when a new axis can be taken is different.

      if (r_depth>0) and (np1^.UDPrun=np1^.RLPrun)
                     and (np1^.RLPrun=np1^.FBPrun) then
      begin

    {$IF  QTM}
        if (np1^.UDPrun>r_depth+1)  then goto incAxis;
    {$ELSE}
        if (np1^.UDPrun>r_depth)  then goto incAxis;
    {$IFEND}

        if (np1^.UDPrun>r_depth-1)  then goto incPower;
      end;

    {$IF  QTM}
      if (np1^.UDPrun>r_depth+2) or (np1^.RLPrun>r_depth+2) or (np1^.FBPrun>r_depth+2) then goto incAxis;
    {$ELSE}
      if (np1^.UDPrun>r_depth+1) or (np1^.RLPrun>r_depth+1) or (np1^.FBPrun>r_depth+1) then goto incAxis;
    {$IFEND}

      if (np1^.UDPrun>r_depth) or (np1^.RLPrun>r_depth) or (np1^.FBPrun>r_depth) then goto incPower;
    end;
  end;

  if (r_depth=0) then
  begin
    if Terminated then
    begin
      returnLength:=-2;
      Result:=returnLength; //abort
      goto ende;
    end;
    if (not IsIdCube) then goto incPower;
      returnLength:=depth+1;
      Result:=returnLength; //solution
      PostMessage(Form1.Handle,WM_NEXTLEVEL,Integer(self),depth+100);//TForm1.ShowNextLevel
    goto ende;
  end;
right:
  Dec(r_depth);
  Inc(np); np^.axis:= U;
  goto checkNeighbourAxis;

incAxis:
  if np^.axis=B then goto left;
  Inc(np^.axis);

checkNeighbourAxis:
  if depth<>r_depth then //else no left neighbour
  begin
    np1:=np; Dec(np1);
    {$IF not QTM}
    if (np^.axis=np1^.axis) then goto incAxis;//in FTM no successive moves with same axis
    {$ELSE}
     np2:=np1;Dec(np2);
     if (depth-r_depth>1) and //else no neighbour left of left neighbour
         (np^.axis= np1^.axis) and  (np^.axis= np2^.axis) then goto incAxis;
         //in QTM not three successive moves with same axis
    {$IFEND}
    if np^.axis<=F then
    if TurnAxis(Ord(np^.axis)+3)=np1^.axis then goto incAxis;//no D*U, L*R etc.
  end;
    np^.power:=1;
    goto turn;

left:
  if depth = r_depth then//depth is incremented
  begin
    if depth=maxLength-1 then
    begin
      Result:=-1;
      goto ende
    end;
    Inc(depth);Inc(r_depth);
    PostMessage(Form1.Handle,WM_NEXTLEVEL,Integer(self),depth+1);//Communicate
    nodeCount:=0; idCount:=0;
    np^.axis:=U; np^.power:=1;
    goto turn;
  end
  else
  begin
    Dec(np);
    Inc(r_depth);
    if inValid>depth-r_depth then inValid:=depth-r_depth;
    goto incPower;
  end;
ende:
end;
//++++++++++++++++End find next solution of optimal solver+++++++++++++++++++++++

//++++++++++++++++Check if the Phase 1 solution si a solved cube++++++++++++++++
function IDA.IsIdCube: Boolean;
var i: Integer;
    m:Move;
    np: ^Node;
label ende;

begin
 Inc(idCount);

 for i:=invalid to depth do
 begin
   m:= Move(3*Ord(n[i].axis) + n[i].power - 1);
   n[i+1].cornPos:=CornPermMove[n[i].cornPos,m];
   n[i+1].UDSliceSorted:=UDSliceSortedMove[n[i].UDSliceSorted,m];
   m:= SymMove[16,m];
   n[i+1].RLSliceSorted:=UDSliceSortedMove[n[i].RLSliceSorted,m];
   m:= SymMove[16,m];
   n[i+1].FBSliceSorted:=UDSliceSortedMove[n[i].FBSliceSorted,m];
 end;
 inValid:=depth;
 np:= @n[depth+1];
 if  (np^.cornPos=0) and(np^.UDSliceSorted=0) and  (np^.RLSliceSorted=0) and (np^.FBSliceSorted=0) then
   Result:=true
 else result:=false;

ende:
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++Find next solution for Two-Phase-Algorithm++++++++++++++++++++
function IDA.Next2PhaseSolution: Integer;

var np,np1,np2: ^Node;
    x,r_depth,temp: Integer;
    m: Move;
label incPower,turn,right,incAxis,checkNeighbourAxis,left,ende,phase2;
begin
 np:= @n[depth];
 r_depth:=0;
incPower:
  Inc(np^.power);
  {$IF QTM}
  np1:=np; Dec(np1);
  if (np^.power=2) then Inc(np^.power);
  if (depth<>r_depth){have left neigbour} and (np1^.axis=np^.axis)
       and ((np1^.power=3) or (np^.power=3)) then goto incAxis;
   //only X*X, not X*X',X'*X or X'*X'
  {$IFEND}
  if (np^.power>3) then goto incAxis;

turn:
  np1:=np;
  Inc(np1);
  Inc(NodeCount);

  m:= Move(3*Ord(np^.axis) + np^.power - 1);
  np1^.UDTwist:= TwistMove[np^.UDTwist,m];

  x:= flipSliceMove[np^.UDIdx,Ord(SymMove[np^.UDSym,m])];
  np1^.UDSym:=SymMult[x and 15,np^.UDSym];
  np1^.UDIdx:= x shr 4;

  np1^.UDPrun:= GetPruningLength[np^.UDPrun,GetPruningP(2187*np1^.UDIdx + TwistConjugate[np1^.UDTwist,np1^.UDSym])];

    {$IF  QTM}
      if (np1^.UDPrun>r_depth+2) then goto incAxis;
    {$ELSE}
      if (np1^.UDPrun>r_depth+1) then goto incAxis;
    {$IFEND}
  if (np1^.UDPrun>r_depth) or (( np1^.UDPrun=0) and (r_depth>0)) then goto incPower;
  //we deny phase2 states within phase1, so maybe we loose the best solution

  if (r_depth=0) then
  begin
phase2:

    if Terminated then
    begin
      returnLength:=-2;
      Result:=returnLength;
      goto ende;
    end;
    NextPhase2ID;
    case depth2 of
      -2: goto incPower;
      -3: goto incAxis;
      -4: goto left;
    end;
    if (depth=0) and (depth2=0) and (n[0].axis=U) and (n[0].power=1)
    and (n[1].axis=U) and (n[1].power=3) then // in case of Id cube
    begin
      returnLength:=2;
      Result:=2;
      goto ende;
    end;
// we do not allow UU,RR,FF,DU,DD,LL,LR,BB,BF between phase1 and 2
    if depth2>=0 then
    begin
      if n[depth].axis=n[depth+1].axis then goto incPower;
      if Ord(n[depth].axis)= Ord(n[depth+1].axis)+3 then goto incPower;
    end;
    returnLength:=depth+depth2+2;
    Result:=returnLength; //solution
    goto ende;
  end;
right:
  Dec(r_depth);
  Inc(np); np^.axis:= U;
  goto checkNeighbourAxis;

incAxis:
  if np^.axis=B then goto left;
  Inc(np^.axis);

checkNeighbourAxis:
  if depth<>r_depth then //else no left neighbour
  begin
    np1:=np; Dec(np1);
    {$IF not QTM}
    if (np^.axis=np1^.axis) then goto incAxis;//in FTM no successive moves with same axis
    {$ELSE}
     np2:=np1;Dec(np2);
     if (depth-r_depth>1) and //else no neighbour left of left neighbour
         (np^.axis= np1^.axis) and  (np^.axis= np2^.axis) then goto incAxis;
         //in QTM not three successive moves with same axis
    {$IFEND}
    if np^.axis<=F then
    if TurnAxis(Ord(np^.axis)+3)=np1^.axis then goto incAxis;//no D*U, L*R etc.
  end;
  np^.power:=1;
  goto turn;


    {$IF not QTM}
    if (np^.axis=np1^.axis) then goto incAxis;//in FTM no successive moves with same axis
    {$ELSE}
     np2:=np1;Dec(np2);
     if (depth-r_depth>1) and //else no neighbour left of left neighbour
         (np^.axis= np1^.axis) and  (np^.axis= np2^.axis) then goto incAxis;
         //in QTM not three successive moves with same axis
    {$IFEND}

left:
  if depth = r_depth then//depth is incremented
  begin
    nodeCount:=0; idCount:=0;
    if depth>=maxLength-1 then
    begin
      returnLength:=-1;
      Result:=returnLength; //no more solution
      goto ende
    end;
    Inc(depth);Inc(r_depth);
    np^.axis:=U; np^.power:=1;
    goto turn;
  end
  else
  begin
    Dec(np);
    Inc(r_depth);
    if inValid>depth-r_depth then inValid:=depth-r_depth;
    goto incPower;
  end;
ende:
end;
//++++++++++++++++End Find next solution for Two-Phase-Algorithm++++++++++++++++

//++++++++++++++++++++Find a Phase 2 solution+++++++++++++++++++++++++++++++++++
procedure IDA.NextPhase2ID;
var temp,i,r_depth,symCPos,sym: Integer;
     m: Move; np,np1: ^Node;
label ende,incPower,incAxis,turn,idCheck,right,checkNeighbourAxis,left;
begin
  np:= @n[depth+1];
//precheck only with corners

 for i:=inValid to depth do
 begin
   m:= Move(3*Ord(n[i].axis) + n[i].power - 1);
   n[i+1].cornPos:=CornPermMove[n[i].cornPos,m];
 end;
 temp:= PruningCornPermPh2[np^.cornPos];

 if temp> maxLength-(depth+1)+2 then begin depth2:=-4; goto ende; end;//no solution, go left
 if temp> maxLength-(depth+1)+1 then begin depth2:=-3; goto ende; end;//no solution, new axis
 if temp> maxLength-(depth+1) then begin depth2:=-2; goto ende; end;//no solution, new power

//generate phase2 coordinates

 for i:=inValid to depth do
 begin
   m:= Move(3*Ord(n[i].axis) + n[i].power - 1);
//   n[i+1].cornPos:=CornPermMove[n[i].cornPos,m];
   n[i+1].UDSliceSorted:=UDSliceSortedMove[n[i].UDSliceSorted,m];
   m:= SymMove[16,m];
   n[i+1].RLSliceSorted:=UDSliceSortedMove[n[i].RLSliceSorted,m];
   m:= SymMove[16,m];
   n[i+1].FBSliceSorted:=UDSliceSortedMove[n[i].FBSliceSorted,m];
 end;
 inValid:=depth;
// np:= @n[depth+1];
 np^.edge8Pos:= GetEdge8Perm[np^.RLSliceSorted,np^.FBSliceSorted mod 24];
 if  (np^.edge8Pos=0) and  (np^.UDSliceSorted=0) and (np^.cornPos=0) then
 begin
   depth2:=-1;//no phase 2 necessary
   goto ende;
 end;

 np^.UDPrun:= GetPrunPhase2(np^.cornPos,np^.edge8Pos);//check if a sufficient short

 temp:= np^.UDPrun;
 if temp> maxLength-(depth+1)+2 then begin depth2:=-4; goto ende; end;//no solution, go left
 if temp> maxLength-(depth+1)+1 then begin depth2:=-3; goto ende; end;//no solution, new axis
 if temp> maxLength-(depth+1) then begin depth2:=-2; goto ende; end;//no solution, new power

 r_depth:=0;
 depth2:=0;
 np^.power:=0;
 np^.axis:=U;


incPower:
  Inc(np^.power);
  if (np^.axis<>U) and (np^.axis<>D) then Inc(np^.power);
  if (np^.power>3) then goto incAxis;

turn:
  np1:=np;
  Inc(np1);
  m:= Move(3*Ord(np^.axis) + np^.power - 1);

  np1^.cornPos:= CornPermMove[np^.cornPos,m];
  np1^.edge8Pos:= Edge8PermMove[np^.edge8Pos,m];
  symCPos:= CornPosToSymCornPos[np1^.cornPos];
  sym:= symCPos and $f;
  symCPos:=symCPos shr 4;
  np1^.UDPrun:= GetPruningLength[np^.UDPrun,GetPruningPhase2P(2768*Edge8PosConjugate[np1^.edge8Pos,sym] + symCPos)];

  if (np1^.UDPrun>r_depth+1) then goto incAxis;
  if (np1^.UDPrun>r_depth) then goto incPower;

  if (r_depth=0) then
  begin
idcheck:
    temp:=n[depth+1].UDSliceSorted;
    for i:=depth+1 to depth+1+depth2 do
    begin
      m:= Move(3*Ord(n[i].axis) + n[i].power - 1);
      temp:= UDSliceSortedMove[temp,m];
    end;
    if temp=0 then goto ende else goto incPower;

  end;
right:
  Dec(r_depth);
  Inc(np); np^.axis:= U;
  goto checkNeighbourAxis;

incAxis:
  if np^.axis=B then goto left;
  Inc(np^.axis);

checkNeighbourAxis:
  if depth2<>r_depth then //else no left neighbour
  begin
    np1:=np; Dec(np1);
    if (np^.axis=np1^.axis) then goto incAxis;//no UU etc.
    if np^.axis<=F then
    if TurnAxis(Ord(np^.axis)+3)=np1^.axis then goto incAxis;//no DU etc.
  end;
    np^.power:=1;
    if (np^.axis<>U) and (np^.axis<>D) then Inc(np^.power);
    goto turn;

left:
  if depth2 = r_depth then//depth2 is incremented
  begin
    nodeCount:=0; idCount:=0;
    if depth2>=maxLength-depth-2 then //no solution <= maxLen
    begin
      depth2:=-2;//use this to signal no solution
      goto ende
    end;
    Inc(depth2);Inc(r_depth);
    np^.axis:=U; np^.power:=1;
    goto turn;
  end
  else
  begin
    Dec(np);
    Inc(r_depth);
    goto incPower;
  end;
ende:
end;
//++++++++++++++++++++End Find a Phase 2 solution+++++++++++++++++++++++++++++++

//+++++++++Generate Solver String from node representation++++++++++++++++++++++
function IDA.SolverString:String;
var i,x: Integer;
    s: String;
begin
 x:=0;
 i:=0;
 while i<returnlength do
 begin
   if (i<returnlength-1) and (n[i].axis=n[i+1].axis)
   and (n[i].power=1) and (n[i+1].power=1) then  //happens in QTM
   begin
     case n[i].axis of
       U: s:=s+'U2 ';
       R: s:=s+'R2 ';
       F: s:=s+'F2 ';
       D: s:=s+'D2 ';
       L: s:=s+'L2 ';
       B: s:=s+'B2 ';
     end;
     Inc(i);Inc(i);continue;
   end;
   case n[i].axis of
     U: s:=s+'U';
     R: s:=s+'R';
     F: s:=s+'F';
     D: s:=s+'D';
     L: s:=s+'L';
     B: s:=s+'B';
   end;
   case n[i].power of
     1: s:=s+' ';
     2: begin s:=s+'2 ';Inc(x); end;
     3: s:=s+chr(39)+' ';
   end;
   Inc(i);
 end;
 {$IF QTM}
 s:=s+' ('+IntToStr(returnLength+x)+'q)';
 {$ELSE}
 s:=s+' ('+IntToStr(returnLength)+'f)';
 {$IFEND}
 Result:=s;
end;
//+++++++++Generate Solver String from node representation++++++++++++++++++++++


//Generate a table which gives the new pruning value from the old value and+++++
//the new value mod 3+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure CreateGetPruningLengthTable;
var i,j,diff:Integer;
begin
  for i:= 0 to 18 do
  for j:= 0 to 2 do
  begin
    diff:=j-i mod 3;
    if diff<0 then diff:=diff+3;
    case diff of
      2: GetPruningLength[i,j]:=i - 1;
      1: GetPruningLength[i,j]:=i + 1;
      0: GetPruningLength[i,j]:=i;
    end;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++Run Search until maneuver lenght <= maxmoves+++++++++++++++++++++++++
procedure IDA.Execute;
begin
  if runOptimal then
  begin
    NextSolution(31)
  end
  else
  repeat
  Next2PhaseSolution;
  until returnlength<=maxMoves;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++Initialize Structure for  IDA search+++++++++++++++++++++++++
constructor IDA.Create(ia: Ida);
var i: Integer;
begin
  inherited Create(true);//do no start
  Priority:=tpLower;
  for i:=0 to 31 do
  begin
    n[i].UDIdx:= ia.n[i].UDIdx;
    n[i].UDSym:= ia.n[i].UDSym;
    n[i].RLIdx:= ia.n[i].RLIdx;
    n[i].RLSym:= ia.n[i].RLSym;
    n[i].FBIdx:= ia.n[i].FBIdx;
    n[i].FBSym:= ia.n[i].FBSym;
    n[i].UDPrun:= ia.n[i].UDPrun;
    n[i].RLPrun:= ia.n[i].RLPrun;
    n[i].FBPrun:= ia.n[i].FBPrun;
    n[i].UDTwist:= ia.n[i].UDTwist;
    n[i].RLTwist:= ia.n[i].RLTwist;
    n[i].FBTwist:= ia.n[i].FBTwist;
    n[i].axis:= ia.n[i].axis;
    n[i].power:= ia.n[i].power;
    n[i].cornPos:= ia.n[i].cornPos;
    n[i].UDSliceSorted:=ia.n[i].UDSliceSorted;
    n[i].RLSliceSorted:=ia.n[i].RLSliceSorted;
    n[i].FBSliceSorted:=ia.n[i].FBSliceSorted;

    n[i].UDSliceSortedSymIdx:=ia.n[i].UDSliceSortedSymIdx;
    n[i].RLSliceSortedSymIdx:=ia.n[i].RLSliceSortedSymIdx;
    n[i].FBSliceSortedSymIdx:=ia.n[i].FBSliceSortedSymIdx;
    n[i].UDSliceSortedSymSym:=ia.n[i].UDSliceSortedSymSym;
    n[i].RLSliceSortedSymSym:=ia.n[i].RLSliceSortedSymSym;
    n[i].FBSliceSortedSymSym:=ia.n[i].FBSliceSortedSymSym;
    n[i].UDFlip:=ia.n[i].UDFlip;
    n[i].RLFlip:=ia.n[i].RLFlip;
    n[i].FBFlip:=ia.n[i].FBFlip;
    n[i].UDPrunBig:=ia.n[i].UDPrunBig;
    n[i].RLPrunBig:=ia.n[i].RLPrunBig;
    n[i].FBPrunBig:=ia.n[i].FBPrunBig;

    depth:= ia.depth;
    depth2:= ia.depth2;
    nodeCount:= ia.nodeCount;
    idCount:= ia.idCount;
    inValid:= ia.inValid;
    maxLength:= ia.maxLength;
    returnLength:=ia.returnLength;
    runOptimal:=false;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
end.
