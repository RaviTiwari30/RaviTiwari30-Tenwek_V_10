using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_TechnicianMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {            
            //LastUpdatedby,UpdateDate,IPAddress
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
            LoadData();
        }
        lblMsg.Text = "";
    }

    private void BindEmployee()
    {
        ddlEmployee.Items.Clear();
        ddlEmployee.DataSource = null;
        ddlEmployee.DataBind();

        string str = "SELECT Name EmployeeName,Employee_ID from Employee_master Where isActive=1";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlEmployee.DataSource = dt;
            ddlEmployee.DataTextField = "EmployeeName";
            ddlEmployee.DataValueField = "Employee_ID";
            ddlEmployee.DataBind();
            ddlEmployee.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            
        }
    }

    private void LoadData()
    {
        grdTechnician.DataSource = null;
        grdTechnician.DataBind();

        string str = "SELECT fm.TechnicianID,fm.TechnicianName,fm.TechnicianCode,fm.Description,fm.Designation,if(fm.IsEmployee=1,'YES','NO')IsEmployee,";
        str += "(SELECT Name FROM Employee_master WHERE Employee_ID=fm.Employee_ID)EmployeeName,";
        str += "IF(fm.IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE fm.LastUpdatedby=employee_ID)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(fm.UpdateDate,'%T'))UpdateDate,";
        str += "fm.IPAddress FROM eq_Technician_master fm ";

        DataTable dt = StockReports.GetDataTable(str);

        grdTechnician.DataSource = dt;
        grdTechnician.DataBind();
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (CheckValidation())
        {   
            MySqlConnection conn = Util.GetMySqlCon();
            conn.Open();
            MySqlTransaction tnx = conn.BeginTransaction();
            
            try
            {                
                string str = "",EmpID="";
                int IsActive = 0,IsEmployee=0;

                if (chkActive.Checked)
                    IsActive = 1;

                if (chkIsEmployee.Checked)
                {
                    IsEmployee = 1;
                    EmpID = ddlEmployee.SelectedValue;
                }
                if (ViewState["IsUpdate"].ToString() == "S")
                {
                    str = "Insert into eq_Technician_master(TechnicianName,TechnicianCode,Description,Designation,IsEmployee,Employee_ID,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    str += "value('" + txtname.Text.Trim() + "','" + txtCode.Text.Trim() + "','" + txtDescription.Text.Trim() + "',";
                    str += "'" + txtDesignation.Text.Trim() + "'," + IsEmployee + ",'" + EmpID + "',";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";

                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=fm.LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(fm.UpdateDate,'%T')),'</BR>Ip Address : ',fm.IPAddress,'</BR>" +
                    "Name : ',fm.TechnicianName,', Code : ',fm.TechnicianCode,', Designation : ',fm.Designation,', Is A Employee : ',if(fm.IsEmployee=1,'YES','NO')," +
                    "', Employee : ' ,IFNULL((SELECT Name FROM Employee_master WHERE Employee_ID=fm.Employee_ID LIMIT 1),''),', Active : ',IF(fm.IsActive=1,'Yes','No'),'</BR>" +
                    "Description : ' ,fm.Description)DataLog " +
                    "FROM eq_Technician_master fm WHERE TechnicianID=" + ViewState["TechnicianID"].ToString() + " ");
                    

                    str = "Update eq_Technician_master Set TechnicianName='" + txtname.Text.Trim() + "',TechnicianCode='" + txtCode.Text.Trim() + "',";
                    str += "Designation='" + txtDesignation.Text.Trim() + "',IsEmployee=" + IsEmployee + ",Employee_ID='" + EmpID + "',";
                    str += "IsActive = " + IsActive + ",Description='" + txtDescription.Text.Trim() + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where TechnicianID=" + ViewState["TechnicianID"].ToString() + " ";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved";
                ViewState["TechnicianID"] = "";
                ViewState["IsUpdate"] = "S";
                btnsave.Text = "Save";
                ClearFields();
                LoadData();

            }
            catch (Exception ex)
            {
                tnx.Rollback();
                conn.Close();
                conn.Dispose();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = ex.Message;
            }
        }
    }

    private void Commit()
    {
        throw new NotImplementedException();
    }    

    private bool CheckValidation()
    {
        if (chkIsEmployee.Checked==true && ddlEmployee.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select Employee";
            return false;
        }

        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Technician Name";
            return false;
        }

        if (txtCode.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Technician Code";
            return false;
        }

        if (txtDesignation.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Technician Designation";
            return false;
        }

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            string isExist = StockReports.ExecuteScalar("SElECT TechnicianName from eq_Technician_master Where TechnicianName ='"+txtname.Text.Trim()+"'");

            if (isExist != string.Empty)
            {
                lblMsg.Text = "Duplicate Record Exist";
                return false;
            }

        }
        return true;
    }

    private void ClearFields()
    {        
        txtname.Text = "";
        txtCode.Text = "";
        txtDescription.Text = "";
        txtDesignation.Text = "";
        chkIsEmployee.Checked = false;
        ddlEmployee.Items.Clear();
    }

    protected void grdTechnician_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string TechnicianID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_Technician_master WHERE TechnicianID=" + TechnicianID);
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsEmployee"].ToString() == "1")
                {
                    DataTable dtEmp = StockReports.GetDataTable("Select Employee_ID,name from employee_master where IsActive=1 order by Name");

                    if (dtEmp != null && dtEmp.Rows.Count > 0)
                    {
                        ddlEmployee.DataSource = dtEmp;
                        ddlEmployee.DataTextField = "Name";
                        ddlEmployee.DataValueField = "Employee_ID";
                        ddlEmployee.DataBind();
                        ddlEmployee.SelectedIndex = ddlEmployee.Items.IndexOf(ddlEmployee.Items.FindByValue(dt.Rows[0]["Employee_ID"].ToString()));
                    }
                    chkIsEmployee.Checked = true;
                }
                else
                    chkIsEmployee.Checked = false;


                txtname.Text = dt.Rows[0]["TechnicianName"].ToString();
                txtCode.Text = dt.Rows[0]["TechnicianCode"].ToString();
                txtDescription.Text = dt.Rows[0]["Description"].ToString();
                txtDesignation.Text = dt.Rows[0]["Designation"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["TechnicianID"] = TechnicianID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_Technician_master WHERE TechnicianID=" + TechnicianID);
            mdpLog.Show();
        }
    }

    protected void chkIsEmployee_CheckedChanged(object sender, EventArgs e)
    {
        BindEmployee();
    }
}