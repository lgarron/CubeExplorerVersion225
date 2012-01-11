object OptionForm: TOptionForm
  Left = 324
  Top = 195
  HelpContext = 1005
  BorderIcons = [biMinimize]
  BorderStyle = bsDialog
  Caption = 'Two-Phase-Algorithm'
  ClientHeight = 261
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 24
    Top = 13
    Width = 145
    Height = 193
    Caption = 'Maximal maneuver length'
    TabOrder = 0
    object RadioButton1: TRadioButton
      Tag = 20
      Left = 13
      Top = 24
      Width = 68
      Height = 17
      Caption = '20 moves'
      TabOrder = 0
      OnClick = RBMaxMovesClick
    end
    object RadioButton2: TRadioButton
      Tag = 21
      Left = 13
      Top = 57
      Width = 68
      Height = 17
      Caption = '21 moves'
      TabOrder = 1
      OnClick = RBMaxMovesClick
    end
    object RadioButton3: TRadioButton
      Tag = 22
      Left = 13
      Top = 90
      Width = 68
      Height = 17
      Caption = '22 moves'
      TabOrder = 2
      OnClick = RBMaxMovesClick
    end
    object RadioButton4: TRadioButton
      Tag = 23
      Left = 13
      Top = 123
      Width = 68
      Height = 17
      Caption = '23 moves'
      TabOrder = 3
      OnClick = RBMaxMovesClick
    end
    object RadioButton5: TRadioButton
      Tag = 24
      Left = 13
      Top = 156
      Width = 68
      Height = 17
      Caption = '24 moves'
      TabOrder = 4
      OnClick = RBMaxMovesClick
    end
  end
  object GroupBox2: TGroupBox
    Tag = 18
    Left = 191
    Top = 13
    Width = 145
    Height = 193
    Caption = 'Stop automatic search at'
    TabOrder = 1
    object RadioButton6: TRadioButton
      Tag = 18
      Left = 15
      Top = 56
      Width = 70
      Height = 17
      Caption = '18 moves'
      TabOrder = 0
      OnClick = RBStopAtClick
    end
    object RadioButton7: TRadioButton
      Tag = 19
      Left = 15
      Top = 88
      Width = 70
      Height = 17
      Caption = '19 moves'
      TabOrder = 1
      OnClick = RBStopAtClick
    end
    object RadioButton8: TRadioButton
      Tag = 20
      Left = 15
      Top = 120
      Width = 70
      Height = 17
      Caption = '20 moves'
      Checked = True
      TabOrder = 2
      TabStop = True
      OnClick = RBStopAtClick
    end
    object RadioButton9: TRadioButton
      Tag = 21
      Left = 15
      Top = 152
      Width = 70
      Height = 17
      Caption = '21 moves'
      TabOrder = 3
      OnClick = RBStopAtClick
    end
    object RadioButton10: TRadioButton
      Tag = 17
      Left = 15
      Top = 24
      Width = 70
      Height = 17
      Caption = '17 moves'
      TabOrder = 4
      OnClick = RBStopAtClick
    end
  end
  object Button1: TButton
    Left = 226
    Top = 221
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 40
    Top = 225
    Width = 113
    Height = 17
    Caption = 'Use Triple Search'
    TabOrder = 3
    OnClick = CheckBox1Click
  end
end
