using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Mortuary_Mortuary : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string TransactionID;
            TransactionID = Request.QueryString["TransactionID"].ToString();
            BindCorpseDetails(TransactionID);
        }
    }
    private void BindCorpseDetails(string TransactionID)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetCorpseInformation(TransactionID);
        if (dt != null && dt.Rows.Count > 0)
        {
            lblCorpseNo.Text = dt.Rows[0]["Corpse_ID"].ToString();
            lblCorpseName.Text = dt.Rows[0]["CName"].ToString();
            lblDOB.Text = dt.Rows[0]["Age"].ToString();
            lblGender.Text = dt.Rows[0]["Gender"].ToString();
            lblStatus.Text = dt.Rows[0]["Type"].ToString();
            lblDeathType.Text = dt.Rows[0]["DeathType"].ToString();
            lblDoctorName.Text = dt.Rows[0]["DName"].ToString(); ;
            lblDepositeID.Text = dt.Rows[0]["DepositeNo"].ToString();
            lblDepositeDate.Text = dt.Rows[0]["DepositeDateTime"].ToString();
            lblRoomNo.Text = dt.Rows[0]["FreezerName"].ToString();
            lblDeathDate.Text = dt.Rows[0]["DateofDeath"].ToString() + " " + dt.Rows[0]["TimeofDeath"].ToString();
            lblReleasedDate.Text = dt.Rows[0]["ReleasedDateTime"].ToString();
            BindPatientImage(dt.Rows[0]["PatientID"].ToString().Trim(), dt.Rows[0]["Corpse_ID"].ToString().Trim());
        }
    }
    private void BindPatientImage(string PatientID, string Corpse_ID)
    {
        //1st check patient image available then use patient image otherwise use Default image as per Gender

        DateTime DateEnrolle = Util.GetDateTime(StockReports.ExecuteScalar("select DateEnrolled from Patient_master where PatientID='" + PatientID + "'"));
        string Gender = Util.GetString(StockReports.ExecuteScalar("SELECT Gender FROM mortuary_corpse_master WHERE Corpse_ID='" + Corpse_ID + "'"));
        PatientID = PatientID.Replace("/", "_");
        lblGender.Text = Gender;
        string PImagePath = HttpContext.Current.Server.MapPath(@"~/PatientPhoto/" + DateEnrolle.Year + "/" + DateEnrolle.Month + "/" + PatientID + ".jpg");
        if (File.Exists(PImagePath))
        {
            imgPatient.ImageUrl = @"~/PatientPhoto/" + DateEnrolle.Year + "/" + DateEnrolle.Month + "/" + PatientID + ".jpg";
        }
        else
        {
            //check gender
            if (Gender == "Male")
            {
                imgPatient.ImageUrl = "~/Images/MaleDefault.png";
            }
            else if (Gender == "Female")
            {
                imgPatient.ImageUrl = "~/Images/FemaleDefault.png";
            }
        }
    }
}