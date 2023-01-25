using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_DocAccount_DoctorChargesDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDoctors();
            ViewState["UserID"] = Session["ID"].ToString();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }
    private void BindDoctors()
    {
        DataTable dt = All_LoadData.bindDoctor();
        dt = dt.AsEnumerable().Where(d => d.Field<int>("IsDocShare") == 1).CopyToDataTable();

        if (dt.Rows.Count > 0)
        {
            ddlDoctor.DataSource = dt;
            ddlDoctor.DataTextField = "Name";
            ddlDoctor.DataValueField = "DoctorID";
            ddlDoctor.DataBind();
            ddlDoctor.Items.Insert(0, new ListItem("All", "All"));
        }
        else
            ddlDoctor.Items.Clear();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        if (rbdReportType.SelectedValue == "S")
        {
            sb.Append(" SELECT IFNULL(t.doctor,'-')Doctor,t.typeoftnx,SUM(grossamt)Gross,SUM(Disc)Disc,SUM(NetAmt)NetAmt FROM ( ");
        }
        sb.Append("select t4.*,concat(pm.title,' ',pm.Pname) PatientName,t5.AmountPaid  from (Select t1.DoctorID,t1.doctor, rt.ReceiptNo,t1.TypeOfTnx,t1.DiscountReason,t1.PatientID,t1.billdate,t1.EntryDate,");
        sb.Append(" t1.GrossAmt,if(t1.Disc is null,0,t1.Disc)Disc,t1.NetAmt,scm.Name SCName,t1.ItemName,0.0 TBillDisc,t1.TransactionID from (Select ltd.DoctorID,(SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=pmh.DoctorID)doctor, 'OPD-APPOINTMENT' TypeOfTnx,lt.LedgerTransactionNo,lt.DiscountReason,lt.PatientID,lt.TransactionID, ");
        sb.Append(" date_format(lt.Date,'%d-%b-%y') billdate,date_format(lt.Date,'%d-%b-%y') EntryDate,(ltd.Rate*ltd.Quantity) GrossAmt,(ltd.Rate*ltd.Quantity)-ltd.Amount Disc,");
        sb.Append(" ltd.Amount NetAmt,im.SubCategoryID,'' ItemName From f_ledgertransaction lt inner join patient_medical_history pmh on pmh.TransactionID = lt.TransactionID inner join f_ledgertnxdetail ltd on lt.LedgerTransactionNo = ltd.LedgerTransactionNo ");
        sb.Append(" inner join f_iteMMaster im on ltd.ItemID = im.ItemID Where lt.TypeOfTnx = 'OPD-APPOINTMENT' and lt.IsCancel = 0 and (date(lt.Date) between '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" and '" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "') ");
        if (ddlDoctor.SelectedValue != "All")
        {
            sb.Append(" and pmh.DoctorID='" + ddlDoctor.SelectedValue + "'  ");
        }
        sb.Append(" union all select ltd.DoctorID,(SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=pmh.DoctorID)doctor ,'OPD-PROCEDURE' TypeOfTnx,lt.LedgerTransactionNo,lt.DiscountReason,lt.PatientID,lt.TransactionID, date_format(lt.Date,'%d-%b-%y'),");
        sb.Append(" date_format(lt.Date,'%d-%b-%y'),(ltd.Rate*ltd.Quantity)GrossAmt,(ltd.Rate*ltd.Quantity)-ltd.Amount Disc,ltd.Amount NetAmt,ltd.SubCategoryID,ltd.ItemName ");
        sb.Append(" from f_ledgertransaction lt inner join f_ledgertnxdetail ltd on lt.LedgerTransactionNo = ltd.LedgerTransactionNo inner join patient_medical_history pmh on ");
        sb.Append(" pmh.TransactionID = lt.TransactionID where lt.TypeOfTnx='OPD-PROCEDURE' and lt.IsCancel = 0 and date(lt.date) between '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
        if (ddlDoctor.SelectedValue != "All")
        {
            sb.Append(" and pmh.DoctorID ='" + ddlDoctor.SelectedValue + "' ");
        }

        sb.Append("    )t1 inner join f_reciept rt on rt.AsainstLedgerTnxNo = t1.LedgerTransactionNo inner join f_subcategorymaster scm ");
        sb.Append(" on scm.SubCategoryID = t1.SubCategoryID inner join f_categorymaster ct on scm.categoryid=ct.categoryid inner join f_configrelation cf on cf.categoryid=ct.categoryid where cf.ConfigID in ('5','25') union all Select ltd.DoctorID,(SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=im.type_id)doctor ,adj.BillNo,'IPD-VISITS' TypeOfTnx,adj.DiscountOnBillReason,adj.PatientID,date_format(lt.BillDate,'%d-%b-%y'),");
        sb.Append(" date_format(ltd.EntryDate,'%d-%b-%y'),(ltd.Rate*ltd.Quantity) GrossAmt,(ltd.Rate*ltd.Quantity)-ltd.Amount Disc,ltd.Amount NetAmt,sm.Name,'' itemname,");
        sb.Append(" Round(((adj.DiscountOnBill*100)/adj.TotalBilledAmt),1) TBillDisc,adj.TransactionID From f_ipdadjustment Adj inner Join f_ledgertransaction LT on adj.TransactionID = LT.TransactionID ");
        sb.Append(" inner join f_ledgertnxdetail ltd on lt.LedgerTransactionNo = ltd.LedgerTransactionNo inner join f_iteMMaster im  on ltd.ItemID = im.ItemID inner join f_subcategorymaster sm ");
        sb.Append(" on sm.SubCategoryID = im.SubCategoryID inner join f_categorymaster ct on sm.categoryid=ct.categoryid inner join f_configrelation cf on cf.categoryid=ct.categoryid   where (adj.billno is not null) and  cf.ConfigID in ('1','22') and (date(lt.BillDate) between '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "') ");
        if (ddlDoctor.SelectedValue != "All")
        {
            sb.Append(" and im.Type_Id='" + ddlDoctor.SelectedValue + "'  ");
        }
        sb.Append(" and ltd.IsVerified = 1 and lt.IsCancel = 0 and ltd.IsPackage = 0 and ltd.IsSurgery = 0 union all select t1.DoctorID,(SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=t1.DoctorID)doctor ,t2.BillNo,t2.TypeOfTnx,t2.DiscountOnBillReason");
        sb.Append(" ,t2.PatientID,t2.BillDate,t2.EntDate,t1.GrossAmt,(t1.GrossAmt-t1.NetAmt) Disc,t1.NetAmt,t1.typename,'',if(t2.TBillDisc is null,0,t2.TBillDisc)TBillDisc,t2.TransactionID from (select sd.DoctorID,sg.LedgerTransactionNo,(100*sd.Amount)/(100-sd.Discount) GrossAmt,");
        sb.Append(" sd.Amount NetAmt,im.typename from f_surgery_doctor sd inner join f_surgery_discription sg on sd.SurgeryTransactionID = sg.SurgeryTransactionID inner join f_iteMMaster im on im.itemid = sd.itemid ");
        if (ddlDoctor.SelectedValue != "All")
        {
            sb.Append(" where sd.DoctorID='" + ddlDoctor.SelectedValue + "' ");
        }
        sb.Append("    )t1 inner join ( select lt.TransactionID,lt.LedgerTransactionNo,date_format(lt.BillDate,'%d-%b-%y')BillDate,date_format(lt.Date,'%d-%b-%y')EntDate,lt.PatientID,");
        sb.Append(" Round((adj.DiscountOnBill*100)/adj.TotalBilledAmt,1) TBillDisc,'IPD-PROCEDURE' TypeOfTnx,adj.DiscountOnBillReason,adj.billno from f_ledgertransaction LT inner Join f_ipdadjustment Adj on LT.TransactionID = adj.TransactionID ");
        sb.Append(" inner join f_ledgertnxdetail ltd on lt.LedgerTransactionNo = ltd.LedgerTransactionNo where (adj.billno is not null) and (date(lt.BillDate) between '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "') ");
        sb.Append(" and ltd.IsVerified = 1 and lt.IsCancel = 0 and ltd.IsPackage = 0 and ltd.IsSurgery = 1 group by lt.LedgerTransactionNo) t2 on t1.LedgerTransactionNo = t2.LedgerTransactionNo) t4");
        sb.Append(" inner join patient_master pm on t4.PatientID = pm.PatientID");
        sb.Append(" left  join (Select sum(AmountPaid)AmountPaid,rt.TransactionID from f_reciept rt inner join ");
        sb.Append(" (Select TransactionID from f_ledgertransaction where (date(BillDate) between '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "')  ");
        sb.Append(" and IsCancel = 0 group by TransactionID) lt on rt.TransactionID = lt.TransactionID ");
        sb.Append(" Where rt.IsCancel=0 group by rt.TransactionID ");
        sb.Append(" )t5 on t4.TransactionID = t5.TransactionID");
        if (rbdReportType.SelectedValue == "S")
        {
            sb.Append(" )t GROUP BY DoctorID,typeoftnx order by Doctor");
        }


        DataTable dt = StockReports.GetDataTable(sb.ToString());



        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "DoctorName";
            dc.DefaultValue = ddlDoctor.SelectedItem.Text;
            dt.Columns.Add(dc);

            dt.TableName = "Table";


            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            // ds.Tables.Add(dt1.Copy());            

            Session["ds"] = ds;
            if (rbdReportType.SelectedValue == "D")
            {
                //ds.WriteXml("E:/DocChargesDiscount.xml");
                Session["ReportName"] = "DocDiscDetails";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                //ds.WriteXml("E:/DocChargesDiscount_summary.xml");
                Session["ReportName"] = "DocDiscDetails_Summary";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }


        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }

    protected void rbtActive_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDoctors();
    }

}
