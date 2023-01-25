using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_Orders : System.Web.UI.Page
{
    private DataTable dtSearch;
    string PID = "";
    string TID = "";
    string LabType = "";
    string IsView = "0";
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

        if (!string.IsNullOrEmpty(Request.QueryString["IsView"]))
        {
            IsView = Request.QueryString["IsView"].ToString();
        }



        lblMsg.Text = "";


        spnTransactionID.InnerText = TID;
        spnPatientID.InnerText = PID;


        LoginType = Convert.ToString(Session["LoginType"]).ToUpper();

        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientAdjustmentDetails(spnTransactionID.InnerText);
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;
            if (Resources.Resource.AllowFiananceIntegration == "1")//
            {
                if (AllLoadData_IPD.CheckDataPostToFinance(spnTransactionID.InnerText) > 0)
                {
                    string Msga = "Patient's Final Bill Already Posted To Finance...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msga);
                }
            }
            if (dtAuthority.Rows.Count > 0)
            {
                ViewState["IsDiscount"] = dtAuthority.Rows[0]["IsDiscount"].ToString();
                ViewState["IsRate"] = dtAuthority.Rows[0]["IsEdit"].ToString();
            }
            else
            {
                ViewState["IsDiscount"] = "1";
                ViewState["IsRate"] = "1";
            }
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsBillFreezed"].ToString() == "1")
                {
                    DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                    if ((dt.Rows[0]["IsBillFreezed"].ToString() == "1") && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
                    {
                        string Msg = "";
                        int auth = AllLoadData_IPD.IPDBillAuthorization(Session["ID"].ToString(), Util.GetInt(Session["RoleID"].ToString()));
                        if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0" && auth == 0)
                        {
                            Msg = "You Are Not Authorised To AMEND IPD Bills...";
                            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        }
                        else if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "1" && dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                        {
                            Msg = "Patient's Final Bill has been Closed for Further Updating...";
                            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        }
                    }
                    else if (dt.Rows[0]["IsBillFreezed"].ToString().Trim() == "1" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
                    {
                        string Msg = "";
                        Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                        Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                    }
                }
            }            
            
            
            
            
            
            
            
            
            
            
            
            ddlItemBind();
            BindData();
            BindMedData();
            hideshowgrd(1);

        }

        txtSelectDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        CalendarExtender1.StartDate = DateTime.Now;

        txtStopDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        CalendarExtender2.StartDate = DateTime.Now;


    }

    public void ddlItemBind()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT(im.ItemID)ItemId,im.TypeName ItemName  FROM  f_itemmaster im INNER JOIN crm_reminders_status cr ON cr.ItemId=im.ItemID");
        sb.Append(" where cr.PatientId='" + PID + "' and cr.TransactionId='" + TID + "' ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        ddlItem.DataSource = dt;
        ddlItem.DataValueField = "ItemId";
        ddlItem.DataTextField = "ItemName";
        ddlItem.DataBind();
        ddlItem.Items.Insert(0, "All");
    }

    public void BindData()
    {


        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT cr.RepeatDuration,cr.ID, IF(cr.TypeofScheduler=1,'Run Once','Run At Interval') TypOfSch, cr.PatientId,IF(cr.IsActive=0,0,IF( CONCAT(cr.AutoStopDate,' ',cr.AutoStopTime)<NOW(),0,1))IsActive,IF(cr.IsActive=0,'Stopped', IF( CONCAT(cr.AutoStopDate,' ',cr.AutoStopTime)<NOW(),'Stopped','Running'))Status,cr.TransactionId, DATE_FORMAT( cr.NextRunTime ,'%d-%b-%Y %r')NextRunTime,CONCAT(DATE_FORMAT(cr.StartDate,'%d-%b-%Y'),' ',DATE_FORMAT(cr.StartTime,'%r'))StartDate,cr.StartTime,   ");

        if (rblLabDepartmentType.SelectedValue == "4")
        {
            sb.Append(" cr.Id NotiId,cr.IsIndentDone IsIndentDone, IF(cr.IsIndentDone=1,'Indent Done','Indent Not Done')IndentStatus, ");

        }
        else
        {
            sb.Append(" crn.Id NotiId,if(crn.IsView,1,0) IsIndentDone, IF(crn.Isview=1,'Indent Done','Indent Not Done')IndentStatus, ");

        }

        sb.Append(" cr.ItemId,cr.Quantity,cr.DoctorId,cr.ReminderTypeName,cr.ReminderID,IM.TypeName ItemName ,CONCAT(dm.Title,' ',dm.NAME) Doctor  ,CONCAT(PM.Title,' ',PM.PName) Pname ");
        sb.Append(" FROM  crm_reminders_status cr   ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=cr.PatientId   ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=cr.ItemId   ");
        sb.Append(" INNER JOIN doctor_master DM ON DM.DoctorID=cr.DoctorId   ");
        if (rblLabDepartmentType.SelectedValue != "4")
        {

            sb.Append(" INNER JOIN crm_notification crn ON crn.ReminderID=cr.ID   ");
        }

        sb.Append(" WHERE IsDiscontinued=0 AND  cr.PatientId='" + PID + "' AND cr.TransactionId='" + TID + "' ");
        if (ddlItem.SelectedItem.ToString() != "All")
        {
            sb.Append(" And  cr.ItemId='" + ddlItem.SelectedValue.ToString() + "' ");
        }
        if (rblIndentStatus.SelectedValue != "2")
        {
            sb.Append(" And  crn.IsView=" + rblIndentStatus.SelectedValue + " ");
        }
        if (rblStatus.SelectedValue != "2")
        {
            sb.Append(" And  cr.IsActive=" + rblStatus.SelectedValue + " ");
        }

        if (rblondate.SelectedValue == "1")
        {
            sb.Append("   AND  cr.StartDate>='" + Util.GetDateTime(ucFromDate.Text.ToString()).ToString("yyyy-MM-dd") + "' AND CR.StartDate<='" + Util.GetDateTime(ucToDate.Text.ToString()).ToString("yyyy-MM-dd") + "' ");
        }
        else if (rblondate.SelectedValue == "2")
        {
            sb.Append("   AND  cr.AutoStopDate>='" + Util.GetDateTime(ucFromDate.Text.ToString()).ToString("yyyy-MM-dd") + "' AND CR.AutoStopDate<='" + Util.GetDateTime(ucToDate.Text.ToString()).ToString("yyyy-MM-dd") + "' ");

        }
        else if (rblondate.SelectedValue == "3")
        {
            sb.Append("   AND  date(cr.NextRunTime)>='" + Util.GetDateTime(ucFromDate.Text.ToString()).ToString("yyyy-MM-dd") + "' AND  date(cr.NextRunTime)<='" + Util.GetDateTime(ucToDate.Text.ToString()).ToString("yyyy-MM-dd") + "' ");

        }

        if (rblLabDepartmentType.SelectedValue != "0")
        {
            sb.Append("AND cr.ReminderID=" + rblLabDepartmentType.SelectedValue + "");

        }

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        GrdOrder.DataSource = dt;
        GrdOrder.DataBind();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (rblLabDepartmentType.SelectedValue=="4")
        {
            BindMedData();
            hideshowgrd(1);
        }
        else
        {
           
            BindData();
            hideshowgrd(0);
        }


    }
    protected void GrdOrder_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Stop")
        {
            ;
            int id = Convert.ToInt32(e.CommandArgument);
            string ID = ((Label)GrdOrder.Rows[id].FindControl("lblId")).Text;
            string Name = ((Label)GrdOrder.Rows[id].FindControl("lblPName")).Text;

            string IpNO = ((Label)GrdOrder.Rows[id].FindControl("lblTransactionId")).Text;


            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {

                string str = "update crm_reminders_status  set IsActive=0,IsForceFullyStop=1,StopBy='" + Session["ID"].ToString() + "',StopDate=NOW()  WHERE Id=" + Util.GetInt(ID) + " ";
                int i = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                if (i > 0)
                {
                    lblMsg.Text = "Stop Successfully";//"Order of " + Name + "( Ipd No. :- " + IpNO + " ) Stop Successfully";
                    Tnx.Commit();
                    BindData();
                }
                else
                {
                    Tnx.Rollback();
                }
            }
            catch (Exception ex)
            {
                Tnx.Rollback();

                throw (ex);
            }
            finally
            {
                Tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }


    [WebMethod(EnableSession = true, Description = "Save Lab And Radiology Order")]
    public static string SaveLabAndRadiologyOrder(int Id, string RepeatDuration, string TypeofDuration, string TypeOfSchedular, string StartDate, string StartTime, string StopDate, string StopTime, int NoOfRepetition)
    {
        string LedgerTransactionNo = string.Empty;
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            //Logic to Add  Stop Date Time on Behalf of No of repetition
            if (Util.GetInt(TypeOfSchedular) == 0)
            {
                DateTime dt = Util.GetDateTime(StartDate + ' ' + StartTime);

                if (TypeofDuration == "HOUR")
                {
                    dt = dt.AddHours(Util.GetInt(RepeatDuration) * Util.GetInt(NoOfRepetition));
                }
                else if (TypeofDuration == "MONTH")
                {
                    dt = dt.AddMonths(Util.GetInt(RepeatDuration) * Util.GetInt(NoOfRepetition));
                }
                else if (TypeofDuration == "WEEK")
                {
                    dt = dt.AddDays(Util.GetInt(RepeatDuration) * Util.GetInt(NoOfRepetition) * 7);
                }

                else if (TypeofDuration == "DAY")
                {
                    dt = dt.AddDays(Util.GetInt(RepeatDuration) * Util.GetInt(NoOfRepetition));
                }

                else if (TypeofDuration == "MINUTE")
                {
                    dt = dt.AddMinutes(Util.GetInt(RepeatDuration) * Util.GetInt(NoOfRepetition));
                }


                StopDate = dt.ToString("yyyy-MM-dd");
                StopTime = dt.ToString("HH:mm:ss");


            }

            StringBuilder sbdt = new StringBuilder();
            sbdt.Append("SELECT * FROM  crm_reminders_status cr WHERE cr.id=" + Id + "");
            DataTable data = new DataTable();
            data = StockReports.GetDataTable(sbdt.ToString());
            if (data.Rows.Count == 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
            //Discontinued ORDER 

            string str = "update crm_reminders_status  set IsDiscontinued=1 WHERE Id=" + Util.GetInt(Id) + " ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

            //NEW ENTRY AGAINSET DISCONTINUED ORDERED
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO  crm_reminders_status ");
            sb.Append(" (DiscontinuedId, ItemId,DurationVal,RequisitionType,PatientId,TransactionId,ReminderID,ReminderTypeName,TypeofScheduler,StartDate,StartTime,RepeatDuration,TypeofDuration,IsActive,EntryBy,Remark,DoctorId,Quantity,AutoStopDate,AutoStopTime, ");
            sb.Append(" Route,Meal,Dose,Timing,Duration,isDischargeMedicine,IsMedicineIndent,TypeOfMedicine,ToDepartment,NofRepetition ) ");
            sb.Append(" VALUES(@DiscontinuedId,@ItemId,@DurationVal,@RequisitionType,@PatientId,@TransactionId,@ReminderID,@ReminderTypeName,@TypeofScheduler,@StartDate,@StartTime,@RepeatDuration,@TypeofDuration,@IsActive,@EntryBy,@Remark,@DoctorId,@Quantity,@StopDate,@StopTime ,");
            sb.Append(" @Route,@Meal,@Dose,@Timing,@Duration,@isDischargeMedicine,@IsMedicineIndent,@TypeOfMedicine,@ToDepartment,@NofRepetition )");

            CountSave = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                DiscontinuedId = Id,
                ItemId = data.Rows[0]["ItemId"].ToString(),
                PatientId = data.Rows[0]["PatientId"].ToString(),
                TransactionId = data.Rows[0]["TransactionId"].ToString(),
                ReminderID = Util.GetInt(data.Rows[0]["ReminderID"].ToString()),
                ReminderTypeName = data.Rows[0]["ReminderTypeName"].ToString(),
                TypeofScheduler = TypeOfSchedular,
                StartDate = Util.GetDateTime(StartDate).ToString("yyyy-MM-dd"),
                StartTime = Util.GetDateTime(StartTime).ToString("HH:mm:ss"),
                RepeatDuration = Util.GetInt(RepeatDuration),
                TypeofDuration = TypeofDuration,
                StopDate = Util.GetDateTime(StopDate).ToString("yyyy-MM-dd"),
                StopTime = Util.GetDateTime(StopTime).ToString("HH:mm:ss"),
                IsActive = 1,
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),

                Remark = data.Rows[0]["Remark"].ToString(),
                DoctorId = data.Rows[0]["DoctorId"].ToString(),
                Quantity = Util.GetInt(data.Rows[0]["Quantity"].ToString()),

                Route = Util.GetString(data.Rows[0]["Route"].ToString()),
                Meal = Util.GetString(data.Rows[0]["Meal"].ToString()),
                Dose = Util.GetString(data.Rows[0]["Dose"].ToString()),
                Timing = Util.GetString(data.Rows[0]["Timing"].ToString()),
                Duration = Util.GetString(data.Rows[0]["Duration"].ToString()),

                isDischargeMedicine = Util.GetInt(data.Rows[0]["isDischargeMedicine"].ToString()),
                IsMedicineIndent = Util.GetBoolean(data.Rows[0]["IsMedicineIndent"].ToString()),
                TypeOfMedicine = Util.GetInt(data.Rows[0]["TypeOfMedicine"].ToString()),
                ToDepartment = data.Rows[0]["ToDepartment"].ToString(),
                DurationVal = Util.GetInt(data.Rows[0]["DurationVal"].ToString()),
                RequisitionType = Util.GetInt(data.Rows[0]["RequisitionType"].ToString()),
                NofRepetition = Util.GetInt(NoOfRepetition),
            });



            if (CountSave > 0)
            {
                tnx.Commit();
                
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Order Genrated Successfully" });

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
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public static DataTable BindLabAndRadiologyItem(string OrderID, string transactionid, string ItemId, string ReferenceCode, string IPDCaseTypeID, string ScheduleChargeID, string CentreID)
    {
        DataTable dt = new DataTable();
       
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  '" + System.DateTime.Now.ToString("dd-MMM-yyyy") + "' FromDate,DoctorId,Qty,TypeName,SubCategoryName,ItemCode,IF(Rate IS NULL,0,Rate) Rate, ");
        sb.Append("CONCAT(ItemId,'#',IF(Rate IS NULL,0,Rate),'#' ");
        sb.Append(",IF(IFNULL(ItemDisplayName,'')='',TypeName,ItemDisplayName),'#' ");
        sb.Append(",IF(ItemCode IS NULL,IFNULL(CPTCode,''),ItemCode),'#',IF(RateListID IS NULL,'',RateListID),'#',RateEditable,'#',GenderInvestigate,'#',TYPE,'#',IsOutSource, ");
        sb.Append("'#',OutSourceLabID,'#',SampleTypeName,'#',Type_ID,'#',SubCategoryID,'#',ConfigID)ItemId FROM (  ");
        sb.Append("SELECT im.TypeName AS TypeName,ims.GenderInvestigate,sub.Name AS SubCategoryName, ");
        sb.Append("IM.ItemID,IM.Type_ID,IM.SubCategoryID,RL.Rate,RL.ItemDisplayName,RL.ItemCode,RL.RateListID,IM.RateEditable,IM.ItemCode CPTCode, ");
        sb.Append("ims.TYPE,ims.IsOutSource,ims.OutSourceLabID,IFNULL(ims.SampleTypeName,'')SampleTypeName,cf.ConfigID,cr.Quantity AS Qty,cr.DoctorId ");
        sb.Append("FROM f_itemmaster IM  ");
        sb.Append("INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID`");
        sb.Append("INNER JOIN f_subcategorymaster sub ON  IM.SubCategoryID=sub.SubCategoryID   ");
        sb.Append("INNER JOIN investigation_master ims ON ims.Investigation_Id=im.Type_ID  ");
        sb.Append("INNER JOIN f_configrelation cf ON cf.CategoryID = sub.CategoryID  ");
        sb.Append("  INNER JOIN crm_reminders_status cr ON cr.ItemId=im.ItemID AND cr.ID IN(" + OrderID + ")   ");

        sb.Append("LEFT JOIN (  ");
        sb.Append("SELECT ID RateListID,ItemID,Rate,ItemDisplayName,ItemCode FROM f_ratelist_ipd WHERE  IPDCaseTypeID='" + IPDCaseTypeID.Trim() + "'  ");
        sb.Append("AND ScheduleChargeID='" + ScheduleChargeID.Trim() + "' AND PanelID='" + ReferenceCode.Trim() + "'  AND IsCurrent=1  and CentreID='" + CentreID + "'");
        sb.Append(") RL ON RL.ItemID=IM.ItemID WHERE cf.ConfigID=3 AND im.Isactive=1 AND itc.`IsActive`=1 AND itc.CentreID='" + CentreID + "' ");
        sb.Append(" AND IM.ItemId in (" + ItemId.Trim() + ") ");
      
       
        sb.Append(" )t  ORDER BY TypeName ");
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }


    public static DataTable BindIpdServicesItem(string OrderID, string transactionid, string ItemId, string ReferenceCode, string IPDCaseTypeID, string ScheduleChargeID, string CentreID)
    {
       
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT '" + System.DateTime.Now.ToString("dd-MMM-yyyy") + "' FromDate,DoctorId,Qty,TypeName,SubCategoryName,ItemCode,IF(Rate IS NULL,0,Rate) Rate, ");
        sb.Append("CONCAT(ItemId,'#',IF(Rate IS NULL,0,Rate),'#' ");
        sb.Append(",IF(IFNULL(ItemDisplayName,'')='',TypeName,ItemDisplayName),'#' ");
        sb.Append(",IF(ItemCode IS NULL,CPTCode,ItemCode),'#',IF(RateListID IS NULL,'',RateListID),'#',RateEditable,'#',GSTDetails,'#','NA','#','NA', ");
        sb.Append("'#','NA','#','NA','#',Type_ID,'#',SubCategoryID,'#',ConfigID)ItemId FROM (  ");
        sb.Append("SELECT im.TypeName AS TypeName,sub.Name AS SubCategoryName, ");
        sb.Append("IM.ItemID,IFNULL(IM.Type_ID,'')Type_ID,IM.SubCategoryID,RL.Rate,RL.ItemDisplayName,RL.ItemCode,RL.RateListID,IM.RateEditable,IM.ItemCode CPTCode, ");
        sb.Append("cf.ConfigID,CONCAT(IFNULL(IM.HSNCode,''),'^',IM.IGSTPercent,'^',IM.SGSTPercent,'^',IM.CGSTPercent,'^',IFNULL(IM.GSTType,''))GSTDetails,cr.Quantity AS Qty,cr.DoctorId ");
        sb.Append("FROM f_itemmaster IM  ");
        sb.Append("INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` ");
        sb.Append("INNER JOIN f_subcategorymaster sub ON  IM.SubCategoryID=sub.SubCategoryID   ");
        sb.Append("INNER JOIN f_configrelation cf ON cf.CategoryID = sub.CategoryID  ");
        sb.Append("  INNER JOIN crm_reminders_status cr ON cr.ItemId=im.ItemID AND cr.ID IN(" + OrderID + ")   ");

        sb.Append("LEFT JOIN (  ");
        sb.Append("SELECT ID RateListID,ItemID,Rate,ItemDisplayName,ItemCode FROM f_ratelist_ipd WHERE  IPDCaseTypeID='" + IPDCaseTypeID.Trim() + "'  ");
        sb.Append("AND ScheduleChargeID='" + ScheduleChargeID.Trim() + "' AND PanelID=" + ReferenceCode + "  AND IsCurrent=1  ");
        sb.Append(") RL ON RL.ItemID=IM.ItemID WHERE cf.ConfigID IN (2,6,8,9,10,20,24,14,26,27,29) AND im.Isactive=1 AND itc.`IsActive`=1 AND itc.CentreID='" + CentreID + "' ");
        sb.Append(" AND IM.ItemId in (" + ItemId.Trim() + ") ");
      
        sb.Append("  )t  ORDER BY TypeName ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public static DataTable DataTableBindProcedureItem(string OrderID, string transactionid, string ItemId, string ReferenceCode, string IPDCaseTypeID, string ScheduleChargeID, string CentreID)
    {
       
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT '" + System.DateTime.Now.ToString("dd-MMM-yyyy") + "' FromDate,DoctorId,Qty,TypeName,SubCategoryName,ItemCode,IF(Rate IS NULL,0,Rate) Rate, ");
        sb.Append("CONCAT(ItemId,'#',IF(Rate IS NULL,0,Rate),'#' ");
        sb.Append(",IF(IFNULL(ItemDisplayName,'')='',TypeName,ItemDisplayName),'#' ");
        sb.Append(",IF(ItemCode IS NULL,CPTCode,ItemCode),'#',IF(RateListID IS NULL,'0',RateListID),'#',RateEditable,'#',GSTDetails,'#','NA','#','NA', ");
        sb.Append("'#','NA','#','NA','#',Type_ID,'#',SubCategoryID,'#',ConfigID)ItemId FROM (  ");
        sb.Append("SELECT im.TypeName AS TypeName,sub.Name AS SubCategoryName, ");
        sb.Append("IM.ItemID,IM.Type_ID,IM.SubCategoryID,RL.Rate,RL.ItemDisplayName,RL.ItemCode,RL.RateListID,IM.RateEditable,IM.ItemCode CPTCode, ");
        sb.Append("cf.ConfigID,CONCAT(IFNULL(IM.HSNCode,''),'^',IM.IGSTPercent,'^',IM.SGSTPercent,'^',IM.CGSTPercent,'^',IFNULL(IM.GSTType,''))GSTDetails,cr.Quantity AS Qty ,cr.DoctorId ");
        sb.Append("FROM f_itemmaster IM  ");
        sb.Append("INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID`");
        sb.Append("INNER JOIN f_subcategorymaster sub ON  IM.SubCategoryID=sub.SubCategoryID   ");
        sb.Append("INNER JOIN f_configrelation cf ON cf.CategoryID = sub.CategoryID  ");
        sb.Append("  INNER JOIN crm_reminders_status cr ON cr.ItemId=im.ItemID AND cr.ID IN(" + OrderID + ")   ");

        sb.Append("LEFT JOIN (  ");
        sb.Append("SELECT ID RateListID,ItemID,Rate,ItemDisplayName,ItemCode FROM f_ratelist_ipd WHERE  IPDCaseTypeID='" + IPDCaseTypeID.Trim() + "'  ");
        sb.Append("AND ScheduleChargeID=" + ScheduleChargeID.Trim() + " AND PanelID=" + ReferenceCode.Trim() + "  AND IsCurrent=1 and CentreID=" + CentreID + " ");
        sb.Append(") RL ON RL.ItemID=IM.ItemID WHERE cf.ConfigID=25 AND im.Isactive=1 AND itc.`IsActive`=1 AND itc.CentreID='" + CentreID + "' ");
       
      sb.Append(" AND IM.ItemId in (" + ItemId.Trim() + ") ");
      
        sb.Append("  )t  ORDER BY TypeName ");
       return StockReports.GetDataTable(sb.ToString());
    }


    public static DataTable BindMedicineItem(string Type, string PanelID, string DeptLedgerNo, string OrderID, string transactionid, string ItemId, string CentreID)
    {
        
        DataTable dt = new DataTable();
      
        //if (canIndentMedicalConsumables == "0" && canIndentMedicalItems == "0")
        //    return dt;

        StringBuilder sb = new StringBuilder();
        if (Type == "0")
        {
            sb.Append("SELECT '" + System.DateTime.Now.ToString("dd-MMM-yyyy") + "' FromDate,IM.Typename AS ItemName,im.HSNCode,IFNULL(st.Qty,'0') AS AvlQty,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(st.Qty,''),'#',IFNULL(IM.UnitType,''),'#',IF(pay.ItemID IS NULL,'0','1'),'#',im.Dose,'#',im.MedicineType,'#',im.Route,'#','0','#',cr.CategoryID)ItemID");
            sb.Append(" ,dmo.Remark,dmo.DurationVal,0 RequisitionType, CONCAT(dmo.Dose,' ',dmo.DoseUnit )Dose,dmo.Route,dmo.DoctorId,dmo.IsDischargeMed isDischargeMedicine,0 TypeOfMedicine, '' Meal,dmo.Qty AS Qty,'' Timing, dmo.DepartmentId ToDepartment,dmo.DurationName Duration ");
                        
            sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_itemmaster_centerwise itc ON itc.`ItemID`=im.`ItemID` ");
            sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID ");
            sb.Append("  INNER JOIN tenwek_docotor_medicine_order dmo ON dmo.ItemId=im.ItemID AND dmo.ID IN(" + OrderID + ")   ");


            sb.Append(" INNER JOIN (SELECT IF(sum(InitialCount-ReleasedCount)>0,sum(InitialCount-ReleasedCount),0) ");
            sb.Append(" Qty,ItemID FROM f_stock WHERE isPost=1 AND (InitialCount-ReleasedCount)>0 ");
            if (DeptLedgerNo != "0")
                sb.Append(" AND DeptLedgerNo='" + DeptLedgerNo + "' AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
            sb.Append("  GROUP BY ITemID)st ON st.itemID = im.ItemID ");
            sb.Append(" LEFT JOIN f_panel_item_payable pay ON Pay.ItemID=im.ItemID AND Pay.PanelID='" + PanelID + "' AND  pay.IsActive=1 WHERE CR.ConfigID = 11 AND im.IsActive=1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + CentreID + "' ");

            sb.Append(" AND IM.ItemId in (" + ItemId.Trim() + ") ");

            sb.Append(" order by IM.Typename");
        }
        else if (Type == "1")
        {
            sb.Append(" select '" + System.DateTime.Now.ToString("dd-MMM-yyyy") + "' FromDate,im.HSNCode,IFNULL(st.Qty,'0') AS AvlQty,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(st.Qty,'0'),'#',IFNULL(IM.UnitType,''),'#',IF(pay.ItemID IS NULL,'0','1'),'#',im.Dose,'#',im.MedicineType,'#',im.Route,'#','0','#',cr.CategoryID)ItemID,im.typename AS ItemName ");
            sb.Append(" ,CRS.Remark, crs.DurationVal,crs.RequisitionType,crs.Dose,crs.Route,crs.DoctorId,crs.isDischargeMedicine,crs.TypeOfMedicine,crs.Meal,crs.Quantity AS Qty,crs.Timing,crs.ToDepartment,crs.Duration ");
            
            sb.Append(" from f_itemmaster im ");
            sb.Append(" INNER join f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID INNER JOIN f_itemmaster_centerwise itc ON itc.`ItemID`=im.`ItemID` ");
            sb.Append("  INNER JOIN crm_reminders_status crs ON crs.ItemId=im.ItemID AND crs.ID IN(" + OrderID + ")   ");

            
            sb.Append(" INNER JOIN (SELECT IF(sum(InitialCount-ReleasedCount)>0,sum(InitialCount-ReleasedCount),0) ");
            sb.Append(" Qty,ItemID FROM f_stock WHERE isPost=1 AND (InitialCount-ReleasedCount)>0 ");
            sb.Append(" AND DeptLedgerNo='" + DeptLedgerNo + "' AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' GROUP BY ITemID)st ON st.itemID = im.ItemID ");
            sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=im.ItemID LEFT JOIN f_salt_master fsm ON fis.saltID = fsm.SaltID ");
            sb.Append(" LEFT JOIN f_panel_item_payable pay ON Pay.ItemID=im.ItemID AND Pay.PanelID='" + PanelID + "' AND  pay.IsActive=1 WHERE fsm.IsActive=1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + CentreID + "' ");
            sb.Append(" AND IM.ItemId in (" + ItemId.Trim() + ") ");
            sb.Append(" order by im.Typename");
        }
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
    [WebMethod(EnableSession = true)]
    public static string GetItemID(string RemainderType, string transactionid, string PanelId, string OrderID, string ReferenceCode, string IPDCaseTypeID, string ScheduleChargeID, string CentreID)
    {

        try
        {
            StringBuilder sb = new StringBuilder();
            //sb.Append("SELECT GROUP_CONCAT(cr.ItemId) ItemId FROM crm_reminders_status cr WHERE cr.ID IN("+OrderID+")");

            DataTable dt = new DataTable();

            DataTable appointmentDetails = new DataTable();

            if (RemainderType == "4") // This Is for Medicine Item
            {
                sb.Append("  SELECT GROUP_CONCAT(dmo.ItemId)ItemId,GROUP_CONCAT(dmo.Id)OrId,dmo.DepartmentId ToDepartment,0 TypeOfMedicine,'4' RemainderTypeId FROM tenwek_docotor_medicine_order dmo  WHERE dmo.ID  IN(" + OrderID + ")  ");
               
                dt = StockReports.GetDataTable(sb.ToString());

            }
            else
            {

                sb.Append("SELECT GROUP_CONCAT(cr.ItemId)ItemId,GROUP_CONCAT(cr.ID)OrId,cr.ReminderID RemainderTypeId,CR.TypeOfMedicine,CR.ToDepartment FROM crm_notification crn INNER JOIN crm_reminders_status cr ON crn.ReminderId=cr.ID WHERE crn.ID IN(" + OrderID + ") ");
                dt = StockReports.GetDataTable(sb.ToString());

            }
            if (dt.Rows[0]["RemainderTypeId"].ToString() == "1" || dt.Rows[0]["RemainderTypeId"].ToString() == "2")
            {
                appointmentDetails = BindLabAndRadiologyItem(dt.Rows[0]["OrId"].ToString(), transactionid, dt.Rows[0]["ItemId"].ToString(), ReferenceCode, IPDCaseTypeID, ScheduleChargeID, CentreID);
                if (appointmentDetails.Rows.Count > 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = appointmentDetails });
                else
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = appointmentDetails, Message = "No Data Found,Select Order" });
          
            }
            else if (dt.Rows[0]["RemainderTypeId"].ToString() == "3")
            {
                appointmentDetails = BindIpdServicesItem(dt.Rows[0]["OrId"].ToString(), transactionid, dt.Rows[0]["ItemId"].ToString(), ReferenceCode, IPDCaseTypeID, ScheduleChargeID, CentreID);
                if (appointmentDetails.Rows.Count > 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = appointmentDetails });
                else
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = appointmentDetails, Message = "No Data Found ,Select Order" });
          
            }
            else if (dt.Rows[0]["RemainderTypeId"].ToString() == "4" && RemainderType == "4")
            {
                appointmentDetails = BindMedicineItem(dt.Rows[0]["TypeOfMedicine"].ToString(), PanelId, dt.Rows[0]["ToDepartment"].ToString(), dt.Rows[0]["OrId"].ToString(), transactionid, dt.Rows[0]["ItemId"].ToString(), CentreID);
                if (appointmentDetails.Rows.Count > 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = appointmentDetails });
                else
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = appointmentDetails, Message = "No Data Found ,Select Order" });
          
            }
            else if (dt.Rows[0]["RemainderTypeId"].ToString() == "5")
            {
                appointmentDetails = DataTableBindProcedureItem(dt.Rows[0]["OrId"].ToString(), transactionid, dt.Rows[0]["ItemId"].ToString(), ReferenceCode, IPDCaseTypeID, ScheduleChargeID, CentreID);
                if (appointmentDetails.Rows.Count > 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = appointmentDetails });
                else
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = appointmentDetails, Message = "No Data Found ,Select Order" });
          
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = appointmentDetails, Message = "No Data Found ,Select Order" });
            }
             
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }







    protected void grdMedicine_RowCommand(object sender, GridViewCommandEventArgs e)
    {

    }



    public void BindMedData()
    {


        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT IFNULL(CONCAT(ems.Title,' ' ,ems.NAME),'') AS ApprovedBy, tdm.IsApproved,tdm.ApprovedRemark,if(tdm.IsApproved=1,'Approved', if( tdm.IsApproved=2,'Reject','Not Approved'))ApprovedStatus ,tdm.Id,tdm.IsView,if(tdm.IsPrn=0,'NO','YES')PrnView,tdm.IsPrn,tdm.ItemId,tdm.ItemName,tdm.PatientId,tdm.TransactionId,tdm.DepartmentId, ");
        sb.Append("  DATE_FORMAT(tdm.StartDate,'%d-%b-%Y')StartDate,tdm.EndDate,tdm.IsNow,tdm.FirstDose,tdm.Dose,tdm.DoseUnit,tdm.IntervalId, ");
        sb.Append(" tdm.IntervalName,tdm.DurationName,tdm.DurationVal,tdm.Route,tdm.Qty,tdm.DoctorId,tdm.DoctorName, ");
        sb.Append(" tdm.Remark,tdm.IsDischargeMed,tdm.IndentNo, ");
        sb.Append(" IF(tdm.IsIndentDone=1,IF(IFNULL(fid.ReceiveQty,0)>0,'Transfered To Ward','Indent Done'),'Pending Indent ')  IndentStatus, ");
        sb.Append(" tdm.IsIndentDone,DATE_FORMAT(tdm.FinalDoseTime,'%d-%b-%Y %H:%i %p')FinalDoseTime,DATE_FORMAT(CONCAT( tdm.StartDate,' ',tdm.FirstDose),'%d-%b-%Y %H:%i %p')StartDoseTime , ");
        sb.Append(" ROUND((24 /(SELECT IFNULL( COUNT(sdt.DoseId),1) FROM tenwek_standard_dose_time sdt WHERE sdt.DoseId= tdm.IntervalId)),0)Frequency , ");
        sb.Append(" CONCAT(tdm.Dose,' / ',tdm.Route)DoseRoute,CONCAT(tdm.Dose,' ',tdm.DoseUnit )Doses,CONCAT(em.Title,' ' ,em.NAME) AS OrderBy,tdm.IsActive,tdm.IsDisContinue, ");
        sb.Append(" IF( IFNULL( tdm.DoseTime,'')='',(SELECT GROUP_CONCAT(TIME_FORMAT( sdt.Time,'%H:%i')) FROM tenwek_standard_dose_time sdt WHERE sdt.DoseId= tdm.IntervalId),tdm.DoseTime )ScheduleDose, ");
        sb.Append(" (CONCAT( ROUND((SELECT fs.MRP FROM f_stock fs WHERE fs.ItemID=tdm.ItemId  ORDER BY id DESC LIMIT 1),2),' X ',tdm.Qty,' = ',ROUND(((SELECT fs.MRP FROM f_stock fs WHERE fs.ItemID=tdm.ItemId  ORDER BY id DESC LIMIT 1)* tdm.Qty),2)) )CostQty ");
        sb.Append(" FROM Tenwek_Docotor_medicine_Order tdm  ");
        sb.Append(" LEFT JOIN f_indent_detail_patient fid ON fid.IndentNo=tdm.IndentNo and fid.ItemId=tdm.ItemId ");
        sb.Append(" INNER JOIN  employee_master em ON em.EmployeeID=tdm.EntryBy ");
        sb.Append(" left JOIN  employee_master ems ON ems.EmployeeID=tdm.ApprovedBy ");

        sb.Append(" WHERE tdm.IsActive=1 AND tdm.IsDisContinue=0 AND tdm.PatientId='" + PID + "' AND  tdm.TransactionId='" + TID + "' ");

        if (rblIndentStatus.SelectedValue != "2")
        {
            sb.Append(" And  tdm.IsIndentDone=" + rblIndentStatus.SelectedValue + " ");
        }

        sb.Append(" ORDER by tdm.id desc");
        DataTable dt = new DataTable();
         dt = StockReports.GetDataTable(sb.ToString());
 
        grdMedicine.DataSource = dt;
        grdMedicine.DataBind();
    }

    public void hideshowgrd(int Typ)
    {
        if (Typ==0)
        {
            grdMedicine.Visible = false;
            GrdOrder.Visible = true;
        }
        else
        {
            grdMedicine.Visible = true;
            GrdOrder.Visible = false;
        }
    }





    [WebMethod(EnableSession = true)]
    public static string ViewOrders(string Id)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var sqlCMD = string.Empty;

        try
        {
            sqlCMD = "update Tenwek_Docotor_medicine_Order set IsView=1,ViewBy=@Updateby,ViewByName=@ViewByName,ViewDateTime=now() where ID in (" + Id + ") ";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Updateby = HttpContext.Current.Session["ID"].ToString(),
                ViewByName = HttpContext.Current.Session["EmployeeName"].ToString()
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Acknowledge Successfully." });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    
    [WebMethod(EnableSession = true)]
    public static string ApproveOrder(string Id,string ApprovedRemark,int isApproved)
    {
        string Message="Approved Successfully";

        if (isApproved==2)
        {
            Message = "Rejected Successfully";

        }
         

        if (GetEmployeeType(HttpContext.Current.Session["ID"].ToString())==1)
        {
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You can not approve. Contact to Primary Nurse." });

        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var sqlCMD = string.Empty;

        try
        {
            sqlCMD = "update Tenwek_Docotor_medicine_Order set IsApproved=@isApproved,ApprovedRemark=@ApprovedRemark,ApprovedDateTime=now(),ApprovedBy=@ApprovedBy where ID in (" + Id + ") ";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                ApprovedBy = HttpContext.Current.Session["ID"].ToString(),
                ApprovedRemark = ApprovedRemark,
                isApproved = Util.GetInt(isApproved)
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Message });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
     



    public static int GetApprovalType(string EmployeeId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.`EmployeeID`,em.`Title`,em.`NAME` FROM  employee_master em WHERE em.`TierID`=8 AND em.`EmployeeID`='" + EmployeeId + "' AND em.`IsActive`=1; ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            return 0;

        }
        else
        {
            return 1;

        }

    }

    public static int GetEmployeeType(string EmployeeId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.`EmployeeID`,em.`Title`,em.`NAME` FROM  employee_master em WHERE em.`TierID`=8 AND em.`EmployeeID`='" + EmployeeId + "' AND em.`IsActive`=1; ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            return 1;

        }
        else
        {

            return 0;
        }

    }


}