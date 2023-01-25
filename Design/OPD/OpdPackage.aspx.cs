using System;
using System.Web.Services;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Data;

public partial class Design_OPD_OPDPackage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtOnlineFromDate.Text = txtOnlineToDate.Text = txtPrescripptionModelFromDate.Text = txtPrescripptionModelToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            cdOnlineToDate.EndDate = cdOnlineFromDate.EndDate = calExdtxtPrescripptionModelFromDate.EndDate = calExdtxtPrescripptionModelToDate.EndDate = System.DateTime.Now;
            ViewState["IsDiscount"] = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "IsDiscount");
            ViewState["roleID"] = Session["RoleID"].ToString();
            lblDeptLedgerNo.Text = Session["DeptLedgerNo"].ToString();
        }
        txtPrescripptionModelFromDate.Attributes.Add("readOnly", "readOnly");
        txtPrescripptionModelToDate.Attributes.Add("readOnly", "readOnly");
    }



    [WebMethod]
    public static string SearchPackagePrescription(string patientID, string fromDate, string toDate)
    {
        var sqlCmd = new StringBuilder("SELECT DATE_FORMAT(t.createdDate,'%d-%b-%Y') `Date` ,t.Name,CONCAT(f.Type_ID, '#', t.Test_ID,'#',f.SubCategoryID) ID,(SELECT CONCAT(e.Title,e.Name)  FROM  doctor_master e WHERE e.DoctorID =t.DoctorID) `Doctor`  FROM patient_test t INNER JOIN f_itemmaster f ON  f.ItemID=t.Test_ID ");
        sqlCmd.Append("WHERE t.IsPackage=1 and t.IsActive=1 AND t.PatientID=@patientID  ");
        sqlCmd.Append("AND t.PrescribeDate>=@fromDate AND t.PrescribeDate<=@toDate");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), System.Data.CommandType.Text, new
        {
            patientID = patientID,
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd")
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
    }

    [WebMethod]
    public static string GetPatientVaccinationAndConsumables(string visitID, string patientID)
    {
        //visitID = "LLSHHI135";
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable("SELECT sd.SalesID,im.TypeName,im.ItemID,sd.SoldUnits,sd.PerUnitSellingPrice,im.SubCategoryID,'N' SampleType,0 OutSource FROM patient_consumables  pc INNER JOIN f_salesdetails  sd ON sd.SalesID=pc.SalesID INNER JOIN f_itemmaster im ON im.ItemID=sd.ItemID WHERE  sd.LedgertransactionNo = 0 and pc.PatientID=@patientID", CommandType.Text, new
        {
            visitID = visitID,
            patientID = patientID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


}