pageextension 50206 "BBC MLCD Apply Cust. Entries" extends "Apply Customer Entries"
{
    actions
    {
        addfirst(processing)
        {
            action("BBC MLCD Delete")
            {
                ApplicationArea = all;
                Visible = AllowDelete;
                Enabled = AllowDelete and CanDelete;
                Caption = 'Delete';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Delete;

                trigger OnAction()
                begin
                    if not Confirm('Delete?') or not AppliedInvoiceEntry.FindFirst() then
                        exit;
                    if FilterText.Length() = 0 then
                        FilterText.Append(StrSubstNo('<>%1', AppliedInvoiceEntry."Cust. Ledger Entry No."))
                    else
                        FilterText.Append(StrSubstNo('&<>%1', AppliedInvoiceEntry."Cust. Ledger Entry No."));
                    AppliedInvoiceEntry.Delete(true);
                    CanDelete := false;
                    Rec.FilterGroup(2);
                    Rec.SetFilter("Entry No.", StrSubstNo('%1&%2', InitialFilter, FilterText.ToText()));
                    Rec.FilterGroup(0);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        AppliedInvoiceEntry.SetRange("Document Type", ApplyingCustLedgEntry."Document Type");
        AppliedInvoiceEntry.SetRange("Document No.", ApplyingCustLedgEntry."Document No.");
        InitialFilter := Rec.GetFilter("Entry No.");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        AppliedInvoiceEntry.SetRange("Cust. Ledger Entry No.", Rec."Entry No.");
        CanDelete := not AppliedInvoiceEntry.IsEmpty();
    end;

    procedure SetAllowDelete()
    begin
        AllowDelete := true;
    end;

    var
        [InDataSet]
        AllowDelete: Boolean;
        [InDataSet]
        CanDelete: Boolean;
        AppliedInvoiceEntry: Record "BBC MLCD Applied Invoice Entry";
        FilterText: TextBuilder;
        InitialFilter: Text;
}