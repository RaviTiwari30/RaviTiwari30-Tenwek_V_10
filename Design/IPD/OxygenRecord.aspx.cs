using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_IPD_OxygenRecord : System.Web.UI.Page
    {
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindNurse();
            // txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            lblPID.Text = Request.QueryString["PatientId"].ToString();
            lblTID.Text = Request.QueryString["TransactionID"].ToString();
            bindOxygenRecord();
            bindOxygenData();
        }
        DataTable dt = AllLoadData_IPD.getAdmitDischargeData(lblTID.Text);
        calOxygenDate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
        if (dt.Rows[0]["Status"].ToString() == "OUT")
            calOxygenDate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
        else
            calOxygenDate.EndDate = DateTime.Now;
        txtDate.Attributes.Add("readOnly", "true");
        txtDateOFF.Attributes.Add("readOnly", "true");
        CalendarExtender1.StartDate = DateTime.Now;
    }

    private void bindNurse()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Name,em.EmployeeID AS Employee_ID FROM employee_master em INNER JOIN employee_hospital eh ON eh.EmployeeID=em.EmployeeID WHERE eh.CentreID='" + Session["CentreID"].ToString() + "' ");
        if (dt.Rows.Count > 0)
        {
            ddlNurseTimeOff.DataSource = dt;
            ddlNurseTimeOff.DataTextField = "Name";
            ddlNurseTimeOff.DataValueField = "Employee_ID";
            ddlNurseTimeOff.DataBind();
            ddlNurseTimeOn.DataSource = dt;
            ddlNurseTimeOn.DataTextField = "Name";
            ddlNurseTimeOn.DataValueField = "Employee_ID";
            ddlNurseTimeOn.DataBind();
            ddlNurseTimeOff.Items.Insert(0, new ListItem("Select", "0"));
            ddlNurseTimeOn.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void bindOxygenRecord()
    {
        DataTable dt = StockReports.GetDataTable("SELECT IFNULL(oxy.ID,'0')ID, DATE_FORMAT(OxygenDateON,'%d-%b-%Y')OxygenDateON,if(OxygenDateOFF='0001-01-01','',DATE_FORMAT(OxygenDateOFF,'%d-%b-%Y'))OxygenDateOFF,DATE_FORMAT(OxygenTimeON,'%h:%i %p')OxygenTimeON,NurseTimeON," +
        "if(NurseTimeOFf='0','',DATE_FORMAT(OxygenTimeOFF,'%h:%i %p'))OxygenTimeOFF,NurseTimeOFf,if(NurseTimeOFf='0','',TIME_FORMAT( TIMEDIFF(CONCAT(OxygenDateOFF,' ',OxygenTimeOFF),CONCAT(OxygenDateON,' ',OxygenTimeON)) ,'%H:%i:%s'))Hours," +
            " TypeOfTherapy,em.Name NurseTimeONBy,em1.Name NurseTimeOffBy,oxy.DeliveryType,oxy.OxygenDeliveryDetails FROM IPD_OxygenRecord oxy INNER JOIN employee_master em ON oxy.NurseTimeON=em.employeeID " +
            " LEFT JOIN employee_master em1 ON oxy.NurseTimeOFf=em1.employeeID WHERE TransactionID='" + lblTID.Text + "'");
        if (dt.Rows.Count > 0)
        {
            grdOxygen.DataSource = dt;
            grdOxygen.DataBind();
        }
    }

    protected bool validate()
        {
        string s = ""; string t = "";
        if (txtDate.Text != "" && txtTimeOn.Text != "")
            {
            s = txtDate.Text + " " + txtTimeOn.Text;
            }
        if (txtDateOFF.Text != "" && txtTimeOff.Text != "")
            {
            t = txtDateOFF.Text + " " + txtTimeOff.Text;
            }
        if ((txtDate.Text != "") && (txtDateOFF.Text != ""))
            {
            DateTime dtFromDate = DateTime.Parse(txtDate.Text);
            DateTime dtToDate = DateTime.Parse(txtDateOFF.Text);
            TimeSpan difference = dtFromDate - dtToDate;
            double days = difference.TotalDays;

            if (days > 0)
                {
                lblMsg.Text = "Date ON cannot be greater than Date OFF";
                return false;
                }
            }
        if (s != "" && t != "")
            {
            DateTime theDateA = DateTime.Parse(s);
            DateTime theDateB = DateTime.Parse(t);
            if (theDateB < theDateA)
                {
                lblMsg.Text = "Time Off Greater then Time ON";
                return false;
                }
            }
        if (txtDateOFF.Text != "" || txtTimeOff.Text != "")
            {
            if (txtDateOFF.Text == "")
                {
                lblMsg.Text = "Please Select Date Off";
                ddlNurseTimeOff.Focus();
                return false;
                }
            if (txtTimeOff.Text == "")
                {
                lblMsg.Text = "Please Enter Time Off";
                txtTimeOff.Focus();
                return false;
                }
            if (ddlNurseTimeOff.SelectedIndex == 0)
                {
                lblMsg.Text = "Please Select Nurse Time Off";
                ddlNurseTimeOff.Focus();
                return false;
                }
            }
        if ((lblFillTimeON.Text == "1"))
            {
            if (txtDateOFF.Text.Trim() == "")
                {
                lblMsg.Text = "Please Enter Date Off";
                txtDateOFF.Focus();
                return false;
                }
            if (txtTimeOff.Text.Trim() == "")
                {
                lblMsg.Text = "Please Enter Time Off";
                txtTimeOff.Focus();
                return false;
                }

            if (ddlNurseTimeOff.SelectedIndex == 0)
                {
                lblMsg.Text = "Please Select Nurse Time Off";
                ddlNurseTimeOff.Focus();
                return false;
                }
            }
        return true;
        }

    protected void btnOxygen_Click(object sender, EventArgs e)
        {
        if (validate())
            {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
                {
                if ((lblFillTimeON.Text == "1"))
                    {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE IPD_OxygenRecord SET OxygenDateOFF='" + Util.GetDateTime(txtDateOFF.Text).ToString("yyyy-MM-dd") + "', OxygenTimeOFF='" + Util.GetDateTime(txtTimeOff.Text).ToString("HH:mm:ss") + "', " +
                        " NurseTimeOFf='" + ddlNurseTimeOff.SelectedItem.Value + "' WHERE ID='" + lblOxygenID.Text + "'");
                    }
                else
                    {
                    string sb = "INSERT INTO IPD_OxygenRecord(PatientID,TransactionID,OxygenDateOn,OxygenTimeON,NurseTimeON,OxygenTimeOFF,NurseTimeOFF, " +
                   " TypeOfTherapy,TimeOnCreatedBy,OxygenDateOFF,DeliveryType,OxygenDeliveryDetails)VALUES('" + lblPID.Text + "','" + lblTID.Text + "', " +
                   " '" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTimeOn.Text).ToString("HH:mm:ss") + "', " +
                    " '" + ddlNurseTimeOn.SelectedItem.Value + "','" + Util.GetDateTime(txtTimeOff.Text).ToString("HH:mm:ss") + "'," +
                    " '" + ddlNurseTimeOff.SelectedItem.Value + "','" + ddlTypeOfTherapy.SelectedItem.Text + "','" + Session["ID"].ToString() + "','" + Util.GetDateTime(txtDateOFF.Text).ToString("yyyy-MM-dd") + "','" + ddlDeliveryType.SelectedValue + "','" + txtOxygenDeliveryDetails.Text + "')";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                    }
                tnx.Commit();
                bindOxygenRecord();
                bindOxygenData();
                if ((lblFillTimeON.Text == "1"))
                {
                    txtOxygenDeliveryDetails.Enabled = true;
                }
                lblMsg.Text = "Record Saved Successfully";
                }
            catch (Exception ex)
                {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                }
            finally
                {
                tnx.Dispose();
                con.Close();
                con.Dispose();
                }
            }
        }

    protected void btnUpdate_Click(object sender, EventArgs e)
        {
        if (validate())
            {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
                {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE IPD_OxygenRecord SET OxygenDateON='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',OxygenTimeON='" + Util.GetDateTime(txtTimeOn.Text).ToString("HH:mm:ss") + "'," +
                     " NurseTimeON='" + ddlNurseTimeOn.SelectedItem.Value + "',OxygenDateOFF='" + Util.GetDateTime(txtDateOFF.Text).ToString("yyyy-MM-dd") + "', " +
                     " OxygenTimeOFF='" + Util.GetDateTime(txtTimeOff.Text).ToString("HH:mm:ss") + "', " +
                     " NurseTimeOFf='" + ddlNurseTimeOff.SelectedItem.Value + "',TypeOfTherapy='" + ddlTypeOfTherapy.SelectedItem.Text + "' WHERE ID='" + lblOxygenID.Text + "'");
                tnx.Commit();
                bindOxygenRecord();
                btnOxygen.Visible = true;
                btnUpdate.Visible = false;
                txtOxygenDeliveryDetails.Enabled = true;
                lblMsg.Text = "Record Updated Successfully";
                clearControl();
                }
            catch (Exception ex)
                {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                }
            finally
                {
                tnx.Dispose();
                con.Close();
                con.Dispose();
                }
            }
        }

    protected void grdOxygen_RowCommand(object sender, GridViewCommandEventArgs e)
        {
        int index = Convert.ToInt32((e.CommandArgument));

        if (e.CommandName == "AEdit")
            {
            lblMsg.Text = "";
            txtDate.Text = ((Label)grdOxygen.Rows[index].FindControl("lblOxygenDateON")).Text;
            txtTimeOn.Text = ((Label)grdOxygen.Rows[index].FindControl("lblOxygenTimeON")).Text;
            ddlNurseTimeOn.SelectedIndex = ddlNurseTimeOn.Items.IndexOf(ddlNurseTimeOn.Items.FindByValue(((Label)grdOxygen.Rows[index].FindControl("lblNurseTimeON")).Text));
            txtDateOFF.Text = ((Label)grdOxygen.Rows[index].FindControl("lblOxygenDateOFF")).Text;
            txtTimeOff.Text = ((Label)grdOxygen.Rows[index].FindControl("lblOxygenTimeOFF")).Text;
            calOxygenDate.StartDate = Convert.ToDateTime(txtDate.Text);
            CalendarExtender1.StartDate = Convert.ToDateTime(txtDate.Text);
            ddlNurseTimeOff.SelectedIndex = ddlNurseTimeOff.Items.IndexOf(ddlNurseTimeOff.Items.FindByValue(((Label)grdOxygen.Rows[index].FindControl("lblNurseTimeOff")).Text));
            ddlTypeOfTherapy.SelectedIndex = ddlTypeOfTherapy.Items.IndexOf(ddlTypeOfTherapy.Items.FindByText(((Label)grdOxygen.Rows[index].FindControl("lblTypeOfTherapy")).Text));
            ddlDeliveryType.SelectedIndex = ddlDeliveryType.Items.IndexOf(ddlDeliveryType.Items.FindByText(((Label)grdOxygen.Rows[index].FindControl("lblDeliveryType")).Text));
            txtOxygenDeliveryDetails.Text = ((Label)grdOxygen.Rows[index].FindControl("lblOxygenDeliveryDetails")).Text;
            ddlDeliveryType.Enabled = false;
            txtOxygenDeliveryDetails.Enabled = false;
            lblOxygenID.Text = ((Label)grdOxygen.Rows[index].FindControl("lblID")).Text;
            btnOxygen.Visible = false;
            btnUpdate.Visible = true;
            }
        }

    protected void grdOxygen_RowDataBound(object sender, GridViewRowEventArgs e)
        {
        if (e.Row.RowType == DataControlRowType.DataRow)
            {
            string aa = ((Label)e.Row.FindControl("lblNurseTimeOFf")).Text;
            if (((Label)e.Row.FindControl("lblNurseTimeOFf")).Text == "")
                {
                ((ImageButton)e.Row.FindControl("imgResult")).Visible = false;
                }
            else
                {
                ((ImageButton)e.Row.FindControl("imgResult")).Visible = true;
                }
            }
        }

    private void bindOxygenData()
        {
        DataTable dt = StockReports.GetDataTable("SELECT oxy.ID,DATE_FORMAT(OxygenDateON,'%d-%b-%Y')OxygenDateON,DATE_FORMAT(OxygenDateOFF,'%d-%b-%Y')OxygenDateOFF,DATE_FORMAT(OxygenTimeON,'%h:%i %p')OxygenTimeON,NurseTimeON,if(NurseTimeOFf='0','',DATE_FORMAT(OxygenTimeOFF,'%h:%i %p'))OxygenTimeOFF,NurseTimeOFf,OxygenHours," +
            " TypeOfTherapy,em.Name NurseTimeONBy,em1.Name NurseTimeOffBy,oxy.DeliveryType,oxy.OxygenDeliveryDetails FROM IPD_OxygenRecord oxy INNER JOIN employee_master em ON oxy.NurseTimeON=em.employeeID " +
            " LEFT JOIN employee_master em1 ON oxy.NurseTimeOFf=em1.employeeID WHERE TransactionID='" + lblTID.Text + "' AND NurseTimeOFf='0' Order By oxy.ID DESC");
        if (dt.Rows.Count > 0)
            {
                txtDate.Text = dt.Rows[0]["OxygenDateON"].ToString();
                txtTimeOn.Text = dt.Rows[0]["OxygenTimeON"].ToString();
                txtOxygenDeliveryDetails.Text = dt.Rows[0]["OxygenDeliveryDetails"].ToString();

            ddlNurseTimeOn.SelectedIndex = ddlNurseTimeOn.Items.IndexOf(ddlNurseTimeOn.Items.FindByValue(dt.Rows[0]["NurseTimeON"].ToString()));
            ddlTypeOfTherapy.SelectedIndex = ddlTypeOfTherapy.Items.IndexOf(ddlTypeOfTherapy.Items.FindByText(dt.Rows[0]["TypeOfTherapy"].ToString()));
            ddlDeliveryType.SelectedIndex = ddlDeliveryType.Items.IndexOf(ddlDeliveryType.Items.FindByText(dt.Rows[0]["DeliveryType"].ToString()));

            txtDate.Enabled = false;
            txtTimeOn.Enabled = false;
            ddlNurseTimeOn.Enabled = false;
            ddlTypeOfTherapy.Enabled = false;
            ddlDeliveryType.Enabled = false;
            txtOxygenDeliveryDetails.Enabled = false;
            lblFillTimeON.Text = "1";
            lblOxygenID.Text = dt.Rows[0]["ID"].ToString();
            }
        else
            {
            clearControl();
            }
        }

    protected void clearControl()
        {
        lblFillTimeON.Text = "0";
        txtDate.Text = "";
        txtTimeOn.Text = "";
        txtOxygenDeliveryDetails.Text = "";
        ddlNurseTimeOn.SelectedIndex = 0;
        ddlTypeOfTherapy.SelectedIndex = 0;
        ddlDeliveryType.SelectedIndex = 0;
        txtTimeOff.Text = "";
        ddlNurseTimeOff.SelectedIndex = 0;
        txtDateOFF.Text = "";
        txtDate.Enabled = true;
        txtTimeOn.Enabled = true;
        ddlNurseTimeOn.Enabled = true;
        ddlTypeOfTherapy.Enabled = true;
        ddlDeliveryType.Enabled = true;
        }
    }