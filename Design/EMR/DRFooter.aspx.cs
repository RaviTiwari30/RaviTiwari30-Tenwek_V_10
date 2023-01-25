using MySql.Data.MySqlClient;
using System;
using System.Data;

public partial class Design_EMR_DRFooter : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            var TID = string.Empty;

            if (Request.QueryString["TransactionID"] == null)
                TID = Request.QueryString["TID"].ToString();
            else
                TID = Request.QueryString["TransactionID"].ToString();

            ViewState["TID"] = TID;

            BindFooter(TID);
            // All_LoadData.bindDoctor(ddldoctor);
            AllLoadData_IPD.BindDoctorIPD(ddldoctor);
        }

        lblMsg.Text = "";
    }

    private void BindFooter(string TID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            string str = "Select Footer,PreparedBy from emr_ipd_details where TransactionID='" + TID.ToString() + "'";
            MySqlDataReader dr = MySqlHelper.ExecuteReader(con, CommandType.Text, str);
            dr.Read();
            
            if (dr.HasRows)
            {
                txtDetail.Text = dr["Footer"].ToString();
                txtPreparedBy.Text = dr["PreparedBy"].ToString();
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
