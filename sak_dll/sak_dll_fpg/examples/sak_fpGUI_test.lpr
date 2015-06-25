program sak_fpGUI_test;

{$mode objfpc}{$H+}
{$DEFINE UseCThreads}
uses {$IFDEF UNIX}
  cthreads, {$ENDIF}
  sak_dll_fpg,
  SysUtils,
  Math,
  Classes,
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
  fpg_form { you can add units after this };

type
  Tassistive = class(TfpgForm)
  private
    {@VFD_HEAD_BEGIN: Assistive}

    Load_sak: TfpgButton;
    Unload_sak: TfpgButton;
    CheckBox1: TfpgCheckBox;
    Test_me: TfpgButton;
    Label2: TfpgLabel;
    Labelpos: TfpgLabel;
    RadioButton1: TfpgRadioButton;
    RadioButton2: TfpgRadioButton;
    Test_text: TfpgMemo;
    Label1: TfpgLabel;
    test_grid: TfpgStringGrid;
    test_edit: TfpgEdit;
    Button3: TfpgButton;
    Button4: TfpgButton;
    Button5: TfpgButton;
    ListBox1: TfpgListBox;
    ComboBox1: TfpgComboBox;
    FMenuBar: TfpgMenuBar;
    FFileSubMenu: TfpgPopupMenu;
    FEditSubMenu: TfpgPopupMenu;
    FEditSelectSubMenu: TfpgPopupMenu;
    FViewSubMenu: TfpgPopupMenu;
    slider: TfpgTrackBar;

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
  var
    f: integer;
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
    Grid1: TfpgStringGrid;
    Button1: TfpgButton;
    {@VFD_HEAD_END: form3}
  public
    procedure AfterCreate; override;
    procedure closeform3(Sender: TObject);
  end;

  {@VFD_NEWFORM_DECL}
var

  MainForm: Tassistive;

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
    WindowPosition := wpScreenCenter;
    Hint := '';

    Memo1 := TfpgMemo.Create(self);
    with Memo1 do
    begin
      Name := 'Memo1';
      SetPosition(24, 20, 324, 161);
      FontDesc := '#Edit1';
      Hint := '';
      Lines.Add('The quick brown fox, jumps over the lazy dog...');
      Lines.Add('');
      Lines.Add('Please, write something here...');
      Lines.Add('');
      Lines.Add('Use F12 key to read all.');
      Lines.Add('Use F11 key to stop reading.');
      TabOrder := 0;
    end;


    Button1 := TfpgButton.Create(self);
    with Button1 do
    begin
      Name := 'Button1';
      SetPosition(140, 196, 80, 23);
      Text := 'Close';
      FontDesc := '#Label1';
      Hint := '';
      ImageName := '';
      TabOrder := 1;
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
    WindowPosition := wpScreenCenter;
    Hint := '';

    Grid1 := TfpgStringGrid.Create(self);
    with Grid1 do
    begin
      Name := 'Test_Grid';
      SetPosition(24, 20, 324, 161);
      BackgroundColor := TfpgColor($80000002);
      FontDesc := '#Grid';
      HeaderFontDesc := '#GridHeader';
      Hint := '';
      RowCount := 5;
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
      Text := 'Close';
      FontDesc := '#Label1';
      Hint := '';
      ImageName := '';
      TabOrder := 2;
      onclick := @closeform3;
    end;

    {@VFD_BODY_END: form3}
    {%endregion}
    for x := 0 to 4 do
      for y := 0 to 4 do
        grid1.Cells[x, y] := IntToStr(random(1000)) + randommoney;
  end;

  procedure Tform3.closeform3(Sender: TObject);
  begin
    Destroy;
  end;

  procedure Tassistive.btnloadClick(Sender: TObject);
  begin
    Load_sak.Enabled := False;
    UnLoad_sak.Enabled := True;
    SAKLoadlib;

    /// You may change the default gender and language.
    /// gender : male or female,
    /// language : langage code
    /// Here example for Portugues/Brasil woman

    // SAKSetVoice(female,'pt');

  end;

  procedure Tassistive.changepos(Sender: TObject; pos: longint);
  begin
    labelpos.Text := IntToStr(pos);
  end;

  procedure Tassistive.btnunloadClick(Sender: TObject);
  begin
    UnLoad_sak.Enabled := False;
    Load_sak.Enabled := True;
    if SakIsEnabled = true then SAKUnloadLib;
  end;

  procedure Tassistive.FreeLib(Sender: TObject);
  begin
    SAKFreeLib;
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
    Hint := '';
    WindowPosition := wpScreenCenter;
    BackgroundColor := clmoneygreen;
    Ondestroy := @FreeLib;


    slider := TfpgTrackBar.Create(self);
    with slider do
    begin
      Name := 'Slider';
      SetPosition(200, 275, 200, 24);
      Max := 10;
      Position := 0;
      OnChange := @ChangePos;
    end;

    Labelpos := TfpgLabel.Create(self);
    with Labelpos do
    begin
      Name := 'Labelpos';
      SetPosition(165, 275, 30, 24);
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
      SetPosition(40, 32, 90, 25);
      Text := 'Load sak';
      FontDesc := '#Label1';
      Hint := '';
      ImageName := '';
      TabOrder := 0;
      onclick := @btnloadClick;
    end;

    Unload_sak := TfpgButton.Create(self);
    with Unload_sak do
    begin
      Name := 'Unload_sak';
      SetPosition(40, 64, 90, 25);
      Text := 'Unload sak';
      Enabled := False;
      FontDesc := '#Label1';
      Hint := '';
      ImageName := '';
      TabOrder := 12;
      onclick := @btnUnloadClick;
    end;

    CheckBox1 := TfpgCheckBox.Create(self);
    with CheckBox1 do
    begin
      Name := 'CheckBox1';
      SetPosition(44, 96, 100, 19);
      FontDesc := '#Label1';
      Hint := '';
      TabOrder := 1;
      Text := 'Test';
    end;

    Test_me := TfpgButton.Create(self);
    with Test_me do
    begin
      Name := 'Test_me';
      SetPosition(36, 132, 90, 30);
      Text := 'Test Me';
      FontDesc := '#Label1';
      Hint := '';
      ImageName := '';
      TabOrder := 2;
      onclick := @btnTestClick;
    end;

    Label2 := TfpgLabel.Create(self);
    with Label2 do
    begin
      Name := 'Label2';
      SetPosition(40, 168, 90, 30);
      FontDesc := '#Label1';
      Hint := '';
      Text := 'Increment = 0';
    end;

    RadioButton1 := TfpgRadioButton.Create(self);
    with RadioButton1 do
    begin
      Name := 'number1';
      SetPosition(36, 204, 100, 19);
      Checked := True;
      FontDesc := '#Label1';
      GroupIndex := 0;
      Hint := '';
      TabOrder := 3;
      Text := 'Always';
    end;

    RadioButton2 := TfpgRadioButton.Create(self);
    with RadioButton2 do
    begin
      Name := 'number2';
      SetPosition(36, 232, 96, 19);
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
      SetPosition(168, 32, 188, 141);
      FontDesc := '#Edit1';
      Hint := '';
      Lines.Add('Please, write something here...');
      Lines.Add('Use F12 key to read all ');
      Lines.Add('Use F11 key to stop reading');
      TabOrder := 5;
    end;

    Label1 := TfpgLabel.Create(self);
    with Label1 do
    begin
      Name := 'Label1';
      SetPosition(396, 32, 300, 30);
      FontDesc := '#Label1';
      Hint := '';
      Text := 'Stringgrid : use arrow keys or enter to speak it...';
    end;

    test_grid := TfpgStringGrid.Create(self);
    with test_grid do
    begin
      Name := 'dimension';
      SetPosition(384, 56, 308, 144);
      BackgroundColor := TfpgColor($80000002);
      FontDesc := '#Grid';
      HeaderFontDesc := '#GridHeader';
      Hint := '';
      RowCount := 5;
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
      Text := 'Write something here. Use F12 key to read it, F11 to stop reading...';
    end;

    Button3 := TfpgButton.Create(self);
    with Button3 do
    begin
      Name := 'Button3';
      SetPosition(424, 245, 96, 23);
      Text := 'Other Form2';
      FontDesc := '#Label1';
      Hint := '';
      ImageName := '';
      TabOrder := 10;
      onClick := @showform2;
    end;

    Button4 := TfpgButton.Create(self);
    with Button4 do
    begin
      Name := 'Button4';
      SetPosition(560, 245, 88, 23);
      Text := 'Other Form3';
      FontDesc := '#Label1';
      Hint := '';
      ImageName := '';
      TabOrder := 11;
      onClick := @showform3;
    end;

    Button5 := TfpgButton.Create(self);
    with Button5 do
    begin
      Name := 'Button5';
      SetPosition(272, 240, 88, 24);
      Text := 'File Dialog';
      FontDesc := '#Label1';
      Hint := '';
      ImageName := '';
      TabOrder := 11;
      onClick := @btnOpenFileClick;
    end;

    ListBox1 := TfpgListBox.Create(self);
    with ListBox1 do
    begin
      Name := 'size_';
      SetPosition(156, 188, 92, 76);
      FontDesc := '#List';
      Hint := '';
      Items.Add('small');
      Items.Add('medium');
      Items.Add('large');
      Items.Add('extra large');
      TabOrder := 6;
    end;

    ComboBox1 := TfpgComboBox.Create(self);
    with ComboBox1 do
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



    {@VFD_BODY_END: Assistive}
    {%endregion}

    // Attach sub menus to main menu bar
    FMenuBar.AddMenuItem('&File', nil).SubMenu := FFileSubMenu;
    FMenuBar.AddMenuItem('&Edit', nil).SubMenu := FEditSubMenu;
    FMenuBar.AddMenuItem('&View', nil).SubMenu := FViewSubMenu;

    randomize;
    for x := 0 to 4 do
      for y := 0 to 4 do
        test_grid.Cells[x, y] := IntToStr(random(1000)) + randommoney;
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
    fpgApplication.CreateForm(Tassistive, MainForm);
    fpgApplication.MainForm := MainForm;


    MainForm.Show;
    fpgApplication.Run;
  end;

begin
  MainProc;
end.
