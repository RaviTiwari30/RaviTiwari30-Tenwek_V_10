using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_CSSD_IssueToDepartmentFromCssd : System.Web.UI.Page
{
    public void LoadStock()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("     SELECT CONCAT(im.ItemID,'#',im.UnitType)ItemId,  CONCAT(CAST(im.typename AS CHAR),' # (',CAST(im.typename AS CHAR),') # ',CAST((ctnx.Quantity-ctnx.ReleaseQuantity) AS CHAR(500)),'#',0)    itemname    ");
        sb.Append("     FROM f_configrelation cf    INNER JOIN f_subcategorymaster sc ON   cf.CategoryID = sc.CategoryID INNER JOIN f_itemmaster im   ");
        sb.Append("     ON sc.SubCategoryID = im.SubCategoryID     INNER JOIN f_stock s ON s.ItemID = im.ItemID AND    s.DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "'     ");
        sb.Append("    INNER JOIN cssd_f_batch_tnxdetails ctnx ON s.stockid=ctnx.stockid    AND ctnx.isprocess=2 AND ctnx.isset=0     ");
        sb.Append("     WHERE cf.ConfigRelationID=11 AND ctnx.Quantity > 0    GROUP BY im.ItemID           ");
        sb.Append("     UNION ALL          ");

        sb.Append("     SELECT CONCAT(t.setid,'#','')ItemId,CONCAT(t.SetName,' # (','It Is A Set',') # ', COUNT(*),'#',1)itemname FROM (   ");
        sb.Append("     SELECT cst.SetID,cst.SetName,cst.SetStockID,SUM(cst.ReceivedQty)ReceivedQty,SUM(cst.ReturnedQty)ReturnedQty,SUM(ctnx.Quantity)Quantity,ctnx.IsProcess,(s.InitialCount-s.ReleasedCount)qty  FROM f_configrelation cf         ");
        sb.Append("     INNER JOIN f_subcategorymaster sc ON  cf.CategoryID = sc.CategoryID INNER JOIN f_itemmaster im        ");
        sb.Append("     ON sc.SubCategoryID = im.SubCategoryID INNER JOIN f_stock s ON s.ItemID = im.ItemID  AND s.DeptLedgerNo =  '" + ViewState["DeptLedgerNo"].ToString() + "'     ");
        sb.Append("     INNER JOIN cssd_stock_setstock css  ON css.StockID=s.StockID INNER JOIN cssd_recieve_Set_stock cst ON css.StockID=cst.StockID AND css.SetStockID=cst.SetStockID INNER JOIN cssd_f_batch_tnxdetails     ");
        sb.Append("     ctnx ON cst.ID=ctnx.SetTnxID AND ctnx.IsProcess=2 AND ctnx.isset=1 WHERE cst.isactive=1 AND  cst.IsReturned=0     AND IsSetMaster=1    AND IsProcessBatch=1 AND IsUpdateBatch=1        ");
        sb.Append("     GROUP BY cst.setstockid)t GROUP BY setid   ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

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
                    if (((Label)row.FindControl("lblIsSet")).Text == "0")
                    {
                        DataRow dr = dt.NewRow();
                        dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                        dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                        dr["BatchNumber"] = ((Label)row.FindControl("lblBatchNumber")).Text;
                        dr["UnitPrice"] = Util.GetFloat(((Label)row.FindControl("lblUnitPrice")).Text);
                        dr["SubCategoryID"] = ((Label)row.FindControl("lblSubCategoryID")).Text;
                        float Qty = Util.GetFloat(((TextBox)row.FindControl("txtIssueQty")).Text);
                        dr["IssueQty"] = Qty;
                        dr["Qty"] = Util.GetFloat(((Label)row.FindControl("lblAvailQty")).Text);
                        dr["StockID"] = ((Label)row.FindControl("lblStockID")).Text;
                        dr["Unit"] = ((Label)row.FindControl("lblUnitType")).Text;
                        dr["MedExpiryDate"] = ((Label)row.FindControl("lblMedExpiryDate")).Text;
                        dr["IsSet"] = 0;
                        dr["SetStockID"] = "";
                        dr["IsSet"] = 0;
                        dr["SetID"] = "";
                        dr["TnxID"] = ((Label)row.FindControl("lblTnxID")).Text;

                        //for MRP and Tax Calculation
                        float MRP = Util.GetFloat(((Label)row.FindControl("lblMRP")).Text);
                        dr["TaxableMRP"] = MRP;
                        float TaxPer = Util.GetFloat(((Label)row.FindControl("lblTax")).Text);
                        dr["Tax"] = TaxPer;
                        //float NonTaxableRate = MRP - ((MRP * TaxPer) / 100);
                        float NonTaxableRate = (MRP * 100) / (100 + TaxPer);
                        float Discount = 0;
                        float DiscountedRate = NonTaxableRate;
                        float NetRate = DiscountedRate + ((DiscountedRate * TaxPer) / 100);

                        float Amount = NetRate * Qty;

                        dr["MRP"] = NonTaxableRate;
                        dr["Discount"] = 0;
                        dr["DiscountAmt"] = Discount * Qty;
                        dr["GrossAmount"] = Amount;
                        dt.Rows.Add(dr);
                    }
                    else
                    {
                        StringBuilder sb = new StringBuilder();

                        sb.Append("  SELECT t1.*,t2.tax FROM(SELECT st.StockID, st.ItemID, st.ItemName, st.BatchNumber, st.SubCategoryID, st.UnitPrice, ");
                        sb.Append("  st.MRP,DATE_FORMAT( st.MedExpiryDate,'%d-%b-%Y')MedExpiryDate, (ctnx.Quantity)AvailQty,UnitType,1 IsSet,ctnx.id TnxID  ");
                        sb.Append("  FROM f_stock st INNER JOIN cssd_stock_setstock css ON css.StockID=st.StockID  INNER JOIN  cssd_recieve_Set_stock cst  ON css.SetStockID=cst.SetStockID AND css.StockID=cst.StockID INNER JOIN cssd_f_batch_tnxdetails ctnx ON  ctnx.StockID=st.StockID AND ctnx.SetStockID=css.SetStockID  ");
                        sb.Append("  AND ctnx.isprocess=2 AND ctnx.isset=1  WHERE ctnx.SetStockID='" + ((Label)row.FindControl("lblSetStockID")).Text + "' AND ctnx.Quantity>0 AND  ");
                        sb.Append("   st.Ispost=1 AND  st.DeptLedgerNo =  '" + ViewState["DeptLedgerNo"].ToString() + "' ORDER BY stockid)t1  ");
                        sb.Append(" LEFT JOIN (SELECT SUM(tc.perCentage)Tax,tc.StockID FROM f_taxchargedlist tc WHERE tc.ItemID IN  ");
                        sb.Append(" (SELECT itemid FROM cssd_recieve_set_stock WHERE SetStockID='" + ((Label)row.FindControl("lblSetStockID")).Text + "' )  GROUP BY tc.stockid)T2 ON t1.stockid = t2.stockid ");

                        DataTable dtSetStock = StockReports.GetDataTable(sb.ToString());
                        if (dtSetStock.Rows.Count > 0)
                        {
                            foreach (DataRow drSetStock in dtSetStock.Rows)
                            {
                                DataRow dr = dt.NewRow();
                                dr["ItemID"] = Util.GetString(drSetStock["ItemID"]);
                                dr["ItemName"] = Util.GetString(drSetStock["ItemName"]);
                                dr["BatchNumber"] = Util.GetString(drSetStock["BatchNumber"]);
                                dr["UnitPrice"] = Util.GetFloat(drSetStock["UnitPrice"].ToString());
                                dr["SubCategoryID"] = Util.GetString(drSetStock["SubCategoryID"]);
                                float Qty = Util.GetFloat(drSetStock["AvailQty"].ToString());
                                dr["IssueQty"] = Qty;
                                dr["Qty"] = Util.GetFloat(drSetStock["AvailQty"].ToString());
                                dr["StockID"] = Util.GetString(drSetStock["StockID"].ToString());
                                dr["Unit"] = Util.GetString(drSetStock["UnitType"].ToString());
                                dr["MedExpiryDate"] = Util.GetDateTime(drSetStock["MedExpiryDate"].ToString());
                                dr["IsSet"] = 1;
                                dr["SetStockID"] = ((Label)row.FindControl("lblSetStockID")).Text;
                                dr["SetID"] = ((Label)row.FindControl("lblItemID")).Text;
                                dr["TnxID"] = Util.GetString(drSetStock["TnxID"].ToString());

                                //for MRP and Tax Calculation
                                float MRP = Util.GetFloat(drSetStock["MRP"].ToString());
                                dr["TaxableMRP"] = MRP;
                                float TaxPer = Util.GetFloat(drSetStock["tax"].ToString());
                                dr["Tax"] = TaxPer;
                                //float NonTaxableRate = MRP - ((MRP * TaxPer) / 100);
                                float NonTaxableRate = (MRP * 100) / (100 + TaxPer);
                                float Discount = 0;
                                float DiscountedRate = NonTaxableRate;
                                float NetRate = DiscountedRate + ((DiscountedRate * TaxPer) / 100);

                                float Amount = NetRate * Qty;

                                dr["MRP"] = NonTaxableRate;
                                dr["Discount"] = 0;
                                dr["DiscountAmt"] = Discount * Qty;
                                dr["GrossAmount"] = Amount;
                                dt.Rows.Add(dr);
                            }
                        }
                    }
                }
            }
            dt.AcceptChanges();
            ViewState["StockTransfer"] = dt;

            grdItemDetails.DataSource = dt;
            grdItemDetails.DataBind();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["IsSet"].ToString() == "1")
                {
                    grdItemDetails.Columns[10].Visible = false;
                }
                else
                {
                    grdItemDetails.Columns[10].Visible = true;
                }
            }
            grdItem.DataSource = null;
            grdItem.DataBind();
            txtSearch.Text = "";
            txtSearch.Focus();
        }
    }

    protected void btnOKRejection_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (lblIsset.Text == "1")
            {
                string str = "update cssd_recieve_Set_stock set returnedqty=SetQuantity where setid='" + lblItemid.Text + "' and stockid='" + lblStockid.Text + "'";
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, str);
                string strdlt = "update cssd_f_batch_tnxdetails set isprocess=4,RejectReason='" + txtCancelReason.Text.ToString() + "' where SetStockID='" + lblSetStockID.Text + "' ";
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, strdlt);
            }
            else
            {
                string strdlt = "update cssd_f_batch_tnxdetails set isprocess=4,RejectReason='" + txtCancelReason.Text.ToString() + "' where id='" + lblId.Text + "' and stockid='" + lblStockid.Text + "' ";
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, strdlt);
            }

            tnx.Commit();

            LoadStock();
            grdItem.DataSource = null;
            grdItem.DataBind();
            pnlHide.Visible = false;
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddlDept.SelectedIndex == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
            return;
        }
        DataTable dtItem = null;

        if (ViewState["StockTransfer"] != null)
        {
            dtItem = (DataTable)ViewState["StockTransfer"];
            if (dtItem.Rows.Count == 0)
            {
                lblMsg.Text = "Please Add Item";
                btnAddItem.Focus();
                return;
            }
            lblMsg.Text = "";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

            //string strSales = "select max(salesno) from f_salesdetails where TrasactionTypeID = 1";


            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranx, CommandType.Text, "select Get_SalesNo('1','" + AllGlobalFunction.MedicalStoreID + "','" + Session["CentreID"].ToString() + "') "));

            for (int i = 0; i < dtItem.Rows.Count; i++)
            {
                Sales_Details ObjSales = new Sales_Details(tranx);
                ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjSales.LedgerNumber = ddlDept.SelectedItem.Value;
                ObjSales.DepartmentID = "STO00001";
                ObjSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                ObjSales.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                ObjSales.SoldUnits = Util.GetFloat(dtItem.Rows[i]["IssueQty"]);
                ObjSales.PerUnitBuyPrice = Util.GetFloat(dtItem.Rows[i]["UnitPrice"]);
                ObjSales.PerUnitSellingPrice = Util.GetFloat(dtItem.Rows[i]["TaxableMRP"]);
                ObjSales.Date = DateTime.Now;
                ObjSales.Time = DateTime.Now;
                ObjSales.IsReturn = 0;
                ObjSales.LedgerTransactionNo = "";
                ObjSales.TrasactionTypeID = 1;
                ObjSales.IsService = "NO";
                ObjSales.IndentNo = txtIndent.Text.Trim();
                ObjSales.SalesNo = SalesNo;
                ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                ObjSales.UserID = ViewState["ID"].ToString();
                ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                string SalesID = ObjSales.Insert();
                if (SalesID == string.Empty)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    return;
                }

                Stock objStock = new Stock(tranx);
                objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objStock.InitialCount = Util.GetFloat(dtItem.Rows[i]["IssueQty"]);
                objStock.BatchNumber = Util.GetString(dtItem.Rows[i]["BatchNumber"]);
                objStock.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                objStock.ItemName = Util.GetString(dtItem.Rows[i]["ItemName"]);
                objStock.DeptLedgerNo = ddlDept.SelectedItem.Value;
                objStock.IsFree = 0;
                objStock.IsPost = 1;
                objStock.MRP = Util.GetFloat(dtItem.Rows[i]["TaxableMRP"]);
                objStock.StockDate = DateTime.Now;
                objStock.Unit = Util.GetString(dtItem.Rows[i]["Unit"]);
                objStock.SubCategoryID = Util.GetString(dtItem.Rows[i]["SubCategoryID"]);
                objStock.UnitPrice = Util.GetFloat(dtItem.Rows[i]["UnitPrice"]);
                objStock.IsCountable = 1;
                objStock.IsReturn = 0;
                objStock.FromDept = ViewState["DeptLedgerNo"].ToString();
                objStock.FromStockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                objStock.IndentNo = Util.GetString(txtIndent.Text.Trim());
                objStock.MedExpiryDate = Util.GetDateTime(dtItem.Rows[i]["MedExpiryDate"]);
                objStock.RejectQty = 0;
                objStock.StoreLedgerNo = "STO00001";
                objStock.UserID = ViewState["ID"].ToString();
                objStock.SetStockID = Util.GetString(dtItem.Rows[i]["SetStockID"]);
                objStock.IsSet = Util.GetInt(dtItem.Rows[i]["IsSet"]);
                objStock.SetID = Util.GetInt(dtItem.Rows[i]["SetID"]);
                objStock.SetStockQty = Util.GetInt(dtItem.Rows[i]["IssueQty"]);
                objStock.IsSterlize = 1;
                objStock.PostDate = DateTime.Now;
                objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());
                string stokID = objStock.Insert();

                if (stokID == string.Empty)
                {
                    tranx.Rollback();
                    tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    return;
                }

                //----Check Release Count in Stock Table---------------------
                string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(dtItem.Rows[i]["IssueQty"]) + "),0,1)CHK from f_stock where stockID=" + Util.GetString(dtItem.Rows[i]["StockID"]);
                if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(tranx, CommandType.Text, sql)) <= 0)
                {
                    tranx.Rollback();
                    con.Close();
                    con.Dispose();
                    lblMsg.Text = "Quantity Not Available";
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    return;
                }

                //---- Update Release Count in Stock Table---------------------
                string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetFloat(dtItem.Rows[i]["IssueQty"]) + " where StockID = " + Util.GetString(dtItem.Rows[i]["StockID"]) + "";

                int flag = Util.GetInt(MySqlHelperNEw.ExecuteNonQuery(tranx, CommandType.Text, strStock));

                if (flag == 0)
                {
                    tranx.Rollback();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    return;
                }

                if (Util.GetString(dtItem.Rows[i]["IsSet"]) == "1")
                {
                    string strCssdTnx = "update cssd_f_batch_tnxdetails set IsProcess=3,Isreturn=1,ReturnDateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',ReturnBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE ID ='" + Util.GetString(dtItem.Rows[i]["TnxID"]) + "' ";
                    int CssdTnx = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strCssdTnx);

                    string strSetStock = " UPDATE cssd_recieve_set_stock SET ReturnedQty='" + Util.GetFloat(dtItem.Rows[i]["IssueQty"]) + "',IsReturned=1 WHERE SetStockID='" + Util.GetString(dtItem.Rows[i]["SetStockID"]) + "' and isactive=1 and itemid='" + Util.GetString(dtItem.Rows[i]["ItemID"]) + "' ";
                    int SetStock = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strSetStock);
                }
                else
                {
                    if ((Util.GetFloat(dtItem.Rows[i]["Qty"])) == (Util.GetFloat(dtItem.Rows[i]["IssueQty"])))
                    {
                        string strCssdTnx = "update cssd_f_batch_tnxdetails set IsProcess=3,Isreturn=1,ReleaseQuantity=ReleaseQuantity+'" + Util.GetFloat(dtItem.Rows[i]["IssueQty"]) + "',ReturnDateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',ReturnBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE ID ='" + Util.GetString(dtItem.Rows[i]["TnxID"]) + "' ";
                        int CssdTnx = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strCssdTnx);
                    }
                    else
                    {
                        string strCssdTnx = "update cssd_f_batch_tnxdetails set ReleaseQuantity=ReleaseQuantity+'" + Util.GetFloat(dtItem.Rows[i]["IssueQty"]) + "',ReturnDateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',ReturnBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE ID ='" + Util.GetString(dtItem.Rows[i]["TnxID"]) + "' ";
                        int CssdTnx = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strCssdTnx);
                    }
                }
            }
            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully, Issue No. : " + SalesNo + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='IssueToDepartmentFromCssd.aspx';", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        SearchItem();
    }

    protected void grdItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            txtCancelReason.Text = "";
            string strLtNo = Util.GetString(e.CommandArgument);
            string IsSurgery = strLtNo.Split('#')[1].ToUpper();

            lblId.Text = strLtNo.Split('#')[0].ToUpper();
            lblStockid.Text = IsSurgery;
            lblItemid.Text = strLtNo.Split('#')[2].ToString();
            lblIsset.Text = strLtNo.Split('#')[3].ToString();
            lblSetStockID.Text = strLtNo.Split('#')[4].ToString();
            mpeRejection.Show();
        }
    }

    protected void grdItem_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblIsSet")).Text == "1")
            {
                //  e.Row.BackColor = System.Drawing.Color.LightPink;
                e.Row.Attributes.Add("style", "background-color:lightpink");
            }
            else if (((Label)e.Row.FindControl("lblIsSet")).Text == "0")
            {
                e.Row.Attributes.Add("style", "background-color:#FF99CC");
            }
        }
    }

    protected void grdItemDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["StockTransfer"];
            dtItem.Rows[args].Delete();
            grdItemDetails.DataSource = dtItem;
            grdItemDetails.DataBind();
            dtItem.AcceptChanges();
            //lblTotalAmount.Text = Util.GetString(dtItem.Compute("sum(Grossamount)", ""));
            ViewState["StockTransfer"] = dtItem;
            if (dtItem.Rows.Count == 0)
            {
                pnlHide.Visible = false;
            }
            else
            {
                pnlHide.Visible = true;
            }
        }
    }

    protected void grdItemDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblIsSetNew")).Text == "1")
            {
                // e.Row.BackColor = System.Drawing.Color.LightPink;
                e.Row.Attributes.Add("style", "background-color:lightpink");
            }
            else
            {
                e.Row.Attributes.Add("style", "background-color:#FF99CC");
            }
            if (((Label)e.Row.FindControl("lblIsSetNew")).Text == "1")
            {
                ((Label)e.Row.FindControl("lblIsSetNew")).Text = "yes";
            }
            else
            {
                ((Label)e.Row.FindControl("lblIsSetNew")).Text = "NO";
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

            ViewState["LoginType"] = Session["LoginType"].ToString();

            ScriptManager1.SetFocus(ddlDept);
            BindDepartments();
            LoadStock();
            ScriptManager1.SetFocus(ddlDept);
            txtSearch.Focus();
        }
    }

    private void BindDepartments()
    {
        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' and LedgerNumber != '" + ViewState["DeptLedgerNo"].ToString() + "' ORDER BY LedgerName";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "LedgerName";
            ddlDept.DataValueField = "LedgerNumber";
            ddlDept.DataBind();
            lblMsg.Text = string.Empty;
            ddlDept.Items.Insert(0, "Select");

            ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByText("OR"));
        }
        else
        {
            ddlDept.Items.Clear();
            lblMsg.Text = "No Department Found";
        }

        int index = ddlDept.Items.IndexOf(ddlDept.Items.FindByText(ViewState["LoginType"].ToString()));
        if (index != -1)
        {
            ddlDept.Items[index].Selected = true;
            ddlDept.Items[index].Enabled = false;
        }
    }

    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT CONCAT(im.ItemID,'#',im.UnitType)ItemId,CONCAT(im.typename,' # (',im.TypeName,') # ',SUM(s.InitialCount-s.ReleasedCount))itemname FROM f_configrelation cf INNER JOIN f_subcategorymaster sc ON  ");
        sb.Append(" cf.CategoryID = sc.CategoryID INNER JOIN f_itemmaster im ON sc.SubCategoryID = im.SubCategoryID  ");
        sb.Append(" INNER JOIN f_stock s ON s.ItemID = im.ItemID AND s.DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' ");
        sb.Append(" WHERE cf.ConfigRelationID=11 AND s.InitialCount-s.ReleasedCount > 0  ");
        sb.Append(" GROUP BY im.ItemID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
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

    private DataTable GetItemDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("StockID");
        dt.Columns.Add("ItemID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNumber");
        dt.Columns.Add("SubCategoryID");
        dt.Columns.Add("MRP", typeof(float));
        dt.Columns.Add("TaxableMRP", typeof(float));
        dt.Columns.Add("Tax", typeof(float));
        dt.Columns.Add("UnitPrice", typeof(float));
        dt.Columns.Add("Qty", typeof(float));
        dt.Columns.Add("IssueQty", typeof(float));
        dt.Columns.Add("Discount", typeof(float));
        dt.Columns.Add("DiscountAmt", typeof(float));
        dt.Columns.Add("GrossAmount", typeof(float));
        dt.Columns.Add("Unit");
        dt.Columns.Add("MedExpiryDate");
        dt.Columns.Add("IsSet");
        dt.Columns.Add("SetStockID");
        dt.Columns.Add("SetID");
        dt.Columns.Add("TnxID");

        return dt;
    }

    private void SearchItem()
    {
        if (ListBox1.SelectedIndex != -1)
        {
            lblMsg.Text = "";
            StringBuilder sb = new StringBuilder();
            if (ListBox1.SelectedItem.Text.Split('#').GetValue(3).ToString() == "0")
            {
                sb.Append("select t1.*,t2.tax from(select ctnx.ID, '' SetStockID,s.StockID,s.ItemID,s.ItemName,s.BatchNumber,ctnx.BatchNo, s.SubCategoryID,s.UnitPrice,s.MRP,date_format(s.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,");
                sb.Append(" ((ctnx.Quantity-ctnx.ReleaseQuantity))AvailQty,s.UnitType,0 IsSet,ctnx.ID TnxID,(select ledgername from f_ledgermaster where ledgernumber=s.fromdept and groupid='DPT')FromDept,ctnx.BatchName,ctnx.BoilerName  from f_stock s inner join cssd_f_batch_tnxdetails ctnx on s.stockid=ctnx.stockid and ctnx.isprocess=2 and ctnx.isset=0  where s.ItemID='" + ListBox1.SelectedValue.Split('#').GetValue(0) + "' and (ctnx.Quantity)>0 and");
                sb.Append(" Ispost=1  and DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' order by s.stockid)t1 left join (select sum(tc.perCentage)Tax,tc.StockID");
                sb.Append(" from f_taxchargedlist tc where tc.ItemID = '" + ListBox1.SelectedValue.Split('#').GetValue(0) + "'  group by tc.stockid)T2");
                sb.Append(" on t1.stockid = t2.stockid");
                DataTable dt = StockReports.GetDataTable(sb.ToString());
                if (dt != null && dt.Rows.Count > 0)
                {
                    grdItem.DataSource = dt;
                    grdItem.DataBind();
                    pnlHide.Visible = true;
                    int TranferQty = Util.GetInt(txtTransferQty.Text.Trim());
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (TranferQty > Util.GetInt(dt.Rows[i]["AvailQty"]))
                        {
                            ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = Util.GetString(dt.Rows[i]["AvailQty"]);
                            ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                            TranferQty = TranferQty - Util.GetInt(dt.Rows[i]["AvailQty"]);
                        }
                        else
                        {
                            ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = TranferQty.ToString();
                            ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                            break;
                        }
                    }
                    btnAddItem.Focus();
                }
                else
                {
                    grdItem.DataSource = null;
                    grdItem.DataBind();
                }
            }
            else
            {
                // final chaka chak query

                sb.Append("     SELECT DATE_FORMAT(s.MedExpiryDate,'%d-%b-%Y')MedExpiryDate, ctnx.ID,cst.SetStockID,cst.StockID,cst.SetID,cst.SetID ItemID,cst.SetName ItemName,'' BatchNumber,'' SubCategoryID,'' UnitPrice,'' MRP,'' MedExpiryDate,1 AvailQty, ");
                sb.Append("       '' UnitType,1 IsSet,ctnx.ID TnxID,(SELECT ledgername FROM f_ledgermaster WHERE ledgernumber=s.fromdept  AND groupid='DPT')FromDept, ");
                sb.Append("       ctnx.batchno,ctnx.BatchName,ctnx.BoilerName,''tax  FROM f_configrelation cf       ");
                sb.Append("       INNER JOIN f_subcategorymaster sc ON  cf.CategoryID = sc.CategoryID INNER JOIN f_itemmaster im      ");
                sb.Append("      ON sc.SubCategoryID = im.SubCategoryID INNER JOIN f_stock s ON s.ItemID = im.ItemID  AND s.DeptLedgerNo =  '" + ViewState["DeptLedgerNo"].ToString() + "'   ");
                sb.Append("          INNER JOIN cssd_recieve_Set_stock cst ON s.StockID=cst.StockID  INNER JOIN cssd_stock_setstock css    ON css.SetStockID=cst.SetStockID  INNER JOIN cssd_f_batch_tnxdetails   ");
                sb.Append("      ctnx ON cst.ID=ctnx.SetTnxID AND ctnx.IsProcess=2 AND ctnx.isset=1  WHERE  css.SetID ='" + ListBox1.SelectedValue.Split('#').GetValue(0) + "' AND ctnx.Quantity>0 AND  cst.isactive=1 AND cst.IsReturned=0       ");
                sb.Append("       GROUP BY cst.setstockid ");

                DataTable dt = StockReports.GetDataTable(sb.ToString());
                if (dt != null && dt.Rows.Count > 0)
                {
                    grdItem.DataSource = dt;
                    grdItem.DataBind();
                    pnlHide.Visible = true;
                    int TranferQty = Util.GetInt(txtTransferQty.Text.Trim());
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (TranferQty > Util.GetInt(dt.Rows[i]["AvailQty"]))
                        {
                            ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = Util.GetString(dt.Rows[i]["AvailQty"]);
                            ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                            TranferQty = TranferQty - Util.GetInt(dt.Rows[i]["AvailQty"]);
                        }
                        else
                        {
                            ((TextBox)grdItem.Rows[i].FindControl("txtIssueQty")).Text = TranferQty.ToString();
                            ((CheckBox)grdItem.Rows[i].FindControl("chkSelect")).Checked = true;
                            break;
                        }
                    }
                    btnAddItem.Focus();
                }
                else
                {
                    grdItem.DataSource = null;
                    grdItem.DataBind();
                }
            }
        }
        else
        {
            lblMsg.Text = "Please Select Items";
            return;
        }
    }

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
                    string IsSet = ((Label)row.FindControl("lblIsSet")).Text;
                    string SetStockID = ((Label)row.FindControl("lblSetStockID")).Text;
                    DataRow[] drow = dt.Select("StockID = '" + stockID + "' and IsSet='" + IsSet + "' and SetStockID='" + SetStockID + "' ");
                    if (drow.Length > 0)
                    {
                        lblMsg.Text = "Item Already Selected";
                        return false;
                    }
                }

                float TransferQty = 0, AvailQty = 0;
                if (((TextBox)row.FindControl("txtIssueQty")).Text.Trim() != string.Empty)
                    TransferQty = Util.GetFloat(((TextBox)row.FindControl("txtIssueQty")).Text);
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM34','" + lblMsg.ClientID + "');", true);
                    return false;
                }
                if (TransferQty == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM249','" + lblMsg.ClientID + "');", true);
                    ((TextBox)row.FindControl("txtIssueQty")).Focus();
                    return false;
                }
                AvailQty = Util.GetFloat(((Label)row.FindControl("lblAvailQty")).Text);
                if (TransferQty > AvailQty)
                {
                    lblMsg.Text = "Requested Quantity is not Available";
                    return false;
                }
            }
        }
        if (status)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
            return false;
        }
        return true;
    }
}