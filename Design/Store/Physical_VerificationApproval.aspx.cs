using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;

public partial class Design_Store_Physical_VerificationApproval : System.Web.UI.Page
{
    protected bool CheckProcessQty(string EntryNo, string Type, string StoreType)
    {
        DataTable dtChkQty;
        if (StoreType == "STO00001")
            dtChkQty = StockReports.GetDataTable("SELECT ItemID,ItemName,(QIH-InitialCount)ChkQty FROM (SELECT pv.ItemID,pv.StockID,pv.InitialCount,(st.InitialCount-st.ReleasedCount)QIH,pv.ItemName FROM Physical_Verification pv INNER JOIN f_stock st ON st.StockID=pv.StockID WHERE pv.EntryNo='" + EntryNo + "' AND pv.TypeOfTnx='" + Type + "' AND pv.Approved<>2)t ");
        else
            dtChkQty = StockReports.GetDataTable("SELECT ItemID,ItemName,(QIH-InitialCount)ChkQty FROM (SELECT pv.ItemID,pv.StockID,pv.InitialCount,(st.InitialCount-st.ReleasedCount)QIH,pv.ItemName FROM Physical_Verification pv INNER JOIN f_stock st ON st.StockID=pv.StockID WHERE pv.EntryNo='" + EntryNo + "' AND pv.TypeOfTnx='" + Type + "' AND pv.Approved<>2)t ");

        if (dtChkQty.Rows.Count > 0)
        {
            foreach (DataRow dr in dtChkQty.Rows)
            {
                if (Util.GetDecimal(dr["ChkQty"]) < 0)
                {
                    lblmsg.Text = "Check Item (" + dr["ItemName"].ToString() + ") Process Qty. and Available Stock Qty, (Reject This Item Before Save)";
                    return false;
                }
            }
        }
        return true;
    }

    protected void GetSelectedItems(string EntryNo)
    {
        string que = " SELECT pv.ID,pv.EntryNo,pv.ItemID,pv.ItemName,pv.Rate,pv.MRP,pv.BatchNumber,IF(pv.Type='+',pv.InitialCount,CONCAT('-',pv.InitialCount))InitialCount, pv.TypeOfTnx, " +
                     " (SELECT LedgerName FROM f_ledgermaster WHERE ledgerNumber=pv.DeptLedgerNo LIMIT 1)Department,  " +
                     " pv.PurTaxPer,pv.PurTaxType,pv.Approved,IFNULL((st.InitialCount-st.ReleasedCount),0)CurrentStock FROM physical_verification pv " +
                     " LEFT JOIN f_stock st ON st.StockID=pv.StockID " +
                     " WHERE pv.EntryNo=" + EntryNo + " ORDER BY pv.TypeOfTnx ";
        DataTable dtItems = StockReports.GetDataTable(que);
        if (dtItems.Rows.Count > 0)
        {
            grdItemDetails.DataSource = dtItems;
            grdItemDetails.DataBind();
        }
        else
        {
            grdItemDetails.DataSource = null;
            grdItemDetails.DataBind();
            lblmsg.Text = "Please Select One Entry No";
        }
    }

    protected void grdItemDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            string value = Util.GetString(e.CommandArgument);
            bool Result = StockReports.ExecuteDML("Update Physical_Verification set Approved=2,ApprovedBy='" + Session["ID"].ToString() + "' where ID='" + value.ToString() + "' ");
            if (Result)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblmsg.ClientID + "');", true);
                grdItemDetails.DataSource = null;
                grdItemDetails.DataBind();
                BindPhysicalData();
            }
        }
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string value = "";
        lblmsg.Text = "";
        if (e.CommandName == "Reject")
        {
            value = Util.GetString(e.CommandArgument);
            bool Result = StockReports.ExecuteDML("Update Physical_Verification set Approved=2,ApprovedBy='" + Session["ID"].ToString() + "' where EntryNo='" + value + "'");
            if (Result)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblmsg.ClientID + "');", true);
                grdItemDetails.DataSource = null;
                grdItemDetails.DataBind();
                BindPhysicalData();
            }
        }
        if (e.CommandName == "View")
        {
            GetSelectedItems(Util.GetString(e.CommandArgument));
        }
        if (e.CommandName == "Save")
        {
            Save(Util.GetString(e.CommandArgument));
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            if ((dtAuthority != null && dtAuthority.Rows.Count > 0))
            {
                if (dtAuthority.Rows[0]["Physical_Verification"].ToString() == "0")
                {
                    string Msg = "You Are Not Authorized ";
                    Response.Redirect("~/Design/Common/PatientBillMsg.aspx?msg=" + Msg);
                }
            }
            else
            {
                string Msg = "You Are Not Authorized ";
                Response.Redirect("~/Design/Common/PatientBillMsg.aspx?msg=" + Msg);
            }
            BindStore();
            BindPhysicalData();
        }
    }

    protected void Save(string EntryNo)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            //Medical Store
            if (rdbStoreType.SelectedValue.ToUpper() == "STO00001")
            {
                //Stock Update Medica Store
                DataTable dtItemDetail = StockReports.GetDataTable("SELECT pv.ID phyid,pv.UnitPrice,pv.PurTaxPer,pv.Date As EntryDate,pv.StockID,pv.GrossAmount Amount,pv.NetAmount,pv.ItemID,pv.ItemName,pv.BatchNumber BatchNo,pv.InitialCount Quantity,pv.TypeOfTnx,pv.StoreLedgerNo,pv.Rate,pv.MRP,pv.MedExpiryDate ExpiryDate ,pv.SubCategoryID,Narration,pv.SaleTaxPer, CONCAT(pv.PurTaxType,' ',pv.PurTaxPer)PurTax,'' Disc,'HS' TYPE,pv.DeptLedgerNo,pv.LedgerNo,UnitType FROM Physical_Verification pv where pv.EntryNo='" + EntryNo + "' and pv.Approved=0 and pv.StoreLedgerNo='STO00001' and pv.TypeOfTnx='StockUpdate'");
                if (dtItemDetail.Rows.Count > 0)
                {
                    string LedgerTran = SaveStockAdjustment(dtItemDetail, Session["HOSPID"].ToString(), Session["ID"].ToString(), dtItemDetail.Rows[0]["TypeOfTnx"].ToString(), dtItemDetail.Rows[0]["LedgerNo"].ToString(), Session["ID"].ToString(), dtItemDetail.Rows[0]["DeptLedgerNo"].ToString(), dtItemDetail.Rows[0]["StoreLedgerNo"].ToString(), "", con, objTran);
                    if (LedgerTran == "")
                    {
                        objTran.Rollback();
                        objTran.Dispose();
                        con.Close();
                        con.Dispose();
                        lblmsg.Text = "Record Not Saved";
                        return;
                    }
                    UpdateApproval_Flag(EntryNo, "StockUpdate", con, objTran);
                }
                //Stock Process Medica Store
                DataTable dtItemDetail_Process = StockReports.GetDataTable("SELECT pv.UnitPrice,pv.PurTaxPer,pv.Date As EntryDate,pv.StockID,pv.GrossAmount Amount,pv.NetAmount,pv.ItemID,pv.ItemName,pv.BatchNumber BatchNo,pv.InitialCount Quantity,pv.TypeOfTnx,pv.StoreLedgerNo,pv.Rate,pv.MRP,pv.MedExpiryDate MedExpiryDate,'1' IsExpirable ,pv.SubCategoryID,Narration, pv.SaleTaxPer, CONCAT(pv.PurTaxType,' ',pv.PurTaxPer)PurTax,'' Disc,'HS' TYPE,pv.DeptLedgerNo,pv.LedgerNo,UnitType FROM Physical_Verification pv where pv.EntryNo='" + EntryNo + "' and pv.Approved=0 and pv.StoreLedgerNo='STO00001' and pv.TypeOfTnx='StockAdjustment' AND IFNULL(pv.StockID,'')<>'' ");
                {
                    if (dtItemDetail_Process.Rows.Count > 0)
                    {
                        bool ChkQty = CheckProcessQty(EntryNo, "StockAdjustment", "STO00001");
                        if (!ChkQty)
                        {
                            objTran.Rollback();
                            objTran.Dispose();
                            con.Close();
                            con.Dispose();
                            return;
                        }
                        string Saved = SaveAdjustmentStock(dtItemDetail_Process, "", Session["ID"].ToString(), "StockAdjustment", dtItemDetail_Process.Rows[0]["LedgerNo"].ToString(), Session["ID"].ToString(), dtItemDetail_Process.Rows[0]["Narration"].ToString(), dtItemDetail_Process.Rows[0]["DeptLedgerNo"].ToString(), dtItemDetail_Process.Rows[0]["StoreLedgerNo"].ToString(), dtItemDetail_Process.Rows[0]["StoreLedgerNo"].ToString(), con, objTran);
                        if (Saved == string.Empty)
                        {
                            objTran.Rollback();
                            objTran.Dispose();
                            con.Close();
                            con.Dispose();
                            lblmsg.Text = "Record Not Saved";
                            return;
                        }
                        UpdateApproval_Flag(EntryNo, "StockAdjustment", con, objTran);
                    }
                }
            }
            //General Store
            if (rdbStoreType.SelectedValue.ToUpper() == "STO00002")
            {
                // lblmsg.Text = "Not For General Items";
                //Stock Update Non Medical
                DataTable dtItemDetail = StockReports.GetDataTable("SELECT pv.ID phyid,pv.UnitPrice,pv.PurTaxPer,pv.Date As EntryDate,pv.StockID,pv.GrossAmount Amount,pv.NetAmount,pv.ItemID,pv.ItemName,pv.BatchNumber BatchNo,pv.InitialCount Quantity,pv.TypeOfTnx,pv.StoreLedgerNo,pv.Rate,pv.MRP,pv.MedExpiryDate ExpiryDate ,pv.SubCategoryID,Narration,pv.SaleTaxPer, CONCAT(pv.PurTaxType,' ',pv.PurTaxPer)PurTax,'' Disc,'HS' TYPE,pv.DeptLedgerNo,pv.LedgerNo,UnitType FROM Physical_Verification pv where pv.EntryNo='" + EntryNo + "' and pv.Approved=0 and pv.StoreLedgerNo='STO00002' and pv.TypeOfTnx='StockUpdate'");
                if (dtItemDetail.Rows.Count > 0)
                {
                    string LedgerTran = SaveStockAdjustment(dtItemDetail, Session["HOSPID"].ToString(), Session["ID"].ToString(), dtItemDetail.Rows[0]["TypeOfTnx"].ToString(), dtItemDetail.Rows[0]["LedgerNo"].ToString(), Session["ID"].ToString(), dtItemDetail.Rows[0]["DeptLedgerNo"].ToString(), "STO00002", "", con, objTran);
                    if (LedgerTran == "")
                    {
                        objTran.Rollback();
                        objTran.Dispose();
                        con.Close();
                        con.Dispose();
                        lblmsg.Text = "Record Not Saved";
                        return;
                    }
                    UpdateApproval_Flag(EntryNo, "StockUpdate", con, objTran);
                }
                // Stock Process Non Medical
                DataTable dtItemDetail_Process = StockReports.GetDataTable("SELECT pv.UnitPrice,pv.PurTaxPer,pv.Date As EntryDate,pv.StockID,pv.GrossAmount Amount,pv.NetAmount,pv.ItemID,pv.ItemName,pv.BatchNumber BatchNo,pv.InitialCount Quantity,pv.TypeOfTnx,pv.StoreLedgerNo,pv.Rate,pv.MRP,pv.MedExpiryDate MedExpiryDate,'1' IsExpirable ,pv.SubCategoryID,Narration, pv.SaleTaxPer, CONCAT(pv.PurTaxType,' ',pv.PurTaxPer)PurTax,'' Disc,'HS' TYPE,pv.DeptLedgerNo,pv.LedgerNo,UnitType FROM Physical_Verification pv where pv.EntryNo='" + EntryNo + "' and pv.Approved=0 and pv.StoreLedgerNo='STO00002' and pv.TypeOfTnx='StockAdjustment' AND IFNULL(pv.StockID,'')<>'' ");
                {
                    if (dtItemDetail_Process.Rows.Count > 0)
                    {
                        bool ChkQty = CheckProcessQty(EntryNo, "StockAdjustment", "STO00002");
                        if (!ChkQty)
                        {
                            objTran.Rollback();
                            objTran.Dispose();
                            con.Close();
                            con.Dispose();
                            return;
                        }
                        string Saved = SaveAdjustmentStock(dtItemDetail_Process, "", Session["ID"].ToString(), "StockAdjustment", dtItemDetail_Process.Rows[0]["LedgerNo"].ToString(), Session["ID"].ToString(), dtItemDetail_Process.Rows[0]["Narration"].ToString(), dtItemDetail_Process.Rows[0]["DeptLedgerNo"].ToString(), dtItemDetail_Process.Rows[0]["StoreLedgerNo"].ToString(), "STO00002", con, objTran);
                        if (Saved == string.Empty)
                        {
                            objTran.Rollback();
                            objTran.Dispose();
                            con.Close();
                            con.Dispose();
                            lblmsg.Text = "Record Not Saved";
                            return;
                        }
                        UpdateApproval_Flag(EntryNo, "StockAdjustment", con, objTran);
                    }
                }
            }
            objTran.Commit();

            BindPhysicalData();
            grdItemDetails.DataSource = null;
            grdItemDetails.DataBind();
            lblmsg.Text = "Record Saved Successfully";
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            objTran.Rollback();
        }
        finally
        {
            objTran.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void UpdateApproval_Flag(string EntryNo, string Type, MySqlConnection con, MySqlTransaction Tnx)
    {
        int Result = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE Physical_Verification SET Approved=1,ApprovedBy='" + Session["ID"].ToString() + "' WHERE EntryNo='" + EntryNo + "' AND TypeOfTnx='" + Type + "' AND Approved<>2 ");
        if (Result == 0)
        {
            Tnx.Rollback();
            Tnx.Dispose();
            con.Close();
            con.Dispose();
            lblmsg.Text = "Record Not Saved";
        }
    }

    protected void BindPhysicalData()
    {
        string Query = "SELECT pv.EntryNo,(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=pv.StoreLedgerNo)GroupName,"
            + " (SELECT CONCAT(title,' ',NAME) FROM employee_master WHERE EmployeeID=pv.EntryBy)EntryBy,"
            + " DATE_FORMAT(pv.Date,'%d-%b-%Y')EntryDate,cm.CentreName CenterName,rm.RoleName FROM physical_verification pv INNER JOIN f_rolemaster rm ON rm.DeptLedgerNo=pv.DeptLedgerNo INNER JOIN center_master cm ON cm.CentreID=pv.CentreID  "
            + " where pv.Approved=0 and StoreLedgerNo='" + rdbStoreType.SelectedItem.Value + "' AND pv.CentreID=" + Session["CentreID"].ToString() + " GROUP BY pv.EntryNo";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(Query);
        if (dt != null && dt.Rows.Count > 0)
        {
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
        else
        {
            GridView1.DataSource = null;
            GridView1.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

    private void BindStore()
    {
        string str = "SELECT upper(LedgerName)LedgerName,LedgerNumber from f_ledgermaster Where GroupID='STO'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            rdbStoreType.DataSource = dt;
            rdbStoreType.DataTextField = "LedgerName";
            rdbStoreType.DataValueField = "LedgerNumber";
            rdbStoreType.DataBind();
            rdbStoreType.SelectedIndex = 0;
        }
    }
    protected void rdbStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindPhysicalData();
    }
    public string SaveAdjustmentStock(DataTable dt, string HospID, string UserID, string TranType, string LedgerNumber, string ApprovedBy, string Narration, string DeptLedgerNo, string DepartmentID, string StorLedgerNo, MySqlConnection con, MySqlTransaction tranX)
    {
        string SalesID = string.Empty;
        try
        {
            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "select Get_SalesNo('8','" + StorLedgerNo + "','" + Session["CentreID"].ToString() + "') "));
            if (SalesNo == 0)
            {
                lblmsg.Text = "Please Generate Store Sales No.";
                return string.Empty;
            }
            for (int i = 0; i < dt.Rows.Count; i++)
            {

                decimal TaxablePurVATAmt = Util.GetDecimal(dt.Rows[i]["UnitPrice"]) * Util.GetDecimal(dt.Rows[i]["Quantity"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["PurTaxPer"])));
                decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dt.Rows[i]["PurTaxPer"]) / 100;

                decimal TaxableSaleVATAmt = Util.GetDecimal(dt.Rows[i]["MRP"]) * Util.GetDecimal(dt.Rows[i]["Quantity"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["SaleTaxPer"])));
                decimal vatSaleamt = TaxableSaleVATAmt * Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]) / 100;
                //---------------- Insert into Sales Details Table-----------

                Sales_Details ObjSales = new Sales_Details(tranX);
                ObjSales.Hospital_ID = HospID;
                ObjSales.LedgerNumber = LedgerNumber;
                ObjSales.LedgerTransactionNo = "0";
                ObjSales.DepartmentID = DepartmentID;
                ObjSales.StockID = Util.GetString(dt.Rows[i]["StockID"]);
                ObjSales.SoldUnits = Util.GetDecimal(dt.Rows[i]["Quantity"]);
                ObjSales.PerUnitBuyPrice = Util.GetDecimal(dt.Rows[i]["UnitPrice"]);
                ObjSales.PerUnitSellingPrice = Util.GetDecimal(dt.Rows[i]["MRP"]);
                ObjSales.Date = Util.GetDateTime(dt.Rows[i]["EntryDate"]);
                ObjSales.Time = DateTime.Now;
                ObjSales.IsReturn = 0;
                ObjSales.TrasactionTypeID = 8;
                ObjSales.ItemID = Util.GetString(dt.Rows[i]["ItemID"]);
                ObjSales.Naration = Narration;
                ObjSales.SalesNo = SalesNo;
                ObjSales.DeptLedgerNo = DeptLedgerNo;
                ObjSales.UserID = UserID;
                ObjSales.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjSales.IpAddress = All_LoadData.IpAddress();
                ObjSales.LedgerTnxNo = 0;
                ObjSales.medExpiryDate = Util.GetDateTime(dt.Rows[i]["MedExpiryDate"]);
                ObjSales.PurTaxPer = Util.GetDecimal(dt.Rows[i]["PurTaxPer"]);
                ObjSales.PurTaxAmt = vatPuramt;
                ObjSales.TaxPercent = Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]);
                ObjSales.TaxAmt = vatSaleamt;
                ObjSales.HSNCode = "";
                ObjSales.IGSTPercent = 0;
                ObjSales.IGSTAmt = 0;
                ObjSales.CGSTPercent = 0;
                ObjSales.CGSTAmt = 0;
                ObjSales.SGSTPercent = 0;
                ObjSales.SGSTAmt = 0;
                ObjSales.GSTType = "";
                SalesID = ObjSales.Insert();
                if (SalesID.Length == 0)
                {
                    return string.Empty;
                }
                string strStock = "update f_stock set ReleasedCount = ReleasedCount +" + Util.GetDecimal(dt.Rows[i]["Quantity"]) + " where StockID = '" + Util.GetString(dt.Rows[i]["StockID"]) + "' and ReleasedCount + " + Util.GetDecimal(dt.Rows[i]["Quantity"]) + "<=InitialCount";
                if (MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, strStock) == 0)
                {
                    return string.Empty;
                }
            }
            return Util.GetString(SalesNo);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
    }
    protected void grdItemDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblApproved")).Text == "1")
            {
                ((ImageButton)e.Row.FindControl("imbReject")).Style.Add("display", "none");
                e.Row.BackColor = System.Drawing.Color.YellowGreen;
            }
            else if (((Label)e.Row.FindControl("lblApproved")).Text == "2")
            {
                ((ImageButton)e.Row.FindControl("imbReject")).Style.Add("display", "none");
                e.Row.BackColor = System.Drawing.Color.LightPink;
            }
            else
                e.Row.BackColor = System.Drawing.Color.Yellow;
        }
    }
    public string SaveStockAdjustment(DataTable dt, string HospID, string UserID, string TranType, string LedgerNumber, string approvedBy, string DeptLedgerNo, string StoreLedgerNo, string taxCalculateOn, MySqlConnection con, MySqlTransaction tranX)
    {
        string StockID = "";
        DateTime stockdate = Util.GetDateTime(dt.Rows[0]["EntryDate"].ToString());

        string ReferenceNo = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT get_Tran_idPh('Stock Adjustment','" + Util.GetString(DeptLedgerNo) + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ")"));
        if (ReferenceNo == string.Empty)
        {
            return "";
        }
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            string ItemID = dt.Rows[i]["ItemID"].ToString();
            string SubCatID = dt.Rows[i]["SubCategoryID"].ToString();
            string Quantity = dt.Rows[i]["Quantity"].ToString();
            string ItemName = dt.Rows[i]["ItemName"].ToString();
            decimal disAmt = 0;
            decimal perUnitPrice = 0;


            perUnitPrice = Math.Round(Util.GetDecimal(dt.Rows[i]["unitPrice"]), 2, MidpointRounding.AwayFromZero);

            decimal TaxablePurVATAmt = Util.GetDecimal(dt.Rows[i]["UnitPrice"]) * Util.GetDecimal(dt.Rows[i]["Quantity"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["PurTaxPer"])));
            decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dt.Rows[i]["PurTaxPer"]) / 100;

            decimal TaxableSaleVATAmt = Util.GetDecimal(dt.Rows[i]["MRP"]) * Util.GetDecimal(dt.Rows[i]["Quantity"]) * (100 / (100 + Util.GetDecimal(dt.Rows[i]["SaleTaxPer"])));
            decimal vatSaleamt = TaxableSaleVATAmt * Util.GetDecimal(dt.Rows[i]["SaleTaxPer"]) / 100;

            Stock objStock = new Stock(tranX);
            string postime = DateTime.Now.ToString("HH:mm:ss");
            objStock.Hospital_ID = Session["HOSPID"].ToString();
            objStock.ItemID = ItemID;
            objStock.ItemName = ItemName;
            objStock.LedgerTransactionNo = Util.GetString("0");
            objStock.BatchNumber = Util.GetString(dt.Rows[i]["BatchNo"].ToString());
            objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(perUnitPrice));
            objStock.MRP = Util.GetDecimal(dt.Rows[i]["MRP"].ToString());
            objStock.IsCountable = Util.GetInt("1");
            objStock.InitialCount = Util.GetDecimal(Quantity);
            objStock.ReleasedCount = Util.GetDecimal(0);
            objStock.IsReturn = Util.GetInt(2);
            objStock.LedgerNo = "";
            objStock.StoreLedgerNo = StoreLedgerNo;
            objStock.MedExpiryDate = Util.GetDateTime(Util.GetDateTime(dt.Rows[i]["ExpiryDate"]).ToString("yyyy-MM-dd"));
            objStock.StockDate = stockdate;
            objStock.IsPost = 1;
            objStock.PostUserID = UserID;
            objStock.DeptLedgerNo = DeptLedgerNo;
            objStock.Naration = Util.GetString(dt.Rows[i]["Narration"].ToString());
            objStock.SubCategoryID = SubCatID;
            objStock.PostDate = Util.GetDateTime(stockdate.ToString("yyyy-mm-dd HH:mm:ss"));
            objStock.Unit = Util.GetString(dt.Rows[i]["UnitType"].ToString());
            objStock.IsBilled = 1;
            objStock.Reusable = 0;
            objStock.Rate = Util.GetDecimal(dt.Rows[i]["Rate"].ToString());
            objStock.DiscPer = 0;
            objStock.SaleTaxPer = Util.GetDecimal(dt.Rows[i]["SaleTaxPer"].ToString());
            objStock.SaleTaxAmt = vatSaleamt;
            objStock.PurTaxPer = Util.GetDecimal(dt.Rows[i]["PurTaxPer"].ToString());
            objStock.PurTaxAmt = vatPuramt;
            objStock.TYPE = "HS";
            objStock.DiscAmt = 0;
            objStock.UserID = UserID;
            objStock.ConversionFactor = 1;
            objStock.MajorUnit = Util.GetString("NOS");
            objStock.MinorUnit = Util.GetString("NOS");
            objStock.MajorMRP = Util.GetDecimal(dt.Rows[i]["MRP"]);
            objStock.taxCalculateOn = Util.GetString(taxCalculateOn);
            objStock.IpAddress = All_LoadData.IpAddress();
            // For GST
            objStock.HSNCode = "";
            objStock.GSTType = "";
            objStock.IGSTPercent = 0;
            objStock.IGSTAmtPerUnit = 0;
            objStock.CGSTPercent = 0;
            objStock.CGSTAmtPerUnit = 0;
            objStock.SGSTPercent = 0;
            objStock.SGSTAmtPerUnit = 0;
            //
            objStock.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            if (Util.GetDateTime(dt.Rows[i]["ExpiryDate"]).ToString("yyyy-MM-dd") == "0001-01-01")
                objStock.IsExpirable = 0;
            else
                objStock.IsExpirable = 1;

            if (StoreLedgerNo == "STO00001")
                objStock.TypeOfTnx = "StockUpdate";
            else
                objStock.TypeOfTnx = "NONMEDICALADJUSTMENT";

            objStock.ReferenceNo = ReferenceNo;

            try
            {
                StockID = objStock.Insert().ToString();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "";
            }

            if (StockID.Length == 0)
            {
                return "";
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE Physical_Verification SET StockID='" + StockID + "' WHERE ID=" + dt.Rows[i]["phyid"].ToString() + "");
            }
        }
        return ReferenceNo;
    }
}