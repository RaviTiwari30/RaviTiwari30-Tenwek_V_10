using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Purchase_PurchaseSummaryReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        string StoreLedgerNo = "", TypeofTnx = "";
        if (rdbgrp.SelectedItem.Value == "11")
        {
            StoreLedgerNo = "'STO00001'";
            TypeofTnx = "'Purchase'";
        }
        else if (rdbgrp.SelectedItem.Value == "28")
        {
            StoreLedgerNo = "'STO00002'";
            TypeofTnx = "'NMPurchase'";
        }
        else
        {
            StoreLedgerNo = "'STO00001','STO00002'";
            TypeofTnx = "'Purchase','NMPurchase'";
        }

        sb.Append(" SELECT   im.typename ItemName, sm.Name GroupName,  ");
        sb.Append(" st.BatchNumber, im.Manufacturer, st.InitialCount Quantity, st.UnitPrice Rate,   ");
        sb.Append(" round((st.UnitPrice*st.InitialCount),2) NetAmt, DATE_format(st.PostDate,'%d-%b-%Y') PostDate,'Medical Store' StoreType,   ");
        sb.Append(" st.Naration, lm.LedgerName Supplier  , ");
        sb.Append(" (SELECT ROUND( IF (SUM(IF(TrasactionTypeID IN(3,13),SoldUnits,0))>SUM(IF(TrasactionTypeID IN(5,14),SoldUnits,0)),(SUM(IF(TrasactionTypeID IN(3,13),SoldUnits,0)) - SUM(IF(TrasactionTypeID IN(5,14),SoldUnits,0))),0))");
        sb.Append(" FROM f_salesdetails  WHERE DATE<='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE>=ADDDATE('" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "',-60) AND  ");
        sb.Append(" Itemid=im.itemid AND  TrasactionTypeID IN(5,14,3,13) AND   ");
        sb.Append(" StoreLedgerNo IN (" + StoreLedgerNo + ") ");
        sb.Append(" ) Avg_Cosmp, ");
        sb.Append(" (SELECT ROUND(IF(SUM(IF(TrasactionTypeID IN(3,13),SoldUnits,0))>SUM(IF(TrasactionTypeID IN(5,14),SoldUnits,0)),((SUM(IF(TrasactionTypeID IN(3,13),SoldUnits,0)) - SUM(IF(TrasactionTypeID IN(5,14),SoldUnits,0)))/2),0)) ");
        sb.Append(" FROM f_salesdetails  WHERE DATE<='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE>=ADDDATE('" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "',-30) AND  ");
        sb.Append(" Itemid=im.itemid AND  TrasactionTypeID IN(5,14,3,13) AND  ");
        sb.Append(" StoreLedgerNo IN (" + StoreLedgerNo + ") ");
        sb.Append("  ) Last_Mon_Cosmp, (SELECT SUM(st.InitialCount-st.ReleasedCount)Whole_Hosp_Stock FROM f_stock st WHERE st.ispost=1 AND ");
        sb.Append(" (st.InitialCount-st.ReleasedCount)>0 and Date(st.MedExpiryDate)>CurDate() AND StoreLedgerNo IN (" + StoreLedgerNo + "))Whole_Hosp_Stock ,");
        sb.Append(" (SELECT SUM(st.InitialCount-st.ReleasedCount) FROM f_stock st WHERE st.ispost=1 AND ");
        sb.Append(" (st.InitialCount-st.ReleasedCount)>0 and Date(st.MedExpiryDate)>CurDate() and StoreLedgerNo IN (" + StoreLedgerNo + "))MedStore_Stock ");
        sb.Append(" FROM f_stock st   ");
        sb.Append(" INNER JOIN f_itemmaster im ON st.itemid = im.itemid   ");
        sb.Append(" INNER JOIN f_subcategorymaster sm  ON im.SubCategoryID = sm.SubCategoryID   ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=st.LedgerTransactionNo   ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON  lm.LedgerNumber=lt.LedgerNoCr   ");
        sb.Append(" WHERE IsFree = 0  AND IsPost = 1  AND IsReturn = 0   ");
        sb.Append(" AND st.StoreLedgerNo IN (" + StoreLedgerNo + ") ");
        sb.Append(" AND lt.TypeOfTnx IN (" + TypeofTnx + ")");
        sb.Append("  AND DATE(st.PostDate) BETWEEN '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'  ");
        sb.Append("  AND '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");

        if (ddlGroup.SelectedItem.Value != "All")
            sb.Append(" AND im.SubCategoryID = '" + ddlGroup.SelectedValue + "'  ");

        if (ddlItem.SelectedItem.Value != "All")
            sb.Append(" AND im.ItemID='" + ddlItem.SelectedValue + "' ");

        if (rbtBilled.SelectedItem.Value != "All")
            sb.Append(" and im.ToBeBilled='" + rbtBilled.SelectedItem.Value + "' ");

        if (rbtType.SelectedItem.Value != "All")
            sb.Append(" and im.Type_ID='" + rbtType.SelectedItem.Value + "' ");

        sb.Append("  ORDER BY st.postdate,im.typename  ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            Session["Period"] = "From : " + ucFromDate.Text + " To : " + ucToDate.Text;
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Purchase Summary Report";
            Session["Period"] = "From " + ucFromDate.Text + " to " + ucToDate.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            lblMsg.Text = "";
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }

    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();
        rdbgrp.Items[0].Enabled = false;
        rdbgrp.Items[1].Enabled = false;
        rdbgrp.Items[2].Enabled = false;

        DataTable dt = StockReports.GetRights(RoleId);
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "true")
            {
                rdbgrp.Items[0].Enabled = true;
                rdbgrp.Items[1].Enabled = true;
                rdbgrp.Items[2].Enabled = true;
                rdbgrp.Items[1].Selected = true;
            }
            else if (dt.Rows[0]["IsMedical"].ToString() == "true" || dt.Rows[0]["IsGeneral"].ToString() == "true")
            {
                if (dt.Rows[0]["IsMedical"].ToString() == "true")
                {
                    rdbgrp.Items[0].Enabled = false;
                    rdbgrp.Items[1].Enabled = true;
                    rdbgrp.Items[2].Enabled = false;
                    rdbgrp.Items[1].Selected = true;
                }
                else if (dt.Rows[0]["IsGeneral"].ToString() == "true")
                {
                    rdbgrp.Items[0].Enabled = false;
                    rdbgrp.Items[1].Enabled = false;
                    rdbgrp.Items[2].Enabled = true;
                    rdbgrp.Items[2].Selected = true;
                }
            }
            else if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "false")
            {
                string Msg = "You do not have rights to Open this report ";
                Response.Redirect("../Purchase/MsgPage.aspx?msg=" + Msg);
            }
            return false;
        }
        else { return true; }
    }

    protected void ddlGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            if (ChkRights())
            {
                string Msg = "You do not have rights to Open this report ";
                Response.Redirect("../Purchase/MsgPage.aspx?msg=" + Msg);
            }

            BindGroup();
            BindItem();
        }

        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    protected void rbtBilled_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
    }

    protected void rbtType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
    }

    protected void rdbgrp_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGroup();
        BindItem();
    }

    private void BindGroup()
    {
        DataView dv = LoadCacheQuery.loadSubCategory().DefaultView;
        if (rdbgrp.SelectedItem.Value == "11")
            dv.RowFilter = "ConfigID=11";
        else if (rdbgrp.SelectedItem.Value == "28")
            dv.RowFilter = "ConfigID=28";
        else
            dv.RowFilter = "ConfigID IN (11,28)";

        ddlGroup.DataSource = dv.ToTable();
        ddlGroup.DataTextField = "Name";
        ddlGroup.DataValueField = "SubCategoryID";
        ddlGroup.DataBind();

        ddlGroup.Items.Insert(0, new ListItem("All", "All"));
        ddlGroup.SelectedIndex = 0;
    }

    private void BindItem()
    {
        string strQuery = "";
        strQuery = " SELECT im.TypeName,im.ItemID FROM f_Itemmaster im  ";
        strQuery += " inner join f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID ";
        strQuery += " INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQuery += " WHERE im.isActive=1 ";

        if (rdbgrp.SelectedItem.Value != "All")
            strQuery += " AND cf.ConfigID ='" + rdbgrp.SelectedItem.Value + "' ";

        if (ddlGroup.SelectedItem.Value != "All")
            strQuery += " and im.SubCategoryID='" + ddlGroup.SelectedItem.Value + "'";

        if (rbtBilled.SelectedItem.Value != "All")
            strQuery += " and im.ToBeBilled='" + rbtBilled.SelectedItem.Value + "' ";

        if (rbtType.SelectedItem.Value != "All")
            strQuery += " and im.Type_ID='" + rbtType.SelectedItem.Value + "' ";

        strQuery += " ORDER BY im.TypeName";

        ddlItem.DataSource = StockReports.GetDataTable(strQuery);
        ddlItem.DataTextField = "TypeName";
        ddlItem.DataValueField = "ItemID";
        ddlItem.DataBind();

        ddlItem.Items.Insert(0, new ListItem("All", "All"));
        ddlItem.SelectedIndex = 0;
    }
}