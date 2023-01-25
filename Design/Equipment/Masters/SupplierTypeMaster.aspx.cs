using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_SupplierTypeMaster : System.Web.UI.Page
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
            chkActive.Checked = true;
            chkActive.Enabled = false;
            txtname.Focus();
        }
        lblMsg.Text = "";
    }   

    private void LoadData()
    {
        grdSupplierType.DataSource = null;
        grdSupplierType.DataBind();

        string str = "SELECT SupplierTypeID,SupplierTypeName,SupplierTypeCode,Description,";        
        str += "IF(IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE LastUpdatedby=employee_ID LIMIT 1)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(UpdateDate,'%T'))UpdateDate,";
        str += "IPAddress FROM eq_Suppliertype_master ORDER BY SupplierTypeName ";

        DataTable dt = StockReports.GetDataTable(str);

        grdSupplierType.DataSource = dt;
        grdSupplierType.DataBind();
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
                    str = "Insert into eq_SupplierType_master(SupplierTypeName,SupplierTypeCode,Description,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    str += "value('" + txtname.Text.Trim().Replace("'","") + "','" + txtCode.Text.Trim() + "','" + txtDescription.Text.Trim() + "', ";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(UpdateDate,'%T')),'</BR>Ip Address : ',IPAddress,'</BR>" +
                    "Name : ',SupplierTypeName,', Code : ',SupplierTypeCode,', Active : ',IF(IsActive=1,'Yes','No'),'</BR>" +
                    "Description : ',Description)DataLog " +
                    "FROM eq_Suppliertype_master WHERE SupplierTypeID=" + ViewState["SupplierTypeID"].ToString() + " ");
                    

                    str = "Update eq_SupplierType_master Set SupplierTypeName='" + txtname.Text.Trim() + "',SupplierTypeCode='" + txtCode.Text.Trim() + "',";
                    str += "IsActive = " + IsActive + ",Description='" + txtDescription.Text.Trim() + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where SupplierTypeID=" + ViewState["SupplierTypeID"].ToString() + " ";

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                    //if (IsActive == 0)
                    //{
                    //    str = "Update f_vendormaster set IsActive=0 Where SupplierTypeID=" + ViewState["SupplierTypeID"].ToString() + " ";
                    //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    //}
                }                

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved Successfully";
                ViewState["SupplierTypeID"] = "";
                ViewState["IsUpdate"] = "S";
                btnsave.Text = "Save";
                chkActive.Checked = true;
                chkActive.Enabled = false;
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

    private bool CheckValidation()
    {
        int SupplierType = 0;
        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Enter Supplier Type Name";
            txtname.Focus();
            return false;
        }

        //if (txtCode.Text.Trim() == "")
        //{
        //    lblMsg.Text = "Provide Supplier Type Code";
        //    return false;
        //}

        //if (ViewState["IsUpdate"].ToString() == "S")
        //{
        //    string isExist = StockReports.ExecuteScalar("SElECT SupplierTypeName from eq_Suppliertype_master Where SupplierTypeName ='"+txtname.Text.Trim()+"'");

        //    if (isExist != string.Empty)
        //    {
        //        lblMsg.Text = "Duplicate Record Exist";
        //        return false;
        //    }

        //}
        if (ViewState["IsUpdate"].ToString() == "S")
        {
            SupplierType = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) FROM eq_Suppliertype_master WHERE SupplierTypeName ='" + txtname.Text.Trim() + "' "));
            if (SupplierType > 0)
            {
                lblMsg.Text = "Duplicate Record Exist";
                txtname.Focus();
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

    protected void grdSupplierType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string SupplierTypeID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditAT")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_Suppliertype_master WHERE SupplierTypeID=" + SupplierTypeID);
            if (dt != null && dt.Rows.Count > 0)
            {                
                txtname.Text = dt.Rows[0]["SupplierTypeName"].ToString();
                txtCode.Text = dt.Rows[0]["SupplierTypeCode"].ToString();
                txtDescription.Text = dt.Rows[0]["Description"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["SupplierTypeID"] = SupplierTypeID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
                chkActive.Enabled = true;
                txtDescription.Focus();
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_Suppliertype_master WHERE SupplierTypeID=" + SupplierTypeID);
            mdpLog.Show();
        }
    }
}