using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CPOE_DialysisChart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
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
                BindDialysis();
                lblPatientID.Text = ViewState["PID"].ToString();
                lblTransactionID.Text = ViewState["TID"].ToString();
                txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txtTime.Text = DateTime.Now.ToString("hh:mm tt");
                txt15MinTime.Text = DateTime.Now.ToString("hh:mm tt");
                BindDoctor();
                Disable15min();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void BindDoctor()
    {
        try
        {
            DataTable dt = EDPReports.GetConsultantsWithoutTitle();
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlDoctor.DataSource = dt;
                ddlDoctor.DataTextField = "text";
                ddlDoctor.DataValueField = "value";
                ddlDoctor.DataBind();
                ddlDoctor.Items.Insert(0, new ListItem("--------", "0"));
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            if (btnSave.Text == "Save")
            {
                string DialysisNo = StockReports.ExecuteScalar("SELECT CONCAT(IFNULL(MAX(DialysisNo),0)+1)DialysisNo FROM dialysis_monitoring_chart WHERE PatientID='" + ViewState["PID"].ToString() + "'");
                string str = "INSERT INTO dialysis_monitoring_chart(DialysisNo,StartDate,StartTime,TransactionID,PatientID, " +
                           "Dur_HD,UF,QB,QD,No_HD,Heparine,Pre_HDBP,Pre_HDWeight,DialyzerReuser,Access, " +
                           "Saline_Tyle,Doctor,EntryBy,EntryDate,Remarks)VALUES(  " +
                           "'" + DialysisNo + "','" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "', " +
                           "'" + ViewState["TID"].ToString() + "','" + ViewState["PID"].ToString() + "','" + txtDurationofHD.Text.Trim() + "','" + txtUF.Text.Trim() + "', " +
                           "'" + txtQB.Text.Trim() + "','" + txtQD.Text.Trim() + "','" + txtNoofHD.Text.Trim() + "','" + txtHeparin.Text.Trim() + "','" + txtPreBp.Text.Trim() + "', " +
                           "'" + txtPreHdWeight.Text.Trim() + "','" + ddlDialReuser.SelectedItem.Text + "', " +
                           "'" + txtAccess.Text.Trim() + "','" + ddlSalineType.SelectedItem.Text + "','" + ddlDoctor.SelectedValue + "','" + Session["ID"].ToString() + "', " +
                           "Now(),'" + txtComment.Text.Trim() + "') ";
                StockReports.ExecuteDML(str);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            }
            else
            {
                string str = "UPDATE dialysis_monitoring_chart SET StartDate='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',StartTime='" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "',Dur_HD='" + txtDurationofHD.Text.Trim() + "',UF='" + txtUF.Text.Trim() + "', " +
                            "QB='" + txtQB.Text.Trim() + "',QD='" + txtQD.Text.Trim() + "',No_HD='" + txtNoofHD.Text.Trim() + "',Heparine='" + txtHeparin.Text.Trim() + "',Pre_HDBP='" + txtPreBp.Text.Trim() + "', " +
                            "Pre_HDWeight='" + txtPreHdWeight.Text.Trim() + "', Post_HDBP='" + txtPostBP.Text + "',Post_HDWeight='" + txtPostHdWeight.Text + "', " +
                            "DialyzerReuser='" + ddlDialReuser.SelectedItem.Text + "',Access='" + txtAccess.Text.Trim() + "',Saline_Tyle='" + ddlSalineType.SelectedItem.Text + "',Doctor='" + ddlDoctor.SelectedItem.Text + "', " +
                            "UpdateBy='" + Session["ID"].ToString() + "',UpdateDate=NOW(),Remarks='" + txtComment.Text.Trim() + "' " +
                            "WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND ID='" + lblDiID.Text + "'";
                StockReports.ExecuteDML(str);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
            }
            Dialysisclear();
            BindDialysis();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }

    private void BindDialysis()
    {
        try
        {
            StringBuilder query = new StringBuilder();
            query.Append("SELECT ID,DialysisNo,StartDate,StartTime,TransactionID,PatientID,isClose, ");
            query.Append("Dur_HD,UF,QB,QD,No_HD,Heparine,Pre_HDBP,Pre_HDWeight,Post_HDBP,Post_HDWeight,DialyzerReuser,Access,Remarks, ");
            query.Append("Saline_Tyle,Doctor,EntryBy FROM dialysis_monitoring_chart  WHERE PatientID='" + ViewState["PID"].ToString() + "' AND isclose=0 ");
            DataTable dt = StockReports.GetDataTable(query.ToString());
            if (dt.Rows.Count > 0)
            {
                lblDiID.Text = Util.GetString(dt.Rows[0]["ID"].ToString());
                lblDialysesNo.Text = Util.GetString(dt.Rows[0]["DialysisNo"].ToString());
                txtDate.Text = Util.GetDateTime(dt.Rows[0]["StartDate"]).ToString("dd-MMM-yyyy");
                txtTime.Text = Util.GetDateTime(dt.Rows[0]["StartTime"]).ToString("hh:mm tt");
                txtDurationofHD.Text = Util.GetString(dt.Rows[0]["Dur_HD"].ToString());
                txtUF.Text = Util.GetString(dt.Rows[0]["UF"].ToString());
                txtQB.Text = Util.GetString(dt.Rows[0]["QB"].ToString());
                txtQD.Text = Util.GetString(dt.Rows[0]["QD"].ToString());
                txtNoofHD.Text = Util.GetString(dt.Rows[0]["No_HD"].ToString());
                txtHeparin.Text = Util.GetString(dt.Rows[0]["Heparine"].ToString());
                txtPreBp.Text = Util.GetString(dt.Rows[0]["Pre_HDBP"].ToString());
                txtPreHdWeight.Text = Util.GetString(dt.Rows[0]["Pre_HDWeight"].ToString());
                txtPostBP.Text = Util.GetString(dt.Rows[0]["Post_HDBP"].ToString());
                txtPostHdWeight.Text = Util.GetString(dt.Rows[0]["Post_HDWeight"].ToString());
                txtAccess.Text = Util.GetString(dt.Rows[0]["Access"].ToString());
                txtComment.Text = Util.GetString(dt.Rows[0]["Remarks"].ToString());
                ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByText(dt.Rows[0]["Doctor"].ToString()));
                ddlDialReuser.SelectedIndex = ddlDialReuser.Items.IndexOf(ddlDialReuser.Items.FindByText(dt.Rows[0]["DialyzerReuser"].ToString()));
                ddlSalineType.SelectedIndex = ddlSalineType.Items.IndexOf(ddlSalineType.Items.FindByText(dt.Rows[0]["Saline_Tyle"].ToString()));
                txtPostBP.Enabled = true;
                txtPostHdWeight.Enabled = true;
                txtDurationofHD.Enabled = true;
                btnClose.Visible = true;
                btnSave.Text = "Update";
                Disable15min();
                if (dt.Rows[0]["EntryBy"].ToString() != Session["ID"].ToString())
                {
                    txtDate.Enabled = false;
                    txtTime.Enabled = false;
                    txtUF.Enabled = false;
                    txtQB.Enabled = false;
                    txtQD.Enabled = false;
                    txtNoofHD.Enabled = false;
                    txtHeparin.Enabled = false;
                    txtPreBp.Enabled = false;
                    txtPreHdWeight.Enabled = false;
                    txtAccess.Enabled = false;
                    txtComment.Enabled = false;
                    ddlDoctor.Enabled = false;
                    ddlDialReuser.Enabled = false;
                    ddlSalineType.Enabled = false;
                }
                else
                {
                    txtDate.Enabled = true;
                    txtTime.Enabled = true;
                    txtUF.Enabled = true;
                    txtQB.Enabled = true;
                    txtQD.Enabled = true;
                    txtNoofHD.Enabled = true;
                    txtHeparin.Enabled = true;
                    txtPreBp.Enabled = true;
                    txtPreHdWeight.Enabled = true;
                    txtAccess.Enabled = true;
                    txtComment.Enabled = true;
                    ddlDoctor.Enabled = true;
                    ddlDialReuser.Enabled = true;
                    ddlSalineType.Enabled = true;
                }
            }
            else
            {
                Dialysisclear();
                txtPostBP.Enabled = false;
                txtPostHdWeight.Enabled = false;
                txtDurationofHD.Enabled = false;
                btnClose.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }

    private void Dialysisclear()
    {
        try
        {
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtDurationofHD.Text = "";
            txtUF.Text = "";
            txtQB.Text = "";
            txtQD.Text = "";
            txtNoofHD.Text = "";
            txtHeparin.Text = "";
            txtPreBp.Text = "";
            txtPreHdWeight.Text = "";
            txtPostBP.Text = "";
            txtPostHdWeight.Text = "";
            txtAccess.Text = "";
            txtComment.Text = "";
            ddlDoctor.SelectedIndex = 0;
            ddlDialReuser.SelectedIndex = 0;
            ddlSalineType.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void Disable15min()
    {
        try
        {
            if (lblDialysesNo.Text == "")
            {
                txt15minBp.Enabled = false;
                txt15minHeparin.Enabled = false;
                txt15minTemp.Enabled = false;
                txt15minVp.Enabled = false;
                txt15MinTime.Enabled = false;
            }
            else
            {
                txt15minBp.Enabled = true;
                txt15minHeparin.Enabled = true;
                txt15minTemp.Enabled = true;
                txt15minVp.Enabled = true;
                txt15MinTime.Enabled = true;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Insert(string Time, string BP, string VP, string Temp, string Heparin, string DialysisNo, string PID, string TID)
    {
        try
        {
            string str = "INSERT INTO dial_15minmonitring_chart(DialysisNo,TIME,BP,VP,Heparin,Temp,EntryBy,EntryDate,PatientID,TransactionID)VALUES " +
                             "('" + DialysisNo + "','" + Util.GetDateTime(Time).ToString("HH:mm:ss") + "','" + BP + "','" + VP + "', " +
                              "'" + Temp + "','" + Heparin + "','" + HttpContext.Current.Session["ID"].ToString() + "',Now(),'" + PID + "','" + TID + "')";
            StockReports.ExecuteDML(str);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "2";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Bind15min(string DialysisNo, string PID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT mc.ID,mc.DialysisNo,Date_Format(mc.TIME,'%h:%m %p')Time,mc.Temp,mc.BP,mc.VP,mc.Heparin,(SELECT NAME FROM employee_master em Where em.Employee_ID=mc.EntryBy)NAME,mc.EntryBy,mc.EntryDate FROM  dial_15minmonitring_chart mc INNER JOIN dialysis_monitoring_chart dmc ON dmc.DialysisNo=mc.DialysisNo WHERE mc.DialysisNo='" + DialysisNo + "' AND mc.PatientID='" + PID + "' AND dmc.IsClose=0 ");
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindDialysisDetail(string DialNo, string TID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT mc.ID,mc.DialysisNo,Date_Format(mc.TIME,'%h:%m %p')Time,mc.Temp,mc.BP,mc.VP,mc.Heparin,(SELECT NAME FROM employee_master em Where em.Employee_ID=mc.EntryBy)NAME,mc.EntryBy,mc.EntryDate FROM  dial_15minmonitring_chart mc INNER JOIN dialysis_monitoring_chart dmc ON dmc.DialysisNo=mc.DialysisNo WHERE mc.DialysisNo='" + DialNo + "' AND mc.TransactionID='" + TID + "' AND dmc.IsClose=1 ");
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string BindDetailDialysis(string PID)
    {
        try
        {
            StringBuilder query = new StringBuilder();
            query.Append("SELECT ID,DialysisNo,Date_Format(StartDate,'%d-%m-%Y')StartDate,StartTime,TransactionID,PatientID,isClose, ");
            query.Append("Dur_HD,UF,QB,QD,No_HD,Heparine,Pre_HDBP,Pre_HDWeight,Post_HDBP,Post_HDWeight,(Pre_HDWeight-Post_HDWeight)WeightGain,DialyzerReuser,Access,Remarks, ");
            query.Append("Saline_Tyle,Doctor,(SELECT NAME FROM employee_master em Where em.Employee_ID=dmc.EntryBy)EntryBy FROM dialysis_monitoring_chart dmc  WHERE PatientID='" + PID + "' AND isclose=1 ");
            DataTable dt = StockReports.GetDataTable(query.ToString());
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string Update(string Time, string BP, string VP, string Temp, string Heparin, string ID)
    {
        try
        {
            string str = "UPDATE dial_15minmonitring_chart SET TIME='" + Util.GetDateTime(Time).ToString("HH:mm:ss") + "',BP='" + BP + "',VP='" + VP + "',Heparin='" + Heparin + "',Temp='" + Temp + "' WHERE ID='" + ID + "' ";
            StockReports.ExecuteDML(str);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    protected void btnClose_Click(object sender, EventArgs e)
    {
        try
        {
            string str = "UPDATE dialysis_monitoring_chart SET StartDate='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',StartTime='" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "',Dur_HD='" + txtDurationofHD.Text.Trim() + "',UF='" + txtUF.Text.Trim() + "', " +
                         "QB='" + txtQB.Text.Trim() + "',QD='" + txtQD.Text.Trim() + "',No_HD='" + txtNoofHD.Text.Trim() + "',Heparine='" + txtHeparin.Text.Trim() + "',Pre_HDBP='" + txtPreBp.Text.Trim() + "', " +
                         "Pre_HDWeight='" + txtPreHdWeight.Text.Trim() + "', Post_HDBP='" + txtPostBP.Text + "',Post_HDWeight='" + txtPostHdWeight.Text + "', " +
                         "DialyzerReuser='" + ddlDialReuser.SelectedItem.Text + "',Access='" + txtAccess.Text.Trim() + "',Saline_Tyle='" + ddlSalineType.SelectedItem.Text + "',Doctor='" + ddlDoctor.SelectedItem.Text + "', " +
                         "UpdateBy='" + Session["ID"].ToString() + "',UpdateDate=NOW(),Remarks='" + txtComment.Text.Trim() + "',IsClose=1,CloseBy='" + Session["ID"].ToString() + "',CloseDateTime=Now() " +
                         "WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND ID='" + lblDiID.Text + "'";
            StockReports.ExecuteDML(str);
            ScriptManager.RegisterStartupScript(this, GetType(), "Key", "alert('This Dialysis has Closed');", true);
            BindDialysis();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }

    [WebMethod]
    public static string getTime()
    {
        try
        {
            return System.DateTime.Now.ToString("hh:mm tt");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
}