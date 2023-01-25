using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Consignment_StockTransfer : System.Web.UI.Page
{
    protected void btnAddFromPopUp_Click(object sender, EventArgs e)
    {
        DataTable dtPop = new DataTable();
        dtPop = (DataTable)Session["popdata"];
        Session["popdata"] = null;

        if (dtPop != null)
        {
            DataTable dt;
            if (ViewState["StockTransfer"] != null)
                dt = (DataTable)ViewState["StockTransfer"];
            else
                dt = GetItemDataTable();
            for (int i = 0; i < dtPop.Rows.Count; i++)
            {
                DataRow drNew = dtPop.Rows[i];
                if (dt.Select("StockID=" + Util.GetString(drNew["StockID"]) + "", "").Length == 0)
                {
                    DataRow dr = dt.NewRow();
                    dr["ItemID"] = Util.GetString(drNew["ItemID"]);
                    dr["ItemName"] = Util.GetString(drNew["ItemName"]);
                    dr["BatchNumber"] = Util.GetString(drNew["BatchNumber"]);
                    dr["UnitPrice"] = Util.GetString(drNew["UnitPrice"]);
                    dr["MRP"] = Util.GetString(drNew["MRP"]);
                    dr["SubCategory"] = Util.GetString(drNew["SubCategory"]);
                    dr["IssueQty"] = Util.GetString(drNew["IssueQty"]);
                    dr["Qty"] = Util.GetDecimal(drNew["Qty"]);
                    dr["StockID"] = Util.GetString(drNew["StockID"]);
                    dr["UnitType"] = Util.GetString(drNew["UnitType"]);
                    dr["Amount"] = Util.GetDecimal(drNew["Amount"]);
                   
                    dt.Rows.Add(dr);
                }
            }
            dt.AcceptChanges();
            ViewState["StockTransfer"] = dt;

            grdItemDetails.DataSource = dt;
            grdItemDetails.DataBind();
            lblTotalAmount.Text = Util.GetString(dt.Compute("sum(Amount)", ""));
        }
    }

    protected void btnWord_Click(object sender, EventArgs e)
    {
        BindItem();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        //btnSave.Enabled = true;
        if (!IsPostBack)
        {
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            BindItem();

            ucDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            toDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        ucDate.Attributes.Add("readOnly", "true");
        toDate.Attributes.Add("readOnly", "true");
    }

    #region BindDataLoad

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        string str = " SELECT ID ,ConsignmentNo,itemID,BillNo,ChallanNo,DeptLedgerNo,Rate,TaxPer,PurTaxAmt,DiscAmt,SaleTaxPer,SaleTaxAmt,TYPE,Reusable,IsBilled,TaxID,ItemName,MedExpiryDate,Date_Format(MedExpiryDate,'%d %b %Y')MedExpiry,BatchNumber,UnitPrice,DiscountPer,MRP,Freight,Octroi,RoundOff,VendorLedgerNo,(InititalCount-ReleasedCount)AvailQty,(SELECT subcategoryID FROM f_itemmaster WHERE itemID='" + ListBox1.SelectedValue + "') SubCategoryID,(SELECT Type_ID FROM f_itemmaster   WHERE ItemID='" + ListBox1.SelectedValue + "')Type_ID,(SELECT UnitTYpe FROM f_itemmaster WHERE ItemID='" + ListBox1.SelectedValue + "')UnitTYpe,(SELECT IsActive FROM f_itemmaster WHERE ItemID = '" + ListBox1.SelectedValue + "') IsActive,IFNULL(HSNCode,'')HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,IFNULL(GSTType,'')GSTType,SpecialDiscPer,IFNULL(isDeal,'')isDeal,ConversionFactor FROM consignmentdetail where IsPost=1 and  if(MedExpiryDate <> '0001-01-31',MedExpiryDate>=curdate(),'1=1') AND (InititalCount-ReleasedCount)>0 and ItemID='" + ListBox1.SelectedValue + "'";
        //string str = "SELECT st.StockID,st.ItemID,st.ItemName,st.BatchNumber,st.UnitPrice,st.MRP,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')MedExpiryDate, (st.InitialCount-st.ReleasedCount)AvailQty,st.SubCategoryID, im.Type_ID,im.IsUsable, im.ToBeBilled, st.UnitType,im.ServiceItemID,im.isexpirable,st.PurTaxPer,st.HSNCode,st.IGSTPercent,st.IGSTAmtPerUnit,st.SGSTPercent,st.SGSTAmtPerUnit,st.CGSTPercent,st.CGSTAmtPerUnit,st.GSTType FROM f_stock st INNER JOIN f_itemmaster im ON st.ItemID=im.ItemID WHERE st.ItemID='" + ListBox1.SelectedValue + "'  AND (st.InitialCount-st.ReleasedCount)>0 AND st.Ispost=1  AND st.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'  AND st.MedExpiryDate>CURDATE() ORDER BY st.stockid ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
             int isActive = Util.GetInt(dt.Rows[0]["IsActive"]);
            if (isActive != 1)
            {
                lblMsg.Text = "Please Map With Finance First.";
				grdItem.DataSource = null;
            grdItem.DataBind();
                return;
            }
            else
                lblMsg.Text = string.Empty;
            grdItem.DataSource = dt;
            grdItem.DataBind();
            decimal TranferQty = Util.GetDecimal(txtTransferQty.Text.Trim());
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (TranferQty > Util.GetDecimal(dt.Rows[i]["AvailQty"]))
                {
                    ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = Util.GetString(dt.Rows[i]["AvailQty"]);
                    ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                    TranferQty = TranferQty - Util.GetDecimal(dt.Rows[i]["AvailQty"]);
                }
                else
                {
                    ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = TranferQty.ToString();
                    ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                    break;
                }
            }
            AllQuery AQ = new AllQuery();
            string AdmitDate = AQ.getAdmitDate("ISHHI" + lblTransactionNo.Text.Trim());

            string PrescribeDate = Util.GetDateTime(toDate.Text).ToString("yyyy-MM-dd");

            if (Util.GetDateTime(PrescribeDate) < Util.GetDateTime(AdmitDate))
            {
                lblMsg.Text = "Given Date is less then Admit Date";
                return;
            }
            btnAddItem.Focus();
            btnAddItem.Visible = true;


            //btnAddItem_Click(btnAddItem, EventArgs.Empty);
        }
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
        }
    }

    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        if (ValidateItems())
        {
            DataTable dt;
            if (ViewState["StockTransfer"] != null)
                dt = (DataTable)ViewState["StockTransfer"];
            else
                dt = GetItemDataTable();

            foreach (GridViewRow row in grdItem.Rows)
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked)
                {
                    DataRow dr = dt.NewRow();
                    dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                    dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                    dr["BatchNumber"] = ((Label)row.FindControl("lblBatchNumber")).Text;
                    dr["UnitPrice"] = Util.GetDecimal(((Label)row.FindControl("lblUnitPrice")).Text);
                    dr["MRP"] = Util.GetDecimal(((Label)row.FindControl("lblMRP")).Text);

                    if (((Label)row.FindControl("lblSubCategory")).Text.Trim() != "")
                        dr["SubCategory"] = ((Label)row.FindControl("lblSubCategory")).Text;
                    else
                        dr["SubCategory"] = StockReports.ExecuteScalar("Select SubCategoryID from f_itemmaster where itemid='" + ((Label)row.FindControl("lblItemID")).Text + "'");

                    decimal Qty = Util.GetDecimal(((TextBox)row.FindControl("txtIssueQty")).Text);
                    dr["IssueQty"] = Qty;
                    dr["Qty"] = Util.GetDecimal(((Label)row.FindControl("lblAvailQty")).Text);
                    dr["StockID"] = ((Label)row.FindControl("lblStockID")).Text;
                    dr["UnitType"] = ((Label)row.FindControl("lblUnitType")).Text;

                    if (rbtStorToDept.Checked == true)
                        dr["Amount"] = Util.GetDecimal(dr["UnitPrice"]) * Util.GetDecimal(dr["IssueQty"]);
                    else
                        dr["Amount"] = Util.GetDecimal(dr["IssueQty"]) * Util.GetDecimal(dr["MRP"]);
                    dr["Type_ID"] = ((Label)row.FindControl("lblType_ID")).Text;

                    dr["RoundOff"] = ((Label)row.FindControl("lblRoundOff")).Text;
                    dr["Octroi"] = ((Label)row.FindControl("lblOctroi")).Text;
                    dr["Freight"] = ((Label)row.FindControl("lblFreight")).Text;
                    dr["VendorLedgerNo"] = ((Label)row.FindControl("lblVendorLedgerNo")).Text;
                    dr["MedExpiryDate"] = ((Label)row.FindControl("lblMedExpiryDate")).Text;
                    dr["DeptLedgerNo"] = ((Label)row.FindControl("lblDeptLedgerNo")).Text;
                    dr["ServiceItemID"] = Util.GetString(StockReports.ExecuteScalar("Select ServiceItemID from f_itemmaster where ItemID='" + dr["ItemID"].ToString() + "'"));

                    dr["TaxID"] = ((Label)row.FindControl("lblTaxID")).Text;
                    dr["TaxPer"] = ((Label)row.FindControl("lblTaxPer")).Text;
                    dr["Rate"] = ((Label)row.FindControl("lblRate")).Text;
                    dr["TYPE"] = ((Label)row.FindControl("lblType")).Text;
                    dr["SaleTaxPer"] = ((Label)row.FindControl("lblSaleTaxPer")).Text;
                    dr["Discount"] = ((Label)row.FindControl("lblDiscount")).Text;

                    dr["HSNCode"] = ((Label)row.FindControl("lblHSNCode")).Text;
                    dr["IGSTPercent"] = ((Label)row.FindControl("lblIGSTPercent")).Text;
                    dr["CGSTPercent"] = ((Label)row.FindControl("lblCGSTPercent")).Text;
                    dr["SGSTPercent"] = ((Label)row.FindControl("lblSGSTPercent")).Text;
                    dr["GSTType"] = ((Label)row.FindControl("lblGSTType")).Text;
                    dr["SpecialDiscPer"] = ((Label)row.FindControl("lblSpecialDiscPer")).Text;
                    dr["isDeal"] = ((Label)row.FindControl("lblisDeal")).Text;
                    dr["ConversionFactor"] = ((Label)row.FindControl("lblConversionFactor")).Text;
                    dt.Rows.Add(dr);
                }
            }
            dt.AcceptChanges();
            ViewState["StockTransfer"] = dt;
            grdItemDetails.DataSource = dt;
            grdItemDetails.DataBind();
            lblTotalAmount.Text = Util.GetString(dt.Compute("sum(Amount)", ""));
            grdItem.DataSource = null;
            grdItem.DataBind();
            txtSearch.Text = "";
            SetFocus(txtSearch);
            pnlSave.Visible = true;
            btnAddItem.Visible = false;
            txtTransferQty.Text = "";
            //txtBar.Focus();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        ptnDetail.Visible = false;
        pnldetail.Visible = false;
        pnlSave.Visible = false;
        PatientSearch();
    }

    protected void grdItemDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int index = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["StockTransfer"];
            dtItem.Rows[index].Delete();
            dtItem.AcceptChanges();
            lblTotalAmount.Text = Util.GetString(dtItem.Compute("sum(Amount)", ""));
            ViewState["StockTransfer"] = dtItem;
            grdItemDetails.DataSource = dtItem;
            grdItemDetails.DataBind();
            if (dtItem.Rows.Count == 0)
                btnSave.Visible = false;
            else
                btnSave.Visible = true;

            txtSearch.Focus();
        }
    }

    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ASelect")
        {
            string TID = Util.GetString(e.CommandArgument);
            BindPatientDetails(TID);
            pnldetail.Visible = true;
            ptnDetail.Visible = true;
            grdPatient.DataSource = null;
            grdPatient.DataBind();
            grdItem.DataSource = null;
            grdItem.DataBind();
            AllLoadData_IPD.fromDatetoDate("ISHHI" + lblTransactionNo.Text.Trim(), ucDate, toDate, calucDate, caltoDate);
            txtSearch.Focus();
        }
    }

    private DataTable GetItemDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("StockID");
        dt.Columns.Add("ItemID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNumber");
        dt.Columns.Add("SubCategory");
        dt.Columns.Add("UnitType");
        dt.Columns.Add("MRP", typeof(float));
        dt.Columns.Add("UnitPrice", typeof(float));
        dt.Columns.Add("Qty", typeof(float));
        dt.Columns.Add("IssueQty", typeof(float));
        dt.Columns.Add("Amount", typeof(float));
        dt.Columns.Add("Type_ID");
        dt.Columns.Add("RoundOff");
        dt.Columns.Add("Octroi");
        dt.Columns.Add("Freight");
        dt.Columns.Add("VendorLedgerNo");
        dt.Columns.Add("BillNo");
        dt.Columns.Add("ChallanNo");
        dt.Columns.Add("MedExpiryDate");
        dt.Columns.Add("DeptLedgerNo");
        dt.Columns.Add("ServiceItemID");
        dt.Columns.Add("TaxPer");
        dt.Columns.Add("TaxID");
        dt.Columns.Add("Rate");
        dt.Columns.Add("SaleTaxPer");
        dt.Columns.Add("TYPE");
        dt.Columns.Add("Discount");

        dt.Columns.Add("HSNCode");
        dt.Columns.Add("IGSTPercent");
        dt.Columns.Add("CGSTPercent");
        dt.Columns.Add("SGSTPercent");
        dt.Columns.Add("GSTType");
        dt.Columns.Add("SpecialDiscPer");
        dt.Columns.Add("isDeal");
        dt.Columns.Add("ConversionFactor");
        return dt;
    }

    #endregion BindDataLoad

    #region BindData

    private void BindDepartment()
    {
        string str = "select LedgerNumber,LedgerName from  f_ledgermaster where GroupID='DPT' order by LedgerName ";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "LedgerName";
            ddlDepartment.DataValueField = "LedgerNumber";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("------", "0"));
        }
    }

   private void BindItem()
    {
        string str = "select itemid,concat(ItemName,'#',sum(InititalCount-ReleasedCount))itemname,TYPE from consignmentdetail where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' AND CentreID=" + Session["CentreID"].ToString() + " and Ispost=1 and (InititalCount-ReleasedCount)>0 and if(MedExpiryDate <> '0001-01-31',MedExpiryDate>=curdate(),'1=1') group by itemid order by itemname";
        //string str = "select itemid,concat(ItemName,'#',sum(InitialCount-ReleasedCount))itemname from f_stock where DeptLedgerNo = '" + ddlDepartment.SelectedItem.Value + "' and Ispost=1 and (InitialCount-ReleasedCount)>0 and MedExpiryDate>curdate() group by itemid order by itemname";
        DataTable dt = StockReports.GetDataTable(str);
        ViewState["BindItem"] = dt;
        if (dt != null && dt.Rows.Count > 0)
        {
            ListBox1.DataSource = dt;
            ListBox1.DataTextField = "ItemName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
        }
        else
        {
            ListBox1.Items.Clear();

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

                lblPatientName.Text = dt.Rows[0]["PName"].ToString();
                lblTransactionNo.Text = dt.Rows[0]["TransactionID"].ToString().Replace("ISHHI", "");
                lblRoomNo.Text = dt.Rows[0]["RoomNo"].ToString();
                lblPanelComp.Text = dt.Rows[0]["Company_Name"].ToString();
                lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
                ViewState["TID"] = dt.Rows[0]["TransactionID"].ToString();
                lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
                lblPatientType.Text = dt.Rows[0]["PatientType"].ToString();
                lblIPDCaseType_ID.Text = dt.Rows[0]["IPDCaseTypeID"].ToString();
                lblRoom_ID.Text = dt.Rows[0]["RoomID"].ToString();
            }
            DataTable dt1 = AQ.GetPatientIPDInformation(TransactionID);
            if (dt1.Rows.Count > 0)
            {
                lblDoctorName.Text = dt1.Rows[0]["DoctorName"].ToString();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void PatientSearch()
    {
        lblMsg.Text = "";
        if ((txtName.Text.Trim() == string.Empty) && (txtCRNo.Text.Trim() == string.Empty))
        {
            lblMsg.Text = "Please Enter Patient Name OR IPD No.";
            return;
        }

        StringBuilder sb = new StringBuilder();
        sb.Append(" select IP.TransactionID,PM.PName,CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.Locality,' ',PM.City)Address");
        sb.Append(" FROM  patient_medical_history IP  INNER JOIN  patient_master  PM ON IP.PatientID=PM.PatientID inner join patient_ipd_profile pip on pip.TransactionID=ip.TransactionID  WHERE  PIP.Status='IN' and IP.CentreID = " + Session["CentreID"].ToString() + " AND ");//f_ipdadjustment

        if (txtCRNo.Text.Trim() != string.Empty)
            sb.Append("   IP.TransNo='" + txtCRNo.Text.Trim() + "'");//
        if (txtName.Text.Trim() != string.Empty)
            sb.Append("   PM.PName like '%" + txtName.Text + "%'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdPatient.DataSource = dt;
            grdPatient.DataBind();
        }
        else
        {
            lblMsg.Text = "No Record Found";
            grdPatient.DataSource = null;
            grdPatient.DataBind();
        }
        grdItemDetails.DataSource = null;
        grdItemDetails.DataBind();
        grdItem.DataSource = null;
        grdItem.DataBind();
        txtTransferQty.Text = "";
        lblTotalAmount.Text = "0";
        if (ViewState["StockTransfer"] != null)
        {
            ViewState.Remove("StockTransfer");
        }
        AllLoadData_IPD.fromDatetoDate("" + StockReports.getTransactionIDbyTransNo( txtCRNo.Text.Trim()), ucDate, toDate, calucDate, caltoDate);
    }

    #endregion BindData

    #region Validation

    private bool ValidateItems()
    {
        DataTable dt = null;
        if (ViewState["StockTransfer"] != null)
            dt = (DataTable)ViewState["StockTransfer"];
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

                decimal TransferQty = 0, AvailQty = 0;

                if (((TextBox)row.FindControl("txtIssueQty")).Text.Trim() != string.Empty)
                    TransferQty = Util.GetDecimal(((TextBox)row.FindControl("txtIssueQty")).Text);
                else
                {
                    lblMsg.Text = "Please Specify Quantity";
                    ((TextBox)row.FindControl("txtIssueQty")).Focus();
                    return false;
                }
                if (TransferQty <= 0)
                {
                    lblMsg.Text = "Please Enter Valid Quantity";
                    ((TextBox)row.FindControl("txtIssueQty")).Focus();
                    return false;
                }

                AvailQty = Util.GetDecimal(((Label)row.FindControl("lblAvailQty")).Text);
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

    #endregion Validation

    #region Stock Transfer

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblTotalAmount.Text = "";
        lblMsg.Text = "";
        if ((rbtStorToPat.Checked == true) && (lblTransactionNo.Text.Trim() == string.Empty))
        {
            lblMsg.Text = "Please Give Patient Identification";
            ScriptManager1.SetFocus(txtCRNo);
            return;
        }
        if ((rbtStorToDept.Checked == true) && (ddlDepartment.SelectedIndex == 0))
        {
            lblMsg.Text = "Please select Department";
            ScriptManager1.SetFocus(ddlDepartment);
            return;
        }
        int IsMedClear = Util.GetInt(StockReports.ExecuteScalar("Select IsMedCleared from patient_medical_history where TransactionID='" + lblTransactionNo.Text.Trim() + "'"));//f_ipdadjustment

        if (IsMedClear == 1)
        {
            lblMsg.Text = "PATIENT MEDICAL CLEARANCE HAS BEEN DONE, YOU CAN'T RETURN ITEMS";
            return;
        }
        if (AllLoadData_IPD.CheckBillGenerate("ISHHI" + lblTransactionNo.Text.Trim(), "IPD") > 0)
        {
            lblMsg.Text = "Patient Bill Already Been Generated, Now you can not Issue any Medicine. Please contact to Billing Department.";
            return;
        }

        string SalesID = SaveData();

        if (SalesID != "0" && SalesID!=string.Empty)
        {
            string Sale = SalesID;
            clear();
            lblMsg.Text = "Record Saved Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key132323", "alert('Medicine is Issue to Patient IPD No. :'+'" + lblTransactionNo.Text + "');", true);
            if (chkPrint.Checked)
            {
                string LedTnxNo = SalesID;
                if (LedTnxNo != "")
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key2", "window.open('../Common/PharmacyReceipt.aspx?LedTnxNo=" + LedTnxNo + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&IsBill=1&Duplicate=0');", true);
                   // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key232324324", "window.open('../Common/GSTPharmacyReceipt.aspx?LedTnxNo=" + LedTnxNo + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&IsBill=1&Duplicate=0');", true);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key232324324", "window.open('../Common/CommonReceipt_pdf.aspx?LedgerTransactionNo=" + LedTnxNo + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&IsBill=1&Duplicate=0&Type=PHY');", true);

                }

            }
            chkPrint.Checked = true;
        }
        else
            lblMsg.Text = "Error Occurred,Please Contact Administrator";
    }

    private void clear()
    {
        ViewState.Remove("StockTransfer");
        txtNarration.Text = "";


        rbtStorToDept.Checked = true;
        txtTransferQty.Text = "";
        ListBox1.SelectedIndex = 0;
        txtName.Text = "";
        txtCRNo.Text = "";
        ucDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        toDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

        grdPatient.DataSource = null;
        grdPatient.DataBind();
        grdItem.DataSource = null;
        grdItem.DataBind();
        grdItemDetails.DataSource = null;
        grdItemDetails.DataBind();

        lblTotalAmount.Text = string.Empty;
        pnlSave.Visible = false;
        ptnDetail.Visible = false;
        pnldetail.Visible = false;
        BindItem();

    }

    private string SaveData()
    {

        //ViewState["TID"].ToString()
        int IsMedClear = Util.GetInt(StockReports.ExecuteScalar("Select IsMedCleared from patient_medical_history where TransactionID='" + ViewState["TID"].ToString() + "'"));//f_ipdadjustment

        if (IsMedClear == 1)
        {
            lblMsg.Text = "PATIENT MEDICAL CLEARANCE HAS BEEN DONE, YOU CAN'T RETURN ITEMS";
            return "0";
        }
        if (ViewState["StockTransfer"] != null)
        {


            DataTable dtItem = (DataTable)ViewState["StockTransfer"];
            string LedTxnID = string.Empty, LedgerTnxNo = string.Empty, TranType = string.Empty, InvoiceNo = string.Empty, ChallanNo = string.Empty, ConID = string.Empty;
            string HSNCode = string.Empty; string GSTType = string.Empty; string isDeal = string.Empty;
            decimal UnitPrice = 0;
            decimal freight = 0;
            decimal Octori = 0;
            decimal RoundOff = 0;
            decimal IGSTPercent = 0;
            decimal CGSTPercent = 0;
            decimal SGSTPercent = 0;
            decimal SpecialDiscPer = 0;
            decimal SpecialDiscAmt = 0;
            decimal ConversionFactor = 1;
            decimal QTY = 0;
            string SalesIDP = string.Empty;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                /////////////////////////---------------------FOR GRN-------------------------------------//////////////

                for (int i = 0; i < grdItemDetails.Rows.Count; i++)
                {

                   decimal Disc = 0;
                    UnitPrice = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblUnitPrice")).Text);
                    Octori = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblOctroi")).Text);

                    freight = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblFreight")).Text);
                    RoundOff = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblRoundOff")).Text);
                  //  InvoiceNo = ((Label)grdItemDetails.Rows[i].FindControl("lblBillNo")).Text;
                  //  ChallanNo = ((Label)grdItemDetails.Rows[i].FindControl("lblChallanNo")).Text;
                  
                    //HSNCode = ((Label)grdItemDetails.Rows[i].FindControl("lblHSNCode")).Text;
                    //IGSTPercent = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblIGSTPercent")).Text);
                    //CGSTPercent = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblCGSTPercent")).Text);
                    //SGSTPercent = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblSGSTPercent")).Text);
                    //SpecialDiscPer = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblSpecialDiscPer")).Text);
                    //ConversionFactor = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblConversionFactor")).Text);
                    //GSTType = ((Label)grdItemDetails.Rows[i].FindControl("lblGSTType")).Text;
                    //isDeal = ((Label)grdItemDetails.Rows[i].FindControl("lblisDeal")).Text;
                    QTY=Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblIssueQty")).Text);
                    ConID = ((Label)grdItemDetails.Rows[i].FindControl("lblStockID")).Text;

                    DataTable StockDetails = StockReports.GetDataTable("SELECT GSTType,isDeal,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,SpecialDiscPer,ConversionFactor,BillNo,ChallanNo,ChallanDate,BillDate,VendorLedgerNo,Unit,OtherCharges,MarkUpPercent,LandingCost,CurrencyCountryID,Currency,CurrencyFactor FROM consignmentdetail WHERE ID=" + Util.GetInt(ConID) + " ");
                    InvoiceNo = StockDetails.Rows[0]["BillNo"].ToString();
                    ChallanNo = StockDetails.Rows[0]["ChallanNo"].ToString();
                    HSNCode = StockDetails.Rows[0]["BillNo"].ToString();
                    IGSTPercent = Util.GetDecimal(StockDetails.Rows[0]["IGSTPercent"].ToString());
                    CGSTPercent = Util.GetDecimal(StockDetails.Rows[0]["CGSTPercent"].ToString());
                    SGSTPercent = Util.GetDecimal(StockDetails.Rows[0]["SGSTPercent"].ToString());
                    SpecialDiscPer = Util.GetDecimal(StockDetails.Rows[0]["SpecialDiscPer"].ToString());
                    ConversionFactor = Util.GetDecimal(StockDetails.Rows[0]["ConversionFactor"].ToString());
                    GSTType = StockDetails.Rows[0]["GSTType"].ToString();
                    isDeal = StockDetails.Rows[0]["isDeal"].ToString();





                    string TransactionType = string.Empty;
                    if (Util.GetString("STO00001") == "STO00001")
                        TransactionType = "PURCHASE";
                    else if (Util.GetString("STO00001") == "STO00002")
                        TransactionType = "NMPURCHASE";

                    if (TransactionType == string.Empty)
                        return "";

                   string GRNNo = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT get_Tran_idPh('" + TransactionType + "','" + ViewState["DeptLedgerNo"].ToString() + "'," + Util.GetInt(Session["CentreID"].ToString()) + ")"));

                   if (string.IsNullOrEmpty(GRNNo))
                   {

                       Tranx.Rollback();
                       Tranx.Dispose();
                       con.Close();
                       con.Dispose();
                       lblMsg.Text = "Record Not Saved";
                       return "0";
                        
                   }
                        


                    Ledger_Transaction objLedTran = new Ledger_Transaction(Tranx);
                    objLedTran.LedgerNoCr = Util.GetString(((Label)grdItemDetails.Rows[i].FindControl("lblVendorLedgerNo")).Text);
                    objLedTran.Hospital_ID = ViewState["HOSPID"].ToString();
                    objLedTran.LedgerNoDr = "STO00001";
                    objLedTran.TypeOfTnx = "PURCHASE";
                    objLedTran.Date = DateTime.Now;
                    objLedTran.AgainstPONo = "";
                    objLedTran.BillNo = GRNNo;
                    objLedTran.GrossAmount = Util.GetDecimal(UnitPrice + freight + Octori + RoundOff);
                    objLedTran.NetAmount = Util.GetDecimal(UnitPrice);
                    objLedTran.IsCancel = 0;
                    objLedTran.CancelReason = "";
                    objLedTran.CancelAgainstLedgerNo = "";
                    objLedTran.CancelDate = Util.GetDateTime(string.Empty);
                    objLedTran.InvoiceNo = InvoiceNo;
                    objLedTran.ChalanNo = ChallanNo;


                    objLedTran.Time = DateTime.Now;
                    objLedTran.Freight = Util.GetDecimal(freight);
                    objLedTran.Octori = Util.GetDecimal(0);
                    //objLedTran.GatePassInWard = GatePassIn;
                    objLedTran.RoundOff = Util.GetDecimal(RoundOff);
                    objLedTran.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    objLedTran.UserID = ViewState["ID"].ToString();
                    objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objLedTran.IpAddress = All_LoadData.IpAddress();
                    objLedTran.OtherCharges = Util.GetDecimal(StockDetails.Rows[0]["OtherCharges"].ToString());
                    LedgerTnxNo = objLedTran.Insert().ToString();

                   

                    if (LedgerTnxNo == string.Empty)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Record Not Saved";
                        return "0";
                    }

                    InvoiceMaster objInvMas = new InvoiceMaster(Tranx);

                    objInvMas.Hospital_ID = ViewState["HOSPID"].ToString();
                    objInvMas.InvoiceNo = InvoiceNo;
                    //objInvMas.InvoiceDate = Util.GetDateTime(InvoiceDate);
                    objInvMas.ChalanNo = ChallanNo;
                    //objInvMas.ChalanDate = Util.GetDateTime(ChalanDate);

                    if (InvoiceNo != string.Empty)
                        objInvMas.IsCompleteInvoice = "YES";
                    else
                        objInvMas.IsCompleteInvoice = "NO";


                    objInvMas.PONumber = "";

                    objInvMas.VenLedgerNo = Util.GetString(((Label)grdItemDetails.Rows[i].FindControl("lblVendorLedgerNo")).Text);
                    objInvMas.LedgerTnxNo = LedgerTnxNo;
                    objInvMas.InvoiceAmount = Util.GetDecimal(objLedTran.GrossAmount);

                    string InvMID = objInvMas.Insert().ToString();

                    if (InvMID == string.Empty)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error";
                        return "0";
                    }

                    Stock objStock = new Stock(Tranx);
                    decimal MRP = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblMRP")).Text);
                    
                    objStock.Hospital_ID = ViewState["HOSPID"].ToString();
                    objStock.ItemID = ((Label)grdItemDetails.Rows[i].FindControl("lblItemID")).Text;
                    objStock.ItemName = ((Label)grdItemDetails.Rows[i].FindControl("lblItemName")).Text;
                    objStock.LedgerTransactionNo = LedgerTnxNo;
                    objStock.BatchNumber = ((Label)grdItemDetails.Rows[i].FindControl("lblBatchNumber")).Text;
                    objStock.UnitPrice = UnitPrice;

                    objStock.MRP = MRP;
                    objStock.MajorMRP = MRP;
                    objStock.IsCountable = 1;
                    objStock.InitialCount = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblIssueQty")).Text);
                    objStock.ReleasedCount = 0;
                    objStock.IsReturn = 0;
                    objStock.LedgerNo = "";  ///  In Case Of Return of Item
                    objStock.MedExpiryDate = Util.GetDateTime(((Label)grdItemDetails.Rows[i].FindControl("lblMedExpDate")).Text); ;
                    objStock.PostDate = DateTime.Now;
                    objStock.StockDate = DateTime.Now;
                    objStock.TypeOfTnx = "Purchase";
                    //objStock.PostDate = Util.GetDateTime(EntryDate + " " + postime);
                    objStock.StoreLedgerNo = "STO00001";
                    objStock.IsPost = 1;
                    objStock.Naration = txtNarration.Text.Trim();
                    objStock.IsFree = 0;
                    objStock.UserID = ViewState["ID"].ToString();
                    objStock.IsBilled = 1;
                    objStock.Reusable = 0;
                    objStock.VenLedgerNo = Util.GetString(StockDetails.Rows[0]["VendorLedgerNo"]);
                    objStock.DiscPer = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblDiscount")).Text);
                    objStock.Rate = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblRate")).Text) / ConversionFactor;
                    if (Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblDiscount")).Text) > 0)
                    {
                        Disc = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblRate")).Text) * Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblDiscount")).Text) * Util.GetDecimal(0.01);
                        Disc = Disc / ConversionFactor;
                    }
                    if (SpecialDiscPer > 0)
                    {
                        SpecialDiscAmt=Util.GetDecimal((Util.GetDecimal(objStock.Rate)-Util.GetDecimal(Disc))*SpecialDiscPer/100);
                    }

                    objStock.DiscAmt = Util.GetDecimal(Disc);

                    decimal taxableAmout = Util.GetDecimal(Util.GetDecimal(objStock.Rate) - Util.GetDecimal(Disc) - Util.GetDecimal(SpecialDiscAmt));

                    objStock.TYPE = ((Label)grdItemDetails.Rows[i].FindControl("lblType")).Text;
                    objStock.SaleTaxPer = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblSaleTaxPer")).Text);
                    objStock.PurTaxPer = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblTaxPer")).Text);
                    objStock.PurTaxAmt = Util.GetDecimal((Util.GetDecimal(UnitPrice) - Disc) * Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblTaxPer")).Text) * Util.GetDecimal(0.01));
                    objStock.ConsignmentID = Util.GetInt(((Label)grdItemDetails.Rows[i].FindControl("lblStockID")).Text);

                    objStock.taxCalculateOn = "RateAD";
                    objStock.isDeal = isDeal;
                    objStock.HSNCode = HSNCode;
                    objStock.GSTType = GSTType;
                    objStock.ConversionFactor = ConversionFactor;
                    objStock.IGSTPercent = IGSTPercent;
                    objStock.IGSTAmtPerUnit = Math.Round(((taxableAmout*objStock.IGSTPercent)/100)/ (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                    objStock.CGSTPercent = CGSTPercent;
                    objStock.CGSTAmtPerUnit = Math.Round(((taxableAmout * objStock.CGSTPercent) / 100) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                    objStock.SGSTPercent = SGSTPercent;
                    objStock.SGSTAmtPerUnit = Math.Round(((taxableAmout * objStock.SGSTPercent) / 100) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);

                    //Special Discount Work
                    objStock.SpecialDiscPer = SpecialDiscPer;
                    objStock.SpecialDiscAmt = SpecialDiscAmt;

                    objStock.Unit = Util.GetString(StockDetails.Rows[0]["Unit"]);
                    objStock.DeptLedgerNo = Session["DeptLedgerNo"].ToString();
                    objStock.MajorUnit = Util.GetString(StockDetails.Rows[0]["Unit"]);
                    objStock.MinorUnit = Util.GetString(StockDetails.Rows[0]["Unit"]);
                    objStock.InvoiceNo = InvoiceNo;
                    objStock.InvoiceDate = Util.GetDateTime(StockDetails.Rows[0]["BillDate"]);
                    objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objStock.IpAddress = All_LoadData.IpAddress();
                    objStock.IsExpirable = 1;
                    objStock.ExciseAmt = Util.GetDecimal("0");
                    objStock.ExcisePer = Util.GetDecimal("0");
                    objStock.taxCalculateOn = "RateAD";
                    objStock.ChalanNo = Util.GetString(ChallanNo);
                    objStock.ChalanDate = Util.GetDateTime(StockDetails.Rows[0]["ChallanDate"]);
                    objStock.InvoiceAmount = objLedTran.NetAmount;
                    objStock.OtherCharges = Util.GetDecimal(StockDetails.Rows[0]["OtherCharges"]) / Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblIssueQty")).Text);
                    objStock.MarkUpPercent = Util.GetDecimal(StockDetails.Rows[0]["MarkUpPercent"]);
                    objStock.LandingCost = UnitPrice;
                    objStock.CurrencyCountryID = Util.GetInt(StockDetails.Rows[0]["CurrencyCountryID"]);
                    objStock.Currency = Util.GetString(StockDetails.Rows[0]["Currency"]);
                    objStock.CurrencyFactor = Util.GetDecimal(StockDetails.Rows[0]["CurrencyFactor"]);

                    if (((Label)grdItemDetails.Rows[i].FindControl("lblSubCategory")).Text.Trim() != "")
                        objStock.SubCategoryID = ((Label)grdItemDetails.Rows[i].FindControl("lblSubCategory")).Text;
                    else
                        objStock.SubCategoryID = StockReports.ExecuteScalar("Select SubCategoryID from f_itemmaster where itemid='" + ((Label)grdItemDetails.Rows[i].FindControl("lblItemID")).Text + "'");


                    if (objStock.SaleTaxPer > 0)
                        objStock.SaleTaxAmt = Math.Round((Util.GetDecimal((objStock.MRP * 100) / (100 + objStock.SaleTaxPer)) * objStock.SaleTaxPer / 100) * Util.GetDecimal(objStock.InitialCount), 4);
                    else
                        objStock.SaleTaxAmt = 0;


                    string StockID = objStock.Insert().ToString();

                    if (StockID == string.Empty)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error";
                        return "0";
                    }

                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(Tranx);

                    objLTDetail.Hospital_Id = ViewState["HOSPID"].ToString();
                    objLTDetail.LedgerTransactionNo = LedgerTnxNo;
                    objLTDetail.ItemID = ((Label)grdItemDetails.Rows[i].FindControl("lblItemID")).Text;

                    if (((Label)grdItemDetails.Rows[i].FindControl("lblSubCategory")).Text.Trim() != "")
                        objLTDetail.SubCategoryID = ((Label)grdItemDetails.Rows[i].FindControl("lblSubCategory")).Text;
                    else
                        objLTDetail.SubCategoryID = StockReports.ExecuteScalar("Select SubCategoryID from f_itemmaster where itemid='" + ((Label)grdItemDetails.Rows[i].FindControl("lblItemID")).Text + "'");

                    //objLTDetail.Rate = UnitPrice;
                    objLTDetail.Rate = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblRate")).Text);
                    objLTDetail.Quantity = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblIssueQty")).Text);
                    objLTDetail.StockID = StockID;
                    objLTDetail.ItemName = ((Label)grdItemDetails.Rows[i].FindControl("lblItemName")).Text;
                    objLTDetail.EntryDate = DateTime.Now;
                    objLTDetail.UserID = ViewState["ID"].ToString();

                    objLTDetail.Type_ID = ((Label)grdItemDetails.Rows[i].FindControl("lblType")).Text;
                    objLTDetail.ToBeBilled = 1;



                    //if (((Label)gr.FindControl("lblTAX")).Text != "" && Util.GetDecimal(((Label)gr.FindControl("lblTAX")).Text) > 0)
                    if (Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblTaxPer")).Text) > 0)
                        objLTDetail.IsTaxable = "YES";
                    else
                        objLTDetail.IsTaxable = "NO";

                    objLTDetail.DiscountPercentage = 0;// Util.GetDecimal(rowItem["Discount"]);

                    objLTDetail.Amount = Util.GetDecimal(UnitPrice * Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblIssueQty")).Text));
                    objLTDetail.IsFree = 0;// Util.GetInt(rowItem["isfree"]);
                    objLTDetail.HSNCode = HSNCode;
                    objLTDetail.IGSTPercent = IGSTPercent;
                    objLTDetail.IGSTAmt = Math.Round(((taxableAmout * objLTDetail.IGSTPercent) / 100), 4, MidpointRounding.AwayFromZero);
                    objLTDetail.CGSTPercent = CGSTPercent;
                    objLTDetail.CGSTAmt = Math.Round(((taxableAmout * objLTDetail.CGSTPercent) / 100), 4, MidpointRounding.AwayFromZero);
                    objLTDetail.SGSTPercent = SGSTPercent;
                    objLTDetail.SGSTAmt = Math.Round(((taxableAmout * objLTDetail.SGSTPercent) / 100), 4, MidpointRounding.AwayFromZero); 
                    objLTDetail.SpecialDiscPer = SpecialDiscPer;
                    objLTDetail.SpecialDiscAmt = SpecialDiscAmt;
                    
                    objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objLTDetail.RoleID = Util.GetInt(Session["RoleID"].ToString());
                    objLTDetail.medExpiryDate = Util.GetDateTime(((Label)grdItemDetails.Rows[i].FindControl("lblMedExpDate")).Text); 
                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetail.NetItemAmt = Util.GetDecimal(UnitPrice * Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblIssueQty")).Text));
                    objLTDetail.TotalDiscAmt = 0;
                    objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;
                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(objLTDetail.SubCategoryID, con));
                    objLTDetail.Type = "S";
                    objLTDetail.BatchNumber = ((Label)grdItemDetails.Rows[i].FindControl("lblBatchNumber")).Text;
                    objLTDetail.StoreLedgerNo = "STO00001";
                    objLTDetail.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    objLTDetail.PurTaxPer = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblTaxPer")).Text);
                    objLTDetail.PurTaxAmt = Util.GetDecimal((Util.GetDecimal(UnitPrice) - Disc) * Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblTaxPer")).Text) * Util.GetDecimal(0.01));
                    objLTDetail.unitPrice = UnitPrice;
                    objLTDetail.OtherCharges = Util.GetDecimal(StockDetails.Rows[0]["OtherCharges"]);
                    objLTDetail.MarkUpPercent = Util.GetDecimal(StockDetails.Rows[0]["MarkUpPercent"]);

                    string LdgTrnxDtlID = objLTDetail.Insert().ToString();

                    if (LdgTrnxDtlID == string.Empty)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error";
                        return "0";
                    }



                    ExcuteCMD excuteCMD = new ExcuteCMD();
                    excuteCMD.DML(Tranx, "UPDATE  f_stock s SET s.LedgerTnxNo=@ledgerTnxNo WHERE s.StockID=@stockID", CommandType.Text, new
                    {
                        ledgerTnxNo = LdgTrnxDtlID,
                        stockID = StockID
                    });


                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        string IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(LedgerTnxNo), 1, 18, 0, Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            lblMsg.Text = "Error In Finance Integration in GRN";
                            return "0";
                        }
                    }


                    //if (((Label)grdItemDetails.Rows[i].FindControl("lblTaxID")).Text != "" && Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblTaxPer")).Text) > 0)
                    //{
                    //    TaxChargedList objTCharged = new TaxChargedList(Tranx);

                    //    objTCharged.LedgerTransactionNo = LedgerTnxNo;
                    //    objTCharged.Hospital_ID = ViewState["HOSPID"].ToString();
                    //    objTCharged.TaxID = ((Label)grdItemDetails.Rows[i].FindControl("lblTaxID")).Text;
                    //    objTCharged.Percentage = Util.GetDecimal(((Label)grdItemDetails.Rows[i].FindControl("lblTaxPer")).Text);
                    //    objTCharged.ItemID = objStock.ItemID;
                    //    objTCharged.StockID = StockID;

                    //    int TaxChrgID = objTCharged.Insert();

                    //    if (TaxChrgID == 0)
                    //    {
                    //        Tranx.Rollback();
                    //        Tranx.Dispose();
                    //        con.Close();
                    //        con.Dispose();
                    //        lblMsg.Text = "Record Not Saved";
                    //        return "0";
                    //    }
                    //}

                    //int i = 0;
                    string sql = "select if(InititalCount < (ReleasedCount+" + objStock.InitialCount + "),0,1)CHK from consignmentdetail WHERE ID='" + ((Label)grdItemDetails.Rows[i].FindControl("lblStockID")).Text + "'";
                    if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }

                    string Query = "UPDATE consignmentdetail SET ReleasedCount=ReleasedCount+" + objStock.InitialCount + " WHERE ID='" + ((Label)grdItemDetails.Rows[i].FindControl("lblStockID")).Text + "'";
                    MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, Query);

                    ScriptManager.RegisterStartupScript(this, this.GetType(), LedgerTnxNo, "alert('GRN No:'+'" + LedgerTnxNo + "');", true);
                    string stokIDD = string.Empty;
                    //if (((Label)grdItemDetails.Rows[i].FindControl("lblDeptLegerNo")).Text != Session["DeptLedgerNo"].ToString())
                    //{
                    //    /////////////////////////---------------------FOR Department Issue-------------------------------------//////////////

                    //    //code for getting sales number
                    //    //string strSales = "select max(salesno) from f_salesdetails where TrasactionTypeID = 1";
                    //    int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('1','" + AllGlobalFunction.MedicalStoreID + "','" + Session["CentreID"].ToString() + "')"));
                        
                    //    //SalesNo += 1;
                    //    string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + objStock.InitialCount + " where StockID = '" + StockID + "'";
                    //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);

                    //    Stock objStockD = new Stock(Tranx);
                    //    objStockD.Hospital_ID = "HOS/070920/00001";
                    //    objStockD.InitialCount = objStock.InitialCount;
                    //    objStockD.BatchNumber = objStock.BatchNumber;
                    //    objStockD.ItemID = objStock.ItemID;
                    //    objStockD.ItemName = objStock.ItemName;

                    //    objStockD.DeptLedgerNo = ((Label)grdItemDetails.Rows[i].FindControl("lblDeptLegerNo")).Text;
                    //    objStockD.IsFree = 0;
                    //    objStockD.IsPost = 1;
                    //    objStockD.PostDate = DateTime.Now;
                    //    objStockD.MRP = objStock.MRP;
                    //    objStockD.StockDate = DateTime.Now;
                    //    objStockD.Unit = objStock.Unit;
                    //    objStockD.SubCategoryID = objStock.SubCategoryID;
                    //    objStockD.UnitPrice = objStock.UnitPrice;
                    //    objStockD.IsCountable = 1;
                    //    objStockD.IsReturn = 0;
                    //    objStockD.FromDept = Session["DeptLedgerNo"].ToString();
                    //    objStockD.FromStockID = StockID;
                    //    objStockD.IndentNo = "";
                    //    objStockD.MedExpiryDate = objStock.MedExpiryDate;
                    //    objStockD.RejectQty = objStock.RejectQty;
                    //    objStockD.StoreLedgerNo = "STO00001";
                    //    objStockD.UserID = ViewState["ID"].ToString();
                    //    objStockD.PostUserID = ViewState["ID"].ToString();
                    //    objStockD.IsBilled = 1;
                    //    objStockD.Reusable = 0;
                    //    objStockD.DiscPer = objStock.DiscPer;
                    //    objStockD.Rate = objStock.Rate;
                    //    objStockD.DiscAmt = objStock.DiscAmt;
                    //    objStockD.TYPE = objStock.TYPE;
                    //    objStockD.SaleTaxPer = objStock.SaleTaxPer;
                    //    objStockD.SaleTaxAmt = objStock.SaleTaxAmt;
                    //    objStockD.PurTaxPer = objStock.PurTaxPer;
                    //    objStockD.PurTaxAmt = objStock.PurTaxAmt;
                    //    objStockD.ConversionFactor = objStock.ConversionFactor;
                    //    objStockD.MajorMRP = objStock.MajorMRP;
                    //    objStockD.HSNCode = objStock.HSNCode;
                    //    objStockD.GSTType = objStock.GSTType;
                    //    objStockD.IGSTPercent = objStock.IGSTPercent;
                    //    objStockD.IGSTAmtPerUnit = objStock.IGSTAmtPerUnit;
                    //    objStockD.CGSTPercent = objStock.CGSTPercent;
                    //    objStockD.CGSTAmtPerUnit = objStock.CGSTAmtPerUnit;
                    //    objStockD.SGSTPercent = objStock.SGSTPercent;
                    //    objStockD.SGSTAmtPerUnit = objStock.SGSTAmtPerUnit;
                    //    objStockD.SpecialDiscPer = objStock.SpecialDiscPer;
                    //    objStockD.SpecialDiscAmt = objStock.SpecialDiscAmt;
                    //    objStockD.isDeal = objStock.isDeal;
                    //    objStockD.taxCalculateOn = objStock.taxCalculateOn;

                    //    objStockD.Unit = objStock.Unit;
                    //    objStockD.MajorUnit = objStock.MajorUnit;
                    //    objStockD.MinorUnit = objStock.MinorUnit;


                    //    objStockD.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    //    objStockD.IpAddress = All_LoadData.IpAddress();
                    //    objStockD.IsExpirable = 1;
                    //    objStockD.ExciseAmt = Util.GetDecimal("0");
                    //    objStockD.ExcisePer = Util.GetDecimal("0");
                    //    objStockD.OtherCharges = objStock.OtherCharges;
                    //    objStockD.MarkUpPercent = objStock.MarkUpPercent;
                    //    objStockD.LandingCost = objStock.LandingCost;
                    //    objStockD.CurrencyCountryID = objStock.CurrencyCountryID;
                    //    objStockD.Currency = objStock.Currency;
                    //    objStockD.CurrencyFactor = objStock.CurrencyFactor;

                    //    stokIDD = objStockD.Insert();


                    //    Sales_Details ObjSales = new Sales_Details(Tranx);
                    //    ObjSales.Hospital_ID = "HOS/070920/00001";
                    //    ObjSales.LedgerNumber = ((Label)grdItemDetails.Rows[i].FindControl("lblDeptLegerNo")).Text;
                    //    ObjSales.DepartmentID = "STO00001";
                    //    ObjSales.ItemID = objStock.ItemID;
                    //    ObjSales.StockID = StockID;

                    //    ObjSales.SoldUnits = objStock.InitialCount;
                    //    ObjSales.PerUnitBuyPrice = objStock.UnitPrice;
                    //    ObjSales.PerUnitSellingPrice = objStock.MRP;

                    //    ObjSales.Date = DateTime.Now;
                    //    ObjSales.Time = DateTime.Now;
                    //    ObjSales.IsReturn = 0;
                    //    ObjSales.LedgerTransactionNo = "";
                    //    ObjSales.TrasactionTypeID = 1;
                    //    ObjSales.IsService = "NO";
                    //    ObjSales.IndentNo = "";
                    //    ObjSales.SalesNo = SalesNo;
                    //    ObjSales.DeptLedgerNo = Session["DeptLedgerNo"].ToString();
                    //    ObjSales.UserID = ViewState["ID"].ToString();

                    //    decimal taxableAmt = (Util.GetDecimal(ObjSales.PerUnitSellingPrice) * 100 * Util.GetDecimal(objStock.InitialCount) / (100 + IGSTPercent + CGSTPercent + SGSTPercent));
                    //    //decimal nonTaxableRate = (Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                    //    // decimal discount = Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * objLTDetail.DiscountPercentage / 100;
                    //    // decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

                    //    decimal IGSTTaxAmount = Math.Round(taxableAmt * IGSTPercent / 100, 4, MidpointRounding.AwayFromZero);
                    //    decimal CGSTTaxAmount = Math.Round(taxableAmt * CGSTPercent / 100, 4, MidpointRounding.AwayFromZero);
                    //    decimal SGSTTaxAmount = Math.Round(taxableAmt * SGSTPercent / 100, 4, MidpointRounding.AwayFromZero);

                    //    ObjSales.IGSTPercent = IGSTPercent;
                    //    ObjSales.IGSTAmt = IGSTTaxAmount;
                    //    ObjSales.CGSTPercent = CGSTPercent;
                    //    ObjSales.CGSTAmt = CGSTTaxAmount;
                    //    ObjSales.SGSTPercent = SGSTPercent;
                    //    ObjSales.SGSTAmt = SGSTTaxAmount;
                    //    ObjSales.HSNCode = objStock.HSNCode;
                    //    ObjSales.GSTType = objStock.GSTType;

                    //    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    //    ObjSales.PurTaxAmt = objStock.PurTaxAmt;
                    //    ObjSales.PurTaxPer = objStock.PurTaxPer;
                    //    ObjSales.TaxAmt = objStock.SaleTaxAmt;
                    //    ObjSales.TaxPercent = objStock.SaleTaxPer;

                    //    string SalesID = ObjSales.Insert();

                    //    if (SalesID == string.Empty)
                    //    {
                    //        Tranx.Rollback();
                    //        Tranx.Dispose();
                    //        con.Close();
                    //        con.Dispose();
                    //        return "0";
                    //    }

                    //    if (Resources.Resource.AllowFiananceIntegration == "1")
                    //    {
                    //        string IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(0, 0, 1, SalesNo, Tranx));
                    //        if (IsIntegrated == "0")
                    //        {
                    //            Tranx.Rollback();
                    //            lblMsg.Text = "Error In Finance Integration in Dept Issue";
                    //            return "0";
                    //        }
                    //    }

                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), SalesID, "alert('Department Issue No:'+'" + SalesID + "');", true);
                    //}
                    /////////////////////////---------------------FOR Patient Issue-------------------------------------//////////////


                    //string strSales1 = "select max(salesno) from f_salesdetails where TrasactionTypeID = '3'";
                    int SalesNoP = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('1','" + AllGlobalFunction.MedicalStoreID + "','" + Session["CentreID"].ToString() + "')"));
                    string BillNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select get_billno_store('"+ ViewState["DeptLedgerNo"].ToString() +"','" + Session["CentreID"].ToString() + "')").ToString();
                    //SalesNoP += 1;

                    string str = "select LedgerNumber from f_ledgermaster where LedgerUserID='" + lblPatientID.Text.Trim() + "'";
                    string LedgerNumber = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, str));
                    ViewState.Add("LedgerNumber", LedgerNumber);

                    //Insert into f_LedgerTransaction Single row effect
                    Ledger_Transaction objLedTranP = new Ledger_Transaction(Tranx);
                    objLedTranP.LedgerNoCr = LedgerNumber;
                    objLedTranP.LedgerNoDr = "STO00001";
                    objLedTranP.Hospital_ID = "HOS/070920/00001";
                    objLedTranP.GrossAmount = Util.GetDecimal(objStock.MRP);
                    objLedTranP.NetAmount = Util.GetDecimal(objStock.MRP);
                    objLedTranP.TransactionID = ViewState["TID"].ToString();
                    objLedTranP.TypeOfTnx = "Sales";
                    objLedTranP.PanelID = Util.GetInt(lblPanelID.Text.Trim());
                    objLedTranP.PatientID = lblPatientID.Text.Trim();
                    objLedTranP.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
                    objLedTranP.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
                    //objLedTranP.IndentNo = txtIndentNo.Text.Trim();
                    objLedTranP.TransactionType_ID = 3;
                    objLedTranP.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    objLedTranP.UserID = ViewState["ID"].ToString();
                    objLedTranP.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objLedTranP.BillNo = BillNo;
                    objLedTranP.BillDate = Util.GetDateTime(DateTime.Now.ToShortDateString());
                    objLedTranP.IpAddress = All_LoadData.IpAddress();
                    objLedTranP.PatientType = lblPatientType.Text.Trim();
                    objLedTranP.OtherCharges = objLedTran.OtherCharges;

                    LedTxnID = objLedTranP.Insert();

                    if (LedTxnID == string.Empty)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }



                    LedgerTnxDetail objLTDetailP = new LedgerTnxDetail(Tranx);
                    objLTDetailP.Hospital_Id = "HOS/070920/00001";
                    objLTDetailP.LedgerTransactionNo = LedTxnID;
                    objLTDetailP.ItemID = objStock.ItemID;
                    objLTDetailP.SubCategoryID = objStock.SubCategoryID;
                    objLTDetailP.TransactionID = ViewState["TID"].ToString();
                    objLTDetailP.Rate = Util.GetDecimal(objStock.MRP);
                    objLTDetailP.Quantity = Util.GetDecimal(objStock.InitialCount);
                    objLTDetailP.StockID = StockID;
                    objLTDetailP.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    objLTDetailP.ConfigID = 11;
                    objLTDetailP.IsVerified = 1;
                    objLTDetailP.Amount = Util.GetDecimal(objStock.MRP * objStock.InitialCount);
                    objLTDetailP.ItemName = objStock.ItemName;
                    objLTDetailP.UserID = Convert.ToString(ViewState["ID"]); ;
                    objLTDetailP.EntryDate = DateTime.Now;
                    objLTDetailP.Type_ID = ((Label)grdItemDetails.Rows[i].FindControl("lblType")).Text;
                    objLTDetailP.ToBeBilled = 1;
                    objLTDetailP.HSNCode=HSNCode;
                    objLTDetailP.GSTType=GSTType;
                    objLTDetailP.IGSTPercent=IGSTPercent;
                    objLTDetailP.CGSTPercent=CGSTPercent;
                    objLTDetailP.SGSTPercent=SGSTPercent;
                    objLTDetailP.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetailP.RoleID = Util.GetInt(Session["RoleID"].ToString());
                    objLTDetailP.IpAddress = All_LoadData.IpAddress();
                    objLTDetailP.Type = "I";
                    objLTDetailP.IPDCaseTypeID = lblIPDCaseType_ID.Text;
                    objLTDetailP.RoomID = lblRoom_ID.Text;
                    decimal taxableAmtP =((Util.GetDecimal(objLTDetailP.Rate) * 100 * Util.GetDecimal(objStock.InitialCount)) / (100 + IGSTPercent + CGSTPercent + SGSTPercent));
                        //decimal nonTaxableRate = (Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                        // decimal discount = Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * objLTDetail.DiscountPercentage / 100;
                        // decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);
                        decimal IGSTTaxAmountP = Math.Round(taxableAmtP * IGSTPercent / 100, 4, MidpointRounding.AwayFromZero);
                        decimal CGSTTaxAmountP = Math.Round(taxableAmtP * CGSTPercent / 100, 4, MidpointRounding.AwayFromZero);
                        decimal SGSTTaxAmountP = Math.Round(taxableAmtP * SGSTPercent / 100, 4, MidpointRounding.AwayFromZero);

                    objLTDetailP.IGSTAmt=IGSTTaxAmountP;
                    objLTDetailP.CGSTAmt=CGSTTaxAmountP;
                    objLTDetailP.SGSTAmt=SGSTTaxAmountP;


                    objLTDetailP.SpecialDiscPer = objLTDetail.SpecialDiscPer;
                    objLTDetailP.SpecialDiscAmt = objLTDetail.SpecialDiscAmt;

                    objLTDetailP.CentreID = objLTDetail.CentreID;
                    objLTDetailP.medExpiryDate = objLTDetail.medExpiryDate;
                    objLTDetailP.NetItemAmt = Util.GetDecimal(objStock.MRP * objStock.InitialCount);
                    objLTDetailP.TotalDiscAmt = objLTDetail.TotalDiscAmt;
                    objLTDetailP.BatchNumber = objLTDetail.BatchNumber;
                    objLTDetailP.StoreLedgerNo = objLTDetail.StoreLedgerNo;
                    objLTDetailP.DeptLedgerNo = objLTDetail.DeptLedgerNo;
                    objLTDetailP.PurTaxPer = objLTDetail.PurTaxPer;
                    objLTDetailP.PurTaxAmt = objLTDetail.PurTaxAmt;
                    objLTDetailP.unitPrice = objLTDetail.unitPrice;

                    objLTDetailP.OtherCharges = objLTDetail.OtherCharges;
                    objLTDetailP.MarkUpPercent = objLTDetail.MarkUpPercent;
                    objLTDetailP.SubCategoryID = objLTDetail.SubCategoryID;
                    objLTDetailP.IsTaxable = objLTDetail.IsTaxable;
                    int ID = objLTDetailP.Insert();

                    if (ID == 0)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }


                    Sales_Details ObjSalesP = new Sales_Details(Tranx);
                    ObjSalesP.Hospital_ID = "HOS/070920/00001";
                    ObjSalesP.LedgerNumber = ViewState["LedgerNumber"].ToString();
                    ObjSalesP.DepartmentID = "STO00001";
                    ObjSalesP.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    //if (stokIDD == string.Empty)
                    //{
                        ObjSalesP.StockID = StockID;
                    //}
                    //else
                    //{
                    //    ObjSalesP.StockID = stokIDD;
                    //}

                    ObjSalesP.SoldUnits = Util.GetDecimal(dtItem.Rows[i]["IssueQty"]);
                    ObjSalesP.PerUnitBuyPrice = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]);
                    ObjSalesP.PerUnitSellingPrice = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
                    ObjSalesP.Date = DateTime.Now;
                    ObjSalesP.Time = DateTime.Now;
                    ObjSalesP.IsReturn = 0;
                    ObjSalesP.LedgerTransactionNo = LedTxnID;
                    ObjSalesP.UserID = ViewState["ID"].ToString();

                    ObjSalesP.TrasactionTypeID = 3;

                    ObjSalesP.IsService = "NO";
                    //ObjSales.IndentNo = txtIndentNo.Text.Trim();
                    ObjSalesP.Naration = txtNarration.Text.Trim();
                    ObjSalesP.SalesNo = SalesNoP;
                    ObjSalesP.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    ObjSalesP.BillNoforGP = BillNo;
                    ObjSalesP.PatientID = lblPatientID.Text;
                    //ObjSalesP.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    ObjSalesP.IpAddress = All_LoadData.IpAddress();
                    ObjSalesP.LedgerTnxNo = ID;
                    ObjSalesP.Type_ID = objLTDetailP.Type_ID;
                    ObjSalesP.TransactionID = ViewState["TID"].ToString();
                    ObjSalesP.HSNCode=objLTDetailP.HSNCode;
                    ObjSalesP.GSTType=objLTDetailP.GSTType;
                    ObjSalesP.IGSTPercent=IGSTPercent;
                    ObjSalesP.IGSTAmt=IGSTTaxAmountP;
                    ObjSalesP.CGSTPercent=CGSTPercent;
                    ObjSalesP.CGSTAmt=CGSTTaxAmountP;
                    ObjSalesP.SGSTPercent=SGSTPercent;
                    ObjSalesP.SGSTAmt=SGSTTaxAmountP;
                    ObjSalesP.LedgerTransactionNo = LedTxnID;
                    ObjSalesP.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    ObjSalesP.PurTaxAmt = objStock.PurTaxAmt;
                    ObjSalesP.PurTaxPer = objStock.PurTaxPer;
                    ObjSalesP.TaxAmt = objStock.SaleTaxAmt;
                    ObjSalesP.TaxPercent = objStock.SaleTaxPer;

                    SalesIDP = ObjSalesP.Insert();
                    if (SalesIDP == string.Empty)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }

                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        string IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(LedTxnID), 0, 3, SalesNoP, Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            lblMsg.Text = "Error In Finance Integration in Patient Stock Issue";
                            return "0";
                        }

                        IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(Util.GetInt(LedTxnID), "", "R", Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            lblMsg.Text = "Error In Finance Integration in Patient Issue Issue";
                            return "0";
                        }

                    }



                    //if (((Label)grdItemDetails.Rows[i].FindControl("lblDeptLegerNo")).Text == "LSHHI17")
                   // {
                        str = "update f_stock set ReleasedCount = ReleasedCount + " + objStock.InitialCount + " where StockID = '" + StockID + "'";
                    //}
                    //else
                    //{
                      //  str = "update f_stock set ReleasedCount = ReleasedCount + " + objStock.InitialCount + " where StockID = '" + stokIDD + "'";
                    //}
                    int flag = Util.GetInt(MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str));

                    if (flag == 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), SalesIDP, "alert('Patient Issue No:'+'" + SalesIDP + "');", true);





                }


                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                return LedTxnID;
            }
            catch (Exception ex)
            {
                lblMsg.Text = ex.Message;
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                return "0";
            }


        }
        else
        {
            return "0";
        }
    }

    #endregion Stock Transfer

    private DataTable PrintItemIssueReport(string saleno)
    {
        string str = " select IndentNo,(select TypeName from f_itemmaster where ItemID=sale.ItemID)as ItemName, " +
        "    (select LedgerName from f_ledgermaster where LedgerNumber=sale.LedgerNumber)issuedepart, " +
        "   (select LedgerName from f_ledgermaster where LedgerNumber=sale.DepartmentID)Store, " +
        "(select UnitType from f_itemmaster where ItemID=sale.ItemID)as UnitType," +
        "   SalesID,SoldUnits,Date_format(Date,'%d %b %y')Date,TIME_FORMAT(Time,'%r')Time,Naration,salesno from f_salesdetails sale where salesno=" + saleno + " ";
        return StockReports.GetDataTable(str);
    }
}