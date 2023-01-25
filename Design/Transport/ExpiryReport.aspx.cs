using System;
using System.Data;
using System.Web.UI;

public partial class Design_Transport_ExpiryReport : System.Web.UI.Page
{
    protected void btnView_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == string.Empty)
        {
            lblmsg.Text = "Please Select Centre";
            return;
        }

        if (rblReportType.SelectedValue == "1")
        {
            DataTable driver = StockReports.GetDataTable("SELECT cm.CentreID,cm.CentreName,dm.Name,dm.Address,Mobile,LicenceNo,DATE_FORMAT(LicenceExpiryDate,'%d-%b-%Y')LicenceExpiryDate FROM t_driver_master dm INNER JOIN center_master cm ON cm.CentreID= dm.CentreID " +
                " WHERE LicenceExpiryDate >='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND LicenceExpiryDate <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' " +
                "and dm.CentreID in (" + Centre + ") ");

            if (driver.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ReportDate";
                dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                driver.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"]));
                driver.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(driver.Copy());

             //   ds.WriteXmlSchema("D:\\DriverLicenceExpiry.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "DriverLicenceExpiry";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
        if (rblReportType.SelectedValue == "2")
        {
            DataTable vehicle = StockReports.GetDataTable("SELECT cm.CentreID,cm.CentreName, VehicleNo,VehicleName,ModelNo,RcNo,DATE_FORMAT(TaxDepositDate,'%d-%b-%Y')TaxDepositDate,DATE_FORMAT(InsuranceExpiryDate,'%d-%b-%Y')InsuranceExpiryDate,AveragePerLtrs FROM t_vehicle_master dm INNER JOIN center_master cm ON cm.CentreID= dm.CentreID " +
                " WHERE InsuranceExpiryDate >='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND InsuranceExpiryDate <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' " +
             "and dm.CentreID in (" + Centre + ") ");
            if (vehicle.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ReportDate";
                dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                vehicle.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"]));
                vehicle.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(vehicle.Copy());

             //  ds.WriteXmlSchema("D:\\vehicleInsuranceExpiry.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "vehicleInsuranceExpiry";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
        if (rblReportType.SelectedValue == "3")
        {
            DataTable vehicle;

            if (rblSearchBy.SelectedValue == "2")
            {
                vehicle = StockReports.GetDataTable("SELECT cm.CentreID,cm.CentreName, VM.VehicleNo,VM.VehicleName,VM.ModelNo,VehicleType,Model,DATE_FORMAT(VS.CurServiceDate,'%d-%b-%Y')CurServiceDate,DATE_FORMAT(VS.NextServiceDate,'%d-%b-%Y')NextServiceDate, " +
                                   "VS.Remarks FROM t_vehicle_servicing VS INNER JOIN t_vehicle_master VM ON VS.VehicleID=VM.ID INNER JOIN center_master cm ON cm.CentreID= vs.CentreID WHERE VM.IsActive=1 AND " +
                                   "DATE(VS.NextServiceDate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(VS.NextServiceDate)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' " +
                                    "and vs.CentreID in (" + Centre + ")  ORDER BY VM.VehicleName ");
            }
            else
            {
                vehicle = StockReports.GetDataTable("SELECT cm.CentreID,cm.CentreName, VM.VehicleNo,VM.VehicleName,VM.ModelNo,VehicleType,Model,DATE_FORMAT(VS.CurServiceDate,'%d-%b-%Y')CurServiceDate,DATE_FORMAT(VS.NextServiceDate,'%d-%b-%Y')NextServiceDate, " +
                                                  "VS.Remarks FROM t_vehicle_servicing VS INNER JOIN t_vehicle_master VM ON VS.VehicleID=VM.ID INNER JOIN center_master cm ON cm.CentreID= vs.CentreID WHERE VM.IsActive=1 AND " +
                                                  "DATE(VS.CurServiceDate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(VS.CurServiceDate)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' "+
                                                   "and vs.CentreID in (" + Centre + ")  ORDER BY VM.VehicleName ");
            }

            if (vehicle.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ReportDate";
                dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                vehicle.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"]));
                vehicle.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(vehicle.Copy());

          //      ds.WriteXmlSchema("D:\\VehicleServiceReport.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "VehicleServiceReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(),btnView);
        }
        txtToDate.Attributes.Add("readOnly", "readOnly");
        txtFromDate.Attributes.Add("readOnly", "readOnly");
    }
}