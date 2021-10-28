unit frmSignUp_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit,
  FMX.DateTimeCtrls, Data.DB, Data.Win.ADODB, Blusins_u, FMX.Ani, MainPage_u;

type
  TfrmSignUP = class(TForm)
    FloatAnimation: TFloatAnimation;
    StyleBook1: TStyleBook;
    procedure btnSignUpClick(Sender : TObject);
    procedure pnlLoginClick(Sender : TObject);
    procedure imgExitClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure edtNameClick(Sender : TObject);
    procedure edtEmailClick(Sender : TObject);
    procedure pnlLoginEnter(Sender : TObject);
    procedure pnlLoginLeave(Sender : TObject);
    procedure edtPasswordCLick(Sender : TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    bShown : Boolean;
  public
    { Public declarations }

  end;

var
  frmSignUP: TfrmSignUP;
  objBlusins : TBluSins;

  edtPassword, edtName, edtEmail : TEdit;             //Edits

  imgLogo, imgEmail, imgPassword, imgName, imgExit : TImage;   //Images

  lblSignUp, lblLogin : TLabel;                       //Labels

  btnSignUp : TCornerButton;                          //Buttons

  dtpDate : TDateEdit;                                //Date

  recBorder : TRectangle;                             //Border

  pnlLogin : TPanel;                                  //Panels
implementation

{$R *.fmx}

uses frmLogIn_u, DataBase_u;



procedure TfrmSignUP.pnlLoginClick(Sender: TObject);
begin
  frmSignUp.Hide;
  frmLogin.Show;
end;

procedure TfrmSignUP.pnlLoginEnter(Sender: TObject);
begin
  lblLogin.StyledSettings := lblLogin.StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor];
  lblLogin.FontColor := TAlphaColors.Grey;
end;

procedure TfrmSignUP.pnlLoginLeave(Sender: TObject);
begin
  lblLogin.StyledSettings := lblLogin.StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor];
  lblLogin.FontColor := TAlphaColors.White;
end;

procedure TfrmSignUP.btnSignUpClick(Sender: TObject);
Var sEmail, sName, sPassword : String;
    iPos : Integer;
    sDate, sTime : String;
begin
  sName := edtName.Text;
  sEmail := edtEmail.Text;
  sPassword := edtPassword.Text;
  dtpDate.Date:= Date;
  dtpDate.Time := Time;
  sDate := DateToStr(dtpDate.Date);
  sTime := TimeToStr(dtpDate.Time);
  objBlusins := TBlusins.Create(sName, sEmail, sPassword);

  if (sName = '') or (sEmail = '') or (sPassword = '')then
    begin
      Showmessage('Missing Credentials');
      Exit;
    end;

  iPos := POS(' ', sName);
  if iPos = 0 then
    begin
      Showmessage('Name and Surname is required');
      Exit;
    end;

  iPos := POS('@', sEmail);
  if iPos = 0 then
    begin
      Showmessage('Please enter a valid email');
      Exit;
    end;

  with DataBase_U.frmDatabase do
    begin
      adoLogin.Open;
      adoLogin.Insert;
      adoLogin['Name'] := objBlusins.getName;
      adoLogin['Surname'] := objBlusins.getSurname;
      adoLogin['Email'] := sEmail;
      adoLogin['Password'] := sPassword;
      adoLogin['Date'] := sDate;
      adoLogin['Time'] := sTime;
      adoLogin.Post;
    end;

  Showmessage('Welcome ' + sName);

  frmSignUp.Hide;
  frmLogin.Show;
end;


procedure TfrmSignUP.edtEmailClick(Sender: TObject);
begin
  edtEmail.SelectAll;
end;

procedure TfrmSignUP.edtNameClick(Sender: TObject);
begin
  edtName.SelectAll;
end;

procedure TfrmSignUP.edtPasswordCLick(Sender: TObject);
begin
  edtPassword.SelectAll;
end;

procedure TfrmSignUP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmSignUP.FormCreate(Sender: TObject);
begin
  bShown := False;
  imgLogo := TImage.Create(Self);                 //Creating The Pictures
  imgEmail := TImage.Create(Self);
  imgPassword := TImage.Create(Self);
  imgName := TImage.Create(Self);
  imgExit := TImage.Create(Self);

  edtEmail := TEdit.Create(Self);                 //Creating The Edits
  edtPassword := TEdit.Create(Self);
  edtName := TEdit.Create(Self);

  lblSignUp := TLabel.Create(Self);               //Creating The Lables
  lblLogin := TLabel.Create(Self);

  btnSignUp := TCornerButton.Create(Self);        //Creating The Button

  dtpDate := TDateEdit.Create(Self);              //Creating The Date

  recBorder := TRectangle.Create(Self);           //Creating Border

  pnlLogin := TPanel.Create(Self);                //Creating Panel

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Edit Details

  with edtName do
    begin
    Text := 'Name and Surname';
    Height := 22;
    Width := 150;
    Position.X := 384;
    Position.Y := 138;
    Parent := frmSignUp;
    StyleLookup := 'transparentedit';
    OnClick := edtNameClick;
    end;

  with edtEmail do
    begin
    Text := 'Email';
    Height := 22;
    Width := 150;
    Position.X := 384;
    Position.Y := 174;
    Parent := frmSignUp;
    StyleLookup := 'transparentedit';
    OnClick := edtEmailClick;
    end;

  with edtPassword do
    begin
    Text := 'Password';
    Height := 22;
    Width := 150;
    Position.X := 384;
    Position.Y := 210;
    Parent := frmSignUp;
    StyleLookup := 'transparentedit';
    OnClick := edtPasswordClick;
    end;


  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Image Details

  with imgLogo do
    begin
    Bitmap.LoadFromFile('Blusins Logo.png');
    Height := 250;
    Width := 265;
    Position.X := 32;
    Position.Y := 72;
    Parent := frmSignUp;
    Opacity := 0;
    end;

  with imgName do
    begin
    Bitmap.LoadFromFile('Name.png');
    Height := 40;
    Width := 40;
    Position.X := 351;
    Position.Y := 129;
    Parent := frmSignUp;
    end;


  with imgEmail do
    begin
    imgEmail.bitmap.LoadFromFile('Email.png');
    Height := 40;
    Width := 40;
    Position.X := 351;
    Position.Y := 165;
    Parent := frmSignUp;
    end;

  with imgPassword do
    begin
    imgPassword.bitmap.LoadFromFile('Password.jpg');
    Height := 40;
    Width := 40;
    Position.X := 351;
    Position.Y := 201;
    Parent := frmSignUp;
    end;

  with imgExit do
    begin
    Bitmap.LoadFromFile('Exit.jpg');
    Height := 40;
    Width := 40;
    Position.X := 567;
    Position.Y := 10;
    Parent := frmSignUp;
    Opacity := 1;
    OnClick := imgExitClick;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Label Details

  with lblSignUp do
    begin
    Text := 'Member Signup';
    Height := 50;
    Width := 200;
    Position.X := 355;
    Position.Y := 70;
    Parent := frmSignUp;
    TextSettings.Font.Size := 25;
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor];
    FontColor := TAlphaColors.White;
    end;

  with lblLogin do
    begin
    Text := 'or login here';
    Height := 49;
    Width := 145;
    Enabled := True;
    Position.X := 410;
    Position.Y := 298;
    Parent := frmSignUp;
    TextSettings.Font.Size := 10;
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Button Details

  with btnSignUp do
    begin
    Text := 'Sign Up Now!';
    Height := 49;
    Width := 145;
    Position.X := 368;
    Position.Y := 265;
    Parent := frmSignUp;
    XRadius := 20;
    YRadius := 20;
    TextSettings.Font.Size := 15;
    StyledSettings := StyledSettings - [TStyledSetting.Size] ;
    OnClick := btnSignUpClick;
    Cursor := crHandPoint;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Animation Details

    FloatAnimation.Parent := imgLogo;
   with FloatAnimation do
     begin
     AnimationType := TAnimationType.InOut;
     Loop := True;
     AutoReverse := True;
     Delay := 0;
     Duration := 3;
     Enabled := True;
     Interpolation := TInterpolationType.Quartic;
     PropertyName := 'Opacity';
     Trigger := 'frmSignUp.Visible=True';
     StartValue := 0;
     StopValue := 1;
     end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Border Details

  with recBorder do
    begin
    Height := frmSignup.Height;
    Width := frmSignup.Width;
    Position.X := 0;
    Position.Y := 0;
    Stroke.Kind := TBrushKind.Solid;
    Enabled := False;
    Stroke.Thickness := 12;
    Stroke.Color := TAlphaColor($FFE0E0E0);
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := TAlphaColors.Null;
    Parent := frmSignUp;
    end;


  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Panel Details

  with pnlLogin do
    begin
    Height := 15;
    Width := 65;
    Position.X := 410;
    Position.Y := 317;
    Opacity := 0;
    Parent := frmSignUp;
    OnClick := pnlLoginClick;
    OnMouseEnter := pnlLoginEnter;
    OnMouseLeave := pnlLoginLeave;
    Cursor := crHandPoint;
    end;

end;


procedure TfrmSignUP.FormShow(Sender: TObject);
begin
  if bShown = False then
    begin
      FloatAnimation.Start;
      bShown := True
    end;
end;


procedure TfrmSignUP.imgExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
