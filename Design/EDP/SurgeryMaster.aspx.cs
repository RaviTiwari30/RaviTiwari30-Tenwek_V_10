using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_EDP_SurgeryMaster : System.Web.UI.Page
{
    protected void btnDepartment_Click(object sender, EventArgs e)
    {
        if (txtDepartment.Text != "")
        {
            MySqlConnection con = new MySqlConnection(Util.GetConString());
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string str1 = "SELECT Name FROM Surdept_master WHERE name='" + txtDepartment.Text + "' AND IsActive=1";
                string abc = StockReports.ExecuteScalar(str1);
                if (abc != "")
                {
                    lblMsg.Text = "Department Already Exists";
                    return;
                }
                string STR = " insert into  Surdept_master (NAME,IsActive)  values ('" + txtDepartment.Text + "','" + "1" + "' )";
                int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, STR);
                tnx.Commit();
                LoadDept();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                tnx.Rollback();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            lblMsg.Text = "Please Enter Department Name";
            return;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtSurgeryName.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM049','" + lblMsg.ClientID + "');", true);
            return;
        }
        SaveData();
    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        if (txtName.Text.Trim() == "" && txtItemCode1.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM168','" + lblMsg.ClientID + "');", true);
            return;
        }
        LoadSurgery();
    }

    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView1.EditIndex = -1;
        LoadSurgery();
    }

    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = (int)e.NewEditIndex;
        LoadSurgery();
        LoadDept(((DropDownList)GridView1.Rows[e.NewEditIndex].FindControl("ddlDept")), ((Label)GridView1.Rows[e.NewEditIndex].FindControl("lblDept1")).Text);
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
          MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
          try
          {

              string SurgeryId = ((Label)GridView1.Rows[e.RowIndex].FindControl("lblSurgery_ID")).Text.Trim();
              int GroupID = Util.GetInt(((Label)GridView1.Rows[e.RowIndex].FindControl("lblGroupID")).Text.Trim());

              Surgery_Master objSurgery = new Surgery_Master(Tranx);
              objSurgery.Name = ((TextBox)GridView1.Rows[e.RowIndex].FindControl("txtSurgery")).Text.Trim();
              objSurgery.Ownership = "";
              objSurgery.GroupID = Util.GetInt(((Label)GridView1.Rows[e.RowIndex].FindControl("lblGroupID")).Text.Trim());
              objSurgery.Creator_ID = Session["ID"].ToString();
              objSurgery.Department = ((DropDownList)GridView1.Rows[e.RowIndex].FindControl("ddlDept")).Text.Trim();
              objSurgery.SurgeryCode = ((TextBox)GridView1.Rows[e.RowIndex].FindControl("txtSurgeryCode")).Text.Trim();

              string IsActive = ((DropDownList)GridView1.Rows[e.RowIndex].FindControl("ddlIsActive")).SelectedItem.Text;

              if (IsActive.ToUpper() == "TRUE")
                  objSurgery.IsActive = 1;
              else
                  objSurgery.IsActive = 0;

              objSurgery.Surgery_ID = ((Label)GridView1.Rows[e.RowIndex].FindControl("lblSurgery_ID")).Text.Trim();
              objSurgery.Update();

              //DataTable dt = StockReports.GetDataTable("SELECT ItemID,GroupID,Rate,PanelID FROM f_surgery_group WHERE groupID=" + Util.GetInt(GroupID) + " AND IsActive=1");
              DataTable dt = StockReports.GetDataTable("SELECT ItemID,0 GroupID,MinLimit Rate,0 PanelID from  f_itemmaster WHERE issurgery=1 AND isActive=1");

              decimal totalRate = Util.GetDecimal(dt.Compute("sum(Rate)", ""));

              MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE f_surgery_calculator SET IsActive=0 WHERE SurgeryID='" + SurgeryId + "' AND GroupID=" + GroupID + " ");

              Surgery_Calculator objCal = new Surgery_Calculator(Tranx);
              for (int i = 0; i < dt.Rows.Count; i++)
              {
                  objCal.SurgeryID = SurgeryId;
                  objCal.ItemID = dt.Rows[i]["ItemID"].ToString();
                  objCal.CreatedBy = Session["ID"].ToString();
                  objCal.GroupID = GroupID;
                  objCal.Rate = Util.GetDecimal(dt.Rows[i]["Rate"].ToString());
                  objCal.PanelID = Util.GetInt(dt.Rows[i]["PanelID"].ToString());
                  objCal.Insert().ToString();

                  //int ScheduleChargeID = Util.GetInt(StockReports.ExecuteScalar("SELECT ScheduleChargeID FROM f_rate_schedulecharges WHERE PanelID='" + Util.GetString(dt.Rows[i]["PanelID"].ToString()) + "' AND isDefault=1 "));
                  //StringBuilder sb = new StringBuilder();
                  //sb.Append("Delete from f_surgery_rate_list Where Surgery_ID = '" + SurgeryId + "' ");
                  //sb.Append("and PanelID = '" + Util.GetString(dt.Rows[i]["PanelID"].ToString()) + "' ");
                  //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

                  //sb = new StringBuilder();

                  //sb.Append("INSERT INTO f_surgery_rate_list(Surgery_ID,Rate,PanelID,IPDCaseType_ID,PanelCode,IsCurrent,DateFrom,UserID,ScheduleChargeID)");
                  //sb.Append("Select '" + SurgeryId + "'," + Util.GetDecimal(totalRate) + ",");
                  //sb.Append("'" + Util.GetString(dt.Rows[i]["PanelID"].ToString()) + "',icm.IPDCaseType_ID,'" + txtItemCode.Text.Trim() + "',");
                  //sb.Append("'1',");
                  //sb.Append("'" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Session["ID"].ToString() + "'," + ScheduleChargeID + " from (Select IPDCaseType_ID from ipd_case_type_master Where IsActive=1) icm ");
                  //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
              }
              Tranx.Commit();
              ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Updated Successfully');", true);

          }
          catch (Exception ex)
          {
              ClassLog cl = new ClassLog();
              cl.errLog(ex);
              Tranx.Rollback();
              ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error Occured! Please contact to administrator.');", true);
          }

          finally
          {
              Tranx.Dispose();
              con.Close();
              con.Dispose();
          }

        GridView1.EditIndex = -1;
        LoadSurgery();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDept();
            BindSurgeryGroup();
            MultiView1.ActiveViewIndex = 0;
        }
        lblMsg1.Text = "";
        lblMsg.Text = "";
    }

    private void BindSurgeryGroup()
    {
        string Sql = "SELECT GroupID,GroupName FROM f_surgery_groupmaster WHERE IsActive=1 ORDER BY GroupName";
        DataTable dt = StockReports.GetDataTable(Sql);
        chkSurgeryGroup.DataSource = dt;
        chkSurgeryGroup.DataTextField = "GroupName";
        chkSurgeryGroup.DataValueField = "GroupID";
        chkSurgeryGroup.DataBind();
    
    }
    protected void rdbEdit_CheckedChanged(object sender, EventArgs e)
    {
        //LoadSurgery();
        txtName.Focus();
        MultiView1.ActiveViewIndex = 1;
    }

    protected void rdbNew_CheckedChanged(object sender, EventArgs e)
    {
        GridView1.DataSource = null;
        GridView1.DataBind();
        MultiView1.ActiveViewIndex = 0;
    }

    private void LoadDept()
    {
        string str = "";
        str = "select Name from Surdept_master Where IsActive=1 order by Name";

        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "Name";
            ddlDept.DataValueField = "Name";
            ddlDept.DataBind();

            ddlDept1.DataSource = dt;
            ddlDept1.DataTextField = "Name";
            ddlDept1.DataValueField = "Name";
            ddlDept1.DataBind();

            ddlDept1.Items.Insert(0, (new ListItem("ALL", "ALL")));
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }

    private void LoadDept(DropDownList ddl, string DeptName)
    {
        string str = "";
        str = "select Name from Surdept_master Where IsActive=1 order by Name";

        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddl.DataSource = dt;
            ddl.DataTextField = "Name";
            ddl.DataValueField = "Name";
            ddl.DataBind();

            ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByText(DeptName));
        }
    }

    private void LoadSurgery()
    {
        string str = "";
        str = "SELECT Surgery_ID, LTRIM(NAME) NAME,Department,SurgeryCode,s.GroupID,sg.GroupName,IF(s.IsActive=1,'True','False')IsActive FROM f_surgery_master s LEFT JOIN f_surgery_groupmaster sg ON s.GroupID=sg.GroupID WHERE id >0 ";

        if (txtName.Text.Trim() != "")
            str = str + " and Name like '" + txtName.Text.Trim() + "%'";

        if (ddlDept1.SelectedValue != "ALL")
            str = str + " and Department like '%" + ddlDept1.SelectedValue + "%'";

        if (txtItemCode1.Text.Trim() != "")
            str = str + " and SurgeryCode = '" + txtItemCode1.Text.Trim() + "'";

        str = str + " order by ltrim(Name)";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg1.ClientID + "');", true);
        }
    }

    //private void SaveData()
    //{
    //    string  SurgeryName = "";
    //    if (txtSurgeryName.Text != "")
    //    {
    //        SurgeryName = txtSurgeryName.Text.Trim();
    //    }

    //    int IsValid = 0;
    //    string Group = "";
    //    int IsSave = 0;
    //    foreach (ListItem li in chkSurgeryGroup.Items)
    //    {
    //        if (li.Selected)
    //        {
    //            IsSave = 1;
    //            if (Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_surgery_master WHERE NAME='" + txtSurgeryName.Text.Trim() + "' and Department='" + ddlDept.SelectedItem.Text + "' and GroupID=" + Util.GetInt(li.Value) + " ")) > 0)
    //            {
    //                IsValid = 1;
    //                if (Group == "")
    //                    Group = li.Text;
    //                else
    //                    Group = Group + "," + li.Text;
    //            }
    //        }
    //    }

    //    if (IsValid == 1)
    //    {
    //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Same Surgery Already Created for Surgery Groups : " + Group + "');", true);
    //        return;
    //    }

    //    if (IsSave == 0)
    //    {
    //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Kindly Select Atleast one Surgery Group');", true);
    //        return;
    //    }

    //    MySqlConnection con = Util.GetMySqlCon();
    //    con.Open();
    //    MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
    //    try
    //    {

    //        foreach (ListItem li in chkSurgeryGroup.Items)
    //        {
    //            if (li.Selected)
    //            {
                   
    //                string SurgeryId = "";
    //                Surgery_Master objSurgery = new Surgery_Master(Tranx);
    //                objSurgery.Name = SurgeryName;
    //                objSurgery.Ownership = "";
    //                objSurgery.GroupID = Util.GetInt(li.Value);
    //                objSurgery.Creator_ID = Session["ID"].ToString();
    //                objSurgery.Department = ddlDept.SelectedItem.Text;
    //                objSurgery.SurgeryCode = txtItemCode.Text.Trim();
    //                objSurgery.SurgeryGrade = "";
    //                objSurgery.IsActive = 1;
    //                SurgeryId = objSurgery.Insert().ToString();

    //                if (SurgeryId == "")
    //                {
    //                    Tranx.Rollback();
    //                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error Occured! Please contact to administrator.');", true);
    //                    return;
    //                }

    //                DataTable dt = StockReports.GetDataTable("SELECT ItemID,GroupID,Rate,PanelID FROM f_surgery_group WHERE groupID=" + Util.GetInt(li.Value) + " AND IsActive=1");

    //                decimal totalRate = Util.GetDecimal(dt.Compute("sum(Rate)", "")); 
    //                Surgery_Calculator objCal = new Surgery_Calculator(Tranx);
    //                for (int i = 0; i < dt.Rows.Count; i++)
    //                {
    //                    objCal.SurgeryID = SurgeryId;
    //                    objCal.ItemID = dt.Rows[i]["ItemID"].ToString();
    //                    objCal.CreatedBy = Session["ID"].ToString();
    //                    objCal.GroupID = Util.GetInt(li.Value);
    //                    objCal.Rate = Util.GetDecimal(dt.Rows[i]["Rate"].ToString());
    //                    objCal.PanelID = Util.GetInt(dt.Rows[i]["PanelID"].ToString());
    //                    objCal.Insert().ToString();

    //                    int ScheduleChargeID = Util.GetInt(StockReports.ExecuteScalar("SELECT ScheduleChargeID FROM f_rate_schedulecharges WHERE PanelID='" + Util.GetString(dt.Rows[i]["PanelID"].ToString()) + "' AND isDefault=1 "));
    //                    StringBuilder sb = new StringBuilder();
    //                    sb.Append("Delete from f_surgery_rate_list Where Surgery_ID = '" + SurgeryId + "' ");
    //                    sb.Append("and PanelID = '" + Util.GetString(dt.Rows[i]["PanelID"].ToString()) + "' ");
    //                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

    //                    sb = new StringBuilder();

    //                    sb.Append("INSERT INTO f_surgery_rate_list(Surgery_ID,Rate,PanelID,IPDCaseType_ID,PanelCode,IsCurrent,DateFrom,UserID,ScheduleChargeID)");
    //                    sb.Append("Select '" + SurgeryId + "'," + Util.GetDecimal(totalRate) + ",");
    //                    sb.Append("'" + Util.GetString(dt.Rows[i]["PanelID"].ToString()) + "',icm.IPDCaseType_ID,'" + txtItemCode.Text.Trim() + "',");
    //                    sb.Append("'1',");
    //                    sb.Append("'" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Session["ID"].ToString() + "'," + ScheduleChargeID + " from (Select IPDCaseType_ID from ipd_case_type_master Where IsActive=1) icm ");
    //                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
    //                }

    //            }
    //        }

    //        Tranx.Commit();
    //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
    //        txtSurgeryName.Text = "";
    //        LoadCacheQuery.DropCentreWiseCache();//
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);
    //        Tranx.Rollback();
    //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error Occured! Please contact to administrator.');", true);
    //    }

    //    finally
    //    {
    //        Tranx.Dispose();
    //        con.Close();
    //        con.Dispose();
    //    }
    //}


    private void SaveData()
    {
        string SurgeryName = "";
        if (txtSurgeryName.Text != "")
        {
            SurgeryName = txtSurgeryName.Text.Trim();
        }

        int IsValid = 0;
        string Group = "";
        int IsSave = 0;
        //foreach (ListItem li in chkSurgeryGroup.Items)
        //{
        //    if (li.Selected)
        //    {
        //        IsSave = 1;
        //        if (Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_surgery_master WHERE NAME='" + txtSurgeryName.Text.Trim() + "' and Department='" + ddlDept.SelectedItem.Text + "' and GroupID=" + Util.GetInt(li.Value) + " ")) > 0)
        //        {
        //            IsValid = 1;
        //            if (Group == "")
        //                Group = li.Text;
        //            else
        //                Group = Group + "," + li.Text;
        //        }
        //    }
        //}


        if (Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_surgery_master WHERE NAME='" + txtSurgeryName.Text.Trim() + "' and Department='" + ddlDept.SelectedItem.Text + "'  ")) > 0)
        {
            IsValid = 1;
        }

        if (IsValid == 1)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Same Surgery Already Created for Surgery Groups : " + Group + "');", true);
            return;
        }

        //if (IsSave == 0)
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Kindly Select Atleast one Surgery Group');", true);
        //    return;
        //}

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            //foreach (ListItem li in chkSurgeryGroup.Items)
            //{
            //    if (li.Selected)
            //    {

                    string SurgeryId = "";
                    Surgery_Master objSurgery = new Surgery_Master(Tranx);
                    objSurgery.Name = SurgeryName;
                    objSurgery.Ownership = "";
                    objSurgery.GroupID = 0; 
                    objSurgery.Creator_ID = Session["ID"].ToString();
                    objSurgery.Department = ddlDept.SelectedItem.Text;
                    objSurgery.SurgeryCode = txtItemCode.Text.Trim();
                    objSurgery.SurgeryGrade = "";
                    objSurgery.IsActive = 1;
                    SurgeryId = objSurgery.Insert().ToString();

                    if (SurgeryId == "")
                    {
                        Tranx.Rollback();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error Occured! Please contact to administrator.');", true);
                        return;
                    }

                    //       DataTable dt = StockReports.GetDataTable("SELECT ItemID,GroupID,Rate,PanelID FROM f_surgery_group WHERE groupID=" + Util.GetInt(li.Value) + " AND IsActive=1");
                    DataTable dt = StockReports.GetDataTable("SELECT ItemID,0 GroupID,MinLimit Rate,0 PanelID from  f_itemmaster WHERE issurgery=1 AND isActive=1");


                    decimal totalRate = Util.GetDecimal(dt.Compute("sum(Rate)", ""));
                    Surgery_Calculator objCal = new Surgery_Calculator(Tranx);
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        objCal.SurgeryID = SurgeryId;
                        objCal.ItemID = dt.Rows[i]["ItemID"].ToString();
                        objCal.CreatedBy = Session["ID"].ToString();
                        objCal.GroupID = 0;// Util.GetInt(li.Value);
                        objCal.Rate = Util.GetDecimal(dt.Rows[i]["Rate"].ToString());
                        objCal.PanelID = Util.GetInt(dt.Rows[i]["PanelID"].ToString());
                        objCal.Insert().ToString();

                        //  int ScheduleChargeID = Util.GetInt(StockReports.ExecuteScalar("SELECT ScheduleChargeID FROM f_rate_schedulecharges WHERE PanelID='" + Util.GetString(dt.Rows[i]["PanelID"].ToString()) + "' AND isDefault=1 "));
                        //StringBuilder sb = new StringBuilder();
                        //sb.Append("Delete from f_surgery_rate_list Where Surgery_ID = '" + SurgeryId + "' ");
                        //sb.Append("and PanelID = '" + Util.GetString(dt.Rows[i]["PanelID"].ToString()) + "' ");
                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

                        //sb = new StringBuilder();

                        //sb.Append("INSERT INTO f_surgery_rate_list(Surgery_ID,Rate,PanelID,IPDCaseType_ID,PanelCode,IsCurrent,DateFrom,UserID,ScheduleChargeID)");
                        //sb.Append("Select '" + SurgeryId + "'," + Util.GetDecimal(totalRate) + ",");
                        //sb.Append("'" + Util.GetString(dt.Rows[i]["PanelID"].ToString()) + "',icm.IPDCaseType_ID,'" + txtItemCode.Text.Trim() + "',");
                        //sb.Append("'1',");
                        //sb.Append("'" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + Session["ID"].ToString() + "'," + ScheduleChargeID + " from (Select IPDCaseType_ID from ipd_case_type_master Where IsActive=1) icm ");
                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                    }

            //}
            //}

            Tranx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
            txtSurgeryName.Text = "";
            LoadCacheQuery.DropCentreWiseCache();//
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error Occured! Please contact to administrator.');", true);
        }

        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void Validation()
    {
        //  btnSave.Attributes.Add("OnClick", "SurgeryName('" + txtSurgeryName.ClientID + "');return false;");
    }
}