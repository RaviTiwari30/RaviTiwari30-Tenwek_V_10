using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Welcome : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // LoadData(); 
            // bindRole();

            lblEmpId.Text = Session["ID"].ToString();
            WelcomeMessage();
            BindCounter();
            bindLoginDetails(Session["ID"].ToString(), Session["RoleID"].ToString());
            bindLabels(Session["ID"].ToString(), Session["CentreID"].ToString());
         ;// String.Format("data:image/jpg;base64,{0}", PROFILE_PIC); 

            


            txtNewsDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calfrom.EndDate = DateTime.Now;


        }
    }
    private void bindLabels(string employeeID, string centerID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT wl.Label_Text,wl.Label_Icon,wl.Label_FunctionName FROM welcome_Labels_EmpWise le INNER JOIN welcome_labels wl ON le.Label_ID=wl.ID WHERE wl.IsActive=1 AND le.IsActive=1 AND le.EmployeeID='" + employeeID + "'");//Emp_ID
        var labels = string.Empty;
        foreach (DataRow item in dt.Rows)
        {
            var value = StockReports.ExecuteScalar("CALL " + item["Label_FunctionName"].ToString() + "('" + employeeID + "','" + centerID + "')");
            var valueArray = new string[] { "0", "0" };
            if (!string.IsNullOrEmpty(value))
            {
                if (value.Split('#').Length > 1)
                    valueArray = value.Split('#');
                else
                    valueArray[0] = value;
            }

            labels += "<div class='col-md-6'> <div class='well span3 top-block'> <span class='icon32 icon-color " + item["Label_Icon"].ToString() + "'></span> <div>" + item["Label_Text"].ToString() + "</div> <div>" + valueArray[1] + "</div> <span class='notification green'>" + valueArray[1] + "</span> </div> </div>";
        }
       // divWelcomeLabels.InnerHtml = labels;

    }
    private void bindLoginDetails(string employeeID, string roleID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT DATE_FORMAT(f.LastLoginTime,'%d-%b-%Y  %l:%i %p') LastLoginTime,f.NoOfLogins,DATE_FORMAT(f.EntryDate,'%d-%b-%Y  %l:%i %p') EntryDate,f.Last_IPAddress FROM f_login f WHERE f.EmployeeID='" + employeeID + "' AND f.RoleID=" + roleID);
        if (dt.Rows.Count > 0)
        {
            divLastLoginTime.InnerText = Util.GetString(dt.Rows[0]["LastLoginTime"]);
            divLastLoginIPAddress.InnerText = Util.GetString(dt.Rows[0]["Last_IPAddress"]);
            divTotalLogin.InnerText = Util.GetString(dt.Rows[0]["NoOfLogins"]);
            divLastPasswordChange.InnerText = Util.GetString(dt.Rows[0]["EntryDate"]);
        }
    }
    private void BindCounter()
    {
        if (Session["LoginType"].ToString().ToUpper() == "OPD" || Session["LoginType"].ToString().ToUpper() == "EMERGENCY")
        {
            DataTable dtCounter = StockReports.GetDataTable("SELECT TypeID,TypeName FROM tokentype_master WHERE isactive=1");
            if (dtCounter.Rows.Count > 0)
            {
                //np  ddlCounterName.DataSource = dtCounter;
                //np  ddlCounterName.DataTextField = "TypeName";
                //np  ddlCounterName.DataValueField = "TypeID";
                //np  ddlCounterName.DataBind();
                //np  ddlCounterName.Items.Insert(0, "---Select Counter---");
                //np  ddlCounterName.Visible = true;
                //np  lblCounter.Visible = true;
            }
            else
            {
                //np  ddlCounterName.Visible = false;
                //np  lblCounter.Visible = false;
            }
        }
        if (Resources.Resource.TokenDisplay == "0" || Resources.Resource.TokenDisplay == "")
        {
            //np  lblCounter.Visible = false;
            //np ddlCounterName.Visible = false;
        }
    }
    protected void ddlCounterName_SelectedIndexChanged(object sender, EventArgs e)
    {
        //np if (ddlCounterName.SelectedItem.Value != "0")
        //np {
        try
        {
            //np  StockReports.ExecuteDML("Update f_login set CounterNo='" + ddlCounterName.SelectedItem.Value + "' where EmployeeId='" + Session["id"].ToString() + "'");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        //np  }
    }
    private void bindRole()
    {
        DataTable dt = StockReports.GetDataTable("SELECT rm.RoleName RoleName,rm.ID,isDefault FROM f_login fl INNER JOIN f_rolemaster rm ON fl.RoleID=rm.ID AND fl.EmployeeID='" + Util.GetString(Session["id"]) + "' AND fl.Active=1 AND fl.CentreID='" + Session["CentreID"].ToString() + "' AND rm.Active=1 ORDER BY rm.RoleName ");

        //np ddlRole.DataSource = dt;

        //np ddlRole.DataTextField = "RoleName";
        //np  ddlRole.DataValueField = "id";
        //np  ddlRole.DataBind();
        //np  ddlRole.Items.Insert(0, "---Select Role---");
        dt = dt.AsEnumerable().Where(r => r.Field<int>("isDefault") == 1).AsDataView().ToTable();

        //np if (dt.Rows.Count > 0)
        // string Rolename = StockReports.ExecuteScalar("Select RoleName from f_rolemaster where ID=(Select roleID from f_login where isDefault=1 and EmployeeID='" + Util.GetString(Session["ID"]) + "')");
        //np  ddlRole.SelectedIndex = ddlRole.Items.IndexOf(ddlRole.Items.FindByValue(dt.Rows[0]["ID"].ToString()));
    }
    private void LoadData()
    {
        try
        {
            //string str = "Select rl.RoleName,concat(DATE_FORMAT(l.CurLoginTime,'%d-%b-%y'),' ',TIME_FORMAT(l.CurLoginTime,'%h:%i:%p'))CurLoginTime," +
            //             "concat(DATE_FORMAT(l.LastLogintime,'%d-%b-%y'),' ',TIME_FORMAT(l.LastLogintime,'%h:%i:%p'))LastLogintime,l.NoOfLogins," +
            //            " concat(' ',em.Name)EmpName,if(l.IsDefault=1,rl.RoleName,rl.RoleName)IsDefaultRole from f_login l inner join f_rolemaster rl on l.RoleID = rl.ID" +

            //            " inner join employee_master em on em.Employee_ID = l.EmployeeID" +
            //            " where l.EmployeeID='" + Util.GetString(Session["ID"]) + "'" + 
            //            " and l.RoleID='" + Util.GetString(Session["RoleID"]) + "'";

            //DataTable dt = StockReports.GetDataTable(str);

            //if(dt !=null && dt.Rows.Count >0)
            //{
            //np lblName.Text = Session["LoginName"].ToString();

            //    //lblDesignation.Text = "STAFF";
            //    lblModule.Text = dt.Rows[0]["RoleName"].ToString();
            //    lblCLogin.Text = dt.Rows[0]["CurLoginTime"].ToString();
            //    lblLastLogin.Text = dt.Rows[0]["LastLogintime"].ToString();
            //}

            DataTable BirthDaydt = StockReports.GetDataTable(" SELECT CONCAT(Title,' ',NAME)NAME FROM employee_master WHERE IsActive=1 AND DAY(dob)=DAY(CURRENT_DATE) AND MONTH(dob)=MONTH(CURRENT_DATE) ");
            if (BirthDaydt.Rows.Count > 0)
            {
                //np   imgBirthDay.Visible = true;
                for (int i = 0; i < BirthDaydt.Rows.Count; i++)
                {
                    //np lblEmployeeName.Text += BirthDaydt.Rows[i]["NAME"].ToString() + ", ";
                }
                //np  int lenght = lblEmployeeName.Text.Length;
                //np  if (lenght > 0)
                {
                    //np  lblEmployeeName.Text = lblEmployeeName.Text.Substring(0, lenght - 2);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void ddlRole_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            StockReports.ExecuteDML("update f_login set isDefault=0 where EmployeeId='" + Session["id"].ToString() + "'");
            //np StockReports.ExecuteDML("update f_login set isDefault=1 where EmployeeId='" + Session["id"].ToString() + "' and RoleID='" + ddlRole.SelectedValue + "'");

            //  bindRole();
            //  LoadData();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void WelcomeMessage()
    {
        DataTable dtMessage = LoadCacheQuery.BindWelcomeMessage(Util.GetInt(Session["CentreID"].ToString()));
        if (dtMessage.Rows.Count > 0)
        {
            divWelcomeMessage.InnerHtml = dtMessage.Rows[0]["Message"].ToString();
            divWelcomeMessage.Attributes.Add("title", dtMessage.Rows[0]["DescriptionMessage"].ToString());
        }
        else
            divWelcomeMessage.InnerHtml = "";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string showdischarge(string RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT count(*) FROM f_ipdAdjustment id ");
        sb.Append("     INNER JOIN (SELECT pip1.TransactionID FROM patient_ipd_profile pip1 INNER JOIN ");
        sb.Append("     (SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID FROM  patient_ipd_profile pip INNER JOIN f_roomtype_role rtr ON pip.IPDCaseType_ID=rtr.IPDCaseType_ID ");
        sb.Append("     WHERE rtr.IPDCaseType_ID IN (SELECT IPDCaseType_ID FROM f_roomtype_role WHERE Role_ID='" + Util.GetString(RoleID) + "' GROUP BY Role_ID,IPDCaseType_ID) GROUP BY TransactionID ");
        sb.Append("     )pip2 ON pip1.PatientIPDProfile_ID=pip2.PatientIPDProfile_ID )pip ON id.TransactionID=pip.TransactionID  ");
        sb.Append(" WHERE id.IsPlanned=1 AND id.IsRoomClean=0");
        int checkdis = Util.GetInt(StockReports.ExecuteScalar(sb.ToString()));
        return Newtonsoft.Json.JsonConvert.SerializeObject(checkdis);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindDischargedPatients(string RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT PName,TransactionID,BedNo,ward, ");
        sb.Append("  PlanDis,FinalDischargeSummary,DischargeSummaryApproved,Intemation,MedClearnace,BillFreeze,DischargeDate, ");
        sb.Append("  BillDate,PatientClearnace,NurseClearnace,RoomClearnace, ");
        sb.Append("  IF(FinalDischargeSummary<>'','false',DishSummTAT)DishSummTAT, ");
        sb.Append("  IF(DischargeSummaryApproved<>'','false',DishSummApprovedTAT)DishSummApprovedTAT, ");
        sb.Append("  IF(Intemation<>'','false',DishIntimationTAT)DishIntimationTAT, ");
        sb.Append("  IF(MedClearnace<>'','false',MedClearedTAT)MedClearedTAT, ");
        sb.Append("  IF(BillFreeze<>'','false',BillFreezedTAT)BillFreezedTAT, ");
        sb.Append("  IF(BillDate<>'','false',BillGenTAT)BillGenTAT, ");
        sb.Append("  IF(PatientClearnace<>'','false',PatClearanceTAT)PatClearanceTAT, ");
        sb.Append("  IF(NurseClearnace<>'','false',NurseTAT)NurseTAT, ");
        sb.Append("  IF(RoomClearnace<>'','false',RoomTAT)RoomTAT ");
        sb.Append("  FROM ( ");
        sb.Append("     SELECT CONCAT(pm.Title,' ',pm.PName)PName, REPLACE(pmh.TransactionID,'ISHHI','')TransactionID, ");
        sb.Append("     (SELECT CONCAT(rm.Bed_No,'/',rm.Name) FROM patient_ipd_profile pip ");
        sb.Append("     INNER JOIN room_master rm ON rm.Room_ID=pip.Room_ID ");
        sb.Append("     WHERE pip.TransactionID=pmh.TransactionID ");
        sb.Append("     ORDER BY PatientIPDProfile_ID DESC LIMIT 1 ");
        sb.Append("     )BedNo, ");
        sb.Append("     (SELECT rm.Name FROM patient_ipd_profile pip ");
        sb.Append("     INNER JOIN room_master rm ON rm.Room_ID=pip.Room_ID ");
        sb.Append("     WHERE pip.TransactionID=pmh.TransactionID ");
        sb.Append("     ORDER BY PatientIPDProfile_ID DESC LIMIT 1 ");
        sb.Append("     )Ward, ");
        //  sb.Append("     IF(adj.IsPlanned=1,DATE_FORMAT(adj.PlanDateTime,'%d-%b-%y %I:%i %p'),'')PlanDis, ");

        sb.Append("  IF(adj.IsPlanned=1,IF(IsPlannedType=1,DATE_FORMAT(adj.PlanDateTime,'%d-%b-%y %I:%i %p'),DATE_FORMAT(adj.PlanTimeStamp,'%d-%b-%y %I:%i %p')),'')PlanDis,  ");

        sb.Append("     IF(adj.IsFinalDischSummary=1,DATE_FORMAT(adj.FinalDischSummaryTimestamp,'%d-%b-%y %I:%i %p'),'')FinalDischargeSummary,  ");
        sb.Append("     IF(adj.IsDischargeSummaryApprove=1,DATE_FORMAT(adj.DischargeSummaryApproveTimestamp,'%d-%b-%y %I:%i %p'),'')DischargeSummaryApproved,  ");
        sb.Append("     (SELECT IF(pip.IsDisIntimated=1,DATE_FORMAT(pip.IntimationTime,'%d-%b-%y %I:%i %p'),'' ) ");
        sb.Append("     FROM patient_ipd_profile pip WHERE pip.TransactionID=pmh.TransactionID AND pip.IsDisIntimated=1 ");
        sb.Append("     ORDER BY PatientIPDProfile_ID DESC LIMIT 1 ");
        sb.Append("     )  Intemation,  ");
        sb.Append("     IF(adj.IsMedCleared=1,DATE_FORMAT(adj.MedClearedDate,'%d-%b-%y %I:%i %p'),'')MedClearnace,  ");
        sb.Append("     IF(adj.IsBillFreezed=1,DATE_FORMAT(adj.BillFreezedTimeStamp,'%d-%b-%y %I:%i %p'),'')BillFreeze,  ");
        sb.Append("     IF(ich.Status='OUT',DATE_FORMAT(CONCAT(ich.DateOfDischarge,' ',ich.TimeOfDischarge),'%d-%b-%y %I:%i %p'),'')DischargeDate,  ");
        sb.Append("     IF((IFNULL(adj.BillNo,''))<>'',DATE_FORMAT(adj.BillDate,'%d-%b-%y %I:%i %p'),'')BillDate,  ");
        sb.Append("     IF(adj.IsClearance=1,DATE_FORMAT(adj.ClearanceTimeStamp,'%d-%b-%y %I:%i %p'),'')PatientClearnace,  ");
        sb.Append("     IF(adj.IsNurseClean=1,DATE_FORMAT(adj.NurseCleanTimeStamp,'%d-%b-%y %I:%i %p'),'')NurseClearnace,  ");
        sb.Append("     IF(adj.IsRoomClean=1,DATE_FORMAT(adj.RoomCleanTimeStamp,'%d-%b-%y %I:%i %p'),'')RoomClearnace,  ");
        sb.Append("     IF(CAST(TIME_TO_SEC(TIMEDIFF(adj.PlanDateTime, adj.FinalDischSummaryTimestamp))/60 AS UNSIGNED)>45 AND adj.FinalDischSummaryTimestamp<>'0001-01-01 00:00:00','true','false')DishSummTAT,  ");
        sb.Append("     IF(CAST(TIME_TO_SEC(TIMEDIFF(adj.FinalDischSummaryTimestamp,adj.DischargeSummaryApproveTimestamp))/60 AS UNSIGNED)>20 AND adj.DischargeSummaryApproveTimestamp<>'0001-01-01 00:00:00','true','false')DishSummApprovedTAT, ");
        sb.Append("     IF(IFNULL(CAST(TIME_TO_SEC(TIMEDIFF(adj.DischargeSummaryApproveTimestamp,(SELECT pip.IntimationTime  FROM patient_ipd_profile pip WHERE pip.TransactionID=pmh.TransactionID  ORDER BY PatientIPDProfile_ID DESC LIMIT 1)))/60 AS UNSIGNED),0)>20,'true','false')DishIntimationTAT,  ");
        sb.Append("     IF(CAST(TIME_TO_SEC(TIMEDIFF(( SELECT pip.IntimationTime  FROM patient_ipd_profile pip WHERE pip.TransactionID=pmh.TransactionID  ORDER BY PatientIPDProfile_ID DESC LIMIT 1), adj.MedClearedDate))/60 AS UNSIGNED)>15 AND adj.MedClearedDate<>'0001-01-01 00:00:00','true','false')MedClearedTAT,  ");
        sb.Append("     IF(CAST(TIME_TO_SEC(TIMEDIFF(adj.MedClearedDate, adj.BillFreezedTimeStamp))/60 AS UNSIGNED)>20 AND adj.BillFreezedTimeStamp<>'0001-01-01 00:00:00','true','false')BillFreezedTAT,  ");
        sb.Append("     IF(pnl.PanelGroup='TPA',  IF(CAST(TIME_TO_SEC(TIMEDIFF(adj.BillFreezedTimeStamp, adj.BillDate))/60 AS UNSIGNED)>30 AND adj.BillDate<>'0001-01-01 00:00:00' AND adj.BillDate IS NOT NUll,'true','false'),  ");
        sb.Append("     IF(CAST(TIME_TO_SEC(TIMEDIFF(adj.BillFreezedTimeStamp, adj.BillDate))/60 AS UNSIGNED)>15 AND adj.BillDate<>'0001-01-01 00:00:00' AND adj.BillDate IS NOT NUll,'true','false'))BillGenTAT,  ");
        sb.Append("     IF(pnl.PanelGroup='TPA',  IF(CAST(TIME_TO_SEC(TIMEDIFF(adj.BillDate, adj.ClearanceTimeStamp))/60 AS UNSIGNED)>240 AND adj.ClearanceTimeStamp<>'0001-01-01 00:00:00','true','false'),  ");
        sb.Append("     IF(pnl.PanelGroup='PSU',  IF(CAST(TIME_TO_SEC(TIMEDIFF(adj.BillDate, adj.ClearanceTimeStamp))/60 AS UNSIGNED)>5 AND adj.ClearanceTimeStamp<>'0001-01-01 00:00:00','true','false'),  ");
        sb.Append("     IF(CAST(TIME_TO_SEC(TIMEDIFF(adj.BillDate, adj.ClearanceTimeStamp))/60 AS UNSIGNED)>30 AND adj.ClearanceTimeStamp<>'0001-01-01 00:00:00','true','false')))PatClearanceTAT,  ");
        sb.Append("     IF(CAST(TIME_TO_SEC(TIMEDIFF(adj.ClearanceTimeStamp, adj.NurseCleanTimeStamp))/60 AS UNSIGNED)>10 AND adj.NurseCleanTimeStamp<>'0001-01-01 00:00:00','true','false')NurseTAT,  ");
        sb.Append("     IF(CAST(TIME_TO_SEC(TIMEDIFF(adj.NurseCleanTimeStamp, adj.RoomCleanTimeStamp))/60 AS UNSIGNED)>20 AND adj.RoomCleanTimeStamp<>'0001-01-01 00:00:00','true','false')RoomTAT  ");
        sb.Append("     FROM patient_medical_history pmh  ");
        sb.Append("     INNER JOIN f_ipdadjustment adj ON adj.TransactionID=pmh.TransactionID  ");
        sb.Append("     INNER JOIN ipd_case_history ich ON ich.TransactionID=pmh.TransactionID  ");
        sb.Append("     INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
        sb.Append("     INNER JOIN f_panel_master pnl ON pnl.PanelID=pmh.PanelID   ");

        sb.Append("     INNER JOIN (SELECT pip1.TransactionID FROM patient_ipd_profile pip1 INNER JOIN ");
        sb.Append("     (SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID FROM  patient_ipd_profile pip INNER JOIN f_roomtype_role rtr ON pip.IPDCaseType_ID=rtr.IPDCaseType_ID ");
        sb.Append("     WHERE rtr.IPDCaseType_ID IN (SELECT IPDCaseType_ID FROM f_roomtype_role WHERE Role_ID='" + Util.GetString(RoleID) + "' GROUP BY Role_ID,IPDCaseType_ID) GROUP BY TransactionID ");
        sb.Append("     )pip2 ON pip1.PatientIPDProfile_ID=pip2.PatientIPDProfile_ID )pip ON pmh.TransactionID=pip.TransactionID  ");

        sb.Append("     WHERE adj.IsPlanned=1");
        sb.Append("  )t WHERE RoomClearnace='' ORDER BY ward,BedNo ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string CloseBatchNumber(string EmployeeId)
    {
        string EndReceiptNo = "";
        StringBuilder sbnew = new StringBuilder();
        sbnew.Append(" SELECT ReceiptNo FROM f_reciept WHERE Reciever='" + EmployeeId.ToString() + "' ORDER BY DATE DESC,TIME DESC LIMIT 1 ");
        DataTable dtnew = StockReports.GetDataTable(sbnew.ToString());
        if (dtnew.Rows.Count > 0 && dtnew.Rows[0][0].ToString() != "")
        {
            EndReceiptNo = dtnew.Rows[0][0].ToString();
        }
        sbnew.Clear();
        sbnew.Append(" UPDATE Employee_Batch_details SET EndDate=CURRENT_DATE,EndTime=CURRENT_TIME,STATUS=1,EndReceiptNo='" + EndReceiptNo + "' WHERE Employe_Id='" + EmployeeId.ToString() + "' and STATUS=0 ");
        bool checkdis = StockReports.ExecuteDML(sbnew.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(checkdis);

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ShowCloseBatchButton(string EmployeeId)
    {
        StringBuilder sbnew = new StringBuilder();
        sbnew.Append(" select STATUS,BatchNumber from Employee_Batch_details WHERE Employe_Id='" + EmployeeId.ToString() + "' and status=0 ");
        DataTable Dtold = StockReports.GetDataTable(sbnew.ToString());
        if (Dtold.Rows.Count > 0 && Dtold.Rows[0][0].ToString() != "")
        {
            string Status = Dtold.Rows[0][0].ToString();
            return Newtonsoft.Json.JsonConvert.SerializeObject(Dtold);
        }
        else
            return "";

    }



    [WebMethod(EnableSession = true)]
    public static string GetDataToFill()
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();
             DataTable dt;
             sbnew.Append("SELECT IF(  IFNULL(tn.ExpiryDate,0)<>0 ,IF(CONCAT(DATE(tn.`ExpiryDate`),' ',TIME(tn.`ExpiryTime`))<NOW(),1,0),1)IsExpired, TIME_FORMAT(tn.ExpiryTime,'%h:%i %p')NewsExTimes,DATE_FORMAT( tn.ExpiryDate,'%d-%b-%Y')NewsExDates,TIME_FORMAT( tn.NewsTime,'%h:%i %p')NewsTimes, DATE_FORMAT( tn.NewsDate,'%d-%b-%Y')NewsDates,DATE_FORMAT(tn.EntryDate,'%d-%b-%Y')EntryDate,tn.* FROM tenwek_news tn WHERE tn.IsActive=1 and date(tn.NewsDate)>='" + Util.GetDateTime(DateTime.Now.AddDays(-15)).ToString("yyyy-MM-dd") + "' and time(tn.NewsTime)<='" + Util.GetDateTime(DateTime.Now).ToString("HH:mm:ss") + "' and date(tn.NewsDate)<='" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "' ORDER BY  date(tn.NewsDate) DESC ,time(tn.NewsTime) DESC  ");
           dt = StockReports.GetDataTable(sbnew.ToString());


            if (dt.Rows.Count <= 0)
            {
                sbnew = new StringBuilder();
                sbnew.Append("SELECT IF(  IFNULL(tn.ExpiryDate,0)<>0 ,IF(CONCAT(DATE(tn.`ExpiryDate`),' ',TIME(tn.`ExpiryTime`))<NOW(),1,0),1)IsExpired, TIME_FORMAT(tn.ExpiryTime,'%h:%i %p')NewsExTimes,TIME_FORMAT( tn.NewsTime,'%h:%i %p')NewsTimes, DATE_FORMAT( tn.NewsDate,'%d-%b-%Y')NewsDates,DATE_FORMAT(tn.EntryDate,'%d-%b-%Y')EntryDate,tn.* FROM tenwek_news tn WHERE tn.IsActive=1 order by ID DESC  limit 1");
                dt = StockReports.GetDataTable(sbnew.ToString());
            }

            
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

        }
    }


    [WebMethod(EnableSession = true)]
    public static string GetDataToFillByDate(string Date)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();

            DataTable dt = new DataTable();
            sbnew.Append("SELECT  TIME_FORMAT( tn.NewsTime,'%h:%i %p')NewsTimes, DATE_FORMAT( tn.NewsDate,'%d-%b-%Y')NewsDates,DATE_FORMAT(tn.EntryDate,'%d-%b-%Y')EntryDate,tn.* FROM tenwek_news tn WHERE tn.IsActive=1 and date(tn.NewsDate)='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "'  ORDER BY  date(tn.NewsDate),time(tn.NewsTime) DESC  ");
             dt = StockReports.GetDataTable(sbnew.ToString());



            if (dt.Rows.Count <= 0)
            {
                sbnew = new StringBuilder();
                sbnew.Append("SELECT  TIME_FORMAT( tn.NewsTime,'%h:%i %p')NewsTimes, DATE_FORMAT( tn.NewsDate,'%d-%b-%Y')NewsDates,DATE_FORMAT(tn.EntryDate,'%d-%b-%Y')EntryDate,tn.* FROM tenwek_news tn WHERE tn.IsActive=1 order by ID DESC  limit 1");
                dt = StockReports.GetDataTable(sbnew.ToString());
            }


            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

        }
    }



}
