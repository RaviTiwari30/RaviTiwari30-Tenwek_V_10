using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;
using Oracle.ManagedDataAccess.Client;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Web.Services;
using System.IO;
using System.Collections.Generic;

[Serializable]
public partial class Design_CommonReports_TransferReportHisVsFinance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ceFromDate.EndDate = ceToDate.EndDate = DateTime.Now;
	    if(Session["ID"].ToString() != "EMP001")
               ceFromDate.StartDate = ceToDate.StartDate = Util.GetDateTime("2019-07-01");
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }

    [WebMethod]
    public static string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string GetExcelReports(int centreID, string fromDate, string toDate, int type, string ReportName, string reporttype)
    {
        string sql = "CALL sp_HISvsSteging(" + centreID + ",'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'," + type + ") ";
        DataTable dtHISVsFianance = StockReports.GetDataTable(sql);

        string myConnString = System.Configuration.ConfigurationManager.AppSettings["OracleConnectionFinance"];
        OracleConnection myConnection = new OracleConnection(myConnString);
        StringBuilder sb = new StringBuilder();

        try
        {
            OracleCommand cmd = new OracleCommand();
            cmd.Connection = myConnection;

            if (type == 1) // Revenue
            {
                sb.Append("SELECT t.REVENUE_ACCOUNT,SUM(CR_Amount-DR_Amount)Fin_Staging FROM ( ");
                sb.Append("     SELECT l.REVENUE_ACCOUNT,SUM(ROUND((CASE WHEN l.BILL_AMOUNT>0 THEN ABS(l.BILL_AMOUNT) ELSE 0 END),2))CR_Amount, ");
                sb.Append("     SUM(ROUND((CASE WHEN l.BILL_AMOUNT<0 THEN ABS(l.BILL_AMOUNT) ELSE 0 END),2))DR_Amount ");
                sb.Append("     FROM trans$dtl l ");
                sb.Append("     WHERE l.TRAN_TYPE='R' ");
                sb.Append("     AND l.DOCUMENT_DATE between TO_DATE('" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','yyyy-MM-DD')  AND TO_DATE('" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','yyyy-MM-DD') ");
                sb.Append("	    AND l.BOOKING_BRNCH_ID= '0" + centreID + "' ");
                sb.Append("	    GROUP BY l.REVENUE_ACCOUNT ");
                sb.Append("     UNION ALL ");
                sb.Append("     SELECT l.REVENUE_ACCOUNT,SUM(ROUND((CASE WHEN l.TR_TYPE='D' THEN l.AMOUNT ELSE 0 END),2))CR_Amount, ");
                sb.Append("     SUM(ROUND((CASE WHEN l.TR_TYPE='C' THEN l.AMOUNT ELSE 0 END),2))DR_Amount FROM dr$cr$notes l ");
                sb.Append("     WHERE ");
                sb.Append(" 	l.trans_dt between TO_DATE('" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','yyyy-MM-DD')  AND TO_DATE('" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','yyyy-MM-DD') ");
                sb.Append("	    AND l.BRANCH_ID= '0" + centreID + "' ");
                sb.Append("	    GROUP BY l.REVENUE_ACCOUNT ");
                sb.Append(")t GROUP BY t.REVENUE_ACCOUNT");

                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                //File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["REVENUE_ACCOUNT"].ToString() == dr["REVENUE_ACCOUNT"].ToString())
                            {
                                row["Fin_Staging"] = dr["Fin_Staging"].ToString();
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"]));
                            }
                        }
                    }
                }
            }
            else if (type == 2)
            {
                sb.Append("SELECT SUM(p.PAY_AMT)Fin_Staging,p.PAY_MODE,p.CURRENCY_NAME ");
                sb.Append("FROM trans$dtl$pay p  ");
                sb.Append("WHERE p.INSTRUMENT_DATE between TO_DATE('" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','yyyy-MM-DD')  AND TO_DATE('" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','yyyy-MM-DD') ");
                sb.Append("AND p.RECV_BRCH_ID = '0" + centreID + "' ");
                sb.Append("GROUP BY p.PAY_MODE,p.CURRENCY_NAME");

                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                //File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["PAY_MODE"].ToString() == dr["PAY_MODE"].ToString() && row["CURRENCY_NAME"].ToString() == dr["CURRENCY_NAME"].ToString())
                            {
                                row["Fin_Staging"] = dr["Fin_Staging"].ToString();
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"]));
                            }
                        }
                    }
                }
            }

            else if (type == 3)
            {
                sb.Append("SELECT 'Inventory Purchase_Returns' AS TransactionType,SUPPLIER_NAME,SUM(Fin_Staging)Fin_Staging FROM ( ");
                sb.Append("    SELECT 'Store Purchase' AS TransactionType,SUPPLIER_NAME, ");
	            //sb.Append("    ROUND(SUM(t.TOT_PUR_PRICE*t.CURR_CONV),2) AS Fin_Staging  ");
		sb.Append("    ROUND(SUM(CASE WHEN t.INV_FLG NOT IN('Y') THEN (t.TOT_PUR_PRICE*t.CURR_CONV) ELSE 0 END),2) AS Fin_Staging  ");
                sb.Append("    FROM appua.TRANS$GRN t WHERE t.TRANS_DATE between TO_DATE('" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','yyyy-MM-DD')  AND TO_DATE('" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','yyyy-MM-DD')  ");
                sb.Append("    AND t.BRANCH_ID= '0" + centreID + "' AND t.TRANS_TYPE=18 GROUP BY t.SUPPLIER_NAME");
	            sb.Append("    UNION ALL ");
                sb.Append("    SELECT 'Supplier Return' AS TransactionType,SUPPLIER_NAME, ");
	            sb.Append("    ROUND(SUM(t.TOT_PUR_PRICE*t.CURR_CONV),2) AS Fin_Staging  ");
                sb.Append("    FROM appua.TRANS$GRN t WHERE t.TRANS_DATE between TO_DATE('" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','yyyy-MM-DD')  AND TO_DATE('" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','yyyy-MM-DD')  ");
                sb.Append("    AND t.BRANCH_ID= '0" + centreID + "' AND t.TRANS_TYPE=7  GROUP BY t.SUPPLIER_NAME ");
	            sb.Append("    UNION ALL ");
                sb.Append("    SELECT 'Blood Bank Purchase'  AS TransactionType,'NATIONAL BLOOD TRANSFUSION SERVICE' SUPPLIER_NAME, ROUND(SUM(b.QTY*b.RATE),2) AS Fin_Staging ");
                sb.Append("    FROM appua.trans$bb b  ");
                sb.Append("    WHERE b.SOURCE_BRANCH_ID= '0" + centreID + "' AND TRUNC(b.TRANS_DT) between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append(")t GROUP BY t.SUPPLIER_NAME ");
                
                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["SUPPLIER_NAME"].ToString() == dr["SUPPLIER_NAME"].ToString())
                            {
                                row["Fin_Staging"] = dr["Fin_Staging"].ToString();
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"]));
                            }
                        }
                    }
                }
            }

            else if (type == 4)
            {
                sb.Append("    SELECT P.PanelID,ROUND(SUM(allocated_amt*DECODE(curr_conv,0,1,curr_conv)),2)Fin_Staging ");
                sb.Append("    FROM appua.trans$dtl$panel p ");
                sb.Append("    WHERE TRUNC(p.Allocated_date) between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    AND p.RECV_BRCH_ID='" + centreID + "' ");
                sb.Append("    GROUP BY p.PanelID ");



                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                //File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["PanelID"].ToString() == dr["PanelID"].ToString())
                            {
                                row["Fin_Staging"] = dr["Fin_Staging"].ToString();
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"]));
                            }
                        }
                    }
                }
            }
            else if (type == 5)
            {
                sb.Append(" SELECT DoctorID,(doc_share_amt+dr_cr_amt) AS Fin_Staging FROM ( ");
                sb.Append("     SELECT a.DoctorID, nvl(b.amt,0) dr_cr_amt, nvl(c.amt,0) doc_share_amt ");
                sb.Append("     FROM ( ");
                sb.Append("         SELECT DISTINCT DoctorID FROM appua.doc$SHARE ");
                sb.Append("         UNION ");
                sb.Append("         SELECT DISTINCT DoctorID FROM appua.dr$cr$notes ");
                sb.Append("     ) a ");
                sb.Append("     LEFT OUTER JOIN ( ");
                sb.Append(" 	    SELECT DoctorID, sum(amt)amt  from ( ");
                sb.Append(" 	        SELECT dcr.DoctorID, DECODE(tr_type, 'D',amount*curr_conv,DECODE(aa.TRAN_TYPE,'C',0,-amount*curr_conv)) amt  ");
                sb.Append(" 	        FROM appua.dr$cr$notes dcr ");
                sb.Append("             LEFT OUTER JOIN ( ");
                sb.Append(" 		        SELECT DoctorID as DOCTORID,TRAN_TYPE FROM appua.doc$SHARE WHERE TRUNC(trans_dt) BETWEEN '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append(" 		        AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' AND BRANCH_ID='0" + centreID + "' GROUP BY DoctorID,TRAN_TYPE ");
                sb.Append(" 	        )aa ON (dcr.DoctorID=aa.DOCTORID) ");

                sb.Append("             WHERE config_id IN ('1', '5') AND  TRUNC(trans_dt) BETWEEN '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "'  ");
                sb.Append(" 	        AND branch_id= '0" + centreID + "' )k GROUP BY DoctorID ");
                sb.Append("         ) b ON (a.DoctorID = b.DoctorID) ");
                sb.Append("         LEFT OUTER JOIN ( ");
                sb.Append(" 	        SELECT DoctorID, SUM(doc_amount) amt FROM appua.doc$SHARE WHERE tran_type IN('D','C') AND  TRUNC(ref_date)  ");
                sb.Append(" 	        BETWEEN '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' AND branch_id= '0" + centreID + "' GROUP BY DoctorID ");
                sb.Append("         ) c ON (a.DoctorID = c.DoctorID) ");
                sb.Append(" ) t ");


                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                //File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["DoctorID"].ToString() == dr["DoctorID"].ToString())
                            {
                                row["Fin_Staging"] = dr["Fin_Staging"].ToString();
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"]));
                            }
                        }
                    }
                }


                // For 4th Stage Finance Data to be fetched from Main Finance in Oracle

		sb = new StringBuilder();
                sb.Append(" SELECT a.eo_nm doc_name,a.eo_leg_code, SUM(DECODE(b.gl_amt_typ,'DR',(b.gl_amt_bs*-1),b.gl_amt_bs))Fin_Main, b.vouch_no, ");
                sb.Append(" c.glbl_doc_type_nm, b.gl_vou_dt, b.gl_amt_bs, b.gl_amt_typ, b.gl_type_id, B.RECORD_TYPE, ");
                sb.Append(" b.gl_ext_doc_no, b.gl_narr,b.gl_vou_id ");
                sb.Append(" FROM ( ");
                sb.Append("     SELECT a.eo_nm ,a.eo_leg_code,c.coa_id payable_acc, nvl(d.coa_id, 0) control_acc ");
                sb.Append("     FROM app.app$eo a ");
                sb.Append("     INNER JOIN fin.fin$acc$na b ON (a.eo_type = b.acc_type AND a.eo_id = b.acc_type_id) ");
                sb.Append("     INNER JOIN fin.fin$coa c ON (b.acc_id = c.coa_acc_id) ");
                sb.Append("     LEFT OUTER JOIN fin.fin$coa d ON (a.eo_leg_code =d.coa_alias) ");
                sb.Append("     WHERE a.eo_type = 80 AND a.eo_leg_code = nvl('LSHHI2', a.eo_leg_code) ");
                sb.Append(" ) a,( ");
                sb.Append("     SELECT b.doc_txn_id_disp vouch_no, a.gl_vou_dt, a.gl_coa_id, a.gl_amt_bs, a.gl_amt_typ, a.gl_type_id, 'LIABILITY ACCOUNT' RECORD_TYPE, ");
                sb.Append("     a.gl_ext_doc_no, a.gl_narr,a.gl_vou_id ");
                sb.Append("     FROM fin.gl_lines a ");
                sb.Append("     INNER JOIN app.app$doc$txn b ON (a.gl_vou_id = b.doc_txn_id) ");
                sb.Append("     WHERE a.usr_id_create = 3 ");
                sb.Append("     AND trunc(a.gl_vou_dt) >= to_date('" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "', 'YYYY-mm-dd') ");
                sb.Append("     AND trunc(a.gl_vou_dt) <= to_date('" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "', 'YYYY-mm-dd') ");
                sb.Append("     AND a.gl_org_id = '0" + centreID + "' ");
                sb.Append("     AND a.gl_ext_doc_no = nvl('LSHHI2', a.gl_ext_doc_no) ");
                sb.Append("     AND a.gl_narr NOT LIKE '%BEING VOUCHER PASSED AGAINST DOCTOR ALLOCATION%' ");
                sb.Append("     UNION ALL ");
                sb.Append("     SELECT b.doc_txn_id_disp vouch_no, a.gl_vou_dt, a.gl_coa_id, a.gl_amt_bs, a.gl_amt_typ, a.gl_type_id, 'CONTROL ACCOUNT' RECORD_TYPE, ");
                sb.Append("     a.gl_ext_doc_no, a.gl_narr,a.gl_vou_id ");
                sb.Append("     FROM fin.gl_lines a ");
                sb.Append("     INNER JOIN app.app$doc$txn b ON (a.gl_vou_id = b.doc_txn_id) ");
                sb.Append("     WHERE a.usr_id_create = 3 ");
                sb.Append("     AND trunc(a.gl_vou_dt) >= to_date('" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "', 'YYYY-mm-dd') ");
                sb.Append("     AND trunc(a.gl_vou_dt) <= to_date('" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "', 'YYYY-mm-dd') ");
                sb.Append("     AND a.gl_org_id = '0" + centreID + "' ");
                sb.Append("     AND a.gl_ext_doc_no = nvl('LSHHI2', a.gl_ext_doc_no) ");
                sb.Append("     AND a.gl_narr NOT LIKE '%BEING VOUCHER PASSED AGAINST DOCTOR ALLOCATION%' ");
                sb.Append(" ) b, app.app$glbl$doc$TYPE c ");
                sb.Append(" WHERE b.gl_type_id = c.glbl_doc_type_id ");
                sb.Append(" AND c.glbl_doc_id = 56 ");
                sb.Append(" AND DECODE(b.record_type, 'LIABILITY ACCOUNT', a.payable_acc, a.control_acc) = b.gl_coa_id ");
                sb.Append(" GROUP BY a.eo_leg_code ");

                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                File.WriteAllText("f:/abc.txt", sb.ToString());

                //myConnection.Open();
                OracleDataReader dress = cmd.ExecuteReader();
                if (dress.HasRows)
                {
                    while (dress.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["DoctorID"].ToString() == dress["eo_leg_code"].ToString())
                            {
                                row["Fin_Main"] = dress["Fin_Main"].ToString();
                                row["Diff_FinStaging_vs_FinMain"] = Util.GetString(Util.GetDecimal(row["His_Main"]) - Util.GetDecimal(dress["Fin_Main"]));
                            }
                        }
                    }
                }
            }
            else if (type == 6)
            {


                sb.Append(" SELECT ds.DoctorID,ROUND(SUM(ds.ALLOC_AMOUNT),2) AS Fin_Staging ");
                sb.Append(" FROM appua.doc$alloc ds WHERE ");
                sb.Append("   TRUNC(ds.REF_DATE) between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append(" AND ds.BRANCH_ID='0" + centreID + "' ");
                sb.Append(" GROUP BY ds.DoctorID ");
                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                //File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["DoctorID"].ToString() == dr["DoctorID"].ToString())
                            {
                                row["Fin_Staging"] = dr["Fin_Staging"].ToString();
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"]));
                            }
                        }
                    }
                }
            }
            else if (type == 7)
            {
                sb.Append(" SELECT   ");
                sb.Append(" e.ACC_NM AS Fin_Staging_PanelName ,e.ACC_CODE AS Fin_Staging_PanelID,( CASE WHEN e.ACC_CODE IS NULL THEN 'No' ELSE 'Yes' END )  AvailableInFin_Staging,  ");
                sb.Append(" e.INSERT_TYPE AS Fin_Staging_INSERT_TYPE  ");
                sb.Append(" FROM appua.ENTITY$MASTER e   ");
                sb.Append(" WHERE e.ACC_TYPE=10  ORDER BY e.ID  ");

                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            //if (row["Finance_PanelID"].ToString() == dr["Fin_Staging_PanelID"].ToString() && row["HIS_Staging_INSERT_TYPE"].ToString() == dr["Fin_Staging_INSERT_TYPE"].ToString())
                            if (row["Finance_PanelID"].ToString() == dr["Fin_Staging_PanelID"].ToString())
                            {
                                row["Fin_Staging_PanelName"] = dr["Fin_Staging_PanelName"].ToString();
                                row["Fin_Staging_PanelID"] = dr["Fin_Staging_PanelID"].ToString();
                                row["AvailableInFin_Staging"] = dr["AvailableInFin_Staging"].ToString();
                                //row["Fin_Staging_INSERT_TYPE"] = dr["Fin_Staging_INSERT_TYPE"].ToString();
                            }
                        }
                    }
                }
            }
            else if (type == 8)
            {


                sb.Append(" SELECT  ");
                sb.Append(" e.ACC_NM AS Fin_Staging_DoctorName ,e.ACC_CODE AS Fin_Staging_DoctorID,( CASE WHEN e.ACC_CODE IS NULL THEN 'No' ELSE 'Yes' END )  AvailableInFin_Staging, ");
                sb.Append(" e.INSERT_TYPE AS Fin_Staging_INSERT_TYPE ");
                sb.Append(" FROM appua.ENTITY$MASTER e  ");
                sb.Append(" WHERE e.ACC_TYPE=80  ORDER BY e.ID ");
                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["Finance_DoctorID"].ToString() == dr["Fin_Staging_DoctorID"].ToString() && row["HIS_Staging_INSERT_TYPE"].ToString() == dr["Fin_Staging_INSERT_TYPE"].ToString())
                            {
                                row["Fin_Staging_DoctorName"] = dr["Fin_Staging_DoctorName"].ToString();
                                row["Fin_Staging_DoctorID"] = dr["Fin_Staging_DoctorID"].ToString();
                                row["AvailableInFin_Staging"] = dr["AvailableInFin_Staging"].ToString();
                                row["Fin_Staging_INSERT_TYPE"] = dr["Fin_Staging_INSERT_TYPE"].ToString();
                            }
                        }
                    }
                }
            }
 	else if (type == 9)
            {

                // Creating New Row in dtHISVsFianance for those cases where vourchers from Finance not exist in dtHISVsFianance table 
                // because here source is Finance from where unallocated data comes from.

                DataRow drNew = dtHISVsFianance.NewRow();

		        // Settled Amt
                sb.Append("SELECT SUM(a.gl_amt_bs)FinMain_Settled ,b.INSTRUMENT_NO FROM fin.gl_lines a,TRANS$DTL$PAY b ");
                sb.Append("WHERE  a.gl_coa_id = 1711 ");
                sb.Append("AND a.gl_vou_id =b.GL_VOU_ID ");
                sb.Append("AND b.PAID_BY='PA' ");
                sb.Append("AND b.IS_PA_SETTEL='Y' ");
                sb.Append("AND a.USR_ID_CREATE='3' ");
                sb.Append("AND TO_DATE(INSTRUMENT_DATE,'DD-MM-RRRR') BETWEEN TO_DATE('01-Apr-2019','DD-MM-RRRR') AND TO_DATE('" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "','DD-MM-RRRR') ");
                sb.Append("AND a.gl_org_id = '0" + centreID + "' ");
                sb.Append("GROUP BY INSTRUMENT_NO ");

                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        DataRow[] drRow = dtHISVsFianance.Select("GL_INSTRMNT_NO='" + dr["INSTRUMENT_NO"].ToString().Replace(",", "") + "'");


                        if (drRow.Length > 0)
                        {
                            drRow[0]["FinMain_Settled"] = dr["FinMain_Settled"].ToString();
                            drRow[0]["Diff_HIS_Vs_FinMain_Settled"] = Util.GetString(Util.GetDecimal(drRow[0]["HIS_Settled"]) - Util.GetDecimal(dr["FinMain_Settled"]));
                            dtHISVsFianance.AcceptChanges();
                        }
                        else
                        {
                            drNew = dtHISVsFianance.NewRow();
                            drNew["GL_INSTRMNT_NO"] = dr["INSTRUMENT_NO"].ToString().Replace(",", "");
                            drNew["FinMain_Settled"] = dr["FinMain_Settled"].ToString();

                            drNew["Diff_HIS_Vs_FinMain_Settled"] = 0 - Util.GetDecimal(dr["FinMain_Settled"]);
                            dtHISVsFianance.Rows.Add(drNew);
                            dtHISVsFianance.AcceptChanges();
                        }

                        //foreach (DataRow row in dtHISVsFianance.Rows)
                        //{
                        //    if (row["GL_INSTRMNT_NO"].ToString() == dr["INSTRUMENT_NO"].ToString())
                        //    {
                        //        row["FinMain_Settled"] = dr["FinMain_Settled"].ToString();
                        //        row["Diff_HIS_Vs_FinMain_Settled"] = Util.GetString(Util.GetDecimal(row["HIS_Settled"]) - Util.GetDecimal(dr["FinMain_Settled"]));
                        //    }                            
                        //}

                        
                    }
                }

 		// Unallocated Amount
                sb = new StringBuilder();
               // sb.Append("SELECT d.doc_txn_id_disp voucher_no, a.GL_INSTRMNT_NM, a.GL_INSTRMNT_NO, a.GL_INSTRMNT_DT,SUM(b.gl_amt_bs) gl_amt_bs, c.FIELD_VAL ");
		sb.Append("SELECT a.GL_INSTRMNT_NO,SUM(b.gl_amt_bs) gl_amt_bs ");
                sb.Append("FROM fin.gl_line_instrumnt a ");
                sb.Append("JOIN fin.gl_lines b ON(a.gl_org_id = b.gl_org_id AND a.gl_vou_id = b.gl_vou_id AND b.gl_coa_id = 1711 ");
                sb.Append("AND b.GL_TYPE_ID=3) ");
                sb.Append("JOIN fin.gl$flx c ON (a.gl_org_id = c.org_id AND a.gl_vou_id = c.doc_id ) ");
                sb.Append("JOIN app.app$doc$txn d ON(a.gl_org_id = d.doc_org_id AND a.gl_vou_id = d.doc_txn_id) ");
                sb.Append("WHERE a.gl_org_id = '0" + centreID + "' AND trunc(a.GL_INSTRMNT_DT) BETWEEN TO_DATE('01-Apr-2019','DD-MM-RRRR') AND TO_DATE('" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "','DD-MM-RRRR')  ");
                sb.Append(" GROUP BY a.GL_INSTRMNT_NO ");

                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                File.WriteAllText("f:/abc.txt", sb.ToString());

                //myConnection.Open();
                OracleDataReader dress = cmd.ExecuteReader();
                if (dress.HasRows)
                {
                    while (dress.Read())
                    {
                        DataRow[] drRow = dtHISVsFianance.Select("GL_INSTRMNT_NO='" + dress["GL_INSTRMNT_NO"].ToString().Replace(",","") + "'");


                        if (drRow.Length > 0)
                        {
                            drRow[0]["FinMain_Received"] = dress["gl_amt_bs"].ToString();
                            drRow[0]["Diff_HIS_Vs_FinMain_Received"] = Util.GetString(Util.GetDecimal(drRow[0]["HIS_Received"]) - Util.GetDecimal(dress["gl_amt_bs"]));
                            dtHISVsFianance.AcceptChanges();
                        }
                        else
                        {
                            drNew = dtHISVsFianance.NewRow();
                            drNew["GL_INSTRMNT_NO"] = dress["GL_INSTRMNT_NO"].ToString().Replace(",", "");
                            drNew["FinMain_Received"] = dress["gl_amt_bs"].ToString();

                            drNew["Diff_HIS_Vs_FinMain_Received"] = 0 - Util.GetDecimal(dress["gl_amt_bs"]);
                            dtHISVsFianance.Rows.Add(drNew);
                            dtHISVsFianance.AcceptChanges();
                        }


                        //foreach (DataRow row in dtHISVsFianance.Rows)
                        //{
                        //    if (row["GL_INSTRMNT_NO"].ToString() == dress["GL_INSTRMNT_NO"].ToString())
                        //    {
                        //        row["Fin_Main_ReceivedAmount"] = dress["gl_amt_bs"].ToString();
                        //        row["Diff_ReceivedAmount_FinStaging_vs_FinMain"] = Util.GetString(Util.GetDecimal(row["PanelReceivedAmount"]) - Util.GetDecimal(dress["gl_amt_bs"]));
                        //    }
                        //    else
                        //    {
                        //        if (dtHISVsFianance.Select("GL_INSTRMNT_NO='" + dress["GL_INSTRMNT_NO"].ToString() + "'").Length == 0)
                        //        {
                        //            drNew = dtHISVsFianance.NewRow();
                        //            drNew["INSTRUMENT_NO"] = dress["GL_INSTRMNT_NO"].ToString();
                        //            drNew["Fin_Main_ReceivedAmount"] = dress["gl_amt_bs"].ToString();
                        //            row["Diff_ReceivedAmount_FinStaging_vs_FinMain"] = Util.GetString(Util.GetDecimal(row["PanelReceivedAmount"]) - Util.GetDecimal(dress["gl_amt_bs"]));
                        //            dtHISVsFianance.Rows.Add(drNew);
                        //        }
                        //    }
                        //}

                        
                    }

                }
            }
            else if (type == 12)
            {                
                //Ankur
		
                sb.Append("  SELECT g.TRANS_TYPE, SUM((CASE WHEN g.TRANS_TYPE=8 then (-1)*g.TOT_PUR_PRICE WHEN g.TRANS_TYPE=18 AND g.INV_FLG <>'Y' then g.TOT_PUR_PRICE WHEN g.TRANS_TYPE =18 AND g.INV_FLG ='Y' THEN 0 ELSE g.TOT_PUR_PRICE END)*g.CURR_CONV) Fin_Staging ");
                sb.Append("    FROM appua.trans$grn g ");
                sb.Append("    WHERE TO_DATE(g.TRANS_DATE,'dd-mm-rrrr') BETWEEN '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "'  ");
                sb.Append("    AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    AND g.BRANCH_ID='0" + centreID + "' AND g.TOT_PUR_PRICE<>0 AND g.TRANS_TYPE IN (3,5,13,14,16,17,8,19,27,28,7,18) ");
                sb.Append(" GROUP BY g.TRANS_TYPE ");
                
                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["TRANS_TYPE"].ToString() == dr["TRANS_TYPE"].ToString())
                            {
                                row["Fin_Staging"] = Util.GetString(Util.round(Util.GetDecimal(dr["Fin_Staging"])));
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.round(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"])));
                            }
                        }
                    }
                }
                             
                
                sb.Clear();
                
                /*
                sb.Append("SELECT a.TRANS_TYPE, SUM(DECODE(b.gl_amt_typ, 'Dr',b.amt, -b.amt)) Fin_Main FROM ");
                sb.Append("( ");
                sb.Append("select  distinct c.STOCK COA_ID, a.grn_no, trans_type ");
                sb.Append("from appua.trans$grn a ");
                sb.Append("inner join appua.hims$org$map b on (a.branch_id = b.HIMS_BRANCH_CODE) ");
                sb.Append("inner join itm$master@ebizdbl c on (a.item_id = c.\"ItemID\") ");
                sb.Append("where ");
                sb.Append("trunc(a.trans_date) between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "'and '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("and b.org_id ='0"+ centreID +"' AND a.trans_type IN (19,18,23,21,25,5,14,17, 3,13,16,22,24,26,7,8,27)  ");
                //AND a.trans_type IN (19,18,23,21,25,5,14,17, 3,13,16,22,24,26,7,8,27)  (3,13,16,22,24,26,7,8,27)
                sb.Append(") a INNER JOIN  ");
                sb.Append("(  ");
                sb.Append("SELECT gl_coa_id, gl_amt_typ, gl_ext_doc_no, gl_amt_bs amt, gl_vou_id FROM fin.gl_lines a  ");
                sb.Append("WHERE trunc(a.gl_vou_dt) BETWEEN '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' AND a.gl_org_id = '0" + centreID + "' AND a.usr_id_create = 3  ");
                sb.Append(") b ON (a.coa_id = b.gl_coa_id AND a.grn_no = b.gl_ext_doc_no) GROUP BY a.trans_type  ");
                */

                 sb.Append("Select trans_type,sum(amt)Fin_Main from (");
                sb.Append("     SELECT a.trans_type, sum(decode(b.gl_amt_typ, 'Dr',b.amt, -b.amt)) amt from ( ");
                sb.Append("	        SELECT distinct trans_type ");
                sb.Append("	        from appua.trans$grn a ");
                sb.Append("	        inner join appua.hims$org$map b on (a.branch_id = b.HIMS_BRANCH_CODE) ");
                sb.Append("     	where ");
                sb.Append("	        trunc(a.trans_date) between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' and '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("	        and b.org_id = '0" + centreID + "' ");
                sb.Append("	        and a.trans_type in(19,18,23,21,25,5, 14, 17) ");
                sb.Append("     ) a inner join ( ");
                sb.Append("	        select a.gl_coa_id, a.gl_amt_typ,a.gl_amt_bs amt, a.gl_vou_id, b.his_grn_typ ");
                sb.Append("	        from fin.gl_lines a ");
                sb.Append("	        inner join fin.gl b on (a.gl_org_id = b.gl_org_id and a.gl_vou_id = b.gl_vou_id) ");
                sb.Append("	        where ");
                sb.Append("	        trunc(a.gl_vou_dt) between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' and '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("	        and a.gl_org_id = '0" + centreID + "' ");
                sb.Append("	        and a.usr_id_create = 3 ");
                sb.Append("	            and b.his_grn_typ is not null ");
                sb.Append("	        and a.gl_amt_typ = 'Dr' ");
                sb.Append("	        and a.gl_coa_id in(4387,1823,2072,1833,12001,1964,2075,1826,1915,2078,589) ");
                sb.Append("     ) b on (a.trans_type = b.his_grn_typ) group by a.trans_type ");
                sb.Append("     UNION ALL ");
                sb.Append("     SELECT a.trans_type, sum(decode(b.gl_amt_typ, 'Dr',b.amt, -b.amt)) amt from ( ");
                sb.Append("	        SELECT distinct trans_type ");
                sb.Append("	        from appua.trans$grn a ");
                sb.Append("	        inner join appua.hims$org$map b on (a.branch_id = b.HIMS_BRANCH_CODE) ");
                sb.Append("	        where ");
                sb.Append("	        trunc(a.trans_date) between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' and '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("	        and b.org_id = '0" + centreID + "' ");
                sb.Append("	        and a.trans_type in(3,13, 16,22,24,26,7,8,27) ");
                sb.Append("     )a inner join ( ");
                sb.Append("	        select a.gl_coa_id, a.gl_amt_typ,a.gl_amt_bs amt, a.gl_vou_id, b.his_grn_typ ");
                sb.Append("	        from fin.gl_lines a ");
                sb.Append("	        inner join fin.gl b on (a.gl_org_id = b.gl_org_id and a.gl_vou_id = b.gl_vou_id) ");
                sb.Append("     	where ");
                sb.Append("	        trunc(a.gl_vou_dt) between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' and '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("	        and a.gl_org_id = '0" + centreID + "' ");
                sb.Append("	        and a.usr_id_create = 3 ");
                sb.Append("	        and b.his_grn_typ is not null ");
                sb.Append("	        and a.gl_amt_typ = 'Cr' ");
                sb.Append("	        and a.gl_coa_id in(4387,1823,2072,1833,12001,1964,2075,1826,1915,2078,589) ");
                sb.Append("     )b on (a.trans_type = b.his_grn_typ) group by a.trans_type ");
                sb.Append(")t GROUP BY t.trans_type");


                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                //File.WriteAllText("f:/abc.txt", sb.ToString());

                //myConnection.Open();
                OracleDataReader dress = cmd.ExecuteReader();
                if (dress.HasRows)
                {
                    while (dress.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["TRANS_TYPE"].ToString() == dress["TRANS_TYPE"].ToString())
                            {
                                row["Fin_Main"] = Util.GetString(Util.round(Util.GetDecimal(dress["Fin_Main"].ToString())));
                                row["Diff_FinStaging_vs_FinMain"] = Util.round(Util.GetDecimal(row["Fin_Staging"]) - Util.GetDecimal(dress["Fin_Main"]));
                            }
                        }
                    }
                }
                 
                 


                //OracleDataReader dress = cmd.ExecuteReader();
                //if (dress.HasRows)
                //{
                //    while (dress.Read())
                //    {
                //        foreach (DataRow row in dtHISVsFianance.Rows)
                //        {
                //            if (row["DoctorID"].ToString() == dress["eo_leg_code"].ToString())
                //            {
                //                row["Fin_Main"] = dress["Fin_Main"].ToString();
                //                row["Diff_FinStaging_vs_FinMain"] = Util.GetString(Util.GetDecimal(row["His_Main"]) - Util.GetDecimal(dress["Fin_Main"]));
                //            }
                //        }
                //    }
                //}
            }

            else if (type == 13)
            {
                sb.Append("SELECT SUM(WRITE_OFF_AMT) AS Fin_Staging,f.PanelID ");
                sb.Append("FROM appua.trans$WRITE$off f  ");
                sb.Append("WHERE f.BRANCH_ID='0" + centreID + "'  ");
                sb.Append("AND TO_DATE(f.TRANS_DT,'dd-mm-rrrr') BETWEEN '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "'  ");
                sb.Append("AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "'  ");
                sb.Append("AND f.WRITE_OFF_AMT<>0  "); // WRITE_OFF_PANEL
                sb.Append("GROUP BY f.PanelID ");


                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["PanelID"].ToString() == dr["PanelID"].ToString())
                            {
                                row["Fin_Staging"] = dr["Fin_Staging"].ToString();
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"]));
                            }
                        }
                    }
                }
            }

            else if (type == 14)
            {
                sb.Append("SELECT f.DoctorID,SUM(f.WRITE_OFF_DOCTOR) AS Fin_Staging ");
                sb.Append("FROM appua.trans$WRITE$off f  ");
                sb.Append("WHERE f.BRANCH_ID='0" + centreID + "' ");
                sb.Append("AND  TO_DATE(f.TRANS_DT,'dd-mm-rrrr') BETWEEN '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "'  ");
                sb.Append("AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' AND f.WRITE_OFF_DOCTOR<>0 ");
                sb.Append("GROUP BY f.DoctorID ");

                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                //File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["DoctorID"].ToString() == dr["DoctorID"].ToString())
                            {
                                row["Fin_Staging"] = dr["Fin_Staging"].ToString();
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"]));
                            }
                        }
                    }
                }
            }

            else if (type == 15)
            {
                sb.Append("SELECT SUM(Amt)Fin_Staging,t.PanelID FROM ( ");
                sb.Append("    SELECT P.PanelID,ROUND(SUM(allocated_amt*DECODE(curr_conv,0,1,curr_conv)),2)Amt ");
                sb.Append("    FROM appua.trans$dtl$panel p ");
                sb.Append("    WHERE TRUNC(p.Allocated_date) between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    AND p.RECV_BRCH_ID='" + centreID + "' ");
                sb.Append("    GROUP BY p.PanelID ");
                sb.Append("    UNION ALL ");
                sb.Append("    SELECT pa.PanelID, ");
                sb.Append("    ROUND(SUM(PA.PAY_AMT*DECODE(PA.CURR_CONV,0,1,PA.CURR_CONV))*-1,2)Amt ");
                sb.Append("    FROM appua.TRANS$DTL$PAY pa ");
                sb.Append("    WHERE pa.RECV_BRCH_ID='0" + centreID + "' AND pa.PAID_BY='PA'  ");
                sb.Append("    AND TO_DATE(pa.INSTRUMENT_DATE,'dd-mm-rrrr') between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    GROUP BY PA.PanelID ");
                sb.Append("    UNION ALL ");
                sb.Append("    SELECT TO_NUMBER(f.PanelID) PanelID, ");
                sb.Append("    ROUND(SUM(WRITE_OFF_AMT+WRITE_OFF_DOCTOR)*-1,2)Amt ");
                sb.Append("    FROM appua.trans$WRITE$off f  ");
                sb.Append("    WHERE f.BRANCH_ID='0" + centreID + "' AND TRUNC(f.TRANS_DT) ");
                sb.Append("    between '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append("    GROUP BY f.PanelID ");
                sb.Append(")t GROUP BY t.PanelID ");

                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                //File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["PanelID"].ToString() == dr["PanelID"].ToString())
                            {
                                row["Fin_Staging"] = dr["Fin_Staging"].ToString();
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"]));
                            }
                        }
                    }
                }
            }
            else if (type == 16)
            {
                sb.Append(" SELECT DoctorID,TransferedAmount AS Fin_Staging FROM ( ");
                sb.Append(" SELECT a.DoctorID, nvl(b.amt,0) dr_cr_amt, nvl(c.amt,0) doc_share_amt,ROUND(nvl(b.amt,0) + nvl(c.amt,0),2) NetClosing, ");
                sb.Append(" ROUND(nvl(d.allocatedamount,0),2) allocatedamount,ROUND(nvl(WRITE_OFF_DOCTOR,0),2)WRITE_OFF_DOCTOR, ");
                sb.Append(" ROUND((nvl(b.amt,0) + nvl(c.amt,0)-nvl(allocatedamount,0)+nvl(WRITE_OFF_DOCTOR,0)),2) TransferedAmount ");
                sb.Append(" FROM ( ");
                sb.Append(" SELECT DISTINCT DoctorID FROM appua.doc$SHARE ");
                sb.Append(" UNION ");
                sb.Append(" SELECT DISTINCT DoctorID FROM appua.dr$cr$notes ");
                sb.Append(" UNION ");
                sb.Append(" SELECT DISTINCT DoctorID FROM appua.doc$alloc ");
                sb.Append(" UNION ALL ");
                sb.Append(" SELECT DISTINCT DoctorID FROM appua.trans$WRITE$off ");
                sb.Append(" ) a ");
                sb.Append(" LEFT OUTER JOIN ( ");
                sb.Append(" 	SELECT DoctorID, sum(amt)amt  from ( ");
                sb.Append(" 	SELECT dcr.DoctorID, DECODE(tr_type, 'D',amount*curr_conv,DECODE(aa.TRAN_TYPE,'C',0,-amount*curr_conv)) amt  ");
                sb.Append(" 	FROM appua.dr$cr$notes dcr ");
                sb.Append(" LEFT OUTER JOIN ( ");
                sb.Append(" 		SELECT DoctorID as DOCTORID,TRAN_TYPE FROM appua.doc$SHARE WHERE TRUNC(trans_dt) BETWEEN '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append(" 		AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' AND BRANCH_ID='0" + centreID + "' GROUP BY DoctorID,TRAN_TYPE ");
                sb.Append(" 	)aa ON (dcr.DoctorID=aa.DOCTORID) ");


                sb.Append(" WHERE config_id IN ('1', '5') AND  TRUNC(trans_dt) BETWEEN '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "'  ");
                sb.Append(" 	AND branch_id= '0" + centreID + "' )k GROUP BY DoctorID ");
                sb.Append(" ) b ON (a.DoctorID = b.DoctorID) ");
                sb.Append(" LEFT OUTER JOIN ( ");
                sb.Append(" 	SELECT DoctorID, SUM(doc_amount) amt FROM appua.doc$SHARE WHERE tran_type IN('D','C') AND  TRUNC(ref_date)  ");
                sb.Append(" 	BETWEEN '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' AND '" + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "' AND branch_id= '0" + centreID + "' GROUP BY DoctorID ");
                sb.Append(" ) c ON (a.DoctorID = c.DoctorID) ");

                sb.Append(" LEFT OUTER JOIN ( ");
                sb.Append(" 	SELECT DoctorID, nvl(SUM(al.ALLOC_AMOUNT-al.BANK_CHARGES),0) allocatedamount FROM appua.doc$alloc al ");
                sb.Append(" 	WHERE TRUNC(ref_date) BETWEEN  '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' AND '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append(" 	AND DoctorID<>'' AND BRANCH_ID='0" + centreID + "' GROUP BY DoctorID ");
                sb.Append(" ) d ON a.DoctorID = d.DoctorID ");
                sb.Append(" LEFT OUTER JOIN ( ");
                sb.Append(" 	SELECT wr.DoctorID,nvl(SUM(wr.WRITE_OFF_DOCTOR),0)WRITE_OFF_DOCTOR ");
                sb.Append(" 	FROM appua.trans$WRITE$off wr WHERE TRUNC(wr.TRANS_DT) BETWEEN  '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' AND '" + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "' ");
                sb.Append(" 	AND wr.DoctorID<>'0' AND wr.BRANCH_ID='0" + centreID + "' GROUP BY wr.DoctorID ");
                sb.Append(" ) e ON a.DoctorID = e.DoctorID ");
                sb.Append(" ) t ");







                cmd.CommandText = sb.ToString();
                cmd.BindByName = true;

                // File.WriteAllText("f:/abc.txt", sb.ToString());

                myConnection.Open();
                OracleDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dtHISVsFianance.Rows)
                        {
                            if (row["DoctorID"].ToString() == dr["DoctorID"].ToString())
                            {
                                row["Fin_Staging"] = dr["Fin_Staging"].ToString();
                                row["Diff_HisStaging_vs_FinStaging"] = Util.GetString(Util.GetDecimal(row["His_Staging"]) - Util.GetDecimal(dr["Fin_Staging"]));
                            }
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            if (myConnection.State == ConnectionState.Open)
                myConnection.Close();
        }


        if (dtHISVsFianance.Rows.Count > 0)
        {
            if (reporttype == "R")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From Date : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To Date : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "";
                dtHISVsFianance.Columns.Add(dc);
                dtHISVsFianance = Util.GetDataTableRowSum(dtHISVsFianance);
                string CacheName = HttpContext.Current.Session["ID"].ToString();
                Common.CreateCachedt(CacheName, dtHISVsFianance);
                ReportName = ReportName + " Report";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
            }
            else if (reporttype == "S")
            {
                dtHISVsFianance = Util.GetDataTableRowSum(dtHISVsFianance);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dtHISVsFianance, period = "From Date : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To Date : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy") + "" });
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Error." });
            }
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Record Found." });
        }
    }
}
