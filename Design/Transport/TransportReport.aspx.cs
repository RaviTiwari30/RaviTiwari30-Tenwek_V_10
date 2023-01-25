using System;
using System.Data;
using System.Web.UI;

public partial class Design_Transport_TransportReport : System.Web.UI.Page
{
    protected void BindVehicle()
    {
        string sql = "select CONCAT(VehicleName,' # ',VehicleNo)Name, CONCAT(ID,'#',LastReading)Id from t_vehicle_master where IsActive=1 order by VehicleName,VehicleNo";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sql);
        ddlVehicle.DataSource = dt;
        ddlVehicle.DataTextField = "Name";
        ddlVehicle.DataValueField = "Id";
        ddlVehicle.DataBind();

        ddlVehicle.Items.Insert(0, "Select");
    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        string sql = "";

        sql = "select date_format(tv.DepartureDate,'%d-%b-%Y') as DepartureDate ,date_format(tv.DepartureTime,'%h:%i %p')as DepartureTime,date_format(tv.ArrivalDate,'%d-%b-%Y') as ArrivalDate,date_format(tv.ArrivalTime,'%h:%i %p')as ArrivalTime,vm.VehicleName,vm.VehicleNo , tv.DriverID, tv.DriverName, tv.Opening, tv.Closing, tv.KmsCovered,tv.Reading, tv.PetrolRemark,(select Purpose from t_purpose_master where ID=tv.Purpose)Purpose, tv.PlaceVisited ,tv.ApprovedBy from t_travel_detail tv inner join t_vehicle_master vm on vm.ID=tv.VehicleID Where tv.IsCancel=0 ";
        if (ddlVehicle.SelectedIndex > 0)
            sql += " AND VehicleID=" + ddlVehicle.SelectedItem.Value.ToString().Trim().Split('#')[0] + "";
        sql += " And DepartureDate >= '" + Util.GetDateTime(txtDepartureDate.Text).ToString("yyyy-MM-dd") + "' And ArrivalDate <='" + Util.GetDateTime(txtArrivalDate.Text).ToString("yyyy-MM-dd") + "' And IsCancel=0 order by Date(DepartureDate),Time(DepartureTime)";
        Session["ReportName"] = "TravellingDetail";

        StockReports.ExecuteDML(sql);
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sql);

        DataColumn DC = new DataColumn("DATE_Range");

        DC.DefaultValue = "From : " + Util.GetDateTime(txtDepartureDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtArrivalDate.Text).ToString("dd-MMM-yyyy");

        dt.Columns.Add(DC);

        DataColumn DC3 = new DataColumn("USER");
        DC3.DefaultValue = Session["LoginName"].ToString();
        dt.Columns.Add(DC3);

        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            //   ds.WriteXml("D:/TransportReport.xml");

            Session["ds"] = ds;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblmsg.Text = "No Record found";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtArrivalDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtDepartureDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindVehicle();
        }
        txtArrivalDate.Attributes.Add("readOnly", "readOnly");
        txtDepartureDate.Attributes.Add("readOnly", "readOnly");
    }
}