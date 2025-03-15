unit FileWork;

interface

uses
  CandyTypes;

procedure SaveToFile(TypeOfCandys: TTypeOfCandysAdr; Road: String); overload;
procedure SaveToFile(Candys: TCandysAdr; Road: String); overload;
function LoadFromFile(var TypeOfCandy: TTypeOfCandysAdr; Road: String)
  : Integer; overload;
  function LoadFromFile(var Candy: TCandysAdr; Road: String)
  : Integer; overload;

implementation

type

  TFileTypeOfCandy = File of TTypeOfCandysInf;
  TFileCandy = File of TCandysInf;

procedure SaveToFile(TypeOfCandys: TTypeOfCandysAdr; Road: String); overload;
var
  Save: TFileTypeOfCandy;
begin
  AssignFile(Save, Road);
  Rewrite(Save);
  While TypeOfCandys^.Adr <> nil do
  begin
    TypeOfCandys := TypeOfCandys^.Adr;
    Write(Save, TypeOfCandys^.Inf);
  end;
  Close(Save);
end;

procedure SaveToFile(Candys: TCandysAdr; Road: String); overload;
var
  Save: TFileCandy;
begin
  AssignFile(Save, Road);
  Rewrite(Save);
  While Candys^.Adr <> nil do
  begin
    Candys := Candys^.Adr;
    Write(Save, Candys^.Inf);
  end;
  Close(Save);
end;

function LoadFromFile(var TypeOfCandy: TTypeOfCandysAdr; Road: String)
  : Integer; overload;
var
  Save: TFileTypeOfCandy;
  temp: TTypeOfCandysAdr;
  Inf: TTypeOfCandysInf;
begin
  AssignFile(Save, Road);
  try
    Reset(Save);
    Result := 0;
    temp := TypeOfCandy;
    Clear(TypeOfCandy^.Adr);
    While not EOF(Save) do
    begin
      Read(Save, Inf);
      New(temp^.Adr);
      temp := temp^.Adr;
      temp.Inf := Inf;
      if Inf.PKey > Result then
        Result := Inf.PKey;
    end;
    Close(Save);
    Inc(Result);
  except
    Result := -1;
  end;

end;

function LoadFromFile(var Candy: TCandysAdr; Road: String): Integer; overload;
var
  Save: TFileCandy;
  temp: TCandysAdr;
  Inf: TCandysInf;
begin
  AssignFile(Save, Road);
  try
    Reset(Save);
    Result := 0;
    temp := Candy;
    Clear(Candy^.Adr);
    While not EOF(Save) do
    begin
      Read(Save, Inf);
      New(temp^.Adr);
      temp := temp^.Adr;
      temp.Inf := Inf;
      if Inf.PKey > Result then
        Result := Inf.PKey;
    end;
    Close(Save);
    Inc(Result);
  except
    Result := -1;
  end;
end;

end.
