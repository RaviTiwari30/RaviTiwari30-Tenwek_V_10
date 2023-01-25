using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;

public partial class Design_Finance_ReceiptEdit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
          DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
          if (dtAuthority.Rows.Count > 0)
          {
              if (dtAuthority.Rows[0]["CanChangePaymentDetails"].ToString() != "")
              {
                  lblCanChangePaymentDetails.Text = "1";
              }
              else
              {
                  lblCanChangePaymentDetails.Text = "1";
              }
          }
          else {
              lblCanChangePaymentDetails.Text = "1";
          }
    }
}