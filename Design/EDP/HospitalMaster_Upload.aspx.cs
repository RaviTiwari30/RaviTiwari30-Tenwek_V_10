using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_EDP_HospitalMaster_Upload : System.Web.UI.Page
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
        DataTable dtMaster = StockReports.GetDataTable("SELECT ID,ExcelType,ExcelUrl,IsUploaded FROM HospitalMaster_ExcelType WHERE isactive=1 order by sequence");
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
        int CountItem = 0;
        lblMsg.Text = "";
        if (e.CommandName.ToString() == "AView")
        {
            string FilePath = "";
            GridViewRow row = (GridViewRow)(((Control)e.CommandSource).NamingContainer);
            CheckBox chkIsSample = row.FindControl("chkWithData") as CheckBox;
            FilePath = e.CommandArgument.ToString().Split('$')[0];
            if (File.Exists(FilePath))
            {
                FileInfo Filea = new FileInfo(FilePath);
                string FileName = Filea.Name;
                if (Filea.Extension == ".csv")
                {
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                    // Add the file size into the response header
                    Response.AddHeader("Content-Length", Filea.Length.ToString());

                    // Set the ContentType
                    Response.ContentType = "application/vnd.csv";

                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                    Response.TransmitFile(Filea.FullName);

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
                lblMsg.Text = "No File Is Exists";
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
                if (ExcelType.ToUpper() == "LABORATORY MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_laboratory_master";
                        string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        }
                        string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
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

                        DataTable dtObservationType = StockReports.GetDataTable("SELECT SubGroup FROM " + TableName + " GROUP BY SubGroup");
                        if (dtObservationType.Rows.Count > 0)
                        {
                            for (int m = 0; m < dtObservationType.Rows.Count; m++)
                            {
                                string observationtypeID = StockReports.ExecuteScalar("SELECT ObservationType_ID FROM observationtype_master WHERE NAME ='" + dtObservationType.Rows[m]["SubGroup"].ToString() + "'  ");
                                if (observationtypeID == "")
                                {
                                    ObservationType_Master objObservationType_Master = new ObservationType_Master(Tranx);
                                    objObservationType_Master.Creator_ID = ViewState["UserID"].ToString();
                                    objObservationType_Master.Name = dtObservationType.Rows[m]["SubGroup"].ToString();
                                    objObservationType_Master.Description = dtObservationType.Rows[m]["SubGroup"].ToString();
                                    objObservationType_Master.DeptEmailID = "";
                                    objObservationType_Master.Flag = 1;

                                    observationtypeID = objObservationType_Master.Insert();
                                    if (observationtypeID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                }
                                 string SubCategoryID = StockReports.ExecuteScalar("Select SubcategoryID From f_subcategorymaster Where Name ='" + dtObservationType.Rows[m]["SubGroup"].ToString() + "' ");
                                 if (SubCategoryID == "")
                                 {
                                     SubCategoryID = CreateStockMaster.SaveSubCategoryDetails(dtObservationType.Rows[m]["SubGroup"].ToString(), dtObservationType.Rows[m]["SubGroup"].ToString(), "3", Tranx);
                                     if (SubCategoryID == "")
                                     {
                                         Tranx.Rollback();
                                         return;
                                     }
                                     //update SubcategoryID to observationtype_master
                                     MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update observationtype_master set Description='" + SubCategoryID + "',DeptDescription='" + dtObservationType.Rows[m]["SubGroup"].ToString() + "' where observationtype_ID='" + observationtypeID + "'");
                                     MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set ObservationTypeID='" + observationtypeID + "',SubCategoryID='" + SubCategoryID + "' where SubGroup='" + dtObservationType.Rows[m]["SubGroup"].ToString() + "'");
                                 }
                            }
                        }
                        DataTable dtInvestigationTemp = StockReports.GetDataTable("SELECT * FROM " + TableName + " where Investigation_Name<>''");
                        if (dtInvestigationTemp.Rows.Count > 0)
                        {
                            for (int n = 0; n < dtInvestigationTemp.Rows.Count; n++)
                            {
                                 int InvCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select count(*) from investigation_master where name='" + dtInvestigationTemp.Rows[n]["Investigation_Name"].ToString() + "'").ToString());
                                 if (InvCount > 0)
                                 {

                                 }
                                 else
                                 {
                                     string ReportType = "1";
                                     MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
                                     string InvestigationID = ObjMapInvObs.SaveNewInvestigation(dtInvestigationTemp.Rows[n]["Investigation_Name"].ToString(), dtInvestigationTemp.Rows[n]["Investigation_Name"].ToString(), dtInvestigationTemp.Rows[n]["ObservationTypeID"].ToString(), dtInvestigationTemp.Rows[n]["SubGroup"].ToString(), ReportType, dtInvestigationTemp.Rows[n]["Sample_Required"].ToString(), dtInvestigationTemp.Rows[n]["Print_Sequence"].ToString(), dtInvestigationTemp.Rows[n]["Gender"].ToString(), "", dtInvestigationTemp.Rows[n]["Sample_Name"].ToString(), dtInvestigationTemp.Rows[n]["Investigation_Code"].ToString(), "0", 1, 0, 1, 1, 0, 1, 0, 1, "0", "0", "");
                                     // MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE investigation_master im SET im.IsOutSource=" + dtInvestigationTemp.Rows[n]["IsOutSource"].ToString() + ",im.OutSourceLabID=" + dtInvestigationTemp.Rows[n]["OUTSOURCEDLABNAME"].ToString() + " WHERE im.Investigation_Id='" + InvestigationID + "'");
                                     //if (InvestigationID == "" || InvestigationID == "0")
                                     //{
                                     //    lblMsg.Text = "Error.....";
                                     //    //Tranx.Rollback();
                                     //   // return;
                                     //}
                                 }
                            }
                        }
                    }
                }
                if (ExcelType.ToUpper() == "RADIOLOGY MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_radiology_master";
                        string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        }
                        string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
                        ((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        string strQuery = CreateTable(TableName, Mypath);
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        Mypath = Mypath.Replace(@"\", @"\\");

                        strQuery = "";
                        string ENCLOSEDBY = @"'""'";
                        string ESCAPEDBY = @"'""'";
                        strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                        DataTable dtObservationType = StockReports.GetDataTable("SELECT SubGroup FROM " + TableName + " GROUP BY SubGroup");
                        if (dtObservationType.Rows.Count > 0)
                        {
                            for (int m = 0; m < dtObservationType.Rows.Count; m++)
                            {
                                string observationtypeID = StockReports.ExecuteScalar("SELECT ObservationType_ID FROM observationtype_master WHERE NAME ='" + dtObservationType.Rows[m]["SubGroup"].ToString() + "'  ");
                                if (observationtypeID == "")
                                {
                                    ObservationType_Master objObservationType_Master = new ObservationType_Master(Tranx);
                                    objObservationType_Master.Creator_ID = ViewState["UserID"].ToString();
                                    objObservationType_Master.Name = dtObservationType.Rows[m]["SubGroup"].ToString();
                                    objObservationType_Master.Description = dtObservationType.Rows[m]["SubGroup"].ToString();
                                    objObservationType_Master.DeptEmailID = "";
                                    objObservationType_Master.Flag = 1;

                                    observationtypeID = objObservationType_Master.Insert();
                                    if (observationtypeID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                }
                                string SubCategoryID = StockReports.ExecuteScalar("Select SubcategoryID From f_subcategorymaster Where Name ='" + dtObservationType.Rows[m]["SubGroup"].ToString() + "' ");
                                if (SubCategoryID == "")
                                {
                                    SubCategoryID = CreateStockMaster.SaveSubCategoryDetails(dtObservationType.Rows[m]["SubGroup"].ToString(), dtObservationType.Rows[m]["SubGroup"].ToString(), "7", Tranx);
                                    if (SubCategoryID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                }
                                //update SubcategoryID to observationtype_master
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update observationtype_master set Description='" + SubCategoryID + "',DeptDescription='" + dtObservationType.Rows[m]["SubGroup"].ToString() + "' where observationtype_ID='" + observationtypeID + "'");
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set ObservationTypeID='" + observationtypeID + "',SubCategoryID='" + SubCategoryID + "' where SubGroup='" + dtObservationType.Rows[m]["SubGroup"].ToString() + "'");
                            }
                        }
                        DataTable dtInvestigationTemp = StockReports.GetDataTable("SELECT * FROM " + TableName + " where Investigation_Name<>''");
                        if (dtInvestigationTemp.Rows.Count > 0)
                        {
                            for (int n = 0; n < dtInvestigationTemp.Rows.Count; n++)
                            {
                                int InvCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select count(*) from investigation_master where name='" + dtInvestigationTemp.Rows[n]["Investigation_Name"].ToString() + "'").ToString());
                                if (InvCount > 0)
                                {

                                }
                                else
                                {
                                    MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
                                    string InvestigationID = ObjMapInvObs.SaveNewInvestigation(dtInvestigationTemp.Rows[n]["Investigation_Name"].ToString(), dtInvestigationTemp.Rows[n]["Investigation_Name"].ToString(), dtInvestigationTemp.Rows[n]["ObservationTypeID"].ToString(), dtInvestigationTemp.Rows[n]["SubGroup"].ToString(), "5", dtInvestigationTemp.Rows[n]["Sample_Required"].ToString(), dtInvestigationTemp.Rows[n]["Print_Sequence"].ToString(), dtInvestigationTemp.Rows[n]["Gender"].ToString(), "", dtInvestigationTemp.Rows[n]["Sample_Name"].ToString(), dtInvestigationTemp.Rows[n]["Investigation_Code"].ToString(), "0", 0, 0, 1, 1, 1, 0, 0, 1, "0","0","");
                                    //if (InvestigationID == "0") {
                                    //}
                                    //if (InvestigationID == "" || InvestigationID=="0")
                                    //{
                                    //    lblMsg.Text = "Error.....";
                                    //    Tranx.Rollback();
                                    //    return;
                                    //}
                                }
                            }
                        }
                    }
                }

                if (ExcelType.ToUpper() == "MEDICAL STORE ITEM MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_medicalstore_master10";
                        string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        }
                        string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
                        ((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        string strQuery = CreateTable(TableName, Mypath);
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        Mypath = Mypath.Replace(@"\", @"\\");

                        strQuery = "";
                        string ENCLOSEDBY = @"'""'";
                        string ESCAPEDBY = @"'""'";
                        strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                        DataTable dtSubCategory = StockReports.GetDataTable("SELECT SubGroup FROM " + TableName + " GROUP BY SubGroup");
                        if (dtSubCategory.Rows.Count > 0)
                        {
                            string SubCategoryID = string.Empty;
                            for (int m = 0; m < dtSubCategory.Rows.Count; m++)
                            {
                                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(NAME) FROM f_subcategorymaster WHERE NAME='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "' AND CategoryID='LSHHI38' "));
                                if (count == 0)
                                {
                                    SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                                    objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    objSubCategoryMaster.CategoryID = "LSHHI38"; //"LSHHI38"; //LSHHI5
                                    objSubCategoryMaster.Name = dtSubCategory.Rows[m]["SubGroup"].ToString();
                                    objSubCategoryMaster.DisplayName = "MEDICINE & CONSUMABLES";
                                    objSubCategoryMaster.DisplayPriority = m + 1;
                                    objSubCategoryMaster.Abbreviation = "MED";
                                    objSubCategoryMaster.Active = 1;
                                    SubCategoryID = objSubCategoryMaster.Insert();
                                    if (SubCategoryID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set SubCategoryID='" + SubCategoryID + "' where SubGroup='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "'");
                                }
                                else
                                {
                                    SubCategoryID = StockReports.ExecuteScalar("SELECT  SubCategoryID FROM  f_subcategorymaster WHERE NAME='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "' AND CategoryID='LSHHI38' ");
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set SubCategoryID='" + SubCategoryID + "' where SubGroup='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "'");
                                }
                            }
                        }
                        DataTable dtManufacturer = StockReports.GetDataTable("SELECT Manufacturer FROM " + TableName + " GROUP BY Manufacturer");
                        if (dtManufacturer.Rows.Count > 0)
                        {
                            int ManufactureID = 0;
                            for (int m = 0; m < dtManufacturer.Rows.Count; m++)
                            {
                                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(NAME) FROM f_manufacture_master WHERE NAME='" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "' "));
                                if (count == 0)
                                {
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into f_manufacture_master(NAME,IsActive,UserID)values('" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "',1,'" + ViewState["UserID"].ToString() + "')");
                                    ManufactureID = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT MAX(ManufactureID) FROM f_manufacture_master"));
                                    //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Alter Table " + TableName + " add column Manufacturer_ID INT(11)");
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set Manufacturer_ID='" + ManufactureID + "' where Manufacturer='" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "'");
                                }
                                else
                                {
                                    ManufactureID = Util.GetInt(StockReports.ExecuteScalar("SELECT ManufactureID FROM f_manufacture_master WHERE NAME='" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "' "));
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set Manufacturer_ID='" + ManufactureID + "' where Manufacturer='" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "'");
                                }
                            }
                        }

                        DataTable dtMedicalStoreItems = StockReports.GetDataTable("SELECT * FROM " + TableName + " where ItemName<>''");
                        if (dtMedicalStoreItems.Rows.Count > 0)
                        {
                            for (int n = 0; n < dtMedicalStoreItems.Rows.Count; n++)
                            {
                                if (dtMedicalStoreItems.Rows[n]["ItemName"].ToString().Trim() != "")
                                {
                                    string ItemIDcount = StockReports.ExecuteScalar("SELECT ItemID FROM f_itemmaster im WHERE im.TypeName='" + dtMedicalStoreItems.Rows[n]["ItemName"].ToString().Trim() + "' AND im.SubCategoryID ='" + dtMedicalStoreItems.Rows[n]["SubCategoryID"].ToString() + "' ");
                                    if (ItemIDcount == "")
                                    {
                                        ItemMaster objIMaster = new ItemMaster(Tranx);
                                        objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                        objIMaster.Type_ID = 0;
                                        objIMaster.TypeName = dtMedicalStoreItems.Rows[n]["ItemName"].ToString().Trim();
                                        objIMaster.Description = dtMedicalStoreItems.Rows[n]["ItemName"].ToString().Trim();
                                        objIMaster.SubCategoryID = dtMedicalStoreItems.Rows[n]["SubCategoryID"].ToString();
                                        objIMaster.IsEffectingInventory = "YES";
                                        objIMaster.IsExpirable = dtMedicalStoreItems.Rows[n]["Expirable"].ToString().Trim();
                                        objIMaster.BillingUnit = "";
                                        objIMaster.Pulse = "";
                                        objIMaster.IsTrigger = "NO";
                                        objIMaster.StartTime = Util.GetDateTime(System.DateTime.Now);
                                        objIMaster.EndTime = Util.GetDateTime(System.DateTime.Now);
                                        objIMaster.BufferTime = "00:00";
                                        objIMaster.IsActive = 3;
                                        objIMaster.QtyInHand = 0;
                                        objIMaster.IsAuthorised = 0;
                                        objIMaster.ItemCatalog = "";
                                        objIMaster.Rack = "";
                                        objIMaster.Shelf = "";

                                        objIMaster.MaxLevel = Util.GetDouble(dtMedicalStoreItems.Rows[n]["MaxLevel"]);
                                        objIMaster.MinLevel = Util.GetDouble(dtMedicalStoreItems.Rows[n]["MinLevel"]);
                                        objIMaster.ReorderLevel = Util.GetDouble(dtMedicalStoreItems.Rows[n]["ReorderLevel"]);
                                        objIMaster.ReorderQty = Util.GetDouble(dtMedicalStoreItems.Rows[n]["ReorderQty"]);
                                        objIMaster.MaxReorderQty = Util.GetDouble(0);
                                        objIMaster.MinReorderQty = Util.GetDouble(0);

                                        objIMaster.Packing = "";
                                        objIMaster.ManufactureID = Util.GetInt(dtMedicalStoreItems.Rows[n]["Manufacturer_ID"]);
                                        objIMaster.ServiceItemId = 0;
                                        objIMaster.IsUsable = "NR";
                                        objIMaster.ToBeBilled = 1;
                                        objIMaster.UnitType = Util.GetString(dtMedicalStoreItems.Rows[n]["MinUnit"]);
                                        objIMaster.majorUnit = Util.GetString(dtMedicalStoreItems.Rows[n]["MaxUnit"]);
                                        objIMaster.minorUnit = Util.GetString(dtMedicalStoreItems.Rows[n]["MinUnit"]);
                                        objIMaster.converter = Util.GetDecimal(dtMedicalStoreItems.Rows[n]["ConversionFactor"]);
                                        objIMaster.serviceName = "";
                                        objIMaster.CreaterID = ViewState["UserID"].ToString(); ;
                                        objIMaster.PurchaseVat = Util.GetDecimal(dtMedicalStoreItems.Rows[n]["VatPercentage"].ToString().Replace("%", ""));
                                        objIMaster.VatType = dtMedicalStoreItems.Rows[n]["VatType"].ToString();
                                        objIMaster.ItemCode = dtMedicalStoreItems.Rows[n]["ItemCode"].ToString().Replace("A-", "");
                                        objIMaster.VatLine = dtMedicalStoreItems.Rows[n]["VatLine"].ToString();
                                        string ItemID = objIMaster.Insert().ToString();
                                        if (ItemID == "")
                                        {
                                            Tranx.Rollback();
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (ExcelType.ToUpper() == "GENERAL STORE ITEM MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_generalstore_master";
                        string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        }
                        string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
                        ((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        string strQuery = CreateTable(TableName, Mypath);
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        Mypath = Mypath.Replace(@"\", @"\\");

                        strQuery = "";
                        string ENCLOSEDBY = @"'""'";
                        string ESCAPEDBY = @"'""'";
                        strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                        DataTable dtSubCategory = StockReports.GetDataTable("SELECT SubGroup FROM " + TableName + " GROUP BY SubGroup");
                        if (dtSubCategory.Rows.Count > 0)
                        {

                            for (int m = 0; m < dtSubCategory.Rows.Count; m++)
                            {
                                string SubCategoryID = string.Empty;
                                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(NAME) FROM f_subcategorymaster WHERE NAME='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "' "));
                                if (count == 0)
                                {
                                    SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                                    objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    objSubCategoryMaster.CategoryID = "8";
                                    objSubCategoryMaster.Name = dtSubCategory.Rows[m]["SubGroup"].ToString();
                                    objSubCategoryMaster.DisplayName = "GENERAL ITEMS";
                                    objSubCategoryMaster.DisplayPriority = m + 1;
                                    objSubCategoryMaster.Abbreviation = "MED";
                                    objSubCategoryMaster.Active = 1;

                                    SubCategoryID = objSubCategoryMaster.Insert();
                                    if (SubCategoryID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set SubCategoryID='" + SubCategoryID + "' where SubGroup='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "'");
                                }
                                else
                                {
                                    SubCategoryID = StockReports.ExecuteScalar("SELECT  SubCategoryID FROM  f_subcategorymaster WHERE NAME='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "' ");
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set SubCategoryID='" + SubCategoryID + "' where SubGroup='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "'");
                                }
                            }
                        }
                        DataTable dtManufacturer = StockReports.GetDataTable("SELECT Manufacturer FROM " + TableName + " GROUP BY Manufacturer");
                        if (dtManufacturer.Rows.Count > 0)
                        {
                            for (int m = 0; m < dtManufacturer.Rows.Count; m++)
                            {
                                //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into f_manufacture_master(NAME,IsActive,UserID)values('" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "',1,'" + ViewState["UserID"].ToString() + "')");
                                //int ManufactureID = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT MAX(ManufactureID) FROM f_manufacture_master"));
                                //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set Manufacturer_ID='" + ManufactureID + "' where Manufacturer='" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "'");
                                int ManufactureID = 0;
                                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(NAME) FROM f_manufacture_master WHERE NAME='" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "' "));
                                if (count == 0)
                                {
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into f_manufacture_master(NAME,IsActive,UserID)values('" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "',1,'" + ViewState["UserID"].ToString() + "')");
                                    ManufactureID = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT MAX(ManufactureID) FROM f_manufacture_master"));
                                    //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Alter Table " + TableName + " add column Manufacturer_ID INT(11)");
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set Manufacturer_ID='" + ManufactureID + "' where Manufacturer='" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "'");
                                }
                                else
                                {
                                    ManufactureID = Util.GetInt(StockReports.ExecuteScalar("SELECT ManufactureID FROM f_manufacture_master WHERE NAME='" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "' "));
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set Manufacturer_ID='" + ManufactureID + "' where Manufacturer='" + dtManufacturer.Rows[m]["Manufacturer"].ToString() + "'");
                                }
                            }

                        }

                        DataTable dtGeneralStoreItems = StockReports.GetDataTable("SELECT * FROM " + TableName + " where ItemName<>''");
                        if (dtGeneralStoreItems.Rows.Count > 0)
                        {
                            for (int n = 0; n < dtGeneralStoreItems.Rows.Count; n++)
                            {
                                if (dtGeneralStoreItems.Rows[n]["ItemName"].ToString().Trim() != "")
                                {
                                    //bool abc = SaveItemDetailsModified(dtGeneralStoreItems.Rows[n]["SubCategoryID"].ToString(), "HS", dtMedicalStoreItems.Rows[n]["ItemName"].ToString(), "YES", dtMedicalStoreItems.Rows[n]["ItemDescription"].ToString(), dtMedicalStoreItems.Rows[n]["Expirable"].ToString(), "", "", "NO", "00:00:00", "00:00:00", "00:00:00", "1", "0", "0", "", "", Util.GetDouble(dtMedicalStoreItems.Rows[n]["MaxLevel"]), Util.GetDouble(dtMedicalStoreItems.Rows[n]["MinLevel"]), Util.GetDecimal(dtMedicalStoreItems.Rows[n]["ReorderLevel"]), Util.GetDecimal(dtMedicalStoreItems.Rows[n]["ReorderQty"]), Util.GetDouble(0), Util.GetDouble(0), "", ManufactureID, Tranx, "", "", "NR", 1, dtMedicalStoreItems.Rows[n]["MaxUnit"].ToString(), "", Util.GetDecimal(0), dtMedicalStoreItems.Rows[n]["ItemCode"].ToString(), "", 0, dtMedicalStoreItems.Rows[n]["MinUnit"].ToString(), Util.GetDecimal(dtMedicalStoreItems.Rows[n]["ConversionFactor"]));
                                    ItemMaster objIMaster = new ItemMaster(Tranx);
                                    objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    objIMaster.Type_ID = 0;
                                    objIMaster.TypeName = dtGeneralStoreItems.Rows[n]["ItemName"].ToString().Trim();
                                    objIMaster.Description = dtGeneralStoreItems.Rows[n]["ItemName"].ToString().Trim();
                                    objIMaster.SubCategoryID = dtGeneralStoreItems.Rows[n]["SubCategoryID"].ToString();
                                    objIMaster.IsEffectingInventory = "YES";
                                    objIMaster.IsExpirable = dtGeneralStoreItems.Rows[n]["Expirable"].ToString().Trim();
                                    objIMaster.BillingUnit = "";
                                    objIMaster.Pulse = "";
                                    objIMaster.IsTrigger = "NO";
                                    objIMaster.StartTime = Util.GetDateTime(System.DateTime.Now);
                                    objIMaster.EndTime = Util.GetDateTime(System.DateTime.Now);
                                    objIMaster.BufferTime = "00:00";
                                    objIMaster.IsActive = 3;
                                    objIMaster.QtyInHand = 0;
                                    objIMaster.IsAuthorised = 0;
                                    objIMaster.ItemCatalog = "";
                                    objIMaster.Rack = "";
                                    objIMaster.Shelf = "";

                               //     objIMaster.MaxLevel = Util.GetDouble(dtGeneralStoreItems.Rows[n]["MaxLevel"]);
                               //     objIMaster.MinLevel = Util.GetDouble(dtGeneralStoreItems.Rows[n]["MinLevel"]);
                               //     objIMaster.ReorderLevel = Util.GetDouble(dtGeneralStoreItems.Rows[n]["ReorderLevel"]);
                             //       objIMaster.ReorderQty = Util.GetDouble(dtGeneralStoreItems.Rows[n]["ReorderQty"]);
                                    objIMaster.MaxReorderQty = Util.GetDouble(0);
                                    objIMaster.MinReorderQty = Util.GetDouble(0);

                                    objIMaster.Packing = "";
                                    objIMaster.ManufactureID = Util.GetInt(dtGeneralStoreItems.Rows[n]["Manufacturer_ID"]);
                                    objIMaster.ServiceItemId = 0;
                                    objIMaster.IsUsable = "NR";
                                    objIMaster.ToBeBilled = 1;
                                    objIMaster.UnitType = Util.GetString(dtGeneralStoreItems.Rows[n]["MinUnit"]);
                                    objIMaster.majorUnit = Util.GetString(dtGeneralStoreItems.Rows[n]["MaxUnit"]);
                                    objIMaster.minorUnit = Util.GetString(dtGeneralStoreItems.Rows[n]["MinUnit"]);
                                    objIMaster.converter = Util.GetDecimal(dtGeneralStoreItems.Rows[n]["ConversionFactor"]);
                                    objIMaster.serviceName = "";
                                    objIMaster.CreaterID = ViewState["UserID"].ToString();
                                    objIMaster.PurchaseVat = Util.GetDecimal(15);
                               //     objIMaster.VatType = Util.GetString(dtGeneralStoreItems.Rows[n]["VatType"]);
                                    objIMaster.IsAsset = 0;
                              //      objIMaster.VatLine = dtGeneralStoreItems.Rows[n]["VatLine"].ToString();
                                    objIMaster.ItemCode = dtGeneralStoreItems.Rows[n]["ItemCode"].ToString().Replace("A-", "").Trim();
                                   string ItemID= objIMaster.Insert().ToString();
                                    if (ItemID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                }
                            }
                        }
                    }
                }

                if (ExcelType.ToUpper() == "MAJOR SURGERY MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_majorsurgery_master";
                        //string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        //if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        //{
                        //    Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        //}
                        //string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
                        //((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);

                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        //string strQuery = CreateTable(TableName, Mypath);
                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        //Mypath = Mypath.Replace(@"\", @"\\");

                        //strQuery = "";
                        //string ENCLOSEDBY = @"'""'";
                        //string ESCAPEDBY = @"'""'";
                        //strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        string strQuery = "";

                        DataTable dtSubCategory = StockReports.GetDataTable("SELECT Department FROM " + TableName + " GROUP BY Department");
                        if (dtSubCategory.Rows.Count > 0)
                        {
                            for (int m = 0; m < dtSubCategory.Rows.Count; m++)
                            {
                                int tDetpeID = Util.GetInt(StockReports.ExecuteScalar("SELECT DeptID FROM Surdept_master s WHERE s.Name ='" + dtSubCategory.Rows[m]["Department"].ToString() + "' LIMIT 1"));
                                if (tDetpeID > 0) {
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set DeptID='" + tDetpeID + "' where Department='" + dtSubCategory.Rows[m]["Department"].ToString() + "'");
                                }
                                else
                                {
                                    strQuery = "";
                                    strQuery = "Insert into Surdept_master(Name,IsActive)values('" + dtSubCategory.Rows[m]["Department"].ToString() + "',1)";
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                                    int DeptID = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select Max(DeptID) from Surdept_master"));
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update " + TableName + " set DeptID='" + DeptID + "' where Department='" + dtSubCategory.Rows[m]["Department"].ToString() + "'");
                                }
                            }
                        }
                        DataTable dtSurgery = StockReports.GetDataTable("SELECT SurgeryName,DeptID,SurgeryCode,SOC FROM " + TableName + " where SurgeryName<>''");
                        if (dtSurgery.Rows.Count > 0)
                        {
                            for (int n = 0; n < dtSurgery.Rows.Count; n++)
                            {
                               int IsExistSurgery = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_surgery_master sm WHERE sm.Name ='" + dtSurgery.Rows[n]["SurgeryName"].ToString().Trim() + "'"));
                               if (IsExistSurgery == 0)
                               {
                                   CountItem += CountItem;
                                   string SurgeryId = Surgery.SaveSurgeryMaster(dtSurgery.Rows[n]["SurgeryName"].ToString().Trim(), dtSurgery.Rows[n]["DeptID"].ToString(), dtSurgery.Rows[n]["SurgeryCode"].ToString(), Tranx, "EMP002", Util.GetInt(dtSurgery.Rows[n]["SOC"].ToString()));
                                   if (SurgeryId == "")
                                   {
                                       Tranx.Rollback();
                                       return;
                                   }
                               }
                               else
                               {
 
                               }
                            }
                        }
                    }
                }

                if (ExcelType.ToUpper() == "DOCTOR MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_doctor_master";
                        string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        }
                        string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
                        ((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        string strQuery = CreateTable(TableName, Mypath);
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        Mypath = Mypath.Replace(@"\", @"\\");

                        strQuery = "";
                        string ENCLOSEDBY = @"'""'";
                        string ESCAPEDBY = @"'""'";
                        strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                        DataTable dtDept = StockReports.GetDataTable("SELECT Designation FROM " + TableName + " GROUP BY Designation");
                        if (dtDept.Rows.Count > 0)
                        {
                            for (int m = 0; m < dtDept.Rows.Count; m++)
                            {
                                int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from Type_master where Name ='" + dtDept.Rows[m]["Designation"].ToString() + "' AND typeID=5 "));
                                if (count == 0)
                                {
                                    strQuery = "";
                                    strQuery = "INSERT INTO type_master(typeID,NAME,TYPE)VALUES(5,'" + dtDept.Rows[m]["Designation"].ToString() + "','Doctor-Department')";
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                                }
                            }
                        }
                        DataTable dtSpecialization = StockReports.GetDataTable("SELECT Specialization FROM " + TableName + " GROUP BY Specialization");
                        if (dtSpecialization.Rows.Count > 0)
                        {
                            for (int m = 0; m < dtSpecialization.Rows.Count; m++)
                            {
                                int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from Type_master where Name ='" + dtSpecialization.Rows[m]["Specialization"].ToString() + "' AND typeID=3 "));
                                if (count == 0)
                                {
                                    strQuery = "";
                                    strQuery = "INSERT INTO type_master(typeID,NAME,TYPE)VALUES(3,'" + dtSpecialization.Rows[m]["Specialization"].ToString() + "','Doctor-Specialization')";
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                                }
                            }
                        }
                        DataTable dtDoctor = StockReports.GetDataTable("SELECT * FROM " + TableName + " where DoctorName<>''");
                        if (dtDoctor.Rows.Count > 0)
                        {
                            for (int n = 0; n < dtDoctor.Rows.Count; n++)
                            {
                                DoctorMaster objDoctorMaster = new DoctorMaster(Tranx);
                                objDoctorMaster.Title = dtDoctor.Rows[n]["Title"].ToString();
                                objDoctorMaster.Name = dtDoctor.Rows[n]["DoctorName"].ToString();
                                objDoctorMaster.Phone1 = dtDoctor.Rows[n]["PhoneNo"].ToString();
                                objDoctorMaster.Mobile = dtDoctor.Rows[n]["MobileNO"].ToString();
                                objDoctorMaster.Street_Name = dtDoctor.Rows[n]["StreetName"].ToString();
                                objDoctorMaster.Specialization = dtDoctor.Rows[n]["Specialization"].ToString();
                                objDoctorMaster.DoctorTime = "";
                                objDoctorMaster.Email = dtDoctor.Rows[n]["Email"].ToString();
                                objDoctorMaster.Designation = dtDoctor.Rows[n]["Designation"].ToString();
                                int DocType =1;
                                //if (dtDoctor.Rows[n]["DoctorType"].ToString().ToUpper() == "SPECIALIST")
                                //    DocType=2;
                                objDoctorMaster.DocGroupId = Util.GetString(DocType);
                                objDoctorMaster.DocDepartmentID = Util.GetString(StockReports.ExecuteScalar("Select ID from Type_master where Name='" + dtDoctor.Rows[n]["Designation"].ToString() + "' Limit 1 "));
                                objDoctorMaster.Degree = dtDoctor.Rows[n]["Degree"].ToString();
                             //   objDoctorMaster.IsDocShare = Util.GetInt(dtDoctor.Rows[n]["IsDoctorShare"].ToString());
                                objDoctorMaster.IMARegistartionNo = dtDoctor.Rows[n]["IMARegistration"].ToString();
                               
                                string DID = objDoctorMaster.Insert();
                                if (DID == "")
                                {
                                    Tranx.Rollback();
                                    return;
                                }
                                //if (dtDoctor.Rows[n]["IsDiscountApplicale"].ToString().ToUpper() == "YES")
                           //     int IsDiscountApplicale = Util.GetInt(dtDoctor.Rows[n]["IsDiscountApplicale"].ToString());
                                decimal RoomRent = 0;
                                //if (dtDoctor.Rows[n]["RoomRent"].ToString() != "")
                                  //  RoomRent = Util.GetDecimal(dtDoctor.Rows[n]["RoomRent"].ToString());
                           //     string strdocquery = "UPDATE doctor_master SET DoctorCode='" + dtDoctor.Rows[n]["DoctorCode"].ToString() + "',TANNO='" + dtDoctor.Rows[n]["TANNo"].ToString() + "' WHERE DoctorID='" + DID + "'";
                         //       MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strdocquery);
                                Ledger_Master objLedMas = new Ledger_Master(Tranx);
                                objLedMas.Hospital_ID = Convert.ToString(Session["HOSPID"]);
                                objLedMas.GroupID = "DOC";
                                objLedMas.LegderName = dtDoctor.Rows[n]["DoctorName"].ToString();
                                objLedMas.LedgerUserID = Util.GetString(DID);
                                objLedMas.OpeningBalance = Util.GetDecimal("0");
                                objLedMas.Insert().ToString();

                                // ============== SAVING INTO Item-Master  ====================
                                StringBuilder sb = new StringBuilder();
                                sb.Append(" SELECT t.Company_Name,t.PanelID,t.ReferenceCode,t.ReferenceCodeOPD,rs.ScheduleChargeID   FROM ");
                                sb.Append(" (SELECT RTRIM(LTRIM(Company_Name)) AS Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD  ");
                                sb.Append(" FROM f_panel_master WHERE PanelID IN ( ");
                                sb.Append(" SELECT DISTINCT(ReferenceCodeOPD) FROM f_panel_master) ");
                                sb.Append(" )t  INNER JOIN f_rate_schedulecharges rs ON rs.panelid =t.PanelID WHERE rs.IsDefault=1 ");
                                sb.Append("  ORDER BY t.Company_Name ");

                                DataTable dtPanel = StockReports.GetDataTable(sb.ToString());

                                DataTable dtSubCategoryID = CreateStockMaster.LoadSubCategoryByCategory(CreateStockMaster.LoadCategoryByConfigID("5"));

                                //Inserting rates for opd first
                                //shatrughan 18.04.13
                               string strdocrate = "select * from DocgroupRate where Type='OPD' ";

                              DataTable dtdocgrouprate = StockReports.GetDataTable(strdocrate);

                                //
                              bool Save = CreateStockMaster.SaveItemDetails(dtSubCategoryID, DID, dtDoctor.Rows[n]["DoctorName"].ToString(), "NO", "", "NO", "", "", "YES", "", "", "", "", "0.0", "0", Tranx, dtdocgrouprate, dtPanel, "1", ViewState["UserID"].ToString(), "", 0, 0);
                              if (Save == false)
                              {
                                  Tranx.Rollback();
                                  return;
                              }
                                //Inserting rates for ipd first
                                
                              
                                //DataTable dtRoomType = StockReports.GetDataTable("SELECT DISTINCT(NAME)RoomName,IPDCaseType_ID FROM ipd_case_type_master WHERE isactive=1 ");
                                //DataTable dtSubCategoryIDIPD = CreateStockMaster.LoadSubCategoryByCategory(CreateStockMaster.LoadCategoryByConfigID("1"));

                                //string strdocrateIPD = "select * from docgrouprate where Type='IPD' ";

                                //DataTable dtdocgrouprateIPD = StockReports.GetDataTable(strdocrateIPD);

                                //bool SaveIPD = CreateStockMaster.SaveItemDetailsIPD(dtSubCategoryIDIPD, DID, Util.GetString(dtDoctor.Rows[n]["DoctorName"].ToString()), "NO", "", "NO", "", "", "YES", "", "", "", "", "0.0", "0", Tranx, dtdocgrouprateIPD, dtPanel, "1", dtRoomType, ViewState["UserID"].ToString(), 0, 0);
                                //if (Save == false)
                                //{
                                //    Tranx.Rollback();
                                //    return;
                                //}
                            }
                        }
                    }
                }
                if (ExcelType.ToUpper() == "ROOM MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_room_master";
                        string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        }
                        string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
                        ((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        string strQuery = CreateTable(TableName, Mypath);
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        Mypath = Mypath.Replace(@"\", @"\\");

                        strQuery = "";
                        string ENCLOSEDBY = @"'""'";
                        string ESCAPEDBY = @"'""'";
                        strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                        DataTable dtRoomType = StockReports.GetDataTable("SELECT RoomType,CenterID FROM " + TableName + " GROUP BY RoomType");
                        if (dtRoomType.Rows.Count > 0)
                        {
                            for (int m = 0; m < dtRoomType.Rows.Count; m++)
                            {
                                strQuery = "";
                                ipd_case_type_master IPCM = new ipd_case_type_master(Tranx);
                                IPCM.Name = Util.ToTitleCase(dtRoomType.Rows[m]["RoomType"].ToString());
                                IPCM.Description = dtRoomType.Rows[m]["RoomType"].ToString();
                                IPCM.Ownership = "Public";
                                IPCM.Creator_Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                IPCM.No_Of_Round = Util.GetInt("0");
                                IPCM.Creator_Id = ViewState["UserID"].ToString();
                                IPCM.IsActive = 1;
                                IPCM.BillingCategoryID = "";
                                IPCM.CentreID = Util.GetInt(dtRoomType.Rows[m]["CenterID"].ToString());
                                string ipdCaseTypeID = IPCM.Insert();
                                if (ipdCaseTypeID == "")
                                {
                                    Tranx.Rollback();
                                    return;
                                }
                                string CatID = CreateStockMaster.LoadCategoryByConfigID("2").Rows[0]["CategoryID"].ToString();

                                SubCategoryMaster objSubCatMas = new SubCategoryMaster(Tranx);
                                objSubCatMas.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                objSubCatMas.Name = dtRoomType.Rows[m]["RoomType"].ToString();
                                objSubCatMas.Description = Util.GetString(ipdCaseTypeID);
                                objSubCatMas.DisplayName = "Room Charges";
                                objSubCatMas.CategoryID = Util.GetString(CatID);
                                objSubCatMas.Active = 1;
                                string SubCatID = objSubCatMas.Insert().ToString();
                                if (SubCatID == "")
                                {
                                    Tranx.Rollback();
                                    return;
                                }
                                ItemMaster objIMaster = new ItemMaster(Tranx);
                                objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                objIMaster.Type_ID = Util.GetInt( ipdCaseTypeID);
                                objIMaster.TypeName = dtRoomType.Rows[m]["RoomType"].ToString();
                                objIMaster.Description = dtRoomType.Rows[m]["RoomType"].ToString();
                                objIMaster.SubCategoryID = SubCatID;
                                objIMaster.IsEffectingInventory = "No";
                                objIMaster.IsExpirable = "";
                                objIMaster.BillingUnit = "";
                                objIMaster.Pulse = "";
                                objIMaster.IsTrigger = Util.GetString("YES");
                                objIMaster.StartTime = Util.GetDateTime("00:00:00");
                                objIMaster.EndTime = Util.GetDateTime("00:00:00");
                                objIMaster.BufferTime = Util.GetString("0");
                                objIMaster.IsActive = Util.GetInt("1");
                                objIMaster.QtyInHand = Util.GetDecimal("0");
                                objIMaster.IsAuthorised = Util.GetInt("1");
                                objIMaster.UnitType = "";
                                string ItemID = objIMaster.Insert().ToString();
                                if (ItemID == "")
                                {
                                    Tranx.Rollback();
                                    return;
                                }
                                //In Case of Nurshing Care Charges
                                DataTable dt = CreateStockMaster.LoadSubCategoryByConfigID("24"); //Nurshing Care
                                if (dt != null && dt.Rows.Count > 0)
                                {
                                    SubCatID = dt.Rows[0]["SubCategoryID"].ToString();
                                    CreateStockMaster.SaveItemDetails1(SubCatID, ipdCaseTypeID, dtRoomType.Rows[m]["RoomType"].ToString(), "NO", "", "NO", "", "", "YES", "00:00:00", "00:00:00", "0", "1", "0", "", "", 0, 0, Tranx);
                                }
                                //In Case of RMO Charges
                                dt = CreateStockMaster.LoadSubCategoryByConfigID("27");
                                if (dt != null && dt.Rows.Count > 0)
                                {
                                    SubCatID = dt.Rows[0]["SubCategoryID"].ToString();
                                    CreateStockMaster.SaveItemDetails1(SubCatID, ipdCaseTypeID, dtRoomType.Rows[m]["RoomType"].ToString(), "NO", "", "NO", "", "", "YES", "00:00:00", "00:00:00", "0", "1", "0", "", "", 0, 0, Tranx);
                                }
                            }
                        } 
                        DataTable dtRoom = StockReports.GetDataTable("SELECT * FROM " + TableName + " where RoomName<>''");
                        if (dtRoom.Rows.Count > 0)
                        {
                            for (int n = 0; n < dtRoom.Rows.Count; n++)
                            {
                                string RID = Session["ID"].ToString();
                                Room_Master objRoomMaster = new Room_Master(Tranx);
                                objRoomMaster.Location = AllGlobalFunction.Location;
                                objRoomMaster.HospCode = AllGlobalFunction.HospCode;
                                objRoomMaster.Name = Util.ToTitleCase(dtRoom.Rows[n]["RoomName"].ToString());
                                objRoomMaster.Floor = Util.ToTitleCase(dtRoom.Rows[n]["Floor"].ToString());
                                objRoomMaster.Room_No = dtRoom.Rows[n]["RoomNo"].ToString();
                                objRoomMaster.IPDCaseType_ID = Util.GetString(StockReports.ExecuteScalar("Select IPDCaseTypeID from ipd_case_type_master where  name='" + dtRoom.Rows[n]["RoomType"].ToString() + "' and isActive=1"));
                                objRoomMaster.Bed_No = dtRoom.Rows[n]["BedNo"].ToString();
                                objRoomMaster.Description = dtRoom.Rows[n]["Description"].ToString();
                                objRoomMaster.Creator_Date = Util.GetDateTime(System.DateTime.Now.ToString("dd/MMM/yyyy"));
                                objRoomMaster.Creator_ID = RID.ToString();
                                objRoomMaster.IsActive = 1;
                                objRoomMaster.IsCountable = 1;
                                objRoomMaster.CentreID = Util.GetInt(dtRoom.Rows[n]["CenterID"].ToString());
                                objRoomMaster.Insert();
                            }
                        }
                    }
                }
                if (ExcelType.ToUpper() == "MINOR PROCEDURE MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_minorprocedure_master";
                        //string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        //if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        //{
                        //    Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        //}
                        //string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
                        //((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);

                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        //string strQuery = CreateTable(TableName, Mypath);
                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        //Mypath = Mypath.Replace(@"\", @"\\");

                        //strQuery = "";
                        //string ENCLOSEDBY = @"'""'";
                        //string ESCAPEDBY = @"'""'";
                        //strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        string strQuery = "";

                        string CategoryID = "46"; //Util.GetString(StockReports.ExecuteScalar("SELECT CategoryID FROM f_configrelation WHERE ConfigID=25 "));
                        if (CategoryID == "")
                        {
                            CategoryMaster objCategoryMaster = new CategoryMaster(Tranx);
                            objCategoryMaster.Name = "Minor Procedure";
                            objCategoryMaster.Active = 1;
                            objCategoryMaster.Abbreviation = "Minor";
                            objCategoryMaster.UserID = "";
                            CategoryID = objCategoryMaster.Insert();
                            if (CategoryID == "")
                            {
                                Tranx.Rollback();
                                return;
                            }
                            Insert_ConfigRelation objconfigRelation = new Insert_ConfigRelation(Tranx);
                            objconfigRelation.ConfigID = Util.GetInt(25);
                            objconfigRelation.CategoryID = CategoryID;
                            objconfigRelation.Name = "Minor Procedure";
                            objconfigRelation.Insert();
                        }

                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Alter table " + TableName + " add column SubCategoryID varchar(20)");

                        DataTable dtSubCategory = StockReports.GetDataTable("SELECT SubGroup FROM " + TableName + " Where IFNULL(SubGroup,'')<>'' GROUP BY SubGroup");
                        if (dtSubCategory.Rows.Count > 0)
                        {
                            for (int m = 0; m < dtSubCategory.Rows.Count; m++)
                            {
                                string SubCategoryID = StockReports.ExecuteScalar("Select SubcategoryID From f_subcategorymaster Where CategoryID='" + CategoryID + "' AND Name ='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "' ");
                                 if (SubCategoryID == "")
                                 {
                                     SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                                     objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                     objSubCategoryMaster.CategoryID = CategoryID;
                                     objSubCategoryMaster.Name = dtSubCategory.Rows[m]["SubGroup"].ToString();
                                     objSubCategoryMaster.DisplayName = "Minor Procedure Charges";
                                     objSubCategoryMaster.DisplayPriority = 0;
                                     objSubCategoryMaster.Abbreviation = "";// dtSubCategory.Rows[m]["SubGroup"].ToString().PadLeft(4);
                                     objSubCategoryMaster.Active = 1;
                                     SubCategoryID = objSubCategoryMaster.Insert();
                                     if (SubCategoryID == "")
                                     {
                                         Tranx.Rollback();
                                         return;
                                     }
                                 }
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update " + TableName + " set SubCategoryID='" + SubCategoryID + "' where SubGroup='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "'");
                            }
                        }
                        DataTable dtMinorProcedure = StockReports.GetDataTable("SELECT * FROM " + TableName + " where ItemName<>''");
                        if (dtMinorProcedure.Rows.Count > 0)
                        {
                            for (int n = 0; n < dtMinorProcedure.Rows.Count; n++)
                            {
                                string ItemID = StockReports.ExecuteScalar("SELECT ItemID FROM f_itemmaster im WHERE im.TypeName='" + Util.GetString(dtMinorProcedure.Rows[n]["ItemName"]) + "' AND im.SubCategoryID ='" + Util.GetString(dtMinorProcedure.Rows[n]["SubCategoryID"]) + "' ");
                                if (ItemID == "")
                                {
                                    CountItem += 1;
                                    ItemMaster objIMaster = new ItemMaster(Tranx);
                                    objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    objIMaster.Type_ID = 0;
                                    objIMaster.TypeName = Util.GetString(dtMinorProcedure.Rows[n]["ItemName"]);
                                    objIMaster.Description = "";
                                    objIMaster.SubCategoryID = Util.GetString(dtMinorProcedure.Rows[n]["SubCategoryID"]);
                                    objIMaster.IsEffectingInventory = "NO";
                                    objIMaster.IsExpirable = "No";
                                    objIMaster.BillingUnit = "";
                                    objIMaster.Pulse = "";
                                    objIMaster.IsTrigger = "YES";
                                    objIMaster.StartTime = DateTime.Now;
                                    objIMaster.EndTime = DateTime.Now;
                                    objIMaster.BufferTime = "0";
                                    objIMaster.IsActive = 1;
                                    objIMaster.QtyInHand = 0;
                                    objIMaster.IsAuthorised = 1;
                                    objIMaster.ItemCode = HttpUtility.UrlDecode(Util.GetString(dtMinorProcedure.Rows[n]["ItemCode"]));
                                    objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
                                    objIMaster.IsDiscountable = Util.GetInt(1);
                                    objIMaster.RateEditable = Util.GetInt(0);
                                    ItemID = objIMaster.Insert().ToString();
                                    if (ItemID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                }
                                else
                                {
                                    
                                }
                            }
                        }
                    }
                }
                if (ExcelType.ToUpper() == "OTHER CHARGES MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_OtherCharges_master";
                        //string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        //if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        //{
                        //    Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        //}
                        //string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
                        //((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);

                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        //string strQuery = CreateTable(TableName, Mypath);
                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        //Mypath = Mypath.Replace(@"\", @"\\");

                        //strQuery = "";
                        //string ENCLOSEDBY = @"'""'";
                        //string ESCAPEDBY = @"'""'";
                        //strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                        string strQuery = "";

                        string CategoryID = Util.GetString(StockReports.ExecuteScalar("SELECT CategoryID FROM f_configrelation WHERE ConfigID=20 "));
                        if (CategoryID == "")
                        {
                            CategoryMaster objCategoryMaster = new CategoryMaster(Tranx);
                            objCategoryMaster.Name = "OTHER CHARGES";
                            objCategoryMaster.Active = 1;
                            objCategoryMaster.Abbreviation = "OTH";
                            objCategoryMaster.UserID = "";
                            CategoryID = objCategoryMaster.Insert();
                            if (CategoryID == "")
                            {
                                Tranx.Rollback();
                                return;
                            }
                            Insert_ConfigRelation objconfigRelation = new Insert_ConfigRelation(Tranx);
                            objconfigRelation.ConfigID = Util.GetInt(20);
                            objconfigRelation.CategoryID = CategoryID;
                            objconfigRelation.Name = "Other Charges";
                            objconfigRelation.Insert();
                        }

                       // MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Alter table " + TableName + " add column SubCategoryID varchar(50)");

                        DataTable dtSubCategory = StockReports.GetDataTable("SELECT SubGroup FROM " + TableName + " GROUP BY SubGroup");
                        if (dtSubCategory.Rows.Count > 0)
                        {
                            for (int m = 0; m < dtSubCategory.Rows.Count; m++)
                            {
                                string SubCategoryID = StockReports.ExecuteScalar("Select SubcategoryID From f_subcategorymaster Where CategoryID='" + CategoryID + "' AND Name ='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "' ");
                                if (SubCategoryID == "")
                                {
                                    SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                                    objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    objSubCategoryMaster.CategoryID = CategoryID;
                                    objSubCategoryMaster.Name = dtSubCategory.Rows[m]["SubGroup"].ToString();
                                    objSubCategoryMaster.DisplayName = "Other Charges";
                                    objSubCategoryMaster.DisplayPriority = 0;
                                    objSubCategoryMaster.Abbreviation = "";// dtSubCategory.Rows[m]["SubGroup"].ToString().Substring(0, 3);
                                    objSubCategoryMaster.Active = 1;

                                    SubCategoryID = objSubCategoryMaster.Insert();
                                    if (SubCategoryID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                }
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update " + TableName + " set SubCategoryID='" + SubCategoryID + "' where SubGroup='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "'");
                            }
                        }
                        DataTable dtOtherCharges = StockReports.GetDataTable("SELECT * FROM " + TableName + " where ItemName<>''");
                        if (dtOtherCharges.Rows.Count > 0)
                        {
                            for (int n = 0; n < dtOtherCharges.Rows.Count; n++)
                            {
                                string ItemID = StockReports.ExecuteScalar("SELECT ItemID FROM f_itemmaster im WHERE im.TypeName='" + Util.GetString(dtOtherCharges.Rows[n]["ItemName"]) + "' AND SubCategoryID='" + Util.GetString(dtOtherCharges.Rows[n]["SubCategoryID"]) + "' ");
                                if (ItemID == "")
                                {
                                    CountItem += 1;
                                    ItemMaster objIMaster = new ItemMaster(Tranx);
                                    objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    objIMaster.Type_ID = 0;
                                    objIMaster.TypeName = Util.GetString(dtOtherCharges.Rows[n]["ItemName"]);
                                    objIMaster.Description = Util.GetString(dtOtherCharges.Rows[n]["ItemName"]);
                                    objIMaster.SubCategoryID = Util.GetString(dtOtherCharges.Rows[n]["SubCategoryID"]);
                                    objIMaster.IsEffectingInventory = "NO";
                                    objIMaster.IsExpirable = "No";
                                    objIMaster.BillingUnit = "";
                                    objIMaster.Pulse = "";
                                    objIMaster.IsTrigger = "YES";
                                    objIMaster.StartTime = DateTime.Now;
                                    objIMaster.EndTime = DateTime.Now;
                                    objIMaster.BufferTime = "0";
                                    objIMaster.IsActive = 1;
                                    objIMaster.QtyInHand = 0;
                                    objIMaster.IsAuthorised = 1;
                                    objIMaster.ItemCode = Util.GetString(dtOtherCharges.Rows[n]["ItemCode"]);
                                    objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
                                    objIMaster.IsDiscountable = Util.GetInt(1);
                                    objIMaster.RateEditable = Util.GetInt(0);
                                    ItemID = objIMaster.Insert().ToString();
                                    if (ItemID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                }
                                else
                                {
 
                                }
                            }
                        }
                    }
                }
                if (ExcelType.ToUpper() == "IPD PACKAGE MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_IPDPackage_master";
                        string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        }
                        string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
                        ((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        string strQuery = CreateTable(TableName, Mypath);
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        Mypath = Mypath.Replace(@"\", @"\\");

                        strQuery = "";
                        string ENCLOSEDBY = @"'""'";
                        string ESCAPEDBY = @"'""'";
                        strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                        string CategoryID = Util.GetString(StockReports.ExecuteScalar("SELECT CategoryID FROM f_configrelation WHERE ConfigID=14 "));
                        if (CategoryID == "")
                        {
                            CategoryMaster objCategoryMaster = new CategoryMaster(Tranx);
                            objCategoryMaster.Name = "IPD PACKAGES";
                            objCategoryMaster.Active = 1;
                            objCategoryMaster.Abbreviation = "IPP";
                            objCategoryMaster.UserID = "";
                            CategoryID = objCategoryMaster.Insert();
                            if (CategoryID == "")
                            {
                                Tranx.Rollback();
                                return;
                            }
                            Insert_ConfigRelation objconfigRelation = new Insert_ConfigRelation(Tranx);
                            objconfigRelation.ConfigID = Util.GetInt(20);
                            objconfigRelation.CategoryID = CategoryID;
                            objconfigRelation.Name = "IPD PACKAGE";
                            objconfigRelation.Insert();
                        }

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Alter table " + TableName + " add column SubCategoryID varchar(50)");

                        DataTable dtSubCategory = StockReports.GetDataTable("SELECT SubGroup FROM " + TableName + " GROUP BY SubGroup");
                        if (dtSubCategory.Rows.Count > 0)
                        {
                            for (int m = 0; m < dtSubCategory.Rows.Count; m++)
                            {
                                string SubCategoryID = StockReports.ExecuteScalar("Select SubcategoryID From f_subcategorymaster Where CategoryID='" + CategoryID + "' AND Name ='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "' ");
                                if (SubCategoryID == "")
                                {
                                    SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                                    objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    objSubCategoryMaster.CategoryID = CategoryID;
                                    objSubCategoryMaster.Name = dtSubCategory.Rows[m]["SubGroup"].ToString();
                                    objSubCategoryMaster.DisplayName = "IPD PACKAGE";
                                    objSubCategoryMaster.DisplayPriority = 0;
                                    objSubCategoryMaster.Abbreviation = "";// dtSubCategory.Rows[m]["SubGroup"].ToString().Substring(0, 3);
                                    objSubCategoryMaster.Active = 1;

                                    SubCategoryID = objSubCategoryMaster.Insert();
                                    if (SubCategoryID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                }
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update " + TableName + " set SubCategoryID='" + SubCategoryID + "' where SubGroup='" + dtSubCategory.Rows[m]["SubGroup"].ToString() + "'");
                            }
                        }
                        DataTable dtIPDPackage = StockReports.GetDataTable("SELECT * FROM " + TableName + " where ItemName<>''");
                        if (dtIPDPackage.Rows.Count > 0)
                        {
                            for (int n = 0; n < dtIPDPackage.Rows.Count; n++)
                            {
                                string ItemID = StockReports.ExecuteScalar("SELECT ItemID FROM f_itemmaster im WHERE im.TypeName='" + Util.GetString(dtIPDPackage.Rows[n]["ItemName"]) + "' AND SubCategoryID='" + Util.GetString(dtIPDPackage.Rows[n]["SubCategoryID"]) + "' ");
                                if (ItemID == "")
                                {
                                    CountItem += 1;
                                    ItemMaster objIMaster = new ItemMaster(Tranx);
                                    objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    objIMaster.Type_ID = 0;
                                    objIMaster.TypeName = Util.GetString(dtIPDPackage.Rows[n]["ItemName"]);
                                    objIMaster.Description = Util.GetString(dtIPDPackage.Rows[n]["OLdItemid"]);
                                    objIMaster.SubCategoryID = Util.GetString(dtIPDPackage.Rows[n]["SubCategoryID"]);
                                    objIMaster.IsEffectingInventory = "NO";
                                    objIMaster.IsExpirable = "No";
                                    objIMaster.BillingUnit = "";
                                    objIMaster.Pulse = "";
                                    objIMaster.IsTrigger = "YES";
                                    objIMaster.StartTime = DateTime.Now;
                                    objIMaster.EndTime = DateTime.Now;
                                    objIMaster.BufferTime = "0";
                                    objIMaster.IsActive = 1;
                                    objIMaster.QtyInHand = 0;
                                    objIMaster.IsAuthorised = 1;
                                    objIMaster.ItemCode = Util.GetString(dtIPDPackage.Rows[n]["ItemCode"]);
                                    objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
                                    objIMaster.IsDiscountable = Util.GetInt(1);
                                    objIMaster.RateEditable = Util.GetInt(0);
                                    
                                    ItemID = objIMaster.Insert().ToString();
                                    if (ItemID == "")
                                    {
                                        Tranx.Rollback();
                                        return;
                                    }
                                }
                                else
                                {

                                }
                            }
                        }
                    }
                }
                if (ExcelType.ToUpper() == "SUPPLIER MASTER")
                {
                    if (((FileUpload)row.FindControl("ddlupload_doc")).HasFile)
                    {
                        TableName = "temp_Supplier_master";
                        //string FilePath = Server.MapPath(((FileUpload)row.FindControl("ddlupload_doc")).FileName);
                        //if (!Directory.Exists(Server.MapPath("~/Design/Documents/TempFiles/")))
                        //{
                        //    Directory.CreateDirectory(Server.MapPath("~/Design/Documents/TempFiles/"));
                        //}
                        //string Mypath = Server.MapPath("~/Design/Documents/TempFiles/") + TableName;
                        //((FileUpload)row.FindControl("ddlupload_doc")).SaveAs(Mypath);

                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                        //string strQuery = CreateTable(TableName, Mypath);
                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        //Mypath = Mypath.Replace(@"\", @"\\");

                        //strQuery = "";
                        //string ENCLOSEDBY = @"'""'";
                        //string ESCAPEDBY = @"'""'";
                        //strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE " + TableName + " FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
                        //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                    }
                    string strQuery = "";
                    DataTable dtSupplierMaster = StockReports.GetDataTable("SELECT * FROM " + TableName + " where VendorName<>''");
                    if (dtSupplierMaster.Rows.Count > 0)
                    {
                        for (int n = 0; n < dtSupplierMaster.Rows.Count; n++)
                        {
                            vendor objVendor = new vendor(Tranx);
                            objVendor.VendorName = Util.GetString(dtSupplierMaster.Rows[n]["VendorName"].ToString());
                            objVendor.VendorCode = Util.GetString(dtSupplierMaster.Rows[n]["VendorCode"].ToString());
                            objVendor.VendorType = Util.GetString(dtSupplierMaster.Rows[n]["VendorType"].ToString());
                            objVendor.VendorCategory = Util.GetString(dtSupplierMaster.Rows[n]["VendorCategory"].ToString());
                            objVendor.Bank = Util.GetString(dtSupplierMaster.Rows[n]["Bank"].ToString());
                            objVendor.AccountNo = Util.GetString(dtSupplierMaster.Rows[n]["AccountNo"].ToString());
                            objVendor.PaymentMode = Util.GetString(dtSupplierMaster.Rows[n]["PaymentMode"].ToString());
                        //    objVendor.ShipmentDetail = Util.GetString(dtSupplierMaster.Rows[n]["ShipmentDetail"].ToString());
                            objVendor.VATNo = Util.GetString(dtSupplierMaster.Rows[n]["VATNo"].ToString());
                            objVendor.Address1 = Util.GetString(dtSupplierMaster.Rows[n]["Address1"].ToString());
                        //    objVendor.Address2 = Util.GetString(dtSupplierMaster.Rows[n]["Address2"].ToString());
                        //    objVendor.Address3 = Util.GetString(dtSupplierMaster.Rows[n]["Address3"].ToString());
                            objVendor.ContactPerson = Util.GetString(dtSupplierMaster.Rows[n]["ContactPerson"].ToString());
                            objVendor.City = Util.GetString(dtSupplierMaster.Rows[n]["City"].ToString());
                            objVendor.Country = Util.GetString(dtSupplierMaster.Rows[n]["Country"].ToString());
                            objVendor.Pin = Util.GetString(dtSupplierMaster.Rows[n]["Pin"].ToString());
                            objVendor.Telephone = Util.GetString(dtSupplierMaster.Rows[n]["Telephone"].ToString());
                            objVendor.Email = Util.GetString(dtSupplierMaster.Rows[n]["Email"].ToString());
                            objVendor.Area = Util.GetString(dtSupplierMaster.Rows[n]["Area"].ToString());
                            objVendor.Fax = Util.GetString(dtSupplierMaster.Rows[n]["Fax"].ToString());
                            objVendor.Mobile = Util.GetString(dtSupplierMaster.Rows[n]["Mobile"].ToString());
                            objVendor.StoreID = "";
                           // objVendor.DrugLicence = Util.GetString(dtSupplierMaster.Rows[n]["DrugLicence"].ToString());
                            objVendor.CreditDays = Util.GetString(dtSupplierMaster.Rows[n]["CreditDays"].ToString());
                            //objVendor.TinNo = Util.GetString(dtSupplierMaster.Rows[n]["TinNo"].ToString());

                            string VendorID = objVendor.Insert();
                            if (VendorID != string.Empty)
                            {
                                Ledger_Master objLM = new Ledger_Master(Tranx);
                                objLM.GroupID = "VEN";
                                objLM.LegderName = Util.GetString(dtSupplierMaster.Rows[n]["VendorName"].ToString());
                                objLM.LedgerUserID = VendorID;
                                objLM.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                objLM.OpeningBalance = Util.GetDecimal(0);
                                objLM.ClosingBalance = Util.GetDecimal(0);
                                objLM.CurrentBalance = Util.GetDecimal(0);
                                string i = objLM.Insert().ToString();
                                if (i == "0")
                                {
                                    Tranx.Rollback();
                                    return;
                                }
                            }
                            else
                            {
                                Tranx.Rollback();
                                return;
                            }
                        }
                    }
                }
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update hospitalmaster_exceltype set IsUploaded=1 where ID=" + Util.GetInt(((Label)row.FindControl("lblID")).Text) + "");
                int totalitemupload = CountItem; ;
               // MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DROP TABLE IF EXISTS " + TableName + "");
                Tranx.Commit();
                lblMsg.Text = "Record Saved Successfully " + totalitemupload;
                BindMaster();
            }
            catch (Exception ex)
            {
                lblMsg.Text = ex.Message;
                Tranx.Rollback();
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