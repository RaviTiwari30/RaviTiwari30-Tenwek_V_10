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
using System.Text;

public partial class Design_IPD_OrderSet_Nursing_DVTProphylaxis : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {

                string OrderSetID = Request.QueryString["ID"].ToString();
                ViewState["ID"] = OrderSetID;
                string TID = Request.QueryString["TID"].ToString();
                ViewState["TransID"] = TID;
                string Groupid = Request.QueryString["GroupID"].ToString();
                ViewState["GroupID"] = Groupid;
                ViewState["NewGroupID"] = 8;
                ViewState["Relational_ID"] = Request.QueryString["RelationalID"].ToString();
                bindOrderSet(Convert.ToInt16(ViewState["NewGroupID"]));
                BindPatientDVT();
            }
            catch
            {

            }


        }

    }
    private void BindPatientDVT()
    {
        int Count = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from nursing_ordersetDVTProphylaxis where TransactionID='" + ViewState["TransID"].ToString() + "' and GroupID=" + ViewState["GroupID"] + " and RelationalID=" + ViewState["Relational_ID"] + ""));
        if (Count > 0)
        {
            string TransactionId = Convert.ToString(Request.QueryString["TID"]);
            StringBuilder sb = new StringBuilder();
            //  sb.Append("select pt.outsource,pt.Test_ID ItemID,date_format(pt.PrescribeDate,'%d-%b-%Y') Date,remarks,im.typeName Item from nursing_ordersetDVTProphylaxis  ");
            //  sb.Append("  where TransactionID = '" + TransactionId + "' ");
            //  sb.Append(" and GroupID = '" + ViewState["GroupID"] + "' and RelationalID=" + ViewState["Relational_ID"] + " ");

            //  DataTable dt = new DataTable();
            //  dt = StockReports.GetDataTable(sb.ToString());
            sb.Append("SELECT nos.GroupID,nos.Groups,nos.ID,if(nos.CheckBox=1,'true','false')CheckBox,nos.Items,nos.SubGroup,IF(ISNULL(nod.TransactionID),'false','true')Chk,if(nos.IsPopup=1,'true','false')IsPopup,IFNULL(popurl,'')popupurl,'" + ViewState["TransID"].ToString() + "' TID," + ViewState["Relational_ID"].ToString() + " RelationalID,ifnull(Categoryid,'')Categoryid ");
            sb.Append(" FROM  nursing_orderset_master    nos LEFT  JOIN  nursing_ordersetDVTProphylaxis  nod");
            sb.Append("  ON nos.ID=nod.ItemsID AND nod.TransactionID='" + ViewState["TransID"].ToString() + "' and nod.RelationalID=" + ViewState["Relational_ID"] + " ");
            sb.Append("  WHERE nos.isActive=1 AND    nos.GroupID=8 ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdMedicine.DataSource = dt;
                grdMedicine.DataBind();
            }
        }

    }
    protected void GroupHeader(int GroupID)
    {
        string str = StockReports.ExecuteScalar("Select Groups from nursing_orderSet_master where GroupID=" + GroupID + "");
        lblHeader.Text = str.ToString();
    }
    public void bindOrderSet(int ID)
    {
        ViewState["NewGroupID"] = ID;

        BindGrid(ID);
        GroupHeader(ID);
        pnlSpine.Visible = true;
        btnSave.Visible = true;

    }
    public void BindGrid(int GroupID)
    {
        DataTable dtItems = StockReports.GetDataTable("SELECT ID,Groups,GroupID,SubGroup,Items,if(CheckBox=1,'true','false')CheckBox,('false')chk,if(IsPopup=1,'true','false')IsPopup,IFNULL(popurl,'')popupurl,'" + ViewState["TransID"].ToString() + "' TID," + ViewState["Relational_ID"].ToString() + " RelationalID,ifnull(categoryid,'')categoryid FROM nursing_orderSet_master WHERE IsActive=1 AND GroupID= " + GroupID + " order by serialno");
        if (dtItems.Rows.Count > 0)
        {

            grdMedicine.DataSource = dtItems;
            grdMedicine.DataBind();
            ViewState["NewGroupID"] = GroupID;
            btnSave.Visible = true;
        }
        else
        {
            grdMedicine.DataSource = null;
            grdMedicine.DataBind();
            btnSave.Visible = false;
        }
    }
    protected void BindDetails(int GroupID, int RelationalID)
    {
        int Count = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from nursing_orderset_details where TransactionID='" + ViewState["TransID"].ToString() + "' and GroupID=" + GroupID + " and RelationalID=" + RelationalID + ""));
        if (Count > 0)
        {
            pnlSpine.Visible = true;
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT nos.GroupID,nos.Groups,nos.ID,if(nos.CheckBox=1,'true','false')CheckBox,nos.Items,nos.SubGroup,IF(ISNULL(nod.TransactionID),'false','true')Chk,if(nos.IsPopup=1,'true','false')IsPopup,IFNULL(popurl,'')popupurl,'" + ViewState["TransID"].ToString() + "' TID," + ViewState["Relational_ID"].ToString() + " RelationalID,ifnull(Categoryid,'')Categoryid ");
            sb.Append(" FROM  nursing_orderset_master    nos LEFT  JOIN  nursing_orderset_details  nod");
            sb.Append("  ON nos.ID=nod.ItemID AND nod.TransactionID='" + ViewState["TransID"].ToString() + "' and nod.RelationalID=" + RelationalID + " ");
            sb.Append("  WHERE nos.isActive=1 AND   nos.groupid=" + GroupID + " ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {

                grdMedicine.DataSource = dt;
                grdMedicine.DataBind();
                ViewState["NewGroupID"] = GroupID;
                // btnSave.Visible = true;
                GroupHeader(GroupID);

                btnSave.Visible = false;

            }
            else
            {

                btnSave.Visible = true;
            }
        }
    }
    private DataTable GetItemDataTable()
    {

        if (ViewState["dtItems"] != null)
        {
            return (DataTable)ViewState["dtItems"];
        }
        else
        {
            DataTable dtItem = new DataTable();
            dtItem.Columns.Add("Groups");
            dtItem.Columns.Add("SubGroup");
            dtItem.Columns.Add("Items");
            return dtItem;
        }
    }
    protected void grdmedicine_databound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex >= 1)
        {
            string Group = ((Label)e.Item.FindControl("lblSubGroupDisplay")).Text;

            string PreviousGroup = ((Label)grdMedicine.Items[e.Item.ItemIndex - 1].FindControl("lblSubGroup")).Text;

            if (Group == PreviousGroup)
            {
                ((Label)e.Item.FindControl("lblSubGroupDisplay")).Text = "";
                ((HtmlTableRow)e.Item.FindControl("tr")).Visible = false;
            }



        }
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {

            ImageButton ib = (ImageButton)e.Item.FindControl("Image1");
            if (ib != null)
            {

                // ib.AccessKey = (e.Item.ItemIndex + 1).ToString();
            }
        }

    }
    protected void grdmedicine_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "view")
        {
            string GroupID = e.CommandArgument.ToString().Split('#')[0];
            string PopupUrl = e.CommandArgument.ToString().Split('#')[1];
            string OrderSetID = e.CommandArgument.ToString().Split('#')[2];
            lblPopupurl.Text = PopupUrl.ToString();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('" + PopupUrl + "?TID=" + ViewState["TransID"] + "&GroupID=" + GroupID + "&OrderSetID=" + OrderSetID + "&RelationalID=" + ViewState["Relational_ID"] + "');", true);

        }

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        saveDate();
    }

    public void saveDate()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM nursing_ordersetDVTProphylaxis WHERE TransactionID ='" + ViewState["TransID"].ToString() + "'and GroupID='" + ViewState["GroupID"].ToString() + "' and RelationalID=" + ViewState["Relational_ID"].ToString() + "");

            foreach (RepeaterItem rpt in grdMedicine.Items)
            {
               
                CheckBox chk = (CheckBox)rpt.FindControl("chk");
                if (chk.Checked)
                {
                   

                    string Group = Util.GetString(((Label)rpt.FindControl("lblGroup")).Text);
                    string GroupID = Util.GetString(((Label)rpt.FindControl("lblGroupID")).Text);
                    string SubGroup = Util.GetString(((Label)rpt.FindControl("lblSubGroup")).Text);
                    string Items = Util.GetString(((Label)rpt.FindControl("lblItem")).Text);
                    string ItemID = Util.GetString(((Label)rpt.FindControl("lblID")).Text);
                    string strQuery = "INSERT INTO nursing_ordersetDVTProphylaxis (MainGroupName,MainGroupID,GroupID,SubGroup,Items,ItemsID,TransactionID,CreatedBy,RelationalID,OrderSetID) VALUES('" + Group + "','" + GroupID + "','" + ViewState["GroupID"].ToString() + "','" + SubGroup + "','" + Items + "','" + ItemID + "','" + ViewState["TransID"] + "' ,'" + Session["ID"].ToString() + "'," + ViewState["Relational_ID"] + ",'" + ViewState["ID"].ToString() + "');";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

                }
            

            }
            Tranx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }



    }
}