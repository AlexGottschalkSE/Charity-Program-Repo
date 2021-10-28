unit admin_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.DateTimeCtrls, DataBase_u, fmx.Grid,
  System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Memo, FMX.Memo.Types, Math;

Const
  MAXNUM = 1000;

type
  TfrmAdmin = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure DashClick(Sender : TObject);
    procedure DonoClick(Sender : TObject);
    procedure GiveawayClick(Sender : TObject);
    procedure LoginClick(Sender : TObject);
    procedure FormShow(Sender: TObject);
    procedure ExitClick(Sender : TObject);
    procedure LogoutClick(Sender : TObject);
    procedure btnFindNameClick(Sender : TObject);
    procedure btnFindSurnameClick(Sender : TObject);
    procedure btnRestoreClick(Sender : TObject);
    procedure btnChooseWinnerClick(Sender : TObject);
    procedure btnAddAccClick(Sender : TObject);
    procedure btnDeleteAccClick(Sender : TObject);
  private
    { Private declarations }
    iTotalDonations : Integer;
    arrName : Array[1..Maxnum] of String;
    arrSurname : Array[1..Maxnum] of String;
    arrAmount : Array[1..Maxnum] of String;
    iCount : Integer;
    iTotalEntries : Integer;
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;

  imgBanner, imgDash, imgDNBanner, imgGBanner, imgAccBanner, imgExit2 : TImage;

  pnlDash, pnlDono, pnlLogins, pnlGiveaway, pnlLogout : TPanel;

  lblDate, lblEmail, lblPass : TLabel;
  lblDCount, lblDHighest, lblDAverage, lblDTotal : TLabel;
  lblEntries, lblEToday, lblChance : TLabel;
  lblAccTotal, lblAccToday : TLabel;

  memDono : TMemo;

  dtpDate : TDateEdit;

  btnSearchName, btnFindSurname, btnRestoreDB : TButton;
  btnChooseWinner : TButton;
  btnAddAccount, btnDeleteAcc, btnSortPayments : TButton;
implementation

{$R *.fmx}

uses frmLogIn_u, frmSignUp_u;


procedure TfrmAdmin.btnAddAccClick(Sender: TObject);
Var sName, sSurname, sEmail, sPassword, sDate, sTime, sLine : String;
begin
  sName := Inputbox('Insert new Firstname here', 'Insert here', '');
  sSurname := Inputbox('Insert new Surname here', 'Insert here', '');
  sEmail := Inputbox('Insert new Email here', 'Insert here', '');
  sPassword := Inputbox('Insert new Password here', 'Insert here', '');

  dtpDate.Date:= Date;
  dtpDate.Time := Time;
  sDate := DateToStr(dtpDate.Date);
  sTime := TimeToStr(dtpDate.Time);
  memDono.Lines.Clear;
  with DataBase_U.frmDatabase do
    begin
      adoLogin.Open;
      adoLogin.Insert;
      adoLogin['Name'] := sName;
      adoLogin['Surname'] := sSurname;
      adoLogin['Email'] := sEmail;
      adoLogin['Password'] := sPassword;
      adoLogin['Date'] := sDate;
      adoLogin['Time'] := sTime;
      adoLogin.Post;
    end;

  with DataBase_U.frmDatabase do                 //Finding total amount of Donations and Amount
   begin
     adoLogin.Open;
     adoLogin.First;

     while not adoLogin.Eof do
       begin
         sLine :=  adoLogin.FieldByName('Name').AsString + #9 + adoLogin.FieldByName('Surname').AsString + #9 +
         adoLogin.FieldByName('Email').AsString + #9 + adoLogin.FieldByName('Date').AsString;
         memDono.Lines.Add(sLine);
         adoLogin.Next;
       end;
         adoLogin.Close;
     end;

end;

procedure TfrmAdmin.btnChooseWinnerClick(Sender: TObject);
Var iWinner, i, iPos : Integer;
    sLine, sName, sSurname, sCode : String;
begin
  iWinner := RandomRange(1,iTotalEntries + 1);

  sLine :=  memDono.Lines[iWinner - 1];

  Showmessage(sLine);

  memDono.Lines.Delete(iWinner);
  iTotalEntries := iTotalEntries - 1;

end;

procedure TfrmAdmin.btnDeleteAccClick(Sender: TObject);
Var sSurname, sLine : String;
begin
  sSurname := Inputbox('Input Surname to Delete', 'Input Here', '');
  memDono.Lines.Clear;
  with Database_u.frmDatabase do
    begin
      qryLogins.close;
      qryLogins.SQL.Clear;
      qryLogins.SQL.Add('DELETE FROM Logins ');
      qryLogins.SQL.Add('Where Surname = "' + sSurname + '"');
      qryLogins.ExecSQL;
      qryLogins.close
    end;

   with DataBase_U.frmDatabase do                 //Finding total amount of Donations and Amount
   begin
     adoLogin.Open;
     adoLogin.First;

     while not adoLogin.Eof do
       begin
         sLine :=  adoLogin.FieldByName('Name').AsString + #9 + adoLogin.FieldByName('Surname').AsString + #9 +
         adoLogin.FieldByName('Email').AsString + #9 + adoLogin.FieldByName('Date').AsString;
         memDono.Lines.Add(sLine);
         adoLogin.Next;
       end;
   adoLogin.Close;
     end;
end;

procedure TfrmAdmin.btnFindNameClick(Sender: TObject);
var
  i: Integer;
  sSearch : String;
begin
  memDono.Lines.Clear;
  memDono.Lines.Add('Name' + #9 + 'Surname' + #9 + '      Amount' + #13);
  sSearch := Inputbox('Please input a first name', 'Enter Name', 'Alex');

  with DataBase_U.frmDatabase do                 //Finding total amount of Donations and Amount
   begin
     adoDonations.Open;
     adoDonations.First;
   while not adoDonations.Eof do
     begin
       if adoDonations.FieldByName('Name').AsString = sSearch then
         begin
           memDono.Lines.Add(adoDonations.FieldByName('Name').AsString + #9 +
           adoDonations.FieldByName('Surname').AsString + #9 + '      ' + adoDonations.FieldByName('Amount').AsString);
           adoDonations.Next;
         end
     else
   adoDonations.Next;
   end;
   end;
end;


procedure TfrmAdmin.btnFindSurnameClick(Sender: TObject);
var
  i: Integer;
  sSearch : String;
begin
  memDono.Lines.Clear;
  memDono.Lines.Add('Name' + #9 + 'Surname' + #9 + '      Amount' + #13);
  sSearch := Inputbox('Please input a Surname', 'Enter Name', 'Woods');

  with DataBase_U.frmDatabase do
   begin
     adoDonations.Open;
     adoDonations.First;
   while not adoDonations.Eof do
   begin
     if adoDonations.FieldByName('Surname').AsString = sSearch then
       begin
         memDono.Lines.Add(adoDonations.FieldByName('Name').AsString + #9 +
         adoDonations.FieldByName('Surname').AsString + #9 + '      ' + adoDonations.FieldByName('Amount').AsString);
         adoDonations.Next;
       end
     else
   adoDonations.Next;
   end;
   end;

   end;

procedure TfrmAdmin.btnRestoreClick(Sender: TObject);
Var sLine : String;
begin
  memDono.Lines.Clear;
  with DataBase_U.frmDatabase do                 //Finding total amount of Donations and Amount
   begin
     adoDonations.Open;
     adoDonations.First;

     while not adoDonations.Eof do
       begin

         sLine :=  adoDonations.FieldByName('Name').AsString + #9 + adoDonations.FieldByName('Surname').AsString + #9 +
         adoDonations.FieldByName('Date').AsString + #9 + adoDonations.FieldByName('Amount').AsString + #9
         + adoDonations.FieldByName('Type').AsString;

         memDono.Lines.Add(sLine);
         adoDonations.Next;
       end;
   adoDonations.Close;
   end;
end;

procedure TfrmAdmin.DashClick(Sender: TObject);                //When Dashboard is clicked
begin
  imgDash.Visible := True;
  lblDate.Visible := True;
  lblEmail.Visible := True;
  lblPass.Visible := True;
  btnChooseWinner.Visible := False;
  lblEntries.Visible := False;
  lblEToday.Visible := False;
  lblChance.Visible := False;
  btnDeleteAcc.Visible := False;
  btnAddAccount.Visible := False;
  lblDCount.Visible := False;
  lblDHighest.Visible := False;
  lblDAverage.Visible := False;
  lblDTotal.Visible := False;
  imgDNBanner.Visible := False;
  memDono.Visible := False;
  btnSearchName.Visible := False;
  btnFindSurname.Visible := False;
  btnRestoreDB.Visible := False;
  btnSortPayments.Visible := False;
  imgGBanner.Visible := False;
  lblEntries.Visible := False;
  lblEToday.Visible := False;
  lblChance.Visible := False;

  imgAccBanner.Visible := False;
  lblAccToday.Visible := False;
  lblAccTotal.Visible := False;
end;

procedure TfrmAdmin.DonoClick(Sender: TObject);                //When Donations is clicked
Var iTotalAmount, iRow, iHighest : Integer;
    rAverageAmount : Real;
    sLine : String;
begin
  rAverageAmount := 0;
  iTotalDonations := 0;
  iTotalAmount := 0;
  rAverageAmount := 0;
  iHighest := 1;
  imgDash.Visible := False;
  lblDate.Visible := False;
  lblEmail.Visible := False;
  lblPass.Visible := False;
  iRow := 0;
  iCount := 0;
  btnChooseWinner.Visible := False;
  lblEntries.Visible := False;
  lblEToday.Visible := False;
  lblChance.Visible := False;
  btnFindSurname.Visible := True;
  btnRestoreDB.Visible := True;
  btnSortPayments.Visible := True;
  btnAddAccount.Visible := False;
  btnDeleteAcc.Visible := False;
  imgAccBanner.Visible := False;
  lblAccToday.Visible := False;
  lblAccTotal.Visible := False;
  btnSearchName.Visible := True;
  memDono.Visible := True;
  imgDNBanner.Visible := True;
  lblDCount.Visible := True;
  lblDHighest.Visible := True;
  lblDAverage.Visible := True;
  lblDTotal.Visible := True;
  imgGBanner.Visible := False;
  memDono.Lines.Clear;

  with DataBase_U.frmDatabase do                 //Finding total amount of Donations and Amount
   begin
     adoDonations.Open;
     adoDonations.First;

     while not adoDonations.Eof do
       begin
         iTotalDonations := iTotalDonations + adoDonations.FieldByName('Amount').AsInteger;


         inc(iCount);
         arrName[iCount] := adoDonations.FieldByName('Name').AsString;
         arrSurname[iCount] := adoDonations.FieldByName('Surname').AsString;
         arrAmount[iCount] := adoDonations.FieldByName('Amount').AsString;

         sLine :=  adoDonations.FieldByName('Name').AsString + #9 + adoDonations.FieldByName('Surname').AsString + #9 +
         adoDonations.FieldByName('Date').AsString + #9 + adoDonations.FieldByName('Amount').AsString + #9
         + adoDonations.FieldByName('Type').AsString;

         memDono.Lines.Add(sLine);
         inc(iTotalAmount);
         adoDonations.Next;
       end;
   adoDonations.Close;
     end;

  rAverageAmount := iTotalDonations/iTotalAmount;      //Finding Average Donation Amount


  with DataBase_U.frmDatabase do
  begin
     adoDonations.Open;
     adoDonations.First;
  while NOT adoDonations.eof do          //Finding Highest Donation
     begin
       if adoDonations.FieldByName('Amount').AsInteger > iHighest then
         begin
          iHighest:= adoDonations.FieldByName('Amount').AsInteger;
         end;
        adoDonations.Next;
     end;
  adoDonations.Close;
  end;

  lblDCount.Text := IntToStr(iTotalAmount);
  lblDHighest.Text := IntToStr(iHighest);
  lblDAverage.Text :=  FloatToStrF(rAverageAmount, ffFixed, 8,0);
  lblDTotal.Text := IntToStr(iTotalDonations);

end;

procedure TfrmAdmin.ExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmAdmin.FormCreate(Sender: TObject);
begin
  imgBanner := TImage.Create(Self);
  imgDash := TImage.Create(Self);
  imgDNBanner := TImage.Create(Self);
  imgGBanner := TImage.Create(Self);
  imgAccBanner := TImage.Create(Self);
  imgExit2 := TImage.Create(Self);

  pnlDash := TPanel.Create(Self);
  pnlDono := TPanel.Create(Self);
  pnlLogins := TPanel.Create(Self);
  pnlGiveaway := TPanel.Create(Self);
  pnlLogout := TPanel.Create(Self);

  lblEmail := TLabel.Create(Self);
  lblPass := TLabel.Create(Self);
  lblDate := TLabel.Create(Self);

  lblDCount := TLabel.Create(Self);
  lblDHighest := TLabel.Create(Self);
  lblDAverage := TLabel.Create(Self);
  lblDTotal := TLabel.Create(Self);

  lblEntries := TLabel.create(Self);
  lblEToday := TLabel.Create(Self);
  lblChance := TLabel.Create(Self);

  lblAccTotal := TLabel.Create(Self);
  lblAccToday := TLabel.Create(Self);
  memDono := TMemo.Create(Self);

  dtpDate := TDateEdit.Create(Self);

  btnSearchName := TButton.Create(Self);
  btnFindSurname := TButton.Create(Self);
  btnRestoreDB := TButton.Create(Self);
  btnChooseWinner := TButton.Create(Self);
  btnAddAccount := TButton.Create(Self);
  btnDeleteAcc := TButton.Create(Self);
  btnSortPayments := TButton.Create(Self);
  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Image Details

  with imgBanner do
    begin
    Bitmap.LoadFromFile('AdminBanner.png');
    Height := 630;
    Width := 185;
    Position.X := 0;
    Position.Y := -15;
    Parent := frmAdmin;
    SendtoBack;
    end;

  with imgExit2 do
    begin
    Bitmap.LoadFromFile('Exit.jpg');
    Height := 40;
    Width := 40;
    Position.X := 820;
    Position.Y := 0;
    Parent := frmAdmin;
    Opacity := 1;
    OnClick := ExitClick;
    end;

  with imgDash do
    begin
    Bitmap.LoadFromFile('DashBanner.png');
    Height := 113;
    Width := 609;
    Position.X := 190;
    Position.Y := -15;
    Parent := frmAdmin;
    SendtoBack;
    Visible := False;
    end;

  with imgDNBanner do
    begin
    Bitmap.LoadFromFile('DonationsBanner.png');
    Height := 113;
    Width := 609;
    Position.X := 210;
    Position.Y := 5;
    Parent := frmAdmin;
    SendtoBack;
    Visible := False;
    end;

  with imgGBanner do
    begin
    Bitmap.LoadFromFile('GiveawayPage.png');
    Height := 113;
    Width := 609;
    Position.X := 210;
    Position.Y := 5;
    Parent := frmAdmin;
    SendtoBack;
    Visible := False;
    end;

  with imgAccBanner do
    begin
    Bitmap.LoadFromFile('AccountsBanner.png');
    Height := 113;
    Width := 609;
    Position.X := 210;
    Position.Y := 5;
    Parent := frmAdmin;
    SendtoBack;
    Visible := False;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Button Details

  with btnSearchName do
    begin
    Text := 'Search for first name';
    Height := 22;
    Width := 140;
    Position.X := 705;
    Position.Y := 145;
    Parent := frmAdmin;
    TextSettings.Font.Size := 14;
    StyledSettings := StyledSettings - [TStyledSetting.Size] ;
    OnClick := btnFindNameClick;
    Cursor := crHandPoint;
    BringToFront;
    Visible := False;
    end;

  with btnFindSurname do
    begin
    Text := 'Search for Surname';
    Height := 22;
    Width := 140;
    Position.X := 705;
    Position.Y := 175;
    Parent := frmAdmin;
    TextSettings.Font.Size := 14;
    StyledSettings := StyledSettings - [TStyledSetting.Size] ;
    OnClick := btnFindSurnameClick;
    Cursor := crHandPoint;
    BringToFront;
    Visible := False;
    end;

  with btnRestoreDB do
    begin
    Text := 'Restore Database';
    Height := 22;
    Width := 140;
    Position.X := 705;
    Position.Y := 205;
    Parent := frmAdmin;
    TextSettings.Font.Size := 14;
    StyledSettings := StyledSettings - [TStyledSetting.Size] ;
    OnClick := btnRestoreClick;
    Cursor := crHandPoint;
    BringToFront;
    Visible := False;
    end;

  with btnChooseWinner do
    begin
    Text := 'Choose Winner';
    Height := 22;
    Width := 140;
    Position.X := 444;
    Position.Y := 110;
    Parent := frmAdmin;
    TextSettings.Font.Size := 14;
    StyledSettings := StyledSettings - [TStyledSetting.Size] ;
    OnClick := btnChooseWinnerClick;
    Cursor := crHandPoint;
    BringToFront;
    Visible := False;
    end;

  with btnAddAccount do
    begin
    Text := 'Add Account';
    Height := 22;
    Width := 120;
    Position.X := 380;
    Position.Y := 110;
    Parent := frmAdmin;
    TextSettings.Font.Size := 14;
    StyledSettings := StyledSettings - [TStyledSetting.Size] ;
    OnClick := btnAddAccClick;
    Cursor := crHandPoint;
    BringToFront;
    Visible := False;
    end;

  with btnDeleteAcc do
    begin
    Text := 'Delete Account';
    Height := 22;
    Width := 120;
    Position.X := 524;
    Position.Y := 110;
    Parent := frmAdmin;
    TextSettings.Font.Size := 14;
    StyledSettings := StyledSettings - [TStyledSetting.Size] ;
    OnClick := btnDeleteAccClick;
    Cursor := crHandPoint;
    BringToFront;
    Visible := False;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Panel Details

  with pnlDash do
    begin
    Height := 33;
    Width := 161;
    Position.X := 8;
    Position.Y := 8;
    Parent := frmAdmin;
    BringToFront;
    Opacity := 0;
    OnClick := DashClick;
    end;

 with pnlDono do
    begin
    Height := 33;
    Width := 161;
    Position.X := 8;
    Position.Y := 64;
    Parent := frmAdmin;
    BringToFront;
    Opacity := 0;
    OnClick := DonoClick;
    end;

  with pnlGiveaway do
    begin
    Height := 33;
    Width := 161;
    Position.X := 8;
    Position.Y := 120;
    Parent := frmAdmin;
    BringToFront;
    Opacity := 0;
    Onclick := GiveawayClick;
    end;

  with pnlLogins do
    begin
    Height := 33;
    Width := 161;
    Position.X := 8;
    Position.Y := 176;
    Parent := frmAdmin;
    BringToFront;
    Opacity := 0;
    OnClick := LoginClick;
    end;

  with pnlLogOut do
    begin
    Height := 49;
    Width := 49;
    Position.X := 0;
    Position.Y := 560;
    Parent := frmAdmin;
    BringToFront;
    Visible := True;
    OnClick := LogoutClick;
    Opacity := 0;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Dynamic Label Details

  with lblDate do
    begin
    Text := 'The date today is ' + DateToStr(Now());
    Height := 25;
    Width := 240;
    Position.X := 196;
    Position.Y := 150;
    Parent := frmAdmin;
    TextSettings.Font.Size := 16;
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor];
    FontColor := TAlphaColors.White;
    Visible := False;
    end;

  with lblEmail do
    begin
    Height := 50;
    Width := 400;
    Position.X := 196;
    Position.Y := 195;
    Parent := frmAdmin;
    TextSettings.Font.Size := 16;
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor];
    FontColor := TAlphaColors.White;
    Visible := False;
    end;

  with lblPass do
    begin
    Height := 50;
    Width := 400;
    Position.X := 196;
    Position.Y := 250;
    Parent := frmAdmin;
    TextSettings.Font.Size := 16;
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor];
    FontColor := TAlphaColors.White;
    Visible := False;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Donation Labels Details

  with lblDCount do
    begin
    Height := 35;
    Width := 45;
    Text := '00';
    Position.X := 288;
    Position.Y := 48;
    Parent := frmAdmin;
    TextSettings.Font.Size := 24;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.Lime;
    Visible := False;
    BringToFront;
    end;

  with lblDHighest do
    begin
    Height := 35;
    Width := 100;
    Text := '00';
    Position.X := 410;
    Position.Y := 48;
    Parent := frmAdmin;
    TextSettings.Font.Size := 24;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.Lime;
    Visible := False;
    BringToFront;
    end;

  with lblDAverage do
    begin
    Height := 35;
    Width := 100;
    Text := '00';
    Position.X := 560;
    Position.Y := 48;
    Parent := frmAdmin;
    TextSettings.Font.Size := 24;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.Lime;
    Visible := False;
    BringToFront;
    end;

  with lblDTotal do
    begin
    Height := 35;
    Width := 100;
    Text := '00';
    Position.X := 695;
    Position.Y := 48;
    Parent := frmAdmin;
    TextSettings.Font.Size := 24;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.Lime;
    Visible := False;
    BringToFront;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Giveaway Labels Details

     with lblEntries do
    begin
    Height := 35;
    Width := 100;
    Text := '00';
    Position.X := 351;
    Position.Y := 54;
    Parent := frmAdmin;
    TextSettings.Font.Size := 24;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.Cyan;
    Visible := False;
    BringToFront;
    end;

  with lblEToday do
    begin
    Height := 35;
    Width := 100;
    Text := '00';
    Position.X := 498;
    Position.Y := 54;
    Parent := frmAdmin;
    TextSettings.Font.Size := 24;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.Cyan;
    Visible := False;
    BringToFront;
    end;

  with lblChance do
    begin
    Height := 35;
    Width := 100;
    Text := '00';
    Position.X := 645;
    Position.Y := 54;
    Parent := frmAdmin;
    TextSettings.Font.Size := 24;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.Cyan;
    Visible := False;
    BringToFront;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Donation Memo Details

  with memDono do
    begin
    Height := 569;
    Width := 640;
    Position.X := 228;
    Position.Y := 140;
    Parent := frmAdmin;
    TextSettings.Font.Size := 16;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.White;
    Visible := False;
    StyleLookup := 'transparentedit';
    SendToBack;
    ReadOnly := True;
    end;

  ////////////////////////////////////////////////////////////////////////////////

                      //Account Labels Details

  with lblAccTotal do
    begin
    Height := 35;
    Width := 100;
    Text := '00';
    Position.X := 424;
    Position.Y := 46;
    Parent := frmAdmin;
    TextSettings.Font.Size := 24;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.Thistle;
    Visible := False;
    BringToFront;
    end;

   with lblAccToday do
    begin
    Height := 35;
    Width := 100;
    Text := '00';
    Position.X := 570;
    Position.Y := 46;
    Parent := frmAdmin;
    TextSettings.Font.Size := 24;
    TextSettings.Font.Family := 'Tw Cen MT';
    StyledSettings := StyledSettings - [TStyledSetting.Size] - [TStyledSetting.FontColor] - [TStyledSetting.Style];
    FontColor := TAlphaColors.Thistle;
    Visible := False;
    BringToFront;
    end;

end;

procedure TfrmAdmin.FormShow(Sender: TObject);
begin
  lblEmail.Text := 'Your email is: ' +frmLogin.sAdminName;
  lblPass.Text  := 'Your password is: ' + frmLogin.sAdminPass;
  frmLogin.Hide;
end;

procedure TfrmAdmin.GiveawayClick(Sender: TObject);               //When Giveaway is clicked
Var
  iEntriesToday: Integer;
  sLine, sDate : String;
  rChance : Real;
begin
  imgDash.Visible := False;
  lblDate.Visible := False;
  lblEmail.Visible := False;
  lblPass.Visible := False;
  btnRestoreDB.Visible := False;
  btnSearchName.Visible := False;
  lblDCount.Visible := False;
  lblDHighest.Visible := False;
  lblDAverage.Visible := False;
  lblDTotal.Visible := False;
  imgDNBanner.Visible := False;
  memDono.Lines.Clear;
  memDono.Visible := True;
  imgGBanner.Visible := True;
  btnFindSurname.Visible := False;
  btnAddAccount.Visible := False;
  btnDeleteAcc.Visible := False;
  lblEntries.Visible := True;
  lblEToday.Visible := True;
  lblChance.Visible := True;
  btnSortPayments.Visible := False;
  iEntriesToday := 0;
  iTotalEntries := 0;
  iEntriesToday := 0;
  rChance := 0;

  imgAccBanner.Visible := False;
  lblAccToday.Visible := False;
  lblAccTotal.Visible := False;
  btnChooseWinner.Visible := True;
  dtpDate.Date := Date;
  dtpDate.Time := Time;
  sDate := DateToStr(dtpDate.Date);

  with DataBase_U.frmDatabase do                 //Finding total amount of Donations and Amount
   begin
     adoGiveaway.Open;
     adoGiveaway.First;

     while not adoGiveaway.Eof do
       begin
         sLine :=  adoGiveaway.FieldByName('Name').AsString + #9 + adoGiveaway.FieldByName('Surname').AsString + #9 +
         adoGiveaway.FieldByName('ID Number').AsString + #9 + adoGiveaway.FieldByName('Phone Number').AsString + #9
         + adoGiveaway.FieldByName('Date').AsString + #9 + adoGiveaway.FieldByName('Code').AsString;

         memDono.Lines.Add(sLine);
         inc(iTotalEntries);
         adoGiveaway.Next;
       end;
   adoGiveaway.Close;
   end;


  with DataBase_U.frmDatabase do                              //Finding Daily spectators
   begin
     adoGiveaway.Open;
     adoGiveaway.First;
     while not adoGiveaway.Eof do
       begin
         if adoGiveaway.FieldByName('Date').AsString = sDate then
            inc(iEntriesToday);
         adoGiveaway.Next;
       end;
   end;



  rChance := (1/iTotalEntries)*100;

  lblEntries.Text := IntToStr(iTotalEntries);
  lblEToday.Text := IntToStr(iEntriesToday);
  lblChance.Text := FloatToStrF(rChance, ffFixed, 8,2);

end;

procedure TfrmAdmin.LoginClick(Sender: TObject);                  //When Logins is clicked
Var sLine, sDate : String;
    iTotalAcc, iAccToday : Integer;
begin
  imgDash.Visible := False;
  lblDate.Visible := False;
  lblEmail.Visible := False;
  lblPass.Visible := False;
  btnSearchName.Visible := False;
  btnFindSurname.Visible := False;
  btnRestoreDB.Visible := False;
  lblDCount.Visible := False;
  lblDHighest.Visible := False;
  lblDAverage.Visible := False;
  lblDTotal.Visible := False;
  imgDNBanner.Visible := False;
  memDono.Lines.Clear;
  memDono.Visible := True;;
  imgGBanner.Visible := False;
  btnSortPayments.Visible := False;
  btnDeleteAcc.Visible := True;
  btnAddAccount.Visible := True;
  lblEntries.Visible := False;
  lblEToday.Visible := False;
  lblChance.Visible := False;
  btnChooseWinner.Visible := False;
  imgAccBanner.Visible := True;
  lblAccToday.Visible := True;
  lblAccTotal.Visible := True;
  btnDeleteAcc.Visible := True;
  dtpDate.Date := Date;
  dtpDate.Time := Time;
  sDate := DateToStr(dtpDate.Date);

  iAccToday := 0;
  iTotalAcc := 0;

  with DataBase_U.frmDatabase do                 //Finding total amount of Donations and Amount
   begin
     adoLogin.Open;
     adoLogin.First;

     while not adoLogin.Eof do
       begin
         sLine :=  adoLogin.FieldByName('Name').AsString + #9 + adoLogin.FieldByName('Surname').AsString + #9 +
         adoLogin.FieldByName('Email').AsString + #9 + adoLogin.FieldByName('Date').AsString;

         memDono.Lines.Add(sLine);
         inc(iTotalAcc);
         adoLogin.Next;
       end;
   adoLogin.Close;
     end;


  with DataBase_U.frmDatabase do                              //Finding Daily spectators
   begin
     adoLogin.Open;
     adoLogin.First;
     while not adoLogin.Eof do
       begin
         if adoLogin.FieldByName('Date').AsString = sDate then
            inc(iAccToday);
         adoLogin.Next;
       end;

   end;

  lblAccTotal.Text := IntToStr(iTotalAcc);
  lblAccToday.Text := IntToStr(iAccToday);

end;


procedure TfrmAdmin.LogoutClick(sender: TObject);
begin
  frmSignup.Show;
  frmAdmin.Close;

end;

end.
