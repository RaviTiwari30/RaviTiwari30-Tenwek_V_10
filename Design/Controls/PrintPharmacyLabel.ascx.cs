using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Text;

public partial class Design_Controls_PrintPharmacyLabel : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Bindlabelmaster();
        }
    }
    private void Bindlabelmaster()
    {
        DataTable dtDuration = LoadCacheQuery.LoadMedicineQuantity("Duration");
        ddlDuration.DataSource = dtDuration;
        ddlDuration.DataTextField = "Name";
        ddlDuration.DataValueField = "Quantity";
        ddlDuration.DataBind();
        ddlDuration.Items.Insert(0, new ListItem("", "0"));
        //DataTable dtTime = LoadCacheQuery.LoadMedicineQuantity("Time");

        string str = "SELECT   sd.Id,CONCAT(sd.Id,'#',IF(COUNT(sdt.DoseId)=0,1,COUNT(sdt.DoseId)))IdTimes,sd.Name	 FROM  tenwek_standard_dose sd LEFT JOIN tenwek_standard_dose_time sdt ON sd.Id=sdt.DoseId WHERE sd.IsActive=1 GROUP BY sd.Id";
        DataTable dt = StockReports.GetDataTable(str);
        ddlTime.DataSource = dt;
        ddlTime.DataTextField = "Name";
        ddlTime.DataValueField = "Id";
        ddlTime.DataBind();
        ddlTime.Items.Insert(0, new ListItem(" ", "0"));
        DataTable dtDose = LoadCacheQuery.LoadMedicineQuantity("Dose");
        ddlDose.DataSource = dtDose;
        ddlDose.DataTextField = "Name";
        ddlDose.DataValueField = "Name";
        ddlDose.DataBind();
        ddlDose.Items.Insert(0, new ListItem("", "0"));
        DataTable dtCaution = LoadCacheQuery.LoadMedicineQuantity("Caution");
        ddlSideEffect.DataSource = dtCaution;
        ddlSideEffect.DataTextField = "Name";
        ddlSideEffect.DataValueField = "Name";
        ddlSideEffect.DataBind();
        ddlSideEffect.Items.Insert(1, new ListItem("Keep In Cool Place", "1"));
        DataTable dtMeal = LoadCacheQuery.LoadMedicineQuantity("Meal");
        ddlMeal.DataSource = dtMeal;
        ddlMeal.DataTextField = "Name";
        ddlMeal.DataValueField = "Name";
        ddlMeal.DataBind();
        ddlMeal.Items.Insert(0, new ListItem("", "0"));
    }
}