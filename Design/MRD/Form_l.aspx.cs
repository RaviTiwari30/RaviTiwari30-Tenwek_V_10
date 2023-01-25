using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Lab_Form_L : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BindDisease();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
            bindPatientType();
        }
        FrmDate.Attributes.Add("readOnly", "true");
        ToDate.Attributes.Add("readOnly", "true");
    }
    private void bindPatientType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DISTINCT(pmh.TYPE)PType FROM patient_medical_history pmh ORDER BY TYPE");
        ddlPatientType.DataSource = dt;
        ddlPatientType.DataTextField = "PType";
        ddlPatientType.DataValueField = "PType";
        ddlPatientType.DataBind();
        ddlPatientType.Items.Insert(0, new ListItem("ALL"));
        
    }
    private void BindDisease()
    {
        string str = "select  mdm.DiseaseId,mdm.DiseaseName FROM mrd_disease_master mdm WHERE IsActive=1 order by DiseaseName";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            chkDiseaseList.DataSource = dt;
            chkDiseaseList.DataTextField = "DiseaseName";
            chkDiseaseList.DataValueField = "DiseaseId";
            chkDiseaseList.DataBind();
        }
    }
    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }

        return str;
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        string Disease = GetSelection(chkDiseaseList);
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT(NAME) IDSP_Disease,Date_Format(plo.Date,'%d-%b-%Y')Date,COUNT(plo.Investigation_ID)TotalCase,(SELECT COUNT((Investigation_ID))PositiveCase  FROM mrd_map_investigation_disease idm ");
        sb.Append("WHERE idm.Investigation_ID=id.Investigation_ID GROUP BY investigation_ID)No_of_Positive_Case FROM  mrd_map_investigation_disease id  ");
        sb.Append("INNER JOIN patient_labinvestigation_opd plo ON plo.Investigation_ID=id.Investigation_ID ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON plo.TransactionID=pmh.Transactionid  ");
        sb.Append("WHERE DATE(DATE)>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(DATE)<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "' AND id.DiseaseID IN (" + Disease + ") And plo.CentreID IN(" + Centre + ")");

        if (ddlPatientType.SelectedValue != "ALL")
        {
            sb.Append(" and pmh.Type='" + ddlPatientType.SelectedItem.Value + "' ");
        }
        sb.Append("GROUP BY diseaseID,id.Investigation_ID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["ReportName"] = "Form - L Weekly Laboratory Surveillance Report";
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
    }
}