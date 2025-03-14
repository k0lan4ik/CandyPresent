program CandyPresent;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Windows;

type
  TCandysInf = record
    PKey: Integer;
    Name: String[200];
    Cost: Integer;
    Weigth: Real;
  end;

  TCandysAdr = ^TCandys;

  TCandys = record
    Inf: TCandysInf;
    Adr: TCandysAdr;
  end;

  TTypeOfCandysInf = record
    PKey: Integer;
    Name: String[200];
    Candys: TCandysAdr;
  end;

  TTypeOfCandysAdr = ^TTypeOfCandys;

  TTypeOfCandys = record
    Inf: TTypeOfCandysInf;
    Adr: TTypeOfCandysAdr;
  end;

procedure ShowLists();
begin

end;

const
  MENU_ITEMS: array[1..10] of string = (
    '1. ������ ������ �� �����',
    '2. �������� ����� ������',
    '3. ���������� ������ � ������������ � ��������',
    '4. ����� ������ � �������������� ��������',
    '5. ���������� ������ � ������',
    '6. �������� ������ �� ������',
    '7. �������������� ������',
    '8. �������� ����������� �������',
    '9. ����� �� ��������� ��� ���������� ���������',
    '10.����� � ����������� ���������'
  );

var
  SelectedItem: Integer = 0;
  hConsole: THandle;
  ConsoleWidth: Integer;

// ���������� ������� WinAPI
procedure SetConsoleTextAttribute(hConsoleOutput: THandle; wAttributes: Word); stdcall; external 'kernel32.dll';
function GetStdHandle(nStdHandle: DWORD): THandle; stdcall; external 'kernel32.dll';
function GetConsoleScreenBufferInfo(hConsoleOutput: THandle; var lpConsoleScreenBufferInfo: CONSOLE_SCREEN_BUFFER_INFO): BOOL; stdcall; external 'kernel32.dll';

// ��������� ������ �������
procedure UpdateConsoleWidth;
var
  info: CONSOLE_SCREEN_BUFFER_INFO;
begin
  GetConsoleScreenBufferInfo(hConsole, info);
  ConsoleWidth := info.dwSize.X;
end;

// ������� �������
procedure ClearConsole;
var
  coord: TCoord;
  count, numWritten: DWORD;
begin
  coord.X := 0;
  coord.Y := 0;
  UpdateConsoleWidth;
  count := ConsoleWidth * 100;
  FillConsoleOutputCharacter(hConsole, ' ', count, coord, numWritten);
  SetConsoleCursorPosition(hConsole, coord);
end;

// ��������� ���� � ������ ���������� ������
procedure DrawMenu;
var
  i: Integer;
  textLine: string;
  spaces: string;
begin
  ClearConsole;
  UpdateConsoleWidth;

  for i := Low(MENU_ITEMS) to High(MENU_ITEMS) do
  begin
    textLine := ' ' + MENU_ITEMS[i];
    if Length(textLine) > ConsoleWidth - 1 then
      textLine := Copy(textLine, 1, ConsoleWidth - 2) + '�';

    spaces := StringOfChar(' ', ConsoleWidth - (Length(textLine)+1));

    if i = SelectedItem then
    begin
      // ���������� ������
      SetConsoleTextAttribute(hConsole, BACKGROUND_BLUE or FOREGROUND_INTENSITY);SetConsoleTextAttribute(hConsole, FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE or BACKGROUND_BLUE);
      Write(textLine);
      Write(spaces);
    end
    else
    begin
      // ������� ������
      SetConsoleTextAttribute(hConsole, FOREGROUND_INTENSITY or FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE);
      Write(textLine);
      Write(spaces);
    end;
    Writeln;
  end;

  // ����� ������
  SetConsoleTextAttribute(hConsole, FOREGROUND_INTENSITY or FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE);
  end;

// ��������� ������
function ReadKey: Word;
var
  InputRec: TInputRecord;
  NumRead: Cardinal;
begin
  while True do
  begin
    ReadConsoleInput(GetStdHandle(STD_INPUT_HANDLE), InputRec, 1, NumRead);
    if (InputRec.EventType = KEY_EVENT) and InputRec.Event.KeyEvent.bKeyDown then
      Exit(InputRec.Event.KeyEvent.wVirtualKeyCode);
  end;
end;

begin
  hConsole := GetStdHandle(STD_OUTPUT_HANDLE);

  while True do
  begin
    DrawMenu;
    case ReadKey of
      VK_UP: if SelectedItem > 0 then Dec(SelectedItem);
      VK_DOWN: if SelectedItem < High(MENU_ITEMS) then Inc(SelectedItem);
      VK_RETURN:
        begin
          ClearConsole;
          Writeln('������ �����: ', MENU_ITEMS[SelectedItem]);
          if SelectedItem >= 9  then Break;
          Sleep(2000);
        end;
      VK_ESCAPE: Break;
    end;
  end;

  // �������������� ������
  SetConsoleTextAttribute(hConsole, FOREGROUND_INTENSITY or FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE);
end.
