<%@ WebService Language="C#" Class="prescribeServices" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Text;
using System.Linq;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.Xml.Linq;
using System.IO;

using System.Web.Script.Serialization;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class prescribeServices : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string GetAmount(string ItemID)
    {
        var sqlCmd = new StringBuilder("SELECT IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",SubcategoryID,UnitPrice) ,0) MRP from f_stock where (InitialCount- ReleasedCount)>0 AND  CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND ItemID='" + ItemID + "'  ORDER BY id DESC LIMIT 1 ");
        var dt = StockReports.GetDataTable(sqlCmd.ToString());
        if (dt.Rows.Count>0 && dt!=null)
        {
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response =dt  });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" });

        }
        
    }

    [WebMethod(EnableSession = true)]
    public string medicineItemSearch(string prefix)
    {

        string DepartmentLedgerTransaction = "LSHHI57";
       string dptLedgerNo = StockReports.ExecuteScalar("SELECT rm.`DeptLedgerNo` FROM doctor_master dm INNER JOIN doctor_employee de ON de.`DoctorID`=dm.`DoctorID` INNER JOIN tenwek_map_department_to_role tmd ON tmd.`DocDepartment`=dm.`DocDepartmentID` AND tmd.`IsActive`=1 INNER JOIN f_rolemaster rm ON rm.`ID`=tmd.`RoleId` WHERE de.`EmployeeID`='" + HttpContext.Current.Session["ID"].ToString() + "';");

       if (!string.IsNullOrEmpty(dptLedgerNo))
       {
           DepartmentLedgerTransaction = dptLedgerNo;
       }
         
       
        //var sqlCmd= new StringBuilder("SELECT im.ItemCode,UPPER(CONCAT(SUBSTR(sm.Name,1,3),'. ',IM.Typename)) Typename, IM.ItemID, IM.MedicineType, IM.Dose, CONCAT(IFNULL(im.ItemCode, ''),'#',IFNULL(IM.Typename, '')) ItemName, IF(IFNULL(qty,0)<'1',CONCAT(IM.ItemID,'#','1','#',IM.MedicineType,'#',IM.Dose), CONCAT(IM.ItemID,'#','0','#',IM.MedicineType,'#',IM.Dose))ItemID FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID   LEFT JOIN  f_item_salt ts ON im.ItemID=ts.ItemID INNER JOIN f_salt_master fsm ON  fsm.SaltID=ts.saltID LEFT JOIN (SELECT IF(SUM(InitialCount-ReleasedCount)>0,SUM(InitialCount-ReleasedCount),0)  Qty,ItemID FROM f_stock WHERE ispost=1  AND MedExpiryDate > CURDATE() GROUP BY ITemID)st ON st.itemID = im.ItemID WHERE CR.ConfigID = 11 AND im.IsActive=1   ORDER BY IM.Typename limit 10";

       var sqlCmd = new StringBuilder(" SELECT * FROM ( SELECT im.ItemCode, UPPER(CONCAT('(Qty:',ROUND(IFNULL(st.Qty,0),2),')',SUBSTR(sm.Name, 1, 3),'.',IM.Typename,' - ',IFNULL(fsm.Name,''))) Typename, IM.ItemID, IM.MedicineType, IFNULL(IM.Dose,'') `Dose`,IFNULL(IM.Duration,'')`Duration`,IFNULL(IM.Route,'')`Route`,IFNULL(IM.Times,'')`Times`,IM.Typename `Brand`, fsm.Name `Generic`  FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID LEFT JOIN  f_item_salt ts ON im.ItemID=ts.ItemID LEFT JOIN f_salt_master fsm ON  fsm.SaltID=ts.saltID LEFT JOIN (SELECT SUM(InitialCount - ReleasedCount) Qty, ItemID FROM f_stock WHERE ispost = 1 AND MedExpiryDate > CURDATE() AND (InitialCount - ReleasedCount)>0 AND CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " AND DeptledgerNo='" + DepartmentLedgerTransaction + "' GROUP BY ITemID) st ON st.itemID = im.ItemID WHERE CR.ConfigID = 11 AND im.IsActive = 1  AND (im.TypeName LIKE '%" + prefix + "%' OR fsm.Name LIKE '%" + prefix + "%') ORDER BY st.Qty DESC");
        //  sqlCmd.Append(" UNION ALL ");
        //sqlCmd.Append(" SELECT im.ItemCode, UPPER(CONCAT(SUBSTR(sm.Name, 1, 3),'.',IM.Typename,' - ',IFNULL(fsm.Name,''))) Typename, IM.ItemID, IM.MedicineType, IFNULL(IM.Dose,'') `Dose`,IFNULL(IM.Duration,'')`Duration`,IFNULL(IM.Route,'')`Route`,IFNULL(IM.Times,'')`Times`,IM.Typename `Brand`, fsm.Name `Generic` FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID LEFT JOIN  f_item_salt ts ON im.ItemID=ts.ItemID Left JOIN f_salt_master fsm ON  fsm.SaltID=ts.saltID LEFT JOIN (SELECT IF( SUM(InitialCount - ReleasedCount) > 0, SUM(InitialCount - ReleasedCount),0 ) Qty, ItemID FROM f_stock WHERE ispost = 1 AND MedExpiryDate > CURDATE() GROUP BY ITemID) st ON st.itemID = im.ItemID WHERE CR.ConfigID = 11 AND im.IsActive = 1 AND im.TypeName LIKE '%" + prefix + "%'  ");
       sqlCmd.Append(" ) t UNION All ");
        sqlCmd.Append(" SELECT '' ItemCode ,cdm.`ItemName` `Typename`,cdm.id `ItemID`, '' `MedicineType`,cdm.Dose,cdm.Duration,cdm.Route,cdm.Times,cdm.`ItemName` `BrandName`,'' Generic FROM   cpoe_doctorItem_Master cdm   WHERE cdm.ItemType=1 and  cdm.`ItemName`  LIKE '%" + prefix + "%' ");
        var dt = StockReports.GetDataTable(sqlCmd.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public string getMedicineQuantity(string type)
    {
        System.Data.DataTable dtData = LoadCacheQuery.LoadMedicineQuantity(type);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
    }

    [WebMethod]
    public string getRoute()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(AllGlobalFunction.Route);
    }

    [WebMethod]
    public string GetMolecular()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT s.Name label,CONCAT(s.SaltID,'#',s.CIMS_GUID) val FROM  f_salt_master s WHERE s.IsActive=1 AND s.CIMS_Type='Molecule'"));
    }




    [WebMethod(EnableSession = true)]
    public string InvestigationItemSearch(int isIPDData, string transactionId, string appID)
    {
        DataTable dtInv = LoadCacheQuery.LoadInvestigation("1", "0", "0", isIPDData, transactionId, appID);
        StringBuilder sqlQuery = new StringBuilder(); //new StringBuilder( "SELECT cdm.ItemName,cdm.id,0 `IsPackage`  FROM   cpoe_doctorItem_Master cdm  WHERE cdm.ItemType=3 ");

        if (isIPDData == 0)
        {
           DataTable dt = StockReports.GetDataTable("SELECT app.CentreID,app.ScheduleChargeID,pm.ReferenceCode FROM appointment app INNER JOIN f_panel_master pm ON pm.PanelID=app.PanelID WHERE app.App_ID='" + appID + "' ORDER BY App_ID DESC LIMIT 1;");
           if (dt.Rows.Count == 0 || dt == null)
            {
                dt = StockReports.GetDataTable("SELECT pmh.ScheduleChargeID,pm.ReferenceCode,pmh.CentreID FROM patient_medical_history pmh INNER JOIN f_panel_master pm ON pm.PanelID=pmh.PanelID WHERE pmh.TransactionID='" + transactionId + "' LIMIT 1;");
            }
            
            //by indra prakash
            sqlQuery.Append(" SELECT (SELECT Rate FROM f_ratelist  rt  WHERE panelid='1' AND itemid=itm.ItemID AND iscurrent='1')Rate1,pm.Name `ItemName`,itm.ItemID `id`,1 `IsPackage` ");

            if (dt.Rows.Count > 0 && dt != null)
                sqlQuery.Append(" ,IFNULL(rl.Rate ,0) as Rate ");   
            else
                sqlQuery.Append(" ,0 Rate "); 

            sqlQuery.Append(" FROM package_master pm INNER JOIN f_itemmaster itm ON  itm.Type_ID=pm.PackageID INNER JOIN f_subcategorymaster sub ON sub.SubCategoryID=itm.subCategoryID INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID  AND con.ConfigID=23 ");

            if (dt.Rows.Count>0 && dt != null)
                sqlQuery.Append(" LEFT JOIN f_ratelist rl ON rl.ItemID=itm.ItemID  AND rl.PanelID='" + dt.Rows[0]["ReferenceCode"].ToString() + "' AND rl.CentreID='" + dt.Rows[0]["CentreID"].ToString() + "' AND rl.IsCurrent=1");
    
            
            sqlQuery.Append(" WHERE pm.IsActive=1 AND itm.IsActive=1  AND  pm.ToDate >=CURDATE() ");

            var dtDoctorItems = StockReports.GetDataTable(sqlQuery.ToString());
            foreach (DataRow item in dtDoctorItems.Rows)
            {
                DataRow toInsert = dtInv.NewRow();
                toInsert[0] = item["ItemName"];
                toInsert["itemID"] = item["id"];
                toInsert["NewItemID"] = item["id"];
                toInsert["TypeName"] = item["ItemName"];
                toInsert["IsPackage"] = item["IsPackage"];
                toInsert["IsOutSource"] = 0;
                toInsert["Rate"] = item["Rate"];
                dtInv.Rows.InsertAt(toInsert, 0);
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtInv);
    }

    [WebMethod(EnableSession = true)]
    public string ProcedureItemSearch(string TransactionId)
    {
        string PanelId = StockReports.ExecuteScalar("SELECT pmh.`PanelID` FROM patient_medical_history pmh WHERE pmh.`TransactionID`='"+TransactionId+"' ");

        string ReffCodeOPd = StockReports.ExecuteScalar("SELECT ReferenceCodeOPD FROM f_panel_master WHERE PanelID='" + PanelId + "'");


        DataTable dtMain = CreateStockMaster.LoadItemSubCategoryByCategoryConfigID("'25','20'", ReffCodeOPd);
        var dtDoctorItems = StockReports.GetDataTable("SELECT cdm.ItemName,cdm.id FROM   cpoe_doctorItem_Master cdm  WHERE cdm.ItemType=2 ");
        foreach (DataRow item in dtDoctorItems.Rows)
        {
            DataRow toInsert = dtMain.NewRow();
            toInsert["ItemID"] = item["id"];
            toInsert["TypeName"] = item["ItemName"];
            toInsert["ProName"] = item["ItemName"];
            toInsert["NewItemID"] = item["id"];
            dtMain.Rows.InsertAt(toInsert, 0);
        }


        return Newtonsoft.Json.JsonConvert.SerializeObject(dtMain);
    }
    [WebMethod(EnableSession = true)]
    public string loadPrescriptionView(int isIPDData)
    {
        string doctorId = StockReports.ExecuteScalar("SELECT d.`DoctorID` FROM doctor_employee d WHERE d.`EmployeeID`='" + HttpContext.Current.Session["ID"].ToString() + "' LIMIT 1 ");

        DataTable dt = new DataTable();

   DataTable dtExist = StockReports.GetDataTable("SELECT cp.ID, cp.AccordianName,cp.ViewUrl,cp.divHTML, IF(cpms.`Id` IS NULL,1,if(" + isIPDData + "=1,cp.IsIPDHide,0)) AS IsHide FROM cpoe_prescription_master cp INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID` AND cpms.`RoleID`='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND cpms.`IsDefault`=0 AND cpms.`DoctorID`='" + doctorId + "' AND cpms.`IsActive`=1 WHERE cp.IsActive=1 GROUP BY cp.`ID` ORDER BY cpms.order ");
       if (dtExist.Rows.Count > 0)
       {
        if (doctorId != "" && doctorId != null && doctorId != "0")
            dt = StockReports.GetDataTable("SELECT cp.ID, cp.AccordianName,cp.ViewUrl,cp.divHTML, IF(cpms.`Id` IS NULL,1,if(" + isIPDData + "=1,cp.IsIPDHide,0)) AS IsHide FROM cpoe_prescription_master cp LEFT JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID` AND cpms.`RoleID`='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND cpms.`IsDefault`=0 AND cpms.`DoctorID`='" + doctorId + "' AND cpms.`IsActive`=1 WHERE cp.IsActive=1 GROUP BY cp.`ID` ORDER BY cpms.order ");
        else
        {

            // dt = StockReports.GetDataTable("SELECT cp.ID,cp.AccordianName,cp.ViewUrl,cp.divHTML,IF(cpms.`Id` IS NULL,1,if(" + isIPDData + "=1,cp.IsIPDHide,0)) AS IsHide FROM cpoe_prescription_master cp INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID` AND cpms.`RoleID`='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND cpms.`IsDefault`=1 AND ifnull(cpms.`DoctorID`,'')='' AND cpms.`IsActive`=1 WHERE cp.IsActive=1 GROUP BY cp.`ID` ORDER BY cpms.order ");
            dt = StockReports.GetDataTable("SELECT cp.ID,cp.AccordianName,cp.ViewUrl,cp.divHTML,1 AS IsHide FROM cpoe_prescription_master cp LEFT JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID` AND cpms.`RoleID`='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND cpms.`IsDefault`=1 AND ifnull(cpms.`DoctorID`,'')='' AND cpms.`IsActive`=1 WHERE cp.IsActive=1 GROUP BY cp.`ID` ORDER BY cpms.order ");

        }

}
        if (dt.Rows.Count == 0)
        {
           // if (HttpContext.Current.Session["ID"].ToString() != "EMP001")
              //  dt = StockReports.GetDataTable("SELECT cp.ID,cp.AccordianName,cp.ViewUrl,cp.divHTML,1 IsHide FROM cpoe_prescription_master cp ORDER BY cp.Order");
          //  else
            dt = StockReports.GetDataTable("SELECT cp.ID,cp.AccordianName,cp.ViewUrl,cp.divHTML,if(" + isIPDData + "=1,cp.IsIPDHide,0) IsHide FROM cpoe_prescription_master cp  where cp.IsActive=1 ORDER BY cp.Order");

        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    public class TemplateMaster
    {
        public int? id { get; set; }
        public string valueField { get; set; }
        public string templateName { get; set; }
        public string doctorID { get; set; }
        public int templateFor { get; set; }
    }

    public class SetItem
    {
        public string ItemID { get; set; }
        public decimal Quantity { get; set; }
        public int? SetID { get; set; }
        public string Dose { get; set; }
        public string Route { get; set; }
        public string Meal { get; set; }
        public string Time { get; set; }
        public string Duration { get; set; }
    }

    public class TemplateMedicineSet : TemplateMaster
    {
        private List<SetItem> _medicines = new List<SetItem>();
        public List<SetItem> medicines { get; set; }

    }


    public class molecular
    {
        public string molecularName { get; set; }
        public int molecularID { get; set; }
    }
    public class prescriptionHeader
    {
        public int Id { get; set; }
    }



    [WebMethod(EnableSession = true)]
    public string SavePrescription(List<Patient_Test> investigations, List<Patient_Medicine> medicines, List<Patient_Test> procedures, string transactionID, string App_ID, string patientID, string chiefComplaint, string doctorNotes, string clinicalExamination, string appointmentDoctorID, string vaccinationStatus, string allergies, string medications, string progressionComplaint, List<molecular> molecularAllergies, string ledgerTransactionNo, string provisionalDiagnosis, string doctorAdvice, string confidentialData, List<prescriptionHeader> prescriptionHeader, string referral, string referralRemarks, string refferdoctor, string referaltype, string consultationType, string referDept, string doctorType, string appointmentDate, string appointmentTime, int isDoctorAppointment, int IsIPDData)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            List<Patient_Test> investigationsList = new JavaScriptSerializer().ConvertToType<List<Patient_Test>>(investigations);
            List<Patient_Test> proceduresList = new JavaScriptSerializer().ConvertToType<List<Patient_Test>>(procedures);
            List<Patient_Medicine> medicinesList = new JavaScriptSerializer().ConvertToType<List<Patient_Medicine>>(medicines);
            string userID = HttpContext.Current.Session["ID"].ToString();
            var doctorID = GetDoctor(userID, transactionID);
            string sqlQuery = string.Empty;
            ExcuteCMD excuteCMD = new ExcuteCMD();

            if (IsIPDData == 1)
            {
                if (string.IsNullOrEmpty(App_ID))
                {
                    App_ID = Util.GetString(excuteCMD.ExecuteScalar(tnx, "CALL insert_ipd_prescriptionvisit(@transactionID,@doctorID,@createdBy)", CommandType.Text, new
                    {
                        transactionID = transactionID,
                        doctorID = doctorID,
                        createdBy = userID
                    }));
                }
            }

            var medicinePrescriptionMaster = StockReports.GetDataTable("SELECT * FROM medicinePrescriptionMaster").AsEnumerable().Select(i => new { text = Util.GetString(i.Field<string>("Text")).ToLower(), type = Util.GetInt(i.Field<int>("Type")) }).ToList();
            var doctorItemsMaster = StockReports.GetDataTable("SELECT m.ItemName,m.ItemType  FROM cpoe_doctorItem_Master m").AsEnumerable().Select(i => new { itemName = Util.GetString(i.Field<string>("ItemName")).ToLower(), itemType = Util.GetInt(i.Field<int>("ItemType")) }).ToList();

            sqlQuery = "UPDATE patient_test pt  SET isactive=@isActive WHERE pt.IsIssue=@IsIssue and pt.TransactionID=@TransactionID and pt.App_ID=@App_ID and IsIPDData=@IsIPDData";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                IsIssue = 0,
                TransactionID = transactionID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });



            for (int i = 0; i < investigationsList.Count; i++)
            {
                var isAlreadyPrescribed = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM patient_test pt WHERE pt.TransactionID=@transactionID and pt.App_ID=@App_ID  AND pt.IsActive=1  AND  pt.Test_ID=@testID and IsIPDData=@IsIPDData", CommandType.Text, new
                {
                    transactionID = transactionID,
                    testID = investigationsList[i].Test_ID,
                    App_ID = App_ID,
                    IsIPDData = IsIPDData
                }));

                if (isAlreadyPrescribed < 1)
                {
                    Patient_Test pt = new Patient_Test(tnx);
                    pt.PatientID = investigationsList[i].PatientID;
                    pt.App_ID = App_ID;
                    pt.TransactionID = investigationsList[i].TransactionID;
                    pt.Test_ID = investigationsList[i].Test_ID;
                    pt.name = investigationsList[i].name;
                    pt.LedgerTransactionNo = investigationsList[i].LedgerTransactionNo;
                    pt.Quantity = investigationsList[i].Quantity;
                    pt.Remarks = investigationsList[i].Remarks;
                    pt.ConfigID = Util.GetInt(3);
                    pt.IsUrgent = 0;
                    pt.Outsource = investigationsList[i].Outsource;
                    pt.DoctorID = doctorID;
                    pt.CreatedBy = userID;
                    pt.IsPackage = investigationsList[i].IsPackage;
                    pt.IsIPDData = IsIPDData;
                    pt.PrescribeDate = Util.GetDateTime(investigations[i].PrescribeDate);
                    pt.Insert();

                    if (investigationsList[i].Test_ID.ToString().ToLower().Contains("oth"))
                    {
                        var isItemExits = doctorItemsMaster.Where(d => d.itemType == 3 && d.itemName.ToLower() == investigationsList[i].name.ToLower()).ToList();
                        if (isItemExits.Count < 1)
                        {
                            var item = new
                            {
                                ItemName = investigationsList[i].name,
                                Dose = string.Empty,
                                Route = string.Empty,
                                Duration = string.Empty,
                                Times = string.Empty,
                                ItemType = 3
                            };
                            excuteCMD.ExecuteScalar(tnx, "INSERT INTO cpoe_doctoritem_master(ItemName,Dose,Route,Duration,Times,ItemType) VALUES (@ItemName,@Dose,@Route,@Duration,@Times,@ItemType)", CommandType.Text, item);
                            var _temp = new { itemName = investigationsList[i].name, itemType = 3 };
                            doctorItemsMaster.Add(_temp);
                        }
                    }
                }

            }

            for (int i = 0; i < proceduresList.Count; i++)
            {



                var isAlreadyPrescribed = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM patient_test pt WHERE pt.TransactionID=@transactionID and pt.App_ID=@App_ID AND pt.IsActive=1 AND  pt.Test_ID=@testID AND IsIPDData=@IsIPDData", CommandType.Text, new
                {
                    transactionID = transactionID,
                    testID = proceduresList[i].Test_ID,
                    App_ID = App_ID,
                    IsIPDData = IsIPDData
                }));

                if (isAlreadyPrescribed < 1)
                {

                    Patient_Test pt = new Patient_Test(tnx);
                    pt.PatientID = proceduresList[i].PatientID;
                    pt.App_ID = App_ID;
                    pt.TransactionID = proceduresList[i].TransactionID;
                    pt.Test_ID = proceduresList[i].Test_ID;
                    pt.name = proceduresList[i].name;
                    pt.DoctorID = doctorID;
                    pt.LedgerTransactionNo = proceduresList[i].LedgerTransactionNo;
                    pt.Remarks = proceduresList[i].Remarks;
                    pt.Quantity = Util.GetInt(proceduresList[i].Quantity);
                    pt.ConfigID = Util.GetInt(3);
                    pt.CreatedBy = userID;
                    pt.IsIPDData = IsIPDData;
                    pt.PrescribeDate = Util.GetDateTime(proceduresList[i].PrescribeDate);
                    pt.Insert();

                    if (proceduresList[i].Test_ID.ToString().ToLower().Contains("oth"))
                    {
                        var isItemExits = doctorItemsMaster.Where(d => d.itemType == 2 && d.itemName.ToLower() == proceduresList[i].name.ToLower()).ToList();
                        if (isItemExits.Count < 1)
                        {
                            var item = new
                            {
                                ItemName = proceduresList[i].name,
                                Dose = string.Empty,
                                Route = string.Empty,
                                Duration = string.Empty,
                                Times = string.Empty,
                                ItemType = 2
                            };
                            excuteCMD.ExecuteScalar(tnx, "INSERT INTO cpoe_doctoritem_master(ItemName,Dose,Route,Duration,Times,ItemType) VALUES (@ItemName,@Dose,@Route,@Duration,@Times,@ItemType)", CommandType.Text, item);
                            var _temp = new { itemName = proceduresList[i].name, itemType = 2 };
                            doctorItemsMaster.Add(_temp);
                        }
                    }
                }

            }

            sqlQuery = "UPDATE patient_medicine pt  SET isactive=@isActive WHERE pt.IsIssued=@IsIssued and pt.TransactionID=@TransactionID and pt.App_ID=@App_ID and IsIPDData=@IsIPDData";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                IsIssued = 0,
                TransactionID = transactionID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });


            for (int i = 0; i < medicinesList.Count; i++)
            {
                var isAlreadyPrescribed = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM patient_medicine pm WHERE pm.TransactionID=@transactionID and pm.App_ID=@App_ID AND pm.IsActive=1 AND pm.Medicine_ID=@medicineID and IsIPDData=@IsIPDData", CommandType.Text, new
                {
                    transactionID = transactionID,
                    medicineID = medicinesList[i].Medicine_ID,
                    App_ID = App_ID,
                    IsIPDData = IsIPDData
                }));

                StringBuilder sbgetrle = new StringBuilder();
                sbgetrle.Append(" SELECT mr.DocDepartment,mr.RoleId,fr.DeptLedgerNo,dm.DoctorID ");
                sbgetrle.Append(" FROM tenwek_Map_Department_to_Role mr ");
                sbgetrle.Append(" INNER JOIN doctor_master DM ON dm.DocDepartmentID=mr.DocDepartment ");
                sbgetrle.Append(" INNER JOIN f_rolemaster fr ON fr.ID=mr.RoleId");
                sbgetrle.Append(" WHERE mr.IsActive=1 AND dm.DoctorID=" + Util.GetInt(doctorID) + "");
                DataTable MappedDpt = StockReports.GetDataTable(sbgetrle.ToString());

                int DrDeptId = 0;
                int DrRoleID = 0;
                string DeptLedgerNo = "";

                if (MappedDpt.Rows.Count>0)
                {
                    DrDeptId = Util.GetInt(MappedDpt.Rows[0]["DocDepartment"].ToString());
                    DrRoleID = Util.GetInt(MappedDpt.Rows[0]["RoleId"].ToString());
                    DeptLedgerNo = Util.GetString(MappedDpt.Rows[0]["DeptLedgerNo"].ToString());
                    
                }

                if (isAlreadyPrescribed < 1)
                {
                    Patient_Medicine objMed = new Patient_Medicine(tnx);
                    objMed.PatientID = medicinesList[i].PatientID;
                    objMed.TransactionID = medicinesList[i].TransactionID;

                    objMed.Medicine_ID = medicinesList[i].Medicine_ID;
                    objMed.MedicineName = medicinesList[i].MedicineName;
                    objMed.NoOfDays = medicinesList[i].NoOfDays;

                    objMed.NoTimesDay = medicinesList[i].NoTimesDay;
                    objMed.Remarks = medicinesList[i].Remarks;
                    objMed.Quantity = medicinesList[i].Quantity;
                    objMed.Dose = medicinesList[i].Dose;
                    objMed.EnteryBy = HttpContext.Current.Session["ID"].ToString();
                    objMed.Meal = medicinesList[i].Meal;
                    objMed.LedgerTransactionNo = medicinesList[i].LedgerTransactionNo;
                    objMed.Route = medicinesList[i].Route;
                    int Emergency = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(SubcategoryID) FROM appointment WHERE TransactionID='" + medicinesList[i].TransactionID + "' and App_ID=" + App_ID + " AND SubcategoryID='" + Resources.Resource.EmergencySubcategoryID + "' "));
                    if (Emergency > 0)
                        objMed.isEmergency = 1;
                    objMed.centreID = Util.GetInt(Session["centreID"].ToString());
                    objMed.Hospital_ID = Session["HOSPID"].ToString();
                    objMed.DoctorID = doctorID;
                    objMed.App_ID = Util.GetInt(App_ID);
                    objMed.IsIPDData = IsIPDData;

                    objMed.Unit = medicinesList[i].Unit;
                    objMed.IntervalId = medicinesList[i].IntervalId;
                    objMed.IntervalName = medicinesList[i].IntervalName;
                    objMed.DurationVal = medicinesList[i].DurationVal;
                    objMed.DurationName = medicinesList[i].DurationName;
                    objMed.TimetoGive = medicinesList[i].TimetoGive;
                    objMed.RefealVal = medicinesList[i].RefealVal;                   
                    objMed.DocDepartmentId = DrDeptId;
                    objMed.DocRoleId =  DrRoleID;
                    objMed.DeptLedgerNo = DeptLedgerNo;
                    
                    
                    
                    objMed.RefealTillDate = Util.GetDateTime(DateTime.Now.AddMonths(Util.GetInt(medicinesList[i].RefealVal)).ToString()).ToString();  
                    
                     
                    int med = objMed.Insert();


                    int OrderId = med;
                    string[] ScheduleTime = medicinesList[i].TimetoGive.Split(',');

                    foreach (string time in ScheduleTime)
                    {
                        StringBuilder sbDoseTime = new StringBuilder();


                        sbDoseTime.Append(" INSERT INTO  tenwek_patient_dose_time_opd ");
                        sbDoseTime.Append("  (PatientId,OrderId,TransactionId,DoseTime,DoseId,DoseName) ");
                        sbDoseTime.Append(" VALUES (@PatientId,@OrderId,@TransactionId,@DoseTime,@DoseId,@DoseName)");
                        int T = excuteCMD.DML(tnx, sbDoseTime.ToString(), CommandType.Text, new
                        {
                            PatientId = Util.GetString(medicinesList[i].PatientID),
                            OrderId = OrderId,
                            TransactionId = Util.GetString(medicinesList[i].TransactionID),
                            DoseTime = Util.GetDateTime(time),
                            DoseId = Util.GetInt(medicinesList[i].IntervalId),
                            DoseName = Util.GetString(medicinesList[i].IntervalName),

                        });

                    }

                    
                    
                    
                    
                    
                    
                    var isDosesExits = medicinePrescriptionMaster.Where(d => d.type == 1 && d.text == medicinesList[i].Dose.ToLower()).ToList();
                    if (isDosesExits.Count < 1)
                    {
                        var dose = new { text = medicinesList[i].Dose, type = 1 };
                        excuteCMD.ExecuteScalar(tnx, "INSERT INTO medicinePrescriptionMaster (`Text`,`Type`)VALUES(@text,@type)", CommandType.Text, dose);
                        medicinePrescriptionMaster.Add(dose);
                    }

                    var isTimesExits = medicinePrescriptionMaster.Where(d => d.type == 2 && d.text == medicinesList[i].NoTimesDay.ToLower()).ToList();
                    if (isTimesExits.Count < 1)
                    {
                        var time = new { text = medicinesList[i].NoTimesDay, type = 2 };
                        excuteCMD.ExecuteScalar(tnx, "INSERT INTO medicinePrescriptionMaster (`Text`,`Type`)VALUES(@text,@type)", CommandType.Text, time);
                        medicinePrescriptionMaster.Add(time);
                    }

                    var isDaysExits = medicinePrescriptionMaster.Where(d => d.type == 3 && d.text.ToLower() == medicinesList[i].NoOfDays.ToLower()).ToList();

                    if (isDaysExits.Count < 1)
                    {
                        var days = new { text = medicinesList[i].NoOfDays, type = 3 };
                        excuteCMD.ExecuteScalar(tnx, "INSERT INTO medicinePrescriptionMaster (`Text`,`Type`)VALUES(@text,@type)", CommandType.Text, days);
                        medicinePrescriptionMaster.Add(days);

                    }

                    var isRouteExits = medicinePrescriptionMaster.Where(d => d.type == 4 && d.text.ToLower() == medicinesList[i].Route.ToLower()).ToList();
                    if (isRouteExits.Count < 1)
                    {
                        var route = new { text = medicinesList[i].Route, type = 4 };
                        excuteCMD.ExecuteScalar(tnx, "INSERT INTO medicinePrescriptionMaster (`Text`,`Type`)VALUES(@text,@type)", CommandType.Text, route);
                        medicinePrescriptionMaster.Add(route);
                    }

                    if (medicinesList[i].Medicine_ID.ToString().ToLower().Contains("oth"))
                    {
                        var isItemExits = doctorItemsMaster.Where(d => d.itemType == 1 && d.itemName.ToLower() == medicinesList[i].MedicineName.ToLower()).ToList();
                        if (isItemExits.Count < 1)
                        {
                            var item = new
                            {
                                ItemName = medicinesList[i].MedicineName,
                                Dose = medicinesList[i].Dose,
                                Route = medicinesList[i].Route,
                                Duration = medicinesList[i].NoOfDays,
                                Times = medicinesList[i].NoTimesDay,
                                ItemType = 1
                            };
                            excuteCMD.ExecuteScalar(tnx, "INSERT INTO cpoe_doctoritem_master(ItemName,Dose,Route,Duration,Times,ItemType) VALUES (@ItemName,@Dose,@Route,@Duration,@Times,@ItemType)", CommandType.Text, item);
                            var _temp = new { itemName = medicinesList[i].MedicineName, itemType = 1 };
                            doctorItemsMaster.Add(_temp);
                        }
                    }
                }
            }


            #region Start of Doctor Notes
            sqlQuery = "UPDATE Cpoe_careplan cc SET cc.IsActive=@isActive WHERE cc.TransactionID=@TransactionID and cc.App_ID=@App_ID AND IsIPDData=@IsIPDData";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                TransactionID = transactionID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });
            sqlQuery = "INSERT  INTO cpoe_careplan (CarePlan,TransactionID,PatientID,EntryBy,App_ID,IsIPDData)VALUES(@CarePlan,@TransactionID,@PatientID,@EntryBy,@App_ID,@IsIPDData)";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                CarePlan = doctorNotes,
                TransactionID = transactionID,
                PatientID = patientID,
                EntryBy = userID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });
            #endregion end of Doctor Notes


            #region Start of Doctor Advice
            sqlQuery = "UPDATE cpoe_doctorAdvice cc SET cc.IsActive=@isActive WHERE cc.TransactionID=@TransactionID and cc.App_ID=@App_ID AND IsIPDData=@IsIPDData";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                TransactionID = transactionID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });
            sqlQuery = "INSERT  INTO cpoe_doctorAdvice (doctorAdvice,TransactionID,PatientID,EntryBy,App_ID,IsIPDData)VALUES(@doctorAdvice,@TransactionID,@PatientID,@EntryBy,@App_ID,@IsIPDData)";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                doctorAdvice = doctorAdvice,
                TransactionID = transactionID,
                PatientID = patientID,
                EntryBy = userID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });
            #endregion end of Doctor Advice
            #region Start of prescription Header
            sqlQuery = "UPDATE cpoe_PrescriptionHeaderShow cc SET cc.IsActive=@isActive WHERE cc.TransactionID=@TransactionID and cc.App_ID=@App_ID AND IsIPDData=@IsIPDData";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                TransactionID = transactionID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });

            for (int i = 0; i < prescriptionHeader.Count; i++)
            {
                sqlQuery = "INSERT INTO cpoe_PrescriptionHeaderShow (cpoe_prescription_master_ID,TransactionID,PatientID,EntryBy,App_ID,IsIPDData)VALUES(@cpoe_prescription_master_ID,@TransactionID,@PatientID,@EntryBy,@App_ID,@IsIPDData)";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    cpoe_prescription_master_ID = prescriptionHeader[i].Id,
                    TransactionID = transactionID,
                    PatientID = patientID,
                    EntryBy = userID,
                    App_ID = App_ID,
                    IsIPDData = IsIPDData
                });
            }
            #endregion end of prescription Header




            #region Start of confidential data
            sqlQuery = "UPDATE cpoe_confidentialdata cc SET cc.IsActive=@isActive WHERE cc.TransactionID=@TransactionID and cc.App_ID=@App_ID AND IsIPDData=@IsIPDData";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                TransactionID = transactionID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });
            sqlQuery = "INSERT  INTO cpoe_confidentialdata (confidentialData,TransactionID,PatientID,EntryBy,App_ID,IsIPDData)VALUES(@confidentialData,@TransactionID,@PatientID,@EntryBy,@App_ID,@IsIPDData)";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                confidentialData = confidentialData,
                TransactionID = transactionID,
                PatientID = patientID,
                EntryBy = userID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });
            #endregion end of confidential data

            #region Start of Vaccination Status
            sqlQuery = "UPDATE cpoe_VaccinationStatus cc SET cc.IsActive=@isActive WHERE cc.TransactionID=@TransactionID and cc.App_ID=@App_ID AND IsIPDData=@IsIPDData";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                TransactionID = transactionID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });
            sqlQuery = "INSERT  INTO cpoe_VaccinationStatus (VaccinationStatus,TransactionID,PatientID,EntryBy,App_ID,IsIPDData)VALUES (@VaccinationStatus,@TransactionID,@PatientID,@EntryBy,@App_ID,@IsIPDData)";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                VaccinationStatus = vaccinationStatus,
                TransactionID = transactionID,
                PatientID = patientID,
                EntryBy = userID,
                App_ID = App_ID,
                IsIPDData = IsIPDData
            });
            #endregion end of Vaccination Status





            #region Start of CPOEExaminiation
            string a = "SELECT count(*) FROM cpoe_hpexam WHERE TransactionID='" + transactionID + "' and App_ID=" + App_ID + " AND IsIPDData=" + IsIPDData + "";
            string IsCPOEExaminiation = StockReports.ExecuteScalar("SELECT count(*) FROM cpoe_hpexam WHERE TransactionID='" + transactionID + "' and App_ID=" + App_ID + " AND IsIPDData=" + IsIPDData + "");
            if (Util.GetInt(IsCPOEExaminiation) == 0)
            {
                sqlQuery = "INSERT INTO cpoe_hpexam(TransactionID,PatientID,ClinicalExaminiation,MainComplaint,Allergies,Medications,ProgressionComplaint,EntryBy,EntryDate,App_ID,IsIPDData)"
                         + " VALUE(@TransactionID,@PatientID,@ClinicalExaminiation,@MainComplaint,@Allergies,@Medications,@ProgressionComplaint,@EntryBy,@EntryDate,@App_ID,@IsIPDData)";

                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TransactionID = transactionID,
                    PatientID = patientID,
                    ClinicalExaminiation = clinicalExamination,
                    MainComplaint = chiefComplaint,
                    Allergies = allergies,
                    Medications = medications,
                    ProgressionComplaint = progressionComplaint,
                    EntryBy = userID,
                    EntryDate = System.DateTime.Now.ToString("yyyy-MM-dd"),
                    App_ID = App_ID,
                    IsIPDData = IsIPDData

                });
            }
            else
            {
                sqlQuery = "update cpoe_hpexam SET ClinicalExaminiation=@ClinicalExaminiation,MainComplaint=@MainComplaint,allergies=@Allergies,medications=@Medications,ProgressionComplaint=@ProgressionComplaint where TransactionID=@TransactionID and App_ID=@App_ID AND IsIPDData=@IsIPDData";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TransactionID = transactionID,
                    ClinicalExaminiation = clinicalExamination,
                    MainComplaint = chiefComplaint,
                    Medications = medications,
                    ProgressionComplaint = progressionComplaint,
                    Allergies = allergies,
                    App_ID = App_ID,
                    IsIPDData = IsIPDData

                });
            }
            #endregion End of CPOEExaminiation



            #region Start of MolecularAllergies
            excuteCMD.DML(tnx, "DELETE FROM cpoe_molecullarallergies WHERE TransactionID=@TransactionID and APP_ID=@App_ID AND IsIPDData=@IsIPDData", CommandType.Text, new { TransactionID = transactionID, APP_ID = App_ID, IsIPDData = IsIPDData });
            sqlQuery = "INSERT INTO cpoe_molecullarallergies (TransactionID, PatientID, MolecularName, MolecularID , APP_ID,IsIPDData) VALUES (@TransactionID,@PatientID,@MolecularName,@MolecularID,@APP_ID,@IsIPDData)";

            for (int i = 0; i < molecularAllergies.Count; i++)
            {
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TransactionID = transactionID,
                    PatientID = patientID,
                    MolecularName = molecularAllergies[i].molecularName,
                    MolecularID = molecularAllergies[i].molecularID,
                    App_ID = App_ID,
                    IsIPDData = IsIPDData
                });
            }


            #endregion End of MolecularAllergies


            #region Start Provisional Diagnosis

            if (provisionalDiagnosis != "")
            {
                excuteCMD.DML(tnx, "Delete from cpoe_PatientDiagnosis where LedgerTransactionNo=@LedgerTransactionNo and App_ID=@App_ID AND IsIPDData=@IsIPDData", CommandType.Text, new { LedgerTransactionNo = ledgerTransactionNo, App_ID = App_ID, IsIPDData = IsIPDData });
                sqlQuery = "insert into cpoe_PatientDiagnosis(PatientID,TransactionID,LedgerTransactionNo,ProvisionalDiagnosis,CreatedBy,App_ID,IsIPDData) values(@PatientID,@TransactionID,@LedgerTransactionNo,@ProvisionalDiagnosis,'" + HttpContext.Current.Session["ID"].ToString() + "',@App_ID,@IsIPDData)";

                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TransactionID = transactionID,
                    PatientID = patientID,
                    LedgerTransactionNo = ledgerTransactionNo,
                    ProvisionalDiagnosis = provisionalDiagnosis,
                    App_ID = App_ID,
                    IsIPDData = IsIPDData

                });
            }
            #endregion End of Provisional Diagnosis


            #region Start Referral Consultation

            excuteCMD.DML(tnx, "UPDATE cpoe_referralConsultation SET IsActive=0 WHERE TransactionID=@TID AND AppID=@AppID AND IsActive=1 AND IsIPDData=@IsIPDData", CommandType.Text, new
            {
                TID = transactionID,
                AppID = App_ID,
                IsIPDData = IsIPDData
            });


            if (!String.IsNullOrEmpty(referDept) || !String.IsNullOrEmpty(refferdoctor))
            {
                sqlQuery = "INSERT INTO cpoe_referralConsultation(TransactionID,PatientID,DoctorID,DATE,TIME,ReferralType,ConsultationType,FromDrID,Impression,EntryBy,Entrydate,AppID,Remarks,referDept,doctorType,NewAppDate,NewAppTime,IsIPDData) VALUES";
                sqlQuery += "(@TransactionID,@PatientID,@DoctorID,CURDATE(),CURRENT_TIME(),@ReferralType,@ConsultationType,@FromDrID,@Impression,@EntryBy,CURDATE(),@AppID,@Remarks,@referDept,@doctorType,@NewAppDate,@NewAppTime,@IsIPDData)";

                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TransactionID = transactionID,
                    PatientID = patientID,
                    DoctorID = refferdoctor,
                    ReferralType = referaltype,
                    ConsultationType = consultationType,
                    FromDrID = HttpContext.Current.Session["ID"].ToString(),
                    Impression = referral,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    AppID = App_ID,
                    Remarks = referralRemarks,
                    referDept = referDept,
                    doctorType = doctorType,
                    NewAppDate = Util.GetDateTime(Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd")),
                    NewAppTime = appointmentTime,
                    IsIPDData = IsIPDData
                });



                if (IsIPDData == 0)
                {
                    // Appointment ************* 
                    int IsAlreadyBookApp = 0;
                    if (isDoctorAppointment == 1)
                    {
                        string sqlappquery = "SELECT COUNT(*) FROM appointment app WHERE app.`DoctorID`='" + refferdoctor + "' AND app.`Date`='" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "' AND app.`Time`='" + Util.GetDateTime(appointmentTime.Split('-')[0]).ToString("HH:mm:ss") + "' AND app.`EndTime`='" + Util.GetDateTime(appointmentTime.Split('-')[1]).ToString("HH:mm:ss") + "' AND app.`IsCancel`=0 ";
                        IsAlreadyBookApp = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sqlappquery));
                    }

                    if (isDoctorAppointment == 1 && IsAlreadyBookApp == 0)
                    {
                        int AppNo=0;
                        int IsSlotWiseToken = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IFNULL(isSlotWiseToken,0) AS isSlotWiseToken FROM doctor_master dm WHERE dm.`DoctorID`='" + refferdoctor + "' "));

                        if (IsSlotWiseToken == 0)
                        {
                            AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_AppNo('" + refferdoctor + "','" + Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd") + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')"));
                        }
                        else
                        {
                            AppNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select get_Token_No_Doctor_Appointment('" + refferdoctor + "','" + Util.GetDateTime(appointmentDate).DayOfWeek.ToString() + "','" + appointmentTime + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')"));
                        }
                        
                        List<docVisitDetail> visitDetail1 = AllLoadData_OPD.appVisitDetail(Util.GetDateTime(Util.GetDateTime(DateTime.Now)), Util.GetString(Resources.Resource.FirstVisitSubCategoryID), con);

                        StringBuilder sbsql = new StringBuilder();
                        sbsql.Append(" SELECT app.`Title`,app.`PLastName`,app.`PFirstName`,app.`PName`, ");
                        sbsql.Append(" app.`DOB`,Get_Age(app.`DOB`) AS Age, app.`MaritalStatus`, ");
                        sbsql.Append(" app.`Sex`,app.`ContactNo`,app.`Email`,3 AS TypeOfApp,app.`PatientType`,app.`City`,app.`Nationality`, NOW() `EntryDate`,app.`PanelID`, ");
                        sbsql.Append(" app.`Address`,app.`Taluka`,app.`LandMark`,app.`Place`, ");
                        sbsql.Append(" app.`District`,app.`Pincode`,app.`Occupation`,app.`Relation`, ");
                        sbsql.Append(" app.`RelationName`,app.`AdharCardNo`,app.`countryID`,app.`districtID`,app.`cityID`,app.`talukaID`,app.`State`,app.`StateID`, ");
                        sbsql.Append(" app.`AppointmnetType`, ");
                        sbsql.Append(" app.`PlaceOfBirth`,IF(IFNULL(app.`IsInternational`,'')='',1,app.`IsInternational`) AS IsInternational,app.`OverSeaNumber`,app.`EthenicGroup`, ");
                        sbsql.Append(" app.`IsTranslatorRequired`,app.`FacialStatus`,app.`Race`,app.`Employement`,app.`MonthlyIncome`,app.`ParmanentAddress`,app.`IdentificationMarkSecond`, ");
                        sbsql.Append(" app.`IdentificationMark`,app.`LanguageSpoken`,app.`EmergencyRelationOf`,app.`EmergencyRelationShip`,app.`EmergencyPhoneNo`,app.`Phone_STDCODE`, ");
                        sbsql.Append(" app.ResidentialNumber,app.ResidentialNumber_STDCODE,app.`EmergencyFirstName`,app.`EmergencySecondName`,app.`InternationalCountryID`,app.`InternationalCountry`,app.`InternationalNumber`,app.`Phone`,app.`EmergencyAddress`  ");
                        sbsql.Append(" FROM appointment app  ");
                        sbsql.Append(" WHERE app.`App_ID`=" + App_ID + " ");


                        DataTable dataPM = StockReports.GetDataTable(sbsql.ToString());

                        if (dataPM.Rows.Count > 0)
                        {
                            decimal rate = 0;
                            string appItemID = "0";
                            int rateListId = 0;
                            int ReferenceCodeOPD = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT pnl.`ReferenceCodeOPD` FROM `f_panel_master` pnl WHERE pnl.`PanelID`=" + Util.GetInt(dataPM.Rows[0]["PanelID"].ToString()) + ""));
                            DataTable dtAppRate = AllLoadData_OPD.GetRate(refferdoctor, Util.GetString(Resources.Resource.FirstVisitSubCategoryID), ReferenceCodeOPD, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()));
                            if (dtAppRate != null && dtAppRate.Rows.Count > 0)
                            {
                                rate = Util.GetDecimal(dtAppRate.Rows[0]["Rate"].ToString());
                                appItemID = dtAppRate.Rows[0]["ItemID"].ToString();
                                rateListId = Util.GetInt(dtAppRate.Rows[0]["ID"]);
                            }

                            appointment ObjApp = new appointment(tnx);
                            ObjApp.Title = dataPM.Rows[0]["Title"].ToString();
                            ObjApp.PfirstName = dataPM.Rows[0]["PFirstName"].ToString();
                            ObjApp.plastName = dataPM.Rows[0]["PLastName"].ToString();
                            ObjApp.Pname = dataPM.Rows[0]["PName"].ToString();
                            ObjApp.ContactNo = dataPM.Rows[0]["ContactNo"].ToString();
                            ObjApp.DOB = Util.GetDateTime(dataPM.Rows[0]["DOB"]);
                            ObjApp.Age = Util.GetString(dataPM.Rows[0]["Age"]);
                            ObjApp.Email = dataPM.Rows[0]["Email"].ToString();
                            ObjApp.TypeOfApp = "3";//Phone
                            ObjApp.PatientType = dataPM.Rows[0]["PatientType"].ToString();
                            ObjApp.Nationality = dataPM.Rows[0]["Nationality"].ToString();
                            ObjApp.Sex = dataPM.Rows[0]["Sex"].ToString();
                            ObjApp.Date = Util.GetDateTime(Util.GetDateTime(appointmentDate).ToString("yyyy-MM-dd"));
                            ObjApp.DoctorID = refferdoctor;
                            ObjApp.Time = Util.GetDateTime(appointmentTime.Split('-')[0]);
                            ObjApp.EndTime = Util.GetDateTime(appointmentTime.Split('-')[1]);
                            ObjApp.EntryUserID = HttpContext.Current.Session["ID"].ToString();
                            ObjApp.Amount = rate;
                            ObjApp.PanelID = Util.GetInt(dataPM.Rows[0]["PanelID"]);
                            ObjApp.ItemID = appItemID;
                            ObjApp.RateListID =rateListId;
                            ObjApp.SubCategoryID = Resources.Resource.FirstVisitSubCategoryID;
                            if (patientID != "")
                            {
                                ObjApp.PatientID = patientID;
                                ObjApp.isNewPatient = 0;
                                ObjApp.VisitType = "Old Patient";
                            }
                            else
                            {
                                ObjApp.isNewPatient = 1;
                                ObjApp.VisitType = "New Patient";
                            }
                            ObjApp.IpAddress = All_LoadData.IpAddress();
                            ObjApp.AppNo = Util.GetInt(AppNo);
                            ObjApp.hashCode = Util.getHash();
                            ObjApp.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();

                            ObjApp.PinCode = dataPM.Rows[0]["PinCode"].ToString();
                            ObjApp.Occupation = dataPM.Rows[0]["Occupation"].ToString();
                            ObjApp.MaritalStatus = dataPM.Rows[0]["MaritalStatus"].ToString();
                            ObjApp.Relation = dataPM.Rows[0]["Relation"].ToString();
                            ObjApp.RelationName = dataPM.Rows[0]["RelationName"].ToString();
                            ObjApp.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            ObjApp.AdharCardNo = dataPM.Rows[0]["AdharCardNo"].ToString();
                            ObjApp.LandMark = dataPM.Rows[0]["LandMark"].ToString();
                            ObjApp.Place = dataPM.Rows[0]["Place"].ToString();

                            ObjApp.Taluka = dataPM.Rows[0]["Taluka"].ToString();
                            ObjApp.TalukaID = Util.GetInt(dataPM.Rows[0]["TalukaID"]);
                            ObjApp.City = dataPM.Rows[0]["City"].ToString();
                            ObjApp.CityID = Util.GetInt(dataPM.Rows[0]["CityID"]);
                            ObjApp.District = dataPM.Rows[0]["District"].ToString();
                            ObjApp.DistrictID = Util.GetInt(dataPM.Rows[0]["DistrictID"]);
                            ObjApp.State = dataPM.Rows[0]["State"].ToString();
                            ObjApp.StateID = Util.GetInt(dataPM.Rows[0]["StateID"]);
                            ObjApp.CountryID = Util.GetInt(dataPM.Rows[0]["CountryID"]);
                            ObjApp.IsConform = 0;
                            ObjApp.PlaceOfBirth = dataPM.Rows[0]["PlaceOfBirth"].ToString();
                            ObjApp.IdentificationMark = dataPM.Rows[0]["IdentificationMark"].ToString();
                            ObjApp.IsInternational = dataPM.Rows[0]["IsInternational"].ToString();
                            ObjApp.Phone = dataPM.Rows[0]["Phone"].ToString();
                            ObjApp.LedgerTransactionNo = "0";
                            if (visitDetail1.Count > 0)
                            {
                                ObjApp.NextSubcategoryID = visitDetail1[0].nextSubcategoryID.ToString();
                                ObjApp.DocValidityPeriod = Util.GetInt(visitDetail1[0].docValidityPeriod.ToString());
                                ObjApp.nextVisitDateMax = Util.GetDateTime(visitDetail1[0].nextVisitDateMax.ToString());
                                ObjApp.nextVisitDateMin = Util.GetDateTime(visitDetail1[0].nextVisitDateMin.ToString());
                                ObjApp.lastVisitDateMax = Util.GetDateTime(visitDetail1[0].lastVisitDateMax.ToString());
                            }
                            string AppID = ObjApp.Insert();


                            if (string.IsNullOrEmpty(AppID))
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In AppointMent" });

                            }
                        }
                    }
                    //**************************
                }
            }
            #endregion End Referral Consultation

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, App_ID = App_ID });
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




    public static string GetDoctor(string userID, string transactionID)
    {
        if (Convert.ToString(HttpContext.Current.Session["RoleID"]).ToUpper() == "52" || Convert.ToString(HttpContext.Current.Session["RoleID"]).ToUpper() == "323")
        {
            string str = "select DoctorID from doctor_employee where EmployeeID='" + userID + "'";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                return Util.GetString(dt.Rows[0][0]);
            }
            else
            {
                string DocID = StockReports.ExecuteScalar("Select DoctorID from Patient_medical_history where TransactionID='" + transactionID + "'");
                return DocID;
            }
        }
        else
        {
            return string.Empty;
        }
    }


    [WebMethod(EnableSession = true)]
    public string GetPrescription(string transactionID, string appointmentID, int IsIPDData)
    {
       
        ExcuteCMD excuteCMD = new ExcuteCMD();
        if (IsIPDData != 2)
        {
            DataTable dtInvestigation = StockReports.GetDataTable("SELECT DATE_FORMAT(pt.`PrescribeDate`,'%d-%b-%Y') AS prescriptionDate, pt.Test_ID itemID,pt.Name `name`,pt.Outsource `isOutSource`,pt.Quantity `quantity`,pt.IsUrgent,pt.IsIssue,pt.Remarks `remarks`,pt.IsPackage FROM patient_test pt WHERE pt.ConfigID=3 and pt.IsActive=1 and pt.IsEmergencyData=0 AND pt.TransactionID='" + transactionID + "' AND pt.App_ID='" + appointmentID + "' and pt.IsIPDData=" + IsIPDData + " ");
            DataTable dtProcedures = StockReports.GetDataTable("SELECT DATE_FORMAT(pt.`PrescribeDate`,'%d-%b-%Y') AS prescriptionDate ,pt.Test_ID itemID,pt.Name `name`,pt.Outsource,pt.Quantity `quantity`,pt.IsUrgent,pt.IsIssue,pt.Remarks `remarks` FROM patient_test pt WHERE pt.ConfigID=25 AND pt.IsActive=1 and pt.IsEmergencyData=0 and  pt.TransactionID='" + transactionID + "' and pt.App_ID='" + appointmentID + "' and pt.IsIPDData=" + IsIPDData + " ");
            DataTable dtMedicines = StockReports.GetDataTable("SELECT ifnull(med.RefealVal,'')RefealVal,ifnull(med.Unit,'')Unit,ifnull( med.IntervalId,'')IntervalId,ifnull(med.IntervalName,'')IntervalName,ifnull(med.DurationName,'')DurationName,ifnull(med.DurationVal,'')DurationVal,ifnull(med.TimetoGive,'')TimetoGive,med.MedicineName `name`, med.Medicine_ID `itemID`, med.NoOfDays `duration`, med.NoTimesDay `times`, med.Remarks `remarks`, med.OrderQuantity `quantity`, med.Dose `dose`, med.Meal `meal`, med.Route `route`, med.IsIssued,IFNULL((SELECT IFNULL((get_New_PriceByRange(st.CentreID,st.SubcategoryID,st.unitPrice)*med.OrderQuantity),0)MRP FROM f_stock st WHERE st.ItemID=med.Medicine_ID AND st.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND (st.InitialCount-st.ReleasedCount)>0 ORDER BY id DESC LIMIT 1),0)MRP FROM patient_medicine med WHERE med.TransactionID='" + transactionID + "' and med.IsEmergencyData=0 and med.IsIPDData=" + IsIPDData + " AND med.IsActive=1  and med.App_ID='" + appointmentID + "'");
            DataTable dtCpoeExamination = StockReports.GetDataTable("SELECT ce.ClinicalExaminiation,ce.MainComplaint,ce.Medications,ce.Allergies,ce.ProgressionComplaint FROM cpoe_hpexam ce WHERE ce.TransactionID= '" + transactionID + "' and App_ID='" + appointmentID + "' and IsIPDData=" + IsIPDData + "  ");
            DataTable dtProvisional = StockReports.GetDataTable("SELECT cp.ProvisionalDiagnosis FROM cpoe_PatientDiagnosis cp WHERE TransactionID='" + transactionID + "' and App_ID='" + appointmentID + "'  and IsIPDData=" + IsIPDData + "  ");
            string doctorNotes = StockReports.ExecuteScalar("SELECT cc.CarePlan  FROM Cpoe_careplan cc WHERE  cc.TransactionID='" + transactionID + "' AND cc.IsActive=1  and App_ID='" + appointmentID + "' and IsIPDData=" + IsIPDData + " ");
            string doctorAdvice = StockReports.ExecuteScalar("SELECT cc.doctorAdvice  FROM cpoe_doctorAdvice cc WHERE  cc.TransactionID='" + transactionID + "' AND cc.IsActive=1  and App_ID='" + appointmentID + "' and IsIPDData=" + IsIPDData + " ");
            string confidentialData = StockReports.ExecuteScalar("SELECT cc.confidentialdata  FROM cpoe_confidentialdata cc WHERE  cc.TransactionID='" + transactionID + "' AND cc.IsActive=1  and App_ID='" + appointmentID + "' and IsIPDData=" + IsIPDData + " ");
            string vaccinationStatus = StockReports.ExecuteScalar("SELECT cc.VaccinationStatus  FROM cpoe_VaccinationStatus cc WHERE  cc.TransactionID='" + transactionID + "' AND cc.IsActive=1  and App_ID='" + appointmentID + "' and IsIPDData=" + IsIPDData + " ");
            DataTable dtPatientDetails = new DataTable();
            int roleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
            if (IsIPDData == 1 && transactionID != "")
            {

            StringBuilder sqlCMD = new StringBuilder();
            if (string.IsNullOrEmpty(appointmentID))
            {

                string doctorID = GetDoctor(HttpContext.Current.Session["ID"].ToString(), transactionID);

                sqlCMD = new StringBuilder(" SELECT cm.ReportFooterURL,dm.DoctorID,ifnull(dm.Specialization,'') as Specialization, CONCAT(pm.Title, '', pm.PName) `PatientName`, pm.PatientID, CONCAT(dm.Title, ' ', dm.Name) `DoctorName`, CONCAT(pm.Age, '/', pm.Gender) `Gender`, pnl.Company_Name, DATE_FORMAT(cc.CreatedOn, '%d-%b-%Y') appointmentDate, '' BillNo, 0 Adjustment, 'IPD' `VisitType`, '' ValidTo, pm.Mobile  ");
                sqlCMD.Append(" FROM  patient_medical_history pmh ");
                sqlCMD.Append(" INNER JOIN `patient_medical_history` adj ON adj.`TransactionID`=pmh.`TransactionID` AND adj.`TYPE`='IPD' ");
                sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID  ");
                sqlCMD.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID  ");
                sqlCMD.Append(" LEFT JOIN ipd_prescriptionvisit cc ON cc.ID='' ");
                sqlCMD.Append(" LEFT JOIN doctor_master dm ON dm.DoctorID ='" + doctorID + "'   ");
                sqlCMD.Append(" INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
                sqlCMD.Append(" WHERE pmh.TransactionID =@transactionID  ");

            }
            else
            {
                sqlCMD = new StringBuilder(" SELECT  cm.ReportFooterURL,dm.DoctorID,ifnull(dm.Specialization,'') as Specialization, CONCAT(pm.Title, '', pm.PName) `PatientName`, pm.PatientID, CONCAT(dm.Title, ' ', dm.Name) `DoctorName`,  ");
                sqlCMD.Append(" CONCAT(pm.Age, '/', pm.Gender) `Gender`, pnl.Company_Name, DATE_FORMAT(cc.CreatedOn, '%d-%b-%Y') appointmentDate,  ");
                sqlCMD.Append(" '' BillNo, 0 Adjustment, 'IPD' `VisitType`, '' ValidTo, pm.Mobile  ");
                sqlCMD.Append(" FROM patient_medical_history pmh ");
                sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.`PatientID` ");
                sqlCMD.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID  ");
                sqlCMD.Append(" INNER JOIN ipd_prescriptionvisit cc ON cc.ID=@appointmentID ");
                sqlCMD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID =cc.DoctorID  ");
                sqlCMD.Append(" INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
                sqlCMD.Append(" WHERE pmh.TransactionID = @transactionID  AND pmh.`TYPE`='IPD' ");
            }

            dtPatientDetails = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                transactionID = transactionID,
                appointmentID = appointmentID
            });
        }
        else
        {
            dtPatientDetails = excuteCMD.GetDataTable("SELECT ap.DoctorID,ifnull(dm.Specialization,'') as Specialization, CONCAT(pm.Title,'',pm.PName) `PatientName`,pm.PatientID,CONCAT(dm.Title,' ',dm.Name) `DoctorName`,CONCAT(pm.Age,'/',pm.Gender) `Gender`, pnl.Company_Name,DATE_FORMAT(ap.Date,'%d-%b-%Y') appointmentDate,IFNULL(lt.BillNo,'')BillNo,IFNULL(lt.Adjustment,'')Adjustment,sc.Name `VisitType`,DATE_FORMAT(IF(sc.SubCategoryID='" + Resources.Resource.FollowUpVisitSubCategoryID + "',(SELECT   ADDDATE(a.Date, (SELECT DocValidityPeriod FROM  f_subcategorymaster WHERE SubCategoryID=a.SubCategoryID))  FROM  appointment a WHERE a.PatientID=pm.PatientID AND a.SubCategoryID<>'" + Resources.Resource.FollowUpVisitSubCategoryID + "' order by a.App_ID DESC LIMIT 1),ADDDATE(ap.Date,sc.DocValidityPeriod)),'%d-%b-%Y') ValidTo,pm.Mobile,cm.ReportFooterURL  FROM  appointment ap INNER JOIN patient_master pm ON pm.PatientID =ap.PatientID LEFT JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=ap.LedgerTnxNo INNER JOIN doctor_master dm  ON dm.DoctorID=ap.DoctorID  INNER JOIN f_panel_master pnl  ON pnl.PanelID=ap.PanelID INNER JOIN center_master cm ON cm.CentreID=ap.CentreID INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=ap.SubCategoryID WHERE ap.App_ID=@appointmentID", CommandType.Text, new
            {
                appointmentID = appointmentID
            });
        }

            DataTable dtPatientMolecularAllergies = StockReports.GetDataTable("SELECT s.MolecularName,s.MolecularID FROM cpoe_molecullarallergies s  WHERE s.TransactionID='" + transactionID + "' and App_ID='" + appointmentID + "' and IsIPDData=" + IsIPDData + "  ");
            DataTable dtReferral = StockReports.GetDataTable("SELECT " + HttpContext.Current.Session["CentreID"].ToString() + " AS centreID,DATE_FORMAT(CURDATE(),'%d-%b-%Y') AS AppDate,Date_Format(if(ifnull(NewAppDate,'')='0001-01-01','',ifnull(NewAppDate,'')),'%d-%b-%Y') AS NewAppDate,NewAppTime, doctorType, Impression, Remarks,DoctorID,ReferralType,ConsultationType FROM cpoe_referralConsultation WHERE TransactionID='" + transactionID + "' AND IsActive=1  and AppID='" + appointmentID + "' and IsIPDData=" + IsIPDData + "   ");
            if (dtReferral.Rows.Count == 0)
                dtReferral = StockReports.GetDataTable("SELECT " + HttpContext.Current.Session["CentreID"].ToString() + " AS centreID,DATE_FORMAT(CURDATE(),'%d-%b-%Y') AS AppDate,'' NewAppDate,'' NewAppTime,'' doctorType,'' Impression,'' Remarks,'' DoctorID,'' ReferralType,'' ConsultationType  ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { investigationList = dtInvestigation, proceduresList = dtProcedures, medicinesList = dtMedicines, doctorNotes = doctorNotes, CPOEExamination = dtCpoeExamination, vaccinationStatus = vaccinationStatus, patientDetails = dtPatientDetails, molecularAllergies = dtPatientMolecularAllergies, ProvisionalDiagnosis = dtProvisional, doctorAdvice = doctorAdvice, ConfidentialData = confidentialData, ReferralConsultation = dtReferral });

        }

        else
        {
            //ExcuteCMD excuteCMD = new ExcuteCMD();
            int roleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());

            string userID = HttpContext.Current.Session["ID"].ToString();
            string doctorID = GetDoctor(userID, transactionID);

            string patientID = StockReports.ExecuteScalar("SELECT pmh.PatientID FROM patient_medical_history pmh WHERE TransactionID='" + transactionID + "'");

            var data = new
            {
                transactionID = transactionID,
                appointmentID = appointmentID,
                doctorID = doctorID,
                patientID = patientID
            };


            StringBuilder sqlCMD = new StringBuilder(" SELECT CONCAT(pt.Test_ID,'_',pt.PatientTest_ID) itemID, pt.Name `name`, pt.Outsource `isOutSource`, pt.Quantity `quantity`, pt.IsUrgent, pt.IsIssue, pt.Remarks `remarks`, pt.IsPackage,pt.PatientTest_ID FROM patient_test pt ");
            sqlCMD.Append(" WHERE pt.ConfigID = 3 AND pt.IsActive = 1 AND pt.TransactionID =@transactionID AND pt.App_ID=@appointmentID AND pt.IsEmergencyData=1 ");

            DataTable dtInvestigation = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, data);


            sqlCMD = new StringBuilder("SELECT CONCAT(pt.Test_ID,'_',pt.PatientTest_ID) itemID, pt.Name `name`, pt.Outsource, pt.Quantity `quantity`, pt.IsUrgent, pt.IsIssue, pt.Remarks `remarks`,pt.PatientTest_ID FROM patient_test pt ");
            sqlCMD.Append(" WHERE pt.ConfigID = 25  AND pt.IsActive = 1 AND pt.TransactionID = @transactionID AND pt.App_ID=@appointmentID AND pt.IsEmergencyData=1 ");

            DataTable dtProcedures = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, data);


            sqlCMD = new StringBuilder("SELECT med.MedicineName `name`, med.Medicine_ID `itemID`, med.NoOfDays `duration`, med.NoTimesDay `times`, med.Remarks `remarks`, med.OrderQuantity `quantity`, med.Dose `dose`, med.Meal `meal`, med.Route `route`, med.IsIssued,ifnull(med.IndentNo,0)IndentNo FROM patient_medicine med ");
            sqlCMD.Append(" WHERE med.TransactionID =@transactionID AND med.App_ID=@appointmentID  AND med.IsEmergencyData=1 AND med.IsActive = 1 ");

            string s = excuteCMD.GetRowQuery(sqlCMD.ToString(), data);
            DataTable dtMedicines = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, data);


            sqlCMD = new StringBuilder("SELECT ce.ClinicalExaminiation, ce.MainComplaint, ce.Medications, ce.Allergies, ce.ProgressionComplaint FROM emr_hpexam ce ");
            sqlCMD.Append(" WHERE ce.TransactionID =@transactionID AND ce.App_ID=@appointmentID ");

            DataTable dtCpoeExamination = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, data);


            sqlCMD = new StringBuilder("SELECT cp.ProvisionalDiagnosis FROM emr_PatientDiagnosis cp ");
            sqlCMD.Append(" WHERE TransactionID =@transactionID AND cp.App_ID=@appointmentID ");

            DataTable dtProvisional = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, data);


            sqlCMD = new StringBuilder("SELECT cc.CarePlan  FROM emr_careplan cc ");
            sqlCMD.Append(" WHERE  cc.TransactionID=@transactionID AND cc.App_ID=@appointmentID AND cc.IsActive=1 ");

            string doctorNotes = Util.GetString(excuteCMD.ExecuteScalar(sqlCMD.ToString(), data));


            sqlCMD = new StringBuilder("SELECT cc.VaccinationStatus  FROM emr_VaccinationStatus cc ");
            sqlCMD.Append(" WHERE  cc.TransactionID=@transactionID AND cc.App_ID=@appointmentID AND cc.IsActive=1 ");

            string vaccinationStatus = Util.GetString(excuteCMD.ExecuteScalar(sqlCMD.ToString(), data));

            if (string.IsNullOrEmpty(appointmentID))
            {
                // sqlCMD = new StringBuilder(" SELECT CONCAT(pm.Title, '', pm.PName) `PatientName`, pm.PatientID, CONCAT(dm.Title, ' ', dm.Name) `DoctorName`, CONCAT(DATE_FORMAT(pm.DOB,'%d-%b-%Y'),'/',pm.Age, '/', pm.Gender) `Gender`, pnl.Company_Name, DATE_FORMAT(NOW(), '%d-%b-%Y') appointmentDate, '' BillNo, 0 Adjustment, 'Emergency' `VisitType`, '' ValidTo, pm.Mobile FROM Emergency_Patient_Details ap INNER JOIN patient_master pm ON pm.PatientID = ap.PatientId INNER JOIN  patient_medical_history pmh ON pmh.TransactionID = ap.TransactionId  ");
                // sqlCMD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID =@doctorID ");
                // sqlCMD.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
                // if (!transactionID.Contains("ISHHI"))
                //     sqlCMD.Append(" WHERE ap.TransactionId = @transactionID ");
                // else
                //    sqlCMD.Append(" WHERE ap.PatientId = @patientID ");


                sqlCMD = new StringBuilder(" SELECT cm.ReportFooterURL,CONCAT(pm.Title, '', pm.PName) `PatientName`, pm.PatientID, CONCAT(dm.Title, ' ', dm.Name) `DoctorName`, CONCAT(DATE_FORMAT(pm.DOB,'%d-%b-%Y'),'/',pm.Age, '/', pm.Gender) `Gender`, pnl.Company_Name, DATE_FORMAT(cc.CreatedOn, '%d-%b-%Y') appointmentDate, '' BillNo, 0 Adjustment, 'Emergency' `VisitType`, '' ValidTo, pm.Mobile  ");
                sqlCMD.Append(" FROM  patient_medical_history pmh ");
                sqlCMD.Append(" LEFT JOIN Emergency_Patient_Details ap ON ap.TransactionId=pmh.TransactionID ");
                sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID  ");
                sqlCMD.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID  ");
                sqlCMD.Append(" LEFT JOIN emergency_prescriptionvisit cc ON cc.ID='' ");
                sqlCMD.Append(" LEFT JOIN doctor_master dm ON dm.DoctorID =cc.DoctorID   ");
                sqlCMD.Append(" INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
                if (!transactionID.Contains("ISHHI"))
                    sqlCMD.Append(" WHERE pmh.TransactionID =@transactionID  ");
                else
                    sqlCMD.Append(" WHERE pmh.PatientID=@patientID  ");

            }
            else
            {
                sqlCMD = new StringBuilder(" SELECT cm.ReportFooterURL,CONCAT(pm.Title, '', pm.PName) `PatientName`, pm.PatientID, CONCAT(dm.Title, ' ', dm.Name) `DoctorName`, CONCAT(DATE_FORMAT(pm.DOB,'%d-%b-%Y'),'/',pm.Age, '/', pm.Gender) `Gender`, pnl.Company_Name, DATE_FORMAT(cc.CreatedOn, '%d-%b-%Y') appointmentDate, '' BillNo, 0 Adjustment, 'Emergency' `VisitType`, '' ValidTo, pm.Mobile FROM Emergency_Patient_Details ap INNER JOIN patient_master pm ON pm.PatientID = ap.PatientId INNER JOIN  patient_medical_history pmh ON pmh.TransactionID = ap.TransactionId  ");

                sqlCMD.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
                sqlCMD.Append(" INNER JOIN emergency_prescriptionvisit cc ON cc.ID=@appointmentID ");
                sqlCMD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID =cc.DoctorID ");
                sqlCMD.Append(" INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
                sqlCMD.Append(" WHERE ap.TransactionId = @transactionID ");
            }

            DataTable dtPatientDetails = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, data);

            DataTable dtPatientMolecularAllergies = new DataTable();
            DataTable doctorAdvice = new DataTable();
            DataTable confidentialData = new DataTable();
            DataTable dtReferral = new DataTable();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { investigationList = dtInvestigation, proceduresList = dtProcedures, medicinesList = dtMedicines, doctorNotes = doctorNotes, CPOEExamination = dtCpoeExamination, vaccinationStatus = vaccinationStatus, patientDetails = dtPatientDetails, molecularAllergies = dtPatientMolecularAllergies, ProvisionalDiagnosis = dtProvisional,doctorAdvice = doctorAdvice, ConfidentialData = confidentialData, ReferralConsultation = dtReferral }); 
            //return Newtonsoft.Json.JsonConvert.SerializeObject(new { investigationList = dtInvestigation, proceduresList = dtProcedures, medicinesList = dtMedicines, doctorNotes = doctorNotes, CPOEExamination = dtCpoeExamination, vaccinationStatus = vaccinationStatus, patientDetails = dtPatientDetails, molecularAllergies = dtPatientMolecularAllergies, ProvisionalDiagnosis = dtProvisional, doctorAdvice = doctorAdvice, ConfidentialData = confidentialData, ReferralConsultation = dtReferral });
        }
    }


    [WebMethod]
    public string GetFavoriteTemplates(string doctorID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(GetFavorite(doctorID));
    }

    [WebMethod]
    public string GetHidePrescriptionData(string appointmentId, int IsIPDData)
    {
       // string HidePrescription = StockReports.ExecuteScalar(" SELECT GROUP_CONCAT(cpm.`divControlID` SEPARATOR ' ,#') as divControlID FROM cpoe_prescription_master cpm  LEFT JOIN cpoe_PrescriptionHeaderShow cps ON cpm.`ID`=cps.`cpoe_prescription_master_ID` AND cps.IsActive=1 AND cps.`App_ID`='" + appointmentId + "' and cps.IsIPDData=" + IsIPDData + " WHERE cps.id IS NULL AND IFNULL(cpm.`divControlID`,'')<>'' ");
        string HidePrescription = StockReports.ExecuteScalar(" SELECT GROUP_CONCAT(IF(cpm.`ID`=2,CONCAT(cpm.`divControlID`,' ,.lblDivInvestigationPreview'),IF(cpm.`ID`=3,CONCAT(cpm.`divControlID`,' ,.lblDivProcedurePreview'),cpm.`divControlID`)) SEPARATOR ' ,#') as divControlID FROM cpoe_prescription_master cpm  LEFT JOIN cpoe_PrescriptionHeaderShow cps ON cpm.`ID`=cps.`cpoe_prescription_master_ID` AND cps.IsActive=1 AND cps.`App_ID`='" + appointmentId + "' and cps.IsIPDData=" + IsIPDData + " WHERE cps.id IS NULL AND IFNULL(cpm.`divControlID`,'')<>'' ");
       
	   if (HidePrescription.Length > 1)
        {
            if (IsIPDData != 2)
            {
                 HidePrescription = "#" + HidePrescription + "";
                return HidePrescription;
				 // HidePrescription = "'#" + HidePrescription + "'";
                //return Newtonsoft.Json.JsonConvert.SerializeObject(HidePrescription);
            }
            else {
                return string.Empty;
            }
        }
        else
            return string.Empty;
    }
    [WebMethod(EnableSession = true)]
    public string GetShowPrescriptionData(string appointmentId, int IsIPDData)
    {
        string roleID = HttpContext.Current.Session["RoleID"].ToString();
        string str = "select DoctorID from doctor_employee where EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "'";
        string doctorID = StockReports.ExecuteScalar(str);
        // doctorID = "LSHHI1";
        DataTable ShowPrescription = StockReports.GetDataTable(" SELECT cpoe_prescription_master_ID as ID FROM cpoe_PrescriptionHeaderShow cps where cps.IsActive=1 AND cps.`App_ID`='" + appointmentId + "' and IsIPDData=" + IsIPDData + " ");
        if (ShowPrescription.Rows.Count == 0)
        {
            str = " select distinct cpoe_prescription_master_ID as ID from cpoe_prescription_master_setting s WHERE s.`DoctorID`='" + doctorID + "' AND s.`RoleID`='" + roleID + "' AND s.`IsActive`=1 AND s.`IsDefaultCheck`=1 and s.IsDefault=0 ";
            ShowPrescription = StockReports.GetDataTable(str);
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(ShowPrescription);
    }



    [WebMethod]
    public string GetVitalDetails(string transactionID, string appID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT IF(IFNULL(ipo.T,'')='',0,ipo.T) AS Temp, ipo.P AS Pulse, ipo.SPO2, ipo.BP, ipo.r,ipo.HT,ipo.WT,ROUND(ipo.BMI,2)BMI,ROUND(ipo.BSA,2)BSA,ipo.Remarks FROM cpoe_vital ipo WHERE ipo.TransactionID = '" + transactionID + "' GROUP BY ipo.ID ORDER BY ipo.EntryDate DESC LIMIT 1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string GetPreviousVisit(string transactionID, string patientID, string AppID, int IsIPDData)
    {
        var sqlCmd = new System.Text.StringBuilder();
        // var sqlCmd = new System.Text.StringBuilder("SELECT DATE_FORMAT(DateOfVisit,'%d-%b-%Y')DateVisit,CONCAT(dm.Title,' ',dm.Name)DName,pmh.DoctorID,lt.TransactionID,lt.LedgerTransactionNo, IF(lt.TransactionID='" + transactionID + "',1,0) CurrentVisit,(SELECT f.Company_Name FROM f_panel_master f WHERE f.PanelID= pmh.PanelID) PanelName FROM patient_medical_history pmh INNER JOIN Doctor_master dm ON pmh.DoctorID=dm.DoctorID INNER JOIN f_ledgertransaction lt ON lt.`TransactionID`=pmh.`TransactionID`  AND lt.`TypeOfTnx`='OPD-APPOINTMENT' ");
        // sqlCmd.Append("  WHERE  pmh.PatientID='" + patientID + "' ORDER BY CurrentVisit DESC, DateOfVisit  DESC");
        //pmh.TransactionID !='" + transactionID + "' AND
        //  int roleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
        //if (roleID == 293)
        //    sqlCmd.Append("SELECT DATE_FORMAT(lt.Date, '%d-%b-%Y') DateVisit, CONCAT(dm.Title, ' ', dm.Name) DName, ltd.DoctorID, lt.TransactionID, lt.LedgerTransactionNo, IF( lt.TransactionID = '" + transactionID + "', 1,0) CurrentVisit, (SELECT f.Company_Name FROM f_panel_master f WHERE f.PanelID = lt.PanelID) PanelName FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=lt.TransactionID AND LTD.ItemID='" + Resources.Resource.DialysisRoomItemID + "' INNER JOIN Doctor_master dm ON dm.DoctorID = ltd.DoctorID WHERE lt.PatientID = '" + patientID + "' ORDER BY CurrentVisit DESC, lt.Date DESC ");
        //else if (roleID == 292)
        //    sqlCmd.Append("SELECT DATE_FORMAT(lt.Date, '%d-%b-%Y') DateVisit, CONCAT(dm.Title, ' ', dm.Name) DName, ltd.DoctorID, lt.TransactionID, lt.LedgerTransactionNo, IF( lt.TransactionID = '" + transactionID + "', 1,0) CurrentVisit, (SELECT f.Company_Name FROM f_panel_master f WHERE f.PanelID = lt.PanelID) PanelName FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=lt.TransactionID AND LTD.ItemID='" + Resources.Resource.ObservationItemID + "' INNER JOIN Doctor_master dm ON dm.DoctorID = ltd.DoctorID WHERE lt.PatientID = '" + patientID + "' ORDER BY CurrentVisit DESC, lt.Date DESC ");
        //else
        //  sqlCmd.Append("SELECT DATE_FORMAT(DateOfVisit,'%d-%b-%Y')DateVisit,CONCAT(dm.Title,' ',dm.Name)DName,pmh.DoctorID,lt.TransactionID,lt.LedgerTransactionNo, IF(lt.TransactionID='" + transactionID + "',1,0) CurrentVisit,(SELECT f.Company_Name FROM f_panel_master f WHERE f.PanelID= pmh.PanelID) PanelName FROM patient_medical_history pmh INNER JOIN Doctor_master dm ON pmh.DoctorID=dm.DoctorID INNER JOIN f_ledgertransaction lt ON lt.`TransactionID`=pmh.`TransactionID`  AND lt.`TypeOfTnx`='OPD-APPOINTMENT'   WHERE  pmh.PatientID='" + patientID + "' ORDER BY CurrentVisit DESC, DateOfVisit  DESC");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dtopd = new DataTable();

        StringBuilder sb = new StringBuilder();

        if (IsIPDData == 1)
        {
            sb.Append(" SELECT  pmh.ID AS App_ID,pmh.CreatedOn AS VisitDate,DATE_FORMAT(pmh.CreatedOn,'%d-%b-%Y') DateVisit, CONCAT(dm.Title, ' ', dm.Name) DName, pmh.DoctorID DoctorID, ");
            sb.Append(" pmh.TransactionID TransactionID,'' LedgerTransactionNo,  ");
            sb.Append(" IF(" + IsIPDData + "=1,IF(pmh.ID=@App_ID,1,0),0) CurrentVisit, ");
            sb.Append(" (SELECT f.Company_Name FROM f_panel_master f WHERE f.PanelID= adj.PanelID) PanelName ,'1' AS Isipd,cm.ReportFooterURL  ");
            sb.Append(" FROM ipd_prescriptionvisit pmh  ");
            sb.Append("  INNER JOIN `patient_medical_history` adj ON adj.`TransactionID`=pmh.`TransactionID` AND adj.`TYPE`='IPD'  ");
            sb.Append(" INNER JOIN Doctor_master dm ON pmh.DoctorID = dm.DoctorID  ");
            sb.Append(" INNER JOIN center_master cm ON cm.CentreID=adj.CentreID ");
            sb.Append(" WHERE adj.PatientID =@patientID  ");
        }
       // sb.Append(" UNION ALL ");
        if (IsIPDData == 0)
        {
            sb.Append(" SELECT app.App_ID,app.Date AS VisitDate, DATE_FORMAT(app.Date,'%d-%b-%Y')DateVisit,CONCAT(dm.Title,' ',dm.Name)DName,DM.DoctorID, ");
            sb.Append(" app.TransactionID,app.LedgerTnxNo AS LedgerTransactionNo,  ");
            sb.Append(" IF(" + IsIPDData + "=0,IF(app.App_ID=@App_ID,1,0),0) CurrentVisit,  ");
            sb.Append(" (SELECT f.Company_Name FROM f_panel_master f WHERE f.PanelID= app.PanelID) PanelName,'0' AS Isipd,cm.ReportFooterURL  ");
            sb.Append(" FROM appointment app  ");
            sb.Append(" INNER JOIN Doctor_master dm ON dm.DoctorID=app.DoctorID  ");
            sb.Append(" INNER JOIN center_master cm ON cm.CentreID=app.CentreID ");
            sb.Append(" WHERE app.IsCancel=0 AND app.PatientID=@patientID AND app.TransactionID<>0 ");
        }
        //sb.Append(" UNION ALL ");
        
        //sb.Append(" SELECT pmh.ID AS App_ID,pmh.CreatedBy AS VisitDate ,  DATE_FORMAT(pmh.CreatedOn,'%d-%b-%Y') DateVisit, ");
        //sb.Append("CONCAT(dm.Title, ' ', dm.Name) DName, pmh.DoctorID DoctorID, pmh.TransactionID TransactionID,'' LedgerTransactionNo, ");
        //sb.Append(" IF(" + IsIPDData + "=2,IF(pmh.ID=@App_ID,1,0),0) CurrentVisit,'' AS PanelName ,'2' AS Isipd,cm.ReportFooterURL ");
        //sb.Append("FROM emergency_prescriptionvisit pmh ");
        //sb.Append("INNER JOIN Doctor_master dm ON pmh.DoctorID = dm.DoctorID ");
        //sb.Append("INNER JOIN emergency_patient_details emr ON emr.TransactionId=pmh.TransactionID ");
        //sb.Append("INNER JOIN patient_medical_history pmh1 ON pmh1.TransactionID=emr.TransactionID ");
        //sb.Append(" INNER JOIN center_master cm ON cm.CentreID=pmh1.CentreID ");
        //sb.Append("WHERE emr.PatientId=@patientID ");

        sb.Append(" ORDER BY CurrentVisit DESC, VisitDate  DESC ");
        dtopd = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            App_ID = AppID,
            patientID = patientID
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtopd);



    }

    [WebMethod]
    public string SaveTemplate(TemplateMaster data)
    {
        try
        {

            var tableName = GetFavoriteTableNameByNo(data.templateFor);


            ExcuteCMD excuteCMD = new ExcuteCMD();
            // var isExits = excuteCMD.ExecuteScalar("SELECT COUNT(*) FROM " + tableName + " ce  WHERE ce.TempName=@templateName", new
            // {
            //     templateName = data.templateName
            // });
            //if(Util.GetInt(isExits)>0)
            //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Template Already Exits !" });



            string sqlQuery = "INSERT INTO " + tableName + "(TempName,ValueField,DoctorID) VALUES(@TempName,@ValueField,@DoctorID)";
            excuteCMD.DML(sqlQuery, CommandType.Text, new
            {
                TempName = data.templateName,
                ValueField = data.valueField,
                DoctorID = data.doctorID
            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }


    [WebMethod]
    public string UpdateTemplate(TemplateMaster data)
    {
        try
        {
            var tableName = GetFavoriteTableNameByNo(data.templateFor);

            ExcuteCMD excuteCMD = new ExcuteCMD();
            //var isExits = excuteCMD.ExecuteScalar("SELECT COUNT(*) FROM " + tableName + " ce  WHERE ce.id<>@id and  ce.TempName=@templateName", new
            //{
            //    templateName = data.templateName,
            //    id=data.id
            //});
            //if (Util.GetInt(isExits) > 0)
            //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Template Already Exits !" });



            string sqlQuery = "UPDATE " + tableName + " cc  SET  cc.TempName=@TempName,cc.ValueField=@ValueField WHERE cc.ID=@id";
            excuteCMD.DML(sqlQuery, CommandType.Text, new
            {
                TempName = data.templateName,
                ValueField = data.valueField,
                id = data.id
            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
        }
        catch (Exception ex)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }

    [WebMethod]
    public string DeleteTemplate(int templateID, int templateFor)
    {
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();

            if (templateFor == 7)
            {
                excuteCMD.ExecuteScalar("UPDATE medicinesetmaster SET IsActive=0 WHERE id=@id", new
              {
                  id = templateID
              });


            }
            else
            {
                var tableName = GetFavoriteTableNameByNo(templateFor);

                var isExits = excuteCMD.ExecuteScalar("DELETE  FROM  " + tableName + "  WHERE ID=@id", new
                {
                    id = templateID
                });
            }

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Delete Successfully" });

        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }

    //[WebMethod]
    //public string DeleteMedicineTemplate(int templateID)
    //{
    //    try
    //    {
    //        var tableName = GetFavoriteTableNameByNo(templateFor);
    //        ExcuteCMD excuteCMD = new ExcuteCMD();
    //        var isExits = excuteCMD.ExecuteScalar("DELETE  FROM  " + tableName + "  WHERE ID=@id", new
    //        {
    //            id = templateID
    //        });

    //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Delete Successfully" });

    //    }
    //    catch (Exception ex)
    //    {
    //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
    //    }
    //}



    [WebMethod(EnableSession = true)]
    public string SaveMedicineTemplate(TemplateMedicineSet data)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            var entryBy = HttpContext.Current.Session["ID"].ToString();
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var sqlCmd = new StringBuilder();
            string setID = Util.GetString(data.id);
            if (string.IsNullOrEmpty(setID))
            {

                sqlCmd = new StringBuilder("INSERT INTO medicinesetmaster(SetName,EntryBy,Description) VALUE(@SetName,@EntryBy,@Description); SELECT @@identity; ");
                var tsetID = excuteCMD.ExecuteScalar(tnx, sqlCmd.ToString(), CommandType.Text, new
                {
                    SetName = data.templateName,
                    EntryBy = entryBy,
                    Description = string.Empty
                });
                setID = Util.GetString(tsetID);
                sqlCmd = new StringBuilder("INSERT INTO medicinesetmasterdoctorwise(SetID,DoctorID,EntryBy) VALUE(@SetID,@DoctorID,@EntryBy)");
                excuteCMD.ExecuteScalar(tnx, sqlCmd.ToString(), CommandType.Text, new
                {
                    SetID = setID,
                    DoctorID = data.doctorID,
                    EntryBy = entryBy
                });
            }
            else
            {
                excuteCMD.DML("DELETE FROM  medicinesetitemmaster WHERE SetID=@setID", CommandType.Text, new
                {
                    setID = setID
                });
            }

            var medicinePrescriptionMaster = StockReports.GetDataTable("SELECT * FROM medicinePrescriptionMaster").AsEnumerable().Select(i => new { text = Util.GetString(i.Field<string>("Text")).ToLower(), type = Util.GetInt(i.Field<int>("Type")) }).ToList();



            data.medicines.ForEach(i =>
            {
                sqlCmd = new StringBuilder("INSERT INTO medicinesetitemmaster (SetID, ItemID, EntryBy, Quantity, dose, route, meal, times, duration, Typename)");
                sqlCmd.Append("VALUES (@SetID,@ItemID,@EntryBy,@Quantity,@dose,@route,@meal,@times,@duration,@Typename)");
                excuteCMD.ExecuteScalar(tnx, sqlCmd.ToString(), CommandType.Text, new
                {
                    SetID = setID,
                    ItemID = i.ItemID,
                    Quantity = i.Quantity,
                    dose = i.Dose,
                    route = i.Route,
                    meal = i.Meal,
                    times = i.Time,
                    duration = i.Duration,
                    Typename = string.Empty,
                    EntryBy = entryBy
                });

                var isDosesExit = medicinePrescriptionMaster.Where(d => d.type == 1 && d.text == i.Dose.ToLower()).ToList();
                if (isDosesExit.Count < 1)
                {
                    var dose = new { text = i.Dose, type = 1 };
                    excuteCMD.ExecuteScalar(tnx, "INSERT INTO medicinePrescriptionMaster (`Text`,`Type`)VALUES(@text,@type)", CommandType.Text, dose);
                    medicinePrescriptionMaster.Add(dose);
                }

                var isTimesExit = medicinePrescriptionMaster.Where(d => d.type == 2 && d.text == i.Time.ToLower()).ToList();
                if (isTimesExit.Count < 1)
                {
                    var time = new { text = i.Time, type = 2 };
                    excuteCMD.ExecuteScalar(tnx, "INSERT INTO medicinePrescriptionMaster (`Text`,`Type`)VALUES(@text,@type)", CommandType.Text, time);
                    medicinePrescriptionMaster.Add(time);
                }

                var isDaysExit = medicinePrescriptionMaster.Where(d => d.type == 3 && d.text.ToLower() == i.Duration.ToLower()).ToList();

                if (isDaysExit.Count < 1)
                {
                    var days = new { text = i.Duration, type = 3 };
                    excuteCMD.ExecuteScalar(tnx, "INSERT INTO medicinePrescriptionMaster (`Text`,`Type`)VALUES(@text,@type)", CommandType.Text, days);
                    medicinePrescriptionMaster.Add(days);

                }

                var isRouteExit = medicinePrescriptionMaster.Where(d => d.type == 4 && d.text.ToLower() == i.Route.ToLower()).ToList();
                if (isRouteExit.Count < 1)
                {
                    var route = new { text = i.Route, type = 4 };
                    excuteCMD.ExecuteScalar(tnx, "INSERT INTO medicinePrescriptionMaster (`Text`,`Type`)VALUES(@text,@type)", CommandType.Text, route);
                    medicinePrescriptionMaster.Add(route);
                }

            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string AddMedicinePrescriptionDefaultValue(List<SetItem> data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            var SqlCmd = "UPDATE f_itemmaster  SET Dose=@Dose,Route=@Route,Duration=@Duration,Times=@Times WHERE ItemID=@ItemID";
            ExcuteCMD excuteCMD = new ExcuteCMD();
            data.ForEach(i =>
            {
                excuteCMD.DML(tnx, SqlCmd, CommandType.Text, new
                {
                    Dose = i.Dose,
                    Route = i.Route,
                    Duration = i.Duration,
                    Times = i.Time,
                    ItemID = i.ItemID
                });
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }

    [WebMethod]
    public string GetMedicineDoses(int type)
    {
        DataTable dt = StockReports.GetDataTable("SELECT mm.Text,mm.ID FROM medicinePrescriptionMaster mm WHERE mm.Type=" + type);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }






    //public string SearchMedicine() {

    //    System.Text.StringBuilder sb = new System.Text.StringBuilder();

    //        sb.Append("Select ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
    //        sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber,");
    //        sb.Append(" ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");
    //        sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf ");
    //        sb.Append(" ,IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID=sm.SaltID WHERE fis.ItemID=im.ItemID GROUP BY im.ItemID),'') AS Generic ");
    //        sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID ");
    //        sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
    //        sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + deptLedgerNo + "' ");
    //        sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
    //        sb.Append(" AND TRIM(ST.ItemName) LIKE '" + q + "%' ");
    //        sb.Append(" AND st.DeptLedgerNo='" + deptLedgerNo + "' ");
    //        sb.Append("  AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') AND CR.ConfigID = 11 ");
    //        sb.Append("  ORDER BY st.MedExpiryDate LIMIT " + Util.GetString(20) + " ");

    //        sb.Append("Select ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
    //        sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber,");
    //        sb.Append(" ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty ,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");
    //        sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf,fsm.Name AS Generic ");
    //        sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID");
    //        sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
    //        sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=ST.ItemID Inner JOIN f_salt_master ");
    //        sb.Append(" fsm ON fis.saltID = fsm.SaltID AND fsm.IsActive=1 ");
    //        sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + deptLedgerNo + "' ");
    //        sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
    //        sb.Append(" AND TRIM(fsm.Name)  LIKE '" + q + "%' ");
    //        sb.Append(" AND st.DeptLedgerNo='" + deptLedgerNo + "'  AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') AND CR.ConfigID = 11 ");
    //        sb.Append("  ORDER BY st.MedExpiryDate LIMIT " + Util.GetString(20) + " ");


    //}





    public static object GetFavorite(string doctorID)
    {


        int templateNameCharCount = 25;
        DataTable dtClinicalExamination = new DataTable();
        DataTable dtChiefComplaint = new DataTable();
        DataTable dtDoctorsNotes = new DataTable();
        DataTable dtVaccinationStatus = new DataTable();
        DataTable dtMedicines = new DataTable();
        DataTable doctorAdvice = new DataTable();

        if (!string.IsNullOrEmpty(doctorID))
        {

            dtClinicalExamination = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,3 templateFor FROM myfavorite_ClinicalExamination f WHERE f.DoctorID='" + doctorID + "'");
            dtChiefComplaint = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName` ,f.ValueField,f.ID,1 templateFor FROM MyFavorite_ChiefComplaint f WHERE f.DoctorID='" + doctorID + "'");
            dtDoctorsNotes = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,2 templateFor FROM myfavorite_DoctorNotes f WHERE f.DoctorID='" + doctorID + "'");
            dtVaccinationStatus = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,4 templateFor FROM myfavorite_VaccinationStatus f WHERE f.DoctorID='" + doctorID + "'");
            dtMedicines = StockReports.GetDataTable("SELECT mm.ID,mm.SetName FROM medicinesetmaster mm INNER JOIN medicinesetmasterdoctorwise md ON mm.ID=md.SetID WHERE md.DoctorID='" + doctorID + "' AND mm.IsActive=1 ORDER BY mm.SetName ");
            doctorAdvice = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,5 templateFor FROM myfavorite_doctorAdvice f WHERE f.DoctorID='" + doctorID + "'");
        }
        else
        {
            dtClinicalExamination = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,3 templateFor FROM myfavorite_ClinicalExamination f ");
            dtChiefComplaint = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName` ,f.ValueField,f.ID,1 templateFor FROM MyFavorite_ChiefComplaint f ");
            dtDoctorsNotes = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,2 templateFor FROM myfavorite_DoctorNotes f ");
            dtVaccinationStatus = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,4 templateFor FROM myfavorite_VaccinationStatus f ");
            dtMedicines = StockReports.GetDataTable("SELECT mm.ID,mm.SetName FROM medicinesetmaster mm INNER JOIN medicinesetmasterdoctorwise md ON mm.ID=md.SetID WHERE  mm.IsActive=1 ORDER BY mm.SetName");
            doctorAdvice = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,5 templateFor FROM myfavorite_doctorAdvice f ");
        }





        //DataTable dtChiefComplaint = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName` ,f.ValueField,f.ID,1 templateFor FROM MyFavorite_ChiefComplaint f WHERE f.DoctorID='" + doctorID + "'");
        //DataTable dtDoctorsNotes = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,2 templateFor FROM myfavorite_DoctorNotes f WHERE f.DoctorID='" + doctorID + "'");
        //DataTable dtClinicalExamination = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,3 templateFor FROM myfavorite_ClinicalExamination f WHERE f.DoctorID='" + doctorID + "'");
        //DataTable dtVaccinationStatus = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,4 templateFor FROM myfavorite_VaccinationStatus f WHERE f.DoctorID='" + doctorID + "'");
        //DataTable dtMedicines = StockReports.GetDataTable("SELECT mm.ID,mm.SetName FROM medicinesetmaster mm INNER JOIN medicinesetmasterdoctorwise md ON mm.ID=md.SetID WHERE md.DoctorID='" + doctorID + "' AND mm.IsActive=1");
        List<object> listMedicines = new List<object>();
        foreach (DataRow item in dtMedicines.Rows)
        {
            var medicines = StockReports.GetDataTable("SELECT mm.ID `id`,im.TypeName `name`,mm.ItemID `itemID`,mm.dose,mm.duration,mm.meal,mm.Quantity `quantity`,mm.route,mm.times,'' remarks,0 IsIssued FROM medicinesetitemmaster mm INNER JOIN f_itemmaster  im ON mm.ItemID=im.ItemID WHERE mm.SetID=" + Util.GetInt(item["ID"]));
            listMedicines.Add(new { templateFor = 7, TempName = item["SetName"].ToString(), ValueField = medicines, ID = item["ID"].ToString() });

        }

        return new
        {
            clinicalExaminationTemplates = dtClinicalExamination,
            chiefComplaintTemplates = dtChiefComplaint,
            doctorsNotesTemplates = dtDoctorsNotes,
            vaccinationStatusTemplates = dtVaccinationStatus,
            medicinesTemplates = listMedicines,
            doctorAdviceTemplates = doctorAdvice
        };
    }


    public static string GetFavoriteTableNameByNo(int templateFor)
    {

        switch (templateFor)
        {
            case 1:
                return "myFavorite_ChiefComplaint";
            case 2:
                return "myfavorite_DoctorNotes";
            case 3:
                return "myfavorite_ClinicalExamination";
            case 4:
                return "myfavorite_VaccinationStatus";
            case 5:
                return "myfavorite_doctorAdvice";


            default:
                return string.Empty;
        }
    }


    //[WebMethod]
    //public string SearchMedData(string prefix, string itemId)
    //{
    //    var status = "";
    //    string sInitStr = "";

    //    sInitStr = "<Initialize><DataFile password='GDDBDEMO' path='" + DataPath + "'/></Initialize>";
    //    SVR = FT.CreateServer(sInitStr, out sReturnValue, out sGUID);
    //    status = "<Request><List><Product><ByName>" + prefix + "</ByName></Product></List></Request>";

    //    string sQueryResults = "";
    //    string sQueryString = status;
    //    sReturnValue = SVR.RequestXML(sQueryString, out sQueryResults);
    //    status = sReturnValue;

    //    ExcuteCMD excuteCMD = new ExcuteCMD();
    //    var ReferenceKey = excuteCMD.ExecuteScalar("Select CIMS_GUID  FROM f_itemmaster  WHERE ItemID=@param", new
    //    {
    //        param = itemId
    //    });


    //    status = "<Request><Content><Product reference=\"" + ReferenceKey + "\"></Product></Content></Request>";
    //    sReturnValue = SVR.RequestXML(status, out sQueryResults);

    //    XmlDocument xdoc = new XmlDocument();
    //    xdoc.LoadXml(sReturnValue);

    //    // Create an XML declaration. 
    //    XmlDeclaration xmldecl;
    //    xmldecl = xdoc.CreateXmlDeclaration("1.0", null, null);
    //    xmldecl.Encoding = "UTF-8";
    //    xmldecl.Standalone = "yes";

    //    // Add the new node to the document.
    //    XmlElement root = xdoc.DocumentElement;
    //    xdoc.InsertBefore(xmldecl, root);

    //    // Display the modified XML document 
    //    Console.WriteLine(xdoc.OuterXml);

    //    xdoc.Save(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\sample.xml");


    //    string XMLFilePath = @"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\sample.xml";
    //    string XSLTFilePath = @"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\Monograph-Interaction-CDSDefault.xsl";
    //    Transform(XMLFilePath, XSLTFilePath, itemId);
    //    ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\" + itemId + ".html", ".js\" />", ".js\"></script>");
    //    ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\" + itemId + ".html", "&amp;Delta;", "<tr>");
    //    ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\" + itemId + ".html", "&lt;", "<");
    //    ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\" + itemId + ".html", "&gt;", ">");
    //    ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\" + itemId + ".html", "&amp;lt;", "");
    //    ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\" + itemId + ".html", "ui-icon ui-icon-alert", "");



    //    return ReferenceKey;
    //}

    public static void ReplaceInFile(string filePath, string searchText, string replaceText)
    {
        var content = string.Empty;
        using (StreamReader reader = new StreamReader(filePath))
        {
            content = reader.ReadToEnd();
            reader.Close();
        }
        content = content.Replace(searchText, replaceText);
        using (StreamWriter writer = new StreamWriter(filePath))
        {
            writer.Write(content);
            writer.Close();
        }
    }

    public static void Transform(string sXmlPath, string sXslPath, string ItemID)
    {
        try
        {
            //load the Xml doc
            XPathDocument myXPathDoc = new XPathDocument(sXmlPath);
            XslTransform myXslTrans = new XslTransform();
            //load the Xsl 
            myXslTrans.Load(sXslPath);

            //create the output stream
            XmlTextWriter myWriter = new XmlTextWriter(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\" + ItemID + ".html", Encoding.UTF8);

            //do the actual transform of Xml
            myXslTrans.Transform(myXPathDoc, null, myWriter);
            myWriter.Close();
        }
        catch (Exception e)
        {
            Console.WriteLine("Exception: {0}", e.ToString());
        }
    }


    static public String TransformXMLToHTML(XmlDocument xmlDoc, string strpath)
    {
        using (MemoryStream stream = new MemoryStream(ASCIIEncoding.Default.GetBytes(xmlDoc.DocumentElement.OuterXml)))
        {
            XPathDocument document = new XPathDocument(stream);
            using (StringWriter writer = new StringWriter())
            {
                XslTransform xslt = new XslTransform();
                xslt.Load(strpath);

                xslt.Transform(document, null, writer);
                return writer.ToString();
            }
        }
    }


    //  private FastTrack5.FastTrack_Creator FT = new FastTrack5.FastTrack_Creator();
    // private FastTrack5.IFastTrack_Server SVR;
    private string DataPath = "D:\\CIMS\\CIMSDatabase\\FastTrackData.mrc";
    private string sReturnValue = "";
    private string sGUID = "";

    private void createNode(string prefix, System.Xml.XmlTextWriter writer)
    {
        writer.WriteStartElement("List");
        writer.WriteStartElement("Product");
        writer.WriteStartElement("ByName");
        writer.WriteString(prefix);
        writer.WriteEndElement();
        writer.WriteEndElement();
        writer.WriteEndElement();
    }

    [WebMethod]
    public string WriteXDoc(string tId, string itemId, string cims_guid, string cims_Type)
    {
        //    string ReferenceKey = "",XDocStream = "",result="0";
        //    if (cims_Type == "Molecule")
        //        ReferenceKey = cims_guid;
        //    else
        //        ReferenceKey = GetElemReference(itemId);

        //    if(ReferenceKey!=""){
        //        // Write DrugInteraction Xml
        //        XDocStream = AppendXML_Elem(itemId, @"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + ".xml", ReferenceKey, cims_Type);
        //        // End


        //        var status = "";
        //        string sInitStr = "";
        //        sInitStr = "<Initialize><DataFile password='GDDBDEMO' path='" + DataPath + "'/></Initialize>";
        //        SVR = FT.CreateServer(sInitStr, out sReturnValue, out sGUID);

        //        string sQueryResults = "";
        //        string sQueryString = XDocStream;                                                
        //        sReturnValue = SVR.RequestXML(sQueryString, out sQueryResults);
        //        status = sReturnValue;

        //        if(sReturnValue!=null){
        //                XmlDocument xdoc = new XmlDocument();
        //                xdoc.LoadXml(sReturnValue);

        //                // Create an XML declaration. 
        //                XmlDeclaration xmldecl;
        //                xmldecl = xdoc.CreateXmlDeclaration("1.0", null, null);
        //                xmldecl.Encoding = "UTF-8";xmldecl.Standalone = "yes";

        //                // Add the new node to the document.
        //                XmlElement root = xdoc.DocumentElement;
        //                xdoc.InsertBefore(xmldecl, root);
        //                Console.WriteLine(xdoc.OuterXml);

        //                xdoc.Save(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + "_.xml");
        //                string XMLFilePath = @"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + "_.xml";
        //                string XSLTFilePath = @"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\Monograph-Interaction-CDSDefault.xsl";

        //                XPathDocument myXPathDoc = new XPathDocument(XMLFilePath);XslTransform myXslTrans = new XslTransform();myXslTrans.Load(XSLTFilePath);
        //                XmlTextWriter myWriter = new XmlTextWriter(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + ".html", Encoding.UTF8);
        //                myXslTrans.Transform(myXPathDoc, null, myWriter);myWriter.Close();

        //                ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + ".html", ".js\" />", ".js\"></script>");
        //                ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + ".html", "&amp;Delta;", "<tr>");
        //                ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + ".html", "&lt;", "<");
        //                ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + ".html", "&gt;", ">");
        //                ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + ".html", "&amp;lt;", "");
        //                ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + ".html", "ui-icon ui-icon-alert", "");
        //                ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + ".html", "css/", "../css/");
        //                ReplaceInFile(@"C:\inetpub\wwwroot\his\Design\CPOE\CIMS\TID\xDoc_" + tId + ".html", "scripts/", "../scripts/");

        //                XPathDocument document = new XPathDocument(XMLFilePath);
        //                XPathNavigator navigator = document.CreateNavigator();
        //                XPathNavigator node = navigator.SelectSingleNode("//Result/Interaction/Product/Route/Product");
        //                if (node != null)
        //                {
        //                    if (node.HasAttributes)
        //                    {
        //                        result = "1";
        //                    }
        //                    else
        //                    {
        //                        result = "0";
        //                    }
        //                }
        //                else
        //                {
        //                    result = "0";
        //                }                           
        //        }

        //    }

        return "";
    }




    private string AppendXML_Elem(string ItemID, string sXmlPath, string ReferenceKey, string CIMS_Type)
    {

        if (!File.Exists(sXmlPath))
        {
            XmlWriterSettings xmlWriterSettings = new XmlWriterSettings();
            xmlWriterSettings.Indent = true;
            xmlWriterSettings.NewLineOnAttributes = true;
            using (XmlWriter xmlWriter = XmlWriter.Create(sXmlPath, xmlWriterSettings))
            {
                xmlWriter.WriteStartDocument();
                xmlWriter.WriteStartElement("Request");
                xmlWriter.WriteStartElement("Interaction");

                if (CIMS_Type == "Product")
                {
                    xmlWriter.WriteStartElement("Prescribing");
                    xmlWriter.WriteStartElement("Product");
                    xmlWriter.WriteAttributeString("reference", ReferenceKey);
                    xmlWriter.WriteAttributeString("ItemID", ItemID);
                    xmlWriter.WriteEndElement();
                    xmlWriter.WriteEndElement();
                }
                else if (CIMS_Type == "Molecule")
                {
                    xmlWriter.WriteStartElement("Allergies");
                    xmlWriter.WriteStartElement("Molecule", "");
                    xmlWriter.WriteAttributeString("reference", ReferenceKey);
                    xmlWriter.WriteAttributeString("SaltID", ItemID);
                    xmlWriter.WriteEndElement();
                    xmlWriter.WriteEndElement();
                }
                xmlWriter.WriteStartElement("HealthIssueCodes"); xmlWriter.WriteEndElement();
                xmlWriter.WriteEndElement();
                xmlWriter.WriteStartElement("PatientProfile"); xmlWriter.WriteEndElement();
                xmlWriter.WriteEndElement();
                xmlWriter.WriteEndDocument();
                xmlWriter.Flush();
                xmlWriter.Close();
            }
        }

        else
        {
            XDocument xDocument = XDocument.Load(sXmlPath);
            XElement root = xDocument.Element("Request");
            if (CIMS_Type == "Product")
            {
                if (root.Element("Prescribing") == null)
                {
                    IEnumerable<XElement> Introws = root.Descendants("Interaction");
                    XElement IntfirstRow = Introws.First();
                    IntfirstRow.Add(
                   new XElement("Prescribing"));
                }
                IEnumerable<XElement> rows = root.Descendants("Prescribing");
                XElement firstRow = rows.First();
                firstRow.Add(
                   new XElement("Product", new XAttribute("reference", ReferenceKey), new XAttribute("ItemID", ItemID)));
            }
            else if (CIMS_Type == "Molecule")
            {
                if (root.Element("Allergies") == null)
                {
                    IEnumerable<XElement> Introws = root.Descendants("Interaction");
                    XElement IntfirstRow = Introws.First();
                    IntfirstRow.Add(
                   new XElement("Allergies"));
                }
                IEnumerable<XElement> rows = root.Descendants("Allergies");
                XElement firstRow = rows.First();
                firstRow.Add(
                   new XElement("Molecule", new XAttribute("reference", ReferenceKey), new XAttribute("SaltID", ItemID)));
            }

            xDocument.Save(sXmlPath);
        }

        XDocument doc = XDocument.Load(sXmlPath);
        return doc.ToString();
    }

    private string GetElemReference(string ItemID)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var reference = excuteCMD.ExecuteScalar("SELECT CIMS_GUID from f_itemmaster WHERE ItemID=@itemId", new
        {
            itemId = ItemID
        });
        return reference;
    }

    [WebMethod]
    public string RemoveItemXDoc(string Id, string Type)
    {
        string ItemID = "", SaltID = "", result = "0";
        if (Type == "Molecule")
            SaltID = Id;
        else
            ItemID = Id;



        return result;
    }

    [WebMethod]
    public string BindDepartment()
    {
        string str = "SELECT TRIM(Department)Department FROM doctor_master dm INNER JOIN doctor_hospital dh ON dm.DoctorID=dh.DoctorID WHERE dm.IsActive=1 GROUP BY Department";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string BindDoctorAll(string Department, string TID)
    {
        string CurrentDoctorId = Util.GetString(StockReports.ExecuteScalar(" SELECT pmh.`DoctorID` FROM `patient_medical_history` pmh WHERE pmh.`TransactionID`='" + TID + "'  "));
        string sql = "SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name,' (',dm.Designation,')'))Name,dm.Designation Department,dm.DocDepartmentID,dm.Specialization,dm.docGroupID,dm.IsDocShare,dm.IsEmergencyAvailable  FROM doctor_master dm INNER JOIN f_center_doctor fcp ON dm.DoctorID=fcp.DoctorID WHERE dm.IsActive = 1 AND fcp.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND fcp.isActive=1 ORDER BY dm.name";
        DataTable dt = StockReports.GetDataTable(sql);
        DataView DoctorView = dt.AsDataView();
        //  DoctorView.RowFilter = "DoctorID<>'" + CurrentDoctorId + "'";
        if (Department.ToUpper() != "ALL")
            DoctorView.RowFilter = "Department='" + Department + "' ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(DoctorView.ToTable());


    }

    [WebMethod]
    public string GetAllergiesAndDiagnosis(string patientID)
    {
        string str = "SELECT 'Allergies' AS DataType,ce.Allergies AS DataValues,DATE_FORMAT(ce.EntryDate,'%d-%b-%y') AS EntryDate FROM cpoe_hpexam ce WHERE ce.PatientID='" + patientID + "' AND IFNULL(ce.Allergies,'')<>'' UNION ALL SELECT 'Diagnosis' AS DataType, cp.ProvisionalDiagnosis AS DataValues,DATE_FORMAT(cp.CreatedDate,'%d-%b-%y') AS EntryDate FROM cpoe_PatientDiagnosis cp WHERE cp.PatientID='" + patientID + "' AND IFNULL(cp.ProvisionalDiagnosis,'')<>''";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession=true)]
    public string CheckStockofItem(string ItemId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT SUM(InitialCount - ReleasedCount) Qty, ItemID ");
        sb.Append(" FROM f_stock WHERE ispost = 1 AND MedExpiryDate > CURDATE() ");
        sb.Append(" AND (InitialCount - ReleasedCount)>0 AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        sb.Append(" AND DeptledgerNo='LSHHI57' AND ITemID='" + ItemId + "' GROUP BY ITemID");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count>0 && dt!=null)
        {
            decimal Count = Util.GetDecimal(dt.Rows[0]["Qty"].ToString());
            if (Count>0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "" });
              
            }
            
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "" });
              
        }

    }




    [WebMethod]
    public string CheckTransactionDetail(string TransactionID)
    {
        int Checkdt = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from cpoe_10cm_patient where TransactionID='" + TransactionID + "' and  IsActive=1 "));
        if (Checkdt > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = 1 });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = 0 });
        }

    }

    [WebMethod]
    public string CheckIsNoteFinder(string TransactionID)
    {
        int Checkdt = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from notecreationpatient_detail where TransactionID='" + TransactionID + "'"));
        if (Checkdt > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = 1 });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = 0 });
        }

    }
    
    
    

}