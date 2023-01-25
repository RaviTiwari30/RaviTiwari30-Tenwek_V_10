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

public partial class Design_MIS_MISIPDDischargeAnalysis : System.Web.UI.Page
{
     
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {            
            txtFromDateC.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDateC.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            
            string DateFrom = "", DateTo = "", SelectionType = "", DateType = "1";

            if (Request.QueryString["DateFrom"] != null && Request.QueryString["DateFrom"].ToString() != "")
                DateFrom = Request.QueryString["DateFrom"].ToString();

            if (Request.QueryString["DateTo"] != null && Request.QueryString["DateTo"].ToString() != "")
                DateTo = Request.QueryString["DateTo"].ToString();

            if (Request.QueryString["SelectionType"] != null && Request.QueryString["SelectionType"].ToString() != "")
                SelectionType = Request.QueryString["SelectionType"].ToString();

            if (Request.QueryString["DateType"] != null && Request.QueryString["DateType"].ToString() != "")
                DateType = Request.QueryString["DateType"].ToString();

            ViewState["DateFrom"] = Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd");
            ViewState["DateTo"] = Util.GetDateTime(DateTo).ToString("yyyy-MM-dd");
            ViewState["SelectionType"] = SelectionType;
            ViewState["DateType"] = DateType;
            lblClickedC.Text = SelectionType;            
        }
    }
   
    #region Analysis

    protected void btnCompare_Click(object sender, EventArgs e)
    {
        TimeSpan ts1 = Util.GetDateTime(ViewState["DateTo"].ToString()).Date - Util.GetDateTime(ViewState["DateFrom"].ToString()).Date;
        TimeSpan ts2 = Util.GetDateTime(txtToDateC.Text).Date - Util.GetDateTime(txtFromDateC.Text).Date;

        ViewState["DateFrom"] = ViewState["DateFrom"].ToString();
        ViewState["DateTo"] = ViewState["DateTo"].ToString();
        ViewState["DateFromC"] = Util.GetDateTime(txtFromDateC.Text).ToString("yyyy-MM-dd");
        ViewState["DateToC"] = Util.GetDateTime(txtToDateC.Text).ToString("yyyy-MM-dd");        
        
        LoadComparisonData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), Util.GetDateTime(txtFromDateC.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDateC.Text).ToString("yyyy-MM-dd"), Util.GetString(ts1.Days+1), Util.GetString(ts2.Days+1), ViewState["DateType"].ToString(), "", "IPD", "", ViewState["SelectionType"].ToString());
        
        lblDocC.Visible = true;
        lblGroupC.Visible = true;
        lblItemwiseC.Visible = true;
        lblPanelC.Visible = true;

    }

    private void LoadComparisonData(string DateFrom, string DateTo, string CompDateFrom, string CompDateTo, string Days1, string Days2, string DateType, string TypeofTnx, string OPDIPD, string ConfigIds, string SelectionType)
    {
        if (OPDIPD == "IPD")
        {            
            LoadComparisonDataIPD(DateFrom, DateTo, CompDateFrom, CompDateTo, Days1, Days2);                      
            
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;
            ViewState["TypeofTnx"] = TypeofTnx;
            ViewState["SelectionType"] = SelectionType;
        }
    }

    private void LoadComparisonDataIPD(string DateFrom, string DateTo, string CompDateFrom, string CompDateTo, string Days1, string Days2)
    {
        string strQ = "";

        //For Doctor-wise
        strQ += "SELECT dm.Name,cast(COUNT(t.TransactionID) as decimal(6,1))Qty,t.DoctorID,CompType  FROM ( ";
        strQ += "    SELECT ich.TransactionID,pmh.DoctorID,pmh.PanelID,pmh.DischargeType,";
        strQ += "    if((DATE(ich.DateOfDischarge) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType FROM ipd_case_history ich  ";
        strQ += "    INNER JOIN patient_medical_history pmh ON ich.TransactionID = pmh.TransactionID  ";
        strQ += "    WHERE ich.status <>'CANCEL' ";
        strQ += "    AND (Date(DateOfDischarge) Between '" + DateFrom + "' AND  '" + DateTo + "') ";
        strQ += "    OR (Date(DateOfDischarge) Between '" + CompDateFrom + "' AND  '" + CompDateTo + "') ";
        strQ += ")t INNER JOIN doctor_master dm ON dm.DoctorID = t.DoctorID GROUP BY dm.DoctorID,CompType ";
        strQ += "ORDER BY dm.Name,CompType ";
        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            dt = MergeExtraRows(dt, "DoctorID", rbtViewType.SelectedValue, Days1, Days2);

            grdDocC.DataSource = dt;
            grdDocC.DataBind();
        }
        else
        {
            grdDocC.DataSource = null;
            grdDocC.DataBind();
        }


        //For Specialization-wise

        strQ = "";
        strQ += "SELECT dm.Specialization NAME,cast(COUNT(t.TransactionID) as decimal(6,1))Qty,dm.Specialization ItemID,CompType FROM ( ";
        strQ += "    SELECT ich.TransactionID,pmh.DoctorID,pmh.PanelID,pmh.DischargeType,";
        strQ += "    if((DATE(ich.DateOfDischarge) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType FROM ipd_case_history ich  ";
        strQ += "    INNER JOIN patient_medical_history pmh ON ich.TransactionID = pmh.TransactionID ";
        strQ += "    WHERE ich.status <>'CANCEL' ";
        strQ += "    AND (Date(DateOfDischarge) Between '" + DateFrom + "' AND  '" + DateTo + "') ";
        strQ += "    OR (Date(DateOfDischarge) Between '" + CompDateFrom + "' AND  '" + CompDateTo + "') ";
        strQ += ")t INNER JOIN doctor_master dm ON dm.DoctorID = t.DoctorID GROUP BY dm.Specialization,CompType ";
        strQ += "ORDER BY dm.Specialization,CompType ";

        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            dt = MergeExtraRows(dt, "ItemID", rbtViewType.SelectedValue, Days1, Days2);
            grdSpecC.DataSource = dt;
            grdSpecC.DataBind();

        }
        else
        {
            grdSpecC.DataSource = null;
            grdSpecC.DataBind();
        }

        //For DischargeType-wise

        strQ = "";
        strQ += "SELECT t.DischargeType Name,cast(COUNT(t.TransactionID) as decimal(6,1))Qty,t.DischargeType,CompType FROM ( ";
        strQ += "    SELECT ich.TransactionID,pmh.DoctorID,pmh.PanelID,pmh.DischargeType, ";
        strQ += "    if((DATE(ich.DateOfDischarge) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType FROM ipd_case_history ich  ";
        strQ += "    INNER JOIN patient_medical_history pmh ON ich.TransactionID = pmh.TransactionID ";
        strQ += "    WHERE ich.status <>'CANCEL' ";
        strQ += "    AND (Date(DateOfDischarge) Between '" + DateFrom + "' AND  '" + DateTo + "') ";
        strQ += "    OR (Date(DateOfDischarge) Between '" + CompDateFrom + "' AND  '" + CompDateTo + "') ";
        strQ += ")t GROUP BY t.DischargeType,CompType ";
        strQ += "ORDER BY t.DischargeType,CompType ";

        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            dt = MergeExtraRows(dt, "DischargeType", rbtViewType.SelectedValue, Days1, Days2);
            grdDischargeTypeC.DataSource = dt;
            grdDischargeTypeC.DataBind();

        }
        else
        {
            grdDischargeTypeC.DataSource = null;
            grdDischargeTypeC.DataBind();
        }


        //For Panel-wise

        strQ = "";
        strQ = "";
        strQ += "SELECT pnl.Company_Name NAME,cast(COUNT(t.TransactionID) as decimal(6,1))Qty,pnl.PanelID,CompType FROM ( ";
        strQ += "    SELECT ich.TransactionID,pmh.DoctorID,pmh.PanelID,pmh.DischargeType,";
        strQ += "    if((DATE(ich.DateOfDischarge) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType FROM ipd_case_history ich  ";
        strQ += "    INNER JOIN patient_medical_history pmh ON ich.TransactionID = pmh.TransactionID ";
        strQ += "    WHERE ich.status <>'CANCEL' ";
        strQ += "    AND (Date(DateOfDischarge) Between '" + DateFrom + "' AND  '" + DateTo + "') ";
        strQ += "    OR (Date(DateOfDischarge) Between '" + CompDateFrom + "' AND  '" + CompDateTo + "') ";
        strQ += ")t INNER JOIN f_panel_master pnl ON pnl.PanelID = t.PanelID GROUP BY pnl.PanelID,CompType ";
        strQ += "ORDER BY pnl.Company_Name,CompType ";
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            dt = MergeExtraRows(dt, "PanelID", rbtViewType.SelectedValue, Days1, Days2);
            grdPanelC.DataSource = dt;
            grdPanelC.DataBind();

        }
        else
        {
            grdPanelC.DataSource = null;
            grdPanelC.DataBind();
        }
    }

    private void LoadDocDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string DocID, string CompType)
    {
        string strQ = "";

        strQ = "SELECT pm.Pname PatientName,REPLACE(T1.TransactionID,'ISHHI','')IP_No, ";
        strQ += "REPLACE(T1.PatientID,'LSHHI','')MR_No, ";
        strQ += "concat(pm.Age,'/',if(ucase(pm.Gender)='MALE','M','F'))Age,pnl.Company_Name Panel, Date_Format(T1.DateOfAdmit,'%d-%b-%y')AdmitDate,";
        strQ += "T1.TimeOfAdmit AdmitTime,IF(T1.DateOfDischarge='0001-01-01','-',Date_Format(T1.DateOfDischarge,'%d-%b-%y'))DischargeDate,T1.TimeOfDischarge DischargeTime, ";
        strQ += "T1.DischargeType,T1.Status,dm.Name Cunsultant1, ";
        strQ += "Concat(IFNULL((SELECT Name from IPD_Case_Type_Master where IPDCaseType_ID=T1.AdmitCaseID),''),'/',";
        strQ += "ifnull((Select Bed_No from room_master where Room_ID=T1.AdmitRoomID),''))AdmittedIn, ";
        strQ += "Concat(IFNULL((SELECT Name from IPD_Case_Type_Master where IPDCaseType_ID=T1.DischargeCaseID),''),'/',";
        strQ += "IFNULL((Select Bed_No from room_master where Room_ID=T1.DischargeRoomID),''))DischargeFrom, ";
        strQ += "IF(T1.DateOfDischarge='0001-01-01',DATEDIFF(CURDATE(),T1.DateOfAdmit)+1,DATEDIFF(T1.DateOfDischarge,T1.DateOfAdmit)+1)DatewiseStay, ";
        strQ += "TIMESTAMPDIFF(HOUR,CONCAT(T1.DateOfAdmit,' ',T1.TimeOfAdmit),IF(T1.DateOfDischarge='0001-01-01',NOW(),CONCAT(T1.DateOfDischarge,' ',T1.TimeOfDischarge)))HourlyStay, ";
        strQ += "ROUND((TIMESTAMPDIFF(HOUR,CONCAT(T1.DateOfAdmit,' ',T1.TimeOfAdmit),IF(T1.DateOfDischarge='0001-01-01',NOW(),CONCAT(T1.DateOfDischarge,' ',T1.TimeOfDischarge)))/24),1)ActualDayStay, ";
        strQ += "Round(TotalBilledAmt)TotalBilledAmt,Round(ItemWiseDiscount+DiscountOnBill)TotalDiscount,";
        strQ += "Round((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill)))NetBillAmount,";
        strQ += "Round(ReceiveAmt)ReceiveAmt,";
        strQ += "Round((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+Deduction_Acceptable+ReceiveAmt+TDS+WriteOff)) As OutStanding ";
        strQ += "FROM  (";
        strQ += "   SELECT pip.IPDCaseType_ID DischargeCaseID,pip.Room_ID DischargeRoomID,pip1.IPDCaseType_ID AdmitCaseID, ";
        strQ += "   pip1.Room_ID AdmitRoomID,T.* FROM  ( ";
        strQ += "       SELECT MAX(pip.PatientIPDProfile_ID)MaxPatientIPDProfile_ID, ";
        strQ += "       MIN(pip.PatientIPDProfile_ID)MinPatientIPDProfile_ID, pmh.PatientID,ich.TransactionID, ";
        strQ += "       pmh.PanelID,ich.DateOfAdmit,ich.TimeOfAdmit, ich.DateOfDischarge,ich.TimeOfDischarge, ";
        strQ += "       pmh.DoctorID,pmh.DoctorID1,ich.Status,pmh.DischargeType, ";
        strQ += "       IF(UCASE(ich.Status)<>'CANCEL',";
        strQ += "       (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON ";
        strQ += "       lt.LedgertransactionNo = ltd.LedgertransactionNo ";
        strQ += "       INNER JOIN f_Itemmaster im ON im.ItemID = Ltd.ItemID ";
        strQ += "       WHERE ltd.TransactionID = ich.TransactionID AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 ";
        strQ += "       GROUP BY ltd.TransactionID),0)TotalBilledAmt,";
        strQ += "       IFNULL((Select DiscountOnBill from f_ipdAdjustment where TransactionID=pmh.TransactionID),0)DiscountOnBill,";
        strQ += "       IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =ich.TransactionID ";
        strQ += "       AND IsCancel = 0 GROUP BY TransactionID),0)ReceiveAmt,";
        strQ += "       Cast(IFNULL((Select sum(AmountPaid) from f_reciept where TransactionID =ich.TransactionID and IsCancel = 0 and AmountPaid >0 group by ich.TransactionID),0) as DECIMAL(15,2))TotalDeposit,";
        strQ += "       Cast(IFNULL((Select Replace(sum(AmountPaid),'-','') from f_reciept where TransactionID =ich.TransactionID and IsCancel = 0 and AmountPaid <0 group by ich.TransactionID),0) as DECIMAL(15,2))TotalRefund,";
        strQ += "       IF(UCASE(ich.Status)<>'CANCEL',IFNULL((SELECT SUM(((Rate*Quantity)*DiscountPercentage)/100) FROM f_ledgertnxdetail ";
        strQ += "       WHERE TransactionID = ich.TransactionID AND IsVerified = 1 AND IsPackage = 0 ";
        strQ += "       GROUP BY TransactionID),0),0)ItemWiseDiscount,ifnull(pmh.TDS,0)TDS, ";
        strQ += "       IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,ifnull(pmh.WriteOff,0)WriteOff ";
        strQ += "       FROM ipd_case_history ich  INNER JOIN patient_medical_history pmh ";
        strQ += "       ON ich.TransactionID = pmh.TransactionID  INNER JOIN patient_ipd_profile pip ";
        strQ += "       ON ich.TransactionID = pip.TransactionID ";
        
        if(CompType=="1")
            strQ += "       WHERE Date(ich.DateOfDischarge) >='" + DateFrom + "' AND  Date(ich.DateOfDischarge) <='" + DateTo + "' ";
        else
            strQ += "       WHERE Date(ich.DateOfDischarge) >='" + DateFromC + "' AND  Date(ich.DateOfDischarge) <='" + DateToC + "' ";
        
        strQ += "       AND ich.Consultant_ID='" + DocID + "' ";
        strQ += "       AND ich.status <> 'cancel'  GROUP BY pip.TransactionID ";
        strQ += "   ) T  INNER JOIN patient_ipd_profile pip ON T.MaxPatientIPDProfile_ID = pip.PatientIPDProfile_ID ";
        strQ += "   INNER JOIN patient_ipd_profile pip1 ON T.MinPatientIPDProfile_ID = pip1.PatientIPDProfile_ID ";
        strQ += ")T1  INNER JOIN patient_master pm ON pm.PatientID = T1.PatientID ";
        strQ += "INNER JOIN doctor_master dm ON dm.DoctorID = T1.DoctorID ";
        strQ += "INNER JOIN f_panel_master pnl ON pnl.PanelID = T1.PanelID ";
        strQ += "ORDER BY T1.TransactionID ";

        DataTable dt = StockReports.GetDataTable(strQ);
        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetails.DataSource = dt;
            grdDetails.DataBind();
            ((Label)grdDetails.FooterRow.FindControl("lblTotalBilledAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalBilledAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTotalDiscountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalDiscount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblNetBillAmountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(NetBillAmount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblReceiveAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(ReceiveAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblOutStandingT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(OutStanding)", ""))));
        }
        else
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();
        }

    }

    private void LoadItemDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string ItemID, string CompType)
    {
        string strQ = "";
        strQ = "SELECT pm.Pname PatientName,REPLACE(T1.TransactionID,'ISHHI','')IP_No, ";
        strQ += "REPLACE(T1.PatientID,'LSHHI','')MR_No, ";
        strQ += "concat(pm.Age,'/',if(ucase(pm.Gender)='MALE','M','F'))Age,pnl.Company_Name Panel, Date_Format(T1.DateOfAdmit,'%d-%b-%y')AdmitDate,";
        strQ += "T1.TimeOfAdmit AdmitTime,IF(T1.DateOfDischarge='0001-01-01','-',Date_Format(T1.DateOfDischarge,'%d-%b-%y'))DischargeDate,T1.TimeOfDischarge DischargeTime, ";
        strQ += "T1.DischargeType,T1.Status,dm.Name Cunsultant1, ";
        strQ += "Concat(IFNULL((SELECT Name from IPD_Case_Type_Master where IPDCaseType_ID=T1.AdmitCaseID),''),'/',";
        strQ += "ifnull((Select Bed_No from room_master where Room_ID=T1.AdmitRoomID),''))AdmittedIn, ";
        strQ += "Concat(IFNULL((SELECT Name from IPD_Case_Type_Master where IPDCaseType_ID=T1.DischargeCaseID),''),'/',";
        strQ += "IFNULL((Select Bed_No from room_master where Room_ID=T1.DischargeRoomID),''))DischargeFrom, ";
        strQ += "IF(T1.DateOfDischarge='0001-01-01',DATEDIFF(CURDATE(),T1.DateOfAdmit)+1,DATEDIFF(T1.DateOfDischarge,T1.DateOfAdmit)+1)DatewiseStay, ";
        strQ += "TIMESTAMPDIFF(HOUR,CONCAT(T1.DateOfAdmit,' ',T1.TimeOfAdmit),IF(T1.DateOfDischarge='0001-01-01',NOW(),CONCAT(T1.DateOfDischarge,' ',T1.TimeOfDischarge)))HourlyStay, ";
        strQ += "ROUND((TIMESTAMPDIFF(HOUR,CONCAT(T1.DateOfAdmit,' ',T1.TimeOfAdmit),IF(T1.DateOfDischarge='0001-01-01',NOW(),CONCAT(T1.DateOfDischarge,' ',T1.TimeOfDischarge)))/24),1)ActualDayStay, ";
        strQ += "Round(TotalBilledAmt)TotalBilledAmt,Round(ItemWiseDiscount+DiscountOnBill)TotalDiscount,";
        strQ += "Round((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill)))NetBillAmount,";
        strQ += "Round(ReceiveAmt)ReceiveAmt,";
        strQ += "Round((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+Deduction_Acceptable+ReceiveAmt+TDS+WriteOff)) As OutStanding ";
        strQ += "FROM  (";
        strQ += "   SELECT pip.IPDCaseType_ID DischargeCaseID,pip.Room_ID DischargeRoomID,pip1.IPDCaseType_ID AdmitCaseID, ";
        strQ += "   pip1.Room_ID AdmitRoomID,T.* FROM  ( ";
        strQ += "       SELECT MAX(pip.PatientIPDProfile_ID)MaxPatientIPDProfile_ID, ";
        strQ += "       MIN(pip.PatientIPDProfile_ID)MinPatientIPDProfile_ID, pmh.PatientID,ich.TransactionID, ";
        strQ += "       pmh.PanelID,ich.DateOfAdmit,ich.TimeOfAdmit, ich.DateOfDischarge,ich.TimeOfDischarge, ";
        strQ += "       pmh.DoctorID,pmh.DoctorID1,ich.Status,pmh.DischargeType, ";
        strQ += "       IF(UCASE(ich.Status)<>'CANCEL',";
        strQ += "       (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON ";
        strQ += "       lt.LedgertransactionNo = ltd.LedgertransactionNo ";
        strQ += "       INNER JOIN f_Itemmaster im ON im.ItemID = Ltd.ItemID ";
        strQ += "       WHERE ltd.TransactionID = ich.TransactionID AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 ";
        strQ += "       GROUP BY ltd.TransactionID),0)TotalBilledAmt,";
        strQ += "       IFNULL((Select DiscountOnBill from f_ipdAdjustment where TransactionID=pmh.TransactionID),0)DiscountOnBill,";
        strQ += "       IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =ich.TransactionID ";
        strQ += "       AND IsCancel = 0 GROUP BY TransactionID),0)ReceiveAmt,";
        strQ += "       Cast(IFNULL((Select sum(AmountPaid) from f_reciept where TransactionID =ich.TransactionID and IsCancel = 0 and AmountPaid >0 group by ich.TransactionID),0) as DECIMAL(15,2))TotalDeposit,";
        strQ += "       Cast(IFNULL((Select Replace(sum(AmountPaid),'-','') from f_reciept where TransactionID =ich.TransactionID and IsCancel = 0 and AmountPaid <0 group by ich.TransactionID),0) as DECIMAL(15,2))TotalRefund,";
        strQ += "       IF(UCASE(ich.Status)<>'CANCEL',IFNULL((SELECT SUM(((Rate*Quantity)*DiscountPercentage)/100) FROM f_ledgertnxdetail ";
        strQ += "       WHERE TransactionID = ich.TransactionID AND IsVerified = 1 AND IsPackage = 0 ";
        strQ += "       GROUP BY TransactionID),0),0)ItemWiseDiscount,ifnull(pmh.TDS,0)TDS, ";
        strQ += "       IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,ifnull(pmh.WriteOff,0)WriteOff ";
        strQ += "       FROM ipd_case_history ich  INNER JOIN patient_medical_history pmh ";
        strQ += "       ON ich.TransactionID = pmh.TransactionID  INNER JOIN patient_ipd_profile pip ";
        strQ += "       ON ich.TransactionID = pip.TransactionID ";
        if (CompType == "1")
            strQ += "       WHERE Date(ich.DateOfDischarge) >='" + DateFrom + "' AND  Date(ich.DateOfDischarge) <='" + DateTo + "' ";
        else
            strQ += "       WHERE Date(ich.DateOfDischarge) >='" + DateFromC + "' AND  Date(ich.DateOfDischarge) <='" + DateToC + "' ";
        strQ += "       AND ich.status <> 'cancel'  GROUP BY pip.TransactionID ";
        strQ += "   ) T  INNER JOIN patient_ipd_profile pip ON T.MaxPatientIPDProfile_ID = pip.PatientIPDProfile_ID ";
        strQ += "   INNER JOIN patient_ipd_profile pip1 ON T.MinPatientIPDProfile_ID = pip1.PatientIPDProfile_ID ";
        strQ += ")T1  INNER JOIN patient_master pm ON pm.PatientID = T1.PatientID ";
        strQ += "INNER JOIN doctor_master dm ON dm.DoctorID = T1.DoctorID ";
        strQ += "INNER JOIN f_panel_master pnl ON pnl.PanelID = T1.PanelID ";
        strQ += "Where dm.Specialization = '" + ItemID + "' ";
        strQ += "ORDER BY T1.TransactionID ";
        DataTable dt = StockReports.GetDataTable(strQ);

        strQ = "";

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetails.DataSource = dt;
            grdDetails.DataBind();
            ((Label)grdDetails.FooterRow.FindControl("lblTotalBilledAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalBilledAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTotalDiscountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalDiscount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblNetBillAmountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(NetBillAmount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblReceiveAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(ReceiveAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblOutStandingT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(OutStanding)", ""))));
        }
        else
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();
        }

    }

    private void LoadDischargeTypeDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string DischargeType, string CompType)
    {
        string strQ = "";
        strQ = "SELECT pm.Pname PatientName,REPLACE(T1.TransactionID,'ISHHI','')IP_No, ";
        strQ += "REPLACE(T1.PatientID,'LSHHI','')MR_No, ";
        strQ += "concat(pm.Age,'/',if(ucase(pm.Gender)='MALE','M','F'))Age,pnl.Company_Name Panel, Date_Format(T1.DateOfAdmit,'%d-%b-%y')AdmitDate,";
        strQ += "T1.TimeOfAdmit AdmitTime,IF(T1.DateOfDischarge='0001-01-01','-',Date_Format(T1.DateOfDischarge,'%d-%b-%y'))DischargeDate,T1.TimeOfDischarge DischargeTime, ";
        strQ += "T1.DischargeType,T1.Status,dm.Name Cunsultant1, ";
        strQ += "Concat(IFNULL((SELECT Name from IPD_Case_Type_Master where IPDCaseType_ID=T1.AdmitCaseID),''),'/',";
        strQ += "ifnull((Select Bed_No from room_master where Room_ID=T1.AdmitRoomID),''))AdmittedIn, ";
        strQ += "Concat(IFNULL((SELECT Name from IPD_Case_Type_Master where IPDCaseType_ID=T1.DischargeCaseID),''),'/',";
        strQ += "IFNULL((Select Bed_No from room_master where Room_ID=T1.DischargeRoomID),''))DischargeFrom, ";
        strQ += "IF(T1.DateOfDischarge='0001-01-01',DATEDIFF(CURDATE(),T1.DateOfAdmit)+1,DATEDIFF(T1.DateOfDischarge,T1.DateOfAdmit)+1)DatewiseStay, ";
        strQ += "TIMESTAMPDIFF(HOUR,CONCAT(T1.DateOfAdmit,' ',T1.TimeOfAdmit),IF(T1.DateOfDischarge='0001-01-01',NOW(),CONCAT(T1.DateOfDischarge,' ',T1.TimeOfDischarge)))HourlyStay, ";
        strQ += "ROUND((TIMESTAMPDIFF(HOUR,CONCAT(T1.DateOfAdmit,' ',T1.TimeOfAdmit),IF(T1.DateOfDischarge='0001-01-01',NOW(),CONCAT(T1.DateOfDischarge,' ',T1.TimeOfDischarge)))/24),1)ActualDayStay, ";
        strQ += "Round(TotalBilledAmt)TotalBilledAmt,Round(ItemWiseDiscount+DiscountOnBill)TotalDiscount,";
        strQ += "Round((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill)))NetBillAmount,";
        strQ += "Round(ReceiveAmt)ReceiveAmt,";
        strQ += "Round((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+Deduction_Acceptable+ReceiveAmt+TDS+WriteOff)) As OutStanding ";
        strQ += "FROM  (";
        strQ += "   SELECT pip.IPDCaseType_ID DischargeCaseID,pip.Room_ID DischargeRoomID,pip1.IPDCaseType_ID AdmitCaseID, ";
        strQ += "   pip1.Room_ID AdmitRoomID,T.* FROM  ( ";
        strQ += "       SELECT MAX(pip.PatientIPDProfile_ID)MaxPatientIPDProfile_ID, ";
        strQ += "       MIN(pip.PatientIPDProfile_ID)MinPatientIPDProfile_ID, pmh.PatientID,ich.TransactionID, ";
        strQ += "       pmh.PanelID,ich.DateOfAdmit,ich.TimeOfAdmit, ich.DateOfDischarge,ich.TimeOfDischarge, ";
        strQ += "       pmh.DoctorID,pmh.DoctorID1,ich.Status,pmh.DischargeType, ";
        strQ += "       IF(UCASE(ich.Status)<>'CANCEL',";
        strQ += "       (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON ";
        strQ += "       lt.LedgertransactionNo = ltd.LedgertransactionNo ";
        strQ += "       INNER JOIN f_Itemmaster im ON im.ItemID = Ltd.ItemID ";
        strQ += "       WHERE ltd.TransactionID = ich.TransactionID AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 ";
        strQ += "       GROUP BY ltd.TransactionID),0)TotalBilledAmt,";
        strQ += "       IFNULL((Select DiscountOnBill from f_ipdAdjustment where TransactionID=pmh.TransactionID),0)DiscountOnBill,";
        strQ += "       IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =ich.TransactionID ";
        strQ += "       AND IsCancel = 0 GROUP BY TransactionID),0)ReceiveAmt,";
        strQ += "       Cast(IFNULL((Select sum(AmountPaid) from f_reciept where TransactionID =ich.TransactionID and IsCancel = 0 and AmountPaid >0 group by ich.TransactionID),0) as DECIMAL(15,2))TotalDeposit,";
        strQ += "       Cast(IFNULL((Select Replace(sum(AmountPaid),'-','') from f_reciept where TransactionID =ich.TransactionID and IsCancel = 0 and AmountPaid <0 group by ich.TransactionID),0) as DECIMAL(15,2))TotalRefund,";
        strQ += "       IF(UCASE(ich.Status)<>'CANCEL',IFNULL((SELECT SUM(((Rate*Quantity)*DiscountPercentage)/100) FROM f_ledgertnxdetail ";
        strQ += "       WHERE TransactionID = ich.TransactionID AND IsVerified = 1 AND IsPackage = 0 ";
        strQ += "       GROUP BY TransactionID),0),0)ItemWiseDiscount,ifnull(pmh.TDS,0)TDS, ";
        strQ += "       IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,ifnull(pmh.WriteOff,0)WriteOff ";
        strQ += "       FROM ipd_case_history ich  INNER JOIN patient_medical_history pmh ";
        strQ += "       ON ich.TransactionID = pmh.TransactionID  INNER JOIN patient_ipd_profile pip ";
        strQ += "       ON ich.TransactionID = pip.TransactionID ";
        if (CompType == "1")
            strQ += "       WHERE Date(ich.DateOfDischarge) >='" + DateFrom + "' AND  Date(ich.DateOfDischarge) <='" + DateTo + "' ";
        else
            strQ += "       WHERE Date(ich.DateOfDischarge) >='" + DateFromC + "' AND  Date(ich.DateOfDischarge) <='" + DateToC + "' ";
        strQ += "       AND pmh.DischargeType='" + DischargeType + "' ";
        strQ += "       AND ich.status <> 'cancel'  GROUP BY pip.TransactionID ";
        strQ += "   ) T  INNER JOIN patient_ipd_profile pip ON T.MaxPatientIPDProfile_ID = pip.PatientIPDProfile_ID ";
        strQ += "   INNER JOIN patient_ipd_profile pip1 ON T.MinPatientIPDProfile_ID = pip1.PatientIPDProfile_ID ";
        strQ += ")T1  INNER JOIN patient_master pm ON pm.PatientID = T1.PatientID ";
        strQ += "INNER JOIN doctor_master dm ON dm.DoctorID = T1.DoctorID ";
        strQ += "INNER JOIN f_panel_master pnl ON pnl.PanelID = T1.PanelID ";
        strQ += "ORDER BY T1.TransactionID ";

        DataTable dt = StockReports.GetDataTable(strQ);

        strQ = "";

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetails.DataSource = dt;
            grdDetails.DataBind();
            ((Label)grdDetails.FooterRow.FindControl("lblTotalBilledAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalBilledAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTotalDiscountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalDiscount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblNetBillAmountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(NetBillAmount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblReceiveAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(ReceiveAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblOutStandingT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(OutStanding)", ""))));
        }
        else
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();
        }

    }

    private void LoadPanelDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string PanelID, string CompType)
    {
        string strQ = "";
        strQ = "SELECT pm.Pname PatientName,REPLACE(T1.TransactionID,'ISHHI','')IP_No, ";
        strQ += "REPLACE(T1.PatientID,'LSHHI','')MR_No, ";
        strQ += "concat(pm.Age,'/',if(ucase(pm.Gender)='MALE','M','F'))Age,pnl.Company_Name Panel, Date_Format(T1.DateOfAdmit,'%d-%b-%y')AdmitDate,";
        strQ += "T1.TimeOfAdmit AdmitTime,IF(T1.DateOfDischarge='0001-01-01','-',Date_Format(T1.DateOfDischarge,'%d-%b-%y'))DischargeDate,T1.TimeOfDischarge DischargeTime, ";
        strQ += "T1.DischargeType,T1.Status,dm.Name Cunsultant1, ";
        strQ += "Concat(IFNULL((SELECT Name from IPD_Case_Type_Master where IPDCaseType_ID=T1.AdmitCaseID),''),'/',";
        strQ += "ifnull((Select Bed_No from room_master where Room_ID=T1.AdmitRoomID),''))AdmittedIn, ";
        strQ += "Concat(IFNULL((SELECT Name from IPD_Case_Type_Master where IPDCaseType_ID=T1.DischargeCaseID),''),'/',";
        strQ += "IFNULL((Select Bed_No from room_master where Room_ID=T1.DischargeRoomID),''))DischargeFrom, ";
        strQ += "IF(T1.DateOfDischarge='0001-01-01',DATEDIFF(CURDATE(),T1.DateOfAdmit)+1,DATEDIFF(T1.DateOfDischarge,T1.DateOfAdmit)+1)DatewiseStay, ";
        strQ += "TIMESTAMPDIFF(HOUR,CONCAT(T1.DateOfAdmit,' ',T1.TimeOfAdmit),IF(T1.DateOfDischarge='0001-01-01',NOW(),CONCAT(T1.DateOfDischarge,' ',T1.TimeOfDischarge)))HourlyStay, ";
        strQ += "ROUND((TIMESTAMPDIFF(HOUR,CONCAT(T1.DateOfAdmit,' ',T1.TimeOfAdmit),IF(T1.DateOfDischarge='0001-01-01',NOW(),CONCAT(T1.DateOfDischarge,' ',T1.TimeOfDischarge)))/24),1)ActualDayStay, ";
        strQ += "Round(TotalBilledAmt)TotalBilledAmt,Round(ItemWiseDiscount+DiscountOnBill)TotalDiscount,";
        strQ += "Round((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill)))NetBillAmount,";
        strQ += "Round(ReceiveAmt)ReceiveAmt,";
        strQ += "Round((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+Deduction_Acceptable+ReceiveAmt+TDS+WriteOff)) As OutStanding ";
        strQ += "FROM  (";
        strQ += "   SELECT pip.IPDCaseType_ID DischargeCaseID,pip.Room_ID DischargeRoomID,pip1.IPDCaseType_ID AdmitCaseID, ";
        strQ += "   pip1.Room_ID AdmitRoomID,T.* FROM  ( ";
        strQ += "       SELECT MAX(pip.PatientIPDProfile_ID)MaxPatientIPDProfile_ID, ";
        strQ += "       MIN(pip.PatientIPDProfile_ID)MinPatientIPDProfile_ID, pmh.PatientID,ich.TransactionID, ";
        strQ += "       pmh.PanelID,ich.DateOfAdmit,ich.TimeOfAdmit, ich.DateOfDischarge,ich.TimeOfDischarge, ";
        strQ += "       pmh.DoctorID,pmh.DoctorID1,ich.Status,pmh.DischargeType, ";
        strQ += "       IF(UCASE(ich.Status)<>'CANCEL',";
        strQ += "       (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON ";
        strQ += "       lt.LedgertransactionNo = ltd.LedgertransactionNo ";
        strQ += "       INNER JOIN f_Itemmaster im ON im.ItemID = Ltd.ItemID ";
        strQ += "       WHERE ltd.TransactionID = ich.TransactionID AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 ";
        strQ += "       GROUP BY ltd.TransactionID),0)TotalBilledAmt,";
        strQ += "       IFNULL((Select DiscountOnBill from f_ipdAdjustment where TransactionID=pmh.TransactionID),0)DiscountOnBill,";
        strQ += "       IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =ich.TransactionID ";
        strQ += "       AND IsCancel = 0 GROUP BY TransactionID),0)ReceiveAmt,";
        strQ += "       Cast(IFNULL((Select sum(AmountPaid) from f_reciept where TransactionID =ich.TransactionID and IsCancel = 0 and AmountPaid >0 group by ich.TransactionID),0) as DECIMAL(15,2))TotalDeposit,";
        strQ += "       Cast(IFNULL((Select Replace(sum(AmountPaid),'-','') from f_reciept where TransactionID =ich.TransactionID and IsCancel = 0 and AmountPaid <0 group by ich.TransactionID),0) as DECIMAL(15,2))TotalRefund,";
        strQ += "       IF(UCASE(ich.Status)<>'CANCEL',IFNULL((SELECT SUM(((Rate*Quantity)*DiscountPercentage)/100) FROM f_ledgertnxdetail ";
        strQ += "       WHERE TransactionID = ich.TransactionID AND IsVerified = 1 AND IsPackage = 0 ";
        strQ += "       GROUP BY TransactionID),0),0)ItemWiseDiscount,ifnull(pmh.TDS,0)TDS, ";
        strQ += "       IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable,IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,ifnull(pmh.WriteOff,0)WriteOff ";
        strQ += "       FROM ipd_case_history ich  INNER JOIN patient_medical_history pmh ";
        strQ += "       ON ich.TransactionID = pmh.TransactionID  INNER JOIN patient_ipd_profile pip ";
        strQ += "       ON ich.TransactionID = pip.TransactionID ";
        if (CompType == "1")
            strQ += "       WHERE Date(ich.DateOfDischarge) >='" + DateFrom + "' AND  Date(ich.DateOfDischarge) <='" + DateTo + "' ";
        else
            strQ += "       WHERE Date(ich.DateOfDischarge) >='" + DateFromC + "' AND  Date(ich.DateOfDischarge) <='" + DateToC + "' ";
        strQ += "       AND pmh.PanelID=" + PanelID + " ";
        strQ += "       AND ich.status <> 'cancel'  GROUP BY pip.TransactionID ";
        strQ += "   ) T  INNER JOIN patient_ipd_profile pip ON T.MaxPatientIPDProfile_ID = pip.PatientIPDProfile_ID ";
        strQ += "   INNER JOIN patient_ipd_profile pip1 ON T.MinPatientIPDProfile_ID = pip1.PatientIPDProfile_ID ";
        strQ += ")T1  INNER JOIN patient_master pm ON pm.PatientID = T1.PatientID ";
        strQ += "INNER JOIN doctor_master dm ON dm.DoctorID = T1.DoctorID ";
        strQ += "INNER JOIN f_panel_master pnl ON pnl.PanelID = T1.PanelID ";
        strQ += "ORDER BY T1.TransactionID ";
        DataTable dt = StockReports.GetDataTable(strQ);

        strQ = "";

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetails.DataSource = dt;
            grdDetails.DataBind();
            ((Label)grdDetails.FooterRow.FindControl("lblTotalBilledAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalBilledAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTotalDiscountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalDiscount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblNetBillAmountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(NetBillAmount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblReceiveAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(ReceiveAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblOutStandingT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(OutStanding)", ""))));
        }
        else
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();
        }
    }

    private DataTable MergeExtraRows(DataTable dtMain, string GroupingID,string ViewType,string Days1,string Days2)
    {
        dtMain.Columns.Add("QtyGrowth");

        if(ViewType =="1")
            dtMain = GetActialCompFigure(dtMain,GroupingID);
        else
            dtMain = GetAvgPerDayData(dtMain,GroupingID, Days1, Days2);

        return dtMain;
    }

    private DataTable GetActialCompFigure(DataTable dtMain, string GroupingID)
    {

        for (int i = 0; i < dtMain.Rows.Count; i++)
        {
            DataRow[] drFound = dtMain.Select(GroupingID + "='" + dtMain.Rows[i][GroupingID].ToString() + "'");

            if (drFound.Length == 1)
            {
                //Adding a new row (copy of this dr having qty,gross,net,disc,collected with zero value

                DataRow drNewRow = dtMain.NewRow();
                drNewRow.ItemArray = dtMain.Rows[i].ItemArray;

                drNewRow["Qty"] = "0";                

                //Defining Growth for Color Coding
                
                drNewRow["QtyGrowth"] = "N";
                dtMain.Rows[i]["QtyGrowth"] = "Y";                

                if (drNewRow["CompType"].ToString() == "1")
                    drNewRow["CompType"] = "2";
                else
                    drNewRow["CompType"] = "1";

                dtMain.Rows.InsertAt(drNewRow, i + 1);

                // Adding New Row to Calculate the Average of above Two Rows

                drNewRow = dtMain.NewRow();
                drNewRow.ItemArray = dtMain.Rows[i].ItemArray;

                drNewRow["Name"] = "Difference Total :";
                drNewRow["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Qty"]), 2));
                drNewRow["CompType"] = Util.GetString("3");

                if (dtMain.Rows[i]["CompType"].ToString() == "2")
                {
                    if (dtMain.Rows[i]["QtyGrowth"].ToString() == "N")
                        drNewRow["Qty"] = Util.GetString(Util.GetDecimal(drNewRow["Qty"]) * (-1));
                    
                }

                dtMain.Rows.InsertAt(drNewRow, i + 2);

                dtMain.AcceptChanges();
            }
            else if (drFound.Length == 2)
            {

                // Adding New Row to Calculate the Average of above Two Rows

                DataRow drNewRow = dtMain.NewRow();

                // Setting max Qty as Growth

                if (Util.GetString(drFound[0]["CompType"]) == "2")
                {
                    drNewRow.ItemArray = drFound[0].ItemArray;        

                    drNewRow["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Qty"]) - Util.GetDecimal(drFound[1]["Qty"]), 2));
                    drNewRow["CompType"] = Util.GetString("3");
                }
                else
                {
                    drNewRow.ItemArray = drFound[0].ItemArray;                    

                    drNewRow["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Qty"]) - Util.GetDecimal(drFound[0]["Qty"]), 2));
                    drNewRow["CompType"] = Util.GetString("3");
                }

                drNewRow["Name"] = "Difference Total :";

                if (Util.GetDecimal(drNewRow["Qty"]) >= 0)
                    drNewRow["QtyGrowth"] = "Y";
                else
                    drNewRow["QtyGrowth"] = "N";                

                dtMain.Rows.InsertAt(drNewRow, i + 2);

                dtMain.AcceptChanges();

            }
        }

        //Sorting Data on GroupID,CompType

        DataView dv = dtMain.DefaultView;
        dv.Sort = GroupingID + ",CompType";
        dtMain = dv.ToTable();

        //Adding Total for each Type

        DataRow dr = dtMain.NewRow();
        dr[0] = "Total of Ist Period";
        dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Qty)", "CompType=1"))));
        dr["CompType"] = Util.GetString("1");
        dtMain.Rows.InsertAt(dr, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr1 = dtMain.NewRow();
        dr1[0] = "Total of 2nd Period";
        dr1["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Qty)", "CompType=2"))));
        dr1["CompType"] = Util.GetString("2");
        dtMain.Rows.InsertAt(dr1, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr2 = dtMain.NewRow();
        dr2[0] = "Total Difference";
        dr2["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["Qty"]) - Util.GetDecimal(dr["Qty"])));
        dr2["CompType"] = Util.GetString("3");

        if (Util.GetDecimal(dr2["Qty"]) >= 0)
            dr2["QtyGrowth"] = "Y";
        else
            dr2["QtyGrowth"] = "N";

        dtMain.Rows.InsertAt(dr2, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        return dtMain;       
    }

    private DataTable GetAvgPerDayData(DataTable dtMain, string GroupingID, string Days1, string Days2)
    {
        for (int i = 0; i < dtMain.Rows.Count; i++)
        {
            DataRow[] drFound = dtMain.Select(GroupingID + "='" + dtMain.Rows[i][GroupingID].ToString() + "'");

            if (drFound.Length == 1)
            {
                //Adding a new row (copy of this dr having qty,gross,net,disc,collected with zero value

                DataRow drNewRow = dtMain.NewRow();
                drNewRow.ItemArray = dtMain.Rows[i].ItemArray;

                drNewRow["Qty"] = "0";                

                //Putting Avg per Day for each field

                dtMain.Rows[i]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Qty"]) / Util.GetDecimal(Days2),2));
                
                //Defining Growth for Color Coding
                
                drNewRow["QtyGrowth"] = "N";                
                dtMain.Rows[i]["QtyGrowth"] = "Y";
                
                if (drNewRow["CompType"].ToString() == "1")
                    drNewRow["CompType"] = "2";
                else
                    drNewRow["CompType"] = "1";

                dtMain.Rows.InsertAt(drNewRow, i + 1);

                // Adding New Row to Calculate the Average of above Two Rows

                drNewRow = dtMain.NewRow();
                drNewRow.ItemArray = dtMain.Rows[i].ItemArray;

                drNewRow["Name"] = "Total Growth/Decline in Percentage:";

                if (drNewRow["CompType"].ToString() == "1")
                {
                    drNewRow["Qty"] = "100";                    
                }
                else
                {
                    drNewRow["Qty"] = "0";                    
                }

                drNewRow["CompType"] = Util.GetString("3");

                if (dtMain.Rows[i]["CompType"].ToString() == "2")
                {
                    if (dtMain.Rows[i]["QtyGrowth"].ToString() == "N")
                        drNewRow["Qty"] = Util.GetString(Util.GetDecimal(drNewRow["Qty"]) * (-1));
                    
                }

                dtMain.Rows.InsertAt(drNewRow, i + 2);

                dtMain.AcceptChanges();
            }
            else if (drFound.Length == 2)
            {

                // Adding New Row to Calculate the Average of above Two Rows

                DataRow drNewRow = dtMain.NewRow();

                // Setting max Qty as Growth

                if (Util.GetString(drFound[0]["CompType"]) == "2")
                {
                    //Avg Per Day of 2nd Period
                    drFound[0]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Qty"]) / Util.GetDecimal(Days2)));
                    
                    //Avg Per Day of 1st Period
                    drFound[1]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Qty"]) / Util.GetDecimal(Days1)));
                    drNewRow.ItemArray = drFound[0].ItemArray;
                    
                    if (Util.GetDecimal(drFound[1]["Qty"]) > 0)
                        drNewRow["Qty"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["Qty"]) - Util.GetDecimal(drFound[1]["Qty"]))/Util.GetDecimal(drFound[1]["Qty"])) * 100, 2));
                    else
                        drNewRow["Qty"] = "100";                    

                    drNewRow["CompType"] = Util.GetString("3");
                }
                else
                {
                    //Avg Per Day of 2nd Period
                    drFound[0]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Qty"]) / Util.GetDecimal(Days1),2));
                    
                    //Avg Per Day of 1st Period
                    drFound[1]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Qty"]) / Util.GetDecimal(Days2),2));
                    drNewRow.ItemArray = drFound[0].ItemArray;                    

                    if (Util.GetDecimal(drFound[0]["Qty"]) > 0)
                        drNewRow["Qty"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[1]["Qty"]) - Util.GetDecimal(drFound[0]["Qty"])) / Util.GetDecimal(drFound[0]["Qty"])) * 100, 2));
                    else
                        drNewRow["Qty"] = "100";

                    drNewRow["CompType"] = Util.GetString("3");
                }

                drNewRow["Name"] = "Total Growth/Decline in Percentage:";

                if (Util.GetDecimal(drNewRow["Qty"]) >= 0)
                    drNewRow["QtyGrowth"] = "Y";
                else
                    drNewRow["QtyGrowth"] = "N";                

                dtMain.Rows.InsertAt(drNewRow, i + 2);

                dtMain.AcceptChanges();

            }
        }

        //Sorting Data on GroupID,CompType

        DataView dv = dtMain.DefaultView;
        dv.Sort = GroupingID + ",CompType";
        dtMain = dv.ToTable();

        //Adding Total for each Type

        DataRow dr = dtMain.NewRow();
        dr[0] = "Total of Ist Period";
        dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Qty)", "CompType=1"))));
        dr["CompType"] = Util.GetString("1");
        dtMain.Rows.InsertAt(dr, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr1 = dtMain.NewRow();
        dr1[0] = "Total of 2nd Period";
        dr1["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Qty)", "CompType=2"))));
        dr1["CompType"] = Util.GetString("2");
        dtMain.Rows.InsertAt(dr1, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr2 = dtMain.NewRow();
        dr2[0] = "OverAll Growth/Decline in Percentage";
                
        if (Util.GetDecimal(dr["Qty"]) > 0)
            dr2["Qty"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["Qty"]) - Util.GetDecimal(dr["Qty"]))/Util.GetDecimal(dr["Qty"])) * 100, 2));
        else
            dr2["Qty"] = "100";

                
        dr2["CompType"] = Util.GetString("3");

        if (Util.GetDecimal(dr2["Qty"]) >= 0)
            dr2["QtyGrowth"] = "Y";
        else
            dr2["QtyGrowth"] = "N";

        dtMain.Rows.InsertAt(dr2, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        return dtMain;
    }


    #endregion

    protected void grdDocC_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblCompDoc")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FFFF");
            }
            else if (((Label)e.Row.FindControl("lblCompDoc")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFFC0");
            }

            else if (((Label)e.Row.FindControl("lblCompDoc")).Text == "3")
            {//System.Drawing.ColorTranslator.FromHtml("#404040")
                e.Row.BackColor =System.Drawing.Color.White;

                if (((Label)e.Row.FindControl("lblDocQtyGrowth")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");
                

            }            
        }
    }
    protected void grdSpecC_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblCompSpec")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FFFF");
            }
            else if (((Label)e.Row.FindControl("lblCompSpec")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFFC0");
            }

            else if (((Label)e.Row.FindControl("lblCompSpec")).Text == "3")
            {
                e.Row.BackColor = System.Drawing.Color.White;

                if (((Label)e.Row.FindControl("lblSpecQtyGrowth")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");               

            }     

            
        }
    }
    protected void grdDischargeTypeC_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblCompDischargeType")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FFFF");
            }
            else if (((Label)e.Row.FindControl("lblCompDischargeType")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFFC0");
            }

            else if (((Label)e.Row.FindControl("lblCompDischargeType")).Text == "3")
            {
                e.Row.BackColor = System.Drawing.Color.White;

                if (((Label)e.Row.FindControl("lblDischargeTypeQtyGrowth")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");                              

            }     

            
        }
    }
    protected void grdPanelC_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblCompPanel")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FFFF");
            }
            else if (((Label)e.Row.FindControl("lblCompPanel")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFFC0");
            }

            else if (((Label)e.Row.FindControl("lblCompPanel")).Text == "3")
            {
                e.Row.BackColor = System.Drawing.Color.White;

                if (((Label)e.Row.FindControl("lblPanelQtyGrowth")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");                

            }     
           
        }
    }

    protected void grdDocC_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string DocID = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string CompType = Util.GetString(e.CommandArgument).Split('#')[1].ToString();

            if (CompType != "3")
            {
                LoadDocDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), "", DocID, CompType);
                mpSelect.Show();
            }
        }
    }
    protected void grdSpecC_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string ItemID = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string CompType = Util.GetString(e.CommandArgument).Split('#')[1].ToString();
            if (CompType != "3")
            {
                LoadItemDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), "", ItemID, CompType);
                mpSelect.Show();
            }
        }
    }
    protected void grdDischargeTypeC_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string DischargeType = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string CompType = Util.GetString(e.CommandArgument).Split('#')[1].ToString();
            if (CompType != "3")
            {
                LoadDischargeTypeDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(),"", DischargeType, CompType);
                mpSelect.Show();
            }
        }
    }
    protected void grdPanelC_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string PanelID = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string CompType = Util.GetString(e.CommandArgument).Split('#')[1].ToString();
            if (CompType != "3")
            {
                LoadPanelDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), "", PanelID, CompType);
                mpSelect.Show();
            }
        }
    }    
}
