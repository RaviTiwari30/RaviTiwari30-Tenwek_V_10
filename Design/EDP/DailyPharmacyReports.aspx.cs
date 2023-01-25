using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_DailyPharmacyReports : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            txtdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
            divGridView.Visible = false;
        }

        txtdatefrom.Attributes.Add("readOnly", "true");

    }


    private void BindDepartment()
    {
         string strQuery = "SELECT ledgerNumber,ledgerName,rm.IsStore,rm.IsGeneral,rm.IsMedical,rm.IsIndent,rm.ID RoleID FROM f_ledgermaster lm INNER JOIN f_rolemaster rm ON lm.ledgerNumber=rm.DeptLedgerNo WHERE lm.GroupID = 'DPT' AND lm.IsCurrent=1 AND rm.Active=1  order by ledgerName";
         DataTable dt = StockReports.GetDataTable(strQuery);
        ddlDepartment.DataSource = dt;
        ddlDepartment.DataTextField = "ledgerName";
        ddlDepartment.DataValueField = "ledgerNumber";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, "Select");

        ddlDepartment.Items.FindByValue(Session["DeptLedgerNo"].ToString()).Selected = true;
      //  ddlDepartment.Enabled = false;
    }



    [WebMethod(EnableSession = true)]
    public static string GetDataToFill(string DepLedgerNo, string Date)
    {
         
        try
        {
            string OutOfStock =GetOutOfStock(DepLedgerNo,Date);
            string LowInstock = GetLowInStock(DepLedgerNo);
            string PrescribedButOutOfStock = GetPrescribedButOutOfStock(DepLedgerNo, Date);
            string IpdOpdCount = GetIpdAndOpdCount(DepLedgerNo, Date);
            DataTable HandHoverTo = GetHandOverEmployee();

            if (HandHoverTo.Rows.Count>0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = "1",
                    OutOfStock = OutOfStock,
                    LowInstock = LowInstock,
                    PrescribedButOutOfStock = PrescribedButOutOfStock,
                    IpdOpdCount = IpdOpdCount,
                    HandHoverTo = HandHoverTo
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = "2",
                    OutOfStock = OutOfStock,
                    LowInstock = LowInstock,
                    PrescribedButOutOfStock = PrescribedButOutOfStock,
                    IpdOpdCount = IpdOpdCount
                });

            }
                       


        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = "3", data = ex.ToString() });

        }
    }
    public static string GetIpdAndOpdCount(string DepLedgerNo, string Date)
    {
       
        StringBuilder sb = new StringBuilder();
         
        sb.Append(" SELECT * FROM (SELECT COUNT(DISTINCT(pmh.PatientID))PatientCount   ");
        sb.Append(" FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sb.Append(" WHERE DATE(lt.DATE)='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "'  AND lt.DeptLedgerNo='" + DepLedgerNo + "'  AND  lt.TypeOfTnx IN ('Pharmacy-Issue')   )t ");
         
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count>0)
        {
            return dt.Rows[0]["PatientCount"].ToString(); 
        }
        else
        {
            return "";
        }
      
    }

    public static string GetLowInStock(string DepLedgerNo )
    {
         
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT GROUP_CONCAT(tt.ItemName)LowInStock  FROM (SELECT t.* FROM ");
        sb.Append(" (SELECT st.ItemID ,st.ItemName,st.DeptLedgerNo, ");
        sb.Append(" SUM(st.InitialCount)InitialCount,SUM(st.ReleasedCount)ReleasedQty, ");
        sb.Append(" (SUM(st.InitialCount)-SUM(st.ReleasedCount))RemaningQty ");
        sb.Append(" FROM f_stock st  ");
        sb.Append(" GROUP BY st.ItemID)t  ");
        sb.Append(" INNER JOIN f_itemmaster_deptwise fid ON fid.ItemID=t.ItemId");
        sb.Append(" WHERE t.DeptLedgerNo='"+DepLedgerNo+"' AND t.RemaningQty<fid.MinLevel  AND t.RemaningQty>0 )tt GROUP BY tt.DeptLedgerNo ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {

            return dt.Rows[0]["LowInStock"].ToString();
        }
        else
        {
            return "";
        }
    }


    public static string GetOutOfStock(string DepLedgerNo, string Date)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  GROUP_CONCAT(ltd.ItemName) OutOfStock FROM f_ledgertnxdetail ltd  ");
        sb.Append("INNER JOIN  f_ledgertransaction lt ON lt.TransactionID=ltd.TransactionID AND lt.TypeOfTnx IN ('Pharmacy-Issue') ");
        sb.Append(" WHERE DATE(ltd.EntryDate)='"+Util.GetDateTime(Date).ToString("yyyy-MM-dd")+"' AND ltd.DeptLedgerNo='"+DepLedgerNo+"'  AND ltd.ItemID   IN ( ");
        sb.Append(" SELECT t.ItemID FROM (SELECT SUM(st.InitialCount)InitialCount ,SUM(st.ReleasedCount)ReleasedCount, ");
        sb.Append(" (SUM(st.InitialCount)-SUM(st.ReleasedCount))RemainingQty, st.ItemID,st.ItemName FROM f_stock st WHERE st.ItemID!=0 AND st.DeptLedgerNo='"+DepLedgerNo+"'");
        sb.Append("  GROUP BY st.ItemID)t  ");
        sb.Append("  WHERE t.RemainingQty=0 )");
        sb.Append(" GROUP  BY DATE(ltd.EntryDate) ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
       
        if (dt.Rows.Count > 0)
        {

            return dt.Rows[0]["OutOfStock"].ToString();
        }
        else
        {
            return "";
        }
    }


    public static string GetPrescribedButOutOfStock(string DepLedgerNo, string Date)
    {
         
 
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT GROUP_CONCAT(PrescribedButOutOfStock)PrescribedButOutOfStock FROM ");
        sb.Append(" (SELECT  GROUP_CONCAT( fd.ItemName) PrescribedButOutOfStock FROM f_indent_detail fd ");
        sb.Append(" WHERE DATE(fd.dtEntry)>='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND fd.DeptTo='" + DepLedgerNo + "'  ");
        sb.Append(" AND fd.ItemID IN ( ");
         sb.Append(" SELECT t.ItemID FROM (SELECT SUM(st.InitialCount)InitialCount ,SUM(st.ReleasedCount)ReleasedCount, ");
        sb.Append(" (SUM(st.InitialCount)-SUM(st.ReleasedCount))RemainingQty, st.ItemID,st.ItemName FROM f_stock st WHERE st.ItemID!=0 AND st.DeptLedgerNo='"+DepLedgerNo+"'");
        sb.Append("  GROUP BY st.ItemID)t  ");
        sb.Append("  WHERE t.RemainingQty=0 )");

        sb.Append(" UNION ALL");
        sb.Append(" SELECT  GROUP_CONCAT( od.MedicineName) PrescribedButOutOfStock FROM patient_medicine od ");
        sb.Append(" WHERE DATE(od.Date)>='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" AND od.Medicine_ID  IN ( ");
       sb.Append(" SELECT t.ItemID FROM (SELECT SUM(st.InitialCount)InitialCount ,SUM(st.ReleasedCount)ReleasedCount, ");
        sb.Append(" (SUM(st.InitialCount)-SUM(st.ReleasedCount))RemainingQty, st.ItemID,st.ItemName FROM f_stock st WHERE st.ItemID!=0 AND st.DeptLedgerNo='"+DepLedgerNo+"'");
        sb.Append("  GROUP BY st.ItemID)t  ");
        sb.Append("  WHERE t.RemainingQty=0 )");

        sb.Append(" )t");
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
       
        if (dt.Rows.Count > 0)
        {

            return dt.Rows[0]["PrescribedButOutOfStock"].ToString();
        }
        else
        {
            return "";
        }
    }





    public static DataTable GetHandOverEmployee()
    {        
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT DISTINCT( CONCAT(em.Title,' ',em.NAME)) EmpName FROM employee_master em  ");
        sb.Append(" INNER JOIN f_login  fl ON fl.EmployeeID=em.EmployeeID AND fl.RoleID IN(16,161) ");
        sb.Append(" AND fl.EmployeeID NOT IN('EMP001') WHERE em.IsActive=1");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        
        return dt;
    }




    [WebMethod(EnableSession = true, Description = "DailyData")]
    public static string SaveDailyData(string IpdOpdCount, string OutOfStockDrug, string LowStockdrug, string DDATally, string DrugPrescribedButOutOfStock, string HMISIssues, string SpecialOrder, string HandHoverTo, string Signature, string DeptLedgerNo, string DeptName, string Remarks, string SelectedDate)
    {
        string LedgerTransactionNo = string.Empty;
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {           
             
            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO  tenwek_dailypharmacyreport ");
             sb.Append("  (IpdOpdCount,OutOfStockDrug, ");
            sb.Append("   LowStockdrug,DDATally,DrugPrescribedButOutOfStock");
            sb.Append("   ,HMISIssues,SpecialOrder,HandHoverBy,HandHoverTo,");
            sb.Append("    Signature,EntryBy,DeptLedgerNo,DeptName,Remarks,SelectedDate) ");
            sb.Append("VALUES");
            sb.Append("  (@IpdOpdCount,@OutOfStockDrug, ");
            sb.Append("   @LowStockdrug,@DDATally,@DrugPrescribedButOutOfStock");
            sb.Append("   ,@HMISIssues,@SpecialOrder,@HandHoverBy,@HandHoverTo,");
            sb.Append("    @Signature,@EntryBy,@DeptLedgerNo,@DeptName,@Remarks,@SelectedDate) ");
            CountSave = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                IpdOpdCount = IpdOpdCount,
                OutOfStockDrug = OutOfStockDrug,
                LowStockdrug = LowStockdrug,
                DDATally = DDATally,
                DrugPrescribedButOutOfStock = DrugPrescribedButOutOfStock,
                HMISIssues = HMISIssues,
                SpecialOrder = SpecialOrder,
                HandHoverBy = HttpContext.Current.Session["EmployeeName"].ToString(),
                HandHoverTo = HandHoverTo,
                Signature = Signature,
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                DeptLedgerNo = DeptLedgerNo,
                DeptName = DeptName,
                Remarks=Remarks,
                SelectedDate = Util.GetDateTime(SelectedDate).ToString("yyyy-MM-dd")

            });



            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Save  Successfully" });

            }
            else
            {
                tnx.Rollback(); 
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
           
            ClassLog cl = new ClassLog();
            cl.errLog(ex);           
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }




    protected void btngetPrintData_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(dr.EntryDate,'%d-%b-%Y %r')EntryDateTime ,dr.* FROM tenwek_dailypharmacyreport ");
        sb.Append("dr WHERE dr.IsActive=1 AND DATE(dr.SelectedDate)='" + Util.GetDateTime(txtdatefrom.Text.ToString()).ToString("yyyy-MM-dd") + "' AND dr.DeptLedgerNo='" + ddlDepartment.SelectedValue + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grvdetail.DataSource = dt;
        grvdetail.DataBind();
        divGridView.Visible = true;
       // divShowHide.Visible = false;        
    }
    protected void grvdetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "RePrint")
        {
            string Id = Util.GetString(e.CommandArgument);

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT DATE_FORMAT(dr.SelectedDate,'%d-%b-%Y')EntryDateTime ,dr.* FROM tenwek_dailypharmacyreport ");
            sb.Append("dr WHERE dr.ID="+Util.GetInt(Id)+"");
            DataTable dt = StockReports.GetDataTable(sb.ToString());


            if (dt != null && dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();

                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = Convert.ToString(Session["LoginName"]);
                dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                Session["ReportName"] = "DailyPharmacyReport";
                Session["ds"] = ds;
               // ds.WriteXmlSchema("E:\\DailyPharmacyReport.xml");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);

            }

        }
    }
}