using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_RoomLog : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_IPD.bindCaseType(ddlCaseType, "Select", 2);
            
            BindFloor();
            Search();
        }
    }
    private void BindFloor()
    {
        cmbFloor.DataSource = All_LoadData.LoadFloor();
        cmbFloor.DataValueField = "NAME";
        cmbFloor.DataTextField = "NAME";
        cmbFloor.DataBind();
    }
    private void Search()
    {
        string str = "SELECT icm.Name RoomType,icm.Description RoomTypeDesc,icm.IPDCaseType_ID,rm.Name,rm.Room_No,rm.Bed_No,rm.Floor,rm.Room_Id,rm.Description,IF(rm.IsActive =1,'Active','De-Active')IsActive ,DATE_FORMAT(rm.Updater_Date,'%d-%b-%Y')Updater_Date,rm.Updater_ID,CONCAT(em.Title,'',em.Name) updatername FROM ipd_case_type_master icm INNER JOIN room_master_log rm ON icm.IPDCaseType_ID = rm.IPDCaseTypeID INNER JOIN employee_master em ON em.employee_id=rm.Updater_ID WHERE rm.IsActive < 2  ";
        if (ddlCaseType.SelectedIndex != 0)
        {
            str = str + " and icm.IPDCaseType_ID='" + ddlCaseType.SelectedValue + "'";
        }
        if (cmbFloor.SelectedIndex != -1)
        {
            str = str + " and  rm.Floor ='" + cmbFloor.SelectedValue + "'";
        }

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            grdInv.DataSource = dt;
            grdInv.DataBind();
            pnlRoomType.Visible = true;
        }

        else
        {
            grdInv.DataSource = null;
            grdInv.DataBind();
           // pnlRoomType.Visible = false;
        }
    }
    protected void ddlCaseType_SelectedIndexChanged(object sender, EventArgs e)
    {
        Search();
    }
    protected void cmbFloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        Search();
    }
}