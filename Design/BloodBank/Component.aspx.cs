using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_Component : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (GridViewRow gr in grvListForm.Rows)
            {
                if (((CheckBox)gr.FindControl("chkComp")).Checked)
                {
                    if (((TextBox)gr.FindControl("txtVolume")).Text != "")
                    {
                        Component com = new Component();
                        com.BloodCollection_Id = lblDonation1.Text;
                        com.Component_Id = Util.GetInt(((Label)gr.FindControl("lblGrdComponentId")).Text);
                        com.BagType = lblBagType.Text;
                        com.Volumn = ((TextBox)gr.FindControl("txtVolume")).Text;
                        com.IsComponent = 3;
                        com.CreatedBy = Session["ID"].ToString();
                        com.Createddate = Util.GetDateTime(((Label)gr.FindControl("lbldtCreate")).Text);
                        com.ExpiryDate = Util.GetDateTime(((Label)gr.FindControl("lbldtExpiry")).Text);

                        com.status = 1;
                        com.CentreID = Util.GetInt(Session["CentreID"].ToString());
                        string BloodComponentId = com.Insert();
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM210','" + lblMsg.ClientID + "');", true);
                        return;
                    }
                }
            }

            string up8 = "UPDATE bb_visitors_history SET IsComponent=3 where  BloodCollection_ID='" + lblDonation1.Text + "' ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up8);

            Tranx.Commit();
            pnlComponent.Visible = false;
            pnlDetail.Visible = false;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Blood Component Created Successfully!!! ');", true);
            txtBagNo.Text = "";
            txtDonationId.Text = "";
            txtDonorId.Text = "";
            txtName.Text = "";
            Search();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
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

    protected void grdComponent_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AResult")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            lblID.Text = ((Label)grdComponent.Rows[index].FindControl("lblBCID")).Text;
            lblDonation1.Text = ((Label)grdComponent.Rows[index].FindControl("lblDonationID")).Text;
            lblDonor1.Text = ((Label)grdComponent.Rows[index].FindControl("lblDonorID")).Text;
            lblName1.Text = ((Label)grdComponent.Rows[index].FindControl("lblName")).Text;
            lblBagType.Text = ((Label)grdComponent.Rows[index].FindControl("lblBagType1")).Text;
            //lblBagNo.Text = ((Label)grdComponent.Rows[index].FindControl("lblBagNumber1")).Text;
            lblVolume.Text = ((Label)grdComponent.Rows[index].FindControl("lblVolume1")).Text;
            lblGroup1.Text = ((Label)grdComponent.Rows[index].FindControl("lblGroup")).Text;
            lblBagNo.Text = ((Label)grdComponent.Rows[index].FindControl("lblTubeNo")).Text;
        }

        grdComponent.DataSource = null;
        grdComponent.DataBind();
        bindDetail();
        bindForm(lblBagType.Text, lblDonation1.Text);
    }

    protected void grvListForm_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string st = System.DateTime.Now.ToString("dd-MMM-yyyy");
            if (Util.GetDateTime(((Label)e.Row.FindControl("lbldtExpiry")).Text) < Util.GetDateTime(st.ToString()))
            {
                e.Row.Attributes.Add("style", "background-color:red");
                ((CheckBox)e.Row.FindControl("chkComp")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtVolume")).Enabled = false;
            }
            e.Row.ToolTip = "Component " + Convert.ToString(DataBinder.Eval(e.Row.DataItem, "ComponentName")) + " Expired On: " + Convert.ToString(DataBinder.Eval(e.Row.DataItem, "dtExpiry"));
            e.Row.Style.Add("Cursor", "Hand");
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BloodBank.bindBloodGroup(ddlBloodgroup);
            ddlBloodgroup.Items.Insert(0, new ListItem("Select", "0"));
            txtcollectfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtcollectTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            txtDonationId.Focus();
            ViewState["CenterID"] = Util.GetString(Session["CentreID"].ToString());
        }
        txtcollectfrom.Attributes.Add("readOnly", "true");
        txtcollectTo.Attributes.Add("readOnly", "true");
    }

    private void bindDetail()
    {
        pnlDetail.Visible = true;
    }

    private void bindForm(string BagType, string CollectionID)
    {
        pnlComponent.Visible = true;
        if (BagType.ToLower() == "single")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT id,componentName,'" + lblBagType.Text + "'BagType,DATE_FORMAT((SELECT Collecteddate FROM bb_collection_details WHERE BloodCollection_Id='" + lblDonation1.Text + "'),'%d-%b-%Y')dtCreate,");
            sb.Append(" DATE_FORMAT(DATE_ADD(DATE((SELECT Collecteddate FROM bb_collection_details WHERE BloodCollection_Id='" + lblDonation1.Text + "')),");
            sb.Append(" INTERVAL dtExpiry DAY),'%d-%b-%Y')dtExpiry from bb_component_master where isComponent=1 order by ID asc");
            DataTable dt1 = StockReports.GetDataTable(sb.ToString());
            grvListForm.DataSource = dt1;
            grvListForm.DataBind();
            ((CheckBox)grvListForm.Rows[0].FindControl("chkComp")).Checked = true;
            ((CheckBox)grvListForm.Rows[0].FindControl("chkComp")).Enabled = false;
            btnSave.Enabled = true;
        }
        else
        {
            StringBuilder sb2 = new StringBuilder();
            sb2.Append("SELECT id,componentName,'" + lblBagType.Text + "'BagType,DATE_FORMAT((SELECT Collecteddate FROM bb_collection_details WHERE BloodCollection_Id='" + lblDonation1.Text + "'),'%d-%b-%Y')dtCreate,");
            sb2.Append(" DATE_FORMAT(DATE_ADD(DATE((SELECT Collecteddate FROM bb_collection_details WHERE BloodCollection_Id='" + lblDonation1.Text + "')),");
            sb2.Append(" INTERVAL dtExpiry DAY),'%d-%b-%Y')dtExpiry from bb_component_master where isComponent=1 order by ID asc");
            DataTable dt2 = StockReports.GetDataTable(sb2.ToString());
            int i = dt2.Rows.Count;
            grvListForm.DataSource = dt2;
            grvListForm.DataBind();
           
        }
    }

    private void Search()
    {
        try
        {
            pnlDetail.Visible = false;
            pnlComponent.Visible = false;

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT bv.Visitor_ID,bvh.Visit_ID,bcd.Bloodcollection_id,bvh.isFit,bcd.BagType,bv.Name,bv.dtBirth,bv.Gender,bcd.BBTubeNo,bcd.Volume, ");
            sb.Append(" DATE_FORMAT(bcd.CollectedDate,'%d-%b-%Y')CollectedDate,bm.BloodGroup FROM bb_visitors bv   ");
            sb.Append(" INNER JOIN bb_visitors_history bvh ON bv.Visitor_ID=bvh.Visitor_ID INNER JOIN bb_collection_details bcd ON bcd.Visitor_Id=bv.Visitor_ID and bcd.visit_id=bvh.visit_id");
            sb.Append("  INNER JOIN bb_bloodgroup_master bm ON bm.Id=bv.BloodGroup_Id  ");
            sb.Append(" WHERE bvh.isFit=1  AND bvh.isComponent=0     AND bvh.IsScreened=3 AND bvh.CentreID=" + Util.GetInt(ViewState["CenterID"]) + "  ");
            if (txtDonorId.Text != "")
            {
                sb.Append("and bv.Visitor_ID='" + txtDonorId.Text + "'");
            }
            if (txtDonationId.Text != "")
            {
                sb.Append(" and bcd.Bloodcollection_id ='" + txtDonationId.Text + "'");
            }
            if (txtName.Text != "")
            {
                sb.Append(" and bv.name like '" + txtName.Text.Trim() + "%'");
            }
            if (ddlBloodgroup.SelectedIndex != 0)
            {
                sb.Append(" and bm.BloodGroup='" + ddlBloodgroup.SelectedItem.Text + "'");
            }
            if (txtBagNo.Text != "")
            {
                sb.Append(" and bvh.BBTubeNo='" + txtBagNo.Text + "'");
            }
            if (ddlBagType.SelectedIndex != 0)
            {
                sb.Append(" and bvh.bagtype='" + ddlBagType.SelectedItem.Text + "'");
            }

            if (txtcollectfrom.Text != "")
            {
                sb.Append(" AND DATE(bcd.CollectedDate)>='" + Util.GetDateTime(txtcollectfrom.Text).ToString("yyyy-MM-dd") + "'");
            }
            if (txtcollectTo.Text != "")
            {
                sb.Append(" and DATE(bcd.CollectedDate) <='" + Util.GetDateTime(txtcollectTo.Text).ToString("yyyy-MM-dd") + "'");
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdComponent.DataSource = dt;
                grdComponent.DataBind();
                pnlhide.Visible = true;
            }
            else
            {
                grdComponent.DataSource = dt;
                grdComponent.DataBind();
                pnlhide.Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            grdComponent.DataSource = null;
            grdComponent.DataBind();
            pnlhide.Visible = false;
        }
    }
}