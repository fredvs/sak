unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msegraphedits,msescrollbar,
 msefileutils,msemenuwidgets,msegrids,msewidgetgrid,msebitmap,msedatanodes,
 msefiledialog,mselistbrowser,msesys;

type
 tmainfo = class(tmainform)
   tlabel1: tlabel;
   tbutton1: tbutton;
   tbutton2: tbutton;
   tstringedit1: tstringedit;
   tbooleanedit1: tbooleanedit;
   tbooleaneditradio1: tbooleaneditradio;
   tbooleaneditradio2: tbooleaneditradio;
   tbooleaneditradio3: tbooleaneditradio;
   tslider1: tslider;
   tmemoedit1: tmemoedit;
   tmainmenuwidget1: tmainmenuwidget;
   demogrid: tstringgrid;
   sakitdir: tfilenameedit;
 procedure loadassistive(const sender: TObject);
 procedure unloadassistive(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm, sak_mse;
 
  function randommoney: msestring;
  var
    x: integer;
  begin
  
   
      x := random(3);
    case x of
      0: Result := ' €';
      1: Result := ' £';
      2: Result := ' $';
    end;
  end;

 procedure tmainfo.loadassistive(const sender: TObject);
  var
x, y  : integer;
 begin
  randomize;
    for x := 0 to 4 do
      for y := 0 to 5 do
     demogrid[x][y]  := IntToStr(random(1000))  + randommoney;
  
 if sakloadlib(tosysfilepath(sakitdir.value)) = 0 then 
begin
 tbutton1.enabled := false;
 tbutton2.enabled := true;
 // SAKSetVoice(2, 'fr') ; // => you may choose genre+language
 end; 
 
 end;
 
 procedure tmainfo.unloadassistive(const sender: TObject);
 begin
 tbutton2.enabled := false;
 tbutton1.enabled := true;
 sakunloadlib;
 end;
 
 
end.
