using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CPOE_Patient_Referal_Form : System.Web.UI.Page
{
    string PID = "";
    string TID = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.QueryString["TransactionID"] != null)
        {
            spnTransactionID.InnerText = Request.QueryString["TransactionID"].ToString();
            spnPatientID.InnerText = Request.QueryString["PatientID"].ToString();

            PID = Request.QueryString["PatientID"].ToString();
            TID = Request.QueryString["TransactionID"].ToString();
        }

        if (!IsPostBack)
        {
            getData(PID, TID);
        }


    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (string.IsNullOrEmpty(txtRefMsg.Text))
        {
            lblMsg.Text = "Enter Reffering Message";
            return;
        }
        if (string.IsNullOrEmpty(txtReferralConsultants.Text))
        {
            lblMsg.Text = "Enter Referral Consultants";
            return;
        }
        if (string.IsNullOrEmpty(txtHosRefereTo.Text))
        {
            lblMsg.Text = "Enter Name Of the Hospital refered To";
            return;
        }
        if (string.IsNullOrEmpty(txtReferringConsultant.Text))
        {
            lblMsg.Text = "Enter Referring Consultant";
            return;
        }
        else
        {
            lblMsg.Text = "";
        }

        DataTable dt = StockReports.GetDataTable("SELECT * FROM tenwek_patient_refferal pr WHERE pr.PatientId='" + PID + "' AND pr.TransactionId='" + TID + "'");

        if (dt.Rows.Count > 0)
        {
            getData(PID, TID);
            lblMsg.Text = "The Patient Reffer Form Is Already Filled";
            return;
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  tenwek_patient_refferal ");
            sb.Append("  (PatientId,TransactionId,RefMsg, ");
            sb.Append(" NameOfHosRefTo,RefferalConsultant, ");
            sb.Append(" ResionOfRefferal,RefferingConsultent, ");
            sb.Append(" IsActive,EnterBy) ");
            sb.Append(" VALUES (@PatientId,@TransactionId,@RefMsg, ");
            sb.Append(" @NameOfHosRefTo,@RefferalConsultant, ");
            sb.Append(" @ResionOfRefferal,@RefferingConsultent, ");
            sb.Append(" @IsActive,@EnterBy) ");
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                PatientId = Util.GetString(PID),
                TransactionId = Util.GetString(TID),
                RefMsg = Util.GetString(txtRefMsg.Text),
                NameOfHosRefTo = Util.GetString(txtHosRefereTo.Text),
                RefferalConsultant = Util.GetString(txtReferralConsultants.Text),
                ResionOfRefferal = Util.GetString(txtReasonforReferral.Text),
                RefferingConsultent = Util.GetString(txtReferringConsultant.Text),
                IsActive = Util.GetInt(1),
                EnterBy = Util.GetString(HttpContext.Current.Session["ID"].ToString())
            });

            tnx.Commit();
            getData(PID, TID);
            if (A == 1)
            {
                lblMsg.Text = "Record Save Successfully";
            }

        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error Occured Contact to Administrator";
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    public void getData(string Pid, string Tid)
    {
        DataTable dt = StockReports.GetDataTable("SELECT * FROM tenwek_patient_refferal pr WHERE pr.PatientId='" + Pid + "' AND pr.TransactionId='" + Tid + "' Order By Id Desc");

        if (dt.Rows.Count > 0)
        {
            txtRefMsg.Text = dt.Rows[0]["RefMsg"].ToString();
            txtHosRefereTo.Text = dt.Rows[0]["NameOfHosRefTo"].ToString();
            txtReferralConsultants.Text = dt.Rows[0]["RefferalConsultant"].ToString();
            txtReasonforReferral.Text = dt.Rows[0]["ResionOfRefferal"].ToString();
            txtReferringConsultant.Text = dt.Rows[0]["RefferingConsultent"].ToString();
            btnUpdate.Visible = true;
            btnPrint.Visible = true;
            btnSave.Visible = false;
        }
        else
        {
            btnUpdate.Visible = false;
            btnPrint.Visible = false;
            btnSave.Visible = true;
        }

    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {

        StringBuilder Sb = new StringBuilder();
        Sb.Append("  SELECT pm.PatientID,pm.Mobile,pm.Age,pm.Gender,CONCAT(pm.Age,'/',pm.Gender)AgeSex , ");
        Sb.Append("  CONCAT(dm.Title,' ',dm.NAME)DrName,pr.RefMsg,pr.NameOfHosRefTo,pr.RefferalConsultant, ");
        Sb.Append("  pr.RefferingConsultent,pr.ResionOfRefferal,pr.TransactionId,''Signature, ");
        Sb.Append("  CONCAT(dm.Title,' ',dm.NAME)EmpName, pr.EnterDate,pnlm.Company_Name,CONCAT(pm.Title,'',pm.PName)PName  ");
        Sb.Append("  FROM tenwek_patient_refferal pr  ");
        Sb.Append("  INNER JOIN  patient_master pm ON pm.PatientID =pr.PatientId ");
        Sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.PatientID=pm.PatientID AND pmh.TransactionID=pr.TransactionId ");
        Sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        Sb.Append("  INNER JOIN employee_master em ON em.EmployeeID=pr.EnterBy ");
        Sb.Append("  INNER JOIN f_panel_master pnlm ON pnlm.PanelID=pmh.PanelID ");

        Sb.Append("  WHERE pr.IsActive=1 AND pr.PatientId='" + PID + "' AND pr.TransactionId='" + TID + "' ");


        DataTable dt = StockReports.GetDataTable(Sb.ToString());

        StringBuilder sb = new StringBuilder();

        sb.Append("    SELECT  t.IcdCode,t.Description FROM patient_master pm ");
        sb.Append(" LEFT JOIN ( ");
        sb.Append(" SELECT icd.ICD10_Code IcdCode,icd.WHO_Full_Desc Description,cpoe.PatientID FROM cpoe_10cm_patient cpoe ");
        sb.Append(" INNER JOIN icd_10_new icd ON icd.ICD10_Code=cpoe.ICD_Code ");
        sb.Append(" WHERE cpoe.IsActive=1 AND cpoe.TransactionID='" + TID + "' AND cpoe.PatientID='" + PID + "' ");
        sb.Append(" )t ON t.PatientID=pm.PatientID ");
        sb.Append(" WHERE pm.PatientID='" + PID + "'  ");
        DataTable dt1 = StockReports.GetDataTable(sb.ToString());

        DataSet ds = new DataSet();
        if (dt.Rows.Count > 0)
        {

            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "PatientRefferingDetails";

            ds.Tables.Add(dt1.Copy());
            ds.Tables[1].TableName = "Drugs";

            DataTable dtImg = new DataTable();
            dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[2].TableName = "Header";


           // ds.WriteXml("E:/P.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "PatientReferalForm";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }

    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txtRefMsg.Text))
        {
            lblMsg.Text = "Enter Reffering Message";
            return;
        }
        if (string.IsNullOrEmpty(txtReferralConsultants.Text))
        {
            lblMsg.Text = "Enter  Referral Consultants";
            return;
        }
        if (string.IsNullOrEmpty(txtHosRefereTo.Text))
        {
            lblMsg.Text = "Enter   Name Of the Hospital refered To";
            return;
        }
        if (string.IsNullOrEmpty(txtReferringConsultant.Text))
        {
            lblMsg.Text = "Enter  Referring Consultant";
            return;
        }
        else
        {
            lblMsg.Text = "";
        }


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sb = new StringBuilder();


            sb.Append(" Update tenwek_patient_refferal ");
            sb.Append(" set RefMsg=@RefMsg, ");
            sb.Append(" NameOfHosRefTo=@NameOfHosRefTo,RefferalConsultant=@RefferalConsultant, ");
            sb.Append(" ResionOfRefferal=@ResionOfRefferal,RefferingConsultent=@RefferingConsultent, ");
            sb.Append(" UpdateBy=@UpdateBy,UpdatedBy=NOW() where PatientId=@PatientId and TransactionId=@TransactionId   ");
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                PatientId = Util.GetString(PID),
                TransactionId = Util.GetString(TID),
                RefMsg = Util.GetString(txtRefMsg.Text),
                NameOfHosRefTo = Util.GetString(txtHosRefereTo.Text),
                RefferalConsultant = Util.GetString(txtReferralConsultants.Text),
                ResionOfRefferal = Util.GetString(txtReasonforReferral.Text),
                RefferingConsultent = Util.GetString(txtReferringConsultant.Text),
                IsActive = Util.GetInt(1),
                UpdateBy = Util.GetString(HttpContext.Current.Session["ID"].ToString())
            });

            tnx.Commit();
            getData(PID, TID);
            if (A == 1)
            {
                lblMsg.Text = "Record Updated Successfully";
            }

        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error Occured Contact to Administrator.";
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}