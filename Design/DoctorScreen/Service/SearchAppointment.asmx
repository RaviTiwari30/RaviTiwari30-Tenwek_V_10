<%@ WebService Language="C#"  Class="SearchAppointment" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;


/// <summary>
/// Summary description for Search_Appointment
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class SearchAppointment : System.Web.Services.WebService
{

    public SearchAppointment()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

    public string LoadAppointment(string DoctorID)
    {
        AllSelectQuery AQ = new AllSelectQuery();
        DataTable dt = AQ.GetDoctorScreen_Appointment(DoctorID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

    public string LoadAll_InOutPatient(string DoctorID)
    {
        AllSelectQuery AQ = new AllSelectQuery();
        DataTable dt = AQ.LoadAll_InOutPatient(DoctorID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    
    public string LoadAll_OnlinePatient(string DoctorID)
    {
        AllSelectQuery AQ = new AllSelectQuery();
        DataTable dt = AQ.LoadAll_OnlinePatient(DoctorID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadAppointment_PType(string DoctorID, string P_Type)
    {
        AllSelectQuery AQ = new AllSelectQuery();            
        DataTable dt = AQ.GetDoctorScreen_Appointment_PType(DoctorID, P_Type);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateCall(string App_ID, string DoctorID)
    {
        Doctor_Screen DS = new Doctor_Screen();
        string Ret = DS.UpdateCall(App_ID, DoctorID);
        return Ret;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateUncall(string App_ID)
    {
        Doctor_Screen DS = new Doctor_Screen();
        string Ret = DS.UpdateUncall(App_ID);
        return Ret;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Hold(string App_ID)
    {
        Doctor_Screen DS = new Doctor_Screen();
        string Ret = DS.Hold(App_ID);
        return Ret;
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateIn(string App_ID, string DoctorID)
    {
        Doctor_Screen DS = new Doctor_Screen();
        string Ret = DS.UpdateIn(App_ID, DoctorID);
        return Ret;
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateOut(string App_ID, string DoctorID)
    {
        Doctor_Screen DS = new Doctor_Screen();
        string Ret = DS.UpdateOut(App_ID, DoctorID);
        return Ret;
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadDoctor(string date)
    {
        date = DateTime.Now.ToString("yyyy-MM-dd");
        Doctor_Screen DS = new Doctor_Screen();
        return Newtonsoft.Json.JsonConvert.SerializeObject(DS.LoadDoctor(date));
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadPatient(string date, string DocID)
    {
        date = DateTime.Now.ToString("yyyy-MM-dd");
        Doctor_Screen DS = new Doctor_Screen();
        return Newtonsoft.Json.JsonConvert.SerializeObject(DS.LoadPatient(date, DocID));
    }
    
    public string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        if (table.Rows.Count > 0)
        {

            foreach (DataRow dr in table.Rows)
            {
                if (sb.Length != 0)
                    sb.Append(",");
                sb.Append("{");
                StringBuilder sb2 = new StringBuilder();
                foreach (DataColumn col in table.Columns)
                {
                    string fieldname = col.ColumnName;
                    string fieldvalue = dr[fieldname].ToString();
                    if (sb2.Length != 0)
                        sb2.Append(",");
                    sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));
                }
                sb.Append(sb2.ToString());
                sb.Append("}");


            }
            if (e == makejson.e_with_square_brackets)
            {
                sb.Insert(0, "[");
                sb.Append("]");
            }
        }
            return sb.ToString();

        
    }

}

