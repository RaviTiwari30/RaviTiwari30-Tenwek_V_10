using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;

/// <summary>
/// Summary description for OT
/// </summary>
public class OT_AutoCompletion
{
    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #region Overloaded Constructor

    public OT_AutoCompletion()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public OT_AutoCompletion(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    public string[] GetAssistant(string prefixText, int count)
    {
        objCon = Util.GetMySqlCon();
       
        if (count == 0)
        {
            count = 10;
        }

        if (prefixText.Equals("xyz"))
        {
            return new string[0];
        }
        DataTable dtTemp;
        List<string> items = new List<string>(count);
        try
        {
            string sSQL = "SELECT distinct(Ass_Doc1) FROM ot_operationrecord WHERE Ass_Doc1 Like '" + prefixText + "%'";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
                for (int i = 0; i < dtTemp.Rows.Count; i++)
                    items.Add(dtTemp.Rows[i][0].ToString());
            }
            else
                items.Add("No Doctor");
            return items.ToArray();
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            // Util.WriteLog(ex);

            // Util.WriteLog(sParams);
            throw (ex);
        }
    }

    public string[] GetDiagnosis(string prefixText, int count)
    {
        objCon = Util.GetMySqlCon();
       
        if (count == 0)
        {
            count = 10;
        }

        if (prefixText.Equals("xyz"))
        {
            return new string[0];
        }
        DataTable dtTemp;
        List<string> items = new List<string>(count);
        try
        {
            string sSQL = "SELECT distinct(pre_diagnosis) FROM ot_operationrecord WHERE pre_diagnosis Like '" + prefixText + "%'";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
                for (int i = 0; i < dtTemp.Rows.Count; i++)
                    items.Add(dtTemp.Rows[i][0].ToString());
            }
            else
                items.Add("No Diagnosis");
            return items.ToArray();
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            // Util.WriteLog(ex);

            // Util.WriteLog(sParams);
            throw (ex);
        }
    }

    public string[] GetPosition(string prefixText, int count)
    {
        objCon = Util.GetMySqlCon();
        if (count == 0)
        {
            count = 10;
        }

        if (prefixText.Equals("xyz"))
        {
            return new string[0];
        }
        DataTable dtTemp;
        List<string> items = new List<string>(count);
        try
        {
            string sSQL = "SELECT distinct(Position) FROM ot_notes WHERE Position Like '" + prefixText + "%'";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
                for (int i = 0; i < dtTemp.Rows.Count; i++)
                    items.Add(dtTemp.Rows[i][0].ToString());
            }
            else
                items.Add("No Position");
            return items.ToArray();
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            // Util.WriteLog(ex);

            // Util.WriteLog(sParams);
            throw (ex);
        }
    }
}