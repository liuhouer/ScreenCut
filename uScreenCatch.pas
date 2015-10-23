//***************************************************************
//*作者:刀剑如梦
//*Email:yckxzjj@163.com
//*愿与您相互交流、共同进步！！！
//*Delphi编程驿站  http://yckxzjj.vip.sina.com 2003.07.06
//***************************************************************
unit uScreenCatch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ExtDlgs, Buttons, ComCtrls, Menus, JPEG ,Registry,
  WinSkinData, WinSkinStore, RzBHints, RzTray;

type
  TScreenCatchFrm = class(TForm)
    MainTimer: TTimer;
    ShowImage: TImage;
    SaveDialog: TSavePictureDialog;
    TopPanel: TPanel;
    StatusBar: TStatusBar;
    AllSreenPanel: TPanel;
    AllScreenSpeedBtn: TSpeedButton;
    QuYueSreenPanel: TPanel;
    QuYueSreenSpeedBtn: TSpeedButton;
    SavePanel: TPanel;
    SaveSpeedBtn: TSpeedButton;
    ExitPanel: TPanel;
    ExitSpeedBtn: TSpeedButton;
    OpenDialog: TOpenDialog;
    SystemTimer: TTimer;
    ScrollBox: TScrollBox;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N5: TMenuItem;
    N2: TMenuItem;
    N6: TMenuItem;
    N3: TMenuItem;
    N8: TMenuItem;
    N4: TMenuItem;
    N7: TMenuItem;
    pm_AutoScreen: TMenuItem;
    AutoScreenPanel: TPanel;
    AutoScreenSpeedBtn: TSpeedButton;
    SkinData: TSkinData;
    cstyle: TComboBox;
    RzTray1: TRzTrayIcon;
    RzBall1: TRzBalloonHints;
    Button1: TButton;
    procedure MainTimerTimer(Sender: TObject);
    procedure AllScreenSpeedBtnClick(Sender: TObject);
    procedure QuYueSreenSpeedBtnClick(Sender: TObject);
    procedure SaveSpeedBtnClick(Sender: TObject);
    procedure ExitSpeedBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SystemTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pm_AutoScreenClick(Sender: TObject);
    procedure AutoScreenSpeedBtnClick(Sender: TObject);
    procedure cstyleChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
    procedure BMPToJPG(BmpFileName:string);
    Procedure MsgBox;
  end;

var
  ScreenCatchFrm: TScreenCatchFrm;

implementation

uses uScreenCatchShow, uAutoScreen, Unit1;




{$R *.DFM}

//自定义函数,随机取得4位a到z之间字符串,作为JPG格式图像的文件名
function RandomFileName():String;
var
  PicName : string;
  I : Integer;
begin
  Randomize;
  for I := 1 to 4 do
    PicName := PicName + Chr(97 + Random(26));
  RandomFileName := PicName;
end;

procedure TScreenCatchFrm.BMPToJPG(BmpFileName:string);
var
  Jpeg : TJPEGImage;
  Bmp : TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromFile(BmpFileName);
    Jpeg := TJPEGImage.Create;
    try
      Jpeg.Assign(Bmp);
      Jpeg.Compress;
      //以随机文件名保存在与EXE文件同目录下
      Jpeg.SaveToFile(ExtractFilePath(Application.ExeName) + RandomFileName + '.jpg');
    finally
      Jpeg.Free;
    end;
  finally
     Bmp.Free;
  end;
end;

procedure TScreenCatchFrm.MainTimerTimer(Sender: TObject); //抓取屏幕，并保存到Image控件中
var
  Fullscreen : TBitmap;
  FullscreenCanvas : TCanvas;
  DC : HDC;
begin
  MainTimer.Enabled := False;//取消时钟
  Fullscreen:=TBitmap.Create;//创建一个BITMAP来存放图象
  Fullscreen.Width := Screen.Width;
  Fullscreen.Height := Screen.Height;
  DC:=GetDC(0);//取得屏幕的DC，参数0指的是屏幕
  FullscreenCanvas := TCanvas.Create;//创建一个CANVAS对象
  FullscreenCanvas.Handle := DC;

  Fullscreen.Canvas.CopyRect
  (Rect(0,0,Screen.Width,Screen.Height),FullScreenCanvas,
  Rect(0,0,Screen.Width,Screen.Height));
  //把整个屏幕复制到BITMAP中
  FullScreenCanvas.Free;//释放CANVAS对象
  ReleaseDC(0,DC);//释放DC
   //*******************************
  ShowImage.Picture.Bitmap := FullScreen;//拷贝下的图象赋给IMAGE对象
  ShowImage.Width := FullScreen.Width;
  ShowImage.Height := FullScreen.Height;
  FullScreen.Free;//释放bitmap
  ScreenCatchFrm.WindowState := wsNormal;//复原窗口状态
  ScreenCatchFrm.Show;//显示窗口
  MessageBeep(1);//BEEP叫一声，报告图象已经截取好了。
end;

procedure TScreenCatchFrm.AllScreenSpeedBtnClick(Sender: TObject);//全屏抓图
begin
  ScreenCatchFrm.WindowState := wsMinimized;//最小化程序窗口
  ScreenCatchFrm.Hide;//把程序藏起来
  MainTimer.Enabled := True;//打开记时器
end;

procedure TScreenCatchFrm.QuYueSreenSpeedBtnClick(Sender: TObject);//区域抓图
begin
  try
    begin
      ScreenCatchFrm.Hide;
      CatchScreenShowFrm := TCatchScreenShowFrm.Create(Application);
      CatchScreenShowFrm.Hide;
      CatchScreenShowFrm.ChildTimer.Enabled := True;
    end
  except
    MsgBox;
    Application.Terminate;
  end;
end;

procedure TScreenCatchFrm.SaveSpeedBtnClick(Sender: TObject);//保存图片
begin
  SaveDialog.Title := 'bruce温馨提示：图片保存后将被转换成随机文件';
  if SaveDialog.Execute then
  begin
    ScreenCatchFrm.ShowImage.Picture.SaveToFile(SaveDialog.FileName);
    BMPToJPG(SaveDialog.FileName);
    DeleteFile(SaveDialog.FileName);
  end;
end;

procedure TScreenCatchFrm.ExitSpeedBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TScreenCatchFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TScreenCatchFrm.MsgBox;
begin
  with Application do
    MessageBox('程序内部错误',PChar(Title),MB_OK+MB_ICONERROR);
end;

procedure TScreenCatchFrm.SystemTimerTimer(Sender: TObject);
var
  DateTime : TDateTime;
begin
  DateTime := Now;
  StatusBar.Panels[1].Text := DateTimeToStr(DateTime);
end;

procedure TScreenCatchFrm.FormCreate(Sender: TObject);
var
  RegF: TRegistry;
begin
cstyle.Clear;

   cstyle.Items.Add('绿色节拍')  ;
 cstyle.Items.Add('智能时代')  ;
 cstyle.Items.Add('蓝色海洋') ;
 cstyle.Items.Add('橙子情节');
 cstyle.Items.Add('青青草地' );
 cstyle.ItemIndex:=0;
    //读取注册表,根据是否设置了开机自动运行,而设置pm_AutoScreen的状态
  RegF := TRegistry.Create;
  RegF.RootKey := HKEY_LOCAL_MACHINE;
  try
    RegF.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', True);
    if RegF.ValueExists('ScreenCapture') then
      pm_AutoScreen.Checked := True
    else
      pm_AutoScreen.Checked := False;
  except
    MsgBox;
  end;
   RegF.CloseKey;
   RegF.Free;
end;

procedure TScreenCatchFrm.pm_AutoScreenClick(Sender: TObject);
var RegF: TRegistry;
begin
  RegF := TRegistry.Create;
  RegF.RootKey := HKEY_LOCAL_MACHINE;
  try
    RegF.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',True);
    //设置开机是否自动运行
    if pm_AutoScreen.Checked then
    begin
      RegF.DeleteValue('ScreenCapture');
      RegF.WriteString('ScreenCapture', Application.ExeName);
    end
    else
      RegF.DeleteValue('ScreenCapture');
  except
    MsgBox;
  end;
   RegF.CloseKey;
   RegF.Free;
end;

procedure TScreenCatchFrm.AutoScreenSpeedBtnClick(Sender: TObject);
begin
  if AutoScreenSpeedBtn.Caption = '停止抓图' then
  begin
    AutoScreenFrm.AutoScreenTimer.Enabled := False;
    AutoScreenSpeedBtn.Caption := '自动抓图';
  end
  else
  begin
    AutoScreenFrm := TAutoScreenFrm.Create(Application);
    AutoScreenFrm.Show;
  end;
end;

procedure TScreenCatchFrm.cstyleChange(Sender: TObject);
begin
if cstyle.Text= '青青草地' then
begin
skindata.LoadFromFile(ExtractFilePath(ParamStr(0))+'Skins\青青草地.skn');
rztray1.ShowBalloonHint('Skin','青青草地',bhiinfo,10);
end
else if cstyle.Text= '智能时代' then
begin
skindata.LoadFromFile(ExtractFilePath(ParamStr(0))+'Skins\智能时代.skn');
rztray1.ShowBalloonHint('Skin','智能时代',bhiinfo,10);

end
else if cstyle.Text= '蓝色海洋' then
begin
skindata.LoadFromFile(ExtractFilePath(ParamStr(0))+'Skins\蓝色海洋.skn');
rztray1.ShowBalloonHint('Skin','蓝色海洋',bhiinfo,10);
end
else if cstyle.Text= '绿色节拍' then
begin
skindata.LoadFromFile(ExtractFilePath(ParamStr(0))+'Skins\绿色节拍.skn');
rztray1.ShowBalloonHint('Skin','绿色节拍',bhiinfo,10);
end
else if cstyle.Text= '橙子情节' then
begin
skindata.LoadFromFile(ExtractFilePath(ParamStr(0))+'Skins\橙子情结.skn');
rztray1.ShowBalloonHint('Skin','橙子情结',bhiinfo,10);
end;
end;

procedure TScreenCatchFrm.Button1Click(Sender: TObject);
begin
form1.show;
end;

end.
