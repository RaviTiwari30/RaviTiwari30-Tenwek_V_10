using System;
using System.Web.Services;
using System.Data;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
using System.Web.Script.Services;
using System.Collections.Generic;
using System.Web.UI.HtmlControls;
using System.Drawing;
using MW6BarcodeASPNet;
using System.IO;

public partial class Design_Store_PatientIndent : System.Web.UI.Page
{
    private static Bitmap objBitmap;
    private static Bitmap objBitmap1;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null)
            {
                spnTransactionID.InnerText = Request.QueryString["TransactionID"].ToString();
                spnPatientID.InnerText = Request.QueryString["PatientID"].ToString();
                DataTable dt = AllLoadData_IPD.LoadIPDPatientDetail(spnPatientID.InnerText, spnTransactionID.InnerText);
                if (dt.Rows.Count > 0)
                {
                    spnPanelID.InnerText = dt.Rows[0]["PanelID"].ToString();
                    spnIPD_CaseTypeID.InnerText = dt.Rows[0]["IPDCaseTypeID"].ToString();
                    spnRoomID.InnerText = dt.Rows[0]["RoomID"].ToString();
                    BindStoreDepartment();
                }
                AllQuery AQ = new AllQuery();
                DataTable dtDischarge = AQ.GetPatientDischargeStatus(spnTransactionID.InnerText);
                if (dtDischarge != null && dtDischarge.Rows.Count > 0 && dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                {
                    string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No Services possible...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            var roleID = Util.GetInt(Session["RoleID"]);
            var employeeID = Util.GetString(HttpContext.Current.Session["ID"]);

            var canIndentMedicalItems = All_LoadData.GetAuthorization(roleID, employeeID, "CanIndentMedicalItems");
            var canIndentMedicalConsumables = All_LoadData.GetAuthorization(roleID, employeeID, "CanIndentMedicalConsumables");

            spnCanIndentMedicalItems.InnerText = canIndentMedicalItems;
            spnCanIndentMedicalConsumables.InnerText = canIndentMedicalConsumables;

        }

        txtSelectDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        CalendarExtender1.StartDate = DateTime.Now;



        
        txtSelectDate.Attributes.Add("readonly", "true"); 


        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = "[]";

        if (cmd == "item")
        {
            rtrn = makejsonoftable(BindItem(), makejson.e_with_square_brackets);
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();
            return;
        }
    }
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    public string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("\"{0}\":\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));
            }
            sb.Append(sb2.ToString());
            sb.Append("}");
        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }

    protected void BindStoreDepartment()
    {
        // DataTable dt = AllLoadData_Store.dtStoreIndentDepartments(Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), 0);
        //DataView dv = dt.DefaultView;
        string CentreID = Session["CentreID"].ToString();
        //string ledgerNumber = StockReports.ExecuteScalar("SELECT DISTINCT GROUP_CONCAT(CONCAT('''',rm.DeptLedgerNo,'''')) FROM f_rolemaster rm INNER JOIN f_centre_role cr ON cr.RoleID=rm.id WHERE cr.CentreID IN (" + CentreID + ") AND cr.isActive=1");
        //dv.RowFilter = "ledgerNumber in (" + ledgerNumber + ") ";
        //dt = dv.ToTable();



        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT lm.`LedgerName`,lm.`LedgerNumber`FROM f_rolemaster rm INNER JOIN f_ledgermaster lm ON lm.`LedgerNumber`=rm.`DeptLedgerNo`INNER JOIN f_centre_role cr ON cr.RoleID=rm.id WHERE cr.CentreID IN (" + CentreID + ") AND rm.`IsStore`=1 AND cr.isActive=1 AND cr.IsPatientIndent=1 ");
        if (Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()) == 11)
            sb.Append(" and rm.IsMedical=1 ");
        else
            sb.Append(" and rm.IsGeneral=1 ");

        sb.Append(" order by LedgerName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataSource = dt;
        ddlDepartment.DataTextField = "ledgerName";
        ddlDepartment.DataValueField = "ledgerNumber";
        ddlDepartment.DataBind();
      ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
        //ddlDepartment.Enabled = false;
    }
    [WebMethod]
    public static string BindRequisitionType()
    {
        DataTable dt = AllLoadData_Store.dtTypeMaster();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string BindMedicineQuantity(string Type)
    {
        DataTable dtData = LoadCacheQuery.LoadMedicineQuantity(Type);
        if (dtData.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
        else
            return "";
    }
    [WebMethod]
    public static string GetMedicineStock(string MedicineID, string DeptLedgerNo)
    {
        string DeptNo = "'LSHHI17','LSHHI57','LSHHI3886','" + DeptLedgerNo + "'";
        DataTable dt = StockReports.GetDataTable(" SELECT rm.RoleName DeptName,SUM(st.InitialCount-st.ReleasedCount)Quantity FROM f_stock st INNER JOIN f_rolemaster rm ON rm.DeptLedgerNo=st.DeptLedgerNo  WHERE st.ItemID='" + MedicineID + "'  AND st.DeptLedgerNo IN (" + DeptNo + ") AND st.IsPost=1 AND MedExpirydate>=CURRENT_DATE GROUP BY rm.DeptLedgerNo ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string LoadIndentMedicine(string TnxID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,IndentNo,DATE_FORMAT(dtEntry,'%d-%b-%y %h:%i %p')dtEntry FROM f_indent_detail_patient WHERE TransactionID='" + TnxID + "' GROUP BY dtentry ORDER BY dtentry ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Load Indent")]
    public static string LoadIndentItems(string IndentNo)
    {
        DataTable dt = StockReports.GetDataTable("SELECT osm.entryid ID,osm.reqqty quantity,im.typename NAME,im.ItemID,osm.indentno,osm.dose,osm.timing Times,DATE_FORMAT(osm.duration,'%d-%b-%y')duration,osm.Route,osm.Meal,im.unittype,im.MedicineType FROM orderset_medication  osm INNER JOIN f_itemmaster im ON im.ItemID=osm.medicineid INNER JOIN f_indent_detail_patient idp ON idp.`IndentNo`=osm.`IndentNo`WHERE idp.`id`='" + IndentNo + "' ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string BindSubcategory()
    {
        DataView dv = LoadCacheQuery.loadSubCategory().DefaultView;
        dv.RowFilter = "ConfigID = '11' ";
        if (dv.ToTable().Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dv.ToTable());
        else
            return "";
    }

    public DataTable BindItem()
    {
        string itemName = Util.GetString(Request.QueryString["q"]);
        string Type = Util.GetString(Request.QueryString["Type"]);
        string PanelID = Util.GetString(Request.QueryString["PanelID"]);
        string DeptLedgerNo = Util.GetString(Request.QueryString["DeptLegerNo"]);
        string SubcategoryID = Util.GetString(Request.QueryString["SubcategoryID"]);
        string canIndentMedicalItems = Util.GetString(Request.QueryString["canIndentMedicalItems"]);
        string canIndentMedicalConsumables = Util.GetString(Request.QueryString["canIndentMedicalConsumables"]);

        DataTable dt = new DataTable();
        if (itemName.Length < 1)
            return dt;

        //if (canIndentMedicalConsumables == "0" && canIndentMedicalItems == "0")
        //    return dt;

        StringBuilder sb = new StringBuilder();
        if (Type == "0")
        {
            sb.Append("SELECT IM.Typename AS ItemName,im.HSNCode,IFNULL(st.Qty,'0') AS AvlQty,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(st.Qty,''),'#',IFNULL(IM.UnitType,''),'#',IF(pay.ItemID IS NULL,'0','1'),'#',im.Dose,'#',im.MedicineType,'#',im.Route,'#','0','#',cr.CategoryID)ItemID");
            sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_itemmaster_centerwise itc ON itc.`ItemID`=im.`ItemID` ");
            sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID ");
            sb.Append(" INNER JOIN (SELECT IF(sum(InitialCount-ReleasedCount)>0,sum(InitialCount-ReleasedCount),0) ");
            sb.Append(" Qty,ItemID FROM f_stock WHERE isPost=1 AND (InitialCount-ReleasedCount)>0 ");
            if (DeptLedgerNo != "0")
                sb.Append(" AND DeptLedgerNo='" + DeptLedgerNo + "' AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
            sb.Append("  GROUP BY ITemID)st ON st.itemID = im.ItemID ");
            sb.Append(" LEFT JOIN f_panel_item_payable pay ON Pay.ItemID=im.ItemID AND Pay.PanelID='" + PanelID + "' AND  pay.IsActive=1 WHERE CR.ConfigID = 11 AND im.IsActive=1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + Session["CentreID"].ToString() + "' ");
            if (SubcategoryID != "0")
                sb.Append(" and SM.SubCategoryID='" + SubcategoryID + "'");

            if (canIndentMedicalConsumables == "1" && canIndentMedicalItems == "0")
                sb.Append(" and cr.CategoryID='LSHHI38' ");

            if (canIndentMedicalItems == "1" && canIndentMedicalConsumables == "0")
                sb.Append(" and cr.CategoryID='LSHHI5' ");

            sb.Append(" AND sm.`CategoryID`='38' AND im.Typename like '" + itemName + "%'"); //Only CategoryID 38 Medicine Search(Medicine Consumables)
            sb.Append(" order by IM.Typename LIMIT " + Util.GetString(Request.QueryString["rows"]) + "");
        }
        else if (Type == "1")
        {
            sb.Append(" select im.HSNCode,IFNULL(st.Qty,'0') AS AvlQty,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(st.Qty,'0'),'#',IFNULL(IM.UnitType,''),'#',IF(pay.ItemID IS NULL,'0','1'),'#',im.Dose,'#',im.MedicineType,'#',im.Route,'#','0','#',cr.CategoryID)ItemID,im.typename AS ItemName from f_itemmaster im ");
            sb.Append(" INNER join f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID INNER JOIN f_itemmaster_centerwise itc ON itc.`ItemID`=im.`ItemID` ");
            sb.Append(" INNER JOIN (SELECT IF(sum(InitialCount-ReleasedCount)>0,sum(InitialCount-ReleasedCount),0) ");
            sb.Append(" Qty,ItemID FROM f_stock WHERE isPost=1 AND (InitialCount-ReleasedCount)>0 ");
            sb.Append(" AND DeptLedgerNo='" + DeptLedgerNo + "' AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' GROUP BY ITemID)st ON st.itemID = im.ItemID ");
            sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=im.ItemID LEFT JOIN f_salt_master fsm ON fis.saltID = fsm.SaltID ");
            sb.Append(" LEFT JOIN f_panel_item_payable pay ON Pay.ItemID=im.ItemID AND Pay.PanelID='" + PanelID + "' AND  pay.IsActive=1 WHERE fsm.IsActive=1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + Session["CentreID"].ToString() + "' ");
            if (SubcategoryID != "0")
                sb.Append(" and sm.SubCategoryID='" + SubcategoryID + "'");

            if (canIndentMedicalConsumables == "1" && canIndentMedicalItems == "0")
                sb.Append(" cr.CategoryID='LSHHI38' ");

            if (canIndentMedicalItems == "1" && canIndentMedicalConsumables == "0")
                sb.Append(" cr.CategoryID='LSHHI5' ");

            sb.Append(" AND fsm.Name like '" + itemName + "%'");
            sb.Append(" order by im.Typename LIMIT " + Util.GetString(Request.QueryString["rows"]) + "");
        }
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
    [WebMethod]
    public static string BindRoute()
    {
        string[] Route = AllGlobalFunction.Route;
        return Newtonsoft.Json.JsonConvert.SerializeObject(Route);
    }
    [WebMethod(EnableSession = true, Description = "Save Indent")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveIndent(List<insert> Data, int isDischargeMedicine)
    {
        string IndentNo = "";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string EntryID = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select ifnull(Max(EntryID),0)+1 ID from orderset_medication"));
            IndentNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select get_indent_no_patient('" + Data[0].Dept + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')").ToString();
            if (IndentNo != "")
            {
                int count = Util.GetInt(0);
                string ItemID = "";
                string OtherIndentNo = "";
                string DurationDate = "";
                for (int i = 0; i < Data.Count; i++)
                {

                    StringBuilder sb = new StringBuilder();
                    DurationDate = Data[i].Duration;

                    sb.Append("insert into f_indent_detail_patient(IndentNo,ItemId,ItemName,ReqQty,UnitType,DeptFrom,DeptTo,StoreId,UserId,TransactionID,IndentType,CentreID,Hospital_Id,PatientID,DoctorID,IPDCaseTypeID,RoomID,isDischargeMedicine)  ");
                    sb.Append("values('" + IndentNo + "','" + Data[i].ItemID + "','" + Data[i].MedicineName + "'," + Util.GetFloat(Data[i].Quantity) + "");
                    sb.Append(",'" + Data[i].UnitType + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + Data[i].Dept + "','STO00001', ");
                    sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + Data[i].TID + "','" + Data[i].IndentType + "','" + HttpContext.Current.Session["CentreID"].ToString() + "', ");
                    sb.Append("'" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + Data[i].PID + "','" + Data[i].DoctorID + "','" + Data[i].IPDCaseTypeID + "','" + Data[i].Room_ID + "'," + isDischargeMedicine + ") ");
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        return "0" + "#" + "0"; 
                    }
                    count = 1;
                    ItemID = Data[i].ItemID;
                    OtherIndentNo = IndentNo;
                    sb.Clear();
                    DateTime DateDuration = Util.GetDateTime(System.DateTime.Now.AddDays(Util.GetDouble(Data[i].DurationValue)).ToString("yyyy-MM-dd"));
                    sb.Append(" Insert into orderset_medication(EntryID,TransactionID,PatientID,MedicineID,MedicineName,ReqQty,Dose,Timing,Duration,EntryBy,IndentNo,Route,Meal)values(");
                    sb.Append(" " + Util.GetInt(EntryID) + ",'" + Data[i].TID + "','" + Data[i].PID + "','" + ItemID + "','" + Data[i].MedicineName + "','" + Util.GetFloat(Data[i].Quantity) + "', ");
                    sb.Append(" '" + Data[i].Dose + "','" + Data[i].Time + "','" + DateDuration.ToString("yyyy-MM-dd") + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + OtherIndentNo + "','" + Data[i].Route + "','" + Util.GetString(Data[i].Meal) + "')");
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0" + "#" + "0"; 
                    }
                }
                int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + Data[0].Dept + "'"));
                string notification = Notification_Insert.notificationInsert(28, IndentNo, Tranx, "", "", roleID);
                if (notification == "")
                {
                    Tranx.Rollback();
                    return "" + "#" + ""; ;
                }
                Tranx.Commit();
                return "1"+"#"+IndentNo;
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

        return "0";
    }
    
    
    
    public class insert
    {
        public string ItemID { get; set; }
        public string Dose { get; set; }
        public string Time { get; set; }
        public string Duration { get; set; }
        public string DurationValue { get; set; }
        public string Route { get; set; }
        public string Meal { get; set; }
        public string TID { get; set; }
        public string PID { get; set; }
        public string Doc { get; set; }
        public string LnxNo { get; set; }
        public string MedicineName { get; set; }
        public string Dept { get; set; }
        public string Quantity { get; set; }
        public string UnitType { get; set; }
        public string IndentType { get; set; }
        public string DoctorID { get; set; }
        public string IPDCaseTypeID { get; set; }
        public string Room_ID { get; set; }
    }
    [WebMethod(EnableSession = true, Description = "Print Indent")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string printIndent(string IndentNo, string TransactionId)
    {

        string Output = string.Empty;
        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" select cm.CentreName,id.IndentNo,(rd.DeptName)DeptFrom,(rd1.DeptName)DeptTo,id.ItemName,id.ItemID,id.ReqQty,id.ReceiveQty,id.RejectQty,id.UnitType,id.Narration,id.isApproved, ");
        sb1.Append(" id.ApprovedBy,id.ApprovedReason,id.dtEntry,id.UserId,Concat(em.Title,' ',em.Name)EmpName,CONCAT(pm.Title,' ',pm.PName)PatientName,Replace(pmh.TransactionID,'ISHHI','')TransactionID,id.IndentType,pmh.`TransNo` as Transaction_ID,'' FID from f_indent_detail_patient id inner  ");
        sb1.Append("join f_rolemaster rd on id.DeptFrom=rd.DeptLedgerNo inner join f_rolemaster rd1  ");
        sb1.Append("on id.DeptTo=rd1.DeptLedgerNo inner join employee_master em on id.UserId=em.EmployeeID ");
        sb1.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=id.TransactionID ");
        sb1.Append("  INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
        sb1.Append("  INNER JOIN center_master cm ON cm.CentreID=id.CentreID ");
        sb1.Append("  WHERE pmh.TransactionID = '" + TransactionId + "'  and id.indentno='" + IndentNo + "'");
        sb1.Append(" Union All ");
        sb1.Append(" SELECT '' CentreName, id.IndentNo,'' DeptFrom,'' DeptTo,id.MedicineName ItemName,id.MedicineID Itemid,id.ReqQty,'' ReceiveQty,'' RejectQty,'' UnitType,'' Narration,'' isApproved,'' ApprovedBy,'' ApprovedReason,id.EntryDate Date,'' UserId,CONCAT(em.Title,' ',em.Name)EmpName,CONCAT(pm.Title,' ',pm.PName)PatientName,REPLACE(pmh.TransactionID,'ISHHI','')TransactionID,'' IndentType,pmh.`TransNo` as Transaction_ID,'' as FID  ");
        sb1.Append(" FROM orderset_medication id ");
        sb1.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=id.TransactionID ");
        sb1.Append(" INNER JOIN patient_master pm ON pmh.patientid=pm.patientid ");
        sb1.Append(" INNER JOIN employee_master em ON em.employeeid=id.EntryBy ");
        sb1.Append("  WHERE pmh.TransactionID = '" + TransactionId + "'  and id.indentno='" + IndentNo + "' and id.indentno LIKE 'OTH%'  ");
        DataSet ds = new DataSet();
        ds.Tables.Add(StockReports.GetDataTable(sb1.ToString()).Copy());
        ds.Tables[0].TableName = "Table";

        DataTable dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        ds.Tables[1].TableName = "ClientImage";
        sb1 = new StringBuilder();
        sb1.Append(" SELECT '" + IndentNo + "' IndentNo,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PName,pm.Age,pm.Gender,pm.Mobile,  ");
        sb1.Append(" CONCAT(IF(pm.House_No<>'',CONCAT(pm.House_No,','),''),IF(pm.City<>'',CONCAT(pm.City,','),''),IF(pm.District<>'',CONCAT(pm.District,','),''),IF(pm.Country<>'',pm.Country,''))Address, ");
        sb1.Append(" fpm.Company_Name PanelName, pmh.DischargeType,CONCAT(pmh.KinRelation,'',pmh.KinName) RelationName,  ");
        sb1.Append(" IF(DATE_FORMAT(BillDate,'%d-%b-%Y')='01-Jan-0001','',DATE_FORMAT(BillDate,'%d-%b-%Y %h:%i %p')) ReceiptDateTime,  ");
        sb1.Append(" UPPER(CONCAT(rm.Name,IF(IFNULL(rm.Room_No,'')='','',CONCAT('-',rm.Room_No))))Room,  ");
        sb1.Append(" REPLACE(pmh.Transno,'ISHHI','')IPNo,Concat(CONCAT(dm.Title,' ',dm.Name),'/',dm.Specialization) DoctorName   ");
        sb1.Append(" FROM (   SELECT 'Admit' AS AdmitDischargeType,pipa.* FROM patient_ipd_profile pipa    ");
        sb1.Append(" WHERE PatientIPDProfile_ID=(SELECT MIN(PatientIPDProfile_ID)PatientIPDProfile_ID   ");
        sb1.Append(" FROM patient_ipd_profile WHERE transactionID='" + TransactionId + "')   )pip   ");
        sb1.Append(" INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID = pip.IPDCaseTypeID   ");
        sb1.Append(" INNER JOIN room_master rm ON rm.RoomId = pip.roomID    ");
        sb1.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=pip.TransactionID    ");
        sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID    ");
        sb1.Append("  INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID   ");
        sb1.Append("  INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID   ");
        sb1.Append("  INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
        DataTable dtPatientNew = new DataTable();
        dtPatientNew = StockReports.GetDataTable(sb1.ToString());
        if (dtPatientNew.Rows.Count > 0)
        {
            OutputImg(dtPatientNew.Rows[0]["PatientID"].ToString());
            dtPatientNew.Columns.Add("PatientIDBarCode", System.Type.GetType("System.Byte[]"));
            dtPatientNew.Rows[0]["PatientIDBarCode"] = GetBitmapBytes(objBitmap);
            OutputImg1(dtPatientNew.Rows[0]["IndentNo"].ToString());
            dtPatientNew.Columns.Add("IndentNoBarCode", System.Type.GetType("System.Byte[]"));
            dtPatientNew.Rows[0]["IndentNoBarCode"] = GetBitmapBytes(objBitmap1);
            dtPatientNew.AcceptChanges();
        }
        dtPatientNew = dtPatientNew.Copy();
        dtPatientNew.TableName = "PatientDetails";
        ds.Tables.Add(dtPatientNew);

        if (ds.Tables[0].Rows.Count > 0)
        {
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "PatientNewIndent";
            Output = "../../Design/common/Commonreport.aspx";
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "", message = "", Output = Output });


    }   
  
    private static void OutputImg(string PatientID)
    {
        string FontName = "";
        Graphics objGraphics;
        Point p;
        Barcode MyBarcode = new Barcode();
        MyBarcode.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFF");
        MyBarcode.BarColor = Color.Black;
        MyBarcode.CheckDigit = true;
        MyBarcode.CheckDigitToText = true;
        MyBarcode.Data = PatientID;
        MyBarcode.BarHeight = 1.0F;
        MyBarcode.NarrowBarWidth = 0.02F;
        MyBarcode.Orientation = MW6BarcodeASPNet.enumOrientation.or0;
        MyBarcode.SymbologyType = MW6BarcodeASPNet.enumSymbologyType.syCode128;
        MyBarcode.ShowText = false;
        MyBarcode.Wide2NarrowRatio = 0.5F;
        FontName = "Verdana, Arial, sans-serif";
        MyBarcode.TextFont = new Font(FontName, 8.0F);
        MyBarcode.SetSize(160, 30);
        objBitmap = new Bitmap(160, 30);
        objGraphics = Graphics.FromImage(objBitmap);
        p = new Point(0, 0);
        MyBarcode.Render(objGraphics, p);
        objGraphics.Flush();
    }
    private static void OutputImg1(string IndentNo)
    {
        string FontName = "";
        Graphics objGraphics;
        Point p;
        Barcode MyBarcode = new Barcode();
        MyBarcode.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFF");
        MyBarcode.BarColor = Color.Black;
        MyBarcode.CheckDigit = true;
        MyBarcode.CheckDigitToText = true;
        MyBarcode.Data = IndentNo;
        MyBarcode.BarHeight = 1.0F;
        MyBarcode.NarrowBarWidth = 0.02F;
        MyBarcode.Orientation = MW6BarcodeASPNet.enumOrientation.or0;
        MyBarcode.SymbologyType = MW6BarcodeASPNet.enumSymbologyType.syCode128;
        MyBarcode.ShowText = false;
        MyBarcode.Wide2NarrowRatio = 0.5F;
        FontName = "Verdana, Arial, sans-serif";
        MyBarcode.TextFont = new Font(FontName, 8.0F);
        MyBarcode.SetSize(160, 30);
        objBitmap1 = new Bitmap(160, 30);
        objGraphics = Graphics.FromImage(objBitmap1);
        p = new Point(0, 0);
        MyBarcode.Render(objGraphics, p);
        objGraphics.Flush();
    }
    private static byte[] GetBitmapBytes(Bitmap Bitmap1)    //  getting Stream of Bar Code image
    {
        MemoryStream memStream = new MemoryStream();
        byte[] bytes;
        try
        {
            Bitmap1.Save(memStream, System.Drawing.Imaging.ImageFormat.Jpeg);
            bytes = new byte[memStream.Length];
            memStream.Seek(0, SeekOrigin.Begin);
            memStream.Read(bytes, 0, bytes.Length);
            return bytes;
        }
        finally
        {
            memStream.Close();
            memStream.Dispose();
        }
    }
}