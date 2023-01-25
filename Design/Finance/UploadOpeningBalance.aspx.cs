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
using ClosedXML;
using ClosedXML.Excel;

public partial class Design_EDP_UploadOpeningBalance : System.Web.UI.Page
{
    string[] Fields;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            BindCentre();
            //if (Session["ID"].ToString() == "EMP001")
            //{
            //    btnPatientDetail.Visible = true;
            //    btnUploadData.Visible = true;
            //    btnUpdateFinance.Visible = true;
            //}
            //else
            //{
                btnCheckError.Visible = false;
                btnPatientDetail.Visible = false;
                btnUploadData.Visible = false;
                btnUpdateFinance.Visible = false;
            //}
        }
        lblMsg.Text = "";
    }
    private void visiblefalse()
    {
        btnSave.Visible = false;
        btnCheckError.Visible = false;
        btnPatientDetail.Visible = false;
        btnUploadData.Visible = false;
        btnUpdateFinance.Visible = false;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        int centreID = Util.GetInt(ddlCentre.SelectedItem.Value);
        if (centreID != 1)
        {
            lblMsg.Text = "Opening Balance will upload from Tenwek  Hospital";
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            //Truncate OLd Table
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "truncate Table _billdt ");
            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "truncate Table _panel ");
            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "truncate Table _docshare ");
            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "truncate Table _error ");

            //Save the uploaded Excel file.
            if (!Directory.Exists(Server.MapPath("~/Design/EDP/TempFiles/")))
                Directory.CreateDirectory(Server.MapPath("~/Design/EDP/TempFiles/"));

            string FileName = Path.GetFileName(fuOpeningBalance.FileName);
            string filePath = Server.MapPath("~/Design/EDP/TempFiles/" + FileName);
            if (File.Exists(filePath))
                File.Delete(filePath);
            fuOpeningBalance.SaveAs(filePath);

            string sqlquerydata = string.Empty;

            //Open the Excel file using ClosedXML.
            using (XLWorkbook workBook = new XLWorkbook(filePath))
            {
                //Read the first Sheet from Excel file.
                IXLWorksheet workSheetBillDetail = workBook.Worksheet(1);


                sqlquerydata = BulkInsert(workSheetBillDetail, "_billdt");
                if (sqlquerydata.Length > 1)
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sqlquerydata);
                /*IXLWorksheet workSheetPanelDetail = workBook.Worksheet(2);
                IXLWorksheet workSheetDocDetail = workBook.Worksheet(3);


                sqlquerydata= BulkInsert(workSheetPanelDetail, "_panel");
                if (sqlquerydata.Length > 1)
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sqlquerydata);

                sqlquerydata = BulkInsert(workSheetDocDetail, "_docshare");
                if (sqlquerydata.Length > 1)
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sqlquerydata);*/

            }
            tnx.Commit();
            lblMsg.Text = "Record Saved Successfully";
            btnCheckError.Visible = true;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            lblMsg.Text = ex.ToString();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
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

    private void BindCentre()
    {
        string str = "SELECT cm.CentreID,cm.CentreName FROM center_master cm WHERE cm.isActive=1 ";
        DataTable dtCentre = StockReports.GetDataTable(str);
        ddlCentre.DataSource = dtCentre;
        ddlCentre.DataTextField = "CentreName";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
        ddlCentre.Items.Insert(0, new ListItem("Select", "0"));
        ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue("1"));
        ddlCentre.Enabled = false;
    }

    protected void btnCheckError_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        int centreID = Util.GetInt(ddlCentre.SelectedItem.Value);
        if (centreID != 1)
        {
            lblMsg.Text = "Please Select the Centre Tenwek Hospital";
            return;
        }
        ExcuteCMD excuteCMD = new ExcuteCMD();
        excuteCMD.DML("call sp_Gen_OpeningBal_Error()", CommandType.Text, new { });
        //StockReports.ExecuteDML(" call sp_Gen_OpeningBal_Error() ");
        DataTable dt = StockReports.GetDataTable(" select * from _error ");

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " record(s) found.";
            gvError.DataSource = dt;
            gvError.DataBind();
        }
        else
        {
            gvError.DataSource = null;
            gvError.DataBind();
            lblMsg.Text = "No Error Found in the Sheet";
            btnPatientDetail.Visible = true;
        }
    }
    protected void btnUploadData_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        
        int isError = CheckError();

        if (isError == 1)
            return;

        int centreID = Util.GetInt(ddlCentre.SelectedItem.Value);
        if (centreID != 1)
        {
            lblMsg.Text = "Please Select the Centre Tenwek  Hospital";
            return;
        }
        ExcuteCMD excuteCMD = new ExcuteCMD();
        excuteCMD.DML("call sp_Gen_OpeningBal(" + centreID + ")", CommandType.Text, new { });
       // StockReports.ExecuteDML(" call sp_Gen_OpeningBal(" + centreID + ") ");
        btnCheckError.Visible = false;
        btnPatientDetail.Visible = false;
        btnUploadData.Visible = false;
        btnUpdateFinance.Visible = false;
        btnSave.Visible = true;
    }
   
    protected void btnPatientDetail_Click(object sender, EventArgs e)
    {
        
        int isError = CheckError();

        if (isError == 1)
            return;

        lblMsg.Text = "";
        int centreID = Util.GetInt(ddlCentre.SelectedItem.Value);
        if (centreID != 1)
        {
            lblMsg.Text = "Please Select the Centre Tenwek  Hospital";
            return;
        }
        ExcuteCMD excuteCMD = new ExcuteCMD();
        excuteCMD.DML("call sp_Gen_OpeningBal_Patient(" + centreID + ")", CommandType.Text, new { });
       // StockReports.ExecuteDML(" call sp_Gen_OpeningBal_Patient(" + centreID + ") ");


        string sql = " INSERT INTO _error(UHID,BillNo,Error) SELECT a.UHID,a.BillNo,'Problem in patient Data in Bill details' as Error FROM _billdt a LEFT JOIN patient_master pm ON a.`UHID`=pm.`PatientID` WHERE pm.`PatientID` IS NULL ";

        excuteCMD = new ExcuteCMD();
        excuteCMD.DML(sql, CommandType.Text, new { });
      //  StockReports.ExecuteDML(sql);

        DataTable dt = StockReports.GetDataTable("  select * from _error  ");


        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " record(s) found. ";
            gvError.DataSource = dt;
            gvError.DataBind();
        }
        else
        {
            gvError.DataSource = null;
            gvError.DataBind();
            lblMsg.Text = "All Patients Inserted successfully.";
            btnUploadData.Visible = true;
        }

    }

    public int CheckError()
    {

        string sql = "select * from _error";

        DataTable dt = StockReports.GetDataTable(sql);
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Please Remove following Errors First.. ";
            gvError.DataSource = dt;
            gvError.DataBind();
            return 1;
        }
        else
        {
            gvError.DataSource = null;
            gvError.DataBind();
            lblMsg.Text = "All Patients Inserted successfully.";
            return 0;
        }




    }
    protected void btnUpdateFinance_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";


        int isError = CheckError();

        if (isError == 1)
            return;

        int centreID = Util.GetInt(ddlCentre.SelectedItem.Value);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        excuteCMD.DML("call sp_Push_OpeningBal_ESS()", CommandType.Text, new { });
      //  StockReports.ExecuteDML(" call sp_Push_OpeningBal_ESS() ");

        string sql = " INSERT INTO _error(UHID,BillNo,Error)  SELECT adj.`PatientID`,adj.`BillNo`,'Patient Data is Not Transfer in Finance' AS Error FROM f_ipdadjustment adj WHERE adj.isopeningBalance=1";
        excuteCMD = new ExcuteCMD();
        excuteCMD.DML(sql, CommandType.Text, new { });
        //  StockReports.ExecuteDML(sql);

        DataTable dt = StockReports.GetDataTable("  select * from _error  ");

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " record(s) found. ";
            gvError.DataSource = dt;
            gvError.DataBind();
        }
        else
        {
            gvError.DataSource = null;
            gvError.DataBind();
            lblMsg.Text = "Finance Uploaded successfully.";
        }


    }
}
