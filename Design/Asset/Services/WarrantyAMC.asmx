<%@ WebService Language="C#" Class="WarrantyAMC" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WarrantyAMC : System.Web.Services.WebService
{
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public string SearchGRNDataforWarrantyAMC(string DateSearchBy, string FromDate, string ToDate, string SearchID, string SearchValue, string IsPending, string PendingID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT st.LedgerTransactionNo AS GRNNo,DATE_FORMAT(st.PurchaseDate,'%d-%b-%Y')PurchaseDate, st.InvoiceNo, DATE_FORMAT(st.InvoiceDate,'%d-%b-%Y')InvoiceDate,  ");
        sb.Append("im.TypeName AS ItemName,im.ItemID,eam.BatchNumber,eam.ModelNo,eam.SerialNo,eam.AssetNo,eam.ID as AssetID, ");
        sb.Append("IF(IFNULL(eaw.ID,0)=0,0,1)IsWarrantyEntered,IF(IFNULL(ead.ID,0)=0,0,1)IsAmcEntered,IF(IFNULL(eid.ID,0)=0,0,1)IsInsuranceEntered, ");
        sb.Append("IF(IFNULL(esd.ID,0)=0,0,1)IsServiceEntered  ");
        sb.Append("FROM eq_Asset_stock st  ");
        sb.Append("Inner join eq_asset_master eam on eam.ID= st.AssetID ");
        sb.Append("INNER JOIN f_itemmaster im ON im.itemID = st.ItemID ");
        sb.Append("LEFT JOIN eq_assetwarrantydetail eaw ON eaw.AssetID=eam.ID AND eaw.IsActive=1 ");
        sb.Append("LEFT JOIN eq_AMC_detail ead ON ead.AssetID= eam.ID AND ead.IsActive=1 ");
        sb.Append("LEFT JOIN eq_Insurance_detail eid ON eid.AssetID= eam.ID AND eid.IsActive=1 ");
        sb.Append("LEFT JOIN eq_ServiceProvider_detail esd ON esd.AssetID=eam.ID AND esd.IsActive=1 ");

        sb.Append("WHERE st.IsPost=1 ");
        if (DateSearchBy == "G")
            sb.Append("AND st.PurchaseDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND st.PurchaseDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        else if (DateSearchBy == "I")
            sb.Append("AND st.InvoiceDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND st.InvoiceDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (!string.IsNullOrEmpty(SearchValue))
        {
            if (SearchID == "B")
            {
                sb.Append("AND st.BatchNumber ='" + SearchValue + "' ");
            }
            else if (SearchID == "M")
            {
                sb.Append("AND eam.ModelNo ='" + SearchValue + "' ");
            }
            else if (SearchID == "S")
            {
                sb.Append(" AND eam.SerialNo='" + SearchValue + "' ");
            }
            else if (SearchID == "A")
            {
                sb.Append(" AND eam.AssetNo ='" + SearchValue + "' ");
            }
        }
        if (IsPending == "1")
        {
            if(PendingID=="W")
                sb.Append(" AND IFNULL(eaw.ID,0)=0 ");
            else if (PendingID == "A")
                sb.Append(" AND IFNULL(ead.ID,0)=0 ");
            else if (PendingID == "I")
                sb.Append(" AND IFNULL(eid.ID,0)=0 ");
            else
                sb.Append(" AND IFNULL(esd.ID,0)=0 ");

        }
        sb.Append("");
        sb.Append("GROUP BY eam.ID  ");
        sb.Append("ORDER BY st.LedgerTransactionNo,im.TypeName,st.ID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string SaveWarrantyDetails(List<AssetWarranty> warranty, List<itemdetails> ItemDetails, List<AccessoriesWarranty> accessories)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            ItemDetails.ForEach(i =>
            {
                var IsExist = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM eq_AssetWarrantyDetail WHERE AssetID =@AssetID AND IsActive=1", CommandType.Text, new
                {
                    AssetID = i.AssetID,
                }));
                if (IsExist > 0)
                {
                    string sql = "UPDATE eq_AssetWarrantyDetail SET Isactive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() WHERE AssetID=@AssetID";
                    excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        UpdatedBy = UserID,
                    });
                }
                warranty.ForEach(j =>
                {
                    string sqlCMD = "INSERT INTO eq_assetwarrantydetail (AssetID,ItemID,LedgerTransactionNo,StockID,SupplierID,WarrantyFromDate,WarrantyToDate,Period,Remarks,CreatedBy) VALUES(@AssetID,@ItemID,@LedgerTransactionNo,@StockID,@SupplierID,@WarrantyFromDate,@WarrantyToDate,@Period,@Remarks,@CreatedBy);";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                   {
                       AssetID = i.AssetID,
                       ItemID = i.ItemID,
                       LedgerTransactionNo = i.GRNNo,
                       StockID = i.StockID,
                       SupplierID = j.SupplierID,
                       WarrantyFromDate = Util.GetDateTime(j.WarrantyFrom).ToString("yyyy-MM-dd"),
                       WarrantyToDate = Util.GetDateTime(j.WarrantyTo).ToString("yyyy-MM-dd"),
                       Period = j.Period,
                       Remarks = j.Remarks,
                       CreatedBy = UserID,
                   });
                });
            });
            accessories.ForEach(i =>
            {
                var IsExist = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM eq_accessories_warrantydetail WHERE AssetID =@AssetID and AccessoriesID=@AccessoriesID AND IsActive=1", CommandType.Text, new
                {
                    AssetID = i.AssetID,
                    AccessoriesID = i.AccessoriesID
                }));
                if (IsExist > 0)
                {
                    string sql = "UPDATE eq_accessories_warrantydetail SET Isactive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() WHERE AssetID=@AssetID and AccessoriesID=@AccessoriesID";
                    excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        AccessoriesID = i.AccessoriesID,
                        UpdatedBy = UserID,
                    });
                }
                string sqlCMD = "INSERT INTO eq_accessories_warrantydetail (AssetID,ItemID,AccessoriesID,SupplierID,WarrantyFromDate,WarrantyToDate,Period,Remarks,CreatedBy) VALUES(@AssetID,@ItemID,@AccessoriesID,@SupplierID,@WarrantyFromDate,@WarrantyToDate,@Period,@Remarks,@CreatedBy);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    AssetID = i.AssetID,
                    ItemID = i.ItemID,
                    AccessoriesID = i.AccessoriesID,
                    SupplierID = i.SupplierID,
                    WarrantyFromDate = Util.GetDateTime(i.WarrantyFrom).ToString("yyyy-MM-dd"),
                    WarrantyToDate = Util.GetDateTime(i.WarrantyTo).ToString("yyyy-MM-dd"),
                    Period = i.Period,
                    Remarks = i.Remarks,
                    CreatedBy = UserID,
                });

            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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
    [WebMethod(EnableSession = true)]
    public string SaveAMCDetails(List<Amc> amc, List<itemdetails> ItemDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            ItemDetails.ForEach(i =>
            {
                var IsExist = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM eq_AMC_detail WHERE AssetID =@AssetID AND IsActive=1", CommandType.Text, new
                {
                    AssetID = i.AssetID,
                }));
                if (IsExist > 0)
                {
                    string sql = "UPDATE eq_AMC_detail SET Isactive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() WHERE AssetID=@AssetID";
                    excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        UpdatedBy = UserID,
                    });
                }
                amc.ForEach(j =>
                {
                    var visitno = j.NoOfVisit == "" ? 0 : 1;
                    string sqlCMD = "INSERT INTO eq_AMC_detail (AssetID,ItemID,SupplierID,WarrantyFromDate,WarrantyToDate,AMCAmount,NoOfVisit,Remarks,CreatedBy) VALUES(@AssetID,@ItemID,@SupplierID,@WarrantyFromDate,@WarrantyToDate,@AMCAmount,@NoOfVisit,@Remarks,@CreatedBy);";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        ItemID = i.ItemID,
                        SupplierID = j.SupplierID,
                        WarrantyFromDate = Util.GetDateTime(j.WarrantyFrom).ToString("yyyy-MM-dd"),
                        WarrantyToDate = Util.GetDateTime(j.WarrantyTo).ToString("yyyy-MM-dd"),
                        AMCAmount = Util.GetDecimal(j.Amount),
                        NoOfVisit = visitno,
                        Remarks = j.Remarks,
                        CreatedBy = UserID,
                    });
                });
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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

    [WebMethod(EnableSession = true)]
    public string SaveInsuranceDetails(List<Insurance> insurance, List<itemdetails> ItemDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            ItemDetails.ForEach(i =>
            {
                var IsExist = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM eq_Insurance_detail WHERE AssetID =@AssetID AND IsActive=1", CommandType.Text, new
                {
                    AssetID = i.AssetID,
                }));
                if (IsExist > 0)
                {
                    string sql = "UPDATE eq_Insurance_detail SET Isactive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() WHERE AssetID=@AssetID";
                    excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        UpdatedBy = UserID,
                    });
                }
                insurance.ForEach(j =>
                {
                    string sqlCMD = "INSERT INTO eq_Insurance_detail (AssetID,ItemID,SupplierID,FromDate,ToDate,InsuranceAmount,RiskCoverageAmount,Remarks,CreatedBy) VALUES(@AssetID,@ItemID,@SupplierID,@FromDate,@ToDate,@InsuranceAmount,@RiskCoverageAmount,@Remarks,@CreatedBy);";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        ItemID = i.ItemID,
                        SupplierID = j.SupplierID,
                        FromDate = Util.GetDateTime(j.FromDate).ToString("yyyy-MM-dd"),
                        ToDate = Util.GetDateTime(j.ToDate).ToString("yyyy-MM-dd"),
                        InsuranceAmount = Util.GetDecimal(j.InsuranceAmount),
                        RiskCoverageAmount = Util.GetDecimal(j.RiskCoverageAmount),
                        Remarks = j.Remarks,
                        CreatedBy = UserID,
                    });
                });
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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


    [WebMethod(EnableSession = true)]
    public string SaveServiceProviderDetails(List<ServiceProvider> serviceprovider, List<itemdetails> ItemDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            ItemDetails.ForEach(i =>
            {
                var IsExist = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM eq_ServiceProvider_detail WHERE AssetID =@AssetID AND IsActive=1", CommandType.Text, new
                {
                    AssetID = i.AssetID,
                }));
                if (IsExist > 0)
                {
                    string sql = "UPDATE eq_ServiceProvider_detail SET Isactive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() WHERE AssetID=@AssetID";
                    excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        UpdatedBy = UserID,
                    });
                }
                serviceprovider.ForEach(j =>
                {
                    string sqlCMD = "INSERT INTO eq_ServiceProvider_detail (AssetID,ItemID,SupplierID,Remarks,CreatedBy) VALUES(@AssetID,@ItemID,@SupplierID,@Remarks,@CreatedBy);";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        ItemID = i.ItemID,
                        SupplierID = j.SupplierID,
                        Remarks = j.Remarks,
                        CreatedBy = UserID,
                    });
                });
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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
    [WebMethod(EnableSession = true)]
    public string SaveNotApplicableDetails(List<NotApplicable> notapplicable, List<itemdetails> ItemDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            ItemDetails.ForEach(i =>
            {
                var IsExist = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM eq_NotApplicable_detail WHERE AssetID =@AssetID AND IsActive=1", CommandType.Text, new
                {
                    AssetID = i.AssetID,
                }));
                if (IsExist > 0)
                {
                    string sql = "UPDATE eq_NotApplicable_detail SET Isactive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() WHERE AssetID=@AssetID";
                    excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        UpdatedBy = UserID,
                    });
                }
                notapplicable.ForEach(j =>
                {
                    string sqlCMD = "INSERT INTO eq_NotApplicable_detail (AssetID,ItemID,Detail,Remarks,CreatedBy) VALUES(@AssetID,@ItemID,@Detail,@Remarks,@CreatedBy);";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        ItemID = i.ItemID,
                        Detail = j.DetailID,
                        Remarks = j.Remarks,
                        CreatedBy = UserID,
                    });
                });
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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


    public class AssetWarranty
    {
        public string SupplierID { get; set; }
        public string WarrantyFrom { get; set; }
        public string WarrantyTo { get; set; }
        public string Period { get; set; }
        public string Remarks { get; set; }
    }
    public class AccessoriesWarranty
    {
        public string SupplierID { get; set; }
        public string ItemID { get; set; }
        public string AssetID { get; set; }
        public string AccessoriesID { get; set; }
        public string WarrantyFrom { get; set; }
        public string WarrantyTo { get; set; }
        public string Period { get; set; }
        public string Remarks { get; set; }
    }
    public class itemdetails
    {
        public string ItemID { get; set; }
        public string ItemName { get; set; }
        public string AssetID { get; set; }
        public string GRNNo { get; set; }
        public string StockID { get; set; }
    }
    public class Amc
    {
        public string SupplierID { get; set; }
        public string WarrantyFrom { get; set; }
        public string WarrantyTo { get; set; }
        public string Amount { get; set; }
        public string NoOfVisit { get; set; }
        public string Remarks { get; set; }
    }
    public class Insurance
    {
        public string SupplierID { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string InsuranceAmount { get; set; }
        public string RiskCoverageAmount { get; set; }
        public string Remarks { get; set; }
    }
    public class ServiceProvider
    {
        public string SupplierID { get; set; }
        public string Remarks { get; set; }
    }
    public class NotApplicable
    {
        public string DetailID { get; set; }
        public string Remarks { get; set; }
    }

    [WebMethod]
    public string BindAssetDocument(string AssetID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT edm.ID,edm.DocumentName, ");
        sb.Append("IFNULL(edd.ID,0)Visible,IF(IFNULL(edd.url,'')='','false','true')STATUS,IFNULL(edd.Remark,'')Remark,  ");
        sb.Append("IFNULL(edd.Url,'')Url,IFNULL(FileName,'')FileName, IF(IFNULL(edd.Url,'')='','false','true')FileStatus,IFNULL(DATE_FORMAT(edd.UploadDate,'%d-%b-%y %I:%i %p'),'')Upload_Date ");
        sb.Append("FROM eq_Asset_DocumentMaster edm  ");
        sb.Append("LEFT JOIN eq_Asset_documentdetails edd ON edm.ID = edd.DocumentID AND edd.AssetID="+AssetID+" ");
        sb.Append("WHERE edm.IsActive=1 Order By DocumentName ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string LoadWarrantyDetails(string AssetID) 
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT lm.LedgerNumber AS SupplierID, lm.LedgerName AS SupplierName,DATE_FORMAT(ewd.WarrantyFromDate,'%d-%b-%Y')WarrantyFrom,DATE_FORMAT(ewd.WarrantyToDate,'%d-%b-%Y')WarrantyTo , ");
        sb.Append("ewd.Period,ewd.Remarks,CONCAT(em.Title,'',em.Name)CreatedBy,DATE_FORMAT(ewd.CreatedDateTime,'%d-%b-%Y')CreatedDate ");
        sb.Append("FROM eq_assetwarrantydetail ewd  ");
        sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = ewd.SupplierID ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID= ewd.CreatedBy ");
        sb.Append("WHERE ewd.AssetID="+AssetID+" AND ewd.IsActive=1; ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
     [WebMethod]
    public string LoadAMCDetails(string AssetID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT lm.LedgerNumber AS SupplierID, lm.LedgerName AS SupplierName,DATE_FORMAT(ead.WarrantyFromDate,'%d-%b-%Y')WarrantyFrom,DATE_FORMAT(ead.WarrantyToDate,'%d-%b-%Y')WarrantyTo , ");
        sb.Append("ead.AMCAmount,ead.NoOfVisit,ead.Remarks, ");
        sb.Append("CONCAT(em.Title,'',em.Name)CreatedBy,DATE_FORMAT(ead.CreatedDateTime,'%d-%b-%Y')CreatedDate ");
        sb.Append("FROM eq_amc_detail ead  ");
        sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = ead.SupplierID ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID= ead.CreatedBy ");
        sb.Append("WHERE ead.AssetID="+AssetID+" AND ead.IsActive=1; ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
     [WebMethod]
     public string LoadInsuranceDetails(string AssetID)
     {
         StringBuilder sb = new StringBuilder();
         sb.Append("SELECT lm.LedgerNumber AS SupplierID, lm.LedgerName AS SupplierName,DATE_FORMAT(eid.FromDate,'%d-%b-%Y')FromDate,DATE_FORMAT(eid.ToDate,'%d-%b-%Y')ToDate , ");
         sb.Append("eid.InsuranceAmount,eid.RiskCoverageAmount,eid.Remarks, ");
         sb.Append("CONCAT(em.Title,'',em.Name)CreatedBy,DATE_FORMAT(eid.CreatedDateTime,'%d-%b-%Y')CreatedDate ");
         sb.Append("FROM eq_insurance_detail eid  ");
         sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = eid.SupplierID ");
         sb.Append("INNER JOIN employee_master em ON em.EmployeeID= eid.CreatedBy ");
         sb.Append("WHERE eid.AssetID=" + AssetID + " AND eid.IsActive=1; ");

         return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
     }
     [WebMethod]
     public string LoadServiceProviderDetails(string AssetID)
     {
         StringBuilder sb = new StringBuilder();
         sb.Append("SELECT lm.LedgerNumber AS SupplierID, lm.LedgerName AS SupplierName,esd.Remarks, ");
         sb.Append("vm.ContactPerson,CONCAT(vm.Address1,' ',vm.City)Address,vm.Mobile, ");
         sb.Append("CONCAT(em.Title,'',em.Name)CreatedBy,DATE_FORMAT(esd.CreatedDateTime,'%d-%b-%Y')CreatedDate ");
         sb.Append("FROM eq_serviceprovider_detail esd  ");
         sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = esd.SupplierID ");
         sb.Append("INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID`  ");
         sb.Append("INNER JOIN employee_master em ON em.EmployeeID= esd.CreatedBy ");
         sb.Append("WHERE esd.AssetID=" + AssetID + " AND esd.IsActive=1; ");

         return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
     }
     [WebMethod(EnableSession=true)]
     public string SaveInstallationDetails(string Date, string By, string Remarks,string AssetID)
     {
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try
         {
             var sqlCMD = "Update eq_Asset_Master set InstallationDate=@InstallationDate,InstallationBy=@InstallationBy,InstallationRemarks=@InstallationRemarks,InstallationEntryBy=@InstallationEntryBy where ID=@AssetID";
             excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
             {
                 InstallationEntryBy = HttpContext.Current.Session["ID"].ToString(),
                 InstallationRemarks = Remarks,
                 InstallationBy = By,
                 InstallationDate=Util.GetDateTime(Date).ToString("yyy-MM-dd"),
                 AssetID=AssetID,
             });
             tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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
    
    
}