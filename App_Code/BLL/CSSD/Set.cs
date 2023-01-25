using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web;

/// <summary>
/// Summary description for Set
/// </summary>
public class Set
{
    public Set()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public string SaveSet(string SetName, string Description, string isActive, string setId,int validityDays,string setDeptId,string setDept)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string str = "select COUNT(*) from cssd_f_set_master  WHERE Name='" + SetName.Trim() + "' AND Set_ID<>'" + setId.Trim() + "' ";
            int IsExist = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, str));
            if (IsExist > 0)
            {
                Tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Set Already Exist." });
            }

            if (setId == "" || setId == "0")
            {
                Set_master sm = new Set_master(Tnx);
                sm.SetName = SetName;
                sm.Description = Description;
                sm.UserID = HttpContext.Current.Session["ID"].ToString();
                sm.IsActive = Util.GetInt(isActive);
                sm.validityDays = validityDays;
                sm.setDeptId = Util.GetInt(setDeptId);
                sm.setDept = Util.GetString(setDept);
                string SetID = sm.Insert();
                Tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully." });
            }
            else
            {
                str = "UPDATE cssd_f_set_master st SET st.Name=@setName,st.Description=@desc,st.LastUpdatedBy=@userId,st.LastUpdateDate=NOW(),st.IsActive=@isActive,st.validityDays=@validityDays,st.setDeptId=@setDeptId,st.setDepartment=@setDepartment WHERE st.Set_ID=@setId";
                ExcuteCMD cmd = new ExcuteCMD();
                cmd.DML(Tnx, str, CommandType.Text, new
                {
                    setName = SetName,
                    desc = Description,
                    userId = HttpContext.Current.Session["ID"].ToString(),
                    setId = setId,
                    isActive=Util.GetInt(isActive),
                    validityDays=validityDays,
                    setDeptId=Util.GetInt(setDeptId),
                    setDepartment=setDept
                });
                Tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully." });
            }

        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable LoadSets()
    {
        DataTable dt = new DataTable();
        AllSelectQuery Aq = new AllSelectQuery();
        return Aq.LoadSets();
    }

    public DataTable LoadSetHavingItem()
    {
        DataTable dt = new DataTable();
        AllSelectQuery Aq = new AllSelectQuery();
        return Aq.LoadSetHavingItem();
    }

    public DataTable loadSetItems(string SetID)
    {
        DataTable dt = new DataTable();
        AllSelectQuery Aq = new AllSelectQuery();
        return Aq.loadSetItems(SetID);
    }
}