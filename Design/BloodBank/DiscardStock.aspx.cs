using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_DiscardStock : System.Web.UI.Page
{
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow gr in grdDiscard.Rows)
        {
            ((CheckBox)gr.FindControl("chkCheck")).Checked = false;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (GridViewRow gr in grdDiscard.Rows)
            {
                if (((CheckBox)gr.FindControl("chkCheck")).Checked)
                {
                    if (((DropDownList)gr.FindControl("ddlReason")).SelectedIndex != 0)
                    {
                        DiscardBlood db = new DiscardBlood();
                        db.Stock_ID = ((Label)gr.FindControl("lblStockID")).Text;
                        db.BloodCollection_ID = ((Label)gr.FindControl("lblBloodCollectionID")).Text; ;
                        db.BagType = ((Label)gr.FindControl("lblBagType")).Text;
                        db.BBTubeNo = ((Label)gr.FindControl("lblBBTubeNo")).Text;
                        db.BloodGroup = ((Label)gr.FindControl("lblBloodGroup")).Text;
                        db.CentreID = Util.GetInt(Session["CentreID"].ToString());
                        db.ComponentName = ((Label)gr.FindControl("lblComponentName")).Text; ;
                        db.EntryBy = Session["ID"].ToString();
                        db.Reason = ((DropDownList)gr.FindControl("ddlReason")).SelectedItem.Text;
                        db.IsDiscarded = 1;
                        string DiscardID = db.Insert();
                        string up = "UPDATE bb_stock_master SET status=0,IsDiscarded=1, DiscardedBy='" + Session["ID"].ToString() + "',DiscardedDate=NOW() where Stock_ID='" + ((Label)gr.FindControl("lblStockID")).Text + "'";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM212','" + lblerrmsg.ClientID + "');", true);

                        return;
                    }
                }
                else
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM213','" + lblerrmsg.ClientID + "');", true);
            }
            Tranx.Commit();
            Search();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblerrmsg.ClientID + "');", true);
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

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtStockId.Focus();
            txtexpiryfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtexpiryTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));

            BloodBank.bindBagType(ddlBagType);
           
        }
        txtexpiryfrom.Attributes.Add("readOnly", "true");
        txtexpiryTo.Attributes.Add("readOnly", "true");
    }

    private void reason()
    {
        DataTable dt1 = StockReports.GetDataTable("Select ID,Reason from bb_Reason_master where IsActive=1");
        for (int i = 0; i < grdDiscard.Rows.Count; i++)
        {
            ((DropDownList)grdDiscard.Rows[i].FindControl("ddlReason")).DataSource = dt1;
            ((DropDownList)grdDiscard.Rows[i].FindControl("ddlReason")).DataTextField = "Reason";
            ((DropDownList)grdDiscard.Rows[i].FindControl("ddlReason")).DataValueField = "ID";
            ((DropDownList)grdDiscard.Rows[i].FindControl("ddlReason")).DataBind();
            ((DropDownList)grdDiscard.Rows[i].FindControl("ddlReason")).Items.Insert(0, "Select");
        }
    }

    private void Search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT id,Stock_Id,BloodCollection_Id,BagType,BBTubeNo,BloodGroup,ComponentName,Date_Format(EntryDate,'%d-%b-%Y')EntryDate,Date_Format(ExpiryDate,'%d-%b-%Y')ExpiryDate from bb_stock_master Where ISDiscarded=0 and Status=1");
            sb.Append(" AND IsHold=0 AND IsDispatch=0 AND (InitialCount-ReleaseCount)>0 AND centreID='"+Session["CentreID"].ToString()+"' ");
            if (txtStockId.Text.Trim() != "")
            {
                sb.Append(" AND Stock_Id='" + txtStockId.Text.Trim() + "' ");
            }
            if (txtBloodCollectionID.Text.Trim() != "")
            {
                sb.Append(" AND BloodCollection_Id='" + txtBloodCollectionID.Text.Trim() + "'");
            }
            if (txtTubeNo.Text.Trim() != "")
            {
                sb.Append(" AND BBTubeNo='" + txtTubeNo.Text.Trim() + "'");
            }
            if (ddlBagType.SelectedIndex != 0)
            {
                sb.Append(" AND BagType='" + ddlBagType.SelectedItem.Text + "'");
            }
            if (txtStockId.Text.Trim() == "" && txtBloodCollectionID.Text.Trim() == "" && txtTubeNo.Text.Trim() == "" && ddlBagType.SelectedIndex == 0)
            {
                if (txtexpiryfrom.Text != "")
                {
                    sb.Append(" AND DATE(ExpiryDate) >='" + Util.GetDateTime(txtexpiryfrom.Text).ToString("yyyy-MM-dd") + "'");
                }

                if (txtexpiryTo.Text != "")
                {
                    sb.Append(" AND  DATE(ExpiryDate) <='" + Util.GetDateTime(txtexpiryTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdDiscard.DataSource = dt;
                grdDiscard.DataBind();
                reason();
                pnlHide.Visible = true;
                pnlHide1.Visible = true;
            }
            else
            {
                pnlHide.Visible = false;
                pnlHide1.Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            grdDiscard.DataSource = null;
            grdDiscard.DataBind();
            pnlHide.Visible = false;
            pnlHide1.Visible = false;
        }
    }
}