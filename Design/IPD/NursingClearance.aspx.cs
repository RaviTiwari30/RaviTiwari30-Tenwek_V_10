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


public partial class Design_IPD_NursingClearance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));

            if (dtAuthority.Rows.Count > 0)
            {
                if (dtAuthority.Rows[0]["IsNurseClean"].ToString() == "0")
                {
                    string Msg = "You Are Not Authorised To Nursing Clearance...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                }
                else
                {
                    if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
                    {
                        ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
                        ViewState["ID"] = Session["ID"].ToString();
                        CheckRoomClearance();
                        string validateDischargeProcess = IPDBilling.ValidateDischargeSteps((int)AllGlobalFunction.DischargeProcessStep.NursingClearance, ViewState["TransactionID"].ToString());
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

                string Msg = "You Are Not Authorised To Nursing Clearance...";
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
            string Sql = " UPDATE patient_medical_history SET IsNurseClean=1,NurseCleanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',NurseCleanUserID='" + ViewState["ID"].ToString() + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";//f_ipdAdjustment
            // StockReports.ExecuteDML(Sql);
            MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, Sql);


            // Update skipped steps in discharge process
            // string skipStepIDs = "'" + (int)AllGlobalFunction.DischargeProcessStep.RoomClearance + "'";

            string skipStepIDs = IPDBilling.getDischargeSkipSteps(objtnx, (int)AllGlobalFunction.DischargeProcessStep.NursingClearance);
            if (!String.IsNullOrEmpty(skipStepIDs))
            {
                AllUpdate objUpdate = new AllUpdate(objtnx);
                bool updateStatus = objUpdate.UpdateDischargeProcessStep(ViewState["TransactionID"].ToString(), Util.GetString(ViewState["ID"]), skipStepIDs);
                if (!updateStatus)
                {
                    objtnx.Rollback();

                }
            }

            lblMsg.Text = "Nursing Clearance Saved Successfully..";
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

    private void CheckPatientClearance()
    {
        string IsClearance = "";
        IsClearance = StockReports.ExecuteScalar(" SELECT IsClearance FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");//f_ipdadjustment
        if (IsClearance != "1")
        {
            lblMsg.Text = "Kindly Patient Clearance First..";
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
        IsRoomClean = StockReports.ExecuteScalar(" SELECT IsNurseClean FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");//f_ipdadjustment
        if (IsRoomClean == "1")
        {
            string Msg = "Nursing Clearance Already Done....";
            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            //lblMsg.Text = "Nursing Clearance Already Done..";
            //MainDiv.Visible = false;
        }
        else
        {
            lblMsg.Text = "";
            MainDiv.Visible = true;
        }
    }
}
