using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using MySql.Data.MySqlClient;

public partial class Design_IPD_Patient_OrderSet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            spnTransactionID.InnerText = Request.QueryString["TransactionID"].ToString();
            AllQuery AQ = new AllQuery();
            DataTable dtDischarge = AQ.GetPatientDischargeStatus(Request.QueryString["TransactionID"].ToString());
            if (spnTransactionID.InnerText.Contains("ISHHI"))
            {
                if (dtDischarge != null && dtDischarge.Rows.Count > 0)
                {
                    if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                    {
                        string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No Lab Prescription possible...";
                        Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                    }
                    else
                    {
                        DataTable dt = AQ.GetPatientIPDInformation("", Request.QueryString["TransactionID"].ToString(), "IN");
                        lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
                        spnPatientID.InnerText = dt.Rows[0]["PatientID"].ToString();
                        spnIPD_CaseTypeID.InnerText = dt.Rows[0]["IPDCaseType_ID"].ToString();
                        spnDocID.InnerText = dt.Rows[0]["DoctorID"].ToString();
                        lblReferenceCodeOPD.Text = StockReports.ExecuteScalar("SELECT ReferenceCode FROM f_panel_master WHERE PanelID=" + dt.Rows[0]["PanelID"].ToString() + " ");
                    }
                }
            }
            else
            {
                DataTable dt = StockReports.GetDataTable("Select app.PanelID,app.PatientID,app.DoctorID,fpm.ReferenceCodeOPD from appointment app INNER JOIN f_panel_master fpm ON app.PanelID=fpm.PanelID where app.TransactionID='" + spnTransactionID.InnerText + "'");
                if (dt.Rows.Count > 0) {
                    lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
                    spnPatientID.InnerText = dt.Rows[0]["PatientID"].ToString();
                    spnDocID.InnerText = dt.Rows[0]["DoctorID"].ToString();
                    lblReferenceCodeOPD.Text = dt.Rows[0]["ReferenceCodeOPD"].ToString();
                }
            }
           
        }
    }
    [WebMethod]
    public static string SaveOrder(List<OrderColumn> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            string OrderNo = string.Empty;
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                if (Data[0].TransactionID.Contains("ISHHI"))
                {
                    OrderNo = StockReports.ExecuteScalar("SELECT CONCAT('IORD','/',MAX(IFNULL(SPLIT_STR(indent_No,'/',2),0)+1))OrderNO FROM patient_test ");
                }
                else
                {
                    OrderNo = StockReports.ExecuteScalar("SELECT CONCAT('EORD','/',MAX(IFNULL(SPLIT_STR(indent_No,'/',2),0)+1))OrderNO FROM patient_test ");
                }
                for (int i = 0; i < Data.Count; i++)
                {
                    string str = "Insert into patient_test(Test_ID,TransactionID,PrescribeDate,PatientID,DoctorID,Remarks,Quantity,ConfigID,CreatedBy,IsUrgent,TYPE,indent_No) " +
                                     " values('" + Data[i].Test_ID + "','" + Data[i].TransactionID + "',NOW(),'" + Data[i].PatientID + "','"+ Data[i].DoctorID +"','"+ Data[i].Remarks +"','"+ Data[i].Quantity +"','"+ Data[i].ConfigID +"','" + HttpContext.Current.Session["ID"].ToString() + "','"+ Data[i].IsUrgent+"','IPD','"+ OrderNo +"')";
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                }
                tranX.Commit();
                return OrderNo;
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
            return "0";
        }

    }
    public class OrderColumn
    {
        public string Test_ID { get; set; }
        public string TransactionID { get; set; }
        public string PatientID { get; set; }
        public string DoctorID { get; set; }
        public string Remarks { get; set; }
        public string Quantity { get; set; }
        public string ConfigID { get; set; }
        public string IsUrgent { get; set; }
    }
}