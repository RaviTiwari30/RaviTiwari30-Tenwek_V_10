using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_IPD_CatherForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            AllQuery AQ = new AllQuery();
            if (!IsPostBack)
            {
                if (Request.QueryString["TransactionID"] == null)
                {
                    ViewState["TID"] = Request.QueryString["TID"].ToString();
                    ViewState["PID"] = Request.QueryString["PID"].ToString();
                }
                else
                {
                    ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                    ViewState["PID"] = Request.QueryString["PatientID"].ToString();
                }
                txtInsertDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txtRemovedDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txtInsertTime.Text = DateTime.Now.ToString("hh:mm tt");
                txtRemovedTime.Text = DateTime.Now.ToString("hh:mm tt");
                BindEmployee();
                BindInsertion();
                if (Request.QueryString["TransactionID"] != null)
                {
                    DataTable dtDischarge = AQ.GetPatientDischargeStatus(ViewState["TID"].ToString());
                    if (Session["RoleID"].ToString() != "51")
                    {
                        if (dtDischarge != null && dtDischarge.Rows.Count > 0)
                        {
                            if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                            {
                                btnSaveInsertion.Visible = false;
                                btnSaveDetail.Visible = false;
                            }
                        }
                    }
                }
            }
            DateTime AdmitDate = Util.GetDateTime(AQ.getAdmitDate(ViewState["TID"].ToString()));
            cclInsertDate.StartDate = AdmitDate;
            cclInsertDate.EndDate = DateTime.Now;
            txtInsertDate.Attributes.Add("Readonly", "Readonly");
            txtRemovedDate.Attributes.Add("Readonly","Readonly");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void BindEmployee()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Name,Employee_ID From employee_master Where isActive=1 ");
        if (dt.Rows.Count > 0)
        {
            ddlUser.DataSource = dt;
            ddlUser.DataTextField = "Name";
            ddlUser.DataValueField = "Employee_ID";
            ddlUser.DataBind();
            ddlUser.Items.Insert(0, new ListItem("Select", "0"));
            ddlInsertUser.DataSource = dt;
            ddlInsertUser.DataTextField = "Name";
            ddlInsertUser.DataValueField = "Employee_ID";
            ddlInsertUser.DataBind();
            ddlInsertUser.Items.Insert(0, new ListItem("Select", "0"));
            ddlRemovedBy.DataSource = dt;
            ddlRemovedBy.DataTextField = "Name";
            ddlRemovedBy.DataValueField = "Employee_ID";
            ddlRemovedBy.DataBind();
            ddlRemovedBy.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    protected void btnSaveInsertion_Click(object sender, EventArgs e)
    {
        if (btnSaveInsertion.Text == "Save")
        {
            if (ddlInsertUser.SelectedIndex == 0)
            {
                lblMsg.Text = "Please Select Insert User";
                ddlInsertUser.Focus();
                return;
            }
            else
            {
                bool check = StockReports.ExecuteDML("INSERT INTO catherinsert(TID,PID,InsertedBy,InsertedDate,EntryBy)VALUES('" + ViewState["TID"] + "','" + ViewState["PID"] + "','" + ddlInsertUser.SelectedValue + "','" + Util.GetDateTime(txtInsertDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtInsertTime.Text).ToString("hh:mm:ss") + "','" + Session["ID"].ToString() + "')");
                if (check == true)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                else
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            }
        }
        else if (btnSaveInsertion.Text == "Save Removal")
        {
            if (ddlRemovedBy.SelectedIndex == 0)
            {
                lblMsg.Text = "Please Select Removed User";
                ddlRemovedBy.Focus();
                return;
            }
            else if (txtInfection.Text != "" && ddlUser.SelectedIndex ==0)
            {
                lblMsg.Text = "Please Select The infection Control Nurse";
                ddlUser.Focus();
                return;
            }
            else
            {
                bool check = StockReports.ExecuteDML("UPDATE catherinsert SET RemovedBy='" + ddlRemovedBy.SelectedValue + "',Removedate='" + Util.GetDateTime(txtRemovedDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtRemovedTime.Text).ToString("hh:mm:ss") + "',UpdateBy='" + Session["ID"].ToString() + "',UpdateDate=NOW(),Infection='" + txtInfection.Text.Trim() + "',InfectionUser='"+ ddlInsertUser.SelectedValue +"' WHERE ID='" + lblcathID.Text.Trim() + "' AND TID='" + ViewState["TID"].ToString() + "' ");
                if (check == true)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                else
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            }
        }
        BindInsertion();
    }
    private void BindInsertion()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,TID,PID,DATE_FORMAT(InsertedDate,'%d-%b-%y')InsertDate,DATE_FORMAT(InsertedDate,'%h:%m %p')InsertTime,insertedBy ");
        sb.Append("FROM catherinsert WHERE TID='" + ViewState["TID"].ToString() + "' AND Removedate IS  NULL ");
        DataTable dtInsertion = StockReports.GetDataTable(sb.ToString());
        if (dtInsertion.Rows.Count > 0)
        {
            txtInsertDate.Text = Util.GetDateTime(dtInsertion.Rows[0]["InsertDate"]).ToString("dd-MMM-yyyy");
            txtInsertTime.Text = Util.GetDateTime(dtInsertion.Rows[0]["InsertTime"]).ToString("hh:mm tt");
            ddlInsertUser.SelectedIndex = ddlInsertUser.Items.IndexOf(ddlInsertUser.Items.FindByValue(dtInsertion.Rows[0]["insertedBy"].ToString()));
            lblcathID.Text = Util.GetString(dtInsertion.Rows[0]["ID"]);
            txtInsertDate.Enabled = false;
            txtInsertTime.Enabled = false;
            ddlInsertUser.Enabled = false;
            tb_Record.Visible = true;
            div_Save.Visible = true;
            BindCautiBundle();
            validatetrue();
            btnSaveInsertion.Text = "Save Removal";
            cclRemovedDate.StartDate = Util.GetDateTime(dtInsertion.Rows[0]["InsertDate"]);
            cclRemovedDate.EndDate = Util.GetDateTime(dtInsertion.Rows[0]["InsertDate"]).AddDays(14);
        }
        else
        {
            txtInsertDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtInsertTime.Text = DateTime.Now.ToString("hh:mm tt");
            ddlInsertUser.SelectedIndex = 0;
            lblcathID.Text = "";
            txtInsertDate.Enabled = true;
            txtInsertTime.Enabled = true;
            ddlInsertUser.Enabled = true;
            tb_Record.Visible = false;
            div_Save.Visible = false;
            BindCautiBundle();
            btnSaveInsertion.Text = "Save";
            //cclRemovedDate.StartDate = DateTime.Now.ToString("dd-MMM-yyyy");
            //cclRemovedDate.EndDate = DateTime.Now.AddDays(14).ToString("dd-MMM-yyyy");
        }
    }
    private void validatetrue()
    {
        ddlRemovedBy.Enabled = true;
        txtRemovedDate.Enabled = true;
        txtRemovedTime.Enabled = true;
        txtInfection.Enabled = true;
        ddlUser.Enabled = true;
    }
    private void BindCautiBundle()
    {
        DataTable dt = StockReports.GetDataTable("Select cm.Name,cm.ID,cd.ID AS DID, cd.catherID,cd.TID,cd.PID,cd.Remarks,(Select Name from employee_master where employee_ID=cd.EntryBy)EmpName,cd.EntryBy,cd.EntryDate,cd.Status from Cather_master cm left join Cather_Detail cd on cd.CautiID=cm.ID And TID='" + ViewState["TID"] + "' And Day='"+ ddlDays.SelectedValue +"' And CatherID='"+ lblcathID.Text +"' where cm.isActive=1");
        if (dt.Rows.Count > 0)
        {
            grdCath.DataSource = dt;
            grdCath.DataBind();
        }
        else
        {
            grdCath.DataSource = null;
            grdCath.DataBind();
        }
    }
    protected void btnSaveDetail_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*)COUNT FROM Cather_Detail WHERE CatherID='" + lblcathID.Text + "' And Day='"+ ddlDays.SelectedValue +"' "));
        if (count > 0)
        {
            foreach (GridViewRow dr in grdCath.Rows)
            {
                string ssssss = ((Label)dr.FindControl("lblDID")).Text;
                sb.Append(" UPDATE cather_detail SET STATUS='" + ((RadioButtonList)dr.FindControl("rblStatus")).SelectedValue + "',Remarks='" + ((TextBox)dr.FindControl("txtRemarks")).Text + "',EntryBY='" + Session["ID"].ToString() + "' WHERE id='" + ((Label)dr.FindControl("lblDID")).Text + "'; ");
            }
            bool check = StockReports.ExecuteDML(sb.ToString());
            if (check == true)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            }
        }
        else
        {
            foreach (GridViewRow dr in grdCath.Rows)
            {
                sb.Append("INSERT INTO Cather_Detail(CatherID,NAME,PID,TID,STATUS,EntryBY,DAY,CautiID,Remarks)VALUES('" + lblcathID.Text + "','" + ((Label)dr.FindControl("lblCatherName")).Text + "','" + ViewState["PID"].ToString() + "','" + ViewState["TID"].ToString() + "','" + ((RadioButtonList)dr.FindControl("rblStatus")).SelectedValue + "','" + Session["ID"].ToString() + "','" + ddlDays.SelectedValue + "','" + ((Label)dr.FindControl("lblID")).Text + "','" + ((TextBox)dr.FindControl("txtRemarks")).Text + "'); ");
            }
            bool check = StockReports.ExecuteDML(sb.ToString());
            if (check == true)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            }
        }
        BindCautiBundle();
    }
    protected void grdCath_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            ((RadioButtonList)e.Row.FindControl("rblStatus")).SelectedIndex = ((RadioButtonList)e.Row.FindControl("rblStatus")).Items.IndexOf(((RadioButtonList)e.Row.FindControl("rblStatus")).Items.FindByValue(((Label)e.Row.FindControl("lblStatus")).Text));
            if (((RadioButtonList)e.Row.FindControl("rblStatus")).SelectedIndex == -1)
            {
                ((RadioButtonList)e.Row.FindControl("rblStatus")).SelectedValue = "0";
            }
            else if (((Label)e.Row.FindControl("lblEntryBy")).Text != Session["ID"].ToString())
            {
                ((RadioButtonList)e.Row.FindControl("rblStatus")).Enabled = false;
            }
        }
    }
    protected void ddlDays_TextChanged(object sender, EventArgs e)
    {
        BindCautiBundle();
    }
}