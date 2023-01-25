using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CPOE_Investigation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Convert.ToString(Request.QueryString["TID"]) != null)
            {
                ViewState["TID"] = Convert.ToString(Request.QueryString["TID"]);
                ViewState["PatientID"] = Convert.ToString(Request.QueryString["PID"]);
                if (Request.QueryString["LnxNo"] != null)
                    ViewState["LnxNo"] = Convert.ToString(Request.QueryString["LnxNo"]);
                else
                    ViewState["LnxNo"] = "0";

                ViewState["appointmentID"] = Convert.ToString(Request.QueryString["App_ID"]);
                if (Request.QueryString["IsIPDData"] != null)
                    ViewState["IsIPDData"] = Convert.ToString(Request.QueryString["IsIPDData"]);
                else
                    ViewState["IsIPDData"] = "0";

                string str = string.Empty;
                if (string.IsNullOrEmpty(lblAppointmentDoctorID.Text))
                    // str = StockReports.ExecuteScalar("SELECT DoctorID from doctor_employee where Employee_id='" + Convert.ToString(Session["ID"]) + "'");
                    str = GetDoctor(Convert.ToString(Session["ID"]), ViewState["TID"].ToString());

                ViewState["currentDoctorID"] = str;
                lblAppointmentDoctorID.Text = Util.GetString(str);
                if (!String.IsNullOrEmpty(str))
                {
                    if (ViewState["appointmentID"].ToString() == "")
                        ViewState["appointmentID"] = StockReports.ExecuteScalar("SELECT id FROM ipd_prescriptionvisit cc WHERE date(cc.CreatedOn)=curdate() and cc.TransactionID='" + ViewState["TID"].ToString() + "' AND cc.DoctorID='" + str + "' ORDER BY id LIMIT 1 ");
                }

                lblApp_ID.Text = ViewState["appointmentID"].ToString();
                lblTransactionId.Text = ViewState["TID"].ToString();
                lblLedgerTransactionID.Text = ViewState["LnxNo"].ToString();
                lblPatientID.Text = ViewState["PatientID"].ToString();
                lblIsIPDData.Text = ViewState["IsIPDData"].ToString();
                if (!string.IsNullOrEmpty(Request.QueryString["isipdopdprint"]))
                {
                    lblisipdopdprint.Text = Request.QueryString["isipdopdprint"].ToString();
                }
                lblisAccordian.Text = "1";
                bindTabs();
            }
            else
            {
                //ViewState["TID"] = Convert.ToString(Request.QueryString["TID"]);
				// ViewState["TID"] = Convert.ToString(Request.QueryString["TID"]);
                //if (ViewState["TID"].ToString() == string.Empty)
                   ViewState["TID"] = "0";
                ViewState["PatientID"] = Convert.ToString(Request.QueryString["PID"]);
                ViewState["LnxNo"] = "";
                lblisAccordian.Text = "0";
                ViewState["currentDoctorID"] = "";
                lblApp_ID.Text = "";
                lblTransactionId.Text = "0";
                lblLedgerTransactionID.Text = "";
                lblPatientID.Text = ViewState["PatientID"].ToString();
            }
            string primarydoctor = StockReports.ExecuteScalar(" SELECT (SELECT CONCAT(em.Title,' ',em.Name)EmpName FROM  employee_master em " +
            " WHERE em.EmployeeID=EntryBy ORDER BY ID DESC LIMIT 1)EmpName FROM `Cpoe_careplan` WHERE app_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "'  ORDER BY ID asc LIMIT 1");
            ViewState["PrimaryDoctor"] = primarydoctor;
            string PrimaryDoctorEntryTime = StockReports.ExecuteScalar(" SELECT DATE_FORMAT(EntryDate,'%d-%M-%Y %I:%i %p') AS EntryDate FROM `Cpoe_careplan` WHERE app_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "'  ORDER BY ID asc LIMIT 1");
            ViewState["FirstVisitDate"] = PrimaryDoctorEntryTime;

            string lastModifiedbydoctor = StockReports.ExecuteScalar(" SELECT (SELECT CONCAT(em.Title,' ',em.Name)EmpName FROM  employee_master em " +
           " WHERE em.EmployeeID=EntryBy ORDER BY ID DESC LIMIT 1)EmpName FROM `Cpoe_careplan` WHERE app_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "'  ORDER BY ID desc LIMIT 1");
            ViewState["LastDoctor"] = lastModifiedbydoctor;
            string lastmodifiedTime = StockReports.ExecuteScalar(" SELECT DATE_FORMAT(EntryDate,'%d-%M-%Y %I:%i %p') AS EntryDate FROM `Cpoe_careplan` WHERE app_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "'  ORDER BY ID desc LIMIT 1");
            ViewState["LastVisitDate"] = lastmodifiedTime;
           
        }
       
    }
    private string GetDoctor(string userID, string transactionID)
    {
        if (Convert.ToString(HttpContext.Current.Session["RoleID"]).ToUpper() == "52" || Convert.ToString(HttpContext.Current.Session["RoleID"]).ToUpper() == "323")
        {
            string str = "select DoctorID from doctor_employee where Employeeid='" + userID + "'";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                return Util.GetString(dt.Rows[0][0]);
            }
            else
            {
                string DocID = StockReports.ExecuteScalar("Select DoctorID from Patient_medical_history where TransactionID='" + transactionID + "'");
                return DocID;
            }
        }
        else
        {
            return string.Empty;
        }
    }
    protected void bindTabs()
    {
		
		 string IsIpdData = lblIsIPDData.Text;
       // string doctorId = StockReports.ExecuteScalar("SELECT d.`DoctorID` FROM doctor_employee d WHERE d.`Employee_id`='" + Session["ID"].ToString() + "' LIMIT 1 ");
        string doctorId = lblAppointmentDoctorID.Text;

       // doctorId = "LSHHI1";
            DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT cp.AccordianName,cp.ID,cpms.IsDefaultCheck FROM cpoe_prescription_master cp INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID` WHERE cpms.`RoleID`='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND cp.IsActive=1 AND cpms.`IsActive`=1 AND cpms.`IsDefault`=0 AND cpms.`DoctorID`='" + doctorId + "' AND IF('" + IsIpdData + "'='1', cp.IsIPDHide=0,1=1) GROUP BY cp.`ID` ORDER BY cpms.order");

        if (dt.Rows.Count == 0 && dt != null)
            dt = StockReports.GetDataTable("SELECT cp.AccordianName,cp.ID,cpms.IsDefaultCheck FROM cpoe_prescription_master cp INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID` WHERE cpms.`RoleID`='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND cp.IsActive=1 AND cpms.`IsActive`=1 AND cpms.`IsDefault`=1 AND ifnull(cpms.`DoctorID`,'')=''  AND IF('" + IsIpdData + "'='1', cp.IsIPDHide=0,1=1) GROUP BY cp.`ID` ORDER BY cpms.order");

        if (dt.Rows.Count == 0 && dt != null)
            dt = StockReports.GetDataTable("SELECT cp.AccordianName,cp.ID,0 IsDefaultCheck FROM cpoe_prescription_master cp WHERE cp.IsActive=1  AND IF('" + IsIpdData + "'='1', cp.IsIPDHide=0,1=1) ORDER BY cp.Order");

        if (dt.Rows.Count > 0)
        {
            chkHeaders.DataSource = dt;
            chkHeaders.DataTextField = "AccordianName";
            chkHeaders.DataValueField = "ID";
            chkHeaders.DataBind();

        }

    }
}