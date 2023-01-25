using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Collections;
using System.Text;

public partial class Design_EDP_IPDPackage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategory();
            BindPackage();
            LoadPanel();
            LoadScheduleCharges();
            LoadItemMaster("");
            if (rbtNewEdit.SelectedValue == "1")
            {
                ddlPackage.Visible = false;
                txtPkg.Visible = true;
            }
            else
            {
                ddlPackage.Visible = true;
                txtPkg.Visible = false;
            }
            HideShowControls();
        }
    }

    public void BindServices()
    {
        DataTable dtItem = (DataTable)ViewState["ITEM"];
        grdItem.DataSource = dtItem;
        grdItem.DataBind();

        if (dtItem != null && dtItem.Rows.Count > 0)
        {
            butSave.Visible = true;
        }
        else
        {
            butSave.Visible = false;
        }
    }

    public DataTable getItemDT()
    {
        DataTable dtItem = new DataTable();
        if (ViewState["ITEM"] == null)
        {
            dtItem.Columns.Add("Category");
            dtItem.Columns.Add("CategoryID");
            dtItem.Columns.Add("Quantity");
            dtItem.Columns.Add("Amount");
            dtItem.Columns.Add("IsAmount");
            dtItem.Columns.Add("ConfigID");
            dtItem.Columns.Add("Detail_ItemID");
            dtItem.Columns.Add("Detail_ItemName");
            dtItem.Columns.Add("PackageType");
            dtItem.Columns.Add("PackageTypeID");
        }
        else
        {
            dtItem = (DataTable)ViewState["ITEM"];
        }

        return dtItem;
    }

    protected void btnAddInv_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (txtqty.Text.Trim() == "" && txtAmt.Text.Trim() == "")
        {
            lblMsg.Text = "Please Add Quantity or amount";
            txtqty.Text = "";
            txtAmt.Text = "";
            return;
        }
        if (ddlCategory.SelectedIndex != 0)
        {
            if (ddlCategory.SelectedItem.Value.Split('#')[1].ToString() == "22")
            {
                if (Util.GetInt(txtqty.Text.Trim()) > 1 && txtAmt.Text == "")
                {
                    lblMsg.Text = "Adding Multiple surgery not allowed";
                    txtqty.Text = "";
                    txtAmt.Text = "";
                    return;
                }
            }
        }
        if (rbtPackageType.SelectedValue == "1")
        {
            foreach (GridViewRow gr in grdItem.Rows)
            {
                string cat = ((Label)gr.FindControl("lblCategoryID")).Text;
                if (cat == ddlCategory.SelectedItem.Value.Split('#')[0].ToString())
                {
                    lblMsg.Text = "Category already added";
                    return;
                }
            }
        }
        if (rbtPackageType.SelectedValue == "2")
        {
            foreach (GridViewRow gr in grdItem.Rows)
            {
                string cat = ((Label)gr.FindControl("lblCategoryID")).Text;
                string PackageType = ((Label)gr.FindControl("lblPackageTypeID")).Text;
                if ((cat == ddlCategory.SelectedItem.Value.Split('#')[0].ToString()) && PackageType == "1")
                {
                    lblMsg.Text = "Category already added";
                    return;
                }
            }
        }
        DataTable dtItem = getItemDT();

        if (rbtPackageType.SelectedValue == "1")
        {
            DataRow dr = dtItem.NewRow();
            dr["CategoryID"] = ddlCategory.SelectedItem.Value.Split('#')[0].ToString();
            dr["Category"] = ddlCategory.SelectedItem.Text;
            dr["Quantity"] = Util.GetInt(txtqty.Text.Trim());
            dr["Amount"] = Util.GetDecimal(txtAmt.Text.Trim());
            dr["IsAmount"] = rdbflag.SelectedValue;
            dr["ConfigID"] = ddlCategory.SelectedItem.Value.Split('#')[1].ToString();
            dr["Detail_ItemID"] = "";
            dr["Detail_ItemName"] = "";
            dr["PackageType"] = rbtPackageType.SelectedItem.Text.ToString();
            dr["PackageTypeID"] = rbtPackageType.SelectedValue;
            dtItem.Rows.Add(dr);
        }
        else
        {
            string ItemIDs = string.Empty;
            foreach (ListItem li in chlItems.Items)
            {
                if (li.Selected)
                {
                    if (ItemIDs != string.Empty)
                        ItemIDs += "," + li.Value + "";
                    else
                        ItemIDs = "" + li.Value + "";
                }
            }
            string[] strs = ItemIDs.Split(',');
            ArrayList ItemIDsArray = new ArrayList();
            ItemIDsArray.AddRange(strs);

            for (int i = 0; i < ItemIDsArray.Count; i++)
            {
                int ItemIdExist = 0;
                foreach (GridViewRow gr in grdItem.Rows)
                {
                    string ItemID = ((Label)gr.FindControl("lblItemID")).Text;
                    if (ItemID == ItemIDsArray[i].ToString().Split('#')[0].ToString())
                    {
                        ItemIdExist = 1;
                    }
                }
                if (ItemIdExist == 0)
                {
                    string ItemName = "";
                    DataRow dr = dtItem.NewRow();
                    dr["CategoryID"] = ddlCategory.SelectedItem.Value.Split('#')[0].ToString();
                    dr["Category"] = ddlCategory.SelectedItem.Text;
                    dr["Quantity"] = Util.GetInt(txtqty.Text.Trim());
                    dr["Amount"] = Util.GetDecimal(txtAmt.Text.Trim());
                    dr["IsAmount"] = rdbflag.SelectedValue;
                    dr["ConfigID"] = ddlCategory.SelectedItem.Value.Split('#')[1].ToString();
                    dr["Detail_ItemID"] = ItemIDsArray[i].ToString();
                    if (ddlCategory.SelectedItem.Value.Split('#')[1].ToString() == "22")
                    {
                        ItemName = StockReports.ExecuteScalar("Select Name FROM f_surgery_master  where Surgery_ID='" + ItemIDsArray[i].ToString() + "'"); 
                    }
                    else
                        ItemName = StockReports.ExecuteScalar("Select Typename from F_itemmaster where ItemID='" + ItemIDsArray[i].ToString() + "'");
                    dr["Detail_ItemName"] = ItemName;
                    dr["PackageType"] = rbtPackageType.SelectedItem.Text.ToString();
                    dr["PackageTypeID"] = rbtPackageType.SelectedValue;
                    dtItem.Rows.Add(dr);
                }
            }
        }

        dtItem.AcceptChanges();
        ViewState["ITEM"] = dtItem;
        BindServices();
        txtqty.Text = "";
        txtAmt.Text = "";
        butSave.Visible = true;
    }

    protected void butSave_Click(object sender, EventArgs e)
    {
        //if (Util.GetInt(txtValidDays.Text) <= 0)
        //{
        //    lblMsg.Text = "Please Enter Validity Days";
        //    return;
        //}
        if (rbtNewEdit.SelectedValue == "1")
        {
            if (CheckDuplicate())
            {
                lblMsg.Text = "Package already Exist";
                return;
            }
        }
        if (ViewState["ITEM"] == null && grdItem.Rows.Count == 0)
        {
            lblMsg.Text = "Add Item";
            return;
        }
        if (rbtNewEdit.SelectedItem.Value == "1")
        {
            if (txtPkg.Text.Trim() == "")
            {
                lblMsg.Text = "Please Enter Package Name";
                txtPkg.Focus();
                return;
            }
        }
        else
        {
            if (ddlPackage.SelectedIndex == 0)
            {
                lblMsg.Text = "Please Select Package";
                ddlPackage.Focus();
                return;
            }
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            DataTable dtSched = null;
            int PackageID = 0;
            string ItemID = "", PkgName = "";

            if (rbtNewEdit.SelectedValue == "2")
            {
                PackageID = Util.GetInt(ddlPackage.SelectedItem.Value);
            }
            else
            {
                //----------------------------insert into PackageMasteripd---------------------------

                string insert = "INSERT INTO PackageMasteripd(PackageName,UserID,DaysInvolved) VALUES('" + txtPkg.Text.Trim() + "','" + Session["ID"].ToString() + "','" + Util.GetInt(txtValidDays.Text.Trim()) + "')";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, insert);
                PackageID = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT MAX(PackageId) FROM PackageMasteripd "));
                string PackageItemID = "SELECT ItemID FROM PackageMasteripd WHERE packageID='" + PackageID + "' ";
                PackageItemID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, PackageItemID));

                //----------------------insert into packagemasteripd_details---------------------------

                if (ViewState["ITEM"] != null && grdItem.Rows.Count > 0)
                {
                    //DataTable dtItem = (DataTable)ViewState["ITEM"];
                    //DataTable DistinctTable = dtItem.DefaultView.ToTable(true, "CategoryID");

                    //for (int x = 0; x < DistinctTable.Rows.Count; x++)
                    //{
                    //    DataRow[] drTemp = dtItem.Select("CategoryID = '" + DistinctTable.Rows[x]["CategoryID"].ToString() + "'");

                    //    for (int j = 0; j < drTemp.Length; j++)
                    //    {
                    //        DataRow rowItem = drTemp[j];
                    //        string CategoryID = Util.GetString(rowItem["CategoryID"]);
                    //        int Quantity = Util.GetInt(rowItem["Quantity"]);
                    //        decimal Amount = Util.GetDecimal(rowItem["Amount"]);
                    //        int IsAmount = Util.GetInt(rowItem["IsAmount"]);
                    //        int ConfigID = Util.GetInt(rowItem["ConfigID"]);

                    //        int IsSurgery = 0;
                    //        if (ConfigID == 22)
                    //            IsSurgery = 1;
                    //        else
                    //            IsSurgery = 0;

                    //        string Detail_ItemId = Util.GetString(rowItem["Detail_ItemID"]);
                    //        int PackageTypeID = Util.GetInt(rowItem["PackageTypeID"]);
                    //        string str = " INSERT INTO packagemasteripd_details(PackageId,ItemID,CategoryID,Quantity,Amount,UserID,IsAmount,IsSurgery,Detail_ItemID,PackageType)  " +
                    //                     " VALUES('" + PackageID + "','" + PackageItemID + "','" + CategoryID + "'," + Quantity + ",'" + Amount + "','" + Session["ID"].ToString() + "'," + IsAmount + "," + IsSurgery + ",'" + Detail_ItemId + "'," + PackageTypeID + ")";
                    //        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                    //    }
                    //}

                    foreach (GridViewRow row in grdItem.Rows)
                    {
                        string CategoryID = Util.GetString(((Label)row.FindControl("lblCategoryID")).Text);
                        int Quantity = Util.GetInt(((TextBox)row.FindControl("txtQty")).Text);
                        decimal Amount = Util.GetDecimal(((TextBox)row.FindControl("txtAmount")).Text);
                        int ConfigID = Util.GetInt(((Label)row.FindControl("lblConfigID")).Text);
                        int IsAmount = 0;
                        int IsSurgery = 0;
                        if (ConfigID == 22)
                            IsSurgery = 1;
                        else
                            IsSurgery = 0;

                        string Detail_ItemId = Util.GetString(((Label)row.FindControl("lblItemID")).Text);
                        int PackageTypeID = Util.GetInt(((Label)row.FindControl("lblPackageTypeID")).Text);
                        if (Util.GetInt(((Label)row.FindControl("lblIsAmount")).Text) == 1)
                        {
                            IsAmount = 1;
                        }
                        string str = " INSERT INTO packagemasteripd_details(PackageId,ItemID,CategoryID,Quantity,Amount,UserID,IsAmount,IsSurgery,Detail_ItemID,PackageType)  " +
                                        " VALUES('" + PackageID + "','" + PackageItemID + "','" + CategoryID + "'," + Quantity + ",'" + Amount + "','" + Session["ID"].ToString() + "'," + IsAmount + "," + IsSurgery + ",'" + Detail_ItemId + "'," + PackageTypeID + ")";
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                    }
                }
            }
            if (rbtNewEdit.SelectedValue == "2")
            {
                if (ViewState["ITEM"] != null && grdItem.Rows.Count > 0)
                {
                    //----------------------Update into packagemasteripd_details---------------------------

                    string update = " UPDATE packagemasteripd_details SET IsActive=0 WHERE PackageId='" + PackageID + "'";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, update);


                    string PackageItemID = "SELECT ItemID FROM PackageMasteripd WHERE packageID='" + PackageID + "' ";
                    PackageItemID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, PackageItemID));


                    //DataTable dtItem = (DataTable)ViewState["ITEM"];
                    //DataTable DistinctTable = dtItem.DefaultView.ToTable(true, "CategoryID");
                    ////----------------------insert into packagemasteripd_details---------------------------

                    //for (int x = 0; x < DistinctTable.Rows.Count; x++)
                    //{
                    //    DataRow[] drTemp = dtItem.Select("CategoryID = '" + DistinctTable.Rows[x]["CategoryID"].ToString() + "'");

                    //    for (int j = 0; j < drTemp.Length; j++)
                    //    {
                    //        DataRow rowItem = drTemp[j];
                    //        string CategoryID = Util.GetString(rowItem["CategoryID"]);
                    //        int Quantity = Util.GetInt(rowItem["Quantity"]);
                    //        float Amount = Util.GetDecimal(rowItem["Amount"]);
                    //        int IsAmount = Util.GetInt(rowItem["IsAmount"]);
                    //        int ConfigID = Util.GetInt(rowItem["ConfigID"]);

                    //        int IsSurgery = 0;
                    //        if (ConfigID == 22)
                    //            IsSurgery = 1;
                    //        else
                    //            IsSurgery = 0;
                    //        string Detail_ItemId = Util.GetString(rowItem["Detail_ItemID"]);
                    //        int PackageTypeID = Util.GetInt(rowItem["PackageTypeID"]);
                    //        string str = " INSERT INTO packagemasteripd_details(PackageId,ItemID,CategoryID,Quantity,Amount,UserID,IsAmount,IsSurgery,Detail_ItemID,PackageType)  " +
                    //                     " VALUES('" + PackageID + "','" + PackageItemID + "','" + CategoryID + "'," + Quantity + ",'" + Amount + "','" + Session["ID"].ToString() + "'," + IsAmount + "," + IsSurgery + ",'" + Detail_ItemId + "'," + PackageTypeID + ")";
                    //        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                    //    }
                    //}
                    foreach (GridViewRow row in grdItem.Rows)
                    {
                        string CategoryID = Util.GetString(((Label)row.FindControl("lblCategoryID")).Text);
                        int Quantity = Util.GetInt(((TextBox)row.FindControl("txtQty")).Text);
                        decimal Amount = Util.GetDecimal(((TextBox)row.FindControl("txtAmount")).Text);
                        int ConfigID = Util.GetInt(((Label)row.FindControl("lblConfigID")).Text);
                        int IsAmount = 0;
                        int IsSurgery = 0;
                        if (ConfigID == 22)
                            IsSurgery = 1;
                        else
                            IsSurgery = 0;

                        string Detail_ItemId = Util.GetString(((Label)row.FindControl("lblItemID")).Text);
                        int PackageTypeID = Util.GetInt(((Label)row.FindControl("lblPackageTypeID")).Text);
                        if (Util.GetInt(((Label)row.FindControl("lblIsAmount")).Text) == 1)
                        {
                            IsAmount = 1;
                        }
                        string str = " INSERT INTO packagemasteripd_details(PackageId,ItemID,CategoryID,Quantity,Amount,UserID,IsAmount,IsSurgery,Detail_ItemID,PackageType)  " +
                                        " VALUES('" + PackageID + "','" + PackageItemID + "','" + CategoryID + "'," + Quantity + ",'" + Amount + "','" + Session["ID"].ToString() + "'," + IsAmount + "," + IsSurgery + ",'" + Detail_ItemId + "'," + PackageTypeID + ")";
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                    }


                }

                //-------------update status in PackageMasteripd------------------------------
                string upd = "UPDATE PackageMasteripd SET IsActive=" + rdbActive.SelectedValue + " WHERE PackageID=" + ddlPackage.SelectedItem.Value + " ";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, upd);

                ItemID = "SELECT ItemID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON " +
                        "im.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON " +
                        "cf.CategoryID = sc.CategoryID WHERE cf.ConfigID=14 and " +
                        "im.Type_ID='" + ddlPackage.SelectedItem.Value + "' AND sc.Active=1 ";

                ItemID = StockReports.ExecuteScalar(ItemID);

                if (ItemID != "")
                {
                    string update = "Select * from f_ratelist_ipd where ItemID='" + ItemID + "' and ScheduleChargeID=" + ddlSchCharge.SelectedValue + " and PanelID='" + ddlPanel.SelectedItem.Value + "' and CentreID='"+Session["CentreID"].ToString()+"' ";
                    dtSched = StockReports.GetDataTable(update);
                }

                PkgName = ddlPackage.SelectedItem.Text;
            }
            else
            {
                PkgName = txtPkg.Text.Trim();
                string SubcategoryID = "SELECT sc.SubCategoryID FROM f_subcategorymaster sc INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID WHERE cf.ConfigID=14 AND sc.Active=1";
                SubcategoryID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, SubcategoryID));
                if (SubcategoryID.ToString() == "")
                {
                    lblMsg.Text = "Please Create SubcategoryID";
                    return;
                }
                ItemMaster objIMaster = new ItemMaster(tranX);
                objIMaster.Hospital_ID = "";
                objIMaster.Type_ID = 0;
                objIMaster.TypeName = PkgName;
                objIMaster.Type_ID = PackageID;
                objIMaster.Description = "";
                objIMaster.SubCategoryID = SubcategoryID;
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
                objIMaster.IPAddress = All_LoadData.IpAddress();
                objIMaster.CreaterID = Session["ID"].ToString();
                ItemID = objIMaster.Insert().ToString();

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE PackageMasteripd SET ItemID='" + ItemID + "' WHERE PackageID='" + PackageID + "'");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE packagemasteripd_details SET ItemID='" + ItemID + "' WHERE PackageId='" + PackageID + "'");
            }
            if (dtSched == null)
            {
                DataTable dtRoom = StockReports.GetDataTable("Select IPDCaseType_ID from ipd_case_Type_master where IsActive=1");

                foreach (DataRow dr in dtRoom.Rows)
                {
                    RateListIPD objRateList = new RateListIPD(tranX);
                    objRateList.PanelID = ddlPanel.SelectedItem.Value;
                    objRateList.ItemID = ItemID;
                    objRateList.Rate = Util.GetDecimal(txtAmount.Text.Trim());
                    objRateList.IsTaxable = 0;
                    objRateList.FromDate = DateTime.Now;
                    objRateList.ToDate = DateTime.Now;
                    objRateList.IsCurrent = 1;
                    objRateList.IsService = "YES";
                    objRateList.ItemDisplayName = PkgName;
                    objRateList.ItemCode = "";
                    objRateList.IPDCaseTypeID = dr["IPDCaseType_ID"].ToString();
                    objRateList.ScheduleChargeID = Util.GetInt(ddlSchCharge.SelectedValue);
                    objRateList.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objRateList.Insert();
                }
            }

            tranX.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            ViewState["ITEM"] = null;
            BindServices();
            BindPackage();
            txtAmount.Text = "0";
            txtPkg.Text = "";
            txtValidDays.Text = "0";

        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void ddlPackage_SelectedIndexChanged(object sender, EventArgs e)
    {
        ViewState["ITEM"] = null;
        BindServices();
        BindItems();
    }

    protected void ddlPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadScheduleCharges();
    }

    protected void ddlSchCharge_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtNewEdit.SelectedValue == "2")
            BindRate();
    }

    protected void grdItem_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        DataTable DtItem = ((DataTable)ViewState["ITEM"]);
        DtItem.Rows[e.RowIndex].Delete();
        ViewState["ITEM"] = DtItem;
        BindServices();
    }

    protected void rbtNewEdit_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (rbtNewEdit.SelectedValue == "1")
        {
            ddlPackage.ClearSelection();
            ddlPackage.Visible = false;
            txtPkg.Visible = true;
            txtAmount.Text = "0";
            txtAmount.Enabled = true;
            ViewState["ITEM"] = null;
            BindServices();
        }
        else
        {
            ddlPackage.ClearSelection();
            ddlPackage.Visible = true;
            txtPkg.Visible = false;
            txtAmount.Text = "0";
            txtAmount.Enabled = true;
            ViewState["ITEM"] = null;
            BindServices();
        }
    }

    //protected void rdbflag_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    if (rdbflag.SelectedValue == "0")
    //    {
    //        lblQty.Visible = true;
    //        txtqty.Visible = true;
    //        lblAmt.Visible = false;
    //        txtAmt.Visible = false;
    //    }
    //    else
    //    {
    //        lblQty.Visible = false;
    //        txtqty.Visible = false;
    //        lblAmt.Visible = true;
    //        txtAmt.Visible = true;
    //    }
    //}

    private void BindItems()
    {
        if (ddlPackage.SelectedValue != "0")
        {

            string str = " SELECT fc.CategoryID, (fc.Name)Category,pid.Quantity,pid.Amount,pid.IsAmount,cf.ConfigID,pid.Detail_ItemID,IF(pid.issurgery=1,(SELECT NAME FROM f_surgery_master WHERE Surgery_ID=pid.`Detail_ItemID`),(SELECT typename FROM f_itemmaster WHERE itemid=pid.`Detail_ItemID`))Detail_ItemName,PackageType,IFNULL(pmi.DaysInvolved,0)DaysInvolved FROM  packagemasteripd_details pid INNER JOIN PackageMasteripd pmi ON pid.PackageId=pmi.PackageID inner join f_categorymaster fc ON pid.CategoryID=fc.CategoryID INNER JOIN f_configrelation cf ON fc.CategoryID = cf.CategoryID  WHERE pid.PackageId='" + ddlPackage.SelectedItem.Value + "' AND pid.IsActive=1 ORDER BY fc.Name ";

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(str);

            if (dt.Rows.Count > 0)
            {
                txtValidDays.Text = dt.Rows[0]["DaysInvolved"].ToString();
                DataTable dtItem = getItemDT();

                foreach (DataRow drow in dt.Rows)
                {
                    DataRow dr = dtItem.NewRow();
                    dr["CategoryID"] = drow["CategoryID"];
                    dr["Category"] = drow["Category"];
                    dr["Quantity"] = drow["Quantity"];
                    dr["Amount"] = drow["Amount"];
                    dr["IsAmount"] = drow["IsAmount"];
                    dr["ConfigID"] = drow["ConfigID"];
                    dr["Detail_ItemID"] = drow["Detail_ItemID"];
                    dr["Detail_ItemName"] = drow["Detail_ItemName"];
                    dr["PackageTypeID"] = drow["PackageType"];
                    if (drow["PackageType"].ToString() == "1")
                        dr["PackageType"] = "Category Wise";
                    else
                        dr["PackageType"] = "Item Wise";
                    dtItem.Rows.Add(dr);
                }
                ViewState["ITEM"] = dtItem;
                BindServices();
                BindRate();
            }
            else
            {
                lblMsg.Text = " No Item Found";
                ViewState["ITEM"] = null;
                BindServices();

                BindRate();
            }
        }
    }

    private void BindPackage()
    {
        string str = "Select PackageID,PackageName from PackageMasteripd Where IsActive=1 order by PackageName";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            ddlPackage.DataSource = dt;
            ddlPackage.DataTextField = "PackageName";
            ddlPackage.DataValueField = "PackageID";
            ddlPackage.DataBind();
            ddlPackage.Items.Insert(0, new ListItem("--Select--", "0"));
        }
        else
            ddlPackage.Items.Insert(0, new ListItem("--No Package--", "0"));
    }

    private void BindRate()
    {
        string bind = "";
        bind = " select Rate,PanelID,ScheduleChargeID from f_ratelist_ipd where ItemID = ( " +
               "     Select ItemID from f_itemmaster im inner join f_subcategorymaster sc on sc.SubCategoryID = im.SubCategoryID " +
               "     INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID " +
               "     WHERE cf.ConfigID=14 AND sc.Active=1 and im.Type_ID = '" + ddlPackage.SelectedValue + "'  LIMIT 1 " +
               " ) AND PanelID='" + ddlPanel.SelectedItem.Value + "' AND ScheduleChargeID='" + ddlSchCharge.SelectedItem.Value + "' and CentreID='"+Session["CentreID"].ToString()+"' LIMIT 1";

        DataTable rate = new DataTable();
        rate = StockReports.GetDataTable(bind);

        if (rate.Rows.Count > 0)
        {
            txtAmount.Text = Util.GetString(rate.Rows[0]["Rate"]);
            ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByValue(rate.Rows[0]["PanelID"].ToString()));
            LoadScheduleCharges();
            ddlSchCharge.SelectedIndex = ddlSchCharge.Items.IndexOf(ddlSchCharge.Items.FindByValue(rate.Rows[0]["ScheduleChargeID"].ToString()));
            txtAmount.Enabled = false;
        }
        else
        {
            txtAmount.Text = "0";
            txtAmount.Enabled = true;
        }
    }

    private bool CheckDuplicate()
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM PackageMasteripd WHERE PackageName='" + txtPkg.Text.Trim() + "' and IsActive=1"));
        if (count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    private void LoadCategory()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT CONCAT(cm.CategoryID,'#',cf.ConfigID)CategoryID,cm.NAME FROM f_categorymaster  cm INNER JOIN f_configrelation cf ON cm.CategoryID = cf.CategoryID WHERE cf.ConfigID IN( 2,8,6,11,24,26,3,1,22,25,27,20) AND cm.Active=1");
        ddlCategory.DataSource = dt;
        ddlCategory.DataValueField = "CategoryID";
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataBind();
        ddlCategory.Items.Insert(0, "-- Select Category --");
    }

    private void LoadPanel()
    {
        ddlPanel.DataSource = CreateStockMaster.LoadPanelCompanyRef();
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();
        ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByText(AllGlobalFunction.Panel.ToString()));
    }

    private void LoadScheduleCharges()
    {
        if (ddlPanel.SelectedIndex != -1)
        {
            string cpyFrm = "SELECT NAME,ScheduleChargeID,IsDefault FROM f_rate_schedulecharges rs INNER JOIN f_panel_master fpm ON rs.panelid=fpm.ReferenceCode WHERE fpm.PanelID ='" + ddlPanel.SelectedItem.Value + "'";
            DataTable dtFrm = StockReports.GetDataTable(cpyFrm);
            ddlSchCharge.DataSource = dtFrm;
            ddlSchCharge.DataTextField = "NAME";
            ddlSchCharge.DataValueField = "ScheduleChargeID";
            ddlSchCharge.DataBind();

            if (dtFrm != null && dtFrm.Rows.Count > 0)
            {
                string Selected = dtFrm.Select("IsDefault=1")[0]["ScheduleChargeID"].ToString();
                ddlSchCharge.SelectedIndex = ddlSchCharge.Items.IndexOf(ddlSchCharge.Items.FindByValue(Selected));
            }
        }
    }

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        chlItems.Items.Clear();
        LoadItemMaster(ddlCategory.SelectedValue.Split('#')[0].ToString());
    }

    private void LoadItemMaster(string CategoryID)
    {
        string str = "";
        if (CategoryID == "LSHHI11")
        {
             str = "  SELECT sm.Surgery_ID ItemID , sm.Name TypeName FROM f_surgery_master sm   WHERE  IsActive=1 ORDER BY sm.Name";
        }
        else
        {
             str = " SELECT ItemID,IF(ConfigID =1,CONCAT(TypeName,'(',sc.Name,')'),TypeName) TypeName FROM f_itemmaster im  INNER JOIN f_subcategorymaster sc  ON im.SubCategoryID=sc.SubCategoryID  INNER JOIN f_categorymaster  cm ON sc.CategoryID=cm.CategoryID  INNER JOIN f_configrelation cf ON cm.CategoryID = cf.CategoryID WHERE ";
            if (CategoryID != "")
                str = str + " cm.CategoryID='" + CategoryID.ToString() + "'  ";
            else
                str = str + " cf.ConfigID IN( 2,8,6,14,11,24,26,3,1,25,27,20) ";
            str = str + " AND cm.Active=1 AND sc.Active=1 AND im.IsActive=1 ";
            if (CategoryID == "")
            {
                str = str + " Union All ";
                str = str + " SELECT sm.Surgery_ID ItemID , sm.Name TypeName FROM f_surgery_master sm   WHERE  IsActive=1 ";
            }
            str=  str + " ORDER BY TypeName";
        }
        DataTable dt = StockReports.GetDataTable(str);
        //if (dt.Rows.Count > 0)
        //{
        //    ddlItem.DataSource = dt;
        //    ddlItem.DataValueField = "ItemID";
        //    ddlItem.DataTextField = "TypeName";
        //    ddlItem.DataBind();
        //    ddlItem.Items.Insert(0, "-- Select Item --");
        //}
        //else
        //{
        //    ddlItem.DataSource = dt;
        //    ddlItem.DataBind();
        //    ddlItem.Items.Insert(0, "-- No Record found --");
        //}

        if (dt.Rows.Count > 0)
        {
            chkItems.Visible = true;
            chlItems.DataSource = dt;
            chlItems.DataTextField = "TypeName";
            chlItems.DataValueField = "ItemID";
            chlItems.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            chkItems.Visible = false;
            chlItems.Items.Clear();
            lblMsg.Text = "No Items Found";
        }

    }

    protected void rbtPackageType_SelectedIndexChanged(object sender, EventArgs e)
    {
        HideShowControls();
    }

    private void HideShowControls()
    {

        chlItems.DataSource = new DataTable();
        chlItems.DataBind();
        ddlCategory.SelectedIndex = 0;
        if (rbtPackageType.SelectedValue == "1") // In Case Of Category Wise
        {
            //lblItem.Visible = false;
            //ddlItem.Visible = false;
           // rdbflag.SelectedIndex = 1; // To Select Amount Wise
          //  rdbflag.Enabled = false;
          //  lblQty.Visible = false;
          //  lblAmt.Visible = true;
         //   txtAmt.Visible = true;
         //   txtqty.Visible = false;
            //ddlItem.DataSource = null;
            divSearch.Visible = false;
            trchkItem.Visible = false;
        }
        else //In Case of Item Wise
        {
         //   rdbflag.SelectedIndex = 0; // To select Quantity Radiobutton
         //   rdbflag.Enabled = false;
            //lblItem.Visible = true;
            //ddlItem.Visible = true;
          //  lblAmt.Visible = false;
         //   txtAmt.Visible = false;
         //   lblQty.Visible = true;
         //   txtqty.Visible = true;
            //ddlItem.DataSource = null;
            divSearch.Visible = true;
            trchkItem.Visible = true;
        }
    }

    protected void chkItems_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < chlItems.Items.Count; i++)
            chlItems.Items[i].Selected = chkItems.Checked;
    }
    protected void grdItem_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string IsAmount = ((Label)e.Row.FindControl("lblIsAmount")).Text;
            if (IsAmount == "1")
            {
                ((TextBox)e.Row.FindControl("txtQty")).Enabled = false;
            }
            else
            {
                ((TextBox)e.Row.FindControl("txtAmount")).Enabled = false;
            }
        }
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pm.Packagename,IFNULL(im.TypeName,'') Itemname,cm.Name CategoryName,pmd.Amount,pmd.Quantity,em.Name CreatedBy, ");
        sb.Append("DATE_FORMAT(pmd.CreationDate,'%d-%b-%Y %H:%m:%s')CreatedDate,IF(pm.IsActive=1,'YES','NO') STATUS FROM packagemasteripd_details pmd ");
        sb.Append("INNER JOIN packagemasteripd pm ON pm.PackageID=pmd.PackageId ");
        sb.Append("LEFT JOIN f_itemmaster im ON im.ItemID=pmd.Detail_ItemID ");
        sb.Append("LEFT JOIN f_categorymaster cm ON cm.CategoryID=pmd.CategoryID ");
        sb.Append("INNER JOIN employee_master em ON em.Employee_ID=pmd.UserID; ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Package Report";
            Session["Period"] = "As On" + DateTime.Now.ToString("dd-MM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
        else
            lblMsg.Text = "No Record Found.";
    }
}