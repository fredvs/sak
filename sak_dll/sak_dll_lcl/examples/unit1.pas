unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  sak_dll_lcl, Unit2, Unit3, Forms, StdCtrls, Grids, Dialogs, Menus, ComCtrls, SysUtils,
  Classes;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckBox1: TCheckBox;
    color_: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    size_: TListBox;
    memo1: TMemo;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Stock: TStringGrid;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }

  end;

var
  MainForm: TMainForm;
  tempi: integer;


implementation

{$R *.lfm}

{ TMainForm }


procedure TMainForm.Button2Click(Sender: TObject);
begin
  SAKLoadLib;
  button2.Enabled := False;
  button3.Enabled := True;

  /// You may change the default gender and language.
  /// gender : male or female,
  /// language : langage code
  /// Here example for Portugues/Brasil woman

  // SAKSetVoice(female,'pt');

end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
 if SakIsEnabled = true then SAKUnloadLib;
  button2.Enabled := True;
  button3.Enabled := False;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  form2.Show;
end;

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

procedure TMainForm.Button5Click(Sender: TObject);
var
  x, y: integer;
begin
  for x := 0 to 4 do
    for y := 1 to 4 do
      form3.Stock.Cells[x, y] := IntToStr(random(1000)) + randommoney;
  form3.Show;
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  opendialog1.Execute;

end;

procedure TMainForm.Button7Click(Sender: TObject);
begin
  savedialog1.Execute;
end;



procedure TMainForm.Button1Click(Sender: TObject);
begin
  Inc(tempi);
  label1.Caption := 'Test enter ' + IntToStr((tempi));
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SAKFreeLib;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  x, y: integer;
begin
  randomize;
  for x := 1 to 4 do
    for y := 1 to 4 do
      MainForm.Stock.Cells[x, y] := IntToStr(random(1000)) + randommoney;
  tempi := 0;
end;

procedure TMainForm.TrackBar1Change(Sender: TObject);
begin
  label3.Caption := IntToStr(TrackBar1.Position);
end;


end.
