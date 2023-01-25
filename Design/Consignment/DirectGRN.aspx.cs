using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.IO;
using System.Web;
using System.Globalization;
using System.Collections.Generic;



public partial class Design_Store_DirectGRN : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            todalcal.EndDate = DateTime.Now;
            callandate.EndDate = DateTime.Now;
            expdate.StartDate = DateTime.Now.AddDays(1);
            // txtExpDate1.Text = System.DateTime.Now.AddDays(1).ToString("dd-MMM-yyyy");
            BindVendor();
            BindSaleTax();
            txtFreight.Attributes.Add("onkeyup", "sum('" + lbl.ClientID + "','" + txtInvoiceAmount.ClientID + "','" + txtFreight.ClientID + "','" + txtOctori.ClientID + "','" + txtRoundOff.ClientID + "');");
            txtOctori.Attributes.Add("onkeyup", "sum('" + lbl.ClientID + "','" + txtInvoiceAmount.ClientID + "','" + txtFreight.ClientID + "','" + txtOctori.ClientID + "','" + txtRoundOff.ClientID + "');");
            txtRoundOff.Attributes.Add("onkeyup", "sum('" + lbl.ClientID + "','" + txtInvoiceAmount.ClientID + "','" + txtFreight.ClientID + "','" + txtOctori.ClientID + "','" + txtRoundOff.ClientID + "');");
            BindTAX();
            BindDepartment();
            BindItem();

        }
        txtBillDate.Attributes.Add("readOnly", "true");
        txtChalanDate.Attributes.Add("readOnly", "true");
        //  txtExpDate1.Attributes.Add("readOnly", "true");
        txtInvoiceAmount.Attributes.Add("readOnly", "true");

    }

    public void BindVendor()
    {
        StringBuilder sb = new StringBuilder();
        if (Resources.Resource.StoreWiseVendor == "1")
        {
            sb.Append(" SELECT CONCAT(lm.LedgerNumber,'#',lm.LedgerUserID,'#',vm.StateID)ID,lm.LedgerName FROM f_ledgermaster  lm  ");
            sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
            sb.Append(" WHERE groupID='VEN' AND IsCurrent=1 AND vm.DepTLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ORDER BY LedgerName ");
        }
        else
        {
            // sb.Append(" select concat(LedgerNumber,'#',LedgerUserID)ID,LedgerName from f_ledgermaster where groupID='VEN' and IsCurrent=1 order by LedgerName ");
            sb.Append(" SELECT CONCAT(lm.LedgerNumber,'#',lm.LedgerUserID,'#',vm.StateID)ID,lm.LedgerName FROM f_ledgermaster  lm  ");
            sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
            sb.Append(" WHERE groupID='VEN' AND IsCurrent=1  ORDER BY LedgerName ");

        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ddlVendor.DataSource = dt;
            ddlVendor.DataTextField = "LedgerName";
            ddlVendor.DataValueField = "ID";
            ddlVendor.DataBind();

            ddlVendor.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlVendor.Items.Clear();
            ddlVendor.DataSource = null;
            ddlVendor.DataBind();
        }

    }

    private void BindSaleTax()
    {
        AllLoadData_Store.bindSalesTax(DropDownList2);
    }

    private void BindItem()
    {
        DataTable dtItem = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT concat(IM.Typename,' # ','(',SM.name,')')ItemName,im.IsExpirable,IsUsable,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#', ");
        sb.Append(" IF(IFNULL(im.MinorUnit,'')='',IFNULL(im.UnitType,''),im.MinorUnit),'#',IM.Type_ID,'#',IFNULL(IM.SaleTaxPer,''),'#',IFNULL(UPPER(im.IsExpirable),''),'#',IF(IFNULL(im.minorUnit,'')='',IFNULL(im.minorUnit,''),im.minorUnit),'#',IF(IFNULL(im.ConversionFactor,'')='',IFNULL(im.ConversionFactor,''),im.ConversionFactor),'#',IF(IFNULL(im.MajorUnit,'')='',IFNULL(im.MajorUnit,''),im.MajorUnit),'#',IFNULL(im.IGSTPercent,0),'#',IFNULL(im.SGSTPercent,0),'#',IFNULL(im.CGSTPercent,0),'#',IFNULL(im.GSTType,''),'#',IFNULL(im.HSNCode,''))ItemID ");
        sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
        sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID =SM.CategoryID WHERE c.ConfigID=11 AND IM.IsActive=1 and Typename<>'' AND IM.`IsStent`=1 ");

        sb.Append("order by IM.Typename ");
        dtItem = StockReports.GetDataTable(sb.ToString());
        ViewState["dtItem"] = dtItem;
        if (dtItem.Rows.Count > 0)
        {
            ListBox1.DataSource = dtItem;
            ListBox1.DataTextField = "ItemName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
        }
        else
        {
            ListBox1.Items.Clear();
            ListBox1.Items.Add("No Item Found");

        }
    }
    public void BindTAX()
    {
        string sql = "select TaxName,TaxID from f_taxmaster where TaxID IN('T4','T6','T7') order by TaxName ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            ddlTAX1.DataSource = dt;
            ddlTAX1.DataTextField = "TaxName";
            ddlTAX1.DataValueField = "TaxID";
            ddlTAX1.DataBind();
            ddlTAX1.SelectedIndex = ddlTAX1.Items.IndexOf(ddlTAX1.Items.FindByValue("T6"));
        }
        else
        {
            ddlTAX1.Items.Clear();
            ddlTAX1.Items.Add("No Item Found");

        }

    }

    public DataTable getItemDT()
    {

        DataTable dtItem = new DataTable();
        if (ViewState["ITEM"] == null)
        {
            dtItem.Columns.Add("ItemID");
            dtItem.Columns.Add("ItemName");
            dtItem.Columns.Add("SubCategoryID");
            dtItem.Columns.Add("Rate");
            dtItem.Columns.Add("MRP");
            dtItem.Columns.Add("Unit");
            dtItem.Columns.Add("Quantity",typeof(decimal));
            dtItem.Columns.Add("BatchNo");
            dtItem.Columns.Add("Discount");
            dtItem.Columns.Add("IsFree");
            dtItem.Columns.Add("FreeStatus");
            dtItem.Columns.Add("ExpDate");
            dtItem.Columns.Add("TaxID");
            dtItem.Columns.Add("TaxPer");
            dtItem.Columns.Add("TaxName");
            dtItem.Columns.Add("SaleTaxPer");
            dtItem.Columns.Add("TypeID");
            dtItem.Columns.Add("IsUsable");
            dtItem.Columns.Add("IsExpirable");
            dtItem.Columns.Add("SaleUnit");
            dtItem.Columns.Add("conversionFactor");
            dtItem.Columns.Add("MajorUnit");
            dtItem.Columns.Add("AMT");
            dtItem.Columns.Add("deal");
            dtItem.Columns.Add("deal1");
            dtItem.Columns.Add("totaldeal");
            dtItem.Columns.Add("StoreLedgerNo");
            dtItem.Columns.Add("NetAmount");
            dtItem.Columns.Add("TaxAmount");
            dtItem.Columns.Add("DealTotal");
            dtItem.Columns.Add("ExciseAmt");
            dtItem.Columns.Add("ExcisePer");
            dtItem.Columns.Add("UnitPrice");
            dtItem.Columns.Add("discAmt");
            dtItem.Columns.Add("Amount");
            dtItem.Columns.Add("TaxCalculateOn");
            //GST Changes
            dtItem.Columns.Add("igstTaxPer");
            dtItem.Columns.Add("igstTaxAmt", typeof(decimal));
            dtItem.Columns.Add("cgstTaxPer");
            dtItem.Columns.Add("cgstTaxAmt", typeof(decimal));
            dtItem.Columns.Add("sgstTaxPer");
            dtItem.Columns.Add("sgstTaxAmt", typeof(decimal));
            dtItem.Columns.Add("HSNCode");
            dtItem.Columns.Add("GSTType");
            dtItem.Columns.Add("SpecialDiscPer");
            dtItem.Columns.Add("SpecialDiscAmt");

        }
        else
        {
            dtItem = (DataTable)ViewState["ITEM"];
        }

        return dtItem;
    }
    public void BindGrid()
    {
        DataTable dtItem = (DataTable)ViewState["ITEM"];
        gvPODetails.DataSource = dtItem;
        gvPODetails.DataBind();
        GetNetAmount();
        DisableControl();
        getTaxAmounts();
    }
    private void DisableControl()
    {
        ddlVendor.Enabled = false;
        txtChalanDate.Enabled = false;
        txtChalanNo.Enabled = false;
        txtBillDate.Enabled = false;
        txtBillNo.Enabled = false;
        txtGatePassInWard.Enabled = false;
        rdoGRNPayType.Enabled = false;
    }
    private void EnableControl()
    {
        ddlVendor.Enabled = true;
        txtChalanDate.Enabled = true;
        txtChalanNo.Enabled = true;
        txtBillDate.Enabled = true;
        txtBillNo.Enabled = true;
        txtGatePassInWard.Enabled = true;
        rdoGRNPayType.Enabled = true;

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddlVendor.SelectedIndex <= 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM022','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (ValidateEntryData())
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                if (ViewState["ITEM"] == null)
                {

                    return;
                }
                int ConsignmentNo = Util.GetInt(StockReports.ExecuteScalar("SELECT IFNULL(MAX(ConsignmentNo),0)+1 FROM consignmentdetail"));

                DataTable dtItem = (DataTable)ViewState["ITEM"];
                // DataTable dtTax = (DataTable)ViewState["dtTax"];

                string LedgerTnxNo = string.Empty, InvoiceNo = string.Empty, ChalanNo = string.Empty, ChalanDate = string.Empty, InvoiceDate = string.Empty, GrnPaymentMode = string.Empty;
                decimal cc = 0;
                foreach (GridViewRow gr in gvPODetails.Rows)
                {
                    decimal aa = Util.GetDecimal(((Label)gr.FindControl("lblRate")).Text) * Util.GetDecimal(((Label)gr.FindControl("lblRecQty")).Text) * (Util.GetDecimal(100) - Util.GetDecimal(((Label)gr.FindControl("lblDiscount")).Text)) * Util.GetDecimal(0.01);
                    cc += (aa * (Util.GetDecimal(100) + Util.GetDecimal(((Label)gr.FindControl("lblTAX")).Text)) * Util.GetDecimal(0.01));
                    cc = Math.Round(cc, 2);

                }

                decimal NetAmount = (decimal)cc;
                decimal freight = Util.GetDecimal(txtFreight.Text.Trim());
                decimal Octori = Util.GetDecimal(txtOctori.Text.Trim());
                decimal RoundOff = Util.GetDecimal(txtRoundOff.Text.Trim());
                string GatePassIn = Util.GetString(txtGatePassInWard.Text.Trim());
                //string HospID = Convert.ToString(Session["HOSPID"]);
                InvoiceNo = txtBillNo.Text.Trim();
                InvoiceDate = Util.GetDateTime(txtBillDate.Text).ToString("yyyy-MM-dd");

                ChalanNo = txtChalanNo.Text.Trim();
                ChalanDate = Util.GetDateTime(txtChalanDate.Text).ToString("yyyy-MM-dd");

                if (InvoiceDate.Trim() == "")
                {
                    InvoiceDate = "0001-01-01";
                }
                if (ChalanDate.Trim() == "")
                {
                    ChalanDate = "0001-01-01";
                }
                int countItem = Util.GetInt(dtItem.Compute("sum(Quantity)", ""));

                foreach (DataRow rowItem in dtItem.Rows)
                {
                    decimal aa = 0;
                    decimal bb = 0;
                    string ItemID = string.Empty;
                    string ItemName = string.Empty;
                    string BatchNumber = string.Empty;
                    string Type = string.Empty;
                    decimal UnitPrice = 0;
                    decimal TaxPer = 0;
                    decimal DisPer = 0;
                    decimal InitialCount = 0;
                    DateTime MedExpiryDate;
                    int IsFree = 0;
                    string Unit = rowItem["Unit"].ToString();
                    decimal MRP = Util.GetDecimal(rowItem["MRP"]);
                    decimal Disc = 0;
                    decimal SaleTaxPer = 0;
                    double PurTaxAmt = 0;
                    double SaleTaxAmt = 0;
                    decimal igstPer = 0;
                    decimal cgstPer = 0;
                    decimal sgstPer = 0;
                    decimal specialDiscPer = 0;
                    string HSNCode = string.Empty;
                    string GSTType = string.Empty;
                    string isDeal = string.Empty;
                    decimal ConversionFactor = 0;
                    if (MRP == 0)
                    {
                        MRP = Util.GetDecimal(rowItem["Rate"]) + 5;
                    }
                    HSNCode = Util.GetString(rowItem["HSNCode"]);
                    GSTType = Util.GetString(rowItem["GSTType"]);
                    cgstPer = Util.GetDecimal(rowItem["cgstTaxPer"]);
                    sgstPer = Util.GetDecimal(rowItem["sgstTaxPer"]);
                    igstPer = Util.GetDecimal(rowItem["igstTaxPer"]);
                    specialDiscPer = Util.GetDecimal(rowItem["SpecialDiscPer"]);
                    ConversionFactor = Util.GetDecimal(rowItem["conversionFactor"]);
                    decimal TotalTax = Math.Round(cgstPer + igstPer + sgstPer, 4);
                    ItemID = Util.GetString(rowItem["ItemID"]);
                    ItemName = Util.GetString(rowItem["ItemName"]);
                    DisPer = Util.GetDecimal(rowItem["Discount"]);
                    TaxPer = Util.GetDecimal(TotalTax);
                    BatchNumber = Util.GetString(rowItem["BatchNo"]);
                    aa = Util.GetDecimal(rowItem["Rate"]) * (Util.GetDecimal(100) - Util.GetDecimal(rowItem["Discount"])) * Util.GetDecimal(0.01);
                    bb = (aa * (Util.GetDecimal(100) + Util.GetDecimal(TotalTax)) * Util.GetDecimal(0.01));
                    //double bb = (aa * (100 + Util.GetDecimal(((Label)gr.FindControl("lblTAX")).Text)) * 0.01);
                    UnitPrice = Util.GetDecimal(rowItem["UnitPrice"]);
                    isDeal = Util.GetString(rowItem["DealTotal"]);

                    int Reusable = 0;
                    int IsBilled = 1;
                    SaleTaxPer = Util.GetDecimal(rowItem["SaleTaxPer"]);
                    //Type = Util.GetString(rowItem["TypeID"]); 
                    Type = Util.GetString("IMP");
                    if (Util.GetDecimal(rowItem["Discount"]) > 0)
                    {
                        Disc = Util.GetDecimal(rowItem["Rate"]) * Util.GetDecimal(rowItem["Discount"]) * Util.GetDecimal(0.01);
                    }
                    PurTaxAmt = (float)(bb - aa);

                    InitialCount = Util.GetDecimal(rowItem["Quantity"]);

                    if (rowItem["ExpDate"].ToString().Length > 0)
                    {
                        MedExpiryDate = Util.GetDateTime(rowItem["ExpDate"]); ;
                    }
                    else
                    {
                        MedExpiryDate = DateTime.Now.AddYears(5);
                    }

                    IsFree = Util.GetInt(rowItem["isfree"]);


                    string str = "INSERT INTO consignmentdetail(ConsignmentNo,VendorLedgerNo,ChallanNo,ChallanDate,BillNo,BillDate,ItemID,ItemName,BatchNumber,Rate,UnitPrice,TaxPer,PurTaxAmt,DiscAmt,SaleTaxPer,SaleTaxAmt,TYPE,Reusable,IsBilled,TaxID,DiscountPer,MRP,Unit,InititalCount,StockDate,IsPost,IsFree,Naration,DeptLedgerNo,GateEntryNo,UserID,Freight,Octroi,RoundOff,GRNAmount,MedExpiryDate,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,GSTType,SpecialDiscPer,isDeal,ConversionFactor)	VALUES('" + ConsignmentNo + "','" + ddlVendor.SelectedItem.Value.Split('#')[0] + "','" + txtChalanNo.Text + "','" + ChalanDate + "','" + txtBillNo.Text + "','" + InvoiceDate + "','" + ItemID + "','" + ItemName + "','" + BatchNumber + "','" + Util.GetDecimal(rowItem["Rate"]) + "','" + UnitPrice + "','" + TaxPer + "','" + PurTaxAmt + "','" + Disc + "','" + SaleTaxPer + "','" + SaleTaxAmt + "','" + Type + "','" + Reusable + "','" + IsBilled + "','" + rowItem["TaxID"].ToString() + "','" + DisPer + "','" + MRP + "','" + Unit + "','" + InitialCount + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','0','" + IsFree + "','" + txtNarration.Text + "','" + Util.GetString(ddlDeptLedgerNo.SelectedItem.Value) + "','" + txtGatePassInWard.Text + "','" + ViewState["ID"].ToString() + "'," + freight / countItem + "," + Octori / countItem + "," + RoundOff / countItem + "," + txtInvoiceAmount.Text + ",'" + MedExpiryDate.ToString("yyyy-MM-dd") + "','" + HSNCode + "','" + igstPer + "','" + cgstPer + "','" + sgstPer + "','" + GSTType + "','" + specialDiscPer + "','" + isDeal + "','"+ConversionFactor+"' ) ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

                   
                }
                Tranx.Commit();
                gvPODetails.DataSource = null;
                gvPODetails.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='DirectGRN.aspx';", true);
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = ex.Message;
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();

            }
        }
    }
    private bool ValidateEntryData()
    {
        if (DateTime.Now.CompareTo(Util.GetDateTime(txtBillDate.Text).Date) > 0)
        {
            return true;
        }
        else
        {
            lblMsg.Text = "Bill Date Less then Current Date";
            return false;
        }

    }
    private bool ValidateBillNo(string BillNo, string VendorLedgerNo)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_invoicemaster where replace(replace(replace(replace(InvoiceNo,'.',''),'-',''),' ',''),'','')='" + BillNo.Replace(".", "").Replace("-", "").Replace(" ", "") + "'  and VenLedgerNo='" + VendorLedgerNo + "'"));
        if (count == 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    protected bool ValidateMRP()
    {

        if (Util.GetDecimal(txtRate1.Text.Trim()) > Util.GetDecimal(txtMRP1.Text.Trim()))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM261','" + lblMsg.ClientID + "');", true);
            return false;
        }
        else
        {
            lblMsg.Text = string.Empty;
            return true;
        }
    }
    protected void btnSaveItems_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (ddlVendor.SelectedIndex == -1)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM022','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (ddlDeptLedgerNo.SelectedIndex <1) {
            lblMsg.Text = "Please Select Department";
            ddlDeptLedgerNo.Focus();
            return;
        
        }
        if (ListBox1.SelectedIndex == -1)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (txtBillNo.Text.Trim() == string.Empty && txtChalanNo.Text.Trim() == string.Empty)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM262','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (txtBillNo.Text.Trim() != string.Empty)
        {
            if (txtBillDate.Text == string.Empty)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM263','" + lblMsg.ClientID + "');", true);
                return;
            }
        }
        if (txtChalanNo.Text.Trim() != string.Empty)
        {
            if (txtChalanDate.Text == string.Empty)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM264','" + lblMsg.ClientID + "');", true);
                return;
            }
        }
        if (ListBox1.SelectedValue.Split('#')[5].ToUpper() == "YES")
        {
            if (txtExpDate1.Text == string.Empty)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM265','" + lblMsg.ClientID + "');", true);
                return;
            }
            string format = "dd-MM-yyyy";
            DateTime dateTime;
            if (!DateTime.TryParseExact(txtExpDate1.Text, format, CultureInfo.InvariantCulture, DateTimeStyles.None, out dateTime))
            {
                lblMsg.Text = "Please Enter Valid Expiry Date (format-dd-MM-yyyy)";
                return;
            }
        }
        if (Util.GetDecimal(txtRate1.Text) > Util.GetDecimal(txtMRP1.Text))
        {
            lblMsg.Text = "Rate cannot be greater than Selling Price";
            return;
        }
        if ((Util.GetDecimal(txtIGST.Text) + Util.GetDecimal(txtCGSt.Text) + Util.GetDecimal(txtSGST.Text)) > 100)
        {
            lblMsg.Text = "Total Tax cannot be more than 100%";
            return;
        }


        string InvNo = StockReports.ExecuteScalar("SELECT count(*) FROM f_ledgermaster lm INNER JOIN f_invoicemaster im ON lm.LedgerNumber = im.VenLedgerNo inner join f_ledgertransaction lt on lt.LedgerTransactionNo=im.LedgerTnxNo WHERE im.VenLedgerNo='" + ddlVendor.SelectedItem.Value.Split('#')[0] + "' AND im.InvoiceNo='" + txtBillNo.Text.Trim() + "' and lt.IsCancel=0 ");
        if (Util.GetInt(InvNo) > 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM266','" + lblMsg.ClientID + "');", true);
            return;
        }
        DataTable dtitemofLstbx = new DataTable();
        dtitemofLstbx = (DataTable)ViewState["dtItem"];
        DataTable dtItem = getItemDT();

        DataRow[] dr1 = dtItem.Select("ItemID = '" + ListBox1.SelectedItem.Value.Split('#')[0] + "' ");

        DataRow dr = dtItem.NewRow();
        dr["ItemID"] = ListBox1.SelectedItem.Value.Split('#')[0];
        dr["ItemName"] = ListBox1.SelectedItem.Text.Split('#')[0];
        dr["SubCategoryID"] = ListBox1.SelectedItem.Value.Split('#')[1];
        dr["MRP"] = Util.GetDouble(txtMRP1.Text.Trim());
        dr["Unit"] = ListBox1.SelectedItem.Value.Split('#')[8];//Purchase Unit
        dr["Quantity"] = Util.GetDouble(txtQuantity1.Text.Trim());
        dr["BatchNo"] = Util.GetString(txtBatchNo1.Text.Trim());
        dr["TypeID"] = ListBox1.SelectedItem.Value.Split('#')[3];
        dr["IsExpirable"] = ListBox1.SelectedItem.Value.Split('#')[5];
        dr["SaleUnit"] = ListBox1.SelectedItem.Value.Split('#')[6];//
        dr["conversionFactor"] = ListBox1.SelectedItem.Value.Split('#')[7];
        dr["MajorUnit"] = ListBox1.SelectedItem.Value.Split('#')[8];
        dr["StoreLedgerNo"] = "STO00001";

        DataRow[] dr2 = dtitemofLstbx.Select("ItemID = '" + ListBox1.SelectedItem.Value.ToString() + "' ");
        if (dr2[0]["IsUsable"].ToString() == "R")
            dr["IsUsable"] = 1;
        else
            dr["IsUsable"] = 0;

        if (ListBox1.SelectedItem.Value.Split('#')[5].ToUpper() == "NO")
        {
            dr["ExpDate"] = string.Empty;
        }
        else
        {
            DateTime expDate = DateTime.ParseExact(txtExpDate1.Text, "dd-MM-yyyy", null);
            dr["ExpDate"] = expDate.ToString("yyyy-MM-dd");
        }
        dr["TaxID"] = ddlTAX1.SelectedItem.Value;
        dr["TaxPer"] = Util.GetDouble(txtTAX1.Text.Trim());
        dr["TaxName"] = ddlTAX1.SelectedItem.Text;
        //GST Changes
        dr["igstTaxPer"] = txtIGST.Text;
        dr["cgstTaxPer"] = txtCGSt.Text;
        dr["sgstTaxPer"] = txtSGST.Text;
        // dr["HSNCode"] = ListBox1.SelectedItem.Value.Split('#')[13];
        dr["HSNCode"] = txtHSNCodeNo.Text.Trim();
        //dr["GSTType"] = ListBox1.SelectedItem.Value.Split('#')[12];
        dr["GSTType"] = ddlTAX1.SelectedItem.Text;
        decimal excisePer = 0; decimal rate1 = Util.GetDecimal(txtRate1.Text.Trim());
        decimal SpecialDiscPer = 0; decimal SpecialDiscAmt = 0;
        if (rblTaxCal.SelectedValue == "ExciseAmt")
        {
            excisePer = Util.GetDecimal(txtExcisePer.Text.Trim());
        }
        if (txtDeal.Text != string.Empty)
        {
            int deal = Util.GetInt(txtDeal.Text) + Util.GetInt(txtDeal1.Text);
            rate1 = Util.GetDecimal(Util.GetDouble(Util.GetDecimal(txtQuantity1.Text.Trim()) * Util.GetDecimal(txtRate1.Text.Trim())) / Util.GetDouble(deal));
        }
        decimal discountPer = 0; decimal discountAmt = 0;
        if (txtDiscAmt.Text.Trim() != string.Empty)
        {

            discountPer = Math.Round((Util.GetDecimal(txtDiscAmt.Text.Trim()) * 100) / Util.GetDecimal(txtRate1.Text.Trim()), 2);
            discountAmt = Util.GetDecimal(txtDiscAmt.Text.Trim());
        }
        else
        {
            discountPer = Util.GetDecimal(txtDiscount1.Text.Trim());
            discountAmt = Util.GetDecimal(txtDiscAmt.Text.Trim());
        }
        if (txtSpclDisc.Text.Trim() != string.Empty)
        {
            SpecialDiscPer = Math.Round(Util.GetDecimal(txtSpclDisc.Text), 2);
        }
        else if (txtSpclDiscAmt.Text.Trim() != string.Empty)
        {
            SpecialDiscAmt = Util.GetDecimal(txtSpclDiscAmt.Text.Trim());
            SpecialDiscPer = Math.Round(((SpecialDiscAmt * 100) / (Util.GetDecimal(txtRate1.Text.Trim()) - (Util.GetDecimal(txtRate1.Text.Trim()) * discountPer / 100))), 2);
        }
        List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
        {
         new TaxCalculation_DirectGRN 
         
         {
             
             DiscAmt=Util.GetDecimal(discountAmt), 
             DiscPer=Util.GetDecimal(discountPer), 
             MRP=Util.GetDecimal(txtMRP1.Text.Trim()),
             Quantity = Util.GetDecimal(txtQuantity1.Text.Trim()),
             Rate=Util.GetDecimal(rate1),
             TaxPer = Util.GetDecimal(txtTAX1.Text.Trim()),
             Type = Util.GetString(rblTaxCal.SelectedValue),
             ExcisePer= Util.GetDecimal(excisePer),
            deal =Util.GetDecimal(txtDeal.Text.Trim()),
            deal2= Util.GetDecimal(txtDeal1.Text.Trim()),
            ActualRate=Util.GetDecimal(txtRate1.Text.Trim()), 
            //GST Changes
			IGSTPrecent=Util.GetDecimal(txtIGST.Text.Trim()),
            CGSTPercent=Util.GetDecimal(txtCGSt.Text.Trim()),
            SGSTPercent=Util.GetDecimal(txtSGST.Text.Trim()),
            // To pass Special Discount
            SpecialDiscPer=Util.GetDecimal(SpecialDiscPer),
            SpecialDiscAmt=Util.GetDecimal(SpecialDiscAmt)

         }
         };

        string taxCalculation = AllLoadData_Store.taxCalulation(taxCalculate);

        if (rbtnFree.SelectedItem.Text.ToUpper() == "YES")
        {
            dr["IsFree"] = "1";
            dr["FreeStatus"] = "Yes";
            dr["Discount"] = 0;
            dr["Rate"] = 0;
            dr["discAmt"] = 0;

            dr["NetAmount"] = 0;
            dr["taxAmount"] = 0;
            dr["Amount"] = 0;
            dr["UnitPrice"] = 0;
            //GST Changes
            dr["igstTaxAmt"] = 0;
            dr["cgstTaxAmt"] = 0;
            dr["sgstTaxAmt"] = 0;

            dr["SpecialDiscPer"] = 0;
            dr["SpecialDiscAmt"] = 0;

        }
        else
        {
            dr["IsFree"] = "0";
            dr["FreeStatus"] = "No";
            if (txtDiscAmt.Text.Trim() != string.Empty)
            {
                decimal Percent = 0;
                Percent = Math.Round((Util.GetDecimal(txtDiscAmt.Text.Trim()) * 100) / Util.GetDecimal(txtRate1.Text.Trim()), 2);
                dr["Discount"] = Percent;
                dr["discAmt"] = Util.GetDecimal(txtDiscAmt.Text.Trim());
            }
            else
            {
                dr["Discount"] = Util.GetDouble(txtDiscount1.Text.Trim());
                dr["discAmt"] = Util.GetDecimal(taxCalculation.Split('#')[2].ToString());
            }

            dr["Rate"] = Util.GetDouble(txtRate1.Text.Trim());


            dr["NetAmount"] = Util.GetDecimal(taxCalculation.Split('#')[0].ToString());
            dr["taxAmount"] = Util.GetDecimal(taxCalculation.Split('#')[1].ToString());
            dr["Amount"] = Util.GetDecimal(taxCalculation.Split('#')[3].ToString());
            dr["UnitPrice"] = Util.GetDecimal(taxCalculation.Split('#')[4].ToString());
            //GST Changes
            dr["igstTaxAmt"] = Util.GetDecimal(taxCalculation.Split('#')[8].ToString());
            dr["cgstTaxAmt"] = Util.GetDecimal(taxCalculation.Split('#')[9].ToString());
            dr["sgstTaxAmt"] = Util.GetDecimal(taxCalculation.Split('#')[10].ToString());

            dr["SpecialDiscPer"] = SpecialDiscPer;
            dr["SpecialDiscAmt"] = Util.GetDecimal(taxCalculation.Split('#')[11].ToString());


        }



        if (rblTaxCal.SelectedValue == "ExciseAmt")
        {
            dr["ExciseAmt"] = Util.GetDecimal(taxCalculation.Split('#')[6].ToString());
            dr["ExcisePer"] = Util.GetDecimal(taxCalculation.Split('#')[7].ToString());
        }
        else
        {
            dr["ExciseAmt"] = 0;
            dr["ExcisePer"] = 0;
        }


        dr["SaleTaxPer"] = DropDownList2.SelectedItem.Value;
        if (txtDeal.Text == string.Empty)
            dr["AMT"] = Util.GetDouble(Util.GetDouble(txtQuantity1.Text.Trim()) * Util.GetDouble(txtRate1.Text.Trim()));
        else
        {
            int deal = Util.GetInt(txtDeal.Text) + Util.GetInt(txtDeal1.Text);
            Double rate2 = Util.GetDouble(Util.GetDouble(Util.GetDouble(txtQuantity1.Text.Trim()) * Util.GetDouble(txtRate1.Text.Trim())) / Util.GetDouble(deal));
            dr["AMT"] = Math.Round(Util.GetDouble(rate2 * Util.GetDouble(txtDeal.Text)), 2);
            dr["deal"] = txtDeal.Text;
            dr["deal1"] = txtDeal1.Text;
            dr["totaldeal"] = deal.ToString();
            dr["DealTotal"] = txtDeal.Text + "+" + txtDeal1.Text;
        }
        if (rbtnFree.SelectedItem.Text.ToUpper() == "YES")
        {
            dr["AMT"] = 0;
        }
        dr["TaxCalculateOn"] = Util.GetString(rblTaxCal.SelectedItem.Value);

        dtItem.Rows.Add(dr);
        dtItem.AcceptChanges();
        Clear();
        ViewState["ITEM"] = dtItem;
        BindGrid();
        txtSearch.Text = string.Empty;
        txtSearch.Focus();
        ddlTAX1.SelectedIndex = ddlTAX1.Items.IndexOf(ddlTAX1.Items.FindByValue("T3"));
        txtExpDate1.Text = "";
        //txtTAX1.Text = "5";



    }
    public void BindDepartment()
    {
        ddlDeptLedgerNo.DataSource = StockReports.GetDataTable("SELECT LedgerNumber,LedgerName FROM f_ledgermaster WHERE GroupID='DPT'");
        ddlDeptLedgerNo.DataTextField = "LedgerName";
        ddlDeptLedgerNo.DataValueField = "LedgerNumber";
        ddlDeptLedgerNo.DataBind();
        ddlDeptLedgerNo.Items.Insert(0, "Select");

    }
    protected void Clear()
    {
        txtMRP1.Text = string.Empty;
        txtBatchNo1.Text = string.Empty;
        txtRate1.Text = string.Empty;
        txtQuantity1.Text = string.Empty;
        txtTAX1.Text = string.Empty;
        txtDiscount1.Text = string.Empty;
        txtDiscAmt.Text = string.Empty;
        ddlTAX1.SelectedIndex = 0;
        rbtnFree.SelectedIndex = 1;
        txtDeal.Text = string.Empty;
        txtDeal1.Text = string.Empty;
        txtExcisePer.Text = string.Empty;
        txtSpclDisc.Text = string.Empty;
        txtSpclDiscAmt.Text = string.Empty;
    }
    protected void GetNetAmount()
    {
        decimal NetAmount = 0;
        foreach (GridViewRow row in gvPODetails.Rows)
        {
            string aaaa = Util.GetString(((Label)row.FindControl("lbldeal")).Text);
            string bbbb = ((Label)row.FindControl("lblTAX")).Text;
            //if (Util.GetString(((Label)row.FindControl("lbldeal")).Text) != string.Empty)
            //{
            //    int deal = Util.GetInt(((Label)row.FindControl("lbldeal")).Text) + Util.GetInt(((Label)row.FindControl("lbldeal1")).Text);
            //    Double rate2 = Util.GetDecimal(Util.GetDecimal(((Label)row.FindControl("lblRate")).Text.Trim()) * Util.GetDecimal(((Label)row.FindControl("lblRecQty")).Text.Trim()) / Util.GetDouble(deal));
            //    double amt1 = Math.Round(Util.GetDouble(rate2 * Util.GetDouble(((Label)row.FindControl("lbldeal")).Text)), 2);
            //    amt1 = amt1 * (100 - Util.GetDecimal(((Label)row.FindControl("lblDiscount")).Text.Trim())) * 0.01;
            //    double bb = (amt1 * (100 + Util.GetDecimal(((Label)row.FindControl("lblTAX")).Text)) * 0.01);
            //    NetAmount += Math.Round(bb, 2);
            //}
            //else
            //{
            //    double aa = Util.GetDecimal(Util.GetDecimal(((Label)row.FindControl("lblRate")).Text.Trim()) * Util.GetDecimal(((Label)row.FindControl("lblRecQty")).Text.Trim()));
            //    aa = aa * (100 - Util.GetDecimal(((Label)row.FindControl("lblDiscount")).Text.Trim())) * 0.01;
            //    double bb = (aa * (100 + Util.GetDecimal(((Label)row.FindControl("lblTAX")).Text)) * 0.01);
            //    NetAmount += Math.Round(bb, 2);
            //}
            if (((Label)row.FindControl("lblFreeStatus")).Text == "No")
            {
                NetAmount += Util.GetDecimal(((Label)row.FindControl("lblNetAmount")).Text);
            }
        }
        decimal TAmt = Math.Round(NetAmount + Util.GetDecimal(txtFreight.Text.Trim()) + Util.GetDecimal(txtOctori.Text.Trim()), 0);


        decimal roundOff = Util.GetDecimal(TAmt) - Util.GetDecimal(NetAmount);
        txtRoundOff.Text = roundOff + string.Empty;
        txtInvoiceAmount.Text = TAmt + string.Empty;
        lbl.Text = Math.Round(NetAmount, 2) + string.Empty;
    }
    //GST Changes
    protected void getTaxAmounts()
    {
        DataTable dt = (DataTable)ViewState["ITEM"];
        txtTotalIGST.Text = (Util.GetDecimal(dt.Compute("Sum(igstTaxAmt)", ""))).ToString();
        txtTotalCGST.Text = (Util.GetDecimal(dt.Compute("Sum(cgstTaxAmt)", ""))).ToString();
        txtTotalSGST.Text = (Util.GetDecimal(dt.Compute("Sum(sgstTaxAmt)", ""))).ToString();
    }
    protected void gvPODetails_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        DataTable DtItem = ((DataTable)ViewState["ITEM"]);
        DtItem.Rows[e.RowIndex].Delete();
        DtItem.AcceptChanges();
        ViewState["ITEM"] = DtItem;
        BindGrid();
        if (DtItem.Rows.Count == 0)
        {
            ViewState["ITEM"] = null;
            EnableControl();
        }

    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='DirectGRN.aspx';", true);

    }
    protected void lnkNewItems_Click(object sender, EventArgs e)
    {
        BindItem();
    }
    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        BindItem();
    }
    protected void gvPODetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            DataTable DtItem = ((DataTable)ViewState["ITEM"]);
            int RowIndex = int.Parse(e.CommandArgument.ToString());

            txtMRP1.Text = DtItem.Rows[RowIndex]["MRP"].ToString();
            txtBatchNo1.Text = DtItem.Rows[RowIndex]["BatchNo"].ToString();
            txtRate1.Text = DtItem.Rows[RowIndex]["Rate"].ToString();
            txtQuantity1.Text = DtItem.Rows[RowIndex]["Quantity"].ToString();
            if (((Label)gvPODetails.Rows[index].FindControl("lblTAXType")).Text.Trim() == "IGST")
            {
                txtIGST.Text = DtItem.Rows[RowIndex]["igstTaxPer"].ToString();

            }
            else if (((Label)gvPODetails.Rows[index].FindControl("lblTAXType")).Text.Trim() == "CGST&SGST")
            {

                txtCGSt.Text = DtItem.Rows[RowIndex]["cgstTaxPer"].ToString();
                txtSGST.Text = DtItem.Rows[RowIndex]["sgstTaxPer"].ToString();
            }
            else
            {
                txtTAX1.Text = DtItem.Rows[RowIndex]["TaxPer"].ToString();
            }

            txtDiscount1.Text = DtItem.Rows[RowIndex]["Discount"].ToString();
            ListBox1.SelectedIndex = ListBox1.Items.IndexOf(ListBox1.Items.FindByText(((Label)gvPODetails.Rows[index].FindControl("lblitemname")).Text));
            lblConFactor.Text = DtItem.Rows[RowIndex]["conversionFactor"].ToString();
            lblMajorUnit.Text = DtItem.Rows[RowIndex]["MajorUnit"].ToString();
            lblMinorUnit.Text = DtItem.Rows[RowIndex]["SaleUnit"].ToString();
            ddlTAX1.SelectedIndex = ddlTAX1.Items.IndexOf(ddlTAX1.Items.FindByValue(DtItem.Rows[RowIndex]["TaxID"].ToString()));
            if (DtItem.Rows[RowIndex]["ExpDate"].ToString() != "")
            {
                DateTime expDate = DateTime.ParseExact(DtItem.Rows[RowIndex]["ExpDate"].ToString(), "yyyy-MM-dd", null);
                txtExpDate1.Text = expDate.ToString("dd-MM-yyyy");
            }
            else
            {
                txtExpDate1.Text = "";
            }

            txtExcisePer.Text = DtItem.Rows[RowIndex]["ExcisePer"].ToString();
            txtDeal.Text = DtItem.Rows[RowIndex]["deal"].ToString();
            txtDeal1.Text = DtItem.Rows[RowIndex]["deal1"].ToString();
            txtSpclDisc.Text = DtItem.Rows[RowIndex]["SpecialDiscPer"].ToString();
            //txtSpclDiscAmt.Text = DtItem.Rows[RowIndex]["SpecialDiscAmt"].ToString();
            DtItem.Rows[RowIndex].Delete();
            DtItem.AcceptChanges();
            ViewState["ITEM"] = DtItem;
            BindGrid();
            if (DtItem.Rows.Count == 0)
            {
                ViewState["ITEM"] = null;
                EnableControl();
            }
        }

    }

    [WebMethod]
    public static string BindLedgerNameGrd(string ItemID)
    {
        StringBuilder str = new StringBuilder();
        str.Append("SELECT itm.ItemID,itm.TypeName AS ItemName,sm.name AS saltname,sm.unit,slt.ID,ifnull(slt.Quantity,'')Strength,ifnull(slt.Unit,'')strengthUnit  ");

        str.Append("FROM f_itemmaster itm INNER JOIN f_item_salt slt ON itm.ItemID=slt.ItemID INNER JOIN f_salt_master sm ON ");
        str.Append("sm.SaltID=slt.SaltID WHERE itm.ItemID='" + ItemID + "' and sm.IsActive=1 order by itm.TypeName");

        DataTable dt = StockReports.GetDataTable(str.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

}