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
    tBrightnessBar: TTrackBar;
    tGainBar: TTrackBar;
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
  RValues, GValues, BValues, RValues2, GValues2, BValues2 : array[0..1000, 0..1000] of byte;

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
          RValues2[x, y] := getRValue(image.Canvas.Pixels[x, y]);
          GValues2[x, y] := getGValue(image.Canvas.Pixels[x, y]);
          BValues2[x, y] := getBValue(image.Canvas.Pixels[x, y]);
        end;
      end;
  end;
end;

procedure TForm1.ProcessBtnClick(Sender: TObject);
var
  x, y : integer;
  brightnessR, brightnessG, brightnessB : integer;
begin
  for y:=0 to image.Height-1 do
  begin
    for x:=0 to image.Width-1 do
    begin
      adjR := tGainBar.Position * RValues[x, y] + tBrightnessBar.Position;
      adjR := clipValue(brightnessR);

      adjG := tGainBar.Position * GValues[x, y] + tBrightnessBar.Position;
      adjG := clipValue(brightnessG);

      adjB := tGainBar.Position * BValues[x, y] + tBrightnessBar.Position;
      adjB := clipValue(brightnessB);

      EditImage.Canvas.Pixels[x, y] := RGB(adjR, adjG, adjB);
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

