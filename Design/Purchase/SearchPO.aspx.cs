using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web;
public partial class Design_Purchase_SearchPO : System.Web.UI.Page
{
    #region Event Handling
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_Store.bindTypeMaster(cmbRequestType);
            AllLoadData_Store.bindStore(lstVendor, "VEN", "All");
            BindLedger();
            EntryDate1.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            EntryDate2.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            BindCategory();
        }
        EntryDate1.Attributes.Add("readOnly", "true");
        EntryDate2.Attributes.Add("readOnly", "true");

    }
    private void BindLedger()
    {
        string str = "SELECT LedgerName,LedgerNumber from f_ledgermaster Where GroupID='STO'";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            cmbPurchase.DataSource = dt;
            cmbPurchase.DataTextField = "LedgerName";
            cmbPurchase.DataValueField = "LedgerNumber";
            cmbPurchase.DataBind();

            int index = cmbPurchase.Items.IndexOf(cmbPurchase.Items.FindByText(Session["LoginType"].ToString()));
            if (index != -1)
            {
                cmbPurchase.SelectedIndex = cmbPurchase.Items.IndexOf(cmbPurchase.Items.FindByText(Session["LoginType"].ToString()));

                cmbPurchase.Enabled = false;
            }
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            row = (DataRowView)e.Row.DataItem;
            e.Row.Attributes.Add("onMouseOver", "SetNewColor(this);");
            e.Row.Attributes.Add("onMouseOut", "SetOldColor(this);");
            e.Row.Attributes.Add("ondblclick", "ShowPO('" + Util.GetString(row["PurchaseOrderNo"]) + "');");
        }
    }
    protected void btnReportDetail_Click(object sender, EventArgs e)
    {
        SearchReport();
    }
    #endregion

    #region Data Binding
    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT concat(IM.Typename,' # ','(',SM.name,')')ItemName,concat(IM.ItemID,'#',IM.SubCategoryID)ItemID");
        sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation cr ON cr.CategoryID=sm.CategoryID");
        sb.Append(" WHERE cr.ConfigID IN (11,28) order by IM.Typename ");

        DataTable dtItem = new DataTable();
        dtItem = StockReports.GetDataTable(sb.ToString());

        if (dtItem != null && dtItem.Rows.Count > 0)
        {
            lstItem.DataSource = dtItem;
            lstItem.DataTextField = "ItemName";
            lstItem.DataValueField = "ItemID";
            lstItem.DataBind();
            lstItem.Items.Insert(0, new ListItem("All"));
        }
        else
        {
            lstItem.Items.Clear();
            lstItem.Items.Add("No Item Found");

        }
    }
    
    #endregion

    #region Search Critaria
    private string GetCreitaria()
    {
        string str = string.Empty;
        str = " WHERE po.CentreID=" + Session["CentreID"].ToString() + " ";
        if (txtPONo.Text != string.Empty)
            str = str + " AND PO.PurchaseOrderNo='" + txtPONo.Text.Trim() + "'";

        if (txtSubject.Text != string.Empty)
        {
            if (str != string.Empty)
                str = str + " and PO.Subject like '" + txtSubject.Text.Trim() + "%'";
            else
                str = " where PO.Subject like'" + txtSubject.Text.Trim() + "%'";
        }
        if (ddlCategory.SelectedIndex > 0)
        {
            str = str + " and cm.CategoryID='" + ddlCategory.SelectedItem.Value + "'  ";
        }
        if (cmbStatus.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PO.Status='" + cmbStatus.SelectedItem.Value + "'  ";
            else
                str = " where PO.Status='" + cmbStatus.SelectedItem.Value + "' ";

          //  if (cmbRequestType.SelectedItem.Value == "1")
         //       str = str + " and POD.Status='2' ";
         //   else
         //       str = str + " and POD.Status='0' ";

        }
      
        if (cmbRequestType.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and Type='" + cmbRequestType.SelectedItem.Text + "'";
            else
                str = " where Type='" + cmbRequestType.SelectedItem.Text + "'";
        }

        if (lstVendor.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PO.VendorID = '" + lstVendor.SelectedValue + "'";
            else
                str = " where PO.VendorID = '" + lstVendor.SelectedValue + "'";

        }
        if (txtPONo.Text.Trim() == string.Empty)
        {
            if (EntryDate1.Text.Trim() != string.Empty)
            {
                if (str != string.Empty)
                    str = str + " and date(PO.RaisedDate) >='" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'";
                else
                    str = " where date(PO.RaisedDate) >='" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'";
            }
            if (EntryDate2.Text.Trim() != string.Empty)
            {
                if (str != string.Empty)
                    str = str + " and date(PO.RaisedDate) <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "'";
                else
                    str = " where date(PO.RaisedDate) <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "'";
            }
        }
        if (lstItem.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and POD.ItemID ='" + lstItem.SelectedItem.Value.Split('#')[0] + "'";
            else
                str = " where POD.ItemID ='" + lstItem.SelectedItem.Value.Split('#')[0] + "'";
        }
        if (ddlItemType.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and POD.IsFree ='" + ddlItemType.SelectedValue + "'";
            else
                str = " where POD.IsFree ='" + ddlItemType.SelectedValue + "'";
        }
        if (chkAutoPo.Checked == true)
        {

            if (str != string.Empty)
                str = str + " AND po.IsAutoPo=1 ";
            else
                str = " where  AND po.IsAutoPo=1 ";

        }
        return str;
    }
    #endregion

    #region Search Purchase Order
    private void Search()
    {
        string Query = "";
        Query = "select distinct(PO.PurchaseOrderNo),PO.NetTotal,PO.GrossTotal,PO.Subject,PO.VendorName,date_format(PO.RaisedDate,'%d-%b-%Y')RaisedDate,PO.Type,(case when Po.Status = 0 then 'Pending Approval' when Po.Status = 1 then 'Rejected' when Po.Status = 2 then 'Approved' when Po.Status = 3 then 'Grn Done' end )Status FROM f_purchaseorder PO INNER JOIN f_purchaseorderdetails POD on PO.PurchaseOrderNo=POD.PurchaseOrderNo AND po.StoreLedgerNo='" + cmbPurchase.SelectedValue + "' AND PO.DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "'  ";

        string str = GetCreitaria();

        if (str != string.Empty)
            Query = Query + str;

        DataTable dt = StockReports.GetDataTable(Query);

        if (dt != null && dt.Rows.Count > 0)
        {
            GridView1.DataSource = dt;
            GridView1.DataBind();
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                if (GridView1.Rows[i].Cells[5].Text == "Approved")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.YellowGreen;
                }
                if (GridView1.Rows[i].Cells[5].Text == "Grn Done")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.Yellow;
                }
                if (GridView1.Rows[i].Cells[5].Text == "Rejected")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.LightPink;
                }
                if (GridView1.Rows[i].Cells[5].Text == "Pending Approval")
                {                  
                    GridView1.Rows[i].BackColor = System.Drawing.Color.LightBlue;
                }
            }
            //lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";

        }
        else
        {
            //lblMsg.Text = "No Record Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            GridView1.DataSource = null;
            GridView1.DataBind();
        }
    }

    private void searchPRbtn(string status)
    {
        string Query = "";
        Query = "select t.* from (select distinct(PO.PurchaseOrderNo),PO.NetTotal,PO.GrossTotal,PO.Subject,PO.VendorName,date_format(PO.RaisedDate,'%d-%b-%y')RaisedDate,PO.Type,(case when Po.Status = 0 then 'Pending Approval' when Po.Status = 1 then 'Rejected' when Po.Status = 2 then 'Approved' when Po.Status = 3 then 'Grn Done' end )Status from f_purchaseorder PO inner join f_purchaseorderdetails POD on PO.PurchaseOrderNo=POD.PurchaseOrderNo and po.storeLedgerNo='"+cmbPurchase.SelectedValue+"' AND po.CentreID="+ Session["CentreID"].ToString() +" ";

        string str = GetCreitaria();

        if (str != string.Empty)
            Query = Query + str;
        Query = Query + ")t Where t.Status='" + status + "' ";
        DataTable dt = StockReports.GetDataTable(Query);

        if (dt != null && dt.Rows.Count > 0)
        {
            GridView1.DataSource = dt;
            GridView1.DataBind();
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                if (GridView1.Rows[i].Cells[5].Text == "Approved")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.YellowGreen;
                }
                if (GridView1.Rows[i].Cells[5].Text == "Grn Done")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.Yellow; ;
                }
                if (GridView1.Rows[i].Cells[5].Text == "Rejected")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.LightPink;
                }
                if (GridView1.Rows[i].Cells[5].Text == "Pending Approval")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.LightBlue;
                }
            }
        }
        else
        {
            //lblMsg.Text = "No Record Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            GridView1.DataSource = null;
            GridView1.DataBind();
        }

    }


    private void SearchReport()
    {
        if (rdoReportType.SelectedValue != "1" && rbtPDF.SelectedValue == "2")
        {
            StringBuilder sb = new StringBuilder();

            string StoreType = AllGlobalFunction.GeneralDeptLedgerNo;
            if (rdoMedical_general.SelectedIndex == 0)
                StoreType = AllGlobalFunction.MedicalDeptLedgerNo;


            sb.Append(" SELECT DISTINCT(PO.PurchaseOrderNo),POD.PurchaseOrderDetailID,POD.Specification,PO.Subject,PO.VendorName,POD.ItemName,");
            sb.Append(" POD.OrderedQty,POD.RecievedQty,POD.Rate,POD.Discount_p,(SELECT NAME FROM employee_master WHERE EmployeeId=PO.RaisedUserID)RaisedUser,POD.BuyPrice,");
            sb.Append(" (CASE WHEN POD.IsFree = 0 THEN 'No' WHEN POD.IsFree = 1 THEN 'Yes' END )IsFree,DATE_FORMAT(PO.RaisedDate,'%d-%b-%y')RaisedDate,PO.Type,");
            sb.Append(" (CASE WHEN Po.Status = 0 THEN 'Pending Apporval' WHEN Po.Status = 1 THEN 'Rejected' WHEN Po.Status = 2 THEN 'Approved' WHEN Po.Status = 3 THEN 'Grn Done' END )STATUS,");
            sb.Append(" t2.TaxPer,t2.TaxName, ");

            
                sb.Append(" (SELECT ROUND( IF (SUM(IF(TrasactionTypeID IN(3,13),SoldUnits,0))>SUM(IF(TrasactionTypeID IN(5,14),SoldUnits,0)),");
                sb.Append(" (SUM(IF(TrasactionTypeID IN(3,13),SoldUnits,0)) - SUM(IF(TrasactionTypeID IN(5,14),SoldUnits,0)))/3,0)) ");
                sb.Append(" FROM f_salesdetails  WHERE DATE<='" + Util.GetDateTime(EntryDate1.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE>=ADDDATE('" + Util.GetDateTime(EntryDate2.Text.Trim()).ToString("yyyy-MM-dd") + "',-90) AND  ");
                sb.Append(" Itemid=pod.itemid AND  TrasactionTypeID IN(5,14,3,13) AND DeptLedgerNo IN ('" + StoreType + "'))Avg_Cosmp, ");
                sb.Append(" (SELECT ROUND(IF(SUM(IF(TrasactionTypeID IN(3,13),SoldUnits,0))>SUM(IF(TrasactionTypeID IN(5,14),SoldUnits,0)),(SUM(IF(TrasactionTypeID IN(3,13),SoldUnits,0)) - SUM(IF(TrasactionTypeID IN(5,14),SoldUnits,0))),0)) ");
                sb.Append(" FROM f_salesdetails  WHERE DATE<='" + Util.GetDateTime(EntryDate1.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE>=ADDDATE('" + Util.GetDateTime(EntryDate2.Text.Trim()).ToString("yyyy-MM-dd") + "',-30) AND  ");
                sb.Append(" Itemid=pod.itemid AND  TrasactionTypeID IN(5,14,3,13) AND ");
                sb.Append(" StoreLedgerNo IN ('" + StoreType + "') ");
                sb.Append(" ) Last_Mon_Cosmp, (SELECT SUM(st.InitialCount-st.ReleasedCount)Whole_Hosp_Stock FROM f_stock st WHERE st.ispost=1 AND ");
                sb.Append(" (st.InitialCount-st.ReleasedCount)>0 AND DATE(st.MedExpiryDate)>CURDATE()  AND st.itemid = pod.ItemID )Whole_Hosp_Stock ,");
                sb.Append(" (SELECT SUM(st.InitialCount-st.ReleasedCount) FROM f_stock st WHERE st.ispost=1 AND ");
                sb.Append(" (st.InitialCount-st.ReleasedCount)>0 AND DATE(st.MedExpiryDate)>CURDATE() AND StoreLedgerNo ='" + cmbPurchase.SelectedValue + "' AND st.itemid = pod.ItemID)MainStore_Stock ");
            

            sb.Append(" FROM f_purchaseorder PO INNER JOIN f_purchaseorderdetails POD ON PO.PurchaseOrderNo=POD.PurchaseOrderNo  ");
            sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.subcategoryID=POD.SubCategoryID ");
            sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID=scm.CategoryID ");
            sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID=cm.CategoryID AND po.StoreLedgerNo='" + rdoMedical_general.SelectedItem.Value + "'    ");
            sb.Append(" LEFT JOIN  ( ");                                                                                                                             // AND pod.status<>2
            sb.Append("     SELECT POt.PONumber,POT.PODetailID,POT.TaxPer,PTM.TaxName  FROM f_purchaseordertax POT ");
            sb.Append("     INNER JOIN f_taxmaster PTM ON POT.TaxID=PTM.TaxID ");
            sb.Append(" )t2 ON POD.PurchaseOrderDetailID=t2.PODetailID ");

            string str = GetCreitaria();
            sb.Append(str);

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Purchase Detail Report";
                Session["Period"] = "From : " + EntryDate1.Text.Trim() + " To : " + EntryDate2.Text.Trim();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);

            }
        }
        else
        {
            string Query = "", ReportType = "", strTax = "";
            if (rdoReportType.SelectedValue == "1")
            {
                //Query = "select distinct(PO.PurchaseOrderNo),PO.Subject,PO.VendorName,PO.NetTotal,(select Name from employee_master where Employee_Id=PO.RaisedUserID)RaisedUser,date_format(PO.RaisedDate,'%d-%b-%y')RaisedDate,PO.Type,(case when Po.Status = 0 then 'Pending' when Po.Status = 1 then 'Reject' when Po.Status = 2 then 'Open' when Po.Status = 3 then 'Close' end )Status from f_purchaseorder PO inner join f_purchaseorderdetails POD on PO.PurchaseOrderNo=POD.PurchaseOrderNo";
                Query = "select distinct(PO.PurchaseOrderNo),PO.Subject,PO.VendorName,PO.NetTotal,(select Name from employee_master where EmployeeId=PO.RaisedUserID)RaisedUser,date_format(PO.RaisedDate,'%d-%b-%y')RaisedDate,PO.Type,(case when Po.Status = 0 then 'Pending' when Po.Status = 1 then 'Reject' when Po.Status = 2 then 'Open' when Po.Status = 3 then 'Close' end )Status from f_purchaseorder PO inner join f_purchaseorderdetails POD on PO.PurchaseOrderNo=POD.PurchaseOrderNo inner join f_subcategorymaster scm on scm.subcategoryID=POD.SubCategoryID inner join f_categorymaster cm on cm.CategoryID=scm.CategoryID inner join f_configrelation c on c.CategoryID=cm.CategoryID and po.StoreLedgerNo='" + rdoMedical_general.SelectedItem.Value + "'";
                ReportType = "SummaryPO";
            }
            else
            {
                //Query = "select distinct(PO.PurchaseOrderNo),POD.PurchaseOrderDetailID,POD.RecievedQty,POD.Specification,PO.Subject,PO.VendorName,POD.ItemName,POD.OrderedQty,POD.Rate,POD.Discount_p,(select Name from employee_master where Employee_Id=PO.RaisedUserID)RaisedUser,POD.BuyPrice,(case when POD.IsFree = 0 then 'No' when POD.IsFree = 1 then 'Yes' end )IsFree,date_format(PO.RaisedDate,'%d-%b-%y')RaisedDate,PO.Type,(case when Po.Status = 0 then 'Pending' when Po.Status = 1 then 'Reject' when Po.Status = 2 then 'Open' when Po.Status = 3 then 'Close' end )Status  from f_purchaseorder PO inner join f_purchaseorderdetails POD on PO.PurchaseOrderNo=POD.PurchaseOrderNo     AND pod.status<>2";
                Query = "select distinct(PO.PurchaseOrderNo),POD.PurchaseOrderDetailID,POD.RecievedQty,POD.Specification,PO.Subject,PO.VendorName,POD.ItemName,POD.OrderedQty,POD.Rate,POD.Discount_p,(select Name from employee_master where EmployeeId=PO.RaisedUserID)RaisedUser,POD.BuyPrice,(case when POD.IsFree = 0 then 'No' when POD.IsFree = 1 then 'Yes' end )IsFree,date_format(PO.RaisedDate,'%d-%b-%y')RaisedDate,PO.Type,(case when Po.Status = 0 then 'Pending' when Po.Status = 1 then 'Reject' when Po.Status = 2 then 'Open' when Po.Status = 3 then 'Close' end )Status  from f_purchaseorder PO inner join f_purchaseorderdetails POD on PO.PurchaseOrderNo=POD.PurchaseOrderNo  inner join f_subcategorymaster scm on scm.subcategoryID=POD.SubCategoryID inner join f_categorymaster cm on cm.CategoryID=scm.CategoryID inner join f_configrelation c on c.CategoryID=cm.CategoryID and po.StoreLedgerNo='" + rdoMedical_general.SelectedItem.Value + "'   ";      // AND pod.status<>2

                ReportType = "DetailPO";
            }

            string str = GetCreitaria();

            if (str != string.Empty)
                Query = Query + str;


            DataTable dtTax = new DataTable();
            DataTable dt = StockReports.GetDataTable(Query);
            if (dt != null && dt.Rows.Count > 0)
            {
                strTax = "select t1.PurchaseOrderDetailID,t2.TaxPer,t2.TaxName from (select distinct(PO.PurchaseOrderNo),POD.PurchaseOrderDetailID,PO.Subject,PO.VendorName,POD.ItemName,POD.OrderedQty,POD.Rate,POD.Discount_p,POD.BuyPrice from f_purchaseorder PO inner join f_purchaseorderdetails POD on PO.PurchaseOrderNo=POD.PurchaseOrderNo " + str + "  )t1 inner join  (select POt.PONumber,POT.PODetailID,POT.TaxPer,PTM.TaxName  from f_purchaseordertax POT inner join f_taxmaster PTM on POT.TaxID=PTM.TaxID)t2 on t1.PurchaseOrderDetailID=t2.PODetailID";
                dtTax = StockReports.GetDataTable(strTax);
                DataColumn dc1 = new DataColumn();
                dc1.ColumnName = "PRDate";

                if ((EntryDate1.Text.Trim() != string.Empty) && (EntryDate2.Text.Trim() != string.Empty))
                {
                    dc1.DefaultValue = "From : " + EntryDate1.Text.Trim() + " To : " + EntryDate2.Text.Trim();
                }
                else
                {
                    dc1.DefaultValue = "As On : " + DateTime.Now.ToString("dd-MM-yyyy");
                }

                //New Column For StoreType
                DataColumn dcStore_Type = new DataColumn();
                dcStore_Type.ColumnName = "StoreType";
                dcStore_Type.DefaultValue = rdoMedical_general.SelectedItem.Text;
                dt.Columns.Add(dcStore_Type);

                DataColumn dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc1);
                dt.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                ds.Tables[0].TableName = "PODetail";
                ds.Tables.Add(dtTax.Copy());
                ds.Tables[1].TableName = "Tax";
                //ds.WriteXmlSchema(@"C:\searchPO55.xml");
                Session["ds"] = ds;
                Session["ReportName"] = ReportType;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/commonreport.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                GridView1.DataSource = null;
                GridView1.DataBind();
            }
        }

    }
    #endregion
    protected void rdoReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdoReportType.SelectedValue == "1")
            rbtPDF.Visible = false;
        else
            rbtPDF.Visible = true;
    }
    protected void btnSN_Click(object sender, EventArgs e)
    {
        searchPRbtn("Approved");
    }
    protected void btnRN_Click(object sender, EventArgs e)
    {
        searchPRbtn("Grn Done");
    }
    protected void btnNA_Click(object sender, EventArgs e)
    {
        searchPRbtn("Rejected");
    }
    protected void btnA_Click(object sender, EventArgs e)
    {
        searchPRbtn("Pending Approval");
    }
    protected void cmbPurchase_SelectedIndexChanged(object sender, EventArgs e)
    {
        Search();
    }
    protected void chkitem_CheckedChanged(object sender, EventArgs e)
    {
        if (chkitem.Checked)
            BindItem();
        else
        {
            lstItem.Items.Clear();
            lstItem.Items.Add("No Item Found");
        }
    }
    private void BindCategory()
    {
        DataTable dtcategory = StockReports.GetDataTable("SELECT cm.Name,cm.CategoryID FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cf.CategoryID = cm.CategoryID WHERE cf.ConfigID IN (11,28)");
        if (dtcategory.Rows.Count > 0)
        {
            ddlCategory.DataSource = dtcategory;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("All"));
        }
    }
}
