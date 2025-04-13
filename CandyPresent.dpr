program CandyPresent;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  FileWork in 'FileWork.pas',
  CandyTypes in 'CandyTypes.pas',
  Menu in 'Menu.pas',
  GeneratorGifts in 'GeneratorGifts.pas',
  GiftWork in 'GiftWork.pas';

const
  MAIN_MENU: array [1 .. 10] of string = ('1. ������ ������ �� �����',
    '2. �������� ����� ������',
    '3. ���������� ������ � ������������ � ��������',
    '4. ����� ������ � �������������� ��������',
    '5. ���������� ������ � ������', '6. �������� ������ �� ������',
    '7. �������������� ������', '8. �������� ����������� �������',
    '9. ����� �� ��������� ��� ���������� ���������',
    '10.����� � ����������� ���������');
  LISTS_ARRAY: array [1 .. 2] of string = ('C����� ���������',
    '������ ����� ���������');
  CANDY_LIST: array [1 .. 6] of string = ('pk', '���', '���', '���������',
    '���', '�����');
  TYPE_LIST: array [1 .. 2] of string = ('pk', '���');

type
  TVoidProcedure = procedure();

var
  headType: TTypeOfCandysAdr;
  headCandy: TCandysAdr;
  info: TTypeOfCandysAdrs;
  pkType, pkCandy, i: Integer;

procedure ReadTypeList();
var
  i: Integer;
begin
  ClearConsole;

  Write('������� ��� ���� : ');
  Readln(headType^.Inf.Name);
  headType^.Inf.PKey := pkType;
  Add(headType, headType^.Inf);
  inc(pkType);

end;

procedure ReadCandyList();
var
  i: Integer;
  temp: TTypeOfCandysAdr;
  p: TCandysAdr;
begin
  ClearConsole;
  p := headCandy;
  Write('������� ��� �������� : ');
  Readln(p^.Inf.Name);
  repeat
    Write('������� ������ ���� �������� : ');
    Readln(headType^.Inf.PKey);
    temp := Find(headType^.Adr, headType^.Inf, CompareTCPKey)[0];
    if temp = nil then
      BaseInfo(['����� ��� �� ������, ��������� ����']);
  until temp <> nil;
  p^.Inf.TypeCandyKet := temp^.Inf.PKey;
  Write('������� ��������� �������� : ');
  Readln(p^.Inf.Cost);
  Write('������� ��� �������� : ');
  Readln(p^.Inf.Weigth);
  Write('������� ���������� ������ � �������� : ');
  Readln(p^.Inf.Sugar);
  p^.Inf.PKey := pkCandy;
  Add(p, p^.Inf);
  inc(pkCandy);
end;

procedure WriteTypeList();
var
  temp: TTypeOfCandysAdr;
begin
  ClearConsole;
  temp := headType;
  Writeln('|', TYPE_LIST[1]:4, '|', TYPE_LIST[2]:20, '|');
  while temp^.Adr <> nil do
  begin
    temp := temp^.Adr;
    Writeln('|', temp^.Inf.PKey:4, '|', temp^.Inf.Name:20, '|');
  end;
end;

procedure WriteCandyList();
var
  p: TCandysAdr;
begin
  ClearConsole;
  p := headCandy;
  Writeln('|', CANDY_LIST[1]:4, '|', CANDY_LIST[2]:20, '|', CANDY_LIST[3]:20,
    '|', CANDY_LIST[4]:10, '|', CANDY_LIST[5]:10, '|', CANDY_LIST[6]:10);
  while p^.Adr <> nil do
  begin
    p := p^.Adr;
    headType^.Inf.PKey := p^.Inf.TypeCandyKet;
    Writeln('|', p^.Inf.PKey:4, '|', p^.Inf.Name:20, '|',
      Find(headType^.Adr, headType^.Inf, CompareTCPKey)[0]^.Inf.Name:20, '|',
      p^.Inf.Cost:10, '|', p^.Inf.Weigth:10:3, '|', p^.Inf.Sugar:10:3);
  end;
end;

procedure ReadFromFile();
var
  val1, val2: Integer;
begin
  val1 := LoadFromFile(headType, 'type.dcu');
  val2 := LoadFromFile(headCandy, 'candy.dcu');
  if (val1 <> -1) and (val2 <> -1) then
  begin
    BaseInfo(['������ � ����� ������ �������']);
    pkType := val1;
    pkCandy := val2;
  end
  else
    BaseInfo(['������ ������ � �����']);
end;

procedure SortCandyList();
begin
  case BaseMenu(CANDY_LIST) of
    0:
      Sort(headCandy^.Adr, CompareCnPKey);
    1:
      Sort(headCandy^.Adr, CompareCnTypeCandyKet);
    2:
      Sort(headCandy^.Adr, CompareCnName);
    3:
      Sort(headCandy^.Adr, CompareCnCost);
    4:
      Sort(headCandy^.Adr, CompareCnWeigth);
    5:
      Sort(headCandy^.Adr, CompareCnSugar);
  end;

end;

procedure SortTypeList();
begin
  case BaseMenu(TYPE_LIST) of
    0:
      Sort(headType, CompareTCPKey);
    1:
      Sort(headType, CompareTCName);
  end;

end;

procedure FindCandyList();
var
  tempT: TTypeOfCandysAdrs;
  tempC: TCandysAdrs;
  i: Integer;
begin
  case BaseMenu(CANDY_LIST) of
    0:
      begin
        ClearConsole;
        Readln(headCandy^.Inf.PKey);
        tempC := Find(headCandy^.Adr, headCandy^.Inf, CompareCnPKey);
      end;
    2:
      begin
        ClearConsole;
        repeat
          Readln(headType^.Inf.Name);
          tempT := Find(headType^.Adr, headType^.Inf, CompareTCName);
          if tempT[0] = nil then
            BaseInfo(['����� ��� �� ������, ��������� ����']);
        until tempT[0] <> nil;
        headCandy^.Inf.TypeCandyKet := tempT[0]^.Inf.PKey;
        tempC := Find(headCandy^.Adr, headCandy^.Inf, CompareCnTypeCandyKet);
      end;
    1:
      begin
        ClearConsole;
        Readln(headCandy^.Inf.Name);
        tempC := Find(headCandy^.Adr, headCandy^.Inf, CompareCnName);
      end;
    3:
      begin
        ClearConsole;
        Readln(headCandy^.Inf.Cost);
        tempC := Find(headCandy^.Adr, headCandy^.Inf, CompareCnCost);
      end;
    4:
      begin
        ClearConsole;
        Readln(headCandy^.Inf.Weigth);
        tempC := Find(headCandy^.Adr, headCandy^.Inf, CompareCnWeigth);
      end;
    5:
      begin
        ClearConsole;
        Readln(headCandy^.Inf.Sugar);
        tempC := Find(headCandy^.Adr, headCandy^.Inf, CompareCnSugar);
      end;
  end;
  ClearConsole;
  i := 0;
  Writeln('|', CANDY_LIST[1]:4, '|', CANDY_LIST[2]:20, '|', CANDY_LIST[3]:20,
    '|', CANDY_LIST[4]:10, '|', CANDY_LIST[5]:10, '|');
  While tempC[i] <> nil do
  begin
    headType^.Inf.PKey := tempC[i]^.Inf.TypeCandyKet;
    Writeln('|', tempC[i]^.Inf.PKey:4, '|', tempC[i]^.Inf.Name:20, '|',
      Find(headType^.Adr, headType^.Inf, CompareTCPKey)[0]^.Inf.Name:20, '|',
      tempC[i]^.Inf.Cost:10, '|', tempC[i]^.Inf.Weigth:10:3, '|');
    inc(i);
  end;
end;

procedure FindTypeList();
var
  tempT: TTypeOfCandysAdrs;
  i: Integer;
begin
  case BaseMenu(TYPE_LIST) of
    0:
      begin
        ClearConsole;
        Readln(headType^.Inf.PKey);
        tempT := Find(headType^.Adr, headType^.Inf, CompareTCPKey);
      end;
    1:
      begin
        ClearConsole;
        Readln(headType^.Inf.Name);
        tempT := Find(headType^.Adr, headType^.Inf, CompareTCName);
      end;
  end;
  ClearConsole;
  i := 0;
  Writeln('|', TYPE_LIST[1]:4, '|', TYPE_LIST[2]:20, '|');
  While tempT[i] <> nil do
  begin
    Writeln('|', tempT[i]^.Inf.PKey:4, '|', tempT[i]^.Inf.Name:20, '|');
    inc(i);
  end;
end;

procedure EditCandyList();
var
  tempT: TTypeOfCandysAdrs;
begin
  FindCandyList();
  Writeln('������� ����� ����������� ��������');
  Readln(headCandy^.Inf.PKey);
  case BaseMenu(CANDY_LIST) of
    1:
      begin
        ClearConsole;
        Readln(Find(headCandy^.Adr, headCandy^.Inf, CompareCnPKey)
          [0]^.Inf.Name);
      end;
    2:
      begin
        ClearConsole;
        repeat
          Readln(headType^.Inf.Name);
          tempT := Find(headType^.Adr, headType^.Inf, CompareTCName);
          if tempT[0] = nil then
            BaseInfo(['����� ��� �� ������, ��������� ����']);
        until tempT[0] <> nil;
        Find(headCandy^.Adr, headCandy^.Inf, CompareCnPKey)[0]^.Inf.TypeCandyKet
          := tempT[0]^.Inf.PKey;
      end;
    3:
      begin
        ClearConsole;
        Readln(Find(headCandy^.Adr, headCandy^.Inf, CompareCnPKey)
          [0]^.Inf.Cost);
      end;
    4:
      begin
        ClearConsole;
        Readln(Find(headCandy^.Adr, headCandy^.Inf, CompareCnPKey)
          [0]^.Inf.Weigth);
      end;
    5:
      begin
        ClearConsole;
        Readln(Find(headCandy^.Adr, headCandy^.Inf, CompareCnPKey)
          [0]^.Inf.Sugar);
      end;
  end;
end;

procedure EditTypeList();
begin
  FindTypeList();
  Writeln('������� ����� ����������� ��������');
  Readln(headType^.Inf.PKey);
  case BaseMenu(TYPE_LIST) of
    1:
      begin
        ClearConsole;
        Readln(Find(headType^.Adr, headType^.Inf, CompareTCPKey)[0]^.Inf.Name);
      end;
  end;
end;

procedure ChoseFunction(ParamsN: array of string;
  ParamsP: array of TVoidProcedure);
var
  i: Integer;
begin
  i := BaseMenu(ParamsN);
  if i <> -1 then
    ParamsP[i]();
end;

procedure DeleteCandyList();
var
  pk: Integer;
begin
  FindCandyList();
  Writeln('������� ����� ���������� ��������');
  Readln(pk);
  Delete(headCandy, pk);

end;

procedure DeleteTypeList();
var
  pk: Integer;
begin
  FindTypeList();
  Writeln('������� ����� ���������� ��������');
  Readln(pk);
  Delete(headType, pk);
end;

procedure MainMenu();
var Population: TPopulation;
    isExit: Boolean;
begin
  isExit := false;
  while not isExit do
  begin
    case BaseMenu(MAIN_MENU) of
      0:
        ReadFromFile();
      1:
        begin
          ChoseFunction(LISTS_ARRAY, [WriteCandyList, WriteTypeList]);
          Readln;
        end;
      2:
        ChoseFunction(LISTS_ARRAY, [SortCandyList, SortTypeList]);
      3:
        ChoseFunction(LISTS_ARRAY, [FindCandyList, FindTypeList]);
      4:
        begin
          ChoseFunction(LISTS_ARRAY, [ReadCandyList, ReadTypeList]);
          BaseInfo(['������� ��� ��������']);
        end;
      5:
        ChoseFunction(LISTS_ARRAY, [DeleteCandyList, DeleteTypeList]);
      6:
        begin
          ChoseFunction(LISTS_ARRAY, [EditCandyList, EditTypeList]);
          Readln;
        end;
      7:
        begin
          RunGeneticAlgorithm(Population, headCandy^.Adr, headType^.Adr, 1000, // ����. ���
            500, // ����. ���������
            3, // ����. �����
            50 // ���������
            );
            Readln;
        end;
      9:
        begin
          SaveToFile(headType, 'type.dcu');
          SaveToFile(headCandy, 'candy.dcu');
          isExit := true;
        end;
      -1,8:
       isExit := true;
    end;

  end;
end;

begin
  New(headType);
  headType^.Adr := nil;

  New(headCandy);
  headCandy^.Adr := nil;

  MainMenu();

  Clear(headType);
  Clear(headCandy);

end.
