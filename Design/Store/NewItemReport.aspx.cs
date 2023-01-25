using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_NewItemReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Select ItemCode 'Item Code',im.TypeName 'Item Name',(fsm.Name)'Category', ");
            sb.Append(" ( SELECT NAME FROM f_manufacture_master MM WHERE MM.ManufactureID=im.ManufactureID ) 'Manufacture Name', ");
            sb.Append(" im.Description,im.rack,im.shelf,im.maxlevel 'Max Level',im.minlevel 'Min Level',im.reorderlevel 'Reorder Level', ");
            sb.Append(" im.reorderqty 'Reorder Qty',im.packing,im.majorunit 'PurchaseUnit',im.MinorUnit 'SaleUnit',im.ConversionFactor,(em.Name)'Creater Name', ");
            sb.Append(" Date_Format(im.CreaterDateTime,'%d-%b-%Y')'Created Date',(em1.Name)'Last Updated By',DATE_FORMAT(im.Updatedate,'%d-%b-%Y')'Update date',");
            sb.Append(" if(im.IsActive=1,'Active','InActive')Status from f_itemmaster im inner join employee_master em on EmployeeID=im.CreaterID  ");
            sb.Append(" LEFT JOIN employee_master em1 ON em1.EmployeeID=REPLACE(im.LastUpdatedBy,'Backend','EMP001') inner join f_subcategorymaster fsm on im.SubCategoryID=fsm.SubCategoryID  ");
            sb.Append(" where im.itemid <>'' and im.IsActive='" + rdoActive.SelectedValue + "'");
            if (rbtnMedNonMed.SelectedItem.Value != "3")
            {
                sb.Append(" and fsm.CategoryID='" + rbtnMedNonMed.SelectedItem.Value + "'  ");
            }

            if (rbtFilter.SelectedItem.Value == "0")
            {
                sb.Append("    AND DATE(im.CreaterDateTime)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
                sb.Append("    AND DATE(im.CreaterDateTime)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            }
            else
            {
                sb.Append("    AND DATE(im.Updatedate)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
                sb.Append("    AND DATE(im.Updatedate)<='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
            }

            if (txtSearch.Text.Trim() != string.Empty)
            {
                sb.Append(" and im.TypeName like '%" + txtSearch.Text.Trim() + "'");
            }
            if (txtSearchchar.Text.Trim() != string.Empty)
            {
                sb.Append(" and im.TypeName like '%" + txtSearchchar.Text.Trim() + "%'");
            }

            if (ddlGroup.SelectedIndex != 0)
            {
                sb.Append(" and  im.SubCategoryID = '" + ddlGroup.SelectedValue + "'");
            }
            if (rbtType.SelectedValue.ToUpper() != "All")
            {
                sb.Append("  and im.Type_ID='" + rbtType.SelectedItem.Value + "' ");
            }
            if (ddlEmployeeName.SelectedIndex != 0)
            {
                sb.Append("AND em.EmployeeID = '" + ddlEmployeeName.SelectedValue + "'");
            }
            sb.Append(" ORDER BY im.CreaterDateTime,im.Updatedate ");
            dt = StockReports.GetDataTable(sb.ToString());
            ViewState["dt"] = dt;
            if (dt.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = " REPORT OF " + ddlGroup.SelectedItem.Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key5", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
        }
    }

    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();
        rbtnMedNonMed.Items[0].Enabled = false;
        rbtnMedNonMed.Items[1].Enabled = false;
        rbtnMedNonMed.Items[2].Enabled = false;

        DataTable dt = StockReports.GetRights(RoleId);
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "true")
            {
                rbtnMedNonMed.Items[0].Enabled = true;
                rbtnMedNonMed.Items[1].Enabled = true;
                rbtnMedNonMed.Items[2].Enabled = true;
                rbtnMedNonMed.SelectedIndex = 0;
            }
            else if (dt.Rows[0]["IsMedical"].ToString() == "true" || dt.Rows[0]["IsGeneral"].ToString() == "true")
            {
                if (dt.Rows[0]["IsMedical"].ToString() == "true")
                {
                    rbtnMedNonMed.Items[0].Enabled = true;
                    rbtnMedNonMed.Items[1].Enabled = false;
                    rbtnMedNonMed.Items[2].Enabled = false;
                    rbtnMedNonMed.SelectedIndex = 0;
                }
                else if (dt.Rows[0]["IsGeneral"].ToString() == "true")
                {
                    rbtnMedNonMed.Items[0].Enabled = false;
                    rbtnMedNonMed.Items[1].Enabled = true;
                    rbtnMedNonMed.Items[2].Enabled = false;
                    rbtnMedNonMed.SelectedIndex = 1;
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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (ChkRights())
            {
                string Msg = "You do not have rights to Open this report ";
                Response.Redirect("../Purchase/MsgPage.aspx?msg=" + Msg);
            }
            ucDateFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucDateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            BindGroup();
            BindEmployee();
        }
        ucDateFrom.Attributes.Add("readOnly", "true");
        ucDateTo.Attributes.Add("readOnly", "true");
    }

    protected void rbtnMedNonMed_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGroup();
    }

    private void BindEmployee()
    {
        string strQuery = "";
        strQuery = "SELECT EmployeeID,NAME FROM employee_master";
        DataTable Items = StockReports.GetDataTable(strQuery);
        ddlEmployeeName.DataSource = Items;
        ddlEmployeeName.DataTextField = "Name";
        ddlEmployeeName.DataValueField = "EmployeeID";
        ddlEmployeeName.DataBind(); ddlEmployeeName.Items.Insert(0, "All");
    }

    private void BindGroup()
    {
        DataView dv = LoadCacheQuery.loadSubCategory().DefaultView;
        if (rbtnMedNonMed.SelectedValue == "LSHHI5")
            dv.RowFilter = "ConfigID=11";
        else if (rbtnMedNonMed.SelectedValue == "LSHHI8")
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
}