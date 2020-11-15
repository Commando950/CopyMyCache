unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, GhettoFileDetection;

type

  { TForm1 }

  TForm1 = class(TForm)
    DeleteCache: TButton;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    CopyCacheButton: TButton;
    DiscordCachePath: TEdit;
    InfoText: TStaticText;
    StaticText1: TStaticText;
    StatusBar: TStatusBar;
    procedure CopyCacheButtonClick(Sender: TObject);
    procedure DeleteCacheClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  DiscordCachePath: string;
  GIFSFound, PNGSFound, JPGSFound, SpecialImages, VideosFound, AudioFound, UnknownsFound: integer;

implementation

{$R *.lfm}

{ TForm1 }

function HexStrToStr(const HexStr: string): string;
var
  ResultLen: integer;
begin
  ResultLen := Length(HexStr) div 2;
  SetLength(Result, ResultLen);
  if ResultLen > 0 then
    SetLength(Result, HexToBin(Pointer(HexStr), Pointer(Result), ResultLen));
end;

function DeleteCacheFiles(): boolean;
var
  CurrentFile: integer;
  CacheFiles: TStringList;
begin
  Result := False;//Just to store we haven't had success yet.
  if DirectoryExists(Form1.DiscordCachePath.Text) then
  begin
    //Copy/Detect cache files.
    CacheFiles := TStringList.Create;
    CacheFiles.Capacity := 30000;
    if DirectoryExists(Form1.DiscordCachePath.Text) then
    begin
      try
        Form1.StatusBar.SimpleText := 'Finding Cache Files...';
        FindAllFiles(CacheFiles, Form1.DiscordCachePath.Text, 'f_*', True);
        for CurrentFile := 0 to CacheFiles.Count - 1 do
        begin
          Application.ProcessMessages();
          Form1.StatusBar.SimpleText :=
            'Deleting file ' + IntToStr(CurrentFile) + ' out of ' + IntToStr(CacheFiles.Count) + '!';
          DeleteFile(CacheFiles.Strings[CurrentFile]);
        end;
        CacheFiles.Clear;
        Form1.StatusBar.SimpleText := 'Finding Data Files...';
        FindAllFiles(CacheFiles, Form1.DiscordCachePath.Text,
          'data_*', True);
        for CurrentFile := 0 to CacheFiles.Count - 1 do
        begin
          Application.ProcessMessages();
          Form1.StatusBar.SimpleText :=
            'Deleting data ' + IntToStr(CurrentFile) + ' out of ' + IntToStr(CacheFiles.Count) + '!';
          DeleteFile(CacheFiles.Strings[CurrentFile]);
        end;
      finally
        CacheFiles.Free;
        Form1.StatusBar.SimpleText := 'Done deleting your cache!';
        Result := True;//Our job was successful.
      end;
    end
    else
    begin
      ShowMessage('ERROR: Directory "' + Form1.DiscordCachePath.Text +
        '" not found!' + LineEnding + LineEnding +
        'Please make sure the folder/directory exists before you try again!');
    end;
  end
  else
  begin
    ShowMessage('ERROR: Discord cache path not found.');
  end;
end;

function CopyCacheFiles(): boolean;
var
  CurrentFile: integer;
  CacheFiles: TStringList;
begin
  //Be sure to make the function understand we've not got a result yet!
  Result := False;
  if DirectoryExists(Form1.DiscordCachePath.Text) then
  begin
    //Copy/Detect cache files.
    CacheFiles := TStringList.Create;
    CacheFiles.Capacity := 30000;
    GIFSFound := 0;
    PNGSFound := 0;
    JPGSFound := 0;
    SpecialImages := 0;
    VideosFound := 0;
    AudioFound := 0;
    UnknownsFound := 0;
    if Form1.SelectDirectoryDialog1.Execute then
      if DirectoryExists(Form1.SelectDirectoryDialog1.FileName) then
      begin
        try
          Form1.StatusBar.SimpleText := 'Working...';
          FindAllFiles(CacheFiles, Form1.DiscordCachePath.Text, 'f_*', True);
          for CurrentFile := 0 to CacheFiles.Count - 1 do
          begin
            Application.ProcessMessages();
            Form1.StatusBar.SimpleText :=
              'PNGs:' + IntToStr(PngsFound) + ' JPGs:' + IntToStr(GifsFound) +
              ' GIFs:' + IntToStr(GifsFound) + ' Other Images:' + IntToStr(SpecialImages) +
              ' Videos:' + IntToStr(VideosFound) + ' Audio:' + IntToStr(AudioFound) +
              ' Unknown:' + IntToStr(UnknownsFound);
            if IsPNG(CacheFiles.Strings[CurrentFile]) then
            begin
              CopyFile(CacheFiles.Strings[CurrentFile],
                Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
                CacheFiles.Strings[CurrentFile]) + '.png');
              PNGSFound := PNGSFound + 1;
              continue;
            end;
            if IsJpeg(CacheFiles.Strings[CurrentFile]) then
            begin
              CopyFile(CacheFiles.Strings[CurrentFile],
                Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
                CacheFiles.Strings[CurrentFile]) + '.jpg');
              JPGSFound := JPGSFound + 1;
              continue;
            end;
            if IsGif(CacheFiles.Strings[CurrentFile]) then
            begin
              CopyFile(CacheFiles.Strings[CurrentFile],
                Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
                CacheFiles.Strings[CurrentFile]) + '.gif');
              GIFSFound := GIFSFound + 1;
              continue;
            end;
            if IsMP4(CacheFiles.Strings[CurrentFile]) then
            begin
              CopyFile(CacheFiles.Strings[CurrentFile],
                Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
                CacheFiles.Strings[CurrentFile]) + '.mp4');
              VideosFound := VideosFound + 1;
              continue;
            end;
            if IsMOV(CacheFiles.Strings[CurrentFile]) then
            begin
              CopyFile(CacheFiles.Strings[CurrentFile],
                Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
                CacheFiles.Strings[CurrentFile]) + '.mov');
              VideosFound := VideosFound + 1;
              continue;
            end;
            if IsWEBM(CacheFiles.Strings[CurrentFile]) then
            begin
              CopyFile(CacheFiles.Strings[CurrentFile],
                Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
                CacheFiles.Strings[CurrentFile]) + '.webm');
              VideosFound := VideosFound + 1;
              continue;
            end;
            if IsMP3(CacheFiles.Strings[CurrentFile]) then
            begin
              CopyFile(CacheFiles.Strings[CurrentFile],
                Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
                CacheFiles.Strings[CurrentFile]) + '.mp3');
              AudioFound := AudioFound + 1;
              continue;
            end;
            if IsOGG(CacheFiles.Strings[CurrentFile]) then
            begin
              CopyFile(CacheFiles.Strings[CurrentFile],
                Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
                CacheFiles.Strings[CurrentFile]) + '.ogg');
              AudioFound := AudioFound + 1;
              continue;
            end;
            if IsWAV(CacheFiles.Strings[CurrentFile]) then
            begin
              CopyFile(CacheFiles.Strings[CurrentFile],
                Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
                CacheFiles.Strings[CurrentFile]) + '.wav');
              AudioFound := AudioFound + 1;
              continue;
            end;
            if IsWebp(CacheFiles.Strings[CurrentFile]) then
            begin
              CopyFile(CacheFiles.Strings[CurrentFile],
                Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
                CacheFiles.Strings[CurrentFile]) + '.webp');
              SpecialImages := SpecialImages + 1;
              continue;
            end;
            CopyFile(CacheFiles.Strings[CurrentFile],
              Form1.SelectDirectoryDialog1.FileName + '\' + ExtractFileName(
              CacheFiles.Strings[CurrentFile]));
            UnknownsFound := UnknownsFound + 1;
          end;
        finally
          CacheFiles.Free;
          Form1.StatusBar.SimpleText := 'Done copying unarchived images!';
          Result := True;
        end;
      end
      else
      begin
        ShowMessage('ERROR: Directory "' +
          Form1.SelectDirectoryDialog1.FileName + '" not found!' + LineEnding +
          LineEnding + 'Please make sure the folder/directory exists before you try again!');
      end;
  end
  else
  begin
    ShowMessage('ERROR: Discord cache path not found!');
  end;
end;

procedure TForm1.CopyCacheButtonClick(Sender: TObject);
begin
  if CopyCacheFiles() then
  begin
    ShowMessage
    (
      IntToStr(PNGSFound) + ' .PNG files were found.' +
      LineEnding + IntToStr(JPGSFound) + ' .JPG files were found.' +
      LineEnding + IntToStr(GIFSFound) + ' .GIF files were found.' +
      LineEnding + IntToStr(VideosFound) + ' Other images were found.' +
      LineEnding + IntToStr(VideosFound) + ' Video files were found.' +
      LineEnding + IntToStr(AudioFound) + ' Audio files were found.' +
      LineEnding + IntToStr(UnknownsFound) + ' Unknown files were found.' +
      LineEnding + LineEnding +
      'Please report any problems to Commando950!'
    );
  end
  else
  begin
    ShowMessage('Copying cached discord files failed! Report this to Commando950!');
  end;
end;

procedure TForm1.DeleteCacheClick(Sender: TObject);
begin
  if QuestionDlg('Caption', 'Are you sure you want to delete your discord cache?' +
    LineEnding + LineEnding + 'This action is irreversible and can not be undone',
    mtCustom, [mrYes, 'Yes', mrNo, 'No', 'IsDefault'], '') = mrYes then
  begin
    ShowMessage(
      'Discord must be closed in order to delete data files. It will NOT be successful if discord is open.'
      +
      LineEnding + 'Cache files will be deleted anyway though.');
    if DeleteCacheFiles() then
    begin
      ;
      if FileExists(DiscordCachePath.Text + '\data_0') or
        FileExists(DiscordCachePath.Text + '\data_1') or
        FileExists(DiscordCachePath.Text + '\data_2') or
        FileExists(DiscordCachePath.Text + '\data_3') then
        ShowMessage(
          'Data files still exist! Discord was probably open when you performed the delete.');
      ShowMessage
      (
        'Data/Cache Files were deleted if they existed.' +
        LineEnding +
        'If discord was open only cache files were deleted. Data files is probably still there.'
        +
        LineEnding +
        'These files are not deleted in any special way and no guaranteed removal is promised.' +
        LineEnding + 'It is RECOMMENDED to see for yourself to be sure.' +
        LineEnding + LineEnding + 'Please report any problems to Commando950!'
        );
    end
    else
    begin
      ShowMessage('Deleting cached discord files failed! Report this to Commando950!');
    end;
  end
  else
  begin
    ShowMessage('Operation canceled by user.');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if DirectoryExists(GetEnvironmentVariable('appdata') + '\discord\Cache') then
  begin
    DiscordCachePath.Text := GetEnvironmentVariable('appdata') + '\discord\Cache';
  end
  else
  begin
    if DirectoryExists(GetEnvironmentVariable('appdata') +
      '\discordcanary\cache') then
    begin
      DiscordCachePath.Text :=
        GetEnvironmentVariable('appdata') + '\discordcanary\Cache';
    end
    else
    begin
      DiscordCachePath.Text :=
        GetEnvironmentVariable('appdata') + '\discord\Cache';
      ShowMessage('Discord cache not found in default location. Please specify it.');
    end;
  end;
  SelectDirectoryDialog1.InitialDir := ExtractFilePath(Application.ExeName) + 'cache';
end;

end.
