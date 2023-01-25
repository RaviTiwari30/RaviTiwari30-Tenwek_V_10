using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;

public partial class Design_Purchase_PendingIndentItem : System.Web.UI.Page
{
    public void bindindent()
    {
        StringBuilder sb = new StringBuilder();
       
            sb.Append(" SELECT GROUP_CONCAT(IndentNo)indentno,GROUP_CONCAT(DeptFrom)DeptFrom,SUM(ReqQty)ReqQty,GROUP_CONCAT(IndentDate)IndentDate,");
            sb.Append(" GROUP_CONCAT(ReceiveQty)ReceiveQty,GROUP_CONCAT(RejectQty)RejectQty,GROUP_CONCAT(IndentRaiseBy)IndentRaiseBy,DeptFromID,ItemId,ItemName,");
            sb.Append(" AvailQty,rate,DiscAmt,TaxAmt,DiscPer,NetAmt,Vendorname,MajorUnit,ManuFacturer,ManufactureID,VendorID,SubCategoryID,TaxPer,TaxID,GenStock,SUM(PendingQty)PendingQty FROM (");
            sb.Append(" SELECT * FROM  (  ");
            sb.Append(" SELECT id.indentno,id.DeptFrom AS DeptFromID,lm.ledgername AS DeptFrom,id.ItemId,id.ItemName,ReqQty ReqQty,DATE_FORMAT(id.dtentry,'%d-%b-%y' ' %h:%i %p')IndentDate,   ");
            sb.Append(" ReceiveQty ReceiveQty,RejectQty RejectQty,em.Name  AS IndentRaiseBy,IFNULL(( SELECT (InitialCount-ReleasedCount) Qty FROM f_stock WHERE IsPost=1  AND DeptLedgerNo=id.Deptfrom AND ItemID=id.ItemID GROUP BY ItemID),0)AvailQty,  ");
            sb.Append(" IFNULL(sir.GrossAmt,0) Rate,IFNULL( sir.DiscAmt,0)DiscAmt,IFNULL(sir.TaxAmt,0)TaxAmt,IFNULL(ROUND((sir.DiscAmt*100)/sir.GrossAmt,1),'')DiscPer,IFNULL(sir.NetAmt,0)NetAmt,lmm.LedgerName VendorName,im.MajorUnit,  IFNULL(im.ManuFacturer,'')ManuFacturer, ");
            sb.Append(" IFNULL(im.ManufactureID,'')ManufactureID,sir.Vendor_ID AS VendorID, im.SubCategoryID ,( SELECT SUM(sit.Taxper) FROM f_storeitem_tax sit   ");
            sb.Append(" WHERE sit.ItemID=sir.ItemID AND sit.StoreRateID=sir.ID )TaxPer,    ");
            sb.Append(" ( SELECT GROUP_CONCAT(CONCAT(sit.TaxID,'|',sit.Taxper) SEPARATOR '#') FROM f_storeitem_tax sit WHERE sit.ItemID=sir.ItemID AND sit.StoreRateID=sir.ID GROUP BY sit.ItemID,sit.storeRateID )TaxID, ");
            sb.Append(" IFNULL((SELECT SUM((InitialCount-ReleasedCount))Bal  FROM f_stock  WHERE IsPost=1");
            if (ddlDepartment.SelectedItem.Text != "ALL")
                sb.Append(" and DeptLedgerno='" + ddlDepartment.SelectedValue + "'");
            sb.Append("   AND (InitialCount-ReleasedCount)>0  AND ItemID=id.ItemID AND DeptLedgerNo='LSHHI17' GROUP BY ItemID),0) GenStock ,((id.reqQty)-(id.ReceiveQty+id.RejectQty))PendingQty ");
            sb.Append(" FROM f_indent_detail id  ");
            sb.Append(" INNER JOIN f_ledgermaster lm  ON lm.LedgerNumber = id.Deptfrom AND GroupID='DPT'   ");
            sb.Append(" INNER JOIN employee_master em ON  id.UserId=em.Employee_ID  ");
            sb.Append(" LEFT JOIN  f_storeitem_rate  sir ON id.ItemID=sir.ItemID  AND sir.IsActive=1 ");
            sb.Append(" LEFT JOIN f_ledgermaster lmm ON lmm.ledgernumber=sir.vendor_id ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.itemID=id.itemID ");
            sb.Append(" WHERE DATE(id.dtEntry) >= '" + Util.GetDateTime(FromDate.Text).ToString("yyyy-MM-dd") + "' and Date(id.dtEntry) <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "' AND id.DepartmentID='"+ rblStoreType.SelectedItem.Value+"' ");
        
        if (ddlDepartment.SelectedItem.Text != "ALL")
        {
            sb.Append(" AND DeptFrom='" + ddlDepartment.SelectedValue + "'");
        }
        sb.Append(" and id.Storeid='" + rblStoreType.SelectedItem.Value + "' and id.IsPR=0");
        sb.Append(" HAVING (id.reqQty>id.ReceiveQty+id.RejectQty) ) tt HAVING GenStock<PendingQty)ttt GROUP BY ItemId");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        ViewState["ITEM"] = dt;
        if (dt.Rows.Count > 0)
        {
            GrdIndent.DataSource = dt;
            GrdIndent.DataBind();
        }
        else
        {
            GrdIndent.DataSource = null;
            GrdIndent.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!ValidateQty())
        {
            return;
        }
        string HSPoNumber = "";
        string PONumber = "";
        lblMsg.Text = "";
        string VID = "";
        DataTable dtt = ((DataTable)ViewState["ITEM"]).Clone();

        DataTable tt = (DataTable)ViewState["ITEM"];
        DataColumn dc = tt.Columns.Add("OrderQty", typeof(string));
        dtt.Columns.Add("OrderQty", typeof(string));

        for (int k = 0; k < GrdIndent.Rows.Count; k++)
        {
            bool b = ((CheckBox)GrdIndent.Rows[k].FindControl("chkPO")).Checked;
            if (b == true)
            {
                TextBox poQty = ((TextBox)GrdIndent.Rows[k].FindControl("txtPOQty"));
                dc.DefaultValue = poQty;
                tt.Rows[k]["OrderQty"] = poQty.Text;

                dtt.Rows.Add(tt.Rows[k].ItemArray);
                dtt.AcceptChanges();
            }
        }

        DataTable dtItemsNew = dtt.Clone();
        DataTable dtItems = dtt;

        DataView view = new DataView(dtItems);
        view.Sort = "VendorID ASC";
        DataTable newTable = view.ToTable();

        if (newTable.Rows.Count == 1)
        {
            ViewState["ITEM"] = newTable;
            if (ViewState["ITEM"] != null)
            {
                string type_id = "HS";
                PONumber = SaveHSData(type_id);
            }
        }
        else
        {
            for (int i = 0; i < dtt.Rows.Count; i++)
            {
                if ((string.IsNullOrEmpty(VID)) || (VID == newTable.Rows[i]["VendorID"].ToString()))
                {
                    if (string.IsNullOrEmpty(VID))
                    {
                        VID = newTable.Rows[i]["VendorID"].ToString();
                    }
                    dtItemsNew.Rows.Add(newTable.Rows[i].ItemArray);
                    dtItemsNew.AcceptChanges();
                    if (dtt.Rows.Count - 1 == i)
                    {
                        VID = "Unknown";
                        if (i != 0)
                            i--;
                    }
                }
                else
                {
                    ViewState["ITEM"] = dtItemsNew;
                    if (ViewState["ITEM"] != null)
                    {
                        if (dtItemsNew.Rows.Count > 0)
                        {
                            string type_id = "HS";
                            HSPoNumber = SaveHSData(type_id);
                            if (PONumber == "" || PONumber == null)
                                PONumber = HSPoNumber;
                            else
                                PONumber = PONumber + "#" + HSPoNumber;
                        }
                    }
                    if (VID != "Unknown")
                    {
                        VID = newTable.Rows[i]["VendorID"].ToString();
                        if (i != 0)
                            i--;
                    }
                    else
                        break;
                    dtItemsNew.Rows.Clear();
                }
            }
        }

        string ImagesToprint = string.Empty;
        if (chkPrintImg.Checked == true)
        {
            ImagesToprint = "1";
        }
        else
        {
            ImagesToprint = "0";
        }

        int poLength = PONumber.Split('#').Length;
        string[] PO = PONumber.Split('#');
        for (int n = 0; n < poLength; n++)
        {
            if (PONumber != string.Empty)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1" + n, "alert('PurchaseOrder No : " + PO[n] + "');", true);
                if (chkPrintImg.Checked == true)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key2" + n, "window.open('POReport.aspx?PONumber=" + PO[n] + "&ImageToPrint=" + ImagesToprint + "');location.href='PendingIndentItem.aspx';", true);
                }
            }
            else
                lblMsg.Text = "Error....";
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        bindindent();
    }

    protected void chkboxSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)GrdIndent.HeaderRow.FindControl("chkboxSelectAll");
        foreach (GridViewRow row in GrdIndent.Rows)
        {
            CheckBox ChkBoxRows = (CheckBox)row.FindControl("chkPO");
            if (ChkBoxHeader.Checked == true)
            {
                ChkBoxRows.Checked = true;
            }
            else
            {
                ChkBoxRows.Checked = false;
            }
        }
    }

    protected void ddlPOType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlPOType.SelectedItem.Text.ToString() == "Urgent")
            txtDeliveryDate.Text = System.DateTime.Now.AddDays(3).ToString("dd-MMM-yyyy");
        else
            txtDeliveryDate.Text = System.DateTime.Now.AddDays(7).ToString("dd-MMM-yyyy");
    }

    protected void GrdIndent_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Label Vendor_ID = (Label)e.Row.FindControl("lblVendorID");
            TextBox txtPOQty = (TextBox)e.Row.FindControl("txtPOQty");
            CheckBox chk = (CheckBox)e.Row.FindControl("chkPO");
            if (Vendor_ID.Text == "" || Vendor_ID.Text == null)
            {
                chk.Enabled = false;
                txtPOQty.Enabled = false;
            }
            else
            {
                chk.Enabled = true;
                txtPOQty.Enabled = true;
            }
        }
    }

    protected void GrdIndent_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoadData_Store.checkStoreRight(rblStoreType);
            BindDepartmet();
            AllLoadData_Store.bindTypeMaster(ddlPOType);
            txtDeliveryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtValidDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtPODate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            CalendarExtender1.StartDate = DateTime.Now;
            CalendarExtender2.StartDate = DateTime.Now;
            CalendarExtender3.StartDate = DateTime.Now;
        }
        FromDate.Attributes.Add("readOnly", "readOnly");
        ToDate.Attributes.Add("readOnly", "readOnly");
        txtPODate.Attributes.Add("readOnly", "readOnly");
        txtValidDate.Attributes.Add("readOnly", "readOnly");
        txtDeliveryDate.Attributes.Add("readOnly", "readOnly");
        lblMsg.Text = "";
    }

    protected bool ValidateQty()
    {
        int Count = 0;
        for (int k = 0; k < GrdIndent.Rows.Count; k++)
        {
            bool b = ((CheckBox)GrdIndent.Rows[k].FindControl("chkPO")).Checked;
            if (b == true)
            {
                string poQty = ((TextBox)GrdIndent.Rows[k].FindControl("txtPOQty")).Text;
                if (poQty == "0" || poQty == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Enter PO Qty');", true);
                    ((TextBox)GrdIndent.Rows[k].FindControl("txtPOQty")).Focus();
                    return false;
                }
                Count = Count + 1;
            }
        }
        if (Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Select Atleast One Item');", true);
            return false;
        }

        return true;
    }

    private void BindDepartmet()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT rd.DeptName,rd.DeptLedgerNo FROM f_rolemaster rd INNER JOIN f_rolemaster rm ON rd.RoleID=rm.ID WHERE rm.Active=1 ORDER BY rd.DeptName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "DeptName";
            ddlDepartment.DataValueField = "DeptLedgerNo";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, "ALL");
        }
    }

    private string SaveHSData(string type_id)
    {
        decimal NetAmount = 0;
        DataTable dtHS = (DataTable)ViewState["ITEM"];

        if (dtHS.Rows.Count > 0)
        {
            for (int i = 0; i < dtHS.Rows.Count; i++)
            {
                NetAmount = NetAmount + Util.GetDecimal(dtHS.Rows[i]["NetAmt"]);
            }
        }

        string HSPoNumber = string.Empty;

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
        HSPoNumber = StockReports.ExecuteScalar("Select get_po_number('" + type_id + "','" + Session["DeptLedgerNo"].ToString() + "','" + Session["CentreID"].ToString() + "')");
        if (HSPoNumber == "")
            {
            return string.Empty;
            }
            DateTime ByDate = Util.GetDateTime("01-Jan-0001");

            PurchaseOrderMaster iMst = new PurchaseOrderMaster(Tnx);
            iMst.Subject = txtNarration.Text.Trim();
            iMst.Remarks = txtRemarks.Text.Trim();
            iMst.VendorID = dtHS.Rows[0]["VendorID"].ToString();
            iMst.VendorName = dtHS.Rows[0]["VendorName"].ToString();
            if (txtPODate.Text != string.Empty)
                iMst.RaisedDate = Util.GetDateTime(txtPODate.Text);
            else
                iMst.RaisedDate = DateTime.Now;
            iMst.RaisedUserID = Convert.ToString(Session["ID"]);
            iMst.RaisedUserName = Convert.ToString(Session["UserName"]);
            iMst.ValidDate = Util.GetDateTime(txtValidDate.Text);
            iMst.DeliveryDate = Util.GetDateTime(txtDeliveryDate.Text);
            iMst.NetTotal = Util.GetDecimal(NetAmount) - Util.GetDecimal(txtFreight.Text.Trim()) - Util.GetDecimal(txtRoundOff.Text.Trim()) + Util.GetDecimal(txtScheme.Text.Trim()) - Util.GetDecimal(txtExciseOnBill.Text);
            iMst.GrossTotal = Util.GetDecimal(NetAmount);
            iMst.Freight = Util.GetDecimal(txtFreight.Text.Trim());
            iMst.RoundOff = Util.GetDecimal(txtRoundOff.Text.Trim());
            iMst.Scheme = Util.GetDecimal(txtScheme.Text.Trim());
            iMst.Type = ddlPOType.SelectedItem.Text;
            iMst.ByDate = ByDate;
            iMst.ExciseOnBill = Util.GetDecimal(txtExciseOnBill.Text);
            iMst.PoNumber = HSPoNumber;
            iMst.DeptLedgerNo=Session["DeptLedgerNo"].ToString();
            iMst.StoreLedgerNo = rblStoreType.SelectedValue;
            iMst.CentreID = Util.GetInt(Session["CentreID"].ToString());
            iMst.Hospital_ID = Session["HOSPID"].ToString();
            HSPoNumber = iMst.Insert();
            if (HSPoNumber == string.Empty)
            {
                Tnx.Rollback();
                con.Close();
                con.Dispose();
                return string.Empty;
            }

            foreach (DataRow row in dtHS.Rows)
            {
                int PODDetail = 0;

                PurchaseOrderDetail POD = new PurchaseOrderDetail(Tnx);
                POD.ItemID = Util.GetString(row["ItemID"]);
                POD.ItemName = Util.GetString(row["ItemName"]);
                POD.PurchaseOrderNo = HSPoNumber;
                POD.OrderedQty = Util.GetDecimal(row["OrderQty"]);
                POD.Rate = Util.GetDecimal(row["Rate"]);
                POD.QoutationNo = string.Empty;
                POD.SubCategoryID = Util.GetString(row["SubCategoryID"]);
                POD.Status = 0;

                POD.ApprovedQty = Util.GetDecimal(row["OrderQty"]);
                POD.BuyPrice = Util.GetDecimal(row["NetAmt"]);
                POD.Amount = POD.ApprovedQty * POD.BuyPrice;
                POD.Discount_p = Util.GetDecimal(row["DiscPer"]);
                POD.RecievedQty = 0;
                POD.Status = 0;
                POD.Specification = txtNarration.Text;
                POD.Unit = Util.GetString(row["MajorUnit"]);
                POD.DeptLedgerNo = Session["DeptLedgerNo"].ToString();
                POD.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                POD.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                PODDetail = POD.Insert();
                if (PODDetail == 0)
                {
                    Tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }

                int lenTaxPer = Util.GetString(row["TaxID"]).Split('#').Length;
                string[] ss = Util.GetString(row["TaxID"]).Split('#');

                for (int j = 0; j < lenTaxPer; j++)
                {
                    string TaxID = ss[j].Split('|')[0];
                    string TaxPer = ss[j].Split('|')[1];
                    PurchaseOrderTax poTax = new PurchaseOrderTax(Tnx);
                    poTax.PODetailID = PODDetail;
                    poTax.PONumber = HSPoNumber;
                    poTax.ITemID = Util.GetString(row["ItemID"]);
                    poTax.TaxID = Util.GetString(TaxID);
                    poTax.TaxPer = (decimal)Math.Round(Util.GetDouble(TaxPer), 2);
                    poTax.TaxAmt = (decimal)Math.Round(Util.GetDouble(row["TaxAmt"]), 2);
                    int Tax = poTax.InsertTax();
                    if (Tax == 0)
                    {
                        Tnx.Rollback();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }
                }
                string str = "Update f_indent_detail set IsPR=1 where IndentNo IN(" + Util.GetString(row["IndentNo"]) + ") and ItemID='" + Util.GetString(row["ItemID"]) + "'";
                int Result_Update = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                str = string.Empty;
                if (Result_Update < 1)
                {
                    Tnx.Rollback();
                    Tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                    return string.Empty;
                }
            }

            Tnx.Commit();
            con.Close();
            con.Dispose();
            return HSPoNumber;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            return string.Empty;
        }
    }

    
}