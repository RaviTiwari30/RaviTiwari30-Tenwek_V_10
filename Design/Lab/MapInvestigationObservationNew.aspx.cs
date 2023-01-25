using System;
using System.Data;
using System.Web.UI.WebControls;
using System.Text;
using System.Web.Services;


public partial class Design_Lab_MapInvestigationObservationNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Bind_Investigation();
            BindObservation();
            BindDepartment();
            BindInvListBox();
            All_LoadData.bindDocTypeList(cmbDept, 5, "Select"); 
            All_LoadData.bindCenterDropDownList(ddlCentre_popup, Session["CentreID"].ToString(), "");
        }
    }
    [WebMethod]
    public static string BindMachine()
    {
        //DataTable dt = StockReports.GetDataTable("SELECT MachineID TEXT,MachineID VALUE FROM labobservation_range  GROUP BY MachineID ");
        DataTable dt = StockReports.GetDataTable("SELECT NAME as TEXT,id as VALUE FROM macmaster WHERE IsActive=1 AND LabMachine=1 ");
        //if (dt.Rows.Count > 0)
        //{
        //    ddlMachine_popup.DataSource = dt;
        //    ddlMachine_popup.DataTextField = "TEXT";
        //    ddlMachine_popup.DataValueField = "VALUE";
        //    ddlMachine_popup.DataBind();
        //}
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
   }
    private void BindSampleType()
    {
        string str = "Select ID,SampleType from sample_type where IsActive=1 ORDER BY sampletype";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSample.DataSource = dt;
            ddlSample.DataTextField = "SampleType";
            ddlSample.DataValueField = "ID";
            ddlSample.DataBind();
            ddlSample.Items.Insert(0, new ListItem("Select", "0"));
        }
    }  
   private void BindObservation()
    {       
        string str=" SELECT LOM.LabObservation_ID, LOM.Name as ObsName,LOM.Minimum,LOM.Maximum,LOM.MinFemale,LOM.MaxFemale,LOM.MinChild,LOM.MaxChild,LOM.ReadingFormat, '0' printOrder,'0' Child_Flag  FROM labobservation_master lom  ORDER BY lom.name ";     
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlObservation.DataSource = dt;
            ddlObservation.DataTextField = "ObsName";
            ddlObservation.DataValueField = "LabObservation_ID";
            ddlObservation.DataBind();
            ddlObservation.Items.Insert(0, new ListItem("----Select Observation----", ""));
        }
    }
    private void BindDepartment()
    {
        DataTable dt = AllLoadData_OPD.BindLabRadioDepartment(Session["RoleID"].ToString());
        ddlGroupHead.DataSource = dt;
        ddlGroupHead.DataTextField = "Name";
        ddlGroupHead.DataValueField = "ObservationType_ID";
        ddlGroupHead.DataBind();
        ddlDepartment.DataSource = dt;
        ddlDepartment.DataTextField = "Name";
        ddlDepartment.DataValueField = "ObservationType_ID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("All Investigations", "ALL"));
    }



    private void Bind_Investigation()
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append(" select CONCAT(IFNULL(im.ItemCode,''),' # ',inv.name)NAME ,inv.Investigation_id from f_itemmaster im   ");
        sb.Append(" select inv.Name ,inv.Investigation_id from f_itemmaster im   ");
        sb.Append(" inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID  ");
        sb.Append("  inner join f_configrelation c on c.CategoryID=sc.CategoryID ");
        sb.Append("  inner join investigation_master inv on inv.Investigation_id=im.Type_id   ");
        sb.Append("  and c.ConfigID='3'  and im.IsActive=1 AND sc.Active=1 ");
        if (Session["LoginType"].ToString().ToUpper() == "RADIOLOGY")
        {
            sb.Append(" and inv.ReportType=5 ");
        }
        else
        {
            sb.Append(" and inv.ReportType<>5 ");
        }
        sb.Append("order by inv.Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlInvestigation.DataSource = dt;
            ddlInvestigation.DataTextField = "Name";
            ddlInvestigation.DataValueField = "Investigation_Id";
            ddlInvestigation.DataBind();
            ddlInvestigation.Items.Insert(0, new ListItem( "----Select Investigation----",""));
        }
    }

    private void BindInvListBox()
    {      
        MapInvestigation_Observation objmap = new MapInvestigation_Observation();
        DataTable dt1 = objmap.BindInvListBox(ddlDepartment.SelectedValue);      
        lstInvestigation.DataSource = dt1;
        lstInvestigation.DataTextField = "Name";
        lstInvestigation.DataValueField = "newValue";
        lstInvestigation.DataBind();
    }
}
