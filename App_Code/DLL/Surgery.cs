using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Collections.Generic;


public class Surgery
{

    public static string SaveSurgeryMaster(string SurgeryName, string Dept, string ItemCode, MySqlTransaction tnx, string EmployeeId, int GroupID)
    {
       
        try
        {
            string SurgeryId = "";
            Surgery_Master objSurgery = new Surgery_Master(tnx);
            objSurgery.Name = SurgeryName;
            objSurgery.Ownership = "";
            objSurgery.GroupID = GroupID;
            objSurgery.Creator_ID = EmployeeId;
            objSurgery.Department = Dept;
            objSurgery.SurgeryCode = ItemCode;
            objSurgery.SurgeryGrade = "";
            objSurgery.IsActive = 1;
            SurgeryId = objSurgery.Insert().ToString();
            if (SurgeryId != "")
            {
                DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select ItemID,MinLimit,ItemType from f_itemmaster where issurgery=1").Tables[0];
                if (dt != null && dt.Rows.Count > 0)
                {
                    Surgery_Calculator objCal = new Surgery_Calculator(tnx);
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        objCal.SurgeryID = SurgeryId;
                        objCal.ItemID = dt.Rows[i]["ItemID"].ToString();
                        objCal.Percentage = Util.GetDecimal(dt.Rows[i]["MinLimit"].ToString());
                        objCal.Insert().ToString();
                    }
                }


            }
            
            return SurgeryId;


        }
        catch (Exception ex)
        {
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    public static string UpdateSurgeryMaster(string SurgeryId, List<Surgery_Calculator> SugItemList)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {

            int Row=MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "delete from f_surgery_calculator where SurgeryID='"+SurgeryId+"' ");

            if (Row >0)
            {
                //DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "select ItemID,MinLimit,ItemType from f_itemmaster where issurgery=1").Tables[0];
                //if (dt != null && dt.Rows.Count > 0)
                if (SugItemList != null && SugItemList.Count > 0)
                {
                    Surgery_Calculator objCal = new Surgery_Calculator(Tranx);
                    for (int i = 0; i < SugItemList.Count; i++)
                    {
                        objCal.SurgeryID = SurgeryId;
                        objCal.ItemID = SugItemList[i].ItemID;
                        objCal.Percentage = Util.GetDecimal(SugItemList[i].Percentage);
                        objCal.IsDiscountable = Util.GetInt(SugItemList[i].IsDiscountable);
                        objCal.Insert().ToString();
                    }
                }

            }
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return SurgeryId;
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
}
