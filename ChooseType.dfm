object Choose: TChoose
  Left = 0
  Top = 0
  Caption = 'ChooseType'
  ClientHeight = 311
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object ChooseList: TPanel
    Left = 0
    Top = 0
    Width = 324
    Height = 311
    Align = alClient
    TabOrder = 0
    ExplicitLeft = -8
    ExplicitWidth = 710
    ExplicitHeight = 516
    object Button1: TButton
      Left = 72
      Top = 96
      Width = 179
      Height = 42
      Action = chooseCandy
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 72
      Top = 194
      Width = 179
      Height = 42
      Action = chooseTypeCandy
      ModalResult = 1
      TabOrder = 1
    end
  end
  object ActionList1: TActionList
    Left = 16
    Top = 32
    object chooseCandy: TAction
      Category = 'ChooseList'
      Caption = #1057#1087#1080#1089#1086#1082' '#1082#1086#1085#1092#1077#1090
      OnExecute = chooseCandyExecute
    end
    object chooseTypeCandy: TAction
      Category = 'ChooseList'
      Caption = #1057#1087#1080#1089#1086#1082' '#1090#1080#1087#1086#1074' '#1089#1083#1072#1076#1086#1089#1090#1077#1081
      OnExecute = chooseTypeCandyExecute
    end
  end
end
