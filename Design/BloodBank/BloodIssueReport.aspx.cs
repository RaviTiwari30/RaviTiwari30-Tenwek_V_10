using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_BloodBank_BloodIssueReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblerrmsg.Text = "Please Select Centre";
            return;
        }

        DataTable dt = new DataTable();
        if (rdoReport.SelectedItem.Value == "1")
        {
            dt = SearchBloodIssue(Centre);
        }
        else if (rdoReport.SelectedItem.Value == "2")
        {
            dt = SearchBloodReturn(Centre);
        }
        else
        {
            dt = AllCase(Centre);
        }
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + txtIssuedatefrom.Text + " To : " + txtIssuedateTo.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "HeaderName";
            if (rdoReport.SelectedItem.Value == "1")
            {
                dc.DefaultValue = "BLOOD ISSUE REPORT";
            }
            else if (rdoReport.SelectedItem.Value == "2")
            {
                dc.DefaultValue = "BLOOD RETURN REPORT";
            }
            else
            {
                dc.DefaultValue = "BLOOD ISSUE/RETURN REPORT";
            }
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "BloodIssueReport";

            //ds.WriteXmlSchema("E:/BloodIssueReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtIssuedatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtIssuedateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BloodBank.bindComponent(ddlComponentName);
            ddlComponentName.Items.Insert(0,new ListItem("All"));
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPrint);
        }
        txtIssuedatefrom.Attributes.Add("readOnly", "true");
        txtIssuedateTo.Attributes.Add("readOnly", "true");
    }

    private DataTable AllCase(string Centre)
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT * FROM ( ");
            sb.Append(" SELECT  (SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=ib.IssueBy LIMIT 0, 1) AS IssueBy,cm.CentreName,ib.ComponentName,DATE_FORMAT(ib.Expiry,'%d-%b-%Y')Expiry,ib.BagType,ib.BBTubeNo,ib.PatientID,ib.TransactionID,sm.Stock_ID, ");
            sb.Append("  CONCAT(pm.Title,' ',pm.PName)PName,ib.Type,DATE_FORMAT(ib.IssuedDate,'%d-%b-%Y')IssuedDate,'' ReturnDate FROM bb_issue_blood ib INNER JOIN bb_stock_master sm  ");
            sb.Append(" ON sm.Stock_Id=ib.Stock_ID INNER JOIN patient_master pm ON pm.PatientID=ib.PatientID INNER JOIN center_master cm ON cm.CentreID= ib.CentreID WHERE sm.IsHold=0 AND ib.IsHold=0 AND ib.IsReturn=0 AND ib.CentreId IN (" + Centre + ")");

            if (ddlComponentName.SelectedIndex != 0)
            {
                sb.Append(" AND ib.ComponentID='" + ddlComponentName.SelectedItem.Value + "'");
            }
            if (rdbType.SelectedValue != "ALL")
            {
                if (rdbType.SelectedValue == "OPD")
                {
                    sb.Append(" AND  ib.Type='" + rdbType.SelectedItem.Text + "' ");
                }
                else
                {
                    sb.Append(" AND  ib.Type='" + rdbType.SelectedItem.Text + "' ");
                }
            }
            if (ddlComponentName.SelectedIndex == 0)
            {
                if (txtIssuedatefrom.Text != "")
                {
                    sb.Append(" AND DATE(IssuedDate) >='" + Util.GetDateTime(txtIssuedatefrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtIssuedateTo.Text != "")
                {
                    sb.Append(" and DATE(IssuedDate) <='" + Util.GetDateTime(txtIssuedateTo.Text).ToString("yyyy-MM-dd") + "' ");
                }
            }

            sb.Append("UNION ALL");

            sb.Append(" SELECT cm.CentreName, rb.ComponentName,DATE_FORMAT(ib.Expiry,'%d-%b-%Y')Expiry,ib.BagType,rb.BBTubeNo,rb.PatientID,rb.TransactionID,sm.Stock_ID, ");
            sb.Append("  CONCAT(pm.Title,' ',pm.PName)PName,ib.Type,DATE_FORMAT(ib.IssuedDate,'%d-%b-%Y')IssuedDate,DATE_FORMAT(rb.ReturnDate,'%d-%b-%Y')ReturnDate FROM bb_return_blood rb INNER JOIN bb_stock_master sm	");
            sb.Append(" ON sm.Stock_Id=rb.Stock_ID INNER JOIN bb_issue_blood ib ON Ib.Issue_ID=rb.Issue_ID INNER JOIN patient_master pm ON pm.PatientID=ib.PatientID INNER JOIN center_master cm ON cm.CentreID= rb.CentreID WHERE sm.IsHold=0 AND ib.IsHold=0 AND ib.Isreturn=1  AND rb.CentreId IN (" + Centre + ") ");

            if (ddlComponentName.SelectedIndex != 0)
            {
                sb.Append(" AND rb.ComponentID='" + ddlComponentName.SelectedItem.Value + "'");
            }
            if (rdbType.SelectedValue != "ALL")
            {
                if (rdbType.SelectedValue == "OPD")
                {
                    sb.Append(" AND  ib.Type='" + rdbType.SelectedItem.Text + "' ");
                }
                else
                {
                    sb.Append(" AND  ib.Type='" + rdbType.SelectedItem.Text + "' ");
                }
            }
            if (ddlComponentName.SelectedIndex == 0)
            {
                if (txtIssuedatefrom.Text != "")
                {
                    sb.Append(" AND DATE(rb.ReturnDate) >='" + Util.GetDateTime(txtIssuedatefrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtIssuedateTo.Text != "")
                {
                    sb.Append(" and DATE(rb.ReturnDate) <='" + Util.GetDateTime(txtIssuedateTo.Text).ToString("yyyy-MM-dd") + "' ");
                }
            }
            sb.Append(" )t ORDER BY t.ReturnDate");
            dt1 = StockReports.GetDataTable(sb.ToString());
            return dt1;
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);

            return dt1;
        }
    }

    private DataTable SearchBloodIssue(string Centre)
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  (SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=ib.IssueBy LIMIT 0, 1) AS IssueBy,cm.CentreName, ib.ComponentName,DATE_FORMAT(ib.Expiry,'%d-%b-%Y')Expiry,ib.BagType,ib.BBTubeNo,ib.PatientID,ib.TransactionID,sm.Stock_ID, ");
            sb.Append("  CONCAT(pm.Title,' ',pm.PName)PName,ib.Type,DATE_FORMAT(ib.IssuedDate,'%d-%b-%Y')IssuedDate,''ReturnDate FROM bb_issue_blood ib INNER JOIN bb_stock_master sm	");
            sb.Append(" ON sm.Stock_Id=ib.Stock_ID INNER JOIN patient_master pm ON pm.PatientID=ib.PatientID INNER JOIN center_master cm ON cm.CentreID= ib.CentreID WHERE sm.IsHold=0 AND ib.IsHold=0 and ib.IsReturn=0 AND ib.CentreId IN (" + Centre + ") ");

            if (ddlComponentName.SelectedIndex != 0)
            {
                sb.Append(" AND ib.ComponentID='" + ddlComponentName.SelectedItem.Value + "'");
            }
            if (rdbType.SelectedValue != "ALL")
            {
                if (rdbType.SelectedValue == "OPD")
                {
                    sb.Append(" AND  ib.Type='" + rdbType.SelectedItem.Text + "' ");
                }
                else
                {
                    sb.Append(" AND  ib.Type='" + rdbType.SelectedItem.Text + "' ");
                }
            }
            if (ddlComponentName.SelectedIndex == 0)
            {
                if (txtIssuedatefrom.Text != "")
                {
                    sb.Append(" AND DATE(IssuedDate) >='" + Util.GetDateTime(txtIssuedatefrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtIssuedateTo.Text != "")
                {
                    sb.Append(" and DATE(IssuedDate) <='" + Util.GetDateTime(txtIssuedateTo.Text).ToString("yyyy-MM-dd") + "' ");
                }
            }
            sb.Append("ORDER BY DATE(IssuedDate)");

            dt1 = StockReports.GetDataTable(sb.ToString());
            return dt1;
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);

            return dt1;
        }
    }

    private DataTable SearchBloodReturn(string Centre)
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT (SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=ib.IssueBy LIMIT 0, 1) AS IssueBy,cm.CentreName, rb.ComponentName,DATE_FORMAT(ib.Expiry,'%d-%b-%Y')Expiry,ib.BagType,rb.BBTubeNo,rb.PatientID,rb.TransactionID,sm.Stock_ID, ");
            sb.Append("  CONCAT(pm.Title,' ',pm.PName)PName,ib.Type,DATE_FORMAT(ib.IssuedDate,'%d-%b-%Y')IssuedDate,DATE_FORMAT(rb.ReturnDate,'%d-%b-%Y')ReturnDate FROM bb_return_blood rb INNER JOIN bb_stock_master sm	");
            sb.Append(" ON sm.Stock_Id=rb.Stock_ID INNER JOIN bb_issue_blood ib ON Ib.Issue_ID=rb.Issue_ID INNER JOIN patient_master pm ON pm.PatientID=ib.PatientID INNER JOIN center_master cm ON cm.CentreID= rb.CentreID WHERE sm.IsHold=0 AND ib.IsHold=0 AND ib.Isreturn=1 and rb.CentreID IN (" + Centre + ")");

            if (ddlComponentName.SelectedIndex != 0)
            {
                sb.Append(" AND rb.ComponentID='" + ddlComponentName.SelectedItem.Value + "'");
            }
            if (rdbType.SelectedValue != "ALL")
            {
                if (rdbType.SelectedValue == "OPD")
                {
                    sb.Append(" AND  ib.Type='" + rdbType.SelectedItem.Text + "' ");
                }
                else
                {
                    sb.Append(" AND  ib.Type='" + rdbType.SelectedItem.Text + "' ");
                }
            }
            if (ddlComponentName.SelectedIndex == 0)
            {
                if (txtIssuedatefrom.Text != "")
                {
                    sb.Append(" AND DATE(rb.ReturnDate) >='" + Util.GetDateTime(txtIssuedatefrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtIssuedateTo.Text != "")
                {
                    sb.Append(" and DATE(rb.ReturnDate) <='" + Util.GetDateTime(txtIssuedateTo.Text).ToString("yyyy-MM-dd") + "' ");
                }
            }
            sb.Append("ORDER BY DATE(ReturnDate)");
            dt1 = StockReports.GetDataTable(sb.ToString());
            return dt1;
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);

            return dt1;
        }
    }
}