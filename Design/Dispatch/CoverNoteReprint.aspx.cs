using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Dispatch_CoverNoteReprint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           // All_LoadData.bindPanel(ddlPanelCompany, "ALL");
           // ddlPanelCompany.Items.RemoveAt(0);
           // ddlPanelCompany.SelectedIndex = 0;
            bindPanel();
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        ucFromDate.Attributes.Add("readOnly", "readOnly");
        ucToDate.Attributes.Add("readOnly", "readOnly");
    }

    private void bindPanel()
    {
        DataTable dt = All_LoadData.loadPanelRoleWisePanelGroupWise(1);
        if (dt.Rows.Count > 0)
        {
            ddlPanelCompany.DataSource = dt;
            ddlPanelCompany.DataTextField = "Company_Name";
            ddlPanelCompany.DataValueField = "PanelID";
            ddlPanelCompany.DataBind();
           // ddlPanelCompany.Items.Insert(0, "ALL");
        }
        else
        {
            ddlPanelCompany.Items.Insert(0, "--No Panel Found--");
            lblMsg.Text = "Please Map Panel Group with Selected Role or Enable Cover Note Feature from Panel Master.";
        }

    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindCoverNodeData();
    }

    private void BindCoverNodeData()
    { 
        StringBuilder sb =new StringBuilder();
        sb.Append(" SELECT cv.`CoverNoteNo`,if(pmh.Type IN('IPD','EMG'),pmh.TransNo,'') as TransNo,pmh.Type, DATE_FORMAT(cv.`CreatedDateTime`,'%d-%b-%y')CoverNoteDate,GROUP_CONCAT(cv.`BillNo` SEPARATOR ' </br>') as BillNo,cv.`PanelName`,cv.`PatientName`,cv.`PatientID` FROM f_covernote cv INNER JOIN patient_medical_history pmh on pmh.TransactionID=cv.TransactionID WHERE cv.`IsCancel`=0 ");
        if (txtCoverNoteNo.Text.Trim() != string.Empty)
            sb.Append("  AND cv.`CoverNoteNo`='" + txtCoverNoteNo.Text.Trim() + "' ");
        else
        {
            if (txtMRNo.Text.Trim() != string.Empty)
                sb.Append("  AND cv.`PatientID`='" + txtMRNo.Text.Trim() + "' ");
            if (ddlPanelCompany.SelectedItem.Value != "ALL")
                sb.Append(" AND cv.PanelID='" + ddlPanelCompany.SelectedItem.Value + "'  ");
            if (txtPatientName.Text.Trim() != string.Empty)
                sb.Append(" AND cv.`PatientName` like '%" + txtPatientName.Text.Trim() + "%' ");

            if (txtTransNo.Text.Trim() != string.Empty && rblType.SelectedValue != "OPD")
                sb.Append(" AND pmh.`TransNo` = '" + txtTransNo.Text.Trim() + "' ");

            sb.Append("AND pmh.Type='" + rblType.SelectedValue + "'   "); 

        }
       
        if(txtMRNo.Text.Trim() == string.Empty && txtCoverNoteNo.Text.Trim() == string.Empty && txtTransNo.Text.Trim() == string.Empty)
            sb.Append(" AND DATE(cv.`CreatedDateTime`) >='" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(cv.`CreatedDateTime`)<='" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");

        sb.Append(" AND cv.CentreID='" + Session["CentreID"].ToString() + "' GROUP BY cv.CoverNoteNo order by  cv.`CoverNoteNo`  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            divShow.Visible = true;
            lblMsg.Text = dt.Rows.Count + " Records Found.";
            gvItems.DataSource = dt;
            gvItems.DataBind();


            
        }
        else
        {
            lblMsg.Text = "No Receord Found..";
            divShow.Visible = false;
        }

    }

    protected void PrintData(string CoverNoteNo,string Type)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('CoverNotePrintOut_pdf.aspx?CoverNoteNo="+ CoverNoteNo +"&Type="+ Type +"');", true);
    }
    protected void gvItems_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "print")
        {
            string CoverNoteNo = e.CommandArgument.ToString();
            PrintData(CoverNoteNo.Split('#')[0], CoverNoteNo.Split('#')[1]);
        }
    }


}