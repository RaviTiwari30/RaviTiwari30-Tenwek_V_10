using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_CenterManagement : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string SearchCenter(string CenterName, int CenterID)
    {
        string query = "SELECT cm.`CentreID`,cm.`CentreName`,cm.`Address`,cm.`MobileNo`,cm.`CentreCode`,IF(cm.`IsActive`=1,'Yes','No')Active,cm.`Latitude`,cm.`Longitude`  FROM center_master cm ";

        if (CenterID > 0 && CenterName.Length <= 0)
            query += "WHERE CentreID=" + CenterID + "";

        if (CenterName.Length > 0 && CenterID <= 0)
            query += " where CentreName like '%" + CenterName + "%' ";

        if (CenterName.Length > 0 && CenterID > 0)
            query += " where CentreName like '" + CenterName + "%' and CentreID=" + CenterID + "";

        DataTable dt = StockReports.GetDataTable(query);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string loadPrescriptionView()
    {
        StringBuilder sb = new StringBuilder();
        try
        {
            sb.Append(" SELECT up.ID,up.AccordianName,up.ViewUrl FROM Center_Page_master up  ");
            sb.Append(" WHERE up.IsActive=1 ORDER BY up.SeqOrder ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }
}