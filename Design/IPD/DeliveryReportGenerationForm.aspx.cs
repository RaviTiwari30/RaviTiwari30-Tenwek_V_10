

using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_IPD_DeliveryReportGenerationForm : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["PatientID"] = Util.GetString(Request.QueryString["PatientID"]);
            string TID = "";
            TID = Request.QueryString["TransactionID"].ToString();
           txtDeliveryPlace.Text= Session["CentreName"].ToString();

           txtDocumentedBy.Text = StockReports.ExecuteScalar("SELECT NAME FROM  `employee_master` where EmployeeID='" + Session["ID"].ToString() + "'");
           string count = StockReports.ExecuteScalar("SELECT count(*) FROM  `deliveryreportgeneration` where PatientID='" + ViewState["PatientID"].ToString() + "'");
           if (Int32.Parse( count)>0 )
           {
               btnSave.Enabled = false;
           }
            BindDetails();
            
        }

        txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ((TextBox)StartTime.FindControl("txtTime")).Text = DateTime.Now.ToString("hh:mm tt");
        string ipdno = StockReports.ExecuteScalar("SELECT TransNo FROM `patient_medical_history` WHERE PatientID='" + ViewState["PatientID"].ToString() + "' ORDER BY TransactionID DESC LIMIT 1");
        txtMotherEncounterNr.Text = ipdno;
        txtDeliveryPlace.Text = Session["CentreName"].ToString();

        txtDocumentedBy.Text = StockReports.ExecuteScalar("SELECT NAME FROM  `employee_master` where EmployeeID='" + Session["ID"].ToString() + "'");
           
    }
    protected void BindDetails()
    {
        string str = "Select *,DATE_FORMAT(DATE,'%d-%b-%Y') AS DATE1,TIME_FORMAT(Time,'%h:%i %p') AS Time1,(SELECT NAME FROM  `employee_master` where EmployeeID=DocumentedBy limit 1) as EntryBy from deliveryreportgeneration where PatientId='" + ViewState["PatientID"].ToString() + "' order by ID desc ";
        DataTable dtDetails = StockReports.GetDataTable(str.ToString());
        if (dtDetails.Rows.Count > 0)
        {

            pnlhide.Visible = true;
            grid.DataSource = dtDetails;
            grid.DataBind();
            ViewState["dtDetails"] = dtDetails;
            try
            {

                if (dtDetails.Rows.Count > 0)
                    {
                        DataRow[] rows = dtDetails.Select("PatientID='"+ViewState["PatientID"].ToString()+"'");
                        ViewState["ID"] = rows[0]["ID"].ToString();
                        txtCongenitalAbnormality.Text = rows[0]["CongenitalAbnormality"].ToString();
                        txtMotherEncounterNr.Text = rows[0]["MotherEncounterNr"].ToString();
                        txtDeliveryNr.Text = rows[0]["DeliveryNr"].ToString();
                        string gender = rows[0]["Gender"].ToString();
                        if (gender == "Male")
                        {
                            rdbGender.SelectedIndex = 0;
                        }
                        else
                        {
                            rdbGender.SelectedIndex = 1;
                        }
                        //txtDeliveryPlace.Text = rows[0]["DeliveryPlace"].ToString();
                        string deliverymode = rows[0]["DeliveryMode"].ToString();
                        switch (deliverymode)
                        {
                            case "Normal":
                                rdbDeliveryMode.SelectedIndex = 0;
                                break;
                            case "Breech":
                                rdbDeliveryMode.SelectedIndex = 1;
                                break;
                            case "Caesarean":
                                rdbDeliveryMode.SelectedIndex = 2;
                                break;
                            case "Forceps":
                                rdbDeliveryMode.SelectedIndex = 3;
                                break;
                            case "Vacuum":
                                rdbDeliveryMode.SelectedIndex = 4;
                                break;
                        }

                        txtReasonIfCaesarean.Text = rows[0]["ReasonIfCaesarean"].ToString();
                        string BornBeforeArrival = rows[0]["BornBeforeArrival"].ToString();
                        if (BornBeforeArrival == "Yes")
                        {
                            rdbBornBeforeArrival.SelectedIndex = 0;
                        }
                        else
                        {
                            rdbBornBeforeArrival.SelectedIndex = 1;
                        }
                        string FacePresentation = rows[0]["FacePresentation"].ToString();
                        if (FacePresentation == "Yes")
                        {
                            rdbFacePresentation.SelectedIndex = 0;
                        }
                        else
                        {
                            rdbFacePresentation.SelectedIndex = 1;
                        }
                        string PosterioOccipitalPosition = rows[0]["PosterioOccipitalPosition"].ToString();
                        if (PosterioOccipitalPosition == "Yes")
                        {
                            rdbPosterioOccipitalPosition.SelectedIndex = 0;
                        }
                        else
                        {
                            rdbPosterioOccipitalPosition.SelectedIndex = 1;
                        }

                        txtDeliveryRank.Text = rows[0]["DeliveryRank"].ToString();
                        string apgarscore1min = rows[0]["ApgarScore1Min"].ToString();
                        rdbApgarScore1Min.SelectedIndex = Int32.Parse(apgarscore1min);

                        string apgarscore5min = rows[0]["ApgarScore5Min"].ToString();
                        rdbApgarScore5Min.SelectedIndex = Int32.Parse(apgarscore5min);

                        string apgarscore10min = rows[0]["ApgarScore10Min"].ToString();
                        rdbApgarScore10Min.SelectedIndex = Int32.Parse(apgarscore10min);

                        txtTimeToSpontanRespiration.Text = rows[0]["TimeToSpontanRespiration"].ToString();
                        txtCondition.Text = rows[0]["Condition"].ToString();
                        txtWeightAtBirth.Text = rows[0]["WeightAtBirth"].ToString();
                        txtLengthAtBirth.Text = rows[0]["LengthAtBirth"].ToString();
                        txtHeadCircumference.Text = rows[0]["HeadCircumference"].ToString();
                        txtScoredGestationalAge.Text = rows[0]["ScoredGestationalAge"].ToString();
                        string Feeding = rows[0]["Feeding"].ToString();
                        switch (Feeding)
                        {
                            case "Breast":
                                rdbFeeding.SelectedIndex = 0;
                                break;
                            case "Formula":
                                rdbFeeding.SelectedIndex = 1;
                                break;
                            case "Both":
                                rdbFeeding.SelectedIndex = 2;
                                break;
                            case "Parenteral":
                                rdbFeeding.SelectedIndex = 3;
                                break;
                            case "Never Fed":
                                rdbFeeding.SelectedIndex = 4;
                                break;
                        }

                        txtCongenitalAbnormality.Text = rows[0]["CongenitalAbnormality"].ToString();
                        txtClassification.Text = rows[0]["Classification"].ToString();
                        string Outcome = rows[0]["Outcome"].ToString();
                        switch (Outcome)
                        {
                            case "Alive":
                                rdbOutcome.SelectedIndex = 0;
                                break;
                            case "Still Born":
                                rdbOutcome.SelectedIndex = 1;
                                break;
                            case "Early Neonatal Death":
                                rdbOutcome.SelectedIndex = 2;
                                break;
                            case "Late Neonatal Death":
                                rdbOutcome.SelectedIndex = 3;
                                break;
                            case "Death Uncertain Timing":
                                rdbOutcome.SelectedIndex = 4;
                                break;
                        }
                        string DeseaseCategory = rows[0]["DeseaseCategory"].ToString();
                        switch (DeseaseCategory)
                        {
                            case "Asphyxia":
                                rdbDeseaseCategory.SelectedIndex = 0;
                                break;

                            case "Infection":
                                rdbDeseaseCategory.SelectedIndex = 1;
                                break;
                            case "Congenital Abnormality":
                                rdbDeseaseCategory.SelectedIndex = 2;
                                break;
                            case "Trauma":
                                rdbDeseaseCategory.SelectedIndex = 3;
                                break;
                        }
                        txtDocumentedBy.Text = StockReports.ExecuteScalar("SELECT NAME FROM  `employee_master` where EmployeeID='" + rows[0]["DocumentedBy"].ToString() + "'");

                        txtDeliveryPlace.Text = Session["CentreName"].ToString();
                        txtDate.Text = rows[0]["DATE1"].ToString();

                        //txtDate.Text =  Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
                        //((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");

                        ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["Time"].ToString()).ToString("HH:mm tt"); 
                    }
                
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('../../Design/IPD/DeliveryReportGenerationForm_Print.aspx?TestID=O23&LabType=&LabreportType=11&PID=" + ViewState["PatientID"] + "');", true);

    }
    
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string count = StockReports.ExecuteScalar("Select count(*) from deliveryreportgeneration where PatientId='" + ViewState["PatientID"].ToString() + "' order by ID desc ");
            if (count == "0")
            {
                string entrydate = Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd");
                string time = Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss");
                string sql = "INSERT INTO `deliveryreportgeneration` (" +

     " `MotherEncounterNr`,  `DeliveryNr`,  `Gender`,  `DeliveryPlace`,  `DeliveryMode`,  `ReasonIfCaesarean`,  `BornBeforeArrival`,  `FacePresentation`,  `PosterioOccipitalPosition`," +
    "  `DeliveryRank`,  `ApgarScore1Min`,  `ApgarScore5Min`,  `ApgarScore10Min`,  `TimeToSpontanRespiration`,  `Condition`,  `WeightAtBirth`,  `LengthAtBirth`,  `HeadCircumference`," +
    "`ScoredGestationalAge`,  `Feeding`,  `Classification`,  `Outcome`,  `DeseaseCategory`,  `DocumentedBy`,  `Date`,  `Time`,`PatientID`,`CongenitalAbnormality`)" +
    " VALUES  (        '" + txtMotherEncounterNr.Text + "',    '" + txtDeliveryNr.Text + "',    '" + rdbGender.SelectedValue + "',    '" + txtDeliveryPlace.Text + "',    '" + rdbDeliveryMode.SelectedValue + "'," +
    "    '" + txtReasonIfCaesarean.Text + "',    '" + rdbBornBeforeArrival.SelectedValue + "',    '" + rdbFacePresentation.SelectedValue + "',    '" + rdbPosterioOccipitalPosition.SelectedValue + "'," +
    "    '" + txtDeliveryRank.Text + "',    '" + rdbApgarScore1Min.SelectedValue + "',    '" + rdbApgarScore5Min.SelectedValue + "',    '" + rdbApgarScore10Min.SelectedValue + "'," +
    "    '" + txtTimeToSpontanRespiration.Text + "',    '" + txtCondition.Text + "',    '" + txtWeightAtBirth.Text + "',    '" + txtLengthAtBirth.Text + "',    '" + txtHeadCircumference.Text + "'," +
    "    '" + txtScoredGestationalAge.Text + "',    '" + rdbFeeding.SelectedValue + "',    '" + txtClassification.Text + "',    '" + rdbOutcome.SelectedValue + "',    '" + rdbDeseaseCategory.SelectedValue + "'," +
    "    '" + Session["ID"].ToString() + "',    '" + entrydate + "',    '" + time + "','" + ViewState["PatientID"].ToString() + "' ,'" + txtCongenitalAbnormality .Text+ "' );";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                tnx.Commit();
                con.Close();
                con.Dispose();
                btnSave.Enabled = false;
                
                BindDetails();
                lblMsg.Text = "Record Saved Successfully.";
                clear();
            }
            else
            {
                string entrydate = Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd");
                string time = Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss");
                string sql = "UPDATE  `deliveryreportgeneration` set " +

     " `MotherEncounterNr`='" + txtMotherEncounterNr.Text + "',  `DeliveryNr`= '" + txtDeliveryNr.Text + "',  `Gender`= '" + rdbGender.SelectedValue + "',  `DeliveryPlace`='" + txtDeliveryPlace.Text + "'" +
     ",  `DeliveryMode`='" + rdbDeliveryMode.SelectedValue + "',  `ReasonIfCaesarean`='" + txtReasonIfCaesarean.Text + "',  `BornBeforeArrival`=  '" + rdbBornBeforeArrival.SelectedValue + "'" +
     ",  `FacePresentation`=  '" + rdbFacePresentation.SelectedValue + "',  `PosterioOccipitalPosition`='" + rdbPosterioOccipitalPosition.SelectedValue + "'," +
    "  `DeliveryRank`= '" + txtDeliveryRank.Text + "',  `ApgarScore1Min`= '" + rdbApgarScore1Min.SelectedValue + "',  `ApgarScore5Min`= '" + rdbApgarScore5Min.SelectedValue + "'" +
    ",  `ApgarScore10Min`= '" + rdbApgarScore10Min.SelectedValue + "',  `TimeToSpontanRespiration`= '" + txtTimeToSpontanRespiration.Text + "',  `Condition`= '" + txtCondition.Text + "'" +
    ",  `WeightAtBirth`=  '" + txtWeightAtBirth.Text + "',  `LengthAtBirth`=    '" + txtLengthAtBirth.Text + "',  `HeadCircumference`='" + txtHeadCircumference.Text + "'," +
    "`ScoredGestationalAge`='" + txtScoredGestationalAge.Text + "',  `Feeding`= '" + rdbFeeding.SelectedValue + "',  `Classification` ='" + txtClassification.Text + "',  `Outcome`='" + rdbOutcome.SelectedValue + "'" +
    ",  `DeseaseCategory`=   '" + rdbDeseaseCategory.SelectedValue + "',  `DocumentedBy`= '" + Session["ID"].ToString() + "',`CongenitalAbnormality`='" + txtCongenitalAbnormality.Text + "' where ID='" + ViewState["ID"].ToString() + "'  ;";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                tnx.Commit();
                con.Close();
                con.Dispose();
                BindDetails();
                lblMsg.Text = "Record Saved Successfully.";
                clear();
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }


    protected void grid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        
    }
    protected void grid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            
        }
    }

    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "Change")
            {
                lblMsg.Text = "";

                int id = Convert.ToInt16(e.CommandArgument.ToString());

                string ID1 = ((Label)grid.Rows[id].FindControl("lblID")).Text;

                ViewState["ID"] = ID1;
                DataTable dt = (DataTable)ViewState["dtDetails"];
                DataRow[] rows = dt.Select("ID = '" + ID1 + "'");
                if (rows.Length > 0)
                {
                    txtMotherEncounterNr.Text = rows[0]["MotherEncounterNr"].ToString();
                    txtDeliveryNr.Text = rows[0]["DeliveryNr"].ToString();
                    string gender = rows[0]["Gender"].ToString();
                    if (gender == "Male")
                    {
                        rdbGender.SelectedIndex = 0; 
                    }
                    else
                    {
                        rdbGender.SelectedIndex = 1;
                    }
                    //txtDeliveryPlace.Text = rows[0]["DeliveryPlace"].ToString();
                    string deliverymode = rows[0]["DeliveryMode"].ToString();
                    switch (deliverymode)
                    {
                        case "Normal":
                            rdbDeliveryMode.SelectedIndex = 0;
                            break;
                        case "Breech":
                            rdbDeliveryMode.SelectedIndex = 1;
                            break;
                        case "Caesarean":
                            rdbDeliveryMode.SelectedIndex = 2;
                            break;
                        case "Forceps":
                            rdbDeliveryMode.SelectedIndex = 3;
                            break;
                        case "Vacuum":
                            rdbDeliveryMode.SelectedIndex = 4;
                            break;
                    }

                    txtReasonIfCaesarean.Text = rows[0]["ReasonIfCaesarean"].ToString();
                    string BornBeforeArrival = rows[0]["BornBeforeArrival"].ToString();
                    if (BornBeforeArrival == "Yes")
                    {
                        rdbBornBeforeArrival.SelectedIndex = 0;
                    }
                    else
                    {
                        rdbBornBeforeArrival.SelectedIndex = 1;
                    }
                    string FacePresentation = rows[0]["FacePresentation"].ToString();
                    if (FacePresentation == "Yes")
                    {
                        rdbFacePresentation.SelectedIndex = 0;
                    }
                    else
                    {
                        rdbFacePresentation.SelectedIndex = 1;
                    }
                    string PosterioOccipitalPosition = rows[0]["PosterioOccipitalPosition"].ToString();
                    if (PosterioOccipitalPosition == "Yes")
                    {
                        rdbPosterioOccipitalPosition.SelectedIndex = 0;
                    }
                    else
                    {
                        rdbPosterioOccipitalPosition.SelectedIndex = 1;
                    }

                    txtDeliveryRank.Text = rows[0]["DeliveryRank"].ToString();
                    string apgarscore1min = rows[0]["ApgarScore1Min"].ToString();
                    rdbApgarScore1Min.SelectedIndex = Int32.Parse(apgarscore1min);

                    string apgarscore5min = rows[0]["ApgarScore5Min"].ToString();
                    rdbApgarScore5Min.SelectedIndex = Int32.Parse(apgarscore5min);

                    string apgarscore10min = rows[0]["ApgarScore10Min"].ToString();
                    rdbApgarScore10Min.SelectedIndex = Int32.Parse(apgarscore10min);

                    txtTimeToSpontanRespiration.Text = rows[0]["TimeToSpontanRespiration"].ToString();
                    txtCondition.Text = rows[0]["Condition"].ToString();
                    txtWeightAtBirth.Text = rows[0]["WeightAtBirth"].ToString();
                    txtLengthAtBirth.Text = rows[0]["LengthAtBirth"].ToString();
                    txtHeadCircumference.Text = rows[0]["HeadCircumference"].ToString();
                    txtScoredGestationalAge.Text = rows[0]["ScoredGestationalAge"].ToString();
                    string Feeding = rows[0]["Feeding"].ToString();
                    switch (Feeding)
                    {
                        case "Breast":
                            rdbFeeding.SelectedIndex = 0;
                            break;
                        case "Formula":
                            rdbFeeding.SelectedIndex = 1;
                            break;
                        case "Both":
                            rdbFeeding.SelectedIndex = 2;
                            break;
                        case "Parenteral":
                            rdbFeeding.SelectedIndex = 3;
                            break;
                        case "Never Fed":
                            rdbFeeding.SelectedIndex = 4;
                            break;
                    }

                    txtCongenitalAbnormality.Text = rows[0]["CongenitalAbnormality"].ToString();
                    txtClassification.Text = rows[0]["Classification"].ToString();
                    string Outcome = rows[0]["Outcome"].ToString();
                    switch (Outcome)
                    {
                        case "Alive":
                            rdbOutcome.SelectedIndex = 0;
                            break;
                        case "Still Born":
                            rdbOutcome.SelectedIndex = 1;
                            break;
                        case "Early Neonatal Death":
                            rdbOutcome.SelectedIndex = 2;
                            break;
                        case "Late Neonatal Death":
                            rdbOutcome.SelectedIndex = 3;
                            break;
                        case "Death Uncertain Timing":
                            rdbOutcome.SelectedIndex = 4;
                            break;
                    }
                    string DeseaseCategory = rows[0]["DeseaseCategory"].ToString();
                    switch (DeseaseCategory)
                    {
                        case "Asphyxia":
                            rdbDeseaseCategory.SelectedIndex = 0;
                            break;
                       
                        case "Infection":
                            rdbDeseaseCategory.SelectedIndex = 1;
                            break;
                        case "Congenital Abnormality":
                            rdbDeseaseCategory.SelectedIndex = 2;
                            break;
                        case "Trauma":
                            rdbDeseaseCategory.SelectedIndex = 3;
                            break;
                    }
                    txtDocumentedBy.Text = StockReports.ExecuteScalar("SELECT NAME FROM  `employee_master` where EmployeeID='" + rows[0]["DocumentedBy"].ToString() + "'");

                    txtDeliveryPlace.Text = Session["CentreName"].ToString();
                    btnSave.Visible = false;
                    btnUpdate.Visible = true;

                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string entrydate = Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss");
            string sql = "UPDATE  `deliveryreportgeneration` set " +

 " `MotherEncounterNr`='" + txtMotherEncounterNr.Text + "',  `DeliveryNr`= '" + txtDeliveryNr.Text + "',  `Gender`= '" + rdbGender.SelectedValue + "',  `DeliveryPlace`='" + txtDeliveryPlace.Text + "'"+
 ",  `DeliveryMode`='" + rdbDeliveryMode.SelectedValue + "',  `ReasonIfCaesarean`='" + txtReasonIfCaesarean.Text + "',  `BornBeforeArrival`=  '" + rdbBornBeforeArrival.SelectedValue + "'"+
 ",  `FacePresentation`=  '" + rdbFacePresentation.SelectedValue + "',  `PosterioOccipitalPosition`='" + rdbPosterioOccipitalPosition.SelectedValue + "'," +
"  `DeliveryRank`= '" + txtDeliveryRank.Text + "',  `ApgarScore1Min`= '" + rdbApgarScore1Min.SelectedValue + "',  `ApgarScore5Min`= '" + rdbApgarScore5Min.SelectedValue + "'"+
",  `ApgarScore10Min`= '" + rdbApgarScore10Min.SelectedValue + "',  `TimeToSpontanRespiration`= '" + txtTimeToSpontanRespiration.Text + "',  `Condition`= '" + txtCondition.Text + "'"+
",  `WeightAtBirth`=  '" + txtWeightAtBirth.Text + "',  `LengthAtBirth`=    '" + txtLengthAtBirth.Text + "',  `HeadCircumference`='" + txtHeadCircumference.Text + "'," +
"`ScoredGestationalAge`='" + txtScoredGestationalAge.Text + "',  `Feeding`= '" + rdbFeeding.SelectedValue + "',  `Classification` ='" + txtClassification.Text + "',  `Outcome`='" + rdbOutcome.SelectedValue + "'"+
",  `DeseaseCategory`=   '" + rdbDeseaseCategory.SelectedValue + "',  `DocumentedBy`= '" + Session["ID"].ToString() + "',`Date`='"+entrydate+"',  `Time`='"+time+"'  where ID='" + ViewState["ID"].ToString() + "'  ;";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            tnx.Commit();
            con.Close();
            con.Dispose();
            btnUpdate.Enabled = false;
            BindDetails();
            lblMsg.Text = "Record Saved Successfully.";
            clear();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = ex.Message;
        } 
        clear();
        lblMsg.Text = "Record Updated Successfully.";
    }
    private void clear()
    {
       
    }
    protected void bynCancel_Click(object sender, EventArgs e)
    {
        clear();
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        bynCancel.Visible = false;
    }
}
