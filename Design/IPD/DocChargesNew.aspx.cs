using System;
using System.Data;


public partial class Design_IPD_DocChargesNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        

        if (!IsPostBack)
        {
            string TransID = "";
            string iUserID = "";
            string TID = "";
            if (Request.QueryString["TransactionID"] != null)
            {
                TransID = Request.QueryString["TransactionID"].ToString();
                iUserID = Session["ID"].ToString();
                ViewState["TID"] = TransID;
                lbluserID.Text = Session["ID"].ToString();
                 TID = Request.QueryString["TransactionID"].ToString();
            }
            AllQuery AQ = new AllQuery();
            // Modify on 12-10-2016
            // DataTable dt = AQ.d_GetPatientAdjustmentDetails(TID);
            DataTable dt = AQ.GetPatientAdjustmentDetails(TID);
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;

            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsBillFreezed"].ToString() == "1")
                {
                    DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                    if ((dt.Rows[0]["IsBillFreezed"].ToString() == "1") && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
                    {
                        string Msg = "";
                        int auth = AllLoadData_IPD.IPDBillAuthorization(Session["ID"].ToString(), Util.GetInt(Session["RoleID"].ToString()));
                        if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0" && auth==0)
                        {
                            Msg = "You Are Not Authorised To AMEND IPD Bills...";
                            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        }
                        else if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "1" && dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                        {
                            Msg = "Patient's Final Bill has been Closed for Further Updating...";
                            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        }
                    }
                    else if (dt.Rows[0]["IsBillFreezed"].ToString().Trim() == "1" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
                    {
                        string Msg = "";
                        Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                        Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                    }
                }
                if (dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                {
                    string Msg = "";
                    Msg = "Patient's Final Bill has been Closed for Further Updating...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                }
            }
            BindDoctor();
            BindPatientDetails();
            if (Session["RoleID"].ToString() != "52")
            {
                btnSave.Visible = true;
            }
            else
            {
                btnSave.Visible = false;
            }
        }

        lblMsg.Text = "";
    }
    private void BindPatientDetails()
    {


        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetPatientIPDInformation("", ViewState["TID"].ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblPatientID.Text = Convert.ToString(dt.Rows[0]["PatientID"]);
            lblTransactionNo.Text = Convert.ToString(dt.Rows[0]["TransactionID"].ToString());
            lblCaseTypeID.Text = Convert.ToString(dt.Rows[0]["IPDCaseTypeID"].ToString());
            lblReferenceCode.Text = Convert.ToString(dt.Rows[0]["ReferenceCode"].ToString());
            lblPanelID.Text = Convert.ToString(dt.Rows[0]["PanelID"].ToString());
            ViewState["ScheduleChargeID"] = dt.Rows[0]["ScheduleChargeID"].ToString();
            lblPatientType.Text = Convert.ToString(dt.Rows[0]["PatientType"]);
            lblRoomID.Text = dt.Rows[0]["RoomID"].ToString();
        }
        else
            lblMsg.Text = "Patient Record and Room Not Available";
    }
    private void BindDoctor()
    {

        DataTable dt = AllLoadData_IPD.dtbindDoctor();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDoctor.DataSource = dt;
            ddlDoctor.DataTextField = "Name";
            ddlDoctor.DataValueField = "DoctorID";
            ddlDoctor.DataBind();

                DataTable dtdoc = StockReports.GetDataTable("select DoctorID from patient_medical_history where TransactionID ='" + ViewState["TID"].ToString() + "'");

               

                if (dtdoc != null && dtdoc.Rows.Count > 0)
                {
                    string DoctorID = Convert.ToString(dtdoc.Rows[0]["DoctorID"]);
                    if (DoctorID != string.Empty)
                        ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue(DoctorID));
                }
            }
        
    }

}