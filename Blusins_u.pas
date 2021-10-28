unit Blusins_u;

interface
uses
  SysUtils, DateUtils;

type
  TBluSins = class(TObject)
  private
    { Private declarations }
    fName: String;
    fSurname : String;
    fEmail : String;
    fPassword : String;

  public
    { Public declarations }
    constructor Create(sName, sEmail, sPassword : String);
    function getName : String;
    function getSurname : String;
  end;


implementation

{ TBluSins }

constructor TBluSins.Create(sName, sEmail, sPassword: String);
begin
  fName := sName;
  fEmail := sEmail;
  fPassword := sPassword;
end;


function TBluSins.getName: String;
Var iPos : Integer;
    sFirstName : String;
begin
  iPos := POS(' ', fName);
  sFirstName := Copy(fName, 1, iPos - 1);
  Result := sFirstName;
end;

function TBluSins.getSurname: String;
Var iPos : Integer;
    sFullname, sSurname : String;
begin
  iPos := POS(' ', fName);
  Delete(fName, 1, iPos);
  sSurname := fName;

  Result := sSurname;
end;


end.
