using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
public partial class Design_IPD_Vieworderset : System.Web.UI.Page
{
    string TID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        TID = Request.QueryString["TransactionID"].ToString();
        ViewState["transid"] = TID.ToString();

        if (!IsPostBack)
        {
            SearchReport(TID);
        }
    }

    private void SearchReport(string TID)
    {

        string TransactionID = TID;
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pmh.TransactionID,DATE_FORMAT(nod.createddate,'%d-%b-%Y')createddate,nod.groups as Groups,pmh.DoctorID,dm.name as Doctor_name,nod.GroupID,nod.relationalid");
        sb.Append(" FROM nursing_orderset_details nod INNER JOIN patient_medical_history pmh ON nod.TransactionID=pmh.TransactionID ");
        sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID inner join nursing_orderset_master nos ON nos.GroupID=nod.GroupID");
        sb.Append("    WHERE pmh.TransactionID='" + TransactionID + "' and ISOrderSet=1");
        sb.Append("  group BY nod.relationalid");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
        else
        {
            GridView1.DataSource = null;
            GridView1.DataBind();
        }

    }
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "editemp")
        {
           
            string TID = e.CommandArgument.ToString().Split('#')[0];
            int GroupID = Convert.ToInt32(e.CommandArgument.ToString().Split('#')[1]);
            int RelationalID = Convert.ToInt32(e.CommandArgument.ToString().Split('#')[2]);
            Response.Redirect("../../Design/IPD/NursingOrderSet.aspx?TransactionID=" + TID + "&GroupID=" + GroupID + "&RelationalID=" + RelationalID + "");

        }
        if (e.CommandName == "view")
        {

            string TID = e.CommandArgument.ToString().Split('#')[0];
            string GroupID = e.CommandArgument.ToString().Split('#')[1];
            string RelationalID = e.CommandArgument.ToString().Split('#')[2];
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/IPD/NursingOrderSetPrintOut.aspx?TID=" + TID + "&GroupID=" + GroupID + "&RelationalID=" + RelationalID + "');", true);

        }
    }
}

