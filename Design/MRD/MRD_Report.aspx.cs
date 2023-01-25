using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_MRD_MRD_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            ucDateFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucDateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnissue);
            
        }
        ucDateFrom.Attributes.Add("readonly", "readonly");
        ucDateTo.Attributes.Add("readonly", "readonly");
    }
    protected void btnissue_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Centre',function(){});", true);
            return;
        }
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        if (rbtnreport.SelectedValue == "9")
        {
            sb.Append("SELECT t.TotalFuncBed,t1.TotalAdmits,t.TotalFuncBed*(IF(DATEDIFF('" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "')=0,1,DATEDIFF('" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "')))AvailableBedDays, ");
            sb.Append("t2.TotalDischarged,t3.PatientDays,t4.TotalDeaths, ");
            sb.Append("t5.TotalBirth,t5.BirthFeMale,t5.BirthMale,t5.LSCS,t5.NVD,t6.MajorPro,t6.MinorPro,t7.OPD_Patients, ");
            sb.Append("t8.Total_MLC,t8.RTA,t8.Poisoining,t8.Burns,t8.Hanging,t8.Assaults,t9.DeathUnder48Hrs,t10.DeathOver48Hrs  FROM ( ");
            sb.Append("     SELECT COUNT(RoomID)TotalFuncBed FROM ipd_case_type_master icm  ");
            sb.Append("     INNER JOIN room_master rm ON icm.IPDCaseTypeID = rm.IPDCaseTypeID ");
            sb.Append("     WHERE icm.IsActive=1 AND rm.IsActive=1  and rm.IsCountable=1 ");
            sb.Append(" )t, (");
            sb.Append("     SELECT COUNT(TransactionID)TotalAdmits FROM patient_medical_history ");
            sb.Append("     WHERE DATE(DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(DateOfAdmit) <='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("     AND UCASE(STATUS) <>'CANCEL' AND CentreID IN (" + Centre + ") ");
            sb.Append(" )t1,(");
            sb.Append("     SELECT COUNT(TransactionID)TotalDischarged FROM patient_medical_history ");
            sb.Append("     WHERE DATE(DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("     AND UCASE(STATUS) <>'CANCEL' AND CentreID IN (" + Centre + ") ");
            sb.Append(" )t2,( ");
            sb.Append("     SELECT COUNT(TransactionID)PatientDays FROM patient_ipd_profile pip INNER JOIN  ( ");
            sb.Append("         SELECT * FROM temp_for_date WHERE DATE(dt)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(dt)<= '" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("     ) tfd WHERE UCASE(pip.Status)<>'CANCEL' AND CONCAT(pip.StartDate,' ',pip.StartTime )  <= CONCAT(tfd.dt,' ','23:59:59') ");
            sb.Append("    AND  IF(STATUS='IN',CONCAT(CURDATE(),' ','23:59:59'), CONCAT(PIP.EndDate,' ',pip.EndTime)) >= CONCAT(tfd.dt,' ','23:59:59') AND pip.CentreID IN (" + Centre + ")");
            sb.Append(")t3,( ");
            sb.Append("    SELECT COUNT(pmh.TransactionID)TotalDeaths ");
            sb.Append("    FROM patient_medical_history pmh  ");
            sb.Append("    WHERE UCASE(pmh.DischargeType)='Death' ");
            sb.Append("    AND UCASE(pmh.Status)<>'CANCEL' ");
            sb.Append("    AND IF(Year(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("    AND IF(Month(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.CentreID IN (" + Centre + ") ");
            sb.Append(")t4,( ");
            sb.Append("     SELECT SUM(t.Total)TotalBirth, SUM(CASE WHEN UPPER(Gender)='FEMALE' THEN t.Total ELSE 0 END) BirthFeMale, ");
            sb.Append("     SUM(CASE WHEN UPPER(Gender)='MALE' THEN t.Total ELSE 0 END )BirthMale , ");
            sb.Append("     SUM(CASE WHEN UPPER(typeofdelivery)='LSCS' THEN t.Total ELSE 0 END )LSCS, ");
            sb.Append("     SUM(CASE WHEN UPPER(typeofdelivery)='NVD' THEN t.Total ELSE 0 END )NVD ");
            sb.Append("     FROM ( ");
            sb.Append("         SELECT COUNT(*)Total,pm.Gender,pmh.typeofdelivery FROM patient_medical_history pmh  ");
            sb.Append("         INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
            sb.Append("         WHERE pm.title='B/O' AND pmh.status<>'Cancel' ");
            sb.Append("         AND TRIM(REPLACE(pm.Age,'DAYS(S)','')) IN ('0','1') ");
            sb.Append("         AND DATE(pm.DateEnrolled)=DATE(pmh.DateOfAdmit) ");
            sb.Append("         AND DATE(pmh.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("         AND DATE(pmh.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.CentreID IN (" + Centre + ") GROUP BY pm.Gender,pmh.typeofdelivery ");
            sb.Append("     )t ");
            sb.Append(")t5,( ");
            sb.Append("    SELECT SUM(MajorPro)MajorPro,SUM(MinorPro)MinorPro FROM ( ");
            sb.Append("        SELECT ");
            sb.Append("        IF(cf.ConfigID=25,1,0) MinorPro,IF(cf.ConfigID=22,1,0) MajorPro ");
            sb.Append("        FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON ");
            sb.Append("        lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID INNER JOIN f_subcategorymaster sc ON ");
            sb.Append("        sc.SubCategoryID = ltd.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ");
            sb.Append("        WHERE cf.ConfigID IN (22,25) AND lt.CentreID IN (" + Centre + ") ");
            sb.Append("        AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),lt.IsCancel=0,ltd.IsVerified=1) ");
            sb.Append("        AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ) ");
            sb.Append("        AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ) ");
            sb.Append("        GROUP BY ltd.ledgertransactionNo ");
            sb.Append("    )t ");
            sb.Append(")t6,( ");
            sb.Append("    SELECT COUNT(lt.PatientID)OPD_Patients FROM f_ledgertransaction lt INNER JOIN patient_master pm ON ");
            sb.Append("    lt.TypeOfTnx ='OPD-Appointment' AND  pm.PatientID = lt.PatientID ");
            sb.Append("    WHERE  ");
            sb.Append("    DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND lt.CentreID IN (" + Centre + ") ");
            sb.Append(")t7,( ");
            sb.Append("    SELECT COUNT(TransactionID)Total_MLC, ");
            sb.Append(" IFNULL(SUM(IF(UCASE(mlc_type)='RTA',1,0)),0)RTA, ");
            sb.Append(" IFNULL(SUM(IF((mlc_type)='Poisoining',1,0)),0)Poisoining, ");
            sb.Append(" IFNULL(SUM(IF((mlc_type)='Burns',1,0)),0)Burns, ");
            sb.Append(" IFNULL(SUM(IF((mlc_type)='Hanging',1,0)),0)Hanging,      ");
            sb.Append(" IFNULL(SUM(IF((mlc_type)='Assaults',1,0)),0)Assaults ");
            sb.Append("    FROM patient_medical_history WHERE IFNULL(Admission_Type,'') = 'MLC CASE' AND TYPE='IPD' AND CentreID IN (" + Centre + ") ");
            sb.Append("    AND DATE(DateOfVisit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(DateOfVisit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append(")t8,( ");
            sb.Append("    SELECT COUNT(pmh.TransactionID)DeathUnder48Hrs ");
            sb.Append("    FROM patient_medical_history pmh  ");
            sb.Append("    WHERE UCASE(pmh.DischargeType)='Death' AND pmh.IsDeathOver48HRS=1 ");
            sb.Append("    AND UCASE(pmh.Status)<>'CANCEL' ");
            sb.Append("    AND IF(Year(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("    AND IF(Month(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.CentreID IN (" + Centre + ") ");
            sb.Append(")t9, ( ");
            sb.Append("    SELECT COUNT(pmh.TransactionID)DeathOver48Hrs ");
            sb.Append("    FROM patient_medical_history pmh  ");
            sb.Append("    WHERE UCASE(pmh.DischargeType)='Death' AND ifnull(pmh.IsDeathOver48HRS,'0')=0 ");
            sb.Append("    AND UCASE(pmh.Status)<>'CANCEL' ");
            sb.Append("    AND IF(Year(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("    AND IF(Month(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.CentreID IN (" + Centre + ") ");
            sb.Append(")t10 ");

            DataTable dtStat = StockReports.GetDataTable(sb.ToString());

            if (dtStat != null && dtStat.Rows.Count > 0)
            {
                DataTable dtModified = new DataTable();

                dtModified.Columns.Add("S.No.", typeof(string));
                dtModified.Columns.Add("Particulars", typeof(string));
                dtModified.Columns.Add("Status", typeof(decimal));

                dtModified = MapStatistics(dtModified, dtStat);

                lbldetail.Text = "Statistics";
                grddetail.DataSource = dtModified;
                grddetail.DataBind();
            }
            else
            {

                lbldetail.Text = "";
                lblsummary.Text = "";
                grdsummary.DataSource = null;
                grdsummary.DataBind();
                grddetail.DataSource = null;
                grddetail.DataBind();

            }
            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }
        if (rbtnreport.SelectedValue == "8")
        {
            sb.Append("     SELECT IF(t.Type='IPD',t.TransNo,'') as'Baby IPD No.',t.DOB 'D.O.B.',t.Gender 'Sex',t.Status,t.DocName 'Doctor Name',  ");
            sb.Append("     t.TypeofDelivery 'Type of Delivery',t.DeliveryWeeks 'Delivery Weeks Days',t.FatherName 'Father Name',t.BirthIgnoreReason 'Birth Ignore Reason'       ");
            sb.Append("     FROM (   SELECT IF(UPPER(pm.Relation)='FATHER',pm.RelationName,'')fatherName,pmh.DeliveryWeeks,pmh.typeofdelivery,pm.TimeOfBirth,pm.Weight,pm.gender,IF(pm.dob='0001-01-01',pm.age,pm.dob)DOB,  ");
            sb.Append("      pmh.TransactionID,dm.Name DocName,      ");
            sb.Append("     pmh.status,IFNULL(pmh.BirthIgnoreReason,'')BirthIgnoreReason ,pmh.Type,pmh.TransNo    FROM patient_medical_history pmh   ");
            sb.Append("     INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN doctor_master dm      ");
            sb.Append("     ON pmh.DoctorID=dm.DoctorID WHERE pmh.MotherTID<>'' AND pmh.status<>'Cancel' AND pmh.CentreID IN (" + Centre + ") AND DATE(pmh.DateofAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append("     AND  DATE(pmh.DateofAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "')t  ");
            DataTable dtbirthdtl = StockReports.GetDataTable(sb.ToString());
            if (dtbirthdtl != null && dtbirthdtl.Rows.Count > 0)
            {
                lbldetail.Text = "Birth Details";
                grddetail.DataSource = dtbirthdtl;
                grddetail.DataBind();
            }
            else
            {

                lbldetail.Text = "";
                lblsummary.Text = "";
                grdsummary.DataSource = null;
                grdsummary.DataBind();
                grddetail.DataSource = null;
                grddetail.DataBind();
            }

            StringBuilder sb1 = new StringBuilder();
            sb1.Append("  SELECT SUM(CASE WHEN UPPER(Gender)='FEMALE' THEN t.Total ELSE 0 END) Female, ");
            sb1.Append("  SUM(CASE WHEN UPPER(Gender)='MALE' THEN t.Total ELSE 0 END )Male ");
            sb1.Append("  ,SUM(CASE WHEN UPPER(typeofdelivery)='LSCS' THEN t.Total ELSE 0 END )LSCS, ");
            sb1.Append("  SUM(CASE WHEN UPPER(typeofdelivery)='NVD' THEN t.Total ELSE 0 END )NVD ");
            sb1.Append("   FROM ( ");
            sb1.Append("  SELECT COUNT(*)Total,pm.Gender,pmh.typeofdelivery FROM patient_medical_history pmh  ");
            sb1.Append("  INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
            sb1.Append("  WHERE pmh.MotherTID<>'' AND pmh.status<>'Cancel' AND pmh.status<>'Cancel' AND pmh.CentreID IN (" + Centre + ") and DATE(pmh.DateofAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.DateofAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' GROUP BY pm.Gender,pmh.typeofdelivery)t ");

            DataTable dtbirthsum = StockReports.GetDataTable(sb1.ToString());
            if (dtbirthsum != null && dtbirthsum.Rows.Count > 0)
            {
                lblsummary.Text = "Birth Summary";
                grdsummary.DataSource = dtbirthsum;
                grdsummary.DataBind();
            }
            else
            {
                lblsummary.Text = "";
                grdsummary.DataSource = null;
                grdsummary.DataBind();
            }
        }
        if (rbtnreport.SelectedValue == "1")
        {
            //sb.Append("  SELECT   'IPD'TYPE,mdm.DiseaseName 'Disease Name',COUNT(*)Quantity,YEAR(ich.DateOfDischarge)'Year of Discharge',DATE_FORMAT(ich.DateOfDischarge,'%b')'Month of Discharge'  ");
            //sb.Append("  FROM mrd_map_investigation_disease mmid  ");
            //sb.Append("  INNER JOIN mrd_disease_master mdm ON mmid.DiseaseID=mdm.DiseaseId ");
            //sb.Append("  INNER JOIN patient_medical_history ich ON mmid.TransactionID=ich.TransactionID  ");//ipd_case_history
            //sb.Append("  WHERE  DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND ich.CentreID IN (" + Centre + ") ");
            //sb.Append("  GROUP BY DATE(ich.DateOfDischarge),mmid.DiseaseID ");
            //sb.Append("   UNION ALL ");
            sb.Append("  SELECT ich.TYPE,mdm.DiseaseName'Disease Name',COUNT(*)Quantity, ");
            sb.Append("  YEAR(pli.Date)'Year of Disease', ");
            sb.Append("  DATE_FORMAT(pli.Date,'%b')'Month of Disease'     FROM mrd_map_investigation_disease mmid ");
            sb.Append("  INNER JOIN mrd_disease_master mdm ON mmid.DiseaseID=mdm.DiseaseId   ");
            sb.Append("  INNER JOIN  patient_labinvestigation_opd pli ON pli.TransactionID = mmid.TransactionID ");
            sb.Append("  INNER JOIN patient_medical_history ich ON mmid.TransactionID=ich.TransactionID  ");
            sb.Append("  WHERE pli.Investigation_ID = mmid.Investigation_ID  AND pli.Date>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND pli.Date<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pli.CentreID IN (" + Centre + ") ");
            sb.Append("  GROUP BY mmid.DiseaseID ");//DATE(pli.Date),

            DataTable dtNotifiable = StockReports.GetDataTable(sb.ToString());
            dtNotifiable.TableName = "dtNotifiable";

            if (dtNotifiable != null && dtNotifiable.Rows.Count > 0)
            {
                DataRow TotalRow = dtNotifiable.NewRow();
                TotalRow[0] = "Total";
                TotalRow["Quantity"] = dtNotifiable.Compute("sum(Quantity)", "");
                dtNotifiable.Rows.Add(TotalRow);

                lbldetail.Text = "Notifiable Diseases";
                grddetail.DataSource = dtNotifiable;
                grddetail.DataBind();

            }
            else
            {

                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);

            }
            grdsummary.DataSource = null;
            grdsummary.DataBind();
            lblsummary.Text = "";

        }
        if (rbtnreport.SelectedValue == "2")
        {
            sb.Append("  SELECT tm.Name Department,SUM(ltd.Quantity)Quantity     FROM f_ledgertransaction lt ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo ");
            sb.Append("  INNER JOIN f_itemmaster im ON ltd.Itemid=im.itemid INNER JOIN doctor_master dm ON im.Type_ID=dm.DoctorID ");
            sb.Append("  Inner join type_master tm ON tm.ID= dm.DocDepartmentID ");
            sb.Append("  WHERE lt.IsCancel=0 AND lt.TypeOfTnx='OPD-Appointment' AND ");
            sb.Append("  DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("  AND lt.CentreID IN (" + Centre + ") GROUP BY dm.DocDepartmentID  ORDER BY dm.DocDepartmentID ");
            DataTable dtopd = StockReports.GetDataTable(sb.ToString());
            dtopd.TableName = "dtopd";
            if (dtopd != null && dtopd.Rows.Count > 0)
            {
                DataRow TotalRow = dtopd.NewRow();
                TotalRow[0] = "Total";
                TotalRow["Quantity"] = dtopd.Compute("sum(Quantity)", "");
                dtopd.Rows.Add(TotalRow);
                lbldetail.Text = "OPD Consultation";
                grddetail.DataSource = dtopd;
                grddetail.DataBind();
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
            }
            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }

        if (rbtnreport.SelectedValue == "3")
        {
            sb.Append("  SELECT pmh.DischargeType 'Discharge Type',COUNT(*)'No. of Discharge' FROM patient_medical_history pmh  ");
            sb.Append("    WHERE pmh.Status <> 'Cancel' AND pmh.CentreID IN (" + Centre + ") AND  ");//INNER JOIN ipd_case_history ich ON pmh.TransactionID=ich.TransactionID
            sb.Append("  DATE(pmh.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND   ");
            sb.Append("  DATE(pmh.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' GROUP BY pmh.DischargeType ORDER BY  pmh.DischargeType  ");
            DataTable dtdis = StockReports.GetDataTable(sb.ToString());
            string Total = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM patient_medical_history ich where  ich.Status <> 'Cancel'  AND ich.CentreID IN (" + Centre + ") AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'   ");//ipd_case_history
            dtdis.TableName = "dtAd";
            if (dtdis != null && dtdis.Rows.Count > 0)
            {
                DataRow TotalRow = dtdis.NewRow();
                TotalRow[0] = "Total";
                TotalRow[1] = dtdis.Compute("SUM([No. of Discharge])", "");
                dtdis.Rows.Add(TotalRow);
                lbldetail.Text = "Discharge Type";
                grddetail.DataSource = dtdis;
                grddetail.DataBind();
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }

        if (rbtnreport.SelectedValue == "4")
        {
            sb.Append("  SELECT Investigation,round(SUM(OPD),0)OPD,ROUND(SUM(IPD),0)IPD FROM ( ");
            sb.Append("      SELECT   ");
            sb.Append("      (SELECT NAME FROM f_subcategorymaster WHERE SubCategoryID=ltd.SubCategoryID)Investigation, ");
            sb.Append("      IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),ltd.Quantity,0)OPD, ");
            sb.Append("      IF(lt.TypeOfTnx ='ipd-Lab',ltd.Quantity,0)IPD,ltd.TransactionID,lt.TypeOfTnx 	 ");
            sb.Append("      FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON  ");
            sb.Append("      lt.LedgerTransactionNo = ltd.LedgerTransactionNo INNER JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID INNER JOIN f_subcategorymaster sc ON  ");
            sb.Append("      sc.SubCategoryID = ltd.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ");
            sb.Append("      WHERE cf.ConfigID =3 ");
            sb.Append("      AND IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),lt.IsCancel=0,ltd.IsVerified=1) ");
            sb.Append("      AND IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "') ");
            sb.Append("      AND IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' )	 ");
            sb.Append("      AND  ltd.IsPackage=0 )t GROUP BY t.Investigation ");
            DataTable dtinv = StockReports.GetDataTable(sb.ToString());
            dtinv.TableName = "dtinv";
            if (dtinv != null && dtinv.Rows.Count > 0)
            {
                DataRow dr = dtinv.NewRow();
                decimal IpTotal = 0, OpTotal = 0;
                foreach (DataRow drnew in dtinv.Rows)
                {
                    IpTotal = IpTotal + Util.GetDecimal(drnew["IPD"].ToString());
                    OpTotal = OpTotal + Util.GetDecimal(drnew["OPD"].ToString());
                }
                dr["Investigation"] = "TOTAL";
                dr["IPD"] = Util.GetString(IpTotal);
                dr["OPD"] = Util.GetString(OpTotal);
                dtinv.Rows.Add(dr);
                dtinv.AcceptChanges();
                lbldetail.Text = "OPD-IPD Investigation";
                grddetail.DataSource = dtinv;
                grddetail.DataBind();
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }

        if (rbtnreport.SelectedValue == "5")
        {
            sb.Append("  SELECT IF(pmh.Type='IPD',pmh.Transno,'')'IPD No.',DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%y')'Date Of Admit',mlc_type 'MLC Type',pmh.MLC_NO 'MLC No.',dm.Name 'Doctor Name' FROM patient_medical_history pmh   ");
            sb.Append("  INNER JOIN doctor_master dm ON pmh.DoctorID=dm.DoctorID ");
            sb.Append("  WHERE IFNULL(pmh.MLC_NO,'') <> '' AND pmh.CentreID IN (" + Centre + ") AND DATE(pmh.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'  ");
            DataTable dtMLC = StockReports.GetDataTable(sb.ToString());
            dtMLC.TableName = "dtMLC";
            if (dtMLC != null && dtMLC.Rows.Count > 0)
            {
                lbldetail.Text = "MLC-Cases";
                grddetail.DataSource = dtMLC;
                grddetail.DataBind();
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }
        if (rbtnreport.SelectedValue == "6")
        {
            sb.Append("     SELECT T.MRNo 'UHID',T.IPNo 'IPD No.',T.PName 'Patient Name',T.Age,T.Gender 'Sex',T.DateOfAdmit 'Date of Admit', ");
            sb.Append("    T.DocName 'Doctor Name',T.Department,T.StayDays 'Stay Days',ictm.Name Ward,IF(IFNULL(T.timed,'0')=1,'Death Over 48 Hrs','Death Under 48 Hrs')TOD FROM (SELECT REPLACE(pm.PatientID,'LSHHI','')MRNo,IF(pmh.Type='IPD',pmh.Transno,'')IPNo, ");
            sb.Append("     pm.PName,pm.Age,pm.Gender,	 ");
            sb.Append("     DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%y')DateOfAdmit,IFNULL(DATE_FORMAT(pmh.TimeOfDeath,'%d-%b-%y'),'')DateOfDeath, ");
            sb.Append("     pmh.CauseOfDeath,(SELECT TypeOfDeath FROM typeofdeath WHERE ID=pmh.TypeOfDeathID)TypeOfDeath,dm.Name DocName, ");
            sb.Append("    dm.Designation AS Department      ");
            sb.Append("     ,(SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID ");
            sb.Append("     GROUP BY TransactionID)PatientIPDProfile_ID, ");
            sb.Append("     CONCAT( FLOOR(HOUR(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge), CONCAT(DateOfAdmit,' ',TimeOfAdmit))) / 24), ' days ',  ");
            sb.Append("     MOD(HOUR(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge), CONCAT(DateOfAdmit,' ',TimeOfAdmit))), 24), ' hours ',  ");
            sb.Append("     MINUTE(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge), CONCAT(DateOfAdmit,' ',TimeOfAdmit))), ' minutes')StayDays ");
            sb.Append("      ,pmh.IsDeathOver48HRS,((FLOOR(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge),CONCAT(DateOfAdmit,' ',TimeOfAdmit)))/10000)>48)timed         FROM patient_medical_history pmh      ");
            sb.Append("     INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN doctor_master dm      ");
            sb.Append("     ON pmh.DoctorID=dm.DoctorID  ");
            sb.Append("     WHERE UPPER(pmh.DischargeType)='DEATH' AND pmh.CentreID IN (" + Centre + ") AND DATE(pmh.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' )T ");
            sb.Append("     INNER JOIN patient_ipd_profile pip  ON pip.PatientIPDProfile_ID=t.PatientIPDProfile_ID ");
            sb.Append("     INNER JOIN ipd_case_type_master ictm ON pip.IPDCaseTypeID_Bill=ictm.IPDCaseTypeID ");
            DataTable dtdead = StockReports.GetDataTable(sb.ToString());
            string Total = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM patient_medical_history pmh where pmh.Status <> 'Cancel' AND UPPER(pmh.DischargeType)='Death' AND Type='IPD' and DATE(pmh.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(pmh.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.CentreID IN (" + Centre + ") ");
            dtdead.TableName = "dtdead";
            if (dtdead != null && dtdead.Rows.Count > 0)
            {
                DataRow dr = dtdead.NewRow();
                dr["IPD No."] = "TOTAL";
                dr["Patient Name"] = Util.GetString(Total);

                dr["Doctor Name"] = "";
                dr["Department"] = "";

                dtdead.Rows.Add(dr);
                dtdead.AcceptChanges();

                lbldetail.Text = "Death Case";
                grddetail.DataSource = dtdead;
                grddetail.DataBind();
            }
            else
            {

                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }

            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }
        if (rbtnreport.SelectedValue == "7")
        {
            sb.Append("  SELECT t.Department,SUM(CASE WHEN t.Type='ADMISSION' THEN t.No  ELSE 0 END)'No. of Admission', ");
            sb.Append("  SUM(CASE WHEN t.Type='DISCHARGE' THEN t.No  ELSE 0 END)'No. of Discharge' FROM(  ");
            sb.Append("  SELECT tm.Name Department,COUNT(*)NO,'ADMISSION' TYPE FROM patient_medical_history ich  ");
            sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID = ich.doctorid  ");
            sb.Append(" INNER JOIN Type_Master tm  ON tm.ID=dm.DocDepartmentID ");
            sb.Append("  WHERE ich.Status <> 'Cancel' AND ich.CentreID IN (" + Centre + ") ");
            sb.Append("  AND DATE(ich.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND   DATE(ich.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' GROUP BY dm.DocDepartmentID ");
            sb.Append("  UNION ALL  ");
            sb.Append("  SELECT tm.Name Department,COUNT(*)NO,'DISCHARGE' TYPE FROM patient_medical_history ich   ");
            sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID = ich.doctorid  ");
            sb.Append("  INNER JOIN Type_Master tm  ON tm.ID=dm.DocDepartmentID ");
            sb.Append("  WHERE ich.Status <> 'Cancel' AND ich.CentreID IN (" + Centre + ") ");
            sb.Append("  AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND   DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' GROUP BY dm.DocDepartmentID ");
            sb.Append("  )t GROUP BY t.Department ORDER BY t.Department ");
            DataTable dtAd = StockReports.GetDataTable(sb.ToString());
            string TotalAD = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM patient_medical_history ich where  ich.Status <> 'Cancel' AND ich.CentreID IN (" + Centre + ")  AND DATE(ich.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(ich.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'  ");
            string TotalDis = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM patient_medical_history ich where  ich.Status <> 'Cancel' AND ich.CentreID IN (" + Centre + ") AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            dtAd.TableName = "dtAd";
            if (dtAd != null && dtAd.Rows.Count > 0)
            {
                DataRow dr = dtAd.NewRow();
                dr["Department"] = "TOTAL";
                dr[1] = Util.GetString(TotalAD);
                dr[2] = Util.GetString(TotalDis); ;
                dtAd.Rows.Add(dr);
                dtAd.AcceptChanges();
                lbldetail.Text = "Department Wise Admission Discharge";
                grddetail.DataSource = dtAd;
                grddetail.DataBind();
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }

        if (rbtnreport.SelectedValue == "10")
        {
            sb.Append("  SELECT ProcedureName 'Procedure Name',SUM(MinorPro)'Minor Procedure',SUM(MajorPro)'Major Procedure','' Total FROM (  ");
            sb.Append("  SELECT   ");
            sb.Append("  IF(cf.ConfigID=25,(SELECT Typename FROM f_itemmaster WHERE ITemID=ltd.ItemID),ltd.SurgeryName) ProcedureName,  ");
            sb.Append("  IF(cf.ConfigID=25,1,0) MinorPro,IF(cf.ConfigID=22,1,0) MajorPro	 ");
            sb.Append("  FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON  ");
            sb.Append("  lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID INNER JOIN f_subcategorymaster sc ON  ");
            sb.Append("  sc.SubCategoryID = ltd.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID  ");
            sb.Append("  WHERE cf.ConfigID IN (22,25)  AND lt.CentreID IN (" + Centre + ") ");
            sb.Append("  AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),lt.IsCancel=0,ltd.IsVerified=1) ");
            sb.Append("  AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ) ");
            sb.Append("  AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ) ");
            sb.Append("  GROUP BY ltd.ledgertransactionNo ");
            sb.Append("  )t GROUP BY t.ProcedureName ");
            DataTable dtsur = StockReports.GetDataTable(sb.ToString());
            dtsur.TableName = "dtsur";
            if (dtsur.Rows.Count > 0)
            {
                DataRow dr = dtsur.NewRow();
                decimal Major = 0, Minor = 0;
                foreach (DataRow drnew in dtsur.Rows)
                {
                    drnew["Total"] = Util.GetString(Util.GetDecimal(drnew[2].ToString()) + Util.GetDecimal(drnew[1].ToString()));
                    Major = Major + Util.GetDecimal(drnew[2].ToString());
                    Minor = Minor + Util.GetDecimal(drnew[1].ToString());
                }
                dr[0] = "TOTAL";
                dr[2] = Util.GetString(Major);
                dr[1] = Util.GetString(Minor);
                dr["Total"] = Util.GetString(Major + Minor);
                dtsur.Rows.Add(dr);
                dtsur.AcceptChanges();
                if (dtsur != null && dtsur.Rows.Count > 0)
                {
                    lbldetail.Text = "Major Minor Surgeries";
                    grddetail.DataSource = dtsur;
                    grddetail.DataBind();
                }
                else
                {
                    lbldetail.Text = "";
                    grddetail.DataSource = null;
                    grddetail.DataBind();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
                }
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }
        if (rbtnreport.SelectedValue == "12")
        {
            sb.Append(" SELECT DeptName 'Department Name',SUM(MajorPro)'Major Procedure' ");
            sb.Append("   FROM ( ");
            sb.Append(" SELECT   sm.Department DeptName,IF(cf.ConfigID=22,1,0) MajorPro	   ");
            sb.Append(" FROM f_ledgertnxdetail ltd  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON    lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON    sc.SubCategoryID = ltd.SubCategoryID ");
            sb.Append(" INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ");
            sb.Append(" INNER JOIN f_surgery_master sm ON sm.Surgery_ID=ltd.SurgeryID    ");
            sb.Append(" WHERE cf.ConfigID IN (22)    AND IF((lt.TypeOfTnx !='IPD Surgery'),lt.IsCancel=0,ltd.IsVerified=1)   ");
            sb.Append(" AND IF((lt.TypeOfTnx !='IPD Surgery'),DATE(lt.Date)<='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "', DATE(adj.BillDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' )   ");
            sb.Append(" GROUP BY ltd.SurgeryID ");
            sb.Append(" )t GROUP BY t.DeptName ");
            DataTable dtsur = StockReports.GetDataTable(sb.ToString());
            dtsur.TableName = "dtsur";
            if (dtsur.Rows.Count > 0)
            {
                DataRow dr = dtsur.NewRow();
                decimal Major = 0;

                foreach (DataRow drnew in dtsur.Rows)
                {
                    Major = Major + Util.GetDecimal(drnew[1].ToString());
                }
                dr[0] = "Total";
                dr[1] = Util.GetString(Major);
                dtsur.Rows.Add(dr);
                dtsur.AcceptChanges();
                if (dtsur != null && dtsur.Rows.Count > 0)
                {
                    lbldetail.Text = "Major Surgeries Department Wise";
                    grddetail.DataSource = dtsur;
                    grddetail.DataBind();
                }
                else
                {
                    lbldetail.Text = "";
                    grddetail.DataSource = null;
                    grddetail.DataBind();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
                }
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }
        if (rbtnreport.SelectedValue == "11")
        {
            sb.Append(" SELECT DATE_FORMAT(DATE,'%d-%b-%y')DATE,Pname 'Patient Name' ,Age,Gender,Address,DName 'Doctor Name',Father, ");
            sb.Append("  Mobile,phone,Broughtby 'Brought by',cause_Of_Death 'Cause of Death' FROM mrd_broughtby where DATE(DATE)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(DATE)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            DataTable dtmrdbroughtby = StockReports.GetDataTable(sb.ToString());
            if (dtmrdbroughtby != null && dtmrdbroughtby.Rows.Count > 0)
            {
                lbldetail.Text = "Mrd Brought By";
                grddetail.DataSource = dtmrdbroughtby;
                grddetail.DataBind();
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }
        if (rbtnreport.SelectedValue == "13")
        {
            sb.Append("SELECT (SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=t.DoctorID)DoctorName,t.itemName 'Surgeon Type',COUNT(REPLACE(sm.Surgery_ID,'LSHHI',''))Total ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT  ltd.ItemName,sur.SurgeryTransactionID,surdoc.DoctorID,ltd.SurgeryName,(ltd.Rate*ltd.Quantity)GrossAmt,ltd.Amount, ");
            sb.Append(" IF(ltd.discountpercentage >0,((ltd.Rate*ltd.Quantity)-ltd.Amount),0)Disc,ltd.EntryDate, ");
            sb.Append(" lt.LedgerTransactionNo,ltd.SurgeryID,lt.PatientID,lt.TransactionID, ");
            sb.Append("                adj.BillNo,adj.BillDate,ltd.IsPackage ");
            sb.Append("                FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON ");
            sb.Append("                lt.LedgerTransactionNo = ltd.LedgerTransactionNo INNER JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID");
            sb.Append("                INNER JOIN f_surgery_discription sur ON ltd.LedgerTransactionNO=sur.LedgerTransactionNO AND ltd.itemid=sur.ItemID ");
            sb.Append("              INNER JOIN f_surgery_doctor surdoc ON sur.SurgeryTransactionID=surdoc.SurgeryTransactionID ");
            sb.Append("                WHERE ISSurgery=1 AND IsVerified=1 AND (adj.BillNo IS NOT NULL AND adj.billNo <> '') AND adj.CentreID IN (" + Centre + ") ");
            sb.Append("                AND DATE(adj.BillDate) >= '" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.BillDate) <= '" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("           )T INNER JOIN f_surgery_master sm ON t.SurgeryID = sm.Surgery_ID ");
            sb.Append("           INNER JOIN patient_master pm ON pm.PatientID = t.PatientID ");
            sb.Append("           GROUP BY t.SurgeryTransactionID ");
            sb.Append("           ORDER BY sm.Name,sm.Department ");
            DataTable dtsur = StockReports.GetDataTable(sb.ToString());
            dtsur.TableName = "dtsur";
            if (dtsur.Rows.Count > 0)
            {
                DataRow dr = dtsur.NewRow();
                decimal Major = 0;
                foreach (DataRow drnew in dtsur.Rows)
                {
                    Major = Major + Util.GetDecimal(drnew[2].ToString());
                }
                dr[1] = "Total";
                dr[2] = Util.GetString(Major);
                dtsur.Rows.Add(dr);
                dtsur.AcceptChanges();
                if (dtsur != null && dtsur.Rows.Count > 0)
                {
                    lbldetail.Text = "Major Surgeries Doctor Wise";
                    grddetail.DataSource = dtsur;
                    grddetail.DataBind();
                }
                else
                {
                    lbldetail.Text = "";
                    grddetail.DataSource = null;
                    grddetail.DataBind();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
                }
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
            lblsummary.Text = "";
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }
        if (rbtnreport.SelectedValue == "14")
        {
            sb.Append("  SELECT DATE_FORMAT(t0.EntryDate,'%d-%b-%Y')Month_days,IFNULL(t2.EntryQty,'0') 'No Of Regisration',t0.EntryQty 'No Of NewPatient',t1.entryQty 'No Of OldPatient',  ");
            sb.Append("   (t0.EntryQty+t1.entryQty) 'Total Attendance'   ");
            sb.Append("  FROM (SELECT Entrydate,COUNT(EntryQty)EntryQty FROM  ");
            sb.Append("  ( SELECT DATE Entrydate, COUNT(*)EntryQty FROM appointment  ");
            sb.Append("  WHERE  DATE>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND VisitType='New Patient' AND CentreID IN (" + Centre + ") GROUP BY DATE,PatientID)t  ");
            sb.Append("  GROUP BY Entrydate)t0  ");
            sb.Append("  LEFT JOIN ( SELECT Entrydate,COUNT(EntryQty)EntryQty FROM  ");
            sb.Append("  ( SELECT DATE Entrydate, COUNT(*)EntryQty FROM appointment  ");
            sb.Append("  WHERE  DATE>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND VisitType='Old Patient' AND CentreID IN (" + Centre + ") GROUP BY DATE,PatientID)t  ");
            sb.Append("  GROUP BY Entrydate)t1 ON t1.EntryDate=t0.EntryDate   ");
            sb.Append("  LEFT JOIN  (SELECT DATE(DateEnrolled)EntryDate,COUNT(*)EntryQty  ");
            sb.Append("  FROM patient_master WHERE DATE(DateEnrolled)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND (DateEnrolled)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND CentreID IN (" + Centre + ") GROUP BY  DATE(DateEnrolled) )t2 ON t2.EntryDate=t0.EntryDate ");

            DataTable dtopd = StockReports.GetDataTable(sb.ToString());
            if (dtopd != null && dtopd.Rows.Count > 0)
            {
                lbldetail.Text = "Date Wise Attendance";
                grddetail.DataSource = dtopd;
                grddetail.DataBind();
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
        }
        else
        {
            lbldetail.Text = "";
        }
        lblsummary.Text = "";
    }

    protected void btnexcel_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        if (rbtnreport.SelectedValue == "9")
        {
            sb.Append("SELECT t.TotalFuncBed,t1.TotalAdmits,t.TotalFuncBed*(IF(DATEDIFF('" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "')=0,1,DATEDIFF('" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "')))AvailableBedDays, ");
            sb.Append("t2.TotalDischarged,t3.PatientDays,t4.TotalDeaths, ");
            sb.Append("t5.TotalBirth,t5.BirthFeMale,t5.BirthMale,t5.LSCS,t5.NVD,t6.MajorPro,t6.MinorPro,t7.OPD_Patients, ");
            sb.Append("t8.Total_MLC,t8.RTA,t8.Poisoining,t8.Burns,t8.Hanging,t8.Assaults,t9.DeathUnder48Hrs,t10.DeathOver48Hrs FROM ( ");
            sb.Append("     SELECT COUNT(RoomID)TotalFuncBed FROM ipd_case_type_master icm  ");
            sb.Append("     INNER JOIN room_master rm ON icm.IPDCaseTypeID = rm.IPDCaseTypeID ");
            sb.Append("     WHERE icm.IsActive=1 AND rm.IsActive=1  and rm.IsCountable=1 ");
            sb.Append(" )t, (");
            sb.Append("     SELECT COUNT(TransactionID)TotalAdmits FROM patient_medical_history ");
            sb.Append("     WHERE DATE(DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(DateOfAdmit) <='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("     AND UCASE(STATUS) <>'CANCEL' AND CentreID IN (" + Centre + ") ");
            sb.Append(" )t1,(");
            sb.Append("     SELECT COUNT(TransactionID)TotalDischarged FROM patient_medical_history ");
            sb.Append("     WHERE DATE(DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("     AND UCASE(STATUS) <>'CANCEL' AND CentreID IN (" + Centre + ") ");
            sb.Append(" )t2,( ");
            sb.Append("     SELECT COUNT(TransactionID)PatientDays FROM patient_ipd_profile pip INNER JOIN  ( ");
            sb.Append("         SELECT * FROM temp_for_date WHERE DATE(dt)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(dt)<= '" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("     ) tfd WHERE UCASE(pip.Status)<>'CANCEL' AND CONCAT(pip.StartDate,' ',pip.StartTime )  <= CONCAT(tfd.dt,' ','23:59:59') ");
            sb.Append("    AND  IF(STATUS='IN',CONCAT(CURDATE(),' ','23:59:59'), CONCAT(PIP.EndDate,' ',pip.EndTime)) >= CONCAT(tfd.dt,' ','23:59:59') AND pip.CentreID IN (" + Centre + ")");
            sb.Append(")t3,( ");
            sb.Append("    SELECT COUNT(pmh.TransactionID)TotalDeaths ");
            sb.Append("    FROM patient_medical_history pmh  ");
            sb.Append("    WHERE UCASE(pmh.DischargeType)='Death' ");
            sb.Append("    AND UCASE(pmh.Status)<>'CANCEL' ");
            sb.Append("    AND IF(Year(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("    AND IF(Month(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.CentreID IN (" + Centre + ") ");
            sb.Append(")t4,( ");
            sb.Append("     SELECT SUM(t.Total)TotalBirth, SUM(CASE WHEN UPPER(Gender)='FEMALE' THEN t.Total ELSE 0 END) BirthFeMale, ");
            sb.Append("     SUM(CASE WHEN UPPER(Gender)='MALE' THEN t.Total ELSE 0 END )BirthMale , ");
            sb.Append("     SUM(CASE WHEN UPPER(typeofdelivery)='LSCS' THEN t.Total ELSE 0 END )LSCS, ");
            sb.Append("     SUM(CASE WHEN UPPER(typeofdelivery)='NVD' THEN t.Total ELSE 0 END )NVD ");
            sb.Append("     FROM ( ");
            sb.Append("         SELECT COUNT(*)Total,pm.Gender,pmh.typeofdelivery FROM patient_medical_history pmh  ");
            sb.Append("         INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
            sb.Append("         WHERE pm.title='B/O' AND pmh.status<>'Cancel' ");
            sb.Append("         AND TRIM(REPLACE(pm.Age,'DAYS(S)','')) IN ('0','1') ");
            sb.Append("         AND DATE(pm.DateEnrolled)=DATE(pmh.DateOfAdmit) ");
            sb.Append("         AND DATE(pmh.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("         AND DATE(pmh.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.CentreID IN (" + Centre + ") GROUP BY pm.Gender,pmh.typeofdelivery ");
            sb.Append("     )t ");
            sb.Append(")t5,( ");
            sb.Append("    SELECT SUM(MajorPro)MajorPro,SUM(MinorPro)MinorPro FROM ( ");
            sb.Append("        SELECT ");
            sb.Append("        IF(cf.ConfigID=25,1,0) MinorPro,IF(cf.ConfigID=22,1,0) MajorPro ");
            sb.Append("        FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON ");
            sb.Append("        lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID INNER JOIN f_subcategorymaster sc ON ");
            sb.Append("        sc.SubCategoryID = ltd.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ");
            sb.Append("        WHERE cf.ConfigID IN (22,25) AND lt.CentreID IN (" + Centre + ") ");
            sb.Append("        AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),lt.IsCancel=0,ltd.IsVerified=1) ");
            sb.Append("        AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ) ");
            sb.Append("        AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ) ");
            sb.Append("        GROUP BY ltd.ledgertransactionNo ");
            sb.Append("    )t ");
            sb.Append(")t6,( ");
            sb.Append("    SELECT COUNT(lt.PatientID)OPD_Patients FROM f_ledgertransaction lt INNER JOIN patient_master pm ON ");
            sb.Append("    lt.TypeOfTnx ='OPD-Appointment' AND  pm.PatientID = lt.PatientID ");
            sb.Append("    WHERE  ");
            sb.Append("    DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND lt.CentreID IN (" + Centre + ") ");
            sb.Append(")t7,( ");
            sb.Append("    SELECT COUNT(TransactionID)Total_MLC, ");
            sb.Append(" IFNULL(SUM(IF(UCASE(mlc_type)='RTA',1,0)),0)RTA, ");
            sb.Append(" IFNULL(SUM(IF((mlc_type)='Poisoining',1,0)),0)Poisoining, ");
            sb.Append(" IFNULL(SUM(IF((mlc_type)='Burns',1,0)),0)Burns, ");
            sb.Append(" IFNULL(SUM(IF((mlc_type)='Hanging',1,0)),0)Hanging,      ");
            sb.Append(" IFNULL(SUM(IF((mlc_type)='Assaults',1,0)),0)Assaults ");
            sb.Append("    FROM patient_medical_history WHERE IFNULL(Admission_Type,'') = 'MLC CASE' AND TYPE='IPD' AND CentreID IN (" + Centre + ") ");
            sb.Append("    AND DATE(DateOfVisit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(DateOfVisit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append(")t8,( ");
            sb.Append("    SELECT COUNT(pmh.TransactionID)DeathUnder48Hrs ");
            sb.Append("    FROM patient_medical_history pmh ");
            sb.Append("    WHERE UCASE(pmh.DischargeType)='Death' AND pmh.IsDeathOver48HRS=0 ");
            sb.Append("    AND UCASE(pmh.Status)<>'CANCEL' ");
            sb.Append("    AND IF(Year(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("    AND IF(Month(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.CentreID IN (" + Centre + ") ");
            sb.Append(")t9, ( ");
            sb.Append("    SELECT COUNT(pmh.TransactionID)DeathOver48Hrs ");
            sb.Append("    FROM patient_medical_history pmh ");
            sb.Append("    WHERE UCASE(pmh.DischargeType)='Death' AND ifnull(pmh.IsDeathOver48HRS,'0')=1 ");
            sb.Append("    AND UCASE(pmh.Status)<>'CANCEL' ");
            sb.Append("    AND IF(Year(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("    AND IF(Month(pmh.TimeOfDeath) ='0001' OR pmh.TimeOfDeath IS NULL ,DATE(pmh.DateOfDischarge),DATE(pmh.TimeOfDeath))<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.CentreID IN (" + Centre + ") ");
            sb.Append(")t10 ");
            DataTable dtStat = StockReports.GetDataTable(sb.ToString());
            if (dtStat != null && dtStat.Rows.Count > 0)
            {
                DataTable dtModified = new DataTable();
                dtModified.Columns.Add("S.No.", typeof(string));
                dtModified.Columns.Add("Particulars", typeof(string));
                dtModified.Columns.Add("Status", typeof(decimal));
                dtModified = MapStatistics(dtModified, dtStat);
                Session["dtExport2Excel"] = dtModified;
                Session["ReportName"] = "Statitics";
                Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            }
            else
            {
                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }


        }
        if (rbtnreport.SelectedValue == "8")
        {
            sb.Append("     SELECT IF(t.Type='IPD',t.TransNo,'') AS 'Baby IPD No.',t.DOB 'D.O.B.',t.Gender 'Sex',t.Status,t.DocName 'Doctor Name',  ");
            sb.Append("     t.TypeofDelivery 'Type of Delivery',t.DeliveryWeeks 'Delivery Weeks Days',t.FatherName 'Father Name',t.BirthIgnoreReason 'Birth Ignore Reason'       ");
            sb.Append("     FROM (   SELECT IF(UPPER(pm.Relation)='FATHER',pm.RelationName,'')fatherName,pmh.DeliveryWeeks,pmh.typeofdelivery,pm.TimeOfBirth,pm.Weight,pm.gender,IF(pm.dob='0001-01-01',pm.age,pm.dob)DOB,  ");
            sb.Append("      pmh.TransactionID,dm.Name DocName,      ");
            sb.Append("     pmh.status,IFNULL(pmh.BirthIgnoreReason,'')BirthIgnoreReason,pmh.Type,pmh.TransNo   FROM patient_medical_history pmh   ");
            sb.Append("     INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN doctor_master dm      ");
            sb.Append("     ON pmh.DoctorID=dm.DoctorID WHERE pmh.MotherTID<>'' AND pmh.status<>'Cancel' AND pmh.CentreID IN (" + Centre + ") AND DATE(pmh.DateofAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "'   ");
            sb.Append("     AND  DATE(pmh.DateofAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "')t  ");
            DataTable dtbirthdtl = StockReports.GetDataTable(sb.ToString());
            StringBuilder sb1 = new StringBuilder();
            sb1.Append("  SELECT SUM(CASE WHEN UPPER(Gender)='FEMALE' THEN t.Total ELSE 0 END) Female, ");
            sb1.Append("  SUM(CASE WHEN UPPER(Gender)='MALE' THEN t.Total ELSE 0 END )Male ");
            sb1.Append("  ,SUM(CASE WHEN UPPER(typeofdelivery)='LSCS' THEN t.Total ELSE 0 END )LSCS, ");
            sb1.Append("  SUM(CASE WHEN UPPER(typeofdelivery)='NVD' THEN t.Total ELSE 0 END )NVD ");
            sb1.Append("   FROM ( ");
            sb1.Append("  SELECT COUNT(*)Total,pm.Gender,pmh.typeofdelivery FROM patient_medical_history pmh  ");
            sb1.Append("  INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
            sb1.Append("  WHERE pmh.MotherTID<>'' AND pmh.status<>'Cancel' AND pmh.CentreID IN (" + Centre + ") and DATE(pmh.DateofAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.DateofAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' GROUP BY pm.Gender,pmh.typeofdelivery)t ");
            DataTable dtbirthsum = StockReports.GetDataTable(sb1.ToString());
            if (dtbirthdtl != null && dtbirthdtl.Rows.Count > 0)
            {
                lbldetail.Text = "Birth Details";
                Session["dtExport2Excel"] = dtbirthdtl;
                Session["ReportName"] = "Birth Details";
                Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");

                if (dtbirthsum != null && dtbirthsum.Rows.Count > 0)
                {
                    Session["dtExport2Excel1"] = dtbirthsum;
                    Session["ReportName1"] = "Birth Summary";
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            }
            else
            {

                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }

        }
        if (rbtnreport.SelectedValue == "1")
        {
            //sb.Append("  SELECT   'IPD'TYPE,mdm.DiseaseName 'Disease Name',COUNT(*)Quantity,YEAR(ich.DateOfDischarge)'Year of Discharge',DATE_FORMAT(ich.DateOfDischarge,'%b')'Month of Discharge'  ");
            //sb.Append("  FROM mrd_map_investigation_disease mmid  ");
            //sb.Append("  INNER JOIN mrd_disease_master mdm ON mmid.DiseaseID=mdm.DiseaseId ");
            //sb.Append("  INNER JOIN ipd_case_history ich ON mmid.TransactionID=ich.TransactionID  ");
            //sb.Append("  WHERE  DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND ich.CentreID IN (" + Centre + ") ");
            //sb.Append("  GROUP BY DATE(ich.DateOfDischarge),mmid.DiseaseID ");
            //sb.Append("   UNION ALL ");
            sb.Append("  SELECT ich.TYPE,mdm.DiseaseName'Disease Name',COUNT(*)Quantity, ");
            sb.Append("  YEAR(pli.Date)'Year of Disease', ");
            sb.Append("  DATE_FORMAT(pli.Date,'%b')'Month of Disease'     FROM mrd_map_investigation_disease mmid ");
            sb.Append("  INNER JOIN mrd_disease_master mdm ON mmid.DiseaseID=mdm.DiseaseId   ");
            sb.Append("  INNER JOIN  patient_labinvestigation_opd pli ON pli.TransactionID = mmid.TransactionID ");
            sb.Append("  INNER JOIN patient_medical_history ich ON mmid.TransactionID=ich.TransactionID  ");
            sb.Append("  WHERE pli.Investigation_ID = mmid.Investigation_ID  AND pli.Date>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND pli.Date<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pli.CentreID IN (" + Centre + ") ");
            sb.Append("  GROUP BY mmid.DiseaseID ");// DATE(pli.Date),

            DataTable dtNotifiable = StockReports.GetDataTable(sb.ToString());
            dtNotifiable.TableName = "dtNotifiable";

            if (dtNotifiable != null && dtNotifiable.Rows.Count > 0)
            {
                DataRow TotalRow = dtNotifiable.NewRow();
                TotalRow[0] = "Total";
                TotalRow["Quantity"] = dtNotifiable.Compute("sum(Quantity)", "");
                dtNotifiable.Rows.Add(TotalRow);
                Session["dtExport2Excel"] = dtNotifiable;
                Session["ReportName"] = "Notifiable Diseases";
                Session["Period"] = "From" + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {
                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }


        }
        if (rbtnreport.SelectedValue == "14")
        {
            sb.Append("  SELECT DATE_FORMAT(t0.EntryDate,'%d-%b-%Y')Month_days,IFNULL(t2.EntryQty,'0') 'No Of Regisration',t0.EntryQty 'No Of NewPatient',t1.entryQty 'No Of OldPatient',  ");
            sb.Append("   (t0.EntryQty+t1.entryQty) 'Total Attendance'   ");
            sb.Append("  FROM (SELECT Entrydate,COUNT(EntryQty)EntryQty FROM  ");
            sb.Append("  ( SELECT DATE Entrydate, COUNT(*)EntryQty FROM appointment  ");
            sb.Append("  WHERE  DATE>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND VisitType='New Patient' AND CentreID IN (" + Centre + ") GROUP BY DATE,PatientID)t  ");
            sb.Append("  GROUP BY Entrydate)t0  ");
            sb.Append("  LEFT JOIN ( SELECT Entrydate,COUNT(EntryQty)EntryQty FROM  ");
            sb.Append("  ( SELECT DATE Entrydate, COUNT(*)EntryQty FROM appointment  ");
            sb.Append("  WHERE  DATE>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND VisitType='Old Patient' AND CentreID IN (" + Centre + ") GROUP BY DATE,PatientID)t  ");
            sb.Append("  GROUP BY Entrydate)t1 ON t1.EntryDate=t0.EntryDate   ");
            sb.Append("  LEFT JOIN  (SELECT DATE(DateEnrolled)EntryDate,COUNT(*)EntryQty  ");
            sb.Append("  FROM patient_master WHERE DATE(DateEnrolled)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND (DateEnrolled)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND CentreID IN (" + Centre + ") GROUP BY  DATE(DateEnrolled) )t2 ON t2.EntryDate=t0.EntryDate ");
            DataTable dtopd = StockReports.GetDataTable(sb.ToString());
            dtopd.TableName = "dtopd";
            if (dtopd != null && dtopd.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = dtopd;
                Session["ReportName"] = "OPD Consultation";
                Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {
                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
        }
        if (rbtnreport.SelectedValue == "2")
        {
            sb.Append("  SELECT tm.Name Department,SUM(ltd.Quantity)Quantity     FROM f_ledgertransaction lt ");
            sb.Append("  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo ");
            sb.Append("  INNER JOIN f_itemmaster im ON ltd.Itemid=im.itemid INNER JOIN doctor_master dm ON im.Type_ID=dm.DoctorID ");
            sb.Append("  Inner join type_master tm ON tm.ID= dm.DocDepartmentID ");
            sb.Append("  WHERE lt.IsCancel=0 AND lt.TypeOfTnx='OPD-Appointment' AND ");
            sb.Append("  DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("  AND lt.CentreID IN (" + Centre + ") GROUP BY dm.DocDepartmentID  ORDER BY dm.DocDepartmentID ");
            DataTable dtopd = StockReports.GetDataTable(sb.ToString());
            dtopd.TableName = "dtopd";
            if (dtopd != null && dtopd.Rows.Count > 0)
            {
                DataRow TotalRow = dtopd.NewRow();
                TotalRow[0] = "Total";
                TotalRow["Quantity"] = dtopd.Compute("sum(Quantity)", "");
                dtopd.Rows.Add(TotalRow);

                Session["dtExport2Excel"] = dtopd;
                Session["ReportName"] = "OPD Consultation";
                Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {
                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
        }

        if (rbtnreport.SelectedValue == "3")
        {
            sb.Append("  SELECT pmh.DischargeType 'Discharge Type',COUNT(*)'No. of Discharge' FROM patient_medical_history pmh  ");
            sb.Append("  WHERE pmh.Status <> 'Cancel' AND pmh.CentreID IN (" + Centre + ") AND  ");
            sb.Append("  DATE(pmh.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND   ");
            sb.Append("  DATE(pmh.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' GROUP BY pmh.DischargeType ORDER BY  pmh.DischargeType  ");
            DataTable dtdis = StockReports.GetDataTable(sb.ToString());
            string Total = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM patient_medical_history ich where  ich.Status <> 'Cancel'  AND ich.CentreID IN (" + Centre + ") AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'   ");
            dtdis.TableName = "dtAd";

            if (dtdis != null && dtdis.Rows.Count > 0)
            {
                DataRow TotalRow = dtdis.NewRow();
                TotalRow[0] = "Total";
                TotalRow[1] = dtdis.Compute("sum([No. of Discharge])", "");
                dtdis.Rows.Add(TotalRow);
                Session["dtExport2Excel"] = dtdis;
                Session["ReportName"] = "Discharge Type";
                Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {
                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }

        }

        if (rbtnreport.SelectedValue == "4")
        {
            sb.Append("  SELECT Investigation,SUM(OPD)OPD,SUM(IPD)IPD FROM ( ");
            sb.Append("      SELECT   ");
            sb.Append("      (SELECT NAME FROM f_subcategorymaster WHERE SubCategoryID=ltd.SubCategoryID)Investigation, ");
            sb.Append("      IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),ltd.Quantity,0)OPD, ");
            sb.Append("      IF(lt.TypeOfTnx ='ipd-Lab',ltd.Quantity,0)IPD,ltd.TransactionID,lt.TypeOfTnx 	 ");
            sb.Append("      FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON  ");
            sb.Append("      lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID INNER JOIN f_subcategorymaster sc ON  ");
            sb.Append("      sc.SubCategoryID = ltd.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ");
            sb.Append("      WHERE cf.ConfigID =3 ");
            sb.Append("      AND IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),lt.IsCancel=0,ltd.IsVerified=1) ");
            sb.Append("      AND IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "') ");
            sb.Append("      AND IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' )	 ");
            sb.Append("      AND  ltd.IsPackage=0 )t GROUP BY t.Investigation ");
            DataTable dtinv = StockReports.GetDataTable(sb.ToString());
            dtinv.TableName = "dtinv";
            if (dtinv != null && dtinv.Rows.Count > 0)
            {
                DataRow dr = dtinv.NewRow();
                decimal IpTotal = 0, OpTotal = 0;
                foreach (DataRow drnew in dtinv.Rows)
                {
                    IpTotal = IpTotal + Util.GetDecimal(drnew["IPD"].ToString());
                    OpTotal = OpTotal + Util.GetDecimal(drnew["OPD"].ToString());
                }
                dr["Investigation"] = "TOTAL";
                dr["IPD"] = Util.GetString(IpTotal);
                dr["OPD"] = Util.GetString(OpTotal);
                dtinv.Rows.Add(dr);
                dtinv.AcceptChanges();
                Session["dtExport2Excel"] = dtinv;
                Session["ReportName"] = "OPD-IPD Investigation";
                Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {
                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
        }

        if (rbtnreport.SelectedValue == "5")
        {
            sb.Append("  SELECT IF(pmh.Type='IPD',pmh.Transno,'')'IPD No.',DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%y')'Date Of Admit',mlc_type 'MLC Type',pmh.MLC_NO 'MLC No.',dm.Name 'Doctor Name' FROM patient_medical_history pmh  ");
            sb.Append("  INNER JOIN doctor_master dm ON pmh.DoctorID=dm.DoctorID ");
            sb.Append("  WHERE IFNULL(pmh.MLC_NO,'') <> '' AND pmh.CentreID IN (" + Centre + ") AND DATE(pmh.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'  ");
            DataTable dtMLC = StockReports.GetDataTable(sb.ToString());
            dtMLC.TableName = "dtMLC";
            if (dtMLC.Rows.Count > 0)
            {
                sb = new StringBuilder();
                sb.Append("  SELECT dm.Name DocName,COUNT(*)Total FROM patient_medical_history pmh ");
                sb.Append("  INNER JOIN doctor_master dm ON pmh.DoctorID=dm.DoctorID  ");
                sb.Append("  WHERE IFNULL(pmh.Acc_MLCNO,'') <> '' AND pmh.CentreID IN (" + Centre + ") AND DATE(pmh.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'  ");
                sb.Append("  GROUP BY pmh.DoctorID ");
                DataTable dtSumMLC = StockReports.GetDataTable(sb.ToString());
                dtSumMLC.TableName = "dtSumMLC";
                if (dtMLC != null && dtMLC.Rows.Count > 0)
                {
                    Session["dtExport2Excel"] = dtMLC;
                    Session["ReportName"] = "MLC-Cases";
                    Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                    if (dtSumMLC != null && dtSumMLC.Rows.Count > 0)
                    {
                        Session["dtExport2Excel1"] = dtSumMLC;
                        Session["ReportName1"] = "MLC Summary";
                    }
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                }
                else
                {
                    lblMsg.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
                }
            }
        }
        if (rbtnreport.SelectedValue == "6")
        {
            sb.Append("     SELECT T.MRNo 'UHID',T.IPNo 'IPD No.',T.PName 'Patient Name',T.Age,T.Gender 'Sex',T.DateOfAdmit 'Date of Admit', ");
            sb.Append("    T.DocName 'Doctor Name',T.Department,T.StayDays 'Stay Days',ictm.Name Ward,IF(IFNULL(T.timed,'0')=1,'Death Over 48 Hrs','Death Under 48 Hrs')TOD FROM (SELECT REPLACE(pm.PatientID,'LSHHI','')MRNo,IF(pmh.Type='IPD',pmh.Transno,'')IPNo, ");
            sb.Append("     pm.PName,pm.Age,pm.Gender,	 ");
            sb.Append("     DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%y')DateOfAdmit,IFNULL(DATE_FORMAT(pmh.TimeOfDeath,'%d-%b-%y'),'')DateOfDeath, ");
            sb.Append("     pmh.CauseOfDeath,(SELECT TypeOfDeath FROM typeofdeath WHERE ID=pmh.TypeOfDeathID)TypeOfDeath,dm.Name DocName, ");
            sb.Append("    dm.Designation AS Department      ");
            sb.Append("     ,(SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID ");
            sb.Append("     GROUP BY TransactionID)PatientIPDProfile_ID, ");
            sb.Append("     CONCAT( FLOOR(HOUR(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge), CONCAT(DateOfAdmit,' ',TimeOfAdmit))) / 24), ' days ',  ");
            sb.Append("     MOD(HOUR(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge), CONCAT(DateOfAdmit,' ',TimeOfAdmit))), 24), ' hours ',  ");
            sb.Append("     MINUTE(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge), CONCAT(DateOfAdmit,' ',TimeOfAdmit))), ' minutes')StayDays ");
            sb.Append("      ,pmh.IsDeathOver48HRS,((FLOOR(TIMEDIFF(CONCAT(DateOfDischarge,' ',TimeOfDischarge),CONCAT(DateOfAdmit,' ',TimeOfAdmit)))/10000)>48)timed         FROM patient_medical_history pmh      ");
            sb.Append("     INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN doctor_master dm      ");
            sb.Append("     ON pmh.DoctorID=dm.DoctorID  ");
            sb.Append("     WHERE UPPER(pmh.DischargeType)='DEATH' AND pmh.CentreID IN (" + Centre + ") AND DATE(pmh.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(pmh.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' )T ");
            sb.Append("     INNER JOIN patient_ipd_profile pip  ON pip.PatientIPDProfile_ID=t.PatientIPDProfile_ID ");
            sb.Append("     INNER JOIN ipd_case_type_master ictm ON pip.IPDCaseTypeID_Bill=ictm.IPDCaseTypeID ");
            DataTable dtdead = StockReports.GetDataTable(sb.ToString());
            string Total = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM patient_medical_history pmh   where  UPPER(pmh.DischargeType)='EXPIRED' AND Type='IPD' and DATE(pmh.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(pmh.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.CentreID IN (" + Centre + ") ");
            dtdead.TableName = "dtdead";
            if (dtdead != null && dtdead.Rows.Count > 0)
            {
                DataRow dr = dtdead.NewRow();
                dr["IPD No."] = "TOTAL";
                dr["Patient Name"] = Util.GetString(Total);
                //dr["Date of Death"] = "";
                dr["Doctor Name"] = "";
                dr["Department"] = "";

                dtdead.Rows.Add(dr);
                dtdead.AcceptChanges();

                Session["dtExport2Excel"] = dtdead;
                Session["ReportName"] = "Death Case";
                Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {
                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }
        }
        if (rbtnreport.SelectedValue == "7")
        {
            sb.Append("  SELECT t.Department,SUM(CASE WHEN t.Type='ADMISSION' THEN t.No  ELSE 0 END)'No. of Admission', ");
            sb.Append("  SUM(CASE WHEN t.Type='DISCHARGE' THEN t.No  ELSE 0 END)'No. of Discharge' FROM(  ");
            sb.Append("  SELECT tm.Name Department,COUNT(*)NO,'ADMISSION' TYPE FROM patient_medical_history ich  ");
            sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID = ich.DoctorID  ");
            sb.Append(" INNER JOIN Type_Master tm  ON tm.ID=dm.DocDepartmentID ");
            sb.Append("  WHERE ich.Status <> 'Cancel' AND ich.CentreID IN (" + Centre + ") ");
            sb.Append("  AND DATE(ich.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND   DATE(ich.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' GROUP BY dm.DocDepartmentID ");
            sb.Append("  UNION ALL  ");
            sb.Append("  SELECT tm.Name Department,COUNT(*)NO,'DISCHARGE' TYPE FROM patient_medical_history ich   ");
            sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID = ich.DoctorID  ");
            sb.Append("  INNER JOIN Type_Master tm  ON tm.ID=dm.DocDepartmentID ");
            sb.Append("  WHERE ich.Status <> 'Cancel' AND ich.CentreID IN (" + Centre + ") ");
            sb.Append("  AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND   DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' GROUP BY dm.DocDepartmentID ");
            sb.Append("  )t GROUP BY t.Department ORDER BY t.Department ");
            DataTable dtAd = StockReports.GetDataTable(sb.ToString());
            string TotalAD = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM patient_medical_history ich where  ich.Status <> 'Cancel' AND ich.CentreID IN (" + Centre + ") AND DATE(ich.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(ich.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'  ");
            string TotalDis = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM patient_medical_history ich where  ich.Status <> 'Cancel' AND ich.CentreID IN (" + Centre + ") AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            dtAd.TableName = "dtAd";
            if (dtAd != null && dtAd.Rows.Count > 0)
            {
                DataRow dr = dtAd.NewRow();
                dr["Department"] = "TOTAL";
                dr["No. of Admission"] = Util.GetString(TotalAD);
                dr["No. of Discharge"] = Util.GetString(TotalDis); ;
                dtAd.Rows.Add(dr);
                dtAd.AcceptChanges();
                Session["dtExport2Excel"] = dtAd;
                Session["ReportName"] = "Department Wise Admission & Discharge";
                Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {

                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            }

        }

        if (rbtnreport.SelectedValue == "10")
        {
            sb.Append("  SELECT ProcedureName 'Procedure Name',SUM(MinorPro)'Minor Procedure',SUM(MajorPro)'Major Procedure','' Total FROM (  ");
            sb.Append("  SELECT   ");
            sb.Append("  IF(cf.ConfigID=25,(SELECT Typename FROM f_itemmaster WHERE ITemID=ltd.ItemID),ltd.SurgeryName) ProcedureName,  ");
            sb.Append("  IF(cf.ConfigID=25,1,0) MinorPro,IF(cf.ConfigID=22,1,0) MajorPro	 ");
            sb.Append("  FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON  ");
            sb.Append("  lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID INNER JOIN f_subcategorymaster sc ON  ");
            sb.Append("  sc.SubCategoryID = ltd.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID  ");
            sb.Append("  WHERE cf.ConfigID IN (22,25)  AND lt.CentreID IN (" + Centre + ") ");
            sb.Append("  AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),lt.IsCancel=0,ltd.IsVerified=1) ");
            sb.Append("  AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' ) ");
            sb.Append("  AND IF((lt.TypeOfTnx ='opd-procedure' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "',DATE(adj.BillDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ) ");
            sb.Append("  GROUP BY ltd.ledgertransactionNo ");
            sb.Append("  )t GROUP BY t.ProcedureName ");
            DataTable dtsur = StockReports.GetDataTable(sb.ToString());
            dtsur.TableName = "dtsur";
            if (dtsur.Rows.Count > 0)
            {
                DataRow dr = dtsur.NewRow();
                decimal Major = 0, Minor = 0;

                foreach (DataRow drnew in dtsur.Rows)
                {
                    drnew["Total"] = Util.GetString(Util.GetDecimal(drnew[1].ToString()) + Util.GetDecimal(drnew[2].ToString()));
                    Major = Major + Util.GetDecimal(drnew[2].ToString());
                    Minor = Minor + Util.GetDecimal(drnew[1].ToString());
                }

                dr[0] = "TOTAL";
                dr[2] = Util.GetString(Major);
                dr[1] = Util.GetString(Minor);
                dr["Total"] = Util.GetString(Major + Minor);
                dtsur.Rows.Add(dr);
                dtsur.AcceptChanges();


                if (dtsur != null && dtsur.Rows.Count > 0)
                {
                    Session["dtExport2Excel"] = dtsur;
                    Session["ReportName"] = "Major Minor Surgeries";
                    Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                }
                else
                {
                    lblMsg.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                }
            }
        }
        if (rbtnreport.SelectedValue == "12")
        {
            sb.Append(" SELECT DeptName 'Department Name',SUM(MajorPro)'Major Procedure' ");
            sb.Append("   FROM ( ");
            sb.Append(" SELECT   sm.Department DeptName,IF(cf.ConfigID=22,1,0) MajorPro	   ");
            sb.Append(" FROM f_ledgertnxdetail ltd  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON    lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON    sc.SubCategoryID = ltd.SubCategoryID ");
            sb.Append(" INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ");
            sb.Append(" INNER JOIN f_surgery_master sm ON sm.Surgery_ID=ltd.SurgeryID    ");
            sb.Append(" WHERE cf.ConfigID IN (22)    AND IF((lt.TypeOfTnx !='IPD Surgery'),lt.IsCancel=0,ltd.IsVerified=1)   ");
            sb.Append(" AND IF((lt.TypeOfTnx !='IPD Surgery'),DATE(lt.Date)<='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "', DATE(adj.BillDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' )   ");
            sb.Append(" GROUP BY ltd.SurgeryID ");
            sb.Append(" )t GROUP BY t.DeptName ");
            DataTable dtsur = StockReports.GetDataTable(sb.ToString());
            dtsur.TableName = "dtsur";
            if (dtsur.Rows.Count > 0)
            {
                DataRow dr = dtsur.NewRow();
                decimal Major = 0;

                foreach (DataRow drnew in dtsur.Rows)
                {
                    Major = Major + Util.GetDecimal(drnew[1].ToString());
                }
                dr[0] = "Total";
                dr[1] = Util.GetString(Major);
                dtsur.Rows.Add(dr);
                dtsur.AcceptChanges();
                if (dtsur != null && dtsur.Rows.Count > 0)
                {
                    Session["dtExport2Excel"] = dtsur;
                    Session["ReportName"] = "Major Surgeries";
                    Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                }
                else
                {
                    lblMsg.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
                }
            }
        }
        if (rbtnreport.SelectedValue == "13")
        {
            sb.Append("SELECT (SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=t.DoctorID)DoctorName,t.itemName 'Surgeon Type',COUNT(REPLACE(sm.Surgery_ID,'LSHHI',''))Total ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT  ltd.ItemName,sur.SurgeryTransactionID,surdoc.DoctorID,ltd.SurgeryName,(ltd.Rate*ltd.Quantity)GrossAmt,ltd.Amount, ");
            sb.Append(" IF(ltd.discountpercentage >0,((ltd.Rate*ltd.Quantity)-ltd.Amount),0)Disc,ltd.EntryDate, ");
            sb.Append(" lt.LedgerTransactionNo,ltd.SurgeryID,lt.PatientID,lt.TransactionID, ");
            sb.Append("                adj.BillNo,adj.BillDate,ltd.IsPackage ");
            sb.Append("                FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON ");
            sb.Append("                lt.LedgerTransactionNo = ltd.LedgerTransactionNo INNER JOIN patient_medical_history adj ON adj.TransactionID=lt.TransactionID");
            sb.Append("                INNER JOIN f_surgery_discription sur ON ltd.LedgerTransactionNO=sur.LedgerTransactionNO AND ltd.itemid=sur.ItemID ");
            sb.Append("              INNER JOIN f_surgery_doctor surdoc ON sur.SurgeryTransactionID=surdoc.SurgeryTransactionID ");
            sb.Append("                WHERE ISSurgery=1 AND IsVerified=1 AND (adj.BillNo IS NOT NULL AND adj.billNo <> '') AND adj.CentreID IN (" + Centre + ") ");
            sb.Append("                AND DATE(adj.BillDate) >= '" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(adj.BillDate) <= '" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("           )T INNER JOIN f_surgery_master sm ON t.SurgeryID = sm.Surgery_ID ");
            sb.Append("           INNER JOIN patient_master pm ON pm.PatientID = t.PatientID ");
            sb.Append("           GROUP BY t.SurgeryTransactionID ");
            sb.Append("           ORDER BY sm.Name,sm.Department ");

            DataTable dtsur = StockReports.GetDataTable(sb.ToString());
            dtsur.TableName = "dtsur";
            if (dtsur.Rows.Count > 0)
            {
                DataRow dr = dtsur.NewRow();
                decimal Major = 0;

                foreach (DataRow drnew in dtsur.Rows)
                {
                    Major = Major + Util.GetDecimal(drnew[2].ToString());
                }
                dr[1] = "Total";
                dr[2] = Util.GetString(Major);
                dtsur.Rows.Add(dr);
                dtsur.AcceptChanges();
                if (dtsur != null && dtsur.Rows.Count > 0)
                {
                    Session["dtExport2Excel"] = dtsur;
                    Session["ReportName"] = "Major Surgeries";
                    Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                }
                else
                {
                    lblMsg.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
                }
            }
        }
        if (rbtnreport.SelectedValue == "11")
        {
            sb.Append(" SELECT DATE_FORMAT(DATE,'%d-%b-%y')DATE,Pname 'Patient Name' ,Age,Gender,Address,DName 'Doctor Name',Father, ");
            sb.Append("  Mobile,phone,Broughtby 'Brought by',cause_Of_Death 'Cause of Death' FROM mrd_broughtby where DATE(DATE)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(DATE)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");

            DataTable dtmrdbroughtby = StockReports.GetDataTable(sb.ToString());

            if (dtmrdbroughtby != null && dtmrdbroughtby.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = dtmrdbroughtby;
                Session["ReportName"] = "MRD Brought By";
                Session["Period"] = "From " + Util.GetDateTime(ucDateFrom.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {
                lbldetail.Text = "";
                grddetail.DataSource = null;
                grddetail.DataBind();
            }
            grdsummary.DataSource = null;
            grdsummary.DataBind();
        }
    }

    private DataTable MapStatistics(DataTable dtMod, DataTable dtStat)
    {
        foreach (DataColumn dc in dtStat.Columns)
        {
            DataRow dr = dtMod.NewRow();
            try
            {
                switch (dc.ColumnName)
                {
                    case "TotalFuncBed":

                        dr[0] = "1";
                        dr[1] = "Total Functional Bed";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0][dc]);
                        dtMod.Rows.Add(dr);
                        break;

                    case "TotalAdmits":
                        dr[0] = "2";
                        dr[1] = "Total Patient Admitted";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0][dc]);
                        dtMod.Rows.Add(dr);
                        break;

                    case "AvailableBedDays":

                        dr[0] = "3";
                        dr[1] = "Available Bed Days";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0][dc]);
                        dtMod.Rows.Add(dr);
                        break;

                    case "TotalDischarged":

                        dr[0] = "4";
                        dr[1] = "Total Patient Discharged";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0][dc]);
                        dtMod.Rows.Add(dr);
                        break;

                    case "PatientDays":

                        dr[0] = "5";
                        dr[1] = "Patient Days";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0][dc]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "a.  Average Length of Stay   (E/D)";

                        dr[2] = Math.Round(Util.GetDecimal(dtStat.Rows[0]["PatientDays"]) / Util.GetDecimal(dtStat.Rows[0]["TotalDischarged"]), 2);

                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "b.  Bed Occupancy Rate   (E/C)*100";
                        dr[2] = Math.Round((Util.GetDecimal(dtStat.Rows[0]["PatientDays"]) / Util.GetDecimal(dtStat.Rows[0]["AvailableBedDays"])) * 100, 2);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "c.  Bed TurnOver Rate  (D/A)";
                        dr[2] = Math.Round(Util.GetDecimal(dtStat.Rows[0]["TotalDischarged"]) / Util.GetDecimal(dtStat.Rows[0]["TotalFuncBed"]), 2);
                        dtMod.Rows.Add(dr);
                        break;


                    case "TotalDeaths":

                        dr[0] = "6";
                        dr[1] = "Total Deaths in Hospital";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0][dc]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[0] = "7";
                        dr[1] = "  - Death Under 48 Hours";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["DeathUnder48Hrs"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[0] = "8";
                        dr[1] = "  - Death Over 48 Hours";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["DeathOver48Hrs"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "a.  Hospital Death Rate   (F/D)*100";
                        dr[2] = Math.Round((Util.GetDecimal(dtStat.Rows[0]["TotalDeaths"]) / Util.GetDecimal(dtStat.Rows[0]["TotalDischarged"])) * 100, 2);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "b.  Net Death Rate (((F-G)/(F+D)) - G)*100 ";

                        Decimal F = Util.GetDecimal(dtStat.Rows[0]["TotalDeaths"]);
                        Decimal G = Util.GetDecimal(dtStat.Rows[0]["DeathUnder48Hrs"]);
                        Decimal D = Util.GetDecimal(dtStat.Rows[0]["TotalDischarged"]);

                        dr[2] = Math.Round((((F - G) / (F + D)) - G) * 100, 2);
                        dtMod.Rows.Add(dr);
                        break;

                    case "TotalBirth":

                        dr[0] = "9";
                        dr[1] = "Total Births in Hospital";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0][dc]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - Male Births";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["BirthMale"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - Female Births";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["BirthFeMale"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - LSCS";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["LSCS"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - NVD";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["NVD"]);
                        dtMod.Rows.Add(dr);

                        //dr = dtMod.NewRow();
                        //dr[1] = "  - IUD";
                        //dr[2] = Util.GetDecimal(dtStat.Rows[0]["IUD"]);
                        //dtMod.Rows.Add(dr);

                        break;

                    case "MajorPro":

                        dr[0] = "10";
                        dr[1] = "Surgeries/Procedures : ";
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - Major Procedure";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["MajorPro"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - Minor Procedure";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["MinorPro"]);
                        dtMod.Rows.Add(dr);

                        break;

                    case "OPD_Patients":

                        dr[0] = "11";
                        dr[1] = "OPD Patients : ";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["OPD_Patients"]);
                        dtMod.Rows.Add(dr);
                        break;


                    case "Total_MLC":

                        dr[0] = "12";
                        dr[1] = "Total MLC : ";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["Total_MLC"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - RTA";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["RTA"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - Poisoining";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["Poisoining"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - Burns";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["Burns"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - Hanging";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["Hanging"]);
                        dtMod.Rows.Add(dr);

                        dr = dtMod.NewRow();
                        dr[1] = "  - Assaults";
                        dr[2] = Util.GetDecimal(dtStat.Rows[0]["Assaults"]);
                        dtMod.Rows.Add(dr);
                       
                        break;


                    default:
                        break;
                }
            }
            catch (Exception ex)
            {
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }
        }

        return dtMod;

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        btnExportConsult.Visible = true;
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT dm.Name,SUM(ltd.Quantity)Quantity     FROM f_ledgertransaction lt   INNER JOIN f_ledgertnxdetail ltd  ");
        sb.Append("   ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo   INNER JOIN f_itemmaster im ON ltd.Itemid=im.itemid  ");
        sb.Append("   INNER JOIN doctor_master dm ON im.Type_ID=dm.DoctorID   WHERE lt.IsCancel=0 AND lt.TypeOfTnx='OPD-Appointment' AND   ");
        sb.Append("   DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND dm.Specialization='" + txtDesc.Text.ToString() + "' GROUP BY dm.DoctorID  ORDER BY dm.Name ");
        DataTable dtopd = StockReports.GetDataTable(sb.ToString());
        dtopd.TableName = "dtopd";
        if (dtopd != null && dtopd.Rows.Count > 0)
        {
            DataRow TotalRow = dtopd.NewRow();
            TotalRow[0] = "Total";
            TotalRow["Quantity"] = dtopd.Compute("sum(Quantity)", "");
            dtopd.Rows.Add(TotalRow);
            lbldetail.Text = "OPD Consultation";
            grddetailnew.DataSource = dtopd;
            grddetailnew.DataBind();
            mpeconsultation.Show();
            lblsummary.Text = "";
        }
        else
        {
            lbldetail.Text = "";
            grddetailnew.DataSource = null;
            grddetailnew.DataBind();
        }
    }

    protected void btnDescDischarge_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT REPLACE(t.PatientID,'LSHHI','')MRNo,REPLACE(t.TransactionID,'ISHHI','')IPNo,t.PatientName Name,t.Age,t.sex,t.Panel,DATE_FORMAT(t.DateOfAdmit,'%d-%b-%y')DOA,TIME_FORMAT(t.TimeOfAdmit,'%H:%i:%s')TOA,DATE_FORMAT(t.DateOfDischarge,'%d-%b-%y')DOD,TIME_FORMAT(t.TimeOfDischarge,'%H:%i:%s')TOD,t.Doctor,t.Diagnosis,ictm.Name RoomType,CONCAT(rm.Name,'/',rm.Floor,'/',rm.Bed_No)Room FROM (  ");
        sb.Append("  SELECT pm.PName PatientName,pm.Age,pm.Gender sex,(SELECT Company_Name FROM f_panel_master WHERE PanelID=pmh.PanelID)panel,ich.DateOfAdmit,ich.TimeOfAdmit,ich.DateOfDischarge,ich.TimeOfDischarge,  ");
        sb.Append("  (SELECT NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)Doctor,(SELECT Diagnosis FROM diagnosis_master WHERE DiagnosisID=pmh.DiagnosisID)Diagnosis,  ");
        sb.Append("  (SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID  ");
        sb.Append("  GROUP BY TransactionID)PatientIPDProfile_ID,pm.PatientID,pmh.TransactionID  FROM patient_medical_history pmh    INNER JOIN ipd_case_history ich ON  ");
        sb.Append("  pmh.TransactionID=ich.TransactionID INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID  ");
        sb.Append("  WHERE ich.Status <> 'Cancel' AND    DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND     ");
        sb.Append("  DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.DischargeType='" + txtDesc.Text.ToString() + "')t  ");
        sb.Append("  INNER JOIN patient_ipd_profile pip  ON pip.PatientIPDProfile_ID=t.PatientIPDProfile_ID   ");
        sb.Append("  INNER JOIN ipd_case_type_master ictm ON pip.IPDCaseType_ID_Bill=ictm.IPDCaseType_ID   ");
        sb.Append("  INNER JOIN room_master rm ON pip.Room_ID=rm.Room_Id  ");
        sb.Append("  ORDER BY  t.PatientName  ");


        DataTable dtopd = StockReports.GetDataTable(sb.ToString());
        dtopd.TableName = "dtopd";


        if (dtopd != null && dtopd.Rows.Count > 0)
        {
            
            //DataRow TotalRow = dtopd.NewRow();
            // TotalRow[0] = "Total";
            //TotalRow["Quantity"] = dtopd.Compute("sum(Quantity)", "");
            // dtopd.Rows.Add(TotalRow);


            //lbldetail.Text = "OPD Consultation";
            btnExportDisDetail.Visible = true;
            grdDescdisc.DataSource = dtopd;
            grdDescdisc.DataBind();




        }
        else
        {

            lbldetail.Text = "";
            grdDescdisc.DataSource = null;
            grdDescdisc.DataBind();

        }
        mpedicharge.Show();
        lblsummary.Text = "";
    }

    protected void btnExportConsult_Click(object sender, EventArgs e)
    {


        StringBuilder sb = new StringBuilder();



        sb.Append("   SELECT dm.Name,SUM(ltd.Quantity)Quantity     FROM f_ledgertransaction lt   INNER JOIN f_ledgertnxdetail ltd  ");
        sb.Append("   ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo   INNER JOIN f_itemmaster im ON ltd.Itemid=im.itemid  ");
        sb.Append("   INNER JOIN doctor_master dm ON im.Type_ID=dm.DoctorID   WHERE lt.IsCancel=0 AND lt.TypeOfTnx='OPD-Appointment' AND   ");
        sb.Append("   DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND dm.Specialization='" + txtDesc.Text.ToString() + "' GROUP BY dm.DoctorID  ORDER BY dm.Name ");




        DataTable dtopd = StockReports.GetDataTable(sb.ToString());
        dtopd.TableName = "dtopd";





        if (dtopd != null && dtopd.Rows.Count > 0)
        {
          ;
            DataRow TotalRow = dtopd.NewRow();
            TotalRow[0] = "Total";
            TotalRow["Quantity"] = dtopd.Compute("sum(Quantity)", "");
            dtopd.Rows.Add(TotalRow);

            Session["dtExport2Excel"] = dtopd;
            Session["ReportName"] = "OPD Consultation";
            Session["Period"] = "From" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('ExportToExcel.aspx');", true);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);




        }
        else
        {

            lblMsg.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            mpeconsultation.Show();
        }
    }

    protected void btnDescDoc_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT dm.Name Doctor,REPLACE(pm.PatientID,'LSHHI','')MRNo,pm.PName,pm.Age,CONCAT(pm.Mobile,'/',pm.Phone)MOB,CONCAT(pm.Country,'/',pm.City,'/',pm.House_No)Address ");
        sb.Append("   FROM f_ledgertransaction lt   INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
        sb.Append("   INNER JOIN patient_master pm ON lt.PatientID=pm.PatientID");
        sb.Append("   INNER JOIN f_itemmaster im ON ltd.Itemid=im.itemid ");
        sb.Append("   INNER JOIN doctor_master dm ON im.Type_ID=dm.DoctorID   WHERE lt.IsCancel=0 AND lt.TypeOfTnx='OPD-Appointment' AND   ");
        sb.Append("   DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND dm.Name='" + txtDescDoc.Text.ToString() + "'  ORDER BY pm.PName  ");


        DataTable dtopd = StockReports.GetDataTable(sb.ToString());
        dtopd.TableName = "dtopd";


        if (dtopd != null && dtopd.Rows.Count > 0)
        {
            btnExportConsultdtl.Visible = true;
         
            grddetailnewdtl.DataSource = dtopd;
            grddetailnewdtl.DataBind();

            //mpedicharge.Show();
            lblsummary.Text = "";
            mpeconsultation.Show();
            mpeconsultationdtl.Show();

        }
        else
        {

            lbldetail.Text = "";
            grddetailnewdtl.DataSource = null;
            grddetailnewdtl.DataBind();

            //mpedicharge.Show();
            lblsummary.Text = "";
            mpeconsultation.Show();

        }


    }

    protected void btnExportConsultdtl_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT dm.Name Doctor,REPLACE(pm.PatientID,'LSHHI','')MRNo,pm.PName,pm.Age,CONCAT(pm.Mobile,'/',pm.Phone)MOB,CONCAT(pm.Country,'/',pm.City,'/',pm.House_No)Address ");
        sb.Append("   FROM f_ledgertransaction lt   INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
        sb.Append("   INNER JOIN patient_master pm ON lt.PatientID=pm.PatientID");
        sb.Append("   INNER JOIN f_itemmaster im ON ltd.Itemid=im.itemid ");
        sb.Append("   INNER JOIN doctor_master dm ON im.Type_ID=dm.DoctorID   WHERE lt.IsCancel=0 AND lt.TypeOfTnx='OPD-Appointment' AND   ");
        sb.Append("   DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND dm.Name='" + txtDescDoc.Text.ToString() + "'  ORDER BY pm.PName  ");


        DataTable dtopd = StockReports.GetDataTable(sb.ToString());
        dtopd.TableName = "dtopd";


        if (dtopd != null && dtopd.Rows.Count > 0)
        {


            Session["dtExport2Excel"] = dtopd;
            Session["ReportName"] = "OPD Consultation";
            Session["Period"] = "From" + ucDateFrom.Text + " To " + ucDateTo.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('ExportToExcel.aspx');", true);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);




        }
        else
        {

            lblMsg.Visible = true;
            //lblMsg.Text = "No Record Found";
            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Not Record Found',function(){});", true);
            mpeconsultation.Show();
        }
    }

    protected void btnDescSpeciality_Click(object sender, EventArgs e)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT t.Name,SUM(CASE WHEN t.Type='ADMISSION' THEN t.No  ELSE 0 END)NoOFAdmission, ");
        sb.Append("  SUM(CASE WHEN t.Type='DISCHARGE' THEN t.No  ELSE 0 END)NoOFDischarge FROM(    SELECT dm.Name,COUNT(*)NO,'ADMISSION' TYPE  ");
        sb.Append("  FROM ipd_case_history ich    INNER JOIN doctor_master dm ON dm.DoctorID = ich.Consultant_ID    WHERE ich.Status <> 'Cancel'  ");
        sb.Append("  AND DATE(ich.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND   DATE(ich.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND dm.Specialization='" + txtDescSpeciality.Text.ToString() + "' GROUP BY dm.Name     ");
        sb.Append("  UNION ALL     ");
        sb.Append("  SELECT dm.Name,COUNT(*)NO,'DISCHARGE' TYPE FROM ipd_case_history ich     INNER JOIN doctor_master dm ON  ");
        sb.Append("  dm.DoctorID = ich.Consultant_ID    WHERE ich.Status <> 'Cancel'   AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND    ");
        sb.Append("  DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'  AND dm.Specialization='" + txtDescSpeciality.Text.ToString() + "' GROUP BY dm.Name   )t GROUP BY t.Name   ORDER BY t.Name  ");

        DataTable dtAd = StockReports.GetDataTable(sb.ToString());


        //  string TotalAD = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM ipd_case_history ich where  ich.Status <> 'Cancel' AND DATE(ich.DateOfAdmit)>='" + ucDateFrom.Text + "' AND DATE(ich.DateOfAdmit)<='" + ucDateTo.Text + "'  ");
        //  string TotalDis = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM ipd_case_history ich where  ich.Status <> 'Cancel' AND DATE(ich.DateOfDischarge)>='" + ucDateFrom.Text + "' AND DATE(ich.DateOfDischarge)<='" + ucDateTo.Text + "' ");
        dtAd.TableName = "dtAd";



        if (dtAd != null && dtAd.Rows.Count > 0)
        {
            btnExportSpeciality.Visible = true;
            grddetailSpeciality.DataSource = dtAd;
            grddetailSpeciality.DataBind();
            //foreach (GridViewRow gr in grddetailSpeciality.Rows)
            //{
            //    gr.Attributes.Add("ondblclick", "loadDescSpecailitydtl('" + gr.Cells[0].Text + "');");
            //}

            mpeSpeciality.Show();



        }
        else
        {

            lbldetail.Text = "";
            grddetailSpeciality.DataSource = null;
            grddetailSpeciality.DataBind();
        }


    }
    protected void btnExportSpeciality_Click(object sender, EventArgs e)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT t.Name,SUM(CASE WHEN t.Type='ADMISSION' THEN t.No  ELSE 0 END)NoOFAdmission, ");
        sb.Append("  SUM(CASE WHEN t.Type='DISCHARGE' THEN t.No  ELSE 0 END)NoOFDischarge FROM(    SELECT dm.Name,COUNT(*)NO,'ADMISSION' TYPE  ");
        sb.Append("  FROM ipd_case_history ich    INNER JOIN doctor_master dm ON dm.DoctorID = ich.Consultant_ID    WHERE ich.Status <> 'Cancel'  ");
        sb.Append("  AND DATE(ich.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND   DATE(ich.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND dm.Specialization='" + txtDescSpeciality.Text.ToString() + "' GROUP BY dm.Name     ");
        sb.Append("  UNION ALL     ");
        sb.Append("  SELECT dm.Name,COUNT(*)NO,'DISCHARGE' TYPE FROM ipd_case_history ich     INNER JOIN doctor_master dm ON  ");
        sb.Append("  dm.DoctorID = ich.Consultant_ID    WHERE ich.Status <> 'Cancel'   AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND    ");
        sb.Append("  DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'  AND dm.Specialization='" + txtDescSpeciality.Text.ToString() + "' GROUP BY dm.Name   )t GROUP BY t.Name   ORDER BY t.Name  ");

        DataTable dtAd = StockReports.GetDataTable(sb.ToString());


        //  string TotalAD = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM ipd_case_history ich where  ich.Status <> 'Cancel' AND DATE(ich.DateOfAdmit)>='" + ucDateFrom.Text + "' AND DATE(ich.DateOfAdmit)<='" + ucDateTo.Text + "'  ");
        //  string TotalDis = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM ipd_case_history ich where  ich.Status <> 'Cancel' AND DATE(ich.DateOfDischarge)>='" + ucDateFrom.Text + "' AND DATE(ich.DateOfDischarge)<='" + ucDateTo.Text + "' ");
        dtAd.TableName = "dtAd";



        if (dtAd != null && dtAd.Rows.Count > 0)
        {

            Session["dtExport2Excel"] = dtAd;
            Session["ReportName"] = "OPD Consultation";
            Session["Period"] = "From" + ucDateFrom.Text + " To " + ucDateTo.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('ExportToExcel.aspx');", true);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

            mpeSpeciality.Show();


        }
        else
        {

            lbldetail.Text = "";
            grddetailSpeciality.DataSource = null;
            grddetailSpeciality.DataBind();
            // mpeSpeciality.Show();
        }

    }
    protected void btnDescSpecialitydtl_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("     SELECT t.* FROM(SELECT 'ADMISSION' TYPE,REPLACE(pmh.PatientID,'LSHHI','')MRNo,REPLACE(pmh.TransactionID,'ISHHI','')IPNo,pm.PName,pm.Age, ");
        sb.Append("    CONCAT(pm.Mobile,'/',pm.Phone)MOB,CONCAT(pm.Country,'/',pm.City,'/',pm.House_No)Address  FROM ipd_case_history ich INNER JOIN patient_medical_history pmh ON ich.TransactionID=pmh.TransactionID      ");
        sb.Append("    INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN doctor_master dm ON dm.DoctorID = ich.Consultant_ID    WHERE ich.Status <> 'Cancel'     ");
        sb.Append("    AND DATE(ich.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND   DATE(ich.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND dm.Name='" + txtDescSpecialitydtl.Text.ToString() + "'         ");
        sb.Append("    UNION ALL       SELECT 'DISCHARGE' TYPE,REPLACE(pmh.PatientID,'LSHHI','')MRNo,REPLACE(pmh.TransactionID,'ISHHI','')IPNo,pm.PName,pm.Age, ");
        sb.Append("    CONCAT(pm.Mobile,'/',pm.Phone)MOB,CONCAT(pm.Country,'/',pm.City,'/',pm.House_No)Address FROM ipd_case_history ich INNER JOIN patient_medical_history pmh ON ich.TransactionID=pmh.TransactionID      ");
        sb.Append("    INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN doctor_master dm ON dm.DoctorID = ich.Consultant_ID     WHERE ich.Status <> 'Cancel'   AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND       ");
        sb.Append("    DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'  AND dm.Name='" + txtDescSpecialitydtl.Text.ToString() + "'  )t  ORDER BY t.TYPE  ");


        DataTable dtAd = StockReports.GetDataTable(sb.ToString());


        //  string TotalAD = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM ipd_case_history ich where  ich.Status <> 'Cancel' AND DATE(ich.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(ich.DateOfAdmit)<='" + ucDateTo.Text + "'  ");
        //  string TotalDis = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM ipd_case_history ich where  ich.Status <> 'Cancel' AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(ich.DateOfDischarge)<='" + ucDateTo.Text + "' ");
        dtAd.TableName = "dtAd";



        if (dtAd != null && dtAd.Rows.Count > 0)
        {
            btnExportSpecialitydtl.Visible = true;
            grddetailSpecialitydtl.DataSource = dtAd;
            grddetailSpecialitydtl.DataBind();


            mpeSpeciality.Show();
            mpeSpecialitydtl.Show();


        }
        else
        {

            lbldetail.Text = "";
            grddetailSpecialitydtl.DataSource = null;
            grddetailSpecialitydtl.DataBind();
            mpeSpeciality.Show();
        }
    }

    protected void btnDescInvest_Click(object sender, EventArgs e)
    {

        StringBuilder sb = new StringBuilder();




        sb.Append("  SELECT Investigation,OPD,IPD FROM ( ");
        sb.Append("      SELECT   ");
        sb.Append("      ltd.ItemName Investigation, ");
        sb.Append("      IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),ltd.Quantity,0)OPD, ");
        sb.Append("      IF(lt.TypeOfTnx ='ipd-Lab',ltd.Quantity,0)IPD,ltd.TransactionID,lt.TypeOfTnx 	 ");
        sb.Append("      FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON  ");
        sb.Append("      lt.LedgerTransactionNo = ltd.LedgerTransactionNo INNER JOIN f_subcategorymaster sc ON  ");
        sb.Append("      sc.SubCategoryID = ltd.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ");
        sb.Append("      WHERE cf.ConfigRelationID =3 ");
        sb.Append("      AND IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),lt.IsCancel=0,ltd.IsVerified=1) ");
        sb.Append("      AND IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "',DATE(lt.BillDate)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "') ");
        sb.Append("      AND IF((lt.TypeOfTnx ='opd-Lab' OR lt.TypeOfTnx ='IPD Surgery'),DATE(lt.Date)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "',DATE(lt.BillDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' )	 ");
        sb.Append("  AND (LT.BillNo IS NOT NULL) AND LT.billNo <> '' AND  ltd.IsPackage=0 )t  ");

        DataTable dtinv = StockReports.GetDataTable(sb.ToString());


        //string Total = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM ipd_case_history ich where  ich.Status <> 'Cancel'  AND ich.Status='OUT' AND YEAR(ich.DateOfAdmit)='" + ddlyear.SelectedItem.Value.ToString().Trim() + "' AND MONTH(ich.DateOfAdmit)='" + ddlMonth.SelectedItem.Value.ToString().Trim() + "'   ");
        dtinv.TableName = "dtinv";



        if (dtinv != null && dtinv.Rows.Count > 0)
        {



            lbldetail.Text = "Discharge Type";
            grddetailInvest.DataSource = dtinv;
            grddetailInvest.DataBind();

            mpeInvest.Show();


        }
        else
        {

            lbldetail.Text = "";
            grddetailInvest.DataSource = null;
            grddetailInvest.DataBind();
        }

    }


    protected void btnExportDisDetail_Click(object sender, EventArgs e)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT REPLACE(t.PatientID,'LSHHI','')MRNo,REPLACE(t.TransactionID,'ISHHI','')IPNo,t.PatientName Name,t.Age,t.sex,t.Panel,DATE_FORMAT(t.DateOfAdmit,'%d-%b-%y')DOA,TIME_FORMAT(t.TimeOfAdmit,'%H:%i:%s')TOA,DATE_FORMAT(t.DateOfDischarge,'%d-%b-%y')DOD,TIME_FORMAT(t.TimeOfDischarge,'%H:%i:%s')TOD,t.Doctor,t.Diagnosis,ictm.Name RoomType,CONCAT(rm.Name,'/',rm.Floor,'/',rm.Bed_No)Room FROM (  ");
        sb.Append("  SELECT pm.PName PatientName,pm.Age,pm.Gender sex,(SELECT Company_Name FROM f_panel_master WHERE PanelID=pmh.PanelID)panel,ich.DateOfAdmit,ich.TimeOfAdmit,ich.DateOfDischarge,ich.TimeOfDischarge,  ");
        sb.Append("  (SELECT NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)Doctor,(SELECT Diagnosis FROM diagnosis_master WHERE DiagnosisID=pmh.DiagnosisID)Diagnosis,  ");
        sb.Append("  (SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID  ");
        sb.Append("  GROUP BY TransactionID)PatientIPDProfile_ID,pm.PatientID,pmh.TransactionID  FROM patient_medical_history pmh    INNER JOIN ipd_case_history ich ON  ");
        sb.Append("  pmh.TransactionID=ich.TransactionID INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID  ");
        sb.Append("  WHERE ich.Status <> 'Cancel' AND    DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND     ");
        sb.Append("  DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND pmh.DischargeType='" + txtDesc.Text.ToString() + "')t  ");
        sb.Append("  INNER JOIN patient_ipd_profile pip  ON pip.PatientIPDProfile_ID=t.PatientIPDProfile_ID   ");
        sb.Append("  INNER JOIN ipd_case_type_master ictm ON pip.IPDCaseType_ID_Bill=ictm.IPDCaseType_ID   ");
        sb.Append("  INNER JOIN room_master rm ON pip.Room_ID=rm.Room_Id  ");
        sb.Append("  ORDER BY  t.PatientName  ");


        DataTable dtopd = StockReports.GetDataTable(sb.ToString());
        dtopd.TableName = "dtopd";


        if (dtopd != null && dtopd.Rows.Count > 0)
        {
            
            Session["dtExport2Excel"] = dtopd;
            Session["ReportName"] = "OPD Consultation";
            Session["Period"] = "From" + ucDateFrom.Text + " To " + ucDateTo.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('ExportToExcel.aspx');", true);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);







        }
        else
        {

            lbldetail.Text = "";
            grdDescdisc.DataSource = null;
            grdDescdisc.DataBind();

        }
        mpedicharge.Show();
        lblsummary.Text = "";
    }

    protected void btnExportSpecialitydtl_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("     SELECT t.* FROM(SELECT 'ADMISSION' TYPE,REPLACE(pmh.PatientID,'LSHHI','')MRNo,REPLACE(pmh.TransactionID,'ISHHI','')IPNo,pm.PName,pm.Age, ");
        sb.Append("    CONCAT(pm.Mobile,'/',pm.Phone)MOB,CONCAT(pm.Country,'/',pm.City,'/',pm.House_No)Address  FROM ipd_case_history ich INNER JOIN patient_medical_history pmh ON ich.TransactionID=pmh.TransactionID      ");
        sb.Append("    INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN doctor_master dm ON dm.DoctorID = ich.Consultant_ID    WHERE ich.Status <> 'Cancel'     ");
        sb.Append("    AND DATE(ich.DateOfAdmit)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND   DATE(ich.DateOfAdmit)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' AND dm.Name='" + txtDescSpecialitydtl.Text.ToString() + "'         ");
        sb.Append("    UNION ALL       SELECT 'DISCHARGE' TYPE,REPLACE(pmh.PatientID,'LSHHI','')MRNo,REPLACE(pmh.TransactionID,'ISHHI','')IPNo,pm.PName,pm.Age, ");
        sb.Append("    CONCAT(pm.Mobile,'/',pm.Phone)MOB,CONCAT(pm.Country,'/',pm.City,'/',pm.House_No)Address FROM ipd_case_history ich INNER JOIN patient_medical_history pmh ON ich.TransactionID=pmh.TransactionID      ");
        sb.Append("    INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN doctor_master dm ON dm.DoctorID = ich.Consultant_ID     WHERE ich.Status <> 'Cancel'   AND DATE(ich.DateOfDischarge)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND       ");
        sb.Append("    DATE(ich.DateOfDischarge)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "'  AND dm.Name='" + txtDescSpecialitydtl.Text.ToString() + "'  )t  ORDER BY t.TYPE  ");


        DataTable dtAd = StockReports.GetDataTable(sb.ToString());


        dtAd.TableName = "dtAd";



        if (dtAd != null && dtAd.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dtAd;
            Session["ReportName"] = "OPD Consultation";
            Session["Period"] = "From" + ucDateFrom.Text + " To " + ucDateTo.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('ExportToExcel.aspx');", true);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);




        }
        else
        {

            lbldetail.Text = "";
            grddetailSpecialitydtl.DataSource = null;
            grddetailSpecialitydtl.DataBind();
            mpeSpeciality.Show();
        }
    }
}
