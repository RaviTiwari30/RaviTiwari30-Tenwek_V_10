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

public partial class Design_Equipment_Masters_PMS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
        }

        txtduedate.Attributes.Add("readonly", "readonly");
        txtLastDone.Attributes.Add("readonly", "readonly");
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT am.AssetID,am.AssetName,am.AssetTypeID,am.AssetCode,pms.PMSID,IFNULL(PMS.IsActive,0)IsActive FROM eq_asset_master am left JOIN eq_preventiveMS pms ON am.AssetCode=pms.AssetCode  where am.AssetID<>'' ");

            if (txtmachinename.Text.Trim() != "")
            {
                sb.Append("AND AssetName like '" + txtmachinename.Text.Trim() + "%' ");
            }          

            if (txtassestcode.Text.Trim() != "")
            {
                sb.Append("AND am.AssetCode LIKE '" + txtassestcode.Text.Trim() + "%'");
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdpms.DataSource = dt;
                grdpms.DataBind();

            }
            else
            {
                grdpms.DataSource = null;
                grdpms.DataBind();
                lblmsg.Text = "Record Not Found";
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.GeneralLog(ex.Message);
        }
    }
    protected void grdpms_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblmsg.Text = "";
        string PMSID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "Select")
        {
            mpeCreateGroup.Show();
            txtgrdMName.Text = e.CommandArgument.ToString().Split('#')[0];
            txtgrdAcode.Text = e.CommandArgument.ToString().Split('#')[1];
        }
        else if (e.CommandName == "ViewLog")
        {
            try
            {
                lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_preventiveMS WHERE PMSID=" + PMSID);
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
            DataTable dt = StockReports.GetDataTable("Select FrequencyType,MachineName,AssetCode,Date_format(PMSDoneDate,'%d-%b-%Y')PMSDoneDate,Date_format(DueDate,'%d-%b-%Y')DueDate,PMSDeliverables from eq_preventivems where PMSID=" + PMSID);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlfreqncytype.SelectedIndex = ddlfreqncytype.Items.IndexOf(ddlfreqncytype.Items.FindByValue(dt.Rows[0]["FrequencyType"].ToString()));
                txtgrdMName.Text = dt.Rows[0]["MachineName"].ToString();
                txtgrdAcode.Text = dt.Rows[0]["AssetCode"].ToString();
                txtLastDone.Text = dt.Rows[0]["PMSDoneDate"].ToString();
                txtduedate.Text = dt.Rows[0]["DueDate"].ToString();
                txtpmsdlivrable.Text = dt.Rows[0]["PMSDeliverables"].ToString();

                ViewState["PMSID"] = PMSID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
                mpeCreateGroup.Show();
            }
        }

    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (checkvalidation())
        {
            MySqlConnection conn = Util.GetMySqlCon();
            conn.Open();
            MySqlTransaction tnx = conn.BeginTransaction();
            //string already = StockReports.ExecuteScalar("Select MachineName FROM eq_preventiveMS where MachineName= '" + txtgrdMName.Text.Trim() + "'");

            //if (already != "")
            //{

            //    lblmsg.Text = "Machine Name Already Exit ";
            //    return;
            //}
            try
            {

                string str = "";
                int IsActive = 1;
                if (ViewState["IsUpdate"].ToString() == "S")
                {
                    if (Util.GetInt(StockReports.ExecuteScalar("SELECT  COUNT(*) FROM eq_preventivems WHERE  PMSDoneDate='" + Util.GetDateTime(txtLastDone.Text).ToString("yyyy-MM-dd") + "' AND DueDate='" + Util.GetDateTime(txtduedate.Text).ToString("yyyy-MM-dd") + "'")) > 0)
                    {
                        lblmsg.Text = "This Date is Already Used";
                        Clear();
                        return;

                    }

                    str = "insert into eq_preventiveMS(MachineName,AssetCode,FrequencyType,PMSDoneDate,DueDate,PMSDeliverables,LastUpdatedby,UpdateDate,IsActive)";
                    str += "values('" + txtgrdMName.Text + "','" + txtgrdAcode.Text + "','" + ddlfreqncytype.SelectedItem.Text + "','" + Util.GetDateTime(txtLastDone.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtduedate.Text).ToString("yyyy-MM-dd") + "',";
                    str += " '" + txtpmsdlivrable.Text + "','" + ViewState["LastUpdatedby"].ToString() + "',Now()," + IsActive + ")";
                }
                else
                {


                    //      string str1 = " INSERT INTO eq_preventivems_Backup(PMSID,MachineName,AssetCode,FrequencyType,Date_Format(PMSDoneDate,'%d-%b-%y')PMSDoneDate,Date_format(DueDate,'%d-%b-%Y')DueDate, PMSDeliverables,LastUpdatedby,UpdateDate,DataLog,IsActive,InsertDate,Bck_USERID)(SELECT ep.*,'" + Util.GetString(Session["Id"]) + "'  FROM eq_preventivems ep WHERE  PMSID='" + ViewState["PMSID"].ToString() + "')";
                    string str1 = " INSERT INTO eq_preventivems_Backup (PMSID,MachineName,AssetCode,FrequencyType,PMSDoneDate,DueDate,PMSDeliverables,LastUpdatedby,UpdateDate,DataLog,IsActive,InsertDate,Bck_USERID) (SELECT PMSID,MachineName,AssetCode,FrequencyType,DATE_FORMAT(PMSDoneDate,'%Y-%m-%d'),DATE_FORMAT(DueDate,'%Y-%m-%d'), PMSDeliverables,LastUpdatedby,UpdateDate,DataLog,IsActive,InsertDate,'" + Util.GetString(Session["Id"]) + "'  FROM eq_preventivems ep WHERE  PMSID='" + ViewState["PMSID"].ToString() + "')";

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str1);


                    string DataLog = StockReports.ExecuteScalar(" SELECT CONCAT(" +
                       "'LastUpdateby: ',(SELECT NAME FROM employee_master WHERE Employee_ID=fm.LastUpdatedby LIMIT 1), '</BR>" +
                        "Last UpdateDate : ', CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ', TIME_FORMAT(fm.UpdateDate,'%T')),'</BR>" +
                          " Name: ', fm.MachineName,',AssestCode: ',fm.AssetCode," +
                           "', Active : ', IF(fm.IsActive=1,'Yes','No'))DataLog FROM eq_preventiveMS fm ");


                    str = " UPDATE eq_preventiveMS SET MachineName='" + txtgrdMName.Text.Trim() + "',AssetCode='" + txtgrdAcode.Text.Trim() + "',FrequencyType='" + ddlfreqncytype.SelectedItem.Text + "',IsActive=" + IsActive + ",";
                    str += "DueDate='" + Util.GetDateTime(txtduedate.Text).ToString("yyyy-MM-dd") + "',PMSDoneDate='" + Util.GetDateTime(txtLastDone.Text).ToString("yyyy-MM-dd") + "',PMSDeliverables='" + txtpmsdlivrable.Text.Trim() + "',LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),";
                    str += "DataLog =Concat_Ws('</BR></BR>',DataLog,'" + DataLog + "')WHERE PMSID='" + ViewState["PMSID"].ToString() + "'";

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

    private bool checkvalidation()
    {
        if (ddlfreqncytype.SelectedItem.Text == "Select")
        {

            lblmsg.Text = "Please Select Frequency";
            return false;

        }
        if (txtLastDone.Text.Trim() == "")
        {
            lblmsg.Text = "Please Select LastPMSDone";
            return false;
        }
        if (txtduedate.Text.Trim() == "")
        {
            lblmsg.Text = "Please Select Due Date";
            return false;

        }
        return true;


    }

    private void Clear()
    {
        txtgrdMName.Text = "";
        txtgrdAcode.Text = "";
        txtLastDone.Text = "";
        txtduedate.Text = "";
        txtpmsdlivrable.Text = "";
    }
    protected void txtLastDone_TextChanged(object sender, EventArgs e)
    {
        if (txtLastDone.Text != "")
        {
            if (ddlfreqncytype.SelectedItem.Text == "Annually")
            {
                DateTime dt = Util.GetDateTime(txtLastDone.Text);
                dt = dt.AddMonths(12);
                txtduedate.Text = dt.ToString("dd-MMM-yyyy");

            }
            else
            {
                DateTime dt = Util.GetDateTime(txtLastDone.Text);
                dt = dt.AddMonths(6);
                txtduedate.Text = dt.ToString("dd-MMM-yyyy");

            }
        }
        mpeCreateGroup.Show();
    }



    protected void btnClose1_Click(object sender, EventArgs e)
    {
        Clear();
    }



    protected void grdpms_RowDataBound(object sender, GridViewRowEventArgs e)
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


        //        ((ImageButton)e.Row.FindControl("imbSelect")).Visible = true; ;

        //    }
        //}


    }


    protected void btnclose1_Click(object sender, EventArgs e)
    {
        Clear();
    }

}
