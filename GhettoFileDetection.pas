{
You are free to use this, but be weary its absolutely garbage and isn't guaranteed to work at all.

Use with caution as it is extraordinarily primitive.
}

unit GhettoFileDetection;

interface

uses
  Classes;

function IsWebM(FilePath: string): boolean;
function IsWebP(FilePath: string): boolean;
function IsMOV(FilePath: string): boolean;
function IsMP4(FilePath: string): boolean;
function IsMP3(FilePath: string): boolean;
function IsWAV(FilePath: string): boolean;
function IsOGG(FilePath: string): boolean;
function IsJPEG(FilePath: string): boolean;
function IsGif(FilePath: string): boolean;
function IsPNG(FilePath: string): boolean;

implementation

function IsWebM(FilePath: string): boolean;
var
  FileReader: TStream;
  header: array[0..3] of byte;
begin
  Result := False;
  FileReader := TFileStream.Create(FilePath, fmOpenRead);
  try
    FileReader.seek(0, soFromBeginning);
    FileReader.ReadBuffer(header, Length(header));
    if header[0] = 26 then
      if header[1] = 69 then
        if header[2] = 223 then
          if header[3] = 163 then
            Result := True;
  finally
    FileReader.Free;
  end;
end;

function IsWebP(FilePath: string): boolean;
var
  FileReader: TStream;
  header: array[0..11] of byte;
begin
  Result := False;
  FileReader := TFileStream.Create(FilePath, fmOpenRead);
  try
    FileReader.seek(0, soFromBeginning);
    FileReader.ReadBuffer(header, Length(header));
    if header[8] = 87 then
      if header[9] = 69 then
        if header[10] = 66 then
          if header[11] = 80 then
            Result := True;
  finally
    FileReader.Free;
  end;
end;

function IsMOV(FilePath: string): boolean;
var
  FileReader: TStream;
  header: array[0..9] of byte;
begin
  Result := False;
  FileReader := TFileStream.Create(FilePath, fmOpenRead);
  try
    FileReader.seek(0, soFromBeginning);
    FileReader.ReadBuffer(header, Length(header));
    if header[0] = 0 then
      if header[1] = 0 then
        if header[2] = 0 then
          if header[3] = 20 then
            if header[4] = 102 then
              if header[5] = 116 then
                if header[6] = 121 then
                  if header[7] = 112 then
                    if header[8] = 113 then
                      if header[9] = 116 then
                        Result := True;
  finally
    FileReader.Free;
  end;
end;

function IsMP4(FilePath: string): boolean;
var
  FileReader: TStream;
  header: array[0..9] of byte;
begin
  Result := False;
  FileReader := TFileStream.Create(FilePath, fmOpenRead);
  try
    FileReader.seek(0, soFromBeginning);
    FileReader.ReadBuffer(header, Length(header));
    if header[0] = 0 then
      if header[1] = 0 then
        if header[2] = 0 then
          if header[3] = 32 then
            if header[4] = 102 then
              if header[5] = 116 then
                if header[6] = 121 then
                  if header[7] = 112 then
                    if header[8] = 105 then
                      if header[9] = 115 then
                        Result := True;
  finally
    FileReader.Free;
  end;
end;

function IsMP3(FilePath: string): boolean;
var
  FileReader: TStream;
  header: array[0..2] of byte;
begin
  Result := False;
  FileReader := TFileStream.Create(FilePath, fmOpenRead);
  try
    FileReader.seek(0, soFromBeginning);
    FileReader.ReadBuffer(header, Length(header));
    if header[0] = 73 then
      if header[1] = 68 then
        if header[2] = 51 then
          Result := True;
  finally
    FileReader.Free;
  end;
end;

function IsWAV(FilePath: string): boolean;
var
  FileReader: TStream;
  header: array[0..11] of byte;
begin
  Result := False;
  FileReader := TFileStream.Create(FilePath, fmOpenRead);
  try
    FileReader.seek(0, soFromBeginning);
    FileReader.ReadBuffer(header, Length(header));
    if header[8] = 87 then
      if header[9] = 65 then
        if header[10] = 86 then
          if header[11] = 69 then
            Result := True;
  finally
    FileReader.Free;
  end;
end;

function IsOGG(FilePath: string): boolean;
var
  FileReader: TStream;
  header: array[0..3] of byte;
begin
  Result := False;
  FileReader := TFileStream.Create(FilePath, fmOpenRead);
  try
    FileReader.seek(0, soFromBeginning);
    FileReader.ReadBuffer(header, Length(header));
    if header[0] = 79 then
      if header[1] = 103 then
        if header[2] = 103 then
          if header[3] = 83 then
            Result := True;
  finally
    FileReader.Free;
  end;
end;

function IsJPEG(FilePath: string): boolean;
var
  FileReader: TStream;
  header: array[0..2] of byte;
begin
  Result := False;
  FileReader := TFileStream.Create(FilePath, fmOpenRead);
  try
    FileReader.seek(0, soFromBeginning);
    FileReader.ReadBuffer(header, Length(header));
    if header[0] = 255 then
      if header[1] = 216 then
        if header[2] = 255 then
          Result := True;
  finally
    FileReader.Free;
  end;
end;

function IsGif(FilePath: string): boolean;
var
  FileReader: TStream;
  header: array[0..2] of byte;
begin
  Result := False;
  FileReader := TFileStream.Create(FilePath, fmOpenRead);
  try
    FileReader.seek(0, soFromBeginning);
    FileReader.ReadBuffer(header, Length(header));
    if chr(header[0]) = 'G' then
      if chr(header[1]) = 'I' then
        if chr(header[2]) = 'F' then
          Result := True;
  finally
    FileReader.Free;
  end;
end;

function IsPNG(FilePath: string): boolean;
var
  FileReader: TStream;
  header: array[0..3] of byte;
begin
  Result := False;
  FileReader := TFileStream.Create(FilePath, fmOpenRead);
  try
    FileReader.seek(0, soFromBeginning);
    FileReader.ReadBuffer(header, Length(header));
    if header[0] = 137 then
      if header[1] = 80 then
        if header[2] = 78 then
          if header[3] = 71 then
            Result := True;
  finally
    FileReader.Free;
  end;
end;

end.
