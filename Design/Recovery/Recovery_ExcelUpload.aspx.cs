using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Recovery_Recovery_ExcelUpload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            BindMaster();
        }
    }

    protected void BindMaster()
    {
        DataTable dtMaster = StockReports.GetDataTable("SELECT ID,ExcelType,ExcelUrl,IsUploaded FROM Recovery_ExcelType WHERE isactive=1 order by sequence");
        if (dtMaster.Rows.Count > 0)
        {
            grdDocDetails.DataSource = dtMaster;
            grdDocDetails.DataBind();
        }
        else
        {
            grdDocDetails.DataSource = null;
            grdDocDetails.DataBind();
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

    protected void ValidateData()
    {
        int HasFile = 0;
        foreach (GridViewRow row in grdDocDetails.Rows)
        {
            if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                HasFile = 1;
        }
        if (HasFile == 0)
        { lblMsg.Text = "No File Selected"; return; }
    }

    protected void grdDocDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        if (e.CommandName.ToString() == "AView")
        {
            string FilePath = "";
            GridViewRow row = (GridViewRow)(((Control)e.CommandSource).NamingContainer);
            CheckBox chkIsSample = row.FindControl("chkWithData") as CheckBox;
            FilePath = e.CommandArgument.ToString().Split('$')[0];

            FileInfo File = new FileInfo(FilePath);
            string FileName = File.Name;
            if (File.Exists)
            {
                if (File.Extension == ".csv")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", File.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "application/vnd.csv";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(File.FullName);

                    // End the response
                    Response.Flush();
                }
                else
                {
                    lblMsg.Text = "File Type Not Identified";
                }
            }
            else
            {
                lblMsg.Text = "File Not Exist";
            }
        }
        if (e.CommandName.ToString() == "aSave")
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            GridViewRow row = (GridViewRow)(((Control)e.CommandSource).NamingContainer);
            string TableName = "";
            try
            {
                ValidateData();

                string ExcelType = e.CommandArgument.ToString();
                ValidateData();

                if (ExcelType.ToUpper() == "SAVE REMARK IN PROCESS")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_recovery_action_detail";
                        string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        if (!Directory.Exists(Server.MapPath("~/Design/Recovery/TempFiles/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("~/Design/Recovery/TempFiles/"));
                        }
                        string Mypath = Server.MapPath("~/Design/Recovery/TempFiles/") + TableName;
                        ((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);
                        
                        string strQuery = "";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        strQuery = CreateTable(TableName, Mypath);
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        Mypath = Mypath.Replace(@"\", @"\\");

                        strQuery = "";
                        string ENCLOSEDBY = @"'""'";
                        string ESCAPEDBY = @"'""'";

                        strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                      
                    }
                }


               // MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update recovery_exceltype set IsUploaded=1 where ID=" + Util.GetInt(((Label)row.FindControl("lblID")).Text) + "");

               // MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                
            //SELECT STR_TO_DATE(EXPECTEDDATE,'%d-%m-%Y')ExpectedDate,STR_TO_DATE(TargetDate,'%c-%e-%Y %T')TargetDate FROM temp_recovery_action_detail
                string TPAInvNo = string.Empty; string BillNo = string.Empty;
                DataTable dtExcel=StockReports.GetDataTable("select * from temp_recovery_action_detail");
                if(dtExcel!=null && dtExcel.Rows.Count>0)
                {
                    for (int i = 0; i < dtExcel.Rows.Count; i++)
                    {
                        DataTable dtAdj = StockReports.GetDataTable("SELECT `TPAInvNo`,BillNo FROM `f_ipdadjustment` WHERE `TransactionID`='ISHHI" + dtExcel.Rows[i]["IPNo"].ToString() + "' AND `IsTPAInvActive`=1");
                        if (dtAdj != null && dtAdj.Rows.Count > 0)
                        {
                            TPAInvNo = dtAdj.Rows[0]["TPAInvNo"].ToString();
                            BillNo = dtAdj.Rows[0]["BillNo"].ToString();
                        }
                        string query = "insert into recovery_action_detail(TPAInvNo,TransactionID,BillNo,ProcessID,TargetDate,ExpectedDate,UserRemark,CreatedBy,CreatedDate) values('" + TPAInvNo + "','ISHHI" + dtExcel.Rows[i]["IPNo"].ToString() + "','" + BillNo + "','" + dtExcel.Rows[i]["ProcessID"].ToString() + "','" + Util.GetDateTime(dtExcel.Rows[i]["TargetDate"]).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(dtExcel.Rows[i]["ExpectedDate"]).ToString("yyyy-MM-dd") + "','" + dtExcel.Rows[i]["UserRemark"].ToString() + "','" + ViewState["UserID"].ToString() + "',now())";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text,query);

                        if (Util.GetInt(dtExcel.Rows[i]["IsClose"]) == 1)
                        {
                            query = "update tpa_process_close set IsClosed=1,ClosedBy='" + ViewState["UserID"].ToString() + "',ClosedDate=now() where TPAInvNo='" + dtExcel.Rows[i]["TPAInvNo"].ToString() + "' AND TransactionID='ISHHI" + dtExcel.Rows[i]["IPNo"].ToString() + "' AND ProcessID='" + dtExcel.Rows[i]["ProcessID"].ToString() + "'";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, query);
                        }
                    }
                }

                Tranx.Commit();
                lblMsg.Text = "Record Saved Successfully";
                BindMaster();
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                lblMsg.Text = ex.Message;           
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return;
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void grdDocDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblIsUploaded")).Text == "1")
            {
                ((Button)e.Row.FindControl("btnSave")).Enabled = false;
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            }
            else
            {
                ((Button)e.Row.FindControl("btnSave")).Enabled = true;
                e.Row.BackColor = System.Drawing.Color.Pink;
            }
        }
    }
}