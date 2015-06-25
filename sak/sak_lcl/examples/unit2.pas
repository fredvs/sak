unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    color_: TComboBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
   private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Button1Click(Sender: TObject);
begin
  form2.hide;
end;


end.

