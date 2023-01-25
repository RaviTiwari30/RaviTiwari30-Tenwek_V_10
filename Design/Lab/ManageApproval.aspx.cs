using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_ManageApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            All_LoadData.bindRole(DDroleid, "Select");
            All_LoadData.bindEmployee(ddlTecnicianID, "Select");
            BindEmployee();
        }
    }
    private void BindEmployee()
    {
        try
        {
            string str;
            if (Session["RoleID"].ToString() == "11")
            {
                str = "SELECT em.EmployeeID,em.NAME FROM employee_master em  INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID INNER JOIN doctor_employee de ON de.EmployeeID = em.EmployeeID WHERE em.IsActive = 1 AND fl.RoleID='11' AND fl.`CentreID`='" + Session["CentreID"].ToString() + "' ORDER BY NAME";
            }
            else if (Session["RoleID"].ToString() == "104")
            {
                str = "SELECT em.EmployeeID,em.NAME FROM employee_master em  INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID INNER JOIN doctor_employee de ON de.EmployeeID = em.EmployeeID WHERE em.IsActive = 1 AND fl.RoleID='104' AND fl.`CentreID`='" + Session["CentreID"].ToString() + "' ORDER BY NAME";
            }
            else
            {
                str = "SELECT em.EmployeeID,em.NAME FROM employee_master em  INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID INNER JOIN doctor_employee de ON de.EmployeeID = em.EmployeeID WHERE em.IsActive = 1 AND fl.RoleID IN (11,104) AND fl.`CentreID`='"+ Session["CentreID"].ToString() + "' ORDER BY NAME";
            }
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlEmployee.DataSource = dt;
                ddlEmployee.DataTextField = "Name";
                ddlEmployee.DataValueField = "EmployeeID";
                ddlEmployee.DataBind();
                ddlEmployee.Items.Insert(0, "Select");
            }
            else
            {
                ddlEmployee.Items.Clear();
            }
        }
        catch
        { }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindgrid()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT if(ap.DefaultSignature=0,'No','Yes') DefaultSignature, Ap.Id AS id,Ap.Roleid,Ap.EmployeeID,Rm.RoleName as Rolename,em.NAME as empName,ifnull((SELECT NAME FROM employee_master WHERE EmployeeID=ap.TechnicalId),'')TechName,case when ap.Approval=1 then 'Approve' when ap.Approval=2 then 'Forward' when ap.Approval=3 then 'Aprrove & NotApprove' when Approval=5 then 'Result Entry' else 'Aprrove & NotApprove & Unhold' end AS Authority FROM f_approval_labemployee Ap INNER JOIN f_rolemaster rm ON ap.roleId=rm.id INNER JOIN employee_master em ON em.EmployeeID=Ap.EmployeeId  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string DefaultSignature = "0";
        if (chisdefault.Checked)
        {
            DefaultSignature = "1";
        }
        try
        {
            
            string strr = "SELECT Roleid FROM f_approval_labemployee WHERE employeeID='" + ddlEmployee.SelectedValue + "' and TechnicalId='" + ddlTecnicianID.SelectedValue + "'";
            DataTable dt = StockReports.GetDataTable(strr);
            if (dt != null && dt.Rows.Count > 0)
            {
                string str = "INSERT INTO f_approval_labemployee(RoleID,EmployeeID,Approval,TechnicalId,CreatedBy,CreatedByID,DefaultSignature) VALUES ('" + DDroleid.SelectedValue + "','" + ddlEmployee.SelectedValue + "'," + rblApproval.SelectedItem.Value.ToString() + ",'" + ddlTecnicianID.SelectedValue + "','" + HttpContext.Current.Session["LoginName"].ToString() + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + DefaultSignature + "')";
                if (dt.Rows[0]["Roleid"].ToString() == DDroleid.SelectedValue.ToString())
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "key1", "modelAlert('This Role ID and Technician is Already Engaged to this Employee');", true);
                    return;
                }

               StockReports.ExecuteDML(str);
               bindgrid();
            }
            else
            {
                SaveSign();
                string str = "INSERT INTO f_approval_labemployee(RoleID,EmployeeID,Approval,TechnicalId,CreatedBy,CreatedByID,DefaultSignature) VALUES ('" + DDroleid.SelectedValue + "','" + ddlEmployee.SelectedValue + "','" + rblApproval.SelectedItem.Value.ToString() + "','" + ddlTecnicianID.SelectedValue + "','" + HttpContext.Current.Session["LoginName"].ToString() + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + DefaultSignature + "')";
                StockReports.ExecuteDML(str);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "key2", "modelAlert('Record Saved Successfully');", true);
                chisdefault.Checked = false;
            }
            bindgrid();

        }
        catch
        { }
    }

    private void SaveSign()
    {
        if (fuSign.PostedFile.ContentLength > 0)
        {
            fuSign.SaveAs(Server.MapPath("~/Design/LAB/Signature/" + ddlEmployee.SelectedValue + ".jpg"));
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string removeSign(string ID)
    {
        try
        {
            string str = "DELETE FROM f_approval_labemployee WHERE ID=" + ID.Trim() + "";
            StockReports.ExecuteDML(str);
            return "1";
        }
        catch
        {
            ClassLog cl = new ClassLog();
            return "0";
        }
    }

    
}