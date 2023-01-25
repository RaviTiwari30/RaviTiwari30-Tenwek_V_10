using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;
using System.Text;

public partial class Design_IPD_IPDAdmissionDetail : System.Web.UI.Page
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
        string PName = "", CRNo = "", PatientID = "";


        if (txtPatientId.Text.Trim() != "")
        {
            PatientID = txtPatientId.Text.Trim();
        }
        if (txtCRNo.Text.Trim() != "")
        {
            CRNo = "" + txtCRNo.Text.Trim();
        }
        if (txtPName.Text.Trim() != "")
        {
            PName = txtPName.Text.Trim();
        }
        DataTable dt = PatientDetail(PatientID, CRNo, PName);
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

   

    private DataTable PatientDetail(string PatientID, string CRNo, string PName)
    {
        if (CRNo != "")
            CRNo = StockReports.getTransactionIDbyTransNo(CRNo.Trim());//"" +
        
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT  pmh.TransactionID,pmh.TransNo,pip.PatientIPDProfile_ID,pip.PatientID,PM.PName,CONCAT(PM.House_No,'',PM.Street_Name,PM.City)AS Address,ictm.Name AS CaseType,rm.Room_No, pip.RoomID,pmh.Status,pmh.IsDischargeIntimate, ");
        sb.Append("  pmh.IsBilledClosed, IFNULL(pmh.BillNo,'')BillNo,IFNULL(pmh.panelInvoiceNo,'')panelInvoiceNo, pmh.IsBillFreezed , pmh.IsClearance, pmh.IsNurseClean, pmh.IsRoomClean, pmh.IsMedCleared FROM (   ");
        sb.Append("        SELECT pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseTypeID,pip1.IPDCaseTypeID_Bill,pip1.RoomID,pip1.TransactionID,pip1.Status ,pip1.PanelID    ");
        sb.Append("        FROM patient_ipd_profile pip1 INNER JOIN (     ");
        sb.Append("           SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID   FROM patient_ipd_profile  WHERE PatientIPDProfile_ID<>'' AND status<>'Cancel' ");
        if (PatientID != "")
        {
            sb.Append(" AND PatientID='" + PatientID + "'");
        }
        if (CRNo != "")
        {
            sb.Append(" AND TransactionID='" + CRNo + "' ");
        }
        sb.Append("          GROUP BY TransactionID  ");
        sb.Append("            )pip2 ON pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID     )pip    ");
        sb.Append("        INNER JOIN Patient_Medical_History pmh ON pip.TransactionID = pmh.TransactionID ");
        sb.Append("        INNER JOIN room_master rm ON rm.RoomId = pip.roomid INNER JOIN ipd_case_type_master ictm ON PIP.IPDCaseTypeID=ictm.IPDCaseTypeID ");
        sb.Append("        INNER JOIN patient_master PM ON PIP.PatientID=PM.PatientID  WHERE  pmh.status <> 'Cancel' AND pmh.CentreID='" + Session["CentreID"].ToString() + "' ");
        if (PatientID != "")
        {
            sb.Append(" and PIP.PatientID='" + PatientID + "'");
        }
        if (PName != "")
        {
            sb.Append(" and PM.PName like '" + PName + "%'");
        }
        if (CRNo != "")
        {
            sb.Append(" and pmh.TransactionID='" + CRNo + "'");
        }
        sb.Append(" ORDER By pmh.TransactionID");
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
        if (((Label)grdPatientDetail.SelectedRow.FindControl("lblPanelInvoiceNo")).Text != "")
        {
            lblMsg.Text = "Please Cancel Panel Invoice No.";
            return;

        }
        if (((Label)grdPatientDetail.SelectedRow.FindControl("lblIsBilledClosed")).Text == "1")
        {
            lblMsg.Text = "Please Cancel Bill Finalised";
            return;

        }
        if (((Label)grdPatientDetail.SelectedRow.FindControl("lblBillNo")).Text != "")
        {
            lblMsg.Text = "Please Cancel Bill";
            return;

        }
        
        lblRoomID.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblRoomID")).Text;
        lblPatientIPDProfileID.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblPatientIPDProfile_ID")).Text;
        lblIPDNo.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblTransactionID")).Text;
        lblStatus.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblStatus")).Text.ToUpper();
        lblPatientID.Text = ((Label)grdPatientDetail.SelectedRow.FindControl("lblPatientID")).Text;
        if (((Label)grdPatientDetail.SelectedRow.FindControl("lblIsDischargeIntimate")).Text == "0")
        {
            rdbAdmitted.Checked = true;
            rdbAdmitted.Enabled = true;
            rdbDischargeIntimation.Checked = false;
            rdbDischargeIntimation.Enabled = false;
            rdbMedClearance.Checked = false;
            rdbMedClearance.Enabled = false;
            rdbBillFreezed.Checked = false;
            rdbBillFreezed.Enabled = false;
            rdbDischarge.Checked = false;
            rdbDischarge.Enabled = false;
            rdbPatientClearance.Checked = false;
            rdbPatientClearance.Enabled = false;
            rdbNursingClearance.Checked = false;
            rdbNursingClearance.Enabled = false;
            rdbRoomClearance.Checked = false;
            rdbRoomClearance.Enabled = false;
        }
        else if ((((Label)grdPatientDetail.SelectedRow.FindControl("lblIsDischargeIntimate")).Text == "1") && (((Label)grdPatientDetail.SelectedRow.FindControl("lblStatus")).Text.ToUpper() == "IN")&& (((Label)grdPatientDetail.SelectedRow.FindControl("lblIsBillFreezed")).Text == "0"))
        {
            rdbAdmitted.Checked = false;
            rdbAdmitted.Enabled = false;
            rdbDischargeIntimation.Checked = true;
            rdbDischargeIntimation.Enabled = true;
            rdbMedClearance.Checked = false;
            rdbMedClearance.Enabled = false;
            rdbBillFreezed.Checked = false;
            rdbBillFreezed.Enabled = false;
            rdbDischarge.Checked = false;
            rdbDischarge.Enabled = false;
            rdbPatientClearance.Checked = false;
            rdbPatientClearance.Enabled = false;
            rdbNursingClearance.Checked = false;
            rdbNursingClearance.Enabled = false;
            rdbRoomClearance.Checked = false;
            rdbRoomClearance.Enabled = false;
            lblStatus.Text = "Discharge Intimate";
        }
        else if ((((Label)grdPatientDetail.SelectedRow.FindControl("lblIsDischargeIntimate")).Text == "1") && (((Label)grdPatientDetail.SelectedRow.FindControl("lblStatus")).Text.ToUpper() == "OUT"))
        {
            rdbAdmitted.Checked = false;
            rdbAdmitted.Enabled = false;
            rdbDischargeIntimation.Checked = false;
            rdbDischargeIntimation.Enabled = false;
            rdbMedClearance.Checked = false;
            rdbMedClearance.Enabled = false;
            rdbDischarge.Checked = true;
            rdbDischarge.Enabled = true;
            rdbPatientClearance.Checked = false;
            rdbPatientClearance.Enabled = false;
            rdbNursingClearance.Checked = false;
            rdbNursingClearance.Enabled = false;
            rdbRoomClearance.Checked = false;
            rdbRoomClearance.Enabled = false;
        }
         if ((((Label)grdPatientDetail.SelectedRow.FindControl("lblIsBillFreezed")).Text == "1") && (((Label)grdPatientDetail.SelectedRow.FindControl("lblStatus")).Text.ToUpper() == "IN") )
        {
            rdbAdmitted.Checked = false;
            rdbAdmitted.Enabled = false;
            rdbDischargeIntimation.Checked = false;
            rdbDischargeIntimation.Enabled = false;
            rdbMedClearance.Checked = false;
            rdbMedClearance.Enabled = false;
            rdbBillFreezed.Checked = true;
            rdbBillFreezed.Enabled = true;
            rdbDischarge.Checked = false;
            rdbDischarge.Enabled = false;
            rdbPatientClearance.Checked = false;
            rdbPatientClearance.Enabled = false;
            rdbNursingClearance.Checked = false;
            rdbNursingClearance.Enabled = false;
            rdbRoomClearance.Checked = false;
            rdbRoomClearance.Enabled = false;
            lblStatus.Text = "Bill Freezed";
        }
         if ((((Label)grdPatientDetail.SelectedRow.FindControl("lblIsClearance")).Text == "1") && (((Label)grdPatientDetail.SelectedRow.FindControl("lblStatus")).Text.ToUpper() == "OUT"))
         {
             rdbAdmitted.Checked = false;
             rdbAdmitted.Enabled = false;
             rdbDischargeIntimation.Checked = false;
             rdbDischargeIntimation.Enabled = false;
             rdbMedClearance.Checked = false;
             rdbMedClearance.Enabled = false;
             rdbBillFreezed.Checked = false;
             rdbBillFreezed.Enabled = false;
             rdbPatientClearance.Checked = true;
             rdbPatientClearance.Enabled = true;
             rdbDischarge.Checked = false;
             rdbDischarge.Enabled = false;
             rdbNursingClearance.Checked = false;
             rdbNursingClearance.Enabled = false;
             rdbRoomClearance.Checked = false;
             rdbRoomClearance.Enabled = false;
             lblStatus.Text = "Patient Clearance";
         }
         if ((((Label)grdPatientDetail.SelectedRow.FindControl("lblIsNurseClean")).Text == "1") && (((Label)grdPatientDetail.SelectedRow.FindControl("lblStatus")).Text.ToUpper() == "OUT"))
         {
             rdbAdmitted.Checked = false;
             rdbAdmitted.Enabled = false;
             rdbDischargeIntimation.Checked = false;
             rdbDischargeIntimation.Enabled = false;
             rdbMedClearance.Checked = false;
             rdbMedClearance.Enabled = false;
             rdbBillFreezed.Checked = false;
             rdbBillFreezed.Enabled = false;
             rdbDischarge.Checked = false;
             rdbDischarge.Enabled = false;
             rdbPatientClearance.Checked = false;
             rdbPatientClearance.Enabled = false;
             rdbNursingClearance.Checked = true;
             rdbNursingClearance.Enabled = true;
             lblStatus.Text = "Nursing Clearance ";
         }
         if ((((Label)grdPatientDetail.SelectedRow.FindControl("lblIsRoomClean")).Text == "1") && (((Label)grdPatientDetail.SelectedRow.FindControl("lblStatus")).Text.ToUpper() == "OUT"))
         {
           
             rdbAdmitted.Checked = false;
             rdbAdmitted.Enabled = false;
             rdbDischargeIntimation.Checked = false;
             rdbDischargeIntimation.Enabled = false;
             rdbMedClearance.Checked = false;
             rdbMedClearance.Enabled = false;
             rdbBillFreezed.Checked = false;
             rdbBillFreezed.Enabled = false;
             rdbDischarge.Checked = false;
             rdbDischarge.Enabled = false;
             rdbPatientClearance.Checked = false;
             rdbPatientClearance.Enabled = false;
             rdbNursingClearance.Checked = false;
             rdbNursingClearance.Enabled = false;
             rdbRoomClearance.Checked = true;
             rdbRoomClearance.Enabled = true;
             lblStatus.Text = "Room Clearance ";
         }
         if ((((Label)grdPatientDetail.SelectedRow.FindControl("lblIsMedCleared")).Text == "1") && (((Label)grdPatientDetail.SelectedRow.FindControl("lblStatus")).Text.ToUpper() == "IN") && (((Label)grdPatientDetail.SelectedRow.FindControl("lblIsBillFreezed")).Text == "0"))
         {

             rdbAdmitted.Checked = false;
             rdbAdmitted.Enabled = false;
             rdbDischargeIntimation.Checked = false;
             rdbDischargeIntimation.Enabled = false;
             rdbMedClearance.Checked = true;
             rdbMedClearance.Enabled = true;
             rdbBillFreezed.Checked = false;
             rdbBillFreezed.Enabled = false;
             rdbDischarge.Checked = false;
             rdbDischarge.Enabled = false;
             rdbPatientClearance.Checked = false;
             rdbPatientClearance.Enabled = false;
             rdbNursingClearance.Checked = false;
             rdbNursingClearance.Enabled = false;
             rdbRoomClearance.Checked = false;
             rdbRoomClearance.Enabled = false;
             lblStatus.Text = "Medical Clearance ";
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
            string BillNo = StockReports.ExecuteScalar(" SELECT CONCAT(IFNULL(BillNo,''),'#',IsBilledClosed,'#',IFNULL(panelInvoiceNo,''))BillNo FROM Patient_Medical_History WHERE TransactionID='" + lblIPDNo.Text.Trim() + "' ");
            if (BillNo.Split('#')[2] != "")
            {
                lblMsg.Text = "Please Cancel Panel Invoice No.";
                return;
            }
            if (BillNo.Split('#')[1] == "1")
            {
                lblMsg.Text = "Please Cancel Bill Finalised";
                return;
            }
            if (BillNo.Split('#')[0] != "")
            {
                lblMsg.Text = "Please Cancel Bill";
                return;
            }
           
            
            if (rdbDischarge.Checked == true)
            {
                string TID = StockReports.ExecuteScalar("Select REPLACE(TransactionID,'','')TID from patient_ipd_profile where RoomID='" + lblRoomID.Text + "' and status='IN'");
                if (TID.ToString() != "")
                {
                    lblMsg.Text = "Bed already occupied by patient IPD No. -(" + TID.ToString() + ")";
                    return;
                }
            }        
            StringBuilder sb = new StringBuilder();
            if (rdbAdmitted.Checked)
            {
                sb.Clear();
                sb.Append(" UPDATE Patient_Medical_History ich INNER JOIN patient_ipd_profile pip ON ich.TransactionID=pip.TransactionID  INNER JOIN room_master rm ON pip.`RoomID`=rm.`RoomID`  set ");
                sb.Append("  ich.AdmissionCancelledBy  ='" + Session["ID"].ToString() + "',ich.AdmissionCancelReason  ='" + txtCancelReason.Text.Trim() + "', ");
                sb.Append("  ich.AdmissionCancelDate  =NOW(), ich.Status='Cancel', pip.Status='Cancel',pip.TobeBill=2,rm.`IsRoomClean`=1");
                sb.Append("  WHERE pip.PatientIPDProfile_ID='" + lblPatientIPDProfileID.Text + "' AND ich.TransactionID='" + lblIPDNo.Text + "' AND pip.Status='IN'");                               
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            }
            else if (rdbDischargeIntimation.Checked)
            {
                sb.Clear();
                sb.Append(" update Patient_Medical_History ich INNER JOIN patient_ipd_profile pip ON ich.TransactionID=pip.TransactionID ");
                sb.Append(" set ich.IsDischargeIntimate=0,pip.IsDisIntimated=0,DisIntimateReason='" + txtCancelReason.Text.Trim() + "',DisIntimateBy='" + Session["ID"].ToString() + "' WHERE  ich.TransactionID='" + lblIPDNo.Text + "' AND pip.Status='IN' ");
                sb.Append(" AND pip.PatientIPDProfile_ID='" + lblPatientIPDProfileID.Text + "' ");
               
               MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
               StringBuilder sb1 = new StringBuilder();
               sb1.Append("Insert into f_dischargeintimate (TransactionID,PatientID,CancelReason,dtCancel,CancelUser,IsCancel) values ( ");
               sb1.Append(" '" + lblIPDNo.Text + "','"+ lblPatientID.Text +"','" + txtCancelReason.Text.Trim() + "',NOW(),'"+ Session["ID"].ToString() +"',1 ) ");
               MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb1.ToString());
            }
            else if (rdbDischarge.Checked)
            {
                  sb.Clear();
                  sb.Append(" update Patient_Medical_History ich INNER JOIN patient_ipd_profile pip ON ich.TransactionID=pip.TransactionID set ");
                  sb.Append(" ich.DischargedCancelledBy ='" + Session["ID"].ToString() + "',ich.DischargeCancelReason ='" + txtCancelReason.Text.Trim() + "',ich.DischargeCancelDate =NOW(),  ");
                  sb.Append(" DateOfDischarge='0001-01-01',ich.TimeOfDischarge='00:00:00', ich.Status='IN',pip.Status='IN',pip.EndDate='0001-01-01',pip.EndTime='00:00:00' ");
                  sb.Append(" WHERE  ich.TransactionID='" + lblIPDNo.Text + "' AND pip.PatientIPDProfile_ID='" + lblPatientIPDProfileID.Text + "'");
                
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
               
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, " UPDATE diet_patientdiet_detail SET enddate='0000-00-00',EndTime='00:00:00'  WHERE TransactionID='" + lblIPDNo.Text + "' AND CurrentStatus=1	");
            }
            else if (rdbMedClearance.Checked)
            {
                sb.Clear();

                sb.Append("update Patient_Medical_History Set IsMedCleared=0,BillingRemarks = concat(BillingRemarks,'" + txtCancelReason.Text.Trim() + "') where TransactionID='" + lblIPDNo.Text + "'");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            }
            else if (rdbBillFreezed.Checked)
            {
                sb.Clear();
                sb.Append("Update Patient_Medical_History Set IsBillFreezed=0, BillFreezedTimeStamp = '0001-01-01 00:00:00',BillFreezedUser=''  where TransactionID='" + lblIPDNo.Text + "'");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            }
            else if (rdbPatientClearance.Checked)
            {
                sb.Clear();
                sb.Append("Update Patient_Medical_History Set IsClearance=0,ClearanceTimeStamp = '0001-01-01 00:00:00',ClearanceRemark='',ClearanceUserID='' where TransactionID='" + lblIPDNo.Text + "'");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            }

            else if (rdbNursingClearance.Checked)
            {
                sb.Clear();
                sb.Append("Update Patient_Medical_History Set IsNurseClean=0, NurseCleanTimeStamp = '0001-01-01 00:00:00',NurseCleanUserID='' where TransactionID='" + lblIPDNo.Text + "'");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            }
            else if (rdbRoomClearance.Checked)
            {
                sb.Clear();
                sb.Append("Update Patient_Medical_History Set IsRoomClean=0, RoomCleanTimeStamp = '0001-01-01 00:00:00',RoomCleanUserID='' where TransactionID='" + lblIPDNo.Text + "'");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
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
