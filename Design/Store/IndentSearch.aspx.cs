using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_Store_IndentSearch : System.Web.UI.Page
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
        }
        DateFrom.Attributes.Add("readOnly", "true");
        DateTo.Attributes.Add("readOnly", "true");
    }

    private void BindDepartment()
    {
        DataTable dt = LoadCacheQuery.bindStoreDepartment();
        if (dt != null && dt.Rows.Count > 0)
        {
         
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "LedgerName";
            ddlDepartment.DataValueField = "LedgerNumber";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("All", "0"));
        }
    }
    protected void btnSearchIndent_Click1(object sender, EventArgs e)
    {
        try
        {

            string str = " SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE' " +
                         "  WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew FROM ( " +
                         " SELECT   (SELECT ledgername FROM f_ledgermaster fl WHERE fl.LedgerNumber=id.DeptTo )deptto,id.indentno,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,lm.ledgername AS DeptFrom,id.Status, " +
                         " SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty FROM f_indent_detail id " +
                         " INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = id.DeptFrom  where Date(id.dtEntry) >= '" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' "+
                         " and Date(id.dtEntry) <='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' AND DeptFrom='" + ViewState["DeptLedgerNo"].ToString() + "' and id.CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + "  ";
           
            if (txtIndentNoToSearch.Text.ToString().Trim() != string.Empty)
            {
                str += " and indentno = '" + txtIndentNoToSearch.Text.ToString().Trim() + "'";
            }
            if (ddlDepartment.SelectedIndex > 0)
            {
                str += " and deptFrom='" + ddlDepartment.SelectedItem.Value + "'";
            }

            str += "GROUP BY IndentNo )t ";
            DataTable dtIndentDetails = StockReports.GetDataTable(str);
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
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }

    }

    
    protected void gvGRN_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {

            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string status = Util.GetString(e.CommandArgument).Split('#')[1];
            StringBuilder sb1 = new StringBuilder();        
            sb1.Append("select '" + status + "' StatusNew,id.IndentNo,(rd.DeptName)DeptFrom,(rd1.DeptName)DeptTo,id.ItemName,id.ReqQty,id.UnitType,IF(id.`RejectReason`<>'',id.`RejectReason`,id.Remarks)Narration,id.isApproved, ");
            sb1.Append(" id.ApprovedBy,id.ApprovedReason,DATE_FORMAT(id.dtEntry,'%d-%b-%Y')DATE,id.UserId,Concat(em.Title,' ',em.Name)EmpName,id.ReceiveQty,(ifnull(id.ReqQty,0)-ifnull(id.ReceiveQty,0)-ifnull(id.RejectQty,0))PendingQty,id.RejectQty,(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employeeID=id.rejectBy)RejectBy from f_indent_detail id inner  ");
            sb1.Append(" join f_rolemaster rd on id.DeptFrom=rd.DeptLedgerNo inner join f_rolemaster rd1  ");
            sb1.Append(" on id.DeptTo=rd1.DeptLedgerNo inner join employee_master em on id.UserId=em.EmployeeID  ");
            sb1.Append(" where indentno='" + IndentNo + "' ");

           DataTable dtnew= StockReports.GetDataTable(sb1.ToString());
           if (dtnew.Rows.Count > 0)
           {
               grdIndentdtl.DataSource = dtnew;
               grdIndentdtl.DataBind();
               mpe2.Show();
               All_LoadData.updateNotification(IndentNo,Util.GetString(Session["ID"].ToString()), Util.GetString(Session["RoleID"].ToString()), 26, null, "Store");
           }
           else
           {
               grdIndentdtl.DataSource = null;
               grdIndentdtl.DataBind();
               ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
           }                               
        }
        else if (e.CommandName == "APrint")
        {
            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string status = Util.GetString(e.CommandArgument).Split('#')[1];
            StringBuilder sb1 = new StringBuilder();          
            sb1.Append("select '" + status + "' StatusNew,id.IndentNo,(rd.DeptName)DeptFrom,(rd1.DeptName)DeptTo,id.ItemName,id.ReqQty,id.UnitType,id.Narration,id.isApproved, ");
            sb1.Append(" id.ApprovedBy,id.ApprovedReason,id.dtEntry,id.UserId,Concat(em.Title,' ',em.Name)EmpName,id.ReceiveQty,id.RejectQty,id.RejectBy,id.Remarks AS ItemRemarks from f_indent_detail id ");
            sb1.Append(" inner join f_rolemaster rd on id.DeptFrom=rd.DeptLedgerNo ");
            sb1.Append(" inner join f_rolemaster rd1 on id.DeptTo=rd1.DeptLedgerNo  ");
            sb1.Append(" inner join employee_master em on id.UserId=em.EmployeeID where indentno='" + IndentNo + "' ");

           
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            DataSet ds = new DataSet();
            ds.Tables.Add(StockReports.GetDataTable(sb1.ToString()).Copy());
            ds.Tables.Add(dtImg.Copy());
          //  ds.WriteXmlSchema(@"F:\NewIndent.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "NewIndent";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);

           

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

    protected void grdIndentdtl_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "REJECT")
            {
                 e.Row.BackColor = System.Drawing.Color.LightPink;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "CLOSE")
            {
                 e.Row.BackColor = System.Drawing.Color.AntiqueWhite;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "OPEN")
            {
                 e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.LightYellow;
            }

        }
    }
   

    public void searchindentnew(string status)
    {
        try
        {
            string str ="select * from ( "+
                        " SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE' " +
                         "  WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew FROM ( " +
                         " SELECT (SELECT ledgername FROM f_ledgermaster fl WHERE fl.LedgerNumber=id.DeptTo )deptto,id.indentno,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,lm.ledgername AS DeptFrom,id.Status, " +
                         " SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty FROM f_indent_detail id " +
                         " INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = id.DeptFrom  where Date(id.dtEntry) >= '" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' and Date(id.dtEntry) <='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "'  ";
            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.GeneralDeptLedgerNo)
            {
                str += "AND id.StoreID = 'STO00002'";
            }
            else if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            {
                str += "AND id.StoreID = 'STO00001'";
            }
            else
            {
                str += "and id.DeptFrom = '" + ViewState["DeptLedgerNo"].ToString() + "'";
            }
            if (txtIndentNoToSearch.Text.ToString().Trim() != string.Empty)
            {
                str += " and indentno = '" + txtIndentNoToSearch.Text.ToString().Trim() + "'";
            }
            if (ddlDepartment.SelectedIndex > 0)
            {
                str += " and deptFrom='" + ddlDepartment.SelectedItem.Value + "'";
            }

            str += "GROUP BY IndentNo )t )t2 where t2.StatusNew='" + status + "' order by dtEntry";

            DataTable dtIndentDetails = StockReports.GetDataTable(str);
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
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
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
