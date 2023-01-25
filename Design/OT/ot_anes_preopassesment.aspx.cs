using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OT_ot_anes_preopassesment : System.Web.UI.Page
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

            string dt = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");

            StringBuilder sbupdate = new StringBuilder();
            sbupdate.Append("update cocoa_anes_preopassesment set isActive=0,UpdateBy='" + Util.GetString(Session["ID"].ToString()) + "',UpdateDate=NOW() where Transaction_Id='" + ViewState["TID"] + "' and Patient_ID='" + ViewState["PID"] + "' ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbupdate.ToString());



            StringBuilder sb = new StringBuilder();
            sb.Append(" Insert Into cocoa_anes_preopassesment(Patient_ID,Transaction_Id,Previousanaesthetics, ");
            sb.Append(" CoMorbidity,DrugHx,Hb,Sickling,Platelets,WBC,ESR,APTT,INR,NA,K,Ca,Urea,Alcohol,Smoking, ");
            sb.Append("Creatinine,LFT,Palor,Jaundice,Temp,FBS,HormonalAssays,Oedema,Hydration,GenOthers,Hepatitis, ");

            sb.Append(" HIV,Pulse,Urine,BP,MPS,HS,ECG,RR,SPO2,Auscultation,CXR,CNS,Abdomen,OthersSystems,Urinalysis,");
            sb.Append("NeckMobility,MouthOpening,ThyromentalDistance, Mallampati01,Mallampati02,Mallampati03,Mallampati04,");
            sb.Append("ASAST01,ASAST02,ASAST03,ASAST04,ASAST05,ASAST06,Date,Time,Others,Notes,EntryBy)");
            sb.Append("VALUES('" + ViewState["PID"] + "','" + ViewState["TID"] + "','" + txtPreviousAnaesthetics.Text + "', ");

            sb.Append(" '" + txtCoMorbidity.Text + "','" + txtDrugHx.Text + "','" + txtHB.Text + "','" + txtSickling.Text + "',");
            sb.Append(" '" + txtPlatelets.Text + "','" + txtWBC.Text + "','" + txtESR.Text + "','" + txtAPTT.Text + "',");
            sb.Append(" '" + txtINR.Text + "','" + txtNa.Text + "','" + txtK.Text + "','" + txtCa.Text + "','" + txtUrea.Text + "'," + rblAlcohol.SelectedValue + "," + rblSmoking.SelectedValue + ",");
            sb.Append(" '" + txtCreatinine.Text + "','" + txtLFT.Text + "'," + rblPalor.SelectedValue + "," + rblJaundice.SelectedValue + ",'" + txtTemp.Text + "',");
            sb.Append(" '" + txtFBS.Text + "','" + txtHormonalAssays.Text + "','" + txtOedema.Text + "','" + txtHydration.Text + "','" + txtGenOthers.Text + "','" + txtHepatitis.Text + "',");
            sb.Append(" '" + txtHIV.Text + "','" + txtPulse.Text + "','" + txtUrine.Text + "','" + txtBP.Text + "','" + txtMPS.Text + "','" + txtHS.Text + "','" + txtECG.Text + "',");
            sb.Append(" '" + txtRR.Text + "','" + txtSpo2.Text + "','" + txtAuscultation.Text + "','" + txtCXR.Text + "','" + txtCns.Text + "','" + txtAbdomen.Text + "',");
            sb.Append(" '" + txtOtherssystems.Text + "','" + txtUrinalysis.Text + "',");
            sb.Append(" '" + txtNeckMobility.Text + "','" + txtMouthOpening.Text + "','" + txtThyromentaldistance.Text + "', ");
            sb.Append(" " + chkMallampati1.Checked + "," + chkMallampati2.Checked + "," + chkMallampati3.Checked + "," + chkMallampati4.Checked + ", ");
            sb.Append(" " + chkASA1.Checked + "," + chkASA2.Checked + "," + chkASA3.Checked + "," + chkASA4.Checked + "," + chkASA5.Checked + "," + chkASA6.Checked + ", ");
            sb.Append(" '" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "','" + txtOthers.Text + "', ");
            sb.Append(" '" + txtNotes.Text + "','" + Util.GetString(Session["ID"].ToString()) + "')");


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


    public void clear()
    {
        txtPreviousAnaesthetics.Text = "";
        txtCoMorbidity.Text = "";
        txtDrugHx.Text = "";
        txtHB.Text = "";
        txtSickling.Text = "";
        txtPlatelets.Text = "";
        txtWBC.Text = "";
        txtESR.Text = "";
        txtAPTT.Text = "";
        txtINR.Text = "";
        txtNa.Text = "";
        txtK.Text = "";
        txtCa.Text = "";
        txtUrea.Text = "";
        rblAlcohol.ClearSelection();
        rblSmoking.ClearSelection();
        txtCreatinine.Text = "";
        txtLFT.Text = "";
        rblPalor.ClearSelection();
        rblJaundice.ClearSelection();
        txtTemp.Text = "";
        txtFBS.Text = "";
        txtHormonalAssays.Text = "";
        txtOedema.Text = "";
        txtHydration.Text = "";
        txtGenOthers.Text = "";
        txtHepatitis.Text = "";
        txtHIV.Text = "";
        txtPulse.Text = "";
        txtUrine.Text = "";
        txtBP.Text = "";
        txtMPS.Text = "";
        txtHS.Text = "";
        txtECG.Text = "";
        txtRR.Text = "";
        txtSpo2.Text = "";
        txtAuscultation.Text = "";
        txtCXR.Text = "";
        txtCns.Text = "";
        txtAbdomen.Text = "";
        txtOtherssystems.Text = "";
        txtUrinalysis.Text = "";
        txtNeckMobility.Text = "";
        txtMouthOpening.Text = "";
        txtThyromentaldistance.Text = "";
        chkMallampati1.Checked = false;
        chkMallampati2.Checked = false;
        chkMallampati3.Checked = false;
        chkMallampati4.Checked = false;
        chkASA1.Checked = false;
        chkASA2.Checked = false;
        chkASA3.Checked = false;
        chkASA4.Checked = false;
        chkASA5.Checked = false;
        chkASA6.Checked = false;
        txtDate.Text = "";
        txtTime.Text = "";
        txtOthers.Text = "";
        txtNotes.Text = "";

    }


    public void BindPreviousDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  ");

        sb.Append(" Patient_ID,Transaction_Id,Previousanaesthetics, CoMorbidity,DrugHx,Hb,Sickling,Platelets,WBC,ESR,APTT,INR,NA,K,Ca,Urea,Alcohol,Smoking, ");
        sb.Append(" Creatinine,LFT,Palor,Jaundice,Temp,FBS,HormonalAssays,Oedema,Hydration,GenOthers,Hepatitis, ");

        sb.Append(" HIV,Pulse,Urine,BP,MPS,HS,ECG,RR,SPO2,Auscultation,CXR,CNS,Abdomen,OthersSystems,Urinalysis, ");
        sb.Append(" NeckMobility,MouthOpening,ThyromentalDistance,IF(IFNULL(Mallampati01,0)=0,'false','true')Mallampati01,IF(IFNULL(Mallampati02,0)=0,'false','true')Mallampati02,IF(IFNULL(Mallampati03,0)=0,'false','true')Mallampati03,IF(IFNULL(Mallampati03,0)=0,'false','true')Mallampati04, ");
        sb.Append(" if(ifnull(ASAST01,0)=0,'false','true')ASAST01, if(ifnull(ASAST02,0)=0,'false','true')ASAST02, if(ifnull(ASAST03,0)=0,'false','true')ASAST03, if(ifnull(ASAST04,0)=0,'false','true')ASAST04, if(ifnull(ASAST05,0)=0,'false','true')ASAST05, if(ifnull(ASAST06,0)=0,'false','true')ASAST06,DATE_FORMAT(Date,'%d-%b-%Y')DateAns,Time,Others,Notes ");

        sb.Append(" FROM cocoa_anes_preopassesment cap ");

        sb.Append(" WHERE  cap.IsActive=1 AND cap.Patient_Id='" + ViewState["PID"] + "' AND cap.Transaction_Id='" + ViewState["TID"] + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            txtPreviousAnaesthetics.Text = dt.Rows[0]["Previousanaesthetics"].ToString();
            txtCoMorbidity.Text = dt.Rows[0]["CoMorbidity"].ToString();
            txtDrugHx.Text = dt.Rows[0]["DrugHx"].ToString();
            txtHB.Text = dt.Rows[0]["Hb"].ToString();
            txtSickling.Text = dt.Rows[0]["Sickling"].ToString();
            txtPlatelets.Text = dt.Rows[0]["Platelets"].ToString();
            txtWBC.Text = dt.Rows[0]["WBC"].ToString();
            txtESR.Text = dt.Rows[0]["ESR"].ToString();
            txtAPTT.Text = dt.Rows[0]["APTT"].ToString();
            txtINR.Text = dt.Rows[0]["INR"].ToString();
            txtNa.Text = dt.Rows[0]["NA"].ToString();
            txtK.Text = dt.Rows[0]["K"].ToString();
            txtCa.Text = dt.Rows[0]["Ca"].ToString();
            txtUrea.Text = dt.Rows[0]["Urea"].ToString();
            rblAlcohol.SelectedValue = dt.Rows[0]["Alcohol"].ToString();
            rblSmoking.SelectedValue = dt.Rows[0]["Smoking"].ToString();
            txtCreatinine.Text = dt.Rows[0]["Creatinine"].ToString();
            txtLFT.Text = dt.Rows[0]["LFT"].ToString();
            rblPalor.SelectedValue = dt.Rows[0]["Palor"].ToString();
            rblJaundice.SelectedValue = dt.Rows[0]["Jaundice"].ToString();
            txtTemp.Text = dt.Rows[0]["Temp"].ToString();
            txtFBS.Text = dt.Rows[0]["FBS"].ToString();
            txtHormonalAssays.Text = dt.Rows[0]["HormonalAssays"].ToString();
            txtOedema.Text = dt.Rows[0]["Oedema"].ToString();
            txtHydration.Text = dt.Rows[0]["Hydration"].ToString();
            txtGenOthers.Text = dt.Rows[0]["GenOthers"].ToString();
            txtHepatitis.Text = dt.Rows[0]["Hepatitis"].ToString();
            txtHIV.Text = dt.Rows[0]["HIV"].ToString();
            txtPulse.Text = dt.Rows[0]["Pulse"].ToString();
            txtUrine.Text = dt.Rows[0]["Urine"].ToString();
            txtBP.Text = dt.Rows[0]["Bp"].ToString();
            txtMPS.Text = dt.Rows[0]["MPS"].ToString();
            txtHS.Text = dt.Rows[0]["HS"].ToString();
            txtECG.Text = dt.Rows[0]["ECG"].ToString();
            txtRR.Text = dt.Rows[0]["RR"].ToString();
            txtSpo2.Text = dt.Rows[0]["SPO2"].ToString();
            txtAuscultation.Text = dt.Rows[0]["Auscultation"].ToString();
            txtCXR.Text = dt.Rows[0]["CXR"].ToString();
            txtCns.Text = dt.Rows[0]["Cns"].ToString();
            txtAbdomen.Text = dt.Rows[0]["Abdomen"].ToString();
            txtOtherssystems.Text = dt.Rows[0]["Otherssystems"].ToString();
            txtUrinalysis.Text = dt.Rows[0]["Urinalysis"].ToString();
            txtNeckMobility.Text = dt.Rows[0]["NeckMobility"].ToString();
            txtMouthOpening.Text = dt.Rows[0]["MouthOpening"].ToString();
            txtThyromentaldistance.Text = dt.Rows[0]["Thyromentaldistance"].ToString();
            chkMallampati1.Checked = Util.GetBoolean(dt.Rows[0]["Mallampati01"].ToString());
            chkMallampati2.Checked = Util.GetBoolean(dt.Rows[0]["Mallampati02"].ToString());
            chkMallampati3.Checked = Util.GetBoolean(dt.Rows[0]["Mallampati03"].ToString());
            chkMallampati4.Checked = Util.GetBoolean(dt.Rows[0]["Mallampati04"].ToString());
            chkASA1.Checked = Util.GetBoolean(dt.Rows[0]["ASAST01"].ToString());
            chkASA2.Checked = Util.GetBoolean(dt.Rows[0]["ASAST02"].ToString());
            chkASA3.Checked = Util.GetBoolean(dt.Rows[0]["ASAST03"].ToString());
            chkASA4.Checked = Util.GetBoolean(dt.Rows[0]["ASAST04"].ToString());
            chkASA5.Checked = Util.GetBoolean(dt.Rows[0]["ASAST05"].ToString());
            chkASA6.Checked = Util.GetBoolean(dt.Rows[0]["ASAST06"].ToString());
            txtDate.Text = dt.Rows[0]["DateAns"].ToString();
            txtTime.Text = Util.GetDateTime(dt.Rows[0]["Time"].ToString()).ToString("hh:mm tt");
            txtOthers.Text = dt.Rows[0]["Others"].ToString();
            txtNotes.Text = dt.Rows[0]["Notes"].ToString();

            btnSave.Text = "Update";
        }
        else
        {
            clear();
            btnSave.Text = "Save";
        }
    }



}