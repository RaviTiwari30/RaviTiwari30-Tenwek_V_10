using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_StockPost : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string StockID = "";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StockInsert si = new StockInsert(Tranx);
            for (int i = 0; i < grvCom.Rows.Count; i++)
            {
                si.BloodCollection_Id = lblBloodCollectionId1.Text;
                si.BBTubeNo = lblTubeNo1.Text;
                si.BagType = lblbagType1.Text;
                si.BloodGroup = lblBloodTested1.Text;
                si.ComponentID = Util.GetInt(((Label)grvCom.Rows[i].FindControl("lblComponentID2")).Text);
                si.InitialCount = Util.GetDecimal(((Label)grvCom.Rows[i].FindControl("lblVolumn2")).Text);
                si.ExpiryDate = Util.GetDateTime(((Label)grvCom.Rows[i].FindControl("lblExpiryDate2")).Text);
                si.CentreId = Util.GetInt((Session["CentreID"]).ToString());
                si.CreatedBy = Session["ID"].ToString();
                si.IsComponent = 1;
                si.status = 1;
                si.IsDiscarded = 0;
                si.EntryDate = Util.GetDateTime(System.DateTime.Now.ToString());
                si.ComponentName = ((Label)grvCom.Rows[i].FindControl("lblComponentName")).Text;
                StockID = si.Insert();
            }
            string up = "UPDATE bb_visitors_history SET IsTested=1 WHERE BloodCollection_Id='" + lblBloodCollectionId1.Text + "' and Visitor_Id='" + lblDonorID1.Text + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up);
            Tranx.Commit();
           

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Stock Created Successfully...Stock ID: " + StockID + "');", true);
            txtCollectionId.Text = "";
            txtDonationId.Text = "";
            search();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblerrmsg.ClientID + "');", true);
            
            Tranx.Rollback();
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
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
        search();
    }

    protected void grdGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ASelect")
        {
            int index = Util.GetInt(e.CommandArgument);
            string[] s = ((Label)grdStock.Rows[index].FindControl("lblrecord")).Text.Split('#');
            lblName1.Text = ((Label)grdStock.Rows[index].FindControl("lblName")).Text;
            lblDonorID1.Text = ((Label)grdStock.Rows[index].FindControl("lblDonorID1")).Text;
            lblBloodCollectionId1.Text = ((Label)grdStock.Rows[index].FindControl("lblCollectionID")).Text;
            lblbagType1.Text = ((Label)grdStock.Rows[index].FindControl("lblBagType")).Text;
            lblTubeNo1.Text = ((Label)grdStock.Rows[index].FindControl("lblBBTubeNo")).Text;
            lblBloodTested1.Text = ((Label)grdStock.Rows[index].FindControl("lblBloodTested")).Text;

            bindGrid();
            if (grvCom.Rows.Count > 0)
            {
                mpeCreateGroup.Show();
            }
        }
    }

    protected void grvCom_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Attributes["onmouseover"] = "javascript:SetMouseOver(this)";
            e.Row.Attributes["onmouseout"] = "javascript:SetMouseOut(this)";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtCollectionId.Focus();
            txtcollectionfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtcollectionTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            ViewState["CenterID"] = Util.GetString(Session["CentreID"].ToString());
        }
        txtcollectionfrom.Attributes.Add("readOnly", "true");
        txtcollectionTo.Attributes.Add("readOnly", "true");
    }

    private void bindGrid()
    {
        try
        {
            StringBuilder sb2 = new StringBuilder();
            sb2.Append("    SELECT bc.Component_ID, bcm.ComponentName,bcm.AliasName,bc.volumn,bc.BagType,DATE_FORMAT(bc.ExpiryDate,'%d-%b-%Y')ExpiryDate FROM  bb_visitors_history bvh   ");
            sb2.Append("     INNER JOIN bb_collection_details bcd ON bcd.Visitor_Id=bvh.Visitor_ID  and bvh.visit_id=bcd.visit_id   INNER JOIN bb_component bc ON bc.BloodCollection_Id=bcd.BloodCollection_Id     ");
            sb2.Append("    INNER JOIN bb_component_master bcm ON bcm.Id=bc.Component_Id             WHERE bvh.IsComponent=3  ");
            sb2.Append("     AND bvh.IsGrouped=3 AND bvh.IsScreened=3 AND bvh.IsTested=0   ");
            sb2.Append(" AND bc.BloodCollection_Id ='" + lblBloodCollectionId1.Text + "'   AND bc.ExpiryDate>=CURDATE()  ");

            sb2.Append(" ORDER BY bc.Component_ID ");
            DataTable dt = StockReports.GetDataTable(sb2.ToString());

            if (dt.Rows.Count > 0)
            {
                grvCom.DataSource = dt;
                grvCom.DataBind();
            }
            else
            {
                grvCom.DataSource = null;
                grvCom.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM228','" + lblerrmsg.ClientID + "');", true);
                return;
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            grdStock.DataSource = null;
            grdStock.DataBind();
            pnlHide.Visible = false;
        }
    }

    private void search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
                       sb.Append("  SELECT bv.Visitor_Id,bcd.BloodCollection_Id,bv.Name,bv.Gender,DATE_FORMAT(bcd.CollectedDate,'%d-%b-%Y')CollectionDate,bvh.BBTubeNo,bvh.BagType,bg.BloodTested ");
            sb.Append("   FROM  bb_visitors bv INNER JOIN bb_visitors_history bvh ON bvh.Visitor_ID=bv.Visitor_ID INNER JOIN bb_collection_details bcd    ON bcd.Visitor_Id=bv.Visitor_ID and bcd.visit_id=bvh.visit_id  ");
            sb.Append("   INNER JOIN bb_grouping bg  ON bg.BloodCollection_Id=bvh.BloodCollection_Id ");
            sb.Append("     WHERE bvh.IsComponent=3 AND bvh.IsGrouped=3 AND bvh.IsScreened=3 AND bvh.IsTested=0  AND bg.IsApproved=3 AND bg.status=1 AND bvh.CentreID=" + Util.GetInt(ViewState["CenterID"]) + " ");
            if (txtCollectionId.Text != "")
            {
                sb.Append(" AND bcd.BloodCollection_Id='" + txtCollectionId.Text.Trim() + "' ");
            }
            if (txtDonationId.Text != "")
            {
                sb.Append(" AND bv.Visitor_Id='" + txtDonationId.Text.Trim() + "' ");
            }
            if (txtDonationId.Text == "" && txtCollectionId.Text == "")
            {
                if (txtcollectionfrom.Text != "")
                {
                    sb.Append(" AND DATE(bcd.CollectedDate) >='" + Util.GetDateTime(txtcollectionfrom.Text).ToString("yyyy-MM-dd") + "'");
                }

                if (txtcollectionTo.Text != "")
                {
                    sb.Append(" AND  DATE(bcd.CollectedDate) <='" + Util.GetDateTime(txtcollectionTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdStock.DataSource = dt;
                grdStock.DataBind();
                pnlHide.Visible = true;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
                grdStock.DataSource = null;
                grdStock.DataBind();
                pnlHide.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            grdStock.DataSource = null;
            grdStock.DataBind();
            pnlHide.Visible = false;
        }
    }
}