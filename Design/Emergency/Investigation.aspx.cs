using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;



public partial class Design_CPOE_Investigation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Convert.ToString(Request.QueryString["TID"]) != null)
            {

              
                if (Convert.ToString(Request.QueryString["TID"]).Contains("ISHHI"))
                {
                    ViewState["TID"] = Convert.ToString(Request.QueryString["TransactionID"]);
                  //  ViewState["Patient_ID"] = Convert.ToString(Request.QueryString["PatientId"]);
                    ViewState["Patient_ID"] = Convert.ToString(Request.QueryString["PID"]);
                    ViewState["LnxNo"] = "";
                    lblisAccordian.Text = "0";//0
                    lblApp_ID.Text = "";
                    lblTransactionId.Text = "";
                    lblTransactionIdPre.Text = StockReports.ExecuteScalar("SELECT TransactionID FROM emergency_patient_details WHERE PAtientID='" + ViewState["Patient_ID"].ToString() + "' ORDER BY ID DESC LIMIT 1");
                    lblLedgerTransactionID.Text = "";
                    if (lblTransactionIdPre.Text == "")
                        lblTransactionIdPre.Text = Convert.ToString(Request.QueryString["TID"]);

                    lblPatientID.Text = ViewState["Patient_ID"].ToString();
                }
                else
                {
                    ViewState["TID"] = Convert.ToString(Request.QueryString["TID"]);
                    ViewState["Patient_ID"] = Convert.ToString(Request.QueryString["PID"]);
                    ViewState["LnxNo"] = Convert.ToString(Request.QueryString["LnxNo"]);
                    if (Session["RoleID"].ToString() == "52" || Session["RoleID"].ToString() == "323")
                        lblisAccordian.Text = "1";
                    else
                        lblisAccordian.Text = "0";//0

                //ViewState["appointmentID"] = Convert.ToString(Request.QueryString["App_ID"]);
                string appointmentID = string.Empty;
                string doctorID = GetDoctor(HttpContext.Current.Session["ID"].ToString(), Convert.ToString(ViewState["TID"].ToString()));
                if (!String.IsNullOrEmpty(doctorID))
                {
                    lblisAccordian.Text = "1";
                    //appointmentID = ViewState["appointmentID"].ToString();
                    if (appointmentID == "")
                    {
                        appointmentID = StockReports.ExecuteScalar("SELECT id FROM emergency_prescriptionvisit cc WHERE cc.TransactionID='" + ViewState["TID"].ToString() + "' AND cc.DoctorID='" + doctorID + "' ORDER BY id LIMIT 1 ");
                        if (string.IsNullOrEmpty(appointmentID))
                        {
                            appointmentID = Util.GetString(StockReports.ExecuteScalar("CALL insert_emergency_prescriptionvisit('" + ViewState["TID"].ToString() + "','" + doctorID + "','" + Session["ID"].ToString() + "')"));
                        }

                        }
                    }
                    else
                    {
                        lblisAccordian.Text = "0";//0
                    }
                    lblAppointmentDoctorID.Text = doctorID;
                    lblApp_ID.Text = appointmentID;
                    lblTransactionId.Text = ViewState["TID"].ToString();
                    lblLedgerTransactionID.Text = Util.GetString(ViewState["LnxNo"]);
                    lblPatientID.Text = ViewState["Patient_ID"].ToString();
                }

            }
            else
            {
                ViewState["TID"] = Convert.ToString(Request.QueryString["TransactionID"]);
                ViewState["Patient_ID"] = Convert.ToString(Request.QueryString["PatientId"]);
                ViewState["Patient_ID"] = Convert.ToString(Request.QueryString["PID"]);
                ViewState["LnxNo"] = "";
                lblisAccordian.Text = "0";//0
                lblApp_ID.Text = "";
                lblTransactionId.Text = "";
                lblTransactionIdPre.Text = StockReports.ExecuteScalar("SELECT TransactionID FROM emergency_patient_details WHERE PAtientID='" + ViewState["Patient_ID"].ToString() + "' ORDER BY ID DESC LIMIT 1");
                lblLedgerTransactionID.Text = "";
                if (lblTransactionIdPre.Text == "")
                    lblTransactionIdPre.Text = Convert.ToString(Request.QueryString["TransactionID"]);

                lblPatientID.Text = ViewState["Patient_ID"].ToString();
            }

            ////ViewState["appointmentID"] = Convert.ToString(Request.QueryString["App_ID"]);
            //string appointmentID = string.Empty;
            //string doctorID = GetDoctor(HttpContext.Current.Session["ID"].ToString(), Convert.ToString(ViewState["TID"].ToString()));
            //if (!String.IsNullOrEmpty(doctorID))
            //{
            //    lblisAccordian.Text = "1";
            //    //appointmentID = ViewState["appointmentID"].ToString();
            //    if (appointmentID == "")
            //    {
            //        appointmentID = StockReports.ExecuteScalar("SELECT id FROM emergency_prescriptionvisit cc WHERE cc.TransactionID='" + ViewState["TID"].ToString() + "' AND cc.DoctorID='" + doctorID + "' ORDER BY id LIMIT 1 ");
            //        if (string.IsNullOrEmpty(appointmentID))
            //        {
            //            appointmentID = Util.GetString(StockReports.ExecuteScalar("CALL insert_emergency_prescriptionvisit('" + ViewState["TID"].ToString() + "','" + doctorID + "','" + Session["ID"].ToString() + "')"));
            //        }

            //    }
            //}
            //else
            //{
            //    lblisAccordian.Text = "1";//0
            //}
            //lblAppointmentDoctorID.Text = doctorID;
            //lblApp_ID.Text = appointmentID;
            //lblTransactionId.Text = ViewState["TID"].ToString();
            //lblLedgerTransactionID.Text = Util.GetString(ViewState["LnxNo"]);
            //lblPatientID.Text = ViewState["Patient_ID"].ToString();
        }
    }


    public static string GetDoctor(string userID, string transactionID)
    {
        //if (Convert.ToString(HttpContext.Current.Session["RoleID"]).ToUpper() == "52")
        //{
        string str = "select DoctorID from doctor_employee where EmployeeID='" + userID + "'";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            return Util.GetString(dt.Rows[0][0]);
        }
        else
        {
            //string DocID = StockReports.ExecuteScalar("Select DoctorID from Patient_medical_history where TransactionID='" + transactionID + "'");
            return "";// DocID;
        }
        // }
        // else
        // {
        //string DocID = StockReports.ExecuteScalar("Select DoctorID from Patient_medical_history where TransactionID='" + transactionID + "'");
        //     return "";
        // }
    }
}