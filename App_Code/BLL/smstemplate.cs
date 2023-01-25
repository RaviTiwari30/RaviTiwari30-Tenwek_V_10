using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Data;
/// <summary>
/// Summary description for smstemplate
/// </summary>
public class smstemplate
{
    public smstemplate()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static string getSMSTemplate(int templateID, object columnInfo, int smsType, MySqlConnection con, string UserID)
    {
        try
        {
            // smsType 1 for patient 2 for doctor 3 for employee 4 for other
            List<smsTemplateInfo> dataColumnInfo = new JavaScriptSerializer().ConvertToType<List<smsTemplateInfo>>(columnInfo);
            string smsContent = "";
            if (con != null)
                smsContent = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SMS FROM sms_master where Active =1 AND TemplateID=" + templateID + ""));
            else
                smsContent = StockReports.ExecuteScalar("SELECT SMS FROM sms_master where Active =1 AND TemplateID=" + templateID + "");

            DataTable dtCentre = StockReports.GetDataTable("SELECT c.CentreName,c.MobileNo,c.Website,c.CentreCode FROM center_master c WHERE c.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
            StringBuilder sms = new StringBuilder();

            if (smsContent != "")
            {
                sms.Append(smsContent);
                if (sms.ToString().Contains("<PatientName>"))
                {
                    sms.Replace("<PatientName>", dataColumnInfo[0].PName);
                }
                if (sms.ToString().Contains("<Title>"))
                {
                    sms.Replace("<Title>", dataColumnInfo[0].Title);
                }
                if (sms.ToString().Contains("<UHID>"))
                {
                    sms.Replace("<UHID>", dataColumnInfo[0].PatientID);
                }
                if (sms.ToString().Contains("<AppointmentNo>"))
                {
                    sms.Replace("<AppointmentNo>", dataColumnInfo[0].AppNo.ToString());
                }
                if (sms.ToString().Contains("<TestName>"))
                {
                    sms.Replace("<TestName>", dataColumnInfo[0].InvestigationName.ToString());
                }
                if (sms.ToString().Contains("<AppointmentDate>"))
                {
                    sms.Replace("<AppointmentDate>", dataColumnInfo[0].AppointmentDate.ToString());
                }

                if (sms.ToString().Contains("<AppointmentTime>"))
                {
                    sms.Replace("<AppointmentTime>", dataColumnInfo[0].AppointmentTime.ToString());
                }

                if (sms.ToString().Contains("<EmailAddress>"))
                {
                    sms.Replace("<EmailAddress>", dataColumnInfo[0].EmailAddress.ToString());
                }

                if (sms.ToString().Contains("<DoctorName>"))
                {
                    sms.Replace("<DoctorName>", dataColumnInfo[0].DoctorName.ToString());
                }
                if (sms.ToString().Contains("<LabNo>"))
                {
                    sms.Replace("<LabNo>", dataColumnInfo[0].LedgertransactionNo.Replace("LOSHHI", "1").Replace("LSHHI", "2").Replace("LISHHI", "3").ToString());
                }
                if (sms.ToString().Contains("<IPDNo>"))
                {
                    sms.Replace("<IPDNo>", dataColumnInfo[0].TransactionID.Replace("ISHHI", "").ToString());
                }
                if (sms.ToString().Contains("<AdmDate>"))
                {
                    sms.Replace("<AdmDate>", dataColumnInfo[0].AdmDate);
                }
                if (sms.ToString().Contains("<Ward>"))
                {
                    sms.Replace("<Ward>", dataColumnInfo[0].Ward);
                }
                if (sms.ToString().Contains("<Amount>"))
                {
                    sms.Replace("<Amount>", dataColumnInfo[0].Amount);
                }
                if (sms.ToString().Contains("<CentreName>"))
                {
                    sms.Replace("<CentreName>", dtCentre.Rows[0]["CentreName"].ToString());
                }
                if (sms.ToString().Contains("<CentreWebsite>"))
                {
                    sms.Replace("<CentreWebsite>", dtCentre.Rows[0]["Website"].ToString());
                }
                if (sms.ToString().Contains("<CentreContactNo>"))
                {
                    sms.Replace("<CentreContactNo>", dtCentre.Rows[0]["MobileNo"].ToString());
                }
                if (sms.ToString().Contains("<CentreCode>"))
                {
                    sms.Replace("<CentreCode>", dtCentre.Rows[0]["CentreCode"].ToString());
                }
                if (sms.ToString().Contains("<FromWard>"))
                {
                    sms.Replace("<FromWard>", dataColumnInfo[0].FromWard.ToString());
                }
                if (con != null)
                {
                    Sms_Host SH = new Sms_Host(con);
                    SH._DoctorID = dataColumnInfo[0].DoctorID;
                    SH._EmployeeID = "";
                    SH._Msg = sms.ToString(); ;
                    SH._PatientID = dataColumnInfo[0].PatientID;
                    SH._SmsTo = dataColumnInfo[0].ContactNo;
                    SH._smsType = smsType;
                    SH._TemplateID = templateID;
                    SH._UserID = UserID;
                    SH._CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    int IsSend = SH.sendSms();
                    return Util.GetString(IsSend);
                }
                else
                {
                    Sms_Host SH = new Sms_Host();
                    SH._DoctorID = dataColumnInfo[0].DoctorID;
                    SH._EmployeeID = "";
                    SH._Msg = sms.ToString(); ;
                    SH._PatientID = dataColumnInfo[0].PatientID;
                    SH._SmsTo = dataColumnInfo[0].ContactNo;
                    SH._smsType = smsType;
                    SH._TemplateID = templateID;
                    SH._UserID = UserID;
                    SH._CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    int IsSend = SH.sendSms();
                    return Util.GetString(IsSend);
                }
            }
            else
            {
                return "0";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    public static List<smsTemplateInfo> getColumnInfo(int templateID, MySqlConnection con)
    {
        string columnInfo = "";
        if (con != null)
            columnInfo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ColumnInfo From sms_master WHERE active=1 AND templateID='" + templateID + "'"));
        else
            columnInfo = Util.GetString(StockReports.ExecuteScalar("SELECT ColumnInfo From sms_master WHERE active=1 AND templateID='" + templateID + "'"));

        List<smsTemplateInfo> list = new List<smsTemplateInfo>();
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

            list = ConvertDataTable<smsTemplateInfo>(table);
        }
        return list;
    }

    private static List<T> ConvertDataTable<T>(DataTable dt)
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
}