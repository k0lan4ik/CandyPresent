unit Menu;

interface
  function BaseMenu(items: array of string): Integer;
  procedure BaseInfo(items: array of string);
  procedure ClearConsole;
implementation

uses
  Windows;

var
  hConsole: THandle;
  ConsoleWidth: Integer;

  // ���������� ������� WinAPI
procedure SetConsoleTextAttribute(hConsoleOutput: THandle; wAttributes: Word);
  stdcall; external 'kernel32.dll';
function GetStdHandle(nStdHandle: DWORD): THandle; stdcall;
  external 'kernel32.dll';
function GetConsoleScreenBufferInfo(hConsoleOutput: THandle;
  var lpConsoleScreenBufferInfo: CONSOLE_SCREEN_BUFFER_INFO): BOOL; stdcall;
  external 'kernel32.dll';

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
procedure DrawMenu(items: array of string; Selected: Integer);
var
  i: Integer;
  textLine: string;
  spaces: string;
begin
  ClearConsole;

  for i := Low(items) to High(items) do
  begin
    textLine := ' ' + items[i];
    if Length(textLine) > ConsoleWidth - 1 then
      textLine := Copy(textLine, 1, ConsoleWidth - 2) + '�';

    spaces := StringOfChar(' ', ConsoleWidth - (Length(textLine) + 1));

    if i = Selected then
    begin
      // ���������� ������
      SetConsoleTextAttribute(hConsole, BACKGROUND_BLUE or
        FOREGROUND_INTENSITY);
      SetConsoleTextAttribute(hConsole, FOREGROUND_RED or FOREGROUND_GREEN or
        FOREGROUND_BLUE or BACKGROUND_BLUE);
      Write(textLine);
      Write(spaces);
    end
    else
    begin
      // ������� ������
      SetConsoleTextAttribute(hConsole, FOREGROUND_INTENSITY or
        FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE);
      Write(textLine);
      Write(spaces);
    end;
    Writeln;
  end;

  // ����� ������
  SetConsoleTextAttribute(hConsole, FOREGROUND_INTENSITY or FOREGROUND_RED or
    FOREGROUND_GREEN or FOREGROUND_BLUE);
end;

procedure DrawInfo(items: array of string);
var
  i: Integer;
begin
  ClearConsole;
  for i := Low(items) to High(items) do
  begin
    Writeln(items[i]);
  end;
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
    if (InputRec.EventType = KEY_EVENT) and InputRec.Event.KeyEvent.bKeyDown
    then
      Exit(InputRec.Event.KeyEvent.wVirtualKeyCode);
  end;
end;

function BaseMenu(items: array of string): Integer;
var
  SelectedItem: Integer;
begin
  SelectedItem := 0;
  while True do
  begin
    DrawMenu(items, SelectedItem);
    case ReadKey of
      VK_UP:
        if SelectedItem > 0 then
          Dec(SelectedItem);
      VK_DOWN:
        if SelectedItem < High(items) then
          Inc(SelectedItem);
      VK_RETURN:
        begin
          Result := SelectedItem;
          Break;
        end;
      VK_ESCAPE:
        begin
          Result := -1;
          Break;
        end;
    end;
  end;

  // �������������� ������
  SetConsoleTextAttribute(hConsole, FOREGROUND_INTENSITY or FOREGROUND_RED or
    FOREGROUND_GREEN or FOREGROUND_BLUE);
end;

procedure BaseInfo(items: array of string);
begin
  while True do
  begin
    DrawInfo(items);
    case ReadKey of
      VK_RETURN, VK_ESCAPE:
        Break;
    end;
  end;
end;




initialization

hConsole := GetStdHandle(STD_OUTPUT_HANDLE);

end.
