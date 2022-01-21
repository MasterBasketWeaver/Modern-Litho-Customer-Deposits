tableextension 50203 "BBC MLCD Gen. Journal Batch" extends "Gen. Journal Batch"
{
    fields
    {
        field(50200; "BBC MLCD Cust. Dep. Acc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Deposit Account No.';
            TableRelation = "G/L Account"."No." where(Blocked = const(false));
        }
        field(50201; "BBC MLCD Customer Deposit"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Deposit';
        }
    }
}