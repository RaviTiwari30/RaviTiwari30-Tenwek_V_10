<%@ WebService Language="C#" Class="Panel_Invoice" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Linq;
using System.Text;
using System.IO;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Panel_Invoice : System.Web.Services.WebService
{

    [WebMethod(EnableSession = true)]
    [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    public string GetMessages(string BillFromDate, string BillToDate, string PatientID, string ClaimNo, string PolicyNo, string IPDNo, string DocketNo, string DispatchNo, string DispatchDate, int PanelID, string Type, string Status, string CashCredit, string chkDispatchDate, int IsCoverNote)
    {
        PanelInvoice PI = new PanelInvoice();

        DataTable dt = PI.bindDispatchData(BillFromDate, BillToDate, PatientID, ClaimNo, PolicyNo, IPDNo, DocketNo, DispatchNo, DispatchDate, PanelID, Type, Status, CashCredit, chkDispatchDate, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), IsCoverNote);
        DataColumn dc = new DataColumn("maxBillDate");

        dc.DefaultValue = dt.Compute("MAX(BillDate)", null);
        dt.Columns.Add(dc);

        if ((dt.Rows.Count > 0) && (dt != null))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    public string saveDispatch(object Dispatch)
    {
        PanelInvoice PI = new PanelInvoice();
        string result = PI.saveDispatch(Dispatch, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()));
        return result;
    }
    [WebMethod(EnableSession = true)]
    public string panelInvoiceSearch(string InvoiceNo, string IPDNo)
    {
        PanelInvoice PI = new PanelInvoice();
        DataTable dt = PI.searchInvoicedata(InvoiceNo, IPDNo);
        if ((dt.Rows.Count > 0) && (dt != null))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindInvoiceData(string invoiceNo, string IPDNo)
    {
        PanelInvoice PI = new PanelInvoice();
        DataTable dt = PI.invoiceDetailData(invoiceNo, IPDNo);
        if ((dt.Rows.Count > 0) && (dt != null))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string saveSettlement(object Invoice, decimal ReceivedAmount, decimal TDSAmount, decimal WriteOff, decimal DeducationAmt, string Type, string InvoiceNo, string InvoiceDate, int PanelID, string PatientType, decimal balanceAmount, decimal InvoiceAmount,string onAccountVoucharID)
    {
        PanelInvoice PI = new PanelInvoice();
        string outPut = PI.saveSettlement(Invoice, ReceivedAmount, TDSAmount, WriteOff, DeducationAmt, Type, InvoiceNo, InvoiceDate, PanelID, PatientType, balanceAmount, InvoiceAmount, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), onAccountVoucharID);
        return outPut;
    }
    [WebMethod(EnableSession = true)]
    public string InvoiceCancelData(string InvoiceNo)
    {
        PanelInvoice PI = new PanelInvoice();
        DataTable canceldt = PI.InvoiceCancelData(InvoiceNo);
        if ((canceldt.Rows.Count > 0) && (canceldt != null))
            return Newtonsoft.Json.JsonConvert.SerializeObject(canceldt);
        else
            return "";

    }
    [WebMethod(EnableSession = true)]
    public string InvoiceCancel(string InvoiceNo, string ID, decimal receivedAmt, decimal tdsAmt, decimal writeOff, decimal decAmt, string cancelReason, string Type)
    {
        PanelInvoice PI = new PanelInvoice();
        return PI.InvoiceCancel(InvoiceNo, ID, receivedAmt, tdsAmt, writeOff, decAmt, cancelReason, Type);
       

    }

    [WebMethod(EnableSession = true)]
    public string dispatchReport(string InvoiceNo)
    {

        DataTable dt = StockReports.GetDataTable("CALL panel_dispatchReport('" + InvoiceNo + "')");
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            DataTable dtImg = AllLoadData_OPD.CrystalReportLogoForInvoice();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[1].TableName = "logo";
            //   ds.WriteXmlSchema("E:\\dispatchReport.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "dispatchReport";
            return "1";
        }

        else
        {
            return "0";
        }
    }
    [WebMethod]
    public string dispatchCancelData(string InvoiceNo)
    {
        PanelInvoice PI = new PanelInvoice();
        string con = PI.dispatchCancelData(InvoiceNo);
        return con;

    }
    [WebMethod]
    public string dispatchData(string InvoiceNo)
    {
        PanelInvoice PI = new PanelInvoice();
        DataTable dt = PI.dispatchData(InvoiceNo);
        if ((dt.Rows.Count > 0) && (dt != null))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod(EnableSession = true)]
    public string dispatchCancel(string InvoiceNo, string cancelReason, string type)
    {
        PanelInvoice PI = new PanelInvoice();
        string con = PI.dispatchCancel(InvoiceNo, cancelReason,type);
        return con;

    }
    [WebMethod(EnableSession = true)]
    public string IPDDetailedBill(string TransactionID)
    {
        try
        {
            TransactionID = string.Concat("ISHHI", TransactionID);
            DataSet ds = new DataSet();

            ds.Tables.Add(IPDBilling.GetBilledPatientDetail(TransactionID).Copy());
            ds.Tables[0].TableName = "dtBilled";
            ds.Tables.Add(IPDBilling.GetBilledPatientItemDetail(TransactionID).Copy());
            ds.Tables[1].TableName = "dtBilledDetail";

            DataTable Table = new DataTable();
            Table = ds.Tables["dtBilledDetail"].Copy();
            Table.TableName = "Table";

            DataTable dtBilled = new DataTable();
            dtBilled = ds.Tables["dtBilled"].Copy();
            Table.TableName = "dtBilled";          
            AllQuery AQ = new AllQuery();
            DataTable dtNetAmtWord = AllLoadData_IPD.patientIPDDetail(TransactionID, Table, dtBilled.Rows[0]["BillNo"].ToString().Trim());                    
            DataTable dtReceipt = new DataTable();
            dtReceipt = AllLoadData_IPD.IPDReceipt(TransactionID);                     
            DataTable dtVerLedgerTnxDetails = new DataTable();

            if (!Table.Columns.Contains("ShowSummary"))
            {
                Table.Columns.Add("ShowSummary");
            }
            dtVerLedgerTnxDetails = Table.Clone();

            
            
            DataRow[] drLtnxDetails = Table.Select("IsVerified=1 and IsPackage =0");
            foreach (DataRow dr in drLtnxDetails)
            {
                if (dr["DisplayName"].ToString() == "")
                {
                    dr["DisplayName"] = "#";
                }
                if (dr["DisplayName"].ToString() == "CROSS CONSULTANCY" || dr["DisplayName"].ToString() == "Room Charges" || dr["DisplayName"].ToString() == "IPD CONSULTATION" || dr["DisplayName"].ToString() == "EQUIPMENT CHARGES" || dr["DisplayName"].ToString() == "INJECTION CHARGES" || dr["DisplayName"].ToString() == "Package" || dr["DisplayName"].ToString() == "Procedure Charges" || dr["DisplayName"].ToString() == "STENT CHARGES" || dr["DisplayName"].ToString() == "OTHER CHARGES" || dr["DisplayName"].ToString() == "Procedure Charges." || dr["DisplayName"].ToString() == "NURSING CARE CHARGES" || dr["DisplayName"].ToString() == "RMO CHARGES")
                {
                    if (dr["DisplayName"].ToString() == "IPD CONSULTATION" || dr["DisplayName"].ToString() == "CROSS CONSULTANCY")
                    {
                        dr["ItemName"] = "Dr. " + dr["ItemName"].ToString() + "  (" + dr["Specialization"].ToString() + ")";
                    }
                    dr["ShowSummary"] = 1;
                }
                else
                {
                    dr["ShowSummary"] = 0;
                }
                dtVerLedgerTnxDetails.ImportRow(dr);
            }

            DataTable dtHeader = AllLoadData_IPD.patientIPDHeader(dtBilled.Rows[0]["PatientID"].ToString(), dtBilled.Rows[0]["TransactionID"].ToString());           
            dtHeader.TableName = "Header";
            
            dtBilled.TableName = "LedgerTnx";
            dtVerLedgerTnxDetails.TableName = "LedgerTnxDetails";
            
           


            if (dtNetAmtWord != null && dtNetAmtWord.Rows[0]["DiscountReason"].ToString() == "")
            {
                DataRow[] rowDis = dtVerLedgerTnxDetails.Select("DiscountReason <>''");

                if (rowDis.Length > 0)
                {
                    foreach (DataRow row1 in rowDis)
                    {
                        dtNetAmtWord.Rows[0]["DiscountReason"] = row1["DiscountReason"].ToString();
                        break;
                    }
                }
            }
            DataView dv = dtVerLedgerTnxDetails.DefaultView;
            dv.Sort = "DisplayPriority";
            dtVerLedgerTnxDetails = dv.ToTable();

            dtNetAmtWord.Rows[0]["IsBilledClosed"] = StockReports.ExecuteScalar("Select IsBilledClosed from f_ipdadjustment where TransactionID='" + dtBilled.Rows[0]["TransactionID"].ToString() + "'");



            if (dtReceipt != null && dtReceipt.Columns.Contains("PanelName") == false) dtReceipt.Columns.Add("PanelName");
            decimal NetAmtReceived = 0;
            if (dtReceipt != null && dtReceipt.Rows.Count > 0)
            {
                string PanelName = AQ.GetPanelByID(dtBilled.Rows[0]["PanelID"].ToString()).Rows[0][0].ToString();

                for (int i = 0; i < dtReceipt.Rows.Count; i++)
                {
                    dtReceipt.Rows[i]["PanelName"] = PanelName;
                }

                NetAmtReceived = Util.GetDecimal(Math.Round(Util.GetDecimal(dtReceipt.Compute("sum(AmountPaid)", ""))));
            }

            dtNetAmtWord.Rows[0]["ReceivedAmt"] = NetAmtReceived.ToString();

           

            DataTable dtdebit = new DataTable();
            dtdebit = AllLoadData_IPD.IPDDebitNote(TransactionID);
            dtdebit.TableName = "Debit";
            
            
            DataTable dtCredit = new DataTable();
            dtCredit = AllLoadData_IPD.IPDCreditNote(TransactionID);
            dtCredit.TableName = "Crebit";
            
           
            ds.Tables.Add(dtBilled.Copy());
            ds.Tables.Add(dtVerLedgerTnxDetails);

            DataColumn dc = new DataColumn();
            dc.ColumnName = "lang_code";
            dc.DefaultValue = Resources.Resource.Lang_Code;
            dtHeader.Columns.Add(dc);
            ds.Tables.Add(dtHeader);
            ds.Tables.Add(dtNetAmtWord);

            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "lang_code";
            dc1.DefaultValue = Resources.Resource.Lang_Code;
            dtReceipt.Columns.Add(dc1);
            dtReceipt.AcceptChanges();

            ds.Tables.Add(dtReceipt.Copy());
            ds.Tables.Add(dtCredit.Copy());
            ds.Tables.Add(dtdebit.Copy());


            string str = "Select LTD.LedgerTransactionNo,idt.SubItemName,idt.Rate as SubItemRate,idt.ItemID from (Select * from f_ledgertnxdetail where TransactionID = '" + dtBilled.Rows[0]["TransactionID"].ToString() + "' AND Isverified <> 2 group by ItemID) ltd inner join f_itemdetail idt on idt.ItemID = ltd.ItemID and idt.IsActive = 1 and idt.PanelID=" + dtBilled.Rows[0]["PanelID"].ToString() + " order by LTD.ItemID,date(LTD.EntryDate)";
            DataTable dtItemdt = StockReports.GetDataTable(str);

            dtItemdt.TableName = "ItemDetail";
            ds.Tables.Add(dtItemdt.Copy());
            HttpContext.Current.Session["ReportName"] = "BillReportDetails";
            HttpContext.Current.Session["ds"] = ds;
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public string IPDSummaryBill(string TransactionID)
    {
        try
        {
            TransactionID = string.Concat("ISHHI", TransactionID);
            DataSet ds = new DataSet();

            ds.Tables.Add(IPDBilling.GetBilledPatientDetail(TransactionID).Copy());
            ds.Tables[0].TableName = "dtBilled";
            ds.Tables.Add(IPDBilling.GetBilledPatientItemDetail(TransactionID).Copy());
            ds.Tables[1].TableName = "dtBilledDetail";

            DataTable Table = new DataTable();
            Table = ds.Tables["dtBilledDetail"].Copy();
            Table.TableName = "Table";

            DataTable dtBilled = new DataTable();
            dtBilled = ds.Tables["dtBilled"].Copy();
            Table.TableName = "dtBilled";
            AllQuery AQ = new AllQuery();
            DataTable dtNetAmtWord = AllLoadData_IPD.patientIPDDetail(TransactionID, Table, dtBilled.Rows[0]["BillNo"].ToString().Trim());
            DataTable dtReceipt = new DataTable();
            dtReceipt = AllLoadData_IPD.IPDReceipt(TransactionID);
            DataTable dtVerLedgerTnxDetails = new DataTable();
            if (!Table.Columns.Contains("ShowSummary"))
            {
                Table.Columns.Add("ShowSummary");
            }
            dtVerLedgerTnxDetails = Table.Clone();



            DataRow[] drLtnxDetails = Table.Select("IsVerified=1 and IsPackage =0");
            foreach (DataRow dr in drLtnxDetails)
            {
                if (dr["DisplayName"].ToString() == "")
                {
                    dr["DisplayName"] = "#";
                }

                dr["ShowSummary"] = 0;


                dtVerLedgerTnxDetails.ImportRow(dr);
            }

            DataTable dtHeader = AllLoadData_IPD.patientIPDHeader(dtBilled.Rows[0]["PatientID"].ToString(), dtBilled.Rows[0]["TransactionID"].ToString());
            dtHeader.TableName = "Header";

            dtBilled.TableName = "LedgerTnx";
            dtVerLedgerTnxDetails.TableName = "LedgerTnxDetails";



            if (dtNetAmtWord != null && dtNetAmtWord.Rows[0]["DiscountReason"].ToString() == "")
            {
                DataRow[] rowDis = dtVerLedgerTnxDetails.Select("DiscountReason <>''");

                if (rowDis.Length > 0)
                {
                    foreach (DataRow row1 in rowDis)
                    {
                        dtNetAmtWord.Rows[0]["DiscountReason"] = row1["DiscountReason"].ToString();
                        break;
                    }
                }
            }
            DataView dv = dtVerLedgerTnxDetails.DefaultView;
            dv.Sort = "DisplayPriority";
            dtVerLedgerTnxDetails = dv.ToTable();
            if (dtReceipt != null && dtReceipt.Columns.Contains("PanelName") == false) dtReceipt.Columns.Add("PanelName");
            decimal NetAmtReceived = 0;
            if (dtReceipt != null && dtReceipt.Rows.Count > 0)
            {
                string PanelName = AQ.GetPanelByID(dtBilled.Rows[0]["PanelID"].ToString()).Rows[0][0].ToString();

                for (int i = 0; i < dtReceipt.Rows.Count; i++)
                {
                    dtReceipt.Rows[i]["PanelName"] = PanelName;
                }

                NetAmtReceived = Util.GetDecimal(Math.Round(Util.GetDecimal(dtReceipt.Compute("sum(AmountPaid)", ""))));
            }

            dtNetAmtWord.Rows[0]["ReceivedAmt"] = NetAmtReceived.ToString();
            DataTable dtdebit = new DataTable();
            dtdebit = AllLoadData_IPD.IPDDebitNote(TransactionID);
            dtdebit.TableName = "Debit";


            DataTable dtCredit = new DataTable();
            dtCredit = AllLoadData_IPD.IPDCreditNote(TransactionID);
            dtCredit.TableName = "Crebit";

            ds.Tables.Add(dtBilled.Copy());
            ds.Tables.Add(dtVerLedgerTnxDetails);

            DataColumn dc = new DataColumn();
            dc.ColumnName = "lang_code";
            dc.DefaultValue = Resources.Resource.Lang_Code;
            dtHeader.Columns.Add(dc);
            ds.Tables.Add(dtHeader);
            ds.Tables.Add(dtNetAmtWord);

            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "lang_code";
            dc1.DefaultValue = Resources.Resource.Lang_Code;
            dtReceipt.Columns.Add(dc1);
            dtReceipt.AcceptChanges();

            ds.Tables.Add(dtReceipt.Copy());
            ds.Tables.Add(dtCredit.Copy());
            ds.Tables.Add(dtdebit.Copy());

            string str = "Select LTD.LedgerTransactionNo,idt.SubItemName,idt.Rate as SubItemRate,idt.ItemID from (Select * from f_ledgertnxdetail where TransactionID = '" + dtBilled.Rows[0]["TransactionID"].ToString() + "' AND Isverified <> 2 group by ItemID) ltd inner join f_itemdetail idt on idt.ItemID = ltd.ItemID and idt.IsActive = 1 and idt.PanelID=" + dtBilled.Rows[0]["PanelID"].ToString() + " order by LTD.ItemID,date(LTD.EntryDate)";
            DataTable dtItemdt = StockReports.GetDataTable(str);

            dtItemdt.TableName = "ItemDetail";
            ds.Tables.Add(dtItemdt.Copy());

            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "BillReportSummary";
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
            return "0";
        }
    }


    [WebMethod(EnableSession = true)]
    public string dispatchReportAll(string InvoiceNo,String Type)
    {

        return PanelInvoice.dispatchReportAll(InvoiceNo,Type);
    }
    [WebMethod(EnableSession=true)]
    public string oldPatientSearch(string PatientID, string PName, string LName, string ContactNo, string Address, string FromDate, string ToDate,string invoiceSetellment,string PanelID= "")
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  pm.Title,pm.PName,pm.PFirstName,pm.PLastName,IF(pm.DOB='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y')) AS DOB,dis.PanelInvoiceNo,");
        sb.Append(" pm.Age,pm.Gender,DATE_FORMAT(pm.DateEnrolled,'%d-%b-%Y') AS Date,pm.House_No,SUBSTRING(pm.House_No,'1','20')SubHouseNo,IFNULL(pm.mobile,'')ContactNo,pm.Email,pm.Country,pm.City,pm.Relation,pm.RelationName ");
        sb.Append("  ,pm.PatientID MRNo,'1' PatientRegStatus FROM patient_master pm inner join f_dispatch dis on dis.PatientID=pm.PatientID ");
        if (invoiceSetellment == "2")
            sb.Append(" inner join f_panelonaccount acc on dis.PanelInvoiceNo=acc.invoiceNo ");
        sb.Append("    WHERE pm.PatientType<>2 AND pm.PatientID <>'' AND dis.CentreID=" + Session["CentreID"].ToString() + " ");
        if (PatientID.Trim() != "")
            sb.Append(" AND pm.PatientID='" + PatientID.Trim() + "'");
        if (PName.Trim() != "")
            sb.Append(" AND pm.PFirstName LIKE '%" + PName.Trim() + "%'");
        if (LName.Trim() != "")
            sb.Append(" AND pm.PLastName LIKE '%" + LName.Trim() + "%'");
        if (PatientID.Trim() == "" && ContactNo.Trim() == "" && PName.Trim() == "" && LName.Trim() == "")
        {
            if (FromDate.Trim() != "" && ToDate.Trim() != "")
                if(invoiceSetellment == "2")
                    sb.Append(" AND DATE(acc.createdDate)>= '" + Util.GetDateTime(FromDate.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(acc.createdDate)<='" + Util.GetDateTime(ToDate.Trim()).ToString("yyyy-MM-dd") + "'");             
                else
                sb.Append(" AND DATE(dis.EntryDate)>= '" + Util.GetDateTime(FromDate.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(dis.EntryDate)<='" + Util.GetDateTime(ToDate.Trim()).ToString("yyyy-MM-dd") + "'");
        }
        if (Address.Trim() != "")
            sb.Append(" AND pm.House_No LIKE '" + Address.Trim() + "%'");
        if (ContactNo.Trim() != "")
            sb.Append(" AND (pm.Phone = '" + ContactNo.Trim() + "' OR pm.Mobile = '" + ContactNo.Trim() + "') ");
        sb.Append(" And dis.isCancel=0 AND dis.IsDispatched=1 ");
        if(invoiceSetellment=="1")
        sb.Append(" AND dis.IsSettled IN(0,2)  ");
        if(invoiceSetellment == "0")
            sb.Append(" AND dis.IsSettled IN(0,1,2)  ");
        if(invoiceSetellment == "2")
            sb.Append(" AND  acc.IsActive=1 AND iscancelled=0  ");
        if (PanelID != string.Empty && PanelID != "0")
        {
            sb.Append(" AND  dis.PanelID='" + PanelID + "'  ");
        }
        sb.Append(" ORDER BY dis.EntryDate DESC LIMIT 100");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}