unit GiftWork;

interface

uses
  CandyTypes, SysUtils, Classes, System.Generics.Collections;

type
  PGift = ^TGift;
  TGift = record
    Items: TCandysAdr;
    TotalSugar: Double;
    TotalCost: Integer;
    TotalWeight: Double;
    TypesCount: Integer;
    Next: PGift;
  end;

  TPopulation = array of PGift;

  procedure RunGeneticAlgorithm(
    var Population: TPopulation;
    Candies: TCandysAdr;
    Types: TTypeOfCandysAdr;
    MaxWeight: Double;
    MaxCost: Double;
    RequiredTypes: Integer;
    Generations: Integer
  );

  procedure FreePopulation(var Population: TPopulation);
  procedure PrintGift(Gift: PGift);

implementation

var
  GCandies: TCandysAdr;
  GTypes: TTypeOfCandysAdr;

// ����������� �������
function GetRandomType(Types: TTypeOfCandysAdr): TTypeOfCandysAdr;
var
  Count, i: Integer;
  Current: TTypeOfCandysAdr;
begin
  Count := 0;
  Current := Types;
  while Current <> nil do
  begin
    Inc(Count);
    Current := Current^.Adr;
  end;

  Current := Types;
  for i := 0 to Random(Count) - 1 do
    if Current <> nil then
      Current := Current^.Adr;

  Result := Current;
end;

procedure DeleteTypeFromGift(Gift: PGift; TypeKey: Integer);
var
  Current, Prev: TCandysAdr;
begin
  Prev := nil;
  Current := Gift^.Items;
  while Current <> nil do
  begin
    if Current^.Inf.TypeCandyKet = TypeKey then
    begin
      if Prev = nil then
        Gift^.Items := Current^.Adr
      else
        Prev^.Adr := Current^.Adr;
      Dispose(Current);
      Current := Gift^.Items;
    end
    else
    begin
      Prev := Current;
      Current := Current^.Adr;
    end;
  end;
end;

// ������������ �������
procedure UpdateGiftStats(Gift: PGift);
var
  Current: TCandysAdr;
begin
  Gift^.TotalSugar := 0;
  Gift^.TotalCost := 0;
  Gift^.TotalWeight := 0;

  Current := Gift^.Items;
  while Current <> nil do
  begin
    Gift^.TotalSugar := Gift^.TotalSugar + Current^.Inf.Sugar;
    Gift^.TotalCost := Gift^.TotalCost + Current^.Inf.Cost;
    Gift^.TotalWeight := Gift^.TotalWeight + Current^.Inf.Weigth;
    Current := Current^.Adr;
  end;
end;

function GetUniqueTypes(Gift: PGift): TList<Integer>;
var
  Current: TCandysAdr;
begin
  Result := TList<Integer>.Create;
  Current := Gift^.Items;
  while Current <> nil do
  begin
    if not Result.Contains(Current^.Inf.TypeCandyKet) then
      Result.Add(Current^.Inf.TypeCandyKet);
    Current := Current^.Adr;
  end;
end;

function FindCandyByType(TypeKey: Integer): TCandysAdr;
var
  Current: TCandysAdr;
begin
  Current := GCandies;
  while Current <> nil do
  begin
    if Current^.Inf.TypeCandyKet = TypeKey then
      Exit(Current);
    Current := Current^.Adr;
  end;
  Result := nil;
end;

procedure AddCandyToGift(
  var Gift: PGift;
  Candy: TCandysInf;
  Quantity: Integer
);
var
  i: Integer;
  NewItem, Current: TCandysAdr;
begin
  // ��������� � ����� ������
  if Gift^.Items = nil then
  begin
    // ������� ������ �������
    New(Gift^.Items);
    Current := Gift^.Items;
  end
  else
  begin
    // ���� ��������� �������
    Current := Gift^.Items;
    while Current^.Adr <> nil do
      Current := Current^.Adr;

    // ������� ����� �������
    New(Current^.Adr);
    Current := Current^.Adr;
  end;

  // ��������� ������
  Current^.Inf := Candy;
  Current^.Adr := nil;

  // ��������� Quantity-1 �����
  for i := 2 to Quantity do
  begin
    New(Current^.Adr);
    Current := Current^.Adr;
    Current^.Inf := Candy;
    Current^.Adr := nil;
  end;

  UpdateGiftStats(Gift);
end;

function CreateExactTypesGift(
  Candies: TCandysAdr;
  Types: TTypeOfCandysAdr;
  RequiredTypes: Integer;
  MaxWeight: Double;
  MaxCost: Double
): PGift;
var
  SelectedTypes: TList<Integer>;
  CurrentType: TTypeOfCandysAdr;
  CurrentCandy: TCandysAdr;
  Quantity: Integer;
begin
  New(Result);
  Result^.Items := nil;
  SelectedTypes := TList<Integer>.Create;

  try
    // ����� ���������� �����
    while SelectedTypes.Count < RequiredTypes do
    begin
      CurrentType := GetRandomType(Types);
      if (CurrentType <> nil) and (not SelectedTypes.Contains(CurrentType^.Inf.PKey)) then
        SelectedTypes.Add(CurrentType^.Inf.PKey);
    end;

    // ���������� ��������� � ������ ����������
    for var TypeKey in SelectedTypes do
    begin
      CurrentCandy := FindCandyByType(TypeKey);
      if CurrentCandy <> nil then
      begin
        Quantity := 1 + Random(3);
        AddCandyToGift(Result, CurrentCandy^.Inf, Quantity);
      end;
    end;

  finally
    SelectedTypes.Free;
  end;
end;

function CalculateFitness(
  Gift: PGift;
  RequiredTypes: Integer;
  MaxWeight: Double;
  MaxCost: Double
): Double;
const
  Penalty = 1000;
begin
  Result := Gift^.TotalSugar;

  var UniqueTypes := GetUniqueTypes(Gift);
  try
    if UniqueTypes.Count <> RequiredTypes then
      Result := Result + Abs(UniqueTypes.Count - RequiredTypes) * Penalty;
  finally
    UniqueTypes.Free;
  end;

  if Gift^.TotalWeight > MaxWeight then
    Result := Result + (Gift^.TotalWeight - MaxWeight) * Penalty;

  if Gift^.TotalCost > MaxCost then
    Result := Result + (Gift^.TotalCost - MaxCost) * Penalty;
end;

function TournamentSelection(
  Population: TPopulation;
  RequiredTypes: Integer;
  MaxWeight: Double;
  MaxCost: Double
): PGift;
var
  i: Integer;
  Candidate: PGift;
begin
  Result := Population[Random(Length(Population))];
  for i := 1 to 4 do
  begin
    Candidate := Population[Random(Length(Population))];
    if CalculateFitness(Candidate, RequiredTypes, MaxWeight, MaxCost) <
       CalculateFitness(Result, RequiredTypes, MaxWeight, MaxCost) then
      Result := Candidate;
  end;
end;

procedure CrossoverGifts(
  Parent1, Parent2: PGift;
  var Child: PGift;
  RequiredTypes: Integer
);
var
  Types1, Types2: TList<Integer>;
  i: Integer;
begin
  New(Child);
  Child^.Items := nil;

  Types1 := GetUniqueTypes(Parent1);
  Types2 := GetUniqueTypes(Parent2);
  try
    // �� ������� ��������
    for i := 0 to RequiredTypes div 2 - 1 do
      if i < Types1.Count then
        AddCandyToGift(Child, FindCandyByType(Types1[i])^.Inf, 1);

    // �� ������� ��������
    for i := 0 to RequiredTypes div 2 - 1 do
      if i < Types2.Count then
        AddCandyToGift(Child, FindCandyByType(Types2[i])^.Inf, 1);

    // ��������� ����������� ����
    while GetUniqueTypes(Child).Count < RequiredTypes do
    begin
      var rndType := Types1.Count;
      if rndType > 0  then
       Types1[Random(Types1.Count)]
     else
       Types2[Random(Types2.Count)];
      AddCandyToGift(Child, FindCandyByType(rndType)^.Inf, 1);
    end;

    UpdateGiftStats(Child);
  finally
    Types1.Free;
    Types2.Free;
  end;
end;

procedure DeleteCandyFromGift(Gift: PGift; Candy: TCandysAdr);
var
  Current, Prev: TCandysAdr;
begin
  Prev := nil;
  Current := Gift^.Items;
  while Current <> nil do
  begin
    if Current = Candy then
    begin
      if Prev = nil then
        Gift^.Items := Current^.Adr
      else
        Prev^.Adr := Current^.Adr;
      Dispose(Current);
      Break;
    end;
    Prev := Current;
    Current := Current^.Adr;
  end;
end;

function FindFirstCandyByType(TypeKey: Integer): TCandysAdr;
begin
  Result := GCandies;
  while Result <> nil do
  begin
    if Result^.Inf.TypeCandyKet = TypeKey then
      Exit;
    Result := Result^.Adr;
  end;
end;



procedure ReplaceTypeInGift(
  Gift: PGift;
  OldType: Integer;
  NewType: Integer
);
var
  CurrentCandy: TCandysAdr;
  NewCandy: TCandysAdr;
  Count: Integer;
begin
  Count := 0;
  CurrentCandy := Gift^.Items;
  while CurrentCandy <> nil do
  begin
    if CurrentCandy^.Inf.TypeCandyKet = OldType then
      Inc(Count);
    CurrentCandy := CurrentCandy^.Adr;
  end;

  DeleteTypeFromGift(Gift, OldType);
  NewCandy := FindFirstCandyByType(NewType);
  if (NewCandy <> nil) and (Count > 0) then
    AddCandyToGift(Gift, NewCandy^.Inf, Count);
end;

procedure MutateGift(
  Gift: PGift;
  RequiredTypes: Integer
);
var
  OldType: Integer;
  NewTypeKey: Integer;
  AvailableTypes: TList<Integer>;
begin
  if Random < 0.1 then
  begin
    var CurrentTypes := GetUniqueTypes(Gift);
    try
      if CurrentTypes.Count > 0 then
      begin
        OldType := CurrentTypes[Random(CurrentTypes.Count)];
        AvailableTypes := TList<Integer>.Create;
        try
          var CurrentType := GTypes;
          while CurrentType <> nil do
          begin
            if CurrentType^.Inf.PKey <> OldType then
              AvailableTypes.Add(CurrentType^.Inf.PKey);
            CurrentType := CurrentType^.Adr;
          end;

          if AvailableTypes.Count > 0 then
          begin
            NewTypeKey := AvailableTypes[Random(AvailableTypes.Count)];
            ReplaceTypeInGift(Gift, OldType, NewTypeKey);
          end;
        finally
          AvailableTypes.Free;
        end;
      end;
    finally
      CurrentTypes.Free;
    end;
  end;
  UpdateGiftStats(Gift);
end;

procedure RunGeneticAlgorithm(
  var Population: TPopulation;
  Candies: TCandysAdr;
  Types: TTypeOfCandysAdr;
  MaxWeight: Double;
  MaxCost: Double;
  RequiredTypes: Integer;
  Generations: Integer
);
var
  i, j: Integer;
  NewPopulation: TPopulation;
begin
  GCandies := Candies;
  GTypes := Types;

  SetLength(Population, 100);
  for i := 0 to High(Population) do
    Population[i] := CreateExactTypesGift(Candies, Types, RequiredTypes, MaxWeight, MaxCost);

  for j := 1 to Generations do
  begin
    SetLength(NewPopulation, Length(Population));

    var BestIndex := 0;
    for i := 1 to High(Population) do
      if CalculateFitness(Population[i], RequiredTypes, MaxWeight, MaxCost) <
         CalculateFitness(Population[BestIndex], RequiredTypes, MaxWeight, MaxCost) then
        BestIndex := i;
    NewPopulation[0] := Population[BestIndex];

    for i := 1 to High(NewPopulation) do
    begin
      var Parent1 := TournamentSelection(Population, RequiredTypes, MaxWeight, MaxCost);
      var Parent2 := TournamentSelection(Population, RequiredTypes, MaxWeight, MaxCost);
      var Child: PGift;
      CrossoverGifts(Parent1, Parent2, Child, RequiredTypes);
      MutateGift(Child, RequiredTypes);
      NewPopulation[i] := Child;
    end;

    for i := 0 to High(Population) do
      if i <> BestIndex then
        Dispose(Population[i]);
    Population := NewPopulation;
  end;
end;

procedure FreePopulation(var Population: TPopulation);
var
  i: Integer;
begin
  for i := 0 to High(Population) do
  begin
    while Population[i]^.Items <> nil do
      DeleteCandyFromGift(Population[i], Population[i]^.Items);
    Dispose(Population[i]);
  end;
  SetLength(Population, 0);
end;

procedure PrintGift(Gift: PGift);
var
  Current: TCandysAdr;
  TypeCounts: TDictionary<Integer, Integer>;
begin
  TypeCounts := TDictionary<Integer, Integer>.Create;
  try
    Writeln('���������� �������:');
    Current := Gift^.Items;
    while Current <> nil do
    begin
      var cnt: Integer;
      if TypeCounts.TryGetValue(Current^.Inf.TypeCandyKet, cnt) then
        TypeCounts[Current^.Inf.TypeCandyKet] := cnt + 1
      else
        TypeCounts.Add(Current^.Inf.TypeCandyKet, 1);
      Current := Current^.Adr;
    end;

    for var tp in TypeCounts.Keys do
    begin
      var candy := FindFirstCandyByType(tp);
      Writeln(Format('��� %d (%s): %d ��',
        [tp, candy^.Inf.Name, TypeCounts[tp]]));
    end;

    Writeln(Format(
      '�����: ���=%.1f�, �����=%.1f�, ���������=%d���, �����=%d',
      [Gift^.TotalWeight, Gift^.TotalSugar, Gift^.TotalCost, TypeCounts.Count]
    ));
  finally
    TypeCounts.Free;
  end;
end;

end.
