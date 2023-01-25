
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
public partial class Design_Store_DuePharmacyReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                //txtSearchFromDate.S

                txtSearchFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtSearchToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                //All_LoadData.bindDocTypeList(ddlDept, 5, "--Select--");
                DataTable dt = All_LoadData.LoadRole(Util.GetString(HttpContext.Current.Session["id"]), Util.GetString(HttpContext.Current.Session["CentreID"].ToString()));

                ddlDept.DataSource = dt;
                ddlDept.DataTextField = "RoleName";
                ddlDept.DataValueField = "ID";
                ddlDept.DataBind();
                string id = StockReports.ExecuteScalar("SELECT ID FROM `f_rolemaster` WHERE DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "' LIMIT 1");
        
                ddlDept.SelectedValue = id;
               
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (Session["ds"] != null)
        {


            DataSet ds = new DataSet();
            // ds.WriteXmlSchema(@"D:\PharmacyBalance.xml");
            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }

    }
    protected void ddlDept_SelectedIndexChanged(object sender, EventArgs e)
    {
    }
    [WebMethod(EnableSession = true)]
    public static string SearchOPDBills(string MRNo, string panelID, string fromDate, string toDate, string centreId, string billNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IF(pm.PatientID='CASH002',(SELECT CONCAT(Title,' ',NAME) FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo),CONCAT(pm.Title,' ',pm.Pname))PName,");
        sb.Append(" REPLACE( IF(pm.PatientID='CASH002',(SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo),lt.PatientID),'OUT1','Walk In')PatientID, ");
        sb.Append(" lt.CentreID ,cm.centreName,if(lt.IpNo<>'',REPLACE(lt.IPNo,'ISHHI',''),'')IPDNo,lt.NetAmount,(lt.NetAmount-lt.adjustment)BalanceAmt, ");
        sb.Append("  lt.adjustment,lt.LedgerTransactionNo,lt.TypeOfTnx,lt.BillNo,DATE_FORMAT(lt.BillDate,'%d-%b-%Y')BillDate,CONCAT(em.Title,' ',em.Name)EmpName , pnl.Company_Name ");
        sb.Append("  FROM f_ledgertransaction lt  INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID ");
        sb.Append("  INNER JOIN  employee_master em ON em.employeeID=lt.userid INNER JOIN center_master cm ON cm.centreID=lt.CentreID ");
        sb.Append("  INNER JOIN f_panel_master pnl ON pnl.PanelID=lt.PanelID ");
        sb.Append(" WHERE   lt.IsLablePrint=0 AND TypeOftnx IN ('Pharmacy-Issue') AND lt.NetAmount<>lt.adjustment AND lt.IsCancel=0 AND lt.CentreID IN ('" + HttpContext.Current.Session["CentreID"].ToString() + "') and lt.DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' ");//and lt.BillNo like 'SIB%' 
        if (MRNo != "")
        {
            if (MRNo.ToUpper().Contains("OUT"))
            {
                sb.Append(" AND (SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo)='" + MRNo + "' ");
            }
            else
            {
                sb.Append(" AND lt.PatientID='" + MRNo + "'");
            }
        }

        //if (txtIPDNO.Text.Trim() != "")
          //  sb.Append(" AND lt.IPNo='ISHHI" + txtIPDNO.Text.Trim() + "'");
        // if (txtMRNo.Text.Trim() != "" && txtIPDNO.Text.Trim() != "")
        // {
        sb.Append("     AND DATE(lt.Billdate)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' ");
        sb.Append("     AND DATE(lt.Billdate)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        // }

        
        sb.Append("    ORDER BY DATE(lt.Billdate)  ");
        DataTable dtSearch = StockReports.GetDataTable(sb.ToString());
        if (dtSearch.Rows.Count > 0 && dtSearch != null)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(HttpContext.Current.Session["LoginName"]);
            dtSearch.Columns.Add(dc);


            DataSet ds = new DataSet();
            ds.Tables.Add(dtSearch.Copy());
           // ds.WriteXmlSchema(@"D:\PharmacyBalance.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "DueBill";
            

            return Newtonsoft.Json.JsonConvert.SerializeObject(dtSearch);
        }
        else
            return "";

    }

    
}