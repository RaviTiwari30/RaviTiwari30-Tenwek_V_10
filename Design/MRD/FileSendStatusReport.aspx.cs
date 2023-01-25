using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_FileSendStatusReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPatientID.Focus();
            
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
         
            BindPanel();
            //BindParentPanel();
            All_LoadData.BindPanelIPD(ddlParentPanel);
            ddlParentPanel.Items.Insert(0, new ListItem("Select"));
            All_LoadData.bindDoctor(cmbDoctor, "ALL");
            AllLoadData_IPD.bindCaseType(cmbRoom,"ALL");
           
            AllLoadData_IPD.bindDischargeType(ddlDischageType);
            ddlDischageType.Items.Insert(0, new ListItem("ALL"));
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
    public void BindPanel()
    {
        try
        {
            DataTable dt = LoadCacheQuery.loadAllPanel();
            cmbCompany.DataSource = dt;
            cmbCompany.DataTextField = "Company_Name";
            cmbCompany.DataValueField = "PanelID";
            cmbCompany.DataBind();
            cmbCompany.Items.Insert(0, new ListItem("Select"));
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    //public void BindParentPanel()
    //{
    //    try
    //    {
    //        DataTable dt = LoadCacheQuery.loadAllPanel();
    //        ddlParentPanel.DataSource = dt;
    //        ddlParentPanel.DataTextField = "Company_Name";
    //        ddlParentPanel.DataValueField = "Panel_ID";
    //        ddlParentPanel.DataBind();
    //        ddlParentPanel.Items.Insert(0, new ListItem("Select"));
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog objClassLog = new ClassLog();
    //        objClassLog.errLog(ex);
    //    }
    //}
}