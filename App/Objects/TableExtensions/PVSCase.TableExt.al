tableextension 50200 "BBC MLCD PVS Case" extends "PVS Case"
{
    fields
    {
        field(50200; "BBC MLCD Cust. Ledger Entries"; Integer)
        {
            Caption = 'Customer Deposit Ledger Entries';
            FieldClass = FlowField;
            CalcFormula = count("Cust. Ledger Entry" where("Customer No." = field("Sell-To No."), "BBC MLCD Customer Deposit" = const(true)));
            Editable = false;
        }
    }
}