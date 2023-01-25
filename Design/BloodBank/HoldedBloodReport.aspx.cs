using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_BloodBank_HoldedBloodReport : System.Web.UI.Page
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
        dt = search(Centre);
        if (dt != null && dt.Rows.Count > 0)
        {
            lblerrmsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + txtholddatefrom.Text + " To : " + txtholddateTo.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "HoldBloodReport";

            //ds.WriteXmlSchema("D:/HoldBloodReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblerrmsg.Text = "Please Select Centre";
            return;
        }
        DataTable dt = new DataTable();
        dt = search(Centre);
        if (dt.Rows.Count > 0)
        {
            grdStock.DataSource = dt;
            grdStock.DataBind();

            pnlHide.Visible = true;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);

            grdStock.DataSource = null;
            grdStock.DataBind();

            pnlHide.Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtholddatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtholddateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BloodBank.bindBagType(ddlBagType);
            ddlBagType.Items.Insert(0, "Select");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPrint);
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            btnPrint.Attributes.Add("onclick", String.Format("this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnPrint, String.Empty)));

        }
        txtholddatefrom.Attributes.Add("readOnly", "true");
        txtholddateTo.Attributes.Add("readOnly", "true");
    }

    private DataTable search(string Centre)
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  cm.CentreName,cm.CentreID, ib.ComponentName,DATE_FORMAT(ib.Expiry,'%d-%b-%Y')Expiry,ib.BagType,ib.BBTubeNo,ib.PatientID,ib.TransactionID,sm.Stock_ID, ");
            sb.Append("  CONCAT(pm.Title,' ',pm.PName)PName,DATE_FORMAT(ib.Holddate,'%d-%b-%y')Holddate FROM bb_issue_blood ib INNER JOIN bb_stock_master sm	");
            sb.Append(" ON sm.Stock_Id=ib.Stock_ID INNER JOIN patient_master pm ON pm.PatientID=ib.PatientID INNER JOIN center_master cm ON ib.CentreID=cm.CentreID  WHERE sm.IsHold=1 AND ib.IsHold=1 and ib.CentreID IN (" + Centre + ") ");

            if (txtTransactionID.Text.Trim() != "")
            {
                sb.Append("AND ib.TransactionID='ISHHI" + txtTransactionID.Text.Trim() + "'");
            }
            if (txtPatientID.Text.Trim() != "")
            {
                sb.Append("AND ib.PatientID='" + txtPatientID.Text.Trim() + "'");
            }
            if (txtTubeNo.Text.Trim() != "")
            {
                sb.Append(" AND ib.BagType='" + txtTubeNo.Text.Trim() + "'");
            }
            if (ddlBagType.SelectedIndex != 0)
            {
                sb.Append(" AND ib.BagType='" + ddlBagType.SelectedItem.Text + "'");
            }
            if (txtTransactionID.Text == "" && txtPatientID.Text.Trim() == "" && txtTubeNo.Text.Trim() == "" && ddlBagType.SelectedIndex == 0)
            {
                if (txtholddatefrom.Text != "")
                {
                    sb.Append(" AND DATE(ib.HoldDate) >='" + Util.GetDateTime(txtholddatefrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtholddateTo.Text != "")
                {
                    sb.Append(" and DATE(ib.HoldDate) <='" + Util.GetDateTime(txtholddateTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }
            sb.Append(" ORDER BY ib.Issue_ID");
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