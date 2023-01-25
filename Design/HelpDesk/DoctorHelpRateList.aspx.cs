using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_HelpDesk_DoctorHelpRateList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtName.Focus();
           
            All_LoadData.bindDocTypeList(ddlDepartment, 5, "ALL");
            All_LoadData.bindDocTypeList(ddlSpecialization, 3, "ALL");
           
            BindPanel();
            BindCaseType();
            BindSubCategory();
        }
    }

    private void BindCaseType()
    {
        try
        {
            string sql = "select icm.Name,icm.IPDCaseTypeID from ipd_case_type_master icm inner join ipd_case_type_master bc on icm.IPDCaseTypeID = bc.BillingCategoryID where icm.IsActive=1 group by icm.IPDCaseTypeID order by icm.name";

            cmbCaseType.DataSource = StockReports.GetDataTable(sql);
            cmbCaseType.DataTextField = "Name";
            cmbCaseType.DataValueField = "IPDCaseTypeID";
            cmbCaseType.DataBind();
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    private void BindPanel()
    {
        try
        {
            ddlPanel.Items.Clear();
            DataTable dt = CreateStockMaster.LoadPanelCompanyRef();
            foreach (DataRow dr in dt.Rows)
            {
                ListItem li1 = new ListItem(dr[0].ToString(), dr[1].ToString() + "#" + dr[2].ToString() + "#" + dr[3].ToString());
                li1.Attributes["REFID"] = dr[2].ToString();
                li1.Attributes["REFIDOPD"] = dr[3].ToString();
                ddlPanel.Items.Add(li1);
                ddlPanel.Attributes.Add("REFID", dr[2].ToString());
                ddlPanel.Attributes["REFIDOPD"] = dr[3].ToString();
            }

            ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByText(AllGlobalFunction.Panel));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }


    private void BindSubCategory()
    {
        DataTable dt = CreateStockMaster.LoadSubCategoryType();
        cmbSubCategory.DataSource = dt;
        cmbSubCategory.DataTextField = "Name";
        cmbSubCategory.DataValueField = "SubCategoryID";
        cmbSubCategory.DataBind();
    }
}