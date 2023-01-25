using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Purchase_CreatePO : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["centerID"] = Session["CentreID"].ToString();
            ViewState["deptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["userID"] = Session["ID"].ToString();
            txtDeliveryDate.Text = txtPODate.Text = txtValidDate.Text=txtFromDate.Text=txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calDelivery.StartDate = calPODate.StartDate = calValid.StartDate = DateTime.Now;
            AllLoadData_Store.bindTypeMaster(ddlType);
            ViewState["PurchaseOrderNo"] = Util.GetString(Request.QueryString["purchaseOrderNo"]);


            calExtenderFromDate.EndDate = System.DateTime.Now;
            calExtenderToDate.EndDate = System.DateTime.Now;
            CalendarExtender1.StartDate = System.DateTime.Now;
            CalendarExtender2.StartDate = System.DateTime.Now;




            txtQuotationFromDate.Text = txtQuotationToDate.Text = txtToDateSearch.Text = txtFromDateSearch.Text = txtFromDate.Text = txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            

        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
        txtFromDateSearch.Attributes.Add("readonly", "true");
        txtToDateSearch.Attributes.Add("readonly", "true");
        txtQuotationFromDate.Attributes.Add("readonly", "true");
        txtQuotationToDate.Attributes.Add("readonly", "true");

    }
}