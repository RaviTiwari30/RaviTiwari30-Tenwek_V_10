using System.Net;
using cfg = System.Configuration.ConfigurationManager;

/// <summary>
/// Summary description for AllGlobalFunction
/// </summary>
public class AllGlobalFunction
{
    public const string LabID = "LAB", BranchID = "BRANCH";
    public static string Location = cfg.AppSettings["Location"];
    public static string LocationDummy = cfg.AppSettings["LocationDummy"];
    public static string LocationIPD = cfg.AppSettings["LocationIPD"];
    public static string LocationPur = cfg.AppSettings["LocationPur"];
    public static string LocationPatReturn = cfg.AppSettings["LocationPatReturn"];
    public static string LocationUpdate = cfg.AppSettings["LocationUpdate"];
    public static string LocationNMPurchase = cfg.AppSettings["LocationNMPurchase"];
    public static string LocationAdjust = cfg.AppSettings["LocationAdjust"];
    public static string NonMedicalAdjust = cfg.AppSettings["NonMedicalAdjust"];
    public static string LabIPD = cfg.AppSettings["LabIPD"];
    public static string LabOPD = cfg.AppSettings["LabOPD"];
    public static string HospCode = cfg.AppSettings["HospCode"];
    public static string THospCode = cfg.AppSettings["THospCode"];
    public static string CHospCode = cfg.AppSettings["CHospCode"];
    public static string LHospCode = cfg.AppSettings["LHospCode"];
    public static string Panel = Resources.Resource.DefaultPanel;
    public static string MachineDB = cfg.AppSettings["MachineDB"];
    public static string EmailSubject = cfg.AppSettings["MailSub"];
    public static string EmailID_From = cfg.AppSettings["FromMail"];
    public static string MedicalDeptLedgerNo = cfg.AppSettings["MedicalDeptLedgerNo"];
    public static string GeneralDeptLedgerNo = cfg.AppSettings["GeneralDeptLedgerNo"];
    public static string StroeHospCode = cfg.AppSettings["StoreHospCode"];
    public static string LocationCorpse = cfg.AppSettings["LocationCorpse"];
    public static string[] MedicineType = { "", "Tablet", "Syrup", "EyeDrop", "EarDrop", "NosalDrop", "Capsule", "Tube", "Powder", "Lotion", "Cream", "Immunization", "Injection", "Suspension", "Emulsion", "Sachet", "Inhaler", "Rotacap", "Puff", "Pellet", "Ointment" };
    public static string[] MedicineTab = { "", "2.5ml", "5ml", "7.5ml", "10ml", "15ml", "20ml", "1", "2", "1/2", "3/4", "3", "4", "5", "6", "7", "8", "9", "10" };
    public static string[] MedicineTimes = { "", "SOS", "QDS", "HS", "BD", "OD", "TDS", "AM", "PM", "Once Daily", "30 Min", "At Night", "1 Hourly", "2 Hourly", "3 Hourly", "4 Hourly", "6 Hourly", "8 Hourly", "12 Hourly", "STAT", "1 Times", "2 Times", "3 Times", "4 Times", "5 Times", "6 Times", "7 Times", "8 Times", "9 Times", "10 Times", "11 Times", "12 Times", "13 Times", "14 Times", "15 Times", "16 Times", "17 Times", "18 Times", "19 Times", "20 Times", "When Needed", "PRN" };
    public static string[] MedicineDays = { "", "1 Day", "2 Days", "3 Days", "4 Days", "5 Days", "6 Days", "7 Days", "8 Days", "9 Days", "10 Days", "11 Days", "12 Days", "13 Days", "20 Days", "1 Week", "2 Weeks", "3 Weeks", "6 Weeks", "7 Weeks", "1 Month", "2 Months", "3 Months", "4 Months", "5 Months", "1/2 yr", "1 yr", "2 yrs", "> 2 yrs", "Life Long" };
    public static string[] SymptomDuration = { "0 Day", "1 Day", "2 Days", "3 Days", "4 Days", "5 Days", "6 Days", "7 Days", "1 Week", "2 Weeks", "3 Weeks", "1 Month", "2 Months", "3 Months", "4 Months", "5 Months", "1/2 yr", "1 yr", "2 yrs", "> 2 yrs " };
    public static string[] BloobGroup = { "NA", "O+", "O-", "A+", "B+", "AB+", "A-", "B-" };
    public static string[] NameTitle = { "Mr.", "Mrs.", "Miss.", "B/O.","Dr." };
    public static object[] NameTitleWithGender = { new { title = "Mr.", gender = "Male" }, new { title = "Mrs.", gender = "Female" }, new { title = "Miss.", gender = "Female" }, new { title = "Master", gender = "Male" }, new { title = "Baby", gender = "" }, new { title = "B/O.", gender = "" }, new { title = "Dr.", gender = "" }, new { title = "Prof.", gender = "" }, new { title = "Madam", gender = "Female" }, new { title = "Sister", gender = "Female" }, new { title = "NO", gender = "Female" } };
    //public static object[] NameTitleWithGender = { new { title = "", gender = "UnKnown" }, new { title = "Mr.", gender = "Male" }, new { title = "Ms.", gender = "Female" }, new { title = "B/O.", gender = "UnKnown" } };
    public static string[] Instruments = { "Mesa", "Denali", "Wego", "ISOLA", "VSP", "PLIF", "TCIF", "Harms Cage", "Exactec Knee", "Exactec HIP", "Strayker Knee", "Strayker", "Trauma details", "Cast details" };
    public static string[] Eye = { "LE", "RE" };
    public static string[] VisionType = { "Unaided", "Aided", "With Pin Hole" };
    public static string[] VisionValue = { " ", "6/60", "6/60(p)", "6/36", "6/36(p)", "6/18", "6/18(p)", "6/12", "6/12(p)", "6/9", "6/9(p)", "6/6", "6/6(p)", "6/5" };
    public static string[] PreviousGlassShape = { "Spherical", "Cylndrical" };
    public static string[] PreviousGlassType = { "Convex", "Concave" };
    public static string[] PreviousGlassValue = {" ", "0.25", "0.50", "0.75", "1.00", "1.25", "1.50", "1.75", "2.00", "2.25", "2.50", "2.75", "3.00", "3.25", "3.50", "3.75", "4.00", "4.25", "4.50", "4.75", "5.25", "5.50", "5.75", "6.00", "6.25", "6.50", "6.75", "7.00", "7.25", "7.50", "7.75", "8.00", "8.25", "8.50", "8.75", "9.00", "9.25", "9.50", "9.75", "10.25", "10.50", "10.75", "11.00", "11.25", "11.50", "11.75", "12.00", "12.25", "12.50", "12.75", "13.00", "13.25", "13.50", "13.75", "14.00", "14.25", "14.50", "14.75", "15.25", "15.50", "15.75", "16.00", "16.25", "16.50", "16.75", "17.00", "17.25", "17.50", "17.75", "18.00", "18.25", "18.50", "18.75", "19.00", "19.25", "19.50", "19.75" };
    public static string[] CylindricalAngle = {" ","0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "145", "146", "147", "148", "149", "150", "151", "152", "153", "154", "155", "156", "157", "158", "159", "160", "161", "162", "163", "164", "165", "166", "167", "168", "169", "170", "171", "172", "173", "174", "175", "176", "177", "178", "179", "180"};
    public static string[] KinRelation = { "Self", "Father", "Son", "Wife", "Daughter", "Husband", "Gaurd", "Mother", "Brother", "Uncle", "Sister", "Other" };
    public static string[] Medicinenextdosetime = {"", "1 Hour","2 Hour","3 Hour","4 Hour","5 Hour","6 Hour","7 Hour","8 Hour", "9 Hour","10 Hour" , "11 Hour","12 Hour" };
    public static string[] DischargeType = { "Normal", "LAMA", "Absconding", "Discharge On Request", "Death", "Patient On Leave", "Referred","Transfer On Requrest" };
    public static string[] MartialStatus = { "", "Married", "Single", "Divorced", "Widowed", "Others" };
    public static string[] DeliveryType = { "NVD", "LSCS", "FORCEP VACCUM", "BREECH DELIVERY" };
    public static string[] DeliveryWeeks = { "20 Weeks", "21 Weeks", "22 Weeks", "23 Weeks", "24 Weeks", "25 Weeks", "26 Weeks", "27 Weeks", "28 Weeks", "29 Weeks", "30 Weeks", "31 Weeks", "32 Weeks", "33 Weeks", "34 Weeks", "35 Weeks", "36 Weeks", "37 Weeks", "38 Weeks", "39 Weeks", "40 Weeks", "41 Weeks", "42 Weeks", "43 Weeks", "44 Weeks", "45 Weeks", "46 Weeks", "47 Weeks", "48 Weeks" };
    public static string[] DeliveryDays = { "0 Day", "1 Day", "2 Days", "3 Days", "4 Days", "5 Days", "6 Days", "7 Days" };
    public static string[] ReligiousAffiliation = { "Select", "Buddhism", "Christianity", "Hinduism", "Islam", "Others" };
    public static string[] Race = { "Select", "Malay", "Chinese", "Indian", "Sabah", "Bidayuh", "Others" };
    public static string[] Route = {"Ear Drops", "Epidural", "Eye Drops", "Inhaled", "Intradermal", "Intramuscular (IM)", "Intraterial", "Intravenours (IV)", "Nasal", "Nebulized", "Oral or NG (PO)", "Other (See Remarks)", "Rectal (PR)", "Subcutaneous (SC)", "Sublingal (SL)", "Swish and Swallow", "Topical", "Transdermal Patch", "Vaginal (PV)" };
    public static string[] FreQuency = { "Select", "od(once in a day)", "bid(twice a day)", "tid(three times a day)", "qid(four times a day)", "ac(before meals)", "pc(After meals)", "STAT", "HS(At Bed Time)", "SOS(if necessary)", "Every One Hour", "Every Two Hour once", "Every Three Hour Once", "Every Four Hour Once" };
    public static string[] Time = { " ", "1-1-1-1", "1-1-1-0", "1-1-0-1", "1-0-1-1", "0-1-1-1", "1-0-0-1", "1-1-0-0", "1-0-1-0", "0-1-1-0", "1-0-0-0", "0-1-0-0", "0-0-1-0", "0-0-0-1" };
    public static string[] Validity = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30" };
    public static object[] BG = { new { BloodGroup = "NA" }, new { BloodGroup = "O+" }, new { BloodGroup = "O-" }, new { BloodGroup = "A+" }, new { BloodGroup = "B+" }, new { BloodGroup = "AB+" }, new { BloodGroup = "A-" }, new { BloodGroup = "B-" } };
    public static object[] taxCalculateOn = { 
                                                new { value = "RateAD", text = "RateAD" }, 
                                                new { value = "MRP", text = "MRP" },
                                                new { value = "Rate", text = "Rate" },
                                                new { value = "RateRev", text = "Rate Rev." },
                                                new { value = "RateExcl", text = "Rate Excl." },
                                                new { value = "MRPExcl", text = "MRP Excl." },
                                                new { value = "ExciseAmt", text = "Excise Amt." },
                                            };


    public static string MachineIPAddress()
    {
        System.Net.IPHostEntry ip = Dns.GetHostEntry(Dns.GetHostName());
        IPAddress[] addr = ip.AddressList;
        return addr.GetValue(0).ToString();
    }
    public static string MedicalStoreID = "STO00001";
    public static string GeneralStoreID = "STO00002";
    public enum DischargeProcessStep {PatientAdmission=1,PlanDischarge=2, FinalDoctorVisit = 3,DischargeSummaryPrepared=4,DischargeSummaryApproved=5,DischargeIntimation=6, MedicalClearance = 7,BillFreeze=8,Discharge=9,BillGenerate=10, PatientClearance = 11, NursingClearance = 12, RoomClearance = 13 };
    public static string SMSAPI = "http://bulksmsgateway.co.in/SMS_API/sendsms.php?username=demo&password=123456&mobile={Mobile}&sendername=NETWLD&message={Sms}";

    public static string PurchaseLeadTime = "3"; //In Days

    public static string errorMessage = "Error occurred, Please contact administrator.", saveMessage = "Record Saved Successfully.", maxDiscountValidationErrorMessage = "Invalid Discount ! </br><b class=" + "patientInfo" + " style=" + "font-size: 11px;" + ">Max Discount Eligible : ";
    public static string[] MedicineDoseType = { "Tablet", "Supp","Hello" };
}
