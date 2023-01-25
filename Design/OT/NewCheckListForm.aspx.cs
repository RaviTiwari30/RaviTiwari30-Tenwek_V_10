using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OT_NewCheckListForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Transaction_ID.Text = Request.QueryString["TID"].ToString();
            PatientId.Text = Request.QueryString["PatientId"].ToString();
            App_ID.Text = Request.QueryString["App_ID"].ToString();
           // OTBookingID.Text = Request.QueryString["OTBookingID"].ToString();
           // OTNumber.Text = Request.QueryString["OTNumber"].ToString();
           // lblIpdNo.Text = Transaction_ID.Text.ToString().Replace("ISHHIA", "");
            lblIpdNo.Text = StockReports.ExecuteScalar("SELECT TransNo FROM patient_medical_history WHERE TransactionID='" + Transaction_ID.Text + "' AND Centreid='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");

            if (App_ID.Text.ToString()=="PrintOtForm")
            {
                btnsavesurgery.Visible = false;  
            }
        }
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SavessclTransaction(sscl_form sscldata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            excuteCMD.DML(Tranx, con, " UPDATE sscl_transaction_form SET UpdateBy=@EntryBy,UpdateDae=NOW(),IsActive=@IsActive WHERE TransactionId=@TransactionId", CommandType.Text, new
            {

                TransactionId = sscldata.Tid,
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                IsActive = 0,

            });

            string Query = "INSERT INTO sscl_transaction_form(PatientId,TransactionId,h1,h2,h3,h4,h5,h6,h7,h8,h9,nameh1,sexh1,ageh1,dobh1,fullNameh2,sexh2,ageh2,mrnoh2,digh2,surh2,With4,oprh4,ringh9,beadsh9,hph9,egh9,rmh9,hah9,monh9,wwh9,wigh9,ugh9,aeh9,EntryBy,EntryDate,IsActive)";
            Query += "VALUE(@PatientId,@TransactionId,@h1,@h2,@h3,@h4,@h5,@h6,@h7,@h8,@h9,@nameh1,@sexh1,@ageh1,@dobh1,@fullNameh2,@sexh2,@ageh2,@mrnoh2,@digh2,@surh2,@With4,@oprh4,@ringh9,@beadsh9,@hph9,@egh9,@rmh9,@hah9,@monh9,@wwh9,@wigh9,@ugh9,@aeh9,@EntryBy,NOW(),@IsActive)";

            excuteCMD.DML(Tranx, con, Query, CommandType.Text, new
              {
                  PatientId = sscldata.Pid,
                  TransactionId = sscldata.Tid,
                  h1 = sscldata.H1,
                  h2 = sscldata.H2,
                  h3 = sscldata.H3,
                  h4 = sscldata.H4,
                  h5 = sscldata.H5,
                  h6 = sscldata.H6,

                  h7 = sscldata.H7,
                  h8 = sscldata.H8,
                  h9 = sscldata.H9,
                  nameh1 = sscldata.NameH1,
                  sexh1 = sscldata.SexH1,
                  ageh1 = sscldata.AgeH1,
                  dobh1 = sscldata.DobH1,
                  fullNameh2 = sscldata.FullNameH2,
                  sexh2 = sscldata.SexH2,
                  ageh2 = sscldata.AgeH2,
                  mrnoh2 = sscldata.MrNoH2,
                  digh2 = sscldata.DigH2,
                  surh2 = sscldata.SurH2,
                  With4 = sscldata.WitH4,
                  oprh4 = sscldata.OprH4,
                  ringh9 = sscldata.RingH9,
                  beadsh9 = sscldata.BeadsH9,
                  hph9 = sscldata.HpH9,
                  egh9 = sscldata.EgH9,
                  rmh9 = sscldata.RmH9,
                  hah9 = sscldata.Ha9,
                  monh9 = sscldata.MonH9,
                  wwh9 = sscldata.WWH9,
                  wigh9 = sscldata.WigH9,
                  ugh9 = sscldata.UgH9,
                  aeh9 = sscldata.AeH9,
                  EntryBy = HttpContext.Current.Session["ID"].ToString(),
                  IsActive = 1,

              });

            Tranx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });


        }
        catch (Exception)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Error Occured ! Contact To Administrator" });

            throw;
        }


    }


    [WebMethod]
    public static string EditSurgerySafety(string Tid)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT * FROM  sscl_transaction_form  sc WHERE sc.TransactionId='" + Tid + "' AND sc.IsActive=1");
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" });

        }
       
    }



    public class sscl_form
    {
        public int Id { get; set; }
        public string Pid { get; set; }
        public string Tid { get; set; }
        public int H1 { get; set; }
        public int H2 { get; set; }
        public int H3 { get; set; }
        public int H4 { get; set; }
        public int H5 { get; set; }
        public int H6 { get; set; }
        public int H7 { get; set; }
        public int H8 { get; set; }
        public int H9 { get; set; }

        public int NameH1 { get; set; }
        public int AgeH1 { get; set; }
        public int SexH1 { get; set; }
        public int DobH1 { get; set; }


        public int FullNameH2 { get; set; }
        public int AgeH2 { get; set; }
        public int SexH2 { get; set; }
        public int MrNoH2 { get; set; }
        public int DigH2 { get; set; }
        public int SurH2 { get; set; }

        public int WitH4 { get; set; }
        public int OprH4 { get; set; }

        public int RingH9 { get; set; }
        public int BeadsH9 { get; set; }
        public int HpH9 { get; set; }
        public int EgH9 { get; set; }
        public int RmH9 { get; set; }
        public int Ha9 { get; set; }
        public int MonH9 { get; set; }
        public int WWH9 { get; set; }
        public int WigH9 { get; set; }
        public int UgH9 { get; set; }
        public int AeH9 { get; set; }

        public string EntryBy { get; set; }

        public DateTime EntryDate { get; set; }

    }

}