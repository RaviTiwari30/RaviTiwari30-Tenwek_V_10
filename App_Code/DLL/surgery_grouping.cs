using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for surgery_grouping
/// </summary>
public class surgery_grouping
{
	 #region All Memory Variables

  
    private string _ItemID;
    private string _ItemName;
    private string _Type_ID;
    private decimal _Rate;
    private int _GroupID;
    private string _ID;
    private string _GroupName;
    private string _CreatedBy;
    private int _PanelID;
    private decimal _ScaleOfCost;
    #endregion
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

     #endregion
    #region Overloaded Constructor
    public surgery_grouping()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
	}
    public surgery_grouping(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property
    public virtual string ItemID
    {
        get
        {
            return _ItemID;
        }
        set
        {
            _ItemID = value;
        }
    }
    public virtual string ItemName
    {
        get
        {
            return _ItemName;
        }
        set
        {
            _ItemName = value;
        }
    }
    public virtual string Type_ID
    {
        get
        {
            return _Type_ID;
        }
        set
        {
            _Type_ID = value;
        }
    }
    public virtual decimal Rate
    {
        get
        {
            return _Rate;
        }
        set
        {
            _Rate = value;
        }
    }
    public virtual int GroupID
    {
        get
        {
            return _GroupID;
        }
        set
        {
            _GroupID = value;
        }
    }
    public virtual string ID
    {
        get
        {
            return _ID;
        }
        set
        {
            _ID = value;
        }
    }
    public virtual string GroupName
    {
        get
        {
            return _GroupName;
        }
        set
        {
            _GroupName = value;
        }
    }
    public virtual string   CreatedBy
    {
        get
        {
            return _CreatedBy;
        }
        set
        {
            _CreatedBy = value;
        }
    }
     public virtual int PanelID
    {
        get
        {
            return _PanelID;
        }
        set
        {
            _PanelID = value;
        }
    }
     public virtual decimal ScaleOfCost
    {
        get
        {
            return _ScaleOfCost;
        }
        set
        {
            _ScaleOfCost = value;
        }
    }
    
   
     #endregion
    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_f_surgery_group");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

         
            this.Type_ID = Util.GetString(Type_ID);
            this.ItemID = Util.GetString(ItemID);
            this.Rate = Util.GetDecimal(Rate);
            this.GroupID = Util.GetInt(GroupID);
            this.ItemName = Util.GetString(ItemName);
            this.GroupName = Util.GetString(GroupName);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.PanelID = Util.GetInt(PanelID);
            this.ScaleOfCost = Util.GetDecimal(ScaleOfCost);
           
            cmd.Parameters.Add(new MySqlParameter("@Type_ID", Type_ID));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Rate));
            cmd.Parameters.Add(new MySqlParameter("@GroupID", GroupID));
            cmd.Parameters.Add(new MySqlParameter("@ItemName", ItemName));
         
            cmd.Parameters.Add(new MySqlParameter("@GroupName", GroupName));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@PanelID", PanelID));
            cmd.Parameters.Add(new MySqlParameter("@ScaleOfCost", ScaleOfCost));
            
            Output = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Output.ToString();
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            throw (ex);
        }

    }

 #endregion All Public Member Function
}