using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_DoctorChargesDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //BindDoctors();
            LoadDoc();
            BindGroup();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    protected void LoadDoc()
    {
        DataTable dtDoc = All_LoadData.bindDoctor();
        ddlDoctor.DataSource = dtDoc;
        ddlDoctor.DataTextField = "Name";
        ddlDoctor.DataValueField = "DoctorID";
        ddlDoctor.DataBind();
        ddlDoctor.Items.Insert(0, "All");
    }

    private void BindGroup()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DocType,ID FROM DoctorGroup WHERE isActive=1");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDoctorGroup.DataSource = dt;
            ddlDoctorGroup.DataTextField = "DocType";
            ddlDoctorGroup.DataValueField = "ID";
            ddlDoctorGroup.DataBind();
            ddlDoctorGroup.Items.Insert(0, new ListItem("ALL"));
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        string DocID = ""; int PackageCondition = 0;
        if (ddlDoctor.SelectedItem.Text.ToUpper() != "ALL")
        {
            DocID = ddlDoctor.SelectedValue;
        }
        string DocGroup = "0";
        if (ddlDoctorGroup.SelectedItem.Text.ToUpper() != "ALL")
        {
            DocGroup = ddlDoctorGroup.SelectedValue;
        }
        if (rdbReportType.SelectedValue == "0")
        {
            if (chkPackageCondition.Checked)
                PackageCondition = 1;

            DataTable dtAppDetail = AllLoadData_OPD.DoctorWiseOPDDetail(DocID, Util.GetDateTime(txtFromDate.Text), Util.GetDateTime(txtToDate.Text), PackageCondition, Centre, DocGroup);

            if (dtAppDetail.Rows.Count > 0)
            {
                lblMsg.Text = "";
                DataColumn dc = new DataColumn();
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                dtAppDetail.Columns.Add(dc);
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dtAppDetail.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dtAppDetail.Copy());
                ds.Tables.Add(dtImg.Copy());

                Session["ds"] = ds;
                 //ds.WriteXmlSchema(@"D:\DoctorWiseAppointmentDetail.xml");
                Session["ReportName"] = "DoctorWiseAppointmentDetail";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/common/Commonreport.aspx');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found', function(){});", true);
        }
        else
        {
            rdbReportType.SelectedIndex = 0;
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cm.CentreID,cm.CentreName,app.PatientID,app.Pname As Patient_Name,dm.Name AS Doctor_Name,if(app.visitType='Old Patient','Review Patient','New Patient')`Patient Type` FROM appointment app inner join center_master cm on cm.CentreID= app.CentreID INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID where  app.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND app.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' And app.PatientID<>'' and app.CentreID IN (" + Centre + ") ");
            if (DocID != "")
                sb.Append(" AND app.DoctorID='" + DocID + "' ");
            if (rdbVisitType.SelectedValue == "1")
                sb.Append(" AND app.visitType='Old Patient' ");
            else if (rdbVisitType.SelectedValue == "2")
                sb.Append(" AND app.visitType='New Patient' ");
            sb.Append(" order by cm.centreID");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                dt.Columns.Remove("CentreID");
                dt.Columns["CentreName"].ColumnName = "Centre Name";
                dt.Columns["PatientID"].ColumnName = "UHID";
                dt.Columns["Patient_Name"].ColumnName = "Patient Name";
                dt.Columns["Doctor_Name"].ColumnName = "Doctor Name";
                lblMsg.Text = "";
                Session["Period"] = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                Session["ReportName"] = "DoctorWisePatientStatus";
                Session["dtExport2Excel"] = dt;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found', function(){});", true);
            }
        }
    }
}