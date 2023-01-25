using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web;
using System.Collections.Generic;
using System.Linq;
public partial class Design_Purchase_PendingPurchaseRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int CentreID = Util.GetInt(Session["CentreID"].ToString());

            if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            {
               // ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                //return;
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                ViewState["CentreID"] = Session["CentreID"].ToString();
            }
            else
            {
                if (ChkRights())
                {
                    string Msg = "You do not have rights to generate purchase Order ";
                    Response.Redirect("MsgPage.aspx?msg=" + Msg);
                }
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                ViewState["CentreID"] = Session["CentreID"].ToString();
                string deptledgerno = Session["DeptLedgerNo"].ToString();
                FromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

                txtDeliveryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtValidDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtPODate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                AllLoadData_Store.bindTypeMaster(ddlPOType);
                CalendarExtender1.StartDate = DateTime.Now;
                CalendarExtender2.StartDate = DateTime.Now;
                CalendarExtender3.StartDate = DateTime.Now;
            }
        }
        FromDate.Attributes.Add("readOnly", "readOnly");
        ToDate.Attributes.Add("readOnly", "readOnly");
        txtPODate.Attributes.Add("readOnly", "readOnly");
        txtValidDate.Attributes.Add("readOnly", "readOnly");
        txtDeliveryDate.Attributes.Add("readOnly", "readOnly");
        lblMsg.Text = "";
    }

    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();
        rblStoreType.Items[0].Enabled = false;
        rblStoreType.Items[1].Enabled = false;

        DataTable dt1 = StockReports.GetPurchaseApproval("PO", EmpId);
        if (dt1 != null && dt1.Rows.Count > 0)
        {
            DataTable dt = StockReports.GetRights(RoleId);
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "false")
                {
                    string Msg = "You do not have rights to generate purchase Order ";
                    Response.Redirect("MsgPage.aspx?msg=" + Msg);
                }
                else
                {
                    rblStoreType.Items[0].Enabled = Util.GetBoolean(dt.Rows[0]["IsMedical"]);
                    rblStoreType.Items[1].Enabled = Util.GetBoolean(dt.Rows[0]["IsGeneral"]);
                }
                return false;
            }
            else { return true; }
        }
        else { return true; }
    }

    private void bindPRNo()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT(prm.PurchaseRequestNo)PurchaseRequestNo FROM f_purchaserequestdetails prd INNER JOIN f_purchaserequestmaster ");
        sb.Append(" prm ON prm.PurchaseRequestNo=prd.PurchaseRequisitionNo WHERE  (ApprovedQty- orderedQty)>0 ");
        sb.Append(" AND prm.Storeid='" + rblStoreType.SelectedItem.Value + "' ");
        sb.Append(" AND DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "'  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlPRNo.DataSource = dt;
            ddlPRNo.DataTextField = "PurchaseRequestNo";
            ddlPRNo.DataValueField = "PurchaseRequestNo";
            ddlPRNo.DataBind();
        }
        else
        {
            ddlPRNo.DataSource = string.Empty;
            ddlPRNo.DataTextField = "";
            ddlPRNo.DataValueField = "";
            ddlPRNo.DataBind();
        }

    }
    protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindPRNo();
        grdPPR.DataSource = null;
        grdPPR.DataBind();
    }
    protected void grdPPR_RowDataBound(object sender, GridViewRowEventArgs e)
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
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (rblStoreType.SelectedIndex >= 0)
        {
            lblMsg.Text = "";
            bindPurchaseRequest();
        }
        else
            lblMsg.Text = "Please select Store Type";
    }

    private void bindPurchaseRequest()
    {
        string PurchaseRequisitionNo = "";
        foreach (System.Web.UI.WebControls.ListItem item in ddlPRNo.Items)
        {
            if (item.Selected)
            {
                if (PurchaseRequisitionNo != string.Empty)
                    PurchaseRequisitionNo += ",'" + item.Value + "'";
                else
                    PurchaseRequisitionNo = "'" + item.Value + "'";
            }
        }
        if (PurchaseRequisitionNo == "")
        {
            lblMsg.Text = "Please select PO No.";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT * FROM  ( ");
        sb.Append("   SELECT prd.PurchaseRequisitionNo,lm.ledgername AS DeptFrom,prd.ItemId,prd.ItemName,  ");
        sb.Append("   DATE_FORMAT(RaisedDate,'%d-%b-%Y')RaisedDate,CONCAT(ApprovedQty,' ',IF(IFNULL(fid.MajorUnit,'')='',im.MajorUnit,fid.MajorUnit)) ReqQty,prd.orderedQty,em.Name  AS PRRaiseBy,(ApprovedQty-orderedQty)RemQty,ApprovedQty,  ");
        sb.Append("   IFNULL(sir.GrossAmt,0) Rate,IFNULL( sir.DiscAmt,0)DiscAmt,IFNULL(sir.TaxAmt,0)TaxAmt,   ");
        sb.Append("   IFNULL(ROUND((sir.DiscAmt*100)/sir.GrossAmt,1),'')DiscPer,IFNULL(sir.NetAmt,0)NetAmt, ");
        sb.Append("   IFNULL(lmm.LedgerName,'') VendorName,IF(IFNULL(fid.MajorUnit,'')='',im.MajorUnit,fid.MajorUnit)MajorUnit,CONCAT(im.ReorderQty,' ',IF(IFNULL(fid.MinorUnit,'')='',im.MinorUnit,fid.MinorUnit))ReorderQty,  IFNULL(im.ManuFacturer,'')ManuFacturer, ");
        sb.Append("   IFNULL(im.ManufactureID,'')ManufactureID,sir.Vendor_ID AS VendorID, im.SubCategoryID ,  ");
        sb.Append("   IFNULL((SELECT CONCAT(SUM((InitialCount-ReleasedCount)),' ', IF(IFNULL(fid.MajorUnit,'')='',im.MajorUnit,fid.MajorUnit))Bal  FROM f_stock  WHERE IsPost=1  ");
        sb.Append("   AND (InitialCount-ReleasedCount)>0  AND ItemID=prd.ItemID AND storeLedgerNo='" + rblStoreType.SelectedItem.Value + "' GROUP BY ItemID),0) GenStock  ");
        sb.Append("  ,((prd.requestedQty))PendingQty,sir.TaxCalulatedOn, ");
        //GST Changes
        sb.Append("  IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent, ");
        sb.Append("  IFNULL((SELECT Ven_GSTINNo FROM f_vendormaster WHERE Vendor_ID=sir.Vendor_ID),'')Ven_GSTINNo ");
        //Deal Work
        sb.Append(" ,IFNULL(sir.IsDeal,'')IsDeal ");
        //
        sb.Append("   FROM f_purchaserequestdetails prd ");
        sb.Append("   INNER JOIN f_purchaserequestmaster prm ON prm.PurchaseRequestNo=prd.PurchaseRequisitionNo ");
        sb.Append("   INNER JOIN f_ledgermaster lm  ON lm.LedgerNumber = prm.StoreID ");
        sb.Append("   INNER JOIN employee_master em ON  prm.RaisedByID=em.Employee_ID ");
        sb.Append("   LEFT JOIN  f_storeitem_rate  sir ON prd.ItemID=sir.ItemID  AND sir.IsActive=1 AND sir.DeptLedgerNo ='" + ViewState["DeptLedgerNo"].ToString() + "' ");
        sb.Append("   LEFT JOIN f_ledgermaster lmm ON lmm.ledgernumber=sir.vendor_id ");
        sb.Append("   INNER JOIN f_itemmaster im ON im.itemID=prd.itemID  ");
        sb.Append("  LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
        sb.Append("  WHERE  prd.PurchaseRequisitionNo IN (" + PurchaseRequisitionNo + ")  AND ");
        sb.Append("  prm.Storeid='" + rblStoreType.SelectedItem.Value + "' AND prd.Approved=1  AND prm.Approved=2 AND (ApprovedQty-orderedQty)>0  ");
        sb.Append(" HAVING (prd.ApprovedQty>prd.orderedQty) ORDER BY prd.PurchaseRequisitionNo) tt ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ViewState["ITEM"] = dt;
        if (dt.Rows.Count > 0)
        {
            grdPPR.DataSource = dt;
            grdPPR.DataBind();
        }
        else
        {
            grdPPR.DataSource = null;
            grdPPR.DataBind();
        }
    }
    protected void ddlPOType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlPOType.SelectedItem.Text.ToString() == "Urgent")
            txtDeliveryDate.Text = System.DateTime.Now.AddDays(3).ToString("dd-MMM-yyyy");
        else
            txtDeliveryDate.Text = System.DateTime.Now.AddDays(7).ToString("dd-MMM-yyyy");
    }

    protected bool ValidateQty()
    {
        lblMsg.Text = "";
        int Count = 0;
        for (int k = 0; k < grdPPR.Rows.Count; k++)
        {
            bool b = ((CheckBox)grdPPR.Rows[k].FindControl("chkPO")).Checked;
            if (b == true)
            {
                string poQty = ((TextBox)grdPPR.Rows[k].FindControl("txtPOQty")).Text;
                if (poQty == "0" || poQty == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Enter PO Qty.');", true);
                    ((TextBox)grdPPR.Rows[k].FindControl("txtPOQty")).Focus();
                    return false;
                }
                Count = Count + 1;
            }
        }
        if (Count == 0)
        {
            lblMsg.Text = "Select Atleast One Item";
            return false;
        }

        return true;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!ValidateQty())
        {
            return;
        }
        lblMsg.Text = "";
        DataColumn dc = new DataColumn();
        DataTable dtt = ((DataTable)ViewState["ITEM"]).Clone();

        DataTable tt = (DataTable)ViewState["ITEM"];
        if (tt.Columns.Contains("OrderQty"))
        { }
        else
            dc = tt.Columns.Add("OrderQty", typeof(string));
        if (dtt.Columns.Contains("OrderQty"))
        { }
        else
            dtt.Columns.Add("OrderQty", typeof(string));

        for (int k = 0; k < grdPPR.Rows.Count; k++)
        {
            bool b = ((CheckBox)grdPPR.Rows[k].FindControl("chkPO")).Checked;
            if (b == true)
            {
                TextBox poQty = ((TextBox)grdPPR.Rows[k].FindControl("txtPOQty"));
                dc.DefaultValue = poQty;
                tt.Rows[k]["OrderQty"] = poQty.Text;

                dtt.Rows.Add(tt.Rows[k].ItemArray);
                dtt.AcceptChanges();
            }
        }

        DataTable dtItemsNew = dtt.Clone();
        ViewState["ITEM"] = dtt;

        string PONo = SaveHSData("HS");

        //List<string> PONo=new List<string>();
        //DataTable ven = dtItemsNew.AsEnumerable().GroupBy(row => row.Field<string>("VendorID")).Select(group => group.First()).CopyToDataTable();
        //for (int i = 0; i < ven.Rows.Count; i++)
        //    {
        //    string type_id = "HS";
        //    HSPoNumber = SaveHSData(type_id, ven.Rows[i]["VendorID"].ToString());
        //    //if (PONumber == "" || PONumber == null)
        //    //    PONumber = HSPoNumber;
        //    //else
        //    //    PONumber = PONumber + "#" + HSPoNumber;

        //    PONo.Add(HSPoNumber);
        //    }
        //DataView view = new DataView(dtItems);
        //view.Sort = "VendorID ASC";
        //DataTable newTable = view.ToTable();
        //if (newTable.Rows.Count == 1)
        //    {
        //    ViewState["ITEM"] = newTable;
        //    if (ViewState["ITEM"] != null)
        //        {
        //        string type_id = "HS";
        //        PONumber = SaveHSData(type_id);
        //        }
        //    }
        //else
        //    {
        //    for (int i = 0; i < dtt.Rows.Count; i++)
        //        {
        //        if ((string.IsNullOrEmpty(VID)) || (VID == newTable.Rows[i]["VendorID"].ToString()))
        //            {
        //            if (string.IsNullOrEmpty(VID))
        //                {
        //                VID = newTable.Rows[i]["VendorID"].ToString();
        //                }
        //            dtItemsNew.Rows.Add(newTable.Rows[i].ItemArray);
        //            dtItemsNew.AcceptChanges();
        //            if (dtt.Rows.Count - 1 == i)
        //                {
        //                VID = "Unknown";
        //                if (i != 0)
        //                    i--;
        //                }
        //            }
        //        else
        //            {
        //            ViewState["ITEM"] = dtItemsNew;
        //            if (ViewState["ITEM"] != null)
        //                {
        //                if (dtItemsNew.Rows.Count > 0)
        //                    {
        //                    string type_id = "HS";
        //                   // HSPoNumber = SaveHSData(type_id);
        //                    if (PONumber == "" || PONumber == null)
        //                        PONumber = HSPoNumber;
        //                    else
        //                        PONumber = PONumber + "#" + HSPoNumber;
        //                    }
        //                }
        //            if (VID != "Unknown")
        //                {
        //                VID = newTable.Rows[i]["VendorID"].ToString();
        //                if (i != 0)
        //                    i--;
        //                }
        //            else
        //                break;
        //            dtItemsNew.Rows.Clear();
        //            }
        //        }
        //    }

        if (PONo == "1")
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key200", "location.href='PendingPurchaseRequest.aspx';", true);

    }

    private string SaveHSData(string type_id)
    {

        DataTable dtHS = (DataTable)ViewState["ITEM"];

        List<string> PONo = new List<string>();
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            DataTable dtVen = dtHS.AsEnumerable().GroupBy(row => row.Field<string>("VendorID")).Select(group => group.First()).CopyToDataTable();

            for (int i = 0; i < dtVen.Rows.Count; i++)
            {
                decimal NetAmount = 0;
                string HSPoNumber = string.Empty;
                string VendorID = dtVen.Rows[i]["VendorID"].ToString();
                DataTable dtVenItem = dtHS.AsEnumerable().Where(r => r.Field<string>("VendorID") == VendorID).CopyToDataTable();
                for (int j = 0; j < dtVenItem.Rows.Count; j++)
                {
                    NetAmount += decimal.Round(Util.GetDecimal(Util.GetDecimal(dtVenItem.Rows[j]["NetAmt"]) * Util.GetDecimal(dtVenItem.Rows[j]["OrderQty"])), 2, MidpointRounding.AwayFromZero);
                }

                HSPoNumber = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "Select get_po_number('" + type_id + "','" + Util.GetString(ViewState["DeptLedgerNo"]) + "','" + Util.GetString(ViewState["CentreID"]) + "')"));
                PurchaseOrderMaster iMst = new PurchaseOrderMaster(Tnx);
                iMst.Subject = txtNarration.Text.Trim();
                iMst.Remarks = txtRemarks.Text.Trim();
                iMst.VendorID = dtVenItem.Rows[0]["VendorID"].ToString();
                iMst.VendorName = dtVenItem.Rows[0]["VendorName"].ToString();
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
                iMst.ByDate = Util.GetDateTime("01-Jan-0001");
                iMst.ExciseOnBill = Util.GetDecimal(txtExciseOnBill.Text);
                iMst.S_Amount = Util.GetDecimal(iMst.NetTotal);
                iMst.S_CountryID = Util.GetInt(Resources.Resource.BaseCurrencyID);
                iMst.S_Currency = Util.GetString(Resources.Resource.BaseCurrencyNotation);
                iMst.DeptLedgerNo = Util.GetString(ViewState["DeptLedgerNo"]);
                iMst.StoreLedgerNo = Util.GetString(rblStoreType.SelectedValue);
                AllSelectQuery ASQ = new AllSelectQuery();
                iMst.C_Factor = ASQ.GetConversionFactor(Util.GetInt(Resources.Resource.BaseCurrencyID));
                iMst.PoNumber = HSPoNumber;
                iMst.CentreID = Util.GetInt(ViewState["CentreID"].ToString());
                iMst.Hospital_ID = Util.GetString(Session["HOSPID"]).ToString();
                HSPoNumber = iMst.Insert();
                if (HSPoNumber == string.Empty)
                {
                    Tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }
                // DataTable itemGroup = dtVenItem.AsEnumerable().GroupBy(row => row.Field<string>("ItemID")).Select(group => group.First()).CopyToDataTable();

                foreach (DataRow row in dtVenItem.Rows)
                {
                    //Deal Work
                    string Amt = "";
                    decimal rate1 = Util.GetDecimal(row["Rate"]);
                    decimal deal1 = 0;
                    decimal deal2 = 0;
                    if (row["IsDeal"].ToString() != "")
                    {
                        int deal = Util.GetInt(row["IsDeal"].ToString().Split('+')[0]) + Util.GetInt(row["IsDeal"].ToString().Split('+')[1]);
                        rate1 = Util.GetDecimal(Util.GetDouble(Util.GetDecimal(row["OrderQty"]) * Util.GetDecimal(row["Rate"])) / Util.GetDouble(deal));
                        deal1 = Util.GetDecimal(row["IsDeal"].ToString().Split('+')[0]);
                        deal2 = Util.GetDecimal(row["IsDeal"].ToString().Split('+')[1]);
                    }
                    List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
                     {
                         
                          new TaxCalculation_DirectGRN {DiscAmt=0, DiscPer=Util.GetDecimal(row["DiscPer"]), MRP=Util.GetDecimal(0),Quantity = Util.GetDecimal(row["OrderQty"]),Rate=rate1,TaxPer =Util.GetDecimal(row["IGSTPercent"]) + Util.GetDecimal(row["CGSTPercent"]) + Util.GetDecimal(row["SGSTPercent"]),Type = Util.GetString(row["TaxCalulatedOn"]),IGSTPrecent=Util.GetDecimal(row["IGSTPercent"]),CGSTPercent=Util.GetDecimal(row["CGSTPercent"]),SGSTPercent=Util.GetDecimal(row["SGSTPercent"]),deal =Util.GetDecimal(deal1),deal2= Util.GetDecimal(deal2),ActualRate=Util.GetDecimal(row["Rate"])}
                         
                     };

                    Amt = AllLoadData_Store.taxCalulation(taxCalculate);

                    int PODDetail = 0;

                    PurchaseOrderDetail POD = new PurchaseOrderDetail(Tnx);
                    POD.ItemID = Util.GetString(row["ItemID"]);
                    POD.ItemName = Util.GetString(row["ItemName"]).Trim();
                    POD.PurchaseOrderNo = HSPoNumber;
                    POD.OrderedQty = Util.GetDecimal(row["OrderQty"]);
                    POD.Rate = Util.GetDecimal(row["Rate"]);
                    POD.QoutationNo = string.Empty;
                    POD.SubCategoryID = Util.GetString(row["SubCategoryID"]);
                    POD.Status = 0;
                    POD.ApprovedQty = Util.GetDecimal(row["OrderQty"]);
                    POD.BuyPrice = Util.GetDecimal(Amt.Split('#')[4].ToString());
                    POD.Amount = Util.GetDecimal(Amt.Split('#')[0].ToString());
                    POD.Discount_p = Util.GetDecimal(row["DiscPer"]);
                    POD.RecievedQty = 0;
                    POD.Status = 0;
                    POD.Specification = txtNarration.Text;
                    POD.Unit = Util.GetString(row["MajorUnit"]);
                    POD.DeptLedgerNo = Util.GetString(ViewState["DeptLedgerNo"]);
                    POD.PurchaseRequestNo = Util.GetString(row["PurchaseRequisitionNo"]);
                    POD.ExcisePercent = 0;
                    POD.ExciseAmt = 0;
                    POD.VATPercent = Util.GetDecimal(row["IGSTPercent"]) + Util.GetDecimal(row["CGSTPercent"]) + Util.GetDecimal(row["SGSTPercent"]);
                    POD.VATAmt = Math.Round(Util.GetDecimal(Amt.Split('#')[8].ToString()) + Util.GetDecimal(Amt.Split('#')[9].ToString()) + Util.GetDecimal(Amt.Split('#')[10].ToString()), 2);
                    POD.StoreLedgerNo = Util.GetString(rblStoreType.SelectedValue);
                    POD.TaxCalulatedOn = Util.GetString(row["TaxCalulatedOn"]);
                    POD.CentreID = Util.GetInt(ViewState["CentreID"].ToString());
                    POD.Hospital_ID = Util.GetString(Session["HOSPID"]).ToString();
                    POD.isDeal = Util.GetString(row["IsDeal"]);

                    // GST Changes
                    POD.GSTType = Util.GetString(row["GSTType"]);
                    POD.HSNCode = Util.GetString(row["HSNCode"]);
                    POD.IGSTPercent = Util.GetDecimal(row["IGSTPercent"]);
                    POD.IGSTAmt = Util.GetDecimal(Amt.Split('#')[8].ToString());
                    POD.CGSTPercent = Util.GetDecimal(row["CGSTPercent"]);
                    POD.CGSTAmt = Util.GetDecimal(Amt.Split('#')[9].ToString());
                    POD.SGSTPercent = Util.GetDecimal(row["SGSTPercent"]);
                    POD.SGSTAmt = Util.GetDecimal(Amt.Split('#')[10].ToString());
                    
                    // ----
                    //

                    PODDetail = POD.Insert();
                    if (PODDetail == 0)
                    {
                        Tnx.Rollback();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_purchaserequestdetails SET orderedQty=orderedQty+" + Util.GetDecimal(row["OrderQty"]) + " WHERE PurchaseRequisitionNo='" + Util.GetString(row["PurchaseRequisitionNo"]) + "' AND ItemID='" + Util.GetString(row["ItemID"]) + "' ");

                    PurchaseOrderPurchaseRequest POP = new PurchaseOrderPurchaseRequest(Tnx);
                    POP.PONumber = HSPoNumber;
                    POP.PRNumber = Util.GetString(row["PurchaseRequisitionNo"]);
                    POP.ITemID = Util.GetString(row["ItemID"]);
                    POP.OrderedQty = Util.GetDecimal(row["OrderQty"]);
                    POP.CentreID = Util.GetInt(ViewState["CentreID"].ToString());
                    POP.Hospital_ID = Util.GetString(Session["HOSPID"]).ToString();
                    POP.PODetailID = PODDetail;
                    POP.InsertPoPr();
                }

                PONo.Add(HSPoNumber);
            }

            Tnx.Commit();
            string ImagesToprint = string.Empty;
            if (chkPrintImg.Checked == true)
                ImagesToprint = "1";
            else
                ImagesToprint = "0";

            for (int k = 0; k < PONo.Count; k++)
            {
                int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + Util.GetString(ViewState["DeptLedgerNo"]) + "'"));
                string notification = Notification_Insert.notificationInsert(31, PONo[k].ToString(), Tnx, "", "", roleID);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1" + k, "alert('PurchaseOrder No. : " + PONo[k].ToString() + "');", true);
                if (chkPrintImg.Checked == true)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key2" + k, "window.open('POReport.aspx?PONumber=" + PONo[k].ToString() + "&ImageToPrint=" + ImagesToprint + "');", true);
            }
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            Tnx.Rollback();
            return string.Empty;
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}