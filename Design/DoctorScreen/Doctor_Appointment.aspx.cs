using System;
using System.Media;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Media;
public partial class Design_DoctorScreen_Doctor_Appointment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetDoctor();
            //UpdateDocIP();
            UpdateMap();
        }
    }
    protected void GetDoctor()
    {

        string str = "select DoctorID from doctor_employee where Employee_id='" + Convert.ToString(Session["ID"]) + "'";
        DataTable dt_ID = StockReports.GetDataTable(str);
        if (dt_ID != null && dt_ID.Rows.Count > 0)
        {
            str = "";
            str = "SELECT CONCAT(TITLE,' ',NAME)Dname FROM doctor_master WHERE DoctorID='" + dt_ID.Rows[0]["DoctorID"] + "'";
            DataTable dt_Name = StockReports.GetDataTable(str);
            lblDoc_ID.Text = Util.GetString(dt_ID.Rows[0]["DoctorID"]);
            lblDoctor.Text = Util.GetString(dt_Name.Rows[0]["Dname"]);
            lblroomNo.Text = StockReports.ExecuteScalar("select Room_No from doctor_hospital where DoctorID='" + lblDoc_ID.Text + "'");
        }
    }
    protected void UpdateDocIP()
    {
         //string.IsNullOrEmpty(Request.UserHostAddress))
         string IPAddress = Request.UserHostAddress;

         //string IPAddress = Request.ServerVariables("HTTP_X_FORWARDED_FOR");

         int ID=Util.GetInt(StockReports.ExecuteScalar("Select ID from doc_doorip_map where Doc_ID=" + lblDoc_ID.Text.Trim() + ""));
         if (ID > 0)
         {
             StockReports.ExecuteDML("UPDATE doc_doorip_map SET DoorTab='',Doc_ID='',doctab='' WHERE Doc_ID='" + lblDoc_ID.Text.Trim() + "'");
         }
         else
         {

         }


         StockReports.ExecuteDML("UPDATE doc_doorip_map SET DoorTab='',Doc_ID='',doctab='' WHERE Doc_ID='" + lblDoc_ID.Text.Trim() + "'");

         StockReports.ExecuteDML("update doc_doorip_map set ");


         StockReports.ExecuteDML("UPDATE doc_doorip_map SET Doc_ID='' where Doc_ID='" + lblDoc_ID.Text.Trim() + "' ");
         StockReports.ExecuteDML("UPDATE doc_doorip_map SET Doc_ID='" + lblDoc_ID.Text.Trim() + "' where DocTab='" + IPAddress + "' ");
    }
    protected void UpdateMap()
    {
        int ID=Util.GetInt(StockReports.ExecuteScalar("Select ID from doc_doorip_map where Room_No='" + lblroomNo.Text.Trim() + "'"));
        if (ID > 0)
        {
            StockReports.ExecuteDML("Update doc_doorip_map set Doc_ID='" + lblDoc_ID.Text + "' where ID=" + ID + "");
        }
        else
        {
            StockReports.ExecuteDML("Insert into doc_doorip_map(Doc_ID,Room_No)value('" + lblDoc_ID.Text + "','" + lblroomNo.Text.Trim() + "')");
        }
    }
  
}
