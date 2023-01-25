using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Lab_LaboratoryCountReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            if (!IsPostBack)
            {
                FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                BindDepartment();
                All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
            }
            FrmDate.Attributes.Add("readOnly", "true");
            ToDate.Attributes.Add("readOnly", "true");
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
    private void BindDepartment()
    {
        DataTable dt = AllLoadData_OPD.BindLabRadioDepartment(HttpContext.Current.Session["RoleID"].ToString());
        if ( (dt !=null) && (dt.Rows.Count > 0) )
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "Name";
            ddlDepartment.DataValueField = "ObservationType_ID";
            ddlDepartment.DataBind();
            
            
        }
        else
        {
            ddlDepartment.DataSource = null;
            ddlDepartment.DataTextField = "";
            ddlDepartment.DataValueField = "";
            ddlDepartment.DataBind();
            ddlDepartment.Enabled = false;
            
        }
        ddlDepartment.Items.Insert(0, new ListItem("ALL", "0"));
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string ageFrom = "", ageTo = "";

        if (txtFromAge.Text.Trim() != "")
        {
            ageFrom = txtFromAge.Text.Trim() + " " + ddlAgeFrom.SelectedItem.Text;
        }

        if (txtToAge.Text.Trim() != "")
        {
            ageTo = txtToAge.Text.Trim() + " " + ddlAgeTo.SelectedItem.Text;
        }

        if (ageFrom.Contains("YRS") == true)
            ageFrom = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(ageFrom.Replace("YRS", "").Trim()) * 365)));
        else if (ageFrom.Contains("DAYS(S)") == true)
            ageFrom = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(ageFrom.Replace("DAYS(S)", "").Trim()) * 1)));
        else if (ageFrom.Contains("MONTH(S)") == true)
            ageFrom = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(ageFrom.Replace("MONTH(S)", "").Trim()) * 30)));

        if (ageTo.Contains("YRS") == true)
            ageTo = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(ageTo.Replace("YRS", "").Trim()) * 365)));
        else if (ageTo.Contains("DAYS(S)") == true)
            ageTo = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(ageTo.Replace("DAYS(S)", "").Trim()) * 1)));
        else if (ageTo.Contains("MONTH(S)") == true)
            ageTo = Util.GetString(Math.Round(Util.GetDecimal(Util.GetDecimal(ageTo.Replace("MONTH(S)", "").Trim()) * 30)));


        StringBuilder sb = new StringBuilder();
        sb.Append(" Select TYPE,DeptName,InvestigationName,(Quantity)Quantity from ( ");
        sb.Append("SELECT (CASE WHEN plo.Type=1 THEN 'OPD' WHEN plo.Type=2 THEN 'IPD' ELSE 'Emergency' END) TYPE,obm.Name DeptName,IF(obm.Name='MISCELLANEOUS',CONCAT(im.Name,' (',plo.Remarks,')'),im.Name) InvestigationName,COUNT(im.Name)Quantity ");
        sb.Append("FROM patient_labinvestigation_opd plo INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_Id ");
        sb.Append("INNER JOIN investigation_observationtype ino ON ino.Investigation_ID=im.Investigation_Id ");
        sb.Append("INNER JOIN observationtype_master obm ON obm.ObservationType_ID=ino.ObservationType_Id ");
        sb.Append("INNER JOIN patient_master pm ON plo.PatientID=pm.PatientID ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID  AND cr.RoleID='" + Session["RoleID"] + "'");
        sb.Append("WHERE plo.Date>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "' AND plo.Date<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "' AND plo.IsSampleCollected<>'R' AND plo.CentreID IN (" + Centre + ") ");
        if (ddlDepartment.SelectedIndex > 0)
            sb.Append("AND obm.ObservationType_ID='" + ddlDepartment.SelectedValue + "' ");
        if (txtName.Text != "")
            sb.Append("AND im.Name LIKE '%" + txtName.Text + "%' ");
        if (rblGender.SelectedItem.Value != "3")
            sb.Append("AND pm.Gender='" + rblGender.SelectedItem.Text + "' ");
        if (rdbitem.SelectedValue != "0")
            sb.Append("AND plo.Type=" + rdbitem.SelectedValue + " ");
        if (ageFrom != "")
        {
            sb.Append(" and (Case when pm.Age like '%YRS%' then trim(Replace(pm.Age,'YRS',''))*365 ");
            sb.Append(" when pm.Age like '%DAYS(S)%' then trim(Replace(pm.Age,'DAYS(S)',''))*1  ");
            sb.Append(" when pm.Age like '%MONTH(S)%' then trim(Replace(pm.Age,'MON',''))*30 end) >= '" + ageFrom + "'");
        }

        if (ageTo != "")
        {
            sb.Append(" and (Case when pm.Age like '%YRS%' then trim(Replace(pm.Age,'YRS',''))*365 ");
            sb.Append(" when pm.Age like '%DAYS(S)%' then trim(Replace(pm.Age,'DAYS(S)',''))*1  ");
            sb.Append(" when pm.Age like '%MONTH(S)%' then trim(Replace(pm.Age,'MONTH(S)',''))*30 end) <= '" + ageTo + "'");
        }

        sb.Append(" GROUP BY IF(obm.Name='MISCELLANEOUS',CONCAT(InvestigationName,' (',plo.Remarks,')'),im.Investigation_Id),plo.TYPE)t WHERE t.TYPE<>'' ORDER BY DeptName ASC,TYPE ASC,InvestigationName ASC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["Type"].ToString() == "") { 

            }
            string reportHeader = "";

            if (rblGender.SelectedItem.Value != "3")
                reportHeader += " of " + rblGender.SelectedItem.Text;

            if (ageFrom != "" && ageTo != "")
                reportHeader += " Between Age " + txtFromAge.Text.Trim() + " " + ddlAgeFrom.SelectedItem.Text + " To " + txtToAge.Text.Trim() + " " + ddlAgeFrom.SelectedItem.Text;

            Session["ReportName"] = "Lab Count Report " + reportHeader;
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../../Design/Common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }
}