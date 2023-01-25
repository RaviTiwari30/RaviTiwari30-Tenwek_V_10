using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_Lab_SampleRejectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BindUser();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }
    }


    private void BindUser()
    {
        DataTable dt = new DataTable();
        string str = "Select concat(em.Title,' ',Name)As Name,em.EmployeeID from employee_master em order by em.name";

        dt = StockReports.GetDataTable(str);
        
        if (dt.Rows.Count > 0)
        {
            ddlUsers.DataSource = dt;
            ddlUsers.DataTextField = "Name";
            ddlUsers.DataValueField = "EmployeeID";
            ddlUsers.DataBind();
            ddlUsers.Items.Insert(0,"");
        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT cmt.CentreID,cmt.CentreName,SUBSTRING_INDEX(lt.TypeOfTnx,'-',1)TypeOfTnx,psr.PatientID MRNO,plo.BarcodeNo AS LedgerTransactionNo,CONCAT(pm.Title,pm.PName)PNAME,pm.Age,pm.Gender,TRIM(CONCAT(CONCAT(IFNULL(pm.Phone,''),'',IFNULL(pm.Mobile,'')))) Phone,pm.House_No Address, ");
        sb.Append(" im.Name InvName, psr.RejectionReason,DATE_FORMAT(psr.EntDate,'%d-%b-%Y') RejectionDate,em.Name RejectedBy FROM patient_sample_Rejection  psr ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=psr.PatientID  ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=psr.LedgerTransactionNo inner join center_master cmt on cmt.CentreID=lt.CentreID");
        sb.Append(" INNER JOIN employee_master em ON em.EmployeeID=psr.UserID ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=psr.Investigation_ID ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.Test_ID ");
        sb.Append(" WHERE plo.IsSampleCollected='R' AND psr.EntDate>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'  ");
        sb.Append(" and psr.EntDate<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (ddlUsers.SelectedIndex > 0)
            sb.Append(" AND psr.UserID='" + ddlUsers.SelectedValue + "' ");
        if (txtLabNo.Text != "")
            sb.Append(" AND plo.BarcodeNo='" + txtLabNo.Text + "' ");
        sb.Append(" ORDER BY psr.LedgerTransactionNo ");

        DataTable dt = new DataTable();
        dt= StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "ClientName";
            dc.DefaultValue = GetGlobalResourceObject("Resource", "ClientFullName").ToString();
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"D:\SampleRejectionReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "SampleRejectionReport";
            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/Commonreport.aspx');", true);
            lblMsg.Text = "";
            // lblMsg.Text = "Total records Found" + dt.Rows.Count;

        }
        else
        {
            lblMsg.Text = "Record Not found";
        }
        

    }
}
