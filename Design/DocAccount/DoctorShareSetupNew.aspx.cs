using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class Design_DocAccount_DoctorShareSetupNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ViewState["CurrentCentreID"] = Session["CentreID"].ToString();
    }

    [WebMethod(EnableSession = true)]
    public static string bindDoctorShareControls()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" CALL bindDoctorShareControls(); "));
    }

    [WebMethod(EnableSession = true)]
    public static string CreateDoctorShareTempTable()
    {
        //    string tblName = "CategoryWiseReferralWise_mapping_" + HttpContext.Current.Session["ID"].ToString();
        //    StockReports.ExecuteDML(" DROP TABLE IF EXISTS " + tblName + " ; ");
        //    StockReports.ExecuteDML(" CREATE TABLE " + tblName + " ( `ID` INT(11) NOT NULL AUTO_INCREMENT,`CategoryID` INT(11) DEFAULT 0,`CategoryName` VARCHAR(100) DEFAULT '',`ReferralTypeID` INT(11) DEFAULT 0,`ReferralType` VARCHAR(50) DEFAULT '',PRIMARY KEY (`ID`),KEY `CategoryID` (`CategoryID`), KEY `ReferralTypeID` (`ReferralTypeID`) ); ");
        //    StockReports.ExecuteDML(" INSERT INTO " + tblName + " (CategoryID,CategoryName,ReferralTypeID,ReferralType) SELECT cm.`CategoryID`,cm.`NAME` AS CategoryName,rm.ID AS ReferralTypeID,RM.`ReferalType` FROM `f_categorymaster` cm CROSS JOIN referraltype_master rm WHERE rm.`IsActive`=1 AND cm.`Active`=1 ; ");


        //    tblName = "SurgeryItemReferralWise_mapping_" + HttpContext.Current.Session["ID"].ToString();
        //    StockReports.ExecuteDML(" DROP TABLE IF EXISTS " + tblName + " ; ");
        //    StockReports.ExecuteDML(" CREATE TABLE " + tblName + " ( `ID` INT(11) NOT NULL AUTO_INCREMENT,`CategoryID` INT(11) DEFAULT 0,`SubCategoryID` INT(11) DEFAULT 0,`ItemID` INT(11) DEFAULT 0,`ItemName` VARCHAR(100) DEFAULT '',`ReferralTypeID` INT(11) DEFAULT 0,`ReferralType` VARCHAR(50) DEFAULT '',PRIMARY KEY (`ID`),KEY `CategoryID` (`CategoryID`),KEY `SubCategoryID` (`SubCategoryID`),KEY `ItemID` (`ItemID`), KEY `ReferralTypeID` (`ReferralTypeID`) ); ");
        //    StockReports.ExecuteDML(" INSERT INTO " + tblName + " (CategoryID,SubCategoryID,ItemID,ItemName,ReferralTypeID,ReferralType) SELECT sc.`CategoryID`,sc.`SubCategoryID`,im.`ItemID`,im.`TypeName`,rm.ID AS ReferralTypeID,RM.`ReferalType` FROM `f_itemmaster` im INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubcategoryID` INNER JOIN `f_configrelation` cf ON cf.`CategoryID`=sc.`CategoryID` AND cf.`ConfigID`=22 AND cf.`IsActive`=1 CROSS JOIN referraltype_master rm WHERE rm.`IsActive`=1 AND im.`IsActive`=1 AND im.`Type_ID` IN(1,2) ORDER BY TypeName,ReferalType ; ");

        return "1";
    }

    [WebMethod(EnableSession = true)]
    public static string bindDoctorShareCentreWiseDoctorWise(int gridType, int centreID, int doctorID, int shareType, int panelGroupID, int panelID, int serviceType, int packageID, int categoryID, int subCategoryID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();

        if (serviceType != 4)
        {
            string tblName = string.Empty;

            string ConfigIds = string.Empty;

            if (serviceType == 1)
            {
                // tblName = "CategoryWiseReferralWise_mapping_" + HttpContext.Current.Session["ID"].ToString();
                tblName = "CategoryWiseReferralWise_mapping_EMP001";
                ConfigIds = Resources.Resource.AllowDoctorShareOnConfigIDs;
            }
            else if (serviceType == 3)
            {
                // tblName = "SurgeryItemReferralWise_mapping_" + HttpContext.Current.Session["ID"].ToString();
                tblName = "SurgeryItemReferralWise_mapping_EMP001";
            }
            else
            {
                ConfigIds = Resources.Resource.ExcludeConfigIDsFromIPDPackageInDoctorShare;
            }

            DataTable dtDoctorShare = excuteCMD.GetDataTable("  CALL bindDoctorShareCentreWiseDoctorWise(@GridType,@TableName,@CentreID,@DoctorID,@ShareType,@PanelGroupID,@PanelID,@ServiceType,@ConfigIDs,@ReferralTypeIDs,@PackageID,@CategoryID,@SubCategoryID) ", CommandType.Text, new
            {
                GridType = gridType,
                TableName = tblName,
                CentreID = centreID,
                DoctorID = doctorID,
                ShareType = shareType,
                PanelGroupID = panelGroupID,
                PanelID = panelID,
                ServiceType = serviceType,
                ConfigIDs = ConfigIds,
                ReferralTypeIDs = "",
                PackageID = packageID,
                CategoryID = categoryID,
                SubCategoryID = subCategoryID
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDoctorShare);
        }
        else
        {
            DataTable dtDoctorConfiguration = excuteCMD.GetDataTable("  CALL bindDoctorConfiguration(@CentreID,@DoctorID,@ConfigIDs,1) ", CommandType.Text, new
            {
                CentreID = centreID,
                DoctorID = doctorID,
                ConfigIDs = Resources.Resource.AllowDoctorShareOnConfigIDs,
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDoctorConfiguration);


        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindUnitDoctorShareDetails(int centreID, int doctorID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dtDoctorConfiguration = excuteCMD.GetDataTable("  CALL bindDoctorConfiguration(@CentreID,@DoctorID,@ConfigIDs,2) ", CommandType.Text, new
        {
            CentreID = centreID,
            DoctorID = doctorID,
            ConfigIDs = Resources.Resource.AllowDoctorShareOnConfigIDs,
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dtDoctorConfiguration);
    }

    [WebMethod(EnableSession = true)]
    public static string saveDoctorShare(System.Collections.Generic.List<CentrewiseDoctorShare> DoctorShare)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            for (int i = 0; i < DoctorShare.Count; i++)
            {
                var item = DoctorShare[i];
                item.CreatedBy = HttpContext.Current.Session["ID"].ToString();

                if (i == 0)
                {
                    if (item.GridType == 1)
                        excuteCMD.DML(tnx, "UPDATE docacc_doctorsharesetup d SET d.`IsActive`=0,d.`UpdatedBy`=@CreatedBy,d.`UpdatedDateTime`=NOW() WHERE d.`IsActive`=1 AND d.`CentreID`=@CentreID AND d.`DoctorID`=@DoctorID AND d.`ShareType`=@ShareType AND d.`ServiceType`=@ServiceType AND d.`PanelGroupID`=@PanelGroupID AND d.`PanelID`=@PanelID AND d.`SubCategoryID`=0 AND d.`ItemID`=0 ", CommandType.Text, item);
                    else if (item.GridType == 2)
                        excuteCMD.DML(tnx, "UPDATE docacc_doctorsharesetup d SET d.`IsActive`=0,d.`UpdatedBy`=@CreatedBy,d.`UpdatedDateTime`=NOW() WHERE d.`IsActive`=1 AND d.`CentreID`=@CentreID AND d.`DoctorID`=@DoctorID AND d.`ShareType`=@ShareType AND d.`ServiceType`=@ServiceType AND d.`PanelGroupID`=@PanelGroupID AND d.`PanelID`=@PanelID AND d.`CategoryID`=@CategoryID AND d.`SubCategoryID`<>0 AND d.`ItemID`=0 ", CommandType.Text, item);
                    else if (item.GridType == 3)
                        excuteCMD.DML(tnx, "UPDATE docacc_doctorsharesetup d SET d.`IsActive`=0,d.`UpdatedBy`=@CreatedBy,d.`UpdatedDateTime`=NOW() WHERE d.`IsActive`=1 AND d.`CentreID`=@CentreID AND d.`DoctorID`=@DoctorID AND d.`ShareType`=@ShareType AND d.`ServiceType`=@ServiceType AND d.`PanelGroupID`=@PanelGroupID AND d.`PanelID`=@PanelID AND d.`CategoryID`=@CategoryID AND d.`SubCategoryID`=@SubCategoryID AND d.`ItemID`<>0 ", CommandType.Text, item);

                }
                if (item.IsCheck == 1)
                {

                    var sqlCmd = new StringBuilder(" INSERT INTO docacc_doctorsharesetup(CentreID,DoctorID,ShareType,ServiceType,PanelGroupID,PanelID,ReferralTypeID,CategoryID,SubCategoryID,ItemID,OPDSharePer, ");
                    sqlCmd.Append(" OPDShareAmt,OPDBonusPer,OPDBonusAmt,IPDSharePer,IPDShareAmt,IPDBonusPer,IPDBonusAmt,EMGSharePer,EMGShareAmt,EMGBonusPer,EMGBonusAmt,CreatedBy,CreatedDateTime) ");
                    sqlCmd.Append(" VALUES(@CentreID, @DoctorID, @ShareType, @ServiceType, @PanelGroupID, @PanelID, @ReferralTypeID, @CategoryID, @SubCategoryID, @ItemID, @OPDSharePer,  ");
                    sqlCmd.Append(" @OPDShareAmt, @OPDBonusPer, @OPDBonusAmt, @IPDSharePer, @IPDShareAmt, @IPDBonusPer, @IPDBonusAmt, @EMGSharePer,  ");
                    sqlCmd.Append(" @EMGShareAmt, @EMGBonusPer, @EMGBonusAmt, @CreatedBy, NOW()) ");
                    excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
                }
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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
    public static string saveExcludePackageDetails(System.Collections.Generic.List<ExcludeDetails> excludeDetails, int CategoryID, int SubCategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            for (int i = 0; i < excludeDetails.Count; i++)
            {
                var item = excludeDetails[i];
                item.CreatedBy = HttpContext.Current.Session["ID"].ToString();

                if (i == 0)
                {
                    excuteCMD.DML(tnx, "UPDATE docacc_excludeservicesfrompackagesetup d SET d.`IsActive`=0,d.`UpdatedBy`=@CreatedBy,d.`UpdatedDateTime`=NOW() WHERE d.`IsActive`=1 AND d.`CentreID`=@CentreID AND d.`ShareType`=@ShareType AND d.`PanelGroupID`=@PanelGroupID AND d.`PanelID`=@PanelID AND d.`SubCategoryID`=0 AND d.`ItemID`=0 and d.PackageID=@PackageID", CommandType.Text, new
                    {
                        CentreID = item.CentreID,
                        ShareType = item.ShareType,
                        PanelGroupID = item.PanelGroupID,
                        PanelID = item.PanelID,
                        PackageID = item.PackageID,
                        CreatedBy = item.CreatedBy
                    });

                    if (CategoryID > 0)
                    {
                        excuteCMD.DML(tnx, "UPDATE docacc_excludeservicesfrompackagesetup d SET d.`IsActive`=0,d.`UpdatedBy`=@CreatedBy,d.`UpdatedDateTime`=NOW() WHERE d.`IsActive`=1 AND d.`CentreID`=@CentreID AND d.`ShareType`=@ShareType AND d.`PanelGroupID`=@PanelGroupID AND d.`PanelID`=@PanelID AND d.`CategoryID`=@categoryID AND d.`SubCategoryID`<>0 AND d.`ItemID`=0  and d.PackageID=@PackageID", CommandType.Text, new
                        {
                            CentreID = item.CentreID,
                            ShareType = item.ShareType,
                            PanelGroupID = item.PanelGroupID,
                            PanelID = item.PanelID,
                            PackageID = item.PackageID,
                            categoryID = CategoryID,
                            CreatedBy = item.CreatedBy
                        });
                    }

                    if (SubCategoryID > 0)
                    {
                        excuteCMD.DML(tnx, "UPDATE docacc_excludeservicesfrompackagesetup d SET d.`IsActive`=0,d.`UpdatedBy`=@CreatedBy,d.`UpdatedDateTime`=NOW() WHERE d.`IsActive`=1 AND d.`CentreID`=@CentreID AND d.`ShareType`=@ShareType AND d.`PanelGroupID`=@PanelGroupID AND d.`PanelID`=@PanelID AND d.`CategoryID`=@categoryID AND d.`SubCategoryID`=@subCategoryID AND d.`ItemID`<>0  and d.PackageID=@PackageID ", CommandType.Text, new
                        {
                            CentreID = item.CentreID,
                            ShareType = item.ShareType,
                            PanelGroupID = item.PanelGroupID,
                            PanelID = item.PanelID,
                            PackageID = item.PackageID,
                            categoryID = CategoryID,
                            subCategoryID = SubCategoryID,
                            CreatedBy = item.CreatedBy
                        });
                    }
                }

                var sqlCmd = new StringBuilder(" INSERT INTO docacc_excludeservicesfrompackagesetup(CentreID,ShareType,PanelGroupID,PanelID,PackageID,CategoryID,SubCategoryID,ItemID,CreatedBy,CreatedDateTime) VALUES(@CentreID, @ShareType, @PanelGroupID, @PanelID, @PackageID, @CategoryID, @SubCategoryID, @ItemID, @CreatedBy,NOW()) ");
                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);

            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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
    public static string saveDoctorConfiguration(System.Collections.Generic.List<DoctorConfiguration> DoctorConfiguration, System.Collections.Generic.List<UnitDoctorSharing> UnitDoctorSharing, int ShareCategory, decimal Salary, int ShareCalculationType, int IsWriteOffAndDeductApply)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            for (int i = 0; i < DoctorConfiguration.Count; i++)
            {
                var item = DoctorConfiguration[i];
                item.CreatedBy = HttpContext.Current.Session["ID"].ToString();

                if (i == 0)
                    excuteCMD.DML(tnx, "UPDATE docAcc_DoctorWiseDiscountBeared d SET d.`IsActive`=0,d.`UpdatedBy`=@CreatedBy,d.`UpdatedDateTime`=NOW() WHERE d.`IsActive`=1 AND d.`CentreID`=@CentreID AND d.`DoctorID`=@DoctorID ", CommandType.Text, item);

                var sqlCmd = new StringBuilder(" INSERT INTO docAcc_DoctorWiseDiscountBeared(DoctorID,CentreID,CategoryID,DiscountBearedBy,CreatedBy,CreatedDateTime) VALUES(@DoctorID,@CentreID,@CategoryID,@DiscountBearedBy,@CreatedBy,NOW()) ");
                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);

            }

            excuteCMD.DML(tnx, "UPDATE docshare_centrewisedoctorwiseconfiguration d SET d.`IsActive`=0,d.`UpdatedBy`=@CreatedBy,d.`UpdatedDateTime`=NOW() WHERE d.`IsActive`=1 AND d.`CentreID`=@CentreID AND d.`DoctorID`=@DoctorID ", CommandType.Text, new
            {
                DoctorID = DoctorConfiguration[0].DoctorID,
                CentreID = DoctorConfiguration[0].CentreID,
                CreatedBy = HttpContext.Current.Session["ID"].ToString()
            });


            excuteCMD.DML(tnx, "INSERT INTO docshare_centrewisedoctorwiseconfiguration(DoctorID,CentreID,ShareCategory,Salary,ShareCalculationType,IsWriteOffAndDeductApply,CreatedBy,CreatedDateTime) VALUES(@DoctorID,@CentreID,@ShareCategory,@Salary,@ShareCalculationType,@IsWriteOffAndDeductApply,@CreatedBy,NOW()) ", CommandType.Text, new
            {
                DoctorID = DoctorConfiguration[0].DoctorID,
                CentreID = DoctorConfiguration[0].CentreID,
                ShareCategory = ShareCategory,
                Salary = Salary,
                ShareCalculationType = ShareCalculationType,
                IsWriteOffAndDeductApply = IsWriteOffAndDeductApply,
                CreatedBy = HttpContext.Current.Session["ID"].ToString()

            });

            for (int i = 0; i < UnitDoctorSharing.Count; i++)
            {
                var itemUnit = UnitDoctorSharing[i];
                itemUnit.CreatedBy = HttpContext.Current.Session["ID"].ToString();

                if (i == 0)
                    excuteCMD.DML(tnx, "UPDATE master_CentreWiseUnitdoctorsShare d SET d.`IsActive`=0,d.`UpdatedBy`=@CreatedBy,d.`UpdatedDateTime`=NOW() WHERE d.`IsActive`=1 AND d.`CentreID`=@CentreID AND d.`DoctorID`=@DoctorID ", CommandType.Text, itemUnit);

                var sqlCmd = new StringBuilder(" INSERT INTO master_CentreWiseUnitdoctorsShare(CentreID,DoctorID,UnitDoctorsID,CategoryID,OPDSharePer,IPDSharePer,EMGSharePer,CreatedBy,CreatedDateTime) VALUES(@CentreID, @DoctorID, @UnitDoctorsID, @CategoryID, @OPDSharePer, @IPDSharePer, @EMGSharePer, @CreatedBy,NOW()) ");
                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, itemUnit);

            }


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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
    public static string ReCalculateDoctorWiseShare(int doctorID, int centreID, string year,string month)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            excuteCMD.DML(tnx, " CALL ReCalculateDoctorWiseShare(@UserID,@AppliedDoctorID,@CentreID,@Year,@Month) ", CommandType.Text, new
            {
                UserID = HttpContext.Current.Session["ID"].ToString(),
                AppliedDoctorID = doctorID,
                CentreID = centreID,
                Year = year,
                Month = month
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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

    public class CentrewiseDoctorShare
    {
        public int CentreID { get; set; }
        public int DoctorID { get; set; }
        public int ShareType { get; set; }
        public int ServiceType { get; set; }
        public int PanelGroupID { get; set; }
        public int PanelID { get; set; }
        public int ReferralTypeID { get; set; }
        public int CategoryID { get; set; }
        public int SubCategoryID { get; set; }
        public int ItemID { get; set; }
        public decimal OPDSharePer { get; set; }
        public decimal OPDShareAmt { get; set; }
        public decimal OPDBonusPer { get; set; }
        public decimal OPDBonusAmt { get; set; }
        public decimal IPDSharePer { get; set; }
        public decimal IPDShareAmt { get; set; }
        public decimal IPDBonusPer { get; set; }
        public decimal IPDBonusAmt { get; set; }
        public decimal EMGSharePer { get; set; }
        public decimal EMGShareAmt { get; set; }
        public decimal EMGBonusPer { get; set; }
        public decimal EMGBonusAmt { get; set; }
        public string CreatedBy { get; set; }
        public int IsCheck { get; set; }
        public int GridType { get; set; }
    }

    public class ExcludeDetails
    {
        public int CentreID { get; set; }
        public int ShareType { get; set; }
        public int PanelGroupID { get; set; }
        public int PanelID { get; set; }
        public int PackageID { get; set; }
        public int CategoryID { get; set; }
        public int SubCategoryID { get; set; }
        public int ItemID { get; set; }
        public string CreatedBy { get; set; }
    }

    public class DoctorConfiguration
    {
        public int DoctorID { get; set; }
        public int CentreID { get; set; }
        public int CategoryID { get; set; }
        public int DiscountBearedBy { get; set; }
        public string CreatedBy { get; set; }
    }
    public class UnitDoctorSharing
    {
        public int DoctorID { get; set; }
        public int CentreID { get; set; }
        public int UnitDoctorsID { get; set; }
        public int CategoryID { get; set; }
        public decimal OPDSharePer { get; set; }
        public decimal IPDSharePer { get; set; }
        public decimal EMGSharePer { get; set; }
        public string CreatedBy { get; set; }
    }




}