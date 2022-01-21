pageextension 50201 "BBC MLCD Cust. Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        modify("Entry No.")
        {
            ApplicationArea = all;
            Visible = false;
        }
        addfirst(Control1)
        {
            field("Entry No.2"; Rec."Entry No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Customer Name")
        {
            field("BBC MLCD Customer Deposit"; Rec."BBC MLCD Customer Deposit")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies if the entry is a Customer Deposit.';
            }
            field("BBC MLCD PrintVis Case No."; Rec."BBC MLCD PrintVis Case No.")
            {
                ApplicationArea = all;
            }
        }
    }
}