using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_Popup : System.Web.UI.UserControl
{
    public string CurrentDataTimeDisp = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        CurrentDataTimeDisp = DateTime.Now.ToString("dd-MM-yyyy hh:mm:ss tt");
        if (!IsPostBack)
        {
            bindantibiotic();
        }
    }
    void bindantibiotic()
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,name  FROM histoimmuno_master WHERE isactive=1 ORDER BY name");
        lstlist.DataSource = dt;
        lstlist.DataValueField = "id";
        lstlist.DataTextField = "name";
        lstlist.DataBind();

    }
  
    [WebMethod]
    public static string BindDetail(string LedgerTransactionNo)
    {
        DataTable ptdetail = StockReports.GetDataTable("SELECT CONCAT(pm.Title,' ',pm.PName)PName,plo.BarcodeNo,pm.PatientID FROM patient_labinvestigation_opd plo INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID WHERE plo.LedgerTransactionNo =" + LedgerTransactionNo.ToString() + " LIMIT 1");
        DataTable griddetail = StockReports.GetDataTable("SELECT FileUrl,UploadedBy,Updatedate FROM patient_labinvestigation_attachment WHERE LedgerTransactionNo=" + LedgerTransactionNo.ToString() + " ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { ptdetail, griddetail });
    } 

}