{*******************************************************************************

  krpRegions library. Skin preview form.

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
unit krpRegionsSkinPreviewForm;

{$I krpRegions.inc}

interface

uses
  Windows, Messages, SysUtils, classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, krpRegionsSkins;

type

//==============================================================================
// TfrmSkinPreview
//==============================================================================

  TfrmSkinPreview = class(TForm)
    pgc1: TPageControl;
      tsMask: TTabSheet;
        imMask: TImage;
      tsNormal: TTabSheet;
        imNormal: TImage;
      tsSelected: TTabSheet;
        imSelected: TImage;
      tsActive: TTabSheet;
        imActive: TImage;
      tsDisabled: TTabSheet;
        imDisabled: TImage;
    pnInfoBorder: TPanel;
      pnInfo: TPanel;
        lb1: TLabel;
          lbProject: TLabel;
        lb2: TLabel;
          lbDescription: TLabel;
        lb3: TLabel;
          lbVersion: TLabel;
        lb4: TLabel;
          lbAuthor: TLabel;
        lb5: TLabel;
          lbCopyright: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;{TfrmSkinPreview = class(TForm)}


//==============================================================================
// Preview routines
//==============================================================================

procedure krpSkinPreviewFromGraphics(const ACaption: string;
  const G0, G1, G2, G3, G4: TGraphic);
procedure krpSkinPreviewFromFiles(const ACaption: string;
  const F0, F1, F2, F3, F4: string);
procedure krpSkinPreviewFromSkinFile(const ASkinFile: TkrpSkinFile);

{******************************************************************************}
implementation
{******************************************************************************}
{$R *.DFM}
uses
  krpRegionsProcs;

const
  intFormResizeX = 30;
  intFormResizeY = 70;

//------------------------------------------------------------------------------

procedure krpSkinPreviewFromGraphics(const ACaption: string;
  const G0, G1, G2, G3, G4: TGraphic);
begin
  with TfrmSkinPreview.Create(nil) do
  try
  // Hide info panel
    pnInfoBorder.Visible := False;
    Caption := ACaption;
  // Asign skin pictures
    imMask    .Picture.Assign(G0);
    imNormal  .Picture.Assign(G1);
    imSelected.Picture.Assign(G2);
    imActive  .Picture.Assign(G3);
    imDisabled.Picture.Assign(G4);
  // Resize form to show all image area
    if Assigned(imMask.Picture) and (not imMask.Picture.Graphic.Empty) then
    begin
      Width  := imMask.Picture.Width  + intFormResizeX;
      Height := imMask.Picture.Height + intFormResizeY;
    end;
  // Show form
    ShowModal;
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------

procedure krpSkinPreviewFromFiles(const ACaption: string;
  const F0, F1, F2, F3, F4: string);
begin
  with TfrmSkinPreview.Create(nil) do
  try
  // Hide info panel
    pnInfoBorder.Visible := False;
    Caption := ACaption;
  // Load skin pictures
    try
      imMask.Picture.LoadFromFile(F0);
    // Resize form to show all image area
      Width  := imMask.Picture.Width  + intFormResizeX;
      Height := imMask.Picture.Height + intFormResizeY;
    except
      imMask.Picture.Assign(nil);
    end;
    try    imNormal.Picture.LoadFromFile(F1);
    except imNormal.Picture.Assign(nil);
    end;
    try    imSelected.Picture.LoadFromFile(F2);
    except imSelected.Picture.Assign(nil);
    end;
    try    imActive.Picture.LoadFromFile(F3);
    except imActive.Picture.Assign(nil);
    end;
    try    imDisabled.Picture.LoadFromFile(F4);
    except imDisabled.Picture.Assign(nil);
    end;
  // Show form
    ShowModal;
  finally
    Free;
  end;
end;{procedure krpSkinPreviewFromFiles}

//------------------------------------------------------------------------------

procedure krpSkinPreviewFromSkinFile(const ASkinFile: TkrpSkinFile);
var
  Dir: string;
begin
  with ASkinFile, TfrmSkinPreview.Create(nil) do
  try
    Caption := FileName;
  // Load skin pictures
    Dir := DirName;
    try
      imMask.Picture.LoadFromFile(krpExpandRelativeFileNameEx(Dir, MaskName));
    // Resize form to show all image area
      Width  := imMask.Picture.Width  + intFormResizeX;
      Height := imMask.Picture.Height + intFormResizeY  + pnInfoBorder.Height;
    except
      imMask.Picture.Assign(nil);
    end;
    try    imNormal.Picture.LoadFromFile(krpExpandRelativeFileNameEx(Dir, PictureNormal));
    except imNormal.Picture.Assign(nil);
    end;
    try    imSelected.Picture.LoadFromFile(krpExpandRelativeFileNameEx(Dir, PictureSelected));
    except imSelected.Picture.Assign(nil);
    end;
    try    imActive.Picture.LoadFromFile(krpExpandRelativeFileNameEx(Dir, PictureActive));
    except imActive.Picture.Assign(nil);
    end;
    try    imDisabled.Picture.LoadFromFile(krpExpandRelativeFileNameEx(Dir, PictureDisabled));
    except imDisabled.Picture.Assign(nil);
    end;
  // Get file info
    lbProject    .Caption := SkinFile.Project;
    lbDescription.Caption := SkinFile.Description;
    lbVersion    .Caption := SkinFile.Version;
    lbAuthor     .Caption := SkinFile.Author;
    lbCopyright  .Caption := SkinFile.Copyright;
  // Show form
    ShowModal;
  finally
    Free;
  end;
end;{procedure krpSkinPreviewFromSkinFile}


//==============================================================================
// TfrmSkinPreview
//==============================================================================
{ TfrmSkinPreview }

procedure TfrmSkinPreview.FormCreate(Sender: TObject);
begin
{$IfDef D5}
  Constraints.MinWidth := 300;
  Constraints.MinHeight := 300;
{$EndIf D5}
end;

//------------------------------------------------------------------------------

procedure TfrmSkinPreview.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_Escape, VK_Return] then Close;
end;

//------------------------------------------------------------------------------

procedure TfrmSkinPreview.FormResize(Sender: TObject);
begin
{$IfNDef D5}
  if Width  < 300 then Width  := 300;
  if Height < 300 then Height := 300;
{$EndIf D5}
end;

//------------------------------------------------------------------------------

end{unit krpRegionsSkinPreviewForm}.
