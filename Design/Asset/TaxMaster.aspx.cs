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

public partial class Design_TaxMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }
    }


    [WebMethod]
    public static string bindTaxServiceMaster()
    {
        string[] service = AllGlobalFunction.Service;
        DataTable dt = new DataTable();

        dt.Columns.Add("Value");
        dt.Columns.Add("Name");
        foreach (string s in service)
        {
            DataRow dr = dt.NewRow();
            string[] numb = s.Split(',');
            dr["Value"] = numb[0];
            dr["Name"] = numb[0];

            dt.Rows.Add(dr);

        }

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string SaveTaxMaster(string TaxID, string TaxName, int IsDefault, int IsItemRateWithTax, string Savetype, string IsServiceWise, string IsBillWise)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
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
                // Insert into Main Tax Master table ------------------start-----------
                var sqlCMD = "INSERT INTO f_tax_master (TaxName,IsDefault,IsItemRateWithTax,CreatedBy,CreateDate,System_Mac) VALUES(@TaxName,@IsDefault,@IsItemRateWithTax,@CreatedBy,@CreateDate,@System_Mac);SELECT @@identity;";
                var NewTaxID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                  {
                      TaxName = TaxName,
                      IsDefault = IsDefault,
                      IsItemRateWithTax = IsItemRateWithTax,
                      CreatedBy = UserID,
                      CreateDate = CurrentDate,
                      System_Mac = addr,


                  }));
                //- End --------------------------

                // ----- Insert into detail table start ------
                string[] service = AllGlobalFunction.Service;

                foreach (string s in service)
                {
                    int isService = IsServiceWise.Contains(s) ? 1 : 0;
                    int isBillWise = IsBillWise.Contains(s) ? 1 : 0;

                    sqlCMD = "INSERT INTO f_tax_master_detail (TaxID,BillingType,IsServiceWise,IsBillWise,CreatedBy,CreatedDT,System_Mac) VALUES(@TaxID,@BillingType,@IsServiceWise,@IsBillWise,@CreatedBy,@CreatedDT,@System_Mac);";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                     {
                         TaxID = NewTaxID,
                         BillingType = s,
                         IsServiceWise = isService,
                         IsBillWise = isBillWise,
                         CreatedBy = UserID,
                         CreatedDT = CurrentDate,
                         System_Mac = addr,
                     });
                }

                //------------- End--------
                message = "Record Save Successfully";
            }
            else
            {
                var sqlCMD = "UPDATE f_tax_master SET TaxName = @TaxName,IsDefault = @IsDefault,IsItemRateWithTax = @IsItemRateWithTax,UpdatedBy = @UpdatedBy,UpdatedDate = Now(),UpdateSystem_Mac=@UpdateSystem_Mac WHERE TaxId = @TaxId;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    TaxName = TaxName,
                    IsDefault = IsDefault,
                    IsItemRateWithTax = IsItemRateWithTax,
                    UpdatedBy = UserID,
                    UpdateSystem_Mac = addr,
                    TaxId = TaxID,

                });

                 // ----- Update into detail table start ------
                string[] service = AllGlobalFunction.Service;

                foreach (string s in service)
                {
                    int isService = IsServiceWise.Contains(s) ? 1 : 0;
                    int isBillWise = IsBillWise.Contains(s) ? 1 : 0;

                    sqlCMD = "UPDATE f_tax_master_detail SET IsServiceWise=@IsServiceWise,IsBillWise=@IsBillWise,Updateby=@Updateby,UpdateSystem_Mac=@UpdateSystem_Mac,UpdateDT=Now() WHERE TaxID = '" + TaxID + "' and BillingType=@BillingType;";
                    Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                {
                    TaxID = TaxID,
                    BillingType = s,
                    IsServiceWise = isService,
                    IsBillWise = isBillWise,
                    Updateby = UserID,
                    UpdateSystem_Mac = addr,

                }));
                }

                //------------- End--------
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
    public static string bindTaxMaster(int TaxID)
    {

        StringBuilder sb = new StringBuilder();

        //sb.Append(" Select * from f_tax_master ");
        sb.Append("SELECT tm.TaxId,tm.`TaxName`,if(tm.IsDefault=1,'Yes','No')vDefault,tm.IsDefault,if(tm.IsItemRateWithTax=1,'Inclusive','Exclusive')ItemRateWithTax,tm.IsItemRateWithTax,tm.`IsActive`,tmd.`BillingType`,TRIM(BOTH ',' FROM GROUP_CONCAT(if(tmd.IsServiceWise=1,tmd.`BillingType`,'')))ServiceWise,GROUP_CONCAT(CONCAT(tmd.`BillingType`,'#',tmd.IsServiceWise)) IsServiceWise,TRIM(BOTH ',' FROM GROUP_CONCAT(if(tmd.IsBillWise=1,tmd.`BillingType`,'')))BillWise,GROUP_CONCAT(CONCAT(tmd.`BillingType`,'#',tmd.IsBillWise)) IsBillWise ");
        sb.Append(" FROM f_tax_master tm INNER JOIN f_tax_master_detail tmd ON tm.TaxID=tmd.`TaxID` ");

        if (TaxID != 0)
            sb.Append(" where tm.TaxID='" + TaxID + "'");

        sb.Append(" GROUP BY tm.TaxId ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

}

