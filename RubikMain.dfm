object Form1: TForm1
  Left = 182
  Top = 122
  HelpContext = 1008
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AutoScroll = False
  ClientHeight = 491
  ClientWidth = 870
  Color = clBtnFace
  Constraints.MinHeight = 525
  Constraints.MinWidth = 798
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PageCtrl: TPageControl
    Left = 526
    Top = 0
    Width = 344
    Height = 491
    ActivePage = TabSheet1
    Align = alRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabIndex = 0
    TabOrder = 0
    TabStop = False
    object TabSheet1: TTabSheet
      HelpContext = 1002
      Caption = 'Facelet Editor'
      DesignSize = (
        336
        463)
      object FacePaint: TPaintBox
        Left = 3
        Top = 12
        Width = 332
        Height = 255
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clBtnFace
        ParentColor = False
        OnMouseDown = FacePaintMouseDown
        OnMouseMove = FacePaintMouseMove
        OnPaint = FacePaintPaint
      end
      object Bevel1: TBevel
        Left = 2
        Top = 268
        Width = 334
        Height = 2
        Anchors = [akLeft, akRight, akBottom]
      end
      object LSelColor: TLabel
        Left = 223
        Top = 231
        Width = 89
        Height = 16
        Caption = 'Selected Color'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object ProgressLabel: TLabel
        Left = 15
        Top = 438
        Width = 177
        Height = 13
        Alignment = taCenter
        Anchors = [akLeft, akBottom]
        AutoSize = False
      end
      object GroupBox1: TGroupBox
        Left = 151
        Top = 292
        Width = 105
        Height = 95
        Anchors = [akLeft, akBottom]
        Caption = 'Apply Move'
        TabOrder = 1
        object ButtonU: TButton
          Left = 4
          Top = 15
          Width = 31
          Height = 36
          HelpContext = 1006
          Caption = 'U'
          TabOrder = 0
          OnClick = ButtonXClick
          OnMouseDown = ButtonMouseDown
          OnMouseUp = ButtonMouseUp
        end
        object ButtonR: TButton
          Left = 37
          Top = 15
          Width = 31
          Height = 36
          HelpContext = 1006
          Caption = 'R'
          TabOrder = 1
          OnClick = ButtonXClick
          OnMouseDown = ButtonMouseDown
          OnMouseUp = ButtonMouseUp
        end
        object ButtonF: TButton
          Left = 70
          Top = 15
          Width = 31
          Height = 36
          HelpContext = 1006
          Caption = 'F'
          TabOrder = 2
          OnClick = ButtonXClick
          OnMouseDown = ButtonMouseDown
          OnMouseUp = ButtonMouseUp
        end
        object ButtonD: TButton
          Left = 4
          Top = 53
          Width = 32
          Height = 36
          HelpContext = 1006
          Caption = 'D'
          TabOrder = 3
          OnClick = ButtonXClick
          OnMouseDown = ButtonMouseDown
          OnMouseUp = ButtonMouseUp
        end
        object ButtonL: TButton
          Left = 37
          Top = 53
          Width = 32
          Height = 36
          HelpContext = 1006
          Caption = 'L'
          TabOrder = 4
          OnClick = ButtonXClick
          OnMouseDown = ButtonMouseDown
          OnMouseUp = ButtonMouseUp
        end
        object ButtonB: TButton
          Left = 69
          Top = 53
          Width = 32
          Height = 36
          HelpContext = 1006
          Caption = 'B'
          TabOrder = 5
          OnClick = ButtonXClick
          OnMouseDown = ButtonMouseDown
          OnMouseUp = ButtonMouseUp
        end
      end
      object GroupBox2: TGroupBox
        Left = 260
        Top = 292
        Width = 73
        Height = 95
        Anchors = [akLeft, akBottom]
        Caption = 'Reset To'
        TabOrder = 2
        object ButtonEmpty: TButton
          Left = 6
          Top = 16
          Width = 60
          Height = 20
          Caption = 'Empty'
          TabOrder = 0
          OnClick = ButtonEmptyClick
        end
        object ButtonClear: TButton
          Left = 6
          Top = 43
          Width = 60
          Height = 20
          Caption = 'Clean'
          TabOrder = 1
          OnClick = ButtonClearClick
        end
        object ButtonRandom: TButton
          Left = 6
          Top = 69
          Width = 60
          Height = 20
          Caption = 'Random'
          TabOrder = 2
          OnClick = ButtonRandomClick
        end
      end
      object ButtonCustomize: TButton
        Left = 199
        Top = 415
        Width = 130
        Height = 24
        Anchors = [akLeft, akBottom]
        Caption = 'Customize Selected Color'
        TabOrder = 3
        OnClick = ButtonCustomizeClick
      end
      object GroupBox3: TGroupBox
        Left = 1
        Top = 292
        Width = 146
        Height = 95
        Anchors = [akLeft, akBottom]
        Caption = 'Use Current Pattern'
        TabOrder = 0
        object ButtonAddSolve: TButton
          Left = 5
          Top = 16
          Width = 136
          Height = 35
          HelpContext = 1002
          Caption = ' Add and Solve '
          TabOrder = 0
          OnClick = ButtonAddSolveClick
        end
        object ButtonAddGen: TButton
          Left = 5
          Top = 55
          Width = 136
          Height = 35
          HelpContext = 1001
          Caption = 'Add and Generate'
          TabOrder = 1
          OnClick = ButtonAddSolveClick
        end
      end
      object ProgressBar: TProgressBar
        Left = 10
        Top = 421
        Width = 177
        Height = 13
        Anchors = [akLeft, akBottom]
        Min = 0
        Max = 100
        TabOrder = 4
      end
    end
    object PatEdit: TTabSheet
      HelpContext = 1003
      Caption = 'Pattern Editor'
      ImageIndex = 1
      object Bevel2: TBevel
        Left = 229
        Top = 0
        Width = 12
        Height = 461
        Shape = bsLeftLine
      end
      object CurShape: TShape
        Left = 243
        Top = 192
        Width = 77
        Height = 65
        Brush.Color = clRed
      end
      object Label1: TLabel
        Left = 235
        Top = 263
        Width = 89
        Height = 16
        Caption = 'Selected Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object CheckBoxA1: TCheckBox
        Left = 191
        Top = 42
        Width = 35
        Height = 17
        TabStop = False
        AllowGrayed = True
        Caption = 'All'
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = CheckBoxAOnClick
      end
      object CheckBoxF1: TCheckBox
        Left = 160
        Top = 33
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'F'
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = CheckBoxOnClick
      end
      object CheckBoxR1: TCheckBox
        Left = 126
        Top = 33
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'R'
        Checked = True
        State = cbChecked
        TabOrder = 6
        OnClick = CheckBoxOnClick
      end
      object CheckBoxU1: TCheckBox
        Left = 92
        Top = 33
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'U'
        Checked = True
        State = cbChecked
        TabOrder = 7
        OnClick = CheckBoxOnClick
      end
      object CheckBoxD1: TCheckBox
        Left = 92
        Top = 51
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'D'
        Checked = True
        State = cbChecked
        TabOrder = 8
        OnClick = CheckBoxOnClick
      end
      object CheckBoxL1: TCheckBox
        Left = 126
        Top = 51
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'L'
        Checked = True
        State = cbChecked
        TabOrder = 9
        OnClick = CheckBoxOnClick
      end
      object CheckBoxB1: TCheckBox
        Left = 160
        Top = 51
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'B'
        Checked = True
        State = cbChecked
        TabOrder = 10
        OnClick = CheckBoxOnClick
      end
      object CheckBoxA2: TCheckBox
        Left = 191
        Top = 132
        Width = 35
        Height = 17
        TabStop = False
        AllowGrayed = True
        Caption = 'All'
        Checked = True
        State = cbChecked
        TabOrder = 11
        OnClick = CheckBoxAOnClick
      end
      object CheckBoxU2: TCheckBox
        Left = 92
        Top = 123
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'U'
        Checked = True
        State = cbChecked
        TabOrder = 12
        OnClick = CheckBoxOnClick
      end
      object CheckBoxD2: TCheckBox
        Left = 92
        Top = 141
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'D'
        Checked = True
        State = cbChecked
        TabOrder = 13
        OnClick = CheckBoxOnClick
      end
      object CheckBoxR2: TCheckBox
        Left = 126
        Top = 123
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'R'
        Checked = True
        State = cbChecked
        TabOrder = 14
        OnClick = CheckBoxOnClick
      end
      object CheckBoxL2: TCheckBox
        Left = 126
        Top = 141
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'L'
        Checked = True
        State = cbChecked
        TabOrder = 15
        OnClick = CheckBoxOnClick
      end
      object CheckBoxF2: TCheckBox
        Left = 160
        Top = 123
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'F'
        Checked = True
        State = cbChecked
        TabOrder = 16
        OnClick = CheckBoxOnClick
      end
      object CheckBoxB2: TCheckBox
        Left = 160
        Top = 141
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'B'
        Checked = True
        State = cbChecked
        TabOrder = 17
        OnClick = CheckBoxOnClick
      end
      object CheckBoxA3: TCheckBox
        Left = 191
        Top = 221
        Width = 35
        Height = 17
        TabStop = False
        AllowGrayed = True
        Caption = 'All'
        Checked = True
        State = cbChecked
        TabOrder = 18
        OnClick = CheckBoxAOnClick
      end
      object CheckBoxU3: TCheckBox
        Left = 92
        Top = 212
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'U'
        Checked = True
        State = cbChecked
        TabOrder = 19
        OnClick = CheckBoxOnClick
      end
      object CheckBoxD3: TCheckBox
        Left = 92
        Top = 230
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'D'
        Checked = True
        State = cbChecked
        TabOrder = 20
        OnClick = CheckBoxOnClick
      end
      object CheckBoxR3: TCheckBox
        Left = 126
        Top = 212
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'R'
        Checked = True
        State = cbChecked
        TabOrder = 21
        OnClick = CheckBoxOnClick
      end
      object CheckBoxL3: TCheckBox
        Left = 126
        Top = 230
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'L'
        Checked = True
        State = cbChecked
        TabOrder = 22
        OnClick = CheckBoxOnClick
      end
      object CheckBoxF3: TCheckBox
        Left = 160
        Top = 212
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'F'
        Checked = True
        State = cbChecked
        TabOrder = 23
        OnClick = CheckBoxOnClick
      end
      object CheckBoxB3: TCheckBox
        Left = 160
        Top = 230
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'B'
        Checked = True
        State = cbChecked
        TabOrder = 24
        OnClick = CheckBoxOnClick
      end
      object CheckBoxA4: TCheckBox
        Left = 191
        Top = 311
        Width = 35
        Height = 17
        TabStop = False
        AllowGrayed = True
        Caption = 'All'
        Checked = True
        State = cbChecked
        TabOrder = 25
        OnClick = CheckBoxAOnClick
      end
      object CheckBoxU4: TCheckBox
        Left = 92
        Top = 302
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'U'
        Checked = True
        State = cbChecked
        TabOrder = 26
        OnClick = CheckBoxOnClick
      end
      object CheckBoxD4: TCheckBox
        Left = 92
        Top = 320
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'D'
        Checked = True
        State = cbChecked
        TabOrder = 27
        OnClick = CheckBoxOnClick
      end
      object CheckBoxR4: TCheckBox
        Left = 126
        Top = 302
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'R'
        Checked = True
        State = cbChecked
        TabOrder = 28
        OnClick = CheckBoxOnClick
      end
      object CheckBoxL4: TCheckBox
        Left = 126
        Top = 320
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'L'
        Checked = True
        State = cbChecked
        TabOrder = 29
        OnClick = CheckBoxOnClick
      end
      object CheckBoxF4: TCheckBox
        Left = 160
        Top = 302
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'F'
        Checked = True
        State = cbChecked
        TabOrder = 30
        OnClick = CheckBoxOnClick
      end
      object CheckBoxB4: TCheckBox
        Left = 160
        Top = 320
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'B'
        Checked = True
        State = cbChecked
        TabOrder = 31
        OnClick = CheckBoxOnClick
      end
      object CheckBoxA5: TCheckBox
        Left = 191
        Top = 400
        Width = 35
        Height = 17
        TabStop = False
        AllowGrayed = True
        Caption = 'All'
        Checked = True
        State = cbChecked
        TabOrder = 32
        OnClick = CheckBoxAOnClick
      end
      object CheckBoxU5: TCheckBox
        Left = 92
        Top = 391
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'U'
        Checked = True
        State = cbChecked
        TabOrder = 33
        OnClick = CheckBoxOnClick
      end
      object CheckBoxD5: TCheckBox
        Left = 92
        Top = 409
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'D'
        Checked = True
        State = cbChecked
        TabOrder = 34
        OnClick = CheckBoxOnClick
      end
      object CheckBoxR5: TCheckBox
        Left = 126
        Top = 391
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'R'
        Checked = True
        State = cbChecked
        TabOrder = 35
        OnClick = CheckBoxOnClick
      end
      object CheckBoxL5: TCheckBox
        Left = 126
        Top = 409
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'L'
        Checked = True
        State = cbChecked
        TabOrder = 36
        OnClick = CheckBoxOnClick
      end
      object CheckBoxF5: TCheckBox
        Left = 160
        Top = 391
        Width = 31
        Height = 18
        TabStop = False
        Caption = 'F'
        Checked = True
        State = cbChecked
        TabOrder = 37
        OnClick = CheckBoxOnClick
      end
      object CheckBoxB5: TCheckBox
        Left = 160
        Top = 409
        Width = 31
        Height = 17
        TabStop = False
        Caption = 'B'
        Checked = True
        State = cbChecked
        TabOrder = 38
        OnClick = CheckBoxOnClick
      end
      object PatBox1: TGroupBox
        Left = 7
        Top = 3
        Width = 83
        Height = 86
        TabOrder = 39
      end
      object PatBox2: TGroupBox
        Left = 7
        Top = 94
        Width = 83
        Height = 86
        TabOrder = 40
      end
      object PatBox3: TGroupBox
        Left = 7
        Top = 185
        Width = 83
        Height = 86
        TabOrder = 41
      end
      object PatBox4: TGroupBox
        Left = 7
        Top = 275
        Width = 83
        Height = 86
        TabOrder = 42
      end
      object PatBox5: TGroupBox
        Left = 7
        Top = 366
        Width = 83
        Height = 86
        TabOrder = 43
      end
      object CheckBoxContinuous: TCheckBox
        Left = 238
        Top = 436
        Width = 82
        Height = 17
        Caption = 'Continuous'
        TabOrder = 3
      end
      object GroupBox4: TGroupBox
        Left = 243
        Top = 10
        Width = 77
        Height = 167
        Caption = 'Pattern Type'
        TabOrder = 44
        object PatShape1: TShape
          Tag = 1
          Left = 2
          Top = 18
          Width = 71
          Height = 25
          Brush.Color = clRed
          OnMouseDown = PatShapeMouseDown
        end
        object PatShape2: TShape
          Tag = 2
          Left = 2
          Top = 42
          Width = 71
          Height = 25
          Brush.Color = clYellow
          OnMouseDown = PatShapeMouseDown
        end
        object PatShape3: TShape
          Tag = 3
          Left = 2
          Top = 66
          Width = 71
          Height = 25
          Brush.Color = clLime
          OnMouseDown = PatShapeMouseDown
        end
        object PatShape4: TShape
          Tag = 4
          Left = 2
          Top = 90
          Width = 71
          Height = 25
          Brush.Color = clBlue
          OnMouseDown = PatShapeMouseDown
        end
        object PatShape5: TShape
          Tag = 5
          Left = 2
          Top = 114
          Width = 71
          Height = 25
          OnMouseDown = PatShapeMouseDown
        end
        object PatShape6: TShape
          Tag = 6
          Left = 2
          Top = 138
          Width = 71
          Height = 25
          Brush.Color = clGray
          OnMouseDown = PatShapeMouseDown
        end
      end
      object PatClear: TButton
        Left = 238
        Top = 304
        Width = 89
        Height = 24
        Caption = 'Clear Patterns'
        TabOrder = 0
        OnClick = PatClearClick
      end
      object RunPatButton: TButton
        Left = 238
        Top = 340
        Width = 89
        Height = 53
        Caption = 'Start Search'
        TabOrder = 1
        OnClick = RunPatButtonClick
      end
      object FindGenerators: TCheckBox
        Left = 238
        Top = 402
        Width = 98
        Height = 17
        Caption = 'Find Generators'
        TabOrder = 2
      end
    end
    object GoalTab: TTabSheet
      HelpContext = 1004
      Caption = 'Goal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 2
      ParentFont = False
      DesignSize = (
        336
        463)
      object GoalPaint: TPaintBox
        Left = 3
        Top = 12
        Width = 332
        Height = 255
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clBtnFace
        ParentColor = False
        OnPaint = GoalPaintClick
      end
      object Bevel3: TBevel
        Left = 2
        Top = 268
        Width = 334
        Height = 2
        Anchors = [akLeft, akRight, akBottom]
      end
      object Label2: TLabel
        Left = 45
        Top = 357
        Width = 251
        Height = 48
        Alignment = taCenter
        Anchors = [akRight, akBottom]
        Caption = 
          'This is an advanced feature. You should not use it if you only w' +
          'ant to solve the cube or generate pretty patterns.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object goalcopy: TButton
        Left = 15
        Top = 282
        Width = 137
        Height = 41
        Anchors = [akRight, akBottom]
        Caption = 'Copy from Facelet Editor'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = goalcopyClick
      end
      object ClearGoal: TButton
        Left = 184
        Top = 282
        Width = 137
        Height = 41
        Anchors = [akRight, akBottom]
        Caption = 'Reset to Clean Cube'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = ClearGoalClick
      end
    end
  end
  object SbVert: TScrollBar
    Left = 488
    Top = -2
    Width = 16
    Height = 467
    Kind = sbVertical
    Max = 1000000
    PageSize = 0
    TabOrder = 1
    TabStop = False
    OnScroll = SbVertScroll
  end
  object SbHor: TScrollBar
    Left = 21
    Top = 464
    Width = 460
    Height = 16
    PageSize = 0
    TabOrder = 2
    TabStop = False
    OnScroll = SbHorScroll
  end
  object Panel1: TPanel
    Left = 40
    Top = 40
    Width = 417
    Height = 393
    BevelOuter = bvLowered
    Color = clWindow
    TabOrder = 3
    object OutPut: TPaintBox
      Left = 1
      Top = 1
      Width = 415
      Height = 352
      Align = alTop
      PopupMenu = PopupMenu1
      OnMouseDown = OutPutMouseDown
      OnPaint = OutputPaint
    end
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 1
  end
  object MainMenu1: TMainMenu
    Left = 56
    object File1: TMenuItem
      Caption = '&File'
      HelpContext = 1008
      OnClick = File1Click
      object LoadWorkspace1: TMenuItem
        Caption = '&Load Maneuvers...'
        OnClick = LoadWorkspace1Click
      end
      object SaveWorkspace1: TMenuItem
        Caption = '&Save Maneuvers...'
        OnClick = SaveWorkspace1Click
      end
      object SaveasHtml1: TMenuItem
        Caption = 'Save as HTML..'
        OnClick = SaveasHtml1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object PrinterSetup1: TMenuItem
        Caption = 'Printer Setup...'
        OnClick = PrinterSetup1Click
      end
      object PrintMainWindow: TMenuItem
        Caption = 'Print All Cubes'
        OnClick = PrintMainWindowClick
      end
      object PrintSelectedCubes: TMenuItem
        Caption = 'Print Selected Cubes'
        OnClick = PrintMainWindowClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        ShortCut = 32856
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      HelpContext = 1008
      OnClick = Edit1Click
      object DeleteselectedCubes2: TMenuItem
        Caption = 'Delete selected Cubes'
        OnClick = DeleteselectedCubes1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object ClearMainWindow2: TMenuItem
        Caption = 'Clear Main Window'
        OnClick = ClearMainWindow1Click
      end
    end
    object Options1: TMenuItem
      Caption = '&Options'
      HelpContext = 1005
      object TwoPhaseAlgorithm1: TMenuItem
        Caption = 'Two-Phase-Algorithm...'
        OnClick = TwoPhaseAlgorithm1Click
      end
      object HugeSolver: TMenuItem
        Caption = 'Huge Optimal Solver...'
        Enabled = False
        OnClick = HugeSolverClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      HelpContext = 1008
      object Contents1: TMenuItem
        Caption = '&Contents'
        OnClick = Contents1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = '&About...'
        HelpContext = 1007
        OnClick = About1Click
      end
    end
  end
  object SDWorkSpace: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Maneuver Textfile (*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 96
  end
  object ODWorkspace: TOpenDialog
    DefaultExt = 'qex'
    Filter = 'Maneuver Textfile (*.txt)|*.txt'
    Left = 136
  end
  object PopupMenu1: TPopupMenu
    Left = 184
    object DeleteselectedCubes1: TMenuItem
      Caption = 'Delete selected Cubes'
      Enabled = False
      OnClick = DeleteselectedCubes1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ClearMainWindow1: TMenuItem
      Caption = 'Clear Main Window'
      OnClick = ClearMainWindow1Click
    end
  end
  object CubePopupMenu: TPopupMenu
    AutoPopup = False
    Left = 224
    object rotUD: TMenuItem
      Caption = 'Rotate 1/4 about UD-axis'
      OnClick = rotUDClick
    end
    object RotURF: TMenuItem
      Caption = 'Rotate 1/3 about URF-corner'
      OnClick = RotURFClick
    end
    object RotFB: TMenuItem
      Caption = 'Rotate 1/2 about FB-axis'
      OnClick = RotFBClick
    end
    object RefRL: TMenuItem
      Caption = 'Reflect at RL-plane'
      OnClick = RefRLClick
    end
    object Invert1: TMenuItem
      Caption = 'Invert Permutation'
      OnClick = InvertClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object RemoveCube1: TMenuItem
      Caption = 'Remove Cube'
      OnClick = RemoveCube1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object TransferCubetoFaceletEditor1: TMenuItem
      Caption = 'Transfer Cube to Facelet Editor'
      OnClick = TransferCubetoFaceletEditor1Click
    end
    object TransferCubetoGoal1: TMenuItem
      Caption = 'Transfer Cube to Goal'
      OnClick = TransferCubetoGoal1Click
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 272
  end
  object SaveHtml: TSaveDialog
    DefaultExt = 'htm'
    Filter = 'Html File (*.html)|*.html'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 319
    Top = 2
  end
end
