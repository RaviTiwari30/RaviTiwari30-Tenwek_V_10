using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Globalization;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.UI.HtmlControls;

public partial class Design_Store_DirectGRNSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtInvoiceNo.Focus();
                ViewState["ID"] = Session["ID"].ToString();
                ViewState["HOSPID"] = Session["HOSPID"].ToString();
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                ViewState["CentreID"] = Session["CentreID"].ToString();

                AllLoadData_Store.bindStore(ddlVendor, "VEN", "All");
                AllLoadData_Store.bindStore(ddlVendorGRN, "VEN", "All");
                ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                Iexpdate.StartDate = DateTime.Now.AddDays(1);
                BindGST();
                btnAddGRNItem.Visible = false;
          
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
        CaltxtucInvoiceDate.EndDate = DateTime.Now;
        CaltxtucChalanDate.EndDate = DateTime.Now;
        txtucInvoiceDate.Attributes.Add("readOnly", "true");
        txtucChalanDate.Attributes.Add("readOnly", "true");

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindConsignmentInfo();
    }
    protected void gvGRN_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvGRN.PageIndex = e.NewPageIndex;
        BindConsignmentInfo();
    }
    protected void gvGRN_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            row = (DataRowView)e.Row.DataItem;
            e.Row.Attributes.Add("onMouseOver", "SetNewColor(this);");
            e.Row.Attributes.Add("onMouseOut", "SetOldColor(this);");
            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            {
                e.Row.Attributes.Add("ondblclick", "ShowPO('" + Util.GetString(row["consignmentNo"]) + "','Hos_GRN');");
            }
            else
            {
                e.Row.Attributes.Add("ondblclick", "ShowPO('" + Util.GetString(row["consignmentNo"]) + "','Proj_GRN');");
            }


            //var isPost=row["Post"].ToString();

            //if (isPost == "true")
            //{
            //    HtmlImage img = (HtmlImage)e.Row.FindControl("imgEdit");
            //    img.Style.Add("display", "none");
            //}
            
            

        }
    }
    protected void gvGRN_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "APost")
        {
            StockReports.ExecuteDML(" UPDATE consignmentdetail SET IsPost=1,PostDate=NOW(),PostUserID='"+ Session["ID"].ToString() +"' WHERE consignmentNo='" + e.CommandArgument + "' and IsCancel<>1 ");
            lblMsg.Text = "Consignment Post";
            gvItems.DataSource = null;
            gvItems.DataBind();
        }
        else if (e.CommandName == "AView")
        {
            string consignmentNo = Util.GetString(e.CommandArgument);
            ViewState["consignmentNo"] = consignmentNo;
            BindConsignmentItems1();
        }
        else if (e.CommandName == "ACancel")
        {
            lblConsignNo.Text = Util.GetString(e.CommandArgument);
            mpCancel.Show();
        }

        else if (e.CommandName == "AEdit")
        {
            string ConsignNo = Util.GetString(e.CommandArgument);

            StringBuilder sb = new StringBuilder();
           sb.Append("  SELECT ");
            sb.Append(" BillNo, ");
            sb.Append("  BillDate, ");
            sb.Append(" ConsignmentNo, ");
            sb.Append(" VendorLedgerNo, ");
            sb.Append(" ChallanNo, ");
            sb.Append(" ChallanDate, ");
            sb.Append(" BillNo, ");
            sb.Append(" DATE_FORMAT(BillDate,'%d-%b-%y')BillDate, ");
            sb.Append(" ItemID, ");
            sb.Append(" ItemName, ");
            sb.Append(" BatchNumber, ");
            sb.Append(" Rate, ");
            sb.Append(" UnitPrice, ");
            sb.Append(" TaxPer, ");
            sb.Append(" TaxID, ");
            sb.Append(" DiscountPer, ");
            sb.Append(" MRP, ");
            sb.Append(" Unit, ");
            sb.Append(" InititalCount, ");
            sb.Append(" DATE_FORMAT(StockDate,'%d-%b-%y')StockDate, ");
            sb.Append(" IsPost, ");
            sb.Append(" IsFree, ");
            sb.Append(" Naration, ");
            sb.Append(" DeptLedgerNo, ");
            sb.Append(" GateEntryNo, ");
            sb.Append(" UserID, ");
            sb.Append(" Freight, ");
            sb.Append(" Octroi, ");
            sb.Append(" RoundOff, ");
            sb.Append(" GRNAmount, ");
            sb.Append("   DATE_FORMAT(MedExpiryDate,'%d-%b-%y')MedExpiryDate ");
            sb.Append(" FROM consignmentdetail ");
            sb.Append(" WHERE ConsignmentNo='" + ConsignNo.Trim() + "' ");
            DataTable dt = new DataTable();

            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                lblGRN.Text = ConsignNo.Trim();
                txtFright.Text = Util.GetDecimal(dt.Rows[0]["Freight"]) + "";
                txtRoundOff.Text = Util.GetDecimal(dt.Rows[0]["RoundOff"]) + "";
                txtOctori.Text = Util.GetDecimal(dt.Rows[0]["Octroi"]) + "";
                txtFright.Attributes["IsPost"] = Util.GetString(dt.Rows[0]["IsPost"]);
                txtInfoInvoiceNo.Text = Util.GetString(dt.Rows[0]["BillNo"]);
                if (Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("dd-MM-yyyy") != "01-01-0001")
                    txtucInvoiceDate.Text = Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("dd-MMM-yyyy");
                else
                    txtucInvoiceDate.Text = "";

                txtInfoChalanNo.Text = Util.GetString(dt.Rows[0]["ChallanNo"]);
                if (Util.GetDateTime(dt.Rows[0]["ChallanDate"]).ToString("dd-MM-yyyy") != "01-01-0001")
                    txtucChalanDate.Text = Util.GetDateTime(dt.Rows[0]["ChallanDate"]).ToString("dd-MMM-yyyy");
                else
                    txtucChalanDate.Text = "";
                txtnarration.Text = Util.GetString(dt.Rows[0]["Naration"]);
                lblBillAmt.Text = Util.GetString(dt.Rows[0]["GRNAmount"]);
                ddlVendorGRN.SelectedIndex = ddlVendorGRN.Items.IndexOf(ddlVendorGRN.Items.FindByValue(Util.GetString(dt.Rows[0]["VendorLedgerNo"])));

                if (Util.GetInt(dt.Rows[0]["IsPost"]) == 0)
                {
                    lblFright.Enabled = true;
                    lblOctori.Enabled = true;
                    lblRoundOff.Enabled = true;

                    txtFright.Enabled = true;
                    txtRoundOff.Enabled = true;
                    txtOctori.Enabled = true;
                }
                else
                {
                    lblFright.Enabled = false;
                    lblOctori.Enabled = false;
                    lblRoundOff.Enabled = false;

                    txtFright.Enabled = false;
                    txtRoundOff.Enabled = false;
                    txtOctori.Enabled = false;


                }


                mpGRNInfo.Show();
            }
        }
        BindConsignmentInfo();
    }
    protected void btnInfoUpdate_Click(object sender, EventArgs e)
    {

        string InvoiceDate = Util.GetDateTime(txtucInvoiceDate.Text).ToString("yyyy-MM-dd");
        if (InvoiceDate == string.Empty)
        {
            InvoiceDate = "0001-01-01";
        }
        string ChalanDate =Util.GetDateTime(txtucChalanDate.Text).ToString("yyyy-MM-dd");

        if (ChalanDate == string.Empty)
        {
            ChalanDate = "0001-01-01";
        }

        MySqlConnection conn;
        MySqlTransaction tnx;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
        {
            conn.Open();
        }
        tnx = conn.BeginTransaction();

        try
        {
            if (Util.GetInt(txtFright.Attributes["IsPost"]) == 0)
            {

                string strQuery = "UPDATE  consignmentdetail SET VendorLedgerNo='" + ddlVendorGRN.SelectedItem.Value + "'  Freight='" + txtFright.Text.ToString() + "',RoundOff='" + txtRoundOff.Text.ToString() + "',Octroi='" + txtOctori.Text.ToString() + "',BillNo='" + txtInfoInvoiceNo.Text.ToString() + "',BillDate='" + InvoiceDate + "',ChallanNo='" + txtInfoChalanNo.Text.ToString() + "',ChallanDate='" + ChalanDate + "',Naration='" + txtnarration.Text.ToString() + "' where ConsignmentNo='" + lblGRN.Text.ToString() + "'  ";
                if (StockReports.ExecuteDML(strQuery))
                    BindConsignmentItems1();
                else
                    lblMsg.Text = "Error...";


            }



            tnx.Commit();
            tnx.Dispose();

            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }
            BindConsignmentInfo();
        }
        catch (Exception ex)
        {
            tnx.Commit();
            tnx.Dispose();

            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }
    protected void btnGRNCancel_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        string UserID = Convert.ToString(Session["ID"]);
        string strSql = string.Empty;
        strSql = "UPDATE  consignmentdetail SET  IsCancel='1',RejectReason='" + txtCancelReason.Text + "',RejectedBy='" + UserID + "',RejectDateTime=NOW() where ConsignmentNo='" + lblConsignNo.Text.ToString() + "'  ";
        StockReports.ExecuteDML(strSql);
        con.Close();
        BindConsignmentInfo();

    }
    protected void gvItems_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            if (ViewState["ConsignmentItems"] != null)
            {
                BindItem();
                BindTAX();
                string ID = Util.GetString(e.CommandArgument);
                DataTable dt = (DataTable)ViewState["ConsignmentItems"];
                DataRow[] dr = dt.Select("ID = '" + ID + "'");

                if (dr.Length > 0)
                {
                    lblStockID.Text = ID;
                    lblFree.Text = (Util.GetBoolean(dr[0]["Free"]) ? "Yes" : "No");
                    lblItemName.Text = Util.GetString(dr[0]["ItemName"]);
                    lblRate.Text = Util.GetString(dr[0]["Rate"]);
                    lblQty.Text = Util.GetString(dr[0]["InititalCount"]);
                    lblDiscountPer.Text = Util.GetString(dr[0]["DiscountPer"]);
                    //lblTaxPer.Text = Util.GetString(dr[0]["PurTaxPer"]);
                    //GST Changes
                    lblIGSTPer.Text = Util.GetString(dr[0]["IGSTPercent"]);
                    lblCGSTPer.Text = Util.GetString(dr[0]["CGSTPercent"]);
                    lblSGSTPer.Text = Util.GetString(dr[0]["SGSTPercent"]);
                    lblHSNCode.Text = Util.GetString(dr[0]["HSNCode"]);
                    lblGSTType.Text = Util.GetString(dr[0]["GSTType"]);

                    lblBatchNumber.Text = Util.GetString(dr[0]["BatchNumber"]);
                    //lblMRP.Text = Util.GetString(dr[0]["MRP"]);
                    //lblLedgerTnxNo.Text = Util.GetString(dr[0]["LedgertransactionNo"]);
                    //lblTaxCalculateOn.Text = Util.GetString(dr[0]["taxCalculateOn"]);
                    //lblConversionFactor.Text = Util.GetString(dr[0]["ConversionFactor"]);
                    //lblExcisePer.Text = Util.GetString(dr[0]["ExcisePer"]);
                    lblExpiryDate.Text = Util.GetString(dr[0]["MedExpiryDate"]);
                    lblIsDeal.Text = Util.GetString(dr[0]["isDeal"]);
                    txtBatch.Text = Util.GetString(dr[0]["BatchNumber"]);
                    txtQty.Text = Util.GetString(dr[0]["InititalCount"]);
                    txtMRP.Text = Util.GetString(dr[0]["MRP"]);
                    txtDiscPer.Text = Util.GetString(dr[0]["DiscountPer"]);
                    // txtVatper.Text = Util.GetString(dr[0]["PurTaxPer"]);
                    txtRate.Text = Util.GetString(dr[0]["Rate"]);
                    txtExpDate.Text = Util.GetDateTime(dr[0]["MedExpiryDate"]).ToString("dd-MMM-yyyy");
                    //txtDeal.Text = Util.GetString(dr[0]["Deal1"]);
                    //txtDeal1.Text = Util.GetString(dr[0]["Deal2"]);
                    //ddlItemname.SelectedValue = Util.GetString(dr[0]["ItemID"]);
                    ddlItemname.SelectedItem.Text = Util.GetString(dr[0]["ItemName"]);
                    //GST Changes
                    txtIGST.Text = Util.GetString(dr[0]["IGSTPercent"]);
                    txtCGST.Text = Util.GetString(dr[0]["CGSTPercent"]);
                    txtSGST.Text = Util.GetString(dr[0]["SGSTPercent"]);
                    if (Util.GetString(dr[0]["GSTType"]) == "CGST&SGST")
                    {
                        ddlTax.SelectedIndex = ddlTax.Items.IndexOf(ddlTax.Items.FindByText("CGST&SGST"));
                        txtCGST.Enabled = txtSGST.Enabled = true;
                        txtIGST.Enabled = false;
                       // spSgst.Visible = true;
                       // spUtgst.Visible = false;
                        spSgst.InnerText = "SGST(%) :";
                    }
                    else if (Util.GetString(dr[0]["GSTType"]) == "CGST&UTGST")
                    {
                        ddlTax.SelectedIndex = ddlTax.Items.IndexOf(ddlTax.Items.FindByText("CGST&UTGST"));
                        txtCGST.Enabled = txtSGST.Enabled = true;
                        txtIGST.Enabled = false;
                        //spSgst.Visible = false;
                       // spUtgst.Visible = true;
                        spSgst.InnerText = "UTGST(%) :";
                    }
                    else
                    {
                        ddlTax.SelectedIndex = ddlTax.Items.IndexOf(ddlTax.Items.FindByText("IGST"));
                        txtCGST.Enabled = txtSGST.Enabled = false;
                        txtIGST.Enabled = true;
                       // spSgst.Visible = true;
                       // spUtgst.Visible = false;
                        spSgst.InnerText = "SGST(%) :";
                    }
                    //Special Discount changes

                    lblSpecialDiscPer.Text = txtSpecialDiscPer.Text = Util.GetString(dr[0]["SpecialDiscPer"]);
                    mpUpdate.Show();
                }
            }
        }

        if (e.CommandName == "ACancel1")
        {
            if (ViewState["ConsignmentItems"] != null)
            {
                string ID = Util.GetString(e.CommandArgument);
                DataTable dt = (DataTable)ViewState["ConsignmentItems"];
                DataRow[] dr = dt.Select("ID = '" + ID + "'");
                if (dr.Length > 0)
                {
                    lblStockID1.Text = ID;
                    lblItemName1.Text = Util.GetString(dr[0]["ItemName"]);
                    lblGRNno1.Text = Util.GetString(dr[0]["ConsignmentNo"]);
                    txtItemReason.Text = "";
                    txtItemReason.Focus();
                    mapItemCancel.Show();

                }
            }
        }

    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        mpUpdate.Hide();
       
    }

    #region Data Binding
    private void BindConsignmentInfo()
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" select t.* from ");
        sb.Append(" (SELECT IF(con.`IsReturn`=0,'No','Yes')IsReturn, consignmentNo,LedgerName,ChallanNo,DATE_FORMAT(ChallanDate,'%d %b %Y')ChallanDate,Date_format(StockDate,'%d %b %Y')StockDate,BillNo,GRNAmount,IsCancel,IF(IsCancel=1,'Cancel',IF(IsPost = 1,'Post','No'))NewPost,(CASE WHEN ispost=1 THEN 'True'  ELSE 'False' END)IsPosted,IF(`IsCancel`=1,'true',IF(IsPost = 1,'true','false'))Post,(CASE WHEN IsCancel=0 THEN 'NotRej.' WHEN IsCancel=1 THEN  'Rej.' END) AS IsReject FROM consignmentdetail con INNER JOIN f_ledgermaster lm ON con.VendorLedgerNo=lm.LedgerNumber where con.ID >0 and DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and CentreID=" + ViewState["CentreID"].ToString() + " ");

        if (txtInvoiceNo.Text != "")
            sb.Append(" and BillNo='" + txtInvoiceNo.Text + "' ");

        if (ddlVendor.SelectedIndex != 0)
            sb.Append("  and LedgerNumber= '" + ddlVendor.SelectedValue + "'");

        sb.Append(" and date(StockDate) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append(" and date(StockDate) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");

        sb.Append("AND con.CentreID="+ Session["CentreID"].ToString() +"  ORDER BY iscancel ");
        sb.Append(" )t ");
        sb.Append(" group by consignmentNo order by consignmentNo desc ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            gvGRN.DataSource = dt;
            gvGRN.DataBind();
            lblMsg.Text = "";

        }
        else
        {
            gvGRN.DataSource = null;
            gvGRN.DataBind();
            lblMsg.Text = "No Record Found";
        }


    }
    private void BindConsignmentItems1()
    {
        if (ViewState["consignmentNo"] != null)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ID,ConsignmentNo,ItemID,ItemName,UnitPrice,Rate,BatchNumber,  IF(ReleasedCount>0,'true','false')ReleasedCountExists,TaxPer,DiscountPer,InititalCount,MRP,IF(IsPost = 1,'true','false')NewPost,IF(`IsCancel`=1,'true',IF(IsPost = 1,'true','false'))Post, ");
            sb.Append(" IF(IsCancel=1,'Rej.','NotRej.')IsReject,IF(IsFree = 1,'true','false')Free,SpecialDiscPer,IFNULL(isDeal,'')isDeal,IFNULL(GSTType,'')GSTType,SGSTPercent,CGSTPercent,IGSTPercent,IFNULL(HSNCode,'')HSNCode,IsCancel,DATE_FORMAT(MedExpiryDate,'%d-%b-%Y')MedExpiryDate ");
            sb.Append(" FROM consignmentdetail WHERE ConsignmentNo='" + ViewState["consignmentNo"].ToString() + "' ");
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                gvItems.DataSource = dt;
                gvItems.DataBind();
                ViewState["ConsignmentItems"] = dt;
                lblMsg.Text = "";
            }
            else
            {
                gvItems.DataSource = null;
                gvItems.DataBind();
                lblMsg.Text = "No Details Found";
            }
        }
        else
        {
            gvItems.DataSource = null;
            gvItems.DataBind();
            lblMsg.Text = "No Details Found";
        }
    }
    private void BindItem()
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IM.Typename ItemName,im.IsExpirable,IsUsable,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#', ");
        sb.Append(" IF(IFNULL(IM.MinorUnit,'')='',IFNULL(im.UnitType,''),IM.MinorUnit),'#',IM.Type_ID,'#',IFNULL(IM.SaleTaxPer,''),'#',IFNULL(UPPER(im.IsExpirable),''),'#',IF(IFNULL(IM.minorUnit,'')='',IFNULL(im.minorUnit,''),IM.minorUnit),'#',IF(IFNULL(IM.ConversionFactor,'')='',IFNULL(im.ConversionFactor,''),IM.ConversionFactor),'#',IF(IFNULL(IM.MajorUnit,'')='',IFNULL(im.MajorUnit,''),IM.MajorUnit))ItemID,IM.Type_ID ");
        sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID ");
        // sb.Append(" LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=IM.itemID AND fid.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
        sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID =SM.CategoryID  WHERE IM.IsActive=1 AND ");
        sb.Append(" c.ConfigID ='11' ");
        sb.Append(" AND IM.TypeName<>'' order by IM.Typename ");
        DataTable dtItem = StockReports.GetDataTable(sb.ToString());

        ViewState["dtItem"] = dtItem;
        if (dtItem.Rows.Count > 0)
        {
            ddlItemname.DataSource = dtItem;
            ddlItemname.DataTextField = "ItemName";
            ddlItemname.DataValueField = "ItemID";
            ddlItemname.DataBind();
        }
        else
        {
            ddlItemname.Items.Clear();
            ddlItemname.Items.Add("No Item Found");
        }
    }
    public void BindTAX()
    {
        string sql = "";
        if (Resources.Resource.IsGSTApplicable == "0")
        {
            sql = "select TaxName,TaxID from f_taxmaster where TaxID IN('T4','T6') order by TaxName ";
        }
        else if (Resources.Resource.IsGSTApplicable == "1")
        {
            sql = "select TaxName,TaxID from f_taxmaster where TaxID IN('T4','T6','T7') order by TaxName ";
        }
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            ddlTax.DataSource = dt;
            ddlTax.DataTextField = "TaxName";
            ddlTax.DataValueField = "TaxID";
            ddlTax.DataBind();

        }
        else
        {
            ddlTax.Items.Clear();
            ddlTax.Items.Add("No Item Found");

        }

    }
    #endregion
    protected void gvItems_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblReject")).Text != "NotRej.")
            {
                e.Row.BackColor = System.Drawing.Color.Pink;
                e.Row.ToolTip = "Rejected Item";
                e.Row.Cells[8].Enabled = false;
                e.Row.Cells[9].Enabled = false;
                e.Row.FindControl("imbEdit").Visible = false;
                e.Row.FindControl("imbCancel1").Visible = false;
            }
        }
    }
    protected void btnRejectItem_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        string UserID = Convert.ToString(Session["ID"]);
        string strSql = string.Empty;
        strSql = "UPDATE  consignmentdetail SET  IsCancel='1',RejectReason='" + txtItemReason.Text + "',RejectedBy='" + UserID + "',RejectDateTime=NOW() where ID='" + lblStockID1.Text.ToString() + "'  ";
        StockReports.ExecuteDML(strSql);
        con.Close();
        BindConsignmentItems1();
        
    }
    [WebMethod]
    public static List<object> GetItemList(string ItemName, string GRNNo)
    {
        List<object> Emp = new List<object>();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IM.Typename ItemName,IM.ItemID `ID`,im.IsExpirable,IsUsable,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#', ");
        sb.Append(" IF(IFNULL(IM.MinorUnit,'')='',IFNULL(im.UnitType,''),IFNULL(IM.MinorUnit,'')),'#',IFNULL(IM.Type_ID,''),'#',IFNULL(IM.SaleTaxPer,''),'#',IFNULL(UPPER(im.IsExpirable),''),'#',IF(IFNULL(IM.minorUnit,'')='',IFNULL(im.minorUnit,''),IFNULL(IM.minorUnit,'')),'#',IF(IFNULL(IM.ConversionFactor,'')='',IFNULL(im.ConversionFactor,''),IFNULL(IM.ConversionFactor,'')),'#',IF(IFNULL(IM.MajorUnit,'')='',IFNULL(im.MajorUnit,''),IFNULL(IM.MajorUnit,'')),'#',IFNULL(im.GSTType,''),'#',IFNULL(im.IGSTPercent,''),'#',IFNULL(im.CGSTPercent,''),'#',IFNULL(im.SGSTPercent,''),'#',IFNULL(im.HSNCode,''),'#',IFNULL(im.IsUsable,''))ItemID,IM.Type_ID  ");
        sb.Append(" FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID ");
        sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID =SM.CategoryID  ");
        sb.Append(" WHERE IM.IsActive=1 AND c.ConfigID ='11' AND TypeName LIKE '%" + ItemName + "%' AND  IM.TypeName<>''");
        sb.Append(" AND NOT EXISTS(SELECT * FROM f_stock WHERE LedgerTransactionNo='" + GRNNo + "' AND itemid=im.Itemid) ");
        sb.Append(" ORDER BY IM.Typename ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        foreach (DataRow row in dt.Rows)
        {
            Emp.Add(new
            {
                itemName = row["ItemName"].ToString(),
                itemID = row["ItemID"].ToString()
            });
        }
        return Emp;
    }
    public void BindGST()
    {
        string sql = "select TaxName,TaxID from f_taxmaster where TaxID IN('T4','T6','T7') order by TaxName ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            ddlIGSTType.DataSource = dt;
            ddlIGSTType.DataTextField = "TaxName";
            ddlIGSTType.DataValueField = "TaxID";
            ddlIGSTType.DataBind();
            ddlIGSTType.SelectedIndex = ddlIGSTType.Items.IndexOf(ddlIGSTType.Items.FindByValue("T4"));
        }
        else
        {
            ddlIGSTType.Items.Clear();
            ddlIGSTType.Items.Add("No Item Found");
        }

    }
}

