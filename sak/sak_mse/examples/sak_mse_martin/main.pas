unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msegraphedits,msescrollbar,
 msemenuwidgets,msegrids,msewidgetgrid,msebitmap,msedatanodes,msefiledialog,
 mselistbrowser,msesys;

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
   usekeybuffer: tbooleanedit;
   tstatfile1: tstatfile;
   language: tstringedit;
   gender: tenumedit;
   sakitdir: tfilenameedit;
   tframecomp2: tframecomp;
   tframecomp1: tframecomp;
   tfacecomp2: tfacecomp;
   tfacecomp1: tfacecomp;
   tframecomp3: tframecomp;
   procedure loadassistive(const sender: TObject);
   procedure unloadassistive(const sender: TObject);
   procedure setusekeybuffer(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure voiceentered(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm, sak_mse;
 
  function randommoney: string;
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
  if sakloadlib(sakitdir.value) = 0 then begin //use default datadir
   tbutton1.enabled := false;
   tbutton2.enabled := true;
   voiceentered(nil); //init
  end;
 end;
 
 procedure tmainfo.unloadassistive(const sender: TObject);
 begin
 tbutton2.enabled := false;
 tbutton1.enabled := true;
 sakunloadlib;
 end;

procedure tmainfo.setusekeybuffer(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 sakusekeybuffer:= avalue;
end;

procedure tmainfo.voiceentered(const sender: TObject);
begin
 saksetvoice(gender.value+1,language.value,-1,-1,-1);
end;

end.
