<%@ WebService Language="C#" Class="EMR" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class EMR : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string DRHeader(string Header, string TID)
    {
        try
        {
            StockReports.ExecuteDML("Update emr_ipd_details set Header = '" + Header + "',PreparedBy='" + Util.GetString(Session["ID"]) + "',LastUpdatedBy='" + Util.GetString(Session["ID"]) + "',UpdateDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress='" + Util.GetString(HttpContext.Current.Request.UserHostAddress) + "' where TransactionID='" + TID.ToString() + "'");

            All_LoadData.updateNotification(Util.GetString(TID), "", "", 30, null, "EMR");

            return "1";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return "0";
        }


    }

    [WebMethod(EnableSession = true)]
    public string ConsultantAdd(string DoctorID, string TID, int IsMainDoctor, string doctorName)
    {
        int s = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM patient_medical_history WHERE TransactionID='" + TID + "' AND (DoctorID ='" + DoctorID + "' OR DoctorID1='" + DoctorID + "')"));
        int s1 = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_multipledoctor_ipd WHERE TransactionID='" + TID + "' AND doctorID='" + DoctorID + "'"));
        int s2 = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM emr_patient_doctor WHERE TransactionID='" + TID + "' AND doctorID='" + DoctorID + "'"));

        MySqlConnection con = new MySqlConnection();
        try
        {
            if ((s == 0) && (s1 == 0) && (s2 == 0))
            {
                con = Util.GetMySqlCon();
                con.Open();
                if (IsMainDoctor == 0)
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO emr_patient_doctor(TransactionID,doctorID) VALUES('" + TID.ToString() + "','" + DoctorID + "')");
                else
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO f_multipledoctor_ipd(TransactionID,DoctorID,DoctorName) VALUES('" + TID.ToString() + "','" + DoctorID + "','" + doctorName + "')");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE patient_medical_history pmh2 SET pmh2.`DoctorID`=IF(pmh2.`DoctorID`='',	(SELECT mpi.`DoctorID` FROM f_multipledoctor_ipd mpi  WHERE TransactionID=pmh2.TransactionID LIMIT 1),pmh2.`DoctorID`),pmh2.`DoctorID1`=IFNULL((SELECT mpi.`DoctorID` FROM f_multipledoctor_ipd mpi  WHERE TransactionID=pmh2.TransactionID LIMIT 1,1),'')  WHERE pmh2.TransactionID='" + TID.ToString() + "' ");
                }

                return "1";
            }
            else
            {
                return "0";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    
    [WebMethod(EnableSession = true)]
    public string bindConsultant(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT TID,TransactionID,doctorID,Name,Specialization,Master,IsUpdate FROM (");
        sb.Append(" SELECT REPLACE(pmh1.TransactionID,'ISHHI','')TID,pmh1.TransactionID AS TransactionID,dm1.DoctorID AS doctorID,dm1.Name,dm1.Specialization,'1' Master,'0' IsUpdate ");
        sb.Append(" FROM patient_medical_history pmh1 INNER JOIN doctor_master dm1 ON dm1.DoctorID=pmh1.DoctorID  ");
        sb.Append(" WHERE pmh1.TransactionID='" + TID + "' ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT REPLACE(pmh2.TransactionID,'ISHHI','')TID,pmh2.TransactionID AS TransactionID,pmh2.DoctorID1 AS doctorID,dm2.Name,dm2.Specialization,'1' Master,'1' IsUpdate  ");
        sb.Append(" FROM patient_medical_history pmh2 INNER JOIN  doctor_master dm2 ON dm2.DoctorID=pmh2.DoctorID1   ");
        sb.Append(" WHERE pmh2.TransactionID='" + TID + "'   ");
        sb.Append(" UNION ALL   ");
        sb.Append(" SELECT REPLACE(mpi.TransactionID,'ISHHI','')TID,mpi.TransactionID,mpi.doctorID,dm3.Name,dm3.Specialization,'1' Master,'1' IsUpdate  ");
        sb.Append(" FROM f_multipledoctor_ipd mpi INNER JOIN doctor_master dm3 ON mpi.doctorID=dm3.DoctorID  ");
        sb.Append(" WHERE TransactionID='" + TID + "'  ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT REPLACE(em.TransactionID,'ISHHI','')TID,em.TransactionID,em.doctorID,dm.Name,dm.Specialization,'0' Master,'1' IsUpdate  ");
        sb.Append(" FROM emr_patient_doctor em INNER JOIN doctor_master dm ON em.doctorID=dm.DoctorID  ");
        sb.Append(" WHERE isactive=1 AND TransactionID='" + TID + "'  ");
        sb.Append(")t GROUP BY t.DoctorID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string DeleteConsultant(string TID, string DoctorID, int Master)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (Master == 1)
            {
                int isLastDoctor = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT ipdDoctorValidationNew('" + TID + "','" + DoctorID + "')"));
                if (isLastDoctor >0)
                {
                    Tnx.Rollback();
                    return "2";
                }

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " CALL updateIpdMainDoctor('" + TID + "','" + DoctorID + "') ");
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " DELETE FROM emr_patient_doctor WHERE doctorID='" + DoctorID + "' AND TransactionID='" + TID + "' ");
            }

            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string saveEmrFooter(string TID, string Footer, string PreparedBy)
    {
        try
        {
            StockReports.ExecuteDML("Update emr_ipd_details set Footer = '" + HttpUtility.UrlDecode(Footer) + "', PreparedBy = '" + HttpUtility.UrlDecode(PreparedBy) + "' where TransactionID='" + TID + "'");
            All_LoadData.updateNotification(Util.GetString(TID), "", "", 30, null, "EMR");

            return "1";
        }

        catch
        {
            return "0";
        }
    }
    [WebMethod(Description = "EMR Search")]
    public string EMRSearch(string PatientId, string PatientName, string TransactionId, string RoomID, string DoctorID, string Company, string FromAdmitDate, string ToAdmitDate, string DischargeDateFrom, string DischargeDateTo, string VisitDateFrom, string VisitDateTo, string status)
    {

        DataTable dt = CreateStockMaster.SearchPatientEMR(PatientId, PatientName, TransactionId, RoomID, DoctorID, Company, FromAdmitDate, ToAdmitDate, DischargeDateFrom, DischargeDateTo, VisitDateFrom, VisitDateTo, status, 1);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string EMRPatientDetail(string TransactionId, string Type)
    {
        DataTable dt = new DataTable();
        if (Type == "Discharge")
        {
            dt = CreateStockMaster.GetAdmitDetail(TransactionId, Type);
        }
        else
        {
            dt = CreateStockMaster.GetAdmitDetail(TransactionId, Type);
        }
        if (dt != null && dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string EMRFrame(int RoleID)
    {


        DataTable dt = StockReports.GetDataTable(" SELECT fmm.FileName,fmm.URL,fmm.FrameName FROM f_framemenumaster fmm INNER JOIN f_frame_role ffr ON fmm.ID=ffr.URLID " +
                    " WHERE fmm.IsActive=1 AND ffr.IsActive=1 AND ffr.RoleID=" + RoleID + " ORDER BY ffr.SequenceNo");
        if (dt.Rows.Count > 0)
        {
            string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }

        else
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    public string EMRMedicine(string TID, string Header, string Medicine, string Route, string Timefornxtdose, string Dose, string Time, string Days, string Script, string Reason, string ID, string Meal)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (ID != "")
            {
                string sql = "Delete from  discharge_medicine  where ID='" + ID + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sql);
            }
            string strQuery = "INSERT INTO discharge_medicine(TransactionID,message,Medicinename,Dose,time,Route,days,Time_next_Dose,Script,Remarks,EnteredBy,Enterdate,Meal) VALUES('" + TID + "','" + Header + "','" + Medicine + "','" + Dose + "','" + Time + "','" + Route + "','" + Days + "','" + Timefornxtdose + "','" + Script + "','" + Reason + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Meal + "');";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
            Tranx.Commit();

            return "1";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();

            return "0";
        }

        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string bindEMRMedicine(string TID)
    {

        DataTable dt = StockReports.GetDataTable("select ID,message as Header,MedicineName as Medicine,Dose,Route, days,time,Time_next_Dose as Timefornxtdose,Script ,Remarks as Reason,Meal from discharge_medicine where TransactionID='" + TID + "'order by header");
        if (dt != null && dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string deleteEMRMedicine(string TID, string medicineName, string Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sql = "Delete from  discharge_medicine  where MedicineName='" + medicineName + "' and ID='" + Id + "' And TransactionID='" + TID + "'";

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sql);
            Tranx.Commit();

            return "1";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            return "0";
        }

        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string bindEMRInvItem(string TID)
    {
        StringBuilder str = new StringBuilder();
        str.Append(" select distinct DeptName,LabInvestigationIPD_ID,RoleID Role_ID,Date,SampleDate,InvestigationID,TransactionID,Test_ID,LabInves_Description,ID,RoleID,ObservationType_ID,LedgerTransactionNo, ");
        str.Append(" Investigation_Id,Name,ReportType,FileLimitationName,Department, ");
        str.Append(" DoctorName,Designation,Dept,Validation ,Remarks, IsPrint,case IsPrint when '' then 'false' else 'true' end IsEnter ");
        str.Append(" from  ");
        str.Append(" ( ");
        str.Append(" select plo.*,im.Investigation_Id,im.Name,im.ReportType,im.FileLimitationName,om.Name Department,  ");
        str.Append(" lf.DoctorName,Designation,Dept,Validation ,IF(IFNULL(epi.Remarks,'')='',IFNULL((SELECT FindingText FROM patient_labobservation_opd_text WHERE Test_ID=plo.Test_ID ORDER BY Test_ID DESC LIMIT 1),''),epi.Remarks)Remarks,IFNULL(EPI.IsPrint,'')IsPrint from Investigation_master im inner join   ");
        str.Append(" (select LabInvestigationOPD_ID AS LabInvestigationIPD_ID,date_format(date,'%d-%b-%Y') as Date,SampleDate,pli.Investigation_ID as InvestigationID,TransactionID,Test_ID,  ");
        str.Append(" IFNULL((Select LabInves_Description from patient_labinvestigation_opd_text where PLO_ID=pli.ID ORDER BY PLO_ID DESC LIMIT 1),'')LabInves_Description,");
        str.Append(" pli.ID,RoleID,iot.ObservationType_ID,LedgerTransactionNo   ");
        str.Append(" ,otm.Name DeptName ");
        str.Append(" from patient_labinvestigation_OPD pli inner join investigation_observationtype iot on iot.Investigation_ID = pli.Investigation_ID   ");
        str.Append(" inner join f_categoryrole cr on  cr.ObservationType_ID=iot.ObservationType_ID   ");
        str.Append(" inner join observationtype_master otm on otm.ObservationType_ID=iot.ObservationType_ID ");
        str.Append(" where  pli.TransactionID='" + TID + "'  And pli.Result_flag=1 And pli.approved=1 ");
        str.Append(" ) plo   ");
        str.Append(" on plo.InvestigationID = im.Investigation_Id  ");
        str.Append(" inner join observationtype_master om on om.observationtype_Id = plo.observationtype_ID  ");
        str.Append(" left outer join labdept_footer lf on lf.roleID = plo.roleID  ");
        str.Append(" left outer join emr_patient_investigation EPI on (EPI.TransactionID=plo.TransactionID and EPI.Investigation_ID=plo.InvestigationID  and EPI.Test_ID=plo.Test_ID )  ");
        str.Append(" ) aa Group by LabInvestigationIPD_ID ");
        str.Append(" Union all ");
        str.Append(" select distinct DeptName,LabInvestigationOPD_ID,RoleID Role_ID,Date,SampleDate,InvestigationID,TransactionID,Test_ID,LabInves_Description,ID,RoleID,ObservationType_ID,LedgerTransactionNo, ");
        str.Append(" Investigation_Id,Name,ReportType,FileLimitationName,Department, ");
        str.Append(" DoctorName,Designation,Dept,Validation ,Remarks, IsPrint,case IsPrint when '' then 'false' else 'true' end IsEnter ");
        str.Append(" from  ");
        str.Append(" ( ");
        str.Append(" select plo.*,im.Investigation_Id,im.Name,im.ReportType,im.FileLimitationName,om.Name Department,  ");
        str.Append(" lf.DoctorName,Designation,Dept,Validation ,IFNULL(EPI.Remarks,'')Remarks,IFNULL(EPI.IsPrint,'')IsPrint from Investigation_master im inner join   ");
        str.Append(" (select LabInvestigationOPD_ID,date_format(date,'%d-%b-%Y') as Date,SampleDate,pli.Investigation_ID as InvestigationID,pli.IPNo AS TransactionID,Test_ID,  ");
        str.Append(" IFNULL((Select LabInves_Description from patient_labinvestigation_opd_text where PLO_ID=pli.ID ORDER BY PLO_ID DESC LIMIT 1),'')LabInves_Description,");
        str.Append(" pli.ID,RoleID,iot.ObservationType_ID,LedgerTransactionNo   ");
        str.Append(" ,otm.Name DeptName,pli.IPNo ");
        str.Append(" from patient_labinvestigation_OPD pli inner join investigation_observationtype iot on iot.Investigation_ID = pli.Investigation_ID   ");
        str.Append(" inner join f_categoryrole cr on  cr.ObservationType_ID=iot.ObservationType_ID   ");
        str.Append(" inner join observationtype_master otm on otm.ObservationType_ID=iot.ObservationType_ID ");
        str.Append(" where  pli.IPNo='" + TID + "' And pli.Result_flag=1 And pli.approved=1  ");
        str.Append(" ) plo  ");
        str.Append(" on plo.InvestigationID = im.Investigation_Id  ");
        str.Append(" inner join observationtype_master om on om.observationtype_Id = plo.observationtype_ID  ");
        str.Append(" left outer join labdept_footer lf on lf.roleID = plo.roleID  ");
        str.Append(" left outer join emr_patient_investigation EPI on (EPI.TransactionID=plo.IPNo and EPI.Investigation_ID=plo.InvestigationID  and EPI.Test_ID=plo.Test_ID )  ");
        str.Append(" GROUP BY plo.ID ) aa  ");
        DataTable dt = StockReports.GetDataTable(str.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public string saveEMRInvItem(object InvNumeric, object InvText)
    {
        List<NumericInv> NumericInv = new JavaScriptSerializer().ConvertToType<List<NumericInv>>(InvNumeric);
        List<TextLabInv> NumericText = new JavaScriptSerializer().ConvertToType<List<TextLabInv>>(InvText);
        string query = ""; string query1; string query2;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            if (NumericInv.Count > 0)
            {
                query = "delete from emr_patient_investigation where TransactionID='" + HttpUtility.UrlDecode(NumericInv[0].TransactionID) + "'";

            }
            else if (NumericText.Count > 0)
            {
                query = "delete from emr_patient_investigation where TransactionID='" + HttpUtility.UrlDecode(NumericText[0].TransactionID) + "'";

            }
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, query);
            if (NumericInv.Count > 0)
            {
                for (int i = 0; i < NumericInv.Count; i++)
                {
                    query1 = "insert into emr_patient_investigation(PatientID,TransactionID,Investigation_ID,LabInvestigationIPD_ID,Remarks,IsPrint,UserID,Test_ID)values('" + HttpUtility.UrlDecode(NumericInv[i].PatientID) + "','" + HttpUtility.UrlDecode(NumericInv[i].TransactionID) + "','" + HttpUtility.UrlDecode(NumericInv[i].Investigation_ID) + "','" + HttpUtility.UrlDecode(NumericInv[i].LabInvestigationIPD_ID) + "','" + HttpUtility.UrlDecode(NumericInv[i].Remarks) + "',1,'" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpUtility.UrlDecode(NumericInv[i].Test_ID) + "')";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, query1);
                }
            }

            if (NumericText.Count > 0)
            {
                for (int i = 0; i < NumericText.Count; i++)
                {
                    query2 = "insert into emr_patient_investigation(PatientID,TransactionID,Investigation_ID,LabInvestigationIPD_ID,Remarks,IsPrint,UserID,Test_ID)values('" + HttpUtility.UrlDecode(NumericText[i].PatientID) + "','" + HttpUtility.UrlDecode(NumericText[i].TransactionID) + "','" + HttpUtility.UrlDecode(NumericText[i].Investigation_ID) + "','" + HttpUtility.UrlDecode(NumericText[i].LabInvestigationIPD_ID) + "','" + HttpUtility.UrlDecode(NumericText[i].Remarks) + "',1,'" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpUtility.UrlDecode(NumericText[i].Test_ID) + "')";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, query2);
                }
            }

            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class NumericInv
    {
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
        public string Investigation_ID { get; set; }
        public string LabInvestigationIPD_ID { get; set; }
        public string Remarks { get; set; }
        public string Test_ID { get; set; }


    }
    public class TextLabInv
    {
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
        public string Investigation_ID { get; set; }
        public string LabInvestigationIPD_ID { get; set; }
        public string Remarks { get; set; }
        public string Test_ID { get; set; }


    }
    [WebMethod(EnableSession = true)]
    public string bindEMRHeader()
    {
        DataTable header = StockReports.GetDataTable("Select Header_ID,HeaderName,IsActive,SeqNo,'Active' Active,'DeActive' DeActive  From d_discharge_header order by SeqNo+0");
        if (header != null && header.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(header);
        }
        else
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    public string saveEMRHeader(string HeaderName)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int seqNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "Select IFNULL(MAX(SeqNo+1),1)+0 SeqNo from NoteTypeHeaderMaster"));
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Insert Into NoteTypeHeaderMaster(HeaderName,SeqNo,IsActive)VALUES('" + HeaderName + "'," + seqNo + ",1)");
            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public string saveEMRHeaderTable(object EMR)
    {
        List<EMRHeader> EMRHeader = new JavaScriptSerializer().ConvertToType<List<EMRHeader>>(EMR);
        if (EMRHeader.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE  FROM d_discharge_header");
                for (int i = 0; i < EMRHeader.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO d_discharge_header(Header_ID,HeaderName,SeqNo,IsActive)VALUES('" + EMRHeader[i].HeaderID + "','" + HttpUtility.UrlDecode(EMRHeader[i].HeaderName) + "','" + (Util.GetInt(i) + 1) + "','" + HttpUtility.UrlDecode(EMRHeader[i].Active) + "') ");
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
        {
            return "";
        }
    }
    public class EMRHeader
    {
        public string SNo { get; set; }
        public string HeaderID { get; set; }
        public string HeaderName { get; set; }
        public string SequenceNo { get; set; }
        public string Active { get; set; }



    }

    [WebMethod]
    public string BindHeader()
    {
        string str = "SELECT Header_Id, HeaderName FROM d_discharge_header WHERE isactive=1 and HeaderName<>'' ORDER BY HeaderName";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod(EnableSession = true)]
    public string SaveDischargeType(string DischargeType, string HeaderType, int DepartmentId, int MendtoryType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            //var IpAddress = HttpContext.Current.Request.UserHostAddress;
            var message = "";

            string str = "SELECT COUNT(*) FROM d_setheader_Mandatory WHERE isactive=1 and DischargeName = '" + DischargeType + "' and HeaderId = '" + HeaderType + "' and DepartmentId='"+DepartmentId+"'";


            var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Discharge Type Already Exists" });
            }


            string sqlCMD = "INSERT INTO d_setheader_Mandatory (DischargeName,HeaderId,IsActive,CreatedBy,CreatedDateTime,DepartmentID,mandatoryType) VALUES(@DischargeType,@HeaderType,1,@CreatedBy,Now(),@DepartmentID,@mandatoryType);";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                DischargeType = DischargeType,
                HeaderType = HeaderType,
                CreatedBy = UserID,
                DepartmentID=Util.GetInt(DepartmentId),
                mandatoryType=Util.GetInt(MendtoryType)
            });
            message = "Record Save Successfully";


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string bindDischargeType(string DischargeName)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT shm.Id,shm.DischargeName,ddh.HeaderName, ");
        sb.Append("CONCAT(CONCAT(em.Title,em.Name))CreatedBy , ");
        sb.Append("DATE_FORMAT(shm.CreatedDateTime,'%d-%b-%Y')DateTime,tm.NAME AS DepartmentName,if(shm.mandatoryType=0,'No','Yes')mandatoryType ");
        sb.Append("FROM d_setheader_Mandatory shm ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID= shm.CreatedBy ");
        sb.Append("INNER JOIN d_discharge_header ddh ON ddh.Header_Id= shm.HeaderId ");
        sb.Append(" INNER JOIN type_master tm ON tm.ID = shm.DepartmentID ");
        sb.Append("WHERE 1=1 and shm.IsActive=1 ");
        if (DischargeName != "")
            sb.Append(" and shm.DischargeName = '" + DischargeName + "' ");
        sb.Append(" Order By DischargeName ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string deleteDischargeType(int Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update d_setheader_Mandatory set IsActive=0 where Id=" + Util.GetInt(Id) + " ");
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Deleted Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured. Please contact to Administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string GetDischargeType(string Id)
    {
        string strd = "SELECT Header FROM emr_ipd_details ed  where ed.TransactionID = '" + Id + "' ";
        DataTable dt1 = StockReports.GetDataTable(strd);
        string DischargeSummaryName = dt1.Rows[0]["Header"].ToString();
        string str = "SELECT  shm.Id,shm.DischargeName,ddh.HeaderName,shm.mandatoryType FROM d_setheader_Mandatory shm INNER JOIN d_discharge_header ddh ON ddh.Header_Id= shm.HeaderId WHERE  shm.IsActive=1 AND DischargeName='" + DischargeSummaryName + "' ";
        DataTable dt = StockReports.GetDataTable(str);

        string str2 = "SELECT Header_ID Header_ID,HeaderName,Detail Value,''TempHeadName,0 TempFlag,Approved FROM emr_DRDetail edr INNER JOIN emr_ipd_details eid ON eid.Transactionid=edr.Transactionid WHERE edr.Transactionid='" + Id + "'";
        DataTable dtAdded = StockReports.GetDataTable(str2);

        return Newtonsoft.Json.JsonConvert.SerializeObject(new { dtmandatory = dt, dtadded = dtAdded });

    }

    [WebMethod]
    public string BindDepartment()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Distinct tm.NAME as Department,tm.ID FROM type_master tm inner join Doctor_master Dm on Dm.DocDepartmentID=tm.ID  WHERE TypeID =5 ORDER BY tm.NAME");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return "";

    }
    [WebMethod]
    public string BinddischargeHeaderDepartmentwise(string DepartmentID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT Header_Id,HeaderName FROM d_Header_DeptWise WHERE Department=" + DepartmentID + " AND ISACTIVE=1 ORDER BY HeaderName");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return "0";

    }
    [WebMethod(EnableSession = true)]
    public string saveNoteTypeHeaderTable(object EMR)
    {
        List<EMRHeader> EMRHeader = new JavaScriptSerializer().ConvertToType<List<EMRHeader>>(EMR);
        if (EMRHeader.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE  FROM NoteTypeHeaderMaster");
                for (int i = 0; i < EMRHeader.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO NoteTypeHeaderMaster(Header_ID,HeaderName,SeqNo,IsActive)VALUES('" + EMRHeader[i].HeaderID + "','" + HttpUtility.UrlDecode(EMRHeader[i].HeaderName) + "','" + (Util.GetInt(i) + 1) + "','" + HttpUtility.UrlDecode(EMRHeader[i].Active) + "') ");
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public string bindNoteTypeHeader()
    {
        DataTable header = StockReports.GetDataTable("Select Header_ID,HeaderName,IsActive,SeqNo,'Active' Active,'DeActive' DeActive  From NoteTypeHeaderMaster order by SeqNo+0");
        if (header != null && header.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(header);
        }
        else
        {
            return "";
        }
    }


    [WebMethod(EnableSession = true)]
    public string saveNoteTypeHeader(string HeaderName)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int seqNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "Select IFNULL(MAX(SeqNo+1),1)+0 SeqNo from NoteTypeHeaderMaster"));
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Insert Into NoteTypeHeaderMaster(HeaderName,SeqNo,IsActive)VALUES('" + HeaderName + "'," + seqNo + ",1)");
            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public string saveNoteTypeTable(object EMR)
    {
        List<EMRHeader> EMRHeader = new JavaScriptSerializer().ConvertToType<List<EMRHeader>>(EMR);
        if (EMRHeader.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE  FROM NoteTypeMaster");
                for (int i = 0; i < EMRHeader.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO NoteTypeMaster(Header_ID,HeaderName,SeqNo,IsActive)VALUES('" + EMRHeader[i].HeaderID + "','" + HttpUtility.UrlDecode(EMRHeader[i].HeaderName) + "','" + (Util.GetInt(i) + 1) + "','" + HttpUtility.UrlDecode(EMRHeader[i].Active) + "') ");
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public string bindNoteTypeMaster()
    {
        DataTable header = StockReports.GetDataTable("Select Header_ID,HeaderName,IsActive,SeqNo,'Active' Active,'DeActive' DeActive  From NoteTypeMaster order by SeqNo+0");
        if (header != null && header.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(header);
        }
        else
        {
            return "";
        }
    }


    [WebMethod(EnableSession = true)]
    public string saveNoteTypeMaster(string HeaderName)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int seqNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "Select IFNULL(MAX(SeqNo+1),1)+0 SeqNo from NoteTypeMaster"));
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Insert Into NoteTypeMaster(HeaderName,SeqNo,IsActive)VALUES('" + HeaderName + "'," + seqNo + ",1)");
            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    public string SaveNoteTypemandtory(string NoteTypeID, string NoteTypeHeaderId, int MendtoryType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            //var IpAddress = HttpContext.Current.Request.UserHostAddress;
            var message = "";

            string str = "SELECT COUNT(*) FROM NoteType_setheader_mandatory WHERE isactive=1 and NoteTypeID = '" + NoteTypeID + "' and NoteTypeHeaderId = '" + NoteTypeHeaderId + "' ";


            var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Discharge Type Already Exists" });
            }


            string sqlCMD = "INSERT INTO NoteType_setheader_mandatory (NoteTypeID,NoteTypeHeaderId,IsActive,CreatedBy,CreatedDateTime,mandatoryType) VALUES(@NoteTypeID,@NoteTypeHeaderId,1,@CreatedBy,Now(),@mandatoryType);";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                NoteTypeID = NoteTypeID,
                NoteTypeHeaderId = NoteTypeHeaderId,
                CreatedBy = UserID,
                mandatoryType = Util.GetInt(MendtoryType)
            });
            message = "Record Save Successfully";


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string bindNotetypeHeaderwise(string NoteTypeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select nsm.Id,nm.HeaderName as NoteName,nhm.HeaderName as NoteHeaderName,CONCAT(CONCAT(em.Title,em.Name))CreatedBy ");
        sb.Append(" ,DATE_FORMAT(nsm.CreatedDateTime,'%d-%b-%Y')DATETIME,if(nsm.mandatoryType=0,'No','Yes')mandatoryType ,nsm.mandatoryType as Mandatory from NoteType_setheader_mandatory nsm ");
        sb.Append(" inner join NoteTypeMaster nm on nm.Header_Id=nsm.NoteTypeID ");
        sb.Append(" inner join NoteTypeHeaderMaster nhm on nhm.Header_Id=nsm.NoteTypeHeaderId ");
        sb.Append(" inner join employee_master em on em.EmployeeID=nsm.CreatedBy ");
        sb.Append(" where nsm.IsActive=1 ");
        if (NoteTypeID != "0" && NoteTypeID !=null)
            sb.Append(" and nsm.NoteTypeID = '" + NoteTypeID + "' ");
        sb.Append(" Order By nm.HeaderName ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string bindNoteTypemandatory(string TID)
    {

        string str = "SELECT  nsm.Id,ntm.HeaderName noteName,nthm.HeaderName AS HeaderName,nsm.mandatoryType FROM NoteType_setheader_mandatory nsm INNER JOIN NoteTypeMaster ntm ON nsm.NoteTypeID=ntm.Header_Id INNER JOIN NoteTypeHeaderMaster nthm ON nthm.Header_Id=nsm.NoteTypeHeaderId ";
        DataTable dt = StockReports.GetDataTable(str);
        string str2 = "SELECT Header_ID Header_ID,HeaderName,Detail Value,''TempHeadName FROM notecreationpatient_detail edr  WHERE edr.Transactionid='" + TID + "'";
        DataTable dtAdded = StockReports.GetDataTable(str2);
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { dtmandatory = dt, dtadded = dtAdded });

    }
    [WebMethod(EnableSession = true)]
    public string deleteMandtoryType(int Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update NoteType_setheader_mandatory set IsActive=0 where Id=" + Util.GetInt(Id) + " ");
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Deleted Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured. Please contact to Administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

   

   
}