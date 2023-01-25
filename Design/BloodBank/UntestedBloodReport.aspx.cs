using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_BloodBank_UntestedBloodReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = search();
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
            Session["ReportName"] = "UntestedBlood";

            //ds.WriteXmlSchema("C:/UntestedBlood.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = search();
        if (dt.Rows.Count > 0)
        {
            grdComponent.DataSource = dt;
            grdComponent.DataBind();

            pnlHide.Visible = true;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
            grdComponent.DataSource = null;
            grdComponent.DataBind();
            pnlHide.Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            btnPrint.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnPrint, String.Empty)));
        }
        txtdatefrom.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }

    private DataTable search()
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT bvh.Visitor_ID,CONCAT(bv.Title,bv.Name)NAME,bcm.ComponentName,bc.BloodCollection_Id,bc.bagType,bc.Volumn,DATE_FORMAT(bc.CreatedDate,'%d-%b-%Y')CreatedDate,");
            sb.Append(" cd.BBTubeNo FROM bb_visitors_history bvh INNER JOIN bb_visitors bv ON bv.Visitor_ID =bvh.Visitor_ID   ");
            sb.Append(" INNER JOIN bb_component bc ON bc.BloodCollection_Id =bvh.BloodCollection_Id INNER JOIN bb_collection_details cd ON cd.BloodCollection_Id=bc.BloodCollection_Id ");
            sb.Append(" INNER JOIN bb_component_master bcm ON bcm.Id=bc.Component_Id ");
            sb.Append(" WHERE  bvh.IScomponent=3  AND bvh.ISScreened IN(0,1,2,4) AND bvh.isFit=1 ");

            if (txtDonorID.Text.Trim() != "")
            {
                sb.Append(" AND bvh.Visitor_ID='" + txtDonorID.Text.Trim() + "'");
            }
            if (txtCollectionID.Text.Trim() != "")
            {
                sb.Append("AND bc.BloodCollection_Id='" + txtCollectionID.Text.Trim() + "'");
            }
            if (txtCollectionID.Text == "" && txtDonorID.Text.Trim() == "")
            {
                if (txtdatefrom.Text != "")
                {
                    sb.Append(" AND DATE(bc.CreatedDate) >='" + Util.GetDateTime(txtdatefrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtdateTo.Text != "")
                {
                    sb.Append(" and DATE(bc.CreatedDate) <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + "'");
                }
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