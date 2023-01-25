using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_Emergency_Report_EmergencyDischargeReport : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtPatientDetails;
    DataTable dtHeader;
    //Page Property

    int MarginLeft = 20;
    int MarginRight = 10;
    int PageWidth = 550;
    int BrowserWidth = 750;



    //Header Property
    float HeaderHeight = 190;//207
    int XHeader = 20;//20
    int YHeader = 80;//80
    int HeaderBrowserWidth = 800;




    // BackGround Property
    bool HeaderImage = true;
    bool FooterImage = false;
    bool FooterText = true;
    bool BackGroundImage = false;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 30;
    int XFooter = 20;

    string id = "";
    string name = "";
    string TID = "";
    string HeaderText = "Discharge Summary";
    string divwidth = "800px";
    string tableclass = "style='width:100%;border-collapse:collapse;font-family:Times New Roman;font-size:12px;";
    ExcuteCMD excuteCMD = new ExcuteCMD();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(Request.QueryString["IsOnlinePrint"]))
        {
            id = Session["ID"].ToString();
            name = Session["LoginName"].ToString();
            TID =  Util.GetString(Request.QueryString["TID"]);
        }
        else
        {
            TID = Util.GetString(Common.Decrypt(Request.QueryString["LedgerTransactionNo"]));
        }
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = "g8vq0tPn‐5c/q4fHi‐8fq7rbOj‐sqO3o7uy‐t6Owsq2y‐sa26urq6";
        try {
            StringBuilder sb = new StringBuilder();
            string con = string.Empty;
            BindData();
            BindHeaderFooter();
            if (dtPatientDetails.Rows.Count == 0)
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
                return;
            }

            DataTable dtOrder = StockReports.GetDataTable("SELECT ID,AccordianName FROM emr_prescriptionview_master cp ORDER BY cp.Order");
            StringBuilder tsb = new StringBuilder();
            DataTable dtDetail = new DataTable();
            tsb = new StringBuilder("SELECT CONCAT(dm.Title,'',dm.Name,' (',dm.Specialization,')') AS 'Doctor Name' ");
            tsb.Append("FROM emergency_prescriptionvisit pv INNER JOIN doctor_master dm ON dm.DoctorID=pv.DoctorID WHERE pv.TransactionID=@transactionID GROUP BY dm.DoctorID ");
            dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
            if (dtDetail.Rows.Count > 0)
                con = AddTableContent(dtDetail, sb, "TREATING DOCTORS");
            for (int i = 0; i < dtOrder.Rows.Count; i++)
            {
                //con = string.Empty;
                if (dtOrder.Rows[i]["ID"].ToString() == "1")
                {
                    tsb = new StringBuilder();
                    tsb.Append("SELECT med.MedicineName AS 'Medicine Name', med.NoOfDays 'Duration', med.NoTimesDay 'Times', med.Remarks Remarks, ");
                    tsb.Append("med.Dose Dose, med.Meal, med.Route,CONCAT(dm.Title,'',dm.Name) As 'Doctor Name',DATE_FORMAT(med.Date,'%d-%b-%Y') 'Prescribe Date' FROM patient_medicine med INNER JOIN doctor_master dm ON dm.DoctorID=med.DoctorID ");
                    tsb.Append("WHERE med.TransactionID =@transactionID  AND med.IsActive = 1 AND med.IsEmergencyData=1 AND med.MedicineName<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
                if (dtOrder.Rows[i]["ID"].ToString() == "2")
                {
                    tsb = new StringBuilder();
                    tsb.Append("SELECT pt.Name 'Test Name',CONCAT(dm.Title,dm.Name) AS 'Doctor Name', DATE_FORMAT(pt.PrescribeDate,'%d-%b-%Y') 'Prescribe Date' FROM patient_test pt ");
                    tsb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=pt.DoctorID ");
                    tsb.Append("WHERE pt.ConfigID = 3 AND pt.IsActive = 1 AND pt.TransactionID =@transactionID AND pt.IsEmergencyData=1 AND pt.Name<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
                if (dtOrder.Rows[i]["ID"].ToString() == "3")
                {
                    tsb = new StringBuilder("SELECT pt.Name 'Procedure Name',CONCAT(dm.Title,dm.Name) AS 'Doctor Name', DATE_FORMAT(pt.PrescribeDate,'%d-%b-%Y') 'Prescribe Date' FROM patient_test pt ");
                    tsb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=pt.DoctorID ");
                    tsb.Append("WHERE pt.ConfigID = 25 AND pt.IsActive = 1 AND pt.TransactionID =@transactionID AND pt.IsEmergencyData=1 AND pt.Name<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
                if (dtOrder.Rows[i]["ID"].ToString() == "4")
                {
                    tsb = new StringBuilder("SELECT cc.ClinicalExaminiation 'Notes',CONCAT(dm.Title,'',dm.Name) 'Doctor Name',DATE_FORMAT(cc.EntryDate,'%d-%b-%Y %l:%i %p') 'Entry Date' FROM emr_hpexam cc ");
                    tsb.Append("INNER JOIN doctor_employee de ON de.Employee_id=cc.EntryBy ");
                    tsb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=de.DoctorID WHERE cc.TransactionID =@transactionID AND cc.ClinicalExaminiation<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
                if (dtOrder.Rows[i]["ID"].ToString() == "5")
                {
                    tsb = new StringBuilder("SELECT cc.CarePlan 'Notes',CONCAT(dm.Title,'',dm.Name) 'Doctor Name',DATE_FORMAT(cc.EntryDate,'%d-%b-%Y %l:%i %p') 'Entry Date'  FROM emr_careplan cc ");
                    tsb.Append("INNER JOIN doctor_employee de ON de.Employee_id=cc.EntryBy ");
                    tsb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=de.DoctorID WHERE cc.TransactionID=@transactionID AND cc.IsActive=1 AND cc.CarePlan<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
                if (dtOrder.Rows[i]["ID"].ToString() == "6")
                {
                    tsb = new StringBuilder("SELECT cc.MainComplaint 'Notes',CONCAT(dm.Title,'',dm.Name) 'Doctor Name',DATE_FORMAT(cc.EntryDate,'%d-%b-%Y %l:%i %p') 'Entry Date' FROM emr_hpexam cc ");
                    tsb.Append("INNER JOIN doctor_employee de ON de.Employee_id=cc.EntryBy ");
                    tsb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=de.DoctorID WHERE cc.TransactionID =@transactionID AND cc.MainComplaint<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
                if (dtOrder.Rows[i]["ID"].ToString() == "7")
                {
                    tsb = new StringBuilder("SELECT cc.VaccinationStatus 'Notes',CONCAT(dm.Title,'',dm.Name) 'Doctor Name',DATE_FORMAT(cc.EntryDate,'%d-%b-%Y %l:%i %p') 'Entry Date'  FROM emr_VaccinationStatus cc ");
                    tsb.Append("INNER JOIN doctor_employee de ON de.Employee_id=cc.EntryBy INNER JOIN doctor_master dm ON dm.DoctorID=de.DoctorID WHERE  cc.TransactionID=@transactionID AND cc.IsActive=1 AND cc.VaccinationStatus<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
                if (dtOrder.Rows[i]["ID"].ToString() == "8")
                {
                    tsb = new StringBuilder("SELECT cc.Allergies 'Notes',CONCAT(dm.Title,'',dm.Name) 'Doctor Name',DATE_FORMAT(cc.EntryDate,'%d-%b-%Y %l:%i %p') 'Entry Date' FROM emr_hpexam cc ");
                    tsb.Append("INNER JOIN doctor_employee de ON de.Employee_id=cc.EntryBy ");
                    tsb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=de.DoctorID WHERE cc.TransactionID =@transactionID AND cc.Allergies<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
                if (dtOrder.Rows[i]["ID"].ToString() == "9")
                {
                    tsb = new StringBuilder("SELECT cc.Medications 'Notes',CONCAT(dm.Title,'',dm.Name) 'Doctor Name',DATE_FORMAT(cc.EntryDate,'%d-%b-%Y %l:%i %p') 'Entry Date' FROM emr_hpexam cc ");
                    tsb.Append("INNER JOIN doctor_employee de ON de.Employee_id=cc.EntryBy ");
                    tsb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=de.DoctorID WHERE cc.TransactionID =@transactionID AND cc.Medications<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
                if (dtOrder.Rows[i]["ID"].ToString() == "10")
                {
                    tsb = new StringBuilder("SELECT cc.ProgressionComplaint 'Notes',CONCAT(dm.Title,'',dm.Name) 'Doctor Name',DATE_FORMAT(cc.EntryDate,'%d-%b-%Y %l:%i %p') 'Entry Date' FROM emr_hpexam cc ");
                    tsb.Append("INNER JOIN doctor_employee de ON de.Employee_id=cc.EntryBy ");
                    tsb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=de.DoctorID WHERE cc.TransactionID =@transactionID AND cc.ProgressionComplaint<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
                if (dtOrder.Rows[i]["ID"].ToString() == "12")
                {
                    tsb = new StringBuilder("SELECT cp.ProvisionalDiagnosis,CONCAT(dm.Title,'',dm.Name) 'Doctor Name',DATE_FORMAT(cp.CreatedDate,'%d-%b-%Y %l:%i %p') 'Entry Date'  ");
                    tsb.Append("FROM emr_PatientDiagnosis cp INNER JOIN doctor_employee de ON de.Employee_id=cp.CreatedBy INNER JOIN doctor_master dm ON dm.DoctorID=de.DoctorID ");
                    tsb.Append("WHERE cp.TransactionID =@transactionID AND cp.ProvisionalDiagnosis<>'' ");
                    dtDetail = excuteCMD.GetDataTable(tsb.ToString(), CommandType.Text, new { transactionID = TID });
                    if (dtDetail.Rows.Count > 0)
                        con = AddTableContent(dtDetail, sb, dtOrder.Rows[i]["AccordianName"].ToString());
                }
            }
            AddContent(con);
            SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
            mergeDocument();
            byte[] pdfBuffer = document.WriteToMemory();
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            HttpContext.Current.Response.BinaryWrite(pdfBuffer);
            HttpContext.Current.Response.Flush();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
            return;
        }
        finally
        {
            if (document != null)
            {
                document.Close();

            }
            if (tempDocument != null)
            {
                tempDocument.Close();
            }
        }
    }
    private string AddTableContent(DataTable dtData, StringBuilder sb, string AccordianName)
    {
        if (dtData.Rows.Count > 0)
        {
            sb.Append("<div style='width:" + divwidth + ";text-align:left;'> ");
            sb.Append("<br/><div style='width:" + divwidth + ";text-align:left;font-family:verdana,geneva,sans-serif;font-size:16px;font-weight:bold;'>" + AccordianName + " :</div> ");
            sb.Append(" <table style='border:1px solid; width:100%;font-family:verdana,geneva,sans-serif' rules='all'><tbody> ");
            DataRow drHeader = dtData.Rows[0];
            sb.Append("<tr style='background-color:#cccccc;font-size:16px;font-weight:bold;'> ");
            sb.Append("<td style='text-align:center;'>S.No.</td>");
            for (int i = 0; i < dtData.Columns.Count; i++)
            {
                sb.Append("<td style='text-align:center;'>" + dtData.Columns[i].ColumnName.ToString().ToUpper() + "</td>");

            }
            sb.Append(" </tr> ");
            int j = 0;
            foreach (DataRow dr in dtData.Rows)
            {
                j++;
               // drcurrent = dr;
                sb.Append("<tr style='font-size:14px;'> ");
                sb.Append("<td  style='text-align:center;'>" + j + "</td>");
                foreach (DataColumn dc in dtData.Columns)
                {
                    sb.Append("<td style='text-align:center;'>" + dtData.Rows[dtData.Rows.IndexOf(dr)][dtData.Columns.IndexOf(dc)].ToString() + "</td>");

                }
                sb.Append(" </tr> ");

            }
            sb.Append(" </tbody></table></div> ");
        }
        return sb.ToString();
    }
    private void AddContent(string Content)
    {
        //File.AppendAllText("F:\\apollo.txt", Content);
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty);
        PdfHtml html1 = new PdfHtml();
        html1 = new PdfHtml(MarginLeft, ((html1LayoutInfo == null) ? 0 : html1LayoutInfo.LastPageRectangle.Height), PageWidth, Content, null);
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);

        html1.FontEmbedding = false;
        html1.BrowserWidth = BrowserWidth;

        html1.ImagesCutAllowed = false;
        html1LayoutInfo = page1.Layout(html1);
        
    }

    private void mergeDocument()
    {
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {
            System.Drawing.Font pageNumberingFont = new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);

            PdfText pageNumberingText = new PdfText(530, FooterHeight, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;

            PdfText printdatetime = new PdfText(22, FooterHeight, "Printed on " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
            printdatetime.ForeColor = System.Drawing.Color.Black;
            PdfText printby = new PdfText();
            if (name != "")
            {
                printby = new PdfText(250, FooterHeight, "Printed By : " + name, pageNumberingFont);
                printby.ForeColor = System.Drawing.Color.Black;
            }
            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);

            }
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            p.Footer.Layout(printby);
            document.Pages.AddPage(p);
            pageno++;
        }

        tempDocument = new PdfDocument();
    }
    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;
        //set background iamge in pdf report.
        if (BackGroundImage == true)
        {
            HeaderImg = "Images/Duplicate_watermark.gif";
            page1.Layout(getPDFBackGround(HeaderImg));
        }
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);
    }
    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakePatientHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);
       
        PdfHtml CenterheaderHtml = new PdfHtml(20, 3, PageWidth, MakeHospitalHeader(HeaderText), null);
        CenterheaderHtml.FitDestWidth = true;
        CenterheaderHtml.FontEmbedding = false;
        CenterheaderHtml.Opacity = 999999;
        CenterheaderHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(CenterheaderHtml);

        page.Header.Layout(getPDFImageforbarcode(420, 155, dtPatientDetails.Rows[0]["PatientID"].ToString()));
        //PdfText pdfuhid = new PdfText(67, 92, "" + dtPatientDetails.Rows[0]["PatientID"].ToString(), new Font("Times New Roman", 8));
        //page.Header.Layout(pdfuhid);
        if (HeaderImage)
        {
            page.Header.Layout(getPDFImageHeader(dtPatientDetails.Rows[0]["ReportHeaderURL"].ToString()));
        }
    }

    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
            if (FooterImage)
            {
                page.Footer.Layout(getPDFImageFooter(dtPatientDetails.Rows[0]["FooterImage"].ToString()));
            }
            if (FooterText)
            {
                PdfHtml CenterfooterHtml = new PdfHtml(XFooter, 1, PageWidth, MakeHospitalFooter(), null);
                CenterfooterHtml.FitDestWidth = true;
                CenterfooterHtml.FontEmbedding = false;
                CenterfooterHtml.Opacity = 999999;
                CenterfooterHtml.BrowserWidth = HeaderBrowserWidth;
                page.Footer.Layout(CenterfooterHtml);
            }
        }
    }
    private PdfImage getPDFImageforbarcode(float X, float Y, string PatientID)
    {
        string image = "";
        image = new BarcodeImg().Save(PatientID).Trim();
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, 100, Base64StringToImage(image));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }

    public System.Drawing.Image Base64StringToImage(string base64String)
    {
        byte[] imageBytes = Convert.FromBase64String(base64String.Replace("data:image/png;base64,", ""));
        MemoryStream memStream = new MemoryStream(imageBytes, 0, imageBytes.Length);

        memStream.Write(imageBytes, 0, imageBytes.Length);
        System.Drawing.Image image = System.Drawing.Image.FromStream(memStream);
        Bitmap newImage = new Bitmap(240, 30);
        using (Graphics graphics = Graphics.FromImage(newImage))
            graphics.DrawImage(image, 0, 0, 240, 30);
        return newImage;
    }

    private PdfImage getPDFBackGround(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(120, 110, 300, Server.MapPath("~/" + SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = false;
        transparentResizedPdfImage.Opacity = 40;
        //transparentResizedPdfImage.AlphaBlending = true;
        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private PdfImage getPDFImageFooter(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(20, 0, Server.MapPath(SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
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
    void BindData()
    {
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append("SELECT CONCAT(pm.Title, '', pm.PName) PatientName, pm.PatientID, ");
        sqlCMD.Append("CONCAT(pm.Age, '/', pm.Gender) `Gender`, pnl.Company_Name, DATE_FORMAT(ap.EnteredOn, '%d-%b-%Y %l:%i %p') AdmittedDate, ");
        sqlCMD.Append("DATE_FORMAT(ap.ReleasedDateTime, '%d-%b-%Y  %l:%i %p') DischargeDate, 'Emergency' `VisitType`,  ");
        sqlCMD.Append("pm.Mobile,pmh.CentreID,cm.ReportHeaderURL,ap.EmergencyNo,pmh.DischargeType, ");
        sqlCMD.Append("CONCAT(IF(pm.House_No<>'',CONCAT(pm.House_No,','),''),IF(pm.City<>'',CONCAT(pm.City,','),''),IF(pm.District<>'',CONCAT(pm.District,','),''),IF(pm.Country<>'',pm.Country,''))Address ");
        sqlCMD.Append("FROM Emergency_Patient_Details ap  ");
        sqlCMD.Append("INNER JOIN patient_master pm ON pm.PatientID = ap.PatientId  ");
        sqlCMD.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID = ap.TransactionId   ");
        sqlCMD.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID  INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
        sqlCMD.Append("WHERE ap.TransactionId = @transactionID ");
        dtPatientDetails = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = TID
        });
    }
    void BindHeaderFooter()
    {
        dtHeader = StockReports.GetDataTable("select HeaderText,FooterText from Receipt_Header WHERE HeaderType='OPD' AND CentreID='" + dtPatientDetails.Rows[0]["CentreID"].ToString() + "' ");
    }
    private string MakeHospitalHeader(string HeaderText)
    {

        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:" + divwidth + ";text-align:center;'>" + dtHeader.Rows[0]["HeaderText"].ToString() + "</div> ");
        //Header.Append("<div style='width:" + divwidth + ";text-align:center;font-weight:bold;border:1px solid black;'>" + HeaderText + "</div> ");
        //Header.Append("<div style='width:" + divwidth + ";text-align:center;font-weight:bold;border:1px solid black;height:32px'>" + HeaderText + "</div> ");
        return Header.ToString();
    }
    private string MakeHospitalFooter()
    {

        StringBuilder Footer = new StringBuilder();
        Footer.Append("<div style='width:" + divwidth + ";text-align:center;'>" + dtHeader.Rows[0]["FooterText"].ToString() + "</div> ");
        return Footer.ToString();
    }
    private string MakePatientHeader()
    {
        StringBuilder Header = new StringBuilder();

        Header.Append("<div style='width:" + divwidth + ";border:1px solid black;'>");
        Header.Append("<table class='" + tableclass + "'>");
        Header.Append("<tr>");
        Header.Append("<td style='width:15%;font-weight:bold;text-align:left;'>UHID</td>");
        Header.Append("<td style='font-weight:bold;text-align:center;'> : </td>");
        Header.Append("<td style='width:40%;text-align:left;'>" + Util.GetString(dtPatientDetails.Rows[0]["PatientID"]) + "</td>");
        Header.Append("<td style='width:18%;font-weight:bold;text-align:left;'>Admission Date</td>");
        Header.Append("<td style='font-weight:bold;text-align:center;'> : </td>");
        Header.Append("<td style='width:35%;text-align:left;'>" + Util.GetDateTime(dtPatientDetails.Rows[0]["AdmittedDate"]) + "</td>");
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='width:15%;font-weight:bold;text-align:left;'>Name</td>");
        Header.Append("<td style='font-weight:bold;text-align:center;'> : </td>");
        Header.Append("<td style='width:40%;text-align:left;'>" + Util.GetString(dtPatientDetails.Rows[0]["PatientName"]) + "</td>");
        Header.Append("<td style='width:18%;font-weight:bold;text-align:left;'>Discharge Date</td>");
        Header.Append("<td style='font-weight:bold;text-align:center;'> : </td>");
        Header.Append("<td style='width:35%;text-align:left;'>" + Util.GetString(dtPatientDetails.Rows[0]["DischargeDate"]) + "</td>");
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='width:15%;font-weight:bold;text-align:left;'>Age/Sex</td>");
        Header.Append("<td style='font-weight:bold;text-align:center;'> : </td>");
        Header.Append("<td style='width:40%;text-align:left;'>" + Util.GetString(dtPatientDetails.Rows[0]["Gender"]) + "</td>");
        Header.Append("<td style='width:18%;font-weight:bold;text-align:left;'>Panel</td>");
        Header.Append("<td style='font-weight:bold;text-align:center;'> : </td>");
        Header.Append("<td style='width:35%;text-align:left;'>" + Util.GetString(dtPatientDetails.Rows[0]["Company_Name"]) + "</td>");
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='width:15%;font-weight:bold;text-align:left;'>Contact No.</td>");
        Header.Append("<td style='font-weight:bold;text-align:center;'> : </td>");
        Header.Append("<td style='width:40%;text-align:left;'>" + Util.GetString(dtPatientDetails.Rows[0]["Mobile"]) + "</td>");
        Header.Append("<td style='width:18%;font-weight:bold;text-align:left;'>Emergency No.</td>");
        Header.Append("<td style='font-weight:bold;text-align:center;'> : </td>");
        Header.Append("<td style='width:35%;text-align:left;vertical-align:top' >" + dtPatientDetails.Rows[0]["EmergencyNo"].ToString() + "</td>");
        Header.Append("</tr>");

        Header.Append("<tr>");
        Header.Append("<td style='width:15%;font-weight:bold;text-align:left;'>Address</td>");
        Header.Append("<td style='font-weight:bold;text-align:center;'> : </td>");
        Header.Append("<td style='width:40%;text-align:left;vertical-align:top' colspan='3'>" + Util.ToTitleCase(Util.GetString(dtPatientDetails.Rows[0]["Address"])) + "</td>");
        Header.Append("<td style='width:18%;font-weight:bold;text-align:left;'></td>");
        Header.Append("<td style='font-weight:bold;text-align:center;'> </td>");
        Header.Append("<td style='width:35%;text-align:left;'></td>");
        Header.Append("</tr>");
        Header.Append("</table></div><div style='width:" + divwidth + ";text-align:center;font-family:verdana,geneva,sans-serif;font-size:16px;font-weight:bold;'>" + HeaderText +" "+ dtPatientDetails.Rows[0]["DischargeType"].ToString() + "</div>");

        return Header.ToString();
    }
}