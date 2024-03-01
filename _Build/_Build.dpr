program _Build;

uses
  Forms,
  _BuildMain in '_BuildMain.pas' {Form1},
  krpRegionsComponents in '..\krpRegionsComponents.pas',
  krpRegionsSkingines in '..\krpRegionsSkingines.pas',
  krpRegionsImages in '..\krpRegionsImages.pas',
  krpRegionsSkins in '..\krpRegionsSkins.pas',
  krpRegionsDialogs in '..\krpRegionsDialogs.pas',
  krpRegionsReg in '..\krpRegionsReg.pas',
  krpRegionsConsts in '..\krpRegionsConsts.pas',
  krpRegionsProcs in '..\krpRegionsProcs.pas',
  krpRegionsTypes in '..\krpRegionsTypes.pas',
  krpRegionsDesc in '..\krpRegionsDesc.pas',
  krpRegionsCollectionItems in '..\krpRegionsCollectionItems.pas',
  krpRegionsCollections in '..\krpRegionsCollections.pas',
  krpRegionsSkinPreviewForm in '..\krpRegionsSkinPreviewForm.pas' {frmSkinPreview},
  krpRegionsAboutForm in '..\krpRegionsAboutForm.pas' {frmkrpRegionLibraryAbout},
  krpRegionsDesigning in '..\krpRegionsDesigning.pas',
  krpRegionsPcx in '..\krpRegionsPcx.pas',
  krpRegionsGif in '..\krpRegionsGif.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
