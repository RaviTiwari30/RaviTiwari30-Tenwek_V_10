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

public partial class Design_IPD_WardTypeListManagment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }




    [WebMethod(EnableSession = true)]
    public static string Bindwardtypepatientlist(string RoomType, string PID, string TID, string Team, int IsOwnPatient)
    {

        string NewDr = Util.GetString(StockReports.ExecuteScalar("SELECT de.DoctorID FROM doctor_employee de WHERE de.EmployeeID='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' limit 1 "));
        string DRID = "";
        if (!string.IsNullOrEmpty(NewDr))
        {
            DRID = "'" + NewDr + "','" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "'";
        }
        else
        {
            DRID = "'" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "'";
        }

        string PrimaryTrId = "";
        string SecondaryTrId = "";
        string PrimaryTrIdFromTreatmentTeam = "";
        if (Team != "" && Team != "0")
        {
            PrimaryTrId = Util.GetString(StockReports.ExecuteScalar("SELECT  GROUP_CONCAT(fmi.TransactionID) FROM f_multipledoctor_ipd fmi WHERE fmi.DoctorID='" + Team + "' AND fmi.IsPrimary=1"));
            SecondaryTrId = Util.GetString(StockReports.ExecuteScalar("SELECT  GROUP_CONCAT(fmi.TransactionID) FROM f_multipledoctor_ipd fmi WHERE fmi.DoctorID='" + Team + "' AND fmi.IsPrimary=2"));

        }

        if (IsOwnPatient == 1)
        {
            PrimaryTrId = Util.GetString(StockReports.ExecuteScalar("SELECT  GROUP_CONCAT(fmi.TransactionID) FROM f_multipledoctor_ipd fmi WHERE fmi.DoctorID   IN (" + DRID + ") AND fmi.IsPrimary=1 "));
            SecondaryTrId = Util.GetString(StockReports.ExecuteScalar("SELECT  GROUP_CONCAT(fmi.TransactionID) FROM f_multipledoctor_ipd fmi WHERE fmi.DoctorID IN (" + DRID + ")  AND fmi.IsPrimary=2 "));
            PrimaryTrIdFromTreatmentTeam = Util.GetString(StockReports.ExecuteScalar("SELECT GROUP_CONCAT(dt.TransactionID) FROM f_doctotreatingteam dt WHERE  dt.STATUS='IN' AND dt.FirstcallDoctorID IN (" + DRID + ") "));

        }

        string[] PTrId = PrimaryTrId.Trim().Split(',');
        string[] PTrIdFTT = PrimaryTrIdFromTreatmentTeam.Trim().Split(',');
        string[] STrid = SecondaryTrId.Trim().Split(',');
        string PrimaryTrIds = "";
        string SecondaryTrIds = "";

        int PCount = 0;
        int SCount = 0;

        foreach (string item in PTrId)
        {
            if (PCount == 0)
            {
                PrimaryTrIds += "'" + item + "'";
            }
            else
            {
                PrimaryTrIds += ",'" + item + "'";
            }

            PCount = PCount + 1;

        }
        foreach (string item in PTrIdFTT)
        {
            if (PCount == 0)
            {
                PrimaryTrIds += "'" + item + "'";
            }
            else
            {
                PrimaryTrIds += ",'" + item + "'";
            }

            PCount = PCount + 1;
        }
        foreach (string item in STrid)
        {
            if (SCount == 0)
            {
                SecondaryTrIds += "'" + item + "'";
            }
            else
            {
                SecondaryTrIds += ",'" + item + "'";
            }

            SCount = SCount + 1;
        }

        DataTable dt = Getdata(RoomType, PID, TID, PrimaryTrIds, "Primary");
        DataTable dtSecondary = Getdata(RoomType, PID, TID, SecondaryTrIds, "Others");

        if (dt.Rows.Count > 0 && dtSecondary.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Pstatus = true, Sstatus = true, Primarydata = dt, Secondarydata = dtSecondary });
        }
        else if (dt.Rows.Count > 0 && dtSecondary.Rows.Count == 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Pstatus = true, Sstatus = false, Primarydata = dt, Secondarydata = "" });

        }
        else if (dt.Rows.Count == 0 && dtSecondary.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Pstatus = false, Sstatus = true, Primarydata = "", Secondarydata = dtSecondary });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Pstatus = false, Sstatus = false, response = "No Record Found" });
        }


    }

    public static DataTable Getdata(string RoomType, string PID, string TID, string PrimaryTransactionId, string Type)
    {

        DataTable dt = new DataTable();

        StringBuilder sb = new StringBuilder();


        sb.Append(" SELECT ifnull( concat(  if(ifnull(t.DateOfBirthInDay,0)>90,0, (((t.GaWeek*7)+t.GaDays+t.DateOfBirthInDay) div 7)),' Week ', if(ifnull(t.DateOfBirthInDay,0)>90,0, mod(((t.GaWeek*7)+t.GaDays+t.DateOfBirthInDay),7)),' Days '),'')CGA,  Concat( if(t.GaWeek=0,'',t.GaWeek),if(t.GaWeek=0,'',' Week '),if(t.GaDays=0,'',t.GaDays), if(t.GaDays=0,'',' Days '))GA,t.* from ( ");
        sb.Append(" SELECT   pmh.BillNo,pm.Gender AS Sex,pmh.PanelID,pmh.TransNo,CONCAT(icm.NAME,'/',rm.Room_No,'/',rm.Bed_No)Location,CONCAT(pm.Title,'',pm.PName)Pname, ");

        sb.Append(" ( SELECT IF(IF( IFNULL(v.Resp,'')<>'',v.Resp,0)<pdr.FromRange,'0',IF(IF( IFNULL(v.Resp,'')<>'',v.Resp,0)>pdr.ToRange,'2',IF(IF( IFNULL(v.Resp,'')<>'',v.Resp,0)>=pdr.FromRange && IF( IFNULL(v.Resp,'')<>'',v.Resp,0) <=pdr.ToRange,'1','4'))) ColorCode  ");
        sb.Append(" FROM PediatricRefferanceChartMaster pdr ");
        sb.Append("  WHERE pdr.Type='RR' AND pdr.AgeType=concat( '(',SUBSTRING_INDEX(pm.Age,' ',-1),')') AND  SUBSTRING_INDEX(pm.Age,' ',1) BETWEEN pdr.FromAge AND   pdr.ToAge AND IFNULL(pdr.RangeType,'')=''  ) RRColorCode , ");
        sb.Append(" ( SELECT IF(IF( IFNULL(v.Temp,'')<>'',v.Temp,0)<pdr.FromRange,'0',IF(IF( IFNULL(v.Temp,'')<>'',v.Temp,0)>pdr.ToRange,'2',IF(IF( IFNULL(v.Temp,'')<>'',v.Temp,0) >=pdr.FromRange && IF( IFNULL(v.Temp,'')<>'',v.Temp,0)<=pdr.ToRange,'1','4'))) ColorCode  ");
        sb.Append(" FROM PediatricRefferanceChartMaster pdr ");
        sb.Append("  WHERE pdr.Type='Temp' AND pdr.AgeType=concat( '(',SUBSTRING_INDEX(pm.Age,' ',-1),')')  AND  SUBSTRING_INDEX(pm.Age,' ',1) BETWEEN pdr.FromAge AND   pdr.ToAge AND IFNULL(pdr.RangeType,'')=''  ) TempColorCode , ");

        sb.Append(" ( SELECT IF( IF( IFNULL(SUBSTRING_INDEX(v.Bp,'/',1),'')<>'',SUBSTRING_INDEX(v.Bp,'/',1),0)<pdr.FromRange,'0',IF(IF( IFNULL(SUBSTRING_INDEX(v.Bp,'/',1),'')<>'',SUBSTRING_INDEX(v.Bp,'/',1),0)>pdr.ToRange,'2',IF(IF( IFNULL(SUBSTRING_INDEX(v.Bp,'/',1),'')<>'',SUBSTRING_INDEX(v.Bp,'/',1),0)>=pdr.FromRange && IF( IFNULL(SUBSTRING_INDEX(v.Bp,'/',1),'')<>'',SUBSTRING_INDEX(v.Bp,'/',1),0) <=pdr.ToRange,'1','4'))) ColorCode  ");
        sb.Append(" FROM PediatricRefferanceChartMaster pdr ");
        sb.Append("  WHERE pdr.Type='BP' AND pdr.AgeType=concat( '(',SUBSTRING_INDEX(pm.Age,' ',-1),')')  AND  SUBSTRING_INDEX(pm.Age,' ',1) BETWEEN pdr.FromAge AND   pdr.ToAge AND IFNULL(pdr.RangeType,'')='S'  ) SystolicColorCode , ");

        sb.Append(" ( SELECT IF(IF( IFNULL(SUBSTRING_INDEX(v.Bp,'/',-1),'')<>'',SUBSTRING_INDEX(v.Bp,'/',-1),0)<pdr.FromRange,'0',IF(IF( IFNULL(SUBSTRING_INDEX(v.Bp,'/',-1),'')<>'',SUBSTRING_INDEX(v.Bp,'/',-1),0)>pdr.ToRange,'2',IF(IF( IFNULL(SUBSTRING_INDEX(v.Bp,'/',-1),'')<>'',SUBSTRING_INDEX(v.Bp,'/',-1),0)>=pdr.FromRange && IF( IFNULL(SUBSTRING_INDEX(v.Bp,'/',-1),'')<>'',SUBSTRING_INDEX(v.Bp,'/',-1),0) <=pdr.ToRange,'1','4'))) ColorCode  ");
        sb.Append(" FROM PediatricRefferanceChartMaster pdr ");
        sb.Append("  WHERE pdr.Type='BP' AND pdr.AgeType=concat( '(',SUBSTRING_INDEX(pm.Age,' ',-1),')')  AND  SUBSTRING_INDEX(pm.Age,' ',1) BETWEEN pdr.FromAge AND   pdr.ToAge AND IFNULL(pdr.RangeType,'')='D'  ) DialoticColorCode , ");

        sb.Append(" (SELECT IF(Get_Current_Age(bbc.BabyUHID)  LIKE '%MONTH%', CEIL(SUBSTRING_INDEX(Get_Current_Age(bbc.BabyUHID),' ',1)*30), ");
        sb.Append("  IF(Get_Current_Age(bbc.BabyUHID)  LIKE '%DAYS%',SUBSTRING_INDEX(Get_Current_Age(bbc.BabyUHID),' ',1),0) )  FROM baby_chart bbc WHERE bbc.BabyUHID=pm.PatientID ORDER BY ID DESC LIMIT 1)DateOfBirthInDay, ");

        sb.Append(" pm.PatientID AS UHID,IFNULL(com.CodeType,'') AS 'CODE', ");
        sb.Append(" CONCAT(DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.TimeOfAdmit,'%l:%i %p'))DOA,pm.Age,CONCAT(dm.Title,' ',dm.NAME)FistCall,ifnull(bbc.GaWeek,0)GaWeek,ifnull(bbc.GaDays,0)GaDays, ");
        sb.Append(" DATEDIFF(CURDATE(),pmh.DateOfAdmit)Days,(SELECT IFNULL(GROUP_CONCAT(ploo.VALUE),'')LABRESULT FROM patient_labobservation_opd ploo INNER JOIN patient_labinvestigation_opd plo ON ploo.Test_ID=plo.Test_ID ");
        sb.Append(" WHERE ploo.LabObservation_ID IN('LSHHI220') AND  plo.transactionid=pmh.TransactionID) ISS,IFNULL(v.Weight,'')Weight,IFNULL(v.Height,'')Height,IFNULL(v.Bp,'')Bp,IFNULL(v.Temp,'')Temp,IFNULL(v.Resp,'')Resp, ");
        sb.Append(" IFNULL(v.Oxygen,'')Oxygen,IFNULL(CONCAT(( ");
        sb.Append(" SELECT  (CONCAT('HB',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo  ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID ");
        sb.Append(" WHERE plo.TransactionID=pmh.TransactionID ");
        sb.Append(" AND ploo.LabObservation_ID IN ('LSHHI2') ");
        sb.Append(" AND ploo.VALUE <>'' ");
        sb.Append(" GROUP BY ploo.LabObservation_ID ");
        sb.Append(" ORDER BY ploo.LabObservationName,ploo.ID DESC  ),',',( ");
        sb.Append(" SELECT  (CONCAT('NA',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo  ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID ");
        sb.Append(" WHERE plo.TransactionID=pmh.TransactionID ");
        sb.Append(" AND ploo.LabObservation_ID IN ('LSHHI267') ");
        sb.Append(" AND ploo.VALUE <>'' ");
        sb.Append(" GROUP BY ploo.LabObservation_ID ");
        sb.Append(" ORDER BY ploo.LabObservationName,ploo.ID DESC ),',',( ");
        sb.Append("   SELECT  (CONCAT('PL',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID ");
        sb.Append(" WHERE plo.TransactionID=pmh.TransactionID ");
        sb.Append(" AND ploo.LabObservation_ID IN ('LSHHI16') ");
        sb.Append(" AND ploo.VALUE <>'' ");
        sb.Append(" GROUP BY ploo.LabObservation_ID");
        sb.Append(" ORDER BY ploo.LabObservationName,ploo.ID DESC ");
        sb.Append(" ),',',( ");
        sb.Append(" SELECT  (CONCAT('CRE',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo  ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID ");
        sb.Append(" WHERE plo.TransactionID=pmh.TransactionID ");
        sb.Append(" AND ploo.LabObservation_ID IN ('LSHHI179') ");
        sb.Append(" AND ploo.VALUE <>'' ");
        sb.Append(" 	GROUP BY ploo.LabObservation_ID ");
        sb.Append(" ORDER BY ploo.LabObservationName,ploo.ID DESC  ");
        sb.Append(" ),',',( ");
        sb.Append(" SELECT  (CONCAT('K',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo  ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID ");
        sb.Append(" WHERE plo.TransactionID=pmh.TransactionID ");
        sb.Append(" AND ploo.LabObservation_ID IN ('LSHHI179') ");
        sb.Append(" AND ploo.VALUE <>'' ");
        sb.Append(" GROUP BY ploo.LabObservation_ID ");
        sb.Append(" ORDER BY ploo.LabObservationName,ploo.ID DESC  ");
        sb.Append(" )),'')LAB,'' ProblemList,( SELECT GROUP_CONCAT(SUBSTRING_INDEX(ta.ItemName,' ',1))  ");
        sb.Append("FROM  tenwek_docotor_medicine_order ta ");
        sb.Append(" WHERE ta.TransactionId=pmh.TransactionID  ");
        sb.Append(" AND ta.IsActive=1  ");
        sb.Append(" AND ta.IsDisContinue=0) Medicaation");
        sb.Append(" ,'' Plan ");
        sb.Append(" ,pmh.TransactionID,pmh.DoctorID,IFNULL( (SELECT pl.PlanNotes FROM doctorpatientnoteslist pl ");
        sb.Append("  WHERE pl.Active=1  ");
        sb.Append("  AND pl.TransactionID=pmh.TransactionID ORDER BY id DESC LIMIT 1) ,'')PlanNotes, ");
        sb.Append(" IFNULL((SELECT pl.ProblemNotes FROM doctorpatientnoteslist pl ");
        sb.Append("  WHERE pl.Active=1  ");
        sb.Append("  AND pl.TransactionID=pmh.TransactionID ORDER BY id DESC LIMIT 1),'')ProblemNotes, ");
        sb.Append("  '" + Type + "' Type ");
        sb.Append(" FROM patient_medical_history pmh  ");
        sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
        sb.Append(" INNER JOIN patient_ipd_profile pip  ON pip.TransactionID=pmh.TransactionID ");
        sb.Append(" INNER JOIN ipd_case_type_master  icm ON icm.IPDCaseTypeID=pip.IPDCaseTypeID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sb.Append(" INNER JOIN room_master rm ON rm.RoomID=pip.RoomID ");
        sb.Append(" LEFT JOIN baby_chart bbc ON bbc.BabyUHID=pm.PatientID ");

        sb.Append(" LEFT JOIN CodeMaster com ON com.ID=pmh.PatientCodeType ");
        sb.Append(" LEFT JOIN(SELECT Weight,Height,Oxygen,Bp,Temp,Resp,TransactionID FROM IPD_Patient_ObservationChart ");
        sb.Append(" ORDER BY id DESC  )v ON v.TransactionID=pmh.TransactionID ");

        sb.Append(" WHERE pip.STATUS='IN' AND pmh.TYPE='IPD' and  pmh.TransactionID in(" + PrimaryTransactionId + ") ");

        if (!string.IsNullOrEmpty(TID))
        {
            sb.Append(" AND pmh.TransactionID='" + TID + "' ");
        }
        if (!string.IsNullOrEmpty(PID))
        {
            sb.Append(" AND pmh.PatientID='" + PID + "' ");
        }
        if (!string.IsNullOrEmpty(RoomType) && RoomType != "0")
        {
            sb.Append(" AND icm.IPDCaseTypeID='" + RoomType + "' ");
        }

        sb.Append(" Group By pmh.TransactionID ");
        sb.Append(" ) t");
        dt = StockReports.GetDataTable(sb.ToString());
        DataColumn dc = new DataColumn("LoginType");
        if (dt.Rows.Count > 0)
        {

            dc.DefaultValue = HttpContext.Current.Session["RoleID"].ToString();
            dt.Columns.Add(dc);
        }
        return dt;



    }

    [WebMethod(EnableSession = true)]
    public static string Bindwardtypepatientlistreport(string RoomType, string PID, string TID, string Team, int IsOwnPatient)
    {
        string NewDr = Util.GetString(StockReports.ExecuteScalar("SELECT de.DoctorID FROM doctor_employee de WHERE de.EmployeeID='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' limit 1 "));
        string DRID = "";
        if (!string.IsNullOrEmpty(NewDr))
        {
            DRID = "'" + NewDr + "','" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "'";
        }
        else
        {
            DRID = "'" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "'";
        }

        string PrimaryTrId = "";
        string SecondaryTrId = "";
        string PrimaryTrIdFromTreatmentTeam = "";
        if (Team != "" && Team != "0")
        {
            PrimaryTrId = Util.GetString(StockReports.ExecuteScalar("SELECT  GROUP_CONCAT(fmi.TransactionID) FROM f_multipledoctor_ipd fmi WHERE fmi.DoctorID='" + Team + "' AND fmi.IsPrimary=1"));
            SecondaryTrId = Util.GetString(StockReports.ExecuteScalar("SELECT  GROUP_CONCAT(fmi.TransactionID) FROM f_multipledoctor_ipd fmi WHERE fmi.DoctorID='" + Team + "' AND fmi.IsPrimary=2"));

        }

        if (IsOwnPatient == 1)
        {
            PrimaryTrId = Util.GetString(StockReports.ExecuteScalar("SELECT  GROUP_CONCAT(fmi.TransactionID) FROM f_multipledoctor_ipd fmi WHERE fmi.DoctorID   IN (" + DRID + ") AND fmi.IsPrimary=1 "));
            SecondaryTrId = Util.GetString(StockReports.ExecuteScalar("SELECT  GROUP_CONCAT(fmi.TransactionID) FROM f_multipledoctor_ipd fmi WHERE fmi.DoctorID IN (" + DRID + ")  AND fmi.IsPrimary=2 "));
            PrimaryTrIdFromTreatmentTeam = Util.GetString(StockReports.ExecuteScalar("SELECT GROUP_CONCAT(dt.TransactionID) FROM f_doctotreatingteam dt WHERE  dt.STATUS='IN' AND dt.FirstcallDoctorID IN (" + DRID + ") "));

        }

        string[] PTrId = PrimaryTrId.Trim().Split(',');
        string[] PTrIdFTT = PrimaryTrIdFromTreatmentTeam.Trim().Split(',');
        string[] STrid = SecondaryTrId.Trim().Split(',');
        string PrimaryTrIds = "";
        string SecondaryTrIds = "";

        int PCount = 0;
        int SCount = 0;

        foreach (string item in PTrId)
        {
            if (PCount == 0)
            {
                PrimaryTrIds += "'" + item + "'";
            }
            else
            {
                PrimaryTrIds += ",'" + item + "'";
            }

            PCount = PCount + 1;

        }
        foreach (string item in PTrIdFTT)
        {
            if (PCount == 0)
            {
                PrimaryTrIds += "'" + item + "'";
            }
            else
            {
                PrimaryTrIds += ",'" + item + "'";
            }

            PCount = PCount + 1;
        }
        foreach (string item in STrid)
        {
            if (SCount == 0)
            {
                SecondaryTrIds += "'" + item + "'";
            }
            else
            {
                SecondaryTrIds += ",'" + item + "'";
            }

            SCount = SCount + 1;
        }

        DataTable dt = Getdata(RoomType, PID, TID, PrimaryTrIds, "Primary");
        dt.Columns.Remove("PanelID");
        dt.Columns.Remove("TransactionID");
        dt.Columns.Remove("DoctorID");
        dt.Columns.Remove("LoginType");

        dt.Columns["TransNo"].ColumnName = "IPDNo";

        DataTable dtSecondary = Getdata(RoomType, PID, TID, SecondaryTrIds, "Others");
        if (dtSecondary.Rows.Count > 0)
        {
            dtSecondary.Merge(dt, true, MissingSchemaAction.Ignore);

            //dtSecondary.Merge(dt);
            dtSecondary.AcceptChanges();

        }
        else
        {
            dtSecondary = dt;
        }


        if (dtSecondary.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dtSecondary;
            HttpContext.Current.Session["ReportName"] = "Ward Type Patient List";

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "No Record Found" });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" }); }


    }



    [WebMethod(EnableSession = true)]
    public static string bindpatientnotes(string TransactionID)
    {
        DataTable dt = StockReports.GetDataTable("select d.ID,Ifnull(ProblemNotes,'')ProblemNotes,Ifnull(PlanNotes,'')PlanNotes,TransactionID,concat(em.Title,' ',em.NAME)CreatedBy,DATE_FORMAT(d.CreatedDate,'%d-%b-%Y')CreatedDate from doctorpatientnoteslist d inner join employee_master em on em.EmployeeID=d.Createdby where TransactionID='" + TransactionID + "'");

        if (dt.Rows.Count > 0)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }

    [WebMethod(EnableSession = true)]
    public static string bindPMP(string TID)
    {
        DataTable dt = StockReports.GetDataTable("select d.ID,ProblemNotes,PlanNotes,TransactionID,( SELECT GROUP_CONCAT(SUBSTRING_INDEX(ta.ItemName,' ',1))  FROM  tenwek_docotor_medicine_order ta  WHERE ta.TransactionId=d.TransactionID   AND ta.IsActive=1   AND ta.IsDisContinue=0)Medication from doctorpatientnoteslist d where TransactionID='" + TID + "' ORDER BY D.ID desc limit 1");

        if (dt.Rows.Count > 0)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Problem,Plan & Medication Found.." }); }


    }

    [WebMethod(EnableSession = true)]
    public static string bindDoctorTeamList()
    {
        DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.name)DoctorName FROM doctor_master dm  WHERE  IsUnit=1 AND dm.IsActive=1 order by dm.name ");
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
    }


    [WebMethod(EnableSession = true)]
    public static string bindAddDoctorTeam(string TeamID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.name)DoctorName FROM doctor_master dm  WHERE  dm.IsUnit=1 AND dm.DoctorID<>'" + TeamID + "' AND dm.IsActive=1");
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
    }


    [WebMethod(EnableSession = true)]
    public static string RemoveInvolvedDr(string TransactionID, int IsTeam, string TeamId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";

            string NewDoctorId = "";
            string NewDoctorName = "";

            if (IsTeam == 0)
            {
                DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID, CONCAT(dm.Title,'',dm.NAME)drName FROM doctor_master dm INNER JOIN  doctor_employee de ON de.DoctorID=dm.DoctorID WHERE de.EmployeeID='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "'");

                if (dt.Rows.Count > 0)
                {
                    NewDoctorId = dt.Rows[0]["DoctorID"].ToString();
                    NewDoctorName = dt.Rows[0]["drName"].ToString();
                }
                else
                {
                    NewDoctorId = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                    NewDoctorName = Util.GetString(HttpContext.Current.Session["EmployeeName"].ToString()); ;
                }

            }
            else
            {
                DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID, CONCAT(dm.Title,'',dm.NAME)drName FROM doctor_master dm  WHERE dm.DoctorID='" + TeamId + "'");
                NewDoctorId = dt.Rows[0]["DoctorID"].ToString();
                NewDoctorName = dt.Rows[0]["drName"].ToString();
            }


            DataTable dtRow = StockReports.GetDataTable(" SELECT * FROM f_multipledoctor_ipd   WHERE  TransactionID='" + TransactionID + "' AND  DoctorID='" + NewDoctorId + "' ");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_multipledoctor_ipd   WHERE  TransactionID='" + TransactionID + "' AND  DoctorID='" + NewDoctorId + "' ");


            var sqlCMD = "insert into f_multipledoctor_ipd_removed (DoctorID, TransactionID, DoctorName,MId)value(@DoctorID,@TransactionID,@DoctorName,@MId)";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                DoctorID = NewDoctorId,
                TransactionID = TransactionID,
                DoctorName = NewDoctorName,
                MId = dtRow.Rows[0]["ID"].ToString()
            });

            message = "Removed Sucessfully";

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



    [WebMethod(EnableSession = true)]
    public static string AddInvolvedDr(string TransactionID, int IsTeam, string TeamId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string NewDoctorId = "";
            string NewDoctorName = "";

            if (IsTeam == 0)
            {
                DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID, CONCAT(dm.Title,'',dm.NAME)drName FROM doctor_master dm INNER JOIN  doctor_employee de ON de.DoctorID=dm.DoctorID WHERE de.EmployeeID='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "'");

                if (dt.Rows.Count > 0)
                {
                    NewDoctorId = dt.Rows[0]["DoctorID"].ToString();
                    NewDoctorName = dt.Rows[0]["drName"].ToString();
                }
                else
                {
                    NewDoctorId = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                    NewDoctorName = Util.GetString(HttpContext.Current.Session["EmployeeName"].ToString()); ;
                }

            }
            else
            {
                DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID, CONCAT(dm.Title,'',dm.NAME)drName FROM doctor_master dm  WHERE dm.DoctorID='" + TeamId + "'");
                NewDoctorId = dt.Rows[0]["DoctorID"].ToString();
                NewDoctorName = dt.Rows[0]["drName"].ToString();
            }


            DataTable dtcheck = StockReports.GetDataTable("SELECT * FROM f_multipledoctor_ipd dm  WHERE dm.DoctorID='" + NewDoctorId + "' AND dm.TransactionID='" + TransactionID + "'");

            if (dtcheck.Rows.Count > 0)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Doctor/Team Already Added To this Patient", message = "" });

            }

            var sqlCMD = "insert into f_multipledoctor_ipd (DoctorID, TransactionID, DoctorName,IsPrimary)value(@DoctorID,@TransactionID,@DoctorName,2)";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                DoctorID = NewDoctorId,
                TransactionID = TransactionID,
                DoctorName = NewDoctorName,
            });
            message = "Added Save Sucessfully";

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



    [WebMethod(EnableSession = true)]

    public static string SaveProblemNotes(string DoctorID, string TransactionID, string PatientID, string ProblemNote, string PlanNote)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";


            var sqlCMD = "insert into doctorpatientnoteslist (ProblemNotes,DoctorID,TransactionID,PatientID,Createdby,PlanNotes,Active,CreatedDate)value(@ProblemNotes,@DoctorID,@TransactionID,@PatientID,@Createdby,@PlanNotes,@Active,NOW())";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                ProblemNotes = ProblemNote,
                DoctorID = Util.GetString(DoctorID),
                TransactionID = TransactionID,
                PatientID = PatientID,
                PlanNotes = PlanNote,
                Createdby = HttpContext.Current.Session["ID"].ToString(),
                Active = 1

            });
            message = "Record Save Sucessfully";


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




}