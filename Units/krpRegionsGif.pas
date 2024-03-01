{*******************************************************************************

  krpRegions library. GIF file support (based on AntGif unit by KARPOLAN).

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
unit krpRegionsGif;

{$I krpRegions.inc}

{*******************************************************************************
  Install this file like component and standart TPicture properties will
understand the GIF file format. You can use standart TImage component for GIFs
*******************************************************************************}

{*******************************************************************************
  The GIF handling code is based heavily on routines written for Borland
Pascal 7.0 by Sean Wenzel, CIS 71736,1245.
  Thanks to High Gear, Inc. for examples and High Gear VCL
*******************************************************************************}

{$A-}  { Not Aligned packed records }
interface

uses
  Windows, Math, SysUtils, classes, Graphics;

const
  gifMaxScreenWidth      = 2048;
  gifMaxCodes            = 4095;
  strGifHeaderSignature  = 'GIF';
  bmpFileSignature       = $4d42;

type
  TkrpGifFileHeader = packed record
    Signature: array[0..2] of Char; { Header Signature - 'GIF' }
    Version  : array[0..2] of Char; { Gif Format Version : '87a' or '89a' }
  end;

  TkrpGifDataSubBlock = packed record
    Size: Byte;                  { Block's Size }
    Data: array[1..255] of Byte; { Data Block   }
  end;

  TkrpGifLogicalScreendescriptor = packed record
    ScreenWidth         : Word;   { logical screen width in pixels }
    ScreenHeight        : Word;   { logical screen height in pixels }
    packedFields        : Byte;   { screen and color map info - see below }
    BackGroundColorIndex: Byte;   { index to global color table }
    AspectRatio         : Byte;   { pixel aspect ration : actual ratio = (AspectRatio + 15) / 64 }
  end;

  TkrpGifImageDescriptor = packed record
    Separator   : Byte;  { Image Descriptor identifier - always $2C }
    ImageLeftPos: Word;  { X position of image on the logical screen }
    ImageTopPos : Word;  { Y position of image on the logical screen }
    ImageWidth  : Word;  { width of image in pixels }
    ImageHeight : Word;  { height of image in pixels }
    PackedFields: Byte;  { Image and color table data information }
  end;

{ One Item Of Color Table }

  TkrpGifColorItem = packed record
    Red  : Byte;  { Red color element }
    Green: Byte;  { Green color element }
    Blue : Byte;  { Blue color element }
  end;

{ Color Table }
  TkrpGifColorTable = array[0..255] of TkrpGifColorItem;

{ One Line In Decoded Image }
  TkrpGifLineData = array[0..gifMaxScreenWidth] of Byte;

{******************************************************************************}
{ TkrpGif }

  EGif = class(Exception);

  TkrpGif = class(TGraphic)
  private
    fGifStream        : TMemoryStream;    { file stream for the Gif file }
    fBitmap           : TBitmap;
    fBitmapStream     : TMemoryStream;
    fBitmapLineList   : TList;            { Holds TBitmapLine objects }
    fFileName         : TFileName;
    fBitmapInfoHeader : TBitmapInfoHeader;{ File Header for bitmap file }
    Header            : TkrpGifFileHeader;{ Gif file header }
    LogicalScreen     : TkrpGifLogicalScreendescriptor; { Gif screen descriptor }
    ImageDescriptor   : TkrpGifImageDescriptor;         { Gif  image descriptor }
    GlobalColorTable  : TkrpGifColorTable;
    LocalColorTable   : TkrpGifColorTable;
    UseLocalColors    : Boolean;          { True if local colors in use }
    Interlaced        : Boolean;          { True if image is Interlaced }
    LZWCodeSize       : Byte;             { Minimum size of the LZW codes in bits }
    ImageData         : TkrpGifDataSubBlock; { variable to store Incoming Data }
    TableSize         : Word;             { Number of entrys in the color table }
    BitsLeft          : SmallInt;         { bits left in byte }
    BytesLeft         : SmallInt;         { bytes left in block }
    CurrCodeSize      : SmallInt;         { Current size of code in bits }
    ClearCode         : SmallInt;
    endingCode        : SmallInt;
    Slot              : Word;             { Position that the next new code is to be added }
    TopSlot           : Word;             { Highest slot position for the current code size }
    HighCode          : Word;             { highest code that does not require Decoding }
    NextByte          : SmallInt;         { Index to the next byte in the datablock array }
    CurrByte          : Byte;             { the current byte }
    LineBuffer        : TkrpGifLineData;  { array for buffer line output }
    CurrentX          : SmallInt;         { Current screen X location }
    CurrentY          : SmallInt;         { Current screen X location }
    InterlacePass     : Byte;             { interlace pass number }
  { Stack for the Decoded codes }
    DecodeStack       : array[0..gifMaxCodes] of Byte;
  { Prefixes/Suffixes Routine }
    Prefix            : array[0..gifMaxCodes] of SmallInt;
    Suffix            : array[0..gifMaxCodes] of SmallInt;
  { Streams Routine }
    procedure InitCompressionStream;
    procedure ReadSubBlock;
    procedure WriteStream(Stream: TStream; WriteSize: Boolean);
    procedure ReadStream(Size: LongInt; Stream: TStream);
  { Decode Routine }
    procedure DecodeGifHeader;
    procedure DecodeGif;
  { Convert Routine }
    procedure ConverTkrpGif;
    procedure ConverTkrpGifToBmp;
  { Process Routine }
    procedure CheckObjects;
    procedure DrawGifLine;
    function ProcessExtensions: Boolean;
    function NextCode: Word;
  protected
  { Override This }
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
  { Properties Overrides }
    function  GetEmpty: Boolean; override;
    function  GetHeight: Integer; override;
    procedure SetHeight(A: Integer); override;
    function  GetWidth: Integer; override;
    procedure SetWidth(A: Integer); override;
  { Streams Routine }
    procedure ReadData (Stream: TStream); override;
    procedure WriteData(Stream: TStream); override;
  public
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
    property GifStream   : TMemoryStream
      read   fGifStream
      write  fGifStream;
    property Bitmap      : TBitmap
      read   fBitmap
      write  fBitmap;
    property FileName    : TFileName
      read   fFileName;
  { Old Properties }
    property Empty;
    property Height;
    property Modified;
    property Width;
    property OnChange;
  end;{TkrpGif = class(TGraphic)}


{******************************************************************************}
implementation
{******************************************************************************}

const
{ Error Messages constants }
  strNoFile             = 'Gif File Not Found';
  strNoGifFile          = 'File isn''t a Gif File';
  strNoGlobalColorTable = 'Global Color Table Not Found';
  strPreceded           = 'Image Descriptor Preceded';
  strEmptyBlock         = 'Data Block is Empty';
  strWrongCodeSize      = 'Wrong Gif Code Size';
  strWrongCode          = 'Wrong Gif Code';
  strWrongBitSize       = 'Wrong Bit Size';

{ Terminator For Data Blocks }
{  BlockTerminator : Byte = 0;

{ Logical Screen Descriptor Field Masks }
  lsdGlobalColorTable = $80;  { set if global color table follows L.S.D. }
  lsdColorResolution  = $70;  { Color resolution - 3 bits }
  lsdSort             = $08;  { set if global color table is sorted - 1 bit }
  lsdColorTableSize   = $07;  { size of global color table - 3 bits }
														  { Actual size = 2^value+1    - value is 3 bits }
{ Separator For Image Blocks }
  ImageSeparator: Byte = $2C;

{ Image Descriptor Bit Masks }
  idLocalColorTable   = $80;  { set if a local color table follows }
  idInterlaced        = $40;  { set if image is Interlaced }
  idSort              = $20;  { set if color table is sorted }
  idReserved          = $0C;  { reserved - must be set to $00 }
  idColorTableSize    = $07;  { size of color table as above }

{ Indicates end of Gif Data Stream }
{	Trailer : Byte = $3B;

{ Gif89a Standard Introduced Control Extensions }
  ceExtensionIntroducer            = $21;
  ceGraphicControlLabel            = $F9;
  ceGraphicControlBlockSize        = $04;
  cePlainTextLabel                 = $01;
  cePlainTextBlockSize             = $0C;
  ceApplicationExtensionLabel      = $FF;
  ceApplicationExtensionBlockSize  = $0B;
  ceCommentLabel                   = $FE;

{ Bit Masks for Use With Next Code }
  CodeMask: array[0..12] of SmallInt = (
    0,
    $0001, $0003,
    $0007, $000F,
    $001F, $003F,
    $007F, $00FF,
    $01FF, $03FF,
    $07FF, $0FFF);

type

{ Holder of single line of Bitmap image }
  TBitmapLine = class(TObject)
    BitmapLine: TkrpGifLineData;
    LineNumber: SmallInt;
  end;

  TkrpGifExtensionBlock = packed record
    Introducer    : Byte;   { Fixed value of ExtensionIntroducer }
    ExtensionLabel: Byte;
  end;

  TkrpGifGraphicsControlExtension = packed record
    BlockSize    : Byte;  { Size of remaining fields. Always $04 }
    packedFields : Byte;  { Method of graphics disposal to use }
    DelayTime    : Word;  { Hundredths of seconds to wait }
    ColorIndex   : Byte;  { Transparent color index }
    Terminator   : Byte;  { Block terminator. Always 0 }
  end;

  TkrpGifPlainTextExtension = packed record
    BlockSize        : Byte;   { Size of extension block. Always $0C }
    TextGridLeft     : Byte;   { X position of text grid in pixels }
    TextGridTop      : Byte;   { Y position of text grid in pixels }
    TextGridWidth    : Byte;   { Width of the text grid in pixels }
    TextGridHeight   : Byte;   { Height of the text grid in pixels }
    CellWidth        : Byte;   { Width of a grid cell in pixels }
    CellHeight       : Byte;   { Height of a grid cell in pixels }
    TextFgColorIndex : Byte;   { Text foreground color index value }
    TextBgColorIndex : Byte;   { Text background color index value }
  end;

{ The next thing in a plain text extension is one or more data sub-blocks
containing the actual textual information that is to be rendered as a graphic.
Use the TkrpGifDataSubBlock Type. The appearance of the BlockTerminator (0)
marks the end of the Plain Text Extension block. }
  TkrpGifApplicationExtension = packed record
    BlockSize  : Byte;                 { Size of extension block. Always $0B }
    Identifier : array[1..8] of Char;  { Application Identifier }
    AuthentCode: array[1..3] of Byte;  { Application authentication code }
  end;


{******************************************************************************}
{ TkrpGif }

{--------------------------------------}
{ Sort List Routine }

function SortBitmapLineList(Item1, Item2: Pointer) : Integer;
var
  Line1, Line2: TBitmapLine;
begin
  try
  { Convert pointers to typed pointers }
    Line1 := Item1;
    Line2 := Item2;
  { Sort Result }
    Result := Line1.LineNumber - Line2.LineNumber;
  except
    Result := 0;
  end;
end;

{--------------------------------------}
{ Init/Done }

constructor TkrpGif.Create;
begin
  inherited Create;
  fBitmapLineList := TList        .Create;
  fBitmapStream   := TMemoryStream.Create;
  fGifStream      := TMemoryStream.Create;
  fBitmap         := TBitmap      .Create;
end;

{--------------------------------------}

destructor TkrpGif.Destroy;
begin
  fBitmap      .Free;
  fGifStream   .Free;
  fBitmapStream.Free;
{ frees all of the bitmap line objects, then clears the list }
  if Assigned(fBitmapLineList) then
  begin
    fBitmapLineList.Clear;
    fBitmapLineList.Free;
  end;
  inherited Destroy;
end;

{--------------------------------------}
{ Override This }

procedure TkrpGif.Assign(Source: TPersistent);
begin
  if (Source is TkrpGif) then
  begin
    CheckObjects;
    fGifStream.Clear;
    (Source as TkrpGif).GifStream.Seek(0, soFrombeginning);
    fGifStream.LoadFromStream((Source as TkrpGif).GifStream);
    ConverTkrpGif;
    Changed(Self);
  end else
    inherited Assign(Source);
end;

{--------------------------------------}
{ Files Routine }

procedure TkrpGif.LoadFromFile(const FileName : string);
begin
{ For New File }
  if fFileName = FileName then Exit;
{ Check File Existing }
  if not FileExists(FileName) then raise EGif.Create(strNoFile);
{ Check File Extention }
  if (UpperCase(ExtractFileExt(FileName)) <> '.GIF') then
    raise EGif.Create(strNoGifFile);
{ Load From File}
  fFileName := FileName;
  fGifStream.LoadFromFile(fFileName);
  ConverTkrpGif;
end;

{--------------------------------------}

procedure TkrpGif.SaveToFile(const FileName: string);
begin
  fGifStream.SaveToFile(FileName);
end;

{--------------------------------------}
{ Stream Routine }

procedure TkrpGif.LoadFromStream(Stream: TStream);
begin
{ Check For Stream }
  if not Assigned(Stream) then Exit;
{ Loading }
  fGifStream.LoadFromStream(Stream);
  ConverTkrpGif;
  Changed(Self);
end;

{--------------------------------------}

procedure TkrpGif.SaveToStream(Stream: TStream);
begin
  WriteStream(Stream, False);
end;

{--------------------------------------}
{ ClipBoard Routine }

procedure TkrpGif.LoadFromClipBoardFormat(AFormat: Word; AData: THandle;
  APalette: HPalette);
begin
end;

{--------------------------------------}

procedure TkrpGif.SaveToClipBoardFormat(var AFormat: Word; var AData: THandle;
  var APalette: HPalette);
begin
end;

{--------------------------------------}
{ Override This }

procedure TkrpGif.Draw(ACanvas: TCanvas; const Rect: TRect);
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
end;{procedure TkrpGif.Draw}

{--------------------------------------}
{ Properties Overrides }

function TkrpGif.GetEmpty : Boolean;
begin
  Result := fBitmap.Empty;
end;

{--------------------------------------}

function TkrpGif.GetHeight: Integer;
begin
  Result := ImageDescriptor.ImageHeight;
end;

{--------------------------------------}

procedure TkrpGif.SetHeight(A: Integer);
begin
end;

{--------------------------------------}

function TkrpGif.GetWidth: Integer;
begin
  Result := ImageDescriptor.ImageWidth;
end;

{--------------------------------------}

procedure TkrpGif.SetWidth(A: Integer);
begin
end;

{--------------------------------------}
{ Streams Routine }

procedure TkrpGif.ReadData(Stream: TStream);
var
  Size: LongInt;
begin
  Stream.Read(Size, SizeOf(Size));
  ReadStream(Size, Stream);
  CheckObjects;
  ConverTkrpGif;
  Changed(Self);
end;

{--------------------------------------}

procedure TkrpGif.WriteData(Stream: TStream);
begin
  WriteStream(Stream, True);
end;{procedure TkrpGif.WriteData}

{--------------------------------------}
{ Streams Routine }

procedure TkrpGif.InitCompressionStream;
begin
  fGifStream.Read(LZWCodeSize, SizeOf(LZWCodeSize)); { get minimum code size }
{ Check For Correct Code Size }
  if (LZWCodeSize < 2) or (LZWCodeSize > 9) then { valid code sizes 2-9 bits }
    raise EGif.Create(strWrongCodeSize);
{ PreSet variables }
  CurrCodeSize := Succ(LZWCodeSize);             { set the initial code size }
  ClearCode    := (1 shl LZWCodeSize);           { set the clear code }
  endingCode   := Succ(ClearCode);               { set the ending code }
  HighCode     := Pred(ClearCode);               { set the highest code not needing Decoding }
  BytesLeft    := 0;
  BitsLeft     := 0;
  CurrentX     := 0;
  CurrentY     := 0;
end;

{--------------------------------------}

procedure TkrpGif.ReadSubBlock;
begin
{ Get Block Size }
  fGifStream.Read(ImageData.Size, SizeOf(ImageData.Size));
{ Check For Empty Block }
  if ImageData.Size = 0 then raise EGif.Create(strEmptyBlock);
{ Read In Block }
  fGifStream.Read(ImageData.Data, ImageData.Size);
  NextByte  := 1;                                 { Reset Next Byte  }
  BytesLeft := ImageData.Size;                    { Reset Bytes Left }
end;{procedure TkrpGif.ReadSubBlock}

{--------------------------------------}

procedure TkrpGif.ReadStream(Size: LongInt; Stream: TStream);
begin
  fGifStream.SetSize(Size);
  Stream.ReadBuffer(fGifStream.Memory^, Size);
end;

{--------------------------------------}

procedure TkrpGif.WriteStream(Stream: TStream; WriteSize: Boolean);
var
  Size: LongInt;
begin
  Size := fGifStream.Size;
  if WriteSize then Stream.WriteBuffer(Size, SizeOf(Size));
  if Size <> 0 then Stream.WriteBuffer(fGifStream.Memory^, Size);
end;

{--------------------------------------}
{ Decode Routine }

procedure TkrpGif.DecodeGifHeader;
begin
{ Read Header }
  fGifStream.Read(Header, SizeOf(Header));
{ Check For Right Header }
  if Header.Signature <> strGifHeaderSignature then
    raise EGif.Create(strNoGifFile);
{ Work Arround LogicalScreen }
  fGifStream.Read(LogicalScreen, SizeOf(LogicalScreen));
{ Check For Color Table }
  if (LogicalScreen.PackedFields and
    lsdGlobalColorTable) <> lsdGlobalColorTable then
    raise EGif.Create(strNoGlobalColorTable);
{ Read Global Color Table }
  TableSize := Trunc(Power(2,(LogicalScreen.PackedFields and
    lsdColorTableSize)+1));
  fGifStream.Read(GlobalColorTable, (TableSize * SizeOf(TkrpGifColorItem)));
{ Check For Preceded }
  if not ProcessExtensions then raise EGif.Create(strPreceded);
{ Read ImageDescriptor }
  with fGifStream do
  begin
  { Move Back 'couse ProcessExtensions Read ImageDescriptor.Separator Too }
    Seek(-SizeOf(ImageDescriptor.Separator), soFromCurrent);
    Read(ImageDescriptor, SizeOf(ImageDescriptor));
  end;
{ Check For Local Color Table }
  if (ImageDescriptor.PackedFields and
    idLocalColorTable) = idLocalColorTable then
  begin
   { Read Local Color Table }
    TableSize := Trunc(Power(2,(ImageDescriptor.PackedFields and
      idColorTableSize) + 1));
    fGifStream.Read(LocalColorTable, (TableSize * SizeOf(TkrpGifColorItem)));
    UseLocalColors := True;
  end else
    UseLocalColors := False;
{ Check For Interlaced }
  if (ImageDescriptor.PackedFields and idInterlaced) = idInterlaced then
  begin
    Interlaced    := True;
    InterlacePass := 0;
  end;
{ Check For Stream Error }
  if not Assigned(fGifStream) then raise EGif.Create(strNoFile);
end;{procedure TkrpGif.DecodeGifHeader}


{--------------------------------------}
{ Procedure Actually Decodes Gif Image. Special Thancks Sean Wenzel and
  High Gear, Inc. }

procedure TkrpGif.DecodeGif;
var
  SP           : SmallInt;     { index to the Decode stack }
  TempOldCode,
  OldCode      : Word;
  BufCnt       : Word;         { line buffer counter }
  Code, C      : Word;
  CurrBuf      : Word;         { line buffer index }
  MaxedOut     : Boolean;

  {------------------------------------}
  { Local procedure that Decodes a code and puts it on the Decode stack }

  procedure _DecodeCode(var Code: Word);
  begin
    while Code > HighCode do            { rip thru the prefix list placing suffixes }
    begin                              { onto the Decode stack }
      DecodeStack[SP] := Suffix[Code]; { put the suffix on the Decode stack }
      Inc(SP);                         { Increment Decode stack index }
      Code := Prefix[Code];            { get the new prefix }
    end;
    DecodeStack[SP] := Code;            { put the last code onto the Decode stack }
    Inc(SP);                            { Increment the Decode stack index }
  end;{INTERNAL procedure _DecoeCode}

  {------------------------------------}

  procedure _WorkArroundClearCode;
  begin
    CurrCodeSize := LZWCodeSize + 1;         { reset the code size }
    Slot         := endingCode  + 1;         { set slot for next new code }
    TopSlot      := (1 shl CurrCodeSize);    { set max slot number }
  { Read until all clear codes gone - shouldn't happen }
    while C = ClearCode do
      C := NextCode;
  { Check For endingCode After Clear }
    if C = EndingCode then raise EGif.Create(strWrongCode);
  { Set to Zero if Code is Beyond Preset Codes }
    if C >= Slot then C := 0;
    OldCode := C;
  { Output Code to Decoded Stack }
    DecodeStack[SP] := C;
    Inc(SP);
  end;{INTERNAL procedure _WorkArroundClearCode}

  {------------------------------------}

  procedure _WorkArroundCodeInTable;
  begin
    _DecodeCode(Code);                { Decode the code }
    if Slot <= TopSlot then
    begin                             { add the new code to the table }
      Suffix[Slot] := Code;           { make the suffix }
      PreFix[slot] := OldCode;        { the previous code - a link to the data }
      Inc(Slot);                      { Increment slot number }
      OldCode := C;                   { set oldcode }
    end;
    if Slot >= TopSlot then
    begin { Have Reached Top Slot for Bit Size }
      if CurrCodeSize < 12 then       { new bit size not too big? }
      begin
        TopSlot := (TopSlot shl 1);  { new top slot }
        Inc(CurrCodeSize);           { new code size }
      end else
        MaxedOut := True;
    end;
  end;{INTERNAL procedure _WorkArroundCodeInTable}

  {------------------------------------}

  procedure _WorkArroundCodeOutOfTable;
  begin
  { Check For Next Available Slot }
    if Code <> Slot then raise EGif.Create(strWrongCode);
  { The code does not exist so make a new entry in the code table
      and then translate the new code ** }
    TempOldCode := OldCode;                { make a copy of the old code }
    while OldCode > HighCode do            { translate the old code and place it }
    begin                                 { on the Decode stack }
      DecodeStack[SP] := Suffix[OldCode]; { do the suffix }
      OldCode         := Prefix[OldCode]; { get next prefix }
    end;{ while OldCode > HighCode do}
  { Put the code onto the Decode stack but DO NOT Increment stack index because
    because we are only translating the oldcode to get the first Character }
    DecodeStack[SP] := OldCode;
    if Slot <= TopSlot then
    begin                                { make new code entry }
      Suffix[Slot] := OldCode;           { first Char of old code }
      Prefix[Slot] := TempOldCode;       { link to the old code prefix }
      Inc(Slot);                         { Increment slot }
    end;
    if Slot >= TopSlot then               { slot is too big }
    begin                                { Increment code size }
      if CurrCodeSize < 12 then
      begin
        TopSlot := (TopSlot shl 1);     { new top slot }
        Inc(CurrCodeSize);              { new code size }
      end else
        MaxedOut := True;
    end;
  { Now that the table entry exists Decode it set the new old code }
    _DecodeCode(Code);
    OldCode := C;
  end;{INTERNAL procedure _WorkArroundCodeOutOfTable}

  {------------------------------------}

  procedure _PutToLineBuffer;
  begin
    while SP > 0 do
    begin
      Dec(SP);
      LineBuffer[CurrBuf] := DecodeStack[SP];
      Inc(CurrBuf);
      Dec(BufCnt);
      if BufCnt = 0 then
      begin { Line is Full }
        DrawGifLine;
        CurrBuf := 0;
        BufCnt := ImageDescriptor.ImageWidth;
      end;{if BufCnt = 0 then}
    end;
  end;{INTERNAL procedure _PutToLineBuffer}

  {------------------------------------}

begin
{ Initialize Decoding Paramaters }
  InitCompressionStream;
{ PreSet variables }
  OldCode  := 0;
  SP       := 0;
  BufCnt   := ImageDescriptor.ImageWidth; { Set Image Width }
  CurrBuf  := 0;
  MaxedOut := False;
{ Run thru a loop }
  C := NextCode;                                 { get the initial code - should be a clear code }
  while C <> EndingCode do                       { main loop until ending code is found }
  begin
    if C <> ClearCode then
    begin { Code Must be Decoded }
      Code := C;
      if Code < Slot then _WorkArroundCodeInTable
      else _WorkArroundCodeOutOfTable;
    end else
      _WorkArroundClearCode;
  { The Decoded string is on the Decode stack so pop it off and put it into
    the line buffer }
    _PutToLineBuffer;
  { Get Next Code }
    C := NextCode;
  { Check For Error}
    if (MaxedOut) and (C <> ClearCode) then raise EGif.Create(strWrongBitSize);
    MaxedOut := False;
  end;{while C <> endingCode do}
end;{procedure TkrpGif.DecodeGif}

{--------------------------------------}
{ Process Routine }

procedure TkrpGif.CheckObjects;
begin
  if not Assigned(fGifStream) then fGifStream := TMemoryStream.Create;
  if not Assigned(fBitmap) then fBitmap := TBitmap.Create;
  if not Assigned(fBitmapStream) then fBitmapStream := TMemoryStream.Create;
  if not Assigned(fBitmapLineList) then fBitmapLineList := TList.Create;
end;

{--------------------------------------}

procedure TkrpGif.DrawGifLine;
var
  NewLine: TBitmapLine;
begin
{ Rather than writing the image line to the screen, we're going to instantiate
  a bitmap line and put the line there. }
  NewLine := TBitmapLine.Create;
  with NewLine do
  begin
    BitmapLine := LineBuffer;
    LineNumber := CurrentY;
  end;
{ Add New Line }
  fBitmapLineList.Add(NewLine);
	Inc(CurrentY);
{ Work Arround Interlaced }
	if Interlaced then
  begin
  { Incremental Process }
    case InterlacePass of
      0: Inc(CurrentY, 7);
      1: Inc(CurrentY, 7);
      2: Inc(CurrentY, 3);
      3: Inc(CurrentY, 1);
    end;
  { Check Out Of Image }
    if CurrentY >= ImageDescriptor.ImageHeight then
    begin
      Inc(InterlacePass);
      case InterlacePass of
        1: CurrentY := 4;
        2: CurrentY := 2;
        3: CurrentY := 1;
      end;
    end;
  end;{if Interlaced then}
end;{procedure TkrpGif.DrawGifLine}

{--------------------------------------}

function TkrpGif.ProcessExtensions: Boolean;
var
  AExtensionBlock           : TkrpGifExtensionBlock;
  AGraphicsControlExtension : TkrpGifGraphicsControlExtension;
  APlainTextExtension       : TkrpGifPlainTextExtension;
  AApplicationExtension     : TkrpGifApplicationExtension;

  {------------------------------------}

  procedure ProcessSubBlocks;
  var
    ASubBlock : TkrpGifDataSubBlock;
  begin
  { Get Data Block Size }
    fGifStream.Read(ASubBlock.Size, SizeOf(ASubBlock.Size));
    while ASubBlock.Size <> 0 do
    begin
      fGifStream.Read(ASubBlock.Data, ASubBlock.Size);
      fGifStream.Read(ASubBlock.Size, SizeOf(ASubBlock.Size));
    end;
  end;{INTERNAL procedure _ProcessSubBlocks}

  {------------------------------------}

  procedure _ProcessGraphicControl;
  begin
    fGifStream.Read(AGraphicsControlExtension, SizeOf(AGraphicsControlExtension));
  end;{INTERNAL procedure _ProcessGraphicControl}

  {------------------------------------}

  procedure _ProcessComment;
  begin
    ProcessSubBlocks;
  end;{INTERNAL procedure _ProcessComment}

  {------------------------------------}

  procedure _ProcessApplication;
  begin
    fGifStream.Read(AApplicationExtension, SizeOf(AApplicationExtension));
    ProcessSubBlocks;
  end;{INTERNAL procedure _ProcessApplication}

  {------------------------------------}

  procedure _ProcessPlainText;
  begin
    fGifStream.Read(APlainTextExtension, SizeOf(APlainTextExtension));
    ProcessSubBlocks;
  end;{INTERNAL procedure _ProcessPlainText}

  {------------------------------------}

begin
  Result := True;
{ Read image descriptor separator }
  fGifStream.Read(ImageDescriptor.Separator, SizeOf(ImageDescriptor.Separator));
{ Run thru a Loop  }
  while (ImageDescriptor.Separator <> ImageSeparator) do
    if (ImageDescriptor.Separator = ceExtensionIntroducer) then
    begin
    { Read ExtensionLabel }
      fGifStream.Read(AExtensionBlock.ExtensionLabel,
        SizeOf(AExtensionBlock.ExtensionLabel));
    { Separate Process by ExtensionLabel }
      case (AExtensionBlock.ExtensionLabel) of
        cePlainTextLabel            : _ProcessPlainText;
        ceGraphicControlLabel       : _ProcessGraphicControl;
        ceCommentLabel              : _ProcessComment;
        ceApplicationExtensionLabel : _ProcessApplication;
      end;
    { Read Separator }
      fGifStream.Read(ImageDescriptor.Separator,
        SizeOf(ImageDescriptor.Separator));
    end else
      Result := False;
end;{function TkrpGif.ProcessExtensions}

{--------------------------------------}
{ Returns a code of the proper Bit Size }

function TkrpGif.NextCode: Word;
begin
  if BitsLeft = 0 then
  begin
  { Check for Another Block }
    if BytesLeft <= 0 then ReadSubBlock;
    CurrByte := ImageData.Data[NextByte]; { get a byte }
    Inc(NextByte);                        { set the next byte index }
    BitsLeft := 8;                        { set bits left in the byte }
    Dec(BytesLeft);                       { Decrement the bytes left counter }
  end;
  Result := CurrByte shr (8 - BitsLeft);  { shift off any previosly used bits}
  while CurrCodeSize > BitsLeft do               { need more bits ? }
  begin
  { Check For Bytes Left In Block }
    if BytesLeft <= 0 then ReadSubBlock;
    CurrByte := ImageData.Data[NextByte];         { get another byte }
    Inc(NextByte);                                { Increment NextByte counter }
    Result   := Result or (CurrByte shl BitsLeft);{ add the remaining bits to the return value }
    Inc(BitsLeft, 8);                              { set bit counter }
    Dec(BytesLeft);                               { Decrement bytesleft counter }
  end;
  BitsLeft := BitsLeft - CurrCodeSize;             { subtract the code size from bitsleft }
  Result   := (Result and CodeMask[CurrCodeSize]); { mask off the right number of bits }
end;{function TkrpGif.NextCode}

{--------------------------------------}
{ Convert Routine }

procedure TkrpGif.ConverTkrpGif;

  procedure _DeleteLinesAndClearList;
  var
    TempLine: TBitmapLine;
    i : Integer;
  begin
    if fBitmapLineList.Count > 0 then
      for i := (fBitmapLineList.Count - 1) downto 0 do
      begin
        TempLine := fBitmapLineList.Items[i];
        fBitmapLineList.Delete(i);
        TempLine.Free;
      end;
    fBitmapLineList.Clear;
  end;{INTERNAL procedure _DeleteLinesAndClearList}

begin
{ Start a decoding }
  CheckObjects;
  DecodeGifHeader;
{ ReCreate lines list if it is needed }
  if not Assigned(fBitmapLineList) then fBitmapLineList := TList.Create;
{ Free lines list}
  _DeleteLinesAndClearList;
{ Set new list size (Capacity) }
  fBitmapLineList.Capacity := ImageDescriptor.ImageHeight;
{ Gif To BMP}
  DecodeGif;
  ConverTkrpGifToBmp;
{ Free lines list}
  _DeleteLinesAndClearList;
end;{procedure TkrpGif.ConverTkrpGif}

{--------------------------------------}

procedure TkrpGif.ConverTkrpGifToBmp;
var
  ABitmapFileHeader : TBitmapFileHeader;
  ARGDQuad          : TRGBQuad;
  i, ImageWidth,
  BoundarySize      : Integer;
const
  Bounder: LongInt = $00000000;
begin
{ Prepare Bitmap Info Header }
  with fBitmapInfoHeader do
  begin
    biSize          := SizeOf(fBitmapInfoHeader);
    biWidth         := ImageDescriptor.ImageWidth;
    biHeight        := ImageDescriptor.ImageHeight;
    biPlanes        := 1;
    biBitCount      := 8;
    biCompression   := BI_RGB; { Not Compressed Bitmap }
    biSizeImage     := 0;
    biXPelsPerMeter := 143;
    biYPelsPerMeter := 143;
    biClrUsed       := 0;
    biClrImportant  := 0;
  end;
{ Set Image Size And Calculate Boundary Size }
  ImageWidth   := ImageDescriptor.ImageWidth;
  BoundarySize := ImageWidth mod 4;
  if BoundarySize <> 0 then BoundarySize := 4 - BoundarySize;
{ Prepare Bitmap File Header }
  with ABitmapFileHeader do
  begin
    bfType := bmpFileSignature;
    bfOffBits := 1024 + { Palettte } SizeOf(ABitmapFileHeader) +
      SizeOf(fBitmapInfoHeader);
    bfSize := bfOffBits + (ImageDescriptor.ImageHeight *
      (ImageDescriptor.ImageWidth + BoundarySize));
    bfReserved1 := 0;
    bfReserved2 := 0;
  end;
{ Check fBitmapStream}
  if not Assigned(fBitmapStream) then fBitmapStream := TMemoryStream.Create;
{ Write To fBitmapStream }
  with fBitmapStream do
  begin
    Clear;
  { Write Headers }
    Write(ABitmapFileHeader, SizeOf(ABitmapFileHeader));
    Write(fBitmapInfoHeader, SizeOf(fBitmapInfoHeader));
  { Write RGB Palette }
    ARGDQuad.rgbReserved := 0; { Preset Reserved Byte }
    if UseLocalColors then
      for i := 0 to 255 do
      begin
        with ARGDQuad do
        begin
          rgbRed   := LocalColorTable[i].Red;
          rgbGreen := LocalColorTable[i].Green;
          rgbBlue  := LocalColorTable[i].Blue;
        end;
        Write(ARGDQuad, SizeOf(ARGDQuad));
      end
    else
      for i := 0 to 255 do
      begin
        with ARGDQuad do
        begin
          rgbRed   := GlobalColorTable[i].Red;
          rgbGreen := GlobalColorTable[i].Green;
          rgbBlue  := GlobalColorTable[i].Blue;
        end;
        Write(ARGDQuad, SizeOf(ARGDQuad));
      end;
  { Sort List if Needed }
    if Interlaced then fBitmapLineList.Sort(SortBitmapLineList);
  { Write All Lines to Stream (Reverse Order) }
    for i := (fBitmapLineList.Count - 1) downto 0 do
    begin
      Write(TBitmapLine(fBitmapLineList.Items[i]).BitmapLine, ImageWidth);
    { Additional Zeros for Right BMP Line Size (MUST BE 32 Bit Aligned) }
      Write(Bounder, BoundarySize);
    end;
  { Reset Stream }
    Seek(0, soFromBeginning);
  end;{with fBitmapStream do}

{ Reload Bitmap from Stream }
  fBitmap.LoadFromStream(fBitmapStream);
end;{procedure TkrpGif.ConverTkrpGifToBmp}


{**************************************************************************}
initialization
{**************************************************************************}
{$IfDef krpRegions_UseGif}
  Registerclass(TkrpGif);
  TPicture.RegisterFileFormat('GIF', 'GIF image file', TkrpGif);
{$EndIf krpRegions_UseGif}

{**************************************************************************}
finalization
{**************************************************************************}
{$IfDef krpRegions_UseGif}
  {$IfDef D3}
  TPicture.UnregisterGraphicclass(TkrpGif);
  {$EndIf D3}
{$EndIf krpRegions_UseGif}

end{unit krpRegionsGif}.
