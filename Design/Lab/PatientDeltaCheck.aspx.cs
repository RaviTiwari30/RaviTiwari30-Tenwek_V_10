using MySql.Data.MySqlClient;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_PatientDeltaCheck : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            calEntryDate1.EndDate = DateTime.Now;

            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            BindDepartment();
        }
        FrmDate.Attributes.Add("readonly", "true");
        ToDate.Attributes.Add("readonly", "true");
    }
    //protected void btnSearch_Click(object sender, EventArgs e)
    //{
    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "GetDateDetails('" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "');", true);
    //}

    private void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name NAME,ot.ObservationType_ID SubCategoryID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        sb.Append(" order by ot.Name");
        ddlDepartment.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataTextField = "NAME";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("All Department", ""));
    }

    [WebMethod]
    public static string GetPatientID(string IPDNo)
    {
        StringBuilder sb = new StringBuilder();
        string IPNo = "ISHHI" + IPDNo;
        sb.Append("SELECT * FROM `f_ipdadjustment` WHERE TransactionID='" + IPNo + "' LIMIT 1");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetPatientIDByEMGNum(string EMG)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT * FROM emergency_patient_details WHERE EmergencyNo='" + EMG + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetPharmacyIPDQty(DateTime Date, string ItemID, string TransactionID,int ID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ROUND(SUM(Qty),0)Qty,DATE_FORMAT(DATE,'%d-%b-%y')DATE,ItemID,ItemName,Dose FROM cpoe_medication_record WHERE DATE='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND ItemID='" + ItemID + "'");//AND TransactionID='" + TransactionID + "' AND ID=" + ID + "
       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetPharmacyEMGQty(DateTime Date, string ItemID) 
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT SUBSTRING(NoTimesDay,1,2)Qty FROM patient_medicine WHERE DATE='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND Medicine_ID='" + ItemID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetPharmacyItemName(DateTime FromDate, DateTime ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,DATE_FORMAT(DATE,'%d-%b-%y')DATE,TransactionID,ItemID,ItemName,Dose,ROUND(SUM(Qty),0)Qty FROM  cpoe_medication_record ");
        sb.Append(" WHERE  DATE>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY ItemID ORDER BY DATE_FORMAT(DATE,'%d-%b-%y') ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetPharmacyEMGDateDetails(DateTime FromDate, DateTime ToDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT IF(NoOfDays='',0,SUBSTRING(NoOfDays, 1, 1))Days,DATE FROM `patient_medicine` WHERE DATE>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY DATE");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            DataTable table = new DataTable();
            DataRow row = table.NewRow();
            int counter1 = 0, counter2 = 0;
            string column = "";
            foreach (DataRow dr in dt.Rows)
            {
                int days = Util.GetInt(dr["Days"]);
                string date = Util.GetString(dr["DATE"]);

            if (days > 0 && days > 1)
            {
                for (int i = 0; i <= days; i++)
                {
                    column = "Date_" + counter1;
                    string coll = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select DATE_FORMAT(DATE_ADD('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "', INTERVAL " + i + " DAY),'%d-%b-%y') AS d"));
                    table.Columns.Add(column, typeof(string));
                    counter1++;
                }
            }
            else if (days == 1)
            {
                column = "Date_" + counter1;
                string coll = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select DATE_FORMAT('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "','%d-%b-%y') AS d"));
                table.Columns.Add(column, typeof(string));
                counter1++;
            }
        }

        int tbaleCount = table.Columns.Count;

        table.Columns.Add("Count", typeof(string));

        foreach (DataRow dr in dt.Rows)
        {
            string date = Util.GetString(dr["Date"]);
            int days = Util.GetInt(dr["Days"]);

            if (days > 0 && days > 1)
            {
                for (int i = 0; i <= days; i++)
                {
                    string col = "Date_" + counter2;
                    string coll = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select DATE_FORMAT(DATE_ADD('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "', INTERVAL " + i + " DAY),'%d-%b-%y') AS d"));
                    //bool exists = table.Select().ToList().Exists(r => r[col].ToString() == coll);
                    row[col] = coll;
                    counter2++;
                }
            }
            else if (days == 1)
            {
                string col = "Date_" + counter2;
                string coll = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select DATE_FORMAT('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "','%d-%b-%y') AS d"));
               // bool exists = table.Select().ToList().Exists(r => r[col].ToString() == coll);
                row[col] = coll;
                counter2++;
            }
        }

        row["Count"] = tbaleCount;

        table.Rows.Add(row);

        Hashtable hTable = new Hashtable();
        ArrayList duplicateList = new ArrayList();

        int ctr = 0;
        string cl = "Date_";

        //foreach (DataColumn dc in table.Columns)
        //{
        //    foreach (DataRow drow in table.Rows)
        //    {
        //        if (hTable.Contains(drow[dc.ColumnName]))
        //            duplicateList.Add(drow);
        //        else
        //            hTable.Add(drow[dc.ColumnName], string.Empty);

        //        ctr++;
        //    }
        //}

        //Removing a list of duplicate items from datatable.
        //foreach (DataRow dRow in duplicateList)
        //table.Rows.Remove(dRow);

        string[] arr = new string[table.Columns.Count];
        int c = 0;
        foreach (DataColumn dc in table.Columns)
        {
            foreach (DataRow drow in table.Rows)
            {
                if (hTable.Contains(drow[dc.ColumnName]))
                    arr[c] = dc.ColumnName;
                else
                    hTable.Add(drow[dc.ColumnName], string.Empty);
            }
            c++;
        }

            for (int j = 0; j < arr.Length; j++)
            {
                string _colname = arr[j];
                if (_colname != null)
                {
                    table.Columns.Remove(_colname);
                }
            }

            return Newtonsoft.Json.JsonConvert.SerializeObject(table);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetPharmacyEMGItemName(DateTime FromDate, DateTime ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT PatientMedicine_ID,Medicine_ID,SUBSTRING(NoOfDays, 1, 1)Days,NoTimesDay, DATE_FORMAT(DATE,'%d-%b-%y')DATE,MedicineName FROM patient_medicine WHERE DATE>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY Medicine_ID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetPharmacyDateDetails(DateTime FromDate, DateTime ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT DATE_FORMAT(DATE,'%d-%b-%y')DATE FROM cpoe_medication_record WHERE  DATE>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ORDER BY DATE_FORMAT(DATE,'%d-%b-%y') ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataTable table = new DataTable();
        DataRow row = table.NewRow();
        int counter1 = 0, counter2 = 0;
        foreach (DataRow dr in dt.Rows)
        {
            string date = Util.GetString(dr["Date"]);
            //table.Columns.Add(date, typeof(string));
            string column = "Date_" + counter1;
            table.Columns.Add(column, typeof(string));
            counter1++;
        }

        int tbaleCount = table.Columns.Count;

        table.Columns.Add("Count", typeof(string));

        foreach (DataRow dr in dt.Rows)
        {
            string date = Util.GetString(dr["Date"]);
            string col = "Date_" + counter2;
            row[col] = date;
            counter2++;
        }

        row["Count"] = tbaleCount;

        table.Rows.Add(row);

        return Newtonsoft.Json.JsonConvert.SerializeObject(table);
    }

    [WebMethod]
    public static string GetDateDetails(DateTime FromDate, DateTime ToDate, string PatientID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(DATE,'%d-%b-%y')DATE FROM patient_labinvestigation_opd WHERE PatientID='" + PatientID + "' AND DATE>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY DATE");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataTable table = new DataTable();
        DataRow row = table.NewRow();
        int counter1 = 0, counter2=0;
        foreach (DataRow dr in dt.Rows)
        {
            string date = Util.GetString(dr["Date"]);
            //table.Columns.Add(date, typeof(string));
            string column = "Date_" + counter1;
            table.Columns.Add(column, typeof(string));
            counter1++;
        }

        int tbaleCount = table.Columns.Count;

        table.Columns.Add("Count", typeof(string));

        foreach (DataRow dr in dt.Rows)
        {
            //foreach (DataColumn dc in table.Columns)
            //{
            //    string date = Util.GetString(dr["Date"]);
            //    string col = Util.GetString(dc.ColumnName.Trim());
            //    if (date == col)
            //    {
            //        row[col] = date;
            //    }
            //}
            string date = Util.GetString(dr["Date"]);
            string col="Date_"+counter2;
            row[col] = date;
            counter2++;
        }

        row["Count"] = tbaleCount;

        table.Rows.Add(row);


        return Newtonsoft.Json.JsonConvert.SerializeObject(table);
    }

    [WebMethod]
    public static string GetAllTest(DateTime fromDate, DateTime ToDate, string PatientID, string Department, string TYPE)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IFNULL(CONCAT(plo.MinValue,'-',plo.MaxValue),'')'Range',im.Name 'InvestigationName',  DATE_FORMAT(pli.Date,'%d-%b-%y')Date,DATE_FORMAT(pli.`ResultEnteredDate`,'%d-%b-%y %h:%i:%s') AS TST_DATE, DATE_FORMAT(pli.`ResultEnteredDate`,'%h:%i:%s')  AS TST_TIME, ");
        sb.Append(" pli.LedgerTransactionNo AS LAB_NO,'' LIS_NO, '' IPD_NO,REPLACE(pli.PatientID,'LSHHI','') OPD_NO, pm.Title PATTITLE,   pm.Pname PATIENT_NAME, ");
        sb.Append("pm.Age AS AGE, REPLACE(otm.Name,' ','') DEPARTMENT,    REPLACE(plo.LabObservationName,' ','') PARAM_NAME,   plo.Value , '' DOCTOR      , ");
        sb.Append(" pli.`ResultEnteredDate` FROM patient_labobservation_opd plo ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd pli ON plo.test_ID=pli.Test_ID AND pli.PatientID='" + PatientID + "' AND pli.Result_Flag=1 ");
        sb.Append(" INNER JOIN investigation_master im ON im.investigation_ID=pli.investigation_id INNER JOIN investigation_observationtype iot ON iot.investigation_ID=im.investigation_ID ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_ID INNER JOIN patient_master pm ON pm.PatientID=pli.PatientID ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=pli.TransactionID ");
        sb.Append(" WHERE pli.DATE>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "'  AND pli.DATE<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        if (Department != "")
        {
            sb.Append(" AND otm.ObservationType_ID='" + Department + "' ");
        }
        if (TYPE != "ALL")
        {
            sb.Append(" AND pmh.Type='" + TYPE + "' ");
        }
        sb.Append(" ORDER BY DATE,DEPARTMENT ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetValue(DateTime Date, string ParamName, string department, string PatientID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT   pli.Date,DATE_FORMAT(pli.`ResultEnteredDate`,'%d-%b-%y %h:%i:%s') AS TST_DATE, DATE_FORMAT(pli.`ResultEnteredDate`,'%h:%i:%s')  AS TST_TIME, ");
        sb.Append(" pli.LedgerTransactionNo AS LAB_NO,'' LIS_NO, '' IPD_NO,REPLACE(pli.PatientID,'LSHHI','') OPD_NO, pm.Title PATTITLE,   pm.Pname PATIENT_NAME, ");
        sb.Append("pm.Age AS AGE, REPLACE(otm.Name,' ','') DEPARTMENT,    REPLACE(plo.LabObservationName,' ','') PARAM_NAME,   plo.Value , '' DOCTOR      , ");
        sb.Append(" pli.`ResultEnteredDate` FROM patient_labobservation_opd plo ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd pli ON plo.test_ID=pli.Test_ID AND pli.PatientID='" + PatientID + "' AND pli.Result_Flag=1 ");
        sb.Append(" INNER JOIN investigation_master im ON im.investigation_ID=pli.investigation_id INNER JOIN investigation_observationtype iot ON iot.investigation_ID=im.investigation_ID ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_ID INNER JOIN patient_master pm ON pm.PatientID=pli.PatientID ");
        sb.Append("  WHERE DATE='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND REPLACE(plo.LabObservationName,' ','')='" + ParamName + "' AND REPLACE(otm.Name,' ','')='" + department + "' ");
        sb.Append(" ORDER BY DEPARTMENT ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

}