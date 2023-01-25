using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_Store_IndentStatusReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGroup();
            //if (ChkRights())
            //{
            //    string Msg = "You do not have rights to Open this report ";
            //    Response.Redirect("../Purchase/MsgPage.aspx?msg=" + Msg);
            //}
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            ucDateFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucDateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
           // BindGroup();
            BindGroupHead();
            ItemBind(ddlGroup.SelectedValue);
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }

        ucDateFrom.Attributes.Add("readOnly", "true");
        ucDateTo.Attributes.Add("readOnly", "true");

    }
    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();

        DataTable dt = StockReports.GetRights(RoleId);
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "true")
            {
                cmbdept.SelectedIndex = cmbdept.Items.IndexOf(cmbdept.Items.FindByValue("STO00001"));                
            }
            else if (dt.Rows[0]["IsMedical"].ToString() == "true" || dt.Rows[0]["IsGeneral"].ToString() == "true")
            {
                if (dt.Rows[0]["IsMedical"].ToString() == "true")
                {
                    cmbdept.SelectedIndex = cmbdept.Items.IndexOf(cmbdept.Items.FindByValue("STO00001"));
                    cmbdept.Enabled = false;
                }
                else if (dt.Rows[0]["IsGeneral"].ToString() == "true")
                {
                    cmbdept.SelectedIndex = cmbdept.Items.IndexOf(cmbdept.Items.FindByValue("STO00002"));
                    cmbdept.Enabled = false;
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
    private void BindDepartment()
    {
        string str = "select LedgerNumber,LedgerName from  f_ledgermaster where GroupID='DPT' and IsCurrent=1 order by LedgerName ";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "LedgerName";
            ddlDept.DataValueField = "LedgerNumber";
            ddlDept.DataBind();
            ddlDept.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    private void BindGroup()
    {
        string str = "SELECT LedgerName,LedgerNumber from f_ledgermaster Where GroupID='STO'";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            cmbdept.DataSource = dt;
            cmbdept.DataTextField = "LedgerName";
            cmbdept.DataValueField = "LedgerNumber";
            cmbdept.DataBind();
            //if (ViewState["DeptLedgerNo"].ToString() == "LSHHI17")
            //{
            //    cmbdept.SelectedIndex = cmbdept.Items.IndexOf(cmbdept.Items.FindByValue("STO00001"));
            //}
            //else if (ViewState["DeptLedgerNo"].ToString() == "LSHHI18")
            //{
            //    cmbdept.SelectedIndex = cmbdept.Items.IndexOf(cmbdept.Items.FindByValue("STO00002"));
            //}
            //else 
            //{
            //    cmbdept.SelectedIndex = cmbdept.Items.IndexOf(cmbdept.Items.FindByValue("STO00001"));
            //}
        }
    }

    private void BindGroupHead()
    {
        string strQuery = "";
        strQuery = " SELECT sc.Name GroupHead,sc.SubCategoryID FROM f_subcategorymaster sc ";
        strQuery += " INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQuery += " WHERE sc.Active=1 ";
        
        if(cmbdept.SelectedValue=="STO00001")
            strQuery += " AND cf.ConfigID ='11' ";
        
        if (cmbdept.SelectedValue == "STO00002")
        strQuery += " AND cf.ConfigID ='28' ";

        strQuery += " Group by sc.SubCategoryID ORDER BY sc.Name";

        ddlGroup.DataSource = StockReports.GetDataTable(strQuery);
        ddlGroup.DataTextField = "GroupHead";
        ddlGroup.DataValueField = "SubCategoryID";
        ddlGroup.DataBind();
        ddlGroup.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlGroup.SelectedIndex = 0;

    }
    protected void cmbdept_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGroupHead();
        ItemBind(ddlGroup.SelectedValue);
    }
    protected void ddlGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        ItemBind(ddlGroup.SelectedValue);
    }
    private void ItemBind(string SubCategoryID)
    {
        string strQuery = "";
        strQuery = " SELECT im.TypeName,im.ItemID FROM f_Itemmaster im  ";
        strQuery += " inner join f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID ";
        strQuery += " INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQuery += " WHERE sc.Active=1 ";
        
        if (cmbdept.SelectedValue == "STO00001")
            strQuery += " AND cf.ConfigID ='11' ";
        
        if (cmbdept.SelectedValue == "STO00002")
            strQuery += " AND cf.ConfigID ='28' ";
       
        if (SubCategoryID != "ALL")
            strQuery = strQuery + " and sc.SubCategoryID='" + SubCategoryID + "'";
        
        strQuery += " ORDER BY im.TypeName";

        ddlItem.DataSource = StockReports.GetDataTable(strQuery);
        ddlItem.DataTextField = "TypeName";
        ddlItem.DataValueField = "ItemID";
        ddlItem.DataBind();
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
             string Centre = All_LoadData.SelectCentre(chkCentre);
            if (Centre == "")
            {
                lblMsg.Text = "Please Select Centre";
                return;
            }
            lblMsg.Text = "";
            StringBuilder sb = new StringBuilder();
            if (ddlType.SelectedItem.Value == "DIndent")
            {
                sb.Append("Select * from ( ");
                sb.Append("SELECT t.*,(CASE WHEN t.Requested_Qty=t.Rejected_Qty THEN 'REJECT'  WHEN  t.Requested_Qty-t.Issued_Qty-t.Rejected_Qty=0 THEN 'CLOSE' WHEN   t.Requested_Qty+t.Issued_Qty+t.Rejected_Qty=t.Requested_Qty THEN 'OPEN' WHEN (t.Issued_Qty+t.Rejected_Qty)<t.Requested_Qty THEN 'PARTIAL'  END)Status ");
                sb.Append("FROM (  SELECT cmt.CentreName,(im.ItemCode)ItemCode,im.TypeName ItemName,id.IndentNo RequisitionNo,DATE_FORMAT(id.dtentry,'%d-%b-%y')DateOfEntry,emp.Name AS RaisedBy, ");
                sb.Append("lm.ledgername AS DeptFrom,Cast(ReqQty as decimal(15,2))Requested_Qty,cast(ReceiveQty as decimal(15,2))Issued_Qty,cast(RejectQty as decimal(15,2))Rejected_Qty,cast((ReqQty-(ReceiveQty+RejectQty)) as decimal(15,2))BalQty FROM f_indent_detail id  ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=id.ItemId INNER JOIN employee_master emp ON id.UserId=emp.EmployeeID  INNER JOIN f_ledgermaster lm ");
                sb.Append(" ON lm.LedgerNumber = id.DeptFrom ");
                sb.Append(" INNER JOIN center_master cmt ON cmt.CentreID = id.CentreID "); 
                sb.Append(" WHERE id.dtEntry >='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND DATE(id.dtEntry)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + " 23:59:59'");
                sb.Append(" AND id.StoreID = '" + cmbdept.SelectedValue + "'");
                sb.Append(" AND id.CentreID IN (" + Centre + ") ");
                if (txtIndentNo.Text.ToString().Trim() != string.Empty)
                    sb.Append(" AND id.indentno = '" + txtIndentNo.Text.ToString().Trim() + "'");
                
                if (ddlDept.SelectedIndex > 0)
                    sb.Append(" AND id.deptFrom='" + ddlDept.SelectedItem.Value + "'");
                
                if (chkGroupHead.Checked)
                    sb.Append(" AND im.SubCategoryID='" + ddlGroup.SelectedItem.Value + "'");
                
                if (chkItem.Checked)
                    sb.Append(" AND im.ItemID='" + ddlItem.SelectedItem.Value + "'");

                sb.Append(" )t )t2 ");
                if (ddlstatus.SelectedItem.Value != "ALL")
                    sb.Append(" Where t2.STATUS='" + ddlstatus.SelectedItem.Text + "'");
            }
            else
            {
                sb.Append("Select t2.CentreName,t2.PatientName,t2.MRNo,REPLACE(t2.TransactionID,'ISHHI','')IPDNo,t2.ItemCode,t2.ItemName,t2.RequisitionNo,t2.DateOfEntry,t2.RaisedBy,t2.DeptFrom,t2.Requested_Qty,t2.Issued_Qty,t2.Rejected_Qty,t2.BalQty BalanceQty,t2.STATUS Status,t2.AutoRejectNarration from ( ");
                sb.Append("SELECT t.*,(CASE WHEN t.IsAutoReject=0 AND t.Requested_Qty=t.Rejected_Qty THEN 'REJECT' WHEN t.IsAutoReject=0 AND t.Requested_Qty=(t.Issued_Qty+t.Rejected_Qty) THEN 'CLOSE' WHEN t.IsAutoReject=0 AND t.Requested_Qty=(t.Requested_Qty-(t.Issued_Qty+t.Rejected_Qty)) THEN 'OPEN' WHEN t.IsAutoReject=1 THEN 'AUTOREJECT' END)STATUS, ");
                sb.Append("( SELECT PName FROM patient_master WHERE PatientID=(SELECT PatientID FROM f_ipdadjustment WHERE TransactionID=t.TransactionID LIMIT 1))PatientName,(SELECT PatientID FROM f_ipdadjustment	WHERE TransactionID=t.TransactionID LIMIT 1)MRNo ");
                sb.Append("FROM (  SELECT cmt.CentreName,idp.TransactionID,(im.ItemCode)ItemCode,im.TypeName ItemName,idp.IndentNo RequisitionNo,DATE_FORMAT(idp.dtentry,'%d-%b-%y')DateOfEntry,emp.Name AS RaisedBy, ");
                sb.Append("lm.ledgername AS DeptFrom,Cast(ReqQty as decimal(15,2))Requested_Qty,cast(ReceiveQty as decimal(15,2))Issued_Qty,cast(RejectQty as decimal(15,2))Rejected_Qty,cast(IF(idp.IsAutoReject=1,(ReqQty-(ReceiveQty+RejectQty)),0)  as decimal(15,2))BalQty,idp.IsAutoReject,idp.AutoRejectNarration FROM f_indent_detail_patient idp  ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=idp.ItemId INNER JOIN employee_master emp ON idp.UserId=emp.EmployeeID  INNER JOIN f_ledgermaster lm ");
                sb.Append(" ON lm.LedgerNumber = idp.DeptFrom ");
                sb.Append(" INNER JOIN center_master cmt ON cmt.CentreID = idp.CentreID "); 
                sb.Append(" WHERE idp.dtEntry >='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND idp.dtEntry<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + " 23:59:59'");
                sb.Append(" AND idp.StoreID = '" + cmbdept.SelectedValue + "'");
                sb.Append(" AND idp.CentreID IN (" + Centre + ") ");
                if (txtIndentNo.Text.ToString().Trim() != string.Empty)
                    sb.Append(" AND idp.indentno = '" + txtIndentNo.Text.ToString().Trim() + "'");
                
                if (ddlDept.SelectedIndex > 0)
                    sb.Append(" AND idp.deptFrom='" + ddlDept.SelectedItem.Value + "'");
                
                if (chkGroupHead.Checked)
                    sb.Append(" AND im.SubCategoryID='" + ddlGroup.SelectedItem.Value + "'");
                
                if (chkItem.Checked)
                    sb.Append(" AND im.ItemID='" + ddlItem.SelectedItem.Value + "'");

                sb.Append(" )t )t2 ");
                if (ddlstatus.SelectedItem.Value != "ALL")
                    sb.Append(" Where t2.STATUS='" + ddlstatus.SelectedItem.Text + "'");
            }
            
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = Util.GetDataTableRowSum(dt);
                Session["ReportName"] = "Requisition Status Report";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
         }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            return;
        }
    }
}
