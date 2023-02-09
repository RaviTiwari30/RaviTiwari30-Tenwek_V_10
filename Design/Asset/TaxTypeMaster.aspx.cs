using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Net.NetworkInformation;
using System.Configuration;
using System.Web.UI.HtmlControls;
using System.Web.Services;

public partial class Design_Asset_TaxTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindTaxName();
            BindDefaultFormula();
        }
    }
    private void BindTaxName()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT TaxId,TaxName  FROM f_tax_master ");

        ddlname.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlname.DataTextField = "TaxName";
        ddlname.DataValueField = "TaxId";
        ddlname.DataBind();
        ddlname.Items.Insert(0, new ListItem("Select", ""));
    }
    private void BindDefaultFormula()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT ID,Name  FROM f_taxformulaMaster ");

        ddlFormula.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlFormula.DataTextField = "Name";
        ddlFormula.DataValueField = "ID";
        ddlFormula.DataBind();
        ddlFormula.Items.Insert(0, new ListItem("Select", ""));
    }
    [WebMethod(EnableSession = true)]
    public static string SaveTaxTypeMaster(string TaxName, string TaxID, string TaxType, int TaxFormulaId, int IsActive, string Savetype)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            // var TaxID = "";
            var message = "";

            string addr = "";
            foreach (NetworkInterface n in NetworkInterface.GetAllNetworkInterfaces())
            {
                if (n.OperationalStatus == OperationalStatus.Up)
                {
                    addr += n.GetPhysicalAddress().ToString();
                    break;
                }
            }
            var CurrentDate = Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd");
            var UserID = HttpContext.Current.Session["ID"].ToString();

            if (Savetype == "Save")
            {
                var sqlCMD = "INSERT INTO f_taxtype_master (TaxID,TaxType,TaxFormulaId,IsActive,CreatedBy,CreatedDT,System_Mac) VALUES(@TaxID,@TaxType,@TaxFormulaId,@IsActive,@CreatedBy,@CreatedDT,@System_Mac);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    TaxID =TaxName,
                    TaxType = TaxType,
                    TaxFormulaId = TaxFormulaId,
                    IsActive = IsActive,
                    CreatedBy = UserID,
                    CreatedDT = CurrentDate,
                    System_Mac = addr,


                });
                message = "Record Save Successfully";
            }
            else
            {
                string sqlCMD = "UPDATE f_taxtype_master SET TaxType = @TaxType,TaxFormulaId = @TaxFormulaId,IsActive=@IsActive,Updateby = @Updateby,UpdateDT = Now(),UpdateSystem_Mac=@UpdateSystem_Mac WHERE ID = '" + TaxID + "';";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    TaxType = TaxType,
                    TaxFormulaId = TaxFormulaId,
                    IsActive = IsActive,
                    Updateby = UserID,
                    TaxId=TaxID,
                    UpdateDT = CurrentDate,
                    UpdateSystem_Mac = addr,
                    ID = TaxID,

                });

             

                message = "Record Updated Successfully";
            }
           
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
 
    [WebMethod]
    public static string bindTaxTypeMasterDetails(int ID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT tm.TaxName,ttm.TaxType,ttm.Id FormulaId,CONCAT(tfm.NAME, ' ','(',tfm.Formula,')')TaxFormulaId,CASE WHEN ttm.Isactive = '1' THEN 'Yes' ELSE 'No' END IsActiveValue,ttm.Isactive  FROM f_taxtype_master ttm ");
        sb.Append(" INNER JOIN f_tax_master tm ON tm.TaxId = ttm.ID ");
        sb.Append(" INNER JOIN f_taxformulamaster tfm ON ttm.TaxFormulaId=tfm.ID    ");
        if (ID != 0)
            sb.Append(" where tm.TaxID='" + ID + "'");

        sb.Append(" GROUP BY ttm.ID ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
}