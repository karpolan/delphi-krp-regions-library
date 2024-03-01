{*******************************************************************************

  Lens - magnifying glass, Upgrade from the Web form.

  Author:    KARPOLAN
  E-Mail:    karpolan@ABFsoftware.com, karpolan@i.am
  WEB:       http://www.ABFsoftware.com, http://karpolan.i.am
  Copyright © 1996-2000 by KARPOLAN.
  Copyright © 1999 UtilMind Solutions.
  Copyright © 2000 ABF software, Inc.
  All rights reserved.

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

  DISCLAIMER

  THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS WITHOUT WARRANTY OF ANY KIND,
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE PERSON USING THE
SOFTWARE BEARS ALL RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE.
THE AUTHOR WILL NOT BE LIABLE FOR ANY SPECIAL, INCIDENTAL, CONSEQUENTIAL,
INDIRECT OR SIMILAR DAMAGES DUE TO LOSS OF DATA OR ANY OTHER REASON, EVEN IF
THE AUTHOR OR AN AGENT OF THE AUTHOR HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES. IN NO EVENT SHALL THE AUTHOR'S LIABILITY FOR ANY DAMAGES EVER
EXCEED THE PRICE PAID FOR THE LICENSE TO USE THE SOFTWARE, REGARDLESS OF THE
FORM OF THE CLAIM.

** History: ********************************************************************

  29 oct 1999 - 1.0 first release.
  02 nov 1999 - 1.1 added keyboard support. Skin, position and zoom values
    are stored in the system registry now.
  05 nov 1999 - 1.11 fixed bug under Win95 (Square lens)....
  09 nov 1999 - 1.2 added Help.
  27 nov 1999 - 1.21 Added new features of the krpRegions library version 1.1,
    fixed help file.
  06 jun 2000 - 1.3 Added new features of the krpRegions library version 1.2,
    Now distributed by ABF software, Inc. <http://www.ABFsoftware.com>.
    Some minor changes.
  16 jun 2000 - 1.31 Fixed bug under Windows NT and Windows 2000 in 15/16 bit
    (32768/65536 colors) video modes. Added color value hint.
  25 nov 2000 - 1.4 Upgrade from the web feature. New skin for people with
    poor eyesight. More keyboard control combination: F9 - BIG skin;
    F5, F6, F7, F8, Shift + "+", Shift + "-" - zoom manipulation. Added more
    languages in the installation program.

*******************************************************************************}
unit LensUpgradeForm;

{$I Lens.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls,
  abfClasses, abfInternet, abfUSF;

type

//==============================================================================
// frmUpgrade
//==============================================================================
// Upgrade from the Web form
// The upgrading process works following way:
// 1. Download "InfoFile" from the URL, specified by the SupgFileInfo const.
// 2. Read loacal copy of "InfoFile" and check is the version specified in the
//    file higher then current version if application (const Version). If the
//    version is not higher then stop process, upgrade is not needed.
// 3. Read the list of files that should be downloaded, and download it to
//    temporary files. Also prepare the list for copying temporary files to
//    destination files.
// 4. Create external process that will try to copy temporary files to
//    destination files as long as all files will succesfully copied.
//    Some files, exe for example, can be locked by system, so the external
//    process will wait until files will be unlocked.
// 5. Terminate the application for unlocking the exe file.

  TfrmUpgrade = class(TForm)
    tmrCopyDone: TTimer;
    tmrStart: TTimer;
    lbStatus: TLabel;
    barProgress: TProgressBar;
    btnUpgrade: TBitBtn;
    btnOkCancel: TBitBtn;
    tmrChecking: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure tmrCopyDoneTimer(Sender: TObject);
    procedure tmrStartTimer(Sender: TObject);
    procedure tmrCheckingTimer(Sender: TObject);
    procedure btnUpgradeClick(Sender: TObject);
  private
    FCopyTread: TabfCustomCopyThread;
    FCopyCopiedSize, FCopyTotalSize: LongWord;
    FCopyDone, FErrorOccurred, FInfoFileDownloaded, FFilesDownloaded: Boolean;
    FInfoFile: TabfUsfFile;
    FInfoFileLocalName: string;
    FFileList: TabfStringList;
    FInstallPath: string; // Install path of program (taken from registry)
    procedure ErrorOccurred;
    procedure CopyDone;
    function DownloadInfoFile: Boolean;
    function DownloadFiles: Boolean;
    function ReplaceLocalFiles: Boolean;
    procedure OnCopyError(Sender: TObject; ErrorCode: LongWord;
      const ErrorMessage: string);
    procedure OnCopyProgress(Sender: TObject; CopiedSize, TotalSize: LongWord;
      var Terminate: Boolean);
  public
    function CheckNewVersion: Boolean;
    function UpgradeToNewVersion: Boolean;
  end;{TfrmUpgrade = class(TForm)}

var
  frmUpgrade: TfrmUpgrade;

//==============================================================================
// Entry point
//==============================================================================

procedure Upgrade;

{******************************************************************************}
implementation
{******************************************************************************}
{$R *.DFM}

uses
  abfConsts, abfSysUtils, abfVclUtils, LensMainForm;

var
  _RestartApp: Boolean = False;
  _UpgradeDone: Boolean = False;

//==============================================================================
// File names, aliases.
//==============================================================================

const
  SupgFileSelf    = 'SELF';     // Alias for the self %Windows%\*.scr file
  SupgFileReadMe  = 'README';   // Alias for %InstallPath%\ReadMe.txt file
  SupgFileLicense = 'LICENSE';  // Alias for %InstallPath%\License.txt file
{$IfDef LocalUpgrade}
  SupgFileInfo    = 'C:\ABF\krpRegions\Demos\Lens\info.usf';
{$Else LocalUpgrade}
  SupgFileInfo    = 'http://www.abfsoftware.com/freeware/Lens/Data/info.usf';
{$EndIf LocalUpgrade}

//==============================================================================
// Messages
//==============================================================================

  SupgError        = 'Upgrade can not be performed now.';
  SupgChecking     = 'Checking for new version...';
  SupgNotAvailable = 'No new version is availabe.';
  SupgAvailable    = 'A new %s version is available.';
  SupgInfoReady    = 'Info file downloaded.';
  SupgDowloading   = 'Downloading %d of %d files...';
  SupgDowloadEnd   = 'Download completed.';
  SupgReplacing    = 'Replacing %d of %d files...';
  SupgReplaceEnd   = 'Replace completed.';
  SupgDone         = 'Upgrade done. Please restart the application.';
  SupgAlreadyDone  = 'Upgrade already done. Please restart the application.';

//==============================================================================
// Entry point
//==============================================================================

procedure Upgrade;
begin
  abfTrace('Upgrade called');
{ Check is upgrde already done }
  if _UpgradeDone then
  begin
    MessageDlg(SupgAlreadyDone, mtInformation, [mbOk], 0);
    abfTrace(SupgAlreadyDone);
    Exit;
  end;
{ Run upgrade routines }
  abfTraceEx('** Upgrade routines Begin **', 2);
  frmUpgrade := TfrmUpgrade.Create(nil);
  try
    abfFormCenterForm(frmUpgrade, nil);
    frmUpgrade.ShowModal;
  finally
    abfTraceEx('** Upgrade routines End ****', -2);
    frmUpgrade.Free;
  end;
{ Check is application should be restarted }
  if _RestartApp then Application.MainForm.Close;
end;


//==============================================================================
// frmUpgrade
//==============================================================================
// Upgrade from the Web form
// The upgrading process works following way:
// 1. Download "InfoFile" from the URL, specified by the SupgFileInfo const.
// 2. Read loacal copy of "InfoFile" and check is the version specified in the
//    file higher then current version if application (const Version). If the
//    version is not higher then stop process, upgrade is not needed.
// 3. Read the list of files that should be downloaded, and download it to
//    temporary files. Also prepare the list for copying temporary files to
//    destination files.
// 4. Create external process that will try to copy temporary files to
//    destination files as long as all files will succesfully copied.
//    Some files, exe for example, can be locked by system, so the external
//    process will wait until files will be unlocked.
// 5. Terminate the application for unlocking the exe file.
// Date: 10/13/2000
{ TfrmUpgrade }

//------------------------------------------------------------------------------
// Downloads "InfoFile" and checks is new version is available. Enables/Disables
// controls depending on the new version status.

function TfrmUpgrade.CheckNewVersion: Boolean;
begin
  lbStatus.Caption := SupgChecking;
  Result := DownloadInfoFile;
  if not Result then
  begin
    ErrorOccurred;
    Exit;
  end;
  Result := (abfStrToVersion(FInfoFile.Version) > Version);
  if not Result then
  begin
    ErrorOccurred;
    lbStatus.Caption := SupgNotAvailable;
    abfTrace(lbStatus.Caption);
    Exit;
  end;
  btnUpgrade.Enabled := True;
  btnUpgrade.Visible := True;
  if btnUpgrade.CanFocus then btnUpgrade.SetFocus;
  lbStatus.Caption := Format(SupgAvailable, [FInfoFile.Version]);
  abfTrace(lbStatus.Caption);
end;

//------------------------------------------------------------------------------
// Downloads all needed files to temporery files, after that replaces local
// files with new ones. If all were done, changes caption of the OkCancel
// button.

function TfrmUpgrade.UpgradeToNewVersion: Boolean;
begin
  Result := False;
  btnUpgrade.Enabled := False;
  btnUpgrade.Visible := False;
  if not DownloadFiles then Exit;
  if not ReplaceLocalFiles then Exit;
  lbStatus.Caption := SupgDone;
//  btnUpgrade.Visible := False;
  btnOkCancel.Caption := 'OK';
  btnOkCancel.ModalResult := mrOk;
  _UpgradeDone := True;
  Result := True;
end;

//------------------------------------------------------------------------------
// Sets flags and control properties to default values. Outputs error message.

procedure TfrmUpgrade.ErrorOccurred;
begin
  FCopyDone := True;
  btnUpgrade.Enabled := False;
  btnUpgrade.Visible := False;
  barProgress.Position := 100;
  lbStatus.Caption := SupgError;
  FErrorOccurred := True;
  if btnOkCancel.CanFocus then btnOkCancel.SetFocus;
end;

//------------------------------------------------------------------------------
// Called each time the copy tread finished copying or downloading

procedure TfrmUpgrade.CopyDone;
begin
  FCopyDone := True;
  FCopyTread := nil; // Set pointer nil for right checking
end;

//------------------------------------------------------------------------------
// Download "InfoFile" from the URL, specified by the SupgFileInfo const.

function TfrmUpgrade.DownloadInfoFile: Boolean;
begin
  Result := False;
  if FInfoFileDownloaded then Exit; // Don't download second time
  barProgress.Position := 8;
{ Get unique name for local copy of InfoFile }
  FInfoFileLocalName := abfGetUniqueTempFileName(Application.Title);
{ Start downloading of InfoFile }
  FCopyDone := False;
  FErrorOccurred := False;
  FCopyTread := {$IfDef LocalUpgrade}TabfLocalCopyThread{$Else}TabfHttpCopyThread{$EndIf}
    .Create(SupgFileInfo, FInfoFileLocalName, False, True, OnCopyError,
    OnCopyProgress, nil);
  abfTrace('Download InfoFile');
{ Wait for the end of downloading }
  tmrChecking.Enabled := True;
  repeat
    Application.ProcessMessages;
    if (ModalResult <> mrNone) or Application.Terminated then Exit;
  until FCopyDone;
  tmrChecking.Enabled := False;
  if FErrorOccurred then Exit;
{ Download completed }
  abfTrace('Download completed');
  lbStatus.Caption := SupgInfoReady;
{ Read local copy of InfoFile }
  FInfoFile := TabfUsfFile.Create(FInfoFileLocalName);
  abfTrace('Local copy of InfoFile loaded');
{ Set flags }
  Result := True;
  FInfoFileDownloaded := Result;
end;{function TfrmUpgrade.DownloadInfoFile}

//------------------------------------------------------------------------------
// Read the list of files that should be downloaded, and download it to
// temporary files. Also prepare the FFileList list for copying temporary files
// to destination files.

function TfrmUpgrade.DownloadFiles: Boolean;
var
  i: Integer;
  S, SrcName, DstName, TmpName, Operation: string;
begin
  Result := False;
  if FFilesDownloaded then Exit; // Don't download second time
  FFileList := TabfStringList.Create; // Create the list for local overwrite
  with FInfoFile.Files do
    for i := 0 to Count - 1 do
    begin
      S := FInfoFile.Files[i];
      Operation := ExtractParameter(S);
    { Check operation, if copy is needed then download file }
      if usfIsCopyOperation(Operation) then
      begin
        barProgress.Position := 0;
        lbStatus.Caption := Format(SupgDowloading, [i + 1, Count]);
      { Get file names }
        SrcName := ExtractName(S);
        DstName := ExtractValue(S);
        TmpName := abfGetUniqueTempFileName(Application.Title);
      { Start downloading of file }
        FCopyDone := False;
        FErrorOccurred := False;
        FCopyTread := {$IfDef LocalUpgrade}TabfLocalCopyThread{$Else}TabfHttpCopyThread{$EndIf}
          .Create(SrcName, TmpName, False, True, OnCopyError,
          OnCopyProgress, nil);
        abfTrace('Downloading ' + SrcName + ' to ' + TmpName);
      { Wait for the end of downloading }
        repeat
          Application.ProcessMessages;
          if (ModalResult <> mrNone) or Application.Terminated then Exit;
        until FCopyDone;
        if FErrorOccurred then Exit;
      { Download completed }
        lbStatus.Caption := SupgDowloadEnd;
        FFileList.Add(TmpName + '=' + DstName + ',' + Operation);
        abfTrace('Download completed');
      end {else
        FFileList.Add(S);{} // Add the line as it is
    end;{for i := 0 to Count - 1 do}
{ Download completed (the last message) }
  lbStatus.Caption := SupgDowloadEnd;
{ Set flags }
  Result := True;
  FFilesDownloaded := Result;
end;{procedure TfrmUpgrade.DownloadFiles}

//------------------------------------------------------------------------------
// Copies temporary files to destination.

function TfrmUpgrade.ReplaceLocalFiles: Boolean;
var
  i: Integer;
  S, SrcName, DstName: string;

  //-------------------------------------

  procedure _TranslateName(var FileName: string);
  begin
    if AnsiCompareText(FileName, SupgFileSelf) = 0 then
    begin
      FileName := ParamStr(0);
      _RestartApp := True;
    end else
    if AnsiCompareText(FileName, SupgFileReadMe) = 0 then
      FileName := FInstallPath + 'ReadMe.txt'
    else
    if AnsiCompareText(FileName, SupgFileLicense) = 0 then
      FileName := FInstallPath + 'License.txt'
    else
      FileName := abfExpandRelativeFileName(FileName);
  end;{Internal _TranslateName}

  //-------------------------------------

begin
  Result := False;
  with FFileList do
    for i := 0 to Count - 1 do
    begin
      barProgress.Position := 0;
      lbStatus.Caption := Format(SupgReplacing, [i + 1, Count]);
      S := FFileList[i];
      SrcName := ExtractName(S);
      DstName := ExtractValue(S);
      _TranslateName(DstName);
    { Check is the DstName the application's exename }
      if DstName = ParamStr(0) then
      begin
        abfReplaceFileAndRun(SrcName, DstName, ''); // Variant 1
//        abfReplaceFile(SrcName, DstName);             // Variant 2
        _RestartApp := True;
        Continue;
      end;
      if not FileExists(SrcName) then Continue;
    { Delete file }
      if FileExists(DstName) then
      begin
        SetFileAttributes(PChar(DstName), FILE_ATTRIBUTE_NORMAL);
        DeleteFile(DstName);
      end;
    { Replace file with new one }
      FCopyDone := False;
      FErrorOccurred := False;
      FCopyTread := TabfLocalCopyThread.Create(SrcName, DstName, False, True,
        OnCopyError, OnCopyProgress, nil);
      abfTrace('Replacing ' + DstName + ' with ' + SrcName);
    { Wait for the end of downloading }
      repeat
        Application.ProcessMessages;
        if (ModalResult <> mrNone) or Application.Terminated then Exit;
      until FCopyDone;
      if FErrorOccurred then Exit;
    { Replacing completed }
      lbStatus.Caption := SupgReplaceEnd;
      abfTrace('Replace completed');
      DeleteFile(SrcName);
    end;
  Result := True;
end;{function TfrmUpgrade.ReplaceLocalFiles}

//------------------------------------------------------------------------------
// Called periodically during the copy process. Updates progress indicator and
// copy flags. Also checks is the copying should be terminated or it is ended.

procedure TfrmUpgrade.OnCopyProgress(Sender: TObject; CopiedSize,
  TotalSize: LongWord; var Terminate: Boolean);
begin
{ Check is form closed or application terminated }
  Terminate := (ModalResult <> mrNone) or Application.Terminated;
  if Terminate then Exit;
{ Update progress indicator }
  if (TotalSize <= 0) or (CopiedSize >= TotalSize) then
    barProgress.Position := 100
  else
    barProgress.Position := Round(CopiedSize / (TotalSize / 100));
{ Set copy flags }
  FCopyCopiedSize := CopiedSize;
  FCopyTotalSize  := TotalSize;
{ Check is the end. Starts a CopyDone after some delay }
  if CopiedSize >= TotalSize then tmrCopyDone.Enabled := True;
end;

//------------------------------------------------------------------------------
// Called if some error occurred during the copy process.

procedure TfrmUpgrade.OnCopyError(Sender: TObject; ErrorCode: LongWord;
  const ErrorMessage: string);
begin
{ Check is form closed or application terminated }
  if (ModalResult <> mrNone) or Application.Terminated then Exit;
{$IfDef DEBUG}
  ShowMessage(ErrorMessage);
{$EndIf DEBUG}
  ErrorOccurred;
end;


//==============================================================================
// Published by Delphi

//------------------------------------------------------------------------------
// Initializes values and control properties.

procedure TfrmUpgrade.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  FCopyTread := nil;
  FInfoFile := nil;
  btnUpgrade.Enabled := False;
  btnUpgrade.Visible := False;
  barProgress.Position := 0;
  lbStatus.Caption := '';
  FCopyDone := True;
  FErrorOccurred := False;
  FInfoFileDownloaded := False;
  FFilesDownloaded := False;
  FInstallPath := SAppPath;
//  FInstallPath := abfAddSlash(abfRegReadStringDef(HKEY_CURRENT_USER,
//    SBaseRegKey, SregInstallPath, SAppPath));
end;

//------------------------------------------------------------------------------
// Frees objects, deletes temporary files.

procedure TfrmUpgrade.FormDestroy(Sender: TObject);
begin
  if FileExists(FInfoFileLocalName) then DeleteFile(FInfoFileLocalName);
  if Assigned(FInfoFile) then FInfoFile.Free;
  FInfoFile := nil;
  if Assigned(FFileList) then FFileList.Free;
  FFileList := nil;
end;

//------------------------------------------------------------------------------
// Terminates copying if it is in progress.

procedure TfrmUpgrade.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not FErrorOccurred and Assigned(FCopyTread) then FCopyTread.Cancel;
end;

//------------------------------------------------------------------------------
// Starts a New Version checking after some delay

procedure TfrmUpgrade.FormShow(Sender: TObject);
begin
  tmrStart.Enabled := True;
end;

//------------------------------------------------------------------------------
// Event of the Start delay timer

procedure TfrmUpgrade.tmrStartTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  CheckNewVersion;
end;

//------------------------------------------------------------------------------
// Event of the CopyDone delay timer

procedure TfrmUpgrade.tmrCopyDoneTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  CopyDone;
end;

//------------------------------------------------------------------------------
// Periodicaly update progress indicator during InfoFile downloading

procedure TfrmUpgrade.tmrCheckingTimer(Sender: TObject);
begin
  if barProgress.Position > 95 then
  begin
    TTimer(Sender).Enabled := False;
    Exit;
  end;
  barProgress.Position := barProgress.Position + 1;
end;

//------------------------------------------------------------------------------
// Starts upgrading process.

procedure TfrmUpgrade.btnUpgradeClick(Sender: TObject);
begin
  UpgradeToNewVersion;
end;

//------------------------------------------------------------------------------

end{unit LensUpgradeForm}.
