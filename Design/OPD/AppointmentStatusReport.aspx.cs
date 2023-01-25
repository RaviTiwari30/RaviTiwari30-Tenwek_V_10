using System;
using System.Data;
using System.Web.UI;


public partial class Design_OPD_AppointmentStatusReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            LoadDoc();
            ViewState["UserID"] = Session["ID"].ToString();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
            clcAppDate.EndDate = DateTime.Now;
            txtCurrentDate0_CalendarExtender.EndDate = DateTime.Now;
        }
        txtfromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    protected void LoadDoc()
    {
        DataTable dtDoc = All_LoadData.bindDoctor();
        ddlDoctor.DataSource = dtDoc;
        ddlDoctor.DataTextField = "Name";
        ddlDoctor.DataValueField = "DoctorID";
        ddlDoctor.DataBind();
        ddlDoctor.Items.Insert(0, "All");
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        string DoctorID = "";
        lblMsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        if (ddlDoctor.SelectedItem.Text != "All")
        {
            DoctorID = ddlDoctor.SelectedItem.Value;
        }

        DataTable dtReport = AllLoadData_OPD.SearchAppointment(DoctorID, Util.GetDateTime(txtfromDate.Text), Util.GetDateTime(txtToDate.Text), txtAppNo.Text, "", ddlVisitType.SelectedValue.ToString(), ddlStatus.SelectedValue.ToString(),Centre);

        if (dtReport != null && dtReport.Rows.Count > 0)
        {

            for (int i = 0; i < dtReport.Rows.Count; i++)
            {
                if (dtReport.Rows[i]["IsConform"].ToString() == "0" && dtReport.Rows[i]["IsCancel"].ToString() == "0" && Util.GetDateTime(dtReport.Rows[i]["AppDateTime"]) < Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yy hh: mm tt")))
                {
                    dtReport.Rows[i]["Status"] = "App Time Expired";
                }
                else
                {
                    if (dtReport.Rows[i]["IsConform"].ToString() == "1")
                    {
                        dtReport.Rows[i]["Status"] = "Confirmed";
                    }
                    else if (dtReport.Rows[i]["IsCancel"].ToString() == "1")
                    {
                        dtReport.Rows[i]["Status"] = "Canceled";
                    }
                    else if (dtReport.Rows[i]["IsReschedule"].ToString() == "1")
                    {
                        dtReport.Rows[i]["Status"] = "ReScheduled";
                    }
                    else
                    {
                        dtReport.Rows[i]["Status"] = "Pending";
                    }
                }
                dtReport.AcceptChanges();
            }
            DataColumn dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            dc.DefaultValue = "From : " + Util.GetDateTime(txtfromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dtReport.Columns.Add(dc);
            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dtReport.Columns.Add(dc);
            if (rdoReportType.SelectedValue == "1")
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dtReport.Copy());
               // ds.WriteXmlSchema(@"E:\AppConfirmationReport.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "AppConfirmationReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                dtReport.Columns.Remove("transaction_id");
                dtReport.Columns.Remove("App_ID");
                dtReport.Columns.Remove("Doctor_ID");
                dtReport.Columns.Remove("IsConform");
                dtReport.Columns.Remove("IsReschedule");
                dtReport.Columns.Remove("IsCancel");
                dtReport.Columns.Remove("CancelReason");
                dtReport.Columns.Remove("ConformDate");
                dtReport.Columns.Remove("LedgerTnxNo");
                dtReport.Columns.Remove("AppDateTime");
                dtReport.Columns.Remove("CentreID");
                dtReport.AcceptChanges();
                dtReport.Columns[0].ColumnName = "MRNo";
                dtReport.Columns[4].ColumnName = "Patient Type";
                dtReport.Columns[2].ColumnName = "Patient Name";

                Session["dtExport2Excel"] = dtReport;
                Session["ReportName"] = "Appointment Status Report";
                Session["Period"] = dtReport.Rows[0]["ReportDate"].ToString();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }


        }
        else
            lblMsg.Text = "No Record Found";
    }
}