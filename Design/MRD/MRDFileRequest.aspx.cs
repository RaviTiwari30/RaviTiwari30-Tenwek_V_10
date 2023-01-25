using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_MRDFileRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPatientID.Focus();

            MRDReceivedfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            MRDReceivedTodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindDays();
            bindHours();
            BindPanel();
            BindParentPanel();
            All_LoadData.BindPanelIPD(cmbCompany);
            cmbCompany.Items.Insert(0, new ListItem("Select"));
            All_LoadData.bindDoctor(cmbDoctor, "All");
            AllLoadData_IPD.bindCaseType(cmbRoom, "ALL");

            AllLoadData_IPD.bindDischargeType(ddlDischageType);
            bindPatientType();
        }
       
    }
    private void bindPatientType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DISTINCT(pmh.TYPE)PType FROM patient_medical_history pmh ORDER BY TYPE");
        ddlPatientType.DataSource = dt;
        ddlPatientType.DataTextField = "PType";
        ddlPatientType.DataValueField = "PType";
        ddlPatientType.DataBind();
        ddlPatientType.Items.Insert(0, new ListItem("ALL"));
        ddlPatientType.SelectedIndex = 2;
    }
    public void bindDays()
    {
        ddldays.Items.Insert(0, "Select");
        for (int index = 1; index <= 31; index++)
        {
            ddldays.Items.Add(index.ToString());

        }
        ddldays.SelectedIndex = 0;
    }
    public void bindHours()
    {
       // ddlHours.Items.Insert(0, "Select");
        for (int index = 1; index <= 24; index++)
        {
            ddlHours.Items.Add((index-1).ToString("00"));

        }
        
    }
    public void BindPanel()
    {
        try
        {
            DataTable dt = LoadCacheQuery.loadAllPanel();
            cmbCompany.DataSource = dt;
            cmbCompany.DataTextField = "Company_Name";
            cmbCompany.DataValueField = "Panel_ID";
            cmbCompany.DataBind();
            cmbCompany.Items.Insert(0, new ListItem("Select"));
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    public void BindParentPanel()
    {
        try
        {
            DataTable dt = LoadCacheQuery.loadAllPanel();
            ddlParentPanel.DataSource = dt;
            ddlParentPanel.DataTextField = "Company_Name";
            ddlParentPanel.DataValueField = "Panel_ID";
            ddlParentPanel.DataBind();
            ddlParentPanel.Items.Insert(0, new ListItem("Select"));
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
}