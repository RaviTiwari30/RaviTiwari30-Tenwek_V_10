using System;
using System.Data;
using System.IO;
using System.Linq;

public partial class Design_IPD_VitalSignChart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                string folderName = @"c:\TempImageFiles";
                string TID = string.Empty;
                string transNo = string.Empty;
                if (!Directory.Exists(folderName))
                {
                    Directory.CreateDirectory(folderName);
                }

                if (Request.QueryString["TransactionID"] != null)
                {
                    TID = Request.QueryString["TransactionID"].ToString();
                }
                else
                {
                    TID = Request.QueryString["TID"].ToString();
                }

                string result = Util.GetString(StockReports.ExecuteScalar("SELECT CONCAT(TransNo,'#',Type) FROM patient_medical_history WHERE TransactionID=" + TID));
                ViewState["Type"] = "";
                if (!string.IsNullOrEmpty(result))
                {
                    transNo = result.Split('#')[0];
                    ViewState["Type"] = result.Split('#')[1];
                }


                ViewState["IPDNO"] = "";
                ViewState["EMGNo"] = "";
                if (ViewState["Type"].ToString() == "IPD")
                    ViewState["IPDNO"] = transNo;
                else
                    ViewState["EMGNo"] = Request.QueryString["EMGNo"].ToString();
                BindGraphSPO2(TID);
                BindGraphTemp(TID);
                BindGraphBP(TID);
                BindGraphPulse(TID);
                BindDiabiatic(TID);
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
    private void BindGraphTemp(string TID)
    {
        try
        {
            DataTable dt = new DataTable();
            if (ViewState["Type"].ToString() == "IPD")
            {
                dt = StockReports.GetDataTable("SELECT Round(Temp,2)Temp,CONCAT(DATE_FORMAT(DATE,'%d-%b-%Y'),'/',DATE_FORMAT(TIME,'%l:%i %p')) AS CreatedTime FROM ipd_patient_observationchart WHERE TransactionID='" + TID + "' AND Temp<>''  ORDER BY DATE  ");
            }
            else
            {
                dt = StockReports.GetDataTable("SELECT ROUND(T,2)Temp,CONCAT(DATE_FORMAT(c.EntryDate,'%d-%b-%Y'),'/',DATE_FORMAT(c.EntryDate,'%l:%i %p')) AS CreatedTime FROM cpoe_vital c WHERE c.TransactionID='" + TID + "' AND T<>''  ORDER BY entrydate");
            }
            if (dt.Rows.Count > 0)
            {
                double minTemp = Convert.ToDouble(dt.Compute("min(Temp)", string.Empty));
                double maxTemp = Convert.ToDouble(dt.Compute("max(Temp)", string.Empty));
                if (maxTemp > minTemp)
                {
                    chartTemp.DataSource = dt;
                    chartTemp.Legends.Add("Temp").Title = "Temperature Graph";
                    chartTemp.ChartAreas["ChartArea1"].AxisX.Title = "DateTime";
                    chartTemp.ChartAreas["ChartArea1"].AxisY.Minimum = minTemp;
                    chartTemp.ChartAreas["ChartArea1"].AxisY.Maximum = maxTemp;
                    chartTemp.ChartAreas["ChartArea1"].AxisY.Interval = 2;
                    chartTemp.ChartAreas["ChartArea1"].AxisY.Title = "Temperature";
                    chartTemp.Series["Temp"].XValueMember = "CreatedTime";
                    chartTemp.Series["Temp"].YValueMembers = "Temp";
                    chartTemp.Series["Temp"].ToolTip = " #VALX | #VALY";
                    chartTemp.DataBind();
                }
                else
                    lblMsg.Text = "Please Enter Correct Temperature Data";
            }
            else
            {
                lblMsg.Text = "Temperature Record Not Found";
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
    private void BindGraphSPO2(string TID)
    {
        try
        {
            DataTable dt = new DataTable();
            if (ViewState["Type"].ToString() == "IPD")
            {
                dt = StockReports.GetDataTable("SELECT Oxygen as SPO2,CONCAT(DATE_FORMAT(DATE,'%d-%b-%Y'),'/',DATE_FORMAT(TIME,'%l:%i %p')) AS CreatedTime FROM ipd_patient_observationchart WHERE TransactionID='" + TID + "' AND Oxygen<>''  ORDER BY DATE  ");
            }
            else
            {
                dt = StockReports.GetDataTable("SELECT SPO2 as SPO2,CONCAT(DATE_FORMAT(c.EntryDate,'%d-%b-%Y'),'/',DATE_FORMAT(c.EntryDate,'%l:%i %p')) AS CreatedTime FROM cpoe_vital c WHERE c.TransactionID='" + TID + "' AND SPO2<>''  ORDER BY entrydate");
            }
            if (dt.Rows.Count > 0)
            {
                double minTemp = Convert.ToDouble(dt.Compute("min(SPO2)", string.Empty));
                double maxTemp = Convert.ToDouble(dt.Compute("max(SPO2)", string.Empty));
                if (maxTemp > minTemp)
                {
                    chartSPO2.DataSource = dt;
                    chartSPO2.Legends.Add("SPO2").Title = "SPO2 Graph";
                    chartSPO2.ChartAreas["ChartArea1"].AxisX.Title = "DateTime";
                    chartSPO2.ChartAreas["ChartArea1"].AxisY.Minimum = minTemp;
                    chartSPO2.ChartAreas["ChartArea1"].AxisY.Maximum = maxTemp;
                    chartSPO2.ChartAreas["ChartArea1"].AxisY.Interval = 10;
                    chartSPO2.ChartAreas["ChartArea1"].AxisY.Title = "SPO2";
                    chartSPO2.Series["SPO2"].XValueMember = "CreatedTime";
                    chartSPO2.Series["SPO2"].YValueMembers = "SPO2";
                    chartSPO2.Series["SPO2"].ToolTip = " #VALX | #VALY";
                    chartSPO2.DataBind();
                }
                else
                    lblMsg.Text = "Please Enter Correct SPO2 Data";
            }
            else
            {
                lblMsg.Text = "SPO2 Record Not Found";
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
    

    private void BindGraphBP(string TID)
    {
        try
        {
            DataTable dt = new DataTable();
            if (ViewState["Type"].ToString() == "IPD")
            {
                dt = StockReports.GetDataTable("SELECT split_str(bp,'/',1)Systolic,TRIM(split_str(bp,'/',2))Diastolic,CONCAT(DATE_FORMAT(DATE,'%d-%b-%Y'),'/',DATE_FORMAT(TIME,'%H:%i %p')) AS CreatedTime FROM ipd_patient_observationchart WHERE TransactionID='" + TID + "' and BP<>'' ORDER BY DATE,TIME  ");
            }
            else
            {
                dt = StockReports.GetDataTable("SELECT split_str(bp,'/',1)Systolic,TRIM(split_str(bp,'/',2))Diastolic,CONCAT(DATE_FORMAT(EntryDate,'%d-%b-%Y'),'/',DATE_FORMAT(EntryDate,'%H:%i %p')) AS CreatedTime FROM cpoe_vital WHERE TransactionID='" + TID + "' AND BP<>'' ORDER BY EntryDate  ");
            }
            if (dt.Rows.Count > 0)
            {
                double maxBPSystolic = 0;
                double minBPSystolic = 0.00;
                double maxBPDiastolic = 0.00;
                double minBPDiastolic = 0.00;

                maxBPSystolic = Convert.ToDouble(dt.AsEnumerable().Max(column => column["Systolic"]));
                minBPSystolic = Convert.ToDouble(dt.AsEnumerable().Min(column => column["Systolic"]));
                maxBPDiastolic = Convert.ToDouble(dt.AsEnumerable().Max(column => column["Diastolic"]));
                minBPDiastolic = Convert.ToDouble(dt.AsEnumerable().Min(column => column["Diastolic"]));

                double minBp = 0.00;
                double maxBp = 0.00;
                if (maxBPSystolic >= maxBPDiastolic)
                {
                    maxBp = maxBPSystolic;
                }
                if (maxBPDiastolic >= maxBPSystolic)
                {
                    maxBp = maxBPDiastolic;
                }
                if (minBPSystolic >= minBPDiastolic)
                {
                    minBp = minBPDiastolic;
                }
                if (minBPDiastolic >= minBPSystolic)
                {
                    minBp = minBPSystolic;
                }
                if (maxBp > minBp)
                {
                    chartBP.DataSource = dt;
                    chartBP.Legends.Add("BP").Title = "Blood Pressure Graph";
                    chartBP.ChartAreas["ChartArea2"].AxisX.Title = "DateTime";
                    chartBP.ChartAreas["ChartArea2"].AxisY.Minimum = minBp;
                    chartBP.ChartAreas["ChartArea2"].AxisY.Maximum = maxBp;
                    chartBP.ChartAreas["ChartArea2"].AxisY.Interval = 10;

                    chartBP.ChartAreas["ChartArea2"].AxisY.Title = "BP";
                    chartBP.Series["Systolic"].XValueMember = "CreatedTime";
                    chartBP.Series["Systolic"].YValueMembers = "Systolic";
                    chartBP.Series["Diastolic"].XValueMember = "CreatedTime";
                    chartBP.Series["Diastolic"].YValueMembers = "Diastolic";


                    chartBP.Series["Diastolic"].ToolTip = " #VALX | #VALY";
                    chartBP.Series["Systolic"].ToolTip = " #VALX | #VALY";

                    chartBP.DataBind();
                }
                else
                    lblMsg.Text = "Please Enter Correct B/P Data";
            }
            else
                lblMsg.Text = "B/P Record Not Found";
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
    private void BindGraphPulse(string TID)
    {
        try
        {
            DataTable dt = new DataTable();
            if (ViewState["Type"].ToString() == "IPD")
            {
                dt = StockReports.GetDataTable("SELECT (Pulse+0)Pulse,CONCAT(DATE_FORMAT(DATE,'%d-%b-%Y'),'/',DATE_FORMAT(TIME,'%H:%i %p')) AS CreatedTime FROM ipd_patient_observationchart WHERE TransactionID='" + TID + "' AND Pulse<>''  ORDER BY DATE(DATE)");
            }
            else
            {
                dt = StockReports.GetDataTable(" SELECT (P+0)Pulse,CONCAT(DATE_FORMAT(EntryDate,'%d-%b-%Y'),'/',DATE_FORMAT(EntryDate,'%H:%i %p')) AS CreatedTime FROM cpoe_vital WHERE TransactionID='" + TID + "' AND P<>''  ORDER BY DATE(EntryDate) ");
            }
            if (dt.Rows.Count > 0)
            {

                double maxPulse = Convert.ToDouble(dt.Compute("max(Pulse)", string.Empty));
                double minPulse = Convert.ToDouble(dt.Compute("min(Pulse)", string.Empty));
                if (maxPulse > minPulse)
                {
                    chartPL.DataSource = dt;
                    chartPL.Legends.Add("Pulse").Title = "Pulse Graph";
                    chartPL.ChartAreas["ChartArea3"].AxisX.Title = "DateTime";
                    chartPL.ChartAreas["ChartArea3"].AxisY.Minimum = minPulse;
                    chartPL.ChartAreas["ChartArea3"].AxisY.Maximum = maxPulse;
                    chartPL.ChartAreas["ChartArea3"].AxisY.Interval = 10;
                    chartPL.ChartAreas["ChartArea3"].AxisY.Title = "Pulse";
                    chartPL.Series["Pulse"].XValueMember = "CreatedTime";
                    chartPL.Series["Pulse"].YValueMembers = "Pulse";

                    chartPL.Series["Pulse"].ToolTip = " #VALX | #VALY";

                    chartPL.DataBind();
                }
                else
                    lblMsg.Text = "Please Enter Correct Pulse Data";
            }
            else
            {
                lblMsg.Text = "Pulse Record Not Found";
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
    private void BindDiabiatic(string TID)
    {
        try
        {
            if (ViewState["Type"].ToString() == "IPD")
            {
                divDiabetic.Visible = true;
                DataTable dtDiabiatic = StockReports.GetDataTable("SELECT (CBG+0)CBG,Date_format(EntryDate,'%d-%b-%Y %l:%i %p')DateTime FROM Diabiatic_chart WHERE TransactionID='" + TID + "' AND Active=1 ORDER BY EntryDate  ");
                if (dtDiabiatic.Rows.Count > 0)
                {
                    //double maxPulse = Convert.ToDouble(dt.Compute("max(Pulse)", string.Empty));
                    //double minPulse = Convert.ToDouble(dt.Compute("min(Pulse)", string.Empty));
                    decimal maxDiab = Util.GetDecimal(dtDiabiatic.Compute("max(CBG)", string.Empty));
                    decimal minDiab = Util.GetDecimal(dtDiabiatic.Compute("min(CBG)", string.Empty));
                    if (maxDiab > minDiab)
                    {
                        chartDiab.DataSource = dtDiabiatic;
                        chartDiab.Legends.Add("Diabiatic").Title = "Diabiatic Graph";
                        chartDiab.ChartAreas["ChartArea4"].AxisX.Title = "DateTime";
                        chartDiab.ChartAreas["ChartArea4"].AxisY.Minimum = Util.GetDouble(minDiab);
                        chartDiab.ChartAreas["ChartArea4"].AxisY.Maximum = Util.GetDouble(maxDiab);
                        chartDiab.ChartAreas["ChartArea4"].AxisY.Interval = 1;
                        chartDiab.ChartAreas["ChartArea4"].AxisY.Title = "CBG";
                        chartDiab.Series["Diabiatic"].XValueMember = "DateTime";
                        chartDiab.Series["Diabiatic"].YValueMembers = "CBG";
                        chartDiab.DataBind();
                    }
                    else
                        lblMsg.Text = "Please Enter Correct Diabetic Data";
                }
                else
                {
                    lblMsg.Text = "Diabetic Record Not Found";
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
}