using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;

public partial class Design_IPD_OrderSet_Nursing_OrderSet_PatientInvestigation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string OrderSetID = Request.QueryString["ID"].ToString();
            ViewState["ID"] = OrderSetID;
            string TID = Request.QueryString["TID"].ToString();
            ViewState["TransID"] = TID;
            string Groupid = Request.QueryString["GroupID"].ToString();
            ViewState["GroupID"] = Groupid;
            ViewState["Relational_ID"] = Request.QueryString["RelationalID"].ToString();
            string categoryid = Request.QueryString["categoryid"].ToString();
            ViewState["categoryid"] = categoryid;
           
            GetDoctor();
            txtSearch.Attributes.Add("onKeyPress", "doClick('" + btnSelect.ClientID + "',event)");
            BindPatientExam();
            BindSubCategory(ViewState["categoryid"].ToString());
            BindInvestigation( ddlsubcategory.SelectedValue);
        }
    }
   
    private void BindSubCategory(string value)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT subcategoryid,NAME FROM f_subcategorymaster");
        if (value == "-Select-")
            sb.Append("  WHERE categoryid IN ('Lshhi3','LSHHI7')");
        else
        {
            sb.Append("  WHERE categoryid = '" + value + "'");
        }
        DataTable Items = StockReports.GetDataTable(sb.ToString());
        ddlsubcategory.DataSource = Items;
        ddlsubcategory.DataTextField = "Name";
        ddlsubcategory.DataValueField = "subcategoryid";
        ddlsubcategory.DataBind();
        //ddlCategory.SelectedIndex = 0;
        ddlsubcategory.Items.Insert(0, "-Select-");
    }

    private void BindInvestigation( string subcategory)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select item,concat(ItemID,'#',SubCategoryID,'#',cast(LabType AS BINARY),'#',Type_ID)ItemID ");
        sb.Append(" from(select  CONCAT(im.ItemCode,'#',im.TypeName)  Item,im.ItemID,im.SubCategoryID,im.Type_ID,");
        sb.Append(" (case when cr.ConfigID=3 then 'LAB'  ");
        sb.Append("   end)LabType  from f_itemmaster im inner join f_subcategorymaster sm ");
        sb.Append(" on sm.subcategoryid = im.subcategoryid inner join f_configrelation  cr on cr.categoryid = sm.categoryid ");
        sb.Append(" where cr.ConfigID in (3) and im.IsActive=1 AND cr.categoryid='" + ViewState["categoryid"].ToString() + "'");
         if (subcategory != "-Select-")
        {
           sb.Append("   AND sm.SubCategoryID='"+subcategory+"'");
        }

         sb.Append("   )t1 order by Item");
        DataTable dtInv = StockReports.GetDataTable(sb.ToString());
        if (dtInv != null && dtInv.Rows.Count > 0)
        {
            lstInv.DataSource = dtInv;
            lstInv.DataTextField = "Item";
            lstInv.DataValueField = "ItemID";
            lstInv.DataBind();
        }
        else
        {
            lstInv.Items.Clear();
        }
    }
    protected void ddlsubcategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindInvestigation(ddlsubcategory.SelectedValue);

    }
    private void GetDoctor()
    {
        if (Convert.ToString(Session["LoginType"]).ToUpper() == "DOCTOR")
        {
            string str = "select DoctorID from doctor_employee where Employee_id='" + Convert.ToString(Session["ID"]) + "'";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
                lblDoctorID.Text = Util.GetString(dt.Rows[0][0]);

        }
    }
    private void BindPatientExam()
    {
        string TransactionId = Convert.ToString(Request.QueryString["TID"]);


        StringBuilder sb = new StringBuilder();
        sb.Append("select pt.outsource,pt.Test_ID ItemID,date_format(pt.PrescribeDate,'%d-%b-%Y') Date,remarks,im.typeName Item from nursing_orderset_Investigation pt inner join f_itemmaster im ");
        sb.Append(" on pt.test_ID = im.ItemID  INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = im.subcategoryid where pt.TransactionID = '" + TransactionId + "' ");
        sb.Append(" and pt.GroupID = '" + ViewState["GroupID"] + "' and pt.RelationalID=" + ViewState["Relational_ID"] + " and sm.CategoryID='" + ViewState["categoryid"].ToString() + "'");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());


        if (dt.Rows.Count > 0)
        {
            grdItemRate.DataSource = dt;
            grdItemRate.DataBind();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string value = dt.Rows[i]["Outsource"].ToString();
                if (Convert.ToInt16(value) == 1)
                {
                    ((CheckBox)grdItemRate.Rows[i].FindControl("chkprint")).Checked = true;
                }
            }
            ViewState["dtItems"] = dt;
        }
    }
    protected void btnSelect_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (lstInv.SelectedIndex > -1)
        {
            DataTable dtItem = new DataTable();
            if (ViewState["dtItems"] != null)
                dtItem = (DataTable)ViewState["dtItems"];
            else
                dtItem = GetItem();

            for (int i = 0; i < dtItem.Rows.Count; i++)
            {
                if (dtItem.Rows[i]["ItemID"].ToString() == lstInv.SelectedValue.Split('#')[0].ToString())
                {
                    lblMsg.Text = "Investigation Already Prescribed";
                    return;
                }
            }

            DataRow dr = dtItem.NewRow();
            dr["Item"] = lstInv.SelectedItem.Text;
            dr["ItemID"] = lstInv.SelectedValue.Split('#')[0].ToString();
            dr["Date"] = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            dr["Remarks"] = txtRemarks.Text;
           


            dtItem.Rows.Add(dr);

            ViewState.Add("dtItems", dtItem);
            grdItemRate.DataSource = dtItem;
            grdItemRate.DataBind();
            for (int i = 0; i < dtItem.Rows.Count; i++)
            {
                string value = dtItem.Rows[i]["Outsource"].ToString();
                if (value == "")
                { }
                else if (Convert.ToInt16(value) == 1)
                {
                    ((CheckBox)grdItemRate.Rows[i].FindControl("chkprint")).Checked = true;
                }
            }
            txtSearch.Text = string.Empty;
            //lblMsg.Text = "Investigation Added Successfully";
            sm1.SetFocus(txtSearch);
            txtRemarks.Text = "";

        }
        else
            lblMsg.Text = "Please Select Investigation";
    }
    private string SaveData()
    {

        
            
            //string PatientID = Convert.ToString(Request.QueryString["PID"]);
            //string LnxNo = Convert.ToString(Request.QueryString["LnxNo"]);

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            if (ViewState["dtItems"] != null)
            {
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from nursing_orderset_investigation where TransactionID = '" + ViewState["TransID"] + "' and GroupID = '" + ViewState["GroupID"] + "' and RelationalID=" + ViewState["Relational_ID"].ToString() + " and CategoryID='" + ViewState["categoryid"].ToString() + "'");
                    DataTable dtItem = (DataTable)ViewState["dtItems"];


                    foreach (GridViewRow dr in grdItemRate.Rows)
                    {
                        int outsource = 0;
                        string testid = ((System.Web.UI.WebControls.Label)dr.FindControl("lblvalue")).Text;

                        string remarks = ((System.Web.UI.WebControls.Label)dr.FindControl("lblRemarks")).Text;
                        int flag = 0;
                        for (int i = 0; i < grdItemRate.Rows.Count; i++)
                        {

                            string GrditemID = ((Label)grdItemRate.Rows[i].FindControl("lblvalue")).Text;
                            if (GrditemID == ((System.Web.UI.WebControls.Label)dr.FindControl("lblvalue")).Text)
                            {

                                if (((CheckBox)grdItemRate.Rows[i].FindControl("chkPrint")).Checked == true)
                                {

                                    flag = 1;

                                    break;
                                }
                            }
                        }

                        if (flag == 1)
                            outsource = 1;

                        else
                            outsource = 0;

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO nursing_orderset_Investigation (TransactionID,GroupID,Test_ID,Remarks,Outsource,OrderSetID,RelationalID,categoryID) VALUES('" + ViewState["TransID"].ToString() + "','" + ViewState["GroupID"].ToString() + "','" + testid + "','" + remarks + "','" + outsource + "','" + ViewState["ID"].ToString() + "'," + ViewState["Relational_ID"].ToString() + ",'" + ViewState["categoryid"].ToString() + "')");
                        // pt.Insert();

                        //if (outsource == 1)
                        //{

                        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/CPOE/Investigation_OutsourceSlip.aspx?TransactionID=" + ViewState["TransID"] + "&GroupID=" + ViewState["GroupID"] + "')", true);
                        //}

                    }

                    tnx.Commit();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

                    return "1";
                }
                catch (Exception ex)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return string.Empty;
                }
            }
            else
            {
                try
                {
                    int numberOfRecords = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from nursing_orderset_investigation where TransactionID = '" + ViewState["TransID"] + "' and GroupID = '" + ViewState["GroupID"] + "' and RelationalID=" + ViewState["Relational_ID"].ToString() + " and CategoryID='" + ViewState["categoryid"].ToString() + "'");
                    tnx.Commit();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    if (numberOfRecords > 1)
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
                    else
                        lblMsg.Text = "Please Select Investigation";
                    return "2";
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return string.Empty;
                }
                
            }
        
           
    }
    private DataTable GetItem()
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
            dtItem.Columns.Add("Item");
            dtItem.Columns.Add("Date");
            dtItem.Columns.Add("Remarks");
            dtItem.Columns.Add("Outsource");
            return dtItem;
        }
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
            //for (int i = 0; i < dtItem.Rows.Count; i++)
            //{
            //   string value = dtItem.Rows[i]["Outsource"].ToString();
            //    if (Convert.ToInt16(value) == 1)
            //    {
            //        ((CheckBox)grdItemRate.Rows[i].FindControl("chkprint")).Checked = true;


            //    }

            //}
            ViewState["dtItems"] = dtItem;
          //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
        }
        //if (e.CommandName == "Print")
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/CPOE/Investigation_OutsourceSlip.aspx?PatientID=", + Util.GetString(e.CommandArgument)  + "'&outsource" + Util.GetString(e.CommandArgument) + true);

        //}

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string TransactionId = Convert.ToString(Request.QueryString["TID"]);
        //string LnxNo = Convert.ToString(Request.QueryString["LnxNo"]);
        if (SaveData() != string.Empty)
        {
            grdItemRate.DataSource = null;

            grdItemRate.DataBind();
            ViewState.Remove("dtItems");
            BindInvestigation(ddlsubcategory.SelectedValue);
            BindPatientExam();
        }
        
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);

        }
    }
    
}
