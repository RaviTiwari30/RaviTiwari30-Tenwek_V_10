using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_PragnancyReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        FrmDate.Attributes.Add("readOnly", "true");
        ToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pd.id,pd.weekofpreg, DATE_FORMAT(pd.CreatedDate,'%d-%b-%y') Registration_date,pd.`PatientID` ,CONCAT(pm.title,' ',pm.pname)Patient_name,CONCAT(pm.relation,' ',pm.relationname)Relationname, ");
        sb.Append(" pm.age,pm.house_no,pd.noofmalechild,pd.nooffemalechild,DATE_FORMAT(pd.lmp,'%d-%b-%y')lmp,DATE_FORMAT(pd.edd,'%d-%b-%y')edd,pd.type FROM Pregnancy_details pd ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pd.`PatientID` WHERE pd.ISAntenatalPatient=1 ");
        sb.Append(" AND DATE(pd.CreatedDate)>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(pd.CreatedDate)<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'  ORDER BY pd.CreatedDate  ");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXml(@"D://Pragnancy.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "Antenatal_Patient_report";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record not found.";
        }
    }
}