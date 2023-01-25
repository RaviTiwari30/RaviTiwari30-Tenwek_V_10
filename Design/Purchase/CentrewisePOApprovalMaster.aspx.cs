using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Purchase_CentrewisePOApprovalMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCategory();
        }
    }

    private void BindCategory()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT cm.Name,cm.CategoryID FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cm.categoryid = cf.categoryid  Where Active=1 and cf.ConfigID in(11,28) ORDER BY cm.Name ");
       if (dt.Rows.Count > 0)
       {
           chkCategory.DataSource = dt;
           chkCategory.DataTextField = "Name";
           chkCategory.DataValueField = "CategoryID";
           chkCategory.DataBind();
           chkCategory.RepeatColumns = 6;
         
       }
    }
}