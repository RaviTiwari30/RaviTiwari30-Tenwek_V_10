using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_InTakeOutTakeChart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AllQuery AQ = new AllQuery();
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.Hour + ":" + DateTime.Now.Minute;
            ViewState["UserID"] = Session["ID"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["TransactionID"] = TID;
            ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();
            DataTable dtDischarge = AQ.GetPatientDischargeStatus(TID);
            lblPatientId.Text = Request.QueryString["PatientID"].ToString();
            lblTransactionId.Text = TID;

            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                {
                    string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No form can be fill...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }
        }
        DateTime AdmitDate = Util.GetDateTime(AQ.getAdmitDate(ViewState["TransactionID"].ToString()));
        txtDate.Attributes.Add("readOnly", "readOnly");
        calDate.StartDate = AdmitDate;
        calDate.EndDate = DateTime.Now;
    }

    private DataTable Search()
    {
        DataTable dt = StockReports.GetDataTable("SELECT it.ID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,DATE_FORMAT(TIME,'%h:%i %p')TIME,IVF,IVFQuantity,Oral_RT,OralQuantity,OutPut,Others,em.Name AS EntryBy,EntryBy EntryByID,DATE_FORMAT(it.EntryDate,'%d-%b-%Y %h:%i %p')EntryDate FROM InTakeOutPutChart it" +
                                               " INNER JOIN employee_master em ON em.EmployeeID=it.EntryBy " +
                                               " WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' order by concat(DATE,' ',TIME) desc ");
        return dt;
    }




    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = Search();
        DataSet ds = new DataSet();
        if (dt.Rows.Count > 0)
        {
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "InTakeOutTakeChart";
            AllQuery AQ = new AllQuery();
            DataTable dtStatus = AQ.GetPatientDischargeStatus(ViewState["TransactionID"].ToString());
            string Status = dtStatus.Rows[0]["Status"].ToString();
            DataTable dtInfo = AQ.GetPatientIPDInformation("", ViewState["TransactionID"].ToString(), Status);
            ds.Tables.Add(dtInfo.Copy());
            ds.Tables[1].TableName = "PatientInfo";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[2].TableName = "logo";
            //    ds.WriteXmlSchema(@"E:\InTakeOutTakeChart.xml");
            Session["ReportName"] = "InTakeOutTakeChart";
            Session["ds"] = ds;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }



    [WebMethod(EnableSession = true, Description = "Save intake output chart")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveIntakeOutTake(insert item)
    {
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  intakeoutputchart ");
            sb.Append(" (DATE,TIME,EntryBy,EntryDate,PatientID,TransactionID, ");
            sb.Append(" FluidNo,Type,Infused,POType,POAmount,TubeType,TubeAmount,Vomit, ");
            sb.Append(" Stool,NG,Urine,Drain1,Drain2,Drain3,Remark,IsActive)  ");
            sb.Append(" values (@DATE,@TIME,@EntryBy,NOW(),@PatientID,@TransactionID, ");
            sb.Append(" @FluidNo,@Type,@Infused,@POType,@POAmount,@TubeType,@TubeAmount,@Vomit, ");
            sb.Append(" @Stool,@NG,@Urine,@Drain1,@Drain2,@Drain3,@Remark,@IsActive)  ");
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {

                DATE = Util.GetDateTime(item.DATE).ToString("yyyy-MM-dd"),
                TIME = Util.GetDateTime(item.TIME).ToString("HH:mm:ss"),
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                PatientID = Util.GetString(item.PatientID),
                TransactionID = Util.GetString(item.TransactionID),
                FluidNo = Util.GetInt(item.FluidNo),
                Type = Util.GetString(item.Type),
                Infused = Util.GetDecimal(item.Infused),
                POType = Util.GetString(item.POType),
                POAmount = Util.GetDecimal(item.POAmount),
                TubeType = Util.GetString(item.TubeType),
                TubeAmount = Util.GetDecimal(item.TubeAmount),
                Vomit = Util.GetDecimal(item.Vomit),
                Stool = Util.GetDecimal(item.Stool),
                NG = Util.GetDecimal(item.NG),
                Urine = Util.GetDecimal(item.Urine),
                Drain1 = Util.GetDecimal(item.Drain1),
                Drain2 = Util.GetDecimal(item.Drain2),
                Drain3 = Util.GetDecimal(item.Drain3),
                Remark = Util.GetString(item.Remark),
                IsActive = 1

            });

            CountSave += A;


            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Msg = "Save Successfully" });

            }
            else
            {
                tnx.Rollback();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            CountSave--;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true, Description = "Save intake output chart")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Delete(int Id)
    {

        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();


            sb.Append(" update intakeoutputchart ");
            sb.Append(" set IsActive=@IsActive,UpdateBy=@EntryBy,UpdateDate=NOW() where ID=@ID");
           
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            { 
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                 ID=Util.GetInt(Id),
                IsActive = 0

            });

            CountSave += A;


            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Msg = "Save Successfully" });

            }
            else
            {
                tnx.Rollback();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            CountSave--;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class insert
    {
        public string ID { get; set; } //int

        public string DATE { get; set; }
        public string TIME { get; set; }
        public string EntryBy { get; set; }
        public string EntryDate { get; set; }
        public string PatientID { get; set; }
        public string TransactionID { get; set; }
        public string FluidNo { get; set; }
        public string Type { get; set; }
        public string Infused { get; set; }
        public string POType { get; set; }
        public string POAmount { get; set; }
        public string TubeType { get; set; }
        public string TubeAmount { get; set; }
        public string Vomit { get; set; }
        public string Stool { get; set; }

        public string NG { get; set; }
        public string Urine { get; set; }
        public string Drain1 { get; set; }
        public string Drain2 { get; set; }
        public string Drain3 { get; set; }
        public string Remark { get; set; }
        public string IsActive { get; set; }

    }


    [WebMethod(EnableSession = true)]
    public static string GetDataDetails(int Typ, string Pid,string Tid)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();
            string Todaydate = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
            string Yesterdaydate = Util.GetDateTime(DateTime.Now).AddDays(-1).ToString("yyyy-MM-dd");
             
            string Time = "06:00:00";
            string TodayDateTime = Todaydate + " " + Time;
            string YesterdayDateTime = Yesterdaydate + " " + Time;



            sbnew.Append(" SELECT ic.ID,DATE_FORMAT( ic.DATE,'%d-%b-%Y')DATE,if(date(ic.DATE)=date(NOW()),1,0)CanDelete,TIME_FORMAT(ic.TIME,'%I:%i  %p')TIME,ic.EntryBy,ic.PatientID, ");
            sbnew.Append(" ic.FluidNo,ic.Type,ic.Infused,ic.POType,ic.POAmount,ic.TubeType,ic.TubeAmount,ic.Vomit, ");
            sbnew.Append(" ic.Stool,ic.NG,ic.Urine,ic.Drain1,ic.Drain2,ic.Drain3,ic.Remark, CONCAT(em.Title,' ',em.NAME) EntryByName  FROM intakeoutputchart ic ");
            sbnew.Append(" INNER JOIN employee_master em ON em.EmployeeId=ic.EntryBy ");
            sbnew.Append(" WHERE ic.IsActive=1 and ic.PatientID='" + Pid + "' and ic.TransactionID='" + Tid + "' ");
            if (Typ==0)
            {
                sbnew.Append(" and concat(date(ic.DATE),' ',time(ic.TIME))>='" + TodayDateTime + "'   ");
            }
            if (Typ == 1)
            {
                sbnew.Append(" and concat(date(ic.DATE),' ',time(ic.TIME))>='" + YesterdayDateTime + "' and concat(date(ic.DATE),' ',time(ic.TIME))<'" + TodayDateTime + "'   ");
            }
           

            //sbnew.Append("  order by date(ic.DATE) desc");
            sbnew.Append("  order by concat(date(ic.DATE),' ',ic.TIME) desc");
            DataTable dt = StockReports.GetDataTable(sbnew.ToString());
            if (dt.Rows.Count > 0)
            {
                if (Typ==2)
                {
             
 
                    double Final_Infused = Convert.ToDouble(dt.Compute("SUM(Infused)", string.Empty));
                    double Final_POAmount = Convert.ToDouble(dt.Compute("SUM(POAmount)", string.Empty));
                    double Final_TubeAmount = Convert.ToDouble(dt.Compute("SUM(TubeAmount)", string.Empty));
                    double Final_Vomit = Convert.ToDouble(dt.Compute("SUM(Vomit)", string.Empty));
                    double Final_Stool = Convert.ToDouble(dt.Compute("SUM(Stool)", string.Empty));
                    double Final_NG = Convert.ToDouble(dt.Compute("SUM(NG)", string.Empty));
                    double Final_Urine = Convert.ToDouble(dt.Compute("SUM(Urine)", string.Empty));
                    double Final_Drain1 = Convert.ToDouble(dt.Compute("SUM(Drain1)", string.Empty));
                    double Final_Drain2 = Convert.ToDouble(dt.Compute("SUM(Drain2)", string.Empty));
                    double Final_Drain3 = Convert.ToDouble(dt.Compute("SUM(Drain3)", string.Empty));
                    double inOutDiff = (Final_Infused + Final_POAmount + Final_TubeAmount) - (Final_Vomit + Final_Stool + Final_NG + Final_Urine + Final_Drain1 + Final_Drain2 + Final_Drain3);
                    dt.Rows.Add(0, "", 0, "", "", "", 0, "Total", Final_Infused, "", Final_POAmount, "", Final_TubeAmount, Final_Vomit, Final_Stool, Final_NG, Final_Urine, Final_Drain1, Final_Drain2, Final_Drain3, inOutDiff, "");

                }
                if (Typ == 1)
                {


                    double Final_Infused = Convert.ToDouble(dt.Compute("SUM(Infused)", string.Empty));
                    double Final_POAmount = Convert.ToDouble(dt.Compute("SUM(POAmount)", string.Empty));
                    double Final_TubeAmount = Convert.ToDouble(dt.Compute("SUM(TubeAmount)", string.Empty));
                    double Final_Vomit = Convert.ToDouble(dt.Compute("SUM(Vomit)", string.Empty));
                    double Final_Stool = Convert.ToDouble(dt.Compute("SUM(Stool)", string.Empty));
                    double Final_NG = Convert.ToDouble(dt.Compute("SUM(NG)", string.Empty));
                    double Final_Urine = Convert.ToDouble(dt.Compute("SUM(Urine)", string.Empty));
                    double Final_Drain1 = Convert.ToDouble(dt.Compute("SUM(Drain1)", string.Empty));
                    double Final_Drain2 = Convert.ToDouble(dt.Compute("SUM(Drain2)", string.Empty));
                    double Final_Drain3 = Convert.ToDouble(dt.Compute("SUM(Drain3)", string.Empty));
                    double inOutDiff = (Final_Infused + Final_POAmount + Final_TubeAmount) - (Final_Vomit + Final_Stool + Final_NG + Final_Urine + Final_Drain1 + Final_Drain2 + Final_Drain3);
                    
                    dt.Rows.Add(0, "", 0, "", "", "", 0, "Total", Final_Infused, "", Final_POAmount, "", Final_TubeAmount, Final_Vomit, Final_Stool, Final_NG, Final_Urine, Final_Drain1, Final_Drain2, Final_Drain3, inOutDiff, "");

                }


                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

        }
    }

}