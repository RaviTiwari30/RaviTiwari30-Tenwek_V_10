using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.Collections.Generic;


public partial class Design_IPD_PatientClearance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));

            if (dtAuthority.Rows.Count > 0)
            {
                if (dtAuthority.Rows[0]["IsPatientClearance"].ToString() == "0")
                {
                    string Msg = "You Are Not Authorised To Patient Clearance...";
                  Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                   //lblMsg.Text = Msg;
                    //btnSave.Enabled = true;
                }
            //    else
            //    {
            //        if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
            //        {
            //            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            //            ViewState["ID"] = Session["ID"].ToString();
            //            CheckClearance();
            //            string validateDischargeProcess = IPDBilling.ValidateDischargeSteps((int)AllGlobalFunction.DischargeProcessStep.PatientClearance, ViewState["TransactionID"].ToString());
            //            if (String.IsNullOrEmpty(validateDischargeProcess))
            //            {
            //                btnSave.Enabled = true;
            //            }
            //            else
            //            {
            //                btnSave.Enabled = false;
            //                lblMsg.Text = validateDischargeProcess;
            //            }
            //        }
            //    }
            }
            //else
            //{
            //    //if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
            //    //{
            //    //    ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            //    //    ViewState["ID"] = Session["ID"].ToString();
            //    //    CheckBill();
            //    //}

            //    string Msg = "You Are Not Authorised To Patient Clearance...";
            //    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            //}
            if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
            {

                ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
                ViewState["ID"] = Session["ID"].ToString();
                string Isdischarge = "";
                Isdischarge = StockReports.ExecuteScalar(" SELECT STATUS FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");
                if (Isdischarge != "OUT")
                {      string Msg = "Please Discharge The Patient !!!";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg); 
                }

                CheckClearance();
               btnSave.Enabled = true;
               
            }
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string Sql = "";
        if (txtNaration.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Naration..";
            txtNaration.Focus();
            return;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            Sql = " UPDATE patient_medical_history SET IsClearance=1,ClearanceRemark='" + txtNaration.Text.Trim() + "',ClearanceTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',ClearanceUserID='" + ViewState["ID"].ToString() + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";//f_ipdAdjustment
        MySqlHelper.ExecuteNonQuery(objtnx,CommandType.Text,Sql);
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('PatientClearanceSlip.aspx?IPNO=" + ViewState["TransactionID"].ToString() + "');", true);

        lblMsg.Text = "Patient Clearance Saved Successfully..";
        btnReprint.Visible = false;
        //string PlanStatus = "";
        //PlanStatus = StockReports.ExecuteScalar(" SELECT PlanStatus FROM f_ipdadjustment WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' and IsPlannedType=2 ");
        //if (PlanStatus == "Lama" || PlanStatus == "Discharge On Request" || PlanStatus == "Expired" || PlanStatus == "Cancelled" || PlanStatus == "Absconding" || PlanStatus == "Patient On Leave")
        //{
        //    StringBuilder sb = new StringBuilder();
        //    sb.Append("  SELECT pip.PatientIPDProfile_ID,rm.Room_Id,rm.Room_No,rm.Bed_No,ctm.Name,pip.TransactionID FROM patient_ipd_profile pip  ");
        //    sb.Append("  INNER JOIN room_master rm ON pip.Room_ID=rm.Room_Id ");
        //    sb.Append("  INNER JOIN ipd_case_type_master ctm ON pip.IPDCaseType_ID=ctm.IPDCaseType_ID ");
        //    sb.Append("  WHERE pip.Status='OUT' AND TransactionID='" + ViewState["TransactionID"].ToString() + "' order by pip.PatientIPDProfile_ID desc limit 1 ");

        //    DataTable dtroomdetail = StockReports.GetDataTable(sb.ToString());
        //    if (dtroomdetail.Rows.Count > 0)
        //    {
        //        string SqlNC = " UPDATE f_ipdAdjustment SET IsNurseClean=1,NurseCleanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',NurseCleanUser='" + ViewState["ID"].ToString() + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";
        //        StockReports.ExecuteDML(SqlNC);
        //        string SqlRM = " UPDATE room_master SET IsRoomClean=1 WHERE Room_Id='" + dtroomdetail.Rows[0]["Room_Id"].ToString() + "' ";
        //        StockReports.ExecuteDML(SqlRM);
        //        string SqlAdj = " UPDATE f_ipdAdjustment SET IsRoomClean=1,RoomCleanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',RoomCleanUser='" + ViewState["ID"].ToString() + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";
        //        StockReports.ExecuteDML(SqlAdj);
        //        lblMsg.Text = "Room Clearance Saved Successfully..";
        //        MainDiv.Visible = false;
        //    }
        //}
        //else
        //{
            // Update skipped steps in discharge process
            //string skipStepIDs = "'" + (int)AllGlobalFunction.DischargeProcessStep.NursingClearance + "'," +
            //                     "'" + (int)AllGlobalFunction.DischargeProcessStep.RoomClearance + "'";
            string skipStepIDs = IPDBilling.getDischargeSkipSteps(objtnx, (int)AllGlobalFunction.DischargeProcessStep.PatientClearance);
            if (!String.IsNullOrEmpty(skipStepIDs))
            {
                AllUpdate objUpdate = new AllUpdate(objtnx);
                bool updateStatus = objUpdate.UpdateDischargeProcessStep(ViewState["TransactionID"].ToString(), Util.GetString(ViewState["ID"]), skipStepIDs);
                if (!updateStatus)
                {
                    objtnx.Rollback();

                }
            }
            //AllUpdate objUpdate = new AllUpdate();
            //objUpdate.UpdateDischargeProcessStep(ViewState["TransactionID"].ToString(), ViewState["ID"].ToString(), skipStepIDs);
            ////
        //}

        MainDiv.Visible = false;
        objtnx.Commit();
        }
        catch (Exception ex)
        {
            objtnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Visible = true;
            lblMsg.Text = "Error..";
        }
        finally
        {
            objtnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void CheckBill()
    {
        string IsBill = "";
        IsBill = StockReports.ExecuteScalar(" SELECT BillNo FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");//f_ipdadjustment
        if (IsBill == "")
        {
            lblMsg.Text = "Kindly Bill Generate First..";
            MainDiv.Visible = false;
        }
        else
        {
            CheckClearance();
        }
    }

    private void CheckClearance()
    {
        string IsClearance = "";
        IsClearance = StockReports.ExecuteScalar(" SELECT IsClearance FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");//f_ipdadjustment
        if (IsClearance == "1")
        {
            //string Msg = "Patient Clearance Already Done.....";
         //   Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            lblMsg.Text = "Patient Clearance Already Done..";
            MainDiv.Visible = false;
            btnReprint.Visible = false;
        }
        else
        {
            lblMsg.Text = "";
            MainDiv.Visible = true;
            btnReprint.Visible = false;
        }
    }
    protected void btnReprint_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('PatientClearanceSlip.aspx?IPNO=" + ViewState["TransactionID"].ToString() + "');", true);
    }
}
