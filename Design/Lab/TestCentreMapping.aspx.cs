using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Linq;
using System.Web.UI.HtmlControls;

public partial class Design_Investigation_TestCentreMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ddlDepartment.DataSource = AllLoadData_OPD.BindLabRadioDepartment(HttpContext.Current.Session["RoleID"].ToString());
        ddlDepartment.DataTextField = "Name";
        ddlDepartment.DataValueField = "ObservationType_ID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));

        All_LoadData.bindCenterDropDownList(ddlCentre, Session["CentreID"].ToString(), "Select");
        All_LoadData.bindCenterDropDownList(ddlTestCentre1, Session["CentreID"].ToString(), "Select");
        //AllLoad_Data.bindAllCentreLab(ddlTestCentre2);
        //AllLoad_Data.bindAllCentreLab(ddlTestCentre3);
        All_LoadData.bindCenterDropDownList(DropDownList1, Session["CentreID"].ToString(), "Select");
       // AllLoad_Data.bindAllCentreLab(DropDownList2);
       // AllLoad_Data.bindAllCentreLab(DropDownList3);
        
    }
    [WebMethod(EnableSession=true)]
    public static string SaveTestCentre(object testCentre)
    {
        List<TestCentre> dataTestCentre = new JavaScriptSerializer().ConvertToType<List<TestCentre>>(testCentre);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

         
            string investigationID = String.Join(",", dataTestCentre.Select(a => String.Join(", ", a.AllInvestigation_ID)));



            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM test_centre_mapping WHERE Booking_Centre='" + dataTestCentre[0].BookingCentre + "' and Investigation_ID IN(" + investigationID + ")");



            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM investigations_outsrclab WHERE Investigation_ID IN(" + investigationID + ")  and CentreID='" + dataTestCentre[0].BookingCentre + "' ");


            string Command = "INSERT INTO test_centre_mapping (Booking_Centre,Test_Centre,Test_Centre2,Test_Centre3,Investigation_ID,UserID,Username) VALUES (@Booking_Centre, @Test_Centre,@Test_Centre2,@Test_Centre3,@Investigation_ID,@UserID,@Username);";


            using (MySqlCommand myCmd = new MySqlCommand(Command, con, Tranx))
            {
                myCmd.CommandType = CommandType.Text;
                for (int i = 0; i < dataTestCentre.Count; i++)
                {

                    myCmd.Parameters.Clear();
                    myCmd.Parameters.AddWithValue("@Booking_Centre", dataTestCentre[i].BookingCentre);
                    myCmd.Parameters.AddWithValue("@Test_Centre", dataTestCentre[i].TestCentre1);

                    myCmd.Parameters.AddWithValue("@Test_Centre2", dataTestCentre[i].TestCentre2);
                    myCmd.Parameters.AddWithValue("@Test_Centre3", dataTestCentre[i].TestCentre3);
                    myCmd.Parameters.AddWithValue("@Investigation_ID", dataTestCentre[i].Investigation_ID);
                    myCmd.Parameters.AddWithValue("@UserID", HttpContext.Current.Session["ID"].ToString());
                    myCmd.Parameters.AddWithValue("@Username", HttpContext.Current.Session["LoginName"].ToString());
                    myCmd.ExecuteNonQuery();


                }
                Tranx.Commit();
            }



            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}