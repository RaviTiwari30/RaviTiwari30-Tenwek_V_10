using System.Web.UI.WebControls;
/// <summary>
/// Summary description for UserValidation
/// </summary>
public class UserValidation
{
	public UserValidation()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static void LoadPaymentModeByChangeOfPanel(RadioButtonList cbl,string PanelID)
    {
        string CompType = StockReports.ExecuteScalar("Select PaymentMode from f_panel_master where PanelID=" + PanelID + " ");

        if (CompType.ToUpper() == "CREDIT") // User Selected Other then Cash i.e. Credit Panel Comp
        {
            foreach (ListItem li in cbl.Items)
            {
                if (li.Text.ToUpper() == "CASH")
                {
                    li.Selected = false;
                    li.Enabled = false;
                }

                if (li.Text.ToUpper() == "CREDIT-CARD")
                {
                    li.Selected = false;
                    li.Enabled = false;
                }

                if (li.Text.ToUpper() == "CHEQUE/DD")
                {
                    li.Selected = false;
                    li.Enabled = false;
                }

                if (li.Text.ToUpper() == "CHEQUE")
                {
                    li.Selected = false;
                    li.Enabled = false;
                }

                if (li.Text.ToUpper() == "CREDIT")
                {
                    li.Selected = true;
                    li.Enabled = true;
                }
            }
        }
        else if (CompType.ToUpper() == "CASH")
        {
            foreach (ListItem li in cbl.Items)
            {
                if (li.Text.ToUpper() == "CASH")
                {
                    li.Selected = true;
                    li.Enabled = true;
                }
                if (li.Text.ToUpper() == "CREDIT-CARD")
                {
                    li.Selected = false;
                    li.Enabled = true;
                }

                if (li.Text.ToUpper() == "CHEQUE/DD")
                {
                    li.Selected = false;
                    li.Enabled = true;
                }

                if (li.Text.ToUpper() == "CHEQUE")
                {
                    li.Selected = false;
                    li.Enabled = true;
                }

                if (li.Text.ToUpper() == "CREDIT")
                {
                    li.Selected = false;
                    li.Enabled = false;
                }
            }
        }
        else
        {
            foreach (ListItem li in cbl.Items)
            {
                if (li.Text.ToUpper() == "CASH")
                {
                    li.Selected = true;
                    li.Enabled = true;
                }
                if (li.Text.ToUpper() == "CREDIT-CARD")
                {
                    li.Selected = false;
                    li.Enabled = true;
                }

                if (li.Text.ToUpper() == "CHEQUE/DD")
                {
                    li.Selected = false;
                    li.Enabled = true;
                }

                if (li.Text.ToUpper() == "CHEQUE")
                {
                    li.Selected = false;
                    li.Enabled = true;
                }

                if (li.Text.ToUpper() == "CREDIT")
                {
                    li.Selected = false;
                    li.Enabled = true;
                }
            }
        }
    }
}
