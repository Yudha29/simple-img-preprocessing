unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ProcessBtn: TButton;
    Image: TImage;
    EditImage: TImage;
    OpenBtn: TButton;
    OpenPictureDialog: TOpenPictureDialog;
    procedure OpenBtnClick(Sender: TObject);
    procedure ProcessBtnClick(Sender: TObject);
    function clipValue(value: integer): integer;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses Windows;

var
  RValues, GValues, BValues, BinaryValues : array[0..1000, 0..1000] of byte;

procedure TForm1.OpenBtnClick(Sender: TObject);
var
  x, y : integer;
begin
  if (OpenPictureDialog.Execute) then
  begin
      image.Picture.LoadFromFile(OpenPictureDialog.FileName);
      EditImage.Picture.LoadFromFile(OpenPictureDialog.FileName);

      for y:=0 to image.Height-1 do
      begin
        for x:=0 to image.Width-1 do
        begin
          RValues[x, y] := getRValue(image.Canvas.Pixels[x, y]);
          GValues[x, y] := getGValue(image.Canvas.Pixels[x, y]);
          BValues[x, y] := getBValue(image.Canvas.Pixels[x, y]);
        end;
      end;
  end;
end;

procedure TForm1.ProcessBtnClick(Sender: TObject);
var
  x, y : integer;
  adjR, adjG, adjB, gray : integer;
begin
  for y:=0 to image.Height-1 do
  begin
    for x:=0 to image.Width-1 do
    begin
      adjR := 2 * RValues[x, y];
      adjG := 2 * GValues[x, y];
      adjB := 2 * BValues[x, y];

      RValues[x, y] := clipValue(adjR);
      GValues[x, y] := clipValue(adjG);
      BValues[x, y] := clipValue(adjB);
    end;
  end;

  for y:=0 to image.Height-1 do
  begin
    for x:=0 to image.Width-1 do
    begin
      gray := (RValues[x, y] + GValues[x, y] + BValues[x, y]) div 3;
      if (gray <= 64) then
        BinaryValues[x, y] := 0
      else
        BinaryValues[x, y] := 255;
    end;
  end;

  for y:=0 to image.Height-1 do
  begin
    for x:=0 to image.Width-1 do
    begin
      EditImage.Canvas.Pixels[x, y] := RGB(BinaryValues[x, y], BinaryValues[x, y], BinaryValues[x, y]);
    end;
  end;
end;

function TForm1.clipValue(value: integer): integer;
begin
    clipValue := value;
    if value < 0 then
         clipValue := 0;
    if value > 255 then
         clipValue := 255;
end;

end.

