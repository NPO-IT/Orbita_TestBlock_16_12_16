object Form1: TForm1
  Left = 65
  Top = 120
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1087#1077#1094#1080#1072#1083#1100#1085#1086#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1085#1086#1077' '#1086#1073#1077#1089#1087#1077#1095#1077#1085#1080#1077' '#1086#1073#1088#1072#1073#1086#1090#1082#1080' '#1080' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
  ClientHeight = 787
  ClientWidth = 1840
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gProgress1: TGauge
    Left = 0
    Top = 632
    Width = 561
    Height = 49
    ForeColor = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Progress = 0
  end
  object gProgress2: TGauge
    Left = 560
    Top = 632
    Width = 569
    Height = 49
    ForeColor = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Progress = 0
  end
  object procentFalseMF1: TLabel
    Left = 224
    Top = 608
    Width = 130
    Height = 20
    Caption = '% '#1089#1073#1086#1077#1074' '#1087#1086' '#1052#1060
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object procentFalseMG: TLabel
    Left = 784
    Top = 608
    Width = 124
    Height = 20
    Caption = '% '#1089#1073#1086#1077#1074' '#1087#1086' '#1052#1043
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblTestResult: TLabel
    Left = 1136
    Top = 96
    Width = 62
    Height = 24
    Caption = #1054#1090#1095#1077#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox2: TGroupBox
    Left = 1600
    Top = 32
    Width = 233
    Height = 721
    Caption = #1054#1090#1083#1072#1076#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    object Label2: TLabel
      Left = 157
      Top = 1
      Width = 12
      Height = 24
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Memo1: TMemo
      Left = 8
      Top = 16
      Width = 217
      Height = 697
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object GroupBox4: TGroupBox
    Left = 904
    Top = 8
    Width = 225
    Height = 585
    Caption = #1040#1076#1088#1077#1089#1072' '#1082#1072#1085#1072#1083#1086#1074
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object OrbitaAddresMemo: TMemo
      Left = 0
      Top = 24
      Width = 225
      Height = 505
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object saveAdrB: TButton
      Left = 0
      Top = 536
      Width = 225
      Height = 49
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
      TabOrder = 1
      OnClick = saveAdrBClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 903
    Height = 593
    ActivePage = ts3
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1052#1077#1076#1083'.'
      object Panel1: TPanel
        Left = -8
        Top = 16
        Width = 889
        Height = 97
        TabOrder = 0
      end
      object diaSlowAnl: TChart
        Left = 0
        Top = 112
        Width = 898
        Height = 193
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginBottom = 6
        MarginRight = 6
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clBlue
        Title.Font.Height = -16
        Title.Font.Name = 'Arial'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1044#1080#1072#1075#1088#1072#1084#1084#1072' '#1040)
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 1023.000000000000000000
        View3D = False
        TabOrder = 1
        object Series1: TBarSeries
          Cursor = crArrow
          Marks.ArrowLength = 20
          Marks.Style = smsValue
          Marks.Visible = True
          SeriesColor = 10485760
          ShowInLegend = False
          OnClick = Series1Click
          BarBrush.Color = clWhite
          BarStyle = bsRectGradient
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Bar'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
      object diaSlowCont: TChart
        Left = -8
        Top = 304
        Width = 906
        Height = 81
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginRight = 6
        MarginTop = 15
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clBlue
        Title.Font.Height = -16
        Title.Font.Name = 'Arial'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1044#1080#1072#1075#1088#1072#1084#1084#1072' '#1050)
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 1.000000000000000000
        Legend.Visible = False
        View3D = False
        TabOrder = 2
        object Series3: TBarSeries
          Marks.ArrowLength = 20
          Marks.Visible = False
          SeriesColor = clGreen
          BarStyle = bsRectGradient
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Bar'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
      object gistSlowAnl: TChart
        Left = -8
        Top = 384
        Width = 905
        Height = 185
        AllowPanning = pmNone
        AllowZoom = False
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginRight = 6
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clBlue
        Title.Font.Height = -16
        Title.Font.Name = 'Arial'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1043#1080#1089#1090#1086#1075#1088#1072#1084#1084#1072' '#1040)
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.Maximum = 300.000000000000000000
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 1023.000000000000000000
        Legend.Visible = False
        View3D = False
        TabOrder = 3
        object upGistSlowSize: TButton
          Left = 864
          Top = 40
          Width = 33
          Height = 57
          Caption = '+'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -40
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = upGistSlowSizeClick
        end
        object downGistSlowSize: TButton
          Left = 864
          Top = 96
          Width = 33
          Height = 57
          Caption = '-'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -40
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = downGistSlowSizeClick
        end
        object Series2: TLineSeries
          Marks.ArrowLength = 0
          Marks.Frame.Visible = False
          Marks.Transparent = True
          Marks.Visible = False
          SeriesColor = clBlue
          Pointer.HorizSize = 30
          Pointer.InflateMargins = False
          Pointer.Style = psDownTriangle
          Pointer.VertSize = 30
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1041#1099#1089#1090#1088'.'
      ImageIndex = 1
      object fastDia: TChart
        Left = -2
        Top = 112
        Width = 900
        Height = 217
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginRight = 6
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clBlue
        Title.Font.Height = -16
        Title.Font.Name = 'Arial'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1044#1080#1072#1075#1088#1072#1084#1084#1072' '#1041)
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 300.000000000000000000
        Legend.Visible = False
        View3D = False
        TabOrder = 0
        object Series4: TBarSeries
          Marks.ArrowLength = 20
          Marks.Visible = True
          SeriesColor = 10485760
          OnClick = Series4Click
          BarStyle = bsRectGradient
          BarWidthPercent = 90
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Bar'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
      object fastGist: TChart
        Left = -2
        Top = 328
        Width = 900
        Height = 233
        AllowPanning = pmNone
        AllowZoom = False
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginRight = 6
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clBlue
        Title.Font.Height = -16
        Title.Font.Name = 'Arial'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1043#1080#1089#1090#1086#1075#1088#1072#1084#1084#1072' '#1041)
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.Maximum = 1020.000000000000000000
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 256.000000000000000000
        Legend.Visible = False
        View3D = False
        TabOrder = 1
        object upGistFastSize: TButton
          Left = 856
          Top = 64
          Width = 33
          Height = 57
          Caption = '+'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -40
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = upGistFastSizeClick
        end
        object downGistFastSize: TButton
          Left = 856
          Top = 120
          Width = 33
          Height = 57
          Caption = '-'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -40
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = downGistFastSizeClick
        end
        object Series11: TFastLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = clBlue
          LinePen.Color = clBlue
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
    end
    object ts3: TTabSheet
      Caption = #1058#1077#1084#1087'.'
      ImageIndex = 2
      object tempDia: TChart
        Left = 0
        Top = 112
        Width = 900
        Height = 217
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginRight = 6
        Title.Font.Charset = RUSSIAN_CHARSET
        Title.Font.Color = clBlue
        Title.Font.Height = -16
        Title.Font.Name = 'Arial'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1044#1080#1072#1075#1088#1072#1084#1084#1072' T')
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 1023.000000000000000000
        Legend.Visible = False
        View3D = False
        TabOrder = 0
        object Series7: TBarSeries
          Marks.ArrowLength = 20
          Marks.Visible = True
          SeriesColor = 10485760
          OnClick = Series7Click
          BarStyle = bsRectGradient
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Bar'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
      object tempGist: TChart
        Left = 0
        Top = 328
        Width = 897
        Height = 234
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginRight = 6
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clBlue
        Title.Font.Height = -16
        Title.Font.Name = 'Arial'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1043#1080#1089#1090#1086#1075#1088#1072#1084#1084#1072' '#1058)
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.Maximum = 300.000000000000000000
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 1023.000000000000000000
        Legend.Visible = False
        View3D = False
        TabOrder = 1
        object upGistTempSize: TButton
          Left = 856
          Top = 64
          Width = 33
          Height = 57
          Caption = '+'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -40
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = upGistTempSizeClick
        end
        object downGistTempSize: TButton
          Left = 856
          Top = 120
          Width = 33
          Height = 57
          Caption = '-'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -40
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = downGistTempSizeClick
        end
        object lnsrsSeries8: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = 10485760
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
    end
    object achx: TTabSheet
      Caption = #1040#1063#1061
      ImageIndex = 3
      object achxG: TChart
        Left = -8
        Top = 112
        Width = 905
        Height = 457
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clBlue
        Title.Font.Height = -16
        Title.Font.Name = 'Arial'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1040#1063#1061)
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 10.000000000000000000
        Legend.Visible = False
        View3D = False
        TabOrder = 0
        object lnsrsSeries9: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = clRed
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
        object lnsrsSeries10: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = clGreen
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
        object lnsrsSeries11: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = clYellow
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1041#1059#1057
      ImageIndex = 4
      TabVisible = False
      object busDia: TChart
        Left = -8
        Top = 136
        Width = 905
        Height = 281
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clBlue
        Title.Font.Height = -16
        Title.Font.Name = 'Arial'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1044#1080#1072#1075#1088#1072#1084#1084#1072' '#1041#1059#1057)
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 65535.000000000000000000
        Legend.Visible = False
        View3D = False
        TabOrder = 0
        object Series5: TBarSeries
          Marks.ArrowLength = 20
          Marks.Visible = True
          SeriesColor = 10485760
          OnClick = Series5Click
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Bar'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
      object busGist: TChart
        Left = -8
        Top = 416
        Width = 905
        Height = 377
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clBlue
        Title.Font.Height = -16
        Title.Font.Name = 'Arial'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1043#1080#1089#1090#1086#1075#1088#1072#1084#1084#1072' '#1041#1059#1057)
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 65535.000000000000000000
        Legend.Visible = False
        View3D = False
        TabOrder = 1
        object Series6: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = 10485760
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
    end
  end
  object tlmWriteB: TButton
    Left = 88
    Top = 20
    Width = 89
    Height = 61
    Caption = #1047#1072#1087#1080#1089#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = tlmWriteBClick
  end
  object Panel2: TPanel
    Left = 176
    Top = 21
    Width = 726
    Height = 116
    TabOrder = 5
    object LabelHeadF: TLabel
      Left = 16
      Top = 8
      Width = 129
      Height = 20
      Caption = #1054#1090#1082#1088#1099#1090#1099#1081' '#1092#1072#1081#1083':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object fileNameLabel: TLabel
      Left = 16
      Top = 40
      Width = 3
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2x: TLabel
      Left = 692
      Top = 56
      Width = 16
      Height = 13
      Caption = '8X'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Labelx: TLabel
      Left = 648
      Top = 56
      Width = 16
      Height = 13
      Caption = '4X'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Labelx2: TLabel
      Left = 610
      Top = 56
      Width = 16
      Height = 13
      Caption = '1X'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object timeHeadLabel: TLabel
      Left = 288
      Top = 8
      Width = 53
      Height = 20
      Caption = #1042#1088#1077#1084#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object orbTimeLabel: TLabel
      Left = 288
      Top = 40
      Width = 3
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 427
      Top = 67
      Width = 226
      Height = 20
      Caption = #1055#1086#1083#1086#1078#1077#1085#1080#1077' '#1074#1086#1089#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 624
      Top = 0
      Width = 72
      Height = 20
      Caption = #1057#1082#1086#1088#1086#1089#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lbl1: TLabel
      Left = 56
      Top = 72
      Width = 93
      Height = 16
      Caption = #1058#1080#1087' '#1089#1080#1075#1085#1072#1083#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TrackBar1: TTrackBar
      Left = 376
      Top = 88
      Width = 329
      Height = 25
      Min = 1
      PageSize = 1
      Position = 1
      TabOrder = 3
      OnChange = TrackBar1Change
    end
    object PanelPlayer: TPanel
      Left = 391
      Top = 8
      Width = 202
      Height = 57
      TabOrder = 0
      object play: TSpeedButton
        Left = 40
        Top = 16
        Width = 41
        Height = 41
        Glyph.Data = {
          360C0000424D360C000000000000360000002800000020000000200000000100
          180000000000000C000001000000010000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5555555555555555555555555555
          5555555555555555555555555555555555555555555555555555555555555555
          5555FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5555555555550906030906031217
          0916230D172B0E182F10182F10172B0E16230D12180909060309060355555555
          5555FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCAC866615A1A1E0B194517195B
          1D1A65211A6C221A70241A70241A6D231A6621195C1E1945171A1F0B66615ACC
          CAC8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFE6E5E44D473F1A250E194618196F231A72241A73
          251B75261B75261B76271B76271B76271B75261A74261A73251971241947181A
          260E4D473FE6E5E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF4D473F19290F1963201A70241B73251C75261C78
          271D7A281D7B281D7C291D7C291D7C291D7B281C79281C77271B75261B712419
          6520192A0F4D473FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFE6E5E44D473F1A36131967211A73241B75261C79271D7B291D7E
          2A1E802B1F812C1F822D1F832D1F822C1F812C1E7F2B1D7D2A1C7B281C77271A
          75251A69221A37134D473FE6E5E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF4D473F19290F1968211A71251B76261D79281D7D291F802B1F84
          2C20862D21872E21882F21892F21882F21872E20852D1F822C1E802A1D7B291C
          78271B74261A6A2219290F4D473FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFCCCAC81A260E1863201972241B75261C7A281E7E2A1F832C21852E218A
          30238C31238E32249033249033238F33238E32228C3121883020852E1F812C1D
          7D2A1C78271A75251965211A260ECCCAC8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF66615A1948181A6F241B74261C78281E7D2A1F822C21872E238B302390
          32259233259434269635269635259535259434249233238E32228A3020852E1F
          812C1D7B291C77271B7225194A1866615AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          B3B0AD1A1E0C186E231A72251B77271D7C291E822C20872E228C312491332E95
          3C3C9E4C30A140289E39289D39289D39279A38269836259334238F32228A3020
          852E1E802A1C7B281B75261971241A1E0CB3B0ADFFFFFFFFFFFFFFFFFFFFFFFF
          4D473F1944161970241B74261C79291E7E2B20842E228A30249033269535257F
          3228543142955141B0542AA43C2AA33B29A03A289D38279836259334238E3221
          88301F822C1D7D2A1C77271A73251944174D473FFFFFFFFFFFFFFFFFFFFFFFFF
          1A1D0B185A1D1971241B76261D7B291F812B21872F238D31259434279A362580
          321B38201C3521305C394EA45D40B1522EA83F29A23B289D3826983624923322
          8C3120852D1E7F2B1C79281A7426195B1E1A1D0BFFFFFFFFFFFFFFFFFFFFFFFF
          1A250E1963201A73251C77271D7D2A1F832C228930248F32269636289C382782
          341C39211B35201D352226472D3E77484FB66235AC4729A03A279A3825943423
          8E3221872E1F812C1D7B281B75261A66201A260EFFFFFFFFFFFFFFFFFFFFFFFF
          192C0F196A211A73251C78271E7E2B20842D228B31249133269837289E392784
          351D39221B35211D36221E36231E362327472E47875442A95431A34225953523
          8F3321882F1F822C1D7C291B76271A6D231A2D10FFFFFFFFFFFFFFFFFFFFFFFF
          192F10196D221A73251C78271E7F2B20852D228C31249233279937299F392785
          351D3A231C35211D36231E37231E37231E36231D37232F5E3832884026963524
          903321892F1F832D1D7C291B76271A6F241A2F11FFFFFFFFFFFFFFFFFFFFFFFF
          273C1D1F7429207A2C227E2E248432268A342992392B973B2D9E3F2FA4412E8A
          3C234129223D28233E28243E2A243E2A223D281E3C231C54252582342D9B3D2B
          963B288E37268834238230217D2E20762B283D1DFFFFFFFFFFFFFFFFFFFFFFFF
          3A4D2E277A322983352B86382C8C3B2F913E329842349D4437A44839AA4A3790
          462B4B312A46302B47312B473128462E214E292C7C3937A34838A84A36A14634
          9C443195402E903D2C8A392A8537297D333B4E2EFFFFFFFFFFFFFFFFFFFFFFFF
          5461462E7D382E893C308C3E339242359745389C483AA14B3DA74E3FAC513D94
          4C2F51372E4D352C4C332856322E783C42B05442B35540AF533EAA503CA54C3A
          A04A379A46349544329040308B3E307E39546147FFFFFFFFFFFFFFFFFFFFFFFF
          656A573075352D873B2F8A3E319041349543379A47399F493CA54C3EA94F3B92
          4B2D503525492C296434399C4A42B25542B35540B0533FAC513DA84E3AA34B38
          9E49359845339343318E3F2F893D317637656A57FFFFFFFFFFFFFFFFFFFFFFFF
          948E873C68382D863A2F893C318D40339242359745389B473AA14A3CA44C378E
          46255D2F35914540AE5341B05340B05340AD523FAB503DA74E3BA44C3A9F4937
          9A47349544329141308B3E2E883C3D6839948E87FFFFFFFFFFFFFFFFFFFFFFFF
          D3D1CE5256402C84392E873B308B3E319040349543369845389D483AA14A399E
          49399C493EA9503EAB513FAB513EAA513EA84F3DA64D3BA34C39A04A389B4735
          9845339342318F3F2F893D2D863B525640D3D1CEFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF9C978F3566322C853B2E893D308C3F329141349443369845389B47399F
          493AA14B3BA34B3BA54C3CA54C3BA44C3BA34B3AA14A389E49379B4735964534
          9342328F40308B3E2E873C3567339C978FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFE4E3E14F5C402E7C372D873B2E893D308E3F329141349543359745379A
          47389C48399E49399F4A399F4A399E4A399D49389B4836994734974534934232
          9040308C3E2E893C307E384F5C41E4E3E1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF99958F4A5A3D2E7F382D863B2F893D308C3F3190403392423495
          43359744359745369846369946369846359745359644339343329141318E4030
          8B3E2E883C2F80394A5B3D99958FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFF1F1F0928C863C59312D7E382D873B2E893D308B3E318D403290
          41339242339342339443349443339443339342329141318F41308D3F308A3E2E
          883C2F80393C5931928C86F1F1F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF928D854A5B3C2E7B372C853A2E873B2F893C2F8A
          3E308C3E318D3F318E3F318E3F318E3F318D3F308C3E2F8A3D2E883C2E863B2F
          7D384A5B3C928D85FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFF1F1F099948E515D433665322C84392D863A2D87
          3B2E893C2F893D2F893D2F893D2F893D2F893C2E883C2D873B2C853A36653351
          5E4399948EF1F1F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4E2A09B955256403C67383075
          352E7C382D81392D84392D84392D82392F7C383075363C6838525640A09B95E4
          E4E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD3D1CEC6C3BE6469
          565461474557383D522F3D522F455738546147646956C6C3BED3D1CEFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = playClick
      end
      object pause: TSpeedButton
        Left = 80
        Top = 16
        Width = 41
        Height = 41
        Glyph.Data = {
          360C0000424D360C000000000000360000002800000020000000200000000100
          180000000000000C000001000000010000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5555555555555555555555555555
          5555555555555555555555555555555555555555555555555555555555555555
          5555FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5555555555550906030906031217
          0916230D172B0E182F10182F10172B0E16230D12180909060309060355555555
          5555FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCAC866615A1A1E0B194517195B
          1D1A65211A6C221A70241A70241A6D231A6621195C1E1945171A1F0B66615ACC
          CAC8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFE6E5E44D473F1A250E194618196F231A72241A73
          251B75261B75261B76271B76271B76271B75261A74261A73251971241947181A
          260E4D473FE6E5E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF4D473F19290F1963201A70241B73251C75261C78
          271D7A281D7B281D7C291D7C291D7C291D7B281C79281C77271B75261B712419
          6520192A0F4D473FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFE6E5E44D473F1A36131967211A73241B75261C79271D7B291D7E
          2A1E802B1F812C1F822D1F832D1F822C1F812C1E7F2B1D7D2A1C7B281C77271A
          75251A69221A37134D473FE6E5E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF4D473F19290F1968211A71251B76261D79281D7D291F802B1F84
          2C20862D21872E21882F21892F21882F21872E20852D1F822C1E802A1D7B291C
          78271B74261A6A2219290F4D473FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFCCCAC81A260E1863201972241B75261C7A281E7E2A1F832C21852E218A
          30238C31238E32249033249033238F33238E32228C3121883020852E1F812C1D
          7D2A1C78271A75251965211A260ECCCAC8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF66615A1948181A6F241B74261C78281E7D2A1F822C21872E238B302390
          32259233259434269635269635259535259434249233238E32228A3020852E1F
          812C1D7B291C77271B7225194A1866615AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          B3B0AD1A1E0C186E231A72251B77271D7C291E822C20872E228C3124913337A2
          4738A64A33A445289D39289D3933A44539A74B38A549259334238F32228A3020
          852E1E802A1C7B281B75261971241A1E0CB3B0ADFFFFFFFFFFFFFFFFFFFFFFFF
          4D473F1944161970241B74261C79291E7E2B20842E228A302490332695352F64
          3A30623A2E783B2AA33B2AA33B2F7C3C30633A2F623A279836259334238E3221
          88301F822C1D7D2A1C77271A73251944174D473FFFFFFFFFFFFFFFFFFFFFFFFF
          1A1D0B185A1D1971241B76261D7B291F812B21872F238D31259434279A361C38
          211A331F205B292CA93F2CAA3F23612C1A341F1A331F289D3826983624923322
          8C3120852D1E7F2B1C79281A7426195B1E1A1D0BFFFFFFFFFFFFFFFFFFFFFFFF
          1A250E1963201A73251C77271D7D2A1F832C228930248F32269636289C381D39
          231C3521225D2B2EAE412EAF4124632E1C35211B342029A03A279A3825943423
          8E3221872E1F812C1D7B281B75261A66201A260EFFFFFFFFFFFFFFFFFFFFFFFF
          192C0F196A211A73251C78271E7E2B20842D228B31249133269837289E391E39
          241D3522235F2D2FB2422FB4432665301D36221C34212AA23B289D3925953523
          8F3321882F1F822C1D7C291B76271A6D231A2D10FFFFFFFFFFFFFFFFFFFFFFFF
          192F10196D221A73251C78271E7F2B20852D228C31249233279937299F391E3A
          241E362324602E30B44431B6452767311E36231D35222AA33B289D3926963524
          903321892F1F832D1D7C291B76271A6F241A2F11FFFFFFFFFFFFFFFFFFFFFFFF
          273C1D1F7429207A2C227E2E248432268A342992392B973B2D9E3F2FA4412541
          2B233D2829663437B74A37B94B2E6C37233E29233C2931A7432FA2412D9B3D2B
          963B288E37268834238230217D2E20762B283D1DFFFFFFFFFFFFFFFFFFFFFFFF
          3A4D2E277A322983352B86382C8C3B2F913E329842349D4437A44839AA4A2C4B
          332B4731326D3C40B95340BB543473402B47312B46303AAD4C38A84A36A14634
          9C443195402E903D2C8A392A8537297D333B4E2EFFFFFFFFFFFFFFFFFFFFFFFF
          5461462E7D382E893C308C3E339242359745389C483AA14B3DA74E3FAC513152
          382F4D3636714146BA5946BB593A78452F4D362F4C3540AF533EAA503CA54C3A
          A04A379A46349544329040308B3E307E39546147FFFFFFFFFFFFFFFFFFFFFFFF
          656A573075352D873B2F8A3E319041349543379A47399F493CA54C3EA94F2F50
          372D4B34346F3F43B55743B6573876432D4C342D4B343FAC513DA84E3AA34B38
          9E49359845339343318E3F2F893D317637656A57FFFFFFFFFFFFFFFFFFFFFFFF
          948E873C68382D863A2F893C318D40339242359745389B473AA14A3CA44C2265
          2E22622C2C7D3A40B05341B0532E813D22642D22622C3DA74E3BA44C3A9F4937
          9A47349544329141308B3E2E883C3D6839948E87FFFFFFFFFFFFFFFFFFFFFFFF
          D3D1CE5256402C84392E873B308B3E319040349543369845389D483AA14A3CA5
          4C3DA74E3EA9503EAB513FAB513EAA513EA84F3DA64D3BA34C39A04A389B4735
          9845339342318F3F2F893D2D863B525640D3D1CEFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF9C978F3566322C853B2E893D308C3F329141349443369845389B47399F
          493AA14B3BA34B3BA54C3CA54C3BA44C3BA34B3AA14A389E49379B4735964534
          9342328F40308B3E2E873C3567339C978FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFE4E3E14F5C402E7C372D873B2E893D308E3F329141349543359745379A
          47389C48399E49399F4A399F4A399E4A399D49389B4836994734974534934232
          9040308C3E2E893C307E384F5C41E4E3E1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF99958F4A5A3D2E7F382D863B2F893D308C3F3190403392423495
          43359744359745369846369946369846359745359644339343329141318E4030
          8B3E2E883C2F80394A5B3D99958FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFF1F1F0928C863C59312D7E382D873B2E893D308B3E318D403290
          41339242339342339443349443339443339342329141318F41308D3F308A3E2E
          883C2F80393C5931928C86F1F1F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF928D854A5B3C2E7B372C853A2E873B2F893C2F8A
          3E308C3E318D3F318E3F318E3F318E3F318D3F308C3E2F8A3D2E883C2E863B2F
          7D384A5B3C928D85FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFF1F1F099948E515D433665322C84392D863A2D87
          3B2E893C2F893D2F893D2F893D2F893D2F893C2E883C2D873B2C853A36653351
          5E4399948EF1F1F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4E2A09B955256403C67383075
          352E7C382D81392D84392D84392D82392F7C383075363C6838525640A09B95E4
          E4E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD3D1CEC6C3BE6469
          565461474557383D522F3D522F455738546147646956C6C3BED3D1CEFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = pauseClick
      end
      object stop: TSpeedButton
        Left = 120
        Top = 16
        Width = 41
        Height = 41
        Glyph.Data = {
          360C0000424D360C000000000000360000002800000020000000200000000100
          180000000000000C000001000000010000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5555555555555555555555555555
          5555555555555555555555555555555555555555555555555555555555555555
          5555FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5555555555550906030906031217
          0916230D172B0E182F10182F10172B0E16230D12180909060309060355555555
          5555FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCAC866615A1A1E0B194517195B
          1D1A65211A6C221A70241A70241A6D231A6621195C1E1945171A1F0B66615ACC
          CAC8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFE6E5E44D473F1A250E194618196F231A72241A73
          251B75261B75261B76271B76271B76271B75261A74261A73251971241947181A
          260E4D473FE6E5E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF4D473F19290F1963201A70241B73251C75261C78
          271D7A281D7B281D7C291D7C291D7C291D7B281C79281C77271B75261B712419
          6520192A0F4D473FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFE6E5E44D473F1A36131967211A73241B75261C79271D7B291D7E
          2A1E802B1F812C1F822D1F832D1F822C1F812C1E7F2B1D7D2A1C7B281C77271A
          75251A69221A37134D473FE6E5E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF4D473F19290F1968211A71251B76261D79281D7D291F802B1F84
          2C20862D21872E21882F21892F21882F21872E20852D1F822C1E802A1D7B291C
          78271B74261A6A2219290F4D473FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFCCCAC81A260E1863201972241B75261C7A281E7E2A1F832C21852E218A
          30238C31238E32249033249033238F33238E32228C3121883020852E1F812C1D
          7D2A1C78271A75251965211A260ECCCAC8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF66615A1948181A6F241B74261C78281E7D2A1F822C21872E238B302390
          32259233259434269635269635259535259434249233238E32228A3020852E1F
          812C1D7B291C77271B7225194A1866615AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          B3B0AD1A1E0C186E231A72251B77271D7C291E822C20872E238C312F993E36A2
          4737A54939A84B3AAA4C3BAA4C3AA94C38A74A37A548309C41249033228A3020
          852E1E802A1C7B281B75261971241A1E0CB3B0ADFFFFFFFFFFFFFFFFFFFFFFFF
          4D473F1944161970241B74261C79291E7E2B20842E228A30258F332A6E352C5F
          362E613830633A31643B31643B30633A2F62392D61372A7036269335238E3221
          88301F822C1D7D2A1C77271A73251944174D473FFFFFFFFFFFFFFFFFFFFFFFFF
          1A1D0B185A1D1971241B76261D7B291F812B21872F238D312593341C50241731
          1C19321E1A331F1B34201B34201A341F1A331F18321D1D532527973624923322
          8C3120852D1E7F2B1C79281A7426195B1E1A1D0BFFFFFFFFFFFFFFFFFFFFFFFF
          1A250E1963201A73251C77271D7D2A1F832C228930248F322695361D52251932
          1E1B341F1B35201C35221D36221C35211B35201A331F1E542728993825943423
          8E3221872E1F812C1D7B281B75261A66201A260EFFFFFFFFFFFFFFFFFFFFFFFF
          192C0F196A211A73251C78271E7E2B20842D228B312491332797371E53261932
          1E1B34201C35211D36221E36231D36221C35211A341F1F5527289B3925953523
          8F3321882F1F822C1D7C291B76271A6D231A2D10FFFFFFFFFFFFFFFFFFFFFFFF
          192F10196D221A73251C78271E7F2B20852D228C312492332798371E54261A33
          1F1C35211D36221E37231F37241E36231D36221B34201F5627299C3926963524
          903321892F1F832D1D7C291B76271A6F241A2F11FFFFFFFFFFFFFFFFFFFFFFFF
          273C1D1F7429207A2C227E2E248432268A342992392B973B2E9D3F245A2D203A
          25213C27223D29243E29243E2A233E29223D29213C27255C2E2FA1412D9B3D2B
          963B288E37268834238230217D2E20762B283D1DFFFFFFFFFFFFFFFFFFFFFFFF
          3A4D2E277A322983352B86382C8C3B2F913E329842349D4437A3482B63352744
          2D29462F2A47302B47322C48322B47312A473029452E2D643739A74A36A14634
          9C443195402E903D2C8A392A8537297D333B4E2EFFFFFFFFFFFFFFFFFFFFFFFF
          5461462E7D382E893C308C3E339242359745389C483AA14B3EA64E31683C2B4B
          322D4C342F4D35304E37314E37304D362F4D352D4B34326A3D3FA9503CA54C3A
          A04A379A46349544329040308B3E307E39546147FFFFFFFFFFFFFFFFFFFFFFFF
          656A573075352D873B2F8A3E319041349543379A47399F493CA34C30663A2949
          302B4B322D4B342E4C352E4C352E4B342D4B332B4A3231683B3EA74E3AA34B38
          9E49359845339343318E3F2F893D317637656A57FFFFFFFFFFFFFFFFFFFFFFFF
          948E873C68382D863A2F893C318D40339242359745389B473AA04A2874352261
          2C22622C22642E22642F23642F22642F22642D22622C2A76363BA34C3A9F4937
          9A47349544329141308B3E2E883C3D6839948E87FFFFFFFFFFFFFFFFFFFFFFFF
          D3D1CE5256402C84392E873B308B3E319040349543369845389D483AA14A3CA5
          4C3DA74E3EA9503EAB513FAB513EAA513EA84F3DA64D3BA34C39A04A389B4735
          9845339342318F3F2F893D2D863B525640D3D1CEFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF9C978F3566322C853B2E893D308C3F329141349443369845389B47399F
          493AA14B3BA34B3BA54C3CA54C3BA44C3BA34B3AA14A389E49379B4735964534
          9342328F40308B3E2E873C3567339C978FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFE4E3E14F5C402E7C372D873B2E893D308E3F329141349543359745379A
          47389C48399E49399F4A399F4A399E4A399D49389B4836994734974534934232
          9040308C3E2E893C307E384F5C41E4E3E1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF99958F4A5A3D2E7F382D863B2F893D308C3F3190403392423495
          43359744359745369846369946369846359745359644339343329141318E4030
          8B3E2E883C2F80394A5B3D99958FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFF1F1F0928C863C59312D7E382D873B2E893D308B3E318D403290
          41339242339342339443349443339443339342329141318F41308D3F308A3E2E
          883C2F80393C5931928C86F1F1F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF928D854A5B3C2E7B372C853A2E873B2F893C2F8A
          3E308C3E318D3F318E3F318E3F318E3F318D3F308C3E2F8A3D2E883C2E863B2F
          7D384A5B3C928D85FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFF1F1F099948E515D433665322C84392D863A2D87
          3B2E893C2F893D2F893D2F893D2F893D2F893C2E883C2D873B2C853A36653351
          5E4399948EF1F1F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4E2A09B955256403C67383075
          352E7C382D81392D84392D84392D82392F7C383075363C6838525640A09B95E4
          E4E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD3D1CEC6C3BE6469
          565461474557383D522F3D522F455738546147646956C6C3BED3D1CEFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = stopClick
      end
      object Label3: TLabel
        Left = 2
        Top = 0
        Width = 197
        Height = 20
        Caption = #1055#1072#1085#1077#1083#1100' '#1074#1086#1089#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
    object tlmPSpeed: TTrackBar
      Left = 608
      Top = 24
      Width = 105
      Height = 25
      Max = 7
      PageSize = 1
      Position = 3
      TabOrder = 1
      OnChange = tlmPSpeedChange
    end
    object Button1: TButton
      Left = 296
      Top = 80
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object startReadACP: TButton
    Left = 0
    Top = 80
    Width = 89
    Height = 57
    Caption = #1055#1088#1080#1077#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = startReadACPClick
  end
  object startReadTlmB: TButton
    Left = 88
    Top = 80
    Width = 89
    Height = 57
    Caption = #1063#1090#1077#1085#1080#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = startReadTlmBClick
  end
  object propB: TButton
    Left = 0
    Top = 20
    Width = 89
    Height = 61
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = propBClick
  end
  object rb1: TRadioButton
    Left = 184
    Top = 112
    Width = 89
    Height = 17
    Caption = #1055#1088#1103#1084#1086#1081
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    TabStop = True
  end
  object rb2: TRadioButton
    Left = 280
    Top = 112
    Width = 113
    Height = 17
    Caption = #1048#1085#1074#1077#1088#1089#1085#1099#1081
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
  end
  object btnAutoTest: TButton
    Left = 1136
    Top = 8
    Width = 273
    Height = 81
    Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1087#1088#1086#1074#1077#1088#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btnAutoTestClick
  end
  object mmoTestResult: TMemo
    Left = 1136
    Top = 128
    Width = 465
    Height = 625
    ScrollBars = ssBoth
    TabOrder = 11
  end
  object btn1: TButton
    Left = 1048
    Top = 712
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 12
    OnClick = btn1Click
  end
  object TimerOutToDia: TTimer
    Enabled = False
    Interval = 55
    OnTimer = TimerOutToDiaTimer
    Left = 704
    Top = 136
  end
  object OpenDialog1: TOpenDialog
    Filter = #1092#1086#1088#1084#1072#1090' tlm(tlm)|*.tlm'
    Left = 808
    Top = 136
  end
  object TimerPlayTlm: TTimer
    Enabled = False
    Interval = 250
    OnTimer = TimerPlayTlmTimer
    Left = 832
    Top = 136
  end
  object OpenDialog2: TOpenDialog
    Filter = #1090#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'(txt)|*.txt'
    Left = 784
    Top = 136
  end
  object TimerOutToDiaBus: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerOutToDiaBusTimer
    Left = 732
    Top = 136
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 860
    Top = 136
  end
  object tmrForTestOrbSignal: TTimer
    Enabled = False
    Interval = 50
    OnTimer = tmrForTestOrbSignalTimer
    Left = 60
    Top = 80
  end
  object tmrCont: TTimer
    Enabled = False
    Interval = 55
    OnTimer = tmrContTimer
    Left = 756
    Top = 136
  end
  object idhttp1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 1384
    Top = 64
  end
  object idpsrvr1: TIdUDPServer
    Bindings = <>
    DefaultPort = 6008
    OnUDPRead = idpsrvr1UDPRead
    Left = 1360
    Top = 64
  end
  object tmr1_1_10_2: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmr1_1_10_2Timer
    Left = 1280
    Top = 96
  end
  object tmrAllTest: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmrAllTestTimer
    Left = 1248
    Top = 96
  end
  object tmrRCo: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = tmrRCoTimer
    Left = 1304
    Top = 96
  end
  object tmrTestSRN2: TTimer
    Enabled = False
    OnTimer = tmrTestSRN2Timer
    Left = 1336
    Top = 96
  end
  object idhttp2: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 1408
    Top = 64
  end
  object tmrMKB_Dpart: TTimer
    Enabled = False
    OnTimer = tmrMKB_DpartTimer
    Left = 1416
    Top = 40
  end
  object tmrF: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = tmrFTimer
    Left = 1416
    Top = 8
  end
end
