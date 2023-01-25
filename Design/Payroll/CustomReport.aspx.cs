using System;
using System.Collections;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_CustomReport : System.Web.UI.Page
{
    private string Query = string.Empty;
    private System.Text.StringBuilder sb = new System.Text.StringBuilder();

    protected void BindGeneralInfo()
    {
        Query = "SELECT EmployeeID,Title,NAME,House_No,Street_Name,Gender,Locality,City,Pincode,PHouse_No,PStreet_Name,PLocality,PCity,PPincode,DOB,  BloodGroup,FatherName,MotherName,HusbandName,PAN_No,PassportNo,Email,Phone,Mobile,DOJ,Dept_ID,Dept_Name,Desi_ID,Desi_name,PF_No,  PF_NOMINEE1,PF_NOMINEE2,BankAccountNo,BankName,BankCode,BranchName,BranchCode,Qualification,Quali_Year,Experience FROM pay_employee_master emp LEFT JOIN  pay_branchmaster bm ON emp.BranchID=bm.Branch_ID LIMIT 0";

        DataTable dt = StockReports.GetDataTable(Query);
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            ListItem list = new ListItem(dt.Columns[i].ColumnName, dt.Columns[i].ColumnName);
            chklEmpGeneralDetail.Items.Add(list);
            ddlCondition1.Items.Add(list);
            ddlCondition2.Items.Add(list);
            ddlCondition3.Items.Add(list);
        }

        chklEmpGeneralDetail.SelectedIndex = 0;

        chklEmpGeneralDetail.Items[chklEmpGeneralDetail.Items.IndexOf(chklEmpGeneralDetail.Items.FindByText("Desi_name"))].Text = "Designation";
        chklEmpGeneralDetail.Items[chklEmpGeneralDetail.Items.IndexOf(chklEmpGeneralDetail.Items.FindByText("Dept_Name"))].Text = "Department";
        chklEmpGeneralDetail.Items[chklEmpGeneralDetail.Items.IndexOf(chklEmpGeneralDetail.Items.FindByText("Desi_ID"))].Text = "DesignationID";
        chklEmpGeneralDetail.Items[chklEmpGeneralDetail.Items.IndexOf(chklEmpGeneralDetail.Items.FindByText("Dept_ID"))].Text = "DepartmentID";
        chklEmpGeneralDetail.Items[chklEmpGeneralDetail.Items.IndexOf(chklEmpGeneralDetail.Items.FindByText("PF_No"))].Text = "SSNIT No";
        chklEmpGeneralDetail.Items[chklEmpGeneralDetail.Items.IndexOf(chklEmpGeneralDetail.Items.FindByText("PF_NOMINEE1"))].Text = "SSNIT NOMINEE1";
        chklEmpGeneralDetail.Items[chklEmpGeneralDetail.Items.IndexOf(chklEmpGeneralDetail.Items.FindByText("PF_NOMINEE2"))].Text = "SSNIT NOMINEE2";
        chklEmpGeneralDetail.Items[chklEmpGeneralDetail.Items.IndexOf(chklEmpGeneralDetail.Items.FindByText("Quali_Year"))].Text = "Year";

        ddlCondition1.Items.Insert(0, "");
        ddlCondition1.SelectedIndex = 0;

        ddlCondition2.Items.Insert(0, "");
        ddlCondition2.SelectedIndex = 0;

        ddlCondition3.Items.Insert(0, "");
        ddlCondition3.SelectedIndex = 0;
    }

    protected void BindRemuneration()
    {
        Query = " select ID,Name from pay_remuneration_master where IsActive=1  and IsLoan=0  AND IsInitial=0";
        DataTable dt = StockReports.GetDataTable(Query);
        chklistRemuneration.DataSource = dt;
        chklistRemuneration.DataValueField = "ID";
        chklistRemuneration.DataTextField = "Name";
        chklistRemuneration.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        try
        {
            int a = 0;
            int b = 0;
            ArrayList TypeName = new ArrayList();
            float Basic = 0;
            sb.Append("Select ");

            for (int i = 0; i < chklEmpGeneralDetail.Items.Count; i++)
            {
                if (chklEmpGeneralDetail.Items[i].Selected)
                {
                    b = 1;
                    sb.Append(chklEmpGeneralDetail.Items[i].Value + ",");
                }
            }
            if (b == 0)
            {
                lblmsg.Text = "Please Select Any 1 Of Employee General Detail";
                return;
            }
            sb.Remove(sb.Length - 1, 1);
            //if (chkBasic.Checked)
            //{
            //    sb.Append(" ,Amount Basic");
            //}
            sb.Replace("EmployeeID", "emp.EmployeeID");
            sb.Append(" from pay_employee_master  emp left join pay_employeeremuneration rem on rem.EmployeeID=emp.EmployeeID and TypeID=1  LEFT JOIN  pay_branchmaster bm ON emp.BranchID=bm.Branch_ID where emp.IsActive=" + RadioButtonList1.SelectedValue + "");
            sb.Replace("DOJ", "date_format(DOJ,'%d %b %Y')DOJ").Replace("DOL", "date_format(DOL,'%d %b %Y')DOL").Replace("DOB", "date_format(DOB,'%d %b %Y')DOB").Replace("JobTimeFrom", "Time_format(IF(JobTimeFrom='00:00:00','',JobTimeFrom),'%h %m %p')JobTimeFrom").Replace("JobTimeTo", "Time_format(IF(JobTimeTo='00:00:00','',JobTimeTo),'%h %m %p')JobTimeTo");
            sb.Replace("BankAccountNo", "concat('A/C ',BankAccountNo)BankAccountNo");

            if (sb.ToString().Contains("Desi_Name"))
            {
                sb.Replace("Desi_Name", "Desi_Name Designation");
            }
            if (sb.ToString().Contains("Dept_Name"))
            {
                sb.Replace("Dept_Name", "Dept_Name Department");
            }

            if (ddlCondition1.SelectedIndex > 0)
            {
                sb.Append(" and ");
                if (ddlCondition1.SelectedIndex > 0 && ddlCondition2.SelectedIndex > 0 && ddlCondition3.SelectedIndex <= 0)
                { sb.Append(" ( "); }
                if (ddlCondition1.SelectedIndex > 0 && ddlCondition3.SelectedIndex > 0 && ddlCondition2.SelectedIndex <= 0)
                { sb.Append(" ( "); }
                if (ddlCondition2.SelectedIndex > 0 && ddlCondition3.SelectedIndex > 0 && ddlCondition1.SelectedIndex <= 0)
                { sb.Append(" ( "); }
                //all 3 condition
                if (ddlCondition1.SelectedIndex > 0 && ddlCondition2.SelectedIndex > 0 && ddlCondition3.SelectedIndex > 0)
                { sb.Append(" ( "); }

                sb.Append(" emp." + ddlCondition1.SelectedItem.Value + "" + ddlOperator1.SelectedItem.Value + "'" + txtCondition1.Text.Trim() + "'");
            }
            if (ddlCondition2.SelectedIndex > 0)
            {
                sb.Append(" " + ddlOperator.SelectedItem.Value + " emp." + ddlCondition2.SelectedItem.Value + "" + ddlOperator2.SelectedItem.Value + "'" + txtCondition2.Text.Trim() + "'");
            }

            if (ddlCondition3.SelectedIndex > 0)
            {
                sb.Append(" " + ddlOperator3.SelectedItem.Value + " emp." + ddlCondition3.SelectedItem.Value + "" + ddlOperator4.SelectedItem.Value + "'" + txtCondition3.Text.Trim() + "'");
            }

            if (ddlCondition1.SelectedIndex > 0 && ddlCondition2.SelectedIndex > 0 && ddlCondition3.SelectedIndex <= 0)
            { sb.Append(" ) "); }
            if (ddlCondition1.SelectedIndex > 0 && ddlCondition3.SelectedIndex > 0 && ddlCondition2.SelectedIndex <= 0)
            { sb.Append(" ) "); }
            if (ddlCondition2.SelectedIndex > 0 && ddlCondition3.SelectedIndex > 0 && ddlCondition1.SelectedIndex <= 0)
            { sb.Append(" ) "); }

            //all 3 condition
            if (ddlCondition1.SelectedIndex > 0 && ddlCondition2.SelectedIndex > 0 && ddlCondition3.SelectedIndex > 0)
            { sb.Append(" ) "); }

            sb.Append(" order by emp.EmployeeID ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            string id = string.Empty;
            foreach (ListItem lst in chklistRemuneration.Items)
            {
                if (lst.Selected)
                {
                    if (a > 0)
                    {
                        id += ",";
                    }
                    a += 1;
                    dt.Columns.Add(new DataColumn(lst.Text));
                    TypeName.Add(lst.Text);
                    id += lst.Value;
                }
            }

            if (a > 0)
            {
                DataTable dtRemun = StockReports.GetDataTable("select emp.EmployeeID,IFNULL(TypeID,'1')TypeID,IFNULL(TypeName,'BASIC')TypeName,IFNULL(Amount,0)Amount,IFNULL(CalType,'AMT')CalType,Per_Cal_Amt FROM pay_employee_master emp  LEFT JOIN pay_employeeremuneration rem ON emp.EmployeeID=rem.EmployeeID AND TypeID in(" + id + ")  where isActive=1 order by emp.EmployeeID,TypeID");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow[] BasicRow = dtRemun.Select("EmployeeID='" + dt.Rows[i]["EmployeeID"].ToString() + "' and CalType='AMT' and TypeID=1");
                    if (BasicRow.Length != 1)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM063','" + lblmsg.ClientID + "');", true);
                        //lblmsg.Text = "Select Basic First!";
                        return;
                    }
                    Basic = Util.GetFloat(BasicRow[0]["Amount"]);
                    DataRow[] row = dtRemun.Select("EmployeeID='" + dt.Rows[i]["EmployeeID"].ToString() + "' and CalType='AMT'");
                    if (row.Length > 0)
                    {
                        for (int j = 0; j < row.Length; j++)
                        {
                            string ColumnName = row[j]["TypeName"].ToString();

                            dt.Rows[i][ColumnName] = row[j]["Amount"];
                        }
                    }
                    DataRow[] row1 = dtRemun.Select("EmployeeID='" + dt.Rows[i]["EmployeeID"].ToString() + "' and CalType='PER'");
                    if (row.Length > 0)
                    {
                        for (int j = 0; j < row1.Length; j++)
                        {
                            string ColumnName = row1[j]["TypeName"].ToString();
                            if (ColumnName == "PF")
                            {
                                dt.Rows[i][ColumnName] = Util.GetFloat(row1[j]["Per_Cal_Amt"]) * Util.GetFloat(row1[j]["Amount"]) / 100;
                            }
                            else if (ColumnName == "ESI")
                            {
                                if (dt.Columns.Contains("TotalEarning"))
                                {
                                    dt.Rows[i][ColumnName] = Util.GetFloat(dt.Rows[i]["TotalEarning"]) * Util.GetFloat(row1[j]["Amount"]) / 100;
                                }
                                else
                                {
                                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM194','" + lblmsg.ClientID + "');", true);
                                    //lblmsg.Text = "Select Total Earning For ESI";
                                    return;
                                }
                            }
                            else
                            {
                                dt.Rows[i][ColumnName] = Basic * Util.GetFloat(row1[j]["Amount"]) / 100;
                            }
                        }
                    }
                }
            }
            if (dt.Columns.Contains("TotalEarning"))
                dt.Columns["TotalEarning"].SetOrdinal(dt.Columns.Count - 1);
            if (dt.Columns.Contains("TotalDeduction"))
                dt.Columns["TotalDeduction"].SetOrdinal(dt.Columns.Count - 1);

            Session["CustomData"] = dt;
            if (dt.Rows.Count > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
            }
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Select Error";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGeneralInfo();
            BindRemuneration();
        }
    }
}