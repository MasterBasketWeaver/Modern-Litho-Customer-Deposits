tableextension 50201 "BBC MLCD Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50200; "BBC MLCD Customer Deposit"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Deposit';
            Editable = false;
        }
    }
}