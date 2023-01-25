using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Text.RegularExpressions;

/// <summary>
/// Summary description for StydyInsctanceUID
/// </summary>
public class StydyInsctanceUID
{
	public StydyInsctanceUID()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public  string GenerateStudyInstanceUid(string PatientId, DateTime StudyDateTime, string AccessionNo)
    {
        string GeneratedStudyUID = String.Empty;
        bool ApplyAsciiForAccessionNo = false;
       string DicomRootPrefix = "1.2.826.0.1.3680043.9.5282.030519";

        // Get DICOM GUID Prefix Root. 
        GeneratedStudyUID = DicomRootPrefix;
        // Get the formula to Apply. 
        string StudyUidFormula = "~DROOT~.~PATID~.~SDATETIME~.~ACCNO~";

        // Applying Root for th <add key="StudyInstanceUidFormula" value="~DROOT~.~PATID~.~SDATE~.~ACCNO~ ~SDATETIME~"/>
        StudyUidFormula = StudyUidFormula.Replace("~DROOT~", GeneratedStudyUID);

        // Apply Patient Id
        StudyUidFormula = StudyUidFormula.Replace("~PATID~", Regex.Replace(PatientId, @"[^\d]", ""));

        // Apply Study Date
        StudyUidFormula = StudyUidFormula.Replace("~SDATE~", Regex.Replace(String.Format("{0:javascript:void(0);yyyyMMdd}", StudyDateTime), @"[^\d]", ""));

        // Apply Study Date
        StudyUidFormula = StudyUidFormula.Replace("~SDATETIME~", Regex.Replace(String.Format("{0:yyyyMMddhhmmssttt}", StudyDateTime), @"[^\d]", ""));

        // Apply AccessionNo
        if (ApplyAsciiForAccessionNo)
        {
            String asciiAccessionValue = String.Empty;

            foreach (char character in AccessionNo)
            {
                asciiAccessionValue += (int)character;
            }

            StudyUidFormula = StudyUidFormula.Replace("~ACCNO~", asciiAccessionValue);
        }
        else
        {
            StudyUidFormula = StudyUidFormula.Replace("~ACCNO~", Regex.Replace(AccessionNo, @"[^\d]", ""));
        }

        // Remove Noise from the String. 
        StudyUidFormula = StudyUidFormula.Replace(".0", ".");
        GeneratedStudyUID = StudyUidFormula.Replace("..", ".");

        return GeneratedStudyUID;
    }

    private static string ConvertCharTOAscii(string Input)
    {
        StringBuilder Result = new StringBuilder();

        foreach (char OneLetter in Input)
        {
            if (Char.IsLetter(OneLetter))
                Result.Append((Convert.ToString((int)OneLetter)));
            else
                Result.Append(OneLetter);
        }
        return Result.ToString();
    }
}