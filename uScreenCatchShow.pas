unit uScreenCatchShow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TCatchScreenShowFrm = class(TForm)
    ChildImage: TImage;
    ChildTimer: TTimer;
    procedure ChildTimerTimer(Sender: TObject);
    procedure ChildImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ChildImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CatchScreenShowFrm: TCatchScreenShowFrm;
  foldx,x1,y1,x2,y2,oldx,oldy,foldy : Integer;
  Flag,Trace : Boolean;
implementation

uses uScreenCatch;

{$R *.DFM}

procedure TCatchScreenShowFrm.ChildTimerTimer(Sender: TObject);
var
  FullScreen: TBitmap;
  FullScreenCanvas: TCanvas;
  DC: HDC;
begin
  ChildTimer.Enabled := False;
  Fullscreen := TBitmap.Create;
  Fullscreen.Width := Screen.width;
  Fullscreen.Height := Screen.Height;
  DC := GetDC(0);
  FullScreenCanvas := TCanvas.Create;
  FullScreenCanvas.Handle := DC;
  FullScreen.Canvas.CopyRect(Rect(0, 0, Screen.Width, Screen.Height), FullScreenCanvas,
  Rect(0, 0, Screen.Width, Screen.Height));
  FullScreenCanvas.Free;
  ReleaseDC(0,DC);
  ChildImage.Picture.Bitmap := FullScreen;
  ChildImage.Width := FullScreen.Width;
  ChildImage.Height := FullScreen.Height;
  FullScreen.Free;
  CatchScreenShowFrm.WindowState := wsMaximized;
  CatchScreenShowFrm.show;
  MessageBeep(1);
  foldx := -1;
  foldy := -1;
  ChildImage.Canvas.Pen.mode := Pmnot; //笔的模式为取反
  ChildImage.Canvas.Pen.Color := clBlack;//笔为黑色
  ChildImage.Canvas.Brush.Style := bsClear;//空白刷子
  Flag := True;
end;


procedure TCatchScreenShowFrm.ChildImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Trace then//是否在追踪鼠标
  begin//是，擦除旧的矩形并画上新的矩形
    with ChildImage.Canvas do
    begin
        rectangle(x1, y1, oldx, oldy);
        Rectangle(x1, y1, x, y);
        oldx := x;
        oldy := y;
    end;
  end
  else if Flag then//在鼠标所在的位置上画十字
  begin
    with ChildImage.Canvas do
    begin
      MoveTo(foldx, 0);//擦除旧的十字
      LineTo(foldx, Screen.Height);
      MoveTo(0, foldy);
      LineTo(Screen.Width,foldy);
      MoveTo(x, 0);//画上新的十字
      LineTo(x, Screen.Height);
      MoveTo(0,y);
      LineTo(Screen.Width, y);
      foldx := x;
      foldy := y;
    end;
  end;
end;

procedure TCatchScreenShowFrm.ChildImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Width, Height : Integer;
  NewBitmap : TBitmap;
begin
  if (Trace = False) then//TRACE表示是否在追踪鼠标
  begin//首次点击鼠标左键，开始追踪鼠标。
    Flag := False;
    with ChildImage.canvas do
    begin
        MoveTo(foldx, 0);
        LineTo(foldx, Screen.height);
        MoveTo(0, foldy);
        LineTo(Screen.width, foldy);
    end;
    x1 := x;
    y1 := y;
    oldx := x;
    oldy := y;
    Trace := True;
    ChildImage.Canvas.Pen.mode:=pmnot;//笔的模式为取反
    //这样再在原处画一遍矩形，相当于擦除矩形。
    ChildImage.Canvas.Pen.Color := clBlack;//笔为黑色
    ChildImage.Canvas.Brush.Style := bsClear;//空白刷子
    end
  else
  begin//第二次点击，表示已经得到矩形了，把它拷贝到FORM1中的IMAGE部件上。
    x2 := x;
    y2 := y;
    Trace := False;
    ChildImage.Canvas.Rectangle(x1, y1, oldx, oldy);
    Width := abs(x2-x1);
    Height := abs(y2-y1);
    ScreenCatchFrm.ShowImage.Width := Width;
    ScreenCatchFrm.ShowImage.Height := Height;

    NewBitmap := TBitmap.Create;
    NewBitmap.Width := Width;
    NewBitmap.Height := Height;
    NewBitmap.Canvas.CopyRect
    (Rect(0, 0, width, Height),CatchScreenShowFrm.ChildImage.Canvas,
    Rect(x1, y1, x2, y2));//拷贝
    ScreenCatchFrm.ShowImage.Picture.Bitmap := NewBitmap;//放到CatchScreenForm的ShowImage上
    NewBitmap.Free;
    CatchScreenShowFrm.Hide;
    ScreenCatchFrm.Show;
end;
end;

procedure TCatchScreenShowFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
