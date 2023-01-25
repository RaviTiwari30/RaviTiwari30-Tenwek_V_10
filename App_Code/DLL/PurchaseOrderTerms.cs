using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for PurchaseOrderTerms
/// </summary>
public class PurchaseOrderTerms
{
    #region All Property

    private int _PoTermsID;

    public int PoTermsID
    {
        get { return _PoTermsID; }
        set { _PoTermsID = value; }
    }

    private string _PONumber;

    public string PONumber
    {
        get { return _PONumber; }
        set { _PONumber = value; }
    }

    private string _Details;

    public string Details
    {
        get { return _Details; }
        set { _Details = value; }
    }

    #endregion All Property

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public PurchaseOrderTerms()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PurchaseOrderTerms(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region All Public Member Function

    public void InsertTerms()
    {
        int iPkValue;
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO f_purchaseorderterms(PONumber,Details)");
            objSQL.Append("VALUES (@PONumber, @Details)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.PONumber = Util.GetString(PONumber);
            this.Details = Util.GetString(Details);

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@PONumber", PONumber),
                new MySqlParameter("@Details", Details));

            iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);
            throw (ex);
        }
    }

    public string[] GetTermsConditions(string prefixText, int count)
    {
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
            string sSQL = "SELECT distinct(Details) FROM f_purchaseorderterms WHERE Details Like '" + prefixText + "%'";

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
                items.Add("No Suggestion");
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

    #endregion All Public Member Function
}