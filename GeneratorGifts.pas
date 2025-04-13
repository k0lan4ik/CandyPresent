unit GeneratorGifts;

interface

implementation
uses
  CandyTypes;

type
  TGiftItemInf = record
    PKeySweet: Integer;
    Quantity: Integer;
  end;

  TGiftItemAdr = ^TGiftItem;

  TGiftItem = record
    Inf: TGiftItemInf;
    Adr: TGiftItemInf;
  end;

   TGiftInf = record
    Items: TGiftItemAdr;
    TotalSugar: Real;
    TotalCost: Integer;
    TotalWeight: Real;
  end;

  TGiftAdr = ^TGift;

  TGift = record
    Inf: TGiftInf;
    Adr: TGiftAdr;
  end;



end.

end.
