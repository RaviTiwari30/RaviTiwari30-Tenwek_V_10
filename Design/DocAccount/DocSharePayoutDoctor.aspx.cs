using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_DocAccount_DocSharePayoutDoctor : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
           // ucFromDate.Text = ucToDate.Text = "01-Feb-2021";
            CalendarExtender1.EndDate = CalendarExtender2.EndDate = System.DateTime.Now;
            BindDoctor();
        }
        ucFromDate.Attributes.Add("readonly", "true");
        ucToDate.Attributes.Add("readonly", "true");
        lblMsg.Text = "";
    }

    private void BindDoctor()
    {
        DataTable dt = StockReports.GetDataTable("Select Name,DoctorID from Doctor_master /*where IsActive=1*/ order by name");
        ddlDoctor.DataSource = dt;
        ddlDoctor.DataTextField = "Name";
        ddlDoctor.DataValueField = "DoctorID";
        ddlDoctor.DataBind();

        ddlDoctor.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlDoctor.SelectedIndex = 0;
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (!chkdoctorwise.Checked)
        {
            if (ddlDoctor.SelectedIndex == 0)
            {
                lblMsg.Text = "Kindly Select Doctor...";
                ddlDoctor.Focus();
                return;
            }
        }
        StringBuilder sb = new StringBuilder();

        if (rdbtran.SelectedValue == "1") //BillDate
        {
            if (rbtReportType.SelectedValue == "D") // Detail
            {
                sb.Append("SELECT iType,IF(iType='OPD','',REPLACE(TransactionID,'ISHHI',''))IPD_No,REPLACE(PatientID,'LSHHI','')MR_No, ");
                sb.Append("(SELECT Company_name FROM f_panel_master WHERE PanelID=t.PanelID)Panel, ");
                sb.Append("(SELECT pname FROM patient_master WHERE PatientID=t.PatientID)PatientName,BillNo,DATE,ROUND(NetAmount)NetBillAmount, ");
                sb.Append("ROUND(IFNULL((SELECT SUM(amountpaid) FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0 AND DATE(DATE)<=t.Date),0))Collected_Till_BillDate, ");
                sb.Append("ROUND(IFNULL((SELECT SUM(amountpaid) FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0 AND DATE(DATE)<='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd") + "'),0))Collected_Till_CurrentDate, ");
                sb.Append("sc.Name Category,(CASE WHEN ConfigID=5 THEN 'OPD-Consultation' WHEN ConfigID=25 THEN 'Minor-Procedures'  ");
                sb.Append("WHEN ConfigID=1 THEN 'IPD-Visit' WHEN ConfigID=22 THEN 'IPD-Surgery' ELSE '' END)TransactionType,ItemName,Rate ItemRate,Quantity, ");
                sb.Append("ROUND(DiscAmt)DiscAmt,ROUND(ItemNetAmt)ItemNetAmt,IF(IsPackage=0,'NO','YES')Within_Package, ");
                sb.Append("ROUND(OPD_Consultation)OPD_Consultation,ROUND(OPD_Procedure)OPD_Procedure, ");
                sb.Append("ROUND(IPD_Visit)IPD_Visit,ROUND(IPD_Surgery)IPD_Surgery FROM ( ");

                if (rbtOPDIPD.SelectedValue == "OPD" || rbtOPDIPD.SelectedValue == "ALL")
                {

                    sb.Append("     SELECT 'OPD' iType,ltd.TransactionID,lt.BillNo,lt.Date,lt.PatientID,SUM(ltd.Amount)NetAmount,ltd.ItemName,ltd.Rate,ltd.Quantity, ");
                    sb.Append("     (ltd.TotalDiscAmt)DiscAmt,SUM(ltd.amount) ItemNetAmt,      IF(ltd.DoctorID='' OR ltd.DoctorID IS NULL,(SELECT DoctorID FROM patient_medical_history       WHERE TransactionID=ltd.TransactionID),ltd.DoctorID)DoctorID, ");
                    sb.Append("     IF(ltd.ConfigID=5,SUM(ltd.amount),0)OPD_Consultation,IF(ltd.ConfigID=25,SUM(ltd.amount),0)OPD_Procedure,      0 AS IPD_Visit,0 AS IPD_Surgery, ");
                    sb.Append("     ltd.ConfigID,lt.PanelID,ltd.subcategoryID,ltd.IsPackage ");
                    sb.Append("     FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo	 ");
                    sb.Append("     WHERE lt.IsCancel=0 AND lt.TypeOfTnx IN ('opd-appointment','opd-procedure','casualty-billing','opd-billing','opd-other') AND lt.NetAmount>=0 ");
                    sb.Append("     AND ltd.ConfigID IN (5,25) AND DATE(lt.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' GROUP BY lt.LedgertransactionNo ");
                }

                if (rbtOPDIPD.SelectedValue == "IPD" || rbtOPDIPD.SelectedValue == "ALL")
                {
                    if (rbtOPDIPD.SelectedValue == "ALL")
                        sb.Append(" UNION ALL ");

                    sb.Append("     SELECT  'IPD' iType,TransactionID,BillNo,BillDate DATE,PatientID,NetBillAmt AS NetAmount,ItemName,Rate,Quantity, ");
                    sb.Append("     ((Rate*Quantity)-(IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt)))DiscAmt, ");
                    sb.Append("  	IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt)ItemNetAmt,DoctorID, ");
                    sb.Append("     0 AS OPD_Consultation, ");
                    sb.Append("     IF(ConfigID=25,IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt),0)OPD_Procedure, ");
                    sb.Append("     IF(ConfigID=1,IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt),0)IPD_Visit, ");
                    sb.Append("     IF(ConfigID=22,IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt),0)IPD_Surgery, ");
                    sb.Append("     ConfigID,PanelID,subcategoryID,IsPackage FROM (  ");
                    sb.Append("             SELECT t2.TransactionID,t2.BillNo,t2.NetBillAmt,t2.MedAmt,t2.DiscountOnBill, ");
                    sb.Append("             (CASE WHEN ltd.ConfigID in (1,25) THEN ltd.DoctorID WHEN ltd.ConfigID =22 THEN IFNULL((SELECT DoctorID FROM f_surgery_doctor sd  ");
                    sb.Append("             INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID  ");
                    sb.Append("             AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                    sb.Append("             AND sds.ItemID = ltd.ItemID),(SELECT DoctorID FROM Patient_Medical_History WHERE TransactionID=ltd.TransactionID  ");
                    sb.Append("             LIMIT 1)) ELSE '' END )DoctorID, ((t2.DiscountOnBill/t2.NetBillAmt)*100)TotalDisc,ltd.IsPackage,  ");
                    sb.Append("             IF(ltd.Ispackage=1,Rate*Quantity,Amount)ItemNetAmt,ltd.ItemName,billDate,t2.PatientID,ConfigID, ");
                    sb.Append("             ltd.Quantity,ltd.Rate,PanelID,ltd.subcategoryID FROM (  ");
                    sb.Append("                     SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0  ");
                    sb.Append("                     AND TransactionID=adj.TransactionID),0)NetBillAmt,  ");
                    sb.Append("                     IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON  ");
                    sb.Append("                     ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=0  ");
                    sb.Append("                     AND ltd.TransactionID=adj.TransactionID AND UCASE(sc.DisplayName)='MEDICINE & CONSUMABLES'),0)MedAmt,  ");
                    sb.Append("                     IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,adj.billDate,adj.PatientID, ");
                    sb.Append("                     adj.TransactionID,adj.panelID PanelID FROM Patient_MEdical_History adj  ");
                    sb.Append("                     WHERE  (adj.billNo IS NOT NULL OR adj.billNo <>'') ");
                    sb.Append("                     AND DATE(adj.billDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.billDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");
                    sb.Append("  	        )t2 INNER JOIN f_ledgertnxdetail ltd ON t2.TransactionID= ltd.TransactionID          ");
                    sb.Append("             WHERE ltd.IsVerified=1 AND ltd.ConfigID in (1,25) ");
                    sb.Append("             Union All ");
                    sb.Append("             SELECT t2.TransactionID,t2.BillNo,t2.NetBillAmt,t2.MedAmt,t2.DiscountOnBill, ");
                    sb.Append("             (CASE WHEN ltd.ConfigID in (1,25) THEN ltd.DoctorID WHEN ltd.ConfigID =22 THEN IFNULL((SELECT DoctorID FROM f_surgery_doctor sd  ");
                    sb.Append("             INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID  ");
                    sb.Append("             AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                    sb.Append("             AND sds.ItemID = ltd.ItemID),(SELECT DoctorID FROM Patient_Medical_History WHERE TransactionID=ltd.TransactionID  ");
                    sb.Append("             LIMIT 1)) ELSE '' END )DoctorID, ((t2.DiscountOnBill/t2.NetBillAmt)*100)TotalDisc,ltd.IsPackage,  ");
                    sb.Append("             IF(ltd.Ispackage=1,ltd.Rate*ltd.Quantity,ltd.Amount)ItemNetAmt,ltd.ItemName,billDate,t2.PatientID,ConfigID, ");
                    sb.Append("             ltd.Quantity,ltd.Rate,PanelID,ltd.subcategoryID FROM (  ");
                    sb.Append("                     SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0  ");
                    sb.Append("                     AND TransactionID=adj.TransactionID),0)NetBillAmt,  ");
                    sb.Append("                     IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON  ");
                    sb.Append("                     ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=0  ");
                    sb.Append("                     AND ltd.TransactionID=adj.TransactionID AND UCASE(sc.DisplayName)='MEDICINE & CONSUMABLES'),0)MedAmt,  ");
                    sb.Append("                     IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,adj.billDate,adj.PatientID, ");
                    sb.Append("                     adj.TransactionID,adj.panelID PanelID FROM Patient_MEdical_History adj  ");
                    sb.Append("                     WHERE  (adj.billNo IS NOT NULL OR adj.billNo <>'') ");
                    sb.Append("                     AND DATE(adj.billDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.billDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");
                    sb.Append("  	        )t2 INNER JOIN f_ledgertnxdetail ltd ON t2.TransactionID= ltd.TransactionID          ");
                    sb.Append("             INNER JOIN f_surgery_discription sd ON sd.LedgerTransactionNo = ltd.LedgerTransactionNo AND sd.ItemID = ltd.ItemID ");
                    sb.Append("             INNER JOIN f_surgery_doctor sdoc ON sd.SurgeryTransactionID = sdoc.SurgeryTransactionID AND sd.ItemID = sdoc.ItemID ");
                    sb.Append("             WHERE ltd.IsVerified=1 AND ltd.ConfigID =22  ");
                    sb.Append("     )t3  ");
                }
                sb.Append(")t INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = t.subcategoryID ");
                sb.Append("WHERE DoctorID='" + ddlDoctor.SelectedValue + "' ");
            }

            else // Summary
            {

                if (chkdoctorwise.Checked) // All Doctor 
                {

                    sb.Append("  SELECT iType,IF(iType='OPD','',REPLACE(TransactionID,'ISHHI',''))IPD_No, ");
                    sb.Append("   '' MR_No, '' Panel, '' PatientName, '' BillNo,DATE, ");
                    sb.Append("  SUM(ROUND(NetAmount))NetBillAmount, ");
                    sb.Append("  SUM( ROUND(IFNULL((SELECT SUM(amountpaid) FROM f_reciept WHERE TransactionID=t.TransactionID ");
                    sb.Append("   AND IsCancel=0 AND DATE(DATE)<=t.Date),0)))Collected_Till_BillDate, ");
                    sb.Append("  SUM( ROUND(IFNULL((SELECT SUM(amountpaid) FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0  ");
                    sb.Append("    AND DATE(DATE)<='2015-1-15'),0)))Collected_Till_CurrentDate, ");
                    sb.Append("    sc.Name Category,(CASE WHEN ConfigID=5 THEN 'OPD-Consultation' ");
                    sb.Append("   WHEN ConfigID=25 THEN 'Minor-Procedures'  WHEN ConfigID=1 THEN 'IPD-Visit'  ");
                    sb.Append("    WHEN ConfigID=22 THEN 'IPD-Surgery' ELSE '' END)TransactionType,  ");
                    sb.Append("   ItemName,SUM(Rate) ItemRate,SUM(Quantity)Quantity,SUM(ROUND(DiscAmt))DiscAmt,SUM(ROUND(ItemNetAmt))ItemNetAmt, ");
                    sb.Append("   IF(IsPackage=0,'NO','YES')Within_Package, SUM(ROUND(OPD_Consultation))OPD_Consultation, ");
                    sb.Append("   SUM(ROUND(OPD_Procedure))OPD_Procedure,SUM(ROUND(IPD_Visit))IPD_Visit,SUM(ROUND(IPD_Surgery))IPD_Surgery , Doctorname  FROM (  ");



                    if (rbtOPDIPD.SelectedValue == "OPD" || rbtOPDIPD.SelectedValue == "ALL")
                    {
                        //sb.Append("     SELECT 'OPD' iType,ltd.TransactionID,lt.BillNo,lt.Date,lt.PatientID,lt.NetAmount,ltd.ItemName,ltd.Rate,ltd.Quantity, ");
                        //sb.Append("     ((ltd.Rate*ltd.Quantity)-ltd.amount)DiscAmt,ltd.amount ItemNetAmt, ");
                        //sb.Append("     IF(ltd.DoctorID='' OR ltd.DoctorID IS NULL,(SELECT DoctorID FROM patient_medical_history  ");
                        //sb.Append("     WHERE TransactionID=ltd.TransactionID),ltd.DoctorID)DoctorID, ");
                        //sb.Append("     IF(ltd.ConfigID=5,ltd.amount,0)OPD_Consultation,IF(ltd.ConfigID=25,ltd.amount,0)OPD_Procedure, ");
                        //sb.Append("     0 AS IPD_Visit,0 AS IPD_Surgery,ltd.ConfigID,lt.PanelID,ltd.subcategoryID,ltd.IsPackage  ");

                        //sb.Append("        ,IF(ltd.DoctorID='' OR ltd.DoctorID IS NULL,(SELECT (SELECT NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)   FROM patient_medical_history pmh    ");
                        //sb.Append("        WHERE pmh.TransactionID=ltd.TransactionID ), (SELECT NAME FROM doctor_master WHERE DoctorID=ltd.DoctorID ))Doctorname    ");

                        //sb.Append("     FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo	 ");
                        //sb.Append("     WHERE lt.IsCancel=0 AND lt.TypeOfTnx IN ('opd-appointment','opd-procedure','casualty-billing') ");
                        //sb.Append("     AND ltd.ConfigID IN (5,25) AND DATE(lt.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");

                   
                        sb.Append("SELECT 'OPD' iType,ltd.TransactionID,lt.BillNo,lt.Date,lt.PatientID,SUM(ltd.Amount)NetAmount,ltd.ItemName,ltd.Rate,ltd.Quantity, ");
                        sb.Append("SUM(ltd.TotalDiscAmt)DiscAmt,SUM(ltd.amount )ItemNetAmt,       ");
                        sb.Append("IF(ltd.DoctorID='' OR ltd.DoctorID IS NULL,(SELECT DoctorID FROM patient_medical_history WHERE TransactionID=ltd.TransactionID),ltd.DoctorID)DoctorID, ");
                        sb.Append("IF(ltd.ConfigID=5,SUM(ltd.amount),0)OPD_Consultation,IF(ltd.ConfigID=25,SUM(ltd.amount),0)OPD_Procedure,      0 AS IPD_Visit,0 AS IPD_Surgery, ");
                        sb.Append("ltd.ConfigID,lt.PanelID,ltd.subcategoryID,ltd.IsPackage          , ");
                        sb.Append("IF(ltd.DoctorID='' OR ltd.DoctorID IS NULL,(SELECT (SELECT NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID) FROM patient_medical_history pmh ");
                        sb.Append("WHERE pmh.TransactionID=ltd.TransactionID ), (SELECT NAME FROM doctor_master WHERE DoctorID=ltd.DoctorID ))Doctorname ");
                        sb.Append("FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo ");
                        sb.Append("WHERE lt.IsCancel=0 AND ltd.TypeOfTnx IN('OPD-APPOINTMENT','OPD-PROCEDURE','CASUALTY-BILLING','opd-billing','opd-other') ");
                        sb.Append("AND  ltd.ConfigID IN (5,25) AND DATE(lt.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' AND lt.NetAmount>=0 ");
                        sb.Append("GROUP BY lt.LedgertransactionNo ");



                    }
                    if (rbtOPDIPD.SelectedValue == "IPD" || rbtOPDIPD.SelectedValue == "ALL")
                    {
                        if (rbtOPDIPD.SelectedValue == "ALL")
                            sb.Append(" UNION ALL ");

                        sb.Append("     SELECT  'IPD' iType,TransactionID,BillNo,BillDate DATE,PatientID,NetBillAmt AS NetAmount,ItemName,Rate,Quantity, ");
                        sb.Append("     ((Rate*Quantity)-(IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt)))DiscAmt, ");
                        sb.Append("  	IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt)ItemNetAmt,DoctorID, ");
                        sb.Append("     0 AS OPD_Consultation, ");
                        sb.Append("     IF(ConfigID=25,IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt),0)OPD_Procedure, ");
                        sb.Append("     IF(ConfigID=1,IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt),0)IPD_Visit, ");
                        sb.Append("     IF(ConfigID=22,IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt),0)IPD_Surgery, ");
                        sb.Append("     ConfigID,PanelID,subcategoryID,IsPackage,Doctorname FROM (  ");
                        sb.Append("             SELECT t2.TransactionID,t2.BillNo,t2.NetBillAmt,t2.MedAmt,t2.DiscountOnBill, ");
                        sb.Append("             (CASE WHEN ltd.ConfigID in (1,25) THEN ltd.DoctorID WHEN ltd.ConfigID =22 THEN IFNULL((SELECT DoctorID FROM f_surgery_doctor sd  ");
                        sb.Append("             INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID  ");
                        sb.Append("             AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                        sb.Append("             AND sds.ItemID = ltd.ItemID),(SELECT DoctorID FROM Patient_Medical_History WHERE TransactionID=ltd.TransactionID  ");
                        sb.Append("             LIMIT 1)) ELSE '' END )DoctorID, ((t2.DiscountOnBill/t2.NetBillAmt)*100)TotalDisc,ltd.IsPackage,  ");
                        sb.Append("             IF(ltd.Ispackage=1,Rate*Quantity,Amount)ItemNetAmt,ltd.ItemName,billDate,t2.PatientID,ConfigID, ");
                        sb.Append("             ltd.Quantity,ltd.Rate,PanelID,ltd.subcategoryID ,");





                        sb.Append("           (CASE WHEN ltd.`ConfigID` IN (1,25) THEN (SELECT NAME FROM doctor_master WHERE DoctorID=ltd.`DoctorID` ) ");
                        sb.Append("            WHEN ltd.`ConfigID`=22 THEN IFNULL(  ((SELECT (SELECT NAME FROM doctor_master WHERE DoctorID=`DoctorID`)DoctorID  ");
                        sb.Append("            FROM f_surgery_doctor sd   INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID  ");
                        sb.Append("            AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                        sb.Append("             AND sds.ItemID = ltd.ItemID)),(SELECT (SELECT NAME FROM doctor_master WHERE DoctorID=DoctorID)doctorname FROM Patient_Medical_History  ");
                        sb.Append("            WHERE TransactionID=ltd.TransactionID               LIMIT 1))  ");
                        sb.Append("            ELSE '' END  ) ");
                        sb.Append("         doctorname   ");


                        sb.Append("   FROM (  ");
                        sb.Append("                     SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0  ");
                        sb.Append("                     AND TransactionID=adj.TransactionID),0)NetBillAmt,  ");
                        sb.Append("                     IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON  ");
                        sb.Append("                     ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=0  ");
                        sb.Append("                     AND ltd.TransactionID=adj.TransactionID AND UCASE(sc.DisplayName)='MEDICINE & CONSUMABLES'),0)MedAmt,  ");
                        sb.Append("                     IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,adj.billDate,adj.PatientID, ");
                        sb.Append("                     adj.TransactionID,adj.panelID PanelID FROM Patient_MEdical_History adj  ");
                        sb.Append("                     WHERE  (adj.billNo IS NOT NULL OR adj.billNo <>'') ");
                        sb.Append("                     AND DATE(adj.billDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.billDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");
                        sb.Append("             )t2 INNER JOIN f_ledgertnxdetail ltd ON t2.TransactionID= ltd.TransactionID          ");
                        sb.Append("             WHERE ltd.IsVerified=1 AND ltd.ConfigID in (1,25)  ");
                        sb.Append("             Union All ");
                        sb.Append("             SELECT t2.TransactionID,t2.BillNo,t2.NetBillAmt,t2.MedAmt,t2.DiscountOnBill, ");
                        sb.Append("             (CASE WHEN ltd.ConfigID in (1,25) THEN ltd.DoctorID WHEN ltd.ConfigID =22 THEN IFNULL((SELECT DoctorID FROM f_surgery_doctor sd  ");
                        sb.Append("             INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID  ");
                        sb.Append("             AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                        sb.Append("             AND sds.ItemID = ltd.ItemID),(SELECT DoctorID FROM Patient_Medical_History WHERE TransactionID=ltd.TransactionID  ");
                        sb.Append("             LIMIT 1)) ELSE '' END )DoctorID, ((t2.DiscountOnBill/t2.NetBillAmt)*100)TotalDisc,ltd.IsPackage,  ");
                        sb.Append("             IF(ltd.Ispackage=1,ltd.Rate*ltd.Quantity,ltd.Amount)ItemNetAmt,ltd.ItemName,billDate,t2.PatientID,ConfigID, ");
                        sb.Append("             ltd.Quantity,ltd.Rate,PanelID,ltd.subcategoryID, ");


                        sb.Append("    (SELECT CONCAT('Dr.',NAME ) Doctorname FROM doctor_master dm WHERE dm.DoctorID=DoctorID LIMIT 1) doctorname  ");

                        sb.Append("      FROM (  ");
                        sb.Append("                     SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0  ");
                        sb.Append("                     AND TransactionID=adj.TransactionID),0)NetBillAmt,  ");
                        sb.Append("                     IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON  ");
                        sb.Append("                     ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=0  ");
                        sb.Append("                     AND ltd.TransactionID=adj.TransactionID AND UCASE(sc.DisplayName)='MEDICINE & CONSUMABLES'),0)MedAmt,  ");
                        sb.Append("                     IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,adj.billDate,adj.PatientID, ");
                        sb.Append("                     adj.TransactionID,adj.panelID PanelID FROM Patient_MEdical_History adj  ");
                        sb.Append("                     WHERE  (adj.billNo IS NOT NULL OR adj.billNo <>'') ");
                        sb.Append("                     AND DATE(adj.billDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.billDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");
                        sb.Append("  	         )t2 INNER JOIN f_ledgertnxdetail ltd ON t2.TransactionID= ltd.TransactionID          ");
                        sb.Append("              INNER JOIN f_surgery_discription sd ON sd.LedgerTransactionNo = ltd.LedgerTransactionNo AND sd.ItemID = ltd.ItemID ");
                        sb.Append("              INNER JOIN f_surgery_doctor sdoc ON sd.SurgeryTransactionID = sdoc.SurgeryTransactionID AND sd.ItemID = sdoc.ItemID ");
                        sb.Append("              WHERE ltd.IsVerified=1 AND ltd.ConfigID =22  ");
                        sb.Append("      )t3  ");
                    }

                    sb.Append(")t INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = t.subcategoryID ");

                    if (ddlDoctor.SelectedItem.Value.ToString() == "ALL")
                    {
                        sb.Append(" WHERE DoctorID in (SELECT DoctorID FROM doctor_master   ) ");
                    }
                    else
                    {

                        sb.Append(" WHERE DoctorID = '" + ddlDoctor.SelectedValue + "' ");

                    }
                    sb.Append(" GROUP BY DoctorID ");







                }
                else // Doctor is Selected
                {
                    sb.Append("SELECT iType,IF(iType='OPD','',REPLACE(TransactionID,'ISHHI',''))IPD_No, ");
                    sb.Append("REPLACE(PatientID,'LSHHI','')MR_No, ");
                    sb.Append("(SELECT Company_name FROM f_panel_master WHERE PanelID=t.PanelID)Panel, ");
                    sb.Append("(SELECT pname FROM patient_master WHERE PatientID=t.PatientID)PatientName, ");
                    sb.Append("BillNo,DATE,ROUND(NetAmount)NetBillAmount, ");
                    sb.Append("ROUND(IFNULL((SELECT SUM(amountpaid) FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0 AND DATE(DATE)<=t.Date),0))Collected_Till_BillDate, ");
                    sb.Append(" SUM(NetPackageAmt) Collected_Till_CurrentDate, ");
                    sb.Append("sc.Name Category,(CASE WHEN ConfigID=5 THEN 'OPD-Consultation' WHEN ConfigID=25 THEN 'Minor-Procedures'  ");
                    sb.Append("WHEN ConfigID=1 THEN 'IPD-Visit' WHEN ConfigID=22 THEN 'IPD-Surgery' ELSE '' END)TransactionType, ");
                    sb.Append("ItemName,SUM(Rate) ItemRate,SUM(Quantity)Quantity,SUM(ROUND(DiscAmt))DiscAmt,SUM(ROUND(ItemNetAmt))ItemNetAmt,IF(IsPackage=0,'NO','YES')Within_Package, ");
                    sb.Append("SUM(ROUND(OPD_Consultation))OPD_Consultation,SUM(ROUND(OPD_Procedure))OPD_Procedure,SUM(ROUND(IPD_Visit))IPD_Visit,SUM(ROUND(IPD_Surgery))IPD_Surgery FROM (  ");

                    if (rbtOPDIPD.SelectedValue == "OPD" || rbtOPDIPD.SelectedValue == "ALL")
                    {
                        sb.Append("SELECT 'OPD' iType,ltd.TransactionID,lt.BillNo,lt.Date,lt.PatientID,SUM(ltd.Amount)NetAmount,ltd.ItemName,ltd.Rate,ltd.Quantity, ");
                        sb.Append("sum(ltd.TotalDiscAmt)DiscAmt,SUM(ltd.amount) ItemNetAmt,      IF(ltd.DoctorID='' OR ltd.DoctorID IS NULL,(SELECT DoctorID FROM patient_medical_history       WHERE TransactionID=ltd.TransactionID),ltd.DoctorID)DoctorID, ");
                        sb.Append("IF(ltd.ConfigID=5,SUM(ltd.amount),0)OPD_Consultation,IF(ltd.ConfigID=25,SUM(ltd.amount),0)OPD_Procedure,      0 AS IPD_Visit,0 AS IPD_Surgery, ");
                        sb.Append("ltd.ConfigID,lt.PanelID,ltd.subcategoryID,ltd.IsPackage,0 NetPackageAmt ");
                        sb.Append("     FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo	 ");
                        sb.Append("     WHERE lt.IsCancel=0 AND ltd.TypeOfTnx IN ('opd-appointment','opd-procedure','casualty-billing','opd-billing','opd-other') AND lt.NetAmount>=0 ");
                        sb.Append("     AND ltd.ConfigID IN (5,25) AND DATE(lt.Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  GROUP BY lt.LedgertransactionNo");

                    }
                    if (rbtOPDIPD.SelectedValue == "IPD" || rbtOPDIPD.SelectedValue == "ALL")
                    {
                        if (rbtOPDIPD.SelectedValue == "ALL")
                            sb.Append(" UNION ALL ");

                        sb.Append("     SELECT  'IPD' iType,TransactionID,BillNo,BillDate DATE,PatientID,NetBillAmt AS NetAmount,ItemName,Rate,Quantity, ");
                        sb.Append("     ((Rate*Quantity)-(IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt)))DiscAmt, ");
                        sb.Append("  	IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt)ItemNetAmt,DoctorID, ");
                        sb.Append("     0 AS OPD_Consultation, ");
                        sb.Append("     IF(ConfigID=25,IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt),0)OPD_Procedure, ");
                        sb.Append("     IF(ConfigID=1,IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt),0)IPD_Visit, ");
                        sb.Append("     IF(ConfigID=22,IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt),0)IPD_Surgery, ");
                        sb.Append("     ConfigID,PanelID,subcategoryID,IsPackage,0 NetPackageAmt FROM (  ");
                        sb.Append("             SELECT t2.TransactionID,t2.BillNo,t2.NetBillAmt,t2.MedAmt,t2.DiscountOnBill, ");
                        sb.Append("             (CASE WHEN ltd.ConfigID in (1,25) THEN ltd.DoctorID WHEN ltd.ConfigID =22 THEN IFNULL((SELECT DoctorID FROM f_surgery_doctor sd  ");
                        sb.Append("             INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID  ");
                        sb.Append("             AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                        sb.Append("             AND sds.ItemID = ltd.ItemID),(SELECT DoctorID FROM Patient_Medical_History WHERE TransactionID=ltd.TransactionID  ");
                        sb.Append("             LIMIT 1)) ELSE '' END )DoctorID, ((t2.DiscountOnBill/t2.NetBillAmt)*100)TotalDisc,ltd.IsPackage,  ");
                        sb.Append("             IF(ltd.Ispackage=1,Rate*Quantity,Amount)ItemNetAmt,ltd.ItemName,billDate,t2.PatientID,ConfigID, ");
                        sb.Append("             ltd.Quantity,ltd.Rate,PanelID,ltd.subcategoryID,0 NetPackageAmt FROM (  ");
                        sb.Append("                     SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0  ");
                        sb.Append("                     AND TransactionID=adj.TransactionID),0)NetBillAmt,  ");
                        sb.Append("                     IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON  ");
                        sb.Append("                     ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=0  ");
                        sb.Append("                     AND ltd.TransactionID=adj.TransactionID AND UCASE(sc.DisplayName)='MEDICINE & CONSUMABLES'),0)MedAmt,  ");
                        sb.Append("                     IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,adj.billDate,adj.PatientID, ");
                        sb.Append("                     adj.TransactionID,adj.panelID PanelID FROM Patient_MEdical_History adj  ");
                        sb.Append("                     WHERE  (adj.billNo IS NOT NULL OR adj.billNo <>'') ");
                        sb.Append("                     AND DATE(adj.billDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.billDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");
                        sb.Append("             )t2 INNER JOIN f_ledgertnxdetail ltd ON t2.TransactionID= ltd.TransactionID          ");
                        sb.Append("             WHERE ltd.IsVerified=1 AND ltd.ConfigID in (1,25)  ");
                        sb.Append("             Union All ");
                        //ekata
                        sb.Append("    SELECT t6.TransactionID,t6.BillNo,t6.NetBillAmt,t6.MedAmt,t6.DiscountOnBill,      ");
                        sb.Append("   (CASE WHEN ltd.ConfigID IN (1,25) THEN ltd.DoctorID WHEN ltd.ConfigID =22 THEN IFNULL((SELECT DoctorID FROM f_surgery_doctor sd      ");
                        sb.Append("   INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID             ");
                        sb.Append("   AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo          ");
                        sb.Append("   AND sds.ItemID = ltd.ItemID),(SELECT DoctorID FROM Patient_Medical_History WHERE TransactionID=ltd.TransactionID               LIMIT 1)) ELSE '' END )DoctorID, ((t6.DiscountOnBill/t6.NetBillAmt)*100)TotalDisc,ltd.IsPackage,      ");
                        sb.Append("    IF(ltd.Ispackage=1,Rate*Quantity,Amount)ItemNetAmt,ltd.ItemName,billDate,t6.PatientID,ConfigID,         ");
                        sb.Append("   ltd.Quantity,ltd.Rate,PanelID,ltd.subcategoryID,NetPackageAmt ");
                        sb.Append("   FROM (  ");
                        sb.Append("   SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=1   ");
                        sb.Append("   AND TransactionID=adj.TransactionID),0)NetBillAmt,                    ");
                        sb.Append(" IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON  ");
                        sb.Append(" ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=1     ");
                        sb.Append("  AND ltd.TransactionID=adj.TransactionID AND UCASE(sc.DisplayName)='MEDICINE & CONSUMABLES'),0)MedAmt, ");
                        sb.Append("  IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,adj.billDate,adj.PatientID,     ");
                        sb.Append("  adj.TransactionID,adj.panelID PanelID, IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0      ");
                        sb.Append("  AND TransactionID=adj.TransactionID),0)NetPackageAmt   ");
                        sb.Append("   FROM Patient_MEdical_History adj      ");
                        sb.Append("  WHERE  (adj.billNo IS NOT NULL OR adj.billNo <>'')    ");
                        sb.Append(" AND DATE(adj.billDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.billDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'     ");
                        sb.Append(" )t6 INNER JOIN f_ledgertnxdetail ltd ON t6.TransactionID= ltd.TransactionID  ");
                        sb.Append(" WHERE ltd.IsVerified=1 AND ltd.ConfigID IN (14)");
                        sb.Append("                                 Union All ");
                        //

                        sb.Append("             SELECT t2.TransactionID,t2.BillNo,t2.NetBillAmt,t2.MedAmt,t2.DiscountOnBill, ");
                        sb.Append("             (CASE WHEN ltd.ConfigID in (1,25) THEN ltd.DoctorID WHEN ltd.ConfigID =22 THEN IFNULL((SELECT DoctorID FROM f_surgery_doctor sd  ");
                        sb.Append("             INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID  ");
                        sb.Append("             AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
                        sb.Append("             AND sds.ItemID = ltd.ItemID),(SELECT DoctorID FROM Patient_Medical_History WHERE TransactionID=ltd.TransactionID  ");
                        sb.Append("             LIMIT 1)) ELSE '' END )DoctorID, ((t2.DiscountOnBill/t2.NetBillAmt)*100)TotalDisc,ltd.IsPackage,  ");
                        sb.Append("             IF(ltd.Ispackage=1,ltd.Rate*ltd.Quantity,ltd.Amount)ItemNetAmt,ltd.ItemName,billDate,t2.PatientID,ConfigID, ");
                        sb.Append("             ltd.Quantity,ltd.Rate,PanelID,ltd.subcategoryID,0 NetPackageAmt FROM (  ");
                        sb.Append("                     SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0  ");
                        sb.Append("                     AND TransactionID=adj.TransactionID),0)NetBillAmt,  ");
                        sb.Append("                     IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON  ");
                        sb.Append("                     ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=0  ");
                        sb.Append("                     AND ltd.TransactionID=adj.TransactionID AND UCASE(sc.DisplayName)='MEDICINE & CONSUMABLES'),0)MedAmt,  ");
                        sb.Append("                     IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,adj.billDate,adj.PatientID, ");
                        sb.Append("                     adj.TransactionID,adj.panelID PanelID FROM Patient_MEdical_History adj  ");
                        sb.Append("                     WHERE  (adj.billNo IS NOT NULL OR adj.billNo <>'') ");
                        sb.Append("                     AND DATE(adj.billDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.billDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");
                        sb.Append("  	         )t2 INNER JOIN f_ledgertnxdetail ltd ON t2.TransactionID= ltd.TransactionID          ");
                        sb.Append("              INNER JOIN f_surgery_discription sd ON sd.LedgerTransactionNo = ltd.LedgerTransactionNo AND sd.ItemID = ltd.ItemID ");
                        sb.Append("              INNER JOIN f_surgery_doctor sdoc ON sd.SurgeryTransactionID = sdoc.SurgeryTransactionID AND sd.ItemID = sdoc.ItemID ");
                        sb.Append("              WHERE ltd.IsVerified=1 AND ltd.ConfigID =22  ");

                        sb.Append("      )t3  ");
                    }

                    sb.Append(")t INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = t.subcategoryID ");
                    sb.Append(" WHERE DoctorID='" + ddlDoctor.SelectedValue + "' ");

                    sb.Append(" GROUP BY TransactionID ");
                }
            }
        }
        else // ReceiptDate Detail
        {
            if (rbtReportType.SelectedValue == "D")
            {
                sb.Append("   SELECT iType,IF(iType='OPD','',REPLACE(TransactionID,'ISHHI',''))IPD_No,MR_No, ");
                sb.Append("   Company_Name Panel,PatientName,BillNo,BillDate DATE,ROUND(TotalBilledAmt)NetBillAmount, ");
                sb.Append("   IFNULL((SELECT DATE_FORMAT(MAX(DATE),'%d-%b-%Y') FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0),'')Settlement_Date, ");
                sb.Append("                       ROUND(IFNULL((SELECT SUM(amountpaid) FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0 AND DATE(DATE)<='2013-04-10'),0))Collected_Till_CurrentDate, ");
                sb.Append("   (SELECT NAME FROM f_subcategorymaster WHERE subcategoryid=t.subcategoryID)Category, ");
                sb.Append("   (CASE WHEN ConfigID=5 THEN 'OPD-Consultation' WHEN ConfigID=25 THEN 'Minor-Procedures'  ");
                sb.Append("   WHEN ConfigID=1 THEN 'IPD-Visit' WHEN ConfigID=22 THEN 'IPD-Surgery' ELSE '' END)TransactionType,ItemName,Rate ItemRate,Quantity, ");
                sb.Append("   ROUND(TotalDisc)DiscAmt,ROUND(Amount)ItemNetAmt,IF(IsPackage=0,'NO','YES')Within_Package, ");
                sb.Append("   ROUND(OPD_Consultation)OPD_Consultation,ROUND(OPD_Procedure)OPD_Procedure, ");
                sb.Append("   ROUND(IPD_Visit)IPD_Visit,ROUND(IPD_Surgery)IPD_Surgery FROM ( ");

                if (rbtOPDIPD.SelectedValue == "OPD" || rbtOPDIPD.SelectedValue == "ALL")
                {
                    //sb.Append("     SELECT 'OPD' iType,T1.TransactionID, t1.BillNo,t1.BillDate,REPLACE(t1.PatientID,'LSHHI','')MR_No,   ");
                    //sb.Append("     pm.PName PatientName,pm.Age,pm.Gender Sex,pnl.Company_Name,   ");
                    //sb.Append("     dm.Name Consultant,t1.ItemNetAmt Amount,TotalBilledAmt,SubcategoryID,ConfigID,Itemname,  ");
                    //sb.Append("     ItemGrossAmt,(ItemGrossAmt-ItemNetAmt)TotalDisc,Quantity,Rate,IsPackage,  ");
                    //sb.Append("     IF(ConfigID=5,ItemNetAmt,0)OPD_Consultation,IF(ConfigID=25,ItemNetAmt,0)OPD_Procedure,  ");
                    //sb.Append("     IF(ConfigID=1,ItemNetAmt,0)IPD_Visit,IF(ConfigID=22,ItemNetAmt,0)IPD_Surgery    ");
                    //sb.Append("     FROM (   ");

                    //sb.Append("         SELECT BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,EntryDate,   ");
                    //sb.Append("         TotalBilledAmt,AmountPaid,ItemGrossAmt,ItemDisc,ItemNetAmt,   ");
                    //sb.Append("         DiscShareOn,LedgerTnxId,LedgertransactionNo,ItemID,Itemname,TBillDisc,  ");
                    //sb.Append("         PatientID,TransactionID,typeoftnx,PaidPtg,IF((TotalBilledAmt-AmountPaid)=0,'Full','Partial')PayStatus,  ");
                    //sb.Append("         TotalNetBillAmt,SubcategoryID,ConfigID,Quantity,Rate,IsPackage FROM ( 	  ");
                    //sb.Append("                 SELECT IF(pa.ReceiptNoLast IS NULL,lt.BillNo,pa.ReceiptNoLast)BillNo,DATE(pa.Date)BillDate,   ");
                    //sb.Append("                 DATE(pa.Date) EntryDate,lt.GrossAmount TotalBilledAmt,lt.NetAmount TotalNetBillAmt,   ");
                    //sb.Append("                 IF(pa.AmountPaid IS NULL,lt.NetAmount,pa.AmountPaid)AmountPaid,   ");
                    //sb.Append("                 (ltd.Rate*ltd.Quantity) ItemGrossAmt,(ltd.Rate*ltd.Quantity)-ltd.Amount ItemDisc,ltd.Amount ItemNetAmt,   ");
                    //sb.Append("                 ltd.itemname,'0' TBillDisc,lt.PatientID,ltd.DiscShareOn,  ");
                    //sb.Append("                 lt.typeoftnx,ltd.LedgerTnxId,lt.LedgertransactionNo,ltd.ItemID,lt.TransactionID,   ");
                    //sb.Append("                 IFNULL(((IF(pa.AmountPaid IS NULL,lt.NetAmount,pa.AmountPaid))*100)/lt.NetAmount,0)PaidPtg,  ");
                    //sb.Append("                 ltd.SubcategoryID,ltd.configID,ltd.Quantity,ltd.Rate,ltd.IsPackage FROM (   ");
                    //sb.Append("                         SELECT rt.ReceiptNo ReceiptNoLast,pa.ReceiptNoAgeinst ReceiptNoOld,IsAdvanceAmt,patientid,   ");
                    //sb.Append("                         rt.Date,rt.AmountPaid,IF((pa.ReceiptNoAgeinst IS NOT NULL OR pa.ReceiptNoAgeinst<>'' AND   ");
                    //sb.Append("                         IsAdvanceAmt=1),(SELECT AsainstLedgerTnxNo FROM f_reciept WHERE ReceiptNo=pa.ReceiptNoAgeinst),   ");
                    //sb.Append("                         rt.AsainstLedgerTnxNo)LedgertransactionNo FROM  f_reciept rt INNER JOIN f_patientaccount pa ON   ");
                    //sb.Append("                         rt.ReceiptNo = pa.ReceiptNo WHERE DATE(rt.date) >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    //sb.Append("                         AND DATE(rt.date) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    //sb.Append("                         AND pa.Type='Debit' AND rt.IsCancel=0 AND pa.Active=1   ");
                    //sb.Append("                 )pa INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = pa.LedgerTransactionNo   ");
                    //sb.Append("                 INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo   ");
                    //sb.Append("                 WHERE lt.TypeOfTnx IN('OPD-APPOINTMENT','OPD-PROCEDURE','CASUALTY-BILLING')   ");
                    //sb.Append("                 AND lt.IsCancel=0 AND ltd.configID IN (5,25))t   ");


                    //sb.Append("                 UNION ALL   ");


                    //sb.Append("                 SELECT BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,EntryDate,TotalBilledAmt,AmountPaid,ItemGrossAmt,ItemDisc,ItemNetAmt,   ");
                    //sb.Append("                 DiscShareOn,LedgerTnxId,LedgertransactionNo,ItemID,Itemname,TBillDisc,PatientID,TransactionID,typeoftnx,PaidPtg,  ");
                    //sb.Append("                 IF((TotalBilledAmt-AmountPaid)=0,'Full','Partial')PayStatus,TotalNetBillAmt,SubcategoryID,configID,Quantity,  ");
                    //sb.Append("                 Rate,IsPackage FROM (   ");
                    //sb.Append("                         SELECT IF(rt.ReceiptNo IS NULL,lt.BillNo,rt.ReceiptNo)BillNo,DATE(rt.Date) BillDate,   ");
                    //sb.Append("                         DATE(rt.Date) EntryDate,lt.GrossAmount TotalBilledAmt,lt.NetAmount TotalNetBillAmt,   ");
                    //sb.Append("                         IF(rt.AmountPaid IS NULL,lt.NetAmount,rt.AmountPaid)AmountPaid,(ltd.Rate*ltd.Quantity) ItemGrossAmt,   ");
                    //sb.Append("                         (ltd.Rate*ltd.Quantity)-ltd.Amount ItemDisc,ltd.Amount ItemNetAmt,ltd.itemname,'0' TBillDisc,   ");
                    //sb.Append("                         lt.PatientID,ltd.DiscShareOn,lt.TransactionID,lt.typeoftnx,   ");
                    //sb.Append("                         ltd.LedgerTnxId,lt.LedgertransactionNo,ltd.ItemID,ltd.SubcategoryID,ltd.configID,ltd.Rate,ltd.IsPackage,  ");
                    //sb.Append("                         IFNULL(((IF(rt.AmountPaid IS NULL,lt.NetAmount,rt.AmountPaid))*100)/lt.NetAmount,0)PaidPtg,ltd.Quantity  ");
                    //sb.Append("                         FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd   ");
                    //sb.Append("                         ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo INNER JOIN f_reciept rt   ");
                    //sb.Append("                         ON lt.LedgerTransactionNo = rt.AsainstLedgerTnxNo   ");
                    //sb.Append("                         WHERE lt.TypeOfTnx IN('OPD-APPOINTMENT','OPD-PROCEDURE','CASUALTY-BILLING') AND   ");
                    //sb.Append("                         DATE(rt.date) >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(rt.date) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    //sb.Append("                         AND lt.NetAmount = rt.AmountPaid AND lt.IsCancel=0  AND ltd.configID IN (5,25) )t   ");
                    //sb.Append("                 )t1 INNER JOIN patient_medical_history pmh ON t1.TransactionID = pmh.TransactionID   ");
                    //sb.Append("                 INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID   ");
                    //sb.Append("                 INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID   ");
                    //sb.Append("                 INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID   ");
                    //sb.Append("                 WHERE PaidPtg=100   ");

                  
                    sb.Append("SELECT 'OPD' iType,T1.TransactionID, t1.BillNo,t1.BillDate,REPLACE(t1.PatientID,'LSHHI','')MR_No,        pm.PName PatientName,pm.Age,pm.Gender  ");
                    sb.Append("Sex,pnl.Company_Name,        dm.Name Consultant,t1.ItemNetAmt Amount,t1.TotalBilledAmt,SubcategoryID,ConfigID,Itemname,       ItemGrossAmt, ");
                    sb.Append("(ItemGrossAmt-ItemNetAmt)TotalDisc,Quantity,Rate,IsPackage,       IF(ConfigID=5,ItemNetAmt,0)OPD_Consultation,IF(ConfigID=25,ItemNetAmt,0)OPD_Procedure, ");
                    sb.Append("IF(ConfigID=1,ItemNetAmt,0)IPD_Visit,IF(ConfigID=22,ItemNetAmt,0)IPD_Surgery         FROM ( ");
                    sb.Append("SELECT BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,EntryDate,            TotalBilledAmt,AmountPaid,ItemGrossAmt,ItemDisc,ItemNetAmt, ");
                    sb.Append("DiscShareOn,LedgerTnxId,LedgertransactionNo,ItemID,Itemname,TBillDisc,           PatientID,TransactionID,typeoftnx,PaidPtg, ");
                    sb.Append("IF((TotalBilledAmt-AmountPaid)=0,'Full','Partial')PayStatus,           TotalNetBillAmt,SubcategoryID,ConfigID,Quantity,Rate,IsPackage  ");
                    sb.Append("FROM ( ");
                    sb.Append("SELECT IF(pa.ReceiptNoLast IS NULL,lt.BillNo,pa.ReceiptNoLast)BillNo,DATE(pa.Date)BillDate, ");
                    sb.Append("DATE(pa.Date) EntryDate,SUM(ltd.GrossAmount) TotalBilledAmt,SUM(ltd.Amount) TotalNetBillAmt, ");
                    sb.Append("IF(pa.AmountPaid IS NULL,SUM(ltd.Amount),pa.AmountPaid)AmountPaid,SUM(ltd.Rate*ltd.Quantity) ItemGrossAmt, ");
                    sb.Append("SUM(ltd.TotalDiscAmt) ItemDisc,SUM(ltd.Amount) ItemNetAmt,ltd.itemname,'0' TBillDisc,lt.PatientID, ");
                    sb.Append("ltd.DiscShareOn,                   ltd.typeoftnx,ltd.LedgerTnxId,lt.LedgertransactionNo,ltd.ItemID,lt.TransactionID, ");
                    sb.Append("IFNULL(((IF(pa.AmountPaid IS NULL,SUM(ltd.Amount),pa.AmountPaid))*100)/SUM(ltd.Amount),0)PaidPtg,ltd.SubcategoryID,ltd.configID, ");
                    sb.Append("ltd.Quantity,ltd.Rate,ltd.IsPackage FROM ( ");
                    sb.Append("SELECT rt.ReceiptNo ReceiptNoLast,pa.ReceiptNoAgeinst ReceiptNoOld,IsAdvanceAmt,patientid, rt.Date,rt.AmountPaid, ");
                    sb.Append("IF((pa.ReceiptNoAgeinst IS NOT NULL OR pa.ReceiptNoAgeinst<>'' AND IsAdvanceAmt=1),(SELECT AsainstLedgerTnxNo FROM f_reciept WHERE ReceiptNo=pa.ReceiptNoAgeinst), rt.AsainstLedgerTnxNo)LedgertransactionNo  ");
                    sb.Append("FROM  f_reciept rt INNER JOIN f_patientaccount pa ON rt.ReceiptNo = pa.ReceiptNo  ");
                    sb.Append("WHERE DATE(rt.date) >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(rt.date) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' AND pa.Type='Debit' AND rt.IsCancel=0  ");
                    sb.Append("AND pa.Active=1 ");
                    sb.Append(")pa INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = pa.LedgerTransactionNo ");
                    sb.Append("INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo ");
                    sb.Append("WHERE ltd.TypeOfTnx IN('OPD-APPOINTMENT','OPD-PROCEDURE','CASUALTY-BILLING','opd-billing','opd-other') ");
                    sb.Append("AND lt.IsCancel=0 AND ltd.configID IN (5,25) GROUP BY lt.LedgertransactionNo, ltd.ItemID ");
                    sb.Append(")t ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,EntryDate,TotalBilledAmt,AmountPaid,ItemGrossAmt,ItemDisc,ItemNetAmt, ");
                    sb.Append("DiscShareOn,LedgerTnxId,LedgertransactionNo,ItemID,Itemname,TBillDisc,PatientID,TransactionID,typeoftnx,PaidPtg, ");
                    sb.Append("IF((TotalBilledAmt-AmountPaid)=0,'Full','Partial')PayStatus,TotalNetBillAmt,SubcategoryID,configID,Quantity, ");
                    sb.Append("Rate,IsPackage FROM ( ");
                    sb.Append("SELECT IF(rt.ReceiptNo IS NULL,lt.BillNo,rt.ReceiptNo)BillNo,DATE(rt.Date) BillDate, ");
                    sb.Append("DATE(rt.Date) EntryDate,SUM(ltd.GrossAmount) TotalBilledAmt,SUM(ltd.Amount) TotalNetBillAmt,  ");
                    sb.Append("IF(rt.AmountPaid IS NULL,SUM(ltd.Amount),rt.AmountPaid)AmountPaid,SUM(ltd.Rate*ltd.Quantity) ItemGrossAmt, ");
                    sb.Append("SUM(ltd.TotalDiscAmt)ItemDisc,SUM(ltd.Amount) ItemNetAmt,ltd.itemname,'0' TBillDisc,lt.PatientID,ltd.DiscShareOn, ");
                    sb.Append("lt.TransactionID,ltd.typeoftnx, ltd.LedgerTnxId,lt.LedgertransactionNo,ltd.ItemID,ltd.SubcategoryID,ltd.configID,ltd.Rate, ");
                    sb.Append("ltd.IsPackage, ROUND(IFNULL(((IF(rt.AmountPaid IS NULL,SUM(ltd.Amount),rt.AmountPaid))*100)/SUM(ltd.Amount),0))PaidPtg,ltd.Quantity  ");
                    sb.Append("FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
                    sb.Append("INNER JOIN f_reciept rt ON lt.LedgerTransactionNo = rt.AsainstLedgerTnxNo  ");
                    sb.Append("WHERE ltd.TypeOfTnx IN('OPD-APPOINTMENT','OPD-PROCEDURE','CASUALTY-BILLING','opd-billing','opd-other') AND ");
                    sb.Append("DATE(rt.date) >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(rt.date) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' AND lt.NetAmount>=0 ");
                    sb.Append("AND lt.NetAmount = rt.AmountPaid AND lt.IsCancel=0  AND ltd.configID IN (5,25) GROUP BY lt.LedgerTransactionNo  ");
                    sb.Append(")t                     ");
                    sb.Append(")t1 INNER JOIN patient_medical_history pmh ON t1.TransactionID = pmh.TransactionID ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
                    sb.Append("INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
                    sb.Append("WHERE PaidPtg=100    ");


                    sb.Append("    AND  PMH.DoctorID ='" + ddlDoctor.SelectedValue + "'    ");
                }

                if (rbtOPDIPD.SelectedValue == "IPD" || rbtOPDIPD.SelectedValue == "ALL")
                {
                    if (rbtOPDIPD.SelectedValue == "ALL")
                        sb.Append("             UNION ALL ");


                    sb.Append("                 SELECT 'IPD' iType,T5.TransactionID, t5.BillNo,   ");
                    sb.Append("                 (SELECT DATE_FORMAT(Billdate,'%d-%b-%y') FROM f_ledgertransaction WHERE TransactionID=t5.TransactionID   ");
                    sb.Append("                 AND Billdate <>'' LIMIT 1)BillDate,REPLACE(pmh.PatientID,'LSHHI','')MR_No,   ");
                    sb.Append("                 pm.PName PatientName,pm.Age,pm.Gender Sex,pnl.Company_Name,dm.Name Consultant,ROUND(ItemNetAmt)Amount,  ");
                    sb.Append("                 NetBillAmt TotalBilledAmt,SubcategoryID,ConfigID,ItemName,ItemGrossAmt,(ItemGrossAmt-ROUND(ItemNetAmt))TotalDisc,   ");
                    sb.Append("                 Quantity,Rate,IsPackage,IF(ConfigID=5,ItemNetAmt,0)OPD_Consultation,IF(ConfigID=25,ItemNetAmt,0)OPD_Procedure,  ");
                    sb.Append("                 IF(ConfigID=1,ItemNetAmt,0)IPD_Visit,IF(ConfigID=22,ItemNetAmt,0)IPD_Surgery FROM (   ");
                    sb.Append("                         SELECT  TransactionID,BillNo,t4.DoctorID,NetBillAmt,MedAmt,DiscountOnBill,  ");
                    sb.Append("                         IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt)ItemNetAmt,  ");
                    sb.Append("                         SubCategoryID,configID,ItemName,ItemGrossAmt,Quantity,Rate,IsPackage FROM ( 		       ");
                    sb.Append("                                 SELECT t2.TransactionID,t2.BillNo,t2.NetBillAmt,t2.MedAmt,t2.DiscountOnBill,t2.Amountpaid,   ");
                    sb.Append("                                 IF(ltd.IsSurgery=0,ltd.DoctorID,IFNULL((SELECT DoctorID FROM f_surgery_doctor sd   ");
                    sb.Append("                                 INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID   ");
                    sb.Append("                                 AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
                    sb.Append("                                 AND sds.ItemID = ltd.ItemID),''))DoctorID,((t2.DiscountOnBill/t2.NetBillAmt)*100)TotalDisc,ltd.ispackage,   ");
                    sb.Append("                                 IF(ltd.Ispackage=1,Rate*Quantity,Amount)ItemNetAmt,ltd.ItemName,ltd.SubCategoryID,  ");
                    sb.Append("                                 ltd.configID,(ltd.Rate*ltd.Quantity)ItemGrossAmt,ltd.Quantity,ltd.Rate FROM (   ");
                    sb.Append("                                         SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0    ");
                    sb.Append("                                         AND TransactionID=t1.TransactionID),0)NetBillAmt,   ");
                    sb.Append("                                         IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON   ");
                    sb.Append("                                         ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=0    ");
                    sb.Append("                                         AND ltd.TransactionID=t1.TransactionID   ");
                    sb.Append("                                         AND UCASE(sc.DisplayName)IN('MEDICINE & CONSUMABLES','PACKAGE MEDICINE','MEDICNE,INJECTION & CONSUMABLES')),0)MedAmt, 			  ");
                    sb.Append("                                         IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,t1.Amountpaid,IFNULL(pmh.TDS,0)TDS,  ");
                    sb.Append("                                         IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.WriteOff,0)WriteOff,   ");
                    sb.Append("                                         IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,t1.TransactionID FROM (   ");
                    sb.Append("                                                 SELECT SUM(rt.AmountPaid)AmountPaid,t.TransactionID FROM f_reciept rt INNER JOIN (    ");
                    sb.Append("                                                         SELECT TransactionID,DATE FROM (     ");
                    sb.Append("                                                                 SELECT TransactionID,MAX(DATE)DATE FROM f_reciept WHERE IsCancel = 0     ");
                    sb.Append("                                                                 AND AsainstLedgerTnxNo='' GROUP BY TransactionID   ");
                    sb.Append("                                                         )aaa WHERE DATE(DATE) BETWEEN '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    sb.Append("                                                 )t ON t.TransactionID = rt.TransactionID WHERE rt.Iscancel=0 GROUP BY t.TransactionID   ");
                    sb.Append("                                         )t1 INNER JOIN Patient_MEdical_History adj ON adj.TransactionID = t1.TransactionID   ");
                    sb.Append("                                         INNER JOIN patient_medical_history pmh ON pmh.TransactionID = adj.TransactionID   ");
                    sb.Append("                                         WHERE  IFNULL(adj.BillNo,'')<>''  ");
                    sb.Append("                                         Having ABS(ROUND((NetBillAmt-DiscountOnBill))-ROUND((Amountpaid+TDS+Deduction_Acceptable+Deduction_NonAcceptable+WriteOff) ))<=4   ");
                    sb.Append("                                 )t2 INNER JOIN f_ledgertnxdetail ltd ON t2.TransactionID= ltd.TransactionID   ");
                    sb.Append("                                 WHERE ltd.IsVerified=1 AND ltd.ConfigID in (1,25)  ");
                    sb.Append("                                 Union All ");
                    sb.Append("                                 SELECT t2.TransactionID,t2.BillNo,t2.NetBillAmt,t2.MedAmt,t2.DiscountOnBill,t2.Amountpaid,   ");
                    sb.Append("                                 IF(ltd.IsSurgery=0,ltd.DoctorID,IFNULL((SELECT DoctorID FROM f_surgery_doctor sd   ");
                    sb.Append("                                 INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID   ");
                    sb.Append("                                 AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
                    sb.Append("                                 AND sds.ItemID = ltd.ItemID),''))DoctorID,((t2.DiscountOnBill/t2.NetBillAmt)*100)TotalDisc,ltd.ispackage,   ");
                    sb.Append("                                 IF(ltd.Ispackage=1,ltd.Rate*ltd.Quantity,ltd.Amount)ItemNetAmt,ltd.ItemName,ltd.SubCategoryID,  ");
                    sb.Append("                                 ltd.configID,(ltd.Rate*ltd.Quantity)ItemGrossAmt,ltd.Quantity,ltd.Rate FROM (   ");
                    sb.Append("                                         SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0    ");
                    sb.Append("                                         AND TransactionID=t1.TransactionID),0)NetBillAmt,   ");
                    sb.Append("                                         IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON   ");
                    sb.Append("                                         ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=0    ");
                    sb.Append("                                         AND ltd.TransactionID=t1.TransactionID   ");
                    sb.Append("                                         AND UCASE(sc.DisplayName)IN('MEDICINE & CONSUMABLES','PACKAGE MEDICINE','MEDICNE,INJECTION & CONSUMABLES')),0)MedAmt, 			  ");
                    sb.Append("                                         IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,t1.Amountpaid,IFNULL(pmh.TDS,0)TDS,  ");
                    sb.Append("                                         IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.WriteOff,0)WriteOff,   ");
                    sb.Append("                                         IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,t1.TransactionID FROM (   ");
                    sb.Append("                                                 SELECT SUM(rt.AmountPaid)AmountPaid,t.TransactionID FROM f_reciept rt INNER JOIN (    ");
                    sb.Append("                                                         SELECT TransactionID,DATE FROM (     ");
                    sb.Append("                                                                 SELECT TransactionID,MAX(DATE)DATE FROM f_reciept WHERE IsCancel = 0     ");
                    sb.Append("                                                                 AND AsainstLedgerTnxNo='' GROUP BY TransactionID   ");
                    sb.Append("                                                         )aaa WHERE DATE(DATE) BETWEEN '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    sb.Append("                                                 )t ON t.TransactionID = rt.TransactionID WHERE rt.Iscancel=0 GROUP BY t.TransactionID   ");
                    sb.Append("                                         )t1 INNER JOIN Patient_MEdical_History adj ON adj.TransactionID = t1.TransactionID   ");
                    sb.Append("                                         INNER JOIN patient_medical_history pmh ON pmh.TransactionID = adj.TransactionID   ");
                    sb.Append("                                         WHERE  IFNULL(adj.BillNo,'')<>''  ");
                    sb.Append("                                         Having ABS(ROUND((NetBillAmt-DiscountOnBill))-ROUND((Amountpaid+TDS+Deduction_Acceptable+Deduction_NonAcceptable+WriteOff) ))<=4   ");
                    sb.Append("                                 )t2 INNER JOIN f_ledgertnxdetail ltd ON t2.TransactionID= ltd.TransactionID   ");
                    sb.Append("                                 INNER JOIN f_surgery_discription sd ON sd.LedgerTransactionNo = ltd.LedgerTransactionNo AND sd.ItemID = ltd.ItemID ");
                    sb.Append("                                 INNER JOIN f_surgery_doctor sdoc ON sd.SurgeryTransactionID = sdoc.SurgeryTransactionID AND sd.ItemID = sdoc.ItemID ");
                    sb.Append("                                 WHERE ltd.IsVerified=1 AND ltd.ConfigID =22  ");
                    sb.Append("                         )t4   ");
                    sb.Append("                 )t5 INNER JOIN patient_medical_history pmh ON t5.TransactionID = pmh.TransactionID   ");
                    sb.Append("                 INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID   ");
                    sb.Append("                 INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID   ");
                    sb.Append("                 LEFT JOIN doctor_master dm ON dm.DoctorID = t5.DoctorID   ");
                    sb.Append("       WHERE t5.DoctorID ='" + ddlDoctor.SelectedValue + "'     ");
                }

                sb.Append(" )t   ");
            }
            else // Receipt Summary
            {
                
                    //sb.Append("SELECT iType,IF(iType='OPD','',REPLACE(TransactionID,'ISHHI',''))IPD_No,MR_No,  ");
                    //sb.Append("Company_Name Panel,PatientName,BillNo,BillDate DATE,ROUND(TotalBilledAmt)NetBillAmount,  ");
                    //sb.Append("IFNULL((SELECT DATE_FORMAT(MAX(DATE),'%d-%b-%Y') FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0),'')Settlement_Date,  ");
                    //sb.Append("IFNULL((SELECT MAX(ReceiptNo) FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0),'')Settlement_Receipt,  ");
                    //sb.Append("ROUND(IFNULL((SELECT SUM(amountpaid) FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0 AND DATE(DATE)<='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd") + "'),0))Collected_Till_CurrentDate,  ");
                    //sb.Append("(SELECT NAME FROM f_subcategorymaster WHERE subcategoryid=t.subcategoryID)Category,  ");
                    //sb.Append("(CASE WHEN ConfigID=5 THEN 'OPD-Consultation' WHEN ConfigID=25 THEN 'Minor-Procedures'   ");
                    //sb.Append("WHEN ConfigID=1 THEN 'IPD-Visit' WHEN ConfigID=22 THEN 'IPD-Surgery' ELSE '' END)TransactionType,ItemName,SUM(Rate) ItemRate,SUM(Quantity)Quantity,  ");
                    //sb.Append("SUM(ROUND(TotalDisc))DiscAmt,SUM(ROUND(Amount))ItemNetAmt,IF(IsPackage=0,'NO','YES')Within_Package,  ");
                    //sb.Append("SUM(ROUND(OPD_Consultation))OPD_Consultation,SUM(ROUND(OPD_Procedure))OPD_Procedure,  ");
                    //sb.Append("SUM(ROUND(IPD_Visit))IPD_Visit,SUM(ROUND(IPD_Surgery))IPD_Surgery FROM (  ");

                   sb.Append("SELECT iType,IF(iType='OPD','',REPLACE(TransactionID,'ISHHI',''))IPD_No,MR_No,  Company_Name Panel,PatientName,BillNo,BillDate DATE, ");
                sb.Append("ROUND(TotalBilledAmt)NetBillAmount,  IFNULL((SELECT DATE_FORMAT(MAX(DATE),'%d-%b-%Y') FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0),'')Settlement_Date, ");
                sb.Append("IFNULL((SELECT MAX(ReceiptNo) FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0),'')Settlement_Receipt,   ");
                sb.Append("ROUND(IFNULL((SELECT SUM(amountpaid) FROM f_reciept WHERE TransactionID=t.TransactionID AND IsCancel=0 AND DATE(DATE)<='2021-02-08'),0))Collected_Till_CurrentDate, ");
                sb.Append("(SELECT NAME FROM f_subcategorymaster WHERE subcategoryid=t.subcategoryID)Category,   ");
                sb.Append("(CASE WHEN ConfigID=5 THEN 'OPD-Consultation' WHEN ConfigID=25 THEN 'Minor-Procedures'   WHEN ConfigID=1 THEN 'IPD-Visit'  ");
                sb.Append("WHEN ConfigID=22 THEN 'IPD-Surgery' ELSE '' END)TransactionType,ItemName,SUM(Rate) ItemRate,SUM(Quantity)Quantity,  SUM(ROUND(TotalDisc))DiscAmt, ");
                sb.Append("SUM(ROUND(Amount))ItemNetAmt,IF(IsPackage=0,'NO','YES')Within_Package,  SUM(ROUND(OPD_Consultation))OPD_Consultation,SUM(ROUND(OPD_Procedure))OPD_Procedure, ");
                sb.Append("SUM(ROUND(IPD_Visit))IPD_Visit,SUM(ROUND(IPD_Surgery))IPD_Surgery FROM ( ");

                if (rbtOPDIPD.SelectedValue == "OPD" || rbtOPDIPD.SelectedValue == "ALL")
                {
                    //sb.Append("     SELECT 'OPD' iType,T1.TransactionID, t1.BillNo,t1.BillDate,REPLACE(t1.PatientID,'LSHHI','')MR_No,   ");
                    //sb.Append("     pm.PName PatientName,pm.Age,pm.Gender Sex,pnl.Company_Name,   ");
                    //sb.Append("     dm.Name Consultant,t1.ItemNetAmt Amount,TotalBilledAmt,SubcategoryID,ConfigID,Itemname,  ");
                    //sb.Append("     ItemGrossAmt,(ItemGrossAmt-ItemNetAmt)TotalDisc,Quantity,Rate,IsPackage,  ");
                    //sb.Append("     IF(ConfigID=5,ItemNetAmt,0)OPD_Consultation,IF(ConfigID=25,ItemNetAmt,0)OPD_Procedure,  ");
                    //sb.Append("     IF(ConfigID=1,ItemNetAmt,0)IPD_Visit,IF(ConfigID=22,ItemNetAmt,0)IPD_Surgery    ");
                    //sb.Append("     FROM (   ");

                    //sb.Append("         SELECT BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,EntryDate,   ");
                    //sb.Append("         TotalBilledAmt,AmountPaid,ItemGrossAmt,ItemDisc,ItemNetAmt,   ");
                    //sb.Append("         DiscShareOn,LedgerTnxId,LedgertransactionNo,ItemID,Itemname,TBillDisc,  ");
                    //sb.Append("         PatientID,TransactionID,typeoftnx,PaidPtg,IF((TotalBilledAmt-AmountPaid)=0,'Full','Partial')PayStatus,  ");
                    //sb.Append("         TotalNetBillAmt,SubcategoryID,ConfigID,Quantity,Rate,IsPackage FROM ( 	  ");
                    //sb.Append("                 SELECT IF(pa.ReceiptNoLast IS NULL,lt.BillNo,pa.ReceiptNoLast)BillNo,DATE(pa.Date)BillDate,   ");
                    //sb.Append("                 DATE(pa.Date) EntryDate,lt.GrossAmount TotalBilledAmt,lt.NetAmount TotalNetBillAmt,   ");
                    //sb.Append("                 IF(pa.AmountPaid IS NULL,lt.NetAmount,pa.AmountPaid)AmountPaid,   ");
                    //sb.Append("                 (ltd.Rate*ltd.Quantity) ItemGrossAmt,(ltd.Rate*ltd.Quantity)-ltd.Amount ItemDisc,ltd.Amount ItemNetAmt,   ");
                    //sb.Append("                 ltd.itemname,'0' TBillDisc,lt.PatientID,ltd.DiscShareOn,  ");
                    //sb.Append("                 lt.typeoftnx,ltd.LedgerTnxId,lt.LedgertransactionNo,ltd.ItemID,lt.TransactionID,   ");
                    //sb.Append("                 IFNULL(((IF(pa.AmountPaid IS NULL,lt.NetAmount,pa.AmountPaid))*100)/lt.NetAmount,0)PaidPtg,  ");
                    //sb.Append("                 ltd.SubcategoryID,ltd.configID,ltd.Quantity,ltd.Rate,ltd.IsPackage FROM (   ");
                    //sb.Append("                         SELECT rt.ReceiptNo ReceiptNoLast,pa.ReceiptNoAgeinst ReceiptNoOld,IsAdvanceAmt,patientid,   ");
                    //sb.Append("                         rt.Date,rt.AmountPaid,IF((pa.ReceiptNoAgeinst IS NOT NULL OR pa.ReceiptNoAgeinst<>'' AND   ");
                    //sb.Append("                         IsAdvanceAmt=1),(SELECT AsainstLedgerTnxNo FROM f_reciept WHERE ReceiptNo=pa.ReceiptNoAgeinst),   ");
                    //sb.Append("                         rt.AsainstLedgerTnxNo)LedgertransactionNo FROM  f_reciept rt INNER JOIN f_patientaccount pa ON   ");
                    //sb.Append("                         rt.ReceiptNo = pa.ReceiptNo WHERE DATE(rt.date) >='" +  Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    //sb.Append("                         AND DATE(rt.date) <='" +  Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    //sb.Append("                         AND pa.Type='Debit' AND rt.IsCancel=0 AND pa.Active=1   ");
                    //sb.Append("                 )pa INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = pa.LedgerTransactionNo   ");
                    //sb.Append("                 INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo   ");
                    //sb.Append("                 WHERE lt.TypeOfTnx IN('OPD-APPOINTMENT','OPD-PROCEDURE','CASUALTY-BILLING')   ");
                    //sb.Append("                 AND lt.IsCancel=0 AND ltd.configID IN (5,25))t   ");


                    //sb.Append("                 UNION ALL   ");


                    //sb.Append("                 SELECT BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,EntryDate,TotalBilledAmt,AmountPaid,ItemGrossAmt,ItemDisc,ItemNetAmt,   ");
                    //sb.Append("                 DiscShareOn,LedgerTnxId,LedgertransactionNo,ItemID,Itemname,TBillDisc,PatientID,TransactionID,typeoftnx,PaidPtg,  ");
                    //sb.Append("                 IF((TotalBilledAmt-AmountPaid)=0,'Full','Partial')PayStatus,TotalNetBillAmt,SubcategoryID,configID,Quantity,  ");
                    //sb.Append("                 Rate,IsPackage FROM (   ");
                    //sb.Append("                         SELECT IF(rt.ReceiptNo IS NULL,lt.BillNo,rt.ReceiptNo)BillNo,DATE(rt.Date) BillDate,   ");
                    //sb.Append("                         DATE(rt.Date) EntryDate,lt.GrossAmount TotalBilledAmt,lt.NetAmount TotalNetBillAmt,   ");
                    //sb.Append("                         IF(rt.AmountPaid IS NULL,lt.NetAmount,rt.AmountPaid)AmountPaid,(ltd.Rate*ltd.Quantity) ItemGrossAmt,   ");
                    //sb.Append("                         (ltd.Rate*ltd.Quantity)-ltd.Amount ItemDisc,ltd.Amount ItemNetAmt,ltd.itemname,'0' TBillDisc,   ");
                    //sb.Append("                         lt.PatientID,ltd.DiscShareOn,lt.TransactionID,lt.typeoftnx,   ");
                    //sb.Append("                         ltd.LedgerTnxId,lt.LedgertransactionNo,ltd.ItemID,ltd.SubcategoryID,ltd.configID,ltd.Rate,ltd.IsPackage,  ");
                    //sb.Append("                         IFNULL(((IF(rt.AmountPaid IS NULL,lt.NetAmount,rt.AmountPaid))*100)/lt.NetAmount,0)PaidPtg,ltd.Quantity  ");
                    //sb.Append("                         FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd   ");
                    //sb.Append("                         ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo INNER JOIN f_reciept rt   ");
                    //sb.Append("                         ON lt.LedgerTransactionNo = rt.AsainstLedgerTnxNo   ");
                    //sb.Append("                         WHERE lt.TypeOfTnx IN('OPD-APPOINTMENT','OPD-PROCEDURE','CASUALTY-BILLING') AND   ");
                    //sb.Append("                         DATE(rt.date) >='" +  Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(rt.date) <='" +  Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    //sb.Append("                         AND lt.NetAmount = rt.AmountPaid AND lt.IsCancel=0  AND ltd.configID IN (5,25) )t   ");
                    //sb.Append("                 )t1 INNER JOIN patient_medical_history pmh ON t1.TransactionID = pmh.TransactionID   ");
                    //sb.Append("                 INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID   ");
                    //sb.Append("                 INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID   ");
                    //sb.Append("                 INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID   ");
                    //sb.Append("                 WHERE PaidPtg=100   ");
                    //sb.Append("    AND  PMH.DoctorID ='" + ddlDoctor.SelectedValue + "'    ");


                    sb.Append("SELECT 'OPD' iType,T1.TransactionID, t1.BillNo,t1.BillDate,REPLACE(t1.PatientID,'LSHHI','')MR_No,        pm.PName PatientName,pm.Age,pm.Gender Sex, ");
                    sb.Append("pnl.Company_Name,dm.Name Consultant,t1.ItemNetAmt Amount,t1.TotalBilledAmt,SubcategoryID,ConfigID,Itemname,ItemGrossAmt, ");
                    sb.Append("(ItemGrossAmt-ItemNetAmt)TotalDisc,Quantity,Rate,IsPackage,IF(ConfigID=5,ItemNetAmt,0)OPD_Consultation,IF(ConfigID=25,ItemNetAmt,0)OPD_Procedure, ");
                    sb.Append("IF(ConfigID=1,ItemNetAmt,0)IPD_Visit,IF(ConfigID=22,ItemNetAmt,0)IPD_Surgery         FROM ( ");
                    sb.Append("SELECT BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,EntryDate,            TotalBilledAmt,AmountPaid,ItemGrossAmt,ItemDisc,ItemNetAmt, ");
                    sb.Append("DiscShareOn,LedgerTnxId,LedgertransactionNo,ItemID,Itemname,TBillDisc,           PatientID,TransactionID,typeoftnx,PaidPtg, ");
                    sb.Append("IF((TotalBilledAmt-AmountPaid)=0,'Full','Partial')PayStatus,           TotalNetBillAmt,SubcategoryID,ConfigID,Quantity,Rate,IsPackage  ");
                    sb.Append("FROM ( ");
                    sb.Append("SELECT IF(pa.ReceiptNoLast IS NULL,lt.BillNo,pa.ReceiptNoLast)BillNo,DATE(pa.Date)BillDate,DATE(pa.Date) EntryDate, ");
                    sb.Append("lt.GrossAmount TotalBilledAmt,lt.NetAmount TotalNetBillAmt,IF(pa.AmountPaid IS NULL,lt.NetAmount,pa.AmountPaid)AmountPaid, ");
                    sb.Append("(ltd.Rate*ltd.Quantity) ItemGrossAmt,(ltd.Rate*ltd.Quantity)-ltd.Amount ItemDisc,ltd.Amount ItemNetAmt, ");
                    sb.Append("ltd.itemname,'0' TBillDisc,lt.PatientID,ltd.DiscShareOn,lt.typeoftnx,ltd.LedgerTnxId,lt.LedgertransactionNo,ltd.ItemID, ");
                    sb.Append("lt.TransactionID,IFNULL(((IF(pa.AmountPaid IS NULL,lt.NetAmount,pa.AmountPaid))*100)/lt.NetAmount,0)PaidPtg, ");
                    sb.Append("ltd.SubcategoryID,ltd.configID,ltd.Quantity,ltd.Rate,ltd.IsPackage FROM ( ");
                    sb.Append("SELECT rt.ReceiptNo ReceiptNoLast,pa.ReceiptNoAgeinst ReceiptNoOld,IsAdvanceAmt,patientid,rt.Date,rt.AmountPaid, ");
                    sb.Append("IF((pa.ReceiptNoAgeinst IS NOT NULL OR pa.ReceiptNoAgeinst<>'' AND IsAdvanceAmt=1), ");
                    sb.Append("(SELECT AsainstLedgerTnxNo FROM f_reciept WHERE ReceiptNo=pa.ReceiptNoAgeinst),rt.AsainstLedgerTnxNo)LedgertransactionNo  ");
                    sb.Append("FROM  f_reciept rt INNER JOIN f_patientaccount pa ON rt.ReceiptNo = pa.ReceiptNo  ");
                    sb.Append("WHERE DATE(rt.date) >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(rt.date) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' AND pa.Type='Debit'  ");
                    sb.Append("AND rt.IsCancel=0 AND pa.Active=1 ");
                    sb.Append(")pa INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = pa.LedgerTransactionNo ");
                    sb.Append("INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo ");
                    sb.Append("WHERE ltd.TypeOfTnx IN('OPD-APPOINTMENT','OPD-PROCEDURE','CASUALTY-BILLING','opd-billing','opd-other') ");
                    sb.Append("AND lt.IsCancel=0 AND ltd.configID IN (5,25) ");
                    sb.Append(")t ");
                    sb.Append("UNION ALL ");
                    sb.Append("SELECT BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,EntryDate,TotalBilledAmt,AmountPaid,ItemGrossAmt,ItemDisc,ItemNetAmt, ");
                    sb.Append("DiscShareOn,LedgerTnxId,LedgertransactionNo,ItemID,Itemname,TBillDisc,PatientID,TransactionID,typeoftnx,PaidPtg, ");
                    sb.Append("IF((TotalBilledAmt-AmountPaid)=0,'Full','Partial')PayStatus,TotalNetBillAmt,SubcategoryID,configID,Quantity, ");
                    sb.Append("Rate,IsPackage FROM ( ");
                    sb.Append("SELECT IF(rt.ReceiptNo IS NULL,lt.BillNo,rt.ReceiptNo)BillNo,DATE(rt.Date) BillDate,DATE(rt.Date) EntryDate,SUM(ltd.GrossAmount) TotalBilledAmt, ");
                    sb.Append("SUM(ltd.Amount) TotalNetBillAmt,IF(rt.AmountPaid IS NULL,SUM(ltd.Amount),rt.AmountPaid)AmountPaid,SUM(ltd.Rate*ltd.Quantity) ItemGrossAmt, ");
                    sb.Append("SUM(ltd.TotalDiscAmt)ItemDisc,SUM(ltd.Amount) ItemNetAmt,ltd.itemname,'0' TBillDisc,lt.PatientID,ltd.DiscShareOn, ");
                    sb.Append("lt.TransactionID,lt.typeoftnx,ltd.LedgerTnxId,lt.LedgertransactionNo,ltd.ItemID,ltd.SubcategoryID,ltd.configID,ltd.Rate, ");
                    sb.Append("ltd.IsPackage,ROUND(IFNULL(((IF(rt.AmountPaid IS NULL,SUM(ltd.Amount),rt.AmountPaid))*100)/SUM(ltd.Amount),0))PaidPtg,ltd.Quantity ");
                    sb.Append("FROM f_ledgertransaction lt  ");
                    sb.Append("INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
                    sb.Append("INNER JOIN f_reciept rt ON lt.LedgerTransactionNo = rt.AsainstLedgerTnxNo ");
                    sb.Append("WHERE ltd.TypeOfTnx IN('OPD-APPOINTMENT','OPD-PROCEDURE','CASUALTY-BILLING','opd-billing','opd-other') AND ");
                    sb.Append("DATE(rt.date) >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(rt.date) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");
                    sb.Append("AND lt.NetAmount = rt.AmountPaid AND lt.IsCancel=0  AND ltd.configID IN (5,25) AND lt.NetAmount>=0 GROUP BY lt.LedgerTransactionNo ");
                    sb.Append(")t                     ");
                    sb.Append(")t1 INNER JOIN patient_medical_history pmh ON t1.TransactionID = pmh.TransactionID ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
                    sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
                    sb.Append("INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
                    sb.Append("WHERE PaidPtg>=100       AND  PMH.DoctorID ='" + ddlDoctor.SelectedValue + "'      ");
                   

                }

                if (rbtOPDIPD.SelectedValue == "IPD" || rbtOPDIPD.SelectedValue == "ALL")
                {
                    if (rbtOPDIPD.SelectedValue == "ALL")
                        sb.Append("             UNION ALL ");


                    sb.Append("                 SELECT 'IPD' iType,T5.TransactionID, t5.BillNo,   ");
                    sb.Append("                 (SELECT DATE_FORMAT(Billdate,'%d-%b-%y') FROM f_ledgertransaction WHERE TransactionID=t5.TransactionID   ");
                    sb.Append("                 AND Billdate <>'' LIMIT 1)BillDate,REPLACE(pmh.PatientID,'LSHHI','')MR_No,   ");
                    sb.Append("                 pm.PName PatientName,pm.Age,pm.Gender Sex,pnl.Company_Name,dm.Name Consultant,ROUND(ItemNetAmt)Amount,  ");
                    sb.Append("                 NetBillAmt TotalBilledAmt,SubcategoryID,ConfigID,ItemName,ItemGrossAmt,(ItemGrossAmt-ROUND(ItemNetAmt))TotalDisc,   ");
                    sb.Append("                 Quantity,Rate,IsPackage,IF(ConfigID=5,ItemNetAmt,0)OPD_Consultation,IF(ConfigID=25,ItemNetAmt,0)OPD_Procedure,  ");
                    sb.Append("                 IF(ConfigID=1,ItemNetAmt,0)IPD_Visit,IF(ConfigID=22,ItemNetAmt,0)IPD_Surgery FROM (   ");
                    sb.Append("                         SELECT  TransactionID,BillNo,t4.DoctorID,NetBillAmt,MedAmt,DiscountOnBill,  ");
                    sb.Append("                         IF(DiscountOnBill >0,(ItemNetAmt-(DiscountOnBill *((ItemNetAmt*100)/(NetBillAmt-MedAmt))/100)),ItemNetAmt)ItemNetAmt,  ");
                    sb.Append("                         SubCategoryID,configID,ItemName,ItemGrossAmt,Quantity,Rate,IsPackage FROM ( 		       ");
                    sb.Append("                                 SELECT t2.TransactionID,t2.BillNo,t2.NetBillAmt,t2.MedAmt,t2.DiscountOnBill,t2.Amountpaid,   ");
                    sb.Append("                                 IF(ltd.IsSurgery=0,ltd.DoctorID,IFNULL((SELECT DoctorID FROM f_surgery_doctor sd   ");
                    sb.Append("                                 INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID   ");
                    sb.Append("                                 AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
                    sb.Append("                                 AND sds.ItemID = ltd.ItemID),''))DoctorID,((t2.DiscountOnBill/t2.NetBillAmt)*100)TotalDisc,ltd.ispackage,   ");
                    sb.Append("                                 IF(ltd.Ispackage=1,Rate*Quantity,Amount)ItemNetAmt,ltd.ItemName,ltd.SubCategoryID,  ");
                    sb.Append("                                 ltd.configID,(ltd.Rate*ltd.Quantity)ItemGrossAmt,ltd.Quantity,ltd.Rate FROM (   ");
                    sb.Append("                                         SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0    ");
                    sb.Append("                                         AND TransactionID=t1.TransactionID),0)NetBillAmt,   ");
                    sb.Append("                                         IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON   ");
                    sb.Append("                                         ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=0    ");
                    sb.Append("                                         AND ltd.TransactionID=t1.TransactionID   ");
                    sb.Append("                                         AND UCASE(sc.DisplayName)IN('MEDICINE & CONSUMABLES','PACKAGE MEDICINE','MEDICNE,INJECTION & CONSUMABLES')),0)MedAmt, 			  ");
                    sb.Append("                                         IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,t1.Amountpaid,IFNULL(pmh.TDS,0)TDS,  ");
                    sb.Append("                                         IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.WriteOff,0)WriteOff,   ");
                    sb.Append("                                         IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,t1.TransactionID FROM (   ");
                    sb.Append("                                                 SELECT SUM(rt.AmountPaid)AmountPaid,t.TransactionID FROM f_reciept rt INNER JOIN (    ");
                    sb.Append("                                                         SELECT TransactionID,DATE FROM (     ");
                    sb.Append("                                                                 SELECT TransactionID,MAX(DATE)DATE FROM f_reciept WHERE IsCancel = 0     ");
                    sb.Append("                                                                 AND AsainstLedgerTnxNo='' GROUP BY TransactionID   ");
                    sb.Append("                                                         )aaa WHERE DATE(DATE) BETWEEN '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    sb.Append("                                                 )t ON t.TransactionID = rt.TransactionID WHERE rt.Iscancel=0 GROUP BY t.TransactionID   ");
                    sb.Append("                                         )t1 INNER JOIN Patient_MEdical_History adj ON adj.TransactionID = t1.TransactionID   ");
                    sb.Append("                                         INNER JOIN patient_medical_history pmh ON pmh.TransactionID = adj.TransactionID   ");
                    sb.Append("                                         WHERE  IFNULL(adj.BillNo,'')<>''  ");
                    sb.Append("                                         Having ABS(ROUND((NetBillAmt-DiscountOnBill))-ROUND((Amountpaid+TDS+Deduction_Acceptable+Deduction_NonAcceptable+WriteOff) ))<=4  ");
                    sb.Append("                                 )t2 INNER JOIN f_ledgertnxdetail ltd ON t2.TransactionID= ltd.TransactionID   ");
                    sb.Append("                                 WHERE ltd.IsVerified=1 AND ltd.ConfigID in (1,25)  ");
                    sb.Append("                                 Union All ");

                    sb.Append("                                 SELECT t2.TransactionID,t2.BillNo,t2.NetBillAmt,t2.MedAmt,t2.DiscountOnBill,t2.Amountpaid,   ");
                    sb.Append("                                 IF(ltd.IsSurgery=0,ltd.DoctorID,IFNULL((SELECT DoctorID FROM f_surgery_doctor sd   ");
                    sb.Append("                                 INNER JOIN f_surgery_discription sds ON sds.SurgeryTransactionID = sd.SurgeryTransactionID   ");
                    sb.Append("                                 AND sd.ItemID = sds.ItemID WHERE sds.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
                    sb.Append("                                 AND sds.ItemID = ltd.ItemID),''))DoctorID,((t2.DiscountOnBill/t2.NetBillAmt)*100)TotalDisc,ltd.ispackage,   ");
                    sb.Append("                                 IF(ltd.Ispackage=1,ltd.Rate*ltd.Quantity,ltd.Amount)ItemNetAmt,ltd.ItemName,ltd.SubCategoryID,  ");
                    sb.Append("                                 ltd.configID,(ltd.Rate*ltd.Quantity)ItemGrossAmt,ltd.Quantity,ltd.Rate FROM (   ");
                    sb.Append("                                         SELECT IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0    ");
                    sb.Append("                                         AND TransactionID=t1.TransactionID),0)NetBillAmt,   ");
                    sb.Append("                                         IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON   ");
                    sb.Append("                                         ltd.SubCategoryID = sc.SubCategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=0    ");
                    sb.Append("                                         AND ltd.TransactionID=t1.TransactionID   ");
                    sb.Append("                                         AND UCASE(sc.DisplayName)IN('MEDICINE & CONSUMABLES','PACKAGE MEDICINE','MEDICNE,INJECTION & CONSUMABLES')),0)MedAmt, 			  ");
                    sb.Append("                                         IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.BillNo,t1.Amountpaid,IFNULL(pmh.TDS,0)TDS,  ");
                    sb.Append("                                         IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.WriteOff,0)WriteOff,   ");
                    sb.Append("                                         IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,t1.TransactionID FROM (   ");
                    sb.Append("                                                 SELECT SUM(rt.AmountPaid)AmountPaid,t.TransactionID FROM f_reciept rt INNER JOIN (    ");
                    sb.Append("                                                         SELECT TransactionID,DATE FROM (     ");
                    sb.Append("                                                                 SELECT TransactionID,MAX(DATE)DATE FROM f_reciept WHERE IsCancel = 0     ");
                    sb.Append("                                                                 AND AsainstLedgerTnxNo='' GROUP BY TransactionID   ");
                    sb.Append("                                                         )aaa WHERE DATE(DATE) BETWEEN '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'   ");
                    sb.Append("                                                 )t ON t.TransactionID = rt.TransactionID WHERE rt.Iscancel=0 GROUP BY t.TransactionID   ");
                    sb.Append("                                         )t1 INNER JOIN Patient_MEdical_History adj ON adj.TransactionID = t1.TransactionID   ");
                    sb.Append("                                         INNER JOIN patient_medical_history pmh ON pmh.TransactionID = adj.TransactionID   ");
                    sb.Append("                                         WHERE  IFNULL(adj.BillNo,'')<>''  ");
                    sb.Append("                                         Having ABS(ROUND((NetBillAmt-DiscountOnBill))-ROUND((Amountpaid+TDS+Deduction_Acceptable+Deduction_NonAcceptable+WriteOff) ))<=4   ");
                    sb.Append("                                 )t2 INNER JOIN f_ledgertnxdetail ltd ON t2.TransactionID= ltd.TransactionID   ");
                    sb.Append("                                 INNER JOIN f_surgery_discription sd ON sd.LedgerTransactionNo = ltd.LedgerTransactionNo AND sd.ItemID = ltd.ItemID ");
                    sb.Append("                                 INNER JOIN f_surgery_doctor sdoc ON sd.SurgeryTransactionID = sdoc.SurgeryTransactionID AND sd.ItemID = sdoc.ItemID ");
                    sb.Append("                                 WHERE ltd.IsVerified=1 AND ltd.ConfigID =22  ");
                    sb.Append("                         )t4   ");

                    sb.Append("                 )t5 INNER JOIN patient_medical_history pmh ON t5.TransactionID = pmh.TransactionID   ");
                    sb.Append("                 INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID   ");
                    sb.Append("                 INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID   ");
                    sb.Append("                 LEFT JOIN doctor_master dm ON dm.DoctorID = t5.DoctorID   ");
                    sb.Append("       WHERE t5.DoctorID ='" + ddlDoctor.SelectedValue + "'     ");


                }

                sb.Append(" )t   ");
                sb.Append("  GROUP BY TransactionID  ");
            }

        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";

            DataColumn dc = new DataColumn();
            dc.ColumnName = "ItemType";
            dc.DefaultValue = ddlDoctor.SelectedItem.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + ucFromDate.Text + " To : " + ucToDate.Text;
            dt.Columns.Add(dc);

            //dc = new DataColumn();
            //dc.ColumnName = "Doctor";
            //dc.DefaultValue = ddlDoctor.SelectedItem.Text;
            //dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            dc.DefaultValue = Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd");
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;

            if (rdbtran.SelectedValue == "1")
            {
                if (rbtReportType.SelectedValue == "D")
                    Session["ReportName"] = "DocSharePayoutDocCollection_Detail";
                else
                    Session["ReportName"] = "DocSharePayoutDocCollection_Summary";

                //ds.WriteXml("c:/ujjdocCollectionSum.xml");
            }
            else
            {
                if (rbtReportType.SelectedValue == "D")
                    Session["ReportName"] = "DocSharePayoutDocCollection_Detail_Receipt";
                else
                    Session["ReportName"] = "DocSharePayoutDocCollection_Summary_Receipt";

                //ds.WriteXml("c:/ujjdocCollectionSum_Receipt.xml");

            }

            if (chkdoctorwise.Checked)
            {
                Session["ReportName"] = "DocSharePayoutDocCollection_Summary_ReceiptDoctorWise";

            }

            //Session["dtExport2Excel"] = dt;
            //Session["ReportName"] = "Doc-Collection";
            //Session["Period"] = "As on : " + DateTime.Now.ToString("dd-MM-yyyy");
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/CommonCrystalReportViewerOld.aspx');", true);


        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }

    protected void rbtReportType_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}
