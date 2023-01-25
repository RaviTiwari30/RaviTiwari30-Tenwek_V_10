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
using System.Linq;


public partial class Design_Emergency_PatientIndent : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
			 if (Util.GetString(Request.QueryString["requestType"]) != "search")
            {
            ViewState["LedgerTnxNo"] = Request.QueryString["LTnxNo"].ToString();
            if (Resources.Resource.AllowFiananceIntegration == "1")//
            {
                if (AllLoadData_IPD.CheckDataPostToFinance(ViewState["LedgerTnxNo"].ToString()) > 0)
                {
                    string Msga = "Patient Final Bill Already Posted To Finance...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msga);
                }
            }
            if (Request.QueryString["TID"] != null)
            {
                spnTransactionID.InnerText = Request.QueryString["TID"].ToString();
                spnPatientID.InnerText = Request.QueryString["PID"].ToString();
                //DataTable dt = AllLoadData_IPD.LoadIPDPatientDetail(spnPatientID.InnerText, spnTransactionID.InnerText);
                //if (dt.Rows.Count > 0)
                //{
                //spnPanelID.InnerText = dt.Rows[0]["PanelID"].ToString();
                //spnIPD_CaseTypeID.InnerText = dt.Rows[0]["IPDCaseType_ID"].ToString();
                //spnRoomID.InnerText = dt.Rows[0]["Room_ID"].ToString();
                BindStoreDepartment();
                //}

            }
			}
        }
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
      //  DataTable dt = AllLoadData_Store.dtStoreIndentDepartments(Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), 0);

	string CentreID = Session["CentreID"].ToString();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT lm.`LedgerName`,lm.`LedgerNumber`FROM f_rolemaster rm INNER JOIN f_ledgermaster lm ON lm.`LedgerNumber`=rm.`DeptLedgerNo`INNER JOIN f_centre_role cr ON cr.RoleID=rm.id WHERE cr.CentreID IN (" + CentreID + ") AND rm.`IsStore`=1 AND cr.isActive=1 AND cr.IsPatientIndent=1 ");
       // if (Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()) == 11)
          //  sb.Append(" and rm.IsMedical=1 ");
       // else
         //   sb.Append(" and rm.IsGeneral=1 ");

        sb.Append(" order by LedgerName ");

	 DataTable dt = StockReports.GetDataTable(sb.ToString());
        //if (dt.Rows.Count > 0)
       // {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "LedgerName";
            ddlDepartment.DataValueField = "LedgerNumber";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
       // }

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
        DataTable dt = StockReports.GetDataTable("SELECT osm.entryid ID,osm.reqqty quantity,im.typename NAME,im.ItemID,osm.indentno,osm.dose,osm.timing Times,DATE_FORMAT(osm.duration,'%d-%b-%y')duration,osm.Route,im.unittype,im.MedicineType FROM orderset_medication  osm INNER JOIN f_itemmaster im ON im.ItemID=osm.medicineid INNER JOIN f_indent_detail_patient idp ON idp.`IndentNo`=osm.`IndentNo`WHERE idp.`id`='" + IndentNo + "' ");
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
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        if (Type == "0")
        {
            sb.Append("SELECT IM.Typename AS ItemName,im.HSNCode,IFNULL(st.Qty,'0') AS AvlQty,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(st.Qty,''),'#',IFNULL(IM.UnitType,''),'#',IF(pay.ItemID IS NULL,'0','1'),'#',im.Dose,'#',im.MedicineType,'#',im.Route,'#','0')ItemID");
            sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_itemmaster_centerwise itc ON itc.`ItemID`=im.`ItemID` ");
            sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID ");
            sb.Append(" LEFT JOIN (SELECT IF((InitialCount-ReleasedCount)>0,(InitialCount-ReleasedCount),0) ");
            sb.Append(" Qty,ItemID FROM f_stock WHERE isPost=1 AND (InitialCount-ReleasedCount)>0 ");
            if (DeptLedgerNo != "0")
                sb.Append(" AND DeptLedgerNo='" + DeptLedgerNo + "' ");
            sb.Append(" GROUP BY ITemID)st ON st.itemID = im.ItemID ");
            sb.Append(" LEFT JOIN f_panel_item_payable pay ON Pay.ItemID=im.ItemID AND Pay.PanelID='" + PanelID + "' AND  pay.IsActive=1 WHERE CR.ConfigID = 11 AND im.IsActive=1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + Session["CentreID"].ToString() + "' ");
            if (SubcategoryID != "0")
                sb.Append(" and SM.SubCategoryID='" + SubcategoryID + "'");
            sb.Append(" AND im.Typename like '" + itemName + "%'");
            sb.Append(" order by IM.Typename LIMIT " + Util.GetString(Request.QueryString["rows"]) + "");
        }
        else if (Type == "1")
        {
            sb.Append(" select im.HSNCode,IFNULL(st.Qty,'0') AS AvlQty,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(st.Qty,'0'),'#',IFNULL(IM.UnitType,''),'#',IF(pay.ItemID IS NULL,'0','1'),'#',im.Dose,'#',im.MedicineType,'#',im.Route)ItemID,im.typename AS ItemName from f_itemmaster im ");
            sb.Append(" INNER join f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID INNER JOIN f_itemmaster_centerwise itc ON itc.`ItemID`=im.`ItemID`  ");
            sb.Append(" LEFT JOIN (SELECT IF((InitialCount-ReleasedCount)>0,(InitialCount-ReleasedCount),0) ");
            sb.Append(" Qty,ItemID FROM f_stock WHERE isPost=1 AND (InitialCount-ReleasedCount)>0 ");
            sb.Append(" AND DeptLedgerNo='" + DeptLedgerNo + "' GROUP BY ITemID)st ON st.itemID = im.ItemID ");
            sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=im.ItemID LEFT JOIN f_salt_master fsm ON fis.saltID = fsm.SaltID ");
            sb.Append(" LEFT JOIN f_panel_item_payable pay ON Pay.ItemID=im.ItemID AND Pay.PanelID='" + PanelID + "' AND  pay.IsActive=1 WHERE fsm.IsActive=1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + Session["CentreID"].ToString() + "' ");
            if (SubcategoryID != "0")
                sb.Append(" and sm.SubCategoryID='" + SubcategoryID + "'");
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
            StringBuilder sb = new StringBuilder();
           


            int count = 0;
            string ItemID = string.Empty;
            string OtherIndentNo = string.Empty;
            string DurationDate = string.Empty;

            var distinctDepartmentIDs = Data.Select(i => i.Dept).ToList().Distinct().ToList();


            for (int j = 0; j < distinctDepartmentIDs.Count; j++)
            {
                IndentNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select get_indent_no_patient('" + Data[0].Dept + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')").ToString();
                if (string.IsNullOrEmpty(IndentNo))
                {
                    Tranx.Rollback();
                    con.Close();
                    con.Dispose();
                    return "0";
                }

                var departmentWiseItems = Data.Where(i => i.Dept == distinctDepartmentIDs[j]).ToList();

                for (int i = 0; i < departmentWiseItems.Count; i++)
                {
                    var itemDetails = departmentWiseItems[i];
                    DurationDate = itemDetails.Duration;
                    sb = new StringBuilder("insert into f_indent_detail_patient(IndentNo,ItemId,ItemName,ReqQty,UnitType,DeptFrom,DeptTo,StoreId,UserId,TransactionID,IndentType,CentreID,Hospital_Id,PatientID,DoctorID,IPDCaseTypeID,RoomID,isDischargeMedicine)  ");
                    sb.Append("values('" + IndentNo + "','" + itemDetails.ItemID + "','" + itemDetails.MedicineName + "'," + Util.GetFloat(itemDetails.Quantity) + "");
                    sb.Append(",'" + itemDetails.UnitType + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + itemDetails.Dept + "','STO00001', ");
                    sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + itemDetails.TID + "','" + itemDetails.IndentType + "','" + HttpContext.Current.Session["CentreID"].ToString() + "', ");
                    sb.Append("'" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + itemDetails.PID + "','" + itemDetails.DoctorID + "','" + Util.GetInt(itemDetails.IPDCaseType_ID) + "','" + Util.GetInt(itemDetails.Room_ID) + "'," + isDischargeMedicine + ") ");
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                    if (itemDetails.prescribeID != "0" && itemDetails.prescribeID != "")
                    {
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE patient_medicine pt SET  pt.IndentNo='" + IndentNo + "' WHERE    pt.PatientMedicine_ID=" + Data[i].prescribeID);
                    }
                }


                int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + Data[0].Dept + "'"));
                string notification = Notification_Insert.notificationInsert(28, IndentNo, Tranx, "", "", roleID);
                if (string.IsNullOrEmpty(notification))
                {
                    Tranx.Rollback();
                    return string.Empty;
                }

            }


           



            string EntryID = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select ifnull(Max(EntryID),0)+1 ID from emr_orderset_medication"));
            for (int i = 0; i < Data.Count; i++)
            {

                count = 1;
                ItemID = Data[i].ItemID;
                OtherIndentNo = IndentNo;
                DateTime DateDuration = Util.GetDateTime(System.DateTime.Now.AddDays(Util.GetDouble(Data[i].Duration.Split('#')[0])).ToString("yyyy-MM-dd"));
                sb= new StringBuilder(" Insert into orderset_medication(EntryID,TransactionID,PatientID,MedicineID,MedicineName,ReqQty,Dose,Timing,Duration,EntryBy,IndentNo,Route)values(");
                sb.Append(" " + Util.GetInt(EntryID) + ",'" + Data[i].TID + "','" + Data[i].PID + "','" + ItemID + "','" + Data[i].MedicineName + "','" + Util.GetFloat(Data[i].Quantity) + "', ");
                sb.Append(" '" + Data[i].Dose + "','" + Data[i].Time + "','" + DateDuration.ToString("yyyy-MM-dd") + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + OtherIndentNo + "','" + Data[i].Route + "')");
                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
            }


           


            Tranx.Commit();
            return "1";

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

    [WebMethod]
    public static string GetPrescriptionItems(string transactionID)
    {

        StringBuilder sqlCMD = new StringBuilder(" SELECT  im.ItemCode ItemCode, im.TypeName ItemName, im.SubCategoryID SubCategoryID, im.ItemID,CONCAT(dm.Title,dm.Name)DoctorName,pt.DoctorID, pt.Dose,pt.PatientMedicine_ID ,pt.NoTimesDay `Time`, pt.NoOfDays Duration, pt.Route Route, pt.IssueQuantity Quantity, pt.Remarks Remarks, im.UnitType unitType, pt.IndentNo FROM patient_medicine pt INNER JOIN  f_itemmaster im ON im.ItemID=pt.Medicine_ID INNER JOIN doctor_master dm ON dm.DoctorID=pt.DoctorID WHERE pt.IsEmergencyData=1 AND pt.isActive=1 AND pt.TransactionID='" + transactionID + "'  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCMD.ToString()));

    }



    public class insert
    {
        public string ItemID { get; set; }
        public string Dose { get; set; }
        public string Time { get; set; }
        public string Duration { get; set; }
        public string Route { get; set; }
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
        public string IPDCaseType_ID { get; set; }
        public string Room_ID { get; set; }
        public string prescribeID { get; set; }
    }
}