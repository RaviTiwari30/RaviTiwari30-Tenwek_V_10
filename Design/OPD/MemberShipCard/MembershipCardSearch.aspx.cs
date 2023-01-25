using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Design_OPD_MemberShipCard_MembershipCardSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.SetCurrentDate();
            txtFromDate.SetCurrentDate();
            txtExpiryFrom.SetCurrentDate();
            txtExpiryTo.SetCurrentDate();
            BindCardType();
        }
    }
    private void BindCardType()
    {
        ddlCardType.DataSource = StockReports.GetDataTable("SELECT ID,NAME FROM membership_card_master WHERE IsActive=1");
        ddlCardType.DataValueField = "ID";
        ddlCardType.DataTextField = "Name";
        ddlCardType.DataBind();
        ddlCardType.Items.Insert(0, "");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append(" SELECT mc.CardNo,mc.Name,mc.Age,mc.Gender,mc.Address,mc.Phone,mc.Mobile,mc.email,mc.MembershipCardName,DATE_FORMAT(mc.ValidFrom,'%d %b %Y')ValidFrom,DATE_FORMAT(mc.ValidTo,'%d %b %Y')ValidTo,mc.ReceiptNo,mc.Amount,mc.Status,mc.Source,mc.SourceName,mc.ReferedBy,mc.ReferedByname FROM membershipcard mc where ValidFrom>='" + txtFromDate.GetDateForDataBase() + "' and ValidFrom<='" + txtToDate.GetDateForDataBase() + "' ");

        if (ddlCardStatus.SelectedIndex > 0)
        {
            sb.Append(" and status='" + ddlCardStatus.SelectedItem.Value + "'");
        }
        if (ddlCardType.SelectedIndex > 0)
        {
            sb.Append(" and mc.MembershipCardID=" + ddlCardType.SelectedItem.Value + "");
        }
        if (chkExpiry.Checked)
        {
            sb.Append(" and ValidFrom>='" + txtExpiryFrom.GetDateForDataBase() + "' and ValidTo<='" + txtExpiryTo.GetDateForDataBase() + "'");
        }
        if (txtCardNo.Text.Length > 0)
        {
            sb.Append(" and mc.CardNo='" + txtCardNo.Text + "'");
        }

        
        
        DataTable dt= StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["CustomData"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../../Design/Payroll/CustomReportForExport.aspx');", true);
        }
    }
}
