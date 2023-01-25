using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Store_MapStoreItem : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["centerID"] = Session["CentreID"].ToString();
            ViewState["deptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["userID"] = Session["ID"].ToString();
           // ViewState["pharmacyWareHouseCenterID"] = Util.GetString(Resources.Resource.PharmacyWareHouseCenterID);
            ViewState["pharmacyWareHouseCenterID"] = Session["CentreID"].ToString();
        }
    }
}