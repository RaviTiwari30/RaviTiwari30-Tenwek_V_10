using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_Purchase_CompanyWiseVendorList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Panel1.Visible = false;
            Panel2.Visible = false;
            Panel5.Visible = false;
        }
    }
    protected void ddlOrderBy_SelectedIndexChanged(object sender, EventArgs e)
    {

        if (ddlOrderBy.SelectedItem.Value == "1")
        {
            Panel1.Visible = true;
            Panel2.Visible = false;
            Panel5.Visible = true;
            BindVendor();
        }
        else if (ddlOrderBy.SelectedItem.Value == "2")
        {
            Panel1.Visible = false;
            Panel2.Visible = true;
            Panel5.Visible = true;
            BindManufacture();
        }
        else
        {
            Panel5.Visible = false;
            Panel1.Visible = false;
            Panel2.Visible = false;
        }
    }
    public void BindManufacture()
    {

        string str1 = "select Name,ManufactureID from f_manufacture_master where IsActive = 1 order by Name";
        DataTable dt1 = StockReports.GetDataTable(str1);

        if (dt1.Rows.Count > 0)
        {
            chkCompany.DataSource = dt1;
            chkCompany.DataTextField = "Name";
            chkCompany.DataValueField = "ManufactureID";
            chkCompany.DataBind();
        }


    }
    private void BindVendor()
    {
        DataTable dtVendorList = StockReports.GetDataTable("SELECT Vendor_ID,VendorName FROM f_vendormaster");
        if (dtVendorList.Rows.Count > 0)
        {
            chklVendors.DataSource = dtVendorList;
            chklVendors.DataValueField = "Vendor_ID";
            chklVendors.DataTextField = "VendorName";
            chklVendors.DataBind();

        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        if (Panel1.Visible == true)
        {
            string VendorList = GetSelectionVendor();


            sb.Append("select VendorName 'Vendor Name',VATNo 'GST No.',if(Address1 = 'Null','',address1)As Address1,DrugLicence 'Drug Licence',Pin 'Pin Code',");
            sb.Append(" if(Address2 ='NULL','',Address2)as Address2,if(Address3 ='NULL','',Address3)as Address3,if(ContactPerson ='NULL','',ContactPerson) as 'Contact Person',Email,");
            sb.Append(" if(Mobile='NULL','',Mobile) as 'Contact No.',");
            sb.Append(" if(City = 'NULL','',City)as City,if(Area = 'NULL','',Area)as Area,if(Country = 'NULL','',Country)as Country,(SELECT NAME FROM f_manufacture_master ");
            sb.Append("  WHERE MAnufactureID=vsg.ManufactureID)'Company Name' from f_vendormaster vm LEFT JOIN f_Vendor_Company vsg ON vsg.VendorID=vm.Vendor_ID ");
            if (chkVendor.Checked == false)
            {
                if (VendorList != "")
                {
                    sb.Append(" where vsg.VendorID in(" + VendorList + ") ");
                }

            }
            sb.Append(" order by VendorName");

            DataTable dtReport = StockReports.GetDataTable(sb.ToString());
            if (dtReport.Rows.Count > 0)
            {
                if (rdoReportFormat.SelectedItem.Value == "1")
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dtReport.Copy());
                    //ds.WriteXmlSchema(@"C:\Vendor_CompanyReport1.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "Vendor_CompanyReport1";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
                }
                else
                {
                    Session["dtExport2Excel"] = dtReport;
                    Session["ReportName"] = "Supplier Report (By Supplier )";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);

                }
            }


        }
        else if (Panel2.Visible == true)
        {
            string ComapnyList = GetSelectionCompany();


            sb.Append(" SELECT NAME,Address,Phone 'Contact No',Fax,Email,dlno 'DL No',tinno 'TIN No',");
            sb.Append(" (SELECT VendorName FROM f_vendormaster vm WHERE vm.Vendor_ID=vsg.VendorID)'Vendor Name' FROM f_manufacture_master mm");
            sb.Append(" LEFT JOIN f_Vendor_Company vsg ON vsg.ManufactureID=mm.MAnufactureID ");
            if (chkAllCompany.Checked == false)
            {
                if (ComapnyList != "")
                {
                    sb.Append(" where vsg.MAnufactureID in(" + ComapnyList + ") ");
                }

            }
            sb.Append(" ORDER BY NAME");


            DataTable dtReport = StockReports.GetDataTable(sb.ToString());

            if (dtReport.Rows.Count > 0)
            {
                if (rdoReportFormat.SelectedItem.Value == "1")
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dtReport.Copy());

                    //ds.WriteXmlSchema(@"C:\Vendor_CompanyReport2.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "Vendor_CompanyReport2";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
                }
                else
                {
                    Session["dtExport2Excel"] = dtReport;
                    Session["ReportName"] = "Supplier Manufacturer Report (By Manufacturer)";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);

                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }


    }
    private string GetSelectionVendor()
    {
        string vendors = "";
        if (chkVendor.Checked == false)
        {
            foreach (ListItem li in chklVendors.Items)
            {
                if (li.Selected)
                {
                    if (vendors == "")
                        vendors = "'" + li.Value + "'";
                    else
                        vendors = vendors + ",'" + li.Value + "'";
                }
            }


        }
        return vendors;

    }
    private string GetSelectionCompany()
    {
        string Comapany = "";
        if (chkAllCompany.Checked == false)
        {
            foreach (ListItem li in chkCompany.Items)
            {
                if (li.Selected)
                {
                    if (Comapany == "")
                        Comapany = "'" + li.Value + "'";
                    else
                        Comapany = Comapany + ",'" + li.Value + "'";
                }
            }


        }
        return Comapany;

    }
    protected void btnCmmpRpt_Click(object sender, EventArgs e)
    {

    }
    //protected void chkVendor_CheckedChanged(object sender, EventArgs e)
    //{

    //}
    protected void chkVendor_CheckedChanged(object sender, EventArgs e)
    {
        if (chklVendors.Items.Count > 0)
        {
            foreach (ListItem li in chklVendors.Items)
            {
                li.Selected = chkVendor.Checked;
            }
        }
    }
    protected void chkAllCompany_CheckedChanged(object sender, EventArgs e)
    {
        if (chkCompany.Items.Count > 0)
        {
            foreach (ListItem li in chkCompany.Items)
            {
                li.Selected = chkAllCompany.Checked;
            }
        }
    }
}
