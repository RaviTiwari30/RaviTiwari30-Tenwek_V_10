using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_BirthCertificateEntryReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            BindDeliveryType();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
       


        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT a.Number,CONCAT(pm.Title,' ',pm.PFirstName) MotherName,a.ConsultantDoctorId,(SELECT CONCAT(Title,' ',NAME) DName FROM doctor_master WHERE doctorid=pmh.Doctorid) ConsultantDoctor,concat('Mr.',' ',a.Guardian) AS FatherName,DATE_FORMAT(a.DeliveryDate,'%d-%b-%Y')DeliveryDate,TIME_FORMAT(a.DeliveryTime,'%h:%i %p')DeliveryTime,a.DeliveryType,a.BabyName,a.Gender,concat(ROUND(a.Weight,2),' ',a.WeightUnit) as Weight,concat(a.Height,' ',a.HeightUnit) as Height,a.Address,DATE_FORMAT(a.IssueDate,'%d-%b-%Y')IssueDate ");
        sb.Append(" FROM birth_certificate_entry a ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON a.PatientId=pmh.PatientId AND a.Transactionid=pmh.Transactionid ");
        sb.Append(" INNER JOIN patient_master pm ON pmh.patientid=pm.PatientID ");
        sb.Append(" WHERE a.DeliveryDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND a.DeliveryDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");


        if (ddlDeliveryType.SelectedItem.Text != "ALL")
        {
           sb.Append("  AND a.DeliveryType='" + ddlDeliveryType.SelectedItem.Text + "' ");
        }

        DataTable dtBirth = StockReports.GetDataTable(sb.ToString());

        if (dtBirth.Rows.Count > 0)
        {
            if (rblFormat.SelectedItem.Text == "PDF")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "User";
                dc.DefaultValue = StockReports.GetUserName(Util.GetString(ViewState["ID"])).Rows[0][0].ToString();
                dtBirth.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "Period From  :  " + txtFromDate.Text + " To :  " + txtToDate.Text;
                dtBirth.Columns.Add(dc);

                DataTable dtImg = All_LoadData.CrystalReportLogo();

                DataSet ds = new DataSet();
                ds.Tables.Add(dtBirth.Copy());
                ds.Tables.Add(dtImg.Copy());

                //ds.WriteXmlSchema("D:\\BirthCertificateEntryReport.xml");

                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "BirthCertificateEntryReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key", "window.open('../../Design/common/CommonReport.aspx');", true);
            }
            else
            {
                foreach (DataRow row in dtBirth.Rows)
                {
                    row[0] = row[0].ToString().Replace("<br>"," - ");
                }

                HttpContext.Current.Session["dtExport2Excel"] = dtBirth;
                HttpContext.Current.Session["ReportName"] = "Baby Birth Report";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }

    private void BindDeliveryType()
    {
        string[] DeliveryType = AllGlobalFunction.DeliveryType;
        DeliveryType[0] = "ALL";

        ddlDeliveryType.DataSource = DeliveryType;
        ddlDeliveryType.DataBind();
    }
}