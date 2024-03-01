{*******************************************************************************

  krpRegions library. PCX file support (based on AntPcx unit by KARPOLAN).

  Author: KARPOLAN

  Copyright (c) 1996-2005 by KARPOLAN.
  Copyright (c) 2000-2005 ABF software, Inc.
  All Rights Reserved.

  e-mail: info@abf-dev.com
  web:    http://www.abf-dev.com

  The entire contents of this file is protected by International Copyright
Laws. Unauthorized reproduction, reverse engineering, and distribution of all
or any portion of the code contained in this file is strictly prohibited and
may result in severe civil and criminal penalties and will be prosecuted to
the maximum extent possible under the law.

  RESTRICTIONS

  THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED FILES OR ANY
PORTION OF ITS CONTENTS SHALL AT NO TIME BE COPIED, TRANSFERRED, SOLD,
DISTRIBUTED, OR OTHERWISE MADE AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS
WRITTEN CONSENT AND PERMISSION FROM THE ABF SOFTWARE, INC.

  CONSULT THE END USER LICENSE AGREEMENT (EULA) FOR INFORMATION ON ADDITIONAL
RESTRICTIONS.

*******************************************************************************}
unit krpRegionsPcx;

{$I krpRegions.inc}

{*******************************************************************************
   Install this file like component and standart TPicture properties will
   understand the PCX format. You can use standart TImage component for PCXs
*******************************************************************************}

interface

uses
  Windows, SysUtils, classes, Graphics;

const
{ Deafault Signatura for PCX Resources }
  pcxResTypeName   = 'PCX';
{ Deafault PCX File Signature (8 BPP) }
  pcxFileSignature = $0A050108;

type

{******************************************************************************}
{ PCX File Header, Size = 128 }

  TkrpPcxHeader = packed record
    Manufact    : Byte;                  { Manufactor     $OA       }
    Version     : Byte;                  { Version        $05       }
    EnCode      : Byte;                  { Group Coding   $01       }
    BitPerPixel : Byte;                  { Bit Per Pixel ($08)      }
    imgLeft     : Word;                  { Picture Coords...        }
    imgTop      : Word;                  {                          }
    imgRight    : Word;                  {                          }
    imgBottom   : Word;                  {                          }
    HRes        : Word;                  { Horisontal Resolution    }
    VRes        : Word;                  { Vertical Resolution      }
    Pal         : array[0..47] of Byte;  { EGA Pallete              }
    VideoMode   : Byte;                  { Video Mode (Reserved)    }
    NumPlanes   : Byte;                  { Numder Of Color Planes   }
    BytePerLine : Word;                  { Byte Per Line            }
    PalInfo     : Word;                  { (1-Color,2-Gray)         }
    ScanHRes    : Word;                  { Scaners Hor.  Resolution }
    ScanVRes    : Word;                  { Scaners Vert. Resolution }
    Xtra        : array[0..53] of Byte;  { Extra Data (Padding)     }
  end;{TkrpPcxHeader = packed record}

{ PCL (PCX Library) File Header }

  TPclHeader = packed record
    id{Software} : array[0..9 ] of Byte;   { Lib Number               }
    Copyright    : array[0..49] of Byte;   { Autor's Copyright        }
    Version      : Word;                   { Version PCL              }
    Note         : array[0..39] of Char;   { Tome Label               }
    Xtra         : array[0..19] of Byte;   { Extra Data (Filter)      }
  end;

{ PCX File in PCL Library Header }

  TkrpPcxInPclHeader = packed record
    SyncByte   : Byte;                   { Byte Of Syncro           }
    FileName   : array[0..11] of Char;   { File Name                }
    FileSize   : DWord;                  { File Size                }
    FileDate   : Word;                   { File Date                }
    FileTime   : Word;                   { File Time                }
    FilePack   : Word;                   { Type Of Packing          }
    Note       : array[0..39] of Char;   { File Label               }
    Xtra       : array[0..20] of Byte;   { Extra Data (Filter)      }
  end;

{ PCX Color Data }

  TkrpPcxRGBColor = packed record
    Red   : Byte;
    Green : Byte;
    Blue  : Byte;
  end;

{ PCX Palette, Size = 768 }

  TkrpPcxPalette = array[0..255] of TkrpPcxRGBColor;

{ PCX/PCL Memory Routine }

  TkrpPcxFileRecord = packed record
    pcxHeader     : TkrpPcxHeader;
    pcxRleData    : Pointer;
    pcxRleDataSize: DWord;
    pcxPalette    : TkrpPcxPalette;
  end;
  TkrpPcxInPclPictureRecord = TkrpPcxFileRecord;

{******************************************************************************}
{ TkrpPcx }

  EPcx = class(Exception);

  TkrpPcx = class(TGraphic)
  private
    fPcxStream: TMemoryStream;
    fBitmap: TBitmap;
  { Streams Routine }
    procedure WriteStream(Stream: TStream; WriteSize : Boolean);
    procedure ReadStream(Size: LongInt; Stream: TStream);
  protected
  { Override This }
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
  { Convert Routine }
    procedure Convert; virtual;
  { Properties Overrides }
    function  GetEmpty: Boolean; override;
    function  GetWidth: Integer; override;
    procedure SetWidth(A: Integer); override;
    function  GetHeight: Integer; override;
    procedure SetHeight(A: Integer); override;
  { Streams Routine }
    procedure ReadData (Stream: TStream); override;
    procedure WriteData(Stream: TStream); override;
  public
    PcxHeader: TkrpPcxHeader;
  { Init/Done }
		constructor Create; override;
		destructor Destroy; override;
  { Override This }
    procedure Assign(Source: TPersistent); override;
  { Files Routine }
    procedure LoadFromFile(const FileName: string); override;
    procedure SaveToFile  (const FileName: string); override;
  { Streams Routine }
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream  (Stream: TStream); override;
  { ClipBoard Routine }
    procedure LoadFromClipBoardFormat(AFormat: Word; AData: THandle;
      APalette: HPalette); override;
    procedure SaveToClipBoardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPalette); override;
  { Properties Routine }
    property PcxStream   : TMemoryStream
      read   fPcxStream
      write  fPcxStream;
    property Bitmap      : TBitmap
      read   fBitmap
      write  fBitmap;
  { Old Properties }
    property Empty;
    property Height;
    property Modified;
    property Width;
    property OnChange;
  end;{TkrpPcx = class(TGraphic)}


{******************************************************************************}
{ Converta PCX file Styled stream to BMP styled One (Main Convertion Proc) }
procedure pcxStreamConvert(APcxStream: TStream; ABmpStream: TMemoryStream);
{ Load PCX from hIstance or From File }
function pcxLoadAsBitmap(const AName: string): TBitMap;
{ Load PCX from File }
function pcxLoadAsBitmapFromFile(const AFileName: string): TBitMap;
{ Load PCX from Stream }
function pcxLoadAsBitmapFromStream(AStream: TStream): TBitMap;
{ Load PCX from Stream (From Position and By Size)}
function pcxLoadAsBitmapFromStreamDirectly(AStream: TStream; APosition: LongInt;
  ASize: LongInt) : TBitMap;

{******************************************************************************}
{ Load PCX file to memory }
function LoadPcxFile(const AFileName: string;
  var APcxFileRec: TkrpPcxFileRecord): Boolean;
{ Convert Loaded PCX file to Bitmap }
function ConverPcxToBitmap(APcxFileRec: TkrpPcxFileRecord; var ABitmap: HBitmap;
  var APalette: HPalette): Boolean;
{ Load Pcx File and Convert Data to Bitmap and Palette }
function LoadPcxFileToBitmap(const AFileName: string; var ABitmap: HBitmap;
  var APalette: HPalette): Boolean;


{******************************************************************************}
implementation
{******************************************************************************}


{******************************************************************************}
{ TkrpPcx }
const
  bmpFileSignature  = $4d42;
  strNoFile         = 'PCX File Not Found';
  strWrongFile      = 'File isn''t a PCX File';

{--------------------------------------}
{ Init/Done }
constructor TkrpPcx.Create;
begin
  fPcxStream := TMemoryStream.Create;
  fBitmap    := TBitmap.Create;
  inherited Create;
end;

{--------------------------------------}

destructor TkrpPcx.Destroy;
begin
  inherited Destroy;
  fBitmap.Free;
  fPcxStream.Free;
end;

{--------------------------------------}
{ Override This }

procedure TkrpPcx.Assign(Source: TPersistent);
begin
  if (Source is TkrpPcx) then
  begin
    fPcxStream.LoadFromStream(TkrpPcx(Source).PcxStream);
  { Change yourself }
    Convert;
    Changed(Self);
  end else
    inherited Assign(Source);
end;

{--------------------------------------}
{ Files Routine }

procedure TkrpPcx.LoadFromFile(const FileName: string);
begin
{ Check File Existing }
  if not FileExists(FileName) then raise EPcx.Create(strNoFile);
{ Check File Extention }
  if (UpperCase(ExtractFileExt(FileName)) <> '.PCX') then
    raise EPcx.Create(strWrongFile);{}
{ Load fPcxStream From File }
  fPcxStream.LoadFromFile(FileName);
{ Change yourself }
  Convert;
  Changed(Self);
end;

{--------------------------------------}

procedure TkrpPcx.SaveToFile(const FileName: string);
begin
  fPcxStream.SaveToFile(FileName);
end;

{--------------------------------------}
{ Stream Routine }

procedure TkrpPcx.LoadFromStream(Stream : TStream);
begin
{ Check For Stream }
  if not Assigned(Stream) then Exit;
{ Load fPcxStream From Stream }
  fPcxStream.LoadFromStream(Stream);
{ Change yourself }
  Convert;
  Changed(Self);
end;

{--------------------------------------}

procedure TkrpPcx.SaveToStream(Stream: TStream);
begin
  WriteStream(Stream, False);
end;

{--------------------------------------}
{ ClipBoard Routine }

procedure TkrpPcx.LoadFromClipBoardFormat(AFormat: Word; AData: THandle;
  APalette: HPalette);
begin
end;

{--------------------------------------}

procedure TkrpPcx.SaveToClipBoardFormat(var AFormat: Word; var AData: THandle;
  var APalette: HPalette);
begin
end;

{--------------------------------------}
{ Override This }

procedure TkrpPcx.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  destDC                : HDC;
  destX, destY,
  destWidth, destHeight : SmallInt;
  srcDC                 : HDC;
  srcX, srcY,
  srcWidth, srcHeight   : SmallInt;
  ROpFlag               : LongInt;
begin
{ Prepare Destanation }
  destDC := ACanvas.Handle;
  with Rect do
  begin
    destX      := Left;
    destY      := Top;
    destWidth  := Right  - Left;
    destHeight := Bottom - Top;
  end;
{ Prepare Source }
  srcDC := fBitmap.Canvas.Handle;
  with fBitmap do
  begin
    srcX      := 0;
    srcY      := 0;
    srcWidth  := Width;
    srcHeight := Height;
  end;
{ Set Raster Operations Flag }
  ROpFlag := ACanvas.CopyMode;
{ StretchBlt }
  StretchBlt(destDC, destX, destY, destWidth, destHeight,
    srcDC,  srcX,  srcY,  srcWidth,  srcHeight, ROpFlag);
end;{procedure TkrpPcx.Draw}

{--------------------------------------}
{ Convertaion Routine }

procedure TkrpPcx.Convert;
var
  msTemp: TMemoryStream;
begin
  fPcxStream.Seek(0, soFrombeginning);
  fPcxStream.Read(PcxHeader, SizeOf(PcxHeader));
  msTemp := TMemoryStream.Create;
  try
    pcxStreamConvert(fPcxStream, msTemp);
    fBitmap.LoadFromStream(msTemp)
  finally
    msTemp.Free;
  end;
end;

{--------------------------------------}
{ Properties Overrides }

function TkrpPcx.GetEmpty: Boolean;
begin
  Result := fBitmap.Empty;
end;

{--------------------------------------}

function TkrpPcx.GetWidth: Integer;
begin
  with PcxHeader do
    Result := ((imgRight - imgLeft) + 1);{}
// Result := fBitmap.Width;
end;{function TkrpPcx.GetWidth}

{--------------------------------------}

procedure TkrpPcx.SetWidth(A: Integer);
begin
end;

{--------------------------------------}

function TkrpPcx.GetHeight: Integer;
begin
  with PcxHeader do
    Result := ((imgBottom - imgTop ) + 1);{}
// Result := fBitmap.Height;
end;

{--------------------------------------}

procedure TkrpPcx.SetHeight(A: Integer);
begin
end;

{--------------------------------------}
{ Streams Routine }

procedure TkrpPcx.ReadData(Stream: TStream);
var
  Size: LongInt;
begin
  Stream.Read(Size, SizeOf(Size));
  ReadStream(Size, Stream);
{ Change yourself }
  Convert;
  Changed(Self);
end;

{--------------------------------------}

procedure TkrpPcx.WriteData(Stream : TStream);
begin
  WriteStream(Stream, True);
end;

{--------------------------------------}

procedure TkrpPcx.ReadStream(Size: LongInt; Stream: TStream);
begin
  fPcxStream.SetSize(Size);
  Stream.ReadBuffer(fPcxStream.Memory^, Size);
end;

{--------------------------------------}

procedure TkrpPcx.WriteStream(Stream: TStream; WriteSize: Boolean);
var
  Size: LongInt;
begin
  Size := fPcxStream.Size;
  if WriteSize then Stream.WriteBuffer(Size, SizeOf(Size));
  if Size > 0 then Stream.WriteBuffer(fPcxStream.Memory^, Size);
end;


{******************************************************************************}
const
  strErrFromResource  = 'Unable load "%s" PCX resource';
  strErrFromFile      = 'Unable load PCX from "%s" file';
  strErrFromStream    = 'Unable load PCX from stream';

{ Converta PCX file Styled stream to BMP styled One (Main Convertion Proc) }
procedure pcxStreamConvert(APcxStream: TStream; ABmpStream: TMemoryStream);
const
  Bounder: DWord = $00000000;
var
{ PCX Routine }
  APcxFileRec       : TkrpPcxFileRecord;
  RleDataPointer    : LongInt;
  pcxWidth          : LongInt;
  pcxHeight         : LongInt;
{ Memory Image Routine }
  ByteOfData        : Byte;
  BytesCount        : Byte;
  ptrImage          : Pointer;
  ImageLen          : LongInt;
  ImagePointer      : LongInt;
{ Bmp Routine }
  ABitmapInfoHeader : Windows.TBitmapInfoHeader;
  ABitmapFileHeader : Windows.TBitmapFileHeader;
  BoundarySize      : LongInt;

  {------------------------------------}

  procedure _ConvertRleToBmp;
  var
    Count: Integer;
  begin
    ImagePointer   := Integer(ptrImage);
    RleDataPointer := Integer(APcxFileRec.pcxRleData);
    Count := 0;
    while Count < ImageLen do
    begin
    { Read One Byte of Data }
      ByteOfData := Byte(Pointer(RleDataPointer)^);
    { Check This Byte }
      if ByteOfData >= 192 then
      begin { Byte is technickal = (Length of bytes row + 192) }
        BytesCount := ByteOfData - 192;
      { read next byte - Real value of color }
        Inc(RleDataPointer);
        ByteOfData := Byte(Pointer(RleDataPointer)^);
      { Fill row of bytes }
        FillChar(Pointer(ImagePointer + Count)^, BytesCount, ByteOfData);
        Inc(Count, BytesCount);
      end else
      begin { Byte is color data }
      { Simple copy the byte }
        Byte(Pointer(ImagePointer + Count)^) := ByteOfData ;
        Inc(Count);
      end;
    { Prepare for next step (byte) }
      Inc(RleDataPointer);
    end;{while Count < ImageLen do}
  end;{INTERNAL procedure _ConvertRleToBmp}

  {------------------------------------}

  procedure _PrepareHeaders;
  begin
  { Calculate Boundary Size }
    BoundarySize := pcxWidth mod 4;
    if BoundarySize <> 0 then BoundarySize := 4 - BoundarySize;
  { Prepare Bitmap Info Header }
    with ABitmapInfoHeader, APcxFileRec.pcxHeader do
    begin
      biSize          := SizeOf(ABitmapInfoHeader);
      biWidth         := pcxWidth;
      biHeight        := -pcxHeight;     { Top-Down Bitmap }
      biPlanes        := NumPlanes;
      biBitCount      := BitPerPixel;
      biCompression   := BI_RGB;         { Not Compressed Bitmap }
      biSizeImage     := 0;
      biXPelsPerMeter := ScanHRes;
      biYPelsPerMeter := ScanVRes;
      biClrUsed       := 0;
      biClrImportant  := 0;              { All colors are important }
    end;
  { Prepare Bitmap File Header }
    with ABitmapFileHeader, APcxFileRec.pcxHeader, ABitmapInfoHeader do
    begin
      bfType      := bmpFileSignature;
      bfOffBits   := 1024 + SizeOf(ABitmapFileHeader) + SizeOf(ABitmapInfoHeader);
      bfSize      := bfOffBits + (Abs(biHeight) * (biWidth + BoundarySize));
      bfReserved1 := 0;
      bfReserved2 := 0;
    end;
  end;{INTERNAL procedure _PrepareHeaders}

  {------------------------------------}

  procedure _WriteToStream;
  var
    i: Integer;
  begin
  { Write To ABmpStream }
    with ABmpStream, APcxFileRec do
    begin
    { Resize & Reset Stream }
      SetSize(ABitmapFileHeader.bfOffBits + ABitmapFileHeader.bfSize);
      Seek(0, soFrombeginning);
    { Write Headers }
      write(ABitmapFileHeader, SizeOf(ABitmapFileHeader));
      write(ABitmapInfoHeader, SizeOf(ABitmapInfoHeader));
    { Write RGB Palette }
      for i := 0 to 255 do
        with pcxPalette[i] do
        begin
          write(Blue   , 1);
          write(Green  , 1);
          write(Red    , 1);
          write(Bounder, 1); { Filler }
        end;
    { Write All Lines to Stream }
      ImagePointer := Integer(ptrImage);
      with pcxHeader do
        for i := imgTop to imgBottom do
        begin
        { Write pixels data (Full Line) }
          Write(Pointer(ImagePointer)^, BytePerLine);
        { Aditional Zeros For 32 bit Alignment }
          Write(Bounder, BoundarySize);
        { Next Line Offset }
          Inc(ImagePointer, BytePerLine);
        end;{for i := ...}
    { Reset Stream }
      Seek(0, soFrombeginning);
    end;{with ABmpStream, APcxFileRec do}
  end;{INTERNAL procedure _WriteToStream}

  {------------------------------------}

begin
{ Load PCX file Header }
  APcxStream.Seek(0, soFrombeginning);
  APcxStream.Read(APcxFileRec.pcxHeader, SizeOf(APcxFileRec.pcxHeader));
  with APcxFileRec.pcxHeader do
  begin
    pcxWidth  := ((imgRight  - imgLeft) + 1);
    pcxHeight := ((imgBottom - imgTop ) + 1);
  end;
  with APcxFileRec do
  begin
  { Prepare Memory for RLE }
    pcxRleDataSize := APcxStream.Size - SizeOf(pcxHeader) - SizeOf(pcxPalette);
    GetMem(pcxRleData, pcxRleDataSize);
    try
    { Load RLE Data }
      APcxStream.Read(pcxRleData^ , pcxRleDataSize);
    { Load PCX file Palette }
      APcxStream.Read(pcxPalette, SizeOf(pcxPalette));;
    { Prepare Memory for BMP Data }
      ImageLen := pcxWidth * pcxHeight;
      GetMem(ptrImage, ImageLen);
      try
        _ConvertRleToBmp;
        _PrepareHeaders;
        _WriteToStream;
      finally
        FreeMem(ptrImage, ImageLen);
      end;
    finally
      FreeMem(pcxRleData, pcxRleDataSize);
    end;
  end;{with APcxFileRec do}
end;{procedure pcxStreamConvert}

{--------------------------------------}
{ Load PCX from hIstance or From File }

function pcxLoadAsBitmap(const AName: string): TBitMap;
var
  ResHandle : THandle;
  ResPtr    : PByte;
  ResSize   : LongInt;
  MemHandle : THandle;
{ Streams For Convertion }
  msPcxImage : TMemoryStream;
  msBmpImage : TMemoryStream;
begin
//  Result := nil;
  ResHandle := FindResource(hInstance, PChar(AName), pcxResTypeName);
  try
  { if No Resource - Try Load From File ... }
    if ResHandle = 0 then
    begin
      Result := pcxLoadAsBitmapFromFile(AName);
      Exit;
    end;
  { Resource Routine }
    MemHandle := LoadResource(hInstance, ResHandle);
    ResPtr    := LockResource(MemHandle);
    ResSize   := SizeOfResource(hInstance, ResHandle);
  { Load PCX Resource to Memory Stream }
    msPcxImage := TMemoryStream.Create;
    msBmpImage := TMemoryStream.Create;
    try
      with msPcxImage do
      begin
      { Load Resource to Stream }
        SetSize(ResSize);
        write(ResPtr^, ResSize);
      { Free Resource }
        FreeResource(MemHandle);
      { Convert Stream Routine }
        pcxStreamConvert(msPcxImage, msBmpImage);
        Result := TBitmap.Create;
        Result.LoadFromStream(msBmpImage);
      end;
    finally
      msBmpImage.Free;
      msPcxImage.Free;
    end;{try..finally}
  except
    raise Exception.CreateFmt(strErrFromResource, [AName]);
  end;
end;{function pcxLoadAsBitmap}

{--------------------------------------}
{ Load PCX from File }

function pcxLoadAsBitmapFromFile(const AFileName: string): TBitMap;
var
  fsPcxFile : TFileStream;
  msBmpImage: TMemoryStream;
begin
//  Result := nil;
  try
    fsPcxFile  := TFileStream  .Create(AFileName, fmOpenRead or fmShareDenyNone);
    msBmpImage := TMemoryStream.Create;
    try
    { Convert Stream Routine }
      pcxStreamConvert(fsPcxFile, msBmpImage);
      Result := TBitmap.Create;
      Result.LoadFromStream(msBmpImage);
    finally
      msBmpImage.Free;
      fsPcxFile .Free;
    end;
  except
    raise Exception.CreateFmt(strErrFromFile, [AFileName]);
  end;
end;{function pcxLoadAsBitmapFromFile}

{--------------------------------------}
{ Load PCX from Stream }

function pcxLoadAsBitmapFromStream(AStream: TStream): TBitMap;
var
  msBmpImage: TMemoryStream;
begin
//  Result := nil;
  try
    msBmpImage := TMemoryStream.Create;
    try
   { Convert Stream Routine }
      pcxStreamConvert(AStream, msBmpImage);
      Result := TBitmap.Create;
      Result.LoadFromStream(msBmpImage);
    finally
      msBmpImage.Free;
    end;
  except
    raise Exception.Create(strErrFromStream);
  end;
end;{function pcxLoadAsBitmapFromStream}

{--------------------------------------}
{ Load PCX from Stream (From Position and By Size) }

function pcxLoadAsBitmapFromStreamDirectly(AStream: TStream; APosition: LongInt;
  ASize: LongInt): TBitMap;
var
  msPcxImage : TMemoryStream;
  OldPosition: LongInt;
begin
//  Result := nil;
  msPcxImage := TMemoryStream.Create;
  try
  { Prepare Stream for Loading }
    OldPosition := AStream.Position;
    AStream.Position := APosition;
    msPcxImage.SetSize(ASize);
    msPcxImage.CopyFrom(AStream, ASize);
    AStream.Position := OldPosition;
  { Load From Stream }
    Result := pcxLoadAsBitmapFromStream(msPcxImage);
  finally
    msPcxImage.Free;
  end;{try..finally}
end;{function pcxLoadAsBitmapFromStreamDirectly}


{******************************************************************************}
{ Load PCX file to memory }

function LoadPcxFile(const AFileName: string;
  var APcxFileRec: TkrpPcxFileRecord): Boolean;
var
  fsPcxFile : TFileStream;
begin
  fsPcxFile := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    with fsPcxFile, APcxFileRec do
    begin
    { Load PCX file Header }
      Read(pcxHeader, SizeOf(pcxHeader));
    { Get mem and load RLE data }
      pcxRleDataSize := Size - SizeOf(pcxHeader) - SizeOf(pcxPalette);
      GetMem(pcxRleData, pcxRleDataSize);
      Read(pcxRleData^, pcxRleDataSize);
    { Load PCX file Palette }
      Read(pcxPalette, SizeOf(PcxPalette));
      Result := True;
    end;{with fsPcxFile, APcxFile do}
  finally
    fsPcxFile.Free;
  end;
end;{function LoadPcxFile}

{--------------------------------------}
{ Convert Loaded PCX file to Bitmap }

function ConverPcxToBitmap(APcxFileRec: TkrpPcxFileRecord; var ABitmap: HBitmap;
  var APalette: HPalette): Boolean;
var
  RleDataPointer,
  ImagePointer : LongInt; { Used like pointers }
  ImageLen,
  Count,
  BytesCount   : LongInt;
  Image        : Pointer;
  ByteOfData   : Byte;
  i            : Integer;
  BitmapRecord : Windows.TBITMAP;
  PaletteRecord: Windows.TLOGPALETTE;
  PalEntries   : array[0..255] of Windows.TPALETTEENTRY;
begin
  with APcxFileRec, APcxFileRec.PcxHeader do
  begin
  { Get memory for Image = Width * Height by BPP }
  { ImageLen  := (HRes * VRes * BitPerPixel + 7) div 8; {}
    ImageLen  := (HRes * VRes); {}
    GetMem(Image, ImageLen);
  { Convert RLE Data To Image Data (Bitmap format) (Word Aligned Width ?) }
    ImagePointer    := Integer(Image);
    RleDataPointer  := Integer(PcxRleData);
    Count := 0;
    while Count <= ImageLen do
    begin
    { read One Byte of Data }
      ByteOfData := Byte(Pointer(RleDataPointer)^);
    { Check This Byte }
      if ByteOfData >= 192 then
      begin { Byte is technickal = (Length of bytes row + 192) }
        BytesCount := ByteOfData - 192;
      { Êead next byte - Real value of color }
        Inc(RleDataPointer);
        ByteOfData := Byte(Pointer(RleDataPointer)^);
      { Fill row of bytes }
        FillChar(Pointer(ImagePointer + Count)^, BytesCount, ByteOfData);
        Inc(Count, BytesCount);
      end else
      begin { Byte is color data }
      { Simple copy the byte }
        Byte(Pointer(ImagePointer + Count)^) := ByteOfData ;
        Inc(Count);
      end;{if else}
    { Prepare for next step (byte) }
      Inc(RleDataPointer);
    end;{while Count < ImageLen do}
  { Prepare Bitmap info record and Create Bitmap }
    with BitmapRecord do
    begin
      bmType        := 0;
      bmWidth       := HRes;
      bmHeight      := VRes;
      bmWidthBytes  := ((HRes + 1) div 2) * 2; { Word Aligned Width }
      bmPlanes      := NumPlanes;
      bmBitsPixel   := BitPerPixel;            { 256 colors }
      bmBits        := Image;
    end;{with BitmapRecord do}
    ABitmap := CreateBitmapIndirect(BitmapRecord);
  { Prepare Palette info record and Create Palette }
    for i := 0 to 255 do
      with pcxPalette[i], PalEntries[i] do
      begin
        peRed    := Red;
        peGreen  := Green;
        peBlue   := Blue;
        peFlags  := 0;
      end;
    with PaletteRecord do
    begin
      palVersion     := $300;
      palNumEntries  := 256;
      palPalEntry[0] := PalEntries[0];
    end;
    APalette := CreatePalette(PaletteRecord);
  end;{with AImage, AImage.PcxHeader do}
  Result := True;
end;{function ConverTkrpPcxToBitmap}

{--------------------------------------}
{ Load Pcx File and Convert Data to Bitmap and Palette }

function LoadPcxFileToBitmap(const AFileName: string; var ABitmap: HBitmap;
  var APalette: HPalette): Boolean;
var
  APcxFileRecord: TkrpPcxFileRecord;
begin
  Result := False;
{ Load PCX File Data }
  if not LoadPcxFile(AFileName, APcxFileRecord) then Exit;
{ Convert Data to Bitmap and Palette }
  try
    Result := ConverPcxToBitmap(APcxFileRecord, ABitmap, APalette);
  finally
    FreeMem(APcxFileRecord.PcxRleData, APcxFileRecord.PcxRleDataSize);
  end;
end;{function LoadPcxFileToBitmap}


{******************************************************************************}
initialization
{******************************************************************************}
{$IfDef krpRegions_UsePcx}
  Registerclass(TkrpPcx);
  TPicture.RegisterFileFormat('PCX', 'PCX image file', TkrpPcx);
{$EndIf krpRegions_UsePcx}

{******************************************************************************}
finalization
{******************************************************************************}
{$IfDef krpRegions_UsePcx}
  {$IfDef D3}
  TPicture.UnregisterGraphicclass(TkrpPcx);
  {$EndIf D3}
{$EndIf krpRegions_UsePcx}

end{unit krpRegionsPcx}.
