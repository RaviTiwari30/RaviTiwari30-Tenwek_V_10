using System;
using System.Data;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for AllUpdatesQuery
/// </summary>
public class AllUpdatesQuery
{



    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    

    #endregion

    #region Overloaded Constructor


    public AllUpdatesQuery()
    {
        objCon = Util.GetMySqlCon();
    }
    public AllUpdatesQuery(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
    }
    #endregion
    public string UpdatePatientProfile(string TransactionID, string OldRoom_ID, int PermanentFlag, string EndDate, string EndTime)
    {
        try
        {
            string RowUpdated = "";
            string strQuery = "";
            if (PermanentFlag == 0)
            {
                strQuery = "update patient_ipd_profile set tobebill=0,IsTempAllocated = 0 where TransactionID='" + TransactionID + "' and TobeBill=1";

            }
            else if (PermanentFlag == 1)
            {
                strQuery = "update patient_ipd_profile set tobebill=0,IsTempAllocated = 0,Status='OUT',EndDate='" + Util.GetDateTime(EndDate).ToString("yyyy-MM-dd") + "',EndTime='" + Util.GetDateTime(EndTime).ToString("HH:mm:ss") + "' where TransactionID='" + TransactionID + "' and Room_ID='" + OldRoom_ID + "' and TobeBill=1";
            }

            else if (PermanentFlag == 2)
            {
                strQuery = "update patient_ipd_profile set Status='IN',IsTempAllocated = 0 where TransactionID='" + TransactionID + "' and Room_ID='" + OldRoom_ID + "' and TobeBill=1";
            }

            if (this.objTrans != null && this.objCon == null)
            {
                RowUpdated = Util.GetString(MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery));

            }

        
            return "1";
        }
        catch (Exception ex)
        {
           
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
    }

}