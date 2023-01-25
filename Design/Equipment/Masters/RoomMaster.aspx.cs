using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_RoomMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //BindLocation();
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
        try
        {
            string str = "SELECT FloorName,FloorID from eq_floor_master where IsActive=1";

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                ddlFloor.DataSource = dt;
                ddlFloor.DataTextField = "FloorName";
                ddlFloor.DataValueField = "FloorID";
                ddlFloor.DataBind();
                ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
                BindLocation(ddlFloor.SelectedValue);

            }
            else
            {
                ddlFloor.DataSource = null;
                ddlFloor.DataBind();
                ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            }
        }
        catch (Exception e)
        {
            lblMsg.Text = e.Message;
        }


    }

    //private void BindLocation()
    //{
    //    string str = "SELECT LocationName,LocationID from eq_location_master Where IsActive=1";
    //    DataTable dt = new DataTable();
    //    dt = StockReports.GetDataTable(str);

    //    if (dt.Rows.Count > 0)
    //    {
    //        ddlLocation.DataSource = dt;
    //        ddlLocation.DataTextField = "LocationName";
    //        ddlLocation.DataValueField = "LocationID";
    //        ddlLocation.DataBind();
    //        ddlLocation.Items.Insert(0, new ListItem("SELECT", "SELECT"));

    //    }
    //    else
    //    {
    //        ddlLocation.DataSource = null;
    //        ddlLocation.DataBind();
    //    }
    //}

    //private void BindFloor(string LocationID)
    //{
    //    string str = "SELECT FloorName,FloorID from eq_Floor_master Where IsActive=1 and LocationID=" + LocationID;
    //    DataTable dt = new DataTable();
    //    dt = StockReports.GetDataTable(str);

    //    if (dt.Rows.Count > 0)
    //    {
    //        ddlFloor.DataSource = dt;
    //        ddlFloor.DataTextField = "FloorName";
    //        ddlFloor.DataValueField = "FloorID";
    //        ddlFloor.DataBind();
    //    }
    //    else
    //    {
    //        ddlFloor.Items.Clear();
    //        ddlFloor.DataSource = null;
    //        ddlFloor.DataBind();
    //    }
    //    ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
    //}
    private void BindLocation(string FloorID)
    {
        try
        {
            string str = " SELECT LocationName,LocationID from eq_location_master where IsActive=1 and Floorid=" + FloorID;
            //SELECT LocationName,LocationID FROM eq_location_master WHERE IsActive=1 AND FloorID=" + FloorID;
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
            else
            {
                ddlFloor.Items.Clear();
                ddlFloor.DataSource = null;
                ddlFloor.DataBind();
                ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            }
        }
        catch (Exception e)
        {
            ddlLocation.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            lblMsg.Text = e.Message;
        }
    }
    

    private void LoadData()
    {
        grdRoom.DataSource = null;
        grdRoom.DataBind();

        string str = "SELECT rm.LocationID, rm.RoomID,rm.RoomName,rm.RoomCode,rm.Description,";
        str += "(SELECT LocationName FROM eq_location_master WHERE LocationID=rm.LocationID)LocationName,";
        str += "(SELECT FloorName FROM eq_Floor_master WHERE FloorID=rm.FloorID)FloorName,";
        str += "IF(rm.IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE rm.LastUpdatedby=employee_ID)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(rm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(rm.UpdateDate,'%T'))UpdateDate,";
        str += "rm.IPAddress FROM eq_Room_master rm ORDER BY rm.RoomName ";

        DataTable dt = StockReports.GetDataTable(str);

        grdRoom.DataSource = dt;
        grdRoom.DataBind();
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
                    str = "Insert into eq_Room_master(RoomName,RoomCode,LocationID,FloorID,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    str += "value('" + txtname.Text.Trim().Replace("'","") + "','" + txtCode.Text.Trim() + "','" + ddlLocation.SelectedValue + "','" + ddlFloor.SelectedValue + "',";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";
                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=rm.LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(rm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(rm.UpdateDate,'%T')),', IP Address : ',rm.IPAddress,'</BR>" +
                    "Name : ',rm.RoomName,', Code : ',rm.RoomCode," +
                    "', Location : ',(SELECT LocationName FROM eq_location_master WHERE LocationID=rm.LocationID LIMIT 1)," +
                    "', Floor : ',(SELECT FloorName FROM eq_Floor_master WHERE FloorID=rm.FloorID LIMIT 1),', Active : ',IF(rm.IsActive=1,'Yes','No'),'</BR>" +
                    "Description : ',rm.Description)DataLog " +
                    "FROM eq_Room_master rm WHERE rm.RoomID=" + ViewState["RoomID"].ToString() + " ");
                    

                    str = "Update eq_Room_master Set RoomName='" + txtname.Text.Trim() + "',RoomCode='" + txtCode.Text.Trim() + "',IsActive = " + IsActive + ",";
                    str += "LocationID='" + ddlLocation.SelectedValue + "',FloorID='" + ddlFloor.SelectedValue + "',Description='" + txtDescription.Text.Trim() + "', ";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where RoomID=" + ViewState["RoomID"].ToString() + " ";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved Successfully";
                ViewState["RoomID"] = "";
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
        if (ddlFloor.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select Floor";
            ddlFloor.Focus();
            return false;
        }

        if (ddlLocation.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select Location";
            ddlLocation.Focus();
            return false;
        }        

        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Enter Room Name";
            txtname.Focus();
            return false;
        }

        //if (txtCode.Text.Trim() == "")
        //{
        //    lblMsg.Text = "Provide Room Code";
        //    return false;
        //}

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            int isExist = 0;
            isExist = Util.GetInt(StockReports.ExecuteScalar("SElECT RoomName from eq_Room_master Where RoomName ='" + txtname.Text.Trim() + "' and LocationID=" + ddlLocation.SelectedValue + " and FloorID =" + ddlFloor.SelectedValue));

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
        ddlLocation.SelectedIndex = 0;
        ddlFloor.SelectedIndex = 0;
        txtname.Text = "";
        txtCode.Text = "";
        txtDescription.Text = "";
    }

    protected void grdRoom_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string RoomID = Util.GetString(e.CommandArgument);


        if (e.CommandName == "EditAT")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_Room_master WHERE RoomID=" + RoomID);
            if (dt != null && dt.Rows.Count > 0)
            {
               // ddlLocation.SelectedIndex = ddlLocation.Items.IndexOf(ddlLocation.Items.FindByValue(dt.Rows[0]["LocationID"].ToString()));
                
                    //dt.Rows[0]["LocationID"].ToString();        
                ddlFloor.SelectedIndex = ddlFloor.Items.IndexOf(ddlFloor.Items.FindByValue(dt.Rows[0]["FloorID"].ToString()));
                BindLocation(ddlFloor.SelectedValue);
                ddlLocation.SelectedIndex = ddlLocation.Items.IndexOf(ddlLocation.Items.FindByValue(dt.Rows[0]["LocationID"].ToString()));

                txtname.Text = dt.Rows[0]["RoomName"].ToString();
                txtCode.Text = dt.Rows[0]["RoomCode"].ToString();
                txtDescription.Text = dt.Rows[0]["Description"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["RoomID"] = RoomID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
                chkActive.Enabled = true;
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_Room_master WHERE RoomID=" + RoomID);
            mdpLog.Show();
        }
    }
    protected void ddlLocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlLocation.SelectedValue.ToUpper() == "")
        {
            lblMsg.Text = "Provide Location...";
            ddlLocation.Focus();
            return;
        }

        //BindFloor(ddlLocation.SelectedValue);
       
    }
    protected void ddlFloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlFloor.SelectedValue.ToUpper() == "")
        {

            lblMsg.Text = "Provide Floor";
            ddlFloor.Focus();
            return;
       }
       BindLocation(ddlFloor.SelectedValue);
    }
   
}