using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Mortuary_Mortuary_PostMortemResult : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblTransactionID.Text = Request.QueryString["TransactionID"].ToString();

            //AllQuery AQ = new AllQuery();
            //DataTable dtDischarge = AQ.GetCorpseReleasedStatus(lblTransactionID.Text);
            //if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            //{
            //    string Msg = "Corpse is Already Released on " + dtDischarge.Rows[0]["ReleasedDateTime"].ToString() + " . No Services can be possible...";
            //    Response.Redirect("../Mortuary/CorpseBillMsg.aspx?msg=" + Msg);
            //}
        }
    }
}