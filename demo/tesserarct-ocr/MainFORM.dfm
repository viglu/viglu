object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'tesseract OCR Demo'
  ClientHeight = 363
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlInfo: TPanel
    Left = 0
    Top = 0
    Width = 533
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -25
    ExplicitWidth = 560
    object Label1: TLabel
      Left = 272
      Top = 68
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object Memo1: TMemo
      Left = 0
      Top = 0
      Width = 533
      Height = 81
      TabStop = False
      Align = alClient
      Color = clBtnFace
      Lines.Strings = (
        
          'This little tool will demonstrate how to use the tesserarct ORC ' +
          'interface.'
        ''
        'libtesseract302.dll will extract text from TIFF files.'
        
          'Do not forget to the directory tessdata and liblept168.dll to th' +
          'e output directory of this demo tool')
      ReadOnly = True
      TabOrder = 0
      ExplicitWidth = 560
    end
  end
  object pnlVersion: TPanel
    Left = 0
    Top = 81
    Width = 533
    Height = 40
    Align = alTop
    TabOrder = 1
    object lblVersion: TLabel
      Left = 8
      Top = 7
      Width = 513
      Height = 27
      AutoSize = False
      WordWrap = True
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 121
    Width = 533
    Height = 242
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 184
    ExplicitTop = 144
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Label2: TLabel
      Left = 8
      Top = 13
      Width = 90
      Height = 13
      Caption = 'File to extract text'
    end
    object edtInputFilename: TEdit
      Left = 8
      Top = 32
      Width = 480
      Height = 21
      TabOrder = 0
    end
    object btnBrowse: TButton
      Left = 494
      Top = 30
      Width = 27
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = btnBrowseClick
    end
    object btnExtract: TButton
      Left = 228
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Extract text'
      TabOrder = 2
      OnClick = btnExtractClick
    end
    object meText: TMemo
      Left = 8
      Top = 104
      Width = 513
      Height = 129
      TabOrder = 3
    end
  end
  object dlgOpen: TOpenDialog
    Left = 408
    Top = 80
  end
end
