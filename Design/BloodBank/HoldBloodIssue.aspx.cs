using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_HoldBloodIssue : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
    }

    protected void grdSearchList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (e.CommandName == "AResult")
            {
                int index = Util.GetInt(e.CommandArgument.ToString());
                GridViewRow gr = grdSearchList.Rows[index];
                decimal i = Util.GetDecimal(((Label)gr.FindControl("lblIssuevolumn")).Text.ToString());
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_issue_blood SET IsHold=0, HoldIssueBy='" + Session["ID"].ToString() + "',HoldIssueDate=NOW() where Stock_ID='" + ((Label)gr.FindControl("lblStockID")).Text + "'");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_stock_master SET IsHold=0,Status=0,ReleaseCount=ReleaseCount-'" + Util.GetDecimal(((Label)gr.FindControl("lblIssuevolumn")).Text.ToString()) + "' where Stock_ID='" + Util.GetString(((Label)gr.FindControl("lblStockID")).Text) + "'");
            }
            if (e.CommandName == "AStock")
            {
                int index = Util.GetInt(e.CommandArgument.ToString());
                GridViewRow gr = grdSearchList.Rows[index];
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_issue_blood SET IsHold=0,Isreturn=1, UnHoldBy='" + Session["ID"].ToString() + "',UnHoldDate=NOW() where Stock_ID='" + ((Label)gr.FindControl("lblStockID")).Text + "'");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_stock_master SET IsHold=0,ReleaseCount=ReleaseCount-'" + Util.GetDecimal(((Label)gr.FindControl("lblIssuevolumn")).Text.ToString()) + "' where Stock_ID='" + ((Label)gr.FindControl("lblStockID")).Text + "'");
            }
            Tranx.Commit();
            pnlSearch.Visible = false;
            grdSearchList.DataSource = null;
            grdSearchList.DataBind();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPatientName.Focus();
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
        }
    }

    private void search()
    {
        try
        {
            if (txtIPDNo.Text == "" && txtPatientName.Text == "" && txtRegNo.Text == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM181','" + lblMsg.ClientID + "');", true);
                grdSearchList.DataSource = null;
                grdSearchList.DataBind();
                pnlSearch.Visible = false;
                return;
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ib.PatientID,ib.LedgerTransactionNo,ib.TransactionID,pm.PName,sm.Stock_Id,sm.BagType,sm.BBTubeNo,sm.componentName,sm.InitialCount,sm.ReleaseCount ");
            sb.Append(" FROM bb_issue_blood ib INNER  JOIN bb_stock_master sm ON sm.Stock_id=ib.Stock_ID INNER JOIN patient_master pm");
            sb.Append("  ON pm.PatientID=ib.PatientID INNER JOIN patient_medical_history pmh ON pmh.`PatientID`=pm.`PatientID`  WHERE ib.ishold=1 AND ib.Expiry >=CURDATE() AND sm.ExpiryDate>=CURDATE() AND sm.IsHold=1 and ib.centreID='" + Session["CentreID"].ToString() + "' ");
            if (txtIPDNo.Text != "")
            {
               // sb.Append(" AND TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
                sb.Append(" AND pmh.`TransNo`=" + txtIPDNo.Text.Trim() + " ");
            }

            if (txtRegNo.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtRegNo.Text.Trim() + "' ");
            }

            if (txtPatientName.Text != "")
            {
                sb.Append(" AND pm.pname like '" + txtPatientName.Text.Trim() + "%' ");
            }

            sb.Append(" group by ib.PatientID ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdSearchList.DataSource = dt;
                grdSearchList.DataBind();

                pnlSearch.Visible = true;
                lblMsg.Text = "";
            }
            else
            {
                pnlSearch.Visible = false;
                grdSearchList.DataSource = null;
                grdSearchList.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            pnlSearch.Visible = false;
            grdSearchList.DataSource = null;
            grdSearchList.DataBind();
        }
    }
}