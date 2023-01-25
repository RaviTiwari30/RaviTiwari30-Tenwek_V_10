using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
public partial class Design_Mortuary_CorpseBillPrint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblCorpseID.Text = Request.QueryString["CorpseID"].ToString();
            lblTransactionID.Text = Request.QueryString["TransactionID"].ToString();
            //LoadReceipt();
        }
    }

    //private void LoadReceipt()
    //{
    //    DataTable dtReceipt = new DataTable();
    //    AllQuery AQ = new AllQuery();
    //    dtReceipt = AQ.GetMortuaryReceipt(lblTransactionID.Text).Copy();

    //    if (dtReceipt != null && dtReceipt.Rows.Count > 0)
    //    {
    //        grdReceipt.DataSource = dtReceipt;
    //        grdReceipt.DataBind();

    //    }
    //    else if (dtReceipt != null && dtReceipt.Rows.Count == 0)
    //    {
    //        DataRow dr1 = dtReceipt.NewRow();
    //        dr1[0] = "";
    //        dr1[1] = "0";
    //        dr1[2] = "";
    //        dr1[3] = "";
    //        dr1[4] = "";
    //        dr1[5] = "";
    //        dtReceipt.Rows.Add(dr1);

    //        grdReceipt.DataSource = dtReceipt;
    //        grdReceipt.DataBind();

    //    }
    //    ViewState["dtReceipt"] = dtReceipt;

    //}

}
