unit uformsettingspaths;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, LazIDEIntf, PackageIntf {, process, math};

type

  { TFormSettingsPaths }

  TFormSettingsPaths  = class(TForm)
    BevelJDKAntAndSDKNDK: TBevel;
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    ComboBoxPrebuild: TComboBox;
    EditPathToGradle: TEdit;
    EditPathToAndroidSDK: TEdit;
    EditPathToJavaJDK: TEdit;
    EditPathToAndroidNDK: TEdit;
    EditPathToAntBinary: TEdit;
    GroupBox1: TGroupBox;
    Image1: TImage;
    LabelNDKRelease: TLabel;
    LabelPathToGradle: TLabel;
    LabelPathToAndroidSDK: TLabel;
    LabelPathToJavaJDK: TLabel;
    LabelPathToAndroidNDK: TLabel;
    LabelPathToAntBinary: TLabel;
    SelDirDlgPathTo: TSelectDirectoryDialog;
    SpBPathToAndroidSDK: TSpeedButton;
    SpBPathToJavaJDK: TSpeedButton;
    SpBPathToAndroidNDK: TSpeedButton;
    SpBPathToAntBinary: TSpeedButton;
    SpBPathToGradle: TSpeedButton;
    SpeedButtonHelp: TSpeedButton;
    SpeedButtonInfo: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure ComboBoxPrebuildChange(Sender: TObject);
    procedure EditPathToAndroidNDKExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpBPathToAndroidSDKClick(Sender: TObject);
    procedure SpBPathToGradleClick(Sender: TObject);
    procedure SpBPathToJavaJDKClick(Sender: TObject);
    procedure SpBPathToAndroidNDKClick(Sender: TObject);
    procedure SpBPathToAntBinaryClick(Sender: TObject);
    procedure SpeedButtonHelpClick(Sender: TObject);
    procedure SpeedButtonInfoClick(Sender: TObject);
    function GetGradleVersion(out tagVersion: integer): string;
    function GetMaxSdkPlatform(): integer;
    function HasBuildTools(platform: integer): boolean;
    function GetPathToSmartDesigner(): string;
  private
    { private declarations }
    FPathToJavaTemplates: string;
    FPathToSmartDesigner: string;
    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
    FPrebuildOSYS: string;
    FPathToGradle: string;
    FNDKIndex: integer; {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
    FNDKRelease: string; // 18.1.506304
    procedure WriteIniString(Key, Value: string);

  public
    { public declarations }
    FOk: boolean;
    //FPathTemplatesEdited: boolean;
    procedure LoadSettings(const fileName: string);
    procedure SaveSettings(const fileName: string);
    function GetPrebuiltDirectory: string;
    function TryGetNDKRelease(pathNDK: string): string;
    function GetNDKVersionItemIndex(ndkRelease: string): integer;

  end;

var
   FormSettingsPaths: TFormSettingsPaths;

implementation

uses LamwSettings;

{$R *.lfm}

{ TFormSettingsPaths }

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


function TFormSettingsPaths.GetPrebuiltDirectory: string;
var
   pathToNdkToolchains49: string;  //FInstructionSet   [ARM or x86]
begin
    Result:= '';
    if FPathToAndroidNDK = '' then Exit;

    pathToNdkToolchains49:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;
    {$ifdef windows}
     Result:=  'windows';
     if DirectoryExists(pathToNdkToolchains49+ 'windows-x86_64') then Result:= 'windows-x86_64';
   {$else}
     {$ifdef darwin}
        Result:=  '';
        if DirectoryExists(pathToNdkToolchains49+ 'darwin-x86_64') then Result:= 'darwin-x86_64';
     {$else}
       {$ifdef linux}
         Result:=  'linux-x86_32';
         if DirectoryExists(pathToNdkToolchains49+ 'linux-x86_64') then Result:= 'linux-x86_64';
       {$endif}
     {$endif}
   {$endif}

   if Result = '' then
   begin
       {$ifdef WINDOWS}
         Result:= 'windows-x86_64';
       {$endif}
       {$ifdef LINUX}
           Result:= 'linux-x86_64';
       {$endif}
       {$ifdef darwin}
           Result:= 'darwin-x86_64';
       {$endif}
   end;

end;

function TFormSettingsPaths.TryGetNDKRelease(pathNDK: string): string;
var
   list: TStringList;
   aux, strNdkVersion: string;
begin
    list:= TStringList.Create;
    if FileExists(pathNDK+DirectorySeparator+'source.properties') then
    begin
        list.LoadFromFile(pathNDK+DirectorySeparator+'source.properties');
        {
           Pkg.Desc = Android NDK
           Pkg.Revision = 18.1.5063045
        }
        strNdkVersion:= list.Strings[1]; //Pkg.Revision = 18.1.5063045
        aux:= SplitStr(strNdkVersion, '='); //aux:= 'Pkg.Revision '   ...strNdkVersion:=' 18.1.506304'
        Result:= Trim(strNdkVersion); //18.1.506304

    end
    else
    begin
       if FileExists(pathNDK+DirectorySeparator+'RELEASE.TXT') then //r10e
       begin
         list.LoadFromFile(pathNDK+DirectorySeparator+'RELEASE.TXT');
         if Trim(list.Strings[0]) = 'r10e' then
            Result:= 'r10e'
         else
         begin
            Result:= 'unknown';
         end;
       end;
    end;
    list.Free;
end;

function TFormSettingsPaths.GetNDKVersionItemIndex(ndkRelease: string): integer;
var
   strNdkVersion: string;
   intNdkVersion: integer;
begin

    if Pos('.',ndkRelease) > 0 then  //18.1.506304
    begin
      strNdkVersion:= SplitStr(ndkRelease, '.'); //strNdkVersion:='18'
      if strNdkVersion <> '' then
      begin
        intNdkVersion:= StrToInt(Trim(strNdkVersion));

        {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
        if intNdkVersion = 11 then Result:= 4
        else if (intNdkVersion > 11) and (intNdkVersion < 22) then Result:= 5
        else if intNdkVersion >= 22 then Result:= 6;

      end;
    end
    else if ndkRelease = 'r10e' then Result:= 3
    else Result := 2; //unknown
end;

//C:\adt32\gradle-4.2.1
//C:\adt32\gradle-3.3
function TFormSettingsPaths.GetGradleVersion(out tagVersion: integer): string;
var
   p: integer;
   strAux: string;
   numberAsString: string;
   userString: string;
begin
  Result:='';
  strAux:= Trim(ExcludeTrailingPathDelimiter(EditpathToGradle.Text));  // C:\adt32\gradle-3.3
  if strAux <> '' then
  begin
     p:= LastDelimiter(PathDelim, strAux);
     strAux:= Copy(strAux, p+1, MaxInt);  //gradle-3.3

     p:=1;
     //skip characters that do not represent a version number
     while (p<=Length(strAux)) AND (NOT (strAux[p] in ['0'..'9','.'])) do Inc(p);
     if (p<=Length(strAux)) then
     begin
        Result:= Copy(strAux, p, MaxInt);  // 3.3
        numberAsString:= StringReplace(Result,'.', '', [rfReplaceAll]); // 33
        if Length(numberAsString) < 3 then
        begin
           numberAsString:= numberAsString+ '0'  //330
        end;
        tagVersion:= StrToInt(Trim(numberAsString));
     end;
  end;

  if Result = '' then
  begin
    userString:= '3.3';
    if InputQuery('Gradle', 'Please, Enter Gradle Version', userString) then
    begin
      Result:= Trim(UserString);  // 3.3
      numberAsString:= StringReplace(Result,'.', '', [rfReplaceAll]); // 33
      if Length(numberAsString) < 3 then
      begin
         numberAsString:= numberAsString+ '0'  //330
      end;
      tagVersion:= StrToInt(Trim(numberAsString));
    end;
  end;

end;

procedure TFormSettingsPaths.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
   fName: string;
begin
  fName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini';
  if FOk then
  begin
    {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
    if FNDKIndex < 3 then
    begin
      ShowMessage('WARNING... Please, update NDK.... ');
    end;
    SaveSettings(fName);
    LamwGlobalSettings.ReloadPaths;
  end;
end;

procedure TFormSettingsPaths.FormShow(Sender: TObject);
var
 flag: boolean;
begin
  //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
  FPathToSmartDesigner:= GetPathToSmartDesigner();

  //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner\java
  FPathToJavaTemplates:= FPathToSmartDesigner  + PathDelim + 'java';

  flag:= false;
  if not FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini') then
  begin
    if FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini') then
    begin
       CopyFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini',
                IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
       flag:= True;
    end;
  end;

  if flag then  //exists  'LAMW.ini'
  begin
    WriteIniString('PathToJavaTemplates', FPathToJavaTemplates);
    WriteIniString('PathToSmartDesigner', FPathToSmartDesigner);
  end;

  LoadSettings(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');

  FOk:= False;

  {$ifdef windows}
  ComboBoxPrebuild.Items.Add('windows');
  ComboBoxPrebuild.Items.Add('windows-x86_64');
  if Self.FPrebuildOSYS <> '' then
      ComboBoxPrebuild.Text:= FPrebuildOSYS
  else
     ComboBoxPrebuild.Text:= 'windows-x86_64';
  {$endif}

  {$ifdef linux}
  ComboBoxPrebuild.Items.Add('linux-x86_32');
  ComboBoxPrebuild.Items.Add('linux-x86_64');
  if Self.FPrebuildOSYS <> '' then
      ComboBoxPrebuild.Text:= FPrebuildOSYS
  else
     ComboBoxPrebuild.Text:= 'linux-x86_64';
  {$endif}

  {$ifdef darwin}
  ComboBoxPrebuild.Items.Add('darwin-x86_64');
  ComboBoxPrebuild.Text:= 'darwin-x86_64';
  {$endif}

  EditPathToJavaJDK.SetFocus;

  {$ifdef darwin}
    if EditPathToJavaJDK.Text = '' then
       EditPathToJavaJDK.Text:= '${/usr/libexec/java_home}';
  {$endif}

end;

function TFormSettingsPaths.HasBuildTools(platform: integer): boolean;
var
  lisDir: TStringList;
  numberAsString, auxStr: string;
  i, builderNumber: integer;
begin
  Result:= False;
  lisDir:= TStringList.Create;   //C:\adt32\sdk\build-tools\19.1.0

  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'build-tools', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= ExtractFileName(lisDir.Strings[i]);
       lisDir.Strings[i]:=auxStr;
    end;
    lisDir.Sorted:=True;
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= lisDir.Strings[i];
       if  auxStr <> '' then
       begin
         if  Pos('rc2', auxStr) = 0  then   //escape some alien...
         begin
           numberAsString:= Copy(auxStr, 1 , 2);  //19
           builderNumber:=  StrToInt(numberAsString);
           if  platform <= builderNumber then
           begin
             Result:= True;
             break;
           end;
         end;
       end;
    end;
  end;
  lisDir.free;
end;

procedure TFormSettingsPaths.WriteIniString(Key, Value: string);
var
  FIniFile: TIniFile;
begin
  FIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
  if FIniFile <> nil then
  begin
    FIniFile.WriteString('NewProject', Key, Value);
    FIniFile.Free;
    LamwGlobalSettings.ReloadPaths;
  end;
end;

function TFormSettingsPaths.GetPathToSmartDesigner(): string;
var
  Pkg: TIDEPackage;
begin
  Result:= '';
  Pkg:=PackageEditingInterface.FindPackageWithName('lazandroidwizardpack');
  if Pkg<>nil then
  begin
      Result:= ExtractFilePath(Pkg.Filename);
      Result:= Result + 'smartdesigner';
      //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
  end;
end;

procedure TFormSettingsPaths.BitBtnCancelClick(Sender: TObject);
begin
  FOK:=False;
  Close;
end;

procedure TFormSettingsPaths.ComboBoxPrebuildChange(Sender: TObject);
var
 pathToNdkToolchains49: string;
 saveContent: string;
begin
  if EditPathToAndroidNDK.Text = '' then
  begin
    ShowMessage('Please, Enter "Path To Android NDK..."');
    Exit;
  end;

  saveContent:= FPrebuildOSYS;

  pathToNdkToolchains49:= EditPathToAndroidNDK.Text+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;

  if not DirectoryExists(pathToNdkToolchains49 + ComboBoxPrebuild.Text) then
  begin
     ShowMessage('Sorry... Path To Ndk Toolchains "'+ ComboBoxPrebuild.Text + '" Not Found!');
     ComboBoxPrebuild.Text:= saveContent;
  end
  else
     Self.FPrebuildOSYS:= ComboBoxPrebuild.Text;

end;

procedure TFormSettingsPaths.EditPathToAndroidNDKExit(Sender: TObject);
begin
  if EditPathToAndroidNDK.Text <> '' then
  begin
     FPathToAndroidNDK:= EditPathToAndroidNDK.Text;
     ComboBoxPrebuild.Text:= Self.GetPrebuiltDirectory();
     FNDKRelease:= TryGetNDKRelease(FPathToAndroidNDK);
     FNDKIndex:= GetNDKVersionItemIndex(FNDKRelease);
     LabelNDKRelease.Caption:= 'NDK Release: '+FNDKRelease;
  end;
end;

procedure TFormSettingsPaths.BitBtnOKClick(Sender: TObject);
begin
   FOk:= True;
   Close;
end;

procedure TFormSettingsPaths.SpBPathToAndroidSDKClick(Sender: TObject);
begin
  if SelDirDlgPathTo.Execute then
  begin
    EditPathToAndroidSDK.Text := SelDirDlgPathTo.FileName;
    FPathToAndroidSDK:= SelDirDlgPathTo.FileName;
  end;
end;

function TFormSettingsPaths.GetMaxSdkPlatform(): integer;
var
  lisDir: TStringList;
  auxStr: string;
  i, intAux: integer;
begin
  Result:= 0;

  lisDir:= TStringList.Create;

  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= ExtractFileName(lisDir.Strings[i]);
       if auxStr <> '' then
       begin
         if Pos('P', auxStr) <= 0  then  //skip android-P
         begin
           auxStr:= Copy(auxStr, LastDelimiter('-', auxStr) + 1, MaxInt);
           intAux:= StrToInt(auxStr);
           if Result < intAux then
           begin
             if HasBuildTools(intAux) then
                Result:= intAux;
           end;
         end;
       end;
    end;
  end;

  lisDir.free;
end;

procedure TFormSettingsPaths.SpBPathToGradleClick(Sender: TObject);
begin
  if SelDirDlgPathTo.Execute then
  begin
    EditPathToGradle.Text:= SelDirDlgPathTo.FileName;
    FPathToGradle:= SelDirDlgPathTo.FileName;
  end;
end;

procedure TFormSettingsPaths.SpBPathToJavaJDKClick(Sender: TObject);
begin
//  {$ifndef darwin}
  if SelDirDlgPathTo.Execute then
  begin
    EditPathToJavaJDK.Text:= SelDirDlgPathTo.FileName;
    FPathToJavaJDK:= SelDirDlgPathTo.FileName;
  end;
//  {$endif}
end;

procedure TFormSettingsPaths.SpBPathToAndroidNDKClick(Sender: TObject);
begin
  if SelDirDlgPathTo.Execute then
  begin
    EditPathToAndroidNDK.Text := SelDirDlgPathTo.FileName;
    FPathToAndroidNDK:= SelDirDlgPathTo.FileName;

    if FPathToAndroidNDK <> '' then
    begin
      FNDKRelease:= TryGetNDKRelease(FPathToAndroidNDK);
      LabelNDKRelease.Caption:= 'NDK Release: '+FNDKRelease;
      FNDKIndex:= GetNDKVersionItemIndex(FNDKRelease);
    end;

    if FPrebuildOSYS = '' then
    begin
      if FPathToAndroidNDK <> '' then
      begin
         FPrebuildOSYS:= Self.GetPrebuiltDirectory();   //try guess
         if FPrebuildOSYS <> '' then
            ComboBoxPrebuild.Text:= FPrebuildOSYS;
      end;
    end;
  end;

end;

procedure TFormSettingsPaths.SpBPathToAntBinaryClick(Sender: TObject);
begin
    if SelDirDlgPathTo.Execute then
  begin
    EditPathToAntBinary.Text := SelDirDlgPathTo.FileName;
    FPathToAntBin:= SelDirDlgPathTo.FileName;
  end;
end;

procedure TFormSettingsPaths.SpeedButtonHelpClick(Sender: TObject);
begin
  ShowMessage('Warning/Recomendation:'+
           sLineBreak+
           sLineBreak+'[LAMW 0.8.6.1] "AppCompat" [material] theme need:'+
           sLineBreak+' 1. Java JDK 1.8'+
           sLineBreak+' 2. Gradle 6.6.1 [https://gradle.org/next-steps/?version=6.6.1&format=bin]' +
           sLineBreak+' 3. Android SDK "plataforms" 29 + "build-tools" 29.0.3'+
           sLineBreak+' 4. Android SDK/Extra  "Support Repository"'+
           sLineBreak+' 5. Android SDK/Extra  "Support Library"'+
           sLineBreak+' 6. Android SDK/Extra  "Google Repository"'+
           sLineBreak+' 7. Android SDK/Extra  "Google Play Services"'+
           sLineBreak+' '+
           sLineBreak+' Hint: "Ctrl + C" to copy this content to Clipboard!');
end;

procedure TFormSettingsPaths.SpeedButtonInfoClick(Sender: TObject);
begin
  ShowMessage('All settings are stored in the file '+sLineBreak+'"LAMW.ini" '+ sLineBreak +
  'ex1. "laz4Android/config"' + sLineBreak +
  'ex2. "C:\Users\...\AppData\Local\lazarus"');
end;

procedure TFormSettingsPaths.LoadSettings(const fileName: string);
var
   pathToNdkToolchains49: string;
begin

  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      FPathToAndroidNDK := ReadString('NewProject','PathToAndroidNDK', '');
      FPathToJavaJDK := ReadString('NewProject','PathToJavaJDK', '');
      FPathToAndroidSDK := ReadString('NewProject','PathToAndroidSDK', '');
      FPathToAntBin := ReadString('NewProject','PathToAntBin', '');
      FPathToGradle :=  ReadString('NewProject','PathToGradle', '');
      FNDKRelease:=  ReadString('NewProject','NDKRelease', '');

      if FNDKRelease <> '' then
      begin
         LabelNDKRelease.Caption:= 'NDK Release: '+FNDKRelease
      end
      else
      begin
         FNDKRelease:= TryGetNDKRelease(FPathToAndroidNDK);
         LabelNDKRelease.Caption:= 'NDK Release: '+FNDKRelease;
         WriteString('NewProject','NDKRelease', FNDKRelease);
      end;

      EditPathToAndroidNDK.Text := FPathToAndroidNDK;
      EditPathToJavaJDK.Text := FPathToJavaJDK;
      EditPathToAndroidSDK.Text := FPathToAndroidSDK;
      EditPathToAntBinary.Text := FPathToAntBin;
      EditpathToGradle.Text := FPathToGradle;

      {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}


      if ReadString('NewProject','NDK', '') <> '' then
      begin
        FNDKIndex:= StrToInt(ReadString('NewProject','NDK', ''));
        if (FNDKIndex < 3)  then
        begin
          ShowMessage('WARNING... Please, update NDK ... ');
        end;
      end;


      FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');
      if FPrebuildOSYS <> '' then
      begin
        pathToNdkToolchains49:= EditPathToAndroidNDK.Text+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                      'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                      'prebuilt'+DirectorySeparator;
        if DirectoryExists(pathToNdkToolchains49 + FPrebuildOSYS) then
        begin
            ComboBoxPrebuild.Text:= FPrebuildOSYS;
        end
        else
        begin
           FPrebuildOSYS:= Self.GetPrebuiltDirectory();
           ComboBoxPrebuild.Text:= FPrebuildOSYS;
           WriteIniString('PrebuildOSYS', FPrebuildOSYS);
        end;
      end
      else
      begin
          if FPathToAndroidSDK <> '' then
          begin
             FPrebuildOSYS:= Self.GetPrebuiltDirectory();   //try guess
             if FPrebuildOSYS <> '' then
             begin
                ComboBoxPrebuild.Text:= FPrebuildOSYS;
                WriteIniString('PrebuildOSYS', FPrebuildOSYS);
             end;
          end;
      end;
    finally
      Free;
    end;
  end;

end;

procedure TFormSettingsPaths.SaveSettings(const fileName: string);
var
   pathToNdkToolchains49: string;
begin

  with TInifile.Create(fileName) do
  try

    WriteString('NewProject', 'PathToSmartDesigner', FPathToSmartDesigner);
    WriteString('NewProject', 'PathToJavaTemplates', FPathToJavaTemplates);

    if EditPathToJavaJDK.Text <> '' then
      WriteString('NewProject', 'PathToJavaJDK', EditPathToJavaJDK.Text);

    if EditPathToAndroidNDK.Text <> '' then
      WriteString('NewProject', 'PathToAndroidNDK', EditPathToAndroidNDK.Text);

    if EditPathToAndroidSDK.Text <> '' then
      WriteString('NewProject', 'PathToAndroidSDK', EditPathToAndroidSDK.Text);

    if EditPathToAntBinary.Text <> '' then
      WriteString('NewProject', 'PathToAntBin', EditPathToAntBinary.Text);

    if (EditPathToGradle.Text <> '') then
      WriteString('NewProject', 'PathToGradle', EditPathToGradle.Text);

    if (LabelNDKRelease.Caption <> '') then
      WriteString('NewProject', 'NDKRelease', FNDKRelease);

    WriteString('NewProject', 'NDK', IntToStr(FNDKIndex));

    if ComboBoxPrebuild.Text = '' then
    begin
      if FPathToAndroidSDK <> '' then
      begin
         if ComboBoxPrebuild.Text = '' then
           ComboBoxPrebuild.Text:= Self.GetPrebuiltDirectory(); //try guess
      end;
    end
    else
    begin

      pathToNdkToolchains49:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator + ComboBoxPrebuild.Text;

      if not DirectoryExists(pathToNdkToolchains49) then
         ComboBoxPrebuild.Text:= Self.GetPrebuiltDirectory();

    end;

    WriteString('NewProject', 'PrebuildOSYS', ComboBoxPrebuild.Text);
  finally
    Free;
  end;
end;

end.

