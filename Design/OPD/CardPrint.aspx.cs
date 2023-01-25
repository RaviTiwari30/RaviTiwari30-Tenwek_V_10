using MW6BarcodeASPNet;
using System;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web;

public partial class Design_CardPrint : System.Web.UI.Page
{
    private Bitmap objBitmap;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ddlPrint.DataSource = System.Drawing.Printing.PrinterSettings.InstalledPrinters;

            ddlPrint.DataBind();
            ddlPrint.SelectedIndex = 0;
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    private void binddetail()
    {
        StringBuilder sb = new StringBuilder();
        string filePathNew = string.Empty;
        sb.Append("Select CONCAT(Title,' ',Pname)Pname,PatientID,Mobile,Gender,DATE_FORMAT(DOB,'%d %b %Y')DOB1,House_No,DATE_FORMAT(DateEnrolled,'%d %b %Y')DateEnrolled from  patient_master where ");
        if (txtMrno.Text != "")
            sb.Append(" PatientID='" + Util.GetFullPatientID(txtMrno.Text.Trim()) + "' ");
        else
            sb.Append(" DATE(DateEnrolled) >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(DateEnrolled)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND PatientType<>2 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        dt.Columns.Add("PhotoUpload", typeof(System.Int32));

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            DateTime DateEnrolled = Util.GetDateTime(dt.Rows[i]["DateEnrolled"]);
            filePathNew = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\PatientPhoto\\" + "\\" + DateEnrolled.Year + "\\" + DateEnrolled.Month + "\\" + dt.Rows[i]["PatientID"].ToString().Replace("/", "_") + ".jpg");
            //  filePathNew = System.IO.Path.Combine(Server.MapPath("~/PatientPhoto" + "/" + DateEnrolled.Year + "/" + DateEnrolled.Month + "/" + dt.Rows[i]["PatientID"].ToString().Replace("/", "_") + ".jpg"));

            if (File.Exists(filePathNew))
            {
                dt.Rows[i]["PhotoUpload"] = 1;
            }
            else
            {
                dt.Rows[i]["PhotoUpload"] = 0;
            }
        }
        if (dt.Rows.Count > 0)
        {
            grdCard.DataSource = dt;
            grdCard.DataBind();
        }
        else
        {
            grdCard.DataSource = null;
            grdCard.DataBind();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        binddetail();
    }

    protected void grdCard_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string PatientID = "";
        PatientID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "imbPrint")
        {
            string str1 = "SELECT CONCAT(Title,' ',Pname)pname,PatientID as Patient_ID,Gender,IFNULL(mobile,'')ContactNo,DATE_FORMAT(DOB,'%d %b %Y')DOB,Get_Current_Age(PatientID)Age,DATE_FORMAT(DateEnrolled,'%d %b %Y')DateEnrolled,YEAR(DateEnrolled)ptyear,MONTH(DateEnrolled)ptmonth,Email,DATE_FORMAT(DateEnrolled,'%d-%b-%Y') ValidUpTo,DATE_FORMAT(DATE_ADD(DateEnrolled, INTERVAL 1 YEAR),'%d-%b-%Y') ValidTill  FROM patient_master WHERE PatientID='" + PatientID.ToString() + "'";
            DataTable dt1 = StockReports.GetDataTable(str1);
            if (dt1.Rows.Count > 0)
            {
                PatientID = PatientID.Replace("/", "_");
                OutputImg(dt1.Rows[0]["Patient_ID"].ToString());
                dt1.Columns.Add("BarCode", System.Type.GetType("System.Byte[]"));
                dt1.Rows[0]["BarCode"] = GetBitmapBytes(objBitmap);
                //dt1.Columns.Add("QRCode", System.Type.GetType("System.Byte[]"));
                DateTime DateEnrolle = Util.GetDateTime(dt1.Rows[0]["DateEnrolled"]);

                dt1.Columns.Add("PatientImage", System.Type.GetType("System.Byte[]"));

               // string PImagePath = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\PatientPhoto\\" + DateEnrolle.Year + "\\" + DateEnrolle.Month + "\\" + PatientID + ".jpg");

                var directoryPath = All_LoadData.createDocumentFolder("PatientPhoto", DateEnrolle.Year.ToString(), DateEnrolle.Month.ToString());
                string PImagePath = "";// Path.Combine(directoryPath.ToString(), PatientID.ToString().Replace("/", "_") + ".jpg");

                //   string PImagePath = HttpContext.Current.Server.MapPath(@"~/PatientPhoto/" + DateEnrolle.Year + "/" + DateEnrolle.Month + "/" + PatientID + ".jpg");

                //if (!(File.Exists(PImagePath)))
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM237','" + lblMsg.ClientID + "');", true);

                //    return;
                //}

              //  FileStream fs1 = new FileStream(PImagePath, FileMode.Open, System.IO.FileAccess.Read);

//                byte[] PImagebyte = new byte[fs1.Length + 1];
           //     fs1.Read(PImagebyte, 0, (int)fs1.Length);
           //     fs1.Close();
          //      dt1.Rows[0]["PatientImage"] =  PImagebyte;
                DataSet ds = new DataSet();
                ds.Tables.Add(dt1.Copy());
                ds.Tables[0].TableName = "PatientDetail";

                DataTable dtImg = All_LoadData.CrystalReportLogo();

                DataTable PatientImageTable = new DataTable();
                //patientimage.TableName = "Logo";
                PatientImageTable.Columns.Add("PatientImage", System.Type.GetType("System.Byte[]"));
                DataRow drImg = PatientImageTable.NewRow();

                var ptid = PatientID.Replace("/", "_").Replace("/", "_").Replace("/", "_").ToString().Trim();
                string path = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\PatientPhoto\\" + dt1.Rows[0]["ptyear"].ToString() + "\\" + dt1.Rows[0]["ptmonth"].ToString() + "\\" + ptid + ".jpg");

                if (File.Exists(path))
                {
                    FileStream fs = new FileStream(path, FileMode.Open, System.IO.FileAccess.Read);
                    byte[] imgbyte = new byte[fs.Length + 1];
                    fs.Read(imgbyte, 0, (int)fs.Length);
                    fs.Close();
                    drImg["PatientImage"] = imgbyte;
                }
                else
                {
                    //drImg["PatientImage"] = "";
                }

                PatientImageTable.Rows.Add(drImg);
                PatientImageTable.AcceptChanges();

                ds.Tables.Add(PatientImageTable.Copy());
                ds.Tables.Add(dtImg.Copy());
                ds.Tables[1].TableName = "PatientImageTable";
               // ds.WriteXmlSchema("E:\\Print.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "Print";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key15", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
        }
        else if (e.CommandName == "imbUpload")
        {
            var Protocol = Request.Url.Scheme; // will get http, https, etc.
            var host = Request.Url.Host; // will get www.mywebsite.com
            var port = Request.Url.Port; // will get the port
            var path = Request.Url.AbsolutePath; // should get the /pages/page1.aspx part, can
            //Image Save URL
            var virtualDirectory = path.Split('/')[1];

            //string ImageSaveUrl = "http://localhost:13276/his/Design/OPD/SaveCaptureImage.aspx";
            string ImageSaveUrl = Protocol + "://" + host + ":" + port + "/" + virtualDirectory + "/Design/OPD/SaveCaptureImage.aspx";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key16", "window.open('../../Design/OPD/ImageCaptureTestPage.aspx?PatientID=" + PatientID.Split('#')[0] + "&url=" + ImageSaveUrl + "&DateEnrolled=" + PatientID.Split('#')[1] + "','photo','width=350px, height=225px','location=no, menubar=no,status=no, toolbar=no, scrollbars=no, resizable=no');", true);
        }
        else if (e.CommandName.ToString() == "imbUploadPhoto")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            string PhotoPatientID = ((Label)grdCard.Rows[id].FindControl("lblPatientID")).Text.Replace("/", "_");
            DateTime DateEnrolle = Util.GetDateTime(((Label)grdCard.Rows[id].FindControl("lblDateEnrolled")).Text);
            if (((FileUpload)grdCard.Rows[id].FindControl("FileUpload")).HasFile)
            {
                string Exte = System.IO.Path.GetExtension(((FileUpload)grdCard.Rows[id].FindControl("FileUpload")).PostedFile.FileName);
                if (Exte != ".jpg" && Exte != ".jpeg" && Exte != ".gif" && Exte != ".png")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM051','" + lblMsg.ClientID + "');", true);
                    return;
                }
                if (All_LoadData.chkDocumentDrive() == 0)
                {
                    lblMsg.Text = "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
                    return;
                }
                var directoryPath = All_LoadData.createDocumentFolder("PatientPhoto", DateEnrolle.Year.ToString(), DateEnrolle.Month.ToString());
                if (directoryPath == null)
                {
                    lblMsg.Text = "Error occurred, Please contact administrator ";
                    return;
                }

                //string directoryPath = Server.MapPath("~/PatientPhoto" + "/" + DateEnrolle.Year + "/" + DateEnrolle.Month);
                //if (!Directory.Exists(directoryPath))
                //{
                //    Directory.CreateDirectory(directoryPath);
                //}
                string filePath = Path.Combine(directoryPath.ToString(), PhotoPatientID + ".jpg");

                //  string filePathNew = System.IO.Path.Combine(Server.MapPath("~/PatientPhoto" + "/" + DateEnrolle.Year + "/" + DateEnrolle.Month + "/" + PhotoPatientID + ".jpg"));

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }
                ((FileUpload)grdCard.Rows[id].FindControl("FileUpload")).SaveAs(filePath);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                binddetail();
            }
            else
            {
                lblMsg.Text = "Please Browse The File From System";
            }
        }
        else if (e.CommandName == "imbPrintSticker")
        {
            string data = string.Empty;
            string str1 = "SELECT CONCAT(Title,' ',PFirstName)pname,PatientID,Gender,IFNULL(mobile,'')ContactNo,Get_Current_Age(PatientID)Age,DATE_FORMAT(DateEnrolled,'%d-%b-%Y')DateEnrolled,CONCAT(LOWER(House_No),' ',LOWER(Street_Name))Address,Concat(Taluka,' ',Place,' ',District)Place,Mobile,ifnull(Concat(Relation,' ',RelationName),'N/A')RelationName,ifnull(occupation,'N/A')occupation  FROM patient_master WHERE PatientID='" + PatientID.ToString() + "'";
            DataTable dt = StockReports.GetDataTable(str1);
            if (dt.Rows.Count > 0)
            {
                data = data + "" + (data == "" ? "" : "^") + dt.Rows[0]["pname"].ToString() + "#"
                    + dt.Rows[0]["age"].ToString() + "/" + dt.Rows[0]["gender"].ToString() + "#" + dt.Rows[0]["PatientID"].ToString() + "#" + dt.Rows[0]["DateEnrolled"].ToString() + "#" + dt.Rows[0]["Address"].ToString() + "#" + dt.Rows[0]["Mobile"].ToString() + "#" +
                   dt.Rows[0]["Place"].ToString() + "#" + dt.Rows[0]["RelationName"].ToString() + "#" + dt.Rows[0]["occupation"].ToString();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "WriteToFiles('" + data + "');", true);
            }
        }
        else if (e.CommandName == "ViewPhoto")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            string PhotoPatientID = ((Label)grdCard.Rows[id].FindControl("lblPatientID")).Text.Replace("/", "_");
            DateTime DateEnrolle = Util.GetDateTime(((Label)grdCard.Rows[id].FindControl("lblDateEnrolled")).Text);
            string gender = ((Label)grdCard.Rows[id].FindControl("lblGender")).Text;

            string PImagePath = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\PatientPhoto\\" + DateEnrolle.Year + "\\" + DateEnrolle.Month + "\\" + PhotoPatientID + ".jpg");
            if (File.Exists(PImagePath))
            {
                imgPatient.Src = this.PhotoBase64ImgSrc(PImagePath);
            }
            else
            {
                //check gender
                if (gender == "Male")
                {
                    imgPatient.Src = "~/Images/MaleDefault.png";
                }
                else if (gender == "Female")
                {
                    imgPatient.Src = "~/Images/FemaleDefault.png";
                }
            }
            mpe.Show();
        }
    }

    protected string PhotoBase64ImgSrc(string fileNameandPath)
    {
        byte[] byteArray = File.ReadAllBytes(fileNameandPath);
        string base64 = Convert.ToBase64String(byteArray);

        return string.Format("data:image/jpg;base64,{0}", base64);
    }

    public byte[] imageToByteArray(System.Drawing.Image imageIn)
    {
        MemoryStream ms = new MemoryStream();
        imageIn.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
        return ms.ToArray();
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

    public System.Drawing.Image RoundCorners(System.Drawing.Image StartImage, int CornerRadius, Color BackgroundColor)
    {
        CornerRadius *= 4;
        Bitmap RoundedImage = new Bitmap(StartImage.Width, StartImage.Height);
        Graphics g = Graphics.FromImage(RoundedImage);
        g.Clear(BackgroundColor);
        g.SmoothingMode = SmoothingMode.AntiAlias;
        Brush brush = new TextureBrush(StartImage);
        GraphicsPath gp = new GraphicsPath();
        gp.AddArc(0, 0, CornerRadius, CornerRadius, 180, 90);
        gp.AddArc(0 + RoundedImage.Width - CornerRadius, 0, CornerRadius, CornerRadius, 270, 90);
        gp.AddArc(0 + RoundedImage.Width - CornerRadius, 0 + RoundedImage.Height - CornerRadius, CornerRadius, CornerRadius, 0, 90);
        gp.AddArc(0, 0 + RoundedImage.Height - CornerRadius, CornerRadius, CornerRadius, 90, 90);
        g.FillPath(brush, gp);
        return RoundedImage;
    }

    protected void grdCard_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
        if (((Label)e.Row.FindControl("lblUploadPhoto")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            }
            else
                ((ImageButton)e.Row.FindControl("imbViewPhoto")).Visible = false;
        }
    }
    [WebMethod(EnableSession = true)]
    public static string GetReport(string patientid)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT '' LedgertransactionNo,pm.PatientID,pm.Title,pm.PFirstName,pm.PLastName,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB,pm.Gender,pm.Age, ");
            sb.Append("DATE_FORMAT(CURRENT_DATE(),'%d-%b-%Y') AS DATE,CURRENT_TIME() AS TIME,pm.Relation,pm.RelationName,pm.RelationPhoneNo,pm.Email, ");
            sb.Append("CONCAT(IFNULL(pm.Relation,''),' ,',IFNULL(pm.RelationName,''),' ,',IFNULL(pm.RelationPhoneNo,''))RelationDetails,pm.Mobile, ");
            sb.Append("CONCAT(IFNULL(Phone_STDCODE,''),'-',IFNULL(pm.Phone,''))Phone,CONCAT(IFNULL(pm.ResidentialNumber_STDCODE,''),'-', ");
            sb.Append("IFNULL(pm.ResidentialNumber,''))ResidentialNumber,CONCAT(pm.House_No,' ',pm.Street_Name,' ', pm.Locality,' ',pm.City,' ',pm.Country)Address, ");
            sb.Append("'' ReportDispatchModeID,'' PaymentModeID FROM patient_master pm WHERE pm.PatientID !='' AND pm.PatientID='" + patientid.Trim() + "' ");
            DataTable dtReport = StockReports.GetDataTable(sb.ToString());
            if (dtReport != null && dtReport.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dtReport.AcceptChanges();
                HttpContext.Current.Session["dtExport2Excel"] = dtReport;
                HttpContext.Current.Session["ReportName"] = "LaboratoryOutPatientRecordForm";
                HttpContext.Current.Session["Period"] = "";
                DataSet ds = new DataSet();
                ds.Tables.Add(dtReport.Copy());
                ds.WriteXmlSchema(@"E:\NewReport.xml");
                HttpContext.Current.Session["ds"] = ds;
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../common/Commonreport.aspx" });
            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Data Found" });
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }
}