using System;
using System.Collections.Generic;
using AjaxControlToolkit;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web.Services;

public partial class Design_OPD_OPD_Investigation_Booking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtBookingDate.Text =  System.DateTime.Now.ToString("dd-MMM-yyyy");
            Calendarextender1.StartDate = System.DateTime.Now;

            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["dtItem"] = GetItem();
        }
        ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindData();
    }
    protected void BindData()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.PatientID,PName,Age,pm.Mobile,House_NO,fpm.Company_Name FROM Patient_Master PM  ");
            sb.Append(" INNER JOIN f_Panel_Master fpm ON PM.PanelID=fpm.PanelID ");

            if (txtFolderNo.Text != "")
            {
                sb.Append(" WHERE pm.PatientID ='" + txtFolderNo.Text.Trim().ToString() + "' ");
            }
            else
            {
                lblMsg.Text = "Enter Patient UHID.";
                return;
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                gdvList.DataSource = dt;
                gdvList.DataBind();
            }
            else
            {
                lblMsg.Text = "No Record Found.";
                gdvList.DataSource = null;
                gdvList.DataBind();
            }
            // getSearchhideandshow(0);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void gdvList_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        ViewState["Patient_ID"] = e.CommandArgument.ToString();
        sb.Append(" SELECT PatientID,PName,Age,pm.Mobile,House_NO,fpm.Company_Name,cm.CentreName FROM Patient_Master PM  ");
        sb.Append(" INNER JOIN f_Panel_Master fpm ON PM.PanelID=fpm.PanelID ");
        sb.Append(" INNER JOIN center_master cm ON cm.CentreID=pm.CentreID ");
        sb.Append(" Where pm.PatientID ='" + ViewState["Patient_ID"] + "' ");
        DataTable dtdetail = StockReports.GetDataTable(sb.ToString());
        if (dtdetail.Rows.Count > 0)
        {
            lblFolderNo.Text = dtdetail.Rows[0]["PatientID"].ToString();
            lblPatientName.Text = dtdetail.Rows[0]["PName"].ToString();
            lblPanel.Text = dtdetail.Rows[0]["Company_Name"].ToString();
            lblContactNo.Text = dtdetail.Rows[0]["Mobile"].ToString();
            lblAge.Text = dtdetail.Rows[0]["Age"].ToString();
            lblAddress.Text = dtdetail.Rows[0]["House_NO"].ToString();
            lblCentre.Text = dtdetail.Rows[0]["CentreName"].ToString();
        }
        if (e.CommandName == "ShowDetails")
        {
            divPrescription.Visible = true;
            divDetails.Visible = true;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            foreach (GridViewRow gr in grvDig.Rows)
            {
                string sql = "Insert Into PATIENT_TEST(Test_ID,Quantity,Name,PatientID,DoctorID,CreatedBy,PrescribeDate,configID,IsReqFromHelpDeskDept) ";
                sql += " Values ('" + ((Label)gr.FindControl("lblItemId")).Text.Trim() + "','" + ((Label)gr.FindControl("lblQty")).Text.Trim() + "','" + ((Label)gr.FindControl("lblItemName")).Text.Trim() + "', ";
                sql += " '" + lblFolderNo.Text + "',532,'" + Session["ID"].ToString() + "','" + Util.GetDateTime(Util.GetDateTime(txtBookingDate.Text)).ToString("yyyy-MM-dd") + "',3,1)";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }

            tnx.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            grvDig.DataSource = null;
            grvDig.DataBind();
            pnlHide.Visible = false;
            DivButton.Visible = false;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            lblMsg.Text = "Error Occured. Contact to Administrator.";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
            clear(0);
        }
    }
    

    protected void btnAddPrescription_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        try
        {
            if (string.IsNullOrEmpty(txtQty.Text) || Util.GetInt(txtQty.Text) <= 0)
            {
                lblMsg.Text = "Enter Valid Qty of Item '" + txtDig.Text + "'";
                return;
            }
            else
            {
                lblMsg.Text = "";
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.ItemID ItemId,im.Typename ItemName FROM f_itemmaster im  ");
            sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.subcategoryid ");
            sb.Append("  INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.categoryid  ");
            sb.Append(" INNER JOIN f_configrelation cfg ON cfg.categoryid=cm.categoryid WHERE cfg.configID IN (3) AND im.isactive=1 ");
            sb.Append(" and im.TypeName ='" + txtDig.Text + "'");
            sb.Append(" ORDER BY im.typename ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            DataTable dtItem = new DataTable();
            if (ViewState["dtItem"] != null)
            {

                dtItem = (DataTable)ViewState["dtItem"];
                if (dtItem != null && dtItem.Rows.Count > 0)
                {
                    string str = dt.Rows[0]["ItemId"].ToString();
                    foreach (DataRow drItem in dtItem.Rows)
                    {
                        if (str == drItem["ItemId"].ToString())
                        {
                            lblMsg.Text = "Item Already Added";
                            return;
                        }
                    }
                }
                dtItem.AcceptChanges();
            }
            else
                dtItem = GetItem();

            DataRow dr = dtItem.NewRow();
            dr["ID"] = dt.Rows[0]["ItemId"].ToString();
            dr["ItemId"] = dt.Rows[0]["ItemId"].ToString();
            dr["ItemName"] = dt.Rows[0]["ItemName"].ToString();
            dr["Qty"] = txtQty.Text;
            dr["Date"] = txtBookingDate.Text;

            dtItem.Rows.Add(dr);

            ViewState.Add("dtItems", dtItem);
            if (dtItem.Rows.Count > 0)
            {
                grvDig.DataSource = dtItem;
                grvDig.DataBind();
                btnSave.Visible = true;
                DivButton.Visible = true;
                pnlHide.Visible = true;
                txtDig.Text = "";
                txtBookingDate.Enabled = false;
            }
            else
            {
                DivButton.Visible = true;
                btnSave.Visible = false;
                txtBookingDate.Enabled = true;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Dispose();
        }
    }

    private DataTable GetItem()
    {
        if (ViewState["dtItem"] != null)
        {
            return (DataTable)ViewState["dtItem"];
        }
        else
        {
            DataTable dtItem = new DataTable();
            dtItem.Columns.Add("ID");
            dtItem.Columns.Add("ItemId");
            dtItem.Columns.Add("ItemName");
            dtItem.Columns.Add("Qty");
            dtItem.Columns.Add("Date");
            return dtItem;
        }
    }

    protected void grvDig_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["dtItems"];
            dtItem.Rows[args].Delete();
            dtItem.AcceptChanges();
            grvDig.DataSource = dtItem;
            grvDig.DataBind();
            ViewState["dtItem"] = dtItem;
            if (dtItem.Rows.Count == 0)
            {
                btnSave.Visible = false;
                DivButton.Visible = false;
                pnlHide.Visible = false;
                txtBookingDate.Enabled = true;
            }
        }
    }


    public void clear(int i)
    {
        if (i == 0)
        {
            grvDig.DataSource = null;
            grvDig.DataBind();
            pnlHide.Visible = false;
            DivButton.Visible = false;
            divPrescription.Visible = false;
            divDetails.Visible = false;
            gdvList.DataSource = null;
            gdvList.DataBind();
            txtFolderNo.Text = "";
            lblFolderNo.Text = "";
            lblPatientName.Text = "";
            lblPanel.Text = "";
            lblAge.Text = "";
            lblCentre.Text = "";
            lblAddress.Text = "";
            ViewState["dtItem"] = null;
            GetItem();
            lblMsg.Text = "Record Saved Successfully";
        }
        else
        {
            Response.Redirect(Request.RawUrl);
        }
    }

    protected void btnCancel_Click(object sender, System.EventArgs e)
    {
        clear(1);
    }

    [WebMethod(EnableSession = true)]
    public static string GetPatientBookingReport(string patientID, string Fromdate, string Todate)
    {
        Fromdate = Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd");
        Todate = Util.GetDateTime(Todate).ToString("yyyy-MM-dd");

        StringBuilder sqlCMD = new StringBuilder();

        sqlCMD.Append(" SELECT DATE_FORMAT(pt.PrescribeDate,'%d-%b-%Y')BookedFor,IF(pt.IsIssue=1,'Billing Done','Pending for Billing')STATUS,pt.PatientID, ");
        sqlCMD.Append(" CONCAT(pm.Title,' ',pm.PName)PName,pm.Age,pm.Gender,pm.House_No address,pm.Mobile, ");
        sqlCMD.Append(" pt.NAME Test,CONCAT(DATE_FORMAT(pt.createdDate,'%d-%b-%Y'),' ',TIME_FORMAT(pt.createdDate,'%h:%i %p'))Bookedon,CONCAT(em.Title,' ',em.NAME)BookedBy ");
        sqlCMD.Append(" FROM patient_test pt ");
        sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID = pt.PatientID  ");
        sqlCMD.Append(" INNER JOIN employee_master em ON em.EmployeeID=pt.CreatedBy ");
        sqlCMD.Append(" WHERE pt.IsReqFromHelpDeskDept=1 And pt.IsActive=1  ");        
        if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" and pt.PatientID=@patientID");
        if (!string.IsNullOrEmpty(Fromdate) && !string.IsNullOrEmpty(Todate))
        {
            sqlCMD.Append(" and Date(pt.PrescribeDate)>='" + Fromdate + "' AND Date(pt.PrescribeDate)<='" + Todate + "' ");
        }
        sqlCMD.Append(" ORDER BY PatientTest_id DESC ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {            
            patientID = patientID
        });

        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();

            HttpContext.Current.Session["ReportName"] = "OPD Investigation Booking Report";
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["Period"] = "Period From Date : " + Fromdate + " To Date : " + Todate;

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = dt });
    }

    [WebMethod(EnableSession = true)]
    public static string GetPatientBookingDetails(string patientID, string Fromdate, string Todate)
    {
        Fromdate = Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd");
        Todate = Util.GetDateTime(Todate).ToString("yyyy-MM-dd");

        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT DATE_FORMAT(pt.PrescribeDate,'%d-%b-%Y')BookedFor,pt.PatientID, ");
        sqlCMD.Append(" CONCAT(pm.Title,' ',pm.PName)PName,pm.Age,pm.Gender,pm.House_No address,pm.Mobile, ");
        sqlCMD.Append(" CONCAT(DATE_FORMAT(pt.createdDate,'%d-%b-%Y'),' ',TIME_FORMAT(pt.createdDate,'%h:%i %p'))Bookedon,CONCAT(em.Title,' ',em.NAME)BookedBy ");
        sqlCMD.Append(" FROM patient_test pt ");
        sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID = pt.PatientID  ");
        sqlCMD.Append(" INNER JOIN employee_master em ON em.EmployeeID=pt.CreatedBy ");
        sqlCMD.Append(" WHERE pt.IsReqFromHelpDeskDept=1  ");
        if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" and pt.PatientID=@patientID");
        if (!string.IsNullOrEmpty(Fromdate) && !string.IsNullOrEmpty(Todate))
        {
            sqlCMD.Append(" and Date(pt.PrescribeDate)>='" + Fromdate + "' AND Date(pt.PrescribeDate)<='" + Todate + "' And pt.IsIssue=0 And pt.IsActive=1 ");
        }
        sqlCMD.Append(" Group by pt.PatientID,pt.PrescribeDate ORDER BY PatientTest_id DESC ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {            
            patientID = patientID
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string GetBookingDetails(string BookingDate, string PatientID)
    {
        BookingDate = Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd");

        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT PatientTest_ID,PatientID,DATE_FORMAT(pt.PrescribeDate,'%d-%b-%Y')PrescribeDate,Name as TestName FROM patient_test pt  ");
        sqlCMD.Append(" WHERE pt.PatientID=@patientID AND pt.PrescribeDate='" + BookingDate + "' AND pt.IsActive=1 AND pt.IsIssue=0 AND pt.IsReqFromHelpDeskDept=1 ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {            
            PatientID = PatientID
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string cancelBookingItem(string PatientTest_ID, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string sqlCMD = " UPDATE patient_test pt SET pt.IsActive=0, pt.Remarks= @Remarks, DeptBookingRejectedBy=@userID,DeptBookingRejectedDate= now() WHERE pt.PatientTest_ID=@PatientTest_ID ";           

            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            { 
                Remarks = Remarks,
                userID = HttpContext.Current.Session["ID"].ToString(),
                PatientTest_ID = PatientTest_ID
            });          

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}