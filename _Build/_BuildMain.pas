unit _BuildMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  krpRegionsComponents, StdCtrls, Buttons, ExtCtrls, krpRegionsProcs,
  krpRegionsImages, krpRegionsSkingines,
  krpRegionsDesigning, jpeg, krpRegionsDialogs, extdlgs,
  krpRegionsConsts;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    SpeedButton3: TSpeedButton;
    Button1: TButton;
    SpeedButton4: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    krpControlRegion1: TkrpControlRegion;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  krpControlRegion1.WinControl := Edit1;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  krpControlRegion1.WinControl := Panel1;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
{  krpDrawRegionBorder(Canvas.Handle, krpControlRegion1.Region.Region,
    clLime, clRed, clYellow, True);{}

{  krpDrawRegionEdgeStd(Canvas.Handle,
    krpControlRegion1.Region.Region, clBtnFace, True, False);{}

  krpDrawRegionEdge(Canvas.Handle,
    krpControlRegion1.Region.Region, clBtnFace, True, False);{}
//  FillRgn(Image2.Canvas.Handle, krpControlRegion1.Region.Region, Canvas.Brush.Handle)
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  krpControlRegion1.BorderLowered := True;
end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  krpControlRegion1.BorderLowered := False;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
  S : String;
begin
//  krpRegionsShowAbout;
//  if krpOpenSkinDialog1.Execute
//   then MessageBeep(0);
  S:=ExtractFilePath(Application.ExeName) + sknFileName;
  krpRegionsOpenSkinDialog(S);

end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
   with TkrpOpenSkinDialog.Create(Self) do
    try
      Execute;
    finally
      Free;
    end
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
   with TOpenPictureDialog.Create(Self) do
    try
      Execute;
    finally
      Free;
    end
end;

end.
