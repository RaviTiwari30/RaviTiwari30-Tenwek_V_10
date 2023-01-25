using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_AttendentPassReprint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";

            string IPDNo = "";
            if (txtIPDNo.Text.Trim() != "")
                IPDNo = StockReports.getTransactionIDbyTransNo(txtIPDNo.Text.Trim());//"" +


            lblMsg.Text = "";
           
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT CONCAT(t2.Title, ' ',t2.PName)PName,t2.PatientID,t2.TransactionID,ictm1.Name,t2.RelativeOf,t2.RelativeName,");
            sb.Append("  CONCAT(House_No,' ',Street_Name,' ',Locality,',',City)Address");
            sb.Append("  ,rm.Bed_No,t2.IPDCaseTypeID,t2.TransNo FROM ( ");
            sb.Append("  SELECT pm.ID,TransactionID,TransNo,IPDCaseTypeID,RoomId,pm.Title,PName,House_No,Street_Name,Locality,City,Pincode,Age,pm.PatientID,pm.Relation AS RelativeOf,pm.RelationName AS RelativeName    FROM (  ");
            sb.Append("  	SELECT pip.PatientID,pip.IPDCaseTypeID,pip.IPDCaseTypeID_Bill,pip.RoomId, pip.TransactionID,pmh.TransNo,");
            sb.Append("  	pip.Status,DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%y')DateOfAdmit,TIME_FORMAT(pmh.TimeOfAdmit,'%l: %i %p')");
            sb.Append("  	TimeOfAdmit,pmh.DoctorID FROM     ( ");
            sb.Append("  		SELECT pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseTypeID,pip1.IPDCaseTypeID_Bill,pip1.RoomId,pip1.TransactionID,");
            sb.Append("  	pip1.Status FROM patient_ipd_profile pip1 ");
            sb.Append("  	INNER JOIN ( ");
            sb.Append("  		SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID FROM patient_ipd_profile ");
            sb.Append("  		WHERE STATUS = 'IN' ");

            if (txtIPDNo.Text.Trim() != string.Empty)
                sb.Append("  		AND TransactionID= '" + IPDNo + "' ");

            sb.Append("     AND CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "	GROUP BY TransactionID  ");
            sb.Append("  	)pip2 ON pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID  ");
            sb.Append("  	)pip INNER JOIN patient_medical_history pmh ON pmh.TransactionID = pip.TransactionID ");
            sb.Append("  	AND pmh.Type='IPD' WHERE pmh.status='IN'  ");
            sb.Append("  ) t1 INNER JOIN  patient_master pm  ON t1.PatientID = pm.PatientID ");
            sb.Append("  )t2");
            sb.Append("   INNER JOIN ipd_case_type_master ictm1 ON ictm1.IPDCaseTypeID = t2.IPDCaseTypeID ");
            sb.Append("  INNER JOIN room_master rm ON rm.RoomId = t2.RoomId ORDER BY t2.ID DESC, t2.PName, t2.PatientID  ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdPatient.DataSource = dt;
                grdPatient.DataBind();
            }
            else
            {
                lblMsg.Text = "No Record Found";
                grdPatient.DataSource = null;
                grdPatient.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Pass")
        {
            string TID = e.CommandArgument.ToString();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('AttendantPass.aspx?TID=" + TID + "');", true);
        }
    }
}