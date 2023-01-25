using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_IPD_ViewPatientOrder_Sets : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["UserID"] = Session["ID"].ToString();
            }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
        }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        if (ddlOrderType.SelectedItem.Value.ToUpper() == "ALL")
        {
            //Medicine
            sb.Append(" SELECT * FROM (SELECT EntryID,TransactionID,ordset.PatientID,'Medicine Orders' OrderSet,(SELECT CONCAT(title,' ',NAME)");
            sb.Append(" FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')EntryDate,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex");
            sb.Append(" FROM orderset_medication ordset inner join patient_master pm on pm.PatientID=ordset.patientID");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.Transactionid ='" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.entrydate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.entrydate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID");
            //Diagnosis
            sb.Append(" Union All");
            sb.Append(" SELECT EntryID,TransactionID,ordset.PatientID,'Lab & Radio Orders' OrderSet,(SELECT CONCAT(title,' ',NAME)");
            sb.Append(" FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')EntryDate,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex");
            sb.Append(" FROM orderset_diagnosis ordset inner join patient_master pm on pm.PatientID=ordset.patientID");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.Transactionid ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.entrydate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.entrydate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID");
            //Diet
            sb.Append(" Union All");
            sb.Append(" SELECT EntryID,TransactionID,ordset.PatientID,'Diet Orders' OrderSet,(SELECT CONCAT(title,' ',NAME)");
            sb.Append(" FROM Employee_master WHERE EmployeeID=EnterBy)EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')EntryDate,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex");
            sb.Append(" FROM orderset_diet ordset inner join patient_master pm on pm.PatientID=ordset.patientID");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.Transactionid ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.entrydate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.entrydate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID");
            //General
            sb.Append(" Union All");
            sb.Append(" SELECT EntryID,TransactionID,ordset.PatientID,'General Orders' OrderSet,(SELECT CONCAT(title,' ',NAME)");
            sb.Append(" FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')EntryDate,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex");
            sb.Append(" FROM orderset_general ordset inner join patient_master pm on pm.PatientID=ordset.patientID");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.Transactionid ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.entrydate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.entrydate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID ");
            //Physio
            sb.Append(" Union All");
            sb.Append(" SELECT EntryID,TransactionID,ordset.PatientID,'IPD Admission Orders' OrderSet,(SELECT CONCAT(title,' ',NAME)");
            sb.Append(" FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')EntryDate,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex");
            sb.Append(" FROM Orderset_IPDAdmission ordset inner join patient_master pm on pm.PatientID=ordset.patientID");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.Transactionid ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.entrydate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.entrydate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID");
            //Consultation
            sb.Append(" Union All");
            sb.Append(" SELECT EntryID,TransactionID AS TransactionID,ordset.PatientID PatientID,'Consultation Order' OrderSet,(SELECT CONCAT(title,' ',NAME) ");
            sb.Append(" FROM Employee_master WHERE EmployeeID=CreatedBy)EntryBy,DATE_FORMAT(CreatedDate,'%d-%b-%y %l:%i %p')EntryDate, ");
            sb.Append(" CONCAT(pm.title,' ',pm.Pname)PatientName,CONCAT(pm.Age,' ','/',' ',pm.Gender)AgeSex ");
            sb.Append(" FROM cpoe_admission_consultation ordset INNER JOIN patient_master pm ON pm.PatientID=ordset.PatientID ");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }
            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.TransactionID ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.CreatedDate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.CreatedDate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID)t ORDER BY t.OrderSet,t.EntryDate DESC");
        }
        if (ddlOrderType.SelectedItem.Value == "Medicine")
        {
            sb.Append(" SELECT EntryID,TransactionID,ordset.PatientID,'Medicine Orders' OrderSet,(SELECT CONCAT(title,' ',NAME)");
            sb.Append(" FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')EntryDate,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex");
            sb.Append(" FROM orderset_medication ordset inner join patient_master pm on pm.PatientID=ordset.patientID");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.Transactionid ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.entrydate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.entrydate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID ORDER BY OrderSet,EntryDate DESC");
        }
        if (ddlOrderType.SelectedItem.Value == "IPD Admission")
        {
            sb.Append(" SELECT EntryID,Replace(TransactionID,'ISHHI','')TransactionID,ordset.PatientID,'IPD Admission Orders' OrderSet,(SELECT CONCAT(title,' ',NAME)");
            sb.Append(" FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')EntryDate,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex");
            sb.Append(" FROM Orderset_IPDAdmission ordset inner join patient_master pm on pm.PatientID=ordset.patientID");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.Transactionid ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.entrydate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.entrydate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID ORDER BY OrderSet,EntryDate DESC");
        }
        if (ddlOrderType.SelectedItem.Value == "Diet")
        {
            sb.Append(" SELECT EntryID,TransactionID,ordset.PatientID,'Diet Orders' OrderSet,(SELECT CONCAT(title,' ',NAME)");
            sb.Append(" FROM Employee_master WHERE EmployeeID=EnterBy)EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')EntryDate,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex");
            sb.Append(" FROM orderset_diet ordset inner join patient_master pm on pm.PatientID=ordset.patientID");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.Transactionid ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.entrydate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.entrydate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID  ORDER BY OrderSet,EntryDate DESC");
        }
        if (ddlOrderType.SelectedItem.Value == "Lab & Radio")
        {
            sb.Append(" SELECT EntryID,TransactionID,ordset.PatientID,'Lab & Radio Orders' OrderSet,(SELECT CONCAT(title,' ',NAME)");
            sb.Append(" FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')EntryDate,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex");
            sb.Append(" FROM orderset_diagnosis ordset inner join patient_master pm on pm.PatientID=ordset.patientID");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.Transactionid ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.entrydate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.entrydate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID ORDER BY OrderSet,EntryDate DESC");
        }
        if (ddlOrderType.SelectedItem.Value == "General")
        {
            sb.Append(" SELECT EntryID,TransactionID,ordset.PatientID,'General Orders' OrderSet,(SELECT CONCAT(title,' ',NAME)");
            sb.Append(" FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')EntryDate,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex");
            sb.Append(" FROM orderset_general ordset inner join patient_master pm on pm.PatientID=ordset.patientID");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.Transactionid ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.entrydate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.entrydate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID ORDER BY OrderSet,EntryDate DESC");
        }
        if (ddlOrderType.SelectedItem.Value == "Consultations Order")
        {
            sb.Append(" SELECT EntryID,TransactionID AS TransactionID,ordset.PatientID AS PatientID,'Consultation Order' OrderSet,(SELECT CONCAT(title,' ',NAME) ");
            sb.Append(" FROM Employee_master WHERE EmployeeID=CreatedBy)EntryBy,DATE_FORMAT(CreatedDate,'%d-%b-%y %l:%i %p')EntryDate, ");
            sb.Append(" CONCAT(pm.title,' ',pm.Pname)PatientName,CONCAT(pm.Age,' ','/',' ',pm.Gender)AgeSex ");
            sb.Append(" FROM cpoe_admission_consultation ordset INNER JOIN patient_master pm ON pm.PatientID=ordset.PatientID ");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }
            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtName.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND ordset.TransactionID ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(ordset.CreatedDate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(ordset.CreatedDate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY EntryID ORDER BY OrderSet,CreatedDate DESC");
        }
        DataTable Items = StockReports.GetDataTable(sb.ToString());

        if (Items.Rows.Count > 0)
        {
            lblMsg.Text = "";
            grdPatient.DataSource = Items;
            grdPatient.DataBind();
        }
        else
        {
            grdPatient.DataSource = null;
            grdPatient.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    private void BindLogPopUp(string EntryType, string EntryID)
    {
        DataTable dtLog = StockReports.GetDataTable(" SELECT (SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=ToEmployeeID)ReadBy,Date_Format(ReadedDate,'%d-%b-%Y %l:%i %p')ReadDate FROM orderset_notification WHERE EntryID=" + EntryID + " and EntryType='" + EntryType + "' and IsReaded=1 group by ToEmployeeID order by ReadedDate Desc");
        if (dtLog.Rows.Count > 0)
        {
            mpeLog.Show();
            grdLog.DataSource = dtLog;
            grdLog.DataBind();
        }
        else
            lblMsg.Text = "No Log Available for this Order"; lblMsg.Visible = true;
    }
    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ALog")
        {
            if (e.CommandArgument.ToString().Split('#')[1] == "Diet Orders")
            {
                BindLogPopUp("Diet Order", e.CommandArgument.ToString().Split('#')[0]);
            }
            if (e.CommandArgument.ToString().Split('#')[1] == "IPD Admission Orders")
            {
                BindLogPopUp("IPDAdmission Order", e.CommandArgument.ToString().Split('#')[0]);
            }
            if (e.CommandArgument.ToString().Split('#')[1] == "Lab & Radio Orders")
            {
                BindLogPopUp("Diagnosis Order", e.CommandArgument.ToString().Split('#')[0]);
            }
            if (e.CommandArgument.ToString().Split('#')[1] == "General Orders")
            {
                BindLogPopUp("General Order", e.CommandArgument.ToString().Split('#')[0]);
            }
            if (e.CommandArgument.ToString().Split('#')[1] == "Medicine Orders")
            {
                BindLogPopUp("Medicine Order", e.CommandArgument.ToString().Split('#')[0]);
            }
            if (e.CommandArgument.ToString().Split('#')[1] == "Consultation Order")
            {
                BindLogPopUp("Consultation Order", e.CommandArgument.ToString().Split('#')[0]);
            }

        }
        if (e.CommandName == "Aview")
        {
            DataTable dt = new DataTable();
            if (e.CommandArgument.ToString().Split('#')[1] == "Medicine Orders")
            {
                dt = StockReports.GetDataTable(" SELECT MedicineName,Dose,Timing,Duration,Remark FROM orderset_medication WHERE EntryID=" + Util.GetInt(e.CommandArgument.ToString().Split('#')[0]) + "");
                if (dt.Rows.Count > 0)
                {
                    mpeMedicine.Show();
                    grdMedicinePopUp.DataSource = dt;
                    grdMedicinePopUp.DataBind();
                    UpdateReadFlag("Medicine Order", Util.GetInt(e.CommandArgument.ToString().Split('#')[0]),7);
                }
                else
                {
                    grdMedicinePopUp.DataSource = "";
                    grdMedicinePopUp.DataBind();
                }
                
            }
            if (e.CommandArgument.ToString().Split('#')[1] == "General Orders")
            {
                dt = StockReports.GetDataTable(" SELECT OrderDetail FROM orderset_general WHERE EntryID=" + Util.GetInt(e.CommandArgument.ToString().Split('#')[0]) + "");
                if (dt.Rows.Count > 0)
                {
                    mpeGeneral.Show();
                    grdGeneralPopUp.DataSource = dt;
                    grdGeneralPopUp.DataBind();
                    UpdateReadFlag("General Order", Util.GetInt(e.CommandArgument.ToString().Split('#')[0]),9);
                }
               
            }
            if (e.CommandArgument.ToString().Split('#')[1] == "Lab & Radio Orders")
            {
                dt = StockReports.GetDataTable(" SELECT ItemName,Remark,Date_Format(Date,'%d-%m-%Y')Date FROM OrderSet_Diagnosis WHERE EntryID=" + Util.GetInt(e.CommandArgument.ToString().Split('#')[0]) + "");
                if (dt.Rows.Count > 0)
                {
                    mpeDiagnosis.Show();
                    grdDiagnosisPopUp.DataSource = dt;
                    grdDiagnosisPopUp.DataBind();
                    UpdateReadFlag("Diagnosis Order", Util.GetInt(e.CommandArgument.ToString().Split('#')[0]),2);
                }
                
            }
            if (e.CommandArgument.ToString().Split('#')[1] == "IPD Admission Orders")
            {
                dt = StockReports.GetDataTable(" SELECT OrderDetail FROM Orderset_IPDAdmission WHERE EntryID=" + Util.GetInt(e.CommandArgument.ToString().Split('#')[0]) + "");
                if (dt.Rows.Count > 0)
                {
                    mpeGeneral.Show();
                    grdGeneralPopUp.DataSource = dt;
                    grdGeneralPopUp.DataBind();
                    UpdateReadFlag("IPDAdmission Order", Util.GetInt(e.CommandArgument.ToString().Split('#')[0]),17);
                } 
            }
            if (e.CommandArgument.ToString().Split('#')[1] == "Consultation Order")
            {
                dt = StockReports.GetDataTable("SELECT (SELECT CONCAT(title,'',NAME) FROM Doctor_master WHERE DoctorID=SpecialistID)Doctor_name,TYPE,DATE_FORMAT(SpecialistDate,'%d-%m-%Y')SpecialistDate,DATE_FORMAT(SpecialistTime,'%l:%i %p')SpecialistTime,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=CreatedBy)EntryBy FROM cpoe_admission_consultation WHERE EntryID=" + Util.GetInt(e.CommandArgument.ToString().Split('#')[0]) + "");
                if (dt.Rows.Count > 0)
                {
                    mpeConsultation.Show();
                    grdconsultationDetail.DataSource = dt;
                    grdconsultationDetail.DataBind();
                    UpdateReadFlag("Consultation Order", Util.GetInt(e.CommandArgument.ToString().Split('#')[0]),13);
                }
                else
                {
                    grdMedicinePopUp.DataSource = "";
                    grdMedicinePopUp.DataBind();
                }
            }
            if (e.CommandArgument.ToString().Split('#')[1] == "Diet Orders")
            {
                DataTable dtDetails = StockReports.GetDataTable("Select * from orderset_diet where EntryID=" + Util.GetInt(e.CommandArgument.ToString().Split('#')[0]) + "");
                if (dtDetails.Rows.Count > 0)
                {
                    if (dtDetails.Rows[0]["FullDiet"].ToString() != "")
                        chkFullDiet.Checked = true;
                    if (dtDetails.Rows[0]["TPN"].ToString() != "")
                        chkTPN.Checked = true;
                    if (dtDetails.Rows[0]["FeedingTube"].ToString() != "")
                        chkFeedingTube.Checked = true;
                    if (dtDetails.Rows[0]["OralFluid"].ToString() != "")
                        chkOralFluids.Checked = true;
                    if (dtDetails.Rows[0]["Nil"].ToString() != "")
                        chkNil.Checked = true;
                    txtMouth.Text = dtDetails.Rows[0]["Nil_Mouth"].ToString();
                    txtThen.Text = dtDetails.Rows[0]["Nil_Then"].ToString();
                    txtComment.Text = dtDetails.Rows[0]["Comments"].ToString();
                    mpeDiet.Show();
                    UpdateReadFlag("Diet Order", Util.GetInt(e.CommandArgument.ToString().Split('#')[0]),10);
                }
                
            }

        }
    }
    protected void UpdateReadFlag(string EntryType, int EntryID, int NotificationType)
    {
        string str = "Update orderset_notification set IsReaded=1, ReadedDate=now() where EntryType='" + EntryType + "' and EntryID=" + EntryID + " and ToEmployeeID='" + ViewState["UserID"].ToString() + "'";
        StockReports.ExecuteDML(str);
        All_LoadData.updateNotification(Util.GetString(EntryID), Util.GetString(Session["ID"].ToString()), Util.GetString(Session["RoleID"].ToString()), 17);
    }
    protected void repRehapOrderSet_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex >= 1)
        {
            string GroupName = ((Label)e.Item.FindControl("lblHead")).Text;
            string PreviousGroupName = ((Label)repRehapOrderSet.Items[e.Item.ItemIndex - 1].FindControl("lblHead")).Text;
            if (GroupName == PreviousGroupName)
            {
                ((HtmlTableRow)e.Item.FindControl("trHeading")).Visible = false;
            }
        }
    }
}