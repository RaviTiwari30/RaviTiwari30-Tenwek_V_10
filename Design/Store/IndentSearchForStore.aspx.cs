using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_Store_IndentSearchForStore : System.Web.UI.Page
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
        string str = "select LedgerNumber,LedgerName from  f_ledgermaster where GroupID='DPT' and IsCurrent=1 order by LedgerName ";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
         
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "LedgerName";
            ddlDepartment.DataValueField = "LedgerNumber";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("------", "0"));
        }
    }
    protected void btnSearchIndent_Click1(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        try
        {

            StringBuilder sb = new StringBuilder();          
            sb.Append(" SELECT t.*,lm.LedgerName,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0  ");
            sb.Append(" THEN 'CLOSE'   WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  FROM  ");
            sb.Append(" ( ");
            sb.Append("  SELECT id.indentno,salesno,salesno IssueNo,DATE_FORMAT(sd.Date,'%d %b %Y')IssueDate,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,id.DeptFrom ");
            sb.Append("  ,id.Status,TrasactionTypeID,SUM(id.reqQty)ReqQty,SUM(id.ReceiveQty)ReceiveQty,SUM(id.RejectQty)RejectQty FROM f_indent_detail id     ");
            
            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.GeneralDeptLedgerNo)
            {
               sb.Append("  INNER JOIN f_salesdetails sd ON sd.indentno=id.IndentNo ");
            }
            else if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            {
                sb.Append("    INNER JOIN f_salesdetails sd ON sd.indentno=id.IndentNo ");
            }

            sb.Append("    where Date(sd.Date) >= '" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' and Date(sd.Date) <='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' ");

            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.GeneralDeptLedgerNo)
            {
                sb.Append("    AND id.StoreID = 'STO00002'" );
            }
            else if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            {
               sb.Append("    AND id.StoreID = 'STO00001' ");
            }
            else
            {
                sb.Append("    and id.DeptFrom = '" + ViewState["DeptLedgerNo"].ToString() + "' ");
            }
            if (txtIndentNoToSearch.Text.ToString().Trim() != string.Empty)
            {
                sb.Append("    and sd.indentno = '" + txtIndentNoToSearch.Text.ToString().Trim() + "'");
            }
            if (ddlDepartment.SelectedIndex > 0)
            {
               sb.Append("     and deptFrom='" + ddlDepartment.SelectedItem.Value + "'");
            }
            sb.Append(" and TrasactionTypeID=1 GROUP BY IndentNo  )t INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=t.DeptFrom ");

            DataTable dtIndentDetails = StockReports.GetDataTable(sb.ToString());
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
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            return;
        }

    }
    protected void gvGRN_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {
            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string SalesID = Util.GetString(e.CommandArgument).Split('#')[1].ToString();
            string TransactionTypeID = Util.GetString(e.CommandArgument).Split('#')[2].ToString();
            string status = Util.GetString(e.CommandArgument).Split('#')[3].ToString();
            StringBuilder sb1 = new StringBuilder();
            sb1.Append("SELECT '" + status + "' StatusNew,id.IndentNo,id.ItemName,id.ReqQty,id.ReceiveQty,(ifnull(id.ReqQty,0)-ifnull(id.ReceiveQty,0)-ifnull(id.RejectQty,0))PendingQty,id.RejectQty,t.IssuedQty, ");
            sb1.Append("id.UnitType,id.Narration,id.isApproved, id.ApprovedBy,id.ApprovedReason, ");
            sb1.Append("DATE_FORMAT(id.dtEntry,'%d-%b-%Y %h:%i %p')DATE,id.UserId,t.BatchNumber, ");
            sb1.Append("t.CostPrice,t.MedExpiryDate, ");
            if (TransactionTypeID == "1")
            {
               // sb1.Append("(SELECT DeptName FROM f_role_dept WHERE DeptLedgerNo = id.DeptFrom)DeptFrom, ");
                sb1.Append("(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber = id.DeptFrom)DeptFrom, ");
            }
            else
                sb1.Append("(SELECT Pname FROM patient_master WHERE PatientID=(SELECT PatientID FROM patient_medical_history WHERE TransactionID=id.TransactionID))DeptFrom, ");
          //  sb1.Append("(SELECT DeptName FROM f_role_dept WHERE DeptLedgerNo = id.DeptTo)DeptTo,(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employee_ID=id.rejectBy)RejectBy, ");
            sb1.Append("(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber = id.DeptTo)DeptTo,(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employee_ID=id.rejectBy)RejectBy, ");
           
            
            sb1.Append("(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employee_ID=id.UserId)EmpName, ");
            sb1.Append("(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employee_ID=t.UserId)IssueBy, t.SellingPrice "); 
            sb1.Append("FROM ");

            if(TransactionTypeID=="1")
                sb1.Append("(SELECT * FROM f_indent_detail WHERE indentno='" + IndentNo + "') id Left JOIN ");
            else
                sb1.Append("(SELECT * FROM f_indent_detail_patient WHERE indentno='" + IndentNo + "') id Left JOIN ");

            sb1.Append("(SELECT sd.IndentNo,st.BatchNumber,st.UnitPrice CostPrice,SUM(sd.SoldUnits)IssuedQty, ");
            sb1.Append("st.MedExpiryDate,sd.ItemID,sd.StockID,sd.UserID,sd.PerUnitSellingPrice SellingPrice FROM ");
            
            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
                sb1.Append("  f_salesdetails sd ");
            else
                sb1.Append("  f_salesdetails sd ");

            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
                sb1.Append(" INNER JOIN f_stock st ");
            else
                sb1.Append(" INNER JOIN f_stock st ");

            sb1.Append("ON sd.StockID = st.StockID WHERE sd.indentno='" + IndentNo + "' ");

            if (TransactionTypeID == "1")
                sb1.Append("and TrasactionTypeID=1 ");
            else
                sb1.Append("and TrasactionTypeID=3  ");


           // and sd.salesno='" + SalesID + "'");
            sb1.Append("GROUP BY sd.StockID,st.BatchNumber)t ");
            sb1.Append("ON id.ItemId = t.ItemID AND id.IndentNo = t.IndentNo ");


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
            mpe2.Show();          
        }
        else if (e.CommandName == "APrint")
        {

            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string SalesID = Util.GetString(e.CommandArgument).Split('#')[1].ToString();
            string TransactionTypeID = Util.GetString(e.CommandArgument).Split('#')[2].ToString();
            StringBuilder sb1 = new StringBuilder();          
            sb1.Append("SELECT id.IndentNo,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,t.IssuedQty, ");
            sb1.Append("id.UnitType,id.Narration,id.isApproved, id.ApprovedBy,id.ApprovedReason, ");
            sb1.Append("DATE_FORMAT(id.dtEntry,'%d-%b-%Y %h:%i %p')dtEntry,id.UserId,t.BatchNumber,t.salesno,t.iDate, ");
            sb1.Append("t.CostPrice,t.MedExpiryDate, ");
            if (TransactionTypeID == "1")
            {
                // sb1.Append("(SELECT DeptName FROM f_role_dept WHERE DeptLedgerNo = id.DeptFrom)DeptFrom, ");
                sb1.Append("(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber = id.DeptFrom)DeptFrom, ");
            }
            else
                sb1.Append("(SELECT Pname FROM patient_master WHERE PatientID=(SELECT PatientID FROM patient_medical_history WHERE TransactionID=id.TransactionID))DeptFrom, ");

           // sb1.Append("(SELECT DeptName FROM f_role_dept WHERE DeptLedgerNo = id.DeptTo)DeptTo, ");
            sb1.Append("(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber = id.DeptTo)DeptTo, ");

            sb1.Append("(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employee_ID=id.UserId)EmpName, ");
            sb1.Append("(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employee_ID=t.UserId)IssueBy, t.SellingPrice ");
            sb1.Append("FROM ");

            if (TransactionTypeID == "1")
                sb1.Append("(SELECT * FROM f_indent_detail WHERE indentno='" + IndentNo + "') id INNER JOIN ");
            else
                sb1.Append("(SELECT * FROM f_indent_detail_patient WHERE indentno='" + IndentNo + "') id INNER JOIN ");

            sb1.Append("(SELECT sd.IndentNo,st.BatchNumber,st.UnitPrice CostPrice,SUM(sd.SoldUnits)IssuedQty,sd.salesno,CONCAT(DATE_FORMAT(sd.DATE,'%d-%b-%Y'),' ',TIME_FORMAT(sd.TIME,'%h:%i %p'))iDate, ");
            sb1.Append("st.MedExpiryDate,sd.ItemID,sd.StockID,sd.UserID,sd.PerUnitSellingPrice SellingPrice FROM ");

            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
                sb1.Append("  f_salesdetails sd ");
            else
                sb1.Append("  f_salesdetails sd ");

            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
                sb1.Append(" INNER JOIN f_stock st ");
            else
                sb1.Append(" INNER JOIN f_stock st ");

            sb1.Append("ON sd.StockID = st.StockID WHERE sd.indentno='" + IndentNo + "' and sd.salesno='" + SalesID + "'");

            if (TransactionTypeID == "1")
                sb1.Append("and TrasactionTypeID=1 ");
            else
                sb1.Append("and TrasactionTypeID=3  ");
            sb1.Append("GROUP BY sd.StockID,st.BatchNumber)t ");
            sb1.Append("ON id.ItemId = t.ItemID AND id.IndentNo = t.IndentNo ");                     
            DataSet ds = new DataSet();
            ds.Tables.Add(StockReports.GetDataTable(sb1.ToString()).Copy());
           // ds.WriteXmlSchema(@"C:\NewIndent.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "NewIndentForStore";            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);

            
            
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
                e.Row.BackColor = System.Drawing.Color.AntiqueWhite;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.LightYellow;
            }

        }
    }

    public void searchindentnew(string status)
    {
        lblMsg.Text = "";
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select * from ( ");
            sb.Append(" SELECT t.*,lm.LedgerName,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0  ");
            sb.Append(" THEN 'CLOSE'   WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  FROM  ");
            sb.Append(" ( ");
            sb.Append("  SELECT id.indentno,salesno,salesno IssueNo,DATE_FORMAT(sd.Date,'%d %b %Y')IssueDate,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,id.DeptFrom ");
            sb.Append("  ,id.Status,TrasactionTypeID,SUM(id.reqQty)ReqQty,SUM(id.ReceiveQty)ReceiveQty,SUM(id.RejectQty)RejectQty FROM f_indent_detail id     ");
            
            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.GeneralDeptLedgerNo)
            {
               sb.Append("  INNER JOIN f_salesdetails sd ON sd.indentno=id.IndentNo ");
            }
            else if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            {
                sb.Append("    INNER JOIN f_salesdetails sd ON sd.indentno=id.IndentNo ");
            }

            sb.Append("    where Date(sd.Date) >= '" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' and Date(sd.Date) <='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' ");

            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.GeneralDeptLedgerNo)
            {
                sb.Append("    AND id.StoreID = 'STO00002'" );
            }
            else if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            {
               sb.Append("    AND id.StoreID = 'STO00001' ");
            }
            else
            {
                sb.Append("    and id.DeptFrom = '" + ViewState["DeptLedgerNo"].ToString() + "' ");
            }
            if (txtIndentNoToSearch.Text.ToString().Trim() != string.Empty)
            {
                sb.Append("    and sd.indentno = '" + txtIndentNoToSearch.Text.ToString().Trim() + "'");
            }
            if (ddlDepartment.SelectedIndex > 0)
            {
               sb.Append("     and deptFrom='" + ddlDepartment.SelectedItem.Value + "'");
            }
             sb.Append("     GROUP BY IndentNo  )t INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=t.DeptFrom  )t2 where t2.StatusNew='"+status+ "'");

             DataTable dtIndentDetails = StockReports.GetDataTable(sb.ToString());
            if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
            {
                grdIndentSearch.DataSource = dtIndentDetails;
                grdIndentSearch.DataBind();
            }
            else
            {
                grdIndentSearch.DataSource = null;
                grdIndentSearch.DataBind();
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
