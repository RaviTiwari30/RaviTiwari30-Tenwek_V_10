using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_BillRegister : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            bindPanel();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    private void bindPanel()
    {
        string PanelGroupID = string.Empty;
       
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  RTRIM(LTRIM(Company_Name)) AS Company_Name,PanelID,PanelGroupID FROM f_panel_master WHERE  IsActive=1 ");
        if (PanelGroupID != "")
            sb.Append(" AND PanelGroupID IN (" + PanelGroupID + ") ");
        sb.Append(" order by Company_Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            chkAllPanel.DataSource = dt;
            chkAllPanel.DataTextField = "Company_Name";
            chkAllPanel.DataValueField = "PanelID";
            chkAllPanel.DataBind();
        }
    }

    public void BindData()
    {
        lblMsg.Text = "";
        string centreid = StockReports.GetSelection(chkCentre);
        if (String.IsNullOrEmpty(centreid))
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string PanelID = string.Empty;
        foreach (ListItem li in chkAllPanel.Items)
        {
            if (li.Selected)
            {
                if (PanelID != string.Empty)
                    PanelID += "," + li.Value + " ";
                else
                    PanelID = "" + li.Value + "";
            }
        }
        StringBuilder sb = new StringBuilder();
        if (rbtnReportType.SelectedValue == "3")
        {
            sb.Append("select lt.BillNo,IF(lt.BillNo!='',IFNULL(CONCAT(DATE_FORMAT(lt.BillDate,'%d-%b-%y'),' ',TIME_FORMAT(lt.time,'%h:%i:%s %p')),''),'') AS BillDate,pm.PatientID AS UHID,CONCAT(pm.Title,'',pm.PName)PatientName,IFNULL(fpm.PanelGroup,'')PanelGroup,fpm.Company_Name AS PanelName,ltd.ItemName,   ");
            sb.Append(" ROUND(SUM(ltd.Rate),2)Rate,ROUND(SUM(ltd.Quantity),2)Quantity,ROUND(SUM(ltd.DiscAmt),2)DiscountAmount,ROUND(SUM(ltd.Amount),2) Amount,ROUND(lt.NetAmount,2)TotalBillAmount,ROUND(lt.Adjustment,2)TotalPaidAmount,ROUND((lt.NetAmount-lt.Adjustment),2)TotalOutStandingAmt, ");
            sb.Append(" (SELECT CONCAT(emp.`Title`,' ',emp.`NAME` ) FROM `employee_master` emp WHERE emp.`EmployeeID` =ltd.UserID)UserName ");
        }
        else
        {
            sb.Append("SELECT pm.PatientID AS UHID,CONCAT(pm.Title,'',pm.PName)PatientName,pm.Age,pm.Gender, ");
            sb.Append("DATE_FORMAT(ltd.EntryDate,'%d-%b-%y %h:%m:%s %p') AS EntryDate,ltd.ItemName,(SELECT CONCAT(dm.`Title`,' ',dm.`NAME` )DoctorName FROM `doctor_master` dm WHERE dm.`DoctorID` =pmh.DoctorID)DoctorName,  ");
            if (rdbgroupwise.SelectedValue == "B")
                sb.Append(" IFNULL(fpm.PanelGroup,'')PanelGroup,fpm.Company_Name as PanelName,Round(lt.GrossAmount,2)GrossAmount,Round(lt.DiscountOnTotal,2)DiscountOnTotal,Round(lt.NetAmount,2)NetAmount,Round(lt.Adjustment,2)PaidAmount,Round((lt.NetAmount-lt.Adjustment),2)BalanceAmt,GROUP_CONCAT(distinct rpd.`PaymentMode`)PaymentMode , ");
            else if (rdbgroupwise.SelectedValue == "C" || rdbgroupwise.SelectedValue == "S")
                sb.Append(" Round(lt.GrossAmount,2)GrossAmt,Round(SUM(ltd.Amount),2) NetAmount,Round(lt.DiscountOnTotal,2)DiscountOnTotal,Round(lt.Adjustment,2)PaidAmount,Round((lt.NetAmount-lt.Adjustment),2)BalanceAmt,GROUP_CONCAT(distinct rpd.`PaymentMode`)PaymentMode, ");
            else if (rdbgroupwise.SelectedValue == "I")
                sb.Append("Round(SUM(ltd.Rate),2)Rate,Round(SUM(ltd.Quantity),2)Quantity,Round(SUM(ltd.DiscAmt),2)DiscountAmount,Round(SUM(ltd.Amount),2) NetAmount, ");
            sb.Append("lt.BillNo,IF(lt.BillNo!='',IFNULL(CONCAT(DATE_FORMAT(lt.BillDate,'%d-%b-%y'),' ',TIME_FORMAT(lt.time,'%h:%i:%s %p')),''),'') AS BillDate, ");
            sb.Append("IF(IFNULL(scm.DisplayName,'')!='',DisplayName,scm.Name)SubGroupName,ca.Name AS GroupName,cm.CentreName, ");
            //Added one Column UserName 26Aug2022 - Pooja
            sb.Append(" (SELECT CONCAT(emp.`Title`,' ',emp.`NAME` ) FROM `employee_master` emp WHERE emp.`EmployeeID` =lt.UserID)UserName ");
        }
            sb.Append("FROM f_ledgertransaction lt INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append("INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgertransactionNo ");
        sb.Append("INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=ltd.SubCategoryID ");
        sb.Append("INNER JOIN f_categorymaster ca ON ca.CategoryID=scm.CategoryID ");
        sb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sb.Append("LEFT JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append("INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID LEFT JOIN `f_reciept` rc ON rc.`AsainstLedgerTnxNo`=lt.`LedgertransactionNo` LEFT JOIN `f_receipt_paymentdetail` rpd ON rc.`ReceiptNo`=rpd.`ReceiptNo` ");
        sb.Append("where lt.IsCancel=0 AND ltd.TypeOfTnx IN ('OPD-APPOINTMENT','OPD-LAB','OPD-PROCEDURE','OPD-OTHERS','OPD-PACKAGE','CASUALTY-BILLING','OPD-Advance','EMERGENCY','OPD Advance/Settlements')  ");
        if (rbtnReportType.SelectedValue == "3")
            sb.Append(" AND ROUND((lt.NetAmount-lt.Adjustment),2)>0 ");
        if (!String.IsNullOrEmpty(txtUHID.Text.Trim()))
            sb.Append("AND pm.PatientID='" + Util.GetFullPatientID(txtUHID.Text.Trim()) + "' ");
        if (!String.IsNullOrEmpty(txtBillNo.Text.Trim()))
            sb.Append("AND lt.BillNo='" + txtBillNo.Text.Trim() + "' ");
        if (centreid != "")
            sb.Append("AND pmh.CentreID IN (" + centreid + ") ");
        if (String.IsNullOrEmpty(txtBillNo.Text.Trim()) && String.IsNullOrEmpty(txtUHID.Text.Trim()))
        {
            sb.Append("AND lt.Date>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND ltd.EntryDate<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        if (PanelID != "")
            sb.Append(" AND pmh.PanelID IN (" + PanelID + ")   ");

        if (rdbgroupwise.SelectedValue == "B" && rbtnReportType.SelectedValue != "3")
            sb.Append("GROUP BY pmh.TransactionID ");
        else if (rdbgroupwise.SelectedValue == "S" && rbtnReportType.SelectedValue != "3")
            sb.Append("GROUP BY pmh.TransactionID ,if(ifnull(scm.DisplayName,'')!='',DisplayName,scm.SubCategoryID) ");//ID
        else if (rdbgroupwise.SelectedValue == "C" && rbtnReportType.SelectedValue != "3")
            sb.Append("GROUP BY pmh.TransactionID ,ca.CategoryID   ");//ID
        else if (rdbgroupwise.SelectedValue == "I" || rbtnReportType.SelectedValue == "3")
            sb.Append("GROUP BY ltd.ID  ");
        if (rdbgroupwise.SelectedValue == "C" && rdbgroupwise.SelectedValue == "S" && rbtnReportType.SelectedValue != "3")
            sb.Append("ORDER BY scm.DisplayPriority+1");
        else
            sb.Append("ORDER BY lt.Date,lt.Time ASC");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            if (rbtnReportType.SelectedValue == "3")
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "OPD Credit Report (Panelwise)";
                Session["Period"] = "From : " + ucFromDate.Text.Trim() + " To : " + ucToDate.Text.Trim();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/ExportToExcel.aspx');", true);
            }
            else if (rdbgroupwise.SelectedValue == "B")
            {
                dt.Columns.Remove("SubGroupName");
                dt.Columns.Remove("GroupName");
                dt.Columns.Remove("ItemName");
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "OPD Bill Register(Bill Wise)";
                Session["Period"] = "From : " + ucFromDate.Text.Trim() + " To : " + ucToDate.Text.Trim();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/ExportToExcel.aspx');", true);
            }
            else if (rdbgroupwise.SelectedValue == "I")
            {
               
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "OPD Bill Register(Item Wise)";
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
                dtMerge.Columns.Add("UHID", typeof(string));
                dtMerge.Columns.Add("EntryDate", typeof(string));
                dtMerge.Columns.Add("STATUS", typeof(string));
                dtMerge.Columns.Add("BillDate", typeof(string));
                dtMerge.Columns.Add("DoctorName", typeof(string));
                dtMerge.Columns.Add("PaymentMode", typeof(string));
                dtMerge.Columns.Add("GrossAmt", typeof(decimal));
                dtMerge.Columns.Add("NetAmount", typeof(decimal));
                dtMerge.Columns.Add("DiscountOnTotal", typeof(decimal));
                dtMerge.Columns.Add("PaidAmount", typeof(decimal));
                dtMerge.Columns.Add("BalanceAmt", typeof(decimal));
                
                

                foreach (DataRow drSub in dt.Rows)
                {
                    if (dtMerge.Columns.Contains(drSub["SubGroupName"].ToString()) == false)
                    {
                        dtMerge.Columns.Add(drSub["SubGroupName"].ToString());
                        dtMerge.Columns[drSub["SubGroupName"].ToString()].DataType = System.Type.GetType("System.Decimal");
                    }
                }
                foreach (DataRow dr in dt.Rows)
                {
                    DataRow[] RowCreated = dtMerge.Select("BillNo='" + dr["BillNo"].ToString() + "'");

                    if (RowCreated.Length == 0)
                    {
                        DataRow[] RowExist = dt.Select("BillNo='" + dr["BillNo"].ToString() + "'");

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
                                row["BillNo"] = NewRow["BillNo"].ToString();
                                row["EntryDate"] = NewRow["EntryDate"].ToString();
                                row["BillDate"] = NewRow["BillDate"].ToString();
                                row["BillNo"] = NewRow["BillNo"].ToString();

                                //Pushing the Value of Amount having respective column name that is created above by SubCategory
                                row[NewRow["SubGroupName"].ToString()] = NewRow["NetAmount"];
                                netAmt = Util.GetDecimal(NewRow["NetAmount"]) + netAmt;
                                row["DiscountOnTotal"] = NewRow["DiscountOnTotal"].ToString();
                                row["PaidAmount"] = NewRow["PaidAmount"].ToString();
                                row["BalanceAmt"] = NewRow["BalanceAmt"].ToString();
                                row["PaymentMode"] = NewRow["PaymentMode"].ToString();
                                row["GrossAmt"] = NewRow["GrossAmt"].ToString();
                                row["DoctorName"] = NewRow["DoctorName"].ToString();
                               
                            }
                            row["NetAmount"] = netAmt;
                            dtMerge.Rows.Add(row);
                        }
                    }
                }
                int sumstart = 11;
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
                    Session["ReportName"] = "OPD Bill Register(Sub Category Wise)";
                else if (rdbgroupwise.SelectedValue == "C")
                    Session["ReportName"] = "OPD Bill Register(Category Wise)";
                Session["Period"] = "From : " + ucFromDate.Text.Trim() + " To : " + ucToDate.Text.Trim();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/ExportToExcel.aspx');", true);
            }
        }
        else
            lblMsg.Text = "No Record Found";
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindData();
    }
}