using System;
using System.Data;
using System.Drawing;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Laundry_ReturnToDepatment : System.Web.UI.Page
{
    public void LoadStock()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT   st.itemID,st.itemName  itemName  FROM f_stock st INNER JOIN f_itemmaster im ON st.ItemID=im.ItemID AND im.isLaundry=1 ");
        sb.Append(" WHERE st.DeptLedgerNo = '" + ViewState["DeptLedgerNo"] + "'   ");
        sb.Append(" AND (st.InitialCount - (st.PendingQty+st.ReleasedCount)) > 0 ");
        //sb.Append(" AND st.FromStockID <> '' AND st.ispost = 1  AND CentreID='" + Session["CentreID"].ToString() + "' ");
        sb.Append("  AND st.ispost = 1  AND CentreID='" + Session["CentreID"].ToString() + "' ");
        //sb.Append(" AND HospCentreID='" + Session["HospCentreID"].ToString() + "'  GROUP BY st.itemName   ");
        sb.Append(" GROUP BY st.itemName   ");

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
    public void BindRequestDetails()
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT ItemID,ItemName,ReturnQty 'Send Qty',(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=ReturnBy)'Send By',  ");
        Query.Append("DATE_FORMAT(ReturnDate,'%d-%b-%Y %l:%i %p')'Send Date',IF(IsComplete=0,'No','Yes')Completed,WashingQty,DryerQty,IroningQty ");

        Query.Append("FROM laundry_recieve_stock WHERE FromDept='" + ViewState["DeptLedgerNo"].ToString() + "' AND centreID='" + Session["CentreID"].ToString() + "' ");
        

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            grdRequestDetail.DataSource = dt;
            grdRequestDetail.DataBind();
        }
        else
        {
            grdRequestDetail.DataSource = null;
            grdRequestDetail.DataBind();
        }
    }
    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";

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
                    DateTime expirydate = Util.GetDateTime(((Label)row.FindControl("lblExpiryDate")).Text);
                    DateTime currentdate = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy"));

                    string isExp = (((Label)row.FindControl("lblIsExpirable")).Text).ToLower();

                    if (isExp != "no")
                    {
                        if (((Label)row.FindControl("lblExpiryDate")).Text != "01-Jan-0001")
                        {
                            if (currentdate <= expirydate)
                            {
                            }
                            else
                            {
                                lblMsg.Text = "Medicine Expired";
                                return;
                            }
                        }
                    }

                    if (Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text).ToString() == "" || Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text).ToString() == "0")
                    {
                        lblMsg.Text = "Please Specify Quantity";
                        return;
                    }
                    DataRow dr = dt.NewRow();
                    dr["ItemID"] = ((Label)row.FindControl("lblItemID")).Text;
                    dr["ItemName"] = ((Label)row.FindControl("lblItemName")).Text;
                    dr["BatchNumber"] = ((Label)row.FindControl("lblBatchNumber")).Text;
                    dr["UnitPrice"] = Util.GetDecimal(((Label)row.FindControl("lblUnitPrice")).Text);
                    decimal Qty = Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text);
                    dr["ReturnQty"] = Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text);
                    dr["Qty"] = ((Label)row.FindControl("lblAvailQty")).Text;
                    dr["UnitType"] = ((Label)row.FindControl("lblUnitType")).Text;
                    dr["MedExpiryDate"] = ((Label)row.FindControl("lblMedExpiryDate")).Text;
                    dr["StockID"] = ((Label)row.FindControl("lblStockId")).Text;
                    dr["FromStockID"] = ((Label)row.FindControl("lblFromStockID")).Text;
                    dr["SubCategoryID"] = ((Label)row.FindControl("lblSubCategoryID")).Text;
                    dr["Comment"] = ((TextBox)row.FindControl("txtComment")).Text;

                    dt.Rows.Add(dr);
                }
            }

            dt.AcceptChanges();
            ViewState["StockTransfer"] = dt;
            grdItemDetails.DataSource = dt;
            grdItemDetails.DataBind();
            grdItem.DataSource = null;
            grdItem.DataBind();
            txtSearch.Text = "";
            btnAddItem.Visible = false;
            txtSearch.Focus();
            if (dt.Rows.Count > 0)
                btnSave.Visible = true;

        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        SaveData();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (ListBox1.SelectedValue != "")
        {
            SearchItem();
        }
        else
        {
            lblMsg.Text = "Please Select Item";
            return;
        }
    }

    protected void grdItem_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblAvailQty")).Text == "0")
            {
                ((CheckBox)e.Row.FindControl("chkSelect")).Visible = false;
            }
            else
            {
                ((CheckBox)e.Row.FindControl("chkSelect")).Visible = true;
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
            ViewState["StockTransfer"] = dtItem;
            if (dtItem.Rows.Count == 0)
            {
                btnSave.Visible = false;
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
            BindRequestDetails();
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
            ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByValue("LSHHI205"));
            ddlDept.Enabled = false;

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

    private DataTable GetItemDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("StockID");
        dt.Columns.Add("ItemID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNumber");
        dt.Columns.Add("SubCategoryID");
        dt.Columns.Add("UnitType");                            
        dt.Columns.Add("UnitPrice", typeof(decimal));
        dt.Columns.Add("Qty", typeof(decimal));
        dt.Columns.Add("IssueQty", typeof(decimal));
        dt.Columns.Add("ReturnQty", typeof(decimal));            
        
        dt.Columns.Add("MedExpiryDate");
        dt.Columns.Add("FromStockID");
        dt.Columns.Add("BarcodeID");

        dt.Columns.Add("Comment");
        return dt;
    }

    private void SaveData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        if (ViewState["StockTransfer"] != null)
        {
            try
            {
               // string barcodeid = "";
               // string str_StockId = "";
                DataTable dtItem = (DataTable)ViewState["StockTransfer"];
                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('1','" + AllGlobalFunction.GeneralStoreID + "','" + Session["CentreID"].ToString() + "')"));
                for (int i = 0; i < dtItem.Rows.Count; i++)
                {

                   



                    string stt = "SELECT UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and IsPost=1 and StockID='" + Util.GetString(dtItem.Rows[i]["StockID"]) + "' AND CentreID = '"+Util.GetInt(Session["CentreID"].ToString())+"'";
                    DataTable dtResult = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stt).Tables[0];

                    //str_StockId = dtResult.Rows[i]["StockID"].ToString();
                    //barcodeid = dtResult.Rows[i]["barcodeID"].ToString();

                    Sales_Details ObjSales = new Sales_Details(Tranx);
                    ObjSales.Hospital_ID = Session["HOSPID"].ToString();
                    ObjSales.LedgerNumber = ddlDept.SelectedItem.Value;
                    ObjSales.DepartmentID = "STO00002";
                    ObjSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    ObjSales.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                    ObjSales.SoldUnits = Util.GetDecimal(dtItem.Rows[i]["ReturnQty"]);
                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtResult.Rows[0]["UnitPrice"]);
                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtResult.Rows[0]["MRP"]);
                    ObjSales.Date = DateTime.Now;
                    ObjSales.Time = DateTime.Now;
                    ObjSales.IsReturn = 0;
                    ObjSales.LedgerTransactionNo = "";
                    ObjSales.TrasactionTypeID = 1;
                    ObjSales.IsService = "NO";
                    ObjSales.SalesNo = SalesNo;
                    ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                    ObjSales.UserID = ViewState["ID"].ToString();
                    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    //ObjSales.HospCentreID = Util.GetInt(Session["HospCentreID"].ToString());
                    string SalesID = ObjSales.Insert();
                    if (SalesID == string.Empty)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error ..";

                        return;
                    }

                   

                    ReturnToLaundry rtl = new ReturnToLaundry(Tranx);
                    rtl.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                    rtl.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    rtl.ItemName = Util.GetString(dtItem.Rows[i]["ItemName"]);
                    rtl.BatchNo = Util.GetString(dtItem.Rows[i]["BatchNumber"]);
                    rtl.ReturnQty = Util.GetDecimal(dtItem.Rows[i]["ReturnQty"]);
                    rtl.ReturnBy = ViewState["ID"].ToString();
                    rtl.SubCategoryID = Util.GetString(dtItem.Rows[i]["SubCategoryID"]);
                    rtl.FromDept = ViewState["DeptLedgerNo"].ToString();
                    rtl.DeptLedgerNo = ddlDept.SelectedItem.Value;
                    rtl.Unit = Util.GetString(dtItem.Rows[i]["UnitType"]);
                    rtl.MedExpiryDate = Util.GetDateTime(dtItem.Rows[i]["MedExpiryDate"]);
                    rtl.FromStockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                    rtl.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    //rtl.HospCentreID = Util.GetInt(Session["HospCentreID"].ToString());
                    rtl.Hospital_ID = Session["HOSPID"].ToString();
                    rtl.Remark = Util.GetString(dtItem.Rows[i]["Comment"]);
                    rtl.Insert();

                    //----Check Release Count in Stock Table---------------------
                    string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetDecimal(dtItem.Rows[i]["ReturnQty"]) + "),0,1)CHK from f_stock where stockID=" + Util.GetString(dtItem.Rows[i]["StockID"])+" AND CentreID ='"+ Util.GetInt(Session["CentreID"].ToString())+"'" ;
                    if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error ..";
                        return;
                    }

                    //---- Update Release Count in Stock Table---------------------
                    string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetDecimal(dtItem.Rows[i]["ReturnQty"]) + " where StockID = " + Util.GetString(dtItem.Rows[i]["StockID"]) + " AND CentreID ='" + Util.GetInt(Session["CentreID"].ToString()) + "'";

                    int flag = Util.GetInt(MySqlHelperNEw.ExecuteNonQuery(Tranx, CommandType.Text, strStock));

                    if (flag == 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error ..";
                        return;
                    }


                }
                Tranx.Commit();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "modelAlert('Record Save Successfully.', function () { window.location.href='ReturnToDepatment.aspx' });", true);
            }
            catch (Exception ex)
            {
                Tranx.Rollback();

                ClassLog c1 = new ClassLog();
                c1.errLog(ex);
                lblMsg.Text = "Error ..";
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    private void SearchItem()
    {
        if (ListBox1.SelectedIndex != -1)
        {

            lblMsg.Text = "";
            StringBuilder sb = new StringBuilder();

            sb.Append("SELECT  t1.* FROM (SELECT  DATE_FORMAT(s.MedExpiryDate, '%d-%b-%Y')ExpiryDate,s.FromStockID,s.StockID,s.ItemID,s.ItemName,s.BatchNumber,s.SubCategoryID,s.UnitPrice,s.MRP,CAST((s.InitialCount-s.ReleasedCount-s.PendingQty)AS DECIMAL(10,2)) AvailQty,DATE_FORMAT(s.MedExpiryDate,'%d-%b-%Y')    MedExpiryDate,s.UnitType, im.`IsExpirable`,");
            sb.Append("    (SELECT LedgerName   FROM f_ledgermaster  WHERE LedgerNumber = s.fromdept AND GroupId = 'DPT')    FromDept FROM f_stock s INNER JOIN `f_itemmaster` im ON im.`ItemID`=s.`ItemID` ");
            //sb.Append("  WHERE s.ItemID = '" + ListBox1.SelectedValue + "' AND (s.InitialCount-s.ReleasedCount)>0  AND s.IsPost = 1   AND s.DeptLedgerNo ='" + ViewState["DeptLedgerNo"] + "'  AND  CentreID='" + Session["CentreID"].ToString() + "' AND HospCentreID='" + Session["HospCentreID"].ToString() + "' ");
            sb.Append("  WHERE s.ItemID = '" + ListBox1.SelectedValue + "' AND (s.InitialCount-s.ReleasedCount)>0  AND s.IsPost = 1   AND s.DeptLedgerNo ='" + ViewState["DeptLedgerNo"] + "'  AND  CentreID='" + Session["CentreID"].ToString() + "' ");
            sb.Append(" ORDER BY s.stockid) t1 ");


            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                grdItem.DataSource = dt;
                grdItem.DataBind();
                btnAddItem.Focus();

                btnAddItem.Visible = true;
                btnSave.Visible = false;
            }
            else
            {
                lblMsg.Text = "Item Quantity Not Available";
                grdItem.DataSource = null;
                grdItem.DataBind();
                btnAddItem.Visible = false;
            }
        }
    }
    private bool ValidateItems()
    {
        DataTable dt = null;
        if (ViewState["StockTransfer"] != null)
            dt = (DataTable)ViewState["StockTransfer"];


        bool status = true;
        int chkvalue = 0;

        foreach (GridViewRow row in grdItem.Rows)
        {
            if (ddlDept.SelectedItem.Text != "Select")
            {
                status = false;
            }
            if (((CheckBox)row.FindControl("chkSelect")).Checked)
            {
                if (dt != null && dt.Rows.Count > 0)
                {
                    string stockID = ((Label)row.FindControl("lblStockId")).Text;


                    DataRow[] drow = dt.Select("StockID = '" + stockID + "' ");
                    if (drow.Length > 0)
                    {
                        lblMsg.Text = "Item Already Selected";
                        return false;
                    }
                }

                decimal TransferQty = 0, AvailQty = 0;
                string value = Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text).ToString();
                if (value != string.Empty)
                    TransferQty = Util.GetDecimal(((TextBox)row.FindControl("txtReturnQty")).Text);
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
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
            return false;
        }
        foreach (GridViewRow row in grdItem.Rows)
        {
            if (((CheckBox)row.FindControl("chkSelect")).Checked)
            {
                chkvalue = chkvalue + 1;
            }
        }
        if (chkvalue == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            return false;
        }
        return true;

    }
}