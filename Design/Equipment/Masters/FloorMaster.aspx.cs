using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_FloorMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindLocation();
            //LastUpdatedby,UpdateDate,IPAddress
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
            LoadData();
            chkActive.Checked = true;
            chkActive.Enabled = false;
        }
        lblMsg.Text = "";
    }

    private void BindLocation()
    {
        string str = "SELECT LocationName,LocationID from eq_location_master Where isActive=1";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlLocation.DataSource = dt;
            ddlLocation.DataTextField = "LocationName";
            ddlLocation.DataValueField = "LocationID";
            ddlLocation.DataBind();
            ddlLocation.Items.Insert(0, new ListItem("SELECT", "SELECT"));

        }
    }

    private void LoadData()
    {
        grdFloor.DataSource = null;
        grdFloor.DataBind();

        string str = "SELECT fm.FloorID,fm.FloorName,fm.FloorCode,fm.Description,";
        str += "(SELECT LocationName FROM eq_location_master WHERE LocationID=fm.LocationID)LocationName,";
        str += "IF(fm.IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE fm.LastUpdatedby=employee_ID)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(fm.UpdateDate,'%T'))UpdateDate,";
        str += "fm.IPAddress FROM eq_floor_master fm ORDER BY fm.FloorName ";

        DataTable dt = StockReports.GetDataTable(str);

        grdFloor.DataSource = dt;
        grdFloor.DataBind();
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (CheckValidation())
        {
            //string str1 = Util.GetString(StockReports.ExecuteScalar("Select FloorName from eq_floor_master where FloorName like '" + txtname.Text + "%' "));
            //{
            //    lblMsg.Text = "This Name is Already Used";
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
                    //str = "Insert into eq_floor_master(FloorName,FloorCode,LocationID,Description,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    //str += "value('" + txtname.Text.Trim().Replace("'","") + "','" + txtCode.Text.Trim() + "','" + ddlLocation.SelectedValue + "','" + txtDescription.Text.Trim() + "',";
                    //str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";

                    str = "Insert into eq_floor_master(FloorName,FloorCode,Description,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    str += "value('" + txtname.Text.Trim().Replace("'", "") + "','" + txtCode.Text.Trim() + "','" + txtDescription.Text.Trim() + "',";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";

                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=fm.LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(fm.UpdateDate,'%T')),'</BR>Ip Address : ',fm.IPAddress,'</BR>" +
                    "Name : ',fm.FloorName,', Code : ',IFNULL(fm.FloorCode,'')," +
                    "', Location : ' ,IFNULL((SELECT LocationName FROM eq_location_master WHERE LocationID=fm.LocationID LIMIT 1),''),', Active : ',IF(fm.IsActive=1,'Yes','No'),'</BR>" +
                    "Description : ' ,IFNULL(fm.Description,''))DataLog " +
                    "FROM eq_floor_master fm WHERE FloorID=" + ViewState["FloorID"].ToString() + " ");


                    str = "Update eq_floor_master Set FloorName='" + txtname.Text.Trim() + "',FloorCode='" + txtCode.Text.Trim() + "',";
                    str += "IsActive = " + IsActive + ",Description='" + txtDescription.Text.Trim() + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where FloorID=" + ViewState["FloorID"].ToString() + " ";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved Successfully";
                ViewState["FloorID"] = "";
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
        //if (ddlLocation.SelectedValue.ToUpper() == "SELECT")
        //{
        //    lblMsg.Text = "Select Location";
        //    return false;
        //}

        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Enter Floor Name";
            txtname.Focus();
            return false;
        }

        //if (txtCode.Text.Trim() == "")
        //{
        //    lblMsg.Text = "Provide Floor Code";
        //    return false;
        //}

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            int isExist = 0;
            isExist = Util.GetInt(StockReports.ExecuteScalar("SElECT count(*) from eq_floor_master Where FloorName ='" + txtname.Text.Trim() + "'"));

            if (isExist > 0)
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
        //ddlLocation.SelectedIndex = 0;
        txtname.Text = "";
        txtCode.Text = "";
        txtDescription.Text = "";
    }

    protected void grdFloor_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string FloorID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_floor_master WHERE FloorID=" + FloorID);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlLocation.SelectedIndex = ddlLocation.Items.IndexOf(ddlLocation.Items.FindByValue(dt.Rows[0]["LocationID"].ToString()));
                txtname.Text = dt.Rows[0]["FloorName"].ToString();
                txtCode.Text = dt.Rows[0]["FloorCode"].ToString();
                txtDescription.Text = dt.Rows[0]["Description"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["FloorID"] = FloorID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
                chkActive.Enabled = true;
                txtDescription.Focus();
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_floor_master WHERE FloorID=" + FloorID);
            mdpLog.Show();
        }
    }

}