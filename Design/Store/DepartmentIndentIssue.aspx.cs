using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Linq;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;
using System.IO;

public partial class Design_Store_DepartmentIndentIssue : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblDeptLedgerNo.Text = Session["DeptLedgerNo"].ToString();
            lblUserID.InnerText = Session["ID"].ToString();
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            DateFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            DateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        DateFrom.Attributes.Add("readOnly", "true");
        DateTo.Attributes.Add("readOnly", "true");
    }

    [WebMethod(EnableSession = true)]
    public static string SearchIndent(string StoreType, string DateFrom, string DateTo, string CentreFrom, string Department, string RequisitionNo, string SubGroup, string status)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM ( ");
            sb.Append("  SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'    ");
            sb.Append("  WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  ");
            sb.Append("  FROM (");
            sb.Append("  SELECT cm.CentreName AS CentreFrom,id.CentreID,id.indentno,id.Type,id.StoreId,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,lm.ledgername AS DeptFrom,lm.LedgerNumber, ");
            sb.Append(" (SELECT COUNT(*) FROM f_salesdetails WHERE IndentNo=id.indentno)NewIndent,SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty, ");
            sb.Append(" SUM(RejectQty)RejectQty,id.Deptfrom DeptfromID  FROM f_indent_detail id INNER JOIN f_itemmaster im ON im.ItemID=id.ItemId INNER JOIN f_ledgermaster lm ");
            sb.Append(" ON lm.LedgerNumber = id.Deptfrom INNER JOIN center_master cm ON cm.CentreID=id.CentreID where Date(id.dtEntry) >= '" + Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" AND Date(id.dtEntry) <='" + Util.GetDateTime(DateTo).ToString("yyyy-MM-dd") + "'  AND id.deptto = '" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' AND id.ToCentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND id.StoreID=@StoreType ");

            if (RequisitionNo != string.Empty)
            {
                sb.Append(" and id.IndentNo = @RequisitionNo ");
            }
            if (Department != "0")
            {
                sb.Append("  and id.DeptFrom=@Department ");
            }
            if (CentreFrom != "0")
            {
                sb.Append("  and id.CentreID=@CentreFrom ");
            }
            if (SubGroup != "0")
            {
                sb.Append("  AND im.SubCategoryID=@SubGroup ");
            }
            sb.Append("  GROUP BY IndentNo        )t  		)t1 ");
            if(status!="")
                sb.Append(" where StatusNew='" + status + "' ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
            {
                StoreType = StoreType,
                DateFrom = Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd"),
                DateTo = Util.GetDateTime(DateTo).ToString("yyyy-MM-dd"),
                CentreFrom = CentreFrom,
                Department = Department,
                RequisitionNo = RequisitionNo,
                SubGroup = SubGroup
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public static string BindCentre()
    {
        try
        {
            DataTable dtCentre = All_LoadData.dtbind_Center();
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public static string BindDepartment()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" select LedgerNumber,LedgerName from  f_ledgermaster where GroupID='DPT' and IsCurrent=1 order by LedgerName ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public static string BindSubCategory(string StorLedgerNo)
    {
        try
        {
            string ConfigID = "";
            if (StorLedgerNo.ToString() == "STO00001")
                ConfigID = "11";
            else
                ConfigID = "28";

            DataTable dt = StockReports.GetDataTable("SELECT sc.SubCategoryID,sc.Name FROM f_subcategorymaster sc INNER JOIN f_configrelation cr ON cr.CategoryID=sc.CategoryID WHERE cr.ConfigID = " + ConfigID + "");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public static string SearchIndentDetails(string IndentNo, string status)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select @status StatusNew, id.IndentNo, id.ItemName, id.ReqQty, id.UnitType,sd.SoldUnits,  DATE_FORMAT(sd.Date,'%d-%b-%y')Date,");
            sb.Append(" sd.UserId,id.ReceiveQty,(IFNULL(id.ReqQty,0)-IFNULL(id.ReceiveQty,0)-IFNULL(id.RejectQty,0))PendingQty,id.RejectQty from f_indent_detail id   ");
            sb.Append(" left outer JOIN f_salesdetails sd    ON sd.IndentNo=id.IndentNo AND sd.ItemID=id.ItemId");
            sb.Append(" where id.indentno =@IndentNo ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
            {
                IndentNo = IndentNo,
                status = status,
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public static string PrintIndentDetails(string IndentNo, string SalesNo)
    {
        try
        {
            if(SalesNo=="")
             SalesNo = StockReports.ExecuteScalar("SELECT SALESNO FROM f_salesdetails WHERE IndentNo='" + IndentNo.Trim() + "' LIMIT 1");
            StringBuilder sb1 = new StringBuilder();
            sb1.Append("SELECT id.IndentNo,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,t.IssuedQty, ");
            sb1.Append("id.UnitType,id.Narration,id.isApproved, id.ApprovedBy,id.ApprovedReason,t.salesno,t.iDate, ");
            sb1.Append(" date_format(id.dtEntry,'%d-%b-%Y %h:%i %p')dtEntry,id.UserId,t.BatchNumber, ");
            sb1.Append("t.CostPrice,t.MedExpiryDate, ");
            sb1.Append("(SELECT DeptName FROM f_rolemaster WHERE DeptLedgerNo = id.DeptFrom)DeptFrom, ");
            sb1.Append("(SELECT DeptName FROM f_rolemaster WHERE DeptLedgerNo = id.DeptTo)DeptTo, ");
            sb1.Append("(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE EmployeeID=id.UserId)EmpName, ");
            sb1.Append("(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE EmployeeID=t.UserId)IssueBy, t.SellingPrice ");
            sb1.Append("FROM ");
            sb1.Append("(SELECT IndentNo,ItemName,ReqQty,ReceiveQty,RejectQty,UnitType,ItemId,ApprovedBy,Narration,isApproved,ApprovedReason,dtEntry,UserId,DeptFrom,DeptTo FROM f_indent_detail WHERE IndentNo='" + IndentNo + "') id INNER JOIN ");
            sb1.Append("(SELECT sd.IndentNo,st.BatchNumber,st.UnitPrice CostPrice,SUM(sd.SoldUnits)IssuedQty,sd.salesno,CONCAT(DATE_FORMAT(sd.DATE,'%d-%b-%Y'),' ',time_format(sd.TIME,'%h:%i %p'))iDate, ");
            sb1.Append("IF(st.IsExpirable=1,date_format(st.MedExpiryDate,'%d-%b-%y'),'') MedExpiryDate,sd.ItemID,sd.StockID,sd.UserID,sd.PerUnitSellingPrice SellingPrice FROM ");
            sb1.Append("  f_salesdetails sd ");
            sb1.Append(" INNER JOIN f_stock st ");
            sb1.Append("ON sd.StockID = st.StockID WHERE sd.indentno='" + IndentNo.Trim() + "' and sd.salesno='" + SalesNo.Trim() + "'");
            sb1.Append("GROUP BY sd.StockID,st.BatchNumber)t ");
            sb1.Append("ON id.ItemId = t.ItemID AND id.IndentNo = t.IndentNo ");
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            DataSet ds = new DataSet();
            ds.Tables.Add(StockReports.GetDataTable(sb1.ToString()).Copy());
            ds.Tables.Add(dtImg.Copy());
            // ds.WriteXmlSchema(@"e:\NewIndent1.xml");
            System.Web.HttpContext.Current.Session["ds"] = ds;
            System.Web.HttpContext.Current.Session["ReportName"] = "NewIndentForStore";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
   
    [WebMethod(EnableSession = true)]
    public static string checkStoreRight()
    {
        try
        {
            DataTable dt = StockReports.GetRights(HttpContext.Current.Session["RoleId"].ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    
    [WebMethod(EnableSession = true)]
    public static string SaveIndentData(List<Item_Details> items, List<RejectItem_Details> Rejectitems)
    {

        List<Item_Details> ItemList = new JavaScriptSerializer().ConvertToType<List<Item_Details>>(items);
        List<RejectItem_Details> RejectItemList = new JavaScriptSerializer().ConvertToType<List<RejectItem_Details>>(Rejectitems);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            // INDENT ITEM REJECTED BECAUSE ISSUE ALTERNET ITEM...
            if (RejectItemList.Count > 0)
            {
                for (int j = 0; j < RejectItemList.Count; j++)
                {
                    if (RejectItemList[j].Types.ToString().Trim() == "REJECT")
                    {
                        var sqlCmd = new StringBuilder("UPDATE f_indent_detail fid SET fid.RejectQty= (fid.ReqQty-fid.ReceiveQty),fid.RejectReason='Alternet Item Added.',fid.RejectBy='" + HttpContext.Current.Session["id"].ToString() + "',fid.dtReject=NOW()  ");
                        sqlCmd.Append(" WHERE fid.IndentNo='" + RejectItemList[j].IndentNo.ToString() + "'  AND fid.ItemId='" + RejectItemList[j].ItemID.ToString() + "' ");

                        if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sqlCmd.ToString()) == 0)
                        {
                            Tranx.Rollback();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Something went wrong.." });

                        }
                    }
                }
            }

             int SalesNo = 0;
             string IndentNo = "";
            if (ItemList.Count > 0)
            {
               
                if (Util.GetInt(ItemList[0].FromcentreID.ToString()) != Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()))
                    SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT Get_SalesNo('27','" + ItemList[0].StoreID.ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "') "));
                else
                    SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT Get_SalesNo('1','" + ItemList[0].StoreID.ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "') "));

                if (SalesNo == 0)
                {
                    Tranx.Rollback();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Issue is not done because sale no is not found, Please contact to administrator." });
                }
               
                string str_StockId = "";
                string GenricType = "";
                string GenricID = "0";
                float TIssueQty=0f;
                for (int j = 0; j < ItemList.Count; j++)
                {
                    float newIssueQty = 0f;
                    IndentNo = ItemList[j].IndentNo.ToString();

                    if (Util.GetFloat(ItemList[j].IssueQuantity.ToString()) > 0)
                    {

                        newIssueQty = newIssueQty + Util.GetFloat(ItemList[j].IssueQuantity.ToString());
                        TIssueQty = TIssueQty + newIssueQty;
                        str_StockId = ItemList[j].StockID.ToString();
                        //GST Changes
                        string stt = "select IsExpirable,StockID,ItemID,Rate,DiscPer,round((DiscAmt/InitialCount),4) as DiscAmt,PurTaxPer ,round((PurTaxAmt/InitialCount),4) as PurTaxAmt , SaleTaxPer,round((SaleTaxAmt/InitialCount),4) as SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType,MajorUnit,MinorUnit,ConversionFactor,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,IGSTAmtPerUnit,SGSTAmtPerUnit,CGSTAmtPerUnit,GSTType,VenLedgerNo from f_stock  where DeptLedgerNo = '" + ItemList[j].DeptLedgerNo.ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";
                        DataTable dtResult = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stt).Tables[0];
                        if (dtResult != null && dtResult.Rows.Count > 0)
                        {
                            int i = 0;
                            string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(ItemList[j].IssueQuantity.ToString()) + "),0,1)CHK from f_stock where stockID='" + str_StockId + "'";
                            if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                            {
                                Tranx.Rollback();
                                con.Close();
                                con.Dispose();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Issue Quantity is not available in the Store." });
                            }
                            string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetFloat(ItemList[j].IssueQuantity.ToString()) + " where StockID = '" + str_StockId + "'";

                            if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock) == 0)
                            {
                                Tranx.Rollback();
                                con.Close();
                                con.Dispose();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Something went wrong.." });

                            }
                            int CountIndent = Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, " Select count(*) from f_indent_detail where IndentNo='" + Util.GetString(ItemList[j].IndentNo.ToString()) + "' and ItemId='" + ItemList[j].ItemID.ToString() + "' "));
                            if (ItemList[j].Types.ToString().Trim() == "OLD")
                            {
                                if (CountIndent > 0)
                                {
                                    string strIndent = "UPDATE f_indent_detail set ReceiveQty = ReceiveQty +" + Util.GetFloat(ItemList[j].IssueQuantity.ToString()) + ",UserId='" + ItemList[j].UserID.ToString() + "' where IndentNo = '" + ItemList[j].IndentNo.ToString() + "' and itemid= '" + ItemList[j].ItemID.ToString() + "' and deptFrom='" + ItemList[j].DeptFrom.ToString() + "' and ReqQty>=(ReceiveQty+RejectQty)";

                                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndent) == 0)
                                    {
                                        Tranx.Rollback();
                                        con.Close();
                                        con.Dispose();
                                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Something went wrong.." });

                                    }
                                }
                            }
                            else if (ItemList[j].Types.ToString().Trim() == "NEW")
                            {
                                if (!string.IsNullOrEmpty(ItemList[j].OldItemID))
                                {
                                    if (ItemList[j].OldItemID.ToString() != "0")
                                    {
                                        GenricType = "GENERIC";
                                        GenricID = ItemList[j].OldItemID.ToString();
                                    }
                                }
                                //   FOR NEW ITEM ADDED IN INDENT
                                StringBuilder sb = new StringBuilder();
                                sb.Append(" INSERT INTO f_indent_detail(IndentNo,ItemId,ItemName,ReqQty,ReceiveQty,UnitType,DeptFrom,DeptTo,StoreId,Narration,UserId,Type,GenricType,OLDItemID,CentreID,Hospital_Id,ToCentreID)  ");
                                sb.Append(" values('" + IndentNo + "','" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "','" + Util.GetString(dtResult.Rows[i]["ItemName"]) + "'," + Util.GetFloat(ItemList[j].RequestQuatity.ToString()) + "," + Util.GetFloat(ItemList[j].IssueQuantity.ToString()) + "");
                                sb.Append(" ,'" + Util.GetString(dtResult.Rows[i]["UnitType"]) + "','" + ItemList[j].DeptFrom.ToString() + "','" + ItemList[j].DeptLedgerNo.ToString() + "','" + ItemList[j].StoreID.ToString() + "','NEW ITEM ADDED','" + ItemList[j].UserID.ToString() + "','Normal','" + Util.GetString(GenricType) + "'," + Util.GetString(GenricID) + "," + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",'" + HttpContext.Current.Session["HOSPID"].ToString() + "'," + Util.GetInt(ItemList[j].FromcentreID.ToString()) + ") ");

                                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                                {
                                    Tranx.Rollback();
                                    con.Close();
                                    con.Dispose();
                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Something went wrong.." });

                                }
                            }
                            
                                                  
                            decimal MRP = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                            decimal SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                            decimal SaleTaxAmtPerUnit = Math.Round(((((MRP * 100) / (100 + SaleTaxPer)) * SaleTaxPer) / 100), 6);
                            decimal TaxablePurVATAmt = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]) * Util.GetDecimal(ItemList[j].IssueQuantity.ToString()) * (100 / (100 + Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"])));
                            decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]) / 100;


                            Stock objStock = new Stock(Tranx);
                            objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                            objStock.InitialCount = Util.GetDecimal(ItemList[j].IssueQuantity.ToString());
                            objStock.BatchNumber = Util.GetString(dtResult.Rows[i]["BatchNumber"]);
                            objStock.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                            objStock.ItemName = Util.GetString(dtResult.Rows[i]["ItemName"]);
                            objStock.DeptLedgerNo = Util.GetString(ItemList[j].DeptLedgerNo);
                            objStock.IsFree = 0;
                            if (Util.GetInt(ItemList[j].FromcentreID) != Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()))
                                objStock.IsPost = 4;
                            else
                                objStock.IsPost = 1;
                            objStock.PostDate = DateTime.Now;
                            objStock.MRP = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                            objStock.StockDate = DateTime.Now;
                            objStock.Unit = Util.GetString(dtResult.Rows[i]["UnitType"]);
                            objStock.SubCategoryID = Util.GetString(dtResult.Rows[i]["SubCategoryID"]);
                            objStock.UnitPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                            objStock.IsCountable = 1;
                            objStock.IsReturn = 0;
                            objStock.FromDept = ItemList[j].FromcentreID.ToString();
                            objStock.FromStockID = Util.GetString(dtResult.Rows[i]["StockID"]);
                            objStock.IndentNo = Util.GetString(ItemList[j].IndentNo);
                            objStock.MedExpiryDate = Util.GetDateTime(dtResult.Rows[i]["MedExpiryDate"]);
                            objStock.RejectQty = Util.GetDouble(ItemList[j].RejectQuantity.ToString());
                            objStock.Unit = Util.GetString(dtResult.Rows[i]["UnitType"]);
                            objStock.StoreLedgerNo = ItemList[j].StoreID.ToString();
                            objStock.UserID = ItemList[j].UserID.ToString();
                            objStock.PostUserID = ItemList[j].UserID.ToString();
                            objStock.Rate = Util.GetDecimal(dtResult.Rows[i]["Rate"]);
                            objStock.TYPE = Util.GetString(dtResult.Rows[i]["TYPE"]);
                            objStock.IsBilled = Util.GetInt(dtResult.Rows[i]["IsBilled"]);
                            objStock.Reusable = Util.GetInt(dtResult.Rows[i]["Reusable"]);
                            objStock.SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                            objStock.SaleTaxAmt = Util.GetDecimal(SaleTaxAmtPerUnit) * Util.GetDecimal(ItemList[j].IssueQuantity);
                            objStock.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                            objStock.PurTaxAmt = vatPuramt;
                            objStock.DiscPer = Util.GetDecimal(dtResult.Rows[i]["DiscPer"]);
                            objStock.DiscAmt = Util.GetDecimal(dtResult.Rows[i]["DiscAmt"]) * Util.GetDecimal(ItemList[j].IssueQuantity);

                            //  objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());

                            objStock.CentreID = Util.GetInt(ItemList[j].FromcentreID);

                            objStock.IpAddress = All_LoadData.IpAddress();
                            //GST Changes
                            objStock.IGSTPercent = Util.GetDecimal(dtResult.Rows[i]["IGSTPercent"]);
                            objStock.IGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["IGSTAmtPerUnit"]);
                            objStock.SGSTPercent = Util.GetDecimal(dtResult.Rows[i]["SGSTPercent"]);
                            objStock.SGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["SGSTAmtPerUnit"]);
                            objStock.CGSTPercent = Util.GetDecimal(dtResult.Rows[i]["CGSTPercent"]);
                            objStock.CGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["CGSTAmtPerUnit"]);
                            objStock.HSNCode = Util.GetString(dtResult.Rows[i]["HSNCode"]);
                            objStock.GSTType = Util.GetString(dtResult.Rows[i]["GSTType"]);
                            objStock.VenLedgerNo = Util.GetString(dtResult.Rows[i]["VenLedgerNo"]);
                            objStock.LedgerTransactionNo = "0";
                            objStock.LedgerTnxNo = "0";
                            objStock.MajorUnit = Util.GetString(dtResult.Rows[i]["MajorUnit"]);
                            objStock.MinorUnit = Util.GetString(dtResult.Rows[i]["MinorUnit"]);
                            objStock.ConversionFactor = Util.GetDecimal(dtResult.Rows[i]["ConversionFactor"]);
                            objStock.VenLedgerNo = Util.GetString(dtResult.Rows[i]["VenLedgerNo"]);
                            objStock.IsExpirable = Util.GetInt(dtResult.Rows[i]["IsExpirable"]);
                            objStock.salesno = SalesNo;
                            string stokID = objStock.Insert();

                            Sales_Details ObjSales = new Sales_Details(Tranx);
                            ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                            ObjSales.LedgerNumber = Util.GetString(ItemList[j].DeptFrom);
                            ObjSales.DepartmentID = ItemList[j].StoreID.ToString();
                            ObjSales.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                            ObjSales.StockID = Util.GetString(dtResult.Rows[i]["StockID"]);
                            ObjSales.SoldUnits = Util.GetDecimal(ItemList[j].IssueQuantity.ToString());
                            ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                            ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                            ObjSales.Date = DateTime.Now;
                            ObjSales.Time = DateTime.Now;
                            ObjSales.IsReturn = 0;
                            ObjSales.LedgerTransactionNo = "";
                            if (Util.GetInt(ItemList[j].FromcentreID.ToString()) != Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()))
                                ObjSales.TrasactionTypeID = 27;
                            else
                                ObjSales.TrasactionTypeID = 1;
                            ObjSales.IsService = "NO";
                            ObjSales.IndentNo = IndentNo;
                            ObjSales.SalesNo = SalesNo;
                            ObjSales.DeptLedgerNo = ItemList[j].DeptLedgerNo.ToString();
                            ObjSales.UserID = ItemList[j].UserID.ToString();
                            ObjSales.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            ObjSales.medExpiryDate = Util.GetDateTime(dtResult.Rows[i]["MedExpiryDate"]);
                            ObjSales.IpAddress = All_LoadData.IpAddress();

                            ObjSales.TaxPercent = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                            ObjSales.TaxAmt = Util.GetDecimal(SaleTaxAmtPerUnit) * Util.GetDecimal(ItemList[j].IssueQuantity.ToString());

                            ObjSales.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                            ObjSales.PurTaxAmt = vatPuramt;
                            //GST Changes
                            decimal igstPercent = Util.GetDecimal(dtResult.Rows[i]["IGSTPercent"]);
                            decimal csgtPercent = Util.GetDecimal(dtResult.Rows[i]["CGSTPercent"]);
                            decimal sgstPercent = Util.GetDecimal(dtResult.Rows[i]["SGSTPercent"]);

                            decimal taxableAmt = (Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]) * 100 * Util.GetDecimal(ItemList[j].IssueQuantity.ToString())) / (100 + igstPercent + csgtPercent + sgstPercent);
                            //decimal nonTaxableRate = (Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                            // decimal discount = Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * objLTDetail.DiscountPercentage / 100;
                            // decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

                            decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                            decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                            decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);

                            ObjSales.IGSTPercent = igstPercent;
                            ObjSales.IGSTAmt = IGSTTaxAmount;
                            ObjSales.CGSTPercent = csgtPercent;
                            ObjSales.CGSTAmt = CGSTTaxAmount;
                            ObjSales.SGSTPercent = sgstPercent;
                            ObjSales.SGSTAmt = SGSTTaxAmount;
                            ObjSales.HSNCode = Util.GetString(dtResult.Rows[0]["HSNCode"]);
                            ObjSales.GSTType = Util.GetString(dtResult.Rows[0]["GSTType"]);
                            //

                            ObjSales.IpAddress = All_LoadData.IpAddress();
                            ObjSales.LedgerTransactionNo = "0";
                            ObjSales.Type_ID = "HS";
                            ObjSales.ToCentreID = Util.GetInt(ItemList[j].FromcentreID.ToString());

                            string SalesID = ObjSales.Insert();

                            if (SalesID == string.Empty)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "SalesID Not Found" });
                            }
                            if (stokID == string.Empty)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "StokID Not Found." });
                            }
                        }
                        else
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Stock Not Available." });
                        }
                    }

                }
                int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_roleMaster WHERE DeptLedgerNo='" + ItemList[0].DeptFrom.ToString() + "' "));
                //Notification_Insert.notificationInsert(26, IndentNo.ToString(), Tranx, "", "", roleID, "");
                All_LoadData.updateNotification(IndentNo, "", Util.GetString(HttpContext.Current.Session["RoleID"].ToString()), 27, Tranx, "Store");
                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    int Trans_Type = 1;

                    if (Util.GetInt(ItemList[0].FromcentreID.ToString()) != Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()))
                        Trans_Type = 27;

                    string IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(0, 0, Trans_Type, SalesNo, Tranx));
                    if (IsIntegrated == "0")
                    {
                        Tranx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Finance Integrated is not done, please contact to administrator." });
                    }
                }
            }
            Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SalesNo = SalesNo, response = "<b style='color:black;font-size: 16px;'> Sales Number &nbsp;:&nbsp;" + SalesNo + "&nbsp;is generated.</b></br><b style='color:black;font-size: 16px;'>Do you want to print ?</b>", message = "<b style='color:black;font-size: 16px;'> Sales Number &nbsp;:&nbsp;" + SalesNo + "&nbsp;is generated.</b></br><b style='color:black;font-size: 16px;'>" });                                      
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
   
    [WebMethod(EnableSession=true)]
    public static string GetIndentItemsStockDetails(string indentNo, string deptLedgerNo)
    {

        var sqlCmd = new StringBuilder("SELECT ST.stockid,IM.TypeName ItemName,fid.ItemID,fid.IndentNo, IFNULL(fid.ReqQty,0) TotalReqQty,(IFNULL(fid.ReqQty,0)-IFNULL(fid.ReceiveQty,0)) ReqQty,IFNULL(fid.RejectQty,0)RejectQty,IFNULL(fid.ReceiveQty,0)ReceiveQty,ST.BatchNumber,IFNULL(ST.MRP,0)MRP,IFNULL(ST.UnitPrice,0)UnitPrice,(IFNULL(ST.InitialCount,0) - IFNULL(ST.ReleasedCount,0)) AvlQty,IM.SubCategoryID,im.isexpirable,DATE_FORMAT(ST.MedExpiryDate, '%d-%b-%Y') MedExpiryDate,");
        sqlCmd.Append("ST.UnitType,im.ToBeBilled,ST.HSNCode,ST.IGSTPercent,ST.IGSTAmtPerUnit,ST.SGSTPercent,ST.SGSTAmtPerUnit,ST.CGSTPercent,ST.CGSTAmtPerUnit,ST.GSTType,im.Type_ID,im.IsUsable,im.ServiceItemID,'0' NewAvlQty,'' IssueQty,0 IssueChecked,st.PurTaxPer ");
        sqlCmd.Append(" ,fid.StoreId,fid.CentreID,fid.DeptFrom,fid.OLDItemID  FROM f_indent_detail fid ");
        sqlCmd.Append("INNER JOIN f_itemmaster IM  ON im.ItemID=fid.ItemId ");
        sqlCmd.Append("INNER JOIN f_subcategorymaster sub  ");
        sqlCmd.Append("ON sub.SubcategoryID = IM.SubcategoryID ");
        sqlCmd.Append("LEFT JOIN f_stock ST ON st.ItemID=im.ItemID AND (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 AND st.DeptLedgerNo = @deptLedgerNo   AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) > CURDATE())  AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ");
        sqlCmd.Append("WHERE  IM.ItemID = fid.ItemId ");
        sqlCmd.Append("AND fid.IndentNo=@indentNo AND fid.ReqQty>(fid.RejectQty+fid.ReceiveQty)");
        sqlCmd.Append("ORDER BY  ST.ItemID,st.MedExpiryDate limit 1  ");
        ExcuteCMD excuteCMD = new ExcuteCMD();

        DataTable dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            indentNo = indentNo,
            deptLedgerNo = deptLedgerNo
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
    }
    public DataTable addItem()
    {
        DataTable dt = new DataTable();
        string itemName = Util.GetString(Request.QueryString["q"]);
        string type = Util.GetString(Request.QueryString["type"]);
        if (itemName != "")
        {
            StringBuilder sb = new StringBuilder();
            if (type == "1")
            {
                sb.Append("Select ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
                sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber,");
                sb.Append(" ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");
                sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf ");
                sb.Append(" ,IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID=sm.SaltID WHERE fis.ItemID=im.ItemID GROUP BY im.ItemID),'') AS Generic ");
                sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID ");
                sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + lblDeptLedgerNo.Text + "' ");
                sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
                sb.Append(" AND TRIM(ST.ItemName) LIKE '%" + itemName + "%' ");
                sb.Append(" AND st.DeptLedgerNo='" + lblDeptLedgerNo.Text + "' ");
                sb.Append("  AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') AND CR.ConfigID = 11 ");
                sb.Append("  ORDER BY st.MedExpiryDate LIMIT " + Util.GetString(Request.QueryString["rows"]) + " ");
            }
            else if (type == "2")
            {
                sb.Append("Select ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
                sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber,");
                sb.Append(" ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty ,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");
                sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf,fsm.Name AS Generic ");
                sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID");
                sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=ST.ItemID Inner JOIN f_salt_master ");
                sb.Append(" fsm ON fis.saltID = fsm.SaltID AND fsm.IsActive=1 ");
                sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + lblDeptLedgerNo.Text + "' ");
                sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
                sb.Append(" AND TRIM(fsm.Name)  LIKE '%" + itemName + "%' ");
                sb.Append(" AND st.DeptLedgerNo='" + lblDeptLedgerNo.Text + "'  AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') AND CR.ConfigID = 11 ");
                sb.Append("  ORDER BY st.MedExpiryDate LIMIT " + Util.GetString(Request.QueryString["rows"]) + " ");
            }
            else if (type == "3")
            {
            }

            dt = StockReports.GetDataTable(sb.ToString());
        }

        return dt;
    }
    [WebMethod(EnableSession = true)]
    public static string RejectIndentItem(string indentID, string itemID, string rejectReason)
    {
        try
        {
            var sqlCmd = new StringBuilder("UPDATE f_indent_detail fid SET fid.RejectQty= (fid.ReqQty-fid.ReceiveQty),fid.RejectReason=@rejectReason,fid.RejectBy=@rejectBy,fid.dtReject=@rejectOn  ");
            if (string.IsNullOrEmpty(itemID))
                sqlCmd.Append(" WHERE  fid.IndentNo=@indentID ");
            else
                sqlCmd.Append(" WHERE fid.IndentNo=@indentID  AND fid.ItemId=@itemID ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            excuteCMD.DML(sqlCmd.ToString(), CommandType.Text, new
            {
                rejectReason = rejectReason,
                rejectBy = HttpContext.Current.Session["id"].ToString(),
                rejectOn = System.DateTime.Now.ToString("yyyy-MM-dd"),
                indentID = indentID,
                itemID = itemID
            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "" });
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator", response = ex.Message });
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindGenericItem(string ItemID, int StockID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select CONCAT(im.ItemID,'#',StockID,'#',AvailableQty)ItemID, CONCAT(fsm.Name,' # ',im.typename,' # (',sm.name,')',' # ',AvailableQty)ItemName from ( ");
        sb.Append(" select ItemID,(SUM(InitialCount) - SUM(ReleasedCount))AvailableQty,StockID from f_stock where (InitialCount - ReleasedCount) > 0 ");
        sb.Append(" and IsPost = 1 and  DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  and MedExpiryDate>CURDATE() and itemid='" + ItemID + "' and StockID <> " + StockID + " ");
        sb.Append(" group by ItemID ");
        sb.Append(" ) t1 inner join f_itemmaster im on t1.itemid = im.ItemID ");
        sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID ");
        sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=im.ItemID LEFT JOIN f_salt_master fsm ON fis.saltID = fsm.SaltID WHERE fsm.IsActive=1 ");



        DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    public class Item_Details
    {
        public float RejectQuantity { get; set; }
        public float IssueQuantity { get; set; }
        public float RequestQuatity { get; set; }        
        public string StoreID { get; set; }
        public string IndentNo { get; set; }
        public string ItemID { get; set; }
        public string StockID { get; set; }
        public string DeptLedgerNo { get; set; }
        public string FromcentreID { get; set; }
        public string DeptFrom { get; set; }
        public string UserID { get; set; }
        public string Types { get; set; }
        public string OldItemID { get; set; }

    
    }
       public class RejectItem_Details
    {
             
        public string StoreID { get; set; }
        public string IndentNo { get; set; }
        public string ItemID { get; set; }
        public string StockID { get; set; }
        public string DeptLedgerNo { get; set; }
        public string FromcentreID { get; set; }
        public string DeptFrom { get; set; }
        public string UserID { get; set; }
        public string Types { get; set; }
    } 
}

                        