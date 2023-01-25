using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web;
using System.Web.Script.Services;
using System.Collections.Generic;

public partial class Design_OPD_DoctorRelatedOPDReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CalendarExteFromDate.EndDate = System.DateTime.Now;
            CalendarExtenderToDate.EndDate = System.DateTime.Now;

            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindReferDoctor(ddlReferDoctor, "Select");
            BindGroup();
            bindPRO();
            ViewState["UserID"] = Session["ID"].ToString();
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }

    private void BindGroup()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DocType,ID FROM DoctorGroup WHERE isActive=1");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDoctorGroup.DataSource = dt;
            ddlDoctorGroup.DataTextField = "DocType";
            ddlDoctorGroup.DataValueField = "ID";
            ddlDoctorGroup.DataBind();
            ddlDoctorGroup.Items.Insert(0, new ListItem("Select"));
        }
    }

    public static void bindReferDoctor(DropDownList ddlObject, string type = "")
    {
        DataTable dtData = LoadCacheQuery.loadReferDoctor();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "DoctorID";
            ddlObject.DataBind();
            if (type != "")
                ddlObject.Items.Insert(0, new ListItem(type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }

    private void bindPRO()
    {
        DataTable dt = AllLoadData_IPD.bindProMaster();
        if (dt.Rows.Count > 0)
        {
            ddlProName.DataSource = dt;
            ddlProName.DataTextField = "ProName";
            ddlProName.DataValueField = "pro_id";
            ddlProName.DataBind();
            ddlProName.Items.Insert(0, new ListItem("All", "0"));
        }
    }

    [WebMethod]
    public static string GetReportData(string ReportType, string fromDate, string toDate, string Center, string Doctor, string DoctorGroup, string PatientType, string AppStatus, string ReferDoctor, string ProName, string PID, string IPDNo, string rdoAppType, string rdoVisitType, string rdoAmtType, string rdoPatientType, string rdoReportType, bool isPackage)
    {
        StringBuilder sb = new StringBuilder();
        string DoctorID = "";
        int PackageCondition = 0;
        string DocGroup = "0";

        if (ReportType == "PROR")
        {
            sb.Clear();
            sb.Append(" SELECT cm.CentreName,cm.CentreID,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PName,IF(pm.Gender='Male','M','F')Gender,pm.Age,CONCAT(pm.House_No,IF(pm.House_No!='',',',''),pm.City,',',pm.Country )Address,fpm.ProName,fpm.Pro_ID,REPLACE(pmh.TransactionID,'ISHHI','')IPDNo,DATE_FORMAT(pmh.dateofVisit,'%d-%b-%Y')DateOfVisit,dr.`Name` drname ");
            sb.Append(" FROM f_pro_master fpm INNER JOIN patient_medical_history pmh ON pmh.ProID=fpm.Pro_ID INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID LEFT JOIN  doctor_referal dr  ON pmh.referedBy=dr.DoctorID WHERE pmh.ProID<>0 AND cm.CentreID IN (" + Center + ") ");
            if (IPDNo.Trim() != "")
                sb.Append(" AND pmh.TransactionID='ISHHI" + IPDNo.Trim() + "' ");
            if (PID.Trim() != "")
                sb.Append(" AND pm.PatientID='" + PID.Trim() + "' ");
            if (ProName != "0")
                sb.Append(" AND pmh.referedBy='" + ProName + "'");
            if (PID.Trim() == "" && IPDNo.Trim() == "" && ProName == "0")
                sb.Append(" AND date(pmh.DateofVisit)>='" + (Convert.ToDateTime(fromDate)).ToString("yyyy-MM-dd") + "'  AND date(pmh.DateofVisit)<='" + (Convert.ToDateTime(toDate)).ToString("yyyy-MM-dd") + "'");

             DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {           
            DataColumn dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            dc.DefaultValue = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

           // ds.WriteXmlSchema("F:\\PROReport.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "PROReport";
            return "1";
        }
        else
            return "0";
        }

        if (ReportType == "DRFFR")
        {
            sb.Clear();
            sb.Append(" SELECT cm.CentreName,cm.CentreID,pm.PatientID,pmh.Type,CONCAT(pm.Title,' ',pm.PName)PName,IF(pm.Gender='Male','M','F')Gender,CONCAT(pm.Age,'/',IF(pm.Gender='Male','M','F'))Age,CONCAT(pm.House_No,IF(pm.House_No!='',',',''),pm.City,',',pm.Country )Address, dr.Name,dr.DoctorID,IF(pmh.Type='IPD',REPLACE(pmh.TransactionID,'ISHHI',''),'')IPDNo,DATE_FORMAT(pmh.dateofVisit,'%d-%b-%Y')DateOfVisit,fpm.ProName ,pnl.Company_Name ");
            sb.Append(" ,pm.Mobile,IFNULL(lt.BillNo,'')BillNo,IFNULL(lt.NetAmount,'')NetAmount,IF(lt.typeoftnx='IPD-Room-Shift','ADMISSION',lt.typeoftnx)Category ");
            sb.Append(" FROM doctor_referal dr INNER JOIN patient_medical_history pmh ON pmh.referedBy=dr.DoctorID INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.TransactionID=pmh.TransactionID ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID left join f_pro_master fpm on pmh.ProID=fpm.Pro_ID INNER JOIN f_panel_master pnl ON pmh.`PanelID`=pnl.`PanelID` WHERE pmh.referedBy<>'' AND cm.CentreID IN (" + Center + ") ");

            if (IPDNo.Trim() != "")
                sb.Append(" AND pmh.TransactionID='ISHHI" + IPDNo.Trim() + "' ");
            if (PID.Trim() != "")
                sb.Append(" AND pm.PatientID='" + PID.Trim() + "' ");
            if (ReferDoctor != "0")
                sb.Append(" AND pmh.referedBy='" + ReferDoctor + "'");
            if (rdoPatientType != "3")
            {
                if (rdoPatientType == "1")
                    sb.Append(" AND pmh.Type='OPD' ");
                else
                    sb.Append(" AND pmh.Type='IPD' ");
            }
             if (PID.Trim() == "" && IPDNo.Trim() == "" && ReferDoctor == "0")
                 sb.Append(" AND date(pmh.DateofVisit)>='" + (Convert.ToDateTime(fromDate)).ToString("yyyy-MM-dd") + "'  AND date(pmh.DateofVisit)<='" + (Convert.ToDateTime(toDate)).ToString("yyyy-MM-dd") + "'");
             sb.Append(" group by pm.PatientID ORDER BY date(pmh.DateofVisit)"); 

             DataTable dt = StockReports.GetDataTable(sb.ToString());
             if (dt.Rows.Count > 0)
             {
                 DataColumn dc = new DataColumn();
                 dc.ColumnName = "ReportDate";
                 dc.DefaultValue = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
                 dt.Columns.Add(dc);

                 dc = new DataColumn();
                 dc.ColumnName = "UserName";
                 dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                 dt.Columns.Add(dc);
                 DataSet ds = new DataSet();
                 ds.Tables.Add(dt.Copy());

                 //ds.WriteXmlSchema("E:\\DoctorRefer.xml");
                 HttpContext.Current.Session["ds"] = ds;
                 HttpContext.Current.Session["ReportName"] = "DoctorRefer";
                 return "1";
             }
             else
                 return "0";
        }      

        if (ReportType == "BSSRPT")
        {
            string Typeoftnx = StockReports.ExecuteScalar("SELECT GetTypeoftnx('OPD')");
            sb.Clear();
            sb.Append(" SELECT t.DoctorID,t.doctor ,t.TypeOfTnx,CentreID,CentreName, ");
            if (rdoAmtType == "1")
                sb.Append(" SUM(t.GrossAmount1)GrossAmount ");
            else
                sb.Append("sum(t.netamt) GrossAmount ");
            sb.Append(" FROM (SELECT pmh.DoctorID,CONCAT(dm.title,' ',dm.Name)Doctor,REPLACE(IF(lt.TypeOfTnx='OPD-LAB','DIAGNOSIS',lt.TypeOfTnx),'OPD-','')TypeOfTnx1, ");
            sb.Append("  ltd.rate*ltd.Quantity GrossAmount1, ltd.rate,ltd.Quantity ,lt.GrossAmount,cm.ConfigID,cm.Name,lt.LedgerTransactionNo, ");
            sb.Append("  IF(cm.`ConfigID`=5,'APPOINTMENT',IF(cm.`ConfigID`=3,'DIAGNOSIS',IF(cm.`ConfigID`=25,'PROCEDURE','OTHERS')))TypeOfTnx, ");
            sb.Append("  ltd.Amount netamt,lt.CentreID,cem.CentreName ");
            sb.Append("  FROM f_ledgertransaction lt  ");
            sb.Append("  INNER JOIN  f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo ");
            sb.Append("  INNER JOIN  f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubCategoryID ");
            sb.Append("  INNER JOIN f_configrelation cm ON sm.CategoryID=cm.CategoryID ");
            sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.transactionID=lt.transactionID    ");
            sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID   ");
            sb.Append("  INNER JOIN Center_master cem ON cem.CentreID = lt.CentreID   ");
            sb.Append("  WHERE lt.TypeOFtnx IN (" + Typeoftnx + ") AND lt.CentreID IN (" + Center + ") ");
            sb.Append("  AND lt.IsCancel=0 and lt.date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND lt.date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' )  t  GROUP BY t.CentreID,t.DoctorID,t.TypeOfTnx  ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ReportDate";
                if ((fromDate != "") && (toDate != ""))
                    dc.DefaultValue = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = Convert.ToString(HttpContext.Current.Session["LoginName"]);
                dt.Columns.Add(dc);
                dc = new DataColumn();
                dc.ColumnName = "ReportName";

                string Text = "";
                if (rdoAmtType == "1")
                    Text = "Gross Amt.";
                else
                    Text = "Net Amt.";

                dc.DefaultValue = "Doctor Wise OPD Business " + "(" + Text + ")";
                dt.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                // ds.WriteXmlSchema(@"E:\DoctorWiseBusiness.xml");
                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "DoctorWiseBusiness";
                return "1";
            }
            else
                return "0";
        }
       
        if (ReportType == "DAPPSRPT")
        {           
            if (DoctorGroup != "Select")
            {
                DocGroup = DoctorGroup;
            }
            if (isPackage)
                PackageCondition = 1;

            DataTable dtAppDetail = AllLoadData_OPD.DoctorWiseOPDSummary("", Util.GetDateTime(fromDate), Util.GetDateTime(toDate), PackageCondition, Center, DocGroup);

            if (dtAppDetail.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
                dtAppDetail.Columns.Add(dc);

                DataColumn dc2 = new DataColumn();
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                dc2.ColumnName = "UserName";
                dc2.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                dtAppDetail.Columns.Add(dc2);
                DataSet ds = new DataSet();
                ds.Tables.Add(dtAppDetail.Copy());
                ds.Tables.Add(dtImg.Copy());
                HttpContext.Current.Session["ds"] = ds;
                // ds.WriteXmlSchema(@"E:\DoctorWiseAppointmentSummary.xml");
                HttpContext.Current.Session["ReportName"] = "DoctorWiseAppointmentSummary";
                return "1";
            }
            else
                return "0";

        }
      
        if (ReportType == "DAPPDRPT")
        {
            if (Doctor != "0")
            {
                DoctorID = Doctor;
            }
            if (DoctorGroup != "Select")
            {
                DocGroup = DoctorGroup;
            }
            if (rdoAppType == "0")
            {
                if (isPackage)
                    PackageCondition = 1;

                DataTable dtAppDetail = AllLoadData_OPD.DoctorWiseOPDDetail(DoctorID, Util.GetDateTime(fromDate), Util.GetDateTime(toDate), PackageCondition, Center, DocGroup);

                if (dtAppDetail.Rows.Count > 0)
                {
                    DataColumn dc = new DataColumn();
                    DataTable dtImg = All_LoadData.CrystalReportLogo();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
                    dtAppDetail.Columns.Add(dc);
                    dc = new DataColumn();
                    dc.ColumnName = "UserName";
                    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                    dtAppDetail.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dtAppDetail.Copy());
                    ds.Tables.Add(dtImg.Copy());

                    HttpContext.Current.Session["ds"] = ds;
                    //ds.WriteXmlSchema(@"D:\DoctorWiseAppointmentDetail.xml");
                    HttpContext.Current.Session["ReportName"] = "DoctorWiseAppointmentDetail";                   
                    return "1";
                }
                else
                    return "0";
            }
            else
            {
                sb.Clear();
                sb.Append(" SELECT cm.CentreID,cm.CentreName,app.PatientID,app.Pname As Patient_Name,dm.Name AS Doctor_Name,if(app.visitType='Old Patient','Review Patient','New Patient')`Patient Type` FROM appointment app inner join center_master cm on cm.CentreID= app.CentreID INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID where  app.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND app.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' And app.PatientID<>'' and app.CentreID IN (" + Center + ") ");
                if (DoctorID != "")
                    sb.Append(" AND app.DoctorID='" + DoctorID + "' ");
                if (rdoVisitType == "1")
                    sb.Append(" AND app.visitType='Old Patient' ");
                else if (rdoVisitType == "2")
                    sb.Append(" AND app.visitType='New Patient' ");
                sb.Append(" order by cm.centreID");
                DataTable dt = StockReports.GetDataTable(sb.ToString());
                if (dt.Rows.Count > 0)
                {
                    dt.Columns.Remove("CentreID");
                    dt.Columns["CentreName"].ColumnName = "Centre Name";
                    dt.Columns["PatientID"].ColumnName = "UHID";
                    dt.Columns["Patient_Name"].ColumnName = "Patient Name";
                    dt.Columns["Doctor_Name"].ColumnName = "Doctor Name";
                    HttpContext.Current.Session["Period"] = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
                    HttpContext.Current.Session["ReportName"] = "DoctorWisePatientStatus";
                    HttpContext.Current.Session["dtExport2Excel"] = dt;                   
                    return "2";
                }
                else
                {                   
                    return "0";
                }
            }
        }

        if (ReportType == "APPSTR")
        {
            if (Doctor != "0")
            {
                DoctorID = Doctor;
            }

            DataTable dtReport = AllLoadData_OPD.SearchAppointment(DoctorID, Util.GetDateTime(fromDate), Util.GetDateTime(toDate), "", "", PatientType, AppStatus,"", Center);

            if (dtReport != null && dtReport.Rows.Count > 0)
            {

                for (int i = 0; i < dtReport.Rows.Count; i++)
                {
                    if (dtReport.Rows[i]["IsConform"].ToString() == "0" && dtReport.Rows[i]["IsCancel"].ToString() == "0" && Util.GetDateTime(dtReport.Rows[i]["AppDateTime"]) < Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yy hh: mm tt")))
                    {
                        dtReport.Rows[i]["Status"] = "App Time Expired";
                    }
                    else
                    {
                        if (dtReport.Rows[i]["IsConform"].ToString() == "1")
                        {
                            dtReport.Rows[i]["Status"] = "Confirmed";
                        }
                        else if (dtReport.Rows[i]["IsCancel"].ToString() == "1")
                        {
                            dtReport.Rows[i]["Status"] = "Canceled";
                        }
                        else if (dtReport.Rows[i]["IsReschedule"].ToString() == "1")
                        {
                            dtReport.Rows[i]["Status"] = "ReScheduled";
                        }
                        else
                        {
                            dtReport.Rows[i]["Status"] = "Pending";
                        }
                    }
                    dtReport.AcceptChanges();
                }
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ReportDate";
                dc.DefaultValue = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
                dtReport.Columns.Add(dc);
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                dtReport.Columns.Add(dc);
                if (rdoReportType == "1")
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dtReport.Copy());
                   // ds.WriteXmlSchema(@"E:\AppConfirmationReport.xml");
                    HttpContext.Current.Session["ds"] = ds;
                    HttpContext.Current.Session["ReportName"] = "AppConfirmationReport";
                    return "1";
                }
                else
                {
                    dtReport.Columns.Remove("transactionid");
                    dtReport.Columns.Remove("App_ID");
                    dtReport.Columns.Remove("DoctorID");
                    dtReport.Columns.Remove("IsConform");
                    dtReport.Columns.Remove("IsReschedule");
                    dtReport.Columns.Remove("IsCancel");
                    dtReport.Columns.Remove("CancelReason");
                    dtReport.Columns.Remove("ConformDate");
                    dtReport.Columns.Remove("LedgerTnxNo");
                    dtReport.Columns.Remove("AppDateTime");
                    dtReport.Columns.Remove("CentreID");
                    dtReport.AcceptChanges();
                    dtReport.Columns[0].ColumnName = "MRNo";
                    dtReport.Columns[4].ColumnName = "Patient Type";
                    dtReport.Columns[2].ColumnName = "Patient Name";

                    HttpContext.Current.Session["dtExport2Excel"] = dtReport;
                    HttpContext.Current.Session["ReportName"] = "Appointment Status Report";
                    HttpContext.Current.Session["Period"] = dtReport.Rows[0]["ReportDate"].ToString();
                    return "2";
                }
            }
            else
                return "0";
        }

        return "0";
    }
}