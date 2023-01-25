using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Linq;

public partial class Design_IPD_Pregnancydetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        caldate.EndDate = DateTime.Now;
        if (!IsPostBack)
        {
            
            txtDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            txtTime.Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            //((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PatientID"].ToString();
            ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
            lblEmployeeName.Text = Session["LoginName"].ToString();
            string Gender = Util.GetString(StockReports.ExecuteScalar("select pm.Gender from patient_medical_history	pmh inner join patient_master pm on pm.PatientID=pmh.PatientID WHERE PMH.TransactionID='" + ViewState["TID"] + "'"));

            if (Gender == "Male")
            {
               string Msg = "Patient Should a Female !!!";
                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            }
            GetPregnancyDetails();
        }
			ViewState["PID"] = Request.QueryString["PatientID"].ToString();

        
            txtDate.Attributes.Add("readOnly", "true");
          //  txtTime.Attributes.Add("readOnly", "true");
    }
    //protected void grdPregnancyDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    //{

    //}
    //protected void grdPregnancyDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    //{
    //    if (e.CommandName == "Change")
    //    {
    //        int id = Convert.ToInt16(e.CommandArgument.ToString());
    //        lblPID.Text = ((Label)grdPregnancyDetails.Rows[id].FindControl("lblID")).Text;

    //        DataTable dt = (DataTable)ViewState["dt"];
    //        DataRow[] rows = dt.Select("Id = '" + lblPID.Text + "'");
    //        if (rows.Length > 0)
    //        {
    //            txtPregnancyNr.Text = rows[0]["PregnancyNr"].ToString();
    //            txtDate.Text = rows[0]["Date1"].ToString();
    //            //txtTime.Text = rows[0]["Time1"].ToString();
    //            ((TextBox)StartTime.FindControl("txtTime")).Text = rows[0]["Time1"].ToString();
    //           txtGravida.Text = rows[0]["Gravida"].ToString();
    //            txtBirths.Text = rows[0]["Births"].ToString();
    //            txtPregnancyGestationalAge.Text = rows[0]["PregnancyGestationalAge"].ToString();
    //            txtNroffetus.Text = rows[0]["Nroffetuses"].ToString();

    //            txtDate.Text = rows[0]["Date1"].ToString();
    //            ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["Time"].ToString()).ToString("hh:mm tt");
    //            string deliverymode = rows[0]["DeliveryMode"].ToString();
    //            string booked = rows[0]["Booked"].ToString();
    //            switch (deliverymode.Trim())
    //            {
    //                case "Normal":
    //                    rdbdelivery.SelectedIndex = 0;
    //                    break;
    //                case "Breech":
    //                    rdbdelivery.SelectedIndex = 1;
    //                    break;
    //                case "Caesarean":
    //                    rdbdelivery.SelectedIndex = 2;
    //                    break;
    //                case "Forceps":
    //                    rdbdelivery.SelectedIndex = 3;
    //                    break;
    //                case "Vacuum":
    //                    rdbdelivery.SelectedIndex = 4;
    //                    break;
    //            }
    //            switch (booked.Trim())
    //            {
    //                case "Yes":
    //                    rdbbooked.SelectedIndex = 0;
    //                    break;
    //                case "No":
    //                    rdbbooked.SelectedIndex = 1;
    //                    break;
    //            }
    //            txtVDRL.Text = rows[0]["VDRL"].ToString();
    //            txtRH.Text = rows[0]["RH"].ToString();
    //            txtHighSystolicValue.Text = rows[0]["HighSystolicValue"].ToString();
    //            txtHighDiastolicvalue.Text = rows[0]["HighDiastolicvalue"].ToString();
    //            string proteinuria = rows[0]["Proteinuria"].ToString();
    //            switch (proteinuria.Trim())
    //            {
    //                case "Yes":
    //                    rdbProteinuria.SelectedIndex = 0;
    //                    break;
    //                case "No":
    //                    rdbProteinuria.SelectedIndex = 1;
    //                    break;
    //            }
    //            txtLabourDuration.Text = rows[0]["LabourDuration"].ToString();
    //            txtAROM.Text = rows[0]["AROM"].ToString();
    //            txtInductionIndication.Text = rows[0]["InductionIndication"].ToString();
    //            txtGETAComplications.Text = rows[0]["GETAComplications"].ToString();
    //            txtEpisiotomyBloodLoss.Text = rows[0]["EpisiotomyBloodLoss"].ToString();
    //            string retainedplacenta = rows[0]["RetainedPlacenta"].ToString();
    //            switch (retainedplacenta.Trim())
    //            {
    //                case "Yes":
    //                    rdbRetainedPlacenta.SelectedIndex = 0;
    //                    break;
    //                case "No":
    //                    rdbRetainedPlacenta.SelectedIndex = 1;
    //                    break;
    //            }
    //            txtPostLabourCondition.Text = rows[0]["PostLabourCondition"].ToString();
    //            string outcome = rows[0]["Outcome"].ToString();
    //            switch (outcome.Trim())
    //            {
    //                case "Alive":
    //                    rdbOutcome.SelectedIndex = 0;
    //                    break;
    //                case "Still Born":
    //                    rdbOutcome.SelectedIndex = 1;
    //                    break;
    //                case "Early Neonatal Death":
    //                    rdbOutcome.SelectedIndex = 2;
    //                    break;
    //                case "Late Neonatal Death":
    //                    rdbOutcome.SelectedIndex = 3;
    //                    break;
    //                case "Death Uncertain":
    //                    rdbOutcome.SelectedIndex = 4;
    //                    break;
    //                   }
    //            string Anaesthesia = rows[0]["Anaesthesia"].ToString();
    //            switch (Anaesthesia.Trim())
    //            {
    //                case "Anaesthesia":
    //                    rdbAnaesthesia.SelectedIndex = 0;
    //                    break;

    //                case "General Anaesthesia":
    //                    rdbAnaesthesia.SelectedIndex = 1;
    //                    break;

    //                case "Spnial Anaesthesia":
    //                    rdbAnaesthesia.SelectedIndex = 2;
    //                    break;

    //                case "Local Anaesthesia":
    //                    rdbAnaesthesia.SelectedIndex = 3;
    //                    break;
    //            }
    //            string Tear = rows[0]["Tear"].ToString();
    //            switch (Tear.Trim())
    //            {
    //                case "Perineum":
    //                    rdbTear.SelectedIndex = 0;
    //                    break;
    //                case "Intact":
    //                    rdbTear.SelectedIndex = 1;
    //                    break;
    //                case "1 tear":
    //                    rdbTear.SelectedIndex = 2;
    //                    break;
    //                case "2 tear":
    //                    rdbTear.SelectedIndex = 3;
    //                    break;
    //                case "3 tear":
    //                    rdbTear.SelectedIndex = 4;
    //                    break;
    //            }
    //            string ColumnX = rows[0]["ColumnX"].ToString();
    //            switch (ColumnX.Trim())
    //            {
    //                case "Incubation Method":
    //                    rdbColumnX.SelectedIndex = 0;
    //                    break;
    //                case "Not Needed":
    //                    rdbColumnX.SelectedIndex = 1;
    //                    break;
    //                case "Unkown":
    //                    rdbColumnX.SelectedIndex = 2;
    //                    break;
    //                case "Prostaglandin":
    //                    rdbColumnX.SelectedIndex = 3;
    //                    break;
    //                case "Oxytocin":
    //                    rdbColumnX.SelectedIndex = 4;
    //                    break;
    //            }
               
    //        }
    //        btnUpdate.Visible = true;
    //        btnSave.Visible = false;
    //        btnCancel.Visible = true;
    //    }
    //}
  
    private DataTable GetPregnancyDetails()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT date_format(d.date,'%d-%b-%Y')Dates,TIME_FORMAT(d.Time,'%h:%i %p')Times,d.* FROM pregnancydetails d WHERE TransactionID='" + ViewState["TID"].ToString() + "' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                txtPregnancyNr.Text = dt.Rows[0]["PregnancyNr"].ToString();
                txtGravida.Text=dt.Rows[0]["Gravida"].ToString();
                txtBirths.Text=dt.Rows[0]["Births"].ToString();
                txtPregnancyGestationalAge.Text=dt.Rows[0]["PregnancyGestationalAge"].ToString();
                txtNroffetus.Text=dt.Rows[0]["Nroffetuses"].ToString();
                rdbdelivery.SelectedIndex=rdbdelivery.Items.IndexOf(rdbdelivery.Items.FindByText(Util.GetString(dt.Rows[0]["DeliveryMode"])));
                rdbbooked.SelectedIndex = rdbbooked.Items.IndexOf(rdbbooked.Items.FindByText(Util.GetString(dt.Rows[0]["Booked"])));
                 txtVDRL.Text=dt.Rows[0]["VDRL"].ToString();
                 txtRH.Text=dt.Rows[0]["RH"].ToString();
                 txtHighSystolicValue.Text=dt.Rows[0]["HighSystolicValue"].ToString();
                 txtHighDiastolicvalue.Text=dt.Rows[0]["HighDiastolicvalue"].ToString();
                 rdbProteinuria.SelectedIndex=rdbProteinuria.Items.IndexOf(rdbProteinuria.Items.FindByText(Util.GetString(dt.Rows[0]["Proteinuria"])));
                 rdbColumnX.SelectedIndex = rdbColumnX.Items.IndexOf(rdbColumnX.Items.FindByText(Util.GetString(dt.Rows[0]["ColumnX"])));
                 txtInductionIndication.Text=dt.Rows[0]["InductionIndication"].ToString();
                 rdbAnaesthesia.SelectedIndex=rdbAnaesthesia.Items.IndexOf(rdbAnaesthesia.Items.FindByText(Util.GetString(dt.Rows[0]["Anaesthesia"])));
                 txtGETAComplications.Text=dt.Rows[0]["GETAComplications"].ToString();
                 rdbTear.SelectedIndex = rdbTear.Items.IndexOf(rdbTear.Items.FindByText(Util.GetString(dt.Rows[0]["tear"])));
                 txtEpisiotomyBloodLoss.Text=dt.Rows[0]["EpisiotomyBloodLoss"].ToString();
                 ddlBloodlossunit.SelectedIndex = ddlBloodlossunit.Items.IndexOf(ddlBloodlossunit.Items.FindByText(Util.GetString(dt.Rows[0]["bloodLossunit"])));
                 rdbRetainedPlacenta.SelectedIndex = rdbRetainedPlacenta.Items.IndexOf(rdbRetainedPlacenta.Items.FindByText(Util.GetString(dt.Rows[0]["RetainedPlacenta"])));
                 txtPostLabourCondition.Text=dt.Rows[0]["PostLabourCondition"].ToString();
                 rdbOutcome.SelectedIndex = rdbOutcome.Items.IndexOf(rdbOutcome.Items.FindByText(Util.GetString(dt.Rows[0]["Outcome"])));
                 txtLabourDuration.Text = dt.Rows[0]["LabourDuration"].ToString();
                 txtAROM.Text = dt.Rows[0]["AROM"].ToString();
                 txtDate.Text = dt.Rows[0]["Dates"].ToString();
                 //((TextBox)StartTime.FindControl("txtTime")).Text = dt.Rows[0]["Times"].ToString();
                 txtTime.Text = dt.Rows[0]["Times"].ToString();
                 lblID.Text = dt.Rows[0]["Id"].ToString();
                 btnUpdate.Visible = true;
                 txtDate.Enabled = false;
                // ((TextBox)StartTime.FindControl("txtTime")).Enabled = false;
				 txtTime.Enabled = false;
                 btnSave.Visible = false;
                
            }

            return dt;
        }
        catch (Exception exc)
        {
            return null;
        }


    }
    
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        if (DateTime.Parse(txtDate.Text.Trim()) > (DateTime.Now))
        {

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('only past dates allowed');", true);
            return;
        }
        
        try
        {
            string deliverymode = rdbdelivery.SelectedItem.Text;
            string booked = rdbbooked.SelectedItem.Text;
            string protienuria = rdbProteinuria.SelectedItem.Text;
            string anaesthesia = rdbAnaesthesia.SelectedItem.Text;
            string tear = rdbTear.SelectedItem.Text;
            string columnx = rdbColumnX.SelectedItem.Text;
            string restainedplacenta = rdbRetainedPlacenta.SelectedItem.Text;
            string outcome = rdbOutcome.SelectedItem.Text;

            string query = "INSERT INTO `pregnancydetails` (`PregnancyNr`,  `Date`,  `Time`,  `Gravida`,  `Births`,  `PregnancyGestationalAge`,  `Nroffetuses`,  `DeliveryMode`,"+
  "`Booked`,  `VDRL`,  `HighSystolicValue`,  `HighDiastolicvalue`,  `Proteinuria`,  `LabourDuration`,  `AROM`,  `InductionIndication`,  `GETAComplications`,  `EpisiotomyBloodLoss`,  `RetainedPlacenta`,"+
 " `PostLabourCondition`,  `Outcome`,  `RH`,`Anaesthesia`,`ColumnX`,`Tear`,`EntryBy`,`PatientId`,bloodLossunit,TransactionID)" +
" VALUES  (    '" + txtPregnancyNr.Text + "',    '" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',    '" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") +
"',    '"+txtGravida.Text+"',    '"+txtBirths.Text+"',    '"+txtPregnancyGestationalAge.Text+"',    '"+txtNroffetus.Text+"',    '"+deliverymode+"',    '"+booked+"',    '"+txtVDRL.Text+
"',    '"+txtHighSystolicValue.Text+"', '"+txtHighDiastolicvalue.Text+"',    '"+protienuria+"',    '"+txtLabourDuration.Text+"',    '"+txtAROM.Text+"',    '"+txtInductionIndication.Text+
"',  '" + txtGETAComplications.Text + "',    '" + txtEpisiotomyBloodLoss.Text + "',    '" + restainedplacenta + "',    '" + txtPostLabourCondition.Text + "'," +
   " '" + outcome + "',    '" + txtRH.Text + "','" + anaesthesia + "','" + columnx + "','" + tear + "','" + Session["ID"].ToString() + "' ,'" + ViewState["PID"] + "' ,'" + ddlBloodlossunit.SelectedItem.Text + "','" + ViewState["TID"].ToString() + "'   );";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            var patientID=string.Empty;
            if (txtBirths.Text.Trim() != "")
            {
                DataTable dt = StockReports.GetDataTable("SELECT * FROM patient_master pm WHERE pm.PatientID='" + ViewState["PID"] + "'" );

                List<Patient_Master> pm = new List<Patient_Master>();

                if (dt.Rows.Count > 0 && dt != null)
                {

                    Patient_Master objPM = new Patient_Master();
                        objPM.PName = dt.Rows[0]["PName"].ToString();
                        objPM.Title = "B/O";
                        objPM.PFirstName = dt.Rows[0]["PFirstName"].ToString();
                        objPM.PLastName = dt.Rows[0]["PLastName"].ToString();
                        objPM.DOB = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        objPM.PatientID = "";
                        objPM.Relation = "Self";
                        objPM.RelationName = "";
                        objPM.Gender = "";
                        objPM.Mobile = dt.Rows[0]["Mobile"].ToString();
                        objPM.Email = dt.Rows[0]["Email"].ToString();
                        objPM.House_No = dt.Rows[0]["House_No"].ToString();
                        objPM.Country = dt.Rows[0]["Country"].ToString();
                        objPM.City = dt.Rows[0]["City"].ToString();
                        objPM.FeesPaid = 0;
                        objPM.HospPatientType = dt.Rows[0]["HospPatientType"].ToString();
                        objPM.DateEnrolled = Util.GetDateTime(DateTime.Now.ToString("dd-MMM-yyyy"));
                        objPM.Taluka = dt.Rows[0]["Taluka"].ToString();
                        objPM.LandMark = dt.Rows[0]["LandMark"].ToString();
                        objPM.Place = dt.Rows[0]["Place"].ToString();
                        objPM.District = dt.Rows[0]["District"].ToString();
                        objPM.Locality = dt.Rows[0]["Locality"].ToString();
                        objPM.PinCode = dt.Rows[0]["PinCode"].ToString();
                        objPM.Occupation = dt.Rows[0]["Occupation"].ToString();
                        objPM.MaritalStatus = dt.Rows[0]["MaritalStatus"].ToString();
                        objPM.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objPM.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        objPM.RegisterBy = HttpContext.Current.Session["ID"].ToString();
                        objPM.IPAddress = All_LoadData.IpAddress();
                        objPM.AdharCardNo = dt.Rows[0]["AdharCardNo"].ToString();
                        objPM.CountryID = Util.GetInt(dt.Rows[0]["CountryID"]);
                        objPM.DistrictID = Util.GetInt(dt.Rows[0]["DistrictID"]);
                        objPM.CityID = Util.GetInt(dt.Rows[0]["CityID"]);
                        objPM.TalukaID = Util.GetInt(dt.Rows[0]["TalukaID"]); ;
                        objPM.OldPatientID = "";
                        objPM.PatientType = dt.Rows[0]["PatientType"].ToString();
                        objPM.State = dt.Rows[0]["State"].ToString();
                        objPM.StateID = Util.GetInt(dt.Rows[0]["StateID"]);
                        objPM.PanelID = Util.GetInt(dt.Rows[0]["PanelID"]);
                        objPM.Active = 1;
                        objPM.PMiddleName = dt.Rows[0]["PMiddleName"].ToString();
                        objPM.EmergencyPhone = dt.Rows[0]["EmergencyPhone"].ToString();
                        objPM.PurposeOfVisit = dt.Rows[0]["PurposeOfVisit"].ToString();
                        objPM.PurposeOfVisitID = Util.GetInt(dt.Rows[0]["PurposeOfVisitID"]);
                        objPM.PRequestDept = Util.GetInt(dt.Rows[0]["PRequestDept"]);
                        objPM.SecondMobileNo = dt.Rows[0]["SecondMobileNo"].ToString();
                        objPM.LastFamilyUHIDNumber = dt.Rows[0]["LastFamilyUHIDNumber"].ToString();
                        pm.Add(objPM);

                }
          
    
                for (int i = 0; i < Util.GetInt(txtBirths.Text); i++)
                {
                    var PatientMasterInfo = Insert_PatientInfo.savePatientMaster(pm, tranx, con);
                    if (PatientMasterInfo.Count == 0)
                    {
                        tranx.Rollback();
                        return;
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "alert('Error Occured Contact Administrator');", true);
                    }

                    else {

                        patientID = PatientMasterInfo[0].PatientID+ " "+ patientID;
                        string Sqlcmd = "INSERT INTO PatientMotherBabyDetails (MotherPatientID,MotherTransactionID,BabyPatientID,Entryby,EntryDate)VALUES(@MotherPatientID,@MotherTransactionID,@BabyPatientID,@Entryby,NOW());";

                        excuteCMD.DML(tranx, Sqlcmd, CommandType.Text, new
                        {

                            MotherPatientID = Util.GetString(ViewState["PID"]),
                            MotherTransactionID = ViewState["TID"].ToString(),
                            BabyPatientID=PatientMasterInfo[0].PatientID,
                            Entryby = HttpContext.Current.Session["ID"].ToString()


                        });
                    }
                }
            }

                tranx.Commit();
            Clear();
            GetPregnancyDetails();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert(' Record Save Sucessfully ', function(){'"+patientID+"'});", true);
        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('not saved');", true);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    private void Clear()
    {
        txtPregnancyNr.Text = "";
        txtDate.Text = "";
        txtGravida.Text = "";
        txtBirths.Text = "";
        txtPregnancyGestationalAge.Text = "";
        txtNroffetus.Text = "";


        txtDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        //((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt"); 
        txtTime.Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
                rdbdelivery.SelectedIndex = 0;
              
                rdbbooked.SelectedIndex = 0;

                txtVDRL.Text = "";
                txtRH.Text = "";
                txtHighSystolicValue.Text = "";
                txtHighDiastolicvalue.Text = "";
                rdbProteinuria.SelectedIndex = 0;

                txtLabourDuration.Text = "";
                txtAROM.Text = "";
                txtInductionIndication.Text = "";
                txtGETAComplications.Text = "";
                txtEpisiotomyBloodLoss.Text = "";
                rdbRetainedPlacenta.SelectedIndex = 0;

                txtPostLabourCondition.Text = "";
                rdbOutcome.SelectedIndex = 0;
                
                rdbAnaesthesia.SelectedIndex = 0;
                
                rdbTear.SelectedIndex = 0;
                
                rdbColumnX.SelectedIndex = 0;
                
               
        
        btnUpdate.Visible = false;
        btnSave.Visible = true;
        btnCancel.Visible = false;


    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        if (DateTime.Parse(txtDate.Text.Trim()) > (DateTime.Now))
        {

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('only past dates allowed');", true);
            return;
        }
        
        try
        {
            string deliverymode = rdbdelivery.SelectedItem.Text;
            string booked = rdbbooked.SelectedItem.Text;
            string protienuria = rdbProteinuria.SelectedItem.Text;

            string anaesthesia = rdbAnaesthesia.SelectedItem.Text;
            string tear = rdbTear.SelectedItem.Text;
            string columnx = rdbColumnX.SelectedItem.Text;
            string restainedplacenta = rdbRetainedPlacenta.SelectedItem.Text;
            string outcome = rdbOutcome.SelectedItem.Text;

            //,	DATE = '" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "', 	TIME = '" + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss")  
            string query = "update  pregnancydetails 	set PregnancyNr = '" + txtPregnancyNr.Text + "' " +
", 	Gravida = '" + txtGravida.Text + "', 	Births = '" + txtBirths.Text + "'," +
                "	PregnancyGestationalAge = '" + txtPregnancyGestationalAge.Text + "',	Nroffetuses = '" + txtNroffetus.Text + "', 	DeliveryMode = '" + deliverymode + "', 	Booked = '" + booked + "'" +	
                ",  `VDRL` = '"+txtVDRL.Text+"',  `HighSystolicValue` = '"+txtHighSystolicValue.Text+"',  `HighDiastolicvalue` = '"+txtHighDiastolicvalue.Text+"',  `Proteinuria` = '"+protienuria+
                "',  `LabourDuration` = '"+txtLabourDuration.Text+"',"+
  "`AROM` = '"+txtAROM.Text+"',  `InductionIndication` = '"+txtInductionIndication.Text+"',  `GETAComplications` = '"+txtGETAComplications.Text+"',  `EpisiotomyBloodLoss` = '"+
  txtEpisiotomyBloodLoss.Text+"',  `RetainedPlacenta` = '"+restainedplacenta+"',"+
"  `PostLabourCondition` = '" + txtPostLabourCondition.Text + "',  `Outcome` = '" + outcome + "',  `RH` = '" + txtRH.Text + "',`Anaesthesia`='" + anaesthesia + "',`ColumnX`='" + columnx + "',`Tear`='" + tear + "' ,bloodLossunit='" + ddlBloodlossunit.SelectedItem.Text + "'	 where	Id = '" + lblID.Text + "' ;";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            var patientID = string.Empty;
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM patientmotherbabydetails WHERE MotherTransactionID='" + ViewState["TID"].ToString() + "'"));

            if ( Util.GetInt(txtBirths.Text)>count)
            {
                count = Util.GetInt(txtBirths.Text) - count;
                  DataTable dt = StockReports.GetDataTable("SELECT * FROM patient_master pm WHERE pm.PatientID='" + ViewState["PID"] + "'");

                    List<Patient_Master> pm = new List<Patient_Master>();

                    if (dt.Rows.Count > 0 && dt != null)
                    {

                        Patient_Master objPM = new Patient_Master();
                        objPM.PName = dt.Rows[0]["PName"].ToString();
                        objPM.Title = "B/O";
                        objPM.PLastName = dt.Rows[0]["PLastName"].ToString();
                        objPM.PFirstName = dt.Rows[0]["PFirstName"].ToString();
                        objPM.DOB = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        objPM.PatientID = "";
                        objPM.Relation = "Self";
                        objPM.RelationName = "";
                        objPM.Gender = "";
                        objPM.Mobile = dt.Rows[0]["Mobile"].ToString();
                        objPM.Email = dt.Rows[0]["Email"].ToString();
                        objPM.House_No = dt.Rows[0]["House_No"].ToString();
                        objPM.Country = dt.Rows[0]["Country"].ToString();
                        objPM.City = dt.Rows[0]["City"].ToString();
                        objPM.FeesPaid = 0;
                        objPM.HospPatientType = dt.Rows[0]["HospPatientType"].ToString();
                        objPM.DateEnrolled = Util.GetDateTime(DateTime.Now.ToString("dd-MMM-yyyy"));
                        objPM.Taluka = dt.Rows[0]["Taluka"].ToString();
                        objPM.LandMark = dt.Rows[0]["LandMark"].ToString();
                        objPM.Place = dt.Rows[0]["Place"].ToString();
                        objPM.District = dt.Rows[0]["District"].ToString();
                        objPM.Locality = dt.Rows[0]["Locality"].ToString();
                        objPM.PinCode = dt.Rows[0]["PinCode"].ToString();
                        objPM.Occupation = dt.Rows[0]["Occupation"].ToString();
                        objPM.MaritalStatus = dt.Rows[0]["MaritalStatus"].ToString();
                        objPM.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objPM.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        objPM.RegisterBy = HttpContext.Current.Session["ID"].ToString();
                        objPM.IPAddress = All_LoadData.IpAddress();
                        objPM.AdharCardNo = dt.Rows[0]["AdharCardNo"].ToString();
                        objPM.CountryID = Util.GetInt(dt.Rows[0]["CountryID"]);
                        objPM.DistrictID = Util.GetInt(dt.Rows[0]["DistrictID"]);
                        objPM.CityID = Util.GetInt(dt.Rows[0]["CityID"]);
                        objPM.TalukaID = Util.GetInt(dt.Rows[0]["TalukaID"]); ;
                        objPM.OldPatientID = "";
                        objPM.PatientType = dt.Rows[0]["PatientType"].ToString();
                        objPM.State = dt.Rows[0]["State"].ToString();
                        objPM.StateID = Util.GetInt(dt.Rows[0]["StateID"]);
                        objPM.PanelID = Util.GetInt(dt.Rows[0]["PanelID"]);
                        objPM.Active = 1;
                        objPM.PMiddleName = dt.Rows[0]["PMiddleName"].ToString();
                        objPM.EmergencyPhone = dt.Rows[0]["EmergencyPhone"].ToString();
                        objPM.PurposeOfVisit = dt.Rows[0]["PurposeOfVisit"].ToString();
                        objPM.PurposeOfVisitID = Util.GetInt(dt.Rows[0]["PurposeOfVisitID"]);
                        objPM.PRequestDept = Util.GetInt(dt.Rows[0]["PRequestDept"]);
                        objPM.SecondMobileNo = dt.Rows[0]["SecondMobileNo"].ToString();
                        objPM.LastFamilyUHIDNumber = dt.Rows[0]["LastFamilyUHIDNumber"].ToString();
                        pm.Add(objPM);

                    }


                    for (int i = 0; i < count; i++)
                    {
                        var PatientMasterInfo = Insert_PatientInfo.savePatientMaster(pm, tranx, con);
                        if (PatientMasterInfo.Count == 0)
                        {
                            tranx.Rollback();
                            return;
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "alert('Error Occured Contact Administrator');", true);
                        }

                        else
                        {

                            patientID = PatientMasterInfo[0].PatientID + " " + patientID;
                            string Sqlcmd = "INSERT INTO PatientMotherBabyDetails (MotherPatientID,MotherTransactionID,BabyPatientID,Entryby,EntryDate)VALUES(@MotherPatientID,@MotherTransactionID,@BabyPatientID,@Entryby,NOW());";

                            excuteCMD.DML(tranx, Sqlcmd, CommandType.Text, new
                            {

                                MotherPatientID = Util.GetString(ViewState["PID"]),
                                MotherTransactionID = ViewState["TID"].ToString(),
                                BabyPatientID = PatientMasterInfo[0].PatientID,
                                Entryby = HttpContext.Current.Session["ID"].ToString()


                            });
                        }
                    }
                

            }

            tranx.Commit();
            Clear();
            GetPregnancyDetails();

            btnSave.Visible = false;
            btnUpdate.Visible = true;
            btnCancel.Visible = false;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('updated successfully');", true);
        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('not updated');", true);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    

   
}