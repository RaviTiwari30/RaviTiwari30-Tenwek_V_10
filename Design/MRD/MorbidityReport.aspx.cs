using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_MRD_MorbidityReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            EntryDate1.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            EntryDate2.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                       
        }
        EntryDate1.Attributes.Add("readonly", "readonly");
        EntryDate2.Attributes.Add("readonly", "readonly");
    }

  
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = new DataSet();
            StringBuilder sb = new StringBuilder();
            string str = "Select concat(pm.Title,' ',pm.PName)PatientName,IF(pmh.Type='IPD',Transno,'')Transaction_ID,pm.Age,pm.Gender," +
            " (Select Name from doctor_master where DoctorID = pmh.DoctorID)Doc1," +
            " ifnull((Select Name from doctor_master where DoctorID = pmh.DoctorID),'')Doc2," +
            " date_format(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,date_format(pmh.DateOfDischarge,'%d-%b-%Y')DateOfDischarge," +
            " trim(concat(pm.House_No,' ',Street_Name,' ',Locality,' ',City,' ',if(Pincode=0,'',Pincode)))Address," +
            " pmh.TotalBilledAmt,ifnull(pmh.DiscountOnBill,'0')DiscountOnBill,pmh.BillDate,pmh.BillNo, " +
            " (select if(PanelID = 1,'CASH', Company_Name) from f_panel_master where PanelID = pmh.PanelID)Panel, " +
            " if(ifnull(pmh.MLC_NO,'')='','',concat('# ',pmh.MLC_NO))MLC_NO, if(pmh.DischargeType = 'Expired','- Expired','')DischargeType" +
            " from mrd_file_master mfm  " +
            " inner join patient_medical_history pmh on pmh.TransactionID = mfm.TransactionID " +
            " inner join patient_master pm on pm.PatientID = mfm.PatientID " +
            " Where pmh.CentreID=" + Session["CentreID"] + " and  mfm.BillDate >='" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "' " +
            " and mfm.BillDate <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "' order by mfm.BillNo";

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(str).Copy();
            dt.TableName = "dtMain";

            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + Util.GetDateTime(EntryDate2.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(EntryDate2.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);
            ds.Tables.Add(dt);

            sb.Append(" Select ic.who_Full_Desc,ic.ICD10_Code,IF(pmh.Type='IPD',Transno,'')Transaction_ID from ");
            sb.Append(" icd_10cm_patient ipt inner join icd_10_new ic on ipt.icd_id = ic.ID ");
            sb.Append(" inner join mrd_file_master mfm on mfm.TransactionID = ipt.TransactionID ");
            sb.Append(" inner join patient_medical_history pmh on pmh.TransactionID=mfm.TransactionID ");
            sb.Append(" Where pmh.CentreID="+Session["CentreID"]+" AND mfm.BillDate >='" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'  ");
            sb.Append(" and mfm.BillDate <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "' ");
            
            if(txtCode.Text.Trim()!="")
            {
                sb.Append("  AND ICD10_Code like '" + txtCode.Text.Trim() + "%' ");
            }
            sb.Append(" order by mfm.BillNo");

            DataTable dtCode = new DataTable();
            dtCode = StockReports.GetDataTable(sb.ToString()).Copy();
            dtCode.TableName = "dtCode";
            ds.Tables.Add(dtCode);


          //  ds.WriteXml("E:\\ICDcode.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "Morbidity";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('Commonreport.aspx');", true);



        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }


    protected void btnGovt_Click(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = new DataSet();




            string str = " select Section,Diagnosis_Code,Diagnosis_Description,if(aa.MALE=0,'',aa.MALE)MALE,if(aa.FEMALE=0,'',aa.FEMALE)FEMALE ,if(aa.ExpiredMALE=0,'',aa.ExpiredMALE)ExpiredMALE,if(aa.ExpiredFEMALE=0,'',aa.ExpiredFEMALE)ExpiredFEMALE " +
                        " from icd_10_new icd  " +
                        " left outer join (select icd_id,sum(MALE)MALE,sum(FEMALE)FEMALE ,sum(ExpiredMALE)ExpiredMALE,sum(ExpiredFEMALE)ExpiredFEMALE " +
                        " from ( " +
                        " select distinct icd.*, " +
                        " if( pm.Gender ='MALE' and pmh.DischargeType != 'Expired' ,1 , 0 )MALE, " +
                        " if( pm.Gender ='FEMALE' and pmh.DischargeType != 'Expired' ,1 , 0 )FEMALE , " +
                        " if( pm.Gender ='MALE' and pmh.DischargeType = 'Expired' ,1 , 0 )ExpiredMALE, " +
                        " if( pm.Gender ='FEMALE' and pmh.DischargeType = 'Expired' ,1 , 0 )ExpiredFEMALE " +
                        " from icd_10cm_patient icd inner join f_ledgertransaction lt on lt.Transaction_ID = icd.Transaction_ID  " +
                        " inner join patient_medical_history pmh on pmh.Transaction_ID = icd.Transaction_ID  " +
                        " inner join patient_master pm on pmh.Patient_ID = pm.Patient_ID  " +
                        " where date(billdate) >= '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'  " +
                        " and date(billdate) <= '" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "'  " +
                        " )a group by icd_id )  " +
                        " aa on aa.icd_id = icd.ID  " +
                        " order by Section,Diagnosis_Code,Diagnosis_Description ";

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(str).Copy();
            dt.TableName = "dtMain";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + Util.GetDateTime(EntryDate1.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(EntryDate2.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            ds.Tables.Add(dt.Copy());
            //  ds.WriteXml("C:\\ICDcode.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "Morbidity2";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('Commonreport.aspx');", true);


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSummary_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT mfm.BillNo,ic.ICD10_Code,ic.who_Full_Desc,pm.Gender, ");
        sb.Append(" SUM(IF(REPLACE(pm.Age,'YRS','')<12,1,0)) Child, ");
        sb.Append(" SUM(IF(REPLACE(pm.Age,'YRS','')>=12 &&  pm.Gender='Male',1,0)) Male, ");
        sb.Append(" SUM(IF(REPLACE(pm.Age,'YRS','')>=12 AND pm.Gender='Female',1,0))Female, ");
        sb.Append(" IF(pmh.Type='IPD',Transno,'')Transaction_ID   ");
        sb.Append(" FROM icd_10cm_patient ipt INNER JOIN icd_10_new ic ON ipt.icd_id = ic.ID INNER JOIN mrd_file_master mfm ON mfm.TransactionID = ipt.TransactionID inner join patient_medical_history pmh on pmh.TransactionID=mfm.TransactionID INNER JOIN patient_master pm ON pm.PatientID = mfm.PatientID  ");
        sb.Append(" WHERE mfm.BillDate >='" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "' AND mfm.BillDate <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "' ");
         if(txtCode.Text.Trim()!="")
            {
                sb.Append("  AND ICD10_Code like '" + txtCode.Text.Trim() + "%' ");
            }
        sb.Append(" GROUP BY ic.ICD10_Code ORDER BY BillNo ");

        DataTable dt = new DataTable();
        DataSet ds = new DataSet();
        dt = StockReports.GetDataTable(sb.ToString());
        ds.Tables.Add(dt.Copy());
       // ds.WriteXml("E:\\Summary.xml");
        Session["ds"] = ds;
        Session["ReportName"] = "MorbiditySummary";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('Commonreport.aspx');", true);
    }
}
