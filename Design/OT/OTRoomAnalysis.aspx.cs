using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Design_OT_OTRoomAnalysis : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            //calendarExteFromDate.EndDate = DateTime.Now;
            //calendarExteToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }




    [WebMethod]
    public static string GetAnalysis(string fromDate, string toDate)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();

        StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT (24-t.AvgCon)AvilableCon,(t.AvgCon*100/24)PercentConsue,t.* FROM  (");
        //sb.Append(" SELECT  SUM(TIMESTAMPDIFF(HOUR,ot.Start_DateTime,ot.End_Datetime)/((DATEDIFF(@toDate,@fromDate)+1))) `AvgCon`,ot.OT,SUM(TIMESTAMPDIFF(MINUTE,ot.Start_DateTime,ot.End_Datetime))a FROM  ot_surgery_schedule ot WHERE DATE(ot.Start_DateTime)>=@fromDate AND  DATE(ot.End_Datetime)<=@toDate ");
        //sb.Append(" GROUP BY ot.OT ");
        //sb.Append(")t");


        sb.Append(" SELECT (24-IFNULL(t.AvgCon,0))AvilableCon,(IFNULL(t.AvgCon,0)*100/24)PercentConsue,IFNULL(t.AvgCon,0)AvgCon,t.Name FROM  ( ");
        sb.Append(" SELECT  SUM(TIMESTAMPDIFF(HOUR,ot.Start_DateTime,ot.End_Datetime)/((DATEDIFF(@toDate,@fromDate)+1))) `AvgCon`,                          ");
        sb.Append(" m.Name,SUM(TIMESTAMPDIFF(MINUTE,ot.Start_DateTime,ot.End_Datetime))a                                                                               ");
        sb.Append(" FROM  ot_master m      ");
        sb.Append(" LEFT JOIN  ot_surgery_schedule ot ON ot.OT=m.Name AND DATE(ot.Start_DateTime)>=@fromDate AND  DATE(ot.End_Datetime)<=@toDate                  ");
  
         sb.Append(" GROUP BY m.Name) t   ");

        

        DataTable dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
         {
             toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
             fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd")
         });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
}