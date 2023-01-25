using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Purchase_ComparativeChartNew : System.Web.UI.Page
{
    protected void BindColor(Repeater rptvenNew)
    {
        foreach (RepeaterItem rp in rptvenNew.Items)
        {
            if (((Label)rp.FindControl("lblSet")).Text == "1")
            {
                ((HtmlTableRow)rp.FindControl("Tr1")).BgColor = "LightGreen";
                ((Button)rp.FindControl("btnset")).Enabled = false;
            }
            else
            {
                ((HtmlTableRow)rp.FindControl("Tr1")).BgColor = "Pink";
                ((Button)rp.FindControl("btnset")).Enabled = true;
            }
        }
    }

    protected void BindLastVendor(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex >= 0)
        {
            string ItemID = ((Label)e.Item.FindControl("lbl")).Text.Split('#')[0];
            string PurchaseRequestNo = ((Label)e.Item.FindControl("lbl")).Text.Split('#')[1];
            if (PurchaseRequestNo.StartsWith("PPR"))
            {
                ((Label)e.Item.FindControl("lblLastVendor")).Text = StockReports.ExecuteScalar("SELECT CONCAT(ROUND(s.Rate,1),' # ',ROUND(s.DiscAmt,1),' # ',ROUND(s.PurTaxPer,1),' # ', ROUND(s.UnitPrice,1),' # ',ROUND(s.InitialCount,1),' # ',Date_format(s.stockdate,'%d%b%y'),' # ',IFNULL((SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=lt.LedgerNoCr),'') )LastQuotation FROM   f_stock s inner join f_ledgertransaction lt on lt.LedgerTransactionNo=s.LedgerTransactionNo WHERE s.itemID='" + ItemID + "'  AND s.IsReturn=0 AND s.isPost=1  AND s.DeptLedgerNo='" + AllGlobalFunction.GeneralDeptLedgerNo + "' ORDER BY s.Itemid,s.stockdate DESC LIMIT 1");
            }
            else
            {
                ((Label)e.Item.FindControl("lblLastVendor")).Text = StockReports.ExecuteScalar("SELECT CONCAT(ROUND(s.Rate,1),' # ',ROUND(s.DiscAmt,1),' # ',ROUND(s.PurTaxPer,1),' # ', ROUND(s.UnitPrice,1),' # ',ROUND(s.InitialCount,1),' # ',Date_format(s.stockdate,'%d%b%y'),' # ',IFNULL((SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=lt.LedgerNoCr),'') )LastQuotation FROM   f_stock s inner join f_ledgertransaction lt on lt.LedgerTransactionNo=s.LedgerTransactionNo WHERE s.itemID='" + ItemID + "'  AND s.IsReturn=0 AND s.isPost=1  AND s.DeptLedgerNo='" + AllGlobalFunction.MedicalDeptLedgerNo + "' ORDER BY s.Itemid,s.stockdate DESC LIMIT 1");
            }
        }
    }

    protected void BindVender(object sender, EventArgs e)
    {
        Repeater rpt = (Repeater)((ImageButton)sender).Parent.FindControl("rptvender");
        if (((ImageButton)sender).AlternateText.ToUpper() == "SHOW")
        {
            string itemid = ((ImageButton)sender).CommandArgument.ToString().Split('#')[0];
            string prno = ((ImageButton)sender).CommandArgument.ToString().Split('#')[1];
            string qty = ((ImageButton)sender).CommandArgument.ToString().Split('#')[2];
            DataTable dtItems = LoadQuotations(itemid, prno, qty);
            ((ImageButton)sender).AlternateText = "Hide";
            ((ImageButton)sender).ImageUrl = "~/Images/minus.png";

            if (dtItems.Rows.Count > 0)
            {
                rpt.DataSource = dtItems;
                rpt.DataBind();
                lblmsg.Text = string.Empty;
            }
            else
            {
                rpt.DataSource = null;
                rpt.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            }
        }
        else
        {
            ((ImageButton)sender).AlternateText = "Show";
            ((ImageButton)sender).ImageUrl = "~/Images/plus.png";
            rpt.DataSource = null;
            rpt.DataBind();
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "ac1", "window.top.location.hash='" + ((ImageButton)sender).ClientID + "';", true);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (txtPr.Text == "")
        {
            if (ddlDept.SelectedItem.Text == "-Select-")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblmsg.ClientID + "');", true);
                return;
            }
            if (ddlStore.SelectedItem.Text == "-Select-")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM015','" + lblmsg.ClientID + "');", true);
                ddlStore.Focus();
                return;
            }
        }
        BindPRRequest();
    }

    protected bool checkeditstatus(string StoreID)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_purchase_approval WHERE Employee_ID='" + Session["ID"].ToString() + "' AND Department='" + StoreID + "' AND ApprovalFor='CCHART' AND Approval='1'"));
        if (count > 0)
        { return true; }
        else { return false; }
    }

    protected void ddlGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
    }

    protected void ddlStore_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGroup();
        BindItem();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["VendorIDOLD"] = "";
            ViewState["VendorQutoD"] = "0";
            ViewState["VendorQutoND"] = "0";
            DateFrom.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            DateTo.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");

            BindStore();
            BindDepartments();
            BindGroup();

            BindCompany();
            BindVendor();

            BindItem();
            ViewState["EmpID"] = Convert.ToString(Session["ID"]);
            string DeptLedgerNo = StockReports.ExecuteScalar("Select DeptLedgerNo from f_rolemaster where RoleID ='" + Util.GetString(Session["RoleID"]) + "' ");
            ViewState["DeptLedgerNo"] = DeptLedgerNo;
        }

        DateFrom.Attributes.Add("readonly", "true");
        DateTo.Attributes.Add("readonly", "true");
    }

    protected void rpt_setvender(object sender, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "set")
        {
            string PR = e.CommandArgument.ToString().Split('#')[5];
            string ItemID = e.CommandArgument.ToString().Split('#')[1];
            string quotationID = e.CommandArgument.ToString().Split('#')[2];
            string VendorLedNo = e.CommandArgument.ToString().Split('#')[0];
            string StoreID = e.CommandArgument.ToString().Split('#')[6];
            string VendorID = e.CommandArgument.ToString().Split('#')[7];
            string VendorName = e.CommandArgument.ToString().Split('#')[8];

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "call Insert_QuotationVendorDummy(" + quotationID + ",'" + PR + "','" + VendorLedNo + "','" + ItemID + "','" + VendorID + "')");
                tnx.Commit();
                DataTable dt = LoadQuotations(e.CommandArgument.ToString().Split('#')[1].ToString(), e.CommandArgument.ToString().Split('#')[5].ToString(), e.CommandArgument.ToString().Split('#')[4].ToString());

                string test = e.Item.ClientID.ToString();
                Repeater rptven = (Repeater)e.Item.Parent.Parent.FindControl("rptvender");

                rptven.DataSource = null;
                rptven.DataBind();
                rptven.DataSource = dt;
                rptven.DataBind();

                if (con.State == ConnectionState.Open)
                {
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
                BindColor(rptven);
            }
            catch (Exception ex)
            {
                tnx.Rollback();

                con.Close();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            }
        }
    }

    protected void rptpr_ItemCommand(object sender, RepeaterCommandEventArgs e)
    {
        string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
        Repeater rpt = (Repeater)e.Item.FindControl("rptitems");
        if (opType == "SHOW")
        {
            string prno = Convert.ToString(e.CommandArgument);
            ((ImageButton)e.CommandSource).AlternateText = "Hide";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";
            DataTable dt = GetSelectedItems(prno);

            if (dt.Rows.Count > 0)
            {
                rpt.DataSource = dt;
                rpt.DataBind();
                lblmsg.Text = string.Empty;
            }
            else
            {
                rpt.DataSource = null;
                rpt.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            }
        }
        else
        {
            ((ImageButton)e.CommandSource).AlternateText = "Show";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/plus.png";
            rpt.DataSource = null;
            rpt.DataBind();
            lblmsg.Text = string.Empty;
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "ac1", "window.top.location.hash='" + ((ImageButton)e.CommandSource).ClientID + "';", true);
    }

    protected void rptvender_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex >= 0)
        {
            if (checkeditstatus(((Label)e.Item.FindControl("lblStore")).Text))
            {
                ((Button)e.Item.FindControl("btnset")).Visible = true;
            }
            else
            {
                ((Button)e.Item.FindControl("btnset")).Visible = false;
            }
            if (((Label)e.Item.FindControl("lblAppStatus")).Text.ToLower() != "true")
            {
                ((Button)e.Item.FindControl("btnset")).Visible = false;
            }

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ((HtmlTableRow)e.Item.FindControl("Tr1")).Attributes.Add("onmouseover", "SetNewColor(this);");
                ((HtmlTableRow)e.Item.FindControl("Tr1")).Attributes.Add("onMouseOut", "SetOldColor(this);");
                if (((Label)e.Item.FindControl("lblSet")).Text == "1")
                {
                    ((HtmlTableRow)e.Item.FindControl("Tr1")).BgColor = "LightGreen";
                    ((Button)e.Item.FindControl("btnset")).Enabled = false;
                }
                else
                {
                    ((HtmlTableRow)e.Item.FindControl("Tr1")).BgColor = "Pink";
                    ((Button)e.Item.FindControl("btnset")).Enabled = true;
                }
            }
        }
    }

    private void BindCompany()
    {
        string str1 = "select Name,ManufactureID from f_manufacture_master where IsActive = 1 order by Name";

        DataTable dt1 = new DataTable();
        dt1 = StockReports.GetDataTable(str1);

        if (dt1.Rows.Count > 0)
        {
            ddlCompany.DataSource = dt1;
            ddlCompany.DataTextField = "Name";
            ddlCompany.DataValueField = "ManufactureID";
            ddlCompany.DataBind();
            ddlCompany.Items.Insert(0, new ListItem("ALL", "ALL"));
        }
    }

    private void BindDepartments()
    {
        DataTable dt = LoadCacheQuery.bindStoreDepartment();

        if (dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "LedgerName";
            ddlDept.DataValueField = "LedgerNumber";
            ddlDept.DataBind();
            ddlDept.Items.Insert(0, new ListItem("ALL", "ALL"));
        }
    }

    private void BindGroup()
    {
        string strQuery = "";
        strQuery = " SELECT sc.Name GroupHead,sc.SubCategoryID FROM f_subcategorymaster sc INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID";

        if (ddlStore.SelectedItem.Text != "ALL")
            strQuery += " INNER JOIN f_itemmaster im on im.SubCategoryID = sc.SubCategoryID ";

        strQuery += " WHERE sc.Active=1 ";

        if (ddlStore.SelectedValue == "STO00001")
            strQuery += " AND cf.ConfigID ='11' ";
        else if (ddlStore.SelectedValue == "STO00002")
            strQuery += " AND cf.ConfigID ='28' ";
        else
            strQuery += " AND cf.ConfigID in ('11','28') ";
        strQuery += " Group by sc.SubCategoryID ORDER BY sc.Name";
        ddlGroup.DataSource = StockReports.GetDataTable(strQuery);
        ddlGroup.DataTextField = "GroupHead";
        ddlGroup.DataValueField = "SubCategoryID";
        ddlGroup.DataBind();

        ddlGroup.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlGroup.SelectedIndex = 0;
    }

    private void BindItem()
    {
        string strQuery = "";
        strQuery = " SELECT im.TypeName,im.ItemID FROM f_subcategorymaster sc ";
        strQuery += " INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQuery += " INNER JOIN f_itemmaster im on im.SubCategoryID = sc.SubCategoryID ";
        strQuery += " WHERE im.IsActive=1 ";
        if (ddlStore.SelectedValue == "STO00001")
            strQuery += " AND cf.ConfigID ='11' ";
        else if (ddlStore.SelectedValue == "STO00002")
            strQuery += " AND cf.ConfigID ='28' ";
        else
            strQuery += " AND cf.ConfigID in ('11','28') ";

        if (ddlGroup.SelectedValue != "ALL")
            strQuery += " AND im.SubCategoryID='" + ddlGroup.SelectedItem.Value + "' ";
        if (ddlCompany.SelectedItem.Value != "ALL")
            strQuery += " AND im.ManufactureID='" + ddlCompany.SelectedItem.Value + "' ";

        strQuery += " ORDER BY im.TypeName";

        ddlItem.DataSource = StockReports.GetDataTable(strQuery);
        ddlItem.DataTextField = "TypeName";
        ddlItem.DataValueField = "ItemID";
        ddlItem.DataBind();
        ddlItem.Items.Insert(0, new ListItem("ALL", "ALL"));
    }

    private void BindPRRequest()
    {
        string Query = "";
        Query = " Select t.PurchaseRequestNo,(select Name from employee_master where employee_id=t.RaisedByID)Name,t.Subject," +
                 " date_format(t.RaisedDate,'%d-%b-%Y')RaisedDate,ld.LedgerNumber,ld.LedgerName DeptRaised,(select LedgerName from f_ledgermaster where LedgerNumber=t.StoreID) StoreType from ( " +
                 "    Select pm.* from f_purchaserequestmaster pm inner join " +
                 "    f_purchaserequestdetails prd on pm.PurchaseRequestNo = prd.PurchaseRequisitionNo " +
                 "    INNER JOIN f_itemmaster im ON im.ItemID=prd.ItemID " +
                 "    inner join f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID " +
                 "    INNER JOIN f_configrelation cf on cf.CategoryID = sc.CategoryID ";

        if (rbtn.SelectedItem.Text == "Yes")
        {
            Query = Query + " inner join f_purchaserequestquotation quot on quot.PurchaseRequestNo=pm.PurchaseRequestNo ";
        }

        Query = Query + "    Where Pm.status = 2 and prd.Status=0 ";

        if (txtPr.Text.Trim() != "")
            Query = Query + "and pm.PurchaseRequestNo = '" + txtPr.Text.Trim() + "' ";

        if (ddlStore.SelectedValue == "STO00001")
            Query += " AND cf.ConfigID ='11' ";
        else if (ddlStore.SelectedValue == "STO00002")
            Query += " AND cf.ConfigID ='28' ";
        else
            Query += " AND cf.ConfigID in ('11','28') ";
        if (ddlGroup.SelectedValue != "ALL")
            Query += " AND im.SubCategoryID='" + ddlGroup.SelectedItem.Value + "' ";
        if (ddlCompany.SelectedItem.Value != "ALL")
            Query += " AND im.ManufactureID='" + ddlCompany.SelectedItem.Value + "' ";
        if (txtPr.Text.Trim() == string.Empty)
        {
            if (DateFrom.Text.Trim() != "")
                Query += " and date(pm.RaisedDate)>='" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' ";

            if (DateTo.Text.Trim() != "")
                Query += " and date(pm.RaisedDate)<='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' ";
        }

        if (txtPr.Text == "")
        {
            if (ddlStore.SelectedItem.Text != "ALL")
            {
                Query = Query + "and StoreId = '" + ddlStore.SelectedValue + "' ";
            }
            if (ddlDept.SelectedItem.Text != "ALL")
            { Query = Query + "and DeptLedgerNo ='" + ddlDept.SelectedValue + "' "; }
        }
        if (ddlGroup.SelectedIndex > 0)
        {
            Query = Query + " and prd.SubCategoryID='" + ddlGroup.SelectedValue + "'  ";
        }
        if (ddlItem.SelectedIndex > 0)
        {
            Query = Query + " and prd.ItemId='" + ddlItem.SelectedValue + "'  ";
        }

        Query = Query + " group by pm.PurchaseRequestNo) t inner join f_ledgermaster ld on ld.LedgerNumber = t.DeptLedgerNo and ld.GroupID='DPT' ";

        if (rbtn.SelectedItem.Text == "No")
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(" select * from ( ");
            sb.Append(" Select t.quote_ID,t.PurchaseRequestNo,(select Name from employee_master where employee_id=t.RaisedByID)Name,t.Subject, ");
            sb.Append("      date_format(t.RaisedDate,'%d-%b-%Y')RaisedDate,ld.LedgerNumber,ld.LedgerName DeptRaised,(select LedgerName from f_ledgermaster where LedgerNumber=t.StoreID) StoreType from (  ");
            sb.Append("      Select pm.*,quot.quote_ID from f_purchaserequestmaster pm inner join  ");
            sb.Append("      f_purchaserequestdetails prd on pm.PurchaseRequestNo = prd.PurchaseRequisitionNo  ");
            sb.Append("      INNER JOIN f_itemmaster im ON im.ItemID=prd.ItemID ");
            sb.Append("      inner join f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID ");
            sb.Append("      INNER JOIN f_configrelation cf on cf.CategoryID = sc.CategoryID ");
            sb.Append("			left join f_purchaserequestquotation quot on quot.PurchaseRequestNo=pm.PurchaseRequestNo  ");
            sb.Append("                     Where Pm.status = 2 and prd.Status=0   ");

            if (txtPr.Text.Trim() != "")
                sb.Append("  and pm.PurchaseRequestNo = '" + txtPr.Text.Trim() + "' ");

            if (ddlStore.SelectedItem.Text != "ALL")
                sb.Append(" and StoreId in('" + ddlStore.SelectedValue + "') ");

            if (ddlDept.SelectedValue != "ALL")
                sb.Append(" and DeptLedgerNo ='" + ddlDept.SelectedValue + "' ");

            if (ddlStore.SelectedValue == "STO00001")
                sb.Append("			 AND cf.ConfigID ='11' ");
            else if (ddlStore.SelectedValue == "STO00002")
                sb.Append("			 AND cf.ConfigID ='28' ");
            else
                sb.Append("			 AND cf.ConfigID in ('11','28') ");
            if (ddlGroup.SelectedValue != "ALL")
                sb.Append("			 AND im.SubCategoryID='" + ddlGroup.SelectedItem.Value + "' ");
            if (ddlCompany.SelectedItem.Value != "ALL")
                sb.Append("			 AND im.ManufactureID='" + ddlCompany.SelectedItem.Value + "' ");
            if (txtPr.Text.Trim() == string.Empty)
            {
                if (DateFrom.Text.Trim() != "")
                    sb.Append("			 and date(pm.RaisedDate)>='" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' ");

                if (DateTo.Text.Trim() != "")
                    sb.Append("			 and date(pm.RaisedDate)<='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' ");
            }

            sb.Append(" group by pm.PurchaseRequestNo) t   ");
            sb.Append(" inner join f_ledgermaster ld on ld.LedgerNumber = t.DeptLedgerNo and ld.GroupID='DPT' )  ");
            sb.Append(" aa where quote_ID is null ");
            Query = sb.ToString();
        }
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(Query);
        if (dt != null && dt.Rows.Count > 0)
        {
            rptpr.DataSource = dt;
            rptpr.DataBind();
        }
        else
        {
            rptpr.DataSource = null;
            rptpr.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

    private void BindStore()
    {
        string str = "SELECT LedgerName,LedgerNumber from f_ledgermaster Where GroupID='STO'  ORDER BY LedgerNumber DESC";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlStore.DataSource = dt;
            ddlStore.DataTextField = "LedgerName";
            ddlStore.DataValueField = "LedgerNumber";
            ddlStore.DataBind();
            ddlStore.Items.Insert(0, new ListItem("ALL", "ALL"));
        }
    }

    private void BindVendor()
    {
        string str2 = "SELECT Vendor_ID,VendorName FROM f_vendormaster order by VendorName";
        DataTable dt2 = new DataTable();
        dt2 = StockReports.GetDataTable(str2);
        if (dt2.Rows.Count > 0)
        {
            ddlVendor.DataSource = dt2;
            ddlVendor.DataTextField = "VendorName";
            ddlVendor.DataValueField = "Vendor_ID";
            ddlVendor.DataBind();
            ddlVendor.Items.Insert(0, new ListItem("ALL", "ALL"));
        }
    }

    private DataTable GetSelectedItems(string PRNO)
    {
        string strQuery = string.Empty;

        strQuery = " Select prd.PuschaseRequistionDetailID ,prd.PurchaseRequisitionNo,prd.ItemName,im.ItemID,mm.NAME Manufacturer,prd.RequestedQty,prd.ApprovedQty,prd.OrderedQty,prd.Specification,prd.Specification, prd.InHandQty,if((Select 'True' from f_purchaserequestquotation where PurchaseRequestNo ='" + PRNO + "' and ItemID=prd.ItemID and IsSet=1)='True','True','False')IsSet from f_purchaserequestdetails prd inner join  f_itemmaster im on im.ItemID=prd.ItemID left outer join f_manufacture_master mm on mm.MAnufactureID=im.ManufactureID where prd.PurchaseRequisitionNo ='" + PRNO + "' AND prd.Status<>2 ORDER BY prd.PurchaseRequisitionNo,prd.ItemName ";
        DataTable dtItemDetails = StockReports.GetDataTable(strQuery);
        return dtItemDetails;
    }

    private DataTable LoadQuotations(string ItemID, string PRNo, string qty)
    {
        DataTable dtItem = new DataTable();
        string strQuery = string.Empty;
        StringBuilder sb = new StringBuilder();

        //shatrughan 26.05.14

        sb.Append("     SELECT * FROM (SELECT (SELECT StoreID FROM f_purchaserequestmaster   ");
        sb.Append("   WHERE PurchaseRequestNo='" + PRNo + "')StoreID,'" + PRNo + "'   PurchaseRequestNo, ");
        sb.Append("    (SELECT TypeName FROM f_itemmaster WHERE ItemId=prq.itemid)ItemName ,prq.Rate,     ");
        sb.Append("    (SELECT ItemID FROM f_itemmaster WHERE ItemId=prq.itemid)ItemId,prq.Discount,  ");
        sb.Append("   ROUND((IFNULL((prq.Rate-(prq.Rate*prq.Discount/100)),0)+(IFNULL((prq.Rate-(prq.Rate*prq.Discount/100)),0)*IFNULL(t.TaxPer,0)/100)),3) AS CostPrice,  ");
        sb.Append("  (ROUND((IFNULL((prq.Rate-(prq.Rate*prq.Discount/100)),0)+(IFNULL((prq.Rate-(prq.Rate*prq.Discount/100)),0) *     IFNULL(t.TaxPer/100,0)))*1,0))AS TotalCost ,1 AS Qty ,  ");
        sb.Append("  prq.ModelNumber,prq.DeliveryTime,prq.PaymentPattern,prq.AMC,prq.OperationalCost,prq.SilentFeatures,prq.AdditionalFeatures,prq.Specification,UploadStatus,IFNULL(IF(URL='','',URL),'')URL,    ");
        sb.Append("     (SELECT ven.Vendorname FROM f_vendormaster ven   WHERE ven.Vendor_id=prq.VendorID)Vendor,      ");
        sb.Append("       prq.QuotationRefNo RefNo,DATE_FORMAT(prq.Date,'%d-%b-%Y')DATE,prq.Remarks,t.TaxName,  ");
        sb.Append("       IFNULL(t.TaxPer,0)TaxPer,prq.quotationID,  IFNULL(IF(t2.IsSet=NULL,0,t2.IsSet),0)IsSet,  ");
        sb.Append("       IFNULL((SELECT IF(IsSet=1,'true','false') FROM f_purchase_quotation  ");
        sb.Append("       WHERE PurchaseRequestNo='" + PRNo + "' AND quotationID=prq.quotationID),'false')SetStatus,prq.IsActive,prq.VendorLedgerNo,  ");
        sb.Append("       (SELECT ven.Vendor_ID FROM f_vendormaster ven WHERE ven.Vendor_id=prq.VendorID)VendorID,       ");
        sb.Append("       IF(IFNULL((SELECT po.Approved FROM      f_purchaseorderpurchaserequest pr ");
        sb.Append("       INNER JOIN f_purchaseorder po     	ON pr.PONumber = po.PurchaseOrderNo   ");
        sb.Append("       WHERE PRNumber='" + PRNo + "' AND ITemID='" + ItemID + "' AND po.Approved IN (2)  AND po.IsAutoPo=1 ),'')=2,'false','true')AppStatus ,'false' EditStatus, ");
        sb.Append("       DATE(IF(IFNULL(auto.DateUpto,NOW())=NOW(),NOW(),auto.DateUpto))DateUpto, ");
        sb.Append("       IF(IFNULL(auto.DateUpto,NOW())=NOW(),'false','true')AutoPo    ");
        sb.Append("       FROM f_purchase_quotation prq LEFT JOIN AutopoQuotation auto  ");
        sb.Append("       ON prq.itemid=auto.itemid AND prq.VendorID=auto.VendorID AND auto.IsActive=1 ");
        sb.Append("  LEFT JOIN (SELECT IsSet,Quote_ID FROM f_purchaserequestquotation WHERE PurchaseRequestNo='" + PRNo + "'  ");
        sb.Append(" AND ItemID ='" + ItemID + "' AND IsActive=1 )t2 ON  prq.Quote_IDMain=t2.Quote_ID ");
        sb.Append("         LEFT JOIN  (SELECT SUM(TaxPer)TaxPer, ");
        sb.Append("       TaxName,quotationID     FROM f_purchase_quotation_tax prt INNER JOIN f_taxmaster tm ON tm.TaxID = prt.TaxID  ");
        sb.Append("       GROUP BY quotationID )t      ON prq.quotationID = t.quotationID  ");
        sb.Append("       WHERE     prq.IsActive=1   )t1   WHERE t1.itemid='" + ItemID + "'  ");
        sb.Append("     ");

        dtItem = StockReports.GetDataTable(sb.ToString());
        return dtItem;
    }
}
