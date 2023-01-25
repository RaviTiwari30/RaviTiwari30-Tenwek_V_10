using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_MRD_GhanaMorbidity : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            EntryDate1.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            EntryDate2.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        EntryDate1.Attributes.Add("readonly", "readonly");
        EntryDate2.Attributes.Add("readonly", "readonly");
    }
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = new DataSet();

            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT Chapter_desc,who_full_desc,");
            sb.Append(" SUM(MNeonatal)MNeonatal,SUM(MPostNeonatal)MPostNeonatal,SUM(M1to4)M1to4,SUM(M5to9)M5to9,SUM(M10to14)M10to14,SUM(M15to17)M15to17,SUM(M18to19)M18to19,SUM(M20to34)M20to34,SUM(M35to49)M35to49,SUM(M50to59)M50to59,SUM(M60to69)M60to69,SUM(Mgrt70)Mgrt70,  ");
            sb.Append(" SUM(FNeonatal)FNeonatal,SUM(FPostNeonatal)FPostNeonatal,SUM(F1to4)F1to4,SUM(F5to9)F5to9,SUM(F10to14)F10to14,SUM(F15to17)F15to17,SUM(F18to19)F18to19,SUM(F20to34)F20to34,SUM(F35to49)F35to49,SUM(F50to59)F50to59,(F60to69)F60to69,SUM(Fgrt70)Fgrt70,  ");
            sb.Append(" SUM(MNeonatal+MPostNeonatal+M1to4+M5to9+M10to14+M15to17+M18to19+M20to34+M35to49+M50to59+M60to69+Mgrt70+FNeonatal+FPostNeonatal+F1to4+F5to9+F10to14+F15to17+F18to19+F20to34+F35to49+F50to59+F60to69+Fgrt70)Total  ");
            sb.Append(" FROM(  ");
            sb.Append("         SELECT icdm.Chapter_desc,icdm.who_full_desc ,icdm.id, ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND  ");
            sb.Append("         TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='DAY(S)' THEN 1 ELSE 0 END MNeonatal 	,  ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='MONTH(S)' THEN 1 ELSE 0 END MPostNeonatal 	,  ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<=4 THEN 1 ELSE 0 END M1to4 	,  ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=5 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<9 THEN 1 ELSE 0 END M5to9 	, ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=10 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<14 THEN 1 ELSE 0 END M10to14 	, ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=15 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<17 THEN 1 ELSE 0 END M15to17 	, ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=18 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<19 THEN 1 ELSE 0 END M18to19 	, ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=20 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<34 THEN 1 ELSE 0 END M20to34 	, ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=35 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<49 THEN 1 ELSE 0 END M35to49 	, ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=50 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<59 THEN 1 ELSE 0 END M50to59 	, ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=60 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<69 THEN 1 ELSE 0 END M60to69 	, ");
            sb.Append("         CASE WHEN pm.Gender='Male' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=70 THEN 1 ELSE 0 END Mgrt70 	, ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='DAY(S)' THEN 1 ELSE 0 END FNeonatal 	,  ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='MONTH(S)' THEN 1 ELSE 0 END FPostNeonatal 	,  ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<=4 THEN 1 ELSE 0 END F1to4 	, ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=5 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<9 THEN 1 ELSE 0 END F5to9 	, ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=10 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<14 THEN 1 ELSE 0 END F10to14 	, ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=15 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<17 THEN 1 ELSE 0 END F15to17 	, ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=18 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<19 THEN 1 ELSE 0 END F18to19 	, ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=20 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<34 THEN 1 ELSE 0 END F20to34 	, ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=35 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<49 THEN 1 ELSE 0 END F35to49 	, ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=50 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<59 THEN 1 ELSE 0 END F50to59 	, ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=60 AND  SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)<69 THEN 1 ELSE 0 END F60to69 	, ");
            sb.Append("         CASE WHEN pm.Gender='Female' AND TRIM(SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',2))='YRS' AND SPLIT_STR(Get_Death(pm.DateEnrolled,ich.Dateofdischarge,pm.Age),' ',1)>=70 THEN 1 ELSE 0 END Fgrt70  ");
            sb.Append("         FROM icd_10cm_patient icd  INNER JOIN ipd_case_history ich ON ich.TransactionID = icd.TransactionID   ");
            sb.Append("  	INNER JOIN icd_10_new icdm ON icdm.ID=icd.icd_ID 	");
            sb.Append(" 	INNER JOIN patient_medical_history pmh ON pmh.TransactionID = icd.TransactionID   ");
            sb.Append(" 	INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID ");
            sb.Append("	    WHERE DATE(DateOfDischarge) >= '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "' AND  DATE(DateOfDischarge) <= '" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "'   AND pmh.DischargeType = 'Death'  ");
            sb.Append("	)t  	GROUP BY t.ID  ");
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString()).Copy();
            if (rdlSelect.SelectedItem.Value == "1" && dt.Rows.Count>0)
            {
                dt.TableName = "dtMain";
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "Period From " + Util.GetDateTime(EntryDate1.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(EntryDate2.Text).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);
                DataColumn dc1 = new DataColumn();
                dc1 = new DataColumn();
                dc1.ColumnName = "Year";
                dc1.DefaultValue = Util.GetDateTime(EntryDate1.Text).ToString("yyyy");
                dt.Columns.Add(dc1);
                DataColumn dc2 = new DataColumn();
                dc2 = new DataColumn();
                dc2.ColumnName = "Month";
                dc2.DefaultValue = Util.GetDateTime(EntryDate1.Text).ToString("MMM");
                dt.Columns.Add(dc2);
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = Convert.ToString(Session["LoginName"]);
                dt.Columns.Add(dc);

                ds.Tables.Add(dt.Copy());
              //    ds.WriteXml("E:\\GhanaMorbidity.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "GhanaMorbidity";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('Commonreport.aspx');", true);
                }
            else if (rdlSelect.SelectedItem.Value == "2" && dt.Rows.Count > 0)
            {
                Session["ReportName"] = "Morbidity Report";
                Session["dtExport2Excel"] = dt;
                Session["Period"] = "From : " + Util.GetDateTime(EntryDate1.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(EntryDate2.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                }
            }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}