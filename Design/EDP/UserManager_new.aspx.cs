using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_UserManager_New : System.Web.UI.Page
{
    #region Data Binding

    private void BindEmployee()
    {
        StringBuilder sb = new StringBuilder();

        if (ddlRole.SelectedValue == "0")
        {
            sb.Append(" select EM.EmployeeID,em.Name,l.UserName,'false' ltype,'true' ptype from employee_master em left join f_login l on");
            sb.Append(" em.EmployeeID=l.EmployeeID where l.EmployeeID is null order by em.Name");
        }
        else
        {
            sb.Append(" select EM.EmployeeID,em.Name,l.UserName,if(l.username is null,'true','false')ltype,if(l.username is null,'true','false')ptype from employee_master em inner join f_login l on");
            sb.Append(" em.EmployeeID=l.EmployeeID where l.RoleID=" + ddlRole.SelectedValue + " order by em.Name");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdRole.DataSource = dt;
            grdRole.DataBind();
            ViewState.Add("Role", dt);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            grdRole.DataSource = null;
            grdRole.DataBind();
        }
    }

    private void BindRole()
    {
        All_LoadData.bindRole(ddlRole);
        All_LoadData.bindRole(ddlRoleRight);
    }

    #endregion Data Binding

    #region Events Handling

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ViewState["EmpId"] != null)
        {
            string EmpId = Convert.ToString(ViewState["EmpId"]);

            if (StockReports.ExecuteDML("call InsertRole('" + EmpId + "'," + ddlRoleRight.SelectedValue + ")"))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                ViewState.Remove("EmpId");
                BindEmployee();
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
    }

    protected void btnSavePassword_Click(object sender, EventArgs e)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_login WHERE userName='" + txtUser.Text.Trim() + "'"));
        if (count > 0)
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM159','" + lblMsg.ClientID + "');", true);
        else
        {
            if (ViewState["EmpId"] != null)
            {
                string EmpId = Convert.ToString(ViewState["EmpId"]);
                string Insert = "update f_login set userName='" + txtUser.Text.Trim() + "',Password='" + txtPassword.Text.Trim() + "' where EmployeeID='" + EmpId + "'";

                if (StockReports.ExecuteDML(Insert))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                    ViewState.Remove("EmpId");
                    ViewState.Remove("Role");
                    BindEmployee();
                }
                else
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void btnSavePwd_Click(object sender, EventArgs e)
    {
        if (ViewState["EmpId"] != null)
        {
            string str = "update f_login set password='" + txtpwd.Text.Trim() + "' where EmployeeID='" + Convert.ToString(ViewState["EmpId"]) + "'";
            if (StockReports.ExecuteDML(str))
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM160','" + lblMsg.ClientID + "');", true);
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void btnUser_Click(object sender, EventArgs e)
    {
        BindEmployee();
    }

    protected void grdRole_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            if (ViewState["Role"] != null)
            {
                DataTable dt = new DataTable();
                dt = (DataTable)ViewState["Role"];

                string EmpID = Util.GetString(e.CommandArgument);
                ViewState.Add("EmpId", EmpID);

                DataRow[] dr = dt.Select("EmployeeID='" + EmpID + "'");
                if (dr.Length > 0)
                    lblEmpName.Text = Util.GetString(dr[0]["Name"]);

                mpeCreateGroup.Show();
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        if (e.CommandName == "login")
        {
            if (ViewState["Role"] != null)
            {
                DataTable dt = new DataTable();
                dt = (DataTable)ViewState["Role"];

                string EmpID = Util.GetString(e.CommandArgument);
                ViewState.Add("EmpId", EmpID);

                DataRow[] dr = dt.Select("EmployeeID='" + EmpID + "'");
                if (dr.Length > 0)
                {
                    lblEmp.Text = Util.GetString(dr[0]["Name"]);
                    txtUser.Text = Util.GetString(dr[0]["UserName"]);
                }
                ModalPopupExtender1.Show();
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        if (e.CommandName == "Password")
        {
            if (ViewState["Role"] != null)
            {
                DataTable dt = new DataTable();
                dt = (DataTable)ViewState["Role"];

                string EmpID = Util.GetString(e.CommandArgument);
                ViewState.Add("EmpId", EmpID);

                DataRow[] dr = dt.Select("EmployeeID='" + EmpID + "'");
                if (dr.Length > 0)
                    lblemp1.Text = Util.GetString(dr[0]["Name"]);

                ModalPopupExtender2.Show();
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }

    private void RoleBind()
    {
        string str = "  SELECT CONCAT(rm.ID,'#',IFNULL(rm.DeptLedgerNo,''))ID,rm.RoleName FROM f_rolemaster rm WHERE rm.Active=1  GROUP BY rm.ID ORDER BY rm.RoleName  ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0 && dt != null)
        {
            ddlRole1.DataSource = dt;
            ddlRole1.DataTextField = "RoleName";
            ddlRole1.DataValueField = "ID";
            ddlRole1.DataBind();
            ddlRole1.Items.Insert(0, new ListItem("Select", "0"));

            ddlDeptMenu.DataSource = dt;
            ddlDeptMenu.DataTextField = "RoleName";
            ddlDeptMenu.DataValueField = "ID";
            ddlDeptMenu.DataBind();
            ddlDeptMenu.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRole();
            RoleBind();
            bindFormat();
        }
        txtFinYear.Attributes.Add("readOnly", "readOnly");
    }

    #endregion Events Handling

    public string GetFinYear(string date)
    {
        if (Convert.ToDateTime(date).ToString("dd-MMM").ToUpper() == "01-JAN")
        {
            return Convert.ToDateTime(date).Year.ToString().Substring(2, 2);
        }
        else
        {
            if (DateTime.Now > Convert.ToDateTime(date))
            {
                return Convert.ToDateTime(date).Year.ToString().Substring(2, 2) + "-" + Convert.ToDateTime(date).AddYears(1).Year.ToString().Substring(2, 2);
            }
            else
            {
                return Convert.ToDateTime(date).AddYears(-1).Year.ToString().Substring(2, 2) + "-" + Convert.ToDateTime(date).Year.ToString().Substring(2, 2);
            }
        }
    }

    private void ClearData()
    {
        ddlRole1.SelectedIndex = 0;
        ddlDeptMenu.SelectedIndex = 0;
        rblIsDepartment.SelectedIndex = 0;
        rbtnStore.SelectedIndex = 0;
        chkMed.Checked = false;
        chkGen.Checked = false;
    }

    protected void ddlRole1_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlDeptMenu.SelectedIndex = ddlRole1.SelectedIndex;
        string str = "SELECT ID,RoleName,IsStore,IFNULL(DeptLedgerNo,'')DeptLedgerNo,IsGeneral,IsMedical,IsUniversal FROM f_rolemaster where id=" + ddlRole1.SelectedValue + " ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["DeptLedgerNo"].ToString() != "")
            {
                rblIsDepartment.SelectedIndex = 0;
            }
            else
                rblIsDepartment.SelectedIndex = 1;

            if (dt.Rows[0]["IsStore"].ToString() == "1")
            {
                rbtnStore.SelectedIndex = 0;
                chkGen.Visible = true;
                chkMed.Visible = true;
                lblRightsFor.Visible = true;
            }
            else
            {
                rbtnStore.SelectedIndex = 1;
                chkGen.Visible = false;
                chkMed.Visible = false;
                lblRightsFor.Visible = false;
            }

            if (dt.Rows[0]["IsGeneral"].ToString() == "1")
                chkGen.Checked = true;
            else
                chkGen.Checked = false;

            if (dt.Rows[0]["IsMedical"].ToString() == "1")
                chkMed.Checked = true;
            else
                chkMed.Checked = false;

            if (dt.Rows[0]["IsUniversal"].ToString() == "0")
            {
                //  trIsUniversal.Visible = true;
                rblIsUniversal.SelectedIndex = 1;
                //   trFormat.Visible = true;
                DataTable format = StockReports.GetDataTable("SELECT TypeName,InitialChar,Separator1,FinancialYearStart,Separator2,TypeLength,UserID,FormatPreview FROM id_master_format WHERE TypeName='" + ddlRole1.SelectedItem.Text + "' AND IsActive=1 ");
                if (format.Rows.Count > 0)
                {
                    txtInitial.Text = format.Rows[0]["InitialChar"].ToString();
                    ddlSeparator1.SelectedIndex = ddlSeparator1.Items.IndexOf(ddlSeparator1.Items.FindByText(format.Rows[0]["Separator1"].ToString()));
                    txtFinYear.Text = Util.GetDateTime(format.Rows[0]["FinancialYearStart"].ToString()).ToString("dd-MMM-yyyy");
                    ddlSeparator2.SelectedIndex = ddlSeparator2.Items.IndexOf(ddlSeparator2.Items.FindByText(format.Rows[0]["Separator2"].ToString()));
                    ddlLength.SelectedIndex = ddlLength.Items.IndexOf(ddlLength.Items.FindByValue(format.Rows[0]["TypeLength"].ToString()));
                    lblPreview.Text = format.Rows[0]["FormatPreview"].ToString();
                }
            }
            else
            {
                //  trIsUniversal.Visible = false;
                rblIsUniversal.SelectedIndex = 0;
                //   trFormat.Visible = false;
                txtInitial.Text = "";
                txtFinYear.Text = "";
                lblPreview.Text = "";
                ddlSeparator1.SelectedIndex = 0;
                ddlSeparator2.SelectedIndex = 0;
                ddlLength.SelectedIndex = 0;
            }
        }
    }

    private void bindFormat()
    {
        DataTable format = StockReports.GetDataTable("SELECT ID,TypeName FROM master_IdFormat WHERE IsActive=1 AND IsMultiple=1");
        ddlType.DataSource = format;
        ddlType.DataTextField = "TypeName";
        ddlType.DataValueField = "ID";
        ddlType.DataBind();
        ddlType.Items.Insert(0, new ListItem("Select", "0"));
    }

    [WebMethod]
    public static string bindUniversalFormat()
    {
        DataTable dt = StockReports.GetDataTable("SELECT imf.TypeID,imf.TypeName,imf.InitialChar,imf.Separator1,if(imf.FinancialYearStart='0001-01-01','',DATE_FORMAT(imf.FinancialYearStart,'%d-%b-%Y'))FinancialYearStart,imf.Separator2,CAST(LPAD('1',imf.TypeLength,0) AS CHAR)TypeLength,imf.FormatPreview FROM id_master_format imf INNER JOIN master_IdFormat mif ON imf.formatID=mif.ID WHERE imf.IsActive=1 AND mif.isMultiple=1 AND imf.isUniversal=1 AND imf.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'");

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string saveRole(List<role> roleDetail, List<role> FormatDetail)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_rolemaster WHERE UPPER(RoleName)='" + roleDetail[0].RoleName.Trim().ToUpper() + "' and Active=1 "));
        if (count > 0)
        {
            return "2";
        }
        else
        {
            if (roleDetail[0].IsUniversal == 0)
            {
                DataTable dt = new DataTable();
                dt.Columns.AddRange(new DataColumn[2] { new DataColumn("Id", typeof(int)), new DataColumn("InitialCharacter", typeof(string)) });

                for (int i = 0; i < FormatDetail.Count; i++)
                {
                    int chkInitialCha = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM id_master_format WHERE InitialChar='" + FormatDetail[i].InitialCharacter.Trim() + "'  "));
                    if (chkInitialCha > 0)
                    {
                        DataRow dtrow = dt.NewRow();
                        dtrow["Id"] = Util.GetInt(i + 1);
                        dtrow["InitialCharacter"] = FormatDetail[i].InitialCharacter.Trim();
                        dt.Rows.Add(dtrow);
                    }
                }
                if (dt.Rows.Count > 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string LedgerNo = "";
                if (roleDetail[0].IsDepartment == 1)
                {
                    Ledger_Master objLedMas = new Ledger_Master(Tranx);
                    objLedMas.LegderName = roleDetail[0].RoleName.Trim();
                    objLedMas.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objLedMas.GroupID = "DPT";
                    LedgerNo = objLedMas.Insert();
                }
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO f_rolemaster(RoleName,Active,IsStore,IsGeneral,IsMedical,DeptLedgerNo) VALUES('" + roleDetail[0].RoleName.Trim() + "',1," + roleDetail[0].IsStore + "," + roleDetail[0].IsGeneral + "," + roleDetail[0].IsMedical + ",'" + LedgerNo + "')");
                if (roleDetail[0].menuFor.Split('#')[0] != "0")
                {
                    int roleid = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT MAX(ID)roleID from f_rolemaster"));
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO f_file_role(urlID,roleID,EmployeeID,Active,Sno) SELECT urlID," + roleid + ",EmployeeID,Active,Sno FROM f_file_role WHERE roleID=" + roleDetail[0].menuFor.Split('#')[0] + "  ");
                }
                if (roleDetail[0].IsUniversal == 0)
                {
                    for (int i = 0; i < FormatDetail.Count; i++)
                    {
                        string deptLedgerNo = "";
                        if (FormatDetail[i].IsUniversalType == 1)
                        {
                            deptLedgerNo = StockReports.ExecuteScalar("SELECT DeptLedgerNo FROM id_master_format WHERE isUniversal=1 AND formatID=" + FormatDetail[i].formatID + " AND IsActive=1 ");
                            if (deptLedgerNo == "")
                            {
                                return "3";
                            }
                        }

                        string formatPreview = "";
                        if (FormatDetail[i].chkFinancialYear == 1)
                            formatPreview = string.Concat(FormatDetail[i].InitialCharacter.Trim(), FormatDetail[i].Separator1.Trim(), All_LoadData.GetFinYear(FormatDetail[i].FinYear.Trim()), FormatDetail[i].Separator2.Trim(), FormatDetail[i].TextLength.Trim());
                        else
                            formatPreview = string.Concat(FormatDetail[i].InitialCharacter.Trim(), FormatDetail[i].Separator1.Trim(), FormatDetail[i].Separator2.Trim(), FormatDetail[i].TextLength.Trim());
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" INSERT INTO id_master_format(TypeName,InitialChar,Separator1,FinancialYearStart,Separator2,TypeLength,UserID,FormatPreview, ");
                        sb.Append(" formatID,DeptLedgerNo,followDeptLedgerNo,chkFinancialYear,isUniversal,CentreID)VALUES( ");
                        sb.Append(" '" + FormatDetail[i].TypeName.Trim() + "','" + FormatDetail[i].InitialCharacter.Trim() + "','" + FormatDetail[i].Separator1 + "', ");
                        if (FormatDetail[i].chkFinancialYear == 1)
                            sb.Append(" '" + Convert.ToDateTime(FormatDetail[i].FinYear.Trim()).ToString("yyyy-MM-dd") + "', ");
                        else
                            sb.Append(" '" + FormatDetail[i].FinYear.Trim() + "', ");
                        sb.Append("'" + FormatDetail[i].Separator2 + "','" + FormatDetail[i].Length + "','" + HttpContext.Current.Session["ID"].ToString() + "',");
                        sb.Append(" '" + formatPreview + "','" + FormatDetail[i].formatID + "','" + LedgerNo + "', ");
                        if (FormatDetail[i].IsUniversalType == 0)
                            sb.Append(" '" + LedgerNo + "',");
                        else
                            sb.Append(" '" + deptLedgerNo + "' ,");
                        sb.Append(" '" + FormatDetail[i].chkFinancialYear + "','" + FormatDetail[i].IsUniversalType + "','" + HttpContext.Current.Session["CentreID"].ToString() + "') ");
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                    }
                }
                if ((Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/MenuData"))) && (roleDetail[0].menuFor.Split('#')[0] != "0"))
                {
                    System.IO.File.Copy(HttpContext.Current.Server.MapPath("~/Design/MenuData/" + roleDetail[0].menuForText + ".xml"), HttpContext.Current.Server.MapPath("~/Design/MenuData/" + roleDetail[0].RoleName + ".xml"));
                }

                Tranx.Commit();
                LoadCacheQuery.dropCache("DepartmentStore");
                return "1";
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    public class role
    {
        public string RoleName { get; set; }
        public int IsDepartment { get; set; }
        public int IsUniversal { get; set; }
        public int IsUniversalType { get; set; }
        public string menuFor { get; set; }
        public int IsStore { get; set; }
        public int IsGeneral { get; set; }
        public int IsMedical { get; set; }
        public string TypeName { get; set; }
        public int formatID { get; set; }
        public string InitialCharacter { get; set; }
        public string FinYear { get; set; }
        public int chkFinancialYear { get; set; }
        public string Separator1 { get; set; }
        public string Separator2 { get; set; }
        public string Length { get; set; }
        public string FormatPreview { get; set; }
        public string menuForText { get; set; }
        public string TextLength { get; set; }
    }
}