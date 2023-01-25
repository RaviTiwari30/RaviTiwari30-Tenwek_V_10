using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_IPD_PROReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            bindPRO();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    private void bindPRO()
    {
        DataTable dt = AllLoadData_IPD.bindProMaster();
        if (dt.Rows.Count > 0)
        {
            ddlProName.DataSource = dt;
            ddlProName.DataTextField = "ProName";
            ddlProName.DataValueField = "pro_id";
            ddlProName.DataBind();
            ddlProName.Items.Insert(0, new ListItem("All", "0"));
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreName,cm.CentreID,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PName,IF(pm.Gender='Male','M','F')Gender,pm.Age,CONCAT(pm.House_No,IF(pm.House_No!='',',',''),pm.City,',',pm.Country )Address,fpm.ProName,fpm.Pro_ID,REPLACE(pmh.TransactionID,'ISHHI','')IPDNo,DATE_FORMAT(pmh.dateofVisit,'%d-%b-%Y')DateOfVisit,dr.`Name` drname ");
        sb.Append(" FROM f_pro_master fpm INNER JOIN patient_medical_history pmh ON pmh.ProID=fpm.Pro_ID INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID LEFT JOIN  doctor_referal dr  ON pmh.referedBy=dr.DoctorID WHERE pmh.ProID<>0 AND cm.CentreID IN (" + Centre + ") ");
        if (txtIPDNo.Text.Trim() != "")
            sb.Append(" AND pmh.TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
        if (txtMRNo.Text.Trim() != "")
            sb.Append(" AND pm.PatientID='" + txtMRNo.Text.Trim() + "' ");
        if (ddlProName.SelectedIndex>0)
            sb.Append(" AND pmh.ProID='" + ddlProName.SelectedValue + "'");
        if (txtMRNo.Text.Trim() == "" && txtIPDNo.Text.Trim() == "" && ddlProName.SelectedIndex == 0)
            sb.Append(" AND date(pmh.DateofVisit)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "'  AND date(pmh.DateofVisit)<='" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "";
            txtFromDate.Text = Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy");
            txtToDate.Text = Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");

            DataColumn dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

           // ds.WriteXmlSchema("F:\\PROReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "PROReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }


        else
            lblMsg.Text = "Record Not Found";
    }
}