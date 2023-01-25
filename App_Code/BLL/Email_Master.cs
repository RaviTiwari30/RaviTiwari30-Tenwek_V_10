using System;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using System.Web.Script.Serialization;
using System.IO;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
/// <summary>
/// Summary description for Email_Master
/// </summary>
public class Email_Master
{
    public Email_Master()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static DataTable BindTemplate()
    {
        DataTable dt = StockReports.GetDataTable("SELECT * FROM email_templatemaster");
        return dt;
    }
    public static int SaveEmailTemplate(int TemplateID, int RoleID, string EmailTo, object columnInfo,string attchmentPaths=null, MySqlTransaction tnx = null, MySqlConnection con=null)
    {
        int emailSendID = 0;
        int CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        try
        {
            List<EmailTemplateInfo> dataColumnInfo = new JavaScriptSerializer().ConvertToType<List<EmailTemplateInfo>>(columnInfo);
            DataTable dttemplatedetail = StockReports.GetDataTable("SELECT RoleID,TemplateID,FromEmailID,FromEmailPassword,EmailSubject,StoreProcedureName,AttachementType,EmailBody,FromEmailPort,FromEmailSmtp,ErrorNotifyEmail FROM email_master Where TemplateID='" + TemplateID + "'");

            if (dttemplatedetail.Rows.Count > 0)
            {
                StringBuilder Email = new StringBuilder(dttemplatedetail.Rows[0]["EmailBody"].ToString());
                if (!string.IsNullOrEmpty(Email.ToString()))
                {

                    ParseEmailBody(dataColumnInfo, dttemplatedetail, Email);


                    if (EmailTo == "2" || EmailTo == "4" || EmailTo == "3")
                    {
                        StringBuilder sbto = new StringBuilder();
                        if (EmailTo == "2" || EmailTo == "4")
                            sbto.Append("SELECT em.Email FROM email_typemaster et INNER join employee_master em ON em.Emplotee_ID=et.Email where et.TemplateID='" + TemplateID + "' And EmailTo = '2' ");
                        if (EmailTo == "4")
                            sbto.Append("UNION ALL ");
                        if (EmailTo == "3" || EmailTo == "4")
                            sbto.Append("SELECT Email FROM email_typemaster WHERE TemplateID='" + TemplateID + "' AND EmailTo = '1' ");
                        DataTable dtSendto = StockReports.GetDataTable(sbto.ToString());
                        if (dtSendto.Rows.Count > 0)
                        {
                            Email_Host objEmail = new Email_Host();
                            for (int i = 0; i <= dtSendto.Rows.Count; i++)
                            {
                                objEmail._FromEamilID = dttemplatedetail.Rows[0]["FromEmailID"].ToString();
                                objEmail._FromEmailPassword = dttemplatedetail.Rows[0]["FromEmailPassword"].ToString();
                                objEmail._ToEmailID = dtSendto.Rows[0]["Email"].ToString();
                                objEmail._EmailSubject = dttemplatedetail.Rows[0]["EmailSubject"].ToString();
                                objEmail._EmailBody = Email.ToString();
                                objEmail._StoreProcedureName = dttemplatedetail.Rows[0]["StoreProcedureName"].ToString();
                                objEmail._TemplateID = Util.GetInt(dttemplatedetail.Rows[0]["TemplateID"].ToString());
                                objEmail._RoleID = Util.GetInt(dttemplatedetail.Rows[0]["RoleID"].ToString());
                                objEmail._AttachementType = dttemplatedetail.Rows[0]["AttachementType"].ToString();
                                objEmail._AttachementPath = attchmentPaths;
                                objEmail._EmailSendDate = "0001-01-01 00:00:00";
                                objEmail._EntryBy = HttpContext.Current.Session["ID"].ToString();
                                objEmail._transactionID = dataColumnInfo[0].TransactionID.ToString();
                                objEmail._patientID = dataColumnInfo[0].PatientID.ToString();
                                objEmail._PageCallPath = Util.GetString(dataColumnInfo[0].PageCallPath);//.ToString();
                                objEmail._CentreID = CentreID;
                                objEmail._emailport = Util.GetInt(dttemplatedetail.Rows[0]["FromEmailPort"].ToString());
                                objEmail._smtp_host = dttemplatedetail.Rows[0]["FromEmailSmtp"].ToString();
                                objEmail._ErrorNotifyEmail = dttemplatedetail.Rows[0]["ErrorNotifyEmail"].ToString();
                                emailSendID = objEmail.sendEmail();
                            }
                        }
                    }
                    if (EmailTo == "1")
                    {
                        if (con != null)
                        {
                            Email_Host objEmail = new Email_Host(con);
                            objEmail._FromEamilID = dttemplatedetail.Rows[0]["FromEmailID"].ToString();
                            objEmail._FromEmailPassword = dttemplatedetail.Rows[0]["FromEmailPassword"].ToString();
                            objEmail._ToEmailID = dataColumnInfo[0].EmailTo.ToString();
                            objEmail._EmailSubject = dttemplatedetail.Rows[0]["EmailSubject"].ToString();
                             string AdditionalEmailbody = string.Empty;
                            if (!String.IsNullOrEmpty(dataColumnInfo[0].AdditionalEmailBody))
                                AdditionalEmailbody = dataColumnInfo[0].AdditionalEmailBody.ToString();
                            objEmail._EmailBody = Email.ToString() + " " + AdditionalEmailbody;
                            objEmail._StoreProcedureName = dttemplatedetail.Rows[0]["StoreProcedureName"].ToString();
                            objEmail._TemplateID = Util.GetInt(dttemplatedetail.Rows[0]["TemplateID"].ToString());
                            objEmail._RoleID = Util.GetInt(dttemplatedetail.Rows[0]["RoleID"].ToString());
                            objEmail._AttachementType = dttemplatedetail.Rows[0]["AttachementType"].ToString();
                            objEmail._AttachementPath = attchmentPaths;
                            objEmail._EmailSendDate = "0001-01-01 00:00:00";
                            objEmail._EntryBy = HttpContext.Current.Session["ID"].ToString();
                            objEmail._transactionID = Util.GetString(dataColumnInfo[0].TransactionID);
                            objEmail._patientID = Util.GetString(dataColumnInfo[0].PatientID);
                            objEmail._PageCallPath = Util.GetString(dataColumnInfo[0].PageCallPath);//.ToString();
                            objEmail._CentreID = CentreID;
                            objEmail._emailport = Util.GetInt(dttemplatedetail.Rows[0]["FromEmailPort"].ToString());
                            objEmail._smtp_host = dttemplatedetail.Rows[0]["FromEmailSmtp"].ToString();
                            objEmail._ErrorNotifyEmail = dttemplatedetail.Rows[0]["ErrorNotifyEmail"].ToString();
                            emailSendID = objEmail.sendEmail();
                        }
                        else
                        {
                            Email_Host objEmail = new Email_Host();
                            objEmail._FromEamilID = dttemplatedetail.Rows[0]["FromEmailID"].ToString();
                            objEmail._FromEmailPassword = dttemplatedetail.Rows[0]["FromEmailPassword"].ToString();
                            objEmail._ToEmailID = dataColumnInfo[0].EmailTo.ToString();
                            objEmail._EmailSubject = dttemplatedetail.Rows[0]["EmailSubject"].ToString();
                            string AdditionalEmailbody = string.Empty;
                            if (!String.IsNullOrEmpty(dataColumnInfo[0].AdditionalEmailBody))
                                AdditionalEmailbody = dataColumnInfo[0].AdditionalEmailBody.ToString();
                            objEmail._EmailBody = Email.ToString() +" "+ AdditionalEmailbody;
                            objEmail._StoreProcedureName = dttemplatedetail.Rows[0]["StoreProcedureName"].ToString();
                            objEmail._TemplateID = Util.GetInt(dttemplatedetail.Rows[0]["TemplateID"].ToString());
                            objEmail._RoleID = Util.GetInt(dttemplatedetail.Rows[0]["RoleID"].ToString());
                            objEmail._AttachementType = dttemplatedetail.Rows[0]["AttachementType"].ToString();
                            objEmail._AttachementPath = attchmentPaths;
                            objEmail._EmailSendDate = "0001-01-01 00:00:00";
                            objEmail._EntryBy = HttpContext.Current.Session["ID"].ToString();
                            objEmail._transactionID = Util.GetString(dataColumnInfo[0].TransactionID);
                            objEmail._patientID = Util.GetString(dataColumnInfo[0].PatientID);
                            objEmail._PageCallPath = Util.GetString(dataColumnInfo[0].PageCallPath);//.ToString();
                            objEmail._CentreID = CentreID;
                            objEmail._emailport = Util.GetInt(dttemplatedetail.Rows[0]["FromEmailPort"].ToString());
                            objEmail._smtp_host = dttemplatedetail.Rows[0]["FromEmailSmtp"].ToString();
                            objEmail._ErrorNotifyEmail = dttemplatedetail.Rows[0]["ErrorNotifyEmail"].ToString();
                            emailSendID = objEmail.sendEmail();
                        }
                    }
                }
                else
                    emailSendID = 0;
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            emailSendID = 0;
        }
        return emailSendID;
    }

    private static void ParseEmailBody(List<EmailTemplateInfo> dataColumnInfo, DataTable dttemplatedetail, StringBuilder Email)
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT c.CentreName,c.MobileNo,c.Website,c.CentreCode FROM center_master c WHERE c.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        if (Email.ToString().Contains("{SUBJECT}"))
            Email.Replace("{SUBJECT}", dttemplatedetail.Rows[0]["EmailSubject"].ToString());

        if (Email.ToString().Contains("{MRNo}"))
            Email.Replace("{MRNo}", dataColumnInfo[0].MRNo);

        if (Email.ToString().Contains("{IPDNo}"))
            Email.Replace("{IPDNo}", dataColumnInfo[0].IPDNo);

        if (Email.ToString().Contains("{PatientName}"))
            Email.Replace("{PatientName}", dataColumnInfo[0].PName);

        if (Email.ToString().Contains("{Title}"))
            Email.Replace("{Title}", dataColumnInfo[0].Title);

        if (Email.ToString().Contains("{MRNo}"))
            Email.Replace("{MRNo}", dataColumnInfo[0].PatientID);

        if (Email.ToString().Contains("{Amount}"))
            Email.Replace("{Amount}", dataColumnInfo[0].BillAmount);

        if (Email.ToString().Contains("{AppointmentNo}"))
            Email.Replace("{AppointmentNo}", dataColumnInfo[0].AppNo.ToString());

        if (Email.ToString().Contains("{TestName}"))
            Email.Replace("{TestName}", dataColumnInfo[0].InvestigationName.ToString());

        if (Email.ToString().Contains("{AppointmentDate}"))
            Email.Replace("{AppointmentDate}", dataColumnInfo[0].AppointmentDate.ToString());

        if (Email.ToString().Contains("{AppointmentTime}"))
            Email.Replace("{AppointmentTime}", dataColumnInfo[0].AppointmentTime.ToString());

        if (Email.ToString().Contains("{AdmissionDate}"))
            Email.Replace("{AdmissionDate}", dataColumnInfo[0].AdmissionDate.ToString());

        if (Email.ToString().Contains("{EmailAddress}"))
            Email.Replace("{EmailAddress}", dataColumnInfo[0].EmailAddress.ToString());


        if (Email.ToString().Contains("{LabNo}"))
            Email.Replace("{LabNo}", dataColumnInfo[0].LedgertransactionNo.Replace("LOSHHI", "1").Replace("LSHHI", "2").Replace("LISHHI", "3").ToString());

        if (Email.ToString().Contains("{IPDNo}"))
            Email.Replace("{IPDNo}", dataColumnInfo[0].TransactionID.Replace("ISHHI", "").ToString());

        if (Email.ToString().Contains("{FromDepartment}"))
            Email.Replace("{FromDepartment}", dataColumnInfo[0].FromDepartment.ToString());

        if (Email.ToString().Contains("{ErrorType}"))
            Email.Replace("{ErrorType}", dataColumnInfo[0].ErrorType.ToString());

        if (Email.ToString().Contains("{Priority}"))
            Email.Replace("{Priority}", dataColumnInfo[0].Priority.ToString());

        if (Email.ToString().Contains("{RoomNo}"))
            Email.Replace("{RoomNo}", dataColumnInfo[0].RoomNo.ToString());

        if (Email.ToString().Contains("{BedNo}"))
            Email.Replace("{BedNo}", dataColumnInfo[0].BedNo.ToString());

        if (Email.ToString().Contains("{PanelName}"))
            Email.Replace("{PanelName}", dataColumnInfo[0].PanelName.ToString());

        if (Email.ToString().Contains("{EmployeeName}"))
            Email.Replace("{EmployeeName}", dataColumnInfo[0].EmployeeName.ToString());

        if (Email.ToString().Contains("{RoomType}"))
            Email.Replace("{RoomType}", dataColumnInfo[0].RoomType.ToString());

        if (Email.ToString().Contains("{Date}"))
            Email.Replace("{Date}", dataColumnInfo[0].Date.ToString());

        if (Email.ToString().Contains("{FromDate}"))
            Email.Replace("{FromDate}", dataColumnInfo[0].FromDate.ToString());

        if (Email.ToString().Contains("{ToDate}"))
            Email.Replace("{ToDate}", dataColumnInfo[0].ToDate.ToString());

        if (Email.ToString().Contains("{ToDate}"))
            Email.Replace("{ToDate}", dataColumnInfo[0].ToDate.ToString());

        if (Email.ToString().Contains("{UserName}"))
            Email.Replace("{UserName}", dataColumnInfo[0].UserName.ToString());

        if (Email.ToString().Contains("{Password}"))
            Email.Replace("{Password}", dataColumnInfo[0].Password.ToString());

        if (Email.ToString().Contains("{Discount}"))
            Email.Replace("{Discount}", dataColumnInfo[0].Discount.ToString());


        if (Email.ToString().Contains("{ApprovalAmount}"))
            Email.Replace("{ApprovalAmount}", dataColumnInfo[0].ApprovalAmount.ToString());




        if (Email.ToString().Contains("{NICNumber}"))
            Email.Replace("{NICNumber}", dataColumnInfo[0].NICNumber.ToString());

        if (Email.ToString().Contains("{PolicyNumber}"))
            Email.Replace("{PolicyNumber}", dataColumnInfo[0].PolicyNumber.ToString());


        if (Email.ToString().Contains("{PolicyCardNumber}"))
            Email.Replace("{PolicyCardNumber}", dataColumnInfo[0].PolicyCardNumber.ToString());



        if (Email.ToString().Contains("{PolicyExpiryDate}"))
            Email.Replace("{PolicyExpiryDate}", dataColumnInfo[0].PolicyExpiryDate.ToString());
        if (Email.ToString().Contains("{DoctorName}"))
            Email.Replace("{DoctorName}", dataColumnInfo[0].DoctorName.ToString());
        if (Email.ToString().Contains("{DOB}"))
            Email.Replace("{DOB}", dataColumnInfo[0].DOB.ToString());
        if (Email.ToString().Contains("{CentreName}"))
            Email.Replace("{CentreName}", dtCentre.Rows[0]["CentreName"].ToString());
        if (Email.ToString().Contains("{CentreWebsite}"))
            Email.Replace("{CentreWebsite}", dtCentre.Rows[0]["Website"].ToString());
        if (Email.ToString().Contains("{CentreContactNo}"))
            Email.Replace("{CentreContactNo}", dtCentre.Rows[0]["MobileNo"].ToString());
        if (Email.ToString().Contains("{CentreCode}"))
            Email.Replace("{CentreCode}", dtCentre.Rows[0]["CentreCode"].ToString());
        if (Email.ToString().Contains("{PurchaseOrderNo}"))
            Email.Replace("{PurchaseOrderNo}", dataColumnInfo[0].PurchaseOrderNo.ToString());
        if (Email.ToString().Contains("{SupplierName}"))
            Email.Replace("{SupplierName}", dataColumnInfo[0].SupplierName.ToString());
    }

    public static List<EmailTemplateInfo> getemailColumnInfo(string columnInfo)
    {
        List<EmailTemplateInfo> list = new List<EmailTemplateInfo>();
        if (columnInfo != "")
        {
            DataTable table = new DataTable();
            DataColumn colID = table.Columns.Add("Id", typeof(string));
            string[] lines = columnInfo.Split('#');
            foreach (var line in lines)
            {
                string[] split = line.Split('#');
                DataRow row = table.NewRow();
                row.SetField(colID, (split[0]));
                table.Rows.Add(row);
            }
            list = ConvertDataTable<EmailTemplateInfo>(table);
        }
        return list;
    }

    public static List<T> ConvertDataTable<T>(DataTable dt)
    {
        List<T> data = new List<T>();
        foreach (DataRow row in dt.Rows)
        {
            T item = GetItem<T>(row);
            data.Add(item);
        }
        return data;
    }
    private static T GetItem<T>(DataRow dr)
    {
        Type temp = typeof(T);
        T obj = Activator.CreateInstance<T>();
        foreach (DataColumn column in dr.Table.Columns)
        {
            foreach (System.Reflection.PropertyInfo pro in temp.GetProperties())
            {
                if (pro.Name == column.ColumnName)
                    pro.SetValue(obj, dr[column.ColumnName], null);
                else
                    continue;
            }
        }
        return obj;
    }
    public static string EmailFileUpload(FileUpload fileupload, string MainFolder, string fileSubfolder)
    {
        string Ext = System.IO.Path.GetExtension(fileupload.PostedFile.FileName.ToString());
        if ((Ext != ".pdf") || (Ext != ".PDF") || (Ext != ".doc") || (Ext != ".DOC") || (Ext != ".docx") || (Ext != ".gif") || (Ext != ".jpg") || (Ext != ".xls") || (Ext != ".xlsx") || (Ext != ".txt"))
        {
            string upld = string.Empty;
            if (All_LoadData.chkDocumentDrive() == 0)
            {
                return "0";
            }
            var folder = All_LoadData.createDocumentFolder(MainFolder, fileSubfolder);
            if (folder == null)
            {
                return "0";
            }
            if (folder.Exists)
            {
                DirectoryInfo[] SubFolder = folder.GetDirectories(fileSubfolder);

                if (SubFolder.Length > 0)
                {
                    foreach (DirectoryInfo Sub in SubFolder)
                    {
                        if (Sub.Name == fileSubfolder)
                        {
                            FileInfo[] files = Sub.GetFiles();
                            foreach (FileInfo fl in files)
                            {
                                string fil = fl.Name;
                                if (fil == fileupload.PostedFile.FileName.ToString())
                                {
                                    return "0";
                                }
                            }
                            string doc = fileupload.FileName;
                            string IpFolder = Sub.Name;
                            upld = Path.Combine(folder.ToString(), doc);
                            fileupload.PostedFile.SaveAs(upld);
                            return doc;
                        }
                    }
                }
                else
                {
                    string doc = fileupload.FileName;
                    upld = Path.Combine(folder.ToString(), doc);
                    fileupload.PostedFile.SaveAs(upld);
                    return doc;
                }
            }
            else
            {
                DirectoryInfo[] sub = folder.GetDirectories();
                string doc = fileupload.FileName;
                upld = Path.Combine(folder.ToString(), doc);
                fileupload.PostedFile.SaveAs(upld);
                return doc;
            }
            return "";
        }
        else
        {
            return "0";
        }
    }
    public static string CrystalReportPdfConvertable(ReportDocument obj1, string FileName)
    {
        try
        {
            ExportOptions CrExportOptions;
            DiskFileDestinationOptions CrDiskFileDestinationOptions = new DiskFileDestinationOptions();
            PdfRtfWordFormatOptions CrFormatTypeOptions = new PdfRtfWordFormatOptions();
            CrDiskFileDestinationOptions.DiskFileName = FileName; //RportPath
            CrExportOptions = obj1.ExportOptions;
            CrExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
            CrExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat;
            CrExportOptions.DestinationOptions = CrDiskFileDestinationOptions;
            CrExportOptions.FormatOptions = CrFormatTypeOptions;
            obj1.Export();
            return FileName;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    public static string CrystalReportExcelConvertable(ReportDocument obj, string FileName)
    {
        try
        {
            ExportOptions CrExportOptions;
            DiskFileDestinationOptions CrDiskFileDestinationOptions = new DiskFileDestinationOptions();
            ExcelFormatOptions CrFormatTypeOptions = new ExcelFormatOptions();
            CrDiskFileDestinationOptions.DiskFileName = FileName;
            CrExportOptions = obj.ExportOptions;  //"c:\\csharp.net-informations.xls";
            CrExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
            CrExportOptions.ExportFormatType = ExportFormatType.Excel;
            CrExportOptions.DestinationOptions = CrDiskFileDestinationOptions;
            CrExportOptions.FormatOptions = CrFormatTypeOptions;
            obj.Export();
            return FileName;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
}