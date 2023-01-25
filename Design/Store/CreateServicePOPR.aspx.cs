using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Design_Store_CreateServicePOPR : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_Store.bindStore(ddlStoreType, "STO");
            DataTable dt = StockReports.GetRights(Session["RoleID"].ToString());
            if (dt.Rows.Count > 0)
            {
                if (Util.GetBoolean(dt.Rows[0]["IsGeneral"]) == true && Util.GetBoolean(dt.Rows[0]["IsMedical"]) == true)
                    ddlStoreType.SelectedIndex = ddlStoreType.Items.IndexOf(ddlStoreType.Items.FindByValue("STO00001"));
                else if (Util.GetBoolean(dt.Rows[0]["IsMedical"]) == true)
                {
                    ddlStoreType.SelectedIndex = ddlStoreType.Items.IndexOf(ddlStoreType.Items.FindByValue("STO00001"));
                    ddlStoreType.Attributes.Add("disabled", "disabled");
                }
                else if (Util.GetBoolean(dt.Rows[0]["IsGeneral"]) == true)
                {
                    ddlStoreType.SelectedIndex = ddlStoreType.Items.IndexOf(ddlStoreType.Items.FindByValue("STO00002"));
                    ddlStoreType.Attributes.Add("disabled", "disabled");
                }
            }
            ViewState["centerID"] = Session["CentreID"].ToString();
            ViewState["deptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["userID"] = Session["ID"].ToString();
            ViewState["PurchaseRequestNo"] = Util.GetString(Request.QueryString["PurchaseRequestNo"]);

            calExtenderFromDate.EndDate = System.DateTime.Now;
            calExtenderToDate.EndDate = System.DateTime.Now;
            CalExtenTxtSearchPurchaseFromDate.EndDate = System.DateTime.Now;
            CalExtenTxtSearchPurchaseToDate.EndDate = System.DateTime.Now;


            calExtRequisitionOn.EndDate = System.DateTime.Now;

            txtSearchPurchaseFromDate.Text = txtSearchPurchaseToDate.Text = txtSearchFromDate.Text = txtSearchToDate.Text = txtRequisitionOn.Text = txtFromDate.Text = txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            //txtFromDate.Text = "28-May-2018";

        }
        txtSearchFromDate.Attributes.Add("readonly", "true");
        txtSearchToDate.Attributes.Add("readonly", "true");
        txtRequisitionOn.Attributes.Add("readonly", "true");
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
        txtSearchPurchaseFromDate.Attributes.Add("readonly", "true");
        txtSearchPurchaseToDate.Attributes.Add("readonly", "true");
    }
}