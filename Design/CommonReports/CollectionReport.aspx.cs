using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

[System.Runtime.InteropServices.GuidAttribute("01FDD488-3DEB-42D1-92D5-C9340E37FDE5")]
public partial class Design_OPD_CollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            FillDateTime();
            BindUser();
            BindTypeOfTnx();
            BindDoctor();
            BindSpeciality();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPreview);
        }
        
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
        if (Session["RoleID"].ToString() == "161" || Session["RoleID"].ToString() == "54")
        {
            for (int i = 0; i <= rbtReportType.Items.Count; i++)
            {
                rbtReportType.Items[2].Attributes.Add("style", "display:none");
                rbtReportType.Items[3].Attributes.Add("style", "display:none");
                rbtReportType.Items[4].Attributes.Add("style", "display:none");
                rbtReportType.Items[6].Attributes.Add("style", "display:none");
                //rbtReportType.Items[7].Attributes.Add("style", "display:none");
              //  rbtReportType.Items[8].Attributes.Add("style", "display:none");
            }
        }
    }
    private void BindDoctor()
    {
        DataTable dt = All_LoadData.bindDoctor();
        if (dt.Rows.Count > 0 && dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                chkDoctor.Items.Add(new ListItem(dt.Rows[i]["Name"].ToString(), dt.Rows[i]["DoctorID"].ToString()));
                chkDoctor.Items[i].Selected = true;
            }
        }
    }
    private void BindSpeciality()
    {
        DataTable dt = All_LoadData.getDocTypeList(3);
        if (dt.Rows.Count > 0 && dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                chkSpeciality.Items.Add(new ListItem(dt.Rows[i]["Name"].ToString(), dt.Rows[i]["Name"].ToString()));
                chkSpeciality.Items[i].Selected = true;
            }
        }
    }

    private void BindTypeOfTnx()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT TypeOfTnx,DisplayName FROM master_typeoftnx WHERE  ");
        if (Session["DeptLedgerNo"].ToString() == "LSHHI57" || Session["DeptLedgerNo"].ToString() == "LSHHI3889") 
            sb.Append("  TypeofTnx IN ('PHARMACY-ISSUE','PHARMACY-RETURN','OPD Advance/Settlements','Sales','Patient-Return','Out Supplier Sale','Out Supplier Return') ");
        else if (Session["DeptLedgerNo"].ToString() == "LSHHI5309")
            sb.Append("  TypeofTnx IN ('PHARMACY-ISSUE','PHARMACY-RETURN','OPD Advance/Settlements','Sales','Patient-Return','Out Supplier Sale','Out Supplier Return') ");
        else
            sb.Append(" Type IN ('OPD','Pharmacy','Other','EXPENSE') ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());

        if (oDT.Rows.Count > 0)
        {
            for (int i = 0; i < oDT.Rows.Count; i++)
            {
                cblColType.Items.Add(new ListItem(oDT.Rows[i]["DisplayName"].ToString(), oDT.Rows[i]["TypeOfTnx"].ToString()));
                cblColType.Items[i].Selected = true;
            }
        }
    }
    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }

        return str;
    }
    private void BindUser()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(em.Title,' ',Name)As Name,em.EmployeeID from employee_master em ");
        //  sb.Append(" INNER JOIN f_login flg on flg.EmployeeID = em.Employee_ID where em.IsActive=1 and flg.Active=1  ");
        sb.Append(" INNER JOIN f_login flg on flg.EmployeeID = em.EmployeeID where em.EmployeeID<>''  ");
        if (Session["DeptLedgerNo"].ToString() == "LSHHI57" || Session["DeptLedgerNo"].ToString() == "LSHHI3889")
              sb.Append(" AND flg.RoleID in (161)  ");
        //  else if (Session["DeptLedgerNo"].ToString() == "LSHHI5309")
         //     sb.Append(" AND flg.RoleID in (281)  ");
        //  else
        //      sb.Append(" AND flg.RoleID in (9,3,211,220,248,1,228,295,11)   ");
        sb.Append(" group by em.EmployeeID order by em.name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            cblUser.DataSource = dt;
            cblUser.DataTextField = "Name";
            cblUser.DataValueField = "EmployeeID";
            cblUser.DataBind();
        }

        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
        if (dtAuthority.Rows.Count > 0)
        {
            if (dtAuthority.Rows[0]["CanViewAllUserCollection"].ToString() == "1")
            {
                for (int i = 0; i < cblUser.Items.Count; i++)
                {
                    cblUser.Items[i].Selected = true;
                }
            }
            else
            {
                for (int i = 0; i < cblUser.Items.Count; i++)
                {
                    if (Session["ID"].ToString() != cblUser.Items[i].Value)
                    {
                        cblUser.Items[i].Selected = false;
                        chkuser.Enabled = false;
                        cblUser.Items[i].Enabled = false;
                    }
                    else
                    {
                        cblUser.Items[i].Selected = true;
                        cblUser.Items[i].Enabled = true;
                    }
                }
            }
        }
    }
    private void FillDateTime()
    {
        ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtFromTime.Text = "00:00 AM";
        txtToTime.Text = "11:59 PM";

    }
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        if (Session["LoginType"] == null)
        {
            return;
        }
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string startDate = string.Empty, toDate = string.Empty, user, colType;
        if (Util.GetDateTime(ucFromDate.Text).ToString() != "")
            if (txtFromTime.Text.Trim() != string.Empty)
                startDate = Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss");
            else
                startDate = Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd");
        if (Util.GetDateTime(ucToDate.Text).ToString() != string.Empty)
            if (txtToTime.Text.Trim() != string.Empty)
                toDate = Util.GetDateTime(Util.GetDateTime(ucToDate.Text)).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtToTime.Text.Trim()).ToString("HH:mm") + ":59";
            else
                toDate = Util.GetDateTime(Util.GetDateTime(ucToDate.Text)).ToString("yyyy-MM-dd") + " 23:59:59";
        user = GetSelection(cblUser);
        colType = GetSelection(cblColType);
        if (colType == string.Empty)
        {
            lblMsg.Text = "Select Type";
            return;
        }
        if (user == string.Empty)
        {
            lblMsg.Text = "Select Employee";
            return;
        }
        if (rbtReportType.SelectedValue == "0")
        {
            var sb = new StringBuilder();
            sb.Append(" SELECT DATE,SUM(PaidAmount),PaymentMode,UserName,UserID,CentreName,CentreID,BatchNumber  FROM (");
            //Cash
            sb.Append("SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(LTD.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4))PaidAmount,CONCAT(rec_pay.PaymentMode,' ',Rec_pay.S_Notation)PaymentMode,em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID,Rec.BatchNumber FROM f_reciept Rec ");
            sb.Append(" INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo   ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
            sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  ");
            sb.Append(" WHERE lt.PaymentModeID<>4 AND rec.LedgerNoDr NOT IN  ('HOSP0006','HOSP0005') and  LT.TypeOfTnx<>'OPD Advance/Settlements' and LT.TypeOfTnx IN (" + colType + ") AND rec.Iscancel=0 AND lt.IsCancel=0  and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") ");
            if (txtBatchnum.Text != null && txtBatchnum.Text != "")
            {
                sb.Append(" and Rec.BatchNumber='" + txtBatchnum.Text.Trim().ToString() + "' ");
            }
            sb.Append(" GROUP BY rec.Date,rec.CentreID,rec.Reciever,Rec.BatchNumber,rec_pay.PaymentMode,rec_pay.S_Notation");
           
            //for adjustment
            if (colType.Contains("OPD Advance/Settlements"))
            {
                sb.Append("  UNION ALL");
                sb.Append("  SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(rec_pay.S_Amount)PaidAmount,CONCAT(rec_pay.PaymentMode,' ',rec_pay.S_Notation)PaymentMode,em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID,rec.BatchNumber   ");
             
                sb.Append("  FROM f_reciept rec ");
                sb.Append("  inner join patient_master pm on pm.PatientID=rec.Depositor ");
                sb.Append("  inner join f_receipt_paymentdetail rec_pay on rec_pay.ReceiptNo=rec.ReceiptNo ");
                sb.Append("  inner join employee_master em on em.EmployeeID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                sb.Append("  where rec.LedgerNoDr IN  ('HOSP0006','HOSP0005') AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' and rec.Reciever in (" + user + ")  AND rec.CentreID IN (" + Centre + ") ");
                if (txtBatchnum.Text != null && txtBatchnum.Text != "")
                {
                    sb.Append(" and rec.BatchNumber='" + txtBatchnum.Text.Trim().ToString() + "'  ");
                }
                sb.Append("  GROUP BY rec.Date,rec.CentreID,rec.Reciever,rec.BatchNumber,rec_pay.PaymentMode,S_Notation ");
            }
            //IPD advance
            if (colType.Contains("IPD"))
            {
                sb.Append(" UNION ALL");
                sb.Append(" SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(rec_pay.S_Amount)PaidAmount,CONCAT(rec_pay.PaymentMode,' ',Rec_pay.S_Notation)PaymentMode,em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID,Rec.BatchNumber  FROM f_reciept Rec");
                sb.Append(" INNER JOIN patient_medical_history adj ON adj.TransactionID=rec.TransactionID ");//
                sb.Append(" INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
                sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID");
                sb.Append(" WHERE rec.Iscancel=0 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") AND adj.Type='IPD' ");//
                if (txtBatchnum.Text != null && txtBatchnum.Text != "")
                {
                    sb.Append(" and Rec.BatchNumber='" + txtBatchnum.Text.Trim().ToString() + "' ");
                }
                sb.Append("GROUP BY rec.Date,rec.CentreID,rec.Reciever,Rec.BatchNumber,rec_pay.PaymentMode,rec_pay.S_Notation");
            }
            //Mortuary Advance
            if (colType.Contains("Mortuary-Advance"))
            {
                sb.Append(" UNION ALL");
                sb.Append(" SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(rec_pay.S_Amount)PaidAmount,CONCAT(rec_pay.PaymentMode,' ',Rec_pay.S_Notation)PaymentMode,");
                sb.Append(" em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID FROM mortuary_receipt Rec");
                sb.Append(" INNER JOIN mortuary_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
                sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID");
                sb.Append(" WHERE rec.Iscancel=0 AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' ");
                sb.Append(" AND rec.Reciever IN (" + user + ") AND rec.CentreID IN (" + Centre + ")");
                sb.Append(" GROUP BY rec.Date,rec.CentreID,rec.Reciever,rec_pay.PaymentMode,rec_pay.S_Notation");
            }
            sb.Append(" )a GROUP BY Date,CentreID,UserID,BatchNumber,PaymentMode ");
            var dt1 = new DataTable();
            dt1 = StockReports.GetDataTable(sb.ToString());
	    //System.IO.File.WriteAllText (@"F:\aa.txt", sb.ToString());
            if (dt1.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
                dt1.Columns.Add(dc);
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                DataSet ds = new DataSet();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables.Add(dt1.Copy());
                //ds.Tables.Add(dtSum.Copy());
                // ds.WriteXmlSchema(@"E:\\CollectionReportSummary.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "CollectionReportSummary";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

            }
            txtBatchnum.Text = "";
        }
        else if (rbtReportType.SelectedValue == "1")
        {
            StringBuilder sb1 = new StringBuilder();
            // for cash only
            sb1.Append("  SELECT  IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,rec.`AsainstLedgerTnxNo`,0),pm.`PatientID`) MRNo, IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,rec.`AsainstLedgerTnxNo`,1),pm.PName) as PName,lt.TransactionID,lt.BillNo,rec.ReceiptNo,pm.Age,IF(ltd.TypeOfTnx='OPD-LAB','DIAGNOSIS',IF(ltd.TypeOfTnx='DR','Debit Note',IF(ltd.TypeOfTnx='CR','Credit Note',ltd.TypeOfTnx)))TypeOfTnx, ");
            sb1.Append("  CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,SUM(LTD.NetItemAmt)NetAmount,SUM(ROUND((rec_pay.S_Amount*IF(LTD.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4))PaidAmount,lt.RoundOff, ");
            sb1.Append("  CONVERT(GROUP_CONCAT(ROUND((rec_pay.S_Amount*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),' ',rec_pay.S_Notation,' ',rec_pay.PaymentMode,' ',rec_pay.BankName,' ',rec_pay.refNo),CHAR)Payment,IFNULL(rec_pay.PaymentRemarks,'')PhoneNo,rec_pay.RefNo,em.Name UserName,cm.CentreName,cm.CentreID FROM f_reciept Rec ");
            sb1.Append("   ");
            sb1.Append("  INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
            sb1.Append("  INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo   ");
            sb1.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
            sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID");
            sb1.Append("  INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
            sb1.Append("  WHERE lt.PaymentModeID<>4 AND rec.LedgerNoDr NOT IN ('HOSP0006','HOSP0005')  AND rec_pay.isopdadvance=0  AND  ltd.TypeOfTnx IN (" + colType + ")  AND  rec.Iscancel=0 AND lt.IsCancel=0  and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") ");
            sb1.Append("  GROUP BY rec.Reciever,rec_pay.ReceiptNo,ltd.TypeOfTnx");
            if (colType.Contains("EXPENSE"))
            {
                //for Expense only
                sb1.Append("  UNION ALL");
                sb1.Append("  SELECT fre.ExpenceToId AS MRNo, fre.ExpenceTo PName,'' TransactionID,'' BillNo,fre.ReceiptNo,'' Age,'Payment' AS  TypeOfTnx,DATE_FORMAT(fre.Date,'%d %b %Y') DATE, ");
                sb1.Append("  fre.AmountPaid*-1 NetAmount,fre.AmountPaid*-1 PaidAmount,'' RoundOff,CONCAT(fre.AmountPaid*-1,' " + Resources.Resource.BaseCurrencyNotation + "',' Cash')Payment ,'' PhoneNo,''RefNo,Em.Name UserName,cm.CentreName,cm.CentreID ");
                sb1.Append("  FROM f_reciept_expence fre INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0 INNER JOIN Center_master cm ON cm.CentreID = fre.CentreID  ");
                sb1.Append("  AND (CONCAT(fre.Date,' ',fre.Time) >= '" + startDate + "' ) ");
                sb1.Append("  AND (CONCAT(fre.Date,' ',fre.Time) <= '" + toDate + "' )   And fre.Depositor in (" + user + ") AND fre.CentreID IN (" + Centre + ") ");
            }
            //for OPD-Advance
            if (colType.Contains("OPD-Advance"))
            {
                sb1.Append("  UNION ALL");
                sb1.Append(" SELECT pm.PatientID MRNo,pm.PName, rec.TransactionID,'' BillNo,rec.ReceiptNo,pm.Age,'OPD-Advance' TypeOfTnx, ");
                sb1.Append(" CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,NetAmount,SUM(rec_pay.Amount)PaidAmount,lt.RoundOff,");
                sb1.Append(" CONVERT(GROUP_CONCAT(rec_pay.S_Amount,' ',rec_pay.S_Notation,' ',rec_pay.PaymentMode,' ',rec_pay.BankName,' ',rec_pay.refNo),CHAR)Payment ,IFNULL(rec_pay.PaymentRemarks,'')PhoneNo,rec_pay.RefNo, ");
                sb1.Append(" em.Name UserName,cm.CentreName,cm.CentreID FROM f_reciept Rec ");
                sb1.Append(" INNER JOIN f_receipt_paymentdetail rec_pay  ON rec_pay.ReceiptNo=rec.ReceiptNo ");
                sb1.Append(" INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo   ");
                sb1.Append(" INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID");
                sb1.Append(" INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  WHERE rec_pay.isopdadvance=1 AND TypeOfTnx='OPD-Advance' AND  rec.Iscancel=0 AND lt.IsCancel=0 ");
                sb1.Append(" AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' ");
                sb1.Append(" AND rec.Reciever IN (" + user + ") AND rec.CentreID IN (" + Centre + ")  GROUP BY rec.Reciever,rec_pay.ReceiptNo ");
            }
            //for Credit only
            //sb1.Append("  UNION ALL");
            //sb1.Append("  SELECT lt.TransactionID,lt.BillNo,'' ReceiptNo,IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,lt.LedgerTransactionNo,0),pm.PatientID) as   MRNo, IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,lt.LedgerTransactionNo,1),pm.PName) as PName,pm.Age,IF(ltd.TypeOfTnx='OPD-LAB','DIAGNOSIS',IF(ltd.TypeOfTnx='DR','Debit Note',IF(ltd.TypeOfTnx='CR','Credit Note',ltd.TypeOfTnx)))TypeOfTnx,CONCAT(DATE_FORMAT(lt.date,'%d %b %Y'),' ',DATE_FORMAT(lt.time,'%H:%i'))DATE,SUM(LTD.NetItemAmt)NetAmount,0 PaidAmount,lt.RoundOff,CONVERT(GROUP_CONCAT(lt_pay.S_Amount,' ',' " + Resources.Resource.BaseCurrencyNotation + "' ,lt_pay.PaymentMode,' ',lt_pay.BankName,' ',lt_pay.refNo),CHAR)Payment ,em.Name UserName,cm.CentreName,cm.CentreID FROM f_ledgertransaction lt ");
            //sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID");
            //sb1.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
            //sb1.Append("  INNER JOIN employee_master em ON lt.UserID=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = lt.CentreID");
            //sb1.Append("  INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo");
            //sb1.Append("  WHERE lt_pay.PaymentModeID=4 and ltd.TypeOfTnx IN (" + colType + ") AND lt.IsCancel=0 and CONCAT(lt.Date,' ',lt.Time)>='" + startDate + "' AND CONCAT(lt.Date,' ',lt.Time)<='" + toDate + "' and lt.userID in (" + user + ") AND lt.CentreID IN (" + Centre + ")  ");
            //sb1.Append("  GROUP BY lt_pay.LedgerTransactionNo,ltd.TypeOfTnx");

            //for adjustment
            if (colType.Contains("OPD Advance/Settlements"))
            {
                sb1.Append("  UNION ALL");
                sb1.Append("  SELECT  IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,rec.`AsainstLedgerTnxNo`,0),pm.PatientID) as MRNo,IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,rec.`AsainstLedgerTnxNo`,1),pm.PName) as PName,rec.TransactionID,''BillNo,rec.ReceiptNo,pm.Age,'OPD Settlement' TypeOfTnx,CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,0 NetAmount,SUM(IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount))PaidAmount,rec.RoundOff,CONVERT(GROUP_CONCAT(rec_pay.S_Amount,' ',rec_pay.S_Notation,' ',rec_pay.PaymentMode,' ',rec_pay.BankName,' ',rec_pay.refNo),CHAR)Payment ,IFNULL(rec_pay.PaymentRemarks,'')PhoneNo,rec_pay.RefNo,em.Name UserName,cm.CentreName,cm.CentreID ");
             
                sb1.Append("  FROM f_reciept rec ");
                sb1.Append("  inner join patient_master pm on pm.PatientID=rec.Depositor ");
                sb1.Append("  inner join f_receipt_paymentdetail rec_pay on rec_pay.ReceiptNo=rec.ReceiptNo ");
                sb1.Append("  inner join employee_master em on em.EmployeeID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                // sb1.Append("  where  IsAdvanceAmt=1 AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  GROUP BY rec.ReceiptNo ");
                sb1.Append("  where  rec.LedgerNoDr IN('HOSP0006','HOSP0005') AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  GROUP BY rec.ReceiptNo ");
            }
            //for IPD advance
            if (colType.Contains("IPD"))
            {
                sb1.Append("  UNION ALL");
                sb1.Append("  SELECT  rec.Depositor MRNo,pm.PName,rec.TransactionID,''BillNo,rec.ReceiptNo,pm.Age,'IPD-Advance' TypeOfTnx,CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,AmountPaid NetAmount,SUM(rec_pay.Amount)PaidAmount,rec.RoundOff,CONVERT(GROUP_CONCAT(rec_pay.S_Amount,' ',rec_pay.S_Notation,' ',rec_pay.PaymentMode,' ',rec_pay.BankName,' ',rec_pay.refNo),CHAR)Payment,IFNULL(rec_pay.PaymentRemarks,'')PhoneNo ,rec_pay.RefNo,em.Name UserName,cm.CentreName,cm.CentreID FROM f_reciept rec");
                sb1.Append("  INNER JOIN patient_medical_history adj ON adj.TransactionID=rec.TransactionID ");//
                sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=rec.Depositor ");
                sb1.Append("  INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                sb1.Append("  INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo");
                sb1.Append("  WHERE rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "'  and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") AND adj.Type='IPD'  ");//
                sb1.Append("  GROUP BY rec.ReceiptNo");
            }
            DataTable dt = StockReports.GetDataTable(sb1.ToString());
            if (dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtFromTime.Text).ToString("hh:mm tt") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtToTime.Text).ToString("hh:mm tt");
                dt.Columns.Add(dc); 
                if (rdbDetailReportType.SelectedValue == "PDF")
                {
                    DataTable dtImg = All_LoadData.CrystalReportLogo();
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    ds.Tables.Add(dtImg.Copy());
                    // ds.WriteXmlSchema("E:\\dailycollectionDetail.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "CollectionReportDetail";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
                
                }
                else if (rdbDetailReportType.SelectedValue == "EXCEL")
                {
                    dt.Columns.Remove("TypeOfTnx");
                    dt.Columns.Remove("CentreID");
                    dt.Columns.Remove("RoundOff");
                    dt.Columns.Remove("TransactionID");
                    dt.Columns.Remove("Age");
                    dt.Columns.Remove("ReceiptNo");
                    dt.Columns.Remove("CentreName");
                    dt.Columns.Remove("Period");
                    Session["ReportName"] = "Collection Report";
                    Session["dtExport2Excel"] = dt;
                    Session["Period"] = "Period From : " + ucFromDate.Text.Trim() + " To : " + ucToDate.Text.Trim();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                }
           
            
            
            
            
            
            
            
            
            
            
            
            
            
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
        else if (rbtReportType.SelectedValue == "2")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,rec.Date dt,em.Name,CASE WHEN ltd.typeoftnx='OPD-Appointment' THEN 'APPOINTMENT' WHEN ltd.typeoftnx='OPD-LAB' THEN 'DIAGNOSIS' WHEN ltd.typeoftnx='DR' THEN 'Debit Note' WHEN ltd.typeoftnx='CR' THEN 'Credit Note' ELSE ltd.typeoftnx  END  TypeOFTnx,SUM(ROUND((rec_pay.S_Amount*IF(LTD.TypeOfTnx IN('DR','CR'),0,IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt)))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4))Amount,cm.CentreName,cm.CentreID FROM f_reciept Rec  ");
            sb.Append("     ");
            sb.Append(" INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo ");
            sb.Append(" INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
            sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
            sb.Append(" WHERE rec.isOPDAdvance=0 AND rec.LedgerNoDr NOT IN  ('HOSP0006','HOSP0005') AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' AND ltd.TypeOfTnx IN (" + colType + ")  AND  rec_pay.PaymentModeID<>4 and Rec.IsCancel=0 and lt.IsCancel=0 AND IFNULL(lt.LedgerTransactionNo,'')<>''  AND  rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
            sb.Append(" GROUP BY rec.Date,ltd.TypeOfTnx,rec.Reciever ");
            if (colType.Contains("OPD Advance/Settlements"))
            {
                sb.Append("  UNION ALL");
                sb.Append("  SELECT CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,rec.Date dt,em.Name,'OPD Adv./Settlement' TypeOfTnx,SUM(IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount))PaidAmount,cm.CentreName,cm.CentreID  ");
              
                sb.Append("  FROM f_reciept rec ");
                sb.Append("  INNER JOIN patient_master pm on pm.PatientID=rec.Depositor ");
                sb.Append("  INNER JOIN f_receipt_paymentdetail rec_pay on rec_pay.ReceiptNo=rec.ReceiptNo ");
                sb.Append("  INNER JOIN employee_master em on em.EmployeeID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                sb.Append("  WHERE  rec.LedgerNoDr IN('HOSP0006','HOSP0005') AND rec.IsCancel=0 AND CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' AND rec.Reciever in (" + user + ")  ");
                sb.Append(" GROUP BY rec.Date,rec.Reciever ");
            }
            if (colType.Contains("OPD-Advance"))
            {
                sb.Append("  UNION ALL");
                sb.Append("  SELECT CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,rec.Date dt,em.Name,'OPD Advance' TypeOfTnx,SUM(rec_pay.Amount)PaidAmount,cm.CentreName,cm.CentreID  ");
                sb.Append("  FROM  f_reciept rec  ");
                sb.Append("  INNER JOIN patient_master pm on pm.PatientID=rec.Depositor ");
                sb.Append("  INNER JOIN f_receipt_paymentdetail rec_pay on rec_pay.ReceiptNo=rec.ReceiptNo ");
                sb.Append("  INNER JOIN employee_master em on em.EmployeeID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                sb.Append("  WHERE  rec.isOPDAdvance=1  AND rec.IsCancel=0 AND CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' AND rec.Reciever in (" + user + ")  ");
                sb.Append(" GROUP BY rec.Date,rec.Reciever ");
            }
            if (colType.Contains("EXPENSE"))
            {
                sb.Append("  UNION ALL");
                sb.Append("  SELECT DATE_FORMAT(fre.Date,'%d %b %Y') DATE,fre.Date dt,Em.NAME,'Payment' AS  TypeOfTnx,SUM(fre.AmountPaid)*-1 PaidAmount,cm.CentreName,cm.CentreID ");
                sb.Append("  FROM f_reciept_expence fre INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0   INNER JOIN Center_master cm ON cm.CentreID = fre.CentreID ");
                sb.Append("  AND (CONCAT(fre.Date,' ',fre.Time) >= '" + startDate + "') ");
                sb.Append("  AND (CONCAT(fre.Date,' ',fre.Time) <= '" + toDate + "')   And fre.Depositor in (" + user + ")");
                sb.Append(" GROUP BY fre.Date,fre.Depositor ");
            }
            if (colType.Contains("IPD"))
            {
                sb.Append(" UNION ALL ");
                sb.Append(" SELECT CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,rec.date dt,em.Name,'IPD-Advance' TypeOfTnx,SUM(recp.Amount)Amount,cm.CentreName,cm.CentreID FROM f_reciept rec ");
                sb.Append(" INNER JOIN patient_medical_history adj ON adj.TransactionID=rec.TransactionID ");//
                sb.Append(" INNER JOIN f_receipt_paymentdetail recp ON rec.ReceiptNo=recp.ReceiptNo ");
                sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                sb.Append(" WHERE CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "'  and rec.IsCancel=0 and rec.Reciever in (" + user + ") AND adj.Type='IPD'  ");//
                sb.Append(" GROUP BY rec.Date,rec.Reciever ");
            }
            sb.Append(" ORDER BY dt ");
            DataTable dt1 = StockReports.GetDataTable(sb.ToString());
            if (dt1.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                DataColumn dc1 = new DataColumn();
                DataTable dtImg = All_LoadData.CrystalReportLogo();

                dc.ColumnName = "Period";
                dc1.ColumnName = "UserName";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtFromTime.Text).ToString("hh:mm tt") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtToTime.Text).ToString("hh:mm tt");
                dc1.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt1.Columns.Add(dc);
                dt1.Columns.Add(dc1);


                DataSet ds = new DataSet();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables.Add(dt1.Copy());
                // ds.WriteXmlSchema(@"E:\\CollectionReportSummaryDateWise.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "CollectionReportSummaryDateWise";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

        }
        else if (rbtReportType.SelectedValue == "3")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT DATE,Dt,NAME,SUM(Amount)Amount,Category FROM ( ");
            sb.Append("  SELECT CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,rec.Date dt,em.Name,ROUND(((if(rec_pay.PaymentmodeID=5,0,rec_pay.S_Amount))*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(lt.NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),3) Amount,cm.Description Category,rec.Reciever UserID,cm1.CentreName,cm1.CentreID FROM f_ledgertransaction lt   ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo   AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
            sb.Append("  INNER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
            sb.Append("  INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubCategoryID  ");
            sb.Append("  INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.CategoryID  ");
            sb.Append("  INNER JOIN employee_master em ON rec.reciever=em.EmployeeID   INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
            sb.Append("  WHERE rec.isOPDAdvance=0 AND rec.LedgerNoDr NOT IN  ('HOSP0006','HOSP0005')  AND rec.IsCancel=0 AND lt.PaymentModeID<>4 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' AND lt.IsCancel=0 and ltd.TypeOfTnx IN (" + colType + ")  AND IFNULL(lt.LedgerTransactionNo,'')<>'' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
            sb.Append("   )t ");
            sb.Append("  GROUP BY t.Date,t.UserID,t.Category ");

            if (colType.Contains("OPD-Advance"))
            {
                sb.Append("  UNION ALL");
                sb.Append("  SELECT DATE,Dt,NAME,SUM(Amount)Amount,Category FROM ( ");
                sb.Append("  SELECT CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,rec.Date dt,em.Name,ROUND(((rec.AmountPaid)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),3) Amount,cm.Description Category,rec.Reciever UserID,cm1.CentreName,cm1.CentreID FROM f_ledgertransaction lt   ");
                sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0  ");
                sb.Append("  INNER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo  ");
                sb.Append("  INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubCategoryID  ");
                sb.Append("  INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.CategoryID  ");
                sb.Append("  INNER JOIN employee_master em ON rec.reciever=em.EmployeeID   INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
                sb.Append("  WHERE rec.isOPDAdvance=1 AND rec.IsCancel=0 AND lt.PaymentModeID<>4 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' AND lt.IsCancel=0 and lt.TypeOfTnx='OPD-Advance'  AND IFNULL(lt.LedgerTransactionNo,'')<>'' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
                sb.Append("   )t ");
                sb.Append("  GROUP BY t.Date,t.UserID,t.Category ");

            }
            if (colType.Contains("OPD Advance/Settlements"))
            {
                //only cash Settlements
                sb.Append("  UNION ALL");
                sb.Append(" SELECT DATE,Dt,Name,SUM(Amount)Amount,Category FROM ( ");
                sb.Append("  SELECT CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,rec.Date dt,em.Name,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4) Amount,cm.Description Category ,rec.Reciever userID,cm1.CentreName,cm1.CentreID  ");
              
                sb.Append("  FROM f_reciept rec ");
                sb.Append("   INNER JOIN patient_master pm on pm.PatientID=rec.Depositor  ");
                sb.Append("   INNER JOIN employee_master em on em.EmployeeID=rec.Reciever  ");
                sb.Append("   INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
                sb.Append("   INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionNo` = rec.`AsainstLedgerTnxNo`  ");
                sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
                sb.Append("   INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubCategoryID  ");
                sb.Append("   INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.CategoryID  INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
                sb.Append("   WHERE  rec.LedgerNoDr IN ('HOSP0006','HOSP0005') AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
                sb.Append("   )t   GROUP BY DATE,UserID,Category ");



            }
            if (colType.Contains("EXPENSE"))
            {
                //only Expense
                sb.Append("  UNION ALL");
                sb.Append(" SELECT DATE,Dt,Name,SUM(Amount)Amount,Category FROM ( ");
                sb.Append("  SELECT DATE_FORMAT(fre.Date,'%d %b %Y') DATE,fre.Date dt,Em.Name, fre.AmountPaid*-1 Amount, 'Payment' Category, Em.EmployeeID  UserID,cm1.CentreName,cm1.CentreID ");
                sb.Append("  FROM f_reciept_expence fre INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0   INNER JOIN Center_master cm1 ON cm1.CentreID = fre.CentreID ");
                sb.Append("  AND (CONCAT(fre.Date,' ',fre.Time) >= '" + startDate + "') ");
                sb.Append("  AND (CONCAT(fre.Date,' ',fre.Time) <= '" + toDate + "')  And fre.Depositor in (" + user + ") AND fre.CentreID IN (" + Centre + ") ");
                sb.Append("   )t   GROUP BY DATE,UserID,Category ");
            }
            if (colType.Contains("IPD"))
            {
                sb.Append(" UNION ALL  ");
                sb.Append(" SELECT CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,rec.date dt,em.Name,SUM(recp.Amount)Amount,'IPD-Advance'Category FROM f_reciept rec  ");
                sb.Append(" INNER JOIN patient_medical_history adj ON adj.TransactionID=rec.TransactionID ");//
                sb.Append(" INNER JOIN f_receipt_paymentdetail recp ON rec.ReceiptNo=recp.ReceiptNo  ");
                sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
                sb.Append(" WHERE CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' AND rec.IsCancel=0  and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") AND adj.Type='IPD' ");//
                sb.Append(" GROUP BY rec.Date,rec.Reciever  ");
            }
            sb.Append(" ORDER BY dt ");

            DataTable dt1 = StockReports.GetDataTable(sb.ToString());
            if (dt1.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                DataColumn dc1 = new DataColumn();
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                dc.ColumnName = "Period";
                dc1.ColumnName = "UserName";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtFromTime.Text).ToString("hh:mm tt") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtToTime.Text).ToString("hh:mm tt");
                dc1.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt1.Columns.Add(dc);
                dt1.Columns.Add(dc1);
                DataSet ds = new DataSet();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables.Add(dt1.Copy());
                //ds.WriteXmlSchema(@"E:\\CollectionReportSummaryDepartmentWise.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "CollectionReportSummaryDepartmentWise";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
        else if (rbtReportType.SelectedValue == "4")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT adj.TransNo as IPDNo,''BillNo,rec.ReceiptNo,IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,rec.`AsainstLedgerTnxNo`,0),pm.PatientID) as  MRNo,IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,rec.`AsainstLedgerTnxNo`,1),pm.PName) as PName,pm.Age,IF(LedgerNoCr='LSHHI11','IPD-Advance','FINAL BILL SETTLEMENT')TypeOfTnx,CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,AmountPaid NetAmount, ");
            sb.Append("  SUM(rec_pay.Amount)PaidAmount,rec.RoundOff,rec_pay.PaymentMode ,rec_pay.PaymentModeID,em.Name UserName,rec_pay.BankName,rec_pay.RefNo,LedgerNoCr,cm.CentreName,cm.CentreID FROM f_reciept rec");
            sb.Append("  INNER JOIN patient_medical_history adj ON adj.TransactionID=rec.TransactionID ");//
            sb.Append("  INNER JOIN patient_master pm ON pm.PatientID=rec.Depositor");
            sb.Append("  INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
            sb.Append("  INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo");
            sb.Append("   WHERE rec.IsCancel=0 AND CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "'  and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") ");
            sb.Append("  AND LedgerNoCr IN ('LSHHI11','LSHHI12') AND adj.Type='IPD'  ");//
            sb.Append("  GROUP BY rec.ReceiptNo,rec_pay.PaymentModeID,DATE(rec.date) ORDER BY DATE(rec.date),TIME(rec.time)");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {

                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtFromTime.Text).ToString("hh:mm tt") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtToTime.Text).ToString("hh:mm tt");
                dt.Columns.Add(dc);
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                ds.Tables.Add(dtImg.Copy());
                // ds.WriteXmlSchema("E:\\dailycollectionIPDDetail.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "CollectionIPDDetail";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

        }
        else if (rbtReportType.SelectedValue == "5")
        {
            StringBuilder sb1 = new StringBuilder();



            sb1.Append(" SELECT TransactionID,BillNo,ReceiptNo, MRNo, PName,Age,TypeOfTnx,DATE,  NetAmount,Amount,RoundOff,UserName ,LedgerTransactionNo,PaymentMode,PaidAmount S_Amount,AmtCashAmt AmtCash,AmtChequeAmt AmtCheque,AmtCreditCardAmt AmtCreditCard,AmtCreditAmt AmtCredit,AmtNEFTAmt AmtNEFT,AmtPaytmAmt AS AmtPaytm,CentreName,CentreID,PaymentModeID ,PaidAmount,AmtCashAmt,AmtChequeAmt, AmtCreditCardAmt, AmtCreditAmt, AmtNEFTAmt,AmtPaytmAmt FROM  ( ");
           
            // for cash only
            sb1.Append(" SELECT t.*,SUM(Amount)PaidAmount,SUM(AmtCash)AmtCashAmt,SUM(AmtCheque)AmtChequeAmt,SUM(AmtCreditCard)AmtCreditCardAmt,SUM(AmtCredit)AmtCreditAmt,SUM(AmtNEFT)AmtNEFTAmt,SUM(AmtPaytm)AmtPaytmAmt ");
            sb1.Append(" FROM ( ");
            sb1.Append("  SELECT lt.TransactionID,lt.BillNo,rec.ReceiptNo,IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,rec.`AsainstLedgerTnxNo`,0),pm.PatientID) AS  MRNo, IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,rec.`AsainstLedgerTnxNo`,1),pm.PName) as PName,pm.Age,IF(ltd.TypeOfTnx='OPD-LAB','DIAGNOSIS',IF(ltd.TypeOfTnx='DR','DebitNote',IF(ltd.TypeOfTnx='CR','Credit Note',ltd.TypeOfTnx)))TypeOfTnx,CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE, ");
            sb1.Append(" ltd.NetItemAmt as NetAmount,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-lt.Roundoff),4) Amount,lt.RoundOff,em.Name UserName ,lt.LedgerTransactionNo,rec_pay.PaymentMode,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4) S_Amount,IF(rec_pay.PaymentModeID=1,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0)AmtCash, ");
            sb1.Append(" IF(rec_pay.PaymentModeID=2,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0)AmtCheque,  IF(rec_pay.PaymentModeID=3,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0)AmtCreditCard, IF(lt.PaymentModeID=4,ltd.NetItemAmt,0)AmtCredit,IF(rec_pay.PaymentModeID=6,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0)AmtNEFT,IF(rec_pay.PaymentModeID=9,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0)AmtPaytm,cm.CentreName,cm.CentreID,rec_pay.PaymentModeID    ");
            sb1.Append("  FROM f_reciept rec INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo ");
            sb1.Append("  INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo ");
            sb1.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
            sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID");
            sb1.Append("  INNER JOIN employee_master em ON rec.reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
            sb1.Append("  WHERE rec_pay.isOPDAdvance=0 AND rec.LedgerNoDr NOT IN  ('HOSP0006','HOSP0005') AND lt.PaymentModeID<>4 AND ltd.TypeOfTnx IN (" + colType + ")  AND lt.IsCancel=0 AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' and rec.reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") ");
            sb1.Append("  )t  GROUP BY t.ReceiptNo,t.PaymentModeID,t.TypeOfTnx ");

            //for OPD-Advance 
            if (colType.Contains("OPD-Advance"))
            {
                sb1.Append("  UNION ALL ");
                sb1.Append(" SELECT t.*,SUM(Amount)PaidAmount,SUM(AmtCash)AmtCashAmt,SUM(AmtCheque)AmtChequeAmt,SUM(AmtCreditCard)AmtCreditCardAmt,SUM(AmtCredit)AmtCreditAmt,SUM(AmtNEFT)AmtNEFTAmt,SUM(AmtPaytm)AmtPaytmAmt ");
                sb1.Append(" FROM ( ");
                sb1.Append("  SELECT lt.TransactionID,lt.BillNo,rec.ReceiptNo,lt.PatientID MRNo, ");
                sb1.Append("  pm.PName,pm.Age,'OPD-Advance' TypeOfTnx,CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE, ");
                sb1.Append("  NetAmount,(rec_pay.Amount)Amount,lt.RoundOff,em.Name UserName ,lt.LedgerTransactionNo,rec_pay.PaymentMode,rec_pay.S_Amount,IF(rec_pay.PaymentModeID=1,rec_pay.S_Amount,0)AmtCash, ");
                sb1.Append("  IF(rec_pay.PaymentModeID=2,rec_pay.S_Amount,0)AmtCheque,  IF(rec_pay.PaymentModeID=3,rec_pay.S_Amount,0)AmtCreditCard, IF(lt.PaymentModeID=4,lt.NetAmount,0)AmtCredit,IF(rec_pay.PaymentModeID=6,rec_pay.S_Amount,0)AmtNEFT,IF(rec_pay.PaymentModeID=9,rec_pay.S_Amount,0) AmtPaytm,cm.CentreName,cm.CentreID,rec_pay.PaymentModeID    ");
                sb1.Append("  FROM f_reciept rec  INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo ");
                sb1.Append("  INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo ");
                sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID");
                sb1.Append("  INNER JOIN employee_master em ON rec.reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                sb1.Append("  WHERE rec.isOPDAdvance=1  and lt.TypeOfTnx='OPD-Advance' AND lt.IsCancel=0 AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' and rec.reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") ");
                sb1.Append("  )t  GROUP BY t.ReceiptNo,t.PaymentModeID      ");

            }
            // for Expense only
            if (colType.Contains("EXPENSE"))
            {

                sb1.Append("  UNION ALL");
                sb1.Append(" SELECT t.*,SUM(Amount)PaidAmount,SUM(AmtCash) AmtCashAmt,SUM(AmtCheque) AmtChequeAmt,SUM(AmtCreditCard) AmtCreditCardAmt,SUM(AmtCredit)AmtCreditAmt,SUM(AmtNEFT)AmtNEFTAmt,SUM(AmtPaytm)AmtPaytmAmt  ");
                sb1.Append("   FROM ( ");
                sb1.Append("  SELECT '' TransactionID,'' BillNo,fre.ReceiptNo,fre.ExpenceToId AS MRNo, fre.ExpenceTo PName,'' Age,'Payment' AS  TypeOfTnx,CONCAT(DATE_FORMAT(fre.date,'%d %b %Y'),' ',DATE_FORMAT(fre.time,'%H:%i')) DATE, ");
                sb1.Append("  fre.AmountPaid*-1 NetAmount,fre.AmountPaid*-1 Amount,'' RoundOff ,Em.Name  UserName,AsainstLedgerTnxNo LedgerTransactionNo,fre.IsCheque_Draft PaymentMode, ");
                sb1.Append("  fre.AmountPaid*-1 S_Amount,fre.AmountPaid*-1 AmtCash,IF(fre.isCheque_Draft=2,fre.AmountPaid*-1,0)AmtCheque,IF(fre.isCheque_Draft=3,fre.AmountPaid*-1,0)AmtCreditCard,0 AmtCredit,0 AmtNEFT,0 AmtPaytm,cm.CentreName,cm.CentreID,''PaymentModeID    ");
                sb1.Append("  FROM f_reciept_expence fre INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0   INNER JOIN Center_master cm ON cm.CentreID = fre.CentreID ");
                sb1.Append("  AND (CONCAT(fre.Date,' ',fre.Time) >= '" + startDate + "' ) ");
                sb1.Append("  AND (CONCAT(fre.Date,' ',fre.Time) <= '" + toDate + "' )   And fre.Depositor in (" + user + ") AND fre.CentreID IN (" + Centre + ") ");
                sb1.Append("  )t   GROUP BY t.ReceiptNo      ");
            }
            //for Credit only
            //sb1.Append("  UNION ALL");
            //sb1.Append(" SELECT t.*,SUM(Amount)PaidAmount,0 AmtCashAmt,0 AmtChequeAmt,0 AmtCreditCardAmt,SUM(AmtCredit)AmtCreditAmt,SUM(AmtNEFT)AmtNEFTAmt,SUM(AmtPaytm)AmtPaytmAmt  ");
            //sb1.Append("   FROM ( ");
            //sb1.Append("  SELECT lt.TransactionID,lt.BillNo,'' ReceiptNo, IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,lt.LedgerTransactionNo,0),pm.PatientID) MRNo, IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,lt.LedgerTransactionNo,1),pm.PName) AS PName,pm.Age,IF(ltd.TypeOfTnx='OPD-LAB','DIAGNOSIS',IF(ltd.TypeOfTnx='DR','DebitNote',IF(ltd.TypeOfTnx='CR','Credit Note',ltd.TypeOfTnx)))TypeOfTnx,CONCAT(DATE_FORMAT(lt.date,'%d %b %Y'),' ',DATE_FORMAT(lt.time,'%H:%i'))DATE,");
            //sb1.Append("  ltd.NetItemAmt as NetAmount,0 Amount,lt.RoundOff,em.Name UserName,lt_pay.LedgerTransactionNo,lt_pay.PaymentMode,ROUND((lt_pay.S_Amount*ltd.NetItemAmt)/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4) as S_Amount ,0 AmtCash,0 AmtCheque,0 AmtCreditCard,  IF(lt_pay.PaymentModeID=4,ROUND((lt_pay.S_Amount*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0)AmtCredit,0 AmtNEFT,0 AmtPaytm,cm.CentreName,cm.CentreID,lt_pay.PaymentModeID    FROM f_ledgertransaction lt ");
            //sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID");
            //sb1.Append("   INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
            //sb1.Append("  INNER JOIN employee_master em ON lt.UserID=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = lt.CentreID ");
            //sb1.Append("  INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo");
            //sb1.Append("  WHERE lt_pay.PaymentModeID=4 and ltd.TypeOfTnx IN (" + colType + ") AND lt.IsCancel=0 and CONCAT(lt.Date,' ',lt.Time)>='" + startDate + "' AND CONCAT(lt.Date,' ',lt.Time)<='" + toDate + "' and lt.userID in (" + user + ") AND lt.CentreID IN (" + Centre + ") ");
            //sb1.Append("  )t   GROUP BY t.LedgerTransactionNo,t.PaymentModeID,t.TypeOfTnx      ");

            //for adjustment
            if (colType.Contains("OPD Advance/Settlements"))
            {
                sb1.Append("  UNION ALL");
                sb1.Append("  SELECT t.*,SUM(Amount)PaidAmount,SUM(AmtCash)AmtCashAmt,SUM(AmtCheque)AmtChequeAmt,SUM(AmtCreditCard)AmtCreditCardAmt,SUM(AmtCredit)AmtCreditAmt,SUM(AmtNEFT)AmtNEFTAmt,SUM(AmtPaytm)AmtPaytmAmt ");
                sb1.Append("   FROM (  ");
                sb1.Append("  SELECT rec.TransactionID,''BillNo,rec.ReceiptNo,IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,rec.`AsainstLedgerTnxNo`,0),pm.PatientID) AS  MRNo,IF(pm.`PatientID` IN('CASH002','CASH005','CASH006'),GetOutSupplierOrDeptOrWalkinPatientName(pm.`PatientID`,rec.`AsainstLedgerTnxNo`,1),pm.PName) as PName,pm.Age,'OPD Settlement' TypeOfTnx,CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,AmountPaid NetAmount, ");
                sb1.Append("  (rec_pay.Amount)Amount,rec.RoundOff ,em.Name UserName,'' LedgerTransactionNo,rec_pay.PaymentMode,rec_pay.S_Amount,IF(rec_pay.PaymentModeID=1,rec_pay.S_Amount,0)AmtCash, ");
                sb1.Append("  IF(rec_pay.PaymentModeID=2,rec_pay.S_Amount,0)AmtCheque,IF(rec_pay.PaymentModeID=3,rec_pay.S_Amount,0)AmtCreditCard, ");
                sb1.Append("  IF(rec_pay.PaymentModeID=4,rec_pay.S_Amount,0)AmtCredit,IF(rec_pay.PaymentModeID=6,rec_pay.S_Amount,0)AmtNEFT,IF(rec_pay.PaymentModeID=9,rec_pay.S_Amount,0)AmtPaytm,cm.CentreName,cm.CentreID,rec_pay.PaymentModeID   ");
              
                sb1.Append("  FROM f_reciept rec ");
                sb1.Append("  INNER JOIN patient_master pm on pm.PatientID=rec.Depositor ");
                sb1.Append("  INNER JOIN f_receipt_paymentdetail rec_pay on rec_pay.ReceiptNo=rec.ReceiptNo ");
                sb1.Append("  INNER JOIN employee_master em on em.EmployeeID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                sb1.Append("  WHERE  rec.LedgerNoDr IN ('HOSP0006','HOSP0005') AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
                sb1.Append("  )t  GROUP BY t.ReceiptNo  ,t.PaymentModeID      ");
            }
            //for IPD advance
            if (colType.Contains("IPD"))
            {
                sb1.Append("  UNION ALL");
                sb1.Append(" SELECT t.*,SUM(Amount)PaidAmount,SUM(AmtCash)AmtCashAmt,SUM(AmtCheque)AmtChequeAmt,SUM(AmtCreditCard)AmtCreditCardAmt,SUM(AmtCredit)AmtCreditAmt,SUM(AmtNEFT)AmtNEFTAmt,SUM(AmtPaytm)AmtPaytmAmt ");
                sb1.Append(" FROM ( ");
                sb1.Append("  SELECT rec.TransactionID,''BillNo,rec.ReceiptNo,rec.Depositor MRNo,pm.PName,pm.Age,'IPD-Advance' TypeOfTnx,CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,AmountPaid NetAmount,");
                sb1.Append(" (rec_pay.Amount)Amount,rec.RoundOff ,em.Name UserName,'' LedgerTransactionNo,rec_pay.PaymentMode,rec_pay.S_Amount,IF(rec_pay.PaymentModeID=1,rec_pay.S_Amount,0)AmtCash, ");
                sb1.Append("   IF(rec_pay.PaymentModeID=2,rec_pay.S_Amount,0)AmtCheque,IF(rec_pay.PaymentModeID=3,rec_pay.S_Amount,0)AmtCreditCard, ");
                sb1.Append("   IF(rec_pay.PaymentModeID=4,rec_pay.S_Amount,0)AmtCredit,IF(rec_pay.PaymentModeID=6,rec_pay.S_Amount,0)AmtNEFT,IF(rec_pay.PaymentModeID=9,rec_pay.S_Amount,0)AmtPaytm,cm.CentreName,cm.CentreID,rec_pay.PaymentModeID  FROM f_reciept rec");
                sb1.Append("  INNER JOIN patient_medical_history adj ON adj.TransactionID=rec.TransactionID ");//
                sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=rec.Depositor");
                sb1.Append("  INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                sb1.Append("  INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo");
                sb1.Append("  WHERE rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "'  and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") AND adj.Type='IPD'  ");//
                sb1.Append("  )t  GROUP BY t.ReceiptNo ,t.PaymentModeID   ");
            }

            sb1.Append(" )t2 ORDER BY t2.BillNo,t2.ReceiptNo ");
            DataTable dt = StockReports.GetDataTable(sb1.ToString());
            if (dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtFromTime.Text).ToString("hh:mm tt") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtToTime.Text).ToString("hh:mm tt");
                dt.Columns.Add(dc);
                if (rdbReportType.SelectedValue == "PDF")
                {
                    DataTable dtImg = All_LoadData.CrystalReportLogo();
                    DataSet ds = new DataSet();

                    ds.Tables.Add(dt.Copy());
                    ds.Tables.Add(dtImg.Copy());
                    //  ds.WriteXmlSchema("E:\\Collection.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "collectionDetail";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
                }
                else if (rdbReportType.SelectedValue == "EXCEL")
                {
                    dt.Columns.Remove("NetAmount");
                    dt.Columns.Remove("Amount");
                    dt.Columns.Remove("RoundOff");
                    dt.Columns.Remove("LedgerTransactionNo");
                    dt.Columns.Remove("PaymentMode");
                    dt.Columns.Remove("S_Amount");
                    dt.Columns.Remove("AmtCash");
                    dt.Columns.Remove("AmtCheque");
                    dt.Columns.Remove("AmtCreditCard");
                    dt.Columns.Remove("AmtNEFT");
                    dt.Columns.Remove("CentreID");
                    dt.Columns.Remove("PaymentModeID");
                    dt.Columns.Remove("PaidAmount");
                    dt.Columns.Remove("Period");
                    Session["ReportName"] = "Collection Report";
                    Session["dtExport2Excel"] = dt;
                    Session["Period"] = "Period From : " + ucFromDate.Text.Trim() + " To : " + ucToDate.Text.Trim();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                }
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
        else if (rbtReportType.SelectedValue == "6")
        {
            StringBuilder sb1 = new StringBuilder();

            sb1.Append(" SELECT SUM(PaidAmount)PaidAmount,SUM(AmtCash)AmtCash,SUM(AmtCheque)AmtCheque, ");
            sb1.Append(" SUM(AmtCreditCard)AmtCreditCard,SUM(AmtNEFT)AmtNEFT,SUM(AmtCashR)AmtCashR,SUM(AmtChequeR)AmtChequeR,SUM(AmtCreditCardR)AmtCreditCardR,SUM(AmtNEFTR)AmtNEFTR,SUM(AmtMobileUPI)AmtMobileUPI,sum(AmtMobileUPIR)AmtMobileUPIR,UserName,UserID FROM ");
            sb1.Append(" ( ");
            sb1.Append("  SELECT SUM(ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4)) PaidAmount,em.Name UserName,rec.reciever UserID, ");
            sb1.Append("  SUM(IF(rec_pay.PaymentModeID=1,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0))AmtCash,  ");
            sb1.Append("  SUM(IF(rec_pay.PaymentModeID=2,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0))AmtCheque,");
            sb1.Append("  SUM(IF(rec_pay.PaymentModeID=3,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0))AmtCreditCard,SUM(IF(rec_pay.PaymentModeID=6,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0))AmtNEFT, ");
            sb1.Append("  SUM(IF(rec_pay.PaymentModeID=9,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4),0))AmtMobileUPI,    ");
            sb1.Append("  0 AmtCashR,0 AmtChequeR,0 AmtCreditCardR,0 AmtMobileUPIR,0 AmtNEFTR,cm.CentreName,cm.CentreID FROM f_reciept rec  ");
            sb1.Append("  INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo ");
            sb1.Append("  INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo ");
            sb1.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
           
            sb1.Append("  INNER JOIN employee_master em ON rec.reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  WHERE rec_pay.PaymentModeID<>4 AND  ltd.TypeOfTnx IN (" + colType + ")");

            sb1.Append("  AND rec.isOPDAdvance=0 AND rec.LedgerNoDr NOT IN  ('HOSP0006','HOSP0005') AND rec.IsCancel=0 AND lt.IsCancel=0 AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "'   AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' AND rec.CentreID IN (" + Centre + ") ");
            sb1.Append("  AND rec.reciever in (" + user + ") GROUP BY rec.reciever  ");

            // for OPD-Advance
            if (colType.Contains("OPD-Advance"))
            {
                sb1.Append("  UNION ALL");
                sb1.Append("  SELECT SUM(rec_pay.S_Amount) PaidAmount,em.Name UserName,rec.Reciever UserID, ");
                sb1.Append("  SUM(IF(rec_pay.PaymentModeID=1,rec_pay.S_Amount,0))AmtCash,  ");
                sb1.Append("  SUM(IF(rec_pay.PaymentModeID=2,rec_pay.S_Amount,0))AmtCheque,");
                sb1.Append("  SUM(IF(rec_pay.PaymentModeID=3,rec_pay.S_Amount,0))AmtCreditCard,SUM(IF(rec_pay.PaymentModeID=6,rec_pay.S_Amount,0))AmtNEFT, ");
                sb1.Append("  SUM(IF(rec_pay.PaymentModeID=6,rec_pay.S_Amount,0))AmtMobileUPI, ");
                sb1.Append("  0 AmtCashR,0 AmtChequeR,0 AmtCreditCardR,0 AmtMobileUPIR,0 AmtNEFTR,cm.CentreName,cm.CentreID FROM f_reciept rec   INNER JOIN f_receipt_paymentdetail rec_pay ON ");
                sb1.Append("  rec.ReceiptNo=rec_pay.ReceiptNo INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  WHERE rec_pay.PaymentModeID<>4 ");
                sb1.Append("  AND rec.isOPDAdvance=1  AND rec.IsCancel=0 AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' AND rec.CentreID IN (" + Centre + ") ");
                sb1.Append("  AND rec.Reciever in (" + user + ") GROUP BY rec.Reciever  ");
            }
            //for Expense only
            if (colType.Contains("EXPENSE"))
            {
                sb1.Append("  UNION ALL");
                sb1.Append("  SELECT SUM(fre.AmountPaid*-1) PaidAmount,CONCAT(em.Title,' ',Em.Name) UserName,em.EmployeeID UserID, ");
                sb1.Append("  SUM(fre.AmountPaid*-1) AmtCash,(IF(IsCheque_Draft=2,fre.AmountPaid*-1,0))AmtCheque,");
                sb1.Append("  (IF(IsCheque_Draft=3,fre.AmountPaid*-1,0))AmtCreditCard,0 AmtNEFT,0 AmtCashR,0 AmtChequeR,0 AmtCreditCardR,0 AmtMobileUPIR,0 AmtNEFTR, 0 AmtMobileUPI ,cm.CentreName,cm.CentreID ");
                sb1.Append("  FROM f_reciept_expence fre INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0  INNER JOIN Center_master cm ON cm.CentreID = fre.CentreID ");
                sb1.Append("  AND (CONCAT(fre.Date,' ',fre.Time) >= '" + startDate + "' ) ");
                sb1.Append("  AND (CONCAT(fre.Date,' ',fre.Time) <= '" + toDate + "' )   And fre.Depositor in (" + user + ") AND fre.CentreID IN (" + Centre + ") GROUP BY fre.Depositor  ");
            }
            //for adjustment
            if (colType.Contains("OPD Advance/Settlements"))
            {
                sb1.Append("  UNION ALL");
                sb1.Append("  SELECT SUM(rec_pay.S_Amount)PaidAmount,em.Name UserName,rec.Reciever UserID, ");
                sb1.Append("  SUM(IF(rec_pay.PaymentModeID=1,rec_pay.S_Amount,0))AmtCash,");
                sb1.Append("  SUM(IF(rec_pay.PaymentModeID=2,rec_pay.S_Amount,0))AmtCheque, ");
                sb1.Append("  SUM(IF(rec_pay.PaymentModeID=3,rec_pay.S_Amount,0))AmtCreditCard,SUM(IF(rec_pay.PaymentModeID=6,rec_pay.S_Amount,0))AmtNEFT, ");
                sb1.Append(" SUM(IF(rec_pay.PaymentModeID=9,rec_pay.S_Amount,0))AmtMobileUPI, ");
                sb1.Append("  0 AmtCashR,0 AmtChequeR,0 AmtCreditCardR,0 AmtMobileUPIR,0 AmtNEFTR,cm.CentreName,cm.CentreID ");
              
                sb1.Append("  FROM f_reciept rec ");
                sb1.Append(" INNER JOIN patient_master pm ON pm.PatientID=rec.Depositor   INNER JOIN f_receipt_paymentdetail rec_pay  ");
                sb1.Append("  ON rec_pay.ReceiptNo=rec.ReceiptNo   INNER JOIN employee_master em ON em.EmployeeID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  WHERE  rec.LedgerNoDr IN ('HOSP0006','HOSP0005') AND rec.IsCancel=0 AND ");
                sb1.Append("  CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") ");
                sb1.Append("  GROUP BY rec.Reciever  ");
            }
            //for IPD advance
            if (colType.Contains("IPD"))
            {
                sb1.Append("  UNION ALL");
                sb1.Append(" SELECT SUM(rec_pay.S_Amount)PaidAmount,em.Name UserName,rec.Reciever UserID, ");
                sb1.Append(" SUM(IF(rec_pay.PaymentModeID=1,rec_pay.S_Amount,0))AmtCash,  ");
                sb1.Append(" SUM(IF(rec_pay.PaymentModeID=2,rec_pay.S_Amount,0))AmtCheque, ");
                sb1.Append(" SUM(IF(rec_pay.PaymentModeID=3,rec_pay.S_Amount,0))AmtCreditCard, SUM(IF(rec_pay.PaymentModeID=6,rec_pay.S_Amount,0))AmtNEFT, ");
                sb1.Append(" SUM(IF(rec_pay.PaymentModeID=9,rec_pay.S_Amount,0))AmtMobileUPI, ");
                sb1.Append(" 0 AmtCashR,0 AmtChequeR,0 AmtCreditCardR,0 AmtMobileUPIR,0 AmtNEFTR,cm.CentreName,cm.CentreID   ");
                sb1.Append(" FROM f_reciept Rec  INNER JOIN patient_medical_history adj ");//
                sb1.Append(" ON adj.TransactionID=rec.TransactionID    INNER JOIN f_receipt_paymentdetail rec_pay  ");
                sb1.Append(" ON rec_pay.ReceiptNo=rec.ReceiptNo   INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  ");
                sb1.Append(" WHERE rec.Iscancel=0 AND CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "'  AND rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") AND adj.Type='IPD'  ");//
                sb1.Append(" GROUP BY rec.Reciever   ");
            }
            // OPD-Refund
            sb1.Append("  UNION ALL");
            sb1.Append(" SELECT SUM(rec_pay.S_Amount)PaidAmount,em.name UserName,rec.Reciever UserID, ");
            sb1.Append(" 0 AmtCash,0 AmtCheque,0 AmtCreditCard,0 AmtNEFT,    SUM(IF(rec_pay.PaymentModeID=9,rec_pay.S_Amount,0))AmtMobileUPI, ");
            sb1.Append(" SUM(IF(rec_pay.PaymentModeID=1,rec_pay.S_Amount,0))AmtCashR,");
            sb1.Append(" SUM(IF(rec_pay.PaymentModeID=2,rec_pay.S_Amount,0))AmtChequeR, ");
            //sb1.Append(" SUM(IF(rec_pay.PaymentModeID=9,rec_pay.S_Amount,0))AmtMobileUPIR,");
            sb1.Append(" SUM(IF(rec_pay.PaymentModeID=3,rec_pay.S_Amount,0))AmtCreditCardR, SUM(IF(rec_pay.PaymentModeID=9,rec_pay.S_Amount,0))AmtMobileUPIR,SUM(IF(rec_pay.PaymentModeID=6,rec_pay.S_Amount,0))AmtNEFTR,cm.CentreName,cm.CentreID ");
            sb1.Append(" FROM f_reciept rec INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo ");
            sb1.Append(" INNER JOIN employee_master em ON em.EmployeeID = rec.Reciever  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
            sb1.Append(" WHERE AmountPaid < 0 AND IsCancel=0 AND  ");
            sb1.Append(" CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "'  and rec.Reciever in (" + user + ")  AND rec.CentreID IN (" + Centre + ") ");
            sb1.Append(" GROUP BY rec.Reciever  ");
            //Cancel
            sb1.Append("  UNION ALL");
            sb1.Append(" SELECT SUM(rec_pay.S_Amount)PaidAmount,em.name UserName,rec.Reciever UserID,");
            sb1.Append(" 0 AmtCash,0 AmtCheque,0 AmtCreditCard,0 AmtNEFT,0 AmtMobileUPI, ");
            sb1.Append(" SUM(IF(rec_pay.PaymentModeID=1,rec_pay.S_Amount*-1,0))AmtCashR,  ");
            sb1.Append(" SUM(IF(rec_pay.PaymentModeID=2,rec_pay.S_Amount*-1,0))AmtChequeR,  ");
            sb1.Append(" SUM(IF(rec_pay.PaymentModeID=9,rec_pay.S_Amount,0))AmtMobileUPI,");
            sb1.Append(" SUM(IF(rec_pay.PaymentModeID=3,rec_pay.S_Amount*-1,0))AmtCreditCardR,SUM(IF(rec_pay.PaymentModeID=6,rec_pay.S_Amount*-1,0))AmtNEFTR,cm.CentreName,cm.CentreID");
            sb1.Append("  FROM f_reciept rec INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo");
            sb1.Append("  INNER JOIN employee_master em ON em.EmployeeID = rec.Reciever  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
            sb1.Append("  WHERE  IsCancel=1   AND");
            sb1.Append(" CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "'  and rec.Reciever in (" + user + ")  AND rec.CentreID IN (" + Centre + ") ");
            sb1.Append(" GROUP BY rec.Reciever ");
            sb1.Append(" )t GROUP BY UserID ORDER BY t.UserName");
            DataTable dt = StockReports.GetDataTable(sb1.ToString());
            if (dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtFromTime.Text).ToString("hh:mm tt") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtToTime.Text).ToString("hh:mm tt");
                dt.Columns.Add(dc);
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                DataSet ds = new DataSet();

                ds.Tables.Add(dt.Copy());
                ds.Tables.Add(dtImg.Copy());
                //  ds.WriteXmlSchema("E:\\collection.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "collection";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
        else if (rbtReportType.SelectedValue == "9")
        {
            string Doctor = StockReports.GetSelection(chkDoctor);
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT DATE,Dt,NAME,SUM(Amount)Amount,DoctorName,DoctorID FROM ( ");
            sb.Append("  SELECT DATE_FORMAT(rec.date,'%d %b %Y')DATE,rec.Date dt,em.Name,ROUND(((if(rec_pay.PaymentmodeID=5,0,rec_pay.S_Amount))*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),3) Amount,IFNULL((SELECT CONCAT(dm.Title,' ',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID)),'NA') DoctorName,IFNULL(IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID),'0') as DoctorID,rec.Reciever UserID,cm1.CentreName,cm1.CentreID FROM f_ledgertransaction lt   ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0  ");
            sb.Append("  INNER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
            sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sb.Append("  INNER JOIN employee_master em ON rec.reciever=em.EmployeeID   INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
            sb.Append("  WHERE rec.isOPDAdvance=0 AND rec.LedgerNoDr NOT IN  ('HOSP0006','HOSP0005')  AND rec.IsCancel=0 AND lt.PaymentModeID<>4 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' AND lt.IsCancel=0 and ltd.TypeOfTnx IN (" + colType + ")  AND IFNULL(lt.LedgerTransactionNo,'')<>'' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
            sb.Append("  AND IFNULL(IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID),0) IN(" + Doctor + ") ");
            sb.Append("   )t ");
            sb.Append("  GROUP BY t.Date,t.DoctorID ");

            if (colType.Contains("OPD-Advance"))
            {
                sb.Append("  UNION ALL");
                sb.Append("  SELECT DATE,Dt,NAME,SUM(Amount)Amount,DoctorName,DoctorID FROM ( ");
                sb.Append("  SELECT DATE_FORMAT(rec.date,'%d %b %Y')DATE,rec.Date dt,em.Name,ROUND(((rec.AmountPaid)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),3) Amount,IFNULL((SELECT CONCAT(dm.Title,' ',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID)),'NA') DoctorName,IFNULL(IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID),'0') as DoctorID,rec.Reciever UserID,cm1.CentreName,cm1.CentreID FROM f_ledgertransaction lt   ");
                sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0  ");
                sb.Append("  INNER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo  ");
                sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID   ");
                sb.Append("  INNER JOIN employee_master em ON rec.reciever=em.EmployeeID INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
                sb.Append("  WHERE rec.isOPDAdvance=1 AND rec.IsCancel=0 AND lt.PaymentModeID<>4 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' AND lt.IsCancel=0 and lt.TypeOfTnx='OPD-Advance'  AND IFNULL(lt.LedgerTransactionNo,'')<>'' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
                sb.Append("  AND IFNULL(IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID),0) IN(" + Doctor + ") ");
                sb.Append("   )t ");
                sb.Append("  GROUP BY t.Date,t.DoctorID ");

            }
            if (colType.Contains("OPD Advance/Settlements"))
            {
                //only cash Settlements
                sb.Append("  UNION ALL");
                sb.Append(" SELECT DATE,Dt,Name,SUM(Amount)Amount,DoctorName,DoctorID FROM ( ");
                sb.Append("  SELECT DATE_FORMAT(rec.date,'%d %b %Y')DATE,rec.Date dt,em.Name,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),3) Amount,IFNULL((SELECT CONCAT(dm.Title,' ',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID)),'NA') DoctorName ,IFNULL(IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID),'0') as DoctorID,rec.Reciever userID,cm1.CentreName,cm1.CentreID  ");
               
                sb.Append("  FROM f_reciept rec ");

                sb.Append("   INNER JOIN patient_master pm on pm.PatientID=rec.Depositor  ");
                sb.Append("   INNER JOIN employee_master em on em.EmployeeID=rec.Reciever  ");
                sb.Append("   INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
                sb.Append("   INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionNo` = rec.`AsainstLedgerTnxNo`  ");
                sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
                sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID  ");
                sb.Append("   INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
                sb.Append("   WHERE   rec.LedgerNoDr IN ('HOSP0006','HOSP0005') AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
                sb.Append("  AND IFNULL(IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID),0) IN(" + Doctor + ") ");
                sb.Append("   )t   GROUP BY DATE,DoctorID ");
            }
            if (colType.Contains("EXPENSE"))
            {
                //only Expense
                sb.Append("  UNION ALL");
                sb.Append(" SELECT DATE,Dt,Name,SUM(Amount)Amount,DoctorName,DoctorID FROM ( ");
                sb.Append("  SELECT '0' DoctorID,DATE_FORMAT(fre.Date,'%d %b %Y') DATE,fre.Date dt,Em.Name, fre.AmountPaid*-1 Amount, 'NA' DoctorName, Em.EmployeeID  UserID,cm1.CentreName,cm1.CentreID ");
                sb.Append("  FROM f_reciept_expence fre INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0   INNER JOIN Center_master cm1 ON cm1.CentreID = fre.CentreID ");
                sb.Append("  AND (CONCAT(fre.Date,' ',fre.Time) >= '" + startDate + "') ");
                sb.Append("  AND (CONCAT(fre.Date,' ',fre.Time) <= '" + toDate + "')  And fre.Depositor in (" + user + ") AND fre.CentreID IN (" + Centre + ") ");
                sb.Append("   )t where t.DoctorID IN(" + Doctor + ") GROUP BY DATE,DoctorID ");
            }
            if (colType.Contains("IPD"))
            {
                sb.Append(" UNION ALL  ");
                sb.Append(" SELECT DATE_FORMAT(rec.date,'%d %b %Y')DATE,rec.date dt,em.Name,SUM(recp.Amount)Amount, CONCAT(dm.Title,' ',dm.Name) DoctorName,pmh.DoctorID FROM f_reciept rec  ");
                sb.Append(" INNER JOIN patient_medical_history adj ON adj.TransactionID=rec.TransactionID ");//
                sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=adj.TransactionID INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
                sb.Append(" INNER JOIN f_receipt_paymentdetail recp ON rec.ReceiptNo=recp.ReceiptNo  ");
                sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
                sb.Append(" WHERE CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' AND rec.IsCancel=0  and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") ");
                sb.Append(" and pmh.DoctorID IN(" + Doctor + ") AND adj.Type='IPD'  ");//
                sb.Append(" GROUP BY rec.Date,rec.Reciever,DoctorID  ");
            }

            sb.Append(" ORDER BY dt,DoctorName ");

            DataTable dt1 = StockReports.GetDataTable(sb.ToString());
            if (dt1.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                DataColumn dc1 = new DataColumn();
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                dc.ColumnName = "Period";
                dc1.ColumnName = "UserName";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtFromTime.Text).ToString("hh:mm tt") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtToTime.Text).ToString("hh:mm tt");
                dc1.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt1.Columns.Add(dc);
                dt1.Columns.Add(dc1);
                DataSet ds = new DataSet();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables.Add(dt1.Copy());
                //   ds.WriteXmlSchema(@"D:\\CollectionReportSummaryDoctortWise.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "CollectionReportSummaryDoctorWise";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
        else if (rbtReportType.SelectedValue == "10")
        {

            string Speciality = StockReports.GetSelection(chkSpeciality);
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT DATE,Dt,NAME,SUM(Amount)Amount,Speciality FROM ( ");
            sb.Append("  SELECT DATE_FORMAT(rec.date,'%d %b %Y')DATE,rec.Date dt,em.Name,ROUND(((if(rec_pay.PaymentmodeID=5,0,rec_pay.S_Amount))*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),3) Amount,IFNULL((SELECT if(ifnull(dm.Specialization,'')<>'',dm.Specialization,'NA') FROM doctor_master dm WHERE dm.DoctorID=IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID)),'NA') Speciality,rec.Reciever UserID,cm1.CentreName,cm1.CentreID FROM f_ledgertransaction lt   ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0  ");
            sb.Append("  INNER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
            sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sb.Append("  INNER JOIN employee_master em ON rec.reciever=em.EmployeeID   INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
            sb.Append("  WHERE rec.isOPDAdvance=0 AND rec.LedgerNoDr NOT IN  ('HOSP0006','HOSP0005')  AND rec.IsCancel=0 AND lt.PaymentModeID<>4 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' AND lt.IsCancel=0 and ltd.TypeOfTnx IN (" + colType + ")  AND IFNULL(lt.LedgerTransactionNo,'')<>'' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
            sb.Append("   )t where t.Speciality IN(" + Speciality + ") ");
            sb.Append("  GROUP BY t.Date,t.Speciality ");

            if (colType.Contains("OPD-Advance"))
            {
                sb.Append("  UNION ALL");
                sb.Append("  SELECT DATE,Dt,NAME,SUM(Amount)Amount,Speciality FROM ( ");
                sb.Append("  SELECT DATE_FORMAT(rec.date,'%d %b %Y')DATE,rec.Date dt,em.Name,ROUND(((rec.AmountPaid)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),3) Amount,IFNULL((SELECT if(ifnull(dm.Specialization,'')<>'',dm.Specialization,'NA') FROM doctor_master dm WHERE dm.DoctorID=IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID)),'NA') Speciality,rec.Reciever UserID,cm1.CentreName,cm1.CentreID FROM f_ledgertransaction lt   ");
                sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0  ");
                sb.Append("  INNER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo  ");
                sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID   ");
                sb.Append("  INNER JOIN employee_master em ON rec.reciever=em.EmployeeID INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
                sb.Append("  WHERE rec.isOPDAdvance=1 AND rec.IsCancel=0 AND lt.PaymentModeID<>4 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' AND lt.IsCancel=0 and lt.TypeOfTnx='OPD-Advance'  AND IFNULL(lt.LedgerTransactionNo,'')<>'' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
                sb.Append("   )t where t.Speciality IN(" + Speciality + ") ");
                sb.Append("  GROUP BY t.Date,t.Speciality ");

            }
            if (colType.Contains("OPD Advance/Settlements"))
            {
                //only cash Settlements
                sb.Append("  UNION ALL");
                sb.Append(" SELECT DATE,Dt,Name,SUM(Amount)Amount,Speciality FROM ( ");
                sb.Append("  SELECT DATE_FORMAT(rec.date,'%d %b %Y')DATE,rec.Date dt,em.Name,ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(ltd.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),3) Amount,IFNULL((SELECT if(ifnull(dm.Specialization,'')<>'',dm.Specialization,'NA') FROM doctor_master dm WHERE dm.DoctorID=IF(IFNULL(ltd.DoctorID,'')<>'',ltd.DoctorID,pmh.DoctorID)),'NA') Speciality ,rec.Reciever userID,cm1.CentreName,cm1.CentreID  ");
                sb.Append("  FROM f_reciept rec ");
                sb.Append("   INNER JOIN patient_master pm on pm.PatientID=rec.Depositor  ");
                sb.Append("   INNER JOIN employee_master em on em.EmployeeID=rec.Reciever  ");
                sb.Append("   INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
                sb.Append("   INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionNo` = rec.`AsainstLedgerTnxNo`  ");
                sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
                sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID  ");
                sb.Append("   INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
                sb.Append("   WHERE  rec.LedgerNoDr IN ('HOSP0006','HOSP0005') AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ")  ");
                sb.Append("   )t where t.Speciality IN(" + Speciality + ") GROUP BY DATE,Speciality ");

            }
            if (colType.Contains("EXPENSE"))
            {
                //only Expense
                sb.Append("  UNION ALL");
                sb.Append(" SELECT DATE,Dt,Name,SUM(Amount)Amount,Speciality FROM ( ");
                sb.Append("  SELECT DATE_FORMAT(fre.Date,'%d %b %Y') DATE,fre.Date dt,Em.Name, fre.AmountPaid*-1 Amount, 'NA' Speciality, Em.EmployeeID  UserID,cm1.CentreName,cm1.CentreID ");
                sb.Append("  FROM f_reciept_expence fre INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0   INNER JOIN Center_master cm1 ON cm1.CentreID = fre.CentreID ");
                sb.Append("  AND (CONCAT(fre.Date,' ',fre.Time) >= '" + startDate + "') ");
                sb.Append("  AND (CONCAT(fre.Date,' ',fre.Time) <= '" + toDate + "')  And fre.Depositor in (" + user + ") AND fre.CentreID IN (" + Centre + ") ");
                sb.Append(" )t where t.Speciality IN(" + Speciality + ") GROUP BY DATE,Speciality ");
            }
            if (colType.Contains("IPD"))
            {
                sb.Append(" UNION ALL  ");
                sb.Append(" SELECT DATE_FORMAT(rec.date,'%d %b %Y')DATE,rec.date dt,em.Name,SUM(recp.Amount)Amount, if(ifnull(dm.Specialization,'')<>'',dm.Specialization,'NA') Speciality FROM f_reciept rec  ");
                //sb.Append(" INNER JOIN f_ipdadjustment adj ON adj.TransactionID=rec.TransactionID ");
                sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=rec.TransactionID INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
                sb.Append(" INNER JOIN f_receipt_paymentdetail recp ON rec.ReceiptNo=recp.ReceiptNo  ");
                sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm1 ON cm1.CentreID = rec.CentreID ");
                sb.Append(" WHERE CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "' AND rec.IsCancel=0  and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") AND pmh.Type='IPD'  ");//
                sb.Append(" and DM.Specialization IN(" + Speciality + ") ");
                sb.Append(" GROUP BY rec.Date,Speciality  ");
            }
            sb.Append(" ORDER BY dt,Speciality ");

            DataTable dt1 = StockReports.GetDataTable(sb.ToString());
            if (dt1.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                DataColumn dc1 = new DataColumn();
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                dc.ColumnName = "Period";
                dc1.ColumnName = "UserName";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtFromTime.Text).ToString("hh:mm tt") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtToTime.Text).ToString("hh:mm tt");
                dc1.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt1.Columns.Add(dc);
                dt1.Columns.Add(dc1);
                DataSet ds = new DataSet();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables.Add(dt1.Copy());
                //  ds.WriteXmlSchema(@"D:\\CollectionReportSummarySpecialitytWise.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "CollectionReportSummarySpecialitytWise";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
        else if (rbtReportType.SelectedValue == "11")
        {
            var sb = new StringBuilder();
            sb.Append(" SELECT DATE,SUM(PaidAmount),PaymentMode,UserName,UserID,CentreName,CentreID,BatchNumber  FROM (");
            //Cash
            sb.Append("SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(ROUND((IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount)*IF(LTD.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4))PaidAmount,CONCAT(rec_pay.PaymentMode,' ',Rec_pay.S_Notation)PaymentMode,em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID,Rec.BatchNumber FROM f_reciept Rec ");
            sb.Append(" INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo   ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
            sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  ");
            sb.Append(" WHERE lt.PaymentModeID<>4 AND rec.LedgerNoDr NOT IN  ('HOSP0006','HOSP0005') and  LT.TypeOfTnx<>'OPD Advance/Settlements' and LT.TypeOfTnx IN (" + colType + ") AND rec.Iscancel=0 AND lt.IsCancel=0  and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") ");
            if (txtBatchnum.Text != null && txtBatchnum.Text != "")
            {
                sb.Append(" and Rec.BatchNumber='" + txtBatchnum.Text.Trim().ToString() + "' ");
            }
            sb.Append(" GROUP BY rec.CentreID,rec.Reciever,rec_pay.PaymentMode ");
            // Credit
            //sb.Append(" UNION ALL");

            //sb.Append(" SELECT DATE_FORMAT(lt.Date,'%d %b %Y')DATE,SUM(ROUND((lt_pay.S_Amount*IF(LTD.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4))PaidAmount,CONCAT(lt_pay.PaymentMode,' ',lt_pay.S_Notation)PaymentMode,em.Name UserName,lt.UserID,cm.CentreName,cm.CentreID,lt.BatchNumber  FROM f_ledgertransaction lt");
            //sb.Append(" INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo");
            //sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsVerified !=2 AND ltd.IsPackage=0 ");
            //sb.Append(" INNER JOIN employee_master em ON lt.UserID=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = lt.CentreID ");
            //sb.Append(" WHERE lt_pay.PaymentModeID=4 and LT.TypeOfTnx IN (" + colType + ") AND lt.IsCancel=0 and CONCAT(lt.Date,' ',lt.Time)>='" + startDate + "' AND CONCAT(lt.Date,' ',lt.Time)<='" + toDate + "'  AND lt_pay.Amount>0 and lt.userID in (" + user + ") AND lt.CentreID IN (" + Centre + ") ");
            //if (txtBatchnum.Text != null && txtBatchnum.Text != "")
            //{
            //    sb.Append(" and lt.BatchNumber='" + txtBatchnum.Text.Trim().ToString() + "' ");
            //}
            //sb.Append(" GROUP BY lt.CentreID,lt.UserID,lt_pay.PaymentMode ");
            if (Session["DeptLedgerNo"].ToString() == "LSHHI57" || Session["DeptLedgerNo"].ToString() == "LSHHI3889")
            {
                //'Sales','Patient-Return'
                sb.Append(" UNION ALL");

                sb.Append(" SELECT DATE_FORMAT(lt.Date,'%d %b %Y')DATE, SUM(((ltd.`Rate`*ltd.`Quantity`)-ltd.`DiscAmt`))PaidAmount,'Credit INR' PaymentMode,em.Name UserName,lt.UserID,cm.CentreName,cm.CentreID,lt.BatchNumber  FROM f_ledgertransaction lt ");
                //    SUM(ROUND((lt_pay.S_Amount*IF(LTD.TypeOfTnx IN('DR','CR'),0,ltd.NetItemAmt))/(NetAmount-LT.CreditNoteAmt-LT.DebitNoteAmt-lt.Roundoff),4))PaidAmount,CONCAT(lt_pay.PaymentMode,' ',lt_pay.S_Notation)PaymentMode,em.Name UserName,lt.UserID,cm.CentreName,cm.CentreID,lt.BatchNumber  FROM f_ledgertransaction lt");
                // sb.Append(" INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo");
                sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND ltd.IsVerified !=2 ");
                sb.Append(" INNER JOIN employee_master em ON lt.UserID=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = lt.CentreID ");
                sb.Append(" WHERE LT.TypeOfTnx IN ('Sales','Patient-Return') AND lt.IsCancel=0 and CONCAT(lt.Date,' ',lt.Time)>='" + startDate + "' AND CONCAT(lt.Date,' ',lt.Time)<='" + toDate + "'   and lt.userID in (" + user + ") AND lt.CentreID IN (" + Centre + ") ");
                if (txtBatchnum.Text != null && txtBatchnum.Text != "")
                {
                    sb.Append(" and lt.BatchNumber='" + txtBatchnum.Text.Trim().ToString() + "' ");
                }
                sb.Append(" GROUP BY lt.CentreID,lt.UserID ");
            }
            //for adjustment
            if (colType.Contains("OPD Advance/Settlements"))
            {
                sb.Append("  UNION ALL");
                sb.Append("  SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(rec_pay.S_Amount)PaidAmount,CONCAT(rec_pay.PaymentMode,' ',rec_pay.S_Notation)PaymentMode,em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID,rec.BatchNumber   ");
                
                sb.Append("  FROM f_reciept rec ");
                sb.Append("  inner join patient_master pm on pm.PatientID=rec.Depositor ");
                sb.Append("  inner join f_receipt_paymentdetail rec_pay on rec_pay.ReceiptNo=rec.ReceiptNo ");
                sb.Append("  inner join employee_master em on em.EmployeeID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
                sb.Append("  where rec.LedgerNoDr IN  ('HOSP0006','HOSP0005') AND rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' and rec.Reciever in (" + user + ")  AND rec.CentreID IN (" + Centre + ") ");
                if (txtBatchnum.Text != null && txtBatchnum.Text != "")
                {
                    sb.Append(" and rec.BatchNumber='" + txtBatchnum.Text.Trim().ToString() + "'  ");
                }
                sb.Append("  GROUP BY rec.CentreID,rec.Reciever,rec_pay.PaymentMode ");
            }
            //IPD advance
            if (colType.Contains("IPD"))
            {
                sb.Append(" UNION ALL");
                sb.Append(" SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(rec_pay.S_Amount)PaidAmount,CONCAT(rec_pay.PaymentMode,' ',Rec_pay.S_Notation)PaymentMode,em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID,Rec.BatchNumber  FROM f_reciept Rec");
                sb.Append(" INNER JOIN patient_medical_history adj ON adj.TransactionID=rec.TransactionID ");//
                sb.Append(" INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
                sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID");
                sb.Append(" WHERE rec.Iscancel=0 and CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' and rec.Reciever in (" + user + ") AND rec.CentreID IN (" + Centre + ") AND adj.Type='IPD' ");//
                if (txtBatchnum.Text != null && txtBatchnum.Text != "")
                {
                    sb.Append(" and Rec.BatchNumber='" + txtBatchnum.Text.Trim().ToString() + "' ");
                }
                sb.Append("GROUP BY rec.CentreID,rec.Reciever,rec_pay.PaymentMode");
            }
            //Mortuary Advance
            if (colType.Contains("Mortuary-Advance"))
            {
                sb.Append(" UNION ALL");
                sb.Append(" SELECT DATE_FORMAT(rec.Date,'%d %b %Y')DATE,SUM(rec_pay.S_Amount)PaidAmount,CONCAT(rec_pay.PaymentMode,' ',Rec_pay.S_Notation)PaymentMode,");
                sb.Append(" em.Name UserName,rec.Reciever UserID,cm.CentreName,cm.CentreID FROM mortuary_receipt Rec");
                sb.Append(" INNER JOIN mortuary_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
                sb.Append(" INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID  INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID");
                sb.Append(" WHERE rec.Iscancel=0 AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' ");
                sb.Append(" AND rec.Reciever IN (" + user + ") AND rec.CentreID IN (" + Centre + ")");
                sb.Append(" GROUP BY rec.Date,rec.CentreID,rec.Reciever,rec_pay.PaymentMode,rec_pay.S_Notation");
            }
            sb.Append(" )a GROUP BY CentreID,UserID,PaymentMode ");
            var dt1 = new DataTable();
            dt1 = StockReports.GetDataTable(sb.ToString());
            //System.IO.File.WriteAllText (@"F:\aa.txt", sb.ToString());
            if (dt1.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
                dt1.Columns.Add(dc);
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                DataSet ds = new DataSet();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables.Add(dt1.Copy());
                //ds.Tables.Add(dtSum.Copy());
                // ds.WriteXmlSchema(@"E:\\CollectionReportSummary.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "CollectionReportSummaryTotal";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

            }
            txtBatchnum.Text = "";
        }

        //GetCollectionData(startDate, toDate, user, colType);
        //  BindUser();
    }

    protected void btnDetail_Click(object sender, EventArgs e)
    {


        if (Session["LoginType"] == null)
        {
            return;
        }
        LoginRestrict LR = new LoginRestrict();
        if (!LR.LoginDateRestrict(Util.GetString(Session["RoleID"]), Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)), Util.GetString(Session["ID"])))
        {
            lblMsg.Text = LoginRestrict.LoginDateRestrictMSG();
            return;
        }


        string startDate = string.Empty, toDate = string.Empty, user, colType;

        if (Util.GetDateTime(ucFromDate.Text).ToString() != string.Empty)
            if (txtFromTime.Text.Trim() != string.Empty)
                startDate = Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd") + " " + txtFromTime.Text.Trim();
            else
                startDate = Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd");

        if (Util.GetDateTime(ucToDate.Text).ToString() != string.Empty)
            if (txtToTime.Text.Trim() != string.Empty)
                toDate = Util.GetDateTime(Util.GetDateTime(ucToDate.Text)).ToString("yyyy-MM-dd") + " " + txtToTime.Text.Trim();
            else
                toDate = Util.GetDateTime(Util.GetDateTime(ucToDate.Text)).ToString("yyyy-MM-dd");

        user = GetSelection(cblUser);
        colType = GetSelection(cblColType);

        //GetCollectionData(startDate, toDate, user, colType);

        //BindUser();
    }


}
