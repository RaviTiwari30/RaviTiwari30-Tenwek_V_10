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

public partial class Design_Store_Doctoer_Medicine_Order : System.Web.UI.Page
{
    string PID = "";
    string TID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null)
            {
                spnTransactionID.InnerText = Request.QueryString["TransactionID"].ToString();
                spnPatientID.InnerText = Request.QueryString["PatientID"].ToString();

                PID = Request.QueryString["PatientID"].ToString();
                TID = Request.QueryString["TransactionID"].ToString();
                DataTable dt = AllLoadData_IPD.LoadIPDPatientDetail(spnPatientID.InnerText, spnTransactionID.InnerText);
                if (dt != null && dt.Rows.Count > 0)
                {
                    spnPanelID.InnerText = dt.Rows[0]["PanelID"].ToString();
                    spnIPD_CaseTypeID.InnerText = dt.Rows[0]["IPDCaseTypeID"].ToString();
                    spnRoomID.InnerText = dt.Rows[0]["RoomID"].ToString();
                    BindStoreDepartment();
                }
                else
                { 
                    DataTable dtEMG = AllLoadData_IPD.LoadEMGPatientDetail(spnPatientID.InnerText, spnTransactionID.InnerText);
                    if (dtEMG != null && dtEMG.Rows.Count > 0)
                    {
                        spnPanelID.InnerText = dtEMG.Rows[0]["PanelID"].ToString();
                        spnIPD_CaseTypeID.InnerText = dtEMG.Rows[0]["IPDCaseTypeID"].ToString();
                        spnRoomID.InnerText = dtEMG.Rows[0]["RoomID"].ToString();
                        BindStoreDepartment();
                    }
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
            BindData();
            BindDiscontinuedData();
        }

        txtSelectDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        CalendarExtender1.StartDate = DateTime.Now;
        txtdateMissing.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        calMiss.EndDate = DateTime.Now;

        txtMStartDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        CalendarExtender2.StartDate = DateTime.Now;

        txtSelectDate.Attributes.Add("readonly", "true");
        txtdateMissing.Attributes.Add("readonly", "true");
        txtMStartDate.Attributes.Add("readonly", "true");


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
        // ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
//        ddlDepartment.Enabled = false;

        ddlDepartment.SelectedValue = "LSHHI39087";
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

            sb.Append(" AND im.Typename like '" + itemName + "%'");
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

    [WebMethod]
    public static string GetInterval()
    {
        string str = "SELECT   CONCAT(sd.Id,'#',IF(COUNT(sdt.DoseId)=0,1,COUNT(sdt.DoseId)))IdTimes,sd.Name	 FROM  tenwek_standard_dose sd LEFT JOIN tenwek_standard_dose_time sdt ON sd.Id=sdt.DoseId WHERE sd.IsActive=1 GROUP BY sd.Id";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetIntervalTimes(int Id)
    {
        string str = "SELECT TIME_FORMAT(sdt.Time,'%h:%i %p')TimeLable,sdt.Id FROM  tenwek_standard_dose_time sdt WHERE DoseId =" + Id + "";
        DataTable dt = StockReports.GetDataTable(str);
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


    [WebMethod(EnableSession = true, Description = "Save Indent")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveMedicneOrder(List<insert> Data)
    {
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            foreach (var item in Data)
            {
                string[] ScheduleTime = item.DoseTime.Split(',');

                if (!Util.GetBoolean(item.IsNow))
                {
                    item.FirstDose = ScheduleTime[0].ToString();
                        
                    item.IsNow = "0";
                }
                else
                {
                    item.IsNow = "1";
                }
                string FinalTime = ScheduleTime[ScheduleTime.Length-1].ToString();  //Util.GetString(StockReports.ExecuteScalar("SELECT  sdt.Time   FROM  tenwek_standard_dose_time sdt WHERE DoseId =" + Util.GetInt(item.IntervalId) + " ORDER BY  TIME(sdt.Time) Desc LIMIT 1"));
              
                item.FinalDoseTime = Util.GetDateTime(item.StartDate + " " + FinalTime).AddDays(Util.GetInt(item.DurationVal)).ToString("yyyy-MM-dd HH:mm:ss");

                StringBuilder sb = new StringBuilder();


                sb.Append(" INSERT INTO  tenwek_docotor_medicine_order ");
                sb.Append(" (ItemId,ItemName,PatientId,TransactionId,DepartmentId,StartDate,EndDate,IsNow, ");
                sb.Append("  FirstDose,Dose,DoseUnit,IntervalId,IntervalName,DurationName,DurationVal,Route,Qty,DoctorId, ");
                sb.Append("  DoctorName,Remark,IsDischargeMed,IsIndentDone,IndentNo,IsActive,EntryBy,FinalDoseTime,DoseTime,IsPrn,IsApproved,IsStudent) ");
                sb.Append(" VALUES (@ItemId,@ItemName,@PatientId,@TransactionId,@DepartmentId,@StartDate,@EndDate,@IsNow, ");
                sb.Append("  @FirstDose,@Dose,@DoseUnit,@IntervalId,@IntervalName,@DurtionName,@DurationVal,@Route,@Qty,@DoctorId, ");
                sb.Append("  @DoctorName,@Remark,@IsDischargeMed,@IsIndentDone,@IndentNo,@IsActive,@EntryBy,@FinalDoseTime,@DoseTime,@IsPrn,@IsApproved,@IsStudent)");

                int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {

                    ItemId = Util.GetString(item.ItemId),
                    ItemName = Util.GetString(item.ItemName),
                    PatientId = Util.GetString(item.PatientId),
                    TransactionId = Util.GetString(item.TransactionId),
                    DepartmentId = Util.GetString(item.DepartmentId),
                    StartDate = Util.GetDateTime(item.StartDate),
                    EndDate = Util.GetDateTime(item.StartDate).AddDays(Util.GetInt(item.DurationVal)),
                    IsNow = Util.GetInt(item.IsNow),
                    FirstDose = Util.GetDateTime(item.FirstDose),
                    Dose = Util.GetString(item.Dose),
                    DoseUnit = Util.GetString(item.DoseUnit),
                    IntervalId = Util.GetInt(item.IntervalId),
                    IntervalName = Util.GetString(item.IntervalName),
                    DurtionName = Util.GetString(item.DurationName),
                    DurationVal = Util.GetString(item.DurationVal),
                    Route = Util.GetString(item.Route),
                    Qty = Util.GetInt(item.Qty),
                    DoctorId = Util.GetString(item.DoctorId),
                    DoctorName = Util.GetString(item.DoctorName),
                    Remark = Util.GetString(item.Remark),
                    IsDischargeMed = Util.GetInt(item.IsDischargeMed),
                    IsIndentDone = 0,
                    IndentNo = "",
                    IsActive = 1,
                    EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                    FinalDoseTime = item.FinalDoseTime,
                    DoseTime = item.DoseTime,
                    IsPrn=Util.GetInt(item.IsPrn),
                    IsApproved = Util.GetInt(GetApprovalType(Util.GetString(HttpContext.Current.Session["ID"].ToString()))),
                    IsStudent = Util.GetInt(GetEmployeeType(Util.GetString(HttpContext.Current.Session["ID"].ToString()))),

                });

                int OrderId = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(ID) FROM tenwek_docotor_medicine_order"));
               
                foreach (string time in ScheduleTime)
                {
                    StringBuilder sbDoseTime = new StringBuilder();


                    sbDoseTime.Append(" INSERT INTO  tenwek_patient_dose_time ");
                    sbDoseTime.Append("  (PatientId,OrderId,TransactionId,DoseTime,DoseId,DoseName) ");
                    sbDoseTime.Append(" VALUES (@PatientId,@OrderId,@TransactionId,@DoseTime,@DoseId,@DoseName)");
                    int T = excuteCMD.DML(tnx, sbDoseTime.ToString(), CommandType.Text, new
                    {
                        PatientId=Util.GetString(item.PatientId),
                        OrderId = OrderId,
                        TransactionId = Util.GetString(item.TransactionId),
                        DoseTime=Util.GetDateTime(time),
                        DoseId = Util.GetInt(item.IntervalId),
                        DoseName = Util.GetString(item.IntervalName),
                         
                    });

                }


                CountSave += A;


            }

            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Order Genrated Successfully" });

            }
            else
            {
                tnx.Rollback();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            CountSave--;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    public void BindData()
    {


        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT  if(tdm.IsView=1, CONCAT('Acknowledge By ',tdm.ViewByName,' on ',DATE_FORMAT(tdm.ViewDateTime,'%d-%b-%Y %r')),'') Ackstring,tdm.Id,if(tdm.IsPrn=0,'NO','YES')PrnView,tdm.IsPrn,tdm.ItemId,tdm.ItemName,tdm.PatientId,tdm.TransactionId,tdm.DepartmentId, ");
        sb.Append(" DATE_FORMAT(tdm.StartDate,'%d-%b-%Y')StartDate,tdm.EndDate,tdm.IsNow,tdm.FirstDose,tdm.Dose,tdm.DoseUnit,tdm.DoseUnit,tdm.IntervalId, ");
        sb.Append(" tdm.IntervalName,tdm.DurationName,tdm.DurationVal,tdm.Route,tdm.Qty,tdm.DoctorId,tdm.DoctorName, ");
        sb.Append(" tdm.Remark,tdm.IsDischargeMed,tdm.IndentNo, ");
        sb.Append(" IF(tdm.IsIndentDone=1,IF(IFNULL(fid.ReceiveQty,0)>0,'Transfered To Ward','Indent Done'),'Pending Indent ')  IndentStatus, ");
        sb.Append(" tdm.IsIndentDone,DATE_FORMAT(tdm.FinalDoseTime,'%d-%b-%Y %h:%i %p')FinalDoseTime,DATE_FORMAT(CONCAT( tdm.StartDate,' ',tdm.FirstDose),'%d-%b-%Y %h:%i %p')StartDoseTime , ");
        sb.Append(" ROUND((24 /(SELECT IFNULL( COUNT(sdt.DoseId),1) FROM tenwek_standard_dose_time sdt WHERE sdt.DoseId= tdm.IntervalId)),0)Frequency , ");
        sb.Append(" CONCAT(tdm.Dose,' / ',tdm.Route)DoseRoute,CONCAT(tdm.Dose,' ',tdm.DoseUnit )Doses,CONCAT(em.Title,' ' ,em.NAME) AS OrderBy,tdm.IsActive,tdm.IsDisContinue, ");
        sb.Append(" IF( IFNULL( tdm.DoseTime,'')='',(SELECT GROUP_CONCAT(TIME_FORMAT( sdt.Time,'%h:%i')) FROM tenwek_standard_dose_time sdt WHERE sdt.DoseId= tdm.IntervalId),tdm.DoseTime ) ScheduleDose, ");
        sb.Append(" (CONCAT( ROUND((SELECT fs.MRP FROM f_stock fs WHERE fs.ItemID=tdm.ItemId ORDER BY id DESC LIMIT 1),2),' X ',tdm.Qty,' = ',ROUND(((SELECT fs.MRP FROM f_stock fs WHERE fs.ItemID=tdm.ItemId ORDER BY id DESC LIMIT 1)* tdm.Qty),2)) )CostQty ");
        sb.Append(" FROM Tenwek_Docotor_medicine_Order tdm  ");
        sb.Append(" LEFT JOIN f_indent_detail_patient fid ON fid.IndentNo=tdm.IndentNo and fid.ItemId=tdm.ItemId ");
        sb.Append(" INNER JOIN  employee_master em ON em.EmployeeID=tdm.EntryBy ");
        sb.Append(" WHERE tdm.IsActive=1 AND tdm.IsDisContinue=0 AND tdm.PatientId='" + PID + "' AND  tdm.TransactionId='" + TID + "' ");



        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        GrdOrder.DataSource = dt;
        GrdOrder.DataBind();
    }




    public void BindDiscontinuedData()
    {

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT   if(tdm.IsView=1, CONCAT('Acknowledge By ',tdm.ViewByName,' on ',DATE_FORMAT(tdm.ViewDateTime,'%d-%b-%Y %r')),'') Ackstring,tdm.Id,if(tdm.IsPrn=0,'NO','YES')PrnView,tdm.IsPrn,tdm.ItemId,tdm.ItemName,tdm.PatientId,tdm.TransactionId,tdm.DepartmentId, ");
        sb.Append("  DATE_FORMAT(tdm.StartDate,'%d-%b-%Y')StartDate,tdm.EndDate,tdm.IsNow,tdm.FirstDose,tdm.Dose,tdm.DoseUnit,tdm.IntervalId, ");
        sb.Append(" tdm.IntervalName,tdm.DurationName,tdm.DurationVal,tdm.Route,tdm.Qty,tdm.DoctorId,tdm.DoctorName, ");
        sb.Append(" tdm.Remark,tdm.IsDischargeMed,tdm.IndentNo, ");
        sb.Append(" IF(tdm.IsIndentDone=1,IF(IFNULL(fid.ReceiveQty,0)>0,'Transfered To Ward','Indent Done'),'Pending Indent ')  IndentStatus, ");
        sb.Append(" tdm.IsIndentDone,DATE_FORMAT(tdm.FinalDoseTime,'%d-%b-%Y %h:%i %p')FinalDoseTime,DATE_FORMAT(CONCAT( tdm.StartDate,' ',tdm.FirstDose),'%d-%b-%Y %h:%i %p')StartDoseTime , ");
        sb.Append(" ROUND((24 /(SELECT IFNULL( COUNT(sdt.DoseId),1) FROM tenwek_standard_dose_time sdt WHERE sdt.DoseId= tdm.IntervalId)),0)Frequency , ");
        sb.Append(" CONCAT(tdm.Dose,' / ',tdm.Route)DoseRoute,CONCAT(tdm.Dose,' ',tdm.DoseUnit )Doses,CONCAT(em.Title,' ' ,em.NAME) AS OrderBy,tdm.IsActive,tdm.IsDisContinue, ");
        sb.Append(" (CONCAT( ROUND((SELECT fs.MRP FROM f_stock fs WHERE fs.ItemID=tdm.ItemId ORDER BY id DESC LIMIT 1),2),' X ',tdm.Qty,' = ',ROUND(((SELECT fs.MRP FROM f_stock fs WHERE fs.ItemID=tdm.ItemId ORDER BY id DESC LIMIT 1)* tdm.Qty),2)) )CostQty ");

        sb.Append(" FROM Tenwek_Docotor_medicine_Order tdm  ");
        sb.Append(" LEFT JOIN f_indent_detail_patient fid ON fid.IndentNo=tdm.IndentNo and fid.ItemId=tdm.ItemId ");
        sb.Append(" INNER JOIN  employee_master em ON em.EmployeeID=tdm.EntryBy ");
        sb.Append(" WHERE tdm.IsActive=1 AND tdm.IsDisContinue=1 AND tdm.PatientId='" + PID + "' AND  tdm.TransactionId='" + TID + "' ");


        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        grdDiscontinued.DataSource = dt;
        grdDiscontinued.DataBind();
    }





    protected void GrdOrder_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Stop")
        {

            int id = Convert.ToInt32(e.CommandArgument);
            string ID = ((Label)GrdOrder.Rows[id].FindControl("lblId")).Text;

            PID = ((Label)GrdOrder.Rows[id].FindControl("lblPatientId")).Text;
            TID = ((Label)GrdOrder.Rows[id].FindControl("lblTransactionId")).Text;


            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {

                string str = "update Tenwek_Docotor_medicine_Order  set IsDisContinue=1,UpdateBy='" + Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id=" + Util.GetInt(ID) + " ";
                int i = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                if (i > 0)
                {
                    lblMsg.Text = "Discontinued Successfully";
                    Tnx.Commit();

                    BindData();
                    BindDiscontinuedData();
                }
                else
                {
                    lblMsg.Text = "Error Occured! Contact To Administrator.";
                    Tnx.Rollback();
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error Occured! Contact To Administrator.";
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




    public class insert
    {
        public string Id { get; set; } //int

        public string ItemId { get; set; }
        public string ItemName { get; set; }
        public string PatientId { get; set; }
        public string TransactionId { get; set; }
        public string DepartmentId { get; set; }
        public string StartDate { get; set; } //Date
        public string EndDate { get; set; } //Date
        public string IsNow { get; set; } //Int
        public string FirstDose { get; set; }
        public string Dose { get; set; }  //decimal
        public string DoseUnit { get; set; }
        public string IntervalId { get; set; } //int
        public string IntervalName { get; set; }
        public string DurationName { get; set; }
        public string DurationVal { get; set; } //Int
        public string Route { get; set; }
        public string Qty { get; set; }   //decimal
        public string DoctorId { get; set; }
        public string DoctorName { get; set; }
        public string Remark { get; set; }
        public string IsDischargeMed { get; set; }  //int
        public string IsIndentDone { get; set; } //int
        public string IndentNo { get; set; }
        public string IsActive { get; set; } //int         
        public string IsDisContinue { get; set; } //int
        public string EntryBy { get; set; }
        public string ReOrderAgainest { get; set; } //int
        public string FinalDoseTime { get; set; }
        public int TypeOfMedicine { get; set; }
        public string DoseTime { get; set; }
        public string IsPrn { get; set; } //int
    }

    protected void grdDiscontinued_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        
        //if (e.CommandName == "Reorder")
        //{

        //    int id = Convert.ToInt32(e.CommandArgument);
        //    string ID = ((Label)grdDiscontinued.Rows[id].FindControl("lblOrID")).Text;


        //    MySqlConnection con = new MySqlConnection();
        //    con = Util.GetMySqlCon();
        //    con.Open();
        //    MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        //    try
        //    {

        //        string str = " INSERT INTO Tenwek_Docotor_medicine_Order (ItemId,ItemName,PatientId,TransactionId, ";
        //        str += " DepartmentId,StartDate,EndDate,IsNow,FirstDose,Dose,DoseUnit,IntervalId,IntervalName,DurationName, ";
        //        str += " DurationVal,Route,Qty,DoctorId,DoctorName,Remark,IsDischargeMed,IsIndentDone, ";
        //        str += " IndentNo,ReOrderAgainest,EntryBy,FinalDoseTime) ";
        //        str += " SELECT ItemId,ItemName,PatientId,TransactionId,DepartmentId,NOW(),ADDDATE(NOW(),DATEDIFF(mo.EndDate,mo.StartDate)),IsNow, ";
        //        str += " FirstDose,Dose,DoseUnit,IntervalId,IntervalName,DurationName, ";
        //        str += " DurationVal,Route,Qty,DoctorId,DoctorName,Remark,";
        //        str += " IsDischargeMed,IsIndentDone,IndentNo,ID,EntryBy , ";
        //        str += " CONCAT(DATE(ADDDATE(NOW(),DATEDIFF(mo.EndDate,mo.StartDate))),' ',TIME(FinalDoseTime))";
        //        str += " FROM Tenwek_Docotor_medicine_Order mo WHERE mo.id=" + ID + "";


        //        int i = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);


        //       string strup = "update Tenwek_Docotor_medicine_Order  set IsActive=0,UpdateBy='" + Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id=" + Util.GetInt(ID) + " ";
        //        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strup);

        //        if (i > 0)
        //        {
        //            lblMsg.Text = "Reorder Successfully";
        //            Tnx.Commit();
        //            BindData();
        //            BindDiscontinuedData();
        //        }
        //        else
        //        {
        //            lblMsg.Text = "Error Occured! Contact To Administrator.";
        //            Tnx.Rollback();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        lblMsg.Text = "Error Occured! Contact To Administrator.";
        //        Tnx.Rollback();

        //        throw (ex);
        //    }
        //    finally
        //    {
        //        Tnx.Dispose();
        //        con.Close();
        //        con.Dispose();
        //    }
        //}
    }


    [WebMethod]
    public static string GetUnit()
    {
        string str = "SELECT sd.Name,sd.Id	 FROM  Tenwek_Unit sd  WHERE sd.IsActive=1  ";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod(EnableSession = true, Description = "Save Indent")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveReorder(insert item)
    {
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string str = "SELECT *	 FROM  tenwek_docotor_medicine_order sd  WHERE sd.id=" + Util.GetInt(item.Id) + "  ";
            DataTable dt = StockReports.GetDataTable(str);
            item.ItemId = dt.Rows[0]["ItemId"].ToString();
            item.ItemName = dt.Rows[0]["ItemName"].ToString();
            item.ReOrderAgainest = item.Id;
            item.PatientId = dt.Rows[0]["PatientId"].ToString();
            item.TransactionId = dt.Rows[0]["TransactionId"].ToString();
            item.DepartmentId = dt.Rows[0]["DepartmentId"].ToString();
            item.DoctorId = dt.Rows[0]["DoctorId"].ToString();
            item.DoctorName = dt.Rows[0]["DoctorName"].ToString();
             


            if (!Util.GetBoolean(item.IsNow))
            {
                item.FirstDose = Util.GetString(StockReports.ExecuteScalar("SELECT TIME_FORMAT(sdt.Time,'%h:%i %p')TimeLable FROM  tenwek_standard_dose_time sdt WHERE DoseId =" + Util.GetInt(item.IntervalId) + " ORDER BY  TIME(sdt.Time) ASC LIMIT 1"));
                item.IsNow = "0";
            }
            else
            {
                item.IsNow = "1";
            }

            string FinalTime = Util.GetString(StockReports.ExecuteScalar("SELECT  sdt.Time   FROM  tenwek_standard_dose_time sdt WHERE DoseId =" + Util.GetInt(item.IntervalId) + " ORDER BY  TIME(sdt.Time) Desc LIMIT 1"));
            item.FinalDoseTime = Util.GetDateTime(item.StartDate + " " + FinalTime).AddDays(Util.GetInt(item.DurationVal)).ToString("yyyy-MM-dd HH:mm:ss");

            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  tenwek_docotor_medicine_order ");
            sb.Append(" (ItemId,ItemName,PatientId,TransactionId,DepartmentId,StartDate,EndDate,IsNow, ");
            sb.Append("  FirstDose,Dose,DoseUnit,IntervalId,IntervalName,DurationName,DurationVal,Route,Qty,DoctorId, ");
            sb.Append("  DoctorName,Remark,IsDischargeMed,IsIndentDone,IndentNo,IsActive,EntryBy,FinalDoseTime,ReOrderAgainest,DoseTime,IsApproved,IsStudent) ");
            sb.Append(" VALUES (@ItemId,@ItemName,@PatientId,@TransactionId,@DepartmentId,@StartDate,@EndDate,@IsNow, ");
            sb.Append("  @FirstDose,@Dose,@DoseUnit,@IntervalId,@IntervalName,@DurtionName,@DurationVal,@Route,@Qty,@DoctorId, ");
            sb.Append("  @DoctorName,@Remark,@IsDischargeMed,@IsIndentDone,@IndentNo,@IsActive,@EntryBy,@FinalDoseTime,@ReOrderAgainest,@DoseTime,@IsApproved,@IsStudent) ");

            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {

                ItemId = Util.GetString(item.ItemId),
                ItemName = Util.GetString(item.ItemName),
                PatientId = Util.GetString(item.PatientId),
                TransactionId = Util.GetString(item.TransactionId),
                DepartmentId = Util.GetString(item.DepartmentId),
                StartDate = Util.GetDateTime(item.StartDate),
                EndDate = Util.GetDateTime(item.StartDate).AddDays(Util.GetInt(item.DurationVal)),
                IsNow = Util.GetInt(item.IsNow),
                FirstDose = Util.GetDateTime(item.FirstDose),
                Dose = Util.GetString(item.Dose),
                DoseUnit = Util.GetString(item.DoseUnit),
                IntervalId = Util.GetInt(item.IntervalId),
                IntervalName = Util.GetString(item.IntervalName),
                DurtionName = Util.GetString(item.DurationName),
                DurationVal = Util.GetString(item.DurationVal),
                Route = Util.GetString(item.Route),
                Qty = Util.GetInt(item.Qty),
                DoctorId = Util.GetString(item.DoctorId),
                DoctorName = Util.GetString(item.DoctorName),
                Remark = Util.GetString(item.Remark),
                IsDischargeMed = Util.GetInt(item.IsDischargeMed),
                IsIndentDone = 0,
                IndentNo = "",
                IsActive = 1,
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                FinalDoseTime = item.FinalDoseTime,
                ReOrderAgainest = item.ReOrderAgainest,
                DoseTime=item.DoseTime,
                IsApproved = Util.GetInt(GetApprovalType(Util.GetString(HttpContext.Current.Session["ID"].ToString()))),
                IsStudent = Util.GetInt(GetEmployeeType(Util.GetString(HttpContext.Current.Session["ID"].ToString()))),

            });




            int ReOrderId = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(ID) FROM tenwek_docotor_medicine_order"));
            string[] ScheduleTime = item.DoseTime.Split(',');

            foreach (string time in ScheduleTime)
            {
                StringBuilder sbDoseTime = new StringBuilder();


                sbDoseTime.Append(" INSERT INTO  tenwek_patient_dose_time ");
                sbDoseTime.Append(" (PatientId,OrderId,TransactionId,DoseTime,DoseId,DoseName) ");
                sbDoseTime.Append(" VALUES (@PatientId,@OrderId,@TransactionId,@DoseTime,@DoseId,@DoseName)");
                int T = excuteCMD.DML(tnx, sbDoseTime.ToString(), CommandType.Text, new
                {
                    PatientId = Util.GetString(item.PatientId),
                    OrderId = ReOrderId,
                    TransactionId = Util.GetString(item.TransactionId),
                    DoseTime = Util.GetDateTime(time),
                    DoseId = Util.GetInt(item.IntervalId),
                    DoseName = Util.GetString(item.IntervalName),

                });

            }











            CountSave += A;


            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Re Order Successfully" });

            }
            else
            {
                tnx.Rollback();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            CountSave--;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }




    [WebMethod(EnableSession = true, Description = "Save Indent")]
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


    [WebMethod]
    public static string GetNowTime()
    {
        DateTime dt = DateTime.Now; 


            return Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                time = Util.GetDateTime(dt).ToString("hh:mm tt")
            });

        
    }
     
    public static int GetApprovalType(string EmployeeId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.`EmployeeID`,em.`Title`,em.`NAME` FROM  employee_master em WHERE em.`TierID`=8 AND em.`EmployeeID`='" + EmployeeId + "' AND em.`IsActive`=1; ");

      DataTable  dt = StockReports.GetDataTable(sb.ToString());
      if (dt.Rows.Count>0 && dt!=null)
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