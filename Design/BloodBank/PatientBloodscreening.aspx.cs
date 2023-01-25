using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Web;

public partial class Design_BloodBank_PatientBloodScreening : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
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
    public static string CheckPatientValidTime(string TransactionID, string ItemID, string GroupingID) 
    {
        var str = "SELECT COUNT(id)isExist,DATE_FORMAT(bcp.EntryDateTime,'%d-%b-%y %h:%m %p')EntryDateTime,IF(TIMESTAMPDIFF(HOUR,bcp.EntryDateTime,NOW())<72,1,0)isValid,bcp.Cell1,bcp.Cell2,bcp.Cell3,bcp.Remarks,bcp.Result FROM bb_patient_screening bcp WHERE bcp.GroupingID='" + GroupingID + "' and isActive=1";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SearchPatient(string PType, string PatientID, string IPDNo, string PName, string BloodGroup, string FromDate, string ToDate, string IsScreen)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pm.PatientID,pmh.TransactionID,IF(pmh.type='IPD',REPLACE(pmh.TransactionID,'ISHHI',''),'') AS IPDNo,pmh.Type,CONCAT(pm.Title,'',pm.PName)Pname,CONCAT(pm.Age,pm.Gender)AgeSex, ");
        sb.Append(" pm.BloodGroup,ltd.ItemName ,DATE_FORMAT(lt.date,'%d-%b-%Y')dtEntry,lt.LedgerTransactionNo,ltd.Quantity, ");
        sb.Append(" CONCAT((SELECT NAME FROM ipd_case_type_Master WHERE IPDCaseTypeID=(SELECT IPDCaseTypeID FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID LIMIT 1)),'/', ");
        sb.Append(" (SELECT bed_no FROM room_master WHERE roomid=(SELECT roomid FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID LIMIT 1)))ward, ");
        sb.Append(" bcd.BloodCollection_Id,bg.Grouping_Id,ltd.ItemID,IF(bps.GroupingID IS NULL,0,1)isScreening,bps.ID ");
        sb.Append(" FROM f_ledgertransaction lt  ");
        sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=ltd.ItemID ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ltd.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append(" INNER JOIN bb_collection_details bcd ON bcd.LedgerTransactionNo=lt.LedgerTransactionNo AND bcd.IsPatient=1 ");
        sb.Append(" INNER JOIN bb_grouping bg ON bg.BloodCollection_Id=bcd.BloodCollection_Id ");
        sb.Append(" LEFT JOIN bb_Patient_Screening bps ON bps.GroupingID=bg.Grouping_Id and bps.IsActive=1 ");
        sb.Append(" WHERE ltd.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + " AND ltd.ConfigID =7 AND ltd.IsVerified=1 AND lt.IsCancel=0 and bg.IsApproved=3 ");
        if (PatientID == string.Empty && IPDNo == string.Empty && PName == string.Empty)
            sb.Append(" and lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
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
            //sb.Append(" AND ltd.TransactionID='ISHHI" + IPDNo + "' ");
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
        sb.Append(" and IF(" + IsScreen + "=0,bps.GroupingID IS NULL,bps.GroupingID IS NOT NULL) ");

        sb.Append(" GROUP BY lt.`LedgerTransactionNo` ");

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
        public string ScreenID { get; set; }
    }
    [WebMethod(EnableSession=true)]
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
                string query = "INSERT INTO bb_patient_screening (BloodCollectionID,GroupingID,PatientID,TransactionID,LedgerTransactionNo,ItemID,ComponentID,ComponentName,BloodGroup,Cell1,Cell2,Cell3,Result,Remarks,EntryBy,CentreID,EntryDateTime) values(@BloodCollectionID,@GroupingID,@PatientID,@TransactionID,@LedgerTransactionNo,@ItemID,@ComponentID,@ComponentName,@BloodGroup,@Cell1,@Cell2,@Cell3,@Result,@Remarks,@EntryBy,@CentreID,@EntryDateTime)";
                using (MySqlCommand cmd = new MySqlCommand(query, con, tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@BloodCollectionID", data[0].BCID);
                    cmd.Parameters.AddWithValue("@GroupingID", data[0].GroupID);
                    cmd.Parameters.AddWithValue("@PatientID", data[0].PatientID);
                    cmd.Parameters.AddWithValue("@TransactionID", Util.GetInt(data[0].TransactionID));
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
                    cmd.Parameters.AddWithValue("@EntryDateTime", DateTime.Now);
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
            finally {
                con.Close();
                con.Dispose();
                tr.Dispose();
            }
        }

        return result;
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateScreening(object screendetail)
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
                string UpdateQwery = "Update bb_patient_screening set isActive=0 where ID=" + data[0].ScreenID ;
                MySqlHelper.ExecuteNonQuery(tr, CommandType.Text, UpdateQwery);

                DataTable dt = StockReports.GetDataTable("SELECT b.EntryBy,b.EntryDateTime FROM bb_patient_screening b WHERE b.ID=" + data[0].ScreenID);



                string query = "INSERT INTO bb_patient_screening (BloodCollectionID,GroupingID,PatientID,TransactionID,LedgerTransactionNo,ItemID,ComponentID,ComponentName,BloodGroup,Cell1,Cell2,Cell3,Result,Remarks,EntryBy,EntryDateTime,CentreID,UpdateBy) values(@BloodCollectionID,@GroupingID,@PatientID,@TransactionID,@LedgerTransactionNo,@ItemID,@ComponentID,@ComponentName,@BloodGroup,@Cell1,@Cell2,@Cell3,@Result,@Remarks,@EntryBy,@EntryDateTime,@CentreID,@UpdateBy)";
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
                    cmd.Parameters.AddWithValue("@EntryBy", dt.Rows[0]["EntryBy"].ToString());
                    cmd.Parameters.AddWithValue("@EntryDateTime", Util.GetDateTime(dt.Rows[0]["EntryDateTime"]).ToString("yyyy-MM-dd HH:mm:ss"));
                    cmd.Parameters.AddWithValue("@CentreID", HttpContext.Current.Session["CentreID"].ToString());
                    cmd.Parameters.AddWithValue("@UpdateBy", HttpContext.Current.Session["ID"].ToString());
                    
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

   

}