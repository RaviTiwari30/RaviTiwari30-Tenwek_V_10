using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OT_Ot_Anes_Procedure : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();
            ViewState["PID"] = Request.QueryString["PID"].ToString();
             BindPreviousDetails();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            StringBuilder sbupdate = new StringBuilder();
            sbupdate.Append("update cocoa_anes_procedure set isActive=0,UpdateBy='" + Util.GetString(Session["ID"].ToString()) + "',UpdateDate=NOW() where Transaction_Id='" + ViewState["TID"] + "' and Patient_ID='" + ViewState["PID"] + "' ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbupdate.ToString());



            StringBuilder sb = new StringBuilder();
            sb.Append(" Insert Into cocoa_anes_procedure(Patient_ID,Transaction_Id, ");
            sb.Append(" `Sedation`,`SSpinal`,`LA`,`TIVA`,`Positionforoperation`, ");
            sb.Append(" `GA`,`Caudal`,`Epidural`,`ETTube`,`Oral`,`ISize`,`Cuff`,`Nasal`,`ThroatPack`,`Easy`, `Difficult`,");
            sb.Append("  `Grade1`,`Grade2`,`Grade3`,`Grade4`,`SV`,`IPPV`,`VT`,`RR`,`Circuit`,");

            sb.Append(" `RPosition`,`RNeedleguage`,`RInterspace`,`RType`,`RLevelofSensoryblock`, ");
            sb.Append(" `EPosition`,`EInterspace`,`ENeedlegauge`,`ELOR`,`ELengthofcatheter`,`ELevelofsensoryBlock`,");
            sb.Append(" `EPlexusBlock`,`EТуре`,`ENerveBlock`,`ENervesBlocked`,`EIVRA`,`ECVP`,`EIVLine`,`ESite`,");

            sb.Append(" `EEyesProtected`,`EArtLine`,`Position`,`BSRGood`,`BSRShallow`,`BAsstIPPV`,");

            sb.Append(" `CPale`,`CPink`,`CCyanotic`,`BP`,`Pulse`,`Awake`,`Drowsy`, ");

            sb.Append(" `AnaesthesiaCommenced`,`AnaesthesiaEnded`,`BloodLoss`,`Urineoutput`,`Extubation`,`Unconscious`,LMA,LMASize,`EntryBy`,VTDetails )");
            sb.Append("VALUES('" + ViewState["PID"] + "','" + ViewState["TID"] + "',");

            sb.Append(" " + chkSedation.Checked + "," + chkSpinal.Checked + "," + chkLA.Checked + "," + chkTIVA.Checked + ",'" + txtPositionforoperation.Text + "', ");
           
            sb.Append(" " + chkGA.Checked + "," + chkCaudal.Checked + "," + chkEpidural.Checked + "," + chkEtTube.Checked + ", ");
            sb.Append(" " + chkOral.Checked + ",'" + txtSize.Text + "'," + chkCuff.Checked + "," + chkNasal.Checked + ", ");
            sb.Append(" " + chkThroatPack.Checked + "," + chkEasy.Checked + "," + chkDifficult.Checked + "," + chkGrade1.Checked + ", ");

            sb.Append(" " + chkGrade2.Checked + "," + chkGrade3.Checked + "," + chkGrade4.Checked + "," + chkSV.Checked + ", ");
            sb.Append(" " + chkIPPV.Checked + "," + chkVT.Checked + ",'" + txtRR.Text + "','" + txtCircuit.Text + "', ");
            sb.Append(" '" + txtRPosition.Text + "','" + txtRNeedleguage.Text + "','" + txtRInterspace.Text + "','" + txtRType.Text + "','" + txtRLevelofSensoryblock.Text + "', ");

            sb.Append(" '" + txtEPosition.Text + "','" + txtEInterspace.Text + "','" + txtENeedleguage.Text + "','" + txtELOR.Text + "','" + txtELengthofcatheter.Text + "','" + txtELevelofsensoryBlock.Text + "',  ");


            sb.Append(" " + chkPlexusBlock.Checked + ",'" + txtEType.Text + "',"+chkNerveBlock.Checked+",'" + txtNervesBlocked.Text + "'," + chkIVRA.Checked + ", ");

            sb.Append(" " + chkCVP.Checked+ "," + chkEIvLine.Checked + ",'" + txtSite.Text + "',  ");

            sb.Append(" " + chkEEyeProtected.Checked + "," + chkEArtLine.Checked + ",'" + txtPosition.Text + "'," + chkBSRGood.Checked + ", " + chkBSRShallow.Checked + "," + chkBAsstIPPV.Checked + ", ");

            sb.Append(" " + chkCPale.Checked + "," + chkCPink.Checked + "," + chkCCyanotic.Checked + ",'" + txtBP.Text + "', ");
            sb.Append(" '" + txtPulse.Text + "'," + chkAwake.Checked + "," + chkDrowsy.Checked + ",  ");

            sb.Append(" '" + txtAnaesthesiaCommenced.Text + "','" + txtAnaesthesiaEnded.Text + "','" + txtBloodLoss.Text + "',  ");
            sb.Append(" '" + txtUrineoutput.Text + "'," + chkExtubation.Checked + "," + chkUnconscious.Checked + ", ");




            sb.Append(" '" + txtLma.Text + "','" + txtlmaSize.Text + "' ,'" + Util.GetString(Session["ID"].ToString()) + "', '" + txtVT.Text + "' )");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();

            lblMsg.Text = "Record Saved Successfully";
            clear();
            BindPreviousDetails();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }

    private void BindPreviousDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  ");
        sb.Append(" Patient_ID,Transaction_Id, `Sedation`,`SSpinal`,`LA`,`TIVA`,`Positionforoperation`, ");
        sb.Append(" `GA`,`Caudal`,`Epidural`,`ETTube`,`Oral`,`ISize`,`Cuff`,`Nasal`,`ThroatPack`,`Easy`, `Difficult`, ");
        sb.Append("  `Grade1`,`Grade2`,`Grade3`,`Grade4`,`SV`,`IPPV`,`VT`,`RR`,`Circuit`, ");

        sb.Append(" `RPosition`,`RNeedleguage`,`RInterspace`,`RType`,`RLevelofSensoryblock`, ");
        sb.Append(" `EPosition`,`EInterspace`,`ENeedlegauge`,`ELOR`,`ELengthofcatheter`,`ELevelofsensoryBlock`, ");
        sb.Append(" `EPlexusBlock`,`EТуре`,`ENerveBlock`,`ENervesBlocked`,`EIVRA`,`ECVP`,`EIVLine`,`ESite`, ");

        sb.Append(" `EEyesProtected`,`EArtLine`,`Position`,`BSRGood`,`BSRShallow`,`BAsstIPPV`, ");

        sb.Append(" `CPale`,`CPink`,`CCyanotic`,`BP`,`Pulse`,`Awake`,`Drowsy`,LMA,LMASize, ");

        sb.Append(" `AnaesthesiaCommenced`,`AnaesthesiaEnded`,`BloodLoss`,`Urineoutput`,`Extubation`,`Unconscious`,VTDetails,`EntryBy` ");
        sb.Append(" FROM cocoa_anes_procedure cap ");

        sb.Append(" WHERE  cap.IsActive=1 AND cap.Patient_Id='" + ViewState["PID"] + "' AND cap.Transaction_Id='" + ViewState["TID"] + "' ");
  
       DataTable dt = StockReports.GetDataTable(sb.ToString());

       if (dt.Rows.Count > 0)
       {
           chkSedation.Checked = Util.GetBoolean(getBoolval(dt.Rows[0]["Sedation"].ToString().Trim()));
           chkSpinal.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["SSpinal"].ToString().Trim()));
           chkLA.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["La"].ToString().Trim()));
           chkTIVA.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["TIVA"].ToString().Trim()));
           
           chkGA.Checked =   Util.GetBoolean(getBoolval(dt.Rows[0]["GA"].ToString().Trim()));
           chkCaudal.Checked =   Util.GetBoolean(getBoolval(dt.Rows[0]["Caudal"].ToString().Trim()));
           chkEpidural.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Epidural"].ToString().Trim()));
           chkEtTube.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["EtTube"].ToString().Trim()));
           chkOral.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Oral"].ToString().Trim()));
        
           chkCuff.Checked =   Util.GetBoolean(getBoolval(dt.Rows[0]["cuff"].ToString().Trim()));
           chkNasal.Checked =   Util.GetBoolean(getBoolval(dt.Rows[0]["Nasal"].ToString().Trim()));
           chkThroatPack.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["ThroatPack"].ToString().Trim()));


           chkDifficult.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Difficult"].ToString().Trim()));
           chkGrade1.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Grade1"].ToString().Trim()));
           chkGrade2.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Grade2"].ToString().Trim()));


           chkGrade3.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Grade3"].ToString().Trim()));
           chkGrade4.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Grade4"].ToString().Trim()));
           chkSV.Checked =   Util.GetBoolean(getBoolval(dt.Rows[0]["SV"].ToString().Trim()));
           chkIPPV.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["IPPV"].ToString().Trim()));
           chkPlexusBlock.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["EPlexusBlock"].ToString().Trim()));

           chkIVRA.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["EIVRA"].ToString().Trim()));


           chkEIvLine.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["EIvLine"].ToString().Trim()));


           chkEEyeProtected.Checked = Util.GetBoolean(getBoolval(dt.Rows[0]["EEyesProtected"].ToString().Trim()));
           chkEArtLine.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["EArtLine"].ToString().Trim()));

           chkBSRGood.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["BSRGood"].ToString().Trim()));
           chkBSRShallow.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["BSRShallow"].ToString().Trim()));
           chkBAsstIPPV.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["BAsstIPPV"].ToString().Trim()));

           chkCPale.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["CPale"].ToString().Trim()));
           chkCPink.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["CPink"].ToString().Trim()));
           chkCCyanotic.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["CCyanotic"].ToString().Trim()));

           chkAwake.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Awake"].ToString().Trim()));
           chkDrowsy.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Drowsy"].ToString().Trim()));

           chkExtubation.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Extubation"].ToString().Trim()));
           chkUnconscious.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["Unconscious"].ToString().Trim()));
           chkCVP.Checked =  Util.GetBoolean(getBoolval(dt.Rows[0]["ECVP"].ToString().Trim()));

           chkEasy.Checked =   Util.GetBoolean(getBoolval(dt.Rows[0]["Easy"].ToString().Trim()));
           chkVT.Checked = Util.GetBoolean(getBoolval(dt.Rows[0]["VT"].ToString().Trim()));

           txtPositionforoperation.Text = dt.Rows[0]["Positionforoperation"].ToString().Trim();



           txtSize.Text = dt.Rows[0]["ISize"].ToString().Trim();
         
           txtRR.Text = dt.Rows[0]["RR"].ToString().Trim();
           txtCircuit.Text = dt.Rows[0]["Circuit"].ToString().Trim();
           txtRPosition.Text = dt.Rows[0]["RPosition"].ToString().Trim();
           txtRNeedleguage.Text = dt.Rows[0]["RNeedleguage"].ToString().Trim();
           txtRInterspace.Text = dt.Rows[0]["RInterspace"].ToString().Trim();

           txtRType.Text = dt.Rows[0]["RType"].ToString().Trim();
           txtRLevelofSensoryblock.Text = dt.Rows[0]["RLevelofSensoryblock"].ToString().Trim();

           txtEPosition.Text = dt.Rows[0]["EPosition"].ToString().Trim();
           txtEInterspace.Text = dt.Rows[0]["EInterspace"].ToString().Trim();
           txtENeedleguage.Text = dt.Rows[0]["ENeedlegauge"].ToString().Trim();
           txtELOR.Text = dt.Rows[0]["ELOR"].ToString().Trim();
           txtELengthofcatheter.Text = dt.Rows[0]["ELengthofcatheter"].ToString().Trim();
           txtELevelofsensoryBlock.Text = dt.Rows[0]["ELevelofsensoryBlock"].ToString().Trim();
           txtEType.Text = dt.Rows[0]["EТуре"].ToString().Trim();
           txtNervesBlocked.Text = dt.Rows[0]["ENervesBlocked"].ToString().Trim();
           txtSite.Text = dt.Rows[0]["ESite"].ToString().Trim();

           txtPosition.Text = dt.Rows[0]["Position"].ToString().Trim();
           txtBP.Text = dt.Rows[0]["BP"].ToString().Trim();
           txtPulse.Text = dt.Rows[0]["Pulse"].ToString().Trim();
           txtAnaesthesiaCommenced.Text = dt.Rows[0]["AnaesthesiaCommenced"].ToString().Trim();
           txtAnaesthesiaEnded.Text = dt.Rows[0]["AnaesthesiaEnded"].ToString().Trim();
           txtBloodLoss.Text = dt.Rows[0]["BloodLoss"].ToString().Trim();
           txtUrineoutput.Text = dt.Rows[0]["Urineoutput"].ToString().Trim();
           txtLma.Text = dt.Rows[0]["Lma"].ToString().Trim();
           txtlmaSize.Text = dt.Rows[0]["lmaSize"].ToString().Trim();
           txtVT.Text = dt.Rows[0]["VTDetails"].ToString().Trim();
         btnSave.Text = "Update";
       }
       else
       {
           btnSave.Text = "Save";
       }
    }


    private void clear()
    {
        chkSedation.Checked = false;
        chkSpinal.Checked = false;
        chkLA.Checked = false;
        chkTIVA.Checked = false;
        txtPositionforoperation.Text = "";
        chkGA.Checked = false;
        chkCaudal.Checked = false;
        chkEpidural.Checked = false;
        chkEtTube.Checked = false;
        chkOral.Checked = false;
        txtSize.Text = "";
        chkCuff.Checked = false;
        chkNasal.Checked = false;
        chkThroatPack.Checked = false;
        chkEasy.Text = "";
        chkDifficult.Checked = false;
        chkGrade1.Checked = false;
        chkGrade2.Checked = false;
        chkGrade3.Checked = false;
        chkGrade4.Checked = false;
        chkSV.Checked = false;
        chkIPPV.Checked = false;
        chkVT.Text = "";
        txtRR.Text = "";
        txtCircuit.Text = "";
        txtRPosition.Text = "";
        txtRNeedleguage.Text = "";
        txtRInterspace.Text = "";

        txtRType.Text = "";
        txtRLevelofSensoryblock.Text = "";

        txtEPosition.Text = "";
        txtEInterspace.Text = "";
        txtENeedleguage.Text = "";
        txtELOR.Text = "";
        txtELengthofcatheter.Text = "";
        txtELevelofsensoryBlock.Text = "";


        chkPlexusBlock.Checked = false;
        txtEType.Text = "";
        txtNervesBlocked.Text = "";
        chkIVRA.Checked = false;

        chkCVP.Checked = false;
        chkEIvLine.Checked = false;
        txtSite.Text = "";

        chkEEyeProtected.Checked = false;
        chkEArtLine.Checked = false;
        txtPosition.Text = "";
        chkBSRGood.Checked = false;
        chkBSRShallow.Checked = false;
        chkBAsstIPPV.Checked = false;

        chkCPale.Checked = false;
        chkCPink.Checked = false;
        chkCCyanotic.Checked = false;
        txtBP.Text = "";
        txtPulse.Text = "";
        chkAwake.Checked = false;
        chkDrowsy.Checked = false;

        txtAnaesthesiaCommenced.Text = "";
        txtAnaesthesiaEnded.Text = "";
        txtBloodLoss.Text = "";
        txtUrineoutput.Text = "";
        chkExtubation.Checked = false;
        chkUnconscious.Checked = false;
        txtVT.Text = "";
    }


    public string getBoolval(string boolean)
    {  
        string st="False";
        if (!string.IsNullOrEmpty(boolean) && boolean == "True")
        {
            st="True";
            return st;
        }
        else
        {
            return st;
        }
    
    }
}