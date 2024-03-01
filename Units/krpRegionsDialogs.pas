{*******************************************************************************

  krpRegions library. Dialogs.

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
unit krpRegionsDialogs;

{$I krpRegions.inc}
{$R-}

interface

uses
  Messages, Windows, SysUtils, Classes, Controls, StdCtrls, Graphics,
  ExtCtrls, Buttons, Dialogs,
  krpRegionsSkins;

resourcestring
  SkrpPictureLabel = 'Picture:';
  SkrpPictureDesc  = ' (%dx%d)';
  SkrpPreviewLabel = 'Preview';
  SkrpOpenSkinDialogTitle = 'Load skin';
  SkrpSkinLabel           = 'Skin:';

type

//==============================================================================
// TkrpOpenSkinDialog
//==============================================================================
// Open/preview skin dialog.

  TkrpOpenSkinDialog = class(TOpenDialog)
  private
    FAbout: string;
  protected
    FSkinFile     : TkrpSkinFile;
    FPicture      : TPicture;
    FPicturePanel : TPanel;
    FPictureLabel : TLabel;
    FPreviewButton: TSpeedButton;
    FPaintPanel   : TPanel;
    FPaintBox     : TPaintBox;
    procedure DoClose; override;
    procedure DoSelectionChange; override;
    procedure DoShow; override;
  // Events for controls
    procedure PreviewPaint(Sender: TObject); dynamic;
    procedure PreviewClick(Sender: TObject); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
  published
  // Properties
    property About: string read FAbout write FAbout stored False;
  end;


//==============================================================================
// Exporting routines
//==============================================================================

//------------------------------------------------------------------------------
// Shows OpenSkin dialog
function krpRegionsOpenSkinDialog(var AFileName : string): Boolean;


{******************************************************************************}
implementation
{******************************************************************************}

uses
  Forms, Dlgs, CommDlg,
  krpRegionsConsts, krpRegionsProcs, krpRegionsSkinPreviewForm,
  krpRegionsResources;

//------------------------------------------------------------------------------
// Shows OpenSkin dialog

function krpRegionsOpenSkinDialog(var AFileName : string): Boolean;
begin
  with TkrpOpenSkinDialog.Create(nil) do
  try
    FileName := AFileName;
    Result := Execute;
    if Result then AFileName := FileName;
  finally
    Free;
  end;
end;


//==============================================================================
// TkrpOpenSkinDialog
//==============================================================================
// Open/preview skin dialog.
{ TkrpOpenSkinDialog }

constructor TkrpOpenSkinDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  krpCheckTrialVersion;
  Title     := SkrpOpenSkinDialogTitle;
  Filter    := SkrpSkinFileFilter + '|' + SkrpDefaultFilter;
  fPicture  := TPicture.Create;
  fSkinFile := TkrpSkinFile.Create(nil);

// Create complex preview panel
  fPicturePanel := TPanel.Create(nil);
  with fPicturePanel do
  begin
    Caption := '';
    SetBounds(200, 5, 200, 223);
    BevelOuter  := bvNone;
    BorderWidth := 5;
    TabOrder    := 1;

  // Create PictureLabel
    fPictureLabel := TLabel.Create(nil);
    with fPictureLabel do
    begin
      Caption  := '';
      SetBounds(6, 6, 180, 23);
      Align    := alTop;
      AutoSize := False;
      Parent   := fPicturePanel;
    end;

  // Create PreviewButton
    fPreviewButton := TSpeedButton.Create(nil);
    with fPreviewButton do
    begin
      SetBounds(0, 1, 23, 22);
      Enabled        := False;
      Hint           := SkrpPreviewLabel;
      ParentShowHint := False;
      ShowHint       := True;
      Glyph.LoadFromResourceName(HInstance, SkrpSkinPriviewGlyph);
      OnClick := PreviewClick;
      Parent  := fPicturePanel;
    end;

  // Create PaintPanel
    fPaintPanel := TPanel.Create(nil);
    with fPaintPanel do
    begin
      Caption    := '';
      SetBounds(5, 29, fPicturePanel.Width - 10, fPicturePanel.Height - 10);
      Align      := alClient;
      BevelInner := bvRaised;
      BevelOuter := bvLowered;
      TabOrder   := 0;
      Parent     := fPicturePanel;

   // Create PaintBox
      fPaintBox  := TPaintBox.Create(nil);
      with fPaintBox do
      begin
        Parent := fPaintPanel;
        Align  := alClient;
        OnDblClick := PreviewClick;
        OnPaint    := PreviewPaint;
      end;
    end;

  end;{with fPicturePanel do}
end;{constructor TkrpOpenSkinDialog.Create}

//------------------------------------------------------------------------------

destructor TkrpOpenSkinDialog.Destroy;
begin
  fPaintBox.Free;
  fPaintPanel.Free;
  fPreviewButton.Free;
  fPictureLabel.Free;
  fPicturePanel.Free;
  fPicture.Free;
  fSkinFile.Free;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TkrpOpenSkinDialog.Execute: Boolean;
begin
  if NewStyleControls and not (ofOldStyleDialog in Options) then
    Template := SkrpSkinDlg
  else
    Template := nil;
  Result := inherited Execute;
end;

//------------------------------------------------------------------------------

procedure TkrpOpenSkinDialog.DoClose;
Begin
  inherited DoClose;
// Hide any hint windows left behind
  Application.HideHint;
end;

//------------------------------------------------------------------------------

procedure TkrpOpenSkinDialog.DoSelectionChange;

  //-------------------------------------

  function _ValidFile(const AFileName: string): Boolean;
  begin
    Result := GetFileAttributes(PChar(AFileName)) <> $FFFFFFFF;
  end;{Internal function _ValidFile}

  //-------------------------------------

var
  AFullName: string;
  AValidFile: Boolean;
begin
  AFullName := FileName;
  AValidFile := False;

// Load skin if file is valid
  if FileExists(AFullName) and _ValidFile(AFullName) and Assigned(fSkinFile) then
  try
    if fSkinFile.LoadSkinFromFile(AFullName) then
    begin
{      fPicture.LoadFromFile(krpExpandRelativeFileNameEx(fSkinFile.DirName,
        fSkinFile.MaskName));{}
      fPicture.LoadFromFile(krpExpandRelativeFileNameEx(fSkinFile.DirName,
        fSkinFile.PictureNormal));
      fPictureLabel.Caption := Format(SkrpPictureDesc, [fPicture.Width,
        fPicture.Height]);
      fPreviewButton.Enabled := True;
      AValidFile := True;
    end;
  except
    AValidFile := False;
  end;

// Reset view if wrong file
  if not AValidFile then
  begin
    fPictureLabel .Caption := SkrpSkinLabel;
    fPreviewButton.Enabled := False;
    fPicture.Assign(nil);
    fSkinFile.Reset;
  end;

// Repaint
  fPaintBox.Invalidate;
  inherited DoSelectionChange;
end;{procedure TkrpOpenSkinDialog.DoSelectionChange}

//------------------------------------------------------------------------------

procedure TkrpOpenSkinDialog.DoShow;
var
  PreviewRect, StaticRect: TRect;
begin
// Set preview area to entire dialog
  GetClientRect(Handle, PreviewRect);
  StaticRect := GetStaticRect;

// Move preview area to right of static area
  PreviewRect.Left := StaticRect.Left + (StaticRect.Right - StaticRect.Left);
  fPicturePanel.Left := PreviewRect.Left;
  fPreviewButton.Left := fPaintPanel.BoundsRect.Right - fPreviewButton.Width;
  fPicture.Assign(nil);
  fPicturePanel.ParentWindow := Handle;
  fPaintPanel.SetBounds(5, 29, fPicturePanel.Width - 10,
    fPicturePanel.Height - 10);
  inherited DoShow;
end;


//------------------------------------------------------------------------------
// Events for controls

procedure TkrpOpenSkinDialog.PreviewPaint(Sender: TObject);
var
  DrawRect: TRect;

  //------------------------------------

  procedure _DrawPicture;
  begin
    with DrawRect do
    begin
      if (fPicture.Width > Right) or (fPicture.Height > Bottom) then
      begin
      // Resize rect
        if fPicture.Width >= fPicture.Height then
          Bottom := MulDiv(fPicture.Height, Right, fPicture.Width)
        else
          Right := MulDiv(fPicture.Width, Bottom, fPicture.Height);
      // Stretch draw
        TPaintBox(Sender).Canvas.StretchDraw(DrawRect, fPicture.Graphic);
      end else
      // Natural size draw
        TPaintBox(Sender).Canvas.Draw((Right - fPicture.Width) div 2,
          (Bottom - fPicture.Height) div 2, fPicture.Graphic);
    end;
  end;{Internal procedure _DrawPicture}

  //------------------------------------

  procedure _DrawText;
  begin
    with DrawRect, TPaintBox(Sender).Canvas do
    begin
      TextOut((Right - TextWidth(SkrpNone)) div 2,
        (Bottom - TextHeight(SkrpNone)) div 2, SkrpNone);
    end;
  end;{Internal procedure _DrawText}

  //------------------------------------

begin
  with TPaintBox(Sender) do
  begin
    Align  := alClient;
    Canvas.Brush.Color := Color;
    DrawRect := ClientRect;
//    DrawRect := Rect(0, 0, Width - 10, Height - 10);
    if fPicture.Width > 0 then _DrawPicture else _DrawText;
  end;
end;{procedure TkrpOpenSkinDialog.PaintBoxPaint}

//------------------------------------------------------------------------------

procedure TkrpOpenSkinDialog.PreviewClick(Sender: TObject);
begin
  krpSkinPreviewFromSkinFile(fSkinFile);
end;


{******************************************************************************}
initialization
{******************************************************************************}
{$IfDef krpRegions_Trial}
  krpCheckTrialVersion;
{$EndIf krpRegions_Trial}

end{unit krpRegionsDialogs}.
