using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Controls_PhysioHeaderOPD : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Label lblTID = ((Label)Parent.FindControl("lblTID"));
            BindData(lblTID.Text);
        }
    }
    private void BindData(string TransactionID)
    {

        DataTable dt = StockReports.GetDataTable("SELECT pmh.PatientID,CONCAT(pm.title, ' ', pm.PName) Pname,CONCAT(pm.Age, ' ', pm.Gender) Age,CONCAT(dm.Title, ' ', dm.Name) DoctorName FROM patient_medical_history PMH INNER JOIN Patient_Master PM ON PM.PatientID = PMH.PatientID INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID WHERE pmh.TransactionID = '" + TransactionID + "' ");
       
        if (dt != null && dt.Rows.Count > 0)
        {

            lblMRNo.Text = dt.Rows[0]["PatientID"].ToString();
            lblPname.Text = dt.Rows[0]["Pname"].ToString();
            lblAgeSex.Text = dt.Rows[0]["Age"].ToString();
           
        }
      

        if (dt != null && dt.Rows.Count > 0)
        {
            lblDoctor.Text = dt.Rows[0]["DoctorName"].ToString();
        }
    }
}