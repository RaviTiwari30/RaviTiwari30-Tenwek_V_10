<%@ WebService Language="C#" Class="SetMaster" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;

[WebService(Namespace = "http://www.itdoseinfo.com/Cssd/SetMaster")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class SetMaster
{
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveSet(string SetName, string Description, string isActive, string setId, int validityDays, string setDeptId, string setDeptName)
    {
        Set st = new Set();
        return st.SaveSet(SetName, Description, isActive, setId, validityDays, setDeptId, setDeptName);

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindSet()
    {
        Set st = new Set();
        DataTable dt = st.LoadSets();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    [WebMethod]
    public string LoadSetsForEdit()
    {
        string sqlCommand = "SELECT IFNULL(st.`Name`,'') 'SetName',st.`Set_ID`,st.`IsActive` FROM cssd_f_set_master st";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCommand));

    }
    [WebMethod]
    public string getEditSetMasterDetails(string setId)
    {
        string sqlCommand = "SELECT IFNULL(st.`Name`,'') 'SetName',IFNULL(st.`Description`,'')'Desc',st.`IsActive`,st.`validityDays`,st.setDeptId FROM cssd_f_set_master st WHERE st.`Set_ID`='" + setId + "' ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCommand));
    }
    [WebMethod]
    public string getCSSDItems(string prefix)
    {
        string sqlCommand = "SELECT im.`ItemID`,im.`TypeName` 'ItemName' FROM f_itemmaster im WHERE im.`TypeName` LIKE '" + prefix + "%' AND im.`isCSSDItem`=1 ORDER BY im.`TypeName`";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCommand));
    }

    [WebMethod(EnableSession = true)]
    public string SaveSetItemMapping(List<SetItemList> data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            ExcuteCMD cmd = new ExcuteCMD();
            string sqlCommand = "UPDATE cssd_set_itemdetail sid  SET sid.`IsActive`=0 WHERE sid.`SetID`=@setId";
            cmd.DML(tnx, sqlCommand, CommandType.Text, new
            {
                setId = data[0].SetID
            });
            foreach (var item in data)
            {
                sqlCommand = "SELECT COUNT(*) FROM cssd_set_itemdetail sid WHERE sid.`ItemID`=@itemId AND sid.`SetID`=@setId";
                int isExist = Util.GetInt(
                    cmd.ExecuteScalar(tnx, sqlCommand, CommandType.Text, new
                    {
                        itemId = item.ItemID,
                        setId = item.SetID
                    }));
                if (isExist > 0)
                {
                    sqlCommand = "UPDATE cssd_set_itemdetail sid  SET sid.`IsActive`=1,sid.`SetName`=@setName,sid.`ItemName`=@itemName,sid.`Quantity`=@qty,sid.`UserID`=@userId WHERE sid.`SetID`=@setId  AND sid.`ItemID`=@itemId ";
                    cmd.DML(tnx, sqlCommand, CommandType.Text, new
                    {
                        setName = item.SetName,
                        itemName = item.ItemName,
                        qty = Util.GetInt(item.Quantity),
                        userId = HttpContext.Current.Session["ID"].ToString(),
                        setId = item.SetID,
                        itemId = item.ItemID
                    });
                }
                else
                {
                    Set_Item_Detail obj = new Set_Item_Detail(tnx);
                    obj.SetID = item.SetID.Trim();
                    obj.SetName = item.SetName.Trim();
                    obj.ItemID = item.ItemID.Trim();
                    obj.ItemName = item.ItemName.Trim();
                    obj.Quantity = Util.GetInt(item.Quantity);
                    obj.UserID = HttpContext.Current.Session["ID"].ToString();
                    obj.IsActive = 1;
                    string Id = obj.Insert();

                }

            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully." });
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod]
    public string loadSetItems(string setId)
    {

        string sqlCommand = "SELECT sid.`SetID`,sid.`SetName`,sid.`ItemID`,sid.`ItemName`,sid.`Quantity` 'Qty' FROM cssd_set_itemdetail sid WHERE sid.`SetID`='" + setId + "' AND sid.`IsActive`=1";
        DataTable dt = StockReports.GetDataTable(sqlCommand);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string validateSetForEdit(string setId)
    {

        string sqlCommmand = "SELECT COUNT(*) FROM cssd_f_batch_tnxdetails bt WHERE bt.`SetID`=@setId AND bt.`IsProcess`=1";
        ExcuteCMD cmd = new ExcuteCMD();
        int isSetUnderBatchProcessing = Util.GetInt(cmd.ExecuteScalar(sqlCommmand, new
        {
            setId = setId
        }));
        if (isSetUnderBatchProcessing > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Set Is Under Batch Processing, Cannot be Edit." });
        sqlCommmand = "SELECT COUNT(*) FROM cssd_requisition bt WHERE bt.`setId`=@setId AND bt.`status`=0";
        int isPendingRequest = Util.GetInt(cmd.ExecuteScalar(sqlCommmand, new
        {
            setId = setId
        }));
        if (isPendingRequest > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Some Requisitions are Pending of this, Cannot be Edit." });



        sqlCommmand = "SELECT IsReceived FROM cssd_f_set_master WHERE Set_ID=@setId";
        int isReceived = Util.GetInt(cmd.ExecuteScalar(sqlCommmand, new
        {
            setId = setId
        }));
        if (isReceived > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Set Items Are Processed Cannot Be Edited." });
        
        
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });
    }

    [WebMethod]
    public string getSetDept() {
        string sqlCommand = "SELECT id,name FROM type_master WHERE typeId=5 ORDER BY NAME";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCommand));   
    
    }
    

}
public class SetItemList
{
    public string SetID { get; set; }
    public string SetName { get; set; }
    public string ItemID { get; set; }
    public string ItemName { get; set; }
    public string Quantity { get; set; }

}