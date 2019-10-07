unit uInvcTendersPlugin;

interface

uses
  RProAPI, RDA2_TLB;

type
  TShowInvoiceTenders = class(TSideButton)
  private
    FRdaDoc: IRdaDocument;
    FRProApp: TRProApp;
  public
    procedure Initialize(RProApp: TRProApp; Doc: IRdaDocument); override;
    class function Menu: TSideMenu; override;
    class function Caption: string; override;
    class function PictureFileName: string; override;
    function Enabled: boolean; override;
    function Execute: TActionRequestSet; override;
  end;


implementation

uses
  {$IFDEF UseCodeSite} CodeSiteLogging, {$ENDIF}
  SysUtils, Classes, Dialogs;


procedure RProClassesAvailable(RProClassArrayProc: TRProClassArrayProc);
begin
  RProClassArrayProc([TShowInvoiceTenders]);
end;

exports
  RProClassesAvailable;

{ TShowInvoiceTenders }

procedure TShowInvoiceTenders.Initialize(RProApp: TRProApp; Doc: IRdaDocument);
begin
  FRdaDoc := Doc;
  FRProApp := RProApp;
end;

class function TShowInvoiceTenders.Menu: TSideMenu;
begin
  Result := smTender;
end;

class function TShowInvoiceTenders.Caption: string;
begin
  Result := 'Show Tenders';
end;

class function TShowInvoiceTenders.PictureFileName: string;
begin
  Result := EmptyStr;
end;

function TShowInvoiceTenders.Enabled: boolean;
begin
  // called frequently by RetailPro
  Result := True;
end;

function TShowInvoiceTenders.Execute: TActionRequestSet;
var
  i: Integer;
  RecTenders: IRdaTender;
  RecTenderItems: IRdaCollection;
  GenericItem: IUnknown;
  RecTenderItem: IRdaTenderItem;
begin
  {$IFDEF UseCodeSite} CodeSite.EnterMethod('TShowInvoiceTenders.Execute');{$ENDIF}

  RecTenders := FRdaDoc.CustomInterface as IRdaTender;
  RecTenderItems := RecTenders.TenderItems;
  for i := 0 to RecTenderItems.length - 1 do begin
    {$IFDEF UseCodeSite} CodeSite.AddSeparator; {$ENDIF}
    GenericItem := RecTenderItems.Item(i);
    RecTenderItem := GenericItem as IRdaTenderItem;
    {$IFDEF UseCodeSite} CodeSite.Send('tender desc', RecTenderItem.Desc); {$ENDIF}
    {$IFDEF UseCodeSite} CodeSite.Send('tender amount', RecTenderItem.Amount); {$ENDIF}
    if RecTenderItem.TenderType = ttCreditCard then begin
      {$IFDEF UseCodeSite} CodeSite.Send('cc type',     (RecTenderItem as IRdaCreditCard).CardType); {$ENDIF}
      {$IFDEF UseCodeSite} CodeSite.Send('cc num',      (RecTenderItem as IRdaCreditCard).CardNumber); {$ENDIF}
      {$IFDEF UseCodeSite} CodeSite.Send('cc exp mon',  (RecTenderItem as IRdaCreditCard).ExpMonth); {$ENDIF}
      {$IFDEF UseCodeSite} CodeSite.Send('cc exp year', (RecTenderItem as IRdaCreditCard).ExpYear); {$ENDIF}
      {$IFDEF UseCodeSite} CodeSite.Send('cc auth',     (RecTenderItem as IRdaCreditCard).AuthorizationNum); {$ENDIF}
      {$IFDEF UseCodeSite} CodeSite.Send('cc ref num',  (RecTenderItem as IRdaCreditCard).ReferenceNum); {$ENDIF}
      {$IFDEF UseCodeSite} CodeSite.Send('cc ctrl num', (RecTenderItem as IRdaCreditCard).ControlNum); {$ENDIF}
    end;
  end;

  ShowMessage('Tender info sent to CodeSite');

  Result := [];

  {$IFDEF UseCodeSite} CodeSite.ExitMethod('TShowInvoiceTenders.Execute'); {$ENDIF}
end;

end.

