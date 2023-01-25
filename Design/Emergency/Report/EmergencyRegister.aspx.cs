using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_Emergency_Report_EmergencyRegister : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            txtFromTime.Text = "00:00 AM";
            txtToTime.Text = "11:59 PM";
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string centreid = StockReports.GetSelection(chkCentre);
        if (String.IsNullOrEmpty(centreid))
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        if (rbtnReportType.SelectedValue == "4" || rbtnReportType.SelectedValue == "5")
        {
            sb.Append("SELECT IF(epd.IsReleased=1,'YES','NO')IsReleased,lt.BillNo,DATE_FORMAT(epd.EnteredOn,'%d-%b-%Y')AdmissionDate,lt.PatientID,epd.EmergencyNo,lt.NetAmount FROM emergency_patient_details epd ");
            sb.Append("LEFT JOIN f_ledgertransaction lt ON lt.TransactionID=epd.TransactionId AND lt.LedgertransactionNo=epd.LedgerTransactionNo ");
            sb.Append("WHERE epd.EmergencyNo<>'' ");
            if (rbtnReportType.SelectedValue == "4")
                sb.Append("AND lt.NetAmount<>0 AND IFNULL(lt.BillNo,'')='' AND epd.IsReleased IN (0,1,2) ");
            if (rbtnReportType.SelectedValue == "5")
                sb.Append(" AND epd.IsReleased IN (0) ");
            sb.Append("AND DATE(epd.EnteredOn)<= CURRENT_DATE() AND lt.CentreID=" + Session["CentreID"].ToString() + "; ");
        }
        else
        {
            sb.Append("SELECT epd.EmergencyNo,pm.PatientID AS UHID,CONCAT(pm.Title,'',pm.PName)PatientName,pm.Age,pm.Gender,CONCAT(dm.Title,' ',dm.Name)DoctorName,HOUR(TIMEDIFF(epd.EnteredOn,epd.ReleasedDateTime))StayHour, ");
            sb.Append("DATE_FORMAT(epd.EnteredOn,'%d-%b-%y %h:%m:%s %p') AS AdmissionDate,IFNULL(DATE_FORMAT(epd.ReleasedDateTime,'%d-%b-%y %h:%m:%s %p'),'') AS DischargeDate,  ");
            sb.Append("(CASE WHEN epd.IsReleased=0 THEN 'Admitted' WHEN epd.IsReleased=1 THEN 'Discharge' WHEN epd.IsReleased=2 THEN 'Released For IPD' WHEN epd.IsReleased=3 THEN 'Shift To IPD' ELSE '' END) STATUS,ltd.ItemName,fpm.Company_Name PanelName, ");
            if (rdbgroupwise.SelectedValue == "B")
                sb.Append("Round(lt.GrossAmount,2)GrossAmount,Round(lt.DiscountOnTotal,2)DiscountOnTotal,Round(lt.NetAmount,2)NetAmount,Round(IFNULL((SELECT SUM(r.AmountPaid) FROM f_reciept r WHERE r.AsainstLedgerTnxNo=epd.LedgerTransactionNo AND r.IsCancel=0),0),2)Collection,ROUND(ifnull((SELECT SUM(pa.Amount) FROM panel_amountallocation pa WHERE pa.TransactionID=epd.TransactionID),0),2)PanelAllocation, ");
            else if (rdbgroupwise.SelectedValue == "C" || rdbgroupwise.SelectedValue == "S")
                sb.Append("Round(SUM(ltd.Amount),2) NetAmount, ");
            else if (rdbgroupwise.SelectedValue == "I")
                sb.Append("Round(SUM(ltd.Rate),2)Rate,Round(SUM(ltd.Quantity),2)Quantity,Round(SUM(ltd.DiscAmt),2)DiscountAmount,Round(SUM(ltd.Amount),2) NetAmount, ");
            sb.Append("lt.BillNo,IF(lt.BillNo!='',IFNULL(DATE_FORMAT(lt.BillDate,'%d-%b-%y %h:%m:%s %p'),''),'') AS BillDate,tr.CodeType TriagingCode, ");
            sb.Append("IFNULL( IF(IFNULL(scm.DisplayName,'')!='',DisplayName,scm.Name),'')SubGroupName,ca.Name AS GroupName,pmh.DischargeType,cm.CentreName ");
            sb.Append("FROM emergency_patient_details epd INNER JOIN patient_medical_history pmh ON pmh.TransactionID=epd.TransactionId ");
            sb.Append("INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
            sb.Append("LEFT JOIN f_ledgertransaction lt ON lt.TransactionID=pmh.TransactionID ");
            sb.Append("LEFT JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgertransactionNo ");
            sb.Append("LEFT JOIN f_subcategorymaster scm ON scm.SubCategoryID=ltd.SubCategoryID ");
            sb.Append("LEFT JOIN f_categorymaster ca ON ca.CategoryID=scm.CategoryID ");
            sb.Append("LEFT JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
            sb.Append("INNER JOIN f_panel_master fpm on fpm.PanelID=pmh.PanelID ");
            sb.Append("LEFT JOIN emr_triagingcodes tr ON tr.ID=pmh.TriagingCode LEFT JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
            sb.Append("WHERE pmh.TransactionID<>'' ");
            if (rbtnReportType.SelectedValue != "-1")
                sb.Append("AND epd.IsReleased='" + rbtnReportType.SelectedValue + "' ");
            if (!String.IsNullOrEmpty(txtUHID.Text.Trim()))
                sb.Append("AND pm.PatientID='" + Util.GetFullPatientID(txtUHID.Text.Trim()) + "' ");
            if (!String.IsNullOrEmpty(txtEmergencyNo.Text.Trim()))
                sb.Append("AND epd.EmergencyNo='" + txtEmergencyNo.Text.Trim() + "' ");
            if (!String.IsNullOrEmpty(txtBillNo.Text.Trim()))
                sb.Append("AND lt.BillNo='" + txtBillNo.Text.Trim() + "' ");
            if (centreid != "")
                sb.Append("AND pmh.CentreID IN (" + centreid + ") ");
            if (String.IsNullOrEmpty(txtBillNo.Text.Trim()) && String.IsNullOrEmpty(txtEmergencyNo.Text.Trim()) && String.IsNullOrEmpty(txtUHID.Text.Trim()))
                sb.Append("AND epd.EnteredOn>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND epd.EnteredOn<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtToTime.Text).ToString("HH:mm:ss") + "' ");
            //sb.Append("AND lt.BillDate>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.BillDate<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
            if (rdbgroupwise.SelectedValue == "B")
                sb.Append("GROUP BY pmh.TransactionID ");
            else if (rdbgroupwise.SelectedValue == "S")
                sb.Append("GROUP BY pmh.TransactionID ,if(ifnull(scm.DisplayName,'')!='',DisplayName,scm.SubCategoryID) ");//ID
            else if (rdbgroupwise.SelectedValue == "C")
                sb.Append("GROUP BY pmh.TransactionID ,ca.CategoryID  ");//ID
            else if (rdbgroupwise.SelectedValue == "I")
                sb.Append("GROUP BY ltd.ID  ");
            if (rdbgroupwise.SelectedValue == "C" && rdbgroupwise.SelectedValue == "S")
                sb.Append("ORDER BY scm.DisplayPriority+1");
            else
                sb.Append("ORDER BY lt.Date,lt.Time ASC");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());


        if (dt.Rows.Count > 0)
        {
            if (rbtnReportType.SelectedValue == "4" || rbtnReportType.SelectedValue == "5") {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Not Bill Generate/Release";
                Session["Period"] = "As On" + DateTime.Now.ToString("dd-MM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/ExportToExcel.aspx');", true);
            }
            else
            {
                if (rdbgroupwise.SelectedValue == "B")
                {
                    dt.Columns.Remove("SubGroupName");
                    dt.Columns.Remove("GroupName");
                    dt.Columns.Remove("ItemName");
                    Session["dtExport2Excel"] = dt;
                    Session["ReportName"] = "Emergency Bill Register(Bill Wise)";
                    Session["Period"] = "From : " + ucFromDate.Text.Trim() + " To : " + ucToDate.Text.Trim();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/ExportToExcel.aspx');", true);
                }
                else if (rdbgroupwise.SelectedValue == "I")
                {
                    Session["dtExport2Excel"] = dt;
                    Session["ReportName"] = "Emergency Bill Register(Item Wise)";
                    Session["Period"] = "From : " + ucFromDate.Text.Trim() + " To : " + ucToDate.Text.Trim();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/ExportToExcel.aspx');", true);
                }
                else if (rdbgroupwise.SelectedValue == "C" || rdbgroupwise.SelectedValue == "S")
                {

                    DataTable dtMerge = new DataTable();
                    dtMerge.Columns.Add("CentreName", typeof(string));
                    dtMerge.Columns.Add("BillNo", typeof(string));
                    dtMerge.Columns.Add("PatientName", typeof(string));
                    dtMerge.Columns.Add("Age", typeof(string));
                    dtMerge.Columns.Add("Gender", typeof(string));
                    dtMerge.Columns.Add("EmergencyNo", typeof(string));
                    dtMerge.Columns.Add("UHID", typeof(string));
                    dtMerge.Columns.Add("AdmissionDate", typeof(string));

                    dtMerge.Columns.Add("DischargeDate", typeof(string));
                    dtMerge.Columns.Add("STATUS", typeof(string));
                    dtMerge.Columns.Add("BillDate", typeof(string));
                    dtMerge.Columns.Add("TriagingCode", typeof(string));
                    dtMerge.Columns.Add("DischargeType", typeof(string));

                    dtMerge.Columns.Add("NetAmount", typeof(decimal));
                    foreach (DataRow drSub in dt.Rows)
                    {
                        if (dtMerge.Columns.Contains(drSub["SubGroupName"].ToString()) == false)
                        {
                            if (!string.IsNullOrEmpty(drSub["SubGroupName"].ToString()))
                            {
                                dtMerge.Columns.Add(drSub["SubGroupName"].ToString());
                                dtMerge.Columns[drSub["SubGroupName"].ToString()].DataType = System.Type.GetType("System.Decimal");
                            }
                        }
                    }
                    foreach (DataRow dr in dt.Rows)
                    {
                        DataRow[] RowCreated = dtMerge.Select("EmergencyNo='" + dr["EmergencyNo"].ToString() + "'");

                        if (RowCreated.Length == 0)
                        {
                            DataRow[] RowExist = dt.Select("EmergencyNo='" + dr["EmergencyNo"].ToString() + "'");

                            if (RowExist.Length > 0)
                            {
                                DataRow row = dtMerge.NewRow();

                                decimal netAmt = 0;
                                foreach (DataRow NewRow in RowExist)
                                {
                                    row["CentreName"] = NewRow["CentreName"].ToString();
                                    row["UHID"] = NewRow["UHID"].ToString();
                                    row["PatientName"] = NewRow["PatientName"].ToString();
                                    row["Age"] = NewRow["Age"].ToString();
                                    row["Gender"] = NewRow["Gender"].ToString();
                                    row["EmergencyNo"] = NewRow["EmergencyNo"].ToString();
                                    row["BillNo"] = NewRow["BillNo"].ToString();
                                    row["AdmissionDate"] = NewRow["AdmissionDate"].ToString();
                                    row["DischargeDate"] = NewRow["DischargeDate"].ToString();
                                    row["STATUS"] = NewRow["STATUS"].ToString();
                                    row["BillDate"] = NewRow["BillDate"].ToString();
                                    row["TriagingCode"] = NewRow["TriagingCode"].ToString();
                                    row["DischargeType"] = NewRow["DischargeType"].ToString();

                                    //Pushing the Value of Amount having respective column name that is created above by SubCategory
                                    if (!string.IsNullOrEmpty(NewRow["SubGroupName"].ToString()))
                                        row[NewRow["SubGroupName"].ToString()] = NewRow["NetAmount"];

                                    netAmt = Util.GetDecimal(NewRow["NetAmount"]) + netAmt;
                                }
                                row["NetAmount"] = netAmt;
                                dtMerge.Rows.Add(row);
                            }
                        }
                    }
                    int sumstart = 13;
                    if (dtMerge.Rows.Count > 0)
                    {
                        for (int i = sumstart; i < dtMerge.Columns.Count; i++)
                        {
                            dtMerge.Columns[i].ColumnName = dtMerge.Columns[i].ColumnName.Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "").Replace("*", "");
                        }

                        DataRow row = dtMerge.NewRow();
                        for (int i = sumstart; i < dtMerge.Columns.Count; i++)
                        {
                            row[i] = dtMerge.Compute("sum(" + dtMerge.Columns[i].ColumnName + ")", "");
                        }
                        dtMerge.Rows.Add(row);

                        if (dtMerge.Rows.Count > 0)
                        {
                            for (int i = sumstart; i < dtMerge.Columns.Count; i++)
                            {
                                dtMerge.Columns[i].ColumnName = dtMerge.Columns[i].ColumnName.Replace(" ", "").Replace("&", "").Replace("_", "").Replace("-", "").Replace(".", "").Replace("(", "").Replace(")", "").Replace("/", "").Replace(",", "").Replace("*", "");
                            }
                        }
                    }
                    Session["dtExport2Excel"] = dtMerge;
                    if (rdbgroupwise.SelectedValue == "S")
                        Session["ReportName"] = "Emergency_Bill_Register(Sub Category Wise)";
                    else if (rdbgroupwise.SelectedValue == "C")
                        Session["ReportName"] = "Emergency_Bill_Register(Category Wise)";
                    Session["Period"] = "From : " + ucFromDate.Text.Trim() + " To : " + ucToDate.Text.Trim();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/ExportToExcel.aspx');", true);
                }
            }
        }
        else
            lblMsg.Text = "No Record Found";
    }
}