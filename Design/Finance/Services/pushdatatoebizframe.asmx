<%@ WebService Language="C#" Class="pushdatatoebizframe" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using System.Text;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class pushdatatoebizframe : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public string PushMasterData()
    {
        string myConnString = System.Configuration.ConfigurationManager.AppSettings["OracleConnectionFinance"];
        OracleConnection myConnection = new OracleConnection(myConnString);
        try
        {
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM `ess`.`entity_master` WHERE IsSend=0");
            if (dt.Rows.Count > 0)
            {
                myConnection.Open();
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;
                        sb.Append("INSERT INTO ENTITY$MASTER (ID,ACC_CODE,ACC_NM,ACC_TYPE,INSERT_TYPE) VALUES ("+ dt.Rows[i]["ID"].ToString() +",'" + dt.Rows[i]["FieldNameID"] + "','" + dt.Rows[i]["FieldName"].ToString().Replace("'","") + "','" + dt.Rows[i]["FieldTypeID"].ToString() + "','" + dt.Rows[i]["INSERT_TYPE"].ToString() + "') ");

                        cmd.CommandText = sb.ToString();
                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE `ess`.`entity_master` SET IsSend=1, UpdateDate=NOW() WHERE ID = " + dt.Rows[i]["ID"].ToString() + "");
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('entity_master','" + ex.Message.Replace("'","~") + "','" + sb.ToString().Replace("'","~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                        StockReports.ExecuteDML("UPDATE `ess`.`entity_master` SET IsSend=30 WHERE ID = " + dt.Rows[i]["ID"].ToString() + "");
                        return sb.ToString();
                    }
                }

                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();
            }

            dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.trans$dtl l WHERE l.DOCUMENT_DATE>='2019-07-01' AND l.IsSync=0;");
            if (dt.Rows.Count > 0)
            {
                myConnection.Open();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;
                        string DocumentDate = Util.GetDateTime(dt.Rows[i]["DOCUMENT_DATE"]).ToString("dd-MMM-yyyy");
                        string BILL_DT = Util.GetDateTime(dt.Rows[i]["BILL_DT"]).ToString("dd-MMM-yyyy");

                        sb.Append("INSERT INTO trans$dtl (ID,TRANS_NO,COMPANYCODE,PatientID,PATIENT_NAME,DoctorID,DOCTOR_NAME,DEPARTMENT_ID,DEPARTMENT_NAME,");
                        sb.Append("CURRENCY_NAME,DOCUMENT_ID,DOCUMENT_DATE,BILL_NO,BILL_AMOUNT,DISC_AMT,REMARK,PanelID,PANELNAME,");
                        sb.Append("GL_VOU_ID,IMP_FLG,VOU_NO,REVENUE_ACCOUNT,CC_1,CC_2,CC_3,CC_4,CC_5,CURR_CONV,TRAN_TYPE,MODULE,IS_BILLED,USR_ID,USR_NAME,BOOKING_BRNCH_ID, ");
                        sb.Append("BILL_DT,IsWalkin");

                        sb.Append(") VALUES ("+ dt.Rows[i]["ID"].ToString() +",'" + dt.Rows[i]["TRANS_NO"].ToString() + "','" + dt.Rows[i]["COMPANYCODE"].ToString() + "',");
                        sb.Append("'" + dt.Rows[i]["PatientID"].ToString() + "','" + dt.Rows[i]["PATIENT_NAME"].ToString().Replace("'", "") + "','" + dt.Rows[i]["DoctorID"].ToString() + "',");
                        sb.Append("'" + dt.Rows[i]["DOCTOR_NAME"].ToString().Replace("'", "") + "','" + dt.Rows[i]["DEPARTMENT_ID"].ToString() + "','" + dt.Rows[i]["DEPARTMENT_NAME"].ToString().Replace("'", "") + "',");
                        sb.Append("'" + dt.Rows[i]["CURRENCY_NAME"].ToString().Replace("'", "") + "','" + dt.Rows[i]["DOCUMENT_ID"].ToString() + "','" + DocumentDate + "',");
                        sb.Append("'" + dt.Rows[i]["BILL_NO"].ToString() + "','" + dt.Rows[i]["BILL_AMOUNT"].ToString() + "','" + dt.Rows[i]["DISC_AMT"].ToString() + "',");
                        sb.Append("'" + dt.Rows[i]["REMARK"].ToString().Replace("'", "") + "','" + dt.Rows[i]["PanelID"].ToString() + "','" + dt.Rows[i]["PANELNAME"].ToString().Replace("'", "") + "',");
                        sb.Append("'" + dt.Rows[i]["GL_VOU_ID"].ToString() + "','" + dt.Rows[i]["IMP_FLG"].ToString() + "','" + dt.Rows[i]["VOU_NO"].ToString() + "',");
                        sb.Append("'" + dt.Rows[i]["REVENUE_ACCOUNT"].ToString() + "','" + dt.Rows[i]["CC_1"].ToString() + "','" + dt.Rows[i]["CC_2"].ToString() + "',");
                        sb.Append("'" + dt.Rows[i]["CC_3"].ToString() + "','" + dt.Rows[i]["CC_4"].ToString() + "','" + dt.Rows[i]["CC_5"].ToString() + "',");
                        sb.Append("'" + dt.Rows[i]["CURR_CONV"].ToString() + "','" + dt.Rows[i]["TRAN_TYPE"].ToString() + "', ");
                        sb.Append("'" + dt.Rows[i]["MODULE"].ToString() + "','" + dt.Rows[i]["IS_BILLED"].ToString() + "', ");
                        sb.Append("'" + dt.Rows[i]["USR_ID"].ToString() + "','" + dt.Rows[i]["USR_NAME"].ToString() + "', ");
                        sb.Append("'" + dt.Rows[i]["BOOKING_BRNCH_ID"].ToString() + "','" + BILL_DT + "','" + dt.Rows[i]["IsWalkin"].ToString() + "' ) ");

                        cmd.CommandText = sb.ToString();
                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE `ess`.`trans$dtl` SET IsSync=1, issyncdatetime=NOW() WHERE ID = " + dt.Rows[i]["ID"].ToString() + "");
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('trans$dtl','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }

                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();
            }

            dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.trans$dtl$pay p WHERE p.IsSync=0 AND p.INSTRUMENT_DATE>='2019-07-01';");
            if (dt.Rows.Count > 0)
            {
                myConnection.Open();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;

                        string INSTRUMENT_DATE = Util.GetDateTime(dt.Rows[i]["INSTRUMENT_DATE"]).ToString("dd-MMM-yyyy");

                        sb.Append("INSERT INTO trans$dtl$pay (ID,TRANS_NO,PAY_MODE,PAY_AMT,CURRENCY_NAME,");
                        sb.Append("BANK_NAME,INSTRUMENT_NO,INSTRUMENT_DATE,TRAN_TYPE,REF_TRAN,CURR_CONV,REF_NO,MODULE,");
                        sb.Append("USR_ID,USR_NAME,RECV_BRCH_ID,PAID_BY,TDS_AMT,TDS_PERCENTAGE,CASHIER_ACCOUNT,PanelID,PANELNAME,BANK_ID,BANK_CHARGES,IS_PA_SETTEL ");

                        sb.Append(") VALUES ("+ dt.Rows[i]["ID"].ToString() +",'" + dt.Rows[i]["TRANS_NO"].ToString() + "','" + dt.Rows[i]["PAY_MODE"].ToString() + "',");
                        sb.Append("'" + dt.Rows[i]["PAY_AMT"].ToString() + "','" + dt.Rows[i]["CURRENCY_NAME"].ToString() + "','" + dt.Rows[i]["BANK_NAME"].ToString().Replace("'", "") + "',");
                        sb.Append("'" + dt.Rows[i]["INSTRUMENT_NO"].ToString() + "','" + INSTRUMENT_DATE + "','" + dt.Rows[i]["TRAN_TYPE"].ToString() + "',");
                        sb.Append("'" + dt.Rows[i]["REF_TRAN"].ToString() + "','" + dt.Rows[i]["CURR_CONV"].ToString() + "','" + dt.Rows[i]["REF_NO"].ToString() + "',");
                        sb.Append("'" + dt.Rows[i]["MODULE"].ToString() + "','" + dt.Rows[i]["USR_ID"].ToString() + "', ");
                        sb.Append("'" + dt.Rows[i]["USR_NAME"].ToString().Replace("'", "") + "',");
                        sb.Append("'" + dt.Rows[i]["RECV_BRCH_ID"].ToString() + "','" + dt.Rows[i]["PAID_BY"].ToString() + "', ");
                        sb.Append(" " + dt.Rows[i]["TDS_AMT"].ToString() + " , " + dt.Rows[i]["TDS_PERCENTAGE"].ToString() + ", " + dt.Rows[i]["CASHIER_ACCOUNT"].ToString() + ", ");
                        sb.Append(" " + dt.Rows[i]["PanelID"].ToString() + ",'" + dt.Rows[i]["PANELNAME"].ToString() + "' ");
                        sb.Append(" , '" + dt.Rows[i]["BANK_ID"].ToString() + "', '" + dt.Rows[i]["BANK_CHARGES"].ToString() + "','" + dt.Rows[i]["IS_PA_SETTEL"].ToString() + "'  ) ");

                        cmd.CommandText = sb.ToString();
                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE `ess`.`trans$dtl$pay` SET IsSync=1, issyncdatetime=NOW() WHERE ID = " + dt.Rows[i]["ID"].ToString() + "");
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        // return sb.ToString();
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('trans$dtl$pay','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }

                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();
            }

            dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.trans$dtl$panel pan WHERE pan.IsSend=0 AND DATE(pan.ALLOCATED_DATE)>='2019-07-01';");

            if (dt.Rows.Count > 0)
            {
                myConnection.Open();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;
                        string ALLOCATED_DATE = Util.GetDateTime(dt.Rows[i]["ALLOCATED_DATE"]).ToString("dd-MMM-yyyy");
                        string APPROVAL_DATE = Util.GetDateTime(dt.Rows[i]["APPROVAL_DATE"]).ToString("dd-MMM-yyyy");
                        sb.Append("INSERT INTO trans$dtl$panel (ID,TRANS_NO,PANEL_NAME,PanelID,ADJUSTED_AMT,ALLOCATED_AMT,");
                        sb.Append("ALLOCATED_DATE,APPROVAL_DATE,USR_NAME,USR_ID,CURRENCY,CURR_CONV) VALUES (");
                        sb.Append("" + dt.Rows[i]["ID"].ToString() + ",'" + dt.Rows[i]["TRANS_NO"] + "','" + dt.Rows[i]["PANEL_NAME"].ToString().Replace("'", "") + "'," + dt.Rows[i]["PanelID"].ToString() + ", ");
                        sb.Append("" + dt.Rows[i]["ADJUSTED_AMT"] + "," + dt.Rows[i]["ALLOCATED_AMT"].ToString() + ",'" + ALLOCATED_DATE + "', ");
                        sb.Append("'" + APPROVAL_DATE + "','" + dt.Rows[i]["USR_NAME"].ToString().Replace("'", "") + "','" + dt.Rows[i]["USR_ID"].ToString() + "','" + dt.Rows[i]["CURRENCY"].ToString() + "','" + dt.Rows[i]["CURR_CONV"].ToString() + "' ");
                        sb.Append(") ");

                        cmd.CommandText = sb.ToString();
                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE `ess`.`trans$dtl$panel` SET IsSend=1, UpdateDate=NOW() WHERE ID = " + dt.Rows[i]["ID"].ToString() + "");
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('trans$dtl$panel','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }
                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();

            }


            dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.dr$cr$notes dr WHERE dr.IsSend=0 AND dr.trans_dt>='2019-07-01';");

            if (dt.Rows.Count > 0)
            {
                myConnection.Open();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;
                        string trans_dt = Util.GetDateTime(dt.Rows[i]["trans_dt"]).ToString("dd-MMM-yyyy");

                        sb.Append("INSERT INTO dr$cr$notes (ID,PatientID,PATIENT_NAME,TR_TYPE,AMOUNT,ITM_NAME,");
                        sb.Append("REVENUE_ACCOUNT,USR_ID,USR_NAME,Document_ID, REMARKS,trans_dt,BRANCH_ID,CURR_ID,CURR_CONV,Module) VALUES (");

                        sb.Append("" + dt.Rows[i]["ID"].ToString() + ",'" + dt.Rows[i]["PatientID"] + "','" + dt.Rows[i]["PATIENT_NAME"].ToString().Replace("'", "") + "','" + dt.Rows[i]["TR_TYPE"].ToString() + "', ");
                        sb.Append("" + dt.Rows[i]["AMOUNT"] + ",'" + dt.Rows[i]["ITM_NAME"].ToString().Replace("'", "") + "', ");
                        sb.Append("" + dt.Rows[i]["REVENUE_ACCOUNT"] + ",'" + dt.Rows[i]["USR_ID"].ToString() + "','" + dt.Rows[i]["USR_NAME"].ToString().Replace("'", "") + "', ");
                        sb.Append("'" + dt.Rows[i]["Document_ID"].ToString() + "','" + dt.Rows[i]["REMARKS"].ToString().Replace("'", "") + "','" + trans_dt + "', ");
                        sb.Append("" + dt.Rows[i]["BRANCH_ID"].ToString() + ",'" + dt.Rows[i]["CURR_ID"].ToString() + "'," + dt.Rows[i]["CURR_CONV"].ToString() + ",'" + dt.Rows[i]["Module"].ToString() + "' ");
                        sb.Append(") ");

                        cmd.CommandText = sb.ToString();
                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE `ess`.`dr$cr$notes` SET IsSend=1, UpdateDate=NOW() WHERE ID = " + dt.Rows[i]["ID"].ToString() + "");
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('dr$cr$notes','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }

                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();
            }

            //BloodBank Transfer
            dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.trans$bb bb WHERE bb.IsSend=0 AND bb.TRANS_DT>='2019-07-01';");
            if (dt.Rows.Count > 0)
            {
                myConnection.Open();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;
                        string TRANS_DT = Util.GetDateTime(dt.Rows[i]["TRANS_DT"]).ToString("dd-MMM-yyyy");

                        sb.Append(" INSERT INTO trans$bb (ID,GRN_NO,INVOICE_NO,SUPPLIER_ACCOUNT,TRANS_DT,ITEM_NAME,BLOOD_GROUP,QTY,RATE,TRAN_TYPE,SOURCE_BRANCH_ID,DEST_BRANCH_ID) VALUES ( ");
                        sb.Append(" "+ dt.Rows[i]["ID"].ToString() +",'" + dt.Rows[i]["GRN_NO"].ToString() + "','" + dt.Rows[i]["INVOICE_NO"].ToString() + "'," + Util.GetInt(dt.Rows[i]["SUPPLIER_ACCOUNT"]) + ",'" + TRANS_DT + "', ");
                        sb.Append(" '" + dt.Rows[i]["ITEM_NAME"].ToString().Replace("'", "") + "','" + dt.Rows[i]["BLOOD_GROUP"].ToString() + "'," + Util.GetDecimal(dt.Rows[i]["QTY"]) + "," + Util.GetDecimal(dt.Rows[i]["RATE"]) + ", ");
                        sb.Append(" '" + dt.Rows[i]["TRAN_TYPE"].ToString() + "'," + Util.GetInt(dt.Rows[i]["SOURCE_BRANCH_ID"]) + " ," + Util.GetInt(dt.Rows[i]["DEST_BRANCH_ID"]) + " )");

                        cmd.CommandText = sb.ToString();
                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE ess.trans$bb SET IsSend=1, UpdateDateTime=NOW() WHERE ID = " + dt.Rows[i]["ID"].ToString() + "");
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('trans$bb','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }

                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();
            }
            //Bill Generate Emergency & IPD
            /*dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.trans$billgenerate WHERE IsSync=0");
            if (dt.Rows.Count > 0)
            {
                myConnection.Open();
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        
                        cmd = new OracleCommand();
                        cmd.Connection = myConnection;
                        sb = new StringBuilder("INSERT INTO trans$billgenerate (ID,TRANS_NO,BILL_NO,BILL_DT) VALUES ("+ dt.Rows[i]["ID"].ToString() +",'" + dt.Rows[i]["TRANS_NO"].ToString() + "','" + dt.Rows[i]["BILL_NO"].ToString() + "','" + Util.GetDateTime(dt.Rows[i]["BILL_DT"]).ToString("dd-MMM-yyyy") + "')");
                        cmd.CommandText = sb.ToString();

                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE ess.trans$billgenerate SET IsSync=1, issyncdatetime=NOW() WHERE ID = " + dt.Rows[i]["Id"].ToString() + "");
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('trans$billgenerate','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }
                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();
            }*/
            //Insert Doctor Share
           /* dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.doc$SHARE ds WHERE ds.IsSync=0 AND ds.TRANS_DT>='2019-07-01';");
            if (dt.Rows.Count > 0)
            {
                myConnection.Open();
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;
                        sb.Append(" INSERT INTO doc$share(ID,TRANS_NO,TRANS_DT,REF_NO,REF_DATE,DOC_AMOUNT,REVENUE_ACCOUNT,NARRATION,BRANCH_ID,CURRENCY,CURR_CONV,DoctorID,DOCTOR_NAME,MODULE,TRAN_TYPE,HOSP_AMT,IS_PROC,IS_PKG) VALUES ( ");
                        sb.Append(" " + dt.Rows[i]["ID"].ToString() + ",'" + dt.Rows[i]["TRANS_NO"].ToString() + "','" + Util.GetDateTime(dt.Rows[i]["TRANS_DT"]).ToString("dd-MMM-yyyy") + "',");
                        sb.Append(" '" + dt.Rows[i]["REF_NO"].ToString() + "','" + Util.GetDateTime(dt.Rows[i]["REF_DATE"]).ToString("dd-MMM-yyyy") + "', ");
                        sb.Append(" " + dt.Rows[i]["DOC_AMOUNT"].ToString() + ",'" + dt.Rows[i]["REVENUE_ACCOUNT"].ToString() + "',");
                        sb.Append(" '" + dt.Rows[i]["NARRATION"].ToString() + "','" + dt.Rows[i]["BRANCH_ID"].ToString() + "', ");
                        sb.Append(" '" + dt.Rows[i]["CURRENCY"].ToString() + "','" + dt.Rows[i]["CURR_CONV"].ToString() + "' ,");
                        sb.Append(" '" + dt.Rows[i]["DoctorID"].ToString() + "' ,'" + dt.Rows[i]["DOCTOR_NAME"].ToString() + "', ");
                        sb.Append(" '" + dt.Rows[i]["MODULE"].ToString() + "' ,'" + dt.Rows[i]["TRAN_TYPE"].ToString() + "'," + dt.Rows[i]["HOSP_AMT"].ToString() + ", ");
                        sb.Append(" '" + dt.Rows[i]["IS_PROC"].ToString() + "' ,'" + dt.Rows[i]["IS_PKG"].ToString() + "' )");
                        cmd.CommandText = sb.ToString();
                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE ess.doc$share SET IsSync=1, issyncdatetime=NOW() WHERE ID = " + dt.Rows[i]["Id"].ToString() + "");
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('doc$share','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }
                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();
            }*/

            //Insert PO Advance
            /*dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.po$advance WHERE IsSync=0");
            if (dt.Rows.Count > 0)
            {
                myConnection.Open();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;

                        sb.Append("INSERT INTO po$advance (ID,EO_ID, AMOUNT, PO_NUMBER, PO_DT, REMARKS, CURRENCY, CURR_CONV,BRANCH_ID ) VALUES (" + dt.Rows[i]["ID"].ToString() + "," + dt.Rows[i]["EO_ID"].ToString() + "," + dt.Rows[i]["AMOUNT"].ToString() + ",'" + dt.Rows[i]["PO_NUMBER"].ToString() + "', '" + Util.GetDateTime(dt.Rows[i]["PO_DT"]).ToString("dd-MMM-yyyy") + "', '" + dt.Rows[i]["REMARKS"].ToString() + "', '" + dt.Rows[i]["CURRENCY"].ToString() + "', " + dt.Rows[i]["CURR_CONV"].ToString() + ", " + dt.Rows[i]["BRANCH_ID"].ToString() + " )");


                        cmd.CommandText = sb.ToString();

                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE ess.po$advance SET IsSync=1, issyncdatetime=NOW() WHERE ID = " + dt.Rows[i]["Id"].ToString() + "");
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('po$advance','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }

                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();
            }*/

            //Insert Inventory Transaction
           /* dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.trans$grn grn WHERE grn.IsSync=0 AND grn.TRANS_DATE>='2019-07-01' AND grn.TOT_PUR_PRICE<>0 AND grn.TRANS_TYPE IN (17,18);");
            if (dt.Rows.Count > 0)
            {
                myConnection.Open();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {

                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;

                        sb.Append(" INSERT INTO TRANS$GRN(ID,PO_NO,GRN_NO,INVOICE_NO,SUPPLIER_NAME,TRANS_DATE,ITEM_NAME,ITEM_ID,ITEM_CLASS,ITM_SR_NO,TRANS_TYPE_FA,QTY, ");
                        sb.Append(" PER_UNIT_PUR_PRICE,TOT_PUR_PRICE,IMP_FLG,PB_VOU_ID,CURRENCY,CURR_CONV,BRANCH_ID,REF_DATE,TAX_AMT,TAX_PER,INV_FLG,TRANS_TYPE,REF_PO_NUMBER,DEST_BRANCH_ID) VALUES ( ");
                        sb.Append(" " + dt.Rows[i]["ID"].ToString() + ",'" + dt.Rows[i]["PO_NO"].ToString() + "','" + dt.Rows[i]["GRN_NO"].ToString() + "','" + dt.Rows[i]["INVOICE_NO"].ToString() + "','" + dt.Rows[i]["SUPPLIER_NAME"].ToString().Replace("'", "") + "','" + Util.GetDateTime(dt.Rows[i]["TRANS_DATE"]).ToString("dd-MMM-yyyy") + "', ");
                        sb.Append(" '" + dt.Rows[i]["ITEM_NAME"].ToString().Replace("'", "") + "','" + dt.Rows[i]["ITEM_ID"].ToString() + "','" + dt.Rows[i]["ITEM_CLASS"].ToString() + "','" + dt.Rows[i]["ITM_SR_NO"].ToString() + "', ");
                        sb.Append(" '" + dt.Rows[i]["TRANS_TYPE_FA"].ToString() + "','" + dt.Rows[i]["QTY"].ToString() + "' ,'" + dt.Rows[i]["PER_UNIT_PUR_PRICE"].ToString() + "' , ");
                        sb.Append(" '" + dt.Rows[i]["TOT_PUR_PRICE"].ToString() + "','" + dt.Rows[i]["IMP_FLG"].ToString() + "' ,'" + dt.Rows[i]["PB_VOU_ID"].ToString() + "', ");
                        sb.Append(" '" + dt.Rows[i]["CURRENCY"].ToString() + "','" + dt.Rows[i]["CURR_CONV"].ToString() + "' ,'" + dt.Rows[i]["BRANCH_ID"].ToString() + "' , ");
                        sb.Append(" '" + Util.GetDateTime(dt.Rows[i]["REF_DATE"]).ToString("dd-MMM-yyyy") + "','" + dt.Rows[i]["TAX_AMT"].ToString() + "' ,");
                        sb.Append(" '" + dt.Rows[i]["TAX_PER"].ToString() + "','" + dt.Rows[i]["INV_FLG"].ToString() + "'," + dt.Rows[i]["TRANS_TYPE"].ToString() + ",'" + dt.Rows[i]["REF_PO_NUMBER"].ToString() + "','" + dt.Rows[i]["DEST_BRANCH_ID"].ToString() + "') ");
                        cmd.CommandText = sb.ToString();
                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE ess.`TRANS$GRN` SET IsSync=1, issyncdatetime=NOW() WHERE ID = " + dt.Rows[i]["Id"].ToString() + "");
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('TRANS$GRN','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }

                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();
            }*/

            //Insert Doctor Allocation
            /*dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.doc$alloc al WHERE al.IsSync=0 AND al.REF_DATE>='2019-06-01';");
            if (dt.Rows.Count > 0)
            {
                myConnection.Open();
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {

                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;
                        sb.Append(" INSERT INTO doc$alloc (ID,TRANS_NO, DOCTOR_NAME, DoctorID, REVENUE_ACCOUNT, ALLOC_AMOUNT, CURRENCY, CURR_CONV, MODULE, BRANCH_ID, NARRATION, REF_NO, REF_DATE,BANK_ID,BANK_CHARGES ) ");
                        sb.Append(" VALUES (" + dt.Rows[i]["ID"].ToString() + ",'" + dt.Rows[i]["TRANS_NO"].ToString() + "', '" + dt.Rows[i]["DOCTOR_NAME"].ToString().Replace("'", "") + "','" + dt.Rows[i]["DoctorID"].ToString() + "', '" + dt.Rows[i]["REVENUE_ACCOUNT"].ToString() + "', '" + dt.Rows[i]["ALLOC_AMOUNT"].ToString() + "', '" + dt.Rows[i]["CURRENCY"].ToString() + "', '" + dt.Rows[i]["CURR_CONV"].ToString() + "', '" + dt.Rows[i]["MODULE"].ToString() + "', '" + dt.Rows[i]["BRANCH_ID"].ToString() + "', '" + dt.Rows[i]["NARRATION"].ToString().Replace("'", "") + "', '" + dt.Rows[i]["REF_NO"].ToString() + "', '" + Util.GetDateTime(dt.Rows[i]["REF_DATE"]).ToString("dd-MMM-yyyy") + "' , '" + dt.Rows[i]["BANK_ID"].ToString() + "', '" + dt.Rows[i]["BANK_CHARGES"].ToString() + "' )");
                        cmd.CommandText = sb.ToString();

                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE ess.`DOC$ALLOC` SET IsSync=1, issyncdatetime=NOW() WHERE ID = " + dt.Rows[i]["Id"].ToString() + "");

                        if (myConnection.State == ConnectionState.Open)
                            myConnection.Close();
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('doc$alloc','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }


            }


            dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT * FROM ess.trans$WRITE$off WHERE IsSync=0");
            if (dt.Rows.Count > 0)
            {
                myConnection.Open();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        sb.Clear();
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = myConnection;

                        sb.Append("INSERT INTO trans$WRITE$off (ID,TRANS_NO,PatientID,PATIENT_NAME,WRITE_OFF_AMT,ITEM_NAME,USR_ID,USR_NAME,BRANCH_ID,CURR_ID,CURR_CONV,TRANS_DT,DoctorID,PanelID,WRITE_OFF_DOCTOR,WRITE_OFF_PANEL)");
                        sb.Append("VALUES (" + dt.Rows[i]["ID"].ToString() + ",'" + dt.Rows[i]["TRANS_NO"].ToString() + "', '" + dt.Rows[i]["PatientID"].ToString() + "', '" + dt.Rows[i]["PATIENT_NAME"].ToString().Replace("'", "") + "','" + dt.Rows[i]["WRITE_OFF_AMT"].ToString() + "', '" + dt.Rows[i]["ITEM_NAME"].ToString().Replace("'", "") + "', '" + dt.Rows[i]["USR_ID"].ToString() + "', '" + dt.Rows[i]["USR_NAME"].ToString().Replace("'", "") + "', '" + dt.Rows[i]["BRANCH_ID"].ToString() + "', '" + dt.Rows[i]["CURR_ID"].ToString() + "', '" + dt.Rows[i]["CURR_CONV"].ToString() + "','" + Util.GetDateTime(dt.Rows[i]["TRANS_DT"]).ToString("dd-MMM-yyyy") + "', '" + dt.Rows[i]["DoctorID"].ToString() + "', '" + dt.Rows[i]["PanelID"].ToString() + "', '" + dt.Rows[i]["WRITE_OFF_DOCTOR"].ToString() + "', '" + dt.Rows[i]["WRITE_OFF_PANEL"].ToString() + "' )");


                        cmd.CommandText = sb.ToString();

                        int chk = cmd.ExecuteNonQuery();
                        if (chk == 1)
                            StockReports.ExecuteDML("UPDATE ess.trans$WRITE$off SET IsSync=1, issyncdatetime=NOW() WHERE ID = " + dt.Rows[i]["Id"].ToString() + "");

                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('trans$WRITE$off','" + ex.Message.Replace("'", "~") + "','" + sb.ToString().Replace("'", "~") + "','" + dt.Rows[i]["ID"].ToString() + "')");
                    }
                }

                if (myConnection.State == ConnectionState.Open)
                    myConnection.Close();
            }*/


            dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT cc.ID,cm.CountryID,cm.Currency,cm.Notation,'' BaseCurrency,'' BaseNotation,ROUND((1/cc.RATE),5) Selling_Base,cc.RATE Selling_Specific,ROUND((1/cc.RATE),5) Buying_Base,cc.RATE Buying_Specific  FROM ess.curr$CONV$MASTER cc INNER JOIN country_master cm ON cm.Notation=cc.CURR_SP WHERE cc.IsSync=0");

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                try
                {
                    Converson_Master ObjConverson = new Converson_Master();
                    ObjConverson.Date = System.DateTime.Now;
                    ObjConverson.B_CountryID = Util.GetInt(Resources.Resource.BaseCurrencyID);
                    ObjConverson.B_Currency = Resources.Resource.BaseCurrencyNotation;
                    ObjConverson.B_Notation = Resources.Resource.BaseCurrencyNotation;
                    ObjConverson.S_CountryID = Util.GetInt(dt.Rows[i]["CountryID"]);
                    ObjConverson.S_Currency = Util.GetString(dt.Rows[i]["Currency"]);
                    ObjConverson.S_Notation = Util.GetString(dt.Rows[i]["Notation"]);
                    ObjConverson.Selling_Base = Util.GetDecimal(dt.Rows[i]["Selling_Base"]);
                    ObjConverson.Selling_Specific = Util.GetDecimal(dt.Rows[i]["Selling_Specific"]);
                    ObjConverson.Buying_Base = Util.GetDecimal(dt.Rows[i]["Buying_Base"]);
                    ObjConverson.Buying_Specific = Util.GetDecimal(dt.Rows[i]["Buying_Specific"]);
                    ObjConverson.UserID = string.Empty;
                    ObjConverson.Round = Util.GetDecimal(0);
                    ObjConverson.MinCurrency = Util.GetDecimal(0);
                    string EntryID = ObjConverson.Insert();

                    StockReports.ExecuteDML("UPDATE ess.curr$CONV$MASTER cm SET  cm.IsSync=1 , cm.SyncDateTime=NOW() WHERE cm.ID=" + dt.Rows[i]["ID"].ToString());
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('curr$CONV$MASTER','" + ex.Message.Replace("'","~") + "','','" + dt.Rows[i]["ID"].ToString() + "')");
                }
            }


            return "Successfully Data Transfered.";

        }
        catch (OracleException OraEx)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(OraEx);
            StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('Connection String','" + OraEx.Message.Replace("'", "~") + "','" + OraEx.Message.Replace("'", "~") + "','0')");
            return OraEx.Message;
            throw new Exception("OraEx " + OraEx.Message);
        }
        catch (System.Exception SysEx)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(SysEx);
            StockReports.ExecuteDML("INSERT INTO ess_financeerrorlog (TableName,ExceptiionType,ErrorData,TableUniqueID) VALUES ('Connection String','" + SysEx.Message.Replace("'", "~") + "','" + SysEx.Message.Replace("'", "~") + "','0')");
            return SysEx.Message;
            throw new Exception("SysEX " + SysEx.Message);
        }
        finally
        {
            if (myConnection.State == ConnectionState.Open)
                myConnection.Close();

            myConnection.Dispose();
        }
    }
}