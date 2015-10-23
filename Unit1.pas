unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,shellapi;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Label2Click(Sender: TObject);
begin
 ShellExecute(handle, 'open','http://bbs.kafan.cn/forum.php?mod=viewthread&tid=1294885&highlight=%D0%A1%B2%BC%BE%B2%CC%FD','qianqian',nil, SW_SHOWNORMAL);

end;

end.
