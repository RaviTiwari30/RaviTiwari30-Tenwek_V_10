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

public partial class Design_Token_CreateRadiologyToken : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblAppointmentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
        }
    }


    [WebMethod]
    public static string BindDepartment()
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
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
    public static string createToken(string LedgerTransactionNo, string Type, string ObservationID, string Investigation_Id, string LabInvestID, string PatientID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            if (Type == "OPD")
            {
                //string DocDepartmentID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "Select docm.DocDepartmentID FROM patient_labinvestigation_ipd PLI INNER JOIN doctor_master docm ON PLI.DoctorID=docm.DoctorID WHERE  PLI.LabInvestigationIPD_ID='" + LabInvestID + "' "));
                string tokenNo = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "select create_Radiology_tokenNo('" + ObservationID + "') "));
                string token = "UPDATE patient_labinvestigation_opd  set IsCancelToken=0, TokenNo='" + tokenNo + "',TokenCreateBy='" + HttpContext.Current.Session["ID"].ToString() + "',TockenCreatedDate=CURDATE(),TokenCreatedTime=CURTIME() where LabInvestigationOPD_ID='" + LabInvestID + "' ";
                string InsertToken = Util.GetString(MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Insert Into Radiolody_CreateToken_Number(TYPE,TestId,TokenNo,LedgerTranscationNO,TockenCreatedDate,ObservationType_Id,Investigation_Id,PatientID,TokenCreateTime) values('" + Type + "','" + LabInvestID + "','" + tokenNo + "','" + LedgerTransactionNo + "',CURDATE(),'" + ObservationID + "','" + Investigation_Id + "','" + PatientID + "',CURTIME() ) "));
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, token);
                tranX.Commit();
                return tokenNo;
            }
            else
            {
                //string DocDepartmentID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "Select docm.DocDepartmentID FROM patient_labinvestigation_opd PLO INNER JOIN doctor_master docm ON PLO.DoctorID=docm.DoctorID WHERE  PLO.LabInvestigationOPD_ID='" + LabInvestID + "' "));
                string tokenNo = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "select create_Radiology_tokenNo('" + ObservationID + "') "));
                string token = "UPDATE patient_labinvestigation_ipd set IsCancelToken=0, TokenNo='" + tokenNo + "',TokenCreateBy='" + HttpContext.Current.Session["ID"].ToString() + "',TockenCreatedDate=CURDATE(),TokenCreatedTime=CURTIME() where LabInvestigationIPD_ID='" + LabInvestID + "' ";
                string InsertToken = Util.GetString(MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Insert Into Radiolody_CreateToken_Number(TYPE,TestId,TokenNo,LedgerTranscationNO,TockenCreatedDate,ObservationType_Id,Investigation_Id,PatientID,TokenCreateTime) values('" + Type + "','" + LabInvestID + "','" + tokenNo + "','" + LedgerTransactionNo + "',CURDATE(),'" + ObservationID + "','" + Investigation_Id + "','" + PatientID + "',CURTIME() ) "));
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, token);
                tranX.Commit();
                return tokenNo;
            }
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
    public static string CancelToken(string LabInvestID, string Type)
    {
        string FrmDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string ToDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string ListOf = "";
        if (Type == "IPD")
        {
            string token = "UPDATE patient_labinvestigation_ipd set  IsCancelToken=3,TokenCancelBy='" + HttpContext.Current.Session["ID"].ToString() + "',TokenCancelDateTime=NOW() where LabInvestigationIPD_ID='" + LabInvestID + "' ";
            bool CancelToken = StockReports.ExecuteDML(token.ToString());
            string ScreenToken = "update Radiolody_CreateToken_Number set IsCancelToken=1 where TestId='" + LabInvestID + "' and type='" + Type + "' and IsCancelToken=0 ";
            bool IscancelTokenScreen = StockReports.ExecuteDML(ScreenToken.ToString());
            StringBuilder sb = new StringBuilder();

            sb.Append("select  DATE_FORMAT( PLI.Date, '%Y-%m-%d')Date, PLI.LabInvestigationIPD_ID LabInvestigation_ID,'" + ListOf + " From " + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' as ReportDate,'IPD' Type, im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,Replace(pli.TransactionID,'ISHHI','')TransactionID,pli.Test_ID, ");
            sb.Append(" pli.LedgerTransactionNo,REPLACE(pli.LedgerTransactionNo,'LISHHI','3')LTD,IM.Name,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent,if(PLI.Result_Flag=0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType,");
            sb.Append("(Select CONCAT(Title,' ',NAME)name from doctor_master where DoctorID =pli.DoctorID )DName,pli.ID , (SELECT replace( TransactionID,'ISHHI','')TransactionID FROM f_ipdadjustment WHERE PatientID=pm.`PatientID` ORDER BY TransactionID DESC LIMIT 1)TransactionID,	( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room ");
            sb.Append(" ,'1' PendingAmount,");
            sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay, ");
            sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus,fpm.Company_Name Panel,pli.isPrint, IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(ISNULL(PLI.tokenNo),'',PLI.tokenNo)tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
            sb.Append(" from patient_labinvestigation_ipd PLI INNER JOIN f_ledgertransaction lt ON pli.LedgerTransactionNo=lt.LedgerTransactionNo inner join investigation_master IM on PLI.Investigation_ID=IM.Investigation_Id ");
            sb.Append(" INNER JOIN patient_medical_history pmh on PLI.TransactionID =pmh.TransactionID ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
            sb.Append(" INNER JOIN  patient_master PM on pmh.PatientID=PM.PatientID INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");
            sb.Append(" INNER JOIN f_ledgertnxDetail ltd on ltd.LedgerTransactionNo = lt.LedgertransactionNo ");
            sb.Append(" INNER JOIN f_ItemMaster imas on imas.ItemID = Ltd.ItemID and imas.Type_ID=im.Investigation_ID ");
            sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID ");
            sb.Append(" where  IsSampleCollected='n' and ltd.IsVerified=1  AND cr.RoleID='" + Resources.Resource.RadiologyRoleId + "'");
            if (FrmDate != string.Empty)
                sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
            if (ToDate != string.Empty)
                sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
            sb.Append(" AND PLI.LabInvestigationIPD_ID='" + LabInvestID + "' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            sb.Clear();

            sb.Append("insert into Cancel_IPD_Radiology_Token(LabInvestigation_ID,ReportDate,TYPE ,ObservationName ,ObservationType_Id,Investigation_Id ,PatientID ,PID ,pname ,age,gender ,Address,TransactionID ");
            sb.Append(",Test_ID ,LedgerTransactionNo ,LTD ,NAME ,IsOutSource ,OutSourceName,IsUrgent ,IsResult,InDate,Approved,chkWork,TIME,IsSample,SampleDate,Dept,ReportType,DName,ID,TransactionID,room,PendingAmount,IsDelay,MacStatus,Panel,isPrint,tokenNoExit,tokenNo,IsCancelToken,UpdateToken,date ) ");
            sb.Append(" values('" + dt.Rows[0]["LabInvestigation_ID"] + "','" + dt.Rows[0]["ReportDate"] + "','" + dt.Rows[0]["TYPE"] + "','" + dt.Rows[0]["ObservationName"] + "','" + dt.Rows[0]["ObservationType_Id"] + "',");
            sb.Append(" '" + dt.Rows[0]["Investigation_Id"] + "','" + dt.Rows[0]["PatientID"] + "','" + dt.Rows[0]["PID"] + "','" + dt.Rows[0]["pname"] + "','" + dt.Rows[0]["age"] + "',");
            sb.Append(" '" + dt.Rows[0]["gender"] + "','" + dt.Rows[0]["Address"] + "','" + dt.Rows[0]["TransactionID"] + "','" + dt.Rows[0]["Test_ID"] + "','" + dt.Rows[0]["LedgerTransactionNo"] + "', ");
            sb.Append(" '" + dt.Rows[0]["LTD"] + "','" + dt.Rows[0]["NAME"] + "','" + dt.Rows[0]["IsOutSource"] + "','" + dt.Rows[0]["OutSourceName"] + "','" + dt.Rows[0]["IsUrgent"] + "', ");
            sb.Append(" '" + dt.Rows[0]["IsResult"] + "','" + dt.Rows[0]["InDate"] + "','" + dt.Rows[0]["Approved"] + "','" + dt.Rows[0]["chkWork"] + "','" + dt.Rows[0]["TIME"] + "', ");
            sb.Append(" '" + dt.Rows[0]["IsSample"] + "','" + dt.Rows[0]["SampleDate"] + "','" + dt.Rows[0]["Dept"] + "','" + dt.Rows[0]["ReportType"] + "','" + dt.Rows[0]["DName"] + "', ");
            sb.Append(" '" + dt.Rows[0]["ID"] + "','" + dt.Rows[0]["TransactionID"] + "','" + dt.Rows[0]["room"] + "','" + dt.Rows[0]["PendingAmount"] + "','" + dt.Rows[0]["IsDelay"] + "', ");
            sb.Append(" '" + dt.Rows[0]["MacStatus"] + "','" + dt.Rows[0]["Panel"] + "','" + dt.Rows[0]["isPrint"] + "','" + dt.Rows[0]["tokenNoExit"] + "','" + dt.Rows[0]["tokenNo"] + "', ");
            sb.Append(" 2," + dt.Rows[0]["UpdateToken"] + ",'" + dt.Rows[0]["DATE"] + "' ) ");
            bool UpdateToken = StockReports.ExecuteDML(sb.ToString());
            return "1";
        }
        else
        {
            string token = "UPDATE  patient_labinvestigation_opd set  IsCancelToken=3,TokenCancelBy='" + HttpContext.Current.Session["ID"].ToString() + "',TokenCancelDateTime=NOW() where LabInvestigationOPD_ID='" + LabInvestID + "' ";
            bool CancelToken = StockReports.ExecuteDML(token.ToString());
            string ScreenToken = "UPDATE Radiolody_CreateToken_Number set IsCancelToken=1 where TestId='" + LabInvestID + "' and type='" + Type + "' and IsCancelToken=0 ";
            bool IscancelTokenScreen = StockReports.ExecuteDML(ScreenToken.ToString());
            StringBuilder sb = new StringBuilder();
            sb.Append("select DATE_FORMAT(PLI.Date, '%Y-%m-%d')Date, PLI.LabInvestigationOPD_ID LabInvestigation_ID, '" + ListOf + " From " + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' as ReportDate,'OPD' Type,im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.TransactionID,pli.Test_ID,pli.LedgerTransactionNo,REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2)LTD,im.Name,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent");
            sb.Append(" ,if(PLI.Result_Flag = 0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType, ");
            sb.Append("(Select CONCAT(Title,' ',NAME)name from doctor_master where DoctorID =pli.DoctorID )DName,pli.ID , (SELECT replace( TransactionID,'ISHHI','')TransactionID FROM f_ipdadjustment WHERE PatientID=pm.`PatientID` ORDER BY TransactionID DESC LIMIT 1)TransactionID,	( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room ");
            sb.Append(" ,IF(lt.NetAmount=lt.Adjustment,TRUE,FALSE)PendingAmount, ");
            sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay, ");
            sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus,fpm.Company_Name Panel,pli.isPrint, IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(ISNULL(PLI.tokenNo),'',PLI.tokenNo)tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
            sb.Append(" from patient_labinvestigation_opd pli inner join f_ledgertransaction lt on lt.LedgerTransactionNo=pli.LedgerTransactionNo");
            sb.Append(" INNER JOIN Patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
            sb.Append(" INNER JOIN patient_master PM on pli.PatientID = PM.PatientID  ");
            sb.Append(" INNER JOIN investigation_master im on pli.Investigation_ID = im.Investigation_Id INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID	INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id INNER JOIN f_ledgertnxDetail ltd ON ltd.LedgerTransactionNo = lt.LedgertransactionNo INNER JOIN f_ItemMaster imas ON imas.ItemID = Ltd.ItemID AND imas.Type_ID=im.Investigation_ID");
            sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID  ");
            sb.Append(" where (lt.TypeOfTnx='opd-lab' or lt.TypeOfTnx='opd-package' or lt.TypeOfTnx='OPD-BILLING') and lt.IsCancel=0 and IsSampleCollected='N' AND cr.RoleID='" + Resources.Resource.RadiologyRoleId + "' ");
            if (FrmDate != string.Empty)
                sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
            if (ToDate != string.Empty)
                sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
            sb.Append(" and   PLI.LabInvestigationOPD_ID='" + LabInvestID + "'   ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            sb.Clear();

            sb.Append("insert into Cancel_OPD_Radiology_Token(LabInvestigation_ID,ReportDate,TYPE ,ObservationName ,ObservationType_Id,Investigation_Id ,PatientID ,PID ,pname ,age,gender ,Address,TransactionID ");
            sb.Append(",Test_ID ,LedgerTransactionNo ,LTD ,NAME ,IsOutSource ,OutSourceName,IsUrgent ,IsResult,InDate,Approved,chkWork,TIME,IsSample,SampleDate,Dept,ReportType,DName,ID,TransactionID,room,PendingAmount,IsDelay,MacStatus,Panel,isPrint,tokenNoExit,tokenNo,IsCancelToken,UpdateToken,date ) ");
            sb.Append(" values('" + dt.Rows[0]["LabInvestigation_ID"] + "','" + dt.Rows[0]["ReportDate"] + "','" + dt.Rows[0]["TYPE"] + "','" + dt.Rows[0]["ObservationName"] + "','" + dt.Rows[0]["ObservationType_Id"] + "',");
            sb.Append(" '" + dt.Rows[0]["Investigation_Id"] + "','" + dt.Rows[0]["PatientID"] + "','" + dt.Rows[0]["PID"] + "','" + dt.Rows[0]["pname"] + "','" + dt.Rows[0]["age"] + "',");
            sb.Append(" '" + dt.Rows[0]["gender"] + "','" + dt.Rows[0]["Address"] + "','" + dt.Rows[0]["TransactionID"] + "','" + dt.Rows[0]["Test_ID"] + "','" + dt.Rows[0]["LedgerTransactionNo"] + "', ");
            sb.Append(" '" + dt.Rows[0]["LTD"] + "','" + dt.Rows[0]["NAME"] + "','" + dt.Rows[0]["IsOutSource"] + "','" + dt.Rows[0]["OutSourceName"] + "','" + dt.Rows[0]["IsUrgent"] + "', ");
            sb.Append(" '" + dt.Rows[0]["IsResult"] + "','" + dt.Rows[0]["InDate"] + "','" + dt.Rows[0]["Approved"] + "','" + dt.Rows[0]["chkWork"] + "','" + dt.Rows[0]["TIME"] + "', ");
            sb.Append(" '" + dt.Rows[0]["IsSample"] + "','" + dt.Rows[0]["SampleDate"] + "','" + dt.Rows[0]["Dept"] + "','" + dt.Rows[0]["ReportType"] + "','" + dt.Rows[0]["DName"] + "', ");
            sb.Append(" '" + dt.Rows[0]["ID"] + "','" + dt.Rows[0]["TransactionID"] + "','" + dt.Rows[0]["room"] + "','" + dt.Rows[0]["PendingAmount"] + "','" + dt.Rows[0]["IsDelay"] + "', ");
            sb.Append(" '" + dt.Rows[0]["MacStatus"] + "','" + dt.Rows[0]["Panel"] + "','" + dt.Rows[0]["isPrint"] + "','" + dt.Rows[0]["tokenNoExit"] + "','" + dt.Rows[0]["tokenNo"] + "', ");
            sb.Append(" 2," + dt.Rows[0]["UpdateToken"] + ",'" + dt.Rows[0]["DATE"] + "' ) ");
            bool UpdateToken = StockReports.ExecuteDML(sb.ToString());
            return "1";
        }
    }

    #region Search
    public static DataTable Search()
    {
        string FrmDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string ToDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string ListOf = "";
        StringBuilder sb = new StringBuilder();
        string TypeofTnx = string.Empty;
        sb.Append(" SELECT * FROM (  Select t.* from (");
        sb.Append("select PLI.LabInvestigationOPD_ID LabInvestigation_ID, '" + ListOf + " From " + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' as ReportDate,'OPD' Type,im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.TransactionID,pli.Test_ID,pli.LedgerTransactionNo,REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2)LTD,im.Name,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent");
        sb.Append(" ,if(PLI.Result_Flag = 0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType, ");
        sb.Append("(Select CONCAT(Title,' ',NAME)name from doctor_master where DoctorID =pli.DoctorID )DName,pli.ID , (SELECT replace( TransactionID,'ISHHI','')TransactionID FROM f_ipdadjustment WHERE PatientID=pm.`PatientID` ORDER BY TransactionID DESC LIMIT 1)TransactionID,	( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room ");
        sb.Append(" ,IF(lt.NetAmount=lt.Adjustment,TRUE,FALSE)PendingAmount, ");
        sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay, ");
        sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus,fpm.Company_Name Panel,pli.isPrint, IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(PLI.IsCancelToken=3,'',PLI.tokenNo)tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
        sb.Append(" from patient_labinvestigation_opd pli inner join f_ledgertransaction lt on lt.LedgerTransactionNo=pli.LedgerTransactionNo");
        sb.Append(" INNER JOIN Patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append(" INNER JOIN patient_master PM on pli.PatientID = PM.PatientID  ");
        sb.Append(" INNER JOIN investigation_master im on pli.Investigation_ID = im.Investigation_Id INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID	INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id INNER JOIN f_ledgertnxDetail ltd ON ltd.LedgerTransactionNo = lt.LedgertransactionNo INNER JOIN f_ItemMaster imas ON imas.ItemID = Ltd.ItemID AND imas.Type_ID=im.Investigation_ID");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID  ");
        sb.Append(" where (lt.TypeOfTnx='opd-lab' or lt.TypeOfTnx='opd-package' or lt.TypeOfTnx='OPD-BILLING') and lt.IsCancel=0  and IsSampleCollected='N' AND cr.RoleID='" + Resources.Resource.RadiologyRoleId + "' ");
        if (FrmDate != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND PLI.IsCancelToken<>3 ");

        sb.Append(" Union ALL ");

        sb.Append("select   PLI.LabInvestigationIPD_ID LabInvestigation_ID,'" + ListOf + " From " + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' as ReportDate,'IPD' Type, im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,Replace(pli.TransactionID,'ISHHI','')TransactionID,pli.Test_ID, ");
        sb.Append(" pli.LedgerTransactionNo,REPLACE(pli.LedgerTransactionNo,'LISHHI','3')LTD,IM.Name,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent,if(PLI.Result_Flag=0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType,");
        sb.Append("(Select CONCAT(Title,' ',NAME)name from doctor_master where DoctorID =pli.DoctorID )DName,pli.ID , (SELECT replace( TransactionID,'ISHHI','')TransactionID FROM f_ipdadjustment WHERE PatientID=pm.`PatientID` ORDER BY TransactionID DESC LIMIT 1)TransactionID,	( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room ");
        sb.Append(" ,'1' PendingAmount,");
        sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay, ");
        sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus,fpm.Company_Name Panel,pli.isPrint, IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(PLI.IsCancelToken=3,'',PLI.tokenNo)tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
        sb.Append(" from patient_labinvestigation_ipd PLI INNER JOIN f_ledgertransaction lt ON pli.LedgerTransactionNo=lt.LedgerTransactionNo inner join investigation_master IM on PLI.Investigation_ID=IM.Investigation_Id ");
        sb.Append(" INNER JOIN patient_medical_history pmh on PLI.TransactionID =pmh.TransactionID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append(" INNER JOIN  patient_master PM on pmh.PatientID=PM.PatientID INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");
        sb.Append(" INNER JOIN f_ledgertnxDetail ltd on ltd.LedgerTransactionNo = lt.LedgertransactionNo ");
        sb.Append(" INNER JOIN f_ItemMaster imas on imas.ItemID = Ltd.ItemID and imas.Type_ID=im.Investigation_ID ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID ");
        sb.Append(" where  IsSampleCollected='n'  and ltd.IsVerified=1  AND cr.RoleID='" + Resources.Resource.RadiologyRoleId + "'");
        if (FrmDate != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  AND PLI.IsCancelToken<>3 ");

        sb.Append(" Union ALL ");

        sb.Append(" SELECT LabInvestigation_ID,ReportDate,TYPE,ObservationName,ObservationType_Id ,Investigation_Id ,");
        sb.Append(" PatientID,PID,pname,age ,gender , Address  ,TransactionID ,Test_ID ,LedgerTransactionNo ,");
        sb.Append(" LTD,NAME ,IsOutSource , OutSourceName,  IsUrgent,IsResult,  InDate,Approved,  chkWork,TIME,   ");
        sb.Append("   IsSample,SampleDate ,Dept ,ReportType , DName ,ID,  TransactionID,room, PendingAmount,  IsDelay , MacStatus,Panel,isPrint, ");
        sb.Append("  tokenNoExit,  tokenNo ,IsCancelToken,UpdateToken   FROM Cancel_IPD_Radiology_Token     ");
        if (FrmDate != string.Empty)
            sb.Append(" where Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");

        sb.Append(" Union ALL ");

        sb.Append(" SELECT LabInvestigation_ID,ReportDate,TYPE,ObservationName,ObservationType_Id ,Investigation_Id ,");
        sb.Append(" PatientID,PID,pname,age ,gender , Address  ,TransactionID ,Test_ID ,LedgerTransactionNo ,");
        sb.Append(" LTD,NAME ,IsOutSource , OutSourceName,  IsUrgent,IsResult,  InDate,Approved,  chkWork,TIME,   ");
        sb.Append("   IsSample,SampleDate ,Dept ,ReportType , DName ,ID,  TransactionID,room, PendingAmount,  IsDelay , MacStatus,Panel,isPrint, ");
        sb.Append("  tokenNoExit,  tokenNo ,IsCancelToken,UpdateToken   FROM Cancel_OPD_Radiology_Token     ");

        if (FrmDate != string.Empty)
            sb.Append(" where Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");

        sb.Append(" )t  order by t.tokenNo   )T3 ");

        sb.Append(" union all ");

        sb.Append(" select PLI.LabInvestigationOPD_ID LabInvestigation_ID, '" + ListOf + " From " + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' as ReportDate,'OPD' Type,im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.TransactionID,pli.Test_ID,pli.LedgerTransactionNo,REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2)LTD,im.Name,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent");
        sb.Append(" ,if(PLI.Result_Flag = 0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType, ");
        sb.Append("(Select CONCAT(Title,' ',NAME)name from doctor_master where DoctorID =pli.DoctorID )DName,pli.ID , (SELECT replace( TransactionID,'ISHHI','')TransactionID FROM f_ipdadjustment WHERE PatientID=pm.`PatientID` ORDER BY TransactionID DESC LIMIT 1)TransactionID,	( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room ");

        sb.Append(" ,IF(lt.NetAmount=lt.Adjustment,TRUE,FALSE)PendingAmount, ");
        sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay, ");
        sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus,fpm.Company_Name Panel,pli.isPrint, IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(PLI.IsCancelToken=3,'',PLI.tokenNo)tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
        sb.Append(" from patient_labinvestigation_opd pli inner join f_ledgertransaction lt on lt.LedgerTransactionNo=pli.LedgerTransactionNo");
        sb.Append(" INNER JOIN Patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append(" INNER JOIN patient_master PM on pli.PatientID = PM.PatientID  ");
        sb.Append(" INNER JOIN investigation_master im on pli.Investigation_ID = im.Investigation_Id INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID	INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id INNER JOIN f_ledgertnxDetail ltd ON ltd.LedgerTransactionNo = lt.LedgertransactionNo INNER JOIN f_ItemMaster imas ON imas.ItemID = Ltd.ItemID AND imas.Type_ID=im.Investigation_ID");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID  ");
        sb.Append(" where (lt.TypeOfTnx='opd-lab' or lt.TypeOfTnx='opd-package' or lt.TypeOfTnx='OPD-BILLING') and lt.IsCancel=0 and IsSampleCollected='N' AND cr.RoleID='" + Resources.Resource.RadiologyRoleId + "' ");
        if (FrmDate != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  AND PLI.IsCancelToken=3 ");

        sb.Append(" Union ALL ");

        sb.Append(" select   PLI.LabInvestigationIPD_ID LabInvestigation_ID,'" + ListOf + " From " + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' as ReportDate,'IPD' Type, im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,Replace(pli.TransactionID,'ISHHI','')TransactionID,pli.Test_ID, ");
        sb.Append(" pli.LedgerTransactionNo,REPLACE(pli.LedgerTransactionNo,'LISHHI','3')LTD,IM.Name,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent,if(PLI.Result_Flag=0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType,");
        sb.Append("(Select CONCAT(Title,' ',NAME)name from doctor_master where DoctorID =pli.DoctorID )DName,pli.ID , (SELECT replace( TransactionID,'ISHHI','')TransactionID FROM f_ipdadjustment WHERE PatientID=pm.`PatientID` ORDER BY TransactionID DESC LIMIT 1)TransactionID,	( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room ");
        sb.Append(" ,'1' PendingAmount,");
        sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay, ");
        sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus,fpm.Company_Name Panel,pli.isPrint, IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(PLI.IsCancelToken=3,'',PLI.tokenNo)tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
        sb.Append(" from patient_labinvestigation_ipd PLI INNER JOIN f_ledgertransaction lt ON pli.LedgerTransactionNo=lt.LedgerTransactionNo inner join investigation_master IM on PLI.Investigation_ID=IM.Investigation_Id ");
        sb.Append(" INNER JOIN patient_medical_history pmh on PLI.TransactionID =pmh.TransactionID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append(" INNER JOIN  patient_master PM on pmh.PatientID=PM.PatientID INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");
        sb.Append(" INNER JOIN f_ledgertnxDetail ltd on ltd.LedgerTransactionNo = lt.LedgertransactionNo ");
        sb.Append(" INNER JOIN f_ItemMaster imas on imas.ItemID = Ltd.ItemID and imas.Type_ID=im.Investigation_ID ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID ");
        sb.Append(" where  IsSampleCollected='n'  and ltd.IsVerified=1  AND cr.RoleID='" + Resources.Resource.RadiologyRoleId + "'");
        if (FrmDate != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' and  PLI.IsCancelToken=3 ");

        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());
        return dtInvest;
    }

    [WebMethod]
    public static string SearchTokenNumber(string Type, string PatientName, string DepartmentId, string labNo, string DoctorName, string TokenNo)
    {
        string FrmDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string ToDate = System.DateTime.Now.ToString("dd-MMM-yyyy");
        string ListOf = "";
        StringBuilder sb = new StringBuilder();
        string TypeofTnx = string.Empty;
        sb.Append(" Select t.* from (");

        sb.Append("select pli.Date,PLI.LabInvestigationOPD_ID LabInvestigation_ID, '" + ListOf + " From " + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' as ReportDate,'OPD' Type,im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.TransactionID,pli.Test_ID,pli.LedgerTransactionNo,REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2)LTD,im.Name,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent");
        sb.Append(" ,if(PLI.Result_Flag = 0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType, ");
        sb.Append("(Select CONCAT(Title,' ',NAME)name from doctor_master where DoctorID =pli.DoctorID )DName,pli.ID , (SELECT replace( TransactionID,'ISHHI','')TransactionID FROM f_ipdadjustment WHERE PatientID=pm.`PatientID` ORDER BY TransactionID DESC LIMIT 1)TransactionID,	( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room ");

        sb.Append(" ,IF(lt.NetAmount=lt.Adjustment,TRUE,FALSE)PendingAmount, ");
        sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay, ");
        sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus,fpm.Company_Name Panel,pli.isPrint, IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(PLI.IsCancelToken=3,'',PLI.tokenNo)tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
        sb.Append(" from patient_labinvestigation_opd pli inner join f_ledgertransaction lt on lt.LedgerTransactionNo=pli.LedgerTransactionNo");
        sb.Append(" INNER JOIN Patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append(" INNER JOIN patient_master PM on pli.PatientID = PM.PatientID  ");
        sb.Append(" INNER JOIN investigation_master im on pli.Investigation_ID = im.Investigation_Id INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID	INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id INNER JOIN f_ledgertnxDetail ltd ON ltd.LedgerTransactionNo = lt.LedgertransactionNo INNER JOIN f_ItemMaster imas ON imas.ItemID = Ltd.ItemID AND imas.Type_ID=im.Investigation_ID");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID  ");
        sb.Append(" where (lt.TypeOfTnx='opd-lab' or lt.TypeOfTnx='opd-package' or lt.TypeOfTnx='OPD-BILLING') and lt.IsCancel=0 and IsSampleCollected='N' AND cr.RoleID='" + Resources.Resource.RadiologyRoleId + "' ");
        if (FrmDate != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        sb.Append(" Union ALL ");

        sb.Append("select   pli.Date,PLI.LabInvestigationIPD_ID LabInvestigation_ID,'" + ListOf + " From " + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' as ReportDate,'IPD' Type, im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,Replace(pli.TransactionID,'ISHHI','')TransactionID,pli.Test_ID, ");
        sb.Append(" pli.LedgerTransactionNo,REPLACE(pli.LedgerTransactionNo,'LISHHI','3')LTD,IM.Name,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent,if(PLI.Result_Flag=0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType,");
        sb.Append("(Select CONCAT(Title,' ',NAME)name from doctor_master where DoctorID =pli.DoctorID )DName,pli.ID , (SELECT replace( TransactionID,'ISHHI','')TransactionID FROM f_ipdadjustment WHERE PatientID=pm.`PatientID` ORDER BY TransactionID DESC LIMIT 1)TransactionID,	( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room ");
        sb.Append(" ,'1' PendingAmount,");
        sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay, ");
        sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus,fpm.Company_Name Panel,pli.isPrint, IF(ISNULL(PLI.tokenNo),0,1)tokenNoExit,IF(PLI.IsCancelToken=3,'',PLI.tokenNo)tokenNo,PLI.IsCancelToken,PLI.UpdateToken ");
        sb.Append(" from patient_labinvestigation_ipd PLI INNER JOIN f_ledgertransaction lt ON pli.LedgerTransactionNo=lt.LedgerTransactionNo inner join investigation_master IM on PLI.Investigation_ID=IM.Investigation_Id ");
        sb.Append(" INNER JOIN patient_medical_history pmh on PLI.TransactionID =pmh.TransactionID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append(" INNER JOIN  patient_master PM on pmh.PatientID=PM.PatientID INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");
        sb.Append(" INNER JOIN f_ledgertnxDetail ltd on ltd.LedgerTransactionNo = lt.LedgertransactionNo ");
        sb.Append(" INNER JOIN f_ItemMaster imas on imas.ItemID = Ltd.ItemID and imas.Type_ID=im.Investigation_ID ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID ");
        sb.Append(" where  IsSampleCollected='N' and ltd.IsVerified=1  AND cr.RoleID='" + Resources.Resource.RadiologyRoleId + "'");
        if (FrmDate != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        sb.Append(" Union ALL ");

        sb.Append(" SELECT Date,LabInvestigation_ID,ReportDate,TYPE,ObservationName,ObservationType_Id ,Investigation_Id ,");
        sb.Append(" PatientID,PID,pname,age ,gender , Address  ,TransactionID ,Test_ID ,LedgerTransactionNo ,");
        sb.Append(" LTD,NAME ,IsOutSource , OutSourceName,  IsUrgent,IsResult,  InDate,Approved,  chkWork,TIME,   ");
        sb.Append("   IsSample,SampleDate ,Dept ,ReportType , DName ,ID,  TransactionID,room, PendingAmount,  IsDelay , MacStatus,Panel,isPrint, ");
        sb.Append("  tokenNoExit,  tokenNo ,IsCancelToken,UpdateToken   FROM Cancel_IPD_Radiology_Token     ");
        if (FrmDate != string.Empty)
            sb.Append(" where Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        sb.Append(" Union ALL ");

        sb.Append(" SELECT Date,LabInvestigation_ID,ReportDate,TYPE,ObservationName,ObservationType_Id ,Investigation_Id ,");
        sb.Append(" PatientID,PID,pname,age ,gender , Address  ,TransactionID ,Test_ID ,LedgerTransactionNo ,");
        sb.Append(" LTD,NAME ,IsOutSource , OutSourceName,  IsUrgent,IsResult,  InDate,Approved,  chkWork,TIME,   ");
        sb.Append("   IsSample,SampleDate ,Dept ,ReportType , DName ,ID,  TransactionID,room, PendingAmount,  IsDelay , MacStatus,Panel,isPrint, ");
        sb.Append("  tokenNoExit,  tokenNo ,IsCancelToken,UpdateToken   FROM Cancel_OPD_Radiology_Token     ");

        if (FrmDate != string.Empty)
            sb.Append(" where Date >='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        sb.Append(" )t   ");

        if (FrmDate != string.Empty)
            sb.Append(" where t.date>='" + Util.GetDateTime(FrmDate).ToString("yyyy-MM-dd") + "'");

        if (Type != null && Type != "" && Type != "All")
            sb.Append(" and  t.type='" + Type + "'");
        if (DepartmentId != null && DepartmentId != "0")
            sb.Append(" and t.ObservationType_Id='" + DepartmentId + "' ");
        if (labNo != null && labNo != "")
            sb.Append(" and t.LTD='" + labNo + "'");
        if (TokenNo != null && TokenNo != "")
            sb.Append(" and t.TokenNo='" + TokenNo + "'");
        if (PatientName != null && PatientName != "")
            sb.Append("and t.pname like('%" + PatientName + "%')");
        if (DoctorName != null && DoctorName != "")
            sb.Append("and t.DName like('%" + DoctorName + "%')");

        sb.Append(" order by t.tokenNo,t.DName  ");

        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());
        if (dtInvest.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtInvest);
        else
            return "";
    }
    #endregion

}