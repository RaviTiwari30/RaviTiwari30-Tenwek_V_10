using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
public partial class Design_DocAccount_DocShareReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //All_LoadData.bindDoctor(ddlDoctor, "ALL");
            //All_LoadData.bindShareDoctorList(ddlDoctor, 1, "ALL");
            BindDoctor();
            bindDate();
        }
    }

    private void bindDate()
    {
        // DataTable Sharedate = StockReports.GetDataTable("SELECT CONCAT(DATE_FORMAT(Share_From,'%d-%b-%Y'),'#',DATE_FORMAT(Share_To,'%d-%b-%Y'))ShareDateID,CONCAT(DATE_FORMAT(Share_From,'%d-%b-%Y'),' To ',DATE_FORMAT(Share_To,'%d-%b-%Y'))ShareDate FROM da_share_date WHERE PostShare=1");
        //DataTable Sharedate = StockReports.GetDataTable(" SELECT DISTINCT CONCAT(DATE_FORMAT(Share_From,'%d-%b-%Y'),'#',DATE_FORMAT(Share_To,'%d-%b-%Y'))ShareDateID,CONCAT(DATE_FORMAT(Share_From,'%d-%b-%Y'),' To ',DATE_FORMAT(Share_To,'%d-%b-%Y'))ShareDate FROM da_doctorsharestatus WHERE IsPosted=1 ");
        DataTable Sharedate = StockReports.GetDataTable(" SELECT DISTINCT CONCAT(DATE_FORMAT(Share_From,'%d-%b-%Y'),'#',DATE_FORMAT(Share_To,'%d-%b-%Y'))ShareDateID,CONCAT(DATE_FORMAT(Share_From,'%d-%b-%Y'),' To ',DATE_FORMAT(Share_To,'%d-%b-%Y'))ShareDate FROM da_doctorsharestatus WHERE Isposted=" + Util.GetInt(rbtPostedStatus.SelectedItem.Value) + " ");
        if (Sharedate.Rows.Count > 0)
        {
            ddlDate.DataTextField = "ShareDate";
            ddlDate.DataValueField = "ShareDateID";
            ddlDate.DataSource = Sharedate;
            ddlDate.DataBind();
            ddlDate.Items.Insert(0, "Select");
        }
        else
        {
            ddlDate.DataSource = null;
            ddlDate.DataBind();
            ddlDate.Items.Insert(0, "Select");
        }
    }

    private void BindDoctor()
    {
        DataTable dtDoctor = All_LoadData.bindDoctor();
        dtDoctor = dtDoctor.AsEnumerable().Where(d => d.Field<int>("IsDocShare") == 1).CopyToDataTable();
        
        if (dtDoctor != null && dtDoctor.Rows.Count > 0)
        {
            ddlDoctor.DataSource = dtDoctor;
            ddlDoctor.DataTextField = "Name";
            ddlDoctor.DataValueField = "DoctorID";
            ddlDoctor.DataBind();

            ddlDoctor.Items.Insert(0, new ListItem("ALL", "0"));
        }
        else
        {
            ddlDoctor.DataSource = null;
            ddlDoctor.DataBind();
        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        if (ddlDate.SelectedIndex != 0)
        {
            //if (rblReportType.SelectedItem.Value == "1")
            //{
            //    StringBuilder sb = new StringBuilder();
            //    sb.Append(" select concat(dm.Title,' ',dm.Name)DoctorName,ROUND(TotalGrossAmt,0) GrossAmount,ROUND(TotalDiscount,0) Discount,");
            //    sb.Append(" ROUND(TotalNetAmt,0) NetAmount,ROUND(DoctorShare,0) DoctorShare ,ROUND(TDS,0) TDS ,ROUND(PayableAmt,0) PayableAmount,ROUND(OPDCashShare,0) OPDCashShare ,ROUND(OPDCreditShare,0) OPDCreditShare ,ROUND(IPDCashShare,0) IPDCashShare ,ROUND(IPDCreditShare,0) IPDCreditShare from ");//ROUND(TotalPaidAmount,0) PaidAmount
            //    sb.Append(" da_docsharemaster doc inner join Doctor_master dm on doc.doctorID=dm.DoctorID where doc.IsPost=1 ");

            //    if (ddlDoctor.SelectedIndex != 0)
            //    {
            //        sb.Append(" AND doc.doctorID='" + ddlDoctor.SelectedItem.Value + "'  ");
            //    }

            //    if (ddlDate.SelectedIndex != 0)
            //    {
            //        sb.Append(" AND doc.fromdate=('" + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[0]).ToString("yyyy-MM-dd") + "')");
            //        sb.Append(" AND doc.todate=('" + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[1]).ToString("yyyy-MM-dd") + "')");
            //    }

            //    DataTable dt = StockReports.GetDataTable(sb.ToString());

            //    if (dt.Rows.Count > 0)
            //    {
            //        Session["ReportName"] = " Doctor Share Summary Report ";
            //        Session["dtExport2Excel"] = dt;
            //        Session["Period"] = "Doctor Share Report From " + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[0]).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[1]).ToString("dd-MMM-yyyy");
            //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            //    }
            //    else
            //    {
            //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            //    }
            //}
            //else
            //{
            //    if (rblReportFormat.SelectedIndex == 1)
            //    {
            //        StringBuilder sb1 = new StringBuilder();
            //        sb1.Append(" SELECT CONCAT(dm.Title,' ',dm.Name)'Doctor Name',doc.ReceiptNo 'Receipt No.',GrossAmount,Discount,NetAmount,DoctorSharePercentage,DoctorShare,  ");
            //        sb1.Append(" TypeOfTnx,doc.PatientID 'UHID',CONCAT(pm.Title,Pm.Pname) 'Patient Name',DATE_FORMAT(doc.BillDate,'%d-%b-%Y')BillDate,Type,IF(doc.PaymentType=1,'CASH','CREDIT')PaymentType ,doc.`UserName`,doc.`PanelName` ");//PaidAmount
            //        sb1.Append(" FROM da_doctorsharedetail doc INNER JOIN Doctor_master dm ON doc.doctorID=dm.DoctorID INNER JOIN patient_master pm ON pm.PatientID=doc.PatientID  ");

            //        if (ddlDoctor.SelectedIndex != 0)
            //        {
            //            sb1.Append(" AND doc.doctorID='" + ddlDoctor.SelectedItem.Value + "'  ");
            //        }

            //        if (ddlDate.SelectedIndex != 0)
            //        {
            //            sb1.Append(" AND doc.fromdate=('" + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[0]).ToString("yyyy-MM-dd") + "')");
            //            sb1.Append(" AND doc.todate=('" + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[1]).ToString("yyyy-MM-dd") + "')");
            //        }

            //        if (rblType.SelectedItem.Value != "3")
            //        {
            //            sb1.Append(" AND doc.Type='" + rblType.SelectedItem.Text + "'");
            //        }

            //        if (rblPaymentType.SelectedItem.Value != "3")
            //        {
            //            sb1.Append(" AND doc.PaymentType='" + rblPaymentType.SelectedItem.Value + "'");
            //        }

            //        sb1.Append(" Order by doc.BillDate");

            //        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());

            //        if (dt1.Rows.Count > 0)
            //        {
            //            if (rblType.SelectedItem.Value == "3" && rblPaymentType.SelectedItem.Value == "3")
            //                Session["ReportName"] = " Doctor Share Detail Report ";
            //            else
            //                Session["ReportName"] = " Doctor Share Detail Report (" + rblType.SelectedItem.Text.ToUpper() + "-" + rblPaymentType.SelectedItem.Text.ToUpper() + ")";

            //            DataRow dr = dt1.NewRow();
            //            dr[0] = "Total";
            //            dr["DoctorShare"] = dt1.Compute("sum(DoctorShare)", "");
            //            dt1.Rows.InsertAt(dr, dt1.Rows.Count + 1);
            //            Session["dtExport2Excel"] = dt1;
            //            Session["Period"] = "Doctor Share Report From " + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[0]).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[1]).ToString("dd-MMM-yyyy");
            //            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            //        }
            //        else
            //        {
            //            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            //        }
            //    }
            //    else
            //    {
            //        StringBuilder sb = new StringBuilder();
            //        //sb.Append(" SELECT doc.ID,doc.DoctorID,concat(dm.Title,' ',dm.Name)DoctorName,TotalGrossAmt GrossAmount,TotalDiscount Discount,");
            //        //sb.Append(" TotalNetAmt NetAmount,TotalPaidAmount PaidAmount,DoctorShare,TDS,PayableAmt PayableAmount,DATE_FORMAT(doc.FromDate,'%d-%b-%Y')FromDate, ");
            //        //sb.Append(" DATE_FORMAT(doc.ToDate,'%d-%b-%Y')ToDate,OPDCashShare,OPDCreditShare,IPDCashShare,IPDCreditShare from da_docsharemaster doc inner join Doctor_master dm on doc.doctorID=dm.DoctorID where doc.IsPost=1 ");

            //        sb.Append(" SELECT doc.ID,doc.DoctorID,concat(dm.Title,' ',dm.Name)DoctorName,TotalGrossAmt GrossAmount,TotalDiscount Discount,TotalNetAmt NetAmount,DATE_FORMAT(doc.FromDate,'%d-%b-%Y')FromDate, ");//TotalPaidAmount PaidAmount

            //        if (rblType.SelectedItem.Value == "1" && rblPaymentType.SelectedItem.Value == "1")
            //        {
            //            sb.Append(" OPDCashShare AS DoctorShare,0 TDS,OPDCashShare AS PayableAmount, ");
            //        }
            //        else if (rblType.SelectedItem.Value == "1" && rblPaymentType.SelectedItem.Value == "2")
            //        {
            //            sb.Append(" OPDCreditShare AS DoctorShare,0 TDS,OPDCreditShare AS PayableAmount, ");
            //        }
            //        else if (rblType.SelectedItem.Value == "2" && rblPaymentType.SelectedItem.Value == "1")
            //        {
            //            sb.Append(" IPDCashShare AS DoctorShare,0 TDS,IPDCashShare AS PayableAmount, ");
            //        }
            //        else if (rblType.SelectedItem.Value == "2" && rblPaymentType.SelectedItem.Value == "2")
            //        {
            //            sb.Append(" IPDCreditShare AS DoctorShare,0 TDS,IPDCreditShare AS PayableAmount, ");
            //        }
            //        else if (rblType.SelectedItem.Value == "3" && rblPaymentType.SelectedItem.Value == "1")
            //        {
            //            sb.Append(" (OPDCashShare+IPDCashShare) AS DoctorShare,0 TDS,(OPDCashShare+IPDCashShare) AS PayableAmount, ");
            //        }
            //        else if (rblType.SelectedItem.Value == "3" && rblPaymentType.SelectedItem.Value == "2")
            //        {
            //            sb.Append(" (OPDCreditShare+IPDCreditShare) AS DoctorShare,0 TDS,(OPDCreditShare+IPDCreditShare) AS PayableAmount, ");
            //        }
            //        else if (rblType.SelectedItem.Value == "1" && rblPaymentType.SelectedItem.Value == "3")
            //        {
            //            sb.Append(" (OPDCashShare+OPDCreditShare) AS DoctorShare,0 TDS,(OPDCashShare+OPDCreditShare) AS PayableAmount, ");
            //        }
            //        else if (rblType.SelectedItem.Value == "2" && rblPaymentType.SelectedItem.Value == "3")
            //        {
            //            sb.Append(" (IPDCashShare+IPDCreditShare) AS DoctorShare,0 TDS,(IPDCashShare+IPDCreditShare) AS PayableAmount, ");
            //        }
            //        else
            //        {
            //            sb.Append("DoctorShare,TDS,PayableAmt PayableAmount, ");
            //        }

            //        sb.Append(" DATE_FORMAT(doc.ToDate,'%d-%b-%Y')ToDate,OPDCashShare,OPDCreditShare,IPDCashShare,IPDCreditShare from da_docsharemaster doc inner join Doctor_master dm on doc.doctorID=dm.DoctorID where doc.IsPost=1 ");

            //        if (ddlDoctor.SelectedIndex != 0)
            //        {
            //            sb.Append(" AND doc.doctorID='" + ddlDoctor.SelectedItem.Value + "'  ");
            //        }

            //        if (ddlDate.SelectedIndex != 0)
            //        {
            //            sb.Append(" AND doc.fromdate=('" + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[0]).ToString("yyyy-MM-dd") + "')");
            //            sb.Append(" AND doc.todate=('" + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[1]).ToString("yyyy-MM-dd") + "')");
            //        }

            //        DataTable dt = StockReports.GetDataTable(sb.ToString());

            //        StringBuilder sb1 = new StringBuilder();
            //        sb1.Append(" SELECT doc.MasterID,doc.DoctorID,doc.ReceiptNo,GrossAmount,Discount,NetAmount,PaidAmount,DoctorSharePercentage,DoctorShare, ");
            //        sb1.Append(" TypeOfTnx,SubCategoryName,doc.PatientID,CONCAT(pm.Title,Pm.Pname)PName,DATE_FORMAT(doc.FromDate,'%d-%b-%Y')FromDate, ");
            //        sb1.Append(" DATE_FORMAT(doc.ToDate,'%d-%b-%Y')ToDate,DATE_FORMAT(doc.BillDate,'%d-%b-%Y')BillDate,Type,IF(doc.PaymentType=1,'CASH','CREDIT')PaymentType FROM da_doctorsharedetail doc INNER JOIN ");
            //        sb1.Append(" Doctor_master dm ON doc.doctorID=dm.DoctorID INNER JOIN patient_master pm ON pm.PatientID=doc.PatientID ");

            //        if (ddlDoctor.SelectedIndex != 0)
            //        {
            //            sb1.Append(" AND doc.doctorID='" + ddlDoctor.SelectedItem.Value + "'  ");
            //        }

            //        if (ddlDate.SelectedIndex != 0)
            //        {
            //            sb1.Append(" AND doc.fromdate=('" + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[0]).ToString("yyyy-MM-dd") + "')");
            //            sb1.Append(" AND doc.todate=('" + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[1]).ToString("yyyy-MM-dd") + "')");
            //        }

            //        if (rblType.SelectedItem.Value != "3")
            //        {
            //            sb1.Append(" AND doc.Type='" + rblType.SelectedItem.Text + "'");
            //        }

            //        if (rblPaymentType.SelectedItem.Value != "3")
            //        {
            //            sb1.Append(" AND doc.PaymentType='" + rblPaymentType.SelectedItem.Value + "'");
            //        }

            //        sb1.Append(" Order by doc.BillDate");
            //        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());

            //        DataSet ds = new DataSet();
            //        ds.Tables.Add(dt.Copy());
            //        ds.Tables[0].TableName = "Master";
            //        ds.Tables.Add(dt1.Copy());
            //        ds.Tables[1].TableName = "Detail";

            //        if (ds.Tables[0].Rows.Count > 0 && ds.Tables[1].Rows.Count > 0)
            //        {
            //            string reportHeader = string.Empty;

            //            if (rblType.SelectedItem.Value == "3" && rblPaymentType.SelectedItem.Value == "3")
            //                reportHeader = " Doctor Share Detail Report ";
            //            else
            //                reportHeader = " Doctor Share Detail Report (" + rblType.SelectedItem.Text.ToUpper() + "-" + rblPaymentType.SelectedItem.Text.ToUpper() + ")";

            //            DataColumn dc = new DataColumn();
            //            dc.ColumnName = "ReportHeader";
            //            dc.DefaultValue = reportHeader;

            //            ds.Tables["Master"].Columns.Add(dc);
            //            ds.AcceptChanges();

            //            Session["ds"] = ds;
            //            //ds.WriteXmlSchema("E:/DoctorShareDetail.xml");
            //            Session["ReportName"] = "DoctorShareDetail";
            //            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);
            //        }
            //        else
            //        {
            //            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            //        }
            //    }
            //}

            StringBuilder sb = new StringBuilder();
            sb.Append(" CALL DocShareReport('" + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[0]).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[1]).ToString("yyyy-MM-dd") + "'," + Util.GetInt(rbtDoctorType.SelectedItem.Value) + ",'" + Util.GetString(ddlDoctor.SelectedItem.Value) + "','" + Util.GetInt(rblReportType.SelectedItem.Value) + "','" + Util.GetString(rblType.SelectedItem.Text) + "')");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {

                Session["ReportName"] = " Doctor Share " + rblReportType.SelectedItem.Text + "(" + rbtPostedStatus.SelectedItem.Text + ") Report ";
                Session["dtExport2Excel"] = dt;
                Session["Period"] = "Doctor Share Report From " + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[0]).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ddlDate.SelectedItem.Value.ToString().Split('#')[1]).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        else
        {
            lblMsg.Text = "Please Select Date";
            ddlDate.Focus();
            return;
        }
    }

    protected void rblReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rblReportType.SelectedIndex == 0)
        {
            rblReportFormat.Visible = false;
            lblReportFormat.Visible = false;
        }
        else
        {
            rblReportFormat.Visible = false;
            lblReportFormat.Visible = false;
        }
    }

    protected void rbtPostedStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindDate();
    }

    protected void rbtDoctorType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDoctor();
    }
}