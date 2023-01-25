using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Linq;

public partial class Design_Store_PatientReturnItem : System.Web.UI.Page
{
    #region Event Handling

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
                        txtBar.Focus();
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
            txtBar.Text = string.Empty;
            txtBar.Focus();
            btnAddItem.Visible = false;
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }

    protected void btnSearchItem_Click(object sender, EventArgs e)
    {
        ReturnItem();
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

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        if (ViewState["dt"] != null)
        {
            DataTable dt = (DataTable)ViewState["dt"];
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {

        string CRNO = (GridView1.SelectedRow.FindControl("lblTID") as Label).Text;
        ViewState["TID"] = CRNO;
        pnlPatient.Visible = true;
        BindPatientDetails(CRNO);
        BindItem(CRNO);
        grdItems.DataSource = null;
        grdItems.DataBind();
        grdReturnItem.DataSource = null;
        grdReturnItem.DataBind();
        txtBar.Focus();
        this.Controls.Add(new LiteralControl("<script type='text/javascript'>getIndentCount();</script>"));
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int CentreID = Util.GetInt(Session["CentreID"].ToString()); if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
               // return;

                pnlPatient.Visible = false;
                txtPName.Focus();
                txtBar.Attributes.Add("onKeyPress", "doClick('" + btnBar.ClientID + "',event)");
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                chkPrint.Checked = true;


                txtFDSearch.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtTDSearch.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                pnlSearch.Visible = false;
                ViewState["ID"] = Session["ID"].ToString();
            }
            else
            {
                pnlPatient.Visible = false;
                txtPName.Focus();
                txtBar.Attributes.Add("onKeyPress", "doClick('" + btnBar.ClientID + "',event)");
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                chkPrint.Checked = true;


                txtFDSearch.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtTDSearch.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                pnlSearch.Visible = false;
                ViewState["ID"] = Session["ID"].ToString();
            }
        }
        //txtFDSearch.Attributes.Add("readOnly", "true");
        //txtTDSearch.Attributes.Add("readOnly", "true");
    }

    #endregion Event Handling

    #region Bind Item

    private void BindItem(string CRNO)
    {
        // StringBuilder sb = new StringBuilder();
        // sb.Append(" SELECT t3.ItemId,IM.TypeName,IM.Type_ID,t3.StockId FROM (SELECT t1.itemid,(t1.SoldQty - IF(t2.RetQty IS NULL,0,t2.RetQty ) )  ");
        // sb.Append(" AS inHandUnits,t1.Stockid FROM (SELECT ltd.ItemID,ltd.StockID,SUM(ltd.Quantity)SoldQty  ");
        // sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionNo = ltd.ledgertransactionno ");
        // sb.Append(" WHERE ltd.TransactionID='" + CRNO + "' AND lt.transactiontypeid IN ('3','4') AND lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and lt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " GROUP BY ltd.itemid  ");
        // sb.Append(" )t1 LEFT JOIN (SELECT ltd.ItemID,ltd.StockID,SUM(ltd.Quantity)RetQty ");
        //  sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionNo = ltd.ledgertransactionno ");
        // sb.Append(" WHERE ltd.TransactionID='" + CRNO + "' AND lt.transactiontypeid IN ('5','6') AND lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and lt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " GROUP BY ltd.itemid ");
        // sb.Append(" )t2 ON t1.ItemID=t2.ItemID)t3 INNER JOIN f_itemmaster IM ON t3.itemid=IM.ItemID  ");
        // sb.Append(" WHERE t3.inHandUnits>0 ORDER BY IM.TypeName ");

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t3.ItemId,IM.TypeName,IM.Type_ID,t3.StockId FROM (SELECT t1.itemid,(t1.SoldQty - IF(t2.RetQty IS NULL,0,t2.RetQty ) )  ");
        sb.Append(" AS inHandUnits,t1.Stockid FROM (SELECT ltd.ItemID,ltd.StockID,SUM(ltd.Quantity)SoldQty  ");
        sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_salesdetails sd ON sd.LedgerTnxNo=ltd.ID INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionNo = ltd.ledgertransactionno ");
        sb.Append(" WHERE ltd.TransactionID='" + CRNO + "' AND sd.TrasactionTypeID IN ('3') AND sd.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and lt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " GROUP BY ltd.itemid  ");
        sb.Append(" )t1 LEFT JOIN (SELECT ltd.ItemID,ltd.StockID,SUM(ltd.Quantity)RetQty ");
        sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_salesdetails sd ON sd.LedgerTnxNo=ltd.ID INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionNo = ltd.ledgertransactionno ");
        sb.Append(" WHERE ltd.TransactionID='" + CRNO + "' AND sd.TrasactionTypeID IN ('5') AND sd.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and lt.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " GROUP BY ltd.itemid ");
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



        return dt;
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
        sb.Append(" ,issue.HSNCode,issue.IGSTPercent,issue.IGSTAmt,issue.SGSTPercent,issue.SGSTAmt,issue.CGSTPercent,issue.CGSTAmt,issue.GSTType,issue.PurTaxPer,issue.IsPackage,issue.PackageID ");
        //
        sb.Append(" from (Select S.ItemName,ltd.Type_ID,ltd.ServiceItemID,ltd.ToBeBilled,ltd.IsVerified, ltd.IsPackage,ltd.PackageID,S.UnitPrice,S.SubCategoryID,S.BatchNumber, S.MedExpiryDate,ltd.isExpirable,SD.StockID,SD.DepartmentID,SD.IndentNo,Sd.ItemID, SD.TrasactionTypeID,SD.PerUnitSellingPrice AS MRP,SD.LedgerNumber,Date_Format(SD.Date,'%d-%b-%y')Date,    sum(SD.SoldUnits) IssueUnits,LM.LedgerName, (SELECT SUM(Qty) FROM cpoe_medication_record WHERE indentno=sd.IndentNo AND itemID=ltd.ItemID)NurUsed,SD.TaxPercent  ");
        //GST Changes
        sb.Append(" ,IFNULL(SD.HSNCode,'')HSNCode,SD.IGSTPercent,SD.IGSTAmt,SD.SGSTPercent,SD.SGSTAmt,SD.CGSTPercent,SD.CGSTAmt,IFNULL(SD.GSTType,'')GSTType,sd.PurTaxPer ");
        //
        sb.Append(" from f_stock S inner join f_salesdetails SD on SD.StockID = S.StockID   ");
        sb.Append(" inner join f_ledgermaster LM on SD.DeptLedgerNo = LM.LedgerNumber INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo AND ltd.StockID=sd.StockID   ");
        sb.Append(" where ltd.TransactionID = '" + lblTransactionNo.Text.Trim() + "' and Sd.TrasactionTypeID in('3','4') and sd.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "  ");
        sb.Append(" and SD.ItemID='" + ddlItem.SelectedValue + "'  and S.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'  group by SD.StockID,Sd.TrasactionTypeID ) issue   ");
        sb.Append(" left outer join (Select Sd.StockID,sum(Sd.SoldUnits) as RtnQty ,Sd.ItemID from f_salesdetails SD  ");
        sb.Append(" inner join f_stock S on SD.StockID = S.StockID INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo AND ltd.StockID=sd.StockID ");
        sb.Append(" where ltd.TransactionID = '" + lblTransactionNo.Text.Trim() + "' and  Sd.TrasactionTypeID in ('5','6')  ");
        sb.Append(" and SD.ItemID='" + ddlItem.SelectedValue + "'  and S.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and sd.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " group by Sd.StockID,Sd.TrasactionTypeID ) ptnRtn  ");
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

    private void Search()
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT ip.TransactionID,concat(pm.Title,' ',pm.Pname)PNAME,concat(pm.House_No,' ',pm.Street_Name,' ',pm.City)Address,Ip.Patient_Type");
        //sb.Append(" FROM f_ipdadjustment ip inner join patient_master pm on ip.PatientID = pm.PatientID ");
        //sb.Append(" INNER JOIN ( SELECT distinct(LedgerNumber)LNo from f_salesdetails sd ");
        //sb.Append(" where TrasactionTypeID in ('3','5') AND sd.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and sd.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " )t1 on t1.lno = ip.PatientLedgerNo");
        //sb.Append(" where (ip.BILLno is null or ip.billno = '') ");


        sb.Append(" SELECT pmh.`TransNo`, pmh.TransactionID,CONCAT(pm.Title,' ',pm.Pname)PNAME,CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.City)Address,pmh.Patient_Type  ");
        sb.Append(" FROM `patient_medical_history` pmh INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID   ");
        sb.Append(" INNER JOIN (  ");
        sb.Append(" 	SELECT DISTINCT(LedgerNumber)LNo FROM f_salesdetails sd  WHERE TrasactionTypeID IN ('3','5') AND sd.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' AND sd.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "  ");
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

    #endregion Bind Item

    #region Validation

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

    #endregion Validation


    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;

    #region Return Item

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int IsMedClear = Util.GetInt(StockReports.ExecuteScalar("Select IsMedCleared from patient_medical_history where TransactionID='" + lblTransactionNo.Text.Trim() + "'"));

        if (IsMedClear == 1)
        {
            lblMsg.Text = "PATIENT MEDICAL CLEARANCE HAS BEEN DONE, YOU CAN'T RETURN ITEMS";
            return;
        }
        string Led = SaveData();

        if (Led != "")
        {
            if (Led == "#")
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + AllGlobalFunction.saveMessage + "');", true);
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Medicine is Returned, Return Bill No. :'+'" + Led.Split('#')[0] + "');", true);

            if (chkPrint.Checked)
            //  ScriptManager.RegisterStartupScript(this, this.GetType(), "Key2", "window.open('../Common/PharmacyReturnReceipt.aspx?LedTnxNo=" + Led.Split('#')[1] + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&IsBill=1&Duplicate=0');", true);
            {
                if (Led != "#")
                {
                    if (Resources.Resource.ReceiptPrintFormat == "0")
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key4", "window.open('../Common/GSTPharmacyReturnReceipt.aspx?LedTnxNo=" + Led.Split('#')[1] + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&IsBill=1&Duplicate=0');", true);
                    else
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key5", "window.open('../Common/CommonReceipt_pdf.aspx?LedgerTransactionNo=" + Led.Split('#')[1] + "&IsBill=1&Duplicate=0&Type=PHY');", true);
                }
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='PatientReturnItem.aspx';", true);
        }


        else
            lblMsg.Text = "Error Occurred,Please Contact Administrator";
    }

    private string SaveData()
    {
        if (ViewState["ReturnItem"] != null)
        {
            DataTable dtItem = (DataTable)ViewState["ReturnItem"];
            string LedTxnID = string.Empty;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
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
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
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
                    //
                    SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('5','" + AllGlobalFunction.MedicalStoreID + "','" + Session["CentreID"].ToString() + "') "));

                    EncounterNo = Encounter.FindEncounterNo(lblPatientID.Text.Trim());

                    if (EncounterNo == 0)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }



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
                    objLedTran.IndentNo = txtIndentNumber.Text.Trim();
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
                    objLedTran.EncounterNo = Util.GetInt(EncounterNo);


                    LedTxnID = objLedTran.Insert();
                    if (LedTxnID == string.Empty)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
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
                                    Tranx.Rollback();
                                    Tranx.Dispose();
                                    con.Close();
                                    con.Dispose();
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
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }
                        //

                        //

                        //Insert into salesdetail multiple row effect

                        Sales_Details objSales = new Sales_Details(Tranx);
                        objSales.Date = DateTime.Now;
                        objSales.Time = DateTime.Now;
                        objSales.LedgerNumber = Util.GetString(dtItem.Rows[i]["LedgerNumber"]);
                        objSales.DepartmentID = "STO00001";
                        objSales.IndentNo = txtIndentNumber.Text.Trim();
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

                        //  objSales.TaxPercent = objLTDetail.PurTaxPer;
                        //  objSales.TaxAmt = objLTDetail.PurTaxAmt;

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
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }
                        //for insert billno
                        //
                        string SalesBillno = "UPDATE f_salesdetails SET billno='" + dtItem.Rows[0]["BillNo"].ToString() + "' WHERE Salesid='" + SalesID + "' ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SalesBillno);
                        //
                        //----Check Release Count in Stock Table---------------------
                        string str = "select if(0 > (ReleasedCount-" + dtItem.Rows[i]["RetQty"] +
                            "),0,1)CHK from f_stock where stockID='" + objLTDetail.StockID + "'";
                        if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                        {
                            Tranx.Rollback();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        str = "update f_stock set  ReleasedCount = ReleasedCount - " + dtItem.Rows[i]["RetQty"] + " where StockID = '" + objLTDetail.StockID + "'";
                        int Result = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                        if (Result == 0)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }
                        //Rejecting those ItemID mapped with Service ItemID that are previously prescribed to Patient
                        //   bool IsServiceItemRejected = StockReports.RejectMedicalServiceItems(lblTransactionNo.Text.Trim(), objLTDetail.ItemID, objLTDetail.StockID, Util.GetDecimal(dtItem.Rows[i]["RetQty"]), Tranx);

                        //if (IsServiceItemRejected == false)
                        //{
                        //    Tranx.Rollback();
                        //    Tranx.Dispose();
                        //    con.Close();
                        //    con.Dispose();
                        //    return string.Empty;
                        //}

                        if (ViewState["Indent_Dpt"] != null)
                        {
                            str = "UPDATE f_indent_detail_patient_return SET ReceiveQty=(ReceiveQty+" + dtItem.Rows[i]["RetQty"] + "),RejectQty=(RejectQty+" + dtItem.Rows[i]["RejectQty"] + ") WHERE ID='" + Util.GetString(dtItem.Rows[i]["ID"]) + "' AND ItemId='" + objLTDetail.ItemID + "'";
                            int update = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                            if (update == 0)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
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
                            Tranx.Rollback();
                            return "0";
                        }
                        IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(Util.GetInt(LedTxnID), "", "R", Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            return "0";
                        }
                    }
                }
                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();

                return BillNo + "#" + LedTxnID;
            }
            catch (Exception ex)
            {
                ClassLog log = new ClassLog();
                log.errLog(ex);
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                return string.Empty;
            }
        }
        else
            return string.Empty;
    }

    #endregion Return Item

    #region BarCode

    protected void btnBar_Click(object sender, EventArgs e)
    {
        AllQuery AQ = new AllQuery();
        string PatientLedgerNo = AQ.GetPatientLedNoByTranID(lblTransactionNo.Text.Trim());

        StringBuilder sb = new StringBuilder();
        sb.Append(" select * from (");
        sb.Append(" Select issue.IndentNo,issue.ItemName,issue.StockID,");
        sb.Append(" issue.UnitPrice,issue.TrasactionTypeID,issue.DepartmentID,issue.ItemID,");
        sb.Append(" issue.BatchNumber,issue.SubCategoryID,Date_Format(issue.MedExpiryDate,'%d-%b-%y') as MedExpiryDate,");
        sb.Append(" issue.MRP,issue.Date,issue.IssueUnits,issue.LedgerName as DeptName,issue.LedgerNumber,");
        sb.Append(" if(ptnRtn.RtnQty is null,0,ptnRtn.RtnQty )RtnQty,");
        sb.Append(" (issue.IssueUnits - if(ptnRtn.RtnQty is null,0,ptnRtn.RtnQty ) ) AS inHandUnits");
        sb.Append(" from (Select S.ItemName,S.UnitPrice,S.SubCategoryID,S.BatchNumber,");
        sb.Append(" S.MedExpiryDate,SD.StockID,SD.DepartmentID,SD.IndentNo,Sd.ItemID,");
        sb.Append(" SD.TrasactionTypeID,SD.PerUnitSellingPrice AS MRP,SD.LedgerNumber,Date_Format(SD.Date,'%d-%b-%y')Date,   ");
        sb.Append(" sum(SD.SoldUnits) IssueUnits,LM.LedgerName from f_stock S inner join f_salesdetails SD");
        sb.Append(" on SD.StockID = S.StockID  inner join f_ledgermaster LM on SD.DepartmentID = LM.LedgerNumber");
        sb.Append(" where SD.LedgerNumber = '" + PatientLedgerNo + "' and Sd.TrasactionTypeID in('3','4') and SD.StockID='LSHHI" + txtBar.Text.Trim() + "'   ");
        sb.Append(" group by SD.StockID,Sd.TrasactionTypeID ) issue ");
        sb.Append(" left outer join (Select Sd.StockID,sum(Sd.SoldUnits) as RtnQty ,Sd.ItemID");
        sb.Append(" from f_salesdetails SD where Sd.LedgerNumber ='" + PatientLedgerNo + "' and ");
        sb.Append(" Sd.TrasactionTypeID in ('5','6') and SD.StockID='LSHHI" + txtBar.Text.Trim() + "' group by Sd.StockID,Sd.TrasactionTypeID )");
        sb.Append(" ptnRtn on issue.StockID = ptnRtn.StockID");
        sb.Append(" )t2 where inHandUnits > 0");

        DataTable dtItemDetails = StockReports.GetDataTable(sb.ToString());
        if (dtItemDetails != null && dtItemDetails.Rows.Count > 0)
        {
            grdItems.DataSource = dtItemDetails;
            grdItems.DataBind();
            btnAddItem.Visible = true;
            ViewState.Add("dtItemDetails", dtItemDetails);

            for (int i = 0; i < grdItems.Rows.Count; i++)
                ((CheckBox)grdItems.Rows[i].FindControl("chkSelect")).Checked = true;
            grdItems.Focus();
            lblMsg.Text = string.Empty;
            txtBar.Text = string.Empty;
        }
        else
        {
            grdItems.DataSource = null;
            grdItems.DataBind();
            lblMsg.Text = "No Record Found";
            txtBar.Text = string.Empty;
            txtBar.Focus();
        }
    }

    #endregion BarCode

    protected void btnView_Click(object sender, EventArgs e)
    {

        try
        {
            if (txtTDSearch.Text.Trim() == "" && txtFDSearch.Text.Trim() == "")
            {
                lblMsg.Text = "Give options of Search ..";

                return;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }

        DataTable dt = new DataTable();

        try
        {
            string PopUpQuery = "";
            PopUpQuery = "SELECT *,IF(StatusNew='OPEN','true','false')VIEW FROM ( ";
            PopUpQuery = PopUpQuery + " SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'  ";
            PopUpQuery = PopUpQuery + " WHEN t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  ";
            PopUpQuery = PopUpQuery + " FROM ( ";
            PopUpQuery = PopUpQuery + " SELECT id.indentno,id.IndentType,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,lm.ledgername AS DeptFrom,id.Status,pmh.TransNo as IPDNo,id.TransactionID, pm.PatientID,pm.PName, ";
            PopUpQuery = PopUpQuery + " (SELECT NAME FROM employee_master WHERE EmployeeID=id.userid)UserName,SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty ";
            PopUpQuery = PopUpQuery + " FROM f_indent_detail_patient_return id INNER JOIN  patient_medical_history pmh ON id.TransactionID = pmh.TransactionID INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID";
            PopUpQuery = PopUpQuery + " INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = id.Deptfrom  where id.storeid='STO00001' and id.deptto = '" + ViewState["DeptLedgerNo"].ToString() + "'  ";
            PopUpQuery = PopUpQuery + " and id.TransactionID='" + lblTransactionID.Text.Trim() + "' ";

            if (txtFDSearch.Text.Trim() != "" && txtTDSearch.Text.Trim() != "")
            {
                PopUpQuery = PopUpQuery + " AND Date(id.dtEntry) >= '" + Util.GetDateTime(txtFDSearch.Text.Trim()).ToString("yyyy-MM-dd") + "' AND Date(id.dtEntry) <='" + Util.GetDateTime(txtTDSearch.Text.Trim()).ToString("yyyy-MM-dd") + "'";
            }
            if (txtIndentID.Text != "")
                PopUpQuery = PopUpQuery + " AND id.IndentNo = '" + Util.GetString(txtIndentID.Text.Trim()) + "'";

            PopUpQuery = PopUpQuery + " GROUP BY IndentNo )t  )t1  where t1.StatusNew in ('OPEN','PARTIAL','CLOSE','REJECT') ORDER BY IndentNo DESC";


            dt = StockReports.GetDataTable(PopUpQuery);

            grisearch.DataSource = dt;
            grisearch.DataBind();
            if (dt.Rows.Count > 0 && dt != null)
            {
                pnlSearch.Visible = true;
                lblMsg.Text = dt.Rows.Count + " Record(s) Found";
                btnAdditemsToReturn.Visible = true;
            }
            else
            {
                lblMsg.Text = "Record Not Found";
            }
            this.Controls.Add(new LiteralControl("<script type='text/javascript'>showIndentModel();</script>"));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }

    }

    protected void grisearch_SelectedIndexChanged(object sender, EventArgs e)
    {
        string Indent_No = "";
        string PatientID = ((Label)grisearch.SelectedRow.FindControl("lblPatientID")).Text;
        Indent_No = ((Label)grisearch.SelectedRow.FindControl("lblIndentNo")).Text;


        StringBuilder sb = new StringBuilder();


        butadd.Attributes.Add("onClick", "setTargetValue('" + Indent_No + "','" + lblMsg.Text + "',event)");

        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "clickBTNADD();", true);
    }

    protected void gvGRN_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {
            ViewState["Indent_Dpt"] = Util.GetString(e.CommandArgument).Split('#')[0];
            BindIndentDetails(Util.GetString(e.CommandArgument).Split('#')[1], Util.GetString(e.CommandArgument).Split('#')[0], Util.GetString(e.CommandArgument).Split('#')[2], Util.GetString(e.CommandArgument).Split('#')[5].ToString());
        }
        if (e.CommandName == "AReject")
        {
            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string strIndent = "update f_indent_detail_patient_return set RejectQty = ReqQty,RejectBy='" + ViewState["ID"].ToString() + "',RejectReason='Wrong Indent' where IndentNo = '" + IndentNo + "'";
            StockReports.ExecuteDML(strIndent);
            btnView_Click(sender, e);
            BindIndentDetails(Util.GetString(e.CommandArgument).Split('#')[1], Util.GetString(e.CommandArgument).Split('#')[0], Util.GetString(e.CommandArgument).Split('#')[2], Util.GetString(e.CommandArgument).Split('#')[5].ToString());
        }
        this.Controls.Add(new LiteralControl("<script type='text/javascript'>showIndentModel();</script>"));
    }

    protected void BindIndentDetails(string Dept, string IndentNo, string TransactionID, string Status)
    {
        string str = "Select t1.*,concat(ictm.Name,' ',rm.Bed_No,' ',rm.Floor)RoomName from (SELECT CONCAT(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'/',pm.Gender)Age,replace(pm.PatientID,'LSHHI','')PatientID," +
                    " pmh.TransactionID , pmh.TransNo as IPDNo,pmh.PanelID,(select name from  doctor_master where DoctorID=pmh.DoctorID)DocTorName,(select company_name from f_panel_master " +
                    " where PanelID=pmh.PanelID)PanelName,pmh.Status,pip.RoomID " +
                    " FROM patient_master pm INNER JOIN patient_medical_history pmh ON " +
                    " pmh.PatientID=pm.PatientID  " +
                    " inner join patient_ipd_profile pip on pip.TransactionID=pmh.TransactionID " +
            //" WHERE pmh.TransactionID='" + TransactionID + "'  AND pip.Status='IN')t1 " +
                    " WHERE pmh.TransactionID='" + TransactionID + "')t1 " +
                    " inner join room_master rm on t1.roomid=rm.RoomId inner join ipd_case_type_master ictm on rm.IPDCaseTypeID=ictm.IPDCaseTypeID ";
        DataTable dtPatientDetails = StockReports.GetDataTable(str);

        if (dtPatientDetails != null && dtPatientDetails.Rows.Count > 0)
        {
            lblAge.Text = dtPatientDetails.Rows[0]["Age"].ToString();
            lblPName.Text = dtPatientDetails.Rows[0]["PName"].ToString();
            lblRegistrationNo.Text = dtPatientDetails.Rows[0]["PatientID"].ToString().Replace("LSHHI", "");
            lblRegistrationNo.Attributes["PanelID"] = dtPatientDetails.Rows[0]["PanelID"].ToString();
            lblTransactionID.Text = dtPatientDetails.Rows[0]["TransactionID"].ToString();
            lblTransNo.Text = dtPatientDetails.Rows[0]["IPDNo"].ToString();
            lblDocName.Text = dtPatientDetails.Rows[0]["DocTorName"].ToString();
            lblPanelName.Text = dtPatientDetails.Rows[0]["PanelName"].ToString();
            ViewState["TID"] = dtPatientDetails.Rows[0]["TransactionID"].ToString();
            ViewState["PID"] = dtPatientDetails.Rows[0]["PatientID"].ToString();
        }
        else
        {
            lblMsg.Text = "Data Not Found. Please Check if Patientis is Discharged";
            pnlSearch.Visible = false;
            return;
        }
        string strnew = string.Empty;

        if (String.IsNullOrEmpty(IndentNo))                                                                                                                                                    //(ind.ReceiveQty+ind.RejectQty)<ind.ReqQty
            strnew = "SELECT ind.*,im.Type_ID,im.SubCategoryID,im.ServiceItemID,im.ToBeBilled FROM f_indent_detail_patient_return ind INNER JOIN f_itemmaster im ON ind.itemid=im.itemid WHERE    ind.TransactionID='" + TransactionID + "'";
        else
            strnew = "select ind.*,im.Type_ID,im.SubCategoryID,im.ServiceItemID,im.ToBeBilled from f_indent_detail_patient_return ind inner join f_itemmaster im on ind.itemid=im.itemid where  ind.indentno = '" + IndentNo + "'";   //(ind.ReceiveQty+ind.RejectQty)<ind.ReqQty and

        DataTable dtIndentDetails = StockReports.GetDataTable(strnew);

        if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
        {
            lblMsg.Text = "";
            DataColumn dc = new DataColumn("AvailQty");
            dc.DefaultValue = "0";
            dtIndentDetails.Columns.Add(dc);

            dc = new DataColumn("IssuePossible");
            dc.DefaultValue = "0";
            dtIndentDetails.Columns.Add(dc);

            dc = new DataColumn("PendingQty");
            dc.DefaultValue = "0";
            dtIndentDetails.Columns.Add(dc);

            dc = new DataColumn("DeptAvailQty");
            dc.DefaultValue = "0";
            dtIndentDetails.Columns.Add(dc);

            for (int m = 0; m < dtIndentDetails.Rows.Count; m++)
            {
                string strStock = "select DISTINCT sum(InitialCount-ReleasedCount-PendingQty)AvailQty,deptledgerno from f_stock  where itemid='" + dtIndentDetails.Rows[m]["itemid"] + "' and (InitialCount-ReleasedCount-PendingQty)>0 and deptledgerno in ('" + ViewState["DeptLedgerNo"].ToString() + "','" + dtIndentDetails.Rows[m]["DeptFrom"].ToString() + "') and Ispost=1  and MedExpiryDate>curdate() group by  itemid,deptledgerno";

                DataTable dtStock = StockReports.GetDataTable(strStock);

                if (dtStock != null && dtStock.Rows.Count > 0)
                {
                    foreach (DataRow row in dtStock.Rows)
                    {
                        if (row["deptledgerno"].ToString() == ViewState["DeptLedgerNo"].ToString())
                            dtIndentDetails.Rows[m]["AvailQty"] = row["AvailQty"].ToString();

                        if (row["deptledgerno"].ToString() == dtIndentDetails.Rows[m]["DeptFrom"].ToString())
                            dtIndentDetails.Rows[m]["DeptAvailQty"] = row["AvailQty"].ToString();
                    }
                }

                float resQty = Util.GetFloat(dtIndentDetails.Rows[m]["ReqQty"]) - Util.GetFloat(dtIndentDetails.Rows[m]["ReceiveQty"]) - Util.GetFloat(dtIndentDetails.Rows[m]["RejectQty"]);
                if (resQty < Util.GetFloat(dtIndentDetails.Rows[m]["AvailQty"]))
                {
                    dtIndentDetails.Rows[m]["IssuePossible"] = resQty;
                }
                else
                {
                    dtIndentDetails.Rows[m]["IssuePossible"] = Util.GetFloat(dtIndentDetails.Rows[m]["AvailQty"]);
                }

                dtIndentDetails.Rows[m]["PendingQty"] = Util.GetFloat(dtIndentDetails.Rows[m]["ReqQty"]) - (Util.GetFloat(dtIndentDetails.Rows[m]["ReceiveQty"]) + Util.GetFloat(dtIndentDetails.Rows[m]["RejectQty"]));
            }
            dtIndentDetails.AcceptChanges();
            ViewState["StockTransfer"] = dtIndentDetails;
            grdIndentDetails.DataSource = dtIndentDetails;
            grdIndentDetails.DataBind();
            pnlSearch.Visible = true;
            btnAdditemsToReturn.Visible = true;
            this.Controls.Add(new LiteralControl("<script type='text/javascript'>showIndentModel();</script>"));
        }
        else
        {
            grdIndentDetails.DataSource = null;
            grdIndentDetails.DataBind();
           // pnlSearch.Visible = false;
            this.Controls.Add(new LiteralControl("<script type='text/javascript'>showIndentModel();</script>"));
            return;
        }
    }

    protected void grdIndentDetails_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            foreach (Control c in e.Item.Controls)
            {
                if (c is System.Web.UI.HtmlControls.HtmlTableRow)
                {
                    HtmlTableRow tr = (HtmlTableRow)c;
                    foreach (Control c1 in tr.Controls)
                    {
                        Label mylabel = (Label)c1.FindControl("lblPendingQty");

                        if (Convert.ToDecimal(mylabel.Text) > 0)
                        {
                            tr.BgColor = "white";
                        }
                        else if (Convert.ToDecimal(mylabel.Text) == 0)
                        {
                            tr.BgColor = "lightgreen";
                        }

                    }
                }
            }

        }
    }



    public class ItemDetail
    {

        public int id { get; set; }
        public int returnQuantity { get; set; }
        public int rejectQuantity { get; set; }

    }

    List<string> aa = new List<string>();
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (ViewState["Indent_Dpt"] != "")
            txtIndentNo.Text = Util.GetString(ViewState["Indent_Dpt"]);






        List<ItemDetail> ItemDetails = new List<ItemDetail>();

        string ids = string.Empty;

        foreach (RepeaterItem item in grdIndentDetails.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                int id = Util.GetInt(((Label)item.FindControl("lblIndentID")).Text);
                int returnQty = Util.GetInt(((TextBox)item.FindControl("txtReturnQuantity")).Text);
                int rejectQty = Util.GetInt(((TextBox)item.FindControl("txtRejectQuantity")).Text);

                int totalQty = returnQty + rejectQty;

                if (totalQty > 0)
                {
                    ids += id + ",";
                    ItemDetails.Add(new ItemDetail
                    {
                        id = id,
                        returnQuantity = returnQty,
                        rejectQuantity = rejectQty
                    });
                }

            }
        }



        if (ItemDetails.Count > 0)
            ids = ids.Substring(0, ids.Length - 1);






        StringBuilder sb = new StringBuilder();
        DataTable dtInd = new DataTable();
        DataTable dt = new DataTable();
        try
        {
            string str = "SELECT ID,ItemID,ReqQty,indentNo,deptfrom FROM f_indent_detail_patient_return WHERE ID in (" + ids + ") ";//"IndentNo='" + ViewState["Indent_Dpt"] + "'";
            dtInd = StockReports.GetDataTable(str);
            if (dtInd != null && dtInd.Rows.Count > 0)
            {
                dt = GetItem();
                foreach (DataRow dr in dtInd.Rows)
                {
                    //float ReqQty = Util.GetFloat(dr["ReqQty"]);
                    int returnID = Util.GetInt(dr["ID"]);

                    var dd = ItemDetails.Where(i => i.id == returnID).ToList();

                    float ReqQty = Util.GetFloat(dd[0].returnQuantity);
                    float IssueQty = 0f;
                    float PendingQty = (ReqQty + dd[0].rejectQuantity) - IssueQty;
                    int iCtr = 0;
                    sb = new StringBuilder();
                    sb.Append(" SELECT t2.* FROM (  ");
                    sb.Append("     SELECT issue.IndentNo,issue.ToBeBilled,issue.IsVerified,issue.ItemName,issue.Type_ID,issue.ServiceItemID,issue.StockID, issue.UnitPrice,  ");
                    sb.Append("     issue.TrasactionTypeID,issue.DepartmentID,issue.ItemID, issue.BatchNumber,issue.SubCategoryID,DATE_FORMAT(issue.MedExpiryDate,'%d-%b-%y') AS MedExpiryDate, ");
                    sb.Append("     issue.IsExpirable, issue.MRP,issue.Date,issue.IssueUnits,issue.LedgerName AS DeptName,issue.LedgerNumber,IF(ptnRtn.RtnQty IS NULL,0,ptnRtn.RtnQty )RtnQty, ");
                    sb.Append("     (issue.IssueUnits - IF(ptnRtn.RtnQty IS NULL,0,ptnRtn.RtnQty ) ) AS inHandUnits,issue.TaxPercent, ");
                    sb.Append("     issue.HSNCode,issue.IGSTPercent,issue.IGSTAmt,issue.SGSTPercent,issue.SGSTAmt,issue.CGSTPercent,issue.CGSTAmt,issue.GSTType   ");
                    sb.Append("     FROM ( ");
                    sb.Append("         SELECT S.ItemName,ltd.Type_ID,ltd.ServiceItemID,ltd.ToBeBilled,ltd.IsVerified,S.UnitPrice,S.SubCategoryID,S.BatchNumber, S.MedExpiryDate, ");
                    sb.Append("         im.isExpirable,SD.StockID,SD.DepartmentID,SD.IndentNo,Sd.ItemID, SD.TrasactionTypeID,SD.PerUnitSellingPrice AS MRP,SD.LedgerNumber, ");
                    sb.Append("         DATE_FORMAT(SD.Date,'%d-%b-%y')DATE,SUM(SD.SoldUnits) IssueUnits,LM.LedgerName,SD.TaxPercent, ");
                    sb.Append("         IFNULL(SD.HSNCode,'')HSNCode,SD.IGSTPercent,SD.IGSTAmt,SD.SGSTPercent,SD.SGSTAmt,SD.CGSTPercent,SD.CGSTAmt,IFNULL(SD.GSTType,'')GSTType   ");
                    sb.Append("         FROM f_stock S INNER JOIN f_salesdetails SD ON SD.StockID = S.StockID INNER JOIN f_ledgermaster LM ON SD.DepartmentID = LM.LedgerNumber ");
                    sb.Append("         INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo AND ltd.StockID=sd.StockID  ");
                    sb.Append("         INNER JOIN f_itemmaster im ON im.itemid=ltd.itemid  ");
                    sb.Append("         WHERE ltd.TransactionID = '" + lblTransactionID.Text + "' AND Sd.TrasactionTypeID IN('3','4') AND SD.ItemID= '" + Util.GetString(dr["ItemID"]) + "' AND S.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'  ");
                    sb.Append("         GROUP BY SD.StockID,Sd.TrasactionTypeID  ");
                    sb.Append("     ) issue   ");
                    sb.Append("     LEFT OUTER JOIN ( ");
                    sb.Append("         SELECT Sd.StockID,SUM(Sd.SoldUnits) AS RtnQty ,Sd.ItemID FROM f_salesdetails SD   ");
                    sb.Append("         INNER JOIN f_stock S ON SD.StockID = S.StockID  ");
                    sb.Append("         INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=sd.LedgerTransactionNo AND ltd.StockID=sd.StockID  ");
                    sb.Append("         WHERE ltd.TransactionID = '" + lblTransactionID.Text + "' AND  Sd.TrasactionTypeID IN ('5','6') AND SD.ItemID='" + Util.GetString(dr["ItemID"]) + "'  AND S.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'  ");
                    sb.Append("         GROUP BY Sd.StockID,Sd.TrasactionTypeID  ");
                    sb.Append("     ) ptnRtn ON issue.StockID = ptnRtn.StockID  ");
                    sb.Append(" )t2  WHERE inHandUnits > 0  ");

                    DataTable dtStk = StockReports.GetDataTable(sb.ToString());
                    if (dtStk != null && dtStk.Rows.Count > 0)
                    {
                        foreach (DataRow drSt in dtStk.Rows)
                        {
                            iCtr += 1;
                            if (PendingQty > 0 && ReqQty <= Util.GetFloat(drSt["inHandUnits"]))
                            {
                                IssueQty = ReqQty;
                                DataRow drNew = dt.NewRow();
                                drNew["IsSelected"] = Util.GetBoolean("True");
                                drNew["ItemID"] = Util.GetString(drSt["ItemID"]);
                                drNew["ItemName"] = Util.GetString(drSt["ItemName"]);
                                drNew["IssueUnits"] = Util.GetFloat(drSt["IssueUnits"]);
                                drNew["Date"] = Util.GetString(drSt["Date"]);
                                drNew["DeptName"] = Util.GetString(drSt["DeptName"]);
                                drNew["inHandUnits"] = Util.GetFloat(drSt["inHandUnits"]);
                                drNew["BatchNumber"] = Util.GetString(drSt["BatchNumber"]);
                                drNew["IsExpirable"] = Util.GetString(drSt["IsExpirable"]);
                                drNew["MedExpiryDate"] = Util.GetString(drSt["MedExpiryDate"]);
                                drNew["MRP"] = Util.GetFloat(drSt["MRP"]);
                                drNew["UnitPrice"] = Util.GetFloat(drSt["UnitPrice"]);
                                drNew["SubCategoryID"] = Util.GetString(drSt["SubCategoryID"]);
                                drNew["RetQty"] = IssueQty;
                                drNew["StockID"] = Util.GetString(drSt["StockID"]);
                                decimal amount = Util.GetDecimal(IssueQty) * Util.GetDecimal(drSt["MRP"]);
                                drNew["Amount"] = amount;
                                drNew["ToBeBilled"] = Util.GetInt(drSt["ToBeBilled"]);
                                drNew["Type_ID"] = Util.GetString(drSt["Type_ID"]);
                                drNew["ServiceItemID"] = Util.GetString(drSt["ServiceItemID"]);
                                drNew["LedgerNumber"] = Util.GetString(drSt["LedgerNumber"]);
                                drNew["IsVerified"] = Util.GetString(drSt["IsVerified"]);
                                drNew["TaxPercent"] = Util.GetString(drSt["TaxPercent"]);
                                drNew["HSNCode"] = Util.GetString(drSt["HSNCode"]);
                                drNew["IGSTPercent"] = Util.GetDecimal(drSt["IGSTPercent"]);
                                drNew["SGSTPercent"] = Util.GetDecimal(drSt["SGSTPercent"]);
                                drNew["CGSTPercent"] = Util.GetDecimal(drSt["CGSTPercent"]);
                                drNew["GSTType"] = Util.GetString(drSt["IsVerified"]);
                                drNew["RejectQty"] = dd[0].rejectQuantity;
                                drNew["ID"] = dd[0].id;
                                dt.Rows.Add(drNew);
                                PendingQty = PendingQty - IssueQty;
                                PendingQty = PendingQty - dd[0].rejectQuantity;
                                dd[0].rejectQuantity = dd[0].rejectQuantity - dd[0].rejectQuantity;
                            }
                            else if (PendingQty > 0 && ReqQty > Util.GetFloat(drSt["inHandUnits"]))
                            {
                                IssueQty = Util.GetFloat(drSt["inHandUnits"]);
                                ReqQty = ReqQty - IssueQty;
                                DataRow drNew = dt.NewRow();
                                drNew["IsSelected"] = Util.GetBoolean("True");
                                drNew["ItemID"] = Util.GetString(drSt["ItemID"]);
                                drNew["ItemName"] = Util.GetString(drSt["ItemName"]);
                                drNew["IssueUnits"] = Util.GetFloat(drSt["IssueUnits"]);
                                drNew["Date"] = Util.GetString(drSt["Date"]);
                                drNew["DeptName"] = Util.GetString(drSt["DeptName"]);
                                drNew["inHandUnits"] = Util.GetFloat(drSt["inHandUnits"]);
                                drNew["BatchNumber"] = Util.GetString(drSt["BatchNumber"]);
                                drNew["IsExpirable"] = Util.GetString(drSt["IsExpirable"]);
                                drNew["MedExpiryDate"] = Util.GetString(drSt["MedExpiryDate"]);
                                drNew["MRP"] = Util.GetFloat(drSt["MRP"]);
                                drNew["UnitPrice"] = Util.GetFloat(drSt["UnitPrice"]);
                                drNew["SubCategoryID"] = Util.GetString(drSt["SubCategoryID"]);
                                drNew["RetQty"] = IssueQty;
                                drNew["StockID"] = Util.GetString(drSt["StockID"]);
                                decimal amount = Util.GetDecimal(IssueQty) * Util.GetDecimal(drSt["MRP"]);
                                drNew["Amount"] = amount;
                                drNew["ToBeBilled"] = Util.GetInt(drSt["ToBeBilled"]);
                                drNew["Type_ID"] = Util.GetString(drSt["Type_ID"]);
                                drNew["ServiceItemID"] = Util.GetString(drSt["ServiceItemID"]);
                                drNew["LedgerNumber"] = Util.GetString(drSt["LedgerNumber"]);
                                drNew["IsVerified"] = Util.GetString(drSt["IsVerified"]);
                                drNew["TaxPercent"] = Util.GetString(drSt["TaxPercent"]);
                                drNew["HSNCode"] = Util.GetString(drSt["HSNCode"]);
                                drNew["IGSTPercent"] = Util.GetDecimal(drSt["IGSTPercent"]);
                                drNew["SGSTPercent"] = Util.GetDecimal(drSt["SGSTPercent"]);
                                drNew["CGSTPercent"] = Util.GetDecimal(drSt["CGSTPercent"]);
                                drNew["GSTType"] = Util.GetString(drSt["IsVerified"]);
                                drNew["RejectQty"] = dd[0].rejectQuantity;
                                drNew["ID"] = dd[0].id;
                                dt.Rows.Add(drNew);
                                PendingQty = PendingQty - IssueQty;
                                PendingQty = PendingQty - dd[0].rejectQuantity;
                                dd[0].rejectQuantity = dd[0].rejectQuantity - dd[0].rejectQuantity;
                            }
                        }
                    }

                    //if (PendingQty > 0)
                    //{
                    //    StockReports.ExecuteDML("update f_indent_detail_patient_return set RejectQty = RejectQty + " + PendingQty + " ,RejectReason= 'Item not available in pharmacy department',RejectBy='" + ViewState["UserID"].ToString() + "' where itemid='" + Util.GetString(dr["ItemID"]) + "' and indentno='" + ViewState["IndentNo"] + "' ");
                    //}

                    dt.AcceptChanges();
                }
                if (dt != null && dt.Rows.Count > 0)
                {
                    grdItems.DataSource = dt;
                    grdItems.DataBind();
                    btnAddItem.Visible = true;
                    ViewState.Add("dtItemDetails", dt);
                    grisearch.DataSource = null;
                    grisearch.DataBind();
                    grdIndentDetails.DataSource = null;
                    grdIndentDetails.DataBind();
                    pnlSearch.Visible = false;
                }
                btnAddItem_Click(sender, e);
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void gvGRN_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatusNew")).Text == "REJECT")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
                e.Row.Cells[0].Enabled = false;

            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.Green;
                e.Row.Cells[0].Enabled = false;

            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
                e.Row.Cells[0].Enabled = false;
                e.Row.Cells[1].Enabled = false;
            }
        }
    }

    protected void rblOption_SelectedIndexChanged(object sender, EventArgs e)
    {

        grisearch.DataSource = null;
        grisearch.DataBind();

    }

    protected void btnSN_Click(object sender, EventArgs e)
    {
        searchindentnew("'OPEN'");
        //Open
    }

    protected void btnA_Click(object sender, EventArgs e)
    {
        searchindentnew("'PARTIAL'");
        // Partial
    }

    protected void btnNA_Click(object sender, EventArgs e)
    {
        searchindentnew("'REJECT'");
        // Reject
    }

    protected void btnRN_Click(object sender, EventArgs e)
    {
        searchindentnew("'CLOSE'");
        // Close
    }

    public void searchindentnew(string status)
    {
        DataTable dt = new DataTable();

        try
        {
            string PopUpQuery = "";

            PopUpQuery = "SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM ( ";
            PopUpQuery = PopUpQuery + " SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'  ";
            PopUpQuery = PopUpQuery + " WHEN t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  ";
            PopUpQuery = PopUpQuery + " FROM ( ";
            PopUpQuery = PopUpQuery + " SELECT id.indentno,id.IndentType,pmh.paymenttype,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,lm.ledgername AS DeptFrom,id.Status,replace(id.TransactionID,'ISHHI','')IPDNo,id.TransactionID, pm.PatientID,pm.PName, ";
            PopUpQuery = PopUpQuery + " (SELECT NAME FROM employee_master WHERE EmployeeID=id.userid)UserName,SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty ";
            PopUpQuery = PopUpQuery + " FROM f_indent_detail_patient id INNER JOIN  patient_medical_history pmh ON id.TransactionID = pmh.TransactionID INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID";
            PopUpQuery = PopUpQuery + " INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = id.Deptfrom  where id.storeid='STO00001' and id.deptto = 'LSHHI57' AND pmh.paymenttype='CASH' ";

            PopUpQuery = PopUpQuery + " and id.TransactionID like '%ISHHI" + ViewState["IPDNO"].ToString() + "%' ";

            if (txtFDSearch.Text.Trim() != "" && txtTDSearch.Text.Trim() != "")
            {

                PopUpQuery = PopUpQuery + " and Date(id.dtEntry) >= '" + Util.GetDateTime(txtFDSearch.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(id.dtEntry) <='" + Util.GetDateTime(txtTDSearch.Text.Trim()).ToString("yyyy-MM-dd") + "'";
            }


            PopUpQuery = PopUpQuery + " GROUP BY IndentNo        )t  )t1  where t1.StatusNew in (" + status + ") order by dtentry ";


            dt = StockReports.GetDataTable(PopUpQuery);

            grisearch.DataSource = dt;
            grisearch.DataBind();
            if (grisearch.Rows.Count == 0)
            {
                lblMsg.Text = "Record Not Found";
            }
            else
            {
                lblMsg.Text = "";
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
        //  str += "GROUP BY IndentNo )t )t2 where t2.StatusNew='" + status + "'";
    }

    [WebMethod(EnableSession = true)]
    public static string GetIndentCount(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT COUNT(*) FROM (SELECT * FROM f_indent_detail_patient_return WHERE reqQty+ReceiveQty+RejectQty=reqQty AND TransactionID=" + TID + " GROUP BY IndentNo)t");
        string Count = Util.GetString(Util.GetInt(StockReports.ExecuteScalar(sb.ToString())));
        if (Count != "" && Count != null)
            return Count;
        else
            return "";
    }
    protected void btnView_Click1(object sender, EventArgs e)
    {
        var departmentLedgerNumber = HttpContext.Current.Session["DeptLedgerNo"].ToString();
        var indentNumber = txtIndentID.Text.Trim();
        var transactionID = lblTransactionNo.Text.ToString();

        BindIndentDetails(departmentLedgerNumber, indentNumber, transactionID, "OPEN");
    }
}