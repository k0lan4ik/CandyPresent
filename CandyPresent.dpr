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
  MAIN_MENU: array [1 .. 10] of string = ('1. Чтение данных из файла',
    '2. Просмотр всего списка',
    '3. Сортировка данных в соответствии с заданием',
    '4. Поиск данных с использованием фильтров',
    '5. Добавление данных в список', '6. Удаление данных из списка',
    '7. Редактирование данных', '8. Создание новогоднего подарка',
    '9. Выход из программы без сохранения изменений',
    '10.Выход с сохранением изменений');
  LISTS_ARRAY: array [1 .. 2] of string = ('Cписок сладостей',
    'Список типов сладостей');
  CANDY_LIST: array [1 .. 6] of string = ('pk', 'имя', 'тип', 'стоимость',
    'вес', 'сахар');
  TYPE_LIST: array [1 .. 2] of string = ('pk', 'имя');

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

  Write('Введите ИМЯ типа : ');
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
  Write('Введите ИМЯ сладости : ');
  Readln(p^.Inf.Name);
  repeat
    Write('Введите ИНДЕКС типа сладости : ');
    Readln(headType^.Inf.PKey);
    temp := Find(headType^.Adr, headType^.Inf, CompareTCPKey)[0];
    if temp = nil then
      BaseInfo(['Такой тип не найден, повторите ввод']);
  until temp <> nil;
  p^.Inf.TypeCandyKet := temp^.Inf.PKey;
  Write('Введите СТОЙМОСТЬ сладости : ');
  Readln(p^.Inf.Cost);
  Write('Введите ВЕС сладости : ');
  Readln(p^.Inf.Weigth);
  Write('Введите СОДЕРЖАНИЕ САХАРА в сладости : ');
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
    BaseInfo(['Чтение с файла прошло успешно']);
    pkType := val1;
    pkCandy := val2;
  end
  else
    BaseInfo(['Ошибка чтение с файла']);
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
            BaseInfo(['Такой тип не найден, повторите ввод']);
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
  Writeln('Введите номер изменяемого элемента');
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
            BaseInfo(['Такой тип не найден, повторите ввод']);
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
  Writeln('Введите номер изменяемого элемента');
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
  Writeln('Введите номер удоляемого элемента');
  Readln(pk);
  Delete(headCandy, pk);

end;

procedure DeleteTypeList();
var
  pk: Integer;
begin
  FindTypeList();
  Writeln('Введите номер удоляемого элемента');
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
          BaseInfo(['Элемент был добавлен']);
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
          RunGeneticAlgorithm(Population, headCandy^.Adr, headType^.Adr, 1000, // Макс. вес
            500, // Макс. стоимость
            3, // Макс. типов
            50 // Поколений
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
