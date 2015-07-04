program sak_fpGUI_test;

{$mode objfpc}{$H+}
uses
  sak_fpg,
  SysUtils,
  Math,
  classes,
  fpg_label,
  fpg_grid,
  fpg_button,
  fpg_CheckBox,
  fpg_ComboBox,
  fpg_TrackBar,
  fpg_ListBox,
  fpg_RadioButton,
  fpg_base,
  fpg_main,
  fpg_memo,
  fpg_dialogs,
  fpg_Menu,
  fpg_edit,
  fpg_form,
  {%units 'Auto-generated GUI code'}
  fpg_editbtn
  {%endunits}
  ;

type
  Tassistive = class(TfpgForm)
  private
    {@VFD_HEAD_BEGIN: Assistive}
    Slider: TfpgTrackBar;
    Labelpos: TfpgLabel;
    FMenuBar: TfpgMenuBar;
    FFileSubMenu: TfpgPopupMenu;
    FEditSubMenu: TfpgPopupMenu;
    FEditSelectSubMenu: TfpgPopupMenu;
    FViewSubMenu: TfpgPopupMenu;
    Load_sak: TfpgButton;
    Unload_sak: TfpgButton;
    CheckBox1: TfpgCheckBox;
    Test_me: TfpgButton;
    Label2: TfpgLabel;
    number1: TfpgRadioButton;
    number2: TfpgRadioButton;
    Test_text: TfpgMemo;
    Label1: TfpgLabel;
    dimension: TfpgStringGrid;
    test_edit: TfpgEdit;
    Button3: TfpgButton;
    Button4: TfpgButton;
    Button5: TfpgButton;
    size_: TfpgListBox;
    color_: TfpgComboBox;
    DirectoryEdit1: TfpgDirectoryEdit;
    Label3: TfpgLabel;
    {@VFD_HEAD_END: Assistive}
  public
    procedure btnOpenFileClick(Sender: TObject);
    procedure AfterCreate; override;
    procedure btnTestClick(Sender: TObject);
    procedure showform2(Sender: TObject);
    procedure showform3(Sender: TObject);
    procedure changepos(Sender: TObject; pos: longint);
    procedure btnLoadClick(Sender: TObject);
    procedure btnUnLoadClick(Sender: TObject);
    procedure FreeLib(Sender: TObject);
  end;
type
  Tform2 = class(TfpgForm)
  private
    {@VFD_HEAD_BEGIN: form2}
    Memo1: TfpgMemo;
    Button1: TfpgButton;
    {@VFD_HEAD_END: form2}
  public
    procedure AfterCreate; override;
    procedure closeform2(Sender: TObject);
  end;
type
  Tform3 = class(TfpgForm)
  private
    {@VFD_HEAD_BEGIN: form3}
    Test_Grid: TfpgStringGrid;
    Button1: TfpgButton;
    {@VFD_HEAD_END: form3}
  public
    procedure AfterCreate; override;
    procedure closeform3(Sender: TObject);
  end;

  {@VFD_NEWFORM_DECL}
var

  MainForm: Tassistive;
  f : integer;

  {@VFD_NEWFORM_IMPL}

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

  procedure Tform2.AfterCreate;
  begin
    {%region 'Auto-generated GUI code' -fold}


    {@VFD_BODY_BEGIN: form2}
  Name := 'form2';
  SetPosition(280, 150, 374, 250);
  WindowTitle := 'form2';
  IconName := '';
  Hint := '';
  BackGroundColor := $80000001;
  WindowPosition := wpScreenCenter;

  Memo1 := TfpgMemo.Create(self);
  with Memo1 do
  begin
    Name := 'Memo1';
    SetPosition(24, 20, 324, 161);
    FontDesc := '#Edit1';
    Hint := '';
    Lines.Add('The quick brown fox, jumps over the lazy dog...');
    Lines.Add('Please, write something here...');
    Lines.Add('Use F12 key to read all.');
    Lines.Add('Use F11 key to read line.');
    Lines.Add('Use F10 key to read word.');
    Lines.Add('Use Cancel key to stop reading.');
    TabOrder := 0;
  end;

  Button1 := TfpgButton.Create(self);
  with Button1 do
  begin
    Name := 'Button1';
    SetPosition(140, 196, 80, 23);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 1;
    Text := 'Close';
    onclick := @closeform2;
  end;

  {@VFD_BODY_END: form2}
    {%endregion}
  end;

  procedure Tform2.closeform2(Sender: TObject);
  begin
    Destroy;
  end;

  procedure Tform3.AfterCreate;
  var
    x, y: integer;
  begin
    {%region 'Auto-generated GUI code' -fold}

    {@VFD_BODY_BEGIN: form3}
  Name := 'form3';
  SetPosition(290, 150, 374, 250);
  WindowTitle := 'form3';
  IconName := '';
  Hint := '';
  BackGroundColor := $80000001;
  WindowPosition := wpScreenCenter;

  Test_Grid := TfpgStringGrid.Create(self);
  with Test_Grid do
  begin
    Name := 'Test_Grid';
    SetPosition(24, 20, 324, 161);
    BackgroundColor := TfpgColor($80000002);
    FontDesc := '#Grid';
    HeaderFontDesc := '#GridHeader';
    Hint := '';
    RowCount := 5;
    ColumnCount := 0;
    RowSelect := False;
    TabOrder := 0;
    AddColumn('green', 63);
    AddColumn('yellow', 63);
    AddColumn('purple', 63);
    AddColumn('red', 63);
    AddColumn('blue', 63);
    DefaultRowHeight := 24;
  end;

  Button1 := TfpgButton.Create(self);
  with Button1 do
  begin
    Name := 'Button1';
    SetPosition(140, 196, 80, 23);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 2;
    Text := 'Close';
    onclick := @closeform3;
  end;

  {@VFD_BODY_END: form3}
    {%endregion}
    for x := 0 to 4 do
      for y := 0 to 4 do
       Test_Grid.Cells[x, y] := IntToStr(random(1000)) + randommoney;
  end;

  procedure Tform3.closeform3(Sender: TObject);
  begin
    Destroy;
  end;

  procedure Tassistive.btnloadClick(Sender: TObject);
  begin
    if  SAKLoadlib(DirectoryEdit1.Directory) = 0 then
    begin
    Load_sak.Enabled := False;
    UnLoad_sak.Enabled := True;
        end;
    fpgapplication.ProcessMessages;


    /// You may change the default gender and language.
    /// gender : male or female,
    /// language : langage code
    /// Here example for Portugues/Brasil woman

    //  SAKSetVoice(female,'pt');

  end;

  procedure Tassistive.changepos(Sender: TObject; pos: longint);
  begin
    labelpos.Text := IntToStr(pos);
  end;

  procedure Tassistive.btnunloadClick(Sender: TObject);
  begin
    UnLoad_sak.Enabled := False;
    Load_sak.Enabled := True;
    SAKUnloadLib;
  end;

  procedure Tassistive.FreeLib(Sender: TObject);
  begin
    SAKUnloadLib;
  end;

  procedure Tassistive.showform2(Sender: TObject);
  var
    form2: Tform2;
  begin
    fpgApplication.CreateForm(TForm2, Form2);
    form2.Show;
  end;

  procedure Tassistive.showform3(Sender: TObject);
  var
    form3: Tform3;
  begin
    fpgApplication.CreateForm(TForm3, Form3);
    form3.Show;
  end;


  procedure Tassistive.btnTestClick(Sender: TObject);
   begin
   Inc(f);
   label2.Text := 'Increment = ' + IntToStr(f);
    end;

  procedure TAssistive.AfterCreate;
  var
    x, y: integer;

  begin
    {%region 'Auto-generated GUI code' -fold}

    {@VFD_BODY_BEGIN: Assistive}
  Name := 'Assistive';
  SetPosition(58, 165, 709, 310);
  WindowTitle := 'sak is the Speecher Assistive Kit. Use your keyboard to test it...';
  IconName := '';
  Hint := '';
  BackGroundColor := $80000001;
  WindowPosition := wpScreenCenter;
  Ondestroy := @FreeLib;

  Slider := TfpgTrackBar.Create(self);
  with Slider do
  begin
    Name := 'Slider';
    SetPosition(200, 275, 200, 24);
    Hint := '';
    Max := 10;
    TabOrder := 1;
    OnChange := @ChangePos;
  end;

  Labelpos := TfpgLabel.Create(self);
  with Labelpos do
  begin
    Name := 'Labelpos';
    SetPosition(165, 275, 30, 24);
    FontDesc := '#Label1';
    Hint := '';
    Text := '0';
  end;

  FMenuBar := TfpgMenuBar.Create(self);
  with FMenuBar do
  begin
    Name := 'FMenuBar';
    SetPosition(0, 0, 400, 24);
    Align := alTop;
  end;

  FFileSubMenu := TfpgPopupMenu.Create(self);
  with FFileSubMenu do
  begin
    Name := 'FFileSubMenu';
    SetPosition(264, 60, 120, 20);
    AddMenuItem('&Open', 'Ctrl-O', nil);
    AddMenuItem('&Save', 'Ctrl-S', nil);
    AddMenuItem('S&ave As', 'Ctrl+Shift+S', nil);
    AddMenuItem('-', '', nil);
    AddMenuItem('Save && Reload', '', nil);
    AddMenuItem('-', '', nil);
    AddMenuItem('&Quit', 'Ctrl-Q', nil);
  end;

  FEditSubMenu := TfpgPopupMenu.Create(self);
  with FEditSubMenu do
  begin
    Name := 'FEditSubMenu';
    SetPosition(264, 80, 120, 20);
    AddMenuItem('&Cut', 'Ctrl-X', nil);
    AddMenuItem('C&opy', 'Ctrl-C', nil);
    AddMenuItem('&Paste', 'Ctrl-V', nil);
    AddMenuItem('-', '', nil);
    AddMenuItem('&Spell check', 'F4', nil).Enabled := False;
  end;

  FEditSelectSubMenu := TfpgPopupMenu.Create(self);
  with FEditSelectSubMenu do
  begin
    Name := 'FEditSelectSubMenu';
    SetPosition(264, 100, 120, 20);
    AddMenuItem('Select All', '', nil);
    AddMenuItem('Select Word', '', nil);
    AddMenuItem('Select Line', '', nil);
    FEditSubMenu.AddMenuItem('Selec&t', '', nil).SubMenu := FEditSelectSubMenu;
  end;

  FViewSubMenu := TfpgPopupMenu.Create(self);
  with FViewSubMenu do
  begin
    Name := 'FViewSubMenu';
    SetPosition(264, 120, 120, 20);
    AddMenuItem('Full Screen', '', nil);
    AddMenuItem('Tool Bar', '', nil).Checked := True;
    AddMenuItem('Status Bar', '', nil).Checked := True;
    AddMenuItem('Line Numbers', '', nil);
  end;

  Load_sak := TfpgButton.Create(self);
  with Load_sak do
  begin
    Name := 'Load_sak';
    SetPosition(36, 72, 90, 25);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 0;
    Text := 'Load sak';
    onclick := @btnloadClick;
  end;

  Unload_sak := TfpgButton.Create(self);
  with Unload_sak do
  begin
    Name := 'Unload_sak';
    SetPosition(36, 100, 90, 25);
    Enabled := False;
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 12;
    Text := 'Unload sak';
    onclick := @btnUnloadClick;
  end;

  CheckBox1 := TfpgCheckBox.Create(self);
  with CheckBox1 do
  begin
    Name := 'CheckBox1';
    SetPosition(44, 136, 100, 19);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 1;
    Text := 'Test';
  end;

  Test_me := TfpgButton.Create(self);
  with Test_me do
  begin
    Name := 'Test_me';
    SetPosition(32, 168, 90, 30);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 2;
    Text := 'Test Me';
    onclick := @btnTestClick;
  end;

  Label2 := TfpgLabel.Create(self);
  with Label2 do
  begin
    Name := 'Label2';
    SetPosition(32, 204, 90, 30);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Increment = 0';
  end;

  number1 := TfpgRadioButton.Create(self);
  with number1 do
  begin
    Name := 'number1';
    SetPosition(36, 236, 100, 19);
    Checked := True;
    FontDesc := '#Label1';
    GroupIndex := 0;
    Hint := '';
    TabOrder := 3;
    Text := 'Always';
  end;

  number2 := TfpgRadioButton.Create(self);
  with number2 do
  begin
    Name := 'number2';
    SetPosition(36, 264, 96, 19);
    FontDesc := '#Label1';
    GroupIndex := 0;
    Hint := '';
    TabOrder := 4;
    Text := 'Never';
  end;

  Test_text := TfpgMemo.Create(self);
  with Test_text do
  begin
    Name := 'Test_text';
    SetPosition(144, 72, 224, 113);
    FontDesc := '#Edit1';
    Hint := '';
    Lines.Add('The quick brown fox, jumps over the lazy dog...');
    Lines.Add('Please, write something here...');
    Lines.Add('Use F12 key to read all.');
    Lines.Add('Use F11 key to read line.');
    Lines.Add('Use F10 key to read word.');
    Lines.Add('Use Cancel key to stop reading.');
    TabOrder := 5;
  end;

  Label1 := TfpgLabel.Create(self);
  with Label1 do
  begin
    Name := 'Label1';
    SetPosition(396, 36, 300, 30);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Stringgrid : use arrow keys or enter to speak it...';
  end;

  dimension := TfpgStringGrid.Create(self);
  with dimension do
  begin
    Name := 'dimension';
    SetPosition(384, 56, 308, 144);
    BackgroundColor := TfpgColor($80000002);
    FontDesc := '#Grid';
    HeaderFontDesc := '#GridHeader';
    Hint := '';
    RowCount := 5;
    ColumnCount := 0;
    RowSelect := False;
    TabOrder := 8;
    AddColumn('maxi', 60);
    AddColumn('extra', 60);
    AddColumn('large', 60);
    AddColumn('medium', 60);
    AddColumn('small', 60);
    DefaultRowHeight := 24;
  end;

  test_edit := TfpgEdit.Create(self);
  with test_edit do
  begin
    Name := 'test_edit';
    SetPosition(396, 210, 288, 24);
    ExtraHint := '';
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 9;
    Text := 'Write something here. Use F12 key to read it, Cancel key to stop reading...';
  end;

  Button3 := TfpgButton.Create(self);
  with Button3 do
  begin
    Name := 'Button3';
    SetPosition(424, 245, 96, 23);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 10;
    Text := 'Other Form2';
    onClick := @showform2;
  end;

  Button4 := TfpgButton.Create(self);
  with Button4 do
  begin
    Name := 'Button4';
    SetPosition(560, 245, 88, 23);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 11;
    Text := 'Other Form3';
    onClick := @showform3;
  end;

  Button5 := TfpgButton.Create(self);
  with Button5 do
  begin
    Name := 'Button5';
    SetPosition(272, 240, 88, 24);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 11;
    Text := 'File Dialog';
    onClick := @btnOpenFileClick;
  end;

  size_ := TfpgListBox.Create(self);
  with size_ do
  begin
    Name := 'size_';
    SetPosition(148, 192, 92, 68);
    FontDesc := '#List';
    Hint := '';
    Items.Add('small');
    Items.Add('medium');
    Items.Add('large');
    Items.Add('extra large');
    TabOrder := 6;
  end;

  color_ := TfpgComboBox.Create(self);
  with color_ do
  begin
    Name := 'color_';
    SetPosition(272, 204, 88, 24);
    ExtraHint := '';
    FontDesc := '#List';
    Hint := '';
    Items.Add('green');
    Items.Add('red');
    Items.Add('yellow');
    Items.Add('blue');
    FocusItem := 0;
    TabOrder := 7;
  end;

  DirectoryEdit1 := TfpgDirectoryEdit.Create(self);
  with DirectoryEdit1 do
  begin
    Name := 'DirectoryEdit1';
    SetPosition(16, 44, 344, 24);
    Directory := '';
    ExtraHint := '';
    RootDirectory := '';
    TabOrder := 24;
  end;

  Label3 := TfpgLabel.Create(self);
  with Label3 do
  begin
    Name := 'Label3';
    SetPosition(132, 28, 120, 15);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Directory of sakit';
  end;

  {@VFD_BODY_END: Assistive}
    {%endregion}

    // Attach sub menus to main menu bar
    FMenuBar.AddMenuItem('&File', nil).SubMenu := FFileSubMenu;
    FMenuBar.AddMenuItem('&Edit', nil).SubMenu := FEditSubMenu;
    FMenuBar.AddMenuItem('&View', nil).SubMenu := FViewSubMenu;

    randomize;
    for x := 0 to 4 do
      for y := 0 to 4 do
        dimension.Cells[x, y] := IntToStr(random(1000)) + randommoney;
    f := 0;
  end;

  procedure Tassistive.btnOpenFileClick(Sender: TObject);
  var
    dlg: TfpgFileDialog;
  begin
    fpgApplication.CreateForm(TfpgFileDialog, dlg);
    dlg.Filter := 'All Files (*)|*|Object Pascal (*.pas;*.lpr;*.pp)|*.pas;*.lpr;*.pp|Lazarus Project (*.lpi)|*.lpi';
    dlg.RunOpenFile;
    dlg.Destroy;
  end;

  procedure MainProc;


  begin
    fpgApplication.Initialize;

    //  fpgApplication.CreateForm(Tassistive, MainForm);
    MainForm := Tassistive.Create(fpgApplication);

    fpgApplication.MainForm := MainForm;
    MainForm.Show;
    fpgApplication.Run;
  end;

begin
     MainProc;
end.
