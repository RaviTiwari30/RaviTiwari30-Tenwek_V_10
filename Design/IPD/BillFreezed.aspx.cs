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

public partial class Design_IPD_BillFreezed : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));

            if (dtAuthority.Rows.Count > 0)
            {
                if (dtAuthority.Rows[0]["IsBillFreezed"].ToString() == "0")
                {
                    string Msg = "You Are Not Authorised To Bill Freezed...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                }
                else
                {
                    if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
                    {
                        ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
                        ViewState["ID"] = Session["ID"].ToString();
                       // CheckMedicalClearance();
                        CheckBillFreezed();
                        string validateDischargeProcess = IPDBilling.ValidateDischargeSteps((int)AllGlobalFunction.DischargeProcessStep.BillFreeze, ViewState["TransactionID"].ToString());
                        if (String.IsNullOrEmpty(validateDischargeProcess))
                        {
                            validateDischargeProcess = IPDBilling.ValidateDischargeSteps((int)AllGlobalFunction.DischargeProcessStep.MedicalClearance, ViewState["TransactionID"].ToString());
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
                //    CheckMedicalClearance();
                //}

                string Msg = "You Are Not Authorised To Bill Freezed...";
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
            string Sql = " UPDATE patient_medical_history SET IsBillFreezed=1,BillFreezedTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',BillFreezedUser='" + ViewState["ID"].ToString() + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";//f_ipdAdjustment
            //StockReports.ExecuteDML(Sql);
            MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, Sql);
            string skipStepIDs = IPDBilling.getDischargeSkipSteps(objtnx, (int)AllGlobalFunction.DischargeProcessStep.BillFreeze);
            if (!String.IsNullOrEmpty(skipStepIDs))
            {
                AllUpdate objUpdate = new AllUpdate(objtnx);
                bool updateStatus = objUpdate.UpdateDischargeProcessStep(ViewState["TransactionID"].ToString(), Util.GetString(ViewState["ID"]), skipStepIDs);
                if (!updateStatus)
                {
                    objtnx.Rollback();

                }
            }
            lblMsg.Text = "Bill Freezed. No Further Changes can be done...";
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

    private void CheckMedicalClearance()
    {
        string IsMedCleared = "";
        IsMedCleared = StockReports.ExecuteScalar(" SELECT IsMedCleared FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");//f_ipdadjustment
        if (IsMedCleared != "1")
        {
            lblMsg.Text = "Kindly Medicine Clearance First..";
            MainDiv.Visible = false;
        }
        else
        {
            CheckBillFreezed();
        }
    }

    private void CheckBillFreezed()
    {
        string IsBillFreezed = "";
        IsBillFreezed = StockReports.ExecuteScalar(" SELECT IsBillFreezed FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");//f_ipdadjustment
        if (IsBillFreezed == "1")
        {
            string Msg = "Bill Already Freezed....";
            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            //lblMsg.Text = "Bill Already Freezed..";
            //MainDiv.Visible = false;
        }
        else
        {
            lblMsg.Text = "";
            MainDiv.Visible = true;
        }
    }
}
