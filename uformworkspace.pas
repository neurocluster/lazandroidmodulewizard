unit uformworkspace;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LazIDEIntf,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, FormPathMissing, uFormOSystem;

type

  { TFormWorkspace }

  TFormWorkspace  = class(TForm)
    BitBtnCancel: TBitBtn;
    BitBtnOK: TBitBtn;
    CheckBox1: TCheckBox;
    ComboBoxTheme: TComboBox;
    ComboSelectProjectName: TComboBox;
    EditPackagePrefaceName: TEdit;
    EditPathToWorkspace: TEdit;
    edProjectName: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Image1: TImage;
    LabelTheme: TLabel;
    LabelPathToWorkspace: TLabel;
    LabelSelectProjectName: TLabel;
    ListBoxMinSDK: TListBox;
    ListBoxPlatform: TListBox;
    ListBoxTargetAPI: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelPlatform: TPanel;
    PanelButtons: TPanel;
    PanelRadioGroup: TPanel;
    RGInstruction: TRadioGroup;
    RGFPU: TRadioGroup;
    SelDirDlgPathToWorkspace: TSelectDirectoryDialog;
    SpdBtnPathToWorkspace: TSpeedButton;
    SpdBtnRefreshProjectName: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButtonHintTheme: TSpeedButton;
    StatusBarInfo: TStatusBar;

    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBoxThemeChange(Sender: TObject);
    procedure ComboSelectProjectNameKeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

    procedure ListBoxMinSDKClick(Sender: TObject);
    procedure ListBoxMinSDKSelectionChange(Sender: TObject; User: boolean);
    procedure ListBoxPlatformSelectionChange(Sender: TObject; User: boolean);
    procedure ListBoxTargetAPIClick(Sender: TObject);
    procedure ListBoxTargetAPISelectionChange(Sender: TObject; User: boolean);
    procedure ListBoxPlatformClick(Sender: TObject);

    procedure RGInstructionClick(Sender: TObject);
    procedure RGFPUClick(Sender: TObject);

    procedure SpdBtnPathToWorkspaceClick(Sender: TObject);
    procedure SpdBtnRefreshProjectNameClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButtonHintThemeClick(Sender: TObject);

  private
    { private declarations }
    FFilename: string;
    FPathToWorkspace: string; {C:\adt32\eclipse\workspace}

    FInstructionSet: string;      {ArmV6}
    FFPUSet: string;              {Soft}
    FPathToJavaTemplates: string;
    FAndroidProjectName: string;

    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;

    FProjectModel: string;

    FModuleType: integer;  //0: GUI project   1: NoGui project
    FSmallProjName: string;

    FPackagePrefaceName: string;

    FMinApi: string;
    FTargetApi: string;

    FTouchtestEnabled: string;
    FAntBuildMode: string;
    FMainActivity: string;   //Simon "App"
    FNDK: string;
    FAndroidNdkPlatform: string;
    FSupportV4: string;

    FPrebuildOSYS: string;

    FFullJavaSrcPath: string;
    FJavaClassName: string;
    FIndexTargetApi: integer;
    FIndexNdkPlatformApi: integer;
    FAndroidTheme: string;

  public
    { public declarations }
    procedure LoadSettings(const pFilename: string);
    procedure SaveSettings(const pFilename: string);
    function GetTextByListIndex(index:integer): string;

    function GetNDKPlatform(identName: string): string;

    function GetCodeNameByApi(api: string):string;
    function GetNDKPlatformByApi(api: string): string;

    function GetFullJavaSrcPath(fullProjectName: string): string;

    procedure LoadPathsSettings(const fileName: string);

    property PathToWorkspace: string read FPathToWorkspace write FPathToWorkspace;

    property InstructionSet: string read FInstructionSet write FInstructionSet;
    property FPUSet: string  read FFPUSet write FFPUSet;
    property PathToJavaTemplates: string read FPathToJavaTemplates write FPathToJavaTemplates;
    property AndroidProjectName: string read FAndroidProjectName write FAndroidProjectName;

    property PathToJavaJDK: string read FPathToJavaJDK write FPathToJavaJDK;
    property PathToAndroidSDK: string read FPathToAndroidSDK write FPathToAndroidSDK;
    property PathToAndroidNDK: string read FPathToAndroidNDK write FPathToAndroidNDK;
    property PathToAntBin: string read FPathToAntBin write FPathToAntBin;
    property ProjectModel: string read FProjectModel write FProjectModel; {eclipse or ant}
    property PackagePrefaceName: string read FPackagePrefaceName write FPackagePrefaceName;
    property MinApi: string read FMinApi write FMinApi;
    property TargetApi: string read FTargetApi write FTargetApi;
    property TouchtestEnabled: string read FTouchtestEnabled write FTouchtestEnabled;
    property AntBuildMode: string read FAntBuildMode write FAntBuildMode;
    property MainActivity: string read FMainActivity write FMainActivity;
    property NDK: string read FNDK write FNDK;
    property AndroidPlatform: string read FAndroidNdkPlatform write FAndroidNdkPlatform;
    property SupportV4: string read FSupportV4 write FSupportV4;
    property PrebuildOSYS: string read FPrebuildOSYS write FPrebuildOSYS;
    property FullJavaSrcPath: string read FFullJavaSrcPath write FFullJavaSrcPath;
    property JavaClassName: string read   FJavaClassName write FJavaClassName;
    property ModuleType: integer read FModuleType write FModuleType;  //0: GUI project   1: NoGui project
    property SmallProjName: string read FSmallProjName write FSmallProjName;
    property AndroidTheme: string read FAndroidTheme write FAndroidTheme;
  end;


  function TrimChar(query: string; delimiter: char): string;
  function SplitStr(var theString: string; delimiter: string): string;

var
   FormWorkspace: TFormWorkspace;

implementation

{$R *.lfm}

{ TFormWorkspace }

function TFormWorkspace.GetCodeNameByApi(api: string):string;
begin
  Result:= 'Unknown';
  if api='8' then Result:= 'Froyo 2.2'
  else if api='10' then Result:= 'Gingerbread 2.3'
  else if api='14' then Result:= 'IceCream 4.0'
  else if api='15' then Result:= 'IceCream 4.0x'
  else if api='16' then Result:= 'JellyBean 4.1'
  else if api='17' then Result:= 'JellyBean 4.2'
  else if api='18' then Result:= 'JellyBean 4.3'
  else if api='19' then Result:= 'KitKat 4.4'
  else if api='20' then Result:= 'KitKat 4.4x'
  else if api='21' then Result:= 'Lollipop 5.0'
  else if api='22' then Result:= 'Lollipop 5.1'
  else if api='23' then Result:= 'Marshmallow 6.0';
end;

procedure TFormWorkspace.ListBoxMinSDKClick(Sender: TObject);
begin
    FMinApi:= ListBoxMinSDK.Items.Strings[ListBoxMinSDK.ItemIndex]
end;

//http://developer.android.com/about/dashboards/index.html
function TFormWorkspace.GetTextByListIndex(index:integer): string;
begin
   Result:= '';
   case index of
     0: Result:= 'Froyo 2.2'; // Api(8)    -Froyo 2.2
     1: Result:= 'Gingerbread 2.3'; // Api(10)   -Gingerbread 2.3
     2: Result:= 'IceCream 4.0'; // Api(15)  -Ice Cream 4.0x
     3: Result:= 'JellyBean 4.1'; // Api(16)  -Jelly Bean 4.1
     4: Result:= 'JellyBean 4.2'; // Api(17)  -Jelly Bean 4.2
     5: Result:= 'JellyBean 4.3'; // Api(18)  -Jelly Bean 4.3
     6: Result:= 'KitKat 4.4'; // Api(19)  -KitKat 4.4
     7: Result:= 'KitKat 4.4W'; // Api(20)  -KitKat 4.4
     8: Result:= 'Lollipop 5.0'; // Api(21)  -Lollipop [5.0]
     9: Result:= 'Lollipop 5.1'; // Api(22)  -Lollipop [5.1]
   end;
end;

procedure TFormWorkspace.ListBoxMinSDKSelectionChange(Sender: TObject; User: boolean);
begin
  StatusBarInfo.Panels.Items[1].Text:= 'MinSdk: '+GetTextByListIndex(ListBoxMinSDK.ItemIndex);
end;

procedure TFormWorkspace.ListBoxPlatformSelectionChange(Sender: TObject;
  User: boolean);
begin
  StatusBarInfo.Panels.Items[0].Text:='Ndk: '+ GetCodeNameByApi(ListBoxPlatform.Items[ListBoxPlatform.ItemIndex]);
end;

procedure TFormWorkspace.ListBoxTargetAPIClick(Sender: TObject);
begin
  FTargetApi:= ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex];
end;

procedure TFormWorkspace.ListBoxTargetAPISelectionChange(Sender: TObject; User: boolean);
begin
  StatusBarInfo.Panels.Items[2].Text:='Target: '+ GetCodeNameByApi(ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex]);
end;

procedure TFormWorkspace.ListBoxPlatformClick(Sender: TObject);
begin
  FAndroidNdkPlatform:= 'android-'+ListBoxPlatform.Items[ListBoxPlatform.ItemIndex]
end;


procedure TFormWorkspace.RGInstructionClick(Sender: TObject);
begin
  FInstructionSet:= RGInstruction.Items[RGInstruction.ItemIndex];  //fix 15-december-2013
end;

procedure TFormWorkspace.RGFPUClick(Sender: TObject);
begin
  FFPUSet:= RGFPU.Items[RGFPU.ItemIndex];  //fix 15-december-2013
end;

function TFormWorkspace.GetNDKPlatform(identName: string): string;
begin
    Result:= 'android-14'; //default
         if identName = 'Froyo'          then Result:= 'android-8'
    else if identName = 'Gingerbread'    then Result:= 'android-13'
    else if identName = 'Ice Cream 4.0x' then Result:= 'android-15'
    else if identName = 'Jelly Bean 4.1' then Result:= 'android-16'
    else if identName = 'Jelly Bean 4.2' then Result:= 'android-17'
    else if identName = 'Jelly Bean 4.3' then Result:= 'android-18'
    else if identName = 'KitKat 4.4'     then Result:= 'android-19'
    else if identName = 'Lollipop 5.0'   then Result:= 'android-21';
end;

function TFormWorkspace.GetNDKPlatformByApi(api: string): string;
begin
  Result:= 'android-'+api;
end;


function TFormWorkspace.GetFullJavaSrcPath(fullProjectName: string): string;
var
  strList: TStringList;
  count: integer;
  path: string;

begin
    strList:= TStringList.Create;
    path:= fullProjectName+DirectorySeparator+'src';
    FindAllDirectories(strList, path, False);
    count:= strList.Count;
    while count > 0 do
    begin
       path:= strList.Strings[0];
       strList.Clear;
       FindAllDirectories(strList, path, False);
       count:= strList.Count;
    end;
    Result:= path;
    strList.Free;
end;

procedure TFormWorkspace.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  strList: TStringList;
  count, i, j, apiTarg: integer;
  path: string;
  aList: TStringList;
begin

  SaveSettings(FFileName);
  if ModalResult = mrCancel  then Exit;

  apiTarg:=  StrToInt(FTargetApi);

  if apiTarg < 11 then
    FAndroidTheme:= 'Light'
  else if (apiTarg >= 11) and  (apiTarg < 14) then
    FAndroidTheme:= 'Holo.Light'
  else
    FAndroidTheme:= 'DeviceDefault';

  if ComboBoxTheme.Text <> 'DeviceDefault' then
    FAndroidTheme:= ComboBoxTheme.Text;

  if EditPathToWorkspace.Text = '' then
  begin
    ShowMessage('Error! Workspace Path was missing....[Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  if ComboSelectProjectName.Text = '' then
  begin
    ShowMessage('Error! Projec Name was missing.... [Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  FPathToWorkspace:= Trim(EditPathToWorkspace.Text);
  FJavaClassName:= 'Controls'; //GUI  [try guess]

  if Pos(DirectorySeparator, ComboSelectProjectName.Text) <= 0 then
  begin
     FProjectModel:= 'Ant';   //project not exits!
     FSmallProjName:= Trim(ComboSelectProjectName.Text);
     FAndroidProjectName:= FPathToWorkspace + DirectorySeparator+ FSmallProjName;
       FPackagePrefaceName:= LowerCase(Trim(EditPackagePrefaceName.Text));
       if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lamw';
       if FModuleType = 1 then //NoGUI
          FJavaClassName:=  FSmallProjName;
  end
  else
  begin
     FProjectModel:= 'Eclipse';  //project exits!
     FAndroidProjectName:= Trim(ComboSelectProjectName.Text);
     aList:= TStringList.Create;
     aList.StrictDelimiter:= True;
     aList.Delimiter:= DirectorySeparator;
     aList.DelimitedText:= TrimChar(FAndroidProjectName, DirectorySeparator);
     FSmallProjName:=  aList.Strings[aList.Count-1];; //ex. "AppTest1"
     FPackagePrefaceName:= '';
     aList.Free;
     if FModuleType = 1 then  //NoGUI
       FJavaClassName:=  FSmallProjName //ex. "AppTest1"
  end;

  FMainActivity:= 'App'; {dummy for Simon template} //TODO: need name flexibility here...

  FAndroidNdkPlatform:= GetNDKPlatformByApi(ListBoxPlatform.Items.Strings[ListBoxPlatform.ItemIndex]); //(ListBoxPlatform.Items.Strings[ListBoxPlatform.ItemIndex]);

  if FProjectModel = 'Eclipse' then
  begin
     strList:= TStringList.Create;
     path:= FAndroidProjectName+DirectorySeparator+'src';
     FindAllDirectories(strList, path, False);

     count:= strList.Count;
     while count > 0 do
     begin
         path:= strList.Strings[0];
         strList.Clear;
         FindAllDirectories(strList, path, False);
         count:= strList.Count;
     end;

     strList.Clear;
     strList.Delimiter:= DirectorySeparator;
     strList.DelimitedText:= path;

     i:= 0;
     path:=strList.Strings[i];
     while path <> 'src' do
     begin
         i:= i+1;
         path:= strList.Strings[i];
     end;

     path:='';
     for j:= (i+1) to strList.Count-2 do
     begin
         path:= path + '.' + strList.Strings[j];
     end;

     FPackagePrefaceName:= TrimChar(path, '.');
     strList.Free;

     FFullJavaSrcPath:=GetFullJavaSrcPath(FAndroidProjectName);
  end;

  if FProjectModel = 'Ant' then
  begin
    if DirectoryExists(FAndroidProjectName) then   //if project exits
    begin
       if MessageDlg('Projec/Directory already Exists!',
         'Re-Create "'+FAndroidProjectName+'" ?', mtConfirmation, [mbYes, mbNo],0) = mrNo then
       begin
         ModalResult:= mrCancel;
       end;
    end
    else
    begin
      MkDir(FAndroidProjectName);
      ChDir(FAndroidProjectName);

      MkDir(FAndroidProjectName+ DirectorySeparator + 'jni');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'jni');

      MkDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');

      MkDir(FAndroidProjectName+ DirectorySeparator + 'libs');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'libs');

      if FSupportV4 = 'yes' then  //add "android 4.0" support to olds devices ...
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar',
                 FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar');

      MkDir(FAndroidProjectName+ DirectorySeparator + 'obj');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'obj');

      MkDir(FAndroidProjectName+ DirectorySeparator + 'obj'+DirectorySeparator+LowerCase(FJavaClassName));
      ChDir(FAndroidProjectName+DirectorySeparator+ 'obj'+DirectorySeparator+LowerCase(FJavaClassName));

      MkDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'x86');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'libs'+DirectorySeparator+'x86');

      MkDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'libs'+DirectorySeparator+'armeabi');

      MkDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi-v7a');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'libs'+DirectorySeparator+'armeabi-v7a');
    end;
  end;
end;

procedure TFormWorkspace.FormCreate(Sender: TObject);
var
  fileName: string;
begin
  fileName:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if not FileExistsUTF8(fileName) then
  begin
    SaveSettings(fileName);  //force to create empty/initial file!
  end;
end;

procedure TFormWorkspace.LoadPathsSettings(const fileName: string);
var
  indexNdk: integer;
  frm: TFormPathMissing;
  frmSys: TFormOSystem;
begin
  if FileExistsUTF8(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      FPathToJavaJDK:= ReadString('NewProject','PathToJavaJDK', '');
      if  FPathToJavaJDK = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Java JDK: [ex. C:\Program Files (x86)\Java\jdk1.7.0_21]';
          if frm.ShowModal = mrOK then
          begin
             FPathToJavaJDK:= frm.PathMissing;
             frm.Free;
          end
          else
          begin
             frm.Free;
             Exit;
          end;
      end;

      FPathToAntBin:= ReadString('NewProject','PathToAntBin', '');
      if  FPathToAntBin = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Ant bin: [ex. C:\adt32\ant\bin]';
          if frm.ShowModal = mrOK then
          begin
             FPathToAntBin:= frm.PathMissing;
             frm.Free;
          end
          else
          begin
             frm.Free;
             Exit;
          end;
      end;

      FPathToAndroidSDK:= ReadString('NewProject','PathToAndroidSDK', '');
      if  FPathToAndroidSDK = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Android SDK: [ex. C:\adt32\sdk]';
          if frm.ShowModal = mrOK then
          begin
             FPathToAndroidSDK:= frm.PathMissing;
             frm.Free;
          end
          else
          begin
             frm.Free;
             Exit;
          end;
      end;

      FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');
      if FPrebuildOSYS = '' then
      begin
          frmSys:= TFormOSystem.Create(nil);
          //frm.LabelPathTo.Caption:= 'WARNING! Enter Your System:  [ex. windows or linux-x86 or linux-x86_64 ...]';
          if frmSys.ShowModal = mrOK then
          begin
             FPrebuildOSYS:= frmSys.PrebuildOSYS;
             frmSys.Free;
          end
          else
          begin
             frmSys.Free;
             Exit;
          end;
      end;

      FPathToAndroidNDK:= ReadString('NewProject','PathToAndroidNDK', '');
      if  FPathToAndroidNDK = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Android NDK:  [ex. C:\adt32\ndk10]';
          if frm.ShowModal = mrOK then
          begin
             FPathToAndroidNDK:= frm.PathMissing;
             frm.Free;
          end
          else
          begin
             frm.Free;
             Exit;
          end;
      end;

      indexNdk:= StrToIntDef(ReadString('NewProject','NDK', ''), 3); //ndk 10e   ... default

      case indexNdk of
         0: FNDK:= '7';
         1: FNDK:= '9';
         2: FNDK:= '10c'; //old Laz4Android
         3: FNDK:= '10e';
      end;

      FPathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');
      if  FPathToJavaTemplates = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Java templates: [ex. ..\LazAndroidWizard\java]';
          if frm.ShowModal = mrOK then
          begin
             FPathToJavaTemplates:= frm.PathMissing;
             frm.Free;
          end
          else
          begin
             frm.Free;
             Exit;
          end;
      end;

      CheckBox1.Checked:= False;
      FSupportV4:= ReadString('NewProject','SupportV4', '');
      if FSupportV4 = 'yes' then CheckBox1.Checked:= True
      else FSupportV4 := 'no';
    finally
      Free;
    end;
  end;
end;

procedure TFormWorkspace.FormActivate(Sender: TObject);
var
  lisDir: TStringList;
  auxStr1: string;
  i: integer;
begin
        //C:\adt32\sdk\platforms
  lisDir:= TStringList.Create;

  ListBoxTargetAPI.Clear;
  FindAllDirectories(lisDir, FPathToAndroidSDK+PathDelim+'platforms', False);
  if lisDir.Count > 0 then
  begin
    for i:=0 to  lisDir.Count-1 do
    begin
       auxStr1:= lisDir.Strings[i];
       auxStr1 := Copy(auxStr1, LastDelimiter('-', auxStr1) + 1, MaxInt);
       ListBoxTargetAPI.Items.Add(auxStr1);
    end;
    if FIndexTargetApi < 0  then FIndexTargetApi:= 0;

    if FIndexTargetApi > (ListBoxTargetAPI.Count-1) then
       FIndexTargetApi:= ListBoxTargetAPI.Count-1;

    ListBoxTargetAPI.ItemIndex:= FIndexTargetApi;
    FTargetApi:= ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex]
  end
  else
  begin
    ShowMessage('Fail! '+'Folder "'+FPathToAndroidSDK+DirectorySeparator+'platforms" is Empty!!');
    lisDir.Free;
    Exit;
  end;

  lisDir.Clear;
  ListBoxPlatform.Clear;
  FindAllDirectories(lisDir, FPathToAndroidNDK+PathDelim+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to  lisDir.Count-1 do
    begin
       auxStr1:= lisDir.Strings[i];
       auxStr1 := Copy(auxStr1, LastDelimiter('-', auxStr1) + 1, MaxInt);

       if auxStr1 <> '' then
         if StrToInt(auxStr1) > 13 then
            ListBoxPlatform.Items.Add(auxStr1);
    end;

    if FIndexNdkPlatformApi < 0  then FIndexNdkPlatformApi:= 0;

    if FIndexNdkPlatformApi > (ListBoxPlatform.Count-1) then
       FIndexNdkPlatformApi:= ListBoxPlatform.Count-1;

    ListBoxPlatform.ItemIndex:= FIndexNdkPlatformApi;
    FAndroidNdkPlatform:= 'android-'+ListBoxPlatform.Items[ListBoxPlatform.ItemIndex]

  end
  else
  begin
    ShowMessage('Fail! '+'Folder "'+FPathToAndroidNDK+DirectorySeparator+'platforms" is Empty!!');
    lisDir.Free;
    Exit;
  end;

  lisDir.Free;

  if EditPathToWorkspace.Text <> '' then
     ComboSelectProjectName.SetFocus
  else EditPathToWorkspace.SetFocus;

  if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lamw';

  StatusBarInfo.Panels.Items[0].Text:='Ndk: '+ GetCodeNameByApi(ListBoxPlatform.Items[ListBoxPlatform.ItemIndex]);
  StatusBarInfo.Panels.Items[1].Text:= 'MinSdk: '+GetTextByListIndex(ListBoxMinSDK.ItemIndex);
  StatusBarInfo.Panels.Items[2].Text:='Target: '+ GetCodeNameByApi(ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex]);

  ListBoxPlatform.MakeCurrentVisible;
  ListBoxMinSDK.MakeCurrentVisible;
  ListBoxTargetAPI.MakeCurrentVisible;
end;

procedure TFormWorkspace.CheckBox1Click(Sender: TObject);
begin
    if  CheckBox1.Checked then FSupportV4:= 'yes'
    else FSupportV4:= 'no';
end;

procedure TFormWorkspace.ComboBoxThemeChange(Sender: TObject);
var
  api21Index, api, apiTarget, i: integer;
begin
  apiTarget:= StrToInt(ListBoxTargetAPI.GetSelectedText);

  if apiTarget < 11 then
  begin
    ShowMessage('Warning:'+
                 #10#13+'"Holo Theme" need TargetSdkApi >= 11'+ //TODO: Theme.Holo.NoActionBar.Fullscreen
                 #10#13+'"Holo Theme + ActionBar" need TargetSdkApi >= 14'+
                 #10#13+'"Material Theme" need TargetSdkApi >= 21');
    ComboBoxTheme.ItemIndex:= 0; //default
    Exit;
  end;

  if (apiTarget < 14) and (Pos('ActionBar', ComboBoxTheme.Text) > 0) then
  begin
    ShowMessage('Warning:'+
                 #10#13+'"Holo Theme + ActionBar" need TargetSdkApi >= 14');
    ComboBoxTheme.ItemIndex:= 0; //default
    Exit;
  end;

  if (apiTarget < 21) and
     (Pos('Material', ComboBoxTheme.Text) > 0) then
  begin
        api21Index:= -1;
        for i:=0 to ListBoxTargetAPI.Count-1 do
        begin
            api:= StrToInt(ListBoxTargetAPI.Items.Strings[i]);
            if   api >= 21 then
            begin
              api21Index:= i;
              if api = 21 then
              begin
                 break;
               end;
            end
        end;
        if api21Index <> -1 then
        begin
          ListBoxTargetAPI.ItemIndex:= api21Index;
          ShowMessage('Warning: TargetSdkApi changed to ['+ListBoxTargetAPI.GetSelectedText+']');
        end
        else
        begin
          ShowMessage('Warning: "Material Theme" need TargetSdkApi >= 21!');
          ComboBoxTheme.ItemIndex:= 0; //default
        end;
  end;
end;

procedure TFormWorkspace.ComboSelectProjectNameKeyPress(Sender: TObject;
  var Key: char);
begin
  if (ComboSelectProjectName.Text <> '') and (Key = #13) then
  begin
    Key := #0;
    BitBtnOK.SetFocus;
  end;
end;

procedure TFormWorkspace.SpdBtnPathToWorkspaceClick(Sender: TObject);
begin
  if SelDirDlgPathToWorkspace.Execute then
  begin
    EditPathToWorkspace.Text := SelDirDlgPathToWorkspace.FileName;
    FPathToWorkspace:= SelDirDlgPathToWorkspace.FileName;
    ComboSelectProjectName.Items.Clear;
    FindAllDirectories(ComboSelectProjectName.Items, FPathToWorkspace, False);

  end;
end;

procedure TFormWorkspace.SpdBtnRefreshProjectNameClick(Sender: TObject);
begin
  FPathToWorkspace:= EditPathToWorkspace.Text;
  ComboSelectProjectName.Items.Clear;
  FindAllDirectories(ComboSelectProjectName.Items, FPathToWorkspace, False);
end;

procedure TFormWorkspace.SpeedButton1Click(Sender: TObject);
begin
  ShowMessage('Lamw: Lazarus Android Module Wizard' +#10#13+ '[ver. 0.6 - rev. 36 - 03 August 2015]');
end;

procedure TFormWorkspace.SpeedButtonHintThemeClick(Sender: TObject);
begin
  ShowMessage('Warning:'+
               #10#13+'"Holo Theme" need TargetSdkApi >= 11'+
               #10#13+'"Holo Theme + ActionBar" need TargetSdkApi >= 14'+
               #10#13+'"Material Theme" need TargetSdkApi >= 21'+
               #10#13+' ' +
               #10#13+'Old Projects [target >= 11]:'+
               #10#13+'Go to ..\res\values-vXX'+
               #10#13+'and modifier "styles.xml" [parent attribute]'+
               #10#13+'Example:'+
               #10#13+'<style name="AppBaseTheme" parent="android:Theme.Holo.Light">');
end;

procedure TFormWorkspace.LoadSettings(const pFilename: string);  //called by
var
  i1, i2, i3, i5, j1{, j2, j3}: integer;
begin
  FFileName:= pFilename;
  with TIniFile.Create(pFilename) do
  try
    FPathToWorkspace:= ReadString('NewProject','PathToWorkspace', '');
    FPackagePrefaceName:= ReadString('NewProject','AntPackageName', '');

    FAntBuildMode:= 'debug'; //default...
    FTouchtestEnabled:= 'True'; //default

    FMainActivity:= ReadString('NewProject','MainActivity', '');  //dummy
    if FMainActivity = '' then FMainActivity:= 'App';

    i5:= StrToIntDef(ReadString('NewProject','NDK', ''), 2);  //ndk 10
    ListBoxPlatform.Clear;


    i1:= StrToIntDef(ReadString('NewProject','InstructionSet', ''), 0);

    i2:= StrToIntDef(ReadString('NewProject','FPUSet', ''), 0);

    i3:= StrToIntDef(ReadString('NewProject','ProjectModel', ''), 0);

    j1:= StrToIntDef(ReadString('NewProject','MinApi', ''), 2); // default Api 14

    if (j1 >= 0) and (j1 < ListBoxMinSDK.Items.Count) then
       ListBoxMinSDK.ItemIndex:= j1
    else
       ListBoxMinSDK.ItemIndex:= ListBoxMinSDK.Items.Count-1;

    FIndexNdkPlatformApi:= StrToIntDef(ReadString('NewProject','AndroidPlatform', ''), 0);

    FIndexTargetApi:= StrToIntDef(ReadString('NewProject','TargetApi', ''), 0); //default index 0

    ComboSelectProjectName.Items.Clear;
    FindAllDirectories(ComboSelectProjectName.Items, FPathToWorkspace, False);

    FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');
  finally
    Free;
  end;

  RGInstruction.ItemIndex:= i1;
  RGFPU.ItemIndex:= i2;

  if i3 = 0 then FProjectModel:= 'Eclipse'
  else FProjectModel:= 'Ant';

  FInstructionSet:= RGInstruction.Items[RGInstruction.ItemIndex];
  FFPUSet:= RGFPU.Items[RGFPU.ItemIndex];

  FMinApi:= ListBoxMinSDK.Items[ListBoxMinSDK.ItemIndex];

  EditPathToWorkspace.Text := FPathToWorkspace;

  EditPackagePrefaceName.Text := FPackagePrefaceName;

  //verify if some was not load!
  Self.LoadPathsSettings(FFileName);

end;

procedure TFormWorkspace.SaveSettings(const pFilename: string);
begin
   with TInifile.Create(pFilename) do
   try
      WriteString('NewProject', 'PathToWorkspace', EditPathToWorkspace.Text);

      WriteString('NewProject', 'FullProjectName', FAndroidProjectName);
      WriteString('NewProject', 'InstructionSet', IntToStr(RGInstruction.ItemIndex));
      WriteString('NewProject', 'FPUSet', IntToStr(RGFPU.ItemIndex));

      if  FProjectModel = 'Ant' then            //IntToStr(RGProjectType.ItemIndex)
        WriteString('NewProject', 'ProjectModel', '1')  //Ant
      else
        WriteString('NewProject', 'ProjectModel','0');  //Eclipse


      if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lamw';
        WriteString('NewProject', 'AntPackageName', LowerCase(Trim(EditPackagePrefaceName.Text)));

      if ListBoxPlatform.ItemIndex < 0 then
        WriteString('NewProject', 'AndroidPlatform', '1')    //ndk plataform
      else
        WriteString('NewProject', 'AndroidPlatform', IntToStr(ListBoxPlatform.ItemIndex));


      WriteString('NewProject', 'MinApi', IntToStr(ListBoxMinSDK.ItemIndex));
      WriteString('NewProject', 'TargetApi', IntToStr(ListBoxTargetAPI.ItemIndex));

      WriteString('NewProject', 'AntBuildMode', 'debug'); //default...

      if FMainActivity = '' then FMainActivity:= 'App';
      WriteString('NewProject', 'MainActivity', FMainActivity); //dummy

      WriteString('NewProject', 'SupportV4', FSupportV4); //dummy

      WriteString('NewProject', 'PathToJavaTemplates', FPathToJavaTemplates);
      WriteString('NewProject', 'PathToJavaJDK', FPathToJavaJDK);
      WriteString('NewProject', 'PathToAndroidNDK', FPathToAndroidNDK);
      WriteString('NewProject', 'PathToAndroidSDK', FPathToAndroidSDK);
      WriteString('NewProject', 'PathToAntBin', FPathToAntBin);

      WriteString('NewProject', 'PrebuildOSYS', FPrebuildOSYS);
   finally
      Free;
   end;
end;

function TrimChar(query: string; delimiter: char): string;
var
  auxStr: string;
  count: integer;
  newchar: char;
begin
  newchar:=' ';
  if query <> '' then
  begin
      auxStr:= Trim(query);
      count:= Length(auxStr);
      if count >= 2 then
      begin
         if auxStr[1] = delimiter then  auxStr[1] := newchar;
         if auxStr[count] = delimiter then  auxStr[count] := newchar;
      end;
      Result:= Trim(auxStr);
  end;
end;

function SplitStr(var theString: string; delimiter: string): string;
var
  i: integer;
begin
  Result:= '';
  if theString <> '' then
  begin
    i:= Pos(delimiter, theString);
    if i > 0 then
    begin
       Result:= Copy(theString, 1, i-1);
       theString:= Copy(theString, i+Length(delimiter), maxLongInt);
    end
    else
    begin
       Result:= theString;
       theString:= '';
    end;
  end;
end;


end.

