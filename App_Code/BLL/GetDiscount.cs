using System;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for GetDiscount
/// </summary>
public class GetDiscount
{
	public GetDiscount()
	{

	}

    public decimal GetDefaultDiscount(string SubCategoryID, int PanelID, DateTime date, string PatientType, string type)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string sql = " select get_discount('" + SubCategoryID + "'," + PanelID + ",'" + date.ToString("yyyy-MM-dd") + "','" + PatientType + "','" + type + "')";
            MySqlCommand cmd = new MySqlCommand(sql, con);
            decimal disc = Util.GetDecimal(cmd.ExecuteScalar());          
            return disc;
        }
        catch
        {          
            return 0;
        }
        finally
        {
            con.Close();
        }

    }
    public string GetDefaultDiscount_Membership(string ItemID, string CardNo, string type)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string sql = " select get_discount_membership('" + ItemID + "','" + CardNo + "','" + type + "')";
            MySqlCommand cmd = new MySqlCommand(sql, con);
            string disc = Util.GetString(cmd.ExecuteScalar());
            if (disc == "0")
                return "0#0";
            else
                return disc;
        }
        catch
        {
            return "";
        }
        finally
        {
            con.Close();
        }

    }
    

}
