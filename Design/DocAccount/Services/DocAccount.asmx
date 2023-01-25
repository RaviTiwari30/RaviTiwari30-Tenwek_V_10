<%@ WebService Language="C#" Class="DocAccount" %>

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
public class DocAccount : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindShare(string Doctor, string Category)
    {
        DataTable dt = new DataTable();

        //if (Doctor.ToString() != "ALL")
        //    dt = StockReports.GetDataTable("Select ifnull(dds.shareCalculationOn,1)shareCalculationOn,sub.subCategoryID,sub.Name,IFNULL(dds.percentage,0)percentage,con.ConfigID,IFNULL(dds.CreditPercentage,0)CreditPercentage ,IFNULL(dds.`IPDCashPercentage`,0)IPDCashPercentage,IFNULL(dds.`IPDCreditPercentage`,0)IPDCreditPercentage from  f_subcategorymaster sub " +
        //        //  " INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID LEFT JOIN da_doctorshare dds on dds.subCategoryID=sub.subCategoryID AND dds.IsActive=1  AND DoctorID='" + Doctor + "' where sub.CategoryID='" + Category + "' AND sub.Active=1 GROUP BY sub.subCategoryID Order by sub.Name ");
        //   " INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID INNER JOIN f_itemmaster im ON im.`SubCategoryID`=sub.`SubCategoryID` LEFT JOIN da_doctorshare dds ON im.`ItemID`=dds.`ItemID` AND dds.IsActive=1 AND DoctorID='" + Doctor + "' and dds.TypeId=1 where sub.CategoryID='" + Category + "' AND sub.Active=1 GROUP BY sub.subCategoryID Order by sub.Name ");
        //else
        //    dt = StockReports.GetDataTable("Select ifnull(das.shareCalculationOn,1)shareCalculationOn,sub.subCategoryID,sub.Name,IFNULL(das.percentage,0)percentage,con.ConfigID,IFNULL(das.CreditPercentage,0)CreditPercentage,IFNULL(das.`IPDCashPercentage`,0)IPDCashPercentage,IFNULL(das.`IPDCreditPercentage`,0)IPDCreditPercentage from  f_subcategorymaster sub " +
        //        //  " INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID LEFT JOIN da_share das on das.subCategoryID=sub.subCategoryID AND das.IsActive=1 where sub.CategoryID='" + Category + "' AND sub.Active=1 GROUP BY sub.subCategoryID Order by sub.Name ");
        //        " INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID INNER JOIN f_itemmaster im ON im.`SubCategoryID`=sub.`SubCategoryID` LEFT JOIN da_doctorshare das ON im.`ItemID`=das.`ItemID` AND das.IsActive=1  and das.TypeId=1 where sub.CategoryID='" + Category + "' AND sub.Active=1 GROUP BY sub.subCategoryID Order by sub.Name ");


        if (Doctor.ToString() != "ALL")
            dt = StockReports.GetDataTable("Select ifnull(dds.shareCalculationOn,1)shareCalculationOn,sub.subCategoryID,sub.Name,IFNULL(IF(dds.shareSetOn=0,dds.OPDAmount,dds.percentage),0)percentage,con.ConfigID,IFNULL(IF(dds.shareSetOn=0,dds.IPDAmount,dds.CreditPercentage),0)CreditPercentage,IFNULL(dds.shareSetOn,1)shareSetOn,IFNULL(dds.`IPDCashPercentage`,0)IPDCashPercentage,IFNULL(dds.`IPDCreditPercentage`,0)IPDCreditPercentage from  f_subcategorymaster sub " +
                //  " INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID LEFT JOIN da_doctorshare dds on dds.subCategoryID=sub.subCategoryID AND dds.IsActive=1  AND DoctorID='" + Doctor + "' where sub.CategoryID='" + Category + "' AND sub.Active=1 GROUP BY sub.subCategoryID Order by sub.Name ");
           " INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID LEFT JOIN da_doctorshare dds ON dds.`SubCategoryID`=sub.`SubCategoryID` AND dds.IsActive=1 AND DoctorID='" + Doctor + "' and dds.TypeId=1 AND dds.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' where sub.CategoryID='" + Category + "'  AND sub.Active=1 GROUP BY sub.subCategoryID Order by sub.Name ");
        else
            dt = StockReports.GetDataTable("Select ifnull(das.shareCalculationOn,1)shareCalculationOn,sub.subCategoryID,sub.Name,IFNULL(IF(das.shareSetOn=0,das.OPDAmount,das.percentage),0)percentage,con.ConfigID,IFNULL(IF(das.shareSetOn=0,das.IPDAmount,das.CreditPercentage),0)CreditPercentage,IFNULL(das.shareSetOn,1)shareSetOn,IFNULL(das.`IPDCashPercentage`,0)IPDCashPercentage,IFNULL(das.`IPDCreditPercentage`,0)IPDCreditPercentage from  f_subcategorymaster sub " +
                //  " INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID LEFT JOIN da_share das on das.subCategoryID=sub.subCategoryID AND das.IsActive=1 where sub.CategoryID='" + Category + "' AND sub.Active=1 GROUP BY sub.subCategoryID Order by sub.Name ");
                " INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID LEFT JOIN da_doctorshare das ON das.`SubCategoryID`=sub.`SubCategoryID` AND das.IsActive=1  and das.TypeId=1 AND dds.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' where sub.CategoryID='" + Category + "' AND sub.Active=1 GROUP BY sub.subCategoryID Order by sub.Name ");


        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveMasterDocShare(object item, string DoctorID, string CategoryID)
    {
        List<shareItemWie> dataItem = new JavaScriptSerializer().ConvertToType<List<shareItemWie>>(item);

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            if (DoctorID != "ALL")
            {
                //int exit = Util.GetInt(StockReports.ExecuteScalar(" Select count(*) from da_DoctorShare where CategoryID='" + CategoryID + "' AND DoctorID='" + DoctorID + "' "));
                //if (exit > 0)
                //{
                //    string str = "UPDATE da_DoctorShare set IsActive=0,DeactivatedBy='" + Session["ID"].ToString() + "',DeactivateDate=now() where CategoryID='" + CategoryID + "' AND DoctorID='" + DoctorID + "'  ";
                //    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                //}

                string str = "UPDATE da_DoctorShare set IsActive=0,DeactivatedBy='" + Session["ID"].ToString() + "',DeactivateDate=now() where CategoryID='" + CategoryID + "' AND DoctorID='" + DoctorID + "' and TypeId=1 and IsActive=1 and CentreID= " + HttpContext.Current.Session["CentreID"].ToString();
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);

                for (int i = 0; i < dataItem.Count; i++)
                {
                    StringBuilder sb = new StringBuilder();

                    if (dataItem[i].ShareIn == 0)
                    {

                        dataItem[i].Amount = dataItem[i].Percentage;
                        dataItem[i].CreditAmount = dataItem[i].CreditAmount;
                        dataItem[i].Percentage = 0;
                        dataItem[i].CreditAmount = 0;
                    }


                    sb.Append(" Insert into da_DoctorShare(TypeId,CategoryID,SubCategoryID,DoctorID,Percentage,CreatedBy,CreditPercentage,IPDCashPercentage,IPDCreditPercentage,shareCalculationOn,CentreID,OPDAmount,IPDAmount,shareSetOn) ");
                    sb.Append(" VALUES(1,'" + CategoryID + "','" + Util.GetString(dataItem[i].SubCategoryID) + "','" + DoctorID + "', ");
                    sb.Append(" '" + Util.GetDecimal(dataItem[i].Percentage) + "','" + Session["ID"].ToString() + "','" + Util.GetDecimal(dataItem[i].CreditPercentage) + "','" + Util.GetDecimal(dataItem[i].ipdCashPercentage) + "','" + Util.GetDecimal(dataItem[i].ipdCreditCashPercentage) + "'," + Util.GetInt(dataItem[i].shareCalculationOn) + "," + HttpContext.Current.Session["CentreID"].ToString() + "," + dataItem[i].Amount + "," + dataItem[i].CreditAmount + "," + dataItem[i].ShareIn + ")");

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                }
            }
            else
            {
                DataTable dtDoctorList = StockReports.GetDataTable("SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))NAME FROM doctor_master dm INNER JOIN f_center_doctor fcp ON dm.DoctorID=fcp.DoctorID WHERE dm.IsActive = 1 AND fcp.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND dm.`IsDocShare`=1 AND fcp.isActive=1 ORDER BY dm.id ");
                if (dtDoctorList != null && dtDoctorList.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtDoctorList.Rows)
                    {
                        //int exit = Util.GetInt(StockReports.ExecuteScalar(" Select count(*) from da_DoctorShare where CategoryID='" + CategoryID + "' AND DoctorID='" + dr["DoctorID"].ToString() + "' "));
                        //if (exit > 0)
                        //{
                        //    string str = "UPDATE da_DoctorShare set IsActive=0,DeactivatedBy='" + Session["ID"].ToString() + "',DeactivateDate=now() where CategoryID='" + CategoryID + "' AND DoctorID='" + dr["DoctorID"].ToString() + "' ";
                        //    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                        //}

                        string str = "UPDATE da_DoctorShare set IsActive=0,DeactivatedBy='" + Session["ID"].ToString() + "',DeactivateDate=now() where CategoryID='" + CategoryID + "' AND DoctorID='" + dr["DoctorID"].ToString() + "'  and TypeId=1 and IsActive=1  and CentreID= " + HttpContext.Current.Session["CentreID"].ToString();
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);

                        for (int i = 0; i < dataItem.Count; i++)
                        {
                            StringBuilder sb = new StringBuilder();
                            sb.Append(" Insert into da_DoctorShare(TypeId,DoctorID,CategoryID,SubCategoryID,Percentage,CreatedBy,CreditPercentage,IPDCashPercentage,IPDCreditPercentage,shareCalculationOn) ");
                            sb.Append(" VALUES( '" + dr["DoctorID"].ToString() + "','" + CategoryID + "','" + Util.GetString(dataItem[i].SubCategoryID) + "','" + Util.GetDecimal(dataItem[i].Percentage) + "', ");
                            sb.Append(" '" + Session["ID"].ToString() + "','" + Util.GetDecimal(dataItem[i].CreditPercentage) + "' ,'" + Util.GetDecimal(dataItem[i].ipdCashPercentage) + "','" + Util.GetDecimal(dataItem[i].ipdCreditCashPercentage) + "'," + Util.GetInt(dataItem[i].shareCalculationOn) + "," + HttpContext.Current.Session["CentreID"].ToString() + " ) ");

                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                        }
                    }
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

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindShareItemWise(string subCategoryID, string DoctorID, string CategoryID)
    {
        StringBuilder sb = new StringBuilder();
        string confID = StockReports.ExecuteScalar("SELECT ConfigID FROM f_configrelation WHERE CategoryID='" + CategoryID + "' AND IsActive=1");
        DataTable dt = new DataTable();
        if (DoctorID.ToString() != "ALL")
        {
            sb.Append(" SELECT * FROM ( ");
            sb.Append(" SELECT  ifnull(dds.shareCalculationOn,1)shareCalculationOn,im.subCategoryID,im.TypeName `Name`,IFNULL(IF(dds.shareSetOn=0,dds.OPDAmount,dds.percentage),0)percentage,im.ItemID,IFNULL(dds.IsActive,'0')IsActive,IFNULL(IF(dds.shareSetOn=0,dds.IPDAmount,dds.CreditPercentage),0)CreditPercentage,IFNULL(dds.shareSetOn,1)shareSetOn,IF(IFNULL(dds.shareSetOn,1)=0, IFNULL(dds.IPDAmount,0),IFNULL(dds.`IPDCashPercentage`,0))IPDCashPercentage,IFNULL(dds.`IPDCreditPercentage`,0)IPDCreditPercentage from f_itemmaster ");
            sb.Append(" im  INNER JOIN da_DoctorShare dds on dds.ItemID=im.ItemID ");
            sb.Append(" AND dds.IsActive=1 AND dds.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " AND dds.DoctorID='" + DoctorID + "' where im.SubCategoryID='" + subCategoryID + "'");
            if ((confID == "1") || (confID == "5"))
                sb.Append("  AND  im.Type_ID='" + DoctorID + "' ");
            sb.Append(" AND im.IsActive=1 ");

            sb.Append(" UNION ALL");

            sb.Append(" SELECT  ifnull(dds.shareCalculationOn,1)shareCalculationOn,im.subCategoryID,im.TypeName `Name`,IFNULL(IF(dds.shareSetOn=0,dds.OPDAmount,dds.percentage),0)percentage,im.ItemID,IFNULL(dds.IsActive,'0')IsActive,IFNULL(IF(dds.shareSetOn=0,dds.IPDAmount,dds.CreditPercentage),0)CreditPercentage,IFNULL(dds.shareSetOn,1)shareSetOn,IF(IFNULL(dds.shareSetOn,1)=0, IFNULL(dds.IPDAmount,0),IFNULL(dds.`IPDCashPercentage`,0))IPDCashPercentage,IFNULL(dds.`IPDCreditPercentage`,0)IPDCreditPercentage from f_itemmaster ");
            sb.Append(" im  LEFT JOIN da_DoctorShare dds on dds.SubCategoryID=im.SubCategoryID  ");
            sb.Append(" AND dds.IsActive=1 AND dds.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "  AND dds.DoctorID='" + DoctorID + "' where im.SubCategoryID='" + subCategoryID + "'");
            if ((confID == "1") || (confID == "5"))
                sb.Append("  AND  im.Type_ID='" + DoctorID + "' ");
            sb.Append(" AND im.IsActive=1 ");

            sb.Append(" )t GROUP BY t.ItemID ORDER BY t.Name ");



            dt = StockReports.GetDataTable(sb.ToString());
        }
        else
        {
            sb.Append(" SELECT * FROM ( ");
            sb.Append(" SELECT  ifnull(das.shareCalculationOn,1)shareCalculationOn,im.subCategoryID,im.TypeName `Name`,IFNULL(das.percentage,0)percentage,im.ItemID,IFNULL(das.IsActive,'0')IsActive,IFNULL(das.CreditPercentage,0)CreditPercentage,IFNULL(das.`IPDCashPercentage`,0)IPDCashPercentage,IFNULL(das.`IPDCreditPercentage`,0)IPDCreditPercentage ");
            sb.Append(" FROM  f_itemmaster im INNER JOIN da_DoctorShare das ON das.ItemID=im.ItemID AND das.IsActive=1 WHERE im.SubCategoryID='" + subCategoryID + "' AND im.IsActive=1  ");
            sb.Append(" UNION ALL");
            sb.Append(" SELECT  ifnull(das.shareCalculationOn,1)shareCalculationOn,im.subCategoryID,im.TypeName `Name`,IFNULL(das.percentage,0)percentage,im.ItemID,IFNULL(das.IsActive,'0')IsActive,IFNULL(das.CreditPercentage,0)CreditPercentage,IFNULL(das.`IPDCashPercentage`,0)IPDCashPercentage,IFNULL(das.`IPDCreditPercentage`,0)IPDCreditPercentage ");
            sb.Append(" FROM  f_itemmaster im LEFT JOIN da_DoctorShare das ON das.SubCategoryID=im.SubCategoryID AND das.IsActive=1 AND das.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " WHERE im.SubCategoryID='" + subCategoryID + "' AND im.IsActive=1  ");
            sb.Append(" )t GROUP BY t.ItemID ORDER BY t.Name ");
            dt = StockReports.GetDataTable(sb.ToString());
        }

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public string saveShareItemWise(object item, string DoctorID, string CategoryID)
    {
        List<shareItemWie> dataItem = new JavaScriptSerializer().ConvertToType<List<shareItemWie>>(item);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            if (DoctorID != "ALL")
            {
                for (int i = 0; i < dataItem.Count; i++)
                {
                    sb.Clear();
                    if (dataItem[i].IsActive == 1)
                    {
                        sb.Append("UPDATE da_DoctorShare SET IsActive=0,DeactivatedBy='" + Session["ID"].ToString() + "',DeactivateDate=now() WHERE ItemID='" + dataItem[i].ItemID + "' AND SubCategoryID='" + dataItem[i].SubCategoryID + "' AND DoctorID='" + DoctorID + "' AND TypeId=2 AND IsActive=1 and centreID= " + HttpContext.Current.Session["CentreID"].ToString());
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                    }

                    sb.Clear();

                    if (dataItem[i].ShareIn == 0)
                    {
                        dataItem[i].Amount = dataItem[i].Percentage;
                        dataItem[i].CreditAmount = dataItem[i].ipdCashPercentage;
                        dataItem[i].Percentage = 0;
                        //dataItem[i].CreditAmount = 0;
                        dataItem[i].CreditPercentage = 0;
                        dataItem[i].ipdCashPercentage = 0;
                        dataItem[i].ipdCreditCashPercentage = 0;
                    }



                    sb.Append("INSERT INTO da_DoctorShare(TypeId,CategoryID,SubCategoryID,ItemID,DoctorID,Percentage,CreatedBy,CreditPercentage,IPDCashPercentage,IPDCreditPercentage,shareCalculationOn,CentreID,OPDAmount,IPDAmount,shareSetOn)");
                    sb.Append(" VALUES(2,'" + CategoryID + "','" + dataItem[i].SubCategoryID + "','" + dataItem[i].ItemID + "','" + DoctorID + "' ,");
                    sb.Append(" '" + Util.GetDecimal(dataItem[i].Percentage) + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDecimal(dataItem[i].CreditPercentage) + "','" + Util.GetDecimal(dataItem[i].ipdCashPercentage) + "','" + Util.GetDecimal(dataItem[i].ipdCreditCashPercentage) + "'," + Util.GetInt(dataItem[i].shareCalculationOn) + "," + HttpContext.Current.Session["CentreID"].ToString() + "," + dataItem[i].Amount + "," + dataItem[i].CreditAmount + "," + dataItem[i].ShareIn + ")");
                    
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                }
            }
            else
            {
                DataTable dtDoctorList = StockReports.GetDataTable("SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))NAME FROM doctor_master dm INNER JOIN f_center_doctor fcp ON dm.DoctorID=fcp.DoctorID WHERE dm.IsActive = 1 AND fcp.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND dm.`IsDocShare`=1 AND fcp.isActive=1 ORDER BY dm.id ");
                if (dtDoctorList != null && dtDoctorList.Rows.Count > 0)
                {
                    for (int i = 0; i < dataItem.Count; i++)
                    {
                        foreach (DataRow dr in dtDoctorList.Rows)
                        {
                            sb.Clear();
                            if (dataItem[i].IsActive == 1)
                            {
                                // sb.Append("UPDATE da_Share SET IsActive=0,DeactivatedBy='" + Session["ID"].ToString() + "',DeactivateDate=now() WHERE ItemID='" + dataItem[i].ItemID + "' AND SubCategoryID='" + dataItem[i].SubCategoryID + "' AND DoctorID='" + dr["DoctorID"].ToString() + "'");
                                sb.Append("UPDATE da_DoctorShare SET IsActive=0,DeactivatedBy='" + Session["ID"].ToString() + "',DeactivateDate=now() WHERE ItemID='" + dataItem[i].ItemID + "' AND SubCategoryID='" + dataItem[i].SubCategoryID + "' AND DoctorID='" + dr["DoctorID"].ToString() + "'  AND TypeId=2 AND IsActive=1 and CentreID= " + HttpContext.Current.Session["CentreID"].ToString());

                                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                            }

                            sb.Clear();
                            // sb.Append("INSERT INTO da_Share(DoctorID,CategoryID,SubCategoryID,ItemID,Percentage,CreatedBy,CreditPercentage,IPDCashPercentage,IPDCreditPercentage)");


                            if (dataItem[i].ShareIn == 0)
                            {

                                dataItem[i].Amount = dataItem[i].Percentage;
                                dataItem[i].CreditAmount = dataItem[i].CreditAmount;
                                dataItem[i].Percentage = 0;
                                dataItem[i].CreditAmount = 0;
                            }

                            sb.Append("INSERT INTO da_DoctorShare(TypeId,DoctorID,CategoryID,SubCategoryID,ItemID,Percentage,CreatedBy,CreditPercentage,IPDCashPercentage,IPDCreditPercentage,shareCalculationOn,centreID,OPDAmount,IPDAmount,shareSetOn)");

                            sb.Append(" VALUES(2,'" + dr["DoctorID"].ToString() + "','" + CategoryID + "','" + dataItem[i].SubCategoryID + "','" + dataItem[i].ItemID + "', ");
                            sb.Append(" '" + Util.GetDecimal(dataItem[i].Percentage) + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDecimal(dataItem[i].CreditPercentage) + "' ,'" + Util.GetDecimal(dataItem[i].ipdCashPercentage) + "','" + Util.GetDecimal(dataItem[i].ipdCreditCashPercentage) + "'," + Util.GetInt(dataItem[i].shareCalculationOn) + "," + HttpContext.Current.Session["CentreID"].ToString() + "," + dataItem[i].Amount + "," + dataItem[i].CreditAmount + "," + dataItem[i].ShareIn + ")");
                            

                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                        }
                    }
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

    public class shareItemWie
    {
        public string ItemID { get; set; }
        public decimal Percentage { get; set; }
        public decimal CreditPercentage { get; set; }
        public decimal Amount { get; set; }
        public decimal CreditAmount { get; set; }
        public decimal ShareIn { get; set; }
        public string SubCategoryID { get; set; }
        public int IsActive { get; set; }
        public int ConfigID { get; set; }
        public decimal ipdCashPercentage { get; set; }
        public decimal ipdCreditCashPercentage { get; set; }
        public int shareCalculationOn { get; set; }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveDocShareDate(string ShareFrom, string ShareTo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string strDoc = "";
            string ID = StockReports.ExecuteScalar("Select ID from da_share_date WHERE PostShare=0 AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ORDER BY ID DESC LIMIT 1");
            if (ID != "")
            {
                DataTable ShareDate = StockReports.GetDataTable("Select Date_Format(Share_From,'%d-%b-%Y')ShareFrom,Date_Format(Share_to,'%d-%b-%Y')ShareTo from da_share_date where id=" + ID + " ");
                if (ShareDate.Rows.Count > 0)
                {
                    if (ShareDate.Rows[0]["ShareTo"].ToString() == "")
                    {
                        strDoc = "UPDATE da_share_date set Share_To='" + Util.GetDateTime(ShareTo.ToString()).ToString("yyyy-MM-dd") + "' where Share_From='" + Util.GetDateTime(ShareFrom.ToString()).ToString("yyyy-MM-dd") + "' AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strDoc);

                    //    strDoc = "UPDATE da_doctorsharestatus set Share_To='" + Util.GetDateTime(ShareTo.ToString()).ToString("yyyy-MM-dd") + "' where Share_From='" + Util.GetDateTime(ShareFrom.ToString()).ToString("yyyy-MM-dd") + "'";
                    //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strDoc);
                    }
                    else
                    {
                        strDoc = ShareDate.Rows[0]["ShareFrom"].ToString();
                        return strDoc;
                    }
                }
            }
            else
            {
                strDoc = " INSERT INTO da_share_date (Share_From,Share_To,CreatedBy,CentreID) values('" + Util.GetDateTime(ShareFrom.ToString()).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ShareTo.ToString()).ToString("yyyy-MM-dd") + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strDoc);

                //strDoc = " INSERT INTO da_doctorsharestatus(DoctorID,Share_From,Share_To,`Type`,PaymentType,EntryBy,EntryDate) " +
                //         " SELECT dm.DoctorID,'" + Util.GetDateTime(ShareFrom.ToString()).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ShareTo.ToString()).ToString("yyyy-MM-dd") + "',dpt.Type,dpt.PaymentType,'" + HttpContext.Current.Session["ID"].ToString() + "',NOW() " +
                //         " FROM doctor_master dm INNER JOIN f_center_doctor fcp ON dm.DoctorID=fcp.DoctorID CROSS JOIN da_doctorpaytype dpt WHERE dm.IsActive = 1 AND fcp.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND fcp.isActive=1 AND dm.IsDocShare=1 ";
                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strDoc);
            }

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindDetail()
    {
        string FromDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Share_From,'%d-%b-%Y')FromDate from da_share_date  WHERE postShare=0 order by ID DESC LIMIT 1");
        string Todate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Share_To,'%d-%b-%Y')ToDate from da_share_date WHERE postShare=0 order by ID DESC LIMIT 1");

        if ((FromDate != "") && (Todate != ""))
            return FromDate + '#' + Todate;
        else
            return "";
    }

    //[WebMethod(EnableSession = true)]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public string BindDocShare(string FromDate, string ToDate, string DoctorID, string CategoryID, string Type, string PaymentType)
    //{
    //    string rtrn = "";

    //    StockReports.ExecuteDML(" DELETE FROM da_tempdoctorlist ");

    //    string query = string.Empty;
    //    query = " INSERT INTO da_tempdoctorlist(DoctorID,DoctorName) SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DocName FROM doctor_master dm INNER JOIN " +
    //            " (SELECT DISTINCT DoctorID FROM da_doctorsharestatus WHERE Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND IsPosted='0' ";
    //    if (DoctorID != "")
    //    {
    //        query += " AND  DoctorID='" + DoctorID + "' ";
    //    }
    //    query += " ) dss ON dm.DoctorID=dss.DoctorID  ";


    //    if (StockReports.ExecuteDML(query))
    //    {
    //        string sql = " CALL da_DocShareDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + Type + "','" + PaymentType + "','" + CategoryID + "') ";

    //        DataTable dt = StockReports.GetDataTable(sql);
    //        if (dt.Rows.Count > 0)
    //        {
    //            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    //            return rtrn;
    //        }
    //        else
    //        {
    //            return rtrn;
    //        }
    //    }
    //    else
    //    {
    //        return rtrn;
    //    }
    //}

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindDocShare(string FromDate, string ToDate, string DoctorID, string CategoryID, string Type, string PaymentType, int IsPanelGroupWise, int PId)
    {
        string rtrn = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string count = StockReports.ExecuteScalar("SELECT COUNT(IsPosted) FROM da_doctorsharestatus WHERE sHARE_From ='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND  DoctorID='" + DoctorID + "' AND IsPosted=0 LIMIT 1");
            if (count != "0")
            {
                // MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM da_tempdoctorlist");
                StringBuilder sb = new StringBuilder();
                //sb.Append("INSERT INTO da_tempdoctorlist(DoctorID,DoctorName) SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DocName FROM doctor_master dm ");
                //sb.Append("INNER JOIN (");
                //sb.Append("   SELECT DISTINCT DoctorID FROM da_doctorsharestatus WHERE Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND IsPosted='0' ");
                //if (DoctorID != "")
                //    sb.Append("AND DoctorID='" + DoctorID + "' ");
                //if (Type != "")
                //    sb.Append(" AND Type='" + Type + "'  ");

                //sb.Append(" ) dss ON dm.DoctorID=dss.DoctorID ");

                //if (Util.getbooleanTrueFalse(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString())))
                // {
                string sql = " CALL da_BindDocShare('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + Type + "','" + PaymentType + "','" + CategoryID + "','" + DoctorID + "'," + IsPanelGroupWise + "," + PId + ") ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                tnx.Commit();
                sb.Clear();
                sb.Append(" SELECT ds.ID,ds.Type,ds.PanelName,IF(ds.IsDone=1,IFNULL(ds.FromDoctorName,''),ds.DoctorName)DoctorName,IF(ds.IsDone=1,ds.FromDoctorID,ds.DoctorID)DoctorID, ");
                sb.Append(" ds.BillDate,ds.BillNo,ds.TypeOfTnx,ds.MRNo,ds.GrossAmount,ds.PaidAmount,ds.DisAmt,ds.NetAmount,ds.PaidAmount,ds.ItemName,ds.Quantity, ");
                sb.Append(" ds.Rate,ds.Amount,ds.RoundOff,ds.FixedAmt,ds.BonusPercentage,ds.BonusAmt,ds.HospShare, ");
                sb.Append(" ds.`PaymentType`,ds.`PatientType`,ds.IsDone,ds.IsAdded,ds.ComplementoryAmt,ds.DoctorID,ds.LtdID,IF(ds.IsDone=1,ds.DoctorID,'')ToDoctorId, ");
                sb.Append(" ds.OPDPercentage,ds.OPD_Amt,ds.OPDBonusPercent,ds.OPDBonusFixedAmt,ds.HospSharePer,ds.HospShareAmt,ds.IPDPercentage,ds.IPD_Amt,ds.IPDBonusPercent,ds.IPDBonusFixedAmt,ds.HospSharePerIPD,ds.HospShareAmtIPD,ds.DocAmt,ds.NetDocAmt,ds.PanelID,ds.PanelGroupID,ds.ItemID,ds.DoctorSalary,ds.SalaryTypeID,ds.SalaryType,ds.SubcategoryId,ds.SubcategoryName,ds.UserName,ds.ReceiptNo, ");
                sb.Append(" ds.OPDPercentage_Ed,ds.OPD_Amt_Ed,ds.OPDBonusPercent_Ed,ds.OPDBonusFixedAmt_Ed,ds.HospSharePer_Ed,ds.HospShareAmt_Ed,ds.IPDPercentage_Ed,ds.IPD_Amt_Ed,ds.IPDBonusPercent_Ed,ds.IPDBonusFixedAmt_Ed,ds.HospSharePerIPD_Ed,ds.HospShareAmtIPD_Ed,ds.DocAmt_Ed,ds.NetShare_Ed,IF(ds.Type='IPD',REPLACE(ds.TransactionID,'ISHHI',''),'')IPNo ");
                sb.Append(" FROM  da_calculatedshare ds ");
                sb.Append(" LEFT JOIN  da_doctorsharedetail dsd ON ds.ltdid=dsd.ltdid AND ds.IsDone<>3 ");
                sb.Append(" WHERE ds.FromDate='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND ds.ToDate='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND ds.IsDone<>3 ");
                if (Type != "")
                    sb.Append(" AND ds.Type='" + Type + "'  ");
                if (CategoryID != "0")
                    sb.Append(" AND ds.CategoryID='" + CategoryID + "' ");
                if (!String.IsNullOrEmpty(DoctorID))
                    sb.Append(" AND IF(ds.`IsDone`=1,ds.`FromDoctorID`,ds.`DoctorID`)='" + DoctorID + "' ");
                if (PId != 0)
                {
                    if (IsPanelGroupWise == 0)
                        sb.Append(" AND ds.PanelID=" + PId + " ");
                    else
                        sb.Append(" AND ds.PanelGroupID=" + PId + " ");
                }
                sb.Append(" AND (ds.`OPDPercentage`+ds.`IPDPercentage`+ds.`OPD_Amt`+ds.`IPD_Amt`)<>0 ");
                sb.Append(" GROUP By ds.PanelID,ds.DoctorID,ds.TYPE,ds.BillNo,ds.LtdID     ");

                DataTable dt = StockReports.GetDataTable(sb.ToString());
                dt.Columns.Add("RowColour");
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (Util.GetInt(dt.Rows[i]["IsDone"]) == 0)
                        {
                            if (Util.GetInt(dt.Rows[i]["IsAdded"]) == 1)
                            {
                                dt.Rows[i]["RowColour"] = "#42f0f0";
                            }
                            else
                            {
                                dt.Rows[i]["RowColour"] = "none";
                            }
                        }
                        else if (Util.GetInt(dt.Rows[i]["IsDone"]) == 1)
                        {
                            dt.Rows[i]["RowColour"] = "#de7ac4";
                        }

                        if (Util.GetDecimal(dt.Rows[i]["OPDPercentage"]) != Util.GetDecimal(dt.Rows[i]["OPDPercentage_Ed"]) || Util.GetDecimal(dt.Rows[i]["OPD_Amt"]) != Util.GetDecimal(dt.Rows[i]["OPD_Amt_Ed"])
                            || Util.GetDecimal(dt.Rows[i]["OPDBonusPercent"]) != Util.GetDecimal(dt.Rows[i]["OPDBonusPercent_Ed"]) || Util.GetDecimal(dt.Rows[i]["OPDBonusFixedAmt"]) != Util.GetDecimal(dt.Rows[i]["OPDBonusFixedAmt_Ed"])
                            || Util.GetDecimal(dt.Rows[i]["HospSharePer"]) != Util.GetDecimal(dt.Rows[i]["HospSharePer_Ed"]) || Util.GetDecimal(dt.Rows[i]["HospShareAmt"]) != Util.GetDecimal(dt.Rows[i]["HospShareAmt_Ed"])
                            || Util.GetDecimal(dt.Rows[i]["IPDPercentage"]) != Util.GetDecimal(dt.Rows[i]["IPDPercentage_Ed"]) || Util.GetDecimal(dt.Rows[i]["IPD_Amt"]) != Util.GetDecimal(dt.Rows[i]["IPD_Amt_Ed"])
                            || Util.GetDecimal(dt.Rows[i]["IPDBonusPercent"]) != Util.GetDecimal(dt.Rows[i]["IPDBonusPercent_Ed"]) || Util.GetDecimal(dt.Rows[i]["IPDBonusFixedAmt"]) != Util.GetDecimal(dt.Rows[i]["IPDBonusFixedAmt_Ed"])
                            || Util.GetDecimal(dt.Rows[i]["HospSharePerIPD"]) != Util.GetDecimal(dt.Rows[i]["HospSharePerIPD_Ed"]) || Util.GetDecimal(dt.Rows[i]["HospShareAmtIPD"]) != Util.GetDecimal(dt.Rows[i]["HospShareAmtIPD_Ed"])
                            || Util.GetDecimal(dt.Rows[i]["DocAmt"]) != Util.GetDecimal(dt.Rows[i]["DocAmt_Ed"]) || Util.GetDecimal(dt.Rows[i]["NetDocAmt"]) != Util.GetDecimal(dt.Rows[i]["NetShare_Ed"]))
                        {
                            dt.Rows[i]["RowColour"] = "#D1F51B";
                        }
                    }

                    rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                    return rtrn;
                }
                else
                {
                    return rtrn;
                }
                // }
                //else
                //{
                //   return rtrn;
                //}
            }
            else
            {

                return rtrn = "1";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return rtrn;

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string TruncateCalShare(string FromDate, string ToDate, string DoctorID, string CategoryID, string Type, string PaymentType, int IsPanelGroupWise, int PId)
    {
        string rtrn = "0";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("DELETE da.* FROM da_calculatedshare da WHERE  da.FromDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND da.ToDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
            //if (DoctorID != "")
            //    sb.Append(" AND da.DoctorID='" + DoctorID + "' ");

            //if (PId != 0)
            //    sb.Append(" AND IF(" + IsPanelGroupWise + "=1,da.PanelGroupID,da.PanelID)=" + PId + ")");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            sb.Clear();
            sb.Append("DELETE sd.* FROM da_shifteddocshare sd WHERE  sd.FromDate='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND sd.ToDate='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
            //if (DoctorID != "")
            //    sb.Append(" AND sd.DoctorID='" + DoctorID + "' ");

            //if (PId != 0)
            //    sb.Append(" AND IF(" + IsPanelGroupWise + "=1,sd.PID,sd.PanelID)=" + PId + ")");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string CalculateDocShare(List<DocDetail> Data, string DoctorID, string Type, string PaymentType)
    {
        int len = Data.Count;
        if (len > 0)
        {
            string condition = string.Empty;
            if (DoctorID != "")
            {
                condition += " AND DoctorID='" + Util.GetString(DoctorID) + "' ";
            }
            if (Type != "")
            {
                condition += " AND Type='" + Util.GetString(Type) + "' ";
            }
            if (PaymentType != "")
            {
                condition += " AND PaymentType='" + Util.GetString(PaymentType) + "' ";
            }

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder query = new StringBuilder();
                query.Append(" INSERT INTO da_Backupdoctorsharedetail(DoctorID,ReceiptNo,BillNo,GrossAmount,Discount,NetAmount,PaidAmount,DoctorSharePercentage,DoctorShare,FromDate,ToDate,CreatedBy,Createddate,BackupBy, ");
                query.Append(" TypeOfTnx,SubcategoryId,SubcategoryName,MasterID,IsPost,PatientID,BillDate,Type,ItemID,ItemName,Quantity,ItemRate,ItemNetAmount,UnPostedBy,UnPostedDate,IpAddress) ");
                query.Append(" SELECT DoctorID,ReceiptNo,BillNo,GrossAmount,Discount,NetAmount,PaidAmount,DoctorSharePercentage,DoctorShare,FromDate,ToDate,CreatedBy,Createddate,'" + HttpContext.Current.Session["ID"].ToString() + "', ");
                query.Append(" TypeOfTnx,SubcategoryId,SubcategoryName,MasterID,IsPost,PatientID,BillDate,Type,ItemID,ItemName,Quantity,ItemRate,ItemNetAmount,UnPostedBy,UnPostedDate,IpAddress  ");
                query.Append(" FROM da_DoctorshareDetail WHERE FromDate='" + Data[0].FromDate.ToString("yyyy-MM-dd") + "' AND ToDate='" + Data[0].ToDate.ToString("yyyy-MM-dd") + "' " + condition);
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, query.ToString());

                query.Clear();
                query.Append(" DELETE FROM da_DoctorshareDetail WHERE FromDate='" + Data[0].FromDate.ToString("yyyy-MM-dd") + "' AND ToDate='" + Data[0].ToDate.ToString("yyyy-MM-dd") + "' " + condition);
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, query.ToString());

                for (int i = 0; i < Data.Count; i++)
                {
                    DoctorshareDetail dsd = new DoctorshareDetail(tnx);
                    dsd.DoctorID = Data[i].DoctorID;
                    dsd.ReceiptNo = Data[i].ReceiptNo;
                    dsd.BillNo = Data[i].BillNo;
                    dsd.GrossAmount = Data[i].GrossAmount;
                    dsd.Discount = Data[i].Discount;
                    dsd.NetAmount = Data[i].NetAmount;
                    dsd.PaidAmount = Data[i].PaidAmount;
                    dsd.DoctorSharePercentage = Data[i].DoctorSharePercentage;
                    dsd.DoctorShare = Data[i].DoctorShare;
                    dsd.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                    dsd.FromDate = Util.GetDateTime(Data[i].FromDate.ToString("yyyy-MM-dd"));
                    dsd.ToDate = Util.GetDateTime(Data[i].ToDate.ToString("yyyy-MM-dd"));
                    dsd.TypeOfTnx = Data[i].TypeOfTnx;
                    dsd.SubcategoryId = Data[i].SubcategoryId;
                    dsd.SubcategoryName = Data[i].SubcategoryName;
                    dsd.PatientID = Data[i].PatientID;
                    dsd.BillDate = Util.GetDateTime(Data[i].BillDate.ToString("yyyy-MM-dd"));
                    dsd.Type = Data[i].Type;
                    dsd.PaymentType = Util.GetInt(Data[i].PaymentType);
                    dsd.ItemID = Util.GetString(Data[i].ItemID);
                    dsd.ItemName = Util.GetString(Data[i].ItemName);
                    dsd.Quantity = Util.GetDecimal(Data[i].Quantity);
                    dsd.ItemRate = Util.GetDecimal(Data[i].ItemRate);
                    dsd.ItemNetAmount = Util.GetDecimal(Data[i].ItemNetAmount);
                    dsd.IPAddress = All_LoadData.IpAddress();
                    dsd.UserName = Data[i].UserName;
                    dsd.PanelName = Data[i].PanelName;
                    dsd.Insert();
                }

                query.Clear();
                query.Append(" UPDATE da_doctorsharestatus SET IsCalculated='1',CalculatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',CalculatedDate=NOW() WHERE Share_From='" + Data[0].FromDate.ToString("yyyy-MM-dd") + "' AND Share_To='" + Data[0].ToDate.ToString("yyyy-MM-dd") + "' " + condition);
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, query.ToString());

                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "0";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }

    public class DocDetail
    {
        public string DoctorID { get; set; }
        public string ReceiptNo { get; set; }
        public string BillNo { get; set; }
        public decimal GrossAmount { get; set; }
        public decimal Discount { get; set; }
        public decimal NetAmount { get; set; }
        public decimal PaidAmount { get; set; }
        public decimal DoctorSharePercentage { get; set; }
        public decimal DoctorShare { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public string CreatedBy { get; set; }
        public string TypeOfTnx { get; set; }
        public string SubcategoryId { get; set; }
        public string SubcategoryName { get; set; }
        public string PatientID { get; set; }
        public DateTime BillDate { get; set; }
        public string Type { get; set; }
        public int PaymentType { get; set; }
        public string ItemID { get; set; }
        public string ItemName { get; set; }
        public decimal Quantity { get; set; }
        public decimal ItemRate { get; set; }
        public decimal ItemNetAmount { get; set; }
        public string UserName { get; set; }
        public string PanelName { get; set; }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveDocShare(List<PostData> Data, string DoctorID, string Type, string PaymentType)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string condition = string.Empty;
                if (DoctorID != "")
                {
                    condition += " AND DoctorID='" + Util.GetString(DoctorID) + "' ";
                }
                if (Type != "")
                {
                    condition += " AND Type='" + Util.GetString(Type) + "' ";
                }
                if (PaymentType != "")
                {
                    condition += " AND PaymentType='" + Util.GetString(PaymentType) + "' ";
                }

                for (int i = 0; i < Data.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE da_doctorsharedetail Set DoctorShare='" + Data[i].DoctorShare + "' where ID='" + Data[i].ID + "' ");
                }

                StringBuilder query = new StringBuilder();
                query.Append(" INSERT INTO da_backupdocsharemaster(ID,DoctorID,FromDate,ToDate,TotalGrossAmt,TotalDiscount,TotalNetAmt,TotalPaidAmount,DoctorShare,TDS,PayableAmt,EntryBy,EntryDate,IsActive,IsPost,UpDatedBy,Type,PaymentType,UnPostedBy,UnPostedDate,IpAddress) ");
                query.Append(" SELECT ID,DoctorID,FromDate,ToDate,TotalGrossAmt,TotalDiscount,TotalNetAmt,TotalPaidAmount,DoctorShare,TDS,PayableAmt,EntryBy,EntryDate,IsActive,IsPost,'" + HttpContext.Current.Session["ID"].ToString() + "',Type,PaymentType,UnPostedBy,UnPostedDate,IpAddress ");
                query.Append(" FROM da_docsharemaster WHERE FromDate='" + Data[0].FromDate.ToString("yyyy-MM-dd") + "' AND ToDate='" + Data[0].ToDate.ToString("yyyy-MM-dd") + "' " + condition);
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query.ToString());

                query.Clear();
                query.Append(" DELETE From da_docsharemaster where FromDate='" + Util.GetDateTime(Data[0].FromDate).ToString("yyyy-MM-dd") + "' AND ToDate='" + Util.GetDateTime(Data[0].ToDate).ToString("yyyy-MM-dd") + "' " + condition);
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query.ToString());


                query.Clear();
                query.Append(" INSERT INTO da_docsharemaster(DoctorID,FromDate,ToDate,TotalGrossAmt,TotalDiscount,TotalNetAmt,TotalPaidAmount,DoctorShare,TDS,PayableAmt,EntryBy,Type,PaymentType,IpAddress) ");
                query.Append(" SELECT DoctorID,Fromdate,ToDate,SUM(GrossAmount),SUM(Discount),SUM(NetAmount),SUM(PaidAmount),SUM(DoctorShare),0,SUM(DoctorShare),'" + HttpContext.Current.Session["ID"].ToString() + "',Type,PaymentType,'" + All_LoadData.IpAddress() + "' ");
                query.Append(" FROM da_doctorsharedetail WHERE Todate='" + Util.GetDateTime(Data[0].ToDate).ToString("yyyy-MM-dd") + "' AND FromDate='" + Util.GetDateTime(Data[0].FromDate).ToString("yyyy-MM-dd") + "' " + condition + " GROUP BY DoctorID,`Type`,PaymentType ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query.ToString());

                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE da_doctorsharedetail dsd INNER JOIN da_docsharemaster dsm ON dsd.DoctorID=dsm.DoctorID AND dsd.FromDate=dsm.FromDate  SET MasterID=dsm.ID WHERE dsd.FromDate='" + Util.GetDateTime(Data[0].FromDate).ToString("yyyy-MM-dd") + "'" +
                //            " AND dsd.ToDate='" + Util.GetDateTime(Data[0].ToDate).ToString("yyyy-MM-dd") + "' AND dsm.FromDate='" + Util.GetDateTime(Data[0].FromDate).ToString("yyyy-MM-dd") + "' AND dsm.ToDate='" + Util.GetDateTime(Data[0].ToDate).ToString("yyyy-MM-dd") + "' ");

                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "0";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }

    public class PostData
    {
        public string ID { get; set; }
        public string DoctorID { get; set; }
        public string ReceiptNo { get; set; }
        public decimal BillNo { get; set; }
        public decimal DoctorShare { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string PostDocShare(List<PostData> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {

                int Count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select Count(*) from da_docsharemaster where FromDate='" + Util.GetDateTime(Data[0].FromDate).ToString("yyyy-MM-dd") + "' AND ToDate='" + Util.GetDateTime(Data[0].ToDate).ToString("yyyy-MM-dd") + "'"));
                if (Count > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE da_doctorsharedetail set IsPost=1 where  FromDate='" + Util.GetDateTime(Data[0].FromDate).ToString("yyyy-MM-dd") + "' AND ToDate='" + Util.GetDateTime(Data[0].ToDate).ToString("yyyy-MM-dd") + "'");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE da_docsharemaster set IsPost=1 where  FromDate='" + Util.GetDateTime(Data[0].FromDate).ToString("yyyy-MM-dd") + "' AND ToDate='" + Util.GetDateTime(Data[0].ToDate).ToString("yyyy-MM-dd") + "'");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE da_share_date set PostShare=1 where  Share_From='" + Util.GetDateTime(Data[0].FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(Data[0].ToDate).ToString("yyyy-MM-dd") + "'");

                    tnx.Commit();
                    return "1";
                }

                else
                {
                    return "2";
                }
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "0";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }



    [WebMethod(EnableSession = true)]
    public string PostDoctorShareNew(int isPost,string FromDate, string ToDate, int DoctorID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            excuteCMD.DML(tnx, " CALL `docacc_DoctorSharePostAndUnPostAndDoctor`(@isPosted,@fromDate,@toDate,@centreID,@doctorID,@entryBy) ", CommandType.Text, new
            {
                isPosted = isPost,
                fromDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"),
                toDate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"),
                centreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()),
                doctorID = DoctorID,
                entryBy = HttpContext.Current.Session["ID"].ToString()
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = (isPost == 1 ? "Doctor share Posted Successfully" : "Doctor share Un-Posted Successfully") });
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

    

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindPostDocShare(string FromDate, string ToDate, string DoctorID, string Type, string PaymentType)
    {
        string rtrn = "";

        StringBuilder query = new StringBuilder();
        if (Type == "OPD" && PaymentType == "1")
        {
            query.Append(" SELECT t.DoctorID,t.DName,t.OPDCashShare,t.IsOPDCashShare,t.OPDCashShare AS TotalShare,IF(t.OPDCashShare>30000,(t.OPDCashShare*0.1),0)TDS,(t.OPDCashShare-IF(t.OPDCashShare>30000,(t.OPDCashShare*0.1),0))NetShare FROM ( ");
            query.Append(" SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,IFNULL(SUM(dsm.DoctorShare),0)OPDCashShare,dss.IsCalculated AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='OPD' AND dsm.PaymentType=1 ");
            query.Append(" WHERE dss.Type='OPD' AND dss.PaymentType=1 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND dss.IsPosted=0 ");

            if (DoctorID != "")
                query.Append(" AND dm.DoctorID='" + DoctorID + "' ");
            query.Append(" GROUP BY dss.DoctorID )t GROUP BY t.DoctorID ORDER BY t.DName ");
        }
        else if (Type == "OPD" && PaymentType == "2")
        {
            query.Append(" SELECT t.DoctorID,t.DName,t.OPDCreditShare,t.IsOPDCreditShare,t.OPDCreditShare AS TotalShare,IF(t.OPDCreditShare>30000,(t.OPDCreditShare*0.1),0)TDS,(t.OPDCreditShare-IF(t.OPDCreditShare>30000,(t.OPDCreditShare*0.1),0))NetShare FROM ( ");
            query.Append(" SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,IFNULL(SUM(dsm.DoctorShare),0)OPDCreditShare,dss.IsCalculated AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='OPD' AND dsm.PaymentType=2 ");
            query.Append(" WHERE dss.Type='OPD' AND dss.PaymentType=2 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND dss.IsPosted=0 ");

            if (DoctorID != "")
                query.Append(" AND dm.DoctorID='" + DoctorID + "' ");

            query.Append(" GROUP BY dss.DoctorID )t GROUP BY t.DoctorID ORDER BY t.DName ");
        }
        else if (Type == "IPD" && PaymentType == "1")
        {
            query.Append(" SELECT t.DoctorID,t.DName,t.IPDCashShare,t.IsIPDCashShare,t.IPDCashShare AS TotalShare,IF(t.IPDCashShare>30000,(t.IPDCashShare*0.1),0)TDS,(t.IPDCashShare-IF(t.IPDCashShare>30000,(t.IPDCashShare*0.1),0))NetShare FROM ( ");
            query.Append(" SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,IFNULL(SUM(dsm.DoctorShare),0)IPDCashShare,dss.IsCalculated AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='IPD' AND dsm.PaymentType=1 ");
            query.Append(" WHERE dss.Type='IPD' AND dss.PaymentType=1 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND dss.IsPosted=0 ");

            if (DoctorID != "")
                query.Append(" AND dm.DoctorID='" + DoctorID + "' ");

            query.Append(" GROUP BY dss.DoctorID )t GROUP BY t.DoctorID ORDER BY t.DName ");
        }
        else if (Type == "IPD" && PaymentType == "2")
        {
            query.Append(" SELECT t.DoctorID,t.DName,t.IPDCreditShare,t.IsIPDCreditShare,t.IPDCreditShare AS TotalShare,IF(t.IPDCreditShare>30000,(t.IPDCreditShare*0.1),0)TDS,(t.IPDCreditShare-IF(t.IPDCreditShare>30000,(t.IPDCreditShare*0.1),0))NetShare FROM ( ");
            query.Append(" SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,IFNULL(SUM(dsm.DoctorShare),0)IPDCreditShare,dss.IsCalculated AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='IPD' AND dsm.PaymentType=2 ");
            query.Append(" WHERE dss.Type='IPD' AND dss.PaymentType=2 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND dss.IsPosted=0 ");

            if (DoctorID != "")
                query.Append(" AND dm.DoctorID='" + DoctorID + "' ");

            query.Append(" GROUP BY dss.DoctorID )t GROUP BY t.DoctorID ORDER BY t.DName ");
        }
        else if (Type == "OPD" && PaymentType == "")
        {
            query.Append(" SELECT t.DoctorID,t.DName,MAX(t.OPDCashShare)OPDCashShare,MAX(t.IsOPDCashShare)IsOPDCashShare,MAX(t.OPDCreditShare)OPDCreditShare,MAX(t.IsOPDCreditShare)IsOPDCreditShare,(MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)) AS TotalShare,IF((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare))>30000,((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare))*0.1),0)TDS,((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare))-IF((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare))>30000,((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare))*0.1),0))NetShare FROM ( ");
            query.Append(" SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,IFNULL(SUM(dsm.DoctorShare),0)OPDCashShare,dss.IsCalculated AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='OPD' AND dsm.PaymentType=1 ");
            query.Append(" WHERE dss.Type='OPD' AND dss.PaymentType=1 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");
            query.Append(" UNION ALL SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,IFNULL(SUM(dsm.DoctorShare),0)OPDCreditShare,dss.IsCalculated AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='OPD' AND dsm.PaymentType=2 ");
            query.Append(" WHERE dss.Type='OPD' AND dss.PaymentType=2 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");

            if (DoctorID != "")
                query.Append(" )t WHERE t.DoctorID='" + DoctorID + "' GROUP BY t.DoctorID ORDER BY t.DName ");
            else
                query.Append(" )t GROUP BY t.DoctorID ORDER BY t.DName ");
        }
        else if (Type == "IPD" && PaymentType == "")
        {
            query.Append(" SELECT t.DoctorID,t.DName,MAX(t.IPDCashShare)IPDCashShare,MAX(t.IsIPDCashShare)IsIPDCashShare,MAX(t.IPDCreditShare)IPDCreditShare,MAX(t.IsIPDCreditShare)IsIPDCreditShare,(MAX(t.IPDCashShare)+MAX(t.IPDCreditShare)) AS TotalShare,IF((MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))>30000,((MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))*0.1),0)TDS,((MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))-IF((MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))>30000,((MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))*0.1),0))NetShare FROM ( ");
            query.Append(" SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,IFNULL(SUM(dsm.DoctorShare),0)IPDCashShare,dss.IsCalculated AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='IPD' AND dsm.PaymentType=1 ");
            query.Append(" WHERE dss.Type='IPD' AND dss.PaymentType=1 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");
            query.Append(" UNION ALL SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,IFNULL(SUM(dsm.DoctorShare),0)IPDCreditShare,dss.IsCalculated AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='IPD' AND dsm.PaymentType=2 ");
            query.Append(" WHERE dss.Type='IPD' AND dss.PaymentType=2 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");

            if (DoctorID != "")
                query.Append(" )t WHERE t.DoctorID='" + DoctorID + "' GROUP BY t.DoctorID ORDER BY t.DName ");
            else
                query.Append(" )t GROUP BY t.DoctorID ORDER BY t.DName ");
        }
        else if (Type == "" && PaymentType == "1")
        {
            query.Append(" SELECT t.DoctorID,t.DName,MAX(t.OPDCashShare)OPDCashShare,MAX(t.IsOPDCashShare)IsOPDCashShare,MAX(t.IPDCashShare)IPDCashShare,MAX(t.IsIPDCashShare)IsIPDCashShare,(MAX(t.OPDCashShare)+MAX(t.IPDCashShare)) AS TotalShare,IF((MAX(t.OPDCashShare)+MAX(t.IPDCashShare))>30000,((MAX(t.OPDCashShare)+MAX(t.IPDCashShare))*0.1),0)TDS,((MAX(t.OPDCashShare)+MAX(t.IPDCashShare))-IF((MAX(t.OPDCashShare)+MAX(t.IPDCashShare))>30000,((MAX(t.OPDCashShare)+MAX(t.IPDCashShare))*0.1),0))NetShare FROM ( ");
            query.Append(" SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,IFNULL(SUM(dsm.DoctorShare),0)OPDCashShare,dss.IsCalculated AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='OPD' AND dsm.PaymentType=1 ");
            query.Append(" WHERE dss.Type='OPD' AND dss.PaymentType=1 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");
            query.Append(" UNION ALL SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,IFNULL(SUM(dsm.DoctorShare),0)IPDCashShare,dss.IsCalculated AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='IPD' AND dsm.PaymentType=1 ");
            query.Append(" WHERE dss.Type='IPD' AND dss.PaymentType=1 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");

            if (DoctorID != "")
                query.Append(" )t WHERE t.DoctorID='" + DoctorID + "' GROUP BY t.DoctorID ORDER BY t.DName ");
            else
                query.Append(" )t GROUP BY t.DoctorID ORDER BY t.DName ");
        }
        else if (Type == "" && PaymentType == "2")
        {
            query.Append(" SELECT t.DoctorID,t.DName,MAX(t.OPDCreditShare)OPDCreditShare,MAX(t.IsOPDCreditShare)IsOPDCreditShare,MAX(t.IPDCreditShare)IPDCreditShare,MAX(t.IsIPDCreditShare)IsIPDCreditShare,(MAX(t.OPDCreditShare)+MAX(t.IPDCreditShare)) AS TotalShare,IF((MAX(t.OPDCreditShare)+MAX(t.IPDCreditShare))>30000,((MAX(t.OPDCreditShare)+MAX(t.IPDCreditShare))*0.1),0)TDS,((MAX(t.OPDCreditShare)+MAX(t.IPDCreditShare))-IF((MAX(t.OPDCreditShare)+MAX(t.IPDCreditShare))>30000,((MAX(t.OPDCreditShare)+MAX(t.IPDCreditShare))*0.1),0))NetShare FROM ( ");
            query.Append(" SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,IFNULL(SUM(dsm.DoctorShare),0)OPDCreditShare,dss.IsCalculated AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='OPD' AND dsm.PaymentType=2 ");
            query.Append(" WHERE dss.Type='OPD' AND dss.PaymentType=2 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");
            query.Append(" UNION ALL SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,IFNULL(SUM(dsm.DoctorShare),0)IPDCreditShare,dss.IsCalculated AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='IPD' AND dsm.PaymentType=2 ");
            query.Append(" WHERE dss.Type='IPD' AND dss.PaymentType=2 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");

            if (DoctorID != "")
                query.Append(" )t WHERE t.DoctorID='" + DoctorID + "' GROUP BY t.DoctorID ORDER BY t.DName ");
            else
                query.Append(" )t GROUP BY t.DoctorID ORDER BY t.DName ");
        }
        else
        {
            query.Append(" SELECT t.DoctorID,t.DName,MAX(t.OPDCashShare)OPDCashShare,MAX(t.IsOPDCashShare)IsOPDCashShare,MAX(t.OPDCreditShare)OPDCreditShare,MAX(t.IsOPDCreditShare)IsOPDCreditShare,MAX(t.IPDCashShare)IPDCashShare,MAX(t.IsIPDCashShare)IsIPDCashShare,MAX(t.IPDCreditShare)IPDCreditShare,MAX(t.IsIPDCreditShare)IsIPDCreditShare,(MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))TotalShare,IF((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))>30000,((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))*0.1),0)TDS,");
            query.Append(" ((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))-IF((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))>30000,((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))*0.1),0))NetShare FROM ( ");
            query.Append(" SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,IFNULL(SUM(dsm.DoctorShare),0)OPDCashShare,dss.IsCalculated AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='OPD' AND dsm.PaymentType=1 ");
            query.Append(" WHERE dss.Type='OPD' AND dss.PaymentType=1 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND dss.IsPosted=0 GROUP BY dss.DoctorID ");
            query.Append(" UNION ALL SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,IFNULL(SUM(dsm.DoctorShare),0)OPDCreditShare,dss.IsCalculated AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='OPD' AND dsm.PaymentType=2 ");
            query.Append(" WHERE dss.Type='OPD' AND dss.PaymentType=2 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND dss.IsPosted=0 GROUP BY dss.DoctorID ");
            query.Append(" UNION ALL SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,IFNULL(SUM(dsm.DoctorShare),0)IPDCashShare,dss.IsCalculated AS IsIPDCashShare,0 AS IPDCreditShare,0 AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='IPD' AND dsm.PaymentType=1 ");
            query.Append(" WHERE dss.Type='IPD' AND dss.PaymentType=1 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND dss.IsPosted=0 GROUP BY dss.DoctorID ");
            query.Append(" UNION ALL SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DName,0 AS OPDCashShare,0 AS IsOPDCashShare,0 AS OPDCreditShare,0 AS IsOPDCreditShare,0 AS IPDCashShare,0 AS IsIPDCashShare,IFNULL(SUM(dsm.DoctorShare),0)IPDCreditShare,dss.IsCalculated AS IsIPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='IPD' AND dsm.PaymentType=2 ");
            query.Append(" WHERE dss.Type='IPD' AND dss.PaymentType=2 AND Share_From='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND dss.IsPosted=0 GROUP BY dss.DoctorID ");

            if (DoctorID != "")
                query.Append(" )t WHERE t.DoctorID='" + DoctorID + "' GROUP BY t.DoctorID ORDER BY t.DName ");
            else
                query.Append(" )t GROUP BY t.DoctorID ORDER BY t.DName ");
        }

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
        else
        {
            return rtrn;
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SetCalculationStatus(string fromDate, string toDate, string doctorID, string type)
    {
        string query = string.Empty;
        string result = "0";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (doctorID != "")
            {
                if (type == "OPDCash")
                {
                    query = " UPDATE da_doctorsharestatus SET IsCalculated='1',CalculatedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',CalculatedDate=NOW(),IsDirectSet='1' WHERE DoctorID IN (" + doctorID + ") AND `Type`='OPD' AND PaymentType='1' AND Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ";
                }
                else if (type == "OPDCredit")
                {
                    query = " UPDATE da_doctorsharestatus SET IsCalculated='1',CalculatedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',CalculatedDate=NOW(),IsDirectSet='1' WHERE DoctorID IN (" + doctorID + ") AND `Type`='OPD' AND PaymentType='2' AND Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ";
                }
                else if (type == "IPDCash")
                {
                    query = " UPDATE da_doctorsharestatus SET IsCalculated='1',CalculatedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',CalculatedDate=NOW(),IsDirectSet='1' WHERE DoctorID IN (" + doctorID + ") AND `Type`='IPD' AND PaymentType='1' AND Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ";
                }
                else if (type == "IPDCredit")
                {
                    query = " UPDATE da_doctorsharestatus SET IsCalculated='1',CalculatedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',CalculatedDate=NOW(),IsDirectSet='1' WHERE DoctorID IN (" + doctorID + ") AND `Type`='IPD' AND PaymentType='2' AND Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ";
                }
                else
                {
                    query = " UPDATE da_doctorsharestatus SET IsCalculated='1',CalculatedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',CalculatedDate=NOW(),IsDirectSet='1' WHERE DoctorID IN (" + doctorID + ") AND Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ";
                }

                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query.ToString());
            }

            tranx.Commit();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
        return result;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string PostDocShareData(string fromDate, string toDate, string doctorID, string type, string paymentType)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder query = new StringBuilder();
            query.Append(" INSERT INTO da_backupdocsharemaster(ID,DoctorID,FromDate,ToDate,TotalGrossAmt,TotalDiscount,TotalNetAmt,TotalPaidAmount,DoctorShare,TDS,PayableAmt,EntryBy,EntryDate,IsActive,IsPost,UpDatedBy,OPDCashShare,OPDCreditShare,IPDCashShare,IPDCreditShare,UnPostedBy,UnPostedDate,IpAddress) ");
            query.Append(" SELECT ID,DoctorID,FromDate,ToDate,TotalGrossAmt,TotalDiscount,TotalNetAmt,TotalPaidAmount,DoctorShare,TDS,PayableAmt,EntryBy,EntryDate,IsActive,IsPost,'" + HttpContext.Current.Session["ID"].ToString() + "',OPDCashShare,OPDCreditShare,IPDCashShare,IPDCreditShare,UnPostedBy,UnPostedDate,IpAddress FROM da_docsharemaster ");
            query.Append(" WHERE FromDate='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND ToDate='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND DoctorID IN (" + doctorID + ") ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query.ToString());

            query.Clear();
            query.Append(" DELETE FROM da_docsharemaster WHERE FromDate='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND ToDate='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND DoctorID IN (" + doctorID + ") ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query.ToString());

            query.Clear();
            query.Append(" INSERT INTO da_docsharemaster(DoctorID,FromDate,ToDate,TotalGrossAmt,TotalDiscount,TotalNetAmt,TotalPaidAmount,DoctorShare,TDS,PayableAmt,EntryBy,IsPost,OPDCashShare,OPDCreditShare,IPDCashShare,IPDCreditShare,IpAddress) ");
            query.Append(" SELECT DoctorID,FromDate,ToDate,GrossAmount,Discount,NetAmount,PaidAmount,TotalShare,TDS,NetShare,'" + HttpContext.Current.Session["ID"].ToString() + "','1',OPDCashShare,OPDCreditShare,IPDCashShare,IPDCreditShare,'" + All_LoadData.IpAddress() + "' FROM ( ");
            query.Append(" SELECT t.DoctorID,t.FromDate,t.ToDate,SUM(t.GrossAmount)GrossAmount,SUM(t.Discount)Discount,SUM(t.NetAmount)NetAmount,SUM(t.PaidAmount)PaidAmount,MAX(t.OPDCashShare)OPDCashShare,MAX(t.OPDCreditShare)OPDCreditShare,MAX(t.IPDCashShare)IPDCashShare,MAX(t.IPDCreditShare)IPDCreditShare,(MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))TotalShare,IF((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))>30000,((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))*0.1),0)TDS,");
            query.Append(" ((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))-IF((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))>30000,((MAX(t.OPDCashShare)+MAX(t.OPDCreditShare)+MAX(t.IPDCashShare)+MAX(t.IPDCreditShare))*0.1),0))NetShare FROM ( ");
            query.Append(" SELECT dm.DoctorID,dss.Share_From AS FromDate,dss.Share_To AS ToDate,IFNULL(SUM(dsm.GrossAmount),0)GrossAmount,IFNULL(SUM(dsm.Discount),0)Discount,IFNULL(SUM(dsm.NetAmount),0)NetAmount,IFNULL(SUM(dsm.PaidAmount),0)PaidAmount,IFNULL(SUM(dsm.DoctorShare),0)OPDCashShare,0 AS OPDCreditShare,0 AS IPDCashShare,0 AS IPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='OPD' AND dsm.PaymentType=1 ");
            query.Append(" WHERE dss.Type='OPD' AND dss.PaymentType=1 AND Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");
            query.Append(" UNION ALL SELECT dm.DoctorID,dss.Share_From AS FromDate,dss.Share_To AS ToDate,IFNULL(SUM(dsm.GrossAmount),0)GrossAmount,IFNULL(SUM(dsm.Discount),0)Discount,IFNULL(SUM(dsm.NetAmount),0)NetAmount,IFNULL(SUM(dsm.PaidAmount),0)PaidAmount,0 AS OPDCashShare,IFNULL(SUM(dsm.DoctorShare),0)OPDCreditShare,0 AS IPDCashShare,0 AS IPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='OPD' AND dsm.PaymentType=2 ");
            query.Append(" WHERE dss.Type='OPD' AND dss.PaymentType=2 AND Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");
            query.Append(" UNION ALL SELECT dm.DoctorID,dss.Share_From AS FromDate,dss.Share_To AS ToDate,IFNULL(SUM(dsm.GrossAmount),0)GrossAmount,IFNULL(SUM(dsm.Discount),0)Discount,IFNULL(SUM(dsm.NetAmount),0)NetAmount,IFNULL(SUM(dsm.PaidAmount),0)PaidAmount,0 AS OPDCashShare,0 AS OPDCreditShare,IFNULL(SUM(dsm.DoctorShare),0)IPDCashShare,0 AS IPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='IPD' AND dsm.PaymentType=1 ");
            query.Append(" WHERE dss.Type='IPD' AND dss.PaymentType=1 AND Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");
            query.Append(" UNION ALL SELECT dm.DoctorID,dss.Share_From AS FromDate,dss.Share_To AS ToDate,IFNULL(SUM(dsm.GrossAmount),0)GrossAmount,IFNULL(SUM(dsm.Discount),0)Discount,IFNULL(SUM(dsm.NetAmount),0)NetAmount,IFNULL(SUM(dsm.PaidAmount),0)PaidAmount,0 AS OPDCashShare,0 AS OPDCreditShare,0 AS IPDCashShare,IFNULL(SUM(dsm.DoctorShare),0)IPDCreditShare ");
            query.Append(" FROM da_doctorsharestatus dss INNER JOIN doctor_master dm ON dm.DoctorID=dss.DoctorID LEFT JOIN da_doctorsharedetail dsm ON dsm.DoctorID=dss.DoctorID AND dsm.Fromdate=dss.Share_From AND dsm.ToDate=dss.Share_To AND dsm.Type='IPD' AND dsm.PaymentType=2 ");
            query.Append(" WHERE dss.Type='IPD' AND dss.PaymentType=2 AND Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY dss.DoctorID ");
            if (doctorID != "")
                query.Append(" )t WHERE t.DoctorID IN (" + doctorID + ") GROUP BY t.DoctorID ");
            else
                query.Append(" )t GROUP BY t.DoctorID ");
            query.Append(" )temp GROUP BY DoctorID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query.ToString());


            query.Clear();
            query.Append(" UPDATE da_doctorsharestatus SET IsPosted='1',PostedBy='" + HttpContext.Current.Session["ID"].ToString() + "',PostedDate=NOW()  WHERE Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND DoctorID IN (" + doctorID + ") ");
            if (type != "")
                query.Append(" AND Type='" + type + "' ");
            if (paymentType != "")
                query.Append(" AND PaymentType='" + paymentType + "' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query.ToString());

            query.Clear();
            query.Append(" UPDATE da_doctorsharedetail  Set IsPost=1 WHERE Fromdate='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND ToDate='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND DoctorID IN (" + doctorID + ") ");
            if (type != "")
                query.Append(" AND Type='" + type + "' ");
            if (paymentType != "")
                query.Append(" AND PaymentType='" + paymentType + "' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query.ToString());


            query.Clear();
            query.Append(" SELECT COUNT(*) FROM da_doctorsharestatus WHERE Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND IsPosted=0 ");
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, query.ToString()));

            if (count == 0)
            {
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " UPDATE da_share_date SET PostShare=1 WHERE Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            }

            query.Clear();
            query.Append(" UPDATE da_doctorsharedetail dsd INNER JOIN da_docsharemaster dsm ON dsd.DoctorID=dsm.DoctorID SET MasterID=dsm.ID ");
            query.Append(" WHERE dsd.Fromdate='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND dsd.ToDate='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND dsd.DoctorID IN (" + doctorID + ") ");
            if (type != "")
                query.Append(" AND dsd.Type='" + type + "' ");
            if (paymentType != "")
                query.Append(" AND dsd.PaymentType='" + paymentType + "' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query.ToString());

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindUnPostDate()
    {
        // Modify on 04-01-2017
        // string ID = StockReports.ExecuteScalar(" SELECT ID FROM da_share_date WHERE PostShare='1' ORDER BY ID DESC LIMIT 1");
        string ID = StockReports.ExecuteScalar(" SELECT ID FROM da_share_date ORDER BY ID DESC LIMIT 1");

        if (ID != "")
        {
            string FromDate = StockReports.ExecuteScalar(" SELECT DATE_FORMAT(Share_From,'%d-%b-%Y')FromDate from da_share_date where ID=" + ID + " ");
            string Todate = StockReports.ExecuteScalar(" SELECT DATE_FORMAT(Share_To,'%d-%b-%Y')ToDate from da_share_date where ID=" + ID + " ");
            if ((FromDate != "") && (Todate != ""))
                return FromDate + '#' + Todate;
            else
                return "";
        }
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SearchPostedDocShare(string fromDate, string toDate, string doctorID)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();
        query.Append(" SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DocName,dsm.OPDCashShare,dsm.OPDCreditShare,dsm.IPDCashShare,dsm.IPDCreditShare,dsm.DoctorShare,dsm.TDS,dsm.PayableAmt ");
        query.Append(" FROM da_docsharemaster dsm INNER JOIN doctor_master dm ON dsm.DoctorID=dm.DoctorID WHERE IsPost=1 AND FromDate='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND ToDate='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
        if (doctorID != "")
            query.Append(" AND dm.DoctorID='" + doctorID + "'");
        query.Append(" ORDER BY dm.Name ");

        DataTable dtPostedDetails = StockReports.GetDataTable(query.ToString());

        if (dtPostedDetails.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dtPostedDetails);
        }

        return result;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UnPostDocShare(string fromDate, string toDate, string doctorID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string share = " UPDATE da_share_date SET PostShare=0 WHERE Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, share);

            string status = " UPDATE da_doctorsharestatus SET IsPosted=0 WHERE Share_From='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND Share_To='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND DoctorID IN (" + doctorID + ") ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, status);

            string detail = " UPDATE da_doctorsharedetail SET IsPost=0,UnPostedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UnPostedDate=NOW() WHERE FromDate='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND ToDate='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND DoctorID IN (" + doctorID + ") ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, detail);

            string master = " UPDATE da_docsharemaster SET IsPost=0,UnPostedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UnPostedDate=NOW() WHERE FromDate='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND ToDate='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND DoctorID IN (" + doctorID + ") ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, master);

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
    

    
    
