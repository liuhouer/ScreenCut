unit uAutoScreen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin;

type
  TAutoScreenFrm = class(TForm)
    SetSpinEdit: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    AutoScreenTimer: TTimer;
    AppBitBtn: TBitBtn;
    procedure AppBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AutoScreenTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AutoScreenFrm: TAutoScreenFrm;

implementation

uses uScreenCatch;

{$R *.dfm}

procedure TAutoScreenFrm.AppBitBtnClick(Sender: TObject);
begin
  AutoScreenTimer.Enabled := True;
  AutoScreenTimer.Interval := StrToInt(SetSpinEdit.Text)*1000;
  AutoScreenFrm.Hide;
  if AutoScreenFrm.AutoScreenTimer.Enabled then
  begin
    SetWindowPos(AutoScreenFrm.Handle, HWND_TOPMOST, AutoScreenFrm.Left, AutoScreenFrm.Top, AutoScreenFrm.Width, AutoScreenFrm.Height,0);
    ScreenCatchFrm.AutoScreenSpeedBtn.Caption := '停止抓图';
  end;
end;

procedure TAutoScreenFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  AutoScreenTimer.Enabled := False;
  Action:= caFree;
end;

procedure TAutoScreenFrm.AutoScreenTimerTimer(Sender: TObject);
var
  BuildBMP: TBitmap;
  c: TCanvas;
  r,t: TRect;
  h: THandle;
  ExeFilePath: string;
begin
  ExeFilePath := ExtractFilePath(Application.ExeName);
  c := TCanvas.Create;
  c.Handle := GetWindowDC(GetDesktopWindow);
  //获得当前活动窗口的句柄
  h := GetForeGroundWindow;
  BuildBMP := TBitmap.Create;
  if h <> 0 then
  //结构t保存该窗口的左上角和右下角的坐标值(相对于屏幕左上角)
    GetWindowRect(h, t);
  try
    r := Rect(0, 0, t.Right-t.Left, t.Bottom-t.Top);
    BuildBMP.Width := t.Right-t.Left;
    BuildBMP.Height := t.Bottom-t.Top;
    BuildBMP.Canvas.CopyRect(r, c, t);
    //抓屏结果保存在与EXE相同目录下
    BuildBMP.SaveToFile(ExeFilePath + 'AutoScreen.bmp');
  finally
    BuildBMP.Free;
  end;
  //将文件转换成JPG格式,以减少磁盘空间的占用
  ScreenCatchFrm.BMPToJPG(ExeFilePath + 'AutoScreen.bmp');
end;


end.
