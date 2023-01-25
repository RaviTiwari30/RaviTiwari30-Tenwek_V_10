using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Collections;
using System.Web.Services;
using System.Text;
using System.Collections.Generic;
using System.Web;


public partial class Design_EDP_IPDPackageMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPanelCompany();            
        }
    }

    private void LoadPanelCompany()
    {
        DataTable dtPanel = All_LoadData.LoadPanelOPD();
        if (dtPanel.Rows.Count > 0)
        {
            chlPanel.DataSource = dtPanel;
            chlPanel.DataTextField = "Company_Name";
            chlPanel.DataValueField = "PanelID";
            chlPanel.DataBind();
        }
        else
        {
            chlPanel.Items.Clear();
        }
    }

    [WebMethod]
    public static string BindPkgCategory(string ConfigID) 
    {
        DataTable dt = StockReports.GetDataTable(" SELECT cm.CategoryID,cm.NAME FROM f_categorymaster  cm INNER JOIN f_configrelation cf ON cm.CategoryID = cf.CategoryID WHERE cf.ConfigID ='" + ConfigID + "' AND cm.Active=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string BindPkgSubCategory(string ConfigID, string CategoryID)
    {
        string str = " SELECT sc.SubCategoryID,Sc.NAME FROM f_subcategorymaster sc INNER JOIN f_categorymaster cm ON sc.CategoryID=cm.CategoryID INNER JOIN f_configrelation cf ON cm.CategoryID = cf.CategoryID WHERE sc.Active=1 and cf.ConfigID='" + ConfigID + "' ";
        if (CategoryID != "0")
            str += " and sc.CategoryID = '" + CategoryID + "'";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string BindIPDPackageMaster(string ConfigID, string CategoryID, string SubCategoyrID)
    {
        string str = "SELECT PackageID ID,PackageName Name FROM PackageMasteripd pm INNER JOIN f_itemmaster im ON im.Type_ID = pm.PackageID INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_categorymaster cm ON sc.CategoryID=cm.CategoryID INNER JOIN f_configrelation cf ON cm.CategoryID = cf.CategoryID WHERE cf.ConfigID='" + ConfigID + "' AND sc.Active=1 AND im.isActive=1";
        if (CategoryID != "0")
            str += " and sc.CategoryID = '" + CategoryID + "'";
        if (SubCategoyrID != "0")
            str += " and im.SubCategoryID = '" + SubCategoyrID + "'";

        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public static string BindAllCategory()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT CONCAT(cm.CategoryID,'#',cf.configID)CategoryID,cm.NAME FROM f_categorymaster  cm INNER JOIN f_configrelation cf ON cm.CategoryID = cf.CategoryID WHERE cf.ConfigID IN( 2,8,6,11,24,26,3,1,22,25,27,20) AND cm.Active=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string BindAllSubCategory(string CategoryID)
    {
        string str = "";
        if (CategoryID == "11")
        {
            str = " Select Concat(DeptID,'#','11','#',22,'#','IPD Surgery') as SubCategoryID, Name From Surdept_master  where IsActive=1 ";
        }
        else
        {
            str = " SELECT CONCAT(sc.SubCategoryID,'#',cm.CategoryID,'#',cf.configID,'#',cm.Name)SubCategoryID,Sc.NAME FROM f_subcategorymaster sc INNER JOIN f_categorymaster cm ON sc.CategoryID=cm.CategoryID INNER JOIN f_configrelation cf ON cm.CategoryID = cf.CategoryID WHERE sc.Active=1 and cf.configID IN( 2,8,6,11,24,26,3,1,25,27,20)  ";
            if (CategoryID != "0")
                str += " and sc.CategoryID = '" + CategoryID + "'";
        }
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string BindAllItems(int searchType, string prefix, string Type, string CategoryID, string SubCategoryID, string itemID) 
    {
        string str = "";
        if (CategoryID == "11")
        {
            str = "  SELECT sm.Surgery_ID ItemID , sm.Name TypeName,sdm.DeptID AS 'SubCategoryID',sdm.Name AS 'SubCategoryName' ,'11' AS 'CategoryID', 'IPD SURGERY' AS 'CategoryName', '22' AS configID FROM f_surgery_master sm inner join Surdept_master sdm on sdm.Name = sm.Department  WHERE  sm.IsActive=1 ";
            if(SubCategoryID!="0")
                str += " sdp.DeptID ='" + SubCategoryID + "'"; ;
            str += "ORDER BY sm.Name"; ;
        }
        else
        {
            str = " SELECT ItemID, TypeName,im.SubCategoryID,sc.Name AS SubCategoryName,sc.CategoryID,cm.Name AS 'CategoryName',cf.configID FROM f_itemmaster im  INNER JOIN f_subcategorymaster sc  ON im.SubCategoryID=sc.SubCategoryID  INNER JOIN f_categorymaster  cm ON sc.CategoryID=cm.CategoryID  INNER JOIN f_configrelation cf ON cm.CategoryID = cf.CategoryID WHERE  cf.configID IN( 2,8,6,11,24,26,3,1,25,27,20) ";
            if (CategoryID != "0")
                str = str + " AND cm.CategoryID='" + CategoryID.ToString() + "'  ";
            if(SubCategoryID !="0")
                str = str + " AND sc.SubCategoryID='" + SubCategoryID + "' "; 
            str = str + " AND cm.Active=1 AND sc.Active=1 AND im.IsActive=1 ";
            str = str + " AND TypeName LIKE '%" + prefix + "%'";
            str = str + " ORDER BY TypeName";
        }

        return  Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }

    [WebMethod]
    public static string BindPackageMasterDetails(string PackageID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pm.PackageID,pm.ItemID,pm.Packagename,pm.IsActive,IFNULL(pm.DaysInvolved,0)DaysInvolved,sc.SubCategoryID,cm.CategoryID,pm.PanelID FROM PackageMasteripd pm ");
        sb.Append("INNER JOIN f_itemmaster im ON pm.ItemID=im.ItemID ");
        sb.Append("INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
        sb.Append("INNER JOIN f_categorymaster cm ON cm.CategoryID=sc.CategoryID ");
        sb.Append("WHERE pm.PackageID=" + PackageID + " "); 

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public static string BindPackageDetails(string PackageID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pmi.PackageName,pmi.PackageID,IFNULL(pmi.DaysInvolved,0)DaysInvolved,fc.CategoryID,fc.Name AS 'CategoryName', ");
        sb.Append("pid.SubCategoryID,IFNULL((SELECT NAME FROM f_subcategorymaster WHERE SubCategoryID=pid.SubCategoryID),'') 'SubCategoryName',pid.Quantity,pid.Amount,cf.configID,pid.Detail_ItemID AS 'ItemID', ");
        sb.Append("IFNULL(IF(pid.issurgery=1,(SELECT NAME FROM f_surgery_master WHERE Surgery_ID=pid.`Detail_ItemID`), ");
        sb.Append("(SELECT typename FROM f_itemmaster WHERE itemid=pid.`Detail_ItemID`)),'')ItemName, ");
        sb.Append("IF(PackageType=1,'CategoryWise',IF(PackageType=2,'ItemWise','SubCategoryWise'))PackageType,IFNULL(pmi.DaysInvolved,0)DaysInvolved  ");
        sb.Append("FROM  packagemasteripd_details pid  ");
        sb.Append("INNER JOIN PackageMasteripd pmi ON pid.PackageId=pmi.PackageID  ");
        sb.Append("INNER JOIN f_categorymaster fc ON pid.CategoryID=fc.CategoryID  ");
        sb.Append("INNER JOIN f_configrelation cf ON fc.CategoryID = cf.CategoryID  WHERE pid.PackageId='" + PackageID + "' AND pid.IsActive=1 ORDER BY fc.Name  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SavePackage(packagemaster packageMaster, List<packagedetails> packageDetails)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string sqlCMD = "SELECT COUNT(*) FROM PackageMasteripd WHERE PackageName=@PackageName";
            var isExist= Util.GetInt( excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
            {
                PackageName=packageMaster.PackageName
            }));
            if (isExist > 0) 
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Package Name Already Exists !!!" }); ;
            }

            //Insert int Package Master table
            sqlCMD = "INSERT INTO packagemasteripd (Packagename,IsActive,UserID,DaysInvolved,PanelID) ";
            sqlCMD += " VALUES(@Packagename, @IsActive,  @UserID,    @DaysInvolved, @PanelID); SELECT @@identity;";
            var PackageID = excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
            {
                Packagename= packageMaster.PackageName,
                IsActive = packageMaster.IsActive,
                UserID=HttpContext.Current.Session["ID"].ToString(),
                DaysInvolved= Util.GetInt(packageMaster.VaidityDays),
                PanelID = packageMaster.PanelID,
            });

            // Insert in PackageMasterDetail
            for (int i = 0; i < packageDetails.Count; i++)
            {
                var PackageType = 1;
                if (packageDetails[i].PackageType == "CategoryWise")
                {
                    PackageType = 1;
                }
                else if (packageDetails[i].PackageType == "SubCategoryWise")
                {
                    PackageType = 3;
                }
                else if (packageDetails[i].PackageType == "ItemWise")
                {
                    PackageType = 2;
                }
 
                sqlCMD = " INSERT INTO packagemasteripd_details (PackageId,CategoryID,Amount,Quantity,IsActive,UserID,IsAmount,IsSurgery,Detail_ItemID,PackageType,SubCategoryID)";
                sqlCMD += " VALUES(@PackageId,@CategoryID,@Amount,@Quantity,@IsActive,@UserID,@IsAmount,@IsSurgery,@Detail_ItemID,@PackageType,@SubCategoryID);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    PackageId= PackageID,
                    CategoryID=packageDetails[i].CategoryID,
                    Amount=packageDetails[i].Amount,
                    Quantity=packageDetails[i].Quantity,
                    IsActive= packageMaster.IsActive,
                    UserID=HttpContext.Current.Session["ID"].ToString(),
                    IsAmount=packageDetails[i].IsAmount,
                    IsSurgery=packageDetails[i].IsSurgery,
                    Detail_ItemID = packageDetails[i].ItemID == "" ? "0" : packageDetails[i].ItemID,
                    PackageType = PackageType,
                    SubCategoryID = packageDetails[i].SubCategoryID == "" ? "0" : packageDetails[i].SubCategoryID,
                });
            }

            //Insert in Item Master
            var PackageItemID = string.Empty;
            ItemMaster objIMaster = new ItemMaster(tnx);
            objIMaster.Hospital_ID = "";
            objIMaster.TypeName = packageMaster.PackageName;
            objIMaster.Type_ID = Util.GetInt(PackageID);
            objIMaster.Description = packageMaster.PackageName;
            objIMaster.SubCategoryID = packageMaster.SubCategoryID;
            objIMaster.IsEffectingInventory = "NO";
            objIMaster.IsExpirable = "No";
            objIMaster.BillingUnit = "";
            objIMaster.Pulse = "";
            objIMaster.IsTrigger = "YES";
            objIMaster.StartTime = DateTime.Now;
            objIMaster.EndTime = DateTime.Now;
            objIMaster.BufferTime = "0";
            objIMaster.IsActive = 1;
            objIMaster.QtyInHand = 0;
            objIMaster.IsAuthorised = 1;
            objIMaster.IPAddress = All_LoadData.IpAddress();
            objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
            PackageItemID = objIMaster.Insert().ToString();

            //Update Package ItemID in Package tables
            sqlCMD = "UPDATE PackageMasteripd SET ItemID=@PackageItemID WHERE PackageID=@PackageID ";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
               {
                   PackageItemID = PackageItemID,
                   PackageID = PackageID,
               });

            sqlCMD = "UPDATE packagemasteripd_details SET ItemID=@PackageItemID WHERE PackageID=@PackageID ";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                PackageItemID = PackageItemID,
                PackageID = PackageID,
            });

            tnx.Commit();

            
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage }); ;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response =AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    
    [WebMethod(EnableSession = true)]
    public static string UpdatePackage(packagemaster packageMaster, List<packagedetails> packageDetails)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string sqlCMD = "SELECT COUNT(*) FROM PackageMasteripd WHERE PackageName=@PackageName and PackageID <>@PackageID";
            var isExist= Util.GetInt( excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
            {
                PackageName=packageMaster.PackageName,
                PackageID = packageMaster.PackageID,
            }));
            if (isExist > 0) 
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Package Name Already Exists !!!" }); ;
            }

            //Update Package Master table
            sqlCMD = "Update packagemasteripd set Packagename=@Packagename,IsActive=@IsActive,UserID=@UserID,DaysInvolved=@DaysInvolved,PanelID=@PanelID where PackageID =@PackageID ";
            
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Packagename= packageMaster.PackageName,
                IsActive = packageMaster.IsActive,
                UserID=HttpContext.Current.Session["ID"].ToString(),
                DaysInvolved= Util.GetInt(packageMaster.VaidityDays),
                PanelID = packageMaster.PanelID,
                PackageID =packageMaster.PackageID,
            });

            //Update Previous Entry Deactive
            sqlCMD = "Update packagemasteripd_details set IsActive=@IsActive where PackageID =@PackageID ";
             excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
             {
                 IsActive = 0,
                 PackageID = packageMaster.PackageID,
             });
            // Insert in PackageMasterDetail
            for (int i = 0; i < packageDetails.Count; i++)
            {
                var PackageType = 1;
                if (packageDetails[i].PackageType == "CategoryWise")
                {
                    PackageType = 1;
                }
                else if (packageDetails[i].PackageType == "SubCategoryWise")
                {
                    PackageType = 3;
                }
                else if (packageDetails[i].PackageType == "ItemWise")
                {
                    PackageType = 2;
                }
 
                sqlCMD = " INSERT INTO packagemasteripd_details (PackageId,ItemID,CategoryID,Amount,Quantity,IsActive,UserID,IsAmount,IsSurgery,Detail_ItemID,PackageType,SubCategoryID)";
                sqlCMD += " VALUES(@PackageId,@PackageItemID,@CategoryID,@Amount,@Quantity,@IsActive,@UserID,@IsAmount,@IsSurgery,@Detail_ItemID,@PackageType,@SubCategoryID);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    PackageId= packageMaster.PackageID,
                    PackageItemID =packageMaster.PackageItemID,
                    CategoryID=packageDetails[i].CategoryID,
                    Amount=packageDetails[i].Amount,
                    Quantity=packageDetails[i].Quantity,
                    IsActive= packageMaster.IsActive,
                    UserID=HttpContext.Current.Session["ID"].ToString(),
                    IsAmount=packageDetails[i].IsAmount,
                    IsSurgery=packageDetails[i].IsSurgery,
                    Detail_ItemID = packageDetails[i].ItemID == "" ? "0" : packageDetails[i].ItemID,
                    PackageType = PackageType,
                    SubCategoryID = packageDetails[i].SubCategoryID == "" ? "0" : packageDetails[i].SubCategoryID,
                });
            }

            sqlCMD = "UPDATE f_itemmaster SET SubCategoryID=@SubCategoryID ,TypeName =@Packagename,Description=@Packagename,IsActive=@IsActive,LastUpdatedBy=@UserID,Updatedate=@UpdateDate WHERE itemid =@PackageItemID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
           {
               SubCategoryID= packageMaster.SubCategoryID,
               Packagename = packageMaster.PackageName,
               IsActive = packageMaster.IsActive,
               UserID = HttpContext.Current.Session["ID"].ToString(),
               UpdateDate =DateTime.Now.ToString("yyyy-MM-dd"),
               PackageItemID =packageMaster.PackageItemID,
           });
           
            tnx.Commit();

            
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" }); ;
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
    public class packagemaster
    {
        public string CategoryID { get; set; }
        public string SubCategoryID { get; set; }
        public string PackageID { get; set; }
        public string PackageName { get; set; }
        public string VaidityDays { get; set; }
        public string IsActive { get; set; }
        public string PackageItemID { get; set; }
        public string PanelID { get; set; }
    }
    public class packagedetails
    {
        public string PackageType { get; set; }
        public string CategoryID { get; set; }
        public string SubCategoryID { get; set; }
        public string ItemID { get; set; }
        public string Quantity { get; set; }
        public string Amount { get; set; }
        public string IsSurgery { get; set; }
        public string IsAmount { get; set; }
    }

}