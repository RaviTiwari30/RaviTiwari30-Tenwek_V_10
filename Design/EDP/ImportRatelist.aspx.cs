using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.IO;
using System.Data.OleDb;
using System.Text;
using Microsoft.Office; 
using System.Collections.Generic;
using ClosedXML.Excel;

public partial class Design_EDP_ImportRateList : System.Web.UI.Page
{
    string[] Fields;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPanel();
            LoadScheduleCharges();
            ViewState["UserID"] = Session["ID"].ToString();
        }
        lblMsg.Text = "";
    }

    private void LoadPanel()
    {
        DataTable dt = new DataTable();
        if (rbtnType.SelectedValue == "1")
        {
            dt = StockReports.GetDataTable("select pm.Company_Name,pm.PanelID from f_panel_master pm INNER JOIN f_rate_schedulecharges rsc ON rsc.panelid=pm.PanelID where pm.PanelID = ReferenceCode");
        }
        else if (rbtnType.SelectedValue == "0")
        {
            dt = StockReports.GetDataTable("select pm.Company_Name,pm.PanelID from f_panel_master pm INNER JOIN f_rate_schedulecharges rsc ON rsc.panelid=pm.PanelID where pm.PanelID = ReferenceCodeOPD");
        }
       //CreateStockMaster.LoadPanelCompanyRefOPD();
        ddlPanel.DataSource = dt;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();
        BindCentre();
    }

    private void LoadScheduleCharges()
    {
        DataTable dtCharges = StockReports.GetDataTable("SELECT NAME,ScheduleChargeID FROM f_rate_schedulecharges WHERE panelID=" + ddlPanel.SelectedValue + " ");
        ddlScheduleCharges.DataSource = dtCharges;
        ddlScheduleCharges.DataTextField = "NAME";
        ddlScheduleCharges.DataValueField = "ScheduleChargeID";
        ddlScheduleCharges.DataBind();
    }
    
    protected void ddlPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadScheduleCharges();
        BindCentre();
    }
    protected void rbtntype_changed(object sender,EventArgs e)
    {
        if (rbtnType.SelectedValue == "0")
        {
            rbtnipdtype.Visible = false;            
        }
        else
        {
            rbtnipdtype.Visible = true;
        }
    }
      
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (FileUpload1.HasFile)
        {
            string FileExtension = Path.GetExtension(FileUpload1.PostedFile.FileName);

            if (FileExtension.ToLower() != ".xlsx")
            {
                lblMsg.Text = "Kindly Upload Excel files...";
                return;
            }
        }


        if (FileUpload1.HasFile)
        {
            string strQuery = "";
            StringBuilder sb = new StringBuilder();
            //Converting Excel file to CSV

            string FileName = "";
            string Mypath = "";
            string TableName = "tmp_rate_Upload";

            string PanelID = ddlPanel.SelectedItem.Value;
            string ScheduleChargeID = ddlScheduleCharges.SelectedItem.Value;

            if (!Directory.Exists(Server.MapPath("~/Design/EDP/TempFiles/")))
                Directory.CreateDirectory(Server.MapPath("~/Design/EDP/TempFiles/"));

            FileName = Path.GetFileName(FileUpload1.FileName);
            Mypath = Server.MapPath("~/Design/EDP/TempFiles/" + FileName);

            if (File.Exists(Mypath))
                File.Delete(Mypath);

            FileUpload1.SaveAs(Mypath);


            MySqlConnection con1 = Util.GetMySqlCon();
            con1.Open();
            MySqlTransaction Tnx = con1.BeginTransaction(IsolationLevel.Serializable);

            if (rbtnType.SelectedValue == "0") // OPD
            {
                try
                {
                    //Delete OLd Table
                    StockReports.ExecuteDML("Drop Table if Exists " + TableName + " ");

                    //Create New Table
                    strQuery = CreateTable(TableName, Mypath);
                    StockReports.ExecuteDML(strQuery);

                    if (strQuery.ToUpper().Contains("OPD") == false)
                    {
                        lblMsg.Text = "The File does not contain a Rate Column 'OPD'. Kindly Check. ";
                        return;
                    }
                    if (strQuery.Contains("ItemID") == false) {
                        lblMsg.Text = "The File does not contain a ItemID Column. Kindly Check. ";
                        return;
                    }
                    strQuery = "ALTER TABLE " + TableName + " ADD INDEX (ItemID)";
                    StockReports.ExecuteDML(strQuery);

                    using (XLWorkbook workBook = new XLWorkbook(Mypath))
                    {
                        //Read the first Sheet from Excel file.
                        IXLWorksheet workSheetBillDetail = workBook.Worksheet(1);
                        string sqlquerydata = BulkInsert(workSheetBillDetail, TableName);
                        if (sqlquerydata.Length > 1)
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sqlquerydata);
                    }

                    //string updt = "UPDATE " + TableName + "  SET CPTCode = REPLACE(CPTCode,'@',''),ItemDIsplayName=REPLACE(ItemDIsplayName,'@','')  ";
                    //StockReports.ExecuteDML(updt);

                    sb = new StringBuilder();
                    sb.Append("Insert into f_ratelist_bkup(");
                    sb.Append(" ID,RateListID,Hospital_ID,Rate,FromDate,ToDate,");
                    sb.Append(" IsCurrent,ItemID,PanelID,ItemDisplayName,");
                    sb.Append(" ItemCode,ScheduleChargeID,UserID,EntryDate,LastUpdatedBy,");
                    sb.Append(" Updatedate,IpAddress,CentreID)");
                    sb.Append(" Select rt.ID,rt.RateListID,rt.Hospital_ID,rt.Rate,rt.FromDate,rt.ToDate,");
                    sb.Append(" rt.IsCurrent,rt.ItemID,rt.PanelID,rt.ItemDisplayName,");
                    sb.Append(" rt.ItemCode,rt.ScheduleChargeID,rt.UserID,rt.EntryDate,rt.LastUpdatedBy,");
                    sb.Append("rt.Updatedate,rt.IpAddress,rt.CentreID");
                    sb.Append(" from f_ratelist rt INNER JOIN " + TableName + " dt ON dt.ItemID = rt.ItemID  ");
                    sb.Append("Where rt.PanelID = " + PanelID + " and rt.IsCurrent=1 and rt.ScheduleChargeID='" + ScheduleChargeID + "' and rt.CentreID="+Util.GetInt(ddlCentre.SelectedValue.ToString())+" ");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                    sb = new StringBuilder();
                    sb.Append("Delete rt.* from f_ratelist rt INNER JOIN " + TableName + " dt ON dt.ItemID = rt.ItemID  Where  ");
                    sb.Append("rt.PanelID = " + PanelID + " and rt.IsCurrent=1 and rt.ScheduleChargeID='" + ScheduleChargeID + "' and rt.CentreID=" + Util.GetInt(ddlCentre.SelectedValue.ToString()) + "  ");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                    sb = new StringBuilder();
                    sb.Append("Insert into f_ratelist(Location,Hospcode,Rate,IsCurrent,ItemID,PanelID,ItemDisplayName,ItemCode,ScheduleChargeID,UserID,CentreID) ");
                    sb.Append(" Select 'L','SHHI',OPD,1,ItemID," + PanelID + ",ItemDisplayName,ItemCode,'" + ScheduleChargeID + "','" + ViewState["UserID"].ToString() + "'," + Util.GetInt(ddlCentre.SelectedValue.ToString()) + "  from " + TableName + " Where ItemID>0 ");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                    sb = new StringBuilder();
                    sb.Append("update f_ratelist set RatelistID = concat(location,hospcode,id),itemid = REPLACE(REPLACE(itemid, '\r', ''), '\n', '') where RatelistID is null or RatelistID=''");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                    sb = new StringBuilder();
                    sb.Append("UPDATE id_master SET MaxID=(SELECT MAX(ID) FROM f_ratelist ) WHERE GroupName='f_ratelist' ");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                    
                    Tnx.Commit();                    
                    lblMsg.Text = "Record Saved Successfully";

                }
                catch (Exception ex)
                {
                    Tnx.Rollback();                  
                    ClassLog objClassLog = new ClassLog();
                    objClassLog.errLog(ex);
                    lblMsg.Text = ex.Message;
                }
                finally
                {
                    Tnx.Dispose();
                    con1.Close();
                    con1.Dispose();
                }
            }
            else /// IPD
            {

                try
                {
                    if (rbtnipdtype.SelectedValue == "0")
                    {
                        //Delete OLd Table
                        StockReports.ExecuteDML("Drop Table if Exists " + TableName + " ");

                        //Create New Table
                        strQuery = CreateTable(TableName, Mypath);
                        StockReports.ExecuteDML(strQuery);

                        strQuery = "ALTER TABLE " + TableName + " ADD INDEX (ItemID)";
                        StockReports.ExecuteDML(strQuery);

                        using (XLWorkbook workBook = new XLWorkbook(Mypath))
                        {
                            //Read the first Sheet from Excel file.
                            IXLWorksheet workSheetBillDetail = workBook.Worksheet(1);
                            string sqlquerydata = BulkInsert(workSheetBillDetail, TableName);
                            if (sqlquerydata.Length > 1)
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sqlquerydata);
                        }
                        //string updt = "UPDATE " + TableName + "  SET ItemCode = REPLACE(ItemCode,'@',''),ItemDIsplayName=REPLACE(ItemDIsplayName,'@','');";
                        //StockReports.ExecuteDML(updt);
                        strQuery = "DROP TABLE IF EXISTS dtTmp_IPD";
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);


                        DataTable dtTmp_IPD = StockReports.GetDataTable("Select * from " + TableName + " ");
                        foreach (DataColumn drIPD in dtTmp_IPD.Columns)
                        {
                            string IPDCaseTypeID = StockReports.ExecuteScalar("Select IPDCaseTypeID from IPD_Case_Type_Master where IsActive=1 and UCASE(Trim(Abbreviation))='" + drIPD.ColumnName.Trim().ToUpper() + "'");
                            if (IPDCaseTypeID != "")
                            {
                                string Rate = drIPD.ColumnName.Trim().ToUpper();

                                strQuery = "INSERT INTO f_ratelist_ipd_bkup(" +
                                "ID,RateListID,Hospital_ID,Rate,FromDate,ToDate," +
                                "IsCurrent,ItemID,PanelID,IPDCaseTypeID,ItemDisplayName," +
                                "ItemCode,ScheduleChargeID,UserID,EntryDate,LastUpdatedBy," +
                                "Updatedate,IpAddress,CentreID)" +
                                "SELECT rt.ID,rt.RateListID,rt.Hospital_ID,rt.Rate,rt.FromDate,rt.ToDate," +
                                "rt.IsCurrent,rt.ItemID,rt.PanelID,rt.IPDCaseTypeID,rt.ItemDisplayName," +
                                "rt.ItemCode,rt.ScheduleChargeID,rt.UserID,rt.EntryDate,rt.LastUpdatedBy," +
                                "rt.Updatedate,rt.IpAddress,rt.CentreID " +
                                "FROM f_ratelist_ipd rt INNER JOIN " + TableName + " dt ON dt.ItemID = rt.ItemID " +
                                "WHERE rt.PanelID = " + PanelID + " " +
                                "AND rt.ScheduleChargeID='" + ScheduleChargeID + "' AND rt.IsCurrent=1 AND rt.IPDCaseTypeID='" + IPDCaseTypeID + "' and rt.CentreID=" + Util.GetInt(ddlCentre.SelectedValue.ToString()) + "  ";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);

                                strQuery = "Delete rt.* FROM f_ratelist_ipd rt INNER JOIN " + TableName + " dt ON dt.ItemID = rt.ItemID " +
                                "WHERE rt.PanelID = " + PanelID + " " +
                                "AND rt.ScheduleChargeID='" + ScheduleChargeID + "' AND rt.IsCurrent=1 AND rt.IPDCaseTypeID='" + IPDCaseTypeID + "' and rt.CentreID=" + Util.GetInt(ddlCentre.SelectedValue.ToString()) + " ";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);

                                strQuery = " INSERT INTO f_ratelist_ipd(Location,Hospcode,Rate,IsCurrent,ItemID,PanelID,IPDCaseTypeID," +
                                "ItemDisplayName,ItemCode,ScheduleChargeID,UserID,CentreID )" +
                                "SELECT 'L','SHHI'," + Rate + ",1,ItemID," + PanelID + ",'" + IPDCaseTypeID + "',ItemDisplayName,ItemCode," +
                                "'" + ScheduleChargeID + "','" + ViewState["UserID"].ToString() + "'," + Util.GetInt(ddlCentre.SelectedValue.ToString()) + "  FROM " + TableName + " Where ItemID>0  ";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);

                                strQuery = "update f_ratelist_ipd set RatelistID = concat(location,hospcode,id),itemid = REPLACE(REPLACE(itemid, '\r', ''), '\n', '') where RatelistID is null or RatelistID=''";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);

                                sb = new StringBuilder();
                                sb.Append("UPDATE id_master SET MaxID=(SELECT MAX(ID) FROM f_ratelist_ipd ) WHERE GroupName='f_ratelist_ipd' ");
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                            }
                        }

                        Tnx.Commit();

                        lblMsg.Text = "Record Saved Successfully";
                    }
                    else
                    {
                        //Delete OLd Table
                        StockReports.ExecuteDML("Drop Table if Exists " + TableName + " ");

                        //Create New Table
                        strQuery = CreateTable(TableName, Mypath);
                        StockReports.ExecuteDML(strQuery);

                        strQuery = "ALTER TABLE " + TableName + " ADD INDEX (ItemID)";
                        StockReports.ExecuteDML(strQuery);

                        using (XLWorkbook workBook = new XLWorkbook(Mypath))
                        {
                            //Read the first Sheet from Excel file.
                            IXLWorksheet workSheetBillDetail = workBook.Worksheet(1);
                            string sqlquerydata = BulkInsert(workSheetBillDetail, TableName);
                            if (sqlquerydata.Length > 1)
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sqlquerydata);
                        }
                   //     string updt = "UPDATE " + TableName + "  SET  itemid = trim(REPLACE(REPLACE(itemid, '\r', ''), '\n', ''))  ";
                     //   StockReports.ExecuteDML(updt);

                        strQuery = "DROP TABLE IF EXISTS dtTmp_IPD_surgery";
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);


                        DataTable dtTmp_IPD_surgery = StockReports.GetDataTable("Select * from " + TableName + " limit 1");
                        foreach (DataColumn drIPD in dtTmp_IPD_surgery.Columns)
                        {
                            string IPDCaseTypeID = StockReports.ExecuteScalar("Select IPDCaseTypeID from IPD_Case_Type_Master where IsActive=1 AND CentreID=" + ddlCentre.SelectedValue + " and UCASE(Trim(Abbreviation))='" + drIPD.ColumnName.Trim().ToUpper() + "'");
                            if (IPDCaseTypeID != "")
                            {
                                string Rate = drIPD.ColumnName.Trim().ToUpper();

                                strQuery = "INSERT INTO f_surgery_rate_list_bkup(" +
                                "ID,surgery_id,PanelID," +
                                "IPDCaseTypeID,rate,panelcode,iscurrent,datefrom," +
                                "userid,ScheduleChargeID," +
                                "paneldisplayname,CentreID )" +
                                "SELECT rt.ID,rt.surgery_id," +
                                "rt.PanelID,rt.IPDCaseTypeID,rt.rate,rt.panelcode,rt.iscurrent," +
                                "NOW(),'" + ViewState["UserID"].ToString() + "',rt.schedulechargeid,rt.paneldisplayname,rt.CentreID " +
                                "FROM f_surgery_rate_list rt INNER JOIN " + TableName + " dt ON dt.ItemID = rt.surgery_id " +
                                "WHERE rt.PanelID = " + PanelID + " " +
                                "AND rt.ScheduleChargeID='" + ScheduleChargeID + "' AND rt.IsCurrent=1 AND rt.IPDCaseTypeID='" + IPDCaseTypeID + "' and rt.CentreID=" + Util.GetInt(ddlCentre.SelectedValue.ToString()) + " ";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);

                                strQuery = "Delete rt.* FROM f_surgery_rate_list rt INNER JOIN " + TableName + " dt ON dt.ItemID = rt.surgery_id " +
                                "WHERE rt.PanelID = " + PanelID + " " +
                                "AND rt.ScheduleChargeID='" + ScheduleChargeID + "' AND rt.IsCurrent=1 AND rt.IPDCaseTypeID='" + IPDCaseTypeID + "' and rt.CentreId=" + Util.GetInt(ddlCentre.SelectedValue.ToString()) + " ";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);

                                strQuery = " INSERT INTO  f_surgery_rate_list(Surgery_ID,PanelID,IPDCaseTypeID,rate,panelcode,iscurrent,userid,ScheduleChargeID,paneldisplayname,CentreID)" +
                                   "SELECT ItemID," + PanelID + ",'" + IPDCaseTypeID + "'," + Rate + ",ItemCode,'1'," +
                                "'" + ViewState["UserID"].ToString() + "','" + ScheduleChargeID + "',ItemDisplayName," + Util.GetInt(ddlCentre.SelectedValue.ToString()) + "  FROM " + TableName + " Where ItemID>0 ";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);

                                //strQuery = "update f_ratelist_ipd set RatelistID = concat(location,hospcode,id) where RatelistID is null or RatelistID=''";
                                //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);


                            }
                        }

                        Tnx.Commit();

                        lblMsg.Text = "Record Saved Successfully";

                    }


                }
                catch (Exception ex)
                {
                    Tnx.Rollback();
                   
                    lblMsg.Text = "Record Not Saved";
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                finally
                {
                    Tnx.Dispose();
                    con1.Close();
                    con1.Dispose();
                }
            }
        }
        else
            lblMsg.Text = "Kindly Upload File..";
   }

    public string CreateTable(string tableName, string Path)
    {
        XLWorkbook workBook = new XLWorkbook(Path);
        IXLWorksheet workSheetBillDetail = workBook.Worksheet(1);
        bool firstRow = true;
        string strQuery = "CREATE TABLE " + tableName + "(\n";
        int rowcount = 0;
        foreach (IXLRow row in workSheetBillDetail.Rows())
        {
            if (!row.IsEmpty())
            {
                rowcount = rowcount + 1;
                if (firstRow)
                {
                    if (rowcount == 3)
                    {
                        foreach (IXLCell cell in row.Cells())
                        {
                            strQuery = strQuery + cell.Value.ToString() + " varchar(800),";
                        }
                        firstRow = false;
                        break;
                    }
                }
            }
        }
        strQuery = strQuery.Substring(0, strQuery.Length - 1) + ")DEFAULT CHARSET=utf8;";
        return strQuery;
    }

    public DataTable RemoveDuplicateRows(DataTable dTable, string colName)
    {
        Hashtable hTable = new Hashtable();
        ArrayList duplicateList = new ArrayList();

        //Add list of all the unique item value to hashtable, which stores combination of key, value pair.
        //And add duplicate item value in arraylist.
        foreach (DataRow drow in dTable.Rows)
        {
            if (hTable.Contains(drow[colName]))
                duplicateList.Add(drow);
            else
                hTable.Add(drow[colName], string.Empty);
        }

        //Removing a list of duplicate items from datatable.
        foreach (DataRow dRow in duplicateList)
            dTable.Rows.Remove(dRow);

        //Datatable which contains unique records will be return as output.
        return dTable;
    }

    private void BindCentre()
    {
        string str = "SELECT cm.CentreID,cm.CentreName,fcp.IsDefault FROM f_center_panel fcp INNER JOIN center_master cm ON fcp.CentreID=cm.CentreID WHERE cm.isActive=1 AND fcp.isActive=1  AND fcp.PanelID='" + ddlPanel.SelectedValue.ToString() + "' ";
        DataTable dtCentre = StockReports.GetDataTable(str);
        ddlCentre.DataSource = dtCentre;
        ddlCentre.DataTextField = "CentreName";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
      //  ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(Util.GetString(dtCentre.Select("IsDefault=1")[0]["CentreID"])));
        ddlCentre.Items.Insert(0, new ListItem("Select","0"));
    }
    public string BulkInsert(IXLWorksheet workSheetData, string TableName)
    {
        //Loop through the Worksheet rows.
        //var nonEmptyDataRows = workSheetData.Worksheet(1).RowsUsed();
        bool firstRow = true;
        string strQuery = " INSERT INTO " + TableName + "(  ";
        int rowcount = 0;
        foreach (IXLRow row in workSheetData.Rows())
        {

            if (!row.IsEmpty())
            {
                rowcount = rowcount + 1;
                //Use the first row to add columns to DataTable.
                if (rowcount >= 3)
                {
                    if (firstRow)
                    {
                        foreach (IXLCell cell in row.Cells())
                        {
                            //if (!cell.IsEmpty())
                                strQuery = strQuery + cell.Value.ToString() + " ,"; 
                            //else
                              //  strQuery = strQuery + " " + " ,"; 
                        }
                        strQuery = strQuery.Substring(0, strQuery.Length - 1);

                        strQuery = strQuery + " ) values ";
                        firstRow = false;
                    }
                    else
                    {
                        //Add rows to DataTable.
                        strQuery = strQuery + "( ";
                        //    int i = 0;
                        foreach (IXLCell cell in row.Cells())
                        {
                            //string ss == strQuery == null ? null : e.ExcelCell.Value.ToString();
                            try
                            {
                                if (cell.IsEmpty())
                                    strQuery = strQuery + "''" + " ,";
                                else
                                    strQuery = strQuery + "'" + cell.Value.ToString() + "',";
                            }
                            catch (Exception ex) { }
                            //   i++;
                        }
                        strQuery = strQuery.Substring(0, strQuery.Length - 1);
                        strQuery = strQuery + " ),";
                    }
                }
            }
        }
        strQuery = strQuery.Substring(0, strQuery.Length - 1);


        strQuery = strQuery + ";";

        if (rowcount == 1)
            return "";
        else
            return strQuery;
    }
}
