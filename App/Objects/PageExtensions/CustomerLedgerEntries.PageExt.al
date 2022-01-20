pageextension 50201 "BBC MLCD Cust Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Customer Name")
        {
            field("BBC MLCD Customer Deposit"; Rec."BBC MLCD Customer Deposit")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies if the entry is a Customer Deposit.';
            }
        }
    }
}