using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web;
using System.Web.Services;
using System.Collections.Generic;
using System.Web.Script.Serialization;

public partial class Design_Store_OPD_Return : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //  int CentreID = Util.GetInt(Session["CentreID"].ToString()); if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            //  {
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
            //return;
            //  }
            //   else
            //   {
            txtHash.Text = Util.getHash();
            txtHash.Attributes.Add("style", "display:none");
            // ((TextBox)PaymentControl.FindControl("txtNetAmount")).Attributes.Add("readonly", "readonly");
            txtHash.Text = Util.getHash();
            txtHash.Attributes.Add("style", "display:none");
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            pnlInfo.Visible = false;
            // pnlOpdReturn.Visible = false;
            //  btnGen.Visible = false;
            //  ((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).Enabled = false;
            txtReceiptNo.Focus();

            //   }
            //if (((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count <= 0)
            //{
            //    PaymentEnableFalse();
            //}
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();


        var departmentLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();

        if (!string.IsNullOrEmpty(txtEmergencyNo.Text.Trim()))
        {
            sb.Append("SELECT tt.* FROM ");
            sb.Append("(SELECT t.LedgerTransactionNo,t.TransactionID,t.ReceiptNo,t.Netamount,t.IsPackage,t.DiscountOnTotal,t.DiscountPercentage,t.GrossAmount,t.Adjustment,t.DATE, ");
            sb.Append("t.TypeOfTnx,t.CustomerID,t.Pname,t.Age,t.contactno,t.Address,t.PatientID,t.PanelID,t.DoctorID,t.Type_ID,t.IsUsable,t.ServiceItemID,t.ToBeBilled,t.BillNo, ");
            sb.Append("t.BatchNumber,t.MedExpiryDate,(t.AvlQty-IFNULL(rt.ReturnQty,0))AvlQty,t.UnitType,t.StockID,t.ItemID,t.ItemName,t.SubCategoryID,t.PerUnitBuyPrice,t.MRP,t.DiscountApproveBy,t.DiscountReason,t.GovTaxPer,t.GovTaxAmount,t.PaymentMode,IPNo,PatientType,t.IsExpirable, ");
            //gst change
            sb.Append(" t.HSNCode,t.IGSTPercent,t.IGSTAmt,t.SGSTPercent,t.SGSTAmt,t.CGSTPercent,if( t.BillDate >=DATE_ADD(NOW(),INTERVAL -24 HOUR),1,0)BillDateStatus,t.CGSTAmt,t.GSTType, ");
            //
            sb.Append(" TaxPercent,t.PaymentModeID, 'EMG' Patient_Type,SaleTaxAmount,SaleTaxPercent FROM ");
            sb.Append("(SELECT DISTINCT(LT.LedgerTransactionNo),LT.TransactionID,concat(lt.BillDate,' ',lt.`TIME`)BillDate,r.ReceiptNo, ROUND(LT.NetAmount,2)NetAmount,ltd.IsPackage,ROUND(LT.DiscountOnTotal,2)DiscountOnTotal,Round(ltd.DiscountPercentage,2)DiscountPercentage,ROUND(LT.GrossAmount,2)GrossAmount,Round(LT.Adjustment,2)Adjustment,DATE_FORMAT(LT.Date,'%d-%b-%y %T')DATE,   ");
            sb.Append("LT.TypeOfTnx,'' CustomerID,CONCAT(PM.Title,' ',PM.Pname)PName,PM.Age,IF(IFNULL(pm.Mobile,'')='',pm.Phone,pm.Mobile)ContactNo,CONCAT(IFNULL(PM.House_No,''),' ',IFNULL(PM.Street_Name,''),' ',IFNULL(PM.Locality,''),' ',    ");
            sb.Append("IFNULL(PM.City,''))Address,pm.PatientID,pmh.PanelID,pmh.DoctorID,im.Type_ID,im.IsUsable,im.ServiceItemID,im.ToBeBilled,   ");
            sb.Append("LT.BillNo,st.BatchNumber, DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y') AS MedExpiryDate,st.IsExpirable,   ");
            sb.Append("SUM(sd.SoldUnits) AS AvlQty,st.UnitType,st.StockID,st.ItemID,st.ItemName,st.SubCategoryID,sd.PerUnitBuyPrice,sd.PerUnitSellingPrice AS MRP,lt.DiscountApproveBy,lt.DiscountReason,lt.GovTaxPer,lt.GovTaxAmount,IF((LT.Adjustment = 0),'Credit','Cash')PaymentMode,IFNULL(LT.IPNo,'')IPNo,lt.PatientType, ");
            //gst change
            sb.Append(" IFNULL(sd.HSNCode,'')HSNCode,sd.IGSTPercent,sd.IGSTAmt,sd.SGSTPercent,sd.SGSTAmt,sd.CGSTPercent,sd.CGSTAmt,IFNULL(sd.GSTType,'')GSTType, ");
            //
            sb.Append(" sd.PurTaxPer TaxPercent, IF(lt.Adjustment>0,1,4) PaymentModeID,(sd.TaxAmt/sd.SoldUnits) SaleTaxAmount,sd.TaxPercent SaleTaxPercent FROM f_ledgertransaction LT    ");
            sb.Append("INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo    ");
            sb.Append("left JOIN f_reciept r ON lt.LedgerTransactionNo = r.AsainstLedgerTnxNo   ");
            sb.Append("INNER JOIN f_stock ST ON LTD.StockID=ST.StockID INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID   ");
            sb.Append("INNER JOIN f_salesdetails sd ON ltd.ID=sd.LedgerTnxNo  ");
            sb.Append("INNER JOIN  patient_master PM ON LT.PatientID=PM.PatientID    ");
            sb.Append("INNER JOIN patient_medical_history pmh ON lt.TransactionID = pmh.TransactionID    ");
            sb.Append("  INNER JOIN emergency_patient_details emg ON  emg.TransactionId=lt.TransactionID ");
            sb.Append("WHERE LT.TypeOfTnx ='Emergency'    ");

            //lt.DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "' and
            sb.Append(" AND  lt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "  ");

            sb.Append("  AND emg.EmergencyNo='" + Util.GetString(txtEmergencyNo.Text) + "'");

            //if (txtReceiptNo.Text.Trim() != "")
            //{
            //    sb.Append("AND r.ReceiptNo='" + txtReceiptNo.Text.Trim() + "'  ");
            //}
            //if (txtBillNo.Text.Trim() != "")
            //{
            //    sb.Append("AND lt.BillNo='" + txtBillNo.Text.Trim() + "' ");
            //}
            sb.Append(" AND lt.PatientID<>'CASH002' AND sd.TrasactionTypeID=3 And sd.DeptLedgerNo='" + departmentLedgerNo + "' GROUP BY ltd.LedgerTransactionNo,ltd.StockID ) t ");
           
            
            //sb.Append("LEFT OUTER JOIN (SELECT LedgerTransactionNo,AgainstLedgerTnxNo,StockID,ItemID,SUM(SoldUnits) ReturnQty,SUM(PerUnitSellingPrice) AS MRP FROM f_salesdetails WHERE  IsReturn=1 ");

            sb.Append(" LEFT OUTER JOIN ( SELECT sd.LedgerTransactionNo,sd.AgainstLedgerTnxNo,sd.StockID,sd.ItemID,SUM(sd.SoldUnits) ReturnQty,SUM(sd.PerUnitSellingPrice) AS MRP FROM f_salesdetails sd INNER JOIN emergency_patient_details emg ON emg.LedgerTransactionNo=sd.AgainstLedgerTnxNo WHERE IsReturn=1 AND emg.EmergencyNo='" + Util.GetString(txtEmergencyNo.Text) + "' ");


            sb.Append("   GROUP BY StockID) AS rt ON t.LedgerTransactionNo = rt.AgainstLedgerTnxNo AND t.StockID = rt.StockID  ");
            sb.Append(")tt WHERE tt.AvlQty>0  ");


        }
        else
        {

            if (txtReceiptNo.Text.Trim() == "" && txtBillNo.Text.Trim() == "" && txtIPDNo.Text.Trim() == "")
            {
                
                    lblMsg.Text = "Please Enter Receipt or Bill Number or IPD No.";
                    return;
               
            }

            sb.Append("SELECT tt.* FROM ");
            sb.Append("(SELECT t.LedgerTransactionNo,t.TransactionID,ifnull(t.ReceiptNo,'')ReceiptNo,t.Netamount,t.IsPackage,t.DiscountOnTotal,t.DiscountPercentage,t.GrossAmount,t.Adjustment,t.DATE, ");
            sb.Append("t.TypeOfTnx,t.CustomerID,t.Pname,t.Age,t.contactno,t.Address,t.PatientID,t.PanelID,t.DoctorID,t.Type_ID,t.IsUsable,t.ServiceItemID,t.ToBeBilled,t.BillNo, ");
            sb.Append("t.BatchNumber,t.MedExpiryDate,(t.AvlQty-IFNULL(rt.ReturnQty,0))AvlQty,t.UnitType,t.StockID,t.ItemID,t.ItemName,t.SubCategoryID,t.PerUnitBuyPrice,t.MRP,t.DiscountApproveBy,t.DiscountReason,t.GovTaxPer,t.GovTaxAmount,t.PaymentMode,IPNo,PatientType,t.IsExpirable, ");
            //gst change
            sb.Append(" t.HSNCode,t.IGSTPercent,t.IGSTAmt,t.SGSTPercent,t.SGSTAmt,t.CGSTPercent,t.CGSTAmt,t.GSTType,if(t.BillDate>=DATE_ADD(NOW(),INTERVAL -24 HOUR),1,0)BillDateStatus, ");
            //
            sb.Append(" TaxPercent,t.PaymentModeID, 'OPD' Patient_Type,SaleTaxAmount,SaleTaxPercent FROM ");
            sb.Append("(SELECT DISTINCT(LT.LedgerTransactionNo),LT.TransactionID,concat(lt.BillDate,' ',lt.`TIME`)BillDate,r.ReceiptNo, ROUND(LT.NetAmount,2)NetAmount,ltd.IsPackage,ROUND(LTD.DiscAmt,2)DiscountOnTotal,Round(ltd.DiscountPercentage,2)DiscountPercentage,ROUND(LTD.Rate*LTD.Quantity,2)GrossAmount,Round(LT.Adjustment,2)Adjustment,DATE_FORMAT(LT.Date,'%d-%b-%y %T')DATE,   ");
            sb.Append("LT.TypeOfTnx,'' CustomerID,CONCAT(PM.Title,' ',PM.Pname)PName,PM.Age,IF(IFNULL(pm.Mobile,'')='',pm.Phone,pm.Mobile)ContactNo,CONCAT(IFNULL(PM.House_No,''),' ',IFNULL(PM.Street_Name,''),' ',IFNULL(PM.Locality,''),' ',    ");
            sb.Append("IFNULL(PM.City,''))Address,pm.PatientID,pmh.PanelID,pmh.DoctorID,im.Type_ID,im.IsUsable,im.ServiceItemID,im.ToBeBilled,   ");
            sb.Append("LT.BillNo,st.BatchNumber, DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y') AS MedExpiryDate,st.IsExpirable,   ");
            sb.Append("sd.SoldUnits AS AvlQty,st.UnitType,st.StockID,st.ItemID,st.ItemName,st.SubCategoryID,sd.PerUnitBuyPrice,sd.PerUnitSellingPrice AS MRP,lt.DiscountApproveBy,lt.DiscountReason,lt.GovTaxPer,lt.GovTaxAmount,IF((LT.Adjustment = 0),'Credit','Cash')PaymentMode,IFNULL(LT.IPNo,'')IPNo,lt.PatientType, ");
            //gst change
            sb.Append(" IFNULL(sd.HSNCode,'')HSNCode,sd.IGSTPercent,sd.IGSTAmt,sd.SGSTPercent,sd.SGSTAmt,sd.CGSTPercent,sd.CGSTAmt,IFNULL(sd.GSTType,'')GSTType, ");
            //
            sb.Append(" sd.PurTaxPer TaxPercent, IF(lt.Adjustment>0,1,4) PaymentModeID,(sd.TaxAmt/sd.SoldUnits) SaleTaxAmount,sd.TaxPercent SaleTaxPercent FROM f_ledgertransaction LT    ");
            sb.Append("INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo    ");
            sb.Append("left JOIN f_reciept r ON lt.LedgerTransactionNo = r.AsainstLedgerTnxNo   ");
            sb.Append("INNER JOIN f_stock ST ON LTD.StockID=ST.StockID INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID   ");
            sb.Append("INNER JOIN f_salesdetails sd ON sd.LedgerTransactionNo=lt.LedgerTransactionNo  AND st.StockID=sd.StockID   ");
            sb.Append("INNER JOIN  patient_master PM ON LT.PatientID=PM.PatientID    ");
            sb.Append("INNER JOIN patient_medical_history pmh ON lt.TransactionID = pmh.TransactionID    ");
            sb.Append("WHERE    ");
            sb.Append(" lt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "  And lt.DeptLedgerNo='" + departmentLedgerNo + "'  AND TrasactionTypeID='16' ");
            if (txtReceiptNo.Text.Trim() != "")
            {
                sb.Append("AND r.ReceiptNo='" + txtReceiptNo.Text.Trim() + "'  ");
            }
            if (txtBillNo.Text.Trim() != "")
            {
                sb.Append("AND lt.BillNo='" + txtBillNo.Text.Trim() + "' ");
            }
            if (txtIPDNo.Text.Trim() != "")
            {
                sb.Append("AND lt.IPNo='" + StockReports.getTransactionIDbyTransNo(txtIPDNo.Text.Trim()) + "'  AND TrasactionTypeID='16' ");
            }
            sb.Append(" AND lt.PatientID<>'CASH002'  GROUP BY sd.StockID  ORDER BY ltd.ID) t ");
            sb.Append("LEFT OUTER JOIN (SELECT LedgerTransactionNo,AgainstLedgerTnxNo,StockID,ItemID,SUM(SoldUnits) ReturnQty,SUM(PerUnitSellingPrice) AS MRP FROM f_salesdetails WHERE ");
            if (txtIPDNo.Text.Trim() == "")
            {
                if (txtReceiptNo.Text.Trim() != "")
                    sb.Append(" AgainstLedgerTnxNo=(SELECT AsainstLedgerTnxNo FROM f_reciept WHERE ReceiptNo='" + txtReceiptNo.Text.Trim() + "')   ");
                else
                    sb.Append(" AgainstLedgerTnxNo=(SELECT LedgerTransactionNo FROM f_ledgertransaction WHERE BillNo='" + txtBillNo.Text.Trim() + "') ");

                sb.Append("AND IsReturn=1 AND TrasactionTypeID='17'  GROUP BY StockID) AS rt ON t.LedgerTransactionNo = rt.AgainstLedgerTnxNo AND t.StockID = rt.StockID  ");

            }
            else
            {
                sb.Append(" TrasactionTypeID='17' ");
                sb.Append("AND IsReturn=1 GROUP BY StockID,AgainstLedgerTnxNo) AS rt ON t.LedgerTransactionNo = rt.AgainstLedgerTnxNo AND t.StockID = rt.StockID  ");

            }
            sb.Append(")tt WHERE tt.AvlQty>0  ");

            if (txtIPDNo.Text.Trim() == "")
            {
                sb.Append(" UNION ALL ");

                sb.Append("SELECT tt.* FROM ");
                sb.Append("(SELECT t.LedgerTransactionNo,t.TransactionID,t.ReceiptNo,t.Netamount,t.IsPackage,t.DiscountOnTotal,t.DiscountPercentage,t.GrossAmount,t.Adjustment,t.DATE, ");
                sb.Append("t.TypeOfTnx,t.CustomerID,t.Pname,t.Age,t.contactno,t.Address,t.PatientID,t.PanelID,t.DoctorID,t.Type_ID,t.IsUsable,t.ServiceItemID,t.ToBeBilled,t.BillNo, ");
                sb.Append("t.BatchNumber,t.MedExpiryDate,(t.AvlQty-IFNULL(rt.ReturnQty,0))AvlQty,t.UnitType,t.StockID,t.ItemID,t.ItemName,t.SubCategoryID,t.PerUnitBuyPrice,t.MRP,t.DiscountApproveBy,t.DiscountReason,t.GovTaxPer,t.GovTaxAmount,t.PaymentMode,IPNo,PatientType,t.IsExpirable, ");
                //gst change
                sb.Append(" t.HSNCode,t.IGSTPercent,t.IGSTAmt,t.SGSTPercent,t.SGSTAmt,t.CGSTPercent,t.CGSTAmt,t.GSTType, if( t.BillDate >=DATE_ADD(NOW(),INTERVAL -24 HOUR),1,0)BillDateStatus, ");
                //

                sb.Append(" TaxPercent, t.PaymentModeID,'WalkIn' Patient_Type,SaleTaxAmount,SaleTaxPercent FROM ");
                sb.Append("(SELECT DISTINCT(LT.LedgerTransactionNo),LT.TransactionID,concat(lt.BillDate,' ',lt.`TIME`)BillDate, r.ReceiptNo,ROUND(LT.NetAmount,2)NetAmount,ltd.IsPackage,ROUND(LT.DiscountOnTotal,2)DiscountOnTotal,Round(ltd.DiscountPercentage,2)DiscountPercentage,ROUND(LT.GrossAmount,2)GrossAmount,Round(LT.Adjustment,2)Adjustment,DATE_FORMAT(LT.Date,'%d-%b-%y %T')DATE,   ");
                sb.Append("LT.TypeOfTnx,pm.CustomerID,CONCAT(PM.Title,' ',PM.Name)PName,PM.Age,IFNULL(pm.ContactNo,'')ContactNo,pm.Address,    ");
                sb.Append("'' PatientID,lt.PanelID,'' DoctorID,im.Type_ID,im.IsUsable,im.ServiceItemID,im.ToBeBilled,   ");
                sb.Append("LT.BillNo,st.BatchNumber, DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y') AS MedExpiryDate,st.IsExpirable,   ");
                sb.Append("sd.SoldUnits AS AvlQty,st.UnitType,st.StockID,st.ItemID,st.ItemName,st.SubCategoryID,sd.PerUnitBuyPrice,sd.PerUnitSellingPrice AS MRP,lt.DiscountApproveBy,lt.DiscountReason,lt.GovTaxPer,lt.GovTaxAmount,IF(LT.Adjustment=0,'Credit','Cash')PaymentMode,IFNULL(LT.IPNo,'')IPNo,lt.PatientType, ");
                //gst change
                sb.Append(" IFNULL(sd.HSNCode,'')HSNCode,sd.IGSTPercent,sd.IGSTAmt,sd.SGSTPercent,sd.SGSTAmt,sd.CGSTPercent,sd.CGSTAmt,IFNULL(sd.GSTType,'')GSTType, ");
                //
                sb.Append(" sd.TaxPercent, IF(lt.Adjustment>0,1,4) PaymentModeID,(sd.TaxAmt/sd.SoldUnits) SaleTaxAmount,sd.TaxPercent SaleTaxPercent FROM f_ledgertransaction LT    ");
                sb.Append("INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo    ");
                sb.Append("left JOIN f_reciept r ON lt.LedgerTransactionNo = r.AsainstLedgerTnxNo   ");
                sb.Append("INNER JOIN f_stock ST ON LTD.StockID=ST.StockID INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID   ");
                sb.Append("INNER JOIN f_salesdetails sd ON ltd.ID=sd.LedgerTnxNo   ");
                sb.Append("INNER JOIN  patient_general_master PM ON lt.LedgerTransactionNo = pm.AgainstLedgerTnxNo    ");
                sb.Append("WHERE  lt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " And lt.DeptLedgerNo='" + departmentLedgerNo + "'  ");
                if (txtReceiptNo.Text.Trim() != "")
                {
                    sb.Append("AND r.ReceiptNo='" + txtReceiptNo.Text.Trim() + "'  ");
                }
                if (txtBillNo.Text.Trim() != "")
                {
                    sb.Append("AND LT.BillNo='" + txtBillNo.Text.Trim() + "' ");
                }
                sb.Append("  GROUP BY sd.StockID  ORDER BY   ltd.ID ) t  ");
                sb.Append("LEFT OUTER JOIN (SELECT LedgerTransactionNo,AgainstLedgerTnxNo,StockID,ItemID,SUM(SoldUnits) ReturnQty,SUM(PerUnitSellingPrice) AS MRP FROM f_salesdetails WHERE ");
                if (txtReceiptNo.Text.Trim() != "")
                    sb.Append(" AgainstLedgerTnxNo=(SELECT AsainstLedgerTnxNo FROM f_reciept WHERE ReceiptNo='" + txtReceiptNo.Text.Trim() + "')   ");
                else
                    sb.Append(" AgainstLedgerTnxNo=(SELECT LedgerTransactionNo FROM f_ledgertransaction WHERE BillNo='" + txtBillNo.Text.Trim() + "') ");
                sb.Append("AND IsReturn=1 GROUP BY StockID) AS rt ON t.LedgerTransactionNo = rt.AgainstLedgerTnxNo AND t.StockID = rt.StockID  ");
                sb.Append(")tt WHERE tt.AvlQty>0  ");
            }
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {

            //if (Util.GetInt(dt.Rows[0]["BillDateStatus"].ToString()) == 0)
            //{
            //    divPaymentControlParent.Style.Add("display", "none");
            //    divSave.Style.Add("display", "none");
            //    lblMsg.Text = "You can return current date bill only.";
            //    pnlInfo.Visible = false;
            //    grdItem.DataSource = null;
            //    grdItem.DataBind();
            //    return;
            //}

            if (dt.Rows[0]["Patient_Type"].ToString() == "OPD")
                lblMRNo.Text = dt.Rows[0]["PatientID"].ToString();
            else if (dt.Rows[0]["Patient_Type"].ToString() == "EMG")
                lblMRNo.Text = dt.Rows[0]["PatientID"].ToString();
            else
                lblMRNo.Text = dt.Rows[0]["CustomerID"].ToString();
            if (dt.Rows[0]["IPNo"].ToString() != "")
                lblIPDNo.Text = dt.Rows[0]["IPNo"].ToString().Replace("ISHHI", "");
            else
                lblIPDNo.Text = "";
            lblPatientName.Text = dt.Rows[0]["PName"].ToString();
            lblAddress.Text = dt.Rows[0]["Address"].ToString();
            lblContactNo.Text = dt.Rows[0]["ContactNo"].ToString();
            lblAge.Text = dt.Rows[0]["Age"].ToString();
            lblDoctorID.Text = dt.Rows[0]["DoctorID"].ToString();
            lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
            lblDiscReason.Text = dt.Rows[0]["DiscountReason"].ToString();
            //niraj  ((Label)PaymentControl.FindControl("lblGovTaxPer")).Text = "Gov. Tax (" + (dt.Rows[0]["GovTaxPer"].ToString()).TrimStart('0').TrimEnd('0', '.') + " %) :&nbsp; ";
            lblGovTaxPer.Text = dt.Rows[0]["GovTaxPer"].ToString();
            lblGovTaxAmt.Text = dt.Rows[0]["GovTaxAmount"].ToString();
            lblAppBy.Text = dt.Rows[0]["DiscountApproveBy"].ToString();
            lblCustomerId.Text = dt.Rows[0]["CustomerID"].ToString();
            lblAmtPaid.Text = dt.Rows[0]["Adjustment"].ToString();
            lblNetAmt.Text = dt.Rows[0]["NetAmount"].ToString();
            lblreceiptno.Text = dt.Rows[0]["ReceiptNo"].ToString();
            lblRefund_Against_BillNo.Text = dt.Rows[0]["BillNo"].ToString();
            lblPatientType.Text = dt.Rows[0]["PatientType"].ToString();
            lblPatientReturnType.Text = dt.Rows[0]["Patient_Type"].ToString().Trim();
            lblBalAmt.Text = Util.GetString(Math.Round(Util.GetDecimal(lblNetAmt.Text) + Util.GetDecimal(lblGovTaxAmt.Text) - Util.GetDecimal(lblAmtPaid.Text), MidpointRounding.AwayFromZero));
            //lblBalAmt.Text = Util.GetString(Util.GetDecimal(lblNetAmt.Text) + Util.GetDecimal(lblGovTaxAmt.Text) - Util.GetDecimal(lblAmtPaid.Text));

            if (Math.Round(Util.GetDecimal(lblNetAmt.Text) + Util.GetDecimal(lblGovTaxAmt.Text) - Util.GetDecimal(lblAmtPaid.Text), 2, MidpointRounding.AwayFromZero) < 1)
                lblBalAmt.Text = "0";
            lblPaymentStatus.Text = dt.Rows[0]["PaymentMode"].ToString();
            lblPaymentStatus.Attributes.Add("PaymentModeID", dt.Rows[0]["PaymentModeID"].ToString().Trim());
            if ((Math.Round(Util.GetDecimal(lblNetAmt.Text) + Util.GetDecimal(lblGovTaxAmt.Text) - Util.GetDecimal(lblAmtPaid.Text), 2, MidpointRounding.AwayFromZero) > 1) && (lblPaymentStatus.Text) != "Credit" )
            {


                lblIsCredit.Text = "1";

                //lblMsg.Text = "Please Settle Previous Amount";
                //divSave.Style.Add("display", "none");
                //pnlInfo.Visible = false;
                //return;
            }
                 if(txtEmergencyNo.Text=="")
            {
                 if (Util.GetDecimal(lblAmtPaid.Text) == 0)
                {
                    lblMsg.Text = "For this Billno. Please use the option:OPD Credit Return";
                    divSave.Style.Add("display", "none");
                    pnlInfo.Visible = false;
                    return;
                }
             }
          
            lblLedgerno.Text = Util.GetString(dt.Rows[0]["LedgerTransactionNo"].ToString());

            pnlInfo.Visible = true;
            grdItem.DataSource = dt;
            grdItem.DataBind();
            lblMsg.Text = "";
            UserControl uc = (UserControl)Page.LoadControl("~/design/Controls/UCPayment.ascx");
            divPaymentUserControl.Controls.Add(uc);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "PaymentControlInit", "$(function () { $paymentControlInit(function(){});});", true);
            divPaymentControlParent.Style.Remove("display");
            divSave.Style.Remove("display");
        }
        else
        {
            divPaymentControlParent.Style.Add("display", "none");
            divSave.Style.Add("display", "none");
            lblMsg.Text = "No Record found";
            pnlInfo.Visible = false;
            grdItem.DataSource = null;
            grdItem.DataBind();
            return;
        }
    }

    //protected void btnAddItem_Click(object sender, EventArgs e)
    //{
    //    if (ValidateItems())
    //    {
    //        int flag = 0;
    //        DataTable dt = null;
    //        if (ViewState["DataItem"] != null)
    //        {
    //            dt = (DataTable)ViewState["DataItem"];
    //        }
    //        else
    //        {
    //            dt = GetItemDataTable();
    //        }

    //        foreach (GridViewRow row in grdItem.Rows)
    //        {
    //            if (((CheckBox)row.FindControl("chkSelect")).Checked)
    //            {
    //                DataRow dr = dt.NewRow();
    //                dr["AgainstLedgerTnxNo"] = ((Label)row.FindControl("lblTnxNo")).Text;
    //                dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
    //                dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
    //                dr["BatchNumber"] = ((Label)row.FindControl("lblBatchNumber")).Text;
    //                dr["Expiry"] = ((Label)row.FindControl("lblExpiry")).Text;
    //                dr["MRP"] = ((Label)row.FindControl("lblMRP")).Text;
    //                decimal mrp = Util.GetDecimal(((Label)row.FindControl("lblMRP")).Text);
    //                dr["UnitType"] = ((Label)row.FindControl("lblUnitType")).Text;
    //                dr["SubCategoryID"] = ((Label)row.FindControl("lblSubCategory")).Text;
    //                decimal qty = Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text);
    //                dr["ReturnQty"] = qty;
    //                dr["StockID"] = ((Label)row.FindControl("lblStockID")).Text;
    //                decimal amount = qty * mrp;//np
    //                dr["Amount"] = amount;
    //                decimal grossAmt = Util.GetDecimal(((Label)row.FindControl("lblGrossAmt")).Text);
    //                decimal discountOnTotal = Util.GetDecimal(((Label)row.FindControl("lblDiscAmtonTotal")).Text);
    //                decimal discPer = (discountOnTotal * 100) / grossAmt;
    //                dr["DiscAmt"] = (amount * discPer) / 100;
    //                dr["UnitPrice"] = Util.GetDecimal(((Label)row.FindControl("lblPerUnitBuyPrice")).Text);
    //                dr["IsUsable"] = Util.GetString(((Label)row.FindControl("lblIsUsable")).Text);
    //                dr["ToBeBilled"] = Util.GetInt(((Label)row.FindControl("lblToBeBilled")).Text);
    //                decimal govTax = (Util.GetDecimal(lblGovTaxPer.Text) / 100) * (amount - (amount * discPer) / 100);
    //                dr["TaxAmt"] = govTax;
    //               // ((TextBox)PaymentControl.FindControl("txtDiscReason")).Text = "Hospital Discount";
    //                dr["IsExpirable"] = ((Label)row.FindControl("lblIsExpirable")).Text;
    //                dr["TaxPercent"] = ((Label)row.FindControl("lblTaxPercent")).Text;
    //                dr["Type_ID"] = ((Label)row.FindControl("lblType_ID")).Text;
    //                //GST Changes
    //                dr["HSNCode"] = ((Label)row.FindControl("lblHSNCode")).Text;
    //                dr["IGSTPercent"] = ((Label)row.FindControl("lblIGSTPercent")).Text;
    //                dr["SGSTPercent"] = ((Label)row.FindControl("lblSGSTPercent")).Text;
    //                dr["CGSTPercent"] = ((Label)row.FindControl("lblCGSTPercent")).Text;
    //                dr["GSTType"] = ((Label)row.FindControl("lblGSTType")).Text;

    //                dt.Rows.Add(dr);
    //                flag = 1;
    //            }

    //        }
    //        if (flag == 1)
    //        {
    //            //gvIssueItem.DataSource = dt;
    //            //gvIssueItem.DataBind();
    //            //ViewState["DataItem"] = dt;
    //            //pnlOpdReturn.Visible = true;
    //           // getReturnPayment();
    //           // PaymentEnableFalse();
    //            lblMsg.Text = "";
    //        }
    //        else
    //        {
    //            lblMsg.Text = "Kindly Select Item";
    //            return;
    //        }

    //    }

    //}
    //private void getReturnPayment()
    //{
    //    DataTable dtNew = null;
    //    if (ViewState["DataItem"] != null)
    //    {
    //        dtNew = (DataTable)ViewState["DataItem"];
    //    }
    //    ((TextBox)PaymentControl.FindControl("txtDiscReason")).Text = lblDiscReason.Text;
    //    ((DropDownList)PaymentControl.FindControl("ddlApproveBy")).SelectedIndex = ((DropDownList)PaymentControl.FindControl("ddlApproveBy")).Items.IndexOf(((DropDownList)PaymentControl.FindControl("ddlApproveBy")).Items.FindByText(lblAppBy.Text));

    //    decimal amount = Math.Round(Util.GetDecimal(dtNew.Compute("sum(Amount)", "")), 2);
    //    decimal discount = Math.Round(Util.GetDecimal(dtNew.Compute("sum(DiscAmt)", "")), 2);
    //    decimal taxAmt = Math.Round(Util.GetDecimal(dtNew.Compute("sum(TaxAmt)", "")), 2);

    //    ((TextBox)PaymentControl.FindControl("txtBillAmount")).Text = Util.GetString(amount);
    //    if (discount > 0)
    //        ((TextBox)PaymentControl.FindControl("txtDisAmount")).Text = Util.GetString(discount);
    //    else
    //        ((TextBox)PaymentControl.FindControl("txtDisAmount")).Text = "";
    //    ((TextBox)PaymentControl.FindControl("txtGovTaxAmt")).Text = Util.GetString(taxAmt);
    //    ((TextBox)PaymentControl.FindControl("txtNetAmount")).Text = Util.GetString(Math.Round(amount - discount, 2, MidpointRounding.AwayFromZero));

    //    decimal totalPaidAmt = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtNetAmount")).Text) + Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtGovTaxAmt")).Text);

    //    ((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text = Util.GetString(Math.Round(amount - discount + taxAmt));
    //    ((Label)PaymentControl.FindControl("lblBalanceAmount")).Text = ((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text;

    //    ((Label)PaymentControl.FindControl("lblRoundVal")).Text = Math.Round((Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text) - Util.GetDecimal(totalPaidAmt)), 2, System.MidpointRounding.AwayFromZero).ToString();
    //    ((TextBox)PaymentControl.FindControl("txtCurrencyBase")).Text = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text).ToString();
    //    ((TextBox)PaymentControl.FindControl("txtPaidAmount")).Text = ((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text;
    //    AllSelectQuery asq = new AllSelectQuery();
    //    decimal rate = asq.ConvertCurrencyBase(Util.GetInt(((DropDownList)PaymentControl.FindControl("ddlCountry")).SelectedValue), Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text));

    //    ((Label)PaymentControl.FindControl("lblCurrencyBase")).Text = Util.GetString(rate) + " " + ((TextBox)PaymentControl.FindControl("lblCurrencyNotation")).Text;
    //    if (lblPaymentStatus.Text == "Credit")
    //    {
    //        ((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).SelectedItem.Text = "Credit";
    //        ((Button)PaymentControl.FindControl("btnAdd")).Enabled = false;
    //        ((TextBox)PaymentControl.FindControl("txtPaidAmount")).Enabled = false;
    //    }
    //    else
    //    {
    //        ((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).SelectedIndex = 0;
    //        ((Button)PaymentControl.FindControl("btnAdd")).Enabled = true;
    //        ((TextBox)PaymentControl.FindControl("txtPaidAmount")).Enabled = true;
    //    }
    //}

    //private void PaymentEnableFalse()
    //{
    //    ((TextBox)PaymentControl.FindControl("txtBillAmount")).Enabled = false;
    //    ((TextBox)PaymentControl.FindControl("txtNetAmount")).Enabled = false;
    //    ((TextBox)PaymentControl.FindControl("txtDisAmount")).Enabled = false;
    //    ((TextBox)PaymentControl.FindControl("txtDisPercent")).Enabled = false;
    //    ((TextBox)PaymentControl.FindControl("txtDiscReason")).Enabled = false;
    //    ((DropDownList)PaymentControl.FindControl("ddlPaymentMode")).Enabled = false;
    //    ((DropDownList)PaymentControl.FindControl("ddlApproveBy")).Enabled = false;
    //}

    #region Validation
    private bool ValidateItems()
    {
        DataTable dt = null;
        if (ViewState["DataItem"] != null)
            dt = (DataTable)ViewState["DataItem"];
        bool status = true;
        foreach (GridViewRow row in grdItem.Rows)
        {
            if (((CheckBox)row.FindControl("chkSelect")).Checked)
            {
                status = false;
                if (dt != null && dt.Rows.Count > 0)
                {
                    string stockID = ((Label)row.FindControl("lblStockID")).Text;
                    DataRow[] drow = dt.Select("StockID = '" + stockID + "'");
                    if (drow.Length > 0)
                    {
                        lblMsg.Text = "Item Already Selected";
                        return false;
                    }
                }
                if (Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text) <= 0)
                {
                    lblMsg.Text = "Kindly Enter Return Quantity";
                    return false;
                }

                decimal returnQty = 0; decimal availQty = 0;
                returnQty = Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text);
                availQty = Util.GetDecimal(((Label)row.FindControl("lblAvailQty")).Text);
                if (returnQty > availQty)
                {
                    lblMsg.Text = "Return Quantity is not Available";
                    return false;
                }
            }
        }
        if (status)
        {
            lblMsg.Text = "Please Select Items";
            return false;
        }
        lblMsg.Text = string.Empty;
        return true;
    }
    #endregion


    protected void btnSave_Click(object sender, EventArgs e)
    {
        //if (Util.GetDecimal(((Label)PaymentControl.FindControl("lblBalanceAmount")).Text) > 0)
        //{
        //    lblMsg.Text = "Please Return Total Amount";
        //    ((TextBox)PaymentControl.FindControl("txtPaidAmount")).Focus();
        //    return;
        //}

        //  int salesNo = SaveData();
        //if (salesNo != 0)
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "location.href='OPD_Return.aspx';", true);
        //}
        //else
        //{
        //    //lblMsg.Text = "Error...";
        //}
    }
    //    private int SaveData()
    //    {
    //        if (ViewState["DataItem"] != null)
    //        {
    //            MySqlConnection con = Util.GetMySqlCon();
    //            con.Open();
    //            MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

    //            try
    //            {
    //                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranx, CommandType.Text, "select Get_SalesNo('17','" + AllGlobalFunction.MedicalStoreID + "','" + Session["CentreID"].ToString() + "') "));

    //                DataTable dtItem = new DataTable();
    //                dtItem = (DataTable)ViewState["DataItem"];

    //                string tID = "", ledTxnID = "";
    //                decimal discAmt = 0, discPer = 0;

    //                decimal totalGrossAmt = 0;
    //                totalGrossAmt = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtBillAmount")).Text);



    //                if (((TextBox)PaymentControl.FindControl("txtDisPercent")).Text != string.Empty)
    //                {
    //                    discAmt = (Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtDisPercent")).Text.Trim()) * totalGrossAmt) / 100;
    //                    discPer = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtDisPercent")).Text.Trim());
    //                }
    //                else
    //                {
    //                    discAmt = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtDisAmount")).Text.Trim());
    //                    discPer = (discAmt * 100) / totalGrossAmt;
    //                }

    //                DataTable dtPaymentDetail = ViewState["dtPaymentDetail"] as DataTable;
    //                if (dtPaymentDetail == null)
    //                {
    //                    dtPaymentDetails();
    //                    dtPaymentDetail = ViewState["dtPaymentDetail"] as DataTable;
    //                }
    //                if ((((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count == 0) && lblPaymentStatus.Text == "Cash")
    //                {
    //                    if (discAmt == totalGrossAmt)
    //                    {
    //                        DataTable dt = StockReports.GetDataTable("SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 ");
    //                        if (dt.Rows.Count > 0)
    //                        {
    //                            AllSelectQuery aSQ = new AllSelectQuery();
    //                            DataRow drRow = dtPaymentDetail.NewRow();
    //                            drRow["PaymentMode"] = "Cash";
    //                            drRow["PaymentModeID"] = "1";
    //                            drRow["PaidAmount"] = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text);
    //                            drRow["Currency"] = dt.Rows[0]["S_Currency"].ToString();
    //                            drRow["CountryID"] = dt.Rows[0]["S_CountryID"].ToString();
    //                            drRow["BankName"] = "";
    //                            drRow["RefNo"] = "";
    //                            drRow["BaceCurrency"] = dt.Rows[0]["B_Currency"].ToString();
    //                            drRow["C_Factor"] = aSQ.GetConversionFactor(Util.GetInt(dt.Rows[0]["S_CountryID"])).ToString();
    //                            drRow["BaseCurrency"] = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text);
    //                            drRow["Notation"] = dt.Rows[0]["S_Notation"].ToString();
    //                            drRow["PaymentRemarks"] = ((TextBox)PaymentControl.FindControl("txtRemarks")).Text;
    //                            drRow["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
    //                            dtPaymentDetail.Rows.Add(drRow);
    //                        }
    //                    }
    //                }
    //                else if ((((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count == 0) && lblPaymentStatus.Text == "Credit")
    //                {
    //                    DataTable dt = StockReports.GetDataTable("SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 ");
    //                    if (dt.Rows.Count > 0)
    //                    {
    //                        AllSelectQuery aSQ = new AllSelectQuery();
    //                        DataRow drRow = dtPaymentDetail.NewRow();
    //                        drRow["PaymentMode"] = "Credit";
    //                        drRow["PaymentModeID"] = "4";
    //                        drRow["PaidAmount"] = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text);
    //                        drRow["Currency"] = dt.Rows[0]["S_Currency"].ToString();
    //                        drRow["CountryID"] = dt.Rows[0]["S_CountryID"].ToString();
    //                        drRow["BankName"] = "";
    //                        drRow["RefNo"] = "";
    //                        drRow["BaceCurrency"] = dt.Rows[0]["B_Currency"].ToString();
    //                        drRow["C_Factor"] = aSQ.GetConversionFactor(Util.GetInt(dt.Rows[0]["S_CountryID"])).ToString();
    //                        drRow["BaseCurrency"] = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text);
    //                        drRow["Notation"] = dt.Rows[0]["S_Notation"].ToString();
    //                        drRow["PaymentRemarks"] = ((TextBox)PaymentControl.FindControl("txtRemarks")).Text;
    //                        drRow["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
    //                        dtPaymentDetail.Rows.Add(drRow);
    //                    }
    //                }
    //                else if ((((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count > 0))
    //                {
    //                    for (int i = 0; i < ((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows.Count; i++)
    //                    {
    //                        DataRow dr = dtPaymentDetail.NewRow();
    //                        dr["PaymentMode"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblPaymentMode")).Text;
    //                        dr["PaymentModeID"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblPaymentModeID")).Text;
    //                        dr["PaidAmount"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblAmount")).Text;
    //                        dr["Currency"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblCurrency")).Text;
    //                        dr["CountryID"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblCountryID")).Text;
    //                        dr["BankName"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblBankName")).Text;
    //                        dr["RefNo"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblRefNo")).Text;
    //                        dr["BaceCurrency"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblBaseCurrency")).Text;
    //                        dr["C_Factor"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblConversionFactor")).Text;
    //                        dr["BaseCurrency"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblBaseCurrencyAmount")).Text;
    //                        dr["Notation"] = ((Label)((GridView)PaymentControl.FindControl("grdPaymentMode")).Rows[i].FindControl("lblNotation")).Text;
    //                        dr["PaymentRemarks"] = ((TextBox)PaymentControl.FindControl("txtRemarks")).Text;
    //                        dr["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
    //                        dtPaymentDetail.Rows.Add(dr);
    //                    }
    //                }
    //                else
    //                {
    //                    lblMsg.Text = "Please Enter Amount";
    //                    ViewState["dtPaymentDetail"] = null;
    //                    return 0;
    //                }
    //                decimal netAmount = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtTotalPaidAmount")).Text);
    //                decimal amountPaid = Util.GetDecimal(((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text);
    //                decimal roundOff = Util.GetDecimal(((Label)PaymentControl.FindControl("lblRoundVal")).Text);
    //                string discountReason = Util.GetString(((TextBox)PaymentControl.FindControl("txtDiscReason")).Text);
    //                string discountApproveBy = Util.GetString(((DropDownList)PaymentControl.FindControl("ddlApproveBy")).Text);

    //                string ledgerNumber = ""; string receiptNo = "";

    //                if (rdoReturn.SelectedItem.Value == "OPD")
    //                {
    //                    ledgerNumber = "CASH001";
    //                }
    //                else
    //                {
    //                    ledgerNumber = "CASH002";
    //                }

    //                Patient_Medical_History objPmh = new Patient_Medical_History(tranx);
    //                if (rdoReturn.SelectedItem.Value == "OPD")
    //                    objPmh.PatientID = lblMRNo.Text.ToString();
    //                else
    //                    objPmh.PatientID = "CASH002";
    //                objPmh.DoctorID = lblDoctorID.Text.ToString();
    //                objPmh.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
    //                objPmh.Time = Util.GetDateTime(DateTime.Now);
    //                objPmh.DateOfVisit = Util.GetDateTime(DateTime.Now);
    //                objPmh.Type = "OPD";
    //                objPmh.PanelID = Util.GetInt(lblPanelID.Text.ToString());
    //                objPmh.ParentID = Util.GetInt(lblPanelID.Text.ToString());
    //                objPmh.ReferedBy = "";
    //                objPmh.patient_type = "1";
    //                objPmh.Source = "OPD-Return";
    //                objPmh.EntryDate = Util.GetDateTime(DateTime.Now);
    //                objPmh.HashCode = txtHash.Text.Trim();
    //                objPmh.UserID = ViewState["UserID"].ToString();
    //                objPmh.ScheduleChargeID = Util.GetInt(StockReports.GetCurrentRateScheduleID(Util.GetInt(lblPanelID.Text.ToString())));
    //                objPmh.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());

    //                tID = objPmh.Insert();
    //                if (tID == string.Empty)
    //                {
    //                    tranx.Rollback();
    //                    tranx.Dispose();
    //                    con.Close();
    //                    con.Dispose();
    //                    lblMsg.Text = "Error...";
    //                    return 0;
    //                }

    //                //Insert into f_LedgerTransaction Single row effect
    //                Ledger_Transaction objLedTran = new Ledger_Transaction(tranx);
    //                objLedTran.LedgerNoCr = ledgerNumber;
    //                objLedTran.LedgerNoDr = "STO00001";
    //                objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
    //                objLedTran.TransactionID = tID;
    //                objLedTran.TypeOfTnx = "Pharmacy-Return";
    //                objLedTran.PanelID = Util.GetInt(lblPanelID.Text.ToString());
    //                if (rdoReturn.SelectedItem.Value == "OPD")
    //                    objLedTran.PatientID = lblMRNo.Text.ToString();
    //                else
    //                    objLedTran.PatientID = "CASH002";
    //                objLedTran.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
    //                objLedTran.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
    //                objLedTran.NetAmount = -netAmount;
    //                objLedTran.GrossAmount = -totalGrossAmt;
    //                objLedTran.DiscountOnTotal = -discAmt;
    //                objLedTran.DiscountReason = discountReason;
    //                objLedTran.DiscountApproveBy = discountApproveBy;
    //                objLedTran.Adjustment = -amountPaid;
    //                objLedTran.TransactionType_ID = 17;
    //                objLedTran.IndentNo = "";
    //                objLedTran.IsPaid = 1;
    //                objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
    //                //decimal Round = AmountPaid - netAmount;
    //                if (Util.GetDecimal(((Label)PaymentControl.FindControl("lblRoundVal")).Text) > 0)
    //                    objLedTran.RoundOff = -Util.GetDecimal(((Label)PaymentControl.FindControl("lblRoundVal")).Text);
    //                else
    //                    objLedTran.RoundOff = Math.Abs(Util.GetDecimal(((Label)PaymentControl.FindControl("lblRoundVal")).Text));
    //                //  objLedTran.RoundOff = Round;
    //                objLedTran.PaymentModeID = Util.GetInt(dtPaymentDetail.Rows[0]["PaymentModeID"]);
    //                objLedTran.IsCancel = Util.GetInt(rdbpaid.SelectedItem.Value);
    //                objLedTran.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
    //                objLedTran.UserID = ViewState["UserID"].ToString();
    //                objLedTran.UniqueHash = txtHash.Text.Trim();
    //                objLedTran.Remarks = ((TextBox)PaymentControl.FindControl("txtRemarks")).Text.Trim();

    //                objLedTran.GovTaxAmount = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtGovTaxAmt")).Text.Trim());
    //                objLedTran.GovTaxPer = Util.GetDecimal(lblGovTaxPer.Text.Trim());
    //                objLedTran.Refund_Against_BillNo = lblRefund_Against_BillNo.Text.Trim();
    //                if (lblIPDNo.Text != "")
    //                    objLedTran.IPNo = "ISHHI" + lblIPDNo.Text;
    //                else
    //                    objLedTran.IPNo = "";
    //                objLedTran.PatientType = lblPatientType.Text.Trim();
    //                objLedTran.IpAddress = All_LoadData.IpAddress();
    //                string creditBillNO = Util.GetString(MySqlHelper.ExecuteScalar(tranx, CommandType.Text, "select get_billno_store_return('" + ViewState["DeptLedgerNo"].ToString() + "','" + Session["CentreID"].ToString() + "')"));
    //                if (creditBillNO == string.Empty)
    //                {
    //                    tranx.Rollback();
    //                    tranx.Dispose();
    //                    con.Close();
    //                    con.Dispose();
    //                    lblMsg.Text = "Error...";
    //                    return 0;
    //                }

    //                objLedTran.BillNo = creditBillNO;
    //                objLedTran.BillDate = DateTime.Now;
    //                ledTxnID = objLedTran.Insert();

    //                if (ledTxnID == string.Empty)
    //                {
    //                    tranx.Rollback();
    //                    tranx.Dispose();
    //                    con.Close();
    //                    con.Dispose();
    //                    lblMsg.Text = "Error...";
    //                    return 0;
    //                }

    //                decimal NetAmt = 0;
    //                for (int i = 0; i < dtItem.Rows.Count; i++)
    //                {


    //                    //---------------- Insert into Ledger Trans Details Table Multiple Row Effect-----------
    //                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tranx);
    //                    objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
    //                    objLTDetail.LedgerTransactionNo = ledTxnID;
    //                    objLTDetail.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
    //                    objLTDetail.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
    //                    objLTDetail.SubCategoryID = Util.GetString(dtItem.Rows[i]["SubCategoryID"]);
    //                    objLTDetail.TransactionID = tID;
    //                    objLTDetail.Rate = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
    //                    objLTDetail.Quantity = -Util.GetDecimal(dtItem.Rows[i]["ReturnQty"]);
    //                    objLTDetail.IsVerified = 1;
    //                    objLTDetail.ItemName = Util.GetString(dtItem.Rows[i]["ItemName"]) + " (Batch : " + Util.GetString(dtItem.Rows[i]["BatchNumber"]) + ")";
    //                    objLTDetail.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
    //                    decimal discAmtPerItem = ((objLTDetail.Rate * Util.GetDecimal(dtItem.Rows[i]["ReturnQty"])) * discPer) / 100;
    //                    objLTDetail.Amount = -Util.GetDecimal((objLTDetail.Rate * Util.GetDecimal(dtItem.Rows[i]["ReturnQty"])) - discAmtPerItem);
    //                    objLTDetail.DiscAmt = -discAmtPerItem;
    //                    objLTDetail.DiscountPercentage = discPer;
    //                    objLTDetail.DiscountReason = discountReason;
    //                    objLTDetail.NetItemAmt = -Util.GetDecimal((objLTDetail.Rate * Util.GetDecimal(dtItem.Rows[i]["ReturnQty"])) - discAmtPerItem);
    //                    objLTDetail.TotalDiscAmt = -discAmtPerItem;
    //                    objLTDetail.UserID = ViewState["UserID"].ToString();
    //                    objLTDetail.TransactionID = tID;
    //                    objLTDetail.TnxTypeID = Util.GetInt("17");
    //                    objLTDetail.IsReusable = Util.GetString(dtItem.Rows[i]["IsUsable"]);
    //                    objLTDetail.ToBeBilled = Util.GetInt(dtItem.Rows[i]["ToBeBilled"]);
    //                    objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
    //                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
    //                    objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
    //                    objLTDetail.IpAddress = All_LoadData.IpAddress();
    //                    objLTDetail.Type = "O";
    //                    objLTDetail.medExpiryDate = Util.GetDateTime(dtItem.Rows[i]["Expiry"]);
    //                    objLTDetail.IsExpirable = Util.GetInt(dtItem.Rows[i]["IsExpirable"]);
    //                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dtItem.Rows[i]["SubCategoryID"]),con));
    //                    objLTDetail.TransactionType_ID = 17;
    //                    objLTDetail.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
    //                    objLTDetail.VarifiedUserID = Convert.ToString(Session["ID"]);
    //                    objLTDetail.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
    //                    objLTDetail.StoreLedgerNo = "STO00001";
    //                    objLTDetail.IsMedService = 1;

    //                    objLTDetail.PurTaxPer = Util.GetDecimal(dtItem.Rows[i]["TaxPercent"]);
    //                    if (Util.GetDecimal(dtItem.Rows[i]["TaxPercent"]) > 0)
    //                        objLTDetail.PurTaxAmt =Math.Abs( Util.GetDecimal(Util.GetDecimal(objLTDetail.Amount) * Util.GetDecimal(dtItem.Rows[i]["TaxPercent"])) / 100);
    //                    else
    //                        objLTDetail.PurTaxAmt = 0;
    //                    objLTDetail.BatchNumber = Util.GetString(dtItem.Rows[i]["BatchNumber"]);
    //                    objLTDetail.unitPrice = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]);
    //                    //GST Changes
    //                    decimal igstPercent = Util.GetDecimal(dtItem.Rows[i]["IGSTPercent"]);
    //                    decimal csgtPercent = Util.GetDecimal(dtItem.Rows[i]["CGSTPercent"]);
    //                    decimal sgstPercent = Util.GetDecimal(dtItem.Rows[i]["SGSTPercent"]);

    //                    decimal nonTaxableRate = (objLTDetail.Rate * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
    //                    decimal discount = objLTDetail.Rate * objLTDetail.DiscountPercentage / 100;
    //                    decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

    //                    decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
    //                    decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
    //                    decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);
    //                    objLTDetail.HSNCode = Util.GetString(dtItem.Rows[i]["HSNCode"]);
    //                    objLTDetail.IGSTPercent = igstPercent;
    //                    objLTDetail.IGSTAmt = Util.GetDecimal(IGSTTaxAmount);
    //                    objLTDetail.CGSTPercent = csgtPercent;
    //                    objLTDetail.CGSTAmt = Util.GetDecimal(CGSTTaxAmount);
    //                    objLTDetail.SGSTPercent = sgstPercent;
    //                    objLTDetail.SGSTAmt = Util.GetDecimal(SGSTTaxAmount);
    //                    //
    //                    int iD = objLTDetail.Insert();

    //                    NetAmt = NetAmt + Util.GetDecimal(objLTDetail.Amount);
    //                    if (iD == 0)
    //                    {
    //                        tranx.Rollback();
    //                        tranx.Dispose();
    //                        con.Close();
    //                        con.Dispose();
    //                        lblMsg.Text = "Error...";
    //                        return 0;
    //                    }


    //                    //---------------- Insert into Sales Details Table-----------

    //                    Sales_Details objSales = new Sales_Details(tranx);
    //                    objSales.LedgerNumber = ledgerNumber;
    //                    objSales.DepartmentID = "STO00001";
    //                    objSales.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
    //                    objSales.SoldUnits = Util.GetFloat(dtItem.Rows[i]["ReturnQty"]);
    //                    objSales.PerUnitBuyPrice = Util.GetFloat(dtItem.Rows[i]["UnitPrice"]);
    //                    objSales.PerUnitSellingPrice = Util.GetFloat(dtItem.Rows[i]["MRP"]);
    //                    objSales.Date = System.DateTime.Now;
    //                    objSales.Time = System.DateTime.Now;
    //                    objSales.IsReturn = 1;
    //                    objSales.TrasactionTypeID = 17;
    //                    objSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
    //                    objSales.IsService = "NO";
    //                    objSales.IndentNo = "";
    //                    objSales.Naration = ((TextBox)PaymentControl.FindControl("txtRemarks")).Text;
    //                    objSales.SalesNo = SalesNo;
    //                    objSales.UserID = ViewState["UserID"].ToString();
    //                    objSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
    //                    objSales.PatientID = lblMRNo.Text.ToString();
    //                    objSales.LedgerTransactionNo = ledTxnID;
    //                    objSales.AgainstLedgerTnxNo = Util.GetString(dtItem.Rows[i]["AgainstLedgerTnxNo"]);
    //                    objSales.BillNoforGP = creditBillNO;
    //                    objSales.IsReusable = Util.GetString(dtItem.Rows[i]["IsUsable"]);
    //                    objSales.ToBeBilled = Util.GetInt(dtItem.Rows[i]["ToBeBilled"]);
    //                    objSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
    //                    objSales.Hospital_ID = Session["HOSPID"].ToString();
    //                   // objSales.Type_ID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select IFNULL(Type_ID,'')Type_ID from f_itemmaster where itemID='" + Util.GetString(dtItem.Rows[i]["ItemID"]) + "'"));
    //                    objSales.Type_ID = Util.GetString(dtItem.Rows[i]["Type_ID"]);
    //                    objSales.Refund_Against_BillNo = lblRefund_Against_BillNo.Text.Trim();
    //                    objSales.IpAddress = All_LoadData.IpAddress();
    //                    objSales.medExpiryDate = Util.GetDateTime(dtItem.Rows[i]["Expiry"]);
    //                    objSales.LedgerTnxNo = iD;
    //                    objSales.BatchNo = Util.GetString(dtItem.Rows[i]["BatchNumber"]);
    //                    objSales.TransactionID = tID;
    //                    objSales.TaxPercent = objLTDetail.PurTaxPer;
    //                    objSales.TaxAmt = objLTDetail.PurTaxAmt;

    //                    objSales.DiscAmt = discAmtPerItem;
    //                    objSales.DisPercent = discPer;
    //                    // Add new 29-06-2017 - For GST                
    //                    objSales.IGSTPercent = igstPercent;
    //                    objSales.IGSTAmt = Util.GetDecimal(IGSTTaxAmount);
    //                    objSales.CGSTPercent = csgtPercent;
    //                    objSales.CGSTAmt = Util.GetDecimal(CGSTTaxAmount);
    //                    objSales.SGSTPercent = sgstPercent;
    //                    objSales.SGSTAmt = Util.GetDecimal(SGSTTaxAmount);
    //                    objSales.HSNCode = Util.GetString(dtItem.Rows[i]["HSNCode"]);
    //                    objSales.GSTType = Util.GetString(dtItem.Rows[i]["GSTType"]);
    //                    //           
    //                    string salesID = objSales.Insert();
    //                    if (salesID == "")
    //                    {
    //                        tranx.Rollback();
    //                        tranx.Dispose();
    //                        con.Close();
    //                        con.Dispose();
    //                        lblMsg.Text = "Error...";
    //                        return 0;
    //                    }

    //                    //---- Update Release Count in Stock Table---------------------

    //                    string strStock = "";
    //                    if (dtItem.Rows[i]["IsUsable"].ToString() == "0" || dtItem.Rows[i]["IsUsable"].ToString() == "NR")
    //                    {


    //                        float soldstock = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(sd.SoldUnits) FROM  f_salesdetails sd WHERE sd.LedgerTransactionNo='" + lblLedgerno.Text.Trim() + "' AND  StockID='" + Util.GetString(dtItem.Rows[i]["StockID"]) + "' AND PatientID='" + lblMRNo.Text.Trim() + "'"));
    //                        float returnstock = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(sd.SoldUnits) FROM  f_salesdetails sd WHERE sd.AgainstLedgerTnxNo='" + lblLedgerno.Text.Trim() + "' AND  StockID='" + Util.GetString(dtItem.Rows[i]["StockID"]) + "' AND PatientID='" + lblMRNo.Text.Trim() + "'"));
    //                        if (soldstock <= returnstock && soldstock != 0.00 && returnstock != 0.00)
    //                        {
    //                            tranx.Rollback();
    //                            tranx.Dispose();
    //                            con.Close();
    //                            con.Dispose();
    //                            lblMsg.Text = "Stock already returned please reopen the page";
    //                            return 0;
    //                        }

    //                        strStock = "update f_stock set ReleasedCount = ReleasedCount -" + objSales.SoldUnits + " where StockID = '" + objSales.StockID + "' and ReleasedCount - " + objSales.SoldUnits + "<=InitialCount";

    //                        if (MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strStock) == 0)
    //                        {
    //                            tranx.Rollback();
    //                            tranx.Dispose();
    //                            con.Close();
    //                            con.Dispose();
    //                            lblMsg.Text = "Stock already returned please reopen the page";
    //                            return 0;
    //                        }
    //                    }
    //                }

    //                ////////////////insert in f_ledgertransaction_paymentDetail/////////////////////
    //                Ledger_Transaction_PaymentDetail objltPaymentDetail = new Ledger_Transaction_PaymentDetail(tranx);
    //                foreach (DataRow row in dtPaymentDetail.Rows)
    //                {
    //                    objltPaymentDetail.PaymentModeID = Util.GetInt(row["PaymentModeID"]);
    //                    objltPaymentDetail.PaymentMode = Util.GetString(row["PaymentMode"]);
    //                    objltPaymentDetail.Amount = -Util.GetDecimal(row["BaseCurrency"]);
    //                    objltPaymentDetail.LedgerTransactionNo = ledTxnID;
    //                    objltPaymentDetail.PaymentRemarks = Util.GetString(row["PaymentRemarks"]);
    //                    objltPaymentDetail.RefDate = Util.GetDateTime(row["RefDate"]);
    //                    objltPaymentDetail.RefNo = Util.GetString(row["RefNo"]);
    //                    objltPaymentDetail.BankName = Util.GetString(row["BankName"]);
    //                    objltPaymentDetail.C_Factor = Util.GetDecimal(row["C_Factor"]);
    //                    objltPaymentDetail.S_Amount = -Util.GetDecimal(row["PaidAmount"]);
    //                    objltPaymentDetail.S_CountryID = Util.GetInt(row["CountryID"]);
    //                    objltPaymentDetail.S_Currency = Util.GetString(row["Currency"]);
    //                    objltPaymentDetail.S_Notation = Util.GetString(row["Notation"]);
    //                    objltPaymentDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
    //                    objltPaymentDetail.Hospital_ID = Session["HOSPID"].ToString();
    //                    string paymentID = objltPaymentDetail.Insert().ToString();
    //                    if (paymentID == string.Empty)
    //                    {
    //                        tranx.Rollback();
    //                        tranx.Dispose();
    //                        con.Close();
    //                        con.Dispose();
    //                        lblMsg.Text = "Error...";
    //                        return 0;
    //                    }
    //                }

    //                ////////////////////////////// Insert in Receipt ///////////////////
    //                if (lblreceiptno.Text != "")
    //                {
    //                    if (dtPaymentDetail.Rows[0]["PaymentMode"].ToString() != "Credit")
    //                    {
    //                        Receipt objReceipt = new Receipt(tranx);
    //                        objReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
    //                        objReceipt.AmountPaid = -amountPaid;
    //                        objReceipt.AsainstLedgerTnxNo = ledTxnID;
    //                        objReceipt.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
    //                        objReceipt.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
    //                        objReceipt.Discount = 0;
    //                        objReceipt.PanelID = Util.GetInt(lblPanelID.Text.ToString());
    //                        objReceipt.IsCancel = Util.GetInt(rdbpaid.SelectedItem.Value);
    //                        objReceipt.Reciever = ViewState["UserID"].ToString();
    //                        if (rdoReturn.SelectedItem.Value == "OPD")
    //                            objReceipt.Depositor = lblMRNo.Text.ToString();
    //                        else
    //                            objReceipt.Depositor = "CASH002";
    //                        objReceipt.TransactionID = tID;
    //                        objReceipt.LedgerNoDr = "STO00001";
    //                        if (rdoReturn.SelectedItem.Value == "OPD")
    //                            objReceipt.LedgerNoCr = "CASH001";
    //                        else
    //                            objReceipt.LedgerNoCr = "CASH002";
    //                        objReceipt.RoundOff = roundOff;
    //                        objReceipt.deptLedgerNo = ViewState["DeptLedgerNo"].ToString();
    //                        objReceipt.CentreID = Util.GetInt(Session["CentreID"].ToString());
    //                        objReceipt.IpAddress = All_LoadData.IpAddress();
    //                        objReceipt.PaidBy = "PAT";
    //                         receiptNo = objReceipt.Insert();

    //                        if (receiptNo == string.Empty)
    //                        {
    //                            tranx.Rollback();
    //                            tranx.Dispose();
    //                            con.Close();
    //                            con.Dispose();
    //                            lblMsg.Text = "Error...";
    //                            return 0;
    //                        }

    //                        Receipt_PaymentDetail objReceiptPayment = new Receipt_PaymentDetail(tranx);
    //                        foreach (DataRow row in dtPaymentDetail.Rows)
    //                        {
    //                            objReceiptPayment.PaymentModeID = Util.GetInt(row["PaymentModeID"]);
    //                            objReceiptPayment.PaymentMode = Util.GetString(row["PaymentMode"]);
    //                            objReceiptPayment.Amount = -Util.GetDecimal(row["BaseCurrency"]);
    //                            objReceiptPayment.ReceiptNo = receiptNo;
    //                            objReceiptPayment.PaymentRemarks = Util.GetString(row["PaymentRemarks"]);
    //                            objReceiptPayment.RefDate = Util.GetDateTime(row["RefDate"]);
    //                            objReceiptPayment.RefNo = Util.GetString(row["RefNo"]);
    //                            objReceiptPayment.BankName = Util.GetString(row["BankName"]);
    //                            objReceiptPayment.C_Factor = Util.GetDecimal(row["C_Factor"]);
    //                            objReceiptPayment.S_Amount = -Util.GetDecimal(row["PaidAmount"]);
    //                            objReceiptPayment.S_CountryID = Util.GetInt(row["CountryID"]);
    //                            objReceiptPayment.S_Currency = Util.GetString(row["Currency"]);
    //                            objReceiptPayment.S_Notation = Util.GetString(row["Notation"]);
    //                            objReceiptPayment.CentreID = Util.GetInt(Session["CentreID"].ToString());
    //                            objReceiptPayment.Hospital_ID = Session["HOSPID"].ToString();
    //                            string paymentID = objReceiptPayment.Insert().ToString();

    //                            if (paymentID == string.Empty)
    //                            {
    //                                tranx.Rollback();
    //                                tranx.Dispose();
    //                                con.Close();
    //                                con.Dispose();
    //                                lblMsg.Text = "Error...";
    //                                return 0;
    //                            }
    //                        }

    //                        if (receiptNo == "")
    //                        {

    //                            return 0;
    //                        }

    //                        decimal pAmount = Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(amount) FROM f_patientaccount WHERE LedgerTransactionNo='" + Util.GetString(dtItem.Rows[0]["AgainstLedgerTnxNo"]) + "' and PatientID='" + "" + lblMRNo.Text.ToString() + "'  GROUP BY LedgerTransactionNo"));

    //                        if (pAmount > 0)
    //                        {
    //                            Pateint_account objPatientAccount = new Pateint_account(tranx);

    //                            objPatientAccount.Amount = amountPaid;
    //                            objPatientAccount.Type = "DEBIT";
    //                            objPatientAccount.TransactionId = objLedTran.TransactionID;
    //                            objPatientAccount.PatientId = objLedTran.PatientID;
    //                            objPatientAccount.UserId = ViewState["UserID"].ToString();
    //                            objPatientAccount.ReceiptNo = receiptNo;
    //                            objPatientAccount.LedgerTransactionNo = ledTxnID;
    //                            objPatientAccount.CentreID = Util.GetInt(Session["CentreID"].ToString());
    //                            objPatientAccount.Hospital_ID = Session["HOSPID"].ToString();
    //                            objPatientAccount.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
    //                            objPatientAccount.PageURL = All_LoadData.getCurrentPageName();
    //                            objPatientAccount.Insert();
    //                        }
    //                    }
    //                }


    //                if (lblPaymentStatus.Text == "Credit")
    //                {
    //                    MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "Update f_ledgerTransaction Set Adjustment=Adjustment+" + netAmount + " where LedgerTransactionNo='" + lblLedgerno.Text + "'");

    //                    Pateint_account objPatientAccount = new Pateint_account(tranx);
    //                    objPatientAccount.Amount = netAmount;
    //                    objPatientAccount.Type = "DEBIT";
    //                    objPatientAccount.TransactionId = objLedTran.TransactionID;
    //                    objPatientAccount.PatientId = objLedTran.PatientID;
    //                    objPatientAccount.UserId = ViewState["UserID"].ToString();
    //                    objPatientAccount.ReceiptNo = "";
    //                    objPatientAccount.LedgerTransactionNo = ledTxnID;
    //                    objPatientAccount.CentreID = Util.GetInt(Session["CentreID"].ToString());
    //                    objPatientAccount.Hospital_ID = Session["HOSPID"].ToString();
    //                    objPatientAccount.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
    //                    objPatientAccount.Insert();
    //                }
    //                tranx.Commit();
    //                tranx.Dispose();
    //                con.Close();
    //                con.Dispose();
    //                ViewState["dtPaymentDetail"] = null;
    //                lblMsg.Text = "Item Returned Successfully";
    ////GST Changes
    //                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/PharmacyReturnReceipt.aspx?LedTnxNo=" + ledTxnID + "&Duplicate=0&OutID=" + lblCustomerId.Text + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&ReceiptNo=" + receiptNo + "');", true);
    //                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/GSTPharmacyReturnReceipt.aspx?LedTnxNo=" + ledTxnID + "&Duplicate=0&OutID=" + lblCustomerId.Text + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&ReceiptNo=" + receiptNo + "');", true);

    //                return SalesNo;


    //            }
    //            catch (Exception ex)
    //            {
    //                lblMsg.Text = ex.Message;
    //                tranx.Rollback();
    //                tranx.Dispose();
    //                con.Close();
    //                con.Dispose();
    //                ClassLog cl = new ClassLog();
    //                cl.errLog(ex);
    //                ViewState["dtPaymentDetail"] = null;
    //                return 0;
    //            }
    //        }
    //        else
    //            return 0;
    //    }

    protected void rdoReturn_SelectedIndexChanged(object sender, EventArgs e)
    {

        pnlInfo.Visible = false;
        // pnlOpdReturn.Visible = false;


        // EnableFalse();
        lblMsg.Text = "";
        txtReceiptNo.Text = "";
        txtBillNo.Text = "";
        grdItem.DataSource = null;
        grdItem.DataBind();
    }
    protected void btnGen_Click(object sender, EventArgs e)
    {
        btnSearch_Click(this, new EventArgs());
    }

    [WebMethod(EnableSession = true)]
    public static string Save(string patientType, string ledgerno, string receiptNo, string customerID, object PMH, object LT, Object LTD, object PaymentDetail, int IsCredit, decimal PaidAmount, decimal TotalBillNetAmt)
    {

        GetEncounterNo Encounter = new GetEncounterNo();
        int EncounterNo = 0;


        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        if (patientType.Trim() == "EMG")
        {
            string transID = Util.GetString(StockReports.ExecuteScalar("SELECT lt.TransactionID FROM f_LedgerTransaction lt WHERE lt.LedgertransactionNo='" + ledgerno + "'"));
            if (AllLoadData_IPD.CheckBillGenerate(transID, "ENG") > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient Final Bill Already Generated.", message = "Patient Final Bill Already Generated." });
            }
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranx, CommandType.Text, "select Get_SalesNo('17','" + AllGlobalFunction.MedicalStoreID + "','" + HttpContext.Current.Session["CentreID"].ToString() + "') "));



            string tID = "", ledTxnID = "";
            decimal discAmt = 0, discPer = 0;

            decimal totalGrossAmt = 0;
            totalGrossAmt = Util.GetDecimal(dataLT[0].GrossAmount);



            //if (dataLT[0].DiscountOnTotal >0)
            //{
            //    discAmt = (Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtDisPercent")).Text.Trim()) * totalGrossAmt) / 100;
            //    discPer = Util.GetDecimal(((TextBox)PaymentControl.FindControl("txtDisPercent")).Text.Trim());
            //}
            //else
            //{
            discAmt = Util.GetDecimal(dataLT[0].DiscountOnTotal);
            discPer = (discAmt * 100) / totalGrossAmt;
            //}

            decimal netAmount = Util.GetDecimal(dataLT[0].NetAmount);
            decimal amountPaid = Util.GetDecimal(dataLT[0].Adjustment);
            decimal roundOff = Util.GetDecimal(dataLT[0].RoundOff);
            string discountReason = Util.GetString(dataLT[0].DiscountReason);
            string discountApproveBy = Util.GetString(dataLT[0].DiscountApproveBy);

            string ledgerNumber = "";

            if (patientType == "OPD")
            {
                ledgerNumber = "CASH001";
            }
            else
            {
                ledgerNumber = "CASH002";
            }

            if (IsCredit == 1)
            {
                if (netAmount != TotalBillNetAmt)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please select all item to return this bill.", message = "Patient Final Bill Already Generated." });

                }
                amountPaid = netAmount - PaidAmount;
            }

            string creditBillNO = Util.GetString(MySqlHelper.ExecuteScalar(tranx, CommandType.Text, "select get_billno_store_return('" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')"));

            if (patientType.Trim() != "EMG")
            {
                Patient_Medical_History objPmh = new Patient_Medical_History(tranx);
                if (patientType == "OPD")
                    objPmh.PatientID = dataPMH[0].PatientID;
                else
                    objPmh.PatientID = "CASH002";
                objPmh.DoctorID = dataPMH[0].DoctorID;
                objPmh.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objPmh.Time = Util.GetDateTime(DateTime.Now);
                objPmh.DateOfVisit = Util.GetDateTime(DateTime.Now);
                objPmh.Type = "OPD";
                objPmh.PanelID = Util.GetInt(dataPMH[0].PanelID);
                objPmh.ParentID = Util.GetInt(dataPMH[0].PanelID);
                objPmh.ReferedBy = "";
                objPmh.patient_type = "1";
                objPmh.Source = "OPD-Return";
                objPmh.EntryDate = Util.GetDateTime(DateTime.Now);
                objPmh.HashCode = dataPMH[0].HashCode;
                objPmh.UserID = HttpContext.Current.Session["ID"].ToString();
                objPmh.ScheduleChargeID = Util.GetInt(StockReports.GetCurrentRateScheduleID(Util.GetInt(dataPMH[0].PanelID)));
                objPmh.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objPmh.BillNo = creditBillNO;
                objPmh.BillDate = DateTime.Now;
                objPmh.BillGeneratedBy = HttpContext.Current.Session["ID"].ToString();
                objPmh.NetBillAmount = -netAmount;
                objPmh.PatientPaybleAmt = -netAmount;
                objPmh.NetBillAmount = Util.GetDecimal(-netAmount);
                objPmh.TotalBilledAmt = Util.GetDecimal(-totalGrossAmt);
                objPmh.ItemDiscount = -discAmt;

                tID = objPmh.Insert();
                if (tID == string.Empty)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Medical History" });

                }

                EncounterNo = Encounter.FindEncounterNo(dataPMH[0].PatientID);

                if (EncounterNo == 0)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error While Genrating Encounter No." });

                }

                //Insert into f_LedgerTransaction Single row effect
                Ledger_Transaction objLedTran = new Ledger_Transaction(tranx);
                objLedTran.LedgerNoCr = ledgerNumber;
                objLedTran.LedgerNoDr = "STO00001";
                objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objLedTran.TransactionID = tID;
                objLedTran.TypeOfTnx = "Pharmacy-Return";
                objLedTran.PanelID = Util.GetInt(dataPMH[0].PanelID);
                if (patientType == "OPD")
                    objLedTran.PatientID = dataPMH[0].PatientID;
                else
                    objLedTran.PatientID = "CASH002";
                objLedTran.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
                objLedTran.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
                objLedTran.NetAmount = -netAmount;
                objLedTran.GrossAmount = -totalGrossAmt;
                objLedTran.DiscountOnTotal = -discAmt;
                objLedTran.DiscountReason = discountReason;
                objLedTran.DiscountApproveBy = discountApproveBy;
                if (dataPaymentDetail[0].PaymentMode.ToString().Trim() != "Credit")
                    objLedTran.Adjustment = -amountPaid;
                else
                    objLedTran.Adjustment = 0;
                objLedTran.TransactionType_ID = 17;
                objLedTran.IndentNo = "";
                objLedTran.IsPaid = 1;
                objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                //decimal Round = AmountPaid - netAmount;
                if (Util.GetDecimal(dataLT[0].RoundOff) > 0)
                    objLedTran.RoundOff = -Util.GetDecimal(dataLT[0].RoundOff);
                else
                    objLedTran.RoundOff = Math.Abs(Util.GetDecimal(dataLT[0].RoundOff));
                //  objLedTran.RoundOff = Round;
                objLedTran.PaymentModeID = Util.GetInt(dataPaymentDetail[0].PaymentModeID);
                objLedTran.IsCancel = Util.GetInt(dataLT[0].IsCancel);
                objLedTran.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                objLedTran.UserID = HttpContext.Current.Session["ID"].ToString();
                objLedTran.UniqueHash = dataLT[0].UniqueHash;
                objLedTran.Remarks = dataLT[0].Remarks;

                objLedTran.GovTaxAmount = Util.GetDecimal(dataLT[0].GovTaxAmount);
                objLedTran.GovTaxPer = Util.GetDecimal(dataLT[0].GovTaxPer);
                objLedTran.Refund_Against_BillNo = dataLT[0].Refund_Against_BillNo;
                if (dataLT[0].IPNo != "")
                    objLedTran.IPNo = dataLT[0].IPNo;
                else
                    objLedTran.IPNo = "";
                objLedTran.PatientType = dataLT[0].PatientType;
                objLedTran.IpAddress = All_LoadData.IpAddress();
                if (creditBillNO == string.Empty)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error While Creating Bill No." });

                }

                objLedTran.BillNo = creditBillNO;
                objLedTran.BillDate = DateTime.Now;
                objLedTran.EncounterNo = EncounterNo;
                ledTxnID = objLedTran.Insert();

                if (ledTxnID == string.Empty)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledger Transaction" });
                }
            }
            else
            {

                tID = Util.GetString(StockReports.ExecuteScalar("SELECT lt.TransactionID FROM f_LedgerTransaction lt WHERE lt.LedgertransactionNo='" + ledgerno + "'"));
                ledTxnID = ledgerno; //Util.GetString(StockReports.ExecuteScalar("SELECT L.LedgertransactionNo FROM f_LedgerTransaction L WHERE L.TransactionID='" + tID + "' LIMIT 1"));


            }
            decimal NetAmt = 0;
            foreach (var item in dataLTD)
            {
                decimal MRP = Util.GetDecimal(item.Rate);
                decimal SaleTaxPer = Util.GetDecimal(item.TaxPercent);
                decimal SaleTaxAmtPerUnit = Math.Round(((((MRP * 100) / (100 + SaleTaxPer)) * SaleTaxPer) / 100), 6);

                decimal TaxablePurVATAmt = Util.GetDecimal(item.unitPrice) * Util.GetDecimal(item.Quantity) * (100 / (100 + Util.GetDecimal(item.PurTaxPer)));
                decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(item.PurTaxPer) / 100;

                //---------------- Insert into Ledger Trans Details Table Multiple Row Effect-----------
                LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tranx);
                objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                objLTDetail.LedgerTransactionNo = ledTxnID;
                objLTDetail.ItemID = Util.GetString(item.ItemID);
                objLTDetail.StockID = Util.GetString(item.StockID);
                objLTDetail.SubCategoryID = Util.GetString(item.SubCategoryID);
                objLTDetail.TransactionID = tID;
                objLTDetail.Rate = Util.GetDecimal(item.Rate);
                objLTDetail.Quantity = -Util.GetDecimal(item.Quantity);
                objLTDetail.DiscountPercentage = item.DiscountPercentage;
                objLTDetail.IsVerified = 1;
                objLTDetail.ItemName = Util.GetString(item.ItemName) + " (Batch : " + Util.GetString(item.BatchNumber) + ")";
                objLTDetail.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                 decimal discAmtPerItem = ((objLTDetail.Rate * Util.GetDecimal(item.Quantity)) * objLTDetail.DiscountPercentage) / 100;
                objLTDetail.Amount = -Util.GetDecimal((objLTDetail.Rate * Util.GetDecimal(item.Quantity)) - discAmtPerItem);
                objLTDetail.DiscAmt = -discAmtPerItem;
                objLTDetail.DiscountReason = discountReason;
                objLTDetail.NetItemAmt = -Util.GetDecimal((objLTDetail.Rate * Util.GetDecimal(item.Quantity)) - discAmtPerItem);
                objLTDetail.TotalDiscAmt = -discAmtPerItem;
                objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                objLTDetail.TransactionID = tID;
                objLTDetail.TnxTypeID = Util.GetInt("17");

                if (patientType == "EMG")
                    objLTDetail.TnxTypeID = 5;



                objLTDetail.IsReusable = Util.GetString(item.IsReusable);
                objLTDetail.ToBeBilled = Util.GetInt(item.ToBeBilled);
                objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                objLTDetail.IpAddress = All_LoadData.IpAddress();
                objLTDetail.Type = "O";
                objLTDetail.medExpiryDate = Util.GetDateTime(item.medExpiryDate);
                objLTDetail.IsExpirable = Util.GetInt(item.IsExpirable);
                objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(item.SubCategoryID), con));
                objLTDetail.TransactionType_ID = 17;



                if (patientType == "EMG")
                    objLTDetail.TransactionType_ID = 5;


                objLTDetail.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                objLTDetail.VarifiedUserID = Convert.ToString(HttpContext.Current.Session["ID"]);
                objLTDetail.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                objLTDetail.StoreLedgerNo = "STO00001";
                objLTDetail.IsMedService = 1;
                objLTDetail.typeOfTnx = "Pharmacy-Return";
                objLTDetail.roundOff = Util.GetDecimal(dataLT[0].RoundOff / dataLTD.Count);

                objLTDetail.PurTaxPer = Util.GetDecimal(item.PurTaxPer);
                if (Util.GetDecimal(item.PurTaxPer) > 0)
                    objLTDetail.PurTaxAmt = vatPuramt;
                else
                    objLTDetail.PurTaxAmt = 0;
                objLTDetail.BatchNumber = Util.GetString(item.BatchNumber);
                objLTDetail.unitPrice = Util.GetDecimal(item.unitPrice);
                //GST Changes
                decimal igstPercent = Util.GetDecimal(item.IGSTPercent);
                decimal csgtPercent = Util.GetDecimal(item.CGSTPercent);
                decimal sgstPercent = Util.GetDecimal(item.SGSTPercent);

                decimal nonTaxableRate = (objLTDetail.Rate * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                decimal discount = objLTDetail.Rate * objLTDetail.DiscountPercentage / 100;
                decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

                decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);
                objLTDetail.HSNCode = Util.GetString(item.HSNCode);
                objLTDetail.IGSTPercent = igstPercent;
                objLTDetail.IGSTAmt = Util.GetDecimal(IGSTTaxAmount);
                objLTDetail.CGSTPercent = csgtPercent;
                objLTDetail.CGSTAmt = Util.GetDecimal(CGSTTaxAmount);
                objLTDetail.SGSTPercent = sgstPercent;
                objLTDetail.SGSTAmt = Util.GetDecimal(SGSTTaxAmount);
                objLTDetail.IsPackage = item.IsPackage;
                objLTDetail.DoctorID = dataPMH[0].DoctorID;



                //
                int iD = objLTDetail.Insert();

                NetAmt = NetAmt + Util.GetDecimal(objLTDetail.Amount);
                if (iD == 0)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledger Transaction Details" });

                }



                if (patientType=="EMG")
                {
                    string IsIntegrate = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(ledTxnID), string.Empty, "R", Util.GetString(iD), tranx));
                    if (IsIntegrate == "0")
                    {
                        tranx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details EMG" });
                    }
                }


                //---------------- Insert into Sales Details Table-----------

                Sales_Details objSales = new Sales_Details(tranx);
                objSales.LedgerNumber = ledgerNumber;
                objSales.DepartmentID = "STO00001";
                objSales.StockID = Util.GetString(item.StockID);
                objSales.SoldUnits = Util.GetDecimal(item.Quantity);
                objSales.PerUnitBuyPrice = Util.GetDecimal(item.unitPrice);
                objSales.PerUnitSellingPrice = Util.GetDecimal(item.Rate);
                objSales.Date = System.DateTime.Now;
                objSales.Time = System.DateTime.Now;
                objSales.IsReturn = 1;
                objSales.TrasactionTypeID = 17;


                if (patientType == "EMG")
                    objSales.TrasactionTypeID = 5;

                objSales.ItemID = Util.GetString(item.ItemID);
                objSales.IsService = "NO";
                objSales.IndentNo = "";
                objSales.Naration = dataLT[0].Remarks;
                objSales.SalesNo = SalesNo;
                objSales.UserID = HttpContext.Current.Session["ID"].ToString();
                objSales.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                objSales.PatientID = dataPMH[0].PatientID;
                objSales.LedgerTransactionNo = ledTxnID;
                objSales.AgainstLedgerTnxNo = Util.GetString(item.LedgerTransactionNo);
                objSales.BillNoforGP = creditBillNO;
                objSales.IsReusable = Util.GetString(item.IsReusable);
                objSales.ToBeBilled = Util.GetInt(item.ToBeBilled);
                objSales.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                // objSales.Type_ID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select IFNULL(Type_ID,'')Type_ID from f_itemmaster where itemID='" + Util.GetString(dtItem.Rows[i]["ItemID"]) + "'"));
                objSales.Type_ID = Util.GetString(item.Type_ID);
                objSales.Refund_Against_BillNo = item.Refund_Against_BillNo;
                objSales.IpAddress = All_LoadData.IpAddress();
                objSales.medExpiryDate = Util.GetDateTime(item.medExpiryDate);
                objSales.LedgerTnxNo = iD;
                objSales.BatchNo = Util.GetString(item.BatchNumber);
                objSales.TransactionID = tID;


                objSales.DiscAmt = discAmtPerItem;
                objSales.DisPercent = item.DiscountPercentage;
                // Add new 29-06-2017 - For GST                
                objSales.IGSTPercent = igstPercent;
                objSales.IGSTAmt = Util.GetDecimal(IGSTTaxAmount);
                objSales.CGSTPercent = csgtPercent;
                objSales.CGSTAmt = Util.GetDecimal(CGSTTaxAmount);
                objSales.SGSTPercent = sgstPercent;
                objSales.SGSTAmt = Util.GetDecimal(SGSTTaxAmount);
                objSales.HSNCode = Util.GetString(item.HSNCode);
                objSales.GSTType = Util.GetString(item.GSTType);


                objSales.PurTaxPer = item.PurTaxPer;
                objSales.PurTaxAmt = vatPuramt;

                objSales.TaxPercent = SaleTaxPer;
                objSales.TaxAmt = SaleTaxAmtPerUnit * item.Quantity;
                //           
                string salesID = objSales.Insert();
                if (salesID == "")
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Sales" });

                }

                //---- Update Release Count in Stock Table---------------------

                string strStock = "";
                if (item.IsReusable == "0" || item.IsReusable == "NR")
                {


                    float soldstock = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(sd.SoldUnits) FROM  f_salesdetails sd WHERE sd.LedgerTransactionNo='" + ledgerno.Trim() + "' AND  StockID='" + Util.GetString(item.StockID) + "' AND PatientID='" + dataPMH[0].PatientID.Trim() + "'"));
                    float returnstock = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(sd.SoldUnits) FROM  f_salesdetails sd WHERE sd.AgainstLedgerTnxNo='" + ledgerno.Trim() + "' AND  StockID='" + Util.GetString(item.StockID) + "' AND PatientID='" + dataPMH[0].PatientID.Trim() + "'"));
                    if (soldstock <= returnstock && soldstock != 0.00 && returnstock != 0.00)
                    {
                        tranx.Rollback();
                        tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        //lblMsg.Text = "Stock already returned please reopen the page";
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In  Sales Details" });

                    }

                    strStock = "update f_stock set ReleasedCount = ReleasedCount -" + objSales.SoldUnits + " where StockID = '" + objSales.StockID + "' and ReleasedCount - " + objSales.SoldUnits + "<=InitialCount";

                    if (MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strStock) == 0)
                    {
                        tranx.Rollback();
                        tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        //  lblMsg.Text = "Stock already returned please reopen the page";
                        //  return 0;
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Stock already returned please reopen the page", message = "Error In Stock" });

                    }
                }
            }



            if (patientType.Trim() != "EMG")
            {
                ////////////////////////////// Insert in Receipt ///////////////////
                if (!string.IsNullOrEmpty(receiptNo))
                {
                    if (dataPaymentDetail[0].PaymentMode.ToString().Trim() != "Credit")
                    {
                        Receipt objReceipt = new Receipt(tranx);
                        objReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        objReceipt.AmountPaid = -amountPaid;
                        objReceipt.AsainstLedgerTnxNo = ledTxnID;
                        objReceipt.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
                        objReceipt.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
                        objReceipt.Discount = 0;
                        objReceipt.PanelID = Util.GetInt(dataPMH[0].PanelID);
                        objReceipt.IsCancel = Util.GetInt(dataLT[0].IsCancel);
                        objReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                        if (patientType == "OPD")
                            objReceipt.Depositor = dataPMH[0].PatientID;
                        else if (patientType == "EMG")
                            objReceipt.Depositor = dataPMH[0].PatientID;
                        else
                            objReceipt.Depositor = "CASH002";
                        objReceipt.TransactionID = tID;
                        objReceipt.LedgerNoDr = "STO00001";
                        if (patientType == "OPD")
                            objReceipt.LedgerNoCr = "CASH001";
                        else
                            objReceipt.LedgerNoCr = "CASH002";
                        objReceipt.RoundOff = roundOff;
                        objReceipt.deptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                        objReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objReceipt.IpAddress = All_LoadData.IpAddress();
                        objReceipt.PaidBy = "PAT";
                        receiptNo = objReceipt.Insert();

                        if (receiptNo == string.Empty)
                        {
                            tranx.Rollback();
                            tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt" });

                        }

                        Receipt_PaymentDetail objReceiptPayment = new Receipt_PaymentDetail(tranx);
                        foreach (var item in dataPaymentDetail)
                        {
                            objReceiptPayment.PaymentModeID = Util.GetInt(item.PaymentModeID);
                            objReceiptPayment.PaymentMode = Util.GetString(item.PaymentMode);
                            objReceiptPayment.Amount = -Util.GetDecimal(item.Amount);
                            objReceiptPayment.ReceiptNo = receiptNo;
                            objReceiptPayment.PaymentRemarks = Util.GetString(item.PaymentRemarks);
                            objReceiptPayment.RefDate = Util.GetDateTime(item.RefDate);
                            objReceiptPayment.RefNo = Util.GetString(item.RefNo);
                            objReceiptPayment.BankName = Util.GetString(item.BankName);
                            objReceiptPayment.C_Factor = Util.GetDecimal(item.C_Factor);
                            objReceiptPayment.S_Amount = -Util.GetDecimal(item.S_Amount);
                            objReceiptPayment.S_CountryID = Util.GetInt(item.S_CountryID);
                            objReceiptPayment.S_Currency = Util.GetString(item.S_Currency);
                            objReceiptPayment.S_Notation = Util.GetString(item.S_Notation);
                            objReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            objReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                            objReceiptPayment.currencyRoundOff = Util.GetDecimal(item.currencyRoundOff);
                            objReceiptPayment.swipeMachine = Util.GetString(item.swipeMachine);
                            string paymentID = objReceiptPayment.Insert().ToString();

                            if (paymentID == string.Empty)
                            {
                                tranx.Rollback();
                                tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt Payment Details" });

                            }
                        }

                        if (string.IsNullOrEmpty(receiptNo))
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error While Receipt Entry" });
                    }
                }

            }

            


            if (patientType == "EMG")
            {


                int IsUpdate = updateEmergencyBillAmounts(tranx, ledgerno.ToString());
                if (IsUpdate != 1)
                {
                    tranx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Emergency LT Update" });
                }

            }


            if (Resources.Resource.AllowFiananceIntegration == "1")
            {


                var transactionTypeID = 17;

                if (patientType == "EMG")
                    transactionTypeID = 5;


                string IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(ledTxnID), 0, transactionTypeID, SalesNo, tranx));
                if (IsIntegrated == "0")
                {
                    tranx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Finance Integartion" });
                }
                IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction(Util.GetInt(ledTxnID), receiptNo, "R", tranx));
                if (IsIntegrated == "0")
                {
                    tranx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                }
            }

            if (IsCredit == 1 && patientType != "EMG")
            {
                StringBuilder sb = new StringBuilder();

                sb.Append("SELECT * FROM panel_amountallocation pa ");
                sb.Append("WHERE pa.`TransactionID`= ");
                sb.Append("(SELECT lt.`TransactionID`   ");
                sb.Append("FROM f_ledgertransaction lt WHERE lt.`LedgertransactionNo`='" + ledgerno + "') AND pa.`EntryType`='CR' ");

                DataTable dt = StockReports.GetDataTable(sb.ToString());

                if (dt.Rows.Count>0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        StringBuilder sqlCMD = new StringBuilder("INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (@panelID,@transactionID,@ApprovalAmount,@EntryBy,'DR') ");

                        int response = excuteCMD.DML(tranx, sqlCMD.ToString(), CommandType.Text, new
                        {
                            transactionID = dt.Rows[i]["TransactionID"].ToString(),
                            ApprovalAmount = -(Util.GetDecimal(dt.Rows[i]["Amount"].ToString())),
                            EntryBy = HttpContext.Current.Session["ID"].ToString(),
                            panelID = dt.Rows[i]["PanelID"].ToString(),
                        });
                    }
                }



                StringBuilder sqlcm = new StringBuilder("INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (@panelID,@transactionID,@ApprovalAmount,@EntryBy,'DR') ");

                int res = excuteCMD.DML(tranx, sqlcm.ToString(), CommandType.Text, new
                {
                    transactionID = tID,
                    ApprovalAmount =-(netAmount-PaidAmount) ,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    panelID = Util.GetInt(dataPMH[0].PanelID),
                });




                StringBuilder sqlledgUpdate = new StringBuilder("UPDATE f_ledgertransaction lt SET lt.AsainstLedgerTnxNo=@AsainstLedgerTnxNo  WHERE lt.`LedgertransactionNo`=@LedgertransactionNo ");

                int resUpdate = excuteCMD.DML(tranx, sqlledgUpdate.ToString(), CommandType.Text, new
                {
                    AsainstLedgerTnxNo = ledTxnID,
                    LedgertransactionNo=ledgerno,
                });

              


            }




            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();

            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/PharmacyReturnReceipt.aspx?LedTnxNo=" + ledTxnID + "&Duplicate=0&OutID=" + lblCustomerId.Text + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&ReceiptNo=" + receiptNo + "');", true);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/GSTPharmacyReturnReceipt.aspx?LedTnxNo=" + ledTxnID + "&Duplicate=0&OutID=" + lblCustomerId.Text + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&ReceiptNo=" + receiptNo + "');", true);

            // return SalesNo;
            var responseURL = "";
            if (Resources.Resource.ReceiptPrintFormat == "0")
                responseURL = "../Common/GSTPharmacyReturnReceipt.aspx?LedTnxNo=" + ledTxnID + "&Duplicate=0&OutID=" + customerID + "&DeptLedgerNo=" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "&ReceiptNo=" + receiptNo + "'";
            else
                responseURL = "../Common/CommonReceipt_pdf.aspx?LedgerTransactionNo=" + ledTxnID + "&Duplicate=0&Type=PHY&IsBill=0&ReceiptNo=" + receiptNo + "'";

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Item Returned Successfully", responseURL = responseURL });


        }
        catch (Exception ex)
        {

            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });

        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    public static int updateEmergencyBillAmounts(MySqlTransaction tnx, string LedgerTnxNo)
    {
        try
        {
            string UpdateQuery = "Call updateEmergencyBillAmounts(" + LedgerTnxNo + ")";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateQuery);
            return 1;


        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

}