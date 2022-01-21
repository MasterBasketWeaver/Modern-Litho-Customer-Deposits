tableextension 50202 "BBC MLCD Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50200; "BBC MLCD PrintVis Case No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PrintVis Case No.';
            TableRelation = "PVS Case";
        }
    }
}