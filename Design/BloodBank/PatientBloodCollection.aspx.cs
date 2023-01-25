using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class Design_BloodBank_PatientBloodCollection : System.Web.UI.Page
{
    [WebMethod]
    public static string bindLocation()
    {

        try
        {


            DataTable dt = StockReports.GetDataTable(" SELECT cm.IPDCaseTypeID ID,cm.Name FROM ipd_case_type_master cm WHERE cm.IsActive=1 AND cm.CentreID='" + HttpContext.Current.Session["CentreID"] + "'");

            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else { return "0"; }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }


    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            lblSession.Text = Session["CentreID"].ToString();
            ViewState["CenterID"] = Util.GetString(Session["CentreID"].ToString());
        }
        txtdatefrom.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
    }
    [WebMethod]
    public static string getDoctorOrderReport(string date, string Todate, string fromTime, string toTime, string Location)
    {
        TimeSpan CompareFromDate = TimeSpan.Parse(Util.GetDateTime(fromTime).ToString("hh:mm"));
        TimeSpan CompareToTime = TimeSpan.Parse(Util.GetDateTime(toTime).ToString("hh:mm"));
        var message = string.Empty;
        string datetimefrom = date + " " + fromTime;
        string datetimeto = Todate + " " + toTime;

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.* FROM ");
        sb.Append(" ( ");
        sb.Append(" SELECT pm.PatientID as UHID,pm.Pname as PatientName,pm.Age,pm.Gender,ItemName,plo.Patient_Type  as PatientType,pmh.TransNo'IPD No.',CONCAT(icm.NAME,'/',rm.Room_No,'/',rm.Bed_No)Ward,CONCAT((DATE_FORMAT(plo.ServiceDate,'%d-%b-%y')),' ',(DATE_FORMAT(plo.ServiceTime,'%h:%m %p')))'Prescribe Date/Time' ");
        sb.Append("  ");
        sb.Append(" FROM ipdservices_request plo   ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=plo.TransactionID  ");
        sb.Append(" INNER JOIN patient_ipd_profile pip ON pmh.TransactionId=pip.TransactionID  ");
        sb.Append(" INNER JOIN room_master rm ON rm.RoomID=pip.RoomID ");
        sb.Append(" INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=pip.IPDCaseTypeID ");
        sb.Append(" Left JOIN bb_collection_details bbc ON bbc.LedgerTransactionNo = plo.LedgerTnxNo ");

        sb.Append(" WHERE bbc.LedgerTransactionNo IS NULL and");
        sb.Append("  CONCAT((DATE_FORMAT(plo.ServiceDate,'%Y-%m-%d')),' ',  (TIME_FORMAT(plo.ServiceTime,'%H:%i:%s'))) >= DATE_FORMAT('" + 
            Util.GetDateTime(datetimefrom).ToString("yyyy-MM-dd HH:mm:ss") + "' ,'%Y-%m-%d %H:%i:%s')"+
        "    AND CONCAT((DATE_FORMAT(plo.ServiceDate,'%Y-%m-%d')),' ',  (TIME_FORMAT(plo.ServiceTime,'%H:%i:%s'))) <= DATE_FORMAT('" + 
        Util.GetDateTime(datetimeto).ToString("yyyy-MM-dd HH:mm:ss") + "','%Y-%m-%d %H:%i:%s')   AND");

        sb.Append(" plo.CentreID = '" + HttpContext.Current.Session["CentreID"] + "'  ");
        if (Location != "0" && !string.IsNullOrEmpty(Location.Trim()))
        {
            sb.Append(" AND  icm.IPDCaseTypeID='" + Location.Trim() + "'   ");
        }
        sb.Append(")t ");
       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Blood Collection Report";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Record Found" });
        }
    } 

    private void search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.PatientID,pmh.TransactionID,IF(pmh.type IN ('IPD','EMG'),REPLACE(pmh.TransNo,'ISHHI',''),'') AS IPDNo,pmh.Type,CONCAT(pm.Title,'',pm.PName)Pname,CONCAT(pm.Age,pm.Gender)AgeSex,pm.BloodGroup,ltd.ItemName , DATE_FORMAT(lt.date,'%d-%b-%Y')dtEntry, lt.LedgerTransactionNo,");
            sb.Append(" CONCAT((SELECT NAME FROM ipd_case_type_Master WHERE IPDCaseTypeID=(SELECT IPDCaseTypeID FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID LIMIT 1)),'/', ");
            sb.Append(" (SELECT bed_no FROM room_master WHERE roomid=(SELECT roomid FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID LIMIT 1)))ward,IF(bbc.LedgerTransactionNo IS NULL,0,1)isCollected ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=ltd.ItemID ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ltd.TransactionID ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
            sb.Append(" LEFT JOIN bb_collection_details bbc ON bbc.LedgerTransactionNo = lt.LedgerTransactionNo ");        
            sb.Append(" WHERE ltd.ConfigID =7 AND ltd.IsVerified<>2 AND lt.IsCancel=0 ");
            if (txtIPDNo.Text.Trim() == string.Empty && txtPatientId.Text.Trim() == string.Empty && txtName.Text.Trim() == string.Empty)
            {
                if (txtdatefrom.Text != "")
                {
                    sb.Append(" AND lt.Date >='" + Util.GetDateTime(txtdatefrom.Text).ToString("yyyy-MM-dd") + "'");
                }
                if (txtdateTo.Text != "")
                {
                    sb.Append(" AND lt.Date <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + "'  ");
                }
            }
            if (rdbType.SelectedValue != "ALL")
            {
                if (rdbType.SelectedValue == "OPD")
                {
                    sb.Append(" AND IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')='OPD' ");
                }
                else if (rdbType.SelectedValue == "EMG")
                {
                    sb.Append(" AND lt.TypeOfTnx IN ('Emergency') AND pmh.Type='EMG' ");
                }
                else
                {
                    sb.Append(" AND IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')='IPD' AND pmh.Type='IPD' ");
                }
            }
            if (txtIPDNo.Text.Trim() != string.Empty)
            {
                //sb.Append(" AND ltd.TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
                sb.Append(" AND pmh.TransNo=" + txtIPDNo.Text.Trim() + " AND pmh.Type='IPD' ");
            }
            if (txtPatientId.Text.Trim() != string.Empty)
            {
                sb.Append(" AND lt.PatientID= '" + txtPatientId.Text + "'");
            }
            if (txtName.Text.Trim() != string.Empty)
            {
                sb.Append(" AND pm.Pname like '" + txtName.Text.Trim() + "%' ");
            }

            sb.Append(" and IF(" + rbtSampleType.SelectedValue + "=0,bbc.LedgerTransactionNo IS NULL,bbc.LedgerTransactionNo IS NOT NULL) AND ltd.`CentreID`=" + Util.GetInt(ViewState["CenterID"]) + "  ");
            sb.Append(" GROUP BY lt.LedgerTransactionNo ORDER BY lt.Date,lt.LedgerTransactionNo ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdPatient.DataSource = dt;
                grdPatient.DataBind();
                pnlHide.Visible = true;
                divSave.Visible = true;
            }
            else
            {
                grdPatient.DataSource = dt;
                grdPatient.DataBind();
                pnlHide.Visible = false;
                divSave.Visible = false;
                Page.ClientScript.RegisterStartupScript(this.GetType(), "M1", "$(function () { modelAlert('No Record Found',function(){ })  });", true); 
            }
            if (rbtSampleType.SelectedValue == "1")
                btnSave.Visible = false;
            else
                btnSave.Visible = true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            grdPatient.DataSource = null;
            grdPatient.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        saveCollectionRecord();
    }
    private void saveCollectionRecord()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        StringBuilder sb = new StringBuilder();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
             int i = 0;
           
            
             for (i = 0; i < grdPatient.Rows.Count; i++)
             {
                 var BloodCollectionID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT bb_id_master('" + lblSession.Text + "','BCP')"));
                 if (((CheckBox)grdPatient.Rows[i].FindControl("chkSelect")).Checked)
                 {
                     var PatientID=((Label)grdPatient.Rows[i].FindControl("lblPatientID")).Text;
                     var TransactionID= ((Label)grdPatient.Rows[i].FindControl("lblTransactionID")).Text;
                     var LedgerTransactionNo= ((Label)grdPatient.Rows[i].FindControl("lblLedgerTransactionNo")).Text;

                     sb.Append(" INSERT INTO bb_collection_details (Visitor_Id,Visit_ID,BloodCollection_Id,CollectedDate,CollectedBy,IsPatient,LedgerTransactionNo,CentreID) ");
                     sb.Append(" VALUES('" + PatientID + "','" + TransactionID + "','" + BloodCollectionID + "',NOW(),'" + ViewState["ID"].ToString() + "',1,'" + LedgerTransactionNo + "'," + Util.GetInt(ViewState["CenterID"]) + ") ");//lblSession.Text
                     MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                 }
                 sb.Clear();
             }
             tranX.Commit();
             Page.ClientScript.RegisterStartupScript(this.GetType(), "M2", "$(function () { modelAlert('Record Save Sucessfully',function(){ })  });", true);
             clear(); 
            search();
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void clear()
    {
        txtName.Text = "";
        txtIPDNo.Text = string.Empty;
        txtPatientId.Text = string.Empty;
    }

    protected void grdPatient_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblIsCollected")).Text == "1")
                e.Row.BackColor = System.Drawing.Color.LightGreen;
        }
    }
}