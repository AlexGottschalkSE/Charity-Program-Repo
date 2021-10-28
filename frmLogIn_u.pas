unit frmLogIn_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Ani, admin_u;

CONST
  MAXNUM = 1000;

type
  TfrmLogin = class(TForm)
    FloatAnimation2: TFloatAnimation;
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgExit2Click(Sender : TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure pnlLoginEnter(Sender : TObject);
    procedure pnlLoginLeave(Sender : TObject);
    procedure pnlSignUpClick(Sender : TObject);
  private
    { Private declarations }
    bShown : Boolean;
  public
    { Public declarations }
    arrEmail : Array[1..Maxnum] of String;
    arrPassword : Array[1..Maxnum] of String;
    arrName : Array[1..Maxnum] of String;
    sAccountName : String;
    sAdminName, sAdminPass : String;
  end;

var
  frmLogin: TfrmLogin;

  edtPassword, edtName, edtEmail : TEdit;              //Edits

  imgLogo, imgEmail, imgPassword, imgExit2 : TImage;   //Images

  lblSignUp, lblLogin : TLabel;                        //Labels

  btnLogin : TCornerButton;                            //Buttons

  recBorder : TRectangle;                              //Border

  pnlSignUp : TPanel;                                  //Panels

implementation

{$R *.fmx}

uses MainPage_U, DataBase_u, frmSignUp_u, frmDS;


procedure TfrmLogin.pnlLoginEnter(Sender: TObject);
begin
  lblSignup.StyledSettings := lblLogin.StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor];
  lblSignup.FontColor := TAlphaColors.Grey;
end;

procedure TfrmLogin.pnlLoginLeave(Sender: TObject);
begin
  lblSignup.StyledSettings := lblLogin.StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor];
  lblSignup.FontColor := TAlphaColors.White;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
Var iCount : Integer;
    sEmail, sPassword, sLine : String;           //Login Values
    iLoop, iPos : Integer;
    bFound : Boolean;
    AdminText : Textfile;
begin
  iCount := 0;
  iLoop := 1;
  bFound := False;
  sEmail := edtEmail.Text;
  sPassword := edtPassword.Text;
  Assignfile(AdminText, 'AdminLogins.txt');

  if (sEmail = '') or (sPassword = '') then
    begin
      Showmessage('Missing Credentials');
      Exit;
    end;

  with DataBase_U.frmDatabase do
   begin
     adoLogin.Open;
     adoLogin.First;
       while not adoLogin.Eof do
         begin
           inc(iCount);
           arrName[iCount] := adoLogin.FieldByName('Name').AsString;
           arrEmail[iCount] := adoLogin.FieldByName('Email').AsString;
           arrPassword[iCount] := adoLogin.FieldByName('Password').AsString;
           adoLogin.Next;
         end;
   adoLogin.Close;
       end;

  while (bFound = False) and (iLoop <= iCount) do
    begin
      if (sEmail = arrEmail[iLoop]) and (sPassword = arrPassword[iLoop]) then
        bFound := True
      else
        inc(iLoop);
    end;

  Reset(AdminText);
  while NOT EOF(AdminText) and (bFound = False) do
    begin
      Readln(AdminText, sLine);
      iPos := POS('#', sLine);
      sAdminName := Copy(sLine, 1, iPos - 1);
      Delete(sLine,1, iPos);
      sAdminPass := sLine;

      if (sEmail = sAdminName) and (sPassword = sAdminPass) then
        begin
        bFound := True;
        Showmessage('Welcome Admin');
        frmAdmin.show;
        Exit;
        end;
    end;

  if bFound = True then
    begin
      sAccountName := arrName[iLoop];
      imgContinue.Visible := True;
      imgLogout.Visible := False;
      frmDS.imgSucc.Bitmap.LoadFromFile('AccPic.png');
      frmDS.imgContinue.Bitmap.LoadFromFile('Continue.png');
      imgSucc.Visible := True;
      lblMyAcc.Visible := True;
      lblMyAcc.Position.X := 78;
      lblMyAcc.Text := 'Welcome ' + sAccountName ;
      frmDonationSuccessful.Show;
    end
      else
    begin
      Showmessage('Incorrect Login Details');
      Exit;
    end;

end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  imgLogo := TImage.Create(Self);
  imgEmail := TImage.Create(Self);
  imgExit2 := TImage.Create(Self);
  imgPassword := TImage.Create(Self);
  lblSignUp := TLabel.Create(Self);
  lblLogin := TLabel.Create(Self);

  edtEmail := TEdit.Create(Self);
  edtPassword := TEdit.Create(Self);

  pnlSignUp := TPanel.Create(Self);
  btnLogin := TCornerButton.Create(Self);
  recBorder := TRectangle.Create(Self);

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Edit Details

  with edtEmail do
    begin
    Text := 'Email';
    Height := 22;
    Width := 150;
    Position.X := 384;
    Position.Y := 174;
    Parent := frmLogin;
    StyleLookup := 'transparentedit';
  end;

  with edtPassword do
    begin
    Text := 'Password';
    Height := 22;
    Width := 150;
    Position.X := 384;
    Position.Y := 210;
    Parent := frmLogin;
    StyleLookup := 'transparentedit';
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
    Parent := frmLogin;
  end;

  with imgEmail do
    begin
    imgEmail.bitmap.LoadFromFile('Email.png');
    Height := 40;
    Width := 40;
    Position.X := 351;
    Position.Y := 165;
    Parent := frmLogin;
  end;

  with imgPassword do
    begin
    imgPassword.bitmap.LoadFromFile('Password.jpg');
    Height := 40;
    Width := 40;
    Position.X := 351;
    Position.Y := 201;
    Parent := frmLogin;
  end;

  with imgExit2 do
    begin
    Bitmap.LoadFromFile('Exit.jpg');
    Height := 40;
    Width := 40;
    Position.X := 567;
    Position.Y := 10;
    Parent := frmLogin;
    Opacity := 1;
    OnClick := imgExit2Click;
  end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Lable Details

  with lblLogin do
    begin
    Text := 'Member Login';
    Height := 50;
    Width := 200;
    Position.X := 355;
    Position.Y := 70;
    Parent := frmLogin;
    TextSettings.Font.Size := 25;
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor];
    FontColor := TAlphaColors.White;
  end;

  with lblSignUp do
    begin
    Text := 'or sign up here';
    Height := 49;
    Width := 145;
    Enabled := True;
    Position.X := 410;
    Position.Y := 298;
    Parent := frmLogin;
    TextSettings.Font.Size := 10;
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    Cursor := crHandPoint;
  end;


  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Button Details

  with btnLogin do
    begin
    Text := 'Login Now!';
    Height := 49;
    Width := 145;
    Position.X := 368;
    Position.Y := 265;
    Parent := frmLogin;
    XRadius := 20;
    YRadius := 20;
    TextSettings.Font.Size := 15;
    StyledSettings := StyledSettings - [TStyledSetting.Size];
    OnClick := btnLoginClick;
    Cursor := crHandPoint;
  end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Animation Details

  FloatAnimation2.Parent := imgLogo;
   with FloatAnimation2 do
     begin
     AnimationType := TAnimationType.InOut;
     Loop := True;
     AutoReverse := True;
     Delay := 0;
     Duration := 4;
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
    Height := frmLogin.Height;
    Width := frmLogin.Width;
    Position.X := 0;
    Position.Y := 0;
    Stroke.Kind := TBrushKind.Solid;
    Enabled := False;
    Stroke.Thickness := 12;
    Stroke.Color := TAlphaColor($FFE0E0E0);
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := TAlphaColors.Null;
    Parent := frmLogin;
   end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Panel Details

  with pnlSignUp do
    begin
    Height := 15;
    Width := 70;
    Position.X := 410;
    Position.Y := 317;
    Opacity := 0;
    Parent := frmLogin;
    OnClick := pnlSignUpClick;
    OnMouseEnter := pnlLoginEnter;
    OnMouseLeave := pnlLoginLeave;
    end;
end;


procedure TfrmLogin.FormShow(Sender: TObject);
begin
   if bShown = False then
    begin
      FloatAnimation2.Start;
      bShown := True
    end;
end;

procedure TfrmLogin.imgExit2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLogin.pnlSignUpClick(Sender: TObject);
begin
  frmSignUp.Show;
  frmLogin.Hide;
end;

end.
