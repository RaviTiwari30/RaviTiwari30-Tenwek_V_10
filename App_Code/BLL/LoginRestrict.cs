using System;

/// <summary>
/// Summary description for RoleRestrict
/// </summary>
public class LoginRestrict
{
	public LoginRestrict()
	{
		
	}
    public bool LoginDateRestrict(string RoleID, DateTime date, string EmpID)
    {

        if (EmpID == "EMP001" || EmpID == "EMP002" || EmpID == "LSHHI10")
            return true;
        else if (RoleID == "9")
        {
            if (date.AddDays(3).Date >= System.DateTime.Now.Date)
                return true;
            else
                return false;
        }
        return true;
    }

    public static string LoginDateRestrictMSG()
    {
        return "You are not authorized to view more than 3 days data";
    }

}
