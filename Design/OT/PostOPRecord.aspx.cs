using System;
using System.Collections.Generic;
using MW6BarcodeASPNet;
using System;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web;
using MySql.Data.MySqlClient;
using System.Linq;

public partial class Design_OT_PostOPRecord : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Transaction_ID.Text = Request.QueryString["TransactionID"].ToString();
            PatientId.Text = Request.QueryString["PatientId"].ToString();
            App_ID.Text = Request.QueryString["App_ID"].ToString();
       
            if (Convert.ToString(HttpContext.Current.Session["RoleID"]).ToUpper() == "111")
            {
                OTBookingID.Text = Request.QueryString["OTBookingID"].ToString();
                OTNumber.Text = Request.QueryString["OTNumber"].ToString();
                btnSave.Visible = true;
            }
            else
            {
                btnSave.Visible = false;
            }
            ViewState["UserID"] = Session["ID"].ToString();
            BindData(Transaction_ID.Text.ToString(), PatientId.Text.ToString());
           // BindGraphBP(Transaction_ID.Text);
           // BindGraphPulse(Transaction_ID.Text);
        }

    }
    protected void BindData(string TnxID, string PnxID)
    {
        try
        {
            DataTable dtdetail = StockReports.GetDataTable(" SELECT * , UPPER(CONCAT(dm.Title,' ',dm.Name))SurgeonName,UPPER(CONCAT(dj.Title,' ',dj.Name))AnaesthistName FROM PostOpRecord pr LEFT JOIN  doctor_master dm ON dm.DoctorID=pr.Surgeon LEFT JOIN  doctor_master dj ON dj.DoctorID=pr.Anaesthist WHERE Transaction_ID='" + Transaction_ID.Text + "' AND Patient_ID='" + PatientId.Text + "'   ");
            if (dtdetail.Rows.Count > 0)
            {
                grdPhysical.DataSource = dtdetail;
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
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string Surgeon = hdnddlSurgeon.Value;
        string Anaesthist = hdnddlAnaesthist.Value;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int ChkEntery = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM PostOpRecord WHERE ID='" + lblID.Text + "'"));
            if (ChkEntery > 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from PostOpRecord WHERE ID='" + lblID.Text + "'");
            }
            string chklistValue = "";
            foreach (ListItem chk in chkList.Items)
            {
                if (chk.Selected == true)
                {
                    chklistValue = chklistValue + ',' + chk;
                }
            }
            string chklistValue2 = "";
            foreach (ListItem chk in chkPharynx.Items)
            {
                if (chk.Selected == true)
                {
                    chklistValue2 = chklistValue2 + ',' + chk;
                }
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO postoprecord(Patient_ID,Transaction_ID,Appointment_ID,OTBOOKING_ID,OriginalWard,ArrivalRecovery,ReturnedWard,DepartureRecovery, ");
            sb.Append(" Surgeon, Anaesthist, CONDITIONN, Conscious, RP, Colour, SemiConscious, PulseRate, Conjuntiva, Unconscious,");
            sb.Append("  SPO2, TimeFullyConscious, Respiration, Adequate, Depressed, Vomited, Salivation, Pharynx, edication, IVFluids, ");
            sb.Append("  Remarks,CreatedBy,CreatedDate,Temp,BloodSugar,BloodSugarType,OtherSpecify,Reports,AdditionalDoctors)VALUES ('" + PatientId.Text + "','" + Transaction_ID.Text + "','" + App_ID.Text + "', '" + OTBookingID.Text + "', '" + txtOriginalWard.Text.Trim().ToString() + "', '" + Util.GetDateTime(txtArrivalRecovery.Text).ToString("HH:mm:ss") + "', '" + txtReturnedWard.Text.Trim().ToString() + "', '" + Util.GetDateTime(txtDepartureRecovery.Text).ToString("HH:mm:ss") + "', ");
            sb.Append("'" + hdnddlSurgeon.Value + "','" + hdnddlAnaesthist.Value + "','" + txtCondition.Text.Trim().ToString() + "','" + txtConscious.Text.Trim().ToString() + "','" + txtRP.Text.Trim().ToString() + "','" + ddlColour.SelectedValue + "','" + txtSemiConscious.Text.Trim().ToString() + "','" + txtPulseRate.Text.Trim().ToString() + "','" + txtConjuntiva.Text.Trim().ToString() + "','" + txtUnconscious.Text.Trim().ToString() + "','" + txtSPO2.Text.Trim().ToString() + "', ");
            sb.Append("'" + txtTimeFullyConscious.Text.Trim().ToString() + "','" + txtRespiration.Text.Trim().ToString() + "','" + txtAdequate.Text.Trim().ToString() + "','" + txtDepressed.Text.Trim().ToString() + "','" + rdList.SelectedValue + "', ");
            sb.Append("'" + chklistValue.TrimStart(',') + "','" + chklistValue2.TrimStart(',') + "','" + txtMedication.Text.Trim().ToString() + "','" + txtIVFluids.Text.Trim().ToString() + "','" + txtRemarks.Text.Trim().ToString() + "','" + ViewState["UserID"] + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + txtTemp.Text.Trim() + "','" + ddlParticular.SelectedValue.ToString() + "','" + txtbloodsugar.Text + "','" + txtOtherSpecification.Text + "','" + txtReport.Text + "','" + txtAdditionalDoctors.Text + "' )");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();
            BindData(Transaction_ID.Text.ToString(), PatientId.Text.ToString());
            BindGraphBP(Transaction_ID.Text);
            BindGraphPulse(Transaction_ID.Text);
            lblMsg.Text = "Record Saved Successfully";
            Clear();

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            // ScriptManager.RegisterStartupScr\ipt(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
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
                lblMsg.Text = "";

                string id = e.CommandArgument.ToString();

                DataTable dtdetail = StockReports.GetDataTable(" select *,DATE_FORMAT(ArrivalRecovery,'%h:%i %p')ArrivalRecovery1,DATE_FORMAT(DepartureRecovery,'%h:%i %p')DepartureRecovery1 from postoprecord WHERE ID='" + id + "'");

                if (dtdetail.Rows.Count > 0)
                {

                    lblID.Text = dtdetail.Rows[0]["ID"].ToString();
                    txtOriginalWard.Text = dtdetail.Rows[0]["OriginalWard"].ToString();
                    txtArrivalRecovery.Text = dtdetail.Rows[0]["ArrivalRecovery1"].ToString();
                    txtReturnedWard.Text = dtdetail.Rows[0]["ReturnedWard"].ToString();
                    txtDepartureRecovery.Text = dtdetail.Rows[0]["DepartureRecovery1"].ToString();
                    hdnddlSurgeon.Value = dtdetail.Rows[0]["Surgeon"].ToString();
                    hdnddlAnaesthist.Value = dtdetail.Rows[0]["Anaesthist"].ToString();
                    txtCondition.Text = dtdetail.Rows[0]["Conditionn"].ToString();
                    txtConscious.Text = dtdetail.Rows[0]["Conscious"].ToString();
                    txtRP.Text = dtdetail.Rows[0]["RP"].ToString();
                    ddlColour.SelectedValue = dtdetail.Rows[0]["Colour"].ToString();
                    txtSemiConscious.Text = dtdetail.Rows[0]["SemiConscious"].ToString();
                    txtPulseRate.Text = dtdetail.Rows[0]["PulseRate"].ToString();
                    txtConjuntiva.Text = dtdetail.Rows[0]["Conjuntiva"].ToString();
                    txtUnconscious.Text = dtdetail.Rows[0]["Unconscious"].ToString();
                    txtSPO2.Text = dtdetail.Rows[0]["SPO2"].ToString();
                    txtTimeFullyConscious.Text = dtdetail.Rows[0]["TimeFullyConscious"].ToString();
                    txtRespiration.Text = dtdetail.Rows[0]["Respiration"].ToString();
                    txtAdequate.Text = dtdetail.Rows[0]["Adequate"].ToString();
                    txtDepressed.Text = dtdetail.Rows[0]["Depressed"].ToString();
                    rdList.SelectedValue = dtdetail.Rows[0]["Vomited"].ToString();
                    string strImagineRadioloy = dtdetail.Rows[0]["Salivation"].ToString(); ;
                    string[] ArrImagingandRadiology = strImagineRadioloy.Split(',');
                    foreach (string sub_str in ArrImagingandRadiology)
                    {
                        for (int i = 0; i <= chkList.Items.Count - 1; i++)
                        {
                            if (sub_str == chkList.Items[i].Text)
                            {
                                chkList.Items[i].Selected = true;
                            }
                        }
                    }
                    string strPharynx = dtdetail.Rows[0]["Pharynx"].ToString(); ;
                    string[] ArrstrPharynx = strPharynx.Split(',');
                    foreach (string sub_str in ArrstrPharynx)
                    {
                        for (int i = 0; i <= chkPharynx.Items.Count - 1; i++)
                        {
                            if (sub_str == chkPharynx.Items[i].Text)
                            {
                                chkPharynx.Items[i].Selected = true;
                            }
                        }
                    }
                    txtMedication.Text = dtdetail.Rows[0]["edication"].ToString();
                    txtIVFluids.Text = dtdetail.Rows[0]["IVFluids"].ToString();
                    txtRemarks.Text = dtdetail.Rows[0]["Remarks"].ToString();
                    txtTemp.Text = dtdetail.Rows[0]["Temp"].ToString();
                    ddlParticular.SelectedValue = dtdetail.Rows[0]["BloodSugar"].ToString();
                    txtbloodsugar.Text = dtdetail.Rows[0]["BloodSugarType"].ToString();
                    txtOtherSpecification.Text = dtdetail.Rows[0]["OtherSpecify"].ToString();
                    txtReport.Text = dtdetail.Rows[0]["Reports"].ToString();
					txtAdditionalDoctors.Text = dtdetail.Rows[0]["AdditionalDoctors"].ToString();
                }

                btnSave.Text = "Update";

                if (Convert.ToString(HttpContext.Current.Session["RoleID"]).ToUpper() == "111")
                  btnSave.Visible = true;
                else
                  btnSave.Visible = false;
            }
            if (e.CommandName == "imbPrint")
            {
                string id = e.CommandArgument.ToString();
                string str1 = "SELECT DATE_FORMAT(pr.ArrivalRecovery,'%h:%i %p')ArrivalRecovery1,DATE_FORMAT(pr.DepartureRecovery,'%h:%i %p')DepartureRecovery1,pr.OriginalWard,pr.ReturnedWard,UPPER(CONCAT(dm.Title,' ',dm.Name))SurgeonName,UPPER(CONCAT(dj.Title,' ',dj.Name))AnaesthistName, pr.CONDITIONN,pr.Conscious, pr.RP, pr.Colour, pr.SemiConscious, pr.PulseRate, pr.Conjuntiva, pr.Unconscious, pr.SPO2, pr.TimeFullyConscious, pr.Respiration, pr.Adequate, pr.Depressed,pr.Vomited,pr.Salivation,pr.Pharynx,pr.edication,pr.IVFluids,pr.Remarks FROM postoprecord pr LEFT JOIN  doctor_master dm ON dm.DoctorID=pr.Surgeon LEFT JOIN  doctor_master dj ON dj.DoctorID=pr.Anaesthist WHERE pr.ID='" + id + "'";
                DataTable dt1 = StockReports.GetDataTable(str1);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt1.Copy());
             //   ds.WriteXmlSchema("E:\\Print.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "PrintPostOPRecord";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key15", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
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
            lblID.Text = "";

            txtOriginalWard.Text = "";
            txtArrivalRecovery.Text = "";
            txtReturnedWard.Text = "";
            txtDepartureRecovery.Text = "";
            ddlSurgeon.ClearSelection();
            ddlAnaesthist.ClearSelection();
            txtCondition.Text = "";
            txtConscious.Text = "";
            txtRP.Text = "";
            ddlColour.SelectedValue = "";
            txtSemiConscious.Text = "";
            txtPulseRate.Text = "";
            txtConjuntiva.Text = "";
            txtUnconscious.Text = "";
            txtSPO2.Text = "";
            txtTimeFullyConscious.Text = "";
            txtRespiration.Text = "";
            txtAdequate.Text = "";
            txtDepressed.Text = "";
            rdList.ClearSelection();
            chkList.ClearSelection();
            chkPharynx.ClearSelection();
            txtMedication.Text = "";
            txtIVFluids.Text = "";
            txtRemarks.Text = "";
            txtTemp.Text = "";
            txtbloodsugar.Text = "";
            txtOtherSpecification.Text = "";
            txtReport.Text = "";
			txtAdditionalDoctors.Text = "";

            btnSave.Visible = true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void BindGraphBP(string TID)
    {
        try
        {
            DataTable dt = new DataTable();
            if (TID.Contains("ISHHI"))
            {
                dt = StockReports.GetDataTable("SELECT split_str(Rp,'/',1)Systolic,TRIM(split_str(Rp,'/',2))Diastolic,date_format(CreatedDate,'%d-%b-%Y %H:%i %p') as CreatedDate FROM postoprecord WHERE Transaction_ID='" + TID + "'");
            }
          
            if (dt.Rows.Count > 0)
            {
                double maxBPSystolic = 0;
                double minBPSystolic = 0.00;
                double maxBPDiastolic = 0.00;
                double minBPDiastolic = 0.00;

                maxBPSystolic = Convert.ToDouble(dt.AsEnumerable().Max(column => column["Systolic"]));
                minBPSystolic = Convert.ToDouble(dt.AsEnumerable().Min(column => column["Systolic"]));
                maxBPDiastolic = Convert.ToDouble(dt.AsEnumerable().Max(column => column["Diastolic"]));
                minBPDiastolic = Convert.ToDouble(dt.AsEnumerable().Min(column => column["Diastolic"]));

                double minBp = 0.00;
                double maxBp = 0.00;
                if (maxBPSystolic >= maxBPDiastolic)
                {
                    maxBp = maxBPSystolic;
                }
                if (maxBPDiastolic >= maxBPSystolic)
                {
                    maxBp = maxBPDiastolic;
                }
                if (minBPSystolic >= minBPDiastolic)
                {
                    minBp = minBPDiastolic;
                }
                if (minBPDiastolic >= minBPSystolic)
                {
                    minBp = minBPSystolic;
                }
                if (maxBp > minBp)
                {
                    chartBP.DataSource = dt;
                    chartBP.Legends.Add("RP").Title = "Blood Pressure Graph";
                    chartBP.ChartAreas["ChartArea2"].AxisX.Title = "DateTime";
                    chartBP.ChartAreas["ChartArea2"].AxisY.Minimum = minBp;
                    chartBP.ChartAreas["ChartArea2"].AxisY.Maximum = maxBp;
                    chartBP.ChartAreas["ChartArea2"].AxisY.Interval = 5;

                    chartBP.ChartAreas["ChartArea2"].AxisY.Title = "BP";
                    chartBP.Series["Systolic"].XValueMember = "CreatedDate";
                    chartBP.Series["Systolic"].YValueMembers = "Systolic";
                    chartBP.Series["Diastolic"].XValueMember = "CreatedDate";
                    chartBP.Series["Diastolic"].YValueMembers = "Diastolic";


                    chartBP.Series["Diastolic"].ToolTip = " #VALX | #VALY";
                    chartBP.Series["Systolic"].ToolTip = " #VALX | #VALY";

                    chartBP.DataBind();
                }
                else
                    lblMsg.Text = "Please Enter Correct B/P Data";
            }
            else
                lblMsg.Text = "B/P Record Not Found";
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }

    private void BindGraphPulse(string TID)
    {
        try
        {
            DataTable dt = new DataTable();
            if (TID.Contains("ISHHI"))
            {
                dt = StockReports.GetDataTable("SELECT (SPO2+0)SPO2,date_format(CreatedDate,'%d-%b-%Y %H:%i %p') as CreatedDate FROM postoprecord WHERE Transaction_ID='" + TID + "' ");
            }
          
            if (dt.Rows.Count > 0)
            {

                double maxPulse = Convert.ToDouble(dt.Compute("max(SPO2)", string.Empty));
                double minPulse = Convert.ToDouble(dt.Compute("min(SPO2)", string.Empty));
                if (maxPulse > minPulse)
                {
                    chartPL.DataSource = dt;
                    chartPL.Legends.Add("SPO2").Title = "SPO2 Graph";
                    chartPL.ChartAreas["ChartArea3"].AxisX.Title = "DateTime";
                    chartPL.ChartAreas["ChartArea3"].AxisY.Minimum = minPulse;
                    chartPL.ChartAreas["ChartArea3"].AxisY.Maximum = maxPulse;
                    chartPL.ChartAreas["ChartArea3"].AxisY.Interval = 5;
                    chartPL.ChartAreas["ChartArea3"].AxisY.Title = "SPO2";
                    chartPL.Series["SPO2"].XValueMember = "CreatedDate";
                    chartPL.Series["SPO2"].YValueMembers = "CreatedDate";

                    chartPL.Series["SPO2"].ToolTip = " #VALX | #VALY";

                    chartPL.DataBind();
                }
                else
                    // lblMsg.Text = "Please Enter Correct SPO2 Data";
                    lblMsg.Text = "";
            }
            else
            {
               // lblMsg.Text = "SPO2 Record Not Found";
                lblMsg.Text = "";
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
}
