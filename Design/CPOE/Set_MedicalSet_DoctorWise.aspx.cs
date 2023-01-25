using System;
using System.Data;
using System.Web;
using System.Web.Services;

public partial class Design_CPOE_Set_MedicalSet_DoctorWise : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod(EnableSession = true)]
    public static string loadSets()
    {
        DataTable dt = All_LoadData.BindMedicineSet();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string BindDoctor()
    {
        DataTable dt = All_LoadData.bindDoctor();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string LoadSetItems(int SetID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT med.ID,med.quantity,im.Typename NAME,im.ItemID,med.SetID,msm.Setname setName FROM MedicineSetItemMaster med INNER JOIN f_itemmaster im ON im.ItemID=med.itemID INNER JOIN  MedicineSetmaster msm ON med.setID=msm.ID WHERE med.setID='" + SetID + "' ORDER BY im.Typename ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string MapSet(string DoctorID, string SetID)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" Select count(*) from MedicineSetmasterDoctorWise where DoctorID='" + DoctorID + "' And SetID='" + SetID + "'"));
        if (count == 0)
        {
            StockReports.ExecuteDML(" insert into MedicineSetmasterDoctorWise (DoctorID,SetID,EntryBy) values ('" + DoctorID + "','" + SetID + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
            return "1";
        }
        else
            return "2";
    }

    [WebMethod]
    public static string BindMapSet(string DoctorID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT msm.SetName,mms.SetID,mms.ID FROM MedicineSetmasterDoctorWise mms INNER JOIN MedicineSetmaster msm ON msm.ID=mms.SetID WHERE DoctorID='" + DoctorID + "' ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string RemoveSet(string ID)
    {
        StockReports.ExecuteDML("Delete from MedicineSetmasterDoctorWise where ID='" + ID + "'");
        return "1";
    }
}