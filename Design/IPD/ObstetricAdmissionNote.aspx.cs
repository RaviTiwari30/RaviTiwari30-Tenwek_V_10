using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_ip_ObstetricAdmissionNote : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        CalendarExtender7.EndDate = DateTime.Now;
        caldate.EndDate = DateTime.Now;
        CalendarExtender1.EndDate = DateTime.Now;
        CalendarExtender2.EndDate = DateTime.Now;
        CalendarExtender3.EndDate = DateTime.Now;
        CalendarExtender4.EndDate = DateTime.Now;
        CalendarExtender5.EndDate = DateTime.Now;
        CalendarExtender6.EndDate = DateTime.Now;
        CalendarExtender7.EndDate = DateTime.Now;
        CalendarExtender7.EndDate = DateTime.Now;
        CalendarExtender7.EndDate = DateTime.Now;
        txtDate.Attributes.Add("readOnly", "true");
        txtHistoryoflabourbeganondate.Attributes.Add("readOnly", "true");
        ROMdates.Attributes.Add("readOnly", "true");
        txtAbdominalDateofExamination.Attributes.Add("readOnly", "true");
        txtVaginalDateOfExamination.Attributes.Add("readOnly", "true");
        Date1.Attributes.Add("readOnly", "true");
        Date2.Attributes.Add("readOnly", "true");
        Date3.Attributes.Add("readOnly", "true");

        if (!IsPostBack)
        {

            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");

            txtHistoryoflabourbeganondate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ((TextBox)Attime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            ROMdates.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ((TextBox)ROMTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            txtAbdominalDateofExamination.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ((TextBox)AbdominalTimeofExamination.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            txtVaginalDateOfExamination.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ((TextBox)txtVaginalTimeOfExamination.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            Date1.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            Date2.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            Date3.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            ViewState["PID"] = Request.QueryString["PatientID"].ToString();
            BindDetails();
            //BindDetails();
        }

    }
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    public string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("\"{0}\":\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));
            }
            sb.Append(sb2.ToString());
            sb.Append("}");
        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }


    public DataTable BindItem()
    {
        string transactionid = Util.GetString(Request.QueryString["TransactionID"]);
        string category = Util.GetString(Request.QueryString["category"]);
        string subcategory = Util.GetString(Request.QueryString["subcategory"]);
        string itemName = Util.GetString(Request.QueryString["q"]);
        int ReferenceCode = Util.GetInt(Request.QueryString["ReferenceCode"].ToString().Trim());
        string IPDCaseTypeID = Util.GetString(Request.QueryString["IPDCaseTypeID"]);
        string ScheduleChargeID = Util.GetString(Request.QueryString["ScheduleChargeID"]);
        string limit = Util.GetString(Request.QueryString["rows"]);
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT TypeName,SubCategoryName,ItemCode,IF(Rate IS NULL,0,Rate) Rate, ");
        sb.Append("CONCAT(ItemId,'#',IF(Rate IS NULL,0,Rate),'#' ");
        sb.Append(",IF(IFNULL(ItemDisplayName,'')='',TypeName,ItemDisplayName),'#' ");
        sb.Append(",IF(ItemCode IS NULL,CPTCode,ItemCode),'#',IF(RateListID IS NULL,'',RateListID),'#',RateEditable,'#',GSTDetails,'#','NA','#','NA', ");
        sb.Append("'#','NA','#','NA','#',Type_ID,'#',SubCategoryID,'#',ConfigID)ItemId FROM (  ");
        sb.Append("SELECT im.TypeName AS TypeName,sub.Name AS SubCategoryName, ");
        sb.Append("IM.ItemID,IFNULL(IM.Type_ID,'')Type_ID,IM.SubCategoryID,RL.Rate,RL.ItemDisplayName,RL.ItemCode,RL.RateListID,IM.RateEditable,IM.ItemCode CPTCode, ");
        sb.Append("cf.ConfigID,CONCAT(IFNULL(IM.HSNCode,''),'^',IM.IGSTPercent,'^',IM.SGSTPercent,'^',IM.CGSTPercent,'^',IFNULL(IM.GSTType,''))GSTDetails ");
        sb.Append("FROM f_itemmaster IM  ");
        sb.Append("INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` ");
        sb.Append("INNER JOIN f_subcategorymaster sub ON  IM.SubCategoryID=sub.SubCategoryID   ");
        sb.Append("INNER JOIN f_configrelation cf ON cf.CategoryID = sub.CategoryID  ");
        sb.Append("LEFT JOIN (  ");
        sb.Append("SELECT ID RateListID,ItemID,Rate,ItemDisplayName,ItemCode FROM f_ratelist_ipd WHERE  IPDCaseTypeID='" + IPDCaseTypeID.Trim() + "'  ");
        sb.Append("AND ScheduleChargeID='" + ScheduleChargeID.Trim() + "' AND PanelID=" + ReferenceCode + "  AND IsCurrent=1  ");
        sb.Append(") RL ON RL.ItemID=IM.ItemID WHERE cf.ConfigID IN (2,6,8,9,10,20,24,14,26,27,29) AND im.Isactive=1 AND itc.`IsActive`=1 AND itc.CentreID='" + Session["CentreID"].ToString() + "' ");
        sb.Append(" AND TypeName like '%" + itemName.Trim() + "%' ");
        if (category != "0" && category != "null")
        {
            sb.Append(" AND cf.CategoryID='" + category + "'");
        }
        if (subcategory != "0" && subcategory != "null")
        {
            sb.Append("   AND sub.SubCategoryID='" + subcategory + "'");
        }
        sb.Append("  LIMIT " + Util.GetString(Request.QueryString["rows"]) + " )t  ORDER BY TypeName ");
        return StockReports.GetDataTable(sb.ToString());
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        try
        {
            Clear();
            lblMsg.Text = "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            if (!Validation())
            {
                return;
            }
            string result = SaveData();
            if (result != string.Empty)
            {
                if (result == "0")
                {
                    return;
                }

                lblMsg.Text = "Record Saved Successfully";
                BindDetails();
                Clear();
            }
            else
            {
                lblMsg.Text = "Record not Saved";
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
        if (!Validation())
        {
            return;
        }

        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("UPDATE  `obstetricadmissionnotes` SET   `Grav` = '"+txtGrav.Text+"',  `P` = '"+txtP.Text+"',  `Plus` = '"+txtPlus.Text+"',  `Living` = '"+txtLiving.Text+"',  `Dead` = '"+txtDead.Text+"',"+
"  `LMP` = '"+txtLMP.Text+"', `EDD` = '"+txtEDD.Text+"',  `Gestation` = '"+txtGestation.Text+"',  `Wks` = '"+txtWks.Text+"',  `Days` = '"+txtDays.Text+"',  `Anenatalcare` = '"+txtAnenatalcare.Text+"',"+
"  `VisitWhere` = '"+txtVisitWhere.Text+"',  `HospitalDeliveries` = '"+txtHospitalDeliveries.Text+"',  `CaesreanSection` = '"+txtCaesreanSection.Text+"',  `VBACS` = '"+txtVBACS.Text+"',"+
"  `APH` = '"+txtAPH.Text+"',  `PPH` = '"+txtPPH.Text+"',  `PreEclamp` = '"+txtPreEclamp.Text+"',  `Stillbirth` = '"+txtStillbirth.Text+"',  `Preterm` = '"+txtPreterm.Text+"',"+
"  `AbortionsMiscarriages` = '"+txtAbortionsMiscarriages.Text+"',  `Firstweekmortality` = '"+txtFirstweekmortality.Text+"',  `NeonatalJaundice` = '"+txtNeonatalJaundice.Text+"',"+
"  `FamilyPlanningawareness` = '"+rdbFamilyPlanningawareness.SelectedItem.Text+"',  `AnyFPUsed` = '"+rdbAnyFPUsed.SelectedItem.Text+"',  `Historyoflabourbeganondate` = '"+Util.GetDateTime(txtHistoryoflabourbeganondate.Text.Trim()).ToString("yyyy-MM-dd")+"',"+
"  `Attime` = '" + Util.GetDateTime(((TextBox)Attime.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "',  `ROM` = '"+rdbROM.SelectedItem.Text+"',  `ROMdates` = '"+
Util.GetDateTime(ROMdates.Text.Trim()).ToString("yyyy-MM-dd") + "',  `ROMTime` = '" + Util.GetDateTime(((TextBox)ROMTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "',  `Colouroffluid` = '" + txtColouroffluid.Text + "'," +
"  `HeartDisease` = '"+rdbHeartDisease.SelectedItem.Text+"',  `Hypertension` = '"+rdbHypertension.SelectedItem.Text+"',  `KidneyDisease` = '"+rdbKidneyDisease.SelectedItem.Text+"',  `Diabetes` = '"+rdbDiabetes.SelectedItem.Text+"',"+
"  `Convulsions` = '"+rdbConvulsions.SelectedItem.Text+"',  `TB` = '"+rdbTB.SelectedItem.Text+"',  `Infertility` = '"+rdbInfertility.SelectedItem.Text+"',  `Other` = '"+rdbOther.SelectedItem.Text+"',"+
"  `Chiefcomplaint` = '"+txtChiefcomplaint.Text+"',  `historyandphysicalexam` = '"+txthistoryandphysicalexam.Text+"',  `AbdominalDateofExamination` = '"+Util.GetDateTime(txtAbdominalDateofExamination.Text.Trim()).ToString("yyyy-MM-dd")+"',"+
"  `AbdominalTimeofExamination` = '" + Util.GetDateTime(((TextBox)AbdominalTimeofExamination.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "',  `StaffPerforming` = '" + txtStaffPerforming.Text + "',  `Reasonfordoingexam` = '" + txtReasonfordoingexam.Text + "'," +
"  `externalGenitalia` = '"+txtexternalGenitalia.Text+"',  `AnyDischarge` = '"+rdbAnyDischarge.SelectedItem.Text+"',  `CervixDilation` = '"+txtCervixDilation.Text+"',"+
"  `Effacement` = '"+txtEffacement.Text+"',  `Applictoprespart` = '"+txtApplictoprespart.Text+"',  `MembranesIntact` = '"+rdbMembranesIntact.SelectedItem.Text+"',"+
"  `CordFelt` = '"+rdbCordFelt.SelectedItem.Text+"',  `Presentation` = '"+txtPresentation.Text+"',  `PresentingPart` = '"+txtPresentingPart.Text+"',"+
"  `Station` = '"+txtStation.Text+"',  `Moulding` = '"+txtMoulding.Text+"',  `Caput` = '"+txtCaput.Text+"',  `PevlisPublicArch` = '"+txtPevlisPublicArch.Text+"',"+
"  `Ischialspines` = '"+txtIschialspines.Text+"',  `SacralPromontory` = '"+txtSacralPromontory.Text+"',  `CurveofSacrum` = '"+txtCurveofSacrum.Text+"',"+
"  `IschialTuberosities` = '"+txtIschialTuberosities.Text+"',  `PelvisAdequate` = '"+rdbPelvisAdequate.SelectedItem.Text+"',  `AttentionCriticalExamFeatures` = '"+txtAttentionCriticalExamFeatures.Text+"',"+
"  `AttentionLabsBloodType` = '"+txtAttentionLabsBloodType.Text+"',  `Rh` = '"+txtRh.Text+"',  `Hgb` = '"+txtHgb.Text+"',  `Date1` = '"+Util.GetDateTime(Date1.Text.Trim()).ToString("yyyy-MM-dd")+"',"+
"  `ISS` = '"+txtISS.Text+"',  `Date2` = '"+Util.GetDateTime(Date2.Text.Trim()).ToString("yyyy-MM-dd")+"',  `VDRL` = '"+txtVDRL.Text+"',  `Date3` = '"+Util.GetDateTime(Date3.Text.Trim()).ToString("yyyy-MM-dd")+"',  `NameDateStamp` = '"+txtNameDateStamp.Text+"',"+
"  `Abdominalscar` = '"+rdbAbdominalscar.SelectedItem.Text+"',  `AbdominalscarWhy` = '"+txtAbdominalscarWhy.Text+"',  `FHTperminute` = '"+txtFHTperminute.Text+"',"+
"  `Contractionsstrength` = '"+txtContractionsstrength.Text+"',  `Frequency` = '"+txtFrequency.Text+"',  `duration` = '"+txtduration.Text+"',"+
"  `fundalHeight` = '"+txtfundalHeight.Text+"',  `Lie` = '"+txtLie.Text+"',  `AbdominalPresentation` = '"+txtAbdominalPresentation.Text+"',  `Position` = '"+txtPosition.Text+"',"+
 " `Descent` = '" + txtDescent.Text + "',  `Engaged` = '" + rdbEngaged.SelectedItem.Text + "',  `Date` = '" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',  `Time` = '" + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "'," +
"  `DateVaginalExam` = '" + Util.GetDateTime(txtVaginalDateOfExamination.Text.Trim()).ToString("yyyy-MM-dd") + "',`TimeVaginalExam` ='" + Util.GetDateTime(((TextBox)txtVaginalTimeOfExamination.FindControl("txtTime")).Text).ToString("H:mm:ss") + "', `VaginalStaffPerforming` = '" + txtStaffPerformingVaginal.Text + "'  WHERE ID = '" + lblPID.Text + "' ");


            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            if (result == 1)
                lblMsg.Text = "Record Updated Successfully";
            tnx.Commit();
            BindDetails();
            Clear();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "Change")
            {
                int id = Convert.ToInt16(e.CommandArgument.ToString());
                lblPID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;

                DataTable dt = (DataTable)ViewState["dt"];
                DataRow[] rows = dt.Select("Id = '" + lblPID.Text + "'");
                if (rows.Length > 0)
                {
                    txtGrav.Text = rows[0]["Grav"].ToString();
                    txtP.Text = rows[0]["P"].ToString();
                    txtPlus.Text = rows[0]["Plus"].ToString();
                    txtLiving.Text = rows[0]["Living"].ToString();
                    txtDead.Text = rows[0]["Dead"].ToString();
                    txtLMP.Text = rows[0]["LMP"].ToString();
                    txtEDD.Text = rows[0]["EDD"].ToString();
                    txtGestation.Text = rows[0]["Gestation"].ToString();
                    txtWks.Text = rows[0]["Wks"].ToString();
                    txtDays.Text = rows[0]["Days"].ToString();
                    txtAnenatalcare.Text = rows[0]["Anenatalcare"].ToString();
                    txtVisitWhere.Text = rows[0]["VisitWhere"].ToString();
                    txtHospitalDeliveries.Text = rows[0]["HospitalDeliveries"].ToString();
                    txtCaesreanSection.Text = rows[0]["CaesreanSection"].ToString();
                    txtVBACS.Text = rows[0]["VBACS"].ToString();
                    txtAPH.Text = rows[0]["APH"].ToString();
                    txtPPH.Text = rows[0]["PPH"].ToString();
                    txtPreEclamp.Text = rows[0]["PreEclamp"].ToString();
                    txtStillbirth.Text = rows[0]["Stillbirth"].ToString();
                    txtPreterm.Text = rows[0]["Preterm"].ToString();
                    txtAbortionsMiscarriages.Text = rows[0]["AbortionsMiscarriages"].ToString();
                    txtFirstweekmortality.Text = rows[0]["Firstweekmortality"].ToString();
                    txtNeonatalJaundice.Text = rows[0]["NeonatalJaundice"].ToString();
                    string FamilyPlanningawareness = rows[0]["FamilyPlanningawareness"].ToString();
                    switch (FamilyPlanningawareness.Trim())
                    {
                        case "Yes":
                            rdbFamilyPlanningawareness.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbFamilyPlanningawareness.SelectedIndex = 1;
                            break;
                    }
                    string AnyFPUsed = rows[0]["AnyFPUsed"].ToString();
                    switch (AnyFPUsed.Trim())
                    {
                        case "Yes":
                            rdbAnyFPUsed.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbAnyFPUsed.SelectedIndex = 1;
                            break;
                    }

                    txtHistoryoflabourbeganondate.Text = rows[0]["Historyoflabourbeganondate1"].ToString();
                    ((TextBox)Attime.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["Attime1"].ToString()).ToString("hh:mm tt");
                    string ROM = rows[0]["ROM"].ToString();
                    switch (ROM.Trim())
                    {
                        case "Yes":
                            rdbROM.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbROM.SelectedIndex = 1;
                            break;
                    }

                    //txtHistoryoflabourbeganondate.Text = rows[0]["Historyoflabourbeganondate"].ToString();
                    ROMdates.Text = rows[0]["ROMdates1"].ToString();
                    ((TextBox)ROMTime.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["ROMTime1"].ToString()).ToString("hh:mm tt");
                    txtColouroffluid.Text = rows[0]["Colouroffluid"].ToString();
                    string HeartDisease = rows[0]["HeartDisease"].ToString();
                    switch (HeartDisease.Trim())
                    {
                        case "Yes":
                            rdbHeartDisease.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbHeartDisease.SelectedIndex = 1;
                            break;
                    }
                    string Hypertension = rows[0]["Hypertension"].ToString();
                    switch (Hypertension.Trim())
                    {
                        case "Yes":
                            rdbHypertension.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbHypertension.SelectedIndex = 1;
                            break;
                    }
                    string KidneyDisease = rows[0]["KidneyDisease"].ToString();
                    switch (KidneyDisease.Trim())
                    {
                        case "Yes":
                            rdbKidneyDisease.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbKidneyDisease.SelectedIndex = 1;
                            break;
                    }
                    string Diabetes = rows[0]["Diabetes"].ToString();
                    switch (Diabetes.Trim())
                    {
                        case "Yes":
                            rdbDiabetes.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbDiabetes.SelectedIndex = 1;
                            break;
                    }
                    string Convulsions = rows[0]["Convulsions"].ToString();
                    switch (Convulsions.Trim())
                    {
                        case "Yes":
                            rdbConvulsions.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbConvulsions.SelectedIndex = 1;
                            break;
                    }
                    string TB = rows[0]["TB"].ToString();
                    switch (TB.Trim())
                    {
                        case "Yes":
                            rdbTB.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbTB.SelectedIndex = 1;
                            break;
                    }
                    string Infertility = rows[0]["Infertility"].ToString();
                    switch (Infertility.Trim())
                    {
                        case "Yes":
                            rdbInfertility.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbInfertility.SelectedIndex = 1;
                            break;
                    }
                    string Other = rows[0]["Other"].ToString();
                    switch (Other.Trim())
                    {
                        case "Yes":
                            rdbOther.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbOther.SelectedIndex = 1;
                            break;
                    }

                    txtChiefcomplaint.Text = rows[0]["Chiefcomplaint"].ToString();
                    txthistoryandphysicalexam.Text = rows[0]["historyandphysicalexam"].ToString();
                    txtAbdominalDateofExamination.Text = rows[0]["AbdominalDateofExamination1"].ToString();
                    ((TextBox)AbdominalTimeofExamination.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["AbdominalTimeofExamination1"].ToString()).ToString("hh:mm tt");
                    txtStaffPerforming.Text = rows[0]["StaffPerforming"].ToString();

                    string Abdominalscar = rows[0]["Abdominalscar"].ToString();
                    switch (Abdominalscar.Trim())
                    {
                        case "Yes":
                            rdbAbdominalscar.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbAbdominalscar.SelectedIndex = 1;
                            break;
                    }
                    txtAbdominalscarWhy.Text = rows[0]["AbdominalscarWhy"].ToString();
                    txtFHTperminute.Text = rows[0]["FHTperminute"].ToString();
                    txtContractionsstrength.Text = rows[0]["Contractionsstrength"].ToString();
                    txtFrequency.Text = rows[0]["Frequency"].ToString();
                    txtduration.Text = rows[0]["duration"].ToString();
                    txtfundalHeight.Text = rows[0]["fundalHeight"].ToString();
                    txtLie.Text = rows[0]["Lie"].ToString();
                    txtAbdominalPresentation.Text = rows[0]["AbdominalPresentation"].ToString();
                    txtPosition.Text = rows[0]["Position"].ToString();
                    txtDescent.Text = rows[0]["Descent"].ToString();
                    string Engaged = rows[0]["Engaged"].ToString();
                    switch (Engaged.Trim())
                    {
                        case "Yes":
                            rdbEngaged.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbEngaged.SelectedIndex = 1;
                            break;
                    }
                    //txtVaginalDateOfExamination.Text = rows[0]["VaginalDateOfExamination1"].ToString();
                    //((TextBox)txtVaginalTimeOfExamination.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["VaginalTimeOfExamination1"].ToString()).ToString("hh:mm tt");
                    //txtStaffPerformingVaginal.Text = rows[0]["StaffPerformingVaginal"].ToString();
                    txtReasonfordoingexam.Text = rows[0]["Reasonfordoingexam"].ToString();
                    txtexternalGenitalia.Text = rows[0]["externalGenitalia"].ToString();
                    string AnyDischarge = rows[0]["AnyDischarge"].ToString();
                    switch (AnyDischarge.Trim())
                    {
                        case "Yes":
                            rdbAnyDischarge.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbAnyDischarge.SelectedIndex = 1;
                            break;
                    }
                    txtCervixDilation.Text = rows[0]["CervixDilation"].ToString();
                    txtEffacement.Text = rows[0]["Effacement"].ToString();
                    txtApplictoprespart.Text = rows[0]["Applictoprespart"].ToString();
                    string MembranesIntact = rows[0]["MembranesIntact"].ToString();
                    switch (MembranesIntact.Trim())
                    {
                        case "Yes":
                            rdbMembranesIntact.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbMembranesIntact.SelectedIndex = 1;
                            break;
                    }
                    string CordFelt = rows[0]["CordFelt"].ToString();
                    switch (CordFelt.Trim())
                    {
                        case "Yes":
                            rdbCordFelt.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbCordFelt.SelectedIndex = 1;
                            break;
                    }
                    txtPresentation.Text = rows[0]["Presentation"].ToString();
                    txtPresentingPart.Text = rows[0]["PresentingPart"].ToString();
                    txtStation.Text = rows[0]["Station"].ToString();
                    txtMoulding.Text = rows[0]["Moulding"].ToString();
                    txtCaput.Text = rows[0]["Caput"].ToString();
                    txtPevlisPublicArch.Text = rows[0]["PevlisPublicArch"].ToString();
                    txtIschialspines.Text = rows[0]["Ischialspines"].ToString();
                    txtSacralPromontory.Text = rows[0]["SacralPromontory"].ToString();
                    txtCurveofSacrum.Text = rows[0]["CurveofSacrum"].ToString();
                    txtIschialTuberosities.Text = rows[0]["IschialTuberosities"].ToString();
                    string PelvisAdequate = rows[0]["PelvisAdequate"].ToString();
                    switch (PelvisAdequate.Trim())
                    {
                        case "Yes":
                            rdbPelvisAdequate.SelectedIndex = 0;
                            break;
                        case "No":
                            rdbPelvisAdequate.SelectedIndex = 1;
                            break;
                    }
                    txtAttentionCriticalExamFeatures.Text = rows[0]["AttentionCriticalExamFeatures"].ToString();
                    txtAttentionLabsBloodType.Text = rows[0]["AttentionLabsBloodType"].ToString();
                    txtRh.Text = rows[0]["Rh"].ToString();
                    txtHgb.Text = rows[0]["Hgb"].ToString();
                    Date1.Text = rows[0]["Date11"].ToString();
                    txtISS.Text = rows[0]["ISS"].ToString();
                    Date2.Text = rows[0]["Date21"].ToString();
                    txtVDRL.Text = rows[0]["VDRL"].ToString();
                    Date3.Text = rows[0]["Date31"].ToString();
                    txtNameDateStamp.Text = rows[0]["NameDateStamp"].ToString();
                    txtStaffPerformingVaginal.Text = rows[0]["VaginalStaffPerforming"].ToString();
                    ((TextBox)txtVaginalTimeOfExamination.FindControl("txtTime")).Text= Util.GetDateTime(rows[0]["TimeVaginalExam1"].ToString()).ToString("hh:mm tt");

                    txtVaginalDateOfExamination.Text = rows[0]["DateVaginalExam1"].ToString();
                    txtDate.Text = rows[0]["Date4"].ToString();
                    ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["Time1"].ToString()).ToString("hh:mm tt");
                    
                }
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                btnCancel.Visible = true;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            //if (e.Row.RowType == DataControlRowType.DataRow)
            //{
            //    if (((Label)e.Row.FindControl("lblUserID")).Text != Session["ID"].ToString() || Util.GetDateTime(((Label)e.Row.FindControl("lblEntryDate")).Text).ToString("dd-MMM-yyyy") != Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy"))
            //    {
            //        ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
            //    }
            //}
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void Clear()
    {
        try
        {

            txtGrav.Text = "";
            txtP.Text = "";
            txtPlus.Text = "";
            txtLiving.Text = "";
            txtDead.Text = "";
            txtLMP.Text = "";
            txtEDD.Text = "";
            txtGestation.Text = "";
            txtWks.Text = "";
            txtDays.Text ="";
            txtAnenatalcare.Text = "";
            txtVisitWhere.Text = "";
            txtHospitalDeliveries.Text = "";
            txtCaesreanSection.Text = "";
            txtVBACS.Text = "";
            txtAPH.Text = "";
            txtPPH.Text = "";
            txtPreEclamp.Text ="";
            txtStillbirth.Text = "";
            txtPreterm.Text ="";
            txtAbortionsMiscarriages.Text = "";
            txtFirstweekmortality.Text = "";
            txtNeonatalJaundice.Text = "";
            
                    rdbFamilyPlanningawareness.SelectedIndex = 0;
                    
                    rdbAnyFPUsed.SelectedIndex = 0;

                    txtHistoryoflabourbeganondate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                    ((TextBox)Attime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");

                    rdbROM.SelectedIndex = 0;
                    ROMdates.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                     ((TextBox)ROMTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");

            txtColouroffluid.Text = "";
            
                    rdbHeartDisease.SelectedIndex = 0;
                    rdbHypertension.SelectedIndex = 0;
                    rdbKidneyDisease.SelectedIndex = 0;
                    rdbDiabetes.SelectedIndex = 0;
                    rdbConvulsions.SelectedIndex = 0;
                    rdbTB.SelectedIndex = 0;
                    rdbInfertility.SelectedIndex = 0;
                    rdbOther.SelectedIndex = 0;
                   
            txtChiefcomplaint.Text = "";
            txthistoryandphysicalexam.Text = "";
            txtAbdominalDateofExamination.Text = "";
            ((TextBox)AbdominalTimeofExamination.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");

            txtStaffPerforming.Text = "";
            rdbAbdominalscar.SelectedIndex = 0;
                 
            txtAbdominalscarWhy.Text = "";
            txtFHTperminute.Text = "";
            txtContractionsstrength.Text = "";
            txtFrequency.Text = "";
            txtduration.Text = "";
            txtfundalHeight.Text = "";
            txtLie.Text = "";
            txtAbdominalPresentation.Text ="";
            txtPosition.Text = "";
            txtDescent.Text = "";
                    rdbEngaged.SelectedIndex = 0;
              txtReasonfordoingexam.Text = "";
            txtexternalGenitalia.Text = "";
                    rdbAnyDischarge.SelectedIndex = 0;
               
            txtCervixDilation.Text = "";
            txtEffacement.Text = "";
            txtApplictoprespart.Text = "";
                    rdbMembranesIntact.SelectedIndex = 0;
                    rdbCordFelt.SelectedIndex = 0;
            txtPresentation.Text = "";
            txtPresentingPart.Text = "";
            txtStation.Text = "";
            txtMoulding.Text = "";
            txtCaput.Text = "";
            txtPevlisPublicArch.Text ="";
            txtIschialspines.Text = "";
            txtSacralPromontory.Text = "";
            txtCurveofSacrum.Text = "";
            txtIschialTuberosities.Text = "";
                    rdbPelvisAdequate.SelectedIndex = 0;
                    txtAttentionCriticalExamFeatures.Text = "";
            txtAttentionLabsBloodType.Text ="";
            txtRh.Text = "";
            txtHgb.Text = "";
            Date1.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtISS.Text = "";
            Date2.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtVDRL.Text = "";
            Date3.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtNameDateStamp.Text = "";
            txtStaffPerformingVaginal.Text = "";
            ((TextBox)txtVaginalTimeOfExamination.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");

            txtVaginalDateOfExamination.Text = "";
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            btnUpdate.Visible = false;
            btnSave.Visible = true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected bool Validation()
    {
        return true;
    }
    private string SaveData()
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO `obstetricadmissionnotes` (  `Grav`,  `P`,  `Plus`,  `Living`,  `Dead`,  `LMP`,  `EDD`,  `Gestation`,  `Wks`,  `Days`,  `Anenatalcare`,  `VisitWhere`,"+
"  `HospitalDeliveries`,  `CaesreanSection`,  `VBACS`,  `APH`,  `PPH`,  `PreEclamp`,  `Stillbirth`,  `Preterm`,  `AbortionsMiscarriages`,  `Firstweekmortality`,  `NeonatalJaundice`,"+
"  `FamilyPlanningawareness`,  `AnyFPUsed`,  `Historyoflabourbeganondate`,  `Attime`,  `ROM`,  `ROMdates`,  `ROMTime`,  `Colouroffluid`,  `HeartDisease`,  `Hypertension`,  `KidneyDisease`,"+
"  `Diabetes`,  `Convulsions`,  `TB`,  `Infertility`,  `Other`,  `Chiefcomplaint`,  `historyandphysicalexam`,  `AbdominalDateofExamination`,  `AbdominalTimeofExamination`,  `StaffPerforming`,"+
"  `Reasonfordoingexam`,  `externalGenitalia`,  `AnyDischarge`,  `CervixDilation`,  `Effacement`,  `Applictoprespart`,  `MembranesIntact`,  `CordFelt`,  `Presentation`,  `PresentingPart`," +
"`Station`,  `Moulding`,  `Caput`,  `PevlisPublicArch`,  `Ischialspines`,  `SacralPromontory`,  `CurveofSacrum`,  `IschialTuberosities`,  `PelvisAdequate`,  `AttentionCriticalExamFeatures`,"+
"  `AttentionLabsBloodType`,  `Rh`,  `Hgb`,  `Date1`,  `ISS`,  `Date2`,  `VDRL`,  `Date3`,  `NameDateStamp`,  `Abdominalscar`,  `AbdominalscarWhy`,  `FHTperminute`,  `Contractionsstrength`,"+
"  `Frequency`,  `duration`,  `fundalHeight`,  `Lie`,  `AbdominalPresentation`,  `Position`,  `Descent`,  `Engaged`,`Date`,`Time`,`EntryBy`,`DateVaginalExam`,`TimeVaginalExam`,`VaginalStaffPerforming`,`PatientId`) " +
"VALUES  (    '"+txtGrav.Text+"',    '"+txtP.Text+"',    '"+txtPlus.Text+"',    '"+txtLiving.Text+"',    '"+txtDead.Text+"',    '"+txtLMP.Text+"',    '"+txtEDD.Text+"',    '"+txtGestation.Text+
"',    '"+txtWks.Text+"',    '"+txtDays.Text+"',    '"+txtAnenatalcare.Text+"',"+
"    '"+txtVisitWhere.Text+"',    '"+txtHospitalDeliveries.Text+"',    '"+txtCaesreanSection.Text+"',    '"+txtVBACS.Text+"',    '"+txtAPH.Text+"',    '"+txtPPH.Text+"',    '"+txtPreEclamp.Text+
"',    '"+txtStillbirth.Text+"',"+
"    '" + txtPreterm.Text + "',    '" + txtAbortionsMiscarriages.Text + "',    '" + txtFirstweekmortality.Text + "',    '" + txtNeonatalJaundice.Text + "',    '" +
rdbFamilyPlanningawareness.SelectedItem.Text + "',    '" + rdbAnyFPUsed.SelectedItem.Text + "'," +
"    '" + Util.GetDateTime(txtHistoryoflabourbeganondate.Text.Trim()).ToString("yyyy-MM-dd") + "',    '" + Util.GetDateTime(((TextBox)Attime.FindControl("txtTime")).Text).ToString("HH:mm:ss") +
"',    '" + rdbROM.SelectedItem.Text + "',    '" + Util.GetDateTime(ROMdates.Text.Trim()).ToString("yyyy-MM-dd") + "',    '" + Util.GetDateTime(((TextBox)ROMTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") +
"',    '" + txtColouroffluid.Text + "',    '" + rdbHeartDisease.SelectedItem.Text + "',    '"+rdbHypertension.SelectedItem.Text+"'," +
"    '"+rdbKidneyDisease.SelectedItem.Text+"',    '"+rdbDiabetes.SelectedItem.Text+"',    '"+rdbConvulsions.SelectedItem.Text+"',    '"+rdbTB.SelectedItem.Text+"',    '"+rdbInfertility.SelectedItem.Text+"',    '"+rdbOther.SelectedItem.Text+"',    '"+txtChiefcomplaint.Text+"',    '"+txthistoryandphysicalexam.Text+"',"+
"    '"+Util.GetDateTime(txtAbdominalDateofExamination.Text.Trim()).ToString("yyyy-MM-dd")+" ',    '"+Util.GetDateTime(((TextBox)AbdominalTimeofExamination.FindControl("txtTime")).Text).ToString("HH:mm:ss")+"',    '"+txtStaffPerforming.Text+"',    '"+txtReasonfordoingexam.Text+"',    '"+txtexternalGenitalia.Text+"',"+
"    '"+rdbAnyDischarge.SelectedItem.Text+"',    '"+txtCervixDilation.Text+"',    '"+txtEffacement.Text+"',    '"+txtApplictoprespart.Text+"',    '"+rdbMembranesIntact.SelectedItem.Text+"',    '"+rdbCordFelt.SelectedItem.Text+"',    '"+txtPresentation.Text+"',"+
"    '"+txtPresentingPart.Text+"',    '"+txtStation.Text+"',    '"+txtMoulding.Text+"',    '"+txtCaput.Text+"',    '"+txtPevlisPublicArch.Text+"',    '"+txtIschialspines.Text+"',    '"+txtSacralPromontory.Text+"',    '"+txtCurveofSacrum.Text+"',"+
"    '"+txtIschialTuberosities.Text+"',    '"+rdbPelvisAdequate.SelectedItem.Text+"',    '"+txtAttentionCriticalExamFeatures.Text+"',    '"+txtAttentionLabsBloodType.Text+"',    '"+txtRh.Text+"',    '"+txtHgb.Text+"',    '"+ Util.GetDateTime(Date1.Text.Trim()).ToString("yyyy-MM-dd")+"',"+
"    '"+txtISS.Text+"',    '"+Util.GetDateTime(Date2.Text.Trim()).ToString("yyyy-MM-dd")+"',    '"+txtVDRL.Text+"',    '"+Util.GetDateTime(Date3.Text.Trim()).ToString("yyyy-MM-dd")+"',    '"+txtNameDateStamp.Text+"',    '"+rdbAbdominalscar.SelectedItem.Text+"',    '"+txtAbdominalscarWhy.Text+"',    '"+txtFHTperminute.Text+"',    '"+txtContractionsstrength.Text+"',"+
 "   '" + txtFrequency.Text + "',    '" + txtduration.Text + "',    '" + txtfundalHeight.Text + "',    '" + txtLie.Text + "',    '" + txtAbdominalPresentation.Text + "',    '" + txtPosition.Text + "',    '" + txtDescent.Text + "',    '" + rdbEngaged.SelectedItem.Text + "',    '" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',    '" +
 Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("H:mm:ss") + "' ,    '" + HttpContext.Current.Session["ID"].ToString() + "',    '" +
 Util.GetDateTime(txtVaginalDateOfExamination.Text.Trim()).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(((TextBox)txtVaginalTimeOfExamination.FindControl("txtTime")).Text).ToString("H:mm:ss") + "','" +
 txtStaffPerformingVaginal.Text + "' ,'" + ViewState["PID"] + "');");

 
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

           
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public void BindDetails()
    {
        try
        {
           // caldate.EndDate = DateTime.Now;
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT *,DATE_FORMAT(Date,'%d-%b-%Y') AS Date4" +
                ",DATE_FORMAT(Historyoflabourbeganondate,'%d-%b-%Y') AS Historyoflabourbeganondate1" +
                ",DATE_FORMAT(ROMdates,'%d-%b-%Y') AS ROMdates1" +
                ",DATE_FORMAT(AbdominalDateofExamination,'%d-%b-%Y') AS AbdominalDateofExamination1" +
                ",DATE_FORMAT(Date1,'%d-%b-%Y') AS Date11" +
                ",DATE_FORMAT(Date2,'%d-%b-%Y') AS Date21" +
                ",DATE_FORMAT(Date3,'%d-%b-%Y') AS Date31" +
                ",DATE_FORMAT(DateVaginalExam,'%d-%b-%Y') AS DateVaginalExam1" +
            ",DATE_FORMAT(Time,'%h:%m') AS Time1" +
            ",DATE_FORMAT(Attime,'%h:%m') AS Attime1" +
            ",DATE_FORMAT(ROMTime,'%h:%m') AS ROMTime1" +
            ",DATE_FORMAT(TimeVaginalExam,'%h:%m') AS TimeVaginalExam1" +
            ",DATE_FORMAT(AbdominalTimeofExamination,'%h:%m') AS AbdominalTimeofExamination1" +
            ",(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=EntryBy LIMIT 0, 1) AS EntryBy1 FROM obstetricadmissionnotes CVE where CVE.PatientId='"+ViewState["PID"]+"'");
            //sb.Append("   INNER JOIN patient_master pm ON pm.PatientID=cv.PatientID");
            //sb.Append("   INNER JOIN employee_master em ON em.EmployeeID=cv.EntryBy");
            //sb.Append("    WHERE cv.TransactionID='" + ViewState["TID"] + "' ORDER BY cv.EntryDate DESC;");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                ViewState["dt"] = dt;
                grdPhysical.DataSource = dt;
                grdPhysical.DataBind();
            }
            else
            {
                grdPhysical.DataSource = null;
                grdPhysical.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }


}