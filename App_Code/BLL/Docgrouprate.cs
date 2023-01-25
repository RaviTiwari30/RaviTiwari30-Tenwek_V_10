using System;
using System.Data;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for Docgrouprate
/// </summary>
public class Docgrouprate
{
    public Docgrouprate()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public DataTable GetDataTable(string type, string panel)
    {

        DataTable dtDocGroup = new DataTable();
        if (type == "OPD")
        {

            string str = "SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NAME,')',''),'(',''),'.',''),',',''),'#',''),'&',''),' ','') NAME,SubCategoryID FROM f_subcategorymaster WHERE CategoryID=(select categoryid from f_configrelation WHERE ConfigID=5) AND Active=1 ";
            DataTable dtsubcategory = StockReports.GetDataTable(str);
            if (dtsubcategory.Rows.Count > 0)
            {
                dtDocGroup.Columns.Add("DocGroup").DataType = typeof(string);

                foreach (DataRow dr in dtsubcategory.Rows)
                {
                    string subcatname = Util.GetString(dr["Name"]);//+"#"+dr["SubCategoryID"];
                    
                    dtDocGroup.Columns.Add(subcatname).DataType = typeof(string);


                }
                dtDocGroup.Columns.Add("SubCategoryID").DataType = typeof(string);
                dtDocGroup.Columns.Add("DocTypeId").DataType = typeof(int);

                string strdocgroup = "";
                strdocgroup = "select id ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Doctype,')',''),'(',''),'.',''),',',''),'#',''),'&',''),' ','') Doctype from doctorgroup where isactive=1  ";

                DataTable dttype = StockReports.GetDataTable(strdocgroup);
                if (dttype.Rows.Count > 0)
                {
                    for (int i = 0; i < dttype.Rows.Count; i++)
                    {
                        DataRow drnew = dtDocGroup.NewRow();

                        drnew["DocGroup"] = Util.GetString(dttype.Rows[i]["Doctype"]);

                        drnew["DocTypeId"] = Util.GetInt(dttype.Rows[i]["id"]);
                        foreach (DataRow dr in dtsubcategory.Rows)
                        {
                            string subcat = Util.GetString(dr["Name"]);
                            
                            if (drnew[subcat] != null)
                            {
                                string strdocgrouprate = "select DocGroupID,DocGroup,TYPE,SubCategoryID,Panel,Rate,DocTypeId FROM  docgrouprate WHERE DocTypeId='" + drnew["DocTypeId"] + "' and TYPE='" + type + "' and SubCategoryID='" + Util.GetString(dr["SubCategoryID"]) + "' and Panel='" + panel + "' and IsActive=1 ";
                                DataTable dtdocgrouprate = StockReports.GetDataTable(strdocgrouprate);
                                if (dtdocgrouprate.Rows.Count > 0)
                                {

                                    drnew[subcat] = Util.GetString(dtdocgrouprate.Rows[0]["Rate"]);
                                }

                            }
                            if (drnew["SubCategoryID"].ToString() == "")
                            {
                                drnew["SubCategoryID"] = Util.GetString(dr["SubCategoryID"]) + "_" + Util.GetInt(drnew["DocTypeId"]);
                            }
                            else
                            {
                                drnew["SubCategoryID"] = drnew["SubCategoryID"] + "#" + Util.GetString(dr["SubCategoryID"]) + "_" + Util.GetInt(drnew["DocTypeId"]);
                            }

                        }
                        dtDocGroup.Rows.Add(drnew);


                    }

                }
                dtDocGroup.AcceptChanges();

                // ViewState["dtDocGroup"] = dtDocGroup;
            }
        }
        else
        {
            string str = "SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NAME,')',''),'(',''),'.',''),',',''),'#',''),'&',''),' ','') NAME,SubCategoryID FROM f_subcategorymaster WHERE CategoryID=(select categoryid from f_configrelation WHERE ConfigID=1) and Active=1 ";
            DataTable dtsubcategory = StockReports.GetDataTable(str);
            if (dtsubcategory.Rows.Count > 0)
            {
                dtDocGroup.Columns.Add("RoomType").DataType = typeof(string);
                dtDocGroup.Columns.Add("IPDCaseTypeID").DataType = typeof(string);

                string strdocgroup = "";
                strdocgroup = "select id,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Doctype,')',''),'(',''),'.',''),',',''),'#',''),'&',''),' ','') Doctype from doctorgroup where isactive=1";
                DataTable dttype = StockReports.GetDataTable(strdocgroup);

                foreach (DataRow dr in dtsubcategory.Rows)
                {

                    if (dttype.Rows.Count > 0)
                    {
                        for (int i = 0; i < dttype.Rows.Count; i++)
                        {
                            string subcatname = dttype.Rows[i]["Doctype"].ToString() + "_" + Util.GetString(dr["Name"]);

                            dtDocGroup.Columns.Add(subcatname).DataType = typeof(string);

                        }
                    }

                }
                dtDocGroup.Columns.Add("SubCategoryID").DataType = typeof(string);
                dtDocGroup.Columns.Add("DocTypeId").DataType = typeof(int);



                string strRoomType = "";
                // strRoomType = "SELECT DISTINCT(NAME)RoomName,IPDCaseType_ID FROM ipd_case_type_master WHERE isactive=1 ";
                strRoomType = " select icm.Name RoomName,icm.IPDCaseType_ID from ipd_case_type_master icm inner join ipd_case_type_master bc on icm.IPDCaseType_ID = bc.BillingCategoryID where icm.IsActive=1 group by icm.IPDCaseType_ID order by icm.name";
                DataTable dtRoomType = StockReports.GetDataTable(strRoomType);
                DataTable dtALLDoctorGroupRate = StockReports.GetDataTable(" SELECT DocGroupID,DocGroup,TYPE,SubCategoryID,Panel,RoomTypeID,Rate,DocTypeId FROM  docgrouprate WHERE IsActive=1 ");


                if (dtRoomType.Rows.Count > 0)
                {
                    for (int i = 0; i < dtRoomType.Rows.Count; i++)
                    {


                        if (dttype.Rows.Count > 0)
                        {
                            DataRow drnew = dtDocGroup.NewRow();



                            drnew["RoomType"] = Util.GetString(dtRoomType.Rows[i]["RoomName"]);

                            drnew["IPDCaseTypeID"] = Util.GetString(dtRoomType.Rows[i]["IPDCaseType_ID"]);
                            //drnew["DocTypeId"] = Util.GetInt(dttype.Rows[i]["id"]);
                            foreach (DataRow dr in dtsubcategory.Rows)
                            {
                                for (int j = 0; j < dttype.Rows.Count; j++)
                                {
                                    drnew["DocTypeId"] = Util.GetInt(dttype.Rows[j]["id"]);
                                    string subcat = dttype.Rows[j]["Doctype"].ToString() + "_" + Util.GetString(dr["Name"]);
                                    
                                    if (drnew[subcat] != null)
                                    {
                                        //string strdocgrouprate = "select DocGroupID,DocGroup,TYPE,SubCategoryID,Panel,Rate,DocTypeId FROM  docgrouprate WHERE DocGroup='" + dttype.Rows[j]["Doctype"].ToString() + "' and TYPE='" + type + "' and SubCategoryID='" + Util.GetString(dr["SubCategoryID"]) + "' and Panel='" + panel + "' and RoomTypeID='" + drnew["IPDCaseTypeID"] + "' and IsActive=1 ";
                                        try
                                        {
                                            string WhereCondition = "DocTypeId='" + drnew["DocTypeId"] + "' and [TYPE]='" + type + "' and SubCategoryID='" + Util.GetString(dr["SubCategoryID"]) + "' and Panel='" + panel + "' and RoomTypeID='" + drnew["IPDCaseTypeID"] + "'";
                                            DataRow[] GroupRate = dtALLDoctorGroupRate.Select(WhereCondition);
                                            if (GroupRate.Length > 0)
                                            {
                                                DataTable dtdocgrouprate = dtALLDoctorGroupRate.Clone();
                                                foreach (DataRow drrate in GroupRate)
                                                {
                                                    dtdocgrouprate.ImportRow(drrate);
                                                }
                                                //if (dtdocgrouprate.Rows.Count > 0)
                                                //{

                                                drnew[subcat] = Util.GetString(dtdocgrouprate.Rows[0]["Rate"]);
                                                //}
                                            }
                                        }
                                        catch (Exception ex)
                                        {
                                            ClassLog ClLog = new ClassLog();
                                            ClLog.errLog(ex);
                                        }


                                    }

                                    if (drnew["SubCategoryID"].ToString() == "")
                                    {
                                        drnew["SubCategoryID"] = Util.GetString(dr["SubCategoryID"]) + "#" + Util.GetInt(drnew["DocTypeId"]);
                                    }
                                    else
                                    {
                                        drnew["SubCategoryID"] = drnew["SubCategoryID"] + "_" + Util.GetString(dr["SubCategoryID"]) + "#" + Util.GetInt(drnew["DocTypeId"]);
                                    }

                                }


                            }
                            dtDocGroup.Rows.Add(drnew);



                        }



                    }

                }
                dtDocGroup.AcceptChanges();
            }
        }
        return dtDocGroup;


    }
    public string SaveDocAll(string UserId, string type)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (type == "OPD")
            {
                string Deactivate = "UPDATE f_ratelist rl INNER JOIN f_rate_schedulecharges rs ON rs.PanelID=rl.PanelID" +
                                         "   INNER JOIN f_itemmaster im ON im.itemiD=rl.ItemID" +
                                         "   INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID " +
                                         "   INNER JOIN f_configrelation cf ON cf.CategoryID=sm.CategoryID" +
                                         "   SET IsCurrent=0" +
                                         "   WHERE rs.IsDefault=1 AND rl.IsCurrent=1 AND cf.ConfigID=5";
                int result1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Deactivate);

                string str = " INSERT INTO f_ratelist(Location,Hospcode,Rate,IsCurrent,ItemID,PanelID,ScheduleChargeID,UserID)" +
                            "   SELECT 'L','SHHI',Rate,1,ItemID,Panel,ScheduleChargeID,'" + UserId + "' FROM doctor_master dm INNER JOIN docgrouprate dr ON dm.DocGroupID=dr.DocTypeID" +
                            "   INNER JOIN f_rate_schedulecharges rsch ON rsch.PanelID=dr.Panel AND IsDefault=1" +
                            "   INNER JOIN f_itemmaster im ON im.Type_ID=dm.DoctorID AND im.SubCategoryID=dr.SubCategoryID" +
                            "   INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID AND sm.Active=1" +
                            "   INNER JOIN f_configrelation cf ON cf.CategoryID=sm.CategoryID" +
                            "   WHERE dm.IsActive=1 AND dr.IsActive=1 AND TYPE='OPD' AND cf.ConfigID=5";

                int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                
               MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ratelist SET RateListID=CONCAT(Location,HospCode,ID) WHERE IFNULL(RatelistID,'')=''");
               MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist) WHERE groupname='f_ratelist'  ");
                tnx.Commit();
                tnx.Dispose();
                return "1";
            }
            else
            {

                string Deactivate = "UPDATE f_ratelist_ipd rl INNER JOIN f_rate_schedulecharges rs ON rs.PanelID=rl.PanelID" +
                                          "  INNER JOIN f_itemmaster im ON im.itemiD=rl.ItemID " +
                                          "  INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID " +
                                          "  INNER JOIN f_configrelation cf ON cf.CategoryID=sm.CategoryID" +
                                          "  SET IsCurrent=0" +
                                          "  WHERE rs.IsDefault=1 and IsCurrent=1 AND cf.ConfigID=1";
                int result1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Deactivate);

                string str = " INSERT INTO f_ratelist_ipd(Location,Hospcode,Rate,IsCurrent,ItemID,PanelID,ScheduleChargeID,UserID,IPDCaseType_ID)" +
                                "SELECT 'L','SHHI',Rate,1,ItemID,Panel,ScheduleChargeID,'" + UserId + "',dr.RoomTypeID FROM doctor_master dm INNER JOIN docgrouprate dr ON dm.DocGroupID=dr.DocTypeID" +
                                "  INNER JOIN f_rate_schedulecharges rsch ON rsch.PanelID=dr.Panel AND IsDefault=1" +
                                "  INNER JOIN f_itemmaster im ON im.Type_ID=dm.DoctorID AND im.SubCategoryID=dr.SubCategoryID" +
                                "  INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID AND sm.Active=1" +
                                "  INNER JOIN f_configrelation cf ON cf.CategoryID=sm.CategoryID" +
                                "  WHERE dm.IsActive=1 AND dr.IsActive=1 AND TYPE='IPD' AND cf.ConfigID=1";

                int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                
                 MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ratelist_ipd SET RateListID=CONCAT(Location,HospCode,ID) WHERE IFNULL(RatelistID,'')=''");
                 MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist_ipd) WHERE groupname='f_ratelist_ipd'  ");
                tnx.Commit();
                tnx.Dispose();
                return "1";
            }
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
    }
    public string Save(string strData, string panelid, string type)
    {
        string[] data = strData.Split('$');
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            decimal rate = 0;
            if (type == "OPD")
            {
                string strdelete = "delete from docgrouprate where TYPE='OPD' and panel=" + panelid + " ";
                int resultdelete = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strdelete);
                int i = 0;
                foreach (string row in data)
                {

                    if (i > 0)
                    {
                        if (i == data.Length - 1)
                        {
                            break;
                        }
                        string[] rowdata = row.Split('|');
                        string DocGroup = Util.GetString(rowdata[0]);
                        string newSubCategoryID = Util.GetString(rowdata[rowdata.Length - 3]);
                        string[] SubCategoryID = newSubCategoryID.Split('#');
                        for (int j = 1; j < rowdata.Length - 3; j++)
                        {
                            rate = Util.GetDecimal(Util.GetString(rowdata[j]));
                            string SubCategory = SubCategoryID[j - 1];
                            string str = "Insert into docgrouprate (DocGroup,TYPE,SubCategoryID,Panel,Rate,IsActive,DocTypeId) values ('" + DocGroup + "','" + type + "','" + SubCategory.Split('_')[0].ToString() + "'," + panelid + "," + rate + ",1," + SubCategory.Split('_')[1].ToString() + " )";
                            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                        }
                    }
                    i++;
                }
                tnx.Commit();
                tnx.Dispose();
                return "1";
            }
            else
            {
                string rowheader = "";
                string[] rowheaderdata = { };
                string strdelete = "delete from docgrouprate where TYPE='IPD' and panel=" + panelid + " ";
                int resultdelete = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strdelete);
                int i = 0;
                foreach (string row in data)
                {
                    if (i == 0)
                    {
                        rowheader = row;
                        rowheaderdata = rowheader.Split('|');
                    }
                    if (i > 0)
                    {
                        if (i == data.Length - 1)
                        {
                            break;
                        }
                        string[] rowdata = row.Split('|');
                        string Room = Util.GetString(rowdata[0]);
                        string RoomType = Util.GetString(rowdata[1]);
                        string newSubCategoryID = Util.GetString(rowdata[rowdata.Length - 3]);
                        string[] SubCategoryID = newSubCategoryID.Split('_');
                        for (int j = 2; j < rowdata.Length - 3; j++)
                        {
                            rate = Util.GetDecimal(Util.GetString(rowdata[j]));
                            string SubCategory = SubCategoryID[j - 2];
                            string DocGroup = rowheaderdata[j].Split('_')[0].ToString();
                            string str = "Insert into docgrouprate (DocGroup,TYPE,SubCategoryID,Panel,Rate,RoomTypeID,IsActive,DocTypeId) values ('" + DocGroup + "','" + type + "','" + SubCategory.Split('#')[0].ToString() + "'," + panelid + "," + rate + ",'" + RoomType + "',1 ," + SubCategory.Split('#')[1].ToString() + ")";
                            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                        }
                    }
                    i++;
                }
                tnx.Commit();
                tnx.Dispose();
                return "1";
            }
        }
       
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
    }
}
