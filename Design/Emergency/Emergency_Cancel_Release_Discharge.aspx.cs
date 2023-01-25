
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;
using System.Text;

public partial class Design_Emergency_Emergency_Cancel_Release_Discharge : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPatientId.Focus();
        }
    }
    private void Search()
    {
        lblMsg.Text = "";
        string PName = "", EMGNo = "", PatientID = "";


        if (txtPatientId.Text.Trim() != "")
        {
            PatientID = txtPatientId.Text.Trim();
        }
        if (txtEMGNo.Text.Trim() != "")
        {
            EMGNo = "" + txtEMGNo.Text.Trim();
        }
        if (txtPName.Text.Trim() != "")
        {
            PName = txtPName.Text.Trim();
        }
        DataTable dt = PatientDetail(PatientID, PName, EMGNo, "", "", "", "", "", "");
        if (dt != null && dt.Rows.Count > 0)
        {
            grdPatientDetail.DataSource = dt;
            grdPatientDetail.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            grdPatientDetail.DataSource = null;
            grdPatientDetail.DataBind();
            pnlHide.Visible = false;

        }
    }



    private DataTable PatientDetail(string MRNo, string PName, string EmergencyNo, string PanelId, string fromDate, string toDate, string Status, string TriageCode, string WaitingType)
    {
        
        StringBuilder sb = new StringBuilder();

       
       
            sb.Append(" SELECT IF(epd.IsReleased='1',IFNULL((Select  CONCAT(em.Title,' ',em.NAME)ReleasedBy from Employee_Master where EmployeeID=epd.ReleasedBy),''),'')ReleasedBy,IFNULL(IF(pmh.STATUS='OUT',CONCAT(em.Title,' ',em.NAME),''),'')DischargedBy,IFNULL(CONCAT(DATE_FORMAT(pmh.`DateOfAdmit`,'%d-%b-%Y'),' ',DATE_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')),'')DOA,IF(pmh.STATUS='OUT',IFNULL(CONCAT(DATE_FORMAT(pmh.`DateOfDischarge`,'%d-%b-%Y'),' ',DATE_FORMAT(pmh.TimeOfDischarge,'%h:%i %p')),''),'')DischargeDatetime,IF(epd.IsReleased='1',IFNULL(DATE_FORMAT(epd.`ReleasedDateTime`,'%d-%b-%Y %h:%i %p'),''),'')'ReleasedDateTime',IF(pmh.STATUS='OUT','Yes','No')DischargeStatus,IF(epd.IsReleased='1','Yes','No')ReleaseStatus, pmh.TransactionID,pmh.CentreID,pm.`PatientID`,epd.`EmergencyNo`,CONCAT(pm.`Title`,' ',pm.`PName`)'Name',CONCAT(pm.`Age`,'/',SUBSTR(pm.`Gender`,1,1))'AgeSex',Date_Format(pm.DOB,'%d-%b-%Y') DOB ");
            sb.Append(" FROM Emergency_Patient_Details epd  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=epd.`TransactionId` ");
            if (!String.IsNullOrEmpty(EmergencyNo))
                sb.Append(" AND epd.`EmergencyNo`='" + EmergencyNo.Trim() + "' ");
            sb.Append(" INNER JOIN `patient_master` pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append(" left JOIN Employee_Master em ON pmh.DischargedBy=em.EmployeeID ");
            
            if (!String.IsNullOrEmpty(MRNo))
                sb.Append("  AND pmh.`PatientID`='" + Util.GetFullPatientID(MRNo.Trim()) + "' ");

            sb.Append(" WHERE pmh.Type='EMG' AND pmh.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
            
            sb.Append(" AND ( pmh.STATUS='OUT' OR epd.IsReleased='1') ");
            //          
            sb.Append("  GROUP BY epd.TransactionId Order by epd.ID Desc");
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;

    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        Search();

    }
    protected void grdPatientDetail_SelectedIndexChanged(object sender, EventArgs e)
    {
        txtCancelReason.Text = "";
        lblMsg.Text = "";
        
        
        lblEMGNo.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblEMGNo")).Text;
        lblTransactionID.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblTransactionID")).Text;
        lblDischargeStatus.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblDischargeStatus")).Text.ToUpper();
        lblPatientName.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblPatientName")).Text.ToUpper();
        lblReleaseStatus.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblReleaseStatus")).Text.ToUpper();
        lblPatientID.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblPatientID")).Text;

        if ((lblDischargeStatus.Text == "YES") && (lblReleaseStatus.Text == "YES"))
        {
            rdbRelease.Checked = true;
            rdbDischarge.Enabled = false;
            rdbDischarge.Checked = false;
            rdbRelease.Enabled = true;
        }
        if ((lblDischargeStatus.Text == "YES") && (lblReleaseStatus.Text == "NO"))
        {
            rdbDischarge.Checked = true;
            rdbRelease.Checked = false;
            rdbRelease.Enabled = false;
            rdbDischarge.Enabled = true;
        }

        mpDetail.Show();

    }


    protected void btnCancel_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            if (txtCancelReason.Text.Trim() == "")
            {
                lblmsgpopup.Text = "Please Enter Cancel Reason";
                txtCancelReason.Focus();
                mpDetail.Show();
                return ;
            }
            
           
            
                    
            StringBuilder sb = new StringBuilder();
            if (rdbRelease.Checked)
            {
                string isreleased = Util.GetString(StockReports.ExecuteScalar(" SELECT IsReleased FROM Emergency_Patient_Details icdp where TransactionID='" + lblTransactionID.Text + "' "));
                if (isreleased == "0")
                {
                    lblMsg.Text = "Patient is already not released.";
                    Tranx.Rollback();
            
                }
                StockReports.ExecuteDML(" UPDATE Emergency_Patient_Details epd SET epd.`IsReleased`=0 WHERE epd.`TransactionId`='" + lblTransactionID.Text + "' ");
                
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, " INSERT INTO EMG_Release_Cancel_Detail(CancelledBy,CancelledDate,Reason,EmergencyNo,TransactionID) VALUES('" + Session["ID"].ToString() + "',NOW(),'" + txtCancelReason.Text + "','" + lblEMGNo.Text + "','"+lblTransactionID.Text+"');");
            
            }
            if(rdbDischarge.Checked)
            {
                string isIN = Util.GetString(StockReports.ExecuteScalar(" SELECT STATUS FROM patient_medical_history  where TransactionID='" + lblTransactionID.Text + "' "));
                if (isIN == "IN")
                {
                    lblMsg.Text = "Patient is already IN.";
                    Tranx.Rollback();

                }
                StockReports.ExecuteDML("UPDATE patient_medical_history pmh SET  STATUS='IN' WHERE pmh.TransactionID='" + lblTransactionID.Text + "'");
                
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, " INSERT INTO EMG_Discharge_Cancel_Detail(CancelledBy,CancelledDate,Reason,EmergencyNo,TransactionID) VALUES('" + Session["ID"].ToString() + "',NOW(),'" + txtCancelReason.Text + "','" + lblEMGNo.Text + "','" + lblTransactionID.Text + "');");
            
            }
            
            Tranx.Commit();
            grdPatientDetail.DataSource = null;
            grdPatientDetail.DataBind();
            mpDetail.Hide();
            lblMsg.Text = "Record Updated Successfully";
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error occurred, Please contact administrator";
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


}
