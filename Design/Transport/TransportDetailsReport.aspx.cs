using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Transport_TransportDetailsReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblLoginType.Text = Session["DeptLedgerNo"].ToString();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindRoleDepartment();
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");

    }



    public void BindRoleDepartment()
    {

        DataTable dtDept = StockReports.GetDataTable("SELECT DeptName,DeptLedgerNo FROM f_rolemaster WHERE active=1 And DeptLedgerNo<>''  And DeptName<>''  ORDER BY DeptName ");

        if (dtDept.Rows.Count > 0 && dtDept != null)
        {

            ddlDepFrom.DataSource = dtDept;
            ddlDepFrom.DataValueField = "DeptLedgerNo";
            ddlDepFrom.DataTextField = "DeptName";
            ddlDepFrom.DataBind();

            ddlDepFrom.SelectedValue = Util.GetString(Session["DeptLedgerNo"].ToString());
            //Add blank item at index 0.
            ddlDepFrom.Items.Insert(0, new ListItem("All", "0"));

        }

    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT tr.`TokenNo`,Tr.`DeptName` From_Department,CONCAT(vm.`VehicleName`,' (',vm.`VehicleNo`,')')VehicleName,  ");
        sb.Append("   vm.`VehicleType`,dm.`NAME` Driver,DATE_FORMAT(tr.`IssueDate`,'%d-%b-%Y %I:%i %p')From_Date,DATE_FORMAT(tr.`AckDateTime`,'%d-%b-%Y %I:%i %p')To_Date,  ");
        sb.Append("   IF(tr.`ReadingTypeID`=1,'Km Basis',IF(tr.`ReadingTypeID`=2,'Range Basis',''))Reading_Type,  ");
        sb.Append("   tr.`KmRun` KM,tr.`Rate`,tr.`BilledAmount` Amount   ");
        sb.Append("   FROM t_transport_request tr  ");
        sb.Append("   INNER JOIN t_vehicle_master vm ON vm.`ID`=tr.`VehicleID`  ");
        sb.Append("   INNER JOIN `t_driver_master` dm ON dm.`ID`=tr.`DriverID`  ");
        sb.Append("   WHERE tr.`IsDept`=1   ");

        if (ddlDepFrom.SelectedValue != "" && ddlDepFrom.SelectedValue != "0")
        {
            sb.Append("      AND tr.`DeptLedgerNo`='" + ddlDepFrom.SelectedValue + "'  ");
        }

        if (ddlVehicleType.SelectedValue != "" && ddlVehicleType.SelectedValue != "0")
        {
            sb.Append("     AND vm.`VehicleType`='" + ddlVehicleType.SelectedValue + "'   ");


        }

        sb.Append("   AND Date( tr.`IssueDate`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND Date( tr.`IssueDate`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {

            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Vehicle Report";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            lblErrorMsg.Text = "";
        }
        else
        {
            lblErrorMsg.Text = "No Record Found.";

        }
    }
}