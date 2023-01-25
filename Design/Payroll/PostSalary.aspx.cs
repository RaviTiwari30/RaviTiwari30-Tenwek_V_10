using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_PostSalary : System.Web.UI.Page
{
    private string MinusSalaryEmployee = string.Empty;

    protected void btnExport_Click(object sender, ImageClickEventArgs e)
    {
        DataTable dt = ViewState["CrossTab"] as DataTable;
        Session["CustomData"] = dt;
        if (dt.Rows.Count > 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
        }
        else
        {
            // lblmsg.Text = "No Record Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void btnFinalClosing_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        string str = string.Empty;
        int a = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            str = "UPDATE pay_empsalary_master mst INNER JOIN pay_employee_master emp ON mst.EmployeeID=emp.Employee_ID  SET mst.BankAccountNo=emp.BankAccountNo,mst.bankID=emp.bankID,mst.BranchID=emp.branchID WHERE MONTH(mst.SalaryMonth)=MONTH('" + txtDate.Text + "') AND YEAR(SalaryMonth)=YEAR('" + txtDate.Text + "') ";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            ///////calculate Total Earning
            str = " update pay_empsalary_master mas inner join (select MasterID,round(sum(Amount),2)Amount from pay_empsalary_detail d inner join pay_empsalary_master mst on mst.ID=d.MasterID " +
            " where RemunerationType='E' and Month(mst.SalaryMonth)=month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "') group by MasterID )det on mas.ID=det.MasterID set mas.TotalEarning=det.Amount where IsPost=0";

            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            ///////calculate Total Earning Round Off
            str = " update pay_empsalary_master mas inner join (select MasterID,round(sum(Amount),2)Amount from pay_empsalary_detail d inner join pay_empsalary_master mst on mst.ID=d.MasterID " +
            " where RemunerationType='E' and Month(mst.SalaryMonth)=month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "') group by MasterID )det on mas.ID=det.MasterID set ERound=Round(TotalEarning-Amount,2) where IsPost=0";
            //comment for ghana
            //a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            ////////////////Update ESI on Gross Amount(Total Earning)
            str = " update pay_empsalary_detail det inner join (select ID,EmployeeID,SalaryMonth,TotalEarning,ERound from pay_empsalary_master where Month(SalaryMonth)=Month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ) mst on mst.ID=det.MasterID " +
            " inner join (select Employee_ID,Amount from pay_employeeremuneration where TypeID=15 and TypeName='ESI' and Amount>0) rem on rem.Employee_ID=mst.EmployeeID " +
            " LEFT OUTER JOIN pay_empsalary_detail det2 ON mst.ID=det2.MasterID AND det2.TypeID=33 " +
            " set det.Amount=ceiling((mst.TotalEarning-(mst.ERound+IFNULL(det2.Amount,0)))*rem.Amount/100) where det.TypeID=15  and det.TypeName='ESI' and  Month(mst.SalaryMonth)=Month('" + txtDate.Text + "') and  Year(mst.SalaryMonth)=Year('" + txtDate.Text + "') ";

            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            ///////update PF Amount in Round Figure
            str = "update pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID set Amount=CEILING(Amount) where TypeID=13 and Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "')";
            //a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            //comment for ghana
            //a = 0;
            ///////update Extra PF Amount in Round Figure
            //str = "update pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID set Amount=Round(Amount) where TypeID=14 and Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "')";
            //a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            //a = 0;

            ///////calculate Total Deduction

            str = " update pay_empsalary_master mas inner join (select MasterID,round(sum(Amount),2)Amount from pay_empsalary_detail d inner join pay_empsalary_master mst on mst.ID=d.MasterID " +
            " where RemunerationType='D' and Month(mst.SalaryMonth)=month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "') group by MasterID )det on mas.ID=det.MasterID set mas.TotalDeduction=det.Amount  where IsPost=0";

            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            ///////calculate net payable
            //comment for ghana  - remove round off
            str = "update pay_empsalary_master set NetPayable=TotalEarning-TotalDeduction where Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";

            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            a = 0;
            /////////////////Calculate ESI Detail

            #region Calculate ESI Detail

            //update basic in esi detail table
            str = " update pay_ESI_detail esi inner join (select MasterID,EmployeeID,Amount from pay_empsalary_detail where TypeID=1)det " +
            " on esi.MasterID=det.MasterID set esi.Basic=Amount where Month(esi.SalaryMonth)=month('" + txtDate.Text + "') and year(esi.SalaryMonth)=year('" + txtDate.Text + "')";

            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            /////update EmployeeContribution in esi detail
            str = " update pay_ESI_detail esi inner join (select MasterID,EmployeeID,Amount from pay_empsalary_detail where TypeID=15)det " +
            " on esi.MasterID=det.MasterID set esi.EmployeeContri=Amount where Month(esi.SalaryMonth)=month('" + txtDate.Text + "')  and Year(esi.SalaryMonth)=Year('" + txtDate.Text + "') ";

            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            //////update total earning
            str = " update pay_ESI_detail esi inner join (select mst.ID,mst.EmployeeID,(TotalEarning-IFNULL(Amount,0))TotalEarning,PayableDays,SalaryMonth from pay_empsalary_master  mst LEFT JOIN pay_empsalary_detail det ON mst.ID=det.MasterID AND TypeID=33  where Month(SalaryMonth)=month('" + txtDate.Text + "')  and Year(SalaryMonth)=Year('" + txtDate.Text + "'))mst " +
            " on esi.MasterID=mst.ID set esi.TotalEarning=ROUND(mst.TotalEarning,0),Days=mst.PayableDays where Month(esi.SalaryMonth)=month('" + txtDate.Text + "') and Year(esi.SalaryMonth)=Year('" + txtDate.Text + "') ";

            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            /////update EmployerContribution in esi detail
            //str = " update pay_ESI_detail set Perks=TotalEarning-Basic,EmployerContri=ceiling(TotalEarning*4.75/100),UserID='" + Session["ID"].ToString() + "' where Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            str = " update pay_ESI_detail esi inner join pay_empsalary_master mst on esi.MasterID=mst.ID  inner join  (select Employee_ID from pay_employeeremuneration where TypeID=15 and Amount>0) emp  " +
            " on esi.EmployeeID=emp.Employee_ID LEFT JOIN pay_empsalary_detail det ON mst.ID=det.MasterID AND TypeID=33 SET esi.EmployerContri=CEILING(((mst.TotalEarning+(Eround)-IFNULL(det.Amount,0)))*4.75/100),Perks=ROUND(esi.TotalEarning-(Basic+ERound),0) where Month(esi.SalaryMonth)=Month('" + txtDate.Text + "') and Year(esi.SalaryMonth)=Year('" + txtDate.Text + "')";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            str = " update pay_esi_detail esi inner join (select ID,EmployeeID,PayableDays from pay_empsalary_master where Month(SalaryMonth)=Month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "')) mst on esi.MasterID=mst.ID set esi.Days=mst.PayableDays ";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            a = 0;

            str = " update pay_esi_detail esi inner join (select Employee_ID,Esi_No from pay_employee_master where ESi_No<>'') emp on esi.EmployeeID=emp.Employee_ID set esi.ESINo=emp.ESI_No";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            a = 0;

            #endregion Calculate ESI Detail

            #region Update PF & Save PF Detail

            //update pf no & DOB
            str = "update pay_pf_detail pf inner join pay_employee_master emp on pf.EmployeeID=emp.Employee_ID set pf.PF_No=emp.PF_No,pf.DOB=Date(emp.DOB) where Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            a = 0;

            //Update Age
            str = "update pay_pf_detail set Age=datediff('" + txtDate.Text + "',Date(DOB))/365 where Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            a = 0;
            ////2
            //update basic in pf detail table (TypeID=1)
            str = "update pay_pf_detail pf inner join pay_empsalary_detail det on pf.MasterID=det.MasterID and TypeID=1 set Basic=det.Amount where Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            a = 0;
            ///3
            //update pf amount in pf detail table (TypeID 13)//12%
            str = "update pay_pf_detail pf inner join pay_empsalary_detail det on pf.MasterID=det.MasterID and TypeID=13 set PF_Amount=det.Amount where Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            a = 0;
            ////4
            //update extra pf amount in pf detail table (TYpeID=14)//Amount
            //////comment for ghana
            //////str = "update pay_pf_detail pf inner join pay_empsalary_detail det on pf.MasterID=det.MasterID and TypeID=14 set Extra_PF_Amount=CEILING(det.Amount) where Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            //////a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            ////a = 0;
            ///////7
            //////////////update pf pension while Basic<=6500(employee share)&&& age Blow 58
            ////str = "update pay_pf_detail pf inner join pay_empsalary_detail det on pf.MasterID=det.MasterID and TypeID=1 and pf.PF_Amount>0 and date_add(Date(DOB),interval 58 year) >= '" + txtDate.Text + "' set Emp_Pension=Round((det.Amount*8.33)/100) where  det.Amount<=6500 and Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            ////a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            ////a = 0;
            ///////7
            //////////////update pf amount while Basic<=6500 (employer share)&&& age Blow 58
            ////str = "update pay_pf_detail pf inner join pay_empsalary_detail det on pf.MasterID=det.MasterID and TypeID=1  and pf.PF_Amount>0  and date_add(Date(DOB),interval 58 year) >= '" + txtDate.Text + "' set Emp_PF=CEILING((det.Amount*3.67)/100) where det.Amount<=6500 and Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            ////a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            ////a = 0;
            ///////8
            //////////////update pf pension while Basic>6500(employer share)&&& age Blow 58
            ////str = "update pay_pf_detail pf inner join pay_empsalary_detail det on pf.MasterID=det.MasterID and TypeID=1  and pf.PF_Amount>0  and date_add(Date(DOB),interval 58 year) >= '" + txtDate.Text + "' set Emp_Pension=541 where det.Amount>6500 and Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            ////a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            ////a = 0;
            //////////////update pf amount while Basic>6500(employer share)&&& age Blow 58
            ////str = "update pay_pf_detail pf inner join pay_empsalary_detail det on pf.MasterID=det.MasterID and TypeID=1  and pf.PF_Amount>0  and date_add(Date(DOB),interval 58 year) >= '" + txtDate.Text + "' set Emp_PF=CEILING(PF_Amount-541) where det.Amount>6500 and Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";

            ////a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            ////a = 0;

            /////////////For Up to 58 Age
            //when people cross age up to 58 his pension account close so all pf amount will save on employer pf account
            //////////update pf pension while Basic<=6500(employee share)&&& age above 58

            str = "update pay_pf_detail pf inner join pay_empsalary_detail det on pf.MasterID=det.MasterID and TypeID=1  and pf.PF_Amount>0  set Emp_PF=(det.Amount*13)/100 where Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            a = 0;
            //////////update pf pension while Basic>6500(employee share)&&& age above 58
            //comment for ghana
            //str = "update pay_pf_detail pf inner join pay_empsalary_detail det on pf.MasterID=det.MasterID and TypeID=1  and pf.PF_Amount>0  and date_add(Date(DOB),interval 58 year) < '" + txtDate.Text + "' set Emp_PF=pf.PF_Amount where det.Amount>6500 and Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            //a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            //a = 0;
            //comment for ghana
            ////str = "update pay_pf_detail set Emp_PF=CEILING(PF_Amount-Emp_Pension) where PF_Amount<>Emp_PF+Emp_Pension and Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') ";
            ////a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            ////a = 0;

            #endregion Update PF & Save PF Detail
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = ex.Message;
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
        Tranx.Commit();
        Tranx.Dispose();
        con.Close();
        con.Dispose();
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
        //lblmsg.Text = "Record Save Successfully ....";
        if (EmpGrid.Rows.Count > 0)
        {
            btnPost.Visible = true;
            // btnExport.Visible = true;
            chkSelect.Visible = true;
            btnFinalClosing.Visible = false;
        }
        Search();
    }

    protected void btnPost_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Query = string.Empty;
            int a = 0;
            foreach (GridViewRow row in EmpGrid.Rows)
            {
                if (((CheckBox)row.FindControl("Select")).Checked)
                {
                    a += 1;
                    if (Util.GetFloat(((Label)row.FindControl("lblTotalEarning")).Text.Trim()) > 0)
                    {
                        Query = "update pay_empsalary_master set IsPost=1,PostDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "' where ID=" + ((Label)row.FindControl("lblID")).Text.Trim() + "";
                        int j = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);

                        //if (j = 1)
                        //{
                        //    Query = "";
                        //}
                    }
                }
            }
            if (a == EmpGrid.Rows.Count)
            {
                Query = "update pay_attendance_date set SalaryPost=1 where Month(Att_To)=Month('" + txtDate.Text + "') and Year(Att_To)=Year('" + txtDate.Text + "')";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
            }
            if (a > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM069','" + lblmsg.ClientID + "');", true);
                //lblmsg.Text = "Salary Post...";
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM070','" + lblmsg.ClientID + "');", true);
                //lblmsg.Text = "Select Post Items";
            }
            Tranx.Commit();
            //Search();
        }
        catch
        {
            // lblmsg.Text = "Error";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

            Tranx.Rollback();
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSarch_Click(object sender, EventArgs e)
    {
        Search();
    }

    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSelect.Checked)
        {
            foreach (GridViewRow row in EmpGrid.Rows)
            {
                if (row.BackColor != System.Drawing.Color.Red)
                {
                    ((CheckBox)row.FindControl("Select")).Checked = true;
                }
            }
        }
        else
        {
            foreach (GridViewRow row in EmpGrid.Rows)
            {
                ((CheckBox)row.FindControl("Select")).Checked = false;
            }
        }
    }

    protected void EmpGrid_Sorting(object sender, GridViewSortEventArgs e)
    {
    }

    protected void EmpRowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[1].Visible = false;
        }
        if (e.Row.RowIndex > -1)
        {
            e.Row.Cells[1].Visible = false;
            if (((Label)e.Row.FindControl("lblIsPost")).Text.Trim() == "1")
            {
                ((CheckBox)e.Row.FindControl("Select")).Checked = true;
            }
            if (Util.GetFloat(((Label)e.Row.FindControl("lblNetPayalbe")).Text.Trim()) < 0)
            {
                e.Row.BackColor = System.Drawing.Color.Red;
                e.Row.ToolTip = "Your Cann't Post Salary.";
                MinusSalaryEmployee += "," + ((Label)e.Row.FindControl("lblEmpID")).Text;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDate();
            //txtDate.SetCurrentDate();
            ViewState["UserID"] = Session["ID"].ToString();
            Search();
        }
    }

    protected void Search()
    {
        lblmsg.Text = "";
        DataTable DtItems = StockReports.GetDataTable("select det.MasterID,det.EmployeeID,TypeID,TypeName,sum(Amount)Amount,SalaryType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID inner join pay_remuneration_master rmst on rmst.ID=det.TypeID and rmst.IsActive=1 where Month(mst.SalaryMonth)=Month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "')  group by TypeID,EmployeeID,SalaryType,MasterID  order by  det.EmployeeID,det.RemunerationType desc,det.TypeID");
        DataTable DtNetPayable = StockReports.GetDataTable("select EmployeeID,Name,concat('A/C ',BankAccountNo)BankAccountNo,TotalEarning,TotalDeduction,NetPayable,SalaryType,ID,IsPost,PayableDays,ERound from pay_empsalary_master where Month(SalaryMonth)=Month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "') order by EmployeeID");
        DataTable Employee = StockReports.GetDataTable("select distinct mst.EmployeeID,mst.ID,SalaryType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where Month(mst.SalaryMonth)=Month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "') order by EmployeeID,TypeID");
        DataTable dt = StockReports.GetDataTable("select Name from pay_remuneration_master where IsActive=1 order by RemunerationType desc,ID");

        DataTable CrossTab = new DataTable();
        if (dt.Rows.Count == 0 || DtItems.Rows.Count == 0 || Employee.Rows.Count == 0)
        {
            //lblmsg.Text = "No Record Found";
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
            return;
        }
        CrossTab.Columns.Add(new DataColumn("ID"));
        CrossTab.Columns.Add(new DataColumn("Employee ID"));
        CrossTab.Columns.Add(new DataColumn("Salary Type"));

        foreach (DataRow row in dt.Rows)
        {
            CrossTab.Columns.Add(new DataColumn(row["Name"].ToString()));
        }

        for (int i = 0; i < Employee.Rows.Count; i++)
        {
            DataRow newrow = CrossTab.NewRow();
            newrow["Employee ID"] = Employee.Rows[i]["EmployeeID"].ToString();
            DataRow[] row = DtItems.Select("EmployeeID='" + Employee.Rows[i]["EmployeeID"].ToString() + "' and MasterID='" + Employee.Rows[i]["ID"].ToString() + "' and SalaryType='" + Employee.Rows[i]["SalaryType"].ToString() + "'");
            for (int j = 0; j < row.Length; j++)
            {
                //string ColumnName = CrossTab.Columns[j+1].ColumnName;
                string ColumnName = row[j]["TypeName"].ToString();
                newrow[ColumnName] = row[j]["Amount"].ToString();
            }
            newrow["Salary Type"] = Employee.Rows[i]["SalaryType"].ToString();
            newrow["ID"] = Employee.Rows[i]["ID"].ToString();

            CrossTab.Rows.Add(newrow);
        }

        CrossTab.Columns.Add(new DataColumn("Total Earning"));
        CrossTab.Columns.Add(new DataColumn("Round"));
        CrossTab.Columns.Add(new DataColumn("Total Deduction"));
        CrossTab.Columns.Add(new DataColumn("Net Payable"));
        CrossTab.Columns.Add(new DataColumn("IsPost"));
        CrossTab.Columns.Add(new DataColumn("Account No."));
        CrossTab.Columns.Add(new DataColumn("Employee Name"));
        //CrossTab.Columns.Add(new DataColumn("ABasic"));
        //CrossTab.Columns.Add(new DataColumn("Actual_Earning"));
        //CrossTab.Columns.Add(new DataColumn("Actual_Deduction"));
        //CrossTab.Columns.Add(new DataColumn("Actual_Net"));
        CrossTab.Columns.Add(new DataColumn("Days"));
        for (int i = 0; i < CrossTab.Rows.Count; i++)
        {
            DataRow[] row = DtNetPayable.Select("EmployeeID='" + CrossTab.Rows[i]["Employee ID"].ToString() + "' and ID='" + CrossTab.Rows[i]["ID"].ToString() + "' and SalaryType='" + CrossTab.Rows[i]["Salary Type"].ToString() + "'");
            if (row.Length > 0)
            {
                CrossTab.Rows[i]["Round"] = row[0]["ERound"].ToString();
                CrossTab.Rows[i]["Total Earning"] = row[0]["TotalEarning"].ToString();
                CrossTab.Rows[i]["Total Deduction"] = row[0]["TotalDeduction"].ToString();
                CrossTab.Rows[i]["Net Payable"] = row[0]["NetPayable"].ToString();
                CrossTab.Rows[i]["IsPost"] = row[0]["IsPost"].ToString();
                CrossTab.Rows[i]["Account No."] = row[0]["BankAccountNo"].ToString();
                CrossTab.Rows[i]["Employee Name"] = row[0]["Name"].ToString();
                CrossTab.Rows[i]["Days"] = row[0]["PayableDays"].ToString();
            }
        }

        CrossTab.Columns["Employee Name"].SetOrdinal(2);
        CrossTab.Columns["Account No."].SetOrdinal(3);

        CrossTab.Columns["Days"].SetOrdinal(4);
        CrossTab.Columns["Total Earning"].SetOrdinal(11);
        EmpGrid.DataSource = CrossTab;
        EmpGrid.DataBind();
        ViewState["CrossTab"] = CrossTab;
        if (MinusSalaryEmployee.Length > 0)
        {
            lblmsg.Text = "Negative Salary Of Employee { " + MinusSalaryEmployee + " }";
        }
    }

    private void BindDate()
    {
        lblFromDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%b %Y')FromDateDisplay from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        txtDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%Y-%m-%d')FromDate from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        if (txtDate.Text.Trim() == "")
        {
            btnSarch.Enabled = false;
            btnFinalClosing.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM067','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Please Post Attendance";
        }
    }
}