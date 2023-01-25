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

public partial class Design_Equipment_Masters_AssetTypeReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindAssetType();
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }

        ucFromDate.Attributes.Add("readonly","readonly");
        ucToDate.Attributes.Add("readonly","readonly");

    }

    private void BindAssetType()
    {
        DataTable dt = StockReports.GetDataTable("Select AssetTypeName,AssetTypeID from eq_assettype_master where isActive=1 order by AssetTypeName");
        ddlassettype.DataSource = dt;
        ddlassettype.DataTextField = "AssetTypeName";
        ddlassettype.DataValueField = "AssetTypeID";
        ddlassettype.DataBind();

        ddlassettype.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlassettype.SelectedIndex = 0;
    }

    public DataTable LoadData(string status, string AssetTypeID)
    {
        string str = "SELECT pms.MachineName,date_format(pms.PMSDoneDate,'%d-%b-%Y')PMSDoneDate,date_format(pms.DueDate,'%d-%b-%Y')DueDate,pms.IsActive,pms.assetcode,";
        str += "am.AssetTypeID FROM eq_preventivems pms INNER JOIN eq_asset_master am ON pms.assetcode=am.assetcode where am.IsActive='1' AND (DATE(pms.InsertDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(pms.InsertDate)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "')";

        if (AssetTypeID.ToString() != "SELECT")
        {
            str += "AND am.AssetTypeID='" + AssetTypeID + "'";
        }
        DataTable dt = StockReports.GetDataTable(str);
        return dt;
    }
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        if (Session["LoginType"] == null)
        {
            return;
        }
        DataTable dtUser = new DataTable();
        dtUser = StockReports.GetUserName(Convert.ToString(Session["ID"]));
        DataColumn dc = new DataColumn();
        dc.ColumnName = "Period";
        dc.DefaultValue = "Period Form'" + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + "','" + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy") + "'";
        dtUser.Columns.Add(dc);
        dc = new DataColumn();
        dc.ColumnName = "ReportType";
        dc.DefaultValue = "2";
        dtUser.Columns.Add(dc);

        DataTable dtreport = new DataTable();
        if (rdoListType.Text == "1")
        
        dtreport=LoadData("1",ddlassettype.SelectedValue.ToString());
        
        else
        
         dtreport=LoadData("0",ddlassettype.SelectedValue.ToString());

            if(dtreport.Rows.Count>0)
            {
            lblmsg.Text="Total"+dtreport.Rows.Count+"Record Found";
                 DataSet ds=new DataSet();
                ds.Tables.Add(dtreport.Copy());
                ds.Tables[0].TableName = "AssetTypeName";
                ds.Tables.Add(dtUser.Copy());
                ds.Tables[1].TableName = "User";
                ds.WriteXmlSchema(@"D:\AssetTypeName.xml");
                //ds.WriteXmlSchema(@"E:\EquipmentReport.xml");
                 Session["EquipmentReport"] = ds;
            string ReportType="AssetTypeName";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Reports/EquipmentReport.aspx?ReportType=" + ReportType + "');", true);
              }
        else
            {
            lblmsg.Text = "No Record Found";
            }
    

            }




   

            
    
}
