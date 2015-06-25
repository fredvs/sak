unit sak_lcl;

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
*  5 th release: 2015-05-18  (lcl => more actions)                             *
*  4 th release: 2015-03-13  (sak_dll synchronized with sak)                   *
*  3 th release: 2015-03-09  (mouse focus)                                     *
*  2 th release: 2013-08-01  (use espeak.exe)                                  *
*  1 th release: 2013-06-15  (multi objects, multi forms)                      *
*                                                                              *
********************************************************************************}
    {
    Copyright (C) 2013 - 2015  Fred van Stappen

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
  Classes,
  Forms,
  Grids,
  Controls,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  Dialogs,
  Menus,
  Math, SysUtils, Process
  {$IF not DEFINED(Windows)}
  , baseunix
       {$endif}  ;
(*
{$define darwin}
{$define freebsd}
{$define windows}
{$define cpu64}
{$define cpu86}
*)

const
  male = 1;
  female = 2;

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
  TSAK_IAssistive = class
  private
    TheObject: TObject;
    OriOnKeyPress: TOnKeyPress;
    OriOnClick: TOnClick;
    OriOnEnter: TOnEnter;
    OriOnMouseDown: TOnMouseDown;
    OriOnMouseUp: TOnMouseUp;
    OriOnMouseMove: TOnMouseMove;
    OriOnChange: TOnChange;
    OriOnDestroy: TOnDestroy;
    OriOnKeyDown: TOnKeyDown;
    OriOnKeyUp: TOnKeyUp;
    OriOnSelectionChange: TOnSelectionChange;
    OriOnSelectionChangeDialog: TOnSelectionChangeDialog;
    OriOnMenuChange: TOnMenuChange;
    Description: ansistring;
  end;

type
  TSAK = class
  protected
    old8087cw: word;
    f: integer;
    mouseclicked: boolean;
    lastfocused: string;
    AProcess: TProcess;
    TheWord: string;  //// use F11 key in memo
    TheSentence: string;   //// use F10 key in memo
    TheLastSentence: string;  //// use F10 key in memo
    ES_ExeFileName: ansistring;
    ES_DataDirectory: ansistring;
    ES_LibFileName: ansistring;
    PA_LibFileName: ansistring;
    
    voice_language: ansistring;
    voice_gender: ansistring;
    voice_speed: integer;  //-s
    voice_pitch: integer;  //-p
    voice_volume: integer;  //-a
    CompCount: integer;
    CheckObject: TObject;
    CheckKey: word;
    CheckShift: TShiftState;
    CheckXPoint: integer;
    CheckYPoint: integer;
    AssistiveData: array of TSAK_IAssistive;
    menuitem: Tmenuitem;
    CheckKeyChar: char;
    TimerRepeat: TTimer;
    TimerCount: TTimer;

    ///// Start speaking the text with default voice
    procedure espeak_key(Text: string);

    //// cancel current speaker
    procedure espeak_cancel;

    procedure ChildComponentCount(AComponent: TComponent);

    procedure SAKEnter(Sender: TObject);
    procedure SAKChange(Sender: TObject);
    procedure SAKClick(Sender: TObject);
    procedure SAKDestroy(Sender: TObject);
    procedure CheckCount(Sender: TObject);
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
    procedure SAKMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure SAKMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure SAKSelectionChange(Sender: TObject; User: boolean);
    procedure SAKSelectionChangeDialog(Sender: TObject);
    procedure SAKMenuChange(Sender: TObject; item: Tmenuitem; User: boolean);
    procedure UpdateChild(AComp: TComponent);
    function WhatName(Sender: TObject): string;

  private
    function LoadLib: integer;
    function unLoadLib: integer;
    procedure InitObject;
  end;

/// Load with custom sakit dir
function SAKLoadLib(const SakitDir: string = ''): integer;
//'' = default

/// Load with custom espeak dir
function SAKLoadLib(const eSpeakBin: string; const eSpeaklib: string; const PortaudioLib: string;
                                      const eSpeakDataDir: string ): integer;

function SAKUnloadLib: integer;

 ///// to find the file in sak.ini (what => 0 = espeak bin, 1 = portaudio lib, 2 = espeak lib, 3 = epeak-data dir)
function WhatFile(sakini : string; what : integer) : string;

 {$IF DEFINED(unix)}
function ChangePermission(thefile : string; raisemessage : boolean = true) : integer ;
{$endif} 

///// usefull if events are changed at run time
procedure SAKSuspend();

///// usefull if events are changed at run time
procedure SAKUpdate();

//// is sak enabled ?
function SakIsEnabled: boolean;

////////////////////// Voice Config Procedures ///////////////
function SAKSetVoice(gender: shortint; language: string ; speed: integer ; pitch: integer ; volume : integer ): integer;
// -gender : 1 = man, 2 = woman => defaut -1 (man)
//-language : is the language code => default '' (en) 
////  for example :'en' for english, 'fr' for french, 'pt' for Portugues, etc...
////           (check in /espeak-data if your language is there...)
//  -speed sets the speed in words-per-minute , Range 80 to 450. The default value is 175. => -1
// -pitch  range of 0 to 99. The default is 50.   => -1
// -volume range of 0 to 200. The default is 100. => -1

///// Start speaking the text with default voice
function SAKSay(Text: string): integer;

//// cancel current speaker
function SAKCancel(): integer;

{$IFDEF FREEBSD}
// These are missing for FreeBSD in FPC's RTL
const
  S_IRWXU = S_IRUSR or S_IWUSR or S_IXUSR;
  S_IRWXG = S_IRGRP or S_IWGRP or S_IXGRP;
  S_IRWXO = S_IROTH or S_IWOTH or S_IXOTH;

{$ENDIF}

var
  sak: TSAK;
  isenabled: boolean = False;
  
implementation

/////////////////////////// Capture Assistive Procedures

procedure TSAK.UpdateChild(AComp: TComponent);
var
  j: integer;
begin

  with AComp as TComponent do

     for j := 0 to ComponentCount - 1 do
    begin

      if (Components[j] is TTrackBar) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Track bar';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TTrackBar(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
          TTrackBar(Components[j]).OnEnter;
        TTrackBar(Components[j]).OnEnter := @sak.SAKEnter;

        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
          TTrackBar(Components[j]).OnChange;
        TTrackBar(Components[j]).OnChange := @sak.SAKChange;
      end
      else
      if (Components[j] is TLabel) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Label,';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TLabel(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
          TLabel(Components[j]).OnClick;
        TLabel(Components[j]).OnClick := @sak.SAKClick;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          TLabel(Components[j]).OnMouseMove;
        TLabel(Components[j]).OnMouseMove := @sak.SAKMouseMove;
      end
      else
      if (Components[j] is TButton) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Button,';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TButton(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
          TButton(Components[j]).OnEnter;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyDown :=
          TButton(Components[j]).OnKeyDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
          TButton(Components[j]).OnClick;

        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          TButton(Components[j]).OnMouseMove;
        TButton(Components[j]).OnMouseMove := @sak.SAKMouseMove;

        TButton(Components[j]).OnEnter := @sak.SAKEnter;
        TButton(Components[j]).OnKeyDown := @sak.SAKKeyDown;
        TButton(Components[j]).OnClick := @sak.SAKClick;
      end
      else
      if (Components[j] is TColorButton) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();


        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Color Button,';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TColorButton(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
          TColorButton(Components[j]).OnClick;
        TColorButton(Components[j]).OnClick := @sak.SAKClick;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          TColorButton(Components[j]).OnMouseMove;
        TColorButton(Components[j]).OnMouseMove := @sak.SAKMouseMove;
      end
      else
      if (Components[j] is TSaveDialog) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Save Dialog';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TSaveDialog(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnSelectionChangeDialog :=
          TSaveDialog(Components[j]).OnSelectionChange;
        TSaveDialog(Components[j]).OnSelectionChange := @sak.SAKSelectionChangeDialog;
        //          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
        //        TSaveDialog(Components[j]).OnMouseMove;
        //      TSaveDialog(Components[j]).OnMouseMove := @sak.SAKMouseMove;

      end
      else
      if (Components[j] is TOpenDialog) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Open Dialog';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TOpenDialog(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnSelectionChangeDialog :=
          TOpenDialog(Components[j]).OnSelectionChange;
        TOpenDialog(Components[j]).OnSelectionChange := @sak.SAKSelectionChangeDialog;
        //     sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
        //    TOpenDialog(Components[j]).OnMouseMove;
        //  TOpenDialog(Components[j]).OnMouseMove := @sak.SAKMouseMove;
      end
      else
      if (Components[j] is TListBox) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'List Box,';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TListBox(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
          TListBox(Components[j]).OnEnter;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
          TListBox(Components[j]).OnMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnSelectionChange :=
          TListBox(Components[j]).OnSelectionChange;

        TListBox(Components[j]).OnEnter := @sak.SAKEnter;
        ;
        TListBox(Components[j]).OnSelectionChange := @sak.SAKSelectionChange;
        TListBox(Components[j]).OnMouseDown := @sak.SAKMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          TListBox(Components[j]).OnMouseMove;
        TListBox(Components[j]).OnMouseMove := @sak.SAKMouseMove;
      end
      else
      if (Components[j] is TRadioButton) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Radio Button,';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TRadioButton(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
          TRadioButton(Components[j]).OnEnter;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
          TRadioButton(Components[j]).OnMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
          TRadioButton(Components[j]).OnChange;

        TRadioButton(Components[j]).OnEnter := @sak.SAKEnter;
        TRadioButton(Components[j]).OnChange := @sak.SAKChange;
        TRadioButton(Components[j]).OnMouseDown := @sak.SAKMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          TRadioButton(Components[j]).OnMouseMove;
        TRadioButton(Components[j]).OnMouseMove := @sak.SAKMouseMove;
      end
      else
      if (Components[j] is TComboBox) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Combo Box,';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TComboBox(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
          TComboBox(Components[j]).OnEnter;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
          TComboBox(Components[j]).OnMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
          TComboBox(Components[j]).OnChange;

        TComboBox(Components[j]).OnEnter := @sak.SAKEnter;
        TComboBox(Components[j]).OnChange := @sak.SAKChange;
        TComboBox(Components[j]).OnMouseDown := @sak.SAKMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          TComboBox(Components[j]).OnMouseMove;
        TComboBox(Components[j]).OnMouseMove := @sak.SAKMouseMove;
      end
      else
      if (Components[j] is TCheckBox) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Check Box,';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TCheckBox(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
          TCheckBox(Components[j]).OnEnter;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
          TCheckBox(Components[j]).OnMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
          TCheckBox(Components[j]).OnChange;
        TCheckBox(Components[j]).OnEnter := @sak.SAKEnter;
        TCheckBox(Components[j]).OnChange := @sak.SAKChange;
        TCheckBox(Components[j]).OnMouseDown := @sak.SAKMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          TCheckBox(Components[j]).OnMouseMove;
        TCheckBox(Components[j]).OnMouseMove := @sak.SAKMouseMove;
      end
      else
      if (Components[j] is TStringGrid) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'String Grid,';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TStringGrid(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
          TStringGrid(Components[j]).OnEnter;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
          TStringGrid(Components[j]).OnKeyPress;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyDown :=
          TStringGrid(Components[j]).OnKeyDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyUp :=
          TStringGrid(Components[j]).OnKeyUp;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
          TStringGrid(Components[j]).OnMouseDown;

        TStringGrid(Components[j]).OnKeyPress := @sak.SAKKeyPress;
        TStringGrid(Components[j]).OnEnter := @sak.SAKEnter;
        TStringGrid(Components[j]).OnKeyDown := @sak.SAKKeyDown;
        TStringGrid(Components[j]).OnKeyUp := @sak.SAKKeyUp;
        TStringGrid(Components[j]).OnMouseDown := @sak.SAKMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          TStringGrid(Components[j]).OnMouseMove;
        TStringGrid(Components[j]).OnMouseMove := @sak.SAKMouseMove;
      end
      else
      if (Components[j] is TMemo) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Memo,';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TMemo(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
          TMemo(Components[j]).OnEnter;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
          TMemo(Components[j]).OnKeyPress;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyDown :=
          TMemo(Components[j]).OnKeyDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
          TMemo(Components[j]).OnMouseDown;
        TMemo(Components[j]).OnKeyPress := @sak.SAKKeyPress;
        TMemo(Components[j]).OnEnter := @sak.SAKEnter;
        TMemo(Components[j]).OnKeyDown := @sak.SAKKeyDown;
        TMemo(Components[j]).OnMouseDown := @sak.SAKMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          TMemo(Components[j]).OnMouseMove;
        TMemo(Components[j]).OnMouseMove := @sak.SAKMouseMove;
      end
      else
      if (Components[j] is TEdit) then
      begin
        SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

        sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
          TSAK_IAssistive.Create();

        sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
          'Edit,';
        sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
          TEdit(Components[j]);
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
          TEdit(Components[j]).OnEnter;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
          TEdit(Components[j]).OnKeyPress;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyDown :=
          TEdit(Components[j]).OnKeyDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
          TEdit(Components[j]).OnMouseDown;

        TEdit(Components[j]).OnKeyPress := @sak.SAKKeyPress;
        TEdit(Components[j]).OnEnter := @sak.SAKEnter;
        TEdit(Components[j]).OnKeyDown := @sak.SAKKeyDown;
        TEdit(Components[j]).OnMouseDown := @sak.SAKMouseDown;
        sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          TEdit(Components[j]).OnMouseMove;
        TEdit(Components[j]).OnMouseMove := @sak.SAKMouseMove;
      end
      else
      if (Components[j] is TComponent) then
      begin

        begin
          UpdateChild(Components[j]);
        end;

      end;

    end;

end;

procedure TSak.ChildComponentCount(AComponent: TComponent);
var
  i: integer;
begin
  f := f + AComponent.ComponentCount;
  for i := 0 to AComponent.ComponentCount - 1 do
    if AComponent.Components[i].ComponentCount > 0 then
      ChildComponentCount(AComponent.Components[i]);
end;



function TSak.WhatName(Sender: TObject): string;
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

procedure TSAK.SAKDestroy(Sender: TObject);
var
  i: integer;
begin
  isenabled := False;
  timercount.Enabled := False;
  unLoadLib;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnDestroy <> nil) then
    begin
      sak.AssistiveData[i].OriOnDestroy(Sender);
      exit;
    end;
  end;
  timercount.Enabled := True;
  isenabled := True;
end;

procedure TSAK.SAKClick(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckRepeatClick;
  TimerRepeat.Interval := 500;
  CheckObject := Sender;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnClick <> nil) then
    begin
      sak.AssistiveData[i].OriOnClick(Sender);
      finded := True;
    end;
    Inc(i);
  end;
end;

procedure TSAK.CheckRepeatClick(Sender: TObject);
var
  texttmp, nameobj: string;
  i: integer;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) then
    begin
      espeak_cancel;

      mouseclicked := True;

      nameobj := whatname(CheckObject);

      texttmp := sak.AssistiveData[i].Description + ' ' + nameobj + ' executed';

      espeak_Key(texttmp);
      exit;
    end;
  end;
end;

procedure TSAK.SAKChange(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckRepeatChange;
  TimerRepeat.Interval := 500;
  CheckObject := Sender;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnChange <> nil) then
    begin
      sak.AssistiveData[i].OriOnChange(Sender);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.SAKMenuChange(Sender: TObject; item: Tmenuitem; User: boolean);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckRepeatMenuChange;
  TimerRepeat.Interval := 300;
  CheckObject := Sender;
  menuitem := item;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnMenuChange <> nil) then
    begin
      sak.AssistiveData[i].OriOnMenuChange(Sender, item, user);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckRepeatMenuChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
  user: boolean;
begin
  user := False;
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) and (CheckObject is TMainMenu) and (menuitem is Tmenuitem) then
    begin
      with menuitem as Tmenuitem do
        texttmp := Caption + ' selected';
      espeak_Key(texttmp);

      exit;
    end;
  end;
end;

procedure TSAK.SAKSelectionChange(Sender: TObject; User: boolean);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckRepeatSelectionChange;
  TimerRepeat.Interval := 500;
  CheckObject := Sender;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnSelectionChange <> nil) then
    begin
      sak.AssistiveData[i].OriOnSelectionChange(Sender, user);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckActive(Sender: TObject; thecontrol: Tcontrol);
var
  i: integer;
  texttmp: string;
  user: boolean;
begin
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (thecontrol = sak.AssistiveData[i].TheObject) and (thecontrol is TStringgrid) then
    begin
      with thecontrol as TStringgrid do
        texttmp := 'Grid ' + Name + ' selected';
      espeak_Key(texttmp);
      exit;
    end;

    if (thecontrol = sak.AssistiveData[i].TheObject) and (thecontrol is TColorButton) then
    begin
      with thecontrol as TColorButton do
        texttmp := Caption + ' selected';
      espeak_Key(texttmp);
      exit;
    end;
  end;
end;

procedure TSAK.CheckRepeatSelectionChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
  user: boolean;
begin
  user := False;
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) and (CheckObject is TListBox) then
    begin
      with CheckObject as TListBox do
        texttmp := GetSelectedText + ' selected';
      espeak_Key(texttmp);
      exit;
    end;
  end;
end;

procedure TSAK.SAKSelectionChangeDialog(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckRepeatDialog;
  TimerRepeat.Interval := 500;
  CheckObject := Sender;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnSelectionChangeDialog <> nil) then
    begin
      sak.AssistiveData[i].OriOnSelectionChangeDialog(Sender);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckRepeatDialog(Sender: TObject);
var
  i, x: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
  x := 0;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) then
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
        espeak_Key(texttmp);

        exit;
      end;
    end;
  end;
end;

procedure TSAK.CheckRepeatChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) then
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

      espeak_Key(texttmp);

      exit;
    end;
  end;
end;

procedure TSAK.SAKMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  /// usefull ?
end;

procedure TSAK.SAKMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  /// usefull ?
end;

procedure TSAK.SAKMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckRepeatMouseMove;
  TimerRepeat.Interval := 600;
  CheckObject := Sender;
  CheckXPoint := x;
  CheckYPoint := y;
  CheckShift := Shift;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnMouseMove <> nil) then
    begin
      sak.AssistiveData[i].OriOnMouseMove(Sender, shift, x, y);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckRepeatMouseMove(Sender: TObject);
var
  texttmp, stringtemp, nameobj: string;
  i: integer;
begin
  if (mouseclicked = False) and (whatname(CheckObject) <> lastfocused) then
  begin
    TimerRepeat.Enabled := False;
    for i := 0 to (Length(sak.AssistiveData) - 1) do
    begin
      if (CheckObject = sak.AssistiveData[i].TheObject) then
      begin
        espeak_cancel;
        if CheckObject is TForm then
        begin
          lastfocused := ' ';
          //  texttmp := 'Left,  ' + IntToStr(CheckXPoint) + ' , of,  ' + IntToStr(TForm(CheckObject).Width) +
          //     '.   Top,  ' + IntToStr(CheckYPoint) + ' , of, ' + IntToStr(TForm(CheckObject).Height);
          //   espeak_Key(texttmp);
        end
        else
        begin
          nameobj := whatname(CheckObject);
          lastfocused := nameobj;

          stringtemp := '';

          if (CheckObject is tcheckbox) then
          begin
            if tcheckbox(CheckObject).Checked = False then
              stringtemp := ' , false, '
            else
              stringtemp := ' , true, ';
          end;

          if (CheckObject is tradiobutton) then
          begin
            if tradiobutton(CheckObject).Checked = False then
              stringtemp := ' , false, '
            else
              stringtemp := ' , true, ';
          end;

          if (CheckObject is ttrackbar) then
          begin
            stringtemp := ' , ' + IntToStr(ttrackbar(CheckObject).Position) + ' , ';
          end;

          texttmp := sak.AssistiveData[i].Description + ' ' + nameobj + stringtemp + ' focused';
          espeak_Key(texttmp);
        end;
        exit;
      end;
    end;
  end;
end;

procedure TSAK.SAKEnter(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckRepeatEnter;
  TimerRepeat.Interval := 600;
  CheckObject := Sender;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnEnter <> nil) then
    begin
      sak.AssistiveData[i].OriOnEnter(Sender);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckRepeatEnter(Sender: TObject);
var
  texttmp, nameobj: string;
  i: integer;
begin
  if mouseclicked = False then
  begin
    TimerRepeat.Enabled := False;
    for i := 0 to (Length(sak.AssistiveData) - 1) do
    begin
      if (CheckObject = sak.AssistiveData[i].TheObject) then
      begin
        nameobj := whatname(CheckObject);
        texttmp := sak.AssistiveData[i].Description + ' ' + nameobj + ' selected';
        espeak_Key(texttmp);
        exit;
      end;
    end;
  end;
  mouseclicked := False;
end;

procedure TSAK.SAKKeyPress(Sender: TObject; var Key: char);
var
  i: integer = 0;
  finded: boolean = False;
  oldlang  : string;
  oldgender, oldspeed, oldpitch, oldvolume : integer;
begin
  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckRepeatKeyPress;
  TimerRepeat.Interval := 300;
  CheckObject := Sender;
  CheckKeyChar := Key;
  
   if (CheckObject is TMemo) or (CheckObject is Tedit) then
   begin

  oldlang := voice_language;
      if voice_gender = '' then
    oldgender := -1 else
     if voice_gender = 'm3' then
    oldgender := 1 else
     oldgender := 2 ;
  oldspeed := voice_speed;
  oldpitch := voice_pitch;
  oldvolume := voice_volume;
   if CheckKeyChar = ' ' then
   begin
   SAKSetVoice(2,'',150,-1,-1);
   espeak_Key(Theword) ;
   TheSentence := TheSentence + ' ' + TheWord;
   Theword := '';
   SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
   end else
   if (CheckKeyChar = '.') or (CheckKeyChar = '?') or (CheckKeyChar = '!') then
   begin
   SAKSetVoice(2,'',150,-1,-1);
   espeak_Key( Theword + ', ' + TheSentence + ' ' + Theword) ;
   SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
   TheLastSentence := TheSentence + ' ' + Theword ;
   TheSentence := '';
   Theword := '';
   end else
    begin
    TimerRepeat.Interval := 1 ;
   Theword := Theword + CheckKeyChar;
   TimerRepeat.Enabled := True;
   end;

   end
   else
   begin
   TimerRepeat.Interval := 400;
   TimerRepeat.Enabled := True;
   end;


  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnKeyPress <> nil) then
    begin
      sak.AssistiveData[i].OriOnKeyPress(Sender, key);
      finded := True;
    end;
    Inc(i);
  end;
end;

procedure TSAK.CheckRepeatKeyPress(Sender: TObject);
var
  tempstr: string;
  i: integer;
begin
  TimerRepeat.Enabled := False;
  tempstr := CheckKeyChar;
  tempstr := trim(tempstr);
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) then
    begin

      tempstr := CheckKeyChar;
      tempstr := trim(tempstr);

      if tempstr <> '' then
        espeak_Key(tempstr);

      exit;
    end;
  end;
end;

procedure TSAK.SAKKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckKeyUp;
  TimerRepeat.Interval := 600;
  TimerRepeat.Enabled := False;
  CheckObject := Sender;
  CheckKey := Key;
  CheckShift := Shift;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnKeyUp <> nil) then
    begin
      sak.AssistiveData[i].OriOnKeyUp(Sender, key, shift);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckKeyUp(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) then
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

          espeak_Key(texttmp);
        end;

      exit;
    end;
  end;

end;

procedure TSAK.SAKKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  i: integer;
 oldlang : string;
 oldgender, oldspeed, oldpitch, oldvolume : integer;
begin
 
  for i := 0 to high(sak.AssistiveData) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) then
    begin

 oldlang := voice_language;
      if voice_gender = '' then
    oldgender := -1 else
     if voice_gender = 'm3' then
    oldgender := 1 else
     oldgender := 2 ;
  oldspeed := voice_speed;
  oldpitch := voice_pitch;
  oldvolume := voice_volume;

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
          120:  if (CheckObject is TMemo) then
                    begin
                SAKSetVoice(2,'',165,-1,-1);
                espeak_Key(thelastsentence) ;
                SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
              end
                  else
          espeak_Key('f, 9');

          121: if (CheckObject is TMemo) then
                    begin
                SAKSetVoice(2,'',165,-1,-1);
                espeak_Key(theword) ;
                SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
              end
                  else espeak_Key('f, 10');
          122:  if (CheckObject is TMemo) then
                 begin
                SAKSetVoice(2,'',165,-1,-1);
                espeak_Key(thesentence) ;
                SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
              end
                  else espeak_Key('f, 11') ;
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
               begin
                SAKSetVoice(2,'',165,-1,-1);
                espeak_Key(Text) ;
                SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
              end
            else
            if (Sender is tedit) then
              with Sender as tedit do
              begin
                SAKSetVoice(2,'',165,-1,-1);
                espeak_Key(Text) ;
                SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
              end
            else
              espeak_Key('f 12');
        end;

        if sak.AssistiveData[i].OriOnKeyDown <> nil then
          sak.AssistiveData[i].OriOnKeyDown(Sender, Key, Shift);
        exit;
      end;
    end;
  end;
end;

////////////////////// Loading Procedure

/// Load with custom espeak dir
function SAKLoadLib(const eSpeakBin: string; const eSpeaklib: string; const PortaudioLib: string;
                                      const eSpeakDataDir: string ): integer;
begin
Result := -1;
 if sak = nil then sak:= TSAK.Create;

 if (espeakdatadir = '') or directoryexists(eSpeakDataDir) then begin
  Result:= 0;
  sak.ES_DataDirectory:= eSpeakDataDir;
 end;
 sak.ES_ExeFileName:= eSpeakBin;
 sak.ES_LibFileName:= eSpeaklib;
 sak.PA_LibFileName:= PortaudioLib;

  Result:= sak.loadlib;
 if result <> 0 then freeandnil(sak);
end;

function SAKLoadLib(const sakitdir: string = ''): integer;
var
 ordir, sakini, espeakbin, espeaklib, portaudiolib, espeakdatadir, tmp: string;
const
 sakininame = 'sak.ini';

{$ifdef mswindows}
 espeaklibdir = 'libwin32';
 espeakdefault = 'espeak.exe';
{$else}
 espeakdefault = 'espeak';
{$endif}


{$if defined(linux) and  defined(cpu64)}
 espeaklibdir = 'liblinux64';
{$endif}
{$if defined(linux) and defined(cpu86) }
 espeaklibdir = 'liblinux32';
{$endif}
{$if defined(freebsd) and  defined(cpu64)}
 espeaklibdir = 'libfreebsd64';
{$endif}
{$if defined(freebsd) and defined(cpu86) } 
 espeaklibdir = 'libfreebsd32';
 {$endif}
{$ifdef darwin}
 espeaklibdir = 'libmac32';
{$endif}

begin
 Result := -1;
 espeakdatadir:= '';
 if sakitdir = '' then begin
  ordir:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 end
 else begin
  ordir:= sakitdir;
 end;

 sakini:= ordir + sakininame;
 espeakbin:= ordir + WhatFile(sakini,0);

 tmp := WhatFile(sakini,1);
 if tmp <> '' then
 portaudiolib:= ordir + tmp else  portaudiolib:= '';

 espeaklib:= ordir + WhatFile(sakini,2);

 tmp := WhatFile(sakini,2);
 if tmp <> '' then
 espeaklib:= ordir + tmp else  espeaklib:= '';

tmp := WhatFile(sakini,3);
 if (tmp = '/') or (tmp = './') then
 espeakdatadir:= ordir else 
if tmp = '../' then
 espeakdatadir:= ExtractFilePath(ordir)
else 
 espeakdatadir:= tmp ;


  if (directoryexists(espeakdatadir)) and (fileexists(espeakbin)) and (fileexists(sakini)) and ((fileexists(portaudiolib)) or (portaudiolib = ''))
 and ((fileexists(espeaklib)) or (espeaklib = ''))
 then
  begin
   Result:= 0;
   espeakdatadir:= ordir ;
   {$ifdef unix}
 result := ChangePermission(espeakbin,true);
   {$endif}
  end
 else begin
  sakini:= ordir +  directoryseparator +'sakit' + directoryseparator +
  espeaklibdir + directoryseparator + sakininame;

  espeakbin:= ordir + directoryseparator + 'sakit' + directoryseparator +
  espeaklibdir+ directoryseparator + WhatFile(sakini, 0);

  tmp := WhatFile(sakini,1);
 if tmp <> '' then
  portaudiolib:= ordir + directoryseparator + 'sakit' + directoryseparator +
  espeaklibdir+ directoryseparator + tmp else  portaudiolib:= '';

 tmp := WhatFile(sakini,2);
 if tmp <> '' then
 espeaklib:= ordir + directoryseparator + 'sakit' + directoryseparator +
  espeaklibdir+ directoryseparator + tmp else  espeaklib:= '';

 tmp := WhatFile(sakini,3);
 if (tmp = '/') or (tmp = './') then
 espeakdatadir:= ordir + directoryseparator + 'sakit' + directoryseparator +
  espeaklibdir+ directoryseparator else 
if tmp = '../' then
 espeakdatadir:= ordir + directoryseparator + 'sakit' + directoryseparator
else 
 espeakdatadir:= tmp ;

     if (directoryexists(espeakdatadir)) and (fileexists(espeakbin)) and (fileexists(sakini)) and ((fileexists(portaudiolib)) or (portaudiolib = ''))
   and ((fileexists(espeaklib)) or (espeaklib = ''))   then
 begin
    Result:= 0;
     {$ifdef unix}
  result := ChangePermission(espeakbin,true);
    {$endif}
   end
  else begin
{$ifdef unix}
  if (fileexists('/usr/bin/'+espeakdefault)) then begin
  espeakbin:= '/usr/bin/'+espeakdefault;
 result := 0;
end else
 if
 (fileexists('/usr/local/bin/'+espeakdefault)) then
begin
  espeakbin:= '/usr/local/bin/'+espeakdefault;
result := 0;
end;
 {$endif}

{$ifdef windows}
  if (fileexists('c:\Program Files (x86)\eSpeak\command_line\'+espeakdefault)) then
begin
  espeakbin:= 'c:\Program Files (x86)\eSpeak\command_line\'+espeakdefault;
 result := 0;
end else
 if
 (fileexists('c:\Program Files\eSpeak\command_line\'+espeakdefault)) then
begin
  espeakbin:= 'c:\Program Files\eSpeak\command_line\'+espeakdefault;
result := 0;
end;
 {$endif}

espeakdatadir:= '';
portaudiolib:= '' ;

end;
 end;

 if result = 0 then begin
  result:= sakloadlib(espeakbin,espeaklib,portaudiolib,espeakdatadir);
 end;
end;


procedure TSAK.InitObject;
var
  i, h: integer;
begin
  mouseclicked := False;
  SetLength(sak.AssistiveData, 0);

  for h := 0 to application.ComponentCount - 1 do  ///

  begin
    SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);
    sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
      TSAK_IAssistive.Create();
    sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
      'Form';
    sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
      TForm(application.Components[h]);
    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
      TForm(application.Components[h]).OnKeyPress;
    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyDown :=
      TForm(application.Components[h]).OnKeyDown;
    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
      TForm(application.Components[h]).OnEnter;
    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
      TForm(application.Components[h]).OnMouseDown;
    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnDestroy :=
      TForm(application.Components[h]).OnDestroy;
    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
      TForm(application.Components[h]).OnMouseMove;

    TForm(application.Components[h]).OnKeyPress := @sak.SAKKeyPress;
    TForm(application.Components[h]).OnKeyDown := @sak.SAKKeyDown;
    TForm(application.Components[h]).OnEnter := @sak.SAKEnter;
    TForm(application.Components[h]).OnMouseDown := @sak.SAKMouseDown;
    TForm(application.Components[h]).OnDestroy := @sak.SAKDestroy;
    TForm(application.Components[h]).OnMouseMove := @sak.SAKMouseMove;


    //  with (application.Components[h]) as TForm do

    for i := 0 to application.Components[h].ComponentCount - 1 do

    begin
      if (application.Components[h].Components[i] is TComponent) then
      begin

        if (application.Components[h].Components[i] is TMenuItem) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Menu Item';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
            TMenuItem(application.Components[h].Components[i]).OnClick;

          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TMenuItem(application.Components[h].Components[i]);
          TMenuItem(application.Components[h].Components[i]).OnClick := @sak.SAKClick;
        end
        else

        if (application.Components[h].Components[i] is TMainMenu) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Main Menu';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TMainMenu(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMenuChange :=
            TMainMenu(application.Components[h].Components[i]).OnChange;
          TMainMenu(application.Components[h].Components[i]).OnChange := @sak.SAKMenuChange;
        end
        else

        if (application.Components[h].Components[i] is TTrackBar) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Track bar';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TTrackBar(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
            TTrackBar(application.Components[h].Components[i]).OnEnter;
          TTrackBar(application.Components[h].Components[i]).OnEnter := @sak.SAKEnter;

          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
            TTrackBar(application.Components[h].Components[i]).OnChange;
          TTrackBar(application.Components[h].Components[i]).OnChange := @sak.SAKChange;
        end
        else
        if (application.Components[h].Components[i] is TLabel) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Label,';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TLabel(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
            TLabel(application.Components[h].Components[i]).OnClick;
          TLabel(application.Components[h].Components[i]).OnClick := @sak.SAKClick;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
            TLabel(application.Components[h].Components[i]).OnMouseMove;
          TLabel(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;
        end
        else
        if (application.Components[h].Components[i] is TButton) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Button,';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TButton(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
            TButton(application.Components[h].Components[i]).OnEnter;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyDown :=
            TButton(application.Components[h].Components[i]).OnKeyDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
            TButton(application.Components[h].Components[i]).OnClick;

          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
            TButton(application.Components[h].Components[i]).OnMouseMove;
          TButton(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;

          TButton(application.Components[h].Components[i]).OnEnter := @sak.SAKEnter;
          TButton(application.Components[h].Components[i]).OnKeyDown := @sak.SAKKeyDown;
          TButton(application.Components[h].Components[i]).OnClick := @sak.SAKClick;
        end
        else
        if (application.Components[h].Components[i] is TColorButton) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();


          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Color Button,';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TColorButton(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
            TColorButton(application.Components[h].Components[i]).OnClick;
          TColorButton(application.Components[h].Components[i]).OnClick := @sak.SAKClick;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
            TColorButton(application.Components[h].Components[i]).OnMouseMove;
          TColorButton(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;
        end
        else
        if (application.Components[h].Components[i] is TSaveDialog) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Save Dialog';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TSaveDialog(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnSelectionChangeDialog :=
            TSaveDialog(application.Components[h].Components[i]).OnSelectionChange;
          TSaveDialog(application.Components[h].Components[i]).OnSelectionChange := @sak.SAKSelectionChangeDialog;
          //          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          //        TSaveDialog(application.Components[h].Components[i]).OnMouseMove;
          //      TSaveDialog(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;

        end
        else
        if (application.Components[h].Components[i] is TOpenDialog) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Open Dialog';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TOpenDialog(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnSelectionChangeDialog :=
            TOpenDialog(application.Components[h].Components[i]).OnSelectionChange;
          TOpenDialog(application.Components[h].Components[i]).OnSelectionChange := @sak.SAKSelectionChangeDialog;
          //     sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
          //    TOpenDialog(application.Components[h].Components[i]).OnMouseMove;
          //  TOpenDialog(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;
        end
        else
        if (application.Components[h].Components[i] is TListBox) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'List Box,';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TListBox(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
            TListBox(application.Components[h].Components[i]).OnEnter;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
            TListBox(application.Components[h].Components[i]).OnMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnSelectionChange :=
            TListBox(application.Components[h].Components[i]).OnSelectionChange;

          TListBox(application.Components[h].Components[i]).OnEnter := @sak.SAKEnter;
          ;
          TListBox(application.Components[h].Components[i]).OnSelectionChange := @sak.SAKSelectionChange;
          TListBox(application.Components[h].Components[i]).OnMouseDown := @sak.SAKMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
            TListBox(application.Components[h].Components[i]).OnMouseMove;
          TListBox(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;
        end
        else
        if (application.Components[h].Components[i] is TRadioButton) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Radio Button,';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TRadioButton(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
            TRadioButton(application.Components[h].Components[i]).OnEnter;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
            TRadioButton(application.Components[h].Components[i]).OnMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
            TRadioButton(application.Components[h].Components[i]).OnChange;

          TRadioButton(application.Components[h].Components[i]).OnEnter := @sak.SAKEnter;
          TRadioButton(application.Components[h].Components[i]).OnChange := @sak.SAKChange;
          TRadioButton(application.Components[h].Components[i]).OnMouseDown := @sak.SAKMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
            TRadioButton(application.Components[h].Components[i]).OnMouseMove;
          TRadioButton(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;
        end
        else
        if (application.Components[h].Components[i] is TComboBox) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Combo Box,';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TComboBox(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
            TComboBox(application.Components[h].Components[i]).OnEnter;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
            TComboBox(application.Components[h].Components[i]).OnMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
            TComboBox(application.Components[h].Components[i]).OnChange;

          TComboBox(application.Components[h].Components[i]).OnEnter := @sak.SAKEnter;
          TComboBox(application.Components[h].Components[i]).OnChange := @sak.SAKChange;
          TComboBox(application.Components[h].Components[i]).OnMouseDown := @sak.SAKMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
            TComboBox(application.Components[h].Components[i]).OnMouseMove;
          TComboBox(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;
        end
        else
        if (application.Components[h].Components[i] is TCheckBox) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Check Box,';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TCheckBox(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
            TCheckBox(application.Components[h].Components[i]).OnEnter;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
            TCheckBox(application.Components[h].Components[i]).OnMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
            TCheckBox(application.Components[h].Components[i]).OnChange;
          TCheckBox(application.Components[h].Components[i]).OnEnter := @sak.SAKEnter;
          TCheckBox(application.Components[h].Components[i]).OnChange := @sak.SAKChange;
          TCheckBox(application.Components[h].Components[i]).OnMouseDown := @sak.SAKMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
            TCheckBox(application.Components[h].Components[i]).OnMouseMove;
          TCheckBox(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;
        end
        else
        if (application.Components[h].Components[i] is TStringGrid) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'String Grid,';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TStringGrid(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
            TStringGrid(application.Components[h].Components[i]).OnEnter;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
            TStringGrid(application.Components[h].Components[i]).OnKeyPress;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyDown :=
            TStringGrid(application.Components[h].Components[i]).OnKeyDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyUp :=
            TStringGrid(application.Components[h].Components[i]).OnKeyUp;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
            TStringGrid(application.Components[h].Components[i]).OnMouseDown;

          TStringGrid(application.Components[h].Components[i]).OnKeyPress := @sak.SAKKeyPress;
          TStringGrid(application.Components[h].Components[i]).OnEnter := @sak.SAKEnter;
          TStringGrid(application.Components[h].Components[i]).OnKeyDown := @sak.SAKKeyDown;
          TStringGrid(application.Components[h].Components[i]).OnKeyUp := @sak.SAKKeyUp;
          TStringGrid(application.Components[h].Components[i]).OnMouseDown := @sak.SAKMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
            TStringGrid(application.Components[h].Components[i]).OnMouseMove;
          TStringGrid(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;
        end
        else
        if (application.Components[h].Components[i] is TMemo) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Memo,';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TMemo(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
            TMemo(application.Components[h].Components[i]).OnEnter;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
            TMemo(application.Components[h].Components[i]).OnKeyPress;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyDown :=
            TMemo(application.Components[h].Components[i]).OnKeyDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
            TMemo(application.Components[h].Components[i]).OnMouseDown;
          TMemo(application.Components[h].Components[i]).OnKeyPress := @sak.SAKKeyPress;
          TMemo(application.Components[h].Components[i]).OnEnter := @sak.SAKEnter;
          TMemo(application.Components[h].Components[i]).OnKeyDown := @sak.SAKKeyDown;
          TMemo(application.Components[h].Components[i]).OnMouseDown := @sak.SAKMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
            TMemo(application.Components[h].Components[i]).OnMouseMove;
          TMemo(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;
        end
        else
        if (application.Components[h].Components[i] is TEdit) then
        begin
          SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

          sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
            TSAK_IAssistive.Create();

          sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
            'Edit,';
          sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
            TEdit(application.Components[h].Components[i]);
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
            TEdit(application.Components[h].Components[i]).OnEnter;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
            TEdit(application.Components[h].Components[i]).OnKeyPress;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyDown :=
            TEdit(application.Components[h].Components[i]).OnKeyDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
            TEdit(application.Components[h].Components[i]).OnMouseDown;

          TEdit(application.Components[h].Components[i]).OnKeyPress := @sak.SAKKeyPress;
          TEdit(application.Components[h].Components[i]).OnEnter := @sak.SAKEnter;
          TEdit(application.Components[h].Components[i]).OnKeyDown := @sak.SAKKeyDown;
          TEdit(application.Components[h].Components[i]).OnMouseDown := @sak.SAKMouseDown;
          sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
            TEdit(application.Components[h].Components[i]).OnMouseMove;
          TEdit(application.Components[h].Components[i]).OnMouseMove := @sak.SAKMouseMove;
        end
        else
        if (application.Components[h].Components[i] is TComponent) then
        begin

          begin
            UpdateChild(application.Components[h].Components[i]);
          end;

        end;

      end;

    end;

  end;

end;

procedure TSAK.CheckCount(Sender: TObject);
begin
  timercount.Enabled := False;

  if (isenabled = True) then
  begin
    f := 0;
    ChildComponentCount(Application);
    if (f <> CompCount) then
    begin
      saksuspend;
      sakupdate;
      CompCount := f;
    end;
    timercount.Enabled := True;
  end;

end;

///////////////// loading sak

function WhatFile(sakini : string; what : integer) : string;
///// to find the file in sak.ini (what => 0 = espeak bin, 1 = portaudio lib, 2 = espeak lib)
var
tf: textfile;
ffinded : boolean ;
dataf, whatfil : string;
len : integer;
begin
ffinded := false;
result := '';

//writeln( 'sakini is ' + sakini);

if fileexists(sakini) then
begin
  AssignFile(tf,pchar(sakini));
   Reset(tF);

   case what of
    0: whatfil := 'BINESPEAK=';
    1: whatfil := 'LIBPORTAUDIO=';
    2: whatfil := 'LIBESPEAK=';
    3: whatfil := 'DIRESPEAKDATA=';
     end;

   len := length(whatfil);

   while (eof(tf) = false) and (ffinded = false) do
     begin
       Readln(tF, dataf);
    dataf := trim(dataf);

    if  Pos(whatfil,dataf) > 0 then
   begin
    if  Pos('#',dataf) > 0 then  dataf := trim(copy(dataf,1, Pos('#',dataf)-1));
     result := copy(dataf,Pos(whatfil,dataf)+ len , length(dataf)-len);
  //  writeln( 'Result is ' +  dataf);
    ffinded := true;
   end;
     end;
  CloseFile(tf);
end;

end;

 {$IF DEFINED(unix)}
function ChangePermission(thefile : string; raisemessage : boolean = true) : integer ;
var
info : stat;
themess : string;
//adialog: TDialog;
begin
  result := 0;
 if (FpStat(thefile,info{%H-})<>-1) and FPS_ISREG(info.st_mode) and
             (BaseUnix.FpAccess(thefile,BaseUnix.X_OK)=0) then else
 begin
  if raisemessage = true then
  begin
     themess :=  'Permission mode of file:' + #13 +
                  thefile +  #13 +
                  'is not set as executable...' + #13 +
                 'Do you want to reset it?';
if MessageDlg(themess, mtWarning,  mbYesNo, 0) = mrYes then
       begin
     fpchmod(thefile, S_IRWXU);
   end else result := -1;

end else result := -1;
end;
end;
 {$endif}

function TSAK.LoadLib: integer;

begin
  Result := 0;
  if isenabled = False then
  begin
    old8087cw := Get8087CW;
    isenabled := False;
    SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
    Set8087CW($133f);

    Screen.AddHandlerActiveControlChanged(@CheckActive);
    // Screen.AddHandlerFormAdded(@CheckCount);
    //  Screen.AddHandlerRemoveForm(@CheckCount);
    TimerRepeat := Ttimer.Create(TimerRepeat);
    TimerCount := Ttimer.Create(TimerCount);

  AProcess := TProcess.Create(nil);
  AProcess.Options := AProcess.Options + [poNoConsole, poUsePipes];
  AProcess.FreeOnRelease;

//  writeln('ES_LibFileName => ' + ES_LibFileName);
{$ifdef unix}
  if trim(ES_LibFileName) <> '' then
begin
 AProcess.Environment.Text := 'LD_LIBRARY_PATH=' + ExtractFilePath(ES_LibFileName) ;
if trim(PA_LibFileName) <> '' then
   AProcess.Environment.Text := AProcess.Environment.Text + ':' + ExtractFilePath(PA_LibFileName)

end  else
  if trim(PA_LibFileName) <> '' then
   AProcess.Environment.Text := 'LD_PRELOAD=' + PA_LibFileName ;
{$endif}

   AProcess.Executable :=  ES_ExeFileName;

   TheWord := '' ;
  TheSentence := '' ;
  TheLastSentence := '' ;

  voice_gender := '' ;
  voice_language := '' ;
  voice_speed := -1 ;
  voice_pitch := -1 ;
  voice_volume := -1 ;

    espeak_Key('sak is working...');

    f := 0;
    ChildComponentCount(Application);
    CompCount := f;
    InitObject;
    TimerRepeat.Enabled := False;
    TimerRepeat.Interval := 600;
    TimerCount.Interval := 700;
    TimerCount.OnTimer := @CheckCount;
    TimerCount.Enabled := True;
    isenabled := True;
    Result := 0;
  end;
end;

function SAKUnLoadLib: integer;
var
  i: integer;
begin
  Result := -1;
  isenabled := False;
  if assigned(sak) then
  begin
    Result := 0;
    
    sak.UnLoadLib;
    sleep(100);

    FreeAndNil(sak.TimerRepeat);
    FreeAndNil(sak.TimerCount);
    FreeAndNil(sak.aprocess);

    for i := 0 to high(sak.AssistiveData) do
      sak.AssistiveData[i].Free;
    Set8087CW(sak.old8087cw);
    FreeAndNil(sak);
    Result := 0;
  end;

end;

function TSAK.UnLoadLib: integer;
var
  i: integer;
begin
  Result := -1;
  if assigned(sak) then
  begin
    espeak_cancel;

    TimerCount.Enabled := False;

    // Screen.RemoveHandlerFormAdded(@CheckCount);
    //  Screen.RemoveHandlerRemoveForm(@CheckCount);
    Screen.RemoveHandlerActiveControlChanged(@CheckActive);

    for i := 0 to high(sak.AssistiveData) do
    begin
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TMainMenu) then
      begin
        TMainMenu(sak.AssistiveData[i].TheObject).OnChange :=
          sak.AssistiveData[i].OriOnMenuChange;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TMenuItem) then
      begin
        TMenuItem(sak.AssistiveData[i].TheObject).OnClick :=
          sak.AssistiveData[i].OriOnClick;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TForm) then
      begin
        TForm(sak.AssistiveData[i].TheObject).OnKeyPress :=
          sak.AssistiveData[i].OriOnKeyPress;
        TForm(sak.AssistiveData[i].TheObject).OnKeyDown :=
          sak.AssistiveData[i].OriOnKeyDown;
        TForm(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].oriOnEnter;
        TForm(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TForm(sak.AssistiveData[i].TheObject).OnDestroy :=
          sak.AssistiveData[i].OriOnDestroy;
        TForm(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TLabel) then
      begin
        TLabel(sak.AssistiveData[i].TheObject).OnClick :=
          sak.AssistiveData[i].OriOnClick;
        TLabel(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TTrackBar) then
      begin
        TTrackBar(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TTrackBar(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TTrackBar(sak.AssistiveData[i].TheObject).OnChange :=
          sak.AssistiveData[i].OriOnChange;
        TTrackBar(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TCheckBox) then
      begin
        TCheckBox(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TCheckBox(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TCheckBox(sak.AssistiveData[i].TheObject).OnChange :=
          sak.AssistiveData[i].OriOnChange;
        TCheckBox(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TComboBox) then
      begin
        TComboBox(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TComboBox(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TComboBox(sak.AssistiveData[i].TheObject).OnChange :=
          sak.AssistiveData[i].OriOnChange;
        TComboBox(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TListBox) then
      begin
        TListBox(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TListBox(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TListBox(sak.AssistiveData[i].TheObject).OnSelectionChange :=
          sak.AssistiveData[i].OriOnSelectionChange;
        TListBox(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TRadioButton) then
      begin
        TRadioButton(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TRadioButton(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TRadioButton(sak.AssistiveData[i].TheObject).OnChange :=
          sak.AssistiveData[i].OriOnChange;
        TRadioButton(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TButton) then
      begin
        TButton(sak.AssistiveData[i].TheObject).OnKeyDown :=
          sak.AssistiveData[i].OriOnKeyDown;
        TButton(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TButton(sak.AssistiveData[i].TheObject).OnClick :=
          sak.AssistiveData[i].OriOnClick;
        TButton(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TEdit) then
      begin
        TEdit(sak.AssistiveData[i].TheObject).OnKeyPress :=
          sak.AssistiveData[i].OriOnKeyPress;
        TEdit(sak.AssistiveData[i].TheObject).OnKeyDown :=
          sak.AssistiveData[i].OriOnKeyDown;
        TEdit(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TEdit(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TEdit(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TMemo) then
      begin
        TMemo(sak.AssistiveData[i].TheObject).OnKeyPress :=
          sak.AssistiveData[i].OriOnKeyPress;
        TMemo(sak.AssistiveData[i].TheObject).OnKeyDown :=
          sak.AssistiveData[i].OriOnKeyDown;
        TMemo(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TMemo(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TMemo(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TStringgrid) then
      begin
        TStringgrid(sak.AssistiveData[i].TheObject).OnKeyPress :=
          sak.AssistiveData[i].OriOnKeyPress;
        TStringgrid(sak.AssistiveData[i].TheObject).OnKeyDown :=
          sak.AssistiveData[i].OriOnKeyDown;
        TStringgrid(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TStringgrid(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TStringgrid(sak.AssistiveData[i].TheObject).OnKeyUp :=
          sak.AssistiveData[i].OriOnKeyUp;
        TStringgrid(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].OriOnMouseMove;
      end;
    end;

    SetLength(sak.AssistiveData, 0);
    Result := 0;
  end;
end;

////////////////////// Voice Config Procedures ///////////////
function SAKSetVoice(gender: shortint; language: string ; speed: integer ; pitch: integer ; volume : integer ): integer;
// -gender : 1 = man, 2 = woman => defaut -1 (man)
//-language : is the language code => default '' (en) 
////  for example :'en' for english, 'fr' for french, 'pt' for Portugues, etc...
////           (check in /espeak-data if your language is there...)
//  -speed sets the speed in words-per-minute , Range 80 to 450. The default value is 175. => -1
// -pitch  range of 0 to 99. The default is 50.   => -1
// -volume range of 0 to 200. The default is 100. => -1
begin
   result := -1;
  if assigned(sak) then
  begin
   result := 0;
    if gender = -1 then
    sak.voice_gender := ''  else
   if gender = 1 then
    sak.voice_gender := 'm3'
  else
    sak.voice_gender := 'f2';
  sak.voice_language := language;
  sak.voice_speed := speed;
  sak.voice_volume := volume;
  sak.voice_pitch := pitch;
  end;
end;

////////////////////// Speecher Procedures ////////////////
procedure TSAK.espeak_key(Text: string);
var
 params: string = '';
begin

   AProcess.Parameters.clear;

 if (voice_gender <> '') or (voice_language <> '') then begin
  params:= params + '-v';
  if voice_language <> '' then begin
   params:= params+voice_language;
   if voice_gender <> '' then begin
    params:= params+'+'+voice_gender;
   end;
  end
  else begin
   if voice_gender <> '' then begin
    params:= params+voice_gender;
   end;
  end;
 end;

if  params <> '' then AProcess.Parameters.Add(params) ;

if voice_speed <> -1 then AProcess.Parameters.Add('-s' + inttostr(voice_speed)) ;
if voice_pitch <> -1 then AProcess.Parameters.Add('-p' + inttostr(voice_pitch)) ;
if voice_volume <> -1 then AProcess.Parameters.Add('-a' + inttostr(voice_volume)) ;

  if sak.es_datadirectory <> '' then
  AProcess.Parameters.Add('--path=' + sak.ES_DataDirectory);
  
  AProcess.Parameters.Add('"' + Text + '"');
  AProcess.Execute;

end;

//// cancel current speaker
function SAKCancel(): integer;
begin
  Result := -1;
  if assigned(sak) then
  begin
    sak.espeak_cancel;
    Result := 0;
  end;
end;

////// suspend/update procedures
procedure SAKSuspend();
begin
  if assigned(sak) then
    sak.UnLoadLib;
end;

procedure SAKUpdate();
begin
  if assigned(sak) then
  begin
    sak.initobject;
    sak.f := 0;
    sak.ChildComponentCount(Application);
    sak.CompCount := sak.f;
    sak.timercount.Enabled := True;
  end;
end;

function SAKSay(Text: string): integer;
begin
  Result := -1;
  if assigned(sak) then
  begin
    Result := 0;
    sak.espeak_Key(Text);
  end;
end;

procedure Tsak.espeak_cancel;
begin
  if assigned(AProcess) then
  begin
    AProcess.Terminate(0);
   // FreeAndNil(AProcess);
  end;
end;

///////////// Enabled procedure

function SakIsEnabled: boolean;
begin
  Result := isenabled;
end;

end.
