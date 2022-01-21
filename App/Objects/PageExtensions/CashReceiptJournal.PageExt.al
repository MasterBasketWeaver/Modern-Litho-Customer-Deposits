pageextension 50202 "BBC MLCD Cash Receipt Jnl." extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Account No.")
        {
            field("BBC MLCD PrintVis Case No."; Rec."BBC MLCD PrintVis Case No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the PrintVis Case the prepayment is applied to.';
            }
        }
    }
}