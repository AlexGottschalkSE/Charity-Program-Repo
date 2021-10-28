unit Mainpage_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, Data.DB,
  Data.Win.ADODB, FMX.Ani, FMX.EditBox, FMX.NumberBox,FMX.DateTimeCtrls, Blusins_u, frmDS, Math,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TfrmMain = class(TForm)
    procedure imgDIAEnter(Sender : TObject);
    procedure imgDIALeave(Sender : TObject);
    procedure imgGAIAEnter(Sender : TObject);
    procedure imgGAIALeave(Sender : TObject);
    procedure imgGAIAClick(Sender : TObject);
    procedure Dclick(Sender : TObject);
    procedure MCClick(Sender : TObject);
    procedure GiveawayClick(Sender : TObject);
    procedure VisaClick(Sender : TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender : TObject);
    procedure imgExitClick(Sender : TObject);
    procedure btnPayClick(Sender : TObject);
    procedure imgAccEnter(Sender : TObject);
    procedure imgAccLeave(Sender : TObject);
    procedure imgAccClick(Sender : TObject);
    procedure imgAboutClick(Snder : TObject);
    procedure imgAboutEnter(Sender : TObject);
    procedure imgAboutLeave(Snder : TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sPaymentMethod : String;
    sCode : String;
  end;

var
  frmMain: TfrmMain;

  imgBanner, imgDIA, imgSecPay, imgExit, imgMC, imgVisa, imgPP, imgDPB : TImage;     //Donate Images and others
  imgGAIA, imgSCW, imgGABanner, imgAccName, imgAbout, imgAboutUs : TImage;                       //Giveaway Images

  lblAccName, lblPA, lblCN, lblEPD, lblSC, lblNOC : TLabel;                          //Donate Labels
  lblName, lblID, lblPN : TLabel;                                                    //Giveaway Labels

  recLine, recPanel : TRectangle;

  edtAmount, edtNOC, edtCN, edtEPD, edtSC : TEdit;                                   //Donate Edits
  edtName, edtID, edtPN : TEdit;                                                     //Giveaway Edits

  btnPay, btnEG : TCornerButton;

  dtpDate : TDateEdit;

implementation

{$R *.fmx}

uses frmSignUp_u, frmLogIn_u, DataBase_u;



procedure TfrmMain.btnPayClick(Sender: TObject);
Var rAmount : Real;
    sTime, sDate, sFName, sName, sSurname, sAmount : String;
    sCardNum, sCVV, sMonth, sYear, sEPD : String;
    iPos, i : Integer;
begin
  dtpDate.date := Date;
  dtpDate.Time := Time;
  sDate := DateToStr(dtpDate.Date);
  sTime := TimeToStr(dtpDate.Time);
  sFName := edtNOC.Text;
  sCardNum := edtCN.Text;
  sCVV := edtSC.Text;
  sAmount := edtAmount.Text;

  if sPaymentMethod = '' then                                   //Checks Payment Method is Chosen
    begin
      Showmessage('Please select a payment method');
      Exit;
    end;

  if (edtAmount.text = '') or (edtNOC.text = '') or (edtCN.text = '') or (edtSC.text = '') or (edtEPD.text = '') then
    Begin
      Showmessage('Missing Credentials');                       //Checks boxes are filled
      Exit;
    End;

  Try
    rAmount := StrToFloat(sAmount);
  Except
    Begin
      Showmessage('Amount must only contain digits');
      Exit;
    End;
  End;


  if NOT (LENGTH(sCardNum) = 16) then                           //Checks Card Num is 16 digits
    begin
      Showmessage('Card number must be 16 digits');
      Exit;
    end;

  for  i := 1 to Length(sCardNum) do                            //Checks Card Number has no letters
    begin
      if NOT ((sCardNum[i]) in ['0'..'9']) then
        begin
          Showmessage('Card Number must contain only digits');
          Exit;
        end
    end;

  sEPD := edtEPD.Text;
  iPos := POS('/', sEPD);

  if iPos = 0 then
    begin
      Showmessage('Expiry Date must contain a "/"');
      Exit;
    end;

  sMonth := Copy(sEPD, 1, iPos - 1);
  Delete(sEPD, 1, iPos);
  sYear := sEPD;

  if Length(sMonth) or Length(sYear) <> 2 then
    begin
      Showmessage('Expiry date must be in the format "MM/YY"');
      Exit;
    end;

  for  i := 1 to Length(sMonth) do                            //Checks Month has no letters
    begin
      if NOT ((sMonth[i]) in ['0'..'9']) then
        begin
          Showmessage('Month of expiry must be digits');
          Exit;
        end
    end;

  for  i := 1 to Length(sYear) do                            //Checks Year has no letters
    begin
      if NOT ((sYear[i]) in ['0'..'9']) then
        begin
          Showmessage('Year of expiry must be digits');
          Exit;
        end
    end;

  if NOT (StrToInt(sMonth) in [1..12]) then
    begin
      showmessage('Invalid Month');
      Exit;
    end;

  if NOT (StrToInt(sYear) > 20) then
    begin
      showmessage('Invalid Year');
      Exit;
    end;


  for  i := 1 to Length(sCVV) do                            //Checks CVV has no letters
    begin
      if NOT ((sCVV[i]) in ['1'..'9']) then
        begin
          Showmessage('CVV must contain only digits');
          Exit;
        end
    end;

  if NOT (LENGTH(sCVV) = 3) then                           //Checks CVV is 3 digits
    begin
      Showmessage('CVV must be 3 digits');
      Exit;
    end;

  if POS(' ', sFName) = 0 then                                  //Checks name and surname is entered
    begin
      Showmessage('Please input a Name and Surname');
      Exit;
    end;


  iPos := POS(' ', sFName);
  sName := COPY(sFName, 1, iPos-1);
  Delete(sFName, 1, iPos);
  sSurname := sFName;


  with DataBase_U.frmDatabase do
    begin
      adoDonations.Insert;
      adoDonations['Name'] := sName;
      adoDonations['Surname'] := sSurname;
      adoDonations['Date'] := sDate;
      adoDonations['Time'] := sTime;
      adoDonations['Amount'] := rAmount;
      adoDonations['Type'] := sPaymentMethod;
      adoDonations.Post;
    end;

  lblCode.Visible := False;
  imgContinue.Visible := False;
  imgLogout.Visible := False;
  imgDone.Visible := True;
  imgDone.Bitmap.LoadFromFile('Done.png');
  imgSucc.Bitmap.LoadFromFile('Paysucc.png');
  frmDonationSuccessful.show;

  edtAmount.Text := '';
  edtNOC.Text := '';
  edtCN.Text := '';
  edtEPD.Text := 'MM/YY';
  edtSC.Text := '';
  edtName.Text := '';
  edtID.Text := '';
  edtPN.Text := '';


end;

procedure TfrmMain.Dclick(Sender: TObject);                                  //When user clicks on donate option
begin
  imgAboutUs.Visible := False;
  imgSecPay.Visible := True;
  imgMC.Visible := True;
  imgVisa.Visible := True;
  edtAmount.Visible := True;
  edtNOC.Visible := True;
  edtCN.Visible := True;
  edtEPD.Visible := True;
  edtSC.Visible := True;
  lblPA.Visible := True;
  lblCN.Visible := True;
  lblEPD.Visible := True;
  lblSC.Visible := True;
  lblNOC.Visible := True;
  btnPay.Visible := True;
  imgDPB.Visible := True;

  imgGABanner.Visible := False;
  imgSCW.Visible := False;
  edtName.Visible := False;
  edtID.Visible := False;
  edtPN.Visible := False;
  lblMyAcc.Visible := False;
  lblName.Visible := False;
  lblID.Visible := False;
  lblPN.Visible := False;
  btnEG.Visible := False;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  imgBanner := TImage.Create(Self);
  imgDIA := TImage.Create(Self);
  imgSecPay := TImage.Create(Self);
  imgExit := TImage.Create(Self);
  imgMC := TImage.Create(Self);
  imgVisa := TImage.Create(Self);
  imgDPB := TImage.Create(Self);
  imgGAIA := TImage.Create(Self);
  imgSCW := TImage.Create(Self);
  imgGABanner := TImage.Create(Self);
  imgAccName := TImage.Create(Self);
  imgAbout := TImage.Create(Self);
  imgAboutUs := TImage.Create(Self);

  edtAmount := TEdit.Create(Self);
  edtCN := TEdit.Create(Self);
  edtEPD := TEdit.Create(Self);
  edtSC := TEdit.Create(Self);
  edtNOC := TEdit.Create(Self);
  edtName := TEdit.Create(Self);
  edtID := TEdit.Create(Self);
  edtPN := TEdit.Create(Self);

  btnPay := TCornerButton.Create(Self);
  btnEG := TCornerButton.Create(Self);

  recPanel := TRectangle.Create(Self);
  recLine := TRectangle.Create(Self);

  dtpDate := TDateEdit.Create(Self);

  lblAccName := TLabel.Create(Self);
  lblPA := TLabel.Create(Self);
  lblCN := TLabel.Create(Self);
  lblEPD := TLabel.Create(Self);
  lblSC := TLabel.Create(Self);
  lblNOC := TLabel.Create(Self);
  lblName := TLabel.Create(Self);
  lblID := TLabel.Create(Self);
  lblPN := TLabel.Create(Self);

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Image Details

  with imgBanner do
    begin
    Bitmap.LoadFromFile('Banner.png');
    Height := 113;
    Width := 257;
    Position.X := 8;
    Position.Y := 8;
    Parent := frmMain;
    end;

  with imgAccName do
    begin
    Bitmap.LoadFromFile('NameActive.png');
    Height := 61;
    Width := 118;
    Position.X := 730;
    Position.Y := 30;
    Parent := frmMain;
    OnMouseEnter := imgAccEnter;
    OnMouseLeave := imgAccLeave;
    BringToFront;
    imgAccName.Opacity := 0;
    OnClick := imgAccClick;
    end;

  with imgDIA do
    begin
    Bitmap.LoadFromFile('Donate Inactive.png');
    Height := 61;
    Width := 118;
    Position.X := 408;
    Position.Y := 30;
    Parent := frmMain;
    OnMouseEnter := imgDIAEnter;
    OnMouseLeave := imgDIALeave;
    BringToFront;
    OnClick := DClick;
    end;

   with imgGAIA do
    begin
    Bitmap.LoadFromFile('Giveaway Inactive.png');
    Height := 61;
    Width := 118;
    Position.X := 520;
    Position.Y := 30;
    Parent := frmMain;
    OnMouseEnter := imgGAIAEnter;
    OnMouseLeave := imgGAIALeave;
    BringToFront;
    OnClick := imgGAIAClick;
    end;

   with imgAbout do
    begin
    Bitmap.LoadFromFile('About Inactive.png');
    Height := 61;
    Width := 118;
    Position.X := 630;
    Position.Y := 30;
    Parent := frmMain;
    OnMouseEnter := imgAboutEnter;
    OnMouseLeave := imgAboutLeave;
    BringToFront;
    OnClick := imgAboutClick;
    end;

   with imgSecPay do
    begin
    Bitmap.LoadFromFile('SecPay.png');
    Height := 150;
    Width := 250;
    Position.X := 539;
    Position.Y := 120;
    Parent := frmMain;
    BringToFront;
    Visible := False;
   end;

   with imgExit do
    begin
    Bitmap.LoadFromFile('Exit.jpg');
    Height := 40;
    Width := 40;
    Position.X := 819;
    Position.Y := 0;
    Parent := frmMain;
    Opacity := 1;
    OnClick := imgExitClick;
    end;

  with imgMC do
    begin
    Bitmap.LoadFromFile('Mastercard.png');
    Height := 39;
    Width := 111;
    Position.X := 550;
    Position.Y := 235;
    Parent := frmMain;
    Visible := False;
    OnClick := MCClick;
    end;

  with imgVisa do
    begin
    Bitmap.LoadFromFile('Visa.png');
    Height := 39;
    Width := 111;
    Position.X := 657;
    Position.Y := 235;
    Parent := frmMain;
    Visible := False;
    OnClick := VisaClick;
    end;

  with imgDPB do
    begin
    Bitmap.LoadFromFile('DPB.png');
    Height := 321;
    Width := 465;
    Position.X := 40;
    Position.Y := 180;
    Parent := frmMain;
    Visible := False;
    end;

  with imgSCW do
    begin
    Bitmap.LoadFromFile('SACTW.png');
    Height := 361;
    Width := 369;
    Position.X := 32;
    Position.Y := 236;
    Parent := frmMain;
    Visible := False;
    end;

  with imgGABanner do
    begin
    Bitmap.LoadFromFile('GiveawayBanner.png');
    Height := 113;
    Width := 481;
    Position.X := 186;
    Position.Y := 128;
    Parent := frmMain;
    Visible := False;
    end;

  with imgAboutUs do
    begin
    Bitmap.LoadFromFile('AboutUs.png');
    Height := 777;
    Width := 481;
    Position.X := 180;
    Position.Y := -10;
    Parent := frmMain;
    Visible := False;
    SendToBack;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Line Details

   with recLine do
    begin
    Height := 9;
    Width := frmMain.Width;
    Position.X := 0;
    Position.Y := 120;
    Stroke.Kind := TBrushKind.Solid;
    Enabled := True;
    Stroke.Thickness := 1;
    Opacity := 1;
    Stroke.Color := $FFFFFFFF;
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := $FFFFFFFF;
    Parent := frmMain;
    SendToBack;
    end;

  with recPanel do
    begin
    Opacity := 100;
    Height := 39;
    Width := frmMain.Width;
    Position.X := 425;
    Position.Y := 40;
    Stroke.Kind := TBrushKind.Solid;
    Enabled := True;
    Stroke.Thickness := 1;
    Stroke.Color := $FFFFFFFF;
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := $FFFFFFFF;
    Parent := frmMain;
    SendToBack;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Label Details

  with lblAccName do
    begin
    Height := 25;
    Width := 200;
    Position.X := 760;
    Position.Y := 46;
    Parent := frmMain;
    TextSettings.Font.Size := 18;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.Black;
    BringToFront;
  end;

  with lblPA do
    begin
    Height := 17;
    Width := 120;
    Position.X := 576;
    Position.Y := 280;
    Text := 'Payment Amount';
    Parent := frmMain;
    TextSettings.Font.Size := 12;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    BringToFront;
    Visible := False;
  end;

  with lblCN do
    begin
    Height := 17;
    Width := 120;
    Position.X := 576;
    Position.Y := 336;
    Text := 'Card Number';
    Parent := frmMain;
    TextSettings.Font.Size := 12;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    BringToFront;
    Visible := False;
  end;

  with lblEPD do
    begin
    Height := 17;
    Width := 65;
    Position.X := 576;
    Position.Y := 392;
    Text := 'Expiry Date';
    Parent := frmMain;
    TextSettings.Font.Size := 12;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    BringToFront;
    Visible := False;
  end;

  with lblSC do
    begin
    Height := 17;
    Width := 81;
    Position.X := 684;
    Position.Y := 392;
    Text := 'Security Code';
    Parent := frmMain;
    TextSettings.Font.Size := 12;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    BringToFront;
    Visible := False;
  end;

  with lblNOC do
    begin
    Height := 17;
    Width := 120;
    Position.X := 576;
    Position.Y := 448;
    Text := 'Name on Card';
    Parent := frmMain;
    TextSettings.Font.Size := 12;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    BringToFront;
    Visible := False;
  end;

  with lblName do
    begin
    Height := 17;
    Width := 120;
    Position.X := 536;
    Position.Y := 312;
    Text := 'Name and Surname';
    Parent := frmMain;
    TextSettings.Font.Size := 12;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    BringToFront;
    Visible := False;
  end;

  with lblID do
    begin
    Height := 17;
    Width := 120;
    Position.X := 536;
    Position.Y := 368;
    Text := 'ID Number';
    Parent := frmMain;
    TextSettings.Font.Size := 12;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    BringToFront;
    Visible := False;
  end;

  with lblPN do
    begin
    Height := 17;
    Width := 120;
    Position.X := 536;
    Position.Y := 424;
    Text := 'Phone Number';
    Parent := frmMain;
    TextSettings.Font.Size := 12;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    BringToFront;
    Visible := False;
  end;



  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Edit Details

  with edtAmount do
    begin
    Text := '';
    Height := 33;
    Width := 185;
    Position.X := 576;
    Position.Y := 296;
    Parent := frmMain;
    Visible := False;
    end;

  with edtCN do
    begin
    Text := '';
    Height := 33;
    Width := 185;
    Position.X := 576;
    Position.Y := 352;
    Parent := frmMain;
    Visible := False;
    end;

  with edtEPD do
    begin
    Text := 'MM/YY';
    Height := 33;
    Width := 97;
    Position.X := 576;
    Position.Y := 408;
    Parent := frmMain;
    Visible := False;
    end;

  with edtSC do
    begin
    Text := '';
    Height := 33;
    Width := 89;
    Position.X := 672;
    Position.Y := 408;
    Parent := frmMain;
    Visible := False;
    end;

  with edtNOC do
    begin
    Text := '';
    Height := 33;
    Width := 185;
    Position.X := 576;
    Position.Y := 464;
    Parent := frmMain;
    Visible := False;
    end;

   with edtName do
    begin
    Text := '';
    Height := 22;
    Width := 225;
    Position.X := 536;
    Position.Y := 328;
    Parent := frmMain;
    Visible := False;
    end;

   with edtID do
    begin
    Text := '';
    Height := 22;
    Width := 225;
    Position.X := 536;
    Position.Y := 384;
    Parent := frmMain;
    Visible := False;
    end;

   with edtPN do
    begin
    Text := '';
    Height := 22;
    Width := 225;
    Position.X := 536;
    Position.Y := 440;
    Parent := frmMain;
    Visible := False;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                     //Dynamic Button Details

  with btnPay do
    begin
    Text := 'Pay Now';
    Height := 33;
    Width := 137;
    Position.X := 600;
    Position.Y := 512;
    Parent := frmMain;
    XRadius := 5;
    YRadius := 7;
    TextSettings.Font.Size := 16;
    StyledSettings := StyledSettings - [TStyledSetting.Size];
    Visible := False;
    OnClick := btnPayClick;
    end;

  with btnEG do
    begin
    Text := 'Enter Giveaway';
    Height := 41;
    Width := 129;
    Position.X := 584;
    Position.Y := 488;
    Parent := frmMain;
    XRadius := 5;
    YRadius := 7;
    TextSettings.Font.Size := 16;
    StyledSettings := StyledSettings - [TStyledSetting.Size];
    Visible := False;
    OnClick := GiveawayClick;
    end;


end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  lblAccName.Text := frmLogin.sAccountName;

  edtAmount.Text := '';
  edtNOC.Text := '';
  edtCN.Text := '';
  edtEPD.Text := 'MM/YY';
  edtSC.Text := '';
  edtName.Text := '';
  edtID.Text := '';
  edtPN.Text := '';

end;

procedure TfrmMain.GiveawayClick(Sender: TObject);
Var sName, sID, sPN, sDate, sTime, sEmail, sPassword : String;
    i : Integer;
begin
  imgAboutUs.Visible := False;
  sName := edtName.Text;
  sID := edtID.Text;
  sPN := edtPN.Text;
  dtpDate.date := Date;
  dtpDate.Time := Time;
  sDate := DateToStr(dtpDate.Date);
  sTime := TimeToStr(dtpDate.Time);
  sCode := '#' + IntToStr(RandomRange(1, 99999));
  lblMyAcc.Visible := False;

  if sName = '' then                                  //Checks name and surname is entered
    begin
      Showmessage('Please input a Name and Surname');
      Exit;
    end;

  if sID = '' then                                  //Checks name and surname is entered
    begin
      Showmessage('Please input an ID number');
      Exit;
    end;

  if sPN = '' then                                  //Checks name and surname is entered
    begin
      Showmessage('Please input a phone number');
      Exit;
    end;

  if POS(' ', sName) = 0 then                                  //Checks name and surname is entered
    begin
      Showmessage('Please input a Name and Surname');
      Exit;
    end;

  for  i := 1 to Length(sID) do                            //Checks ID has no letters
    begin
      if NOT ((sID[i]) in ['0'..'9']) then
        begin
          Showmessage('ID must contain only digits');
          Exit;
        end
    end;

  for  i := 1 to Length(sPN) do                            //Checks Phone Number has no letters
    begin
      if NOT ((sPN[i]) in ['0'..'9']) then
        begin
          Showmessage('Phone number must contain only digits');
          Exit;
        end
    end;

  if NOT (LENGTH(sID) = 13) then                           //Checks ID is 13 digits
    begin
      Showmessage('ID must be 13 digits');
      Exit;
    end;

  if NOT (LENGTH(sPN) = 10) then                           //Checks Phone number is 10 digits
    begin
      Showmessage('Phone Number must be 10 digits');
      Exit;
    end;


  objBlusins := TBlusins.Create(sName, sEmail, sPassword);
  with DataBase_U.frmDatabase do
    begin
      adoGiveaway.Insert;
      adoGiveaway['Name'] := objBlusins.getName;
      adoGiveaway['Surname'] := objBlusins.getSurname;
      adoGiveaway['ID Number'] := sID;
      adoGiveaway['Phone Number'] := sPN;
      adoGiveaway['Date'] := sDate;
      adoGiveaway['Time'] := sTime;
      adoGiveaway['Code'] := sCode;
      adoGiveaway.Post;
    end;

  lblCode.Visible := True;
  lblCode.Text := 'Your Unique Code is ' + sCode;
  imgDone.Bitmap.LoadFromFile('EnterDone.png');
  imgSucc.Bitmap.LoadFromFile('EnterSucc.png');
  frmDonationSuccessful.Show;
  edtAmount.Text := '';
  edtNOC.Text := '';
  edtCN.Text := '';
  edtEPD.Text := 'MM/YY';
  edtSC.Text := '';
  edtName.Text := '';
  edtID.Text := '';
  edtPN.Text := '';
end;

procedure TfrmMain.imgAboutClick(Snder: TObject);
begin
  imgSecPay.Visible := false;
  imgMC.Visible := false;
  imgVisa.Visible := false;
  edtAmount.Visible := false;
  edtNOC.Visible := false;
  edtCN.Visible := false;
  edtEPD.Visible := false;
  edtSC.Visible := false;
  lblPA.Visible := false;
  lblCN.Visible := false;
  lblEPD.Visible := false;
  lblSC.Visible := false;
  lblNOC.Visible := false;
  btnPay.Visible := false;
  imgDPB.Visible := false;

  imgGABanner.Visible := false;
  imgSCW.Visible := false;
  lblName.Visible := false;
  lblID.Visible := false;
  lblPN.Visible := false;
  edtName.Visible := false;
  edtID.Visible := false;
  edtPN.Visible := false;
  btnEG.Visible := false;

  imgAboutUs.Visible := True;


end;

procedure TfrmMain.imgAboutEnter(Sender: TObject);
begin
  imgAbout.Bitmap.LoadFromFile('About Active.png');
end;

procedure TfrmMain.imgAboutLeave(Snder: TObject);
begin
  imgAbout.Bitmap.LoadFromFile('About Inactive.png');
end;

procedure TfrmMain.imgAccClick(Sender: TObject);
begin
  frmDonationSuccessful.Show;
  frmDS.imgSucc.Bitmap.LoadFromFile('AccPic.png');
  frmDS.imgLogOut.Bitmap.LoadFromFile('LogOut.png');
  frmDS.lblMyAcc.Position.X := 112;
  frmDS.lblMyAcc.Text := 'Log Out';
  frmDS.lblMyAcc.Visible := True;
  frmDS.imgLogOut.Visible := True;
  imgAboutUs.Visible := False;
  lblCode.Visible := False;
end;

procedure TfrmMain.imgAccEnter(Sender: TObject);
begin
  imgAccName.Bitmap.LoadFromFile('NameActive.png');
  imgAccName.Opacity := 1;
end;

procedure TfrmMain.imgAccLeave(Sender: TObject);
begin
  imgAccName.Opacity := 0;
end;

procedure TfrmMain.imgDIAEnter(Sender: TObject);
begin
  imgDIA.Bitmap.LoadFromFile('Donate Active.png');
end;

procedure TfrmMain.imgDIALeave(Sender: TObject);
begin
  imgDIA.Bitmap.LoadFromFile('Donate Inactive.png');
end;

procedure TfrmMain.imgExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.imgGAIAClick(Sender: TObject);               //When User chooses Giveaway
begin
  imgAboutUs.Visible := False;
  imgSecPay.Visible := false;
  imgMC.Visible := false;
  imgVisa.Visible := false;
  edtAmount.Visible := false;
  edtNOC.Visible := false;
  edtCN.Visible := false;
  edtEPD.Visible := false;
  edtSC.Visible := false;
  lblPA.Visible := false;
  lblCN.Visible := false;
  lblEPD.Visible := false;
  lblSC.Visible := false;
  lblNOC.Visible := false;
  btnPay.Visible := false;
  imgDPB.Visible := false;

  imgGABanner.Visible := True;
  imgSCW.Visible := True;
  lblName.Visible := True;
  lblID.Visible := True;
  lblPN.Visible := True;
  edtName.Visible := True;
  edtID.Visible := True;
  edtPN.Visible := True;
  btnEG.Visible := True;
end;

procedure TfrmMain.imgGAIAEnter(Sender: TObject);
begin
  imgGAIA.Bitmap.LoadFromFile('Giveaway Active.png');
end;

procedure TfrmMain.imgGAIALeave(Sender: TObject);
begin
  imgGAIA.Bitmap.LoadFromFile('Giveaway Inactive.png');
end;

procedure TfrmMain.MCClick(Sender: TObject);
begin
  sPaymentMethod := 'Master Card';
  imgMC.Enabled := False;
  imgVisa.Enabled := True;
end;

procedure TfrmMain.VisaClick(Sender: TObject);
begin
  sPaymentMethod := 'Visa';
  imgVisa.Enabled := False;
  imgMC.Enabled := True;
end;

end.
