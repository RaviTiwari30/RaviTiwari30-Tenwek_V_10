using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Consignment_ConsignmentSaleReturn : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            pnlPatient.Visible = false;
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            ViewState["ID"] = Session["ID"].ToString();
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }

    private void Search()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pmh.`TransNo`, pmh.TransactionID,CONCAT(pm.Title,' ',pm.Pname)PNAME,CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.City)Address,pmh.Patient_Type  ");
        sb.Append(" FROM `patient_medical_history` pmh INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID   ");
        sb.Append(" INNER JOIN (  ");
        sb.Append(" 	SELECT DISTINCT(LedgerNumber)LNo FROM f_salesdetails sd INNER JOIN f_Stock st ON st.stockid=sd.stockid AND st.`ConsignmentID`<>0  WHERE TrasactionTypeID IN ('3','5') AND sd.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' AND sd.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "  ");//" + ViewState["DeptLedgerNo"].ToString() + "
        sb.Append(" )t1 ON t1.lno = pmh.PatientLedgerNo WHERE pmh.`TYPE`='IPD' AND IFNULL(pmh.`BillNo`,'')='' ");



        if (txtCRNo.Text.Trim() != string.Empty)
            sb.Append(" and pmh.TransNo = " + txtCRNo.Text.Trim() + " ");

        if (txtPName.Text.Trim() != string.Empty)
            sb.Append("  and PM.PNAME like '" + txtPName.Text.Trim() + "%'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            ViewState["dt"] = dt as DataTable;
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
        else
        {
            GridView1.DataSource = null;
            GridView1.DataBind();
            lblMsg.Text = "No Record Found";
        }
    }

    private void BindPatientDetails(string TransactionID)
    {
        try
        {
            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientIPDInformation("", TransactionID);
            if (dt != null && dt.Rows.Count > 0)
            {
                lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
                lblPatientName.Text = dt.Rows[0]["PName"].ToString();
                lblTransactionNo.Text = dt.Rows[0]["TransactionID"].ToString();
                lblRoomNo.Text = dt.Rows[0]["RoomNo"].ToString();
                lblPanelComp.Text = dt.Rows[0]["Company_Name"].ToString();
                lblCaseTypeID.Text = dt.Rows[0]["IPDCaseTypeID"].ToString();
                lblReferenceCode.Text = dt.Rows[0]["ReferenceCode"].ToString();
                lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
                lblPatient_Type.Text = dt.Rows[0]["PatientType"].ToString();
                lblTID.Text = StockReports.getTransNobyTransactionID(dt.Rows[0]["TransactionID"].ToString());
                lblRoomID.Text = dt.Rows[0]["RoomID"].ToString();
            }
            DataTable dt1 = AQ.GetPatientIPDInformation(TransactionID);
            if (dt1 != null && dt1.Rows.Count > 0)
            {
                lblDoctorName.Text = dt1.Rows[0]["DoctorName"].ToString();
                lblAdmissionDate.Text = dt1.Rows[0]["DateOfAdmit"].ToString();
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Patient Record and Room Not Available";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void BindItem(string CRNO)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t3.ItemId,IM.TypeName,IM.Type_ID,t3.StockId FROM (SELECT t1.itemid,(t1.SoldQty - IF(t2.RetQty IS NULL,0,t2.RetQty ) )  ");
        sb.Append(" AS inHandUnits,t1.Stockid FROM (SELECT ltd.ItemID,ltd.StockID,SUM(ltd.Quantity)SoldQty  ");
        sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_salesdetails sd ON sd.LedgerTnxNo=ltd.ID  INNER JOIN f_Stock st ON st.stockid=sd.stockid AND st.`ConsignmentID`<>0 INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionNo = ltd.ledgertransactionno ");
        sb.Append(" WHERE ltd.TransactionID='" + CRNO + "' AND sd.TrasactionTypeID IN ('3') AND sd.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and lt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " GROUP BY ltd.itemid  ");//" + ViewState["DeptLedgerNo"].ToString() + "
        sb.Append(" )t1 LEFT JOIN (SELECT ltd.ItemID,ltd.StockID,SUM(ltd.Quantity)RetQty ");
        sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_salesdetails sd ON sd.LedgerTnxNo=ltd.ID  INNER JOIN f_Stock st ON st.stockid=sd.stockid AND st.`ConsignmentID`<>0  INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionNo = ltd.ledgertransactionno ");
        sb.Append(" WHERE ltd.TransactionID='" + CRNO + "' AND sd.TrasactionTypeID IN ('5') AND sd.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and lt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " GROUP BY ltd.itemid ");//" + ViewState["DeptLedgerNo"].ToString() + "
        sb.Append(" )t2 ON t1.ItemID=t2.ItemID)t3 INNER JOIN f_itemmaster IM ON t3.itemid=IM.ItemID  ");
        sb.Append(" WHERE t3.inHandUnits>0 ORDER BY IM.TypeName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlItem.DataSource = dt;
            ddlItem.DataTextField = "TypeName";
            ddlItem.DataValueField = "ItemID";
            ddlItem.DataBind();
        }
        else
        {
            ddlItem.Items.Clear();
            lblMsg.Text = "No Item Found";
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string CRNO = (GridView1.SelectedRow.FindControl("lblTID") as Label).Text;
        ViewState["TID"] = CRNO;
        pnlPatient.Visible = true;
        BindPatientDetails(CRNO);
        BindItem(CRNO);
    }
    protected void btnSearchItem_Click(object sender, EventArgs e)
    {
        ReturnItem();
    }

    private void ReturnItem()
    {
        AllQuery AQ = new AllQuery();
        string PatientLedgerNo = AQ.GetPatientLedNoByTranID(lblTransactionNo.Text.Trim());

        StringBuilder sb = new StringBuilder();

        sb.Append(" select 0 ID,0 RejectQty, t2.*, 'false' as IsSelected,'' as RetQty from ");
        sb.Append(" ( Select issue.IndentNo,issue.ToBeBilled,issue.IsVerified,issue.ItemName,issue.Type_ID,issue.ServiceItemID,issue.StockID, issue.UnitPrice, ");
        sb.Append(" issue.TrasactionTypeID,issue.DepartmentID,issue.ItemID, issue.BatchNumber,issue.SubCategoryID, ");
        sb.Append(" Date_Format(issue.MedExpiryDate,'%d-%b-%y') as MedExpiryDate,issue.IsExpirable, issue.MRP,issue.Date, ");
        sb.Append(" issue.IssueUnits,issue.LedgerName as DeptName,issue.LedgerNumber,  ");
        sb.Append(" if(ptnRtn.RtnQty is null,0,ptnRtn.RtnQty )RtnQty, (issue.IssueUnits - if(ptnRtn.RtnQty is null,0,ptnRtn.RtnQty ) - IFNULL(issue.NurUsed,0)) AS inHandUnits,issue.TaxPercent  ");
        //GST Changes
        sb.Append(" ,issue.HSNCode,issue.IGSTPercent,issue.IGSTAmt,issue.SGSTPercent,issue.SGSTAmt,issue.CGSTPercent,issue.CGSTAmt,issue.GSTType,issue.PurTaxPer,issue.IsPackage,issue.PackageID,issue.VenLedgerNo,issue.SaleTaxPer,issue.LedgerTransactionNo,issue.`ChalanNo`,issue.`InvoiceNo`,issue.`InvoiceDate`,issue.`CurrencyFactor`,issue.`ConversionFactor`,issue.`DiscPer`,issue.`DiscAmt` ,issue.`MajorUnit`,issue.`IsFree`,issue.`DeptLedgerNo`,issue.`SpecialDiscPer`,issue.`isDeal`,issue.`OtherCharges`,issue.`MarkUpPercent`,issue.`CurrencyCountryID`,issue.`Currency`,issue.Rate,issue.ConsignmentID  ");
        //
        sb.Append(" from (Select S.ItemName,ltd.Type_ID,ltd.ServiceItemID,ltd.ToBeBilled,ltd.IsVerified, ltd.IsPackage,ltd.PackageID,S.UnitPrice,S.SubCategoryID,S.BatchNumber, S.MedExpiryDate,ltd.isExpirable,SD.StockID,SD.DepartmentID,SD.IndentNo,Sd.ItemID, SD.TrasactionTypeID,SD.PerUnitSellingPrice AS MRP,SD.LedgerNumber,Date_Format(SD.Date,'%d-%b-%y')Date,    sum(SD.SoldUnits) IssueUnits,LM.LedgerName, (SELECT SUM(Qty) FROM cpoe_medication_record WHERE indentno=sd.IndentNo AND itemID=ltd.ItemID)NurUsed,SD.TaxPercent  ");
        //GST Changes
        sb.Append(" ,IFNULL(SD.HSNCode,'')HSNCode,SD.IGSTPercent,SD.IGSTAmt,SD.SGSTPercent,SD.SGSTAmt,SD.CGSTPercent,SD.CGSTAmt,IFNULL(SD.GSTType,'')GSTType,sd.PurTaxPer,S.`VenLedgerNo`,S.`SaleTaxPer`,ltd.`LedgerTransactionNo`,lt.`ChalanNo`,lt.`InvoiceNo`,lt.`DATE` AS InvoiceDate,S.`CurrencyFactor`,S.`ConversionFactor`,S.`DiscPer`,S.`DiscAmt` ,S.`MajorUnit`,S.`IsFree`,S.`DeptLedgerNo`,S.`SpecialDiscPer`,S.`isDeal`,S.`OtherCharges`,S.`MarkUpPercent`,S.`CurrencyCountryID`,S.`Currency`,S.`Rate` ,S.`ConsignmentID`   ");
        //
        sb.Append(" from f_stock S inner join f_salesdetails SD on SD.StockID = S.StockID   ");
        sb.Append(" inner join f_ledgermaster LM on SD.DeptLedgerNo = LM.LedgerNumber INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo AND ltd.StockID=sd.StockID INNER JOIN f_ledgertransaction lt ON lt.`LedgertransactionNo`=ltd.`LedgerTransactionNo`    ");
        sb.Append(" where ltd.TransactionID = '" + lblTransactionNo.Text.Trim() + "' and Sd.TrasactionTypeID in('3','4') and sd.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "  ");
        sb.Append(" and SD.ItemID='" + ddlItem.SelectedValue + "'  and S.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'  group by SD.StockID,Sd.TrasactionTypeID ) issue   ");//" + ViewState["DeptLedgerNo"].ToString() + "
        sb.Append(" left outer join (Select Sd.StockID,sum(Sd.SoldUnits) as RtnQty ,Sd.ItemID from f_salesdetails SD  ");
        sb.Append(" inner join f_stock S on SD.StockID = S.StockID INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo AND ltd.StockID=sd.StockID ");
        sb.Append(" where ltd.TransactionID = '" + lblTransactionNo.Text.Trim() + "' and  Sd.TrasactionTypeID in ('5','6')  ");
        sb.Append(" and SD.ItemID='" + ddlItem.SelectedValue + "'  and S.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and sd.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " group by Sd.StockID,Sd.TrasactionTypeID ) ptnRtn  ");//" + ViewState["DeptLedgerNo"].ToString() + "
        sb.Append(" on issue.StockID = ptnRtn.StockID )t2  where inHandUnits > 0 ");

        DataTable dtItemDetails = StockReports.GetDataTable(sb.ToString());
        if (dtItemDetails != null && dtItemDetails.Rows.Count > 0)
        {
            grdItems.DataSource = dtItemDetails;
            grdItems.DataBind();
            btnAddItem.Visible = true;
            ViewState.Add("dtItemDetails", dtItemDetails);
        }
        else
        {
            grdItems.DataSource = null;
            grdItems.DataBind();
            lblMsg.Text = "No Record Found.Please check with ward, may be quantity already being used against patient.";
            btnAddItem.Visible = false;
        }
    }

    private bool ValidateItem()
    {
        if (grdItems != null && grdItems.Rows.Count > 0)
        {
            bool status = true;

            foreach (GridViewRow row in grdItems.Rows)
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked)
                {
                    status = false;

                    float TransferQty = 0, AvailQty = 0;

                    var totalReturnQuantity = Util.GetInt(((TextBox)row.FindControl("txtRetQty")).Text.Trim());
                    var totalRejectQuantity = Util.GetInt(((Label)row.FindControl("lblRejectQuantity")).Text.Trim());

                    //if (((TextBox)row.FindControl("txtRetQty")).Text.Trim() != string.Empty && Util.GetDecimal(((TextBox)row.FindControl("txtRetQty")).Text.Trim()) > 0)
                    if ((totalReturnQuantity + totalRejectQuantity) > 0)
                        TransferQty = Util.GetFloat(((TextBox)row.FindControl("txtRetQty")).Text);
                    else
                    {
                        lblMsg.Text = "Specify a Valid Quantity";
                        return false;
                    }

                    AvailQty = Util.GetFloat(((Label)row.FindControl("lblInHandQty")).Text);
                    if (TransferQty > AvailQty)
                    {
                        lblMsg.Text = "Requested Quantity is not Available";
                        return false;
                    }
                }
            }
            if (status)
            {
                lblMsg.Text = "Please Select Items";
                return false;
            }

            return true;
        }
        else
        {
            lblMsg.Text = " No Items Found";
            return false;
        }
    }

    private DataTable GetItem()
    {
        DataTable dt = new DataTable();

        dt.Columns.Add("ItemID");
        dt.Columns.Add("ServiceItemID");
        dt.Columns.Add("StockID");
        dt.Columns.Add("SubCategory");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNumber");
        dt.Columns.Add("LedgerNumber");
        dt.Columns.Add("MRP", typeof(float));
        dt.Columns.Add("UnitPrice", typeof(float));
        dt.Columns.Add("RetQty", typeof(float));
        dt.Columns.Add("Amount", typeof(float));
        dt.Columns.Add("Type_ID");
        dt.Columns.Add("ToBeBilled");
        dt.Columns.Add("IsVerified");
        dt.Columns.Add("IsExpirable");
        dt.Columns.Add("MedExpiryDate");
        dt.Columns.Add("TaxPercent");
        dt.Columns.Add("PurTaxPer");
        //GST Changes
        dt.Columns.Add("HSNCode");
        dt.Columns.Add("IGSTPercent");
        dt.Columns.Add("SGSTPercent");
        dt.Columns.Add("CGSTPercent");
        dt.Columns.Add("GSTType");
        dt.Columns.Add("inHandUnits");
        dt.Columns.Add("IsSelected", typeof(Boolean));
        dt.Columns.Add("IssueUnits", typeof(float));
        dt.Columns.Add("Date");
        dt.Columns.Add("DeptName");
        dt.Columns.Add("SubCategoryID");
        dt.Columns.Add("IsPackage");
        dt.Columns.Add("PackageID");
        dt.Columns.Add("ID");
        dt.Columns.Add("RejectQty");
        dt.Columns.Add("VenLedgerNo");//
        dt.Columns.Add("SaleTaxPer");//
        dt.Columns.Add("LedgerTransactionNo");//
        dt.Columns.Add("ChalanNo");//
        dt.Columns.Add("InvoiceNo");//
        dt.Columns.Add("InvoiceDate");//
        dt.Columns.Add("CurrencyFactor");//
        dt.Columns.Add("ConversionFactor");//

        dt.Columns.Add("DiscPer");//
        dt.Columns.Add("DiscAmt");//
        dt.Columns.Add("MajorUnit");//
        dt.Columns.Add("IsFree");//
        dt.Columns.Add("DeptLedgerNo");//
        dt.Columns.Add("SpecialDiscPer");//
        dt.Columns.Add("isDeal");//
        dt.Columns.Add("OtherCharges");//
        dt.Columns.Add("MarkUpPercent");//
        dt.Columns.Add("CurrencyCountryID");//
        dt.Columns.Add("Currency");//
        dt.Columns.Add("Rate");//
        dt.Columns.Add("IGSTAmt");//
        dt.Columns.Add("SGSTAmt");//
        dt.Columns.Add("CGSTAmt");//
        dt.Columns.Add("ConsignmentID");//
        return dt;
    }
    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (ValidateItem())
        {
            DataTable dt = new DataTable();
            if (ViewState["ReturnItem"] != null)
            {
                dt = (DataTable)ViewState["ReturnItem"];
            }
            else
                dt = GetItem();

            foreach (GridViewRow row in grdItems.Rows)
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked)
                {
                    string StockID = ((Label)row.FindControl("lblStockID")).Text;
                    DataRow[] dr1 = dt.Select("StockID='" + StockID + "'");
                    if (dr1.Length > 0)
                    {
                        lblMsg.Text = "Item Already Taken";
                       // txtBar.Focus();
                        return;
                    }
                    else
                    {
                        DataRow dr = dt.NewRow();
                        dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                        dr["ServiceItemID"] = ((Label)row.FindControl("lblServiceItemID")).Text;
                        dr["StockID"] = ((Label)row.FindControl("lblStockID")).Text;
                        dr["SubCategoryID"] = ((Label)row.FindControl("lblSubCategory")).Text;
                        dr["ItemName"] = ((Label)row.FindControl("lblItem")).Text;

                        dr["IssueUnits"] = ((Label)row.FindControl("lblIssueUnit")).Text;
                        dr["Date"] = ((Label)row.FindControl("lblDate")).Text;
                        dr["DeptName"] = ((Label)row.FindControl("lblDPTName")).Text;
                        dr["inHandUnits"] = ((Label)row.FindControl("lblInHandQty")).Text;

                        dr["BatchNumber"] = ((Label)row.FindControl("lblBatch")).Text;
                        dr["LedgerNumber"] = ((Label)row.FindControl("lblLedgerNo")).Text;
                        dr["MRP"] = ((Label)row.FindControl("lblMRP")).Text;
                        dr["UnitPrice"] = ((Label)row.FindControl("lblUnitPric")).Text;
                        dr["RetQty"] = ((TextBox)row.FindControl("txtRetQty")).Text;
                        dr["Amount"] = Util.GetFloat(dr["RetQty"]) * Util.GetFloat(dr["MRP"]);
                        dr["Type_ID"] = ((Label)row.FindControl("lblType_ID")).Text;
                        dr["ToBeBilled"] = ((Label)row.FindControl("lblToBeBilled")).Text;
                        dr["IsVerified"] = ((Label)row.FindControl("lblIsVerified")).Text;
                        dr["IsExpirable"] = ((Label)row.FindControl("lblIsExpirable")).Text;
                        dr["MedExpiryDate"] = ((Label)row.FindControl("lblExpiryDate")).Text;
                        dr["TaxPercent"] = ((Label)row.FindControl("lblTaxPercent")).Text;
                        dr["PurTaxPer"] = ((Label)row.FindControl("lblPurTaxPer")).Text;
                        //GST Changes
                        dr["HSNCode"] = ((Label)row.FindControl("lblHSNCode")).Text;
                        dr["IGSTPercent"] = ((Label)row.FindControl("lblIGSTPercent")).Text;
                        dr["SGSTPercent"] = ((Label)row.FindControl("lblSGSTPercent")).Text;
                        dr["CGSTPercent"] = ((Label)row.FindControl("lblCGSTPercent")).Text;
                        dr["GSTType"] = ((Label)row.FindControl("lblGSTType")).Text;


                        dr["IsPackage"] = ((Label)row.FindControl("lblIsPackage")).Text;
                        dr["PackageID"] = ((Label)row.FindControl("lblPackageID")).Text;
                        dr["ID"] = Util.GetInt(((Label)row.FindControl("lblID")).Text);
                        dr["RejectQty"] = Util.GetInt(((Label)row.FindControl("lblRejectQuantity")).Text);
                        dr["VenLedgerNo"] = Util.GetString(((Label)row.FindControl("lblVenLedgerNo")).Text);//
                        dr["SaleTaxPer"] = Util.GetDecimal(((Label)row.FindControl("lblSaleTaxPer")).Text);//
                        dr["LedgerTransactionNo"] = Util.GetInt(((Label)row.FindControl("lblLedgerTransactionNo")).Text);//
                        dr["ChalanNo"] = Util.GetString(((Label)row.FindControl("lblChalanNo")).Text);//
                        dr["InvoiceNo"] = Util.GetDecimal(((Label)row.FindControl("lblInvoiceNo")).Text);//
                        dr["InvoiceDate"] = Util.GetDateTime(((Label)row.FindControl("lblInvoiceDate")).Text);//
                        dr["CurrencyFactor"] = Util.GetDecimal(((Label)row.FindControl("lblCurrencyFactor")).Text);//
                        dr["ConversionFactor"] = Util.GetDecimal(((Label)row.FindControl("lblConversionFactor")).Text);//

                        dr["DiscPer"] = Util.GetDecimal(((Label)row.FindControl("lblDiscPer")).Text);
                        dr["DiscAmt"] = Util.GetDecimal(((Label)row.FindControl("lblDiscAmt")).Text);
                        dr["MajorUnit"] = Util.GetString(((Label)row.FindControl("lblMajorUnit")).Text);//
                        dr["IsFree"] = Util.GetDecimal(((Label)row.FindControl("lblIsFree")).Text);//
                        dr["DeptLedgerNo"] = Util.GetString(((Label)row.FindControl("lblDeptLedgerNo")).Text);//
                        dr["SpecialDiscPer"] = Util.GetDecimal(((Label)row.FindControl("lblSpecialDiscPer")).Text);//
                        dr["isDeal"] = Util.GetString(((Label)row.FindControl("lblisDeal")).Text);//
                        dr["OtherCharges"] = Util.GetDecimal(((Label)row.FindControl("lblOtherCharges")).Text);//
                        dr["MarkUpPercent"] = Util.GetDecimal(((Label)row.FindControl("lblMarkUpPercent")).Text);//
                        dr["CurrencyCountryID"] = Util.GetInt(((Label)row.FindControl("lblCurrencyCountryID")).Text);//
                        dr["Currency"] = Util.GetString(((Label)row.FindControl("lblCurrency")).Text);//
                        dr["Rate"] = Util.GetDecimal(((Label)row.FindControl("lblRate")).Text);//

                        dr["IGSTAmt"] = Util.GetDecimal(((Label)row.FindControl("lblIGSTAmt")).Text);//
                        dr["SGSTAmt"] = Util.GetDecimal(((Label)row.FindControl("lblSGSTAmt")).Text);//
                        dr["CGSTAmt"] = Util.GetDecimal(((Label)row.FindControl("lblCGSTAmt")).Text);//
                        dr["ConsignmentID"] = Util.GetInt(((Label)row.FindControl("lblConsignmentID")).Text);//
                        dt.Rows.Add(dr);
                    }
                }
            }
            dt.AcceptChanges();
            ViewState["ReturnItem"] = dt;
            grdReturnItem.DataSource = dt;
            grdReturnItem.DataBind();
            btnSave.Visible = true;
            grdItems.DataSource = null;
            grdItems.DataBind();
            //txtBar.Text = string.Empty;
            //txtBar.Focus();
            btnAddItem.Visible = false;
        }
    }
    protected void grdReturnItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int index = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["ReturnItem"];
            dtItem.Rows[index].Delete();
            dtItem.AcceptChanges();
            ViewState["ReturnItem"] = dtItem;
            if (dtItem != null && dtItem.Rows.Count > 0)
            {
                grdReturnItem.DataSource = dtItem;
                grdReturnItem.DataBind();
                btnSave.Visible = true;
            }
            else
            {
                grdReturnItem.DataSource = null;
                grdReturnItem.DataBind();
                btnSave.Visible = false;
            }
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        int IsMedClear = Util.GetInt(StockReports.ExecuteScalar("Select IsMedCleared from patient_medical_history where TransactionID='" + lblTransactionNo.Text.Trim() + "'"));

        if (IsMedClear == 1)
        {
            lblMsg.Text = "PATIENT MEDICAL CLEARANCE HAS BEEN DONE, YOU CAN'T RETURN ITEMS";
            return;
        }
        bool patientvalidate = false;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        /*************Patient Return*******************/
        string Led = SaveReturnItems(Tranx, con);
        if (Led != "")
        {
            if (Led == "#")
            {
                patientvalidate = false;
                lblMsg.Text = "Error Occurred,Please Contact Administrator";
                Tranx.Rollback();
            }
            else { patientvalidate = true; }
        }
        else 
        {
            patientvalidate = false;
            lblMsg.Text = "Error Occurred,Please Contact Administrator";
            Tranx.Rollback();
        }
        /*************************************************/

        /*************Vendor Return*******************/
        string LedTnxNo = SaveVendorReturn(Tranx, con);
        if (LedTnxNo == string.Empty)
        {
            patientvalidate = false;
            lblMsg.Text = "Error Occurred,Please Contact Administrator";
            Tranx.Rollback();
        }
        else { patientvalidate = true; }
        /*************************************************/

        string result = SaveConsignmentDetail(Tranx, con);
        if (result == "0")
        {
            patientvalidate = false;
            lblMsg.Text = "Error Occurred,Please Contact Administrator";
            Tranx.Rollback();
        }

        if (patientvalidate == true)
        {
            //con.Open();
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();

            string ledgerno = "";
            if (chkPrint.Checked)
            {
                ledgerno = Util.GetString(Led.Split('#')[1]);
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "AlertMsg(" + ledgerno + "," + LedTnxNo + ");", true);

           // ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='ConsignmentSaleReturn.aspx';", true);
        }
        
    }

    private string SaveReturnItems(MySqlTransaction Tranx, MySqlConnection con)
    {
        if (ViewState["ReturnItem"] != null)
        {
            DataTable dtItem = (DataTable)ViewState["ReturnItem"];
            string LedTxnID = string.Empty;
           // MySqlConnection con = Util.GetMySqlCon();
          //  con.Open();
           // MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            string BillNo = string.Empty;
            string sqlCMD = string.Empty;
            int SalesNo = 0;

            try
            {
                float totalReturnQuantity = Util.GetFloat(dtItem.AsEnumerable().Sum(x => x.Field<float>("RetQty")).ToString());
                if (totalReturnQuantity <= 0)
                {
                    for (int i = 0; i < dtItem.Rows.Count; i++)
                    {
                        //float returnQuantity = Util.GetFloat(dtItem.Rows[i]["RetQty"]);
                        int rejectQuantity = Util.GetInt(dtItem.Rows[i]["RejectQty"]);

                        if (rejectQuantity > 0)
                        {

                            sqlCMD = "UPDATE f_indent_detail_patient_return SET RejectQty=(RejectQty+" + dtItem.Rows[i]["RejectQty"] + ") WHERE ID=" + Util.GetString(dtItem.Rows[i]["ID"]) + "";
                            int update = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sqlCMD);
                            if (update == 0)
                            {
                                return string.Empty;
                            }
                        }
                    }
                }
                else
                {
                    BillNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select get_billno_store_return('" + ViewState["DeptLedgerNo"].ToString() + "','" + Session["CentreID"].ToString() + "')").ToString();
                    if (BillNo == "")
                    {
                        lblMsg.Text = "Please Generate Bill No.";
                        return "";
                    }
                    if (dtItem.Columns.Contains("BillNo") == false) dtItem.Columns.Add("BillNo");
                    dtItem.Rows[0]["BillNo"] = BillNo.ToString();

                    SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('5','" + AllGlobalFunction.MedicalStoreID + "','" + Session["CentreID"].ToString() + "') "));

                    Ledger_Transaction objLedTran = new Ledger_Transaction(Tranx);
                    objLedTran.LedgerNoCr = Util.GetString(dtItem.Rows[0]["LedgerNumber"]);
                    objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objLedTran.TypeOfTnx = "Patient-Return";
                    objLedTran.Date = DateTime.Now;
                    objLedTran.Time = DateTime.Now;
                    objLedTran.GrossAmount = Util.GetDecimal(dtItem.Compute("sum(Amount)", ""));
                    objLedTran.NetAmount = Util.GetDecimal("-" + dtItem.Compute("sum(Amount)", ""));
                    objLedTran.TransactionType_ID = 5;
                    objLedTran.PatientID = lblPatientID.Text.Trim();
                    objLedTran.TransactionID = lblTransactionNo.Text.Trim();
                    objLedTran.IndentNo = ""; //txtIndentNumber.Text.Trim();
                    objLedTran.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    objLedTran.UserID = Session["ID"].ToString();
                    objLedTran.BillNo = dtItem.Rows[0]["BillNo"].ToString();
                    objLedTran.BillDate = Util.GetDateTime(DateTime.Now.ToShortDateString());

                    if (ViewState["Indent_Dpt"] != null)
                        objLedTran.IndentNo = Util.GetString(ViewState["Indent_Dpt"]);
                    else
                        objLedTran.IndentNo = "-";

                    objLedTran.IPNo = lblTransactionNo.Text.Trim();
                    objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objLedTran.IpAddress = All_LoadData.IpAddress();
                    objLedTran.PatientType = lblPatient_Type.Text.Trim();
                    objLedTran.PanelID = Util.GetInt(lblPanelID.Text);
                    LedTxnID = objLedTran.Insert();
                    if (LedTxnID == string.Empty)
                    {
                        return string.Empty;
                    }

                    for (int i = 0; i < dtItem.Rows.Count; i++)
                    {
                        float returnQuantity = Util.GetFloat(dtItem.Rows[i]["RetQty"]);
                        float rejectQuantity = Util.GetFloat(dtItem.Rows[i]["RejectQty"]);

                        if (returnQuantity == 0)
                        {
                            if (rejectQuantity > 0)
                            {

                                sqlCMD = "UPDATE f_indent_detail_patient_return SET RejectQty=(RejectQty+" + dtItem.Rows[i]["RejectQty"] + ") WHERE ID=" + Util.GetString(dtItem.Rows[i]["ID"]) + "";
                                int update = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sqlCMD);
                                if (update == 0)
                                {
                                    return string.Empty;

                                }
                            }

                            continue;
                        }

                        decimal MRP = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
                        decimal SaleTaxPer = Util.GetDecimal(dtItem.Rows[i]["TaxPercent"]);
                        decimal SaleTaxAmtPerUnit = Math.Round(((((MRP * 100) / (100 + SaleTaxPer)) * SaleTaxPer) / 100), 6);

                        decimal TaxablePurVATAmt = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]) * Util.GetDecimal(dtItem.Rows[i]["RetQty"]) * (100 / (100 + Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"])));
                        decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"]) / 100;


                        var indentNo = StockReports.ExecuteScalar("SELECT d.IndentNo FROM f_indent_detail_patient_return d WHERE d.id=" + dtItem.Rows[i]["ID"].ToString());

                        if (string.IsNullOrEmpty(indentNo))
                            ViewState["Indent_Dpt"] = null;
                        else
                            ViewState["Indent_Dpt"] = indentNo;

                        //Insert into LedgerTransactionDetail Detail multiple row effect
                        LedgerTnxDetail objLTDetail = new LedgerTnxDetail(Tranx);
                        objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                        objLTDetail.LedgerTransactionNo = LedTxnID;
                        objLTDetail.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                        objLTDetail.SubCategoryID = Util.GetString(dtItem.Rows[i]["SubCategoryID"]);
                        objLTDetail.Rate = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
                        objLTDetail.Quantity = Util.GetDecimal("-" + dtItem.Rows[i]["RetQty"]);
                        objLTDetail.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                        objLTDetail.ItemName = Util.GetString(dtItem.Rows[i]["ItemName"]);
                        objLTDetail.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        objLTDetail.UserID = Convert.ToString(Session["ID"]);
                        objLTDetail.TransactionID = lblTransactionNo.Text.Trim();

                        if (Util.GetInt(dtItem.Rows[i]["IsPackage"]) == 1)
                        {
                            objLTDetail.IsPackage = 1;
                            objLTDetail.PackageID = Util.GetString(dtItem.Rows[i]["PackageID"]);
                            objLTDetail.NetItemAmt = 0;
                            objLTDetail.Amount = 0;
                        }
                        else
                        {
                            objLTDetail.IsPackage = 0;
                            objLTDetail.Amount = Util.GetDecimal("-" + dtItem.Rows[i]["Amount"]);
                            objLTDetail.NetItemAmt = Util.GetDecimal("-" + dtItem.Rows[i]["Amount"]);
                        }

                        objLTDetail.Type_ID = Util.GetString(dtItem.Rows[i]["Type_ID"]);
                        objLTDetail.ToBeBilled = Util.GetInt(dtItem.Rows[i]["ToBeBilled"]);
                        objLTDetail.ServiceItemID = Util.GetString(dtItem.Rows[i]["ServiceItemID"]);
                        objLTDetail.IsVerified = Util.GetInt(dtItem.Rows[i]["IsVerified"]);
                        objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                        objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                        objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dtItem.Rows[i]["SubCategoryID"]), con));
                        objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        objLTDetail.IpAddress = All_LoadData.IpAddress();
                        objLTDetail.IsExpirable = Util.GetInt(dtItem.Rows[i]["IsExpirable"].ToString().ToUpper() == "YES" ? 1 : 0);
                        objLTDetail.medExpiryDate = Util.GetDateTime(dtItem.Rows[i]["MedExpiryDate"].ToString());
                        objLTDetail.Type = "I";
                        objLTDetail.TransactionType_ID = 5;
                        objLTDetail.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        objLTDetail.VarifiedUserID = Convert.ToString(Session["ID"]);
                        objLTDetail.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                        objLTDetail.StoreLedgerNo = "STO00001";
                        objLTDetail.IsMedService = 1;
                        objLTDetail.BatchNumber = dtItem.Rows[i]["BatchNumber"].ToString();

                        objLTDetail.unitPrice = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]);
                        objLTDetail.PurTaxPer = Util.GetDecimal(dtItem.Rows[i]["TaxPercent"].ToString());
                        if (Util.GetDecimal(dtItem.Rows[i]["TaxPercent"].ToString()) > 0)
                            objLTDetail.PurTaxAmt = vatPuramt;
                        else
                            objLTDetail.PurTaxAmt = 0;
                        objLTDetail.RoomID = lblRoomID.Text;
                        objLTDetail.IPDCaseTypeID = lblCaseTypeID.Text;
                        //GST Changes
                        decimal igstPercent = Util.GetDecimal(dtItem.Rows[i]["IGSTPercent"]);
                        decimal csgtPercent = Util.GetDecimal(dtItem.Rows[i]["CGSTPercent"]);
                        decimal sgstPercent = Util.GetDecimal(dtItem.Rows[i]["SGSTPercent"]);

                        decimal nonTaxableRate = (objLTDetail.Rate * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                        decimal discount = objLTDetail.Rate * objLTDetail.DiscountPercentage / 100;
                        decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

                        decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                        decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                        decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);
                        objLTDetail.HSNCode = Util.GetString(dtItem.Rows[i]["HSNCode"]);
                        objLTDetail.IGSTPercent = igstPercent;
                        objLTDetail.IGSTAmt = Util.GetDecimal(IGSTTaxAmount);
                        objLTDetail.CGSTPercent = csgtPercent;
                        objLTDetail.CGSTAmt = Util.GetDecimal(CGSTTaxAmount);
                        objLTDetail.SGSTPercent = sgstPercent;
                        objLTDetail.SGSTAmt = Util.GetDecimal(SGSTTaxAmount);
                        //
                        objLTDetail.typeOfTnx = "Patient-Return";
                        int LdgTrnxDtlID = objLTDetail.Insert();

                        if (LdgTrnxDtlID == 0)
                        {
                            return string.Empty;
                        }

                        //Insert into salesdetail multiple row effect
                        Sales_Details objSales = new Sales_Details(Tranx);
                        objSales.Date = DateTime.Now;
                        objSales.Time = DateTime.Now;
                        objSales.LedgerNumber = Util.GetString(dtItem.Rows[i]["LedgerNumber"]);
                        objSales.DepartmentID = "STO00001";
                        objSales.IndentNo = ""; //txtIndentNumber.Text.Trim();
                        objSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                        objSales.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                        objSales.TrasactionTypeID = 5;
                        objSales.SoldUnits = Util.GetDecimal(dtItem.Rows[i]["RetQty"]);
                        objSales.PerUnitBuyPrice = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]);
                        objSales.PerUnitSellingPrice = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
                        objSales.LedgerTransactionNo = LedTxnID;
                        objSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                        objSales.UserID = Session["ID"].ToString();
                        objSales.BillNoforGP = Util.GetString(dtItem.Rows[i]["BillNo"]);
                        objSales.Type_ID = Util.GetString(dtItem.Rows[i]["Type_ID"]);
                        objSales.ToBeBilled = Util.GetInt(dtItem.Rows[i]["ToBeBilled"]);
                        objSales.ServiceItemID = Util.GetString(dtItem.Rows[i]["ServiceItemID"]);

                        if (ViewState["Indent_Dpt"] != null)
                            objSales.IndentNo = Util.GetString(ViewState["Indent_Dpt"]);
                        else
                            objSales.IndentNo = "-";

                        objSales.SalesNo = SalesNo;
                        objSales.PatientID = lblPatientID.Text.Trim();
                        objSales.IsReturn = 1;
                        objSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                        objSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        objSales.IpAddress = All_LoadData.IpAddress();
                        objSales.medExpiryDate = Util.GetDateTime(dtItem.Rows[i]["MedExpiryDate"].ToString());
                        objSales.LedgerTnxNo = LdgTrnxDtlID;
                        objSales.BillNo = Util.GetString(dtItem.Rows[i]["BillNo"]);
                        objSales.BatchNo = dtItem.Rows[i]["BatchNumber"].ToString();

                        objSales.TaxPercent = SaleTaxPer;
                        objSales.TaxAmt = SaleTaxAmtPerUnit * Util.GetDecimal(dtItem.Rows[i]["RetQty"]);
                        objSales.PurTaxPer = Util.GetDecimal(dtItem.Rows[i]["PurTaxPer"]);
                        objSales.PurTaxAmt = vatPuramt;

                        // Add new 29-06-2017 - For GST                
                        objSales.IGSTPercent = igstPercent;
                        objSales.IGSTAmt = Util.GetDecimal(IGSTTaxAmount);
                        objSales.CGSTPercent = csgtPercent;
                        objSales.CGSTAmt = Util.GetDecimal(CGSTTaxAmount);
                        objSales.SGSTPercent = sgstPercent;
                        objSales.SGSTAmt = Util.GetDecimal(SGSTTaxAmount);
                        objSales.HSNCode = Util.GetString(dtItem.Rows[i]["HSNCode"]);
                        objSales.GSTType = Util.GetString(dtItem.Rows[i]["GSTType"]);
                        objSales.TransactionID = lblTransactionNo.Text.Trim();
                        //   
                        string SalesID = objSales.Insert();

                        if (SalesID == string.Empty)
                        {
                            return string.Empty;
                        }

                        //for insert billno
                        string SalesBillno = "UPDATE f_salesdetails SET billno='" + dtItem.Rows[0]["BillNo"].ToString() + "' WHERE Salesid='" + SalesID + "' ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SalesBillno);

                        //----Check Release Count in Stock Table---------------------
                        string str = "select if(0 > (ReleasedCount-" + dtItem.Rows[i]["RetQty"] +
                            "),0,1)CHK from f_stock where stockID='" + objLTDetail.StockID + "'";
                        if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                        {
                            return string.Empty;
                        }

                        str = "update f_stock set  ReleasedCount = ReleasedCount - " + dtItem.Rows[i]["RetQty"] + " where StockID = '" + objLTDetail.StockID + "'";
                        int Result = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                        if (Result == 0)
                        {
                            return string.Empty;
                        }

                        if (ViewState["Indent_Dpt"] != null)
                        {
                            str = "UPDATE f_indent_detail_patient_return SET ReceiveQty=(ReceiveQty+" + dtItem.Rows[i]["RetQty"] + "),RejectQty=(RejectQty+" + dtItem.Rows[i]["RejectQty"] + ") WHERE ID='" + Util.GetString(dtItem.Rows[i]["ID"]) + "' AND ItemId='" + objLTDetail.ItemID + "'";
                            int update = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                            if (update == 0)
                            {
                                return string.Empty;

                            }
                        }
                    }
                }
                if (SalesNo > 0)
                {
                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        string IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(LedTxnID), 0, 5, SalesNo, Tranx));
                        if (IsIntegrated == "0")
                        {
                            return "0";
                        }
                        IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(Util.GetInt(LedTxnID), "", "R", Tranx));
                        if (IsIntegrated == "0")
                        {
                            return "0";
                        }
                    }
                }

                return BillNo + "#" + LedTxnID;
            }
            catch (Exception ex)
            {
                ClassLog log = new ClassLog();
                log.errLog(ex);
                return string.Empty;
            }
        }
        else
            return string.Empty;
    }

    private string SaveVendorReturn(MySqlTransaction Tranx, MySqlConnection con)
    {
        if (ViewState["ReturnItem"] != null)
        {
            string LedgerTnxNo = string.Empty;
            DataTable dt = (DataTable)ViewState["ReturnItem"];

            try
            {
                Ledger_Transaction objLedTran = new Ledger_Transaction(Tranx);
                objLedTran.LedgerNoCr = Util.GetString(dt.Rows[0]["VenLedgerNo"]);
                objLedTran.Date = DateTime.Now;
                objLedTran.Time = DateTime.Now;
                objLedTran.GrossAmount = Util.GetDecimal(dt.Compute("sum(Amount)", ""));
                objLedTran.NetAmount = Util.GetDecimal(dt.Compute("sum(Amount)", ""));
                objLedTran.TypeOfTnx = "Vendor-Return";
                objLedTran.Remarks = "ReturnN";
                objLedTran.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                objLedTran.LedgerNoDr = "STO00001";
                objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
                objLedTran.Hospital_ID = Session["HOSPID"].ToString();
                objLedTran.IpAddress = All_LoadData.IpAddress();
                objLedTran.UserID = Convert.ToString(Session["ID"]);
                objLedTran.TransactionType_ID = 7;
                LedgerTnxNo = objLedTran.Insert().ToString();
                if (LedgerTnxNo == string.Empty)
                {
                    return string.Empty;
                }

                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('7','" + "STO00001" + "','" + Util.GetInt(Session["CentreID"].ToString()) + "') "));

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    string venledgerno = StockReports.ExecuteScalar("SELECT DISTINCT(VendorLedgerNo) AS V FROM consignmentdetail WHERE ID=" + Util.GetInt(dt.Rows[i]["ConsignmentID"]) + "");
                    decimal IGSTAmt = 0, CGSTAmt = 0, SGSTAmt = 0, TaxableAmt = 0;
                    decimal TaxableVATAmt = Util.GetDecimal(dt.Rows[i]["UnitPrice"]) * Util.GetDecimal(dt.Rows[i]["RetQty"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["PurTaxPer"])));
                    decimal vatamt = TaxableVATAmt * Util.GetDecimal(dt.Rows[i]["PurTaxPer"]) / 100;

                    decimal TaxableSaleVATAmt = Util.GetDecimal(dt.Rows[i]["MRP"]) * Util.GetDecimal(dt.Rows[i]["RetQty"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["SaleTaxPer"])));
                    decimal vatSaleamt = TaxableSaleVATAmt * Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]) / 100;

                    TaxableAmt = Util.GetDecimal(dt.Rows[i]["UnitPrice"]) * Util.GetDecimal(dt.Rows[i]["RetQty"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["IGSTPercent"]) + Util.GetDecimal(dt.Rows[i]["CGSTPercent"]) + Util.GetDecimal(dt.Rows[i]["SGSTPercent"])));
                    IGSTAmt = Math.Round(TaxableAmt * Util.GetDecimal(dt.Rows[i]["IGSTPercent"]) * Util.GetDecimal(0.01), 4, MidpointRounding.AwayFromZero);
                    CGSTAmt = Math.Round(TaxableAmt * Util.GetDecimal(dt.Rows[i]["CGSTPercent"]) * Util.GetDecimal(0.01), 4, MidpointRounding.AwayFromZero);
                    SGSTAmt = Math.Round(TaxableAmt * Util.GetDecimal(dt.Rows[i]["SGSTPercent"]) * Util.GetDecimal(0.01), 4, MidpointRounding.AwayFromZero);

                    LedgerTnxDetail objLedDet = new LedgerTnxDetail(Tranx);
                    objLedDet.ItemID = Util.GetString(dt.Rows[i]["ItemID"]);
                    objLedDet.StockID = Util.GetString(dt.Rows[i]["StockID"]);
                    objLedDet.SubCategoryID = Util.GetString(dt.Rows[i]["SubCategory"]);
                    objLedDet.Rate = Util.GetDecimal(dt.Rows[i]["UnitPrice"]);
                    objLedDet.Quantity = Util.GetDecimal(dt.Rows[i]["RetQty"]);
                    objLedDet.Amount = Util.GetDecimal(dt.Rows[i]["Amount"]);
                    objLedDet.NetItemAmt = Util.GetDecimal(dt.Rows[i]["Amount"]);
                    objLedDet.EntryDate = DateTime.Now;
                    objLedDet.UserID = Convert.ToString(Session["ID"]);
                    objLedDet.LedgerTransactionNo = LedgerTnxNo;
                    objLedDet.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objLedDet.Hospital_Id = Session["HOSPID"].ToString();
                    objLedDet.pageURL = All_LoadData.getCurrentPageName();
                    objLedDet.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    objLedDet.IsExpirable = Util.GetInt(dt.Rows[i]["IsExpirable"]);
                    objLedDet.medExpiryDate = Util.GetDateTime(dt.Rows[i]["MedExpiryDate"]);
                    objLedDet.IpAddress = All_LoadData.IpAddress();
                    objLedDet.TransactionType_ID = 7;
                    objLedDet.PurTaxPer = Util.GetDecimal(dt.Rows[i]["IGSTPercent"]) + Util.GetDecimal(dt.Rows[i]["CGSTPercent"]) + Util.GetDecimal(dt.Rows[i]["SGSTPercent"]);
                    objLedDet.PurTaxAmt = vatamt;
                    objLedDet.IsFree = Util.GetInt(dt.Rows[i]["IsFree"]);
                    //GST Changes
                    objLedDet.IGSTPercent = Util.GetDecimal(dt.Rows[i]["IGSTPercent"]);
                    objLedDet.IGSTAmt = IGSTAmt;
                    objLedDet.CGSTPercent = Util.GetDecimal(dt.Rows[i]["CGSTPercent"]);
                    objLedDet.CGSTAmt = CGSTAmt;
                    objLedDet.SGSTPercent = Util.GetDecimal(dt.Rows[i]["SGSTPercent"]);
                    objLedDet.SGSTAmt = SGSTAmt;
                    objLedDet.GSTType = Util.GetString(dt.Rows[i]["GSTType"]);
                    objLedDet.HSNCode = Util.GetString(dt.Rows[i]["HSNCode"]);
                    //----
                    int LedTnxID = objLedDet.Insert();
                    if (LedTnxID == 0)
                    {
                        return string.Empty;
                    }

                    Sales_Details ObjSales = new Sales_Details(Tranx);
                    ObjSales.LedgerTransactionNo = LedgerTnxNo;
                    ObjSales.LedgerNumber = venledgerno;// Util.GetString(dt.Rows[i]["LedgerNumber"]);
                    ObjSales.DepartmentID = "STO00001";
                    ObjSales.StockID = Util.GetString(dt.Rows[i]["StockID"]);
                    ObjSales.SoldUnits = Util.GetDecimal(dt.Rows[i]["RetQty"]);
                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(dt.Rows[i]["UnitPrice"]);
                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(dt.Rows[i]["MRP"]);
                    ObjSales.TrasactionTypeID = 7;
                    ObjSales.ItemID = Util.GetString(dt.Rows[i]["ItemID"]);
                    ObjSales.Naration = "ReturnN";
                    ObjSales.IndentNo = txtIndentNo.Text.Trim();
                    ObjSales.SalesNo = SalesNo;
                    ObjSales.Date = DateTime.Now;
                    ObjSales.Time = DateTime.Now;
                    ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    ObjSales.UserID = Session["ID"].ToString();
                    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    ObjSales.Hospital_ID = Session["HOSPID"].ToString();
                    ObjSales.IpAddress = All_LoadData.IpAddress();
                    ObjSales.medExpiryDate = Util.GetDateTime(dt.Rows[i]["MedExpiryDate"]);
                    ObjSales.LedgerTnxNo = LedTnxID;
                    ObjSales.PurTaxAmt = vatamt;
                    ObjSales.PurTaxPer = Util.GetDecimal(dt.Rows[i]["PurTaxPer"]);

                    ObjSales.TaxPercent = Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]);
                    ObjSales.TaxAmt = vatSaleamt;

                    //GST Changes
                    ObjSales.IGSTPercent = Util.GetDecimal(dt.Rows[i]["IGSTPercent"]);
                    ObjSales.IGSTAmt = IGSTAmt;
                    ObjSales.CGSTPercent = Util.GetDecimal(dt.Rows[i]["CGSTPercent"]);
                    ObjSales.CGSTAmt = CGSTAmt;
                    ObjSales.SGSTPercent = Util.GetDecimal(dt.Rows[i]["SGSTPercent"]);
                    ObjSales.SGSTAmt = SGSTAmt;
                    ObjSales.GSTType = Util.GetString(dt.Rows[i]["GSTType"]);
                    ObjSales.HSNCode = Util.GetString(dt.Rows[i]["HSNCode"]);

                    string SalesID = ObjSales.Insert();
                    if (SalesID == string.Empty)
                    {
                        return string.Empty;
                    }

                    string str = "insert Into f_vendor_return (Vender_ID,LedgerTransactionNo,ItemID,QTY,Rate,Amount,AgainstLedgerTransactionNo,DeptID,EditedBy,EditedDate,statusType,SalesID ) ";
                    str = str + ("values ('" + dt.Rows[i]["VenLedgerNo"] + "','" + LedgerTnxNo + "','" + Util.GetString(dt.Rows[i]["ItemID"]) + "','" + Util.GetDecimal(dt.Rows[i]["RetQty"]) + "','" + Util.GetDecimal(dt.Rows[i]["UnitPrice"]) + "','" + Util.GetDecimal(dt.Rows[i]["Amount"]) + "','" + Util.GetString(dt.Rows[i]["LedgerTransactionNo"]) + "','" + ViewState["DeptLedgerNo"].ToString() + "','" + Session["ID"].ToString() + "',CURRENT_DATE,0,'" + SalesID + "')");
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str) == 0)
                    {
                        return string.Empty;
                    }

                    str = "update f_stock set  ReleasedCount = ReleasedCount + " + dt.Rows[i]["RetQty"] + " where StockID = '" + dt.Rows[i]["StockID"] + "'";
                    int Result = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                    if (Result == 0)
                    {
                        return string.Empty;
                    }
                }

                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    string IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(LedgerTnxNo), 0, 7, SalesNo, Tranx));
                    if (IsIntegrated == "0")
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                    }
                }

                return SalesNo.ToString();
            }
            catch (Exception ex)
            {

                return string.Empty;
            }
            finally
            {
                ////Tranx.Dispose();
                //con.Close();
                //con.Dispose();
            }
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        
        return string.Empty;
    }

    private string SaveConsignmentDetail(MySqlTransaction Tranx, MySqlConnection con)
    {
        string result = "1";
        if (ViewState["ReturnItem"] != null)
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            string LedgerTnxNo = string.Empty;
            DataTable dt = (DataTable)ViewState["ReturnItem"];

            try
            {
                int ConsignmentNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT IFNULL(MAX(ConsignmentNo),0)+1 FROM consignmentdetail"));

                string str = "INSERT INTO consignmentdetail(ConsignmentNo,VendorLedgerNo,ChallanNo,ChallanDate,BillNo,BillDate,ItemID,ItemName,BatchNumber,Rate,UnitPrice,TaxPer,PurTaxAmt,DiscAmt,SaleTaxPer,SaleTaxAmt,TYPE,Reusable,IsBilled,TaxID,DiscountPer,MRP,Unit,InititalCount,StockDate,IsPost,IsFree,Naration,DeptLedgerNo,GateEntryNo,UserID,Freight,Octroi,RoundOff,GRNAmount,MedExpiryDate,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,GSTType,SpecialDiscPer,isDeal,ConversionFactor,OtherCharges, MarkUpPercent, LandingCost, CurrencyCountryID,Currency,CurrencyFactor,CentreID,IGSTAmt,CGSTAmt,SGSTAmt,Quantity,ItemNetAmount,StockID,IsReturn) VALUES(@ConsignmentNo,@VendorLedgerNo,@ChallanNo,@ChallanDate,@BillNo,@BillDate,@ItemID,@ItemName,@BatchNumber,@Rate,@UnitPrice,@TaxPer,@PurTaxAmt,@DiscAmt,@SaleTaxPer,@SaleTaxAmt,@TYPE,@Reusable,@IsBilled,@TaxID,@DiscountPer,@MRP,@Unit,@InititalCount,@StockDate,@IsPost,@IsFree,@Naration,@DeptLedgerNo,@GateEntryNo,@UserID,@Freight,@Octroi,@RoundOff,@GRNAmount,@MedExpiryDate,@HSNCode,@IGSTPercent,@CGSTPercent,@SGSTPercent,@GSTType,@SpecialDiscPer,@isDeal,@ConversionFactor,@OtherCharges, @MarkUpPercent, @LandingCost, @CurrencyCountryID,@Currency,@CurrencyFactor,@CentreID,@IGSTAmt,@CGSTAmt,@SGSTAmt,@Quantity,@ItemNetAmount,@StockID,@IsReturn ) ";

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    int ConID = Util.GetInt(dt.Rows[i]["ConsignmentID"]);
                    String BillNo = Util.GetString(StockReports.ExecuteScalar("SELECT BillNo FROM consignmentdetail WHERE Id=" + ConID + ""));
                    int ReusableValue = 0;
                    string Reusable = Util.GetString(StockReports.ExecuteScalar("SELECT im.IsUsable FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dt.Rows[i]["ItemID"]) + "'"));
                    if (Reusable == "R")
                        ReusableValue = Util.GetInt("1");
                    else
                        ReusableValue = Util.GetInt("0");

                    decimal TaxablePurVATAmt = Util.GetDecimal(dt.Rows[i]["UnitPrice"]) * Util.GetDecimal(dt.Rows[i]["RetQty"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["PurTaxPer"])));
                    decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dt.Rows[i]["PurTaxPer"]) / 100;

                    decimal TaxableSaleVATAmt = Util.GetDecimal(dt.Rows[i]["MRP"]) * Util.GetDecimal(dt.Rows[i]["RetQty"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["SaleTaxPer"])));
                    decimal vatSaleamt = TaxableSaleVATAmt * Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]) / 100;
                    decimal igstamt = 0, cgstamt = 0, sgstamt = 0, itemnetamt = 0;
                    if (Util.GetInt(dt.Rows[i]["IsFree"]) == 0)
                    {
                        igstamt = Util.GetDecimal(dt.Rows[i]["IGSTAmt"]);
                        cgstamt = Util.GetDecimal(dt.Rows[i]["CGSTAmt"]);
                        sgstamt = Util.GetDecimal(dt.Rows[i]["SGSTAmt"]);
                        itemnetamt = ((Util.GetDecimal(dt.Rows[i]["Rate"]) * Util.GetDecimal(dt.Rows[i]["RetQty"])) - Util.GetDecimal(dt.Rows[i]["DiscAmt"]));
                    }

                    var ValidEntry = excuteCMD.DML(Tranx, str.ToString(), CommandType.Text, new
                    {
                        ConsignmentNo = ConsignmentNo,
                        VendorLedgerNo = Util.GetString(dt.Rows[i]["VenLedgerNo"]),
                        ChallanNo = Util.GetString(dt.Rows[i]["ChalanNo"]),
                        ChallanDate = Util.GetDateTime(dt.Rows[i]["DATE"]).ToString("yyyy-MM-dd"),
                        BillNo = Util.GetString(BillNo),//"Invoice " + ConsignmentNo
                        BillDate = Util.GetDateTime(dt.Rows[i]["DATE"]).ToString("yyyy-MM-dd"),
                        ItemID = Util.GetString(dt.Rows[i]["ItemID"]),
                        ItemName = Util.GetString(dt.Rows[i]["ItemName"]),
                        BatchNumber = Util.GetString(dt.Rows[i]["BatchNumber"]),

                        Rate = Util.GetDecimal(dt.Rows[i]["Rate"]), //* Util.GetDecimal(dt.Rows[i]["CurrencyFactor"]),
                        UnitPrice = Util.GetDecimal(dt.Rows[i]["UnitPrice"]),
                        TaxPer = Util.GetDecimal(dt.Rows[i]["PurTaxPer"]),
                        PurTaxAmt = Util.GetDecimal(vatPuramt),
                        DiscAmt = (((Util.GetDecimal(dt.Rows[i]["Rate"]) * Util.GetDecimal(dt.Rows[i]["RetQty"])) * Util.GetDecimal(dt.Rows[i]["DiscPer"])) / 100), //* Util.GetDecimal(dt.Rows[i]["CurrencyFactor"]),

                        SaleTaxPer = Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]),
                        SaleTaxAmt = vatSaleamt,
                        TYPE = Util.GetString(StockReports.ExecuteScalar("SELECT im.Type_ID FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dt.Rows[i]["ItemID"]) + "'")),
                        Reusable = ReusableValue,
                        IsBilled = 1,
                        TaxID = 0,
                        DiscountPer = Util.GetDecimal(dt.Rows[i]["DiscPer"]),
                        MRP = (Util.GetDecimal(dt.Rows[i]["MRP"])) / Util.GetDecimal(dt.Rows[i]["ConversionFactor"]), //* Util.GetDecimal(dt.Rows[i]["CurrencyFactor"])
                        Unit = dt.Rows[i]["MajorUnit"],
                        InititalCount = Util.GetDecimal(dt.Rows[i]["RetQty"]) * Util.GetDecimal(dt.Rows[i]["ConversionFactor"]),
                        StockDate = DateTime.Now,
                        IsPost = 1,
                        IsFree = Util.GetInt(dt.Rows[i]["IsFree"]),
                        Naration = "",
                        DeptLedgerNo = dt.Rows[i]["DeptLedgerNo"],
                        GateEntryNo = "",
                        UserID = HttpContext.Current.Session["ID"].ToString(),
                        Freight = Util.GetDecimal("0"),
                        Octroi = Util.GetDecimal("0"),
                        RoundOff = 0,
                        GRNAmount = (Util.GetDecimal(dt.Rows[i]["Rate"]) * Util.GetDecimal(dt.Rows[i]["RetQty"])), //* Util.GetDecimal(dt.Rows[i]["CurrencyFactor"]),
                        MedExpiryDate = Util.GetDateTime(dt.Rows[i]["MedExpiryDate"]),
                        HSNCode = dt.Rows[i]["HSNCode"],
                        IGSTPercent = Util.GetDecimal(dt.Rows[i]["IGSTPercent"]),
                        CGSTPercent = Util.GetDecimal(dt.Rows[i]["CGSTPercent"]),
                        SGSTPercent = Util.GetDecimal(dt.Rows[i]["SGSTPercent"]),
                        GSTType = dt.Rows[i]["GSTType"],
                        SpecialDiscPer = Util.GetDecimal(dt.Rows[i]["SpecialDiscPer"]),
                        isDeal = Util.GetString(dt.Rows[i]["isDeal"]),
                        ConversionFactor = Util.GetDecimal(dt.Rows[i]["ConversionFactor"]),
                        OtherCharges = Util.GetDecimal(dt.Rows[i]["otherCharges"]),// * Util.GetDecimal(dt.Rows[i]["CurrencyFactor"]),
                        MarkUpPercent = Util.GetDecimal(dt.Rows[i]["markUpPercent"]),
                        LandingCost = Util.GetDecimal(dt.Rows[i]["UnitPrice"]),
                        CurrencyCountryID = Util.GetInt(dt.Rows[i]["currencyCountryID"]),
                        Currency = Util.GetString(dt.Rows[i]["currency"]),
                        CurrencyFactor = Util.GetDecimal(dt.Rows[i]["CurrencyFactor"]),
                        CentreID = Util.GetInt(Session["CentreID"].ToString()),
                        IGSTAmt = igstamt, //* Util.GetDecimal(dt.Rows[i]["CurrencyFactor"]),
                        CGSTAmt = cgstamt, //* Util.GetDecimal(dt.Rows[i]["CurrencyFactor"]),
                        SGSTAmt = sgstamt, //* Util.GetDecimal(dt.Rows[i]["CurrencyFactor"]),
                        Quantity = dt.Rows[i]["inHandUnits"],
                        ItemNetAmount = itemnetamt, // * Util.GetDecimal(dt.Rows[i]["CurrencyFactor"])
                        StockID = dt.Rows[i]["StockID"],
                        IsReturn = Util.GetInt(1)
                    });

                    if (Util.GetInt(ValidEntry) < 1)
                    {
                        result = "0";
                       // Tranx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Consignment Entry" });
                    }

                    return result;
                }
            }
            catch (Exception ex)
            {
              //  Tranx.Rollback();
                return string.Empty;
            }
            finally
            {
               // Tranx.Dispose();
               // con.Close();
              //  con.Dispose();
            }
        }
        else 
        {
            result = "0";
        }

        return result;
    }
}