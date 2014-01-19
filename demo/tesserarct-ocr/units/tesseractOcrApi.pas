unit tesseractOcrApi;

interface

uses
  Windows;

type
  TTessBaseAPI = longint;
  PTessBaseAPI = Pointer;


(* General free functions *)
(*
TESS_API const char*
               TESS_CALL TessVersion();
TESS_API void  TESS_CALL TessDeleteText(char* text);
TESS_API void  TESS_CALL TessDeleteTextArray(char** arr);
TESS_API void  TESS_CALL TessDeleteIntArray(int* arr);
#ifdef TESS_CAPI_INCLUDE_BASEAPI
TESS_API void  TESS_CALL TessDeleteBlockList(BLOCK_LIST* block_list);
#endif *)

type
  TTessVersion = function: PAnsiChar; cdecl;

(* Base API *)
  //TessBaseAPI* TESS_CALL TessBaseAPICreate();
  TTessBaseAPICreate = function: PTessBaseAPI; cdecl;

  //TESS_API void  TESS_CALL TessBaseAPIDelete(TessBaseAPI* handle);
  TTessBaseAPIDelete = procedure (handle: PTessBaseAPI); cdecl;

  //TESS_API int   TESS_CALL TessBaseAPIInit3(TessBaseAPI* handle, const char* datapath, const char* language);
  TTessBaseAPIInit3 = function(handle: PTessBaseAPI; datapath: PAnsiChar; language: PAnsiChar): LongInt; cdecl;

  //TESS_API char* TESS_CALL TessBaseAPIProcessPages(TessBaseAPI* handle, const char* filename, const char* retry_config, int timeout_millisec);
  TTessBaseAPIProcessPages = function (handle: PTessBaseAPI; filename: PAnsiChar; retry_config: PAnsiChar; timeout_millisec: LongInt): PAnsiChar; cdecl;

  //TESS_API void  TESS_CALL TessBaseAPISetInputName( TessBaseAPI* handle, const char* name);
  TTessBaseAPISetInputName = procedure(handle: PTessBaseAPI; name: PAnsiChar); cdecl;
  //TESS_API void  TESS_CALL TessBaseAPISetOutputName(TessBaseAPI* handle, const char* name);
  TTessBaseAPISetOutputName = procedure(handle: PTessBaseAPI; name: PAnsiChar); cdecl;

  //char* TESS_CALL TessBaseAPIGetUTF8Text(TessBaseAPI* handle);
  TTessBaseAPIGetUTF8Text = function(handle: PTessBaseApi): PAnsiChar; cdecl;


var
  TessVersion: TTessVersion = nil;
  TessBaseAPICreate: TTessBaseAPICreate = nil;
  TessBaseAPIDelete: TTessBaseAPIDelete = nil;
  TessBaseAPIInit3: TTessBaseAPIInit3 = nil;
  TessBaseAPIProcessPages: TTessBaseAPIProcessPages = nil;
  TessBaseAPISetInputName: TTessBaseAPISetInputName = nil;
  TessBaseAPISetOutputName: TTessBaseAPISetOutputName = nil;
  TessBaseAPIGetUTF8Text: TTessBaseAPIGetUTF8Text = nil;

function LoadTessaractOcrDLL: Boolean;
function IsTessaractOcrDLLLoaded: Boolean;

implementation

const
  TESSERACTOCRDLLNAME = 'libtesseract302.dll';

var
  hTessaractOcr: HMODULE = 0;

function IsTessaractOcrDLLLoaded: Boolean;
begin
  Result := hTessaractOcr <> 0;
end;

function LoadTessaractOcrDLL: Boolean;
begin
  if not IsTessaractOcrDLLLoaded
  then begin
         hTessaractOcr := LoadLibrary(TESSERACTOCRDLLNAME);
         if IsTessaractOcrDLLLoaded
         then begin
                @TessVersion := GetProcAddress(hTessaractOcr, 'TessVersion');
                @TessBaseAPICreate := GetProcAddress(hTessaractOcr, 'TessBaseAPICreate');
                @TessBaseAPIDelete := GetProcAddress(hTessaractOcr, 'TessBaseAPIDelete');
                @TessBaseAPIInit3 := GetProcAddress(hTessaractOcr, 'TessBaseAPIInit3');
                @TessBaseAPIProcessPages := GetProcAddress(hTessaractOcr, 'TessBaseAPIProcessPages');
                @TessBaseAPISetInputName := GetProcAddress(hTessaractOcr, 'TessBaseAPISetInputName');
                @TessBaseAPISetOutputName := GetProcAddress(hTessaractOcr, 'TessBaseAPISetOutputName');
                @TessBaseAPIGetUTF8Text :=  GetProcAddress(hTessaractOcr, 'TessBaseAPIGetUTF8Text');
                Result := True;
              end
         else Result := False;
       end
  else Result := True;
end;

end.
