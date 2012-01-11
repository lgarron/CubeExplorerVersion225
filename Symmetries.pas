unit Symmetries;

interface
uses CubeDefs;
//+++++++++corner and edge permutations/orientations of the 48 symmetries+++++++
var CornSym: array [SymIdx] of CornerCubie;
    EdgeSym: array [SymIdx] of EdgeCubie;

//++++++++++++++++++S(Idx)*S(InvIdx[Idx])= ID+++++++++++++++++++++++++++++++++++
    InvIdx: array [SymIdx] of SymIdx;

//++++++++++++++Group table for the symmetries++++++++++++++++++++++++++++++++++
    SymMult: array[SymIdx,SymIdx] of SymIdx;

//+++++++++++conjugation S(SymIdx]*M*S(SymIdx)^-1+++++++++++++++++++++++++++++++
    SymMove: array[SymIdx,Move] of Move;

procedure CreateSymmetryTables;
function MT(m:String;sym:Symmetry):String;

implementation
uses CubiCube,SysUtils;

//++++++++++++++++inititalize arrays CornSym and EdgeSym++++++++++++++++++++++++
procedure CreateSymmetries;
var cCube: CubieCube; i: Corner; e: Edge; index,urf3,f2,u4,lr2,j,k: Integer;
    c:CornerCubie;
begin
   cCube:= CubieCube.Create;
   index:=0;
   for urf3:= 0 to 2 do //generate all 48 symmetries
   begin
     for f2:= 0 to 1 do
     begin
       for u4:= 0 to 3 do
       begin
         for lr2:= 0 to 1 do
         begin
           for i:=URF to DRB do
           begin
             CornSym[index,i].c:=cCube.PCorn^[i].c;
             CornSym[index,i].o:=cCube.PCorn^[i].o;
           end;
           for e:=UR to BR do
           begin
             EdgeSym[index,e].e:=cCube.PEdge^[e].e;
             EdgeSym[index,e].o:=cCube.PEdge^[e].o;
           end;
           inc(index);
           cCube.Conjugate(S_LR2);
         end;
         cCube.Conjugate(S_U4);
       end;
       cCube.Conjugate(S_F2);
     end;
     cCube.Conjugate(S_URF3);
   end;
   //now find the inverse symmetries
   for j:=0 to 47 do
   for k:= 0 to 47 do
   begin
     CornMult(CornSym[j],CornSym[k],c);
     if (c[URF].c=URF) and (c[UFL].c=UFL) and (c[ULB].c=ULB) then
     begin InvIdx[j]:=k; break; end;
   end;
   cCube.Free;
end;
//++++++++++++End inititalize arrays CornSym and EdgeSym++++++++++++++++++++++++

//++++++++++++++++++++++++++++Initialize array SymMult++++++++++++++++++++++++++
procedure CreateSymmetryGroupTable;
var i,j,k: SymIdx; corn:CornerCubie;
begin
  for i:= 0 to 47 do
  for j:= 0 to 47 do
  begin
    CornMult(CornSym[i],CornSym[j],corn);
    for k:= 0 to 47 do
    begin
      if (CornSym[k,URF].c=corn[URF].c)  and (CornSym[k,UFL].c=corn[UFL].c)
          and (CornSym[k,ULB].c=corn[ULB].c)  then
      begin
        SymMult[i,j]:=k;
        break;
      end;
    end;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++Check if if corners are in their place+++++++++++++++++++++++++
function IsCornID(cc:CubieCube): Boolean;
var i: Corner;
begin
  Result:=True;
  for i:=URF to DRB do
  if (cc.PCorn^[i].c<>i) or (cc.PCorn^[i].o<>0) then
  begin
    Result:=False;
    break;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++create images of the moves by conjugation with symmetries++++++++++++
procedure CreateSymMoveTable;
var c1,c2: CubieCube;prod: CornerCubie;j,m: TurnAxis;k,n: Integer;s: SymIdx;
begin
  c1:= CubieCube.Create;
  c2:= CubieCube.Create;
  for j:= U to B do
  begin
    for k:= 0 to 3 do
    begin
      c1.Move(j);
      if k<>3 then
      begin
        for s:= 0 to 47 do
        begin
          CornMult(CornSym[s],c1.PCorn^,prod);//conjugate
          CornMult(prod,CornSym[InvIdx[s]],c2.PCorn^);
          for m:= U to B do//find the move
          begin
            for n:= 0 to 3 do
            begin
              c2.Move(m);
              if n<>3 then if IsCornID(c2) then
                SymMove[s,Move(3*Ord(j)+k)]:=Move(3*Ord(m)+(2-n));
            end;
          end;
        end;
      end;
    end;
  end;
  c1.Free;
  c2.Free;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure CreateSymmetryTables;
begin
  CreateSymmetries;
  CreateSymmetryGroupTable;
  CreateSymMoveTable;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++Transform maneuver strings according to symmetry conjugation+++++++++
function MT(m:String;sym:Symmetry):String;
var t: array[' '..'U'] of Char;s,r:String; mv:set of 'B'..'U';i,n:Integer;
begin
  s:=m;
  mv:=['U','R','F','D','L','B'];
  case sym of
  S_URF3:
  begin
   t['U']:='R';t['R']:='F';t['F']:='U';t['D']:='L';t['L']:='B';t['B']:='D';
  end;
  S_F2:
  begin
   t['U']:='D';t['D']:='U';t['R']:='L';t['L']:='R';t['F']:='F';t['B']:='B';
  end;
  S_U4:
  begin
   t['U']:='U';t['D']:='D';t['R']:='F';t['F']:='L';t['L']:='B';t['B']:='R';
  end;
  S_LR2:
  begin
    t['U']:='U';t['D']:='D';t['R']:='L';t['L']:='R';t['F']:='F';t['B']:='B';
  end;
  end;
  for i:=1 to Length(m) do
    if m[i] in mv then
    s[i]:=t[m[i]] else
    s[i]:=m[i];

  if sym=S_LR2 then //change the move direction
  begin //
    n:=Length(s);
    for i:= 1 to n do
    begin
      case s[i] of
        'U','R','F','D','L','B': r:=r+s[i];
      else
        continue;
      end;
      if i=n then s:= s+''' '
      else
      begin
        case s[i+1] of
          '3','''': r:=r+' ';
          '2': r:= r+'2 ';
        else
          r:=r+''' ';
        end;
      end;
    end;
    n:=Pos('(',s);
    if n>0 then r:= r+' '+Copy(s,n,Pos(')',s)+1-n);
    Result:= r
  end
  else Result:=s;
end;
//+++++End Transform maneuver strings according to symmetry conjugation+++++++++

end.
