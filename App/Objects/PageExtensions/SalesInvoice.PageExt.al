pageextension 50205 "BBC MLCD Sales Invoice" extends "Sales Invoice"
{


    actions
    {
        addlast("F&unctions")
        {
            action("BBC MLCD Apply Deposits")
            {
                ApplicationArea = All;
                Caption = 'Apply Deposits';
                Image = ApplyEntries;
                Promoted = false;

                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                    GenJnlApply: Codeunit "Gen. Jnl.-Apply";
                    ApplyCustEntries: Page "Apply Customer Entries";

                // c1: Codeunit "CustEntry-Apply Posted Entries"
                begin
                    Rec.CalcFields(Amount);
                    Rec.TestField("Bal. Account No.", '');
                    CustLedgEntry.SetApplyToFilters(Rec."Bill-to Customer No.", Rec."Applies-to Doc. Type".AsInteger(), Rec."Applies-to Doc. No.", Rec.Amount);
                    ApplyCustEntries.SetSales(Rec, CustLedgEntry, Rec.FieldNo("Applies-to Doc. No."));
                    ApplyCustEntries.SetTableView(CustLedgEntry);
                    ApplyCustEntries.SetRecord(CustLedgEntry);
                    ApplyCustEntries.LookupMode(true);
                    if ApplyCustEntries.RunModal <> Action::LookupOK then
                        exit;
                    ApplyCustEntries.GetCustLedgEntry(CustLedgEntry);
                    GenJnlApply.CheckAgainstApplnCurrency(Rec."Currency Code", CustLedgEntry."Currency Code", GenJnlLine."Account Type"::Customer, true);
                    InsertInvoiceEntry(CustLedgEntry."Entry No.");
                    // Rec."Applies-to Doc. Type" := CustLedgEntry."Document Type";
                    // Rec."Applies-to Doc. No." := CustLedgEntry."Document No.";
                    // Rec.Validate("Applies-to ID", Rec."No.");
                end;
            }

        }
        addlast(navigation)
        {
            action("BBC MLCD View Applied Deposits")
            {
                ApplicationArea = All;
                Caption = 'View Applied Deposits';
                Image = ApplicationWorksheet;
                Promoted = false;

                trigger OnAction()
                var
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                    AppliedInvoiceEntry: Record "BBC MLCD Applied Invoice Entry";
                    ApplyCustEntries: Page "Apply Customer Entries";
                    FilterText: TextBuilder;
                begin
                    AppliedInvoiceEntry.SetRange("Document Type", Rec."Document Type");
                    AppliedInvoiceEntry.SetRange("Document No.", Rec."No.");
                    if AppliedInvoiceEntry.FindSet() then
                        repeat
                            if CustLedgerEntry.Get(AppliedInvoiceEntry."Cust. Ledger Entry No.") then
                                if FilterText.Length() = 0 then
                                    FilterText.Append(Format(CustLedgerEntry."Entry No."))
                                else
                                    FilterText.Append(StrSubstNo('|%1', CustLedgerEntry."Entry No."));
                        until AppliedInvoiceEntry.Next() = 0;

                    CustLedgerEntry.SetFilter("Entry No.", FilterText.ToText());
                    ApplyCustEntries.SetSales(Rec, CustLedgerEntry, Rec.FieldNo("Applies-to Doc. No."));
                    ApplyCustEntries.SetTableView(CustLedgerEntry);
                    ApplyCustEntries.SetRecord(CustLedgerEntry);
                    ApplyCustEntries.Caption('Applied Invoice Entries');
                    ApplyCustEntries.Editable(false);
                    ApplyCustEntries.SetAllowDelete();
                    ApplyCustEntries.RunModal();
                end;
            }
        }
    }


    local procedure InsertInvoiceEntry(CustLedgerEntryNo: Integer)
    var
        AppliedInvoiceEntry: Record "BBC MLCD Applied Invoice Entry";
        LineNo: Integer;
    begin
        AppliedInvoiceEntry.SetRange("Document Type", Rec."Document Type");
        AppliedInvoiceEntry.SetRange("Document No.", Rec."No.");
        if AppliedInvoiceEntry.FindLast() then
            LineNo := AppliedInvoiceEntry."Line No.";
        AppliedInvoiceEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntryNo);
        if not AppliedInvoiceEntry.IsEmpty() then
            Error('Already applied Entry %1', CustLedgerEntryNo);

        AppliedInvoiceEntry.Init();
        AppliedInvoiceEntry."Document Type" := Rec."Document Type";
        AppliedInvoiceEntry."Document No." := Rec."No.";
        AppliedInvoiceEntry."Line No." := LineNo + 10000;
        AppliedInvoiceEntry."Cust. Ledger Entry No." := CustLedgerEntryNo;
        AppliedInvoiceEntry.Insert(true);
    end;
}