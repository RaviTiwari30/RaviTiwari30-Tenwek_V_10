using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI.WebControls;
using AjaxControlToolkit;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for LoadCacheQuery
/// </summary>
public static class LoadCacheQuery
{
    public static DataTable loadCategory()
    {
        DataTable dt;
		
        string CacheName = "Category";
        try
        {
			
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                dt = StockReports.GetDataTable(" SELECT cm.Name,cm.CategoryID,ConfigID FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cm.categoryid = cf.categoryid  Where Active=1 ORDER BY cm.Name ");//ConfigID

                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CategoryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable loadSubCategory()
    {
        DataTable dt;
        string CacheName = "SubCategory";
        try
        {
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                dt = StockReports.GetDataTable(" SELECT SubCategoryID,sm.CategoryID,sm.Name,DisplayName,ConfigID,DisplayPriority FROM f_subcategorymaster sm INNER JOIN f_configrelation cf ON sm.categoryid = cf.categoryid  WHERE sm.active=1 ORDER BY sm.Name "); //sm.DisplayPriority ")

                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.SubCategoryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable loadAllPanel()
    {
        DataTable Items;
        string CacheName = "Panel";
        try
        {
            if (HttpContext.Current.Cache[CacheName] != null)
                Items = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                Items = StockReports.GetDataTable("Select RTRIM(LTRIM(Company_Name)) as Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD,IsCash,applyCreditLimit,PanelGroupID from f_panel_master order by Company_Name");

                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, Items, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.PanelCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return Items;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable loadOPDPanel(string CentreID)
    {
        DataTable dtPanel = new DataTable();
        string CacheName = string.Concat("PanelOPD", "_", CentreID);
        if (HttpContext.Current.Cache[CacheName] != null)
            dtPanel = HttpContext.Current.Cache[CacheName] as DataTable;
        else
        {
            dtPanel = StockReports.GetDataTable("SELECT TRIM(Company_Name) AS Company_Name,pm.PanelID,ReferenceCode,ReferenceCodeOPD,IsCash,HideRate,ShowPrintOut,CONCAT(pm.PanelID,'#',ReferenceCodeOPD,'#',HideRate,'#',ShowPrintOut)PanelCompanyValue FROM f_panel_master pm INNER JOIN f_rate_schedulecharges sc ON pm.ReferenceCodeOPD=sc.PanelID INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID WHERE sc.IsDefault=1 and pm.Isactive=1 AND fcp.CentreID='" + CentreID + "' AND fcp.isActive=1 AND pm.DateTo>NOW() ORDER BY pm.PanelID");//
            File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
            File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
            HttpContext.Current.Cache.Insert(CacheName, dtPanel, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.PanelOPDCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        }
        return dtPanel;
    }

    public static DataTable loadIPDPanel(string CentreID)
    {
        DataTable dtPanel = new DataTable();
        string CacheName = string.Concat("PanelIPD", "_", CentreID);
        if (HttpContext.Current.Cache[CacheName] != null)
            dtPanel = HttpContext.Current.Cache[CacheName] as DataTable;
        else
        {
            dtPanel = StockReports.GetDataTable("SELECT TRIM(Company_Name) AS Company_Name,pm.PanelID,ReferenceCode,ReferenceCodeOPD,IsCash,applyCreditLimit,CreditLimitType " +
                         "FROM f_panel_master pm INNER JOIN f_rate_schedulecharges sc ON pm.ReferenceCode=sc.PanelID INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID where sc.IsDefault=1 and pm.Isactive=1  AND pm.DateTo>NOW() AND  fcp.CentreID='" + CentreID + "' AND fcp.isActive=1 ORDER BY Company_Name");

            File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
            File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
            HttpContext.Current.Cache.Insert(CacheName, dtPanel, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.PanelIPDCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        }
        return dtPanel;
    }

    public static DataTable loadDoctor(string CentreID)
    {
        try
        {
            DataTable dt;
            string CacheName = string.Concat("Doctor", "_", CentreID);
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                string sql = "SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))Name,dm.Designation Department,dm.DocDepartmentID,dm.Specialization,dm.docGroupID,dm.IsDocShare,dm.IsEmergencyAvailable  FROM doctor_master dm INNER JOIN f_center_doctor fcp ON dm.DoctorID=fcp.DoctorID WHERE dm.IsActive = 1 AND fcp.CentreID='" + CentreID + "' AND fcp.isActive=1 ORDER BY dm.name";
                dt = StockReports.GetDataTable(sql);
                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.DoctorCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;


        }
    }

    public static DataTable loadCountry()
    {
        DataTable dt = new DataTable();
        string CacheName = "Country";
        if (HttpContext.Current.Cache[CacheName] != null)
            dt = HttpContext.Current.Cache[CacheName] as DataTable;
        else
        {
            string qstr = "SELECT CountryID,Name,IsBaseCurrency,STD_CODE FROM country_master WHERE IsActive=1 ORDER By SeqNo,Name";
            dt = StockReports.GetDataTable(qstr);
            File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
            File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
            HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CountryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        }
        return dt;
    }

    public static DataTable loadCity(string districtID, string StateID)
    {
        DataTable dt = new DataTable();
        string CacheName = "City";
        if (HttpContext.Current.Cache[CacheName] != null)
            dt = HttpContext.Current.Cache[CacheName] as DataTable;
        else
        {
            dt = StockReports.GetDataTable("SELECT distinct City,ID,IsDefault,Country,districtID,StateID FROM city_master where IsActive=1 AND city !='' order by City asc ");
            File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
            File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
            HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CityCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        }
        DataView CityView = dt.DefaultView;
        CityView.RowFilter = "districtID='" + districtID + "' ";

        dt = CityView.ToTable();
        return dt;
    }

    public static DataTable loadReferDoctor()
    {
        DataTable dt = new DataTable();
        string CacheName = string.Concat("ReferDoctor");
        if (HttpContext.Current.Cache[CacheName] != null)
            dt = HttpContext.Current.Cache[CacheName] as DataTable;
        else
        {

            string qstr = "SELECT dr.DoctorID,CONCAT(dr.Title,' ',dr.Name)Name FROM doctor_referal dr  WHERE dr.IsActive = 1 GROUP BY DoctorID ORDER BY NAME ";

            dt = StockReports.GetDataTable(qstr);

            File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
            File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
            HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.PROCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        }

        // if (PROID != "0")
        //  {
        DataView ReferDoctorView = dt.DefaultView;
        // ReferDoctorView.RowFilter = "PROID ='" + PROID + "' ";
        dt = ReferDoctorView.ToTable();
        // }

        return dt;
    }
    public static DataTable loadReferDoctorNew()
    {
        DataTable dt = new DataTable();
        string CacheName = string.Concat("ReferDoctor");
        if (HttpContext.Current.Cache[CacheName] != null)
            dt = HttpContext.Current.Cache[CacheName] as DataTable;
        else
        {

            string qstr = "SELECT dr.DoctorID,CONCAT(dr.Title,' ',dr.Name)NAME,IFNULL(mpr.PRO_ID,'0')PROID FROM doctor_referal dr LEFT JOIN mappedprotoreferdoctor mpr  ON dr.DoctorID=mpr.ReferDoctorID WHERE dr.IsActive = 1 GROUP BY DoctorID ORDER BY NAME ";

            dt = StockReports.GetDataTable(qstr);

            File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
            File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
            HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.PROCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        }

        // if (PROID != "0")
        //  {
        DataView ReferDoctorView = dt.DefaultView;
        // ReferDoctorView.RowFilter = "PROID ='" + PROID + "' ";
        dt = ReferDoctorView.ToTable();
        // }

        return dt;
    }
    public static DataTable loadPRONew(string referDoctorID)
    {
        DataTable dt = new DataTable();
        //string CacheName = string.Concat("PRO");
        //if (HttpContext.Current.Cache[CacheName] != null)
        //    dt = HttpContext.Current.Cache[CacheName] as DataTable;
        //else
        //{

        string qstr = "SELECT pm.Pro_ID,pm.ProName FROM f_pro_master pm WHERE pm.IsActive=1  ORDER BY ProName";
        dt = StockReports.GetDataTable(qstr);


        //    File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
        //    File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
        //    HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.ReferDoctorCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        //}
        return dt;
    }
    public static DataTable loadPRO(string referDoctorID)
    {
        DataTable dt = new DataTable();
        //string CacheName = string.Concat("PRO");
        //if (HttpContext.Current.Cache[CacheName] != null)
        //    dt = HttpContext.Current.Cache[CacheName] as DataTable;
        //else
        //{
        string qstr = string.Empty;

        if ((string.IsNullOrEmpty(referDoctorID)) || (referDoctorID =="0"))
            qstr = "SELECT pm.Pro_ID,pm.ProName  FROM f_pro_master pm  where pm.IsActive=1  ORDER BY ProName";
        else
         qstr = "SELECT pm.Pro_ID,pm.ProName FROM mappedprotoreferdoctor mp INNER JOIN f_pro_master pm ON mp.PRO_ID= pm.Pro_ID WHERE mp.ReferDoctorID='" + referDoctorID + "' and pm.IsActive=1  ORDER BY ProName";

        dt = StockReports.GetDataTable(qstr);


        //    File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
        //    File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
        //    HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.ReferDoctorCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        //}
        return dt;
    }
    public static DataTable loadOPDDiagnosisItems(string Type, string CategoryID, string SubCategoryID)
    {
        int centerID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        string CacheName = "OPDDiagnosisItems_" + HttpContext.Current.Session["CentreID"].ToString();
        DataTable dtInv = new DataTable();
        if (HttpContext.Current.Cache[CacheName] != null)
            dtInv = HttpContext.Current.Cache[CacheName] as DataTable;
        else
        {
            StringBuilder sb = new StringBuilder(); // change ConfigID to ConfigID
            sb.Append("SELECT item,AutoCompleteItemName,ItemCode,TypeName,ItemID Item_ID ,isadvance,IFNULL(IsOutSource, 0)IsOutSource,IFNULL(Type_ID, '') Type_ID,  CAST(LabType AS BINARY) LabType,TnxType,IF(Sample = 'R', Sample, 'N') Sample,SubCategoryID,categoryid,RateEditable,ItemID NewItemID,SubCategory,CONCAT(IFNULL(Type_ID, ''),'#',ItemID,'#',TypeName)PackageItemID,IsSlotWisetoken ");
            sb.Append(" FROM(SELECT im.isadvance,CONCAT(IFNULL(im.ItemCode, ''),' - ',im.TypeName,IF(cr.ConfigID=5,CONCAT('(',sm.Name,')'),'') )  AutoCompleteItemName,im.TypeName, CONCAT(IFNULL(im.ItemCode,''),' # ',im.TypeName)Item,im.RateEditable,ims.GenderInvestigate,im.ItemID,im.SubCategoryID,im.Type_ID,IFNULL(im.ItemCode,'')ItemCode, sm.categoryid ,sm.Name SubCategory, ");
            sb.Append(" (CASE WHEN cr.ConfigID=3 THEN 'LAB' WHEN cr.ConfigID IN (5)  THEN 'OPD' WHEN cr.ConfigID IN (23)  THEN 'PACK'  WHEN cr.ConfigID in (25) THEN 'PRO' WHEN cr.ConfigID in (7) THEN 'BB' ");
            sb.Append(" WHEN cr.ConfigID in (20,6)  THEN 'OTH' WHEN cr.ConfigID IN (3,25,20,7,6,23,5)  THEN 'OPD-BILLING' END)LabType,");
            sb.Append(" (CASE WHEN cr.ConfigID=3 THEN '3' WHEN cr.ConfigID in (25) THEN '4'  WHEN cr.ConfigID in (23) THEN '23' WHEN cr.ConfigID in (7) THEN '6' ");
            sb.Append(" WHEN cr.ConfigID in(5) THEN '5' WHEN cr.ConfigID in(20,6) THEN '20'  when cr.ConfigID IN (3,25,20,6,7,5,23) THEN '16' END)TnxType ,");
            sb.Append(" (SELECT TYPE FROM Investigation_master WHERE Investigation_ID=im.Type_ID)Sample,IsOutSource ,IF(cr.ConfigID=5,(SELECT IsSlotWiseToken FROM doctor_master WHERE doctorID= im.Type_ID),0)IsSlotWisetoken FROM f_itemmaster im  LEFT JOIN investigation_master ims ON ims.Investigation_Id = im.Type_ID INNER JOIN f_subcategorymaster sm ");
            sb.Append(" ON sm.subcategoryid = im.subcategoryid INNER JOIN f_configrelation  cr ON cr.categoryid = sm.categoryid ");
            sb.Append(" INNER JOIN f_itemmaster_centerwise dpt ON dpt.`ItemID`=im.`ItemID` ");
            sb.Append(" WHERE cr.ConfigID in (3,5,25,6,20,7,23)  ");
            sb.Append(" AND im.IsActive=1 AND dpt.`IsActive`=1 AND dpt.`CentreID`= '" + centerID + "' ");
            sb.Append("  )t1 order by Item");


            dtInv = StockReports.GetDataTable(sb.ToString());
            File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
            File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
            HttpContext.Current.Cache.Insert(CacheName, dtInv, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.OPD_InvestigationCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        }
        DataView DvInvestigation = dtInv.DefaultView;
        string filter = string.Empty;
        //For Investigation
        if (Type == "1")
        {
            filter = "TnxType=3";
            DvInvestigation.RowFilter = filter;
        }
        //For Procedure
        else if (Type == "2")
        {
            filter = "TnxType=4";
            DvInvestigation.RowFilter = filter;
        }
        //For Other Items
        else if (Type == "3")
        {
            filter = "TnxType=20";
            DvInvestigation.RowFilter = filter;
        }
        //For Consultation
        else if (Type == "4")
        {
            filter = "TnxType=5";
            DvInvestigation.RowFilter = filter;
        }
        // For Blood Bank
        else if (Type == "5")
        {
            filter = "TnxType=6";
            DvInvestigation.RowFilter = filter;
        }
       // For Laboratory
        else if (Type == "9")
        {
            filter = " CategoryID='3'";
            DvInvestigation.RowFilter = filter;
        }
        // For Radiology
        else if (Type == "10")
        {
            filter = " CategoryID='7'";
            DvInvestigation.RowFilter = filter;
        }
        // For OPD-Package
        else if (Type == "11")
        {
            filter = " TnxType='23'";
            DvInvestigation.RowFilter = filter;
        }
        else if (Type == "10000")
        {
            filter = " TnxType='-1'";
            DvInvestigation.RowFilter = filter;
        }
         // For ALL
        else if (Type == "100")
        {
            string configIDs = "3";

            DataTable dtUserAuthorization = StockReports.GetDataTable("SELECT GROUP_CONCAT(DISTINCT (CASE WHEN colname='IsCanLab' AND colvalue=1 THEN '3' WHEN colname='IsCanRadio' AND colvalue=1 THEN '7' END)) IsCanLabRadio, GROUP_CONCAT(DISTINCT (CASE WHEN colname='IsCanCon' AND colvalue=1 THEN '5' END)) AS IsCanCon, GROUP_CONCAT(DISTINCT (CASE WHEN colname='IsCanPack' AND colvalue=1 THEN '23' END)) AS IsCanPack, GROUP_CONCAT(DISTINCT (CASE WHEN colname='IsCanOther' AND colvalue=1 THEN '20' END)) AS IsCanOther, GROUP_CONCAT(DISTINCT (CASE WHEN colname='IsCanPro' AND colvalue=1 THEN '4' END)) AS IsCanPro,GROUP_CONCAT(DISTINCT (CASE WHEN colname='IsBlood' AND colvalue=1 THEN '6' END)) AS IsBlood FROM userAuthorization WHERE RoleId='" + Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()) + "' AND  EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' AND CentreID=" + centerID + "");


            if (dtUserAuthorization != null && dtUserAuthorization.Rows.Count > 0)
            {


                if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanPro"].ToString()) != string.Empty)
                    configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanPro"].ToString());

                if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanCon"].ToString()) != string.Empty)
                    configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanCon"].ToString());

                if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanPack"].ToString()) != string.Empty)
                    configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanPack"].ToString());

                if (Util.GetString(dtUserAuthorization.Rows[0]["IsCanOther"].ToString()) != string.Empty)
                    configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanOther"].ToString());

                if (Util.GetString(dtUserAuthorization.Rows[0]["IsBlood"].ToString()) != string.Empty)
                    configIDs = configIDs + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsBlood"].ToString());

                //DvInvestigation.RowFilter = " TnxType IN(" + configIDs + ") AND CategoryID NOT IN(" + Util.GetString(dtUserAuthorization.Rows[0]["IsCanLabRadio"].ToString()) + ") ";

               // DvInvestigation.RowFilter = " TnxType IN(" + configIDs + ") AND CategoryID IN(" + Util.GetString(dtUserAuthorization.Rows[0]["IsCanLabRadio"].ToString()) + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanPro"].ToString()) + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanCon"].ToString()) + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanPack"].ToString()) + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsCanOther"].ToString()) + "," + Util.GetString(dtUserAuthorization.Rows[0]["IsBlood"].ToString()) + " ) ";
                DvInvestigation.RowFilter = " TnxType IN(" + configIDs + ") ";
            }
        }
        else
        {
            filter = "TnxType in (3,4,5,6,23)";
            DvInvestigation.RowFilter = filter;
        }

        if (CategoryID != "0")
        {
            filter = " CategoryID='" + CategoryID + "'";
            DvInvestigation.RowFilter = filter;
        }
        if (SubCategoryID != "0")
        {

            filter = " SubCategoryID='" + SubCategoryID + "'";
            DvInvestigation.RowFilter = filter;
        }
        return DvInvestigation.ToTable();
    }
    public static DataTable LoadInvestigation(string Type, string CategoryID, string SubCategoryID, int isIPDData, string transactionId, string appID)
    {
        int centerID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());

        DataTable dtInv = new DataTable();

        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        //chenge by indra prakah
        sb.Append("SELECT '0' Rate,item,CONCAT(ItemID,'#',SubCategoryID,'#',CAST(LabType AS BINARY),'#',");
        sb.Append(" IFNULL(Type_ID,''),'#',IF(Sample='R',Sample,'N'),'#',TnxType,'#',IFNULL(ItemCode,''),'#',IFNULL(GenderInvestigate,''),'#',isadvance,'#',IFNULL(IsOutSource,0),'#',RateEditable)ItemID,TnxType,SubCategoryID,categoryid,ItemID NewItemID,CAST(LabType AS BINARY) LabType, IFNULL(Type_ID, '')Type_ID, IF(Sample = 'R', Sample, 'N')Sample, TnxType, IFNULL(ItemCode, '')ItemCode, IFNULL(GenderInvestigate, '')GenderInvestigate, isadvance , IFNULL(IsOutSource, 0)IsOutSource, RateEditable,TypeName,0 IsPackage,IFNULL(Rate ,0)Rate1  ");
        sb.Append(" FROM(SELECT im.isadvance,CONCAT(IFNULL(im.ItemCode,''),' # ',im.TypeName)Item,im.RateEditable,ims.GenderInvestigate,im.ItemID,im.SubCategoryID,im.Type_ID,IFNULL(im.ItemCode,'')ItemCode,im.TypeName, sm.categoryid , ");
        sb.Append(" (CASE WHEN cr.ConfigID=3 THEN 'LAB' WHEN cr.ConfigID in (25) THEN 'PRO' WHEN cr.ConfigID in (7) THEN 'BB' ");
        sb.Append(" WHEN cr.ConfigID in (20,6)  THEN 'OTH' WHEN cr.ConfigID IN (3,25,20,6)  THEN 'OPD-BILLING' END)LabType,");
        sb.Append(" (CASE WHEN cr.ConfigID=3 THEN '3' WHEN cr.ConfigID in (25) THEN '4' WHEN cr.ConfigID in (7) THEN '6'");
        sb.Append(" WHEN cr.ConfigID in(20,6) THEN '5' when cr.ConfigID IN (3,25,20,6) THEN '16' END)TnxType ,");
        sb.Append(" (SELECT TYPE FROM Investigation_master WHERE Investigation_ID=im.Type_ID)Sample,IsOutSource,rl.Rate  FROM f_itemmaster im  LEFT JOIN investigation_master ims ON ims.Investigation_Id = im.Type_ID INNER JOIN f_subcategorymaster sm ");
        sb.Append(" ON sm.subcategoryid = im.subcategoryid INNER JOIN f_configrelation  cr ON cr.categoryid = sm.categoryid INNER JOIN f_itemmaster_centerwise itc ON itc.itemid=im.`ItemID`  ");
        if (isIPDData == 1)
        {
            dt = StockReports.GetDataTable("SELECT pmh.ScheduleChargeID,pm.ReferenceCode,pmh.CentreID,pid.IPDCaseTypeID FROM patient_medical_history pmh INNER JOIN patient_ipd_profile pid ON pid.TransactionID=pmh.TransactionID INNER JOIN f_panel_master pm ON pm.PanelID=pmh.PanelID WHERE pmh.TransactionID='" + transactionId + "' ORDER BY PatientIPDProfile_ID DESC LIMIT 1;");
            sb.Append(" LEFT JOIN f_ratelist_IPD rl ON rl.ItemID=im.ItemID AND rl.ScheduleChargeID='" + dt.Rows[0]["ScheduleChargeID"].ToString() + "' AND rl.PanelID='" + dt.Rows[0]["ReferenceCode"].ToString() + "' AND rl.CentreID='" + dt.Rows[0]["CentreID"].ToString() + "' AND rl.IPDCaseTypeID ='" + dt.Rows[0]["IPDCaseTypeID"].ToString() + "' AND rl.IsCurrent=1 ");
        }
        else
        {
            dt = StockReports.GetDataTable("SELECT app.CentreID,app.ScheduleChargeID,pm.ReferenceCode FROM appointment app INNER JOIN f_panel_master pm ON pm.PanelID=app.PanelID WHERE app.App_ID='" + appID + "' ORDER BY App_ID DESC LIMIT 1;");
            if (dt.Rows.Count == 0 || dt.Rows[0]["ScheduleChargeID"].ToString()=="0")
            {
                dt = StockReports.GetDataTable("SELECT pmh.ScheduleChargeID,pm.ReferenceCode,pmh.CentreID FROM patient_medical_history pmh INNER JOIN f_panel_master pm ON pm.PanelID=pmh.PanelID WHERE pmh.TransactionID='" + transactionId + "' LIMIT 1;");
            }
            sb.Append(" LEFT JOIN f_ratelist rl ON rl.ItemID=im.ItemID  AND rl.PanelID='" + dt.Rows[0]["ReferenceCode"].ToString() + "' AND rl.CentreID='" + dt.Rows[0]["CentreID"].ToString() + "' AND rl.IsCurrent=1 and rl.ScheduleChargeID='" + dt.Rows[0]["ScheduleChargeID"] + "'");
        }
        //FOR Doctor Favorite Items
        if (Type.Split('#').Length > 1)
            sb.Append(" inner join DoctorLab_ItemSer_Master dl on dl.ItemID=im.itemID and dl.DoctorID='" + Type.Split('#')[1].ToString() + "'");

        sb.Append(" WHERE cr.ConfigID in (3,25,6,20,7)  ");
        sb.Append(" and im.IsActive=1 AND itc.Isactive=1 AND itc.centreid = '" + centerID + "' )t1 order by Item");


        dtInv = StockReports.GetDataTable(sb.ToString());

        DataView DvInvestigation = dtInv.DefaultView;
        string filter = string.Empty;
        //For Investigation
        if (Type == "1")
        {
            filter = "TnxType=3";
            DvInvestigation.RowFilter = filter;
        }
        //For Procedure
        else if (Type == "2")
        {
            filter = "TnxType=4";
            DvInvestigation.RowFilter = filter;
        }
        //For Other Items
        else if (Type == "3")
        {
            filter = "TnxType=5";
            DvInvestigation.RowFilter = filter;
        }
        // For Blood Bank
        else if (Type == "5")
        {
            filter = "TnxType=6";
            DvInvestigation.RowFilter = filter;
        }
        //For Alll
        else
        {
            filter = "TnxType in (3,4,5)";
            DvInvestigation.RowFilter = filter;
        }

        if (CategoryID != "0")
        {
            filter = " CategoryID='" + CategoryID + "'";
            DvInvestigation.RowFilter = filter;
        }
        if (SubCategoryID != "0")
        {

            filter = " SubCategoryID='" + SubCategoryID + "'";
            DvInvestigation.RowFilter = filter;
        }
        return DvInvestigation.ToTable();
    }
    public static DataTable loadTypeOfAppointment()
    {
        DataTable dt;
        string CacheName = "AppointmentType";
        try
        {
            if (HttpContext.Current.Cache[CacheName] != null)
            {
                dt = HttpContext.Current.Cache[CacheName] as DataTable;

            }
            else
            {
                string strQuery = " SELECT AppointmentTypeID,AppointmentType,IsDefault FROM Master_AppointmentType WHERE IsActive=1 ORDER By IsDefault desc ";

                dt = StockReports.GetDataTable(strQuery);

                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.AppointmentTypeCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable loadCurrency()
    {
        DataTable dt;
        string CacheName = "Currency";
        try
        {
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                dt = StockReports.GetDataTable("SELECT * FROM ( SELECT CountryID,NAME,cm.Currency,cm.Notation,cm.IsBaseCurrency,B_CountryID,B_Currency,conmst.S_CountryID,conmst.Selling_Specific,conmst.S_Currency,conmst.S_Notation FROM country_master cm INNER JOIN Converson_Master conmst ON cm.CountryID=conmst.S_CountryID WHERE cm.IsActive=1 ORDER BY conmst.ID DESC )a GROUP BY CountryID ");

                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CurrencyCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable loadBank()
    {
        DataTable dt;
        string CacheName = "Bank";
        try
        {
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                dt = StockReports.GetDataTable(" SELECT Bank_ID,BankName FROM f_bank_master WHERE IsActive=1");

                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.BankCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static void DropCentreWisePanelControlCache()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/CentreWisePanelControlCache_" + dt.Rows[i]["CentreID"].ToString() + ".txt")))//
                {
                    File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/CentreWisePanelControlCache_" + dt.Rows[i]["CentreID"].ToString() + ".txt"));
                }
            }
        }
    }

    public static void DropCentreWiseCache()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/CentreWiseCache_" + dt.Rows[i]["CentreID"].ToString() + ".txt")))//
                {
                    File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/CentreWiseCache_" + dt.Rows[i]["CentreID"].ToString() + ".txt"));
                }
            }
        }
    }

    public static void dropCache(string CacheName)
    {
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"));
        }
    }

    public static void dropAllCache()
    {
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/City.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/City.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Country.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Country.txt"));
        }
        DataTable dt = All_LoadData.dtbind_Center();
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Doctor_" + dt.Rows[i]["CentreID"].ToString() + ".txt")))
                {
                    File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Doctor_" + dt.Rows[i]["CentreID"].ToString() + ".txt"));
                }
                if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/PanelOPD_" + dt.Rows[i]["CentreID"].ToString() + ".txt")))
                {
                    File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/PanelOPD_" + dt.Rows[i]["CentreID"].ToString() + ".txt"));
                }
                if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/PanelIPD_" + dt.Rows[i]["CentreID"].ToString() + ".txt")))
                {
                    File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/PanelIPD_" + dt.Rows[i]["CentreID"].ToString() + ".txt"));
                }

                if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/OPD_Investigation_" + dt.Rows[i]["CentreID"].ToString() + ".txt")))
                {
                    File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/OPD_Investigation_" + dt.Rows[i]["CentreID"].ToString() + ".txt"));
                }
                if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/OPDDiagnosisItems_" + dt.Rows[i]["CentreID"].ToString() + ".txt")))
                {
                    File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/OPDDiagnosisItems_" + dt.Rows[i]["CentreID"].ToString() + ".txt"));
                }

            }
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Panel.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Panel.txt"));
        }


        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/ReferDoctor.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/ReferDoctor.txt"));
        }
       
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Category.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Category.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/SubCategory.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/SubCategory.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Currency.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Currency.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Bank.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Bank.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/AppointmentType.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/AppointmentType.txt"));
        }
        
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/StoreDepartment.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/StoreDepartment.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/DepartmentStore.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/DepartmentStore.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/LoadMedicineQuantity.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/LoadMedicineQuantity.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/PRO.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/PRO.txt"));
        }
    }
    public static void loadDataonCacheCentreWise(string CentreID)
    {
        loadOPDPanel(CentreID);
        loadIPDPanel(CentreID);
        loadDoctor(CentreID);

    }
    public static void loadAllDataonCache()
    {
        loadReferDoctor();
        loadCategory();
        loadSubCategory();
        loadAllPanel();
        loadCountry();
        loadPRO("0");
        loadTypeOfAppointment();
        loadCurrency();
        loadBank();
        bindStoreDepartment();

    }
    public static DataTable bindStoreDepartment()
    {
        DataTable dt;
        string CacheName = "DepartmentStore";
        try
        {
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                string strQuery = "SELECT ledgerNumber,ledgerName,rm.IsStore,rm.IsGeneral,rm.IsMedical,rm.IsIndent,rm.ID RoleID FROM f_ledgermaster lm INNER JOIN f_rolemaster rm ON lm.ledgerNumber=rm.DeptLedgerNo WHERE lm.GroupID = 'DPT' AND lm.IsCurrent=1 AND rm.Active=1  order by ledgerName";
                dt = StockReports.GetDataTable(strQuery);
                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.StoreDepartmentCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable loadDistrict(string countryID, string stateID)
    {
        try
        {
            DataTable dt;
            string CacheName = "District";
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                string str = "SELECT DistrictID,District,IsCurrent,countryID,stateID FROM Master_District WHERE IsActive=1 AND District<>'' ORDER BY District";
                dt = StockReports.GetDataTable(str);
                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CountryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }

            DataView districtView = dt.DefaultView;
            districtView.RowFilter = "countryID='" + countryID + "'  AND stateID='" + stateID + "'  ";
            dt = districtView.ToTable();
            return dt;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;


        }
    }
    public static DataTable loadTaluk(string districtID)
    {
        try
        {
            DataTable dt = new DataTable();
            string CacheName = "Taluka";
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                string str = "SELECT TalukaID,Taluka,DistrictID,IsCurrent FROM Master_Taluka WHERE Taluka<>'' ORDER BY Taluka ASC";
                dt = StockReports.GetDataTable(str);
                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CountryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);

            }
            DataView TalukView = dt.DefaultView;
            TalukView.RowFilter = "DistrictID='" + districtID + "'";
            dt = TalukView.ToTable();
            return dt;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;


        }
    }
    public static DataTable LoadMedicineQuantity(string TYPE)
    {
        try
        {
            DataTable dt = new DataTable();
            string CacheName = "LoadMedicineQuantity";
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                string str = "SELECT NAME,TYPE,Quantity FROM phar_label_master WHERE isActive=1 ORDER BY SequenceNo";
                dt = StockReports.GetDataTable(str);
                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CountryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            DataView Medicine = dt.DefaultView;
            Medicine.RowFilter = "TYPE='" + TYPE + "'";
            dt = Medicine.ToTable();
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable BindWelcomeMessage(int CentreID)
    {
        try
        {
            DataTable dt = new DataTable();
            string CacheName = string.Concat("WelcomeMessage", "_", CentreID);
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                dt = StockReports.GetDataTable("Select Message,DescriptionMessage from welcome_message where Active = '1' ");
                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CountryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable loadState(int countryID)
    {
        try
        {
            DataTable dt;
            string CacheName = "State";
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                string str = "SELECT StateID,StateName,IsCurrent,CountryID FROM master_State WHERE IsActive=1 AND StateName<>'' ORDER BY StateName";
                dt = StockReports.GetDataTable(str);
                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CountryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }

            DataView StateView = dt.DefaultView;
            StateView.RowFilter = "CountryID='" + countryID + "'";
            dt = StateView.ToTable();
            return dt;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;


        }
    }

    public static DataTable CentreWiseCache()
    {
        try
        {
            DataTable dt;
            string CacheName = string.Concat("CentreWiseCache", "_", HttpContext.Current.Session["CentreID"].ToString());
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                string sql = "CALL bindPatientControls(" + HttpContext.Current.Session["CentreID"].ToString() + ")";
                dt = StockReports.GetDataTable(sql);
                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.DoctorCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable CentreWisePanelControlCache()
    {
        try
        {
            DataTable dt;
            string CacheName = string.Concat("CentreWisePanelControlCache", "_", HttpContext.Current.Session["CentreID"].ToString());
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                string sql = "CALL bindPanelControls(" + HttpContext.Current.Session["CentreID"].ToString() + ")";
                dt = StockReports.GetDataTable(sql);
                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.DoctorCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable RoleWiseOPDServiceBookingControls()
    {
        try
        {
            DataTable dt;
            string CacheName = string.Concat("OPDServiceBookingControls", "_", HttpContext.Current.Session["RoleID"].ToString(), "_", HttpContext.Current.Session["ID"].ToString(), "_", HttpContext.Current.Session["CentreID"].ToString());
            if (HttpContext.Current.Cache[CacheName] != null)
                dt = HttpContext.Current.Cache[CacheName] as DataTable;
            else
            {
                string sql = "CALL bindOPDServiceBookingControls(" + HttpContext.Current.Session["RoleID"].ToString() + ",'" + HttpContext.Current.Session["ID"].ToString() + "', '" + HttpContext.Current.Session["CentreID"].ToString() +"')  ";
                dt = StockReports.GetDataTable(sql);
                File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
                HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.DoctorCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
}

