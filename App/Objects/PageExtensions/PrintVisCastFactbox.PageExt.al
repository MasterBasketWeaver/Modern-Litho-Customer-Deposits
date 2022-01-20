pageextension 50200 "BBC MLCD PrintVis Factbox" extends "PVS Case Card Case Info FB"
{
    layout
    {
        addlast(content)
        {
            field("BBC MLCD Cust. Ledger Entries"; Rec."BBC MLCD Cust. Ledger Entries")
            {
                ApplicationArea = all;
                ToolTip = 'Shows the total amount of Customer Deposits posted to the Customer.';
            }
        }
    }
}