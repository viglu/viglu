unit MainFORM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  GhostscriptApi, Vcl.ComCtrls;

type
  TfrmMain = class(TForm)
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    pnlInfo: TPanel;
    Memo1: TMemo;
    pnlMain: TPanel;
    pnlVersion: TPanel;
    lblVersion: TLabel;
    btnBrowseInput: TButton;
    btnBrowseOutput: TButton;
    edtOutputFilename: TEdit;
    edtInputFilename: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbConversionMethod: TComboBox;
    Label4: TLabel;
    btnConvert: TButton;
    meStdIO: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseInputClick(Sender: TObject);
    procedure btnBrowseOutputClick(Sender: TObject);
    procedure btnConvertClick(Sender: TObject);
  private
    { Private declarations }
//    function stdin(caller_handle: Pointer; buf: PAnsichar; len: Integer): Integer;
  //  function stdout(caller_handle: Pointer; buf: PAnsichar; len: Integer): Integer;
    //function stderr(caller_handle: Pointer; buf: PAnsichar; len: Integer): Integer;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function stderr(caller_handle: Pointer; buf: PAnsichar;
  len: Integer): Integer; stdcall;
begin
  frmMain.meStdIO.Lines.Text :=
    frmMain.meStdIO.Lines.Text +
    StringReplace(Copy(buf, 1, len), #10, #13#10, [rfReplaceAll, rfIgnoreCase]);
  Result := len;
end;

function stdin(caller_handle: Pointer; buf: PAnsichar;
  len: Integer): Integer; stdcall;
begin
  frmMain.meStdIO.Lines.Text :=
    frmMain.meStdIO.Lines.Text +
    StringReplace(Copy(buf, 1, len), #10, #13#10, [rfReplaceAll, rfIgnoreCase]);
  Result := len;
end;

function stdout(caller_handle: Pointer; buf: PAnsichar;
  len: Integer): Integer; stdcall;
begin
  frmMain.meStdIO.Lines.Text :=
    frmMain.meStdIO.Lines.Text +
    StringReplace(Copy(buf, 1, len), #10, #13#10, [rfReplaceAll, rfIgnoreCase]);
  Result := len;
end;



procedure TfrmMain.FormCreate(Sender: TObject);
var
  gsVersion: TGSAPI_Revision_S;
begin
  pnlMain.Enabled := LoadGSDLL;
  if IsGSDLLLoaded then
  begin
    GSAPI_Revision(gsVersion, 16);
    lblVersion.Caption := gsVersion.product + #13#10 +
                          gsVersion.copyright + #13#10 +
                          IntToStr(gsVersion.revision) + ' / ' +
                          IntToStr(gsVersion.revisiondate);
  end;
end;

procedure TfrmMain.btnBrowseInputClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    edtInputFilename.Text := dlgOpen.FileName;
    edtOutputFilename.Text := ChangeFileExt(edtInputFilename.Text, '.tif');
  end;
end;

procedure TfrmMain.btnBrowseOutputClick(Sender: TObject);
begin
  if dlgSave.Execute then
  begin
    edtOutputFilename.Text := dlgSave.FileName;
  end;
end;


procedure TfrmMain.btnConvertClick(Sender: TObject);
var
  gsInstance: Pointer;
  apiResult, I: Integer;
  argv: array of PAnsiChar;
  slargv: TStringList;
begin
  if (edtInputFilename.Text = '') or (edtOutputFilename.Text = '') then
    Exit;

  if GSAPI_New_Instance(gsInstance, nil) = 0 then
  begin
    GSAPI_Set_Stdio(gsInstance, @stdin, @stdout, @stderr);

    apiResult := GSAPI_Set_Arg_Encoding(gsInstance, GS_ARG_ENCODING_UTF8);
    if apiResult = 0 then
    begin
      SetLength(argv, 9);
      argv[0] := '-q';
      argv[1] := '-dNOPAUSE';
      argv[2] := '-dBATCH';
      argv[3] := PAnsiChar(AnsiString('-sDEVICE=' + cbConversionMethod.Text));
      argv[4] := '-r300x300';
      argv[5] := '-dPDFFitPage';
      argv[6] := '-sPAPERSIZE=a4';
      argv[7] := PAnsiChar(AnsiString('-sOutputFile=' + edtOutputFilename.Text));
      argv[8] := PAnsiChar(AnsiString(edtInputFilename.Text));

      apiResult := GSAPI_Init_With_Args(gsInstance, Length(argv), @argv[0]);
      if apiResult <> 0 then
        ShowMessage('GSAPI_Init_With_Args returned with error: ' + IntToStr(apiResult));
      GSAPI_Exit(gsInstance);
    end else
    begin
      ShowMessage('GSAPI_Set_Arg_Encoding returned with error: ' + IntToStr(apiResult));
    end;

    GSAPI_Delete_Instance(gsInstance);
  end else
  begin
    ShowMessage('GSAPI_New_Instance returned with error: ' + IntToStr(apiResult));
  end;
end;

end.
