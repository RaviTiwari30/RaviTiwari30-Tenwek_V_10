using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Configuration;
using System.Collections;
using MySql.Data.MySqlClient;
using System.IO;
using System.Collections.Generic;
using ClosedXML;
using ClosedXML.Excel;
using System.Linq;

public partial class Design_Store_PhysicalVerifcation_New : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            BindCentre();
        }
    }
    private void BindCentre()
    {
        string str = "SELECT cm.CentreID,cm.CentreName FROM center_master cm WHERE cm.isActive=1 ";
        DataTable dtCentre = StockReports.GetDataTable(str);
        ddlCentre.DataSource = dtCentre;
        ddlCentre.DataTextField = "CentreName";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
        ddlCentre.Items.Insert(0, new ListItem("Select", "0"));
        ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(Session["CentreID"].ToString()));
        BindDepartment();
    }
    private void BindDepartment()
    {
        string CentreID = ddlCentre.SelectedValue;
        DataTable dtdept = LoadCacheQuery.bindStoreDepartment();
        DataView dv = dtdept.DefaultView;
        if (CentreID == "")
            CentreID = HttpContext.Current.Session["CentreID"].ToString();
        string ledgerNumber = StockReports.ExecuteScalar("SELECT DISTINCT GROUP_CONCAT(CONCAT('''',rm.DeptLedgerNo,'''')) FROM f_rolemaster rm INNER JOIN f_centre_role cr ON cr.RoleID=rm.id WHERE cr.CentreID IN (" + CentreID + ") AND cr.isActive=1");
        dv.RowFilter = "ledgerNumber in (" + ledgerNumber + ") ";
        dtdept = dv.ToTable();
        string rolelist = "LSHHI111,";
        string[] ExceptionDeptList = rolelist.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
        if (ExceptionDeptList.Contains(HttpContext.Current.Session["DeptLedgerNo"].ToString()))
            dtdept = dtdept.AsEnumerable().Where(r => r.Field<int>("IsStore") == 1 || r.Field<int>("IsMedical") == 1 || r.Field<int>("IsGeneral") == 1).AsDataView().ToTable();
        else
            dtdept = dtdept.AsEnumerable().Where(r => r.Field<int>("IsStore") == 1 || r.Field<int>("IsMedical") == 1 || r.Field<int>("IsGeneral") == 1).AsDataView().ToTable();
        if (dtdept.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dtdept;
            ddlDepartment.DataTextField = "ledgerName";
            ddlDepartment.DataValueField = "ledgerNumber";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
            ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByValue(Session["DeptLedgerNo"].ToString()));
        }
    }
    public string BulkInsert(IXLWorksheet workSheetData, string TableName)
    {
        //Loop through the Worksheet rows.
        bool firstRow = true;
        string strQuery = " INSERT INTO " + TableName + "(  ";
        int rowcount = 0;
        foreach (IXLRow row in workSheetData.Rows())
        {

            if (!row.IsEmpty())
            {
                rowcount = rowcount + 1;
                //Use the first row to add columns to DataTable.
                if (firstRow)
                {
                    foreach (IXLCell cell in row.Cells())
                    {

                        strQuery = strQuery + cell.Value.ToString() + " ,";
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
                        try
                        {
                            if (cell.DataType.ToString().ToUpper() == "DATETIME")
                                strQuery = strQuery + "'" + Util.GetDateTime(cell.Value).ToString("yyyy-MM-dd") + "',";
                            //  string A = cell.WorksheetColumn().ColumnLetter();
                            else
                            {

                                strQuery = strQuery + "'" + cell.Value.ToString() + "',";
                            }
                        }
                        catch (Exception ex) { }
                        //   i++;
                    }
                    strQuery = strQuery.Substring(0, strQuery.Length - 1);
                    strQuery = strQuery + " ),";
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
    public static string CreateTable(string tableName, string Path)
    {
        string CSVFilePathName = Path;
        string[] Lines = File.ReadAllLines(CSVFilePathName);
        string[] Fields;
        Fields = Lines[0].Split(new char[] { ',' });
        int Cols = Fields.GetLength(0);

        string sqlsc = "", strFieldsOnly = "";
        sqlsc = "CREATE TABLE " + tableName + "(\n";
        //sqlsc += "ID int(11) NOT NULL AUTO_INCREMENT, ";

        for (int i = 0; i < Cols; i++)
        {
            sqlsc += "\n" + Fields[i].Trim().ToUpper();
            sqlsc += " varchar(500) ";
            sqlsc += ",";

            strFieldsOnly += Fields[i].Trim().ToUpper() + ",";
        }
        sqlsc = sqlsc.Substring(0, sqlsc.Length - 1) + ")";
        //sqlsc += "\nPRIMARY KEY (ID))";
        strFieldsOnly = strFieldsOnly.Substring(0, strFieldsOnly.Length - 1);
        // return sqlsc;
        return sqlsc + "#" + strFieldsOnly;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
       lblMsg.Text = "";
        int centreID = Util.GetInt(ddlCentre.SelectedItem.Value);
        if (centreID == 0)
        {
            lblMsg.Text = "Please Select the Centre.";
            return;
        }
        if (ddlDepartment.SelectedValue == "0")
        {
            lblMsg.Text = "Please Select The Department";
            return;
        }
        if (!fustockAdjustment.HasFile)
        {
            lblMsg.Text = "Please Select The File.";
            return;
        }
        //if (Path.GetExtension(fustockAdjustment.FileName).ToUpper() != ".CSV")
        //{
        //    lblMsg.Text = "Please Convert To .csv File";
        //    return;

        //}
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            //Save the uploaded Excel file.
            if (!Directory.Exists(Server.MapPath("~/Design/EDP/TempFiles/")))
                Directory.CreateDirectory(Server.MapPath("~/Design/EDP/TempFiles/"));

            string FileName = Path.GetFileName(fustockAdjustment.FileName);
            string filePath = Server.MapPath("~/Design/EDP/TempFiles/" + FileName);
            if (File.Exists(filePath))
                File.Delete(filePath);
            fustockAdjustment.SaveAs(filePath);
            
           string TableName = "test.temp_Physical_Verification_" + Session["ID"].ToString();
           string sqlquerydata = string.Empty;

           StockReports.ExecuteDML("DROP TABLE IF EXISTS " + TableName + " ");
           StockReports.ExecuteDML("CREATE TABLE " + TableName + " LIKE temp_physical_verification; ");
           //StockReports.ExecuteDML("Truncate table " + TableName + "");
           //Open the Excel file using ClosedXML.
           using (XLWorkbook workBook = new XLWorkbook(filePath))
           {
               //Read the first Sheet from Excel file.
               IXLWorksheet workSheetBillDetail = workBook.Worksheet(1);
               sqlquerydata = BulkInsert(workSheetBillDetail, TableName);
               if (sqlquerydata.Length > 1)
                   MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sqlquerydata);
           }
           
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "File Upload Successfully";
            Errorfind(TableName);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text =  ex.Message;
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    private void Errorfind(string TableName) {
        StringBuilder sb = new StringBuilder();

        //sb.Append("Truncate Table error_stockadjustment; INSERT INTO error_stockadjustment (TypeName,ItemName,ItemID,Error) ");
        sb.Append("SELECT im.TypeName,i.ItemName,i.ItemID,'ItemID Not Exist'Error FROM " + TableName + " i ");
        sb.Append("LEFT JOIN f_itemmaster im ON im.ItemID=i.ItemID ");
        sb.Append("WHERE im.ItemID IS NULL ");
        sb.Append("UNION ALL ");
        sb.Append("SELECT im.TypeName,i.ItemName,i.ItemID,'SubCategory and ItemID Not Match'Error FROM " + TableName + " i ");
        sb.Append("LEFT JOIN f_itemmaster im ON im.ItemID=i.ItemID AND im.SubCategoryID=i.SubCategoryID ");
        sb.Append("WHERE im.ItemID IS NULL ");
        sb.Append("UNION ALL ");
        sb.Append("SELECT im.TypeName,i.ItemName,i.ItemID,'Itemname Not Match'Error FROM " + TableName + " i ");
        sb.Append("LEFT JOIN f_itemmaster im ON im.ItemID=i.ItemID  ");
        sb.Append("WHERE im.TypeName<>i.ItemName ");
        //StockReports.ExecuteScalar(sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            gvError.DataSource = dt;
            gvError.DataBind();
            btnUploadData.Visible = false;
        }
        else
        {
            gvError.DataSource = null;
            gvError.DataBind();
            btnUploadData.Visible = true;
        }
    }
    private string ExportStock()
    {
      
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  ");
        //sb.Append("IF(TYPE='+','StockUpdate#LSHHI54','StockAdjustment#LSHHI53') TypeOfTnx, ");
        sb.Append(" sc.Name SubCategory,im.TypeName AS ItemName,st.BatchNumber BatchNumber,st.UnitPrice, ");
      //  sb.Append("st.MRP,(st.InitialCount-st.ReleasedCount)InitialCount,0 'PhysicalCount',DATE_FORMAT(st.MedExpiryDate,'%Y-%m-%d') MedExpiryDate,st.Rate,'' Narration,st.PurTaxPer,'Vat' PurTaxType,st.SaleTaxPer, ");

        sb.Append("st.MRP,(st.InitialCount-st.ReleasedCount)InitialCount,0 'PhysicalCount',DATE_FORMAT(st.MedExpiryDate,'%Y-%m-%d') MedExpiryDate,'' Narration, ");
        sb.Append("im.SubCategoryID,st.ItemID,st.StockID,st.UnitType,st.StoreLedgerNo,rm.DeptLedgerNo LedgerNo,st.DeptLedgerNo ");
        sb.Append("FROM f_stock st  ");
        sb.Append("INNER JOIN f_itemmaster im ON im.ItemID=st.ItemID ");
        sb.Append("INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = im.SubCategoryID ");
        sb.Append("INNER JOIN f_rolemaster rm ON rm.DeptLedgerNo=st.DeptLedgerNo ");
        sb.Append("WHERE IsPost=1  AND rm.DeptLedgerNo = '"+ ddlDepartment.SelectedValue +"' AND st.CentreID = "+ ddlCentre.SelectedValue +"  AND st.StoreLedgerNo ='"+ ddlStoreType.SelectedValue +"'  AND st.InitialCount>=st.ReleasedCount  GROUP BY st.StockID  ");
        DataTable dt_temp = StockReports.GetDataTable(sb.ToString());
        if (dt_temp.Rows.Count > 0)
        {
            string ReportName = Session["LoginType"].ToString();
            using (DataTable dt = dt_temp)
            {
                using (var wb = new XLWorkbook())
                {
                    // Add a DataTable as a worksheet
                    wb.Worksheets.Add(dt);
                    ReportName = ddlDepartment.SelectedItem.Text;
                    byte[] package = ((MemoryStream)GetStream(wb)).ToArray();
                    string attachment = "attachment; filename=" + ReportName + ".xlsx";
                    Response.ClearContent();
                    Response.AddHeader("content-disposition", attachment);
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.BinaryWrite(package);
                    Response.End();
                    return "1";
                }
            }
          
        }
        else
            return "0";
    }
    public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        MemoryStream fs = new MemoryStream();
        excelWorkbook.SaveAs(fs);
        fs.Position = 0;
        return fs;
    }
    protected void btnstockdownload_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        int centreID = Util.GetInt(ddlCentre.SelectedItem.Value);
        if (centreID == 0)
        {
            lblMsg.Text = "Please Select the Centre Clinique Darne";
            return;
        }
        string type = ExportStock();
        if (type == "1")
        {
            lblMsg.Text = "Stock File Downloaded SuccessFully.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key", "modelAlert('Stock File Downloaded SuccessFully.');window.location.reload(1);", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key", "modelAlert('No Record Found.');window.location.reload(1);", true);
        }
        
    }
    protected void btnUploadData_Click(object sender, EventArgs e)
    {
        string TableName = "test.temp_Physical_Verification_" + Session["ID"].ToString();
        DataTable dt = StockReports.GetDataTable("SELECT * FROM " + TableName + " ");
        string HospId = Session["HOSPID"].ToString();
        string UserID = Session["ID"].ToString();
        string DeptLedgerNo = ddlDepartment.SelectedValue;
        if (string.IsNullOrEmpty(DeptLedgerNo)) {
            lblMsg.Text = "Please Select Department";
            return;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);
        decimal ad = 0;
        decimal pr = 0;
        decimal cc = 0;
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (Util.GetDecimal(dt.Rows[i]["PhysicalCount"].ToString()) != 0)
            {
                if (Util.GetDecimal(dt.Rows[i]["PhysicalCount"].ToString()) > 0)
                {
                    decimal aa = Util.GetDecimal(dt.Rows[i]["Rate"].ToString()) * Util.GetDecimal(dt.Rows[i]["PhysicalCount"].ToString());
                    ad = ad + (aa + ((aa * Util.GetDecimal(dt.Rows[i]["PurTaxPer"].ToString())) / 100));
                }
                if (Util.GetDecimal(dt.Rows[i]["PhysicalCount"].ToString()) < 0)
                {
                    decimal aa = Util.GetDecimal(dt.Rows[i]["Rate"].ToString()) * Util.GetDecimal(dt.Rows[i]["PhysicalCount"].ToString());
                    pr = pr + (aa + ((aa * Util.GetDecimal(dt.Rows[i]["PurTaxPer"].ToString())) / 100));
                }
            }
        }
        ad = Util.round(ad);
        pr = Util.round(pr);
        string Query = "";
        try
        {
            int EntryNo = Util.GetInt(StockReports.ExecuteScalar("SELECT IFNULL(MAX(EntryNo),0)+1 EntryNo FROM Physical_Verification"));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (Util.GetDecimal(dt.Rows[i]["PhysicalCount"].ToString()) != 0)
                {
                    decimal Initialcount = 0;
                    string TransType = string.Empty;
                    string Type = string.Empty;
                    if (Util.GetDecimal(dt.Rows[i]["PhysicalCount"].ToString()) > 0)
                    {
                        TransType = "StockUpdate";
                        Type = "+";
                        Initialcount = Util.GetDecimal(dt.Rows[i]["PhysicalCount"].ToString());
                        cc = ad;
                    }
                    else if (Util.GetDecimal(dt.Rows[i]["PhysicalCount"].ToString()) < 0)
                    {
                        TransType = "StockAdjustment";
                        Type = "-";
                        Initialcount = Util.GetDecimal(dt.Rows[i]["PhysicalCount"].ToString());
                        cc = pr;
                    }
                    if (Type != string.Empty)
                    {
                        Query = "";
                        Query = "INSERT INTO Physical_Verification(EntryNo,LedgerNo,DeptLedgerNo,HospitalID,DATE,TIME,TypeOfTnx,NetAmount,GrossAmount,ItemID,ItemName,BatchNumber, " +
                                "MRP,InitialCount,StoreLedgerNo,MedExpiryDate,SubCategoryID,Rate,PurTaxPer,PurTaxType,SaleTaxPer,TYPE,EntryBy,Narration,StockID,UnitType,CentreID,UnitPrice)";
                        Query += "VALUES('" + EntryNo + "','" + DeptLedgerNo + "','" + DeptLedgerNo + "','" + HospId + "',NOW(),NOW(),'" + TransType + "'," + cc + "," + cc + ", " +
                                 "'" + dt.Rows[i]["ItemID"].ToString() + "','" + dt.Rows[i]["ItemName"].ToString() + "','" + Util.GetString(dt.Rows[i]["BatchNumber"].ToString()) + "'," + Util.GetDecimal(dt.Rows[i]["MRP"].ToString()) + ",ABS(" + Initialcount + "), " +
                                 "'" + dt.Rows[i]["StoreLedgerNo"].ToString() + "','" + Util.GetDateTime(dt.Rows[i]["MedExpiryDate"]).ToString("yyyy-MM-dd") + "', " +
                                   "'" + dt.Rows[i]["SubCategoryID"].ToString() + "'," + Util.GetDecimal(dt.Rows[i]["UnitPrice"].ToString()) + "," + Util.GetDecimal("0.000000") + ", " +
                                   "'" + "vat" + "'," + Util.GetDecimal("0.000000") + ",'" + Util.GetString(Type) + "', " +

                                 "'" + Session["ID"].ToString() + "','" + Util.GetString(dt.Rows[i]["Narration"].ToString()) + "','" + Util.GetInt(dt.Rows[i]["StockID"].ToString()) + "', " +
                                 "'" + Util.GetString(dt.Rows[i]["UnitType"].ToString()) + "','" + ddlCentre.SelectedValue + "'," + Util.GetDecimal(dt.Rows[i]["UnitPrice"].ToString()) + ")";
                        MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, Query);
                    }
                }
            }
            objTran.Commit();
            lblMsg.Text = "Record Saved Successfully";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            objTran.Rollback();
            lblMsg.Text = "Error occurred, Please contact administrator";
        }
        finally
        {
            objTran.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}