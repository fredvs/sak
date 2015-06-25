program sak_LCL_test;

{$mode objfpc}{$H+}

uses

  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
    Interfaces, // this includes the LCL widgetset
  Forms, Unit1, Unit2, Unit3
  { you can add units after this };

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

