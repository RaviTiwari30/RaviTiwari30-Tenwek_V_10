using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_IPD_NurseAssignment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCaseType();
            BindFloor();
            bindAvailablenurse();
            Search();
        }
    }

    private void BindCaseType()
    {
        DataTable dtData = new DataTable();

        string str = "SELECT DISTINCT(ich.IPDCaseTypeID)IPDCaseTypeID,ich.Name,Role_ID FROM f_roomtype_role rt " +
        "INNER JOIN ipd_case_type_master ich ON ich.IPDCaseTypeID=rt.IPDCaseTypeID " +
        "where Role_ID='" + HttpContext.Current.Session["RoleID"].ToString() + "'  ";

        dtData = StockReports.GetDataTable(str);

        if (dtData.Rows.Count > 0)
        {
            ddlCaseType.DataSource = dtData;
            ddlCaseType.DataTextField = "Name";
            ddlCaseType.DataValueField = "IPDCaseTypeID";
            ddlCaseType.DataBind();

            ddlCaseType.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void BindFloor()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT FloorID AS ID,Role_ID,fm.Name AS NAME FROM f_roomtype_role  rm INNER JOIN Floor_master fm ON fm.ID=rm.FloorID WHERE Role_ID='" + HttpContext.Current.Session["RoleID"].ToString() + "' GROUP BY FloorID,Role_ID ORDER BY fm.SequenceNo+0 ");
        if (dt.Rows.Count > 0)
        {
            cmbFloor.DataSource = All_LoadData.LoadFloor();
            cmbFloor.DataValueField = "NAME";
            cmbFloor.DataTextField = "NAME";
            cmbFloor.DataBind();
            cmbFloor.Items.Insert(1, "GroundFloor");
            //cmbFloor.Items.Add(new ListItem("--Select--", "0", true));
        }
    }
    private void Search()
    {
        string str = string.Empty;
        if (ddlPatienttype.SelectedItem.Value == "1")
        {
            str = @"SELECT pmh.`TransactionID`,pmh.Transno as IPDNo,pm.`PName`,ictm.`Name` AS RoomType,concat(rm.Name,'/',rm.Room_No)RoomName,IFNULL(em.Name,'')NurseName,
        IFNULL(CONCAT(DATE_FORMAT(pna.AssignmentDateIN,'%d-%b-%Y'),' ',TIME_FORMAT(pna.AssignmentTimeIN,'%h:%i %p')),'')AssignmentDateIN,
        IFNULL(CONCAT(DATE_FORMAT(pna.AssignmentDateOUT,'%d-%b-%Y'),' ',TIME_FORMAT(pna.AssignmentTimeOUT,'%h:%i %p')),'')AssignmentDateOUT,
        (CASE WHEN pna.Status=1 THEN 'Completed' WHEN pna.`Status`=0 THEN 'Assigned' ELSE '' END)STATUS, pna.ID,pna.NurseID,pip.IPDCaseTypeID,pm.`PatientID`
        FROM patient_ipd_profile pip inner join Patient_Medical_History pmh on pip.TransactionID = pmh.TransactionID
        INNER JOIN ipd_case_type_master ictm ON pip.IPDCaseTypeID=ictm.IPDCaseTypeID
        INNER JOIN room_master rm on rm.RoomId = pip.RoomId 
        INNER JOIN patient_master pm ON pm.`PatientID` = pip.`PatientID`
        LEFT JOIN patient_nurse_assignment pna ON pip.`TransactionID` = pna.`TransactionID`
        LEFT JOIN employee_master em ON em.EmployeeID=pna.NurseID 
        WHERE pip.`Status`='IN' ";

            str += " and pip.CentreID=" + Util.GetInt(Session["CentreID"]);


            if (ddlCaseType.SelectedIndex != 0)
            {
                str = str + " and pip.IPDCaseTypeID='" + ddlCaseType.SelectedValue + "'";
            }
        }
        else
        {
            str = @"SELECT pmh.`TransactionID`,pmh.Transno as IPDNo,pm.`PName`,ictm.`Name` AS RoomType,concat(rm.Name,'/',rm.Room_No)RoomName,IFNULL(em.Name,'')NurseName,
        IFNULL(CONCAT(DATE_FORMAT(pna.AssignmentDateIN,'%d-%b-%Y'),' ',TIME_FORMAT(pna.AssignmentTimeIN,'%h:%i %p')),'')AssignmentDateIN,
        IFNULL(CONCAT(DATE_FORMAT(pna.AssignmentDateOUT,'%d-%b-%Y'),' ',TIME_FORMAT(pna.AssignmentTimeOUT,'%h:%i %p')),'')AssignmentDateOUT,
        (CASE WHEN pna.Status=1 THEN 'Completed' WHEN pna.`Status`=0 THEN 'Assigned' ELSE '' END)STATUS, pna.ID,pna.NurseID,epd.IPDCaseTypeID,pm.`PatientID`
        FROM Emergency_Patient_Details epd inner join Patient_Medical_History pmh on epd.TransactionID = pmh.TransactionID
        INNER JOIN ipd_case_type_master ictm ON epd.IPDCaseTypeID=ictm.IPDCaseTypeID
        INNER JOIN room_master rm on rm.RoomId = epd.RoomId 
        INNER JOIN patient_master pm ON pm.`PatientID` = epd.`PatientID`
        LEFT JOIN patient_nurse_assignment pna ON epd.`TransactionID` = pna.`TransactionID`
        LEFT JOIN employee_master em ON em.EmployeeID=pna.NurseID 
        WHERE epd.IsReleased=0 ";

            str += " and pmh.CentreID=" + Util.GetInt(Session["CentreID"]);


            if (ddlCaseType.SelectedIndex != 0)
            {
                str = str + " and epd.IPDCaseTypeID='" + ddlCaseType.SelectedValue + "'";
            }
        }

        if (cmbFloor.SelectedIndex != -1 && cmbFloor.SelectedIndex != 0)
        {
            str = str + " and  rm.Floor ='" + cmbFloor.SelectedValue + "' ";
        }
        str += " ORDER BY rm.Name,rm.Bed_No+0  desc ";
        //str += " ORDER BY pna.Status asc, ";
        //str += " pna.AssignmentTimeIN desc;";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            grdInv.DataSource = dt;
            grdInv.DataBind();
            btnsave.Visible = true;
            pnlRoomType.Visible = true;
        }

        else
        {
            btnsave.Visible = false;
            grdInv.DataSource = null;
            grdInv.DataBind();
            // pnlRoomType.Visible = false;
        }
    }
    private void bindAvailablenurse()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DISTINCT emp.EmployeeID,emp.NAME,emp.UserType_ID FROM employee_master emp LEFT OUTER JOIN f_login fl ON emp.EmployeeID=fl.EmployeeID WHERE  emp.IsActive=1 order by emp.NAME asc ");

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlAvailNurse.Items.Clear();
            ddlAvailNurse.DataSource = dt;
            ddlAvailNurse.DataTextField = "NAME";
            ddlAvailNurse.DataValueField = "EmployeeID";
            ddlAvailNurse.DataBind();
            ddlAvailNurse.Items.Insert(0, new ListItem("---Select Nurse---", "0"));
            lblMsg.Text = "";
            btnsave.Enabled = true;
            ddlAvailNurse.SelectedIndex = ddlAvailNurse.Items.IndexOf(ddlAvailNurse.Items.FindByValue(Session["ID"].ToString()));
        }
        else
        {
            lblMsg.Text = "No Nurse Available.";
            ddlAvailNurse.Items.Clear();
            btnsave.Enabled = false;
        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        Search();
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (ddlAvailNurse.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select Nurse";
            return;
        }
        else
        {
            MySqlConnection conn = Util.GetMySqlCon();
            conn.Open();
            MySqlTransaction Tnx = conn.BeginTransaction(IsolationLevel.Serializable);
            try
            {

                foreach (GridViewRow row in grdInv.Rows)
                {
                    if (((CheckBox)row.FindControl("chkRow")).Checked && ((Label)row.FindControl("STATUS")).Text.ToString().Trim() != "Completed")
                    {
                        string TransactionID = ((Label)row.FindControl("TransactionID")).Text;
                        string NurseName = ((Label)row.FindControl("NurseName")).Text;
                        string IPDCaseTypeID = ((Label)row.FindControl("lblIPDCaseTypeID")).Text;
                        string AssignmentDateIN = ((Label)row.FindControl("AssignmentDateIN")).Text;
                        string AssignmentDateOUT = ((Label)row.FindControl("AssignmentDateOUT")).Text;
                        string STATUS = ((Label)row.FindControl("STATUS")).Text;




                        if (btnsave.Text.ToUpper() == "SAVE")
                        {
                            string str = @"select * from patient_nurse_assignment where TransactionID='" + TransactionID + "' and Status=0 and NurseID='" + ddlAvailNurse.SelectedItem.Value + "'";
                            DataTable dt = StockReports.GetDataTable(str);
                            if (dt.Rows.Count > 0)
                            {
                                lblMsg.Text = "Patient Allready Assign To This Nurse";
                            }
                            else
                            {
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Update patient_nurse_assignment set Status=1,AssignmentDateOUT=CURDATE(),AssignmentTimeOUT=CURTIME() where TransactionID='" + TransactionID + "' and Status=0 ");
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "INSERT INTO patient_nurse_assignment (TransactionID,NurseID,AssignmentDateIN,AssignmentTimeIN,IPDCaseTypeID,STATUS) VALUES ('" + TransactionID + "','" + ddlAvailNurse.SelectedItem.Value + "',CURDATE(),CURTIME(),'" + IPDCaseTypeID + "',0 )");
                                lblMsg.Text = "Record Saved Successfully";
                            }

                        }

                    }
                }

                Tnx.Commit(); 
                Search();

            }
            catch (Exception ex)
            {
                Tnx.Rollback();

                lblMsg.Text = "Something went wrong. Patient(s) are Not Assiged To selected nurse.";
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                Tnx.Dispose();
                conn.Close();
                conn.Dispose();
            }



        }
    }

    protected void grdInv_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("STATUS")).Text.ToString().Trim() == "Completed")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FF99CC");
                ((CheckBox)e.Row.FindControl("chkRow")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkRow")).Visible = false;
            }
            else
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#99FFCC");

            }
        }


    }
}