using System;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.HtmlControls;

public partial class Design_Store_OPDPharmacyIssue : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            lblDeptLedgerNo.Text = Session["DeptLedgerNo"].ToString();
            ViewState["IsDiscount"] = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "IsDiscount");
        }

        if (!IsPostBack)
        {
            //calExdtxtPrescribedMedicineFromDate.EndDate = calExdtxtPrescribedMedicineToDate.EndDate =
            //txtPrescribedMedicineFromDate.Text = txtPrescribedMedicineToDate.Text =
            txtfdate.Text = txttdate.Text = txtSearchModelFromDate.Text = txtSerachModelToDate.Text = txtIndentFrom.Text = txtIndentTo.Text = txtPenIndentFrom.Text = txtPenIndentTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calExdTxtSerachModelToDate.EndDate = calExdTxtSearchModelFromDate.EndDate = calExdTxtSerachModelToDate.EndDate = Calendarextender1.EndDate = Calendarextender2.EndDate = Calendarextender3.EndDate=Calendarextender4.EndDate=System.DateTime.Now;
        }

        txtSearchModelFromDate.Attributes.Add("readOnly", "readOnly");
        txtSerachModelToDate.Attributes.Add("readOnly", "readOnly");
        //txtPrescribedMedicineToDate.Attributes.Add("readOnly", "readOnly");
        //txtPrescribedMedicineFromDate.Attributes.Add("readOnly", "readOnly");

        var disableWalkinParmacyCentreIDs = Resources.Resource.DisableWalkinParmacyCentreIDs.Split(',');

        var ss = Array.FindAll(disableWalkinParmacyCentreIDs, s => s.Equals(HttpContext.Current.Session["CentreID"].ToString()));
        if (ss.Length > 0)
        {
            lblRdoWalkIn.Attributes.CssStyle.Add("display", "none");
            //spnWalkin.Attributes.CssStyle.Add("display", "none");
            //rdoGeneral.Attributes.CssStyle.Add("display", "none");
        }

    }

    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }

    [WebMethod(EnableSession=true)]
    public static string bindData(string patientID, string IPDNo, string EMGNo)
    {
        try
        {
            string TID = string.Empty;
            if (string.IsNullOrEmpty(patientID) && string.IsNullOrEmpty(IPDNo) && string.IsNullOrEmpty(EMGNo))
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Please Enter Search Criteria" });

           // if (IPDNo.Contains("LSHHI"))
            //    TID = IPDNo;
           // else
            //    TID = "ISHHI" + IPDNo;


            StringBuilder sb = new StringBuilder();
            //sb.Append(" SELECT pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PName,pm.Age,pm.Gender,");
            //sb.Append(" pm.Country,pm.Mobile ContactNo,CONCAT(pm.House_No,' ,',pm.City)Address,pmh.TransactionID,pm.HospPatientType, ");
            //if (type == 3)
            //    sb.Append(" (pmh.PanelID)PanelID, ");
            //else
            //    sb.Append(" IFNULL(PMH.`PanelID`,'')PanelID, ");
            //sb.Append(" IFNULL(fpm.Company_Name,'')Company_Name,IFNULL(pmh.DoctorID,'')DoctorID,'' PharmacyOSAmt FROM  patient_master pm ");
            //if (type == 3)
            //{
            //    sb.Append(" INNER JOIN patient_ipd_profile pid ON pm.PatientID=pid.PatientID");
            //    sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=pid.TransactionID ");
            //    sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID");
            //    sb.Append(" WHERE STATUS='IN' ");
            //    if (IPDNo.Trim() != "")
            //        sb.Append(" AND pid.TransactionID='ISHHI" + IPDNo.Trim() + "' ");
            //    else if (PatientID.Trim() != "")
            //        sb.Append(" AND pid.PatientID='" + PatientID.Trim() + "' ");
            //}
            //else
            //{
            //    sb.Append("  LEFT JOIN patient_medical_history pmh on pm.PatientID=pmh.PatientID ");
            //    sb.Append(" LEFT JOIN f_panel_master fpm ON fpm.PanelID=pm.PanelID WHERE pm.PatientID='" + PatientID + "'");
            //}


            sb.Append("SELECT IFNULL(IF(pmh.Type='EMG',emg.EmergencyNo,''),'')EmergencyNo ,pm.PatientID, CONCAT(pm.Title, ' ', pm.PName) PName,(pm.Title)Title,(pm.PName)PatientName, pm.Age, pm.Gender, pm.Country, pm.Mobile ContactNo, CONCAT(pm.House_No, ' ,', pm.City) Address, pmh.TransactionID, pm.HospPatientType, IFNULL(PMH.`PanelID`, '') PanelID, IFNULL(fpm.Company_Name, '') Company_Name, IFNULL(pmh.DoctorID, '') DoctorID, '' PharmacyOSAmt , IF(pmh.`TYPE`='IPD',pmh.Status,IF(emg.IsReleased=0 and pmh.Type='EMG','IN','OUT')) AS Status,pmh.BillNo,ifnull(pmh.Type,'OPD')PatientType ");
            /*sb.Append(" ,IFNULL((SELECT t.Vitial FROM (SELECT CONCAT(CONCAT( cv.`HT`,' ',CV.HTType),'#',CONCAT(cv.`WT`,' ',cv.WTTYPE))Vitial,DATE(cv.entrydate)EntryDate FROM `cpoe_vital` cv WHERE cv.`PatientID`=pm.patientid ");
            sb.Append(" UNION ALL ");
            sb.Append(" SELECT CONCAT(CONCAT(ipo.`Height`,'CM'),'#',CONCAT(ipo.Weight,ipo.WeightUnit))Vitial,DATE(ipo.date)EntryDate FROM IPD_Patient_ObservationChart ipo WHERE  ipo.`PatientID`=pm.Patientid )t ");
            sb.Append(" WHERE t.Vitial<>'#' ORDER BY t.EntryDate DESC LIMIT 1),'')Vitial ");*/
            sb.Append(" ,'' Vitial ");
            sb.Append(" FROM patient_master pm LEFT JOIN patient_medical_history pmh ON pm.PatientID = pmh.PatientID  AND pmh.Type IN('EMG','IPD','OPD') AND pmh.CentreID=@CentreID LEFT JOIN f_panel_master fpm ON fpm.PanelID = pm.PanelID LEFT JOIN emergency_patient_details emg ON emg.TransactionId=pmh.TransactionID AND emg.IsReleased=0 WHERE pm.PatientID IS NOT NULL  ");
            if (!string.IsNullOrEmpty(patientID))
                sb.Append(" AND pm.PatientID = @patientID");

            if (!string.IsNullOrEmpty(IPDNo))
                sb.Append(" AND pmh.TransNo=@ipdNo");

            if (!string.IsNullOrEmpty(EMGNo))
                sb.Append(" AND pmh.TransNo=@emergencyNo");

            sb.Append("  ORDER BY CONCAT(PMH.DateOfVisit,' ',PMH.Time) DESC ");

            ExcuteCMD excuteCMD = new ExcuteCMD();


            string  s = excuteCMD.GetRowQuery(sb.ToString(),new
            {
                patientID = patientID,
                ipdNo = IPDNo,
                emergencyNo = EMGNo,
                CentreID = HttpContext.Current.Session["CentreID"].ToString()
            });



            DataTable dataTable = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
            {
                patientID = patientID,
                ipdNo = IPDNo,
                emergencyNo = EMGNo,
                CentreID = HttpContext.Current.Session["CentreID"].ToString()
            });



            // Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable });
            if (dataTable.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable, message = "No Record Found, May be patient already discharged, or may be already released from emergency." });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator", response = ex.Message });
        }
    }

    [WebMethod]
    public static int getCurrentStock(string itemID, decimal SoldUnits)
    {
        int count = Util.GetInt(StockReports.GetDataTable("SELECT COUNT(*) FROM ( SELECT AvailableQty FROM (  SELECT (SUM(InitialCount) - SUM(ReleasedCount))AvailableQty " +
            "  FROM f_stock  WHERE (InitialCount - ReleasedCount) > 0  AND IsPost = 1 AND  DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  AND MedExpiryDate>CURDATE() AND itemid='" + itemID + "'  " +
            "  GROUP BY ItemID )t WHERE AvailableQty<" + SoldUnits + " )t2 "));
        return count;
    }

    public DataTable addItem()
    {
        DataTable dt = new DataTable();
        string itemName = Util.GetString(Request.QueryString["q"]);
        string type = Util.GetString(Request.QueryString["type"]);
        if (itemName != "")
        {
            StringBuilder sb = new StringBuilder();
            if (type == "1")
            {
                sb.Append("Select ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
                sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber,");
                sb.Append(" ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");
                sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf ");
                sb.Append(" ,IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID=sm.SaltID WHERE fis.ItemID=im.ItemID GROUP BY im.ItemID),'') AS Generic ");
                sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID ");
                sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + lblDeptLedgerNo.Text + "' ");
                sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
                sb.Append(" AND TRIM(ST.ItemName) LIKE '%" + itemName + "%' ");
                sb.Append(" AND st.DeptLedgerNo='" + lblDeptLedgerNo.Text + "' ");
                sb.Append("  AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') AND CR.ConfigID = 11 ");
                sb.Append("  ORDER BY st.MedExpiryDate LIMIT " + Util.GetString(Request.QueryString["rows"]) + " ");
            }
            else if (type == "2")
            {
                sb.Append("Select ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
                sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber,");
                sb.Append(" ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty ,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");
                sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf,fsm.Name AS Generic ");
                sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID");
                sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=ST.ItemID Inner JOIN f_salt_master ");
                sb.Append(" fsm ON fis.saltID = fsm.SaltID AND fsm.IsActive=1 ");
                sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + lblDeptLedgerNo.Text + "' ");
                sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
                sb.Append(" AND TRIM(fsm.Name)  LIKE '%" + itemName + "%' ");
                sb.Append(" AND st.DeptLedgerNo='" + lblDeptLedgerNo.Text + "'  AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') AND CR.ConfigID = 11 ");
                sb.Append("  ORDER BY st.MedExpiryDate LIMIT " + Util.GetString(Request.QueryString["rows"]) + " ");
            }
            else if (type == "3")
            {
            }

            dt = StockReports.GetDataTable(sb.ToString());
        }

        return dt;
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
    [WebMethod(EnableSession=true)]
    public static string medicineSearch(string MRNo, string fromDate, string toDate, string type, string DeptLedgerNo, string IPDNo)
    {
        StringBuilder sb = new StringBuilder();
        if (type.ToUpper() == "1")
        {
            sb.Append(" SELECT IF(pm.outsource = 1, 'Yes', 'No') outsource,pm.PatientID,IFNULL(dm.Name,'')doctorName,pm.issueQuantity,em.Name, ");
            sb.Append(" pm.NoOfDays,pm.Dose,pm.NoTimesDay,pm.OrderQuantity,  ");
            sb.Append(" DATE_FORMAT(pm.EnteryDate,'%d-%b-%Y %h:%i %p')EntryDate,IsIssued,pm.Medicine_ID,pm.PatientMedicine_ID,im.Typename FROM patient_medicine pm INNER JOIN ( ");
            sb.Append("    SELECT MAX(pm.PatientMedicine_ID)PatientMedicine_ID  ");
            sb.Append("    FROM patient_medicine pm WHERE  pm.PatientID = '" + MRNo.Trim() + "' AND pm.CentreID='"+ HttpContext.Current.Session["CentreID"].ToString() +"' AND DATE(pm.Date) >= '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "'   ");
            sb.Append("    AND DATE(pm.Date) <= '" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' GROUP BY pm.Medicine_ID ");
            sb.Append("   )t ON pm.PatientMedicine_ID=t.PatientMedicine_ID ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.itemID = pm.Medicine_ID ");
            // sb.Append(" INNER JOIN patient_master pms ON pms.PatientID=pm.PatientID ");
            sb.Append(" Left JOIN Employee_master em on em.employeeID= pm.IssueBy ");
            sb.Append(" LEFT JOIN doctor_master dm ON dm.DoctorID = pm.DoctorID ");
        }
        else if (type.ToUpper() == "3")
        {
            sb.Append("  SELECT * FROM (  ");
            sb.Append("   SELECT t.*,(CASE WHEN  t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ");
            sb.Append("   WHEN t.reqQty-t.ReceiveQty-t.RejectQty>0 THEN 'PARTIAL' ELSE ''  END)StatusNew  ");
            sb.Append("  FROM ( SELECT id.id,id.itemId,Id.Itemname, id.IndentNo,id.IndentType,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry, ");
            sb.Append("       lm.ledgername AS DeptFrom,id.Status,REPLACE(id.TransactionID,'ISHHI','')IPDNo,id.TransactionID, ");
            sb.Append("       (SELECT NAME FROM employee_master WHERE employeeid=id.userid)UserName,");
            sb.Append("       (SELECT NAME FROM  doctor_master WHERE DoctorID=pmh.DoctorID)DoctorName,");
            sb.Append("       (ReqQty)ReqQty,(ReceiveQty)ReceiveQty,(RejectQty)RejectQty,(ReqQty-ReceiveQty-RejectQty)PendingQty,if(ReceiveQty>0,1,0)IsIssued ");
            sb.Append("       FROM f_indent_detail_patient id INNER JOIN  patient_medical_history pmh ON id.TransactionID = pmh.TransactionID ");
            sb.Append("       INNER JOIN f_ledgermaster lm  ON lm.LedgerNumber = id.Deptfrom  WHERE id.storeid='STO00001' ");
            sb.Append("       AND id.deptto = '" + DeptLedgerNo + "' AND DATE(id.dtEntry) >= '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("       AND DATE(id.dtEntry) <= '" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND id.CentreID='"+ HttpContext.Current.Session["CentreID"].ToString() +"' AND pmh.TransactionID='" + IPDNo.ToString() + "'   ");
            sb.Append("    )t   ");
            sb.Append("   )t1  ");
            sb.Append(" WHERE t1.StatusNew IN ('OPEN','PARTIAL') ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string addItem(string ItemID, string MedID, string DeptLedgerNo, decimal AvlQty)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("Select ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,");
        sb.Append(" ST.MRP,ST.UnitPrice, ");
        sb.Append("(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,im.isexpirable,  ");
        sb.Append("date_format(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType,im.ToBeBilled,");
        // Add new on 29-06-2017 - For GST
        sb.Append(" ST.HSNCode,ST.IGSTPercent,ST.IGSTAmtPerUnit,ST.SGSTPercent,ST.SGSTAmtPerUnit,ST.CGSTPercent,ST.CGSTAmtPerUnit,ST.GSTType, ");
        //
        sb.Append("im.Type_ID,im.IsUsable,im.ServiceItemID,'" + AvlQty + "' NewAvlQty,'' IssueQty,0 IssueChecked,st.PurTaxPer from f_stock ST ");
        sb.Append(" INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID");
        sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
        sb.Append(" where (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 AND CR.ConfigID = 11 ");
        sb.Append(" and IM.ItemID ='" + ItemID + "' ");
        sb.Append(" and st.DeptLedgerNo='" + DeptLedgerNo + "' and st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "  ");
        sb.Append(" AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) > CURDATE())  order by st.MedExpiryDate");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "MedID";
            if (MedID != "0")
            {
                dc.DefaultValue = MedID;

            }
            else
            {
                dc.DefaultValue = "0";
            }
            dt.Columns.Add(dc);
            if (Util.GetDecimal(AvlQty) > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (Util.GetDecimal(dt.Rows[i]["AvlQty"].ToString()) > Util.GetDecimal(AvlQty))
                    {
                        dt.Rows[i]["IssueQty"] = Util.GetDecimal(AvlQty);
                        dt.Rows[i]["IssueChecked"] = "1";
                        break;
                    }
                    else
                    {
                        dt.Rows[i]["IssueQty"] = Util.GetDecimal(dt.Rows[i]["AvlQty"].ToString());
                        dt.Rows[i]["IssueChecked"] = "1";
                        AvlQty = AvlQty - Util.GetDecimal(dt.Rows[i]["AvlQty"].ToString());
                    }
                }
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    public static string MedicineCheck(string MRNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT MAX(pm.PatientMedicine_ID)PatientMedicine_ID  ");
        sb.Append("    FROM patient_medicine pm WHERE  pm.PatientID = '" + MRNo.Trim() + "' AND DATE(pm.Date) >=CURRENT_DATE()  ");
        sb.Append("    GROUP BY pm.Medicine_ID ");
        string MedicineID = StockReports.ExecuteScalar(sb.ToString());
        if (MedicineID != "")
            return "1";
        else
            return "0";
    }
    [WebMethod]
    public static string LoadMedSetItems(string SetID, string DeptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT SUM(IFNULL(ST.InitialCount - ST.ReleasedCount,0))StockQty,CASE WHEN SUM(IFNULL(ST.InitialCount - ST.ReleasedCount,0))=0 THEN 1 WHEN SUM(IFNULL(ST.InitialCount - ST.ReleasedCount,0))>med.Quantity THEN 2 ELSE 3 END medSetCon, ");
        sb.Append(" med.ID,med.Quantity,im.Typename NAME,im.ItemID,med.SetID,msm.Setname setName FROM MedicineSetItemMaster ");
        sb.Append(" med INNER JOIN f_itemmaster im ON im.ItemID=med.itemID INNER JOIN  MedicineSetmaster msm ON med.setID=msm.ID  ");
        sb.Append(" LEFT JOIN f_stock st ON st.ItemID=im.ItemID AND (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1  AND st.DeptLedgerNo='" + DeptLedgerNo + "' ");
        sb.Append(" AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01')   ");
        sb.Append(" WHERE med.setID='" + SetID + "' ");
        sb.Append(" GROUP BY im.ItemID  ORDER BY im.Typename ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return null;
    }
    [WebMethod]
    public static string checkOTStatus(string IPDNo)
    {
        return StockReports.ExecuteScalar("SELECT COUNT(*) FROM ot_transferPatient WHERE TransactionID='ISHHI" + IPDNo + "' AND STATUS='IN' ");
    }

    [WebMethod]
    public static string GetDrafts()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(dd.Title,' ',dd.PName) PName,dd.Mobile ContactNo,dd.Email,dd.Address,COUNT(dds.ID)TotalItems,dd.ID FROM store_demand_draft dd INNER JOIN store_demand_draft_details dds ON dd.ID=dds.DraftID WHERE IsUsed=1 AND (dds.Quantity-dds.ReceiveQty)>0 GROUP BY dd.ID ORDER BY dd.id ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession=true)]
    public static string GetAllPendingIndents(string deptLedgerNo, string searchby, string searchtype, string status, string department,string FromDate,string ToDate)
    {
        var sqlCmd = new StringBuilder(" SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM (  ");
        sqlCmd.Append("     SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty<=0 THEN 'CLOSE'  ");
        sqlCmd.Append("     WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  ");
        sqlCmd.Append("     FROM ( ");
        sqlCmd.Append("     SELECT id.indentno,ifnull(rqt.TypeName,'') as IndentType,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry, ");
        sqlCmd.Append("     (SELECT ledgername FROM f_ledgermaster WHERE LedgerNumber = id.Deptfrom)DeptFrom ,id.Status, ");
        // sqlCmd.Append("     REPLACE(id.TransactionID,'ISHHI','')IPDNo,id.TransactionID,pm.PatientID,pm.PName,id.DoctorID, ");
        sqlCmd.Append("     IF(pmh.Type='IPD',pmh.TransNo,'')IPDNo,id.TransactionID,pm.PatientID,pm.PName,id.DoctorID, ");
        sqlCmd.Append("     IFNULL(id.IPDCaseTypeID,'')IPDCaseType_ID,IFNULL(id.RoomID,'')Room_ID, ");
        sqlCmd.Append("     (SELECT NAME FROM employee_master WHERE employeeid=id.userid)UserName, ");
        sqlCmd.Append("     SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty ");
        sqlCmd.Append("     , IF(pmh.Type='IPD','',emg.EmergencyNo)EMGNo,id.TransactionID Typeindent,IFNULL(emg.IsReleased,-1) IsReleased,IFNULL(pip.Status,'OUT')StatusAd,(SELECT Company_Name FROM `f_panel_master` pm WHERE pm.panelID=pmh.PanelID)PanelName   ");
        sqlCmd.Append("     FROM f_indent_detail_patient id INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`=id.`TransactionID` LEFT JOIN f_typemaster Rqt on rqt.TypeID=id.IndentType INNER JOIN patient_master pm ON id.PatientID = pm.PatientID ");
        sqlCmd.Append("      LEFT JOIN emergency_patient_details emg ON emg.TransactionId=id.TransactionID and emg.IsReleased=0  ");
        sqlCmd.Append("   LEFT JOIN patient_ipd_profile pip ON pip.TransactionID=id.TransactionID AND pip.Status='IN' ");
        //  sqlCmd.Append("     WHERE DATE(id.dtEntry) =CURDATE()  AND id.storeid='STO00001' ");
        sqlCmd.Append("     WHERE id.storeid='STO00001' AND id.CentreID='"+ HttpContext.Current.Session["CentreID"].ToString() +"'  ");
        sqlCmd.Append("     and id.deptto = @deptLedgerNo ");
        if (!string.IsNullOrEmpty(searchby) && searchby == "id.TransactionID" && !string.IsNullOrEmpty(searchtype))
            sqlCmd.Append(" AND id.TransactionID='" + StockReports.getTransactionIDbyTransNo(searchtype) + "' ");
        else if (!string.IsNullOrEmpty(searchby) && !string.IsNullOrEmpty(searchtype))
            sqlCmd.Append(" AND " + searchby + " ='" + searchtype + "' ");
        if(department != "")
            sqlCmd.Append(" AND id.DeptFrom IN (" + department + ") ");
        if (!string.IsNullOrEmpty(FromDate.ToString()) && !string.IsNullOrEmpty(ToDate.ToString()))
        {
            sqlCmd.Append(" And DATE(id.dtEntry) >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(id.dtEntry) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        }
        sqlCmd.Append("     GROUP BY IndentNo ");
        sqlCmd.Append(" )t WHERE IF(t.IPDNo = '',t.IsReleased=0,t.StatusAd='IN') ");
        sqlCmd.Append(" )t1 ");
        if(status != "ALL")
        sqlCmd.Append(" WHERE StatusNew IN (" + status + ") ");
        sqlCmd.Append(" Order by indentno ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var s = excuteCMD.GetRowQuery(sqlCmd.ToString(), new
        {
            deptLedgerNo = deptLedgerNo
        });
        DataTable dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            deptLedgerNo = deptLedgerNo
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
        
    }
    [WebMethod]
    public static string ClinicalTrial(string ItemID, string PatientId)
    {
        DataTable dt = StockReports.GetDataTable("SELECT cd.PatientID,cd.Remarks,date_format(cd.EntryDateTime,'%d-%b-%Y %I:%i %p')EntryDateTime,im.TypeName FROM f_clinical_Patient_details cd inner join f_itemmaster im on im.ItemID= cd.ItemID inner join employee_master em on cd.EntryBy= em.EmployeeID inner join patient_master pm on pm.PatientID = cd.PatientID where cd.ItemID='" + ItemID + "' and cd.PatientID='" + PatientId + "' order by cd.Id desc ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetDraftDetails(int draftID)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();


        string ss = excuteCMD.GetRowQuery("SELECT  dds.Quantity, dd.PatientID,dd.PFirstName, dd.PLastName,dd.Title, dd.Address,dd.Age, dd.DoctorID,dd.Email,dd.Mobile ContactNo,dd.PanelID,dds.ItemID,dds.StockID,dds.DiscountPercent, IFNULL((SELECT SUM(s.Amount) FROM f_points_rewardcash s WHERE s.PatientID=pm.PatientID),0)RewardCashAmount, IFNULL(pm.MemberShip,'') MemberShip, IF((pm.MemberShipDate<NOW() OR  IFNULL(pm.MemberShip,'')<>''),1,0) IsMemberShipActive FROM store_draft_bill dd INNER JOIN store_draft_bill_details dds ON dd.ID=dds.DraftID LEFT JOIN  patient_master pm ON pm.PatientID=dd.PatientID WHERE dd.id=@id", new
        {
            id = draftID
        });


        var dt = excuteCMD.GetDataTable("SELECT dds.Quantity, dd.PatientID, dd.PFirstName, dd.PLastName, dd.Title, dd.Address, dd.Age, dd.DoctorID, dd.Email, dd.Mobile ContactNo, dd.PanelID, dds.ItemID, dds.StockID, dds.DiscountPercent FROM store_demand_draft dd INNER JOIN store_demand_draft_details dds ON dd.ID = dds.DraftID LEFT JOIN patient_master pm ON pm.PatientID = dd.PatientID WHERE dd.id =@id", CommandType.Text, new
        {
            id = draftID
        });




        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    public static string ValidateUser(string userName, string password)
    {


        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable UserExits = excuteCMD.GetDataTable("SELECT l.EmployeeID FROM f_login l WHERE l.UserName=@userName AND l.Password=@password AND l.Active=1 and RoleID=@roleID and CentreID=@CentreID ", CommandType.Text, new
        {
            userName = userName,
            password = EncryptPassword(password),
            roleID = Util.GetInt(HttpContext.Current.Session["RoleID"]),
            CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"])
        });

        if (UserExits.Rows.Count > 0 && UserExits != null)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, UserID = UserExits.Rows[0]["EmployeeID"].ToString(), message = "VALID User." });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, UserID = "", message = "Invalid User." });
        //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Invalid User." });



    }




    public static string EncryptPassword(string text)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));
        byte[] result = md5.Hash;
        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < result.Length; i++)
        {
            strBuilder.Append(result[i].ToString("x2"));
        }
        return strBuilder.ToString();
    }

    [WebMethod]
    public static string GetAllergiesAndDiagnosis(string patientID)
    {
        // patientID = "C0036504";
        string str = "SELECT 'Allergies' AS DataType,ce.Allergies AS DataValues,DATE_FORMAT(ce.EntryDate,'%d-%b-%y') AS EntryDate FROM CPOE_hpexam ce " +
                     "WHERE ce.PatientID='" + patientID + "' AND IFNULL(ce.Allergies,'')<>'' " +
                    "UNION ALL " +
                    "SELECT 'Allergies' AS DataType,ce.Allergies AS DataValues,DATE_FORMAT(ce.EntryDate,'%d-%b-%y') AS EntryDate FROM emr_hpexam ce  " +
                    "WHERE ce.PatientID='" + patientID + "' AND IFNULL(ce.Allergies,'')<>''  " +
                    "UNION ALL " +
                    "SELECT 'Diagnosis' AS DataType, cp.ProvisionalDiagnosis AS DataValues,DATE_FORMAT(cp.CreatedDate,'%d-%b-%y') AS EntryDate  " +
                    "FROM EMR_PatientDiagnosis cp WHERE cp.PatientID='" + patientID + "' AND IFNULL(cp.ProvisionalDiagnosis,'')<>'' " +
                    "UNION ALL SELECT 'Diagnosis' AS DataType, cp.ProvisionalDiagnosis AS DataValues,DATE_FORMAT(cp.CreatedDate,'%d-%b-%y') AS EntryDate  " +
                    "FROM cpoe_PatientDiagnosis cp WHERE cp.PatientID='" + patientID + "' AND IFNULL(cp.ProvisionalDiagnosis,'')<>''";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public static string MedicineSearchPatient(string FolderNo, string DoctorID, string FromDate, string ToDate, string Status, string RoleId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT t2.* FROM ");
        sb.Append("  ( ");
        sb.Append("        SELECT t1.*,IF((t1.TItem <> t1.Issued),IF((t1.Issued AND t1.Pending)=0,'Pending','Partial'),'Issued')STATUS ");
        sb.Append("        FROM  ");
        sb.Append("          ( ");
        sb.Append("              SELECT t.PatientID,t.`DoctorID`,t.`App_ID`,t.`IsIPDData`,t.DATE, ");
        sb.Append("              SUM(t.TItem)TItem,SUM(t.Issued)Issued,SUM(t.Pending)Pending,t.TransactionID,  ");
        sb.Append("              CONCAT(pm.title,' ',pm.`PName`)PName,pm.`Age`,CONCAT(dm.title,' ',dm.Name)NAME, ");
        sb.Append(" (SELECT pnl.`Company_Name` FROM  f_panel_master pnl WHERE pnl.`PanelID`=pmh.`PanelID`) PanelName");
        sb.Append("            FROM  ");
        sb.Append("            ( ");
        sb.Append("                SELECT pmd.`PatientID`,pmd.`DoctorID`,pmd.`App_ID`,pmd.`IsIPDData`,DATE_FORMAT(pmd.EnteryDate,'%d-%b-%Y')DATE, ");
        sb.Append("                 COUNT(*)TItem, 0 Pending, 0 Issued,TransactionID FROM patient_medicine pmd WHERE 1 = 1  AND  ifnull(pmd.DocRoleId,0) in (" + Util.GetInt(RoleId) + ",0) and  pmd.IsActive=1 and pmd.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'  ");

        if (!string.IsNullOrEmpty(FromDate.ToString()) && !string.IsNullOrEmpty(ToDate.ToString()))
        {
            sb.Append(" AND DATE(pmd.EnteryDate) >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(pmd.EnteryDate) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        }
        sb.Append("                 GROUP BY pmd.`TransactionID` ");
        sb.Append("                   UNION ALL ");
        sb.Append("                SELECT pmd.`PatientID`,pmd.`DoctorID`,pmd.`App_ID`,pmd.`IsIPDData`,DATE_FORMAT(pmd.EnteryDate,'%d-%b-%Y')DATE, ");
        sb.Append("                 0 TItem, 0 Pending, COUNT(*)Issued, TransactionID FROM patient_medicine pmd  ");
        sb.Append("                 WHERE pmd.`IsIssued`=1  AND  ifnull(pmd.DocRoleId,0) in (" + Util.GetInt(RoleId) + ",0) and pmd.IsActive=1 and pmd.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");

        if (!string.IsNullOrEmpty(FromDate.ToString()) && !string.IsNullOrEmpty(ToDate.ToString()))
        {
            sb.Append(" AND DATE(pmd.EnteryDate) >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(pmd.EnteryDate) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        }
        sb.Append("                GROUP BY pmd.`TransactionID`  ");
        sb.Append("                  UNION ALL ");
        sb.Append("                SELECT pmd.`PatientID`,pmd.`DoctorID`,pmd.`App_ID`,pmd.`IsIPDData`,DATE_FORMAT(pmd.EnteryDate,'%d-%b-%Y')DATE, ");
        sb.Append("                 0 TItem, COUNT(*)Pending, 0 Issued, TransactionID FROM patient_medicine pmd ");
        sb.Append("                 WHERE pmd.`IsIssued`=0 AND  ifnull(pmd.DocRoleId,0) in (" + Util.GetInt(RoleId) + ",0) and pmd.IsActive=1 and pmd.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");

        if (!string.IsNullOrEmpty(FromDate.ToString()) && !string.IsNullOrEmpty(ToDate.ToString()))
        {
            sb.Append(" AND DATE(pmd.EnteryDate) >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(pmd.EnteryDate) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        }
        sb.Append("                 GROUP BY pmd.`TransactionID`  ");
        sb.Append("            )t  ");
        sb.Append("            INNER JOIN `patient_master` pm ON pm.`PatientID`= t.`PatientID`   ");
        sb.Append("            INNER JOIN `doctor_master` dm ON dm.DoctorID=t.`DoctorID` ");
        sb.Append("            INNER JOIN `patient_medical_history` pmh ON pmh.TransactionID=t.`TransactionID` ");

        sb.Append("            GROUP BY `TransactionID`  ");
        sb.Append("          )t1 ");
        sb.Append("  )t2 Where 1=1 ");
        if (FolderNo != "")
        {
            sb.Append(" AND `PatientID`='" + FolderNo + "'");
        }
        if (DoctorID != "0")
        {
            sb.Append(" AND `DoctorID`='" + DoctorID + "'");
        }
        if (Status == "Pending")
        {
            sb.Append(" AND STATUS='Pending'  OR STATUS='Partial'  ");
        }
        //if (Status == "In-Complete")
        //{
        //    sb.Append(" AND STATUS='Partial' ");
        //}
        if (Status == "Complete")
        {
            sb.Append(" AND STATUS='Issued' ");
        }
        sb.Append(" ORDER BY DATE,App_Id ASC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());



        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
 
       

    }


    [WebMethod(EnableSession = true)]
    public static string BindRole()
    {
        var sqlCmd = new StringBuilder();

        sqlCmd.Append(" SELECT DISTINCT(mr.RoleId)RoleId,mr.RoleName Name FROM tenwek_Map_Department_to_Role mr");
 
        DataTable dt = StockReports.GetDataTable(sqlCmd.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

}