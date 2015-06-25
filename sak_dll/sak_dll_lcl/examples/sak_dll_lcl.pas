unit sak_dll_lcl;

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
    Copyright (C) 2013/2015  Fred van Stappen

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

{$mode objfpc}{$H+}

interface

uses
  {$IF DEFINED(windows)}
  dynlibs,
  {$endif}

  Forms,
  Grids,
  Controls,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  Dialogs,
  Menus,
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
  TOnKeyDown = procedure(Sender: TObject; var Key: word; Shift: TShiftState) of object;
  TOnKeyUp = procedure(Sender: TObject; var Key: word; Shift: TShiftState) of object;
  TOnKeyPress = procedure(Sender: TObject; var Key: char) of object;
  TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer) of object;
  TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer) of object;
  TOnMouseMove = procedure(Sender: TObject; Shift: TShiftState; X, Y: integer) of object;
  TOnSelectionChange = procedure(Sender: TObject; User: boolean) of object;
  TOnSelectionChangeDialog = procedure(Sender: TObject) of object;
  TOnMenuChange = procedure(Sender: TObject; item: Tmenuitem; User: boolean) of object;

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
    OriOnKeyDown: TOnKeyDown;
    OriOnKeyUp: TOnKeyUp;
    OriOnSelectionChange: TOnSelectionChange;
    OriOnSelectionChangeDialog: TOnSelectionChangeDialog;
    OriOnMenuChange: TOnMenuChange;

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
    CheckObject: TObject;
    CheckKey: word;
    CheckPoint: Tpoint;
    CheckShift: TShiftState;
    AssistiveData: array of TSAK_Assistive;
    menuitem: Tmenuitem;
    CheckKeyChar: char;
    TimerRepeat: TTimer;
    CheckXPoint: integer;
    CheckYPoint: integer;
    procedure SAKEnter(Sender: TObject);
    procedure SAKChange(Sender: TObject);
    procedure SAKClick(Sender: TObject);
    procedure SAKDestroy(Sender: TObject);

    procedure CheckCount(Sender: TObject; Form: TCustomForm);
    procedure CheckActive(Sender: TObject; thecontrol: Tcontrol);
    procedure CheckRepeatEnter(Sender: TObject);
    procedure CheckRepeatClick(Sender: TObject);
    procedure CheckRepeatChange(Sender: TObject);
    procedure CheckRepeatKeyPress(Sender: TObject);
    procedure CheckRepeatMouseMove(Sender: TObject);
    procedure CheckRepeatMenuChange(Sender: TObject);
    procedure CheckRepeatDialog(Sender: TObject);
    procedure CheckRepeatSelectionChange(Sender: TObject);
    procedure CheckKeyUp(Sender: TObject);
    procedure SAKKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure SAKKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure SAKKeyPress(Sender: TObject; var Key: char);
    procedure SAKMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure SAKMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure SAKMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure SAKSelectionChange(Sender: TObject; User: boolean);
    procedure SAKSelectionChangeDialog(Sender: TObject);
    procedure SAKMenuChange(Sender: TObject; item: Tmenuitem; User: boolean);

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
  if (Sender is TLabel) then
    Result := TLabel(Sender).Caption
  else
  if (Sender is TButton) then
  begin
    if (trim(TButton(Sender).Caption) <> '') then
      Result := TButton(Sender).Caption
    else
    if (trim(TButton(Sender).Name) <> '') then
      Result := TButton(Sender).Name
    else
      Result := TButton(Sender).hint;
  end
  else
  if (Sender is TColorButton) then
  begin
    if (trim(TColorButton(Sender).Caption) <> '') then
      Result := TColorButton(Sender).Caption
    else
    if (trim(TColorButton(Sender).Name) <> '') then
      Result := TColorButton(Sender).Name
    else
      Result := TColorButton(Sender).hint;
  end
  else
  if (Sender is TForm) then
    Result := TForm(Sender).Caption
  else
  if (Sender is TEdit) then
    Result := TEdit(Sender).Name
  else
  if (Sender is TMemo) then
    Result := TMemo(Sender).Name
  else
  if (Sender is TCheckBox) then
    Result := TCheckBox(Sender).Caption
  else
  if (Sender is TRadiobutton) then
    Result := TRadiobutton(Sender).Caption
  else
  if (Sender is TStringgrid) then
    Result := TStringgrid(Sender).Name
  else
  if (Sender is TListBox) then
    Result := TListBox(Sender).Name
  else
  if (Sender is TComboBox) then
    Result := TComboBox(Sender).Name
  else
  if (Sender is TOpenDialog) then
    Result := TSaveDialog(Sender).title
  else
  if (Sender is TMainMenu) then
    Result := TMainMenu(Sender).Name
  else
  if (Sender is TMenuItem) then
    Result := TMenuItem(Sender).Caption
  else
  if (Sender is TTrackBar) then
    Result := TTrackBar(Sender).Name
  else
  if (Sender is TOpenDialog) then
    Result := TSaveDialog(Sender).title;
end;

procedure TSAK_Init.SAKDestroy(Sender: TObject);
var
  i: integer;
begin
  isworking := False;
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

      espeak_Key(PChar(texttmp));
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

procedure TSAK_Init.SAKMenuChange(Sender: TObject; item: Tmenuitem; User: boolean);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnMenuChange <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnMenuChange(Sender, item, user);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckRepeatMenuChange;
  TimerRepeat.Enabled := False;
  TimerRepeat.Interval := 300;
  CheckObject := Sender;
  menuitem := item;
  TimerRepeat.Enabled := True;
end;

procedure TSAK_Init.CheckRepeatMenuChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
  user: boolean;
begin
  user := False;
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) and (CheckObject is TMainMenu) and (menuitem is Tmenuitem) then
    begin
      with menuitem as Tmenuitem do
        texttmp := Caption + ' selected';
      espeak_Key(PChar(texttmp));

       exit;
    end;
  end;
end;

procedure TSAK_Init.SAKSelectionChange(Sender: TObject; User: boolean);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnSelectionChange <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnSelectionChange(Sender, user);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckRepeatSelectionChange;
  TimerRepeat.Enabled := False;
  TimerRepeat.Interval := 500;
  CheckObject := Sender;
  TimerRepeat.Enabled := True;
end;

procedure TSAK_Init.CheckActive(Sender: TObject; thecontrol: Tcontrol);
var
  i: integer;
  texttmp: string;
  user: boolean;
begin
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (thecontrol = InitSpeech.AssistiveData[i].TheObject) and (thecontrol is TStringgrid) then
    begin
      with thecontrol as TStringgrid do
        texttmp := 'Grid ' + Name + ' selected';
      espeak_Key(PChar(texttmp));
      exit;
    end;

    if (thecontrol = InitSpeech.AssistiveData[i].TheObject) and (thecontrol is TColorButton) then
    begin
      with thecontrol as TColorButton do
        texttmp := Caption + ' selected';
      espeak_Key(PChar(texttmp));
      exit;
    end;
  end;
end;

procedure TSAK_Init.CheckRepeatSelectionChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
  user: boolean;
begin
  user := False;
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) and (CheckObject is TListBox) then
    begin
      with CheckObject as TListBox do
        texttmp := GetSelectedText + ' selected';
      espeak_Key(PChar(texttmp));
         exit;
    end;
  end;
end;

procedure TSAK_Init.SAKSelectionChangeDialog(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnSelectionChangeDialog <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnSelectionChangeDialog(Sender);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckRepeatDialog;
  TimerRepeat.Interval := 500;
  TimerRepeat.Enabled := False;
  TimerRepeat.Enabled := True;
  CheckObject := Sender;
end;

procedure TSAK_Init.CheckRepeatDialog(Sender: TObject);
var
  i, x: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
  x := 0;
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
    begin

      if (CheckObject is TSaveDialog) then
      begin
        x := 1;
        with CheckObject as TSaveDialog do
          texttmp := FileName + ' selected';
      end;

      if (CheckObject is TOpenDialog) then
      begin
        x := 1;
        with CheckObject as TOpenDialog do
          texttmp := FileName + ' selected';
      end;
      if x = 1 then
      begin
        espeak_Key(PChar(texttmp));

        exit;
      end;
    end;
  end;
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
      if (CheckObject is TComboBox) then
        with CheckObject as TComboBox do
          texttmp := Text + ' selected';

      if (CheckObject is TTrackBar) then
        with CheckObject as TTrackBar do
          texttmp := Name + ' position is, ' + IntToStr(position);


      if (CheckObject is TCheckBox) then
        with CheckObject as TCheckBox do

          if Checked = False then
            texttmp := 'Change  ' + Caption + ', in false'
          else
            texttmp :=
              'Change  ' + Caption + ', in true';

      if (CheckObject is TRadioButton) then
        with CheckObject as TRadioButton do

          if Checked = False then
            texttmp := 'Change  ' + Caption + ', in false'
          else
            texttmp :=
              'Change  ' + Caption + ', in true';

      espeak_Key(PChar(texttmp));

      exit;
    end;
  end;
end;

procedure TSAK_Init.SAKMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  /// usefull ?
end;

procedure TSAK_Init.SAKMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  /// usefull ?
end;

procedure TSAK_Init.SAKMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
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
        InitSpeech.AssistiveData[i].OriOnMouseMove(Sender, shift, x, y);
      finded := True;
    end;
    Inc(i);
  end;

    TimerRepeat.Enabled := False;
    TimerRepeat.OnTimer := @CheckRepeatMouseMove;
    TimerRepeat.Interval := 600;
    CheckObject := Sender;
    CheckXPoint := x;
    CheckYPoint := y;
    CheckShift := Shift;
    TimerRepeat.Enabled := True;
;
end;

procedure TSAK_Init.CheckRepeatMouseMove(Sender: TObject);
var
  texttmp, stringtemp, nameobj: string;
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
        if CheckObject is TForm then
        begin
          lastfocused := ' ';
       //   texttmp := 'Left,  ' + IntToStr(CheckXPoint) + ' , of,  ' + IntToStr(TForm(CheckObject).Width) +
       //     '.   Top,  ' + IntToStr(CheckYPoint) + ' , of, ' + IntToStr(TForm(CheckObject).Height);
       //   espeak_Key(PChar(texttmp));
        end
        else
        begin
          nameobj := whatname(CheckObject);
          lastfocused := nameobj;
                 stringtemp := '' ;

        if  (CheckObject is tcheckbox) then
        begin
          if tcheckbox(CheckObject).Checked = false then stringtemp := ' , false, ' else stringtemp := ' , true, ';
        end;

         if  (CheckObject is tradiobutton) then
        begin
          if tradiobutton(CheckObject).Checked = false then stringtemp := ' , false, ' else stringtemp := ' , true, ';
        end;

         if  (CheckObject is ttrackbar) then
        begin
        stringtemp := ' , ' + inttostr(ttrackbar(CheckObject).Position) + ' , ' ;
        end;

          texttmp := InitSpeech.AssistiveData[i].Description + ' ' + nameobj + stringtemp + ' focused';
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
        nameobj := whatname(CheckObject);
        texttmp := InitSpeech.AssistiveData[i].Description + ' ' + nameobj + ' selected';
        espeak_Key(PChar(texttmp));
           exit;
      end;
    end;
  end;
  mouseclicked := False;
end;

procedure TSAK_Init.SAKKeyPress(Sender: TObject; var Key: char);
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
        InitSpeech.AssistiveData[i].OriOnKeyPress(Sender, key);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckRepeatKeyPress;
  TimerRepeat.Interval := 300;
  CheckObject := Sender;
  CheckKeyChar := Key;
  TimerRepeat.Enabled := True;
end;

procedure TSAK_Init.CheckRepeatKeyPress(Sender: TObject);
var
  tempstr: string;
  i: integer;
begin
  TimerRepeat.Enabled := False;
  tempstr := CheckKeyChar;
  tempstr := trim(tempstr);
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
    begin

      tempstr := CheckKeyChar;
      tempstr := trim(tempstr);

      if tempstr <> '' then
        espeak_Key(Pchar(tempstr));

        exit;
    end;
  end;
end;

procedure TSAK_Init.SAKKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
var
  i: integer = 0;
  finded: boolean = False;
begin
   TimerRepeat.Enabled := False;
  while (finded = False) and (i < (Length(InitSpeech.AssistiveData))) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
     (InitSpeech.AssistiveData[i].OriOnKeyUp <> nil) then
     begin
        InitSpeech.AssistiveData[i].OriOnKeyUp(Sender, key, shift);
      finded := True;
    end;
    Inc(i);
  end;
  TimerRepeat.OnTimer := @CheckKeyUp;
  TimerRepeat.Interval := 600;
  TimerRepeat.Enabled := False;
  CheckObject := Sender;
  CheckKey := Key;
  CheckShift := Shift;
  TimerRepeat.Enabled := True;
end;

procedure TSAK_Init.CheckKeyUp(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
    begin

      if ((CheckKey = 38) or (CheckKey = 37) or (CheckKey = 39) or (CheckKey = 13) or (CheckKey = 40)) and (CheckObject is tstringgrid) then
        with CheckObject as tstringgrid do
        begin
          if (fixedrows = 1) and (fixedcols = 1) then
            texttmp := Cells[col, 0] + ', ' + Cells[0, row] + '. ' + Cells[col, row]
          else
          if (fixedrows = 1) and (fixedcols = 0) then
            texttmp := Cells[col, 0] + ', row ' + IntToStr(row) + '. ' + Cells[col, row]
          else
          if (fixedrows = 0) and (fixedcols = 1) then
            texttmp := 'column  ' + IntToStr(col) + ' , ' + Cells[0, row] + '. ' + Cells[col, row]
          else
            texttmp := 'column  ' + IntToStr(col) + ' , row  ' + IntToStr(row) + '. ' + Cells[col, row];

          espeak_Key(PChar(texttmp));
        end;

      exit;
    end;
  end;

end;

procedure TSAK_Init.SAKKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  i: integer;

begin

  for i := 0 to high(InitSpeech.AssistiveData) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) then
    begin
      if (key = 27) then
        espeak_Cancel
      else
      begin
        case key of

          13: if (Sender is TButton) then
            else
              espeak_Key('enter');
          8: espeak_Key('back space');
          32: if (Sender is TCheckBox) or (Sender is TButton) then
            else
              espeak_Key('space');
          38: espeak_Key('up');
          40: espeak_Key('down');
          37: espeak_Key('left');
          39: espeak_Key('right');
          112: espeak_Key('f 1');
          113: espeak_Key('f 2');
          114: espeak_Key('f 3');
          115: espeak_Key('f 4');
          116: espeak_Key('f 5');
          117: espeak_Key('f 6');
          118: espeak_Key('f 7');
          119: espeak_Key('f 8');
          120: espeak_Key('f 9');
          121: espeak_Key('f 10');
          122: espeak_Key('f 11');
          9: espeak_Key('tab');
          16: espeak_Key('shift');
          17: espeak_Key('control');
          18: espeak_Key('alt');
          20: espeak_Key('caps lock');
          236: espeak_Key('alt gr');
          33: espeak_Key('page up');
          34: espeak_Key('page down');
          46: espeak_Key('delete');
          45: espeak_Key('insert');
          27: espeak_Key('escape');
          35: espeak_Key('end');
          123: if (Sender is tmemo) then
              with Sender as tmemo do
                espeak_Key(Pchar(Text))
            else
            if (Sender is tedit) then
              with Sender as tedit do
                espeak_Key(Pchar(Text))
            else
              espeak_Key('f 12');
        end;

        if InitSpeech.AssistiveData[i].OriOnKeyDown <> nil then
          InitSpeech.AssistiveData[i].OriOnKeyDown(Sender, Key, Shift);
        exit;
      end;
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
  i, j, f: integer;
begin
  mouseclicked := False;
  SetLength(InitSpeech.AssistiveData, 0);

  for f := 0 to application.ComponentCount - 1 do  ///
  begin
    SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
      TSAK_Assistive.Create();
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
      'Form';
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
      TForm(application.Components[f]);
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyPress :=
      TForm(application.Components[f]).OnKeyPress;
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyDown :=
      TForm(application.Components[f]).OnKeyDown;
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
      TForm(application.Components[f]).OnEnter;
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
      TForm(application.Components[f]).OnMouseDown;
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnDestroy :=
      TForm(application.Components[f]).OnDestroy;

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
      TForm(application.Components[f]).OnMouseMove;

    TForm(application.Components[f]).OnKeyPress := @InitSpeech.SAKKeyPress;
    TForm(application.Components[f]).OnKeyDown := @InitSpeech.SAKKeyDown;
    TForm(application.Components[f]).OnEnter := @InitSpeech.SAKEnter;
    TForm(application.Components[f]).OnMouseDown := @InitSpeech.SAKMouseDown;
    TForm(application.Components[f]).OnMouseMove := @InitSpeech.SAKMouseMove;
    TForm(application.Components[f]).OnDestroy := @InitSpeech.SAKDestroy;

 //  with (application.Components[f]) as TForm do

    for i := 0 to application.Components[f].ComponentCount - 1 do

    begin
      if (application.Components[f].Components[i] is TWinControl)  or
     (application.Components[f].Components[i] is TCheckBox) or (application.Components[f].Components[i] is TButton) or (application.Components[f].Components[i] is TColorButton) or
          (application.Components[f].Components[i] is TMemo) or (application.Components[f].Components[i] is TRadioButton) or (application.Components[f].Components[i] is TEdit) or
          (application.Components[f].Components[i] is TStringGrid) or (application.Components[f].Components[i] is TSaveDialog) or (application.Components[f].Components[i] is TOpenDialog) or
          (application.Components[f].Components[i] is TListBox) or (application.Components[f].Components[i] is TComboBox) or (application.Components[f].Components[i] is TMainMenu) or
          (application.Components[f].Components[i] is TMenuItem) or (application.Components[f].Components[i] is TTrackBar) or (application.Components[f].Components[i] is TLabel)
       then
      begin

        if (application.Components[f].Components[i] is TTrackBar) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Track bar';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TTrackBar(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
            TTrackBar(application.Components[f].Components[i]).OnEnter;
          TTrackBar(application.Components[f].Components[i]).OnEnter := @InitSpeech.SAKEnter;

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
            TTrackBar(application.Components[f].Components[i]).OnChange;
          TTrackBar(application.Components[f].Components[i]).OnChange := @InitSpeech.SAKChange;
        end
        else

        if (application.Components[f].Components[i] is TMenuItem) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Menu Item';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
            TMenuItem(application.Components[f].Components[i]).OnClick;

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TMenuItem(application.Components[f].Components[i]);
          TMenuItem(application.Components[f].Components[i]).OnClick := @InitSpeech.SAKClick;
        end
        else

        if (application.Components[f].Components[i] is TMainMenu) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Main Menu';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TMainMenu(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMenuChange :=
            TMainMenu(application.Components[f].Components[i]).OnChange;
          TMainMenu(application.Components[f].Components[i]).OnChange := @InitSpeech.SAKMenuChange;
        end
        else
        if (application.Components[f].Components[i] is TLabel) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Label,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TLabel(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
            TLabel(application.Components[f].Components[i]).OnClick;
          TLabel(application.Components[f].Components[i]).OnClick := @InitSpeech.SAKClick;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TLabel(application.Components[f].Components[i]).OnMouseMove;
          TLabel(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end
        else
        if (application.Components[f].Components[i] is TButton) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Button,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TButton(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
            TButton(application.Components[f].Components[i]).OnEnter;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyDown :=
            TButton(application.Components[f].Components[i]).OnKeyDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
            TButton(application.Components[f].Components[i]).OnClick;

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TButton(application.Components[f].Components[i]).OnMouseMove;
          TButton(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;

          TButton(application.Components[f].Components[i]).OnEnter := @InitSpeech.SAKEnter;
          TButton(application.Components[f].Components[i]).OnKeyDown := @InitSpeech.SAKKeyDown;
          TButton(application.Components[f].Components[i]).OnClick := @InitSpeech.SAKClick;
        end
        else
        if (application.Components[f].Components[i] is TColorButton) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();


          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Color Button,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TColorButton(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
            TColorButton(application.Components[f].Components[i]).OnClick;
          TColorButton(application.Components[f].Components[i]).OnClick := @InitSpeech.SAKClick;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TColorButton(application.Components[f].Components[i]).OnMouseMove;
          TColorButton(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end
        else
        if (application.Components[f].Components[i] is TSaveDialog) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Save Dialog';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TSaveDialog(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnSelectionChangeDialog :=
            TSaveDialog(application.Components[f].Components[i]).OnSelectionChange;
          TSaveDialog(application.Components[f].Components[i]).OnSelectionChange := @InitSpeech.SAKSelectionChangeDialog;
          //          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
          //        TSaveDialog(application.Components[f].Components[i]).OnMouseMove;
          //      TSaveDialog(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;

        end
        else
        if (application.Components[f].Components[i] is TOpenDialog) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Open Dialog';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TOpenDialog(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnSelectionChangeDialog :=
            TOpenDialog(application.Components[f].Components[i]).OnSelectionChange;
          TOpenDialog(application.Components[f].Components[i]).OnSelectionChange := @InitSpeech.SAKSelectionChangeDialog;
          //     InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
          //    TOpenDialog(application.Components[f].Components[i]).OnMouseMove;
          //  TOpenDialog(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end
        else
        if (application.Components[f].Components[i] is TListBox) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'List Box,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TListBox(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
            TListBox(application.Components[f].Components[i]).OnEnter;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
            TListBox(application.Components[f].Components[i]).OnMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnSelectionChange :=
            TListBox(application.Components[f].Components[i]).OnSelectionChange;

          TListBox(application.Components[f].Components[i]).OnEnter := @InitSpeech.SAKEnter;
          ;
          TListBox(application.Components[f].Components[i]).OnSelectionChange := @InitSpeech.SAKSelectionChange;
          TListBox(application.Components[f].Components[i]).OnMouseDown := @InitSpeech.SAKMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TListBox(application.Components[f].Components[i]).OnMouseMove;
          TListBox(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end
        else
        if (application.Components[f].Components[i] is TRadioButton) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Radio Button,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TRadioButton(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
            TRadioButton(application.Components[f].Components[i]).OnEnter;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
            TRadioButton(application.Components[f].Components[i]).OnMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
            TRadioButton(application.Components[f].Components[i]).OnChange;

          TRadioButton(application.Components[f].Components[i]).OnEnter := @InitSpeech.SAKEnter;
          TRadioButton(application.Components[f].Components[i]).OnChange := @InitSpeech.SAKChange;
          TRadioButton(application.Components[f].Components[i]).OnMouseDown := @InitSpeech.SAKMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TRadioButton(application.Components[f].Components[i]).OnMouseMove;
          TRadioButton(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end
        else
        if (application.Components[f].Components[i] is TComboBox) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Combo Box,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TComboBox(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
            TComboBox(application.Components[f].Components[i]).OnEnter;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
            TComboBox(application.Components[f].Components[i]).OnMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
            TComboBox(application.Components[f].Components[i]).OnChange;

          TComboBox(application.Components[f].Components[i]).OnEnter := @InitSpeech.SAKEnter;
          TComboBox(application.Components[f].Components[i]).OnChange := @InitSpeech.SAKChange;
          TComboBox(application.Components[f].Components[i]).OnMouseDown := @InitSpeech.SAKMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TComboBox(application.Components[f].Components[i]).OnMouseMove;
          TComboBox(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end
        else
        if (application.Components[f].Components[i] is TCheckBox) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Check Box,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TCheckBox(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
            TCheckBox(application.Components[f].Components[i]).OnEnter;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
            TCheckBox(application.Components[f].Components[i]).OnMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
            TCheckBox(application.Components[f].Components[i]).OnChange;
          TCheckBox(application.Components[f].Components[i]).OnEnter := @InitSpeech.SAKEnter;
          TCheckBox(application.Components[f].Components[i]).OnChange := @InitSpeech.SAKChange;
          TCheckBox(application.Components[f].Components[i]).OnMouseDown := @InitSpeech.SAKMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TCheckBox(application.Components[f].Components[i]).OnMouseMove;
          TCheckBox(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end
        else
        if (application.Components[f].Components[i] is TStringGrid) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'String Grid,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TStringGrid(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
            TStringGrid(application.Components[f].Components[i]).OnEnter;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyPress :=
            TStringGrid(application.Components[f].Components[i]).OnKeyPress;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyDown :=
            TStringGrid(application.Components[f].Components[i]).OnKeyDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyUp :=
            TStringGrid(application.Components[f].Components[i]).OnKeyUp;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
            TStringGrid(application.Components[f].Components[i]).OnMouseDown;

          TStringGrid(application.Components[f].Components[i]).OnKeyPress := @InitSpeech.SAKKeyPress;
          TStringGrid(application.Components[f].Components[i]).OnEnter := @InitSpeech.SAKEnter;
          TStringGrid(application.Components[f].Components[i]).OnKeyDown := @InitSpeech.SAKKeyDown;
          TStringGrid(application.Components[f].Components[i]).OnKeyUp := @InitSpeech.SAKKeyUp;
          TStringGrid(application.Components[f].Components[i]).OnMouseDown := @InitSpeech.SAKMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TStringGrid(application.Components[f].Components[i]).OnMouseMove;
          TStringGrid(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end
        else
        if (application.Components[f].Components[i] is TMemo) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Memo,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TMemo(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
            TMemo(application.Components[f].Components[i]).OnEnter;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyPress :=
            TMemo(application.Components[f].Components[i]).OnKeyPress;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyDown :=
            TMemo(application.Components[f].Components[i]).OnKeyDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
            TMemo(application.Components[f].Components[i]).OnMouseDown;
          TMemo(application.Components[f].Components[i]).OnKeyPress := @InitSpeech.SAKKeyPress;
          TMemo(application.Components[f].Components[i]).OnEnter := @InitSpeech.SAKEnter;
          TMemo(application.Components[f].Components[i]).OnKeyDown := @InitSpeech.SAKKeyDown;
          TMemo(application.Components[f].Components[i]).OnMouseDown := @InitSpeech.SAKMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TMemo(application.Components[f].Components[i]).OnMouseMove;
          TMemo(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end
        else
        if (application.Components[f].Components[i] is TEdit) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Edit,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TEdit(application.Components[f].Components[i]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
            TEdit(application.Components[f].Components[i]).OnEnter;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyPress :=
            TEdit(application.Components[f].Components[i]).OnKeyPress;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyDown :=
            TEdit(application.Components[f].Components[i]).OnKeyDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
            TEdit(application.Components[f].Components[i]).OnMouseDown;

          TEdit(application.Components[f].Components[i]).OnKeyPress := @InitSpeech.SAKKeyPress;
          TEdit(application.Components[f].Components[i]).OnEnter := @InitSpeech.SAKEnter;
          TEdit(application.Components[f].Components[i]).OnKeyDown := @InitSpeech.SAKKeyDown;
          TEdit(application.Components[f].Components[i]).OnMouseDown := @InitSpeech.SAKMouseDown;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TEdit(application.Components[f].Components[i]).OnMouseMove;
          TEdit(application.Components[f].Components[i]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end
        else
        if (application.Components[f].Components[i] is TWinControl) then
        begin

          with application.Components[f].Components[i] as TWinControl do

            for j := 0 to application.Components[f].Components[i].ComponentCount - 1 do
            begin
              if (application.Components[f].Components[i].Components[j] is TButton) then
              begin
                SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
                  TSAK_Assistive.Create();

                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
                  'Button,';
                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
                  TButton(application.Components[f].Components[i].Components[j]);
                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
                  TButton(application.Components[f].Components[i].Components[j]).OnEnter;
                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyDown :=
                  TButton(application.Components[f].Components[i].Components[j]).OnKeyDown;
                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
                  TButton(application.Components[f].Components[i].Components[j]).OnClick;

                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
                  TButton(application.Components[f].Components[i].Components[j]).OnMouseMove;
                TButton(application.Components[f].Components[i].Components[j]).OnMouseMove := @InitSpeech.SAKMouseMove;

                TButton(application.Components[f].Components[i].Components[j]).OnEnter := @InitSpeech.SAKEnter;
                TButton(application.Components[f].Components[i].Components[j]).OnKeyDown := @InitSpeech.SAKKeyDown;
                TButton(application.Components[f].Components[i].Components[j]).OnClick := @InitSpeech.SAKClick;
              end
              else
              if (application.Components[f].Components[i].Components[j] is TColorButton) then
              begin
                SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
                  TSAK_Assistive.Create();

                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
                  'Color Button,';
                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
                  TColorButton(application.Components[f].Components[i].Components[j]);
                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
                  TColorButton(application.Components[f].Components[i].Components[j]).OnClick;
                TColorButton(application.Components[f].Components[i].Components[j]).OnClick := @InitSpeech.SAKClick;
                InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
                  TColorButton(application.Components[f].Components[i].Components[j]).OnMouseMove;
                TColorButton(application.Components[f].Components[i].Components[j]).OnMouseMove := @InitSpeech.SAKMouseMove;

              end
               else
        if (application.Components[f].Components[i].Components[j] is TLabel) then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
            'Label,';
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
            TLabel(application.Components[f].Components[i].Components[j]);
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
            TLabel(application.Components[f].Components[i].Components[j]).OnClick;
          TLabel(application.Components[f].Components[i].Components[j]).OnClick := @InitSpeech.SAKClick;
          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseMove :=
            TLabel(application.Components[f].Components[i].Components[j]).OnMouseMove;
          TLabel(application.Components[f].Components[i].Components[j]).OnMouseMove := @InitSpeech.SAKMouseMove;
        end;

            end;

        end;

      end;

    end;
  end;

end;

procedure TSAK_Init.CheckCount(Sender: TObject; Form: TCustomForm);
begin

  if isWorking = True then
  begin
    UnLoadLib;
    InitObject;
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
          Screen.AddHandlerActiveControlChanged(@CheckActive);
          Screen.AddHandlerFormAdded(@CheckCount);
          Screen.AddHandlerRemoveForm(@CheckCount);
          TimerRepeat := Ttimer.Create(TimerRepeat);
        end;
      end;

    end;
  end;

  if Result > -1 then
  begin
    initspeech.isloaded := True;

    InitObject;
    espeak_Key('sak is working...');
    TimerRepeat.Enabled := False;
    TimerRepeat.Interval := 600;
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
    InitSpeech.TimerRepeat.Enabled := False;
    SAKUnLoadLib;
    sleep(100);
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

    Screen.RemoveHandlerFormAdded(@CheckCount);
    Screen.RemoveHandlerRemoveForm(@CheckCount);
    Screen.RemoveHandlerActiveControlChanged(@CheckActive);

    for i := 0 to high(InitSpeech.AssistiveData) do
    begin
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TMainMenu) then
      begin
        TMainMenu(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnMenuChange;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TMenuItem) then
      begin
        TMenuItem(InitSpeech.AssistiveData[i].TheObject).OnClick :=
          InitSpeech.AssistiveData[i].OriOnClick;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TForm) then
      begin
        TForm(InitSpeech.AssistiveData[i].TheObject).OnKeyPress :=
          InitSpeech.AssistiveData[i].OriOnKeyPress;
        TForm(InitSpeech.AssistiveData[i].TheObject).OnKeyDown :=
          InitSpeech.AssistiveData[i].OriOnKeyDown;
        TForm(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].oriOnEnter;
        TForm(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TForm(InitSpeech.AssistiveData[i].TheObject).OnDestroy :=
          InitSpeech.AssistiveData[i].OriOnDestroy;
        TForm(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TLabel) then
      begin
        TLabel(InitSpeech.AssistiveData[i].TheObject).OnClick :=
          InitSpeech.AssistiveData[i].OriOnClick;
        TLabel(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TTrackBar) then
      begin
        TTrackBar(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TTrackBar(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TTrackBar(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TTrackBar(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TCheckBox) then
      begin
        TCheckBox(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TCheckBox(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TCheckBox(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TCheckBox(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TComboBox) then
      begin
        TComboBox(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TComboBox(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TComboBox(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TComboBox(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TListBox) then
      begin
        TListBox(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TListBox(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TListBox(InitSpeech.AssistiveData[i].TheObject).OnSelectionChange :=
          InitSpeech.AssistiveData[i].OriOnSelectionChange;
        TListBox(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TRadioButton) then
      begin
        TRadioButton(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TRadioButton(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TRadioButton(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TRadioButton(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TButton) then
      begin
        TButton(InitSpeech.AssistiveData[i].TheObject).OnKeyDown :=
          InitSpeech.AssistiveData[i].OriOnKeyDown;
        TButton(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TButton(InitSpeech.AssistiveData[i].TheObject).OnClick :=
          InitSpeech.AssistiveData[i].OriOnClick;
        TButton(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TEdit) then
      begin
        TEdit(InitSpeech.AssistiveData[i].TheObject).OnKeyPress :=
          InitSpeech.AssistiveData[i].OriOnKeyPress;
        TEdit(InitSpeech.AssistiveData[i].TheObject).OnKeyDown :=
          InitSpeech.AssistiveData[i].OriOnKeyDown;
        TEdit(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TEdit(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TEdit(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TMemo) then
      begin
        TMemo(InitSpeech.AssistiveData[i].TheObject).OnKeyPress :=
          InitSpeech.AssistiveData[i].OriOnKeyPress;
        TMemo(InitSpeech.AssistiveData[i].TheObject).OnKeyDown :=
          InitSpeech.AssistiveData[i].OriOnKeyDown;
        TMemo(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TMemo(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TMemo(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and (InitSpeech.AssistiveData[i].TheObject is TStringgrid) then
      begin
        TStringgrid(InitSpeech.AssistiveData[i].TheObject).OnKeyPress :=
          InitSpeech.AssistiveData[i].OriOnKeyPress;
        TStringgrid(InitSpeech.AssistiveData[i].TheObject).OnKeyDown :=
          InitSpeech.AssistiveData[i].OriOnKeyDown;
        TStringgrid(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
        TStringgrid(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TStringgrid(InitSpeech.AssistiveData[i].TheObject).OnKeyUp :=
          InitSpeech.AssistiveData[i].OriOnKeyUp;
        TStringgrid(InitSpeech.AssistiveData[i].TheObject).OnMouseMove :=
          InitSpeech.AssistiveData[i].OriOnMouseMove;
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
