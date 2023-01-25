using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
public partial class Design_IPD_InvestigationBill : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }
        if (!IsPostBack)
        {
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["TID"] = TID;
            BindCategory();
        }

    }
    private void GetIssueDetails(string TransID)
    {
        StringBuilder sb = new StringBuilder();

        // sb.Append(" SELECT ItemID,Item,Rate,sum(Quantity)Quantity,TypeOfTnx,AmountPaid,rate*SUM(Quantity)TotalRate,IssueDate,RoundOff, ");
        // sb.Append(" Amount,EntryType FROM ( ");
        if (chkissue.Checked)
        {

            sb.Append(" SELECT  ifnull(pli.BarcodeNo,0) as BarcodeID, REPLACE(REPLACE(LTD.LedgerTransactionNo,'LISHHI',''),'LSHHI','')LedgerTransactionNo,LTD.ItemID,LTD.ItemName AS Item,LTD.Rate,ROUND(LTD.Quantity)Quantity,ltd.DiscAmt,ltd.DiscountPercentage,");
            sb.Append(" 'ISSUE DETAILS ::' AS TypeOfTnx,LT.NetAmount AS TotalRate,LTD.Amount,  ");
            sb.Append(" DATE_FORMAT(LTd.EntryDate,'%d-%b-%Y')IssueDate,Lt.Time ,IFNULL(LT.IPNo,'')IPNo,LT.TypeOfTnx AS TransactionType,lt.RoundOff,sub.CategoryID, ");
            //  sb.Append(" (CASE WHEN sub.CategoryID='3' THEN 'PATHOLOGY' WHEN sub.CategoryID='7' THEN 'RADIOLOGY' WHEN  sub.CategoryID='25' THEN 'CARDIOLOGY' WHEN sub.CategoryID='30' THEN 'Diet Charges (With 2% Vat)' WHEN sub.CategoryID='6' THEN 'Procedure Charges'  END)EntryType,");
            sb.Append(" IF(ltd.isAttendentRoom=1,'ATTENDENT ROOM',cm.Name)EntryType, IFNULL((SELECT IFNULL(itemCode,'')itemCode FROM f_ratelist_ipd rti INNER JOIN f_panel_master fpm ON rti.PanelID=fpm.ReferenceCode ");
            sb.Append(" WHERE fpm.PanelID=lt.PanelID AND rti.itemID = ltd.ItemID AND rti.iscurrent=1 LIMIT 1 ),'')itemCode FROM f_ledgertransaction LT  INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo ");
            sb.Append(" LEFT JOIN f_reciept  RC ON LT.LedgerTransactionNo=RC.AsainstLedgerTnxNo ");
            sb.Append(" INNER JOIN f_subcategorymaster SM ON ltd.SubCategoryID = SM.SubCategoryID   ");
            sb.Append(" INNER JOIN f_categorymaster cm ON sm.CategoryID = cm.CategoryID    ");
            sb.Append(" INNER JOIN Patient_Medical_History PMH ON LTD.TransactionID=PMH.TransactionID INNER JOIN f_subcategorymaster sub ON sub.SubCategoryID=ltd.SubCategoryID ");
            sb.Append(" LEft JOIN patient_labinvestigation_opd pli ON pli.LedgertnxID= ltd.ID WHERE LT.TransactionID = '" + TransID + "' and lt.isCancel=0 AND ltd.isVerified=1 ");
            sb.Append(" AND cm.CategoryID ='" + ddlBillType.SelectedValue + "' ");
            sb.Append("   ORDER BY LTD.ItemName asc,LTd.EntryDate asc");
        }
        // sb.Append(" )t  GROUP BY IssueDate ");


        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            decimal IssueAmount = Util.GetDecimal(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'ISSUE DETAILS ::'"));


            DataColumn dc = new DataColumn();
            dc.ColumnName = "NetAmount";
            dc.DefaultValue = IssueAmount;

            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);



            StringBuilder psb = new StringBuilder();

            psb.Append("SELECT pmh.Transno Transaction_ID,DATE_FORMAT(if(pmh.DateOfAdmit = '0001-01-01',CURDATE(),pmh.DateOfAdmit),'%d-%b-%Y')DateOfAdmit,if(pmh.DateOfDischarge = '0001-01-01','-',DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge, ");
            psb.Append(" CONCAT(pm.Title,' ',pm.PName)Name,pm.House_No Address,CONCAT(pm.Age,'/',pm.Gender)AgeSex,pnl.Company_Name,IFNULL(pm.RelationName,'')RelationName,");
            psb.Append(" CONCAT(dm.Title,' ',dm.Name)Consultant, pmh.PatientID as Patient_ID,  DATE_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')TimeOfAdmit,if(pmh.TimeOfDischarge='00:00:00','',DATE_FORMAT(TimeOfDischarge,'%h:%i %p'))TimeOfDischarge, ");
            psb.Append(" pmh.BillNo from patient_medical_history pmh");
            psb.Append(" inner join patient_master pm on pmh.PatientID = pm.PatientID");
            psb.Append(" inner join f_panel_master pnl on pmh.PanelID = pnl.PanelID inner join doctor_master dm on pmh.DoctorID = dm.DoctorID");
            psb.Append(" where pmh.TransactionID = '" + TransID + "'");

            DataTable dtPatient = new DataTable();
            dtPatient = StockReports.GetDataTable(psb.ToString());

            DataSet ds = new DataSet();
            dtPatient.TableName = "PatientDetail";
            ds.Tables.Add(dtPatient.Copy());

            dt.TableName = "IssueDetails";
            ds.Tables.Add(dt.Copy());

            if (rblBillFormat.SelectedValue == "1")
            {
                Session["ds"] = ds;
                Session["ReportName"] = "InvestigationBillIPD";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/common/CommonCrystalReportViewer.aspx');", true);
            }
            else
            {
                Session["ds"] = ds;
                //ds.WriteXml(@"E://InvestigationBillIPD.xml");

                Session["ReportName"] = "InvestigationBillIPD";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
        }

        else
        {
            lblMsg.Text = "No Record Found";
            return;
        }

    }
    protected void btnView_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        GetIssueDetails(ViewState["TID"].ToString());
    }
    private void BindCategory()
    {
        string str = "";
        //str = " Select cf.Name,cf.ID from f_configrelation_master cf where cf.ID in ";
        //str = str + "(3,25,10)";
        //str = str + " group by cf.ID order by cf.ID";
        str = " SELECT DisplayName,CategoryID ";
        str = str + " FROM (     ";
        str = str + " SELECT ltd.subcategoryID ,ltd.ConfigID,cm.CategoryID,IF(ltd.isAttendentRoom=1,'ATTENDENT ROOM',cm.Name)DisplayName    ";
        str = str + " FROM f_ledgertnxdetail ltd  ";
        str = str + " INNER JOIN f_ledgertransaction LT  ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo  ";
        str = str + " INNER JOIN f_subcategorymaster SM ON ltd.SubCategoryID = SM.SubCategoryID   ";
        str = str + " INNER JOIN f_categorymaster cm ON sm.CategoryID = cm.CategoryID    ";
        str = str + " WHERE Lt.IsCancel = 0 AND  ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND ltd.IsSurgery = 0  AND lt.TransactionID = '" + ViewState["TID"].ToString() + "'";
        str = str + " UNION ALL    ";
        str = str + " SELECT ltd.SubcategoryID ,ltd.ConfigID,cm.CategoryID,IF(ltd.isAttendentRoom=1,'AttendentRoom Room',cm.Name)DisplayName ";
        str = str + " FROM f_ledgertnxdetail ltd ";
        str = str + " INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo";
        str = str + " INNER JOIN f_subcategorymaster SM ON ltd.SubCategoryID = SM.SubCategoryID ";
        str = str + " INNER JOIN f_categorymaster cm ON sm.CategoryID = cm.CategoryID ";
        str = str + " WHERE Lt.IsCancel = 0 AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND ltd.IsSurgery = 1 AND lt.TransactionID = '" + ViewState["TID"].ToString() + "'";
        str = str + " )t1 GROUP BY t1.ConfigID,t1.DisplayName";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            ddlBillType.DataSource = dt;
            ddlBillType.DataTextField = "DisplayName";
            ddlBillType.DataValueField = "CategoryID";
            ddlBillType.DataBind();
        }
    }
}