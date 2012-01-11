unit OptSearch;
interface
  uses FaceCube,Search,classes,CordCube;

type

//+++++++++++++Class for Optimal Search+++++++++++++++++++++++++++++++++++++++++
  OptimalSearch = class
  public
    idaU,idaOldU:Ida;
    coU: CoordCube;
    f:FaceletCube;
    function NextSolution: Integer;
    constructor Create(faCube:FaceletCube);
    procedure OptSearchNotify(Sender: TObject);
    procedure Kill;
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

implementation
 uses CubiCube,CubeDefs,Symmetries,RubikMain,SysUtils,Windows;

//+++++++++++++++++++++++++++++++++Constructor++++++++++++++++++++++++++++++++++
constructor OptimalSearch.Create(faCube: FaceletCube);
var cu,cugoal:CubieCube;i:Face;
begin
  f:=faCube;
  for i:=U1 to B9 do f.faceOrigOpt[i]:= f.PFace^[i];//save original state if we use popup menu while computing
  cu:=CubieCube.Create(faCube.PFace^);//if we want A*X=B we solve B^-1* A= ID
  cugoal:=CubieCube.Create(faCube.goalFace);
  CornInv(cugoal.PCorn^,cugoal.PCornTemp^);
  CornMult(cugoal.PCornTemp^,cu.PCorn^,cu.PCornTemp^);
  cu.cSwap:=cu.PCorn;cu.PCorn:=cu.PCornTemp;cu.PCornTemp:=cu.cSwap;
  EdgeInv(cugoal.PEdge^,cugoal.PEdgeTemp^);
  EdgeMult(cugoal.PEdgeTemp^,cu.PEdge^,cu.PEdgeTemp^);
 cu.eSwap:=cu.PEdge;cu.PEdge:=cu.PEdgeTemp;cu.PEdgeTemp:=cu.eSwap;
  coU:=CoordCube.Create(cu);
  idaU:=nil;
  cu.Free;cugoal.Free;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function OptimalSearch.NextSolution: Integer;
begin
  if idaU=nil then
  begin
    idaU:=Ida.Create(coU);
    idaOldU:=nil;
    coU.Free;
  end
  else
  begin
    idaOldU:=idaU;
    idaU:=Ida.Create(idaU);
  end;
  idaU.OnTerminate:= OptSearchNotify;
  idaU.maxLength:=31;
  idaU.runOptimal:=true;
  idaU.Resume;
  Result:=0;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++Kill Thread+++++++++++++++++++++++++++++++++++++++++++
procedure OptimalSearch.Kill;
begin
  if idaU<>nil then idaU.Terminate;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++Called when thread terminates+++++++++++++++++++++++++++++++++++
procedure OptimalSearch.OptSearchNotify(Sender: TObject);
var l: Integer; ia:Ida;s:String; i:Face;
begin
  ia:= Sender as Ida;
  l:=ia.returnLength;
  if (l>=0) then
  begin
    s:=ia.SolverString;
    if l<f.optLength then f.optLength:=l;//happens for first solution
    if l<=f.optLength then Insert('*',s,Length(s));//'*' means optimality
    f.optManeuver:=s;
    for i:= U1 to B9 do f.PFace^[i]:=f.faceOrigOpt[i];//restore in case of right popup menu use
    Form1.dirty:=true;
  end
  else if Pos('Status',f.optManeuver)>0 then f.optManeuver:='Status: Not running';
  Form1.OutPut.Invalidate;
  f.running:=false; //stop
  idaOldU.free;//doesnt matter if nil
  for l:= 0 to MAXNUM do
  begin
    if ButRun[l].Tag>=0 then if fc[ButRun[l].Tag]=f then
    begin
      ButRun[l].Glyph:=Form1.BMRun;
      break;
    end;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.



