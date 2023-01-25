using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Visitors_Answer
/// </summary>
public class Visitors_Answer
{
    #region All Memory Variables

    private string _Visitor_ID;
    private string _VisitID;
    private int _Question_Id;
    private string _Question;
    private string _Answer;
    private string _Remarks;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Visitors_Answer()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Visitors_Answer(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Visitor_ID
    {
        get
        {
            return _Visitor_ID;
        }

        set
        {
            _Visitor_ID = value;
        }
    }

    public virtual string VisitID
    {
        get
        {
            return _VisitID;
        }

        set
        {
            _VisitID = value;
        }
    }

    public virtual int Question_Id
    {
        get
        {
            return _Question_Id;
        }

        set
        {
            _Question_Id = value;
        }
    }

    public virtual string Question
    {
        get
        {
            return _Question;
        }

        set
        {
            _Question = value;
        }
    }

    public virtual string Answer
    {
        get
        {
            return _Answer;
        }

        set
        {
            _Answer = value;
        }
    }

    public virtual string Remarks
    {
        get
        {
            return _Remarks;
        }

        set
        {
            _Remarks = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string iPkValue;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("bb_visitors_answer_Insert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "identity";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;

            this.Visitor_ID = Util.GetString(Visitor_ID);
            this.VisitID = Util.GetString(VisitID);
            this.Question_Id = Util.GetInt(Question_Id);
            this.Question = Util.GetString(Question);
            this.Answer = Util.GetString(Answer);
            this.Remarks = Util.GetString(Remarks);

            cmd.Parameters.Add(new MySqlParameter("@_Visitor_ID", Visitor_ID));
            cmd.Parameters.Add(new MySqlParameter("@_VisitID", VisitID));
            cmd.Parameters.Add(new MySqlParameter("@_Question_Id", Question_Id));
            cmd.Parameters.Add(new MySqlParameter("@_Question", Question));
            cmd.Parameters.Add(new MySqlParameter("@_Answer", Answer));
            cmd.Parameters.Add(new MySqlParameter("@_Remarks", Remarks));
            iPkValue = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue.ToString();
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