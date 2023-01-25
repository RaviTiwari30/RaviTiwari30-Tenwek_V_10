using System;
using System.Data;
using System.Web;
using MySql.Data.MySqlClient;
using System.IO;
using System.IO.Compression;
using System.Text;
/// <summary>
/// Summary description for AllInsert
/// </summary>
public class AllInsert
{
    public AllInsert()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static string SaveCity(string City, string Country, string DistrictID, string StateID)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM city_master where City='" + City + "' and Country='" + Country + "' AND DistrictID='" + DistrictID + "' AND StateID='" + StateID + "'"));
            if (count > 0)
                return "0";
            else
            {
                LoadCacheQuery.dropCache("City");
                string s = "INSERT INTO city_master(City,Country,createdBy,DistrictID,IPAddress,StateID) values('" + City + "','" + Country + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + DistrictID + "','" + HttpContext.Current.Request.UserHostAddress + "','" + StateID + "')";
                StockReports.ExecuteDML(s);
                return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(ID) FROM city_master"));

            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }
    public static string SaveAppointmentType(string TypeOfAppointment)
    {

        int count = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from Master_AppointmentType where AppointmentType='" + TypeOfAppointment + "' "));
        if (count > 0)
            return "0";
        else
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                TypeOfAppoinment_master ObjCmpln = new TypeOfAppoinment_master(tnx);
                ObjCmpln.AppointmentType = Util.GetString(TypeOfAppointment);
                string Result = ObjCmpln.Insert();
                tnx.Commit();
                LoadCacheQuery.dropCache("AppointmentType");
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }

    }
    public static string SaveDiscReason(string DiscReason, string Type)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM discount_reason where DiscountReason='" + DiscReason + "' and Type='" + Type + "'"));
            if (count > 0)
                return "0";
            else
            {
                string s = "INSERT INTO discount_reason(DiscountReason,Type,CreatedBy) values('" + DiscReason + "','" + Type + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
                StockReports.ExecuteDML(s);
                return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(ID) FROM discount_reason"));
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }
    public static string SaveComplaint(string CName)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT count(*) FROM complain_master WHERE complain='" + CName + "' "));
        if (count > 0)
            return "0";
        else
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                complain_master ObjCmpln = new complain_master(tnx);
                ObjCmpln.Complain = Util.GetString(CName);
                string Re = ObjCmpln.Insert();
                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";
            }
            finally
            {

                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }

    }
    public static string saveRefDoc(string Title, string Name, string HouseNo, string Mobile, string proID)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT count(*) FROM doctor_referal WHERE Title='" + Title + "' and Name='" + Name + "'and House_No='" + HouseNo + "'and Mobile='" + Mobile + "' "));
        if (count > 0)
            return "0";
        else
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            ExcuteCMD excuteCMD= new ExcuteCMD();
            try
            {
                LoadCacheQuery.dropCache("ReferDoctor");
                doctor_referal ObjDr = new doctor_referal(tnx);
                ObjDr.Title = Util.GetString(Title);
                ObjDr.Name = Util.GetString(Name);
                ObjDr.House_No = Util.GetString(HouseNo);
                ObjDr.Mobile = Util.GetString(Mobile);
                string Result = ObjDr.Insert();

                excuteCMD.DML(tnx,"INSERT INTO mappedprotoreferdoctor (PRO_ID,ReferDoctorID,EnteredBy) VALUES (@proID,@referDoctorID,@userID)",CommandType.Text,new {
                     proID=proID,
                     referDoctorID=Result,
                     userID=HttpContext.Current.Session["ID"].ToString()
                });

                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }
    public static string districtInsert(string District, string countryID, string stateID)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM Master_District WHERE District='" + District + "' AND countryID='" + countryID + "' AND stateID='" + stateID + "' "));
            if (count > 0)
                return "0";
            else
            {
                LoadCacheQuery.dropCache("District");
                string s = "INSERT INTO Master_District(District,EntryBy,countryID,IPAddress,stateID) values('" + District + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + countryID + "','" + HttpContext.Current.Request.UserHostAddress + "','" + stateID + "')";
                StockReports.ExecuteDML(s);
                return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(DistrictID) FROM Master_District"));
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }
    public static string talukInsert(string Taluka, string districtID, string cityID)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM Master_Taluka WHERE Taluka='" + Taluka + "' AND DistrictID='" + districtID + "' AND CityID='" + cityID + "' "));
            if (count > 0)
                return "0";
            else
            {
                LoadCacheQuery.dropCache("Taluka");

                string s = "INSERT INTO Master_Taluka(Taluka,DistrictID,EntryBy,cityID,IPAddress) VALUES('" + Taluka + "','" + districtID + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + cityID + "','" + HttpContext.Current.Request.UserHostAddress + "')";
                StockReports.ExecuteDML(s);
                return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(TalukaID) FROM Master_Taluka"));

            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return "";
        }
    }
    public static string InsertVoice(string Audio, string PID, string TID, string Type, string FileName, string UserID)
    {
        try
        {
            if (All_LoadData.chkDocumentDrive() == 0)
            {
                return "0";
            }
            var pathname = All_LoadData.createDocumentFolder("Audio", TID, Util.GetString(DateTime.Now.ToString("dd-MM-yyyy")));
            if (pathname == null)
            {
                return "0";
            }
            int MaxID = Util.GetInt(StockReports.ExecuteScalar("SELECT IFNULL((MAX(ID)+1),1) FROM cpoe_voicerecord"));
            string Path = Util.GetString(pathname);
            Path += "\\" + FileName + "_" + MaxID + ".txt";
            System.IO.File.WriteAllText(Path, Audio);
            CompressFile(Path);
            File.Delete(Path);
            StockReports.ExecuteDML("INSERT INTO cpoe_voicerecord(PatientID,TransactionID,FileName,UserID,Path,TYPE,IPAddress) VALUES('" + PID + "','" + TID + "','" + FileName + "_" + MaxID + "','" + UserID + "','" + Path.Replace(@"\", @"\\") + "','" + Type + "','" + HttpContext.Current.Request.UserHostAddress + "')");
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return "";
        }
    }
    public static void CompressFile(string path)
    {
        FileStream sourceFile = File.OpenRead(path);
        FileStream destinationFile = File.Create(path.Replace(".txt", "") + ".gz");
        byte[] buffer = new byte[sourceFile.Length];
        sourceFile.Read(buffer, 0, buffer.Length);
        using (GZipStream output = new GZipStream(destinationFile, CompressionMode.Compress))
        {
            output.Write(buffer, 0, buffer.Length);
        }
        sourceFile.Close();
        destinationFile.Close();
    }

    public static string SaveDocOPD(string DocID, string HospID, string Day, DateTime StartTime, DateTime EndTime, string RoomNo, string Dept, int avgtime, int StartBufferTime, int EndBufferTime, int DurationforNewPatient, int DurationforOldPatient, string DocFloor, MySqlTransaction Trans, string VisitName,int CentreID)
    {
        try
        {
            doctor_hospital objDocHosp = new doctor_hospital(Trans);
            int Shift = Util.GetInt(MySqlHelper.ExecuteScalar(Trans, CommandType.Text, "select max(IFNULL(Shift,0)) from doctor_hospital where DoctorID='" + DocID + "' and Hospital_ID='" + HospID + "' and Day='" + Day + "'"));

            Shift = Shift + 1;
            objDocHosp.DoctorID = DocID;
            objDocHosp.Hospital_ID = HospID;
            objDocHosp.Day = Day;
            objDocHosp.StartTime = StartTime;
            objDocHosp.EndTime = EndTime;
            objDocHosp.Department = Dept;
            objDocHosp.RoomNo = RoomNo;
            objDocHosp.AvgTime = avgtime;
            objDocHosp.StartBufferTime = StartBufferTime;
            objDocHosp.EndBufferTime = EndBufferTime;
            objDocHosp.DurationforOldPatient = DurationforOldPatient;
            objDocHosp.DurationforNewPatient = DurationforNewPatient;
            objDocHosp.DocFloor = DocFloor;
            objDocHosp.VisitName = VisitName;
            objDocHosp.CentreID = CentreID;
            objDocHosp.Insert();
            return "1";
        }
        catch
        {
            return "0";
        }
    }
    public static string SavePanelMaster(string CompanyName, string Addr1, string Addr2, string HospitalCode, string PanelCode, string IsTPA, string Email, string Phone,
       string Mobile, string ContactPerson, string Fax, string RefCodeOPD, string RefCodeIPD, string Agreement, string isServiceTax, string DateFrom, string DateTo, string CreditLimit,
       string PaymentMode, string PanelGroup, MySqlTransaction tnx, int PanelGroupID, int HideRate, int ShowPrintOut, int coPaymentOn, double coPaymentPercent, int rateCurrencyCountryID, int BillCurrencyCountryID, string BillCurrencyCountryName, decimal BillCurrencyConversion, int IsCash, int coverNote, decimal PanelAmountLimit, int IsPrivateDiet,int IsSmartCard)
    {
        try
        {
            PanelMaster objPanel = new PanelMaster(tnx);
            objPanel.Company_Name = CompanyName;
            objPanel.Add1 = Addr1;
            objPanel.Add2 = Addr2;
            objPanel.Hospital_ID = HospitalCode;
            objPanel.Panel_Code = PanelCode;
            objPanel.IsTPA = IsTPA;
            objPanel.EmailID = Email;
            objPanel.Phone = Phone;
            objPanel.Mobile = Mobile;
            objPanel.Contact_Person = ContactPerson;
            objPanel.Fax_No = Fax;
            objPanel.ReferenceCode = RefCodeIPD;
            objPanel.ReferenceCodeOPD = RefCodeOPD;
            objPanel.Agreement = Agreement;
            objPanel.isServiceTax = isServiceTax;
            objPanel.DateFrom = DateFrom;
            objPanel.DateTo = DateTo;
            objPanel.CreditLimit = CreditLimit;
            objPanel.PaymentMode = PaymentMode;
            objPanel.PanelGroup = PanelGroup;
            objPanel.IPAddress = All_LoadData.IpAddress();
            objPanel.PanelGroupID = PanelGroupID;
            objPanel.CreatedBy = HttpContext.Current.Session["ID"].ToString();
            objPanel.HideRate = HideRate;
            objPanel.ShowPrintOut = ShowPrintOut;
            objPanel.co_PaymentOn = coPaymentOn;
            objPanel.co_PaymentPercent = coPaymentPercent;
            objPanel.rateCurrencyCountryID = rateCurrencyCountryID;
            objPanel.BillCurrencyCountryID = BillCurrencyCountryID;
            objPanel.BillCurrencyCountryName = BillCurrencyCountryName;
            objPanel.BillCurrencyConversion = BillCurrencyConversion;
            objPanel.IsCash = IsCash;
            objPanel.CoverNote = coverNote;
            objPanel.PanelAmountLimit = PanelAmountLimit;
            objPanel.IsPrivateDiet = IsPrivateDiet;
            objPanel.IsSmartCard = IsSmartCard;
            string PanelId = objPanel.Insert();
            return PanelId;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    public static string stateInsert(string CountryID, string StateName)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM master_State WHERE StateName='" + StateName + "'  AND CountryID='" + CountryID + "' "));
            if (count > 0)
                return "0";
            else
            {
                LoadCacheQuery.dropCache("State");

                string s = "INSERT INTO master_State(StateName,CountryID,EntryBy,IPAddress) VALUES('" + StateName + "','" + CountryID + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "')";
                StockReports.ExecuteDML(s);
                return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(StateID) FROM master_State"));

            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return "";
        }
    }
    public static string FieldBoyInsert(string Name, string Address, string ContactNo)
    {
        try
        {
            string s = "INSERT INTO master_fieldboy(FieldBoyName,Address,ContactNo,CreatedBy,IPAddress) VALUES('" + Name + "','" + Address + "','" + ContactNo + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "')";
            StockReports.ExecuteDML(s);
            return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(FieldBoyID) FROM master_fieldboy"));
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return "0";
        }

    }
    public string InsertMedicalCertificate(string MRNo, string PName, string Address, string RelationName, string Gender, string Age, string Diagnosis, string FDate, string TDate, string Remarks, string DoctorName, string DSignature, string docdept, string TransactionID, string UserId)
    {
        try
        {
            string str = "INSERT INTO medicalcertificate(MRNO,PName,Address,RelationName,Gender,Age,Diagnosis,FDate,TDate,Remarks,UserID,DoctorName,DSignature,docdept,TransactionID) VALUES ";
            str += "('" + MRNo + "','" + PName + "','" + Address + "','" + RelationName + "','" + Gender + "','" + Age + "','" + Diagnosis + "','" + FDate + "','" + TDate + "','" + Remarks + "','" + UserId + "','" + DoctorName + "','" + DSignature + "','" + docdept + "','" + TransactionID + "')";
            StockReports.ExecuteDML(str);
            return Util.GetString(StockReports.ExecuteScalar("select Max(ID) from medicalcertificate"));
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return "0";
        }
    }
    public static string InsertDeathCertificate(string PatientID, string TransactionID, string NAME, string RelationName, string Gender, string Age, string Address, string PronounceDate, string PronounceTime, string DeathDate, string DeathTime, string DeathNature, string DeathCause, string DoctorId, string DoctorName, string CertifiedDoctorId, string CertifiedDoctorName, string BodyHandOveredTo)
    {
        try
        {
            string str = "INSERT INTO DeathCertificate(PatientID,TransactionID,NAME,RelationName,Gender,Age,Address,PronounceDate,PronounceTime,DeathDate,DeathTime,DeathNature,DeathCause, ";
            str += "DoctorId,DoctorName,CertifiedDoctorId,CertifiedDoctorName,BodyHandOveredTo,UserId,IpAddress) ";
            str += "VALUES('" + PatientID + "','" + TransactionID + "','" + NAME + "','" + RelationName + "','" + Gender + "','" + Age + "','" + Address + "','" + PronounceDate + "','" + PronounceTime + "','" + DeathDate + "','" + DeathTime + "','" + DeathNature + "','" + DeathCause + "', ";
            str += "'" + DoctorId + "','" + DoctorName + "','" + CertifiedDoctorId + "','" + CertifiedDoctorName + "','" + BodyHandOveredTo + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "') ";
            StockReports.ExecuteDML(str);
            return Util.GetString(StockReports.ExecuteScalar("select MAX(ID) from DeathCertificate"));
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return "0";
        }
    }
	public static string hrCity_master(string City)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM pay_city_master where City='" + City + "' "));
            if (count > 0)
                return "0";
            else
            {
                string s = "INSERT INTO pay_city_master(City,createdBy,CreatedCentreID,IPAddress,IsActive) values('" + City + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + 1 + "','" + HttpContext.Current.Request.UserHostAddress + "'," + 1 + ")";
                StockReports.ExecuteDML(s);
                return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(ID) FROM city_master"));
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }


    public static string PurposeVisit(string VisitName)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM master_purposeofvisit WHERE PurposeName='" + VisitName + "' "));
            if (count > 0)
                return "0";
            else
            {
                LoadCacheQuery.dropCache("PurposeOfVisit");
                string s = "INSERT INTO master_purposeofvisit(PurposeName,CreatedBy,IsActive,CreatedDate) values('" + VisitName + "','" + HttpContext.Current.Session["ID"].ToString() + "','1',Now())";
                StockReports.ExecuteDML(s);
                return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(PurposeID) FROM master_purposeofvisit"));
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }
}