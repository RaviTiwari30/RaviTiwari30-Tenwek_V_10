using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.Services;

public partial class Design_EDP_TokenGenerationMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //BindCategory();
        }
    }

    //private void BindCategory()
    //{
    //    string str = "select CategoryID,Name from f_categorymaster where CategoryID IN (Select CategoryID  from f_ConfigRelation where ConfigID in  (1,2,3,4,5,6,7,9,10,11,14,20,22,24,25,27,28,23) ) order by Name ";
    //    DataTable dt = StockReports.GetDataTable(str);
    //    if (dt.Rows.Count > 0)
    //    {
    //        ddlCategory.DataSource = dt;
    //        ddlCategory.DataTextField = "Name";
    //        ddlCategory.DataValueField = "CategoryID";
    //        ddlCategory.DataBind();
    //        //ListItem li = new ListItem("ALL", "ALL");
    //        //ddlGroups.Items.Add(li);
    //        //ddlGroups.SelectedIndex = ddlGroups.Items.IndexOf(ddlGroups.Items.FindByText("ALL"));
    //        ddlCategory.Text = "";
    //    }
    //    else
    //    {
    //        ddlGroups.Items.Clear();
    //        lblMsg.Text = "No Groups Found";
    //    }
    //}

    public static void SaveGroup(string groupname, string resettype, string CentreID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        using (MySqlTransaction tr = con.BeginTransaction())
        {
            try
            {
                string query = "insert into Id_Master_token(GroupName,ResetType,CentreID) values(@GroupName,@ResetType,@CentreID)";
                using (MySqlCommand cmd = new MySqlCommand(query,con,tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@GroupName", groupname);
                    cmd.Parameters.AddWithValue("@ResetType", resettype);
                    cmd.Parameters.AddWithValue("@CentreID", CentreID);
                    cmd.ExecuteNonQuery();
                    tr.Commit();
                    cmd.Parameters.Clear();
                    con.Close();
                }
            }
            catch
            {
                tr.Rollback();
            }
        }
    }

    public static int GetMaxID()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int maxID = 0;

        string query = "SELECT IFNULL(MAX(GroupID),0) Id FROM Id_Master_token";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            maxID = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
        }
        return maxID;
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string SaveTokenmasterDetail(string tokentype, string catId, string subcatid, string seq, string resettype, string groupname, string modalityName, string modalityID,string CentreID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int groupid = 0;
        string isexists = isGroupNameExists(groupname, CentreID);

        if (isexists != "\"Exists\"")
        {
            SaveGroup(groupname, resettype, CentreID);
        }
        groupid = GetMaxID();

        if (subcatid == "undefined")
        {
            subcatid = "0";
        }

        using (MySqlTransaction tr = con.BeginTransaction())
        {
            if (modalityID == "undefined")
            {
                modalityID = "0";
            }
            try
            {
                string query = "insert into token_master_detail(Token_Type,CategoryID,SubCategoryID,ModalityID,GroupID,Sequence,ResetType,CentreID) values(@Token_Type,@CategoryID,@SubCategoryID,@modalityID,@GroupID,@Sequence,@ResetType,@CentreID)";
                using (MySqlCommand cmd = new MySqlCommand(query,con,tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@Token_Type", tokentype);
                    cmd.Parameters.AddWithValue("@CategoryID", catId);
                    cmd.Parameters.AddWithValue("@SubCategoryID", subcatid);
                    cmd.Parameters.AddWithValue("@GroupID", groupid);
                    cmd.Parameters.AddWithValue("@Sequence", seq);
                    cmd.Parameters.AddWithValue("@ResetType", resettype);
                    cmd.Parameters.AddWithValue("@modalityID", modalityID);
                    cmd.Parameters.AddWithValue("@CentreID", CentreID);
                    cmd.ExecuteNonQuery();
                    tr.Commit();
                    cmd.Parameters.Clear();
                    con.Close();
                }
            }
            catch(Exception ex) 
            {
                tr.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { Success = true });
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string BindDetail(string CategoryID)
    {
        DataTable dtcategoryDetail = StockReports.GetDataTable("SELECT cm.CentreName, tmd.Token_Type, tmd.CategoryID, tmd.SubCategoryID, tmd.GroupID, tmd.Sequence, tmd.ResetType,(SELECT NAME FROM modality_master WHERE ID =tmd.ModalityID )ModalityName,tmd.ModalityID  FROM token_master_detail tmd inner join Center_Master cm on cm.CentreID= tmd.CentreID WHERE tmd.CategoryID='" + CategoryID + "'");
        if (dtcategoryDetail.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtcategoryDetail);
        else
            return "";
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetCategoryName(string CategoryID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string cat = "";

        string query = "SELECT IFNULL(cm.Name,'') NAME FROM f_categorymaster cm WHERE categoryID='" + CategoryID + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cat = cmd.ExecuteScalar().ToString();
            con.Close();
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(cat);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetGroupName(int GroupID) 
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string group = "";

        string query = "SELECT IFNULL(GroupName,'') GroupName FROM Id_MAster_token WHERE GroupID='" + GroupID + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            group = cmd.ExecuteScalar().ToString();
            con.Close();
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(group);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetSubCategoryName(string SubCategoryID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string subcat = "";

        if (SubCategoryID != "0")
        {
            string query = "SELECT IFNULL(sm.Name,'') NAME FROM f_subcategorymaster sm WHERE SubCategoryID='" + SubCategoryID + "'";
            using (MySqlCommand cmd = new MySqlCommand(query, con))
            {
                cmd.CommandType = CommandType.Text;
                subcat = cmd.ExecuteScalar().ToString();
                con.Close();
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(subcat);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string isGroupNameExists(string groupName,string CentreID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string isExists = "";
        int count = 0;

        string query = "SELECT COUNT(*) FROM Id_MAster_token WHERE GroupName='" + groupName + "' and CentreID =" + CentreID + " ";
        using (MySqlCommand cmd = new MySqlCommand(query, con)) 
        {
            cmd.CommandType = CommandType.Text;
            count = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
        }

        if (count > 0)
        {
            isExists = "Exists";
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(isExists);
    }
    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string checkTokenPrefixExist(string Prefix,string CentreID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string isExists = "";
        int count = 0;

        string query = "SELECT count(*) FROM  token_master_detail WHERE sequence='" + Prefix + "' and CentreID=" + CentreID + "";
        using (MySqlCommand cmd = new MySqlCommand(query, con)) 
        {
            cmd.CommandType = CommandType.Text;
            count = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
        }

        if (count > 0)
        {
            isExists = "Exists";
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(isExists);
    }

    

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string IsActive(int GroupID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string isactive = "";

        string query = "SELECT IsActive FROM Id_MAster_token WHERE GroupID='" + GroupID + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            isactive = cmd.ExecuteScalar().ToString();
            con.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(isactive);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string EditGroup(string GroupName)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "UPDATE Id_MAster_token SET IsActive=0 WHERE GroupName='" + GroupName + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.ExecuteNonQuery();
            con.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new { Success = true });
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string CheckModalityExists(string modalityID)
    {
        int isExists = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(modalityid) FROM token_master_detail WHERE modalityid='" + modalityID + "' "));
        return Newtonsoft.Json.JsonConvert.SerializeObject(isExists);
    }
}