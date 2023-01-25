using AjaxControlToolkit;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_OT_OT_TAT : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["OTBookingID"] = Request.QueryString["OTBookingID"].ToString();
            bindTATType();
        }
    }

    [WebMethod]
    public static string BindType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT concat(s.`ID`,'#',s.`IsMainDoctor`) as ID,s.`StaffTypeName` FROM ot_staff_type_master s WHERE s.`IsActive`=1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static bool CompareTime(string StartTime,string EndTime)
    {
        int timediff = Util.TimeDiffInMin(Util.GetDateTime(StartTime), Util.GetDateTime(EndTime));
        if (timediff < 0)
            return false;
        else
            return true;
    }
   

    [WebMethod]
    public static string BindStaff(int typeId, int isMainDoctor)
    {
        DataTable dt = new DataTable();
        if (isMainDoctor == 0)
            dt = StockReports.GetDataTable(" SELECT s.`ID` as DoctorID,s.`StaffName` as Name FROM ot_staff_master s WHERE s.`IsActive`=1 AND s.`StaffTypeID`=" + typeId + " ORDER BY s.`StaffName` ");
        else
            dt = All_LoadData.bindDoctor();


        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string bindOTTATType(int OTBookingID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT o.`ID`,o.`TATTypeName` FROM ot_tat_type_master o WHERE o.id NOT IN(1,3) AND o.`IsActive`=1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    private void bindTATType()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT opt.EntryBy,o.`ID`,IFNULL(DATE_FORMAT(opt.OtStartDate,'%d-%b-%Y'), DATE_FORMAT(NOW(),'%d-%b-%Y'))OtStartDate,o.`TATTypeName` ,if(opt.`StartTime` is null,'false','true') as IsSelected, IFNULL(TIME_FORMAT(opt.`StartTime`,'%I:%i %p'),TIME_FORMAT(CURRENT_TIME(),'%I:%i %p')) as StartTime,CONCAT(IFNULL(em.Title,''),' ',IFNULL(em.NAME,''))EmpName FROM ot_tat_type_master o LEFT JOIN ot_patienttat opt ON opt.`TATTypeID`=o.`ID` AND opt.`OTBookingID`=" + ViewState["OTBookingID"].ToString() + " AND opt.`IsActive`=1  LEFT JOIN employee_master em ON em.EmployeeID=IF(IFNULL(opt.UpdatedBy,'')<>'',IFNULL(opt.UpdatedBy,''),IFNULL(opt.EntryBy,''))  WHERE o.id NOT IN(1,3) AND o.`IsActive`=1 GROUP BY o.`ID` ORDER BY o.DisplayPriority ");
        gvOTTATType.DataSource = dt;
        gvOTTATType.DataBind();

        int rowsCount = this.gvOTTATType.Rows.Count;
        for (int k = 0; k <= rowsCount - 1; k++)
        {
            bool ischecked = ((CheckBox)(this.gvOTTATType).Rows[k].FindControl("chkSelect")).Checked;
           
            TextBox textBox = new TextBox();
            textBox.ID = "txtTime_" + k.ToString();
            textBox.Text = dt.Rows[k]["StartTime"].ToString();
            textBox.Attributes.Add("runat", "server");
            textBox.Attributes.Add("ClientIDMode", "Static");
            textBox.CssClass = "txtTime";
            textBox.EnableViewState = true;
            if (ischecked == false)
            {
                textBox.Text = "";

            }
            this.gvOTTATType.Rows[k].Cells[4].Controls.Add(textBox);
            MaskedEditExtender mee = new MaskedEditExtender();
            mee.ID = "me_" + k.ToString();
            mee.Mask = "99:99";
            mee.MaskType = MaskedEditType.Time;
            mee.AcceptAMPM = true;
            mee.InputDirection = MaskedEditInputDirection.LeftToRight;
            mee.TargetControlID = "txtTime_" + k.ToString();
            this.gvOTTATType.Rows[k].Cells[4].Controls.Add(mee);

            MaskedEditValidator mev = new MaskedEditValidator();
            mev.ID = "mev_" + k.ToString();
            mev.ControlToValidate = "txtTime_" + k.ToString();
            mev.ControlExtender = "me_" + k.ToString();
            mev.IsValidEmpty = true;
            mev.ForeColor = System.Drawing.Color.Red;
            mev.EmptyValueMessage = "Time Required";
            mev.InvalidValueMessage = "Invalid Time";
            mev.ValidationGroup = "save";
            this.gvOTTATType.Rows[k].Cells[4].Controls.Add(mev);




            TextBox textBoxDate = new TextBox();
            textBoxDate.ID = "txtDate_" + k.ToString();
            textBoxDate.Text = dt.Rows[k]["OtStartDate"].ToString();
            textBoxDate.Attributes.Add("runat", "server");
            textBoxDate.Attributes.Add("ClientIDMode", "Static");
            textBoxDate.Attributes.Add("readonly", "readonly");
            textBoxDate.CssClass = "txtUcDate";
            textBoxDate.EnableViewState = true;
            if (ischecked == false )
            {
                textBoxDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
                
            }
            
            this.gvOTTATType.Rows[k].Cells[3].Controls.Add(textBoxDate);

            //HiddenField textBoxEmployee = new HiddenField();
            TextBox textBoxEmployee = new TextBox();
            textBoxEmployee.ID = "txtEmployee_" + k.ToString();
            textBoxEmployee.Text = dt.Rows[k]["EntryBy"].ToString();
            textBoxEmployee.Attributes.Add("runat", "server");
            textBoxEmployee.Attributes.Add("ClientIDMode", "Static");
            textBoxEmployee.CssClass = "txtEmployeeID";
            //textBoxEmployee.Style.Add("display", "none");
            textBoxEmployee.EnableViewState = true;
            //textBoxEmployee.Visible = false;

            this.gvOTTATType.Rows[k].Cells[3].Controls.Add(textBoxEmployee);

            CalendarExtender CE = new CalendarExtender();
            CE.ID = "CE_" + k.ToString();
            CE.Format = "dd-MMM-yyyy";
            CE.TargetControlID = "txtDate_" + k.ToString();
            this.gvOTTATType.Rows[k].Cells[3].Controls.Add(CE);
           
        }

    }

    [WebMethod]
    public static string bindSavedStaff(int OTBookingID)
    {
        DataTable dt = StockReports.GetDataTable("  SELECT o.`StaffTypeID`,o.`StaffID`,o.`StaffName`,TIME_FORMAT(o.`StartTime`,'%I:%i %p') as StartTime,TIME_FORMAT(o.`EndTme`,'%I:%i %p') as EndTme,otm.`StaffTypeName` FROM ot_patienttat o INNER JOIN `ot_staff_type_master` otm ON otm.`ID`=o.`StaffTypeID` WHERE o.`OTBookingID`=" + OTBookingID + " AND o.`IsActive`=1 AND o.`TATTypeID`=3 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SaveType(int type, string typeID, string typeName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            ExcuteCMD excuteCMD = new ExcuteCMD();
            int IsExist = 0;
            if (type == 1)
                IsExist = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM ot_staff_type_master s WHERE s.`StaffTypeName`='" + typeName + "' AND s.`IsActive`=1 "));

            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Type Name is already Exist." });
            }

            if (type == 1)
            {
                sqlQuery = "INSERT INTO ot_staff_type_master(`StaffTypeName`,EntryBy,EntrydateTime) VALUES(@Name,@EntryBy,NOW())";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    Name = typeName,
                    EntryBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            if (type == 2)
            {
                sqlQuery = "UPDATE ot_staff_type_master SET IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=now() WHERE ID=@TypeID";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TypeID = typeID,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            tnx.Commit();
            if (type == 1)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record De-Activated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveStaff(int type, string typeID, string staffName, string staffID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            ExcuteCMD excuteCMD = new ExcuteCMD();
            int IsExist = 0;
            if (type == 1)
                IsExist = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM ot_staff_master s WHERE s.StaffTypeID=" + typeID + " and s.`StaffName`='" + staffName + "' AND s.`IsActive`=1 "));

            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Staff Name is already Exist." });
            }

            if (type == 1)
            {
                sqlQuery = "INSERT INTO ot_staff_master(`StaffName`,StaffTypeID,EntryBy,EntrydateTime) VALUES(@Name,@StaffTypeID,@EntryBy,NOW())";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    Name = staffName,
                    StaffTypeID = typeID,
                    EntryBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            if (type == 2)
            {
                sqlQuery = "UPDATE ot_staff_master SET IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=now() WHERE ID=@StaffID";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    StaffID = staffID,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            tnx.Commit();
            if (type == 1)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record De-Activated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SaveTAT(object tatDetailsData, int otBookingID)
    {
        List<TATDetails> datatatDetails = new JavaScriptSerializer().ConvertToType<List<TATDetails>>(tatDetailsData);

        if (datatatDetails.Count == 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select Atleast One Row" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO ot_PatientTAT(OTBookingID,TransactionID,PatientID,SurgeryID,OTBookingNo,OTID,TATTypeID,StaffTypeID,StaffID,StaffName,StartTime,EndTme,CentreID,EntryBy,EntryDateTime,IPAdress,OtStartDate) ");
            sb.Append(" VALUES(@OTBookingID, @TransactionID, @PatientID, @SurgeryID, @OTBookingNo, @OTID, @TATTypeID, @StaffTypeID, @StaffID, @StaffName, @StartTime, @EndTme, @CentreID, @EntryBy, now(), @IPAdress,@OtStartDate) ");

            DataTable dtBookingDetails = StockReports.GetDataTable("SELECT TransactionID,PatientID,SurgeryID,OTNumber,OTID FROM ot_booking WHERE ID=" + otBookingID + "");

            excuteCMD.DML(tnx, "update ot_PatientTAT set IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=now() where TATTypeID<>1 AND OTBookingID=@OTBookingID ", CommandType.Text, new
            {
                UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                OTBookingID = otBookingID
            });

            for (int i = 0; i < datatatDetails.Count; i++)
            {
                string empid = datatatDetails[i].EmployeeID;
                if (datatatDetails[i].EmployeeID == null || datatatDetails[i].EmployeeID == "")
                {
                    empid = HttpContext.Current.Session["ID"].ToString();
                }
                excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    OTBookingID = otBookingID,
                    TransactionID = dtBookingDetails.Rows[0]["TransactionID"].ToString(),
                    PatientID = dtBookingDetails.Rows[0]["PatientID"].ToString(),
                    SurgeryID = dtBookingDetails.Rows[0]["SurgeryID"].ToString(),
                    OTBookingNo = dtBookingDetails.Rows[0]["OTNumber"].ToString(),
                    OTID = dtBookingDetails.Rows[0]["OTID"].ToString(),
                    TATTypeID = datatatDetails[i].tatTypeID,
                    StaffTypeID = datatatDetails[i].staffTypeID,
                    StaffID = datatatDetails[i].staffID,
                    StaffName = datatatDetails[i].staffName,
                    StartTime = Util.GetDateTime(datatatDetails[i].inTime).ToString("HH:mm:ss"),
                    EndTme = Util.GetDateTime(datatatDetails[i].outTime).ToString("HH:mm:ss"),
                    CentreID = HttpContext.Current.Session["CentreID"].ToString(),
                    IPAdress = All_LoadData.IpAddress(),
                    EntryBy = empid,
                    OtStartDate = Util.GetDateTime(datatatDetails[i].OtStartDate).ToString("yyyy-MM-dd")
                });

            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class TATDetails
    {
        public int tatTypeID { get; set; }
        public int staffTypeID { get; set; }
        public string staffID { get; set; }
        public string staffName { get; set; }
        public string inTime { get; set; }
        public string outTime { get; set; }
        public string OtStartDate { get; set; }
        public string EmployeeID { get; set; }
    }
}