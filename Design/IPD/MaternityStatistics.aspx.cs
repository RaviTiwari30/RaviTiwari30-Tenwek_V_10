using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;

public partial class Design_IPD_MaternityStatistics : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       ddlMonth.SelectedValue= DateTime.Now.Month.ToString();
       ddlYear.SelectedValue = DateTime.Now.Year.ToString();

    }
    [WebMethod(EnableSession = true, Description = "Save Intake")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveStats(object stats1, string month, string year)
    {
        List<Stats> stats = new JavaScriptSerializer().ConvertToType<List<Stats>>(stats1);
        if (stats.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < stats.Count; i++)
                {
                    if (stats[i].ID == null || stats[i].ID == "")
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO `maternitystatics` ( `BtnId`, `Total`,  `CS`,  `SVD`,  `BREEC`,  `AVD`,  `LBIRTH`,  `FBIRTHFSB`,  `SBIRTHFSB`,"+
"  `SBIRTHMSB`,  `KGS`,  `PRETERM`,  `ECLAMPSIA`,  `RUTERUS`,  `OBSTLABC`,  `APH`,  `PPH`,  `SEPSIS`,  `MILD`,  `MODERA`,  `SERVER`,  `18YEAR`,  `1824YEAR`,  `24YEAR`,  `ONETEAR`,"+
"  `TWOTEAR`,  `THREETEAR`,  `FOURTEAR`,  `EPISIOTOMY`, `NEWBORNRESUSCITATION`,  `Month`,  `Year` ) "+
" VALUE('" + stats[i].BtnId + "', '" + stats[i].Total + "',  '" + stats[i].CS + "',  '" + stats[i].SVD + "',  '" + stats[i].BREEC + "',  '" + stats[i].AVD + "',  '" + stats[i].LBIRTH + "',  '" + stats[i].FBIRTHFSB + "'," +
"'"+stats[i].SBIRTHFSB+"',  '"+stats[i].SBIRTHMSB+"',  '"+stats[i].KGS+"',  '"+stats[i].PRETERM+"',  '"+stats[i].ECLAMPSIA+"',  '"+stats[i].RUTERUS+"',  '"+stats[i].OBSTLABC+"',  '"+
stats[i].APH+"',  '"+stats[i].PPH+"',  '"+stats[i].SEPSIS+"',  '"+stats[i].MILD+"',  '"+stats[i].MODERA+"',  '"+stats[i].SERVER+"',  '"+stats[i].YEAR18+"',  '"+stats[i].YEAR1824+"',  '"+
    stats[i].YEAR24+"',  '"+stats[i].ONETEAR+"',  '"+stats[i].TWOTEAR+"',  '"+stats[i].THREETEAR+"',  '"+stats[i].FOURTEAR+"',  '"+stats[i].EPISIOTOMY+"', '"+stats[i].NEWBORNRESUSCITATION+"',  '"+
        month+"',  '"+year+"')");
                    }
                    else if (stats[i].ID != null || stats[i].ID != "")
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update maternitystatics set `Total` ='"+stats[i].Total+"',"+
                             " `CS` ='"+stats[i].CS+"',"+
                             " `SVD` ='"+stats[i].SVD+"',"+
                             " `BREEC` ='"+stats[i].BREEC+"',"+
                             " `AVD` ='"+stats[i].AVD+"',"+
                             " `LBIRTH` ='"+stats[i].LBIRTH+"',"+
                             " `FBIRTHFSB` ='"+stats[i].FBIRTHFSB+"',"+
                             " `SBIRTHFSB` ='"+stats[i].SBIRTHFSB+"',"+
                             " `SBIRTHMSB` ='"+stats[i].SBIRTHMSB+"',"+
                             " `KGS` ='"+stats[i].KGS+"',"+
                             " `PRETERM` ='"+stats[i].PRETERM+"',"+
                             " `ECLAMPSIA` ='"+stats[i].ECLAMPSIA+"',"+
                             " `RUTERUS` ='"+stats[i].RUTERUS+"',"+
                             " `OBSTLABC` ='"+stats[i].OBSTLABC+"',"+
                             " `APH` ='"+stats[i].APH+"',"+
                             " `PPH` ='"+stats[i].PPH+"',"+
                             " `SEPSIS` ='"+stats[i].SEPSIS+"',"+
                             " `MILD` ='"+stats[i].MILD+"',"+
                             " `MODERA` ='"+stats[i].MODERA+"',"+
                             " `SERVER` ='"+stats[i].SERVER+"',"+
                             " `18YEAR` ='"+stats[i].YEAR18+"',"+
                             " `1824YEAR` ='"+stats[i].YEAR1824+"',"+
                             " `24YEAR` ='"+stats[i].YEAR24+"',"+
                             " `ONETEAR` ='"+stats[i].ONETEAR+"',"+
                             " `TWOTEAR` ='"+stats[i].TWOTEAR+"',"+
                             " `THREETEAR` ='"+stats[i].THREETEAR+"',"+
                             " `FOURTEAR` ='"+stats[i].FOURTEAR+"',"+
                             " `EPISIOTOMY` ='"+stats[i].EPISIOTOMY+"',"+
                             " `NEWBORNRESUSCITATION` ='"+stats[i].NEWBORNRESUSCITATION+"',"+
                             " `Month` ='"+month+"',"+
                             " `Year` ='"+year+"' WHERE ID='" + stats[i].ID + "' ");
                    }
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "";
        }
    }
    public class Stats
    {
        public string ID { get; set; }
        public string BtnId { get; set; }
  public string Total{ get; set;}
  public string CS{ get; set;}
  public string SVD{ get; set;}
  public string BREEC{ get; set;}
  public string AVD{ get; set;}
  public string LBIRTH{ get; set;}
  public string FBIRTHFSB{ get; set;}
  public string SBIRTHFSB{ get; set;}
  public string SBIRTHMSB{ get; set;}
  public string KGS{ get; set;}
  public string PRETERM{ get; set;}
  public string ECLAMPSIA{ get; set;}
  public string RUTERUS{ get; set;}
  public string OBSTLABC{ get; set;}
  public string APH{ get; set;}
  public string PPH{ get; set;}
  public string SEPSIS{ get; set;}
  public string MILD{ get; set;}
  public string MODERA{ get; set;}
  public string SERVER{ get; set;}
  public string YEAR18{ get; set;}
  public string YEAR1824{ get; set;}
  public string YEAR24 { get; set; }
  public string ONETEAR{ get; set;}
  public string TWOTEAR{ get; set;}
  public string THREETEAR{ get; set;}
  public string FOURTEAR{ get; set;}
  public string EPISIOTOMY{ get; set;}
  public string NEWBORNRESUSCITATION{ get; set;}
  public string Month{ get; set;}
  public string Year{get; set;}
    }

    [WebMethod]
    public static string bindMaternityStats(string month, string year)
    {
        //string sdt = Util.GetDateTime(DateTime.Now.AddDays(-Int32.Parse(spandays)).AddMonths(-Int32.Parse(span))).ToString("yyyy-MM-dd");
        //string edt = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");

        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT * FROM MaternityStatics  where Month='" + month + "'" +
  " AND  Year='"+year+"' ORDER BY  Id desc  ");



        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return "";
    }
    
}