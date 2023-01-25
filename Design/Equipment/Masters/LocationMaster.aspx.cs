using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_LocationMaster : System.Web.UI.Page
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
            BindFloor();
            chkActive.Checked = true;
            chkActive.Enabled = false;

        }
        lblMsg.Text = "";
    }

    private void BindFloor()
    {
        string str = "SELECT FloorID,FloorName FROM eq_floor_master WHERE IsActive=1";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            ddlFloor.DataSource = dt;
            ddlFloor.DataTextField = "FloorName";
            ddlFloor.DataValueField = "FloorID";
            ddlFloor.DataBind();
            ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        
        }
    }

   

    private void LoadData()
    {
        grdLocation.DataSource = null;
        grdLocation.DataBind();

        string str = "SELECT fm.LocationID,fm.LocationName,fm.LocationCode,fm.Description,";        
        str += "(SELECT FloorName FROM eq_floor_master WHERE FloorID= fm.FloorID )FloorName,IF(fm.IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE fm.LastUpdatedby=employee_ID)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(fm.UpdateDate,'%T'))UpdateDate,";
        str += "fm.IPAddress FROM eq_Location_master fm ORDER BY fm.LocationName ";

        DataTable dt = StockReports.GetDataTable(str);

        grdLocation.DataSource = dt;
        grdLocation.DataBind();
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (CheckValidation())
        {

            //string str1 = Util.GetString(StockReports.ExecuteScalar("Select LocationName eq_location_master where LocationName like'" + txtname.Text + "%'"));
            //{
            //    lblMsg.Text = "This Name is already Used";
            //    return;
            //}
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
                    str = "Insert into eq_Location_master(LocationName,LocationCode,Description,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    str += "value('" + txtname.Text.Trim().Replace("'", "") + "','" + txtCode.Text.Trim() + "','" + txtDescription.Text.Trim() + "',";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";
                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=fm.LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(fm.UpdateDate,'%T')),'</BR>Ip Address : ',fm.IPAddress,'</BR>" +
                    "Name : ',fm.LocationName,', Code : ',fm.LocationCode,', Active : ',IF(fm.IsActive=1,'Yes','No'),'</BR>" +
                    "Description : ' ,fm.Description)DataLog " +
                    "FROM eq_Location_master fm WHERE LocationID=" + ViewState["LocationID"].ToString() + " ");


                    str = "Update eq_Location_master Set LocationName='" + txtname.Text.Trim() + "',LocationCode='" + txtCode.Text.Trim() + "' , ";
                    str += "IsActive = " + IsActive + ",Description='" + txtDescription.Text.Trim() + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where LocationID=" + ViewState["LocationID"].ToString() + " ";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved Successfully";
                ViewState["LocationID"] = "";
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
        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Enter Location Name";
            txtname.Focus();
            return false;
        }

        //if (ddlFloor.SelectedValue.ToUpper() == "SELECT")
        //{
        //    lblMsg.Text = "Select Floor";
        //    ddlFloor.Focus();
        //    return false;
        //}
        
        //if (txtCode.Text.Trim() == "")
        //{
        //    lblMsg.Text = "Provide Location Code";
        //    return false;
        //}

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            int isExist = 0;
            isExist = Util.GetInt(StockReports.ExecuteScalar("SElECT LocationName from eq_Location_master Where LocationName ='"+txtname.Text.Trim()+"'"));
            
            if (isExist>0)
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
        ddlFloor.SelectedIndex = 0;
        txtname.Text = "";
        txtCode.Text = "";
        txtDescription.Text = "";
    }

    protected void grdLocation_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string LocationID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_Location_master WHERE LocationID=" + LocationID);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlFloor.SelectedIndex = ddlFloor.Items.IndexOf(ddlFloor.Items.FindByValue(dt.Rows[0]["FloorID"].ToString()));
                txtname.Text = dt.Rows[0]["LocationName"].ToString();
                txtCode.Text = dt.Rows[0]["LocationCode"].ToString();
                txtDescription.Text = dt.Rows[0]["Description"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["LocationID"] = LocationID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";                
                chkActive.Enabled = true;
                txtDescription.Focus();
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_Location_master WHERE LocationID=" + LocationID);
            mdpLog.Show();
        }
    }
   
}