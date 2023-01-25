using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web;

public partial class Design_IPD_InvestigationIndent : System.Web.UI.Page
{

    public int Flag = 0;
    #region Event Handling
    DataTable dtl = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }

        lblMsg.Text = "";

        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();


            if (Request.QueryString["TransactionID"] != null)
            {
                if (Session["LoginType"].ToString() == "EMR") HyperLink1.Visible = false;
                string TID = Request.QueryString["TransactionID"].ToString();
               
                AllQuery AQ = new AllQuery();
                DataTable dt = AQ.GetPatientAdjustmentDetails(TID);
                DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
                ViewState["Authority"] = dtAuthority;

                if (dt != null && dt.Rows.Count > 0)
                {
                    if (dt.Rows[0]["IsBillFreezed"].ToString() == "1")
                    {
                        DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                        if ((dt.Rows[0]["IsBillFreezed"].ToString() == "1") && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
                        {
                            string Msg = "";

                            if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0")
                            {
                                Msg = "You Are Not Authorised To AMEND IPD Bills...";
                                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                            }
                            else if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "1" && dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                            {
                                Msg = "Patient's Final Bill has been Closed for Further Updating...";
                                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                            }
                        }
                        else if (dt.Rows[0]["IsBillFreezed"].ToString().Trim() == "1" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
                        {
                            string Msg = "";
                            Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);

                        }
                    }
                }
                txtInBetweenSearch.Focus();
                ViewState["TransID"] = TID;
                AllLoadData_IPD.BindDoctorIPD(ddlDoctor);
                BindCategory();
                BindPatientDetails();
                BindInvestigation(ddlcategory.SelectedValue, ddlsubcategory.SelectedValue);
                AllLoadData_Store.bindTypeMaster(ddlRequestType);
            }
        }
    }
    private void BindCategory()
    {
        string strQuery = "";

        strQuery = "SELECT cat.Name,cat.CategoryID from f_categorymaster cat inner join f_configrelation conf on conf.CategoryID=cat.CategoryID where conf.ConfigID  IN (3)";

        DataTable Items = StockReports.GetDataTable(strQuery);
        ddlcategory.DataSource = Items;
        ddlcategory.DataTextField = "Name";
        ddlcategory.DataValueField = "CategoryID";
        ddlcategory.DataBind();
        ddlcategory.Items.Insert(0, new ListItem("Select", "0"));
        BindSubCategory(ddlcategory.SelectedValue);
    }

    private void BindSubCategory(string value)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT subcategoryid,NAME FROM f_subcategorymaster");
        if (value == "Select")
            sb.Append("  WHERE categoryID IN ('LSHHI3','LSHHI7')");
        else
        {
            sb.Append("  WHERE categoryID = '" + value + "'");
        }
        DataTable Items = StockReports.GetDataTable(sb.ToString());
        ddlsubcategory.DataSource = Items;
        ddlsubcategory.DataTextField = "Name";
        ddlsubcategory.DataValueField = "subcategoryid";
        ddlsubcategory.DataBind();
        ddlsubcategory.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void btnSelect_Click(object sender, EventArgs e)
    {
        string ItemID = Util.GetString(lstInv.SelectedValue.Split('#')[0]);
        if (lstInv.SelectedIndex == -1)
        {
            lblMsg.Text = "Please Select Item";
            return;
        }

        AddItem();
        DataTable dtItem = (DataTable)ViewState["dtItems"];
        Flag = 1;
        grdItemRate.DataSource = dtItem;
        grdItemRate.DataBind();
        txtFirstNameSearch.Text = string.Empty;
        ViewState["IsSelected"] = 0;
        txtInBetweenSearch.Text = "";
        txtInBetweenSearch.Focus();
        pnlhide.Visible = true;

    }
    protected void btnReceipt_Click(object sender, EventArgs e)
    {
        string IndentNo = SaveData();
        if (IndentNo != string.Empty)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Indent No.: " + IndentNo + "');", true);
            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='InvestigationIndent.aspx?TransactionID=" + ViewState["TransID"].ToString() + "';", true);
            grdItemRate.DataSource = null;
            grdItemRate.DataBind();
            ViewState["dtItems"] = null;
            pnlhide.Visible = false;

        }
        else
            lblMsg.Text = "Error...";
    }
    protected void grdItemRate_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["dtItems"];
            dtItem.Rows[args].Delete();
            dtItem.AcceptChanges();
            grdItemRate.DataSource = dtItem;
            grdItemRate.DataBind();
            ViewState["dtItems"] = dtItem;
            if (dtItem.Rows.Count > 0)
            {
                pnlhide.Visible = true;
            }
            else
            {
                pnlhide.Visible = false;
            }
        }
    }
    #endregion

    #region Data Binding
    
    private void BindInvestigation(string category, string subcategory)
    {
        string ScheduleChargeID = StockReports.GetPatientCurrentRateScheduleID_IPD(ViewState["TransID"].ToString());
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT TypeName,IM.ItemID FROM f_itemmaster IM INNER JOIN f_subcategorymaster sub ON  IM.SubCategoryID=sub.SubCategoryID  INNER JOIN investigation_master ims ON ims.Investigation_Id=im.Type_ID ");
        sb.Append("    INNER JOIN f_configrelation cf ON cf.CategoryID = sub.CategoryID ");
        sb.Append("   WHERE cf.ConfigID=3 AND im.Isactive=1  ");
        if (category != "0")
        {
            sb.Append(" AND cf.CategoryID='" + category + "'");
        }
        if (subcategory != "0")
        {
            sb.Append("   AND sub.SubCategoryID='" + subcategory + "'");
        }
        if (txtInBetweenSearch.Text.Trim() != string.Empty)
        {
            sb.Append("    and im.TypeName like '%" + txtInBetweenSearch.Text.Trim() + "%' ");
        }
        sb.Append("    ORDER BY TypeName ");

        DataTable dtInv = StockReports.GetDataTable(sb.ToString());
        if (dtInv != null && dtInv.Rows.Count > 0)
        {
            lstInv.DataSource = dtInv;
            lstInv.DataTextField = "TypeName";
            lstInv.DataValueField = "ItemId";
            lstInv.DataBind();
        }
        else
        {
            if (txtInBetweenSearch.Text.Trim() != string.Empty)
            {
                lblMsg.Text = "Match Not Found.";
                txtInBetweenSearch.Focus();
            }
            else
                lstInv.Items.Clear();
        }
    }
    private DataTable GetDataItemTable()
    {
        if (ViewState["dtItems"] != null)
        {
            return (DataTable)ViewState["dtItems"];
        }
        else
        {
            DataTable dtItem = new DataTable();
            dtItem = new DataTable();
            dtItem.Columns.Add("ItemID");
            dtItem.Columns.Add("ItemName");
            dtItem.Columns.Add("Quantity", typeof(float));
            dtItem.Columns.Add("DoctorID");
            dtItem.Columns.Add("DoctorName");
            dtItem.Columns.Add("IndentType");
            return dtItem;
        }
    }
    private void AddItem()
    {
        if (validateItem())
        {
            DataTable dtItem;
            if (ViewState["dtItems"] != null)
            {
                dtItem = (DataTable)ViewState["dtItems"];
            }
            else
                dtItem = GetDataItemTable();

            DataRow dr = dtItem.NewRow();

            dr["ItemName"] = lstInv.SelectedItem.Text;
            dr["ItemID"] = lstInv.SelectedItem.Value;
            dr["Quantity"] = 1;
            dr["DoctorID"] = ddlDoctor.SelectedItem.Value;
            dr["DoctorName"] = ddlDoctor.SelectedItem.Text;
            dr["IndentType"] = ddlRequestType.SelectedItem.Text;

            dtItem.Rows.Add(dr);
            dtItem.AcceptChanges();
            ViewState["dtItems"] = dtItem;
           
        }
    }
    private void BindPatientDetails()
    {
        lblTransactionNo.Text = Convert.ToString(ViewState["TransID"]);

        AllQuery AQ = new AllQuery();
        DataTable ds = AQ.GetPatientIPDInformation("", lblTransactionNo.Text.Trim());

        if (ds != null && ds.Rows.Count > 0)
        {
            if (Resources.Resource.IsmembershipInIPD == "1")
            {
                lblMsg.Text = ds.Rows[0]["IsMemberShipExpire"].ToString();
                lblMembership.Text = ds.Rows[0]["MemberShipCardNo"].ToString();
            }
            else
            {
                lblMsg.Text = "";
                lblMembership.Text = "";
            }
            lblPatientID.Text = ds.Rows[0]["PatientID"].ToString();
            lblTransactionNo.Text = ds.Rows[0]["TransactionID"].ToString();
            lblReferenceCode.Text = ds.Rows[0]["ReferenceCode"].ToString();
            lblCaseTypeID.Text = ds.Rows[0]["IPDCaseType_ID"].ToString();
            lblPanelID.Text = ds.Rows[0]["PanelID"].ToString();
            lblDoctorID.Text = ds.Rows[0]["DoctorID"].ToString();
            ViewState["ScheduleChargeID"] = ds.Rows[0]["ScheduleChargeID"].ToString();
            ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue(ds.Rows[0]["DoctorID"].ToString()));
            lblPatientType.Text = ds.Rows[0]["PatientType"].ToString();
            lblRoomID.Text = ds.Rows[0]["Room_ID"].ToString();
        }
    }
    #endregion

    #region Indent Issue
    private string SaveData()
    {
        string IndentNo = "";
        if (ViewState["dtItems"] != null)
        {
            DataTable dtItem = (DataTable)ViewState["dtItems"];
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                IndentNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select get_panelLedgerReceipt_No('Investigation Indent No.')").ToString();
                foreach(DataRow dr in dtItem.Rows)
                {
                    string sql = "INSERT INTO f_indent_detail_investigation(IndentNo,ItemId,ItemName,ReqQty,DeptFrom,Narration,UserId,TransactionID,IndentType,CentreID, "+
                        " Hospital_Id,DoctorID,PatientID,IPDCaseType_ID,Room_ID) values " +
                    "( '" + IndentNo + "', '" + dr["ItemID"].ToString() + "' , '" + dr["ItemName"].ToString() + "' , " + Util.GetDecimal(dr["Quantity"].ToString()) + " , '" + Session["DeptLedgerNo"].ToString() + "' , " +
                    " '" + txtReason.Text.Trim() + "' , '" + Session["ID"].ToString() + "' , '" + lblTransactionNo.Text.Trim() + "' , '" + dr["IndentType"].ToString() + "' , '" + Session["CentreID"].ToString() + "' , " +
                    " '" + Session["HOSPID"].ToString() + "' , '" + dr["DoctorID"].ToString() + "' ,'" + lblPatientID.Text.Trim() + "', '" + lblCaseTypeID.Text.Trim() + "' , '" + lblRoomID.Text.Trim() + "'  )";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sql);
                }
                
                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
               return IndentNo;
            }
            catch (Exception ex)
            {
                ClassLog c1 = new ClassLog();
                c1.errLog(ex);
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                return string.Empty;
            }
        }
        else
            return string.Empty;
    }
    #endregion

    private bool validateItem()
    {

        foreach (GridViewRow row in grdItemRate.Rows)
        {

            string itemId = ((Label)row.FindControl("lblItem")).Text;
            if (Util.GetString(lstInv.SelectedValue.Split('#')[0]) == itemId)
            {
                lblMsg.Text = "Investigation Already Selected";
                return false;
            }
        }
        return true;
    }

    protected void ddlcategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubCategory(ddlcategory.SelectedValue);
        BindInvestigation(ddlcategory.SelectedValue, ddlsubcategory.SelectedValue);
    }
    protected void ddlsubcategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindInvestigation(ddlcategory.SelectedValue, ddlsubcategory.SelectedValue);

    }
  
}
