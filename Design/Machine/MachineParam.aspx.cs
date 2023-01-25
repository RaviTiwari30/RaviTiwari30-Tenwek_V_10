using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using ICSharpCode.SharpZipLib.Zip;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Web.UI;

public partial class Design_Machine_MachineParam : System.Web.UI.Page
{
    string MachineID=string.Empty , Machine_ParamID=string.Empty;
    Machine objMac = new Machine();
    DataTable dtMachineParam;
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        
        if (!IsPostBack)
        {
            MachineID = Util.GetString(Request.QueryString["MachineID"]);
            Machine_ParamID = Util.GetString(Request.QueryString["MachineParamID"]);
            if (!string.IsNullOrEmpty(Machine_ParamID)) { ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch1", "document.getElementById('ctl00_divMasterNav').style.display='none';", true); }
            ddlMachine.DataSource = objMac.MachineList(Util.GetInt(Session["CentreID"].ToString()));
            ddlMachine.DataTextField = "MachineName";
            ddlMachine.DataValueField = "MachineID";
            ddlMachine.DataBind();
            ddlMachine.Items.Insert(0, new ListItem("--Select--", "0"));
            ddlMachine.SelectedIndex = ddlMachine.Items.IndexOf(ddlMachine.Items.FindByValue(MachineID));
            bindMachineParam();
            BindlstMapping();
            BindlstPending();
        }
    }

    void bindMachineParam()
    {
        try
        {
            dtMachineParam = new DataTable();
            dtMachineParam = objMac.MachineParam(ddlMachine.SelectedValue).Copy();
            ddlMachineParam.DataSource = dtMachineParam;
            ddlMachineParam.DataTextField = "Machine_Param";
            ddlMachineParam.DataValueField = "Machine_ParamID";
            ddlMachineParam.DataBind();
            ddlMachineParam.Items.Insert(0, new ListItem("--Select--", "0"));
            ddlMachineParam.SelectedIndex = ddlMachineParam.Items.IndexOf(ddlMachineParam.Items.FindByValue(Machine_ParamID));
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }

    }
 
    void bindModifiedParam()
    {
        try
        {
            dtMachineParam = new DataTable();
            dtMachineParam = objMac.BindMachineParam(ddlMachine.SelectedValue).Copy();
            ddlMachineParam.DataSource = dtMachineParam;
            ddlMachineParam.DataTextField = "Machine_Param";
            ddlMachineParam.DataValueField = "Machine_ParamID";
            ddlMachineParam.DataBind();
            ddlMachineParam.Items.Insert(0, new ListItem("--Select--", "0"));
            ddlMachineParam.SelectedIndex = ddlMachineParam.Items.IndexOf(ddlMachineParam.Items.FindByValue(Util.GetString(Request.QueryString["MachineParamID"])));
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
    private void BindlstMapping()
    {
        lstMapping.DataSource = objMac.AvailableMapping(ddlMachineParam.SelectedValue);
        lstMapping.DataTextField = "name";
        lstMapping.DataValueField = "LabObservation_ID";
        lstMapping.DataBind();
    }
    private void BindlstPending()
    {

        lstPending.DataSource = objMac.PendingMapping(ddlMachineParam.SelectedValue);
        lstPending.DataTextField = "name";
        lstPending.DataValueField = "LabObservation_ID";
        lstPending.DataBind();
    }
    protected void SaveMapping_Click(object sender, EventArgs e)
    {
        if (ddlMachine.SelectedItem.Text == "--Select--")
        {
            lblMsg.Text = "Please Select Machine ID";
            return;
        }
        if (ddlMachineParam.SelectedItem.Text == "--Select--")
        {
            lblMsg.Text = "Please Select Machine Param ID ";
            return;
        }
        string MachineCentreID = objMac.GetMachineCentreID(ddlMachine.SelectedValue);
        if (((Button)sender).CommandName == "Add")
        {
            foreach (ListItem li in lstPending.Items)
            {
                if (li.Selected)
                {
                    objMac.InsertMapping(ddlMachine.SelectedValue, ddlMachineParam.SelectedValue, txtAlias.Text, li.Value, Session["ID"].ToString(), MachineCentreID);
                }
            }


        }
        else if(((Button)sender).CommandName == "Delete")
        {
            foreach (ListItem li in lstMapping.Items)
            {
                if (li.Selected)
                {
                    objMac.DeleteMapping(ddlMachineParam.SelectedValue, li.Value);
                }
            }

        }
        BindlstMapping();
        //BindlstPending();
    }
    protected void ddlMachine_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindMachineParam();
        BindlstMapping();
        //BindlstPending();
    }
    protected void ddlMachineParam_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindlstMapping();
        //BindlstPending();
        txtAlias.Text = ddlMachineParam.SelectedItem.Text ;
    }
    
    [WebMethod(EnableSession=true)]
    public static string Savedetails(string MachineParam, string Machine, string ParamAlias, string Suffix, string AssayNo, string RoundUpto, string IsOrderable, string MinLength)
    {
        string msg = string.Empty;
        try
        {
            int ItemCount = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM " + AllGlobalFunction.MachineDB + ".mac_machineparam WHERE Machine_paramID='" + MachineParam + "'"));
            if (ItemCount > 0)
            {
                msg = "Parameter Already Exist";
            }
            else if (MachineParam.Trim() == "")
            {
                msg = "Machine Param ID Can Not Be Blank";
            }
            else
            {
                Machine objMachine = new Machine();
                string MachineCentreID = objMachine.GetMachineCentreID(Machine);
                msg = objMachine.InserParam(MachineParam, Machine, ParamAlias, Suffix, AssayNo, RoundUpto, IsOrderable, MinLength, HttpContext.Current.Session["ID"].ToString(), MachineCentreID);
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            msg = ex.Message;
        }
        return msg;
    }
    [WebMethod]
    public static string BindMachineParams(string MachineId)
    {
        Machine machineobject = new Machine();
        return Newtonsoft.Json.JsonConvert.SerializeObject(machineobject.BindMachineParam(MachineId));
    }
    [WebMethod]
    public static string BindMachine()
    {
        Machine machineobject = new Machine();
        return Newtonsoft.Json.JsonConvert.SerializeObject(machineobject.MachineList(Util.GetInt(HttpContext.Current.Session["CentreID"].ToString())));
    }

    [WebMethod(EnableSession=true)]
    public static string UpdateDetail(string Machine, string Machineparam, string ParamAlias, string Suffix, string AssayNo, string RoundUpto, string IsOrderable, string MinLength)
    {
        string msg = string.Empty;
        try
        {
          Machine macobj = new Machine();
          string MachineCentreID = macobj.GetMachineCentreID(Machine);
          msg = macobj.UpdateParam(Machine, Machineparam, ParamAlias, Suffix, AssayNo, RoundUpto, IsOrderable, MinLength, HttpContext.Current.Session["ID"].ToString(), MachineCentreID);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            msg = ex.Message;
        }
        return msg;
    }
    [WebMethod(EnableSession=true)]
    public static string SaveMachine(string MachineName, string MachineAlias)
    {
        string msg = string.Empty;
        try
        {
            Machine macobj = new Machine();
            msg = macobj.SaveMachine(MachineName, MachineAlias, HttpContext.Current.Session["ID"].ToString(), HttpContext.Current.Session["CentreID"].ToString());
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            msg = ex.Message;
        }
        return msg;
    }
    public static string WriteFile(string centreid)
    {
        try
        {
            string MySqlPath = @"C:\ApolloUAT\offline_mac_data\";
            if (centreid.Trim() == "")
                return "";

          
            //creating backup file
            Process p = new Process();
            p.StartInfo.FileName = MySqlPath + "mysqldump.exe";

            p.StartInfo.Arguments = String.Format(" -h 172.16.200.54  -u ess -pebizframe@mscl42!0 -P 4210 " + AllGlobalFunction.MachineDB + " --set-gtid-purged=OFF --tables mac_machinemaster mac_machineparam mac_param_master --where=\"CentreID={0}\" --result-file \"C:\\ApolloUAT\\offline_mac_data\\{0}_master.sql\"",
                                    centreid
                                    );
            
            p.StartInfo.UseShellExecute = false;
            p.StartInfo.CreateNoWindow = false;
            p.StartInfo.RedirectStandardOutput = true;
            p.StartInfo.RedirectStandardError = true;
            p.Start();

            p.WaitForExit();
            p.Dispose();

            string text = File.ReadAllText(String.Format("C:\\ApolloUAT\\offline_mac_data\\{0}_master.sql", centreid));
            text = text.Replace("SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;", "");
            text = text.Replace("SET @@SESSION.SQL_LOG_BIN= 0;", "");
            text = text.Replace("SET @@GLOBAL.GTID_PURGED='';", "");
            text = text.Replace("SET @@SESSION.SQL_LOG_BIN = @/;", "");

            text = text.Replace("`mac_machinemaster`", AllGlobalFunction.MachineDB + ".mac_machinemaster");
            text = text.Replace("`mac_machineparam`", AllGlobalFunction.MachineDB + ".mac_machineparam");
            text = text.Replace("`mac_param_master`", AllGlobalFunction.MachineDB + ".mac_param_master");
            File.WriteAllText(String.Format("C:\\ApolloUAT\\offline_mac_data\\{0}_master.sql", centreid), text);
            return "Mapping Sync Successfully.";
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SyncData()
    {
        try
        {
            string result = WriteFile(HttpContext.Current.Session["CentreID"].ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = result, message = result });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
        }
    }
  
}
