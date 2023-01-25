using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;


public partial class Design_OT_Ot_anes_AnesthaticDrug : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            txtAnesDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtAnesTime.Text = DateTime.Now.ToString("hh:mm tt");

            txtVaTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtAntibioticsTime.Text = DateTime.Now.ToString("hh:mm tt");
       
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            BindPreviousDetails();
        }

        txtAnesDate.Attributes.Add("readOnly", "readOnly");
    }
    [WebMethod]
    public static string BindSearch(string key)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TypeName AS NAME FROM f_itemmaster im INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID = im.SubcategoryID ");
        sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID = sm.CategoryID WHERE cm.CategoryID='5' AND im.TypeName like '%" + key + "%' ");

        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());

        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        return "";
    }
    
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string dt = Util.GetDateTime(txtAnesDate.Text).ToString("yyyy-MM-dd");

            StringBuilder sbupdate = new StringBuilder();
            sbupdate.Append(" update cocoa_anes_anestheticdrug set ");
            sbupdate.Append(" `AnesDrugDate`='" + dt + "',`AnesDrugTime`='" + GetTime24HFormat(txtAnesTime.Text) + "',Drugs='" + txtDrugs.Text + "',`N2O`='" + txtN2O.Text + "',`O2`='" + txtO2.Text + "', ");

            sbupdate.Append(" `VolatileAgent`='" + txtVolatileAgent.Text + "',`VATime`='" + GetTime24HFormat(txtVaTime.Text) + "',`Antibiotic`='" + txtAntibiotics.Text + "',`AntibioticTime`='" + GetTime24HFormat(txtAntibioticsTime.Text) + "', ");
            sbupdate.Append(" `Tourniquet`=" + rblTourniquet.Checked + ",`Site1`='" + txtSite1.Text + "',`Site2`='" + txtSite2.Text + "',`Site3`='" + txtSite3.Text + "', ");
            sbupdate.Append(" isActive=1,UpdateBy='" + Util.GetString(Session["ID"].ToString()) + "',UpdateDate=NOW() where ID='" + lblID.Text+ "'");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbupdate.ToString());

            tnx.Commit();

            lblMsg.Text = "Record Updated Successfully";
            clear();
            BindPreviousDetails();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string dt = Util.GetDateTime(txtAnesDate.Text).ToString("yyyy-MM-dd");

            StringBuilder sb = new StringBuilder();
            sb.Append(" insert  into `cocoa_anes_anestheticdrug`(`Patient_Id`,`Transaction_Id`,`AnesDrugDate`,`AnesDrugTime`,Drugs,`N2O`,`O2`,");
            sb.Append(" `VolatileAgent`,`VATime`,`Antibiotic`,`AntibioticTime`,`Tourniquet`,`Site1`,`Site2`,`Site3`,`EntryBy`) ");
            sb.Append("VALUES('" + ViewState["PID"] + "','" + ViewState["TID"] + "','" + dt + "','" + GetTime24HFormat(txtAnesTime.Text) + "','" + txtDrugs.Text + "','" + txtN2O.Text + "','" + txtO2.Text + "',  ");
            sb.Append(" '" + txtVolatileAgent.Text + "','" + GetTime24HFormat(txtVaTime.Text) + "','" + txtAntibiotics.Text + "','" + GetTime24HFormat(txtAntibioticsTime.Text) + "',  ");
            sb.Append(" " + rblTourniquet.Checked + ",'" + txtSite1.Text + "','" + txtSite2.Text + "','" + txtSite3.Text + "','" + Util.GetString(Session["ID"].ToString()) + "' )");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();

            lblMsg.Text = "Record Saved Successfully";
            clear();
            BindPreviousDetails();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }


    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "Change")
            {
                lblMsg.Text = "";

                int id = Convert.ToInt16(e.CommandArgument.ToString());

                lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblgdID")).Text;
                txtAnesDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDate")).Text;
                txtAnesTime.Text = GetTime12HFormat(((Label)grdPhysical.Rows[id].FindControl("lblTime")).Text);
                txtDrugs.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDrugs")).Text;
                txtN2O.Text = ((Label)grdPhysical.Rows[id].FindControl("lblN2O")).Text;
                txtO2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblO2")).Text;
                txtVolatileAgent.Text = ((Label)grdPhysical.Rows[id].FindControl("lblVolatileAgents")).Text;
                txtVaTime.Text = GetTime12HFormat(((Label)grdPhysical.Rows[id].FindControl("lblVATime")).Text);
                txtAntibiotics.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAntibiotics")).Text;
                txtAntibioticsTime.Text = GetTime12HFormat(((Label)grdPhysical.Rows[id].FindControl("lblAntibioticsTime")).Text);
                rblTourniquet.Checked = Util.GetBoolean(GetBooleanVal(((Label)grdPhysical.Rows[id].FindControl("lblTourniquet")).Text));
                txtSite1.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSite1")).Text;
                txtSite2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSite2")).Text;
                txtSite3.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSite3")).Text;

                btnUpdate.Visible = true;
                btnSave.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }


    public void BindPreviousDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  concat(cap.Site1,' ',cap.site2,' ',cap.site3)Site,  ");
        sb.Append("`Id`,`Patient_Id`,`Transaction_Id`, DATE_FORMAT(`AnesDrugDate`,'%d-%b-%Y')AnesDrugDate,DATE_FORMAT(`AnesDrugTime`,'%r')AnesDrugTime,");
        sb.Append("Drugs,`N2O`,`O2`,`VolatileAgent`,");
        sb.Append("DATE_FORMAT(`VATime`,'%r')VATime,`Antibiotic`,DATE_FORMAT(`AntibioticTime`,'%r')AntibioticTime,");
        sb.Append("`Tourniquet`,IF(IFNULL(Tourniquet,0)=0,'OFF','ON')TourniquetText,`Site1`,`Site2`,`Site3`,");
        sb.Append(" `EntryDate`,`EntryBy`,`UpdateBy`,`UpdateDate`,`IsActive`");

        sb.Append(" FROM cocoa_anes_anestheticdrug cap WHERE  cap.IsActive=1 AND cap.Patient_Id='" + ViewState["PID"] + "' AND cap.Transaction_Id='" + ViewState["TID"] + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grdPhysical.DataSource = dt;
        grdPhysical.DataBind();
    }


    protected void btnCancel_Click(object sender, EventArgs e)
    {
        clear();

    }
    public void clear()
    {
        lblID.Text = "";

        txtAnesDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtAnesTime.Text = DateTime.Now.ToString("hh:mm tt");

        txtVaTime.Text = DateTime.Now.ToString("hh:mm tt");
        txtAntibioticsTime.Text = DateTime.Now.ToString("hh:mm tt");
        txtDrugs.Text = "";
        txtN2O.Text = "";
        txtO2.Text = "";
        txtVolatileAgent.Text = "";
        //txtVaTime.Text = "";
        txtAntibiotics.Text = "";
        //txtAntibioticsTime.Text = "";
        rblTourniquet.Checked = false;
        txtSite1.Text = "";
        txtSite2.Text = "";
        txtSite3.Text = "";
        lblMsg.Text = "";
        btnSave.Visible = true;
        btnUpdate.Visible = false;
    }


    public string GetTime24HFormat(string time12h)
    {
        if (!string.IsNullOrEmpty(time12h))
        {
            return Util.GetDateTime(time12h).ToString("HH:mm:ss");
        }
        else
        {
            return "00:00:00";
        }

    }

    public string GetTime12HFormat(string time24h)
    {
        if (!string.IsNullOrEmpty(time24h))
        {
            return Util.GetDateTime(time24h).ToString("hh:mm tt");
        }
        else
        {
            return "00:00 AM";
        }

    }

    public string GetBooleanVal(string boolval)
    {
        if (!string.IsNullOrEmpty(boolval) && boolval == "1")
        {
            return "True";
        }
        else
        {
            return "False";
        }

    }

}