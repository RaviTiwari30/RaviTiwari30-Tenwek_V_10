using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;

public class PanelAllocation
{
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    public PanelAllocation()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }

    public int IsMultipanel(string TransactionId)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT * FROM panel_amountallocation pl WHERE pl.TransactionID='" + TransactionId + "' GROUP BY pl.TransactionID,pl.PanelID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count == 1)
        {
            StringBuilder sbAmount = new StringBuilder();

           
            sbAmount.Append("  SELECT (lt.NetAmount-(SELECT SUM(pl.Amount) FROM panel_amountallocation pl WHERE pl.TransactionID=lt.TransactionID GROUP BY pl.TransactionID))PatientPayable, ");
            sbAmount.Append("  (SELECT SUM(pl.Amount) FROM panel_amountallocation pl WHERE pl.TransactionID=lt.TransactionID GROUP BY pl.TransactionID)PanelPayable ");
            sbAmount.Append("   FROM f_ledgertransaction lt WHERE lt.TransactionID='" + TransactionId + "' ");
            DataTable dtAmount = StockReports.GetDataTable(sbAmount.ToString());

            if (Util.GetDecimal(dtAmount.Rows[0]["PatientPayable"].ToString()) > 0)
            {
                return 1;
            }
            else
            {
                return 0;
            }

        }
        else
        {
            if (dt!=null && dt.Rows.Count>0 )
            {
                return 1;
            }
            else
            {
                return 2;
            }
            
        }


    }


    public int InserDrNotesEntry(string TransactionId, decimal Amount, MySqlTransaction tranx)
    {

        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();

            var sqlCMD = "INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (@panelID,@transactionID,@amount,@userID,@allocationType)";
            var amtall = Util.GetInt(excuteCMD.ExecuteScalar(tranx, sqlCMD, CommandType.Text, new
            {
                panelID = GetPanelId(TransactionId),
                transactionID = TransactionId,
                amount = (Amount * (-1)),
                userID = HttpContext.Current.Session["ID"].ToString(),
                allocationType = "DR"
            }));


            return 1;
        }
        catch (Exception ex)
        {
            return 0;

        }


    }



    public int GetPanelId(string TransacationId)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pl.PanelID FROM panel_amountallocation pl  ");
        sb.Append(" WHERE pl.TransactionID='" + TransacationId + "' GROUP BY pl.TransactionID,pl.PanelID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {

            return Util.GetInt(dt.Rows[0]["PanelID"].ToString());

        }
        else
        {
            return 0;
        }

    }


    public string GetEmergencyTransactionID(string PatientID)
    {
        string TransactionId = "";

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pmh.TransactionID FROM patient_medical_history pmh ");
        sb.Append(" WHERE pmh.PatientID='"+PatientID+"' AND pmh.type='EMG'  ");
        sb.Append(" AND DATE(pmh.DateOfDischarge)>=DATE(DATE_SUB( NOW(),INTERVAL 24 HOUR)) AND DATE(pmh.DateOfDischarge)<=DATE(NOW()) Limit 1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt!=null && dt.Rows.Count>0)
        {
            TransactionId = Util.GetString(dt.Rows[0]["TransactionID"].ToString());
        }
         
        return TransactionId;
         
    }
}