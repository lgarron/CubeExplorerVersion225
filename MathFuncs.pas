unit MathFuncs;

interface

function Cnk(n,k:Integer):Integer;

implementation

//+++++++++++++++++n choose k+++++++++++++++++++++++++++++++++++++++++++++++++++
function Cnk(n,k:Integer): Integer;
var s,j: Integer;
begin
  if n<k then Result:=0
  else
  begin
    s:=1;
    if (k>n div 2) then k:= n-k;
    for j:=1 to k do
    begin
      s:= (s*n) div j;
      n:=n-1;
    end;
    Result:= s;
  end;
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


end.
