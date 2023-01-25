using System;
using System.Data;
using System.Web.UI.WebControls;
using System.Web.Services;
public partial class Design_OPD_Registration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblMsg.Text = "";
            cmbTitle.Focus();
            All_LoadData.bindcountry(ddlNationality);
            All_LoadData.bindTitle(cmbTitle);          
            BindCity();
            bindmartialstatus();        
            All_LoadData.BindCard(ddlCardTypeReg);
            txtHash.Text = Util.getHash();
            calDOB.EndDate = DateTime.Now;
            calDOB.StartDate = DateTime.Now.AddYears(-150);
            lblGovTaxPer.Text = "0.00";
            BindDocotr();          
            ((Label)PaymentControl.FindControl("lblGovTaxPer")).Text = "Gov. Tax (0 %) :&nbsp; ";
        }      
        txtDOB.Attributes.Add("readOnly", "true");             
    }
    protected void BindDocotr()
    {
        DataTable dtDocList = All_LoadData.LoadDoctor();
        ddlDoctorList.DataSource = dtDocList;
        ddlDoctorList.DataTextField = "Name";
        ddlDoctorList.DataValueField = "DoctorID";
        ddlDoctorList.DataBind();
        ddlDoctorList.SelectedIndex = ddlDoctorList.Items.IndexOf(ddlDoctorList.Items.FindByText("Dr. SELF"));
        ddlDoctorList.Attributes.Add("disabled", "true");
    }        
    [WebMethod]
    public static string GetRate(string ItemId, string PanelID)
    {
        DataTable dtRate = AllLoadData_OPD.GetItem(ItemId, PanelID);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dtRate);
        return rtrn;
    }
    [WebMethod]
    public static string getDocName(string DoctorID)
    {
        string strDoc = StockReports.ExecuteScalar("SELECT CONCAT(title,'',NAME)Name FROM doctor_master WHERE DoctorID='" + DoctorID + "' ");
        return strDoc;
    }   
    protected void BindCity()
    {
        DataTable dt = All_LoadData.BindCity(ddlNationality.SelectedValue.ToString().Trim(),"");
       
        ddlCity.DataSource = dt;
        ddlCity.DataTextField = "City";
        ddlCity.DataValueField = "City";
        ddlCity.DataBind();
        ddlCity.SelectedItem.Text = GetGlobalResourceObject("Resource", "DefaultCity").ToString();
    }  
    private void bindTitle()
    {
        cmbTitle.DataSource = AllGlobalFunction.NameTitle;
        cmbTitle.DataBind();
    }
    private void bindmartialstatus()
    {
        ddlmarital.DataSource = AllGlobalFunction.MartialStatus;
        ddlmarital.DataBind();
        ddlmarital.SelectedIndex = ddlmarital.Items.IndexOf(ddlmarital.Items.FindByText("Single"));
    }
}