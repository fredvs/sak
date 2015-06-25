unit sak_dll_fpg;

{*******************************************************************************
*                         Speech Assistive Kit ( sak )                         *
*                  --------------------------------------                      *
*                                                                              *
*          Assistive Procedures using eSpeak and Portaudio libraries           *
*                                                                              *
*                                                                              *
*                 Fred van Stappen /  fiens@hotmail.com                        *
*                                                                              *
*                                                                              *
********************************************************************************
*  4 th release: 2015-03-13  (sak_dll synchronized with sak)                   *
*  3 th release: 2015-03-09  (mouse focus)                                     *
*  2 th release: 2013-08-01  (use espeak.exe)                                  *
*  1 th release: 2013-06-15  (multi objects, multi forms)                      *
*                                                                              *
********************************************************************************}
    {
    Copyright (C) 2013  Fred van Stappen

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor,
    Boston, MA  02110-1301  USA
    }

interface

uses
  {$IF DEFINED(windows)}
  dynlibs,
  {$endif}

  fpg_base,
  fpg_main,
  fpg_label,
  fpg_grid,
  fpg_button,
  fpg_CheckBox,
  fpg_RadioButton,
  fpg_Menu,
  fpg_ComboBox,
  fpg_ListBox,
  fpg_TrackBar,
  fpg_memo,
  fpg_edit,
  fpg_Widget,
  fpg_form,
  fpg_dialogs,
   {$IF not DEFINED(Windows)}
    baseunix  ,
       {$endif}  
  Classes, Math, SysUtils, uos_PortAudio, uos_eSpeak;

const
  male = 1;
  female = 2;

type
  TSAK_VoiceConfig = record
    voice: espeak_VOICE;
    Parameter: espeak_PARAMETER;
  end;

type

  TProc = procedure of object;
  TOnEnter = procedure(Sender: TObject) of object;
  TOnClick = procedure(Sender: TObject) of object;
  TOnChange = procedure(Sender: TObject) of object;
  TOnDestroy = procedure(Sender: TObject) of object;
  TOnKeyChar = procedure(Sender: TObject; Key: TfpgChar; var ifok: boolean) of object;
  TOnKeyPress = procedure(Sender: TObject; var Key: word; var Shift: TShiftState; var ifok: boolean) of object;
  TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const Pointm: TPoint) of object;
  TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const Pointm: TPoint) of object;
  TOnMouseMove = procedure(Sender: TObject; Shift: TShiftState; const thePoint: TPoint) of object;

  TOnFocusChange = procedure(Sender: TObject; col: longint; row: longint) of object;
  TOnTrackbarChange = procedure(Sender: TObject; position: longint) of object;

type
  TSAK_Assistive = class(TObject)
  private
    TheObject: TObject;
    OriOnKeyPress: TOnKeyPress;
    OriOnClick: TOnClick;
    OriOnEnter: TOnEnter;
    OriOnMouseDown: TOnMouseDown;
    OriOnMouseUp: TOnMouseUp;
    oriOnMouseMove: TOnMouseMove;
    OriOnChange: TOnChange;
    OriOnDestroy: TOnDestroy;
    OriOnKeyChar: TOnKeyChar;
    OriOnFocusChange: TOnFocusChange;
    OriOnTrackbarChange: TOnTrackbarChange;
  public
    Description: ansistring;
    Soundfile: ansistring;
  end;

type
  TSAK_Init = class(TObject)
  public
    PA_FileName: ansistring;
    ES_FileName: ansistring;
    ES_DataDirectory: ansistring;
    isloaded: boolean;
    isworking: boolean;
    CompCount: integer;
    CheckObject: TObject;
    CheckKey: word;
    CheckPoint: Tpoint;
    CheckShift: TShiftState;
    AssistiveData: array of TSAK_Assistive;
    CheckKeyChar: TfpgChar;
    CheckCol, CheckRow, CheckPos: longint;
    TimerCount: TfpgTimer;
    TimerRepeat: TfpgTimer;

    procedure SAKEnter(Sender: TObject);
    procedure SAKChange(Sender: TObject);
    procedure SAKClick(Sender: TObject);
    procedure SAKDestroy(Sender: TObject);

    procedure CheckCount(Sender: TObject);
    procedure CheckRepeatEnter(Sender: TObject);
    procedure CheckRepeatChange(Sender: TObject);
    procedure CheckRepeatKeyPress(Sender: TObject);
    procedure CheckRepeatClick(Sender: TObject);
    procedure CheckRepeatMouseMove(Sender: TObject);
    procedure CheckRepeatKeyChar(Sender: TObject);
    procedure CheckFocusChange(Sender: TObject);
    procedure SAKKeyChar(Sender: TObject; Key: TfpgChar; var ifok: boolean);
    procedure SAKKeyPress(Sender: TObject; var Key: word; var Shift: TShiftState; var ifok: boolean);
    procedure SAKMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const pointm: Tpoint);
    procedure SAKMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const pointm: Tpoint);
    procedure SAKMouseMove(Sender: TObject; Shift: TShiftState; const thePoint: TPoint);
    procedure SAKFocusChange(Sender: TObject; col: longint; row: longint);
    procedure CheckTrackbarChange(Sender: TObject);
    procedure SAKTrackbarChange(Sender: TObject; pos: longint);

  private
    function LoadLib: integer;
    function unLoadLib: integer;
    procedure InitObject;
  end;

//// Load with default
function SAKLoadlib: integer;

/// Load with custom
function SAKLoadLib(PortaudioLib: string; eSpeakLib: string; eSpeakDataDir: string): integer;

function SAKUnloadLib: integer;

function SAKFreeLib: integer;

function SakIsEnabled: boolean;

////// Change voice language or/and gender
function SAKSetVoice(gender: shortint; language: string): integer;
//// gender : 1 = male, 2 = female.
//// language : is the language code, for example :
//// 'en' for english, 'fr' for french, 'pt' for Portugues, etc...
//// (check in /espeak-data if your language is there...)

///// Start speaking the text with default voice
function SAKSay(Text: string): integer;

///// Start speaking the text with custom voice
function SAKSay(Text: string; VoiceParam: TSAK_VoiceConfig): integer;

///// Start speaking the character with default voice
function SAKSay(char: word): integer;

//// Start speaking with custom voice
function SAKSay(char: word; VoiceParam: TSAK_VoiceConfig): integer;

/// stop speaking;
function SAKStop: integer;

function WhatName(Sender: TObject): string;

var
  old8087cw: word;
  DefVoice, CustomVoice: TSAK_VoiceConfig;
  isenabled : boolean = false;
  lastfocused: string = '';
  InitSpeech: TSAK_Init;
  mouseclicked: boolean;
   {$IF DEFINED(windows)}
  VS_Handle: TLibHandle = dynlibs.NilHandle;
  {$endif}


implementation

{$IFDEF FREEBSD}
// These are missing for FreeBSD in FPC's RTL
const
    S_IRWXU =  S_IRUSR or S_IWUSR or S_IXUSR;
    S_IRWXG =  S_IRGRP or S_IWGRP or S_IXGRP;
    S_IRWXO =  S_IROTH or S_IWOTH or S_IXOTH;
{$ENDIF}

/////////////////////////// Capture Assistive Procedures


function WhatName(Sender: TObject): string;
begin
  if (Sender is TfpgLabel) then
    Result := TfpgLabel(Sender).Text
  else
  if (Sender is TfpgButton) then
  begin
    if (trim(Tfpgbutton(Sender).Text) <> '') then
      Result := Tfpgbutton(Sender).Text
    else
    if (trim(Tfpgbutton(Sender).Name) <> '') then
      Result := Tfpgbutton(Sender).Name
    else
      Result := Tfpgbutton(Sender).hint;
  end
  else
  if (Sender is TfpgForm) then
    Result := TfpgForm(Sender).WindowTitle
  else
   if (Sender is TfpgEdit) then
    Result := TfpgEdit(Sender).Name
  else
  if (Sender is TfpgMemo) then
    Result := TfpgMemo(Sender).Name
  else
  if (Sender is TfpgStringgrid) then
    Result := TfpgStringgrid(Sender).Name
  else
  if (Sender is TfpgRadiobutton) then
    Result := TfpgRadiobutton(Sender).Text
  else
  if (Sender is TfpgCheckBox) then
    Result := TfpgCheckBox(Sender).Text
  else
  if (Sender is TfpgListBox) then
    Result := TfpgListBox(Sender).Text
  else
  if (Sender is TfpgFileDialog) then
    Result := TfpgFileDialog(Sender).WindowTitle
  else
  if (Sender is TfpgMenuBar) then
    Result := TfpgMenuBar(Sender).Name
  else
  if (Sender is TfpgPopupMenu) then
    Result := TfpgPopupMenu(Sender).Name
  else
  if (Sender is TfpgMenuItem) then
    Result := TfpgMenuItem(Sender).Text
  else
  if (Sender is TfpgTrackBar) then
    Result := TfpgTrackBar(Sender).Name
  else
  if (Sender is TfpgComboBox) then
    Result := TfpgComboBox(Sender).Name;
end;

procedure TSAK_Init.SAKDestroy(Sender: TObject);
var
  i: integer;
begin
  isworking := False;
  timercount.Enabled := False;

  unLoadLib;
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and (InitSpeech.AssistiveData[i].OriOnDestroy <> nil) then
    begin
      InitSpeech.AssistiveData[i].OriOnDestroy(Sender);
      exit;
    end;
  end;

  isworking := True;
  timercount.Enabled := True;
end;

procedure TSAK_Init.SAKClick(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnClick <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnClick(Sender);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckRepeatClick;
  TimerRepeat.Interval := 500;
  TimerRepeat.Enabled := True;
  CheckObject := Sender;
end;

procedure TSAK_Init.CheckRepeatClick(Sender: TObject);
var
  texttmp, nameobj: string;
  i: integer;
begin
    TimerRepeat.Enabled := false;
//if InitSpeech.isWorking = true then
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
    begin
      espeak_cancel;

      mouseclicked := True;

      nameobj := whatname(CheckObject);

      texttmp := InitSpeech.AssistiveData[i].Description + ' ' + nameobj + ' executed';

      espeak_Key(pchar(texttmp));
          exit;
    end;
  end;
end;

procedure TSAK_Init.SAKChange(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnChange <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnChange(Sender);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckRepeatChange;
  TimerRepeat.Interval := 500;
  TimerRepeat.Enabled := True;
  CheckObject := Sender;
end;

procedure TSAK_Init.CheckRepeatChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
    begin
      espeak_cancel;
      if (CheckObject is TfpgTrackBar) then
        with CheckObject as TfpgTrackBar do
          texttmp := Name + ' position is, ' + IntToStr(position);

      if (CheckObject is TfpgComboBox) then
        with CheckObject as TfpgComboBox do
          texttmp := Text + ' selected';

      if (CheckObject is TfpgListBox) then
        with CheckObject as TfpgListBox do
          texttmp := Text + ' selected';

      if (CheckObject is TfpgCheckBox) then
        with CheckObject as TfpgCheckBox do

          if Checked = False then
            texttmp := 'Change  ' + Text + ', in false'
          else
            texttmp :=
              'Change  ' + Text + ', in true';

      if (CheckObject is TfpgRadioButton) then
        with CheckObject as TfpgRadioButton do
          begin
          if Checked = False then
            texttmp := 'Change  ' + Text + ', in false'
          else
            texttmp :=
              'Change  ' + Text + ', in true';

          texttmp := text ;

          end;

      espeak_Key(pointer(texttmp));

      exit;
    end;
  end;
end;

procedure TSAK_Init.SAKTrackbarChange(Sender: TObject; pos: longint);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnTrackBarChange <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnTrackBarChange(Sender, pos);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.Interval := 300;
  TimerRepeat.OnTimer := @CheckTrackbarChange;
  TimerRepeat.Enabled := True;
  CheckObject := Sender;
  CheckPos := pos;
end;

procedure TSAK_Init.CheckTrackbarChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) and (CheckObject is TfpgTrackBar) then
    begin
      //  espeak_cancel ;
      with CheckObject as TfpgTrackBar do
      begin
        texttmp := Name + ' position is, ' + IntToStr(position);
        espeak_Key(PChar(texttmp));

        exit;
      end;
    end;
  end;
end;

procedure TSAK_Init.SAKFocusChange(Sender: TObject; col: longint; row: longint);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnFocusChange <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnFocusChange(Sender, col, row);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckFocusChange;
  CheckObject := Sender;
  CheckCol := col;
  CheckRow := row;
  TimerRepeat.Enabled := True;
end;

procedure TSAK_Init.CheckFocusChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to high(InitSpeech.AssistiveData) do

    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) and (CheckObject is tfpgstringgrid) then
    begin
      espeak_cancel;
      with CheckObject as tfpgstringgrid do
      begin
        texttmp := ColumnTitle[focuscol] + ', row ' + IntToStr(focusrow + 1) + '. ' + Cells[focuscol, focusrow];
        espeak_Key(PChar(texttmp));
      end;
      exit;
    end;
end;

procedure TSAK_Init.SAKMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const pointm: Tpoint);
begin
end;

procedure TSAK_Init.SAKMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const pointm: Tpoint);
begin
end;

procedure TSAK_Init.SAKMouseMove(Sender: TObject; Shift: TShiftState; const thePoint: TPoint);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnMouseMove <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnMouseMove(Sender, Shift, thePoint);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckRepeatMouseMove;
  TimerRepeat.Interval := 600;
  CheckObject := Sender;
  CheckPoint := thePoint;
  CheckShift := Shift;
  TimerRepeat.Enabled := True;
end;

procedure TSAK_Init.CheckRepeatMouseMove(Sender: TObject);
var
  texttmp,  stringtemp, nameobj: string;
  i: integer;
begin
  if (mouseclicked = False) and (whatname(CheckObject) <> lastfocused) then
  begin
    TimerRepeat.Enabled := False;
    for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
    begin
      if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
      begin
        espeak_cancel;
        if CheckObject is TfpgForm then
        begin
          lastfocused := ' ';
      //    texttmp := 'Left,  ' + IntToStr(CheckPoint.X) + ' , of,  ' + IntToStr(TfpgForm(CheckObject).Width) +
      //      '.   Top,  ' + IntToStr(CheckPoint.y) + ' , of, ' + IntToStr(TfpgForm(CheckObject).Height);
       //   espeak_Key(PChar(texttmp));
        end
        else
        begin
          nameobj := whatname(CheckObject);
          lastfocused := nameobj;
            stringtemp := '' ;

        if  (CheckObject is tfpgcheckbox) then
        begin
          if tfpgcheckbox(CheckObject).Checked = false then stringtemp := ' , false, ' else stringtemp := ' , true, ';
        end;

         if  (CheckObject is tfpgradiobutton) then
        begin
          if tfpgradiobutton(CheckObject).Checked = false then stringtemp := ' , false, ' else stringtemp := ' , true, ';
        end;

         if  (CheckObject is tfpgtrackbar) then
        begin
        stringtemp := ' , ' + inttostr(tfpgtrackbar(CheckObject).Position) + ' , ' ;
        end;

        texttmp := InitSpeech.AssistiveData[i].Description + ' ' + nameobj + stringtemp + ' ,focused';

          espeak_Key(PChar(texttmp));
        end;
        exit;
      end;
    end;
  end;
end;

procedure TSAK_Init.SAKEnter(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnEnter <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnEnter(Sender);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckRepeatEnter;
  TimerRepeat.Interval := 600;
  TimerRepeat.Enabled := False;
  TimerRepeat.Enabled := True;
  CheckObject := Sender;
end;

procedure TSAK_Init.CheckRepeatEnter(Sender: TObject);
var
  texttmp, nameobj: string;
  i: integer;
begin
  if mouseclicked = False then
  begin
    TimerRepeat.Enabled := False;
    for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
    begin
      if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
      begin
        espeak_cancel;
        nameobj := whatname(CheckObject);
        texttmp := InitSpeech.AssistiveData[i].Description + ' ' + nameobj + ' selected';
        espeak_Key(PChar(texttmp));
       exit;
      end;
    end;
  end;
  mouseclicked := False;
end;

procedure TSAK_Init.SAKKeyPress(Sender: TObject; var Key: word; var Shift: TShiftState; var ifok: boolean);
var
  i: integer = 0;
 finded: boolean = False;
begin

   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnKeyPress <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnKeyPress(Sender, key, shift, ifok);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckRepeatKeyPress;
  TimerRepeat.Interval := 300;
  CheckObject := Sender;
  CheckKey := key;
  CheckShift := Shift;
  TimerRepeat.Enabled := True;
end;

procedure TSAK_Init.CheckRepeatKeyPress(Sender: TObject);
var
  i: integer;
  ifok: boolean = true;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to high(InitSpeech.AssistiveData) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
    begin
      espeak_cancel;
      if (CheckKey = 57611) and ((CheckObject is TfpgMemo) or (CheckObject is TfpgEdit)) then
        espeak_Cancel
      else
      begin
        case CheckKey of

          keyPEnter: espeak_Key('enter');
          8: espeak_Key('back space');
          32: if (CheckObject is TfpgCheckBox) or (CheckObject is TfpgRadioButton) or (CheckObject is TfpgComboBox) or
              (CheckObject is TfpgListBox) then
            else
              espeak_Key('space');

          57394:
          begin
            espeak_Key('up');
            if (CheckObject is TfpgTrackBar) then
              with CheckObject as TfpgTrackBar do
                if Position + ScrollStep <= max then
                  Position := Position + ScrollStep;
          end;
          57395:
          begin
            espeak_Key('down');
            if (CheckObject is TfpgTrackBar) then
              with CheckObject as TfpgTrackBar do
                if Position - ScrollStep >= min then
                  Position := Position - ScrollStep;
          end;

          57396:
          begin
            espeak_Key('left');
            if (CheckObject is TfpgTrackBar) then
              with CheckObject as TfpgTrackBar do
                if Position - ScrollStep >= min then
                  Position := Position - ScrollStep;
          end;

          57397:
          begin
            espeak_Key('right');
            if (CheckObject is TfpgTrackBar) then
              with CheckObject as TfpgTrackBar do
                if Position + ScrollStep <= max then
                  Position := Position + ScrollStep;
          end;
          57601: espeak_Key('f, 1');
          57602: espeak_Key('f, 2');
          57603: espeak_Key('f, 3');
          57604: espeak_Key('f, 4');
          57605: espeak_Key('f, 5');
          57606: espeak_Key('f, 6');
          57607: espeak_Key('f, 7');
          57608: espeak_Key('f, 8');
          57609: espeak_Key('f, 9');
          57610: espeak_Key('f, 10');
          57611: espeak_Key('f, 11');
          keyPTab: espeak_Key('tab');
          58112: espeak_Key('shift, left');
          58176: espeak_Key('shift, right');
          58113: espeak_Key('control, right');
          58177: espeak_Key('control, left');
          18: espeak_Key('alt');
          58247: espeak_Key('caps, lock');
          65535: espeak_Key('alt, gr');
          33: espeak_Key('page, up');
          34: espeak_Key('page, down');
          46: espeak_Key('delete');
          57378: espeak_Key('insert');
          27: espeak_Key('escape');
          35: espeak_Key('end');

          57612: if (CheckObject is TfpgMemo) then
              with CheckObject as TfpgMemo do
             espeak_Key(PChar(text))
            else
            if (CheckObject is Tfpgedit) then
              with CheckObject as Tfpgedit do
              espeak_Key(PChar(text))
            else
              espeak_Key('f, 12');

        end;
           exit;
      end;
    end;
  end;
end;

procedure TSAK_Init.SAKKeyChar(Sender: TObject; Key: TfpgChar; var ifok: boolean);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnKeyChar <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnKeyChar(Sender, key, ifok);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckRepeatKeyChar;
  TimerRepeat.Enabled := False;
  TimerRepeat.Interval := 300;
  CheckObject := Sender;
  CheckKeyChar := key;
  TimerRepeat.Enabled := True;
end;

procedure TSAK_Init.CheckRepeatKeyChar(Sender: TObject);
var
  tempstr: string;
  i: integer;
  ifok: boolean;
begin
  ifok := True;
  TimerRepeat.Enabled := False;
  tempstr := CheckKeyChar;
  tempstr := trim(tempstr);
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
    begin
      espeak_cancel;
      tempstr := CheckKeyChar;
      tempstr := trim(tempstr);
      if tempstr <> '' then
        espeak_Key(pchar(tempstr));
       exit;
    end;
  end;
end;

////////////////////// Loading Procedure

function SAKLoadLib(PortaudioLib: string; eSpeakLib: string; eSpeakDataDir: string): integer;
begin
  Result := -1;

  if assigned(InitSpeech) then

    initspeech.isloaded := True
  else
  begin
    InitSpeech := TSAK_Init.Create;
    initspeech.isWorking := True;
    initspeech.isloaded := False;
    if directoryexists(eSpeakDataDir) then
    begin
      Result := 0;
      initspeech.ES_DataDirectory := eSpeakDataDir;
    end;
    if (Result = 0) and (fileexists(PortaudioLib)) then
    begin
      Result := 0;
      initspeech.PA_FileName := PortaudioLib;
    end;

    if (Result = 0) and (fileexists(eSpeakLib)) then
    begin
      Result := 0;
      initspeech.ES_FileName := eSpeakLib;
    end;
  end;
  if (Result = 0) or (initspeech.isloaded = True) then
  begin
    initspeech.isworking := True;
    Result := InitSpeech.loadlib;
  end;
end;

function SAKLoadLib: integer;
var
  ordir: string;
begin
  Result := -1;
  if assigned(InitSpeech) then
  begin

    initspeech.isloaded := True;
  end
  else
  begin
    InitSpeech := TSAK_Init.Create;
    initspeech.isloaded := False;
    ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
   {$ifdef windows}
    InitSpeech.ES_DataDirectory := ordir + '\sakit_dll';
     {$else}
    InitSpeech.ES_DataDirectory := ordir + '/sakit_dll';
       {$endif}

   {$ifdef windows}
    Result := -1;

    if fileexists(ordir + 'msvcr110.dll') then
    begin
      VS_Handle := DynLibs.LoadLibrary(ordir + 'msvcr110.dll');
      if VS_Handle <> DynLibs.NilHandle then
        Result := 0;
    end
    else
    if fileexists(ordir + '\sakit_dll\libwin32\msvcr110.dll') then
    begin
      VS_Handle := DynLibs.LoadLibrary(ordir + '\sakit_dll\libwin32\msvcr110.dll');
      if VS_Handle <> DynLibs.NilHandle then
        Result := 0;
    end;

    if Result = 0 then
    begin
      if fileexists(ordir + 'portaudio_x86.dll') then
      begin
        Result := 0;
        initspeech.PA_FileName := ordir + 'portaudio_x86.dll';
      end
      else
      if fileexists(ordir + '\sakit_dll\libwin32\portaudio_x86.dll') then
      begin
        initspeech.PA_FileName := ordir + '\sakit_dll\libwin32\portaudio_x86.dll';
        Result := 0;
      end;

      if Result = 0 then
      begin
        Result := -1;
        if fileexists(ordir + 'espeak_x86.dll') then
        begin
          Result := 0;
          initspeech.ES_FileName := ordir + 'espeak_x86.dll';
        end
        else
        if fileexists(ordir + '\sakit_dll\libwin32\espeak_x86.dll') then
        begin
          initspeech.ES_FileName := ordir + '\sakit_dll\libwin32\espeak_x86.dll';
          Result := 0;
        end;
      end;
    end;
         {$endif}
         {$IF DEFINED(Linux) and  defined(cpu64)}
    if fileexists(ordir + 'libportaudio_x64.so') then
    begin
      Result := 0;
      initspeech.PA_FileName := ordir + 'libportaudio_x64.so';
    end
    else
    if fileexists(ordir + '/sakit_dll/liblinux64/libportaudio_x64.so') then
    begin
      initspeech.PA_FileName := ordir + '/sakit_dll/liblinux64/libportaudio_x64.so';
      Result := 0;
    end;

    if Result = 0 then
    begin
      Result := -1;
      if fileexists(ordir + 'libespeak_x64.so') then
      begin
        Result := 0;
        initspeech.ES_FileName := ordir + 'libespeak_x64.so';
      end
      else
      if fileexists(ordir + '/sakit_dll/liblinux64/libespeak_x64.so') then
      begin
        initspeech.ES_FileName := ordir + '/sakit_dll/liblinux64/libespeak_x64.so';
        Result := 0;
      end;
    end;
     {$endif}
      {$IF DEFINED(Linux) and defined(cpu86) }
    if fileexists(ordir + 'libportaudio_x86.so') then
    begin
      Result := 0;
      initspeech.PA_FileName := ordir + 'libportaudio_x86.so';
    end
    else
    if fileexists(ordir + '/sakit_dll/liblinux32/libportaudio_x86.so') then
    begin
      initspeech.PA_FileName := ordir + '/sakit_dll/liblinux32/libportaudio_x86.so';
      Result := 0;
    end;
    if Result = 0 then
    begin
      Result := -1;
      if fileexists(ordir + 'libespeak_x86.so') then
      begin
        Result := 0;
        initspeech.ES_FileName := ordir + 'libespeak_x86.so';
      end
      else
      if fileexists(ordir + '/sakit_dll/liblinux32/libespeak_x86.so') then
      begin
        initspeech.ES_FileName := ordir + '/sakit_dll/liblinux32/libespeak_x86.so';
        Result := 0;
      end;
    end;

   {$endif}
         {$IF DEFINED(freebsd) and  defined(cpu64)}
    if fileexists(ordir + 'libportaudio_x64.so') then
    begin
      Result := 0;
      initspeech.PA_FileName := ordir + 'libportaudio_x64.so';
    end
    else
    if fileexists(ordir + '/sakit_dll/libfreebsd64/libportaudio_x64.so') then
    begin
      initspeech.PA_FileName := ordir + '/sakit_dll/libfreebsd64/libportaudio_x64.so';
      Result := 0;
    end;

    if Result = 0 then
    begin
      Result := -1;
      if fileexists(ordir + 'libespeak_x64.so') then
      begin
        Result := 0;
        initspeech.ES_FileName := ordir + 'libespeak_x64.so';
      end
      else
      if fileexists(ordir + '/sakit_dll/libfreebsd64/libespeak_x64.so') then
      begin
        initspeech.ES_FileName := ordir + '/sakit_dll/libfreebsd64/libespeak_x64.so';
        Result := 0;
      end;
    end;
                {$endif}

  end;

  if (Result = 0) or (initspeech.isloaded = True) then
  begin
    initspeech.isworking := True;
    Result := InitSpeech.loadlib;
  end;

end;

procedure TSAK_Init.InitObject;
var
  i, j, f, g: integer;
begin
  mouseclicked := False;
  SetLength(InitSpeech.AssistiveData, 0);

  SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);
  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
    TSAK_Assistive.Create();

  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
    'Application';

  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
    Tfpgapplication(fpgapplication);

  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyPress :=
    Tfpgapplication(fpgapplication).OnKeyPress;

  Tfpgapplication(fpgapplication).OnKeyPress := @InitSpeech.SAKKeyPress;


  for f := 0 to fpgapplication.formCount - 1 do  /// fpgui
  begin
    SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
      TSAK_Assistive.Create();

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
      'Form';

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
      TfpgForm(fpgapplication.Forms[f]);

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyPress :=
      TfpgForm(fpgapplication.Forms[f]).OnKeyPress;

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnDestroy :=
      TfpgForm(fpgapplication.Forms[f]).OnDestroy;

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
      TfpgForm(fpgapplication.Forms[f]).OnMouseDown;

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
      TfpgForm(fpgapplication.Forms[f]).OnMouseMove;

    TfpgForm(fpgapplication.Forms[f]).OnMouseMove := @InitSpeech.SAKMouseMove;
    TfpgForm(fpgapplication.Forms[f]).OnMouseDown := @InitSpeech.SAKMouseDown;
    TfpgForm(fpgapplication.Forms[f]).OnKeyPress := @InitSpeech.SAKKeyPress;
    TfpgForm(fpgapplication.Forms[f]).OnDestroy := @InitSpeech.SAKDestroy;

    with (fpgapplication.Forms[f]) as TfpgForm do

      for i := 0 to ComponentCount - 1 do
      begin
        if (Components[i] is TfpgWidget) or (Components[i] is TfpgButton) or (Components[i] is TfpgMemo) or (Components[i] is TfpgEdit) or
          (Components[i] is TfpgStringGrid) or (Components[i] is TfpgCheckBox) or (Components[i] is TfpgRadiobutton) or
          (Components[i] is TfpgListBox) or (Components[i] is TfpgComboBox) or (Components[i] is TfpgPopupMenu) or
          (Components[i] is TfpgMenuItem) or (Components[i] is TfpgTrackBar) or (Components[i] is TfpgLabel)
        // or (Components[i] is TfpgFileDialog) or (Components[i] is TfpgSaveDialog)
        then
        begin
         
          if (Components[i] is TfpgPopupMenu) then
          begin
           SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Menu';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgPopupMenu(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
              TfpgPopupMenu(Components[i]).OnShow;
            TfpgPopupMenu(Components[i]).OnShow := @InitSpeech.SAKClick;
            with (TfpgPopupMenu(Components[i]) as TfpgPopupMenu) do
              for g := 0 to ComponentCount - 1 do
              begin
                SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);
                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
                  TSAK_Assistive.Create();
                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
                  TfpgMenuItem(Components[g]);
                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
                  TfpgMenuItem(Components[g]).OnClick;
                TfpgMenuItem(Components[g]).OnClick := @InitSpeech.SAKClick;

                //      InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
                //  TfpgMenuItem(Components[g]).OnEnter;
                //  TfpgMenuItem(Components[g]).OnEnter := @InitSpeech.SAKEnter;

              end;
          end
          else
          if (Components[i] is TfpgLabel) then
          begin
           SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Label,';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgLabel(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
              TfpgLabel(Components[i]).OnClick;
            TfpgLabel(Components[i]).OnClick := @InitSpeech.SAKClick;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgLabel(Components[i]).OnMouseMove;
            TfpgLabel(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
          end
          else
          if (Components[i] is TfpgButton) then
          begin
           SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Button';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgButton(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
              TfpgButton(Components[i]).OnClick;
            TfpgButton(Components[i]).OnClick := @InitSpeech.SAKClick;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgButton(Components[i]).OnEnter;
            TfpgButton(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgButton(Components[i]).OnMouseMove;
            TfpgButton(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;

          end
          else
          if (Components[i] is TfpgStringGrid) then
          begin
           SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Grid';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgStringGrid(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnFocusChange :=
              TfpgStringGrid(Components[i]).OnFocusChange;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
              TfpgStringGrid(Components[i]).OnMouseDown;
            TfpgStringGrid(Components[i]).OnFocusChange := @InitSpeech.SAKFocusChange;
            TfpgStringGrid(Components[i]).OnMouseDown := @InitSpeech.SAKMouseDown;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgStringGrid(Components[i]).OnEnter;
            TfpgStringGrid(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgStringGrid(Components[i]).OnMouseMove;
            TfpgStringGrid(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
          end
          else
          if (Components[i] is TfpgTrackBar) then
          begin
            SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Track bar';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgTrackBar(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnTrackbarChange :=
              TfpgTrackBar(Components[i]).OnChange;

            TfpgTrackBar(Components[i]).OnChange := @InitSpeech.SAKTrackBarChange;

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgTrackBar(Components[i]).OnEnter;

            TfpgTrackBar(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgTrackBar(Components[i]).OnMouseMove;
            TfpgTrackBar(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
          end
          else
          if (Components[i] is TfpgRadiobutton) then
          begin
           SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Radio Button';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgRadiobutton(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
              TfpgRadiobutton(Components[i]).OnChange;

            TfpgRadiobutton(Components[i]).OnChange := @InitSpeech.SAKChange;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgRadiobutton(Components[i]).OnEnter;

            TfpgRadiobutton(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgRadiobutton(Components[i]).OnMouseMove;
            TfpgRadiobutton(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
          end
          else

          if (Components[i] is TfpgCheckBox) then
          begin
            SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Check Box';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgCheckBox(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
              TfpgCheckBox(Components[i]).OnChange;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgCheckBox(Components[i]).OnEnter;

            TfpgCheckBox(Components[i]).OnChange := @InitSpeech.SAKChange;
            TfpgCheckBox(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgCheckBox(Components[i]).OnMouseMove;
            TfpgCheckBox(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
          end
          else
          if (Components[i] is TfpgListBox) then
          begin
           SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'List Box';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgListBox(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
              TfpgListBox(Components[i]).OnChange;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgListBox(Components[i]).OnEnter;

            TfpgListBox(Components[i]).OnChange := @InitSpeech.SAKChange;
            TfpgListBox(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgListBox(Components[i]).OnMouseMove;
            TfpgListBox(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
          end
          else
          if (Components[i] is TfpgComboBox) then
          begin
           SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Combo Box';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgComboBox(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
              TfpgComboBox(Components[i]).OnChange;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgComboBox(Components[i]).OnEnter;
            TfpgComboBox(Components[i]).OnChange := @InitSpeech.SAKChange;
            TfpgComboBox(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgComboBox(Components[i]).OnMouseMove;
            TfpgComboBox(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
          end
          else
          if (Components[i] is TfpgMemo) then
          begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Memo';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgMemo(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgMemo(Components[i]).OnEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyChar :=
              TfpgMemo(Components[i]).OnKeyChar;

            TfpgMemo(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            TfpgMemo(Components[i]).OnKeyChar := @InitSpeech.SAKKeyChar;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgMemo(Components[i]).OnMouseMove;
            TfpgMemo(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
          end
          else
          if (Components[i] is TfpgEdit) then
          begin
             SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Edit';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgEdit(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgEdit(Components[i]).OnEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyChar :=
              TfpgEdit(Components[i]).OnKeyChar;
            TfpgEdit(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            TfpgEdit(Components[i]).OnKeyChar := @InitSpeech.SAKKeyChar;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgEdit(Components[i]).OnMouseMove;
            TfpgEdit(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
          end else
          if (Components[i] is TfpgWidget) then
          begin
            {
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Panel,';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgPanel(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
              TfpgPanel(Components[i]).OnClick;
            TfpgPanel(Components[i]).OnClick := @InitSpeech.SAKClick;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
              TfpgPanel(Components[i]).OnMouseMove;
            TfpgPanel(Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
             }

            with Components[i] as TfpgWidget do

              for j := 0 to ComponentCount - 1 do
              begin
                if (Components[j] is TfpgButton) then
                begin
                  SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
                    TSAK_Assistive.Create();

                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
                    'Button,';
                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
                    TfpgButton(Components[j]);
                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
                    TfpgButton(Components[j]).OnClick;
                  TfpgButton(Components[j]).OnClick := @InitSpeech.SAKClick;
                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
                    TfpgButton(Components[j]).OnEnter;
                  TfpgButton(Components[j]).OnEnter := @InitSpeech.SAKEnter;

                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgButton(Components[j]).OnMouseMove;
                  TfpgButton(Components[j]).OnMouseMove := @InitSpeech.SAKMouseMove;
                end;

                if (Components[j] is TfpgLabel) then
                begin
                  SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
                    TSAK_Assistive.Create();

                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
                    'Label,';
                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
                    TfpgLabel(Components[j]);
                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
                    TfpgLabel(Components[j]).OnClick;
                  TfpgLabel(Components[j]).OnClick := @InitSpeech.SAKClick;
                  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgLabel(Components[j]).OnMouseMove;
                  TfpgLabel(Components[j]).OnMouseMove := @InitSpeech.SAKMouseMove;
                end;
              end;

          end;

        end;
      end;
  end;

end;


procedure TSAK_Init.CheckCount(Sender: TObject);
begin
  timercount.Enabled := False;
  if (isWorking = True) then
  begin
    if fpgapplication.ComponentCount <> CompCount then
    begin
      UnLoadLib;
      InitObject;
      CompCount := fpgapplication.ComponentCount;
    end;
    timercount.Enabled := True;
  end;
end;

///////////////// loading sak

function TSAK_Init.LoadLib: integer;
begin
  Result := -1;
  old8087cw := Get8087CW;
  isenabled := false ;
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
  Set8087CW($133f);
  if initspeech.isloaded = True then
    Result := 0
  else
  begin
    if not fileexists(PA_FileName) then
      Result := -2
    else
    if Pa_Load(PA_FileName) then
    begin
      Result := 0;
      Pa_Initialize();
    end
    else
      Result := -21;
    if Result = 0 then
    begin
      if not fileexists(ES_FileName) then
        Result := -3
      else
      if es_Load(es_FileName) then
      begin
            {$IFDEF Windows}
        Result := espeak_Initialize(AUDIO_OUTPUT_SYNCH_PLAYBACK, 500, pointer(ES_DataDirectory), 0);
            {$else}
        Result := espeak_Initialize(AUDIO_OUTPUT_PLAYBACK, 300, pointer(ES_DataDirectory), 0);
            {$ENDIF}

        if Result > -1 then
        begin
          TimerRepeat := Tfpgtimer.Create(50000);
          TimerRepeat.Enabled := False;
          TimerCount := Tfpgtimer.Create(50000);
          TimerCount.Enabled := False;
        end;

      end;

    end;
  end;

  if Result > -1 then
  begin
    initspeech.isloaded := True;

    CompCount := fpgapplication.ComponentCount;

    InitObject;
    espeak_Key('sak is working...');
    TimerRepeat.Enabled := False;
    TimerRepeat.Interval := 600;


    TimerCount.Enabled := False;
    TimerCount.Interval := 700;
    timerCount.OnTimer := @CheckCount;
    if InitSpeech.isWorking = True then
    TimerCount.Enabled := True;
    isenabled := true ;
  end
  else
    Result := -31;
end;

function SAKFreeLib: integer;
var
  i: integer;
begin
  if assigned(InitSpeech) then
  begin

    InitSpeech.TimerCount.Enabled := False;

    InitSpeech.TimerRepeat.Enabled := False;
    SAKUnLoadLib;
    sleep(100);

    InitSpeech.TimerCount.Free;


    InitSpeech.TimerRepeat.Free;
    for i := 0 to high(InitSpeech.AssistiveData) do
      InitSpeech.AssistiveData[i].Free;
    InitSpeech.Free;
    sleep(100);
    ES_Unload();
    sleep(100);
    Pa_Unload();
   {$IF DEFINED(windows)}
    DynLibs.UnloadLibrary(VS_Handle);
    VS_Handle := DynLibs.NilHandle;
   {$endif}
    Set8087CW(old8087cw);
  end;
end;

function SAKUnLoadLib: integer;
begin
  InitSpeech.isWorking := False;
  InitSpeech.UnLoadLib;
  isenabled := false ;
end;

function TSAK_Init.UnLoadLib: integer;
var
  i, g: integer;
begin
  if assigned(InitSpeech) then
  begin
    espeak_cancel;

    InitSpeech.TimerCount.Enabled := False;

    for i := 0 to high(InitSpeech.AssistiveData) do
    begin
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is Tfpgapplication) then
      begin
        Tfpgapplication(InitSpeech.AssistiveData[i].TheObject).OnKeyPress :=
          InitSpeech.AssistiveData[i].OriOnKeyPress;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgForm) then
      begin
        TfpgForm(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
        TfpgForm(InitSpeech.AssistiveData[i].TheObject).OnKeyPress :=
          InitSpeech.AssistiveData[i].OriOnKeyPress;
        TfpgForm(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TfpgForm(InitSpeech.AssistiveData[i].TheObject).OnDestroy :=
          InitSpeech.AssistiveData[i].OriOnDestroy;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgLabel) then
      begin
        TfpgLabel(InitSpeech.AssistiveData[i].TheObject).OnClick :=
          InitSpeech.AssistiveData[i].OriOnClick;
        TfpgLabel(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgButton) then
      begin
        TfpgButton(InitSpeech.AssistiveData[i].TheObject).OnClick :=
          InitSpeech.AssistiveData[i].OriOnClick;
        TfpgButton(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TfpgButton(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgPopupMenu) then
      begin
        TfpgPopupMenu(InitSpeech.AssistiveData[i].TheObject).OnShow :=
          InitSpeech.AssistiveData[i].OriOnClick;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgMenuItem) then
      begin
        TfpgMenuItem(InitSpeech.AssistiveData[i].TheObject).OnClick :=
          InitSpeech.AssistiveData[i].OriOnClick;
        //   TfpgMenuItem(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
        //  InitSpeech.AssistiveData[i].OriOnEnter;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgEdit) then
      begin
        TfpgEdit(InitSpeech.AssistiveData[i].TheObject).OnKeyChar :=
          InitSpeech.AssistiveData[i].OriOnKeyChar;
        TfpgEdit(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TfpgEdit(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgMemo) then
      begin
        TfpgMemo(InitSpeech.AssistiveData[i].TheObject).OnKeyChar :=
          InitSpeech.AssistiveData[i].OriOnKeyChar;
        TfpgMemo(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TfpgMemo(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgStringgrid) then
      begin
        TfpgStringgrid(InitSpeech.AssistiveData[i].TheObject).OnFocusChange :=
          InitSpeech.AssistiveData[i].OriOnFocusChange;
        TfpgStringgrid(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TfpgStringgrid(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TfpgStringgrid(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgCheckBox) then
      begin
        TfpgCheckBox(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TfpgCheckBox(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TfpgCheckBox(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgTrackBar) then
      begin
        TfpgTrackBar(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnTrackbarChange;
        TfpgTrackBar(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TfpgTrackBar(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgComboBox) then
      begin
        TfpgComboBox(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TfpgComboBox(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TfpgComboBox(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgListBox) then
      begin
        TfpgListBox(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TfpgListBox(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TfpgListBox(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TfpgRadiobutton) then
      begin
        TfpgRadiobutton(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TfpgRadiobutton(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TfpgRadiobutton(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].oriOnMouseMove;
      end;
    end;
    SetLength(InitSpeech.AssistiveData, 0);

  end;
end;
////////////////////// Voice Config Procedures
function SAKSetVoice(gender: shortint; language: string): integer;
begin
  CustomVoice.voice.languages := PChar(language);
  CustomVoice.voice.gender := gender;
  espeak_SetVoiceByProperties(CustomVoice.voice);
end;

////////////////////// Speecher Procedures ////////////////

function SAKSay(Text: string): integer; ///// Start speaking the text with default voice
begin
  espeak_Key(pointer(Text));
end;

function SAKSay(Text: string; VoiceParam: TSAK_VoiceConfig): integer;
  ///// Start speaking the text with custom voice
begin
  espeak_Key(pointer(Text));   //// TODO
end;

function SAKSay(char: word): integer;
  ///// Start speaking the character with default voice
begin
  espeak_Char(char);
end;

function SAKSay(char: word; VoiceParam: TSAK_VoiceConfig): integer;
  ///// Start speaking with custom voice
begin
  espeak_Char(char); ///// TODO
end;

function SAKStop: integer; /// stop speaking;
begin
  espeak_Cancel;
end;

///////////// Enabled procedure

function SakIsEnabled: boolean;
begin
  Result := isenabled;
end;


end.
