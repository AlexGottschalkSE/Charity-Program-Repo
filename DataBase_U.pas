unit DataBase_U;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Data.DB,
  Data.Win.ADODB;

type
  TfrmDatabase = class(TForm)
    dbBluSins: TADOConnection;
    adoLogin: TADOTable;
    adoDonations: TADOTable;
    adoGiveaway: TADOTable;
    qryLogins: TADOQuery;
    dsLogins: TDataSource;
    dsDonations: TDataSource;
    qryDonations: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDatabase: TfrmDatabase;

implementation

{$R *.fmx}


end.
