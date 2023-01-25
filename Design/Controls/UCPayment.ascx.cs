using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Controls_UCPayment : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        spnControlMaxEligibleDiscountPercent.InnerText = Util.round(All_LoadData.GetEligiableDiscountPercent(Session["ID"].ToString())).ToString();
    }
}