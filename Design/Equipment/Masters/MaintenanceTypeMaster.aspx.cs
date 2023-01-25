using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_MaintenanceTypeMaster : System.Web.UI.Page
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

    private void LoadData()
    {
        grdMaintenanceType.DataSource = null;
        grdMaintenanceType.DataBind();

        string str = "SELECT MaintenanceTypeID,MaintenanceTypeName,MaintenanceTypeCode,Description,";        
        str += "IF(IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE LastUpdatedby=employee_ID)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(UpdateDate,'%T'))UpdateDate,";
        str += "IPAddress FROM eq_Maintenancetype_master ";

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
                    str = "Insert into eq_MaintenanceType_master(MaintenanceTypeName,MaintenanceTypeCode,Description,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    str += "value('" + txtname.Text.Trim() + "','" + txtCode.Text.Trim() + "','" + txtDescription.Text.Trim() + "', ";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";

                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(UpdateDate,'%T')),'</BR>Ip Address : ',IPAddress,'</BR>" +
                    "Name : ',MaintenanceTypeName,', Code : ',MaintenanceTypeCode,', Active : ',IF(IsActive=1,'Yes','No'),'</BR>" +
                    "Description : ',Description)DataLog " +
                    "FROM eq_Maintenancetype_master WHERE MaintenanceTypeID=" + ViewState["MaintenanceTypeID"].ToString() + " ");
                    

                    str = "Update eq_MaintenanceType_master Set MaintenanceTypeName='" + txtname.Text.Trim() + "',MaintenanceTypeCode='" + txtCode.Text.Trim() + "',";
                    str += "IsActive = " + IsActive + ",Description='" + txtDescription.Text.Trim() + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where MaintenanceTypeID=" + ViewState["MaintenanceTypeID"].ToString() + " ";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved";
                ViewState["MaintenanceTypeID"] = "";
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
        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Maintenance Type Name";
            return false;
        }

        if (txtCode.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Maintenance Type Code";
            return false;
        }

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            string isExist = StockReports.ExecuteScalar("SElECT MaintenanceTypeName from eq_Maintenancetype_master Where MaintenanceTypeName ='"+txtname.Text.Trim()+"'");

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
    }

    protected void grdMaintenanceType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string MaintenanceTypeID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditAT")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_Maintenancetype_master WHERE MaintenanceTypeID=" + MaintenanceTypeID);
            if (dt != null && dt.Rows.Count > 0)
            {                
                txtname.Text = dt.Rows[0]["MaintenanceTypeName"].ToString();
                txtCode.Text = dt.Rows[0]["MaintenanceTypeCode"].ToString();
                txtDescription.Text = dt.Rows[0]["Description"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["MaintenanceTypeID"] = MaintenanceTypeID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_Maintenancetype_master WHERE MaintenanceTypeID=" + MaintenanceTypeID);
            mdpLog.Show();
        }
    }
}