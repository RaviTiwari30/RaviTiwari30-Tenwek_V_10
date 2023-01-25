using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using AjaxControlToolkit;

using System.Collections.Generic;
using MySql.Data.MySqlClient;

using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;
using MW6BarcodeASPNet;
using System.Web;

public partial class Design_CSSD_BatchProcessComplete : System.Web.UI.Page
{
    [WebMethod]
    public static string getdate(string BatchNo, DateTime FrmDate, DateTime ToDate)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("      SELECT DATE_FORMAT(startDate,'%d-%b-%Y')ApproxStartDate,DATE_FORMAT(startDate,'%h:%i %p')ApproxStartTime, ");
        sb.Append("  DATE_FORMAT(EndDate,'%d-%b-%Y')ApproxEndDate,DATE_FORMAT(EndDate,'%h:%i %p')ApproxEndTime,SetID FROM  ");
        sb.Append("  cssd_f_batch_tnxdetails where BatchNo='" + BatchNo + "' and IsProcess=1  limit 1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        CalendarExtender cal = new CalendarExtender();
        cal.StartDate = FrmDate;

        CalendarExtender cal1 = new CalendarExtender();
        cal1.StartDate = ToDate;
        return rtrn;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtPLFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtPLToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");


            txtFromTime.Text = System.DateTime.Now.ToString("hh:mm tt");
            txtToTime.Text = "11:59 PM";
        }
        FrmDate.Attributes.Add("readOnly", "true");
        ToDate.Attributes.Add("readOnly", "true");

        txtPLFromDate.Attributes.Add("readOnly", "true");
        txtPLToDate.Attributes.Add("readOnly", "true");


    }
    [WebMethod(EnableSession = true)]
    public static string saveBatchFinalize(string batchNo, string aStartDate, string aEndTime, string remarks)
    {
        try
        {

            //string sqlCommand = "update cssd_f_batch_tnxdetails bt set bt.AstartDate =@startDate,bt.AEndDate =@endDate,bt.RemarkSec=@remark,bt.IsProcess=2,bt.validityDate=(SELECT DATE((@endDate + INTERVAL sm.validityDays DAY)) FROM cssd_f_set_master sm WHERE sm.`Set_ID`=bt.SetID) WHERE bt.BatchNo =@batchNo and bt.IsProcess=1 ";
            string sqlCommand = "UPDATE cssd_f_batch_tnxdetails bt ";
            sqlCommand += " INNER JOIN cssd_recieve_Set_stock cst ON cst.`ID`=bt.`SetTnxID` ";
            sqlCommand += "SET bt.AstartDate =@startDate,bt.AEndDate =@endDate,bt.RemarkSec=@remark,bt.IsProcess=2, ";
            sqlCommand += "bt.validityDate=(SELECT DATE((@endDate + INTERVAL sm.validityDays DAY)) FROM cssd_f_set_master sm WHERE sm.`Set_ID`=bt.SetID)  ";
            sqlCommand += ",cst.IsUpdateBatch=1 ";
            sqlCommand += "WHERE bt.BatchNo =@batchNo AND bt.IsProcess=1 ";

            ExcuteCMD cmd = new ExcuteCMD();
            cmd.DML(sqlCommand, CommandType.Text, new
            {
                startDate = Util.GetDateTime(aStartDate).ToString("yyyy-MM-dd HH:mm:ss"),
                endDate = Util.GetDateTime(aEndTime).ToString("yyyy-MM-dd HH:mm:ss"),
                remark = remarks,
                batchNo = batchNo
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Batch Finalized Successfully." });
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });


        }


    }






    [WebMethod(EnableSession = true)]
    public static string BindBatchDataToPrint(string FromDate, string ToDate, int IsCurrent)
    {
        DataTable dt = new DataTable();

        StringBuilder sb = new StringBuilder();
        string startDate = "";
        string endDate = "";

        if (IsCurrent == 0)
        {
            startDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
            endDate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");

        }
        else
        {
            startDate = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
            endDate = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        }


        sb.Append("  SELECT  ct.`IsPrint`, ct.`SetName`,ct.`BatchNo`,  ");
        sb.Append("  DATE_FORMAT(ct.`AEndDate`,'%d-%b-%Y %I:%i %p')SerealizedDate,  ");
        sb.Append("  DATE_FORMAT(ct.`validityDate`,'%d-%b-%Y')ExpiryDate ");
        sb.Append("  FROM cssd_f_batch_tnxdetails  ct  ");
        sb.Append("  WHERE ct.`IsProcess`=2  ");
        sb.Append("  AND Date(ct.`AEndDate`)>='" + startDate + "'  AND Date(ct.`AEndDate`)<='" + endDate + "'   ");
        sb.Append("  GROUP BY ct.`BatchNo` ");
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "No Record Found." });
        }
    }



    [WebMethod(EnableSession = true)]
    public static string PrintLabel(string BatchNo, string SetName, string SerealizedDate, string ExpiryDate)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StockReports.ExecuteDML("Drop table if exists Temp_Tenwek_LablePrint");
            string str = "CREATE TABLE  Temp_Tenwek_LablePrint (id int auto_increment Primary key,SetName varchar(500),BatchNo varchar(500),SerealizedDate varchar(500) DEFAULT NULL,ExpiryDate varchar(500) DEFAULT NULL)";
            StockReports.ExecuteDML(str);


            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO  Temp_Tenwek_LablePrint ");
            sb.Append(" (SetName,BatchNo,SerealizedDate,ExpiryDate) ");
            sb.Append(" VALUES (@SetName,@BatchNo,@SerealizedDate,@ExpiryDate)");
            int T = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                SetName = SetName,
                BatchNo = BatchNo,
                SerealizedDate = SerealizedDate,
                ExpiryDate = ExpiryDate
            });

            StringBuilder sbUpd = new StringBuilder();

            sbUpd.Append("update cssd_f_batch_tnxdetails set IsPrint=1 where BatchNo=@BatchNo");

            int IsUpdate = excuteCMD.DML(tnx, sbUpd.ToString(), CommandType.Text, new
            {
                BatchNo = BatchNo,

            });

            tnx.Commit();

            StringBuilder sb1 = new StringBuilder();
            sb1.Append("SELECT * FROM Temp_Tenwek_LablePrint");
            DataTable dt = StockReports.GetDataTable(sb1.ToString());

            DataSet ds = new DataSet();
            DataColumn dc = new DataColumn();
            dc.ColumnName = "PrintBy";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            // asset barcode----
            dt.Columns.Add("BarCode", System.Type.GetType("System.Byte[]"));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                var aa = OutputImg(Util.GetDateTime(ExpiryDate).ToString("ddMMyyyy"));

                dt.Rows[i]["BarCode"] = GetBitmapBytes(objBitmap);
            }
            ds.Tables.Add(dt.Copy());
            //  ds.WriteXmlSchema(@"E:\CSSDLabelToPrints.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "CSSDLabelToPrint";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = "../common/Commonreport.aspx" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "Error Occured While Print Label." });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    private static Bitmap objBitmap;


    public static string OutputImg(string ExpDate)
    {
        string FontName = "";
        Graphics objGraphics;
        Point p;

        //Response.ContentType = "image/Jpeg";
        Barcode MyBarcode = new Barcode();
        MyBarcode.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFF");
        MyBarcode.BarColor = Color.Black;
        MyBarcode.CheckDigit = false;
        MyBarcode.CheckDigitToText = false;
        MyBarcode.Data = ExpDate;
        MyBarcode.BarHeight = 1.0F;

        MyBarcode.NarrowBarWidth = 0.04F;
        MyBarcode.Orientation = MW6BarcodeASPNet.enumOrientation.or0;
        MyBarcode.SymbologyType = MW6BarcodeASPNet.enumSymbologyType.syCode128;
        MyBarcode.ShowText = false;
        MyBarcode.Wide2NarrowRatio = 0.5F;
        FontName = "Verdana, Arial, sans-serif";
        MyBarcode.TextFont = new Font(FontName, 8.0F);
        MyBarcode.SetSize(160, 30);
        objBitmap = new Bitmap(160, 30);
        objGraphics = Graphics.FromImage(objBitmap);
        p = new Point(0, 0);
        MyBarcode.Render(objGraphics, p);
        objGraphics.Flush();

        return "";
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
            memStream.Dispose();
        }
    }




}