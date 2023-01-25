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
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Web.Services;
using System.IO;
using System.Collections.Generic;

[Serializable]
public partial class Design_CommonReports_SICReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ceFromDate.EndDate = ceToDate.EndDate = DateTime.Now;
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
    public static string generateSICReport(int centreID, string fromDate, string toDate, int type)
    {
        DataTable dt = new DataTable();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (type == 1)
            {
                FinanceData(fromDate, toDate, centreID, tnx);

                dt = StockReports.GetDataTable(" CALL rpt_HISvsFinance(" + centreID + ",'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "')");
            }

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


	

    [WebMethod]
    public static string GetExcelReports(int centreID, string fromDate, string toDate, int type)
    {



        DataTable dt_ = new DataTable();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        List<decimal> columns = new List<decimal>() { 8, 9, 18, 19 };
        try
        {
            if (type == 1)
            {
                //  FinanceData(fromDate, toDate, centreID, tnx);

                dt_ = StockReports.GetDataTable(" CALL rpt_HISvsFinance(" + centreID + ",'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "')");


                decimal[] RowTotals = new decimal[dt_.Columns.Count];
                foreach (DataRow row in dt_.Rows)
                {

                    for (int i = 0; i < dt_.Columns.Count; i++)
                    {

                        if (columns.IndexOf(i) > -1)
                            RowTotals[i] += Util.GetDecimal(row[dt_.Columns[i].ColumnName]);
                        else
                            continue;
                    }

                }


                DataRow dtrow = dt_.NewRow();
                dtrow[7] = "Total";
                dt_.Rows.Add(dtrow);


                for (int i = 0; i < dt_.Columns.Count; i++)
                {

                    if (columns.IndexOf(i) > -1)
                        dt_.Rows[dt_.Rows.Count - 1][i] = RowTotals[i];
                    else
                        continue;
                }



                HttpContext.Current.Session["dtExport2Excel"] = dt_;
                HttpContext.Current.Session["ReportName"] = "SIC REVENUE REPORT";
                HttpContext.Current.Session["Period"] = "From " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy");



                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../common/ExportToExcel.aspx" });
            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage });


        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = ex.Message, message = AllGlobalFunction.errorMessage });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }



    }





    public static void FinanceData(string FromDate, string ToDate, int Centre, MySqlTransaction trans)
    {
        // string sql = "SELECT H.TRANS_NO, H.DOC_DT, H.DOC_NO,H.NARRATION, H.GL_AMT_TYP, H.SPECIFIC_CURRENCY, H.BASE_CURRENCY, H.DOC_AMT, H.BS_AMT, H.COA_NM, H.COST_CENTER, H.MODULE, H.GL_VOU_ID FROM APPUA.HIMS_REVENUE_VW H Where DOC_DT BETWEEN TO_DATE('03/01/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND TO_DATE('03/15/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS') ORDER BY 2 ASC NULLS LAST";

        string sql = "SELECT H.TRANS_NO, TO_CHAR(H.DOC_DT,'RRRR-MM-dd') as DOC_DT, H.DOC_NO, H.NARRATION, H.GL_AMT_TYP, H.SPECIFIC_CURRENCY, H.BASE_CURRENCY, H.DOC_AMT, H.BS_AMT, H.COA_NM, H.COST_CENTER, H.MODULE, H.COA_ID, H.GL_VOU_ID FROM APPUA.HIMS_REVENUE_VW H Where DOC_DT BETWEEN TO_DATE('" + Util.GetDateTime(FromDate).ToString("MM/dd/yyyy") + " 00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND TO_DATE('" + Util.GetDateTime(ToDate).ToString("MM/dd/yyyy") + " 00:00:00', 'MM/DD/YYYY HH24:MI:SS')";
        DataTable dt = EbizFrame.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {


            MySqlHelper.ExecuteNonQuery(trans, CommandType.Text, "truncate table temp_financeData");

            StringBuilder sb = new StringBuilder();
            sb.Append(" insert into temp_financeData(TRANS_NO,DOC_DT,DOC_NO,NARRATION,GL_AMT_TYP,SPECIFIC_CURRENCY,BASE_CURRENCY,DOC_AMT,BS_AMT,COA_NM,COST_CENTER,MODULE,COA_ID,GL_VOU_ID) values ");

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (i == dt.Rows.Count - 1)
                {
                    sb.Append(" ('" + dt.Rows[i]["TRANS_NO"].ToString() + "','" + dt.Rows[i]["DOC_DT"].ToString() + "','" + dt.Rows[i]["DOC_NO"].ToString() + "','" + dt.Rows[i]["NARRATION"].ToString() + "','" + dt.Rows[i]["GL_AMT_TYP"].ToString() + "','" + dt.Rows[i]["SPECIFIC_CURRENCY"].ToString() + "','" + dt.Rows[i]["BASE_CURRENCY"].ToString() + "','" + dt.Rows[i]["DOC_AMT"].ToString() + "','" + dt.Rows[i]["BS_AMT"].ToString() + "','" + dt.Rows[i]["COA_NM"].ToString() + "','" + dt.Rows[i]["COST_CENTER"].ToString() + "','" + dt.Rows[i]["MODULE"].ToString() + "','" + dt.Rows[i]["COA_ID"].ToString() + "','" + dt.Rows[i]["GL_VOU_ID"].ToString() + "') ");
                }
                else
                {
                    sb.Append(" ('" + dt.Rows[i]["TRANS_NO"].ToString() + "','" + dt.Rows[i]["DOC_DT"].ToString() + "','" + dt.Rows[i]["DOC_NO"].ToString() + "','" + dt.Rows[i]["NARRATION"].ToString() + "','" + dt.Rows[i]["GL_AMT_TYP"].ToString() + "','" + dt.Rows[i]["SPECIFIC_CURRENCY"].ToString() + "','" + dt.Rows[i]["BASE_CURRENCY"].ToString() + "','" + dt.Rows[i]["DOC_AMT"].ToString() + "','" + dt.Rows[i]["BS_AMT"].ToString() + "','" + dt.Rows[i]["COA_NM"].ToString() + "','" + dt.Rows[i]["COST_CENTER"].ToString() + "','" + dt.Rows[i]["MODULE"].ToString() + "','" + dt.Rows[i]["COA_ID"].ToString() + "','" + dt.Rows[i]["GL_VOU_ID"].ToString() + "'), ");
                }
            }

            StreamWriter sw = new StreamWriter("c:\\dev.txt", true, Encoding.ASCII);
            // string NextLine = "This is the appended line.";
            sw.Write(sb.ToString());
            sw.Close();

            MySqlHelper.ExecuteNonQuery(trans, CommandType.Text, sb.ToString());
        }
    }

}
