using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.IO;
using System.Web.Script.Services;
using MySql.Data.MySqlClient;

public partial class Design_IPD_IPFolder : System.Web.UI.Page
{
    public string TransactionID;
    public string PatientID;
    public string Sex;
    public string BillNo;
    public string UserID;
    public string Type;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TransactionID = Request.QueryString["TID"].ToString();
            ViewState["TransactionID"] = TransactionID;
        
            PatientID = Request.QueryString["PID"].ToString();
           // GenerateMenu(Session["RoleID"].ToString());
            GenerateMainMenu(Session["RoleID"].ToString());
            GetPatientImage(PatientID);
            UserID = Session["ID"].ToString();


            ViewState["defaultUrl"] = "../Emergency/EMG_BillingDetails.aspx";
             Type = "OPD";

           
        }
        if (Session["LoginType"] == null && Session["UserName"] == null)
        {
            Response.Redirect("Default.aspx");
        }
    }
    //public void GenerateMenu(string roleID)
    //{
    //    DataTable dt = StockReports.GetDataTable(" SELECT fmm.FileName,fmm.URL,fmm.FrameName FROM f_framemenumaster fmm INNER JOIN f_frame_role ffr ON fmm.ID=ffr.URLID " +
    //         " WHERE fmm.IsActive=1 AND ffr.IsActive=1 AND ffr.RoleID=" + roleID + " and upper(FrameName)='EMERGENCY' ORDER BY ffr.SequenceNo");
    //    rptMenu.DataSource = dt;
    //    rptMenu.DataBind();
    //}
    public void GetPatientImage(string PatientID)
    {
        try
        {
            DateTime DateEnrolle = Util.GetDateTime(StockReports.ExecuteScalar("select DateEnrolled from Patient_master where PatientID='" + PatientID + "'"));
            string Gender = Util.GetString(StockReports.ExecuteScalar("select Gender from Patient_master where PatientID='" + PatientID + "'"));
            PatientID = PatientID.Replace("/", "_");
            string PImagePath = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\PatientPhoto\\" + DateEnrolle.Year + "\\" + DateEnrolle.Month + "\\" + PatientID + ".jpg");
            if (File.Exists(PImagePath))
            {
                byte[] byteArray = File.ReadAllBytes(PImagePath);
                string base64 = Convert.ToBase64String(byteArray);
                imgPatient.Src = string.Format("data:image/jpg;base64,{0}", base64);
            }
            else
            {
                //check gender
                if (Gender == "Male")
                {
                    imgPatient.Src = "~/Images/MaleDefault.png";
                }
                else if (Gender == "Female")
                {
                    imgPatient.Src = "~/Images/FemaleDefault.png";
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }

    [WebMethod]
    public static string GetAllergiesAndDiagnosis(string patientID)
    {
        // patientID = "C0036504";
        string str = "SELECT 'Allergies' AS DataType,ce.Allergies AS DataValues,DATE_FORMAT(ce.EntryDate,'%d-%b-%y') AS EntryDate FROM CPOE_hpexam ce "+
                     "WHERE ce.PatientID='"+ patientID +"' AND IFNULL(ce.Allergies,'')<>'' "+
                    "UNION ALL "+
                    "SELECT 'Allergies' AS DataType,ce.Allergies AS DataValues,DATE_FORMAT(ce.EntryDate,'%d-%b-%y') AS EntryDate FROM emr_hpexam ce  " +
                    "WHERE ce.PatientID='"+ patientID +"' AND IFNULL(ce.Allergies,'')<>''  "+
                    "UNION ALL "+
                    "SELECT 'Diagnosis' AS DataType, cp.ProvisionalDiagnosis AS DataValues,DATE_FORMAT(cp.CreatedDate,'%d-%b-%y') AS EntryDate  "+
                    "FROM EMR_PatientDiagnosis cp WHERE cp.PatientID='"+ patientID +"' AND IFNULL(cp.ProvisionalDiagnosis,'')<>'' "+
                    "UNION ALL SELECT 'Diagnosis' AS DataType, cp.ProvisionalDiagnosis AS DataValues,DATE_FORMAT(cp.CreatedDate,'%d-%b-%y') AS EntryDate  "+
                    "FROM cpoe_PatientDiagnosis cp WHERE cp.PatientID='"+ patientID +"' AND IFNULL(cp.ProvisionalDiagnosis,'')<>''";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    public void GenerateMainMenu(string roleID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT DISTINCT(if(IFNULL(fmm.MenuHeader,'')='','Others',fmm.MenuHeader)) MenuName FROM f_framemenumaster fmm INNER JOIN f_frame_role ffr ON fmm.ID=ffr.URLID " +
             " WHERE fmm.IsActive=1 AND ffr.IsActive=1 AND ffr.RoleID=" + roleID + " and upper(FrameName)='EMERGENCY' ORDER BY ffr.SequenceNo");
        rptMainMenu.DataSource = dt;
        rptMainMenu.DataBind();
    }



    protected void rptMainMenu_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Repeater rptSubMenu = e.Item.FindControl("rptChildMenu") as Repeater;

            Label a1 = (Label)e.Item.FindControl("lblMenuName");
            var MenuName = a1.Text;
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fmm.FileName,fmm.URL,fmm.FrameName FROM f_framemenumaster fmm INNER JOIN f_frame_role ffr ON fmm.ID=ffr.URLID ");
            sb.Append(" WHERE fmm.IsActive=1 AND ffr.IsActive=1 AND ffr.RoleID=" + Session["RoleID"].ToString() + " ");
            if (MenuName.ToString() != "")
            {
                if (MenuName.ToString() == "Others")
                {
                    sb.Append("  and  IFNULL(fmm.MenuHeader,'')=''  ");

                }
                else
                {
                    sb.Append("  and fmm.MenuHeader like '%" + MenuName + "%'  ");

                }
            }

            sb.Append(" and upper(FrameName)='EMERGENCY' ORDER BY ffr.SequenceNo ");




            DataTable dt = StockReports.GetDataTable(sb.ToString());


            rptSubMenu.DataSource = dt;
            rptSubMenu.DataBind();

        }




    }


}