using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_IPD_DocVisitRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            LbltID.Text = Request.QueryString["TransactionID"].ToString();
            AllQuery AQ = new AllQuery();
            DataTable dtDischarge = AQ.GetPatientDischargeStatus(TID);
            DataTable dt = AQ.GetPatientAdjustmentDetails(TID);
            
            if (dt != null && dt.Rows.Count > 0)
            {
                int auth = AllLoadData_IPD.IPDBillAuthorization(Session["ID"].ToString(), Util.GetInt(Session["RoleID"].ToString()));
                if (dt.Rows[0]["IsBillFreezed"].ToString() == "1" && auth == 0)
                {
                    string Msg = "Patient's Bill has been freezed. No Room Shifting can be possible...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                {
                    string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No Room Shifting can be possible...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["BillNo"].ToString().Trim() != "")
                {
                    string Msg = "Patient's Final Bill has been Generated. No Room can be Sifted Now..";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy"); 
            calucDate.StartDate = DateTime.Now;
           // AllLoadData_IPD.fromDatetoDate(Request.QueryString["Transaction_ID"].ToString(), txtDate, toDate, calucDate, caltoDate);                        
            string SelectDate = System.DateTime.Now.ToString("yyyy-MM-dd");
            BindPatientDetails(TID);
            BindDoctor(SelectDate);
        }
        txtDate.Attributes.Add("readOnly", "true");
        toDate.Attributes.Add("readOnly", "true");
    }

    public void BindDoctor(string selecteddate)
    {
        string getalreadysetdocvisit = "SELECT Doctorid FROM ipd_Patient_DocVisitRequest WHERE transactionid='" + ViewState["TransactionID"] + "' AND Requested_VisitDate='" + selecteddate + "' AND isVisit_Done=0 ";
        DataTable dtgetdoc = new DataTable();
        dtgetdoc = StockReports.GetDataTable(getalreadysetdocvisit);
        
        string str = "Select CONCAT(Title,' ',Name)Name,DoctorID from doctor_master where IsActive = 1 and DoctorID != '" + ViewState["DoctorID"] + "'  order by Name";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            cblDoctor.DataSource = dt;
            cblDoctor.DataTextField = "Name";
            cblDoctor.DataValueField = "DoctorID";
            cblDoctor.DataBind();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                for (int j = 0; j < dtgetdoc.Rows.Count; j++)
                {
                    if (dt.Rows[i]["Doctorid"].ToString() == dtgetdoc.Rows[j]["DoctorID"].ToString())
                    {
                        cblDoctor.Items[i].Selected = true;
                        break;
                    }
                }
            }
        }
        else
        {
            cblDoctor.DataSource = null;
            cblDoctor.DataBind();
        }
    }

    protected void txtDate_TextChanged(object sender, EventArgs e)
    {        
        string startDate = string.Empty;
        startDate = Util.GetDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd");       
        BindDoctor(startDate);
    }


    private void BindPatientDetails(string TransactionID)
    {
        string str = "SELECT pmh.PatientID,pmh.TransactionID,pmh.patient_type,date_format(pmh.DateOfAdmit,'%d-%b-%Y')as DateOfAdmit,DATE_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')TimeOfAdmit,pmh.DoctorID,pmh.PanelID,pmh.ScheduleChargeID, " +
                      "(SELECT NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)CurrentDoctor" +
                     " FROM patient_medical_history " +
                    " WHERE pmh.TransactionID='" + TransactionID + "'and pmh.Status='IN'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ViewState["DoctorID"] = dt.Rows[0]["DoctorID"].ToString();
        }
        
    }

    protected void btnDoctorRequest_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            string VisitDate = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");


            string updatevisit = "Update ipd_Patient_DocVisitRequest set IsVisit_Done=3,IsVisitDone_By='" + Util.GetString(ViewState["ID"]) + "',IsVisit_DoneDate='" + System.DateTime.Now.ToString("yyyy-MM-dd hh-mm-ss") + "' where Requested_VisitDate='" + VisitDate + "' And Transaction_id='" +ViewState["TransactionID"]+"' AND IsVisit_Done= 0";
            StockReports.ExecuteDML(updatevisit);

                 for (int i = 0; i < cblDoctor.Items.Count; i++)
                 {
                     if (cblDoctor.Items[i].Selected == true)
                     {
                         string str = "insert into ipd_Patient_DocVisitRequest (Transactionid,DoctorID,Requested_VisitDate,IsVisit_Done,RequestedBy,EntryDate,centerid) values('" + ViewState["TransactionID"] + "','" + cblDoctor.Items[i].Value + "','" + VisitDate + "','0','" + Util.GetString(ViewState["ID"]) + "','" + System.DateTime.Now.ToString("yyyy-MM-dd hh-mm-ss") + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')";
                         MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                     }

                 }
                 tranX.Commit();
                 lblmsg.Text = "Record Saved Successfully";
                 BindDoctor(VisitDate);
        }
        catch (Exception ex)
        {
            tranX.Rollback();

            lblmsg.Text = "Error occurred, Please contact administrator";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}