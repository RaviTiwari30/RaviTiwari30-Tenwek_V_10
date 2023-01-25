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
[System.Web.Script.Services.ScriptService]
public class prescribeServices : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    [WebMethod(EnableSession = true)]
    public string medicineItemSearch(string prefix)
    {

        var sqlCmd = new StringBuilder("SELECT im.ItemCode, UPPER(CONCAT(SUBSTR(IFNULL(sm.Name,''), 1, 3),'.',IM.Typename,' - ',IFNULL(fsm.Name,''))) Typename, IM.ItemID, IM.MedicineType, IFNULL(IM.Dose,'') `Dose`,IFNULL(IM.Duration,'')`Duration`,IFNULL(IM.Route,'')`Route`,IFNULL(IM.Times,'')`Times`,IM.Typename `Brand`, fsm.Name `Generic`  FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_itemmaster_centerwise itc ON itc.itemid=im.`ItemID` INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID LEFT JOIN  f_item_salt ts ON im.ItemID=ts.ItemID LEFT JOIN f_salt_master fsm ON  fsm.SaltID=ts.saltID LEFT JOIN (SELECT IF( SUM(InitialCount - ReleasedCount) > 0, SUM(InitialCount - ReleasedCount),0 ) Qty, ItemID FROM f_stock WHERE ispost = 1 AND MedExpiryDate > CURDATE() GROUP BY ITemID) st ON st.itemID = im.ItemID WHERE CR.ConfigID = 11 AND im.IsActive = 1 AND itc.Isactive=1 AND itc.centreid='" + Session["CentreID"].ToString() + "' AND (im.TypeName LIKE '%" + prefix + "%' OR fsm.Name LIKE '%" + prefix + "%')  ");
        sqlCmd.Append(" UNION All ");
        sqlCmd.Append(" SELECT '' ItemCode ,cdm.`ItemName` `Typename`,cdm.id `ItemID`, '' `MedicineType`,cdm.Dose,cdm.Duration,cdm.Route,cdm.Times,cdm.`ItemName` `BrandName`,'' Generic FROM   cpoe_doctorItem_Master cdm   WHERE cdm.ItemType=1 and  cdm.`ItemName`  LIKE '%" + prefix + "%' ORDER BY  TypeName ");
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
    public string InvestigationItemSearch()
    {

        DataTable dtInv = LoadCacheQuery.LoadInvestigation("1", "0", "0",0,"","");
        var dtDoctorItems = StockReports.GetDataTable("SELECT cdm.ItemName,cdm.id,0 `IsPackage`  FROM   cpoe_doctorItem_Master cdm  WHERE cdm.ItemType=3 UNION ALL SELECT pm.Name `ItemName`,itm.ItemID `id`,1 `IsPackage` FROM package_master pm INNER JOIN f_itemmaster itm ON  itm.Type_ID=pm.PackageID INNER JOIN f_subcategorymaster sub ON sub.SubCategoryID=itm.subCategoryID INNER JOIN f_configrelation con ON con.categoryID=sub.categoryID  AND con.ConfigID=23  WHERE pm.IsActive=1 AND itm.IsActive=1 AND  pm.ToDate >=CURDATE() ");
        foreach (DataRow item in dtDoctorItems.Rows)
        {
            DataRow toInsert = dtInv.NewRow();
            toInsert[0] = item["ItemName"];
            toInsert["itemID"] = item["id"];
            toInsert["NewItemID"] = item["id"];
            toInsert["TypeName"] = item["ItemName"];
            toInsert["IsPackage"] = item["IsPackage"];
            toInsert["IsOutSource"] = 0;
            dtInv.Rows.InsertAt(toInsert, 0);
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtInv);
    }

    [WebMethod(EnableSession=true)]
    public string ProcedureItemSearch()
    {
        DataTable dtMain = CreateStockMaster.LoadItemSubCategoryByCategoryConfigID("25");
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



    [WebMethod]
    public string loadPrescriptionView()
    {
        var dt = StockReports.GetDataTable("SELECT cp.AccordianName,cp.ViewUrl,cp.IsActive FROM emr_prescriptionview_master cp ORDER BY cp.Order ");
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


    [WebMethod(EnableSession = true)]
    public string SavePrescription(List<Patient_Test> investigations, List<Patient_Medicine> medicines, List<Patient_Test> procedures, string transactionID, string App_ID, string patientID, string chiefComplaint, string doctorNotes, string clinicalExamination, string appointmentDoctorID, string vaccinationStatus, string allergies, string medications, string progressionComplaint, List<molecular> molecularAllergies, string ledgerTransactionNo, string provisionalDiagnosis, string doctorAdvice, string confidentialData)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
		
		
		
		//IsRealsed Validation
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var isReleased = Util.GetInt(excuteCMD.ExecuteScalar("SELECT s.IsReleased FROM emergency_patient_details s WHERE  s.TransactionId=@transactionID", new
            {
                transactionID = transactionID

            }));

            var IsEmergencyNotes = Util.GetInt(excuteCMD.ExecuteScalar("SELECT s.IsReleased FROM emergency_patient_details s WHERE  s.TransactionId=@transactionID AND HOUR(TIMEDIFF(s.ReleasedDateTime,NOW()))>2", new
            {
                transactionID = transactionID

            }));

            if (isReleased > 0 && IsEmergencyNotes > 0)
                                
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    response = (isReleased == 1 ? "Patient Has Been Released Before 2 Hours." : (isReleased == 2 ? "Patient Has Been Released Before 2 Hours for IPD." : "Patient Shifted To IPD."))
                });

            }
            //IsRealsed Validation
		
		
            List<Patient_Test> investigationsList = new JavaScriptSerializer().ConvertToType<List<Patient_Test>>(investigations);
            List<Patient_Test> proceduresList = new JavaScriptSerializer().ConvertToType<List<Patient_Test>>(procedures);
            List<Patient_Medicine> medicinesList = new JavaScriptSerializer().ConvertToType<List<Patient_Medicine>>(medicines);
            string userID = HttpContext.Current.Session["ID"].ToString();
            var doctorID = GetDoctor(userID, transactionID);

            if (doctorID == string.Empty)
                doctorID = "0";
            string sqlQuery = string.Empty;
           // ExcuteCMD excuteCMD = new ExcuteCMD();

            //times and dose mandatory

            for (var i = 0; i < medicinesList.Count; i++) {
                if (string.IsNullOrEmpty(medicinesList[i].Dose)){
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Enter Dose in : " + medicinesList[i].MedicineName, message = "Mandatory Dose" });
                }
                if (string.IsNullOrEmpty(medicinesList[i].NoTimesDay)) {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Enter Times in : "+ medicinesList[i].MedicineName, message = "Mandatory Times" });
                }
            }
            
            //
            var PanelID = StockReports.ExecuteScalar("Select PanelID from Patient_medical_history where TransactionID='" + transactionID + "'");
            string RefID = StockReports.ExecuteScalar(" SELECT ReferenceCodeOPD FROM f_panel_master WHERE PanelID =" + PanelID + " ");
            if (string.IsNullOrEmpty(App_ID))
            {
                App_ID = Util.GetString(excuteCMD.ExecuteScalar(tnx, "CALL insert_emergency_prescriptionvisit(@transactionID,@doctorID,@createdBy)", CommandType.Text, new
                {
                    transactionID = transactionID,
                    doctorID = doctorID,
                    createdBy = userID
                }));
            }
            var medicinePrescriptionMaster = StockReports.GetDataTable("SELECT * FROM medicinePrescriptionMaster").AsEnumerable().Select(i => new { text = Util.GetString(i.Field<string>("Text")).ToLower(), type = Util.GetInt(i.Field<int>("Type")) }).ToList();
            var doctorItemsMaster = StockReports.GetDataTable("SELECT m.ItemName,m.ItemType  FROM cpoe_doctorItem_Master m").AsEnumerable().Select(i => new { itemName = Util.GetString(i.Field<string>("ItemName")).ToLower(), itemType = Util.GetInt(i.Field<int>("ItemType")) }).ToList();
           
            if (isReleased == 0)
            {
                sqlQuery = "UPDATE patient_test pt  SET isactive=0 WHERE pt.IsIssue=0 and pt.TransactionID=@TransactionID and pt.IsEmergencyData=1 and  pt.App_ID=@App_ID";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TransactionID = transactionID,
                    App_ID = App_ID
                });
            }

            string BarcodeNo = string.Empty;
            int RateCount = 0;
            string LedgerID = string.Empty;
            for (int i = 0; i < investigationsList.Count; i++)
            {
                investigationsList[i].PatientTest_ID = Util.GetInt(investigationsList[i].Test_ID.Split('_')[1]);
                var isAlreadyPrescribed = 0;
                if (investigationsList[i].PatientTest_ID > 0)
                {
                    isAlreadyPrescribed = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM patient_test pt WHERE pt.PatientTest_ID=@PatientTest_ID", CommandType.Text, new
                    {
                        PatientTest_ID = investigationsList[i].PatientTest_ID
                    }));
                }
                if (isAlreadyPrescribed < 1)
                {
                    isAlreadyPrescribed = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail ltd WHERE ltd.ItemID='"+ investigations[i].Test_ID.Split('_')[0] +"' AND TransactionID='"+ investigations[i].TransactionID +"'"));
                    if (investigationsList[i].IsPackage == 0 && isAlreadyPrescribed == 0 && isReleased == 0)
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append("SELECT im.TypeName,im.SubCategoryID,im.Type_ID,rt.Rate,rt.ItemCode,rt.ID ");
                        sb.Append("FROM f_ratelist rt INNER JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rt.PanelID AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rt.ScheduleChargeID ");
                        sb.Append("INNER JOIN f_itemmaster im ON im.ItemID=rt.ItemID WHERE rt.IsCurrent=1  and rt.PanelID=" + RefID + " AND rt.CentreID=" + Session["CentreID"].ToString() + "  ");
                        sb.Append("AND rt.ItemID='" + investigations[i].Test_ID.Split('_')[0] + "'  ");
                        DataTable dtItemDetail = StockReports.GetDataTable(sb.ToString());

                        if (dtItemDetail.Rows.Count <= 0)
                        {
                            tnx.Rollback();
							   string responseName = "Rate is not Set for Investigation :" + investigationsList[i].name;
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = responseName, message = "Error In Item Rate." });

                        }


                        var rate = Util.GetDecimal(dtItemDetail.Rows[0]["Rate"].ToString());

                        if (rate <= 0)
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Zero Rate Items Are Not Allow.", message = "Error In Item Rate." });
                        }



                        DataTable dtPatientDetails = StockReports.GetDataTable("SELECT emr.RoomId,emr.IPDCaseTypeID,pm.Age FROM emergency_patient_details emr INNER JOIN patient_master pm ON pm.PatientID=emr.PatientId WHERE emr.TransactionId='" + transactionID + "'");
                        if (dtItemDetail.Rows.Count > 0)
                        {
                            RateCount = 0;
                            LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                            ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                            ObjLdgTnxDtl.LedgerTransactionNo = investigations[i].LedgerTransactionNo;
                            ObjLdgTnxDtl.ItemID = Util.GetString(investigations[i].Test_ID.Split('_')[0]);
                            ObjLdgTnxDtl.Rate = Util.GetDecimal(dtItemDetail.Rows[0]["Rate"].ToString());//
                            ObjLdgTnxDtl.Quantity = Util.GetDecimal(1);
                            ObjLdgTnxDtl.StockID = "";
                            ObjLdgTnxDtl.IsTaxable = "NO";

                            ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(0);
                            ObjLdgTnxDtl.DiscountPercentage = 0;
                            ObjLdgTnxDtl.Amount = Util.GetDecimal(dtItemDetail.Rows[0]["Rate"].ToString());
                            if (ObjLdgTnxDtl.DiscountPercentage > 0)
                                ObjLdgTnxDtl.DiscUserID = HttpContext.Current.Session["ID"].ToString();
                            ObjLdgTnxDtl.IsPackage = 0;
                            ObjLdgTnxDtl.PackageID = "";
                            ObjLdgTnxDtl.IsVerified = 1;
                            ObjLdgTnxDtl.TransactionID = investigations[i].TransactionID;
                            ObjLdgTnxDtl.SubCategoryID = Util.GetString(dtItemDetail.Rows[0]["SubcategoryID"].ToString()).Trim(); //
                            ObjLdgTnxDtl.ItemName = Util.GetString(investigationsList[i].name).Trim();
                            ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                            ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                            ObjLdgTnxDtl.DoctorID = doctorID;
                            ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dtItemDetail.Rows[0]["SubcategoryID"].ToString()), con));
                            ObjLdgTnxDtl.TnxTypeID = Util.GetInt(0);
                            ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                            ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(0);
                            ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                            ObjLdgTnxDtl.RateListID = Util.GetInt(dtItemDetail.Rows[0]["ID"].ToString());
                            ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            ObjLdgTnxDtl.Type = "O";
                            ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                            ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                            ObjLdgTnxDtl.rateItemCode = dtItemDetail.Rows[0]["ItemCode"].ToString();
                            ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                            ObjLdgTnxDtl.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                            ObjLdgTnxDtl.roundOff = 0;
                            ObjLdgTnxDtl.typeOfTnx = "OPD-LAB";
                            ObjLdgTnxDtl.CoPayPercent = 0;
                            ObjLdgTnxDtl.IsPayable = 0;
                            ObjLdgTnxDtl.isPanelWiseDisc = 0;
                            ObjLdgTnxDtl.IPDCaseTypeID = dtPatientDetails.Rows[0]["IPDCaseTypeID"].ToString();
                            ObjLdgTnxDtl.RoomID = dtPatientDetails.Rows[0]["RoomId"].ToString();
                            ObjLdgTnxDtl.Type_ID = "0";
                            string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
                            LedgerID = LdgTnxDtlID;
                            if (LdgTnxDtlID == "")
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In LdgTnx Details" });
                            }

                            if (Resources.Resource.AllowFiananceIntegration == "1")
                            {
                                string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(ledgerTransactionNo), "", "R", LdgTnxDtlID, tnx));
                                if (IsIntegrated == "0")
                                {
                                    tnx.Rollback();
                                    throw new Exception("Error In Finance Integration Details");
                                }
                            }
                            Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
                            objPLI.Investigation_ID = dtItemDetail.Rows[0]["Type_ID"].ToString();
                            objPLI.IsUrgent = Util.GetInt(0);
                            objPLI.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                            objPLI.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                            objPLI.Lab_ID = "LAB1";
                            objPLI.DoctorID = doctorID;
                            objPLI.TransactionID = transactionID;
                            if (BarcodeNo == "")
                                BarcodeNo = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_barcode(" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString();
                            objPLI.BarcodeNo = BarcodeNo;
                            if (BarcodeNo == "0")
                                objPLI.PrePrintedBarcode = 1;
                            string sampletypedetail = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAT(im.sampletypename,'#',im.SampleTypeID,'#',IFNULL(OutSourceLabID,'0'),'#',im.Type) FROM investigation_master im WHERE im.Investigation_Id='" + dtItemDetail.Rows[0]["Type_ID"].ToString() + "'").ToString();
                            if (sampletypedetail.Split('#')[3] == "R")
                            {
                                objPLI.IsSampleCollected = "N";
                                // sampleCollectCount += 1;
                            }
                            else
                            {
                                objPLI.IsSampleCollected = "S";
                                objPLI.SampleDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                objPLI.sampleCollectCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                                objPLI.SampleCollectionBy = HttpContext.Current.Session["ID"].ToString();
                                objPLI.SampleCollectionDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                objPLI.SampleCollector = HttpContext.Current.Session["LoginName"].ToString();
                                //objPLI.SampleReceiveDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                //objPLI.SampleReceivedBy = HttpContext.Current.Session["ID"].ToString();
                                //objPLI.SampleReceiver = HttpContext.Current.Session["LoginName"].ToString();
                            }
                            string[] stringList = Resources.Resource.HistoCytoSubcategoryID.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                            if (stringList.Contains(ObjLdgTnxDtl.SubCategoryID))
                            {
                                objPLI.HistoCytoSampleDetail = 1;
                            }
                            objPLI.CurrentAge = dtPatientDetails.Rows[0]["Age"].ToString();
                            objPLI.PatientID = investigations[i].PatientID;
                            objPLI.Special_Flag = 0;
                            objPLI.LedgerTransactionNo = investigations[i].LedgerTransactionNo;
                            objPLI.IPNo = "";
                            objPLI.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            objPLI.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                            objPLI.LedgerTnxID = Util.GetInt(LdgTnxDtlID);
                            objPLI.OutSourceLabID = 0;
                            if (Util.GetInt(sampletypedetail.Split('#')[2]) != 0)
                            {
                                objPLI.IsOutSource = 1;
                                objPLI.OutSourceBy = HttpContext.Current.Session["ID"].ToString();
                                objPLI.OutsourceDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                                objPLI.OutSourceLabID = Util.GetInt(sampletypedetail.Split('#')[2]);
                            }
                            objPLI.ReportDispatchModeID = 1;
                            objPLI.Type = 3;
                            objPLI.BookingCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            objPLI.IPDCaseTypeID = ObjLdgTnxDtl.IPDCaseTypeID;
                            objPLI.RoomID = ObjLdgTnxDtl.RoomID;
                            objPLI.Remarks = investigationsList[i].Remarks;
                            int resultPLI = objPLI.Insert();
                            if (resultPLI == 0)
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient LAB Investingation" });
                            }
                            //string labPrescribedID = Util.GetString(dataPatient_Test[i].PatientTest_ID).Trim();
                            //if (labPrescribedID != "0")

                        }
                        else
                        {
                            RateCount += 1;
                        }
                    }
                     if (isReleased == 0)
            {
                    Patient_Test pt = new Patient_Test(tnx);
                    pt.PatientID = investigationsList[i].PatientID;
                    pt.App_ID = App_ID;
                    pt.TransactionID = investigationsList[i].TransactionID;
                    pt.Test_ID = investigationsList[i].Test_ID.Split('_')[0];
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
                    pt.IsEmergencyData = 1;
                    int ID = pt.Insert();
                    if (LedgerID != string.Empty)
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Patient_Test SET IsIssue=1,OPDTransactionID='" + transactionID + "',OPDLedgertansactionNO='" + ledgerTransactionNo + "',OPDLedgerTnxID='" + LedgerID + "' WHERE PatientTest_ID=" + ID + " ");

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
            }

            for (int i = 0; i < proceduresList.Count; i++)
            {
                proceduresList[i].PatientTest_ID = Util.GetInt(proceduresList[i].Test_ID.Split('_')[1]);
                var isAlreadyPrescribed = 0;
                if (proceduresList[i].PatientTest_ID > 0)
                {
                    isAlreadyPrescribed = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM patient_test pt WHERE pt.PatientTest_ID=@PatientTest_ID", CommandType.Text, new
                    {
                        PatientTest_ID = proceduresList[i].PatientTest_ID
                    }));
                }
                
                if (isAlreadyPrescribed < 1)
                {
                    isAlreadyPrescribed = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail ltd WHERE ltd.ItemID='" + proceduresList[i].Test_ID.Split('_')[0] + "' AND TransactionID='" + proceduresList[i].TransactionID + "'"));
                if (isAlreadyPrescribed == 0 && isReleased == 0)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("SELECT im.TypeName,im.SubCategoryID,im.Type_ID,rt.Rate,rt.ItemCode,rt.ID ");
                    sb.Append("FROM f_ratelist rt INNER JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rt.PanelID AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rt.ScheduleChargeID ");
                    sb.Append("INNER JOIN f_itemmaster im ON im.ItemID=rt.ItemID WHERE rt.IsCurrent=1  and rt.PanelID=" + RefID + " AND rt.CentreID=" + Session["CentreID"].ToString() + "  ");
                    sb.Append("AND rt.ItemID='" + proceduresList[i].Test_ID.Split('_')[0] + "'  ");
                    DataTable dtItemDetail = StockReports.GetDataTable(sb.ToString());
                    DataTable dtPatientDetails = StockReports.GetDataTable("SELECT emr.RoomId,emr.IPDCaseTypeID,pm.Age FROM emergency_patient_details emr INNER JOIN patient_master pm ON pm.PatientID=emr.PatientId WHERE emr.TransactionId='" + transactionID + "'");
                    if (dtItemDetail.Rows.Count > 0)
                    {
                        RateCount = 0;
                        LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                        ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                        ObjLdgTnxDtl.LedgerTransactionNo = proceduresList[i].LedgerTransactionNo;
                        ObjLdgTnxDtl.ItemID = Util.GetString(proceduresList[i].Test_ID.Split('_')[0]);
                        ObjLdgTnxDtl.Rate = Util.GetDecimal(dtItemDetail.Rows[0]["Rate"].ToString());//
                        ObjLdgTnxDtl.Quantity = Util.GetDecimal(1);
                        ObjLdgTnxDtl.StockID = "";
                        ObjLdgTnxDtl.IsTaxable = "NO";

                        ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(0);
                        ObjLdgTnxDtl.DiscountPercentage = 0;
                        ObjLdgTnxDtl.Amount = Util.GetDecimal(dtItemDetail.Rows[0]["Rate"].ToString());
                        if (ObjLdgTnxDtl.DiscountPercentage > 0)
                            ObjLdgTnxDtl.DiscUserID = HttpContext.Current.Session["ID"].ToString();
                        ObjLdgTnxDtl.IsPackage = 0;
                        ObjLdgTnxDtl.PackageID = "";
                        ObjLdgTnxDtl.IsVerified = 1;
                        ObjLdgTnxDtl.TransactionID = proceduresList[i].TransactionID;
                        ObjLdgTnxDtl.SubCategoryID = Util.GetString(dtItemDetail.Rows[0]["SubcategoryID"].ToString()).Trim(); //
                        ObjLdgTnxDtl.ItemName = Util.GetString(proceduresList[i].name).Trim();
                        ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                        ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        ObjLdgTnxDtl.DoctorID = doctorID;
                        ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dtItemDetail.Rows[0]["SubcategoryID"].ToString()), con));
                        ObjLdgTnxDtl.TnxTypeID = Util.GetInt(0);
                        ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                        ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(0);
                        ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                        ObjLdgTnxDtl.RateListID = Util.GetInt(dtItemDetail.Rows[0]["ID"].ToString());
                        ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        ObjLdgTnxDtl.Type = "O";
                        ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                        ObjLdgTnxDtl.rateItemCode = dtItemDetail.Rows[0]["ItemCode"].ToString();
                        ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        ObjLdgTnxDtl.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                        ObjLdgTnxDtl.roundOff = 0;
                        ObjLdgTnxDtl.typeOfTnx = "OPD-LAB";
                        ObjLdgTnxDtl.CoPayPercent = 0;
                        ObjLdgTnxDtl.IsPayable = 0;
                        ObjLdgTnxDtl.isPanelWiseDisc = 0;
                        ObjLdgTnxDtl.IPDCaseTypeID = dtPatientDetails.Rows[0]["IPDCaseTypeID"].ToString();
                        ObjLdgTnxDtl.RoomID = dtPatientDetails.Rows[0]["RoomId"].ToString();
                        ObjLdgTnxDtl.Type_ID = "0";
                        string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
                        LedgerID = LdgTnxDtlID;
                        if (LdgTnxDtlID == "")
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In LdgTnx Details" });
                        }

                        if (Resources.Resource.AllowFiananceIntegration == "1")
                        {
                            string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(ledgerTransactionNo), "", "R", LdgTnxDtlID, tnx));
                            if (IsIntegrated == "0")
                            {
                                tnx.Rollback();
                                throw new Exception("Error In Finance Integration Details");
                            }
                        }
                    }
                }
                if (isReleased == 0)
                {
                    Patient_Test pt = new Patient_Test(tnx);
                    pt.PatientID = proceduresList[i].PatientID;
                    pt.App_ID = App_ID;
                    pt.TransactionID = proceduresList[i].TransactionID;
                    pt.Test_ID = proceduresList[i].Test_ID.Split('_')[0];
                    pt.name = proceduresList[i].name;
                    pt.DoctorID = doctorID;
                    pt.LedgerTransactionNo = proceduresList[i].LedgerTransactionNo;
                    pt.Remarks = proceduresList[i].Remarks;
                    pt.Quantity = Util.GetInt(proceduresList[i].Quantity);
                    pt.ConfigID = Util.GetInt(25);
                    pt.CreatedBy = userID;
                    pt.IsEmergencyData = 1;
                   int ID =  pt.Insert();
                    if (LedgerID != string.Empty)
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Patient_Test SET IsIssue=1,OPDTransactionID='" + transactionID + "',OPDLedgertansactionNO='" + ledgerTransactionNo + "',OPDLedgerTnxID='" + LedgerID + "' WHERE PatientTest_ID=" + ID + " ");
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
            }


            if (isReleased == 0)
            {
                if (medicinesList.Count > 0)
                {
                    DataTable dtPatientDetails = StockReports.GetDataTable("SELECT emr.RoomId,emr.IPDCaseTypeID,pm.Age FROM emergency_patient_details emr INNER JOIN patient_master pm ON pm.PatientID=emr.PatientId WHERE emr.TransactionId='" + transactionID + "'");
                    StringBuilder sb = new StringBuilder();
                    string IndentNo = string.Empty;
                    var distinctDepartmentIDs = medicinesList.Select(i => i.Dept).ToList().Distinct().ToList();
                    if (Util.GetString(distinctDepartmentIDs[0]) != "0")
                    {
                        sqlQuery = "UPDATE patient_medicine pt  SET isactive=0 WHERE pt.IsIssued=0 and pt.TransactionID=@TransactionID AND pt.IsEmergencyData=1 and  pt.App_ID=@App_ID";
                        excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                        {
                            TransactionID = transactionID,
                            App_ID = App_ID
                        });
                        for (int j = 0; j < distinctDepartmentIDs.Count; j++)
                        {
                            if (isReleased == 0)
                            {
                                IndentNo = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_indent_no_patient('" + distinctDepartmentIDs[j] + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')").ToString();
                                if (string.IsNullOrEmpty(IndentNo))
                                {
                                    tnx.Rollback();
                                    con.Close();
                                    con.Dispose();
                                    return "0";
                                }
                            }
                            var departmentWiseItems = medicinesList.Where(i => i.Dept == distinctDepartmentIDs[j]).ToList();
                            for (int i = 0; i < departmentWiseItems.Count; i++)
                            {
                                var itemDetails = departmentWiseItems[i];
                                var isAlreadyPrescribed = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM patient_medicine pm WHERE pm.TransactionID=@transactionID AND pm.IsEmergencyData=1 and pm.App_ID=@App_ID AND pm.IsActive=1 AND pm.Medicine_ID=@medicineID", CommandType.Text, new
                                {
                                    transactionID = transactionID,
                                    medicineID = itemDetails.Medicine_ID,
                                    App_ID = App_ID
                                }));
                                if (isAlreadyPrescribed < 1)
                                {
                                    if (isReleased == 0)
                                    {
                                        sb = new StringBuilder("insert into f_indent_detail_patient(IndentNo,ItemId,ItemName,ReqQty,UnitType,DeptFrom,DeptTo,StoreId,UserId,TransactionID,IndentType,CentreID,Hospital_Id,PatientID,DoctorID,IPDCaseTypeID,RoomID,isDischargeMedicine)  ");
                                        sb.Append("values('" + IndentNo + "','" + itemDetails.Medicine_ID + "','" + itemDetails.MedicineName + "'," + Util.GetFloat(itemDetails.Quantity) + "");
                                        sb.Append(",'NOS','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + itemDetails.Dept + "','STO00001', ");
                                        sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + transactionID + "','Normal','" + HttpContext.Current.Session["CentreID"].ToString() + "', ");
                                        sb.Append("'" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + itemDetails.PatientID + "','" + doctorID + "','" + dtPatientDetails.Rows[0]["IPDCaseTypeID"].ToString() + "','" + dtPatientDetails.Rows[0]["RoomId"].ToString() + "'," + itemDetails.isDischarge + ") ");
                                        if (MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString()) == 0)
                                        {
                                            tnx.Rollback();
                                            con.Close();
                                            con.Dispose();
                                            return "0";
                                        }
                                    }
                                    Patient_Medicine objMed = new Patient_Medicine(tnx);
                                    objMed.PatientID = itemDetails.PatientID;
                                    objMed.TransactionID = itemDetails.TransactionID;

                                objMed.Medicine_ID = itemDetails.Medicine_ID;
                                objMed.MedicineName = itemDetails.MedicineName;
                                objMed.NoOfDays = itemDetails.NoOfDays;

                                objMed.NoTimesDay = itemDetails.NoTimesDay;
                                objMed.Remarks = itemDetails.Remarks;
                                objMed.Quantity = itemDetails.Quantity;
                                objMed.Dose = itemDetails.Dose;
                                objMed.EnteryBy = HttpContext.Current.Session["ID"].ToString();
                                objMed.Meal = itemDetails.Meal;
                                objMed.LedgerTransactionNo = itemDetails.LedgerTransactionNo;
                                objMed.Route = itemDetails.Route;
                                objMed.isEmergency = 1; //Hospital Medicine
                                objMed.centreID = Util.GetInt(Session["centreID"].ToString());
                                objMed.Hospital_ID = Session["HOSPID"].ToString();
                                objMed.DoctorID = doctorID;
                                objMed.IsEmergencyData = 1;
                                objMed.App_ID = Util.GetInt(App_ID);
                                int med = objMed.Insert();
                                if (isReleased == 0)
                                {
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_medicine pt SET  pt.IndentNo='" + IndentNo + "' WHERE    pt.PatientMedicine_ID=" + med);
                                }
                            }
                        }
                    }
                }
                else
                {
                   // var departmentWiseItems = medicinesList.Where(i => i.Dept == distinctDepartmentIDs[j]).ToList();
                    for (int i = 0; i < medicinesList.Count; i++)
                    {
                        var itemDetails = medicinesList[i];
                        Patient_Medicine objMed = new Patient_Medicine(tnx);
                        objMed.PatientID = itemDetails.PatientID;
                        objMed.TransactionID = itemDetails.TransactionID;

                        objMed.Medicine_ID = itemDetails.Medicine_ID;
                        objMed.MedicineName = itemDetails.MedicineName;
                        objMed.NoOfDays = itemDetails.NoOfDays;

                        objMed.NoTimesDay = itemDetails.NoTimesDay;
                        objMed.Remarks = itemDetails.Remarks;
                        objMed.Quantity = itemDetails.Quantity;
                        objMed.Dose = itemDetails.Dose;
                        objMed.EnteryBy = HttpContext.Current.Session["ID"].ToString();
                        objMed.Meal = itemDetails.Meal;
                        objMed.LedgerTransactionNo = itemDetails.LedgerTransactionNo;
                        objMed.Route = itemDetails.Route;
                        objMed.isEmergency = 3; //Discharge medicine
                        objMed.centreID = Util.GetInt(Session["centreID"].ToString());
                        objMed.Hospital_ID = Session["HOSPID"].ToString();
                        objMed.DoctorID = doctorID;
                        objMed.IsEmergencyData = 1;
                        objMed.App_ID = Util.GetInt(App_ID);
                        int med = objMed.Insert();
                    }
                }
                for (int i = 0; i < medicinesList.Count; i++)
                {
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
            }
            if (IsEmergencyNotes == 0)
            {
            #region Start of Doctor Notes
            sqlQuery = "UPDATE emr_careplan cc SET cc.IsActive=@isActive WHERE cc.TransactionID=@TransactionID and cc.App_ID=@App_ID";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                TransactionID = transactionID,
                App_ID = App_ID
            });
            sqlQuery = "INSERT  INTO emr_careplan (CarePlan,TransactionID,PatientID,EntryBy,App_ID)VALUES(@CarePlan,@TransactionID,@PatientID,@EntryBy,@App_ID)";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                CarePlan = doctorNotes,
                TransactionID = transactionID,
                PatientID = patientID,
                EntryBy = userID,
                App_ID = App_ID
            });
            #endregion end of Doctor Notes



            #region Start of Vaccination Status
            sqlQuery = "UPDATE emr_vaccinationstatus cc SET cc.IsActive=@isActive WHERE cc.TransactionID=@TransactionID and cc.App_ID=@App_ID";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                TransactionID = transactionID,
                App_ID = App_ID
            });
            sqlQuery = "INSERT  INTO emr_vaccinationstatus (VaccinationStatus,TransactionID,PatientID,EntryBy,App_ID)VALUES (@VaccinationStatus,@TransactionID,@PatientID,@EntryBy,@App_ID)";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                VaccinationStatus = vaccinationStatus,
                TransactionID = transactionID,
                PatientID = patientID,
                EntryBy = userID,
                App_ID = App_ID
            });
            #endregion end of Vaccination Status





            #region Start of CPOEExaminiation
            string IsCPOEExaminiation = StockReports.ExecuteScalar("SELECT count(*) FROM emr_hpexam WHERE TransactionID='" + transactionID + "' and App_ID=" + App_ID + "");
            if (Util.GetInt(IsCPOEExaminiation) == 0)
            {
                sqlQuery = "INSERT INTO emr_hpexam(TransactionID,PatientID,ClinicalExaminiation,MainComplaint,Allergies,Medications,ProgressionComplaint,EntryBy,EntryDate,App_ID)"
                         + " VALUE(@TransactionID,@PatientID,@ClinicalExaminiation,@MainComplaint,@Allergies,@Medications,@ProgressionComplaint,@EntryBy,@EntryDate,@App_ID)";

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
                    App_ID = App_ID

                });
            }
            else
            {
                sqlQuery = "update emr_hpexam SET ClinicalExaminiation=@ClinicalExaminiation,MainComplaint=@MainComplaint,allergies=@Allergies,medications=@Medications,ProgressionComplaint=@ProgressionComplaint where TransactionID=@TransactionID and App_ID=@App_ID";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TransactionID = transactionID,
                    ClinicalExaminiation = clinicalExamination,
                    MainComplaint = chiefComplaint,
                    Medications = medications,
                    ProgressionComplaint = progressionComplaint,
                    Allergies = allergies,
                    App_ID = App_ID

                });
            }
            #endregion End of CPOEExaminiation






            #region Start Provisional Diagnosis

            if (!string.IsNullOrEmpty(provisionalDiagnosis))
            {
                excuteCMD.DML(tnx, "Delete from emr_patientdiagnosis where LedgerTransactionNo=@LedgerTransactionNo and App_ID=@App_ID", CommandType.Text, new { LedgerTransactionNo = ledgerTransactionNo, App_ID = App_ID });
                sqlQuery = "insert into emr_patientdiagnosis(PatientID,TransactionID,LedgerTransactionNo,ProvisionalDiagnosis,CreatedBy,App_ID) values(@PatientID,@TransactionID,@LedgerTransactionNo,@ProvisionalDiagnosis,'" + HttpContext.Current.Session["ID"].ToString() + "',@App_ID)";

                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    TransactionID = transactionID,
                    PatientID = patientID,
                    LedgerTransactionNo = ledgerTransactionNo,
                    ProvisionalDiagnosis = provisionalDiagnosis,
                    App_ID = App_ID

                });
            }
            #endregion End of Provisional Diagnosis



            #region Start of Doctor Advice
            sqlQuery = "UPDATE cpoe_doctorAdvice cc SET cc.IsActive=@isActive WHERE cc.TransactionID=@TransactionID and cc.App_ID=@app_ID AND IsIPDData=@IsIPDData";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                TransactionID = transactionID,
                app_ID = App_ID,
                IsIPDData = 2
            });
            sqlQuery = "INSERT  INTO cpoe_doctorAdvice (doctorAdvice,TransactionID,PatientID,EntryBy,App_ID,IsIPDData)VALUES(@doctorAdvice,@TransactionID,@PatientID,@EntryBy,@app_ID,@IsIPDData)";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                doctorAdvice = doctorAdvice,
                TransactionID = transactionID,
                PatientID = patientID,
                EntryBy = userID,
                app_ID = App_ID,
                IsIPDData = 2
            });
            #endregion Start of Doctor Advice

            #region Start of confidential data
            sqlQuery = "UPDATE cpoe_confidentialdata cc SET cc.IsActive=@isActive WHERE cc.TransactionID=@TransactionID and cc.App_ID=@app_ID AND IsIPDData=@IsIPDData";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                isActive = 0,
                TransactionID = transactionID,
                app_ID = App_ID,
                IsIPDData = 2
            });
            sqlQuery = "INSERT  INTO cpoe_confidentialdata (confidentialData,TransactionID,PatientID,EntryBy,App_ID,IsIPDData)VALUES(@confidentialData,@TransactionID,@PatientID,@EntryBy,@app_ID,@IsIPDData)";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                confidentialData = confidentialData,
                TransactionID = transactionID,
                PatientID = patientID,
                EntryBy = userID,
                app_ID = App_ID,
                IsIPDData = 2
            });
            #endregion end of confidential data
            }

            if (isReleased == 0)
            {
                int IsUpdate = updateEmergencyBillAmounts(tnx, ledgerTransactionNo);
                if (IsUpdate != 1)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledgertransaction" });
                }
            }
           
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, appointmentID = App_ID });
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
        if (Convert.ToString(HttpContext.Current.Session["RoleID"]).ToUpper() == "52")
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
            string DocID = StockReports.ExecuteScalar("Select DoctorID from Patient_medical_history where TransactionID='" + transactionID + "'");

            return DocID;
        }
    }


    [WebMethod(EnableSession = true)]
    public string GetPrescription(string transactionID, string appointmentID, int IsIPDData, string PatientID)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
       // if (IsIPDData == 2)
      //  {
            int roleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());

        string userID = HttpContext.Current.Session["ID"].ToString();
        string doctorID = GetDoctor(userID, transactionID);
        string patientID ="";
        if (String.IsNullOrEmpty(transactionID)) {
            patientID = PatientID;
        }
        else
            patientID = StockReports.ExecuteScalar("SELECT pmh.PatientID FROM patient_medical_history pmh WHERE TransactionID='"+transactionID+"'");
        
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

        sqlCMD = new StringBuilder("SELECT cc.doctorAdvice  FROM cpoe_doctorAdvice cc  ");
        sqlCMD.Append(" WHERE  cc.TransactionID=@transactionID AND cc.App_ID=@appointmentID AND cc.IsActive=1  and IsIPDData=2 ");

        string doctorAdvice = Util.GetString(excuteCMD.ExecuteScalar(sqlCMD.ToString(), data));

        sqlCMD = new StringBuilder("SELECT cc.confidentialdata  FROM cpoe_confidentialdata cc  ");
        sqlCMD.Append(" WHERE  cc.TransactionID=@transactionID AND cc.App_ID=@appointmentID AND cc.IsActive=1  and IsIPDData=2 ");

        string confidentialData = Util.GetString(excuteCMD.ExecuteScalar(sqlCMD.ToString(), data));
        
        
        if (string.IsNullOrEmpty(appointmentID))
        {
           // sqlCMD = new StringBuilder(" SELECT CONCAT(pm.Title, '', pm.PName) `PatientName`, pm.PatientID, CONCAT(dm.Title, ' ', dm.Name) `DoctorName`, CONCAT(DATE_FORMAT(pm.DOB,'%d-%b-%Y'),'/',pm.Age, '/', pm.Gender) `Gender`, pnl.Company_Name, DATE_FORMAT(NOW(), '%d-%b-%Y') appointmentDate, '' BillNo, 0 Adjustment, 'Emergency' `VisitType`, '' ValidTo, pm.Mobile FROM Emergency_Patient_Details ap INNER JOIN patient_master pm ON pm.PatientID = ap.PatientId INNER JOIN  patient_medical_history pmh ON pmh.TransactionID = ap.TransactionId  ");
           // sqlCMD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID =@doctorID ");
           // sqlCMD.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
           // if (!transactionID.Contains("ISHHI"))
           //     sqlCMD.Append(" WHERE ap.TransactionId = @transactionID ");
           // else
            //    sqlCMD.Append(" WHERE ap.PatientId = @patientID ");
			
			
			sqlCMD = new StringBuilder(" SELECT CONCAT(pm.Title, '', pm.PName) `PatientName`, pm.PatientID, CONCAT(dm.Title, ' ', dm.Name) `DoctorName`, CONCAT(DATE_FORMAT(pm.DOB,'%d-%b-%Y'),'/',pm.Age, '/', pm.Gender) `Gender`, pnl.Company_Name, DATE_FORMAT(cc.CreatedOn, '%d-%b-%Y') appointmentDate, '' BillNo, 0 Adjustment, 'Emergency' `VisitType`, '' ValidTo, pm.Mobile  ");
            sqlCMD.Append(" FROM  patient_medical_history pmh ");
            sqlCMD.Append(" LEFT JOIN Emergency_Patient_Details ap ON ap.TransactionId=pmh.TransactionID ");
            sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID  ");
            sqlCMD.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID  ");
            sqlCMD.Append(" LEFT JOIN emergency_prescriptionvisit cc ON cc.ID='' ");
            sqlCMD.Append(" LEFT JOIN doctor_master dm ON dm.DoctorID =cc.DoctorID   ");

            if (!string.IsNullOrEmpty(transactionID) && !transactionID.Contains("ISHHI"))
                sqlCMD.Append(" WHERE pmh.TransactionID =@transactionID  ");
            else
                sqlCMD.Append(" WHERE pmh.PatientID=@patientID  ");

        }
        else
        {
            sqlCMD = new StringBuilder(" SELECT CONCAT(pm.Title, '', pm.PName) `PatientName`, pm.PatientID, CONCAT(dm.Title, ' ', dm.Name) `DoctorName`, CONCAT(DATE_FORMAT(pm.DOB,'%d-%b-%Y'),'/',pm.Age, '/', pm.Gender) `Gender`, pnl.Company_Name, DATE_FORMAT(cc.CreatedOn, '%d-%b-%Y') appointmentDate, '' BillNo, 0 Adjustment, 'Emergency' `VisitType`, '' ValidTo, pm.Mobile FROM Emergency_Patient_Details ap INNER JOIN patient_master pm ON pm.PatientID = ap.PatientId INNER JOIN  patient_medical_history pmh ON pmh.TransactionID = ap.TransactionId  ");
            
            sqlCMD.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
            sqlCMD.Append(" INNER JOIN emergency_prescriptionvisit cc ON cc.ID=@appointmentID ");
            sqlCMD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID =cc.DoctorID ");
            sqlCMD.Append(" WHERE ap.TransactionId = @transactionID ");
        }

            DataTable dtPatientDetails = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, data);
            DataTable dtPatientMolecularAllergies = new DataTable();


            return Newtonsoft.Json.JsonConvert.SerializeObject(new { investigationList = dtInvestigation, proceduresList = dtProcedures, medicinesList = dtMedicines, doctorNotes = doctorNotes, CPOEExamination = dtCpoeExamination, vaccinationStatus = vaccinationStatus, patientDetails = dtPatientDetails, molecularAllergies = dtPatientMolecularAllergies, ProvisionalDiagnosis = dtProvisional, doctorAdvice = doctorAdvice, ConfidentialData = confidentialData });
       // }
       
    }


    [WebMethod]
    public string GetFavoriteTemplates(string doctorID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(GetFavorite(doctorID));
    }

    [WebMethod]
    public string GetVitalDetails(string transactionID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT   IF(IFNULL(ipo.T,'')='',0,ipo.T) AS Temp, ipo.P AS Pulse, ipo.SPO2, ipo.BP, ipo.r,ipo.HT,ipo.WT,(SELECT CBG FROM diabiatic_chart WHERE  Active=1 AND TransactionID='" + transactionID + "' LIMIT 1)RBS FROM cpoe_vital ipo WHERE ipo.TransactionID = '" + transactionID + "' GROUP BY ipo.ID ORDER BY ipo.EntryDate DESC LIMIT 1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string GetPreviousVisit(string transactionID, string patientID, string appointmentID, string IsIPDData)
    {
        var sqlCmd = new System.Text.StringBuilder();
        int roleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = new DataTable();
        //if (!string.IsNullOrEmpty(appointmentID))
        //{
        //    dt = excuteCMD.GetDataTable("SELECT DATE_FORMAT(pmh.CreatedOn,'%d-%b-%Y') DateVisit, CONCAT(dm.Title, ' ', dm.Name) DName, pmh.DoctorID DoctorID, pmh.TransactionID TransactionID, IF(pmh.ID=@appointmentID,1,0) CurrentVisit, pmh.ID FROM emergency_prescriptionvisit pmh INNER JOIN Doctor_master dm ON pmh.DoctorID = dm.DoctorID WHERE pmh.TransactionID = @transactionID ORDER BY CurrentVisit DESC, pmh.CreatedOn DESC  ", CommandType.Text, new
        //    {
        //        appointmentID = appointmentID,
        //        transactionID = transactionID
        //    });
        //}
        //else
        //{
        //    dt = excuteCMD.GetDataTable("SELECT DATE_FORMAT(pmh.CreatedOn,'%d-%b-%Y') DateVisit, CONCAT(dm.Title, ' ', dm.Name) DName, pmh.DoctorID DoctorID, pmh.TransactionID TransactionID, IF(pmh.ID=@appointmentID,1,0) CurrentVisit, pmh.ID FROM emergency_prescriptionvisit pmh INNER JOIN Doctor_master dm ON pmh.DoctorID = dm.DoctorID INNER JOIN emergency_patient_details emr ON emr.TransactionId=pmh.TransactionID WHERE emr.PatientId=@patientID ORDER BY CurrentVisit DESC, pmh.CreatedOn DESC  ", CommandType.Text, new
        //    {
        //        appointmentID = appointmentID,
        //        transactionID = transactionID,
        //        patientID = patientID
        //    });
        //}


        StringBuilder sb = new StringBuilder();

        //sb.Append(" SELECT  pmh.ID AS App_ID,pmh.CreatedOn AS VisitDate,DATE_FORMAT(pmh.CreatedOn,'%d-%b-%Y') DateVisit, CONCAT(dm.Title, ' ', dm.Name) DName, pmh.DoctorID DoctorID, ");
        //sb.Append(" pmh.TransactionID TransactionID,'' LedgerTransactionNo,  ");
        //sb.Append(" IF(@isIPDVisit=1,IF(pmh.ID=@App_ID,1,0),0) CurrentVisit, ");
        //sb.Append(" (SELECT f.Company_Name FROM f_panel_master f WHERE f.PanelID= adj.PanelID) PanelName ,'1' AS Isipd  ");
        //sb.Append(" FROM ipd_prescriptionvisit pmh  ");
        //sb.Append(" INNER JOIN `f_ipdadjustment` adj ON adj.`TransactionID`=pmh.`TransactionID`  ");
        //sb.Append(" INNER JOIN Doctor_master dm ON pmh.DoctorID = dm.DoctorID  ");
        //sb.Append(" WHERE adj.PatientID =@patientID  ");
        //sb.Append(" UNION ALL ");
        //sb.Append(" SELECT app.App_ID,app.Date AS VisitDate, DATE_FORMAT(app.Date,'%d-%b-%Y')DateVisit,CONCAT(dm.Title,' ',dm.Name)DName,DM.DoctorID, ");
        //sb.Append(" app.TransactionID,app.LedgerTnxNo AS LedgerTransactionNo,  ");
        //sb.Append(" IF(@isIPDVisit=0,IF(app.App_ID=@App_ID,1,0),0) CurrentVisit,  ");
        //sb.Append(" (SELECT f.Company_Name FROM f_panel_master f WHERE f.PanelID= app.PanelID) PanelName,'0' AS Isipd  ");
        //sb.Append(" FROM appointment app  ");
        //sb.Append(" INNER JOIN Doctor_master dm ON dm.DoctorID=app.DoctorID  ");
        //sb.Append(" WHERE app.IsCancel=0 AND app.PatientID=@patientID  ");
        //sb.Append(" UNION ALL ");
        sb.Append(" SELECT pmh.ID AS App_ID,pmh.CreatedBy AS VisitDate ,  DATE_FORMAT(pmh.CreatedOn,'%d-%b-%Y') DateVisit, ");
        sb.Append("CONCAT(dm.Title, ' ', dm.Name) DName, pmh.DoctorID DoctorID, pmh.TransactionID TransactionID,'' LedgerTransactionNo, ");
        sb.Append("IF(@isIPDVisit='2',IF(pmh.ID=@App_ID,0,0),0) CurrentVisit,'' AS PanelName ,'2' AS Isipd ");
        sb.Append("FROM emergency_prescriptionvisit pmh ");
        sb.Append("INNER JOIN Doctor_master dm ON pmh.DoctorID = dm.DoctorID ");
        sb.Append("INNER JOIN emergency_patient_details emr ON emr.TransactionId=pmh.TransactionID ");
        sb.Append("WHERE emr.PatientId=@patientID ");

        sb.Append(" ORDER BY CurrentVisit DESC, VisitDate  DESC ");
        dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            App_ID = appointmentID,
            patientID = patientID,
            isIPDVisit= IsIPDData
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public string SaveTemplate(TemplateMaster data)
    {
        try
        {

            var tableName = GetFavoriteTableNameByNo(data.templateFor);

            ExcuteCMD excuteCMD = new ExcuteCMD();

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
            dtMedicines = StockReports.GetDataTable("SELECT mm.ID,mm.SetName FROM medicinesetmaster mm INNER JOIN medicinesetmasterdoctorwise md ON mm.ID=md.SetID WHERE md.DoctorID='" + doctorID + "' AND mm.IsActive=1");
            doctorAdvice = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,5 templateFor FROM myfavorite_doctorAdvice f WHERE f.DoctorID='" + doctorID + "'");
    
        }
        else
        {
            dtClinicalExamination = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,3 templateFor FROM myfavorite_ClinicalExamination f ");
            dtChiefComplaint = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName` ,f.ValueField,f.ID,1 templateFor FROM MyFavorite_ChiefComplaint f ");
            dtDoctorsNotes = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,2 templateFor FROM myfavorite_DoctorNotes f ");
            dtVaccinationStatus = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,4 templateFor FROM myfavorite_VaccinationStatus f ");
            dtMedicines = StockReports.GetDataTable("SELECT mm.ID,mm.SetName FROM medicinesetmaster mm INNER JOIN medicinesetmasterdoctorwise md ON mm.ID=md.SetID WHERE  mm.IsActive=1");
            doctorAdvice = StockReports.GetDataTable("SELECT f.TempName `TemplateName`, CONCAT(LEFT(f.TempName , " + templateNameCharCount + "),'...') `TempName`,f.ValueField,f.ID,5 templateFor FROM myfavorite_doctorAdvice f ");
      
        }


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
    [WebMethod(EnableSession=true)]
    public string BindStoreDepartment()
    {
        DataTable dt = AllLoadData_Store.dtStoreIndentDepartments(Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), 0);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            //ddlDepartment.DataSource = dt;
            //ddlDepartment.DataTextField = "ledgerName";
            //ddlDepartment.DataValueField = "ledgerNumber";
            //ddlDepartment.DataBind();
            //ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            return ""; 
        }
    } 
    public int updateEmergencyBillAmounts(MySqlTransaction tnx, string LedgerTnxNo)
    {
        try
        {
            string UpdateQuery = "Call updateEmergencyBillAmounts(" + LedgerTnxNo + ")";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateQuery);
            return 1;
        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

}