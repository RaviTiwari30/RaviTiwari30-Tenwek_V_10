using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_CPOE_ICUAdmission : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();
            txtAdmissiondate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtICUAdmission.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDetails();
            lblMsg.Text = "";
        }
        txtAdmissiondate.Attributes.Add("readOnly", "true");
        txtICUAdmission.Attributes.Add("readOnly", "true");
       
    }
    public void BindDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select * from cpoe_icu_admission where TransactionID='" + ViewState["TID"].ToString() + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            txtAdmissiondate.Text = Util.GetDateTime(dt.Rows[0]["Hosp_Add_Date"]).ToString("dd-MMM-yyyy");
            txtICUAdmission.Text = Util.GetDateTime(dt.Rows[0]["Icu_Add_Date"]).ToString("dd-MMM-yyyy");
            rdoAdmission.SelectedIndex = rdoAdmission.Items.IndexOf(rdoAdmission.Items.FindByText(dt.Rows[0]["Addmission_Form"].ToString()));
            txtAdmission.Text = dt.Rows[0]["Addmission_text"].ToString();
            ddlCriteria.SelectedIndex = ddlCriteria.Items.IndexOf(ddlCriteria.Items.FindByText(dt.Rows[0]["Criteria"].ToString()));
            lblSystolic.Text = dt.Rows[0]["Systotic"].ToString();
            lblHR.Text = dt.Rows[0]["HR"].ToString();
            lblTemp.Text = dt.Rows[0]["Temp"].ToString();
            lblRR.Text = dt.Rows[0]["RR"].ToString();
            lblSPO.Text = dt.Rows[0]["SPO"].ToString();
            lblUrine.Text = dt.Rows[0]["Urine"].ToString();
            lblLevel.Text = dt.Rows[0]["Level"].ToString();
            lblChest.Text = dt.Rows[0]["Chest"].ToString();
            lblPanic.Text = dt.Rows[0]["Panic"].ToString();
            lblECG.Text = dt.Rows[0]["ECG"].ToString();
            if (dt.Rows[0]["Systotic"].ToString() == "<70")
            {
                rdbSystolic3.Checked = true;
            }
            else if (dt.Rows[0]["Systotic"].ToString() == "70-80")
            {
                rdbSystolic2.Checked = true;
            }
            else if (dt.Rows[0]["Systotic"].ToString() == "80-100")
            {
                rdbSystolic1.Checked = true;
            }
            else if (dt.Rows[0]["Systotic"].ToString() == "100-160")
            {
                rdbSystolic0.Checked=true;
            }
            else if (dt.Rows[0]["Systotic"].ToString() == "161-199")
            {
                rdbSystolic11.Checked = true;
            }
            else if (dt.Rows[0]["Systotic"].ToString() == ">200")
            {
                rdbSystolic22.Checked = true;
            }
            if (dt.Rows[0]["HR"].ToString() == "<40")
            {
                RdbHR2.Checked = true;
            }
            else if (dt.Rows[0]["HR"].ToString() == "40-50")
            {
                RdbHR1.Checked = true;
            }
            else if (dt.Rows[0]["HR"].ToString() == "50-100")
            {
                RdbHR0.Checked = true;
            }
            else if (dt.Rows[0]["HR"].ToString() == "100-110")
            {
                RdbHR11.Checked = true;
            }
            else if (dt.Rows[0]["HR"].ToString() == "110-130")
            {
                RdbHR22.Checked = true;
            }
            else if (dt.Rows[0]["HR"].ToString() == ">130")
            {
                RdbHR33.Checked = true;
            }
            if (dt.Rows[0]["Temp"].ToString() == "<35")
            {
                RdbTemp2.Checked = true;
            }
            else if (dt.Rows[0]["Temp"].ToString() == "35.1-36")
            {
                RdbTemp1.Checked = true;
            }
            else if (dt.Rows[0]["Temp"].ToString() == "36.1-38")
            {
                RdbTemp0.Checked = true;
            }
            else if (dt.Rows[0]["Temp"].ToString() == "38.1-38.5")
            {
                RdbTemp11.Checked = true;
            }
            else if (dt.Rows[0]["Temp"].ToString() == "38.6-40")
            {
                RdbTemp22.Checked = true;
            }
            else if (dt.Rows[0]["Temp"].ToString() == ">40")
            {
                RdbTemp33.Checked = true;
            }
            if (dt.Rows[0]["RR"].ToString() == "<9")
            {
                RdbRR2.Checked = true;
            }
            else if (dt.Rows[0]["RR"] == "9-14")
            {
                RdbRR0.Checked = true;
            }
            else if (dt.Rows[0]["RR"].ToString() == "15-20")
            {
                RdbRR11.Checked = true;
            }
            else if (dt.Rows[0]["RR"].ToString() == "21-29")
            {
                RdbRR22.Checked = true;
            }
            else if (dt.Rows[0]["RR"].ToString() == ">30")
            {
                RdbRR33.Checked = true;
            }
            if (dt.Rows[0]["SPO"].ToString() == "<90%")
            {
                RdbSPO3.Checked =true;
            }
            else if (dt.Rows[0]["SPO"].ToString() == "91-93%")
            {
                RdbSPO2.Checked = true;
            }
            else if (dt.Rows[0]["SPO"].ToString() == "94-100%")
            {
                RdbSPO0.Checked = true;
            }
            if (dt.Rows[0]["Urine"].ToString() == "None or <10 ml/2hrs")
            {
                RdbUrine3.Checked = true;
            }
            else if (dt.Rows[0]["Urine"].ToString() == "<30 ml/2hrs")
            {
                RdbUrine2.Checked = true;
            }
            else if (dt.Rows[0]["Urine"].ToString() == "<50 ml/2hrs")
            {
                RdbUrine1.Checked = true;
            }
            else if (dt.Rows[0]["Urine"].ToString() == ">50 ml/2hrs")
            {
                RdbUrine0.Checked = true;
            }
            if (dt.Rows[0]["Level"].ToString() == "Unresponsive")
            {
                RdbLevel3.Checked = true;
            }
            else if (dt.Rows[0]["Level"].ToString() == "Unresponsive")
            {
                RdbLevel2.Checked = true;
            }
            else if (dt.Rows[0]["Level"].ToString() == "Drowsy/ responds voice")
            {
                RdbLevel1.Checked = true;
            }
            else if (dt.Rows[0]["Level"].ToString() == "Alert")
            {
                RdbLevel0.Checked = true;
            }
            else if (dt.Rows[0]["Level"].ToString() == "New Agitation/Confusion")
            {
                RdbLevel11.Checked = true;
            }
            if (dt.Rows[0]["Chest"].ToString() == "3 Points")
            {
                RdbChest3.Checked = true;
            }
            else if (dt.Rows[0]["Chest"].ToString() == "Specify")
            {
                RdbChest2.Checked = true;
            }
            if (dt.Rows[0]["Panic"].ToString() == "3 Points")
            {
                RdbPanic3.Checked = true;
            }
            else if (dt.Rows[0]["Panic"].ToString() == "Specify")
            {
                RdbPanic2.Checked = true;
            }
            if (dt.Rows[0]["ECG"].ToString() == "3 Points")
            {
                RdbECG3.Checked = true;
            }
            else if (dt.Rows[0]["ECG"].ToString() == "Specify")
            {
                RdbECG2.Checked = true;
            }
            txtECG.Text = dt.Rows[0]["ECGText"].ToString();
            txtChest.Text = dt.Rows[0]["ChestText"].ToString();
            TxtPanic.Text = dt.Rows[0]["PanicText"].ToString();
            txtTotalScore.Text = dt.Rows[0]["Total_Score"].ToString();
            lblTotal.Text = dt.Rows[0]["Total_Score"].ToString();
            txtAdd.Text = dt.Rows[0]["Additional_Info"].ToString();
        }

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string sql="";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            string date = txtAdmissiondate.Text;
            string sql1 = "select Count(*) from cpoe_Icu_Admission where TransactionID ='" + ViewState["TID"].ToString() + "' ";
            int ID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql1));
            if (ID == 1)
            { 
            sql="delete from cpoe_Icu_Admission where TransactionID='"+ViewState["TID"].ToString()+"'";
                   MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
           sql  = "insert into cpoe_Icu_Admission (TransactionID,Hosp_Add_Date,Icu_Add_Date,Addmission_Form,Addmission_text,Criteria,Systotic,HR,Temp,RR,SPO,Urine,Level,Chest,Panic,ECG,ChestText,PanicText,ECGText,Total_Score,Additional_Info,EntryBy)  values('" + ViewState["TID"].ToString() + "' , '" + Util.GetDateTime(txtAdmissiondate.Text).ToString("yyyy-MM-dd") + "' , '" + Util.GetDateTime(txtICUAdmission.Text).ToString("yyyy-MM-dd") + "','" + rdoAdmission.SelectedItem.Text + "','" + txtAdmission.Text + "','" + ddlCriteria.SelectedItem.Text + "','" + lblSystolic.Text.ToString() + "','" + lblHR.Text + "','" + lblTemp.Text + "','" + lblRR.Text + "','" + lblSPO.Text + "','" + lblUrine.Text + "','" + lblLevel.Text + "','" + lblChest.Text + "','" + lblPanic.Text + "','" + lblECG.Text + "','" + txtChest.Text + "','" + TxtPanic.Text + "','" + txtECG.Text + "','" + txtTotalScore.Text + "','" + txtAdd.Text + "','" + ViewState["ID"].ToString() + "')";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);


                lblMsg.Text = "Record Saved Successfully";
                BindDetails();
            tnx.Commit();
            con.Close();
        }
        catch (Exception Ex)
        {
            tnx.Rollback();
            con.Close();
        }

    }
}