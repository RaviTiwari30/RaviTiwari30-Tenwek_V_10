using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Controls_PhysioPostOP : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindData(((Label)Parent.FindControl("lblTransactionID")).Text.Trim());
        }
    }

    private void BindData(string transactionID)
    {
        string status = StockReports.ExecuteScalar("SELECT Status FROM patient_medical_history WHERE TransactionID='" + transactionID + "'");

        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetPatientIPDInformation("", transactionID, status);

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMRNo.Text = dt.Rows[0]["Patient_ID"].ToString();
            lblPname.Text = dt.Rows[0]["Title"].ToString() + " " + dt.Rows[0]["PName"].ToString();
            lblAgeSex.Text = dt.Rows[0]["Age"].ToString() + " " + dt.Rows[0]["Gender"].ToString();
            lblRoomNo.Text = dt.Rows[0]["RoomNo"].ToString();
            lblIPDNo.Text = dt.Rows[0]["TransNo"].ToString();
        }

        dt = AQ.GetPatientIPDInformation(transactionID);

        if (dt != null && dt.Rows.Count > 0)
        {
            lblDoctor.Text = dt.Rows[0]["DoctorName"].ToString();
        }
    }
}