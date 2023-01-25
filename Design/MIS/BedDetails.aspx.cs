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

public partial class Design_MIS_BedDetails : System.Web.UI.Page
{
    #region Event Handling
    int TRoom = 0;
    int ORoom = 0;
    int ARoom = 0;    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindFloor();
            BindBedStatus();
            GetRequestedRoomType();
            GetTotalDischargeRoom();
            GetAtttenderRoom();
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
    protected void rpBD_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DataList dlRoom = (DataList)e.Item.FindControl("dlRoom");
            dlRoom.DataSource = GetRooms(((Label)e.Item.FindControl("lblRoomType")).Text);
            dlRoom.DataBind();
        }
        if (e.Item.ItemType == ListItemType.Footer)
        {
            Repeater rpBD = (Repeater)sender;
            TRoom += Util.GetInt(((DataTable)rpBD.DataSource).Compute("sum(TRoom)", ""));
            ORoom += Util.GetInt(((DataTable)rpBD.DataSource).Compute("sum(ORoom)", ""));
            ARoom += Util.GetInt(((DataTable)rpBD.DataSource).Compute("sum(ARoom)", ""));            
            ((Label)e.Item.FindControl("lblTotal")).Text = "Total Bed &nbsp;:&nbsp; " + Util.GetString(((DataTable)rpBD.DataSource).Compute("sum(TRoom)", "")) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total Occupied &nbsp;:&nbsp; " + Util.GetString(((DataTable)rpBD.DataSource).Compute("sum(ORoom)", "") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total Available &nbsp;:&nbsp; " + Util.GetString(((DataTable)rpBD.DataSource).Compute("sum(ARoom)", "")));

        }
        lblTRoom.Text = TRoom.ToString();
        lblORoom.Text = ORoom.ToString();
        lblARoom.Text = ARoom.ToString();       
    }
    #endregion

    #region Data Binding
    private void BindBedStatus()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Ifnull(p.transactionid,'')transactionid,IFNULL(p.BillNo,'')BillNo,IFNULL(p.PatientID,'')PatientID,IFNULL(p.Gender,'')Gender,IFNULL(p.Panelid,'')Panelid,IFNULL(p.doctorID,'')doctorID,ict.IPDCaseTypeID AS IPDCaseType_ID,ict.Name,CONCAT(rm.Room_No,'-',rm.Bed_No) RoomName,rm.Floor,  ");
        sb.Append(" CASE WHEN IFNULL(p.room_id,'')<>'' THEN 1  WHEN IFNULL(p1.room_id,'')<>'' THEN 1 ELSE 0 END RStat ,");
        sb.Append(" CASE WHEN IFNULL(p.room_id,'')<>'' THEN 'hand' WHEN IFNULL(p1.room_id,'')<>'' THEN 'hand' WHEN SPLIT_STR(IFNULL(D.Discharge,''),'/',1)=DATE(NOW()) THEN 'hand' ELSE 'none' END STATUS, ");
        // sb.Append(" CASE WHEN IFNULL(p.room_id,'')<>'' THEN '#F9966B' WHEN IFNULL(p1.room_id,'')<>'' THEN '#C0C0C0' WHEN SPLIT_STR(IFNULL(D.Discharge,''),'/',1)=DATE(NOW()) THEN  '#FFFF00' ELSE '#6AFB92' END StCol, ");
        sb.Append(" CASE WHEN IFNULL(p1.room_id,'')<>'' THEN '#C0C0C0' WHEN SPLIT_STR(IFNULL(D.Discharge,''),'/',1)=DATE(NOW()) THEN  '#FFFF00' WHEN IFNULL(p.room_id,'')<>'' THEN (SELECT IF(IsDischargeIntimate=0,'#F9966B','#FFA500') FROM patient_medical_history pmh WHERE pmh.TransactionID=p.transactionid) ELSE '#6AFB92' END StCol,");
        sb.Append(" CASE WHEN  IFNULL(p.room_id,'')<>'' THEN CONCAT('Name : ',p.PatientName,'&#13;UHID : ',p.PatientID ,CAST('&#13;IPD.No. : 'AS CHAR),");
        sb.Append(" REPLACE(p.TransactionID,'ISHHI',''),CAST('&#13;Admit Date/Time : ' AS CHAR),p.Admit,CAST('&#13;Doctor : 'AS CHAR),p.dName) ");
        sb.Append(" WHEN IFNULL(p1.room_id,'')<>'' THEN CONCAT('Attendant Name : ',p1.Name,CAST('&#13;IPD.No. : 'AS CHAR),");
        sb.Append(" REPLACE(p1.TransactionID,'ISHHI',''),CAST('&#13;Admit Date/Time : ' AS CHAR),p1.Admit) ");
        sb.Append(" WHEN SPLIT_STR(IFNULL(D.Discharge,''),'/',1)=DATE(NOW()) THEN  CONCAT('Discharge Date/Time : ',Date_Format(D.Discharge,'%d-%b-%y %l:%m %p')) ");
        sb.Append(" ELSE  '' END PDetails ");
        sb.Append(" FROM room_master rm inner join ipd_case_type_master ict ON rm.IPDCaseTypeID = ict.IPDCaseTypeID left join (select IFNULL(ich.BillNo,'')BillNo,pm.Gender,ich.Panelid,ich.doctorID,pip.TransactionID,pip.RoomID AS Room_ID,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName,(CONCAT(ich.DateOfAdmit,'/',ich.TimeOfAdmit))Admit,CONCAT(dm.Title,' ',dm.Name)dName");
        sb.Append(" FROM patient_ipd_profile pip inner join patient_master pm on pip.PatientID = pm.PatientID inner join patient_medical_history ich on pip.TransactionID = ich.TransactionID inner join doctor_master dm on dm.DoctorID = ich.DoctorID where pip.Status = 'IN' )p on rm.RoomId = p.Room_ID ");//ipd_case_history
        sb.Append("  LEFT JOIN (SELECT pip.TransactionID,pip.RoomID AS Room_ID,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName,  ");
        sb.Append("  (CONCAT(ich.DateofDischarge,'/',ich.TimeOfDischarge))Discharge,  ");
        sb.Append("  CONCAT(dm.Title,' ',dm.Name)dName   ");
        sb.Append("  FROM patient_ipd_profile pip   ");
        sb.Append("  INNER JOIN patient_master pm ON pip.PatientID = pm.PatientID   ");
        sb.Append("  INNER JOIN patient_medical_history ich ON pip.TransactionID = ich.TransactionID   ");//ipd_case_history
        sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID = ich.DoctorID   ");
        sb.Append("  WHERE pip.Status = 'OUT' AND ich.DateofDischarge<>'0001-01-01' ORDER BY DateofDischarge DESC LIMIT 1)D ON rm.RoomId = D.Room_ID  ");
        sb.Append(" LEFT JOIN ");
        sb.Append("   ( SELECT pip.Name, pip.RoomID AS Room_ID,pip.TransactionID,(CONCAT(pip.startDate,'/',pip.StartTime))Admit FROM patient_attender_profile pip ");
        sb.Append("   WHERE pip.Status = 'IN' )p1 ON rm.RoomId = p1.Room_ID");
        sb.Append(" ");   
        sb.Append(" INNER JOIN floor_master fm ON fm.Name=rm.Floor WHERE rm.IsActive=1 and ict.IsActive=1 ");
        //sb.Append(" order by fm.SequenceNo,rm.Floor,ict.name,rm.name,rm.Bed_No ");
        if (ddlFloor.SelectedItem.Text != "ALL")
            sb.Append("  AND rm.Floor ='" + ddlFloor.SelectedItem.Text + "'");
        sb.Append(" AND fm.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "  AND rm.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
        sb.Append(" order by fm.sequenceNo+0,rm.Room_No,rm.Floor,ict.name,rm.name,rm.Bed_No+0 ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        DataColumn dc = new DataColumn("LoginType");
        if (dt.Rows.Count > 0)
        {
            
            dc.DefaultValue = HttpContext.Current.Session["RoleID"].ToString();
            dt.Columns.Add(dc);

            ViewState["dtRoom"] = dt;
            StringBuilder sbRT = new StringBuilder();
            //sbRT.Append(" select IPDCaseType_ID,Name,Floor,ORoom,TRoom,ARoom,Round((ARoom*100)/TRoom,2)APer,Round((ORoom*100)/TRoom,2)OPer from (select ict.IPDCaseType_ID,ict.Name,rm.Floor,count(rm.Name) TRoom,count(rm.Name)- count(p.Room_ID) ARoom,count(p.Room_ID)ORoom");
            //sbRT.Append(" from room_master rm inner join ipd_case_type_master ict on rm.IPDCaseTypeID = ict.IPDCaseType_ID  AND rm.IsActive=1 and ict.IsActive=1 left join (select Room_ID from p");
            //sbRT.Append(" on rm.Room_Id = p.Room_ID group by rm.Floor,rm.IPDCaseTypeID )t1 order by Name desc");patient_ipd_profile where Status = 'IN' )

            //New for room type request
            sbRT.Append(" select t1.IPDCaseType_ID,Name,Floor,ORoom,TRoom,ARoom,Round((ARoom*100)/TRoom,2)APer,Round((ORoom*100)/TRoom,2)OPer, ");
            sbRT.Append(" IFNULL(t2.TotalRequest,0)RRoom,IF(t2.TotalRequest IS NULL,'none','hand')STATUS,IF(t2.TotalRequest='0','','#FFC0CB')StCol,IF(t2.TotalRequest='0','',CONCAT('Total Request : ',t2.TotalRequest,'&#13;IPD No. : ',t2.IPDNo))BedRequests ");
            sbRT.Append(" from (select ict.IPDCaseTypeID AS IPDCaseType_ID,ict.Name,rm.Floor,count(rm.Name) TRoom,count(rm.Name)- (COUNT(p.Room_ID)+COUNT(A.Room_ID)) ARoom,(COUNT(p.Room_ID)+COUNT(A.Room_ID))ORoom   ");
            sbRT.Append(" from room_master rm inner join ipd_case_type_master ict on rm.IPDCaseTypeID = ict.IPDCaseTypeID  AND rm.IsActive=1 and ict.IsActive=1 left join (select RoomID AS Room_ID from patient_ipd_profile where Status = 'IN' )p");
            sbRT.Append(" on rm.RoomId = p.Room_ID LEFT JOIN (SELECT RoomID AS Room_ID FROM patient_attender_profile WHERE STATUS = 'IN' )A ON rm.RoomId = A.Room_ID GROUP BY rm.Floor,rm.IPDCaseTypeID )t1 ");
            sbRT.Append(" INNER JOIN (SELECT ictm.IPDCaseTypeID AS IPDCaseType_ID,(IFNULL(t.TotalRequest,0))TotalRequest,t.IPDNo FROM ipd_case_type_master ictm LEFT JOIN (SELECT RequestedRoomType AS IPDCaseType_ID,COUNT(*)TotalRequest,GROUP_CONCAT(REPLACE(ich.TransactionID,'ISHHI',''))IPDNo ");
            sbRT.Append(" FROM patient_medical_history ich WHERE ich.Status='IN' AND ich.IsRoomRequest=1  AND ich.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " GROUP BY RequestedRoomType)t ON ictm.IPDCaseTypeID=t.IPDCaseType_ID ");//ipd_case_history

            //sbRT.Append("  LEFT JOIN  ( SELECT pap.IPDCaseType_ID,COUNT(*)TotalRequest,GROUP_CONCAT(REPLACE(pap.TransactionID,'ISHHI',''))IPDNo ");
            //sbRT.Append("  FROM patient_attender_profile pap WHERE pap.Status='IN'  GROUP BY ID )t3 ON ictm.IPDCaseType_ID=t3.IPDCaseType_ID ");
            //sbRT.Append(" ");

            sbRT.Append("  )t2 ON t1.IPDCaseType_ID=t2.IPDCaseType_ID ");
            sbRT.Append(" order by Name desc ");

            DataTable dt1 = StockReports.GetDataTable(sbRT.ToString());
            ViewState["dtRoomType"] = dt1;

            rpFloor.DataSource = dt.DefaultView.ToTable(true, new string[] { "Floor" });
            rpFloor.DataBind();
            lblMsg.Text = string.Empty;
        }
        else
        {
            rpFloor.DataSource = null;
            rpFloor.DataBind();
            lblMsg.Text = "No Record Found...";
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
    private void GetRequestedRoomType()
    {
        string query = " SELECT COUNT(*)TotalRequest FROM patient_medical_history  WHERE STATUS='IN' AND IsRoomRequest=1 AND CentreID=" + Session["CentreID"].ToString() + " "; //ipd_case_history

        int  totalRequest = Util.GetInt(StockReports.ExecuteScalar(query));

        if (totalRequest > 0)
        {
            lblRRoom.Text = totalRequest.ToString();
        }
    }
    private void GetTotalDischargeRoom()
    {
        string query = " SELECT COUNT(*)TotalRequest FROM patient_medical_history WHERE STATUS='OUT' AND Date(DateofDischarge)=Date(Now()) AND CentreID=" + Session["CentreID"].ToString() + "  ";//ipd_case_history

        int totalDischargeRoom = Util.GetInt(StockReports.ExecuteScalar(query));

        if (totalDischargeRoom > 0)
        {
            lblTotalDischarge.Text = totalDischargeRoom.ToString();
        }
    }
    private void GetAtttenderRoom()
    {
        string query = " SELECT COUNT(*)TotalRequest FROM patient_attender_profile WHERE STATUS='IN' AND CentreID=" + Session["CentreID"].ToString() + "  ";

        int totalAttenderRoom = Util.GetInt(StockReports.ExecuteScalar(query));

        if (totalAttenderRoom > 0)
        {
            lblAttenderRoom.Text = totalAttenderRoom.ToString();
        }
    }
    #endregion

    protected void ddlFloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindBedStatus();
    }
    private void BindFloor()
    {
        ddlFloor.DataSource = All_LoadData.LoadFloor();
        ddlFloor.DataValueField = "NAME";
        ddlFloor.DataTextField = "NAME";
        ddlFloor.DataBind();
        ddlFloor.Items.Insert(0, new ListItem("ALL"));
    }
}
