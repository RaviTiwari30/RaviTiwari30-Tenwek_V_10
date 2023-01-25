using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using MySql.Data.MySqlClient;

public partial class Design_Token_CreateLaboratoryToken : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["RoleDept"] = Session["RoleID"].ToString();
            lblAppointmentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
        }
    }

    protected void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + Resources.Resource.RadiologyRoleId + "' ");
        sb.Append(" order by ot.Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            //ddlDepartment.DataSource = dt;
            //ddlDepartment.DataValueField = "ObservationType_ID";
            //ddlDepartment.DataTextField = "Name";
            //ddlDepartment.DataBind();
            //ddlDepartment.Items.Insert(0, "All");
        }
    }

    [WebMethod]
    public static string SearchToken()
    {
        DataTable dtInvest = Search();
        if (dtInvest.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtInvest);
        }
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string createToken(string LedgerTransactionNo, string Test_ID, string TestID, string LabInvestID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            //string DocDepartmentID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "Select docm.DocDepartmentID FROM patient_labinvestigation_opd PLO INNER JOIN doctor_master docm ON PLO.DoctorID=docm.DoctorID WHERE  PLO.LabInvestigationOPD_ID='" + LabInvestID + "' "));
            string tokenNo = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "select create_Laboratory_OPD_tokenNo('" + LedgerTransactionNo + "','" + Test_ID + "') "));
            string token = "UPDATE patient_labinvestigation_opd set IsCancelToken=0, TokenNo='" + tokenNo + "',TokenCreateBy='" + HttpContext.Current.Session["ID"].ToString() + "',TockenCreatedDate=CURDATE(),TokenCreatedTime=CURTIME() where Test_ID in(" + TestID + ") and LedgerTransactionNo='" + LedgerTransactionNo + "'   ";//and LabInvestigationOPD_ID='" + LabInvestID + "'
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, token);
            tranX.Commit();
            return tokenNo;
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
    public static string CancelToken(string LedgerTransactionNo, string Test_ID)
    {
        string FrmDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string ToDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string token = "UPDATE patient_labinvestigation_opd set  IsCancelToken=3,TokenCancelBy='" + HttpContext.Current.Session["ID"].ToString() + "',TokenCancelDateTime=NOW() where LedgerTransactionNo='" + LedgerTransactionNo + "' and Test_ID in (" + Test_ID + ") ";
        bool CancelToken = StockReports.ExecuteDML(token.ToString());
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  DATE_FORMAT( PLI.Date, '%Y-%m-%d')Date,otm.Name ObservationName,otm.ObservationType_Id, im.Investigation_Id, PM.PatientID,CONCAT(PM.Title,' ',Pm.PName)PName,pm.age Age,pm.gender, ");
        sb.Append("CONCAT(pm.House_No,pm.Street_Name,pm.City)Address,pli.TransactionID,PLI.LedgerTransactionNo LedgerTransactionNo1, ");
        sb.Append("pli.Test_ID,IF(lom.Suffix<>'',CONCAT(REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2),'-',lom.Suffix), ");
        sb.Append(" REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2))LedgerTransactionNo, ");
        sb.Append(" im.Name ,im.sampletypename AS SampleType,im.IsOutSource AS IsOutSource,pli.OutSourceID,pli.IsOutSource OutSourceDone, ");
        sb.Append("IF(PLI.Result_Flag = 0,'false','true')IsResult,CONCAT(DATE_FORMAT(pli.date,'%d-%b-%Y'),' ',TIME_FORMAT(pli.Time,'%l:%i %p'))DATETIME, ");
        sb.Append("PLI.ID,pli.SampleReceiveDate,'OPD' AS EntryType,IFNULL(pli.LedgerTnxID,'')LedgerTnxID,pli.isTransferReceive,IFNULL(sampleTransferCentreID,0)sampleTransferCentreID, IFNULL(( ");
        sb.Append("    SELECT IsRefund FROM f_ledgertnxdetail WHERE LedgerTransactionNo = pli.LedgerTransactionNo AND IsRefund=0 AND ItemID IN ( ");
        sb.Append("           SELECT ItemID FROM f_itemmaster WHERE Type_ID=pli.Investigation_ID AND Isactive=1 ");
        sb.Append("    ) LIMIT 1 ");
        sb.Append("),0) IsRefund,pli.IsUrgent,'' TransactionID,''room,IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(ISNULL(PLI.tokenNo),'',PLI.tokenNo)tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
        // sb.Append(" , (SELECT IF((NetAmount=Adjustment),TRUE,FALSE) FROM f_ledgertransaction ltp WHERE PaymentmodeID<>4 AND ltp.TransactionID=lt.TransactionID limit 1)PendingAmount  ");
        sb.Append("FROM patient_labinvestigation_opd pli INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pli.`TransactionID`=pmh.`TransactionID` INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID and pli.Result_Flag=0 INNER JOIN investigation_master im ");
        sb.Append("ON pli.Investigation_ID = im.Investigation_Id ");
        sb.Append(" INNER JOIN doctor_master dm  ON dm.DoctorID = PLI.DoctorID");
        sb.Append(" INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id ");
        sb.Append(" LEFT JOIN labobservation_investigation loi ON loi.Investigation_Id=pli.Investigation_ID ");
        sb.Append(" LEFT JOIN labobservation_master lom ON lom.LabObservation_ID=loi.labObservation_ID ");
        sb.Append(" where im.Type='R' ");
        sb.Append(" AND IsSampleCollected='N' ");
        sb.Append(" AND pli.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        if (FrmDate != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND lt.IsCancel=0");
        sb.Append(" AND PLI.LedgerTransactionNo='" + LedgerTransactionNo + "' and PLI.Test_ID in (" + Test_ID + ") ");
        sb.Append(" GROUP BY PLI.ID,IFNULL(lom.Suffix,'')  order by PLI.ID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        sb.Clear();
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                sb.Clear();
                sb.Append("insert into cancel_OPD_Laboratory_token(ObservationName,ObservationType_Id,Investigation_Id,PatientID,pname,age,gender,Address,TransactionID,Test_ID,LedgerTransactionNo1,NAME,SampleType, ");
                sb.Append("IsOutSource,OutSourceID,OutSourceDone,IsResult,DATETIME,ID,SampleReceiveDate,EntryType,LedgerTnxID,isTransferReceive,sampleTransferCentreID,IsRefund,IsUrgent,TransactionID,room,tokenNoExit,tokenNo,IsCancelToken,UpdateToken,DATE,LedgerTransactionNo ) ");
                sb.Append(" values('" + dt.Rows[i]["ObservationName"] + "','" + dt.Rows[i]["ObservationType_Id"] + "','" + dt.Rows[i]["Investigation_Id"] + "','" + dt.Rows[i]["PatientID"] + "','" + dt.Rows[i]["pname"] + "',");
                sb.Append(" '" + dt.Rows[i]["age"] + "','" + dt.Rows[i]["gender"] + "','" + dt.Rows[i]["Address"] + "','" + dt.Rows[i]["TransactionID"] + "','" + dt.Rows[i]["Test_ID"] + "',");
                sb.Append(" '" + dt.Rows[i]["LedgerTransactionNo1"] + "','" + dt.Rows[i]["NAME"] + "','" + dt.Rows[i]["SampleType"] + "','" + dt.Rows[i]["IsOutSource"] + "','" + dt.Rows[i]["OutSourceID"] + "', ");
                sb.Append(" '" + dt.Rows[i]["OutSourceDone"] + "','" + dt.Rows[i]["IsResult"] + "','" + dt.Rows[i]["DATETIME"] + "','" + dt.Rows[i]["ID"] + "','" + dt.Rows[i]["SampleReceiveDate"] + "', ");
                sb.Append(" '" + dt.Rows[i]["EntryType"] + "','" + dt.Rows[i]["LedgerTnxID"] + "','" + dt.Rows[i]["isTransferReceive"] + "','" + dt.Rows[i]["sampleTransferCentreID"] + "','" + dt.Rows[i]["IsRefund"] + "', ");
                sb.Append(" '" + dt.Rows[i]["IsUrgent"] + "','" + dt.Rows[i]["TransactionID"] + "','" + dt.Rows[i]["room"] + "', ");
                sb.Append(" '" + dt.Rows[i]["tokenNoExit"] + "','" + dt.Rows[i]["tokenNo"] + "', ");
                sb.Append(" 2," + dt.Rows[i]["UpdateToken"] + ",'" + dt.Rows[i]["DATE"] + "','" + dt.Rows[i]["LedgerTransactionNo"] + "' ) ");
                bool UpdateToken = StockReports.ExecuteDML(sb.ToString());
            }
            return "1";
        }
        else
        {
            return "0";
        }
    }

    #region Search
    public static DataTable Search()
    {
        string FrmDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string ToDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        StringBuilder sb = new StringBuilder();
        string TypeofTnx = string.Empty;
        //string RoleDept = HttpContext.Current.Session["RoleDept"].ToString();
        sb.Append("    SELECT * FROM ( ");
        sb.Append("  SELECT t.* FROM ( SELECT pli.LabInvestigationOPD_ID, otm.Name ObservationName,otm.ObservationType_Id, im.Investigation_Id, PM.PatientID,CONCAT(PM.Title,' ',Pm.PName)PName,pm.age Age,pm.gender, ");
        sb.Append("CONCAT(pm.House_No,pm.Street_Name,pm.City)Address,pli.TransactionID,PLI.LedgerTransactionNo LedgerTransactionNo1, ");
        sb.Append("pli.Test_ID,IF(lom.Suffix<>'',CONCAT(REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2),'-',lom.Suffix), ");
        sb.Append(" REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2))LedgerTransactionNo, ");
        sb.Append(" im.Name ,im.sampletypename AS SampleType,im.IsOutSource AS IsOutSource,pli.OutSourceID,pli.IsOutSource OutSourceDone, ");
        sb.Append("IF(PLI.Result_Flag = 0,'false','true')IsResult,CONCAT(DATE_FORMAT(pli.date,'%d-%b-%Y'),' ',TIME_FORMAT(pli.Time,'%l:%i %p'))DATETIME, ");
        sb.Append("PLI.ID,pli.SampleReceiveDate,'OPD' AS EntryType,IFNULL(pli.LedgerTnxID,'')LedgerTnxID,pli.isTransferReceive,IFNULL(sampleTransferCentreID,0)sampleTransferCentreID, IFNULL(( ");
        sb.Append("    SELECT IsRefund FROM f_ledgertnxdetail WHERE LedgerTransactionNo = pli.LedgerTransactionNo AND IsRefund=0 AND ItemID IN ( ");
        sb.Append("           SELECT ItemID FROM f_itemmaster WHERE Type_ID=pli.Investigation_ID AND Isactive=1 ");
        sb.Append("    ) LIMIT 1 ");
        sb.Append("),0) IsRefund,pli.IsUrgent,'' TransactionID,''room,IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(PLI.IsCancelToken=3,'',(IF(ISNULL(PLI.tokenNo),'',PLI.tokenNo)))tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
        // sb.Append(" , (SELECT IF((NetAmount=Adjustment),TRUE,FALSE) FROM f_ledgertransaction ltp WHERE PaymentmodeID<>4 AND ltp.TransactionID=lt.TransactionID limit 1)PendingAmount  ");
        sb.Append("FROM patient_labinvestigation_opd pli INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pli.`TransactionID`=pmh.`TransactionID` INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID and pli.Result_Flag=0 INNER JOIN investigation_master im ");
        sb.Append("ON pli.Investigation_ID = im.Investigation_Id AND IM.ReportType IN(1,3)   ");
        sb.Append(" INNER JOIN doctor_master dm  ON dm.DoctorID = PLI.DoctorID");
        sb.Append(" INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id ");
        sb.Append(" LEFT JOIN labobservation_investigation loi ON loi.Investigation_Id=pli.Investigation_ID ");
        sb.Append(" LEFT JOIN labobservation_master lom ON lom.LabObservation_ID=loi.labObservation_ID ");
        sb.Append(" where im.Type='R' ");
        sb.Append(" AND IsSampleCollected='N' AND pli.IsCancelToken<>3  ");
        sb.Append(" AND pli.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        if (FrmDate != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND lt.IsCancel=0");
        sb.Append(" GROUP BY PLI.ID,IFNULL(lom.Suffix,'')   ");

        sb.Append(" UNION ALL ");
        sb.Append(" SELECT '' LabInvestigationOPD_ID, ObservationName,ObservationType_Id,Investigation_Id,PatientID,pname,age,gender,Address,TransactionID,LedgerTransactionNo1,Test_ID,LedgerTransactionNo,NAME,SampleType,");
        sb.Append(" IsOutSource,OutSourceID,OutSourceDone,IsResult,DATETIME,ID,SampleReceiveDate,EntryType,LedgerTnxID,isTransferReceive,sampleTransferCentreID,IsRefund,");
        sb.Append(" IsUrgent,TransactionID,room,tokenNoExit,tokenNo,IsCancelToken,UpdateToken ");
        sb.Append(" FROM cancel_OPD_Laboratory_token where date=CURDATE() )t ORDER BY t.tokenNo,t.pname )t3 GROUP BY t3.LedgerTransactionNo ");

        sb.Append(" union all ");

        sb.Append("  SELECT pli.LabInvestigationOPD_ID, otm.Name ObservationName,otm.ObservationType_Id, im.Investigation_Id, PM.PatientID,CONCAT(PM.Title,' ',Pm.PName)PName,pm.age Age,pm.gender, ");
        sb.Append("CONCAT(pm.House_No,pm.Street_Name,pm.City)Address,pli.TransactionID,PLI.LedgerTransactionNo LedgerTransactionNo1, ");
        sb.Append("pli.Test_ID,IF(lom.Suffix<>'',CONCAT(REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2),'-',lom.Suffix), ");
        sb.Append(" REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2))LedgerTransactionNo, ");
        sb.Append(" im.Name ,im.sampletypename AS SampleType,im.IsOutSource AS IsOutSource,pli.OutSourceID,pli.IsOutSource OutSourceDone, ");
        sb.Append("IF(PLI.Result_Flag = 0,'false','true')IsResult,CONCAT(DATE_FORMAT(pli.date,'%d-%b-%Y'),' ',TIME_FORMAT(pli.Time,'%l:%i %p'))DATETIME, ");
        sb.Append("PLI.ID,pli.SampleReceiveDate,'OPD' AS EntryType,IFNULL(pli.LedgerTnxID,'')LedgerTnxID,pli.isTransferReceive,IFNULL(sampleTransferCentreID,0)sampleTransferCentreID, IFNULL(( ");
        sb.Append("    SELECT IsRefund FROM f_ledgertnxdetail WHERE LedgerTransactionNo = pli.LedgerTransactionNo AND IsRefund=0 AND ItemID IN ( ");
        sb.Append("           SELECT ItemID FROM f_itemmaster WHERE Type_ID=pli.Investigation_ID AND Isactive=1 ");
        sb.Append("    ) LIMIT 1 ");
        sb.Append("),0) IsRefund,pli.IsUrgent,'' TransactionID,''room,IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(PLI.IsCancelToken=3,'',(IF(ISNULL(PLI.tokenNo),'',PLI.tokenNo)))tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
        // sb.Append(" , (SELECT IF((NetAmount=Adjustment),TRUE,FALSE) FROM f_ledgertransaction ltp WHERE PaymentmodeID<>4 AND ltp.TransactionID=lt.TransactionID limit 1)PendingAmount  ");
        sb.Append("FROM patient_labinvestigation_opd pli INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pli.`TransactionID`=pmh.`TransactionID` INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID and pli.Result_Flag=0 INNER JOIN investigation_master im ");
        sb.Append("ON pli.Investigation_ID = im.Investigation_Id AND IM.ReportType IN(1,3)   ");
        sb.Append(" INNER JOIN doctor_master dm  ON dm.DoctorID = PLI.DoctorID");
        sb.Append(" INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id ");
        sb.Append(" LEFT JOIN labobservation_investigation loi ON loi.Investigation_Id=pli.Investigation_ID ");
        sb.Append(" LEFT JOIN labobservation_master lom ON lom.LabObservation_ID=loi.labObservation_ID ");
        sb.Append(" where im.Type='R' ");
        sb.Append(" AND IsSampleCollected='N' AND pli.IsCancelToken=3  ");
        sb.Append(" AND pli.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        if (FrmDate != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND lt.IsCancel=0");
        sb.Append(" GROUP BY PLI.LedgerTransactionNo,IFNULL(lom.Suffix,'')   ");

        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());

        return dtInvest;
    }

    [WebMethod]
    public static string SearchTokenNumber(string LabNo, string PatientName, string DepartmentId, string InvestigationId, string Token)
    {
        string FrmDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string ToDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        StringBuilder sb = new StringBuilder();
        string TypeofTnx = string.Empty;
        //string RoleDept = HttpContext.Current.Session["RoleDept"].ToString();
        sb.Append("  SELECT t.* FROM ( SELECT PLI.date,otm.Name ObservationName,otm.ObservationType_Id, im.Investigation_Id, PM.PatientID,CONCAT(PM.Title,' ',Pm.PName)PName,pm.age Age,pm.gender, ");
        sb.Append("CONCAT(pm.House_No,pm.Street_Name,pm.City)Address,pli.TransactionID,PLI.LedgerTransactionNo LedgerTransactionNo1, ");
        sb.Append("pli.Test_ID,IF(lom.Suffix<>'',CONCAT(REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2),'-',lom.Suffix), ");
        sb.Append(" REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2))LedgerTransactionNo, ");
        sb.Append(" im.Name ,im.sampletypename AS SampleType,im.IsOutSource AS IsOutSource,pli.OutSourceID,pli.IsOutSource OutSourceDone, ");
        sb.Append("IF(PLI.Result_Flag = 0,'false','true')IsResult,CONCAT(DATE_FORMAT(pli.date,'%d-%b-%Y'),' ',TIME_FORMAT(pli.Time,'%l:%i %p'))DATETIME, ");
        sb.Append("PLI.ID,pli.SampleReceiveDate,'OPD' AS EntryType,IFNULL(pli.LedgerTnxID,'')LedgerTnxID,pli.isTransferReceive,IFNULL(sampleTransferCentreID,0)sampleTransferCentreID, IFNULL(( ");
        sb.Append("    SELECT IsRefund FROM f_ledgertnxdetail WHERE LedgerTransactionNo = pli.LedgerTransactionNo AND IsRefund=0 AND ItemID IN ( ");
        sb.Append("           SELECT ItemID FROM f_itemmaster WHERE Type_ID=pli.Investigation_ID AND Isactive=1 ");
        sb.Append("    ) LIMIT 1 ");
        sb.Append("),0) IsRefund,pli.IsUrgent,'' TransactionID,''room,IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(PLI.IsCancelToken=3,'',(IF(ISNULL(PLI.tokenNo),'',PLI.tokenNo)))tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
        // sb.Append(" , (SELECT IF((NetAmount=Adjustment),TRUE,FALSE) FROM f_ledgertransaction ltp WHERE PaymentmodeID<>4 AND ltp.TransactionID=lt.TransactionID limit 1)PendingAmount  ");
        sb.Append("FROM patient_labinvestigation_opd pli INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pli.`TransactionID`=pmh.`TransactionID` INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID and pli.Result_Flag=0 INNER JOIN investigation_master im ");
        sb.Append("ON pli.Investigation_ID = im.Investigation_Id ");
        sb.Append(" INNER JOIN doctor_master dm  ON dm.DoctorID = PLI.DoctorID");
        sb.Append(" INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id ");
        sb.Append(" LEFT JOIN labobservation_investigation loi ON loi.Investigation_Id=pli.Investigation_ID ");
        sb.Append(" LEFT JOIN labobservation_master lom ON lom.LabObservation_ID=loi.labObservation_ID ");
        sb.Append(" where im.Type='R' ");
        sb.Append(" AND IsSampleCollected='N' ");
       // sb.Append(" AND pli.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        if (FrmDate != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND lt.IsCancel=0");
        sb.Append(" GROUP BY PLI.ID,IFNULL(lom.Suffix,'')   ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT  date, ObservationName,ObservationType_Id,Investigation_Id,PatientID,pname,age,gender,Address,TransactionID,LedgerTransactionNo1,Test_ID,LedgerTransactionNo,NAME,SampleType,");
        sb.Append(" IsOutSource,OutSourceID,OutSourceDone,IsResult,DATETIME,ID,SampleReceiveDate,EntryType,LedgerTnxID,isTransferReceive,sampleTransferCentreID,IsRefund,");
        sb.Append(" IsUrgent,TransactionID,room,tokenNoExit,tokenNo,IsCancelToken,UpdateToken ");
        sb.Append(" FROM cancel_OPD_Laboratory_token )t  ");
        sb.Append(" where t.date>='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (LabNo != null && LabNo != "")
            sb.Append(" and  t.LedgerTransactionNo='" + LabNo + "'");
        if (DepartmentId != null && DepartmentId != "0")
            sb.Append(" and t.ObservationType_Id='" + DepartmentId + "' ");
        if (InvestigationId != null && InvestigationId != "")
            sb.Append(" and t.Investigation_Id='" + InvestigationId + "'");
        if (PatientName != null && PatientName != "")
            sb.Append("and t.pname like('%" + PatientName + "%')");
        if (Token != null && Token != "")
            sb.Append("and t.tokenNo='"+Token+"' ");
        sb.Append("ORDER BY t.ID ");
        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());
        if (dtInvest.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtInvest);
        else
            return "";
    }
    #endregion
}