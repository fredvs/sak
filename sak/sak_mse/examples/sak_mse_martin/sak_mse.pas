unit sak_mse;

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
*  5 th release: 2015-06-04  (mse compatible)                                  *
*  4 th release: 2015-03-13  (sak_dll synchronized with sak)                   *
*  3 th release: 2015-03-04  (fpGUI focus)                                     *
*  2 th release: 2013-08-01  (use espeak executable)                           *
*  1 th release: 2013-06-15  (multi objects, multi forms)                      *
*******************************************************************************}
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

interface
uses
  msetypes, mseglob, mseguiglob, mseguiintf, mseapplication, msestat, msemenus, 
  msemenuwidgets, msegui,
  msegraphics, msegraphutils, mseevent, mseclasses, msewidgets, mseforms, 
  msetimer,mseassistiveserver,mseassistiveclient, msegrids, msestrings,
  msesimplewidgets,msedataedits, mseedit, msekeyboard, msefileutils,
  mseificomp, mseificompglob, mseifiglob, msestatfile, msestream, sysutils,
  mseact,
  msegraphedits, msescrollbar, msewidgetgrid, msetoolbar,msebitmap,mseshapes,
  math, classes, mseprocess,msesysintf,msesys
   {$IF DEFINED(unix)}
  , baseunix
       {$endif};
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
  speakdelay = 800000; //micro seconds
  
type
 esakerror = class(exception)
 end;
 
 speakkindty = (sk_none,sk_key,sk_any);
 
 TSAK = class(TObject, iassistiveserver)
  protected
   ES_ExeFileName: filenamety;
   ES_DataDirectory: filenamety;
  
    voice_language: ansistring;
    voice_gender: ansistring;
    voice_speed: integer;  //-s
    voice_pitch: integer;  //-p
    voice_volume: integer;  //-a

    TheWord: string;  //// use F11 key in memo
    TheSentence: string;   //// use F10 key in memo
    TheLastSentence: string;  //// use F10 key in memo

   fprocess: tmseprocess;
   ftimer: tsimpletimer;
   fspeaktext: msestring;
   fspeakkind: speakkindty;
   fspeakbuffer: msestringarty;
   fpendingspeak: speakkindty;
   procedure procfinished(const sender: tobject);
   
   procedure ondelayedspeak(const sender: tobject);
   function LoadLib: integer;
   procedure espeakcancel();
   procedure speaktext(const text: msestring);
   procedure waitforspeak();
   procedure espeak_key(const Text: msestring);
   procedure startdelay(const amethod: notifyeventty; const delayus: longword);
   procedure delayedspeak(const atext: msestring;
                       const aspeakkind: speakkindty = sk_any;
                                const delayus: longword = speakdelay);

    //iassistiveserver
   procedure doenter(const Sender: iassistiveclient);
   procedure clientmouseevent(const sender: iassistiveclient;
                                      const info: mouseeventinfoty);
   procedure dochange(const sender: iassistiveclient);   
   procedure dofocuschanged(const oldwidget, newwidget: iassistiveclient);
   procedure dokeydown(const Sender: iassistiveclient; 
                                              const info: keyeventinfoty);
   procedure doactionexecute(const Sender: TObject; const info: actioninfoty);
   procedure doitementer(const sender: iassistiveclient; //sender can be nil
                           const items: shapeinfoarty; const aindex: integer);
   procedure doitementer(const sender: iassistiveclient;
                        const items: menucellinfoarty; const aindex: integer);
   procedure docellevent(const sender: iassistiveclient; 
                                     const info: celleventinfoty);
  public
   constructor Create();
   destructor Destroy(); override;
  end;

/// Load with custom sakit dir
function SAKLoadLib(const SakitDir: filenamety = ''): integer;
                            //'' = default

/// Load with custom
function SAKLoadLib(const eSpeakBin: filenamety;
                                      const eSpeakDataDir: filenamety): integer;
 {$IF DEFINED(unix)}
function ChangePermission(const thefile: filenamety = ''; raisemessage : boolean = true) : integer ;
 {$endif}

function WhatSpeakBin(const espeakscript: filenamety = '') : string;

/// Unload sak 
function SAKUnloadLib: integer;

//// to know if sak is loaded
function SakIsEnabled: boolean;

////////////////////// Voice Config Procedures ///////////////
function SAKSetVoice(gender: shortint; language: string ; speed: integer ; pitch: integer ; volume : integer ): integer;
//// gender : 1 = man, 2 = woman.  The default => -1 (man)
//// language : is the language code, for example :
//// 'en' for english, 'fr' for french, 'pt' for Portugues, etc...
////           (check in /espeak-data if your language is there...)
//  speed sets the speed in words-per-minute , Range 80 to 450. The default value is 175. => -1
// pitch  range of 0 to 99. The default is 50.   => -1
// volume range of 0 to 200. The default is 100. => -1

///// Start speaking the text with default voice
function SAKSay(Text: string): integer;

// Cancel current speak.
function SakCancel: integer;

var
 sakusekeybuffer: boolean;
  
implementation
uses
 typinfo, mclasses, mseactions,msearrayutils,msegridsglob,mseformatstr,
 mseprocutils,msesystypes;
var
 sak: TSAK;
  
/////////////////////////// Capture Assistive Procedures

//here iassistiveclient.getvaluetext() would be more appropriate
//disadvantage: blows up msegui

function slidervalue(const sender: tcustomslider): msestring;
begin
 result:= inttostrmse(round(sender.value * 100)) + ' ,%' ;
end;

function booleaneditvalue(const sender: tcustombooleanedit): msestring;
begin
 if sender.value then begin
  result:= 'true';
 end
 else begin
  result:= 'false';
 end;
end;

function whatchange(sender: tobject) : string;
begin
 if (sender is tcustombooleanedit) then begin
  result:= ' changed to '+booleaneditvalue(tcustombooleanedit(sender));
 end
 else if (sender is tcustomslider) then begin
  result := ' changed position to ' + slidervalue(tcustomslider(sender));
 end;
end;

function WhatChar(Sender: TObject; const info: keyeventinfoty;
                                          out nowait: boolean): string;
var
  CheckKey: keyty;
begin
 nowait:= false;
 CheckKey:= info.key;
 Result:= info.chars;
 case CheckKey of
  key_Return: Result:= 'Enter';  
  key_Backspace: Result:= 'back space';
  key_Backtab: Result:= 'back tab';
  key_Up: Result:= 'up';
  key_down: Result := 'down';
  key_left: Result := 'left';
  key_right: Result := 'right';
  key_Tab: Result := 'tab'; 
  key_Space: Result:= 'space';
 
  key_F1: Result:= 'f, 1';
  key_F2: Result:= 'f, 2';
  key_F3: Result:= 'f, 3';
  key_F4: Result:= 'f, 4';
  key_F5: Result:= 'f, 5';
  key_F6: Result:= 'f, 6';
  key_F7: Result:= 'f, 7';
  key_F8: Result:= 'f, 8';
  key_F9: Result:= 'f, 9';
  key_F10: Result:= 'f, 10';
  key_F11: Result:= 'f, 11';
       
  key_F12: begin
   if (Sender is TMemoedit) then result:= TMemoedit(sender).text
   else if (Sender is Tcustomdataedit) then result:= 
                                  tcustomdataedit(sender).text
   else if (Sender is Tcustomstringgrid) then begin
    with tcustomstringgrid(Sender) do begin
     Result := Result + ' column  ' + 
     IntToStr(col) + ' , row  ' + IntToStr(row) + '. ' + items[focusedcell];
    end
   end
   else Result := '';
  end;      
  key_Shift: Result := 'shift';
  key_control: Result := 'control,';
  key_alt: Result := 'alt';
  key_CapsLock: Result := 'caps lock';
  key_NumLock: Result := 'num lock';
  key_AltGr: Result := 'alt gr';  
  Key_PageUp: Result := 'page up';
  Key_PageDown: Result := 'page down';  
  Key_delete: Result := 'delete';
  Key_insert: Result := 'insert';
  Key_escape: Result := 'escape';
  Key_end: Result := 'end';
 end;
end;

function WhatName(Sender: TObject): string;
begin

  Result := '';

  if (Sender is TLabel) then
   Result := 'label, ' + TLabel(Sender).Caption
  else if (Sender is TButton) then
  begin
   if (trim(TButton(Sender).Caption) <> '') then
    Result := 'button, ' + TButton(Sender).Caption
   else if (trim(TButton(Sender).Name) <> '') then
    Result := 'button, ' + TButton(Sender).Name
   else if (trim(TButton(Sender).hint) <> '') then
    Result := 'button, ' + TButton(Sender).hint;
  end
  else if (Sender is TStringEdit) then
   Result := 'edit, ' + TStringEdit(Sender).Name
  else if (Sender is TMemoEdit) then
   Result := 'memo, ' + TMemoEdit(Sender).Name
  else if (Sender is Twidgetgrid) then
   Result := 'grid, ' + Twidgetgrid(Sender).Name
  else if (Sender is Tstringgrid) then
   Result := 'grid, ' + Tstringgrid(Sender).Name
  else if (Sender is tcustombooleanedit) then begin
   if sender is tcustombooleaneditradio then begin
    result:= 'radio button';
   end
   else begin
    result:= 'checkbox';
   end;
   with tcustombooleanedit(sender) do begin
    if (frame <> nil) and (frame.caption <> '') then begin
     result:= result+', ' + frame.caption
    end
    else begin
     result:= result + ', ' + name;
    end;
   end;
  end
  else if (Sender is ttoolbar) then
    Result := 'tool bar, ' + ttoolbar(Sender).Name
  else if (Sender is tslider) then
    Result := 'slider, ' + Tslider(Sender).Name
  else if (Sender is ttoolbutton) then
    Result := 'toolbutton, ' +  ttoolbutton(Sender).hint
  else if (Sender is tmenuitem) then begin
    if (tmenuitem(Sender).Caption <> '') then
      Result := 'menu item , ' + tmenuitem(Sender).Caption
    else
      Result := 'menu item , ' + tmenuitem(Sender).Name;
  end
  else if (Sender is tcustommenu) or (Sender is tpopupmenuwidget) then begin
   Result :=  'menu, ';
  end;
 //   else 
 //    if (Sender is twidget) then
 //   Result := 'widget, ' + Twidget(Sender).Name ;
    
end;

////////////////////// Loading Procedure

function SAKLoadLib(const eSpeakBin: filenamety;
                                      const eSpeakDataDir: filenamety): integer;
begin
 Result := -1;
 if sak = nil then begin
  sak:= TSAK.Create();
 end;
 if (espeakdatadir = '') or finddir(eSpeakDataDir) then begin
  Result:= 0;
  sak.ES_DataDirectory:= eSpeakDataDir;
 end;
 sak.ES_ExeFileName:= eSpeakBin;
 Result:= sak.loadlib;
 if result <> 0 then begin
  freeandnil(sak);
 end;
end;

function SAKLoadLib(const sakitdir: filenamety = ''): integer;
var
 ordir: filenamety;
 espeakbin, espeaksak, espeakdatadir: filenamety;
const
{$ifdef mswindows}
 espeakstarter = 'espeak.bat';
 espeaklibdir = 'libwin32';
 espeakdefault = 'espeak.exe';
{$else}
 espeakstarter = 'espeak.sh';
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
 espeakbin:= ordir + espeakstarter;
 espeaksak:= ordir + WhatSpeakBin(espeakbin);
 if (fileexists(espeakbin)) and (fileexists(espeaksak)) then
begin
   Result:= 0;
   {$ifdef unix}
  result := ChangePermission(espeakbin,true);
 if result = 0 then
  result := ChangePermission(espeaksak,true);
   {$endif}
  end
 else begin
espeakbin:= ordir +  directoryseparator +'sakit' + directoryseparator +
  espeaklibdir + directoryseparator + espeakstarter;
 espeaksak:= ordir + directoryseparator + 'sakit' + directoryseparator +
  espeaklibdir+ directoryseparator + WhatSpeakBin(espeakbin);
    if (fileexists(espeaksak)) and (fileexists(espeakbin)) then
 begin
   Result:= 0;
     {$ifdef unix}
  result := ChangePermission(espeakbin,true);
 if result = 0 then
  result := ChangePermission(espeaksak,true);
    {$endif}
   end
  else begin
   espeakbin:= espeakdefault; //try to run default binary
     Result:= 0;
    end;
  end;
 if result = 0 then begin
  result:= sakloadlib(espeakbin,espeakdatadir);
 end;
end;

function SAKUnLoadLib: integer;
begin
 result:= -1;
 SakCancel;
 if assigned(sak) then begin
 result:= 0;
  freeandnil(sak);
 end;
end;

function checksakactive(const raiseexception: boolean = false): boolean;
begin
 result:= sak <> nil;
 if not result and raiseexception then begin
  raise esakerror.create('SAK not active');
 end;
end;

////////////////////// Voice Config Procedures ///////////////
function SAKSetVoice(gender: shortint; language: string ; speed: integer ; pitch: integer ; volume : integer ): integer;
// gender => 1 = man / => 2 = woman => defaut -1 (man)
// language => 'en' or 'pt' or 'ru'  => default 'en' => ''
//  speed sets the speed in words-per-minute , Range 80 to 450. The default value is 175. => -1
// pitch  range of 0 to 99. The default is 50.  => -1
// volume range of 0 to 200. The default is 100. => -1
begin
  result := -1;
  if checksakactive() then begin
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

//// custom speecher procedre => to use also as extra-speecher
function SAKSay(Text: string): integer;
begin
 result:= -1;
 if checksakactive() then begin
 result:= 0;
 sak.espeak_Key(Text);
 end;
end;

/// cancel current speech
function SakCancel: integer;
begin
 result:= -1;
 if checksakactive() then begin
 result:= 0;
  sak.espeakcancel();
 end;
end;

///////////// Enabled procedure
function SakIsEnabled(): boolean;
begin
 Result:= sak <> nil;
end;

{ tsak }

constructor TSAK.Create();
begin
 ftimer:= tsimpletimer.create(0,nil,false,[to_single]);
 fprocess:= tmseprocess.create(nil);
 fprocess.options:= fprocess.options + [pro_inactive]; 
                               //no console window on windows
 fprocess.onprocfinished:= @procfinished;
              //delaytimer
end;

destructor TSAK.Destroy();
begin
 espeakcancel();
 fprocess.free();
 ftimer.free();
 assistiveserver:= nil;
end;

procedure TSAK.procfinished(const sender: tobject);
begin
 fspeakkind:= sk_none;
 if fspeakbuffer <> nil then begin
  speaktext(fspeakbuffer[0]);
  deleteitem(fspeakbuffer,0);
 end;
end;

procedure tsak.startdelay(const amethod: notifyeventty; 
                                             const delayus: longword);
begin
 ftimer.enabled:= false;
 ftimer.ontimer:= amethod;
 ftimer.interval:= delayus;
 ftimer.enabled:= true;
end;

procedure TSAK.waitforspeak();
begin
 fprocess.waitforprocess();
end;

procedure tsak.speaktext(const text: msestring);
var
 params: msestring;
begin
  params:= '';
 if sak.es_datadirectory <> '' then begin
  params:= params+' --path=' + tosysfilepath(sak.ES_DataDirectory);
                                            //todo: filepath quoting
 end;
 if (sak.voice_gender <> '') or (sak.voice_language <> '') then begin
  params:= params + ' -v';
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

if voice_speed <> -1 then params:= params + ' -s' + inttostr(voice_speed) ;
if voice_pitch <> -1 then params:= params + ' -p' + inttostr(voice_pitch) ;
if voice_volume <> -1 then params:= params + ' -a' + inttostr(voice_volume) ;

 params:= params + ' "' + Text + '"';
 fprocess.parameter:= params;
 fprocess.active:= true;
end;

procedure TSAK.espeakcancel();
begin
 fspeakbuffer:= nil;
 if fprocess.active then begin
  killprocesstree(fprocess.prochandle); 
                //killing shell process does not kill espeak
  fprocess.active:= false;
 end;
end;

procedure TSAK.espeak_key(const Text: msestring);
begin
 espeakcancel();
 speaktext(text);
end; 

procedure TSAK.ondelayedspeak(const sender: tobject);
begin
 espeak_key(fspeaktext);
end;

procedure tsak.delayedspeak(const atext: msestring; 
                              const aspeakkind: speakkindty = sk_any;
                                     const delayus: longword = speakdelay);
begin
 fspeakkind:= aspeakkind;
 if delayus = 0 then begin
  ftimer.enabled:= false;
  if fprocess.active then begin
   additem(fspeakbuffer,atext);
  end
  else begin
   speaktext(atext);
  end;
 end
 else begin
  fspeaktext:= atext;
  startdelay(@ondelayedspeak,delayus);
 end;
end;

procedure TSAK.dochange(const sender: iassistiveclient);
var
 name1: string;
begin
 name1:= WhatName(sender.getinstance);
 if name1 <> '' then begin
  delayedspeak(name1 + WhatChange(sender.getinstance()));
 end;
end;

procedure TSAK.doenter(const Sender: iassistiveclient);
var
 name1: string;
begin
 if not (sender.getinstance is tpopupmenuwidget) then begin
                      //do not disturb item enter
  name1:= WhatName(Sender.getinstance);
  if name1 <> '' then begin
   delayedspeak(name1 + ', enter');
  end;
 end;
end;

procedure TSAK.dokeydown(const Sender: iassistiveclient;
                                              const info: keyeventinfoty);
var
 WhatCh: msestring;
 bo1: boolean;
begin
 if not (es_child in info.eventstate) and 
                           (fspeakkind in [sk_none,sk_key]) then begin
  WhatCh:= WhatChar(Sender.getinstance, info,bo1);
  if (trim(WhatCh) <> '') then begin
   if not bo1 and sakusekeybuffer then begin
    delayedspeak(WhatCh,sk_key,0);
   end
   else begin
    delayedspeak(WhatCh,sk_key,1);
   end;
  end;
 end;
end;

procedure TSAK.clientmouseevent(const sender: iassistiveclient;
                                           const info: mouseeventinfoty);
var
 stringtemp: msestring = '';
 name1: string;
 instance1: tobject;
begin
 instance1:= Sender.getinstance;
 name1:= whatname(instance1);
 if (name1 <> '') and not (instance1 is tpopupmenuwidget) then begin
                          //do not disturb menu item entry speak
  case info.eventkind of
   ek_clientmouseenter: begin
    if instance1 is tcustombooleanedit then  begin 
              //tboolenaeditradio iherites from tcustombooleanedit
     stringtemp:= ' , '+booleaneditvalue(tcustombooleanedit(instance1))+', ';
    end
    else begin
     if instance1 is tcustomslider then begin
      stringtemp:= ' , '+slidervalue(tcustomslider(instance1))+', ';
     end;
    end;       
    delayedspeak(name1 + stringtemp + ' focused.');
   end;
   ek_buttonpress: begin
    delayedspeak(name1 + ' clicked.');
   end;
  end;
 end;
end;

procedure TSAK.dofocuschanged(const oldwidget: iassistiveclient; const newwidget: iassistiveclient);
begin
end;

procedure TSAK.doitementer(const sender: iassistiveclient;
               const items: shapeinfoarty; const aindex: integer);
begin
end;

procedure TSAK.doitementer(const sender: iassistiveclient;
                        const items: menucellinfoarty; const aindex: integer);
var
 name1: string;
begin
 name1:= WhatName(Sender.getinstance);
 if name1 <> '' then begin
  delayedspeak(name1 + ', ' + 
          items[aindex].buttoninfo.ca.caption.text + ' , focused');
 end;
end;

procedure TSAK.docellevent(const sender: iassistiveclient;
               const info: celleventinfoty);
var
 mstr1: msestring;
begin
 with info do begin
  if eventkind = cek_enter then begin
   mstr1:= WhatName(grid)+', column' +
              IntToStr(cell.col) + ' , row  ' + 
              IntToStr(cell.row) + 'entered';
   if info.grid is tcustomstringgrid then begin
    mstr1:= mstr1+'. ' + tcustomstringgrid(grid).items[grid.focusedcell]; 
   end;
   delayedspeak(mstr1);
  end;
 end;
end;

procedure TSAK.doactionexecute(const Sender: TObject; const info: actioninfoty);
begin
 //dummy
end;

///////////////// loading sak
 
function TSAK.LoadLib: integer;
var
 str1: string;
begin
 result:= -1;
 if (getprocessoutput(ES_ExeFileName+' --version','',str1,5000000,
                                           [pro_shell,pro_inactive]) = 0) and
                   ((pos('eSpeak',str1) <> 0) or 
                    (pos('speak text-to-speech',str1) <> 0)) then begin 
  result:= 0;
  fprocess.filename:= ES_ExeFileName;

  TheWord := '' ;
  TheSentence := '' ;
  TheLastSentence := '' ;

  voice_gender := '' ;
  voice_language := '' ;
  voice_speed := -1 ;
  voice_pitch := -1 ;
  voice_volume := -1 ;

  espeak_Key('sak is working...');
  waitforspeak();
  assistiveserver:= iassistiveserver(self); //sak is now operable
 end;
end;

///// for check binaries
// to find what executable is used by espeak-script
function WhatSpeakBin(const espeakscript: filenamety = '') : string;
var
tf: textfile;
ffinded : boolean ;
dataf : string;
scriptfile : string;
begin
ffinded := false;
result := '';

//writeln( 'espeakscript is ' + espeakscript);

if findfile(espeakscript) then
begin
scriptfile := tosysfilepath(espeakscript);
  AssignFile(tf,pchar(scriptfile));
   Reset(tF);

   while (eof(tf) = false) and (ffinded = false) do
     begin
       Readln(tF, dataf);
    dataf := trim(dataf);
   {$ifdef unix}
    if  Pos('ESPEAKBIN=',dataf) > 0 then
   begin
    if  Pos('#',dataf) > 0 then  dataf := trim(copy(dataf,1, Pos('#',dataf)-1));
     result := copy(dataf,Pos('ESPEAKBIN=',dataf)+ 10 , length(dataf)-10);
     //  writeln( 'Result is ' +  dataf);
    ffinded := true;
   end;
{$else}
  if  Pos('%CALLDIR%\',dataf) > 0 then
   begin
    if  Pos(' ',dataf) > 0 then  dataf := trim(copy(dataf,1, Pos(' ',dataf)-1));
     result := copy(dataf,Pos('%CALLDIR%\',dataf)+ 10 , length(dataf)-10);
     //  writeln( 'Result is ' +  dataf);
    ffinded := true;
   end;
{$endif}
     end;
 CloseFile(tf);
end;

end;

{$IF DEFINED(unix)}
function ChangePermission(const thefile: filenamety = ''; raisemessage : boolean = true) : integer ;
var
info : stat;
begin
  result := 0;
 if (FpStat(thefile,info{%H-})<>-1) and FPS_ISREG(info.st_mode) and
             (BaseUnix.FpAccess(thefile,BaseUnix.X_OK)=0) then else
 begin
  if raisemessage = true then
  begin
  
  if askok('Permission mode of file:' +lineend+ thefile
   +lineend+ 'is not set as executable...'
    +lineend+ 'Do you want to reset it?') then begin

  fpchmod(thefile, S_IRWXU);
  ///// => get error at compil
// sys_setfilerights(thefile,[s_irusr,s_iwusr,s_ixusr,s_irgrp,s_ixgrp, s_iroth,s_ixoth]);

   end else result := -1;
  
 end
 else result := -1;

end; 
end;
{$endif}

finalization
 sak.free();
end.
