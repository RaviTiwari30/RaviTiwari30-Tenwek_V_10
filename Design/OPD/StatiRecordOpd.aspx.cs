using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_StatiRecordOpd : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            GetMyWardList();
            GetMyMonthList();
            GetMyYearList();
            BindCentre();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");

    }

    private void BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        ddlCenter.DataSource = dt;
        ddlCenter.DataTextField = "CentreName";
        ddlCenter.DataValueField = "CentreID";
        ddlCenter.DataBind();
        ddlCenter.Items.Insert(0, new ListItem("All", "0"));

    }




    public void GetMyWardList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,NAME FROM type_master WHERE TypeID =5  ORDER BY NAME ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlward.DataSource = dt;
        ddlward.DataValueField = "ID";
        ddlward.DataTextField = "NAME";
        ddlward.DataBind();
        ddlward.Items.Insert(0, new ListItem("All", "0"));
    }



    public void GetMyMonthList()
    {
        DateTime month = Convert.ToDateTime("01/01/2022");
        for (int i = 0; i < 12; i++)
        {
            DateTime NextMont = month.AddMonths(i);
            ListItem list = new ListItem();
            list.Text = NextMont.ToString("MMM");
            list.Value = NextMont.Month.ToString();
            ddlMonth.Items.Add(list);
        }

        // ddlMonth.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
        ddlMonth.Items.Insert(0, new ListItem("All", "0"));
    }


    public void GetMyYearList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT(YEAR(cpoe.EntDate))YearId FROM cpoe_10cm_patient cpoe ORDER BY (YEAR(cpoe.EntDate)) ASC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlYear.DataSource = dt;
        ddlYear.DataValueField = "YearId";
        ddlYear.DataTextField = "YearId";
        ddlYear.DataBind();
        ddlYear.Items.FindByValue(DateTime.Now.Year.ToString()).Selected = true;

    }

    protected void btnReport_Click(object sender, EventArgs e)
    {

        if (ddlReportType.SelectedValue == "0")
        {
            lblMsg.Text = "Select Report Type";
            return;
        }

        if (ddlReportType.SelectedValue == "1")
        {

            decimal FromAgeinDay = (Util.GetDecimal(txtFromAge.Text) * 365);
            decimal ToAgeInDay = (Util.GetDecimal(txtToAge.Text) * 365);

            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT t.Name,SUM(t.Male)Male,SUM(t.Female)Female,( SUM(t.Male)+SUM(t.Female)) Total FROM (  ");
            sb.Append("  SELECT  tm.`NAME`,sm.`CategoryID`,COUNT(pm.`Gender`) Male,0 Female,tm.`ID` DepartmentID,cm.CentreName FROM patient_medical_history pmh  ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
            sb.Append("   AND IF(pm.Age LIKE '%YRS%',(SUBSTRING_INDEX(pm.Age,' ',1)*365),  ");
            sb.Append("  IF(pm.Age LIKE '%MONTH%',(SUBSTRING_INDEX(pm.Age,' ',1)*30),  ");
            sb.Append("  IF(pm.Age LIKE '%DAY%',(SUBSTRING_INDEX(pm.Age,' ',1)),0)) ) BETWEEN  " + FromAgeinDay + " AND " + ToAgeInDay + "  ");

            sb.Append("  INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID`  ");
            sb.Append("  INNER JOIN type_master tm ON tm.`ID`=dm.`DocDepartmentID` AND tm.`TypeID`=5  ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON ltd.`TransactionID`=pmh.`TransactionID`  ");
            sb.Append("  INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=ltd.`SubcategoryID` AND sm.`CategoryID`=1  ");
            sb.Append(" INNER JOIN center_master cm on cm.CentreID=pmh.CentreID ");
            sb.Append("  WHERE pmh.`TYPE`='OPD' AND pm.`Gender`='Male'  ");
            sb.Append("   and pmh.`DateOfVisit`>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and pmh.`DateOfVisit`<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ");
            if (ddlCenter.SelectedItem.Value != "0")
            {
                sb.Append("and  pmh.CentreID='" + ddlCenter.SelectedItem.Value + "'");
            }
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND tm.`ID`='" + ddlward.SelectedValue.ToString() + "'");

            }


            sb.Append("  GROUP BY tm.`ID`    ");
            sb.Append("  UNION ALL   ");
            sb.Append("  SELECT  tm.`NAME`,sm.`CategoryID`,0 Male,COUNT(pm.`Gender`) Female,tm.`ID` DepartmentID,cm.CentreName  FROM patient_medical_history pmh  ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
            sb.Append("   AND IF(pm.Age LIKE '%YRS%',(SUBSTRING_INDEX(pm.Age,' ',1)*365),  ");
            sb.Append("  IF(pm.Age LIKE '%MONTH%',(SUBSTRING_INDEX(pm.Age,' ',1)*30),  ");
            sb.Append("  IF(pm.Age LIKE '%DAY%',(SUBSTRING_INDEX(pm.Age,' ',1)),0)) ) BETWEEN  " + FromAgeinDay + " AND " + ToAgeInDay + "  ");
            sb.Append("  INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID`  ");
            sb.Append("  INNER JOIN type_master tm ON tm.`ID`=dm.`DocDepartmentID` AND tm.`TypeID`=5  ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON ltd.`TransactionID`=pmh.`TransactionID`  ");
            sb.Append("  INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=ltd.`SubcategoryID` AND sm.`CategoryID`=1  ");
            sb.Append(" INNER JOIN center_master cm on cm.CentreID=pmh.CentreID ");
            sb.Append("  WHERE pmh.`TYPE`='OPD' AND pm.`Gender`='Female'  ");
            sb.Append("  and pmh.`DateOfVisit`>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and pmh.`DateOfVisit`<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ");

            if (ddlCenter.SelectedItem.Value != "0")
            {
                sb.Append("and  pmh.CentreID='" + ddlCenter.SelectedItem.Value + "'");
            }
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND tm.`ID`='" + ddlward.SelectedValue.ToString() + "'");

            }
            sb.Append("  GROUP BY tm.`ID`    ");
            sb.Append("  )t GROUP BY t.DepartmentID  ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {

                double Male = Convert.ToDouble(dt.Compute("SUM(Male)", string.Empty));
                double Female = Convert.ToDouble(dt.Compute("SUM(Female)", string.Empty));
                double Total = Convert.ToDouble(dt.Compute("SUM(Total)", string.Empty));
                dt.Rows.Add("Total", Male, Female, Total);

                Session["dtExport2Excel"] = dt;
                Session["Period"] = "From Age " + txtFromAge.Text + " To Age " + txtToAge.Text; ;
                Session["ReportName"] = "OPD Census By Ward & Out Patient";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }

        }
        else if (ddlReportType.SelectedValue == "2")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT t.NAME NAME, ");
            if (Util.GetInt(ddlMonth.SelectedValue) == 0)
            {
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=1,1,0))>0,Cnt,0)) AS  'Jan" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=2,1,0))>0,Cnt,0)) AS 'Feb" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=3,1,0))>0,Cnt,0)) AS 'Mar" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=4,1,0))>0,Cnt,0)) AS 'Apr" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=5,1,0))>0,Cnt,0)) AS 'May" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=6,1,0))>0,Cnt,0)) AS 'Jun" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=7,1,0))>0,Cnt,0)) AS 'Jul" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=8,1,0))>0,Cnt,0)) AS 'Aug" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=9,1,0))>0,Cnt,0)) AS 'Sep" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=10,1,0))>0,Cnt,0)) AS 'Oct" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=11,1,0))>0,Cnt,0)) AS 'Nov" + ddlYear.SelectedValue + "', ");
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=12,1,0))>0,Cnt,0)) AS 'Dec" + ddlYear.SelectedValue + "',  ");
            }
            else
            {
                sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=" + Util.GetInt(ddlMonth.SelectedValue) + ",1,0))>0,Cnt,0)) AS  '" + ddlMonth.SelectedItem.Text + "" + ddlYear.SelectedValue + "', ");
            }
            sb.Append(" SUM(Cnt) Total  FROM ( ");

            sb.Append("   SELECT  tm.`NAME`,COUNT(pm.`Gender`) Cnt,tm.`ID` DepartmentID , ");
            sb.Append(" DATE(pmh.`DateOfVisit`) DateOfAdmit,cm.CentreName FROM patient_medical_history pmh ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append(" INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID` ");
            sb.Append(" INNER JOIN type_master tm ON tm.`ID`=dm.`DocDepartmentID` AND tm.`TypeID`=5 ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.`TransactionID`=pmh.`TransactionID` ");
            sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=ltd.`SubcategoryID` AND sm.`CategoryID`=1 ");
            sb.Append(" INNER JOIN center_master cm on cm.CentreID=pmh.CentreID ");
            sb.Append(" WHERE pmh.`TYPE`='OPD'  ");
            sb.Append("  AND  YEAR(pmh.`DateOfVisit`)=" + Util.GetInt(ddlYear.SelectedValue) + " ");

            if (ddlCenter.SelectedItem.Value != "0")
            {
                sb.Append("and  pmh.CentreID='" + ddlCenter.SelectedItem.Value + "'");
            }

            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND tm.`ID`='" + ddlward.SelectedValue.ToString() + "'");

            }
            if (Util.GetInt(ddlMonth.SelectedValue) != 0)
            {
                sb.Append("  AND  MONTH(pmh.`DateOfVisit`)=" + Util.GetInt(ddlMonth.SelectedValue) + "  ");

            }

            sb.Append("  GROUP BY MONTH(pmh.`DateOfVisit`), tm.ID     ");

            sb.Append(" )t GROUP BY t.DepartmentID  ORDER BY NAME ASC  ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {



                if (Util.GetInt(ddlMonth.SelectedValue) == 0)
                {
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=1,1,0))>0,Cnt,0)) AS 'Jan" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=2,1,0))>0,Cnt,0)) AS 'Feb" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=3,1,0))>0,Cnt,0)) AS 'Mar" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=4,1,0))>0,Cnt,0)) AS 'Apr" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=5,1,0))>0,Cnt,0)) AS 'May" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=6,1,0))>0,Cnt,0)) AS 'Jun" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=7,1,0))>0,Cnt,0)) AS 'Jul" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=8,1,0))>0,Cnt,0)) AS 'Aug" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=9,1,0))>0,Cnt,0)) AS 'Sep" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=10,1,0))>0,Cnt,0)) AS 'Oct" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=11,1,0))>0,Cnt,0)) AS 'Nov" + ddlYear.SelectedValue + "', ");
                    sb.Append(" SUM(IF((IF(MONTH(t.DateOfAdmit)=12,1,0))>0,Cnt,0)) AS 'Dec" + ddlYear.SelectedValue + "',  ");

                    double Jan = Convert.ToDouble(dt.Compute("SUM(Jan" + ddlYear.SelectedValue + ")", string.Empty));
                    double Feb = Convert.ToDouble(dt.Compute("SUM(Feb" + ddlYear.SelectedValue + ")", string.Empty));
                    double Mar = Convert.ToDouble(dt.Compute("SUM(Mar" + ddlYear.SelectedValue + ")", string.Empty));

                    double Apr = Convert.ToDouble(dt.Compute("SUM(Apr" + ddlYear.SelectedValue + ")", string.Empty));
                    double May = Convert.ToDouble(dt.Compute("SUM(May" + ddlYear.SelectedValue + ")", string.Empty));
                    double Jun = Convert.ToDouble(dt.Compute("SUM(Jun" + ddlYear.SelectedValue + ")", string.Empty));

                    double Jul = Convert.ToDouble(dt.Compute("SUM(Jul" + ddlYear.SelectedValue + ")", string.Empty));
                    double Aug = Convert.ToDouble(dt.Compute("SUM(Aug" + ddlYear.SelectedValue + ")", string.Empty));
                    double Sep = Convert.ToDouble(dt.Compute("SUM(Sep" + ddlYear.SelectedValue + ")", string.Empty));

                    double Oct = Convert.ToDouble(dt.Compute("SUM(Oct" + ddlYear.SelectedValue + ")", string.Empty));
                    double Nov = Convert.ToDouble(dt.Compute("SUM(Nov" + ddlYear.SelectedValue + ")", string.Empty));
                    double Dec = Convert.ToDouble(dt.Compute("SUM(Dec" + ddlYear.SelectedValue + ")", string.Empty));


                    double Total = Convert.ToDouble(dt.Compute("SUM(Total)", string.Empty));

                    dt.Rows.Add("Total", Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec, Total);



                }
                else
                {
                    double FTotal = Convert.ToDouble(dt.Compute("SUM(" + ddlMonth.SelectedItem.Text + "" + ddlYear.SelectedValue + ")", string.Empty));
                    double Total = Convert.ToDouble(dt.Compute("SUM(Total)", string.Empty));

                    dt.Rows.Add("Total", FTotal, Total);

                }


                Session["dtExport2Excel"] = dt;
                Session["Period"] = "Month " + ddlMonth.SelectedItem.Text + " Of Year " + ddlYear.SelectedValue;
                Session["ReportName"] = "OPD Census By Clinic Report (YEARLY)";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }


        }
        else if (ddlReportType.SelectedValue == "4")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.`PatientID` UHID ,CONCAT(pm.`Title`,' ', pm.`PName`)PatientName,pm.`Age`,   ");
            sb.Append(" pm.`Gender` Sex, (SELECT GROUP_CONCAT(ic.`ICD10_Code`) FROM cpoe_10cm_patient cp     ");
            sb.Append(" INNER JOIN `icd_10_new` ic ON cp.`ICD_Code`=ic.`ICD10_Code`   ");
            sb.Append(" WHERE cp.`TransactionID`=lt.`TransactionID`) IcdCode,(SELECT GROUP_CONCAT(ic.`WHO_Full_Desc`) FROM cpoe_10cm_patient cp     ");
            sb.Append(" INNER JOIN `icd_10_new` ic ON cp.`ICD_Code`=ic.`ICD10_Code`   ");
            sb.Append(" WHERE cp.`TransactionID`=lt.`TransactionID`) Diagnosis,(SELECT GROUP_CONCAT(pltd.`ItemName`) FROM f_ledgertransaction plt   ");
            sb.Append(" INNER JOIN  f_ledgertnxdetail pltd ON pltd.`TransactionID`=plt.`TransactionID` AND pltd.`ConfigID`=25  ");
            sb.Append(" WHERE plt.`EncounterNo`=lt.`EncounterNo`)Procesdure,  ");
            sb.Append("  CONCAT(DATE_FORMAT(pmh.`DateOfVisit`,'%d-%b-%Y'),' ',TIME_FORMAT(pmh.`TIME`,'%r'))DateRegistration,  ");
            sb.Append(" CONCAT(dm.`Title`,' ',dm.`NAME`)DoctorName,  ");
            sb.Append(" (SELECT SUM(plt.`NetAmount`) FROM f_ledgertransaction plt WHERE plt.`EncounterNo`=lt.`EncounterNo` )BillAmount, pnl.`Company_Name` Insurance,cm.CentreName  ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=lt.`TransactionID`  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
            sb.Append(" INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID`  ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`PanelID`=pmh.`PanelID`  ");
            sb.Append(" INNER JOIN type_master tm ON tm.`ID`=dm.`DocDepartmentID` AND tm.`TypeID`=5  ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.`TransactionID`=pmh.`TransactionID`    ");

            sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=ltd.`SubcategoryID` AND sm.`CategoryID`=1  ");
            sb.Append(" INNER JOIN center_master cm on cm.CentreID=pmh.CentreID ");
            sb.Append(" WHERE pmh.`TYPE`='OPD' ");
            sb.Append("  and pmh.`DateOfVisit`>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and pmh.`DateOfVisit`<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ");

            if (ddlCenter.SelectedItem.Value != "0")
            {
                sb.Append("and  pmh.CentreID='" + ddlCenter.SelectedItem.Value + "'");
            }
            sb.Append(" GROUP BY  lt.`EncounterNo` ");
            sb.Append(" ORDER BY pm.`PatientID` DESC   ");


            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {

                Session["dtExport2Excel"] = dt;

                Session["ReportName"] = "OPD Clinic Wise Report";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }



        }
        else if (ddlReportType.SelectedValue == "5")
        {

            StringBuilder sb = new StringBuilder();

            sb.Append("   SELECT pm.`PatientID` UhID,icd.`ICD_Code` ICD10,ic.`WHO_Full_Desc` Diagnosis,    ");
            sb.Append("     DATE_FORMAT( pmh.`DateOfVisit`,'%d-%b-%Y')DOA,TIME_FORMAT( pmh.`TIME`,'%I:%i %p') 'TIME DOA',pm.`Age`,pm.`Gender` Sex, pm.`Taluka` 'Village/Town', pm.`State` County,   ");
            sb.Append("   CONCAT(dm.`Title`,' ',dm.`NAME`) 'Doctor Name',tm.`NAME` 'Clinic Name'   ");
            sb.Append("   FROM patient_medical_history pmh   ");
            sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON ltd.`TransactionID`=pmh.`TransactionID`   ");
            sb.Append("   INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=ltd.`SubcategoryID` AND sm.`CategoryID`=1   ");
            sb.Append("   INNER JOIN  doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID`   ");
            sb.Append("   INNER JOIN type_master tm ON tm.`ID`=dm.`DocDepartmentID` AND tm.`TypeID`=5   ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`   ");
            sb.Append("   LEFT JOIN  `cpoe_10cm_patient` icd ON icd.`TransactionID`=pmh.`TransactionID`   ");
            sb.Append("   LEFT JOIN  `icd_10_new` ic ON ic.`ICD10_Code`=icd.`ICD_Code`   ");
            sb.Append("   WHERE pmh.`TYPE`='OPD'    ");
            sb.Append("   AND  DATE(pmh.`DateOfVisit`) >='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND pmh.`DateOfVisit`<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   ");

            if (!string.IsNullOrEmpty(txtUhid.Text))
            {
                sb.Append("   AND pmh.`PatientID`='" + txtUhid.Text + "'  ");

            }
           
            if (ddlCenter.SelectedItem.Value != "0")
            {
                sb.Append("and  pmh.CentreID='" + ddlCenter.SelectedItem.Value + "'");
            }
            if (!string.IsNullOrEmpty(ddlward.SelectedValue.ToString()) && ddlward.SelectedValue.ToString() != "0")
            {
                sb.Append(" AND tm.`ID`='" + ddlward.SelectedValue.ToString() + "'");

            }

            if (!string.IsNullOrEmpty(txtDiagnosis.Text))
            {
                 sb.Append(" AND ic.`WHO_Full_Desc` like '%" + txtDiagnosis.Text + "%'");

            }
            sb.Append(" ORDER BY  DATE(pmh.`DateOfVisit`) DESC ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {

                Session["dtExport2Excel"] = dt;

                Session["ReportName"] = "OPD Morbidity Coading Search";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }


        }



    }
}