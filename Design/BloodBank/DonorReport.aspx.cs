using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_BloodBank_DonorReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = Search();
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + txtdatefrom.Text + " To : " + txtdateTo.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "DonorReport";

            //ds.WriteXmlSchema("C:/DonorReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../BloodBank/Commenreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = Search();
        if (dt.Rows.Count > 0)
        {
            grdDonorList.DataSource = dt;
            grdDonorList.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            grdDonorList.DataSource = null;
            grdDonorList.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
            pnlHide.Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BloodBank.bindBloodGroup(ddlBloodgroup);
            ddlBloodgroup.Items.Insert(0, new ListItem("Select", "0"));
            txtdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            btnPrint.Attributes.Add("onclick", String.Format("this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnPrint, String.Empty)));
        }
        txtdatefrom.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }

    private DataTable Search()
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT bv.Visitor_ID,bv.name,bv.dtBirth,bv.Gender,concat(bv.address,',',bv.city)address,IF(bv.MobileNo='',bv.phoneNo,bv.MobileNo)MobileNo,  bgm.BloodGroup,DATE_FORMAT(bv.Blood_DonateDate,'%d-%b-%Y')CollectedDate ");
            sb.Append("   FROM bb_visitors bv  INNER JOIN bb_visitors_history vh ON vh.visitor_id=bv.Visitor_ID LEFT JOIN bb_bloodgroup_master bgm ON bgm.id=bv.BloodGroup_Id  Where bv.Visitor_ID IS NOT null AND bv.CentreID=" + Util.GetInt(Session["CentreID"]) + " ");
            if (txtDonorId.Text != "")
            {
                sb.Append(" AND bv.Visitor_ID='" + txtDonorId.Text + "'");
            }
            if (txtName.Text != "")
            {
                sb.Append(" AND bv.name like '" + txtName.Text + "%'");
            }
            if (ddlBloodgroup.SelectedIndex != 0)
            {
                sb.Append(" AND bgm.BloodGroup='" + ddlBloodgroup.SelectedItem.Text + "'");
            }
            if (txtdatefrom.Text != "")
            {
                sb.Append(" AND DATE(bv.dtEntry)>='" + Util.GetDateTime(txtdatefrom.Text).ToString("yyyy-MM-dd") + "' ");
            }
            if (txtdateTo.Text != "")
            {
                sb.Append(" and DATE(bv.dtEntry)<='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + "'");
            }
            dt1 = StockReports.GetDataTable(sb.ToString());
            return dt1;
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return dt1;
        }
    }
}