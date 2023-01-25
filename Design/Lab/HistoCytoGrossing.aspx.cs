using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_HistoCytoGrossing : System.Web.UI.Page
{
    public string ApprovalId = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.AddDays(-5).ToString("dd-MMM-yyyy");
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");

             ApprovalId = StockReports.ExecuteScalar("SELECT max(Approval)  FROM f_approval_labemployee WHERE RoleID='" +  Session["RoleID"].ToString() + "' AND IF(TechnicalId='',EmployeeID,TechnicalId)='" + Session["ID"].ToString() + "'");
            if (ApprovalId == "4")
            {
                binddoctor();
                ddltype.Enabled = true;
            }
            else
            {
                ddltype.Enabled = false;
                Ckeditorcontrol1.ReadOnly = true;
                ListItem selectedListItem = ddltype.Items.FindByText("Slided");

                if (selectedListItem != null)
                {
                    selectedListItem.Selected = true;
                }
            }
            binddept();
        }
    }

    void binddoctor()
    {
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT DISTINCT fl.employeeid,em.Name FROM f_login fl ");
        sbQuery.Append(" INNER JOIN employee_master em ON em.EmployeeID=fl.EmployeeID ");
        sbQuery.Append(" INNER JOIN f_approval_labemployee fa ON fa.EmployeeID=fl.EmployeeID AND fa.RoleID=11 ");
        sbQuery.Append(" and  fa.TechnicalId='" + Session["ID"].ToString() + "' ");
        sbQuery.Append("  WHERE centreid=" + Session["CentreID"].ToString() + "  ");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        ddldoctor.DataSource = dt;
        ddldoctor.DataTextField = "Name";
        ddldoctor.DataValueField = "employeeid";
        ddldoctor.DataBind();
        ListItem selectedListItem = ddldoctor.Items.FindByValue(Session["ID"].ToString());
        if (selectedListItem != null)
        {
            selectedListItem.Selected = true;
        }
    }

    void binddept()
    {
        string histoid = string.Empty;
        int len = Resources.Resource.HistoCytoSubcategoryID.Split(',').Length;
        for (int i = 0; i < len; i++)
        {
            if (histoid == string.Empty)
                histoid = "'" + Resources.Resource.HistoCytoSubcategoryID.Split(',')[i] + "'";
            else
                histoid += ",'" + Resources.Resource.HistoCytoSubcategoryID.Split(',')[i] + "'";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        sb.Append(" WHERE ot.Description IN (" + histoid + ") ");
        sb.Append(" order by ot.Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddldepartment.DataSource = dt;
            ddldepartment.DataTextField = "Name";
            ddldepartment.DataValueField = "ObservationType_ID";
            ddldepartment.DataBind();
            ddldepartment.Items.Insert(0, new ListItem("", "0"));
        }
        else
            ddldepartment.Items.Clear();
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(List<string> searchdata)
    {
        try
        {
            string checkSession = HttpContext.Current.Session["LoginName"].ToString();
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT ifnull((SELECT CONCAT(Reslide,'#',IFNULL(ReslideOption,'')) FROM patient_labhisto_slides WHERE testid=plo.Test_ID and Reslide=1 limit 1),'0#') isreslide, ot.ObservationType_ID subcategoryid,plo.patientid as patient_id, plo.slidenumber, plo.Test_ID,plo.LedgerTransactionNo,plo.BarcodeNo,pm.PName, ");
        sbQuery.Append(" case when HistoCytoStatus='Grossed' then 'pink' when  HistoCytoStatus='Slided' then 'lightgreen' when  HistoCytoStatus='SlideComplete' then '#00FFFF'  else 'lightyellow' end rowcolor,");
        sbQuery.Append("  IF(HistoCytoSampleDetail<>'', ");
        sbQuery.Append(" CONCAT(");
        sbQuery.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), '^', -1)<>'0',CONCAT('Container:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), "); sbQuery.Append("'^', -1)),''),");
        sbQuery.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2), '^', -1)<>'0',CONCAT(' , Slides:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2),"); sbQuery.Append("'^', -1)),''),");
        sbQuery.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3), '^', -1)<>'0',CONCAT(', Blocks:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3),"); sbQuery.Append(" '^', -1)),''))");
        sbQuery.Append(" ,'') SampleInfo, ");
        sbQuery.Append("inv.Name,plo.sampletype AS SampleTypeName,plo.CurrentAge AS Age,pm.Gender,  ");
        sbQuery.Append(" DATE_FORMAT(SampleCollectionDate,'%d-%b-%y %h:%i %p') SampleCollectionDate, ");
        sbQuery.Append("DATE_FORMAT(SampleReceiveDate,'%d-%b-%y %h:%i %p') SampleReceiveDate, ");
        sbQuery.Append(" ifnull(DATE_FORMAT(SampleReceiveDate,'%d-%b-%y %h:%i %p'),'') HistoStatusDate, ");
        sbQuery.Append(" ifnull(HistoCytoStatus,'') HistoCytoStatus,if(plo.result_flag='1','saved','notdone') reportstatus");
        sbQuery.Append(" FROM patient_labinvestigation_opd plo  INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID ");
        sbQuery.Append("INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo ");
        sbQuery.Append("INNER JOIN investigation_master inv ON inv.Investigation_Id=plo.Investigation_ID AND inv.reporttype=7 ");
        sbQuery.Append(" INNER JOIN investigation_observationtype io ON inv.Investigation_Id = io.Investigation_ID ");
        sbQuery.Append(" INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sbQuery.Append(" AND plo.IsSampleCollected='Y'  ");
        sbQuery.Append(" where plo.sampleTransferCentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        sbQuery.Append(" and  plo.SampleReceiveDate>='" + Util.GetDateTime(searchdata[1]).ToString("yyyy-MM-dd") + " 00:00:00'");
        sbQuery.Append(" and plo.SampleReceiveDate<='" + Util.GetDateTime(searchdata[2]).ToString("yyyy-MM-dd") + " 23:59:59'");
        //if (Util.GetString(searchdata[7]) != "")
        //{
        //    sbQuery.Append(" and plo.HistoCytoPerformingDoctor='" + searchdata[7] + "' ");
        //}
        if (searchdata[3] != "")
        {
            sbQuery.Append(" and plo.Patient_ID='" + searchdata[3] + "'");
        }

        if (searchdata[4] != "")
        {
            sbQuery.Append(" and plo.barcodeno='" + searchdata[4] + "'");
        }
        if (searchdata[5] != "")
        {
            sbQuery.Append(" and plo.slidenumber='" + searchdata[5] + "'");
        }
        if (searchdata[6] != "0")
        {
            sbQuery.Append(" and ot.ObservationType_ID='" + searchdata[6] + "'");
        }
        if (searchdata[0] != "ALL")
        {
            sbQuery.Append(" and HistoCytoStatus ='" + searchdata[0] + "' ");
        }

        sbQuery.Append(" order by plo.SampleReceiveDate");
        //System.IO.File.WriteAllText(@"E:\ankur.txt", sbQuery.ToString());
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savegrossdata(List<string[]> mydataadj)
    {
        string test_id = StockReports.ExecuteScalar("select testid from patient_labhisto_gross where testid='" + Util.GetString(mydataadj[0][0]) + "'");
      
        StockReports.ExecuteDML("delete from patient_labhisto_gross where testid='" + Util.GetString(mydataadj[0][0]) + "'");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string[] ss in mydataadj)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labhisto_gross ");
                sb.Append("(testid,labno,blockid,blockcomment,grosscomment,entrydate,entrybyname,entryby)");
                sb.Append("VALUES('" + ss[0].ToString() + "','" + ss[1].ToString() + "','" + ss[2].ToString() + "','" + ss[3].ToString() + "','" + ss[4].ToString() + "'");
                sb.Append(",NOW(),'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }
            if (test_id == "")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set HistoCytoStatus='Grossed' where test_id='" + Util.GetString(mydataadj[0][0]) + "'");
            }
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb1.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb1.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Grossing-Block Creation Biopsy No: ',slidenumber),'" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "','" + All_LoadData.IpAddress() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "', ");
            sb1.Append(" '" + HttpContext.Current.Session["RoleID"].ToString() + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + Util.GetString(mydataadj[0][0]) + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();

            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();

            throw (ex);
        }


    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdetailblock(string testid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(labno,' / ',blockid) value,blockid FROM patient_labhisto_gross where testid='" + testid + "' order by testid");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savedataslide(List<string[]> mydataadj)
    {
        string test_id = StockReports.ExecuteScalar("select testid from patient_labhisto_slides where testid='" + Util.GetString(mydataadj[0][0]) + "'");
        StockReports.ExecuteDML("delete from patient_labhisto_slides where testid='" + Util.GetString(mydataadj[0][0]) + "' and blockid='" + Util.GetString(mydataadj[0][2]) + "'");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string[] ss in mydataadj)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labhisto_slides ");
                sb.Append("(testid,labno,blockid,slideno,slidecomment,entrydate,entrybyname,entryby)");
                sb.Append("VALUES('" + ss[0].ToString() + "','" + ss[1].ToString() + "','" + ss[2].ToString() + "','" + ss[3].ToString() + "','" + ss[4].ToString() + "'");
                sb.Append(",NOW(),'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }
            if (test_id == "")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set HistoCytoStatus='Slided' where test_id='" + Util.GetString(mydataadj[0][0]) + "'");
            }
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb1.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb1.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Grossing-Slide Creation Biopsy No: ',slidenumber),'" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "','" + All_LoadData.IpAddress() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "', ");
            sb1.Append(" '" + HttpContext.Current.Session["RoleID"].ToString() + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + Util.GetString(mydataadj[0][0]) + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();

            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();

            throw (ex);
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getgrossdetail(string testid)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT testid,labno,blockid,blockcomment,grosscomment FROM patient_labhisto_gross WHERE testid='" + testid + "'");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdetaildatablock(string testid, string blockid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select reslide,reslideoption, testid,labno,blockid,slideno,slidecomment from patient_labhisto_slides where testid='" + testid + "' and blockid='" + blockid + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savecompletedata(List<string[]> mydataadj, List<string[]> mydataadj1)
    {   
        StockReports.ExecuteDML("delete from patient_labhisto_gross where testid='" + Util.GetString(mydataadj[0][0]) + "'");
        StockReports.ExecuteDML("delete from patient_labhisto_slides where testid='" + Util.GetString(mydataadj1[0][0]) + "' and blockid='" + Util.GetString(mydataadj1[0][2]) + "'");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string[] ss in mydataadj)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labhisto_gross ");
                sb.Append("(testid,labno,blockid,blockcomment,grosscomment,entrydate,entrybyname,entryby)");
                sb.Append("VALUES('" + ss[0].ToString() + "','" + ss[1].ToString() + "','" + ss[2].ToString() + "','" + ss[3].ToString() + "','" + ss[4].ToString() + "'");
                sb.Append(",NOW(),'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }
            foreach (string[] ss in mydataadj1)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labhisto_slides ");
                sb.Append("(testid,labno,blockid,slideno,slidecomment,entrydate,entrybyname,entryby)");
                sb.Append("VALUES('" + ss[0].ToString() + "','" + ss[1].ToString() + "','" + ss[2].ToString() + "','" + ss[3].ToString() + "','" + ss[4].ToString() + "'");
                sb.Append(",NOW(),'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set HistoCytoStatus='Slided' where test_id='" + Util.GetString(mydataadj1[0][0]) + "'");

            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();

            throw (ex);
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string markcomplete(string testid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set HistoCytoStatus='SlideComplete' where test_id='" + testid + "'");

            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb1.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb1.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Block/Slide Created Biopsy No: ',slidenumber),'" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "','" + All_LoadData.IpAddress() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "', ");
            sb1.Append(" '" + HttpContext.Current.Session["RoleID"].ToString() + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + testid + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());

            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();

            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();

            throw (ex);
        }
    }

}