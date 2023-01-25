using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;
using System.Data;
using System.Linq;
using System.IO;

/// <summary>
/// Summary description for Update_PatientInfo
/// </summary>
public class Update_PatientInfo
{
    public Update_PatientInfo()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static string updatePatientMaster(object PM, MySqlTransaction tnx, MySqlConnection con)
    {

        try
        {
            List<Patient_Master> dataReg = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PM);

            Patient_Master pm = new Patient_Master(tnx);
            pm.Title = dataReg[0].Title.Trim();
            pm.PFirstName = dataReg[0].PFirstName.Trim();
            pm.PLastName = dataReg[0].PLastName.Trim();
            pm.PName = dataReg[0].PFirstName.Trim() + " " + dataReg[0].PLastName.Trim();
            if (Util.GetDateTime(dataReg[0].DOB).ToString("dd-MM-yyyy") == "01-01-0001")
            {
                pm.Age = Util.GetString(dataReg[0].Age);
                pm.DOB = Util.GetDateTime(Util.GetDateTime(StockReports.ExecuteScalar("Select Get_Approx_DOB('" + Util.GetString(dataReg[0].Age) + "','0001-01-01',CURDATE())")).ToString("yyyy-MM-dd"));
            }

            else
            {
                pm.DOB = Util.GetDateTime(dataReg[0].DOB.ToString("yyyy-MM-dd"));
                pm.Age = Util.GetString(dataReg[0].Age);//Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select Get_Age_DOB('" + dataReg[0].DOB.ToString("yyyy-MM-dd") + "')"));
            }
            pm.Gender = dataReg[0].Gender.Trim();
            pm.Mobile = dataReg[0].Mobile.Trim();
            pm.Email = dataReg[0].Email.Trim();
            pm.Relation = dataReg[0].Relation;
            pm.RelationName = dataReg[0].RelationName;
            pm.House_No = dataReg[0].House_No.Trim();
            pm.Country = dataReg[0].Country.Trim();
            pm.City = dataReg[0].City.Trim();
            pm.HospPatientType = dataReg[0].HospPatientType.Trim();
            pm.Taluka = dataReg[0].Taluka.Trim();
            pm.LandMark = dataReg[0].LandMark;
            pm.Place = dataReg[0].Place;
            pm.District = dataReg[0].District.Trim();
            pm.Locality = dataReg[0].Locality;
            pm.PinCode = dataReg[0].PinCode;
            pm.Occupation = dataReg[0].Occupation;
            pm.MaritalStatus = dataReg[0].MaritalStatus;
            pm.AdharCardNo = dataReg[0].AdharCardNo;
            pm.CountryID = dataReg[0].CountryID;
            pm.DistrictID = dataReg[0].DistrictID;
            pm.CityID = dataReg[0].CityID;
            pm.TalukaID = dataReg[0].TalukaID;
            pm.PatientType = dataReg[0].PatientType;
            pm.PatientID = dataReg[0].PatientID;
            pm.LastUpdatedBy = Util.GetString(HttpContext.Current.Session["ID"].ToString());
            pm.Updatedate = Util.GetDateTime(DateTime.Now);
            pm.State = dataReg[0].State;
            pm.StateID = dataReg[0].StateID;

            pm.EmergencyPhoneNo = dataReg[0].EmergencyPhoneNo;
            pm.IsNewPatient = dataReg[0].IsNewPatient;
            pm.IsRegistrationApply = Util.GetInt(Resources.Resource.RegistrationChargesApplicable);
            pm.PatientType_ID = Util.GetInt(dataReg[0].PatientType_ID);
            pm.PanelID = Util.GetInt(dataReg[0].PanelID);
            pm.Religion = dataReg[0].Religion;
            pm.PlaceOfBirth = dataReg[0].PlaceOfBirth;
            pm.IdentificationMark = dataReg[0].IdentificationMark;
            pm.IsInternational = dataReg[0].IsInternational;
            pm.OverSeaNumber = dataReg[0].OverSeaNumber;
            pm.EthenicGroup = dataReg[0].EthenicGroup;
            pm.IsTranslatorRequired = dataReg[0].IsTranslatorRequired;
            pm.FacialStatus = dataReg[0].FacialStatus;
            pm.Race = dataReg[0].Race;
            pm.Employement = dataReg[0].Employement;
            pm.MonthlyIncome = dataReg[0].MonthlyIncome;
            pm.ParmanentAddress = dataReg[0].ParmanentAddress;
            pm.IdentificationMarkSecond = dataReg[0].IdentificationMarkSecond;
            pm.LanguageSpoken = dataReg[0].LanguageSpoken;
            pm.EmergencyRelationOf = dataReg[0].EmergencyRelationOf;
            pm.EmergencyRelationName = dataReg[0].EmergencyRelationName;
            //
            pm.PhoneSTDCODE = dataReg[0].PhoneSTDCODE;
            pm.ResidentialNumber = dataReg[0].ResidentialNumber;
            pm.ResidentialNumberSTDCODE = dataReg[0].ResidentialNumberSTDCODE;
            pm.EmergencyFirstName = dataReg[0].EmergencyFirstName;
            pm.EmergencySecondName = dataReg[0].EmergencySecondName;
            pm.InternationalCountryID = dataReg[0].InternationalCountryID;
            pm.InternationalCountry = dataReg[0].InternationalCountry;
            pm.InternationalNumber = dataReg[0].InternationalNumber;
            pm.EmergencyAddress = dataReg[0].EmergencyAddress;
            //
            pm.Phone = dataReg[0].Phone;
            pm.IsUpdate = 1;
            pm.Remark = dataReg[0].Remark;
            pm.PMiddleName = dataReg[0].PMiddleName;
            pm.EmergencyPhone = dataReg[0].EmergencyPhone;
            pm.PurposeOfVisit = dataReg[0].PurposeOfVisit;
            pm.PurposeOfVisitID = dataReg[0].PurposeOfVisitID;
            pm.PRequestDept = dataReg[0].PRequestDept;
            pm.SecondMobileNo = dataReg[0].SecondMobileNo;
            pm.StaffDependantID = dataReg[0].StaffDependantID;
			 pm.LastFamilyUHIDNumber = dataReg[0].LastFamilyUHIDNumber;
            int row = pm.Update();

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " DELETE FROM PatientID_proofs WHERE PatientID='" + pm.PatientID + "' ");
            foreach (IDProof idProof in dataReg[0].PatientIDProofs)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " INSERT INTO PatientID_proofs (PatientID,IDProofID,IDProofName,IDProofNumber,EntryBy,EntryDate) VALUE('" + pm.PatientID + "','" + idProof.IDProofID + "','" + idProof.IDProofName + "','" + idProof.IDProofNumber + "','" + HttpContext.Current.Session["ID"].ToString() + "',NOW()) ");
            }



            try
            {
                var catureStatus = Util.GetInt(dataReg[0].isCapTure);
                if (catureStatus == 1)
                {
                    if (All_LoadData.chkDocumentDrive() == 0)
                        throw new Exception("Please Create " + Resources.Resource.DocumentDriveName + " Drive");

                    DateTime patientEnrolledDate = System.DateTime.Now;

                    patientEnrolledDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT pm.DateEnrolled FROM  patient_master pm  WHERE pm.PatientID='" + pm.PatientID + "'"));
                    var directoryPath = All_LoadData.createDocumentFolder("PatientPhoto", patientEnrolledDate.Year.ToString(), patientEnrolledDate.Month.ToString());
                    string filePath = Path.Combine(directoryPath.ToString(), pm.PatientID.ToString().Replace("/", "_") + ".jpg");
                    if (File.Exists(filePath))
                        File.Delete(filePath);

                    string strImage = dataReg[0].base64PatientProfilePic.Replace(dataReg[0].base64PatientProfilePic.Split(',')[0] + ",", "");
                    System.IO.File.WriteAllBytes(filePath, Convert.FromBase64String(strImage));
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }





            if (row == 0)
            {
                tnx.Rollback();
                return "";
            }

            return "1";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }

    }

}