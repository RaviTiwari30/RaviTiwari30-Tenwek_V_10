using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Store_InternalStockTransferGeneral : System.Web.UI.Page
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

            BindDepartment();
            BindCentre();
        }
        DateFrom.Attributes.Add("readOnly", "true");
        DateTo.Attributes.Add("readOnly", "true");
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
    private void BindCentre()
    {
        string str = "Select CentreID,CentreName,IsDefault from center_master Where IsActive=1 order by CentreName";
        DataTable dt = StockReports.GetDataTable(str);
        ddlCentre.DataTextField = "CentreName";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataSource = dt;
        ddlCentre.DataBind();
        ddlCentre.Items.Insert(0, new ListItem("All", "0"));
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

        dt.Columns.Add("AvailQty", typeof(float));
        dt.Columns.Add("MRP", typeof(float));
        dt.Columns.Add("UnitPrice", typeof(float));
        dt.Columns.Add("Qty", typeof(float));
        dt.Columns.Add("IssueQty", typeof(float));
        dt.Columns.Add("Amount", typeof(float));

        dt.Columns.Add("id", typeof(int));
        dt.Columns.Add("IndentNo");
        dt.Columns.Add("ReqQty", typeof(float));
        dt.Columns.Add("ReceiveQty", typeof(float));
        dt.Columns.Add("RejectQty", typeof(float));

        return dt;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        bool isSelect = false;
        int count = 0;//for checking if qty is Entered or not
        int CollectedBy = 0;
        foreach (RepeaterItem lt in grdIndentDetails.Items)
        {
            // GridView grdIt = (GridView)lt.FindControl("grdItem");
            Repeater grdItem = (Repeater)lt.FindControl("grdItem");
            Repeater grdItemGenric = (Repeater)lt.FindControl("grdItemGenric");
            Label LbItemId = (Label)lt.FindControl("lblItemID");
            Label RequestQty = (Label)lt.FindControl("lblRequestedQty");
            Label LAvailQty = (Label)lt.FindControl("lblAvailQty");
            CheckBox chkSelect = (CheckBox)lt.FindControl("chkSelect");
            if (chkSelect.Checked)
            {
                isSelect = true;
                float newIssueQty = 0f;
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
                                    if (Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) > 0)
                                    {
                                        newIssueQty = newIssueQty + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                        count++;
                                    }
                                }
                            }
                        }
                        if (Util.GetFloat(((TextBox)grItem.FindControl("txtIssueQty1")).Text) > 0)
                        {
                            newIssueQty = newIssueQty + Util.GetFloat(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                            count++;
                        }
                    }
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
                                    if (Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) > 0)
                                    {
                                        newIssueQty = newIssueQty + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                        count++;
                                    }
                                }
                            }
                        }

                    }
                }

                float totalRequest = Util.GetFloat(((Label)lt.FindControl("lblRequestedQty")).Text);
                float oldIssueQty = Util.GetFloat(((Label)lt.FindControl("lblIssuedQty")).Text);
                float oldReject = Util.GetFloat(((Label)lt.FindControl("lblRejectedQty")).Text);
                float totalApproved = Util.GetFloat(((Label)lt.FindControl("lblApprovedQty")).Text);
                float txtReject = Util.GetFloat(((TextBox)lt.FindControl("txtReject")).Text);
                if (txtReject != 0.0)
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
                float pendingQty = Util.GetFloat(((Label)lt.FindControl("lblPendingQty")).Text);
                if (Util.GetDecimal(totalApproved) < Util.GetDecimal(oldIssueQty + oldReject + txtReject + newIssueQty))
                {
                    if (Util.GetDecimal(newIssueQty) == 0 && Util.GetDecimal(txtReject) > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Reject Qty. is greater than Approved Qty.');", true);
                    }
                    else
                    {

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Issue Qty. is greater than Approved Qty.');", true);
                    } return;
                }
                else
                    ((TextBox)lt.FindControl("txtIssueingQty")).Text = Util.GetString(newIssueQty);
                //To Check Collected By is entered or not 
                if (count > 0 && txtReject == 0.0)
                {
                    if (((TextBox)lt.FindControl("txtCollectedBy")).Text.Trim() == "")
                    {
                        CollectedBy = 1;
                    }
                }
            }
        }

        if (!isSelect)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('No Item is Selected.');", true);
            return;
        }
        else if (count == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Please Enter Issue/Reject Qty');", true);
            return;
        }
        else if (CollectedBy == 1)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Please Enter Person Name');", true);
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
            //code for getting sales number
            // string strSales = "select max(salesno) from f_salesdetails where TrasactionTypeID = 1";

            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('1','" + AllGlobalFunction.GeneralStoreID + "') "));

            string IndentNo = "";
            string CentreID = "";
            string HospCentreID = "";
            string str_StockId = "";
            float TIssueQty = 0f;
            foreach (RepeaterItem ri in grdIndentDetails.Items)
            {
                IndentNo = Util.GetString(((Label)ri.FindControl("lblIndentNo")).Text.Trim());
                CentreID = Util.GetString(((Label)ri.FindControl("lblCentreID")).Text.Trim());
                HospCentreID = Util.GetString(((Label)ri.FindControl("lblHospCentreID")).Text.Trim());
                if (((CheckBox)ri.FindControl("chkSelect")).Checked)
                {
                    // GridView grdIt = (GridView)ri.FindControl("grdItem");
                    string GenricItemid = ((Label)ri.FindControl("lblItemID")).Text.ToString();
                    Repeater grdItem = (Repeater)ri.FindControl("grdItem");
                    Repeater grdItemGenric = (Repeater)ri.FindControl("grdItemGenric");
                    float newIssueQty = 0f;

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
                                        if (Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) > 0)
                                        {
                                            newIssueQty = newIssueQty + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                            str_StockId = ((Label)grItemNew.FindControl("lblStockIDnew")).Text;
                                            string stt = "select StockID,ItemID,itemname,BatchNumber,Rate,DiscPer,DiscAmt,PurTaxPer ,PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";

                                            DataTable dtResult = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stt).Tables[0];
                                            if (dtResult != null && dtResult.Rows.Count > 0)
                                            {
                                                int i = 0;
                                                string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + "),0,1)CHK from f_stock where stockID='" + str_StockId + "'";
                                                if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                                                {
                                                    Tranx.Rollback();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }
                                                string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + " where StockID = '" + str_StockId + "'";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);



                                                string sqlind = "SELECT   ApprovedQty-(ReceiveQty+RejectQty) FROM f_indent_detail WHERE indentno='" + IndentNo + "' AND itemid= '" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "' ";
                                                decimal RemQty = Util.GetDecimal(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sqlind));
                                                decimal AvlQty = RemQty - Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                                if (AvlQty < 0)
                                                {
                                                    DataTable DtIndent = (DataTable)ViewState["StockTransfer"];
                                                    foreach (DataRow dr in DtIndent.Rows)
                                                    {
                                                        if (Util.GetString(dr["Itemid"]) == Util.GetString(dtResult.Rows[i]["ItemID"]))
                                                            dr["PendingQty"] = RemQty;
                                                    }
                                                    DtIndent.AcceptChanges();
                                                    grdIndentDetails.DataSource = DtIndent;
                                                    grdIndentDetails.DataBind();
                                                    Tranx.Rollback();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                //*********************************************************************************************************************
                                                StringBuilder sb = new StringBuilder();
                                                sb.Append("insert into f_indent_detail(IndentNo,ItemId,ItemName,ReqQty,ReceiveQty,UnitType,DeptFrom,DeptTo,StoreId,Narration,UserId,Type,GenricType,OLDItemID,Hospital_ID,CentreID,HospCentreID)  ");
                                                sb.Append("values('" + IndentNo + "','" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "','" + Util.GetString(dtResult.Rows[i]["ItemName"]) + "'," + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + "," + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + "");
                                                sb.Append(",'" + Util.GetString(dtResult.Rows[i]["UnitType"]) + "','" + ddlDepartment.SelectedValue + "','" + ViewState["DeptLedgerNo"].ToString() + "','STO00001','genric Item issue','" + ViewState["ID"].ToString() + "','Normal','GENERIC','" + GenricItemid + "','" + Session["HOSPID"].ToString() + "','" + CentreID + "','" + HospCentreID + "') ");

                                                string strIndent = "update f_indent_detail set RejectQty = RejectQty + " + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + ",ReceiveQty = ReceiveQty -" + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + ",RejectBy='" + ViewState["ID"].ToString() + "',RejectReason='Generic Item Issued' where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptfrom='" + ddlDepartment.SelectedItem.Value + "'";

                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndent);
                                                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                                                {
                                                    Tranx.Rollback();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }
                                                Stock objStock = new Stock(Tranx);
                                                objStock.Hospital_ID = Session["HOSPID"].ToString();
                                                objStock.InitialCount = Util.GetDecimal(dtResult.Rows[i]["AvailQty"]);
                                                objStock.BatchNumber = Util.GetString(dtResult.Rows[i]["BatchNumber"]);
                                                objStock.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                                objStock.ItemName = Util.GetString(dtResult.Rows[i]["ItemName"]);
                                                objStock.DeptLedgerNo = Util.GetString(ddlDepartment.SelectedItem.Value);
                                                objStock.IsFree = 0;
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
                                                objStock.StoreLedgerNo = "STO00002";
                                                objStock.UserID = ViewState["ID"].ToString();
                                                objStock.PostUserID = ViewState["ID"].ToString();
                                                objStock.Rate = Util.GetDecimal(dtResult.Rows[i]["Rate"]);
                                                objStock.TYPE = Util.GetString(dtResult.Rows[i]["TYPE"]);
                                                objStock.IsBilled = Util.GetInt(dtResult.Rows[i]["IsBilled"]);
                                                objStock.Reusable = Util.GetInt(dtResult.Rows[i]["Reusable"]);
                                                objStock.SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                                objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);
                                                objStock.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                                                objStock.PurTaxAmt = Util.GetDecimal(dtResult.Rows[i]["PurTaxAmt"]);
                                                objStock.DiscPer = Util.GetDecimal(dtResult.Rows[i]["DiscPer"]);
                                                objStock.DiscAmt = Util.GetDecimal(dtResult.Rows[i]["DiscAmt"]);
                                                objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);

                                                objStock.MajorUnit = Util.GetString(dtResult.Rows[i]["MajorUnit"]);
                                                objStock.MinorUnit = Util.GetString(dtResult.Rows[i]["MinorUnit"]);
                                                objStock.ConversionFactor = Util.GetDecimal(dtResult.Rows[i]["ConversionFactor"]);
                                                objStock.CentreID = Util.GetInt(CentreID);
                                                //objStock.HospCentreID = Util.GetInt(HospCentreID);
                                                string stokID = objStock.Insert();

                                                string stTax = "SELECT taxid,percentage,itemid,stockid,TaxAmt,hospital_id FROM f_taxchargedlist WHERE stockid='" + Util.GetString(dtResult.Rows[i]["StockID"]) + "' AND itemid='" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "' ";
                                                DataTable dtTax = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stTax).Tables[0];
                                                if (dtTax != null && dtTax.Rows.Count > 0)
                                                {
                                                    // Util.GetString(dtTax.Rows[i]["hospital_id"]);
                                                    TaxChargedList objTCharged = new TaxChargedList(Tranx);
                                                    objTCharged.LedgerTransactionNo = "";
                                                    objTCharged.Hospital_ID = Util.GetString(dtTax.Rows[0]["hospital_id"]);
                                                    objTCharged.TaxID = Util.GetString(dtTax.Rows[0]["taxid"]);
                                                    objTCharged.Percentage = Util.GetDecimal(dtTax.Rows[0]["percentage"]);

                                                    objTCharged.ItemID = Util.GetString(dtTax.Rows[0]["itemid"]);
                                                    objTCharged.StockID = stokID;
                                                    objTCharged.Amount = Util.GetDecimal(dtTax.Rows[0]["TaxAmt"]);
                                                    //objTCharged.CentreID = Util.GetInt(CentreID);
                                                    //objTCharged.HospCentreID = Util.GetInt(HospCentreID);
                                                    int TaxChrgID = objTCharged.Insert();

                                                    if (TaxChrgID == 0)
                                                    {
                                                        Tranx.Rollback();
                                                        Tranx.Dispose();
                                                        con.Close();
                                                        con.Dispose();
                                                        lblMsg.Text = "Record Not Saved";
                                                        return;
                                                    }
                                                }

                                                Sales_Details ObjSales = new Sales_Details(Tranx);
                                                ObjSales.Hospital_ID = Session["HOSPID"].ToString();
                                                ObjSales.LedgerNumber = Util.GetString(ddlDepartment.SelectedItem.Value);
                                                ObjSales.DepartmentID = "STO00002";
                                                ObjSales.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                                ObjSales.StockID = Util.GetString(dtResult.Rows[i]["StockID"]);

                                                ObjSales.SoldUnits = Util.GetDecimal(dtResult.Rows[i]["AvailQty"]);
                                                ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                                                ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtResult.Rows[i]["MRP"]);

                                                ObjSales.Date = DateTime.Now;
                                                ObjSales.Time = DateTime.Now;
                                                ObjSales.IsReturn = 0;
                                                ObjSales.LedgerTransactionNo = "";
                                                ObjSales.TrasactionTypeID = 1;
                                                ObjSales.IsService = "NO";
                                                ObjSales.IndentNo = IndentNo;
                                                ObjSales.SalesNo = SalesNo;
                                                ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                                ObjSales.UserID = ViewState["ID"].ToString();
                                                ObjSales.CentreID = Util.GetInt(CentreID);
                                                //ObjSales.HospCentreID = Util.GetInt(HospCentreID);
                                                string SalesID = ObjSales.Insert();
                                                if (SalesID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }
                                            }
                                            else
                                            {
                                                Tranx.Rollback();
                                                Tranx.Dispose();
                                                con.Close();
                                                con.Dispose();
                                                return;
                                            }
                                        }
                                    }
                                }
                            }
                            if (Util.GetFloat(((TextBox)grItem.FindControl("txtIssueQty1")).Text) > 0)
                            {
                                newIssueQty = newIssueQty + Util.GetFloat(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                TIssueQty = TIssueQty + newIssueQty;
                                str_StockId = ((Label)grItem.FindControl("lblStockID")).Text;
                                string stt = "select StockID,ItemID,itemname,BatchNumber,Rate,DiscPer,DiscAmt,PurTaxPer ,PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";
                                DataTable dtResult = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stt).Tables[0];
                                if (dtResult != null && dtResult.Rows.Count > 0)
                                {
                                    int i = 0;
                                    //----Check Release Count in Stock Table---------------------
                                    string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(dtResult.Rows[i]["AvailQty"]) + "),0,1)CHK from f_stock where stockID='" + Util.GetString(dtResult.Rows[i]["StockID"]) + "'";
                                    if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                                    {
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Issue Quantity is not available in the Store');", true);
                                        Tranx.Rollback();
                                        con.Close();
                                        con.Dispose();
                                        return;
                                    }

                                    string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetFloat(((TextBox)grItem.FindControl("txtIssueQty1")).Text) + " where StockID = '" + Util.GetString(dtResult.Rows[i]["StockID"]) + "'";
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);

                                    Stock objStock = new Stock(Tranx);
                                    objStock.Hospital_ID = Session["HOSPID"].ToString();
                                    objStock.InitialCount = Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                    objStock.BatchNumber = Util.GetString(dtResult.Rows[i]["BatchNumber"]);
                                    objStock.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                    objStock.ItemName = Util.GetString(dtResult.Rows[i]["ItemName"]);
                                    objStock.DeptLedgerNo = Util.GetString(ddlDepartment.SelectedItem.Value);
                                    objStock.IsFree = 0;
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
                                    objStock.StoreLedgerNo = "STO00002";
                                    objStock.UserID = ViewState["ID"].ToString();
                                    objStock.PostUserID = ViewState["ID"].ToString();

                                    objStock.Rate = Util.GetDecimal(dtResult.Rows[i]["Rate"]);
                                    objStock.TYPE = Util.GetString(dtResult.Rows[i]["TYPE"]);
                                    objStock.IsBilled = Util.GetInt(dtResult.Rows[i]["IsBilled"]);
                                    objStock.Reusable = Util.GetInt(dtResult.Rows[i]["Reusable"]);
                                    objStock.SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                    objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);
                                    objStock.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                                    objStock.PurTaxAmt = Util.GetDecimal(dtResult.Rows[i]["PurTaxAmt"]);
                                    objStock.DiscPer = Util.GetDecimal(dtResult.Rows[i]["DiscPer"]);
                                    objStock.DiscAmt = Util.GetDecimal(dtResult.Rows[i]["DiscAmt"]);
                                    objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);

                                    objStock.CentreID = Util.GetInt(CentreID);
                                    //objStock.HospCentreID = Util.GetInt(HospCentreID);

                                    string stokID = objStock.Insert();
                                    if (stokID == string.Empty)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        return;
                                    }

                                    Sales_Details ObjSales = new Sales_Details(Tranx);
                                    ObjSales.Hospital_ID = Session["HOSPID"].ToString();
                                    ObjSales.LedgerNumber = Util.GetString(ddlDepartment.SelectedItem.Value);
                                    ObjSales.DepartmentID = "STO00002";
                                    ObjSales.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                    ObjSales.StockID = Util.GetString(dtResult.Rows[i]["StockID"]);

                                    ObjSales.SoldUnits = Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtResult.Rows[i]["MRP"]);

                                    ObjSales.Date = DateTime.Now;
                                    ObjSales.Time = DateTime.Now;
                                    ObjSales.IsReturn = 0;
                                    ObjSales.LedgerTransactionNo = "";
                                    ObjSales.TrasactionTypeID = 1;
                                    ObjSales.IsService = "NO";
                                    ObjSales.IndentNo = IndentNo;
                                    ObjSales.SalesNo = SalesNo;
                                    ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                    ObjSales.UserID = ViewState["ID"].ToString();

                                    ObjSales.CentreID = Util.GetInt(CentreID);
                                    //ObjSales.HospCentreID = Util.GetInt(HospCentreID);
                                    string SalesID = ObjSales.Insert();
                                    if (SalesID == string.Empty)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        return;
                                    }
                                    if (stokID == string.Empty)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        return;
                                    }
                                }
                                else
                                {
                                    Tranx.Rollback();
                                    Tranx.Dispose();
                                    con.Close();
                                    con.Dispose();
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
                                        if (Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) > 0)
                                        {
                                            newIssueQty = newIssueQty + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                            str_StockId = ((Label)grItemNewgenric.FindControl("lblStockIDnewgenric")).Text;
                                            string stt = "select StockID,ItemID,itemname,BatchNumber,Rate,DiscPer,DiscAmt,PurTaxPer ,PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";
                                            DataTable dtResult = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stt).Tables[0];
                                            if (dtResult != null && dtResult.Rows.Count > 0)
                                            {
                                                int i = 0;
                                                string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + "),0,1)CHK from f_stock where stockID='" + str_StockId + "'";
                                                if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                                                {
                                                    Tranx.Rollback();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }
                                                string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + " where StockID = '" + str_StockId + "'";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);


                                                //********************************************************03-07-2013***************************************************

                                                string sqlind = "SELECT   ApprovedQty-(ReceiveQty+RejectQty) FROM f_indent_detail WHERE indentno='" + IndentNo + "' AND itemid= '" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "' ";
                                                int RemQty = Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sqlind));
                                                int AvlQty = RemQty - Util.GetInt(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                if (AvlQty < 0)
                                                {
                                                    DataTable DtIndent = (DataTable)ViewState["StockTransfer"];
                                                    foreach (DataRow dr in DtIndent.Rows)
                                                    {
                                                        if (Util.GetString(dr["Itemid"]) == Util.GetString(Util.GetString(dtResult.Rows[i]["ItemID"])))
                                                            dr["PendingQty"] = RemQty;
                                                    }
                                                    DtIndent.AcceptChanges();
                                                    grdIndentDetails.DataSource = DtIndent;
                                                    grdIndentDetails.DataBind();
                                                    Tranx.Rollback();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                //*********************************************************************************************************************

                                                StringBuilder sb = new StringBuilder();
                                                sb.Append("insert into f_indent_detail(IndentNo,ItemId,ItemName,ReqQty,ReceiveQty,UnitType,DeptFrom,DeptTo,StoreId,Narration,UserId,Type,GenricType,OLDItemID,Hospital_ID,CentreID,HospCentreID)  ");
                                                sb.Append("values('" + IndentNo + "','" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "','" + Util.GetString(dtResult.Rows[i]["ItemName"]) + "'," + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + "," + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + "");
                                                sb.Append(",'" + Util.GetString(dtResult.Rows[i]["UnitType"]) + "','" + ddlDepartment.SelectedValue + "','" + ViewState["DeptLedgerNo"].ToString() + "','STO00001','generic Item issue','" + ViewState["ID"].ToString() + "','Normal','GENRIC','" + GenricItemid + "','" + Session["HOSPID"].ToString() + "','" + CentreID + "','" + HospCentreID + "') ");


                                                string strIndent = "update f_indent_detail set RejectQty = RejectQty + " + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + ",ReceiveQty = ReceiveQty -" + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + ",RejectBy='" + ViewState["ID"].ToString() + "',RejectReason='Generic Item Issued' where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptfrom='" + ddlDepartment.SelectedItem.Value + "'";

                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndent);
                                                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                                                {
                                                    Tranx.Rollback();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }


                                                Stock objStock = new Stock(Tranx);
                                                objStock.Hospital_ID = Session["HOSPID"].ToString();
                                                objStock.InitialCount = Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                objStock.BatchNumber = Util.GetString(dtResult.Rows[i]["BatchNumber"]);
                                                objStock.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                                objStock.ItemName = Util.GetString(dtResult.Rows[i]["ItemName"]);
                                                objStock.DeptLedgerNo = Util.GetString(ddlDepartment.SelectedItem.Value);
                                                objStock.IsFree = 0;
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
                                                objStock.StoreLedgerNo = "STO00002";
                                                objStock.UserID = ViewState["ID"].ToString();
                                                objStock.PostUserID = ViewState["ID"].ToString();


                                                objStock.Rate = Util.GetDecimal(dtResult.Rows[i]["Rate"]);
                                                objStock.TYPE = Util.GetString(dtResult.Rows[i]["TYPE"]);
                                                objStock.IsBilled = Util.GetInt(dtResult.Rows[i]["IsBilled"]);
                                                objStock.Reusable = Util.GetInt(dtResult.Rows[i]["Reusable"]);
                                                objStock.SaleTaxPer = Util.GetDecimal(dtResult.Rows[i]["SaleTaxPer"]);
                                                objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);
                                                objStock.PurTaxPer = Util.GetDecimal(dtResult.Rows[i]["PurTaxPer"]);
                                                objStock.PurTaxAmt = Util.GetDecimal(dtResult.Rows[i]["PurTaxAmt"]);
                                                objStock.DiscPer = Util.GetDecimal(dtResult.Rows[i]["DiscPer"]);
                                                objStock.DiscAmt = Util.GetDecimal(dtResult.Rows[i]["DiscAmt"]);
                                                objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[i]["SaleTaxAmt"]);

                                                objStock.CentreID = Util.GetInt(CentreID);
                                                //objStock.HospCentreID = Util.GetInt(HospCentreID);

                                                string stokID = objStock.Insert();
                                                string stTax = "SELECT taxid,percentage,itemid,stockid,TaxAmt,hospital_id FROM f_taxchargedlist WHERE stockid='" + Util.GetString(dtResult.Rows[i]["StockID"]) + "' AND itemid='" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "' ";
                                                DataTable dtTax = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stTax).Tables[0];
                                                if (dtTax != null && dtTax.Rows.Count > 0)
                                                {
                                                    // Util.GetString(dtTax.Rows[i]["hospital_id"]);
                                                    TaxChargedList objTCharged = new TaxChargedList(Tranx);
                                                    objTCharged.LedgerTransactionNo = "";
                                                    objTCharged.Hospital_ID = Util.GetString(dtTax.Rows[0]["hospital_id"]);
                                                    objTCharged.TaxID = Util.GetString(dtTax.Rows[0]["taxid"]);
                                                    objTCharged.Percentage = Util.GetDecimal(dtTax.Rows[0]["percentage"]);

                                                    objTCharged.ItemID = Util.GetString(dtTax.Rows[0]["itemid"]);
                                                    objTCharged.StockID = stokID;
                                                    objTCharged.Amount = Util.GetDecimal(dtTax.Rows[0]["TaxAmt"]);
                                                    // objTCharged.CentreID = Util.GetInt(CentreID);
                                                    //objTCharged.HospCentreID = Util.GetInt(HospCentreID);
                                                    int TaxChrgID = objTCharged.Insert();

                                                    if (TaxChrgID == 0)
                                                    {
                                                        Tranx.Rollback();
                                                        Tranx.Dispose();
                                                        con.Close();
                                                        con.Dispose();
                                                        //lblMsg.Text = "Record Not Saved";
                                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
                                                        return;
                                                    }
                                                }
                                                Sales_Details ObjSales = new Sales_Details(Tranx);
                                                ObjSales.Hospital_ID = Session["HOSPID"].ToString();
                                                ObjSales.LedgerNumber = Util.GetString(ddlDepartment.SelectedItem.Value);
                                                ObjSales.DepartmentID = "STO00002";
                                                ObjSales.ItemID = Util.GetString(dtResult.Rows[i]["ItemID"]);
                                                ObjSales.StockID = Util.GetString(dtResult.Rows[i]["StockID"]);

                                                ObjSales.SoldUnits = Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtResult.Rows[i]["UnitPrice"]);
                                                ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtResult.Rows[i]["MRP"]);

                                                ObjSales.Date = DateTime.Now;
                                                ObjSales.Time = DateTime.Now;
                                                ObjSales.IsReturn = 0;
                                                ObjSales.LedgerTransactionNo = "";
                                                ObjSales.TrasactionTypeID = 1;
                                                ObjSales.IsService = "NO";
                                                ObjSales.IndentNo = IndentNo;
                                                ObjSales.SalesNo = SalesNo;
                                                ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                                ObjSales.UserID = ViewState["ID"].ToString();
                                                ObjSales.CentreID = Util.GetInt(CentreID);
                                                // ObjSales.HospCentreID = Util.GetInt(HospCentreID);

                                                string SalesID = ObjSales.Insert();

                                                if (SalesID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }
                                                if (stokID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }
                                            }
                                            else
                                            {
                                                Tranx.Rollback();
                                                Tranx.Dispose();
                                                con.Close();
                                                con.Dispose();
                                                return;
                                            }
                                            //newIssueQty = newIssueQty + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //********************************************************03-07-2013***************************************************

                    string sqlind1 = "SELECT   ApprovedQty-(ReceiveQty+RejectQty) FROM f_indent_detail WHERE indentno='" + IndentNo + "' AND itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' ";
                    decimal RemQty1 = Util.GetDecimal(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sqlind1));
                    decimal AvlQty1 = RemQty1 - Util.GetDecimal(((TextBox)ri.FindControl("txtIssueingQty")).Text);
                    if (AvlQty1 < 0)
                    {
                        DataTable DtIndent = (DataTable)ViewState["StockTransfer"];
                        foreach (DataRow dr in DtIndent.Rows)
                        {
                            if (Util.GetString(dr["Itemid"]) == Util.GetString(((Label)ri.FindControl("lblItemID")).Text))
                                dr["PendingQty"] = RemQty1;
                        }
                        DtIndent.AcceptChanges();
                        grdIndentDetails.DataSource = DtIndent;
                        grdIndentDetails.DataBind();
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        return;
                    }

                    //*********************************************************************************************************************

                    string strIndent1 = "";
                    if (Util.GetString(Util.GetString(((TextBox)ri.FindControl("txtReason")).Text)) != "")
                    {
                        //strIndent1 = "update f_indent_detail set dtReject=now(),RejectReason='" + Util.GetString(Util.GetString(((TextBox)ri.FindControl("txtReason")).Text)) + "',RejectQty = RejectQty + " + Util.GetString(Util.GetFloat(((TextBox)ri.FindControl("txtReject")).Text)) + ",ReceiveQty = ReceiveQty +" + Util.GetFloat(((TextBox)ri.FindControl("txtIssueingQty")).Text) + " where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptfrom='" + ddlDepartment.SelectedItem.Value + "'";
                        strIndent1 = "update f_indent_detail set dtReject=now(),RejectReason='" + Util.GetString(Util.GetString(((TextBox)ri.FindControl("txtReason")).Text)) + "',RejectQty = RejectQty + " + Util.GetString(Util.GetFloat(((TextBox)ri.FindControl("txtReject")).Text)) + ",ReceiveQty = ReceiveQty +" + Util.GetFloat(((TextBox)ri.FindControl("txtIssueingQty")).Text) + ",rejectBy='" + ViewState["ID"] + "' where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptfrom='" + ddlDepartment.SelectedItem.Value + "'";

                    }
                    else
                    {
                        strIndent1 = "update f_indent_detail set RejectQty = RejectQty + " + Util.GetString(Util.GetFloat(((TextBox)ri.FindControl("txtReject")).Text)) + ",ReceiveQty = ReceiveQty +" + Util.GetFloat(((TextBox)ri.FindControl("txtIssueingQty")).Text) + ",CollectedBy='" + Util.GetString(((TextBox)ri.FindControl("txtCollectedBy")).Text.Trim()) + "' where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptfrom='" + ddlDepartment.SelectedItem.Value + "'  and IFNULL(genrictype,'')<>'GENRIC' ";

                    }
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndent1);
                }
            }
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            string Indent_Dpt = ViewState["Indent_Dpt"].ToString();
            if (TIssueQty > 0)
            {
                if (chkPrint.Checked)
                {
                    PrintIndent(Util.GetString(((Label)grdIndentDetails.Items[0].FindControl("lblIndentNo")).Text.Trim()), SalesNo.ToString());
                    chkPrint.Checked = false;
                }
            }
            BindIndentDetails(Indent_Dpt.Split('#')[1], Indent_Dpt.Split('#')[0], Indent_Dpt.Split('#')[3]);
            btnSearchIndent_Click1(this, new EventArgs());
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
    }
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
                    // ((CheckBox)grdIndentDetails.FindControl("chkSelect")).Checked = true;
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
            return StockReports.GetDataTable("select StockID,ItemID,ItemName,SaleTaxPer,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%y')MedExpiryDate,(InitialCount-ReleasedCount)AvailQty,SubCategoryID,UnitType from f_stock where ItemID in (" + Itemids + ") and (InitialCount-ReleasedCount)>0 and Ispost=1 and DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "' and MedExpiryDate>curdate() order by stockid ");
        }
        else
        {
            return null;
        }
    }
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
                    //((CheckBox)grdIndentDetails.Items.FindControl("chkSelect")).Checked = true;
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
    private DataTable getStockItem(string ItemId)
    {
        //DataSet ds = new DataSet();
        return StockReports.GetDataTable("select  fst.StockID,im.isexpirable,  fst.ItemID,  fst.ItemName,  fst.SaleTaxPer,  fst.BatchNumber, fst.UnitPrice,  fst.MRP,DATE_FORMAT(MedExpiryDate,'%d-%b-%y')MedExpiryDate,  (fst.InitialCount-fst.ReleasedCount)    AvailQty,  fst.SubCategoryID,  fst.UnitType FROM f_stock fst  INNER JOIN f_itemmaster im ON im.ItemID=fst.ItemID where fst.ItemID='" + ItemId + "' and (InitialCount-ReleasedCount)>0 and Ispost=1 and DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "' and  ( IF(im.IsExpirable='NO','2050-01-01',fst.MedExpiryDate)> CURDATE() ) order by stockid ");
    }
    protected void PrintIndent(string IndentNo, string salesno)
    {
        StringBuilder sb1 = new StringBuilder();

        sb1.Append("SELECT id.IndentNo,id.ItemName,id.ReqQty,id.ApprovedQty,id.CancelQty,id.ReceiveQty,id.RejectQty,t.IssuedQty, ");
        sb1.Append("id.UnitType,id.Narration,id.isApproved, id.ApprovedBy,id.ApprovedReason,t.salesno,t.iDate, ");
        sb1.Append(" date_format(id.dtEntry,'%d-%b-%Y %h:%i %p')dtEntry,id.UserId,t.BatchNumber, ");
        sb1.Append("t.CostPrice,t.MedExpiryDate, ");
        sb1.Append("(SELECT DeptName FROM f_role_dept WHERE DeptLedgerNo = id.DeptFrom)DeptFrom, ");
        sb1.Append("(SELECT DeptName FROM f_role_dept WHERE DeptLedgerNo = id.DeptTo)DeptTo, ");
        sb1.Append("(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employee_ID=id.UserId)EmpName, ");
        sb1.Append("(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employee_ID=t.UserId)IssueBy, t.SellingPrice,id.CollectedBy ");
        sb1.Append("FROM ");
        sb1.Append("(SELECT * FROM f_indent_detail WHERE indentno='" + IndentNo + "') id INNER JOIN ");
        sb1.Append("(SELECT sd.IndentNo,st.BatchNumber,st.UnitPrice CostPrice,SUM(sd.SoldUnits)IssuedQty,sd.salesno,CONCAT(DATE_FORMAT(sd.DATE,'%d-%b-%Y'),' ',time_format(sd.TIME,'%h:%i %p'))iDate, ");
        sb1.Append("st.MedExpiryDate,sd.ItemID,sd.StockID,sd.UserID,sd.PerUnitSellingPrice SellingPrice FROM ");

        if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            sb1.Append("  f_salesdetails sd ");
        else
            sb1.Append("  f_salesdetails sd ");

        if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            sb1.Append(" INNER JOIN f_stock st ");
        else
            sb1.Append(" INNER JOIN f_stock st ");

        sb1.Append("ON sd.StockID = st.StockID WHERE sd.indentno='" + IndentNo + "' and sd.salesno='" + salesno + "'");
        sb1.Append("GROUP BY sd.StockID,st.BatchNumber)t ");
        sb1.Append("ON id.ItemId = t.ItemID AND id.IndentNo = t.IndentNo ");

        DataSet ds = new DataSet();
        ds.Tables.Add(StockReports.GetDataTable(sb1.ToString()).Copy());
        //ds.WriteXmlSchema(@"C:\NewIndent.xml");
        Session["ds"] = ds;
        Session["ReportName"] = "NewIndentForStore";

        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);
    }
    protected void btnSearchIndent_Click1(object sender, EventArgs e)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM (   ");
            sb.Append("  SELECT t.*,(CASE WHEN t.ApprovedQty=t.RejectQty THEN 'REJECT' WHEN  t.ApprovedQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'   ");
            sb.Append("  WHEN   t.ApprovedQty+t.ReceiveQty+t.RejectQty=t.ApprovedQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew   ");
            sb.Append("  FROM (  ");

            sb.Append(" SELECT id.indentno,id.Type,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,lm.ledgername AS DeptFrom,  ");
            sb.Append("  (SELECT COUNT(*) FROM f_salesdetails WHERE IndentNo=id.indentno)NewIndent,SUM(ReqQty)ReqQty,Sum(ApprovedQty)ApprovedQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty, CM.CentreName,cm.CentreID  ");
            sb.Append("    FROM f_indent_detail id   ");
            sb.Append("  INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = id.Deptfrom INNER JOIN center_master CM ON id.CentreID=CM.CentreID where Date(id.dtEntry) >= '" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' and Date(id.dtEntry) <='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' and id.storeid='STO00002' and id.deptto = '" + ViewState["DeptLedgerNo"].ToString() + "'  ");

            if (txtIndentNoToSearch.Text.ToString().Trim() != string.Empty)
            {
                sb.Append("   and indentno = '" + txtIndentNoToSearch.Text.ToString().Trim() + "' ");
            }
            if (ddlDepartment.SelectedIndex > 0)
            {
                sb.Append("   and deptfrom='" + ddlDepartment.SelectedItem.Value + "' ");
            }
            if (ddlCentre.SelectedIndex > 0)
            {
                sb.Append(" and id.CentreID='" + ddlCentre.SelectedValue + "' ");
            }
            sb.Append("  and ifnull(id.IsApproved,0)>0 GROUP BY IndentNo        )t  )t1 ");
            DataTable dtIndentDetails = StockReports.GetDataTable(sb.ToString());
            if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
            {
                grdIndentSearch.DataSource = dtIndentDetails;
                grdIndentSearch.DataBind();
                grdIndentDetails.DataSource = null;
                grdIndentDetails.DataBind();
            }
            else
            {
                grdIndentSearch.DataSource = null;
                grdIndentSearch.DataBind();
                grdIndentDetails.DataSource = null;
                grdIndentDetails.DataBind();
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
    protected void BindIndentDetails(string Dept, string IndentNo, string CentreID)
    {
        string str = "select * from f_indent_detail where (ReceiveQty+RejectQty)<ApprovedQty and indentno = '" + IndentNo + "'";
        DataTable dtIndentDetails = StockReports.GetDataTable(str);

        if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
        {
            lblMsg.Text = "";
            dtIndentDetails.Columns.Add("AvailQty");
            dtIndentDetails.Columns.Add("IssuePossible");
            dtIndentDetails.Columns.Add("PendingQty");
            dtIndentDetails.Columns.Add("DeptAvailQty");
            for (int m = 0; m < dtIndentDetails.Rows.Count; m++)
            {
                string stt = "select DISTINCT sum(InitialCount-ReleasedCount-PendingQty)AvailQty from f_stock  where itemid='" + dtIndentDetails.Rows[m]["itemid"] + "' and (InitialCount-ReleasedCount-PendingQty)>0 and deptledgerno ='" + ViewState["DeptLedgerNo"].ToString() + "' and Ispost=1 group by  itemid";
                string result = StockReports.ExecuteScalar(stt);
                if (result == "")
                    result = "0";
                dtIndentDetails.Rows[m]["AvailQty"] = result;

                string sttSubDeptQty = "select DISTINCT sum(InitialCount-ReleasedCount-PendingQty)DeptAvailQty from f_stock  where itemid='" + dtIndentDetails.Rows[m]["itemid"] + "' and (InitialCount-ReleasedCount-PendingQty)>0 and deptledgerno ='" + dtIndentDetails.Rows[m]["DeptFrom"].ToString() + "' and CentreID='" + CentreID + "' and Ispost=1 group by  itemid";
                string resultSubDept = StockReports.ExecuteScalar(sttSubDeptQty);
                if (resultSubDept == "")
                    resultSubDept = "0";
                dtIndentDetails.Rows[m]["DeptAvailQty"] = resultSubDept;


                float resQty = Util.GetFloat(dtIndentDetails.Rows[m]["ApprovedQty"]) - Util.GetFloat(dtIndentDetails.Rows[m]["ReceiveQty"]) - Util.GetFloat(dtIndentDetails.Rows[m]["RejectQty"]);
                if (resQty < Util.GetFloat(result)) { dtIndentDetails.Rows[m]["IssuePossible"] = resQty; }
                else { dtIndentDetails.Rows[m]["IssuePossible"] = Util.GetFloat(result); }
                dtIndentDetails.Rows[m]["PendingQty"] = Util.GetFloat(dtIndentDetails.Rows[m]["ApprovedQty"]) - (Util.GetFloat(dtIndentDetails.Rows[m]["ReceiveQty"]) + Util.GetFloat(dtIndentDetails.Rows[m]["RejectQty"]));
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
            ViewState["Indent_Dpt"] = Util.GetString(e.CommandArgument).Split('#')[0] + "#" + Util.GetString(e.CommandArgument).Split('#')[1] + "#" + Util.GetString(e.CommandArgument).Split('#')[2] + "#" + Util.GetString(e.CommandArgument).Split('#')[3];
            BindIndentDetails(Util.GetString(e.CommandArgument).Split('#')[1], Util.GetString(e.CommandArgument).Split('#')[0], Util.GetString(e.CommandArgument).Split('#')[3]);
        }
        if (e.CommandName == "AViewDetail")
        {
            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string status = Util.GetString(e.CommandArgument).Split('#')[1];

            StringBuilder sb1 = new StringBuilder();
            sb1.Append("select if(ApprovedQty is not null,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=id.ApprovedBy),(Select Concat(title,' ',Name) from Employee_master where Employee_ID=id.CancelUserID))Approve_CancelBy,ifnull(ApprovedQty,if(CancelQty is null,ReqQty,'0'))ApprovedQty,ifnull(CancelQty,'0')CancelQty,'" + status + "'StatusNew, id.IndentNo, id.ItemName, id.ReqQty, id.UnitType,sd.SoldUnits,  DATE_FORMAT(sd.Date,'%d-%b-%y')Date,");
            sb1.Append(" sd.UserId,id.ReceiveQty,(ifnull(id.ApprovedQty,0)-ifnull(id.ReceiveQty,0)-ifnull(id.RejectQty,0))PendingQty,id.RejectQty,IFNULL(CollectedBy,'')CollectedBy,IF(id.IsReceived=0,'No','Yes')Received, ");
            sb1.Append("(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE Employee_ID=id.ReceivedBy)ReceivedBy,DATE_FORMAT(ReceivedDate,'%d-%b-%Y')ReceivedDate from f_indent_detail id   ");

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
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "REJECT")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.Green;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
            }
        }

        if (e.Row != null)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                float RequestedQty = Util.GetFloat(((Label)e.Row.FindControl("lblRequestedQty")).Text.Trim());
                float IssuedQty = Util.GetFloat(((Label)e.Row.FindControl("lblIssuedQty")).Text.Trim());
                float RejectedQty = Util.GetFloat(((Label)e.Row.FindControl("lblRejectedQty")).Text.Trim());
                float PendingQty = Util.GetFloat(((Label)e.Row.FindControl("lblPendingQty")).Text.Trim());


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
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.Green;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
            }
        }
    }



    public void searchindentnew(string status)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM (   ");
            sb.Append("  SELECT t.*,(CASE WHEN t.ApprovedQty=t.RejectQty THEN 'REJECT' WHEN  t.ApprovedQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'   ");
            sb.Append("  WHEN   t.ApprovedQty+t.ReceiveQty+t.RejectQty=t.ApprovedQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew   ");
            sb.Append("  FROM (  ");

            sb.Append(" SELECT id.indentno,id.Type,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,lm.ledgername AS DeptFrom,  ");
            sb.Append("  (SELECT COUNT(*) FROM f_salesdetails WHERE IndentNo=id.indentno)NewIndent,SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,Sum(ApprovedQty)ApprovedQty,SUM(RejectQty)RejectQty,CM.CentreName,cm.CentreID  ");
            sb.Append("    FROM f_indent_detail id   ");
            sb.Append("  INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = id.Deptfrom INNER JOIN center_master CM ON id.CentreID=CM.CentreID where Date(id.dtEntry) >= '" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' and Date(id.dtEntry) <='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' and id.storeid='STO00002' and id.deptto = '" + ViewState["DeptLedgerNo"].ToString() + "'  ");
            if (txtIndentNoToSearch.Text.ToString().Trim() != string.Empty)
            {
                sb.Append("   and indentno = '" + txtIndentNoToSearch.Text.ToString().Trim() + "' ");
            }
            if (ddlDepartment.SelectedIndex > 0)
            {
                sb.Append("   and deptfrom='" + ddlDepartment.SelectedItem.Value + "' ");
            }
            if (ddlCentre.SelectedIndex > 0)
            {
                sb.Append(" and id.CentreID='" + ddlCentre.SelectedValue + "' ");
            }
            sb.Append("  GROUP BY IndentNo )t )t1  ");
            if (status != "")
            {
                sb.Append("  where t1.StatusNew='" + status + "' ");
            }
            DataTable dtIndentDetails = StockReports.GetDataTable(sb.ToString());
            if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
            {
                grdIndentSearch.DataSource = dtIndentDetails;
                grdIndentSearch.DataBind();
                grdIndentDetails.DataSource = null;
                grdIndentDetails.DataBind();
            }
            else
            {
                grdIndentSearch.DataSource = null;
                grdIndentSearch.DataBind();
                grdIndentDetails.DataSource = null;
                grdIndentDetails.DataBind();
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
}
