using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.IO;

public partial class Design_Lab_SampleCollectionLab : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        FrmDate.Attributes.Add("readonly", "readonly");
        ToDate.Attributes.Add("readonly", "readonly");
    }
    [WebMethod]
    public static string bindCenter()
    {
        try
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.dtbind_Centre(HttpContext.Current.Session["ID"].ToString()));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindFloor()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT FloorID AS ID,Role_ID,fm.Name AS NAME FROM f_roomtype_role  rm INNER JOIN Floor_master fm ON fm.ID=rm.FloorID WHERE Role_ID='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND fm.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' GROUP BY FloorID,Role_ID ORDER BY fm.SequenceNo+0 ");
        if (dt.Rows.Count < 1)
            dt = AllLoadData_IPD.loadFloor(Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()));
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string BindRoomType(string FloorID, int isAttenderRoom)
    {
        DataTable dtData = new DataTable();
        if (FloorID == "0")
        {
            if ((isAttenderRoom == 0) || (isAttenderRoom == 1))
                dtData = AllLoadData_IPD.LoadCaseType().AsEnumerable().Where(r => r.Field<int>("isAttenderRoom") == isAttenderRoom).AsDataView().ToTable();
            else
                dtData = AllLoadData_IPD.LoadCaseType();
        }
        else
        {
            dtData = StockReports.GetDataTable("SELECT DISTINCT(ich.IPDCaseTypeID)IPDCaseTypeID,ich.Name,Role_ID FROM f_roomtype_role rt INNER JOIN ipd_case_type_master ich ON ich.IPDCaseTypeID=rt.IPDCaseTypeID  where Role_ID='" + HttpContext.Current.Session["RoleID"].ToString() + "' And FloorID='" + FloorID + "'");
            if (dtData.Rows.Count < 1)
                dtData = AllLoadData_IPD.LoadCaseType();
        }
        if (dtData.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
        else
            return "";
    }

    [WebMethod]
    public static string SearchSampleCollection(List<string> searchdata)
    {
        try
        {
            StringBuilder str = new StringBuilder();
            str.Append("SELECT (SELECT IF( COUNT(plo.`ID`)>0,1,0)IsRecollect FROM patient_labinvestigation_opd p WHERE p.`IsRecollect`=1 AND p.`Test_ID`=plo.`Test_ID` AND p.`IsSampleCollected`='N')IsRecollect, (CASE WHEN plo.Type=1 THEN '#CC99FF' WHEN plo.Type=2 THEN 'bisque' ELSE '#FF0000' END) AS rowcolour,plo.LedgerTransactionNo,CONCAT(pm.Title,'',pm.PName)PName,CONCAT(plo.CurrentAge,'/ ',pm.Gender)Age,DATE_FORMAT(CONCAT(plo.Date,' ',plo.Time),'%d-%b-%y %l:%i %p')BillDate, ");
            str.Append("IF((plo.Type=1 AND lt.IsPaymentApproval=0),(lt.NetAmount-IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' ");
            str.Append("AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount) FROM panel_amountallocation pa ");
            str.Append(" WHERE pa.TransactionID=plo.TransactionID),0)),0)Pendingcheck, ");

            str.Append(" IF(plo.Type=1, IF(lt.PanelId=1,IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd ");
            str.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0)=1,1, ");
            str.Append(" IF(IFNULL(lt.Adjustment,0) < IFNULL(lt.NetAmount,0),0,1)), ");
            str.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,1,1) FROM f_ledgertnxdetail ltd ");
            str.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0)=1,1, ");
            str.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd ");
            str.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0 AND ltd.IsPayable=1)=1, ");
            str.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd ");
            str.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0 AND ltd.IsPayable=0)=1,1,0) ");
            str.Append(" ,IF(IFNULL(lt.Adjustment,0)<IFNULL((SELECT  pmh.PatientPaybleAmt FROM patient_medical_history pmh  ");
            str.Append(" WHERE pmh.TransactionID=lt.TransactionId),0),0,1)) )  ) ,1 )IsPaymentApproved,  ");

            str.Append("IF(plo.Type=1, IF(lt.PanelId=1,IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd  ");
            str.Append("  WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0)=1,1,  ");
            str.Append(" IF(IFNULL(lt.Adjustment,0) < IFNULL(lt.NetAmount,0),CONCAT('Please Make a Payment of Rs ',(IFNULL(lt.NetAmount,0)-IFNULL(lt.Adjustment,0))),1)),  ");
            str.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd  ");
            str.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0)=1,1,  ");
            str.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd  ");
            str.Append(" WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0 AND ltd.IsPayable=1)=1,  ");
            str.Append(" IF((SELECT IF(COUNT(ltd.Id)>0,0,1) FROM f_ledgertnxdetail ltd  ");
            str.Append("  WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsPaymentApproval=0 AND ltd.IsPayable=0)=1,1,'Pending Approval')  ");
            str.Append("  ,IF(IFNULL(lt.Adjustment,0)<IFNULL((SELECT  pmh.PatientPaybleAmt FROM patient_medical_history pmh   ");
            str.Append("  WHERE pmh.TransactionID=lt.TransactionId),0),CONCAT('Please Make a Payment of Rs ',IFNULL((SELECT  pmh.PatientPaybleAmt FROM patient_medical_history pmh   ");
            str.Append("  WHERE pmh.TransactionID=lt.TransactionId),0)),1))) ) ,'' )PendingApprovalMessage ,   ");
            str.Append("  plo.PatientID, IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND SCRequestdatetime>DATE_ADD(NOW(),INTERVAL 15 MINUTE ),'1',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND SCRequestdatetime<=DATE_ADD(NOW(),INTERVAL 30 MINUTE) AND SCRequestdatetime>= DATE_ADD(NOW(),INTERVAL -30 MINUTE),'2',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND  DATE_ADD(plo.SCRequestdatetime,INTERVAL 18 HOUR)>=DATE_ADD(NOW(),INTERVAL 30 MINUTE),'4',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND DATE_ADD(plo.SCRequestdatetime,INTERVAL 18 HOUR)<NOW(),'3','0'))))SReColorcode,Concat(dm.Title,' ',Dm.Name)PdoctorName FROM patient_labinvestigation_opd plo ");
            str.Append("INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID ");
            str.Append("INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=plo.LedgerTransactionNo ");
            str.Append("INNER JOIN doctor_master dm ON dm.DoctorID=plo.DoctorID INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` AND im.ReportType != 5   ");

            // Lab Department test should come role wise for Sample Collection.
            str.Append(" INNER JOIN investigation_observationtype iot on iot.Investigation_ID=plo.Investigation_ID  ");
            str.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = iot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");

            str.Append("WHERE lt.isCancel=0 AND plo.sampleTransferCentreID =" + HttpContext.Current.Session["CentreID"].ToString() + "  ");
            if (searchdata[4] != "")
                str.Append("AND pm.PName LIKE '%" + searchdata[4] + "%'  ");
            if (searchdata[5] != "")
                str.Append("AND pm.PatientID='" + Util.GetString(searchdata[5]) + "' ");
            if (searchdata[3] != "")
                str.Append("AND plo.BarcodeNo = '" + searchdata[3] + "'  ");
            if (searchdata[8] != "0")
                str.Append("AND plo.DoctorID ='" + searchdata[8] + "'  ");
            if (searchdata[7] != "0")
                str.Append("AND dm.DocDepartmentID ='" + searchdata[7] + "' ");
            if (searchdata[9] != "0")
                str.Append("AND lt.PanelID =" + searchdata[9] + "  ");
            if (searchdata[3] == "" && searchdata[4] == "" && searchdata[5] == "" && searchdata[6] == "" && searchdata[7] == "0" && searchdata[8] == "0" && searchdata[9] == "0")
            {
                if (searchdata[10] != "" && searchdata[11] != "")
                {
                    str.Append("AND plo.Date>='" + Util.GetDateTime(searchdata[10]).ToString("yyyy-MM-dd") + "' AND plo.Date<='" + Util.GetDateTime(searchdata[11]).ToString("yyyy-MM-dd") + "' ");
                }
            }
            switch (searchdata[1])
            {
                case "N": str.Append(" AND plo.IsSampleCollected='N' ");
                    break;
                case "Y": str.Append(" AND plo.IsSampleCollected='Y' ");
                    break;
                case "S": str.Append(" AND plo.IsSampleCollected='S' ");
                    break;
                case "R": str.Append(" AND plo.IsSampleCollected='R' ");
                    break;
            }
            if (searchdata[6] != "")
                str.Append(" AND plo.IsUrgent = " + searchdata[6] + " ");
            if (searchdata[2] != "0")
                str.Append(" AND plo.Type = " + searchdata[2] + " ");
            if (searchdata[2] == "2")
                if (searchdata[12] != "0")
                str.Append(" AND plo.IPDCaseTypeID = " + searchdata[12] + " ");

            str.Append(" AND plo.Time>='00:00:00' AND plo.Time<='23:59:59' ");
            str.Append("GROUP BY lt.LedgertransactionNo order by plo.BarcodeNo ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str.ToString()));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string SearchInvestigation(string LedgerTransactionNo)
    {
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append("SELECT ltd.Id LtdId,(SELECT IF( COUNT(plo.`ID`)>0,1,0)IsRecollect FROM patient_labinvestigation_opd p WHERE p.`IsRecollect`=1 AND p.`Test_ID`=plo.`Test_ID` AND p.`IsSampleCollected`='N')IsRecollect,plo.Result_Flag,IFNULL((SELECT CONCAT(IF(UPPER(Container)='VIAL','V','C'),'^',color)color FROM sample_type ist where ist.ID=im.SampleTypeID),'') colorcode,plo.SampleQty, plo.HistoCytoSampleDetail, if(plo.HistoCytoSampleDetail=1,'7',im.reporttype) reporttype, plo.patientid,  ");
        sbQuery.Append("plo.SampleCollector,DATE_FORMAT(SampleCollectionDate,'%d-%b-%Y %h:%i %p') colldate, ");
        sbQuery.Append("plo.SampleReceiver,DATE_FORMAT(SampleReceiveDate,'%d-%b-%Y %h:%i %p') recdate,  ");
        sbQuery.Append("IFNULL(psr.RejectionReason,'')rejectreason,(Select CONCAT(Title,'',Name) from Employee_master em where em.EmployeeID=psr.UserID) rejectedBy,DATE_FORMAT(psr.EntDate,'%d-%b-%Y %h:%i %p') rejectdate,  ");
        sbQuery.Append("CASE WHEN plo.IsSampleCollected='S' THEN  'bisque' WHEN plo.IsSampleCollected='Y'  ");
        sbQuery.Append("THEN 'lightgreen'  WHEN plo.IsSampleCollected='R'  ");
        sbQuery.Append("THEN 'pink' WHEN IFNULL(ltd.`TokenCallStatus`,'0')='1' then 'lightseagreen' ELSE 'white'  ");
        sbQuery.Append("END rowcolor, pm.PName,plo.Test_ID,plo.IsSampleCollected,IF(lom.Suffix<>'',lom.Name,im.name)name,plo.`SampleTypeID`, ");
        sbQuery.Append("plo.`SampleType`,IF(lom.Suffix<>'',CONCAT(plo.BarcodeNo,lom.Suffix),plo.BarcodeNo) BarcodeNo,plo.LedgerTransactionNo,plo.PrePrintedBarcode,plo.Test_ID As TestID,plo.BarcodeNo AS BarcodeNoB,plo.Investigation_ID,   ");
        sbQuery.Append("IF(IFNULL(plo.SampleTypeID,0)=0,     ");
        sbQuery.Append("IFNULL((SELECT CONCAT(ist.id ,'^',ist.SampleType) FROM sample_type ist      ");
        sbQuery.Append("WHERE ist.id =im.SampleTypeID ORDER BY im.SampleTypename  DESC,ist.SampleType LIMIT  1),'1|')   , ");
        sbQuery.Append("CONCAT(plo.`SampleTypeID`,'|',plo.`SampleType`))  SampleID, ");
        sbQuery.Append("(SELECT GROUP_CONCAT(DISTINCT CONCAT(st.id,'|',st.SampleType)ORDER BY  st.id SEPARATOR '$') FROM sample_type st ) SampleTypes, ");
        sbQuery.Append("(SELECT GROUP_CONCAT(DISTINCT CONCAT(em.EmployeeID,'|',em.NAME)ORDER BY  em.NAME SEPARATOR '$') FROM employee_master em  INNER JOIN f_login fl ON fl.EmployeeID=em.Employeeid INNER JOIN doctor_employee de ON de.Employeeid = em.EmployeeID WHERE em.IsActive = 1 AND fl.RoleID='11' ORDER BY NAME) doctorlist, ");
        sbQuery.Append(" ifnull(tcm.Test_Centre,0) AS PerformingTestCentre, ");
        sbQuery.Append(" IFNULL((SELECT ichm.Name FROM   ipd_case_type_master ichm  WHERE IPDCaseTypeID=plo.IPDCaseTypeID),'')RoomType, ");
        sbQuery.Append(" IFNULL(( SELECT CONCAT(NAME,'/',bed_no)room FROM  room_master rm  WHERE RoomID=plo.RoomID),'')bed, ");
        sbQuery.Append(" IF (plo.SCRequestdatetime='0001-01-01 00:00:00','', DATE_FORMAT(plo.SCRequestdatetime,'%d-%b-%y %l:%i %p'))Samplerequestdate, ");
        sbQuery.Append(" IF(plo.IsSampleCollected='N','',DATE_FORMAT(plo.SampleDate,'%d-%b-%y %l:%i %p'))Acutalwithdrawdate, ");
        sbQuery.Append(" IF(plo.SCRequestdatetime='0001-01-01 00:00:00' ,'',IF(plo.IsSampleCollected='N','', ");
        sbQuery.Append(" TIME_FORMAT(TIMEDIFF(plo.SampleDate,plo.SCRequestdatetime),'%H Hr %i M ')))DevationTime, ");

        // Below line commented and made changes because requirement came that Call button should not be applicable for ipd patient.

        // sbQuery.Append(" IFNULL(ltd.`TokenCallStatus`,'0') CallStatus ,ltd.TokenNo ");
        sbQuery.Append("  IF(plo.Type=2,1,IFNULL(ltd.`TokenCallStatus`,'0')) CallStatus, ltd.TokenNo ");

        sbQuery.Append("FROM `patient_labinvestigation_opd` plo   ");
        sbQuery.Append("INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo  AND lt.Iscancel=0   ");
        sbQuery.Append("INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=plo.LedgertnxID AND ltd.IsVerified<>2    ");
        sbQuery.Append("INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID ");
        sbQuery.Append("AND lt.IsCancel=0 AND plo.`LedgerTransactionNo`=" + LedgerTransactionNo + "   ");
        sbQuery.Append("INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` AND im.ReportType != 5   ");

        // Lab Department test should come role wise for Sample Collection.
        sbQuery.Append(" INNER JOIN investigation_observationtype iot on iot.Investigation_ID=plo.Investigation_ID  ");
        sbQuery.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = iot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");

        sbQuery.Append("LEFT JOIN patient_sample_Rejection psr ON psr.Test_ID=plo.Test_ID   ");
        sbQuery.Append("LEFT JOIN labobservation_investigation loi ON loi.Investigation_Id=plo.Investigation_ID ");
        sbQuery.Append("LEFT JOIN labobservation_master lom ON lom.LabObservation_ID=loi.labObservation_ID ");
        sbQuery.Append("LEFT JOIN test_centre_mapping tcm ON tcm.Investigation_ID = im.Investigation_Id AND tcm.Booking_Centre = plo.CentreID ");
        sbQuery.Append(" WHERE  ltd.`ItemID` NOT IN (SELECT fd.`ItemID` FROM f_drcrnote fd WHERE fd.`TransactionID`=ltd.`TransactionID`) ");
      
        sbQuery.Append("GROUP BY plo.LedgerTransactionNo,plo.BarcodeNo,plo.Investigation_ID,lom.Suffix ");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string SaveSamplecollection(List<string> data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        string  Sampledatetime="";
        try
        {

            foreach (string s in data)
            {
                DataTable dtStatus = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, " Select IsSampleCollected,PrePrintedBarcode from patient_labinvestigation_opd where Test_ID='" + s.Split('#')[0] + "' ").Tables[0];
                if (dtStatus.Rows.Count > 0)
                {
                    if (Util.GetInt(dtStatus.Rows[0]["PrePrintedBarcode"]) == 1)
                    {
                        if (Util.GetString(dtStatus.Rows[0]["IsSampleCollected"]) == "R" || (Util.GetString(dtStatus.Rows[0]["IsSampleCollected"]) == "N"))
                        {
                            string newBarocode = s.Split('#')[4].Trim();
                            int a = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select count(1) from patient_labinvestigation_opd where BarcodeNo='" + newBarocode + "' and LedgerTransactionNo<>(select LedgerTransactionNo from patient_labinvestigation_opd  where Test_ID='" + s.Split('#')[0] + "')  "));
                            if (a > 0)
                            {
                                tnx.Rollback();
                                return "Barcode No Already Exist.Please Change Barcode No for : " + s.Split('#')[2];
                            }
                            if (Util.GetInt(dtStatus.Rows[0]["PrePrintedBarcode"]) == 1)
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " Update patient_labinvestigation_opd set BarcodeNo='" + newBarocode.Trim() + "' where Test_ID='" + s.Split('#')[0] + "' ");
                        }
                    }
                }
                StringBuilder sb = new StringBuilder();
                if (s.Split('#')[5] == "0")
                {
                    if (Util.GetInt(dtStatus.Rows[0]["PrePrintedBarcode"]) == 1)
                    {
                        Sampledatetime = Util.GetString(Util.GetDateTime(s.Split('#')[8]).ToString("yyyy-MM-dd HH:mm:ss"));
                    }
                    else
                    {
                        Sampledatetime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    }
                    sb.Append("update patient_labinvestigation_opd set MacStatus=0, IsSampleCollected='S',SampleCollector=@SampleCollector,SampleCollectionBy=@SampleCollectionBy,sampleDate=NOW(),SampleCollectionDate=NOW(),SampleTypeID=@SampleTypeID,SampleType=@SampleTypeName,HistoCytoPerformingDoctor=@HistoCytoPerformingDoctor,sampleCollectCentreID=@sampleCollectCentreID,HistoCytoSampleDetail=@HistoCytoSampleDetail,HistoCytoStatus=@HistoCytoStatus,SampleDate=@SampleDate where Test_ID=@Test_ID and IsSampleCollected !='S' ");
                    int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@SampleCollector", HttpContext.Current.Session["LoginName"].ToString()),
                         new MySqlParameter("@SampleCollectionBy", HttpContext.Current.Session["ID"].ToString()),
                         new MySqlParameter("@Test_ID", s.Split('#')[0]),
                         new MySqlParameter("@SampleTypeID", s.Split('#')[1]),
                         new MySqlParameter("@SampleTypeName", s.Split('#')[2]),
                         new MySqlParameter("@HistoCytoPerformingDoctor", s.Split('#')[3]),
                         new MySqlParameter("@sampleCollectCentreID", HttpContext.Current.Session["CentreID"].ToString()),
                         new MySqlParameter("@HistoCytoSampleDetail",s.Split('#')[6]),
                         new MySqlParameter("@HistoCytoStatus",s.Split('#')[7]),
                         new MySqlParameter("@SampleDate", Util.GetDateTime(Sampledatetime))
                         );
                    sb = new StringBuilder();
                }
                else if (s.Split('#')[5] != "0")
                {
                    sb.Append("update patient_labinvestigation_opd plo set MacStatus=0, IsSampleCollected='S',SampleCollector=@SampleCollector,SampleCollectionBy=@SampleCollectionBy,sampleDate=NOW(),SampleCollectionDate=NOW(),SampleTypeID=@SampleTypeID,SampleType=@SampleTypeName,HistoCytoPerformingDoctor=@HistoCytoPerformingDoctor,sampleCollectCentreID=@sampleCollectCentreID, ");
                    sb.Append("plo.isTransfer=1,plo.sampleTransferCentreID=@sampleTransferCentreID, plo.sampleTransferUserID=@sampleTransferUserID, plo.sampleTransferDate=NOW(),HistoCytoSampleDetail=@HistoCytoSampleDetail,HistoCytoStatus=@HistoCytoStatus,SampleDate=@SampleDate WHERE Test_ID=@Test_ID and IsSampleCollected !='S' ");
                    int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@SampleCollector", HttpContext.Current.Session["LoginName"].ToString()),
                         new MySqlParameter("@SampleCollectionBy", HttpContext.Current.Session["ID"].ToString()),
                         new MySqlParameter("@Test_ID", s.Split('#')[0]),
                         new MySqlParameter("@SampleTypeID", s.Split('#')[1]),
                         new MySqlParameter("@SampleTypeName", s.Split('#')[2]),
                         new MySqlParameter("@HistoCytoPerformingDoctor", s.Split('#')[3]),
                         new MySqlParameter("@sampleCollectCentreID", HttpContext.Current.Session["CentreID"].ToString()),
                         new MySqlParameter("@sampleTransferCentreID", s.Split('#')[5]),
                         new MySqlParameter("@sampleTransferUserID", HttpContext.Current.Session["ID"].ToString()),
                         new MySqlParameter("@HistoCytoSampleDetail", s.Split('#')[6]),
                         new MySqlParameter("@HistoCytoStatus", s.Split('#')[7]),
                          new MySqlParameter("@SampleDate", Util.GetDateTime(Sampledatetime))
                    );
                    sb = new StringBuilder();
                    if (cnt > 0)
                    {
                        //int DispatchCode =  Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_barcode(" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString());
                        sb = new StringBuilder();
                        sb.Append("INSERT INTO sample_logistic (Test_ID,BarcodeNo,FromCentreID,ToCentreID,EntryBy,Status) ");
                        sb.Append("VALUES (@Test_ID,@BarcodeNo,@FromCentreID,@ToCentreID,@EntryBy,'Transfered') ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@Test_ID", s.Split('#')[0]),
                           new MySqlParameter("@BarcodeNo", s.Split('#')[4]),
                           new MySqlParameter("@FromCentreID", HttpContext.Current.Session["CentreID"].ToString()),
                           new MySqlParameter("@ToCentreID", s.Split('#')[5]),
                           new MySqlParameter("@EntryBy", HttpContext.Current.Session["ID"].ToString())
                           );
                    }
                }
                string Status = LabOPD.UpdateSampleStatus(tnx, s.Split('#')[0], HttpContext.Current.Session["ID"].ToString(), HttpContext.Current.Session["LoginName"].ToString(), Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "Sample Collected", "");
                if (Status == "0")
                {
                    tnx.Rollback();
                    return "0";
                }

                string currentTokenNo = s.Split('#')[10].ToString();


                ExcuteCMD cmd = new ExcuteCMD();
                cmd.DML(tnx, "UPDATE  `f_ledgertnxdetail` ltd INNER JOIN  patient_labinvestigation_opd plo  ON plo.`LedgertnxID`=ltd.Id  INNER JOIN `f_subcategorymaster` sm ON ltd.`SubcategoryID`=sm.`SubCategoryID` SET ltd.`TokenCallStatus`=3 WHERE ltd.`TokenNo`=@tokenNo AND ltd.`LedgerTransactionNo`=@LtnxNo And plo.`Test_ID`=@TestID AND sm.`CategoryID`=3", CommandType.Text, new
                {
                    tokenNo = currentTokenNo,
                    LtnxNo = s.Split('#')[9].ToString(),
                    TestID = s.Split('#')[0].ToString()

                }); 
			
            }

           
		   /* string id = StockReports.ExecuteScalar("(SELECT id FROM f_ledgertnxdetail WHERE `SubCategoryID` IN (SELECT `SubCategoryID` FROM f_subcategorymaster WHERE `CategoryID`='3') AND LedgerTransactionNo='" + data[0].Split('#')[9].ToString() + "' ORDER BY ID ASC LIMIT 1)");
            
            ExcuteCMD cmd = new ExcuteCMD();
            cmd.DML(tnx, "UPDATE  `f_ledgertnxdetail` ltd SET ltd.`TokenCallStatus`=3 WHERE ltd.`TokenNo`=@tokenNo AND ltd.`ID`=@id ", CommandType.Text, new
            {
                tokenNo = currentTokenNo,
                id = id
            }); */
         
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();

        }
    }

    [WebMethod(EnableSession = true)]
    public static string getBarcode(string LedgertransactionNo, string Investigation_ID)
    {
        string BarcodeNo = "";
        if (LedgertransactionNo.Split('#')[1] == "B")
            BarcodeNo = LedgertransactionNo.Split('#')[0];
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pm.PName,plo.CurrentAge,LEFT(pm.Gender,1)Gender,plo.PatientID,(CASE WHEN plo.TYPE=1 THEN 'OPD' WHEN plo.Type=2 THEN 'IPD' WHEN plo.Type=3 THEN 'EMG' END)PatientType, ");
        if (BarcodeNo == "" && LedgertransactionNo.Split('#')[1] == "L")
            sb.Append("IF(lom.Suffix<>'',CONCAT(plo.BarcodeNo,lom.Suffix),plo.BarcodeNo) AS BarcodeNo, ");
        else
            sb.Append(" IF(lom.Suffix<>'',CONCAT(plo.BarcodeNo,lom.Suffix),plo.BarcodeNo) AS BarcodeNo, ");
        sb.Append(" IF(DATE_FORMAT(plo.SampleCollectionDate,'%d-%m-%y %H:%i')='01-01-01 00:00',NOW(),DATE_FORMAT(plo.SampleCollectionDate,'%d-%m-%y %H:%i'))SampleDate,pm.PatientID,plo.sampletype,LEFT(ot.Name,5)DeptName "); 
        sb.Append("FROM patient_labinvestigation_opd plo INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=plo.LedgerTransactionNo ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID INNER JOIN Investigation_master im ON im.Investigation_ID=plo.Investigation_ID ");
        if (LedgertransactionNo.Split('#')[1] == "L")
        {
            sb.Append("LEFT JOIN labobservation_investigation loi ON loi.Investigation_Id=plo.Investigation_ID ");
            sb.Append("LEFT JOIN labobservation_master lom ON lom.LabObservation_ID=loi.labObservation_ID ");
        }
        else
        {
            sb.Append(" LEFT JOIN labobservation_investigation loi ON loi.Investigation_Id=plo.Investigation_ID ");
            sb.Append(" LEFT JOIN labobservation_master lom ON lom.LabObservation_ID = loi.labObservation_ID ");
        }

        sb.Append("INNER JOIN investigation_observationtype io ON plo.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" WHERE plo.Investigation_ID<>'' ");
        if(LedgertransactionNo.Split('#')[1] == "L")
            sb.Append("AND lt.LedgertransactionNo=" + LedgertransactionNo.Split('#')[0] + " AND im.ReportType<>5 GROUP BY im.Investigation_Id,ot.ObservationType_ID,lom.Suffix ");
        else if (LedgertransactionNo.Split('#')[1] == "B" && LedgertransactionNo.Contains('-'))
            sb.Append("AND plo.BarcodeNo='" + LedgertransactionNo.Split('#')[0].Split('-')[0].Trim() + "' AND plo.Investigation_ID='" + Investigation_ID + "'  LIMIT 1 ");
        else
            sb.Append("AND plo.BarcodeNo='" + LedgertransactionNo.Split('#')[0].Trim() + "' AND plo.Investigation_ID='" + Investigation_ID + "' LIMIT 1 ");
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        
        string data = "";
        for (int j = 0; j < dt.Rows.Count; j++)
        {
            data = data + "" + (data == "" ? "" : "^") + dt.Rows[j]["PName"].ToString().ToUpper() + "," + dt.Rows[j]["CurrentAge"].ToString() + "/" + dt.Rows[j]["Gender"].ToString() + "," + dt.Rows[j]["BarcodeNo"].ToString() + "," + dt.Rows[j]["SampleDate"].ToString() + "," + "(" + dt.Rows[j]["DeptName"].ToString() + "/" + dt.Rows[j]["sampletype"].ToString() + ")" + "," + dt.Rows[j]["PatientType"].ToString() + "," + dt.Rows[j]["PatientID"].ToString() + "," + dt.Rows[j]["PatientID"].ToString() + "," + dt.Rows[j]["PatientID"].ToString();
        }
        //PNAme 0;
        //Age 1;
        //Barcode 2;
        //sampleDate 3;
        //Dept 4;
        //PatienttYPE 5;
        //pATIENTid 6;
        //System.IO.
        //StreamWriter file2 = new StreamWriter(@"c:\file.txt");
        //file2.WriteLine(data);
        //file2.Close();
        return data;
    }
    [WebMethod]
    public static string SampleRejection(string RejectReason, string TestID)
    {

        int CentreID = Util.GetInt(StockReports.ExecuteScalar("Select plo.CentreID from patient_labinvestigation_opd plo where plo.Test_ID in('" + TestID + "')"));
        if(CentreID != Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()))
            return "you can not reject the sample of another Centre.";

        string IsAuthorised = All_LoadData.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), HttpContext.Current.Session["ID"].ToString(), "IsLabReject");
        if (IsAuthorised == "0" || IsAuthorised == "")
        {
            return "You Are Not Authorize To Reject The Sample, Kindly Contact To IT Team Or Lab Incharge";
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT IF(plo.Type='2',plo.TransactionID,plo.LedgerTransactionNo)TransNo,plo.Test_ID,plo.Type,pm.mobile,pm.PatientID,plo.TransactionID," +
                                       " plo.Investigation_ID,plo.LedgertransactionNo,io.ObservationType_Id,plo.LedgertnxID,ltd.ItemID,ltd.ItemName,lt.PanelID,ltd.IsPackage " +
                                       " FROM patient_labinvestigation_opd plo   " +
                                       " INNER JOIN investigation_observationtype io ON io.Investigation_ID=plo.Investigation_ID  " +
                                       " INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=plo.LedgertnxID " +
                                       " INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=plo.LedgerTransactionNo  " +
                                       " INNER JOIN Patient_master pm ON pm.PatientID=plo.PatientID  " +
                                       " WHERE plo.Test_ID='" + TestID + "'");
            //if (AllLoadData_IPD.CheckDataPostToFinance(dt.Rows[0]["TransNo"].ToString()) > 0)
            //{
            //    string Msga = "Patient Final Bill Already Posted To Finance...";
            //    tnx.Rollback();
            //    return Msga;
            //}
            var isShareAllocationDone = StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_paymentallocation p WHERE p.TransactionID='" + dt.Rows[0]["TransactionID"].ToString() + "' AND p.IsActive=1");
            if (Util.GetInt(isShareAllocationDone) > 0)
            {
                tnx.Rollback();
                return "Sorry Doctor Allocation Done.";
            }
            string sql1 = "insert into patient_sample_Rejection(PatientID, TransactionID, Test_ID,Investigation_ID, LedgerTransactionNo, ObservationType_Id, " +
                          "RejectionReason, UserID ) values ('" + Util.GetString(dt.Rows[0]["PatientID"].ToString()) + "', " +
                          " '" + Util.GetString(dt.Rows[0]["TransactionID"].ToString()) + "', '" + Util.GetString(TestID) + "', " +
                          " '" + Util.GetString(dt.Rows[0]["Investigation_ID"]) + "','" + Util.GetString(dt.Rows[0]["LedgertransactionNo"]) + "' , " +
                          " '" + Util.GetString(dt.Rows[0]["ObservationType_Id"]) + "' , '" + Util.GetString(RejectReason) + "', " +
                          " '" + HttpContext.Current.Session["ID"].ToString() + "' ) ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql1);
            string sql = "Update patient_labinvestigation_opd Set IsSampleCollected = 'R' Where Test_ID ='" + TestID + "' ;";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            if (dt.Rows[0]["Type"].ToString() != "1")
            {
                string TypeBill = "IPD";
                if (dt.Rows[0]["Type"].ToString() == "3")
                    TypeBill = "EMG";
                if (AllLoadData_IPD.CheckBillGenerate(dt.Rows[0]["TransactionID"].ToString(), TypeBill) > 0)
                {
                    tnx.Rollback();
                    return "Bill Already Generated.";
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET LabSampleCollected='R',IsVerified=2,Updatedate=NOW() WHERE ID=" + Util.GetInt(dt.Rows[0]["LedgertnxID"]) + " ");
                if (dt.Rows[0]["Type"].ToString() == "3")
                {
                    string UpdateQuery = "Call updateEmergencyBillAmounts(" + dt.Rows[0]["LedgertransactionNo"].ToString() + ")";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateQuery);
                    string docstring = All_LoadData.CalcaluteDoctorShare("", dt.Rows[0]["LedgertnxID"].ToString(), "1", "HOSP", tnx, con);
                }
                else
                {
                    string docstringIPD = All_LoadData.CalcaluteDoctorShare("", dt.Rows[0]["LedgertnxID"].ToString(), "2", "HOSP", tnx, con);
                }
            }
            else
            {
                if (dt.Rows[0]["IsPackage"].ToString() == "0")
                {
                    decimal CrAmount = Util.GetDecimal(excuteCMD.ExecuteScalar("SELECT (SUM(LTD.Amount)+(IFNULL(SUM(D.`Amount`),0))) FROM f_LedgerTnxDetail LTD LEFT JOIN `f_LedgerTnxDetail` d ON d.LedgerTnxRefID=ltd.ID AND d.IsVerified=1 WHERE LTD.ID=@ltdID", new
                    {
                        ltdID = dt.Rows[0]["LedgertnxID"].ToString()
                    }));

                    var billNo = Util.GetString(excuteCMD.ExecuteScalar("Select BillNo from f_Ledgertransaction where TransactionID=@transactionID and (BillNo is not null or BillNo <>'') Limit 1", new
                    {
                        transactionID = dt.Rows[0]["TransactionID"].ToString()

                    }));

                    var patientLedgerNumber = Util.GetString(excuteCMD.ExecuteScalar("SELECT lm.LedgerNumber FROM f_ledgermaster lm WHERE lm.LedgerUserID=@patientID", new
                    {
                        patientID = dt.Rows[0]["PatientID"].ToString()

                    }));
                    var patientType = "";
                    patientType = "CR";
                    string creditDebitNumber = Util.GetString(excuteCMD.ExecuteScalar(tnx, "select get_CrDrNo(CURRENT_DATE(),@patientType,@unit)", CommandType.Text, new
                    {
                        patientType = patientType,
                        unit = HttpContext.Current.Session["CentreID"].ToString()
                    }));
                    if (creditDebitNumber == "0")
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Credit & Debit No Error." });
                    }
                    drcrnote _drcrnote = new drcrnote(tnx);
                    _drcrnote.CRDR = "CR";
                    _drcrnote.CrDrNo = creditDebitNumber;
                    _drcrnote.TransactionID = dt.Rows[0]["TransactionID"].ToString();
                    _drcrnote.Amount = CrAmount;
                    _drcrnote.EntryDateTime = System.DateTime.Now;
                    _drcrnote.PtTYPE = "PTNT";
                    _drcrnote.BillNo = billNo;
                    _drcrnote.LedgerName = patientLedgerNumber;
                    _drcrnote.Narration = RejectReason;
                    _drcrnote.ItemID = dt.Rows[0]["ItemID"].ToString();
                    _drcrnote.UserID = HttpContext.Current.Session["ID"].ToString();
                    _drcrnote.ItemName = dt.Rows[0]["ItemName"].ToString();
                    _drcrnote.LedgerTnxID = Util.GetInt(dt.Rows[0]["LedgertnxID"].ToString());
                    _drcrnote.LedgerTransactionNo = Util.GetInt(dt.Rows[0]["LedgerTransactionNo"].ToString());
                    _drcrnote.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    _drcrnote.PanelID = Util.GetInt(dt.Rows[0]["PanelID"].ToString());
                    _drcrnote.CRDRNoteType = 1;
                    _drcrnote.Insert();

                    decimal Rate = 0;
                    decimal DiscountAmount = 0;
                    decimal DiscountPercentage = 0;
                    decimal Amount = 0;

                    Rate = CrAmount * -1;
                    Amount = CrAmount * -1;
                    var Ledgertnxdetail = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "CALL Insert_CRDR_ledgertnxdetail(@vTypeofTnx,@vLedgerTnxID,@vAmount,@vUserID,@vpageURL, " +
                        "@vCentreID,@vRoleID,@vIpAddress,@vcreditDebitNumber,@vRate,@vDiscountPercentage,@vDiscAmt)", CommandType.Text, new
                    {
                        vTypeofTnx = "CR",
                        vLedgerTnxID = Util.GetInt(dt.Rows[0]["LedgertnxID"].ToString()),
                        vAmount = Amount,
                        vUserID = HttpContext.Current.Session["ID"].ToString(),
                        vpageURL = All_LoadData.getCurrentPageName(),
                        vCentreID = HttpContext.Current.Session["CentreID"].ToString(),
                        vRoleID = HttpContext.Current.Session["RoleID"].ToString(),
                        vIpAddress = All_LoadData.IpAddress(),
                        vcreditDebitNumber = creditDebitNumber,
                        vRate = Rate,
                        vDiscountPercentage = DiscountPercentage,
                        vDiscAmt = DiscountAmount
                    }));
                    var LedgerTransacionUpdate = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "CALL Insert_CRDR_f_ledgertransaction(@vLedgerTransactionNo)", CommandType.Text, new
                    {
                        vLedgerTransactionNo = dt.Rows[0]["LedgerTransactionNo"].ToString()
                    }));

                    if (dt.Rows[0]["PanelID"].ToString() == "1")
                    {
                        var pmh = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "UPDATE patient_medical_history pmh SET pmh.PatientPaybleAmt= (pmh.PatientPaybleAmt + (@vnewAmount)) WHERE pmh.TransactionID=@vTransaction_ID AND pmh.PatientPaybleAmt>0 ", CommandType.Text, new
                        {
                            vTransaction_ID = dt.Rows[0]["TransactionID"].ToString(),
                            vnewAmount = Amount
                        }));
                    }
                    if (dt.Rows[0]["PanelID"].ToString() != "1")
                    {
                        var pmh = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "UPDATE patient_medical_history pmh SET pmh.PanelPaybleAmt= (pmh.PanelPaybleAmt + (@vnewAmount)) WHERE pmh.TransactionID=@vTransaction_ID AND pmh.PanelPaybleAmt>0 ", CommandType.Text, new
                        {
                            vTransaction_ID = dt.Rows[0]["TransactionID"].ToString(),
                            vnewAmount = Amount
                        }));
                    }
                }
            }
            string Status = LabOPD.UpdateSampleStatus(tnx, TestID, HttpContext.Current.Session["ID"].ToString(), HttpContext.Current.Session["LoginName"].ToString(), Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "Sample Rejected", "");
            if (Status == "0")
            {
                tnx.Rollback();
                return "0";
            }
            //  All_LoadData.updateNotification(Util.GetString(dt.Rows[0]["LedgertnxID"]));
            if (Resources.Resource.SMSApplicable == "1" && dt.Rows[0]["Mobile"].ToString() != "")
            {
                var columninfo = smstemplate.getColumnInfo(2, con);
                if (columninfo.Count > 0)
                {
                    //columninfo[0].PatientID = PatientID;
                    //columninfo[0].PName = PName;
                    //columninfo[0].TemplateID = 8;
                    //string sms = smstemplate.getSMSTemplate(8, columninfo, 1, con, "");
                }
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]

    public static string searchSReqPatient(string fromDate, string toDate)
    {
     
        try
        {
            StringBuilder sb = new StringBuilder();
            //sb.Append("  SELECT CONCAT(pm.Title,'',pm.PName)Pname,pm.PatientID,'1' colorid,plo.LedgerTransactionNo FROM patient_labinvestigation_opd plo  ");

            sb.Append("  SELECT CONCAT(pm.Title,'',pm.PName)Pname,pm.PatientID,IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND SCRequestdatetime>DATE_ADD(NOW(),INTERVAL 15 MINUTE ),'1',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND SCRequestdatetime<=DATE_ADD(NOW(),INTERVAL 30 MINUTE) AND SCRequestdatetime>= DATE_ADD(NOW(),INTERVAL -30 MINUTE),'2',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND  DATE_ADD(plo.SCRequestdatetime,INTERVAL 18 HOUR)>=DATE_ADD(NOW(),INTERVAL 30 MINUTE),'4',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND DATE_ADD(plo.SCRequestdatetime,INTERVAL 18 HOUR)<NOW(),'3','0'))))  colorid,plo.LedgerTransactionNo FROM patient_labinvestigation_opd plo  ");
           
            sb.Append("  INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID ");
            sb.Append("  INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID ");
            sb.Append("  WHERE plo.IsSampleCollected='N'  AND plo.SCRequestdatetime<>'0001-01-01 00:00:00'   ");
            sb.Append("  AND SCRequestdatetime<=DATE_ADD(NOW(),INTERVAL 30 MINUTE)  AND  SCRequestdatetime>= NOW() AND plo.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND plo.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY plo.LedgerTransactionNo ");
            sb.Append("  UNION ALL ");
          //  sb.Append(" SELECT CONCAT(pm.Title,'',pm.PName)Pname,pm.PatientID,'0' colorid,plo.LedgerTransactionNo FROM patient_labinvestigation_opd plo  ");

            sb.Append(" SELECT CONCAT(pm.Title,'',pm.PName)Pname,pm.PatientID,IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND SCRequestdatetime>DATE_ADD(NOW(),INTERVAL 15 MINUTE ),'1',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND SCRequestdatetime<=DATE_ADD(NOW(),INTERVAL 30 MINUTE) AND SCRequestdatetime>= DATE_ADD(NOW(),INTERVAL -30 MINUTE),'2',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND  DATE_ADD(plo.SCRequestdatetime,INTERVAL 18 HOUR)>=DATE_ADD(NOW(),INTERVAL 30 MINUTE),'4',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND DATE_ADD(plo.SCRequestdatetime,INTERVAL 18 HOUR)<NOW(),'3','0')))) colorid,plo.LedgerTransactionNo FROM patient_labinvestigation_opd plo  ");
           
            sb.Append("  INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID ");
            sb.Append("  INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID ");
            sb.Append("  WHERE plo.IsSampleCollected='N'  AND plo.SCRequestdatetime<>'0001-01-01 00:00:00'   ");
            sb.Append("  AND SCRequestdatetime<NOW() AND plo.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND plo.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'  GROUP BY plo.LedgerTransactionNo ");

            
            

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            
        }
         
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }       

    }

    [WebMethod]
    public static string BindCollectionRoom()
    {

        try
        {

            var roleid = "";
            if (HttpContext.Current.Session["RoleID"].ToString() == "61")
            {
                roleid = "11";
            }
            else { roleid = HttpContext.Current.Session["RoleID"].ToString(); }
            DataTable dt = StockReports.GetDataTable("SELECT id,roomName FROM sampleCollectionRoomMaster WHERE isactive=1 AND roleid='" + roleid + "' AND centreID='" + HttpContext.Current.Session["CentreID"] + "'");
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else { return "0"; }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }


    }

    [WebMethod]
    public static string SaveCalledPatient(List<string> data, string CollectionRoomName, string FromDate, string ToDate)
    {
      
        try
        {
            string previousCallToken = string.Empty;
            string returnMsg = string.Empty,LedgertnxNo=string.Empty;
            int isMultiple = 0;

            var str = " SELECT ltd.`TokenNo`,CONCAT(pm.Title,' ',pm.PName)Pname,pm.PatientID,DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y')EntryDate FROM `f_ledgertnxdetail` ltd INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ltd.TransactionID INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  WHERE ltd.`TokenCallStatus`=1 AND LOWER(ltd.`TokenRoomName`)='" + CollectionRoomName.ToLower() + "' AND DATE(ltd.EntryDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(ltd.EntryDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND ltd.`IsRefund`=0 AND pmh.CentreID='" + HttpContext.Current.Session["CentreID"] + "' ";
            DataTable checkAlreadyCalled = StockReports.GetDataTable(str);

            if (checkAlreadyCalled != null && checkAlreadyCalled.Rows.Count > 0)
            {
                 returnMsg = "Token No :" + checkAlreadyCalled.Rows[0]["TokenNo"].ToString() + " Already Called In Room :" + CollectionRoomName + " of </br> Patient : " + checkAlreadyCalled.Rows[0]["Pname"].ToString() + " &nbsp; &nbsp; UHID : " + checkAlreadyCalled.Rows[0]["PatientID"].ToString() + " &nbsp; Date : " + checkAlreadyCalled.Rows[0]["EntryDate"].ToString();
                
                return returnMsg+"#";
            }

            foreach (string s in data) {

                string CurrentToken = s.Split('#')[10].ToString();
                LedgertnxNo=s.Split('#')[9].ToString();
                if (previousCallToken != CurrentToken && !String.IsNullOrEmpty(previousCallToken))
                {
                    isMultiple = 1;
                }
                else { previousCallToken = CurrentToken; }
            }
            if (isMultiple == 1)
            {

                 returnMsg = "Please Select Single Token No Or Patient.";

                 return returnMsg+"#";
            }
            else
            {
                ExcuteCMD cmd = new ExcuteCMD();
                cmd.DML("UPDATE  `f_ledgertnxdetail` ltd INNER JOIN `f_subcategorymaster` sm ON ltd.`SubcategoryID`=sm.`SubCategoryID` SET ltd.`TokenCallStatus`=1 WHERE ltd.`TokenNo`=@tokenNo  AND ltd.`LedgerTransactionNo`=@LtnxNo AND sm.`CategoryID`=3", CommandType.Text, new
                {
                    tokenNo = previousCallToken,
                    LtnxNo = LedgertnxNo

                }); 
				
			  /* string id = StockReports.ExecuteScalar("(SELECT id FROM f_ledgertnxdetail WHERE `SubCategoryID` IN (SELECT `SubCategoryID` FROM f_subcategorymaster WHERE `CategoryID`='3') AND LedgerTransactionNo='" + LedgertnxNo + "' ORDER BY ID ASC LIMIT 1)");
            
                ExcuteCMD cmd = new ExcuteCMD();
                cmd.DML("UPDATE  `f_ledgertnxdetail` ltd SET ltd.`TokenCallStatus`=1 WHERE ltd.`TokenNo`=@tokenNo  AND ltd.`ID`=@id", CommandType.Text, new
                {
                    tokenNo = previousCallToken,
                    id = id

                });*/


            }
            return "1" + "#" + LedgertnxNo;
        }
        catch (Exception ex)
        {
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    [WebMethod]
    public static string SaveUnCalledPatient(List<string> data, string CollectionRoomName, string FromDate, string ToDate)
    {
        try
        {
            string LedgertnxNo = data[0].Split('#')[9].ToString();
            string CurrentTokenNo = data[0].Split('#')[10].ToString();

            ExcuteCMD cmd = new ExcuteCMD();
            cmd.DML("UPDATE  `f_ledgertnxdetail` ltd SET ltd.`TokenCallStatus`=2 WHERE ltd.`TokenNo`=@tokenNo  AND ltd.`LedgerTransactionNo`=@LtnxNo", CommandType.Text, new
            {
                tokenNo = CurrentTokenNo,
                LtnxNo = LedgertnxNo

            });

            return "1"+"#"+LedgertnxNo;
        }

        catch (Exception ex)
        {
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }

  /* [WebMethod]
     public static string getDoctorOrderReport(string date, string fromTime, string toTime, string Location)
     {        
        TimeSpan  CompareFromDate = TimeSpan.Parse(Util.GetDateTime(fromTime).ToString("hh:mm"));
        TimeSpan CompareToTime = TimeSpan.Parse(Util.GetDateTime(toTime).ToString("hh:mm"));
        var message = string.Empty;            
           string datetimefrom = date + " " + fromTime;
           string datetimeto = date + " " + toTime;

           StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CONCAT(PM.Title,' ',PM.PName) Pname,cr.PatientId as UHID,concat(icm.NAME,'/',rm.Room_No,'/',rm.Bed_No)WardType, ");
            sb.Append("  im.TypeName as TestName,DATE_FORMAT( cr.NextRunTime ,'%d-%b-%Y %r')  UpcomingOrder,CONCAT(dm.Title,' ',dm.NAME)Orderby,'Pending' IndentStatus ");
            sb.Append(" FROM  crm_reminders_status cr ");   
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=cr.PatientId     ");   
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=cr.ItemId   ");   
            sb.Append(" INNER JOIN doctor_master DM ON DM.DoctorID=cr.DoctorId    ");   
            sb.Append(" inner join patient_ipd_profile pip on cr.TransactionId=pip.TransactionID  ");   
            sb.Append(" inner join room_master rm on rm.RoomID=pip.RoomID  ");   
            sb.Append(" inner join ipd_case_type_master icm on icm.IPDCaseTypeID=pip.IPDCaseTypeID WHERE IsDiscontinued=0     ");
            if (Location != "0" && !string.IsNullOrEmpty(Location.Trim()))
            {
                sb.Append(" AND  icm.IPDCaseTypeID='" + Location.Trim() + "'");
            }
            sb.Append(" AND  cr.NextRunTime>='" + Util.GetDateTime(datetimefrom).ToString("yyyy-MM-dd HH:mm:ss") + "' AND date(cr.NextRunTime)<='" + Util.GetDateTime(datetimeto).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
            sb.Append("	and  CONCAT(cr.AutoStopDate,' ',cr.AutoStopTime)>= NOW() AND cr.IsActive=1 AND cr.ReminderID=1 ");
            sb.Append("  UNION ALL  ");
            sb.Append(" SELECT CONCAT(pm.Title,'',pm.PName)Pname ,pm.PatientID as UHID ,CONCAT(icm.NAME,'/',rm.Room_No,'/',rm.Bed_No)WardType ");
            sb.Append(" , im.NAME AS TestName,DATE_FORMAT( plo.SCRequestdatetime ,'%d-%b-%Y %r')UpcomingOrder,CONCAT(dm.Title,' ',dm.NAME)Orderby,'Done' IndentStatus ");
            sb.Append(" FROM patient_labinvestigation_opd plo ");    
            sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID   ");    
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID   ");    
            sb.Append(" INNER JOIN patient_ipd_profile pip ON pip.TransactionId=plo.TransactionId ");    
            sb.Append(" INNER JOIN room_master rm ON rm.RoomID=pip.RoomID  ");    
            sb.Append(" iNNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=pip.IPDCaseTypeID ");    
            sb.Append(" inner join doctor_master dm on dm.DoctorID=plo.DoctorID ");    
            sb.Append(" WHERE plo.IsSampleCollected='N' ");
            if (Location!="0" &&  !string.IsNullOrEmpty(Location.Trim()))
            {
                sb.Append(" AND  icm.IPDCaseTypeID='"+Location.Trim()+"'");
            }
            sb.Append(" AND plo.SCRequestdatetime<>'0001-01-01 00:00:00'     AND SCRequestdatetime<=DATE_ADD(NOW(),INTERVAL 30 MINUTE) ");
            sb.Append(" AND  SCRequestdatetime>= NOW() AND plo.Date>='" + Util.GetDateTime(datetimefrom).ToString("yyyy-MM-dd") + "' AND plo.Date<= '" + Util.GetDateTime(datetimeto).ToString("yyyy-MM-dd") + "'");    

             DataTable dt = StockReports.GetDataTable(sb.ToString());
             if (dt.Rows.Count > 0)
             {
                 HttpContext.Current.Session["dtExport2Excel"] = dt;
                 HttpContext.Current.Session["ReportName"] = "Upcoming Orders List";
                 return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Record Founds" });
             }
             else
             {
                 return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Record Founds" });
             }              
    } */

    [WebMethod]
    public static string getDoctorOrderReport(string date, string Todate, string fromTime, string toTime, string Location)
     {  
        TimeSpan  CompareFromDate = TimeSpan.Parse(Util.GetDateTime(fromTime).ToString("hh:mm"));
        TimeSpan CompareToTime = TimeSpan.Parse(Util.GetDateTime(toTime).ToString("hh:mm"));
        var message = string.Empty;            
           string datetimefrom = date + " " + fromTime;
           string datetimeto = Todate + " " + toTime;

           StringBuilder sb = new StringBuilder();
           sb.Append(" SELECT t.BarcodeNo,t.UHID,t.PatientName,t.Age,t.Gender,t.TestName,  ");
           sb.Append(" t.`IPD No.`, t.PatientType,");
           sb.Append(" ");

           // sb.Append(" CONCAT(icm.NAME,'/',rm.Room_No,'/',rm.Bed_No)Ward, ");
           sb.Append(" t.Ward, ");
           sb.Append(" t.PrescribeDate, ");
           sb.Append(" t.WithdrawDate, ");
           sb.Append(" t.`Urgent?` FROM ");
            sb.Append(" ( ");
            sb.Append(" SELECT plo.BarcodeNo,plo.PatientID AS UHID,CONCAT(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,im.Name TestName,  ");
            sb.Append(" IF(plo.Type=2,pmh.TransNo,'')'IPD No.', pmh.type PatientType,");
            sb.Append(" IFNULL((SELECT TRIM(CONCAT(icm.IPDCaseTypeID,'')) FROM room_master rm INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=rm.IPDCaseTypeID"+
  " WHERE rm.RoomId=pmh.CurrentRoomID),(SELECT TRIM(CONCAT(icm.IPDCaseTypeID,'')) FROM room_master rm INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=rm.IPDCaseTypeID"+
  " WHERE rm.RoomId=(SELECT pp.RoomID FROM patient_ipd_profile pp WHERE pp.TransactionID=pmh.TransactionID)))Location,");

            // sb.Append(" CONCAT(icm.NAME,'/',rm.Room_No,'/',rm.Bed_No)Ward, ");
            sb.Append(" IFNULL((SELECT TRIM(CONCAT(icm.Name,'')) FROM room_master rm INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=rm.IPDCaseTypeID"+
  " WHERE rm.RoomId=pmh.CurrentRoomID),(SELECT TRIM(CONCAT(icm.Name,'')) FROM room_master rm INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=rm.IPDCaseTypeID"+
  " WHERE rm.RoomId=(SELECT pp.RoomID FROM patient_ipd_profile pp WHERE pp.TransactionID=pmh.TransactionID)))Ward, ");
            sb.Append(" CONCAT((DATE_FORMAT(plo.Date,'%d-%b-%y')),' ',(DATE_FORMAT(plo.Time,'%h:%i:%s %p')))PrescribeDate, ");
            sb.Append(" CONCAT((DATE_FORMAT(plo.SCRequestdatetime,'%d-%b-%y')),' ',(DATE_FORMAT(plo.SCRequestdatetime,'%h:%i %p')))WithdrawDate, ");
            sb.Append(" IF(plo.IsUrgent=1,'Yes','') `Urgent?` ");
            sb.Append(" FROM patient_labinvestigation_opd plo   ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=plo.LedgerTransactionNo  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID  ");
            sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID  ");
            sb.Append(" INNER JOIN investigation_observationtype io ON io.Investigation_ID=plo.Investigation_ID  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=plo.TransactionID  ");
            sb.Append(" INNER JOIN observationtype_master ot ON ot.ObservationType_ID=io.ObservationType_Id  ");
            sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID AND cr.RoleID='11'  ");
            sb.Append(" INNER JOIN center_master cm ON cm.CentreID=plo.sampleTransferCentreID  ");
            sb.Append(" INNER JOIN center_master cm1 ON cm1.CentreID=plo.CentreID  ");
            sb.Append(" INNER JOIN patient_ipd_profile pip ON pmh.TransactionId=pip.TransactionID  ");
            sb.Append(" INNER JOIN room_master rm ON rm.RoomID=pip.RoomID ");
            sb.Append(" INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=pip.IPDCaseTypeID ");
            sb.Append(" LEFT JOIN sample_logistic sl ON sl.Test_ID=plo.Test_ID AND sl.isActive=1   ");
          //  sb.Append(" WHERE CONCAT(plo.Date,' ',plo.Time) >= '" + Util.GetDateTime(datetimefrom).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
          //  sb.Append(" AND CONCAT(plo.Date,' ',plo.Time) <= '" + Util.GetDateTime(datetimeto).ToString("yyyy-MM-dd HH:mm:ss") + "' ");

            sb.Append(" WHERE plo.SCRequestdatetime >= '" + Util.GetDateTime(datetimefrom).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
            sb.Append(" AND plo.SCRequestdatetime <= '" + Util.GetDateTime(datetimeto).ToString("yyyy-MM-dd HH:mm:ss") + "' ");

            sb.Append(" AND plo.CentreID = '" + HttpContext.Current.Session["CentreID"] + "'  ");
            sb.Append(" AND plo.Type IN (2) AND plo.IsSampleCollected='N' ");
            if (Location != "0" && Location != "67" && !string.IsNullOrEmpty(Location.Trim()))
            {
                sb.Append(" AND  icm.IPDCaseTypeID='" + Location.Trim() + "' GROUP BY plo.Test_ID  )t  where t.Location='" + Location + "' ORDER BY BarcodeNo ");
            }
            else
            {
                sb.Append(" GROUP BY plo.Test_ID ");
                sb.Append(" UNION ALL ");
                sb.Append(" SELECT plo.BarcodeNo,plo.PatientID AS UHID,CONCAT(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,im.Name TestName,  ");
                sb.Append(" IF(plo.Type=2,pmh.TransNo,'')'IPD No.', pmh.type PatientType,'67' Location,'Casualty' Ward,  ");
                sb.Append(" CONCAT((DATE_FORMAT(plo.Date,'%d-%b-%y')),' ',(DATE_FORMAT(plo.Time,'%h:%m:%s %p')))PrescribeDate, ");
                sb.Append(" CONCAT((DATE_FORMAT(plo.Date,'%d-%b-%y')),' ',(DATE_FORMAT(plo.Time,'%h:%m:%s %p')))WithdrawDate, ");
                sb.Append(" IF(plo.IsUrgent=1,'Yes','') `Urgent?` ");
                sb.Append(" FROM patient_labinvestigation_opd plo   ");
                sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=plo.LedgerTransactionNo  ");
                sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID  ");
                sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID  ");
                sb.Append(" INNER JOIN investigation_observationtype io ON io.Investigation_ID=plo.Investigation_ID  ");
                sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=plo.TransactionID  ");
                sb.Append(" INNER JOIN observationtype_master ot ON ot.ObservationType_ID=io.ObservationType_Id  ");
                sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID AND cr.RoleID='11'  ");
                sb.Append(" INNER JOIN center_master cm ON cm.CentreID=plo.sampleTransferCentreID  ");
                sb.Append(" INNER JOIN center_master cm1 ON cm1.CentreID=plo.CentreID  ");
                sb.Append(" LEFT JOIN sample_logistic sl ON sl.Test_ID=plo.Test_ID AND sl.isActive=1   ");
                sb.Append(" WHERE CONCAT(plo.Date,' ',plo.Time) >= '" + Util.GetDateTime(datetimefrom).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
                sb.Append(" AND CONCAT(plo.Date,' ',plo.Time) <= '" + Util.GetDateTime(datetimeto).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
                sb.Append(" AND plo.CentreID = '" + HttpContext.Current.Session["CentreID"] + "'  ");
                sb.Append(" AND plo.Type IN (3) AND plo.IsSampleCollected='N' GROUP BY plo.Test_ID  ");
                sb.Append(" )t ");
                if(Location=="67")
                {
                sb.Append( " where t.location='67' ");
                }
                
                sb.Append(" ORDER BY BarcodeNo ");
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Sample Requisition Report";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "" });
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Record Found" });
            }
     } 


    [WebMethod]
    public static string bindLocation()
    {

        try
        {


            DataTable dt = StockReports.GetDataTable(" SELECT cm.IPDCaseTypeID ID,cm.Name FROM ipd_case_type_master cm WHERE cm.IsActive=1 AND cm.CentreID='" + HttpContext.Current.Session["CentreID"] + "'");

            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else { return "0"; }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }


    }
}