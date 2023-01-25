using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Collections.Generic;


public partial class Design_Store_PurchaseOrderApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            calExtFromDate.EndDate = System.DateTime.Now;
            calExtToDate.EndDate = System.DateTime.Now;
            txtFromDate.Text = txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromDate.Text = txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }

    }
    [WebMethod(EnableSession=true)]
    public static string GetRequisitions(string fromDate, string toDate, string departmentLedgerNo, int CentreID, int RequestionTypeID, bool searchType)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = new DataTable();
        DataTable dtt = excuteCMD.GetDataTable("SELECT pom.FromAmount,pom.ToAmount,pom.CategoryId FROM f_POApproval_master pom WHERE pom.EmployeeId='" + HttpContext.Current.Session["ID"].ToString() + "' AND pom.IsActive=1 ", CommandType.Text);
        if (dtt.Rows.Count > 0)
        {
            var categoryIDs = Util.GetString(dtt.Rows[0]["CategoryId"]).Split(',');


            StringBuilder sqlCMD = new StringBuilder();
            sqlCMD.Append(" SELECT DISTINCT ");
            sqlCMD.Append(" (PO.PurchaseOrderNo), ");
            sqlCMD.Append(" (SELECT ");
            sqlCMD.Append(" NAME ");
            sqlCMD.Append(" FROM ");
            sqlCMD.Append("employee_master ");
            sqlCMD.Append("WHERE employeeID = PO.RaisedUserID) UserName, ");
            sqlCMD.Append("PO.Subject,  ");
            sqlCMD.Append("DATE_FORMAT(PO.RaisedDate, '%d-%b-%y') RaisedDate, ");
            sqlCMD.Append("PO.VendorName,  ");
            sqlCMD.Append("lm.ledgeruserid, ");
            sqlCMD.Append("PO.GrossTotal, ");
            sqlCMD.Append("  PO.Narration, ");
            sqlCMD.Append("ROUND(PO.Freight, 2) Freight, ");
            sqlCMD.Append("ROUND(PO.Roundoff, 2) Roundoff, ");
            sqlCMD.Append("ROUND(PO.Scheme, 2) Scheme,     ");
            sqlCMD.Append("ROUND(PO.ExciseOnBill, 2) ExciseOnBill  , ");
            sqlCMD.Append("SUM(pod.Amount)CategoryTotal ");
            sqlCMD.Append("FROM    ");
            sqlCMD.Append("f_purchaseorder PO    ");

            sqlCMD.Append(" INNER JOIN  f_purchaseorderdetails pod ON pod.PurchaseOrderNo=po.PurchaseOrderNo ");
            sqlCMD.Append(" INNER JOIN f_itemmaster im ON im.ItemID=pod.ItemID   ");
            sqlCMD.Append(" INNER JOIN f_subcategorymaster sb ON sb.SubCategoryID=im.SubCategoryID AND sb.CategoryID  IN ('" + string.Join("','", categoryIDs) + "')    ");

            sqlCMD.Append("INNER JOIN f_ledgermaster lm  ");
            sqlCMD.Append("ON lm.`LedgerNumber` = po.`VendorID` ");
            sqlCMD.Append(" LEFT JOIN f_purchaseorderapproval POA   ");
            sqlCMD.Append("ON PO.PurchaseOrderNo = POA.PONumber   ");
            sqlCMD.Append("WHERE PO.Status = 0                    ");
            sqlCMD.Append("AND PO.StoreLedgerNo IN ('STO00001', 'STO00002') AND pod.IsActive=1    ");
            sqlCMD.Append(" AND po.RaisedDate>=@fromDate  AND po.RaisedDate<=@toDate ");

            if (CentreID != 0)
            {
                sqlCMD.Append(" AND PO.CentreID=@centerID ");
            }


            // sqlCMD.Append("AND PO.DeptLedgerNo = @departmentLedgerNumber ");
            sqlCMD.Append(" GROUP BY po.PurchaseOrderNo");
            sqlCMD.Append(" HAVING CategoryTotal>=@fromAmount AND CategoryTotal <=@toAmount ");


            string sqlCMDString = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
            {
                departmentLedgerNumber = departmentLedgerNo,
                toAmount = Util.GetDecimal(dtt.Rows[0]["ToAmount"]),
                fromAmount = Util.GetDecimal(dtt.Rows[0]["FromAmount"]),
                fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00",
                toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59",
                centerID = CentreID
            });


             dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                departmentLedgerNumber = departmentLedgerNo,
                toAmount = Util.GetString(dtt.Rows[0]["ToAmount"]),
                fromAmount = Util.GetString(dtt.Rows[0]["FromAmount"]),
                fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00",
                toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59",
                centerID = CentreID
            });

            if (dt.Rows.Count > 0)
            {
                dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
                {
                    departmentLedgerNumber = departmentLedgerNo,
                    toAmount = Util.GetString(dtt.Rows[0]["ToAmount"]),
                    fromAmount = Util.GetString(dtt.Rows[0]["FromAmount"]),
                    fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00",
                    toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59",
                    centerID = CentreID
                });
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject("1");
            }
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject("0");
        }
    }


    [WebMethod(EnableSession=true)]
    public static string GetPurchaseOrderDetails(string purchaseOrderNumber)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();

        DataTable dtt = excuteCMD.GetDataTable("SELECT pom.FromAmount,pom.ToAmount,pom.CategoryId FROM f_POApproval_master pom WHERE pom.isactive=1 AND pom.EmployeeId='" + HttpContext.Current.Session["ID"].ToString() + "'", CommandType.Text);
        if (dtt.Rows.Count > 0)
        {
            var categoryIDs = Util.GetString(dtt.Rows[0]["CategoryId"]).Split(',');


            StringBuilder sqlCMD = new StringBuilder();
            sqlCMD.Append(" SELECT  ");
            sqlCMD.Append(" pod.ItemName,pod.ItemID,   ");
            sqlCMD.Append(" pod.PurchaseOrderDetailID, ");
            sqlCMD.Append(" pod.ApprovedQty,               ");
            sqlCMD.Append(" SUM(pod.Amount) CategoryTotal,pod.PurchaseOrderNo ,pod.BuyPrice,pod.Amount,pod.MRP     ");
            sqlCMD.Append("FROM    ");
            sqlCMD.Append("f_purchaseorder PO    ");

            sqlCMD.Append(" INNER JOIN  f_purchaseorderdetails pod ON pod.PurchaseOrderNo=po.PurchaseOrderNo ");
            sqlCMD.Append(" INNER JOIN f_itemmaster im ON im.ItemID=pod.ItemID   ");
            sqlCMD.Append(" INNER JOIN f_subcategorymaster sb ON sb.SubCategoryID=im.SubCategoryID AND sb.CategoryID  IN ('" + string.Join("','", categoryIDs) + "')    ");

            sqlCMD.Append("INNER JOIN f_ledgermaster lm  ");
            sqlCMD.Append("ON lm.`LedgerNumber` = po.`VendorID` ");
            sqlCMD.Append(" LEFT JOIN f_purchaseorderapproval POA   ");
            sqlCMD.Append("ON PO.PurchaseOrderNo = POA.PONumber   ");
            sqlCMD.Append("WHERE PO.Status = 0                    ");
            sqlCMD.Append("AND PO.StoreLedgerNo IN ('STO00001', 'STO00002')    ");
            sqlCMD.Append(" AND pod.IsActive=1 AND pod.IsReject=0 AND pod.PurchaseOrderNo=@purchaseOrderNumber  ");
            sqlCMD.Append(" GROUP BY pod.PurchaseOrderDetailID");
            sqlCMD.Append(" HAVING CategoryTotal>=@fromAmount AND CategoryTotal <=@toAmount ");


            string sqlCMDString = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
            {
                purchaseOrderNumber = purchaseOrderNumber,
                toAmount = Util.GetDecimal(dtt.Rows[0]["ToAmount"]),
                fromAmount = Util.GetDecimal(dtt.Rows[0]["FromAmount"])
            });


            DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                purchaseOrderNumber = purchaseOrderNumber,
                toAmount = Util.GetString(dtt.Rows[0]["ToAmount"]),
                fromAmount = Util.GetString(dtt.Rows[0]["FromAmount"])
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }




    [WebMethod(EnableSession = true)]
    public static string ApprovedPurchaseOrder(string purchaseOrderNumber, string remark)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {


            DataTable dtt = excuteCMD.GetDataTable("SELECT pom.FromAmount,pom.ToAmount,pom.CategoryId FROM f_POApproval_master pom WHERE pom.EmployeeId=@userID AND pom.IsActive=1 ", CommandType.Text, new
            {
                userID = HttpContext.Current.Session["ID"].ToString()
            });
            var categoryIDs = Util.GetString(dtt.Rows[0]["CategoryId"]).Split(',');

            StringBuilder sqlCMD = new StringBuilder();

            sqlCMD.Append("  UPDATE f_purchaseorderdetails pod INNER JOIN f_subcategorymaster sb ON pod.SubCategoryID=sb.SubCategoryID  SET pod.Approved=1 , pod.ApprovedBy=@approvedBY , pod.ApprovedOn=NOW() ");
            sqlCMD.Append("  WHERE pod.PurchaseOrderNo=@purchaseOrderNo AND  sb.CategoryID IN   ('" + string.Join("','", categoryIDs) + "')  ");


            var st = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
            {
                approvedBY = HttpContext.Current.Session["ID"].ToString(),
                purchaseOrderNo = purchaseOrderNumber
            });



            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                approvedBY = HttpContext.Current.Session["ID"].ToString(),
                purchaseOrderNo = purchaseOrderNumber
            });


            var pendingOrderQuantity = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM  f_purchaseorderdetails pod WHERE pod.Approved=0 AND pod.IsReject=0 AND pod.PurchaseOrderNo= @purchaseOrderNumber ", CommandType.Text, new
            {
                purchaseOrderNumber = purchaseOrderNumber
            }));


            if (pendingOrderQuantity == 0)
            {


                excuteCMD.DML(tnx, "Call POApproval(@purchaseOrderNumber,@userID,@userName,1,0)", CommandType.Text, new
                {
                    purchaseOrderNumber = purchaseOrderNumber,
                    userID = HttpContext.Current.Session["ID"].ToString(),
                    userName = HttpContext.Current.Session["UserName"].ToString()
                });


                //DataTable dtTerms = excuteCMD.GetDataTable("SELECT Terms FROM  f_vendor_terms WHERE Vendor_id=(SELECT po.VendorID FROM  f_purchaseorder po WHERE  po.PurchaseOrderNo=@purchaseOrderNumber)", CommandType.Text, new
                //{
                //    purchaseOrderNumber = purchaseOrderNumber
                //});

                //foreach (DataRow row in dtTerms.Rows)
                //{
                //    string terms = row["Terms"].ToString();
                //    excuteCMD.DML(tnx, "INSERT INTO f_purchaseorderterms(PONumber,Details) VALUES(@purchaseOrderNumber,@terms)", CommandType.Text, new
                //    {
                //        purchaseOrderNumber = purchaseOrderNumber,
                //        terms = terms
                //    });
                //}
                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    var dataTable = excuteCMD.GetDataTable("SELECT (f.AmountAdvance/f.C_Factor)Amount,f.C_Factor,f.S_Currency,f.Remarks,f.RaisedDate,v.COA_ID,f.PurchaseOrderNo FROM  f_purchaseorder f INNER JOIN  f_ledgermaster lm ON lm.LedgerNumber=f.VendorID INNER JOIN  f_vendormaster v ON lm.LedgerUserID=v.Vendor_ID WHERE f.PurchaseOrderNo=@purchaseOrder", CommandType.Text, new
                    {
                        purchaseOrder = purchaseOrderNumber
                    });
                    string IsIntegrated = Util.GetString(EbizFrame.InsertPurchaseOrderAdvance(
                                  dataTable.Rows[0]["COA_ID"].ToString(),
                                 Util.GetDecimal(dataTable.Rows[0]["Amount"].ToString()),
                                 dataTable.Rows[0]["PurchaseOrderNo"].ToString(),
                                 dataTable.Rows[0]["Remarks"].ToString().Replace("'"," "),
                                 dataTable.Rows[0]["S_Currency"].ToString(),
                                 Util.GetDecimal(dataTable.Rows[0]["C_Factor"].ToString()),
                                 Util.GetDateTime(dataTable.Rows[0]["RaisedDate"].ToString()),
                                 tnx
                        ));
                    if (IsIntegrated == "0")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                    }
                }

                All_LoadData.updateNotification(purchaseOrderNumber, string.Empty, Util.GetString(HttpContext.Current.Session["RoleID"].ToString()), 31, null, "Store");
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }




    [WebMethod(EnableSession = true)]
    public static string RejectPurchaseOrder(string purchaseOrderNumber, string remark)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {




            var ss = excuteCMD.GetRowQuery("Call usp_RejectPO(@purchaseOrderNumber,@userID,@userName,@remarks)", new
            {
                purchaseOrderNumber = purchaseOrderNumber,
                userID = HttpContext.Current.Session["ID"].ToString(),
                userName = HttpContext.Current.Session["UserName"].ToString(),
                remarks = remark
            });



            excuteCMD.DML(tnx, "Call usp_RejectPO(@purchaseOrderNumber,@userID,@userName,@remarks)", CommandType.Text, new
                {
                    purchaseOrderNumber = purchaseOrderNumber,
                    userID = HttpContext.Current.Session["ID"].ToString(),
                    userName = HttpContext.Current.Session["UserName"].ToString(),
                    remarks = remark
                });


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class purchaseOrderDetail
    {
        public int purchaseOrderDetailsID { get; set; }
        public decimal quantity { get; set; }
        public string purchaseOrderNo { get; set; }
    }


    [WebMethod(EnableSession = true)]
    public static string UpdatePurchaseOrder(List<purchaseOrderDetail> purchaseOrderDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            string sqlCMD = "";
            if (Resources.Resource.IsGSTApplicable == "1")
            {
                sqlCMD = "UPDATE f_purchaseorderdetails pod SET pod.ApprovedQty=@quantity,Discount_a=ROUND((POD.Rate*@quantity*POD.Discount_p*0.01),6),VATAmt=ROUND(( ((POD.Rate*@quantity)-ROUND((POD.Rate*@quantity*POD.Discount_p*0.01),6))*(POD.IGSTPercent+POD.CGSTPercent+POD.SGSTPercent)*0.01),6),Amount= ROUND((POD.Rate*@quantity)-(POD.Rate*@quantity*POD.Discount_p*0.01),6)+ROUND(( ((POD.Rate*@quantity)-ROUND((POD.Rate*@quantity*POD.Discount_p*0.01),6))*(POD.IGSTPercent+POD.CGSTPercent+POD.SGSTPercent)*0.01),6),IGSTAmt=ROUND(((POD.Rate*@quantity)*POD.IGSTPercent)/100,2),CGSTAmt=ROUND(((POD.Rate*@quantity)*POD.CGSTPercent)/100,2),SGSTAmt=ROUND(((POD.Rate*@quantity)*POD.SGSTPercent)/100,2), LastUpdatedBy=@userID,Updatedate=now()  WHERE pod.PurchaseOrderDetailID=@purchaseOrderDetailID";
            }
            else
            {
                sqlCMD = "UPDATE f_purchaseorderdetails pod SET pod.ApprovedQty=@quantity,Discount_a=ROUND((POD.Rate*@quantity*POD.Discount_p*0.01),6),VATAmt=ROUND(( ((POD.Rate*@quantity)-ROUND((POD.Rate*@quantity*POD.Discount_p*0.01),6))*POD.VATPer*0.01),6),Amount= ROUND(((POD.Rate*@quantity)-  ROUND((POD.Rate*@quantity*POD.Discount_p*0.01),6)+ ROUND(( ((POD.Rate*@quantity)-ROUND((POD.Rate*@quantity*POD.Discount_p*0.01),6))*POD.VATPer*0.01),6)),6), LastUpdatedBy=@userID,Updatedate=now()  WHERE pod.PurchaseOrderDetailID=@purchaseOrderDetailID";
            }
            for (int i = 0; i < purchaseOrderDetails.Count; i++)
            {
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    quantity = purchaseOrderDetails[i].quantity,
                    purchaseOrderDetailID = purchaseOrderDetails[i].purchaseOrderDetailsID,
                    userID = HttpContext.Current.Session["ID"].ToString()
                });
            }


            sqlCMD = "UPDATE f_purchaseorder po INNER JOIN (    SELECT SUM(Amount) POAmt,PurchaseOrderNo FROM f_purchaseorderdetails WHERE PurchaseOrderNo=@purchaseOrderNo )t ON t.PurchaseOrderNo=po.PurchaseOrderNo SET po.GrossTotal=t.POAmt,po.NetTotal=t.POAmt+po.Freight+ROUND((ROUND(po.GrossTotal+po.Freight-po.Scheme+po.ExciseOnBill)-ROUND(po.GrossTotal+po.Freight-po.Scheme+po.ExciseOnBill,6)),6)-po.Scheme+po.ExciseOnBill,po.LastUpdatedDate=NOW(),po.LastUpdatedUserID=@userID,po.IPAddress=@ipAddress, po.Roundoff= ROUND((ROUND(po.GrossTotal+po.Freight-po.Scheme+po.ExciseOnBill)-ROUND(po.GrossTotal+po.Freight-po.Scheme+po.ExciseOnBill,6)),6) WHERE po.PurchaseOrderNo=@purchaseOrderNo ";
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                purchaseOrderNo = purchaseOrderDetails[0].purchaseOrderNo,
                userID = HttpContext.Current.Session["ID"].ToString(),
                ipAddress = All_LoadData.IpAddress()
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public static string CancelPurchaseOrderItem(string purchaseOrderDetailID, string PONo, string itemID, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            //string sqlCMD = "UPDATE  f_purchaseorderdetails  pod SET pod.IsReject=1 ,pod.RejectQty=pod.ApprovedQty,pod.CancelUserID=@userID ,pod.CancelUserName=@userName WHERE pod.PurchaseOrderDetailID=@purchaseOrderDetailID";

            //excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            //{
            //    userID = HttpContext.Current.Session["ID"].ToString(),
            //    userName = HttpContext.Current.Session["LoginName"].ToString(),
            //    purchaseOrderDetailID = purchaseOrderDetailID
            //});

            string sqlCMD = "call usp_RejectPO_Item(@poNumber,@itemID,@userID,@userName,@purchaseOrderDetailID,@rejectReason)";

            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                poNumber = PONo,
                itemID = itemID,
                userID = HttpContext.Current.Session["ID"].ToString(),
                userName = HttpContext.Current.Session["LoginName"].ToString(),
                purchaseOrderDetailID = purchaseOrderDetailID,
                rejectReason = Remarks
            });

            string ChkItem = "Select * from f_purchaseorderdetails where  PurchaseOrderNo='" + PONo + "' and STATUS<>2";
            DataTable dtitemDetail = StockReports.GetDataTable(ChkItem);
            if (dtitemDetail.Rows.Count == 0)
            {
                sqlCMD = "call usp_RejectPO(@poNumber,@userID,@userName,@rejectReason)";

                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    poNumber = PONo,
                    userID = HttpContext.Current.Session["ID"].ToString(),
                    userName = HttpContext.Current.Session["LoginName"].ToString(),
                    rejectReason = ""
                });

            }

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



}