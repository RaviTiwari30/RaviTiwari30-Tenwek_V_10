using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Emergency_EmergencyDischarge : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            string App_ID = Request.QueryString["App_ID"].ToString();
            ViewState["RoomID"] = Request.QueryString["RoomID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();


            string Count = Util.GetString(StockReports.ExecuteScalar(" SELECT CONCAT(pmh.Status,'#',pmh.DischargeType)Status FROM patient_medical_history pmh WHERE pmh.TransactionID='" + ViewState["TID"].ToString() + "' "));
            if (Count.Split('#')[0]!="IN")
            {
                lblMsg.Text = "Patient Already Discharged";
                btnDischarge.Visible = false;
                ddlType.SelectedItem.Text = Count.Split('#')[1];
            }
        }
        txtDate.Attributes.Add("readOnly", "readOnly");
    }
    protected void btnDischarge_Click(object sender, EventArgs e)
    {
        try
        {
            string CheckDiagnosis = Util.GetString(StockReports.ExecuteScalar(" SELECT Count(*) FROM cpoe_10cm_patient icdp where icdp.IsActive=1 AND icdp.TransactionID='" + ViewState["TID"].ToString() + "' and IsActive=1"));
            if (CheckDiagnosis != "0")
            {
                // StockReports.ExecuteDML(" Update Appointment set EmerDischargeDate='" + string.Concat(Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd"), ' ', Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss")) + "',EmerIsDischarge='1',EmerDischargeType='" + ddlType.SelectedItem.Text + "',EmerDischargeBy='" + Session["ID"].ToString() + "',EmerDisEntryDate=Now() where App_ID='" + Request.QueryString["App_ID"].ToString() + "' ");
                StockReports.ExecuteDML("UPDATE patient_medical_history pmh SET pmh.IsDischargeIntimate=1,PMH.DischargeIntimateBy='" + Session["ID"].ToString() + "',pmh.DischargedBy='" + Session["ID"].ToString() + "',pmh.DateOfDischarge='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',pmh.TimeOfDischarge='" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "',DischargeType ='" + ddlType.SelectedItem.Text + "', STATUS='OUT' WHERE pmh.TransactionID='" + ViewState["TID"].ToString() + "'");
                StockReports.ExecuteDML(" UPDATE room_master SET IsRoomClean=1 WHERE roomid='" + ViewState["RoomID"].ToString() + "' ");

                if (ddlType.SelectedItem.Text == "Death")
                {
                    string TimeOfDeath = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss");
                    StockReports.ExecuteDML("UPDATE patient_medical_history pmh SET pmh.TypeOfDeathID='1', pmh.TimeOfDeath='" + TimeOfDeath + "' WHERE pmh.TransactionID='" + ViewState["TID"].ToString() + "'");
                }
                lblMsg.Text = "Discharged Successfully";
                btnDischarge.Visible = false;
            }
            else { lblMsg.Text = " Please Enter Final Diagnosis Information. After that, you can discharge. "; }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
    }
}