{*******************************************************************************

  krpRegions library. krpRegions library About form.

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
unit krpRegionsAboutForm;

{$I krpRegions.inc}

interface

uses
  Windows, Messages, SysUtils, classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, krpRegionsImages, krpRegionsSkingines,
  krpRegionsComponents, krpRegionsSkins;

type

//==============================================================================
// TfrmkrpRegionLibraryAbout
//==============================================================================

  TfrmkrpRegionLibraryAbout = class(TForm)
    lb1: TLabel;
      lbEmail: TLabel;
    lb2: TLabel;
      lbWeb: TLabel;
    lb3: TLabel;
      lbOrder: TLabel;
    crOk: TkrpControlRegion;
      pnOk: TPanel;
    skngMain: TkrpColorSkingine;
    sknMain: TkrpSkin;
    procedure FormCreate(Sender: TObject);
    procedure lbEmailClick(Sender: TObject);
    procedure lbWebClick(Sender: TObject);
    procedure lbOrderClick(Sender: TObject);
    procedure lbEmailMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbEmailMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnOkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnOkMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;


//==============================================================================
//  Exporting routines
//==============================================================================

//------------------------------------------------------------------------------
// Shows krpRegions library About dialog.
procedure krpRegionsLibraryAbout;

{******************************************************************************}
implementation
{******************************************************************************}
{$R *.DFM}
uses
  ShellApi, krpRegionsConsts, krpRegionsProcs;

//------------------------------------------------------------------------------
// Shows krpRegions library About dialog.

procedure krpRegionsLibraryAbout;
begin
  with TfrmkrpRegionLibraryAbout.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;


//==============================================================================
// TfrmkrpRegionLibraryAbout
//==============================================================================
{ TfrmkrpRegionLibraryAbout }

procedure TfrmkrpRegionLibraryAbout.FormCreate(Sender: TObject);
begin
{$IfDef D3}
  lbEmail.Cursor := crHandPoint;
  lbWeb  .Cursor := crHandPoint;
  lbOrder.Cursor := crHandPoint;
  pnOk   .Cursor := crHandPoint;
{$EndIf D3}
  lbEmail.Font.Color := clLink;
  lbWeb  .Font.Color := clLink;
  lbOrder.Font.Color := clLink;
end;

//------------------------------------------------------------------------------

procedure TfrmkrpRegionLibraryAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_ESCAPE, VK_RETURN] then Close;
end;

//------------------------------------------------------------------------------

procedure TfrmkrpRegionLibraryAbout.lbEmailClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open',
    PChar('mailto:' + SkrpEmail + '?subject=From krpRegions library about...'),
    nil, nil, SW_SHOW);
end;

//------------------------------------------------------------------------------

procedure TfrmkrpRegionLibraryAbout.lbWebClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('http://' + SkrpWeb), nil,
    nil, SW_SHOW);
end;

//------------------------------------------------------------------------------

procedure TfrmkrpRegionLibraryAbout.lbOrderClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('http://' + SkrpWeb_Register),
    nil, nil, SW_SHOW);
end;

//------------------------------------------------------------------------------

procedure TfrmkrpRegionLibraryAbout.lbEmailMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Font.Color := clYellow;
end;

//------------------------------------------------------------------------------

procedure TfrmkrpRegionLibraryAbout.lbEmailMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Font.Color := clLink;
end;

//------------------------------------------------------------------------------

procedure TfrmkrpRegionLibraryAbout.pnOkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  crOk.BorderLowered := True;
end;

//------------------------------------------------------------------------------

procedure TfrmkrpRegionLibraryAbout.pnOkMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  crOk.BorderLowered := False;
end;

//------------------------------------------------------------------------------

procedure TfrmkrpRegionLibraryAbout.pnOkClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

end{unit krpRegionsAboutForm}.
