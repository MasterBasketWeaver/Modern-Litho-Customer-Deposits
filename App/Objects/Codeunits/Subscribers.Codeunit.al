codeunit 50200 "BBC MLCD Subscribers"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure GenJnlPostLineOnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        if GenJnlBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then
            CustLedgerEntry."BBC MLCD Customer Deposit" := GenJnlBatch."BBC MLCD Customer Deposit";
        CustLedgerEntry."BBC MLCD PrintVis Case No." := GenJournalLine."BBC MLCD PrintVis Case No.";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterGetCustomerReceivablesAccount', '', false, false)]
    local procedure GenJnlPostLineGetCustomerReceivablesAccount(var ReceivablesAccount: Code[20]; GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        if GenJnlBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") and GenJnlBatch."BBC MLCD Customer Deposit"
                and (GenJnlBatch."BBC MLCD Cust. Dep. Acc. No." <> '') then
            ReceivablesAccount := GenJnlBatch."BBC MLCD Cust. Dep. Acc. No.";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostCustOnAfterInitCustLedgEntry', '', false, false)]
    local procedure GenJnlPostLineOnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        if GenJnlBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name")
                and GenJnlBatch."BBC MLCD Customer Deposit" and (GenJnlBatch."BBC MLCD Cust. Dep. Acc. No." <> '') then begin
            GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
            GenJournalLine.Validate("Bal. Account No.", GenJnlBatch."BBC MLCD Cust. Dep. Acc. No.");
            CustLedgEntry."Dimension Set ID" := GenJournalLine."Dimension Set ID";
            CustLedgEntry."Global Dimension 1 Code" := GenJournalLine."Shortcut Dimension 1 Code";
            CustLedgEntry."Global Dimension 2 Code" := GenJournalLine."Shortcut Dimension 2 Code";
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlEntry', '', false, false)]
    local procedure GenJnlPostLineOnBeforeInsertGlEntry(var GLEntry: Record "G/L Entry"; var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        if GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then
            GLEntry."BBC MLCD Customer Deposit" := GenJnlBatch."BBC MLCD Customer Deposit";
        GLEntry."BBC MLCD PrintVis Case No." := GenJnlLine."BBC MLCD PrintVis Case No.";
    end;









    // [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo', '', false, false)]
    // local procedure GenJnlLineOnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo(var GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry")
    // var
    //     SalesHeader: Record "Sales Header";
    //     AppliedInvoiceEntry: Record "BBC MLCD Applied Invoice Entry";
    //     LineNo: Integer;
    // begin
    //     if not GenJournalLine."BBC MLCD Applied Invoice" or not SalesHeader.Get(GenJournalLine."BBC MLCD Source RecID") then
    //         exit;
    //     AppliedInvoiceEntry.SetRange("Document Type", SalesHeader."Document Type");
    //     AppliedInvoiceEntry.SetRange("Document No.", SalesHeader."No.");
    //     if AppliedInvoiceEntry.FindLast() then
    //         LineNo := AppliedInvoiceEntry."Line No.";
    //     AppliedInvoiceEntry.Init();
    //     AppliedInvoiceEntry."Document Type" := SalesHeader."Document Type";
    //     AppliedInvoiceEntry."Document No." := SalesHeader."No.";
    //     AppliedInvoiceEntry."Line No." := LineNo + 10000;
    //     AppliedInvoiceEntry."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
    //     AppliedInvoiceEntry.Insert(true);
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure SalesHeaderOnAfterDelete(var Rec: Record "Sales Header")
    var
        AppliedInvoiceEntry: Record "BBC MLCD Applied Invoice Entry";
    begin
        if Rec.IsTemporary() then
            exit;
        AppliedInvoiceEntry.SetRange("Document Type", Rec."Document Type");
        AppliedInvoiceEntry.SetRange("Document No.", Rec."No.");
        AppliedInvoiceEntry.DeleteAll(true);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', false, false)]
    local procedure SalesPostOnAfterPostSalesLines(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        AppliedInvoiceEntry: Record "BBC MLCD Applied Invoice Entry";
        CustEntryApply: Codeunit "CustEntry-Apply Posted Entries";
    begin
        if not SalesHeader.Invoice or (SalesInvoiceHeader."No." = '') then
            exit;
        AppliedInvoiceEntry.SetRange("Document Type", SalesHeader."Document Type");
        AppliedInvoiceEntry.SetRange("Document No.", SalesHeader."No.");
        if not AppliedInvoiceEntry.FindSet() then
            exit;
        repeat
            CustLedgerEntry.Get(AppliedInvoiceEntry."Cust. Ledger Entry No.");
            CustEntryApply.Apply(CustLedgerEntry, SalesInvoiceHeader."No.", SalesInvoiceHeader."Posting Date");
        until AppliedInvoiceEntry.Next() = 0;
    end;

}