using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_MaintenanceMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindMaintenanceType();
            //LastUpdatedby,UpdateDate,IPAddress
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
            LoadData();
        }
        lblMsg.Text = "";
    }

    private void BindMaintenanceType()
    {
        string str = " SELECT MaintenanceTypeName,MaintenanceTypeID FROM eq_Maintenancetype_master WHERE Isactive=1";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlMaintenanceType.DataSource = dt;
            ddlMaintenanceType.DataTextField = "MaintenanceTypeName";
            ddlMaintenanceType.DataValueField = "MaintenanceTypeID";
            ddlMaintenanceType.DataBind();
            ddlMaintenanceType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            
        }
    }

    private void LoadData()
    {
        grdMaintenanceType.DataSource = null;
        grdMaintenanceType.DataBind();

        string str = "SELECT EM.MaintenanceID,EM.MaintenanceName,EM.MaintenanceCode,";
        str += "(SELECT MaintenanceTypeName FROM eq_Maintenancetype_master WHERE MaintenanceTypeID=EM.MaintenanceTypeID)MaintenanceType,";
        str += "IF(EM.IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE EM.LastUpdatedby=employee_ID)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(EM.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(EM.UpdateDate,'%T'))UpdateDate,";
        str += "IPAddress FROM eq_Maintenance_master EM";

        DataTable dt = StockReports.GetDataTable(str);

        grdMaintenanceType.DataSource = dt;
        grdMaintenanceType.DataBind();
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
                string str = "";
                int IsActive = 0;

                if (chkActive.Checked)
                    IsActive = 1;

                if (ViewState["IsUpdate"].ToString() == "S")
                {
                    str = "Insert into eq_Maintenance_master(MaintenanceName,MaintenanceCode,MaintenanceTypeID,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    str += "value('" + txtname.Text.Trim() + "','" + txtCode.Text.Trim() + "','" + ddlMaintenanceType.SelectedValue + "',";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";

                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(UpdateDate,'%T')),'</BR>Ip Address : ',IPAddress,'</BR>" +
                    "Name : ',MaintenanceName,', Code : ',MaintenanceCode," +
                    "', MaintenanceType : ' ,(SELECT MaintenanceTypename FROM eq_Maintenancetype_master WHERE MaintenanceTypeID=MaintenanceTypeID LIMIT 1),', Active : ',IF(IsActive=1,'Yes','No'))DataLog " +
                    "FROM eq_Maintenance_master WHERE MaintenanceID=" + ViewState["MaintenanceID"].ToString() + " ");
                    

                    str = "Update eq_Maintenance_master Set MaintenanceName='" + txtname.Text.Trim() + "',MaintenanceCode='" + txtCode.Text.Trim() + "',";
                    str += "IsActive = " + IsActive + ",MaintenanceTypeID='" + ddlMaintenanceType.SelectedValue + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where MaintenanceID=" + ViewState["MaintenanceID"].ToString() + " ";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved";
                ViewState["MaintenanceID"] = "";
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
        if (ddlMaintenanceType.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select Maintenance Type";
            return false;
        }

        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Approval Type Name";
            return false;
        }

        if (txtCode.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Approval Type Code";
            return false;
        }

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            string isExist = StockReports.ExecuteScalar("SElECT MaintenanceName from eq_Maintenance_master Where MaintenanceName ='"+txtname.Text.Trim()+"'");

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
        ddlMaintenanceType.SelectedIndex = 0;
        txtname.Text = "";
        txtCode.Text = "";
    }

    protected void grdMaintenanceType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string MaintenanceID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditAT")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_Maintenance_master WHERE MaintenanceID=" + MaintenanceID);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlMaintenanceType.SelectedIndex = ddlMaintenanceType.Items.IndexOf(ddlMaintenanceType.Items.FindByValue(dt.Rows[0]["MaintenanceTypeID"].ToString()));
                txtname.Text = dt.Rows[0]["MaintenanceName"].ToString();
                txtCode.Text = dt.Rows[0]["MaintenanceCode"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["MaintenanceID"] = MaintenanceID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_Maintenance_master WHERE MaintenanceID=" + MaintenanceID);
            mdpLog.Show();
        }
    }
}