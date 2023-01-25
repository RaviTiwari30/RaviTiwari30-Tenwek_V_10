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


public partial class Design_IPD_RoomClearance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));

            if (dtAuthority.Rows.Count > 0)
            {
                if (dtAuthority.Rows[0]["IsRoomClearance"].ToString() == "0")
                {
                    string Msg = "You Are Not Authorised To Room Clearance...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                }
                else
                {
                    if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
                    {
                        ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
                        ViewState["ID"] = Session["ID"].ToString();
                        CheckRoomClearance();
                        string validateDischargeProcess = IPDBilling.ValidateDischargeSteps((int)AllGlobalFunction.DischargeProcessStep.RoomClearance, ViewState["TransactionID"].ToString());
                        if (String.IsNullOrEmpty(validateDischargeProcess))
                        {
                            btnSave.Enabled = true;
                            lblMsg.Text = "";
                        }
                        else
                        {
                            btnSave.Enabled = false;
                            lblMsg.Text = validateDischargeProcess;
                        }
                    }
                }
            }
            else
            {
                //if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
                //{
                //    ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
                //    ViewState["ID"] = Session["ID"].ToString();
                //    CheckPatientClearance();
                //}

                string Msg = "You Are Not Authorised To Room Clearance...";
                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            }
        }
    }
 
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT pip.PatientIPDProfile_ID,rm.RoomId,rm.Room_No,rm.Bed_No,ctm.Name,pip.TransactionID FROM patient_ipd_profile pip  ");
            sb.Append("  INNER JOIN room_master rm ON pip.RoomID=rm.RoomId ");
            sb.Append("  INNER JOIN ipd_case_type_master ctm ON pip.IPDCaseTypeID=ctm.IPDCaseTypeID ");
            sb.Append("  WHERE pip.Status='OUT' AND TransactionID='" + ViewState["TransactionID"].ToString() + "' order by pip.PatientIPDProfile_ID desc limit 1 ");

            DataTable dtroomdetail = StockReports.GetDataTable(sb.ToString());
            if (dtroomdetail.Rows.Count > 0)
            {
                string SqlRM = " UPDATE room_master SET IsRoomClean=1 WHERE RoomId='" + dtroomdetail.Rows[0]["RoomId"].ToString() + "' ";
                //StockReports.ExecuteDML(SqlRM);
                MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, SqlRM);
                string SqlAdj = " UPDATE patient_medical_history SET IsRoomClean=1,RoomCleanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',RoomCleanUserID='" + ViewState["ID"].ToString() + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";//f_ipdAdjustment
                //StockReports.ExecuteDML(SqlAdj);
                MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, SqlAdj);

                //string skipStepIDs = IPDBilling.getDischargeSkipSteps(objtnx, (int)AllGlobalFunction.DischargeProcessStep.RoomClearance);
                //if (!String.IsNullOrEmpty(skipStepIDs))
                //{
                //    AllUpdate objUpdate = new AllUpdate(objtnx);
                //    bool updateStatus = objUpdate.UpdateDischargeProcessStep(ViewState["TransactionID"].ToString(), Util.GetString(ViewState["ID"]), skipStepIDs);
                //    if (!updateStatus)
                //    {
                //        objtnx.Rollback();

                //    }
                //}

                objtnx.Commit();

                lblMsg.Text = "Room Clearance Saved Successfully..";
                MainDiv.Visible = false;
            }
            
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

    private void CheckPatientClearance()
    {
        string IsClearance = "";
        IsClearance = StockReports.ExecuteScalar(" SELECT IsNurseClean FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");//f_ipdadjustment
        if (IsClearance != "1")
        {
            lblMsg.Text = "Kindly Nurse Clearance First..";
            MainDiv.Visible = false;
        }
        else
        {
            CheckRoomClearance();
        }
    }
    private void CheckRoomClearance()
    {
        string IsRoomClean = "";
        IsRoomClean = StockReports.ExecuteScalar(" SELECT IsRoomClean FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");//f_ipdadjustment
        if (IsRoomClean == "1")
        {
            string Msg = "Patient Room Clearance Already Done...";
            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            lblMsg.Text = "Room Clearance Already Done..";
            MainDiv.Visible = false;
        }
        else
        {
            lblMsg.Text = "";
            MainDiv.Visible = true;
        }
    }
}
   