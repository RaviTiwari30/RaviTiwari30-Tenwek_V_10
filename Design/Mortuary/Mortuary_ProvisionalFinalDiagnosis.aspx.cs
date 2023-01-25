using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Mortuary_Mortuary_ProvisionalFinalDiagnosis : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {            
            string PID=StockReports.ExecuteScalar("Select Patient_ID from mortuary_corpse_master where Corpse_ID='" + Request.QueryString["CorpseID"].ToString() + "'");
            if (PID != "")
            {
                BindFinalDiagnosis();
                BindProvisionalDiagnosis();
                Bindalergies();
            }
        }
    }
    
    protected void BindFinalDiagnosis()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT REPLACE(icdp.Transaction_ID,'ISHHI','')'IPD No.',Transaction_ID,Group_Code ,Group_Desc , ");
        sb.Append(" ICD10_3_Code , ICD10_3_Code_Desc ,ICD10_Code , WHO_Full_Desc ,icdp.icd_id,icdp.ID  ");
        sb.Append(" FROM cpoe_10cm_patient icdp INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID where icdp.IsActive=1 ");
        sb.Append(" AND icd.Isactive=1 AND icdp.patient_ID='" + lblPatientID.Text + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            GridView1.DataSource = dt;
            GridView1.DataBind();

        }
        else
        {
            GridView1.DataSource = null;
            GridView1.DataBind();

        }

    }
    protected void Bindalergies()
    {
        DataTable dtdetail = StockReports.GetDataTable("SELECT Allergies FROM cpoe_hpexam WHERE PatientID='" + lblPatientID.Text + "'");
        if (dtdetail.Rows.Count > 0)
        {
            grdAllergies.DataSource = dtdetail;
            grdAllergies.DataBind();

        }
        else
        {
            grdAllergies.DataSource = null;
            grdAllergies.DataBind();

        }
        
    }
    protected void BindProvisionalDiagnosis()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ProvisionalDiagnosis,DATE_Format(CreatedDate,'%d-%b-%Y %h %i:%p')Date FROM cpoe_PatientDiagnosis WHERE Patient_id = '" + lblPatientID.Text + "' ");
        if (dt.Rows.Count > 0)
        {
            grdProvisional.DataSource = dt;
            grdProvisional.DataBind();

        }
        else
        {
            grdProvisional.DataSource = null;
            grdProvisional.DataBind();

        }
    }

}