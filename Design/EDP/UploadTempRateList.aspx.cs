using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.IO;

public partial class Design_EDP_UploadTempRateList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPanel();
            
        }
    }
    private void LoadPanel()
    {
        
        DataTable dt = CreateStockMaster.LoadPanelCompanyRefOPD();
        ddlPanel.DataSource = dt;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (f_ratelist.HasFile)
        {
            if (Path.GetExtension(f_ratelist.FileName).ToUpper() != ".CSV")
            {
                lblMsg.Text = "Please Upload .csv File";
                return;

            }
            string PanelId = ddlPanel.SelectedItem.Value;
            string PanelName = ddlPanel.SelectedItem.Text;

            string FileName = string.Empty;
            string Mypath = string.Empty;
            string TableName = string.Empty;
            string strQuery = string.Empty;
            string Query = string.Empty;
            if (!Directory.Exists(Server.MapPath("~/Design/EDP/TempFiles/")))
                Directory.CreateDirectory(Server.MapPath("~/Design/EDP/TempFiles/"));

            FileName = Path.GetFileName(f_ratelist.FileName);
            Mypath = Server.MapPath("~/Design/EDP/TempFiles/" + FileName);

            if (File.Exists(Mypath))
                File.Delete(Mypath);
            f_ratelist.SaveAs(Mypath);
            string file = File.ReadAllText(Mypath);
            if (file.Contains('"') || file.Contains("'") || file.Contains('#')||file.Contains(';'))
            {
                lblMsg.Text = "Uploaded file contains any special symbol like string symbol,semi-colon, hash symbol etc. Kindly Check...";
                return;
            }

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {


                    TableName = "tmp_ratelist_upload_"+ddlPanel.SelectedItem.Value+"_"+rblType.SelectedItem.Value;
                    //Delete OLd Table
                    StockReports.ExecuteDML("Drop Table if Exists " + TableName + " ");

                    //Create New Table
                    strQuery = CreateTable(TableName, Mypath);
                    if (strQuery.ToUpper().Contains("ITEMNAME") == false)
                    {
                        lblMsg.Text = "The File does not contain a Column 'ITEMNAME'. Kindly Check. ";
                        return;
                    }
                    if (strQuery.ToUpper().Contains("ITEMCODE") == false)
                    {
                        lblMsg.Text = "The File does not contain a Column 'ITEMCODE'. Kindly Check. ";
                        return;
                    }
                    StockReports.ExecuteDML(strQuery);
                    Query = "ALTER TABLE "+TableName+" ADD Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY";
                    StockReports.ExecuteDML(Query);
                    Query = "ALTER TABLE " + TableName + " ADD PanelID varchar(10)"; 
                    StockReports.ExecuteDML(Query);
                    Query = "ALTER TABLE " + TableName + " ADD itemid varchar(10)";
                    StockReports.ExecuteDML(Query);
                    Query = "ALTER TABLE " + TableName + " ADD ScheduleChargeID varchar(10)";
                    StockReports.ExecuteDML(Query);
                    Query = "ALTER TABLE " + TableName + " ADD is_Mapped INT(1) DEFAULT 0";
                    StockReports.ExecuteDML(Query);
                    
                    
                   
                    Mypath = Mypath.Replace(@"\", @"\\");

                    string ENCLOSEDBY = @"'""'";
                    string ESCAPEDBY = @"'""'";

                    strQuery = "LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES ";
                    StockReports.ExecuteDML(strQuery);
                    tnx.Commit();
                    Query = "update " + TableName + " set PanelID=" + PanelId;
                    StockReports.ExecuteDML(Query);
                    lblMsg.Text = "Record Saved Successfully";

                
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error...";
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            lblMsg.Text = "Please Select a File to Upload";
            return;
        }



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
        //sqlsc += "\n PanelId varchar(10),";
        for (int i = 0; i < Cols; i++)
        {
            sqlsc += "\n" + Fields[i].Trim().ToUpper();
            sqlsc += " varchar(200) ";
            sqlsc += ",";

            strFieldsOnly += Fields[i].Trim().ToUpper() + ",";
        }
        sqlsc = sqlsc.Substring(0, sqlsc.Length - 1) + ")DEFAULT CHARSET=latin1";
        //sqlsc += "\nPRIMARY KEY (ID))";
        strFieldsOnly = strFieldsOnly.Substring(0, strFieldsOnly.Length - 1);

        return sqlsc + "#" + strFieldsOnly;
    }
}