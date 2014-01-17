unit ghostscriptApi;

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses
  windows;

type
  TGSAPI_Revision_S = packed record
    product: PAnsiChar;
    copyright: PAnsiChar;
    revision: cardinal;
    revisiondate: cardinal;
  end;

(* Get version numbers and strings.
 * This is safe to call at any time.
 * You should call this first to make sure that the correct version
 * of the Ghostscript is being used.
 * pr is a pointer to a revision structure.
 * len is the size of this structure in bytes.
 * Returns 0 if OK, or if len too small (additional parameters
 * have been added to the structure) it will return the required
 * size of the structure.
 *)
 TGSAPI_Revision = function(var pr: TGSAPI_Revision_S; len: Integer): Integer; stdcall;

(*
 * WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
 *  Ghostscript supports only one instance.
 *  The current implementation uses a global static instance
 *  counter to make sure that only a single instance is used.
 *  If you try to create two instances, the second attempt
 *  will return < 0 and set pinstance to NULL.
 * WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
 *)
(* Create a new instance of Ghostscript.
 * This instance is passed to most other API functions.
 * The caller_handle will be provided to callback functions.
 *)
  TGSAPI_New_Instance = function(var pinstance: Pointer; caller_handle: Pointer): Integer; stdcall;


(*
 * WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
 *  Ghostscript supports only one instance.
 *  The current implementation uses a global static instance
 *  counter to make sure that only a single instance is used.
 * WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
 *)
(* Destroy an instance of Ghostscript
 * Before you call this, Ghostscript must have finished.
 * If Ghostscript has been initialised, you must call gsapi_exit()
 * before gsapi_delete_instance.
 *)
 TGSAPI_Delete_Instance = procedure(instance: Pointer); stdcall;

(* Set the callback functions for stdio
 * The stdin callback function should return the number of
 * characters read, 0 for EOF, or -1 for error.
 * The stdout and stderr callback functions should return
 * the number of characters written.
 * If a callback address is NULL, the real stdio will be used.
 *)
{GSDLLEXPORT int GSDLLAPI
gsapi_set_stdio(void *instance,
    int (GSDLLCALLPTR stdin_fn)(void *caller_handle, char *buf, int len),
    int (GSDLLCALLPTR stdout_fn)(void *caller_handle, const char *str, int len),
    int (GSDLLCALLPTR stderr_fn)(void *caller_handle, const char *str, int len));}

(* Set the callback function for polling.
 * This is used for handling window events or cooperative
 * multitasking.  This function will only be called if
 * Ghostscript was compiled with CHECK_INTERRUPTS
 * as described in gpcheck.h.
 * The polling function should return 0 if all is well,
 * and negative if it wants ghostscript to abort.
 * The polling function must be fast.
 *)
{GSDLLEXPORT int GSDLLAPI gsapi_set_poll(void *instance,
    int (GSDLLCALLPTR poll_fn)(void *caller_handle));}

(* Set the display device callback structure.
 * If the display device is used, this must be called
 * after gsapi_new_instance() and before gsapi_init_with_args().
 * See gdevdisp.h for more details.
 *)
{GSDLLEXPORT int GSDLLAPI gsapi_set_display_callback(
   void *instance, display_callback *callback);}

(* Set the encoding used for the args. By default we assume
 * 'local' encoding. For windows this equates to whatever the current
 * codepage is. For linux this is utf8.
 *
 * Use of this API (gsapi) with 'local' encodings (and hence without calling
 * this function) is now deprecated!
 *)
 TGSArgEncoding = (GS_ARG_ENCODING_LOCAL = 0, GS_ARG_ENCODING_UTF8 = 1, GS_ARG_ENCODING_UTF16LE = 2);
 TGSAPI_set_arg_encoding = function (instance: Pointer; encoding: TGSArgEncoding): Integer; stdcall;


(* Initialise the interpreter.
 * This calls gs_main_init_with_args() in imainarg.c
 * 1. If quit or EOF occur during gsapi_init_with_args(),
 *    the return value will be e_Quit.  This is not an error.
 *    You must call gsapi_exit() and must not call any other
 *    gsapi_XXX functions.
 * 2. If usage info should be displayed, the return value will be e_Info
 *    which is not an error.  Do not call gsapi_exit().
 * 3. Under normal conditions this returns 0.  You would then
 *    call one or more gsapi_run_*() functions and then finish
 *    with gsapi_exit().
 *)
 TGSAPI_Init_With_Args = function(instance: Pointer; argc: Integer; argv: PPAnsiChar): Integer; stdcall;

(* Exit the interpreter.
 * This must be called on shutdown if gsapi_init_with_args()
 * has been called, and just before gsapi_delete_instance().
 *)
 TGSAPI_Exit = function (instance: Pointer): Integer; stdcall;



 var
   GSAPI_Revision: TGSAPI_Revision = nil;
   GSAPI_New_Instance: TGSAPI_New_Instance = nil;
   GSAPI_Delete_Instance: TGSAPI_Delete_Instance = nil;
   GSAPI_Set_Arg_Encoding: TGSAPI_Set_Arg_Encoding = nil;
   GSAPI_Init_With_Args: TGSAPI_Init_With_Args = nil;
   GSAPI_Exit: TGSAPI_Exit = nil;

   function LoadGSDLL: Boolean;
   function IsGSDLLLoaded: Boolean;

implementation

const
  GSDLLNAME = 'gsdll32.dll';

var
  hGS: HMODULE = 0;

function LoadGSDLL: Boolean;
begin
  if not IsGSDLLLoaded
  then begin
         hGS := LoadLibrary(GSDLLNAME);
         if IsGSDLLLoaded
         then begin
                @GSAPI_Revision := GetProcAddress(hGS, 'gsapi_revision');
                @GSAPI_New_Instance := GetProcAddress(hGS, 'gsapi_new_instance');
                @GSAPI_Delete_Instance := GetProcAddress(hGS, 'gsapi_delete_instance');
                @GSAPI_Set_Arg_Encoding := GetProcAddress(hGS, 'gsapi_set_arg_encoding');
                @GSAPI_Init_With_Args := GetProcAddress(hGS, 'gsapi_init_with_args');
                @GSAPI_Exit := GetProcAddress(hGS, 'gsapi_exit');
                Result := True;
              end
         else Result := False;
       end
  else Result := True;
end;

procedure UnLoadGSDLL;
begin
  if FreeLibrary(hGS)
  then begin
         hGS := 0;
         GSAPI_Revision := nil;
         GSAPI_New_Instance := nil;
         GSAPI_Delete_Instance := nil;
         GSAPI_Set_Arg_Encoding := nil;
         GSAPI_Init_With_Args := nil;
         GSAPI_Exit := nil;
       end;
end;

function IsGSDLLLoaded: Boolean;
begin
  Result := hGS <> 0;
end;

end.
