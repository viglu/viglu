unit MainFORM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  tesseractOcrApi;

type
  TForm1 = class(TForm)
    pnlInfo: TPanel;
    Label1: TLabel;
    Memo1: TMemo;
    pnlVersion: TPanel;
    lblVersion: TLabel;
    pnlMain: TPanel;
    Label2: TLabel;
    edtInputFilename: TEdit;
    btnBrowse: TButton;
    dlgOpen: TOpenDialog;
    btnExtract: TButton;
    meText: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnExtractClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  pnlMain.Enabled := LoadTessaractOcrDLL;

  if pnlMain.Enabled then
  begin
    lblVersion.Caption := 'libtesseract302.dll Version ' + String(TessVersion);
  end else
    lblVersion.Caption := 'libtesseract302.dll not loaded';
end;

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    edtInputFilename.Text := dlgOpen.FileName;
  end;
end;

procedure TForm1.btnExtractClick(Sender: TObject);
var
  data: PAnsiChar;
  TessBaseApi: PTessBaseAPI;
  apiResult: Integer;
begin
  btnExtract.Enabled := False;

  TessbaseApi := TessBaseAPICreate;
  if TessBaseApi <> nil then
  begin
    apiResult := TessBaseAPIInit3(TessbaseApi, PAnsiChar('.\tessdata\'), PAnsiChar('eng'));
    if apiResult = 0 then
    begin
      data := TessBaseAPIProcessPages(TessbaseApi, PAnsiChar(AnsiString(edtInputFilename.Text)), nil, 0);
      meText.Lines.Add( UTF8ToString(data) );
    end else
      meText.Lines.Add('TessBaseAPIInit3 failed with error code ' + IntToStr(apiResult));

    TessBaseAPIDelete(TessbaseApi);
  end;

  btnExtract.Enabled := True;
end;


end.
