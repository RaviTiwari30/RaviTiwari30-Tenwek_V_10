using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NewReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //FillDateTime();
            //BindUser();
            //BindTypeOfTnx();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPreview);
            // chkdep_CheckedChanged(sender, e);
            // chkuser_CheckedChanged(sender, e);
            ucFromDate.Text = DateTime.Now.AddDays(0).ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.AddDays(0).ToString("dd-MMM-yyyy");
        }
        
           
       
    }
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        if (Session["LoginType"] == null)
        {
            return;
        }
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string startDate = string.Empty, toDate = string.Empty, user, colType;

        if (Util.GetDateTime(ucFromDate.Text).ToString() != "")

            startDate = Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd");
          

      
                toDate = Util.GetDateTime(Util.GetDateTime(ucToDate.Text)).ToString("yyyy-MM-dd");
            

        //user = GetSelection(cblUser);
        //colType = GetSelection(cblColType);
        //if (colType == string.Empty)
        //{
        //    lblMsg.Text = "Select Type";
        //    return;
        //}
        //if (user == string.Empty)
        //{
        //    lblMsg.Text = "Select Employee";
        //    return;
        //}
        //if (rbtReportType.SelectedValue == "0")
        //{
        //}
    }
    [WebMethod]
    public static string FunctionForApprovalType()
    {
        DataTable dt;
        string Output = "";
        MySqlConnection connection = Util.GetMySqlCon();
        try
        {

            MySqlCommand command = new MySqlCommand("ApprovalType", connection);
            command.CommandType = System.Data.CommandType.StoredProcedure;


            MySqlDataAdapter sda = new MySqlDataAdapter(command);
            dt = new DataTable();
            sda.Fill(dt);
            Output = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            throw (ex);
        }
        return Output;
    
    
    }



    [WebMethod]
    public static string DiscountReport(string fromDate, string toDate, string ApprovalType, string value, string CenterID, string GetType, string minDis, string maxDis)
    {
        DataTable dt;
        string Output = "";
        MySqlConnection connection = Util.GetMySqlCon();
        try
        {
            MySqlCommand command = new MySqlCommand("sp_Discount_Detail", connection);
            command.CommandType = System.Data.CommandType.StoredProcedure;
            command.Parameters.Add(new MySqlParameter("@vFromDate", Util.GetDateTime(fromDate).ToString("yyyy-MM-dd")));
            command.Parameters.Add(new MySqlParameter("@vToDate", Util.GetDateTime(toDate).ToString("yyyy-MM-dd")));
            command.Parameters.Add(new MySqlParameter("@ApprovalBy", Util.GetString(ApprovalType)));
            command.Parameters.Add(new MySqlParameter("@OPD_IPD_Type", Util.GetString(value)));
            command.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetString(CenterID)));
            command.Parameters.Add(new MySqlParameter("@RangeFromVal", Util.GetString(minDis)));
            command.Parameters.Add(new MySqlParameter("@RangeToVal", Util.GetString(maxDis)));
            MySqlDataAdapter sda = new MySqlDataAdapter(command);
            dt = new DataTable();
            sda.Fill(dt);
            DataSet set = new DataSet();


            if (GetType == "Pdf")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + fromDate.Trim() + "  To : " + toDate.Trim();
                dt.Columns.Add(dc);
                set.Tables.Add(dt.Copy());

                set.Tables[0].TableName = "DiscountReport";
                //set.WriteXmlSchema(@"E:\DiscountReport.xml");
                HttpContext.Current.Session["ds"] = set;
                HttpContext.Current.Session["Reportname"] = "DiscountReport";
                Output = "1";
            }
            if (GetType == "Excel")
            {
                

                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + fromDate.Trim() + "  To : " + toDate.Trim();
                dt.Columns.Add(dc);
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["Reportname"] = "DiscountReport";
				HttpContext.Current.Session["Period"] = "From : " + fromDate.Trim() + "  To : " + toDate.Trim();
                dt.Columns.Remove("Period");
                Output = "2";
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }
        return Output;
    }


}
