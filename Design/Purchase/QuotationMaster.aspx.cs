using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Purchase_QuotationMaster : System.Web.UI.Page
{
    [WebMethod]
    public static int CheckQuotationNo(string QuotationNo, string VendorID)
    {
        int Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from f_purchase_Quotation Where QuotationRefNo='" + QuotationNo + "' AND VendorID='" + VendorID + "' "));
        if (Count > 0)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }

    public void BindCategoryNew()
    {
        try
        {
            ddlCategory.DataSource = null;
            ddlCategory.DataBind();

            string str = "select CONCAT(cm.CategoryID,'#',ConfigID)CategoryID,cm.Name from f_categorymaster " +
                " cm inner join f_configrelation c on cm.CategoryID =c.CategoryID where cm.active=1 AND c.ConfigID " +
                " IN (11,28)   order by Name";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                ddlCategory.DataSource = dt;

                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataTextField = "Name";
                ddlCategory.DataBind();
            }
            ddlCategory.Items.Insert(0, new ListItem("Select", "0"));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        int Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from f_purchase_Quotation Where QuotationRefNo='" + txtQuotationNo.Text.Trim() + "' AND VendorID='" + ddlVendor.SelectedItem.Value + "' "));
        if (Count > 0)
        {
            lblmsg.Text = "Quotation No. Already Exists For Vendor " + ddlVendor.SelectedItem.Text;
            txtQuotationNo.Focus();
            return;
        }
        DataTable dt;
        if (ViewState["dtItems"] == null)
        {
            dt = GetDataTable();
        }
        else
        {
            dt = (DataTable)ViewState["dtItems"];
        }

        DataRow dr = dt.NewRow();
        if (lstItem.SelectedIndex < 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblmsg.ClientID + "');", true);
            txtItem.Focus();
            return;
        }
        if (lstItem.SelectedItem.Value != "0")
        {
            dr["ItemId"] = lstItem.SelectedItem.Value.Split('#').GetValue(0).ToString();
            dr["ItemName"] = lstItem.SelectedItem.Text.ToString().Split('#')[0];

            foreach (DataRow drCheck in dt.Rows)
            {
                string ItemID = lstItem.SelectedItem.Value.Split('#').GetValue(0).ToString();
                if (drCheck["ItemId"].ToString() == ItemID)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM240','" + lblmsg.ClientID + "');", true);
                    return;
                }
            }
        }
        if (txtRate.Text == "" || txtRate.Text == "0")
        {
            txtRate.Focus();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM021','" + lblmsg.ClientID + "');", true);
            return;
        }
        else
        {
            dr["Rate"] = txtRate.Text.ToString();
        }

        dr["Discount"] = Util.GetDecimal(txtDisc.Text).ToString();

        if (ddlVendor.SelectedItem.Value == "0")
        {
            ddlVendor.Focus();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM022','" + lblmsg.ClientID + "');", true);
            return;
        }
        else
        {
            dr["VendorID"] = ddlVendor.SelectedItem.Value;
            dr["VendorName"] = ddlVendor.SelectedItem.Text.ToString();
            string LedgerNumber = StockReports.ExecuteScalar("select LedgerNumber from f_ledgermaster where LedgerUserID='" + ddlVendor.SelectedItem.Value + "' and GroupID='VEN' ");
            if (LedgerNumber != "")
            {
                dr["VendorLedgerNo"] = Util.GetString(LedgerNumber);
            }
            else
            {
                dr["VendorLedgerNo"] = "";
            }
        }

        if (txtQuotationNo.Text.ToString() == "")
        {
            txtQuotationNo.Focus();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM023','" + lblmsg.ClientID + "');", true);
            return;
        }
        else
        {
            dr["QuotationRefNo"] = txtQuotationNo.Text.ToString();
        }
        if (refdate.Text == "0001-01-01")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM023','" + lblmsg.ClientID + "');", true);
            return;
        }
        else
        {
            if (ViewState["RefDate"] != null)
            {
                dr["RefDate"] = ViewState["RefDate"].ToString();
            }
            else
            {
                dr["RefDate"] = Util.GetDateTime(refdate.Text).ToString("yyyy-MM-dd");
                ViewState["RefDate"] = Util.GetDateTime(refdate.Text).ToString("yyyy-MM-dd");
            }
        }

        dr["MRP"] = 0.00;

        dr["Remarks"] = txtRemarks.Text.ToString();
        dr["Specification"] = lblSpecification.Text.ToString();
        dr["Qty"] = txtQty.Text.ToString();
        dr["ModelNumber"] = txtModelNumber.Text.Trim();
        if (txtDeliveryTime.Text.Trim() != "")
            dr["DeliveryTime"] = txtDeliveryTime.Text.Trim() + " " + ddlDeliveryTime.SelectedItem.Text;
        else
            dr["DeliveryTime"] = "";
        dr["PaymentPattern"] = txtPaymentPattern.Text.Trim();
        dr["AMC"] = Util.GetDecimal(txtAMC.Text.Trim());
        dr["OperationalCost"] = txtOperationalCost.Text.Trim();
        dr["SilentFeatures"] = txtSilentFeatures.Text.Trim();
        dr["AdditionalFeatures"] = txtAdditionalFeatures.Text.Trim();
        if (ddlupload_doc.HasFile)
        {
            string Path = Server.MapPath("~/QuotationDocument");
            if (!Directory.Exists(Path))
            {
                Directory.CreateDirectory(Path);
            }

            string Exte = System.IO.Path.GetExtension(ddlupload_doc.PostedFile.FileName);
            if (Exte != "")
            {
                if (Exte != ".pdf" && Exte != ".jpg" && Exte != ".jpeg" && Exte != ".doc" && Exte != ".docx" && Exte != ".gif")
                {
                    lblmsg.Text = "Wrong File Extension of Selected Document ";
                    return;
                }
            }
            //  string filePath = System.IO.Path.Combine(Path, ddlupload_doc.FileName);

            string ImgName = ddlupload_doc.FileName;

            string newFile = Guid.NewGuid().ToString() + Exte;
            string Url = System.IO.Path.Combine(Path, newFile);
            //  string filePathNew = Server.MapPath(NewPath) + txtQuotationNo.Text + System.IO.Path.GetExtension(Url);
            if (File.Exists(Url))
            {
                File.Delete(Url);
            }

            ddlupload_doc.SaveAs(Url);
            Url = Url.Replace("\\", "''");
            Url = Url.Replace("'", "\\");
            dr["URL"] = newFile;
            dr["UploadStatus"] = 1;
        }
        else
        {
            dr["URL"] = "";
            dr["UploadStatus"] = 0;
        }

        if (ViewState["ISOld"] != null)
        {
            if (ViewState["ISOld"].ToString() == "1")
            {
                dr["IsOld"] = 1;
            }
            else
            {
                dr["IsOld"] = 0;
            }
        }
        else
        {
            dr["IsOld"] = 0;
        }
        DataTable dtTax = (DataTable)ViewState["dtTax"];

        StringBuilder sbTax = new StringBuilder();
        sbTax.Append("<table width=40% border=0 cellpadding=1 cellspacing=1 >");

        foreach (GridViewRow gr in grdTax.Rows)
        {
            if (((TextBox)gr.FindControl("txtPer")).Text != string.Empty)
            {
                sbTax.Append("<tr>");
                sbTax.Append("<td width=70% align=left valign=middle><font face=Verdana size=2 >" + Util.GetString(((Label)gr.FindControl("lblTaxName")).Text.ToString()) + "</td>");
                sbTax.Append("<td width=10% align=center valign=middle><font face=Verdana size=2 >&nbsp;=&nbsp;</td>");
                sbTax.Append("<td width=20% align=left valign=middle><font face=Verdana size=2 >" + Util.GetString(((TextBox)gr.FindControl("txtPer")).Text.ToString()) + "</td>");
                sbTax.Append("<td width=20% align=left valign=middle><font face=Verdana size=2 >" + Util.GetString(((TextBox)gr.FindControl("txtTaxAmt")).Text.ToString()) + "</td>");
                sbTax.Append("</tr>");
                if (dr["TaxName"].ToString() != "")
                    dr["TaxName"] = dr["TaxName"] + "#" + Util.GetString(((Label)gr.FindControl("lblTaxName")).Text.ToString());
                else
                    dr["TaxName"] = Util.GetString(((Label)gr.FindControl("lblTaxName")).Text.ToString());

                if (dr["TaxID"].ToString() != "")
                    dr["TaxID"] = dr["TaxID"] + "#" + Util.GetString(((Label)gr.FindControl("lblTaxID")).Text.ToString());
                else
                    dr["TaxID"] = Util.GetString(((Label)gr.FindControl("lblTaxID")).Text.ToString());

                if (dr["TaxValue"].ToString() != "")
                    dr["TaxValue"] = dr["TaxValue"] + "#" + Util.GetString(((TextBox)gr.FindControl("txtPer")).Text.ToString());
                else
                    dr["TaxValue"] = Util.GetString(((TextBox)gr.FindControl("txtPer")).Text.ToString());

                if (dr["TaxAmt"].ToString() != "")
                    dr["TaxAmt"] = dr["TaxAmt"] + "#" + "0";
                else
                    dr["TaxAmt"] = "0";
            }
            else if (((TextBox)gr.FindControl("txtTaxAmt")).Text != string.Empty)
            {
                sbTax.Append("<tr>");
                sbTax.Append("<td width=70% align=left valign=middle><font face=Verdana size=2 >" + Util.GetString(((Label)gr.FindControl("lblTaxName")).Text.ToString()) + "</td>");
                sbTax.Append("<td width=10% align=center valign=middle><font face=Verdana size=2 >&nbsp;=&nbsp;</td>");
                sbTax.Append("<td width=20% align=left valign=middle><font face=Verdana size=2 >" + Util.GetString(((TextBox)gr.FindControl("txtPer")).Text.ToString()) + "</td>");
                sbTax.Append("<td width=20% align=left valign=middle><font face=Verdana size=2 >" + Util.GetString(((TextBox)gr.FindControl("txtTaxAmt")).Text.ToString()) + "</td>");
                sbTax.Append("</tr>");
                if (dr["TaxName"].ToString() != "")
                    dr["TaxName"] = dr["TaxName"] + "#" + Util.GetString(((Label)gr.FindControl("lblTaxName")).Text.ToString());
                else
                    dr["TaxName"] = Util.GetString(((Label)gr.FindControl("lblTaxName")).Text.ToString());

                if (dr["TaxID"].ToString() != "")
                    dr["TaxID"] = dr["TaxID"] + "#" + Util.GetString(((Label)gr.FindControl("lblTaxID")).Text.ToString());
                else
                    dr["TaxID"] = Util.GetString(((Label)gr.FindControl("lblTaxID")).Text.ToString());

                if (dr["TaxAmt"].ToString() != "")
                    dr["TaxAmt"] = dr["TaxAmt"] + "#" + Util.GetString(((TextBox)gr.FindControl("txtTaxAmt")).Text.ToString());
                else
                    dr["TaxAmt"] = Util.GetString(((TextBox)gr.FindControl("txtTaxAmt")).Text.ToString());

                if (dr["TaxValue"].ToString() != "")
                    dr["TaxValue"] = dr["TaxValue"] + "#" + "0";
                else
                    dr["TaxValue"] = "0";
            }
        }
        sbTax.Append("</table>");
        dr["Tax"] = sbTax;

        if (dr["TaxID"].ToString() != "")
        {
            string[] TaxID = Util.GetString(dr["TaxID"].ToString()).Split('#');
            string[] TaxName = Util.GetString(dr["TaxName"].ToString()).Split('#');
            string[] TaxValue = Util.GetString(dr["TaxValue"].ToString()).Split('#');
            string[] TaxAmount = Util.GetString(dr["TaxAmt"].ToString()).Split('#');
            for (int i = 0; i < TaxID.Length; i++)
            {
                foreach (DataRow drnew in dtTax.Rows)
                {
                    if (drnew["TaxID"].ToString() == TaxID[i].ToString())
                    {
                        if (TaxID[i].ToString() == "T5")
                        {
                            drnew["TaxAmt"] = TaxAmount[i].ToString();
                        }
                        else
                        {
                            drnew["Tax"] = TaxValue[i].ToString();
                        }
                    }
                }
            }
        }
        dtTax.AcceptChanges();

        AmountCalculation objAmountCalculation = new AmountCalculation();
        decimal rate = objAmountCalculation.getAmountnew(Util.GetDecimal(txtRate.Text.ToString()), Util.GetDecimal(txtDisc.Text.ToString()), dtTax);

        dr["CostPrice"] = rate;
        dt.Rows.Add(dr);
        dt.AcceptChanges();
        ViewState["dtItems"] = dt;
        btnSaveQuto.Visible = true;
        if (dt.Rows.Count > 0)
        {
            grdItemQuto.DataSource = dt;
            grdItemQuto.DataBind();
        }
        else
        {
            grdItemQuto.DataSource = null;
            grdItemQuto.DataBind();
        }
        ddlVendor.Enabled = false;
        txtQuotationNo.Enabled = false;
        ddlCategory.Enabled = false;

        if (ViewState["RefDate"] != null)
        {
            refdate.Text = Util.GetDateTime(refdate.Text).ToString("yyyy-MM-dd");
            refdate.Text = (ViewState["RefDate"].ToString());
        }
        BindSubcategory();
        txtItem.Text = "";
        txtItem.Focus();

        txtRemarks.Text = "";
        txtRate.Text = "";
        lblSpecification.Text = "";
        txtDisc.Text = "";
        BindTax();
        divRefDate.Disabled = true;
        ddlSubCategory.Focus();
    }

    protected void btnQuotSearchnew_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow grmanu in grdVendorQuotationnew.Rows)
        {
            if (((CheckBox)grmanu.FindControl("chkselect")).Checked == true)
            {
                StringBuilder sb = new StringBuilder();
                //sb.Append(" SELECT QuotationID,ItemId,IF(prq.itemid LIKE 'LSHHI%',(SELECT TypeName FROM f_itemmaster WHERE ItemId=prq.itemid), ");
                //sb.Append(" IFNULL((SELECT im.Typename FROM f_itemmaster im  INNER JOIN d_f_itemmaster dim ON im.ItemID=dim.itemIdMain  ");
                //sb.Append(" WHERE dim.itemid=prq.itemid),(SELECT TypeName FROM d_f_itemmaster im  WHERE im.ItemID=prq.ItemID)))ItemName ");
                //sb.Append(" ,IF(prq.itemid LIKE 'LSHHI%',(SELECT (SELECT NAME FROM f_manufacture_master WHERE ManufactureID=im.manufactureid) FROM f_itemmaster im WHERE im.itemid=prq.itemid), ");
                //sb.Append(" IFNULL( (SELECT dim.Name FROM d_f_itemmaster im  INNER JOIN d_f_manufacture_master dim ON im.manufactureid=dim.ManufactureID  ");
                //sb.Append(" WHERE im.itemid=prq.itemid),(SELECT dim.Name FROM d_f_itemmaster im  INNER JOIN f_manufacture_master dim ON im.manufactureid=dim.ManufactureID  ");
                //sb.Append(" WHERE im.itemid=prq.itemid) ) )ManufacturerName,IF(prq.VendorID LIKE 'LSHHI%',(SELECT VendorName FROM f_vendormaster WHERE vendor_id=prq.VendorID), ");
                //sb.Append(" IFNULL((SELECT ven.Vendorname FROM f_vendormaster ven INNER JOIN d_f_vendormaster dven ON ven.vendor_id=dven.vendor_idMain       ");
                //sb.Append(" WHERE dven.Vendor_id=prq.VendorID),(SELECT VendorName FROM d_f_vendormaster ven  WHERE ven.Vendor_id=prq.VendorID)))VendorName ");

                //sb.Append(" ,IF(prq.itemid LIKE 'LSHHI%',(SELECT (SELECT MAnufactureID FROM f_manufacture_master WHERE ManufactureID=im.manufactureid) FROM f_itemmaster im WHERE im.itemid=prq.itemid), ");
                //sb.Append(" IFNULL( (SELECT dim.MAnufactureID FROM d_f_itemmaster im  INNER JOIN d_f_manufacture_master dim ON im.manufactureid=dim.ManufactureID  ");
                //sb.Append(" WHERE im.itemid=prq.itemid),(SELECT dim.MAnufactureID FROM d_f_itemmaster im  INNER JOIN f_manufacture_master dim ON im.manufactureid=dim.ManufactureID  ");
                //sb.Append(" WHERE im.itemid=prq.itemid) ) )Manufacturer ");

                //sb.Append(" ,Rate,'1' Qty,Discount,'' VendorId,'' VendorLedgerNo, ");
                //sb.Append(" '' VendorName ");
                //sb.Append(" ,'' QuotationRefNo,RefDate,Remarks,Specification,'' Tax,'' TaxName,'' TaxID,'' TaxValue,'1' IsOld,MRP,'' SaltName,'' CostPrice,ManufactureQuotNo,''ManufactureQuotationNo,RefrenceNo  FROM f_purchase_Quotation prq WHERE  RefrenceNo='" + Util.GetString(((Label)grmanu.FindControl("lblRefNo")).Text.ToString()) + "' ");
                //Shatrughan 24.05.14
                sb.Append("  SELECT  prq.QuotationID,prq.ItemID,im.TypeName ItemName,fmm.NAME ManufacturerName, ");
                sb.Append("  ven.VendorName,fmm.MAnufactureID Manufacturer,Rate,'1' Qty,Discount,'' VendorId,'' VendorLedgerNo,'' VendorName   ");
                sb.Append(" ,'' QuotationRefNo,RefDate,Remarks,Specification,'' Tax,'' TaxName,'' TaxID,'' TaxValue,'1' IsOld,MRP,'' SaltName,'' CostPrice, ");
                sb.Append(" ManufactureQuotNo,''ManufactureQuotationNo,RefrenceNo ");
                sb.Append("  FROM f_purchase_Quotation prq INNER JOIN f_itemmaster im ON prq.ItemID=im.ItemID INNER JOIN  ");
                sb.Append(" f_vendormaster ven ON ven.vendor_id=prq.VendorID INNER JOIN  ");
                sb.Append(" f_manufacture_master fmm ON fmm.ManufactureID=im.manufactureid WHERE  RefrenceNo='" + Util.GetString(((Label)grmanu.FindControl("lblRefNo")).Text.ToString()) + "' ");
                sb.Append(" ORDER BY prq.QuotationID ");

                DataTable dt = StockReports.GetDataTable(sb.ToString());
                ViewState["ISOld"] = "1";
                ddlVendor.SelectedIndex = ddlVendor.Items.IndexOf(ddlVendor.Items.FindByText(dt.Rows[0]["VendorName"].ToString())) - 1;
                foreach (DataRow dr in dt.Rows)
                {
                    sb = new StringBuilder();
                    sb.Append("SELECT tax.TaxName,pqtax.Taxid,pqtax.TaxPer Tax FROM f_purchase_Quotation_tax pqtax INNER JOIN f_taxmaster tax ON pqtax.TaxID=tax.TaxID WHERE pqtax.QuotationID='" + Util.GetString(dr["QuotationID"].ToString()) + "' ");
                    DataTable dtTax = StockReports.GetDataTable(sb.ToString());
                    ViewState["dtTax"] = dtTax;

                    StringBuilder sbTax = new StringBuilder();
                    sbTax.Append("<table width=40% border=0 cellpadding=1 cellspacing=1 >");

                    foreach (DataRow gr in dtTax.Rows)
                    {
                        sbTax.Append("<tr>");
                        sbTax.Append("<td width=70% align=left valign=middle><font face=Verdana size=2 >" + Util.GetString(gr["TaxName"].ToString()) + "</td>");
                        sbTax.Append("<td width=10% align=center valign=middle><font face=Verdana size=2 >&nbsp;=&nbsp;</td>");
                        sbTax.Append("<td width=20% align=left valign=middle><font face=Verdana size=2 >" + Util.GetString(gr["Tax"].ToString()) + "</td>");
                        sbTax.Append("</tr>");
                        if (dr["TaxName"].ToString() != "")
                            dr["TaxName"] = dr["TaxName"] + "#" + Util.GetString(gr["TaxName"].ToString());
                        else
                            dr["TaxName"] = Util.GetString(gr["TaxName"].ToString());

                        if (dr["TaxID"].ToString() != "")
                            dr["TaxID"] = dr["TaxID"] + "#" + Util.GetString(gr["TaxId"].ToString());
                        else
                            dr["TaxID"] = Util.GetString(gr["TaxId"].ToString());

                        if (dr["TaxValue"].ToString() != "")
                            dr["TaxValue"] = dr["TaxValue"] + "#" + Util.GetString(gr["Tax"].ToString());
                        else
                            dr["TaxValue"] = Util.GetString(gr["Tax"].ToString());
                    }
                    sbTax.Append("</table>");
                    dr["Tax"] = sbTax;

                    dtTax.AcceptChanges();

                    AmountCalculation objAmountCalculation = new AmountCalculation();
                    decimal rate = objAmountCalculation.getAmountnew(Util.GetDecimal(dr["Rate"].ToString()), Util.GetDecimal(dr["Discount"].ToString()), dtTax);
                    dr["CostPrice"] = rate;
                }
                dt.AcceptChanges();
                ViewState["dtItems"] = dt;
                btnSaveQuto.Visible = true;

                if (dt.Rows.Count > 0)
                {
                    grdItemQuto.DataSource = dt;
                    grdItemQuto.DataBind();
                }
                else
                {
                    grdItemQuto.DataSource = null;
                    grdItemQuto.DataBind();
                }
                BindVendor();
                BindCategoryNew();
                lstItem.Items.Clear();
                lstItem.DataSource = null;
                lstItem.DataBind();

                txtQuotationNo.Text = "";
                txtRemarks.Text = "";
                txtRate.Text = "";
                lblSpecification.Text = "";
                txtDisc.Text = "";
                BindTax();
                ddlVendor.Enabled = false;
                txtModelNumber.Text = "";
                txtPaymentPattern.Text = "";
                txtDeliveryTime.Text = "";
                ddlDeliveryTime.SelectedIndex = 0;
                txtOperationalCost.Text = "";
                txtAMC.Text = "";
                txtSilentFeatures.Text = ""; ;
                txtAdditionalFeatures.Text = "";
            }
        }
    }

    protected void btnRefershItem_Click(object sender, EventArgs e)
    {
        BindItemNew();

        if (ddlSubCategory.SelectedItem.Value != "0")
        {
            lstItem.Focus();
        }
        else
        {
            btnSaveQuto.Focus();
        }
        if (ViewState["RefDate"] != null)
        {
            refdate.Text = Util.GetDateTime(refdate.Text).ToString("yyyy-MM-dd");
            refdate.Text = (ViewState["RefDate"].ToString());
        }
    }

    protected void btnSaveQuto_Click(object sender, EventArgs e)
    {
        DataTable dtitem = (DataTable)ViewState["dtItems"];
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        string strQuery = "";
        string QuotationRefNo = "";
        try
        {
            string vendorid = "", vendorledgerno = "", vendorname = "";

            string PQuot = StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_purchase_Quotation WHERE VendorID='" + ddlVendor.SelectedItem.Value + "' AND QuotationRefNo='" + txtQuotationNo.Text.Trim() + "' ");
            if (Util.GetInt(PQuot) > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM241','" + lblmsg.ClientID + "');", true);
                txtQuotationNo.Enabled = true;
                return;
            }

            if (dtitem.Rows.Count > 0)
            {
                string RefNo = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT  get_Tran_id(CONCAT('f_purchase_Quotation'))"));
                foreach (DataRow dr in dtitem.Rows)
                {
                    if (Util.GetString(dr["IsOld"].ToString()) == "0")
                    {
                        if (QuotationRefNo == "")
                        {
                            QuotationRefNo = Util.GetString(dr["QuotationRefNo"].ToString());
                        }
                        strQuery = " insert into f_purchase_Quotation (PurchaseRequestNo,ItemID, Rate, Discount,VendorLedgerNo,VendorID, QuotationRefNo,RefDate, Date, Remarks,Specification,Quote_IDMain,RefrenceNo,MRP,ManufactureQuotNo,ModelNumber,DeliveryTime,PaymentPattern,AMC,OperationalCost,SilentFeatures,AdditionalFeatures,URL,UploadStatus)" +
                        " values ('', '" + Util.GetString(dr["ItemId"].ToString()) + "'," + Util.GetDecimal(dr["Rate"].ToString()) + "," + Util.GetDecimal(dr["Discount"].ToString()) + ",'" + Util.GetString(dr["VendorLedgerNo"].ToString()) + "','" + Util.GetString(dr["VendorID"].ToString()) + "', '" + Util.GetString(dr["QuotationRefNo"].ToString()) + "', " +
                        " '" + dr["RefDate"] + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', '" + Util.GetString(dr["Remarks"].ToString()) + "','" + Util.GetString(dr["Specification"].ToString()) + "',0,'" + RefNo + "','" + Util.GetDecimal(dr["MRP"]) + "','" + dr["ManufactureQuotationNo"] + "', " +
                        " '" + dr["ModelNumber"] + "','" + dr["DeliveryTime"] + "','" + dr["PaymentPattern"] + "','" + dr["AMC"] + "','" + dr["OperationalCost"] + "','" + dr["SilentFeatures"] + "','" + dr["AdditionalFeatures"] + "','" + dr["URL"] + "','" + dr["UploadStatus"] + "' )";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                        string QuoteID = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select max(QuotationID) from f_purchase_Quotation"));

                        if (dr["TaxID"].ToString() != "")
                        {
                            string[] TaxID = Util.GetString(dr["TaxID"].ToString()).Split('#');
                            string[] TaxName = Util.GetString(dr["TaxName"].ToString()).Split('#');
                            string[] TaxValue = Util.GetString(dr["TaxValue"].ToString()).Split('#');
                            string[] TaxAmount = Util.GetString(dr["TaxAmt"].ToString()).Split('#');
                            for (int i = 0; i < TaxID.Length; i++)
                            {
                                string TaxIDNew = Util.GetString(TaxID[i].ToString());
                                string TaxPerNew = Util.GetString(TaxValue[i].ToString());
                                string TaxAmtNew = Util.GetString(TaxAmount[i].ToString());
                                string InsertTax = "insert into f_purchase_Quotation_tax(TaxID,TaxPer,QuotationID,PurchaseRequestNo,PRQTaxIDMain,TaxAmt,CreatedBy) values('" + TaxIDNew + "'," + TaxPerNew + "," + QuoteID + ",'',0,'" + TaxAmtNew + "','" + ViewState["ID"] + "')";
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, InsertTax);
                            }
                        }
                    }
                    else
                    {
                        if (QuotationRefNo == "")
                        {
                            QuotationRefNo = Util.GetString(txtQuotationNo.Text.ToString());
                            if (QuotationRefNo == "")
                            {
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM242','" + lblmsg.ClientID + "');", true);
                                txtQuotationNo.Focus();
                                return;
                            }
                        }

                        if (ddlVendor.SelectedItem.Value == "0")
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM022','" + lblmsg.ClientID + "');", true);
                            return;
                        }
                        else
                        {
                            vendorid = ddlVendor.SelectedItem.Value;
                            vendorname = ddlVendor.SelectedItem.Text.ToString();

                            string LedgerNumber = StockReports.ExecuteScalar("select LedgerNumber from f_ledgermaster where LedgerUserID='" + ddlVendor.SelectedItem.Value + "' and groupid='VEN' ");
                            if (LedgerNumber != "")
                            {
                                vendorledgerno = Util.GetString(LedgerNumber);
                            }
                            else
                            {
                                vendorledgerno = "";
                            }
                        }
                        if (ViewState["RefDate"] == null)
                        {
                            ViewState["RefDate"] = Util.GetDateTime(refdate.Text).ToString("yyyy-MM-dd");
                        }
                        strQuery = "insert into f_purchase_Quotation (PurchaseRequestNo,ItemID, Rate, Discount,VendorLedgerNo,VendorID, QuotationRefNo,RefDate, Date, Remarks,Specification,Quote_IDMain,RefrenceNo,MRP,ManufactureQuotNo,ModelNumber,DeliveryTime,PaymentPattern,AMC,OperationalCost,SilentFeatures,AdditionalFeatures,URL,UploadStatus)" +
                        " values ('', '" + Util.GetString(dr["ItemId"].ToString()) + "'," + Util.GetDecimal(dr["Rate"].ToString()) + "," + Util.GetDecimal(dr["Discount"].ToString()) + ",'" + Util.GetString(vendorledgerno) + "','" + Util.GetString(vendorid) + "', '" + Util.GetString(QuotationRefNo) + "','" + ViewState["RefDate"].ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', '" + Util.GetString(dr["Remarks"].ToString()) + "','" + Util.GetString(dr["Specification"].ToString()) + "',0,'" + RefNo + "'," + dr["MRP"] + ",'" + dr["ManufactureQuotationNo"] + "' ," +
                       " '" + dr["ModelNumber"] + "','" + dr["DeliveryTime"] + "','" + dr["PaymentPattern"] + "','" + dr["AMC"] + "','" + dr["OperationalCost"] + "','" + dr["SilentFeatures"] + "','" + dr["AdditionalFeatures"] + "','" + dr["URL"] + "','" + dr["UploadStatus"] + "' )";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                        string QuoteID = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select max(QuotationID) from f_purchase_Quotation"));

                        if (dr["TaxID"].ToString() != "")
                        {
                            string[] TaxID = Util.GetString(dr["TaxID"].ToString()).Split('#');
                            string[] TaxName = Util.GetString(dr["TaxName"].ToString()).Split('#');
                            string[] TaxValue = Util.GetString(dr["TaxValue"].ToString()).Split('#');
                            string[] TaxAmount = Util.GetString(dr["TaxAmt"].ToString()).Split('#');
                            for (int i = 0; i < TaxID.Length; i++)
                            {
                                string TaxIDNew = Util.GetString(TaxID[i].ToString());
                                string TaxPerNew = Util.GetString(TaxValue[i].ToString());
                                string TaxAmtNew = Util.GetString(TaxAmount[i].ToString());
                                string InsertTax = "insert into f_purchase_Quotation_tax(TaxID,TaxPer,QuotationID,PurchaseRequestNo,PRQTaxIDMain,TaxAmt,CreatedBy) values('" + TaxIDNew + "'," + TaxPerNew + "," + QuoteID + ",'',0,'" + TaxAmtNew + "','" + ViewState["ID"] + "')";
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, InsertTax);
                            }
                        }
                    }
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                Tranx.Commit();

                grdItemQuto.DataSource = null;
                grdItemQuto.DataBind();
                btnSaveQuto.Visible = false;
                ViewState["dtItems"] = null;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "KEY1", "alert('New Reference No. " + RefNo.ToString() + "');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='QuotationMaster.aspx';", true);
            }
        }
        catch (Exception ex)
        {
            foreach (DataRow dr in dtitem.Rows)
            {
                if (dr["UploadStatus"].ToString() != "0")
                {
                }
            }

            Tranx.Rollback();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearchQuot_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("  SELECT  IF(prq.itemid LIKE 'LSHHI%',(SELECT (SELECT NAME FROM f_manufacture_master WHERE ManufactureID=im.manufactureid) FROM f_itemmaster im WHERE im.itemid=prq.itemid),  ");
        //sb.Append("  IFNULL( (SELECT dim.Name FROM d_f_itemmaster im  INNER JOIN d_f_manufacture_master dim ON im.manufactureid=dim.ManufactureID    ");
        //sb.Append("  WHERE im.itemid=prq.itemid),(SELECT dim.Name FROM d_f_itemmaster im  INNER JOIN f_manufacture_master dim ON im.manufactureid=dim.ManufactureID    ");
        //sb.Append("  WHERE im.itemid=prq.itemid) ) )ManufacturerName   ");
        //sb.Append("  ,IF(prq.itemid LIKE 'LSHHI%',(SELECT (SELECT MAnufactureID FROM f_manufacture_master WHERE ManufactureID=im.manufactureid) FROM f_itemmaster im WHERE im.itemid=prq.itemid),   ");
        //sb.Append("  IFNULL( (SELECT dim.MAnufactureID FROM d_f_itemmaster im  INNER JOIN d_f_manufacture_master dim ON im.manufactureid=dim.ManufactureID    ");
        //sb.Append("  WHERE im.itemid=prq.itemid),(SELECT dim.MAnufactureID FROM d_f_itemmaster im  INNER JOIN f_manufacture_master dim ON im.manufactureid=dim.ManufactureID    ");
        //sb.Append("  WHERE im.itemid=prq.itemid) ) )Manufacturer   ");
        //sb.Append("  ,IF(prq.VendorID LIKE 'LSHHI%',(SELECT VendorName FROM f_vendormaster WHERE vendor_id=prq.VendorID),          ");
        //sb.Append("  IFNULL((SELECT ven.Vendorname FROM f_vendormaster ven INNER JOIN d_f_vendormaster dven ON ven.vendor_id=dven.vendor_idMain       ");
        //sb.Append("  WHERE dven.Vendor_id=prq.VendorID),(SELECT VendorName FROM d_f_vendormaster ven  WHERE ven.Vendor_id=prq.VendorID)))VendorName   ");
        //sb.Append("  ,IF(prq.VendorID LIKE 'LSHHI%',(SELECT Vendor_ID FROM f_vendormaster WHERE vendor_id=prq.VendorID),          ");
        //sb.Append("  IFNULL((SELECT ven.Vendor_ID FROM f_vendormaster ven INNER JOIN d_f_vendormaster dven ON ven.vendor_id=dven.vendor_idMain       ");
        //sb.Append("  WHERE dven.Vendor_id=prq.VendorID),(SELECT Vendor_ID FROM d_f_vendormaster ven  WHERE ven.Vendor_id=prq.VendorID)))Vendor,  ");
        //sb.Append("  ManufactureQuotNo,QuotationRefNo,RefrenceNo  FROM f_purchase_Quotation prq WHERE  QuotationRefNo='" + Util.GetString(txtQuotationNo.Text.ToString()) + "' GROUP BY RefrenceNo  ");
        //Shatrughan 24.05.14

        sb.Append("  SELECT * FROM (SELECT prq.QuotationID,fmm.NAME ManufacturerName,fmm.MAnufactureID Manufacturer,ven.Vendorname,prq.VendorID Vendor, ");
        sb.Append(" ManufactureQuotNo,QuotationRefNo,RefrenceNo  FROM f_purchase_Quotation prq INNER JOIN f_itemmaster im ON prq.ItemID=im.ItemID INNER JOIN  ");
        sb.Append(" f_vendormaster ven ON ven.vendor_id=prq.VendorID INNER JOIN ");
        sb.Append(" f_manufacture_master fmm ON fmm.ManufactureID=im.manufactureid WHERE  QuotationRefNo='" + Util.GetString(txtQuotationNo.Text.ToString()) + "' ");
        sb.Append(" ORDER BY prq.QuotationID  )t  GROUP BY RefrenceNo ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            mpequotnew.Show();
            grdVendorQuotationnew.DataSource = dt;
            grdVendorQuotationnew.DataBind();
        }
        else
        {
            grdVendorQuotationnew.DataSource = null;
            grdVendorQuotationnew.DataBind();
        }
    }

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubcategory();
        BindItemNew();

        ddlSubCategory.Focus();
        if (ViewState["RefDate"] != null)
        {
            refdate.Text = Util.GetDateTime(refdate.Text).ToString("yyyy-MM-dd");
            refdate.Text = (ViewState["RefDate"].ToString());
        }
    }

    protected void ddlItem_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ViewState["RefDate"] != null)
        {
            refdate.Text = Util.GetDateTime(refdate.Text).ToString("yyyy-MM-dd");
            refdate.Text = (ViewState["RefDate"].ToString());
        }
    }

    protected void ddlSubCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItemNew();

        if (ddlSubCategory.SelectedItem.Value != "0")
        {
            lstItem.Focus();
        }
        else
        {
            btnSaveQuto.Focus();
        }
        if (ViewState["RefDate"] != null)
        {
            refdate.Text = Util.GetDateTime(refdate.Text).ToString("yyyy-MM-dd");
            refdate.Text = (ViewState["RefDate"].ToString());
        }
    }

    protected void grdItemQuto_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToUpper() == "REMOVE")
        {
            DataTable dtitem = (DataTable)ViewState["dtItems"];
            DataRow dr = dtitem.Rows[Util.GetInt(e.CommandArgument)];
            dtitem.Rows.Remove(dr);
            dtitem.AcceptChanges();
            ViewState["dtItems"] = dtitem;
            if (dtitem.Rows.Count > 0)
            {
                grdItemQuto.DataSource = dtitem;
                grdItemQuto.DataBind();
            }
            else
            {
                grdItemQuto.DataSource = null;
                grdItemQuto.DataBind();
            }
            if (dtitem.Rows.Count == 0)
            {
                ddlVendor.Enabled = true;
                txtQuotationNo.Enabled = true;
                ddlCategory.Enabled = true;
                btnSaveQuto.Visible = false;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            refdate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            BindVendor();
            BindCategoryNew();
            BindSubcategory();
            BindItemNew();

            BindTax();
            ddlVendor.Focus();
        }
        refdate.Attributes.Add("readonly", "true");
        calFromDate.EndDate = DateTime.Now;
    }

    private void BindItemNew()
    {
        lstItem.DataSource = null;
        lstItem.DataBind();

        string str = "select TypeName,ItemId from f_itemmaster IM  INNER JOIN " +
            " f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON " +
            " SM.CategoryID = CR.CategoryID WHERE CR.ConfigID IN (11,28) AND im.IsActive=1 ";
        if (ddlSubCategory.SelectedItem.Value != "ALL")
        {
            str = str + " AND IM.subcategoryid='" + ddlSubCategory.SelectedItem.Value + "' ";
        }
        if (ddlCategory.SelectedItem.Value.Split('#')[0] != "0")
        {
            str = str + " AND SM.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0] + "' ";
        }
        str = str + " order by TypeName ";
        DataTable dt = StockReports.GetDataTable(str);
        lstItem.DataSource = dt;
        lstItem.DataTextField = "TypeName";
        lstItem.DataValueField = "ItemID";
        lstItem.DataBind();
    }

    private void BindSubcategory()
    {
        ddlSubCategory.DataSource = null;
        ddlSubCategory.DataBind();
        if (ddlCategory.SelectedItem.Value.Split('#')[0] != "0")
        {
            string str = "select Name,Subcategoryid from f_subcategorymaster where CategoryId='" + ddlCategory.SelectedItem.Value.Split('#')[0] + "'  AND active=1 ";
            DataTable dt = StockReports.GetDataTable(str);
            ddlSubCategory.DataSource = dt;
            ddlSubCategory.DataTextField = "name";
            ddlSubCategory.DataValueField = "SubCategoryid";
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Insert(0, new ListItem("ALL", "ALL"));
        }
        else
        {
            ddlSubCategory.Items.Clear();
            ddlSubCategory.DataSource = null;
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Insert(0, new ListItem("ALL", "ALL"));
        }
    }

    private void BindTax()
    {
        string strTax = "";
        strTax = "SELECT TM.TaxName,TM.TaxID,'' Tax,'' TaxAmt,IF(isPer=1,'true','false') AS isPer,IF(isAmt=1,'true','false') AS isAmt " +
            " FROM f_taxmaster TM ORDER BY TaxName";
        DataTable dtTax = new DataTable();

        dtTax = StockReports.GetDataTable(strTax);
        if (dtTax != null && dtTax.Rows.Count > 0)
        {
            grdTax.DataSource = dtTax;
            grdTax.DataBind();
        }
        ViewState["dtTax"] = dtTax;
    }

    private void BindVendor()
    {
        ddlVendor.Controls.Clear();
        string str = " SELECT Vendor_Id,vendorName FROM f_vendormaster  order by vendorName ";
        DataTable dt = StockReports.GetDataTable(str);
        ddlVendor.DataSource = dt;
        ddlVendor.DataTextField = "vendorName";
        ddlVendor.DataValueField = "Vendor_Id";
        ddlVendor.DataBind();
        ddlVendor.Items.Insert(0, new ListItem("Select", "0"));
    }

    private DataTable GetDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("ItemId", typeof(string)));
        dt.Columns.Add(new DataColumn("ItemName", typeof(string)));
        dt.Columns.Add(new DataColumn("Manufacturer", typeof(string)));
        dt.Columns.Add(new DataColumn("ManufacturerName", typeof(string)));
        dt.Columns.Add(new DataColumn("Rate", typeof(string)));
        dt.Columns.Add(new DataColumn("Qty", typeof(string)));
        dt.Columns.Add(new DataColumn("Discount", typeof(string)));
        dt.Columns.Add(new DataColumn("VendorID", typeof(string)));
        dt.Columns.Add(new DataColumn("VendorLedgerNo", typeof(string)));
        dt.Columns.Add(new DataColumn("VendorName", typeof(string)));
        dt.Columns.Add(new DataColumn("QuotationRefNo", typeof(string)));
        dt.Columns.Add(new DataColumn("RefDate", typeof(string)));
        dt.Columns.Add(new DataColumn("Remarks", typeof(string)));
        dt.Columns.Add(new DataColumn("Specification", typeof(string)));
        dt.Columns.Add(new DataColumn("Tax", typeof(string)));
        dt.Columns.Add(new DataColumn("TaxName", typeof(string)));
        dt.Columns.Add(new DataColumn("TaxID", typeof(string)));
        dt.Columns.Add(new DataColumn("TaxValue", typeof(string)));
        dt.Columns.Add(new DataColumn("TaxAmt", typeof(string)));
        dt.Columns.Add(new DataColumn("IsOld", typeof(int)));
        dt.Columns.Add(new DataColumn("MRP", typeof(float)));
        dt.Columns.Add(new DataColumn("SaltName", typeof(string)));
        dt.Columns.Add(new DataColumn("CostPrice", typeof(float)));
        dt.Columns.Add(new DataColumn("ManufactureQuotationNo", typeof(string)));
        dt.Columns.Add(new DataColumn("ModelNumber", typeof(string)));
        dt.Columns.Add(new DataColumn("DeliveryTime", typeof(string)));
        dt.Columns.Add(new DataColumn("PaymentPattern", typeof(string)));
        dt.Columns.Add(new DataColumn("AMC", typeof(decimal)));
        dt.Columns.Add(new DataColumn("OperationalCost", typeof(string)));
        dt.Columns.Add(new DataColumn("SilentFeatures", typeof(string)));
        dt.Columns.Add(new DataColumn("AdditionalFeatures", typeof(string)));
        dt.Columns.Add(new DataColumn("UploadStatus", typeof(int)));
        dt.Columns.Add(new DataColumn("URL", typeof(string)));
        ViewState["dtItems"] = dt;
        return dt;
    }
}