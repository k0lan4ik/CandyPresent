unit ChooseType;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList;

type
  TChoose = class(TForm)
    ChooseList: TPanel;
    Button1: TButton;
    Button2: TButton;

    ActionList1: TActionList;
    chooseCandy: TAction;
    chooseTypeCandy: TAction;
    procedure chooseCandyExecute(Sender: TObject);
    procedure chooseTypeCandyExecute(Sender: TObject);
  private
    { Private declarations }
  public
    chType: Integer;
    { Public declarations }
  end;

var
  Choose: TChoose;


implementation

{$R *.dfm}

procedure TChoose.chooseCandyExecute(Sender: TObject);
begin
  chType := 1;

end;

procedure TChoose.chooseTypeCandyExecute(Sender: TObject);
begin
  chType := 2;
end;

end.
