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
}