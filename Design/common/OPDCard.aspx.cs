using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Text;
using MW6BarcodeASPNet;
using System.Drawing.Drawing2D;
using System.IO;

public partial class Design_common_OPDCard : System.Web.UI.Page
{

    protected override void InitializeCulture()
    {
        base.InitializeCulture();
        System.Threading.Thread.CurrentThread.CurrentUICulture = new CultureInfo(Resources.Resource.Lang_Code);
    }
    private Bitmap objBitmap;
    protected void Page_Load(object sender, EventArgs e)
    {
        //lblHeaderText.Text = StockReports.ExecuteScalar("select HeaderText from Receipt_Header WHERE HeaderType='OPD'");

        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }
       
        
            string LedgerTransactionNo = Util.GetString(Request.QueryString["LedgerTransactionNo"]);
            int LedgerTnxID = Util.GetInt(Request.QueryString["LedgerTnxID"]);

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pmh.DoctorID,IF(RC.ReceiptNo IS NULL, LT.BillNo,RC.ReceiptNo) ReceiptNo,");
            sb.Append(" LT.PatientID AS PatientID,PM.Relation,PM.RelationName,LT.Date,Lt.Time,Lt.PanelID,");
            sb.Append(" CONCAT(PM.title,'',PM.PName)PatientName,FPM.Company_Name AS PanelName,");
            sb.Append(" CONCAT(IFNULL(PM.House_No,''),' ',IFNULL(pm.Street_Name,''),' ', IFNULL(pm.Locality,''),'-',IFNULL(pm.City,''),', ',IFNULL(pm.Country,'')) Address,IFNULL(pm.City,'')City, IFNULL(PM.Age,'')Age,IFNULL(PM.Gender,'')Gender, ");
            sb.Append(" IF(IFNULL(pm.Mobile,'')='',IFNULL(pm.Phone,''),IF(pm.Phone <>'',CONCAT(pm.Mobile,'/',pm.Phone),pm.Mobile))Mobile ,");
            sb.Append(" IFNULL(CONCAT(dm.`Title`,' ' , dm.`Name`),'') AS DoctorName,IF(dm.`degree`<>'',dm.`degree`,'')DocDegree, ");
            sb.Append(" dm.Specialization DocDepartment,IFNULL(RC.ReceiptNo,'')IsReceipt ");

            sb.Append(" FROM f_ledgertransaction LT INNER JOIN f_LedgerTnxDetail ltd on ltd.LedgerTransactionNo=lt.LedgerTransactionNo INNER JOIN f_itemmaster im on im.ItemID=ltd.ItemID LEFT JOIN f_reciept  RC ON LT.LedgerTransactionNo=RC.AsainstLedgerTnxNo ");
            sb.Append("  INNER JOIN patient_master PM ON Lt.PatientID=PM.PatientID INNER JOIN Patient_Medical_History PMH ON LT.TransactionID=PMH.TransactionID INNER JOIN f_panel_master FPM ON pmh.PanelID=FPM.PanelID ");
            sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=im.Type_ID ");
            sb.Append(" WHERE  LT.LedgerTransactionNo='" + LedgerTransactionNo + "'");
          DataTable  dt = StockReports.GetDataTable(sb.ToString());

          if (dt.Rows.Count > 0)
          {
              lblPanelCompany.Text = Util.GetString(dt.Rows[0]["PanelName"].ToString());
              lblDocDepartment.Text = Util.GetString(dt.Rows[0]["DocDepartment"].ToString());
              lbldept.Text = Util.GetString(dt.Rows[0]["DocDepartment"].ToString());
              LblPatientName.Text = Util.GetString(dt.Rows[0]["PatientName"].ToString());
              if (Util.GetString(dt.Rows[0]["IsReceipt"].ToString()).Trim() != "")
              {
                  LblReceiptNo.Text = dt.Rows[0]["ReceiptNo"].ToString().Trim();
                  LblDate.Text = Util.GetDateTime(dt.Rows[0]["Date"].ToString()).ToString("dd-MMM-yyyy");
                  LblTime.Text = Util.GetDateTime(dt.Rows[0]["Time"].ToString()).ToString("hh:mm tt");
                  lblRecp.Text = "Receipt&nbsp;No.";
              }
              else
              {
                  LblReceiptNo.Text = Util.GetString(dt.Rows[0]["ReceiptNo"].ToString());
                  LblDate.Text = Util.GetDateTime(dt.Rows[0]["Date"].ToString()).ToString("dd-MMM-yyyy");
                  LblTime.Text = Util.GetDateTime(dt.Rows[0]["Time"].ToString()).ToString("hh:mm tt");                
                  lblRecp.Text = "Bill&nbsp;No.";
              }

             // lblNepaliDate.Text = Util.GetString(NepDateConverter.EngToNep(Util.GetDateTime(Util.GetDateTime(dt.Rows[0]["Date"].ToString()).ToString("yyyy-MM-dd"))));
              if (Resources.Resource.DisplayLocalDate == "1")
                //  trNepDate.Visible = true;


              LblAgeSex.Text = Util.GetString(dt.Rows[0]["Age"].ToString()) + @" / " + Util.GetString(dt.Rows[0]["Gender"].ToString());
              lblAddress.Text = Util.GetString(dt.Rows[0]["Address"].ToString());
              lblMobile.Text = Util.GetString(dt.Rows[0]["Mobile"].ToString());
              lblRelation.Text = dt.Rows[0]["Relation"].ToString();
              lblRelationName.Text = dt.Rows[0]["RelationName"].ToString();
              LblRegNo.Text = Util.GetString(dt.Rows[0]["PatientId"].ToString());
              LblDoctorName.Text = Util.GetString(dt.Rows[0]["DoctorName"].ToString());
              lblDocDegree.Text = Util.GetString(dt.Rows[0]["DocDegree"].ToString());
          }
          string str1 = "SELECT CONCAT(Title,' ',Pname)pname,PatientID,Gender,IFNULL(mobile,'')ContactNo,DATE_FORMAT(DOB,'%d %b %Y')DOB,Get_Current_Age(PatientID)Age,DATE_FORMAT(DateEnrolled,'%d %b %Y')DateEnrolled  FROM patient_master WHERE PatientID='" + dt.Rows[0]["PatientId"].ToString() + "'";
          DataTable dt1 = StockReports.GetDataTable(str1);
          if (dt1.Rows.Count > 0)
          {
              OutputImg(dt1.Rows[0]["PatientID"].ToString());
              dt1.Columns.Add("BarCode", System.Type.GetType("System.Byte[]"));
              dt1.Rows[0]["BarCode"] = GetBitmapBytes(objBitmap);

              Byte[] bytes = GetBitmapBytes(objBitmap);
              string base64String = Convert.ToBase64String(bytes, 0, bytes.Length);
            //  imgPatient.Src = "data:image/jpeg;base64," + base64String;
          }

          string token = StockReports.ExecuteScalar("SELECT CONCAT(appno,'#',IFNULL(IF(OPDVisitNo=0,'',OPDVisitNo),''))appno FROM `appointment` WHERE PatientID='" + dt.Rows[0]["PatientID"].ToString() + "' And LedgertnxNo='" + LedgerTransactionNo.ToString() + "' AND DoctorID='" + dt.Rows[0]["DoctorID"].ToString() + "' ");
          if (token != "")
          {
              lblTokenNo.Text = token.Split('#')[0].ToString();
              lblOPDVisitNo.Text = token.Split('#')[1].ToString();
          }

          string seenByDrName = StockReports.ExecuteScalar("SELECT CONCAT(dm.title,dm.`NAME`) FROM App_Doctor_seenby_Doctor sm INNER JOIN doctor_Master dm ON dm.`DoctorID`= sm.`SeenByDoctorID` WHERE sm.IsActive = 1 AND ActualDoctorID='" + Util.GetString(dt.Rows[0]["DoctorID"].ToString()) + "' AND DATE='" + Util.GetDateTime(dt.Rows[0]["Date"].ToString()).ToString("yyyy-MM-dd") + "'");
          if (seenByDrName != "")
          {
              trSeenby.Visible = true;
              lblSeenbyName.Text = seenByDrName;
          }
    }
    private void OutputImg(string PatientID)
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