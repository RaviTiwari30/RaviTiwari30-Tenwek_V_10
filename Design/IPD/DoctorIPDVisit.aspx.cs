using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;


public partial class Design_IPD_DoctorIPDVisit : System.Web.UI.Page
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
            if (Resources.Resource.AllowFiananceIntegration == "1")//
            {
                if (AllLoadData_IPD.CheckDataPostToFinance(TransID) > 0)
                {
                    string Msga = "Patient's Final Bill Already Posted To Finance...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msga);
                }
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
                        if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0" && auth == 0)
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
            }
            AllLoadData_IPD.fromDatetoDate(TID, txtVisitDate, txtVisitDate, calendarVisitOn, calendarVisitOn);
            //txtVisitDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BindDoctor();
            BindPatientDetails();
            BindVisitType();
            BindPatientVisitDetails(TID);
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

            if (Convert.ToString(Session["RoleID"]).ToUpper() == "323")
            {
                string doctorid = StockReports.ExecuteScalar("select ifnull(DoctorID,'') from doctor_employee where Employee_id='" + Session["ID"].ToString() + "'");
                if (doctorid != string.Empty)
                {
                    ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue(doctorid));
                    ddlDoctor.Enabled = false;
                }
            }
            else
            {
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


    private void BindVisitType()
    {

        DataTable dt = StockReports.GetDataTable("SELECT f.SubCategoryID,f.Name FROM f_Subcategorymaster f INNER JOIN f_configrelation c ON c.CategoryID=f.CategoryID WHERE c.ConfigID=1 AND f.Active=1 ");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlVisitType.DataSource = dt;
            ddlVisitType.DataTextField = "Name";
            ddlVisitType.DataValueField = "SubCategoryID";
            ddlVisitType.DataBind();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string GetConsultationRate(string referencecode, string panelID, string doctorID, string transactionID, string roomTypeID, string subCategoryID, string visitDate)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sb = new StringBuilder();
        string msg = "";
        var isAlready = excuteCMD.GetDataTable("SELECT ItemID,DATE(EntryDate)DATE FROM f_ledgertnxdetail ltd  WHERE ConfigID=1 AND ltd.TransactionID=@transactionID AND DATE(ltd.EntryDate)=@entryDate AND ltd.DoctorID=@DoctorId  AND IsVerified=1 ", CommandType.Text, new
        {
            transactionID = transactionID,
            entryDate = Util.GetDateTime(visitDate).ToString("yyyy-MM-dd"),
            DoctorId = doctorID
        });
       
        //if (isAlready.Rows.Count == 0)
        //{
        //    if (subCategoryID != "LSHHI72")
        //    {
        //        isAlready = excuteCMD.GetDataTable("SELECT ItemID,DATE(EntryDate)DATE FROM f_ledgertnxdetail ltd  WHERE ConfigID=1 AND ltd.SubCategoryID=@SubCategoryID AND ltd.TransactionID=@transactionID AND ltd.DoctorID=@DoctorId  AND IsVerified=1 ", CommandType.Text, new
        //       {
        //           transactionID = transactionID,
        //           DoctorId = doctorID,
        //           SubCategoryID = subCategoryID
        //       });
        //        msg = "This Visit Type Already Added.";
        //    }
        //}
        //else
        //    msg = "Already Visit Added On this Date.";
        //if (isAlready.Rows.Count > 0)
        //{
        //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = msg });
        //}
        sb.Append(" SELECT DateOfAdmit,DateOfDischarge,IF(STATUS='out',DATEDIFF(DateOfDischarge,DateOfAdmit),DATEDIFF(CURDATE(),DateOfAdmit))+1 ts,NAME,IFNULL(SubCategoryID,'')SubCategoryID,IFNULL(ItemID,'')ItemID,IFNULL(Rate,0)Rate,IFNULL(rateListID,0)rateListID,IFNULL(itemcode,'')itemcode ,ScaleOfCost  FROM patient_medical_history ich INNER JOIN (  ");//ipd_case_history
        sb.Append("   SELECT im.ItemID,im.SubcategoryID,sm.Name,IFNULL(Rate,0)Rate,IFNULL(rli.ID,0)rateListID,rli.itemcode,CAST(@transactionID AS CHAR) TransactionID,IFNULL(ScaleOfCost,0)ScaleOfCost FROM    f_itemmaster im ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubcategoryID=im.subcategoryID      INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.CategoryID ");
        sb.Append(" INNER JOIN   f_configrelation cf ON cf.CategoryID=cm.CategoryID ");
        sb.Append(" LEFT OUTER JOIN f_ratelist_ipd rli ON rli.itemID=im.ItemID    AND PanelID=@panelID AND IpdCaseTypeID=@roomTypeID  AND IsCurrent=1 AND CentreID=@CentreID");
        sb.Append(" WHERE  cf.ConfigID=1 AND sm.Active=1  and im.isActive=1 AND im.Type_ID=@doctorID  AND sm.SubcategoryID=@subCategoryID    )r ON ich.TransactionID=r.TransactionID ORDER BY SubcategoryID");
        var data = new
        {
            panelID = referencecode,
            doctorID = doctorID,
            transactionID = transactionID,
            roomTypeID = roomTypeID,
            subCategoryID = subCategoryID,
            CentreID = HttpContext.Current.Session["CentreID"].ToString()
        };
        var dataTable = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, data);
        var s = excuteCMD.GetRowQuery(sb.ToString(), data);
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable,s=s });
    }

    public void BindPatientVisitDetails(string transactionID)
    {
        string doctorid = string.Empty;
        if (Convert.ToString(Session["RoleID"]).ToUpper() == "323")
        {
             doctorid = StockReports.ExecuteScalar("select ifnull(DoctorID,'') from doctor_employee where Employee_id='" + Session["ID"].ToString() + "'");
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ltd.Remarks, DATE_FORMAT(EntryDate,'%d-%b-%Y')`VisitDate`,ltd.ItemName `DoctorName` ,sb.name `VisitType`,round(ltd.Amount,4)Amount  ");
        sb.Append("FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sb ON sb.SubCategoryID=ltd.SubCategoryID WHERE ConfigID=1 ");
        sb.Append("AND ltd.TransactionID='" + transactionID + "' AND IsVerified=1 ");
        if (doctorid != string.Empty)
        {
            sb.Append("AND ltd.DoctorID='"+ doctorid.Trim() +"' ");
        }
        sb.Append("ORDER BY EntryDate");
        var dataTable = StockReports.GetDataTable(sb.ToString());
        grdPatientVisitDetails.DataSource = dataTable;
        grdPatientVisitDetails.DataBind();
    }



}