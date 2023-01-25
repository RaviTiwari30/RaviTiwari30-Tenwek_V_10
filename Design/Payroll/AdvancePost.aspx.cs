using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_AdvancePost : System.Web.UI.Page
{
    public float TotalAmount = 0;
    private string Query = string.Empty;

    protected void BindDate()
    {
        lblFromDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%b %Y')FromDateDisplay from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        txtDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%Y-%m-%d')FromDate from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        if (txtDate.Text.Trim() == "")
        {
            btnSave.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM067','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Please Post Attendance";
        }
        // DateTo.SetDate(
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        Save();
    }

    protected void btnsaveReasion_Click(object sender, EventArgs e)
    {
        if (txtreasion.Text.Length > 0)
        {
            try
            {
                //Status 2 Reject
                StockReports.ExecuteDML("update pay_advancemaster set Status=2 where Adv_ID='" + lblAdvanceNo.Text.Trim() + "' and EmployeeID='" + lblEmpID.Text.Trim() + "'");
                //  lblmsg.Text = "Record Save";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);

                BindData();
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                //lblmsg.Text = ex.Message;
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM068','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Remove Narration Required!";
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindData();
    }

    protected void btnupdate_Click(object sender, EventArgs e)
    {
    }

    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (GridView1.Rows.Count > 0)
        {
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                ((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked = CheckBox1.Checked;
            }
        }
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Select")
        {
            mAdmit.Show();
            lblEmpID.Text = e.CommandArgument.ToString().Split('#')[0];
            lblAdvanceNo.Text = e.CommandArgument.ToString().Split('#')[1];
        }
    }

    protected void OpenPopUp(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            //e.Row.Cells.
        }
    }

    protected void OpenPopUp(object sender, GridViewCommandEventArgs e)
    {
        //string EmployeeID = e.CommandArgument.ToString();
        //mpeCreateGroup.Show();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDate();
            ViewState["UserID"] = Session["ID"].ToString();
            //txtDate.SetCurrentDate();

            BindData();
        }
    }

    protected void Save()
    {
        string str = string.Empty;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        int a = 0;
        try
        {
            if (GridView1.Rows.Count > 0)
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_empsalary_master where  SalaryType='S' and month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "')"));
                if (count == 0)
                {
                    string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");
                    //str = "insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID) select EmployeeID,Name,BankAccountNo,'S','" + txtDate.Text + "',0,'" + ViewState["UserID"].ToString() + "' from pay_employee_master where IsActive=1";
                    str = "insert into pay_empsalary_master(EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID,Dept_ID,Dept_Name,Desi_ID,Desi_Name) select EmployeeID,Name,BankAccountNo,'S','" + txtDate.Text + "',0,'" + ViewState["UserID"].ToString() + "',Dept_ID,Dept_Name,Desi_ID,Desi_Name from pay_employee_master emp inner join (select EmployeeID,PayableDays from pay_attendance where Month(Attendance_To)=Month('" + txtDate.Text + "') and Year(Attendance_To)=Year('" + txtDate.Text + "')) att on emp.EmployeeID=att.EmployeeID and  DATE(DOJ)<'" + txtDate.Text + "' AND (  DATE(DOL)='0001-01-01' OR DATE(DOL)='0000-00-00' OR (DATE(DOL)>='" + ToDate + "' AND DATE(DOL)<='" + txtDate.Text + "')) and PayableDays>0 ";
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                    if (a == 0)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        // lblmsg.Text = "Error";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                        return;
                    }
                    a = 0;
                    str = "insert into pay_esi_detail(MasterID,EmployeeID,Name,SalaryMonth)select ID,EmployeeID,Name,SalaryMonth from pay_empsalary_master where  SalaryType='S' and Date(SalaryMonth)=Date('" + txtDate.Text + "')";
                    //str = "insert into pay_empsalary_master (EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID)values('" + EmpID + "','" + EmpDetail.Rows[i]["Name"].ToString() + "','" + EmpDetail.Rows[i]["BankAccountNo"].ToString() + "','S','" + DateTime.Now.ToString("MM-yyyy") + "',0,'" + ViewState["UserID"].ToString() + "')";
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                    if (a == 0)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        // lblmsg.Text = "Error";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                        return;
                    }
                    a = 0;
                    str = " insert into pay_pf_detail (MasterID,EmployeeID,Name,SalaryMonth) select ID,EmployeeID,Name,SalaryMonth from pay_empsalary_master  where  SalaryType='S' and Date(SalaryMonth)=Date('" + txtDate.Text + "')";
                    //str = "insert into pay_empsalary_master (EmployeeID,Name,BankAccountNo,SalaryType,SalaryMonth,IsPost,UserID)values('" + EmpID + "','" + EmpDetail.Rows[i]["Name"].ToString() + "','" + EmpDetail.Rows[i]["BankAccountNo"].ToString() + "','S','" + DateTime.Now.ToString("MM-yyyy") + "',0,'" + ViewState["UserID"].ToString() + "')";
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                    if (a == 0)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        //lblmsg.Text = "Error";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                        return;
                    }
                    a = 0;
                }
                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked)
                    {
                        string MasterID = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Max(ID) from pay_empsalary_master where IsPost=0 and EmployeeID='" + ((Label)GridView1.Rows[i].FindControl("lblEmpID")).Text.Trim() + "' and SalaryType='S' and Month(SalaryMonth)=Month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "')  order by EntDate desc").ToString();
                        //string MasterID = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Max(ID) from pay_empsalary_master where IsPost=0 and EmployeeID=" + ((Label)GridView1.Rows[i].FindControl("lblEmpID")).Text.Trim() + "  order by EntDate desc").ToString();
                        if (MasterID == "" || MasterID == String.Empty)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            //lblmsg.Text = "Error";
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                            return;
                        }

                        str = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID,TransactionType)values(" + MasterID + ",'" + ((Label)GridView1.Rows[i].FindControl("lblEmpID")).Text.Trim() + "','" + ((Label)GridView1.Rows[i].FindControl("lblTypeID")).Text.Trim() + "','STAFF LOAN'," + ((Label)GridView1.Rows[i].FindControl("lblInstallmentAmt")).Text.Trim() + ",'D','" + Session["ID"].ToString() + "',3)";
                        a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                        if (a == 0)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            //lblmsg.Text = "Error";
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                            return;
                        }
                        a = 0;
                        str = "update pay_advancemaster set Rec_Installment=Rec_Installment+1,ReceiveAmount=ReceiveAmount + " + ((Label)GridView1.Rows[i].FindControl("lblInstallmentAmt")).Text.Trim() + " where EmployeeID='" + ((Label)GridView1.Rows[i].FindControl("lblEmpID")).Text.Trim() + "' and AdV_ID='" + ((Label)GridView1.Rows[i].FindControl("lblAdvID")).Text.Trim() + "'";

                        a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                        if (a == 0)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            //lblmsg.Text = "Error";
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

                            return;
                        }
                        a = 0;
                        str = "insert into pay_advancedetail(MasterID,ADV_ID,EmployeeID,Amount,Install_No,UserID,TypeID,EMIMonth)values(" + MasterID + ",'" + ((Label)GridView1.Rows[i].FindControl("lblAdvID")).Text.Trim() + "','" + ((Label)GridView1.Rows[i].FindControl("lblEmpID")).Text.Trim() + "'," + ((Label)GridView1.Rows[i].FindControl("lblInstallmentAmt")).Text.Trim() + ",1,'" + Session["ID"].ToString() + "'," + ((Label)GridView1.Rows[i].FindControl("lblTypeID")).Text.Trim() + ",'" + txtDate.Text + "')";
                        //str = "insert into pay_advancedetail(MasterID,ADV_ID,EmployeeID,Amount,Install_No,UserID,TypeID)values(" + MasterID + ",'" + ((Label)GridView1.Rows[i].FindControl("lblAdvID")).Text.Trim() + "','" + ((Label)GridView1.Rows[i].FindControl("lblEmpID")).Text.Trim() + "'," + ((Label)GridView1.Rows[i].FindControl("lblInstallmentAmt")).Text.Trim() + ",1,'" + Session["ID"].ToString() + "'," + ((Label)GridView1.Rows[i].FindControl("lblTypeID")).Text.Trim() + ")";
                        a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                        if (a == 0)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            //   lblmsg.Text = "Error";
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                            return;
                        }

                        a = 0;
                    }
                    str = "update pay_advancemaster set Status=1 where Installment=Rec_Installment";
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                    //if (a == 0)
                    //{
                    //    Tranx.Rollback();
                    //    Tranx.Dispose();
                    //    con.Close();
                    //    con.Dispose();
                    //    lblmsg.Text = "Error";
                    //    return;
                    //}
                }
                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);

                BindData();
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            //  lblmsg.Text = "Error";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
    }

    private void BindData()
    {
        Query = "select mst.AdV_ID,mst.EmployeeID,(select Name from pay_employee_master where EmployeeID=mst.EmployeeID)Name,mst.Amount,Installment,Installment-Rec_Installment Remaining," +
        " if(InstallmentAmount>(mst.Amount-ReceiveAmount),(mst.Amount-ReceiveAmount),InstallmentAmount)InstallmentAmount,ReceiveAmount," +
        " Status,DATE_FORMAT(mst.EntDate,'%d-%b-%Y')Date,mst.UserID,AdvanceID from pay_advancemaster  mst" +
        " left join (select * from  pay_advancedetail where Month(EMIMonth)=Month('" + txtDate.Text + "') and Year(EMIMonth)=Year('" + txtDate.Text + "')) det" +
        " on mst.AdV_ID=det.ADV_ID where Status=0 and Installment-Rec_Installment>0 and (mst.Amount-ReceiveAmount)>0 and det.AdV_ID is null";
        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            //lblmsg.Text = dt.Rows.Count + " Record Found";
            GridView1.DataSource = dt;
            GridView1.DataBind();
            TotalAmount = Util.GetFloat(dt.Compute("sum(InstallmentAmount)", ""));
            btnSave.Visible = true;
        }
        else
        {
            GridView1.DataSource = null;
            GridView1.DataBind();
            btnSave.Visible = false;
        }
    }
}