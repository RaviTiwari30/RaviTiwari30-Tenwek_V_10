using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_IPD_PatientIssueDetails : System.Web.UI.Page
{
    protected void btnSearchByName_Click(object sender, EventArgs e)
    {
        try
        {
            StringBuilder psb = new StringBuilder();
            psb.Append("select pm.Age,pm.Gender, ich.TransactionID,date_format(if(ich.DateOfAdmit = '0001-01-01',curdate(),ich.DateOfAdmit),'%d-%b-%Y')DateOfAdmit,date_format(if(ich.DateOfDischarge = '0001-01-01',curdate(),ich.DateOfDischarge),'%d-%b-%Y')DateOfDischarge,ich.Status,concat(pm.Title,' ',pm.PName)Name,pnl.Company_Name,");
            psb.Append(" concat(dm.Title,' ',dm.Name)Consultant from ipd_case_history ich inner join patient_medical_history pmh");
            psb.Append(" on ich.TransactionID = pmh.TransactionID and ich.Status='IN' inner join patient_master pm on pmh.PatientID = pm.PatientID");
            psb.Append(" inner join f_panel_master pnl on pmh.PanelID = pnl.PanelID inner join doctor_master dm on pmh.DoctorID = dm.DoctorID  where pm.PatientID<>'' ");
            if (txtCRNo.Text != "")
                psb.Append(" AND ich.TransactionID ='ISHHI" + txtCRNo.Text + "'");
            if (txtName.Text != "")
                psb.Append(" AND PName like '" + txtName.Text.Trim() + "%'");

            DataTable dt = StockReports.GetDataTable(psb.ToString());
            if (dt.Rows.Count > 0)
            {
                lblMsg.Text = "";
                gvPatientDetail.DataSource = dt;
                gvPatientDetail.DataBind();
                lblMsg.Text = "";
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
        }
    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        GetIssueDetails(txtCRNo.Text.Trim());
    }

    protected void gvPatientDetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        GetIssueDetails(e.CommandArgument.ToString().Replace("ISHHI", ""));
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtCRNo.Focus();
        }
    }

    private void GetIssueDetails(string TransID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select ltd.ID tnxID,sd.salesno,sd.PerUnitSellingPrice,sd.SoldUnits,date_format(sd.Date,'%d-%b-%y')IssueDate,ltd.ItemName,st.BatchNumber,ltd.Amount,ltd.DiscountPercentage ,sd.IndentNo,");
        sb.Append(" 'ISSUE DETAILS ::' AS TypeOfTnx from f_salesdetails sd inner join f_stock st on sd.StockID = st.StockID inner join f_ledgertransaction LT on sd.LedgerTransactionNo = LT.LedgerTransactionNo ");
        sb.Append(" inner join f_ledgertnxdetail ltd on Ltd.LedgerTransactionNo = LT.LedgerTransactionNo and ltd.StockID = sd.StockID where lt.TypeOfTnx='Sales' and LT.TransactionID = 'ISHHI" + TransID + "' and LT.IsCancel = 0 ");
        sb.Append(" UNION ALL ");
        sb.Append(" select ltd.ID tnxID,lt.LedgerTransactionNo,st.MRP,ltd.Quantity,date_format(lt.Date,'%d-%b-%y')Date,ltd.ItemName,st.BatchNumber,ltd.Amount,ltd.DiscountPercentage , sd.IndentNo,'RETURN DETAILS ::' AS TypeOfTnx ");
        sb.Append(" FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd on ltd.LedgerTransactionNo = lt.LedgerTransactionNo inner join f_stock st on st.STOCKID = LTD.STOCKID INNER JOIN f_salesdetails sd  ON sd.StockID=st.StockID ");
        sb.Append(" AND sd.LedgerTransactionNo=ltd.LedgerTransactionNo where LT.TypeOfTnx = 'Patient-Return' and LT.IsCancel = 0 ");
        sb.Append(" and LT.TransactionID = 'ISHHI" + TransID + "' order by salesno,tnxID");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        StringBuilder psb = new StringBuilder();
        psb.Append("select ich.TransactionID,date_format(if(ich.DateOfAdmit = '0001-01-01',curdate(),ich.DateOfAdmit),'%d-%b-%Y')DateOfAdmit,date_format(if(ich.DateOfDischarge = '0001-01-01',curdate(),ich.DateOfDischarge),'%d-%b-%Y')DateOfDischarge,ich.Status,concat(pm.Title,' ',pm.PName)Name,pnl.Company_Name,");
        psb.Append(" concat(dm.Title,' ',dm.Name)Consultant from ipd_case_history ich inner join patient_medical_history pmh");
        psb.Append(" on ich.TransactionID = pmh.TransactionID inner join patient_master pm on pmh.PatientID = pm.PatientID");
        psb.Append(" inner join f_panel_master pnl on pmh.PanelID = pnl.PanelID inner join doctor_master dm on pmh.DoctorID = dm.DoctorID");
        psb.Append(" where ich.TransactionID = 'ISHHI" + TransID + "'");

        DataTable dtPatient = new DataTable();
        dtPatient = StockReports.GetDataTable(psb.ToString());

        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "";
            float IssueAmount = Util.GetFloat(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'ISSUE DETAILS ::'"));
            float ReturnAmount = Util.GetFloat(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'RETURN DETAILS ::'"));

            DataColumn dc = new DataColumn();
            dc.ColumnName = "NetAmount";
            dc.DefaultValue = IssueAmount + ReturnAmount;

            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            dtPatient.TableName = "PatientDetail";
            ds.Tables.Add(dtPatient.Copy());

            dt.TableName = "IssueDetails";
            ds.Tables.Add(dt.Copy());
           // ds.WriteXmlSchema("E:/IpdIssue.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "CreditIssueDetail";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Common/Commonreport.aspx');", true);
            lblMsg.Text = "";
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
}