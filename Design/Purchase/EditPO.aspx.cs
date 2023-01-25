using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Text;

public partial class Design_Purchase_EditPO : System.Web.UI.Page
{
    #region Event Handling

    protected void btnNarSave_Click(object sender, EventArgs e)
    {
        string str = "update f_purchaseorder set Narration = '" + txtNarration.Text + "' where PurchaseOrderNo = '" + lblNarPONo.Text + "'";

        if (StockReports.ExecuteDML(str))
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        try
        {
            string str = "SELECT  st.LedgerTransactionNo FROM f_stock st INNER JOIN f_po_store ps ";
            str += " ON st.LedgerTransactionNo = ps.LedgerTransactionNo inner join f_ledgertransaction lt on lt.`LedgerTransactionNo`=st.`LedgerTransactionNo` and lt.`IsCancel`=0 ";
            str += " WHERE  ps.PONumber='" + txtPONo.Text.Trim() + "'  GROUP BY ps.PONumber";

            str = StockReports.ExecuteScalar(str);

            if (str != "")
            {
                lblMsg.Text = "GRN No. : " + str.Replace("PSHHI", "").Replace("NPSHHI", "") + " is made against this PO No. Amendment can be possible";
                return;
            }

            GetOrderDetails();
            BindOrderDetails();
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
        }
    }

    protected void btnupdate_Click(object sender, EventArgs e)
    {
        if (UpdateItemDetails())
        {
            GetOrderDetails();
            BindOrderDetails();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void gvOrderDetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            string PDID = Util.GetString(e.CommandArgument);

            if (ViewState["dsItems"] != null)
            {
                DataSet ds = (DataSet)ViewState["dsItems"];
                if (ds.Tables.Contains("ItemsDetail"))
                {
                    DataRow[] row = ds.Tables["ItemsDetail"].Select("PurchaseOrderDetailID = '" + PDID + "'");
                    if (row.Length > 0)
                    {
                        lblPDID.Text = PDID;
                        lblItemID.Text = Util.GetString(row[0]["ItemID"]);
                        lblItemName.Text = Util.GetString(row[0]["ItemName"]);
                        lblPONO.Text = Util.GetString(row[0]["PurchaseOrderNo"]);
                        lblQty.Text = Util.GetString(row[0]["ApprovedQty"]);
                        txtDiscount.Text = Util.GetString(row[0]["Discount_p"]);
                        txtPrice.Text = Util.GetString(row[0]["Rate"]);
                        if (Util.GetString(row[0]["Deal"]) != "")
                        {
                            txtDeal1.Text = Util.GetString(row[0]["Deal"]).Split('+')[0];
                            txtDeal2.Text = Util.GetString(row[0]["Deal"]).Split('+')[1];
                        }
                        txtHSNCode.Text = Util.GetString(row[0]["HSNCode"]);
                        if (Util.GetString(row[0]["GSTType"]) == "IGST")
                        {
                            ddlGSTType.SelectedIndex = ddlGSTType.Items.IndexOf(ddlGSTType.Items.FindByValue("T4"));
                            txtIGSTPer.Enabled = true;
                            txtIGSTPer.Text = Util.GetString(row[0]["IGSTPercent"]);
                            txtCGSTPer.Text = txtSGSTPer.Text = "0.00";
                            txtCGSTPer.Enabled = txtSGSTPer.Enabled = false;
                        }
                        else if (Util.GetString(row[0]["GSTType"]) == "CGST&UTGST")
                        {
                            ddlGSTType.SelectedIndex = ddlGSTType.Items.IndexOf(ddlGSTType.Items.FindByValue("T7"));
                            txtIGSTPer.Enabled = false;
                            txtIGSTPer.Text = "0.00";
                            txtCGSTPer.Text = Util.GetString(row[0]["CGSTPercent"]);
                            txtSGSTPer.Text = Util.GetString(row[0]["SGSTPercent"]);
                            txtCGSTPer.Enabled = txtSGSTPer.Enabled = true;
                        }
                        else
                        {
                            ddlGSTType.SelectedIndex = ddlGSTType.Items.IndexOf(ddlGSTType.Items.FindByValue("T6"));
                            txtIGSTPer.Enabled = false;
                            txtIGSTPer.Text = "0.00";
                            txtCGSTPer.Text = Util.GetString(row[0]["CGSTPercent"]);
                            txtSGSTPer.Text = Util.GetString(row[0]["SGSTPercent"]);
                            txtCGSTPer.Enabled = txtSGSTPer.Enabled = true;

                        }
                        mpUpdate.Show();
                    }
                }
            }
        }
    }

    protected void gvOrderDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row != null)
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string PDID = ((Label)e.Row.FindControl("lblPDID")).Text.Trim();

                DataTable dtTax = new DataTable();
                dtTax = BindTax(PDID);

                if ((dtTax != null) && (dtTax.Rows.Count > 0))
                {
                    Repeater rpTax = (Repeater)e.Row.FindControl("rpTax");
                    rpTax.DataSource = dtTax;
                    rpTax.DataBind();
                }
            }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        ViewState["EmployeeID"] = Session["ID"].ToString();
        if (!IsPostBack)
        {
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            bindTax();
        }
    }

    #endregion Event Handling

    #region Bind Data

    private void BindOrderDetails()
    {
        if (ViewState["dsItems"] != null)
        {
            DataSet dsItems = (DataSet)ViewState["dsItems"];
            if (dsItems.Tables.Contains("ItemsDetail"))
            {
                gvOrderDetail.DataSource = dsItems.Tables["ItemsDetail"];
                gvOrderDetail.DataBind();
            }
            else
            {
                gvOrderDetail.DataSource = null;
                gvOrderDetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        else
        {
            gvOrderDetail.DataSource = null;
            gvOrderDetail.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }

    private DataTable BindTax(string PDID)
    {
        if (ViewState["dsItems"] != null)
        {
            DataSet ds = (DataSet)ViewState["dsItems"];
            if (ds.Tables.Contains("TaxDetail"))
            {
                DataTable dtTax = ds.Tables["TaxDetail"].Clone();
                DataRow[] row = ds.Tables["TaxDetail"].Select("PODetailID = '" + PDID + "'");
                if (row.Length > 0)
                    foreach (DataRow dr in row)
                        dtTax.LoadDataRow(dr.ItemArray, true);
                return dtTax;
            }
            return null;
        }
        return null;
    }

    private void GetOrderDetails()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select pd.PurchaseOrderDetailID,po.Narration,pd.PurchaseOrderNo,pd.ItemName,pd.ApprovedQty,pd.RecievedQty,");
            sb.Append(" pd.Rate,pd.Discount_p,pd.ItemID,if(pd.IsFree = 1,'true','false')Free,po.VendorName,pd.`GSTType`,ifnull(pd.`HSNCode`,'') 'HSNCode',pd.`VATPer` 'GSTPer',pd.`VATAmt` 'GSTAmt',ifnull(pd.`IsDeal`,'') 'Deal',pd.`CGSTPercent`,pd.`SGSTPercent`,pd.`IGSTPercent` from f_purchaseorderdetails pd inner join f_purchaseorder po");
            sb.Append(" on pd.PurchaseOrderNo = po.PurchaseOrderNo where po.Approved = 2 and pd.PurchaseOrderNo = '" + txtPONo.Text.Trim() + "'");

            DataTable dtItems = new DataTable();
            dtItems = StockReports.GetDataTable(sb.ToString());

            if (dtItems.Rows.Count > 0)
            {


                DataSet ds = new DataSet();
                ds.Tables.Add(dtItems.Copy());
                ds.Tables[0].TableName = "ItemsDetail";


                ViewState["dsItems"] = ds;

                lblNarPONo.Text = Util.GetString(dtItems.Rows[0]["PurchaseOrderNo"]);
                txtNarration.Text = Util.GetString(dtItems.Rows[0]["Narration"]);
                btnNarration.Enabled = true;
            }
            else
            {
                if (ViewState["dsItems"] != null)
                    ViewState.Remove("dsItems");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                btnNarration.Enabled = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
        }
    }

    private void bindTax()
    {

        DataTable dt = StockReports.GetDataTable(" select TaxName,TaxID from f_taxmaster where TaxID in ('T4','T6','T7') ");
        ddlGSTType.DataSource = dt;
        ddlGSTType.DataTextField = "TaxName";
        ddlGSTType.DataValueField = "TaxID";
        ddlGSTType.DataBind();

    }

    #endregion Bind Data

    #region Update Items Details

    private bool UpdateItemDetails()
    {
        decimal UnitPrice = 0;
       

        string PDID = lblPDID.Text.Trim();

        DataTable TaxTable = new DataTable();
        TaxTable.Columns.Add("TaxID");
        TaxTable.Columns.Add("TaxAmt");
        TaxTable.Columns.Add("TaxPer");
        int Result1 = 0;

        MySqlConnection con = Util.GetMySqlCon();
        if (con.State == ConnectionState.Closed)
            con.Open();

        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select * from f_invoicemaster where PONumber='" + lblPONO.Text + "' ");
            DataTable dtGrn = StockReports.GetDataTable(sb.ToString());
            if (dtGrn.Rows.Count > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM243','" + lblMsg.ClientID + "');", true);
                tnx.Rollback();
                con.Close();
                con.Dispose();
                return false;
            }

            string Amount = "update f_purchaseorderpurchaserequest set OrderedQty='" + lblQty.Text + "'  where POPurchaseRequestID='" + lblPDID.Text + "' and itemid='" + lblItemID.Text + "'";
            int Amount1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Amount);
            if (Amount1 < 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                tnx.Rollback();
                con.Close();
                con.Dispose();
                return false;
            }
            string Amt = "update f_PurchaseOrderDetails set ApprovedQty='" + lblQty.Text + "'  where PurchaseOrderDetailID='" + lblPDID.Text + "' and itemid='" + lblItemID.Text + "'";
            int Amt1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Amt);
            if (Amt1 < 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                tnx.Rollback();
                con.Close();
                con.Dispose();
                return false;
            }
            decimal rate = Util.GetDecimal(txtPrice.Text);
            decimal Qty = Util.GetDecimal(lblQty.Text);
            decimal DiscPercent = Util.GetDecimal(txtDiscount.Text);
            //Deal Work
            decimal rate1 = rate;
            decimal deal1 = 0;
            decimal deal2 = 0;
            decimal IGSTAmt = 0;
            decimal CGSTAmt = 0;
            decimal SGSTAmt = 0;
            string isDeal=string.Empty;

            if (txtDeal1.Text.Trim() != string.Empty)
            {
                int deal = Util.GetInt(txtDeal1.Text.Trim()) + Util.GetInt(txtDeal2.Text.Trim());
                rate1 = Util.GetDecimal(Util.GetDouble(Util.GetDecimal(Qty) * Util.GetDecimal(rate)) / Util.GetDouble(deal));
                deal1 = Util.GetDecimal(txtDeal1.Text.Trim());
                deal2 = Util.GetDecimal(txtDeal2.Text.Trim());
                isDeal=txtDeal1.Text.Trim()+"+"+txtDeal2.Text.Trim();
            }
            List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
          {          
             new TaxCalculation_DirectGRN {DiscAmt=Util.GetDecimal(0), DiscPer=Util.GetDecimal(txtDiscount.Text), MRP=Util.GetDecimal(0),Quantity = Qty,Rate=rate1,TaxPer =Util.GetDecimal(txtIGSTPer.Text) + Util.GetDecimal(txtCGSTPer.Text) + Util.GetDecimal(txtSGSTPer.Text),Type = "RateAD",IGSTPrecent=Util.GetDecimal(txtIGSTPer.Text.Trim()),CGSTPercent=Util.GetDecimal(txtCGSTPer.Text.Trim()),SGSTPercent=Util.GetDecimal(txtSGSTPer.Text.Trim()),deal =Util.GetDecimal(deal1),deal2= Util.GetDecimal(deal2),ActualRate=Util.GetDecimal(rate)}
           };
            //
            Amt = AllLoadData_Store.taxCalulation(taxCalculate);

            rate = Math.Round(rate, 2, MidpointRounding.AwayFromZero);
            decimal newAmount = Math.Round((rate * Util.GetDecimal(Qty)), 2, MidpointRounding.AwayFromZero);

            
            UnitPrice = Util.GetDecimal(Amt.Split('#')[4].ToString());


            IGSTAmt = Util.GetDecimal(Amt.Split('#')[8].ToString());
            CGSTAmt = Util.GetDecimal(Amt.Split('#')[9].ToString());
            SGSTAmt = Util.GetDecimal(Amt.Split('#')[10].ToString());
            decimal totalGST = Math.Round(Util.GetDecimal(txtCGSTPer.Text) + Util.GetDecimal(txtSGSTPer.Text) + Util.GetDecimal(txtIGSTPer.Text), 4);
            decimal totalGSTAmt=Math.Round(IGSTAmt+CGSTAmt+SGSTAmt,4);
            
            decimal roundOff = Util.GetDecimal(Math.Round((Math.Round(newAmount, 0, MidpointRounding.AwayFromZero) - Util.GetDecimal((Math.Round(newAmount, 2, MidpointRounding.AwayFromZero)))), 2, MidpointRounding.AwayFromZero));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL usp_POAmended(" + PDID + ",'" + lblPONO.Text.Trim() + "'," + Util.GetDecimal(txtPrice.Text.Trim()) + "," + Util.GetDecimal(txtDiscount.Text.Trim()) + "," + UnitPrice + "," + Util.GetDecimal(UnitPrice * Qty) + ",'" + txtComments.Text.Trim() + "','','','" + ViewState["EmployeeID"].ToString() + "','" + Request.UserHostAddress + "','" + roundOff.ToString() + "','"+totalGST+"','"+totalGSTAmt+"','"+txtHSNCode.Text.Trim()+"','"+Util.GetDecimal(txtIGSTPer.Text.Trim())+"','"+IGSTAmt+"','"+Util.GetDecimal(txtCGSTPer.Text.Trim())+"','"+CGSTAmt+"','"+Util.GetDecimal(txtSGSTPer.Text.Trim())+"','"+SGSTAmt+"','"+ddlGSTType.SelectedItem.Text+"','"+isDeal+"');");

            //*********************According to Deep Store In charge PO Amendent should not be after any single Item Received

            //StringBuilder strGRN = new StringBuilder();
            //strGRN.Append("select ps.LedgerTransactionNo,ps.StockID,ltd.ID LedgerTnxID, ps.Qty  from f_po_store ps ");
            //strGRN.Append(" inner join f_ledgertnxdetail ltd on ps.LedgerTransactionNo = ltd.LedgerTransactionNo");
            //strGRN.Append(" and ps.StockId = ltd.StockID where ps.PODetailID = '" + PDID + "'");

            //DataTable dtGRN = new DataTable();
            //dtGRN = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, strGRN.ToString()).Tables[0];

            //if (dtGRN.Rows.Count > 0)
            //{
            //    foreach (DataRow drGrn in dtGRN.Rows)
            //    {
            //        string StockID = Util.GetString(drGrn["StockID"]);
            //        string GRNNo = Util.GetString(drGrn["LedgerTransactionNo"]);
            //        decimal GRNAmount = UnitPrice * (Util.GetDecimal(drGrn["Qty"]));
            //        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL usp_StoreGRNUpdate('" + GRNNo + "','" + Util.GetString(drGrn["LedgerTnxID"]) + "','" + StockID + "'," + Util.GetDecimal(txtPrice.Text.Trim()) + "," + Util.GetDecimal(txtDiscount.Text.Trim()) + "," + GRNAmount + "," + UnitPrice + ");");
                    

                   
                  

            //    }
            //}
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return true;
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return false;
        }
    }

    #endregion Update Items Details
}
