<%@ WebService Language="C#" Class="WelcomeDashboardSettings" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WelcomeDashboardSettings  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }



    [WebMethod]
    public  string GetWelcomeFunctionMaster()
    {
        var dt = StockReports.GetDataTable("SELECT fm.Function_Name,fm.Display_Name FROM welcome_functions_master fm WHERE  fm.Is_Active=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public  string SaveWelcomeLabel(object data)
    {
        try
        {
            dynamic labelDetails = JObject.Parse(JsonConvert.SerializeObject(data));
            var sqlCmd = "INSERT INTO welcome_labels (Label_Text,Label_Icon,Label_FunctionName,Created_By) VALUES('" + labelDetails.labelName + "','" + labelDetails.labelIcon + "','" + labelDetails.labelValueFunction + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
            var result = StockReports.ExecuteDML(sqlCmd);
            if (result)
                return JsonConvert.SerializeObject(new { status = true, message = "Save Successfully" });
            else
                return JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator" });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator", errorMessage = ex.Message });
        }
    }



    [WebMethod]
    public string UpdateWelcomeLabel(object data)
    {
        try
        {
            dynamic labelDetails = JObject.Parse(JsonConvert.SerializeObject(data));
            var sqlCmd = "UPDATE  welcome_labels SET Label_Text='" + labelDetails.labelName + "',Label_Icon='" + labelDetails.labelIcon + "',Label_FunctionName='" + labelDetails.labelValueFunction + "'   WHERE id=" + labelDetails.id;
            var result = StockReports.ExecuteDML(sqlCmd);
            if (result)
                return JsonConvert.SerializeObject(new { status = true, message = "Update Successfully" });
            else
                return JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator" });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator", errorMessage = ex.Message });
        }
    }


    [WebMethod]
    public string DeleteWelcomeLabel(int labelID)
    {
        try
        {

            var sqlCmd = "UPDATE  welcome_labels SET IsActive=0 WHERE id=" + labelID;
            var result = StockReports.ExecuteDML(sqlCmd);
            if (result)
                return JsonConvert.SerializeObject(new { status = true, message = "Delete  Successfully" });
            else
                return JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator" });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator", errorMessage = ex.Message });
        }
    }
    
    
    
    

    [WebMethod]
    public  string GetWelcomeLabels()
    {
        var dt = StockReports.GetDataTable("SELECT wl.ID,wl.Label_Text  FROM welcome_labels wl WHERE wl.IsActive=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public  string GetActiveEmployees()
    {
        var dt = StockReports.GetDataTable("SELECT EmployeeID as Employee_ID,CONCAT(emp.Title,' ',emp.NAME)EmpName FROM employee_master emp WHERE emp.IsActive=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public  string GetLabelDetails(int labelID)
    {
        var dt = StockReports.GetDataTable("SELECT wl.ID,wl.Label_Text,wl.Label_Icon,wl.Label_FunctionName FROM welcome_labels wl WHERE wl.ID=" + labelID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public  string SaveLabelsForEmployee(object data)
    {
        try
        {
            dynamic labelDetails = JObject.Parse(JsonConvert.SerializeObject(data));
            var sqlCmd = "INSERT INTO welcome_Labels_EmpWise (EmployeeID,Label_ID,Created_by) VALUES('" + labelDetails.emp_ID + "','" + labelDetails.label_ID + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
            var result = StockReports.ExecuteDML(sqlCmd);
            //if (result)
            //{
            //    var dt = StockReports.GetDataTable("SELECT wl.ID,wl.Label_Text,wl.Label_Icon FROM welcome_labels wl WHERE wl.ID=" + labelDetails.label_ID);
            //    return JsonConvert.SerializeObject(new { status = true, label = dt });
            //}
            if(result)
                return JsonConvert.SerializeObject(new { status = true});
            else
                return JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator" });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator", errorMessage = ex.Message });
        }

    }
    
    [WebMethod(EnableSession = true)]
    public string DeleteEmployeeLabel(int labelID) {
        try
        {
            var sqlCmd = "UPDATE welcome_Labels_EmpWise SET isActive=0  WHERE  id=" + labelID;
            var result = StockReports.ExecuteDML(sqlCmd);
            if (result)
                return JsonConvert.SerializeObject(new { status = true, message = "Delete  Successfully" });
            else
                return JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator" });
        }
        catch (Exception ex)
        {

            return JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator", errorMessage = ex.Message });
        }
    }
    
    
    

    [WebMethod]
    public  string GetLabelsEmployeeWise(string userID)
    {
        var sqlCmd = "SELECT le.ID, wl.Label_Text, wl.Label_Icon, wl.Label_FunctionName FROM welcome_Labels_EmpWise le INNER JOIN welcome_labels wl ON le.Label_ID = wl.ID WHERE wl.IsActive=1 AND le.IsActive=1 AND le.EmployeeID = '" + userID + "'";
        var dt = StockReports.GetDataTable(sqlCmd);
        return JsonConvert.SerializeObject(dt);
    }
    
    
    
}