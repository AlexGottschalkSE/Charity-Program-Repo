unit frmDS;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, Data.DB,
  Data.Win.ADODB, FMX.Ani, FMX.EditBox, FMX.NumberBox,FMX.DateTimeCtrls;

type
  TfrmDonationSuccessful = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure DoneClick(Sender : TObject);
    procedure LogOutClick(Sender : TObject);
    procedure ContinueClick(Sender : TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDonationSuccessful: TfrmDonationSuccessful;

  imgSucc, imgDone, imgLogOut,imgContinue : TImage;

  lblCode, lblMyAcc : TLabel;

implementation

{$R *.fmx}

uses
  MainPage_u, frmLogIn_u;

procedure TfrmDonationSuccessful.ContinueClick(Sender: TObject);
begin
  frmMain.Show;
  frmDonationSuccessful.Hide;
end;

procedure TfrmDonationSuccessful.DoneClick(Sender: TObject);
begin
  frmDonationSuccessful.Close;
end;

procedure TfrmDonationSuccessful.FormCreate(Sender: TObject);
begin
  imgSucc := TImage.Create(Self);
  imgDone := TImage.Create(Self);
  imgLogOut := TImage.Create(Self);
  imgContinue := TImage.Create(Self);

  lblMyAcc := TLabel.Create(Self);
  lblCode := TLabel.Create(Self);

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Image Details

  with imgSucc do
    begin
    Bitmap.LoadFromFile('PaySucc.png');
    Height := 185;
    Width := 265;
    Position.X := 26;
    Position.Y := 24;
    Visible := False;
    Parent := frmDonationSuccessful;
    end;

  with imgDone do
    begin
    Bitmap.LoadFromFile('Done.png');
    Height := 50;
    Width := 193;
    Position.X := 64;
    Position.Y := 280;
    Parent := frmDonationSuccessful;
    Visible := False;
    OnClick := DoneClick;
    end;

  with imgContinue do
    begin
    Bitmap.LoadFromFile('Continue.png');
    Height := 50;
    Width := 193;
    Position.X := 64;
    Position.Y := 280;
    Parent := frmDonationSuccessful;
    Visible := False;
    OnClick := ContinueClick;
    end;

  with imgLogOut do
    begin
    Bitmap.LoadFromFile('Done.png');
    Height := 50;
    Width := 193;
    Position.X := 64;
    Position.Y := 280;
    Parent := frmDonationSuccessful;
    Visible := False;
    OnClick := LogOutClick;
    end;


  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Label Details

  with lblCode do
    begin
    Height := 17;
    Width := 160;
    Position.X := 86;
    Position.Y := 200;
    Parent := frmDonationSuccessful;
    TextSettings.Font.Size := 12;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    BringToFront;
    Visible := False;
    end;

  with lblMyAcc do
    begin
    Height := 41;
    Width := 193;
    Position.X := 98;
    Position.Y := 176;
    Text := 'My Account';
    Parent := frmDonationSuccessful;
    TextSettings.Font.Size := 24;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    BringToFront;
    Visible := False;
    end;
end;

procedure TfrmDonationSuccessful.LogOutClick(Sender: TObject);
begin
  frmMain.Close;
  frmLogin.show;
end;

end.
