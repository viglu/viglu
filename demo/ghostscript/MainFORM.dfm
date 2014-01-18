object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Ghostscript Demo'
  ClientHeight = 451
  ClientWidth = 560
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
    Width = 560
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
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
      Width = 560
      Height = 81
      TabStop = False
      Align = alClient
      Color = clBtnFace
      Lines.Strings = (
        
          'This little tool will demonstrate how to use the ghostscript int' +
          'erface.'
        ''
        
          'With the help of gsdll32.dll from the ghostscript a file will be' +
          ' converted from PDF to tiff format.')
      ReadOnly = True
      TabOrder = 0
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 138
    Width = 560
    Height = 313
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 205
    object Label2: TLabel
      Left = 8
      Top = 57
      Width = 127
      Height = 13
      Caption = 'Output filename (TIFF file)'
    end
    object Label3: TLabel
      Left = 8
      Top = 6
      Width = 179
      Height = 13
      Caption = 'Input filename (PDF or Postscript file)'
    end
    object Label4: TLabel
      Left = 8
      Top = 112
      Width = 130
      Height = 13
      Caption = 'Choose conversion method'
    end
    object edtOutputFilename: TEdit
      Left = 8
      Top = 76
      Width = 505
      Height = 21
      TabOrder = 2
    end
    object edtInputFilename: TEdit
      Left = 8
      Top = 24
      Width = 505
      Height = 21
      TabOrder = 0
    end
    object btnBrowseOutput: TButton
      Left = 519
      Top = 74
      Width = 29
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = btnBrowseOutputClick
    end
    object btnBrowseInput: TButton
      Left = 519
      Top = 22
      Width = 29
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = btnBrowseInputClick
    end
    object cbConversionMethod: TComboBox
      Left = 8
      Top = 131
      Width = 179
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 4
      Text = 'tiff24nc'
      Items.Strings = (
        'tiff12nc'
        'tiff24nc'
        'tiff32nc'
        'tiff48nc '
        'tiff64nc'
        'tiffcrle'
        'tiffg3'
        'tiffg32d'
        'tiffg4'
        'tiffgray'
        'tifflzw '
        'tiffpack '
        'tiffscaled '
        'tiffscaled24'
        'tiffscaled32'
        'tiffscaled4'
        'tiffscaled8'
        'tiffsep'
        'tiffsep1')
    end
    object btnConvert: TButton
      Left = 473
      Top = 168
      Width = 75
      Height = 25
      Caption = 'Convert'
      TabOrder = 5
      OnClick = btnConvertClick
    end
    object meStdIO: TMemo
      Left = 8
      Top = 208
      Width = 540
      Height = 97
      TabOrder = 6
    end
  end
  object pnlVersion: TPanel
    Left = 0
    Top = 81
    Width = 560
    Height = 57
    Align = alTop
    TabOrder = 2
    object lblVersion: TLabel
      Left = 8
      Top = 6
      Width = 545
      Height = 45
      AutoSize = False
      WordWrap = True
    end
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'pdf'
    Filter = 
      'All files (*.*)|*.*|PDF files (*.pdf)|*.pdf|Postscript files (*.' +
      'ps)|*.ps'
    Left = 440
    Top = 16
  end
  object dlgSave: TSaveDialog
    Left = 512
    Top = 16
  end
end
