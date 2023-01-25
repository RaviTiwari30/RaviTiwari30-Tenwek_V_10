using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_IncometaxProcessing : System.Web.UI.Page
{
    private int a = 0;
    private MySqlConnection con;
    private string Query = string.Empty;
    private string Str = string.Empty;

    protected void BindDate()
    {
        lblFromDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%b %Y')FromDateDisplay from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        txtDate.Text = StockReports.ExecuteScalar("select DATE_FORMAT(Att_To,'%Y-%m-%d')FromDate from Pay_Attendance_Date where SalaryPost=0  order by ID DESC");
        if (txtDate.Text.Trim() == "")
        {
            btnCurrentSalary.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM067','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void btnCurrentSalary_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            
            string ToDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y-%m-%d')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");
            int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_empsalary_master where SalaryType='S' and month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "')"));
            if (count == 0)
            {
                lblmsg.Text = "Please Process Salary First";
                return;
            }
            string Year = StockReports.ExecuteScalar("SELECT DATE_FORMAT(Att_From,'%Y')Att_From FROM pay_attendance_date WHERE DATE(Att_To)='" + txtDate.Text + "'");
            DataTable taxslab = StockReports.GetDataTable("SELECT IncomeFrom,IncomeTo,TaxPer,Rate FROM pay_taxslab_masternew WHERE rate>0 AND IsActive=1 AND Year='" + Year.ToString() + "'");
            if (taxslab.Rows.Count > 0)
            {
                foreach (GridViewRow row in EmpGrid.Rows)
                {
                    lblmsg.Text = "";
                    decimal TaxableAmt = Util.GetDecimal(((Label)row.FindControl("lblTaxableAmount")).Text);
                    decimal tax = 0;
                    decimal taxGreater = Util.GetDecimal(StockReports.ExecuteScalar("select Incomefrom from pay_taxslab_masternew where Incomefrom='" + Util.GetDecimal(taxslab.Rows[0]["Incomefrom"]) + "'"));
                    if (TaxableAmt > taxGreater)
                    {
                        for (int i = 0; i < taxslab.Rows.Count; i++)
                        {
                            if ((TaxableAmt >= Util.GetDecimal(taxslab.Rows[i]["IncomeFrom"].ToString())) && (TaxableAmt > Util.GetDecimal(taxslab.Rows[i]["IncomeTo"].ToString())))
                            {
                                tax += Util.GetDecimal(taxslab.Rows[i]["Rate"].ToString());
                            }
                            else if ((TaxableAmt >= Util.GetDecimal(taxslab.Rows[i]["IncomeFrom"].ToString())) && (TaxableAmt < Util.GetDecimal(taxslab.Rows[i]["IncomeTo"].ToString())))
                            {
                                // decimal tam = ((TaxableAmt - (Util.GetDecimal(taxslab.Rows[i]["IncomeFrom"]) - 1)) * Util.GetDecimal(taxslab.Rows[i]["TaxPer"])) / 100;
                                tax += ((TaxableAmt - (Util.GetDecimal(taxslab.Rows[i]["IncomeFrom"]) - 1)) * Util.GetDecimal(taxslab.Rows[i]["TaxPer"])) / 100;
                            }
                        }
                    }

                    string aa = Util.GetString(((Label)row.FindControl("lblMasterID")).Text);
                    DataTable emp = StockReports.GetDataTable("SELECT * FROM pay_remuneration_master WHERE ID='" + ViewState["incometaxtypeid"].ToString() + "'");

                    string str = "Delete det.* from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where mst.EmployeeID='" + Util.GetString(((Label)row.FindControl("lblEmployeeID")).Text) + "' and TypeID='" + ViewState["incometaxtypeid"].ToString() + "' and Month(SalaryMonth)=month('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "')";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                    Query = "insert into pay_empsalary_detail (MasterID,EmployeeID,TypeID,TypeName,Amount,RemunerationType,UserID)values('" + Util.GetString(((Label)row.FindControl("lblMasterID")).Text) + "','" + Util.GetString(((Label)row.FindControl("lblEmployeeID")).Text) + "','" + ViewState["incometaxtypeid"].ToString() + "','" + emp.Rows[0]["Name"].ToString() + "'," + tax + ",'" + emp.Rows[0]["RemunerationType"].ToString() + "','" + ViewState["UserID"].ToString() + "')";
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                }
                Tranx.Commit();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                SearchData();
            }
            else
            {
                lblmsg.Text = "Please Define Tax Slab";
                return;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            Tranx.Rollback();
            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["incometaxtypeid"] = 16;
            ViewState["UserID"] = Session["ID"].ToString();
            BindDate();
        } EnableButton();
    }

    protected void rbtnCalOn_SelectedIndexChanged(object sender, EventArgs e)
    {
        EnableButton();
    }

    protected void SearchData()
    {
        lblmsg.Text = "";
        DataTable DtItems = StockReports.GetDataTable("SELECT mst.ID AS MasterId,mst.EmployeeID,mst.Name,mst.Desi_name Designation,det1.Amount Basic,IFNULL(det2.Amount,0) SSNIT,det1.Amount-IFNULL(det2.Amount,0) TaxableAmount,IFNULL(det3.Amount,0)Tax FROM pay_empsalary_master mst INNER JOIN pay_empsalary_detail det1 ON mst.ID=det1.MasterID AND det1.TypeID=1 LEFT OUTER JOIN pay_empsalary_detail det2 ON mst.ID=det2.MasterID AND det2.TypeID=13 LEFT OUTER JOIN pay_empsalary_detail det3 ON mst.ID=det3.MasterID AND det3.TypeID='" + ViewState["incometaxtypeid"].ToString() + "' WHERE MONTH(SalaryMonth)= MONTH('" + txtDate.Text + "') and Year(SalaryMonth)=Year('" + txtDate.Text + "')");

        DataTable Employee = StockReports.GetDataTable("select distinct mst.EmployeeID,mst.ID,SalaryType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where Month(mst.SalaryMonth)=Month('" + txtDate.Text + "') and Year(mst.SalaryMonth)=Year('" + txtDate.Text + "') order by EmployeeID,TypeID");

        //DataTable dtOther = StockReports.GetDataTable("select Name from pay_remuneration_master where isloan=1 order by ID");
        DataTable CrossTab = new DataTable();
        if (DtItems.Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "No Record Found";
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
            return;
        }

        EmpGrid.DataSource = DtItems;
        EmpGrid.DataBind();
    }

    private void EnableButton()
    {
        btnCurrentSalary.Enabled = true;
        SearchData();
    }
}