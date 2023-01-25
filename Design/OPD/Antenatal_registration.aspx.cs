using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

public partial class Design_OPD_BillRegister : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            //string LabNo = Convert.ToString(Request.QueryString["LedgerTransactionNo"]);
            //string Type = Convert.ToString(Request.QueryString["LabType"]);
            //ViewState["TID"] = Request.QueryString["TID"].ToString();
            //ViewState["PID"] = Request.QueryString["PID"].ToString();
            //ViewState["Gender"] = Request.QueryString["Gender"].ToString();
            //ViewState.Add("Type", Type);
            //ViewState.Add("LabNo", LabNo);
            //ViewState["UserID"] = Session["ID"].ToString();
            //ViewState["ID"] = Session["ID"].ToString();
            //ViewState["LoginName"] = Session["LoginName"].ToString();
            BindRelation();
            BindRadiologist();
            // BindInvestigation();
            //GetData(ViewState["PID"].ToString());
            //  int Check = CheckIsUSGPatient();

            //if (ViewState["Gender"].ToString() != "Female")
            //{
            //    lblMsg.Text = "This page is only for female patients";
            //    ddlInvestigation.Visible = false;
            //    ddlIndication.Visible = false;
            //    ddlRadiologist.Visible = false;
            //    ddlRelation.Visible = false;
            //    ddlUSGN.Visible = false;
            //    txtNumFemaleChild.Visible = false;
            //    txtNumMalechild.Visible = false;
            //    txtWeeks.Visible = false;
            //    btnSave.Visible = false;
            //}
            //else if (Check == 0)
            //{
            //    lblMsg.Text = "USG not found";
            //    ddlInvestigation.Visible = false;
            //    ddlIndication.Visible = false;
            //    ddlRadiologist.Visible = false;
            //    ddlRelation.Visible = false;
            //    ddlUSGN.Visible = false;
            //    txtNumFemaleChild.Visible = false;
            //    txtNumMalechild.Visible = false;
            //    txtWeeks.Visible = false;
            //    btnSave.Visible = false;
            //}
            txtLMP.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtEDD.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        
        FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

        txtLMP.Attributes.Add("readOnly", "true");
        txtEDD.Attributes.Add("readOnly", "true");
        FrmDate.Attributes.Add("readOnly", "true");
        ToDate.Attributes.Add("readOnly", "true");
    }

    public void GetData(string patientID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pd.LMP, pd.`Indication`,pd.`USGN`,pd.`WeekOFPreg`,(SELECT im.Name FROM investigation_master im WHERE im.Investigation_Id=pd.`Investigation_ID`) Investigation, ");
        sb.Append(" (SELECT CONCAT(dm.Title,' ',dm.Name) Doctor FROM doctor_master dm WHERE dm.DoctorID=pd.`DoctorID`) Doctor, pd.`NoOfFemaleChild`,pd.`NoOfMaleChild`,pd.`Investigation_ID`,pd.`DoctorID`,pd.`Relation` ");
        sb.Append(" FROM pregnancy_details pd WHERE PatientID='" + patientID + "' AND TransactionID='" + ViewState["TID"] + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            // btnSave.Visible = false;
            foreach (DataRow dr in dt.Rows)
            {
                txtWeeks.Text = dr["WeekOFPreg"].ToString();
                txtNumMalechild.Text = dr["NoOfMaleChild"].ToString();
                txtNumFemaleChild.Text = dr["NoOfFemaleChild"].ToString();
               // ddlRadiologist.SelectedValue = dr["DoctorID"].ToString();
                ddlInvestigation.SelectedValue = dr["Investigation_ID"].ToString();
                ddlIndication.SelectedValue = dr["Indication"].ToString();
                ddlRelation.SelectedValue = dr["Relation"].ToString();
                ddlUSGN.SelectedValue = dr["USGN"].ToString();
                txtLMP.Text = dr["LMP"].ToString();
            }
        }
        else
        {
            //btnUpdate.Visible = false;
        }
    }

    private void BindRelation()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT rm.Relationship, rm.ID FROM relationship_master rm WHERE rm.IsActive=1");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ddlRelation.DataSource = dt;
            ddlRelation.DataValueField = "ID";
            ddlRelation.DataTextField = "Relationship";
            ddlRelation.DataBind();
            // ddlRelation.Items.Insert(0, "ALL");
        }
    }

    private void BindRadiologist()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name) NAME FROM doctor_master dm WHERE Designation='RADIOLOGY'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ddlRadiologist.DataSource = dt;
            ddlRadiologist.DataValueField = "DoctorID";
            ddlRadiologist.DataTextField = "NAME";
            ddlRadiologist.DataBind();
            ddlRadiologist.Items.Insert(0, "-- Select --");
        }
    }

    private void BindInvestigation()
    {
        StringBuilder sb = new StringBuilder();
        string Type = ViewState["Type"].ToString();

        if (Type == "OPD")
        {
            sb.Append("select pli.ID,IF(pli.Approved=1,'false','true')Approved,ifnull(ApprovedBy,'')ApprovedBy,pli.LabInvestigationOPD_ID as LabInvestigation_ID,date_format(pli.Date,'%d-%b-%y')Date,pli.Test_ID,pli.Result_Flag,");
            sb.Append(" pli.Investigation_ID,Im.Name as IName,Im.ReportType,pli.IsCritical,pli.CriticalDoctor from patient_labinvestigation_opd pli inner join investigation_master im on pli.Investigation_ID=im.Investigation_Id INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID ");
            sb.Append(" where pli.LedgerTransactionNo='" + Convert.ToString(ViewState["LabNo"]) + "' and im.ReportType=5 AND cr.RoleID='" + Session["RoleID"].ToString() + "' ");
        }
        else
        {
            sb.Append("select pli.ID,IF(pli.Approved=1,'false','true')Approved,ifnull(ApprovedBy,'')ApprovedBy,pli.LabInvestigationIPD_ID as LabInvestigation_ID,date_format(pli.Date,'%d-%b-%y')Date,pli.Test_ID,pli.Result_Flag,");
            sb.Append(" pli.Investigation_ID,Im.Name as IName,Im.ReportType,pli.IsCritical,pli.CriticalDoctor from patient_labinvestigation_ipd pli inner join investigation_master im on pli.Investigation_ID=im.Investigation_Id  INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID");
            sb.Append(" where pli.LedgerTransactionNo='" + Convert.ToString(ViewState["LabNo"]) + "' and im.ReportType=5 AND cr.RoleID='" + Session["RoleID"].ToString() + "'");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ddlInvestigation.DataSource = dt;
            ddlInvestigation.DataValueField = "Investigation_ID";
            ddlInvestigation.DataTextField = "IName";
            ddlInvestigation.DataBind();
            ddlInvestigation.Items.Insert(0, "-- Select --");
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        //if (ViewState["Type"] != null)
        //{
        string Type = " ";// ViewState["Type"].ToString();
        string usgtest = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);






        string str = "INSERT INTO Pregnancy_details(WeekOFPreg,Indication,USGN,Relation,NoOfMaleChild,NoOfFemaleChild,TransactionID,LedgertransactionNo,Investigation_ID,PatientID,USGTest,CreatedBy,CreatedDate,TYPE,DoctorID,LMP,EDD) VALUES('" + txtWeeks.Text.Trim() + "','" + ddlIndication.SelectedValue + "','" + ddlUSGN.SelectedValue + "','" + ddlRelation.SelectedValue + "','" + txtNumMalechild.Text.Trim() + "','" + txtNumFemaleChild.Text.Trim() + "','" + ViewState["TID"].ToString() + "','" + Convert.ToString(ViewState["LabNo"]) + "','" + ddlInvestigation.SelectedValue + "','" + ViewState["PID"].ToString() + "','" + usgtest + "','" + ViewState["ID"].ToString() + "',NOW(),'" + Type + "','','" + Util.GetDateTime(txtLMP.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtEDD.Text).ToString("yyyy-MM-dd") + "')";
        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

        tnx.Commit();
        tnx.Dispose();
        con.Close();
        con.Dispose();
        // lblMsg.Text = "Record Saved";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved...');", true);
        Response.Redirect(Request.RawUrl, true);
        //}
    }

    private int CheckIsUSGPatient()
    {
        StringBuilder sb = new StringBuilder();
        string Type = ViewState["Type"].ToString();
        //if (Type == "OPD")
        //{
        //    sb.Append("SELECT COUNT(*) FROM f_ledgertnxdetail WHERE LedgerTransactionNo='" + Convert.ToString(ViewState["LabNo"]) + "' AND SubCategoryID='LSHHI266'");
        //}

        sb.Append("SELECT COUNT(*) FROM f_ledgertnxdetail WHERE LedgerTransactionNo='" + Convert.ToString(ViewState["LabNo"]) + "' AND SubCategoryID IN ('LSHHI425','LSHHI424','LSHHI423')");

        int Count = Util.GetInt(StockReports.ExecuteScalar(sb.ToString()));

        return Count;
    }

  
    [WebMethod]
    public static string onupdateselect(string ID)
    {
        string sql = "";

        sql += " SELECT pd.`Id`,pd.`WeekOFPreg`,pd.`Indication`,pd.`USGN`,pd.`Relation`,pd.`NoOfMaleChild`,pd.`NoOfFemaleChild`,pd.`TransactionID`,";
        sql += " pd.`LedgertransactionNo`,pd.`Investigation_ID`,pd.`PatientID`,pd.`CreatedBy`,pd.`CreatedDate`,pd.`Type`,pd.`DoctorID`,DATE_FORMAT(pd.`LMP`,'%d-%b-%y') LMP,  DATE_FORMAT(pd.`EDD`,'%d-%b-%y') EDD,  ";
        sql += " pd.Trimester,pd.MTP FROM Pregnancy_details  pd where pd.id=" + ID + "   ";



        //sql += " SELECT * FROM Pregnancy_details where id=" + ID + " ";
        DataTable dt = StockReports.GetDataTable(sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    public static string getpatientdetails(string PatientID)
    {
        string sql = "";

        sql += " SELECT pm.PatientID,CONCAT(pm.title,' ',pm.pname) patientname,pm.age,pm.gender,pm.mobile,CONCAT(pm.relation,' ', pm.relationname)Relation, ";
        sql += " lt.LedgerTransactionNo ,lt.`TransactionID`  ,lt.`Date`,pmh.`DoctorID`,pmh.`Type` ";
        sql += " FROM patient_master pm INNER JOIN `f_ledgertransaction` lt ON pm.PatientID=lt.`PatientID` ";
        sql += " INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=lt.`TransactionID` ";
        sql += " WHERE pm.PatientID='" + PatientID.Trim() + "' ORDER BY lt.`Date` DESC LIMIT 1   ";

        DataTable dt = StockReports.GetDataTable(sql);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string getregistrationpatientdetails(string fdate, string tdate)
    {
        string sql = "";
        sql += " SELECT  pd.id, pm.PatientID,CONCAT(pm.title,' ',pm.pname) patientname,pm.age,pm.gender,pm.mobile,CONCAT(pm.relation,' ', pm.relationname)Relation,pd.type";
        sql += " FROM patient_master pm INNER JOIN Pregnancy_details pd ON pm.`PatientID`=pd.PatientID ";
        sql += "  WHERE pd.ISAntenatalPatient=1  ";
        sql += "AND DATE(pd.CreatedDate)>='" + Util.GetDateTime(fdate).ToString("yyyy-MM-dd") + "' AND DATE(pd.CreatedDate)<='" + Util.GetDateTime(tdate).ToString("yyyy-MM-dd") + "' ";


        DataTable dt = StockReports.GetDataTable(sql);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public static string Save_Pregnancy_details(Pregnancy_details pregnancyDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        int Count = 0;
         int ANEID=0;
        try
        {
            Count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM Pregnancy_details WHERE TransactionID='" + pregnancyDetails.TransactionID + "' AND  LedgertransactionNo='" + pregnancyDetails.LedgertransactionNo + "' AND PatientID='" + pregnancyDetails.PatientID + "' AND ISAntenatalPatient=1 "));

            if (Count == 0) { 


            string USERID = HttpContext.Current.Session["ID"].ToString();
            var sqlcmd = "INSERT INTO Pregnancy_details(WeekOFPreg,Indication,USGN,Relation,NoOfMaleChild,NoOfFemaleChild,TransactionID,LedgertransactionNo,Investigation_ID,PatientID,USGTest,CreatedBy,CreatedDate,TYPE,DoctorID,LMP,EDD,ISAntenatalPatient,Trimester,MTP)"
                         + "VALUES(@WeekOFPreg,@Indication,@USGN,@Relation,@NoOfMaleChild,@NoOfFemaleChild,@TransactionID,@LedgertransactionNo,@Investigation_ID,@PatientID,@USGTest,'" + USERID + "',NOW(),@TYPE,@DoctorID,@LMP,@EDD,1,@Trimester,@MTP); SELECT @@identity; ";
            ANEID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlcmd, CommandType.Text, pregnancyDetails));
            }
            if (ANEID > 0)
            {
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Recor save successfully" });
            }
            else if (Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Duplicate Entry !!" });
            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Save !!" });
            }

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    public static string Update_Pregnancy_details(Pregnancy_details pregnancyDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string USERID = HttpContext.Current.Session["ID"].ToString();


            var sqlcmd = "UPDATE Pregnancy_details SET WeekOFPreg=@WeekOFPreg,Indication=@Indication,USGN=@USGN,Relation=@Relation,NoOfMaleChild=@NoOfMaleChild,NoOfFemaleChild=@NoOfFemaleChild,TransactionID=@TransactionID,LedgertransactionNo=@LedgertransactionNo,Investigation_ID=@Investigation_ID,PatientID=@PatientID,USGTest=@USGTest,UpdatedBy='" + USERID + "',UpdatedDate=now(),TYPE=@TYPE,DoctorID=@DoctorID,LMP=@LMP,EDD=@EDD,Trimester=@Trimester,MTP=@MTP where ID=@ID";

            Util.GetString(excuteCMD.ExecuteScalar(tnx, sqlcmd, CommandType.Text, pregnancyDetails));

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Updated Sucessfully " });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }



    public class Pregnancy_details
    {
        public string WeekOFPreg { get; set; }
        public string Indication { get; set; }
        public string USGN { get; set; }
        public string Relation { get; set; }
        public string NoOfMaleChild { get; set; }
        public string NoOfFemaleChild { get; set; }
        public string TransactionID { get; set; }
        public string LedgertransactionNo { get; set; }
        public string Investigation_ID { get; set; }
        public string PatientID { get; set; }
        public string USGTest { get; set; }
        public string TYPE { get; set; }
        public string DoctorID { get; set; }
        public System.DateTime LMP { get; set; }
        public System.DateTime EDD { get; set; }
        public string ID { get; set; }
        public string Trimester { get; set; }
        public string MTP { get; set; }

    }
}
