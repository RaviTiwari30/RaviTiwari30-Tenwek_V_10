using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.Drawing;

public partial class Design_Transport_IssueVehicle : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindDepartment();
            bindVehicle();
            bindDriver();
            BindApproval();
            tr_issuePatient1.Visible = true; tr_issuePatient2.Visible = true; tr_issuePatient3.Visible = true;
            tr_issueDepartment.Visible = false;
        }
        txtFromDate.Attributes.Add("ReadOnly", "true");
        txtToDate.Attributes.Add("ReadOnly", "true");
        txtIssueDriverContact1.Attributes.Add("Disabled", "true");
        txtIssueDriverContact2.Attributes.Add("Disabled", "true");
    }

    private void BindApproval()
    {
        DataTable dt = StockReports.GetDataTable("SELECT da.id,da.ApprovalType FROM f_discountapproval da WHERE Isactive=1");

        if (dt.Rows.Count > 0)
        {
            ddlApprovedBy.DataTextField = "VehicleName";
            ddlApprovedBy.DataValueField = "ID";
            ddlApprovedBy.DataBind();
            ddlApprovedBy.Items.Insert(0, new ListItem("select", "0"));
            ddlApprovedBy.SelectedIndex = 0;
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        issueVehicle.Visible = false;
        DataTable dtRequest = dtTransportRequest();
        if (dtRequest.Rows.Count > 0)
        {
            lblMsg.Text = dtRequest.Rows.Count + " Record(s) Found";
            gvResult.DataSource = dtRequest;
            gvResult.DataBind();
            showResults.Visible = true;
        }
        else
        {
            lblMsg.Text = "No Record Found";
            showResults.Visible = false;
        }
    }

    public DataTable dtTransportRequest()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT tr.TokenNo,tr.Comment,DATE_FORMAT(tr.BookingDate,'%d-%b-%Y %h:%i %p')BookingDate,tr.Status,IF(tr.IsDept=1,Concat(tr.`DeptName`,' ( Dept )'),Concat(tr.`PName`,' ( Patient )'))TYPE,CONCAT(IFNULL(tr.Address,''),' ',IFNULL(tr.City,'')) 'DestinationAddress',DATE_FORMAT(tr.CreatedDate,'%d-%b-%Y')'CreatedDate', ");
        sb.Append(" (SELECT CONCAT(em.Title,' ',em.Name) FROM employee_master em WHERE  em.EmployeeID=tr.CreatedBy)'CreatedBy',if(tr.Status='0','True','False') chkStatus,(CASE WHEN tr.Status='0' THEN 'True' WHEN tr.Status='1' THEN 'True' ELSE 'False' END) chkReject,if(tr.Status='1','True','False') chkIssued, ");

        sb.Append("  IF( (SELECT IF( COUNT(vrm.`ID`)>0,1,0 )FROM t_VehicleReading_Master  ");
        sb.Append(" vrm WHERE vrm.`VehicleID`=tr.`VehicleID` AND vrm.`ReadingTypeID` IN(1,2))>0,  ");
        sb.Append(" IF((SELECT IF( COUNT(vrm.`ID`)>0,1,0 )FROM t_VehicleReading_Master vrm WHERE vrm.`VehicleID`=tr.`VehicleID` AND vrm.`ReadingTypeID`=1)=1,1,  ");
        sb.Append("   IF((SELECT IF( COUNT(vrm.`ID`)>0,1,0 )FROM t_VehicleReading_Master vrm WHERE vrm.`VehicleID`=tr.`VehicleID` AND vrm.`ReadingTypeID`=2)=1,2,1))  ");
        sb.Append("  ,1) ReadingTypeIdtoSelect ,IF((tr.`IsAck`=1 && tr.`IsDept`=1),'True','False') CanAckPrint ");


        sb.Append(" FROM t_transport_request tr WHERE tr.BookingDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' and tr.CentreID=" + Util.GetInt(Session["CentreID"]) + " ");
        sb.Append(" AND tr.BookingDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (ddlStatus.SelectedItem.Value != "All")
            sb.Append(" AND tr.Status='" + ddlStatus.SelectedItem.Value + "' ");
        if (txtTokenNo.Text != "")
            sb.Append(" AND tr.TokenNo='" + txtTokenNo.Text.Trim() + "' ");
        if (rblRequisitionFrom.SelectedItem.Value == "0")
        {
            sb.Append(" AND tr.IsDept=0 ");
            if (txtMRNo.Text != "")
                sb.Append(" tr.PatientID='" + txtMRNo.Text.Trim() + "'");
            if (txtPatientName.Text != "")
                sb.Append(" tr.PName='" + txtPatientName.Text.Trim() + "' ");
        }
        if (rblRequisitionFrom.SelectedItem.Value == "1")
        {
            sb.Append(" AND tr.IsDept=1 ");
            if (ddlFromDept.SelectedItem.Value != "0")
                sb.Append(" AND tr.DeptLedgerNo='" + ddlFromDept.SelectedItem.Value + "'");
        }

        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    private void bindDepartment()
    {
        ddlFromDept.DataSource = StockReports.GetDataTable("SELECT RoleName DeptName,DeptLedgerNo FROM f_rolemaster WHERE IFNULL(DeptLedgerNo,'')<>''  AND Active=1 ORDER BY RoleName ");
        ddlFromDept.DataTextField = "DeptName";
        ddlFromDept.DataValueField = "DeptLedgerNo";
        ddlFromDept.DataBind();
        ddlFromDept.Items.Insert(0, new ListItem("All", "0"));
    }
    private void bindVehicle()
    {
        ddlIssueVehicle.ClearSelection();
        ddlIssueVehicle.DataSource = StockReports.GetDataTable("SELECT CONCAT(vm.`VehicleName`,'(',vm.`VehicleNo`,')')VehicleName,vm.`ID` FROM `t_vehicle_master` vm WHERE vm.`IsActive`=1 AND vm.`Status`=0 and CentreID=" + Util.GetInt(Session["CentreID"]) + "");
        ddlIssueVehicle.DataTextField = "VehicleName";
        ddlIssueVehicle.DataValueField = "ID";
        ddlIssueVehicle.DataBind();
        ddlIssueVehicle.Items.Insert(0, new ListItem("select", "0"));
        ddlIssueVehicle.SelectedIndex = 0;
    }
    private void bindDriver()
    {
        ddlIssueDriver.ClearSelection();
        ddlIssueDriver.DataSource = StockReports.GetDataTable("SELECT dm.`Name`,CONCAT(dm.`ID`,'#',IFNULL(dm.phone,''),'#',IFNULL(dm.Mobile,''))ID FROM t_driver_master dm WHERE dm.`IsActive`=1 AND dm.`Status`=0 and CentreID=" + Util.GetInt(Session["CentreID"]) + "");
        ddlIssueDriver.DataTextField = "Name";
        ddlIssueDriver.DataValueField = "ID";
        ddlIssueDriver.DataBind();
        ddlIssueDriver.Items.Insert(0, new ListItem("select", "0"));
        ddlIssueDriver.SelectedIndex = 0;

    }
    protected void gvResult_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatus")).Text == "0")//pendding status
            {
                e.Row.BackColor = Color.FromName("#F89406");
            }
            else if (((Label)e.Row.FindControl("lblStatus")).Text == "1")//Issue status
            {
                e.Row.BackColor = Color.FromName("#3CB371");
            }
            else if (((Label)e.Row.FindControl("lblStatus")).Text == "2")//expired status
            {
                e.Row.BackColor = System.Drawing.Color.FromArgb(99, 99, 66);
            }
            else if (((Label)e.Row.FindControl("lblStatus")).Text == "3")//rejected status
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
            }
        }
    }
    protected void gvResult_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Select")
        {

            string TokenNo = e.CommandArgument.ToString();
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT tr.TokenNo, IFNULL(tr.PatientID,'') 'MRNo',IFNULL(tr.PName,'')PName,CONCAT(tr.Age,'/',tr.Gender)AgeSex,IFNULL(tr.Mobile,'')Mobile, ");
            sb.Append(" CONCAT(tr.Address,' ',tr.city)Destination,tr.IsDept,IFNULL(tr.DeptName,'')Department,IFNULL(tr.DeptLedgerNo,'')DeptLedgerNo, ");
            sb.Append("  IF( (SELECT IF( COUNT(vrm.`ID`)>0,1,0 )FROM t_VehicleReading_Master  ");
            sb.Append(" vrm WHERE vrm.`VehicleID`=tr.`VehicleID` AND vrm.`ReadingTypeID` IN(1,2))>0,  ");
            sb.Append(" IF((SELECT IF( COUNT(vrm.`ID`)>0,1,0 )FROM t_VehicleReading_Master vrm WHERE vrm.`VehicleID`=tr.`VehicleID` AND vrm.`ReadingTypeID`=1)=1,1,  ");
            sb.Append("   IF((SELECT IF( COUNT(vrm.`ID`)>0,1,0 )FROM t_VehicleReading_Master vrm WHERE vrm.`VehicleID`=tr.`VehicleID` AND vrm.`ReadingTypeID`=2)=1,2,1))  ");
            sb.Append("  ,1) ReadingTypeIdtoSelect ,  ");

            sb.Append(" DATE_FORMAT(tr.BookingDate,'%d-%b-%Y')BookingDate FROM t_transport_request tr WHERE tr.TokenNo='" + TokenNo + "' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                issueVehicle.Visible = true;
                lblIssueTokenNo.Text = dt.Rows[0]["TokenNo"].ToString();
                if (dt.Rows[0]["IsDept"].ToString() == "1")
                {
                    tr_issuePatient1.Visible = false; tr_issuePatient2.Visible = false; tr_issuePatient3.Visible = false;
                    tr_issueDepartment.Visible = true;
                    lblIssueFromDepartment.Text = StockReports.ExecuteScalar("SELECT LedgerName FROM f_ledgermaster WHERE ledgernumber='" + dt.Rows[0]["DeptLedgerNo"].ToString() + "' AND GroupID='DPT'");

                    rblMeaterReadingType.SelectedValue = Util.GetString(dt.Rows[0]["ReadingTypeIdtoSelect"].ToString());

                }
                else
                {
                    tr_issuePatient1.Visible = true; tr_issuePatient2.Visible = true; tr_issuePatient3.Visible = true;
                    tr_issueDepartment.Visible = false;

                    lblIssueMRNo.Text = dt.Rows[0]["MRNo"].ToString();
                    lblIssueAgeSex.Text = dt.Rows[0]["AgeSex"].ToString();
                    lblIssuePatientMobile.Text = dt.Rows[0]["Mobile"].ToString();
                    lblIssuePatientName.Text = dt.Rows[0]["PName"].ToString();

                    lblIssueAddress.Text = dt.Rows[0]["Destination"].ToString();

                    rblMeaterReadingType.SelectedValue = Util.GetString(dt.Rows[0]["ReadingTypeIdtoSelect"].ToString());

                }
            }
            else
            {
                issueVehicle.Visible = false;
            }

        }
        if (e.CommandName == "Reject")
        {
            lblRejectTokenNo.Text = Util.GetString(e.CommandArgument).Split('#')[0];
            hdrejectionSatus.Value = Util.GetString(e.CommandArgument).Split('#')[1];
            mpReject.Show();

        }
        if (e.CommandName == "Print")
        {
            printIssue(Util.GetString(e.CommandArgument));
        }
        if (e.CommandName == "AckPrint")
        {
            AckprintIssue(Util.GetString(e.CommandArgument));
        }
    }
    protected void btnIssue_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("UPDATE t_transport_request SET VehicleID='" + ddlIssueVehicle.SelectedValue + "',ReadingTypeID='" + rblMeaterReadingType.SelectedValue + "',DriverID='" + ddlIssueDriver.SelectedValue.Split('#')[0].Trim() + "',Status=1,IssueDate=NOW(),IssueBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "' WHERE TokenNo='" + lblIssueTokenNo.Text.Trim() + "'");
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
            sb.Clear();
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "UPDATE t_vehicle_master SET Status=1 where ID='" + ddlIssueVehicle.SelectedItem.Value + "'");
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "UPDATE t_driver_master SET Status=1 where ID='" + ddlIssueDriver.SelectedValue.Split('#')[0].Trim() + "'");
            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Record Updated Successfully!";
            showResults.Visible = false;
            bindVehicle();
            bindDriver();
            printIssue(lblIssueTokenNo.Text);
            Clear();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Record Updated Successfully!');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='IssueVehicle.aspx';", true);

        }
        catch (Exception ex)
        {
            tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void btnReject_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("UPDATE t_transport_request SET STATUS='3',RejectionRemark='" + txtRejectReason.Text + "',RejectedDate=NOW(),RejectedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',RejectedAfterIssue='" + hdrejectionSatus.Value + "',RejectionApprovedBy='" + ddlApprovedBy.SelectedValue + "' WHERE TokenNo='" + lblRejectTokenNo.Text.Trim() + "'");
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
            sb.Clear();
            if (hdrejectionSatus.Value == "1")
            {
                sb.Append("UPDATE `t_driver_master`dm INNER JOIN t_transport_request tr ON tr.`DriverID`=dm.`ID` SET dm.`Status`='0' WHERE tr.`TokenNo`='" + lblRejectTokenNo.Text.Trim() + "';");
                sb.Append("UPDATE  t_vehicle_master vm INNER JOIN t_transport_request tr ON tr.`VehicleID`=vm.`ID`  SET vm.`Status`='0' WHERE tr.`TokenNo`='" + lblRejectTokenNo.Text.Trim() + "';");
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
            }
            //  tranx.Commit();
            lblMsg.Text = "Requisition Rejected Successfully";
            txtRejectReason.Text = lblRejectTokenNo.Text = ""; showResults.Visible = false;
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error..."; txtRejectReason.Text = lblRejectTokenNo.Text = "";
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void printIssue(string TokenNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT tr.`TokenNo` TokenNo,IF(tr.`IsDept`=0,CONCAT(IFNULL(tr.`PName`,''),'(',IFNULL(tr.`PatientID`,'New Patient'),')'),CONCAT(IFNULL(tr.`DeptName`,''),' ','Department'))IssuedFor,  ");
        sb.Append(" CONCAT(tr.`Address`,',',tr.`City`)DestinationAddress,DATE_FORMAT(tr.`BookingDate`,'%d-%b-%Y %h:%i %p')'Booking Date',  ");
        sb.Append(" (SELECT CONCAT(vm.`VehicleName`,'(',vm.VehicleNo,')') FROM `t_vehicle_master` vm WHERE vm.`ID`=tr.`VehicleID`)Vehicle,  ");
        sb.Append(" (SELECT dm.`Name` FROM t_driver_master dm WHERE dm.`ID`=tr.`DriverID`)Driver,  ");
        sb.Append(" (SELECT CONCAT(em.`Title`,' ',em.`Name`) FROM employee_master em WHERE em.`EmployeeID`=tr.`IssueBy`)IssuedBy  ");
        sb.Append(" FROM t_transport_request tr WHERE tr.`TokenNo`='" + TokenNo.Trim() + "'  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"E:\\VehicleIssue.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "VehicleIssue";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
    }


    protected void AckprintIssue(string TokenNo)
    {
        StringBuilder sb = new StringBuilder();
         
        sb.Append("  SELECT tr.`TokenNo` TokenNo,  ");
        sb.Append(" IF(tr.`IsDept`=0,CONCAT(IFNULL(tr.`PName`,''),  ");
        sb.Append(" '(',IFNULL(tr.`PatientID`,'New Patient'),')'),CONCAT(IFNULL(tr.`DeptName`,''),' ','Department'))IssuedFor,    ");
        sb.Append(" CONCAT(tr.`Address`,',',tr.`City`)DestinationAddress,DATE_FORMAT(tr.`BookingDate`,'%d-%b-%Y %h:%i %p') BookingDate,  ");
        sb.Append("  (SELECT CONCAT(vm.`VehicleName`,'(',vm.VehicleNo,')') FROM `t_vehicle_master` vm WHERE vm.`ID`=tr.`VehicleID`)Vehicle,  ");
        sb.Append("  (SELECT vm.`VehicleType` FROM `t_vehicle_master` vm WHERE vm.`ID`=tr.`VehicleID`)VehicleType,  ");
        sb.Append("  (SELECT dm.`Name` FROM t_driver_master dm WHERE dm.`ID`=tr.`DriverID`)Driver,  ");
        sb.Append("  (SELECT CONCAT(em.`Title`,' ',em.`Name`) FROM employee_master em WHERE em.`EmployeeID`=tr.`IssueBy`)IssuedBy,  ");
        sb.Append("  tr.`MeterReadingAck`,ROUND(tr.`LastReading`,2)LastReading,tr.`Rate`,tr.`BilledAmount`,tr.`KmRun`   ");

        sb.Append(" FROM t_transport_request tr WHERE tr.`TokenNo`='" + TokenNo.Trim() + "'  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
         //  ds.WriteXmlSchema(@"E:\\AckVehicle.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "VehicleAckPrint";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
    }



    public void Clear()
    {
        lblIssueFromDepartment.Text = "";
        lblIssueMRNo.Text = "";
        lblIssueAgeSex.Text = "";
        lblIssuePatientMobile.Text = "";
        lblIssuePatientName.Text = "";
        lblIssueTokenNo.Text = "";
        lblIssueAddress.Text = "";
        ddlFromDept.SelectedIndex = 0;
        ddlIssueDriver.SelectedIndex = 0;
        ddlIssueVehicle.SelectedIndex = 0;
        showResults.Visible = false;
        issueVehicle.Visible = false;

    }
    protected void ddlIssueVehicle_SelectedIndexChanged(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IF( (SELECT IF( COUNT(vrm.`ID`)>0,1,0 )FROM t_VehicleReading_Master  ");
        sb.Append("  vrm WHERE vrm.`VehicleID`=vm.ID AND vrm.`ReadingTypeID` IN(1,2))>0,  ");
        sb.Append("  IF((SELECT IF( COUNT(vrm.`ID`)>0,1,0 )FROM t_VehicleReading_Master vrm WHERE vrm.`VehicleID`=vm.ID AND vrm.`ReadingTypeID`=1)=1,1,  ");
        sb.Append(" IF((SELECT IF( COUNT(vrm.`ID`)>0,1,0 )FROM t_VehicleReading_Master vrm WHERE vrm.`VehicleID`=vm.ID AND vrm.`ReadingTypeID`=2)=1,2,1))  ");
        sb.Append(" ,1)ReadingTypeIdtoSelect FROM t_vehicle_master vm WHERE vm.id='" + ddlIssueVehicle.SelectedValue + "'  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            rblMeaterReadingType.SelectedValue = Util.GetString(dt.Rows[0]["ReadingTypeIdtoSelect"].ToString());
        }
        else
        {
            rblMeaterReadingType.SelectedValue = "1";
        }

    }
}