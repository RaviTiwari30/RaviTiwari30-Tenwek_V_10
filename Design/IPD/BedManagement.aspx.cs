using System;
using System.Linq;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

using MySql.Data.MySqlClient;

public partial class Design_EDP_BedManagement : System.Web.UI.Page
{
    int TRoom = 0;
    int ORoom = 0;
    int ARoom = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            //  BindBedStatus(1);
        }
    }
    protected void rpFloor_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Repeater rpBD = (Repeater)e.Item.FindControl("rpBD");
            rpBD.DataSource = GetFloorRoomType(((Label)e.Item.FindControl("lblFloor")).Text);
            rpBD.DataBind();
        }

    }
    private DataTable GetFloorRoomType(string Floor)
    {
        //int a = 0;
        DataTable dtRoom = null;
        ViewState["dtRoom1"] = null;
        if (ViewState["dtRoomType"] != null)
        {
            DataTable dtRoomType = (DataTable)ViewState["dtRoomType"];
            DataRow[] rows = dtRoomType.Select("Floor = '" + Floor + "'");
            //for (int i = 0; i < dtRoomType.Rows.Count; i++)
            //{
            //    if (dtRoomType.Rows[i]["TRoom"].ToString() != "")
            //    {
            //        lblTRoom.Text = dtRoomType.Rows[i]["sum(TRoom)"].ToString();
            //    }
            //}

            if (rows.Length > 0)
            {
                dtRoom = dtRoomType.Clone();
                foreach (DataRow dr in rows)
                    dtRoom.ImportRow(dr);
            }
            ViewState["dtRoom1"] = dtRoom;
            return dtRoom;

        }
        return null;
    }
    private void BindBedStatus(int Type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT if(DATE(rm.Creator_Date)=CURDATE(),1,0)NewRoom,na.Room_Id AdmittedRoomID,dis.Room_Id DischargeRoomID,ict.IPDCaseTypeID AS IPDCaseType_ID,ict.Name,CONCAT(rm.Room_No,'-',rm.Bed_No) RoomName,UPPER(rm.Floor)Floor,  ");
        sb.Append(" CASE WHEN IFNULL(ar.room_id,'')<>'' THEN '15' WHEN IFNULL(p.room_id,'')<>'' THEN '3' WHEN IFNULL(p1.room_id,'')<>'' THEN '16' WHEN IFNULL(d.room_id,'')<>'' THEN '4' ELSE '2' END STATUS, ");
        sb.Append(" CASE WHEN IFNULL(ar.room_id,'')<>'' THEN 'url(../../Images/AdvanceRoomBook.jpg)'  WHEN  IFNULL(p.room_id,'')<>'' THEN 'url(../../Images/OccupiedBed.jpg)' WHEN IFNULL(p1.room_id,'')<>'' THEN 'url(../../Images/AttendentRoom.jpg)' WHEN IFNULL(d.room_id,'')<>'' THEN  'url(../../Images/HouseKeeping.jpg)' ELSE 'url(../../Images/AvailableBed.jpg)' END StCol,  ");
        sb.Append(" CASE WHEN  IFNULL(p.room_id,'')<>'' THEN CONCAT('Room Name : ',rm.Room_No,'-',rm.Bed_No,'&#13;Name : ',p.PatientName,'&#13;MR.No. : ',p.PatientID ,CAST('&#13;IPD.No. : 'AS CHAR),REPLACE(p.TransactionID,'ISHHI',''),CAST('&#13;Admit Date/Time : ' AS CHAR),p.Admit,CAST('&#13;Doctor : 'AS CHAR),p.dName) WHEN IFNULL(p1.room_id,'')<>'' THEN CONCAT('Room Name : ',rm.Room_No,'-',rm.Bed_No,'&#13;Attendant Name : ',p1.Name,CAST('&#13;IPD.No. : 'AS CHAR),REPLACE(p1.TransactionID,'ISHHI',''),CAST('&#13;Admit Date/Time : ' AS CHAR),p1.Admit) WHEN IFNULL(d.room_id,'')<>'' THEN  CONCAT('Room Name : ',rm.Room_No,'-',rm.Bed_No) ELSE  CONCAT('Room Name : ',rm.Room_No,'-',rm.Bed_No) END PDetails  ");
        sb.Append(" FROM room_master rm inner join ipd_case_type_master ict ON rm.IPDCaseTypeID = ict.IPDCaseTypeID left join (select pip.TransactionID,pip.RoomID AS Room_ID,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName,(CONCAT(ich.DateOfAdmit,'/',ich.TimeOfAdmit))Admit,CONCAT(dm.Title,' ',dm.Name)dName");
        sb.Append(" FROM patient_ipd_profile pip inner join patient_master pm on pip.PatientID = pm.PatientID inner join patient_medical_history ich on pip.TransactionID = ich.TransactionID inner join doctor_master dm on dm.DoctorID = ich.DoctorID where pip.Status = 'IN' )p on rm.RoomId = p.Room_ID "); //ipd_case_history
        //sb.Append(" LEFT JOIN (SELECT adj.`IsRoomClean`,pip.TransactionID,pip.Room_ID,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName,  ");
        //sb.Append(" (CONCAT(ich.DateofDischarge,'/',ich.TimeOfDischarge))Discharge,  ");
        //sb.Append(" CONCAT(dm.Title,' ',dm.Name)dName   ");
        //sb.Append(" FROM patient_ipd_profile pip   ");
        //sb.Append(" INNER JOIN f_ipdadjustment adj ON adj.`TransactionID`=pip.`TransactionID` ");
        //sb.Append(" INNER JOIN patient_master pm ON pip.PatientID = pm.PatientID   ");
        //sb.Append(" INNER JOIN ipd_case_history ich ON pip.TransactionID = ich.TransactionID   ");
        //sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = ich.Consultant_ID   ");
        //sb.Append(" WHERE pip.Status = 'OUT' AND ich.DateofDischarge<>'0001-01-01' ORDER BY DateofDischarge DESC LIMIT 1)D ON rm.Room_Id = D.Room_ID  ");
        sb.Append(" LEFT JOIN (SELECT RM.Room_ID FROM (SELECT RoomID AS Room_ID,NAME,Room_No,Bed_No,FLOOR FROM room_master  WHERE IsActive=1 AND isAttendent=0 AND IsRoomClean=2)rm LEFT JOIN "+
            " (SELECT (CONCAT(ich.DateofDischarge,'/',ich.TimeOfDischarge))Discharge,RoomID AS Room_ID,IsDisIntimated,IntimationTime,pip.TransactionID FROM patient_ipd_profile pip INNER JOIN patient_medical_history ich ON pip.TransactionID = ich.TransactionID  WHERE ICH.STATUS='IN' )pip ON pip.Room_ID = rm.Room_ID WHERE pip.room_ID IS NULL )D ON rm.RoomId = D.Room_ID  ");//ipd_case_history
        sb.Append(" LEFT JOIN ");
        sb.Append("   ( SELECT pip.Name, pip.RoomID AS Room_ID,pip.TransactionID,(CONCAT(pip.startDate,'/',pip.StartTime))Admit FROM patient_attender_profile pip ");
        sb.Append("   WHERE pip.Status = 'IN' )p1 ON rm.RoomId = p1.Room_ID ");
        sb.Append(" LEFT JOIN ( SELECT pip.RoomID AS Room_ID,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName FROM advance_room_booking pip INNER JOIN patient_master pm ON pip.PatientID = pm.PatientID  WHERE pip.IsCancel =0 and BookingDate=curdate() )ar ON rm.RoomId = ar.Room_ID ");
        sb.Append(" LEFT JOIN (SELECT i.RoomID AS Room_ID FROM patient_ipd_profile i WHERE i.Status='OUT' AND i.EndDate=CURDATE())dis ON rm.RoomId = dis.Room_ID  ");
        sb.Append(" LEFT JOIN (SELECT ICH.`TransactionID`,pip.`RoomID` AS Room_ID FROM patient_medical_history ich INNER JOIN patient_ipd_profile pip ON pip.`TransactionID`=ich.`TransactionID` WHERE DateOfAdmit=CURDATE() GROUP BY ich.`TransactionID`)na ON na.Room_ID=rm.RoomID "); //#ipd_case_history
        sb.Append(" INNER JOIN floor_master fm ON fm.Name=rm.Floor WHERE rm.IsActive=1 and ict.IsActive=1 ");
        sb.Append(" AND rm.CentreID=" + Session["CentreID"].ToString() + " ");
        if (Type == 6)
            sb.Append(" having DischargeRoomID IS NOT NULL ");
        else if (Type == 5)
            sb.Append(" having AdmittedRoomID IS NOT NULL ");
            else if (Type == 21)
            sb.Append(" having NewRoom=1 ");
        else if (Type != 1)
            sb.Append(" having STATUS='" + Type + "' ");
        
        sb.Append(" order by fm.sequenceNo+0,rm.Room_No,rm.Floor,ict.name,rm.name,rm.Bed_No ");
        
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ViewState["dtRoom"] = dt;
            StringBuilder sbRT = new StringBuilder();

            //New for room type request
            sbRT.Append(" select t1.IPDCaseType_ID,Name,Floor,ORoom,TRoom,ARoom,Round((ARoom*100)/TRoom,2)APer,Round((ORoom*100)/TRoom,2)OPer, ");
            sbRT.Append(" IFNULL(t2.TotalRequest,0)RRoom,IF(t2.TotalRequest IS NULL,'none','hand')STATUS,IF(t2.TotalRequest='0','','#FFC0CB')StCol,IF(t2.TotalRequest='0','',CONCAT('Total Request : ',t2.TotalRequest,'&#13;IPD No. : ',t2.IPDNo))BedRequests ");
            sbRT.Append(" from (select ict.IPDCaseTypeID AS IPDCaseType_ID,ict.Name,rm.Floor,count(rm.Name) TRoom,count(rm.Name)- (COUNT(p.Room_ID)+COUNT(A.Room_ID)) ARoom,(COUNT(p.Room_ID)+COUNT(A.Room_ID))ORoom   ");
            sbRT.Append(" from room_master rm inner join ipd_case_type_master ict on rm.IPDCaseTypeID = ict.IPDCaseTypeID  AND rm.IsActive=1 and ict.IsActive=1 left join (select RoomID AS Room_ID from patient_ipd_profile where Status = 'IN' )p");
            sbRT.Append(" on rm.RoomId = p.Room_ID LEFT JOIN (SELECT RoomID AS Room_ID FROM patient_attender_profile WHERE STATUS = 'IN' )A ON rm.RoomId = A.Room_ID where rm.CentreID='" + Session["CentreID"].ToString() + "' GROUP BY rm.Floor,rm.IPDCaseTypeID )t1 ");
            sbRT.Append(" INNER JOIN (SELECT ictm.IPDCaseTypeID AS IPDCaseType_ID,(IFNULL(t.TotalRequest,0))TotalRequest,t.IPDNo FROM ipd_case_type_master ictm LEFT JOIN (SELECT RequestedRoomType AS IPDCaseType_ID,COUNT(*)TotalRequest,GROUP_CONCAT(REPLACE(ich.TransactionID,'ISHHI',''))IPDNo ");
            sbRT.Append(" FROM patient_medical_history ich WHERE ich.Status='IN' AND ich.IsRoomRequest=1 GROUP BY RequestedRoomType)t ON ictm.IPDCaseTypeID=t.IPDCaseType_ID ");//ipd_case_history

            sbRT.Append("  )t2 ON t1.IPDCaseType_ID=t2.IPDCaseType_ID ");
            sbRT.Append("  order by Name desc ");

            DataTable dt1 = StockReports.GetDataTable(sbRT.ToString());
            ViewState["dtRoomType"] = dt1;
            rpFloor.DataSource = dt.DefaultView.ToTable(true, new string[] { "Floor"});
            rpFloor.DataBind();
            lblMsg.Text = string.Empty;
        }
        else
        {
            rpFloor.DataSource = null;
            rpFloor.DataBind();
            lblMsg.Text = "No Record Found...";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "key1", "modelAlert('Rooms are not available as per searching');", true);
            return;
        }
    }
    protected void rpBD_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DataList dlRoom = (DataList)e.Item.FindControl("dlRoom");
            DataTable dtRoomDetail = GetRooms(((Label)e.Item.FindControl("lblRoomType")).Text);
            if (dtRoomDetail != null)
            {
                dlRoom.DataSource = dtRoomDetail;
                dlRoom.DataBind();
            }
            else
            {
                e.Item.Visible = false;
            }
        }

    }
    private DataTable GetRooms(string RoomType)
    {
        DataTable dtRoomStatus = null;
        if (ViewState["dtRoom"] != null)
        {
            DataTable dtRoom = (DataTable)ViewState["dtRoom"];
            DataTable dtIndi_Room = (DataTable)ViewState["dtRoom1"];
            string RoomTypeID = dtIndi_Room.Rows[0]["floor"].ToString();
            DataRow[] rows = dtRoom.Select("IPDCaseType_ID = '" + RoomType + "' and floor='" + RoomTypeID + "'");
            if (rows.Length > 0)
            {
                dtRoomStatus = dtRoom.Clone();
                foreach (DataRow dr in rows)
                    dtRoomStatus.ImportRow(dr);
            }

            return dtRoomStatus;
        }
        return null;
    }
    protected void btnBind_Click(object sender, EventArgs e)
    {
        int Type = Util.GetInt(txtType.Text.Trim());
        BindBedStatus(Type);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "key1", "showBedManagementModel(" + Type + ");", true);
    }

    protected void btnBind1_Click(object sender, EventArgs e)
    {
        //int Type = Util.GetInt(txtType.Text.Trim());
        BindLocationStatus();
        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "key1", "showLocationManagementModel();", true);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "key1", "showLocationManagementModel();", true);
    }


    //=================================================================================
    public void list_ItemCommand1(object source, RepeaterCommandEventArgs e)
    {

        
        string pid = e.CommandName;
        DropDownList ddlfc = (DropDownList)e.Item.FindControl("ddlFirstCall");
        int did = Convert.ToInt32(ddlfc.SelectedValue);
        string dname = (ddlfc.SelectedItem.Text);
        string MaxID = StockReports.ExecuteScalar("SELECT MAX(ID) FROM f_doctorshift WHERE TransactionID=(SELECT transactionId FROM patient_medical_history WHERE patientid=" + pid + " ORDER BY TransactionId DESC LIMIT 1)");
        string transid = StockReports.ExecuteScalar("SELECT transactionId FROM patient_medical_history WHERE patientid=" + pid + " and TYPE='IPD' AND STATUS='IN' ");

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string time = Util.GetDateTime(DateTime.Now).ToString("HH:mm:ss");
            string ShiftTime = Util.GetDateTime(DateTime.Now).ToString("HH:mm:ss");

            string ShiftDate = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");



            string strUpd = "Update f_doctorshift set ToDate='" + ShiftDate + "',ToTime='" + ShiftTime + "',Status='OUT' where ID=" + MaxID;
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strUpd);

            string strIns = "Insert into f_doctorshift (TransactionID,DoctorID,FromDate,FromTime,UserID,Status)values (" + transid + ",'" + did + "','" + ShiftDate + "','" + ShiftTime + "', '','IN')";

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strIns);

            string str = "UPDATE patient_medical_history pmh SET pmh.DoctorID='" + did + "',pmh.LastUpdatedBy = '" + ViewState["ID"] + "',pmh.Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',pmh.IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "'  WHERE pmh.TransactionID=(select TransactionId from f_doctorshift where Id=" + MaxID + ")";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "DELETE FROM f_multipledoctor_ipd WHERE TransactionID="+transid+" AND DoctorID=(select DoctorId from f_doctorshift where ID="+MaxID+")");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Insert into f_multipledoctor_ipd(TransactionID,DoctorID,DoctorName)values('" + transid+ "','" +did + "','" + dname + "')");
            

            Tnx.Commit();

            ScriptManager.RegisterClientScriptBlock((source as Control), this.GetType(), "alert", "alert('Saved Sucessfully'); $('#divLocationManagementModel').showModel();", true);
        
            
            
            


        }
        catch (Exception ex)
        {
            Tnx.Rollback();


            ScriptManager.RegisterClientScriptBlock((source as Control), this.GetType(), "alert", "alert('Error '); $('#divLocationManagementModel').showModel();", true);
        
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }


        
        Label status = (Label)e.Item.FindControl("lblStatus");
        status.Visible = false;
        Label flag = (Label)e.Item.FindControl("lblFlag");
        flag.Text = "1";


        //ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "alert", "alert('Member Registered Sucessfully');", true);
    }
    protected void rpFloor1_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Repeater rpBD = (Repeater)e.Item.FindControl("rpBD1");
            rpBD.DataSource = GetFloorRoomType1(((Label)e.Item.FindControl("lblFloor1")).Text);
            rpBD.DataBind();
        }

    }
    private DataTable GetFloorRoomType1(string Floor)
    {
        //int a = 0;
        DataTable dtRoom = null;
        ViewState["dtRoom1"] = null;
        if (ViewState["dtRoomType1"] != null)
        {
            DataTable dtRoomType = (DataTable)ViewState["dtRoomType1"];
            DataRow[] rows = dtRoomType.Select("Name = '" + Floor + "'");
            //for (int i = 0; i < dtRoomType.Rows.Count; i++)
            //{
            //    if (dtRoomType.Rows[i]["TRoom"].ToString() != "")
            //    {
            //        lblTRoom.Text = dtRoomType.Rows[i]["sum(TRoom)"].ToString();
            //    }
            //}

            if (rows.Length > 0)
            {
                dtRoom = dtRoomType.Clone();
                foreach (DataRow dr in rows)
                    dtRoom.ImportRow(dr);
            }
            ViewState["dtRoom1"] = dtRoom;
            return dtRoom;

        }
        return null;
    }
    private void BindLocationStatus()
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT DISTINCT(Location) FROM tbllocation ");
        sb.Append("SELECT distinct( ict.Name) as Location FROM patient_ipd_profile pip INNER JOIN ipd_case_type_master ict ON ict.IPDCaseTypeID=pip.IPDCaseTypeID WHERE STATUS='IN' AND pip.centreID=" + Session["CentreID"].ToString()+"");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ViewState["dtRoom1"] = dt;
            StringBuilder sbRT = new StringBuilder();

           // sbRT.Append("SELECT *,pm.Age AS Age1,loc.Location  AS Location1 FROM patient_master pm INNER JOIN tbllocation loc ON loc.PatientId=pm.PatientId "+
            //    "  INNER JOIN patient_ipd_profile pip ON pip.PatientID=pm.PatientID");
            sbRT.Append(" SELECT p.TransactionID,0 as IsFlowSheetsBlink,0 as IsIOBlink,0 as IsMedBlink,0 as IsReportsBlink,0 as IsLabsBlink,(SELECT ipoc.Weight FROM IPD_Patient_ObservationChart ipoc WHERE "+
                " ipoc.PatientId=p.PatientId ORDER BY ipoc.Id DESC LIMIT 1) as Weight1," +
                "(SELECT Doctorid FROM f_doctorshift WHERE transactionId=(SELECT transactionId FROM patient_medical_history WHERE patientid=p.PatientId ORDER BY TransactionId DESC LIMIT 1)"+
                " ORDER BY Id DESC LIMIT 1) as FirstCall1," +
                "(SELECT IF(COUNT(*)>0,1,0) FROM nursingprogress np WHERE np.PatientId=p.PatientId AND np.isSeen=0) as IsNursingNoteBlink1, " +
                " (SELECT IF(COUNT(*)>0,1,0) FROM nursing_doctorprogressnote WHERE IsSeen=0 and transactionid in(SELECT  transactionid FROM patient_medical_history WHERE patientId=p.PatientId"
            +" ORDER BY TransactionId DESC)) as IsDoctorNoteBlink1," +
                " (SELECT IF(COUNT(*)>0,1,0) FROM IPD_Patient_ObservationChart poc WHERE poc.PatientId=p.PatientId AND isSeen=0) as IsVitalsBlink1,p.PatientId, "+
                " IF(DATE(rm.Creator_Date)=CURDATE(),1,0)NewRoom,na.Room_Id AdmittedRoomID,dis.Room_Id DischargeRoomID,ict.IPDCaseTypeID AS IPDCaseType_ID," +
"ict.Name,CONCAT(rm.Room_No,'-',rm.Bed_No) RoomName,UPPER(rm.Floor)FLOOR, "+  
"CASE WHEN IFNULL(ar.room_id,'')<>'' THEN '15' WHEN IFNULL(p.room_id,'')<>'' THEN '3' WHEN IFNULL(p1.room_id,'')<>'' THEN '16' WHEN IFNULL(d.room_id,'')<>''"+ 
"THEN '4' ELSE '2' END STATUS,  CASE WHEN IFNULL(ar.room_id,'')<>'' THEN 'url(../../Images/AdvanceRoomBook.jpg)'  WHEN  IFNULL(p.room_id,'')<>'' "+
"THEN 'url(../../Images/OccupiedBed.jpg)' WHEN IFNULL(p1.room_id,'')<>'' THEN 'url(../../Images/AttendentRoom.jpg)' WHEN IFNULL(d.room_id,'')<>'' "+
"THEN  'url(../../Images/HouseKeeping.jpg)' ELSE 'url(../../Images/AvailableBed.jpg)' END StCol,   CASE WHEN  IFNULL(p.room_id,'')<>'' "+
"THEN CONCAT('Room Name : ',rm.Room_No,'-',rm.Bed_No,'&#13;Name : ',p.PatientName,'&#13;MR.No. : ',p.PatientID ,CAST('&#13;IPD.No. : 'AS CHAR),"+
"REPLACE(p.TransNo,'ISHHI',''),CAST('&#13;<br/>Admit Date/Time : ' AS CHAR),p.Admit,CAST('&#13;Doctor : 'AS CHAR),p.dName) WHEN IFNULL(p1.room_id,'')<>'' " +
"THEN CONCAT('Room Name : ',rm.Room_No,'-',rm.Bed_No,'&#13;Attendant Name : ',p1.Name,CAST('&#13;IPD.No. : 'AS CHAR),REPLACE(p.TransNo,'ISHHI','')," +
"CAST('&#13;Admit Date/Time : ' AS CHAR),p1.Admit) WHEN IFNULL(d.room_id,'')<>'' THEN  CONCAT('Room Name : ',rm.Room_No,'-',rm.Bed_No) ELSE  "+
"CONCAT('Room Name : ',rm.Room_No,'-',rm.Bed_No) END PDetails,p.HD1,p.PName,p.ClassDoctorNoteBlink " +
",p.ClassNursingNoteBlink,p.ClassLabsBlink,p.ClassReportsBlink,p.ClassMedBlink,p.ClassVitalsBlink" +
",p.ClassIOBlink,p.ClassFlowSheetsBlink  FROM  room_master rm INNER JOIN ipd_case_type_master ict ON rm.IPDCaseTypeID = ict.IPDCaseTypeID " +
"LEFT JOIN (SELECT pip.TransactionID,ich.TransNo,pip.RoomID AS Room_ID,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName," +
"(CONCAT(ich.DateOfAdmit,'/',ich.TimeOfAdmit))Admit,DATEDIFF(CURDATE(),DATE(ich.DateOfAdmit)) HD1,CONCAT(dm.Title,' ',dm.Name)dName,pm.PName,'' as ClassDoctorNoteBlink " +
",'' as ClassNursingNoteBlink,'' as ClassLabsBlink,'' as ClassReportsBlink,'' as ClassMedBlink,'' as ClassVitalsBlink"+
",'' as ClassIOBlink,'' as ClassFlowSheetsBlink FROM patient_ipd_profile pip " +
"INNER JOIN patient_master pm ON pip.PatientID = pm.PatientID   INNER JOIN patient_medical_history ich ON pip.TransactionID = ich.TransactionID "+
 "INNER JOIN doctor_master dm ON dm.DoctorID = ich.DoctorID WHERE pip.Status = 'IN' )p ON rm.RoomId = p.Room_ID  LEFT JOIN "+
 "(SELECT RM.Room_ID FROM (SELECT RoomID AS Room_ID,NAME,Room_No,Bed_No,FLOOR FROM room_master  WHERE IsActive=1 AND isAttendent=0 AND IsRoomClean=2)rm "+
 "LEFT JOIN  (SELECT (CONCAT(ich.DateofDischarge,'/',ich.TimeOfDischarge))Discharge,RoomID AS Room_ID,IsDisIntimated,IntimationTime,pip.TransactionID,ich.TransNo " +
 "FROM patient_ipd_profile pip INNER JOIN patient_medical_history ich ON pip.TransactionID = ich.TransactionID  WHERE ICH.STATUS='IN' )pip ON pip.Room_ID = rm.Room_ID "+
 "WHERE pip.room_ID IS NULL )D ON rm.RoomId = D.Room_ID   LEFT JOIN    ( SELECT pip.Name, pip.RoomID AS Room_ID,pip.TransactionID,"+
 "(CONCAT(pip.startDate,'/',pip.StartTime))Admit FROM patient_attender_profile pip    WHERE pip.Status = 'IN' )p1 ON rm.RoomId = p1.Room_ID  "+
 "LEFT JOIN ( SELECT pip.RoomID AS Room_ID,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName FROM advance_room_booking pip "+
 "INNER JOIN patient_master pm ON pip.PatientID = pm.PatientID  WHERE pip.IsCancel =0 AND BookingDate=CURDATE() )ar ON rm.RoomId = ar.Room_ID  "+
 "LEFT JOIN (SELECT i.RoomID AS Room_ID FROM patient_ipd_profile i WHERE i.Status='OUT' AND i.EndDate=CURDATE())dis ON rm.RoomId = dis.Room_ID   "+
 "LEFT JOIN (SELECT ICH.`TransactionID`,pip.`RoomID` AS Room_ID FROM patient_medical_history ich INNER JOIN patient_ipd_profile pip ON "+
  "pip.`TransactionID`=ich.`TransactionID` WHERE DateOfAdmit=CURDATE() GROUP BY ich.`TransactionID`)na ON na.Room_ID=rm.RoomID  INNER JOIN "+
  "floor_master fm ON fm.Name=rm.Floor WHERE rm.IsActive=1 AND ict.IsActive=1  AND rm.CentreID=" + Session["CentreID"].ToString() + "  HAVING STATUS='3'  " +
 " ORDER BY fm.sequenceNo+0,rm.Room_No,rm.Floor,ict.name,rm.name,rm.Bed_No ");
            DataTable dt1 = StockReports.GetDataTable(sbRT.ToString());

            foreach (DataRow row in dt1.Rows)
            {

                if (row["IsDoctorNoteBlink1"].ToString() == "1")
                {
                    row["ClassDoctorNoteBlink"] = "blinking";
                }
                else
                {
                    row["ClassDoctorNoteBlink"] = "";

                }
                if (row["IsNursingNoteBlink1"].ToString() == "1")
                {
                    row["ClassNursingNoteBlink"] = "blinking";
                }
                else
                {
                    row["ClassNursingNoteBlink"] = "";

                }
                if (row["IsLabsBlink"].ToString() == "1")
                {
                    row["ClassLabsBlink"] = "blinking";
                }
                else
                {
                    row["ClassLabsBlink"] = "";

                }
                if (row["IsReportsBlink"].ToString() == "1")
                {
                    row["ClassReportsBlink"] = "blinking";
                }
                else
                {
                    row["ClassReportsBlink"] = "";

                }
                if (row["IsMedBlink"].ToString() == "1")
                {
                    row["ClassMedBlink"] = "blinking";
                }
                else
                {
                    row["ClassMedBlink"] = "";

                }
                if (row["IsVitalsBlink1"].ToString() == "1")
                {
                    row["ClassVitalsBlink"] = "blinking";
                }
                else
                {
                    row["ClassVitalsBlink"] = "";

                }
                if (row["IsIOBlink"].ToString() == "1")
                {
                    row["ClassIOBlink"] = "blinking";
                }
                else
                {
                    row["ClassIOBlink"] = "";

                }
                if (row["IsFlowSheetsBlink"].ToString() == "1")
                {
                    row["ClassFlowSheetsBlink"] = "blinking";
                }
                else
                {
                    row["ClassFlowSheetsBlink"] = "";

                }

            }
            ViewState["dtRoomType1"] = dt1;
           // rpFloor1.DataSource = dt.DefaultView.ToTable(true, new string[] { "Location" });
            rpFloor1.DataSource = dt.DefaultView;
            rpFloor1.DataBind();
            lblMsg.Text = string.Empty;
        }
        else
        {
            rpFloor1.DataSource = null;
            rpFloor1.DataBind();
            lblMsg.Text = "No Record Found...";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "key1", "modelAlert('Rooms are not available as per searching');", true);
            return;
        }
    }
    protected void rpBD1_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            StringBuilder sbfc = new StringBuilder();

            //New for room type request
            sbfc.Append(" SELECT * FROM doctor_master");

            DataTable dtfirstcalldocs = StockReports.GetDataTable(sbfc.ToString());

            DropDownList firstcall = (DropDownList)e.Item.FindControl("ddlFirstCall");
            firstcall.DataSource = dtfirstcalldocs;
            firstcall.DataBind();
            Label lblfc = (Label)e.Item.FindControl("lblFirstCall");
            firstcall.SelectedValue = (lblfc.Text);
            //firstcall.SelectedIndexChanged += ddlFirstCall_SelectedIndexChanged;

            //DataList dlRoom = (DataList)e.Item.FindControl("dlRoom");
            //DataTable dtRoomDetail = GetRooms(((Label)e.Item.FindControl("lblRoomType")).Text);
            //if (dtRoomDetail != null)
            //{
            //    dlRoom.DataSource = dtRoomDetail;
            //    dlRoom.DataBind();
            //}
            //else
            //{
            //    e.Item.Visible = false;
            //}
            //Repeater rpSC = (Repeater)e.Item.FindControl("rpShortCuts");
            //rpSC.DataSource = GetShortCuts();
            //rpSC.DataBind();

        }

    }
    protected void ddlFirstCall_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList d = (DropDownList)sender;
        d.SelectedIndex = 1;
        //(RepeaterItem) d.Parent
    }
    protected virtual void RepeaterItemCreated(object sender, RepeaterItemEventArgs e)
    {
        DropDownList MyList = (DropDownList)e.Item.FindControl("ddlFirstCall");
        MyList.SelectedIndexChanged += ddlFirstCall_SelectedIndexChanged;
    }
    private DataTable GetShortCuts()
    {
        StringBuilder sbfc = new StringBuilder();
        //get patient PID,TID
        string PID = "180474";
        string TID = "5";
        string ID = Session["ID"].ToString();
        //New for room type request
        sbfc.Append(" select *,concat(Target,'?PatientId=" + PID + "&amp;TransactionId=" + TID + "' ) as Target1 from tblShorCuts");

        DataTable dtShortcuts = StockReports.GetDataTable(sbfc.ToString());

        return dtShortcuts;


    }
    
   
}

