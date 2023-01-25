using System;
using System.Linq;
using System.Web.UI;
using System.Text;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_OPD_DoctorDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillDateTime();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPreview);
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (Session["LoginType"] == null)
        {
            return;
        }

        LoginRestrict LR = new LoginRestrict();
        if (!LR.LoginDateRestrict(Util.GetString(Session["RoleID"]), Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)), Util.GetString(Session["ID"])))
        {
            lblMsg.Text = LoginRestrict.LoginDateRestrictMSG();
            return;
        }

        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string startDate = string.Empty, toDate = string.Empty;

        if (Util.GetDateTime(ucFromDate.Text).ToString() != "")

            startDate = Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd");

        if (Util.GetDateTime(ucToDate.Text).ToString() != string.Empty)

            toDate = Util.GetDateTime(Util.GetDateTime(ucToDate.Text)).ToString("yyyy-MM-dd");


        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT ttt.centreID,ttt.CentreName,ttt.MRNo,ttt.Title,ttt.PName,ttt.House_No,ttt.Street_Name,ttt.Locality,ttt.City,      ");
        sb.Append("   ttt.State,ttt.Country,ttt.Phone,ttt.Mobile,ttt.Age,ttt.Relation,ttt.RelationName,ttt.Gender,ttt.MaritalStatus,      ");
        sb.Append("   ttt.TransactionID,ttt.DateOfAdmit,ttt.TimeOfAdmit,      ");
        sb.Append("   ttt.DateOfDischarge,ttt.TimeOfDischarge,SUM(IFNULL(ttt.IPD_Visits,0))IPD_Visits,SUM(IFNULL(ttt.Surgeon_Charges,0))Surgeon_Charges, ttt.DoctorID,ttt.DocName,ttt.BillNo, ttt.TotalBilledAmt,ttt.Company_Name     ");
        sb.Append("   FROM   ");
        sb.Append("   (SELECT tt.centreID,tt.CentreName,tt.MRNo,tt.Title,tt.PName,tt.House_No,tt.Street_Name,tt.Locality,tt.City,      ");
        sb.Append("   tt.State,tt.Country,tt.Phone,tt.Mobile,tt.Age,tt.Relation,tt.RelationName,tt.Gender,tt.MaritalStatus,      ");
        sb.Append("   tt.TransactionID,tt.DateOfAdmit,tt.TimeOfAdmit,      ");
        sb.Append("   tt.DateOfDischarge,tt.TimeOfDischarge ,tt.ConfigID,  ");
        sb.Append("   (CASE WHEN tt.configid=1 THEN SUM(tt.Amount) END) IPD_Visits,  ");
        sb.Append("   (CASE WHEN tt.configid=22 THEN SUM(tt.Amount) END) Surgeon_Charges,  ");
        sb.Append("   tt.DoctorID,tt.DocName,tt.BillNo, tt.TotalBilledAmt,tt.Company_Name   ");
        sb.Append("   FROM   ");
        sb.Append("   (  ");

        /*IPD Visits data query*/
        sb.Append("   SELECT cmt.centreID,cmt.CentreName,pm.PatientID MRNo,pm.Title,pm.PName,pm.House_No,pm.Street_Name,pm.Locality,pm.City,      ");
        sb.Append("   pm.State,pm.Country,pm.Phone,pm.Mobile,pm.Age,pm.Relation,pm.RelationName,pm.Gender,pm.MaritalStatus,      ");
        sb.Append("   pmh.TransactionID,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,ich.TimeOfAdmit,      ");
        sb.Append("   DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y')DateOfDischarge,ich.TimeOfDischarge ,  ");
        sb.Append("   (ltd.Amount)Amount,ltd.ConfigID,ltd.ItemID,ItemName,adj.BillNo,  ");
        sb.Append("   (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail  ");
        sb.Append("   WHERE TransactionID=adj.TransactionID AND IsVerified = 1 AND IsPackage = 0  ");
        sb.Append("   GROUP BY TransactionID)TotalBilledAmt,dm.DoctorID,(dm.Name)DocName,pnl.Company_Name ");
        sb.Append("    FROM f_ipdadjustment adj INNER JOIN ipd_case_history ich ON adj.TransactionID = ich.TransactionID       ");
        sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.TransactionID = adj.TransactionID       ");
        sb.Append("   INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID INNER JOIN center_master cmt ON cmt.centreID=pmh.`CentreID`   ");
        sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=adj.TransactionID AND IsVerified = 1 AND IsPackage = 0 AND IsSurgery=0 AND ltd.ConfigID=1  ");
        sb.Append("   INNER JOIN f_itemmaster im ON im.ItemID=ltd.ItemID  ");
        sb.Append("   INNER JOIN doctor_master dm ON dm.DoctorID=im.Type_ID  ");
        sb.Append("   INNER JOIN f_panel_master pnl ON pnl.PanelID=pmh.PanelID ");
        sb.Append("   WHERE adj.TransactionID <>''   ");
        sb.Append("   AND DATE(ich.DateOfAdmit)>='" + startDate + "' AND DATE(ich.DateOfAdmit)<='" + toDate + "'  and pmh.`CentreID` in (" + Centre + ")  ");
        sb.Append("     UNION ALL  ");

        /*Surgery data query*/
        sb.Append("   SELECT cmt.centreID,cmt.CentreName,pm.PatientID MRNo,pm.Title,pm.PName,pm.House_No,pm.Street_Name,pm.Locality,pm.City,      ");
        sb.Append("   pm.State,pm.Country,pm.Phone,pm.Mobile,pm.Age,pm.Relation,pm.RelationName,pm.Gender,pm.MaritalStatus,      ");
        sb.Append("   pmh.TransactionID,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,ich.TimeOfAdmit,      ");
        sb.Append("   DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y')DateOfDischarge,ich.TimeOfDischarge ,  ");
        sb.Append("   (sd.Amount)Amount,ltd.ConfigID,ltd.ItemID,ltd.ItemName,adj.BillNo,  ");
        sb.Append("   (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail  ");
        sb.Append("   WHERE TransactionID=adj.TransactionID AND IsVerified = 1 AND IsPackage = 0  ");
        sb.Append("   GROUP BY TransactionID)TotalBilledAmt,dm.DoctorID,(dm.Name)DocName,pnl.Company_Name ");
        sb.Append("   FROM f_ipdadjustment adj INNER JOIN ipd_case_history ich ON adj.TransactionID = ich.TransactionID       ");
        sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.TransactionID = adj.TransactionID       ");
        sb.Append("   INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID  INNER JOIN center_master cmt ON cmt.centreID=pmh.`CentreID`  ");
        sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=adj.TransactionID AND IsVerified = 1 AND IsPackage = 0 AND IsSurgery=1 AND ltd.ConfigID=22  ");
        sb.Append("   INNER JOIN f_itemmaster im ON im.ItemID=ltd.ItemID AND im.Type_ID IN ('S','D')  ");
        sb.Append("   INNER JOIN f_surgery_discription sdsc ON sdsc.TransactionID=ltd.TransactionID AND sdsc.LedgerTransactionNo=ltd.LedgerTransactionNo AND sdsc.ItemID=ltd.ItemID  ");
        sb.Append("   INNER JOIN f_surgery_doctor sd ON sd.SurgeryTransactionID=sdsc.SurgeryTransactionID  ");
        sb.Append("   INNER JOIN doctor_master dm ON dm.DoctorID=sd.DoctorID  ");
        sb.Append("   INNER JOIN f_panel_master pnl ON pnl.PanelID=pmh.PanelID ");
        sb.Append("   WHERE adj.TransactionID <>''   ");
        sb.Append("   AND DATE(ich.DateOfAdmit)>='" + startDate + "' AND DATE(ich.DateOfAdmit)<='" + toDate + "' and pmh.`CentreID` in (" + Centre + ")  ");
        sb.Append("     )tt  ");
        sb.Append("   GROUP BY tt.TransactionID,tt.configID,tt.DoctorID )ttt   ");
        sb.Append("    GROUP BY ttt.TransactionID,ttt.DoctorID   ");

        DataTable dt1 = StockReports.GetDataTable(sb.ToString());
        if (dt1.Rows.Count > 0)
        {
            lblMsg.Text = "";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            dt1.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt1.Copy());

            // ds.WriteXmlSchema(@"E:\\DoctorDetailReport.xml");

            Session["ds"] = ds;
            Session["ReportName"] = "DoctorDetailReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    private void FillDateTime()
    {
        ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");


    }
}