using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_IPD_IPD_ECGExamination : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
            ViewState["PID"] = Request.QueryString["PatientId"].ToString();

            BindGrid();
        }

        lblMsg.Text = "";        
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        string allTextBoxValues = "";
        foreach (Control c in Page.Controls)
        {
            if (c is TextBox)
            {
                allTextBoxValues += ((TextBox)c).Text + ",";
            }
            foreach (Control childc in c.Controls)
            {
                if (childc is TextBox)
                {
                    allTextBoxValues += ((TextBox)childc).Text + ",";
                    if (allTextBoxValues == ",")
                    {
                        allTextBoxValues = "";
                    }
                }
            }
        }

        if (allTextBoxValues != "")
        {
            Insert();
            BindGrid();
        }
        else
        {
            lblMsg.Text = "Please Provide At Least One Option Data";
        }
    }

    public void Insert()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            ipd_ecg_examination iecg = new ipd_ecg_examination(Tranx);
            iecg.PatientID = ViewState["PID"].ToString();
            iecg.TransactionID = ViewState["TID"].ToString();
            iecg.CardiomegalyofUCouse = txtCardiomegalyCause.Text;
            iecg.HeartfailureofUCause = txtHeartFailure.Text;
            iecg.SystolicmurmurState = txtSystolic.Text;
            iecg.DiastolicmurmurState = txtDiastolic.Text;
            iecg.RCarditisFeverHeDisease = txtRheumatic.Text;
            iecg.Fever = txtFever.Text;
            iecg.Clubblingoffing = txtClubbing.Text;
            iecg.Splenmegaly = txtSplenomegaly.Text;
            iecg.MicroHeamaturia = txtMicroHaematuria.Text;
            iecg.PoBloodCulture = txtPBlood.Text;
            iecg.RaisedEsr = txtRaisedESR.Text;
            iecg.Anaemia = txtAnaemia.Text;
            iecg.PeriEffCardTampPeri = txtPeriCardial.Text;
            iecg.HyperHeartDis = txtHypertens.Text;
            iecg.AngPectMyoCardinf = txtAngina.Text;
            iecg.CongHeartDis = txtConfenital.Text;
            iecg.OtherRes = txtOReason.Text;
            iecg.Dyspnoea = txtDyspnoea.Text;
            iecg.EasyFatig = txtEFatigability.Text;
            iecg.Palpitation = txtPalpitation.Text;
            iecg.Orthopoea = txtOrthoponoea.Text;
            iecg.NoctDypWheeCough = txtNocturnal.Text;
            iecg.FrothySputum = txtForthySputum.Text;
            iecg.Heamoptysis = txtHaemoptysis.Text;
            iecg.AnkleAbdoGenSwel = txtAnkle.Text;
            iecg.NYHeartAssFuncClass = txtNYAssosiation.Text;
            iecg.NYHeartAssFuncClass_1 = txt_1.Text;
            iecg.NYHeartAssFuncClass_2 = txt_2.Text;
            iecg.NYHeartAssFuncClass_3 = txt_3.Text;
            iecg.NYHeartAssFuncClass_4 = txt_4.Text;
            iecg.lastUpdatedBy = Util.GetString(Session["ID"]);
            iecg.lastUpdateDate = System.DateTime.Now;
            iecg.Insert();

            Tranx.Commit();

            lblMsg.Text = "Record Saved Successfully";

            Clear(Page.Controls);
        }
        catch (Exception ex)
        {
            Tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            lblMsg.Text = "Error occurred, Please contact administrator";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public void BindGrid()
    {
        DataTable dt = GetData();
        if (dt.Rows.Count > 0)
        {
            grdDataView.DataSource = dt;
            grdDataView.DataBind();
        }
        else
        {
            grdDataView.DataSource = null;
            grdDataView.DataBind();
        }
    }

    public DataTable GetData()
    {
        StringBuilder query = new StringBuilder();
        query.Append("SELECT iee.ID,iee.PatientID,iee.TransactionID,iee.CardiomegalyofUCouse,iee.HeartfailureofUCause,iee.SystolicmurmurState,iee.DiastolicmurmurState,iee.RCarditisFeverHeDisease,iee.Fever,iee.");
        query.Append("Clubblingoffing,iee.Splenmegaly,iee.MicroHeamaturia,iee.PoBloodCulture,iee.RaisedEsr,iee.Anaemia,iee.PeriEffCardTampPeri,iee.HyperHeartDis,iee.AngPectMyoCardinf,iee.CongHeartDis,iee.OtherRes,iee.");
        query.Append("Dyspnoea,iee.EasyFatig,iee.Palpitation,iee.Orthopoea,iee.NoctDypWheeCough,iee.FrothySputum,iee.Heamoptysis,iee.AnkleAbdoGenSwel,iee.NYHeartAssFuncClass,iee.NYHeartAssFuncClass_1,iee.NYHeartAssFuncClass_2,iee.");
        query.Append("NYHeartAssFuncClass_3,iee.NYHeartAssFuncClass_4,CONCAT(emp.Title,' ',emp.Name) AS lastUpdatedBy,DATE_FORMAT(iee.lastUpdateDate,'%d-%b-%Y %h:%i %p') AS lastUpdateDate ");
        query.Append("FROM ipd_ecg_examination iee INNER JOIN employee_master emp ON iee.lastUpdatedBy=emp.EmployeeID WHERE iee.PatientID = '" + ViewState["PID"].ToString() + "'");

        return StockReports.GetDataTable(query.ToString());
    }

    public void Clear(ControlCollection ctrls)
    {
        foreach (Control ctrl in ctrls)
        {
            if (ctrl is TextBox)
                ((TextBox)ctrl).Text = string.Empty;
            Clear(ctrl.Controls);
        }
    }

    protected void btnUdate_Click(object sender, EventArgs e)
    {
        string allTextBoxValues = "";
        foreach (Control c in Page.Controls)
        {
            if (c is TextBox)
            {
                allTextBoxValues += ((TextBox)c).Text + ",";
            }
            foreach (Control childc in c.Controls)
            {
                if (childc is TextBox)
                {
                    allTextBoxValues += ((TextBox)childc).Text + ",";
                    if (allTextBoxValues == ",")
                    {
                        allTextBoxValues = "";
                    }

                }
            }
        }

        if (allTextBoxValues != "")
        {
            Update();
            BindGrid();
        }
        else
        {
            lblMsg.Text = "Please Provide At Least One Option Data";
        }
    }

    public void Update()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE ipd_ecg_examination SET CardiomegalyofUCouse = '" + txtCardiomegalyCause.Text + "',HeartfailureofUCause = '" + txtHeartFailure.Text + "',SystolicmurmurState = '" + txtSystolic.Text + "', ");
            sb.Append(" DiastolicmurmurState = '" + txtDiastolic.Text + "',RCarditisFeverHeDisease = '" + txtRheumatic.Text + "',Fever = '" + txtFever.Text + "',Clubblingoffing = '" + txtClubbing.Text + "',");
            sb.Append(" Splenmegaly = '" + txtSplenomegaly.Text + "',MicroHeamaturia = '" + txtMicroHaematuria.Text + "',PoBloodCulture = '" + txtPBlood.Text + "',RaisedEsr = '" + txtRaisedESR.Text + "',Anaemia = '" + txtAnaemia.Text + "',");
            sb.Append(" PeriEffCardTampPeri = '" + txtPeriCardial.Text + "',HyperHeartDis = '" + txtHypertens.Text + "',AngPectMyoCardinf = '" + txtAngina.Text + "',CongHeartDis = '" + txtConfenital.Text + "',OtherRes = '" + txtOReason.Text + "',Dyspnoea = '" + txtDyspnoea.Text + "',");
            sb.Append(" EasyFatig = '" + txtEFatigability.Text + "',Palpitation = '" + txtPalpitation.Text + "',Orthopoea = '" + txtOrthoponoea.Text + "',NoctDypWheeCough = '" + txtNocturnal.Text + "',FrothySputum = '" + txtForthySputum.Text + "',");
            sb.Append(" Heamoptysis = '" + txtHaemoptysis.Text + "',AnkleAbdoGenSwel = '" + txtAnkle.Text + "',NYHeartAssFuncClass = '" + txtNYAssosiation.Text + "',NYHeartAssFuncClass_1 = '" + txt_1.Text + "',");
            sb.Append(" NYHeartAssFuncClass_2 = '" + txt_2.Text + "',NYHeartAssFuncClass_3 = '" + txt_3.Text + "',NYHeartAssFuncClass_4 = '" + txt_4.Text + "'");
            sb.Append(" WHERE ID = '" + Util.GetInt(ViewState["ID"].ToString()) + "'");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            tranX.Commit();

            lblMsg.Text = "Record Updated Successfully";

            Clear(Page.Controls);

            btnSave.Visible = true;
            btnUdate.Visible = false;
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            lblMsg.Text = "Error occurred, Please contact administrator";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable Search(int id, string status)
    {
        StringBuilder query = new StringBuilder();
        query.Append("SELECT pm.PName,pm.Age,pm.Gender,pm.Ethnicity,pmh.Height,pmh.Weight,pm.ReligiousAffiliation,CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.City,' ',pm.State,' ',pm.Country) AS Address,");
        query.Append("ecg.PatientID,ecg.TransactionID,ecg.CardiomegalyofUCouse,ecg.HeartfailureofUCause,ecg.SystolicmurmurState,ecg.DiastolicmurmurState,");
        query.Append("ecg.RCarditisFeverHeDisease,ecg.Fever,ecg.Clubblingoffing,ecg.Splenmegaly,ecg.MicroHeamaturia,ecg.PoBloodCulture,ecg.RaisedEsr,ecg.Anaemia,");
        query.Append("ecg.PeriEffCardTampPeri,ecg.HyperHeartDis,ecg.AngPectMyoCardinf,ecg.CongHeartDis,ecg.OtherRes,ecg.Dyspnoea,ecg.EasyFatig,ecg.Palpitation,");
        query.Append("ecg.Orthopoea,ecg.NoctDypWheeCough,ecg.FrothySputum,ecg.Heamoptysis,ecg.AnkleAbdoGenSwel,ecg.NYHeartAssFuncClass,ecg.NYHeartAssFuncClass_1, ");
        query.Append("ecg.NYHeartAssFuncClass_2,ecg.NYHeartAssFuncClass_3,ecg.NYHeartAssFuncClass_4,ecg.lastUpdatedBy,ecg.lastUpdateDate,rm.Description,dm.Name,cm.CentreName,cm.Website,cm.Address,cm.MobileNo,cm.EmailID ");
        query.Append("FROM ipd_ecg_examination ecg INNER JOIN patient_master pm ON pm.PatientID = ecg.PatientID INNER JOIN patient_medical_history pmh ON pmh.TransactionID = ecg.TransactionID ");
        query.Append("INNER JOIN patient_ipd_profile pip ON pip.TransactionID = ecg.TransactionID INNER JOIN room_master rm ON rm.RoomID = pip.RoomID ");
        query.Append("INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID INNER JOIN center_master cm ON cm.CentreID = pm.CentreID ");
        query.Append("WHERE ecg.ID= (" + id + ") AND ecg.TransactionID = ('" + ViewState["TID"].ToString() + "') AND pip.Status = ('" + status + "') AND pm.CentreID = (" + Util.GetInt(Session["CentreID"].ToString()) + ")");

        return StockReports.GetDataTable(query.ToString());
    }

    protected void grdDataView_rowCaommand(object sender, GridViewCommandEventArgs e)
    {
        int id = Util.GetInt(e.CommandArgument.ToString());

        if (e.CommandName == "Print")
        {
            string status = StockReports.ExecuteScalar("SELECT Status FROM patient_medical_history WHERE TransactionID = '" + ViewState["TID"].ToString() + "'");

            DataTable dt = Search(id, status);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ReportName"] = "ECGReport";
            Session["ds"] = ds;
            //ds.WriteXmlSchema(@"d:\ecgReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else if (e.CommandName == "Edit1")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM ipd_ecg_examination WHERE ID = '" + id + "'");

            ViewState["ID"] = dt.Rows[0]["ID"].ToString();

            txtCardiomegalyCause.Text = dt.Rows[0]["CardiomegalyofUCouse"].ToString();
            txtHeartFailure.Text = dt.Rows[0]["HeartfailureofUCause"].ToString();
            txtSystolic.Text = dt.Rows[0]["SystolicmurmurState"].ToString();
            txtDiastolic.Text = dt.Rows[0]["DiastolicmurmurState"].ToString();
            txtRheumatic.Text = dt.Rows[0]["RCarditisFeverHeDisease"].ToString();
            txtFever.Text = dt.Rows[0]["Fever"].ToString();
            txtClubbing.Text = dt.Rows[0]["Clubblingoffing"].ToString();
            txtSplenomegaly.Text = dt.Rows[0]["Splenmegaly"].ToString();
            txtMicroHaematuria.Text = dt.Rows[0]["MicroHeamaturia"].ToString();
            txtPBlood.Text = dt.Rows[0]["PoBloodCulture"].ToString();
            txtRaisedESR.Text = dt.Rows[0]["RaisedEsr"].ToString();
            txtAnaemia.Text = dt.Rows[0]["Anaemia"].ToString();
            txtPeriCardial.Text = dt.Rows[0]["PeriEffCardTampPeri"].ToString();
            txtHypertens.Text = dt.Rows[0]["HyperHeartDis"].ToString();
            txtAngina.Text = dt.Rows[0]["AngPectMyoCardinf"].ToString();
            txtConfenital.Text = dt.Rows[0]["CongHeartDis"].ToString();
            txtOReason.Text = dt.Rows[0]["OtherRes"].ToString();
            txtDyspnoea.Text = dt.Rows[0]["Dyspnoea"].ToString();
            txtEFatigability.Text = dt.Rows[0]["EasyFatig"].ToString();
            txtPalpitation.Text = dt.Rows[0]["Palpitation"].ToString();
            txtOrthoponoea.Text = dt.Rows[0]["Orthopoea"].ToString();
            txtNocturnal.Text = dt.Rows[0]["NoctDypWheeCough"].ToString();
            txtForthySputum.Text = dt.Rows[0]["FrothySputum"].ToString();
            txtHaemoptysis.Text = dt.Rows[0]["Heamoptysis"].ToString();
            txtAnkle.Text = dt.Rows[0]["AnkleAbdoGenSwel"].ToString();
            txtNYAssosiation.Text = dt.Rows[0]["NYHeartAssFuncClass"].ToString();
            txt_1.Text = dt.Rows[0]["NYHeartAssFuncClass_1"].ToString();
            txt_2.Text = dt.Rows[0]["NYHeartAssFuncClass_2"].ToString();
            txt_3.Text = dt.Rows[0]["NYHeartAssFuncClass_3"].ToString();
            txt_4.Text = dt.Rows[0]["NYHeartAssFuncClass_4"].ToString();

            btnSave.Visible = false;
            btnUdate.Visible = true;
        }
    }
}




