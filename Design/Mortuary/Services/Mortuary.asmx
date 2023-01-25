<%@ WebService Language="C#" Class="WebService" %>
using System;
using System.Text;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.IO;



[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(EnableSession = true, Description = "Search Death Patient in Mortuary")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SerachDeathPerson(string MRNo, string IPDNo, string FirstName, string LastName, string FromDate, string ToDate)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("(SELECT PMH.DischargeIntimateBy,IFNULL((SELECT NAME as Room FROM `room_master` WHERE roomId=(SELECT RoomID FROM patient_ipd_profile WHERE transactionid=PMH.TransactionID limit 1)),'Casualty')Ward,PM.Mobile,PM.PatientID Patient_ID,REPLACE(PMH.TransactionID,'ISHHI','')Transaction_ID, REPLACE(PMH.TransNo,'ISHHI','')IPDNo ,PM.PName,PM.Gender,PM.Age,DATE_FORMAT(PMH.TimeOfDeath,'%d-%b-%Y')DOD,  ");
        Query.Append("TIME_FORMAT(PMH.TimeOfDeath,'%H:%i %p')DOT,(SELECT TypeOfDeath FROM typeofdeath WHERE ID=PMH.TypeOfDeathID)TypeOfDeath  ");
        Query.Append("FROM patient_master PM INNER JOIN patient_medical_history PMH ON PM.PatientID=PMH.PatientID WHERE Type IN('IPD','EMG') AND DischargeType='Death' and (IsReceived=0 OR IsReceived is null ) ");

        if (MRNo != "")
        {
            Query.Append("AND PM.PatientID='" + MRNo + "'  ");
        }

        if (IPDNo != "")
        {
            Query.Append("AND PMH.TransactionID='" + string.Concat("ISHHI", IPDNo) + "'  ");
        }

        if (FirstName != "")
        {
            Query.Append("AND PM.PFirstName Like '" + FirstName + "%' ");
        }

        if (LastName != "")
        {
            Query.Append("AND PM.PLastName Like '" + LastName + "%'   ");
        }

        if (MRNo == "" && IPDNo == "" && LastName == "" && FirstName == "")
        {
            Query.Append("AND DATE(PMH.TimeOfDeath)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(PMH.TimeOfDeath)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }

        Query.Append("ORDER BY DateOfVisit)");

        Query.Append(" union  (SELECT PMH.DischargeIntimateBy,IFNULL((SELECT NAME as Room FROM `room_master` WHERE roomId=(SELECT RoomID FROM patient_ipd_profile WHERE transactionid=PMH.TransactionID limit 1)),'Casualty')Ward,PM.Mobile,PM.PatientID Patient_ID,REPLACE(PMH.TransactionID,'ISHHI','')Transaction_ID, REPLACE(PMH.TransNo,'ISHHI','')IPDNo ,PM.PName,PM.Gender,PM.Age,DATE_FORMAT(PMH.TimeOfDeath,'%d-%b-%Y')DOD,  ");
        Query.Append("TIME_FORMAT(PMH.TimeOfDeath,'%H:%i %p')DOT,(SELECT TypeOfDeath FROM typeofdeath WHERE ID=PMH.TypeOfDeathID)TypeOfDeath  ");
        Query.Append("FROM patient_master PM INNER JOIN patient_medical_history PMH ON PM.PatientID=PMH.PatientID WHERE Type IN('IPD','EMG') AND DischargeType='Death' and IsDischargeIntimate='1' ");
        if (MRNo != "")
        {
            Query.Append("AND PM.PatientID='" + MRNo + "'  ");
        }

        if (IPDNo != "")
        {
            // Query.Append("AND PMH.TransactionID='" + string.Concat("ISHHI", IPDNo) + "'  ");
            Query.Append("AND PMH.TransNo='" +  IPDNo+ "'  ");
        }

        if (FirstName != "")
        {
            Query.Append("AND PM.PFirstName Like '" + FirstName + "%' ");
        }


        if (LastName != "")
        {
            Query.Append("AND PM.PLastName Like '" + LastName + "%'   ");
        }

        if (MRNo == "" && IPDNo == "" && LastName == "" && FirstName == "")
        {
            Query.Append("AND DATE(PMH.TimeOfDeath)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(PMH.TimeOfDeath)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }

        Query.Append("ORDER BY DateOfVisit)");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }

    [WebMethod(EnableSession = true, Description = "Save Received Death Patients in Mortuary")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveCorpseReceive(object corpseDetail)
    {
        string result = "0";
        List<Mortuaty_Receive> corpseReceive = new JavaScriptSerializer().ConvertToType<List<Mortuaty_Receive>>(corpseDetail);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int i = 0; i < corpseReceive.Count; i++)
            {
                string Query = "UPDATE patient_medical_history SET IsReceived=1,ReceivedDate=NOW(),ReceivedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',BroughtBy='" + Util.GetString(corpseReceive[i].BroughtBy) + "',ReceivedRemarks='" + Util.GetString(corpseReceive[i].ReceivedRemarks) + "' WHERE TransactionID='" +   Util.GetString(corpseReceive[i].Transaction_ID) + "'";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);
            }

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;
    }



    [WebMethod(EnableSession = true, Description = "Search Corpse for Deposite or Released")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string serachReceivedCorpse(string MRNo, string IPDNo, string FirstName, string LastName, string FromDate, string ToDate, string CorpseType, string ButtonType)
    {
        string str = ButtonType;
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT PM.PatientID Patient_ID,PMH.TransNo IPDNO,REPLACE(PMH.TransactionID,'ISHHI','')Transaction_ID,PM.PName,PM.Gender,PM.Age,PM.Mobile,PMH.DoctorID Doctor_ID,  ");
        Query.Append("(SELECT CONCAT(Title,' ',NAME) FROM doctor_master WHERE doctor_id=PMH.DoctorID limit 1)DocName,DATE_FORMAT(PMH.TimeOfDeath,'%d-%b-%Y')DOD,TIME_FORMAT(PMH.TimeOfDeath,'%H:%i %p')DOT,  ");
        Query.Append("IsReleased,IsDeposited,(SELECT TypeOfDeath FROM typeofdeath WHERE ID=PMH.TypeOfDeathID)TypeOfDeath,PMH.CauseOfDeath,IFNULL((SELECT PatientType FROM patient_type WHERE ID=PMH.PatientTypeID),'')TypeOfPatient,Date_Format(PMH.ReceivedDate,'%d-%b-%Y')ReceivedDate,(SELECT `Name` FROM employee_master WHERE EmployeeID=PMH.ReceivedBy)ReceivedBy,PMH.BroughtBy,PMH.ReceivedRemarks,PMH.CollectedBy,(SELECT `Name` FROM employee_master WHERE EmployeeID=PMH.ReleasedBy)ReleasedBy ");
        Query.Append("FROM patient_master PM INNER JOIN patient_medical_history PMH ON PM.PatientID=PMH.PatientID where Type IN('IPD','EMG') AND DischargeType='Death' and  IsReceived=1  ");
        //and PMH.IsDischargeIntimate=1 ");

        if (MRNo != "")
        {
            Query.Append("AND PM.PatientID='" + MRNo + "'  ");
        }

        if (IPDNo != "")
        {
            Query.Append("AND PMH.TransactionID='" + string.Concat("ISHHI", IPDNo) + "'  ");
        }

        if (FirstName != "")
        {
            Query.Append("AND PM.PFirstName Like '" + FirstName + "%' ");
        }

        if (LastName != "")
        {
            Query.Append("AND PM.PLastName Like '" + LastName + "%'   ");
        }

        if (MRNo == "" && IPDNo == "" && LastName == "" && FirstName == "")
        {
            Query.Append("AND DATE(PMH.TimeOfDeath)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(PMH.TimeOfDeath)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }
        if (CorpseType != "0")
        {
            if (CorpseType == "1")
            {
                Query.Append(" AND IsDeposited=0 AND IsReleased=0 ");
            }
            else
            {
                if (CorpseType == "2")
                {
                    Query.Append(" AND IsDeposited=1 ");
                }
                else
                {
                    if (CorpseType == "3")
                    {
                        Query.Append(" AND IsReleased=1 ");
                    }
                }
            }
        }
        Query.Append(" ORDER BY date(PMH.TimeOfDeath) desc ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            if (ButtonType == "Expoting....")
            {
                DataTable dtt = StockReports.GetDataTable(Query.ToString());
                dtt.Columns.Remove("IsReleased");
                dtt.Columns.Remove("IsDeposited");
                dtt.Columns.Remove("Doctor_ID");
                dtt.Columns.Remove("TypeOfPatient");
                dtt.Columns.Remove("Mobile");
                dtt.Columns.Remove("CauseOfDeath");
                dtt.Columns["PName"].ColumnName = "Patient Name";
                dtt.Columns["DOD"].ColumnName = "Date of Death";
                dtt.Columns["DOT"].ColumnName = "Time of Death";
                dtt.Columns["Transaction_ID"].ColumnName = "IPD No.";
                dtt.Columns["Patient_ID"].ColumnName = "UHID";
                Session["dtExport2Excel"] = dtt;
                Session["ReportName"] = "Mortuary Corpse Report";
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else if (ButtonType == "Searching...")
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }

        return "0";
    }

    [WebMethod(EnableSession = true, Description = "Save Released Corpse Details")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveReleasedDetailDirect(string IPDNo, string CollectedBy, string ContactNo, string Address, string Remarks)
    {
        string result = "0";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string Query = "UPDATE patient_medical_history SET IsReleased=1,ReleasedDate=NOW(),ReleasedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',CollectedBy='" + Util.GetString(CollectedBy) + "',CollectedContact='" + Util.GetString(ContactNo) + "',CollectedAddress='" + Util.GetString(Address) + "',ReleasedRemarks='" + Util.GetString(Remarks) + "' WHERE TransactionID=" + IPDNo + ""; // WHERE TransactionID='" + string.Concat("ISHHI", IPDNo) + "'
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;
    }


    [WebMethod(EnableSession = true, Description = "Search Corpse for Deposite")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string IsCorpseDeposited(string MRNo)
    {
        int Rows = 0;
        Rows = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM mortuary_corpse_master WHERE PatientID='" + MRNo + "'  "));
        if (Rows > 0)
        {
            return "1";
        }
        return "0";
    }

    [WebMethod(EnableSession = true, Description = "Bind Corpse Details at Desposte Time")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindCorpseDetails(string PatientID)
    {
        StringBuilder Query = new StringBuilder();
        //Query.Append("SELECT PM.Patient_ID,PM.PFirstName,PM.PLastName,PM.PName,PM.Gender,PM.Age,PM.ReligiousAffiliation,PM.Ethnicity,PM.Locality,PM.House_No,PM.City,PM.Country,  ");
        //Query.Append("PM.EmergencyNotify,PM.EmergencyRelationShip,PM.EmergencyPhoneNo,PM.EmergencyAddress,PM.TypeOfPatient,PMH.Transaction_ID,PMH.Doctor_ID,  ");
        //Query.Append("DATE_FORMAT(PMH.TimeOfDeath,'%d-%b-%Y')DOD,TIME_FORMAT(PMH.TimeOfDeath,'%H:%i %p')DOT,(SELECT TypeOfDeath FROM typeofdeath WHERE ID=PMH.TypeOfDeathID)TypeOfDeath   ");
        //Query.Append("FROM patient_master PM INNER JOIN patient_medical_history PMH ON PM.Patient_ID=PMH.Patient_ID WHERE PMH.Transaction_ID=CONCAT('ISHHI','" + IPDNo + "') ");

        //Query.Append("SELECT Date_Format(PM.DateEnrolled,'%d-%c-%Y')DateEnrolled,PM.Patient_ID,PM.PFirstName,PM.PLastName,PM.PName,PM.Gender,PM.Age,PM.ReligiousAffiliation,PM.Ethnicity,PM.Locality,PM.House_No,PM.City,PM.Country,PM.countryID,  ");
        //Query.Append("PM.EmergencyNotify,PM.EmergencyRelationShip,PM.EmergencyPhoneNo,PM.EmergencyAddress,PM.EmergencyEmailID,PM.TypeOfPatient,PMH.Transaction_ID,PMH.Doctor_ID,  ");
        //Query.Append("DATE_FORMAT(PMH.TimeOfDeath,'%d-%b-%Y')DOD,TIME_FORMAT(PMH.TimeOfDeath,'%H:%i %p')DOT,(SELECT TypeOfDeath FROM typeofdeath WHERE ID=PMH.TypeOfDeathID)TypeOfDeath,PMH.Panel_ID   ");
        //Query.Append("FROM patient_master PM INNER JOIN patient_medical_history PMH ON PM.Patient_ID=PMH.Patient_ID WHERE PMH.DischargeType='Death' AND PMH.Patient_ID='" + PatientID + "' ");

        Query.Append("SELECT PMH.DischargeIntimateBy,PMH.TransactionID as Transaction_ID,PM.Mobile,Date_Format(PM.DateEnrolled,'%d-%c-%Y')DateEnrolled,PM.PatientID Patient_ID,PM.PFirstName,PM.PLastName,PM.PName,PM.Gender,PM.Age,PM.ReligiousAffiliation,PM.Ethnicity,PM.Locality,PM.House_No,PM.City,PM.Country,PM.countryID,  ");
        Query.Append("PM.EmergencyNotify,PM.EmergencyRelationShip,PM.EmergencyPhoneNo,PM.EmergencyAddress,IFNULL((SELECT PatientType FROM patient_type WHERE ID=PMH.PatientTypeID),'')TypeOfPatient,PMH.TransactionID Transaction_ID, PMH.DoctorID Doctor_ID,  ");
        Query.Append("DATE_FORMAT(PMH.TimeOfDeath,'%d-%b-%Y')DOD,TIME_FORMAT(PMH.TimeOfDeath,'%H:%i %p')DOT,(SELECT TypeOfDeath FROM typeofdeath WHERE ID=PMH.TypeOfDeathID)TypeOfDeath,PMH.PanelID Panel_ID   ");
        Query.Append("FROM patient_master PM left JOIN patient_medical_history PMH ON PM.PatientID=PMH.PatientID and  PMH.DischargeType='Death'  WHERE PM.PatientID='" + PatientID + "' ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "";
    }

    [WebMethod(EnableSession = true, Description = "Bind Corpse Details at Desposte Time")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindCorpseMasterAndDeposite(string ID)
    {
        StringBuilder Query = new StringBuilder();

        Query.Append("SELECT IFNULL(CD.DoctorID,0) AS DischargeIntimateBy,CONCAT(mfm.RackName,'-',mfm.rack_No,'/ShelfNo:',mfm.ShelfNo,'/RoomNo:',mfm.Room_No)Freezer,"+
" DATE_FORMAT(CM.DeathDate,'%d-%M-%Y') AS DeathDate1,TIME_FORMAT(CM.DeathTime, '%h:%i %p') AS DeathTime1,"+
" Cd.*,Cm.* FROM mortuary_corpse_master CM "+
" INNER JOIN mortuary_corpse_deposite CD ON cm.`Corpse_ID`=CD.`CorpseID` "+
" INNER JOIN mortuary_freezer_master mfm ON mfm.RackID=CD.FreezerID WHERE CM.ID='" + ID + "' ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "";
    }

    
    [WebMethod(EnableSession = true, Description = "Update Corpse Deposite Information")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateCorpseDetails(object CorpseMaster, object CorpseDeposite)
    {
        string result = "0";
        List<Mortuary_Corpse_Master> dataCorpseMaster = new JavaScriptSerializer().ConvertToType<List<Mortuary_Corpse_Master>>(CorpseMaster);
        List<Mortuary_Corpse_Deposite> dataCorpseDeposite = new JavaScriptSerializer().ConvertToType<List<Mortuary_Corpse_Deposite>>(CorpseDeposite);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            
            var sqlCMD = "	UPDATE  mortuary_corpse_master SET Location=@vLoc,HospCode=@vHosp  ,TransactionID=@vTransaction_ID,"+
	"FirstName=@vFirstName, LastName=@vLastName,CName=@vCName ,Age=@vAge,Gender=@vGender,DeathDate=@vDeathDate,DeathTime=@vDeathTime,DeathType=@vDeathType ,"+
	"Nationality=@vNationality,Religion=@vReligion,Locality=@vLocality,Address=@vAddress,City=@vCity,Country=@vCountry,OtherAddress=@vOtherAddress,`Type`=@vType	"+ 
	",PlaceOfDeath=@vPlaceOfDeath,	HospitalName=@vHospitalName,RelativeName=@vRelativeName,TypeOfRelation=@vTypeOfRelation,RelativeAddress=@vRelativeAddress"+
	",RelativeContact=@vRelativeContact,	RelativeEmail=@vRelativeEmail,UpdatedBy=@vUpdatedBy,UpdatedDate=NOW(),HospCentreID=@vHospCentreID,PermitNo=@vPermitNo,NationalID=@vNationalID"+
	",InfectiousRemark=@vInfectiousRemark,Mobile=@vMobile	 WHERE ID=@vID;";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                vLoc =  dataCorpseMaster[0].Location,
                vHosp =  dataCorpseMaster[0].HospCode,
                //vCorpse_ID = dataCorpseMaster[0].Corpse_ID,
                //vPatient_ID =  dataCorpseMaster[0].Patient_ID,
                vTransaction_ID = dataCorpseMaster[0].Transaction_ID,
                vFirstName =dataCorpseMaster[0].FirstName,
                vLastName = dataCorpseMaster[0].LastName,
                vCName = dataCorpseMaster[0].CName,
                vAge = dataCorpseMaster[0].Age,
                vGender = dataCorpseMaster[0].Gender,
                vDeathDate = dataCorpseMaster[0].DeathDate,
                vDeathTime = dataCorpseMaster[0].DeathTime,
                vDeathType = dataCorpseMaster[0].DeathType,
                vNationality = dataCorpseMaster[0].Nationality,
                vReligion = dataCorpseMaster[0].Religion,
                vLocality = dataCorpseMaster[0].Locality,
                vAddress = dataCorpseMaster[0].Address,
                vCity = dataCorpseMaster[0].City,
                vCountry = dataCorpseMaster[0].Country,
                vOtherAddress = dataCorpseMaster[0].OtherAddress,
                vType = dataCorpseMaster[0].Type,
                vPlaceOfDeath = dataCorpseMaster[0].PlaceOfDeath,
                vHospitalName = dataCorpseMaster[0].HospitalName,
                vRelativeName = dataCorpseMaster[0].RelativeName,
                vTypeOfRelation = dataCorpseMaster[0].TypeOfRelation,
                vRelativeAddress = dataCorpseMaster[0].RelativeAddress,
                vRelativeContact = dataCorpseMaster[0].RelativeContact,
                vRelativeEmail = dataCorpseMaster[0].RelativeEmail,
                vUpdatedBy = Session["ID"].ToString(),
                vHospCentreID = dataCorpseMaster[0].HospCentreID,
                vPermitNo = dataCorpseMaster[0].PermitNo,
                vNationalID = dataCorpseMaster[0].NationalID,
                vInfectiousRemark = dataCorpseMaster[0].NationalID,
                vMobile = dataCorpseMaster[0].Mobile,
                vID = dataCorpseMaster[0].ID
            });
            string depositeid = StockReports.ExecuteScalar("SELECT ID 	FROM 	mortuary_corpse_deposite  WHERE  CorpseID=(Select Corpse_ID from mortuary_corpse_master where ID='" + dataCorpseMaster[0].ID + "') LIMIT 0, 1");


            var sqlCMD1 = "	UPDATE  mortuary_corpse_deposite  SET Location=@vLocation,HospCode=@vHospCode,DoctorID=@vDoctorID,InDate=NOW()" +
",Remarks=@vRemarks,BroughtBy=@vBroughtBy,AuthDoctor=@vAuthDoctor,FreezerID=@vFreezerID,PanelID=@vPanel_ID,UpdatedBy=@vUpdatedBy,UpdatedDate=NOW(),"+
"HospCentreID=@vHospCentreID,BroughtFrom=@vBroughtFrom"+
" WHERE ID=@vID";
            excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
            {
                vLocation = dataCorpseDeposite[0].Location,
                vHospCode = dataCorpseDeposite[0].HospCode,
                //vTransaction_ID = dataCorpseDeposite[0].Transaction_ID,
                //vCorpseID = dataCorpseDeposite[0].CorpseID,
                vDoctorID = dataCorpseDeposite[0].DoctorID,
                vRemarks = dataCorpseDeposite[0].Remarks,
                vBroughtBy = dataCorpseDeposite[0].BroughtBy,
                vAuthDoctor = dataCorpseDeposite[0].AuthDoctor,
                vFreezerID = dataCorpseDeposite[0].FreezerID,
                vPanel_ID = dataCorpseDeposite[0].Panel_ID,
                vUpdatedBy = Session["ID"].ToString(),
                //vCentreID = dataCorpseDeposite[0].CentreID,
                vHospCentreID = dataCorpseDeposite[0].HospCentreID,
                vBroughtFrom = dataCorpseDeposite[0].BroughtFrom,
                vID = depositeid
            });
           
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

            return "Error occurred, Please contact Administrator";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    
    [WebMethod(EnableSession = true, Description = "Save Corpse Deposite Information")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveCorpseDetails(object CorpseMaster, object CorpseDeposite)
    {
        string result = "0";
        List<Mortuary_Corpse_Master> dataCorpseMaster = new JavaScriptSerializer().ConvertToType<List<Mortuary_Corpse_Master>>(CorpseMaster);
        List<Mortuary_Corpse_Deposite> dataCorpseDeposite = new JavaScriptSerializer().ConvertToType<List<Mortuary_Corpse_Deposite>>(CorpseDeposite);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Mortuary_Corpse_Master ObjMaster = new Mortuary_Corpse_Master(tranx);
            ObjMaster.Patient_ID = dataCorpseMaster[0].Patient_ID;
            ObjMaster.Transaction_ID = dataCorpseMaster[0].Transaction_ID;
            ObjMaster.FirstName = dataCorpseMaster[0].FirstName;
            ObjMaster.LastName = dataCorpseMaster[0].LastName;
            ObjMaster.CName = dataCorpseMaster[0].CName;
            ObjMaster.Age = dataCorpseMaster[0].Age;
            ObjMaster.Gender = dataCorpseMaster[0].Gender;
            ObjMaster.DeathDate = dataCorpseMaster[0].DeathDate;
            ObjMaster.DeathTime = dataCorpseMaster[0].DeathTime;
            ObjMaster.DeathType = dataCorpseMaster[0].DeathType;
            ObjMaster.Nationality = dataCorpseMaster[0].Nationality;
            ObjMaster.Religion = dataCorpseMaster[0].Religion;
            ObjMaster.Locality = dataCorpseMaster[0].Locality;
            ObjMaster.Address = dataCorpseMaster[0].Address;
            ObjMaster.City = dataCorpseMaster[0].City;
            ObjMaster.Country = dataCorpseMaster[0].Country;
            ObjMaster.OtherAddress = dataCorpseMaster[0].OtherAddress;
            ObjMaster.PermitNo = dataCorpseMaster[0].PermitNo;
            ObjMaster.Mobile = dataCorpseMaster[0].Mobile;
            ObjMaster.NationalID = dataCorpseMaster[0].NationalID;
            ObjMaster.InfectiousRemark = dataCorpseMaster[0].InfectiousRemark;
            ObjMaster.Type = dataCorpseMaster[0].Type;
            ObjMaster.PlaceOfDeath = dataCorpseMaster[0].PlaceOfDeath;
            ObjMaster.HospitalName = dataCorpseMaster[0].HospitalName;
            ObjMaster.TypeOfRelation = dataCorpseMaster[0].TypeOfRelation;
            ObjMaster.RelativeName = dataCorpseMaster[0].RelativeName;
            ObjMaster.RelativeAddress = dataCorpseMaster[0].RelativeAddress;
            ObjMaster.RelativeContact = dataCorpseMaster[0].RelativeContact;
            ObjMaster.RelativeEmail = dataCorpseMaster[0].RelativeEmail;
            ObjMaster.CreatedBy = Util.GetString(HttpContext.Current.Session["ID"].ToString());
            ObjMaster.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            //ObjMaster.HospCentreID = Util.GetInt(HttpContext.Current.Session["HospCentreID"].ToString());
            ObjMaster.Corpse_ID = ObjMaster.Insert();


            Mortuary_Corpse_Deposite ObjDeposite = new Mortuary_Corpse_Deposite(tranx);
            ObjDeposite.CorpseID = ObjMaster.Corpse_ID;
            ObjDeposite.DoctorID = dataCorpseDeposite[0].DoctorID;
            ObjDeposite.Remarks = dataCorpseDeposite[0].Remarks;
            ObjDeposite.AuthDoctor = dataCorpseDeposite[0].AuthDoctor;
            ObjDeposite.BroughtBy = dataCorpseDeposite[0].BroughtBy;
            ObjDeposite.BroughtFrom = dataCorpseDeposite[0].BroughtFrom;
            ObjDeposite.FreezerID = dataCorpseDeposite[0].FreezerID;
            ObjDeposite.Panel_ID = dataCorpseDeposite[0].Panel_ID;
            ObjDeposite.CreatedBy = Util.GetString(HttpContext.Current.Session["ID"].ToString());
            ObjDeposite.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            //ObjDeposite.HospCentreID = Util.GetInt(HttpContext.Current.Session["HospCentreID"].ToString());
            ObjDeposite.Transaction_ID = ObjDeposite.Insert();

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE mortuary_freezer_master SET IsVacant=1,UpdatedBy='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' WHERE RackID='" + ObjDeposite.FreezerID + "'");

            string Query = "";
            if (ObjMaster.Transaction_ID != "")
            {
                Query = "SELECT '" + ObjMaster.Corpse_ID + "' AS Corpse_ID,'" + ObjDeposite.Transaction_ID + "' AS Transaction_ID,pmh.ScheduleChargeID,pmh.PanelID Panel_ID,PIP.IPDCaseTypeID,pip.IPDCaseTypeID_Bill,'" + ObjDeposite.DoctorID + "' AS Doctor_ID, " +
                                "im.ItemID,sc.SubCategoryID,sc.Name SubCategoryName,IFNULL(rt.ItemCode,'')ItemCode,IF(IFNULL(rt.ItemDisplayName,'')='',im.typename,rt.ItemDisplayName) " +
                                "ItemDisplayName,(rt.Rate)Rate,'Mortuary-Billing' AS Typeoftnx,'20' AS TnxTypeID,cf.ConfigID ConfigRelationID,adj.PatientLedgerNo,im.ToBeBilled,im.IsUsable " +
                                "FROM patient_ipd_profile pip INNER JOIN patient_medical_history pmh ON pip.TransactionID = pmh.TransactionID " +
                                "INNER JOIN patient_medical_history adj ON pmh.TransactionID=adj.TransactionID INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID " +
                                "INNER JOIN f_ratelist_ipd rt ON rt.ScheduleChargeID = pmh.ScheduleChargeID INNER JOIN f_itemmaster im  ON rt.ItemID = im.ITemID " +
                                "INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON sc.CategoryID = cf.CategoryID AND im.ItemID = rt.ItemID AND rt.IPDCaseTypeID = PIP.IPDCaseTypeID_Bill " +
                                "WHERE im.ItemID='8795' AND im.IsActive=1  AND rt.IsCurrent=1 AND pmh.TransactionID='" + ObjMaster.Transaction_ID + "' "+
                     "UNION ALL" +
                        " SELECT '" + ObjMaster.Corpse_ID + "' AS Corpse_ID,'" + ObjDeposite.Transaction_ID + "' AS Transaction_ID,pmh.ScheduleChargeID,pmh.PanelID Panel_ID,PIP.IPDCaseTypeID,PIP.IPDCaseTypeID AS IPDCaseTypeID_Bill,'" + ObjDeposite.DoctorID + "' AS Doctor_ID, " +
                                "im.ItemID,sc.SubCategoryID,sc.Name SubCategoryName,IFNULL(rt.ItemCode,'')ItemCode,IF(IFNULL(rt.ItemDisplayName,'')='',im.typename,rt.ItemDisplayName) " +
                                "ItemDisplayName,(rt.Rate)Rate,'Mortuary-Billing' AS Typeoftnx,'20' AS TnxTypeID,cf.ConfigID ConfigRelationID,adj.PatientLedgerNo,im.ToBeBilled,im.IsUsable " +
                                "FROM emergency_patient_details pip INNER JOIN patient_medical_history pmh ON pip.TransactionID = pmh.TransactionID " +
                                "INNER JOIN patient_medical_history adj ON pmh.TransactionID=adj.TransactionID INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID " +
                                "INNER JOIN f_ratelist_ipd rt ON rt.ScheduleChargeID = pmh.ScheduleChargeID INNER JOIN f_itemmaster im  ON rt.ItemID = im.ITemID " +
                                "INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON sc.CategoryID = cf.CategoryID AND im.ItemID = rt.ItemID AND rt.IPDCaseTypeID = PIP.IPDCaseTypeID " +
                                "WHERE im.ItemID='8795' AND im.IsActive=1  AND rt.IsCurrent=1 AND pmh.TransactionID='" + ObjMaster.Transaction_ID + "' ";
            }
            else
            {
                Query = " SELECT '" + ObjMaster.Corpse_ID + "' AS Corpse_ID,'" + ObjDeposite.Transaction_ID + "' AS Transaction_ID,rs.ScheduleChargeID, rt.PanelID Panel_ID," +
                                " '" + ObjDeposite.DoctorID + "' AS Doctor_ID, im.ItemID,sc.SubCategoryID,sc.Name SubCategoryName,IFNULL(rt.ItemCode,'')ItemCode,IF(IFNULL(rt.ItemDisplayName,'')=''," +
                                " im.typename,rt.ItemDisplayName) ItemDisplayName,(rt.Rate)Rate,'Mortuary-Billing' AS Typeoftnx,'20' AS TnxTypeID,cf.ConfigID ConfigRelationID,'CASH002' PatientLedgerNo," +
                                " im.ToBeBilled,im.IsUsable FROM f_itemmaster im  INNER JOIN f_ratelist_ipd rt ON rt.ItemID = im.ITemID" +
                                " INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON sc.CategoryID = cf.CategoryID AND im.ItemID = rt.ItemID " +
                                " INNER JOIN f_rate_schedulecharges rs ON rs.ScheduleChargeID = rt.ScheduleChargeID AND rs.IsDefault=1 AND rs.PanelID = rt.PanelID " +
                                " WHERE im.ItemID='8795' AND im.IsActive=1 AND rt.IsCurrent=1 AND rt.IPDCaseTypeID='" + Resources.Resource.Mortuary_IPDCaseType_ID + "' AND rt.PanelID='702' ";
                
             //   37231
            }

            DataTable dt = StockReports.GetDataTable(Query);

            Mortuary_Ledger_Transaction objLedTran = new Mortuary_Ledger_Transaction(tranx);
            objLedTran.LedgerNoCr = Util.GetString(dt.Rows[0]["PatientLedgerNo"]);
            objLedTran.LedgerNoDr = "LSHHI11";
            objLedTran.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());
            objLedTran.TypeOfTnx = Util.GetString(dt.Rows[0]["Typeoftnx"]);
            objLedTran.Date = DateTime.Now;
            objLedTran.Time = DateTime.Now;
            objLedTran.AgainstPONo = "";
            objLedTran.BillNo = "";
            objLedTran.DiscountOnTotal = Util.GetDecimal("0.0");
            objLedTran.GrossAmount = Util.GetDecimal(dt.Rows[0]["Rate"]);
            objLedTran.NetAmount = Util.GetDecimal(dt.Rows[0]["Rate"]);
            objLedTran.IsCancel = 0;
            objLedTran.CancelReason = "";
            objLedTran.CancelAgainstLedgerNo = "";
            objLedTran.CancelDate = Util.GetDateTime("01-Jan-0001");
            objLedTran.UserID = Util.GetString(HttpContext.Current.Session["ID"]);
            objLedTran.CorpseID = Util.GetString(dt.Rows[0]["Corpse_ID"]);
            objLedTran.TransactionID = Util.GetString(dt.Rows[0]["Transaction_ID"]);
            objLedTran.PaymentModeID = 1;
            objLedTran.Panel_ID = Util.GetString(dt.Rows[0]["Panel_ID"]);
            objLedTran.UniqueHash = Util.getHash();
            objLedTran.IpAddress = "";
            objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            //objLedTran.HospCentreID = Util.GetInt(HttpContext.Current.Session["HospCentreID"].ToString());
            string LedTxnID = objLedTran.Insert().ToString();


            Mortuary_LedgerTnxDetail objLTDetail = new Mortuary_LedgerTnxDetail(tranx);
            objLTDetail.Hospital_Id = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString()); ;
            objLTDetail.LedgerTransactionNo = LedTxnID;
            objLTDetail.ItemID = Util.GetString(dt.Rows[0]["ItemID"]);
            objLTDetail.StockID = "";
            objLTDetail.SubCategoryID = Util.GetString(dt.Rows[0]["SubCategoryID"]);
            objLTDetail.TransactionID = Util.GetString(dt.Rows[0]["Transaction_ID"]);
            objLTDetail.Rate = Util.GetDecimal(dt.Rows[0]["Rate"]);
            objLTDetail.Quantity = 1;
            objLTDetail.IsVerified = 1;
            objLTDetail.ItemName = Util.GetString(dt.Rows[0]["ItemDisplayName"]);
            objLTDetail.EntryDate = DateTime.Now;
            objLTDetail.Doctor_Id = Util.GetString(dt.Rows[0]["Doctor_ID"]);
            objLTDetail.Amount = Util.GetDecimal(1 * Util.GetDecimal(dt.Rows[0]["Rate"]));
            objLTDetail.DiscAmt = Util.GetDecimal(0);
            objLTDetail.DiscountPercentage = Util.GetDecimal(0);
            objLTDetail.DiscountReason = "";
            objLTDetail.UserID = Util.GetString(HttpContext.Current.Session["ID"]);
            objLTDetail.TnxTypeID = Util.GetInt(dt.Rows[0]["TnxTypeID"]);
            objLTDetail.ToBeBilled = Util.GetInt(dt.Rows[0]["ToBeBilled"]);
            objLTDetail.IsReusable = Util.GetString(dt.Rows[0]["IsUsable"]);
            objLTDetail.ConfigID = Util.GetInt(dt.Rows[0]["ConfigRelationID"]);
            objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            //objLTDetail.HospCentreID = Util.GetInt(HttpContext.Current.Session["HospCentreID"].ToString());
            objLTDetail.Insert();

            if (ObjMaster.Transaction_ID != "")
            {
                Query = "UPDATE patient_medical_history SET IsDeposited=1 WHERE TransactionID='" + ObjMaster.Transaction_ID + "'";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);
            }

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();

            result = ObjDeposite.Transaction_ID;
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }


        if (result != "0")
        {
            AllQuery aq = new AllQuery();
            DataTable dt = aq.GetCorpseInformation(result);

            if (dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(HttpContext.Current.Session["ID"].ToString()).Rows[0][0];
                dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                //DataTable dtLogo = All_LoadData.CrystalReportLogo();
                //ds.Tables.Add(dtLogo.Copy());

                DataTable dtLogo = CrystalReportLogo();
                ds.Tables.Add(dtLogo.Copy());

                //ds.WriteXmlSchema("D://CorpseDepositeReport.xml");

                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "CorpseDepositeReport";
            }
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Search Corpse")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SearchCorpse(string CorpseNo, string DepositeNo, string FirstName, string LastName, string FromDate, string ToDate, string Status)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT CM.PatientID, CM.TransactionID as TransactionID1,CM.InfectiousRemark,CM.Corpse_ID,CM.CName,CM.Age,CM.Gender,DATE_FORMAT(CM.DeathDate,'%d-%b-%Y')DateofDeath,TIME_FORMAT(CM.DeathTime,'%h:%i %p')TimeofDeath,CM.DeathType, ");
        Query.Append("CD.IsReleased,REPLACE(CD.TransactionID,'CRSHHI','')Transaction_ID,CD.TransactionID TransactionID,DATE_FORMAT(CD.InDate,'%d-%b-%Y %h:%i %p')DepositeDateTime,CONCAT(EM.Title,' ',EM.Name)AdmittedBy, ");
        Query.Append("IF(PM.CorpseID IS NOT NULL,1,0)IsPMRequest,PM.IsApproved,PM.IsSend,PM.IsPostmortem,CONCAT(MFM.RackName,'-',MFM.Rack_No,'/',MFM.ShelfNo)FreezerName FROM  mortuary_corpse_master CM  INNER JOIN mortuary_corpse_deposite CD ON CM.Corpse_ID=CD.CorpseID ");
        Query.Append("INNER JOIN employee_master EM ON CM.CreatedBy=EM.EmployeeID LEFT JOIN mortuary_postmortem PM ON CM.Corpse_ID=PM.CorpseID ");
        Query.Append("INNER JOIN mortuary_freezer_master MFM on CD.FreezerID=MFM.RackID where  CD.IsCancel=0  AND CD.IsReleased='"+Status+"'  ");

        if (CorpseNo != "")
        {
            Query.Append("AND CM.Corpse_ID='" + CorpseNo + "' ");
        }

        if (DepositeNo != "")
        {
            Query.Append("AND CD.TransactionID='" + string.Concat("CRSHHI", DepositeNo) + "' ");
        }

        if (FirstName != "")
        {
            Query.Append("AND CM.FirstName Like '" + FirstName + "%' ");
        }

        if (LastName != "")
        {
            Query.Append("AND CM.LastName Like '" + LastName + "%'   ");
        }

        if (Status == "1" && CorpseNo == "" && DepositeNo == "" && FirstName == "" && LastName == "")
        {
            Query.Append("AND Date(CD.OutDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Date(CD.OutDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }

        Query.Append("ORDER BY DATE(CD.InDate) DESC ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }


    [WebMethod(EnableSession = true, Description = "Create Sticker")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string mortuarySticker(string CorpseID)
    {
        string result = "0";
        string sb = "SELECT CM.Corpse_ID,CM.CName,CM.Age,CM.Gender,DATE_FORMAT(CM.DeathDate,'%d-%b-%Y')DateofDeath,TIME_FORMAT(CM.DeathTime,'%h:%i %p')TimeofDeath,CM.DeathType,CONCAT(FM.RackName,'-',FM.Rack_No,'/','S.N.:',FM.ShelfNo)FreezerName,REPLACE(CD.TransactionID,'CRSHHI','')DepositeNo, " +
        "DATE_FORMAT(CD.InDate,'%d-%b-%Y %h:%i %p')DepositeDateTime,CONCAT(DM.Title,' ',DM.Name)DName,(SELECT PatientType FROM patient_type WHERE id=CM.Type)`Type` FROM mortuary_corpse_master CM INNER JOIN mortuary_corpse_deposite CD ON CM.Corpse_ID=CD.CorpseID " +
        "INNER JOIN doctor_master DM ON DM.DoctorID=CD.DoctorID INNER JOIN mortuary_freezer_master FM ON FM.RackID=CD.FreezerID Where CM.Corpse_ID='" + CorpseID + "' LIMIT 1 ";

        DataTable dt = StockReports.GetDataTable(sb);

        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;
            Session["ReportName"] = "MortuarySticker";
            //ds.WriteXmlSchema("C:/MortuarySticker.xml");
            result = "1";
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "CORPSE DEPOSITE FORM Information")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string MortuaryInforMation(string DepositeNo)
    {
        if (DepositeNo != "0")
        {
            string Transaction_ID="CRSHHI"+DepositeNo+"";
            AllQuery aq = new AllQuery();
            DataTable dt = aq.GetCorpseInformation(Transaction_ID);

            if (dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(HttpContext.Current.Session["ID"].ToString()).Rows[0][0];
                dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                //DataTable dtLogo = All_LoadData.CrystalReportLogo();
                //ds.Tables.Add(dtLogo.Copy());

                DataTable dtLogo = CrystalReportLogo();
                ds.Tables.Add(dtLogo.Copy());

                //ds.WriteXmlSchema("D://CorpseDepositeReport.xml");

                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "CorpseDepositeReport";
            }
        }
        return DepositeNo;
    }

    //All Freezer Relative Work

    [WebMethod(EnableSession = true, Description = "Bind Freezer Details")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindFreezer()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,RackName,Rack_No,Room_No,`Floor`,ShelfNo,Description,IsMuslim,IsActive FROM mortuary_freezer_master order by RackName,ShelfNo");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }


    [WebMethod(EnableSession = true, Description = "Save Freezer Details")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveFreezer(object Freezer)
    {
        string result = "0";
        List<Mortuary_Freezer_Master> dataFreezer = new JavaScriptSerializer().ConvertToType<List<Mortuary_Freezer_Master>>(Freezer);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {

            int Row = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select count(*) from mortuary_freezer_master where RackName='" + dataFreezer[0].RackName + "' AND Rack_No='" + dataFreezer[0].Rack_No + "' AND ShelfNo='" + dataFreezer[0].ShelfNo + "'"));

            if (Row > 0)
            {
                result = "2";
            }
            else
            {
                Mortuary_Freezer_Master obj = new Mortuary_Freezer_Master(tranx);
                obj.Floor = Util.GetString(dataFreezer[0].Floor);
                obj.Room_No = Util.GetString(dataFreezer[0].Room_No);
                obj.RackName = Util.GetString(dataFreezer[0].RackName);
                obj.Rack_No = Util.GetString(dataFreezer[0].Rack_No);
                obj.ShelfNo = Util.GetInt(dataFreezer[0].ShelfNo);
                obj.Description = Util.GetString(dataFreezer[0].Description);
                obj.IsMuslim = Util.GetInt(dataFreezer[0].IsMuslim);
                obj.IsActive = Util.GetInt(dataFreezer[0].IsActive);
                obj.IsActive = Util.GetInt(dataFreezer[0].IsActive);
                obj.CreatedBy = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                obj.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                //obj.HospCentreID = Util.GetInt(HttpContext.Current.Session["HospCentreID"].ToString());
                obj.Insert();
                result = "1";
            }

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();

        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Save Freezer Details")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateFreezer(object Freezer)
    {
        string result = "0";
        List<Mortuary_Freezer_Master> dataFreezer = new JavaScriptSerializer().ConvertToType<List<Mortuary_Freezer_Master>>(Freezer);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {

            string Query = "Update mortuary_freezer_master set RackName='" + Util.GetString(dataFreezer[0].RackName) + "',Rack_No='" + Util.GetString(dataFreezer[0].Rack_No) + "',Room_No='" + Util.GetString(dataFreezer[0].Room_No) + "', " +
                "Floor='" + Util.GetString(dataFreezer[0].Floor) + "',ShelfNo='" + Util.GetInt(dataFreezer[0].ShelfNo) + "',Description='" + Util.GetString(dataFreezer[0].Description) + "',IsMuslim='" + Util.GetInt(dataFreezer[0].IsMuslim) + "'," +
                "IsActive='" + Util.GetInt(dataFreezer[0].IsActive) + "',UpdatedBy='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' where ID='" + Util.GetString(dataFreezer[0].ID) + "'";

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;

    }

    [WebMethod(EnableSession = true, Description = "Bind Freezer")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindFreezerList(string Status, string Muslim)
    {
        DataTable dt = StockReports.GetDataTable("SELECT RackID,CONCAT(RackName,'-',Rack_No,' /','ShelfNo:',ShelfNo,' /','RoomNo:',Room_No)RackName FROM mortuary_freezer_master WHERE IsActive=1 AND IsVacant=" + Status + " AND IsMuslim in (" + Muslim + ")");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }

    //All Post-Mortem Relative Work
    [WebMethod(EnableSession = true, Description = "Get Postmortem Status")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string PostmortemInvestigations()
    {
        StringBuilder Query = new StringBuilder();

        Query.Append("SELECT IM.ItemID,IM.TypeName,SM.SubcategoryID,SM.Name FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubcategoryID=SM.SubcategoryID ");
        Query.Append("INNER JOIN f_categorymaster CM ON SM.CategoryID=CM.CategoryID WHERE CM.CategoryID='LSHHI24' ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }


    [WebMethod(EnableSession = true, Description = "Get Postmortem Status")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string PostmortemStatus(string TransactionID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT CorpseID,DATE_FORMAT(PostmortemDate,'%d-%b-%Y')PostmortemDate,TIME_FORMAT(PostMortemTime,'%h:%i %p')PostMortemTime,IsPostmortem FROM mortuary_postmortem WHERE IsCancel=0 AND TransactionID='" + TransactionID + "'");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }

    [WebMethod(EnableSession = true, Description = "Save Postmortem Result")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SavePostMortemResult(string TransactionID, string Result, List<string> FilePTH)
    {
        string result = "0";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnax = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            string Query = "UPDATE mortuary_postmortem SET Result='" + Result + "',File='" + FilePTH[0] + "' WHERE TransactionID='" + TransactionID + "' ";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            tnax.Commit();
            tnax.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tnax.Rollback();
            tnax.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        return result;
    }


    [WebMethod(EnableSession = true, Description = "Get Postmortem Result")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetPostmortemResult(string TransactionID)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append(" SELECT File,CorpseID,DATE_FORMAT(PostmortemDate,'%d-%b-%y')PostmortemDate,TIME_FORMAT(PostmortemTime,'%h:%i %p')PostmortemTime,DoctorName,Result  FROM mortuary_postmortem WHERE TransactionID='" + TransactionID + "' ");
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }

    [WebMethod(EnableSession = true, Description = "Get Details of Postmortem Process")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string PostmortemProcess(string DepositeNo)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT MCM.Corpse_ID,MCM.CName,MCM.Age,MCM.Gender,DATE_FORMAT(MP.PostmortemDate,'%d-%b-%Y')PostmortemDate,TIME_FORMAT(MP.PostmortemTime,'%h:%i %p')PostmortemTime,MP.DoctorName,MP.Location, ");
        Query.Append("MP.IsApproved,DATE_FORMAT(MP.ApprovedDate,'%d-%b-%Y %h:%i %p')ApprovedDate,(SELECT CONCAT(Title,' ',`Name`) FROM employee_master WHERE EmployeeID=MP.ApprovedBy)ApprovedBy, ");
        Query.Append("MP.IsSend,DATE_FORMAT(MP.SendDate,'%d-%b-%Y %h:%i %p')SendDate,(SELECT CONCAT(Title,' ',`Name`) FROM employee_master WHERE EmployeeID=MP.SendBy)SendBy, ");
        Query.Append("DATE_FORMAT(MP.ReceivedDate,'%d-%b-%Y %h:%i %p')ReceivedDate,ReceivedBy, ");
        Query.Append("MP.IsPostmortem,DATE_FORMAT(MP.ReceivedDateAfterPost,'%d-%b-%Y %h:%i %p')ReceivedDateAfterPost,(SELECT CONCAT(Title,' ',`Name`) FROM employee_master WHERE EmployeeID=MP.ReceivedByAfterPost)ReceivedByAfterPost ");
        Query.Append("FROM mortuary_postmortem MP INNER JOIN mortuary_corpse_master MCM ON MP.CorpseID=MCM.Corpse_ID WHERE MP.TransactionID='" + string.Concat("CRSHHI", DepositeNo) + "' ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }


    [WebMethod(EnableSession = true, Description = "Save sending process of corpse for postmortem")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SendPostmortemProcess(string DepositeNo, string ReceivedBy)
    {
        string result = "0";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnax = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            string Query = "UPDATE mortuary_postmortem SET IsSend='1',SendDate=now(),SendBy='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "',ReceivedBy='" + ReceivedBy + "' WHERE TransactionID='" + string.Concat("CRSHHI", DepositeNo) + "' ";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            tnax.Commit();
            tnax.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tnax.Rollback();
            tnax.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        return result;
    }

    [WebMethod(EnableSession = true, Description = "Save sending process of corpse for postmortem")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ReceivePostmortemProcess(string DepositeNo)
    {
        string result = "0";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnax = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            string Query = "UPDATE mortuary_postmortem SET IsPostmortem='1',ReceivedDateAfterPost=now(),ReceivedByAfterPost='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' WHERE TransactionID='" + string.Concat("CRSHHI", DepositeNo) + "' ";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            tnax.Commit();
            tnax.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tnax.Rollback();
            tnax.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        return result;
    }




    [WebMethod(EnableSession = true, Description = "Save Detail of corpse for which freezer is not allocated")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveCorpseDeposite(string MRNo, string IPDNo, string BroughtBy, string Remarks)
    {
        string result = "0";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnax = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            string Query = "insert into mortuary_corpse_status(Patient_ID,Transaction_ID,InDate,BroughtBy,InRemarks,EntryDate,EntryBy,CentreID) values('" + MRNo + "','" + IPDNo + "',now(),'" + BroughtBy + "','" + Remarks + "',now(),'" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["CentreID"]) + "')";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            tnax.Commit();
            tnax.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tnax.Rollback();
            tnax.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        return result;
    }

    //------------------------Mortuary Reports---------------------------------//


    [WebMethod(EnableSession = true, Description = "Detailed Bill Report")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string mortuaryDetailedBill(string CorpseID, string TransactionID)
    {
        string result = "0";
        AllQuery aq = new AllQuery();
        DataSet ds = new DataSet();

        string Query = "SELECT LedgerTransactionNo,NetAmount,GrossAmount,DiscountOnTotal,DATE_FORMAT(DATE,'%d-%b-%Y')EntryDate,((DiscountOnTotal/GrossAmount) * 100) AS Discount,IFNULL(BillNo,'')BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,DiscountReason,CorpseID,TransactionID,PanelID,TransactionTypeID,DATE_FORMAT(DATE,'%d-%b-%Y')`Date`FROM mortuary_ledgertransaction WHERE TransactionID = '" + TransactionID + "'  ORDER BY LedgerTransactionNo";
        DataTable dtBilled = StockReports.GetDataTable(Query);
        ds.Tables.Add(dtBilled.Copy());
        ds.Tables[0].TableName = "LedgerTnx";


        Query = "SELECT LedgerTransactionNo,Amount,T1.ItemID,Rate,Quantity,StockID,DiscountPercentage,IsPackage,PackageID,IsVerified,t1.SubCategoryID,VarifiedUserID, "

                        + "ItemName,TransactionID,VerifiedDate,UserID,EntryDate,DiscountAmount,LTDetailID,SubCategory, "
                        + "DisplayName,DisplayPriority,DisplayPriority,t1.IsSurgery,t1.Surgery_ID,t1.SurgeryName,t1.DiscountReason,t1.UserName,IF(t1.Type_ID='',im.Type_ID,t1.Type_ID)Type_ID,im.ServiceItemID,(Rate*Quantity)GrossAmt, "
                        + "IFNULL(dm.Specialization,'')Specialization,t1.IsPayable FROM ( "
                        + "     SELECT LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,"
                        + "     LTD.DiscountPercentage,LTD.IsPackage,LTD.PackageID,LTD.IsVerified,LTD.SubCategoryID, "
                        + "     LTD.VarifiedUserID,LTD.ItemName,LTD.TransactionID,"
                        + "     DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate,LTD.LedgerTnxID AS LTDetailID,"
                        + "     LTD.UserID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate,"
                        + "    (((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount,IFNULL(ltd.Type_ID,'')Type_ID, "
                        + "     SC.Name AS SubCategory,SC.DisplayName,SC.DisplayPriority,LTD.IsSurgery,"
                        + "     LTD.Surgery_ID,LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName,LTD.IsPayable      "
                        + "     FROM mortuary_ledgertnxdetail LTD INNER JOIN mortuary_ledgertransaction LT ON "
                        + "     LT.LedgerTransactionNo = LTD.LedgerTransactionNo INNER JOIN "
                        + "     f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID "
                        + "     INNER JOIN employee_master EM ON EM.EmployeeID = LTD.UserID "
                        + "     WHERE LT.TransactionID = '" + TransactionID + "' AND LTD.Isverified =1  "
                        + " )t1 LEFT JOIN f_itemmaster im ON im.itemid = t1.ItemID "
                        + " LEFT JOIN doctor_master dm ON dm.DoctorID=im.Type_ID "
                        + " ORDER BY t1.DisplayName, t1.SubCategoryID,t1.ItemID, "
                        + " DATE(t1.EntryDate) ";

        DataTable dt = StockReports.GetDataTable("SELECT * FROM mortuary_corpse_deposite WHERE TransactionID='" + TransactionID + "'");

        DataTable dtBilledDetail = StockReports.GetDataTable(Query);
        ds.Tables.Add(dtBilledDetail.Copy());
        ds.Tables[1].TableName = "LedgerTnxDetails";

        DataTable dtCorpseDetail = aq.GetCorpseInformation(TransactionID);
        dtCorpseDetail.Columns.Add("LoginName");
        dtCorpseDetail.Rows[0]["LoginName"] = HttpContext.Current.Session["LoginName"];

        dtCorpseDetail.Columns.Add("lang_code");
        dtCorpseDetail.Rows[0]["lang_code"] = "";

        dtCorpseDetail.Columns.Add("DiscountOnBill");
        dtCorpseDetail.Rows[0]["DiscountOnBill"] = Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString());

        dtCorpseDetail.Columns.Add("IsServiceTax");
        dtCorpseDetail.Rows[0]["IsServiceTax"] = "1";

        dtCorpseDetail.Columns.Add("ParentComp");
        dtCorpseDetail.Rows[0]["ParentComp"] = "";

        dtCorpseDetail.Columns.Add("Panel_ID");
        dtCorpseDetail.Rows[0]["Panel_ID"] = "";

        dtCorpseDetail.Columns.Add("ClaimNo");
        dtCorpseDetail.Rows[0]["ClaimNo"] = "";

        dtCorpseDetail.Columns.Add("BillDate");
        dtCorpseDetail.Rows[0]["BillDate"] = dt.Rows[0]["BillDate"].ToString();

        ds.Tables.Add(dtCorpseDetail.Copy());
        ds.Tables[2].TableName = "Header";


        DataTable Table = new DataTable();
        Table = ds.Tables["LedgerTnxDetails"].Copy();

        DataTable dtNetAmtWord = new DataTable();
        dtNetAmtWord.TableName = "dtNetAmtWord";
        dtNetAmtWord.Columns.Add("BilledAmt");
        dtNetAmtWord.Columns.Add("ReceivedAmt");
        dtNetAmtWord.Columns.Add("ReceivedAmtBeforeBill");
        dtNetAmtWord.Columns.Add("ReceivedAmtAfterBill");
        dtNetAmtWord.Columns.Add("NetAmount");
        dtNetAmtWord.Columns.Add("NetAmountWord");
        dtNetAmtWord.Columns.Add("DiscountReason");
        dtNetAmtWord.Columns.Add("ShowReceipt");
        dtNetAmtWord.Columns.Add("Narration");
        dtNetAmtWord.Columns.Add("ServiceTaxAmt");
        dtNetAmtWord.Columns.Add("ServiceTaxPer");
        dtNetAmtWord.Columns.Add("ServiceTaxSurChgAmt");
        dtNetAmtWord.Columns.Add("SerTaxSurChgPer");
        dtNetAmtWord.Columns.Add("SerTaxBillAmt");
        dtNetAmtWord.Columns.Add("IsBilledClosed");
        dtNetAmtWord.Columns.Add("Dedutions");
        dtNetAmtWord.Columns.Add("TDS");
        dtNetAmtWord.Columns.Add("WriteOff");
        dtNetAmtWord.Columns.Add("S_Amount");
        dtNetAmtWord.Columns.Add("S_Notation");
        dtNetAmtWord.Columns.Add("C_Factor");
        dtNetAmtWord.Columns.Add("RoundOff");
        dtNetAmtWord.Columns.Add("CreditLimit");
        dtNetAmtWord.Columns.Add("CreditLimitType");
        dtNetAmtWord.Columns.Add("PanelApprovedAmt");
        AllQuery AQ = new AllQuery();

        decimal AmountReceived = Util.GetDecimal(AQ.GetMortuaryPaidAmount(TransactionID));
        decimal AmountBilled = Util.GetDecimal(AQ.GetMortuaryBillAmount(TransactionID));
        float Dedutions = 0f;
        float TDS = Util.GetFloat(StockReports.ExecuteScalar("Select TDS from mortuary_corpse_deposite where TransactionID='" + TransactionID + "'"));
        float WriteOff = 0;

        string NetAmount = "";
        float DiscountOnItem = 0f;

        DataRow[] DisRow = Table.Select("DiscountPercentage > 0 and IsVerified = 1 and IsPackage = 0");

        if (DisRow.Length > 0)
        {
            foreach (DataRow drDis in DisRow)
            {
                DiscountOnItem = DiscountOnItem + (Util.GetFloat(drDis["Rate"].ToString()) * Util.GetFloat(drDis["Quantity"].ToString())) - Util.GetFloat(drDis["Amount"].ToString());
            }
        }

        NetAmount = Util.GetString(AmountBilled);


        string DiscountReason = "", Narration = "";
        string ServiceTaxPer = "", ServiceTaxAmt = "", ServiceTaxSurChgAmt = "", SerTaxSurChgPer = "", SerTaxBillAmt = "";
        string SAmount = "", SNotation = "", CFactor = "";
        decimal RoundOff = 0; decimal CreditLimit = 0; string CreditLimitType = "";
        //Checking if final discount is allowed       


        if (dt != null && dt.Rows.Count > 0)
        {
            NetAmount = Util.GetString((Util.GetDecimal(NetAmount)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
            DiscountReason = Util.GetString(dt.Rows[0]["DiscountOnBillReason"].ToString());
            Narration = Util.GetString(dt.Rows[0]["Narration"].ToString());
            SAmount = Util.GetString(dt.Rows[0]["S_Amount"].ToString());
            SNotation = Util.GetString(dt.Rows[0]["S_Notation"].ToString());
            CFactor = Util.GetString(dt.Rows[0]["C_Factor"].ToString());

            if (dtBilled.Rows[0]["BillNo"].ToString().Trim() == string.Empty)
            {

                ServiceTaxPer = Util.GetString(All_LoadData.GovTaxPer()).ToString();
                SerTaxSurChgPer = "0";

                ServiceTaxAmt = "";
                ServiceTaxSurChgAmt = "";

                AmountBilled = Util.GetDecimal((Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
                ServiceTaxAmt = Util.GetString(Math.Round((Util.GetDecimal((Util.GetDecimal(AmountBilled)) * Util.GetDecimal(ServiceTaxPer)) / 100), 2, MidpointRounding.AwayFromZero));
                decimal SurchargeTaxAmt = Util.GetDecimal(Math.Round((Util.GetDecimal((Util.GetDecimal(ServiceTaxAmt) * Util.GetDecimal(SerTaxSurChgPer)) / 100)), 2, MidpointRounding.AwayFromZero));
                NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(ServiceTaxAmt) + SurchargeTaxAmt);
                ServiceTaxSurChgAmt = SurchargeTaxAmt.ToString();
                SerTaxBillAmt = AmountBilled.ToString();
                decimal Round = Math.Round((Util.GetDecimal(AmountBilled)) + (Util.GetDecimal(ServiceTaxAmt)), MidpointRounding.AwayFromZero);
                RoundOff = Util.GetDecimal(Round) - (Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(ServiceTaxAmt));
            }
            else
            {
                ServiceTaxAmt = Util.GetString(dt.Rows[0]["ServiceTaxAmt"]);
                ServiceTaxPer = Util.GetString(dt.Rows[0]["ServiceTaxPer"]);
                ServiceTaxSurChgAmt = Util.GetString(dt.Rows[0]["ServiceTaxSurChgAmt"]);
                SerTaxSurChgPer = Util.GetString(dt.Rows[0]["SerTaxSurChgPer"]);
                SerTaxBillAmt = Util.GetString(dt.Rows[0]["SerTaxBillAmount"]);

                NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(dt.Rows[0]["ServiceTaxAmt"]) + Util.GetDecimal(dt.Rows[0]["ServiceTaxSurChgAmt"]));
                RoundOff = Util.GetDecimal(dt.Rows[0]["RoundOff"]);
            }

        }
        float ReceivedAmtBeforeBill = 0f, ReceivedAmtAfterBill = 0f;

        if (Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") != "0001-01-01")
        {
            string st = "SELECT SUM(AmountPaid) FROM mortuary_receipt WHERE TransactionID ='" + TransactionID + "' AND IsCancel = 0 and Date(Date) <='" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY TransactionID ";
            ReceivedAmtBeforeBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM mortuary_receipt WHERE TransactionID ='" + TransactionID + "' AND IsCancel = 0 and Date(Date) <='" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY TransactionID "));
        }
        else
        {
            ReceivedAmtBeforeBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM mortuary_receipt WHERE TransactionID ='" + TransactionID + "' AND IsCancel = 0 GROUP BY TransactionID "));

        }

        DataRow row = dtNetAmtWord.NewRow();
        row["BilledAmt"] = AmountBilled.ToString();
        row["ReceivedAmt"] = AmountReceived.ToString();
        row["NetAmount"] = NetAmount;
        row["DiscountReason"] = DiscountReason;
        row["Narration"] = Narration;
        row["ServiceTaxAmt"] = ServiceTaxAmt;
        row["ServiceTaxPer"] = ServiceTaxPer;
        row["ServiceTaxSurChgAmt"] = ServiceTaxSurChgAmt;
        row["SerTaxSurChgPer"] = SerTaxSurChgPer;
        row["SerTaxBillAmt"] = SerTaxBillAmt;
        row["Dedutions"] = Dedutions;
        row["TDS"] = TDS;
        row["WriteOff"] = WriteOff;
        row["S_Amount"] = SAmount;
        row["S_Notation"] = SNotation;
        row["C_Factor"] = CFactor;
        row["RoundOff"] = RoundOff;
        row["CreditLimit"] = CreditLimit;
        row["CreditLimitType"] = CreditLimitType;
        row["ShowReceipt"] = "1";
        row["IsBilledClosed"] = Util.GetString(dt.Rows[0]["IsBillClosed"]);
        row["ReceivedAmtBeforeBill"] = Util.GetString(ReceivedAmtBeforeBill);
        row["ReceivedAmtAfterBill"] = Util.GetString(ReceivedAmtAfterBill);
        dtNetAmtWord.Rows.Add(row);
        ds.Tables.Add(dtNetAmtWord.Copy());
        ds.Tables[3].TableName = "dtNetAmtWord";


        DataTable dtReceipt = AQ.GetMortuaryReceipt(TransactionID);

        if (dtReceipt != null && dtReceipt.Rows.Count == 0)
        {
            DataRow dr = dtReceipt.NewRow();
            dr["ReceiptNo"] = "";
            dr["AmountPaid"] = "0";
            dr["Date"] = "";
            dr["Type"] = "";
            dr["TransactionID"] = TransactionID.ToString();
            dtReceipt.Rows.Add(dr);
        }

        dtReceipt.Columns.Add("lang_code");
        dtReceipt.Rows[0]["lang_code"] = "";


        ds.Tables.Add(dtReceipt.Copy());
        ds.Tables[4].TableName = "dtReceipt";


        if (dtBilled.Rows.Count > 0)
        {
            Session["ds"] = ds;
            Session["ReportName"] = "MortuaryDetailedBill";
           // ds.WriteXmlSchema("E:/MortuaryDetailBill.xml");
            result = "1";
        }

        return result;
    }


    [WebMethod(EnableSession = true, Description = "Summary Bill Report")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string mortuarySummaryBill(string CorpseID, string TransactionID)
    {
        string result = "0";
        AllQuery aq = new AllQuery();
        DataSet ds = new DataSet();

        string Query = "SELECT LedgerTransactionNo,NetAmount,GrossAmount,DiscountOnTotal,DATE_FORMAT(DATE,'%d-%b-%Y')EntryDate,((DiscountOnTotal/GrossAmount) * 100) AS Discount,IFNULL(BillNo,'')BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,DiscountReason,CorpseID,TransactionID,PanelID Panel_ID,TransactionTypeID,DATE_FORMAT(DATE,'%d-%b-%Y')`Date`FROM mortuary_ledgertransaction WHERE TransactionID = '" + TransactionID + "'  ORDER BY LedgerTransactionNo";
        DataTable dtBilled = StockReports.GetDataTable(Query);
        ds.Tables.Add(dtBilled.Copy());
        ds.Tables[0].TableName = "LedgerTnx";


        Query = "SELECT LedgerTransactionNo,Amount,T1.ItemID,Rate,Quantity,StockID,DiscountPercentage,IsPackage,PackageID,IsVerified,t1.SubCategoryID,VarifiedUserID, "

                        + "ItemName,TransactionID,VerifiedDate,UserID,EntryDate,DiscountAmount,LTDetailID,SubCategory, "
                        + "DisplayName,DisplayPriority,DisplayPriority,t1.IsSurgery,t1.Surgery_ID,t1.SurgeryName,t1.DiscountReason,t1.UserName,IF(t1.Type_ID='',im.Type_ID,t1.Type_ID)Type_ID,im.ServiceItemID,(Rate*Quantity)GrossAmt, "
                        + "IFNULL(dm.Specialization,'')Specialization,t1.IsPayable FROM ( "
                        + "     SELECT LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,"
                        + "     LTD.DiscountPercentage,LTD.IsPackage,LTD.PackageID,LTD.IsVerified,LTD.SubCategoryID, "
                        + "     LTD.VarifiedUserID,LTD.ItemName,LTD.TransactionID,"
                        + "     DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate,LTD.LedgerTnxID AS LTDetailID,"
                        + "     LTD.UserID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate,"
                        + "    (((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount,IFNULL(ltd.Type_ID,'')Type_ID, "
                        + "     SC.Name AS SubCategory,SC.DisplayName,SC.DisplayPriority,LTD.IsSurgery,"
                        + "     LTD.Surgery_ID,LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName,LTD.IsPayable      "
                        + "     FROM mortuary_ledgertnxdetail LTD INNER JOIN mortuary_ledgertransaction LT ON "
                        + "     LT.LedgerTransactionNo = LTD.LedgerTransactionNo INNER JOIN "
                        + "     f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID "
                        + "     INNER JOIN employee_master EM ON EM.EmployeeID = LTD.UserID "
                        + "     WHERE LT.TransactionID = '" + TransactionID + "' AND LTD.Isverified =1  "
                        + " )t1 LEFT JOIN f_itemmaster im ON im.itemid = t1.ItemID "
                        + " LEFT JOIN doctor_master dm ON dm.DoctorID=im.Type_ID "
                        + " ORDER BY t1.DisplayName, t1.SubCategoryID,t1.ItemID, "
                        + " DATE(t1.EntryDate) ";

        DataTable dt = StockReports.GetDataTable("SELECT * FROM mortuary_corpse_deposite WHERE TransactionID='" + TransactionID + "'");

        DataTable dtBilledDetail = StockReports.GetDataTable(Query);
        dtBilledDetail.Columns.Add("ShowSummary");
        dtBilledDetail.Rows[0]["ShowSummary"] = "0";

        ds.Tables.Add(dtBilledDetail.Copy());
        ds.Tables[1].TableName = "LedgerTnxDetails";

        DataTable dtCorpseDetail = aq.GetCorpseInformation(TransactionID);
        dtCorpseDetail.Columns.Add("LoginName");
        dtCorpseDetail.Rows[0]["LoginName"] = HttpContext.Current.Session["LoginName"];

        dtCorpseDetail.Columns.Add("lang_code");
        dtCorpseDetail.Rows[0]["lang_code"] = "";

        dtCorpseDetail.Columns.Add("DiscountOnBill");
        dtCorpseDetail.Rows[0]["DiscountOnBill"] = Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString());

        dtCorpseDetail.Columns.Add("IsServiceTax");
        dtCorpseDetail.Rows[0]["IsServiceTax"] = "1";

        dtCorpseDetail.Columns.Add("ParentComp");
        dtCorpseDetail.Rows[0]["ParentComp"] = "";

        dtCorpseDetail.Columns.Add("Panel_ID");
        dtCorpseDetail.Rows[0]["Panel_ID"] = "";

        dtCorpseDetail.Columns.Add("ClaimNo");
        dtCorpseDetail.Rows[0]["ClaimNo"] = "";

        dtCorpseDetail.Columns.Add("BillDate");
        dtCorpseDetail.Rows[0]["BillDate"] = dt.Rows[0]["BillDate"].ToString();

        ds.Tables.Add(dtCorpseDetail.Copy());
        ds.Tables[2].TableName = "Header";


        DataTable Table = new DataTable();
        Table = ds.Tables["LedgerTnxDetails"].Copy();

        DataTable dtNetAmtWord = new DataTable();
        dtNetAmtWord.TableName = "dtNetAmtWord";
        dtNetAmtWord.Columns.Add("BilledAmt");
        dtNetAmtWord.Columns.Add("ReceivedAmt");
        dtNetAmtWord.Columns.Add("ReceivedAmtBeforeBill");
        dtNetAmtWord.Columns.Add("ReceivedAmtAfterBill");
        dtNetAmtWord.Columns.Add("NetAmount");
        dtNetAmtWord.Columns.Add("NetAmountWord");
        dtNetAmtWord.Columns.Add("DiscountReason");
        dtNetAmtWord.Columns.Add("ShowReceipt");
        dtNetAmtWord.Columns.Add("Narration");
        dtNetAmtWord.Columns.Add("ServiceTaxAmt");
        dtNetAmtWord.Columns.Add("ServiceTaxPer");
        dtNetAmtWord.Columns.Add("ServiceTaxSurChgAmt");
        dtNetAmtWord.Columns.Add("SerTaxSurChgPer");
        dtNetAmtWord.Columns.Add("SerTaxBillAmt");
        dtNetAmtWord.Columns.Add("IsBilledClosed");
        dtNetAmtWord.Columns.Add("Dedutions");
        dtNetAmtWord.Columns.Add("TDS");
        dtNetAmtWord.Columns.Add("WriteOff");
        dtNetAmtWord.Columns.Add("S_Amount");
        dtNetAmtWord.Columns.Add("S_Notation");
        dtNetAmtWord.Columns.Add("C_Factor");
        dtNetAmtWord.Columns.Add("RoundOff");
        dtNetAmtWord.Columns.Add("CreditLimit");
        dtNetAmtWord.Columns.Add("CreditLimitType");
        dtNetAmtWord.Columns.Add("PanelApprovedAmt");
        AllQuery AQ = new AllQuery();

        decimal AmountReceived = Util.GetDecimal(AQ.GetMortuaryPaidAmount(TransactionID));
        decimal AmountBilled = Util.GetDecimal(AQ.GetMortuaryBillAmount(TransactionID));
        float Dedutions = 0f;
        float TDS = Util.GetFloat(StockReports.ExecuteScalar("Select TDS from mortuary_corpse_deposite where TransactionID='" + TransactionID + "'"));
        float WriteOff = 0;

        string NetAmount = "";
        float DiscountOnItem = 0f;

        DataRow[] DisRow = Table.Select("DiscountPercentage > 0 and IsVerified = 1 and IsPackage = 0");

        if (DisRow.Length > 0)
        {
            foreach (DataRow drDis in DisRow)
            {
                DiscountOnItem = DiscountOnItem + (Util.GetFloat(drDis["Rate"].ToString()) * Util.GetFloat(drDis["Quantity"].ToString())) - Util.GetFloat(drDis["Amount"].ToString());
            }
        }

        NetAmount = Util.GetString(AmountBilled);


        string DiscountReason = "", Narration = "";
        string ServiceTaxPer = "", ServiceTaxAmt = "", ServiceTaxSurChgAmt = "", SerTaxSurChgPer = "", SerTaxBillAmt = "";
        string SAmount = "", SNotation = "", CFactor = "";
        decimal RoundOff = 0; decimal CreditLimit = 0; string CreditLimitType = "";
        //Checking if final discount is allowed       


        if (dt != null && dt.Rows.Count > 0)
        {
            NetAmount = Util.GetString((Util.GetDecimal(NetAmount)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
            DiscountReason = Util.GetString(dt.Rows[0]["DiscountOnBillReason"].ToString());
            Narration = Util.GetString(dt.Rows[0]["Narration"].ToString());
            SAmount = Util.GetString(dt.Rows[0]["S_Amount"].ToString());
            SNotation = Util.GetString(dt.Rows[0]["S_Notation"].ToString());
            CFactor = Util.GetString(dt.Rows[0]["C_Factor"].ToString());

            if (dtBilled.Rows[0]["BillNo"].ToString().Trim() == string.Empty)
            {

                ServiceTaxPer = Util.GetString(All_LoadData.GovTaxPer()).ToString();
                SerTaxSurChgPer = "0";

                ServiceTaxAmt = "";
                ServiceTaxSurChgAmt = "";

                AmountBilled = Util.GetDecimal((Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
                ServiceTaxAmt = Util.GetString(Math.Round((Util.GetDecimal((Util.GetDecimal(AmountBilled)) * Util.GetDecimal(ServiceTaxPer)) / 100), 2, MidpointRounding.AwayFromZero));
                decimal SurchargeTaxAmt = Util.GetDecimal(Math.Round((Util.GetDecimal((Util.GetDecimal(ServiceTaxAmt) * Util.GetDecimal(SerTaxSurChgPer)) / 100)), 2, MidpointRounding.AwayFromZero));
                NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(ServiceTaxAmt) + SurchargeTaxAmt);
                ServiceTaxSurChgAmt = SurchargeTaxAmt.ToString();
                SerTaxBillAmt = AmountBilled.ToString();
                decimal Round = Math.Round((Util.GetDecimal(AmountBilled)) + (Util.GetDecimal(ServiceTaxAmt)), MidpointRounding.AwayFromZero);
                RoundOff = Util.GetDecimal(Round) - (Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(ServiceTaxAmt));
            }
            else
            {
                ServiceTaxAmt = Util.GetString(dt.Rows[0]["ServiceTaxAmt"]);
                ServiceTaxPer = Util.GetString(dt.Rows[0]["ServiceTaxPer"]);
                ServiceTaxSurChgAmt = Util.GetString(dt.Rows[0]["ServiceTaxSurChgAmt"]);
                SerTaxSurChgPer = Util.GetString(dt.Rows[0]["SerTaxSurChgPer"]);
                SerTaxBillAmt = Util.GetString(dt.Rows[0]["SerTaxBillAmount"]);

                NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(dt.Rows[0]["ServiceTaxAmt"]) + Util.GetDecimal(dt.Rows[0]["ServiceTaxSurChgAmt"]));
                RoundOff = Util.GetDecimal(dt.Rows[0]["RoundOff"]);
            }

        }
        float ReceivedAmtBeforeBill = 0f, ReceivedAmtAfterBill = 0f;

        if (Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") != "0001-01-01")
        {
            string st = "SELECT SUM(AmountPaid) FROM mortuary_receipt WHERE TransactionID ='" + TransactionID + "' AND IsCancel = 0 and Date(Date) <='" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY TransactionID ";
            ReceivedAmtBeforeBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM mortuary_receipt WHERE TransactionID ='" + TransactionID + "' AND IsCancel = 0 and Date(Date) <='" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY TransactionID "));
        }
        else
        {
            ReceivedAmtBeforeBill = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM mortuary_receipt WHERE TransactionID ='" + TransactionID + "' AND IsCancel = 0 GROUP BY TransactionID "));

        }

        DataRow row = dtNetAmtWord.NewRow();
        row["BilledAmt"] = AmountBilled.ToString();
        row["ReceivedAmt"] = AmountReceived.ToString();
        row["NetAmount"] = NetAmount;
        row["DiscountReason"] = DiscountReason;
        row["Narration"] = Narration;
        row["ServiceTaxAmt"] = ServiceTaxAmt;
        row["ServiceTaxPer"] = ServiceTaxPer;
        row["ServiceTaxSurChgAmt"] = ServiceTaxSurChgAmt;
        row["SerTaxSurChgPer"] = SerTaxSurChgPer;
        row["SerTaxBillAmt"] = SerTaxBillAmt;
        row["Dedutions"] = Dedutions;
        row["TDS"] = TDS;
        row["WriteOff"] = WriteOff;
        row["S_Amount"] = SAmount;
        row["S_Notation"] = SNotation;
        row["C_Factor"] = CFactor;
        row["RoundOff"] = RoundOff;
        row["CreditLimit"] = CreditLimit;
        row["CreditLimitType"] = CreditLimitType;
        row["ShowReceipt"] = "1";
        row["IsBilledClosed"] = Util.GetString(dt.Rows[0]["IsBillClosed"]);
        row["ReceivedAmtBeforeBill"] = Util.GetString(ReceivedAmtBeforeBill);
        row["ReceivedAmtAfterBill"] = Util.GetString(ReceivedAmtAfterBill);
        dtNetAmtWord.Rows.Add(row);
        ds.Tables.Add(dtNetAmtWord.Copy());
        ds.Tables[3].TableName = "dtNetAmtWord";


        DataTable dtReceipt = AQ.GetMortuaryReceipt(TransactionID);

      
        if (dtReceipt != null && dtReceipt.Rows.Count == 0)
        {
            if (dtReceipt.Rows.Count<= 0)
            {

                DataRow dr = dtReceipt.NewRow();
                dr["ReceiptNo"] = "";
                dr["AmountPaid"] = "0";
                dr["Date"] = "";
                dr["Type"] = "";
                dr["TransactionID"] = TransactionID;
                dtReceipt.Rows.Add(dr);
            }
        }

        dtReceipt.Columns.Add("lang_code");
        dtReceipt.Rows[0]["lang_code"] = "";

        ds.Tables.Add(dtReceipt.Copy());
        ds.Tables[4].TableName = "dtReceipt";


        if (dtBilled.Rows.Count > 0)
        {
            Session["ds"] = ds;
            Session["ReportName"] = "MortuarySummaryBill";
          //  ds.WriteXmlSchema("C:/MortuarySummaryBill.xml");
            result = "1";
        }

        return result;
    }



    [WebMethod(EnableSession = true, Description = "Detailed Bill Report")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string mortuaryCorpseReport(string PatientStatus, string Status, string FromDate, string ToDate, string StatusReport)
    {
        string result = "0";

        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT CM.Corpse_ID,REPLACE(CD.TransactionID,'CRSHHI','')DepositeNo,CM.CName,CM.Age,CM.Gender,DATE_FORMAT(CM.DeathDate,'%d-%b-%Y')DeathDate,TIME_FORMAT(CM.DeathTime,'%h:%i %p')DeathTime, ");
        Query.Append("DATE_FORMAT(CD.InDate,'%d-%b-%Y')AdmiteDate,DATE_FORMAT(CD.OutDate,'%d-%b-%Y')ReleaseDate,(SELECT PatientType FROM patient_type WHERE id=CM.Type)PatientStatus,IF(IsReleased=0,'IN','OUT')`Status`, ");
        Query.Append("(SELECT WHO_Full_Desc FROM cpoe_10cm_patient icdp INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID WHERE icdp.TransactionID=CM.TransactionID ORDER BY icdp.EntDate DESC LIMIT 1)Diagnosis, ");
        Query.Append("(SELECT `Name` FROM employee_master WHERE employeeid=CD.CreatedBy)AdmiteBy,(SELECT `Name` FROM employee_master WHERE employeeid=CD.ReleasedBy)ReleaseBy,CD.CorpseCollectedBy,CD.ContactNoCollected, ");
        Query.Append("CD.AddressCollected,CD.Remarks ");
        Query.Append("FROM mortuary_corpse_master CM INNER JOIN mortuary_corpse_deposite CD ON CM.Corpse_ID=CD.CorpseID ");
        Query.Append("WHERE CD.IsCancel=0  AND DATE(CD.InDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(CD.InDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");

        if (PatientStatus != "0")
        {
            Query.Append("AND CM.Type='" + PatientStatus + "' ");
        }

        if (Status != "2")
        {
            Query.Append("AND CD.IsReleased='" + Status + "' ");
        }

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Util.GetString(HttpContext.Current.Session["ID"])).Rows[0][0].ToString();
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + FromDate + " To " + ToDate;
            dt.Columns.Add(dc);


            //ds.WriteXmlSchema("D://MortuaryCorpseReport.xml");

            if (StatusReport == "1")
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                Session["ds"] = ds;
                Session["ReportName"] = "MortuaryCorpseReport";
            }
            else
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Mortuary Corpse Report";
            }


            result = "1";
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Postmortem Report")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string MortuaryPostmortemStatusReport(string fromDate, string toDate, string status, string user_ID)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();

        query.Append(" SELECT (CASE WHEN pm.IsPostmortem=0 AND pm.IsSend=0 THEN 'Requested' WHEN pm.IsPostmortem=0 AND pm.IsSend=1 THEN 'Sent' WHEN pm.IsPostmortem=1 THEN 'Completed' END)STATUS, ");
        query.Append(" CM.Corpse_ID,CM.CName,CM.Age,CM.Gender,DATE_FORMAT(CM.DeathDate,'%d-%b-%Y')DateofDeath,TIME_FORMAT(CM.DeathTime,'%h:%i %p')TimeofDeath,CM.DeathType,REPLACE(CD.TransactionID,'CRSHHI','')Transaction_ID, ");
        query.Append(" CD.TransactionID TransactionID,DATE_FORMAT(CD.InDate,'%d-%b-%Y %h:%i %p')DepositeDateTime,CONCAT(EM.Title,' ',EM.Name)AdmittedBy,CONCAT(MFM.RackName,'-',MFM.Rack_No,'/',MFM.ShelfNo)FreezerName, ");
        query.Append(" pm.DoctorName,pm.Location,DATE_FORMAT(pm.PostmortemDate,'%d-%b-%Y')PostmortemDate,TIME_FORMAT(pm.PostmortemTime,'%h:%i %p')PostmoetemTime,pm.IsSend,IFNULL(DATE_FORMAT(pm.SendDate,'%d-%b-%Y %h:%i %p'),'')SendDate, ");
        query.Append(" IFNULL((SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeid=pm.SendBy),'')SendBy,IFNULL((SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeid=pm.ReceivedBy),'')ReceivedBy, ");
        query.Append(" pm.IsPostmortem,IFNULL(DATE_FORMAT(pm.ReceivedDateAfterPost,'%d-%b-%Y %h:%i %p'),'')ReceivedDateAfterPost,IFNULL((SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeid=pm.ReceivedByAfterPost),'')ReceivedByAfterPost, ");
        query.Append(" DATE_FORMAT(pm.CreatedDate,'%d-%b-%Y %h:%i %p')EntryDate,IFNULL((SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeid=pm.CreatedBy),'')EntryBy ");
        query.Append(" FROM mortuary_corpse_master CM INNER JOIN mortuary_corpse_deposite CD ON CM.Corpse_ID=CD.CorpseID INNER JOIN employee_master EM ON CM.CreatedBy=EM.EmployeeID  ");
        query.Append(" INNER JOIN mortuary_freezer_master MFM ON CD.FreezerID=MFM.RackID INNER JOIN mortuary_postmortem PM ON CM.Corpse_ID=PM.CorpseID WHERE CD.IsCancel=0 ");
        query.Append(" AND pm.PostmortemDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND  pm.PostmortemDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");

        if (status.ToUpper() == "REQUESTED")
        {
            query.Append(" AND pm.IsPostmortem=0 AND pm.IsSend=0 ");
        }
        else if (status.ToUpper() == "SENT")
        {
            query.Append(" AND pm.IsPostmortem=0 AND pm.IsSend=1 ");
        }
        else if (status.ToUpper() == "COMPLETED")
        {
            query.Append(" AND pm.IsPostmortem=1 ");
        }

        query.Append(" ORDER BY pm.PostmortemDate ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Util.GetString(StockReports.GetUserName(user_ID).Rows[0][0]);
            dt.Columns.Add(dc);

            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "Period";
            dc1.DefaultValue = "Period : From " + fromDate + " To " + toDate;
            dt.Columns.Add(dc1);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            //ds.WriteXmlSchema("D://PostmortemReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "CorpsePostmortemStatusReport";

            result = "1";
        }

        return result;
    }

    //------------------------Mortuary Reports---------------------------------//


    public static DataTable CrystalReportLogo()
    {
        DataTable dtImg = new DataTable();
        dtImg.TableName = "Logo";
        dtImg.Columns.Add("ReportHeaderName");
        dtImg.Columns.Add("ClientEmail");
        dtImg.Columns.Add("ClientTelophone");
        dtImg.Columns.Add("ClientWebsite");
        dtImg.Columns.Add("ReportClientLogo", System.Type.GetType("System.Byte[]"));
        dtImg.Columns.Add("FooterLogoReport", System.Type.GetType("System.Byte[]"));
        DataRow drImg = dtImg.NewRow();
        drImg["ReportHeaderName"] = HttpContext.GetGlobalResourceObject("Resource", "ReportHeader").ToString();
        drImg["ClientEmail"] = HttpContext.GetGlobalResourceObject("Resource", "ClientEmail").ToString();
        drImg["ClientTelophone"] = HttpContext.GetGlobalResourceObject("Resource", "ClientTelophone").ToString();
        drImg["ClientWebsite"] = HttpContext.GetGlobalResourceObject("Resource", "ClientWebsite").ToString();
        string path = HttpContext.Current.Server.MapPath("../../../" + HttpContext.GetGlobalResourceObject("Resource", "CrystalReportLogo"));
        FileStream fs = new FileStream(path, FileMode.Open, System.IO.FileAccess.Read);
        byte[] imgbyte = new byte[fs.Length + 1];
        fs.Read(imgbyte, 0, (int)fs.Length);
        fs.Close();
        string path1 = HttpContext.Current.Server.MapPath("../../../" + HttpContext.GetGlobalResourceObject("Resource", "ClientFooterLogo"));
        FileStream fs1 = new FileStream(path1, FileMode.Open, System.IO.FileAccess.Read);
        byte[] imgbyte1 = new byte[fs1.Length + 1];
        fs1.Read(imgbyte1, 0, (int)fs1.Length);
        fs1.Close();
        drImg["FooterLogoReport"] = imgbyte1;
        drImg["ReportClientLogo"] = imgbyte;
        dtImg.Rows.Add(drImg);
        dtImg.AcceptChanges();
        return dtImg;
    }

}

class Mortuaty_Receive
{
    public string Patient_ID { get; set; }
    public string Transaction_ID { get; set; }
    public string BroughtBy { get; set; }
    public string ReceivedRemarks { get; set; }
}
