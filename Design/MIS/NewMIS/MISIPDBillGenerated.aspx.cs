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

public partial class Design_MIS_MISIPDBillGenerated : System.Web.UI.Page
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
            LoadBillingDocDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "", DocID);
            mpSelect.Show();
        }
    }
    protected void grdSpec_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string ItemID = Util.GetString(e.CommandArgument);
            LoadBillingItemDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "", ItemID);
            mpSelect.Show();
        }
    }
    protected void grdBillDate_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string SubCategoryID = Util.GetString(e.CommandArgument);
            LoadBillingRoomDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "", SubCategoryID);
            mpSelect.Show();
        }
    }
    protected void grdPanel_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string PanelID = Util.GetString(e.CommandArgument);
            LoadBillingPanelDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "", PanelID);
            mpSelect.Show();
        }
    }

    private void LoadData(string DateFrom, string DateTo, string DateType, string TypeofTnx, string OPDIPD, string ConfigIds, string SelectionType)
    {
        if (OPDIPD == "IPD")
        {            
            LoadBillGenerated(DateFrom, DateTo); 
            lblClicked.Text = SelectionType;
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;            
            ViewState["SelectionType"] = SelectionType;
        }

    }

    private void LoadBillGenerated(string DateFrom, string DateTo)
    {
        string strQ = "";

        //For Doctor-wise
        strQ += "SELECT dm.Name,SUM(OpenBill)OpenBill,SUM(PkgBill)PkgBill,SUM(MixedBill)MixedBill,dm.DoctorID FROM ( ";
	    strQ +="    SELECT pmh.DoctorID,IF(adj.BillingType=1,1,0)OpenBill, ";
	    strQ +="    IF(adj.BillingType=2,1,0)PkgBill,IF(adj.BillingType=3,1,0)MixedBill FROM f_ipdadjustment adj "; 
        strQ +="    INNER JOIN ( ";
		strQ +="        SELECT TransactionID FROM f_ledgertransaction "; 
		strQ +="        WHERE IFNULL(Billno,'')<>'' AND BillType='IPD' ";
        strQ += "        AND DATE(BillDate)>='" + DateFrom + "' AND DATE(BillDate)<='" + DateTo + "' "; 
		strQ +="        GROUP BY TransactionID ";
	    strQ +="    )t ON adj.TransactionID =t.TransactionID INNER JOIN patient_medical_history pmh ON "; 
	    strQ +="    pmh.TransactionID = adj.TransactionID ";
        strQ +=")t INNER JOIN doctor_master dm ON t.DoctorID = dm.DoctorID ";
        strQ +="GROUP BY dm.DoctorID ORDER BY dm.Name ";

        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(OpenBill)", ""))));
            dr["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(PkgBill)", ""))));
            dr["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(MixedBill)", ""))));    
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
        
	    
        strQ += "SELECT dm.Specialization Name,SUM(OpenBill)OpenBill,SUM(PkgBill)PkgBill,SUM(MixedBill)MixedBill, ";
        strQ += "dm.Specialization ItemID FROM ( ";
	    strQ += "    SELECT pmh.DoctorID,IF(adj.BillingType=1,1,0)OpenBill, ";
	    strQ += "    IF(adj.BillingType=2,1,0)PkgBill,IF(adj.BillingType=3,1,0)MixedBill "; 
        strQ += "    FROM f_ipdadjustment adj INNER JOIN ( ";
		strQ += "        SELECT TransactionID FROM f_ledgertransaction  ";
		strQ += "        WHERE IFNULL(Billno,'')<>'' AND BillType='IPD' "; 
		strQ += "        AND DATE(BillDate)>='"+DateFrom+"' AND DATE(BillDate)<='"+DateTo+"' "; 
		strQ += "        GROUP BY TransactionID ";
	    strQ += "    )t ON adj.TransactionID =t.TransactionID INNER JOIN patient_medical_history pmh ON  ";
	    strQ += "    pmh.TransactionID = adj.TransactionID ";
        strQ += ")t INNER JOIN doctor_master dm ON t.DoctorID = dm.DoctorID ";
        strQ += "GROUP BY dm.Specialization ORDER BY dm.Specialization ";

        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(OpenBill)", ""))));
            dr["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(PkgBill)", ""))));
            dr["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(MixedBill)", ""))));               
            dt.Rows.Add(dr);
            grdSpec.DataSource = dt;
            grdSpec.DataBind();

        }
        else
        {
            grdSpec.DataSource = null;
            grdSpec.DataBind();
        }

        //For BillDate-wise

        strQ = "";
        strQ += "SELECT BillDate NAME ,SUM(OpenBill)OpenBill,SUM(PkgBill)PkgBill,SUM(MixedBill)MixedBill FROM ( ";
	    strQ += "    SELECT IF(adj.BillingType=1,1,0)OpenBill, ";
	    strQ += "    IF(adj.BillingType=2,1,0)PkgBill,IF(adj.BillingType=3,1,0)MixedBill, ";
        strQ += "    t.BillDate FROM f_ipdadjustment adj INNER JOIN ( ";
		strQ += "        SELECT TransactionID,DATE_FORMAT(billdate,'%d-%b-%y')BillDate FROM f_ledgertransaction "; 
		strQ += "        WHERE IFNULL(Billno,'')<>'' AND BillType='IPD' ";
        strQ += "        AND DATE(BillDate)>='" + DateFrom + "' AND DATE(BillDate)<='" + DateTo + "' ";
		strQ += "        GROUP BY TransactionID ";
	    strQ += "    )t ON adj.TransactionID = t.TransactionID ";
        strQ += ")t GROUP BY BillDate ORDER BY BillDate ";

        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(OpenBill)", ""))));
            dr["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(PkgBill)", ""))));
            dr["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(MixedBill)", ""))));               
            dt.Rows.Add(dr);
            grdBillDate.DataSource = dt;
            grdBillDate.DataBind();

        }
        else
        {
            grdBillDate.DataSource = null;
            grdBillDate.DataBind();
        }


        //For Panel-wise

        strQ = "";
        strQ += "SELECT pnl.Company_Name NAME ,SUM(OpenBill)OpenBill,SUM(PkgBill)PkgBill, ";
        strQ += "SUM(MixedBill)MixedBill,pnl.PanelID FROM ( ";
	    strQ += "    SELECT pmh.PanelID,IF(adj.BillingType=1,1,0)OpenBill, ";
	    strQ += "    IF(adj.BillingType=2,1,0)PkgBill,IF(adj.BillingType=3,1,0)MixedBill "; 
        strQ += "    FROM f_ipdadjustment adj INNER JOIN ( ";
		strQ += "        SELECT TransactionID FROM f_ledgertransaction "; 
		strQ += "        WHERE IFNULL(Billno,'')<>'' AND BillType='IPD' ";
        strQ += "        AND DATE(BillDate)>='" + DateFrom + "' AND DATE(BillDate)<='" + DateTo + "' ";
		strQ += "        GROUP BY TransactionID ";
	    strQ += "    )t ON adj.TransactionID =t.TransactionID INNER JOIN patient_medical_history pmh ON "; 
	    strQ += "    pmh.TransactionID = adj.TransactionID ";
        strQ += ")t INNER JOIN f_panel_master pnl ON t.PanelID = pnl.PanelID ";
        strQ += "GROUP BY pnl.PanelID ORDER BY pnl.Company_Name";
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(OpenBill)", ""))));
            dr["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(PkgBill)", ""))));
            dr["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(MixedBill)", ""))));          
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

    private void LoadBillingDocDetailData(string DateFrom, string DateTo, string TypeofTnx, string DocID)
    {
        TypeofTnx = "DoctorID";
        LoadDetailGrid(DateFrom,DateTo,TypeofTnx,DocID);
    }

    private void LoadBillingItemDetailData(string DateFrom, string DateTo, string TypeofTnx, string Specialization)
    {
        TypeofTnx = "Specialization";
        LoadDetailGrid(DateFrom, DateTo, TypeofTnx, Specialization);
    }

    private void LoadBillingRoomDetailData(string DateFrom, string DateTo, string TypeofTnx, string BillDate)
    {
        TypeofTnx = "BillDate";
        LoadDetailGrid(DateFrom, DateTo, TypeofTnx, BillDate);

    }

    private void LoadBillingPanelDetailData(string DateFrom, string DateTo, string TypeofTnx, string PanelID)
    {
        TypeofTnx = "PanelID";
        LoadDetailGrid(DateFrom, DateTo, TypeofTnx, PanelID);
    }

    protected void grdDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //string LedgerTransactionNo = ((Label)e.Row.FindControl("lblLedgerTransactionNo")).Text;
            //string strQ = "Select Quantity,Rate,Amount,((Rate*Quantity)-Amount)Disc,ItemName from f_LedgerTnxDetail where LedgertransactionNo='" + LedgerTransactionNo + "' ";
            //DataTable dt = StockReports.GetDataTable(strQ);
            //string strDetail = MakeDetail(dt, LedgerTransactionNo);
            //Response.Write(strDetail);
            ////HtmlGenericControl HgcDiv = new HtmlGenericControl();
            ////HgcDiv = (HtmlGenericControl)e.Row.FindControl("dvDetail");
            ////HgcDiv.InnerText = strDetail;

            ////e.Row.Attributes.Add("onmouseover", "javascript:showTip(event," + HgcDiv + ");");
            //e.Row.CssClass = "example3tooltip";
            //e.Row.Attributes.Add("onmouseover", "showDiv('dvDetail_" + LedgerTransactionNo + "');");
            
        }

    }

    private void LoadDetailGrid(string DateFrom, string DateTo, string TypeofTnx, string ID)
    {
        string strQ = "";

        strQ += " SELECT BillingType,BillDate,BillNo,Replace(PatientID,'LSHHI','')MR_No,REPLACE(T4.TransactionID,'ISHHI','')IP_No,UPPER(PName)PName,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%y')DateOfAdmit,DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%y')DateOfDischarge, ";
        strQ += " (SELECT CONCAT(Bed_No,'-',UPPER(NAME))Room FROM room_master WHERE Room_ID= (SELECT Room_ID FROM patient_ipd_profile  ";
        strQ += " WHERE PatientIPDProfile_ID =(SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=T4.TransactionID)))Room,UPPER(DoctorName)DoctorName,UCASE(Specialization)Specialization,  ";
        strQ += " ROUND(CAST(GrossAmt AS DECIMAL(15,2)),2)GrossBillAmt,ROUND(CAST(TotalDiscount AS DECIMAL(15,2)),2)TotalDiscount,ROUND(CAST(NetAmount AS DECIMAL(15,2)),2)AS NetBillAmount,  ";
        strQ += " CAST(if(UPPER(PName)not like '%Cancel%',(SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =T4.TransactionID AND IsCancel = 0 AND AmountPaid >0 GROUP BY T4.TransactionID),0) AS DECIMAL(15,2))TotalDeposit, ";
        strQ += " CAST(if(UPPER(PName)not like '%Cancel%',(SELECT REPLACE(SUM(AmountPaid),'-','') FROM f_reciept WHERE TransactionID =T4.TransactionID AND IsCancel = 0 AND AmountPaid <0 GROUP BY T4.TransactionID),0) AS DECIMAL(15,2))TotalRefund, ";
        strQ += " ROUND(CAST(ReceiveAmt AS DECIMAL(15,2)),2)ReceiveAmt,ROUND(CAST(AdjustmentAmt AS DECIMAL(15,2)),2)AdjustmentAmt,ROUND(CAST(OutStanding AS DECIMAL(15,2)),2) AS OutStanding,ROUND(CAST(TDS AS DECIMAL(15,2)),2)TDS, ";
        strQ += " ROUND(CAST(Deduction_Acceptable AS DECIMAL(15,2)),2)DeductionAcceptable,ROUND(CAST(Deduction_NonAcceptable AS DECIMAL(15,2)),2)DeductionNonAcceptable,ROUND(CAST(WriteOff AS DECIMAL(15,2)),2)WriteOff,ROUND(CAST(CreditAmt AS DECIMAL(15,2)),2)CreditAmt,ROUND(CAST(DebitAmt AS DECIMAL(15,2)),2)DebitAmt, ";
        strQ += " CAST(ServiceTaxAmt AS DECIMAL(15,2))ServiceTaxAmt,CAST(ServiceTaxSurChgAmt AS DECIMAL(15,2))ServiceTaxSurChgAmt, ";
        strQ += " UPPER(DiscountOnBillReason)DiscountOnBillReason,UPPER(ApprovalBy)ApprovalBy,UPPER(Panel)Panel,CAST(PanelApprovedAmt AS DECIMAL(15,2))PanelApprovedAmt,  ";
        strQ += " UPPER(PolicyNo)PolicyNo,UPPER(CardNo)CardNo,UPPER(ClaimNo)ClaimNo,UPPER(PanelAppRemarks)PanelAppRemarks,PanelApprovalDate,UPPER(UserID) BillGeneratedBy,IF(IsBilledClosed=1,'BILL FINALISED','BILL NOT FINALISED')BillingStatus FROM ( ";
        strQ += "      SELECT BillingType,DATE_FORMAT(BillDate,'%d-%b-%y')BillDate,BillNo,PatientID,TransactionID,PName,ROUND(TotalBilledAmt) GrossAmt, ";
        strQ += "      ROUND((ItemWiseDiscount+DiscountOnBill))TotalDiscount,ROUND((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill))) ";
        strQ += "      AS NetAmount,ROUND(AdjustmentAmt)AdjustmentAmt,ROUND(ReceiveAmt)ReceiveAmt, ";
        strQ += "      ROUND(((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+AdjustmentAmt+ReceiveAmt+TDS+Deduction_Acceptable+Deduction_NonAcceptable+WriteOff)-CreditAmt+DebitAmt + ServiceTaxAmt+ServiceTaxSurChgAmt)) AS OutStanding, ";
        strQ += "      UserID,DoctorName,Specialization, Panel,ROUND(TDS)TDS,ROUND(Deduction_Acceptable)Deduction_Acceptable,ROUND(Deduction_NonAcceptable)Deduction_NonAcceptable,ROUND(WriteOff)WriteOff,ROUND(CreditAmt)CreditAmt,ROUND(DebitAmt)DebitAmt,ROUND(ServiceTaxAmt,2)ServiceTaxAmt,ROUND(ServiceTaxSurChgAmt,2)ServiceTaxSurChgAmt,  ";
        strQ += "      PolicyNo,CardNo,ClaimNo,PanelApprovedAmt,PanelAppRemarks,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed  FROM ( ";
        strQ += "           SELECT BillingType,BillDate,BillNo,PatientID,TransactionID,PName, ";
        strQ += "           IF(TotalBilledAmt IS NULL,0,TotalBilledAmt)TotalBilledAmt, ";
        strQ += "           IF(ItemWiseDiscount IS NULL,0,ItemWiseDiscount)ItemWiseDiscount, ";
        strQ += "           IF(DiscountOnBill IS NULL,0,DiscountOnBill)DiscountOnBill, ";
        strQ += "           IF(AdjustmentAmt IS NULL,0,AdjustmentAmt)AdjustmentAmt,IF(ReceiveAmt IS NULL,0,ReceiveAmt)ReceiveAmt , ";
        strQ += "           UserID,DoctorName,Specialization,IF(TDS IS NULL,0,TDS)TDS,Deduction_Acceptable,Deduction_NonAcceptable,WriteOff,CreditAmt,DebitAmt,ServiceTaxAmt,ServiceTaxSurChgAmt,Panel, ";
        strQ += "           PolicyNo,CardNo,ClaimNo,PanelApprovedAmt,PanelAppRemarks,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed FROM ( ";
        strQ += "               SELECT T1.BillingType,T1.BillNo,T1.BillDate,T1.PatientID,T1.TransactionID,T1.TotalBilledAmt,T1.DiscountOnBill,T1.TDS,T1.Deduction_Acceptable,T1.Deduction_NonAcceptable,T1.WriteOff,T1.CreditAmt,T1.DebitAmt,T1.AdjustmentAmt,  ";
        strQ += "               T1.ReceiveAmt,T1.ItemWiseDiscount,T1.PName,Em.Name UserID,ServiceTaxAmt,ServiceTaxSurChgAmt,dm.Name DoctorName,dm.Specialization, T1.PolicyNo, ";
        strQ += "               T1.CardNo,T1.ClaimNo,T1.PanelApprovedAmt,T1.PanelAppRemarks,if(PanelApprovalDate='0001-01-01','',DATE_FORMAT(T1.PanelApprovalDate,'%d-%b-%y'))PanelApprovalDate,T1.DiscountOnBillReason,T1.ApprovalBy,  ";
        strQ += "               PM.Company_Name Panel,IsBilledClosed FROM ( ";
        strQ += "                   SELECT BillingType,BillNo,BillDate,PatientID,Temp1.TransactionID, ";
        strQ += "                   (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail ltd  ";
        strQ += "                   INNER JOIN f_Itemmaster im ON im.ItemID = Ltd.ItemID  ";
        strQ += "                   WHERE ltd.TransactionID = Temp1.TransactionID AND ltd.IsVerified = 1 AND  ";
        strQ += "                   ltd.IsPackage = 0     ";
        strQ += "                   GROUP BY TransactionID)TotalBilledAmt, ";
        strQ += "                   DiscountOnBill,AdjustmentAmt,(SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =Temp1.TransactionID ";
        strQ += "                   AND IsCancel = 0 GROUP BY TransactionID)ReceiveAmt, ";
        strQ += "                   (SELECT SUM(((Rate*Quantity)*DiscountPercentage)/100) FROM  ";
        strQ += "                   f_ledgertnxdetail WHERE TransactionID = Temp1.TransactionID  ";
        strQ += "                   AND IsVerified = 1 AND IsPackage = 0 ";
        strQ += "                   GROUP BY TransactionID)ItemWiseDiscount, UserID,TDS,Deduction_Acceptable,Deduction_NonAcceptable,WriteOff,CreditAmt,DebitAmt,ServiceTaxAmt,ServiceTaxSurChgAmt,PName,ClaimNo,PanelAppRemarks, ";
        strQ += "                   PanelApprovedAmt,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed, ";
        strQ += "                   PolicyNo,CardNo,DoctorID,PanelID  FROM  ( ";
        strQ += "                       SELECT (case when adj.BillingType=1 then 'OpenBill' when adj.BillingType=2 then 'PkgBill' else 'MixedBill' end)BillingType,";
        strQ += "                       LT.BillNo,LT.BillDate,Adj.PatientID,Adj.TransactionID, ";
        strQ += "                       Adj.TotalBilledAmt,Adj.DiscountOnBill,Adj.AdjustmentAmt,Adj.UserID,IFNULL(pmh.TDS,0)TDS,IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable, ";
        strQ += "                       IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,IFNULL(pmh.WriteOff,0)WriteOff, ";
        strQ += "                       IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=lt.TransactionID  ";
        strQ += "                       AND CRDR='CR01' AND cancel=0  GROUP BY TransactionID),0)CreditAmt, ";
        strQ += "                       IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=lt.TransactionID  ";
        strQ += "                       AND CRDR='DR01' AND cancel=0 GROUP BY TransactionID),0)DebitAmt, ";
        strQ += "                       Adj.ServiceTaxAmt,Adj.ServiceTaxSurChgAmt,PT.PName PName,adj.ClaimNo,adj.PanelAppRemarks,adj.PanelApprovedAmt, ";
        strQ += "                       adj.PanelApprovalDate,adj.DiscountOnBillReason,adj.ApprovalBy,adj.IsBilledClosed, ";
        strQ += "                       pmh.PolicyNo,pmh.CardNo,pmh.DoctorID,pmh.PanelID FROM ( ";
        strQ += "                             SELECT BillNo,TransactionID,Billdate FROM f_ledgertransaction WHERE IsCancel = 0 ";

        if (TypeofTnx == "BillDate")
            strQ += "                             and Date(BillDate) = '" + Util.GetDateTime(ID).ToString("yyyy-MM-dd") + "' ";
        else
            strQ += "                             and Date(BillDate) >= '" + DateFrom + "' and Date(BillDate) <= '" + DateTo + "'";
        
        strQ += "                             GROUP BY BillNo ";
        strQ += "                       )lt INNER JOIN f_ipdadjustment adj ON adj.TransactionID = lt.TransactionID ";
        strQ += "                       INNER JOIN patient_master pt ON pt.PatientID = adj.PatientID ";
        strQ += "                       INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ";
        strQ += "                       WHERE (Adj.BillNo IS NOT NULL) AND Adj.BillNo <> ''  ";

        if(TypeofTnx=="DoctorID")
            strQ += "                       AND pmh.DoctorID='" + ID + "' ";        
        if (TypeofTnx == "PanelID")
            strQ += "                       AND pmh.PanelID=" + ID + " ";       

        strQ += "                   )Temp1 ";
        strQ += "                   UNION ALL ";
        strQ += "                   SELECT '' BillingType,BC.BillNo,BC.BillDate,BC.PatientID,BC.TransactionID,0.0 TotalBilledAmt, ";
        strQ += "                   0.0 DiscountOnBill, 0.0 AdjustmentAmt,0.0 ReceiveAmt,0.0 ItemWiseDiscount, ";
        strQ += "                   BC.BillGenerateUserID,0.0 TDS,0.0 Deduction_Acceptable,0.0 Deduction_NonAcceptable,0.0 WriteOff,0.0 CreditAmt,0.0 DebitAmt,0.0 ServiceTaxAmt,0.0 ServiceTaxSurChgAmt,CONCAT(PT.Pname,'---CANCEL')PNAME,'' ClaimNo,''PanelAppRemarks,  ";
        strQ += "                   ''PanelApprovedAmt,''PanelApprovalDate,''DiscountOnBillReason,''ApprovalBy,'0' IsBilledClosed,  ";
        strQ += "                   '' PolicyNo,'' CardNo,'' DoctorID,'' PanelID ";
        strQ += "                   FROM f_billcancellation BC INNER JOIN patient_master PT ON BC.PatientID = PT.PatientID ";
        strQ += "               ) T1  ";
        strQ += "               INNER JOIN Doctor_Master dm ON dm.DoctorID = T1.DoctorID ";
        strQ += "               INNER JOIN employee_master EM ON EM.Employee_ID = T1.UserID ";
        strQ += "               LEFT OUTER JOIN f_panel_master PM ON PM.PanelID = T1.PanelID ";

        if (TypeofTnx == "BillDate")
            strQ += "               Where Date(BillDate) = '" + Util.GetDateTime(ID).ToString("yyyy-MM-dd") + "' ";
        else
            strQ += "               where Date(BillDate) >= '" + DateFrom + "' and Date(BillDate) <= '" + DateTo + "'";
        
        //For Specialization
        if (TypeofTnx == "Specialization")
            strQ += "               AND dm.Specialization = '" + ID + "' ";

        strQ += "        )T2";
        strQ += "    )T3";
        strQ += ")T4 left join ipd_case_History ich on ich.TransactionID = T4.TransactionID ";
        strQ += " order by Billno";

        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetails.DataSource = dt;
            grdDetails.DataBind();

            ((Label)grdDetails.FooterRow.FindControl("lblGrossBillAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(GrossBillAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTotalDiscountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalDiscount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblNetBillAmountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(NetBillAmount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTotalDepositT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalDeposit)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTotalRefundT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalRefund)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblReceiveAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(ReceiveAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblOutStandingT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(OutStanding)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTDST")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TDS)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblDeductionAcceptableT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(DeductionAcceptable)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblDeductionNonAcceptableT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(DeductionNonAcceptable)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblWriteOffT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(WriteOff)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblCreditAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(CreditAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblDebitAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(DebitAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblServiceTaxAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(ServiceTaxAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblServiceTaxSurChgAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(ServiceTaxSurChgAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblPanelApprovedAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(PanelApprovedAmt)", ""))));
        
        }
        else
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();
        }
    }
    
    #endregion Overview
        
}
