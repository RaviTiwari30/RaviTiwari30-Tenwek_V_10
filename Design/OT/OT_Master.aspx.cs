using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;

public partial class Design_OT_OT_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtOTStartTime.Text = "08:00 AM";
            txtOTEndTime.Text = "08:00 PM";
            txtDoctorSchedulingDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calExtenderTxtDoctorSchedulingDate.StartDate = System.DateTime.Now;
        }


        txtDoctorSchedulingDate.ReadOnly = true;
    }



    [WebMethod(EnableSession = true)]
    public static string CreateOT(string OTName, string OTStartTime, string OTEndTime, int SlotMins)
    {
        try
        {

            ExcuteCMD excuteCMD = new ExcuteCMD();

            excuteCMD.DML("INSERT INTO ot_master (NAME, StartTime, EndTime, CreatedBy,SlotMins,CentreID ) VALUES (@name,@startTime,@endTime,@createdBy,@slotMins,@centreID)", CommandType.Text, new
            {

                name = OTName,
                startTime = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy") + " " + OTStartTime).ToString("HH:mm"),
                endTime = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy") + " " + OTEndTime).ToString("HH:mm"),
                createdBy = HttpContext.Current.Session["ID"].ToString(),
                slotMins = SlotMins,
                centreID = HttpContext.Current.Session["CentreID"].ToString()
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage });
        }

    }


    [WebMethod]
    public static string GetExitingOTs()
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable("SELECT mm.Name,TIME_FORMAT(mm.StartTime,'%h:%i %p')StartTime, TIME_FORMAT(mm.EndTime,'%h:%i %p')EndTime, mm.SlotMins, CONCAT(em.Title,' ',em.Name)CreatedBy, DATE_FORMAT(mm.CreateDateTime,'%d-%b-%y %h:%i %p' )CreatedOn, IFNULL(CONCAT(em1.Title,' ',em1.Name),'')LastUpdatedBy, IFNULL(DATE_FORMAT(mm.LastUpdateTime,'%d-%b-%y %h:%i %p'),'')LastUpdateOn FROM  ot_master  mm INNER JOIN  employee_master em  ON em.EmployeeID=mm.CreatedBy LEFT JOIN  employee_master em1  ON em.EmployeeID=mm.LastUpdateBy WHERE mm.IsActive=1 ", CommandType.Text, new { });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    public class slot
    {

        public int OTID { get; set; }
        public string startTime { get; set; }
        public string endtime { get; set; }
        public int isDayWiseSelection { get; set; }
        public string scheduleOnText { get; set; }
    }



    [WebMethod(EnableSession=true)]
    public static string SaveDoctorSlotAllocations(string doctorID, List<slot> slotLists)
    {


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {

            ExcuteCMD excuteCMD = new ExcuteCMD();
            var userID = HttpContext.Current.Session["ID"].ToString();



            var slotDayWise = slotLists.Where(i => i.isDayWiseSelection == 1).ToList();

            var slotDateWise = slotLists.Where(i => i.isDayWiseSelection == 0).ToList();


            if (slotDayWise.Count > 0)
            {

                excuteCMD.DML(tnx, "UPDATE ot_doctor_slotsallocation_daywise ot SET IsActive=0 ,DeActiveBy=@deActiveBy,DeActiveDateTime=NOW() WHERE DoctorID=@doctorID", CommandType.Text, new
                {

                    deActiveBy = userID,
                    doctorID = doctorID
                });


                excuteCMD.DML(tnx, "UPDATE ot_doctor_slotsallocation_datewise ot SET IsActive=0 ,DeActiveBy=@deActiveBy,DeActiveDateTime=NOW() WHERE DoctorID=@doctorID", CommandType.Text, new
                {

                    deActiveBy = userID,
                    doctorID = doctorID
                });

                for (int i = 0; i < slotDayWise.Count; i++)
                {

                    excuteCMD.DML(tnx, "INSERT INTO ot_doctor_slotsallocation_daywise (OTID,DoctorID, StartTime, EndTime,CentreID,EntryBy,Day ) VALUES (@otID,@doctorID,@startTime,@endTime,@centreID,@entryBy,@day)", CommandType.Text, new
                        {
                            otID = slotDayWise[i].OTID,
                            doctorID = doctorID,
                            startTime = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy") + " " + slotDayWise[i].startTime).ToString("HH:mm"),
                            endTime = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy") + " " + slotDayWise[i].endtime).ToString("HH:mm"),
                            centreID = HttpContext.Current.Session["CentreID"].ToString(),
                            entryBy = userID,
                            day = slotDayWise[i].scheduleOnText
                        });

                }
            }


            if (slotDateWise.Count > 0)
            {

                excuteCMD.DML(tnx, "UPDATE ot_doctor_slotsallocation_datewise ot SET IsActive=0 ,DeActiveBy=@deActiveBy,DeActiveDateTime=NOW() WHERE DoctorID=@doctorID", CommandType.Text, new
                {

                    deActiveBy = userID,
                    doctorID = doctorID
                });

                for (int i = 0; i < slotDateWise.Count; i++)
                {

                    excuteCMD.DML(tnx, "INSERT INTO ot_doctor_slotsallocation_datewise (OTID,DoctorID, StartTime, EndTime,CentreID,EntryBy,SlotDate ) VALUES (@otID,@doctorID,@startTime,@endTime,@centreID,@entryBy,@slotDate)", CommandType.Text, new
                    {
                        otID = slotDateWise[i].OTID,
                        doctorID = doctorID,
                        startTime = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy") + " " + slotDateWise[i].startTime).ToString("HH:mm"),
                        endTime = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy") + " " + slotDateWise[i].endtime).ToString("HH:mm"),
                        centreID = HttpContext.Current.Session["CentreID"].ToString(),
                        entryBy = userID,
                        slotDate = Util.GetDateTime(slotDateWise[i].scheduleOnText).ToString("yyyy-MM-dd")
                    });

                }
            }


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
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
    public static string GetDoctorBookedSlots(string doctorID)
    {


        ExcuteCMD excuteCMD = new ExcuteCMD();

        var dt = excuteCMD.GetDataTable(" SELECT ot.ID,ot.OTID, TIME_FORMAT(ot.StartTime,'%h:%i %p')startTime, TIME_FORMAT(ot.EndTime,'%h:%i %p')endTime ,om.Name,1 isDayWiseSelection,ot.Day scheduleOnText FROM ot_doctor_slotsallocation_daywise ot INNER  JOIN ot_master om ON om.ID=ot.OTID WHERE ot.IsActive=1 AND ot.DoctorID=@doctorID AND ot.CentreID=@centreID Union all SELECT ot.ID,ot.OTID, TIME_FORMAT(ot.StartTime,'%h:%i %p')startTime, TIME_FORMAT(ot.EndTime,'%h:%i %p')endTime ,om.Name,0 isDayWiseSelection,DATE_FORMAT(ot.SlotDate,'%d-%b-%Y') scheduleOnText FROM ot_doctor_slotsallocation_datewise ot INNER  JOIN ot_master om ON om.ID=ot.OTID WHERE ot.IsActive=1 AND ot.DoctorID=@doctorID AND ot.CentreID=@centreID", CommandType.Text, new
        {
            centreID = HttpContext.Current.Session["CentreID"].ToString(),
            doctorID = doctorID

        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }







}