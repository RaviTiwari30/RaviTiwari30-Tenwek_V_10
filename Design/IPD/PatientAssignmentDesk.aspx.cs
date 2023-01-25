using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_PatientAssignmentDesk : System.Web.UI.Page
{
    private int RCCount, NCCount, PCCount, BGCount, DCount, BFCount, DSCount, DSACount, MCCount, DICount, PCount = (int)0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ScreenID"] = 1;
            ViewState["RoleID"] = Session["RoleID"].ToString();
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            LoadDetails();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    protected void LoadDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.`CentreID`,cm.`CentreName`, ip.PatientID 'UHID',pmh.TransNo 'IPDNo',ip.TransactionID,");
        sb.Append(" CONCAT(pm.Title,' ',pm.PName)'PatientName',pm.Age,pm.Gender as Sex,pm.Mobile as 'ContactNo',");
        sb.Append(" Date_Format(pmh.DateOfAdmit,'%d-%b-%Y')'Date Of Admit',DATE_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')'Time Of Admit',");
        sb.Append(" Date_Format(pmh.DateOfDischarge,'%d-%b-%Y')'DateOfDischarge',DATE_FORMAT(pmh.TimeOfDischarge,'%h:%i %p')'Time Of Discharge',");
        sb.Append(" pmh.DischargeType As 'Discharge Status',");
        sb.Append(" concat(ctm.Name,' / ',rm.Bed_No)BedCategory,rm.Bed_No AS 'Bed No.',rm.Floor,CONCAT(dm.Title,' ',dm.Name)'DoctorName',");
        sb.Append(" (select distinct(Department) from doctor_hospital ");
        sb.Append(" where DoctorID = pmh.DoctorID LIMIT 1)AS 'Dept.',pnl.Company_Name Panel,pmh.Admission_Type,if(pnl.Company_Name='CASH','true','false')AdStatus,");
        sb.Append(" (select Diagnosis from Diagnosis_master where  ID=pmh.DiagnosisID)Diagnosis  ,(SELECT NAME FROM employee_master WHERE employeeid=pmh.`DischargedBy`)DischargedBy,");


        sb.Append(" (SELECT if(ifnull(COUNT(*),0)>0,'true','false') FROM `f_ledgertnxdetail`  ltd ");
        sb.Append(" WHERE ltd.ConfigID=25 AND TransactionID = pmh.TransactionID AND ltd.isDone=0 and ltd.IsVerified=1)ProcedureCount,");
        sb.Append(" (SELECT if(ifnull(COUNT(*),0)>0,'true','false') FROM `f_ledgertnxdetail`  ltd ");
        sb.Append(" WHERE ltd.ConfigID=11 AND TransactionID = pmh.TransactionID AND ltd.isDone=0 and ltd.IsVerified=1)MedicineCount,");
        sb.Append(" (SELECT if(ifnull(COUNT(*),0)>0,'true','false') FROM `f_ledgertnxdetail`  ltd ");
        sb.Append(" WHERE ltd.ConfigID=3 AND TransactionID = pmh.TransactionID AND ltd.isDone=0 and ltd.IsVerified=1)InvestigationCount,");
        sb.Append(" (SELECT if(ifnull(COUNT(*),0)>0,'true','false') FROM `f_ledgertnxdetail`  ltd ");
        sb.Append(" WHERE ltd.ConfigID not in (3,11,25) AND TransactionID = pmh.TransactionID AND ltd.isDone=0 and ltd.IsVerified=1)OtherCount");

        sb.Append(" FROM patient_ipd_profile ip INNER JOIN patient_medical_history pmh on ip.TransactionID = pmh.TransactionID  AND pmh.Type='IPD' ");
        sb.Append(" INNER JOIN room_master rm ON rm.RoomId = ip.RoomID INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID  ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID  INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
        sb.Append(" INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID` ");
        sb.Append(" WHERE pmh.Status = 'IN' and pmh.CentreID =" + Session["CentreID"].ToString());
        sb.Append(" Group by ip.TransactionID Having max(EndDate) Order by pmh.TransactionID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());


        if (dt.Rows.Count > 0 && dt != null)
        {
            grdDischargeScreen.DataSource = dt;
            grdDischargeScreen.DataBind();
        }
        else
        {
            grdDischargeScreen.DataSource = null;
            grdDischargeScreen.DataBind();
        }
    }

    protected void grdDischargeScreen_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ProcedureCall")
        {
            string PDetail = Util.GetString(e.CommandArgument);
            DataTable dt =StockReports.GetDataTable("SELECT ltd.ItemName,ltd.SubcategoryID FROM `f_ledgertnxdetail`  ltd INNER JOIN f_subcategorymaster sc ON sc.SubcategoryID = ltd.SubcategoryID WHERE sc.CategoryID = 'LSHHI6' AND TransactionID = '" + PDetail + "' and ltd.isDone=0");

            lblCategory.Text = "LSHHI6";
            lblIPDNo.Text = PDetail;
            grditems.DataSource = dt;
            grditems.DataBind();
            mpCancel.Show();
        }
        if (e.CommandName == "MedicineCall")
        {
            string PDetail = Util.GetString(e.CommandArgument);

            DataTable dt = StockReports.GetDataTable("SELECT ltd.ItemName,ltd.SubcategoryID FROM `f_ledgertnxdetail`  ltd INNER JOIN f_subcategorymaster sc ON sc.SubcategoryID = ltd.SubcategoryID WHERE sc.CategoryID = 'LSHHI5' AND TransactionID = '" + PDetail + "' and ltd.isDone=0");
            lblCategory.Text = "LSHHI5";
            lblIPDNo.Text = PDetail;
            grditems.DataSource = dt;
            grditems.DataBind();
            mpCancel.Show();
        }
        if (e.CommandName == "InvestigationCall")
        {
            string PDetail = Util.GetString(e.CommandArgument);

            DataTable dt = StockReports.GetDataTable("SELECT ltd.ItemName,ltd.SubcategoryID FROM `f_ledgertnxdetail`  ltd INNER JOIN f_subcategorymaster sc ON sc.SubcategoryID = ltd.SubcategoryID WHERE sc.CategoryID = 'LSHHI3' AND TransactionID = '" + PDetail + "' and ltd.isDone=0");
            lblCategory.Text = "LSHHI3";
            lblIPDNo.Text = PDetail;
            grditems.DataSource = dt;
            grditems.DataBind();
            mpCancel.Show();
        }
        if (e.CommandName == "OtherCall")
        {
            string PDetail = Util.GetString(e.CommandArgument);

            DataTable dt = StockReports.GetDataTable("SELECT ltd.ItemName,ltd.SubcategoryID FROM `f_ledgertnxdetail`  ltd INNER JOIN f_subcategorymaster sc ON sc.SubcategoryID = ltd.SubcategoryID WHERE sc.CategoryID = 'LSHHI16' AND TransactionID = '" + PDetail + "' and ltd.isDone=0");
            lblCategory.Text = "LSHHI16";
            lblIPDNo.Text = PDetail;
            grditems.DataSource = dt;
            grditems.DataBind();
            mpCancel.Show();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        StockReports.ExecuteDML("UPDATE f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=ltd.`SubCategoryID` SET isDone=1 WHERE ltd.`TransactionID`='" + lblIPDNo.Text + "' AND sc.`CategoryID`='" + lblCategory.Text + "'");
        ScriptManager.RegisterStartupScript(Page, typeof(Page), "key1", "alert('Updated Successfully');", true);
        LoadDetails();      
    }
}