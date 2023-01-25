using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_DeleteSingleEmployeeSalary : System.Web.UI.Page
{
    protected void BindDate()
    {
        lblFromDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%b %Y')FromDateDisplay from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        txtDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%Y-%m-%d')FromDate from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        if (txtDate.Text.Trim() == "")
        {
            btnSearch.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM067','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Please Post Attendance";
        }
        // DateTo.SetDate(
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string str = "SELECT mst.ID,mst.EmployeeID,NAME,SalaryType,SalaryMonth,TotalEarning,TotalDeduction,ERound,PayableDays,NetPayable FROM pay_empsalary_master mst WHERE EmployeeID='" + txtEmpID.Text.Trim() + "'  AND MONTH(SalaryMonth)=MONTH('" + txtDate.Text.Trim() + "') AND YEAR(SalaryMonth)=YEAR('" + txtDate.Text.Trim() + "')";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            empGrid.DataSource = dt;
            empGrid.DataBind();
        }
        else
        {
            empGrid.DataSource = null;
            empGrid.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "No Record Found";
        }
    }

    protected void empGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        int i = 0;
        try
        {
            string EmployeeID = e.CommandArgument.ToString().Split('#')[0];
            string MasterID = e.CommandArgument.ToString().Split('#')[1];
            string SalaryType = e.CommandArgument.ToString().Split('#')[2];

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            // Update Loan Master

            sb.Append(" update pay_loanmaster loanM inner join pay_loandetail lod on loanM.LoanNo=lod.LoanNo inner join pay_empsalary_master mst on mst.ID=lod.MasterID ");
            sb.Append(" set Rec_Installment=Rec_Installment-1,ReceiveAmount=ReceiveAmount - lod.InstallAmount,loanM.Status=0 ");
            sb.Append(" where Month(mst.SalaryMonth)=Month('" + txtDate.Text.Trim() + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text.Trim() + "')  and IsPost=0 and mst.ID='" + MasterID + "'  ");
            i = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            sb.Remove(0, sb.Length);
            i = 0;
            //update security
            sb.Append(" update pay_securitymaster secm inner join pay_securitydetail sd on secm.SEC_ID=sd.SEC_ID inner join pay_empsalary_master mst on mst.ID=sd.MasterID ");
            sb.Append(" set Rec_Installment=Rec_Installment-1,ReceiveAmount=ReceiveAmount - sd.Amount,secm.Status=0 ");
            sb.Append(" where Month(mst.SalaryMonth)=Month('" + txtDate.Text.Trim() + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text.Trim() + "')  and IsPost=0 and mst.ID='" + MasterID + "'  ");
            i = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            sb.Remove(0, sb.Length);
            i = 0;

            //Update Advance Master
            sb.Append(" update pay_advancemaster advm inner join pay_advancedetail ad on advm.Adv_ID=ad.Adv_ID inner join pay_empsalary_master mst on mst.ID=ad.MasterID ");
            sb.Append(" set Rec_Installment=Rec_Installment-1,ReceiveAmount=ReceiveAmount - ad.Amount,advm.Status=0 ");
            sb.Append(" where Month(mst.SalaryMonth)=Month('" + txtDate.Text.Trim() + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text.Trim() + "')  and IsPost=0 and mst.ID='" + MasterID + "'  ");
            i = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            sb.Remove(0, sb.Length);
            i = 0;

            //// Delete Arrear Detail from pay_arreardetail
            if (SalaryType == "A")
            {
                sb.Append(" delete arr from pay_empsalary_master mst inner join pay_arreardetail arr on mst.EmployeeID=arr.EmployeeID and Date(mst.ArrearMonth)=Date(arr.ArrearMonth) ");
                sb.Append(" where Month(mst.SalaryMonth)=Month('" + txtDate.Text.Trim() + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text.Trim() + "') and SalaryType='A' and IsPost=0 and arr.EmployeeID='" + EmployeeID + "'");
                i = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                sb.Remove(0, sb.Length);
                i = 0;
            }

            //////////for delete salary (PF,ESI,LoanDetail,AdvanceDetail,Remuneration, and Master)

            sb.Append(" delete loan,adv,esi,pf,det,mst,ot,sd from pay_empsalary_master mst LEFT OUTER join pay_empsalary_detail det on mst.ID=det.masterID ");
            sb.Append(" left outer join pay_pf_detail pf on mst.ID=pf.MasterID left outer join pay_esi_detail esi on mst.ID=esi.MasterID ");
            sb.Append(" left outer join pay_loandetail loan on mst.ID=loan.MasterID left outer join pay_advancedetail adv on mst.ID=adv.MasterID ");
            sb.Append(" LEFT OUTER JOIN pay_overtime ot ON mst.ID=ot.MasterID ");
            sb.Append(" LEFT OUTER JOIN pay_securitydetail sd ON mst.ID=sd.MasterID ");
            sb.Append(" where Month(mst.SalaryMonth)=Month('" + txtDate.Text.Trim() + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text.Trim() + "') and IsPost=0 and mst.ID='" + MasterID + "'  ");
            if (SalaryType == "A")
            {
                sb.Append(" and mst.SalaryType='A' ");
            }
            else
            {
                sb.Append(" and mst.SalaryType='S' ");
            }

            i = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            sb.Remove(0, sb.Length);
            i = 0;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM072','" + lblmsg.ClientID + "');", true);
            // lblmsg.Text = "Salary Delete Successfully";

            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            btnSearch_Click(sender, e);
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
        }
    }

    //MySqlConnection objCon;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmpID.Focus();
            ViewState["UserID"] = Util.GetString(Session["ID"]);
            bool IsValid = CheckRights(ViewState["UserID"].ToString(), Request.FilePath);

            if (IsValid == false)
            {
                //Response.Redirect("../NotAuthorized.aspx");
            }
            txtEmpID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            BindDate();
        }
    }

    private bool CheckRights(string UserID, string Path)
    {
        bool Status = Util.GetBoolean(StockReports.ExecuteScalar("Select if(ifnull(ID,0)>0,'True','False')Status from user_pageauthorise where UserID='" + UserID + "' and urlPath ='" + Path + "'"));
        return Status;
    }
}