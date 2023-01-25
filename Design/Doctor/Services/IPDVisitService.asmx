<%@ WebService Language="C#" CodeBehind="~/App_Code/IPDVisitService.cs" Class="IPDVisitService" %>

using System;
using System.Web;
using System.Collections;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
/// <summary>
/// Summary description for IPDVisitService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class IPDVisitService : System.Web.Services.WebService
{

    public IPDVisitService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }
    

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
  //  public string GetIPDVisit(string TransactionID, string DoctorID, string RoomTypeID, string PanelID)
    public string GetIPDVisit(string TransactionID, string DoctorID, string RoomTypeID, string PanelID, string ScheduleChargeID)
    {
        string Jsondata = string.Empty;
        //IPD Visit

        PanelID = StockReports.ExecuteScalar("SELECT ReferenceCode FROM f_panel_master WHERE PanelID=" + PanelID + "  ");
        DataTable dtGridTable = new DataTable();
        
        StringBuilder sb=new StringBuilder();
        
        sb.Append(" SELECT DateOfAdmit,DateOfDischarge,IF(STATUS='out',DATEDIFF(DateOfDischarge,DateOfAdmit),DATEDIFF(CURDATE(),DateOfAdmit))+1 ts,NAME,CONCAT(SubCategoryID,'_',ItemID,'_',IFNULL(Rate,0),'_',IFNULL(rateListID,0),'_',ifnull(itemcode,''))a  FROM patient_medical_history ich INNER JOIN (  ");
        sb.Append("   SELECT im.ItemID,im.SubcategoryID,sm.Name,IFNULL(Rate,0)Rate,IFNULL(rli.ID,0)rateListID,rli.itemcode,CAST('" + TransactionID + "' AS CHAR) TransactionID FROM    f_itemmaster im ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubcategoryID=im.subcategoryID      INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.CategoryID ");
        sb.Append(" INNER JOIN   f_configrelation cf ON cf.CategoryID=cm.CategoryID ");
     //   sb.Append(" LEFT OUTER JOIN f_ratelist_ipd rli ON rli.itemID=im.ItemID    AND PanelID=" + PanelID + " AND IpdCaseTypeID='" + RoomTypeID + "'  AND IsCurrent=1 and rli.ScheduleChargeID='"+ScheduleChargeID+"'");
        sb.Append(" LEFT OUTER JOIN f_ratelist_ipd rli ON rli.itemID=im.ItemID    AND PanelID=" + PanelID + " AND IpdCaseTypeID='" + RoomTypeID + "'  AND IsCurrent=1 ");
        sb.Append(" WHERE  cf.ConfigID=1 AND sm.Active=1  AND im.Type_ID='" + DoctorID + "' AND im.Isactive=1     )r ON ich.TransactionID=r.TransactionID  WHERE ich.Type='IPD' ORDER BY SubcategoryID");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            dtGridTable.Columns.Add("VisitDate", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                dtGridTable.Columns.Add(row["Name"].ToString() + "_s_" + row["a"].ToString(), typeof(bool)).DefaultValue = false;
            }
        }
        if (dt.Rows.Count > 0)
        {
            DataTable dtDoctorVistiDetail = StockReports.GetDataTable(" SELECT ItemID,DATE(EntryDate)DATE FROM f_ledgertnxdetail ltd  WHERE ConfigID=1 and ltd.TransactionID='" + TransactionID + "' AND IsVerified=1 ");
            DateTime admitDate = Util.GetDateTime(dt.Rows[0]["DateOfAdmit"]);
            int ts = Util.GetInt(dt.Rows[0]["ts"]);

            for (int i = 0; i < ts; i++)
            {
                DataRow dr = dtGridTable.NewRow();
                dr["VisitDate"] = admitDate.AddDays((double)i).ToString("dd-MMM-yyyy"); ;
                for (int j = 1; j < dtGridTable.Columns.Count; j++)
                {
                    string columnName = dtGridTable.Columns[j].ColumnName.Replace("_s_", "$");
                    string ItemID = columnName.Split('$')[1].Split('_')[1];
                    if (dtDoctorVistiDetail.Select(" ItemID='" + ItemID + "' and DATE='" + Util.GetDateTime(dr["VisitDate"]).ToString("yyyy-MM-dd") + "'").Length > 0)
                    {
                        dr[j] = "true";
                    }
                    else
                    {
                        dr[j] = "false";
                    }
                }
                dtGridTable.Rows.Add(dr);
            }
        }
       
        return Jsondata = Newtonsoft.Json.JsonConvert.SerializeObject(dtGridTable);
    }

    [WebMethod(EnableSession=true)]
    public int SaveIPDVisit(string Data, string PatientID, string TransactionID, string userID, int PanelID, string ItemName, string DoctorID, string IPDCaseType_ID, string PatientType, string Room_ID)
    {
        
        string MembershipNo = StockReports.ExecuteScalar("SELECT IF(DATE(pm.MemberShipDate)>=CURDATE(),IFNULL(pm.MemberShip,''),'')MemberShipCardNo from patient_master pm where PatientID='" + PatientID + "'");
        string patientTypeID = StockReports.ExecuteScalar("SELECT pmh.PatientTypeID FROM patient_medical_history pmh WHERE pmh.TransactionID='" + TransactionID + "'");
        
                                   
        string[] visitDetail = Data.Split('_');

        string HospID = Convert.ToString(Session["HOSPID"]);
        
       
        string LedTxnID = string.Empty;
        
        DataTable dtVisit = new DataTable();
        string[] columns = visitDetail[0].Split(',');
        for (int i = 0; i < columns.Length; i++)
        {
            dtVisit.Columns.Add(new DataColumn(columns[i]));
        }
        dtVisit.Columns["Rate"].DataType = typeof(decimal);
        
        for (int i = 1; i < visitDetail.Length; i++)
        {
            string[] columndata = visitDetail[i].Split(',');
            DataRow row = dtVisit.NewRow();
            for (int j = 0; j < columndata.Length; j++)
            {
                
                row[j] = columndata[j];
                
            }
            dtVisit.Rows.Add(row);
        }
        foreach (DataRow iRate in dtVisit.Rows)
        {
            if (Util.GetDecimal(iRate["Rate"]) == 0)
            {
               // string VisitName = StockReports.ExecuteScalar("Select Name from f_subcategorymaster where subcategoryID='" + iRate["SubCategoryID"].ToString() + "'");

                return 2;
            }
        }
        decimal TotalRate = Util.GetDecimal(dtVisit.Compute("sum(Rate)", ""));
        MySqlConnection con = Util.GetMySqlCon();
        if (con.State == ConnectionState.Closed)
            con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        if (visitDetail.Length > 1)
        {
            try
            {
                Ledger_Transaction objLedTran = new Ledger_Transaction(tnx);
                objLedTran.LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientID,con);
                objLedTran.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(HospID,con);  
                objLedTran.Hospital_ID = HospID;
                objLedTran.TypeOfTnx = "IPD-Doc-Billing";
                objLedTran.Date = DateTime.Now;
                objLedTran.Time = DateTime.Now;
                objLedTran.DiscountOnTotal = 0;
                objLedTran.GrossAmount = TotalRate;
                objLedTran.NetAmount = TotalRate;
                objLedTran.IsCancel = 0;
                objLedTran.CancelReason = "";
                objLedTran.CancelAgainstLedgerNo = "";
                objLedTran.CancelDate = Util.GetDateTime(DateTime.Now.ToShortDateString());
                objLedTran.UserID = userID;
                objLedTran.PatientID = PatientID;
                objLedTran.TransactionID = TransactionID;
                objLedTran.PanelID = PanelID;
                objLedTran.UniqueHash = Util.getHash();
                objLedTran.IpAddress = All_LoadData.IpAddress();
                objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLedTran.PatientType = PatientType;
                LedTxnID = objLedTran.Insert().ToString();

                if (LedTxnID == string.Empty)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return 0;
                }
                
                //Checking if Patient is prescribed any IPD Packages
                DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(TransactionID,con);
              //  string PatientType = StockReports.GetPatient_Type_IPD(TransactionID);
                LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);

                foreach (DataRow row in dtVisit.Rows)
                {
                    objLTDetail.Hospital_Id = HospID;
                    objLTDetail.LedgerTransactionNo = LedTxnID;
                    objLTDetail.ItemID = Util.GetString(row["ItemID"]);
                    objLTDetail.Rate = Util.GetDecimal(row["Rate"]);
                    objLTDetail.scaleOfCost = 0;// Util.GetDecimal(row["scaleOfCost"]);
                    objLTDetail.Quantity = 1;
                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(row["SubCategoryID"]),con));
                    //objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, PanelID);


                    var dataTableCoPayDiscont = AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(objLedTran.PanelID),Util.GetString(objLTDetail.ItemID),Util.GetInt(patientTypeID));
                    
                    if (dtPkg != null && dtPkg.Rows.Count > 0)
                    {
                        int iCtr = 0;
                        foreach (DataRow drPkg in dtPkg.Rows)
                        {
                            if (iCtr == 0)
                            {
                                DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(TransactionID, drPkg["PackageID"].ToString(), row["ItemID"].ToString(), Util.GetDecimal(row["Rate"]), 1, Util.GetInt(IPDCaseType_ID), con);

                                if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                {
                                    if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                    {
                                        objLTDetail.Amount = 0;
                                        objLTDetail.DiscountPercentage = 0;
                                        objLTDetail.DiscAmt = 0;
                                        objLTDetail.IsPackage = 1;
                                        objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                        objLTDetail.NetItemAmt = Util.GetDecimal(0);
                                        objLTDetail.TotalDiscAmt = 0;
                                        iCtr = 1;
                                    }
                                    else
                                    {
                                      //  decimal DiscPerc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), Util.GetString(row["ItemID"]),"I",con));

                                        decimal DiscPerc = 0;
                                       if (Resources.Resource.IsmembershipInIPD == "1")
                                        {
                                            if (PanelID == 1)
                                            {
                                                if (MembershipNo != "")
                                                {
                                                    GetDiscount ds = new GetDiscount();
                                                    DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(row["ItemID"]), MembershipNo, "IPD").Split('#')[0].ToString());
                                                }
                                                else
                                                {
                                                    DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                                }
                                            }
                                            else
                                            {
                                                DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                            }
                                        }
                                        else
                                        {
                                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                        }
                                        if (DiscPerc > 0)
                                        {
                                            decimal GrossAmt = Util.GetDecimal(row["Rate"]);
                                            decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                            objLTDetail.Amount = NetAmount;
                                            objLTDetail.DiscountPercentage = DiscPerc;
                                            objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                            objLTDetail.NetItemAmt = Util.GetDecimal(NetAmount);
                                            objLTDetail.TotalDiscAmt = GrossAmt - NetAmount;
                                            objLTDetail.DiscountReason = "Panel Wise Discount";
                                            objLTDetail.DiscUserID = userID;
                                            if (PanelID != 1)
                                            objLTDetail.isPanelWiseDisc = 1;
                                        }
                                        else
                                        {
                                            objLTDetail.DiscountPercentage = 0;
                                            objLTDetail.DiscAmt = 0;
                                            objLTDetail.Amount = Util.GetDecimal(row["Rate"]);
                                            objLTDetail.NetItemAmt = Util.GetDecimal(row["Rate"]);
                                            objLTDetail.TotalDiscAmt = 0;
                                        }
                                    }
                                }
                                else
                                {
                                   // decimal DiscPerc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), Util.GetString(row["ItemID"]),"I",con));
                                    decimal DiscPerc = 0;
                                    if (Resources.Resource.IsmembershipInIPD == "1")
                                    {
                                        if (PanelID == 1)
                                        {
                                            if (MembershipNo != "")
                                            {
                                                GetDiscount ds = new GetDiscount();
                                                DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(row["ItemID"]), MembershipNo, "IPD").Split('#')[0].ToString());
                                            }
                                            else
                                            {
                                                DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                            }
                                        }
                                        else
                                        {
                                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                        }
                                    }
                                    else
                                    {
                                        DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                    }
                                    if (DiscPerc > 0)
                                    {
                                        decimal GrossAmt = Util.GetDecimal(row["Rate"]);
                                        decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                        objLTDetail.Amount = NetAmount;
                                        objLTDetail.DiscountPercentage = DiscPerc;
                                        objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                        objLTDetail.NetItemAmt = Util.GetDecimal(NetAmount);
                                        objLTDetail.TotalDiscAmt = GrossAmt - NetAmount;
                                        objLTDetail.DiscountReason = "Panel Wise Discount";
                                        objLTDetail.DiscUserID = userID;
                                        if(PanelID !=1)
                                        objLTDetail.isPanelWiseDisc = 1;
                                    }
                                    else
                                    {
                                        objLTDetail.DiscountPercentage = 0;
                                        objLTDetail.DiscAmt = 0;
                                        objLTDetail.Amount = Util.GetDecimal(row["Rate"]);
                                        objLTDetail.NetItemAmt = Util.GetDecimal(row["Rate"]);
                                        objLTDetail.TotalDiscAmt =0;
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                      //  decimal DiscPerc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), Util.GetString(row["ItemID"]),"I",con));
                        decimal DiscPerc = 0;
                        if (Resources.Resource.IsmembershipInIPD == "1")
                        {
                            if (PanelID == 1)
                            {
                                if (MembershipNo != "")
                                {
                                    GetDiscount ds = new GetDiscount();
                                    DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(row["ItemID"]), MembershipNo, "IPD").Split('#')[0].ToString());
                                }
                                else
                                {
                                    DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                }
                            }
                            else
                            {
                                DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                            }
                        }
                        else
                        {
                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                        }
                        if (DiscPerc > 0)
                        {
                            decimal GrossAmt = Util.GetDecimal(row["Rate"]);
                            decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                            objLTDetail.Amount = NetAmount;
                            objLTDetail.DiscountPercentage = DiscPerc;
                            objLTDetail.DiscAmt = GrossAmt - NetAmount;
                            objLTDetail.NetItemAmt = NetAmount;
                            objLTDetail.TotalDiscAmt = GrossAmt - NetAmount;
                            objLTDetail.DiscountReason = "Panel Wise Discount";
                            objLTDetail.DiscUserID = userID;
                            if(PanelID != 1)
                            objLTDetail.isPanelWiseDisc = 1;
                        }
                        else
                        {
                            objLTDetail.DiscountPercentage = 0;
                            objLTDetail.DiscAmt = 0;
                            objLTDetail.Amount = Util.GetDecimal(row["Rate"]);

                            objLTDetail.NetItemAmt = Util.GetDecimal(row["Rate"]);
                            objLTDetail.TotalDiscAmt = 0;
                        }
                    }
                  //  objLTDetail.DiscountPercentage = 0;
                    objLTDetail.EntryDate = Util.GetDateTime(row["VisitDate"]);
                    objLTDetail.TransactionID = TransactionID;
                    objLTDetail.UserID = userID;
                    objLTDetail.IsVerified = 1;
                    objLTDetail.ItemName = Util.GetString(ItemName);// Util.GetString(row["itemName"]);
                    objLTDetail.SubCategoryID = Util.GetString(row["SubCategoryID"]);
                    objLTDetail.TnxTypeID = 17;
                    objLTDetail.DoctorID = DoctorID;//Util.GetString(row["doctorID"]);
                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetail.RateListID = Util.GetInt(row["rateListID"]);
                    objLTDetail.rateItemCode = Util.GetString(row["itemcode"]);
                    objLTDetail.IPDCaseTypeID = IPDCaseType_ID;
                    objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objLTDetail.Type = "I";
                    objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    objLTDetail.IpAddress = All_LoadData.IpAddress();
                    objLTDetail.VerifiedDate = Util.GetDateTime(row["VisitDate"]);
                    objLTDetail.VarifiedUserID = userID;
                    objLTDetail.RoomID = Room_ID;
                    objLTDetail.typeOfTnx = "IPD-Doc-Billing";
                    objLTDetail.IsPayable = Util.GetInt(dataTableCoPayDiscont.Rows[0]["IsPayble"]);
                    objLTDetail.CoPayPercent = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDCoPayPercent"]);
                    objLTDetail.Remark = "";//Util.GetString(row["remarks"]);
                    objLTDetail.Insert();
                }

                //Devendra Singh 2018-11-12 Insert Finance Integarion 
                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    string IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(Util.GetInt(LedTxnID), "", "R", tnx));
                    if (IsIntegrated == "0")
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return 0;
                    }
                }
                
                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return 1;
            }
            catch(Exception ex)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return 0;
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
            return 0;
        }
    }
    
    [WebMethod(EnableSession = true)]
    public string SendSMSforCrossConsultation(string doctorID, string doctorName, string patientID, string transactionID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string CentreID = HttpContext.Current.Session["CentreID"].ToString();
            string UserID = HttpContext.Current.Session["ID"].ToString();
    
            //**************** SMS************************//
            if (Resources.Resource.SMSApplicable == "1")
            {
                var columninfo = smstemplate.getColumnInfo(8, con);
                if (columninfo.Count > 0)
                {
                    string DocMobile = StockReports.ExecuteScalar("SELECT dm.Mobile AS MobileNo FROM  doctor_master dm  WHERE DoctorID='" + doctorID + "'");
                    DataTable pDetails = StockReports.GetDataTable("SELECT Get_Current_Room('" + transactionID + "')Ward,Title,CONCAT(Pname,' / ',Age,' / ',Gender)PName FROM patient_master WHERE patientID='" + patientID + "'"); ;
                    string [] mobileArray;
                    if (DocMobile != "")
                    {
                        mobileArray = DocMobile.Split('/');
                        foreach (var mobile in mobileArray)
                        {
                            columninfo[0].PName = pDetails.Rows[0]["PName"].ToString();
                            columninfo[0].Title = pDetails.Rows[0]["Title"].ToString();
                            columninfo[0].ContactNo = mobile;
                            columninfo[0].TemplateID = 8;
                            columninfo[0].PatientID = patientID;
                            columninfo[0].TransactionID = StockReports.getTransNobyTransactionID(transactionID);
                            columninfo[0].Ward = pDetails.Rows[0]["Ward"].ToString();
                            columninfo[0].DoctorID = doctorID;
                            string sms = smstemplate.getSMSTemplate(8, columninfo, 2, con, HttpContext.Current.Session["ID"].ToString());
                        }
                    }
                }
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "SMS Sent Successfully" });
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
    [WebMethod]
    public string getSMSDetailforCrossConsultation(string patientID, string transactionID)
    {
        string AdmitDate = StockReports.ExecuteScalar("SELECT DateOfVisit FROM patient_medical_history WHERE transactionID= " + transactionID);
        DataTable dtSMS = StockReports.GetDataTable(@"SELECT CONCAT(dm.Title,dm.NAME)Doctor,sl.Mobile_No,IF(sl.IsSend=0,'Pending',IF(sl.IsDelivered=1,'Delivered.',IF(sl.IsSend=1,'Sent','Not Delivered')))smsStatus ,
                                                        DATE_FORMAT(sl.EntryDate,'%d-%b-%Y %I:%i %p')SMSRequestAt,CONCAT(emp.Title,emp.NAME)SMSRequestBy
                                                        FROM sms_log sl 
                                                        INNER JOIN doctor_master dm ON dm.DoctorID= sl.DoctorID
                                                        INNER JOIN employee_master emp ON emp.EmployeeID= sl.UserID
                                                        WHERE sl.PatientID='" + patientID + "' and Date(sl.EntryDate)>='" + AdmitDate + "' order by sl.SMS_ID");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtSMS);
    }
}

