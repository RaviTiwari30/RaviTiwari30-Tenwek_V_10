using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Services;

public partial class Design_Purchase_PurchaseRequest : System.Web.UI.Page
{
    #region Event Handling

    protected void btnReset_Click(object sender, EventArgs e)
    {
        Clear();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string PRNo = SaveRequest();
        if (PRNo != string.Empty)
        {
            if (chkprnt.Checked == true)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Request No. : " + PRNo + "');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.open('PRReport.aspx?PRNumber=" + PRNo + "');location.href='PurchaseRequest.aspx';", true);
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Request No. : " + PRNo + "');", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

    }

    protected void btnSaveItems_Click(object sender, EventArgs e)
    {
        if (ddlItem.SelectedIndex < 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (txtQuantity.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
            txtQuantity.Focus();
            return;
        }
        if (ViewState["dtItems"] != null)
        {
            DataTable dtChk = (DataTable)ViewState["dtItems"];
            if (dtChk.Rows.Count > 0 && dtChk != null)
            {
                for (int i = 0; i < dtChk.Rows.Count; i++)
                {
                    if (dtChk.Rows[i]["ItemType"].ToString() != ddlStore.SelectedValue)
                    {
                        lblMsg.Text = "Items cannot be added of different ItemType at one time";
                        return;
                    }
                }
            }
        }

        DataTable dtItems = GetItemDataTable();
        if (dtItems != null)
        {
            string itemID = ddlItem.SelectedItem.Value.Split('#')[0];
            string itemName = ddlItem.SelectedItem.Text.Split('#')[1];
            DataRow[] dr = dtItems.Select("ItemID = '" + itemID + "'");


            if (dr.Length > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM035','" + lblMsg.ClientID + "');", true);
            }
            else
            {
                DataRow row = dtItems.NewRow();
                row["ItemID"] = itemID;
                row["ItemName"] = itemName.Split('#')[0];
                row["SubCategory"] = ddlItem.SelectedItem.Value.Split('#')[1];
                row["Unit"] = ddlItem.SelectedItem.Value.Split('#')[2];
                row["RequiredQty"] = txtQuantity.Text;
                row["Purpose"] = txtPurpose.Text;
                row["Specification"] = txtSpecification.Text;
                row["Dept"] = ViewState["DeptLedgerNo"].ToString();
                row["ItemType"] = ddlStore.SelectedValue;
                row["listBoxSelectedIndex"] = ddlItem.SelectedIndex;
                row["CurrentQuantity"] = ddlItem.SelectedItem.Value.Split('#')[3];
                row["Minimum"] = ddlItem.SelectedItem.Value.Split('#')[4];
                row["Maximum"] = ddlItem.SelectedItem.Value.Split('#')[5];
                dtItems.Rows.Add(row);

                gvRequestItems.DataSource = dtItems;
                gvRequestItems.DataBind();
                ViewState["dtItems"] = dtItems;
                ddlItem.Items.RemoveAt(ddlItem.SelectedIndex);

                ddlItem.SelectedIndex = -1;
                txtQuantity.Text = string.Empty;
                txtSpecification.Text = string.Empty;
                txtPurpose.Text = string.Empty;
                ddlStore.Enabled = false;
                txtDecIncQty.Text = string.Empty;
                txtCurrentReqQty.Text = string.Empty;
                ddlDecIncQty.SelectedIndex = 0;
            }
        }
    }

    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();
        DataTable dt = StockReports.GetRights(RoleId);
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["IsStore"].ToString() == "true")
            {
                ddlDept.Enabled = false;
            }
            else
            {
                ddlDept.Enabled = true;
            }

            if (dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "true")
            {
                ddlStore.SelectedIndex = 0;
            }
            else if (dt.Rows[0]["IsMedical"].ToString() == "true" || dt.Rows[0]["IsGeneral"].ToString() == "true")
            {
                if (dt.Rows[0]["IsMedical"].ToString() == "true")
                {
                    ddlStore.SelectedIndex = 0;
                    ddlStore.Enabled = false;
                }
                else if (dt.Rows[0]["IsGeneral"].ToString() == "true")
                {
                    ddlStore.SelectedIndex = 1;
                    ddlStore.Enabled = false;
                }
            }
            else if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "false")
            {
                string Msg = "You do not have rights to generate purchase request";
                Response.Redirect("MsgPage.aspx?msg=" + Msg);
            }
            return false;
        }
        else { return true; }
    }

    protected void ddlRequestType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlRequestType.SelectedIndex == 3)
        {
            Date.Visible = true;
        }
        else
        { Date.Visible = false; }
    }

    protected void gvRequestItems_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = GetItemDataTable();
            string itemName = dtItem.Rows[args]["ItemName"].ToString();
            string itemID = dtItem.Rows[args]["ItemID"].ToString() + "#" + dtItem.Rows[args]["SubCategory"].ToString() + "#" + dtItem.Rows[args]["Unit"].ToString() + "#" + dtItem.Rows[args]["CurrentQuantity"].ToString() + "#" + dtItem.Rows[args]["Minimum"].ToString() + "#" + dtItem.Rows[args]["Maximum"].ToString();
            ddlItem.Items.Insert(Util.GetInt(dtItem.Rows[args]["listBoxSelectedIndex"]), new ListItem(itemName, itemID));
            dtItem.Rows[args].Delete();
            gvRequestItems.DataSource = dtItem;
            gvRequestItems.DataBind();
            ViewState["dtItems"] = dtItem;
        }
    }

    protected void lnkNewItems_Click(object sender, EventArgs e)
    {
        BindItem();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int CentreID = Util.GetInt(Session["CentreID"].ToString()); if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                if (ChkRights())
                {
                    string Msg = "You do not have rights to generate purchase request ";
                    Response.Redirect("MsgPage.aspx?msg=" + Msg);
                }
                else
                {
                    if (Session["DeptLedgerNo"] != null)
                        ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

                    if (Session["IsStore"] != null)
                        ViewState["IsStore"] = Session["IsStore"].ToString();
                    else
                        ViewState["IsStore"] = "0";
                    AllLoadData_Store.bindStore(ddlStore, "STO");
                    AllLoadData_Store.bindTypeMaster(ddlRequestType);
                    AllLoadData_Store.bindStoreDepartments(ddlDept, ViewState["DeptLedgerNo"].ToString());
                    ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByValue("LSHHI142"));
                    ddlDept.Enabled = false;
                    BindItem();
                    txtNarration.Focus();
                    Date.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
                    Session["ddlStore"] = ddlStore.SelectedValue;
                    Session.Remove("dtItems");

                    Page.ClientScript.RegisterHiddenField("hdnDeptledgerNo", Util.GetString(ViewState["DeptLedgerNo"]));
                }
            }
        }
        Date.Attributes.Add("readOnly", "true");
        calEntryDate1.EndDate = DateTime.Now;
        txtQuantity.Attributes.Add("readOnly", "true");
        //txtCurrentReqQty.Attributes.Add("readOnly", "false");
    }

    #endregion Event Handling

    #region Data Binding
    private void BindItem()
    {
        DataTable dtItem = new DataTable();
        string ConfigID1 = "";
        if (ddlStore.SelectedValue == "STO00001")
            ConfigID1 = "11";
        else
            ConfigID1 = "28";
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT CONCAT(IFNULL(ItemCode,''),' # ',ItemName)ItemName,itemID ItemID FROM   ");
        sb.Append(" (  ");
        sb.Append("    SELECT IM.itemcode,IM.Typename ItemName,  CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(im.MajorUnit,''),'#',  ");
        sb.Append("    IFNULL(spr.CurrentQuantity,0),'#',IFNULL(spr.Minimum,0),'#',IFNULL(spr.Maximum,0),'#',IFNULL(st.Qty,0) )itemID   FROM f_itemmaster IM  ");
        sb.Append("    INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID     ");
        sb.Append("    INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID  ");
        if (chkNormItems.Checked)
            sb.Append(" INNER JOIN ");
        else
            sb.Append(" LEFT JOIN ");
        sb.Append("     f_setPurchaseRequestQuantity spr ON spr.ItemID=IM.ItemID AND ");
        sb.Append("    spr.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' AND spr.isActive=1   ");
        sb.Append("    AND StoreType='" + ddlStore.SelectedValue + "'  ");
        sb.Append(" LEFT JOIN (SELECT sum(InitialCount-ReleasedCount) ");
        sb.Append(" Qty,ItemID FROM f_stock WHERE IsPost=1 AND (InitialCount-ReleasedCount)>0 AND DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' GROUP BY ITemID)st ON st.itemID = im.ItemID ");
        //sb.Append(" LEFT JOIN  f_stock st ON st.ItemID = IM.ItemID AND st.DeptLedgerNo='" +  + "'");
        sb.Append("    WHERE CR.ConfigID = '" + ConfigID1 + "' AND im.IsActive=1  ");
        sb.Append("  GROUP BY im.ItemID )t ");
        sb.Append(" ORDER BY ItemName ");
        dtItem = StockReports.GetDataTable(sb.ToString());
        if (dtItem.Rows.Count > 0)
        {
            ddlItem.DataSource = dtItem;
            ddlItem.DataTextField = "ItemName";
            ddlItem.DataValueField = "ItemID";
            ddlItem.DataBind();
            //ddlItem.Items.Add(new ListItem("Select", "0", true));
            // ddlItem.SelectedItem.Text = "Select";
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key105", "$('.searchable').chosen('destroy').chosen({ width: '100%' });", true);
        }
        else
        {
            ddlItem.Items.Clear();
            ddlItem.Items.Add("No Item Found");
        }
        ddlItem.SelectedIndex = -1;
        txtCurrentReqQty.Text = "";
        txtQuantity.Text = "";
        ddlDecIncQty.SelectedIndex = 0;
        ddlDecIncQty.Enabled = false;
        txtDecIncQty.Text = "";
        ddlDecIncQty.Enabled = false;
    }
    //private DataTable GetItemDataTable()
    //{
    //    if (ViewState["dtItems"] != null)
    //    {
    //        return (DataTable)ViewState["dtItems"];
    //    }
    //    else
    //    {
    //        DataTable dtItem = new DataTable();
    //        dtItem.Columns.Add("ItemID");
    //        dtItem.Columns.Add("ItemName");
    //        dtItem.Columns.Add("SubCategory");
    //        dtItem.Columns.Add("Unit");
    //        dtItem.Columns.Add("RequiredQty");
    //        dtItem.Columns.Add("Purpose");
    //        dtItem.Columns.Add("Specification");
    //        dtItem.Columns.Add("Dept");
    //        dtItem.Columns.Add("ItemType");
    //        dtItem.Columns.Add("listBoxSelectedIndex");
    //        dtItem.Columns.Add("CurrentQuantity");
    //        dtItem.Columns.Add("Minimum");
    //        dtItem.Columns.Add("Maximum");
    //        return dtItem;
    //    }
    //}
    #endregion Data Binding

    #region Generate Purchase Request

    private string SaveRequest()
    {
        string typeOfTnx = "";
        string storeLedgerNo = "";
        if (ViewState["dtItems"] != null)
        {
            DataTable dtItems = (DataTable)ViewState["dtItems"];
            if (dtItems.Rows.Count > 0)
            {
                if (dtItems.Rows[0]["ItemType"].ToString() == "STO00001")
                {
                    typeOfTnx = "Purchase";
                    storeLedgerNo = "STO00001";
                }
                else
                {
                    typeOfTnx = "NMPURCHASE";
                    storeLedgerNo = "STO00002";
                }
                string PRNo = string.Empty;
                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

                try
                {
                    string date = string.Empty;
                    if (Date.Visible == true)
                    {
                        date = Util.GetDateTime(Date.Text).ToString("yyyy-MM-dd");
                    }
                    else
                    {
                        date = "0001-01-01";
                    }

                    PurchaseRequestMaster PRMst = new PurchaseRequestMaster(Tranx);
                    PRMst.RaisedByID = Convert.ToString(Session["ID"]);
                    PRMst.RaisedByName = Convert.ToString(Session["UserName"]);
                    PRMst.RaisedDate = DateTime.Now;
                    PRMst.Status = 0;
                    PRMst.Approved = 0;
                    PRMst.Remarks = string.Empty;
                    PRMst.StoreID = ddlStore.SelectedValue;
                    PRMst.Subject = txtNarration.Text.Trim().Replace("'", "''");
                    PRMst.Type = ddlRequestType.SelectedItem.Text;
                    PRMst.DeptLedgerNo = ddlDept.SelectedValue;
                    PRMst.IssuedTo = ViewState["DeptLedgerNo"].ToString();
                    PRMst.Hospital_ID = Session["HOSPID"].ToString();
                    PRMst.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    PRMst.IpAddress = HttpContext.Current.Request.UserHostAddress;
                    PRMst.bydate = date;

                    PRNo = PRMst.Insert();

                    if (PRNo != string.Empty)
                    {
                        foreach (DataRow dr in dtItems.Rows)
                        {
                            string str = string.Empty;

                            str = "Call Insert_PurchaseRequestDetail('" + PRNo + "','" + Util.GetString(dr["ItemID"]) + "','" + Util.GetString(dr["ItemName"]).Replace("'", "''") + "','" + Util.GetString(dr["SubCategory"]) + "'," + Util.GetDecimal(dr["RequiredQty"]) + "," + Util.GetDecimal(dr["RequiredQty"]) + ",0,'" + Util.GetString(dr["Specification"]) + "','" + Util.GetString(dr["Purpose"]) + "',0,'" + Util.GetString(dr["Unit"]) + "','" + Util.GetString(dr["Dept"]) + "','" + typeOfTnx + "','" + storeLedgerNo + "','" + Session["HOSPID"].ToString() + "','" + Util.GetInt(Session["CentreID"].ToString()) + "');";

                            int result = Convert.ToInt32(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, str));

                            if (result < 1)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                                return string.Empty;
                            }
                        }
                        int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + ddlDept.SelectedValue + "'"));
                        string notification = Notification_Insert.notificationInsert(24, PRNo, Tranx, "", "", roleID);
                        Tranx.Commit();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        Clear();
                        lblMsg.Text = string.Empty;
                        return PRNo;
                    }
                    else
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                        return string.Empty;
                    }
                }
                catch (Exception ex)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                    return string.Empty;
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM036','" + lblMsg.ClientID + "');", true);
                return string.Empty;
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM036','" + lblMsg.ClientID + "');", true);
            return string.Empty;
        }
    }

    #endregion Generate Purchase Request

    #region Reset Form

    private void Clear()
    {
        ddlItem.SelectedIndex = -1;
        txtQuantity.Text = string.Empty;
        txtPurpose.Text = string.Empty;
        txtSpecification.Text = string.Empty;
        txtNarration.Text = "";
        gvRequestItems.DataSource = null;
        gvRequestItems.DataBind();
        ViewState.Clear();
        Session.Remove("dtItems");
    }

    #endregion Reset Form

    protected void btnAddMulti_Click(object sender, EventArgs e)
    {
        DataTable dtItems = GetItemDataTable();
        DataTable dtNewItems = (DataTable)Session["popdata"];
        Session["popdata"] = null;
        if (dtNewItems != null)
        {
            foreach (DataRow drNew in dtNewItems.Rows)
            {
                DataRow[] dr = dtItems.Select("ItemID = '" + drNew["Itemid"].ToString() + "'");

                if (dr.Length == 0)
                {
                    DataRow row = dtItems.NewRow();
                    row["ItemID"] = drNew["Itemid"].ToString();
                    row["ItemName"] = drNew["ItemName"].ToString();
                    row["SubCategory"] = drNew["SubCategory"].ToString();
                    row["Unit"] = drNew["Unit"].ToString();
                    row["RequiredQty"] = drNew["RequiredQty"].ToString();
                    row["Purpose"] = drNew["Purpose"].ToString();
                    row["Specification"] = drNew["Specification"].ToString();
                    dtItems.Rows.Add(row);

                    gvRequestItems.DataSource = dtItems;
                    gvRequestItems.DataBind();
                    ViewState["dtItems"] = dtItems;
                    ddlItem.SelectedIndex = 0;
                    txtQuantity.Text = string.Empty;
                    txtSpecification.Text = string.Empty;
                    txtPurpose.Text = string.Empty;
                }
            }
        }
    }
    protected void ddlStore_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
    }
    protected void ddlLevelType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
    }
    protected void chkNormItems_CheckedChanged(object sender, EventArgs e)
    {
        BindItem();
    }

    [WebMethod(EnableSession = true)]
    public static DataTable GetItemDataTable()
    {
        if (HttpContext.Current.Session["dtItems"] != null)
        {
            return (DataTable)HttpContext.Current.Session["dtItems"];
        }
        else
        {
            DataTable dtItem = new DataTable();
            dtItem.Columns.Add("ItemID");
            dtItem.Columns.Add("ItemName");
            dtItem.Columns.Add("SubCategory");
            dtItem.Columns.Add("Unit");
            dtItem.Columns.Add("RequiredQty");
            dtItem.Columns.Add("Purpose");
            dtItem.Columns.Add("Specification");
            dtItem.Columns.Add("Dept");
            dtItem.Columns.Add("ItemType");
            dtItem.Columns.Add("listBoxSelectedIndex");
            dtItem.Columns.Add("CurrentQuantity");
            dtItem.Columns.Add("Minimum");
            dtItem.Columns.Add("Maximum");
            return dtItem;
        }
    }

    [WebMethod]
    public static string BindPurchaseOrderDetail(string ItemId)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT sum(ApprovedQty)ApprovedQty FROM f_purchaseorderdetails  WHERE ItemID='" +  + "'");
        sb.Append(" SELECT SUM(pod.ApprovedQty)ApprovedQty FROM f_purchaseorderdetails pod INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo=pod.PurchaseOrderNo ");
        sb.Append(" WHERE pod.ItemID='" + ItemId.ToString() + "' AND pod.ApprovedQty>0 AND po.Status=2 AND pod.RecievedQty=0  GROUP BY pod.ItemID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }

    }

    [WebMethod]
    public static string MainStock(string ItemId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Ifnull((ROUND(IF(st.ISPOST=1,SUM(st.InitialCount-st.ReleasedCount),0),2)),0)MainStock  FROM f_stock st  ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=st.DeptledgerNo WHERE   StoreLedgerNo='" + HttpContext.Current.Session["ddlStore"].ToString() + "' AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND st.ItemID='" + ItemId.ToString() + "'   ");
        sb.Append(" AND lm.LedgerNumber='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  GROUP BY DeptLedgerNo,ITemID     ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }

    [WebMethod]
    public static string CurrentStock(string ItemId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT IFNULL((ROUND(IF(ISPOST=1,SUM(InitialCount-ReleasedCount),0),2)),0)CurrentStock  FROM  ");
        sb.Append(" f_stock st INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=st.DeptLedgerNo ");
        sb.Append(" WHERE ItemID='" + ItemId.ToString() + "' AND StoreLedgerNo='" + HttpContext.Current.Session["ddlStore"].ToString() + "'  ");
        if (HttpContext.Current.Session["ddlStore"].ToString() == "STO00001")
        {
            sb.Append("  AND lm.LedgerNumber='" + AllGlobalFunction.MedicalDeptLedgerNo.ToString() + "'  AND CentreID='1' GROUP BY DeptLedgerNo,ItemID");
        }
        else
            sb.Append("  AND lm.LedgerNumber='" + AllGlobalFunction.GeneralDeptLedgerNo.ToString() + "'  AND CentreID='1' GROUP BY DeptLedgerNo,ItemID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string AddItems(string StoreId, string ItemId, string ItemName, string Quantity, string Purpose, string Specification, int Index)
    {
        if (HttpContext.Current.Session["dtItems"] != null)
        {
            DataTable dtChk = (DataTable)HttpContext.Current.Session["dtItems"];
            if (dtChk.Rows.Count > 0 && dtChk != null)
            {
                for (int i = 0; i < dtChk.Rows.Count; i++)
                {
                    if (dtChk.Rows[i]["ItemType"].ToString() != StoreId.ToString())
                    {
                        //lblMsg.Text = "Items cannot be added of different ItemType at one time";
                        //return;
                        return "1";
                    }
                }
            }
        }
        DataTable dtItems = GetItemDataTable();
        if (dtItems != null)
        {
            string itemID = ItemId.Split('#')[0];
            string itemName = ItemName.Split('#')[1];
            DataRow[] dr = dtItems.Select("ItemID = '" + itemID + "'");
            if (dr.Length > 0)
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM035','" + lblMsg.ClientID + "');", true);
                return "2";
            }
            else
            {
                DataRow row = dtItems.NewRow();
                row["ItemID"] = itemID;
                row["ItemName"] = itemName.Split('#')[0];
                row["SubCategory"] = ItemId.Split('#')[1];
                row["Unit"] = ItemId.Split('#')[2];
                row["RequiredQty"] = Quantity.ToString();
                row["Purpose"] = Purpose.ToString();
                row["Specification"] = Specification.ToString();
                row["Dept"] = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                row["ItemType"] = StoreId.ToString();
                row["listBoxSelectedIndex"] = (Index - 1);
                row["CurrentQuantity"] = ItemId.Split('#')[3];
                row["Minimum"] = ItemId.Split('#')[4];
                row["Maximum"] = ItemId.Split('#')[5];
                dtItems.Rows.Add(row);
                HttpContext.Current.Session["dtItems"] = dtItems;
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtItems);
                //gvRequestItems.DataSource = dtItems;
                //gvRequestItems.DataBind();
                //ddlItem.Items.RemoveAt(ddlItem.SelectedIndex);
                //ddlItem.SelectedIndex = -1;
                //txtQuantity.Text = string.Empty;
                //txtSpecification.Text = string.Empty;
                //txtPurpose.Text = string.Empty;
                //ddlStore.Enabled = false;
                //txtDecIncQty.Text = string.Empty;
                //txtCurrentReqQty.Text = string.Empty;
                //ddlDecIncQty.SelectedIndex = 0;
            }
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string DeleteRow(string RowId)
    {
        int args = Util.GetInt(RowId.ToString());
        DataTable dtItem = GetItemDataTable();
        string itemName = dtItem.Rows[args]["ItemName"].ToString();
        string itemID = dtItem.Rows[args]["ItemID"].ToString() + "#" + dtItem.Rows[args]["SubCategory"].ToString() + "#" + dtItem.Rows[args]["Unit"].ToString() + "#" + dtItem.Rows[args]["CurrentQuantity"].ToString() + "#" + dtItem.Rows[args]["Minimum"].ToString() + "#" + dtItem.Rows[args]["Maximum"].ToString();
        //ddlItem.Items.Insert(Util.GetInt(dtItem.Rows[args]["listBoxSelectedIndex"]), new ListItem(itemName, itemID));
        dtItem.Rows[args].Delete();
        if (dtItem.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtItems"] = dtItem;
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtItem);
        }
        else
        {
            return "";
        }

        //int args = Util.GetInt(e.CommandArgument);
        //DataTable dtItem = GetItemDataTable();
        //string itemName = dtItem.Rows[args]["ItemName"].ToString();
        // string itemID = dtItem.Rows[args]["ItemID"].ToString() + "#" + dtItem.Rows[args]["SubCategory"].ToString() + "#" + dtItem.Rows[args]["Unit"].ToString() + "#" + dtItem.Rows[args]["CurrentQuantity"].ToString() + "#" + dtItem.Rows[args]["Minimum"].ToString() + "#" + dtItem.Rows[args]["Maximum"].ToString();
        //ddlItem.Items.Insert(Util.GetInt(dtItem.Rows[args]["listBoxSelectedIndex"]), new ListItem(itemName, itemID));
        //dtItem.Rows[args].Delete();
        //gvRequestItems.DataSource = dtItem;
        //gvRequestItems.DataBind();
        //ViewState["dtItems"] = dtItem;
    }

    [WebMethod(EnableSession = true)]
    public static string SaveAllDetails(string chkprnt, string StoreId, string Narration, string RequestType, string DepartMent, string Bydate, string ledgerNo)
    {
        string PRNo = SaveRequest(StoreId, Narration, RequestType, DepartMent, Bydate, ledgerNo);//
        if (PRNo != string.Empty)
        {
            if (chkprnt == "True")
            {
               HttpContext.Current.Session.Remove("dtItems");
                return PRNo;
            }
            HttpContext.Current.Session.Remove("dtItems");
            return PRNo;
        }
        else
        {
            HttpContext.Current.Session.Remove("dtItems");
            return "1";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveRequest(string StoreId, string Narration, string RequestType, string DepartMent, string Bydate, string ledgerNo)
    {
        string typeOfTnx = "";
        string storeLedgerNo = "";
        if (HttpContext.Current.Session["dtItems"] != null)
        {
            DataTable dtItems = (DataTable)HttpContext.Current.Session["dtItems"];
            if (dtItems.Rows.Count > 0)
            {
                if (dtItems.Rows[0]["ItemType"].ToString() == "STO00001")
                {
                    typeOfTnx = "Purchase";
                    storeLedgerNo = "STO00001";
                }
                else
                {
                    typeOfTnx = "NMPURCHASE";
                    storeLedgerNo = "STO00002";
                }
                string PRNo = string.Empty;
                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    string date = string.Empty;
                    if (Bydate != "")
                    {
                        date = Util.GetDateTime(Bydate).ToString("yyyy-MM-dd");
                    }
                    else
                    {
                        date = "0001-01-01";
                    }
                    PurchaseRequestMaster PRMst = new PurchaseRequestMaster(Tranx);
                    PRMst.RaisedByID = Convert.ToString(HttpContext.Current.Session["ID"]);
                    PRMst.RaisedByName = Convert.ToString(HttpContext.Current.Session["UserName"]);
                    PRMst.RaisedDate = DateTime.Now;
                    PRMst.Status = 0;
                    PRMst.Approved = 0;
                    PRMst.Remarks = string.Empty;
                    PRMst.StoreID = StoreId.ToString();
                    PRMst.Subject = Narration.Trim().Replace("'", "''");
                    PRMst.Type = RequestType.ToString();
                    PRMst.DeptLedgerNo = DepartMent.ToString();
                    PRMst.IssuedTo = ledgerNo; //HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    PRMst.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    PRMst.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    PRMst.IpAddress = HttpContext.Current.Request.UserHostAddress;
                    PRMst.bydate = date;
                    PRNo = PRMst.Insert();
                    if (PRNo != string.Empty)
                    {
                        foreach (DataRow dr in dtItems.Rows)
                        {
                            string str = string.Empty;
                            string indentnumber = "";
                            str = "Call Insert_PurchaseRequestDetail('" + PRNo + "','" + Util.GetString(dr["ItemID"]) + "','" + Util.GetString(dr["ItemName"]).Replace("'", "''") + "','" + Util.GetString(dr["SubCategory"]) + "'," + Util.GetDecimal(dr["RequiredQty"]) + "," + Util.GetDecimal(dr["RequiredQty"]) + ",0,'" + Util.GetString(dr["Specification"]) + "','" + Util.GetString(dr["Purpose"]) + "',0,'" + Util.GetString(dr["Unit"]) + "','" + Util.GetString(dr["Dept"]) + "','" + typeOfTnx + "','" + storeLedgerNo + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "',0,0,'" + indentnumber + "');";
                            int result = Convert.ToInt32(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, str));
                            if (result < 1)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                HttpContext.Current.Session.Remove("dtItems");
                                return "2";
                            }
                        }
                        int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + DepartMent.ToString() + "'"));
                        string notification = Notification_Insert.notificationInsert(24, PRNo, Tranx, "", "", roleID);
                        Tranx.Commit();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        // Clear();
                        return PRNo;
                    }
                    else
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        HttpContext.Current.Session.Remove("dtItems");
                        return "3";
                    }
                }
                catch (Exception ex)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    HttpContext.Current.Session.Remove("dtItems");
                    return "4";
                }
            }
            else
            {
                HttpContext.Current.Session.Remove("dtItems");
                return "5";
            }
        }
        else
        {
            HttpContext.Current.Session.Remove("dtItems");
            return "6";
        }
    }
}
