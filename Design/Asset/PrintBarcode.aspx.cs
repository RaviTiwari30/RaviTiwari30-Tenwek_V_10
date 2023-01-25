using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;
using MW6BarcodeASPNet;

public partial class Design_Asset_PrintBarcode : System.Web.UI.Page
{
    private Bitmap objBitmap;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    //[WebMethod(EnableSession=true)]
    //public static string PrintBarcode(string AssetIDs)
    //{
    //    StringBuilder sb = new StringBuilder();
    //    sb.Append("SELECT DATE_FORMAT(st.PurchaseDate,'%d-%b-%Y')PurchaseDate,st.LedgerTransactionNo AS GRNNo,st.InvoiceNo,lm.LedgerName AS SupplierName,st.ItemName, ");
    //    sb.Append("mm.Name AS ManufacturerName,st.BatchNumber,am.ModelNo,am.SerialNo,am.AssetNo, ");
    //    sb.Append("am.ID AS AssetID,st.ItemID,st.ID AS StockID ");
    //    sb.Append("FROM eq_Asset_stock st  ");
    //    sb.Append("INNER JOIN eq_asset_master am ON am.ID=st.AssetID ");
    //    sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber= st.VenLedgerNo AND lm.groupid='VEN' ");
    //    sb.Append("INNER JOIN f_itemmaster im ON im.itemID= st.ItemID ");
    //    sb.Append("INNER JOIN f_manufacture_master mm ON mm.ManufactureID= im.ManufactureID ");
    //    sb.Append("WHERE am.ID in (" + AssetIDs + ") ");
    //    DataTable dt = StockReports.GetDataTable(sb.ToString());
    //    if (dt.Rows.Count > 0)
    //    {
    //        DataSet ds = new DataSet();
    //        ds.Tables.Add(dt.Copy());
    //        ds.WriteXmlSchema(@"D:\PrintAssetBarcode.xml");
    //        DataColumn dc = new DataColumn();
    //        dc.ColumnName = "PrintBy";
    //        dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
    //        dt.Columns.Add(dc);

    //        // asset barcode----
    //        dt.Columns.Add("BarCode", System.Type.GetType("System.Byte[]"));
    //        for (int i = 0; i < dt.Rows.Count; i++)
    //        {
    //           var aa= OutputImg(dt.Rows[i]["AssetNo"].ToString());

    //           dt.Rows[0]["BarCode"] = GetBitmapBytes(objBitmap);
    //        }
    //        //-----------
    //        HttpContext.Current.Session["ds"] = ds;
    //        HttpContext.Current.Session["ReportName"] = "PrintAssetBarcode";
    //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
    //    }
    //    else
    //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "No Record Found" });
    //}


    public string OutputImg(string PatientID)
    {
        string FontName = "";
        Graphics objGraphics;
        Point p;

        //Response.ContentType = "image/Jpeg";
        Barcode MyBarcode = new Barcode();
        MyBarcode.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFF");
        MyBarcode.BarColor = Color.Black;
        MyBarcode.CheckDigit = true;
        MyBarcode.CheckDigitToText = true;
        MyBarcode.Data = PatientID;
        MyBarcode.BarHeight = 1.0F;
        MyBarcode.NarrowBarWidth = 0.02F;
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

        if (System.IO.File.Exists(Server.MapPath(@"~\Design\2.jpeg")))
        {
            System.IO.File.Delete(Server.MapPath(@"~\Design\2.jpeg"));
        }
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(st.PurchaseDate,'%d-%b-%Y')PurchaseDate,(Select BillNo from f_ledgerTransaction where LedgerTransactionNo = st.LedgerTransactionNo Limit 1) AS GRNNo,st.InvoiceNo,lm.LedgerName AS SupplierName,st.ItemName, ");
        sb.Append("mm.Name AS ManufacturerName,st.BatchNumber,am.ModelNo,am.SerialNo,am.AssetNo, ");
        sb.Append("am.ID AS AssetID,st.ItemID,st.ID AS StockID ");
        sb.Append("FROM eq_Asset_stock st  ");
        sb.Append("INNER JOIN eq_asset_master am ON am.ID=st.AssetID ");
        sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber= st.VenLedgerNo AND lm.groupid='VEN' ");
        sb.Append("INNER JOIN f_itemmaster im ON im.itemID= st.ItemID ");
        sb.Append("INNER JOIN f_manufacture_master mm ON mm.ManufactureID= im.ManufactureID ");
        sb.Append("WHERE am.ID in (" + lblAssetID.Text + ") ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
           
            DataColumn dc = new DataColumn();
            dc.ColumnName = "PrintBy";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);

            // asset barcode----
            dt.Columns.Add("BarCode", System.Type.GetType("System.Byte[]"));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                var aa = OutputImg(dt.Rows[i]["AssetNo"].ToString());

                dt.Rows[i]["BarCode"] = GetBitmapBytes(objBitmap);
            }
            ds.Tables.Add(dt.Copy());
       //     ds.WriteXmlSchema(@"D:\PrintAssetBarcode.xml");

            //-----------
            Session["ds"] = ds;
            Session["ReportName"] = "PrintAssetBarcode";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key15", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
    }
}