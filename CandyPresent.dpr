program CandyPresent;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  FileWork in 'FileWork.pas',
  CandyTypes in 'CandyTypes.pas',
  Menu in 'Menu.pas';

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

var
  headType: TTypeOfCandysAdr;
  headCandy: TCandysAdr;
  info: TTypeOfCandysAdrs;
  pkType, pkCandy, i: Integer;

procedure ReadTypeList(var p: TTypeOfCandysAdr);
var
  i: Integer;
begin
  ClearConsole;
  Write('������� ����� ���������: ');
  Readln(i);
  Writeln;
  for i := 1 to i do
  begin
    Write('������� ��� ���� ', i, ': ');
    Readln(p^.Inf.Name);
    p^.Inf.PKey := pkType;
    Add(p, p^.Inf);
    inc(pkType);
    Writeln;
  end;
end;

procedure ReadCandyList(var p: TCandysAdr);
var
  i: Integer;
  temp: String;
begin
  ClearConsole;
  Write('������� ����� ���������: ');
  Readln(i);
  Writeln;
  for i := 1 to i do
  begin
    Write('������� ��� �������� ', i, ': ');
    Readln(p^.Inf.Name);
    Write('������� ��� �������� ', i, ': ');
    Readln(headType^.Inf.Name);
    p^.Inf.TypeCandyKet := Find(headType, headType^.Inf, CompareTCName)
      [0]^.Inf.PKey;
    Write('������� ��������� �������� ', i, ': ');
    Readln(p^.Inf.Cost);
    Write('������� ��� �������� ', i, ': ');
    Readln(p^.Inf.Weigth);
    p^.Inf.PKey := pkCandy;
    Add(p, p^.Inf);
    inc(pkCandy);
    Writeln;
  end;

end;

procedure WriteTypeList(p: TTypeOfCandysAdr);
var
  temp: TTypeOfCandysAdr;
begin
  Writeln('  pk                 ���');
  while p^.Adr <> nil do
  begin
    p := p^.Adr;
    Writeln(p^.Inf.PKey:4, p^.Inf.Name:20);
  end;
end;

procedure WriteCandyList(p: TCandysAdr);
var
  temp: TCandysAdr;
begin
  Writeln(' pk                    ���                    ���       ���������       ���');
  while p^.Adr <> nil do
  begin
    p := p^.Adr;
    headType^.Inf.PKey := p^.Inf.TypeCandyKet;
    Writeln(p^.Inf.PKey:4, p^.Inf.Name:20,
      Find(headType, headType^.Inf, CompareTCPKey)[0]^.Inf.Name:20,
      p^.Inf.Cost:7, p^.Inf.Weigth:7:2);
  end;
end;

procedure ReadFromFile();
var
  val1, val2: Integer;
begin
  val1 := LoadFromFile(headType, 'test.dcu');
  val2 := LoadFromFile(headCandy, 'test.dcu');
  if (val1 <> -1) and (val2 <> -1) then
  begin
    BaseInfo(['������ � ����� ������ �������']);
    pkType := val1;
    pkCandy := val2;
  end
  else
    BaseInfo(['������ ������ � �����']);
end;

procedure PrintList();
begin
  case BaseMenu(LISTS_ARRAY) of
    0:
      begin
        WriteCandyList(headCandy);
        Readln;
      end;
    1:
      begin
        WriteTypeList(headType);
        Readln;
      end;
  end;

end;

procedure AddToList();
begin
  case BaseMenu(LISTS_ARRAY) of
    0:
      ReadCandyList(headCandy);
    1:
      ReadTypeList(headType);
  end;
  BaseInfo(['�������(-�) ���(-�) ��������(-�)']);
end;

procedure MainMenu();
begin
  while true do
  begin
    case BaseMenu(MAIN_MENU) of
      0:
        ReadFromFile();
      1:
        PrintList();
      4:
        AddToList();
      9:
        begin
          SaveToFile(headType, 'test.dcu');
          SaveToFile(headCandy, 'test.dcu');
          Break;
        end;
      -1, 8:
        Break;
    end;

  end;
end;

begin
  New(headType);
  headType^.Adr := nil;

  New(headCandy);
  headCandy^.Adr := nil;

  MainMenu();
  // ReadList(head);
  Sort(headType^.Adr, CompareTCName);
  WriteTypeList(headType);
  Readln(headType^.Inf.Name);
  info := Find(headType^.Adr, headType^.Inf, CompareTCName);
  i := 0;
  while (i <= High(info)) and (info[i] <> nil) do
  begin
    Writeln(info[i]^.Inf.PKey, ' ---- ', info[i]^.Inf.Name);
    inc(i);
  end;

  Readln(i);
  Delete(headType, i);
  WriteTypeList(headType);

  Readln(headType^.Inf.Name);
  headType^.Inf.PKey := pkType;
  Add(headType, headType^.Inf);

  Readln;
  SaveToFile(headType, 'test.dcu');
  SaveToFile(headCandy, 'test.dcu');

  Clear(headType);
  Clear(headCandy);

end.
