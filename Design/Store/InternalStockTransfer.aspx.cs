using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web;

public partial class Design_Store_InternalStockTransfer : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            DateFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            DateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoadData_Store.checkStoreRight(rblStoreType);
            bindCentre();
            BindDepartment();
            BindSubCategory(rblStoreType.SelectedValue);
        }
        DateFrom.Attributes.Add("readOnly", "true");
        DateTo.Attributes.Add("readOnly", "true");
    }
    private void bindCentre()
    {

        DataTable dtCentre = All_LoadData.dtbind_Center();
        if (dtCentre.Rows.Count > 0)
        {
            ddlFromCentre.DataTextField = "CentreName";
            ddlFromCentre.DataValueField = "CentreID";
            ddlFromCentre.DataSource = dtCentre;
            ddlFromCentre.DataBind();
        }
        ddlFromCentre.Items.Insert(0, new ListItem("All", "0"));
        ddlFromCentre.SelectedIndex = 0;
    }
    private void BindDepartment()
    {
        string str = "select LedgerNumber,LedgerName from  f_ledgermaster where GroupID='DPT' and IsCurrent=1 order by LedgerName ";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "LedgerName";
            ddlDepartment.DataValueField = "LedgerNumber";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("All", "0"));
        }
    }
    private void BindSubCategory(string StorLedgerNo)
    {
        string ConfigID="";
        if (StorLedgerNo.ToString() == "STO00001")
            ConfigID = "11";
        else
            ConfigID = "28";

        string str= "SELECT sc.SubCategoryID,sc.Name FROM f_subcategorymaster sc INNER JOIN f_configrelation cr ON cr.CategoryID=sc.CategoryID WHERE cr.ConfigID = "+ConfigID+"";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSubGroup.DataSource = dt;
            ddlSubGroup.DataTextField = "Name";
            ddlSubGroup.DataValueField = "SubCategoryID";
            ddlSubGroup.DataBind();
            ddlSubGroup.Items.Insert(0, new ListItem("All", "0"));
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
        dt.Columns.Add("DeptFrom");
        dt.Columns.Add("DeptTo");
        dt.Columns.Add("AvailQty", typeof(decimal));
        dt.Columns.Add("MRP", typeof(decimal));
        dt.Columns.Add("UnitPrice", typeof(decimal));
        dt.Columns.Add("Qty", typeof(decimal));
        dt.Columns.Add("IssueQty", typeof(decimal));
        dt.Columns.Add("Amount", typeof(decimal));
        dt.Columns.Add("id", typeof(int));
        dt.Columns.Add("IndentNo");
        dt.Columns.Add("ReqQty", typeof(decimal));
        dt.Columns.Add("ReceiveQty", typeof(decimal));
        dt.Columns.Add("RejectQty", typeof(decimal));

        return dt;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

        bool isSelect = false;
        int count = 0;//for checking if qty is Entered or not
        foreach (RepeaterItem lt in grdIndentDetails.Items)
        {

            Repeater grdItem = (Repeater)lt.FindControl("grdItem");
            Repeater grdItemGenric = (Repeater)lt.FindControl("grdItemGenric");
            Label LbItemId = (Label)lt.FindControl("lblItemID");
            Label RequestQty = (Label)lt.FindControl("lblRequestedQty");
            Label LAvailQty = (Label)lt.FindControl("lblAvailQty");
            CheckBox chkSelect = (CheckBox)lt.FindControl("chkSelect");
            if (chkSelect.Checked)
            {

                decimal newIssueQty = 0;
                if (grdItem.Items.Count > 0)
                {
                    foreach (RepeaterItem grItem in grdItem.Items)
                    {
                        GridView grdItemNew = (GridView)grItem.FindControl("grdItemNew");
                        if (grdItemNew != null)
                        {
                            if (grdItemNew.Rows.Count > 0)
                            {
                                foreach (GridViewRow grItemNew in grdItemNew.Rows)
                                {
                                    if (Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) > 0)
                                    {
                                        newIssueQty = newIssueQty + Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                        count++;
                                    }
                                }
                            }
                        }
                        if (Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text) > 0)
                        {
                            newIssueQty = newIssueQty + Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                            count++;
                        }

                    }
                    isSelect = true;
                }

                else if (grdItemGenric.Items.Count > 0)
                {
                    foreach (RepeaterItem grItemGenric in grdItemGenric.Items)
                    {
                        GridView grdItemNewgenric = (GridView)grItemGenric.FindControl("grdItemNewgenric");
                        if (grdItemNewgenric != null)
                        {
                            if (grdItemNewgenric.Rows.Count > 0)
                            {
                                foreach (GridViewRow grItemNewgenric in grdItemNewgenric.Rows)
                                {
                                    if (Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) > 0)
                                    {
                                        newIssueQty = newIssueQty + Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                        count++;
                                    }
                                }
                            }
                        }

                    }
                    isSelect = true;
                }

                decimal totalRequest = Util.GetDecimal(((Label)lt.FindControl("lblRequestedQty")).Text);
                decimal oldIssueQty = Util.GetDecimal(((Label)lt.FindControl("lblIssuedQty")).Text);
                decimal oldReject = Util.GetDecimal(((Label)lt.FindControl("lblRejectedQty")).Text);
                decimal txtReject = Util.GetDecimal(((TextBox)lt.FindControl("txtReject")).Text);
                if (txtReject != 0)
                {
                    string Reason = Util.GetString(((TextBox)lt.FindControl("txtReason")).Text);

                    if (Reason == "")
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM091','" + lblMsg.ClientID + "');", true);
                        ((TextBox)lt.FindControl("txtReason")).Focus();
                        return;
                    }
                    count++;
                    isSelect = true;
                }
                decimal pendingQty = Util.GetDecimal(((Label)lt.FindControl("lblPendingQty")).Text);
                if (totalRequest < oldIssueQty + oldReject + txtReject + newIssueQty)
                {
                    if (newIssueQty == 0 && txtReject > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Reject Qty. is greater than requested Qty.');", true);
                    }
                    else
                    {

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Issue Qty. is greater than requested Qty.');", true);
                    } return;
                }
                else
                    ((TextBox)lt.FindControl("txtIssueingQty")).Text = Util.GetString(newIssueQty);
            }
        }
        if (!isSelect)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('No Item is Selected./Enter Qty');", true);
            return;
        }
        else if (count == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Please Enter Issue/Reject Qty');", true);
            return;
        }
        else
            SaveIndentData();
    }

    private void SaveIndentData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int SalesNo = 0;
            if (Util.GetInt(ViewState["FromcentreID"].ToString()) != Util.GetInt(Session["CentreID"].ToString()))
                SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT Get_SalesNo('27','" + ViewState["StoreID"].ToString() + "','" + Session["CentreID"].ToString() + "') "));
            else
                SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT Get_SalesNo('1','" + ViewState["StoreID"].ToString() + "','" + Session["CentreID"].ToString() + "') "));

            if (SalesNo == 0)
            {
                Tranx.Rollback();
                return;
            }

            string IndentNo = "";
            string str_StockId = "";
            decimal TIssueQty = 0;

            foreach (RepeaterItem ri in grdIndentDetails.Items)
            {
                IndentNo = Util.GetString(((Label)ri.FindControl("lblIndentNo")).Text.Trim());
                if (((CheckBox)ri.FindControl("chkSelect")).Checked)
                {
                    // GridView grdIt = (GridView)ri.FindControl("grdItem");
                    string GenricItemid = ((Label)ri.FindControl("lblItemID")).Text.ToString();
                    Repeater grdItem = (Repeater)ri.FindControl("grdItem");
                    Repeater grdItemGenric = (Repeater)ri.FindControl("grdItemGenric");
                    decimal newIssueQty = 0;

                    if (grdItem.Items.Count > 0)
                    {
                        foreach (RepeaterItem grItem in grdItem.Items)
                        {
                            GridView grdItemNew = (GridView)grItem.FindControl("grdItemNew");
                            if (grdItemNew != null)
                            {
                                if (grdItemNew.Rows.Count > 0)
                                {
                                    foreach (GridViewRow grItemNew in grdItemNew.Rows)
                                    {
                                        if (Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) > 0)
                                        {
                                            newIssueQty = newIssueQty + Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                            str_StockId = ((Label)grItemNew.FindControl("lblStockIDnew")).Text;
                                            //GST Changes
                                            string stt = "select IsExpirable,StockID,BarCodeID,ItemID,Rate,DiscPer,round((DiscAmt/InitialCount),4) as DiscAmt,PurTaxPer ,round((PurTaxAmt/InitialCount),4) as PurTaxAmt , SaleTaxPer,round((SaleTaxAmt/InitialCount),4) as SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType,MajorUnit,MinorUnit,ConversionFactor,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,IGSTAmtPerUnit,SGSTAmtPerUnit,CGSTAmtPerUnit,GSTType,VenLedgerNo FROM f_stock st  WHERE DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "'  and (InitialCount-ReleasedCount-PendingQty)>0  and  Ispost=1 and Stockid='" + str_StockId + "'";

                                            DataTable dtResult = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stt).Tables[0];
                                            if (dtResult != null && dtResult.Rows.Count > 0)
                                            {
                                                int i = 0;
                                                string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + "),0,1)CHK from f_stock where stockID='" + str_StockId + "'";
                                                if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                                                {
                                                    Tranx.Rollback();
                                                    return;
                                                }
                                                string strStock = "UPDATE f_stock set ReleasedCount = ReleasedCount + " + Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + " where StockID = '" + str_StockId + "'";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);
                                                string sqlind = "SELECT   ReqQty-(ReceiveQty+RejectQty) FROM f_indent_detail WHERE indentNo='" + IndentNo + "' AND itemID= '" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "' ";
                                                decimal RemQty = Util.GetDecimal(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sqlind));
                                                decimal AvlQty = RemQty - Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                                if (AvlQty < 0)
                                                {
                                                    DataTable DtIndent = (DataTable)ViewState["StockTransfer"];
                                                    foreach (DataRow dr in DtIndent.Rows)
                                                    {
                                                        if (Util.GetString(dr["ItemId"]) == Util.GetString(dtResult.Rows[i]["ItemID"]))
                                                            dr["PendingQty"] = RemQty;
                                                    }
                                                    DtIndent.AcceptChanges();
                                                    grdIndentDetails.DataSource = DtIndent;
                                                    grdIndentDetails.DataBind();
                                                    Tranx.Rollback();
                                                    return;
                                                }

                                                //DEVENDRA
                                                StringBuilder sb = new StringBuilder();
                                                sb.Append("INSERT INTO f_indent_detail(IndentNo,ItemId,ItemName,ReqQty,ReceiveQty,UnitType,DeptFrom,DeptTo,StoreId,Narration,UserId,Type,GenricType,OLDItemID,CentreID,Hospital_Id,ToCentreID)  ");
                                                sb.Append("values('" + IndentNo + "','" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "','" + Util.GetString(dtResult.Rows[i]["ItemName"]) + "'," + Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + "," + Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + "");
                                                sb.Append(",'" + Util.GetString(dtResult.Rows[i]["UnitType"]) + "','" + ViewState["deptFrom"].ToString() + "','" + ViewState["DeptLedgerNo"].ToString() + "','" + ViewState["StoreID"].ToString() + "','genric Item issue','" + ViewState["ID"].ToString() + "','Normal','GENERIC','" + GenricItemid + "','" + Session["CentreID"].ToString() + "','" + Session["HOSPID"].ToString() + "'," + Util.GetInt(ViewState["FromcentreID"].ToString()) + ") ");


                                                string strIndent = "UPDATE f_indent_detail set RejectQty = RejectQty + " + Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + ",ReceiveQty = ReceiveQty -" + Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + ",RejectBy='" + ViewState["ID"].ToString() + "',RejectReason='Generic Item Issued' where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptFrom='" + ViewState["deptFrom"].ToString() + "'";

                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndent);
                                                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                                                {
                                                    Tranx.Rollback();
                                                    return;
                                                }

                                                decimal MRP = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                                                decimal SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                                decimal SaleTaxAmtPerUnit = Math.Round(((((MRP * 100) / (100 + SaleTaxPer)) * SaleTaxPer) / 100), 6);
                                                decimal TaxablePurVATAmt = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]) * Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) * (100 / (100 + Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"])));
                                                decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]) / 100;


                                                Stock objStock = new Stock(Tranx);
                                                objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                                objStock.InitialCount = Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                                objStock.BatchNumber = Util.GetString(dtResult.Rows[i]["BatchNumber"]);
                                                objStock.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                                objStock.ItemName = Util.GetString(dtResult.Rows[i]["ItemName"]);
                                                objStock.DeptLedgerNo = Util.GetString(ViewState["deptFrom"].ToString());
                                                objStock.IsFree = 0;
                                                if (Util.GetInt(ViewState["FromcentreID"].ToString()) != Util.GetInt(Session["CentreID"].ToString()))
                                                {
                                                    objStock.IsPost = 4;
                                                    objStock.FromCentreID = Util.GetInt(Session["CentreID"].ToString());
                                                }
                                                else
                                                {
                                                    objStock.IsPost = 1;
                                                }
                                                objStock.PostDate = DateTime.Now;
                                                objStock.MRP = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                                                objStock.StockDate = DateTime.Now;
                                                objStock.Unit = Util.GetString(dtResult.Rows[i]["UnitType"]);
                                                objStock.SubCategoryID = Util.GetString(dtResult.Rows[i]["SubCategoryID"]);
                                                objStock.UnitPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                                                objStock.IsCountable = 1;
                                                objStock.IsReturn = 0;
                                                objStock.FromDept = ViewState["DeptLedgerNo"].ToString();
                                                objStock.FromStockID = Util.GetString(dtResult.Rows[i]["StockID"]);
                                                objStock.IndentNo = Util.GetString(txtIndentNo.Text.Trim());
                                                objStock.MedExpiryDate = Util.GetDateTime(dtResult.Rows[i]["MedExpiryDate"]);
                                                objStock.RejectQty = Util.GetDouble(((TextBox)ri.FindControl("txtReject")).Text);
                                                objStock.Unit = Util.GetString(dtResult.Rows[i]["UnitType"]);
                                                objStock.StoreLedgerNo = ViewState["StoreID"].ToString();
                                                objStock.UserID = ViewState["ID"].ToString();
                                                objStock.PostUserID = ViewState["ID"].ToString();
                                                objStock.Rate = Util.GetDecimal(dtResult.Rows[i]["Rate"]);
                                                objStock.TYPE = Util.GetString(dtResult.Rows[i]["TYPE"]);
                                                objStock.IsBilled = Util.GetInt(dtResult.Rows[i]["IsBilled"]);
                                                objStock.Reusable = Util.GetInt(dtResult.Rows[i]["Reusable"]);
                                                objStock.SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                                //   objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);
                                                objStock.SaleTaxAmt = Util.GetDecimal(SaleTaxAmtPerUnit) * Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                                objStock.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                                                objStock.PurTaxAmt = vatPuramt;
                                                //  objStock.PurTaxAmt = Util.GetDecimal(dtResult.Rows[i]["PurTaxAmt"]);
                                                objStock.DiscPer = Util.GetDecimal(dtResult.Rows[i]["DiscPer"]);
                                                //  objStock.DiscAmt = Util.GetDecimal(dtResult.Rows[i]["DiscAmt"]);

                                                objStock.DiscAmt = Util.GetDecimal(dtResult.Rows[i]["DiscAmt"]) * Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);

                                                //   objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);

                                                objStock.MajorUnit = Util.GetString(dtResult.Rows[i]["MajorUnit"]);
                                                objStock.MinorUnit = Util.GetString(dtResult.Rows[i]["MinorUnit"]);
                                                objStock.ConversionFactor = Util.GetDecimal(dtResult.Rows[i]["ConversionFactor"]);
                                                //  objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());

                                                objStock.CentreID = Util.GetInt(ViewState["FromcentreID"].ToString());
                                                objStock.IpAddress = All_LoadData.IpAddress();
                                                //GST Changes
                                                objStock.IGSTPercent = Util.GetDecimal(dtResult.Rows[i]["IGSTPercent"]);
                                                objStock.IGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["IGSTAmtPerUnit"]);
                                                objStock.SGSTPercent = Util.GetDecimal(dtResult.Rows[i]["SGSTPercent"]);
                                                objStock.SGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["SGSTAmtPerUnit"]);
                                                objStock.CGSTPercent = Util.GetDecimal(dtResult.Rows[i]["CGSTPercent"]);
                                                objStock.CGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["CGSTAmtPerUnit"]);
                                                objStock.HSNCode = Util.GetString(dtResult.Rows[i]["HSNCode"]);
                                                objStock.GSTType = Util.GetString(dtResult.Rows[i]["GSTType"]);
                                                objStock.LedgerTransactionNo = "0";
                                                objStock.LedgerTnxNo = "0";
                                                objStock.VenLedgerNo = Util.GetString(dtResult.Rows[i]["VenLedgerNo"]);
                                                objStock.IsExpirable = Util.GetInt(dtResult.Rows[i]["IsExpirable"]);
                                                objStock.salesno = SalesNo;
                                                objStock.BarCodeID = Util.GetInt(dtResult.Rows[i]["BarCodeID"]);
                                                string stokID = objStock.Insert();

                                                Sales_Details ObjSales = new Sales_Details(Tranx);
                                                ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                                ObjSales.LedgerNumber = Util.GetString(ViewState["deptFrom"].ToString());
                                                ObjSales.DepartmentID = ViewState["StoreID"].ToString();
                                                ObjSales.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                                ObjSales.StockID = Util.GetString(dtResult.Rows[i]["StockID"]);
                                                ObjSales.SoldUnits = Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                                ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                                                ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                                                ObjSales.Date = DateTime.Now;
                                                ObjSales.Time = DateTime.Now;
                                                ObjSales.IsReturn = 0;
                                                ObjSales.LedgerTransactionNo = "0";
                                                if (Util.GetInt(ViewState["FromcentreID"].ToString()) != Util.GetInt(Session["CentreID"].ToString()))
                                                    ObjSales.TrasactionTypeID = 27;
                                                else
                                                    ObjSales.TrasactionTypeID = 1;
                                                ObjSales.IsService = "NO";
                                                ObjSales.IndentNo = IndentNo;
                                                ObjSales.SalesNo = SalesNo;
                                                ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                                ObjSales.UserID = ViewState["ID"].ToString();
                                                ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                                ObjSales.medExpiryDate = Util.GetDateTime(dtResult.Rows[i]["MedExpiryDate"]);
                                                ObjSales.IpAddress = All_LoadData.IpAddress();

                                                ObjSales.TaxPercent = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                                ObjSales.TaxAmt = Util.GetDecimal(SaleTaxAmtPerUnit) * Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);

                                                ObjSales.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                                                ObjSales.PurTaxAmt = vatPuramt;
                                                //GST Changes
                                                decimal igstPercent = Util.GetDecimal(dtResult.Rows[i]["IGSTPercent"]);
                                                decimal csgtPercent = Util.GetDecimal(dtResult.Rows[i]["CGSTPercent"]);
                                                decimal sgstPercent = Util.GetDecimal(dtResult.Rows[i]["SGSTPercent"]);

                                                decimal taxableAmt = (Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]) * 100 * Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text)) / (100 + igstPercent + csgtPercent + sgstPercent);


                                                //decimal nonTaxableRate = (Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                                                // decimal discount = Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * objLTDetail.DiscountPercentage / 100;
                                                // decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

                                                decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                                                decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                                                decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);

                                                ObjSales.IGSTPercent = igstPercent;
                                                ObjSales.IGSTAmt = IGSTTaxAmount;
                                                ObjSales.CGSTPercent = csgtPercent;
                                                ObjSales.CGSTAmt = CGSTTaxAmount;
                                                ObjSales.SGSTPercent = sgstPercent;
                                                ObjSales.SGSTAmt = SGSTTaxAmount;
                                                ObjSales.HSNCode = Util.GetString(dtResult.Rows[0]["HSNCode"]);
                                                ObjSales.GSTType = Util.GetString(dtResult.Rows[0]["GSTType"]);



                                                ObjSales.Type_ID = "HS";
                                                ObjSales.ToCentreID = Util.GetInt(ViewState["FromcentreID"].ToString());
                                                ObjSales.TransactionID = "0";
                                                ObjSales.ServiceItemID = "0";
                                                //

                                                ObjSales.IpAddress = All_LoadData.IpAddress();
                                                ObjSales.LedgerTransactionNo = "0";

                                                string SalesID = ObjSales.Insert();

                                                if (SalesID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    return;
                                                }


                                                if (stokID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    return;

                                                }


                                            }
                                            else
                                            {
                                                Tranx.Rollback();
                                                return;
                                            }
                                        }
                                    }
                                }
                            }
                            if (Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text) > 0)
                            {
                                newIssueQty = newIssueQty + Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                TIssueQty = TIssueQty + newIssueQty;
                                str_StockId = ((Label)grItem.FindControl("lblStockID")).Text;
                                //GST Changes
                                string stt = "select IsExpirable,StockID,BarcodeID,ItemID,Rate,DiscPer,round((DiscAmt/InitialCount),4) as DiscAmt,PurTaxPer ,round((PurTaxAmt/InitialCount),4) as PurTaxAmt , SaleTaxPer,round((SaleTaxAmt/InitialCount),4) as SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType,MajorUnit,MinorUnit,ConversionFactor,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,IGSTAmtPerUnit,SGSTAmtPerUnit,CGSTAmtPerUnit,GSTType,VenLedgerNo from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";
                                DataTable dtResult = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stt).Tables[0];
                                if (dtResult != null && dtResult.Rows.Count > 0)
                                {
                                    int i = 0;
                                    string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text) + "),0,1)CHK from f_stock where stockID='" + str_StockId + "'";
                                    if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                                    {
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Issue Quantity is not available in the Store');", true);
                                        Tranx.Rollback();
                                        return;
                                    }
                                    string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text) + " where StockID = '" + str_StockId + "'";
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);

                                    decimal MRP = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                                    decimal SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                    decimal SaleTaxAmtPerUnit = Math.Round(((((MRP * 100) / (100 + SaleTaxPer)) * SaleTaxPer) / 100), 6);
                                    decimal TaxablePurVATAmt = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]) * Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text) * (100 / (100 + Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"])));
                                    decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]) / 100;


                                    Stock objStock = new Stock(Tranx);
                                    objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    objStock.InitialCount = Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                    objStock.BatchNumber = Util.GetString(dtResult.Rows[i]["BatchNumber"]);
                                    objStock.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                    objStock.ItemName = Util.GetString(dtResult.Rows[i]["ItemName"]);
                                    objStock.DeptLedgerNo = Util.GetString(ViewState["deptFrom"].ToString());
                                    objStock.IsFree = 0;
                                    if (Util.GetInt(ViewState["FromcentreID"].ToString()) != Util.GetInt(Session["CentreID"].ToString()))
                                    {
                                        objStock.IsPost = 4;
                                        objStock.FromCentreID = Util.GetInt(Session["CentreID"].ToString());
                                    }
                                    else
                                        objStock.IsPost = 1;
                                    objStock.PostDate = DateTime.Now;
                                    objStock.MRP = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                                    objStock.StockDate = DateTime.Now;
                                    objStock.Unit = Util.GetString(dtResult.Rows[i]["UnitType"]);
                                    objStock.SubCategoryID = Util.GetString(dtResult.Rows[i]["SubCategoryID"]);
                                    objStock.UnitPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                                    objStock.IsCountable = 1;
                                    objStock.IsReturn = 0;
                                    objStock.FromDept = ViewState["DeptLedgerNo"].ToString();
                                    objStock.FromStockID = Util.GetString(dtResult.Rows[i]["StockID"]);
                                    objStock.IndentNo = Util.GetString(txtIndentNo.Text.Trim());
                                    objStock.MedExpiryDate = Util.GetDateTime(dtResult.Rows[i]["MedExpiryDate"]);
                                    objStock.RejectQty = Util.GetDouble(((TextBox)ri.FindControl("txtReject")).Text);
                                    objStock.Unit = Util.GetString(dtResult.Rows[i]["UnitType"]);
                                    objStock.StoreLedgerNo = ViewState["StoreID"].ToString();
                                    objStock.UserID = ViewState["ID"].ToString();
                                    objStock.PostUserID = ViewState["ID"].ToString();
                                    objStock.Rate = Util.GetDecimal(dtResult.Rows[i]["Rate"]);
                                    objStock.TYPE = Util.GetString(dtResult.Rows[i]["TYPE"]);
                                    objStock.IsBilled = Util.GetInt(dtResult.Rows[i]["IsBilled"]);
                                    objStock.Reusable = Util.GetInt(dtResult.Rows[i]["Reusable"]);
                                    objStock.SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                    objStock.SaleTaxAmt = Util.GetDecimal(SaleTaxAmtPerUnit) * Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                    objStock.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                                    objStock.PurTaxAmt = vatPuramt;
                                    objStock.DiscPer = Util.GetDecimal(dtResult.Rows[i]["DiscPer"]);
                                    objStock.DiscAmt = Util.GetDecimal(dtResult.Rows[i]["DiscAmt"]) * Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);

                                    //  objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());

                                    objStock.CentreID = Util.GetInt(ViewState["FromcentreID"].ToString());

                                    objStock.IpAddress = All_LoadData.IpAddress();
                                    //GST Changes
                                    objStock.IGSTPercent = Util.GetDecimal(dtResult.Rows[i]["IGSTPercent"]);
                                    objStock.IGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["IGSTAmtPerUnit"]);
                                    objStock.SGSTPercent = Util.GetDecimal(dtResult.Rows[i]["SGSTPercent"]);
                                    objStock.SGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["SGSTAmtPerUnit"]);
                                    objStock.CGSTPercent = Util.GetDecimal(dtResult.Rows[i]["CGSTPercent"]);
                                    objStock.CGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["CGSTAmtPerUnit"]);
                                    objStock.HSNCode = Util.GetString(dtResult.Rows[i]["HSNCode"]);
                                    objStock.GSTType = Util.GetString(dtResult.Rows[i]["GSTType"]);
                                    objStock.VenLedgerNo = Util.GetString(dtResult.Rows[i]["VenLedgerNo"]);
                                    objStock.LedgerTransactionNo = "0";
                                    objStock.LedgerTnxNo = "0";
                                    objStock.MajorUnit = Util.GetString(dtResult.Rows[i]["MajorUnit"]);
                                    objStock.MinorUnit = Util.GetString(dtResult.Rows[i]["MinorUnit"]);
                                    objStock.ConversionFactor = Util.GetDecimal(dtResult.Rows[i]["ConversionFactor"]);
                                    objStock.VenLedgerNo = Util.GetString(dtResult.Rows[i]["VenLedgerNo"]);
                                    objStock.IsExpirable = Util.GetInt(dtResult.Rows[i]["IsExpirable"]);
                                    objStock.salesno = SalesNo;
                                    objStock.BarCodeID = Util.GetInt(dtResult.Rows[i]["BarCodeID"]);
                                    string stokID = objStock.Insert();

                                    Sales_Details ObjSales = new Sales_Details(Tranx);
                                    ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    ObjSales.LedgerNumber = Util.GetString(ViewState["deptFrom"].ToString());
                                    ObjSales.DepartmentID = ViewState["StoreID"].ToString();
                                    ObjSales.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                    ObjSales.StockID = Util.GetString(dtResult.Rows[i]["StockID"]);
                                    ObjSales.SoldUnits = Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                                    ObjSales.Date = DateTime.Now;
                                    ObjSales.Time = DateTime.Now;
                                    ObjSales.IsReturn = 0;
                                    if (Util.GetInt(ViewState["FromcentreID"].ToString()) != Util.GetInt(Session["CentreID"].ToString()))
                                        ObjSales.TrasactionTypeID = 27;
                                    else
                                        ObjSales.TrasactionTypeID = 1;
                                    ObjSales.IsService = "NO";
                                    ObjSales.IndentNo = IndentNo;
                                    ObjSales.SalesNo = SalesNo;
                                    ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                    ObjSales.UserID = ViewState["ID"].ToString();
                                    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                    ObjSales.medExpiryDate = Util.GetDateTime(dtResult.Rows[i]["MedExpiryDate"]);
                                    ObjSales.IpAddress = All_LoadData.IpAddress();

                                    ObjSales.TaxPercent = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                    ObjSales.TaxAmt = Util.GetDecimal(SaleTaxAmtPerUnit) * Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);

                                    ObjSales.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                                    ObjSales.PurTaxAmt = vatPuramt;
                                    //GST Changes
                                    decimal igstPercent = Util.GetDecimal(dtResult.Rows[i]["IGSTPercent"]);
                                    decimal csgtPercent = Util.GetDecimal(dtResult.Rows[i]["CGSTPercent"]);
                                    decimal sgstPercent = Util.GetDecimal(dtResult.Rows[i]["SGSTPercent"]);

                                    decimal taxableAmt = (Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]) * 100 * Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text)) / (100 + igstPercent + csgtPercent + sgstPercent);
                                    //decimal nonTaxableRate = (Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                                    // decimal discount = Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * objLTDetail.DiscountPercentage / 100;
                                    // decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

                                    decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                                    decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                                    decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);

                                    ObjSales.IGSTPercent = igstPercent;
                                    ObjSales.IGSTAmt = IGSTTaxAmount;
                                    ObjSales.CGSTPercent = csgtPercent;
                                    ObjSales.CGSTAmt = CGSTTaxAmount;
                                    ObjSales.SGSTPercent = sgstPercent;
                                    ObjSales.SGSTAmt = SGSTTaxAmount;
                                    ObjSales.HSNCode = Util.GetString(dtResult.Rows[0]["HSNCode"]);
                                    ObjSales.GSTType = Util.GetString(dtResult.Rows[0]["GSTType"]);
                                    //

                                    ObjSales.IpAddress = All_LoadData.IpAddress();
                                    ObjSales.LedgerTransactionNo = "0";
                                    ObjSales.Type_ID = "HS";
                                    ObjSales.ToCentreID = Util.GetInt(ViewState["FromcentreID"].ToString());
                                    ObjSales.TransactionID = "0";
                                    ObjSales.ServiceItemID = "0";
                                    string SalesID = ObjSales.Insert();

                                    if (SalesID == string.Empty)
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                    if (stokID == string.Empty)
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                }
                                else
                                {
                                    Tranx.Rollback();
                                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM269','" + lblMsg.ClientID + "');", true);
                                    return;
                                }
                            }
                        }
                    }

                    if (grdItemGenric.Items.Count > 0)
                    {
                        foreach (RepeaterItem grItemGenric in grdItemGenric.Items)
                        {
                            GridView grdItemNewgenric = (GridView)grItemGenric.FindControl("grdItemNewgenric");
                            if (grdItemNewgenric != null)
                            {
                                if (grdItemNewgenric.Rows.Count > 0)
                                {
                                    foreach (GridViewRow grItemNewgenric in grdItemNewgenric.Rows)
                                    {
                                        if (Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) > 0)
                                        {
                                            newIssueQty = newIssueQty + Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                            str_StockId = ((Label)grItemNewgenric.FindControl("lblStockIDnewgenric")).Text;

                                            //GST Changes
                                            string stt = "select IsExpirable,StockID,BarcodeID,ItemID,Rate,DiscPer,round((DiscAmt/InitialCount),4) as DiscAmt,PurTaxPer ,round((PurTaxAmt/InitialCount),4) as PurTaxAmt , SaleTaxPer,round((SaleTaxAmt/InitialCount),4) as SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType,MajorUnit,MinorUnit,ConversionFactor,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,IGSTAmtPerUnit,SGSTAmtPerUnit,CGSTAmtPerUnit,GSTType,VenLedgerNo from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";
                                            DataTable dtResult = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stt).Tables[0];
                                            if (dtResult != null && dtResult.Rows.Count > 0)
                                            {
                                                int i = 0;
                                                string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + "),0,1)CHK from f_stock where stockID='" + str_StockId + "'";
                                                if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                                                {
                                                    Tranx.Rollback();
                                                    return;
                                                }
                                                string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + " WHERE StockID = '" + str_StockId + "'";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);

                                                string sqlind = "SELECT   ReqQty-(ReceiveQty+RejectQty) FROM f_indent_detail WHERE indentNo='" + IndentNo + "' AND itemId= '" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "' ";
                                                int RemQty = Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sqlind));
                                                int AvlQty = RemQty - Util.GetInt(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                if (AvlQty < 0)
                                                {
                                                    DataTable DtIndent = (DataTable)ViewState["StockTransfer"];
                                                    foreach (DataRow dr in DtIndent.Rows)
                                                    {
                                                        if (Util.GetString(dr["ItemID"]) == Util.GetString(Util.GetString(dtResult.Rows[i]["ItemID"])))
                                                            dr["PendingQty"] = RemQty;
                                                    }
                                                    DtIndent.AcceptChanges();
                                                    grdIndentDetails.DataSource = DtIndent;
                                                    grdIndentDetails.DataBind();
                                                    Tranx.Rollback();
                                                    return;
                                                }
                                                StringBuilder sb = new StringBuilder();
                                                sb.Append("insert into f_indent_detail(IndentNo,ItemId,ItemName,ReqQty,ReceiveQty,UnitType,DeptFrom,DeptTo,StoreId,Narration,UserId,Type,GenricType,OLDItemID,ToCentreID)  ");
                                                sb.Append("values('" + IndentNo + "','" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "','" + Util.GetString(dtResult.Rows[i]["ItemName"]) + "'," + Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + "," + Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + "");
                                                sb.Append(",'" + Util.GetString(dtResult.Rows[i]["UnitType"]) + "','" + ViewState["deptFrom"].ToString() + "','" + ViewState["DeptLedgerNo"].ToString() + "','" + ViewState["StoreID"].ToString() + "','generic Item issue','" + ViewState["ID"].ToString() + "','Normal','GENRIC','" + GenricItemid + "'," + Util.GetInt(ViewState["FromcentreID"].ToString()) + ") ");

                                                string strIndent = "update f_indent_detail set RejectQty = RejectQty + " + Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + ",ReceiveQty = ReceiveQty -" + Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + ",RejectBy='" + ViewState["ID"].ToString() + "',RejectReason='Generic Item Issued' where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptFrom='" + ViewState["deptFrom"].ToString() + "'";


                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndent);
                                                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                                                {
                                                    Tranx.Rollback();
                                                    return;
                                                }

                                                decimal MRP = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                                                decimal SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                                decimal SaleTaxAmtPerUnit = Math.Round(((((MRP * 100) / (100 + SaleTaxPer)) * SaleTaxPer) / 100), 6);
                                                decimal TaxablePurVATAmt = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]) * Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) * (100 / (100 + Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"])));
                                                decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]) / 100;


                                                Stock objStock = new Stock(Tranx);
                                                objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                                objStock.InitialCount = Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                objStock.BatchNumber = Util.GetString(dtResult.Rows[i]["BatchNumber"]);
                                                objStock.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                                objStock.ItemName = Util.GetString(dtResult.Rows[i]["ItemName"]);
                                                objStock.DeptLedgerNo = Util.GetString(ViewState["deptFrom"].ToString());
                                                objStock.IsFree = 0;
                                                if (Util.GetInt(ViewState["FromcentreID"].ToString()) != Util.GetInt(Session["CentreID"].ToString()))
                                                {
                                                    objStock.IsPost = 4;
                                                    objStock.FromCentreID = Util.GetInt(Session["CentreID"].ToString());
                                                }
                                                else
                                                    objStock.IsPost = 1;
                                                objStock.PostDate = DateTime.Now;
                                                objStock.MRP = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                                                objStock.StockDate = DateTime.Now;
                                                objStock.Unit = Util.GetString(dtResult.Rows[i]["UnitType"]);
                                                objStock.SubCategoryID = Util.GetString(dtResult.Rows[i]["SubCategoryID"]);
                                                objStock.UnitPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                                                objStock.IsCountable = 1;
                                                objStock.IsReturn = 0;
                                                objStock.FromDept = ViewState["DeptLedgerNo"].ToString();
                                                objStock.FromStockID = Util.GetString(dtResult.Rows[i]["StockID"]);
                                                objStock.IndentNo = Util.GetString(txtIndentNo.Text.Trim());
                                                objStock.MedExpiryDate = Util.GetDateTime(dtResult.Rows[i]["MedExpiryDate"]);
                                                objStock.RejectQty = Util.GetDouble(((TextBox)ri.FindControl("txtReject")).Text);
                                                objStock.Unit = Util.GetString(dtResult.Rows[i]["UnitType"]);
                                                objStock.StoreLedgerNo = ViewState["StoreID"].ToString();
                                                objStock.UserID = ViewState["ID"].ToString();
                                                objStock.PostUserID = ViewState["ID"].ToString();
                                                objStock.Rate = Util.GetDecimal(dtResult.Rows[i]["Rate"]);
                                                objStock.TYPE = Util.GetString(dtResult.Rows[i]["TYPE"]);
                                                objStock.IsBilled = Util.GetInt(dtResult.Rows[i]["IsBilled"]);
                                                objStock.Reusable = Util.GetInt(dtResult.Rows[i]["Reusable"]);
                                                objStock.SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                                objStock.SaleTaxAmt = Util.GetDecimal(SaleTaxAmtPerUnit) * Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                objStock.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                                                objStock.PurTaxAmt = vatPuramt;
                                                objStock.DiscPer = Util.GetDecimal(dtResult.Rows[i]["DiscPer"]);
                                                objStock.DiscAmt = Util.GetDecimal(dtResult.Rows[i]["DiscAmt"]) * Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                //   objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);
                                                //  objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());

                                                objStock.CentreID = Util.GetInt(ViewState["FromcentreID"].ToString());

                                                objStock.IpAddress = All_LoadData.IpAddress();
                                                //GST Changes
                                                objStock.IGSTPercent = Util.GetDecimal(dtResult.Rows[i]["IGSTPercent"]);
                                                objStock.IGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["IGSTAmtPerUnit"]);
                                                objStock.SGSTPercent = Util.GetDecimal(dtResult.Rows[i]["SGSTPercent"]);
                                                objStock.SGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["SGSTAmtPerUnit"]);
                                                objStock.CGSTPercent = Util.GetDecimal(dtResult.Rows[i]["CGSTPercent"]);
                                                objStock.CGSTAmtPerUnit = Util.GetDecimal(dtResult.Rows[i]["CGSTAmtPerUnit"]);
                                                objStock.HSNCode = Util.GetString(dtResult.Rows[i]["HSNCode"]);
                                                objStock.GSTType = Util.GetString(dtResult.Rows[i]["GSTType"]);

                                                objStock.VenLedgerNo = Util.GetString(dtResult.Rows[i]["VenLedgerNo"]);
                                                objStock.LedgerTransactionNo = "0";
                                                objStock.LedgerTnxNo = "0";
                                                objStock.MajorUnit = Util.GetString(dtResult.Rows[i]["MajorUnit"]);
                                                objStock.MinorUnit = Util.GetString(dtResult.Rows[i]["MinorUnit"]);
                                                objStock.ConversionFactor = Util.GetDecimal(dtResult.Rows[i]["ConversionFactor"]);
                                                objStock.VenLedgerNo = Util.GetString(dtResult.Rows[i]["VenLedgerNo"]);
                                                objStock.IsExpirable = Util.GetInt(dtResult.Rows[i]["IsExpirable"]);
                                                objStock.salesno = SalesNo;
                                                objStock.BarCodeID = Util.GetInt(dtResult.Rows[i]["BarCodeID"]);
                                                string stokID = objStock.Insert();

                                                Sales_Details ObjSales = new Sales_Details(Tranx);
                                                ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                                ObjSales.LedgerNumber = Util.GetString(ViewState["deptFrom"].ToString());
                                                ObjSales.DepartmentID = ViewState["StoreID"].ToString();
                                                ObjSales.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                                ObjSales.StockID = Util.GetString(dtResult.Rows[i]["StockID"]);
                                                ObjSales.SoldUnits = Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                                                ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtResult.Rows[i]["MRP"]);
                                                ObjSales.Date = DateTime.Now;
                                                ObjSales.Time = DateTime.Now;
                                                ObjSales.IsReturn = 0;
                                                ObjSales.LedgerTransactionNo = "";
                                                if (Util.GetInt(ViewState["FromcentreID"].ToString()) != Util.GetInt(Session["CentreID"].ToString()))
                                                    ObjSales.TrasactionTypeID = 27;
                                                else
                                                    ObjSales.TrasactionTypeID = 1;
                                                ObjSales.IsService = "NO";
                                                ObjSales.IndentNo = IndentNo;
                                                ObjSales.SalesNo = SalesNo;
                                                ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                                ObjSales.UserID = ViewState["ID"].ToString();
                                                ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                                ObjSales.medExpiryDate = Util.GetDateTime(dtResult.Rows[i]["MedExpiryDate"]);


                                                ObjSales.TaxPercent = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                                ObjSales.TaxAmt = Util.GetDecimal(SaleTaxAmtPerUnit) * Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);

                                                ObjSales.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                                                ObjSales.PurTaxAmt = vatPuramt;

                                                //GST Changes
                                                decimal igstPercent = Util.GetDecimal(dtResult.Rows[i]["IGSTPercent"]);
                                                decimal csgtPercent = Util.GetDecimal(dtResult.Rows[i]["CGSTPercent"]);
                                                decimal sgstPercent = Util.GetDecimal(dtResult.Rows[i]["SGSTPercent"]);

                                                decimal taxableAmt = (Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]) * 100 * Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text)) / (100 + igstPercent + csgtPercent + sgstPercent);
                                                //decimal nonTaxableRate = (Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                                                // decimal discount = Util.GetDecimal(dtItem.Rows[i]["TaxableMRP"]) * objLTDetail.DiscountPercentage / 100;
                                                // decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

                                                decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                                                decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                                                decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);

                                                ObjSales.IGSTPercent = igstPercent;
                                                ObjSales.IGSTAmt = IGSTTaxAmount;
                                                ObjSales.CGSTPercent = csgtPercent;
                                                ObjSales.CGSTAmt = CGSTTaxAmount;
                                                ObjSales.SGSTPercent = sgstPercent;
                                                ObjSales.SGSTAmt = SGSTTaxAmount;
                                                ObjSales.HSNCode = Util.GetString(dtResult.Rows[0]["HSNCode"]);
                                                ObjSales.GSTType = Util.GetString(dtResult.Rows[0]["GSTType"]);
                                                //
                                                ObjSales.IpAddress = All_LoadData.IpAddress();
                                                ObjSales.LedgerTransactionNo = "0";

                                                ObjSales.ToCentreID = Util.GetInt(ViewState["FromcentreID"].ToString());
                                                ObjSales.Type_ID = "HS";
                                                ObjSales.TransactionID = "0";
                                                ObjSales.ServiceItemID = "0";
                                                string SalesID = ObjSales.Insert();

                                                if (SalesID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    return;
                                                }


                                                if (stokID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    return;

                                                }


                                            }
                                            else
                                            {
                                                Tranx.Rollback();
                                                return;
                                            }
                                        }
                                    }
                                }
                            }

                        }
                    }

                    string sqlind1 = "SELECT   ReqQty-(ReceiveQty+RejectQty) FROM f_indent_detail WHERE indentNo='" + IndentNo + "' AND itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' ";
                    decimal RemQty1 = Util.GetDecimal(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sqlind1));
                    decimal AvlQty1 = RemQty1 - Util.GetDecimal(((TextBox)ri.FindControl("txtIssueingQty")).Text);
                    if (AvlQty1 < 0)
                    {
                        DataTable DtIndent = (DataTable)ViewState["StockTransfer"];
                        foreach (DataRow dr in DtIndent.Rows)
                        {
                            if (Util.GetString(dr["ItemId"]) == Util.GetString(((Label)ri.FindControl("lblItemID")).Text))
                                dr["PendingQty"] = RemQty1;
                        }
                        DtIndent.AcceptChanges();
                        grdIndentDetails.DataSource = DtIndent;
                        grdIndentDetails.DataBind();
                        Tranx.Rollback();
                        return;
                    }

                    string strIndent1 = "";
                    if (Util.GetString(Util.GetString(((TextBox)ri.FindControl("txtReason")).Text)) != "")
                    {
                        strIndent1 = "update f_indent_detail set dtReject=now(),RejectReason='" + Util.GetString(Util.GetString(((TextBox)ri.FindControl("txtReason")).Text)) + "',RejectQty = RejectQty + " + Util.GetString(Util.GetDecimal(((TextBox)ri.FindControl("txtReject")).Text)) + ",ReceiveQty = ReceiveQty +" + Util.GetDecimal(((TextBox)ri.FindControl("txtIssueingQty")).Text) + ",rejectBy='" + ViewState["ID"] + "' where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptFrom='" + ViewState["deptFrom"].ToString() + "'";

                    }
                    else
                    {
                        strIndent1 = "update f_indent_detail set RejectQty = RejectQty + " + Util.GetString(Util.GetDecimal(((TextBox)ri.FindControl("txtReject")).Text)) + ",ReceiveQty = ReceiveQty +" + Util.GetDecimal(((TextBox)ri.FindControl("txtIssueingQty")).Text) + " where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptFrom='" + ViewState["deptFrom"].ToString() + "'  and IFNULL(genrictype,'')<>'GENRIC' ";

                    }
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndent1);

                }
            }
            //int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_roleMaster WHERE DeptLedgerNo='" + ViewState["deptFrom"].ToString() + "' "));
            //Notification_Insert.notificationInsert(26, IndentNo.ToString(), Tranx, "", "", roleID, "");
            //All_LoadData.updateNotification(IndentNo, "", Util.GetString(Session["RoleID"].ToString()), 27, Tranx, "Store");

            Tranx.Commit();
            string Indent_Dpt = ViewState["Indent_Dpt"].ToString();
            if (TIssueQty > 0)
            {
                if (chkPrint.Checked)
                {
                    PrintIndent(Util.GetString(((Label)grdIndentDetails.Items[0].FindControl("lblIndentNo")).Text.Trim()), SalesNo.ToString());
                    chkPrint.Checked = false;
                }
            }
            BindIndentDetails(Indent_Dpt.Split('#')[1], Indent_Dpt.Split('#')[0]);
            btnSearchIndent_Click1(this, new EventArgs());
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
        finally {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void PrintIndent(string IndentNo, string salesno)
    {
        StringBuilder sb1 = new StringBuilder();

        sb1.Append("SELECT id.IndentNo,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,t.IssuedQty, ");
        sb1.Append("id.UnitType,id.Narration,id.isApproved, id.ApprovedBy,id.ApprovedReason,t.salesno,t.iDate, ");
        sb1.Append(" date_format(id.dtEntry,'%d-%b-%Y %h:%i %p')dtEntry,id.UserId,t.BatchNumber, ");
        sb1.Append("t.CostPrice,t.MedExpiryDate, ");
        sb1.Append("(SELECT DeptName FROM f_rolemaster WHERE DeptLedgerNo = id.DeptFrom)DeptFrom, ");
        sb1.Append("(SELECT DeptName FROM f_rolemaster WHERE DeptLedgerNo = id.DeptTo)DeptTo, ");
        sb1.Append("(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE EmployeeID=id.UserId)EmpName, ");
        sb1.Append("(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE EmployeeID=t.UserId)IssueBy, t.SellingPrice ");
        sb1.Append("FROM ");
        sb1.Append("(SELECT IndentNo,ItemName,ReqQty,ReceiveQty,RejectQty,UnitType,ItemId,ApprovedBy,Narration,isApproved,ApprovedReason,dtEntry,UserId,DeptFrom,DeptTo FROM f_indent_detail WHERE IndentNo='" + IndentNo + "') id INNER JOIN ");
        sb1.Append("(SELECT sd.IndentNo,st.BatchNumber,st.UnitPrice CostPrice,SUM(sd.SoldUnits)IssuedQty,sd.salesno,CONCAT(DATE_FORMAT(sd.DATE,'%d-%b-%Y'),' ',time_format(sd.TIME,'%h:%i %p'))iDate, ");
        sb1.Append("IF(st.IsExpirable=1,date_format(st.MedExpiryDate,'%d-%b-%y'),'') MedExpiryDate,sd.ItemID,sd.StockID,sd.UserID,sd.PerUnitSellingPrice SellingPrice FROM ");
        sb1.Append("  f_salesdetails sd ");
        sb1.Append(" INNER JOIN f_stock st ");
        sb1.Append("ON sd.StockID = st.StockID WHERE sd.indentno='" + IndentNo + "' and sd.salesno='" + salesno + "'");
        sb1.Append("GROUP BY sd.StockID,st.BatchNumber)t ");
        sb1.Append("ON id.ItemId = t.ItemID AND id.IndentNo = t.IndentNo ");
        DataTable dtImg = All_LoadData.CrystalReportLogo();
        DataSet ds = new DataSet();
        ds.Tables.Add(StockReports.GetDataTable(sb1.ToString()).Copy());
        ds.Tables.Add(dtImg.Copy());
        // ds.WriteXmlSchema(@"e:\NewIndent1.xml");
        Session["ds"] = ds;
        Session["ReportName"] = "NewIndentForStore";

        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);


    }

    protected void btnSearchIndent_Click1(object sender, EventArgs e)
    {
        try
        {
            if (rblStoreType.SelectedIndex < 0)
            {
                lblMsg.Text = "Please Select Store Type";
                return;
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM ( ");
            sb.Append("  SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'    ");
            sb.Append("  WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  ");
            sb.Append("  FROM (");
            sb.Append("  SELECT cm.CentreName AS CentreFrom,id.CentreID,id.indentno,id.Type,id.StoreId,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,lm.ledgername AS DeptFrom,(SELECT CONCAT(em.Title,' ',em.Name)EmpName FROM  employee_master em WHERE em.EmployeeID=id.UserId ORDER BY ID DESC LIMIT 1)EmpName,lm.LedgerNumber, ");
            sb.Append(" (SELECT COUNT(*) FROM f_salesdetails WHERE IndentNo=id.indentno)NewIndent,SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty, ");
            sb.Append(" SUM(RejectQty)RejectQty  FROM f_indent_detail id INNER JOIN f_itemmaster im ON im.ItemID=id.ItemId INNER JOIN f_ledgermaster lm ");
            sb.Append(" ON lm.LedgerNumber = id.Deptfrom INNER JOIN center_master cm ON cm.CentreID=id.CentreID where Date(id.dtEntry) >= '" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" AND Date(id.dtEntry) <='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "'  AND id.deptto = '" + ViewState["DeptLedgerNo"].ToString() + "' AND id.ToCentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " AND id.StoreID='" + rblStoreType.SelectedValue + "' ");

            if (txtIndentNoToSearch.Text.ToString().Trim() != string.Empty)
            {
                sb.Append(" and id.IndentNo = '" + txtIndentNoToSearch.Text.ToString().Trim() + "' ");
            }
            if (ddlDepartment.SelectedIndex > 0)
            {
                sb.Append("  and id.DeptFrom='" + ddlDepartment.SelectedItem.Value + "'");
            }
            if (ddlFromCentre.SelectedIndex > 0)
            {
                sb.Append("  and id.CentreID='" + ddlFromCentre.SelectedItem.Value + "'");
            }
            if (ddlSubGroup.SelectedIndex > 0)
            {
                sb.Append("  AND im.SubCategoryID='"+ddlSubGroup.SelectedItem.Value +"' ");
            }
            sb.Append("  GROUP BY IndentNo        )t  		)t1 ");
            DataTable dtIndentDetails = StockReports.GetDataTable(sb.ToString());
            if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
            {
                grdIndentSearch.DataSource = dtIndentDetails;
                grdIndentSearch.DataBind();
                lblMsg.Text = "";
            }
            else
            {
                grdIndentSearch.DataSource = null;
                grdIndentSearch.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                return;
            }
            grdIndentDetails.DataSource = null;
            grdIndentDetails.DataBind();

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            return;
        }

    }

    protected void BindIndentDetails(string Dept, string IndentNo)
    {
        string str = "SELECT * FROM f_indent_detail WHERE (ReceiveQty+RejectQty)<ReqQty AND indentNo = '" + IndentNo + "'";
        DataTable dtIndentDetails = StockReports.GetDataTable(str);

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
                string strStock = "SELECT DISTINCT sum(InitialCount-ReleasedCount-PendingQty)AvailQty,deptLedgerno,st.CentreID FROM f_stock st inner join f_itemmaster im on im.ItemID=st.ItemID where st.itemid='" + dtIndentDetails.Rows[m]["itemId"] + "' and (InitialCount-ReleasedCount-PendingQty)>0 and deptLedgerno in ('" + ViewState["DeptLedgerNo"].ToString() + "','" + dtIndentDetails.Rows[m]["DeptFrom"].ToString() + "') and Ispost=1  and st.MedExpiryDate>=IF(im.IsExpirable='YES',CURRENT_DATE(),st.MedExpiryDate) group by  st.CentreID,st.itemid,deptledgerno";
                DataTable dtStock = StockReports.GetDataTable(strStock);
                if (dtStock != null && dtStock.Rows.Count > 0)
                {
                    foreach (DataRow row in dtStock.Rows)
                    {
                        if (row["deptLedgerno"].ToString() == ViewState["DeptLedgerNo"].ToString() && row["CentreID"].ToString() == Session["CentreID"].ToString())
                            dtIndentDetails.Rows[m]["AvailQty"] = row["AvailQty"].ToString();

                        if (row["deptLedgerno"].ToString() == dtIndentDetails.Rows[m]["DeptFrom"].ToString() && row["CentreID"].ToString() == dtIndentDetails.Rows[m]["CentreID"].ToString())
                            dtIndentDetails.Rows[m]["DeptAvailQty"] = row["AvailQty"].ToString();
                    }
                }

                decimal resQty = Util.GetDecimal(dtIndentDetails.Rows[m]["ReqQty"]) - Util.GetDecimal(dtIndentDetails.Rows[m]["ReceiveQty"]) - Util.GetDecimal(dtIndentDetails.Rows[m]["RejectQty"]);
                if (resQty < Util.GetDecimal(dtIndentDetails.Rows[m]["AvailQty"]))
                {
                    dtIndentDetails.Rows[m]["IssuePossible"] = resQty;
                }
                else
                {
                    dtIndentDetails.Rows[m]["IssuePossible"] = Util.GetDecimal(dtIndentDetails.Rows[m]["AvailQty"]);
                }

                dtIndentDetails.Rows[m]["PendingQty"] = Util.GetDecimal(dtIndentDetails.Rows[m]["ReqQty"]) - (Util.GetDecimal(dtIndentDetails.Rows[m]["ReceiveQty"]) + Util.GetDecimal(dtIndentDetails.Rows[m]["RejectQty"]));

            }
            dtIndentDetails.AcceptChanges();
            ViewState["StockTransfer"] = dtIndentDetails;
            grdIndentDetails.DataSource = dtIndentDetails;
            grdIndentDetails.DataBind();
        }
        else
        {
            grdIndentDetails.DataSource = null;
            grdIndentDetails.DataBind();
            return;
        }
    }

    protected void gvGRN_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {
            ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByText(Util.GetString(e.CommandArgument).Split('#')[1]));
            txtIndentNo.Text = Util.GetString(e.CommandArgument).Split('#')[0];
            ViewState["Indent_Dpt"] = Util.GetString(e.CommandArgument).Split('#')[0] + "#" + Util.GetString(e.CommandArgument).Split('#')[1];
            ViewState["StoreID"] = Util.GetString(e.CommandArgument).Split('#')[2];
            ViewState["deptFrom"] = Util.GetString(e.CommandArgument).Split('#')[3];
            ViewState["FromcentreID"] = Util.GetString(e.CommandArgument).Split('#')[4];
            BindIndentDetails(Util.GetString(e.CommandArgument).Split('#')[1], Util.GetString(e.CommandArgument).Split('#')[0]);
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "ac1", "window.top.location.hash='" + ((ImageButton)e.CommandSource).ClientID + "';", true);

        if (e.CommandName == "AViewDetail")
        {
            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string status = Util.GetString(e.CommandArgument).Split('#')[1];

            StringBuilder sb1 = new StringBuilder();
            sb1.Append("select '" + status + "'StatusNew, id.IndentNo, id.ItemName, id.ReqQty, id.UnitType,sd.SoldUnits,  DATE_FORMAT(sd.Date,'%d-%b-%y')Date,");
            sb1.Append(" sd.UserId,id.ReceiveQty,(IFNULL(id.ReqQty,0)-IFNULL(id.ReceiveQty,0)-IFNULL(id.RejectQty,0))PendingQty,id.RejectQty from f_indent_detail id   ");

            sb1.Append(" left outer JOIN f_salesdetails sd    ON sd.IndentNo=id.IndentNo AND sd.ItemID=id.ItemId");
            sb1.Append(" where id.indentno ='" + IndentNo + "' ");

            DataTable dtnew = StockReports.GetDataTable(sb1.ToString());
            if (dtnew.Rows.Count > 0)
            {
                grdIndentdtl.DataSource = dtnew;
                grdIndentdtl.DataBind();
                mpe2.Show();
            }
            else
            {
                grdIndentdtl.DataSource = null;
                grdIndentdtl.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }



        }
        if (e.CommandName == "AReprint")
        { 
            string IndentNo= Util.GetString(e.CommandArgument).Split('#')[0];
            string SalesNo = StockReports.ExecuteScalar("SELECT SALESNO FROM f_salesdetails WHERE IndentNo='"+IndentNo+"' LIMIT 1");
            PrintIndent(IndentNo,SalesNo);
        }
    }

    protected void grdIndentdtl_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string Itemname = ((Label)e.Row.FindControl("lblname")).Text;
            string ItemQty = ((Label)e.Row.FindControl("lblReqqty")).Text;
            string ItemUnittype = ((Label)e.Row.FindControl("lblUnittype")).Text;
            string Indentno = ((Label)e.Row.FindControl("lblIndentno")).Text;


            if (e.Row.RowIndex >= 1)
            {
                string Previousname = ((Label)grdIndentdtl.Rows[e.Row.RowIndex - 1].FindControl("lblname")).Text;
                string PreviousQty = ((Label)grdIndentdtl.Rows[e.Row.RowIndex - 1].FindControl("lblReqqty")).Text;
                string PreviousUnittype = ((Label)grdIndentdtl.Rows[e.Row.RowIndex - 1].FindControl("lblUnittype")).Text;
                string PreviousIndentno = ((Label)grdIndentdtl.Rows[e.Row.RowIndex - 1].FindControl("lblIndentno")).Text;


                if (Itemname == Previousname && ItemQty == PreviousQty && ItemUnittype == PreviousUnittype && Indentno == PreviousIndentno)
                {

                    ((Label)e.Row.FindControl("lblItemname")).Text = "";
                    ((Label)e.Row.FindControl("lblitemIndentNo")).Text = "";
                    ((Label)e.Row.FindControl("lblItemUnitType")).Text = "";
                    ((Label)e.Row.FindControl("lblItemQty")).Text = "";
                }
            }
        }
    }
    protected void grdIndentDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row != null)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                decimal RequestedQty = Util.GetDecimal(((Label)e.Row.FindControl("lblRequestedQty")).Text.Trim());
                decimal IssuedQty = Util.GetDecimal(((Label)e.Row.FindControl("lblIssuedQty")).Text.Trim());
                decimal RejectedQty = Util.GetDecimal(((Label)e.Row.FindControl("lblRejectedQty")).Text.Trim());
                decimal PendingQty = Util.GetDecimal(((Label)e.Row.FindControl("lblPendingQty")).Text.Trim());


                if (RequestedQty < (IssuedQty + RejectedQty + PendingQty))
                {
                    ((CheckBox)e.Row.FindControl("chkSelect")).Enabled = false;
                    ((TextBox)e.Row.FindControl("txtIssueingQty")).Enabled = false;
                    ((TextBox)e.Row.FindControl("txtRejectingQty")).Enabled = false;
                    ((TextBox)e.Row.FindControl("txtIssueingQty")).Text = "";
                    ((TextBox)e.Row.FindControl("txtRejectingQty")).Text = "";

                }
            }
        }
    }

    protected void grdIndentSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {


        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatusNew")).Text == "REJECT")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
                ((ImageButton)e.Row.FindControl("imbReprint")).Visible = false;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.Green;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
                ((ImageButton)e.Row.FindControl("imbReprint")).Visible = false;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
            }

        }
    }
    protected void grdIndentDetails_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {

    }
    private DataTable getStockItem(string ItemId)
    {
        return StockReports.GetDataTable("select  fst.StockID,im.isexpirable,  fst.ItemID,  fst.ItemName,  fst.SaleTaxPer,  fst.BatchNumber, fst.UnitPrice,  fst.MRP,IF(im.IsExpirable='NO','',DATE_FORMAT(MedExpiryDate,'%d-%b-%y'))MedExpiryDate,  (fst.InitialCount-fst.ReleasedCount)    AvailQty,  fst.SubCategoryID,  fst.UnitType FROM f_stock fst  INNER JOIN f_itemmaster im ON im.ItemID=fst.ItemID where fst.ItemID='" + ItemId + "' and (InitialCount-ReleasedCount)>0 and Ispost=1 and DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "' AND fst.MedExpiryDate>=IF(im.IsExpirable='YES',CURRENT_DATE(),fst.MedExpiryDate) AND CentreID='" + Session["CentreID"].ToString() + "' order by stockid ");
    }
    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {

        foreach (RepeaterItem rit in grdIndentDetails.Items)
        {

            if (rit.ItemType == ListItemType.Item || rit.ItemType == ListItemType.AlternatingItem)
            {
                CheckBox chkSelect = (CheckBox)sender;
                if (chkSelect.ID == ((CheckBox)rit.FindControl("chkSelect")).ID)
                {
                    if (chkSelect.Checked)
                    {
                        GridView grdIt = (GridView)rit.FindControl("grdItem");
                        Label LbItemId = (Label)rit.FindControl("lblItemID");
                        grdIt.DataSource = getStockItem(LbItemId.Text);
                        grdIt.DataBind();
                        grdIt.Visible = true;
                    }
                    else
                    {
                        GridView grdIt = (GridView)rit.FindControl("grdItem");
                        grdIt.Visible = false;

                    }
                }


            }
        }
    }
    private DataTable getStockItemgenric(string ItemId)
    {
        string Itemids = "";
        DataTable dtsalts1;

        dtsalts1 = StockReports.GetDataTable("SELECT saltid,Quantity FROM f_item_salt WHERE itemid='" + ItemId + "' ");
        dtsalts1.TableName = "firsttable";
        DataTable dtitemSalts = new DataTable();
        DataTable dtsalts2 = new DataTable();
        if (dtsalts1.Rows.Count > 0)
        {
            foreach (DataRow dr in dtsalts1.Rows)
            {
                dtitemSalts = StockReports.GetDataTable("SELECT distinct Itemid FROM f_item_salt WHERE saltid='" + dr["saltid"].ToString() + "' and itemid <>  '" + ItemId + "' ");
                break;
            }
        }
        if (dtitemSalts.Rows.Count > 0)
        {
            foreach (DataRow dr in dtitemSalts.Rows)
            {
                dtsalts2 = StockReports.GetDataTable("SELECT saltid,Quantity FROM f_item_salt WHERE itemid='" + dr["Itemid"].ToString() + "' ");
                if (dtsalts2.Rows.Count > 0)
                {
                    dtsalts2.TableName = "secondtable";
                    DataTable dt;
                    dt = getDifferentRecords(dtsalts1, dtsalts2);
                    if (dt.Rows.Count == 0)
                    {
                        if (Itemids == "")
                        {
                            Itemids = "'" + dr["itemid"] + "'";
                        }
                        else
                        {
                            Itemids = Itemids + "," + "'" + dr["itemid"] + "'";
                        }
                    }
                }


            }
        }

        if (Itemids != "")
        {
            return StockReports.GetDataTable("select StockID,ItemID,ItemName,SaleTaxPer,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%y')MedExpiryDate,(InitialCount-ReleasedCount)AvailQty,SubCategoryID,UnitType from f_stock where ItemID in (" + Itemids + ") and (InitialCount-ReleasedCount)>0 and Ispost=1 and DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "' and MedExpiryDate>curdate() AND CentreID='"+ Session["CentreID"].ToString() +"' order by stockid ");
        }
        else
        {
            return null;
        }
    }


    #region Compare two DataTables and return a DataTable with DifferentRecords
    public DataTable getDifferentRecords(DataTable FirstDataTable, DataTable SecondDataTable)
    {
        //Create Empty Table     
        DataTable ResultDataTable = new DataTable("ResultDataTable");

        //use a Dataset to make use of a DataRelation object     
        using (DataSet ds = new DataSet())
        {
            //Add tables     
            ds.Tables.AddRange(new DataTable[] { FirstDataTable.Copy(), SecondDataTable.Copy() });

            //Get Columns for DataRelation     
            DataColumn[] firstColumns = new DataColumn[ds.Tables[0].Columns.Count];
            for (int i = 0; i < firstColumns.Length; i++)
            {
                firstColumns[i] = ds.Tables[0].Columns[i];
            }

            DataColumn[] secondColumns = new DataColumn[ds.Tables[1].Columns.Count];
            for (int i = 0; i < secondColumns.Length; i++)
            {
                secondColumns[i] = ds.Tables[1].Columns[i];
            }

            //Create DataRelation     
            DataRelation r1 = new DataRelation(string.Empty, firstColumns, secondColumns, false);
            ds.Relations.Add(r1);

            DataRelation r2 = new DataRelation(string.Empty, secondColumns, firstColumns, false);
            ds.Relations.Add(r2);

            //Create columns for return table     
            for (int i = 0; i < FirstDataTable.Columns.Count; i++)
            {
                ResultDataTable.Columns.Add(FirstDataTable.Columns[i].ColumnName, FirstDataTable.Columns[i].DataType);
            }

            //If FirstDataTable Row not in SecondDataTable, Add to ResultDataTable.     
            ResultDataTable.BeginLoadData();
            foreach (DataRow parentrow in ds.Tables[0].Rows)
            {
                DataRow[] childrows = parentrow.GetChildRows(r1);
                if (childrows == null || childrows.Length == 0)
                    ResultDataTable.LoadDataRow(parentrow.ItemArray, true);
            }

            //If SecondDataTable Row not in FirstDataTable, Add to ResultDataTable.     
            foreach (DataRow parentrow in ds.Tables[1].Rows)
            {
                DataRow[] childrows = parentrow.GetChildRows(r2);
                if (childrows == null || childrows.Length == 0)
                    ResultDataTable.LoadDataRow(parentrow.ItemArray, true);
            }
            ResultDataTable.EndLoadData();
        }

        return ResultDataTable;
    }
    #endregion
    protected void grdItem_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
        GridView grdItemNew = (GridView)e.Item.FindControl("grdItemNew");

        if (opType == "SHOW")
        {

            ((ImageButton)e.CommandSource).AlternateText = "Hide";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";

            DataTable dt = getStockItemgenric(Util.GetString(e.CommandArgument));
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    grdItemNew.DataSource = dt;
                    grdItemNew.DataBind();
                    grdItemNew.Visible = true;
                    ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;

                }
                else
                {

                    grdItemNew.DataSource = null;
                    grdItemNew.DataBind();
                    ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;

                }
            }
            else
            {


                grdItemNew.DataSource = null;
                grdItemNew.DataBind();
                ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;

            }

        }
        else
        {
            ((ImageButton)e.CommandSource).AlternateText = "SHOW";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/plus_in.gif";
            grdItemNew.DataSource = null;
            grdItemNew.DataBind();
            grdItemNew.Visible = false;
        }
    }
    protected void grdItemGenric_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
        GridView grdItemNewgenric = (GridView)e.Item.FindControl("grdItemNewgenric");

        if (opType == "SHOW")
        {

            ((ImageButton)e.CommandSource).AlternateText = "Hide";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";

            DataTable dt = getStockItemgenric(Util.GetString(e.CommandArgument));
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    grdItemNewgenric.DataSource = dt;
                    grdItemNewgenric.DataBind();
                    grdItemNewgenric.Visible = true;
                    ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;
                }
                else
                {
                    grdItemNewgenric.DataSource = null;
                    grdItemNewgenric.DataBind();
                    ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;
                }
            }
            else
            {
                grdItemNewgenric.DataSource = null;
                grdItemNewgenric.DataBind();
                ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;
            }

        }
        else
        {
            ((ImageButton)e.CommandSource).AlternateText = "SHOW";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/plus_in.gif";
            grdItemNewgenric.DataSource = null;
            grdItemNewgenric.DataBind();
            grdItemNewgenric.Visible = false;
        }
    }
    protected void grdIndentDetails_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
        Repeater rptitems = (Repeater)e.Item.FindControl("grdItem");
        Repeater rptitemsgenric = (Repeater)e.Item.FindControl("grdItemGenric");
        if (opType == "SHOW")
        {

            ((ImageButton)e.CommandSource).AlternateText = "Hide";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";

            DataTable dt = getStockItem(Util.GetString(e.CommandArgument));
            if (dt.Rows.Count > 0)
            {
                rptitems.DataSource = dt;
                rptitems.DataBind();
                rptitems.Visible = true;
                rptitemsgenric.DataSource = null;
                rptitemsgenric.DataBind();
                rptitemsgenric.Visible = false;
                ((CheckBox)e.Item.FindControl("chkSelect")).Checked = true;
            }
            else
            {
                DataRow dr = dt.NewRow();
                dr["ItemID"] = Util.GetString(e.CommandArgument);
                dt.Rows.Add(dr);
                dt.AcceptChanges();
                rptitemsgenric.DataSource = dt;
                rptitemsgenric.DataBind();
                rptitemsgenric.Visible = true;
                rptitems.DataSource = null;
                rptitems.DataBind();
                rptitems.Visible = false;
                ((CheckBox)e.Item.FindControl("chkSelect")).Checked = true;

            }

        }
        else
        {
            ((ImageButton)e.CommandSource).AlternateText = "SHOW";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/plus_in.gif";
            rptitemsgenric.DataSource = null;
            rptitemsgenric.DataBind();
            rptitemsgenric.Visible = false;
            rptitems.DataSource = null;
            rptitems.DataBind();
            rptitems.Visible = false;
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "ac1", "window.top.location.hash='" + ((ImageButton)e.CommandSource).ClientID + "';", true);

    }
    public void searchindentnew(string status)
    {
        try
        {
            if (rblStoreType.SelectedIndex < 0)
            {
                lblMsg.Text = "Please Select Store Type";
                return;
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM ( ");
            sb.Append("  SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'    ");
            sb.Append("  WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  ");
            sb.Append("  FROM (");
            sb.Append("  SELECT id.indentno,id.Type,id.StoreId,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,lm.ledgername AS DeptFrom,lm.LedgerNumber, ");
            sb.Append(" (SELECT COUNT(*) FROM f_salesdetails WHERE IndentNo=id.indentno)NewIndent,SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty, ");
            sb.Append(" SUM(RejectQty)RejectQty  FROM f_indent_detail id INNER JOIN f_ledgermaster lm ");
            sb.Append(" ON lm.LedgerNumber = id.Deptfrom  where Date(id.dtEntry) >= '" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' and Date(id.dtEntry) <='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" AND id.storeid='" + rblStoreType.SelectedValue + "' AND id.deptto = '" + ViewState["DeptLedgerNo"].ToString() + "' ");
            if (txtIndentNoToSearch.Text.ToString().Trim() != string.Empty)
            {
                sb.Append(" and indentNo = '" + txtIndentNoToSearch.Text.ToString().Trim() + "' ");
            }
            if (ddlDepartment.SelectedIndex > 0)
            {
                sb.Append("  and deptFrom='" + ddlDepartment.SelectedItem.Value + "'");
            }
            sb.Append("  GROUP BY IndentNo        )t  		)t1 where StatusNew='" + status + "'");
            DataTable dtIndentDetails = StockReports.GetDataTable(sb.ToString());
            if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
            {
                grdIndentSearch.DataSource = dtIndentDetails;
                grdIndentSearch.DataBind();
                grdIndentDetails.DataSource = null;
                grdIndentDetails.DataBind();
                lblMsg.Text = "";
            }
            else
            {
                grdIndentSearch.DataSource = null;
                grdIndentSearch.DataBind();
                grdIndentDetails.DataSource = null;
                grdIndentDetails.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                return;
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            return;
        }
    }
    protected void btnSN_Click(object sender, EventArgs e)
    {
        searchindentnew("OPEN");
        //Open
    }
    protected void btnRN_Click(object sender, EventArgs e)
    {
        searchindentnew("CLOSE");
        // Close
    }
    protected void btnNA_Click(object sender, EventArgs e)
    {

        searchindentnew("REJECT");
        // Reject
    }
    protected void btnA_Click(object sender, EventArgs e)
    {
        searchindentnew("PARTIAL");
        // Partial
    }

    protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}
