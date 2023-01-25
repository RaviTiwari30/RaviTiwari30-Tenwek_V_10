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

public partial class Design_Mortuary_CommonPrinterOPDThermal : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;
    DataTable dtHeader;
    DataTable dtSettlement;
    //Page Property

    int MarginLeft = 0;
    int MarginRight = 0;
    int PageWidth = 300;  //300
    int BrowserWidth = 200;



    //Header Property
    float HeaderHeight = 250;//240; //220
    int XHeader = 20; //20
    int YHeader = 100;//80; //110
    int HeaderBrowserWidth = 300;

    // BackGround Property
    bool HeaderImage = true;
    bool FooterImage = false;
    bool FooterText = true;
    bool BackGroundImage = true;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 60;
    int XFooter = 20;

    DataRow drcurrent;

    string id = "";
    string name = "";
    int LedgerTransactionNo = 0;
    int IsBill = 0;
    string ReceiptNo = "";
    string divwidth = "250px";
    // string tableclass = "style='width:100%;;font-family:Times New Roman;font-size:8px;";
    string tableclass = "style='width:100%;;font-family:Arial;font-size:8px;";
    int Dublicate = 0;
    string HeaderText = "";
    string Type = "";
    public static string SReportFileName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(Request.QueryString["IsOnlinePrint"]))
        {
            if (Util.GetString(Request.QueryString["Type"]) == "OPD")
            {
                if (Util.GetString(Request.QueryString["LedgerTransactionNo"]) == "undefined" || Util.GetString(Request.QueryString["LedgerTransactionNo"]) == "" || Util.GetInt(Request.QueryString["LedgerTransactionNo"]) == 0)
                {
                    Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
                    return;
                }
            }
            id = Session["ID"].ToString();
            name = Session["LoginName"].ToString();
          //  LedgerTransactionNo = Util.GetInt(Request.QueryString["LedgerTransactionNo"]);
            IsBill = Util.GetInt(Request.QueryString["IsBill"]);
            ReceiptNo = Util.GetString(Request.QueryString["ReceiptNo"]);
            Dublicate = Util.GetInt(Request.QueryString["Duplicate"]);
            Type = Util.GetString(Request.QueryString["Type"]);
        }
        else
        {
           IsBill = Util.GetInt(Common.Decrypt(Request.QueryString["IsBill"]));
            ReceiptNo = Util.GetString(Common.Decrypt(Request.QueryString["ReceiptNo"]));
            Dublicate = Util.GetInt(Common.Decrypt(Request.QueryString["Duplicate"]));
            Type = Util.GetString(Common.Decrypt(Request.QueryString["Type"]));
        }
        if (Dublicate == 0)
            BackGroundImage = false;
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = "RAwtFRQg-IggtJjYl-Nj11dGp0-ZHVkcGR9-cXNkd3Vq-dXZqfX19-fQ==";
        try
        {
            StringBuilder sb = new StringBuilder();
            BindData();
            if (dtObs.Rows.Count == 0)
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong Or May Be No Item On the Bill To Print. Please Refresh Page,Close Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
                return;
            }
            BindHeaderFooter();
            if (Type == "MOR")
            {
                sb.Append("<div style='width:" + divwidth + ";' >");
                // sb.Append("<table class='" + tableclass + "' style=' '>");
                sb.Append("<table class='style='width:100%;font-family:Arial;font-size:4px;' style='font-size:10px; '>");
                sb.Append("<tr style=''>");
                sb.Append("<td style='font-weight:bold;width:70%'>Particulars</td>");
                sb.Append("<td style='font-weight:bold;width:30%;text-align:right'>Amount(KES)</td>");
                sb.Append("</tr>");
                sb.Append("<tr style='border-bottom:1px solid black;'>");
                sb.Append("<td style='border-top:1px solid black;width:100%' colspan='2'></td>");
                sb.Append("</tr>");
                foreach (DataRow dw in dtObs.Rows)
                {
                    sb.Append("<tr>");
                    sb.Append("<td style='width:700px'>" + Util.GetString(dw["LedgerName"]).ToUpper() + "</td>");
                    sb.Append("<td style='width:100px;text-align:right'>" + Util.GetDecimal(dw["AmountPaid"]).ToString("N") + "</td>");
                    sb.Append("</tr>");
                    drcurrent = dtObs.Rows[dtObs.Rows.IndexOf(dw)];
                }
                sb.Append("<table class='style='width:100%;font-family:Arial;font-size:4px;' style='font-size:13px; '>");
                sb.Append("<tr style='border:1px solid black;'>");
                sb.Append("<td style='font-weight:bold;width:700px;text-align:right;'>Total Amount : </td>");
                sb.Append("<td style='font-weight:bold;width:100px;border-bottom:1px solid black;text-align:right;'>" + Util.GetDecimal(dtObs.Rows[0]["AmountPaid"]).ToString("N") + "</td>");
                sb.Append("</tr></table>");
                // sb.Append("<table class='" + tableclass + "'>");
                sb.Append("<table class='style='width:100%;font-family:Times New Roman;font-size:4px;' style='font-size:13px; '>");
                string Settlement = BindSettlement();
                if (Settlement != "")
                {
                    sb.Append("<br/><tr style='border-botton:1px solid black;'>");
                    sb.Append("<td style='font-weight:bold;width:100%'>Payment Mode : " + Settlement + "</td>");
                    sb.Append("</tr>");
                }
                //if (Util.GetDecimal(dtObs.Rows[0]["AmountPaid"]) > 0)
                //{
                //    string amountwords = ConvertCurrencyInWord.AmountInWord(Util.GetDecimal(dtObs.Rows[0]["AmountPaid"]), Resources.Resource.BaseCurrencyNotation);
                //    sb.Append("<tr style='border-botton:1px solid black;'>");
                //    if (Util.GetString(dtObs.Rows[0]["LedgerNoCr"]) == "LSHHI7018")
                //        sb.Append("<td style='font-weight:bold;width:100%'>Refunded an amount of GHS.  " + amountwords + " Only.</td>");
                //    else
                //        sb.Append("<td style='font-weight:bold;width:100%'>Received with thanks an amount of GHS. " + amountwords + " Only.</td>");
                //    sb.Append("</tr>");
                //}
                if (Util.GetString(drcurrent["Naration"]) != "")
                {
                    sb.Append("<tr style='border-botton:1px solid black;'>");
                    sb.Append("<td style='font-weight:bold;width:100%'>Narration : " + drcurrent["Naration"] + "</td>");
                    sb.Append("</tr>");
                }
                if (Util.GetString(drcurrent["ReceivedFrom"]) != "")
                {
                    sb.Append("<tr style='border-botton:1px solid black;'>");
                    sb.Append("<td style='font-weight:bold;width:100%'>Received From : " + drcurrent["ReceivedFrom"] + "</td>");
                    sb.Append("</tr>");
                }
                /* sb.Append("<br/><tr style='border-botton:1px solid black;'>");
                 sb.Append("<td style='font-weight:bold;width:400px'>Prepared By : " + Util.ToTitleCase(Util.GetString(drcurrent["UserName"])) + "</td>");
                 //sb.Append("<td style='font-weight:bold;width:300px;border-top: #000000 1px dashed;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Signature&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
                 sb.Append("</tr>"); */
                sb.Append("</table>");
            }
            
            AddContent(sb.ToString());
            SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
            mergeDocument();
            byte[] pdfBuffer = document.WriteToMemory();
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-Length", pdfBuffer.Length.ToString());
            Response.BinaryWrite(pdfBuffer);
            Array.Clear(pdfBuffer, 0, pdfBuffer.Length);
            //Response.End();
            Response.Flush();
            //HttpContext.Current.Response.End();
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
                document = null;
            }
            if (tempDocument != null)
            {
                tempDocument.Close();
                tempDocument = null;
            }
        }
    }

    void BindData()
    {
         
         if (Type == "MOR")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT rc.TransactionID,pm.PatientID AS Patient_ID,rc.DATE ReceiptDate,rc.Time ReceiptTime, ");
            sb.Append("  pm.CName PatientName, pm.Age,pm.Gender,rc.ReceiptNo ReceiptNo,''Mobile, ");
            sb.Append("  pnl.Company_Name AS PanelName, CONCAT(dm.Title,' ',dm.Name) AS DoctorName,cd.CorpseID AS IPNo, ");
            sb.Append("  pm.Address Address, ");
            sb.Append("  CONCAT(em.Title,' ',em.Name) AS UserName, ");
            sb.Append("  CONCAT(MFM.RackName,'-',MFM.Rack_No,'/',MFM.ShelfNo) BedNo, ");
            sb.Append("  ROUND(rc.AmountPaid,2)AmountPaid,rc.LedgerNoCr,lm.LedgerName LedgerName, ");
            sb.Append("  rc.ReceivedFrom,rc.Naration,cm.ReportHeaderURLThermalprinter, ");
            sb.Append("  cm.ReportFooterURL,cm.CentreID  ");
            sb.Append("  FROM `mortuary_receipt` rc  ");

            sb.Append("  INNER JOIN `mortuary_corpse_master` pm ON pm.Corpse_ID  =rc.Depositor  ");
            sb.Append("  INNER JOIN mortuary_corpse_deposite CD ON pm.Corpse_ID=CD.CorpseID ");
            sb.Append("  INNER JOIN f_panel_master pnl ON pnl.PanelID  = CD.PanelID ");
            sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID=CD.DoctorID  ");
            sb.Append("  INNER JOIN center_master cm ON cm.centreID=rc.centreID  ");
            sb.Append("  INNER JOIN employee_master em ON rc.Reciever=em.employeeID ");
            sb.Append("  INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=rc.LedgerNoCr ");
            sb.Append("  INNER JOIN mortuary_freezer_master mfm ON mfm.RackID=CD.FreezerID ");

            sb.Append("  WHERE rc.IsCancel=0 AND rc.ReceiptNo='"+ReceiptNo+"'  ");
            sb.Append("  GROUP BY  rc.TransactionID    ");
            dtObs = StockReports.GetDataTable(sb.ToString());
        }
         
    }
    void BindHeaderFooter()
    {
        dtHeader = StockReports.GetDataTable("select HeaderText,FooterText from Receipt_Header WHERE HeaderType='OPD' AND CentreID='" + dtObs.Rows[0]["CentreID"].ToString() + "' ");
    }
    private DataTable BindOPDSettlement()
    {
        dtSettlement = StockReports.GetDataTable("SELECT DATE_FORMAT(CONCAT(rec.Date,' ',rec.Time),'%d-%b-%Y & %l:%i %p')ReceiptDate,rec.AmountPaid,Round(rec_pay.Amount,2)Amount, " +
                       "Round(rec_pay.S_Amount,2) AS S_Amount,rec_pay.S_Notation,rec_pay.PaymentMode,rec.ReceiptNo,CONCAT(em.Title,' ',em.Name) CreatedBy FROM f_reciept rec INNER JOIN f_receipt_paymentdetail rec_pay " +
                       "ON rec_pay.ReceiptNo=rec.ReceiptNo INNER JOIN employee_master em ON em.EmployeeID=rec.Reciever WHERE rec.IsCancel=0 AND rec.AsainstLedgerTnxNo=" + LedgerTransactionNo + " GROUP BY rec_pay.ID ORDER BY rec_pay.ID ASC ");
        return dtSettlement;
    }
    private string BindSettlement()
    {
        string paymentmode = All_LoadData.receiptpaymentdetail(Util.GetString(dtObs.Rows[0]["ReceiptNo"]));
        return paymentmode;
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
        if (drcurrent["PatientName"].ToString().Length > 30)
            HeaderHeight = 244;
        page.CreateHeaderCanvas(HeaderHeight);

        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakePatientHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);
         if (Type == "MOR")
        {
            if (Util.GetString(dtObs.Rows[0]["AmountPaid"]).Contains('-'))
                HeaderText = "Mortuary Refund Receipt";
            else
                HeaderText = "Mortuary Receipt";
        }
         
        PdfHtml CenterheaderHtml = new PdfHtml(0, 45, PageWidth, MakeHospitalHeader(HeaderText), null);
        CenterheaderHtml.FitDestWidth = true;
        CenterheaderHtml.FontEmbedding = false;
        CenterheaderHtml.Opacity = 999999;
        CenterheaderHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(CenterheaderHtml);

        //   page.Header.Layout(getPDFImageforbarcode(45, 94, drcurrent["Patient_ID"].ToString()));
        PdfText pdfuhid = new PdfText(67, 106, "" + drcurrent["Patient_ID"].ToString(), new Font("Times New Roman", 8));
        //   page.Header.Layout(pdfuhid);
        if ((Type == "OPD" || Type == "PHY") && !String.IsNullOrEmpty(drcurrent["BillNo"].ToString()))
        {
            //  page.Header.Layout(getPDFImageforbarcode(450, 94, drcurrent["BillNo"].ToString()));
            //  PdfText pdfBill = new PdfText(460, 106, "" + drcurrent["BillNo"].ToString(), new Font("Times New Roman", 8));
            //   page.Header.Layout(pdfBill);
        }
        if (HeaderImage)
        {
            page.Header.Layout(getPDFImageHeader(drcurrent["ReportHeaderURLThermalprinter"].ToString()));
        }
    }

    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
            if (FooterImage)
            {
                page.Footer.Layout(getPDFImageFooter(drcurrent["FooterImage"].ToString()));
            }
            if (FooterText)
            {
                PdfHtml CenterfooterHtml = new PdfHtml(XFooter, 1, PageWidth, MakeHospitalFooter(), null);
                CenterfooterHtml.FitDestWidth = true;
                CenterfooterHtml.FontEmbedding = false;
                CenterfooterHtml.Opacity = 999999;
                CenterfooterHtml.BrowserWidth = HeaderBrowserWidth;
                //    page.Footer.Layout(CenterfooterHtml);
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
        // PdfImage transparentResizedPdfImage = new PdfImage(120, 110, 300, Server.MapPath("~/" + SignImg));
        PdfImage transparentResizedPdfImage = new PdfImage(20, 110, 150, Server.MapPath("~/" + SignImg));
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
        //  PdfImage transparentResizedPdfImage = new PdfImage(30, 10, 100, Server.MapPath("~/Images/" + SignImg));
        PdfImage transparentResizedPdfImage = new PdfImage(20, 10, 200, Server.MapPath("~/Images/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImageHeader(string SignImg, int x, int y, int width)
    {
        //SignImg = "~/Images/ipdns.png";
        PdfImage transparentResizedPdfImage = new PdfImage(x, y, width, Server.MapPath("~/Images/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private string MakePatientHeader()
    {
        StringBuilder Header = new StringBuilder();
         
        if (Type == "MOR")
        {
            //Header.Append("<div style='width:" + divwidth + ";'>");
            //Header.Append("<table class='" + tableclass + "'>"); 
            Header.Append("   <div style='width: " + divwidth + "; '>");
            Header.Append("   <table style='font-size:10px; class='" + tableclass + "'>");
            Header.Append("  <tr>");
            Header.Append("<td style='width:10%;height:25px; font-weight:bold;text-align:left;'> Corpse No.</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'> : </td>");
            Header.Append("<td style='width:40%;text-align:left;'>" + Util.GetString(drcurrent["IPNo"]).ToUpper() + "</td>");
            Header.Append("  </tr>");
            Header.Append("  <tr>");
            Header.Append("<td style='width:10%;font-weight:bold;text-align:left;'>Name</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'> : </td>");
            Header.Append("<td style='width:40%;text-align:left;'>" + Util.GetString(drcurrent["PatientName"]) + "</td>");
            Header.Append("  </tr>");
            Header.Append("  <tr>");
            Header.Append("<td style='width:18%;font-weight:bold;text-align:left;'>Date & Time</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'> : </td>");
            Header.Append("<td style='width:35%;text-align:left;'>" + Util.GetDateTime(drcurrent["ReceiptDate"]).ToString("dd-MMM-yyyy") + " & " + Util.GetDateTime(drcurrent["ReceiptTime"]).ToString("hh:mm tt") + "</td>");
            Header.Append("  </tr>");
            Header.Append("  <tr>");
            Header.Append("<td style='width:10%;font-weight:bold;text-align:left;'>Deposite No.</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'> : </td>");
            Header.Append("<td style='width:35%;text-align:left;'>" + Util.GetString(drcurrent["TransactionID"]).Replace("CRSHHI", "") + "</td>");
            Header.Append("  </tr>");
            Header.Append("  <tr>");
            Header.Append("<td style='width:10%;font-weight:bold;text-align:left;'>Receipt No.</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'> : </td>");
            Header.Append("<td style='width:35%;text-align:left;'>" + Util.GetString(drcurrent["ReceiptNo"]) + "</td>");
            Header.Append("  </tr>");
            Header.Append("  <tr>");
            Header.Append("<td style='width:10%;font-weight:bold;text-align:left;'>Age/Sex</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'> : </td>");
            Header.Append("<td style='width:40%;text-align:left;'>" + Util.GetString(drcurrent["Age"]) + @" / " + Util.GetString(drcurrent["Gender"].ToString()) + "</td>");
            Header.Append("  </tr>");
            Header.Append("  <tr>");
            Header.Append("<td style='width:10%;font-weight:bold;text-align:left;'>Panel</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'> : </td>");
            Header.Append("<td style='width:35%;text-align:left;'>" + Util.ToTitleCase(Util.GetString(drcurrent["PanelName"])) + "</td>");
            Header.Append("</tr>");
            Header.Append("<tr>");
            Header.Append("<td style='width:10%;font-weight:bold;text-align:left;'>	Freezer No.</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'> : </td>");
            Header.Append("<td style='width:40%;text-align:left;'>" + Util.GetString(drcurrent["BedNo"]) + "</td>");
            Header.Append("</tr>");
       
            Header.Append("<tr>");
            Header.Append("<td style='width:10%;font-weight:bold;text-align:left;'>Doctor</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'>:</td>");
            Header.Append("<td style='width:35%;text-align:left;' >" + Util.ToTitleCase(Util.GetString(drcurrent["DoctorName"])) + "</td>");
            Header.Append("</tr>");
            Header.Append("<tr>");
            Header.Append("<td style='width:18%;font-weight:bold;text-align:left;'>Generated By</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'> : </td>");
            Header.Append("<td style='width:35%;text-align:left;vertical-align:top;'>" + Util.ToTitleCase(Util.GetString(drcurrent["UserName"])) + "</td>");
            Header.Append("</tr>");

            Header.Append("<tr>");
            Header.Append("<td style='width:18%;font-weight:bold;text-align:left;'>Address</td>");
            Header.Append("<td style='font-weight:bold;text-align:center;width: 10%;'> : </td>");
            Header.Append("<td style='width:35%;text-align:left;vertical-align:top;'>" + Util.ToTitleCase(Util.GetString(drcurrent["Address"])) + "</td>");
            Header.Append("</tr>");
             
            Header.Append("</table></div>");
        }
         
        return Header.ToString();
    }
    private string MakeHospitalHeader(string HeaderText)
    {

        StringBuilder Header = new StringBuilder();
        //Header.Append("<div style='width:" + divwidth + ";text-align:center;'>" + dtHeader.Rows[0]["HeaderText"].ToString() + "</div> ");
        //Header.Append("<div style='width:" + divwidth + ";text-align:center;font-weight:bold;border:0px solid black;'><u>" + HeaderText + "<u></div> ");
        // Header.Append("<div style='width:" + divwidth + ";text-align:center;font-weight:bold;border:0px solid black;height:32px'> </div> ");        
        Header.Append("        <table border='0' cellpadding='1' cellspacing='1' style='height:50px; width:300px'>");
        Header.Append("	<tbody>");
        Header.Append("		<tr>");
        Header.Append("			<td style='height:5px; ' class='auto-style1'><span style='font-size:14px'><span style='color:rgb(17, 138, 138)'><span style='font-family:calibri'><strong style='text-align: center'></strong></span></span></span></td>");
        Header.Append("		</tr>");
        Header.Append("		<tr>");
        Header.Append("			<td>");
        Header.Append("			<div class='auto-style1'><span style='color:rgb(17, 138, 138)'><span style='font-size:12px'><span style='font-family:calibri; text-align: center;'></span></span></span></div>");
        Header.Append("			</td>");
        Header.Append("		</tr>");
        Header.Append("		<tr>");
        Header.Append("			<td class='auto-style2'><span style='color:rgb(17, 138, 138)'><span style='font-size:12px'><span style='font-family:calibri; text-align: left;'></span></span></span></td>");
        Header.Append("		</tr>");
        Header.Append("		<tr>");
        Header.Append("			<td class='auto-style1'><strong><span style='color:rgb(255, 0, 0)'><span style='font-size:12px'><span style='font-family:calibri; text-align: center;'></span></span></span></strong></td>");
        Header.Append("		</tr>");
        Header.Append("		<tr>");
        Header.Append("			<td class='auto-style1'><strong><span style='color:rgb(17, 138, 138)'><span style='font-size:12px'><span style='font-family:calibri'></span></span></span></strong></td>");
        Header.Append("		</tr>");
        Header.Append("	</tbody>");
        Header.Append("</table><div style='border:1px solid black;'></div> ");
        //Header.Append("<div style='color:1 px solid black;font-size:14px;font-weight:bold;text-align:center;'>Pharmacy Invoice</div>");      
        Header.Append("<div style='color:1 px solid black;font-size:14px;font-weight:bold;text-align:center;'>" + HeaderText + "</div>");
        return Header.ToString();
    }
    private string MakeHospitalFooter()
    {

        StringBuilder Footer = new StringBuilder();
        Footer.Append("<div style='width:" + divwidth + ";text-align:center;'>" + dtHeader.Rows[0]["FooterText"].ToString() + "</div> ");
        return Footer.ToString();
    }
    private void AddContent(string Content)
    {
        //File.AppendAllText("D:\\apollo.txt", Content);
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A5, PdfDocumentMargins.Empty);
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
            //   p.Footer.Layout(pageNumberingText);
            //   p.Footer.Layout(printdatetime);
            //    p.Footer.Layout(printby);
            document.Pages.AddPage(p);
            pageno++;
        }

        tempDocument = new PdfDocument();
    }
}