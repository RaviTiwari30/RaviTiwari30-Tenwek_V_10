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

public partial class Design_IPD_PlanDischarge : System.Web.UI.Page
{
    public string DoctorID, BedNo, DoctorName, DoctorMobileNo = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDischargeType();
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            if (dtAuthority.Rows.Count > 0)
            {
                if (dtAuthority.Rows[0]["IsPlanDischarge"].ToString() == "0")
                {
                    string Msg = "You Are Not Authorised To Plan Discharge...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                }
                else
                {
                    if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
                    {
                        ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
                        ViewState["ID"] = Session["ID"].ToString();
                        txtDischargeDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                        trUnplan.Visible = false;
                        trPlanDischargeType.Visible = true;
                        CheckPlanned();
                    }
                }
            }
            else
            {
                //if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
                //{
                //    ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
                //    ViewState["ID"] = Session["ID"].ToString();
                //    txtDischargeDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                //    trPlan.Visible = true;
                //    trUnplan.Visible = false;
                //    CheckPlanned();
                //}

                string Msg = "You Are Not Authorised To Plan Discharge...";
                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            }
        }
        txtDischargeDate.Attributes.Add("readOnly", "readOnly");
    }

    private void BindDischargeType()
    {
        ddlUnPlan.DataSource = AllGlobalFunction.DischargeType;
        ddlUnPlan.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        //string Sql = "", PlanDateTime="";
        //if (rbtPlanDisc.SelectedItem.Value == "1")
        //{
        //    if (rbtVisitType.SelectedItem.Value == "1")
        //    {
        //        PlanDateTime = EntryDate1.GetDateForDataBase() + " " + EntryTime1.GetTimeForDataBase();              
        //        if (Util.GetDateTime(PlanDateTime) >= DateTime.Now)
        //        {
        //            Sql = " UPDATE f_ipdAdjustment SET  IsPlanned=1,PlanVisit=" + Util.GetInt(rbtVisitType.SelectedItem.Value) + ",IsPlannedType=" + Util.GetInt(rbtPlanDisc.SelectedItem.Value) + ",PlanDateTime='" + PlanDateTime + "',PlanUser='" + ViewState["ID"].ToString() + "',PlanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";     
        //        }
        //        else
        //        {
        //            lblMsg.Text = "You can't plan discharge before Current date & time.";
        //            return;
        //        }
        //    }
        //    else
        //    {
        //        PlanDateTime = EntryDate1.GetDateForDataBase() + " " + EntryTime1.GetTimeForDataBase();
        //        Sql = " UPDATE f_ipdAdjustment SET  IsPlanned=1,PlanVisit=" + Util.GetInt(rbtVisitType.SelectedItem.Value) + ",IsPlannedType=" + Util.GetInt(rbtPlanDisc.SelectedItem.Value) + ",PlanDateTime='" + PlanDateTime + "',PlanUser='" + ViewState["ID"].ToString() + "',PlanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";
        //    }           
        //}
        //else
        //{
        //    if (ddlUnPlan.SelectedItem.Value == "Select")
        //    {
        //        lblMsg.Text = "Please Select Valid Un-Plan Type";
        //        ddlUnPlan.Focus();
        //        return;
        //    }


        //    Sql = " UPDATE f_ipdAdjustment SET IsPlanned=1,IsPlannedType=" + Util.GetInt(rbtPlanDisc.SelectedItem.Value) + ",PlanDateTime='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',PlanUser='" + ViewState["ID"].ToString() + "',PlanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "', PlanStatus='" + ddlUnPlan.SelectedItem.Value + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";

        //}

        //StockReports.ExecuteDML(Sql);
        //lblMsg.Text = "Discharge Plan Saved Successfully..";
        //MainDiv.Visible = false;



        //GAURAV 07.09.16

        string Sql = "", PlanDateTime = "";
        //PlanDateTime = EntryDate1.GetDateForDataBase() + " " + EntryTime1.GetTimeForDataBase();
        PlanDateTime = Util.GetDateTime(txtDischargeDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)txtDischargeTime.FindControl("txtTime")).Text).ToString("HH:mm:ss");
        DateTime CurrentDateTime = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (rbtPlanDisc.SelectedItem.Value == "1")
            {
                if (rbtVisitType.SelectedItem.Value == "1")// After Visit
                {
                    if (Util.GetDateTime(PlanDateTime) < CurrentDateTime)
                    {
                        lblMsg.Text = "You can't set plan discharge before Current date & time...";
                        return;
                    }

                    Sql = " UPDATE f_ipdAdjustment SET  IsPlanned=1,PlanVisit=" + Util.GetInt(rbtVisitType.SelectedItem.Value) + ",IsPlannedType=" + Util.GetInt(rbtPlanDisc.SelectedItem.Value) + ",PlanDateTime='" + PlanDateTime + "',PlanUser='" + ViewState["ID"].ToString() + "',PlanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";
                    MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, Sql);


                    //--------------------------Insert into sms-----------------------------------------

                    //DataTable dtdm = StockReports.GetDataTable("select DoctorID,Concat(Title,' ',NAME)Name,Mobile from doctor_master WHERE DoctorID=(select DoctorID from patient_medical_history where TransactionID ='" + ViewState["TransactionID"].ToString() + "')");
                    //if (dtdm != null && dtdm.Rows.Count > 0)
                    //{
                    //    DoctorID = dtdm.Rows[0]["DoctorID"].ToString();
                    //    DoctorName = dtdm.Rows[0]["Name"].ToString();
                    //    DoctorMobileNo = dtdm.Rows[0]["Mobile"].ToString();
                    //}
                    //BedNo = StockReports.ExecuteScalar("SELECT CONCAT(rm.Bed_No,'/',rm.Name,'/',rm.Floor)BedNo FROM patient_ipd_profile pip INNER JOIN room_master rm ON rm.Room_ID=pip.Room_ID WHERE pip.TransactionID='" + ViewState["TransactionID"].ToString() + "' ORDER BY PatientIPDProfile_ID DESC LIMIT 1 ");

                    //DataTable dtPatient = StockReports.GetDataTable("Select PatientID,CONCAT(Title,' ',PName)PName from Patient_master where PatientID=(select PatientID from patient_medical_history where TransactionID ='" + ViewState["TransactionID"].ToString() + "')");
                    //if (dtPatient != null && dtPatient.Rows.Count > 0)
                    //{
                    //    if (DoctorMobileNo.Contains("/") == true)
                    //    {
                    //        string[] MobNos = DoctorMobileNo.Split('/');

                    //        foreach (string Nos in MobNos)
                    //        {
                    //            string Msg = "Dear Doctor," + Environment.NewLine + "" + DoctorName + " your patient " + dtPatient.Rows[0]["PName"].ToString() + " at " + BedNo + "  is planned for discharge at " + PlanDateTime + "  after your visit. Please provide consultation to the patient.";
                    //            string sqlspd = "INSERT INTO sms_plan_discharge(PatientID,TransactionID,DoctorID,DoctorMobileNo,CurrentBed,PlanDateTime,SMSTemp,EntryDate,EntryBy)values('" + dtPatient.Rows[0]["PatientID"].ToString() + "','" + ViewState["TransactionID"].ToString() + "','" + DoctorID + "','" + Nos + "','" + BedNo + "','" + PlanDateTime + "','" + Msg + "',now(),'" + Session["ID"].ToString() + "')";
                    //            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sqlspd);
                    //        }
                    //    }
                    //    else if (DoctorMobileNo.Length == 10)
                    //    {
                    //        if (dtPatient != null && dtPatient.Rows.Count > 0)
                    //        {
                    //            string Msg = "Dear Doctor," + Environment.NewLine + "" + DoctorName + " your patient " + dtPatient.Rows[0]["PName"].ToString() + " at " + BedNo + "  is planned for discharge at " + PlanDateTime + "  after your visit. Please provide consultation to the patient.";
                    //            string sqlspd = "INSERT INTO sms_plan_discharge(PatientID,TransactionID,DoctorID,DoctorMobileNo,CurrentBed,PlanDateTime,SMSTemp,EntryDate,EntryBy)values('" + dtPatient.Rows[0]["PatientID"].ToString() + "','" + ViewState["TransactionID"].ToString() + "','" + DoctorID + "','" + DoctorMobileNo + "','" + BedNo + "','" + PlanDateTime + "','" + Msg + "',now(),'" + Session["ID"].ToString() + "')";
                    //            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sqlspd);
                    //        }
                    //    }
                    //}
                    //-------------------------------------End------------------------------------------------------------
                }
                else
                {
                    Sql = " UPDATE f_ipdAdjustment SET  IsPlanned=1,PlanVisit=" + Util.GetInt(rbtVisitType.SelectedItem.Value) + ",IsPlannedType=" + Util.GetInt(rbtPlanDisc.SelectedItem.Value) + ",PlanDateTime='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',PlanUser='" + ViewState["ID"].ToString() + "',PlanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";
                    MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, Sql);
                }
            }
            else
            {
                if (ddlUnPlan.SelectedItem.Value == "Select")
                {
                    lblMsg.Text = "Please Select Valid Un-Plan Type";
                    ddlUnPlan.Focus();
                    return;
                }

                PlanDateTime = "0001-01-01 00:00:00";
                Sql = " UPDATE f_ipdAdjustment SET IsPlanned=1,IsPlannedType=" + Util.GetInt(rbtPlanDisc.SelectedItem.Value) + ",PlanDateTime='" + PlanDateTime + "',PlanUser='" + ViewState["ID"].ToString() + "',PlanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "', PlanStatus='" + ddlUnPlan.SelectedItem.Value + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, Sql);
            }
            MySqltrans.Commit();
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Discharge Plan Saved Successfully..";
            MainDiv.Visible = false;
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = "Please Try Again..";
        }
    }

    protected void rbtPlanDisc_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtPlanDisc.SelectedItem.Value == "1")
        {
            trPlan.Visible = true;
            trUnplan.Visible = false;            
            if (ViewState["isFinalDoctorVisitSkipped"]!=null && ViewState["isFinalDoctorVisitSkipped"].ToString() == "0")
                trPlanDischargeType.Visible = false;
            else
                trPlanDischargeType.Visible = true;
        }
        else
        {
            trPlan.Visible = false;
            trUnplan.Visible = true;
            trPlanDischargeType.Visible = false;
        }
    }

    private void CheckPlanned()
    {
        string IsPlan = "";
        IsPlan = StockReports.ExecuteScalar(" SELECT IsPlanned FROM f_ipdadjustment WHERE IsPlanned=1 AND TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");
        if (IsPlan == "1")
        {
            lblMsg.Text = "Discharge Already Planned..";
            MainDiv.Visible = false;
        }
        else
        {
            lblMsg.Text = "";
            MainDiv.Visible = true;

            // Check FinalDoctorVisit skipped or Not
            string isFinalDoctorVisitSkipped = Util.GetString(StockReports.ExecuteScalar(" SELECT IsActive FROM discharge_process_master WHERE ID='" + (int)AllGlobalFunction.DischargeProcessStep.FinalDoctorVisit + "' "));
            ViewState["isFinalDoctorVisitSkipped"] = isFinalDoctorVisitSkipped;
            if (isFinalDoctorVisitSkipped == "0")
            {
                trPlanDischargeType.Visible = false;
                rbtVisitType.SelectedIndex = 1;
            }
            //
        }
    }
}
