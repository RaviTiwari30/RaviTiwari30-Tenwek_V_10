using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_ViewMedicationOrder : System.Web.UI.Page
{
    string PID = "";
    string TID = "";
    string LabType = "";

    string LoginType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["TransactionID"] == null)
            TID = Request.QueryString["TID"].ToString();
        else
            TID = Request.QueryString["TransactionID"].ToString();



        if (Request.QueryString["PatientID"] == null)
            PID = Request.QueryString["PID"].ToString();
        else
            PID = Request.QueryString["PatientID"].ToString();

        lblMsg.Text = "";


        spnTransactionID.InnerText = TID;
        spnPatientID.InnerText = PID;



        spnCurrentDate.InnerText = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        spnNextDate.InnerText = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        spnPreviousDate.InnerText = Util.GetDateTime(DateTime.Now.AddDays(-3)).ToString("yyyy-MM-dd");


        if (!IsPostBack)
        {

            txtSelectDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            CalendarExtender1.StartDate = DateTime.Now;
            CalendarExtender1.EndDate = DateTime.Now;
            txtdateMissing.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            calMiss.EndDate = DateTime.Now;
        }


    }


    public static DataTable GetOrderRawData(string PatientId, string TransactionId, string FirstDate, string SecondDate, string ThirdDate,string Status)
    {
        DataTable OrderDetails = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("SELECT * from ( ");
            sb.Append("  SELECT (SELECT pmh.`TYPE` FROM patient_medical_history pmh WHERE pmh.`TransactionID`= tdm.TransactionId)Type,tdm.`IsApproved`,tdm.`ApprovedRemark`,tdm.Id OrId,tdm.IsPrn IsPrns,tdm.ItemId,tdm.ItemName MedicineName,tdm.PatientId,tdm.TransactionId,tdm.DepartmentId,   ");
            sb.Append("  CONCAT(tdm.Dose,' ',tdm.DoseUnit,' / ',tdm.Route ) DoseRoute,CONCAT(tdm.Dose,' ',tdm.DoseUnit )Dose, tdm.Route,  ");
            sb.Append("  ROUND((24 /(SELECT IFNULL( COUNT(sdt.DoseId),1) FROM tenwek_standard_dose_time sdt WHERE sdt.DoseId= tdm.IntervalId)),0)Frequency,  ");
            sb.Append("  DATE_FORMAT(CONCAT( tdm.StartDate,' ',tdm.FirstDose),'%d-%b-%Y %I:%i  %p')'Start Dose Time',  ");
            sb.Append("  IF( IFNULL( tdm.DoseTime,'')='',(SELECT GROUP_CONCAT(TIME_FORMAT( sdt.Time,'%I:%i  %p')) FROM tenwek_standard_dose_time sdt WHERE sdt.DoseId= tdm.IntervalId),tdm.DoseTime ) ScheduleDose,  ");
            sb.Append("  DATE_FORMAT(tdm.FinalDoseTime,'%d-%b-%Y %I:%i  %p')FinalDoseTime,  ");
            sb.Append("  IFNULL(tdm.Remark,'')Comment, tdm.IndentNo,  ");
            //sb.Append("  IF(tdm.IsIndentDone=1,IF(IFNULL(fid.ReceiveQty,0)>0,IF(tdm.IsDisContinue=0, 'Transfered To Ward','Medicine Discontinued'),'Indent Done'),'Pending Indent')  STATUS,if(tdm.IsPrn=0,'NO','YES')IsPrn ,  ");
            sb.Append("  IF(tdm.IsDisContinue=0,IF(tdm.IsIndentDone=1,IF(IFNULL(fid.ReceiveQty,0)>0,'Transfered To Ward','Indent Done'),'Pending Indent'),'Medicine Discontinued') STATUS,if(tdm.IsPrn=0,'NO','YES')IsPrn ,  ");
            sb.Append("  IF(tdm.IsIndentDone=1,IF(IFNULL(fid.ReceiveQty,0)>0,IF(tdm.IsDisContinue=0,IF(tdm.FinalDoseTime>=NOW(),1,0),0),0),0)  CanGive,  ");

            sb.Append("   IFNULL( GROUP_CONCAT(CASE WHEN DATE(ta.DoseDate) =DATE('" + FirstDate + "') THEN  TIME_FORMAT(ta.DoseTime,'%I:%i %p')  END ) ,'Not Available' )AS '" + FirstDate + "', ");

            sb.Append(" IFNULL(  GROUP_CONCAT(CASE WHEN DATE(ta.DoseDate) =DATE('" + SecondDate + "') THEN TIME_FORMAT(ta.DoseTime,'%I:%i %p') END ),'Not Available' ) AS '" + SecondDate + "', ");
            sb.Append(" IFNULL( GROUP_CONCAT(CASE WHEN DATE(ta.DoseDate) =DATE('" + ThirdDate + "') THEN TIME_FORMAT(ta.DoseTime,'%I:%i  %p') END ) ,'Not Available' ) AS '" + ThirdDate + "' ");

            sb.Append(" FROM  Tenwek_Docotor_medicine_Order tdm   ");
            sb.Append("  LEFT JOIN  tenwek_activemedication ta  ON tdm.Id=ta.OrderId  ");
            sb.Append(" LEFT JOIN f_indent_detail_patient fid ON fid.IndentNo=tdm.IndentNo and fid.ItemId=tdm.ItemId ");
            sb.Append("  LEFT JOIN  employee_master em ON em.EmployeeID=tdm.EntryBy  ");
            sb.Append("  WHERE tdm.PatientId='" + PatientId + "'    ");
            sb.Append("  AND tdm.TransactionId in (" + TransactionId + ") AND tdm.IsActive=1   ");
            sb.Append("  GROUP BY tdm.Id  ");
            sb.Append(" )t ");

            if (!string.IsNullOrEmpty(Status))
            {
                sb.Append(" WHERE t.STATUS='" + Status + "' ");
            }
            sb.Append(" ORDER BY STATUS='Medicine Discontinued',CanGive='0',Orid DESC ");

            OrderDetails = StockReports.GetDataTable(sb.ToString());

            return OrderDetails;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return OrderDetails;
        }
    }



    [WebMethod(EnableSession = true)]
    public static string GetOrderTable(string PatientId,string Status, string TransactionId, string FromDate, int IsNext,int IsWithIndication)
    {
        DataTable dt = new DataTable();

        try
        {

            DataTable Admitdata = StockReports.GetDataTable("SELECT pmh.DateOfAdmit,pmh.EmergencyTransactionId,IF(IFNULL(pmh.`DateOfDischarge`,'0001-01-01')='0001-01-01',DATE(NOW()),pmh.`DateOfDischarge`)DateOfDischarge FROM patient_medical_history pmh WHERE pmh.TransactionID='" + TransactionId + "' AND pmh.PatientID='" + PatientId + "'");

            if (Util.GetDateTime(FromDate) > Util.GetDateTime(DateTime.Now.Date))
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "You can not see Future Date Medication.", NextDate = Util.GetDateTime(DateTime.Now.Date).ToString("yyyy-MM-dd"), PreviousDate = Util.GetDateTime(DateTime.Now.Date).AddDays(-1).ToString("yyyy-MM-dd") });

            }

            if (Util.GetDateTime(FromDate) < Util.GetDateTime(Admitdata.Rows[0]["DateOfAdmit"].ToString()))
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "You can not see Before Admit Date Medication.", NextDate = Util.GetDateTime(FromDate).AddDays(3).ToString("yyyy-MM-dd"), PreviousDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") });

            }


            if (Util.GetDateTime(FromDate) > Util.GetDateTime(Admitdata.Rows[0]["DateOfDischarge"].ToString()))
            {
                FromDate = Util.GetDateTime(Admitdata.Rows[0]["DateOfDischarge"].ToString()).ToString("yyyy-MM-dd");
            }



            if (!string.IsNullOrEmpty(Util.GetString(Admitdata.Rows[0]["EmergencyTransactionId"].ToString())))
            {
                TransactionId = TransactionId + ","+ Util.GetString(Admitdata.Rows[0]["EmergencyTransactionId"].ToString());
            }

            string FirstDate = "", SecondDate = "", ThirdDate = "", PreviousDate = "", NextDate = "", HtmlTable = "", NotTable = "";

            if (IsNext == 1)
            {
                DateTime date = Util.GetDateTime(FromDate);
                FirstDate = date.ToString("yyyy-MM-dd");
                SecondDate = date.AddDays(1).ToString("yyyy-MM-dd");
                ThirdDate = date.AddDays(2).ToString("yyyy-MM-dd");
                NextDate = date.AddDays(3).ToString("yyyy-MM-dd");
                PreviousDate = date.AddDays(1).ToString("yyyy-MM-dd");
                dt = GetOrderRawData(PatientId, TransactionId, FirstDate, SecondDate, ThirdDate, Status);


            }
            else if (IsNext == 2)
            {
                DateTime date = Util.GetDateTime(FromDate);
                FirstDate = date.AddDays(-2).ToString("yyyy-MM-dd");
                SecondDate = date.AddDays(-1).ToString("yyyy-MM-dd");
                ThirdDate = date.ToString("yyyy-MM-dd");
                NextDate = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
                PreviousDate = Util.GetDateTime(DateTime.Now.AddDays(-3)).ToString("yyyy-MM-dd");
                dt = GetOrderRawData(PatientId, TransactionId, FirstDate, SecondDate, ThirdDate, Status);

            }
            else
            {
                DateTime date = Util.GetDateTime(FromDate);
                FirstDate = date.AddDays(-2).ToString("yyyy-MM-dd");
                SecondDate = date.AddDays(-1).ToString("yyyy-MM-dd");
                ThirdDate = date.ToString("yyyy-MM-dd");

                NextDate = date.AddDays(-1).ToString("yyyy-MM-dd");
                PreviousDate = date.AddDays(-3).ToString("yyyy-MM-dd");

                dt = GetOrderRawData(PatientId, TransactionId, FirstDate, SecondDate, ThirdDate, Status);

            }



            if (dt.Rows.Count > 0)
            {
                if (IsWithIndication==1)
                {
                    HtmlTable = GetHtmlTableString(dt, FirstDate, SecondDate, ThirdDate);
                }
                else
                {

                    HtmlTable = GetHtmlTableStringWithoutIndication(dt, FirstDate, SecondDate, ThirdDate);
                }
                
            }


            if (!string.IsNullOrEmpty(HtmlTable) || !string.IsNullOrEmpty(NotTable))
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = HtmlTable, NextDate = NextDate, PreviousDate = PreviousDate });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "Not Available", NextDate = NextDate, PreviousDate = PreviousDate });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "Error Occured ! Contact To Administrator.", NextDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), PreviousDate = Util.GetDateTime(FromDate).AddDays(-1).ToString("yyyy-MM-dd") });

        }
    }


    public static string GetHtmlTableString(DataTable dt, string FirstDate, string SecondDate, string ThirdDate)
    {
        StringBuilder html = new StringBuilder();
        if (dt.Rows.Count > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();

            try
            {



            html.Append("  <table id='tblOrderData' rules='all' border='1' style='border-collapse: collapse; width: 100%' class='GridViewStyle'>      ");



                //Building the Header row.
                html.Append("<thead> <tr>");
                html.Append(" <th class='GridViewHeaderStyle'> SN. </th>");
                html.Append(" <th class='GridViewHeaderStyle'> Act. </th>");
                html.Append(" <th class='GridViewHeaderStyle'> Dis. </th>");
                foreach (DataColumn column in dt.Columns)
                {
                    string style = "";
                    if (column.ColumnName == "OrId" || column.ColumnName == "Type" || column.ColumnName == "IsApproved" || column.ColumnName == "IsPrns" || column.ColumnName == "Frequency" || column.ColumnName == "DoseRoute" || column.ColumnName == "IndentNo" || column.ColumnName == "ItemId" || column.ColumnName == "PatientId" || column.ColumnName == "TransactionId" || column.ColumnName == "DepartmentId" || column.ColumnName == "IndentNo" || column.ColumnName == "CanGive")
                    {
                        style = "display:none";
                    }
                    if (column.ColumnName == FirstDate || column.ColumnName == SecondDate || column.ColumnName == ThirdDate)
                    {
                        html.Append("<th class='GridViewHeaderStyle' style=" + style + ">");
                        html.Append(Util.GetDateTime(column.ColumnName).ToString("dd-MMM-yyyy"));
                        html.Append("</th>");
                    }
                    else
                    {
                        html.Append("<th class='GridViewHeaderStyle' style=" + style + ">");
                        html.Append(column.ColumnName);
                        html.Append("</th>");
                    }
                }
                html.Append("</tr> </thead> <tbody>");

                int count = 0;
                string rowcolor = "";

                int IsMedIsGiven = 0;
                //Building the Data rows.
                foreach (DataRow row in dt.Rows)
                {
                    string columnColor = "";

                    if (row["STATUS"].ToString().Trim() == "Transfered To Ward")
                    {
                        if (row["CanGive"].ToString().Trim() == "0")
                        {
                            rowcolor = "background-color:#8989899e";
                            IsMedIsGiven = 1;
                        }
                        else
                        {
                            rowcolor = "background-color:#95f2009e";
                            IsMedIsGiven = 1;
                        }

                    }

                    if (row["STATUS"].ToString().Trim() == "Indent Done")
                    {
                        if (row["CanGive"].ToString().Trim() == "0" && Util.GetDateTime(row["FinalDoseTime"].ToString())<Util.GetDateTime(DateTime.Now))
                        {
                            rowcolor = "background-color:#8989899e";
                            IsMedIsGiven = 0;
                        }
                        else
                        {
                            rowcolor = "background-color:#05593e9e";
                            IsMedIsGiven = 0;
                        }
                        //rowcolor = "background-color:#05593e9e";
                        //IsMedIsGiven = 0;

                    }

                    if (row["STATUS"].ToString().Trim() == "Pending Indent")
                    {


                        if (row["IsApproved"].ToString().Trim() == "0")
                        {
                            rowcolor = "background-color:#99f7f79e";
                            IsMedIsGiven = 0;
                            row["STATUS"] = "Indent Need Approval";
                        }
                        else if (row["IsApproved"].ToString().Trim() == "2")
                        {
                            rowcolor = "background-color:#eb81819e";
                            IsMedIsGiven = 0;
                            row["STATUS"] = "Indent Rejected";
                        }
                        else
                        {
                            rowcolor = "background-color:#f2f2009e";
                            IsMedIsGiven = 0;
                        }


                        if (row["Type"].ToString().Trim() == "EMG")
                        {
                            rowcolor = "background-color:#f5e5ab";
                            IsMedIsGiven = 0;
                            row["STATUS"] = "Emg Pending Indent";
                        }

                    }

                if (row["IsPrns"].ToString() == "1")
                {
                    columnColor = "font-weight: 900;background-color:#ea2ce49e";                     
                }
                if (row["STATUS"].ToString().Trim() == "Medicine Discontinued")
                {
                    rowcolor = "background-color:#5939059e";
                    IsMedIsGiven = 1;
                }



                html.Append("<tr style='" + rowcolor + "'>");
                html.Append(" <td class='GridViewLabItemStyle'> " + ++count + " </td>");

                if (Util.GetInt(row["CanGive"]) == 1)
                {
                    html.Append(" <td class='GridViewLabItemStyle'>  <div id='btnOpenPopup' onclick='openGiveMedModel(this)'  > <img style='float: left; margin: 4px;' src='../../Images/Addnew.png' /></div> </td>");

                }
                else
                {
                    html.Append(" <td class='GridViewLabItemStyle'>     </td>");

                }
                if (Util.GetInt(HttpContext.Current.Session["RoleID"]) == 52 && row["STATUS"].ToString().Trim() != "Medicine Discontinued")
                {
                    html.Append(" <td class='GridViewLabItemStyle'>  <div id='divModelDiscontinue' onclick='DiscontinueOrder(this)'  > <input type='button' value='DC' style='background-color:red;color:white'/></div> </td>");

                }
                else
                {
                    html.Append(" <td class='GridViewLabItemStyle'>     </td>");

                }
                foreach (DataColumn column in dt.Columns)
                {

                        string style = "";
                        if (column.ColumnName == "OrId" || column.ColumnName == "Type" || column.ColumnName == "IsApproved" || column.ColumnName == "IsPrns" || column.ColumnName == "Frequency" || column.ColumnName == "DoseRoute" || column.ColumnName == "IndentNo" || column.ColumnName == "ItemId" || column.ColumnName == "PatientId" || column.ColumnName == "TransactionId" || column.ColumnName == "DepartmentId" || column.ColumnName == "IndentNo" || column.ColumnName == "CanGive")
                        {
                            style = "display:none";
                        }

                    if (column.ColumnName == FirstDate || column.ColumnName == SecondDate || column.ColumnName == ThirdDate)
                    {
                        string Frequency = row["Frequency"].ToString();
                        string OrId = row["OrId"].ToString();
                        string date = column.ColumnName;
                            string NewMissTime = MakeMissingString(OrId, date, Frequency,con);
                         
                        if (Util.GetDateTime(date).Date > Util.GetDateTime(row["FinalDoseTime"].ToString()).Date)
                        {
                            NewMissTime = "Not Available";
                            html.Append("<td class='GridViewLabItemStyle' style='cursor: pointer;width: 70px;background-color: white;" + style + "' id='" + column.ColumnName + "'  >");
                            html.Append(NewMissTime);
                            html.Append("</td>");
                        }
                        else if (NewMissTime == "")
                        {
                            NewMissTime = row[column.ColumnName].ToString();
                            html.Append("<td class='GridViewLabItemStyle' style='cursor: pointer;width: 70px;background-color: white;" + style + "' id='" + column.ColumnName + "'  >");
                            html.Append(NewMissTime);
                            html.Append("</td>");
                        }
                        else
                        {
                            if (IsMedIsGiven==1)
                            {
                                html.Append("<td class='GridViewLabItemStyle' style='cursor: pointer;width: 70px;background-color: white;" + style + "' id='" + column.ColumnName + "' onclick='openRestartModel(this,this.id)' >");
                                html.Append(NewMissTime);
                                html.Append("</td>");
                            }
                            else
                            {
                                NewMissTime = row[column.ColumnName].ToString();
                                html.Append("<td class='GridViewLabItemStyle' style='cursor: pointer;width: 70px;background-color: white;" + style + "' id='" + column.ColumnName + "'  >");
                                html.Append(NewMissTime);
                                html.Append("</td>");
                            }
                               
                            
                        }
                      
                    }
                    else if (column.ColumnName == "IsPrn")
                    {
                        html.Append("<td class='GridViewLabItemStyle' style='" + style + "' id='td" + column.ColumnName + "'>");
                        html.Append("<div style='padding: 10px;" + columnColor + "'>");
                        html.Append(row[column.ColumnName]);

                        html.Append("</div>");
                        html.Append("</td>");
                    }
                    else if (column.ColumnName == "ScheduleDose")
                    {
                        if (IsMedIsGiven == 1)
                        {
                            // html.Append("<td class='GridViewLabItemStyle' style='color:blue;cursor: pointer;" + style + "' id='" + column.ColumnName + "' onclick='openMissingModel(this)' >");
                            html.Append("<td class='GridViewLabItemStyle' style='color:blue;cursor: pointer;" + style + "' id='" + column.ColumnName + "' >");
                            html.Append(row[column.ColumnName]);
                            html.Append("</td>");
                        }
                        else
                        {
                            html.Append("<td class='GridViewLabItemStyle' style='" + style + "' id='" + column.ColumnName + "'  >");
                            html.Append(row[column.ColumnName]);
                            html.Append("</td>");
                        }
                    }
                    else
                    {
                        html.Append("<td class='GridViewLabItemStyle' style='" + style + "' id='td" + column.ColumnName + "'>");
                        html.Append(row[column.ColumnName]);
                        html.Append("</td>");
                    }


                }
                html.Append("</tr>");
            }



            //End OF Table

            html.Append(" </tbody> </table>");

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                con.Close();
                con.Dispose();

            }


        }




        return html.ToString();

    }



    public static string GetHtmlTableStringWithoutIndication(DataTable dt, string FirstDate, string SecondDate, string ThirdDate)
    {
        StringBuilder html = new StringBuilder();
        if (dt.Rows.Count > 0)
        {

            //Start OF Table



            html.Append("  <table id='tblOrderData' rules='all' border='1' style='border-collapse: collapse; width: 100%' class='GridViewStyle'>      ");



            //Building the Header row.
            html.Append("<thead> <tr>");
            html.Append(" <th class='GridViewHeaderStyle'> SN </th>");
            html.Append(" <th class='GridViewHeaderStyle'> Action </th>");
            html.Append(" <th class='GridViewHeaderStyle'> Dis. </th>");
            foreach (DataColumn column in dt.Columns)
            {
                string style = "";
                if (column.ColumnName == "OrId" || column.ColumnName == "IsPrns" || column.ColumnName == "Frequency" || column.ColumnName == "DoseRoute" || column.ColumnName == "IndentNo" || column.ColumnName == "ItemId" || column.ColumnName == "PatientId" || column.ColumnName == "TransactionId" || column.ColumnName == "DepartmentId" || column.ColumnName == "IndentNo" || column.ColumnName == "CanGive")
                {
                    style = "display:none";
                }
                if (column.ColumnName == FirstDate || column.ColumnName == SecondDate || column.ColumnName == ThirdDate)
                {
                    html.Append("<th class='GridViewHeaderStyle' style=" + style + ">");
                    html.Append(Util.GetDateTime(column.ColumnName).ToString("dd-MMM-yyyy"));
                    html.Append("</th>");
                }
                else
                {
                    html.Append("<th class='GridViewHeaderStyle' style=" + style + ">");
                    html.Append(column.ColumnName);
                    html.Append("</th>");
                }
            }
            html.Append("</tr> </thead> <tbody>");

            int count = 0;
            string rowcolor = "";

            int IsMedIsGiven = 0;
            //Building the Data rows.
            foreach (DataRow row in dt.Rows)
            {
                string columnColor = "";

                if (row["STATUS"].ToString().Trim() == "Transfered To Ward")
                {
                    rowcolor = "background-color:#95f2009e";
                    IsMedIsGiven = 1;
                }

                if (row["STATUS"].ToString().Trim() == "Indent Done")
                {
                    rowcolor = "background-color:#05593e9e";
                    IsMedIsGiven = 0;
                }

                if (row["STATUS"].ToString().Trim() == "Pending Indent")
                {
                    rowcolor = "background-color:#f2f2009e";
                    IsMedIsGiven = 0;
                }

                if (row["IsPrns"].ToString() == "1")
                {
                    columnColor = "font-weight: 900;background-color:#ea2ce49e";
                }
                if (row["STATUS"].ToString().Trim() == "Medicine Discontinued")
                {
                    rowcolor = "background-color:#5939059e";
                    IsMedIsGiven = 1;
                }



                html.Append("<tr style='" + rowcolor + "'>");
                html.Append(" <td class='GridViewLabItemStyle'> " + ++count + " </td>");

                if (Util.GetInt(row["CanGive"]) == 1)
                {
                    html.Append(" <td class='GridViewLabItemStyle'>  <div id='btnOpenPopup' onclick='openGiveMedModel(this)'  > <img style='float: left; margin: 4px;' src='../../Images/Addnew.png' /></div> </td>");

                }
                else
                {
                    html.Append(" <td class='GridViewLabItemStyle'>     </td>");

                }


                if (Util.GetInt(HttpContext.Current.Session["RoleID"]) == 52 && row["STATUS"].ToString().Trim() != "Medicine Discontinued")
                {
                    html.Append(" <td class='GridViewLabItemStyle'>  <div id='divModelDiscontinue' onclick='DiscontinueOrder(this)'  > <input type='button' value='DC' style='background-color:red;color:white'/></div> </td>");

                }
                else
                {
                    html.Append(" <td class='GridViewLabItemStyle'>     </td>");

                }
                foreach (DataColumn column in dt.Columns)
                {

                    string style = "";
                    if (column.ColumnName == "OrId" || column.ColumnName == "IsPrns" || column.ColumnName == "Frequency" || column.ColumnName == "DoseRoute" || column.ColumnName == "IndentNo" || column.ColumnName == "ItemId" || column.ColumnName == "PatientId" || column.ColumnName == "TransactionId" || column.ColumnName == "DepartmentId" || column.ColumnName == "IndentNo" || column.ColumnName == "CanGive")
                    {
                        style = "display:none";
                    }

                    if (column.ColumnName == FirstDate || column.ColumnName == SecondDate || column.ColumnName == ThirdDate)
                    {

                        if (IsMedIsGiven == 1)
                        {
                            html.Append("<td class='GridViewLabItemStyle' style='cursor: pointer;width: 70px;background-color: white;color:blue;" + style + "' id='" + column.ColumnName + "' onclick='openRestartModel(this,this.id)' >");
                            html.Append(row[column.ColumnName].ToString());
                            html.Append("</td>");
                        }
                        else
                        {
                            

                            html.Append("<td class='GridViewLabItemStyle' style='cursor: pointer;width: 70px;background-color: white;" + style + "' id='" + column.ColumnName + "'  >");
                            html.Append(row[column.ColumnName].ToString());
                            html.Append("</td>");
                        }

                       
                         

                    }
                    else if (column.ColumnName == "IsPrn")
                    {
                        html.Append("<td class='GridViewLabItemStyle' style='" + style + "' id='td" + column.ColumnName + "'>");
                        html.Append("<div style='padding: 10px;" + columnColor + "'>");
                        html.Append(row[column.ColumnName]);

                        html.Append("</div>");
                        html.Append("</td>");
                    }
                    else if (column.ColumnName == "ScheduleDose")
                    {
                        if (IsMedIsGiven == 1)
                        {
                            // html.Append("<td class='GridViewLabItemStyle' style='color:blue;cursor: pointer;" + style + "' id='" + column.ColumnName + "' onclick='openMissingModel(this)' >");
                            html.Append("<td class='GridViewLabItemStyle' style='color:blue;cursor: pointer;" + style + "' id='" + column.ColumnName + "' >");
                            html.Append(row[column.ColumnName]);
                            html.Append("</td>");
                        }
                        else
                        {
                            html.Append("<td class='GridViewLabItemStyle' style='" + style + "' id='" + column.ColumnName + "'  >");
                            html.Append(row[column.ColumnName]);
                            html.Append("</td>");
                        }
                    }
                    else
                    {
                        html.Append("<td class='GridViewLabItemStyle' style='" + style + "' id='td" + column.ColumnName + "'>");
                        html.Append(row[column.ColumnName]);
                        html.Append("</td>");
                    }


                }
                html.Append("</tr>");
            }



            //End OF Table

            html.Append(" </tbody> </table>");



        }




        return html.ToString();

    }



    [WebMethod(EnableSession = true)]
    public static string GetMedicationData(string OrderID, string OrderDate)
    {
        DataTable appointmentDetails = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT  em.NAME GivenBy,if(ta.IsGiven=0,'NO','YES')IsGivenView,ta.ItemName,ta.Frequency,DATE_FORMAT( ta.DoseDate,'%d-%b-%Y')DoseDate,TIME_FORMAT(ta.DoseTime,'%r')DoseTime,ta.Dose,ta.Route,ta.Quantity,ta.Remark,ta.PrimaryNurse,ta.CurrentDoctor FROM tenwek_activemedication ta ");
            sb.Append(" INNER JOIN employee_master em ON em.EmployeeID=ta.EntryBy ");

            sb.Append(" WHERE ta.OrderId='" + OrderID + "' AND ta.DoseDate='" + Util.GetDateTime(OrderDate).ToString("yyyy-MM-dd") + "' ");
            appointmentDetails = StockReports.GetDataTable(sb.ToString());


            if (appointmentDetails.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = appointmentDetails });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = appointmentDetails });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = "No data Available." });
        }
    }



    [WebMethod(EnableSession = true, Description = "Medication")]
    public static string Medication(int OrderId, string Date, string Time, string Dose, string Route, string Frequency, string PId, string Tid, string ItemId, string ItemName, int Qty, string Remark, int IsGiven,string PrimaryNurse,string PrimaryNurseId)
    {
        string LedgerTransactionNo = string.Empty;
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            //Discontinued ORDER 

            //NEW ENTRY AGAINSET DISCONTINUED ORDERED
            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO  tenwek_activemedication ");
            sb.Append(" (PatientId,TransactionId, OrderId,DoseDate,DoseTime,EntryBy,ItemId,ItemName,Route,Frequency,Dose,Quantity,Remark,IsGiven,PrimaryNurse,PrimaryNurseId,CurrentDoctor,CurrentDoctorId )  ");
            sb.Append("  VALUES(@PatientId,@TransactionId, @OrderId,@DoseDate,@DoseTime,@EntryBy,@ItemId,@ItemName,@Route,@Frequency,@Dose ,@Quantity,@Remark,@IsGiven,@PrimaryNurse,@PrimaryNurseId,@CurrentDoctor,@CurrentDoctorId)");
            CountSave = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                PatientId = PId,
                TransactionId = Tid,
                OrderId = OrderId,
                DoseDate = Util.GetDateTime(Date).ToString("yyyy-MM-dd"),
                DoseTime = Util.GetDateTime(Time).ToString("HH:mm:ss"),
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                ItemId = ItemId,
                ItemName = ItemName,
                Route = Route,
                Frequency = Frequency,
                Dose = Dose,
                Quantity = Util.GetInt(Qty),
                Remark = Remark,
                IsGiven = Util.GetInt(IsGiven),
                PrimaryNurse=PrimaryNurse,
                PrimaryNurseId = PrimaryNurseId,
                CurrentDoctor=HttpContext.Current.Session["EmployeeName"].ToString(),
                CurrentDoctorId = HttpContext.Current.Session["ID"].ToString()
            });



            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Given Successfully" });

            }
            else
            {
                tnx.Rollback();
                //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            CountSave--;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string GetMissingData(string OrderId, string Date, string Frequency)
    {
        if (string.IsNullOrEmpty(Date))
        {
            Date = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        }



        DataTable DoctorTime = StockReports.GetDataTable("SELECT TIME_FORMAT(sdt.DoseTime,'%h:%i %p') Time,sdt.Id OrId FROM tenwek_docotor_medicine_order mo INNER JOIN tenwek_patient_dose_time sdt ON  sdt.OrderId=mo.Id WHERE mo.ID=" + OrderId + " AND DATE(mo.StartDate)<='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' ");

        StringBuilder html = new StringBuilder();

        if (DoctorTime.Rows.Count > 0)
        {

            //Start OF Table
            
            html.Append("  <table id='tblMissing' rules='all' border='1' style='border-collapse: collapse; width: 100%' class='GridViewStyle'>      ");



            //Building the Header row.
            html.Append("<thead> <tr>");
            html.Append(" <th class='GridViewHeaderStyle'> SNo. </th>");
            html.Append(" <th class='GridViewHeaderStyle'> Date. </th>");
            foreach (DataColumn column in DoctorTime.Columns)
            {
                string style = "";
                if (column.ColumnName == "OrId" || column.ColumnName == "Doses" || column.ColumnName == "Route" || column.ColumnName == "IndentNo" || column.ColumnName == "ItemId" || column.ColumnName == "PatientId" || column.ColumnName == "TransactionId" || column.ColumnName == "DepartmentId" || column.ColumnName == "IndentNo" || column.ColumnName == "CanGive")
                {
                    style = "display:none";
                }
                html.Append("<th class='GridViewHeaderStyle' style=" + style + ">");
                html.Append(column.ColumnName);
                html.Append("</th>");
            }
            html.Append("</tr> </thead> <tbody>");

            int count = 0;
            int Sn = 0;

            for (int i = 0; i < DoctorTime.Rows.Count; i++)
            {
                DataTable GivenTime = new DataTable();
                count = i;
                if (count == (DoctorTime.Rows.Count - 1))
                {
                    GivenTime = StockReports.GetDataTable("SELECT  ta.DoseTime FROM tenwek_activemedication ta WHERE ta.OrderId='" + OrderId+ "' and date(ta.DoseDate)='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND time(ta.DoseTime)>='" + Util.GetDateTime(DoctorTime.Rows[count]["Time"].ToString()).ToString("HH:mm:ss") + "' AND time( ta.DoseTime)<='" + Util.GetDateTime(DoctorTime.Rows[count]["Time"].ToString()).AddHours(Util.GetInt(Frequency)).ToString("HH:mm:ss") + "' ");

                }
                else
                {
                    GivenTime = StockReports.GetDataTable(" SELECT  ta.DoseTime FROM tenwek_activemedication ta WHERE ta.OrderId='" + OrderId + "' and date(ta.DoseDate)='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND time( ta.DoseTime)>='" + Util.GetDateTime(DoctorTime.Rows[count]["Time"].ToString()).ToString("HH:mm:ss") + "' AND time(ta.DoseTime)<='" + Util.GetDateTime(DoctorTime.Rows[count + 1]["Time"].ToString()).ToString("HH:mm:ss") + "' ");

                }
                string style = "";
                if (GivenTime.Rows.Count == 0)
                {
                    if (Util.GetDateTime(Util.GetDateTime(Date).ToString("yyyy-MM-dd") + ' ' + DoctorTime.Rows[i]["Time"].ToString()) <= Util.GetDateTime(DateTime.Now))
                    {
                        style = "background-color:red";
                    }
                    else
                    {
                        style = " ";
                    }

                }
                else
                {
                    if (Util.GetDateTime(GivenTime.Rows[0]["DoseTime"].ToString()) <= Util.GetDateTime(DoctorTime.Rows[i]["Time"].ToString()).AddHours(1))
                    {
                        style = "background-color:green";
                    }
                    else
                    {
                        style = "background-color:orange";
                    }

                }

                html.Append("<tr style='" + style + "'>");
                html.Append(" <td class='GridViewLabItemStyle'> " + ++Sn + " </td>");
                html.Append(" <td class='GridViewLabItemStyle'> " + Date + " </td>");

                html.Append("<td class='GridViewLabItemStyle'  id='td" + i + "'>");
                html.Append(DoctorTime.Rows[i]["Time"].ToString());
                html.Append("</td>");

                html.Append("</tr>");

            }


            //End OF Table

            html.Append(" </tbody> </table>");

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = html.ToString() });

        }
        else
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data ="<div style='font-weight:bolder;text-align:center;padding:50px'> Medicine Not Prescribed. </div>" });

        }



        
    }





    [WebMethod(EnableSession = true)]
    public static string MakeMissingString(string OrderId, string Date, string Frequency,MySqlConnection con)
    {
        if (string.IsNullOrEmpty(Date))
        {
            Date = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
        }
        StringBuilder sb=new StringBuilder();
        sb.Append("SELECT TIME_FORMAT(sdt.DoseTime,'%h:%i %p') Time,sdt.Id OrId FROM tenwek_docotor_medicine_order mo ");
        sb.Append(" INNER JOIN tenwek_patient_dose_time sdt ON  sdt.OrderId=mo.Id WHERE mo.ID=" + OrderId + " AND DATE(mo.StartDate)<='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' ");
       
             DataTable DoctorTime = new DataTable();
        using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString() , con))
        {
            
                        using (DoctorTime as IDisposable)
                        {
                            da.Fill(DoctorTime);
                             
                        }
        }
        


        StringBuilder html = new StringBuilder();

        if (DoctorTime.Rows.Count > 0)
        {

            

 
            int count = 0;
            int Sn = 0;
            string newTime = "";
            html.Append("<div>");
            for (int i = 0; i < DoctorTime.Rows.Count; i++)
            {
                DataTable GivenTime = new DataTable();
                count = i;
                if (count == (DoctorTime.Rows.Count - 1))
                {

                    StringBuilder sbGiv=new StringBuilder();
        sbGiv.Append("SELECT TIME_FORMAT(ta.DoseTime,'%h:%i %p')DoseTime   FROM tenwek_activemedication ta WHERE ta.IsGiven=1 AND ta.OrderId='" + OrderId + "' and concat( ta.DoseDate,' ',ta.DoseTime)>='" + Util.GetDateTime(Date + " " + DoctorTime.Rows[count]["Time"].ToString()).ToString("yyyy-MM-dd HH:mm:ss") + "' AND concat(ta.DoseDate,' ',ta.DoseTime)<='" + Util.GetDateTime(Date + " " + DoctorTime.Rows[count]["Time"].ToString()).AddHours(Util.GetInt(Frequency)).ToString("yyyy-MM-dd HH:mm:ss") + "'  ");
         
        using (MySqlDataAdapter da = new MySqlDataAdapter(sbGiv.ToString() , con))
        {
            
                        using (GivenTime as IDisposable)
                        {
                            da.Fill(GivenTime);
                             
                        }
        }
         
                }
                else
                {
                      StringBuilder sbGiv=new StringBuilder();
        sbGiv.Append(" SELECT TIME_FORMAT(ta.DoseTime,'%h:%i %p')DoseTime   FROM tenwek_activemedication ta WHERE  ta.IsGiven=1 AND ta.OrderId='" + OrderId + "' and date(ta.DoseDate)='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' AND time( ta.DoseTime)>='" + Util.GetDateTime(DoctorTime.Rows[count]["Time"].ToString()).ToString("HH:mm:ss") + "' AND time(ta.DoseTime)<='" + Util.GetDateTime(DoctorTime.Rows[count + 1]["Time"].ToString()).ToString("HH:mm:ss") + "' ");
        using (MySqlDataAdapter da = new MySqlDataAdapter(sbGiv.ToString() , con))
        {
            
                        using (GivenTime as IDisposable)
                        {
                            da.Fill(GivenTime);
                             
                        }
        }

                  
                }
                string style = "";
                if (GivenTime.Rows.Count == 0)
                {
                    if (Util.GetDateTime(Util.GetDateTime(Date).ToString("yyyy-MM-dd") + ' ' + DoctorTime.Rows[i]["Time"].ToString()) <= Util.GetDateTime(DateTime.Now))
                    {
                        style = "color:red";
                        newTime = DoctorTime.Rows[i]["Time"].ToString();
                    }
                    else
                    {
                        style = "";
                        newTime = DoctorTime.Rows[i]["Time"].ToString();
                    }

                }
                else
                {
                    if (Util.GetDateTime(GivenTime.Rows[0]["DoseTime"].ToString()) <= Util.GetDateTime(DoctorTime.Rows[i]["Time"].ToString()).AddHours(1))
                    {
                        style = "color:green";
                        newTime = GivenTime.Rows[0]["DoseTime"].ToString();
                    }
                    else
                    {
                        style = "color:#750ab8";
                        newTime = GivenTime.Rows[0]["DoseTime"].ToString();
                    }

                }

                html.Append("<div style='font-weight:bolder'>");
                html.Append("<label style="+style+"  id='td" + i + "'>");
                html.Append(newTime);
                html.Append("</label>");
                html.Append("</div>");

            }
            html.Append("</div>");
             
            
        }



        return html.ToString();

    }
     

    [WebMethod]
    public static string GetNowTime()
    {
        DateTime dt = DateTime.Now;


        return Newtonsoft.Json.JsonConvert.SerializeObject(new
        {
            time = Util.GetDateTime(dt).ToString("hh:mm tt")
        });


    }




    [WebMethod(EnableSession = true, Description = "Discontinue Order")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string DiscontinueOrder(int Id)
    {


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            string str = "update Tenwek_Docotor_medicine_Order  set IsDisContinue=1,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id=" + Util.GetInt(Id) + " ";
            int i = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
            if (i > 0)
            {
                Tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Discontinue Order Successfully" });

            }
            else
            {
                Tnx.Rollback();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });

        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }






    }


    [WebMethod(EnableSession = true, Description = "GetPrimaryNurse")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetPrimaryNurse(string OrderId)
    {
        DateTime dt = DateTime.Now;

        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT CONCAT(Title,' ',NAME)DoctorName,pna.`NurseID` FROM patient_nurse_assignment pna  ");
        sb.Append("   INNER JOIN employee_master em ON em.`EmployeeID`=pna.`NurseID`  ");
        sb.Append("   INNER JOIN tenwek_docotor_medicine_order t ON t.`TransactionId`=pna.`TransactionID`  ");
        sb.Append("   WHERE pna.`STATUS`=0 AND  t.`Id`='" + OrderId + "'  GROUP BY pna.`NurseID`  ");

        DataTable PrimeryNurseData = StockReports.GetDataTable(sb.ToString());
        if (PrimeryNurseData.Rows.Count > 0 && PrimeryNurseData != null)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Util.GetString(PrimeryNurseData.Rows[0]["DoctorName"].ToString()), NurseID = Util.GetString(PrimeryNurseData.Rows[0]["NurseID"].ToString()), CurrentDoctor = HttpContext.Current.Session["EmployeeName"].ToString() });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response ="", NurseID = "", CurrentDoctor = HttpContext.Current.Session["EmployeeName"].ToString() });


        }



    }


}