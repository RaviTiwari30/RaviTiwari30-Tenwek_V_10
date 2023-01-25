using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Store_ReturnSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            txtFrmDt.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoadData_Store.checkStoreRight(rblStoreType);
            lblMsg.Text = "";
            cmbdept.Visible = true;
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnView);
            BindDepartment();
        }

        txtFrmDt.Attributes.Add("readOnly", "true");
        txtTDate.Attributes.Add("readOnly", "true");

    }
    public void BindDepartment()
    {
        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' AND LedgerNumber<> '" + ViewState["DeptLedgerNo"].ToString() + "' AND LedgerNumber IN (select DeptLedgerNo from f_stock WHERE fromDept = '" + ViewState["DeptLedgerNo"].ToString() + "' AND StoreLedgerNo='" + rblStoreType.SelectedValue + "' and CentreID=" + Util.GetInt(Session["CentreID"].ToString()) + " )";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            cmbdept.DataSource = dt;
            cmbdept.DataTextField = "LedgerName";
            cmbdept.DataValueField = "LedgerNumber";
            cmbdept.DataBind();
            cmbdept.Items.Insert(0, new ListItem("ALL", "0"));
        }
        else
        {
            cmbdept.Items.Clear();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM254','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void rdbPatient_CheckedChanged(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        cmbdept.Visible = false;
        grdPatient.DataSource = null;
        grdPatient.DataBind();
    }

    protected void rdbDept_CheckedChanged(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        BindDepartment();
        cmbdept.Visible = true;
        grdPatient.DataSource = null;
        grdPatient.DataBind();
    }

    protected void btnView_Click1(object sender, EventArgs e)
    {
        try
        {
            string Centre = All_LoadData.SelectCentre(chkCentre);
            if (Centre == "")
            {
                lblMsg.Text = "Please Select Centre";
                return;
            }
            grdPatient.DataSource = null;
            grdPatient.DataBind();
            DataTable dt = null;
            string  DocumentNo = "", FrmDate = "", ToDate = "", Dept = "";
            
            if (txtDocumentNo.Text != "")
            {
                DocumentNo = txtDocumentNo.Text.Trim();
            }
            
            if (txtFrmDt.Text != "")
            {
                FrmDate = Util.GetDateTime(txtFrmDt.Text).ToString("yyyy-MM-dd");
            }
            if (txtTDate.Text != "")
            {
                ToDate = Util.GetDateTime(txtTDate.Text).ToString("yyyy-MM-dd");
            }
            
            if (cmbdept.SelectedItem.Value != "0")
            {
                Dept = cmbdept.SelectedItem.Value;
            }

            dt = GetDeptReturnDetails(FrmDate, ToDate, DocumentNo, Dept, Centre);
            
            ViewState["Search"] = dt;

            if (dt != null && dt.Rows.Count > 0)
            {
                lblMsg.Text = dt.Rows.Count + "Record Found";
                grdPatient.DataSource = dt;
                grdPatient.DataBind();
                grdPatient.Columns[4].Visible = false;                   
            }
            else
            {
                lblMsg.Text = " No Record Found";
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        
    }
    
    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            int index = Util.GetInt(e.CommandArgument);
            string DocumentNo = grdPatient.Rows[index].Cells[0].Text;
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT st.ItemId,st.ItemName,st.BatchNumber,st.MedExpiryDate,sd.SoldUnits,sd.PerUnitBuyPrice,sd.salesno,sd.Date,sd.Time,");
            sb.Append(" (SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=sd.DeptLedgerNo AND GroupID='DPT')ReturnFrom, ");
            sb.Append(" (SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=sd.LedgerNumber  AND GroupID='DPT')ReturnTo,(SELECT NAME FROM employee_master WHERE EmployeeID=sd.UserID)ReturnBy FROM");
            sb.Append(" f_salesdetails sd INNER JOIN f_stock st ON st.stockId = sd.stockId ");
            sb.Append(" WHERE sd.salesno='" + DocumentNo + "' AND sd.CentreID="+ Session["CentreID"].ToString() +" and TrasactionTypeID=15 AND sd.IsReturn=1  ");

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"C:\DeptReturn.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "DepartmentReturn";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
    }

    public DataTable GetDeptReturnDetails(string FromDate, string ToDate, string DocumentNo, string Dept, string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT sd.salesno ReturnNo,dm.RoleName ReturnFrom,rm.RoleName ReturnTo,cm.CentreName,sd.DeptLedgerNo,sd.LedgerNumber,em.Name ReturnBy, ");
        sb.Append("DATE_FORMAT(sd.Date,'%d-%b-%Y') Date, ");
        sb.Append("SUM(sd.SoldUnits) ReturnQuantity FROM f_salesdetails sd  ");
        sb.Append("INNER JOIN f_rolemaster dm ON dm.DeptLedgerNo = sd.DeptLedgerNo ");
        sb.Append("INNER JOIN f_rolemaster rm ON rm.DeptLedgerNo = sd.LedgerNumber ");
        sb.Append("INNER JOIN center_master cm ON cm.CentreID = sd.CentreID ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID = sd.UserID  ");
        sb.Append("WHERE sd.IsReturn=1   ");
        if (DocumentNo.Trim() == string.Empty)
        {
            sb.Append("and sd.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and sd.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }
        sb.Append("and sd.CentreID IN (" + CentreID + ") ");
        if (cmbdept.SelectedValue != "0")
            sb.Append(" AND sd.DeptLedgerNo='" + cmbdept.SelectedValue + "' ");
        if (DocumentNo.Trim() != string.Empty)
            sb.Append("and sd.salesno=" + DocumentNo.Trim() + "  ");
        sb.Append("GROUP BY sd.salesno,sd.CentreID ");
       return StockReports.GetDataTable(sb.ToString());
    }

    protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDepartment();
    }
}
