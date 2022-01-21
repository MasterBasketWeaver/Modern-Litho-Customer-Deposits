tableextension 50204 "BBC MLCD G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(50200; "BBC MLCD Customer Deposit"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Deposit';
            Editable = false;
        }
        field(50201; "BBC MLCD PrintVis Case No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PrintVis Case No.';
            TableRelation = "PVS Case";
            Editable = false;
        }
    }
}