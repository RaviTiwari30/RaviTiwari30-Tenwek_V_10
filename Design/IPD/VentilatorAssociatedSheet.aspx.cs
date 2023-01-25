using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_IPD_VentilatorAssociatedSheet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
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

            txtDateInsertion.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtVapDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtDateRemoval.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            BindVapDetail();
            BindUser();
            BindDetail();

            AllQuery AQ = new AllQuery();
            if (Request.QueryString["TransactionID"] != null)
            {
                DataTable dtDischarge = AQ.GetPatientDischargeStatus(ViewState["TID"].ToString());
                if (Session["RoleID"].ToString() != "51")
                {
                    if (dtDischarge != null && dtDischarge.Rows.Count > 0)
                    {
                        if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                        {
                            btnSave.Visible = false;
                            btnSaveInsertion.Visible = false;
                        }
                    }
                }
            }

            DateTime AdmitDate = Util.GetDateTime(AQ.getAdmitDate(ViewState["TID"].ToString()));
            cclDateInsertion.StartDate = AdmitDate;
            clcVapDate.StartDate = Util.GetDateTime(txtDateInsertion.Text);

            cclDateInsertion.EndDate = DateTime.Now;
            clcVapDate.EndDate = DateTime.Now;
            cclDateRemoval.EndDate = DateTime.Now;
        }

        lblMsg.Text = "";
        txtDateInsertion.Attributes.Add("readOnly", "readOnly");
        txtDateRemoval.Attributes.Add("readOnly", "readOnly");
        txtVapDate.Attributes.Add("readOnly", "readOnly");
    }

    private void BindUser()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Name, EmployeeID From employee_master WHERE IsActive=1 ");

        if (dt.Rows.Count > 0)
        {
            ddlUser.DataSource = dt;
            ddlUser.DataTextField = "Name";
            ddlUser.DataValueField = "EmployeeID";
            ddlUser.DataBind();
            ddlUser.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void BindVAP()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID VapID,VAPPrevention as VAP FROM master_VAPPrevention WHERE IsActive=1");

        if (dt.Rows.Count > 0)
        {
            grdVAP.DataSource = dt;
            grdVAP.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*)COUNT FROM VAPPrevention_Detail WHERE VAPPreventionID='" + lblVapID.Text + "' AND VapDate='" + Util.GetDateTime(txtVapDate.Text).ToString("yyyy-MM-dd") + "' "));
        if (count > 0)
        {
            foreach (GridViewRow dr in grdVAP.Rows)
            {
                sb.Append(" UPDATE VAPPrevention_Detail SET VAPM='" + ((RadioButtonList)dr.FindControl("rblM")).SelectedValue + "',VAPE='" + ((RadioButtonList)dr.FindControl("rblE")).SelectedValue + "', ");
                sb.Append(" UpdatedBy='" + Session["ID"].ToString() + "',UpdateDate=NOW() ");
                sb.Append(" WHERE ID='" + ((Label)dr.FindControl("lblVapID")).Text + "'; ");
            }
            bool check = StockReports.ExecuteDML(sb.ToString());
            if (check == true)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            }
        }
        else
        {
            foreach (GridViewRow dr in grdVAP.Rows)
            {
                sb.Append(" INSERT INTO VAPPrevention_Detail(VAPPreventionID,VAPPrevention,VapDate,PatientID,TransactionID,VAPM,VAPE,MorEntryBy,EveEntryBy,EntryDate) ");
                sb.Append(" VALUES('" + lblVapID.Text.Trim() + "','" + ((Label)dr.FindControl("lblVap")).Text + "','" + Util.GetDateTime(txtVapDate.Text).ToString("yyyy-MM-dd") + "', ");
                sb.Append(" '" + ViewState["PID"].ToString() + "','" + ViewState["TID"].ToString() + "','" + ((RadioButtonList)dr.FindControl("rblM")).SelectedValue + "','" + ((RadioButtonList)dr.FindControl("rblE")).SelectedValue + "','" + Session["ID"].ToString() + "','" + Session["ID"].ToString() + "',NOW() ); ");
            }
            bool check = StockReports.ExecuteDML(sb.ToString());
            if (check == true)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            }
        }

        BindVapDetail();
        BindDetail();
    }

    private void BindDetail()
    {
        DataTable dt = new DataTable();

        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*)COUNT FROM VAPPrevention_Detail WHERE VAPPreventionID='" + lblVapID.Text + "' "));

        if (count > 0)
        {
            dt = StockReports.GetDataTable(" SELECT ID VapID,VAPPrevention,IFNULL(VAPPreventionID,'')VAPPreventionID,IFNULL(vpd.VAPM,'0')VAPM,IFNULL(vpd.VAPE,'0')VAPE,IFNULL(MorEntryBy,'')MorEntryBy,IFNULL(EveEntryBy,'')EveEntryBy FROM VAPPrevention_Detail vpd WHERE VAPPreventionID='" + lblVapID.Text + "' AND TransactionID='" + ViewState["TID"].ToString() + "' And VapDate='" + Util.GetDateTime(txtVapDate.Text).ToString("yyyy-MM-dd") + "'  ");
        }
        else
        {
            dt = StockReports.GetDataTable(" SELECT ID VapID,VAPPrevention,'' VAPPreventionID,'' VAPM,'' VAPE,'' MorEntryBy,'' EveEntryBy FROM master_VAPPrevention ");
        }

        if (dt.Rows.Count > 0)
        {
            grdVAP.DataSource = dt;
            grdVAP.DataBind();
        }
    }

    private void BindVapDetail()
    {
        DataTable DateInsertion = StockReports.GetDataTable("SELECT ID,IFNULL(DateofInsertion,'')DateofInsertion,IFNULL(DateofRemoval,'')DateofRemoval,DATEDIFF(IF(DateofRemoval='0000-00-00',CURRENT_DATE(),DateofRemoval),DateofInsertion)+1 as NoofDays FROM vapstart WHERE TID=" + ViewState["TID"] + " AND IfNull(DateofInsertion,'0001-01-01')<>'0001-01-01' AND (IfNull(DateofRemoval,'0000-00-00')='0000-00-00' OR DateofRemoval='0000-00-00') ");

        if (DateInsertion.Rows.Count > 0)
        {
            if (DateInsertion.Rows[0]["DateofInsertion"].ToString() == "")
            {
                txtInfection.Enabled = false;
                txtDateRemoval.Enabled = false;
                txtCultureReport.Enabled = false;
                ddlUser.Enabled = false;
                tb_Record.Visible = false;
            }
            else
            {
                txtDateInsertion.Text = Util.GetDateTime(DateInsertion.Rows[0]["DateofInsertion"]).ToString("dd-MMM-yyyy");
                txtDateInsertion.Enabled = false;
                txtInfection.Enabled = true;
                txtDateRemoval.Enabled = true;
                txtCultureReport.Enabled = true;
                ddlUser.Enabled = true;
                tb_Record.Visible = true;
                txtVapDate.Enabled = true;
                lblVentilatorDays.Text = DateInsertion.Rows[0]["NoofDays"].ToString();
                btnSaveInsertion.Text = "Save Removal Date";
                btnSave.Visible = true;
                lblVapID.Text = DateInsertion.Rows[0]["ID"].ToString();
            }
        }
        else
        {
            DataTable Removal = StockReports.GetDataTable("SELECT ID,IFNULL(DateofInsertion,'')DateofInsertion,Date_Format(DateofRemoval,'%d-%b-%y')DateofRemoval,DATEDIFF(DateofRemoval,DateofInsertion)+1 as NoofDays FROM vapstart  Order by ID Desc LIMIT 1 ");
            txtInfection.Enabled = false;
            txtDateRemoval.Enabled = false;
            txtCultureReport.Enabled = false;
            ddlUser.Enabled = false;
            tb_Record.Visible = false;
            txtVapDate.Enabled = true;
            btnSave.Visible = false;
            btnSaveInsertion.Text = "Save";
            if (Removal.Rows.Count > 0 && Removal.Rows[0]["DateofRemoval"] != "")
            {
                DateTime removalDate = Util.GetDateTime(Removal.Rows[0]["DateofRemoval"]);
                cclDateInsertion.EndDate = removalDate;
            }
        }
    }

    protected void btnSaveInsertion_Click(object sender, EventArgs e)
    {
        if (btnSaveInsertion.Text == "Save")
        {
            bool check = StockReports.ExecuteDML("Insert into vapstart(TID,PID,DateofInsertion,StartBy,StartDate)values ('" + ViewState["TID"].ToString() + "','" + ViewState["PID"].ToString() + "','" + Util.GetDateTime(txtDateInsertion.Text).ToString("yyyy-MM-dd") + "','" + Session["ID"].ToString() + "',Now())");
            if (check == true)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                BindVapDetail();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                BindVapDetail();
            }
        }
        else
        {
            if (lblVapID.Text != "" && ddlUser.SelectedIndex != 0)
            {
                bool check = StockReports.ExecuteDML("UPDATE vapstart SET DateofRemoval='" + Util.GetDateTime(txtDateRemoval.Text).ToString("yyyy-MM-dd") + "',CultureReport='" + txtCultureReport.Text.Trim() + "',Infection='" + txtInfection.Text.Trim() + "',InfControlNurse='" + ddlUser.SelectedItem.Text + "',RemovalBy='" + Session["ID"].ToString() + "',RemovalDate=NoW() WHERE ID='" + lblVapID.Text + "' ");
                if (check == true)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                    BindVapDetail();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    BindVapDetail();
                }
            }
            else
            {
                lblMsg.Text = "Please Select The Proper Nurse";
                ddlUser.Focus();
            }
        }

        BindVapDetail();
    }

    protected void grdVAP_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            ((RadioButtonList)e.Row.FindControl("rblM")).SelectedIndex = ((RadioButtonList)e.Row.FindControl("rblM")).Items.IndexOf(((RadioButtonList)e.Row.FindControl("rblM")).Items.FindByValue(((Label)e.Row.FindControl("lblM")).Text));
            ((RadioButtonList)e.Row.FindControl("rblE")).SelectedIndex = ((RadioButtonList)e.Row.FindControl("rblE")).Items.IndexOf(((RadioButtonList)e.Row.FindControl("rblE")).Items.FindByValue(((Label)e.Row.FindControl("lblE")).Text));
            if (((Label)e.Row.FindControl("lblM")).Text == "1")
            {
                if (((Label)e.Row.FindControl("lblUserIDM")).Text != Session["ID"].ToString())
                {
                    ((RadioButtonList)e.Row.FindControl("rblM")).Enabled = false;
                    ((RadioButtonList)e.Row.FindControl("rblM")).ToolTip = "You are not able to Edit";
                }
                else
                {
                    ((RadioButtonList)e.Row.FindControl("rblM")).Enabled = true;
                    ((RadioButtonList)e.Row.FindControl("rblM")).SelectedItem.Value = "1";
                }
            }
            if (((Label)e.Row.FindControl("lblM")).Text == "1")
            {
                if (((Label)e.Row.FindControl("lblUserIDE")).Text != Session["ID"].ToString())
                {
                    ((RadioButtonList)e.Row.FindControl("rblE")).Enabled = false;
                    ((RadioButtonList)e.Row.FindControl("rblE")).ToolTip = "You are not able to Edit";
                }
                else
                {
                    ((RadioButtonList)e.Row.FindControl("rblE")).Enabled = true;
                    ((RadioButtonList)e.Row.FindControl("rblE")).SelectedItem.Value = "1";
                }
            }
        }
    }

    protected void txtVapDate_TextChanged(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*)COUNT FROM VAPPrevention_Detail WHERE VapDate='" + Util.GetDateTime(txtVapDate.Text).ToString("yyyy-MM-dd") + "' "));
        if (count > 0)
        {
            dt = StockReports.GetDataTable(" SELECT ID VapID,VAPPrevention,IFNULL(VAPPreventionID,'')VAPPreventionID,IFNULL(vpd.VAPM,'0')VAPM,IFNULL(vpd.VAPE,'0')VAPE,IFNULL(MorEntryBy,'')MorEntryBy,IFNULL(EveEntryBy,'')EveEntryBy FROM VAPPrevention_Detail vpd WHERE VapDate='" + Util.GetDateTime(txtVapDate.Text).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TID"].ToString() + "'   ");
        }
        else
        {
            dt = StockReports.GetDataTable(" SELECT ID VapID,VAPPrevention,'' VAPPreventionID,'' VAPM,'' VAPE,'' MorEntryBy,'' EveEntryBy FROM master_VAPPrevention ");
        }

        if (dt.Rows.Count > 0)
        {
            grdVAP.DataSource = dt;
            grdVAP.DataBind();

            if (DateTime.Now.ToString("dd-MM-yyyy") != Util.GetDateTime(txtVapDate.Text).ToString("dd-MM-yyyy"))
            {
                btnSave.Visible = false;
            }
        }
    }
}