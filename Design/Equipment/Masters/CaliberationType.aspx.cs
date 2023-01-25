using System;
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
using MySql.Data.MySqlClient;
public partial class Design_Equipment_Transactions_CaliberationType : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";

        }

        txtdate1.Attributes.Add("readonly","readonly");
        txtdate.Attributes.Add("readonly","readonly");

    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT am.AssetID,am.AssetName,am.AssetCode,cl.CalibrationID,IFNULL(cl.IsActive,0)IsActive FROM eq_asset_master am LEFT JOIN eq_calibration cl ON am.AssetCode=cl.AssestCode where am.AssetID<>'' ");
            if (txtmachinename.Text.Trim() != "")
            {
                sb.Append("and am.AssetName LIKE '" + txtmachinename.Text.Trim() + "%'");
            }

            if (txtassetcode.Text.Trim() != "")
            {
                sb.Append("and am.AssetCode LIKE '" + txtassetcode.Text.Trim() + "%'");
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdSupplierType.DataSource = dt;
                grdSupplierType.DataBind();
            }
            else
            {
                grdSupplierType.DataSource = null;
                grdSupplierType.DataBind();
                lblmsg.Text = "Record Not Found";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.GeneralLog(ex.Message);
        }
    }

    protected void grdSupplierType_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        string CalibrationID = Util.GetString(e.CommandArgument);


        if (e.CommandName == "Select")
        {
            mpeCreateGroup.Show();
            txtMName.Text = e.CommandArgument.ToString().Split('#')[0];
            txtAcode.Text = e.CommandArgument.ToString().Split('#')[1];
        }
        else if (e.CommandName == "ViewLog")
        {
            try
            {
                lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_calibration WHERE CalibrationID=" + CalibrationID);
                mdpLog.Show();
            }
            catch (Exception ex)
            {

                lblmsg.Text = "No Log Avaialable!!!";
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }

        }
        else if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable("SELECT MachineName,AssestCode,CalibrationType,DATE_FORMAT(DueDate,'%d-%b-%Y')DueDate,DATE_FORMAT(NextDate,'%d-%b-%Y')NextDate FROM eq_calibration WHERE CalibrationID=" + CalibrationID);

            if (dt != null && dt.Rows.Count > 0)
            {
                ddlCaliType.SelectedIndex = ddlCaliType.Items.IndexOf(ddlCaliType.Items.FindByValue(dt.Rows[0]["CalibrationType"].ToString()));
                txtMName.Text = dt.Rows[0]["MachineName"].ToString();
                txtAcode.Text = dt.Rows[0]["AssestCode"].ToString();
                txtdate.Text = dt.Rows[0]["DueDate"].ToString();
                txtdate1.Text = dt.Rows[0]["NextDate"].ToString();

                ViewState["CalibrationID"] = CalibrationID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
                mpeCreateGroup.Show();
            }
        }
    }


    protected void chkcalibration_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (chkcalibration.SelectedValue == "1")
        {
            txtdate.Visible = true;
        }
        else
        {
            txtdate1.Visible = true;
        }
    }


    protected void btnsave_Click1(object sender, EventArgs e)
    {
        if (CheckValidation())
        {
            //string already = StockReports.ExecuteScalar("Select MachineName FROM eq_calibration where MachineName= '" + txtMName.Text.Trim() + "'");
            //if(already !="")
            //{

            //lblmsg.Text="Machine Name Already Exit ";
            //return;
            //}

            if (Util.GetInt(StockReports.ExecuteScalar("SELECT  COUNT(*) FROM eq_calibration WHERE  DueDate='" + Util.GetDateTime(txtdate.Text).ToString("yyyy-MM-dd") + "' AND NextDate='" + Util.GetDateTime(txtdate1.Text).ToString("yyyy-MM-dd") + "'")) > 0)
            {
                lblmsg.Text = "This Date is Already Used";
                Clear();
                return;

            }

            MySqlConnection conn = Util.GetMySqlCon();
            conn.Open();
            MySqlTransaction tnx = conn.BeginTransaction();
            try
            {

                string str = "";
                int IsActive = 1;


                if (ViewState["IsUpdate"].ToString() == "S")
                {
                    if (Util.GetInt(StockReports.ExecuteScalar("SELECT Count(*)FROM eq_calibration Where DueDate='" + Util.GetDateTime(txtdate.Text).ToString("yyyy-MM-dd") + "'AND NextDate='" + Util.GetDateTime(txtdate1.Text).ToString("yyyy-MM-dd") + "'")) > 0)
                    {
                        lblmsg.Text = "This Date is already Userd";
                        return;

                    }

                    str = "insert into eq_calibration(MachineName,AssestCode,CalibrationType,DueDate,NextDate,LastUpdatedby,UpdateDate,IsActive)";
                    str += " values('" + txtMName.Text.Trim().Replace("'", "") + "','" + txtAcode.Text.Trim() + "','" + ddlCaliType.SelectedItem.Text + "','" + Util.GetDateTime(txtdate.Text.Trim()).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtdate1.Text.Trim()).ToString("yyyy-MM-dd") + "',";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now()," + IsActive + ")";
                }
                else
                {
                    string DataLog = StockReports.ExecuteScalar(" SELECT CONCAT(" +
                        "'LastUpdateby: ',(SELECT NAME FROM employee_master WHERE Employee_ID=fm.LastUpdatedby LIMIT 1),' </BR>" +
                         "Last UpdateDate : ', CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ', TIME_FORMAT(fm.UpdateDate,'%T')),'</BR>" +
                           " Name: ', fm.MachineName,',AssestCode: ',fm.AssestCode," +
                            "', Active : ', IF(fm.IsActive=1,'Yes','No'))DataLog FROM eq_calibration fm ");

                    str = " UPDATE eq_calibration SET MachineName='" + txtMName.Text.Trim() + "',AssestCode='" + txtAcode.Text.Trim() + "',IsActive=" + IsActive + ",";
                    str += "DueDate='" + Util.GetDateTime(txtdate.Text.Trim()).ToString("yyyy-MM-dd") + "',NextDate='" + Util.GetDateTime(txtdate1.Text.Trim()).ToString("yyyy-MM-dd") + "',LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),";
                    str += "DataLog =Concat_Ws('</BR></BR>',DataLog,'" + DataLog + "')WHERE CalibrationID='" + ViewState["CalibrationID"].ToString() + "'";
                   
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                tnx.Commit();
                conn.Close();
                conn.Dispose();
                lblmsg.Text = "Record Saved";
                Clear();
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                conn.Close();
                conn.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblmsg.Text = ex.Message;
            }
        }
    }

    private void Clear()
    {
        txtMName.Text = "";
        txtAcode.Text = "";
        txtdate.Text = "";
        txtdate1.Text = "";
        ddlCaliType.SelectedItem.Text = "";

    }
    private bool CheckValidation()
    {
        if (ddlCaliType.SelectedItem.Text == "Select")
        {
            lblmsg.Text = "Please select Calibration Type";
            ddlCaliType.Focus();
            return false;
        }
        if (txtdate.Text.Trim() == "")
        {
            lblmsg.Text = "Please Select Due Date";
            txtdate.Focus();
            return false;
        }
        if (txtdate1.Text.Trim() == "")
        {
            lblmsg.Text = "Please Select Next Date";
            txtdate1.Focus();
            return false;
        }
        return true;
    }
    
    protected void txtdate_TextChanged(object sender, EventArgs e)
    {
        if (txtdate.Text != "")
        {
            if (ddlCaliType.SelectedItem.Text == "Annually")
            {
                DateTime dt = Util.GetDateTime(txtdate.Text);
                dt = dt.AddMonths(12);
                txtdate1.Text = dt.ToString("dd-MMM-yyyy");
            }
            else
            {
                DateTime dt = Util.GetDateTime(txtdate.Text);
                dt = dt.AddMonths(6);
                txtdate1.Text = dt.ToString("dd-MMM-yyyy");
            }
        }
        mpeCreateGroup.Show();
    }

    protected void btnClose_Click(object sender, EventArgs e)
    {
        Clear();
    }

    protected void grdSupplierType_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblActive")).Text == "1")
            {
                ((ImageButton)e.Row.FindControl("imbEdit")).Visible = true;
            }
            else
            {
                ((ImageButton)e.Row.FindControl("imbEdit")).Visible = false;
            }

        }
        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    if (((Label)e.Row.FindControl("lblActive")).Text == "1")
        //    {

        //        ((ImageButton)e.Row.FindControl("imbSelect")).Visible = false;
        //    }
        //    else
        //    {
        //        ((ImageButton)e.Row.FindControl("imbSelect")).Visible = true;
        //    }

        //}
    }
}

