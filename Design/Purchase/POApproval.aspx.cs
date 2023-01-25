using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Text;

public partial class Design_Purchase_POApproval : System.Web.UI.Page
{
    #region Event Handling
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["ID"] != null)
            {
                string EmpID = Convert.ToString(Session["ID"]);
                ViewState["EmployeeID"] = EmpID;
                int canApprove = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_purchase_approval WHERE Employee_ID='" + EmpID + "' AND ApprovalFor='PO' AND Approval='1'"));
                if (canApprove > 0)
                {
                    if (ChkRights())
                    {
                        string Msg = "You do not have rights to Approve purchase Order ";
                        Response.Redirect("MsgPage.aspx?msg=" + Msg);
                    }
                    rdbApprove.Items[0].Enabled = true;
                    rdbApprove.Items[1].Selected = false;
                    BindPO(ViewState["StoreLedgerNo"].ToString());
                }
                else
                {
                    rdbApprove.Enabled = false;
                    rdbApprove.Items[0].Selected = false;
                    rdbApprove.Items[1].Selected = false;
                    lblMsg.Text = "You Are Not Authorized to Approve/Reject Purchase Order";
                }

            }
        }
    }

    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();
        ViewState["StoreLedgerNo"] = "";

        DataTable dt1 = StockReports.GetPurchaseApproval("PO", EmpId);
        if (dt1 != null && dt1.Rows.Count > 0)
        {
            DataTable dt = StockReports.GetRights(RoleId);
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "true")
                {
                    ViewState["StoreLedgerNo"] = "'STO00001','STO00002'";
                }
                else if (dt.Rows[0]["IsMedical"].ToString() == "true" || dt.Rows[0]["IsGeneral"].ToString() == "true")
                {
                    if (dt.Rows[0]["IsMedical"].ToString() == "true")
                    {
                        ViewState["StoreLedgerNo"] = "'STO00001'";
                    }
                    else if (dt.Rows[0]["IsGeneral"].ToString() == "true")
                    {
                        ViewState["StoreLedgerNo"] = "'STO00002'";
                    }
                }
                else if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "false")
                {
                    string Msg = "You do not have rights to Approve purchase Order ";
                    Response.Redirect("MsgPage.aspx?msg=" + Msg);
                }
                return false;
            }
            else { return true; }
        }
        else { return true; }
    }

    protected void chkUnchek_CheckedChanged(object sender, EventArgs e)
    {
        if (GridView1.Rows.Count > 0)
        {
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                ((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked = chkUnchek.Checked;
            }
        }
    }
    protected void btnItem_Click(object sender, EventArgs e)
    {
        string PONO = GetPONO();
        string VendorId = VendorNo();
        ViewState["VendorID"] = VendorId;
        if (PONO != string.Empty)
            GetSelectedItems(PONO);
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM269','" + lblMsg.ClientID + "');", true);
        }

    }
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "Reject")
        {
            int Index = 0;
            Index = Util.GetInt(e.CommandArgument);
            lblPoNo1.Text = ((Label)GridView1.Rows[Index].FindControl("lblPONumber")).Text;
            mpCancel.Show();
        }

        if (e.CommandName == "AEdit")
        {
            string PurchaseOrderNo = e.CommandArgument.ToString().Split('#')[0];
            string Narration = e.CommandArgument.ToString().Split('#')[1];
            string Freight = e.CommandArgument.ToString().Split('#')[2];
            string Roundoff = e.CommandArgument.ToString().Split('#')[3];
            string Scheme = e.CommandArgument.ToString().Split('#')[4];
            string ExciseOnBill = e.CommandArgument.ToString().Split('#')[5];

            lblNarPONo.Text = PurchaseOrderNo;
            txtNarration.Text = Narration;
            txtFreight.Text = Freight;
            txtRoundOff.Text = Roundoff;
            txtScheme.Text = Scheme;
            txtExciseOnBill.Text = ExciseOnBill;

            mpNarration.Show();
        }

    }

    protected void grdItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            int index = 0;
            index = Util.GetInt(e.CommandArgument);
            string PODetailID = ((Label)grdItem.Rows[index].FindControl("lblPODetailID")).Text;

            StringBuilder sb = new StringBuilder();
            sb.Append("select PurchaseOrderDetailID,PurchaseOrderNo,ItemName,ItemID,OrderedQty,ApprovedQty,Discount_p,Specification,Rate, ");

            //GST Changes
            sb.Append(" IFNULL(IGSTPercent+CGSTPercent+SGSTPercent,0)GSTPer,IGSTPercent,CGSTPercent,SGSTPercent,IFNULL(GSTType,'')GSTType,IFNULL(HSNCode,'')HSNCode,IGSTAmt,CGSTAmt,SGSTAmt,IFNULL(IGSTAmt+CGSTAmt+SGSTAmt,0)GSTAmt, ");
            //Deal Work
            sb.Append(" ifnull(ExcisePer,0)ExcisePer,ifnull(ExciseAmt,0)ExciseAmt,TaxCalulatedOn,IFNULL(IsDeal,'')IsDeal from f_purchaseorderdetails where");
            sb.Append(" PurchaseOrderDetailID=" + PODetailID + "");
            DataTable dtItem = StockReports.GetDataTable(sb.ToString());
            if (dtItem != null && dtItem.Rows.Count > 0)
            {
                lblItemName.Text = Util.GetString(dtItem.Rows[0]["ItemName"]);
                lblSpecification.Text = Util.GetString(dtItem.Rows[0]["Specification"]);
                lblOrderQty.Text = Util.GetString(dtItem.Rows[0]["OrderedQty"]);
                lblPONO.Text = Util.GetString(dtItem.Rows[0]["PurchaseOrderNo"]);
                txtApproveQty.Text = Util.GetString(dtItem.Rows[0]["ApprovedQty"]);
                txtPrice.Text = Util.GetString(dtItem.Rows[0]["Rate"]);
                txtDiscount.Text = Util.GetString(dtItem.Rows[0]["Discount_p"]);
                lblItemID.Text = Util.GetString(dtItem.Rows[0]["ItemID"]);
                lblPODetailID.Text = Util.GetString(dtItem.Rows[0]["PurchaseOrderDetailID"]);
                lblTaxCalulatedOn.Text = Util.GetString(dtItem.Rows[0]["TaxCalulatedOn"]);

                // GST Changes
                lblGSTType.Text = Util.GetString(dtItem.Rows[0]["GSTType"]);
                lblHSNCode.Text = Util.GetString(dtItem.Rows[0]["HSNCode"]);
                lblIGSTPer.Text = Util.GetString(dtItem.Rows[0]["IGSTPercent"]);
                lblCGSTPer.Text = Util.GetString(dtItem.Rows[0]["CGSTPercent"]);
                lblSGSTPer.Text = Util.GetString(dtItem.Rows[0]["SGSTPercent"]);

                //Deal Work
                lblDeal.Text = Util.GetString(dtItem.Rows[0]["IsDeal"]);
                //

            }
            mpeCreateGroup.Show();
        }

        if (e.CommandName == "Reject")
        {
            int IndexItem = 0;
            IndexItem = Util.GetInt(e.CommandArgument);
            lblPoNo2.Text = ((Label)grdItem.Rows[IndexItem].FindControl("lblPONo")).Text;
            lblItemName1.Text = ((Label)grdItem.Rows[IndexItem].FindControl("lblItem")).Text;
            lblCancelItemID.Text = ((Label)grdItem.Rows[IndexItem].FindControl("lblItemID")).Text;
            lblPODetailID1.Text = ((Label)grdItem.Rows[IndexItem].FindControl("lblPODetailID")).Text;
            mapItemCancel.Show();
        }



    }
    protected void btnupdate_Click(object sender, EventArgs e)
    {
        decimal ApproveQty = 0, orderQty = 0, status = 0, VATPerFunc = 0, ExcisePerFunc = 0;
        ApproveQty = Util.GetDecimal(txtApproveQty.Text.Trim());
        orderQty = Util.GetDecimal(lblOrderQty.Text.Trim());

        //if (ApproveQty > orderQty)
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM027','" + lblMsg.ClientID + "');", true);
        //    return;
        //}
        if (ApproveQty == orderQty)
        {
            status = 1;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        int Result = 0, Result1 = 0, resultbkup = 0;
        decimal disc;
        //  decimal Taxes = 0;
        decimal rate = Util.GetDecimal(txtPrice.Text);
        disc = (rate * Util.GetDecimal(txtDiscount.Text)) / 100;
        //  rate = rate - disc;
        rate = Math.Round(rate, 2, MidpointRounding.AwayFromZero);
        decimal Amount = Math.Round((rate * Util.GetDecimal(txtApproveQty.Text)), 2, MidpointRounding.AwayFromZero);
        //Deal Work
        string strbckup = " INSERT INTO f_purchaseorderdetails_bckup (`PurchaseOrderDetailID`,`PurchaseOrderNo`,`ItemID`,`ItemName`,`SubCategoryID`,`OrderedQty`,`ApprovedQty`,`RecievedQty`,`QoutationNo`,`Rate`,`Discount_a`,`Discount_p`,`BuyPrice`,`Amount`,`MRP`,`Status`,`Approved`,`IsFree`,`Specification`,`Unit`,`StoreLedgerNo`,`LastUpdatedBy`,`Updatedate`,`IpAddress`,`CancelReason`,`CancelUserID`,`CancelUserName`,`CancelDate`,`DeptLedgerNo`,`PurchaseRequestNo`,`VATPer`,`VATAmt`,`ExcisePer`,`ExciseAmt`,tg_userId,TaxCalulatedOn,GSTType,HSNCode,IGSTPercent,IGSTAmt,CGSTPercent,CGSTAmt,SGSTPercent,SGSTAmt,IsDeal) " +
                               " SELECT `PurchaseOrderDetailID`,`PurchaseOrderNo`,`ItemID`,`ItemName`,`SubCategoryID`,`OrderedQty`,`ApprovedQty`,`RecievedQty`,`QoutationNo`,`Rate`,`Discount_a`,`Discount_p`,`BuyPrice`,`Amount`,`MRP`,`Status`,`Approved`,`IsFree`,`Specification`,`Unit`,`StoreLedgerNo`,`LastUpdatedBy`,`Updatedate`,`IpAddress`,`CancelReason`,`CancelUserID`,`CancelUserName`,`CancelDate`,`DeptLedgerNo`,`PurchaseRequestNo`,`VATPer`,`VATAmt`,`ExcisePer`,`ExciseAmt`,'" + Session["ID"].ToString() + "',TaxCalulatedOn,GSTType,HSNCode,IGSTPercent,IGSTAmt,CGSTPercent,CGSTAmt,SGSTPercent,SGSTAmt,IsDeal FROM f_purchaseorderdetails WHERE PurchaseOrderDetailID=" + lblPODetailID.Text.Trim() + " AND PurchaseOrderNo='" + lblPONO.Text.Trim() + "' ";
        //
        resultbkup = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strbckup);

        string Amt = "";
        decimal perUnitPrice = 0, NetAmount = 0, vatamtfun = 0, exciseamtfun = 0;
        decimal IGSTAmt = 0, CGSTAmt = 0, SGSTAmt = 0;
        //Deal Work
        decimal rate1 = rate;
		decimal deal1=0;
		decimal deal2=0;
        if (lblDeal.Text.Trim() != string.Empty)
        {
            int deal = Util.GetInt(lblDeal.Text.Trim().Split('+')[0]) + Util.GetInt(lblDeal.Text.Trim().Split('+')[1]);
            rate1 = Util.GetDecimal(Util.GetDouble(Util.GetDecimal(txtApproveQty.Text.Trim()) * Util.GetDecimal(rate)) / Util.GetDouble(deal));
 		    deal1= Util.GetDecimal(lblDeal.Text.Trim().Split('+')[0]);
		    deal2= Util.GetDecimal(lblDeal.Text.Trim().Split('+')[1]);
	    }
        List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
          {          
             new TaxCalculation_DirectGRN {DiscAmt=Util.GetDecimal(0), DiscPer=Util.GetDecimal(txtDiscount.Text), MRP=Util.GetDecimal(0),Quantity = Util.GetDecimal(txtApproveQty.Text),Rate=rate1,TaxPer =Util.GetDecimal(lblIGSTPer.Text) + Util.GetDecimal(lblCGSTPer.Text) + Util.GetDecimal(lblSGSTPer.Text),Type = Util.GetString(lblTaxCalulatedOn.Text.Trim()),IGSTPrecent=Util.GetDecimal(lblIGSTPer.Text.Trim()),CGSTPercent=Util.GetDecimal(lblCGSTPer.Text.Trim()),SGSTPercent=Util.GetDecimal(lblSGSTPer.Text.Trim()),deal =Util.GetDecimal(deal1),deal2= Util.GetDecimal(deal2),ActualRate=Util.GetDecimal(rate)}
           };
        //
        Amt = AllLoadData_Store.taxCalulation(taxCalculate);
    
        perUnitPrice = Util.GetDecimal(Amt.Split('#')[4].ToString());
        NetAmount = Util.GetDecimal(Amt.Split('#')[0].ToString());
        exciseamtfun = Util.GetDecimal(0);
        VATPerFunc = Util.GetDecimal(lblIGSTPer.Text) + Util.GetDecimal(lblSGSTPer.Text) + Util.GetDecimal(lblCGSTPer.Text);
        vatamtfun = Util.GetDecimal(Amt.Split('#')[1].ToString());

        IGSTAmt = Util.GetDecimal(Amt.Split('#')[8].ToString());
        CGSTAmt = Util.GetDecimal(Amt.Split('#')[9].ToString());
        SGSTAmt = Util.GetDecimal(Amt.Split('#')[10].ToString());


        decimal roundOff = Util.GetDecimal(Math.Round((Math.Round(Amount, 0, MidpointRounding.AwayFromZero) - Util.GetDecimal((Math.Round(Amount, 2, MidpointRounding.AwayFromZero)))), 2, MidpointRounding.AwayFromZero));
        string strQuery = "call usp_EditPO1(" + lblPODetailID.Text + ",'" + lblPONO.Text + "'," + txtApproveQty.Text + "," + txtPrice.Text + ",'" + lblItemID.Text + "'," + txtDiscount.Text + "," + perUnitPrice + "," + NetAmount + "," + status + ",'" + lblSpecification.Text.Trim() + "','" + ViewState["EmployeeID"].ToString() + "','" + Request.UserHostAddress + "','" + roundOff.ToString() + "'," + ExcisePerFunc + "," + exciseamtfun + "," + VATPerFunc + "," + vatamtfun + ",'" + Util.GetString(lblHSNCode.Text.Trim()) + "','" + Util.GetDecimal(lblIGSTPer.Text) + "','" + IGSTAmt + "','" + Util.GetDecimal(lblCGSTPer.Text) + "','" + CGSTAmt + "','" + Util.GetDecimal(lblSGSTPer.Text) + "','" + SGSTAmt + "','" + Util.GetString(lblGSTType.Text.Trim()) + "')";
        Result = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
        if (Result >= 0 && Result1 >= 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            GetSelectedItems(GetPONO());
        }
        else
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string PONO = string.Empty;
        string SqlinsTerms = string.Empty;
        string str = string.Empty;
        string EMPID = string.Empty, EMPName = string.Empty;
        bool Result = false;
        EMPID = Convert.ToString(Session["ID"]);
        EMPName = Convert.ToString(Session["UserName"]);
        bool check = false;

        if (rdbApprove.SelectedItem.Value == "Approve")
        {
            if (GridView1.Rows.Count > 0)
            {
                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked == true)
                    {
                        MySqlConnection con = new MySqlConnection();
                        con = Util.GetMySqlCon();
                        con.Open();
                        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
                        //reena
                        try
                        {
                            PONO = "'" + ((Label)GridView1.Rows[i].FindControl("lblPONumber")).Text + "'";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "call POApproval(" + PONO + ",'" + EMPID + "','" + EMPName + "',1,0);");
                            check = true;
                            All_LoadData.updateNotification(((Label)GridView1.Rows[i].FindControl("lblPONumber")).Text, "", Util.GetString(Session["RoleID"].ToString()), 31, null, "Store");
                            if (Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(*) FROM f_purchaseorderterms WHERE Ponumber=" + PONO + " ")) == 0)
                            {
                                str = "SELECT Terms FROM  f_vendor_terms WHERE Vendor_id='" + ((Label)GridView1.Rows[i].FindControl("lblVendorid")).Text + "'";
                                DataTable dtTerms = StockReports.GetDataTable(str);
                                foreach (DataRow row in dtTerms.Rows)
                                {
                                    string terms = row["Terms"].ToString();
                                    SqlinsTerms = "INSERT INTO f_purchaseorderterms(PONumber,Details) VALUES(" + PONO + ",'" + terms + "')";
                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, SqlinsTerms);
                                }
                            }
                            Result = true;
                            Tnx.Commit();
                            con.Close();
                            con.Dispose();
                        }
                        catch (Exception ex)
                        {
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                            Tnx.Rollback();
                            con.Close();
                            con.Dispose();
                        }
                    }
                }
            }
        }
        else
        {
            if (GridView1.Rows.Count > 0)
            {
                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked == true)
                    {
                        PONO = "'" + ((Label)GridView1.Rows[i].FindControl("lblPONumber")).Text + "'";
                        Result = StockReports.ExecuteDML("call usp_RejectPO(" + PONO + ",'" + EMPID + "','" + EMPName + "','');");
                        check = true;
                    }
                }
            }
        }
        if (!check)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "DisplayMsg('MM269','" + lblMsg.ClientID + "');", true);
            return;
        }

        if (Result)
        {
            BindPO(ViewState["StoreLedgerNo"].ToString());
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            grdItem.DataSource = null;
            grdItem.DataBind();
        }
    }
    #endregion

    #region Bind Data
    private void BindPO(string StoreLedgerNo)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT(PO.PurchaseOrderNo),(SELECT Name FROM employee_master WHERE employee_id=PO.RaisedUserID)UserName,");
        sb.Append(" PO.Subject,date_format(PO.RaisedDate,'%d-%b-%y')RaisedDate,PO.VendorName,lm.ledgeruserid,PO.GrossTotal, ");
        sb.Append(" PO.Narration,round(PO.Freight,2)Freight,round(PO.Roundoff,2)Roundoff,round(PO.Scheme,2)Scheme,round(PO.ExciseOnBill,2)ExciseOnBill FROM f_purchaseorder PO ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.`LedgerNumber`= po.`VendorID` ");
        sb.Append(" LEFT JOIN f_purchaseorderapproval POA on PO.PurchaseOrderNo=POA.PONumber ");
        sb.Append(" WHERE PO.Status=0 ");
        sb.Append(" AND PO.StoreLedgerNo IN (" + StoreLedgerNo + ") AND PO.DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "'");

        dt = StockReports.GetDataTable(sb.ToString());

        //if (dt != null && dt.Rows.Count > 0)
        //{

        //    string vendorid = Util.GetString(dt.Rows[0]["ledgeruserid"]);
        //    ViewState["VendorID"] = vendorid;

        //}  

        if (dt != null && dt.Rows.Count > 0)
        {
            GridView1.DataSource = dt;
            GridView1.DataBind();

            chkUnchek.Enabled = true;
            btnItem.Enabled = true;
            btnSave.Enabled = true;

        }
        else
        {
            GridView1.DataSource = null;
            GridView1.DataBind();
            chkUnchek.Enabled = false;
            btnItem.Enabled = false;
            btnSave.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    private void GetSelectedItems(string PONO)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select PurchaseOrderDetailID,PurchaseOrderNo,ItemName,ItemId");
        sb.Append(" ,OrderedQty,ApprovedQty,Rate,if(IsFree = 1,'true','false')IsFree, Specification,Discount_p,CONCAT(ExcisePer,'% /',VATPer,'%') TaxDisplay,'Excise/VAT' TaxName from ");
        sb.Append(" f_purchaseorderdetails where PurchaseOrderNo in(" + PONO + ") and Status=0 ORDER BY PurchaseOrderNo,ItemName");
        DataTable dtitem = new DataTable();
        dtitem = StockReports.GetDataTable(sb.ToString());
        if (dtitem != null && dtitem.Rows.Count > 0)
        {
            grdItem.DataSource = dtitem;
            grdItem.DataBind();
            btnTermsConditions.Visible = true;
            ViewState["PONO"] = PONO;
        }
        else
        {
            grdItem.DataSource = null;
            grdItem.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            btnTermsConditions.Visible = false;
            ViewState["PONO"] = "";
        }
    }
    private DataTable BindTax(string PODetailID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select tm.TaxID,po.TaxPer,po.TaxAmt,CONCAT(po.TaxPer,'%') TaxDisplay,tm.TaxName,po.PODetailID FROM f_taxmaster tm  LEFT JOIN f_purchaseordertax po");
        sb.Append(" on po.TaxID = tm.TaxID and po.PODetailID = '" + PODetailID + "' WHERE tm.TaxID<>'T5' AND po.PODetailID IS NOT NULL");
        sb.Append(" union ");
        sb.Append("select tm.TaxID,po.TaxPer,po.TaxAmt,CONCAT('Rs.',po.TaxAmt) TaxDisplay,tm.TaxName,po.PODetailID FROM f_taxmaster tm  LEFT JOIN f_purchaseorderexcisetax po");
        sb.Append(" on po.TaxID = tm.TaxID and po.PODetailID = '" + PODetailID + "' WHERE tm.TaxID='T5' AND po.PODetailID IS NOT NULL");

        DataTable dtTax = new DataTable();
        dtTax = StockReports.GetDataTable(sb.ToString());

        return dtTax;
    }
    private string GetPONO()
    {
        string PONO = string.Empty;
        if (GridView1.Rows.Count > 0)
        {
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked == true)
                {
                    if (PONO != string.Empty)
                    {
                        PONO += ",'" + ((Label)GridView1.Rows[i].FindControl("lblPONumber")).Text + "'";
                    }
                    else
                    {
                        PONO += "'" + ((Label)GridView1.Rows[i].FindControl("lblPONumber")).Text + "'";
                    }
                }
            }

        }
        return PONO;
    }
    private string VendorNo()
    {
        string vendorId = string.Empty;
        if (GridView1.Rows.Count > 0)
        {
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked == true)
                {
                    if (vendorId != string.Empty)
                    {
                        vendorId += "'" + ((Label)GridView1.Rows[i].FindControl("ledgeruserid")).Text + "'";
                    }
                    else
                    {
                        vendorId += "'" + ((Label)GridView1.Rows[i].FindControl("lblVendorid")).Text + "'";
                    }
                }
            }

        }
        return vendorId;
    }
    #endregion

    protected void btnNarSave_Click(object sender, EventArgs e)
    {
        string str = "";

        str = " UPDATE f_purchaseorder " +
         " SET Narration = '" + txtNarration.Text + "', " +
         " Freight='" + Util.GetDouble(txtFreight.Text) + "', " +
         " Roundoff='" + Util.GetDouble(txtRoundOff.Text) + "', " +
         " Scheme='" + Util.GetDouble(txtScheme.Text) + "', " +
         " ExciseOnBill='" + Util.GetDouble(txtExciseOnBill.Text) + "',LastUpdatedDate=NOW(),LastUpdatedUserID='" + ViewState["EmployeeID"].ToString() + "', " +
         " GrossTotal = (SELECT SUM(Amount) FROM f_purchaseorderdetails WHERE PurchaseOrderNo='" + lblNarPONo.Text + "') " +
         "+" + Util.GetDouble(txtFreight.Text) + "+" + Util.GetDouble(txtRoundOff.Text) + "-" + Util.GetDouble(txtScheme.Text) + "+" + Util.GetDouble(txtExciseOnBill.Text) +
         " WHERE PurchaseOrderNo = '" + lblNarPONo.Text + "'";



        if (StockReports.ExecuteDML(str))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
            BindPO(ViewState["StoreLedgerNo"].ToString());
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
    }
    protected void btnGRNCancel_Click(object sender, EventArgs e)
    {
        try
        {
            string PONO = lblPoNo1.Text.Trim();
            string Reason = txtCancelReason.Text.Trim();
            bool Result = StockReports.ExecuteDML("call usp_RejectPO(" + PONO + ",'" + Convert.ToString(Session["ID"]) + "','" + Convert.ToString(Session["UserName"]) + "','" + Reason + "');");
            if (Result == true)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
                txtCancelReason.Text = "";
                BindPO(ViewState["StoreLedgerNo"].ToString());
                string PNO = GetPONO();
                if (PNO != string.Empty)
                {
                    GetSelectedItems(PNO);
                }
                else
                {
                    grdItem.DataSource = null;
                    grdItem.DataBind();

                }
            }
            else
            {

            }
        }
        catch (Exception ex)
        {
            ClassLog ca = new ClassLog();
            ca.errLog(ex);
        }

    }
    protected void btnRejectItem_Click(object sender, EventArgs e)
    {
        string PONo = lblPoNo2.Text;
        string ItemID = lblCancelItemID.Text;
        string ItemName = lblItemName1.Text;
        string PODetailID = lblPODetailID1.Text;
        string ReasonItem = txtItemReason.Text;

        string strQuery = "call usp_RejectPO_Item('" + PONo + "','" + ItemID + "','" + Convert.ToString(Session["ID"]) + "','" + Convert.ToString(Session["UserName"]) + "','" + PODetailID + "','" + ReasonItem + "')";

        bool Result1 = StockReports.ExecuteDML(strQuery.ToString());
        if (Result1 == true)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
            BindPO(ViewState["StoreLedgerNo"].ToString());
            string PNO = GetPONO();
            if (PNO != string.Empty)
                GetSelectedItems(PNO);
            else
            {
                grdItem.DataSource = null;
                grdItem.DataBind();
            }
        }
        string ChkItem = "Select * from f_purchaseorderdetails where  PurchaseOrderNo='" + PONo + "' and STATUS<>2";
        DataTable dtitemDetail = StockReports.GetDataTable(ChkItem);
        if (dtitemDetail.Rows.Count == 0)
        {
            bool Result2 = StockReports.ExecuteDML("call usp_RejectPO('" + PONo + "','" + Convert.ToString(Session["ID"]) + "','" + Convert.ToString(Session["UserName"]) + "','" + ReasonItem + "');");
            if (Result2 == true)
            {

                BindPO(ViewState["StoreLedgerNo"].ToString());
                string PNO = GetPONO();
                if (PNO != string.Empty)
                    GetSelectedItems(PNO);
                else
                {
                    grdItem.DataSource = null;
                    grdItem.DataBind();
                }
            }
        }
        txtItemReason.Text = "";

    }
    protected void btnTermsConditions_Click(object sender, EventArgs e)
    {
        DataTable dtTerms;
        string PONO = "";


        if (ViewState["PONO"] != null || ViewState["PONO"].ToString() != "")
            PONO = ViewState["PONO"].ToString();


        if (PONO != "")
        {
            if (PONO.Split(',').Length > 1)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM028','" + lblMsg.ClientID + "');", true);
                btnTermsConditions.Visible = false;
                return;
            }
        }

        string strTerms = "select Details Terms,PONumber from f_purchaseorderterms where PONumber =" + PONO + "";
        dtTerms = StockReports.GetDataTable(strTerms);
        if (dtTerms.Rows.Count < 0)
        {
            gvTerms.DataSource = dtTerms;
            gvTerms.DataBind();

            ViewState["dtTerms"] = dtTerms;
        }
        else
        {
            StringBuilder str = new StringBuilder();
            str.Append("  SELECT  t.* FROM (SELECT 'true' IsCheck, pot.Details Terms,'" + PONO.Replace("'", "") + "' PONumber FROM f_purchaseorderterms ");
            str.Append("  pot WHERE pot.PONumber='" + PONO.Replace("'", "") + "' ");
            str.Append("  UNION ALL ");
            str.Append("  SELECT 'false' IsCheck,ftc.Terms,'" + PONO.Replace("'", "") + "' PONumber ");
            str.Append("  FROM f_term_condition ftc ");
            str.Append("  LEFT JOIN f_vendor_terms fvt ON fvt.`Terms_Id`=ftc.`Id` WHERE fvt.Vendor_Id=" + ViewState["VendorID"].ToString() + " ");
            str.Append("  )t GROUP BY PONumber,Terms ORDER BY Terms ");

            // string str = "SELECT ftc.Id,ftc.Terms,'" + PONO.Replace("'", "") + "' PONumber  FROM f_vendor_terms ftc LEFT JOIN f_vendor_terms fvt ON fvt.`Terms_Id`=ftc.`Id` where fvt.Vendor_Id='" + ViewState["VendorID"].ToString() + "' order by ftc.Terms";
            DataTable dt = StockReports.GetDataTable(str.ToString());
            if (dt.Rows.Count > 0)
            {
                gvTerms.DataSource = dt;
                gvTerms.DataBind();
                ViewState["dtTerms"] = dt;
            }
            else
            {
                gvTerms.DataSource = null;
                gvTerms.DataBind();
                ViewState["dtTerms"] = dt;

            }
        }

        lblPONo_Terms.Text = PONO.Replace("'", "");
        mpeCondtions.Show();
    }
    protected void btnAddTerms_Click(object sender, EventArgs e)
    {
        DataTable dtTerms;

        if (ViewState["dtTerms"] != null)
            dtTerms = (DataTable)ViewState["dtTerms"];
        else
        {
            dtTerms = new DataTable();
            dtTerms.Columns.Add("Terms");
        }

        DataRow row = dtTerms.NewRow();
        row["Terms"] = txtConditions.Text.Trim();
        row["PONumber"] = lblPONo_Terms.Text;
        dtTerms.Rows.Add(row);
        gvTerms.DataSource = dtTerms;
        gvTerms.DataBind();
        ViewState["dtTerms"] = dtTerms;
        txtConditions.Text = string.Empty;
        txtConditions.Focus();
    }
    protected void gvTerms_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtTerms = (DataTable)ViewState["dtTerms"];
            dtTerms.Rows[args].Delete();
            dtTerms.AcceptChanges();
            gvTerms.DataSource = dtTerms;
            gvTerms.DataBind();
            ViewState["dtTerms"] = dtTerms;
        }
    }

    protected void btnUpdateCondition_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (ViewState["dtTerms"] != null)
            {
                string PONO = "";
                if (ViewState["PONO"] != null || ViewState["PONO"].ToString() != "")
                    PONO = ViewState["PONO"].ToString();

                string strTerms = "Delete from f_purchaseorderterms Where PONumber in (" + PONO + ")";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strTerms);

                DataTable dtCondition = (DataTable)ViewState["dtTerms"];
                for (int i = 0; i < dtCondition.Rows.Count; i++)
                {
                    PurchaseOrderTerms POM = new PurchaseOrderTerms(Tnx);
                    POM.PONumber = Util.GetString(dtCondition.Rows[i]["PONumber"]);
                    POM.Details = Util.GetString(dtCondition.Rows[i]["Terms"]);
                    POM.InsertTerms();
                }

                Tnx.Commit();
                con.Close();
                con.Dispose();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            Tnx.Rollback();
            con.Close();
            con.Dispose();
        }
    }
}
