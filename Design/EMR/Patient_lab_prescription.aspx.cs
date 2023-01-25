using System;
using System.Data;

public partial class Design_EMR_Patient_lab_prescription : System.Web.UI.Page
{
    public string PID = "";
    public string TID = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //TID = Request.QueryString["TransactionID"].ToString();


            if (Request.QueryString["TransactionID"] == null)
                TID = Request.QueryString["TID"].ToString();
            else
                TID = Request.QueryString["TransactionID"].ToString();


            ViewState["TID"] = TID;
            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientIPDInformation("", TID);
            if (dt != null && dt.Rows.Count > 0)
            {
                PID = dt.Rows[0]["PatientID"].ToString();
            }
        }
    }
}