using System;
using System.Data;
using MySql.Data.MySqlClient;
using MW6BarcodeASPNet;
using System.IO;
using System.Drawing;
using System.Globalization;

public partial class Design_Mortuary_MortuaryReceipt : System.Web.UI.Page
{
    MySqlConnection con = new MySqlConnection();
    DataTable dt = new DataTable();
    DataSet ds = new DataSet();
    Bitmap objBitmap;

    protected override void InitializeCulture()
    {
        base.InitializeCulture();
        System.Threading.Thread.CurrentThread.CurrentUICulture = new CultureInfo(Resources.Resource.Lang_Code);
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        lblHeaderText.Text = StockReports.ExecuteScalar("select HeaderText from Receipt_Header WHERE HeaderType='OPD'");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        string Corpse_ID = "";
        string refund = "";
        if (Request.QueryString["Corpse_ID"] != null)
        {
            Corpse_ID = Request.QueryString["Corpse_ID"].ToString();
        }
        if (Request.QueryString["refund"] != null)
        {
            refund = Request.QueryString["refund"].ToString();
        }
        if (refund.ToString() != string.Empty)
        {
            if (refund.ToString() == "1")
            {
                lblrefund.Visible = true;
                lblHeader.Visible = false;
            }
            else
            {
                lblrefund.Visible = false;
                lblHeader.Visible = true;
            }
        }

        if (Session["DataTableReceipt"] != null)
        {
            Session["R_DataTableReceipt"] = ((DataTable)Session["DataTableReceipt"]).Copy();
            Session.Remove("DataTableReceipt");
        }
        dt = (DataTable)Session["R_DataTableReceipt"];

        string str = "SELECT CONCAT(IF(CM.Address='','',CM.Address),IF(CM.Locality='','',CONCAT(',',CM.Locality)),IF(CM.City='','',CONCAT(',',CM.City)))Address,CM.Age,CM.Gender from mortuary_corpse_master CM where CM.Corpse_ID='" + Corpse_ID + "'";
        DataSet ds = MySqlHelper.ExecuteDataset(con, CommandType.Text, str);

        if (ds.Tables[0].Rows.Count > 0)
        {
            LblAgeSex.Text = Util.GetString(ds.Tables[0].Rows[0]["Age"].ToString()) + @" / " + Util.GetString(ds.Tables[0].Rows[0]["Gender"].ToString());
            LblAgeSex.Text = LblAgeSex.Text.ToUpper();
            LblAddress.Text = ds.Tables[0].Rows[0]["Address"].ToString().ToUpper();
            //lblMobile.Text = ds.Tables[0].Rows[0]["Mobile"].ToString();
        }

        OutputImg(dt.Rows[0]["Transaction_ID"].ToString(), dt.Rows[0]["ReceiptNo"].ToString());

        if (dt.Columns.Contains("Image") == false)
        {
            dt.Columns.Add("Image", System.Type.GetType("System.Byte[]"));
        }
        dt.Rows[0]["Image"] = GetBitmapBytes(objBitmap);

        Session["ImageData"] = GetBitmapBytes(objBitmap);

        string str1 = dt.Rows[0]["Corpse_ID"].ToString();

        LblCorpseName.Text = Util.GetString(dt.Rows[0]["Corpse_Name"].ToString());
        if (Util.GetString(dt.Rows[0]["ReceiptNo"].ToString()).Trim() != "")
        {
            //lblrefund.Visible = false;
            //lblHeader.Visible = false;
            //lblHeaderText.Visible = false;
            lblReceipt.Text = "Receipt No.";
            
            LblReceiptNo.Text = Util.GetString(dt.Rows[0]["ReceiptNo"].ToString());
        }
        LblRegNo.Text = Util.GetString(dt.Rows[0]["Corpse_ID"].ToString());

        LblDoctorName.Text = Util.GetString(dt.Rows[0]["Consultant Name"].ToString()).ToUpper();

        if (dt.Columns.Contains("Date") == true && dt.Columns.Contains("Time") == true)
        {
            LblDate.Text = Util.GetString(dt.Rows[0]["Date"].ToString()) + "  " + Util.GetString(dt.Rows[0]["Time"].ToString());
        }
        else
        {
            LblDate.Text = DateTime.Now.ToString("dd-MMM-yyyy") + "  " + DateTime.Now.ToString("hh:mm tt");
        }
        string a = "";
        string b = "";
        if (dt.Rows[0]["Amount"].ToString() != "")
        {
            string qry = "SELECT ConvertCurrency_base(80," + dt.Rows[0]["Amount"].ToString() + ")";
            lblPaymentInCDF.Text += StockReports.ExecuteScalar(qry);
            lblPaymentInCDF.Text = "";
        }

        if ((dt.Rows[0]["Amount"].ToString().Contains("-")))
        {
            b = dt.Rows[0]["Amount"].ToString();
            b = b.Remove(0, 1);

            b = ConvertCurrencyInWord.AmountInWord(Convert.ToDecimal(dt.Rows[0]["Amount"]), "INR");
        }
        else
        {
            a = ConvertCurrencyInWord.AmountInWord(Convert.ToDecimal(dt.Rows[0]["Amount"]), "INR");
        }

        if (dt.Rows[0]["CompanyName"].ToString() == "")
        {
            if (a != "")
            {
                Label11.Text = "Received with thanks from " + LblCorpseName.Text + " (Amount " + a + " Only)";
            }
            else
            {
                Label11.Text = "Refund Of Amount " + b + " Only to  " + LblCorpseName.Text + " with Thanks.";
            }
        }
        else
        {
            if (a != "")
            {

                Label11.Text = "Received with thanks from ";

            }
            else
            {
                Label11.Text = "Refund Of Amount To ";
            }

            if (dt.Rows[0]["CompanyName"].ToString().Trim() == AllGlobalFunction.Panel.ToString())
            {
                Label11.Text = Label11.Text + dt.Rows[0]["Corpse_Name"].ToString();
            }
            else
            {
                Label11.Text = Label11.Text + dt.Rows[0]["CompanyName"].ToString();
            }
            if (a != "")
            {

                Label11.Text = Label11.Text + " (Amount " + a + " Only)";

            }
            else
            {

                Label11.Text = Label11.Text + b + " Only";

            }
        }
        if (a != "")
        {
            lblamount.Text = Util.GetDouble(dt.Rows[0]["Amount"].ToString()).ToString("f2");
            lblNetAmount.Text = Util.GetDouble(dt.Rows[0]["Amount"].ToString()).ToString("f2");
            string AdvDisplay = StockReports.ExecuteScalar("SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber= (SELECT LedgerNoCr FROM mortuary_receipt WHERE ReceiptNo ='" + dt.Rows[0]["ReceiptNo"].ToString() + "')");
            if (AdvDisplay == "ADV-COL")
                AdvDisplay = "ADVANCE";
            lblAdvDisplay.Text = AdvDisplay;
            //lblAdvDisplay.Text = "MORTUARY ADV-COL";
        }
        else
        {
            lblNetAmount.Text = Util.GetDouble(dt.Rows[0]["Amount"].ToString()).ToString("f2").Remove(0, 1);
            lblamount.Text = lblNetAmount.Text;
            lblAdvDisplay.Text = "REFUND AMOUNT";
        }
        //lblPaymentMode.Text = Util.GetString(All_LoadData.receiptpaymentdetail(LblReceiptNo.Text));
        lblPaymentMode.Text = Util.GetString(StockReports.ExecuteScalar("SELECT CAST(GROUP_CONCAT(S_Amount,S_Notation,' ',PaymentMode) AS CHAR)PaymentMode FROM mortuary_receipt_paymentdetail WHERE ReceiptNo='" + LblReceiptNo.Text + "' GROUP BY ReceiptNo"));
        DataTable dtNarration = StockReports.GetDataTable("SELECT ReceivedFrom,Naration FROM mortuary_receipt WHERE ReceiptNo='" + LblReceiptNo.Text + "' ");
        if (dtNarration.Rows.Count > 0)
        {
            lblPaymentInCDF.Text = "Received From " + dtNarration.Rows[0]["ReceivedFrom"].ToString();
            if (dtNarration.Rows[0]["Naration"].ToString() != "")
                lblPaymentInCDF.Text += " Remarks: " + dtNarration.Rows[0]["Naration"].ToString();
        }
        lblfooter.Text = LblDate.Text + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Prepared By : " + dt.Rows[0]["PreparedBy"].ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Printed By : " + Session["LoginName"].ToString();
        LblCrNo.Text = dt.Rows[0]["Transaction_ID"].ToString().Replace("CRSHHI", "");

        if (dt.Columns.Contains("Freezer_No") == true)
        {
            LblBedno.Text = dt.Rows[0]["Freezer_No"].ToString().ToUpper();
        }
        else
        {
            LblBedno.Text = "";
        }

        if (dt.Columns.Contains("Naration") == true && dt.Rows[0]["Naration"].ToString().Trim() != string.Empty)
        {
            lblNaration.Visible = true;
            lblNaration.Text = "Narration : " + dt.Rows[0]["Naration"].ToString();
        }

        if (dt.Columns.Contains("PanelCompany") == true && dt.Rows[0]["PanelCompany"].ToString().Trim() != string.Empty)
        {
            if (dt.Rows[0]["PanelCompany"].ToString() != AllGlobalFunction.Panel)
            {
                lblPanelHead.Text = "Panel ";

                lblPanelName.Text = dt.Rows[0]["PanelCompany"].ToString();
            }
        }
        else
        {
            lblPanelHead.Text = "";
            lblPanelName.Text = "";
        }
        if (Request.QueryString["cmd"] != null && Request.QueryString["cmd"].ToString().ToLower() == "reprint")
            lblHeader.Text += " (Duplicate)";
        //ImageBar.ImageUrl = "Image.aspx";
        Response.Write("<script>");
        Response.Write("window.print();");
        Response.Write("</script>");


        //to display Lable controls on receipt
        if (Request.QueryString["refund"] != null && Request.QueryString["refund"].ToString()=="0")
        {
            if (Request.QueryString["IsAdvance"] != null && Request.QueryString["IsAdvance"].ToString() == "0")
            {
                lblReceived.Visible = true;
                lblChange.Visible = true;
                lblReceivedAmt.Visible = true;
                lblChangeAmt.Visible = true;
                //lblReceivedAmt.Text = dt.Rows[0]["ReceivedAmt"].ToString();
                //lblChangeAmt.Text = dt.Rows[0]["ChangeAmt"].ToString();
            }
        }

        //============== END ===============================       
    }
    private void OutputImg(string Transaction_ID, string ReceiptNo)
    {

        string FontName = "";
        Graphics objGraphics;
        Point p;

        //Response.ContentType = "image/Jpeg";
        Barcode MyBarcode = new Barcode();
        MyBarcode.BackColor = Color.White;
        MyBarcode.BarColor = Color.Black;
        MyBarcode.CheckDigit = true;
        MyBarcode.CheckDigitToText = true;
        MyBarcode.Data = Transaction_ID + "#" + ReceiptNo + "p";
        MyBarcode.BarHeight = 1.0F;
        MyBarcode.NarrowBarWidth = 0.02F;
        MyBarcode.Orientation = MW6BarcodeASPNet.enumOrientation.or0;
        MyBarcode.SymbologyType = MW6BarcodeASPNet.enumSymbologyType.syCode128;
        MyBarcode.ShowText = false;
        MyBarcode.Wide2NarrowRatio = 0.5F;
        FontName = "Verdana, Arial, sans-serif";
        MyBarcode.TextFont = new Font(FontName, 8.0F);
        MyBarcode.SetSize(400, 60);
        objBitmap = new Bitmap(400, 60);
        objGraphics = Graphics.FromImage(objBitmap);
        p = new Point(0, 0);
        MyBarcode.Render(objGraphics, p);
        objGraphics.Flush();
        objBitmap.Save(Server.MapPath(@"~\Design\Barcode\" + Transaction_ID + ".jpeg"));
        //ImageBar.ImageUrl = Server.MapPath(@"~\Design\Barcode\" + Transaction_ID + ".jpeg");
        if (System.IO.File.Exists(Server.MapPath(@"~\Design\Barcode\" + Transaction_ID + ".jpeg")))
        {
            System.IO.File.Delete(Server.MapPath(@"~\Design\Barcode\" + Transaction_ID + ".jpeg"));
        }
    }

    private static byte[] GetBitmapBytes(Bitmap Bitmap1)    //  getting Stream of Bar Code image
    {
        MemoryStream memStream = new MemoryStream();
        byte[] bytes;

        try
        {
            // Save the bitmap to the MemoryStream.
            Bitmap1.Save(memStream, System.Drawing.Imaging.ImageFormat.Jpeg);

            // Create the byte array.
            bytes = new byte[memStream.Length];

            // Rewind.
            memStream.Seek(0, SeekOrigin.Begin);

            // Read the MemoryStream to get the bitmap's bytes.
            memStream.Read(bytes, 0, bytes.Length);

            // Return the byte array.
            return bytes;
        }

        finally
        {
            // Cleanup.
            memStream.Close();
        }
    }
}
