<%@ WebService Language="C#" CodeBehind="~/App_Code/CenterManagement.cs" Class="CenterManagement" %>
using System;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;
using System.Security.Cryptography;
using System.Web.UI;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

public class CenterManagement : System.Web.Services.WebService
{

    [WebMethod(EnableSession = true)]
    public string UpdateCenter(object CenterDetail, int Followedcenter, int ChkSelf, string InitialCharr, int PrintBarcode, string TextPrintBarcode, int CenterID, int Active, int IsNablCenter, int IsCap)
    {
        List<Center_Master> CenterData = new JavaScriptSerializer().ConvertToType<List<Center_Master>>(CenterDetail);
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) from center_master where CentreName='" + CenterData[0].CentreName + "' and CentreId<>" + Util.GetInt(CenterID) + " "));

        if (CenterData[0].CentreName == "")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Center Name can not blank", Msg = "Center Name Should not blank" });
        }

        if (CenterData[0].CentreCode == "")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", Msg = "Please enter Center Code" });
        }

        if (CenterData[0].MobileNo == "")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", Msg = "Please enter Mobile" });
        }

        if (CenterData[0].Address == "")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", Msg = "Please enter Address" });
        }

        if (CenterData[0].DiscountType == "0")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", Msg = "Please Select Discount Type" });
        }
        
        if (count > 0)
        {
            //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator" });
            return "1";
        }

        if (ChkSelf == 1)
        {
            int isPrefix = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) from center_master where InitialChar='" + Util.GetString(InitialCharr) + "'  and CentreId<>" + Util.GetInt(CenterID) + "  AND FollowedCentreId=CentreID "));

            if (isPrefix > 0)
            {
                // lblMsg.Text = "Prefix Already Mapped with another Centre";
                // txtInitialChar.Focus();
                return "2";
            }
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            int IsDefault = 0;

            int FollowedCentre = Util.GetInt(Followedcenter);
            string InitialChar = "";

            if (ChkSelf == 1)
            {
                FollowedCentre = Util.GetInt(CenterID);
                InitialChar = Util.GetString(InitialCharr);
            }
            
            bool pb = false;
            if (PrintBarcode == 1)
            {
                pb = true;
            }

            bool nabl = false;
            if (IsNablCenter == 1)
            {
                nabl = true;
            }

            bool iscapp = false;
            if (IsCap == 1)
            {
                iscapp = true;
            }
            
             StringBuilder sb = new StringBuilder();
            sb.Append("update center_master set CentreCode='" + CenterData[0].CentreCode + "',CentreName='" + CenterData[0].CentreName + "',Website='" + CenterData[0].Website + "',Address='" + CenterData[0].Address + "',MobileNo= '" + CenterData[0].MobileNo + "',LandlineNo='" + CenterData[0].LandlineNo + "',EmailID='" + CenterData[0].EmailID + "',IsActive= '" + Active + "',DiscountType='" + CenterData[0].DiscountType + "',UpdateDate= '" + System.DateTime.Now.ToString("yyyy-MM-dd") + "',IsDefault=" + IsDefault + ",Latitude='" + Util.GetString(CenterData[0].Latitude) + "',Longitude='" + Util.GetString(CenterData[0].Longitude) + "',FollowedCentreId=" + FollowedCentre + ",InitialChar='" + InitialChar + "' ");
            sb.Append(" ,isCap='" + Util.getbooleanInt(Util.GetBoolean(iscapp)) + "' ");
            sb.Append(" ,IsNableCentre='" + Util.getbooleanInt(Util.GetBoolean(nabl)) + "' ");
            sb.Append(" ,PrePrintedBarcode='" + Util.getbooleanInt(Util.GetBoolean(pb)) + "' ");
            if (TextPrintBarcode != "" && PrintBarcode == 1)
                sb.Append(" ,LabBarcodeAbbreviation='" + TextPrintBarcode + "' ");
            sb.Append(" where CentreId=" + Util.GetInt(CenterID) + "");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = CenterID });
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveCenter(object CenterDetail, int Followedcenter, int ChkSelf, string InitialCharr, int PrintBarcode, string TextPrintBarcode, int IsNablCenter, int IsCap)
    {//object CenterDetail
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            List<Center_Master> CenterData = new JavaScriptSerializer().ConvertToType<List<Center_Master>>(CenterDetail);
            string userID = HttpContext.Current.Session["ID"].ToString();

            if (CenterData[0].CentreName == "")
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Center Name can not blank", Msg = "Center Name Should not blank" });
            }

            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) from center_master where CentreName='" + CenterData[0].CentreName + "'"));

            if (count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Center Name can not blank", Msg = "Center Name Already Exists" });
            }

            if (CenterData[0].CentreCode == "")
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", Msg = "Please enter Center Code" });
            }

            if (CenterData[0].MobileNo == "")
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", Msg = "Please enter Mobile" });
            }

            if (CenterData[0].Address == "")
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", Msg = "Please enter Address" });
            }

            if (CenterData[0].DiscountType == "0")
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", Msg = "Please Select Discount Type" });
            }
            
            Center_Master objCM = new Center_Master(tnx);
            objCM.CentreCode = CenterData[0].CentreCode;
            objCM.CentreName = CenterData[0].CentreName;
            objCM.Website = CenterData[0].Website;
            objCM.Address = CenterData[0].Address;
            objCM.MobileNo = CenterData[0].MobileNo;
            objCM.LandlineNo = CenterData[0].LandlineNo;
            objCM.EmailID = CenterData[0].EmailID;
            objCM.DiscountType = CenterData[0].DiscountType;
            objCM.IsDefault = 0;
            objCM.Latitude = CenterData[0].Latitude;
            objCM.Longitude = CenterData[0].Longitude;

            string CentreID = objCM.Insert().ToString();

            string InitialChar = "";
            if (ChkSelf == 1)
            {
                Followedcenter = Util.GetInt(CentreID);
                InitialChar = Util.GetString(InitialCharr);
            }

            string centerlogo = string.Empty;
           // centerlogo = UploadImage(FileData[0]);

            bool pb = false;
            if (PrintBarcode == 1)
            {
                pb = true;
            }

            bool nabl = false;
            if (IsNablCenter == 1)
            {
                nabl = true;
            }

            bool iscapp = false;
            if (IsCap == 1)
            {
                iscapp = true;
            }

            StringBuilder sb = new StringBuilder();
            sb.Append("update center_master set FollowedCentreId=" + Followedcenter + ",InitialChar='" + InitialChar + "',ReportHeaderURL='CLab_-01.png',ReportFooterURL='CLab_-01.png' ");
            if (IsCap == 1)
                sb.Append(" ,isCap='" + Util.getbooleanInt(Util.GetBoolean(iscapp)) + "' ");
            if (IsNablCenter == 1)
                sb.Append(" ,IsNableCentre='" + Util.getbooleanInt(Util.GetBoolean(nabl)) + "' ");
            sb.Append(" ,PrePrintedBarcode='" + Util.getbooleanInt(Util.GetBoolean(pb)) + "' ");
            if (TextPrintBarcode != "" && PrintBarcode == 1)
                sb.Append(" ,LabBarcodeAbbreviation='" + TextPrintBarcode + "' ");
            sb.Append(" where CentreId=" + Util.GetInt(CentreID) + "");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = CentreID });
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private string UploadImage(System.Web.UI.WebControls.FileUpload fl)
    {
        string name = string.Empty;
        if (fl.HasFile)
        {
            string Exte = System.IO.Path.GetExtension(fl.PostedFile.FileName);
            name = fl.FileName;
            if (Exte != "")
            {
                if (Exte != ".jpg" && Exte != ".jpeg" && Exte != ".JPG" && Exte != ".png")
                {
                   // lblMsg.Text = "Wrong File Extension of Header ";
                    return "ERROR";
                }
            }
            //string Url = Server.MapPath("Images/" + name);
            string Url = Server.MapPath("~/Images/" + name);
            if (System.IO.File.Exists(Url))
            {
                System.IO.File.Delete(Url);
            }

            fl.PostedFile.SaveAs(Url);
            Url = Url.Replace("\\", "''");
            Url = Url.Replace("'", "\\");
            //string str = "Update Center_Master set ReportHeaderURL='" + name + "' where CentreID='" + CentreID + "'";
            //StockReports.ExecuteDML(str);

        }
        return name;
    }

    [WebMethod]
    public string GetCenter(string CenterId)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT * FROM center_master WHERE CentreID=" + CenterId + "");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
    }

    [WebMethod]
    public string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string BindAllCentre()
    {
        DataTable dtcentre = StockReports.GetDataTable(" select CentreID,CentreName from center_master order by CentreName");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtcentre);
    }

     [WebMethod]
    public string BindFollowedCenter()
    {
        DataTable dtcentre = StockReports.GetDataTable(" select CentreID,CentreName,IsDefault from center_master Where IsActive=1 and CentreID=FollowedCentreId order by CentreName");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtcentre);
    }

    [WebMethod]
    public string SearchMarkupDetails(int centreID, string categoryID, string subcategoryID)
    {
        string SQL = "SELECT ID,FromRate,ToRate,MarkUpPercentage FROM f_centrewise_markup WHERE IsActive=1 AND CentreID=" + Util.GetInt(centreID) + " AND CategoryID='" + Util.GetString(categoryID) + "' AND SubCategoryID='" + Util.GetString(subcategoryID) + "' AND IFNULL(ItemID,'')='' ";
        DataTable dt = StockReports.GetDataTable(SQL);
        if (dt.Rows.Count == 0 || dt == null)
        {
            DataRow dr = dt.NewRow();

            dr["FromRate"] = Util.GetDecimal("0");
            dr["ToRate"] = Util.GetDecimal("1");
            dr["MarkUpPercentage"] = Util.GetDecimal("0");
            dr["ID"] = Util.GetInt("0");

            dt.Rows.Add(dr);
            dt.AcceptChanges();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string copyCentreMarkUpSetting(System.Collections.Generic.List<CentrewiseMarup> MarkUpList, List<centre> centreList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            for (int k = 0; k < centreList.Count; k++)
            {
                for (int i = 0; i < MarkUpList.Count; i++)
                {
                    var item = MarkUpList[i];
                    item.EntryBy = HttpContext.Current.Session["ID"].ToString();
                    item.CentreID = centreList[k].centreId;

                    if (i == 0)
                        excuteCMD.DML(tnx, "UPDATE f_centrewise_markup SET IsActive=0,UpdatedBy=@EntryBy,UpdatedDateTime=now() WHERE IsActive=1 AND CentreID=@CentreID AND CategoryID=@CategoryID AND SubCategoryID=@SubCategoryID ", CommandType.Text, item);

                    var sqlCmd = new StringBuilder("INSERT INTO f_centrewise_markup(CentreID,CategoryID,SubCategoryID,FromRate,ToRate,MarkUpPercentage,CreatedBy,CreatedDatetme)");
                    sqlCmd.Append("VALUES (@CentreID,@CategoryID,@SubCategoryID,@FromRate,@ToRate,@MarkupPer,@EntryBy,now())");
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string saveMarkup(System.Collections.Generic.List<CentrewiseMarup> MarkUpList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            for (int i = 0; i < MarkUpList.Count; i++)
            {
                var item = MarkUpList[i];
                item.EntryBy = HttpContext.Current.Session["ID"].ToString();

                if (i == 0)
                    excuteCMD.DML(tnx, "UPDATE f_centrewise_markup SET IsActive=0,UpdatedBy=@EntryBy,UpdatedDateTime=now() WHERE IsActive=1 AND CentreID=@CentreID AND CategoryID=@CategoryID AND SubCategoryID=@SubCategoryID ", CommandType.Text, item);

                var sqlCmd = new StringBuilder("INSERT INTO f_centrewise_markup(CentreID,CategoryID,SubCategoryID,FromRate,ToRate,MarkUpPercentage,CreatedBy,CreatedDatetme)");
                sqlCmd.Append("VALUES (@CentreID,@CategoryID,@SubCategoryID,@FromRate,@ToRate,@MarkupPer,@EntryBy,now())");
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
    public string GetAllCentre()
    {
        int centreID = Util.GetInt(Session["CentreID"]);
        //System.Data.DataView dv = All_LoadData.dtbind_Center().DefaultView;
        //dv.RowFilter = "CentreID NOT IN (" + centreID + ")";
        return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.dtbind_Center());
    }

    [WebMethod]
    public string GetAllCategory()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT cm.Name,cm.CategoryID,ConfigID FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cm.categoryid = cf.categoryid  Where Active=1 ORDER BY cm.Name "));
    }

    [WebMethod]
    public string GetSubCategoryByCategory(string categoryID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT SubCategoryID,sm.CategoryID,sm.Name,DisplayName,ConfigID,DisplayPriority FROM f_subcategorymaster sm INNER JOIN f_configrelation cf ON sm.categoryid = cf.categoryid  WHERE sm.active=1 and sm.categoryid='" + categoryID + "' ORDER BY sm.DisplayPriority "));
    }

    [WebMethod]
    public string GetMedicineGroup()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT si.ID,si.ItemGroup FROM store_itemsgroup si WHERE si.IsActive=1"));
    }

    [WebMethod]
    public string GetDepartMent()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT f.DeptLedgerNo,f.RoleName FROM f_rolemaster f WHERE f.Active=1 AND  f.IsMedical=1 AND  f.IsStore=1"));
    }

    [WebMethod]
    public string GetLoyalityCatogerys()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT f.ID, f.Name,f.Amount,f.Point  FROM loyality_category_master f  where f.IsActive=1"));
    }

    [WebMethod]
    public string GetItems(string centerID, string departMentLedgerNo, string categoryID, string subCategoryID, string itemName, int[] manufactureID, string groupid, string date, string itemtype, string centreName)
    {
        string str = string.Empty;
        //  StringBuilder sqlCmd = new StringBuilder("SELECT IF(C.ConfigID=11,'Medical','General') ItemStoreType, im.TypeName,im.ItemID ,im.SubCategoryID,IFNULL(dp.MaxLevel,0)MaxLevel,IFNULL(dp.MinLevel,0)MinLevel,IFNULL(dp.ReorderLevel,0)ReorderLevel,IFNULL(dp.ReorderQty,0)ReorderQty,IFNULL(dp.MaxReorderQty,0)MaxReorderQty,IFNULL(dp.MinReorderQty,0)MinReorderQty,if(IFNULL(dp.IsActive,0)=1,'Y','N') IsActive,IFNULL(dp.IsActive, 0) IsExits,IFNULL(im.MajorUnit,'')MajorUnit,IFNULL(im.MinorUnit,'') MinorUnit,IFNULL(im.ConversionFactor,1)ConversionFactor,IFNULL(dp.Discount, 0) Discount,IFNULL((SELECT `Name` FROM   loyality_category_master f WHERE f.ID=dp.LoyalityCategoryID),'') LoyalityCategoryID," + centerID + " centerID,'" + departMentLedgerNo + "' departMentLedgerNo,IFNULL(dp.Rack,'')Rack,IFNULL(dp.Shelf,'')Shelf  FROM f_itemmaster im   INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID   INNER JOIN f_configrelation c ON  SM.CategoryID=C.CategoryID AND C.ConfigID IN(11,28) LEFT  JOIN f_itemmaster_deptwise dp ON im.ItemID=dp.ItemID AND dp.CentreID = " + centerID + " AND dp.DeptLedgerNo = '" + departMentLedgerNo + "'  WHERE im.IsActive=1");
        StringBuilder sqlCmd = new StringBuilder(" SELECT  '" + centreName + "' as CentreName,c.`Name` AS Category,c.`CategoryID`,sm.`Name` AS SubCategory,im.TypeName,im.ItemID ,im.SubCategoryID,IFNULL(dp.MaxLevel,0)MaxLevel,IFNULL(dp.MinLevel,0)MinLevel,IFNULL(dp.ReorderLevel,0)ReorderLevel,IFNULL(dp.ReorderQty,0)ReorderQty,IFNULL(dp.MaxReorderQty,0)MaxReorderQty,IFNULL(dp.MinReorderQty,0)MinReorderQty,if(IFNULL(dp.IsActive,0)=1,'Y','N') IsActive,IFNULL(dp.IsActive, 0) IsExits,IFNULL(im.MajorUnit,'')MajorUnit,IFNULL(im.MinorUnit,'') MinorUnit,IFNULL(im.ConversionFactor,1)ConversionFactor,IFNULL(dp.Discount, 0) Discount,IFNULL((SELECT `Name` FROM   loyality_category_master f WHERE f.ID=dp.LoyalityCategoryID),'') LoyalityCategoryID," + centerID + " centerID,'" + departMentLedgerNo + "' departMentLedgerNo,IFNULL(dp.Rack,'')Rack,IFNULL(dp.Shelf,'')Shelf  FROM f_itemmaster im   INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID   INNER JOIN f_configrelation c ON  SM.CategoryID=C.CategoryID LEFT JOIN f_itemmaster_centerwise dp ON im.ItemID=dp.ItemID AND dp.CentreID = " + centerID + " AND dp.`IsActive`=1  WHERE im.IsActive=1");

        if (date != "")
            sqlCmd.Append(" And Date(im.CreaterDateTime) >= '" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "' ");

        for (int i = 0; i <= manufactureID.Length - 1; i++)
        {
            str = str + manufactureID[i] + ",";
        }

        str = str.TrimEnd(',');
        if (manufactureID.Length > 0)
            sqlCmd.Append(" AND im.ManufactureID in (" + str + ")");

        if (groupid != "0")
        {
            sqlCmd.Append(" AND ItemGroupMasterID='" + groupid + "'");
        }

        if (categoryID != "0")
            sqlCmd.Append(" AND sm.CategoryID='" + categoryID + "'");

        if (subCategoryID != "0" && !string.IsNullOrEmpty(subCategoryID))
            sqlCmd.Append(" AND sm.SubCategoryID='" + subCategoryID + "'");

        if (!string.IsNullOrEmpty(itemName))
            sqlCmd.Append(" AND im.TypeName LIKE '%" + itemName + "%'");

        if (itemtype == "mapped")
            sqlCmd.Append("  AND dp.`ID` IS NOT NULL ");
        if (itemtype == "unmapped")
            sqlCmd.Append("  AND dp.`ID` IS NULL ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCmd.ToString()));

    }

    [WebMethod(EnableSession = true)]
    public string SavesDIMappingsDetails(int centreID, List<mappedItem> deptIndentMapping)//Department Indent
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();
            
            if (HttpContext.Current.Session["ID"].ToString() == "EMP001")
            {
                sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  IsDepartmentIndent=0  WHERE CentreID=@centreID AND isActive=1");
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    centreID = centreID,
                    createdBy = userID
                });
                
                sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  IsDepartmentIndent=1  WHERE CentreID=@centreID AND isActive=1 and RoleID=@valueField ");
                for (int i = 0; i < deptIndentMapping.Count; i++)
                {
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, deptIndentMapping[i]);
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SavesPIMappingsDetails(int centreID, List<mappedItem> patientIndentMapping)//Patient Indent
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            try
            {
                if (HttpContext.Current.Session["ID"].ToString() == "EMP001")
                {
                    sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  IsPatientIndent=0  WHERE CentreID=@centreID AND isActive=1");
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                    {
                        centreID = centreID,
                        createdBy = userID
                    });
                    
                    sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  IsPatientIndent=1  WHERE CentreID=@centreID AND isActive=1 and RoleID=@valueField ");
                    for (int i = 0; i < patientIndentMapping.Count; i++)
                    {
                        excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, patientIndentMapping[i]);
                    }
                }

                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SavesRolesMappingsDetails(int centreID, List<mappedItem> mappedRoles)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            if (HttpContext.Current.Session["ID"].ToString() == "EMP001")
            {
                sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  isActive=0,UpdatedBy=@createdBy,UpdatedDateTime=now()  WHERE CentreID=@centreID AND isActive=1");
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    centreID = centreID,
                    createdBy = userID
                });


                sqlCMD = new StringBuilder("INSERT INTO f_centre_role(RoleID,CentreID,CreatedBy) VALUES (@valueField,@centreID,@createdBy)");
                for (int i = 0; i < mappedRoles.Count; i++)
                {
                    mappedRoles[i].createdBy = userID;
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedRoles[i]);
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SavesPanelsMappingsDetails(int centreID, List<mappedItem> mappedPanels)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            sqlCMD.Append("UPDATE  f_center_panel  SET  isActive=0,UpdatedBy=@createdBy,UpdatedDateTime=now()   WHERE CentreID=@centreID AND isActive=1");
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                centreID = centreID,
                createdBy = userID
            });

            sqlCMD = new StringBuilder("INSERT INTO f_center_panel (PanelID,CentreID,CreatedBy,Email, ContactPerson ) VALUES (@valueField,@centreID,@createdBy,@Email,@ContactPerson)");
            for (int i = 0; i < mappedPanels.Count; i++)
            {
                mappedPanels[i].createdBy = userID;

                DataTable dt = StockReports.GetDataTable(" select Email, ContactPerson from f_center_panel where PanelID=" + mappedPanels[i].valueField + " and CentreID=" + mappedPanels[i].centreID + " order by ID DESC LIMIT 1 ");
                if (dt.Rows.Count > 0 && dt != null)
                {
                    mappedPanels[i].Email = dt.Rows[0]["Email"].ToString();
                    mappedPanels[i].ContactPerson = dt.Rows[0]["ContactPerson"].ToString();
                }
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedPanels[i]);
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SavesDoctorsMappingsDetails(int centreID, List<mappedItem> mappedDoctors)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();
            
            sqlCMD = new StringBuilder("UPDATE  f_center_doctor  SET  isActive=0,UpdatedBy=@createdBy,UpdatedDateTime=now()  WHERE CentreID=@centreID AND isActive=1");
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                centreID = centreID,
                createdBy = userID
            });


            sqlCMD = new StringBuilder("INSERT INTO f_center_doctor(DoctorID,CentreID,CreatedBy) VALUES (@valueField,@centreID,@createdBy)");
            for (int i = 0; i < mappedDoctors.Count; i++)
            {
                mappedDoctors[i].createdBy = userID;
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedDoctors[i]);
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SavesEmployeeMappingsDetails(int centreID, List<mappedItem> mappedEmployees)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            sqlCMD = new StringBuilder("UPDATE  centre_access  SET  isActive=0,UpdatedBy=@createdBy,UpdateDate=now()  WHERE CentreAccess=@centreID AND isActive=1");
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                centreID = centreID,
                createdBy = userID
            });


            sqlCMD = new StringBuilder("INSERT INTO centre_access(EmployeeID,CentreAccess,IsActive,CreatedBy,CreatedDate) VALUES (@valueField,@centreID,1,@createdBy,now())");
            for (int i = 0; i < mappedEmployees.Count; i++)
            {
                mappedEmployees[i].createdBy = userID;
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedEmployees[i]);
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string copyCentrePerformCostSetting(List<PerformingCostItemss> ItemList, List<centre> centrelListPerform)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        { 
            StringBuilder sqlCMD = new StringBuilder();

            for (int k = 0; k < centrelListPerform.Count; k++)
            {
                int CenterID = centrelListPerform[k].centreId;

                for (int i = 0; i < ItemList.Count; i++)
                {
                    var item = ItemList[i];
                    item.EntryBy = HttpContext.Current.Session["ID"].ToString();
                    item.Ipaddress = All_LoadData.IpAddress();
                    item.CentreID = Util.GetString(CenterID);

                    excuteCMD.DML(tnx, "DELETE from master_CenterwisePerformingCosting WHERE ItemID=@ItemID AND  CentreID=@CentreID", CommandType.Text, item);
                    var sqlCmd = new StringBuilder("INSERT INTO master_CenterwisePerformingCosting(ItemID,CentreID,PerformingCost,EntryBy,Ipaddress )");
                    sqlCmd.Append("VALUES (@ItemID,@CentreID,@PerformingCost,@EntryBy,@Ipaddress)");
                    excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string CopyCenterItemsMarkup(List<centrewise_markups> ItemList, int IsSet, List<centre> centreItemMarkuplList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            for (int k = 0; k < centreItemMarkuplList.Count; k++)
            {
                int CenterID = centreItemMarkuplList[k].centreId;

                if (ItemList.Count <= 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select Atleast One Item" });

                if (Util.GetString(ItemList[0].SubCategoryID) == "0")
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select Sub Category" });

                if (IsSet > 0)
                {
                    excuteCMD.DML(tnx, " Update f_centrewise_markup set IsActive=0,UpdatedBy=@EntryBy,UpdatedDateTime=NOW() WHERE SubCategoryID=@subCategoryID AND IFNULL(ItemID,'')<>'' AND IsActive=1 and CentreID=@centerID  ", CommandType.Text, new
                    {
                        EntryBy = HttpContext.Current.Session["ID"].ToString(),
                        subCategoryID = Util.GetString(ItemList[0].SubCategoryID),
                        centerID = Util.GetInt(CenterID)
                    });
                }

                ItemList = ItemList.Where(i => Util.GetInt(i.MarkUpPercentage) > 0).ToList();
                for (int i = 0; i < ItemList.Count; i++)
                {
                    StringBuilder sb = new StringBuilder();
                    var item = ItemList[i];
                    item.EntryBy = HttpContext.Current.Session["ID"].ToString();
                    item.CentreID = Util.GetString(CenterID);

                    var sqlCmd = new StringBuilder(" INSERT INTO f_centrewise_markup(CategoryID,SubCategoryID,ItemID,FromRate,ToRate,MarkUpPercentage,IsActive,CreatedBy,CreatedDatetme,CentreID ) ");
                    sqlCmd.Append(" VALUES (@CategoryID,@SubCategoryID,@ItemID,0,0,@MarkUpPercentage,1,@EntryBy,NOW(),@CentreID ) ");
                    excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string CopyCenterToleranceItems(List<PerformingCostItems> ItemListt, int IsSet, List<centre> centreTolList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            for (int k = 0; k < centreTolList.Count; k++)
            {
                int CenterID = centreTolList[k].centreId;

                if (ItemListt.Count <= 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select Atleast One Item" });

                if (Util.GetString(ItemListt[0].SubCategoryID) == "0")
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select Sub Category" });

                if (IsSet > 0)
                {
                    excuteCMD.DML(tnx, " Update f_tolerancelevel tl INNER JOIN `f_itemmaster` im ON im.`ItemID`=tl.`ItemID` set tl.IsActive=0,tl.UpdatedBy=@EntryBy,tl.UpdatedDatetime=NOW() WHERE IFNULL(tl.ItemID,'')<>'' AND tl.IsActive=1 and tl.CentreID=@CentreID and im.SubCategoryID=@SubCategoryID ", CommandType.Text, new
                    {
                        EntryBy = HttpContext.Current.Session["ID"].ToString(),
                        CentreID = Util.GetInt(CenterID),
                        SubCategoryID = ItemListt[0].SubCategoryID
                    });
                }
                for (int i = 0; i < ItemListt.Count; i++)
                {
                    StringBuilder sb = new StringBuilder();
                    var item = ItemListt[i];
                    item.EntryBy = HttpContext.Current.Session["ID"].ToString();
                    item.Ipaddress = All_LoadData.IpAddress();
                    item.CentreID = Util.GetString(CenterID);

                    var sqlCmd = new StringBuilder(" INSERT INTO f_tolerancelevel(ItemID,Maximum_Tolerance_Qty,Minimum_Tolerance_Qty,Maximum_Tolerance_Rate,Minimum_Tolerance_Rate,type,IsActive,EntryBy,EntryDatetime,Ipaddress,CentreID ) ");
                    sqlCmd.Append(" VALUES (@ItemID,@Maximum_Tolerance_Qty,@Minimum_Tolerance_Qty,@Maximum_Tolerance_Rate,@Minimum_Tolerance_Rate,@type,1,@EntryBy,NOW(),@Ipaddress,@CentreID ) ");
                    excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string CopyDICenterAccess(List<mappedItem> deptIndentMapping, List<centre> centreDEIList)//Department Indent
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            for (int k = 0; k < centreDEIList.Count; k++)
            {
                int CenterID = centreDEIList[k].centreId;

                if (HttpContext.Current.Session["ID"].ToString() == "EMP001")
                {
                    sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  IsDepartmentIndent=0  WHERE CentreID=@centreID AND isActive=1");
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                    {
                        centreID = CenterID,
                        createdBy = userID
                    });

                    sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  IsDepartmentIndent=1  WHERE CentreID=@centreID AND isActive=1 and RoleID=@valueField ");
                    for (int i = 0; i < deptIndentMapping.Count; i++)
                    {
                        deptIndentMapping[i].centreID = CenterID;
                        excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, deptIndentMapping[i]);
                    }
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string CopyPICenterAccess(List<mappedItem> patientIndentMapping, List<centre> centrePAIList)//Patient Indent
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            for (int k = 0; k < centrePAIList.Count; k++)
            {
                int CenterID = centrePAIList[k].centreId;
                
                if (HttpContext.Current.Session["ID"].ToString() == "EMP001")
                {
                    sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  IsPatientIndent=0  WHERE CentreID=@centreID AND isActive=1");
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                    {
                        centreID = CenterID,
                        createdBy = userID
                    });
                    
                    sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  IsPatientIndent=1  WHERE CentreID=@centreID AND isActive=1 and RoleID=@valueField ");
                    for (int i = 0; i < patientIndentMapping.Count; i++)
                    {
                        patientIndentMapping[i].centreID = CenterID;
                        excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, patientIndentMapping[i]);
                    }
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string CopyRolesCenterAccess(List<mappedItem> mappedRoles, List<centre> centreRolesList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            for (int k = 0; k < centreRolesList.Count; k++)
            {
                int CenterID = centreRolesList[k].centreId;

                if (HttpContext.Current.Session["ID"].ToString() == "EMP001")
                {
                    sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  isActive=0,UpdatedBy=@createdBy,UpdatedDateTime=now()  WHERE CentreID=@centreID AND isActive=1");
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                    {
                        centreID = CenterID,
                        createdBy = userID
                    });


                    sqlCMD = new StringBuilder("INSERT INTO f_centre_role(RoleID,CentreID,CreatedBy) VALUES (@valueField,@centreID,@createdBy)");
                    for (int i = 0; i < mappedRoles.Count; i++)
                    {
                        mappedRoles[i].createdBy = userID;
                        mappedRoles[i].centreID = CenterID;
                        excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedRoles[i]);
                    }
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string CopyPanelsCenterAccess(List<mappedItem> mappedPanels, List<centre> centrePanList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();
            
            for (int k = 0; k < centrePanList.Count; k++)
            {
                int CenterID = centrePanList[k].centreId;

                sqlCMD = new StringBuilder("UPDATE  f_center_panel  SET  isActive=0,UpdatedBy=@createdBy,UpdatedDateTime=now()   WHERE CentreID=@centreID AND isActive=1");
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    centreID = CenterID,
                    createdBy = userID
                });

                sqlCMD = new StringBuilder("INSERT INTO f_center_panel (PanelID,CentreID,CreatedBy,Email, ContactPerson ) VALUES (@valueField,@centreID,@createdBy,@Email,@ContactPerson)");
                for (int i = 0; i < mappedPanels.Count; i++)
                {
                    mappedPanels[i].createdBy = userID;
                    mappedPanels[i].centreID = CenterID;

                    DataTable dt = StockReports.GetDataTable(" select Email, ContactPerson from f_center_panel where PanelID=" + mappedPanels[i].valueField + " and CentreID=" + mappedPanels[i].centreID + " order by ID DESC LIMIT 1 ");
                    if (dt.Rows.Count > 0 && dt != null)
                    {
                        mappedPanels[i].Email = dt.Rows[0]["Email"].ToString();
                        mappedPanels[i].ContactPerson = dt.Rows[0]["ContactPerson"].ToString();
                    }
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedPanels[i]);
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string CopyDoctorsCenterAccess(List<mappedItem> mappedDoctors, List<centre> centreDOCList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            for (int k = 0; k < centreDOCList.Count; k++)
            {
                int CenterID = centreDOCList[k].centreId;
                
                sqlCMD = new StringBuilder("UPDATE  f_center_doctor  SET  isActive=0,UpdatedBy=@createdBy,UpdatedDateTime=now()  WHERE CentreID=@centreID AND isActive=1");
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    centreID = CenterID,
                    createdBy = userID
                });


                sqlCMD = new StringBuilder("INSERT INTO f_center_doctor(DoctorID,CentreID,CreatedBy) VALUES (@valueField,@centreID,@createdBy)");
                for (int i = 0; i < mappedDoctors.Count; i++)
                {
                    mappedDoctors[i].createdBy = userID;
                    mappedDoctors[i].centreID = CenterID;
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedDoctors[i]);
                }
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string CopyEmployeesCenterAccess(List<mappedItem> mappedEmployees, List<centre> centreEMPList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            for (int k = 0; k < centreEMPList.Count; k++)
            {
                int CenterID = centreEMPList[k].centreId;
                sqlCMD = new StringBuilder("UPDATE  centre_access  SET  isActive=0,UpdatedBy=@createdBy,UpdateDate=now()  WHERE CentreAccess=@centreID AND isActive=1");
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    centreID = CenterID,
                    createdBy = userID
                });

                sqlCMD = new StringBuilder("INSERT INTO centre_access(EmployeeID,CentreAccess,IsActive,CreatedBy,CreatedDate) VALUES (@valueField,@centreID,1,@createdBy,now())");
                for (int i = 0; i < mappedEmployees.Count; i++)
                {
                    mappedEmployees[i].createdBy = userID;
                    mappedEmployees[i].centreID = CenterID;
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedEmployees[i]);
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class CentrewiseMarup
    {
        public int CentreID { get; set; }
        public string SubCategoryID { get; set; }
        public string CategoryID { get; set; }
        public decimal FromRate { get; set; }
        public decimal ToRate { get; set; }
        public decimal MarkupPer { get; set; }
        public string EntryBy { get; set; }

    }

    public class centre
    {
        public int centreId { get; set; }
    }

    public class mappedItem
    {
        public int centreID { get; set; }
        public string valueField { get; set; }
        public string createdBy { get; set; }
        public string Email { get; set; }
        public string ContactPerson { get; set; }
    }

    public class PerformingCostItems
    {
        public string ItemID { get; set; }
        public string SubCategoryID { get; set; }
        public string CategoryID { get; set; }
        public string TypeName { get; set; }
        public string SubCategoryName { get; set; }
        public string CategoryName { get; set; }
        public string Maximum_Tolerance_Qty { get; set; }
        public string Minimum_Tolerance_Qty { get; set; }
        public decimal Maximum_Tolerance_Rate { get; set; }
        public decimal Minimum_Tolerance_Rate { get; set; }
        public string IsSet { get; set; }
        public string EntryBy { get; set; }
        public string Ipaddress { get; set; }
        public string type { get; set; }
        public string CentreID { get; set; }
    }

    public class centrewise_markups
    {
        public string ItemID { get; set; }
        public string SubCategoryID { get; set; }
        public string CategoryID { get; set; }
        public string TypeName { get; set; }
        public string SubCategoryName { get; set; }
        public string CategoryName { get; set; }
        public string FromRate { get; set; }
        public string ToRate { get; set; }
        public string MarkUpPercentage { get; set; }
        public string EntryBy { get; set; }
        public string CentreID { get; set; }
    }

    public class PerformingCostItemss
    {
        public string ItemID { get; set; }
        public string SubCategoryID { get; set; }
        public string CategoryID { get; set; }
        public string TypeName { get; set; }
        public string SubCategoryName { get; set; }
        public string CategoryName { get; set; }
        public decimal PerformingCost { get; set; }
        public string IsSet { get; set; }
        public string EntryBy { get; set; }
        public string Ipaddress { get; set; }
        public string CentreID { get; set; }
    }
}