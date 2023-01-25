using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_BloodBank_PatientCrossMatching : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BloodBank.bindBloodGroup(ddlBloodGroup);
			ddlBloodGroup.Items.Insert(0, new ListItem("Select", "0"));
            txtdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            lblSession.Text = Session["CentreID"].ToString();
            ViewState["CenterID"] = Util.GetString(Session["CentreID"].ToString());
        }
        txtdatefrom.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }

    [WebMethod(EnableSession = true)]
    public static string SearchPatient(string PType, string PatientID, string IPDNo, string PName, string BloodGroup, string FromDate, string ToDate, string Sex, string Age, string Year)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT pm.PatientID,pmh.TransactionID,IF(pmh.type='IPD',REPLACE(pmh.TransactionID,'ISHHI',''),'') AS IPDNo,pmh.Type,CONCAT(pm.Title,'',pm.PName)Pname, ");
        sb.Append(" CONCAT(pm.Age,'/',pm.Gender)AgeSex,bg.`BloodTested` BloodGroup,ltd.ItemName ,DATE_FORMAT(lt.date,'%d-%b-%Y')dtEntry,lt.LedgerTransactionNo,ltd.Quantity, ");
        sb.Append(" CONCAT((SELECT NAME FROM ipd_case_type_Master WHERE IPDCaseTypeID=(SELECT IPDCaseTypeID FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID LIMIT 1)),'/', ");
        sb.Append(" (SELECT bed_no FROM room_master WHERE roomid=(SELECT roomid FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID LIMIT 1)))ward,bcd.BloodCollection_Id, ");
        sb.Append(" bg.Grouping_Id,ltd.ItemID,ps.`ComponentName`,IFNULL((SELECT  ComponentID FROM bb_item_component WHERE ItemID=ltd.`ItemID` LIMIT 1),0)ComponentID,ifnull(isr.id,'')ServiceID  FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=ltd.ItemID ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ltd.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append(" INNER JOIN bb_collection_details bcd ON bcd.LedgerTransactionNo=lt.LedgerTransactionNo AND bcd.IsPatient=1 ");
        sb.Append(" INNER JOIN bb_grouping bg ON bg.BloodCollection_Id=bcd.BloodCollection_Id  ");
        sb.Append(" left JOIN bb_patient_screening ps ON ps.`GroupingID`=bg.`Grouping_Id` AND ps.IsActive=1  ");
        sb.Append(" left join ipdservices_request isr on isr.LedgerTnxNo=lt.LedgerTransactionNo ");
        sb.Append(" WHERE ltd.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + " AND ltd.ConfigID =7 AND ltd.IsVerified=1 AND lt.IsCancel=0 AND bg.IsApproved=3 AND ltd.`BloodIssue`=0 ");

        if (PatientID == string.Empty && IPDNo == string.Empty && PName == string.Empty && Age == string.Empty)
        {
            sb.Append(" AND lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
        }

        if (PType != "ALL")
        {
            if (PType == "OPD")
            {
                sb.Append(" AND IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')='OPD' AND pmh.Type='OPD' ");
            }
            else if (PType == "EMG")
            {
                sb.Append(" AND lt.TypeOfTnx IN ('Emergency') AND pmh.Type='EMG' ");
            }
            else
            {
                sb.Append(" AND IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')='IPD' AND pmh.Type='IPD' ");
            }
        }

        if (IPDNo != string.Empty)
        {
           // sb.Append(" AND ltd.Transaction_ID='ISHHI" + IPDNo + "' ");
            sb.Append(" AND pmh.TransNo=" + IPDNo + " AND pmh.Type='IPD' ");
        }

        if (PatientID != string.Empty)
        {
            sb.Append(" AND lt.PatientID= '" + PatientID + "'");
        }
        if (PName != string.Empty)
        {
            sb.Append(" AND pm.Pname like '" + PName + "%' ");
        }
        if (BloodGroup.Trim() != "Select")
        {
            sb.Append(" AND pm.BloodGroup= '" + BloodGroup + "' ");
        }
        if (Age != string.Empty)
        {
            string age1 = Age + " " + Year;
            sb.Append(" AND pm.`Age`='" + age1 + "' ");
        }
        if (Sex != "All")
        {
            sb.Append(" AND pm.`Gender`='" + Sex + "' ");
        }


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    public class ScreenDetails
    {
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
        public string Component { get; set; }
        public string BG { get; set; }
        public string ItemID { get; set; }
        public string LTNo { get; set; }
        public string BCID { get; set; }
        public string GroupID { get; set; }
        public string CellI { get; set; }
        public string CellII { get; set; }
        public string CellIII { get; set; }
        public string Result { get; set; }
        public string Remarks { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public static string SaveScreening(object screendetail)
    {
        List<ScreenDetails> data = new JavaScriptSerializer().ConvertToType<List<ScreenDetails>>(screendetail);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        var result = string.Empty;

        using (MySqlTransaction tr = con.BeginTransaction())
        {
            try
            {
                string query = "INSERT INTO bb_patient_screening (BloodCollectionID,GroupingID,PatientID,TransactionID,LedgerTransactionNo,ItemID,ComponentID,ComponentName,BloodGroup,Cell1,Cell2,Cell3,Result,Remarks,EntryBy,CentreID) values(@BloodCollectionID,@GroupingID,@PatientID,@TransactionID,@LedgerTransactionNo,@ItemID,@ComponentID,@ComponentName,@BloodGroup,@Cell1,@Cell2,@Cell3,@Result,@Remarks,@EntryBy,@CentreID)";
                using (MySqlCommand cmd = new MySqlCommand(query, con, tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@BloodCollectionID", data[0].BCID);
                    cmd.Parameters.AddWithValue("@GroupingID", data[0].GroupID);
                    cmd.Parameters.AddWithValue("@PatientID", data[0].PatientID);
                    cmd.Parameters.AddWithValue("@TransactionID", data[0].TransactionID);
                    cmd.Parameters.AddWithValue("@LedgerTransactionNo", data[0].LTNo);
                    cmd.Parameters.AddWithValue("@ItemID", data[0].ItemID);
                    cmd.Parameters.AddWithValue("@ComponentID", 1);
                    cmd.Parameters.AddWithValue("@ComponentName", data[0].Component);
                    cmd.Parameters.AddWithValue("@BloodGroup", data[0].BG);
                    cmd.Parameters.AddWithValue("@Cell1", data[0].CellI);
                    cmd.Parameters.AddWithValue("@Cell2", data[0].CellII);
                    cmd.Parameters.AddWithValue("@Cell3", data[0].CellIII);
                    cmd.Parameters.AddWithValue("@Result", data[0].Result);
                    cmd.Parameters.AddWithValue("@Remarks", data[0].Remarks);
                    cmd.Parameters.AddWithValue("@EntryBy", HttpContext.Current.Session["ID"].ToString());
                    cmd.Parameters.AddWithValue("@CentreID", HttpContext.Current.Session["CentreID"].ToString());

                    cmd.ExecuteNonQuery();
                    tr.Commit();
                    cmd.Parameters.Clear();
                    result = "1";
                }
            }
            catch (Exception ex)
            {
                tr.Rollback();
                result = "0";
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                con.Close();
                con.Dispose();
                tr.Dispose();
            }
        }

        return result;
    }

    private void clear()
    {
        txtName.Text = "";
        txtIPDNo.Text = string.Empty;
        txtPatientId.Text = string.Empty;
    }

    [WebMethod(EnableSession = true)]
    public static string BindBag(string bloodgroup, string ComponentID, string ItemId)
    { 
        
        string bg = "";
     

        bg = Util.GetString(StockReports.ExecuteScalar("SELECT GROUP_CONCAT(ToBG) FROM bb_grouping_compatible WHERE FromaBG='" + bloodgroup + "'"));

        string[] lstItem = bg.Split(',');
        string itm = "";
        for (int i = 0; i < lstItem.Length; i++)
        {
            if (itm == "")
            {
                itm = "'" + lstItem[i] + "'";
            }
            else
            {
                itm += ",'" + lstItem[i] + "'";
            }
        }

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Concat(BBTubeNo,'#',BloodGroup)BBTubeNo,ID,ExpiryDate,Stock_Id FROM bb_stock_master sm WHERE ComponentID='" + ComponentID + "' AND BloodGroup IN (" + itm + ") AND sm.InitialCount>sm.ReleaseCount  AND sm.status=1 AND sm.IsDispatch=0 AND sm.IsDiscarded=0 AND sm.IsHold=0 AND DATE(sm.ExpiryDate)>=CURDATE() AND sm.IsActive=1");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod(EnableSession = true)]
    public static string GetExpiryDate(int ID, string Tubeno)
    {
        string date = "";
        string stockID = "";
        int IsExists = 0;
        string patientName = "";

        IsExists = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM bb_blood_crossmatch WHERE BBTubeNo='" + Tubeno + "' AND Compatiblity='Compatible' AND IsActive=1"));
        patientName = Util.GetString(StockReports.ExecuteScalar("SELECT CONCAT(pm.`Title`,' ',pm.`PName`) PName FROM bb_blood_crossmatch bbc INNER JOIN patient_master pm ON pm.`PatientID`=bbc.PatientID WHERE bbc.BBTubeNo='" + Tubeno + "' AND Compatiblity='Compatible' AND IsActive=1 GROUP BY pm.`PatientID`"));
        date = Util.GetString(StockReports.ExecuteScalar("SELECT DATE_Format(ExpiryDate,'%d-%b-%Y')ExpiryDate FROM bb_stock_master WHERE ID='" + ID + "'"));
        stockID = Util.GetString(StockReports.ExecuteScalar("SELECT Stock_Id FROM bb_stock_master WHERE ID='" + ID + "'"));


        return Newtonsoft.Json.JsonConvert.SerializeObject(new { date, stockID, IsExists });
    }

    //[WebMethod(EnableSession = true)]
    //public static string SaveCrossBlood(string ItemId, string ComponentID, string ComponentName, string IPDNO, string PatientID, string StockID, string TubeNum, string LedgerTnxNo, string Compatible)
    //{
    //    string result = "";
    //    MySqlConnection con = new MySqlConnection();
    //    con = Util.GetMySqlCon();
    //    con.Open();
    //    string query = "INSERT INTO bb_blood_crossmatch(ItemID, ComponentID, ComponentName, IPD_No, PatientID, BloodStockID, BBTubeNo, LedgerTnxNo, Compatiblity, Entryby, EntryDate) VALUES('" + ItemId + "','" + ComponentID + "','" + ComponentName + "','" + IPDNO + "','" + PatientID + "','" + StockID + "','" + TubeNum + "','" + LedgerTnxNo + "','" + Compatible + "','" + HttpContext.Current.Session["ID"].ToString() + "',CURDATE())";

    //    try
    //    {
    //        using (MySqlCommand cmd = new MySqlCommand(query, con))
    //        {
    //            cmd.CommandType = CommandType.Text;
    //            cmd.ExecuteNonQuery();
    //            result = "OK";
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);
    //        result = "NO";
    //    }

    //    return Newtonsoft.Json.JsonConvert.SerializeObject(result);
    //}

    [WebMethod(EnableSession = true)]
    public static string SaveCrossBlood(string ItemId, string ComponentID, string ComponentName, string IPDNO, string PatientID, string StockID, string TubeNum, string LedgerTnxNo, string Compatible, string ServiceID)
    {
        string result = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(System.Data.IsolationLevel.Serializable);
        try
        {
            //string str = "INSERT INTO bb_blood_crossmatch(ItemID, ComponentID, ComponentName, IPD_No, PatientID, BloodStockID, BBTubeNo, LedgerTnxNo, Compatiblity, Entryby, EntryDate) VALUES('" + ItemId + "','" + ComponentID + "','" + ComponentName + "','" + IPDNO + "','" + PatientID + "','" + StockID + "','" + TubeNum + "','" + LedgerTnxNo + "','" + Compatible + "','" + HttpContext.Current.Session["ID"].ToString() + "',CURDATE())";
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO bb_blood_crossmatch(ItemID, ComponentID, ComponentName, IPD_No, PatientID, BloodStockID, BBTubeNo, LedgerTnxNo, Compatiblity, Entryby, EntryDate,CenterID,ServiceRequestID) ");
            sb.Append(" VALUES('" + ItemId + "','" + ComponentID + "','" + ComponentName + "','" + IPDNO + "','" + PatientID + "','" + StockID + "','" + TubeNum + "','" + LedgerTnxNo + "','" + Compatible + "','" + HttpContext.Current.Session["ID"].ToString() + "',CURDATE()," + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ",'"+Util.GetInt(ServiceID)+"') ");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
            tnx.Commit();
            result = "OK";
        }
        catch (Exception ex)
        {
            ClassLog lg = new ClassLog();
            lg.errLog(ex);
            tnx.Rollback();
            result = "NO";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(result);
    }

    [WebMethod(EnableSession = true)]
    public static string CheckPatientValidTime(string LedgerTransactionNo, string ItemID, string PatientID)
    {
        var str = "SELECT IF(TIMESTAMPDIFF(HOUR,bg.`EntryDate`,NOW())<48,0,1)isValid,COUNT(ID) isExist FROM bb_blood_crossmatch bg WHERE ItemID='" + ItemID + "' AND ledgerTnxNo='" + LedgerTransactionNo + "' AND PatientID='" + PatientID + "' AND IsActive=1";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateBloodCrossmatch(string ItemId, string ComponentID, string Compatiblity, string PatientID, string StockID, string BagNumber)
    {
        string result = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(System.Data.IsolationLevel.Serializable);

        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE bb_blood_crossmatch SET Compatiblity='" + Compatiblity + "',BBTubeNo='" + BagNumber + "',BloodStockID='" + StockID + "',UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=CURDATE() WHERE ComponentID='" + ComponentID + "' AND PatientID='" + PatientID + "' AND ItemID='" + ItemId + "' AND IsActive=1");
            tnx.Commit();
            result = "OK";
            return Newtonsoft.Json.JsonConvert.SerializeObject(result);
        }
        catch(Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            result = "NO";
            return Newtonsoft.Json.JsonConvert.SerializeObject(result);
        }
    }
}