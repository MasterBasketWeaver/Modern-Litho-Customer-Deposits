pageextension 50203 "BBC MLCD Gen. Journal Batches" extends "General Journal Batches"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("BBC MLCD Cust. Dep. Acc. No."; Rec."BBC MLCD Cust. Dep. Acc. No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Account No. to be used when posting for Customer Deposits. Only applies when the Customer Deposit field for the batch is true.';
            }
        }
        addlast(Control1)
        {
            field("BBC MLCD Customer Deposit"; Rec."BBC MLCD Customer Deposit")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies if the batch is a Customer Deposit and should use the Customer Deposit Account No. when posting.';
            }
        }
    }
}