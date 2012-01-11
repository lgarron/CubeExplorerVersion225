unit TripSearch;
interface
  uses FaceCube,Search,classes,CordCube;

type
//+++++class which allows to apply the Two-Phase-Algorithm in parallel in three
//directions+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  TripleSearch = class
  public
    idaU,idaR,idaF:Ida;
    idaOldU,idaOldR,idaOldF:Ida;
    coU,coR,coF: CoordCube;
    done:Integer;
    f:FaceletCube;
    length,l:Integer;
    useTrip:Boolean;
    function NextSolution:Integer;
    constructor Create(faCube:FaceletCube);
    procedure TripSearchNotify(Sender: TObject);
    procedure Kill;
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

implementation
 uses CubiCube,CubeDefs,Symmetries,RubikMain,SysUtils,Windows,Forms;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
constructor TripleSearch.Create(faCube: FaceletCube);
var cu,cugoal:CubieCube; prodE: EdgeCubie; prodC:CornerCubie;
begin
  useTrip:=useTriple;//useTripel is a global variable
  f:=faCube;
  cu:=CubieCube.Create(faCube.PFace^);//if we want A*X=B we solve B^-1* A= ID
  cugoal:=CubieCube.Create(faCube.goalFace);
  CornInv(cugoal.PCorn^,cugoal.PCornTemp^);
  CornMult(cugoal.PCornTemp^,cu.PCorn^,cu.PCornTemp^);
  cu.cSwap:=cu.PCorn;cu.PCorn:=cu.PCornTemp;cu.PCornTemp:=cu.cSwap;
  EdgeInv(cugoal.PEdge^,cugoal.PEdgeTemp^);
  EdgeMult(cugoal.PEdgeTemp^,cu.PEdge^,cu.PEdgeTemp^);
  cu.eSwap:=cu.PEdge;cu.PEdge:=cu.PEdgeTemp;cu.PEdgeTemp:=cu.eSwap;

  coU:=CoordCube.Create(cu);
  EdgeMult(EdgeSym[16],cu.PEdge^,prodE); //Apply S_URF3*X*S_URF3^-1 to edges
  EdgeMult(prodE,EdgeSym[InvIdx[16]],cu.PEdge^);
  CornMult(CornSym[16],cu.PCorn^,prodC); //Apply S_URF3*X*S_URF3^-1 to corners
  CornMult(prodC,CornSym[InvIdx[16]],cu.PCorn^);
  coR:=CoordCube.Create(cu);

  EdgeMult(EdgeSym[16],cu.PEdge^,prodE);
  EdgeMult(prodE,EdgeSym[InvIdx[16]],cu.PEdge^);
  CornMult(CornSym[16],cu.PCorn^,prodC);
  CornMult(prodC,CornSym[InvIdx[16]],cu.PCorn^);
  coF:=CoordCube.Create(cu);

  idaU:=nil;
  idaR:=niL;
  idaF:=nil;
  length:=faCube.phase2Length-1;
  cu.Free;cugoal.Free;
end;
//++++++++++++++++End constructor+++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++terminate threads+++++++++++++++++++++++++++++++++++++++
procedure TripleSearch.Kill;
begin
  if idaU<>nil then
  begin
   idaU.Terminate;
   idaR.Terminate;
   idaF.Terminate;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++initialize and start IDA objects+++++++++++++++++++++++++++++++++++++
function TripleSearch.NextSolution: Integer;
begin
  done:=0;
  if idaU=nil then
  begin
    idaU:=Ida.Create(coU);
    idaR:=Ida.Create(coR);
    idaF:=Ida.Create(coF);
    idaOldU:=nil;idaOldR:=nil;idaOldF:=nil;
    coU.Free;
    coR.Free;
    coF.free;
  end
  else
  begin
    idaOldU:=idaU;
    idaU:=Ida.Create(idaU);
    if usetrip then
    begin
      idaOldR:=idaR;
      idaOldF:=idaF;
      idaR:=Ida.Create(idaR);
      idaF:=Ida.Create(idaF);
    end;
  end;
  idaU.OnTerminate:= TripSearchNotify;
  idaU.maxLength:=length;
  if usetrip then
  begin
    idaR.OnTerminate:= TripSearchNotify;
    idaF.OnTerminate:= TripSearchNotify;
    idaR.maxLength:=length;
    idaF.maxLength:=length;
  end;
    idaU.Resume;
  if usetrip then
  begin
    idaR.Resume;
    idaF.Resume;
  end;
  Result:=0;
end;
//+++++++++End initialize and start IDA objects+++++++++++++++++++++++++++++++++

//++++++++++++++Called if execute method of thread returns++++++++++++++++++++++
procedure TripleSearch.TripSearchNotify(Sender: TObject);
var n: Integer;ia:Ida; i:Face;
begin
  Inc(done);//the routine will be called three times on triple search
  if done=1 then
  begin
    ia:= Sender as Ida;
    l:=ia.returnLength;
    if l=-1 then
    begin
      Application.MessageBox(PChar(Err[5]),'Maneuver Window',MB_ICONWARNING);
      length:=-1;//nothing more to find
    end;
     if (l>=0) and (l<=length) then
     begin
      Form1.dirty:=true;
      length:=l-1;//new maximal length for next search
       if ia=idaU then
         f.maneuver:=ia.SolverString
       else if ia=idaR then
         f.maneuver:=MT(ia.SolverString,S_URF3)
       else if ia= idaF then
        f.maneuver:=MT(MT(ia.SolverString,S_URF3),S_URF3);

       for i:= U1 to B9 do f.PFace^[i]:=f.faceOrig[i];//restore in case of right popup menu use
       Form1.Output.Invalidate; Form1.Output.Update; //both necessary
    end;
    Kill;
    if not usetrip then done:=3;
  end;

  if done=3 then
  begin
    idaOldU.free;
    if usetrip then
    begin
      idaOldR.free;
      idaOldF.free;
    end;

    if l>StopAt then //options menu
    PostMessage(Form1.Handle,WM_NEXTSEARCH,0,Integer(f.tripSearch))//trigger next search
    else
    begin
      f.running:=false; //stop
      for n:= 0 to MAXNUM do
      begin
        if ButRun[n].Tag>=0 then if fc[ButRun[n].Tag]=f then
        begin
          ButRun[n].Glyph:=Form1.BMRun;//display green arrow
          break;
        end;
      end;
    end;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.
