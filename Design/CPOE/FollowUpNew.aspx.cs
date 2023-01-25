using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Text;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Web;

public partial class Design_CPOE_FollowUpNew : System.Web.UI.Page
{
    protected void BindData(string TID,string PID,string date)
    {
        try
        {
            string FollowUp = StockReports.ExecuteScalar("SELECT CONCAT(DATE_FORMAT(FollowUpSelectedDate,'%d-%b-%Y'),Concat(' FromTime:',app.Time),Concat(' EndTime:',app.EndTime),'#',coa.FollowUpHistory)FollowUpHistory FROM cpoe_Assessment coa  INNER JOIN appointment app ON coa.doctorid=app.DoctorID WHERE app.PatientID='" + PID + "' and coa.TransactionID='" + TID + "' AND coa.FollowUpSelectedDate>=CURDATE() AND app.isconform=0 ");
            if (FollowUp != "")
            {
                txtFollowUpNew.Value = FollowUp.Split('#')[1];
                lblShowMessage.Text = "You have already save follow up for this Patient on Date :" + FollowUp;
                lblShowMessage.Visible = true;
            }
            else
            {
                txtFollowUpNew.Value = "";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    //protected void btnSave_Click(object sender, EventArgs e)
    //{
    //    MySqlConnection con = Util.GetMySqlCon();
    //    con.Open();
    //    MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
    //    try
    //    {
    //        int ChkEntery = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM cpoe_Assessment WHERE transaction_ID='" + ViewState["TID"].ToString() + "'"));
    //        if (ChkEntery > 0)
    //        {
    //            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE cpoe_Assessment SET FollowUpHistory='" + txtFollowUpNew.Text.Trim() + "',FollowUpCreatedBy='" + Session["ID"].ToString() + "',FollowUpCreatedDate=now() WHERE Transaction_ID='" + ViewState["TID"].ToString() + "'");
    //        }
    //        else
    //        {
    //            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO cpoe_Assessment(Transaction_ID,Patient_ID,FollowUpHistory,FollowUpCreatedBy,FollowUpCreatedDate)VALUE('" + ViewState["TID"].ToString() + "','" + ViewState["PID"].ToString() + "','" + txtFollowUpNew.Text.Trim() + "','" + ViewState["UserID"].ToString() + "',now())");
    //        }
    //        tnx.Commit();
    //        BindData(ViewState["TID"].ToString());
    //        //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
    //    }
    //    catch (Exception ex)
    //    {
    //        //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
    //        tnx.Rollback();
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);
    //    }
    //    finally
    //    {
    //        tnx.Dispose();
    //        con.Close();
    //        con.Dispose();
    //    }
    //}

    protected void Page_Load(object sender, EventArgs e)
    { 
        
        calExdTxtOldInvestigationModelFromDate.StartDate = DateTime.Now.AddDays(+1);
        txtdate.Text = DateTime.Now.AddDays(1).ToString("dd-MMM-yyyy");
        try
        {
            if (!IsPostBack)
            {

                Session["UserID"] = Session["ID"].ToString();
                Session["TID"] = Request.QueryString["TID"].ToString();
               
                Session["PID"] = Request.QueryString["PID"].ToString();
              //  Session["Doctor_ID"] = Request.QueryString["DoctorID"].ToString();
                Session["Transaction_ID"] = Request.QueryString["TID"].ToString();
                Session["PatientID"] = Request.QueryString["PatientID"].ToString();
                Session["Panel_ID"] = Request.QueryString["PanelID"].ToString();

                //string billno = Util.GetString(StockReports.ExecuteScalar("select Ifnull(Billno,'')Billno from patient_medical_history where TransactionID='" + Session["TID"].ToString() + "'"  ));

                //if (billno != "")
                //{
                //    string Msg = "Patient's Final Bill has been Closed for Further Updating...";
                //    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                //}
                //else
                //{
                //    BindData(Session["TID"].ToString());
                //}

                BindData(Session["TID"].ToString(), Session["PatientID"].ToString(),txtdate.Text);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    [WebMethod]
    public static string bindAppDetail(string DocGroupID)
    {
        
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT t0.Doctor_ID,t0.DoctorName,IFNULL(t0.TotalPatient,0)TotalPatient,IFNULL(t1.PendingPatient,0)PendingPatient,IFNULL(t2.ViewedPatient,0)ViewedPatient FROM ( ");
        sb.Append("SELECT t.Doctor_ID,t.DoctorName,t.TotalPatient FROM  ");
        sb.Append("(SELECT app.Doctor_ID,CONCAT(dm.Title,'',dm.Name)DoctorName,COUNT(App_ID)TotalPatient ");
        sb.Append("FROM appointment app INNER JOIN doctor_master dm ON dm.Doctor_ID=app.Doctor_ID ");
        sb.Append("WHERE  DATE=DATE(NOW()) AND DocGroupID='" + DocGroupID + "' AND app.iscancel=0 ");
        sb.Append("GROUP BY app.Doctor_ID)t GROUP BY t.Doctor_ID)t0 ");
        sb.Append("LEFT JOIN ( ");
        sb.Append("SELECT t.Doctor_ID,t.DoctorName,t.PendingPatient FROM  ");
        sb.Append("(SELECT app.Doctor_ID,CONCAT(dm.Title,'',dm.Name)DoctorName,COUNT(App_ID)PendingPatient ");
        sb.Append("FROM appointment app INNER JOIN doctor_master dm ON dm.Doctor_ID=app.Doctor_ID ");
        sb.Append("WHERE  DATE=DATE(NOW()) AND app.isview=0  AND DocGroupID='" + DocGroupID + "' AND app.iscancel=0 ");
        sb.Append("GROUP BY app.Doctor_ID)t GROUP BY t.Doctor_ID)t1 ON t1.Doctor_ID=t0.Doctor_ID  ");
        sb.Append("LEFT JOIN ( ");
        sb.Append("SELECT t.Doctor_ID,t.DoctorName,t.ViewedPatient FROM  ");
        sb.Append("(SELECT app.Doctor_ID,CONCAT(dm.Title,'',dm.Name)DoctorName,COUNT(App_ID)ViewedPatient ");
        sb.Append("FROM appointment app INNER JOIN doctor_master dm ON dm.Doctor_ID=app.Doctor_ID ");
        sb.Append("WHERE  DATE=DATE(NOW()) AND app.isview=1  AND DocGroupID='" + DocGroupID + "' AND app.iscancel=0 ");
        sb.Append("GROUP BY app.Doctor_ID)t GROUP BY t.Doctor_ID)t2 ON t2.Doctor_ID=t0.Doctor_ID  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string AppoinmentBooking(string TnxID, string Date, string Time, string FollowUpNew, string ConsultantType,string PanelID,string Patientid)
    {
       // string checkIsFollowUpsave = StockReports.ExecuteScalar(" SELECT IF(FollowUpSelectedDate IS NULL ,0,1)FollowUpSelectedDate FROM cpoe_Assessment WHERE transactionID='" + HttpContext.Current.Session["TID"].ToString() + "'");
        string checkIsFollowUpsave = "0";
        
        if (checkIsFollowUpsave == "0" || checkIsFollowUpsave == "")
        {
            string AppID = "";
            string HashCode = Util.getHash();
            string TransactionId = "";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            string ItemDetail = Util.GetString(StockReports.ExecuteScalar("SELECT CONCAT(im.ItemID,'#',IFNULL(rt.Rate,'0'),'#',IFNULL(rt.RateListID,''))ItemDetail FROM f_itemmaster im INNER JOIN f_subcategorymaster sm ON im.SubcategoryID=sm.SubcategoryID INNER JOIN doctor_master dm ON dm.DoctorID=im.Type_ID LEFT JOIN f_ratelist rt ON rt.ItemID=im.ItemID AND rt.PanelID='" + PanelID + "' AND rt.IsCurrent=1 WHERE dm.DoctorID='" + TnxID + "' AND sm.SubCategoryID='" + ConsultantType + "' "));
            DataTable MedicalHistory = StockReports.GetDataTable("SELECT * from patient_master pm where pm.patientid='"+Patientid+"'");
            int Co_PaymentOn = Util.GetInt(StockReports.ExecuteScalar("select ifnull(Co_PaymentOn,0) from f_panel_master where PanelID='" + PanelID + "'"));
            //if (MedicalHistory.Rows.Count > 0)
           // {
                //Patient_Medical_History objPMH = new Patient_Medical_History(tnx);
                //objPMH.Patient_ID = MedicalHistory.Rows[0]["Patient_ID"].ToString();
                //objPMH.Doctor_ID = MedicalHistory.Rows[0]["Doctor_ID"].ToString();
                //objPMH.Hospital_ID = MedicalHistory.Rows[0]["Doctor_ID"].ToString();
                //objPMH.Time = Util.GetDateTime(DateTime.Now.ToString("hh:mm:ss"));
                //objPMH.DateOfVisit = Util.GetDateTime(Date);
                //objPMH.Type = MedicalHistory.Rows[0]["Type"].ToString();
                //objPMH.Purpose = MedicalHistory.Rows[0]["Purpose"].ToString();
                //objPMH.Panel_ID = Util.GetInt(MedicalHistory.Rows[0]["Panel_ID"]);
                //objPMH.ParentID = Util.GetInt(MedicalHistory.Rows[0]["ParentID"]);
                //objPMH.ReferedBy = MedicalHistory.Rows[0]["ReferedBy"].ToString();
                //objPMH.patient_type = MedicalHistory.Rows[0]["patient_type"].ToString();
                //objPMH.HashCode = HashCode;
                //objPMH.ScheduleChargeID = Util.GetInt(MedicalHistory.Rows[0]["ScheduleChargeID"]);
                //objPMH.Source = MedicalHistory.Rows[0]["Source"].ToString();
                //objPMH.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                //objPMH.UserID = HttpContext.Current.Session["ID"].ToString();
                //objPMH.IsNewPatient = Util.GetInt(MedicalHistory.Rows[0]["IsNewPatient"]);
                //objPMH.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                //objPMH.patientTypeID = Util.GetInt(MedicalHistory.Rows[0]["patientTypeID"]);
                //objPMH.PanelPaybleAmt = Util.GetDecimal(MedicalHistory.Rows[0]["PanelPaybleAmt"]);
                //objPMH.PatientPaybleAmt = Util.GetDecimal(MedicalHistory.Rows[0]["PatientPaybleAmt"]);
                //objPMH.PanelPaidAmt = Util.GetDecimal(MedicalHistory.Rows[0]["PanelPaidAmt"]);
                //objPMH.PatientPaidAmt = Util.GetDecimal(MedicalHistory.Rows[0]["PatientPaidAmt"]);
                //objPMH.Co_PaymentOn = Co_PaymentOn;
                //if (MedicalHistory.Rows[0]["KinRelation"].ToString() == "Select")
                //    objPMH.KinRelation = "";
                //else
                //    objPMH.KinRelation = MedicalHistory.Rows[0]["KinRelation"].ToString();
                //objPMH.KinName = MedicalHistory.Rows[0]["KinName"].ToString();
                //objPMH.KinPhone = MedicalHistory.Rows[0]["KinPhone"].ToString();
                //objPMH.CardNo = MedicalHistory.Rows[0]["CardNo"].ToString();
                //objPMH.PolicyNo = MedicalHistory.Rows[0]["PolicyNo"].ToString();
                //objPMH.ExpiryDate = Util.GetDateTime(MedicalHistory.Rows[0]["ExpiryDate"]);
                //objPMH.CardHolderName = MedicalHistory.Rows[0]["CardHolderName"].ToString();
                //objPMH.RelationWith_holder = MedicalHistory.Rows[0]["RelationWith_holder"].ToString();
                //objPMH.PanelIgnoreReason = MedicalHistory.Rows[0]["PanelIgnoreReason"].ToString();
                //objPMH.ProId = Util.GetInt(MedicalHistory.Rows[0]["ProId"]);
                //objPMH.BookingCenterID = Util.GetInt(HttpContext.Current.Session["BookingCentreID"].ToString());
                //objPMH.IsVisitClose = Util.GetInt(MedicalHistory.Rows[0]["IsVisitClose"]);
                //objPMH.TypeOfReference = MedicalHistory.Rows[0]["TypeOfReference"].ToString();
                //objPMH.TriagingCode = Util.GetInt(MedicalHistory.Rows[0]["TriagingCode"]);
                //TransactionId = objPMH.Insert();





                int AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_AppNo('" + TnxID + "','" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "','1')"));


                string Doctor_Name = (StockReports.ExecuteScalar("SELECT NAME FROM `doctor_master` where doctorid='" + TnxID + "' "));


                DataTable dtRate = All_LoadData.GetItemRateByType_ID(TnxID, PanelID, ConsultantType.ToString());

                appointment ObjApp = new appointment(tnx);
                ObjApp.Title = MedicalHistory.Rows[0]["Title"].ToString();
                ObjApp.PfirstName = MedicalHistory.Rows[0]["PFirstName"].ToString();
                ObjApp.plastName = MedicalHistory.Rows[0]["PLastName"].ToString();
                ObjApp.Pname = MedicalHistory.Rows[0]["PName"].ToString();
                ObjApp.ContactNo = MedicalHistory.Rows[0]["Mobile"].ToString();
                ObjApp.Age = Util.GetString(MedicalHistory.Rows[0]["Age"]);
                ObjApp.VisitType = "Old Patient";
                ObjApp.TypeOfApp = "1";
                ObjApp.PatientType = "Insured";
                ObjApp.Nationality = MedicalHistory.Rows[0]["Country"].ToString();
                ObjApp.City = MedicalHistory.Rows[0]["City"].ToString();
                ObjApp.Sex = MedicalHistory.Rows[0]["Gender"].ToString();
                ObjApp.RefDocID = "";
                ObjApp.PurposeOfVisit = "";
                ObjApp.PurposeOfVisitID = 0;
                ObjApp.Date = Util.GetDateTime(Date);
                ObjApp.DoctorID = TnxID.ToString();
                ObjApp.Time = Util.GetDateTime(Util.GetDateTime(Time.Split('-')[0]).ToString("HH:mm:ss"));
                ObjApp.EndTime = Util.GetDateTime(Util.GetDateTime(Time.Split('-')[1]).ToString("HH:mm:ss"));
                ObjApp.EntryUserID = HttpContext.Current.Session["ID"].ToString();
                ObjApp.Amount = Util.GetDecimal(ItemDetail.Split('#')[1]);
                ObjApp.ItemID =ItemDetail.Split('#')[0];
                //  ObjApp.SubCategoryID = MedicalHistory.Rows[0]["SubCategoryID"].ToString()  ;
                ObjApp.SubCategoryID = ConsultantType.ToString();
                ObjApp.Notes = FollowUpNew;
                ObjApp.RateListID = Util.GetInt(ItemDetail.Split('#')[2].Replace("LSHHI", ""));

                ObjApp.PatientID = Patientid;
                ObjApp.PanelID = Util.GetInt(PanelID);
                ObjApp.AppNo = Util.GetInt(AppNo);
                ObjApp.hashCode = HashCode;
                //ObjApp.IsConform = 1;
                ObjApp.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjApp.Taluka = MedicalHistory.Rows[0]["Taluka"].ToString();
                ObjApp.LandMark = MedicalHistory.Rows[0]["LandMark"].ToString();
                ObjApp.Place = MedicalHistory.Rows[0]["Place"].ToString();
                ObjApp.District = MedicalHistory.Rows[0]["District"].ToString();
                ObjApp.PinCode = MedicalHistory.Rows[0]["PinCode"].ToString();
                ObjApp.Occupation = MedicalHistory.Rows[0]["Occupation"].ToString();
                ObjApp.MaritalStatus = MedicalHistory.Rows[0]["MaritalStatus"].ToString();
                ObjApp.Relation = MedicalHistory.Rows[0]["Relation"].ToString();
                ObjApp.RelationName = MedicalHistory.Rows[0]["RelationName"].ToString();
                ObjApp.TransactionID = string.Empty;
                ObjApp.LedgerTransactionNo = string.Empty; //FOR UPDATE WHILE BILLING

                //ObjApp.ConformDate = Util.GetDateTime(DateTime.Now);
                ObjApp.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjApp.AdharCardNo = MedicalHistory.Rows[0]["AdharCardNo"].ToString();
                ObjApp.District = MedicalHistory.Rows[0]["District"].ToString();
                ObjApp.CountryID = Util.GetInt(MedicalHistory.Rows[0]["CountryID"]);
                ObjApp.DistrictID = Util.GetInt(MedicalHistory.Rows[0]["DistrictID"]);
                ObjApp.CityID = Util.GetInt(MedicalHistory.Rows[0]["CityID"]);
                ObjApp.TalukaID = Util.GetInt(MedicalHistory.Rows[0]["TalukaID"]);
                // ObjApp.ConformBy = HttpContext.Current.Session["ID"].ToString();
               // ObjApp.isNewPatient = Util.GetInt(MedicalHistory.Rows[0]["IsNewPatient"]);
                ObjApp.PlaceOfBirth = MedicalHistory.Rows[0]["PlaceOfBirth"].ToString();
                ObjApp.IdentificationMark = MedicalHistory.Rows[0]["IdentificationMark"].ToString();
                ObjApp.IsInternational = MedicalHistory.Rows[0]["IsInternational"].ToString();
                ObjApp.OverSeaNumber = MedicalHistory.Rows[0]["OverSeaNumber"].ToString();
                ObjApp.EthenicGroup = MedicalHistory.Rows[0]["EthenicGroup"].ToString();
                ObjApp.IsTranslatorRequired = MedicalHistory.Rows[0]["IsTranslatorRequired"].ToString();
                ObjApp.FacialStatus = MedicalHistory.Rows[0]["FacialStatus"].ToString();
                ObjApp.Race = MedicalHistory.Rows[0]["Race"].ToString();
                ObjApp.Employement = MedicalHistory.Rows[0]["Employement"].ToString();
                ObjApp.MonthlyIncome = MedicalHistory.Rows[0]["MonthlyIncome"].ToString();
                ObjApp.ParmanentAddress = MedicalHistory.Rows[0]["ParmanentAddress"].ToString();
                ObjApp.IdentificationMarkSecond = MedicalHistory.Rows[0]["IdentificationMarkSecond"].ToString();
                ObjApp.LanguageSpoken = MedicalHistory.Rows[0]["LanguageSpoken"].ToString();
                ObjApp.EmergencyRelationOf = MedicalHistory.Rows[0]["EmergencyRelationOf"].ToString();
                ObjApp.EmergencyRelationName = MedicalHistory.Rows[0]["EmergencyRelationShip"].ToString();

                ObjApp.PhoneSTDCODE = MedicalHistory.Rows[0]["Phone_STDCODE"].ToString();
                ObjApp.ResidentialNumber = MedicalHistory.Rows[0]["ResidentialNumber"].ToString();
                ObjApp.ResidentialNumberSTDCODE = MedicalHistory.Rows[0]["ResidentialNumber_STDCODE"].ToString();
                ObjApp.EmergencyFirstName = MedicalHistory.Rows[0]["EmergencyFirstName"].ToString();
                ObjApp.EmergencySecondName = MedicalHistory.Rows[0]["EmergencySecondName"].ToString();
                ObjApp.InternationalCountryID = Util.GetInt(MedicalHistory.Rows[0]["InternationalCountryID"]);
                ObjApp.InternationalCountry = MedicalHistory.Rows[0]["InternationalCountry"].ToString();
                ObjApp.InternationalNumber = MedicalHistory.Rows[0]["ResidentialNumber"].ToString();
                ObjApp.Phone = MedicalHistory.Rows[0]["Phone"].ToString();
                ObjApp.EmergencyAddress = MedicalHistory.Rows[0]["EmergencyAddress"].ToString();
                ObjApp.LedgerTransactionNo = "0";
                AppID = ObjApp.Insert();
           // }
            //else
            //{
            //    AppID = "not generated. Please pay the bill.";
            //}
            try
            {
                int ChkEntery = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM cpoe_Assessment WHERE transactionID='" + HttpContext.Current.Session["TID"].ToString() + "'"));
                if (ChkEntery > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE cpoe_Assessment SET FollowUpHistory='" + FollowUpNew.Trim() + "',FollowUpCreatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',FollowUpCreatedDate=now(),FollowUpSelectedDate='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "',DoctorID='"+TnxID+"' WHERE TransactionID='" + HttpContext.Current.Session["TID"].ToString() + "'");
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO cpoe_Assessment(TransactionID,PatientID,FollowUpHistory,FollowUpCreatedBy,FollowUpCreatedDate,FollowUpSelectedDate,DoctorID)VALUE('" + HttpContext.Current.Session["TID"].ToString() + "','" + Patientid + "','" + FollowUpNew + "','" + HttpContext.Current.Session["UserID"].ToString() + "',now(),'" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "','"+TnxID+"' )");
                }
                tnx.Commit();


                 StringBuilder msg =new StringBuilder();
            string contact = "0";
              int smsCon=0;

              msg.Append(" " + ObjApp.Title + " " + ObjApp.Pname + "  has an outpatient appointment AT [Tenwek Hospital] ON [" + ObjApp.Date.ToString("dd-MM-yyyy") + "][" + ObjApp.Time.ToString("HH:mm tt") + "] ");
              msg.Append(" .Please arrive AT registration 30 minutes BEFORE the appointment time. Kindly verify IF will keep the appointment. IF you are unable TO keep the appointment, please CALL 0700-499699 TO reschedule OR cancel.");
                 

 
                  if (ObjApp.ContactNo != "")
                  {
                      Sms_Host objSms = new Sms_Host();
                      objSms._Msg = msg.ToString();
                      objSms._SmsTo = ObjApp.ContactNo;
                      objSms._PatientID = ObjApp.PatientID;
                      objSms._DoctorID = ObjApp.DoctorID; 
                      objSms._EmployeeID = HttpContext.Current.Session["ID"].ToString();
                      objSms._TemplateID = 0;
                      objSms._UserID = HttpContext.Current.Session["ID"].ToString();
                      objSms._smsType = 1;//For Patient
                      objSms._CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]);
                      objSms._TransactionID = ObjApp.TransactionID;
                      smsCon = objSms.sendSms();

                 
              }   

                // BindData(ViewState["TID"].ToString());
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            }
            catch (Exception ex)
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
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
            return "Patient Appoinment Number is " + AppID + ".";
        }
        else
        {
            string GetFollowupDate = StockReports.ExecuteScalar(" SELECT DATE_FORMAT(FollowUpSelectedDate,'%d-%b-%Y') FROM cpoe_Assessment WHERE transactionID='" + HttpContext.Current.Session["TID"].ToString() + "'");
            return "You have already save follow up for this Patient on Date : " + GetFollowupDate + " ";
        }
    }
     
    [WebMethod(EnableSession = true)]
    public static string GetAvaibality(string Date, string DoctorID)
    {
     

        string LeaveQuery = "SELECT COUNT(*)OnLeave FROM Pay_Leave_Master pl WHERE pl.IsActive=1 AND pl.`Date`='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND pl.`DoctorID`='" + DoctorID + "'";
        int IsLeave = Util.GetInt(StockReports.ExecuteScalar(LeaveQuery));
        if (IsLeave > 0)
        {
          //  return "0";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Isdro = 0, data = "0" });
        }
        LeaveQuery = "SELECT ph.`HolidaysName` FROM holidays_details ph WHERE ph.`IsActive`=1 AND ph.`HolidaysDate`='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' ";
        string holidaysName = Util.GetString(StockReports.ExecuteScalar(LeaveQuery));
        if (!string.IsNullOrEmpty(holidaysName))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Isdro = 0, data = "1" });
            // return "1";
        }

        
        DataTable dtDoctorSlot;
        string Query = " SELECT  StartTime,EndTime,AvgTime as DurationForOldPatient FROM doctor_hospital WHERE DoctorID='" + DoctorID + "' AND DAY='" + Util.GetDateTime(Date).DayOfWeek.ToString() + "' and CentreID='" + HttpContext.Current.Session["CentreID"] + "' ";
        dtDoctorSlot = StockReports.GetDataTable(Query);
       
        if (dtDoctorSlot.Rows.Count>0)
        {
            StringBuilder sb = new StringBuilder() ;
            int SlotTime = Util.GetInt(dtDoctorSlot.Rows[0]["DurationForOldPatient"]);
            DateTime dtStart = Util.GetDateTime("08:00:00"); //Util.GetDateTime(dtDoctorSlot.Rows[0]["StartTime"]);
            DateTime dtEnd = Util.GetDateTime("17:00:00");//Util.GetDateTime(dtDoctorSlot.Rows[0]["EndTime"]);
            string set= dtStart.ToString();
            while (Util.GetDateTime( set) < dtEnd)
            {
                string option= Util.GetDateTime( set).ToString("hh:mm tt") + "-"+ Util.GetDateTime(set).AddMinutes(SlotTime).ToString("hh:mm tt") ;
                sb.Append("<option value='"+ option +"'>" + option + "</option>");
                dtStart.AddMinutes(SlotTime);
                set = Util.GetDateTime(set).AddMinutes(SlotTime).ToString();
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Isdro=1, data = sb.ToString() }) ; //Newtonsoft.Json.JsonConvert.SerializeObject(sb.ToString());
        }
           
        if (dtDoctorSlot == null || dtDoctorSlot.Rows.Count == 0)
        {
            dtDoctorSlot = StockReports.GetDataTable(" SELECT  StartTime,EndTime FROM Doctor_TimingDateWise WHERE DoctorID='" + DoctorID + "' AND Date='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' and CentreID='" + HttpContext.Current.Session["CentreID"] + "'  ");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Isdro = 0, data = dtDoctorSlot });
    }
    [WebMethod(EnableSession = true)]
    public static string CheckDoctorAppointment(string Time, string appointmentDate, string DoctorID)
    {
        string check = StockReports.ExecuteScalar("Select count(1) from appointment where DoctorID='" +DoctorID + "' AND TIME='" + DateTime.Parse(Time.Split('-')[0]).ToString("HH:mm") + "' AND EndTime='" + DateTime.Parse(Time.Split('-')[1]).ToString("HH:mm") + "' AND date='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "'  ");        
        return check;
    }

}