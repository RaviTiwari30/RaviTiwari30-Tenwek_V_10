using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_Reports_InfectionControlAnalysis : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            dtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            InvBind();
        }
    }
    void InvBind()
    {
        DataTable dt = StockReports.GetDataTable("SELECT `Investigation_ID`, `NAME` FROM `investigation_master` WHERE `Investigation_ID` IN (353,358,418,431,540,550,340,549) ORDER BY NAME");
        chkinvestigation.DataSource = dt;
        chkinvestigation.DataValueField = "Investigation_ID";
        chkinvestigation.DataTextField = "NAME";
        chkinvestigation.DataBind();
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string InfectionControlSearch(List<string> searchdata)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT pm.`PatientID` UHID,CONCAT(pm.`Title`,' ',pm.`PName`)PatientName,pm.`Age`,pm.`Gender` Sex,im.`NAME`  ");
        sb.Append(" , ploo.`VALUE`,im.`Investigation_Id`,CONCAT(DATE_FORMAT( plo.`DATE`,'%d-%b-%Y'),' ',TIME_FORMAT(plo.`TIME`,'%I:%i %p'))PrescribedDate,plo.`ResultEnteredName` ResultEnteredBy,DATE_FORMAT(plo.`ResultEnteredDate`,'%d-%b-%Y %I-%i %p')ResultEnteredDate ");
        sb.Append(" FROM patient_labinvestigation_opd plo  ");
        sb.Append(" INNER JOIN patient_labobservation_opd ploo ON ploo.`Test_ID`=plo.`Test_ID` ");
        sb.Append(" INNER JOIN investigation_master im  ON  plo.`Investigation_ID`=im.`Investigation_Id` ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=plo.`PatientID` ");

        sb.Append(" WHERE plo.`DATE`>='" + Util.GetDateTime(searchdata[0]).ToString("yyyy-MM-dd") + "' AND plo.`DATE`<='" + Util.GetDateTime(searchdata[1]).ToString("yyyy-MM-dd") + "'  ");
        sb.Append(" AND( ");
        if (searchdata[4].ToString() == "0")
        {

        sb.Append(" ploo.`VALUE` LIKE '%Reactive%'  ");
        sb.Append("  OR ploo.`VALUE` LIKE '%Non Reactive%' ");
        sb.Append(" OR ploo.`VALUE` LIKE '%negative%' ");
        sb.Append("  OR ploo.`VALUE` LIKE '%NEGATIVE%' ");
        sb.Append("  OR ploo.`VALUE` LIKE '%moderate%'  ");
        sb.Append(" OR ploo.`VALUE` LIKE '%nil%' ");
        sb.Append(" OR ploo.`VALUE` LIKE '%absent%' ");
        sb.Append("  OR ploo.`VALUE` LIKE '%positive%'  ");
        sb.Append("  OR ploo.`VALUE` LIKE '%++%' ");
        sb.Append("  OR ploo.`VALUE` LIKE '%not seen%' ");
        sb.Append("  OR ploo.`VALUE` LIKE '%present%' ");
        }
        if (searchdata[4].ToString() == "1")
        {

            sb.Append(" ploo.`VALUE` LIKE '%Reactive%'  "); 
            sb.Append("  OR ploo.`VALUE` LIKE '%positive%'  ");
            sb.Append("  OR ploo.`VALUE` LIKE '%++%' "); 
            sb.Append("  OR ploo.`VALUE` LIKE '%present%' ");
        }
        if (searchdata[4].ToString() == "2")
        {

            sb.Append("   ploo.`VALUE` LIKE '%Non Reactive%' ");
            sb.Append(" OR ploo.`VALUE` LIKE '%negative%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%NEGATIVE%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%moderate%'  ");
            sb.Append(" OR ploo.`VALUE` LIKE '%nil%' ");
            sb.Append(" OR ploo.`VALUE` LIKE '%absent%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%not seen%' ");
        }

        sb.Append("  ) ");
        if (!string.IsNullOrEmpty(searchdata[2].ToString().Trim(',')))
        {

            sb.Append("AND plo.`Investigation_ID` IN("+searchdata[2].ToString().Trim(',')+")");
            
        }

        if (!string.IsNullOrEmpty(searchdata[3].ToString().Trim(',')))
        {

            sb.Append("AND pm.`PatientID`= '" + searchdata[3].ToString()+"' ");

        }
         

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(List<string> searchdata)
    {


        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT pm.`PatientID` UHID,CONCAT(pm.`Title`,' ',pm.`PName`)PatientName,pm.`Age`,pm.`Gender` Sex,im.`NAME`  ");
        sb.Append(" , ploo.`VALUE` Result,CONCAT(DATE_FORMAT( plo.`DATE`,'%d-%b-%Y'),' ',TIME_FORMAT(plo.`TIME`,'%I:%i %p'))PrescribedDate,plo.`ResultEnteredName` ResultEnteredBy,DATE_FORMAT(plo.`ResultEnteredDate`,'%d-%b-%Y %I-%i %p')ResultEnteredDate ");
        sb.Append(" FROM patient_labinvestigation_opd plo  ");
        sb.Append(" INNER JOIN patient_labobservation_opd ploo ON ploo.`Test_ID`=plo.`Test_ID` ");
        sb.Append(" INNER JOIN investigation_master im  ON  plo.`Investigation_ID`=im.`Investigation_Id` ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=plo.`PatientID` ");

        sb.Append(" WHERE plo.`DATE`>='" + Util.GetDateTime(searchdata[0]).ToString("yyyy-MM-dd") + "' AND plo.`DATE`<='" + Util.GetDateTime(searchdata[1]).ToString("yyyy-MM-dd") + "'  ");
        sb.Append(" AND( ");

        if (searchdata[4].ToString() == "0")
        {

            sb.Append(" ploo.`VALUE` LIKE '%Reactive%'  ");
            sb.Append("  OR ploo.`VALUE` LIKE '%Non Reactive%' ");
            sb.Append(" OR ploo.`VALUE` LIKE '%negative%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%NEGATIVE%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%moderate%'  ");
            sb.Append(" OR ploo.`VALUE` LIKE '%nil%' ");
            sb.Append(" OR ploo.`VALUE` LIKE '%absent%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%positive%'  ");
            sb.Append("  OR ploo.`VALUE` LIKE '%++%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%not seen%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%present%' ");
        }
        if (searchdata[4].ToString() == "1")
        {

            sb.Append(" ploo.`VALUE` LIKE '%Reactive%'  ");
            sb.Append("  OR ploo.`VALUE` LIKE '%positive%'  ");
            sb.Append("  OR ploo.`VALUE` LIKE '%++%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%present%' ");
        }
        if (searchdata[4].ToString() == "2")
        {

            sb.Append("   ploo.`VALUE` LIKE '%Non Reactive%' ");
            sb.Append(" OR ploo.`VALUE` LIKE '%negative%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%NEGATIVE%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%moderate%'  ");
            sb.Append(" OR ploo.`VALUE` LIKE '%nil%' ");
            sb.Append(" OR ploo.`VALUE` LIKE '%absent%' ");
            sb.Append("  OR ploo.`VALUE` LIKE '%not seen%' ");
        }



        sb.Append("  ) ");
        if (!string.IsNullOrEmpty(searchdata[2].ToString().Trim(',')))
        {

            sb.Append("AND plo.`Investigation_ID` IN(" + searchdata[2].ToString().Trim(',') + ")");

        }

        if (!string.IsNullOrEmpty(searchdata[3].ToString().Trim(',')))
        {

            sb.Append("AND pm.`PatientID`= '" + searchdata[3].ToString() + "' ");

        }

        sb.Append("Order By plo.`DATE` desc ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
         
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Infection Control Analysis Report";

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "No Record Found" });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" }); }


    }
}