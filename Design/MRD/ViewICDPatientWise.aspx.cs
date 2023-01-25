using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_ViewICDPatientWise : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            if (Request.QueryString["TID"] != null)
            {
                string TID = Request.QueryString["TID"].ToString();
                //if (TID.Contains("SHHI") == false)
                //    TID = "ISHHI" + TID;
                ViewState["TID"] = TID.ToString();
                BindPatient(ViewState["TID"].ToString());
            }

        }

    }
    private void BindPatient(string TID)
        {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT REPLACE(icdp.TransactionID,'ISHHI','')'IPDNo',TransactionID,Group_Code,Group_Desc, ");
        sb.Append(" ICD10_3_Code, ICD10_3_Code_Desc,ICD10_Code, WHO_Full_Desc,icd_id,icdp.ID   ");
        sb.Append(" FROM icd_10cm_patient icdp INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID where icdp.IsActive=1");
        sb.Append(" AND icd.Isactive=1 AND icdp.TransactionID='" + TID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            grvICDCode.DataSource = dt;
            grvICDCode.DataBind();
        }
        else
        {
            grvICDCode.DataSource = null;
            grvICDCode.DataBind();

        }
    }
    protected void grdDig_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            string IPD = Util.GetString(e.CommandArgument).Split('#')[0];
            string args = Util.GetString(e.CommandArgument).Split('#')[2];
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();

            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            int RowsUpdated = 0;

            try
            {
                string sql = "Update icd_10cm_patient set  IsActive=0 where id=" + args + "  and TransactionID='"+IPD.ToString()+"' ";
                RowsUpdated = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sql);
                Tranx.Commit();
                BindPatient(ViewState["TID"].ToString());
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);

            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }


    }
}
