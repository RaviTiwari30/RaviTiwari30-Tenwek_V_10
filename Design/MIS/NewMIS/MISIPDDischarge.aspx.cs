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

public partial class Design_MIS_MISIPDDischarge : System.Web.UI.Page
{
     
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {                    
            SelectType();
        }
    }

    private void SelectType()
    {
        string DateFrom = "", DateTo = "", SelectionType = "",DateType="1";

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

        
        LoadData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), DateType, "", "IPD", "", ViewState["SelectionType"].ToString());            
        
    }

    #region Overview

    protected void grdDoc_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string DocID = Util.GetString(e.CommandArgument);
            LoadDischargeDocDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "", DocID);
            mpSelect.Show();
        }
    }
    protected void grdSpec_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string ItemID = Util.GetString(e.CommandArgument);
            LoadDischargeItemDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "", ItemID);
            mpSelect.Show();
        }
    }
    protected void grdDischargeType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string DischargeType = Util.GetString(e.CommandArgument);
            LoadDischargeTypeDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "", DischargeType);
            mpSelect.Show();
        }
    }
    protected void grdPanel_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string PanelID = Util.GetString(e.CommandArgument);
            LoadDischargePanelDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(),"", PanelID);
            mpSelect.Show();
        }
    }

    private void LoadData(string DateFrom, string DateTo, string DateType, string TypeofTnx, string OPDIPD, string ConfigIds, string SelectionType)
    {
        if (OPDIPD == "IPD")
        {
            LoadDischarge(DateFrom, DateTo); 
            lblClicked.Text = SelectionType;
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;            
            ViewState["SelectionType"] = SelectionType;
        }

    }

    private void LoadDischarge(string DateFrom, string DateTo)
    {
        string strQ = "";

        //For Doctor-wise
        strQ += "SELECT dm.Name,COUNT(t.TransactionID)Qty,t.DoctorID  FROM ( ";
	    strQ += "    SELECT ich.TransactionID,pmh.DoctorID,pmh.PanelID,pmh.DischargeType FROM ipd_case_history ich "; 
	    strQ += "    INNER JOIN patient_medical_history pmh ON ich.TransactionID = pmh.TransactionID "; 
	    strQ += "    WHERE ich.status <>'CANCEL' ";
        strQ += "    AND DATE(DateOfDischarge)>='" + DateFrom + "' ";
        strQ += "    AND  DATE(DateOfDischarge)<='" + DateTo + "' ";
        strQ += ")t INNER JOIN doctor_master dm ON dm.DoctorID = t.DoctorID GROUP BY dm.DoctorID ";
        strQ += "ORDER BY dm.Name ";
        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));            
            dt.Rows.Add(dr);

            grdDoc.DataSource = dt;
            grdDoc.DataBind();
        }
        else
        {
            grdDoc.DataSource = null;
            grdDoc.DataBind();
        }


        //For Specialization-wise

        strQ = "";       

        strQ += "SELECT dm.Specialization NAME,COUNT(t.TransactionID)Qty,dm.Specialization ItemID FROM ( ";
	    strQ += "    SELECT ich.TransactionID,pmh.DoctorID,pmh.PanelID,pmh.DischargeType FROM ipd_case_history ich "; 
	    strQ += "    INNER JOIN patient_medical_history pmh ON ich.TransactionID = pmh.TransactionID "; 
	    strQ += "    WHERE ich.status <>'CANCEL' "; 
        strQ += "    AND DATE(DateOfDischarge)>='"+DateFrom +"' "; 
        strQ += "    AND  DATE(DateOfDischarge)<='"+DateTo +"' ";
        strQ += ")t INNER JOIN doctor_master dm ON dm.DoctorID = t.DoctorID GROUP BY dm.Specialization ";
        strQ += "ORDER BY dm.Specialization ";

        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));            
            dt.Rows.Add(dr);
            grdSpec.DataSource = dt;
            grdSpec.DataBind();

        }
        else
        {
            grdSpec.DataSource = null;
            grdSpec.DataBind();
        }

        //For RoomType-wise

        strQ = "";
        strQ += "SELECT pmh.DischargeType NAME,COUNT(ich.TransactionID)Qty,DischargeType FROM ipd_case_history ich ";
        strQ += "INNER JOIN patient_medical_history pmh ON ich.TransactionID = pmh.TransactionID "; 
        strQ += "WHERE ich.status <>'CANCEL' "; 
        strQ += "AND DATE(DateOfDischarge)>='"+DateFrom+"' ";
        strQ += "AND  DATE(DateOfDischarge)<='" + DateTo + "' ";
        strQ += "GROUP BY pmh.DischargeType ";
        strQ += "ORDER BY pmh.DischargeType ";

        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));            
            dt.Rows.Add(dr);
            grdDischargeType.DataSource = dt;
            grdDischargeType.DataBind();

        }
        else
        {
            grdDischargeType.DataSource = null;
            grdDischargeType.DataBind();
        }


        //For Panel-wise

        strQ = "";
        strQ += "SELECT pnl.Company_Name NAME,COUNT(t.TransactionID)Qty,pnl.PanelID FROM ( ";
	    strQ += "    SELECT ich.TransactionID,pmh.DoctorID,pmh.PanelID,pmh.DischargeType FROM ipd_case_history ich "; 
	    strQ += "    INNER JOIN patient_medical_history pmh ON ich.TransactionID = pmh.TransactionID "; 
	    strQ += "    WHERE ich.status <>'CANCEL' "; 
        strQ += "    AND DATE(DateOfDischarge)>='"+DateFrom+"' "; 
        strQ += "    AND  DATE(DateOfDischarge)<='"+DateTo+"' ";
        strQ += ")t INNER JOIN f_panel_master pnl ON pnl.PanelID = t.PanelID GROUP BY pnl.PanelID ";
        strQ += "ORDER BY pnl.Company_Name ";
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));            
            dt.Rows.Add(dr);
            grdPanel.DataSource = dt;
            grdPanel.DataBind();

        }
        else
        {
            grdPanel.DataSource = null;
            grdPanel.DataBind();
        }
    }

    private void LoadDischargeDocDetailData(string DateFrom, string DateTo, string TypeofTnx, string DocID)
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
        strQ += "       WHERE ich.DateOfDischarge >='" + DateFrom + "' ";
        strQ += "       AND  ich.DateOfDischarge <='" + DateTo + "' ";
        if(DocID!="")
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

    private void LoadDischargeItemDetailData(string DateFrom, string DateTo, string TypeofTnx, string ItemID)
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
        strQ += "       WHERE ich.DateOfDischarge >='" + DateFrom + "' ";
        strQ += "       AND  ich.DateOfDischarge <='" + DateTo + "' ";
        strQ += "       AND ich.status <> 'cancel'  GROUP BY pip.TransactionID ";
        strQ += "   ) T  INNER JOIN patient_ipd_profile pip ON T.MaxPatientIPDProfile_ID = pip.PatientIPDProfile_ID ";
        strQ += "   INNER JOIN patient_ipd_profile pip1 ON T.MinPatientIPDProfile_ID = pip1.PatientIPDProfile_ID ";
        strQ += ")T1  INNER JOIN patient_master pm ON pm.PatientID = T1.PatientID ";
        strQ += "INNER JOIN doctor_master dm ON dm.DoctorID = T1.DoctorID ";
        strQ += "INNER JOIN f_panel_master pnl ON pnl.PanelID = T1.PanelID ";
        if (ItemID != "")
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

    private void LoadDischargeTypeDetailData(string DateFrom, string DateTo, string TypeofTnx, string DischargeType)
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
        strQ += "       WHERE ich.DateOfDischarge >='" + DateFrom + "' ";
        strQ += "       AND  ich.DateOfDischarge <='" + DateTo + "' ";
        if (DischargeType != "")

        strQ += "       AND pmh.DischargeType='" + DischargeType + "' ";
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

    private void LoadDischargePanelDetailData(string DateFrom, string DateTo, string TypeofTnx, string PanelID)
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
        strQ += "       WHERE ich.DateOfDischarge >='" + DateFrom + "' ";
        strQ += "       AND  ich.DateOfDischarge <='" + DateTo + "' ";
        if (PanelID != "")

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
   
    #endregion Overview
        
}
