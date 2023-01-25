using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_IPDUpdateBillingAndDischarge : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            int CentreID = Util.GetInt(Session["CentreID"].ToString());
            if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                DisableControl();
                AllLoadData_IPD.bindDischargeType(ddlDischargeType);
            }
        }
        lblMsg.Text = "";
    }

    private void DisableControl()
    {
        txtAdmissionDate.Enabled = false;
        txtAdmissionTime.Enabled = false;
        txtBillingDate.Enabled = false;
        txtBillingTime.Enabled = false;
        txtDischargeDate.Enabled = false;
        txtDischargeTime.Enabled = false;
        ddlDischargeType.Enabled = false;
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (!String.IsNullOrWhiteSpace(txtIPDNo.Text))
        {
            DataTable dtab = SearchPatientByIPDNo(txtIPDNo.Text);
            if (dtab.Rows.Count > 0)
                BindDetails(dtab);
            else
                lblMsg.Text = "No Record Found";
        }
        //else if (!String.IsNullOrWhiteSpace(txtMRNo.Text))
        //{
        //    DataTable dtab = SearchPatientByMRNo(txtMRNo.Text);
        //    if (dtab.Rows.Count > 0)
        //        BindDetails(dtab);
        //    else
        //        lblMsg.Text = "No Record Found";
        //}
        else
            lblMsg.Text = "Enter IPD Number";
    }

    private DataTable SearchPatientByIPDNo(string IPDNo)
    {
        if (IPDNo != "")
            IPDNo = StockReports.getTransactionIDbyTransNo(IPDNo.Trim());//"" +
        

        StringBuilder sbSqlCmd = new StringBuilder();
        sbSqlCmd.Append("SELECT PM.PatientID,PM.`PFirstname`,PM.`PLastname`,PMH.`dischargeType`,PMH.`DateOFAdmit`,PMH.`TimeOfAdmit`,");
        sbSqlCmd.Append("PMH.`DateOfDischarge`,PMH.`TimeOfDischarge`,PMH.`BillDate` ");
        sbSqlCmd.Append("FROM Patient_Medical_History PMH ");
        sbSqlCmd.Append("INNER JOIN Patient_Master PM ON PM.`PatientID` = PMH.`PatientID` ");
        sbSqlCmd.Append("WHERE PMH.`TransactionID`='" + IPDNo + "'");

        return StockReports.GetDataTable(Util.GetString(sbSqlCmd));
    }
    private void BindDetails(DataTable dtab)
    {
        DataRow row = dtab.Rows[0];
        txtMRNo.Text = Util.GetString(row["PatientID"]);
        txtFirstname.Text = Util.GetString(row["PFirstname"]);
        txtLastname.Text = Util.GetString(row["PLastname"]);
        txtAdmissionDate.Text = Util.GetDateTime(row["DateOFAdmit"]).ToString("dd-MMM-yyyy");
        txtAdmissionTime.Text = Util.GetDateTime(row["TimeOfAdmit"]).ToString("hh:mm tt");
        txtDischargeDate.Text = Util.GetDateTime(row["DateOfDischarge"]).ToString("dd-MMM-yyyy");
        txtDischargeTime.Text = Util.GetDateTime(row["TimeOfDischarge"]).ToString("hh:mm tt");
        txtBillingDate.Text = Util.GetDateTime(row["BillDate"]).ToString("dd-MMM-yyyy");
        txtBillingTime.Text = Util.GetDateTime(row["BillDate"]).ToString("hh:mm tt");
        ddlDischargeType.SelectedItem.Text = Util.GetString(row["DischargeType"]);
    }

    protected void chkAdmissionDT_CheckedChanged(object sender, EventArgs e)
    {
        if (chkAdmissionDT.Checked)
        {
            txtAdmissionDate.Enabled = true;
            txtAdmissionTime.Enabled = true;
        }
        else
        {
            txtAdmissionDate.Enabled = false;
            txtAdmissionTime.Enabled = false;
        }

    }
    protected void chkDischargeType_CheckedChanged(object sender, EventArgs e)
    {
        if (chkDischargeType.Checked)
            ddlDischargeType.Enabled = true;
        else
            ddlDischargeType.Enabled = false;
    }
    protected void chkDischargeDT_CheckedChanged(object sender, EventArgs e)
    {
        if (chkDischargeDT.Checked)
        {
            txtDischargeDate.Enabled = true;
            txtDischargeTime.Enabled = true;
        }
        else
        {
            txtDischargeDate.Enabled = false;
            txtDischargeTime.Enabled = false;
        }
    }
    protected void chkBillingDT_CheckedChanged(object sender, EventArgs e)
    {
        if (chkBillingDT.Checked)
        {
            txtBillingDate.Enabled = true;
            txtBillingTime.Enabled = true;
        }
        else
        {
            txtBillingTime.Enabled = false;
            txtBillingDate.Enabled = false;
        }
    }

    protected void BtnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            
            string IPDNo = StockReports.getTransactionIDbyTransNo(txtIPDNo.Text.Trim());//"" +

            int i = Update(Tnx, IPDNo);
            Tnx.Commit();
            if (i > 0)
            {
                lblMsg.Text = "Record Updated";
                SetDefault();
                DisableControl();
            }
          
        }
        catch 
        {
            Tnx.Rollback();
            con.Close();
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();

        }
    }

    private int Update(MySqlTransaction tranx, string IPDNo)
    {
        int affectedRows = 0;
        StringBuilder sbSqlCmd = new StringBuilder();
        if (chkDischargeType.Checked)
        {
            sbSqlCmd.Clear();
            string dischargeType = ddlDischargeType.SelectedItem.Text;
            sbSqlCmd.Append("Update Patient_Medical_History SET DischargeType='" + dischargeType + "' Where TransactionID='" + IPDNo + "'");
            
            affectedRows = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, Util.GetString(sbSqlCmd));
        }
        if (chkBillingDT.Checked)
        {
            if (!String.IsNullOrWhiteSpace(txtBillingDate.Text) && !String.IsNullOrWhiteSpace(txtBillingTime.Text))
            {
                string billDate = txtBillingDate.Text;
                string billTime = txtBillingTime.Text;
                string billDateTime = billDate + ' ' + billTime;
                sbSqlCmd.Clear();
                sbSqlCmd.Append("Select pmh.`BillClosedDate`,pmh.`DateOfDischarge`,pmh.`TimeOfDischarge` From Patient_Medical_History pmh  Where pmh.`TransactionID` ='" + IPDNo + "' ");
                              
                DataTable dtab = StockReports.GetDataTable(Util.GetString(sbSqlCmd));

                string billClosedDate = Util.GetString(dtab.Rows[0]["BillClosedDate"]);
                string dischargeDate = Util.GetDateTime(dtab.Rows[0]["DateOfDischarge"]).ToString("yyyy-MM-dd") + ' ' + Util.GetDateTime(dtab.Rows[0]["TimeOfDischarge"]).ToString("HH:mm");

                if (!String.IsNullOrWhiteSpace(dischargeDate) && Util.GetDateTime(dischargeDate) > Util.GetDateTime(billDateTime))
                    lblMsg.Text = "Bill Date Cannot Be Before Discharged Date";
                else if (!String.IsNullOrWhiteSpace(billClosedDate) && Util.GetDateTime(billClosedDate) < Util.GetDateTime(billDateTime))
                    lblMsg.Text = "Bill Date Cannot Be After Bill Finalized Date";
                else
                {
                    sbSqlCmd.Clear();
                    sbSqlCmd.Append("Update Patient_Medical_History SET BillDate = '" + Util.GetDateTime(billDateTime).ToString("yyyy-MM-dd HH:mm") + "' Where `TransactionID` ='" + IPDNo + "'");
                    
                    affectedRows = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, Util.GetString(sbSqlCmd));
                }
            }
            else
                lblMsg.Text = "Enter Bill Date Time";
        }
      
        if (chkDischargeDT.Checked)
        {
            if (!String.IsNullOrWhiteSpace(txtDischargeDate.Text) && !String.IsNullOrWhiteSpace(txtDischargeTime.Text))
            {
                string dischargeDate = txtDischargeDate.Text, dischargeTime = txtDischargeTime.Text, dischargeDT = dischargeDate+' '+dischargeTime;
               
                sbSqlCmd.Clear();
                sbSqlCmd.Append(" SELECT pmh.`BillDate`,pmh.`DateOfAdmit`,pmh.`TimeOfAdmit`,MAX(ltd.`EntryDate`) ItemDate");
                sbSqlCmd.Append(" FROM Patient_Medical_History pmh ");
                sbSqlCmd.Append(" INNER JOIN f_ledgertnxDetail ltd ON pmh.`TransactionID` = ltd.`TransactionID`");
                sbSqlCmd.Append(" WHERE ltd.`IsVerified`=1 AND ltd.`IsPackage`=0 AND pmh.TransactionID='" + IPDNo + "' ");
                
                DataTable dtab = StockReports.GetDataTable(Util.GetString(sbSqlCmd));
              
                string billDate = Util.GetString(dtab.Rows[0]["BillDate"]);
                string admitDate = Util.GetDateTime(dtab.Rows[0]["DateOfAdmit"]).ToString("yyyy-MM-dd") +' ' + Util.GetDateTime(dtab.Rows[0]["TimeOfAdmit"]).ToString("HH:mm");
                string itemDate = Util.GetString(dtab.Rows[0]["ItemDate"]);

                if (!String.IsNullOrWhiteSpace(billDate) && Util.GetDateTime(dischargeDT) > Util.GetDateTime(billDate))
                    lblMsg.Text = "Discharged Date Cannot Be After Bill Date";
                else if (!String.IsNullOrWhiteSpace(admitDate) && Util.GetDateTime(admitDate) > Util.GetDateTime(dischargeDT))
                    lblMsg.Text = "Discharged Date Cannot Be Before Admit Date";
                else if (!String.IsNullOrWhiteSpace(itemDate) && Util.GetDateTime(itemDate) > Util.GetDateTime(Util.GetDateTime(dischargeDT).ToString("yyyy-MM-dd HH:mm:ss")))
                    lblMsg.Text = "Record Cannot Be Updated .... last Item Prescribed at " + Util.GetDateTime(itemDate).ToString("dd-MM-yyyy hh:mm tt");
                else 
                {
                    sbSqlCmd.Clear();
                    sbSqlCmd.Append("Update Patient_Medical_History SET DateOfDischarge='" + Util.GetDateTime(dischargeDate).ToString("yyyy-MM-dd") + "',TimeOfDischarge='" + Util.GetDateTime(dischargeTime).ToString("HH:mm") + "' Where ");
                    sbSqlCmd.Append("TransactionID ='" + IPDNo + "'");
                    affectedRows = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, Util.GetString(sbSqlCmd));

                    sbSqlCmd.Clear();
                    sbSqlCmd.Append("Select MAX(PatientIPDProfile_ID) FROM Patient_IPD_Profile Where TransactionID ='" + IPDNo + "'");
                    
                    string id = StockReports.ExecuteScalar(Util.GetString(sbSqlCmd));

                    sbSqlCmd.Clear();
                    sbSqlCmd.Append("Update Patient_IPD_Profile Set EndDate='" + Util.GetDateTime(dischargeDate).ToString("yyyy-MM-dd") + "', EndTime='" + Util.GetDateTime(dischargeTime).ToString("HH:mm") + "'");
                    sbSqlCmd.Append(" Where PatientIPDProfile_ID = '"+id+"'");
                    affectedRows = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, Util.GetString(sbSqlCmd));
                }
            }
            else
                lblMsg.Text = "Enter Discharged Date Time";
        }
        if (chkAdmissionDT.Checked)
        {
            if (!String.IsNullOrWhiteSpace(txtAdmissionDate.Text) && !String.IsNullOrWhiteSpace(txtAdmissionTime.Text))
            {
                string admissionDate = txtAdmissionDate.Text, admissionTime = txtAdmissionTime.Text;

                sbSqlCmd.Clear();
                sbSqlCmd.Append("Update Patient_Medical_History SET DateOFAdmit='" + Util.GetDateTime(admissionDate).ToString("yyyy-MM-dd") + "',TimeOfAdmit='" + Util.GetDateTime(admissionTime).ToString("HH:mm") + "' Where ");
                sbSqlCmd.Append("TransactionID ='" + IPDNo + "'");
                affectedRows = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, Util.GetString(sbSqlCmd));

                sbSqlCmd.Clear();
                sbSqlCmd.Append("Select MIN(PatientIPDProfile_ID) FROM Patient_IPD_Profile Where ");
                sbSqlCmd.Append("TransactionID ='" + IPDNo + "'"); 
                string id = StockReports.ExecuteScalar(Util.GetString(sbSqlCmd));

                sbSqlCmd.Clear();
                sbSqlCmd.Append("Update Patient_IPD_Profile Set StartDate='" + Util.GetDateTime(admissionDate).ToString("yyyy-MM-dd") + "', StartTime='" + Util.GetDateTime(admissionTime).ToString("HH:mm") + "'");
                sbSqlCmd.Append(" Where PatientIPDProfile_ID = '" + id + "' ");
                affectedRows = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, Util.GetString(sbSqlCmd));

            }
            else
                lblMsg.Text = "Enter Admission Date Time";
        }
       
        return affectedRows;
    }
    protected void BtnReset_Click(object sender, EventArgs e)
    {
        SetDefault();
        DisableControl();
    }

    private void SetDefault() 
    {
        txtAdmissionDate.Text = "";
        txtAdmissionTime.Text = "";
        txtBillingDate.Text = "";
        txtBillingTime.Text = "";
        txtDischargeDate.Text = "";
        txtDischargeTime.Text = "";
        txtIPDNo.Text = "";
        txtMRNo.Text = "";
        txtFirstname.Text = "";
        txtLastname.Text = "";
        chkAdmissionDT.Checked = false;
        chkBillingDT.Checked = false;
        chkDischargeDT.Checked = false;
        chkDischargeType.Checked = false;
        ddlDischargeType.SelectedIndex = 0;
    }
}
    
