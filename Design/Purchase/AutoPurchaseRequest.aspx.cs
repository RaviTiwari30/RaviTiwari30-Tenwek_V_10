using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_Store_AutoPurchaseRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucDateFrom.Text = DateTime.Now.AddDays(-90).ToString("dd-MMM-yyyy");
            ucDateTo.Text = DateTime.Now.AddDays(0).ToString("dd-MMM-yyyy");
            if (ChkPermission())
            {
                string Msg = "You do not have rights to generate purchase request ";
                Response.Redirect("MsgPage.aspx?msg=" + Msg);
            }
            else
            {
                if (Session["DeptLedgerNo"] != null)
                    ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                if (Session["IsStore"] != null)
                    ViewState["IsStore"] = Session["IsStore"].ToString();
                else
                    ViewState["IsStore"] = "0";
            }

            LoadGroup();
            //if (System.DateTime.Now.Hour<14)
            //{
            //    btnExport.Visible = false;
            //    btnSave.Visible = false;
            //    btnSearch.Visible = false;
            //}
            //else
            //{
            //    btnExport.Visible = true;
            //    btnSave.Visible = true;
            //    btnSearch.Visible = true;
            //}
        }

    }
    protected bool ChkPermission()
    {
        return false;
        //string EmpId = Session["ID"].ToString();

        //string str = "select * from f_approvaltypemaster where ApprovalType='STO00001' and  ApprovalFor = 'PR' and empid = '" + EmpId + "'";
        //DataTable dt = StockReports.GetDataTable(str.ToString());
        //if (dt != null && dt.Rows.Count > 0)
        //{
        //    return false;
        //}
        //else { return true; }

    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        try
        {
            LoadData("Y");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (rdoTypeBasis.SelectedIndex == 0)
        {
            string a = StockReports.GetSelection(chkIndentStatus);
            if (string.IsNullOrEmpty(a))
            {
                lblMsg.Text = "Please Select Indent Status";
                return;
            }
        }
        if (rdoTypeBasis.SelectedIndex != 0 && rdoTypeBasis.SelectedIndex != 1 && rdoTypeBasis.SelectedIndex != 2 && rdoTypeBasis.SelectedIndex != 3)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Please Select One Type..";
            return;
        }
        LoadData("N");
    }

    private void LoadData(string IsExport)
    {
        StringBuilder sb = new StringBuilder();
        string subcat = StockReports.GetSelection(chkSubCat);
        try
        {
            if (rdoTypeBasis.SelectedItem.Value == "IndentBasis")
            {
                sb.Append("SELECT NAME,BalQty,im.MinLimit,im.ReorderLevel,im.ReorderQty,im.ItemID,im.UnitType AS Unit,im.SubCategoryID,");
                sb.Append("(IFNULL((SELECT SUM(InitialCount-ReleasedCount)");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb.Append(" FROM f_stock ");
                else
                    sb.Append(" FROM f_nmstock ");
                sb.Append(" WHERE ItemID=t.ItemID AND InitialCount-ReleasedCount>0 AND ispost=1 AND DATE(MedExpiryDate)>CURDATE() GROUP BY ITemID ),0)+ifNull((SELECT SUM(pd.ApprovedQty - pd.RecievedQty) FROM f_purchaseorderdetails pd INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo = pd.PurchaseOrderNo WHERE pd.ItemID=im.ItemID AND pd.approved=1 AND pd.STATUS=0 AND po.status=2),0))Hosp_stk,");
                sb.Append("(IFNULL((SELECT SUM(InitialCount-ReleasedCount)");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb.Append(" FROM f_stock WHERE ItemID=t.ItemID AND DeptLedgerNo='" + AllGlobalFunction.MedicalDeptLedgerNo + "' ");
                else
                    sb.Append(" FROM f_nmstock WHERE ItemID=t.ItemID AND DeptLedgerNo='" + AllGlobalFunction.GeneralDeptLedgerNo + "' ");
                sb.Append(" AND InitialCount-ReleasedCount>0 AND ispost=1 GROUP BY ItemID ),0)+ifNull((SELECT SUM(pd.ApprovedQty - pd.RecievedQty) FROM f_purchaseorderdetails pd INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo = pd.PurchaseOrderNo WHERE pd.ItemID=im.ItemID AND pd.approved=1 AND pd.STATUS=0 AND po.status=2),0))MS_stk,");
                sb.Append("IFNULL((SELECT RequestedQty FROM f_purchaserequestdetails WHERE STATUS=0 AND ItemID=t.ItemID ORDER BY PuschaseRequistionDetailID DESC LIMIT 1  ),0)PRQty  FROM ");
                sb.Append("(");
                sb.Append(" SELECT id.ItemID,id.ItemName NAME,SUM(id.reqQty)ReqQty,id.IsPRGenerated,SUM(id.ReceiveQty)ReceiveQty,SUM(id.RejectQty)RejectQty,SUM(ReqQty- (ReceiveQty))BalQty FROM f_indent_detail id");
                if (subcat != "")
                    sb.Append(" INNER JOIN f_Itemmaster im on im.ItemID=id.ItemID AND im.subcategoryID in (" + subcat + ") ");
                sb.Append("     WHERE DATE(id.dtEntry) >= '" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(id.dtEntry) <='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb.Append(" AND id.StoreID = 'STO00001'");
                else
                    sb.Append(" AND id.StoreID = 'STO00002'");
                sb.Append("     GROUP BY ITemID");
                sb.Append(")t INNER JOIN f_itemmaster im ON im.ItemID = t.ITemID");
                sb.Append(" Where t.ItemID is not null AND ( ");
                string StrQ = "";
                for (int i = 0; i < chkIndentStatus.Items.Count; i++)
                {
                    if (chkIndentStatus.Items[i].Selected && chkIndentStatus.Items[i].Text == "Open")
                    {
                        if (StrQ == "")
                            StrQ += " (ReceiveQty+RejectQty)=0 ";
                    }
                    if (chkIndentStatus.Items[i].Selected && chkIndentStatus.Items[i].Text == "Reject")
                    {
                        if (StrQ == "")
                            StrQ += " RejectQty=ReqQty  ";
                        else
                            StrQ += " OR RejectQty=ReqQty  ";
                    }
                    if (chkIndentStatus.Items[i].Selected && chkIndentStatus.Items[i].Text == "Partial")
                    {
                        if (StrQ == "")
                            StrQ += " ReqQty > (ReceiveQty+RejectQty)";
                        else
                            StrQ += " or  ReqQty > (ReceiveQty+RejectQty)";
                    }
                }
                sb.Append("" + StrQ + " ) AND t.IsPRGenerated=0 ");
                sb.Append(" Union All ");
                sb.Append("SELECT NAME,BalQty,im.MinLimit,im.ReorderLevel,im.ReorderQty,im.ItemID,im.UnitType AS Unit,im.SubCategoryID,");
                sb.Append("(IFNULL((SELECT SUM(InitialCount-ReleasedCount)");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb.Append(" FROM f_stock ");
                else
                    sb.Append(" FROM f_nmstock ");
                sb.Append(" WHERE ItemID=t.ItemID AND InitialCount-ReleasedCount>0 AND ispost=1 AND DATE(MedExpiryDate)>CURDATE() GROUP BY ITemID ),0)+ifNull((SELECT SUM(pd.ApprovedQty - pd.RecievedQty) FROM f_purchaseorderdetails pd INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo = pd.PurchaseOrderNo WHERE pd.ItemID=im.ItemID AND pd.approved=1 AND pd.STATUS=0 AND po.status=2),0))Hosp_Stk, ");
                sb.Append("(IFNULL((SELECT SUM(InitialCount-ReleasedCount)");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb.Append(" FROM f_stock WHERE ItemID=t.ItemID AND DeptLedgerNo='" + AllGlobalFunction.MedicalDeptLedgerNo + "' ");
                else
                    sb.Append(" FROM f_nmstock WHERE ItemID=t.ItemID AND DeptLedgerNo='" + AllGlobalFunction.GeneralDeptLedgerNo + "' ");
                sb.Append(" AND InitialCount-ReleasedCount>0 AND ispost=1 GROUP BY ITemID ),0)+ifNull((SELECT SUM(pd.ApprovedQty - pd.RecievedQty) FROM f_purchaseorderdetails pd INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo = pd.PurchaseOrderNo WHERE pd.ItemID=im.ItemID AND pd.approved=1 AND pd.STATUS=0 AND po.status=2),0))MS_Stk,");
                sb.Append("IFNULL((SELECT RequestedQty FROM f_purchaserequestdetails WHERE STATUS=0 AND ItemID=t.ItemID ORDER BY PuschaseRequistionDetailID DESC LIMIT 1  ),0)PRQty  FROM ");
                sb.Append("(");
                sb.Append("     SELECT idp.ItemID,idp.ItemName NAME,SUM(idp.reqQty)ReqQty,idp.IsPRGenerated,SUM(idp.ReceiveQty)ReceiveQty,SUM(idp.RejectQty)RejectQty,SUM(ReqQty- (ReceiveQty))BalQty FROM f_indent_detail_patient idp");
                if (subcat != "")
                    sb.Append(" INNER JOIN f_Itemmaster im on im.ItemID=idP.ItemID AND im.subcategoryID in (" + subcat + ") ");
                sb.Append("     WHERE DATE(idp.dtEntry) >= '" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(idp.dtEntry) <='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb.Append(" AND idp.StoreID = 'STO00001'");
                else
                    sb.Append(" AND idp.StoreID = 'STO00002'");
                sb.Append("     GROUP BY ITemID ");
                sb.Append(" )t INNER JOIN f_itemmaster im ON im.ItemID = t.ITemID");
                sb.Append(" Where t.ItemID is not null AND ( ");
                string StrQr = "";
                for (int i = 0; i < chkIndentStatus.Items.Count; i++)
                {
                    if (chkIndentStatus.Items[i].Selected && chkIndentStatus.Items[i].Text == "Open")
                    {
                        if (StrQr == "")
                            StrQr += " (ReceiveQty+RejectQty)=0 ";
                    }
                    if (chkIndentStatus.Items[i].Selected && chkIndentStatus.Items[i].Text == "Reject")
                    {
                        if (StrQr == "")
                            StrQr += " RejectQty=ReqQty  ";
                        else
                            StrQr += " OR RejectQty=ReqQty  ";
                    }
                    if (chkIndentStatus.Items[i].Selected && chkIndentStatus.Items[i].Text == "Partial")
                    {
                        if (StrQr == "")
                            StrQr += " ReqQty > (ReceiveQty+RejectQty)";
                        else
                            StrQr += " or  ReqQty > (ReceiveQty+RejectQty)";
                    }
                }
                sb.Append("" + StrQr + " ) AND t.IsPRGenerated=0 order by NAME");
            }
            else if (rdoTypeBasis.SelectedItem.Value == "MinStockBasis")
            {
                sb.Append("Select t.*, ");
                sb.Append("IFNULL((SELECT RequestedQty FROM f_purchaserequestdetails WHERE STATUS=0 AND ItemID=t.ItemID ");
                sb.Append("ORDER BY PuschaseRequistionDetailID DESC LIMIT 1  ),0)PRQty FROM ( ");
                sb.Append("SELECT im.TypeName NAME,st.SubCategoryID, st.ItemID,im.UnitType Unit,(Hosp_Stk+ifNull((SELECT SUM(pd.ApprovedQty - pd.RecievedQty) FROM f_purchaseorderdetails pd INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo = pd.PurchaseOrderNo WHERE pd.ItemID=im.ItemID AND pd.approved=1 AND pd.STATUS=0 AND po.status=2),0))Hosp_Stk,");
                sb.Append("(MS_Stk+ifNull((SELECT SUM(pd.ApprovedQty - pd.RecievedQty) FROM f_purchaseorderdetails pd INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo = pd.PurchaseOrderNo WHERE pd.ItemID=im.ItemID AND pd.approved=1 AND pd.STATUS=0 AND po.status=2),0))MS_Stk,BalQty, ");
                sb.Append(" IFNULL(im.MinLimit,0)MinLimit,im.ReorderLevel,im.ReorderQty From ");
                StringBuilder sb1 = new StringBuilder();
                StockReports.ExecuteDML("Drop table if exists tblstock_" + Session["ID"].ToString());
                sb1.Append("Create table tblstock_" + Session["ID"].ToString() + " as ");
                sb1.Append("    SELECT SUM(st.InitialCount-st.ReleasedCount)Hosp_Stk,SUM(st.InitialCount-st.ReleasedCount)BalQty,st.ItemID,st.SubCategoryID, ");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb1.Append(" SUM(if(st.DeptLedgerNo='" + AllGlobalFunction.MedicalDeptLedgerNo + "',st.InitialCount-st.ReleasedCount,0))MS_Stk ");
                else
                    sb1.Append(" SUM(if(st.DeptLedgerNo='" + AllGlobalFunction.GeneralDeptLedgerNo + "',st.InitialCount-st.ReleasedCount,0))MS_Stk ");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb1.Append(" FROM f_stock ST ");
                else
                    sb1.Append(" FROM f_nmstock ST ");

                if (subcat != "")
                    sb1.Append(" INNER JOIN f_subcategorymaster sc on sc.subcategoryID=st.subcategoryID AND sc.subcategoryID in (" + subcat + ") ");

                sb1.Append("WHERE  (st.InitialCount-st.ReleasedCount)>0 AND st.MedExpiryDate>=CURDATE() AND st.IsPost=1 GROUP BY st.ItemID ");
                StockReports.ExecuteDML(sb1.ToString());
                StockReports.ExecuteDML("Alter Table tblstock_" + Session["ID"].ToString() + " add index indItemid(ItemID),add index indSubCategoryID(SubCategoryID)");
                sb.Append(" tblstock_" + Session["ID"].ToString() + " st ");
                sb.Append("INNER JOIN f_itemmaster im ON st.ItemID = im.ItemID )t ");
                sb.Append("WHERE MS_Stk<MinLimit ORDER BY t.subcategoryID,t.Name ");
            }
            else if (rdoTypeBasis.SelectedItem.Value == "RolBasis")
            {
                sb.Append("Select t.*, ");
                sb.Append("IFNULL((SELECT RequestedQty FROM f_purchaserequestdetails WHERE STATUS=0 AND ItemID=t.ItemID ");
                sb.Append("ORDER BY PuschaseRequistionDetailID DESC LIMIT 1  ),0)PRQty FROM ( ");
                sb.Append("SELECT im.TypeName NAME,st.SubCategoryID, st.ItemID,im.UnitType Unit,(ifNull((SELECT SUM(ApprovedQty) FROM f_purchaseorderdetails WHERE approved=1 AND STATUS=0 AND ItemID=im.ItemID),0)+Hosp_stk)Hosp_stk,");
                sb.Append("(MS_Stk+ifNull((SELECT SUM(pd.ApprovedQty - pd.RecievedQty) FROM f_purchaseorderdetails pd INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo = pd.PurchaseOrderNo WHERE pd.ItemID=im.ItemID AND pd.approved=1 AND pd.STATUS=0 AND po.status=2),0))MS_Stk,BalQty, ");
                sb.Append("IFNULL(im.MinLimit,0)MinLimit,im.ReorderLevel,im.ReorderQty ");
                sb.Append("FROM ");
                StringBuilder sb1 = new StringBuilder();
                StockReports.ExecuteDML("Drop table if exists tblstock_" + Session["ID"].ToString());
                sb1.Append("Create table tblstock_" + Session["ID"].ToString() + " as ");
                sb1.Append("    SELECT SUM(st.InitialCount-st.ReleasedCount)Hosp_stk,SUM(st.InitialCount-st.ReleasedCount)BalQty,st.ItemID,st.SubcategoryID, ");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb1.Append(" SUM(if(st.DeptLedgerNo='" + AllGlobalFunction.MedicalDeptLedgerNo + "',st.InitialCount-st.ReleasedCount,0))MS_Stk ");
                else
                    sb1.Append(" SUM(if(st.DeptLedgerNo='" + AllGlobalFunction.GeneralDeptLedgerNo + "',st.InitialCount-st.ReleasedCount,0))MS_Stk ");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb1.Append(" FROM f_stock st ");
                else
                    sb1.Append(" FROM f_nmstock st ");
                if (subcat != "")
                    sb1.Append(" INNER JOIN f_subcategorymaster sc on sc.subcategoryID=st.subcategoryID AND sc.subcategoryID in (" + subcat + ") ");
                sb1.Append("WHERE  (st.InitialCount-st.ReleasedCount)>0 AND st.MedExpiryDate>=CURDATE() AND st.IsPost=1 GROUP BY st.ItemID ");
                StockReports.ExecuteDML(sb1.ToString());
                StockReports.ExecuteDML("Alter Table tblstock_" + Session["ID"].ToString() + " add index indItemid(ItemID),add index indsubcat(SubCategoryID)");
                sb.Append(" tblstock_" + Session["ID"].ToString() + " st ");
                sb.Append("INNER JOIN f_itemmaster im ON st.ItemID = im.ItemID )t ");
                sb.Append("WHERE MS_Stk<ReorderLevel ORDER BY t.subcategoryID,t.Name ");
            }
            else
            {
                sb.Append("   SELECT t.* ");
                sb.Append("   FROM ( ");
                sb.Append("       SELECT im.ItemID,im.TypeName NAME,im.UnitType Unit,st.SubcategoryID, ");
                sb.Append("       IFNULL((SELECT ROUND(SUM(RequestedQty),2) FROM f_purchaserequestdetails WHERE STATUS=0 AND Approved=1 AND ItemID=im.ItemID ");
                sb.Append("       ORDER BY PuschaseRequistionDetailID DESC),0)PRQty , ");
                sb.Append("       (IFNULL((SELECT SUM(ApprovedQty) ");
                sb.Append("       FROM f_purchaseorderdetails WHERE approved=1 AND STATUS=0 AND ItemID=im.ItemID),0)+Hosp_stk)Hosp_stk, ");
                sb.Append("       (MS_Stk+IFNULL((SELECT SUM(pd.ApprovedQty - pd.RecievedQty) FROM f_purchaseorderdetails pd ");
                sb.Append("       INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo = pd.PurchaseOrderNo ");
                sb.Append("       WHERE pd.ItemID=im.ItemID AND pd.approved=1 AND pd.STATUS=0 AND po.status=2),0))MS_Stk,BalQty, ");
                sb.Append("       IFNULL(im.MinLimit,0)MinLimit,st.ReorderLevel,st.ReorderQty,st.PPR,st.PPO,st.StockInHand ");
                sb.Append("       FROM f_itemmaster im 	");
                sb.Append("       INNER JOIN ( ");
                sb.Append("   SELECT IFNULL(SUM(st.InitialCount-st.ReleasedCount),0)Hosp_stk,SUM(st.InitialCount-st.ReleasedCount)BalQty,SUM(IF(st.DeptLedgerNo='LSHHI17',st.InitialCount-st.ReleasedCount,0))MS_Stk,st.ItemID,st.SubcategoryID, ");
                sb.Append("   CROL.ROL ReorderLevel,CROL.PRQ ReorderQty,CROL.PPR,CROL.PPO,CROL.StockInHand ");
                sb.Append("   FROM tblConsumptionROL CROL ");
                if (rdoGroupList.SelectedItem.Value != "1")
                    sb.Append("   LEFT JOIN f_stock st ON CROl.Itemid=st.ItemID ");
                else
                    sb.Append("   LEFT JOIN f_nmstock st ON CROl.Itemid=st.ItemID ");
                if (subcat != "")
                    sb.Append(" INNER JOIN f_subcategorymaster sc on sc.subcategoryID=st.subcategoryID AND sc.subcategoryID in (" + subcat + ") ");
                sb.Append("   GROUP BY st.ItemID ");
                sb.Append("     )  st ON im.ItemID=st.ItemID");
                sb.Append(" )t 	 ");
                //sb.Append(" WHERE MS_Stk+PRQty<ReorderLevel ORDER BY t.Name  ");
                sb.Append(" WHERE StockInHand+PPR+PPO<ReorderLevel ORDER BY t.Name  ");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0 && dt != null)
            {
                if (IsExport == "N")
                {
                    grdViewPendingIndent.DataSource = dt;
                    grdViewPendingIndent.DataBind();
                    ViewState["dtSearch"] = dt;

                    if (rdoTypeBasis.SelectedItem.Value != "IndentBasis")
                        grdViewPendingIndent.Columns[9].Visible = false;
                    else
                        grdViewPendingIndent.Columns[9].Visible = true;
                }
                else
                {
                    Session["dtExport2Excel"] = dt;
                    Session["ReportName"] = "Auto PR Report";
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('/Design/Finanace/ExportToExcel.aspx');", true);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);

                }
            }
            else
            {
                grdViewPendingIndent.DataSource = null;
                grdViewPendingIndent.DataBind();
                ViewState["dtSearch"] = null;
                return;
            }
        }
        catch (Exception ex)
        {
            grdViewPendingIndent.DataSource = null;
            grdViewPendingIndent.DataBind();
            ViewState["dtSearch"] = null;
            lblMsg.Visible = true;
            lblMsg.Text = "Error..";
            return;
        }
    }

    protected void AllCheckChanged(object sender, EventArgs e)
    {
        CheckBox headerCheckBox = (sender as CheckBox);
        if (grdViewPendingIndent.Rows.Count > 0)
        {
            for (int i = 0; i < grdViewPendingIndent.Rows.Count; i++)
            {
                ((CheckBox)grdViewPendingIndent.Rows[i].FindControl("chkSelect")).Checked = headerCheckBox.Checked;
            }

        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string PRNo = SaveRequest();
        if (PRNo != string.Empty)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Request No : " + PRNo + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='AutoPurchaseRequest.aspx';", true);
        }
    }
    private DataTable GetItemDataTable()
    {
        if (ViewState["dtItems"] != null)
        {
            return (DataTable)ViewState["dtItems"];
        }
        else
        {
            DataTable dtItem = new DataTable();
            dtItem.Columns.Add("ItemID");
            dtItem.Columns.Add("ItemName");
            dtItem.Columns.Add("SubCategory");
            dtItem.Columns.Add("Unit");
            dtItem.Columns.Add("RequiredQty");
            dtItem.Columns.Add("Purpose");
            dtItem.Columns.Add("Specification");
            return dtItem;
        }
    }

    #region Generate Purchase Request

    private string SaveRequest()
    {

        DataTable dtItems = GetItemDataTable();
        for (int i = 0; i < grdViewPendingIndent.Rows.Count; i++)
        {
            if (((CheckBox)grdViewPendingIndent.Rows[i].FindControl("chkSelect")).Checked)
            {
                DataRow row = dtItems.NewRow();
                row["ItemID"] = ((Label)grdViewPendingIndent.Rows[i].FindControl("lblItemId")).Text;
                row["ItemName"] = ((Label)grdViewPendingIndent.Rows[i].FindControl("lblItemName")).Text;
                row["SubCategory"] = ((Label)grdViewPendingIndent.Rows[i].FindControl("lblSubCatId")).Text;
                row["Unit"] = ((Label)grdViewPendingIndent.Rows[i].FindControl("lblUnitType")).Text;
                row["RequiredQty"] = ((TextBox)grdViewPendingIndent.Rows[i].FindControl("txtReqQty")).Text.Trim();
                row["Purpose"] = ((TextBox)grdViewPendingIndent.Rows[i].FindControl("txtPurpose")).Text.Trim();
                row["Specification"] = ((TextBox)grdViewPendingIndent.Rows[i].FindControl("txtSpecification")).Text.Trim();
                dtItems.Rows.Add(row);
            }
        }

        if (dtItems.Rows.Count > 0)
        {
            string PRNo = string.Empty;
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                string date = string.Empty;
                date = "0001-01-01";

                PurchaseRequestMaster PRMst = new PurchaseRequestMaster(Tranx);
                PRMst.RaisedByID = Convert.ToString(Session["ID"]);
                PRMst.RaisedByName = Convert.ToString(Session["UserName"]);
                PRMst.RaisedDate = DateTime.Now;
                PRMst.Status = 0;
                PRMst.Approved = 0;
                PRMst.CentreID = Util.GetInt(Session["CentreID"].ToString());
                PRMst.Remarks = string.Empty;
                PRMst.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                PRMst.IssuedTo = ViewState["DeptLedgerNo"].ToString();
                if (rdoGroupList.SelectedItem.Value != "1")
                {
                    PRMst.StoreID = "STO00001";
                }
                else
                {
                    PRMst.StoreID = "STO00002";
                }
                PRMst.Subject = txtNarration.Text.Trim().Replace("'", "''");
                PRMst.bydate = date;
                //PRMst.Type = ddlRequestType.SelectedItem.Text;
                //PRMst.DeptLedgerNo = ddlDept.SelectedValue;
                // PRMst.bydate = date;
                PRNo = PRMst.Insert();

                if (PRNo != string.Empty)
                {
                    foreach (DataRow dr in dtItems.Rows)
                    {
                        string str = string.Empty;
                        if (rdoGroupList.SelectedValue != "1")
                            str = "Call Insert_PurchaseRequestDetail('" + PRNo + "','" + Util.GetString(dr["ItemID"]) + "','" + Util.GetString(dr["ItemName"]).Replace("'", "''") + "','" + Util.GetString(dr["SubCategory"]) + "'," + Util.GetDecimal(dr["RequiredQty"]) + "," + Util.GetDecimal(dr["RequiredQty"]) + ",0,'" + Util.GetString(dr["Specification"]) + "','" + Util.GetString(dr["Purpose"]) + "',0,'" + Util.GetString(dr["Unit"]) + "','','Purchase','" + PRMst.DeptLedgerNo + "','" + Util.GetString(Session["HOSPID"].ToString()) + "','" + PRMst.CentreID + "');";
                        else
                            str = "Call Insert_NMPurchaseRequestDetail('" + PRNo + "','" + Util.GetString(dr["ItemID"]) + "','" + Util.GetString(dr["ItemName"]).Replace("'", "''") + "','" + Util.GetString(dr["SubCategory"]) + "'," + Util.GetDecimal(dr["RequiredQty"]) + "," + Util.GetDecimal(dr["RequiredQty"]) + ",0,'" + Util.GetString(dr["Specification"]) + "','" + Util.GetString(dr["Purpose"]) + "',0,'" + Util.GetString(dr["Unit"]) + "',''," + PRMst.CentreID + ",'" + Util.GetString(Session["HOSPID"].ToString()) + "');";

                        int result = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, str));

                        if (result < 1)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            lblMsg.Text = "Error...";
                            return string.Empty;
                        }
                        string strQry = "Update f_indent_detail SET IsPRGenerated=1 WHERE IsPRGenerated=0 AND ItemID='" + Util.GetString(dr["ItemID"]) + "'";
                        MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, strQry);
                    }
                    Tranx.Commit();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    //Clear();
                    lblMsg.Text = string.Empty;
                    return PRNo;
                }
                else
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    lblMsg.Text = "Error...";
                    return string.Empty;
                }
            }
            catch (Exception ex)
            {

                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = "Error...";
                return string.Empty;

            }
        }
        else
        {
            lblMsg.Text ="Please Select Atleast One Requested Items..";
            return string.Empty;
        }



    #endregion
    }
    protected void rdoTypeBasis_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdoTypeBasis.SelectedItem.Value == "IndentBasis")
        {
            chkIndentStatus.Visible = true;
        }
        else
            chkIndentStatus.Visible = false;
        grdViewPendingIndent.DataSource = null;
        grdViewPendingIndent.DataBind();
    }
    protected void rdoGroupList_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadGroup();
    }

    private void LoadGroup()
    {
        string IsMed = "11";
        if (rdoGroupList.SelectedValue == "1") IsMed = "28";

        DataTable dt = StockReports.GetDataTable("Select sc.name,sc.subcategoryId from f_subcategorymaster sc inner join f_configrelation cf on cf.categoryid = sc.categoryid where sc.active=1 and cf.ConfigID=" + IsMed);

        if (dt != null && dt.Rows.Count > 0)
        {
            chkSubCat.DataSource = dt;
            chkSubCat.DataTextField = "Name";
            chkSubCat.DataValueField = "subcategoryId";
            chkSubCat.DataBind();
        }
        else
        {
            chkSubCat.DataSource = null;
            chkSubCat.DataBind();
        }

    }
    protected void grdViewPendingIndent_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            int Index = 0;
            Index = Util.GetInt(e.CommandArgument);
            DataTable dt = ((DataTable)ViewState["dtSearch"]);
            dt.Rows.RemoveAt(Index);
            dt.AcceptChanges();
            ViewState["dtSearch"] = dt;
            grdViewPendingIndent.DataSource = dt;
            grdViewPendingIndent.DataBind();
        }
    }
}