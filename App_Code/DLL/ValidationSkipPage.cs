using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ValidationSkipPage
/// </summary>
public class ValidationSkipPage
{
    public static List<string> ValidationSkipPages()
    {
        List<string> page = new List<string>();
        page.Add("~/Welcome.aspx".ToLower());
        //page.Add("/Design/Doctor/DoctorEdit.aspx".ToLower());
        page.Add("/Design/DoctorScreen/DisplayScreen.aspx".ToLower());
        page.Add("/Design/DoctorScreen/DisplayScreen.aspx");
        page.Add("/Design/Common/UserAuthorization.aspx".ToLower());
        page.Add("/Design/Payroll/Employee_ProfessionalDetail.aspx".ToLower());
        page.Add("/Design/Payroll/Employee_ProfessionalDetail.aspx".ToLower());
        page.Add("/Design/Lab/AddAttachment.aspx".ToLower());
        page.Add("/Design/Lab/AddReport.aspx".ToLower());
        page.Add("/Design/Lab/PatientSampleinfoPopup.aspx".ToLower());
	page.Add("/Design/Doctor/DoctorEdit.aspx".ToLower());
        return page;
    }
}