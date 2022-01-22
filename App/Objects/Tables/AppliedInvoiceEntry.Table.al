table 50200 "BBC MLCD Applied Invoice Entry"
{
    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Cust. Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Cust. Ledger Entry"."Entry No.";
        }
    }

    keys
    {
        key(PK; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}