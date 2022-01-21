pageextension 50204 "BBC MLCD Gen. Ledger Entries" extends "General Ledger Entries"
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
            field("BBC MLCD Customer Deposit"; Rec."BBC MLCD Customer Deposit")
            {
                ApplicationArea = all;
            }
            field("BBC MLCD PrintVis Case No."; Rec."BBC MLCD PrintVis Case No.")
            {
                ApplicationArea = all;
            }
        }
    }
}