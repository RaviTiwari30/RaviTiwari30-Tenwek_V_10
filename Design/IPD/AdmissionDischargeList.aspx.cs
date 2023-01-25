using System;
using System.Data;
using System.Web;
using System.Web.UI;


public partial class Design_IPD_AdmissionDischargeList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            chkItems.Visible = false;
            chkAllItem.Visible = false;
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            
            Conditions();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    protected void ddlReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        Conditions();
    }
    private void Conditions()
    {
        chkAllItem.Checked = false;
        DataTable dt = new DataTable();

        string ReportType = ddlReportType.SelectedValue;

        switch (ReportType)
        {
            case "1":
                break;
            case "2":
                dt = EDPReports.GetBedCategory();
                break;
            case "3":
                dt = EDPReports.GetConsultants();
                break;
            case "4":
                break;
            case "5":
                dt = EDPReports.GetDepartments();
                break;
            case "6":
                dt = EDPReports.GetFloors();
                break;
            case "7":
                dt = EDPReports.GetPanels();
                break;
        }

        if (dt.Rows.Count > 0)
        {
            chkItems.Visible = true;
            chkItems.DataSource = dt;
            chkItems.DataTextField = "text";
            chkItems.DataValueField = "value";
            chkItems.DataBind();
            chkAllItem.Visible = true;
        }
        else
        {
            chkItems.Items.Clear();
            chkItems.Visible = false;
            chkAllItem.Visible = false;
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string ItemIDs = string.Empty;

        if (Session["LoginType"] == null)
        {
            return;
        }
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
      
        if (chkItems.Visible)
            ItemIDs = StockReports.GetSelection(chkItems);
        
        DataTable dtUser = new DataTable();
        dtUser = StockReports.GetUserName(Convert.ToString(Session["ID"]));
        ucFromDate.Text = Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy");
        ucToDate.Text = Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
        DataColumn dc = new DataColumn();
        dc.ColumnName = "Period";
        dc.DefaultValue = "Period From " + ucFromDate.Text + " To : " + ucToDate.Text;
        dtUser.Columns.Add(dc);

        dc = new DataColumn();
        dc.ColumnName = "ReportType";
        dc.DefaultValue = "2";
        dtUser.Columns.Add(dc);

        DataTable dtPatients = new DataTable();

        if (rdoListType.Text == "1")
            dtPatients = EDPReports.GetPatientAdmissionList(ddlReportType.SelectedValue, ItemIDs, ucFromDate.Text, ucToDate.Text,Centre);        
        else
            dtPatients = EDPReports.GetPatientDischargeList(ddlReportType.SelectedValue, ItemIDs, ucFromDate.Text, ucToDate.Text,Centre);


        if (dtPatients.Rows.Count > 0)
        {

            if (ddlReportFormat.SelectedValue == "2")
            { 
                dtPatients = Util.GetDataTableRowSum(dtPatients);
                 
                dtPatients.Columns.Remove("DischargeStatus");
                dtPatients.Columns.Remove("CentreID");
                dtPatients.Columns.Remove("Phone");
                dtPatients.Columns["PatientName"].SetOrdinal(2);
                dtPatients.Columns["Age"].SetOrdinal(3);
                dtPatients.Columns["Gender"].SetOrdinal(4);
                dtPatients.Columns["Mobile"].SetOrdinal(5);
                dtPatients.Columns["CentreName"].SetOrdinal(dtPatients.Columns.Count-1);
                dtPatients.Columns["PatientID"].ColumnName = "UHID";

                
                if (rdoListType.Text == "1")
                {
                    dtPatients.Columns["Transaction_ID"].ColumnName = "IPD No.";
                    dtPatients.Columns.Remove("Source");
                    dtPatients.Columns.Remove("StartDate");
                }
                else
                {
                    dtPatients.Columns["TransactionID"].ColumnName = "IPD No.";
                    dtPatients.Columns.Remove("EndDate");
                    dtPatients.Columns.Remove("Source");
                }
                 
                string ReportName = "";
                if (rdoListType.Text == "1")
                    ReportName = "Admission Patient List";
                else
                    ReportName = "Discharged Patient List";


                Session["dtExport2Excel"] = dtPatients;
                Session["ReportName"] = ReportName;
                Session["Period"] = "From" + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
             
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
 
            }
            else
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dtPatients.Copy());
                ds.Tables[0].TableName = "Patients";
                ds.Tables.Add(dtUser.Copy());
                ds.Tables[1].TableName = "User";

                //    ds.WriteXmlSchema(@"e:\Discharge.xml");

                Session["EDPReport"] = ds;
                if (rdoListType.Text == "1")
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Reports/Forms/EDPReport.aspx?ReportType=A" + ddlReportType.SelectedValue + "');", true);
                else
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Reports/Forms/EDPReport.aspx?ReportType=D" + ddlReportType.SelectedValue + "');", true);



            }


        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

        }
    }
}
