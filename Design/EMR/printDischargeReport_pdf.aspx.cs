using HiQPdf;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Net;
using System.Drawing.Drawing2D;
using System.Web;
using System.Web.UI;

public partial class Design_Lab_printLabReport_pdf : System.Web.UI.Page
{
    #region
    DataTable dtObs = new DataTable();
    DataTable dtLabReport = new DataTable();
    DataTable dtLabReportSubContent = new DataTable();
    DataTable dtOrganismStyle = new DataTable();
    DataRow drcurrent;
    PdfLayoutInfo html1LayoutInfo;

    DataSet ds = new DataSet();
    DataTable dt;
    // DataTable DS;
    // DataTable InvestigationText;
    // DataTable InvestigationNimeric;
    // DataTable MyOtImageNew;
    // DataTable AddConsultant;
    // DataTable MedRecord;
    // DataTable DocFooter;
    // DataTable dtMedRecord;
    // DataTable dtDoc_footer;
    // DataTable ClientImage;

    // int count = 0;
    // Report Department Type
    // string RadiolgyRoleID = "104";
    // string LabRoleID = "11";

    //Report Variables
    public string LabType = "";
    public string TestID = "";
    string OrderBy = "";
    string PHead = "51";
    public string LeftMargin = "";
    public string PrintSNR = "";
    public string isOnlinePrint = "";
    public string isEmail = "";
    //Page Property
    int MarginLeft = 30;
    //int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;
    bool showItdose = false;

    //Header Property
    int HeaderHeight = 200;
    int XHeader = 30;
    int YHeader = 100;
    int HeaderBrowserWidth = 800;
    // bool showColon = true;
    // float labelWidth = 0f;
    // float labelHeight = 0f;
    // float LastY = 0f;
    bool TopLine = false;
    bool BottomLine = true;
    string strSpecimen = "";

    bool HeaderImage = false;
    string HeaderImg = "Images/Clinique.png";
    int XHeaderImg = 20;
    int YHeaderImg = 2;

    //Footer Property
    // int FooterHeight = 190;
    int FooterHeight = 100;
    int XFooter = 20;
    // int YFooter = 20;
    // int FooterBrowserWidth = 800;
    bool footerTopLine = false;

    //Report Setup
    // bool printSeparateDepartment = false;
    // bool printSeparateReportType = true;
    bool printEndOfReportAtFooter = true;
    // bool ApprovedBySignAtFooter = true;
    // int XSignature = 300;
    // int YSignature = 10;
    // float SignatureWidth = 300;
    float SignatureHeight = 200;
    // bool Barcode = true;
    // int XBarcode = 30;
    // int YBarcode = 10;
    bool PrintOTImages = false;
    int MandatoryHeaderCount = 0;
    PdfDocument document = new PdfDocument();
    #endregion
    protected void Page_Load(object sender, EventArgs e)
    {
        //document.SerialNumber="woqrk5Km-pI6roLCj-sLv67PLi-8+Lz4vLi-8/Hs8vrs-8PLz9w==";
        document.SerialNumber = "g8vq0tPn‐5c/q4fHi‐8fq7rbOj‐sqO3o7uy‐t6Owsq2y‐sa26urq6";


        DataTable dt = StockReports.GetDataTable("Select * from Center_Master where CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'");

        this.HeaderImg = Util.GetString(dt.Rows[0]["ReportHeaderURL"]);

        string TransactionID = Request.QueryString["TID"].ToString();
        string Status = Request.QueryString["Status"].ToString();
        string ReportType = Request.QueryString["ReportType"].ToString();

        var isEmergencyPatient = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM emergency_patient_details emr WHERE emr.TransactionId='" + TransactionID + "'"));



        string dtd = "";
        if (Request.QueryString["dtd"] != null)
        {
            dtd = Request.QueryString["dtd"].ToString();
        }


        StringBuilder sbOtsurgery = new StringBuilder();
        sbOtsurgery.Append(" SELECT it.Diagnosis,(SELECT NAME FROM doctor_master WHERE DoctorID=sc.DoctorID)DoctorName,  ");
        sbOtsurgery.Append("  (SELECT NAME FROM f_surgery_master WHERE Surgery_ID=sc.Surgery_ID) AS Surgery,DATE_FORMAT(pmh.EntryDate,'%d-%b-%Y') DATE ");
        sbOtsurgery.Append("  FROM patient_medical_history pmh  ");
        sbOtsurgery.Append("  INNER JOIN ot_surgerydetail it ON pmh.PatientID=it.PatientID   ");
        sbOtsurgery.Append("  LEFT JOIN ot_surgery_schedule sc ON pmh.PatientID=sc.PatientID   AND  pmh.TransactionID=sc.TransactionID ");
        sbOtsurgery.Append("  WHERE pmh.TransactionID='' ");
        DataTable otSurgery = StockReports.GetDataTable(sbOtsurgery.ToString());


        getData(TransactionID, Status, ReportType, isEmergencyPatient, dtd);

        TestID = Util.GetString(Request.QueryString["TestID"]);
        LabType = Util.GetString(Request.QueryString["LabType"]);
        OrderBy = Util.GetString(Request.QueryString["OrderBy"]);
        PHead = Util.GetString(Request.QueryString["PHead"]);
        //PHead = Util.GetString(Request.QueryString["LabreportType"]);
        if (Request.QueryString["OnlineHeader"] != null)
            HeaderImage = true;
        //TestID = "'" + TestID + "'";
        TestID = "" + TestID + "";
        //TestID = TestID.Replace(",", "','");

        int ShowCloseTbTag = 0;

        DataTable dtTemp = StockReports.GetDataTable("select * from dischargeReportMaster where  id IN (1,2,3,14,15,16,17,19)  order by printOrder");
        StringBuilder sbCss = new StringBuilder();

        sbCss.Append("<style>");
        sbCss.Append(".tbData{width:100%;}");
        sbCss.Append(".tbData th{font-weight:bold;padding-bottom:5px;}");
        sbCss.Append(".tbData th{font-weight:bold;}");
        // sbCss.Append("table.tbOrganism { border-collapse: collapse;}");
        // sbCss.Append("table.tbOrganism, td.tbOrganism, th.tbOrganism{  border: 1px solid black;}");

        foreach (DataRow dr in dtTemp.Rows)
        {
            sbCss.Append("." + dr["Name"].ToString() + "{font-family:" + dr["FName"].ToString() +
            ",geneva,sans-serif;font-size:" + dr["Fsize"].ToString() + "px;text-align:" + dr["Alignment"].ToString() +
            ";" + (dr["Bold"].ToString() == "Y" ? "font-weight:bold;" : "") +
            "" + (dr["Under"].ToString() == "Y" ? "text-decoration:underline;" : "") +
            " " + (dr["Italic"].ToString() == "Y" ? "font-style:italic;" : "") + "width:" + dr["width"].ToString() + "px;Height:" + dr["Height"].ToString() + ";}");
        }
        sbCss.Append(".tbMed{border:1px solid rgb(0, 0, 0); width:100%;border-spacing:0px;font-family:Arial,geneva,sans-serif}");
        sbCss.Append(".tcolMed{text-align:center;font-size:16px;border-left:solid 1px;font-family:Arial,geneva,sans-serif}");
        sbCss.Append("</style>");

        // Exculding global style sheet

        DataView view = new DataView(dtTemp);
        view.RowFilter = "Print = 1";
        dtLabReport = view.ToTable().Copy();

        bool _FirstRow = true;// _LastRow = false;


        StringBuilder sb = new StringBuilder();
        if (ds.Tables["MyOtImage"] != null && ds.Tables["MyOtImage"].Rows.Count > 0)
        {

            int isNotExist = 0;
            string NotExistHeader = string.Empty;
            DataTable dtMan = ds.Tables["MandatoryHeader"];
            for (int z = 0; z < dtMan.Rows.Count; z++)
            {

                DataRow[] dr = ds.Tables["DS"].Select("DS_FIELD='" + dtMan.Rows[z]["HeaderName"].ToString() + "'");

                if (dr.Length == 0)
                {
                    isNotExist = 1;
                    if (NotExistHeader == string.Empty)
                        NotExistHeader = dtMan.Rows[z]["HeaderName"].ToString();
                    else
                        //NotExistHeader = NotExistHeader + " ," + dtMan.Rows[z]["HeaderName"].ToString();
                        NotExistHeader = NotExistHeader + "</br>" + dtMan.Rows[z]["HeaderName"].ToString();
                }
                else
                {
                    MandatoryHeaderCount++;
                }
            }

            if (isNotExist == 1)
            {
                sb.Append("<table class='tbData'>");
                sb.Append("    <tr>");
                sb.Append("   <th style='Color:red;' class='" + dtLabReport.Rows[0]["Name"].ToString() + "' >" + "Please Add These Mandatory Header" + "</th>");
                //sb.Append("   <th>" + NotExistHeader + "</th>");
                sb.Append("   </tr>");
                //sb.Append("    <tr>");

                sb.Append("<tr valign='top'>");
                sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "' style='width: 50%;color:red;'><B>" + NotExistHeader + "  </B></td></br>");
                sb.Append("</tr>");

                //sb.Append("   <th>" + NotExistHeader + "</th>");
                //sb.Append("   </tr>");
                sb.Append("</table>");

            }
            else
            {
                if (ds.Tables["MyOtImage"].Rows[0]["Header"].ToString() != null && ds.Tables["MyOtImage"].Rows[0]["Header"].ToString() != "")
                {
                    sb.Append("<table class='tbData'>");
                    sb.Append("    <tr>");
                    sb.Append("   <th class='" + dtLabReport.Rows[0]["Name"].ToString() + "' >" + ds.Tables["MyOtImage"].Rows[0]["Header"].ToString() + "</th>");
                    sb.Append("   </tr>");
                    sb.Append("</table>");
                }
            }
        }
        else
        {
            sb.Append("<table class='tbData'>");
            sb.Append("    <tr>");
            sb.Append("   <th class='" + dtLabReport.Rows[0]["Name"].ToString() + "' >" + "Please Prepared The Header" + "</th>");
            sb.Append("   </tr>");
            sb.Append("</table>");
        }
        if (ds.Tables["AddConsultant"] != null && ds.Tables["AddConsultant"].Rows.Count > 0)
        {
            // Add new on 24-04-2017 - To show Admission Unit separate
            //sb.Append("<table class='tbData'>");
            //sb.Append("    <tr>");
            //sb.Append("   <th class='" + dtLabReport.Rows[1]["Name"].ToString() + "'>" + "ADMISSION UNIT" + "</th>");
            //sb.Append("   </tr>");
            //sb.Append("</table>");

            if (MandatoryHeaderCount == ds.Tables["MandatoryHeader"].Rows.Count)
            {
                sb.Append("<table  style='width:800px;' >");

                //sb.Append("<table  style='width:800px;' >");
                //sb.Append("<tr valign='top'>");
                //sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["AddConsultant"].Rows[0]["DocName"].ToString() + "  " + ds.Tables["AddConsultant"].Rows[0]["DocDegree"].ToString() + " (" + ds.Tables["AddConsultant"].Rows[0]["DocSpec"].ToString() + ")" + "</td>");
                //sb.Append("</tr>");
                //sb.Append("</table>");
                //

                // Modify on 24-04-2017 - To show Admission Unit separate
                if (ds.Tables["AddConsultant"].Rows.Count > 1)
                {
                    sb.Append("<table class='tbData'>");
                    sb.Append("    <tr>");
                    sb.Append("   <th class='" + dtLabReport.Rows[1]["Name"].ToString() + "'>" + "Admitting Doctor " + "</th>");
                    sb.Append("   </tr>");
                    sb.Append("</table>");
                    sb.Append("<table  style='width:800px;' >");

                    // Modify on 24-04-2017 - To show Admission Unit separate
                    // for (int i = 0; i < ds.Tables["AddConsultant"].Rows.Count; i++)
                    for (int i = 1; i < ds.Tables["AddConsultant"].Rows.Count; i++)
                    {
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["AddConsultant"].Rows[i]["DocName"].ToString() + "  " + ds.Tables["AddConsultant"].Rows[i]["DocDegree"].ToString() + " (" + ds.Tables["AddConsultant"].Rows[i]["DocSpec"].ToString() + ")" + "</td>");
                        sb.Append("</tr>");
                    }
                    sb.Append("</table>");
                }
            }
            //
        }


        for (int k = 0; k < ds.Tables["DS"].Rows.Count; k++)
        {

            sb.Append("<table class='tbData'>");
            DataRow dr = ds.Tables["DS"].Rows[k];
            if (_FirstRow)
            {
                drcurrent = ds.Tables["DS"].Rows[ds.Tables["DS"].Rows.IndexOf(dr)];
                if (MandatoryHeaderCount == ds.Tables["MandatoryHeader"].Rows.Count)
                {

                    sb.Append("    <tr>");
                    sb.Append("   <th class='" + dtLabReport.Rows[1]["Name"].ToString() + "'>" + dr["DS_FIELD"].ToString().ToUpper() + "</th>");
                    sb.Append("   </tr>");

                    if (dr["DS_SUMMARY"].ToString() != "")
                    {
                        if (dr["DS_SUMMARY"].ToString() == "OTSummary")
                        {
                            string PID = StockReports.ExecuteScalar("select Distinct PatientID from patient_medical_history WHERE TransactionID='" + TransactionID.Trim() + "'");
                            string otdetails = addOTDetails(null, PID, null, null);
                            sb.Append("<br/><br/>");
                            sb.Append(otdetails.ToString());
                        }
                    }
                    

                    //if (dr["DS_FIELD"].ToString() != dtLabReport.Rows[5]["Name"].ToString() && dr["DS_FIELD"].ToString() != dtLabReport.Rows[6]["Name"].ToString() && dr["SNO"].ToString() != "1" && dr["DS_FIELD"].ToString() != "Surgery Notes" && dr["DS_FIELD"].ToString() != "Done By" && dr["DS_FIELD"].ToString() != "Anesthetist" && dr["DS_FIELD"].ToString() != "Name Of The Surgery" && dr["DS_FIELD"].ToString() == "Anesthesia")
                    if (dr["DS_SUMMARY"].ToString() != "")
                    {
                       
                        if (dr["DS_SUMMARY"].ToString() == "ShowInvestigationBeforeAdvice")
                        {
                            //------------------------Investigation Numeric Report------------------------------------------

                            if (ds.Tables["InvestigationNimeric"] != null && ds.Tables["InvestigationNimeric"].Rows.Count > 0)
                            {



                                //sb.Append("<tr valign='top'>");
                                //sb.Append("<td>&nbsp;<br/><br/></td>");
                                //sb.Append("</tr>");
                                ShowCloseTbTag = 1;
                                // sb.Append("</table>");
                                // sb.Append(sbCss.ToString());
                                // html1LayoutInfo = null;
                                //// AddContent(sb.ToString(), drcurrent);

                                // sb = new StringBuilder();

                                // sb.Append("<table  style='width:800px;' >");
                                sb.Append("<tr valign='top'>");
                                //sb.Append("<td colspan='4' class='" + dtLabReport.Rows[4]["Name"].ToString() + "'>Investigation Report<br/></td>");
                                // sb.Append("   <th class='" + dtLabReport.Rows[4]["Name"].ToString() + "'>" + "Investigation Report" + "</th>");
                                sb.Append("<td colspan='4' style=font-size:16px;text-align:center;font-family:verdana,geneva,sans-serif;'><u><strong>Investigation Report<strong/><u/><br/></td>");
                                sb.Append("</tr>");
                                sb.Append("<tr valign='top'>");
                                sb.Append("<td colspan='4'></td>");
                                sb.Append("</tr>");
                                sb.Append("</table>");
                                sb.Append("<table  style='width:auto;border-bottom:1px solid rgb(0, 0, 0);border-spacing:0px;font-family:verdana,geneva,sans-serif;' >");


                                for (int i = 0; i < ds.Tables["InvestigationNimeric"].Rows.Count; i++)
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td colspan='4'> <br/ > <strong>" + ds.Tables["InvestigationNimeric"].Rows[i]["date"].ToString() + "</strong> <br/><br/>" + ds.Tables["InvestigationNimeric"].Rows[i]["InvestigationProcedure"].ToString() + " <br/> </td>");
                                    sb.Append("</tr>");
                                }
                                //  sb.Append("</table>");
                            }
                            //--------------------- Investigation Text report----------------------------------------------------

                            if (ds.Tables["InvestigationText"] != null && ds.Tables["InvestigationText"].Rows.Count > 0)
                            {
                                //sb.Append("<tr valign='top'>");
                                //sb.Append("<td>&nbsp;<br/><br/></td>");
                                //sb.Append("</tr>");
                                // sb.Append("<table  style='width:800px;font-family:verdana,geneva,sans-serif;' >");
                                sb.Append("<tr valign='top' style='width:800px;font-family:verdana,geneva,sans-serif;'>");
                                sb.Append("<td>&nbsp;</td>");
                                sb.Append("</tr>");
                                sb.Append("<tr valign='top'>");
                                sb.Append("<td colspan='4' style=font-size:14px;text-align:center;'><u><strong>Investigation Report<strong/><u/><br/></td>");
                                sb.Append("</tr>");
                                sb.Append("<tr valign='top'>");
                                sb.Append("<td colspan='4' style='border-bottom:solid 1px;padding-top:-10px'></td>");
                                sb.Append("</tr>");
                                sb.Append("<tr valign='top'>");
                                sb.Append("<td  style='width:30px;text-align:left;font-size:12px;'><strong>S.No<strong/></td>");
                                sb.Append("<td  style='width:70px;text-align:left;font-size:12px;'><strong>Date<strong/></td>");
                                sb.Append("<td style='width:300px;text-align:left;font-size:12px;'><strong>Investigation<strong/></td>");
                                sb.Append("<td style='width:400px;text-align:left;font-size:12px;'><strong>Findings<strong/></td>");
                                sb.Append("</tr>");
                                sb.Append("<tr valign='top'>");
                                sb.Append("<td colspan='4' style='border-bottom:solid 1px;padding-top:-10px'></td>");
                                sb.Append("</tr>");
                                for (int i = 0; i < ds.Tables["InvestigationText"].Rows.Count; i++)
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td style='width:30px;text-align:left;font-size:10px;'>" + Util.GetInt(i + 1).ToString() + ".</td>");
                                    sb.Append("<td style='width:70px;text-align:left;font-size:10px;'>" + ds.Tables["InvestigationText"].Rows[i]["Date"].ToString() + "</td>");
                                    sb.Append("<td style='width:300px;text-align:left;font-size:10px;'>" + ds.Tables["InvestigationText"].Rows[i]["Investigation"].ToString() + "</td>");
                                    sb.Append("<td style='width:400px;text-align:left;font-size:10px;'>" + ds.Tables["InvestigationText"].Rows[i]["Remarks"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                                // sb.Append("</table>");
                            }
                            // sb.Append("</td>");
                            // sb.Append("</tr>");

                        }
                        else
                        {
                            sb.Append("<tr valign='top'>");
                            sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + dr["DS_SUMMARY"].ToString() + "</td>");
                            sb.Append("</tr>");
                        }

                       

                    }
                    string countfollowupVisit = Util.GetString(StockReports.ExecuteScalar("SELECT COUNT(*) FROM cpoe_assessment cpa WHERE cpa.TransactionID='"+TransactionID+"' "));
                    if (dr["DS_FIELD"].ToString() == "Clinic Follow-up")
                    {
                        if (ds.Tables["FollowUpVisit"] != null && ds.Tables["FollowUpVisit"].Rows.Count > 0)
                        {
                            sb.Append("<table class='tbMed'>");
                            sb.Append("<tr valign='top'>");
                            sb.Append("<td class='tcolMed' style='width:30px;border-bottom:solid 1px;font-weight:bold;'>Sr.No</td>");
                            sb.Append("<td class='tcolMed' style='width:300px;border-bottom:solid 1px;font-weight:bold;'>Doctor Name</td>");
                            sb.Append("<td class='tcolMed' style='width:100px;border-bottom:solid 1px;font-weight:bold;'>Followup Date</td>");
                            for (int i = 0; i < ds.Tables["FollowUpVisit"].Rows.Count; i++)
                            {
                                sb.Append("<tr valign='top'>");
                                sb.Append("<td class='tcolMed' style='width:30px;border-bottom:solid 1px'>" + Util.GetInt(i + 1).ToString() + ".</td>");
                                sb.Append("<td class='tcolMed' style='width:300px;border-bottom:solid 1px'>" + ds.Tables["FollowUpVisit"].Rows[i]["DoctorName"].ToString() + "</td>");
                                sb.Append("<td class='tcolMed' style='width:100px;border-bottom:solid 1px'>" + ds.Tables["FollowUpVisit"].Rows[i]["FollowupDate"].ToString() + "</td>");
                                sb.Append("</tr>");

                            }
                            sb.Append("</table><br>");
                      
                        }
                    }
                    ///-------------------------------------- OT Detail --------------------------------------///
                    if (dr["DS_FIELD"].ToString() == dtLabReport.Rows[7]["Name"].ToString())
                    {
                        PrintOTImages = true;
                    }
                    if (ds.Tables["OTSurgery"] != null && ds.Tables["OTSurgery"].Rows.Count > 0)
                    {
                        for (int i = 0; i < ds.Tables["OTSurgery"].Rows.Count; i++)
                        {
                            ///-------------------------------------- OT Surgery Name --------------------------------------///
                            if (dr["DS_FIELD"].ToString() == "NAME OF THE SURGERY")
                            {
                                if (ds.Tables["OTSurgery"].Rows[i]["SurgeryName"].ToString() != "")
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["OTSurgery"].Rows[i]["SurgeryName"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                            }
                            ///-------------------------------------- END OT Surgery Name --------------------------------------///
                            ///-------------------------------------- OT SurgeOn Detail --------------------------------------///
                            if (dr["DS_FIELD"].ToString() == "Done By")
                            {
                                if (ds.Tables["OTSurgery"].Rows[i]["SurgeonName1"].ToString() != "")
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["OTSurgery"].Rows[i]["SurgeonName1"].ToString() + "  " + ds.Tables["OTSurgery"].Rows[i]["sur1Degree"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                                if (ds.Tables["OTSurgery"].Rows[i]["SurgeonName2"].ToString() != "")
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["OTSurgery"].Rows[i]["SurgeonName2"].ToString() + "  " + ds.Tables["OTSurgery"].Rows[i]["sur2Degree"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                            }
                            ///-------------------------------------- END OT SurgeOn Detail --------------------------------------///
                            ///-------------------------------------- OT Anesthetist Detail --------------------------------------///
                            if (dr["DS_FIELD"].ToString() == "Anesthetist")
                            {
                                if (ds.Tables["OTSurgery"].Rows[i]["Anesthetist"].ToString() != "")
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["OTSurgery"].Rows[i]["Anesthetist"].ToString() + "  " + ds.Tables["OTSurgery"].Rows[i]["AnaDegree"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                                if (ds.Tables["OTSurgery"].Rows[i]["AsstAnesthetist"].ToString() != "")
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["OTSurgery"].Rows[i]["AsstAnesthetist"].ToString() + "  " + ds.Tables["OTSurgery"].Rows[i]["AssAnaDegree"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                            }
                            ///-------------------------------------- END OT Anesthetist Detail --------------------------------------///
                            ///-------------------------------------- OT AnesthesiaType Detail --------------------------------------///
                            if (dr["DS_FIELD"].ToString() == "Anesthesia")
                            {
                                if (ds.Tables["OTSurgery"].Rows[i]["AnesthesiaType"].ToString() != "")
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["OTSurgery"].Rows[i]["AnesthesiaType"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                            }
                            ///-------------------------------------- END OT AnesthesiaType Detail --------------------------------------///
                            ///-------------------------------------- OT Procedure Detail --------------------------------------///
                            if (dr["DS_FIELD"].ToString() == "SURGERY NOTES")
                            {
                                if (ds.Tables["OTSurgery"].Rows[i]["SurgeryDate"].ToString() != "")
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + "<b>Procedure" + " " + "(" + Util.GetDateTime(ds.Tables["OTSurgery"].Rows[i]["SurgeryDate"]).ToString("dd-MMM-yyyy") + ")" + ":</b>" + " " + ds.Tables["OTSurgery"].Rows[i]["Procedures"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                            }
                            ///-------------------------------------- END OT AnesthesiaType Detail --------------------------------------///
                            //////-------------------------------------- OT Notes Finding --------------------------------------///
                            if (dr["DS_FIELD"].ToString() == "Findings")
                            {
                                if (ds.Tables["OTSurgery"].Rows[i]["Findings"].ToString() != "")
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["OTSurgery"].Rows[i]["Findings"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                            }
                            if (dr["DS_FIELD"].ToString() == "Pre Operatve Diagnosis")
                            {
                                if (ds.Tables["OTSurgery"].Rows[i]["PreOperatveDignose"].ToString() != "")
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["OTSurgery"].Rows[i]["PreOperatveDignose"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                            }
                            if (dr["DS_FIELD"].ToString() == "Post Operatve Diagnosis")
                            {
                                if (ds.Tables["OTSurgery"].Rows[i]["PostOprDignosis"].ToString() != "")
                                {
                                    sb.Append("<tr valign='top'>");
                                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + ds.Tables["OTSurgery"].Rows[i]["PostOprDignosis"].ToString() + "</td>");
                                    sb.Append("</tr>");
                                }
                            }
                            ///-------------------------------------- END OT Notes Finding --------------------------------------///
                        }
                    }
                }

                ///-------------------------------------- ICD Code Details --------------------------------------///
                if (dr["DS_FIELD"].ToString() == dtLabReport.Rows[6]["Name"].ToString())
               {
                    if (ds.Tables["FinalDiagnosis"] != null && ds.Tables["FinalDiagnosis"].Rows.Count > 0)
                    {
                        sb.Append("<table class='tbMed'>");
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td class='tcolMed' style='width:30px;border-bottom:solid 1px;font-weight:bold;'>S.No</td>");
                        sb.Append("<td class='tcolMed' style='width:300px;border-bottom:solid 1px;font-weight:bold;'>Group Desease</td>");
                        sb.Append("<td class='tcolMed' style='width:100px;border-bottom:solid 1px;font-weight:bold;'>Group Code</td>");
                        sb.Append("<td class='tcolMed' style='width:300px;border-bottom:solid 1px;font-weight:bold;'>ICD 10 Name</td>");
                        sb.Append("<td class='tcolMed' style='width:80px;border-bottom:solid 1px;font-weight:bold;'>ICD 10 Code</td>");
                        sb.Append("</tr>");
                        for (int i = 0; i < ds.Tables["FinalDiagnosis"].Rows.Count; i++)
                        {
                            sb.Append("<tr valign='top'>");
                            sb.Append("<td class='tcolMed' style='width:30px;border-bottom:solid 1px'>" + Util.GetInt(i + 1).ToString() + ".</td>");
                            sb.Append("<td class='tcolMed' style='width:300px;border-bottom:solid 1px'>" + ds.Tables["FinalDiagnosis"].Rows[i]["Group_Desc"].ToString() + "</td>");
                            sb.Append("<td class='tcolMed' style='width:100px;border-bottom:solid 1px'>" + ds.Tables["FinalDiagnosis"].Rows[i]["Group_Code"].ToString() + "</td>");
                            sb.Append("<td class='tcolMed' style='width:300px;border-bottom:solid 1px'>" + ds.Tables["FinalDiagnosis"].Rows[i]["ICD10_3_Code_Desc"].ToString() + "</td>");
                            sb.Append("<td class='tcolMed' style='width:80px;border-bottom:solid 1px'>" + ds.Tables["FinalDiagnosis"].Rows[i]["ICD10_Code"].ToString() + "</td>");
                            sb.Append("</tr>");

                        }
                        sb.Append("</table><br>");
                    }
                }
                ///-------------------------------------- Medicine Details --------------------------------------///
                if (dr["DS_FIELD"].ToString() == dtLabReport.Rows[5]["Name"].ToString())
               {
                    if (ds.Tables["MedRecord"] != null && ds.Tables["MedRecord"].Rows.Count > 0)
                    {
                        sb.Append("</table>");
                        sb.Append("<table class='tbMed'>");
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td class='tcolMed' style='width:30px;border-bottom:solid 1px;font-weight:bold;font-size:12px'>S.No.</td>");
                        sb.Append("<td class='tcolMed' style='width:400px;border-bottom:solid 1px;font-weight:bold;font-size:12px'>Medicine/Generic Name</td>");
                        sb.Append("<td class='tcolMed' style='width:80px;border-bottom:solid 1px;font-weight:bold;font-size:12px'>Dose</td>");
                        sb.Append("<td class='tcolMed' style='width:150px;border-bottom:solid 1px;font-weight:bold;font-size:12px'>How Often</td>");
                        sb.Append("<td class='tcolMed' style='width:200px;border-bottom:solid 1px;font-weight:bold;font-size:12px'>Route </td>");
                        sb.Append("<td class='tcolMed' style='width:210px;border-bottom:solid 1px;font-weight:bold;font-size:12px'>Duration</td>");
                        sb.Append("<td class='tcolMed' style='width:300px;border-bottom:solid 1px;font-weight:bold;font-size:12px'>Meal</td>");
                        sb.Append("<td class='tcolMed' style='width:200px;border-bottom:solid 1px;font-weight:bold;font-size:12px'>Remarks</td>");
                        sb.Append("<td class='tcolMed' style='display:none;width:150px;border-bottom:solid 1px;font-weight:bold;font-size:14px'>Generics</td>");
                        sb.Append("</tr>");
                        int i = 0;
                        for (i = 0; i < ds.Tables["MedRecord"].Rows.Count; i++)
                        {
                            sb.Append("<tr valign='top'>");
                            if (i > 0)
                            {
                                if (ds.Tables["MedRecord"].Rows[i]["message"].ToString() != ds.Tables["MedRecord"].Rows[i - 1]["message"].ToString())
                                {
                                    sb.Append("<td class='tcolMed' colspan='8' style='font-weight:bold; text-align:center;border-bottom:solid 1px;font-size:12px'>" + ds.Tables["MedRecord"].Rows[i]["message"].ToString() + "</td>");
                                }
                            }
                            else
                                sb.Append("<td class='tcolMed' colspan='8' style='font-weight:bold; text-align:center;border-bottom:solid 1px;font-size:12px'>" + ds.Tables["MedRecord"].Rows[i]["message"].ToString() + "</td>");
                            sb.Append("</tr>");
                            sb.Append("<tr valign='top'>");
                            sb.Append("<td class='tcolMed' style='width:30px;border-bottom:solid 1px;font-size:10px'>" + Util.GetInt(i + 1).ToString() + ".</td>");  
                            sb.Append("<td class='tcolMed' style='width:300px;border-bottom:solid 1px;font-size:13px'>" + "<b>" + ds.Tables["MedRecord"].Rows[i]["Medicinename"].ToString() + "</b><br> [ " + ds.Tables["MedRecord"].Rows[i]["Generic"].ToString() + " ] </td>");
                            sb.Append("<td class='tcolMed' style='width:400px;border-bottom:solid 1px;font-size:10px'>" + ds.Tables["MedRecord"].Rows[i]["Dose"].ToString() + "</td>");
                            sb.Append("<td class='tcolMed' style='width:150px;border-bottom:solid 1px;font-size:10px'>" + ds.Tables["MedRecord"].Rows[i]["Time"].ToString() + "</td>");
                            sb.Append("<td class='tcolMed' style='width:200px;border-bottom:solid 1px;font-size:10px'>" + ds.Tables["MedRecord"].Rows[i]["Route"].ToString() + "</td>");
                            sb.Append("<td class='tcolMed' style='width:210px;border-bottom:solid 1px;font-size:10px'>" + ds.Tables["MedRecord"].Rows[i]["Days"].ToString() + "</td>");
                            sb.Append("<td class='tcolMed' style='width:300px;border-bottom:solid 1px;font-size:10px'>" + ds.Tables["MedRecord"].Rows[i]["Meal"].ToString() + "</td>");
                            sb.Append("<td class='tcolMed' style='width:200px;border-bottom:solid 1px;font-size:10px'>" + ds.Tables["MedRecord"].Rows[i]["Remarks"].ToString() + "</td>");
                            sb.Append("<td class='tcolMed' style='display:none;width:250px;border-bottom:solid 1px;font-size:13px'>" + ds.Tables["MedRecord"].Rows[i]["Generic"].ToString() + "</td>");
                            sb.Append("</tr>");

                        }
                        sb.Append("</table><br>");
                    }
                }

            }
        }



        if (otSurgery.Rows.Count > 0)
        {

            sb.Append("<table class='tbData'>");
            sb.Append("    <tr>");

            sb.Append("   <th class='" + dtLabReport.Rows[0]["Name"].ToString() + "'>" + "OT SURGERY DETAILS " + "</th>");

            sb.Append("   </tr>");
            sb.Append("</table>");

            sb.Append("<table  style='width:800px;' >");
            sb.Append("    <tr>");

            sb.Append("   <th class='" + dtLabReport.Rows[1]["Name"].ToString() + "'>" + "Surgery " + "</th>");

            sb.Append("   <th class='" + dtLabReport.Rows[1]["Name"].ToString() + "'>" + "Date " + "</th>");

            sb.Append("   <th class='" + dtLabReport.Rows[1]["Name"].ToString() + "'>" + " Surgeon " + "</th>");

            sb.Append("   </tr>");
            for (int i = 0; i < otSurgery.Rows.Count; i++)
            {
                sb.Append("<tr valign='top'>");
                sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + otSurgery.Rows[i]["Surgery"].ToString() + "</td>");
                sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + otSurgery.Rows[i]["Date"].ToString() + "</td>");
                sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'>" + otSurgery.Rows[i]["DoctorName"].ToString() + "</td>");
                sb.Append("</tr>");
            }
            sb.Append("</table><br>");

        }






        // To print doctor sign at report end
        sb.Append("<table  style='width:800px;margin-top:50px' >");

        sb.Append("<tr valign='top'>");
        sb.Append("<td  style='width:20%;font-weight:bold;font-size:13px;font-family:verdana,geneva,sans-serif;text-align:left;'>Received By</td><td  style='width:48%;'></td><td  style='width:30%;font-weight:bold;font-size:13px;font-family:verdana,geneva,sans-serif;text-align:right;'>Consultant/Rmo's signature</br>Tenwek Hospital</td><td style='width:2%;'></td>");
        sb.Append("</tr>");
        sb.Append("<tr valign='top'>");
        sb.Append("<td colspan='3' style='width:98%;text-align:center;font-size:12px;'>---------------------------------------------------------------------------------------<strong>End of Report</strong>-----------------------------------------------------------------------------------------</td><td style='width:2%;'></td>");
        sb.Append("</tr>");
        sb.Append("<tr valign='top'>");
        sb.Append("<td colspan='3' style='width:98%;font-style: italic;font-size:13px;font-family:verdana,geneva,sans-serif;text-align:left;'>*report is invalid without sign and seal of concern authority.</td><td style='width:2%;'></td>");
        sb.Append("</tr>");
        //sb.Append("<tr valign='top'>");
        //sb.Append("<td colspan='3'  style='width:98%;font-weight:bold;font-size:13px;font-family:verdana,geneva,sans-serif;text-align:center;'>In case of any emergency, please call on 01204880000, 9310195177, For Appointment-01204880077,</td><td style='width:2%;'></td>");
        //sb.Append("</tr>");
        //sb.Append("<tr valign='top'>");
        //sb.Append("<td colspan='3'  style='width:98%;font-weight:bold;font-size:13px;font-family:verdana,geneva,sans-serif;text-align:center;'>For Pharmacy services-01204880088</td><td style='width:2%;'></td>");
        //sb.Append("</tr>");
        sb.Append("</table>");
        //if (ds.Tables["MyOtImage"].Rows.Count > 0)
        //{
        //    if (ds.Tables["MyOtImage"].Rows[0]["AppDoctorID"].ToString() != "")
        //    {
        //        if (isSign(ds.Tables["MyOtImage"].Rows[0]["AppDoctorID"].ToString()) == true)
        //        {
        //            //sb.Append("<table  style='width:800px;' >");
        //            //sb.Append("<tr valign='top'>");
        //            //sb.Append("<td><img src='" + Server.MapPath("~/Design/Doctor/DoctorSignature/") + Util.GetString(ds.Tables["MyOtImage"].Rows[0]["AppDoctorID"].ToString()) + ".jpg" + "'></td>");
        //            //sb.Append("</tr>");
        //            //sb.Append("<tr valign='top'>");
        //            //sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "'><strong><u>Summary Verified and Digitally Approved By</u> - " + ds.Tables["MyOtImage"].Rows[0]["DocName"].ToString() + " (" + ds.Tables["MyOtImage"].Rows[0]["Specialization"].ToString() + ")</strong></td>");
        //            //sb.Append("</tr>");
        //            //sb.Append("</table>");
        //        }
        //    }
        //}


        //page.Footer.Layout(getPDFImage(450, 20, "Design/Doctor/DoctorSignature/" + Util.GetString(ds.Tables["MyOtImage"].Rows[0]["AppDoctorID"].ToString()) + ".jpg"));

        //----------------------Doctor Footer templates---------------------------------
        if (_FirstRow)
        {
            if (ds.Tables["DocFooter"] != null && ds.Tables["DocFooter"].Rows.Count > 0)
            {
                if (ds.Tables["DocFooter"].Rows[0]["Templetes"].ToString() != "")
                {
                    sb.Append("<tr valign='top'>");
                    sb.Append("<td style='font-family:verdana,geneva,sans-serif;font-size:10px;'>" + "Test Method: " + ds.Tables["DocFooter"].Rows[0]["Templetes"].ToString() + "</td>");
                    sb.Append("</tr>");
                }
            }
        }




        if (PrintOTImages == true)
        {
            if (ds.Tables["MyOtImageNew"] != null && ds.Tables["MyOtImageNew"].Rows.Count > 0)
            {
                sb.Append("<table  style='width:800px;' >");
                sb.Append("<tr valign='top'>");
                sb.Append("<th style=font-size:16px;><strong>Surgery Images :<strong/></th>");
                sb.Append("</tr>");
                sb.Append("<tr valign='top'>");
                sb.Append("<td style='border-bottom:solid 1px;padding-top:-10px'></td>");
                sb.Append("</tr>");
                for (int i = 0; i < ds.Tables["MyOtImageNew"].Rows.Count; i++)
                {

                    string ImaPath = "Design/EMR/OtImages/" + TransactionID.Trim() + "/" + ds.Tables["MyOtImageNew"].Rows[i]["OtImage"].ToString();
                    string path = HttpContext.Current.Server.MapPath(@"~/" + ImaPath);
                    sb.Append("</table>");
                    sb.Append("<table  style='width:800px;' >");
                    sb.Append("<tr valign='top'>");
                    sb.Append("<th> <img style='text-align:center;width:" + ds.Tables["MyOtImageNew"].Rows[i]["PhotoWidth"].ToString() + ";height:" + ds.Tables["MyOtImageNew"].Rows[i]["PhotoHeight"].ToString() + ";' src=" + path + "></img></th>");
                    sb.Append("</tr>");
                    sb.Append("<tr valign='top'>");
                    sb.Append("<td class='" + dtLabReport.Rows[2]["Name"].ToString() + "' style='text-align:center'>" + "<b>Image Narration :</b>" + ds.Tables["MyOtImageNew"].Rows[i]["OtImageNarration"].ToString() + "</td>");
                    sb.Append("</tr>");
                    sb.Append("</table>");
                }
            }
        }
        if (ShowCloseTbTag == 0)
            sb.Append("</table>");
        sb.Append(sbCss.ToString());
        html1LayoutInfo = null;
        AddContent(sb.ToString(), drcurrent);
        
        foreach (DataRow drAtt in ds.Tables["MyOtImageNew"].Rows)
        {
            string _pdf = "";
            if (drAtt["OtImage"].ToString().ToLower().EndsWith(".pdf") && drAtt["DocumentType"].ToString() == "DischargeDocument")
            {
                _pdf = string.Concat(Resources.Resource.DocumentDriveIPAddress, Resources.Resource.DocumentDriveName, "\\", Resources.Resource.DocumentFolderName, "\\DischargeDocument\\"  +drAtt["OtImage"].ToString());
                if (File.Exists(_pdf))
                {
                    try
                    {
                        printEndOfReportAtFooter = false;
                        PdfDocument documents = PdfDocument.FromFile(_pdf);
                        PdfPage pdfPage1 = documents.Pages[0];
                        float pdfPageWidth = pdfPage1.Size.Width;
                        float pdfPageHeight = pdfPage1.Size.Height;
                        int htmlLogoWidthPx = 600;
                        float htmlLogoWidthPt = PdfDpiTransform.FromPixelsToPoints(htmlLogoWidthPx);
                        float htmlLogoHeightPt = 100;
                        PdfRepeatCanvas repeatedCanvas = documents.CreateRepeatedCanvas(new System.Drawing.RectangleF(0, 1500, htmlLogoWidthPt, htmlLogoHeightPt));
                        document.AddDocument(documents);
                    }
                    catch (Exception ex)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('" + _pdf + "');", true);
                    }
                }
            }
        }
		 if (string.IsNullOrEmpty(Request.QueryString["LedgertransactionNo"]))
                            {

                                string query = "SELECT DISTINCT Test_ID FROM patient_labinvestigation_opd where PatientID=(Select PatientID  FROM patient_medical_history WHERE transactionId='" + TransactionID.Trim() + "' and Approved=1 and Result_Flag=1)";
                                DataTable dt1 = StockReports.GetDataTable(query.ToString());
                                string testids = "";
                                for (int i = 0; i < dt1.Rows.Count; i++)
                                {
                                    testids += dt1.Rows[i][0].ToString() + ",";
                                }
                                //if (testids.Length > 0)
                                //{
                                //    testids = testids.Substring(0, testids.Length - 1);
                                //    //TestID = Util.GetString(Request.QueryString["TestID"]);
                                //    TestID = Util.GetString(testids);
                                //    string url = "http://" + Resources.Resource.ipad + "/Tenwek/Design/Lab/printLabReport_pdf.aspx?TestID=" + TestID + "";
                                //    Stream stream = ConvertToStream(url);
                                //    PdfDocument pdfculture = PdfDocument.FromStream(stream);
                                //    document.AddDocument(pdfculture);
                                //}
                               


                            }

        //PdfPage page = document.Pages[document.Pages.Count - 1];
        int a = document.Pages.Count;
        PdfPage page = document.Pages[document.Pages.Count - 1];
        if (printEndOfReportAtFooter)
        {
            // page.Footer.Layout(FooterSignature(31, 10));
            // page.Footer.Layout(getPDFImage(31, 15));

            // Hide on 15-05-2017
            //if (ds.Tables["MyOtImage"].Rows.Count > 0)
            //{
            //    if (ds.Tables["MyOtImage"].Rows[0]["AppDoctorID"].ToString() != "")
            //    {
            //        if (isSign(ds.Tables["MyOtImage"].Rows[0]["AppDoctorID"].ToString()) == true)
            //            page.Footer.Layout(getPDFImage(450, 20, "Design/Doctor/DoctorSignature/" + Util.GetString(ds.Tables["MyOtImage"].Rows[0]["AppDoctorID"].ToString()) + ".jpg"));
            //    }
            //}
            // page.Footer.Layout(EndOfReport(225, 2));
        }


        try
        {
            // write the PDF document to a memory buffer
            byte[] pdfBuffer = document.WriteToMemory();

            // inform the browser about the binary data format
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");

            //// let the browser know how to open the PDF document and the file name
            //HttpContext.Current.Response.AddHeader("Content-Disposition", String.Format("attachment; filename=PdfText.pdf; size={0}",
            //            pdfBuffer.Length.ToString()));

            HttpContext.Current.Response.AddHeader("Content-Disposition", String.Format("inline; filename=PdfText.pdf; size={0}",
                                    pdfBuffer.Length.ToString()));

            // write the PDF buffer to HTTP response
            HttpContext.Current.Response.BinaryWrite(pdfBuffer);

            // call End() method of HTTP response to stop ASP.NET page processing
            HttpContext.Current.Response.End();
        }
        finally
        {

            document.Close();


        }

    }

    private static Stream ConvertToStream(string fileUrl)
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(fileUrl);
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();

        try
        {
            MemoryStream mem = new MemoryStream();
            //string aa = response.ResponseUri;
            Stream stream = response.GetResponseStream();

            stream.CopyTo(mem);

            return mem;
        }
        finally
        {
            response.Close();
        }
    }


    private string addOTDetails(string bookingID, string patientID, string Fromdate, string Todate)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = GetPatientBookingDetails(null, patientID, null, null);
        //  sb.Append("<div style='page-break-before:always'>&nbsp;</div> ");
        if (dt.Rows.Count > 0)
        {

        sb.Append("");
        sb.Append("<b>Operation Details</b><br/>");
        sb.Append("<style>table {  border-collapse: collapse;  width: 100%;}th, td {  text-align: left;  padding: 3px;}tr:nth-child(even) {background-color: #f2f2f2;}</style>");

       
            sb.Append("<div style='border:1px;'><table style='width:100%;display:block; margin: -1px; vertical-align:top;' border='1'>");


            for (int i = 0; i < dt.Rows.Count; i++)
            {
                sb.Append("<tr><td colspan='2'>" + (i + 1).ToString() + "</td></tr>");
                sb.Append("<tr valign='top'><td>Surgery </td><td> " + dt.Rows[i]["SurgeryName"].ToString() + "</td></tr><tr><td>Doctor</td><td>" + dt.Rows[i]["DoctorID"].ToString() + " " + dt.Rows[i]["DoctorName"].ToString() +
                    "</td></tr><tr><td> Surgery Date</td><td >" + dt.Rows[i]["SurgeryDate"].ToString() + "</td></tr>");

            }
            sb.Append("<table></div>");

        }
        //else
        //{
        //    sb.Append("<div style='border:1px;'><table style='width:100%;display:block; margin: -1px; vertical-align:top;' border='1'>");

        //    sb.Append("<tr><td>No Operations</td></tr>");
        //    sb.Append("</table></div>");
        //}
        return sb.ToString();
    }
    private DataTable GetPatientBookingDetails(string bookingID, string patientID, string Fromdate, string Todate)
    {
        //Fromdate = Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd");
        //Todate = Util.GetDateTime(Todate).ToString("yyyy-MM-dd");

        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append("SELECT ot.ID bookingID, ot.OTNumber, ot.PatientName, OT.PatientID , ot.Age, ot.Gender,ot.ContactNo , ot.Address, ot.DoctorID, CONCAT(dm.Title,' ',dm.Name)DoctorName, ot.SurgeryID, sm.Name SurgeryName, ot.OTID,om.Name OTName, DATE_FORMAT(ot.SurgeryDate,'%d-%b-%Y')SurgeryDate, DATE_FORMAT(ot.SlotFromTime,'%h:%i %p')SlotFromTime, DATE_FORMAT(ot.SlotToTime,'%h:%i %p')SlotToTime, ot.PatientID, ot.IsCancel,ot.IsConfirm, ot.RescheduledRefID,IF(IFNULL(ot.PatientID,'')='',0,1)IsRegistredPatient FROM ot_booking  ot INNER JOIN  doctor_master  dm  ON dm.DoctorID=ot.DoctorID INNER JOIN f_surgery_master sm ON sm.Surgery_ID=ot.SurgeryID INNER JOIN ot_master om ON om.ID=ot.OTID WHERE ot.IsActive=1 ");


        if (!string.IsNullOrEmpty(bookingID))
            sqlCMD.Append(" and ot.OTNumber=@bookingID");
        else if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" and ot.PatientID=@patientID");
        //if (!string.IsNullOrEmpty(Fromdate) && !string.IsNullOrEmpty(Todate))
        //{

        //    sqlCMD.Append(" and ot.`EntryDate`>='" + Fromdate + " 00:00:00' AND ot.`EntryDate`<='" + Todate + " 23:59:59'");
        //}

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            bookingID = bookingID,
            patientID = patientID
        });
        return (dt);
    }
   

    //private string getOrganismTable(DataTable dtOrganism)
    //{
    //    dtOrganism.Columns["LabObservationName"].ColumnName = "Organism";
    //    dtOrganism.Columns["Unit"].ColumnName = "Mic";
    //    dtOrganism.Columns["Value"].ColumnName = "Sensitivity";


    //    // Adding Header
    //    StringBuilder sbTH = new StringBuilder();
    //    sbTH.Append("<tr>");
    //    foreach (DataRow dr in dtOrganismStyle.Rows)
    //    {
    //        sbTH.Append("<th class='" + dr["Name"].ToString() + " tbOrganism'>" + dr["Label"].ToString() + "</th>");
    //    }
    //    sbTH.Append("</tr>");

    //    StringBuilder sb = new StringBuilder();

    //    for (int x = 0; x < dtOrganism.Rows.Count; x++)
    //    {
    //        DataRow drOrg = dtOrganism.Rows[x];

    //        if (drOrg["Sensitivity"].ToString().ToUpper() == "HEAD")
    //        {


    //            DataView view = new DataView(dtOrganism);
    //            view.RowFilter = "OrganismID = '" + drOrg["OrganismID"].ToString() + "' and Sensitivity<>'" + drOrg["Sensitivity"].ToString().ToUpper() + "'";
    //            //dtLabReport = view.ToTable().Copy();
    //            if (view.ToTable().Rows.Count > 0)
    //            {
    //                sb.Append(drOrg["Organism"].ToString() + "<br/>");

    //                // Adding Rows
    //                sb.Append("<table class='tbOrganism'>");
    //                sb.Append(sbTH.ToString());

    //                foreach (DataRow dr in view.ToTable().Rows)
    //                {
    //                    sb.Append("<tr>");
    //                    string newTD = "";
    //                    int colSpan = 1;
    //                    for (int j = dtOrganismStyle.Rows.Count - 1; j >= 0; j--)
    //                    {
    //                        DataRow drc = dtOrganismStyle.Rows[j];

    //                        //Condition to check blank value
    //                        string value = dr[drc["Name"].ToString()].ToString();
    //                        if ((value != ""))
    //                        {
    //                            if (value != "HEAD")
    //                                newTD = "<td class='" + drc["Name"].ToString() + " tbOrganism' colSpan='" + colSpan + "'>" + value + "</td>" + newTD;
    //                            else
    //                            {
    //                                newTD = sbTH.ToString() + "<td class='" + drc["Name"].ToString() + "' colSpan='" + colSpan + "'>" + value + "</td>" + newTD;
    //                            }
    //                            colSpan = 1;
    //                        }
    //                        else
    //                            colSpan++;
    //                    }
    //                    sb.Append(newTD);
    //                    sb.Append("</tr>");
    //                }
    //                sb.Append("</table>" + "<br/>");

    //            }
    //        }
    //    }
    //    return sb.ToString();
    //}

    public string MakeHeader(string Header, DataRow dr_Detail)
    {
        for (int i = 0; i < ds.Tables["DS"].Columns.Count; i++)
        {
            Header = Header.Replace("{" + ds.Tables["DS"].Columns[i].ColumnName + "}", dr_Detail[i].ToString());
        }
        return Header;

    }

    //public string getTags_Flag(string Value, string MinRange, string MaxRange, string AbnormalValue)
    //{
    //    string ret_value = Value;
    //    try
    //    {

    //        //if ((MinRange != "") && (Util.GetDecimal(Value) < Util.GetDecimal(MinRange)))
    //        //    ret_value = "L";
    //        //else if ((MaxRange != "") && (Util.GetDecimal(Value) > Util.GetDecimal(MaxRange)))
    //        //    ret_value = "H";

    //    }
    //    catch (Exception ex) { }

    //    if ((ret_value == "") || (ret_value.ToLower() == "head"))
    //        ret_value = "";

    //    return ret_value;

    //}

    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {

        PdfPage page1 = eventParams.PdfPage;

        SetHeader(page1);
        SetFooter(page1);
        //------------------------------------------//
        page1.CreateFooterCanvas(FooterHeight + SignatureHeight);

        float footerHeight = page1.Footer.Height;
        float footerWidth = page1.Footer.Width;

        // layout a simple line
        PdfLine pdfLine = new PdfLine(
                    new System.Drawing.PointF(XFooter, 0.5f + SignatureHeight),
                    new System.Drawing.PointF(XFooter + PageWidth, 0.5f + SignatureHeight));
        //  page1.Footer.Layout(pdfLine);

        //if (ApprovedBySignAtFooter)
        //{
        //    if (isSign(drcurrent["ApprovedBy"].ToString()))
        //    {
        //        if (page1.Footer != null)
        //        {
        //            page1.Footer.Layout(getPDFImage(430, FooterHeight+50 , "Design/opd/signature/" + Util.GetString(drcurrent["ApprovedBy"]) + ".jpg"));
        //        }
        //    }
        //}
        //------------------------//
        page1.CreateFooterCanvas(FooterHeight);
        // float footerHeight = page1.Footer.Height;
        // float footerWidth = page1.Footer.Width;
        // create a border for footer
        if (footerTopLine)
        {
            PdfRectangle borderRectangle = new PdfRectangle(XFooter, 0.5f, PageWidth, 0.25f);
            borderRectangle.LineStyle.LineWidth = 0.5f;
            borderRectangle.ForeColor = Color.Black;
            page1.Footer.Layout(borderRectangle);
        }
        int isShowDeg = 0;
        //if (ApprovedBySignAtFooter)
        //{
        //    if (isSign(drcurrent["ApprovedBy"].ToString()))
        //    {
        //        if (page1.Footer != null)
        //        {
        //            page1.Footer.Layout(getPDFImage(430, FooterHeight - 190, "Design/Doctor/DoctorSignature/" + Util.GetString(drcurrent["ApprovedBy"]) + ".jpg"));
        //            isShowDeg = 1;
        //        }
        //    }
        //}


        // add page numbering in a text element
        System.Drawing.Font pageNumberingFont =
           new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);
        PdfText pageNumberingText = new PdfText(500, FooterHeight - 35, "Page {CrtPage} of {PageCount}", pageNumberingFont);
        page1.Footer.Layout(pageNumberingText);

        // print datetime
        PdfText page1Text = new PdfText(10, FooterHeight - 35, String.Format("{0}   {1}", DateTime.Now.ToString("dd/MM/yyyy"), DateTime.Now.ToShortTimeString()), pageNumberingFont);
        page1Text.ForeColor = System.Drawing.Color.Black;
        page1.Footer.Layout(page1Text);

        // Prepared By
        if (ds.Tables["MyOtImage"].Rows.Count > 0)
        {
            PdfText page1TextRe = new PdfText(130, FooterHeight - 35, "Prepared By : " + ds.Tables["MyOtImage"].Rows[0]["PreparedBy"].ToString(), pageNumberingFont);
            page1TextRe.ForeColor = System.Drawing.Color.Black;
            page1.Footer.Layout(page1TextRe);
        }
        //Printed By 
        if (Util.GetString(Session["ID"]) != "" && Util.GetString(Session["ID"]) != null)
        {
            DataTable dtPrientedBy = StockReports.GetDataTable(" SELECT UPPER(CONCAT(em.title,' ',em.name))PreparedBY FROM  employee_master em WHERE em.EmployeeID='" + Util.GetString(Session["id"]) + "' ");
            PdfText page1TextRe = new PdfText(330, FooterHeight - 35, "Printed By : " + dtPrientedBy.Rows[0]["PreparedBY"].ToString(), pageNumberingFont);
            page1TextRe.ForeColor = System.Drawing.Color.Black;
            page1.Footer.Layout(page1TextRe);
        }
        // page1.Footer.Layout(FooterLine(10, FooterHeight - 100));

        if (isShowDeg == 1)
        {
            System.Drawing.Font DegFont =
            new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 12, System.Drawing.GraphicsUnit.Point);

            PdfText page1TextDeg = new PdfText(460, FooterHeight - 130, "" + drcurrent["DocDegree"].ToString(), DegFont);
            page1TextDeg.ForeColor = System.Drawing.Color.Black;
            page1.Footer.Layout(page1TextDeg);
        }
        //// End Line
        //PdfText page1TextEnd = new PdfText(10, FooterHeight - 140, "Note : This Case Sheet Is Issued as a medical record, not be used as a legal document. For any Emergency or allergies inform to the Hospital immediately. <br/> Ph : 04285240130, 131, 132, Mobile : 094422 92995, <br/> Email:-info@abhiskhospital.com <br/> Website:- www.abhiskhospital.com", pageNumberingFont);
        //page1TextRe.ForeColor = System.Drawing.Color.Black;
        //page1.Footer.Layout(page1TextEnd);
        //--------------------------------------//
        // SetFooter(page1); 

        //Printing two special lines at each page.
        // page.Footer.Layout(TwoLines(5, FooterHeight - 115));

    }
    bool isSign(string imgID)
    {
        return (File.Exists(Server.MapPath("~/Design/Doctor/DoctorSignature/") + "" + imgID + ".jpg"));
    }

    private PdfImage getPDFImage(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Server.MapPath("~/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private void AddContent(string Content, DataRow dr)
    {
        // PdfPage page1 = document.AddPage();
        PdfPage page1 = document.AddPage(PdfPageSize.A4, new PdfDocumentMargins(5), PdfPageOrientation.Portrait);
        PdfHtml html1 = new PdfHtml();

        if (html1LayoutInfo == null)
        {
            html1LayoutInfo = page1.Layout(html1);

        }

        html1 = new PdfHtml(MarginLeft, html1LayoutInfo.LastPageRectangle.Height, PageWidth, Content, null);
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);


        html1.FontEmbedding = false;
        html1.BrowserWidth = BrowserWidth;


        html1LayoutInfo = page1.Layout(html1);

        if (!printEndOfReportAtFooter)
        {

            if (dtObs.Rows.IndexOf(drcurrent) < dtObs.Rows.Count - 1 ? dtObs.Rows[dtObs.Rows.IndexOf(drcurrent) + 1]["LabNo"].ToString() != drcurrent["LabNo"].ToString() : false)
            {
                page1.Layout(EndOfReport(200, html1LayoutInfo.LastPageRectangle.Height + 10));
            }
        }



        if (showItdose)
        {
            System.Drawing.Font sysFontBold = new System.Drawing.Font("Arial",
            6, System.Drawing.FontStyle.Regular,
            System.Drawing.GraphicsUnit.Point);
            PdfText titleRotatedText = new PdfText(2, -20, "", sysFontBold);
            titleRotatedText.ForeColor = System.Drawing.Color.Black;
            titleRotatedText.RotationAngle = 90;
            page1.Layout(titleRotatedText);
        }
    }
    private string MakeHospitalHeader()
    {
        DataTable dtHeader = StockReports.GetDataTable("select HeaderText,FooterText from Receipt_Header WHERE HeaderType='OPD' AND CentreID='1' ");
        string divwidth = "800px";
        StringBuilder Header = new StringBuilder();
        //  Header.Append("<div style='width:" + divwidth + ";text-align:center;'>" + dtHeader.Rows[0]["HeaderText"].ToString() + "</div> ");
        //Header.Append("<div style='width:" + divwidth + ";text-align:center;font-weight:bold;border:0px solid black;'><u>" + HeaderText + "<u></div> ");
        // Header.Append("<div style='width:" + divwidth + ";text-align:center;font-weight:bold;border:0px solid black;height:32px'> </div> ");
        return Header.ToString();
    }
    private void SetHeader(PdfPage page)
    {
        // create the document header
        page.CreateHeaderCanvas(HeaderHeight);

        PdfHtml CenterheaderHtml = new PdfHtml(20, 3, PageWidth, MakeHospitalHeader(), null);
        CenterheaderHtml.FitDestWidth = true;
        CenterheaderHtml.FontEmbedding = false;
        CenterheaderHtml.Opacity = 999999;
        CenterheaderHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(CenterheaderHtml);

        // layout HTML in header
        // PdfHtml headerHtml = null;
        // if (headerHtml == null)
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader(Server.HtmlDecode(drcurrent["ReportHeader"].ToString()), drcurrent), null);
        //headerHtml.FitDestHeight = true;
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;



        page.Header.Layout(headerHtml);




        if (HeaderImage)
        {
            //page.Header.Layout(getPDFImage(XHeaderImg, YHeaderImg, PageWidth, HeaderImg));
            page.Header.Layout(getPDFImageHeader(HeaderImg));
        }



        if (BottomLine)
        {


            //PdfText headerHtmlSpecimen = new PdfText(XHeader, YHeader, PageWidth, strSpecimen, null);



            // create a border for header
            float headerHeight = page.Header.Height;
            float headerWidth = page.Header.Width;

            System.Drawing.Font pageNumberingFont =
          new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 12, System.Drawing.GraphicsUnit.Point);

            PdfText headerHtmlSpecimen = new PdfText(XHeader, headerHeight - 20, PageWidth, strSpecimen, pageNumberingFont);

            page.Header.Layout(headerHtmlSpecimen);


            // PdfRectangle borderRectangle = new PdfRectangle(XHeader, HeaderHeight - 1, PageWidth, 0.25f);

            //borderRectangle.LineStyle.LineWidth = 0.5f;
            //borderRectangle.ForeColor = Color.Black;
            //page.Header.Layout(borderRectangle);
        }


        if (TopLine)
        {
            // create a border for header
            float headerHeight = page.Header.Height;
            float headerWidth = page.Header.Width;
            PdfRectangle borderRectangle = new PdfRectangle(XHeader, YHeader, PageWidth, 0.25f);

            borderRectangle.LineStyle.LineWidth = 0.5f;
            borderRectangle.ForeColor = Color.Black;
            page.Header.Layout(borderRectangle);
        }
    }

    private PdfText getHeaderLabel(DataRow dr, PdfLayoutInfo textLayoutInfo)
    {
        System.Drawing.Font sysFont = new System.Drawing.Font(dr["FName"].ToString(),
                Util.GetFloat(dr["FSize"]),
                        System.Drawing.GraphicsUnit.Point);

        //sysFont.Style= FontStyle.Bold | FontStyle.Italic;

        if (dr["Bold"].ToString() == "Y")
            sysFont = new Font(sysFont, sysFont.Style ^ FontStyle.Bold);

        if (dr["Italic"].ToString() == "Y")
            sysFont = new Font(sysFont, sysFont.Style ^ FontStyle.Italic);

        if (dr["Under"].ToString() == "Y")
            sysFont = new Font(sysFont, sysFont.Style ^ FontStyle.Underline);




        PdfText pt = new PdfText();


        if (dr["Alignment"].ToString() == "Right")
            pt.HorizontalAlign = PdfTextHAlign.Right;
        else if (dr["Alignment"].ToString() == "Centre")
            pt.HorizontalAlign = PdfTextHAlign.Center;


        if (dr["Type"].ToString() == "Data")
        {
            if (dtObs.Columns.Contains(dr["Data"].ToString()))
            {
                pt.Text = drcurrent[dr["Data"].ToString()].ToString();

            }
        }

        else
        {
            pt.Text = dr["Data"].ToString();
        }


        pt.TextSystemFont = sysFont;
        pt.ForeColor = System.Drawing.Color.FromName(dr["P_Forecolor"].ToString());
        pt.DestWidth = Util.GetFloat(dr["Width"]);
        pt.DestX = XHeader + Util.GetFloat(dr["leftadd"]);
        pt.DestY = YHeader + Util.GetFloat(dr["topAdd"]);
        //labelWidth = labelWidth + pt.DestWidth ;

        return pt;
    }

    private void SetFooter(PdfPage page)
    {
        // create the document Foooter
        page.CreateFooterCanvas(FooterHeight);
        float footerHeight = page.Footer.Height;
        float footerWidth = page.Footer.Width;
        // create a border for footer
        if (footerTopLine)
        {
            PdfRectangle borderRectangle = new PdfRectangle(XFooter, 0.5f, PageWidth, 0.25f);
            borderRectangle.LineStyle.LineWidth = 0.5f;
            borderRectangle.ForeColor = Color.Black;
            page.Footer.Layout(borderRectangle);
        }

        // add page numbering in a text element
        System.Drawing.Font pageNumberingFont =
           new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);
        PdfText pageNumberingText = new PdfText(500, FooterHeight - 30, "Page {CrtPage} of {PageCount}", pageNumberingFont);
        page.Footer.Layout(pageNumberingText);

        // print datetime
        PdfText page1Text = new PdfText(10, FooterHeight - 30, String.Format("{0}   {1}", DateTime.Now.ToString("dd/MM/yyyy"), DateTime.Now.ToShortTimeString()), pageNumberingFont);
        page1Text.ForeColor = System.Drawing.Color.Black;
        page.Footer.Layout(page1Text);

        //Printing two special lines at each page.
        // page.Footer.Layout(TwoLines(5, FooterHeight - 115));



        //if (ApprovedBySignAtFooter)
        //{
        //    if ((dtObs.Rows.IndexOf(drcurrent) < dtObs.Rows.Count - 1)
        //          ||
        //          (dtObs.Rows.IndexOf(drcurrent) == dtObs.Rows.Count - 1)
        //          ||
        //          (dtObs.Rows[dtObs.Rows.IndexOf(ds.Tables["MyOtImage"].Rows[0]) + 1]["AppDoctorID"].ToString() != ds.Tables["MyOtImage"].Rows[0]["AppDoctorID"].ToString() && drcurrent["AppDoctorID"].ToString() != "")
        //          )
        //        if (isSign(ds.Tables["MyOtImage"].Rows[0]["AppDoctorID"].ToString()))
        //        {
        //            if (page.Footer != null)
        //            {
        //                page.Footer.Layout(getPDFImage(450, 5, "Design/Doctor/DoctorSignature/" + Util.GetString(ds.Tables["MyOtImage"].Rows[0]["AppDoctorID"].ToString()) + ".jpg"));
        //            }
        //        }
        //    }
    }

    PdfHtml FooterSignature(float X, float Y)
    {
        return new PdfHtml(X, Y, drcurrent["ReportFooter"].ToString(), null);
    }
    PdfText EndOfReport(float X, float Y)
    {
        return new PdfText(X, Y, "*** End Of Report ***", new Font("Times New Roman", 8));

    }
    PdfHtml TwoLines(float X, float Y)
    {
        string strTwoLines = "<table><tr> <td style='width:23%'>*NOTE:Please see overleaf for conditions of reporting</td></tr></table>";
        return new PdfHtml(X, Y, strTwoLines, null);
    }

    #region ImageProcess


    public String ConvertImageURLToBase64(String url)
    {
        StringBuilder _sb = new StringBuilder();

        Byte[] _byte = this.GetImage(url);

        _sb.Append(Convert.ToBase64String(_byte, 0, _byte.Length));

        return _sb.ToString();
    }

    private byte[] GetImage(string url)
    {
        Stream stream = null;
        byte[] buf;

        try
        {
            WebProxy myProxy = new WebProxy();
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);

            HttpWebResponse response = (HttpWebResponse)req.GetResponse();
            stream = response.GetResponseStream();

            using (BinaryReader br = new BinaryReader(stream))
            {
                int len = (int)(response.ContentLength);
                buf = br.ReadBytes(len);
                br.Close();
            }

            stream.Close();
            response.Close();
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            buf = null;
        }

        return (buf);
    }

    private PdfImage getPDFImageHeader(string SignImg)
    {
        //SignImg = "~/Images/ipdns.png";
        PdfImage transparentResizedPdfImage = new PdfImage(30, 10, 100, Server.MapPath("~/Images/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImage(float X, float Y, float Width, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Width, Server.MapPath("~/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    //convert bytearray to image
    public System.Drawing.Image byteArrayToImage(byte[] byteArrayIn)
    {
        using (MemoryStream mStream = new MemoryStream(byteArrayIn))
        {
            //System.Drawing.Image.FromStream(mStream).Save(@"E:\abcnew.jpg");
            return System.Drawing.Image.FromStream(mStream, true, true);
        }
    }

    #endregion

    PdfHtml FooterLine(float X, float Y)
    {
        return new PdfHtml(X, Y, drcurrent["FooterLine"].ToString(), null);
    }

    public void getData(string TransactionID, string Status, string ReportType, int isEmergencyPatient, string dtd)
    {


        dt = CreateStockMaster.SearchPatientEMR("", "", TransactionID, "", "", "", "", "", "", "", "", "", Status, isEmergencyPatient);

        if (dt != null && dt.Rows.Count > 0)
        {

            //If Patient is Not Discharged then Temporary Date of Discharge Should be Updated in blank Discharge Date in table
            DataTable DischargeDate = StockReports.GetDataTable("Select DateOfDiscahrge AS DischargeDate,ifnull(SurgeryDate,'')SurgeryDate from emr_ipd_details where TransactionID='" + TransactionID + "' ");

            if (dt.Rows[0]["DischargeDate"].ToString().Trim() == "-" && Status == "IN" && DischargeDate.Rows[0]["DischargeDate"].ToString() != "")
                dt.Rows[0]["DischargeDate"] = Util.GetDateTime(DischargeDate.Rows[0]["DischargeDate"]).ToString("dd-MMM-yyyy HH:mm:00");
            if (DischargeDate.Rows[0]["SurgeryDate"].ToString() != "")
                dt.Rows[0]["SurgeryDate"] = Util.GetDateTime(DischargeDate.Rows[0]["SurgeryDate"]).ToString("dd-MMM-yyyy");
            else
                dt.Rows[0]["SurgeryDate"] = "";
            DataTable dt2 = getPatientDR(TransactionID, dt.Rows[0]["DocDepartmentID"].ToString());

            //DataTable dt2 = getPatientDR(TransactionID);
            DataColumn DC2 = new DataColumn("Specialization");
            DC2.DefaultValue = StockReports.ExecuteScalar("SELECT Designation FROM doctor_master WHERE DoctorID= (SELECT DoctorID FROM patient_medical_history WHERE TransactionID='" + TransactionID + "')");
            dt2.Columns.Add(DC2);

            DataColumn DC3 = new DataColumn("PreparedBy");
            DC3.DefaultValue = Session["LoginName"].ToString();
            dt2.Columns.Add(DC3);

            DataColumn DC4 = new DataColumn("ApprovedBy");
            DC4.DefaultValue = StockReports.ExecuteScalar("SELECT DoctorID FROM patient_medical_history WHERE TransactionID='" + TransactionID + "'");
            dt2.Columns.Add(DC4);

            dt2.Columns.Add("PName");
            dt2.Columns.Add("Mobile");
            dt2.Columns.Add("PatientID");
            dt2.Columns.Add("Gender");
            dt2.Columns.Add("Relation");
            dt2.Columns.Add("RelationName");
            dt2.Columns.Add("Address");
            dt2.Columns.Add("Age");
            dt2.Columns.Add("TransactionID");
            dt2.Columns.Add("DName");
            dt2.Columns.Add("DocMobile");
            dt2.Columns.Add("DocDegree");
            dt2.Columns.Add("RName");
            dt2.Columns.Add("Company_Name");
            dt2.Columns.Add("BillingCategory");
            dt2.Columns.Add("AdmitDate");
            dt2.Columns.Add("DischargeDate");
            dt2.Columns.Add("SurgeryDate");
            dt2.Columns.Add("Status");
            dt2.Columns.Add("AgeSex");
            dt2.Columns.Add("RoomName");
            dt2.Columns.Add("Room_No");
            dt2.Columns.Add("IPDCaseTypeID");
            dt2.Columns.Add("ReferenceCode");
            dt2.Columns.Add("PanelID");
            dt2.Columns.Add("DischargeType");
            dt2.Columns.Add("KinRelation");
            dt2.Columns.Add("KinName");
            dt2.Columns.Add("Floorbed");
            dt2.Columns.Add("DName2");
            dt2.Columns.Add("RegNo2");
            dt2.Columns.Add("Spec2");
            dt2.Columns.Add("DoctorDegree2");
            dt2.Columns.Add("DocMobile2");

            dt2.Columns.Add("ReportHeader");
            dt2.Columns.Add("ReportFooter");
            dt2.Columns.Add("RoleID");

            //   dt2.Columns.Add("PreparedBy");
            dt2.Columns.Add("FooterLine");

            DataTable dtnew = new DataTable();
            dtnew = StockReports.GetDataTable("select CONCAT(Title,' ',dm.Name) as DName,dm.degree DoctorDegree,dm.IMARegistartionNo,dm.Specialization,dm.Mobile DocMobile,Designation from doctor_master dm where dm.DoctorID in(select DoctorID1 from patient_medical_history where TransactionID='" + TransactionID + "')");

            //  string reportHeader = StockReports.ExecuteScalar("SELECT reportheader FROM d_header_footer_html WHERE roleid='" + PHead + "' AND TYPE='Report' ").ToString();
            //  string reportFooter = StockReports.ExecuteScalar("SELECT ReportFooter FROM d_header_footer_html WHERE roleid='" + PHead + "' AND TYPE='Report' ").ToString();
            //   string FooterLine = StockReports.ExecuteScalar("SELECT FooterLine FROM d_header_footer_html WHERE roleid='" + PHead + "' AND TYPE='Report' ").ToString();

            DataTable headerFooter = StockReports.GetDataTable(" SELECT reportheader,ReportFooter,FooterLine FROM d_header_footer_html WHERE roleid='" + PHead + "' AND TYPE='Report'  ");

            // string MedRecord = "Select * from discharge_medicine where TransactionID='" + TransactionID.Trim() + "'";

            /* Added Generic Name for the the Item. */
            string MedRecord = " Select dm.*, ifnull(fsm.Name,'') Generic from discharge_medicine dm LEFT JOIN f_item_salt fis ON fis.`ItemID` = dm.`ItemID` LEFT JOIN f_salt_master fsm ON fsm.`SaltID` = fis.`saltID` where TransactionID='" + TransactionID.Trim() + "'";

            DataTable dtMedRecord = StockReports.GetDataTable(MedRecord.ToString());

            if (dtMedRecord.Rows.Count > 0)
            {
                if (dt2.Rows.Count > 0)
                {
                    DataRow drow = dt2.NewRow();
                    drow["SNO"] = "10";
                    dt2.Rows.Add(drow);
                }
            }

            foreach (DataRow dw in dt2.Rows)
            {
                if (dtnew != null && dtnew.Rows.Count > 0)
                {
                    dw["DName2"] = dtnew.Rows[0]["DName"].ToString();
                    dw["RegNo2"] = dtnew.Rows[0]["IMARegistartionNo"].ToString();
                    dw["Spec2"] = dtnew.Rows[0]["Designation"].ToString();
                    dw["DoctorDegree2"] = dtnew.Rows[0]["DoctorDegree"].ToString();
                    dw["DocMobile2"] = dtnew.Rows[0]["DocMobile"].ToString();
                }
                dw["reportheader"] = headerFooter.Rows[0]["reportHeader"].ToString();
                dw["ReportFooter"] = headerFooter.Rows[0]["ReportFooter"].ToString();
                dw["RoleID"] = PHead.ToString();

                dw["PName"] = dt.Rows[0]["PName"].ToString();
                dw["Mobile"] = dt.Rows[0]["Mobile"].ToString(); ;
                dw["PatientID"] = dt.Rows[0]["PatientID"].ToString();
                dw["Gender"] = dt.Rows[0]["Gender"].ToString();
                dw["Relation"] = dt.Rows[0]["Relation"].ToString();
                dw["RelationName"] = dt.Rows[0]["RelationName"].ToString();
                dw["Address"] = dt.Rows[0]["Address"].ToString();
                dw["Age"] = dt.Rows[0]["Age"].ToString();
                dw["TransactionID"] = dt.Rows[0]["TransNo"].ToString();
                dw["DName"] = dt.Rows[0]["DName"].ToString();
                dw["DocMobile"] = dt.Rows[0]["DocMobile"].ToString();
                dw["DocDegree"] = dt.Rows[0]["DocDegree"].ToString();
                dw["RName"] = dt.Rows[0]["RName"].ToString();
                dw["Company_Name"] = dt.Rows[0]["Company_Name"].ToString();
                dw["BillingCategory"] = dt.Rows[0]["BillingCategory"].ToString();
                dw["AdmitDate"] = dt.Rows[0]["AdmitDate"].ToString();




                dw["DischargeDate"] = dtd != "" ? dtd : dt.Rows[0]["DischargeDate"].ToString();


                dw["SurgeryDate"] = dt.Rows[0]["SurgeryDate"].ToString();
                dw["Status"] = dt.Rows[0]["Status"].ToString();
                dw["AgeSex"] = dt.Rows[0]["AgeSex"].ToString();
                dw["RoomName"] = dt.Rows[0]["RoomName"].ToString();
                dw["Room_No"] = dt.Rows[0]["Room_No"].ToString();
                dw["IPDCaseTypeID"] = dt.Rows[0]["IPDCaseTypeID"].ToString();
                dw["ReferenceCode"] = dt.Rows[0]["ReferenceCode"].ToString();
                dw["PanelID"] = dt.Rows[0]["PanelID"].ToString();
                dw["DischargeType"] = dt.Rows[0]["DischargeType"].ToString();
                dw["KinRelation"] = dt.Rows[0]["KinRelation"].ToString();
                dw["KinName"] = dt.Rows[0]["KinName"].ToString();
                dw["Floorbed"] = dt.Rows[0]["Floorbed"].ToString();
                //   dw["PreparedBy"] = dt.Rows[0]["USER"].ToString();
                dw["FooterLine"] = headerFooter.Rows[0]["FooterLine"].ToString();
            }
            dt2.AcceptChanges();

            var MandatoryheaderValidation = true;

            DataTable dt3 = getPatientInvestigationText(TransactionID);
            DataTable dt4 = getPatientInvestigationNimericNew(TransactionID);
            DataTable dtSurgery = getOTDetail(TransactionID);
            DataTable dt7 = getconsultant(TransactionID);
            DataTable dt8 = PatientFollowupVisit(TransactionID);
            DataColumn dc = new DataColumn();
            dc.ColumnName = "InvestigationText";
            if (dt3.Rows.Count > 0)
                dc.DefaultValue = "1";

            else
                dc.DefaultValue = "0";

            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "InvestigationNumeric";
            if (dt4.Rows.Count > 0)
                dc.DefaultValue = "1";

            else
                dc.DefaultValue = "0";



            dt.Columns.Add(dc);
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "General";

            ds.Tables.Add(dt2.Copy());
            ds.Tables[1].TableName = "DS";

            ds.Tables.Add(dt3.Copy());
            ds.Tables[2].TableName = "InvestigationText";

            ds.Tables.Add(dt4.Copy());
            ds.Tables[3].TableName = "InvestigationNimeric";



            string sb = "select OtImage,OtImageNarration,Header,Footer,UPPER(CONCAT(em.title,'',em.name))PreparedBY,AppDoctorID FROM emr_ipd_details ed INNER JOIN employee_master em ON em.EmployeeID = ed.PreparedBy where ed.TransactionID ='" + TransactionID.Trim() + "'";
            DataTable FileNameDt = StockReports.GetDataTable(sb);
            if (FileNameDt.Rows.Count > 0)
            {

                DataRow drow;
                DataTable dtt = new DataTable();
                dtt.Columns.Add("image", System.Type.GetType("System.Byte[]"));
                dtt.Columns.Add("Surgery Images");
                dtt.Columns.Add("OtImageNarration");

                dtt.Columns.Add("Header");
                dtt.Columns.Add("Footer");
                dtt.Columns.Add("PreparedBy");
                dtt.Columns.Add("AppDoctorID");
                drow = dtt.NewRow();

                if (FileNameDt.Rows[0]["OtImage"].ToString() != string.Empty)
                {
                    // string path = Server.MapPath("OtImages/" + FileNameDt.Rows[0]["OtImage"].ToString());
                    string ImaPath = "Design/EMR/OtImages/" + TransactionID + "/" + FileNameDt.Rows[0]["OtImage"].ToString();
                    string path = Server.MapPath("~/" + ImaPath);
                    FileStream fs = new FileStream(path, FileMode.Open, System.IO.FileAccess.Read);


                    byte[] imgbyte = new byte[fs.Length + 1];
                    fs.Read(imgbyte, 0, (int)fs.Length);
                    fs.Close();

                    drow["image"] = imgbyte;
                    drow["image"] = FileNameDt.Rows[0]["OtImage"].ToString();
                    drow["Surgery Images"] = "Surgery Images";
                    drow["OtImageNarration"] = FileNameDt.Rows[0]["OtImageNarration"].ToString();
                }
                drow["Footer"] = FileNameDt.Rows[0]["Footer"].ToString();
                drow["Header"] = FileNameDt.Rows[0]["Header"].ToString();
                drow["PreparedBy"] = FileNameDt.Rows[0]["PreparedBy"].ToString();
                drow["AppDoctorID"] = FileNameDt.Rows[0]["AppDoctorID"].ToString();
                dtt.Rows.Add(drow);
                ds.Tables.Add(dtt.Copy());
                ds.Tables[4].TableName = "MyOtImage";

            }


            else
            {
                DataTable dtt = new DataTable();
                dtt.Columns.Add("image", System.Type.GetType("System.Byte[]"));
                dtt.Columns.Add("Surgery Images");
                ds.Tables.Add(dtt.Copy());
                ds.Tables[4].TableName = "MyOtImage";
            }

            sb = "select OtImage,OtImageNarration,PhotoWidth,PhotoHeight,ifnull(DocumentType,'')DocumentType from emr_ipd_details_image where TransactionID ='" + TransactionID.Trim() + "'";
            DataTable dtImage = StockReports.GetDataTable(sb);
            DataTable dtTempImages = new DataTable();
            dtTempImages.Columns.Add("image", System.Type.GetType("System.Byte[]"));
            //dtTempImages.Columns.Add("image");
            dtTempImages.Columns.Add("Surgery Images");
            dtTempImages.Columns.Add("OtImageNarration");
            //if (dtImage.Rows.Count > 0)
            //{
            //    foreach (DataRow dr in dtImage.Rows)
            //    {
            //        DataRow drow;
            //        drow = dtTempImages.NewRow();

            //        if (dr["OtImage"].ToString() != string.Empty)
            //        {
            //        //    string path = HttpContext.Current.Server.MapPath(@"~/OtImages/" + TransactionID + "/" + dr["OtImage"].ToString());
            //            string ImaPath = "Design/EMR/OtImages/" + TransactionID + "/" + dr["OtImage"].ToString();
            //            string path = Server.MapPath("~/" + ImaPath);
            //            FileStream fs = new FileStream(path, FileMode.Open, System.IO.FileAccess.Read);


            //            byte[] imgbyte = new byte[fs.Length + 1];
            //            fs.Read(imgbyte, 0, (int)fs.Length);
            //            fs.Close();

            //            drow["image"] = imgbyte;
            //            //drow["image"] = dr["OtImage"].ToString();
            //            drow["Surgery Images"] = "Surgery Images";
            //            drow["OtImageNarration"] = dr["OtImageNarration"].ToString();
            //        }
            //        dtTempImages.Rows.Add(drow);
            //    }
            //}

            string Doc_footer = "Select * from f_patientdoctorfooter where TransactionID='" + TransactionID.Trim() + "'";
            DataTable dtDoc_footer = StockReports.GetDataTable(Doc_footer.ToString());
            StringBuilder sf = new StringBuilder();
            sf.Append(" SELECT REPLACE(icdp.TransactionID,'ISHHI','')'IPD No.',TransactionID,Group_Code ,Group_Desc , ");
            sf.Append(" ICD10_3_Code , ICD10_3_Code_Desc ,ICD10_Code , WHO_Full_Desc ,icdp.icd_id,icdp.ID  ");
            sf.Append(" FROM cpoe_10cm_patient icdp INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID where icdp.IsActive=1");
            sf.Append(" AND icd.Isactive=1 AND icdp.TransactionID='" + TransactionID.Trim() + "' ");
            DataTable dtFinal = StockReports.GetDataTable(sf.ToString());

            ds.Tables.Add(dtImage.Copy());
            ds.Tables[5].TableName = "MyOtImageNew";

            ds.Tables.Add(dt7.Copy());
            ds.Tables[6].TableName = "AddConsultant";

            ds.Tables.Add(dtMedRecord.Copy());
            ds.Tables[7].TableName = "MedRecord";

            ds.Tables.Add(dtDoc_footer.Copy());
            ds.Tables[8].TableName = "DocFooter";

            ds.Tables.Add(dtFinal.Copy());
            ds.Tables[9].TableName = "FinalDiagnosis";

            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[10].TableName = "ClientImage";

            ds.Tables.Add(dtSurgery.Copy());
            ds.Tables[11].TableName = "OTSurgery";

            StringBuilder snew = new StringBuilder();
            snew.Append(" SELECT  shm.Id,shm.DischargeName,ddh.HeaderName  ");
            snew.Append(" FROM d_setheader_Mandatory shm INNER JOIN d_discharge_header ddh ON ddh.Header_Id= shm.HeaderId WHERE  shm.IsActive=1 ");
            snew.Append(" AND DischargeName='" + ds.Tables["MyOtImage"].Rows[0]["Header"].ToString() + "' and shm.mandatoryType=1 ");
            DataTable MandatoryHeader = StockReports.GetDataTable(snew.ToString());

            ds.Tables.Add(MandatoryHeader.Copy());
            ds.Tables[12].TableName = "MandatoryHeader";
            
            ds.Tables.Add(dt8.Copy());
            ds.Tables[13].TableName = "FollowUpVisit";


        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key12222", "window.print();", true);
    }

    private DataTable PatientFollowupVisit(string TransactionID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT DATE_FORMAT(ct.FollowUpSelectedDate,'%d-%b-%y')FollowupDate,CONCAT(dm.Title,' ',dm.NAME)DoctorName FROM cpoe_assessment ct INNER JOIN doctor_master dm ON ct.doctorid=dm.DoctorID AND ct.TransactionID='"+TransactionID+"'");

        return dt;
    }
    //public DataTable getPatientDR(string TransactionID)
    //{


    //    StringBuilder sb = new StringBuilder();
    //    sb.Append(" SELECT det.HeaderName DS_FIELD,det.Detail DS_SUMMARY,hed.SeqNo SNO,em.Name FROM  ");

    //    sb.Append("d_discharge_header ");

    //    sb.Append(" hed INNER JOIN emr_DRDetail det ON hed.Header_Id=det.Header_Id INNER JOIN employee_master em ON em.Employee_ID=det.UserID WHERE  TransactionID='" + TransactionID + "' ORDER BY hed.SeqNo");


    //    DataTable dtNew = StockReports.GetDataTable(sb.ToString());

    //    return dtNew;

    //}
    public DataTable getPatientDR(string TransactionID, string DocDepartmentID)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) from d_Header_DeptWise Where Department='" + DocDepartmentID + "' "));

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT * FROM ( SELECT '' DS_FIELD,'ShowInvestigationBeforeAdvice' DS_SUMMARY,6 SNO,'' NAME union SELECT '' DS_FIELD,'OTSummary' DS_SUMMARY,15 SNO,'' NAME UNION SELECT 'ADVICE ON DISCHARGE' DS_FIELD,'DischargeMedicine' DS_SUMMARY,16 SNO,'' NAME    ");
        sb.Append("");
        //sb.Append("UNION SELECT ' ' DS_FIELD,'Clinic Follow-up' DS_SUMMARY,29 SNO,'' NAME ");
        sb.Append("");
        sb.Append(" UNION SELECT det.HeaderName DS_FIELD,det.Detail DS_SUMMARY,hed.SeqNo SNO,em.Name  FROM  ");
        if (count == 0)
            sb.Append("d_discharge_header ");
        else
            sb.Append(" d_Header_DeptWise ");
        sb.Append(" hed INNER JOIN emr_DRDetail det ON hed.Header_Id=det.Header_Id INNER JOIN employee_master em ON em.EmployeeID=det.UserID WHERE  TransactionID='" + TransactionID + "'");

        //if (count != 0)
           // sb.Append("and hed.Department='" + DocDepartmentID + "'");

        //sb.Append(" ORDER BY hed.SeqNo");
        sb.Append(") t ORDER BY SNO ASC,DS_FIELD asc");
        DataTable dtNew = StockReports.GetDataTable(sb.ToString());

        return dtNew;

    }

    public DataTable getPatientInvestigationText(string TransactionID)
    {

        StringBuilder sb = new StringBuilder();

        //sb.Append(" Select im.Name Investigation,date_format(t.Date,'%d-%b-%Y')Date, ");
        //sb.Append(" ifnull(t.Remarks,'')Remarks from   ");
        //sb.Append(" (Select pli.Date,pli.Time,pli.LabInvestigationIPD_ID,pli.Investigation_Id,epi.Remarks from  ");
        //sb.Append("     patient_labinvestigation_opd  pli inner join ( ");
        //sb.Append("     select * from emr_patient_investigation where TransactionID='" + TransactionID + "' and IsPrint=1) epi ");
        //sb.Append("     on epi.LabInvestigationIPD_ID = pli.LabInvestigationIPD_ID  and epi.Investigation_ID = pli.Investigation_ID Where pli.approved=1");
        //sb.Append(" union all ");
        //sb.Append(" Select pli.Date,pli.Time,pli.LabInvestigationOPD_ID LabInvestigationIPD_ID,pli.Investigation_Id,epi.Remarks from ");
        //sb.Append("     patient_labinvestigation_opd pli inner join ( ");
        //sb.Append("     select * from emr_patient_investigation_opd where TransactionID_IPD='" + TransactionID + "' and IsPrint=1) epi ");
        //sb.Append("     on epi.LabInvestigationOPD_ID = pli.LabInvestigationOPD_ID  and epi.Investigation_ID = pli.Investigation_ID Where pli.approved=1 ");
        //sb.Append(" ) t ");
        //sb.Append(" inner join investigation_master im on im.Investigation_Id=t.Investigation_Id ");
        //sb.Append(" inner join investigation_observationtype iot on iot.Investigation_ID = im.Investigation_Id ");
        //sb.Append(" inner join observationtype_master otm on otm.ObservationType_ID=iot.ObservationType_Id ");
        //sb.Append(" where im.ReportType !=1 order by otm.Name,im.Name,t.Date,t.Time ");


        //sb.Append(" SELECT im.Name Investigation, DATE_FORMAT(t.Date, '%d-%b-%Y') DATE, IFNULL(t.Remarks, '') Remarks FROM (SELECT pli.Date, pli.Time, pli.LabInvestigationOPD_ID LabInvestigationIPD_ID, pli.Investigation_Id, pli.Remarks FROM patient_labinvestigation_opd pli WHERE pli.approved = 1 UNION ALL SELECT pli.Date, pli.Time, pli.LabInvestigationOPD_ID LabInvestigationIPD_ID, pli.Investigation_Id, epi.Remarks FROM patient_labinvestigation_opd pli INNER JOIN  ");

        //sb.Append(" (SELECT * FROM emr_patient_investigation_opd WHERE TransactionID_IPD = '" + TransactionID + "' AND IsPrint = 1) epi ON epi.LabInvestigationOPD_ID = pli.LabInvestigationOPD_ID AND epi.Investigation_ID = pli.Investigation_ID WHERE pli.approved = 1) t INNER JOIN investigation_master im ON im.Investigation_Id = t.Investigation_Id INNER JOIN investigation_observationtype iot ON iot.Investigation_ID = im.Investigation_Id INNER JOIN observationtype_master otm ON otm.ObservationType_ID = iot.ObservationType_Id WHERE im.ReportType != 1 ORDER BY otm.Name, im.Name, t.Date, t.Time  ");


        sb.Append(" SELECT im.Name Investigation,DATE_FORMAT(pli.Date, '%d-%b-%Y') DATE,IFNULL(plt.FindingText, '') Remarks ");
        sb.Append(" FROM patient_labinvestigation_opd pli	   ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id = pli.Investigation_Id ");
        sb.Append(" left join  patient_labobservation_opd_text  plt on  plt.Test_ID=pli.Test_ID ");
        sb.Append(" INNER JOIN investigation_observationtype iot ON iot.Investigation_ID = im.Investigation_Id ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID = iot.ObservationType_Id      ");
        sb.Append(" WHERE im.ReportType != 1 AND pli.approved = 1 AND pli.TransactionID='" + TransactionID + "' ");
        sb.Append(" ORDER BY otm.Name,im.Name,pli.Date,pli.Time ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;

    }

    public DataTable getPatientInvestigationNimeric(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT CONCAT(im.Name) Investigation,REPLACE(t.LabObservationName,'&nbsp;',' ')LabObservationName ,DATE_FORMAT(t.Result_Date,'%d_%m_%y')DATE, ");
        //sb.Append(" concat(t.Result_Date,' ',t.Result_Time)ResultDateTime,GROUP_CONCAT(IFNULL(t.Value,''))VALUE ,t.MinValue,t.MaxValue,im.Investigation_Id,ParentID,t.LabObservation_ID,t.Child_Flag,t.Priorty,Test_ID,lai.Priorty InvPriorty  FROM    ");
        //sb.Append(" (	 ");
        //sb.Append(" SELECT pli.LabInvestigationIPD_ID,pli.Investigation_Id,ploi.Result_Time,ploi.Result_Date,ploi.Value,  ");
        //sb.Append("     ploi.MinValue,ploi.MaxValue,ploi.LabObservationName,ParentID,ploi.LabObservation_ID,Child_Flag,Priorty,ploi.Test_ID FROM patient_labinvestigation_opd  pli  ");
        //sb.Append("     INNER JOIN (SELECT * FROM emr_patient_investigation WHERE TransactionID='" + TransactionID + "' AND IsPrint=1) epi   ");
        //sb.Append("     ON epi.LabInvestigationIPD_ID = pli.LabInvestigationIPD_ID  AND epi.Investigation_ID = pli.Investigation_ID  ");
        //sb.Append("     INNER JOIN patient_labobservation_ipd ploi ON ploi.Test_ID = pli.Test_ID    ");
        //sb.Append("     INNER JOIN labobservation_master lm ON lm.LabObservation_ID = ploi.LabObservation_ID		 ");
        //sb.Append("     WHERE pli.approved=1  ");
        //sb.Append(")t  ");
        //sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=t.Investigation_Id    ");
        //sb.Append(" INNER JOIN investigation_observationtype iot ON iot.Investigation_ID = im.Investigation_Id    ");
        //sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_Id  ");
        //sb.Append(" LEFT JOIN labobservation_investigation lai ON lai.Investigation_Id=t.Investigation_Id  AND lai.labObservation_ID=t.labObservation_ID ");
        //sb.Append(" WHERE im.ReportType =1 GROUP BY t.Investigation_Id,iot.ObservationType_Id,t.Result_Date,priorty ORDER BY im.Name,t.Result_Date,t.Result_Time,priorty   ");

        sb.Append(" SELECT CONCAT(im.Name) Investigation,REPLACE(t.LabObservationName,'&nbsp;',' ')LabObservationName,DATE_FORMAT(t.Result_Date,'%d_%m_%y')DATE, ");
        sb.Append(" concat(t.Result_Date,' ',t.Result_Time)ResultDateTime,GROUP_CONCAT(IFNULL(t.Value,''))VALUE ,t.MinValue,t.MaxValue,im.Investigation_Id,t.ParentID,t.LabObservation_ID,t.Child_Flag,t.Priorty,Test_ID,lai.Priorty InvPriorty  FROM    ");
        sb.Append(" (	 ");
        sb.Append(" SELECT pli.LabInvestigationOPD_ID LabInvestigationIPD_ID,pli.Investigation_Id,TIME(ploi.ResultDateTime) AS Result_Time,DATE(ploi.ResultDateTime) AS Result_Date,ploi.Value,  ");
        sb.Append("     ploi.MinValue,ploi.MaxValue,ploi.LabObservationName,ParentID,ploi.LabObservation_ID,Child_Flag,Priorty,ploi.Test_ID FROM patient_labinvestigation_opd  pli  ");
        //sb.Append("     INNER JOIN (SELECT * FROM emr_patient_investigation WHERE TransactionID='" + TransactionID + "' AND IsPrint=1) epi   ");
        //sb.Append("     ON epi.LabInvestigationIPD_ID = pli.LabInvestigationIPD_ID  AND epi.Investigation_ID = pli.Investigation_ID  ");
        sb.Append("     INNER JOIN patient_labobservation_opd ploi ON ploi.Test_ID = pli.Test_ID    ");
        sb.Append("     INNER JOIN labobservation_master lm ON lm.LabObservation_ID = ploi.LabObservation_ID		 ");
        sb.Append("     WHERE pli.approved=1  AND pli.TransactionID='" + TransactionID + "'  ");
        sb.Append(")t  ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=t.Investigation_Id    ");
        sb.Append(" INNER JOIN investigation_observationtype iot ON iot.Investigation_ID = im.Investigation_Id    ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_Id  ");
        sb.Append(" LEFT JOIN labobservation_investigation lai ON lai.Investigation_Id=t.Investigation_Id  AND lai.labObservation_ID=t.labObservation_ID ");
        sb.Append(" WHERE im.ReportType =1 GROUP BY t.Investigation_Id,iot.ObservationType_Id,t.Result_Date,priorty ORDER BY im.Name,t.Result_Date,t.Result_Time,priorty   ");

        DataTable dtLabOb = StockReports.GetDataTable(sb.ToString());

        DataTable dtMerge = new DataTable();

        ///////////////////

        string Investigations = string.Empty;
        for (int i = 0; i < dtLabOb.Rows.Count; i++)
        {
            if (dtLabOb.Rows[i]["Investigation_ID"].ToString().Length > 2)
                Investigations = Investigations + "'" + dtLabOb.Rows[i]["Investigation_ID"].ToString() + "',";

            if (dtLabOb.Rows[i]["ParentID"].ToString() != "")
            {
                DataRow[] PrExist = dtLabOb.Select("LabObservation_ID='" + dtLabOb.Rows[i]["ParentID"].ToString() + "'");

                if (PrExist.Length <= 0)
                {
                    DataRow row = dtLabOb.NewRow();
                    row.ItemArray = dtLabOb.Rows[i].ItemArray;
                    DataTable dtlb = StockReports.GetDataTable("SELECT lm.*,li.Priorty FROM labobservation_master lm INNER JOIN labobservation_investigation li ON lm.LabObservation_ID = li.labObservation_ID WHERE li.labObservation_ID='" + dtLabOb.Rows[i]["ParentID"].ToString() + "' limit 1");
                    row["LabObservation_ID"] = dtlb.Rows[0]["LabObservation_ID"].ToString();
                    row["LabObservationName"] = dtlb.Rows[0]["NAME"].ToString();
                    row["Child_Flag"] = dtlb.Rows[0]["Child_Flag"].ToString();
                    row["ParentID"] = dtlb.Rows[0]["ParentID"].ToString();
                    row["InvPriorty"] = dtlb.Rows[0]["Priorty"].ToString();
                    row["Priorty"] = dtlb.Rows[0]["Priorty"].ToString();
                    row["VALUE"] = "";
                    row["MinValue"] = "";
                    row["MaxValue"] = "";
                    //row["IsParent"] = "Y";
                    row["Investigation_ID"] = dtLabOb.Rows[i]["Investigation_ID"].ToString();
                    row["Test_ID"] = dtLabOb.Rows[i]["Test_ID"].ToString();
                    // row["TransactionID"] = dtLabOb.Rows[i]["TransactionID"].ToString();

                    DataRow[] PrChild = dtLabOb.Select("ParentID='" + dtLabOb.Rows[i]["ParentID"].ToString() + "'");
                    if (PrChild.Length > 0)
                    {
                        foreach (DataRow dr1 in PrChild)
                        {
                            dr1["InvPriorty"] = dtlb.Rows[0]["Priorty"].ToString();
                        }
                    }

                    dtLabOb.Rows.InsertAt(row, i);
                    dtLabOb.AcceptChanges();
                }
            }
        }
        if (dtLabOb != null && dtLabOb.Rows.Count > 0)
        {
            dtMerge.Columns.Add("Investigation");
            dtMerge.Columns.Add("LabObservationName");
            dtMerge.Columns.Add("DATE");
            dtMerge.Columns.Add("VALUE");

            //Creating each Date Value as a Column in dtMerge
            // DataTable dtCol = dtLabOb.Copy();

            DataView dv = dtLabOb.DefaultView;
            dv.Sort = "ResultDateTime";
            DataTable sortedDT = dv.ToTable();

            foreach (DataRow drSub in sortedDT.Rows)
            {
                if (dtMerge.Columns.Contains(drSub["Date"].ToString().Replace(" ", "").Replace("&", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "")) == false)
                {
                    dtMerge.Columns.Add(drSub["Date"].ToString().Replace(" ", "").Replace("&", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", ""), typeof(string));
                    //dtMerge.Columns[drSub["Date"].ToString().Replace(" ", "").Replace("&", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "")].DataType = System.Type.GetType("System.Decimal");
                }
            }

            foreach (DataRow dr in dtLabOb.Rows)
            {
                DataRow[] RowCreated = dtMerge.Select("Investigation='" + dr["Investigation"].ToString() + "' and LabObservationName='" + dr["LabObservationName"].ToString() + "'");
                if (RowCreated.Length == 0)
                {
                    DataRow[] RowExist = dtLabOb.Select("Investigation='" + dr["Investigation"].ToString() + "' and LabObservationName='" + dr["LabObservationName"].ToString() + "'");
                    if (RowExist.Length > 0)
                    {
                        DataRow row = dtMerge.NewRow();
                        foreach (DataRow NewRow in RowExist)
                        {
                            row["Investigation"] = NewRow["Investigation"].ToString();
                            row["LabObservationName"] = NewRow["LabObservationName"].ToString();
                            row["VALUE"] = NewRow["VALUE"].ToString();
                            //row["ResultDateTime"] = NewRow["ResultDateTime"].ToString();
                            row[NewRow["Date"].ToString().Replace(" ", "").Replace("&", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "")] = Util.GetString((NewRow["VALUE"]));
                        }
                        dtMerge.Rows.Add(row);
                    }
                }
            }
            dtMerge.AcceptChanges();
        }

        return dtMerge;

        // return dtLabOb;
    }



    public DataTable getPatientInvestigationNimericNew(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" select t2.date,group_concat(concat('<b>',t2.Investigation,' :- </b>'),'<br/>',t2.TestName SEPARATOR '<br/><br/>' ) as InvestigationProcedure from  (");

        sb.Append(" SELECT t1.Investigation,t1.date,GROUP_CONCAT(t1.LabObservationName,' - ',t1.VALUE SEPARATOR ', ') AS TestName FROM  (");



        sb.Append(" SELECT CONCAT(im.Name) Investigation,REPLACE(t.LabObservationName,'&nbsp;',' ')LabObservationName,DATE_FORMAT(t.Result_Date,'%d-%b-%Y')DATE, ");
        sb.Append(" concat(t.Result_Date,' ',t.Result_Time)ResultDateTime,GROUP_CONCAT(IFNULL(t.Value,''))VALUE ,t.MinValue,t.MaxValue,im.Investigation_Id,t.ParentID,t.LabObservation_ID,t.Child_Flag,t.Priorty,Test_ID,lai.Priorty InvPriorty  FROM    ");
        sb.Append(" (	 ");
        sb.Append(" SELECT pli.LabInvestigationOPD_ID LabInvestigationIPD_ID,pli.Investigation_Id,TIME(ploi.ResultDateTime) AS Result_Time,DATE(ploi.ResultDateTime) AS Result_Date,ploi.Value,  ");
        sb.Append("     ploi.MinValue,ploi.MaxValue,ploi.LabObservationName,ParentID,ploi.LabObservation_ID,Child_Flag,Priorty,ploi.Test_ID FROM patient_labinvestigation_opd  pli  ");
        //sb.Append("     INNER JOIN (SELECT * FROM emr_patient_investigation WHERE TransactionID='" + TransactionID + "' AND IsPrint=1) epi   ");
        //sb.Append("     ON epi.LabInvestigationIPD_ID = pli.LabInvestigationIPD_ID  AND epi.Investigation_ID = pli.Investigation_ID  ");
        sb.Append("     INNER JOIN patient_labobservation_opd ploi ON ploi.Test_ID = pli.Test_ID    ");
        sb.Append("     INNER JOIN labobservation_master lm ON lm.LabObservation_ID = ploi.LabObservation_ID		 ");
        sb.Append("     WHERE pli.approved=1  AND pli.TransactionID='" + TransactionID + "'  ");
        sb.Append(")t  ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=t.Investigation_Id    ");
        sb.Append(" INNER JOIN investigation_observationtype iot ON iot.Investigation_ID = im.Investigation_Id    ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_Id  ");
        sb.Append(" LEFT JOIN labobservation_investigation lai ON lai.Investigation_Id=t.Investigation_Id  AND lai.labObservation_ID=t.labObservation_ID ");
        sb.Append(" WHERE im.ReportType =1 GROUP BY t.Investigation_Id,iot.ObservationType_Id,t.Result_Date,priorty ORDER BY im.Name,t.Result_Date,t.Result_Time,priorty   ");

        //new grouping code
        sb.Append(" ) t1");
        sb.Append(" GROUP  BY  t1.date,t1.Investigation_Id)t2");
        sb.Append("  GROUP BY t2.date");



        DataTable dtLabOb = StockReports.GetDataTable(sb.ToString());

        return dtLabOb;


    }






    public DataTable getNuclearMedicineInvestigation(string TransactionID)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append(" Select TransactionID,PatientID,Inv_date,Date,Nackscan,Metastasis,Tg,SCalcium,ChestXray from emr_patient_investigation_nuclear where TransactionID='" + TransactionID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public DataTable getconsultant(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT t.DocName,t.DocDegree,t.DocReg,t.DocSpec FROM ");
        sb.Append("( ");
        sb.Append(" SELECT CONCAT('Dr.' ,dm1.Name) AS DocName,dm1.degree DocDegree,dm1.IMARegistartionNo DocReg,dm1.Specialization DocSpec ");
        sb.Append(" FROM patient_medical_history pmh1 INNER JOIN doctor_master dm1 ON dm1.DoctorID=pmh1.DoctorID ");
        sb.Append(" WHERE TransactionID='" + TransactionID + "' ");
        sb.Append(" UNION ALL ");
        sb.Append(" Select CONCAT('Dr.' ,dm2.Name) AS DocName,dm2.degree DocDegree,dm2.IMARegistartionNo DocReg,dm2.Specialization DocSpec ");
        sb.Append(" FROM patient_medical_history pmh2 INNER JOIN  doctor_master dm2 ON dm2.DoctorID=pmh2.DoctorID1 ");
        sb.Append(" WHERE TransactionID='" + TransactionID + "' ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT  CONCAT('Dr.' ,dm3.Name) AS DocName,dm3.degree DocDegree,dm3.IMARegistartionNo DocReg,dm3.Specialization DocSpec ");
        sb.Append(" FROM f_multipledoctor_ipd mpi INNER JOIN doctor_master dm3 ON dm3.DoctorID=mpi.DoctorID ");
        sb.Append(" WHERE TransactionID='" + TransactionID + "' ");
        sb.Append(" UNION ALL  ");
        sb.Append(" SELECT CONCAT('Dr.' ,dm.Name) AS DocName,dm.degree DocDegree,dm.IMARegistartionNo DocReg,dm.Specialization DocSpec  ");
        sb.Append(" FROM emr_patient_doctor pd INNER JOIN doctor_master dm ON dm.DoctorID=pd.doctorID  ");
        sb.Append(" WHERE pd.TransactionId='" + TransactionID + "'  ");
        sb.Append(")t ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return dt;
    }

    public DataTable getOTDetail(string TransactionID)
    {
        string Query = "  SELECT IF(SurgeonName1<>'select',SurgeonName1,'')SurgeonName1,IF(SurgeonName2<>'select',SurgeonName2,'')SurgeonName2, " +
                 "IF(AsstSurgeon1<>'select',AsstSurgeon1,'')AsstSurgeon1,IF(AsstSurgeon2<>'select',AsstSurgeon2,'')AsstSurgeon2, " +
                 "IF(Anesthetist<>'select',Anesthetist,'')Anesthetist,IF(AsstAnesthetist<>'select',AsstAnesthetist,'')AsstAnesthetist, " +
                 "IF(ScrubNurse<>'select',ScrubNurse,'')ScrubNurse,IF(CirculNurse<>'select',CirculNurse,'')CirculNurse,  " +
                 " SurgeryDate,Urgency,SurStartTime,SurFinishTime,PreOperatveDignose,Operation,Incisions1,Incisions2,Findings,Drains,Closure,Sample,Complication, " +
                 " BloodLoss,PostOprDignosis,PostOpInstruction,Ports,Procedures,AnesthesiaType,SurgeryName, " +
                 " (SELECT Degree FROM doctor_master WHERE CONCAT(title,'',NAME)=SurgeonName1)sur1Degree, " +
                 " (SELECT Degree FROM doctor_master WHERE CONCAT(title,'',NAME)=SurgeonName2)sur2Degree, " +
                 " (SELECT Degree FROM doctor_master WHERE CONCAT(title,'',NAME)=Anesthetist)AnaDegree, " +
                 " (SELECT Degree FROM doctor_master WHERE CONCAT(title,'',NAME)=AsstAnesthetist)AssAnaDegree " +
                 " FROM cpoe_OTNotes_DeptofSurgery WHERE TransactionID='" + TransactionID + "' ";

        DataTable dt = StockReports.GetDataTable(Query);
        return dt;
    }
    public string getTags(string Value, string MinRange, string MaxRange)
    {
        string ret_value = Value;
        try
        {
            decimal val;
            bool flag = decimal.TryParse(Value, out val);
            if ((MinRange == "") || (MaxRange == "") || (flag == false))
                ret_value = Value;
            else
            {
                if ((MinRange != "") && (Util.GetDecimal(Value) < Util.GetDecimal(MinRange)))
                {
                    ret_value = "<b>" + ret_value + "</b>";

                }
                else if ((MaxRange != "") && (Util.GetDecimal(Value) > Util.GetDecimal(MaxRange)))
                {
                    ret_value = "<b>" + ret_value + "</b>";

                }

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }




        return ret_value;

    }
    public string getvalue(string Value, string MinRange, string MaxRange)
    {
        string ret_value = "";
        try
        {
            decimal val;

            bool flag = decimal.TryParse(Value, out val);
            if ((MinRange == "") || (MaxRange == "") || (flag == false))
                ret_value = "";
            else
            {
                if (Value == "")
                {
                    ret_value = "";
                }
                else if ((MinRange != "") && (Util.GetDecimal(Value) < Util.GetDecimal(MinRange)))
                {
                    ret_value = "L";

                }
                else if ((MaxRange != "") && (Util.GetDecimal(Value) > Util.GetDecimal(MaxRange)))
                {
                    ret_value = "H";

                }
                else
                {
                    ret_value = "";
                }

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }




        return ret_value;

    }
    public string DisplayReading(string MinValue, string MaxValue, string DispValue)
    {
        if (DispValue.Trim() != "")
            return DispValue;
        else if ((MinValue.Trim() != "") && (MaxValue.Trim() != ""))
            return MinValue.Trim() + "-" + MaxValue.Trim();
        else if (MinValue.Trim() != "")
            return MinValue.Trim();
        else if (MaxValue.Trim() != "")
            return MinValue.Trim();
        else
            return "";

    }
}
