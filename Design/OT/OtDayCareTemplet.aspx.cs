using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OT_OtDayCareTemplet : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblPatientID.Text = Convert.ToString(Request.QueryString["CorpseID"]);//Corpse Id is recived from PID

            if (Request.QueryString["TransactionID"].ToString() != null && Request.QueryString["TransactionID"].ToString() != string.Empty)
                lblTransactionID.Text = Convert.ToString(Request.QueryString["TransactionID"]);   
            else
                lblTransactionID.Text = Convert.ToString(Request.QueryString["TransactionID"]);  

            string DoctorID = StockReports.ExecuteScalar("SELECT doctorId from doctor_employee where Employeeid='" + Convert.ToString(Session["ID"]) + "'");

            if (DoctorID == "")
            {
                lblDoctorID.Text = "0";
            }
            lblDoctorID.Text = Util.GetString(DoctorID);
            
        }
    }

    [WebMethod]
    public static string bindPatientConsent(string patientID)
    {
        StringBuilder sqlCmd = new StringBuilder(" SELECT p.ID, p.`TypeID`,p.`Patient_ID`,pcftm.`Name` AS ConsentType, pm.CName AS PatientName, ");
        sqlCmd.Append(" p.`Content`,TIME_TO_SEC( TIMEDIFF(NOW(),p.`EntryDate`))/(60*60) Timehours , DATE_FORMAT(p.`EntryDate`,'%d-%b-%y %h:%i %p') AS EntryDate,DATE_FORMAT(p.`UpdatedDate`,'%d-%b-%y %h:%i %p') AS UpdatedDate,(SELECT CONCAT(em.`Title`,' ',em.`Name`) AS UpdatedBy FROM employee_master em WHERE em.`EmployeeID`=p.UpdatedBy) UpdatedBy ,CONCAT(em.`Title`,' ',em.`Name`) AS EntryBy,if(em.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "','block','none')IsVisible ");
        sqlCmd.Append(" FROM patient_consentform_data_mo p  ");
        sqlCmd.Append(" INNER JOIN employee_master em ON em.`EmployeeID`=p.`EntryBy` ");
        sqlCmd.Append(" INNER JOIN mo_patient_consent_form_Type_Master pcftm ON pcftm.`ID`=p.`TypeID` ");
        sqlCmd.Append(" INNER JOIN mortuary_corpse_master pm ON pm.`Corpse_ID`=p.`OtId` ");
        sqlCmd.Append(" WHERE p.`IsActive`=1 AND p.`OtId`='" + patientID + "' ");

        DataTable dt = StockReports.GetDataTable(sqlCmd.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string BindConsentType(string doctorID)
    {
        StringBuilder sb = new StringBuilder("SELECT ID,Name FROM mo_patient_consent_form_type_master WHERE IsActive=1 ");
        if (doctorID != "0")
            sb.Append(" and Doctor_ID='" + doctorID + "' ");

        sb.Append("  ORDER BY Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string BindTemplate(string doctorID)
    {
        StringBuilder sb = new StringBuilder("SELECT Template_ID,Template_Name FROM mo_patient_consent_template WHERE IsActive=1 ");
        if (doctorID != "0")
            sb.Append(" and Doctor_ID='" + doctorID + "' ");

        sb.Append(" ORDER BY Template_Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string BindTemplateContent(int templateId)
    {
        DataTable dt = StockReports.GetDataTable("SELECT Template_Desc FROM mo_patient_consent_template WHERE Template_ID=" + templateId + " and IsActive=1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public static string DeleteSelectedTemplate(int templateId, string doctorID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            ExcuteCMD excuteCMD = new ExcuteCMD();
            int isSelfType = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT if(s.Doctor_ID='" + doctorID + "',1,0) FROM mo_patient_consent_template s WHERE s.`IsActive`=1 AND s.`Template_ID`=" + templateId + " "));
            if (isSelfType == 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You can delete your's Template" });

            sqlQuery = "UPDATE mo_patient_consent_template SET IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=now() WHERE Template_ID=@templateId";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                templateId = templateId,
                UpdatedBy = HttpContext.Current.Session["ID"].ToString()
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Deleted Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveConsentType(int type, string typeID, string typeName, string doctorID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            ExcuteCMD excuteCMD = new ExcuteCMD();
            int IsExist = 0;
            if (type == 1)
                IsExist = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM mo_patient_consent_form_type_master s WHERE s.`Name`='" + typeName + "' AND s.`IsActive`=1 "));
            else if (type == 2)
                IsExist = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM mo_patient_consent_form_type_master s WHERE s.`Name`='" + typeName + "' AND s.`IsActive`=1  AND s.`ID`<>" + typeID + " "));

            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Type Name already Exist." });
            }

            if (type != 1)
            {
                int isSelfType = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT if(s.Doctor_ID='" + doctorID + "',1,0) FROM mo_patient_consent_form_type_master s WHERE s.`Name`='" + typeName + "' AND s.`IsActive`=1 and s.Doctor_ID='" + doctorID + "' AND s.`ID`<>" + typeID + " "));
                if (isSelfType == 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You can edit or delete your's Consent Type" });

            }
            if (type == 1)
            {
                sqlQuery = "INSERT INTO mo_patient_consent_form_type_master(`Name`,EntryBy,EntryDateTime,Doctor_ID) VALUES(@Name,@EntryBy,NOW(),@Doctor_ID)";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    Name = typeName,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    Doctor_ID = doctorID
                });
            }
            if (type == 2)
            {

                sqlQuery = "UPDATE mo_patient_consent_form_type_master SET Name=@TypeName,UpdatedBy=@UpdatedBy,UpdatedDateTime=now() WHERE ID=@TypeID";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TypeName = typeName,
                    TypeID = typeID,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            if (type == 3)
            {
                sqlQuery = "UPDATE mo_patient_consent_form_type_master SET IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=now() WHERE ID=@TypeID";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TypeID = typeID,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            tnx.Commit();
            if (type == 1)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
            else if (type == 2)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Deleted Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SavePatientConsent(int type, int consentId, string transactionId, string patientID, string typeID, string content, string templateName, int isSaveAsTemplate, string doctorID, int appID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            ExcuteCMD excuteCMD = new ExcuteCMD();
            if (type == 1)
            {




                sqlQuery = "INSERT INTO patient_consentform_data_mo(TypeID,Content,EntryBy,OtId,Patient_ID,OtBookingNumber)  ";
                sqlQuery += "VALUES(" + Util.GetInt(type) + ",'" + content + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + patientID + "','" + patientID + "','" + transactionId + "' ";
                sqlQuery += " )";

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sqlQuery);


            }
            if (type == 2)
            {

                sqlQuery = "UPDATE patient_consentform_data_mo SET TypeID=@TypeID,Content=@Content,UpdatedBy=@UpdatedBy,UpdatedDate=now() WHERE ID=@ConsentID";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    Content = content,
                    TypeID = typeID,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    ConsentID = consentId
                });
            }
            if (type == 3)
            {
                sqlQuery = "UPDATE patient_consentform_data_mo SET IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDate=now() WHERE ID=@ConsentID";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    ConsentID = consentId
                });
            }

            if (isSaveAsTemplate == 1 && type != 3)
            {
                int IsExist = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM mo_patient_consent_template s WHERE s.`Template_Name`='" + templateName + "' AND s.`IsActive`=1 AND s.Doctor_ID='" + doctorID + "' "));
                if (IsExist > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Template Name already Exist." });
                }

                sqlQuery = "INSERT INTO mo_patient_consent_template(Template_Desc,Template_Name,EntryBy,EntryDateTime,Doctor_ID) VALUES(@Template_Desc,@Template_Name,@EntryBy,now(),@Doctor_ID) ";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    Template_Desc = content,
                    Template_Name = templateName,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    Doctor_ID = doctorID
                });
            }

            tnx.Commit();
            if (type == 1)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
            else if (type == 2)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Deleted Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



}