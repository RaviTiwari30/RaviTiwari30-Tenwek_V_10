using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_UpdateAdmitDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
           
            AllLoadData_IPD.bindDeliveryDetails(ddlWeeks, ddlDays, ddlTypeofDelivery);              
            AllLoadData_IPD.bindTypeOfDeath(ddltypeOfDeath, "Select");
            string TransactionID = Request.QueryString["TID"];
            ViewState["TID"] =TransactionID.ToString();            
            txtMlcTime.Text = DateTime.Now.ToString("hh:mm");
            BindDetails(ViewState["TID"].ToString());
        }
        EntryDateDeath.Attributes.Add("readonly", "readonly");
        txtAccidentDate.Attributes.Add("readonly", "readonly");
        txtAccidentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        calucDate.EndDate = DateTime.Now;
        CalendarExtender2.EndDate = DateTime.Now;
    }

   
    
    private void BindDetails(string TransactionID)
    {
        string sql = "select pm.title,pm.DOB,pm.Age,pm.TimeOfBirth,pm.Weight,pmh.Acc_date,pmh.Acc_time,pmh.Acc_location,pmh.MLC_NO,pmh.MLC_Type,pmh.Acc_PCNo,pmh.Cas_reason,pmh.BroughtBy,pmh.DischargeType,pmh.TimeOfDeath,pmh.TypeOfDeathID,pmh.CauseOfDeath,pmh.IsDeathOver48HRS,pmh.typeofdelivery,pmh.DeliveryWeeks,pmh.DeliveryType,pmh.Remarks from patient_master pm inner join patient_medical_history pmh on pm.PatientID=pmh.PatientID where pmh.TransactionID='" + TransactionID + "'";
        DataTable dt = StockReports.GetDataTable(sql);
        if (Util.GetString(dt.Rows[0]["title"]) != "")
        {
            birth.Style["display"] = "";
            if (Util.GetString(dt.Rows[0]["typeofdelivery"]) != "")
            {
                ddlTypeofDelivery.SelectedIndex = ddlTypeofDelivery.Items.IndexOf(ddlTypeofDelivery.Items.FindByText(Util.GetString(dt.Rows[0]["typeofdelivery"])));
            }
            string DeliveryWeeks = Util.GetString(dt.Rows[0]["DeliveryWeeks"]);
            if (DeliveryWeeks != "")
            {
                string[] delWeeks = DeliveryWeeks.Split('.');
                string DeliveryWeek = Util.GetString(delWeeks[0]);
                string DeliveryDays = Util.GetString(delWeeks[1]);
                ddlWeeks.SelectedIndex = ddlWeeks.Items.IndexOf(ddlWeeks.Items.FindByText(DeliveryWeek));
                ddlDays.SelectedIndex = ddlDays.Items.IndexOf(ddlDays.Items.FindByText(DeliveryDays));
            }
            string Weight = Util.GetString(dt.Rows[0]["Weight"]);
            if (Weight != "")
            {
                string[] delWeight = Weight.Split(' ');
                string txtW = Util.GetString(delWeight[0]);
                string dropdownW = Util.GetString(delWeight[1]);
                txtWeight.Text = txtW;
                ddlWeight.SelectedIndex = ddlWeight.Items.IndexOf(ddlWeight.Items.FindByValue(dropdownW));
            }
            string age = Util.GetString(dt.Rows[0]["Age"]);
            if (age != "")
            {
                string[] delage = age.Split(' ');
                string txtag = Util.GetString(delage[0]);
                string dropdownage = Util.GetString(delage[1]);
                txtAge.Text = txtag;
                ddlAge.SelectedIndex = ddlAge.Items.IndexOf(ddlAge.Items.FindByValue(dropdownage));
                
            }
        }


        if (Util.GetString(dt.Rows[0]["DischargeType"]).ToUpper() != "EXPIRED")
        {
            Death.Style["display"] = "none";
        }
        if (Util.GetString(dt.Rows[0]["DischargeType"]).ToUpper() == "EXPIRED")
        {
            Death.Style["display"] = "";
            if (Util.GetString(dt.Rows[0]["DischargeType"]) != "")
            {
                lblDischargeType.Text = Util.GetString(dt.Rows[0]["DischargeType"]);
            }
            if (Util.GetString(dt.Rows[0]["TimeOfDeath"]) != "")
            {
                string TimeOfDeath =  Util.GetString(dt.Rows[0]["TimeOfDeath"]);
                string[] TimeOfD = TimeOfDeath.Split(' ');
                string dateofDeath = Util.GetString(TimeOfD[0]);

                string timeofdeathnew = Util.GetString(TimeOfD[1]);
                EntryDateDeath.Text = Util.GetDateTime(dateofDeath).ToString("dd-MMM-yyyy");
                txtDeathTime.Text = Util.GetDateTime( timeofdeathnew).ToString("HH:mm tt");

            }
            if (Util.GetString(dt.Rows[0]["CauseOfDeath"]) != "")
            {
                txtcauseOfDeath.Text = Util.GetString(dt.Rows[0]["CauseOfDeath"]);
            }
            txtRemarks.Text = Util.GetString(dt.Rows[0]["Remarks"]);
            if (Util.GetString(dt.Rows[0]["TypeOfDeathID"]) != "")
            {
                ddltypeOfDeath.SelectedIndex = ddlTypeofDelivery.Items.IndexOf(ddlTypeofDelivery.Items.FindByValue(Util.GetString(dt.Rows[0]["TypeOfDeathID"]).ToString()));

            }
            if (dt.Rows[0]["IsDeathOver48HRS"].ToString() == "0")
            {
                chkDeathover48hrs.Checked = false;
            }
            else
            {
                chkDeathover48hrs.Checked = true;
            }
        }
      
        string Accdate = Util.GetString(dt.Rows[0]["Acc_date"]);
        if (Util.GetString(dt.Rows[0]["MLC_NO"]) != "")
        {
            Mlc.Style["display"] = "";

            if (Util.GetString(dt.Rows[0]["Acc_date"]) != "")
            {
                if (Util.GetString(Util.GetDateTime(Accdate).ToString("yyyy-M-dd")) != "0001-1-01")
                {
                    string[] dateofAcc = Util.GetDateTime(Accdate).ToString("yyyy-M-dd").Split('-');
                    txtAccidentDate.Text = Util.GetDateTime(Accdate).ToString("dd-MMM-yyyy");
                }
            }
            if (Util.GetString(dt.Rows[0]["Acc_time"]) != "")
            {
                string Acc_time = Util.GetString(dt.Rows[0]["Acc_time"]);
                if (Util.GetString(dt.Rows[0]["Acc_time"]) != "00:00:00")
                {
                   
                    txtMlcTime.Text = Util.GetDateTime( Acc_time).ToString("HH:mm tt");
                }
            }
            if (Util.GetString(dt.Rows[0]["Acc_location"]) != "")
            {
                txtAccLocation.Text = Util.GetString(dt.Rows[0]["Acc_location"]);
            }
            if (Util.GetString(dt.Rows[0]["MLC_NO"]) != "")
            {
                txtMlcNo.Text = Util.GetString(dt.Rows[0]["MLC_NO"]);
                ddlMLCType.SelectedIndex = ddlMLCType.Items.IndexOf(ddlMLCType.Items.FindByValue(dt.Rows[0]["MLC_Type"].ToString()));
            }
            if (Util.GetString(dt.Rows[0]["Acc_PCNo"]) != "")
            {
                txtPcNo.Text = Util.GetString(dt.Rows[0]["Acc_PCNo"]);
            }
            if (Util.GetString(dt.Rows[0]["Cas_reason"]) != "")
            {
                txtOthers.Text = Util.GetString(dt.Rows[0]["Cas_reason"]);
            }
            if (Util.GetString(dt.Rows[0]["BroughtBy"]) != "")
            {
                txtBroughtby.Text = Util.GetString(dt.Rows[0]["BroughtBy"]);
            }
        }
    }
  
    protected void btnBirthUpdate_Click(object sender, EventArgs e)
    {
        string Transaction_No = ViewState["TID"].ToString();
        int RowUpdated = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {

            string strQuery = "Update patient_medical_history Set TypeOfDelivery ='" + Util.GetString(ddlTypeofDelivery.SelectedValue) + "',DeliveryWeeks='" + Util.GetString(ddlWeeks.SelectedValue + "." + ddlDays.SelectedValue) + "',DeliveryType=" + true + " Where TransactionID ='" + Transaction_No + "'";
            RowUpdated = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strQuery);
            string strQuerypatient = "Update patient_master pm inner join patient_medical_history pmh on pm.PatientID=pmh.PatientID Set pm.Age='" + Util.GetString(txtAge.Text + " " + ddlAge.SelectedValue) + "',pm.Weight ='" + Util.GetString(txtWeight.Text.ToString()) + " " + ddlWeight.SelectedValue + "' Where pmh.TransactionID ='" + Transaction_No + "'";
            RowUpdated = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strQuerypatient);
            tnx.Commit();
          
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMSG.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMSG.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnDeathDetail_Click(object sender, EventArgs e)
    {
        if (EntryDateDeath.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM134','" + lblMSG.ClientID + "');", true);
            return;
        }
        if (txtcauseOfDeath.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM135','" + lblMSG.ClientID + "');", true);
            return;
        }
        string Transaction_No = ViewState["TID"].ToString();
        int TypeOfDeath = Util.GetInt(ddltypeOfDeath.SelectedValue.ToString());
        string CauseOfDeath = txtcauseOfDeath.Text.ToString();
        int Deathover48hrs = 0;
        if (chkDeathover48hrs.Checked == true)
        {
            Deathover48hrs = 1;
        }
        string Remarks = txtRemarks.Text.ToString();

        UpdatePatientMedicalHistoryDeath(Transaction_No, lblDischargeType.Text, Util.GetDateTime(EntryDateDeath.Text).ToString("yyyy-MM-dd") + " " + txtDeathTime.Text.Trim(), TypeOfDeath, CauseOfDeath, Deathover48hrs, Remarks);
    }
    protected void btnMLCDetail_Click(object sender, EventArgs e)
    {
        if (txtAccidentDate.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM136','" + lblMSG.ClientID + "');", true);
            return;
        }
        if (txtMlcTime.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM140','" + lblMSG.ClientID + "');", true);
            return;
        }     
        int RowUpdated = 0;
        string Transaction_No = ViewState["TID"].ToString();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {

            string strQuery = "Update patient_medical_history Set Acc_date ='" + Util.GetDateTime(txtAccidentDate.Text).ToString("yyyy-MM-dd") + "',Acc_time='" + txtMlcTime.Text.ToString() + "',Acc_location='" + Util.GetString(txtAccLocation.Text.Trim().ToUpper()) + "',MLC_NO='" + Util.GetString(txtMlcNo.Text.Trim().ToUpper()) + "',MLC_type='"+ddlMLCType.SelectedValue.ToString()+"',Acc_PCNo='" + Util.GetString(txtPcNo.Text.Trim().ToUpper()) + "',Cas_reason='" + Util.GetString(txtOthers.Text.Trim().ToUpper()) + "',BroughtBy='" + Util.GetString(txtBroughtby.Text.ToString()) + "' Where TransactionID ='" + Transaction_No + "' and CentreID="+Session["CentreID"]+"";

            RowUpdated = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strQuery);
            if (RowUpdated > 0)
            {
                tnx.Commit();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", " modelAlert('Record Updated Successfully',function(){});", true);

            }
            else
            {
                tnx.Rollback();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Not Found',function(){});", true);
               
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Not Found',function(){});", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public void UpdatePatientMedicalHistoryDeath(string Transaction_No, string DischargeType, string TimeOfDeath, int TypeOfDeath, string CauseOfDeath, int Deathover48hrs, string Remarks)
    {
        int RowUpdated = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {

            string strQuery = "Update patient_medical_history Set DischargeType ='" + DischargeType + "',TimeOfDeath='" + TimeOfDeath + "',TypeOfDeathID=" + TypeOfDeath + ",IsDeathOver48HRS=" + Deathover48hrs + ",CauseOfDeath='" + CauseOfDeath + "',Remarks='" + Remarks + "' Where TransactionID ='" + Transaction_No + "'";
            RowUpdated = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strQuery);
            if (RowUpdated > 0)
            {
                tnx.Commit();              
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMSG.ClientID + "');", true);
            }
            else
            {
                tnx.Rollback();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMSG.ClientID + "');", true);

            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();           
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMSG.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

   
}
