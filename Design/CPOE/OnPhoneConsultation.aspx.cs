using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CPOE_OnPhoneConsultation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string PhoneConsultation(string PID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT CONCAT(pm.`Title`,' ',pm.`PName`)PatName,pm.`Age`,pm.`Gender` Sex,pm.`PatientID`,pm.`cityID`,pm.`Mobile`,  ");
        sb.Append("   (SELECT fpm.`Company_Name` FROM f_panel_master fpm WHERE fpm.`PanelID`=pm.`PanelID`)Panel ");
        sb.Append("  FROM patient_master pm WHERE pm.`PatientID`='" + PID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });

        }

    }

    [WebMethod(EnableSession = true)]
    public static string PhoneConsultationSave(string PID)
    {
        GetEncounterNo Encounter = new GetEncounterNo();
        int EncounterNo = 0;

        string TransactionId = "";
        string DocId = "";
        string AppID = "";
        string HashCode = Util.getHash();
        string ConsultationType = Util.GetString(Resources.Resource.OnPhoneConsultation);

        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT  *  FROM patient_master pm  ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`PanelID`=pm.`PanelID` WHERE pm.`PatientID`='" + PID + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {

                DocId = Util.GetString(StockReports.ExecuteScalar("SELECT dm.`DoctorID` FROM  doctor_employee de INNER JOIN doctor_master dm ON dm.`DoctorID`=de.`DoctorID` WHERE de.`EmployeeID`='" + HttpContext.Current.Session["ID"].ToString() + "' "));

                DataTable dtRate = All_LoadData.GetItemRateByType_ID(DocId, dt.Rows[0]["PanelID"].ToString(), ConsultationType);


                Patient_Medical_History objPMH = new Patient_Medical_History(tnx);
                objPMH.PatientID = dt.Rows[0]["PatientID"].ToString();
                objPMH.DoctorID = DocId;
                objPMH.Hospital_ID = "";
                objPMH.Time = Util.GetDateTime(DateTime.Now.ToString("hh:mm:ss"));
                objPMH.DateOfVisit = Util.GetDateTime(DateTime.Now);
                objPMH.Purpose = "";
                objPMH.Type = "OPD";
                objPMH.UserID = HttpContext.Current.Session["ID"].ToString();
                objPMH.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                objPMH.PanelID = Util.GetInt(dt.Rows[0]["PanelID"]);
                objPMH.Source = "0";
                objPMH.ReferedBy = "";
                objPMH.KinRelation = "";
                objPMH.KinName = "";
                objPMH.KinPhone = "";
                objPMH.ParentID = Util.GetInt(dt.Rows[0]["ParentID"]);
                objPMH.patient_type = "";
                objPMH.PolicyNo = "";
                objPMH.CardNo = "";
                objPMH.ScheduleChargeID = Util.GetInt(dtRate.Rows[0]["ScheduleChargeID"]);
                objPMH.IsNewPatient = Util.GetInt(0);
                objPMH.RelationWith_holder = "";
                objPMH.PanelIgnoreReason = "";
                objPMH.CardHolderName = "";
                objPMH.HashCode = HashCode;
                objPMH.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objPMH.ProId = Util.GetInt(0);
                objPMH.patientTypeID = Util.GetInt(0);
                objPMH.PatientPaybleAmt = 0; // Util.GetDecimal(MedicalHistory.Rows[0]["PatientPaybleAmt"]);
                objPMH.PanelPaybleAmt = 0; // Util.GetDecimal(MedicalHistory.Rows[0]["PanelPaybleAmt"]);
                objPMH.PatientPaidAmt = 0; //Util.GetDecimal(MedicalHistory.Rows[0]["PatientPaidAmt"]);
                objPMH.PanelPaidAmt = 0; //Util.GetDecimal(MedicalHistory.Rows[0]["PanelPaidAmt"]);               
                objPMH.Co_PaymentOn = 0;
                objPMH.BookingCenterID = Util.GetInt(HttpContext.Current.Session["BookingCentreID"].ToString());
                objPMH.IsVisitClose = Util.GetInt(0);
                objPMH.TypeOfReference = "";
                objPMH.TriagingCode = Util.GetInt(0);
                TransactionId = objPMH.Insert();

                int AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_AppNo('" + DocId + "','" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "','1')"));


                string Doctor_Name = (StockReports.ExecuteScalar("SELECT NAME FROM `doctor_master` where DoctorID='" + DocId + "' "));


                string Res = Encounter.FindEncounterNoInCaseOfConsultatioin(PID, tnx, con);
                if (Res.Contains("Close"))
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update patient_encounter set Active=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "', UpdateDate=now() where Active=1 And  PatientID= " + PID + " ");

                    Res = Encounter.FindEncounterNoInCaseOfConsultatioin(PID, tnx, con);

                    if (Res.Contains("Close"))
                    {

                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator !" });

                    }
                    else
                    {
                        EncounterNo = Util.GetInt(Res);
                    }
                }
                else
                {
                    EncounterNo = Util.GetInt(Res);
                }

                Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tnx);
                ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnx.LedgerNoCr = "";
                ObjLdgTnx.LedgerNoDr = "";
                ObjLdgTnx.TypeOfTnx = "OPD-APPOINTMENT";
                ObjLdgTnx.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjLdgTnx.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                ObjLdgTnx.BillNo = SalesEntry.genBillNo(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
                if (ObjLdgTnx.BillNo == "")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator !" });

                }
                ObjLdgTnx.BillDate = Util.GetDateTime(DateTime.Now);
                ObjLdgTnx.NetAmount = 0;  // Util.GetDecimal(lttable.Rows[0]["NetAmount"].ToString());
                ObjLdgTnx.GrossAmount = 0; // Util.GetDecimal(lttable.Rows[0]["GrossAmount"].ToString());
                ObjLdgTnx.DiscountOnTotal = 0; // Util.GetDecimal(lttable.Rows[0]["DiscountOnTotal"].ToString());
                ObjLdgTnx.DiscountReason = "";// lttable.Rows[0]["DiscountReason"].ToString().Trim();
                ObjLdgTnx.IsCancel = 0;
                ObjLdgTnx.IsPaid = 1;
                ObjLdgTnx.PatientID = dt.Rows[0]["PatientID"].ToString();
                ObjLdgTnx.PaymentModeID = 4; // Util.GetInt(lttable.Rows[0]["PaymentModeID"].ToString());
                ObjLdgTnx.PanelID = Util.GetInt(dt.Rows[0]["PanelID"]);
                ObjLdgTnx.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnx.TransactionID = TransactionId;
                ObjLdgTnx.PatientType_ID = Util.GetInt(0);
                ObjLdgTnx.RoundOff = 0;
                ObjLdgTnx.UniqueHash = Util.getHash();
                ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnx.DiscountApproveBy = "";
                ObjLdgTnx.Adjustment = 0;
                ObjLdgTnx.GovTaxPer = 0;
                ObjLdgTnx.GovTaxAmount = 0; // Util.GetDecimal(lttable.Rows[0]["GovTaxAmount"].ToString());
                ObjLdgTnx.IPNo = Util.GetString("");
                ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnx.PatientType = "";
                ObjLdgTnx.CurrentAge = Util.GetString(dt.Rows[0]["Age"].ToString());
                ObjLdgTnx.FieldBoyID = Util.GetInt(0);
                ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);

                string LedgerTransactionNo = ObjLdgTnx.Insert();
                if (LedgerTransactionNo == "")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator." });

                }



                LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
                ObjLdgTnxDtl.ItemID = dtRate.Rows[0]["ItemID"].ToString();
                ObjLdgTnxDtl.Rate = Util.GetDecimal(dtRate.Rows[0]["Rate"]);
                ObjLdgTnxDtl.Amount = Util.GetDecimal(0);
                ObjLdgTnxDtl.Quantity = 1;
                ObjLdgTnxDtl.StockID = "";
                ObjLdgTnxDtl.IsTaxable = "NO";
                ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(0);
                ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(0);
                ObjLdgTnxDtl.IsPackage = 0;
                ObjLdgTnxDtl.PackageID = "";
                ObjLdgTnxDtl.IsVerified = 1;
                ObjLdgTnxDtl.SubCategoryID = ConsultationType;
                ObjLdgTnxDtl.ItemName = Util.GetString(dtRate.Rows[0]["Item"].ToString());
                ObjLdgTnxDtl.TransactionID = TransactionId;
                ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjLdgTnxDtl.DiscountReason = "";
                ObjLdgTnxDtl.DoctorID = DocId;
                ObjLdgTnxDtl.TnxTypeID = 5;
                ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(ConsultationType), con));
                ObjLdgTnxDtl.TotalDiscAmt = 0;
                ObjLdgTnxDtl.NetItemAmt = 0;
                ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnxDtl.RateListID = Util.GetInt(dtRate.Rows[0]["RateListID"].ToString().Replace("LSHHI", ""));
                ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                ObjLdgTnxDtl.Type = "O";
                ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                ObjLdgTnxDtl.typeOfTnx = "OPD-APPOINTMENT";
                ObjLdgTnxDtl.roundOff = 0;
                ObjLdgTnxDtl.panelCurrencyCountryID = Util.GetInt(dt.Rows[0]["BillCurrencyCountryID"].ToString());
                ObjLdgTnxDtl.panelCurrencyFactor = Util.GetDecimal(dt.Rows[0]["BillCurrencyConversion"].ToString());
                var ldgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();

                if (string.IsNullOrEmpty(ldgTnxDtlID))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator." });
                }


                appointment ObjApp = new appointment(tnx);
                ObjApp.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjApp.DoctorID = DocId;
                ObjApp.PatientID = dt.Rows[0]["PatientID"].ToString();
                ObjApp.Title = dt.Rows[0]["Title"].ToString();
                ObjApp.plastName = dt.Rows[0]["PLastName"].ToString();

                ObjApp.PfirstName = dt.Rows[0]["PFirstName"].ToString();
                ObjApp.Pname = dt.Rows[0]["PName"].ToString();
                // ObjApp.DOB = MedicalHistory.Rows[0]["DOB"].ToString();
                ObjApp.Age = Util.GetString(dt.Rows[0]["Age"]);
                ObjApp.AppNo = Util.GetInt(AppNo);
                ObjApp.Time = Util.GetDateTime(Util.GetDateTime(DateTime.Now).ToString("HH:mm:ss"));
                ObjApp.EndTime = Util.GetDateTime(Util.GetDateTime(DateTime.Now.AddMinutes(10)).ToString("HH:mm:ss"));
                ObjApp.Date = Util.GetDateTime(DateTime.Now);
                ObjApp.TransactionID = TransactionId;
                ObjApp.IpAddress = All_LoadData.IpAddress();
                ObjApp.MaritalStatus = dt.Rows[0]["MaritalStatus"].ToString();
                ObjApp.Sex = dt.Rows[0]["Gender"].ToString();
                ObjApp.ContactNo = dt.Rows[0]["Mobile"].ToString();
                ObjApp.VisitType = "Old Patient";
                ObjApp.TypeOfApp = "2";//MedicalHistory.Rows[0]["TypeOfApp"].ToString();
                ObjApp.PatientType = dt.Rows[0]["PatientType"].ToString();
                ObjApp.City = dt.Rows[0]["City"].ToString();
                ObjApp.Nationality = "";
                ObjApp.RefDocID = "";
                ObjApp.PurposeOfVisitID = Util.GetInt(dt.Rows[0]["PurposeOfVisitID"].ToString());
                ObjApp.PurposeOfVisit = dt.Rows[0]["PurposeOfVisit"].ToString();
                ObjApp.Notes = "";
                ObjApp.EntryUserID = HttpContext.Current.Session["ID"].ToString();
                ObjApp.EntryDate = Util.GetDateTime(DateTime.Now);
                ObjApp.IsConform = 1;
                ObjApp.ConformDate = Util.GetDateTime(DateTime.Now);
                ObjApp.PanelID = Util.GetInt(dt.Rows[0]["PanelID"]);
                ObjApp.Amount = 0;
                ObjApp.ItemID = dtRate.Rows[0]["ItemID"].ToString();
                ObjApp.SubCategoryID = ConsultationType;
                ObjApp.LedgerTransactionNo = LedgerTransactionNo; //FOR UPDATE WHILE BILLING
                ObjApp.hashCode = HashCode;
                ObjApp.Taluka = dt.Rows[0]["Taluka"].ToString();
                ObjApp.LandMark = dt.Rows[0]["LandMark"].ToString();
                ObjApp.Place = dt.Rows[0]["Place"].ToString();
                ObjApp.District = dt.Rows[0]["District"].ToString();
                ObjApp.PinCode = dt.Rows[0]["PinCode"].ToString();
                ObjApp.Occupation = dt.Rows[0]["Occupation"].ToString();
                ObjApp.Relation = dt.Rows[0]["Relation"].ToString();
                ObjApp.RelationName = dt.Rows[0]["RelationName"].ToString();
                ObjApp.AdharCardNo = dt.Rows[0]["AdharCardNo"].ToString();
                ObjApp.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjApp.CountryID = Util.GetInt(dt.Rows[0]["CountryID"]);
                ObjApp.DistrictID = Util.GetInt(dt.Rows[0]["DistrictID"]);
                ObjApp.CityID = Util.GetInt(dt.Rows[0]["CityID"]);
                ObjApp.TalukaID = Util.GetInt(dt.Rows[0]["TalukaID"]);
                ObjApp.RateListID = Util.GetInt(dtRate.Rows[0]["RateListID"].ToString().Replace("LSHHI", ""));
                ObjApp.ConformBy = HttpContext.Current.Session["ID"].ToString();
                ObjApp.isNewPatient = Util.GetInt(0);
                ObjApp.PlaceOfBirth = dt.Rows[0]["PlaceOfBirth"].ToString();
                ObjApp.IsInternational = dt.Rows[0]["IsInternational"].ToString();
                ObjApp.OverSeaNumber = dt.Rows[0]["OverSeaNumber"].ToString();
                ObjApp.EthenicGroup = dt.Rows[0]["EthenicGroup"].ToString();
                ObjApp.IsTranslatorRequired = dt.Rows[0]["IsTranslatorRequired"].ToString();
                ObjApp.FacialStatus = dt.Rows[0]["FacialStatus"].ToString();
                ObjApp.Race = dt.Rows[0]["Race"].ToString();
                ObjApp.Employement = dt.Rows[0]["Employement"].ToString();
                ObjApp.MonthlyIncome = dt.Rows[0]["MonthlyIncome"].ToString();
                ObjApp.ParmanentAddress = dt.Rows[0]["ParmanentAddress"].ToString();
                ObjApp.IdentificationMarkSecond = dt.Rows[0]["IdentificationMarkSecond"].ToString();
                ObjApp.IdentificationMark = dt.Rows[0]["IdentificationMark"].ToString();
                ObjApp.LanguageSpoken = dt.Rows[0]["LanguageSpoken"].ToString();
                ObjApp.EmergencyRelationOf = dt.Rows[0]["EmergencyRelationOf"].ToString();
                ObjApp.EmergencyRelationName = dt.Rows[0]["EmergencyRelationShip"].ToString();
                ObjApp.ResidentialNumber = dt.Rows[0]["ResidentialNumber"].ToString();
                ObjApp.PhoneSTDCODE = dt.Rows[0]["Phone_STDCODE"].ToString();
                ObjApp.ResidentialNumberSTDCODE = dt.Rows[0]["ResidentialNumber_STDCODE"].ToString();
                ObjApp.EmergencyFirstName = dt.Rows[0]["EmergencyFirstName"].ToString();
                ObjApp.EmergencySecondName = dt.Rows[0]["EmergencySecondName"].ToString();
                ObjApp.InternationalCountryID = Util.GetInt(dt.Rows[0]["InternationalCountryID"]);
                ObjApp.InternationalCountry = dt.Rows[0]["InternationalCountry"].ToString();
                ObjApp.InternationalNumber = dt.Rows[0]["ResidentialNumber"].ToString();
                ObjApp.Phone = dt.Rows[0]["Phone"].ToString();
                ObjApp.EmergencyAddress = dt.Rows[0]["EmergencyAddress"].ToString();

                AppID = ObjApp.Insert();



                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update appointment set temperatureRoom=1, tempRoomUpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "', tempRoomUpdateDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "' where app_id= " + AppID + " ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update f_ledgertransaction set IsPhoneConsultation=1 where LedgertransactionNo= '" + LedgerTransactionNo + "' ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update patient_encounter set IsPhoneConsultation=1 where EncounterNo= '" + EncounterNo + "' ");

                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "../CPOE/OPDSearch.aspx?PatientId=" + PID + "" });


            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator ." });

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();

            }


        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator ." });

        }

    }


}