using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OT_CssdCountSheet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString(); 
             
        }

    }
    protected void btnSearchData_Click(object sender, EventArgs e)
    {
        BindGridview1(txtPatientID.Text);
    }

    public void BindGridview1(string PatientId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT GROUP_CONCAT( DISTINCT cd.`setId`)SetID,GROUP_CONCAT(DISTINCT cm.`NAME`)SetName, ");
        sb.Append("  cd.`requestId`,cd.`usedAgainstUHID`,cd.usedAgainstTID,DATE_FORMAT( cd.`createdDateTime`,'%d-%b-%Y %I:%i %p') RequestedDateTime FROM cssd_requisition cd ");
        sb.Append("  INNER JOIN  `cssd_f_set_master` cm ON cm.`Set_ID`=cd.`setId` ");
        sb.Append("  WHERE cd.usedAgainstUHID='" + PatientId + "'   ");
        sb.Append("  GROUP BY cd.`requestId` ORDER BY id DESC ");

        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            GridView1.DataSource = dtDetails;
            GridView1.DataBind();
            divCountSheetDetails.Visible = false;
            divSearchData.Visible = true;

        }
        else
        {
            divCountSheetDetails.Visible = false;
            divSearchData.Visible = false;
            lblMsg.Text = "No Data Found.";
        }

    }


    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        //Determine the RowIndex of the Row whose Button was clicked.
        int rowIndex = Convert.ToInt32(e.CommandArgument);

        //Reference the GridView Row.
        GridViewRow row = GridView1.Rows[rowIndex];

        Label SetID = (Label)row.FindControl("lblSetID");
        Label RequestID = (Label)row.FindControl("lblrequestId");
        Label PatientId = (Label)row.FindControl("lblusedAgainstUHID");
          Label TID = (Label)row.FindControl("lblusedAgainstTID");
         
        grdDetailSearch(SetID.Text, RequestID.Text, PatientId.Text);

        txtUHId.Text = PatientId.Text;
        txtSetId.Text = SetID.Text;
        txtTransactionID.Text = TID.Text;
        txtRequestId.Text = RequestID.Text;

    }

    private void grdDetailSearch(string SetID, string RequestId, string PatientId)
    {
        StringBuilder sb = new StringBuilder();
         
        sb.Append("    SELECT cd.`ItemID` CdItemId,cd.`SetID` CdSetId,cd.`SetName` CdSetName, ");
        sb.Append("    cd.`ItemName` CdItemName,cr.`requestId`,cr.`usedAgainstTID`, ");
        sb.Append("    cr.`usedAgainstUHID`,cop.* FROM cssd_requisition cr ");
        sb.Append("    INNER JOIN cssd_set_itemdetail cd ON cd.`SetID`= cr.`setId` ");
        sb.Append("    LEFT JOIN cssd_ot_post_countsheet_detail  cop ON cop.`TransactionID`=cr.`usedAgainstTID` AND cop.`ItemId`=cd.`ItemID` AND cop.`SetId`=cd.`SetID` ");
        sb.Append("    WHERE cr.`setId` IN("+SetID+") AND cd.`IsActive`=1 AND cr.`requestId`='"+RequestId+"' AND cr.`usedAgainstUHID`='"+PatientId+"'  AND cd.`IsActive`=1 ");
        sb.Append("    GROUP BY cd.`ItemID`,cd.`SetID` ORDER BY cd.`SetID` ");

        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());

        if (dtDetails.Rows.Count > 0)
        {
            grdDetail.DataSource = dtDetails;
            grdDetail.DataBind();
            divCountSheetDetails.Visible = true;
        }
        else
        {
            divCountSheetDetails.Visible = false;
        }
    }

     
    protected void grdDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            ((TextBox)e.Row.FindControl("txtTotal2")).Attributes.Add("readonly", "readonly");
            ((TextBox)e.Row.FindControl("txtTotal1")).Attributes.Add("readonly", "readonly");
            ((TextBox)e.Row.FindControl("txtFinal")).Attributes.Add("readonly", "readonly");
            if (((TextBox)e.Row.FindControl("txtFinal")).Text != "" || ((TextBox)e.Row.FindControl("txtTotal1")).Text != "" || ((TextBox)e.Row.FindControl("txtTotal2")).Text != "")
            {
                ((CheckBox)e.Row.FindControl("chk")).Checked = true;
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            }
            else
            {
                ((CheckBox)e.Row.FindControl("chk")).Checked = false;
            }


        }

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string str = "";
        int a = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {



            int count = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete From cssd_ot_post_countsheet_detail where  TransactionID='" + txtTransactionID.Text + "' And PatientID='" + txtUHId.Text + "' And SetId in(" + txtSetId.Text + ") And RequestId='"+txtRequestId.Text+"' ");

            for (int i = 0; i < grdDetail.Rows.Count; i++)
            {
                if (((CheckBox)grdDetail.Rows[i].FindControl("chk")).Checked == true)
                {
                    ((TextBox)grdDetail.Rows[i].FindControl("txtTotal1")).Attributes.Add("readonly", "false");
                    ((TextBox)grdDetail.Rows[i].FindControl("txtTotal2")).Attributes.Add("readonly", "false");
                    ((TextBox)grdDetail.Rows[i].FindControl("txtFinal")).Attributes.Add("readonly", "false");


                    str = "Insert Into cssd_ot_post_countsheet_detail(TransactionID,PatientID,SetId,SetName,initial,addInitial1,addInitial2,addInitial3,addInitial4,addInitial5,Total1,CountFirst,FistAdd1,FistAdd2,FistAdd3,FistAdd4,Total2,CountSecond,Final,Entry_By,ItemId,ItemName,RequestId) Values('" + ((Label)grdDetail.Rows[i].FindControl("lblusedAgainstTID")).Text + "','" + ((Label)grdDetail.Rows[i].FindControl("lblusedAgainstUHID")).Text + "','" + ((Label)grdDetail.Rows[i].FindControl("lblSetID")).Text + "','" + ((Label)grdDetail.Rows[i].FindControl("lblSetName")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtinitial")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtaddInitial1")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtaddInitial2")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtaddInitial3")).Text + "','" +
                        ((TextBox)grdDetail.Rows[i].FindControl("txtaddInitial4")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtaddInitial5")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txttotal1")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFirst")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFistAdd1")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFistAdd2")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFistAdd3")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFistAdd4")).Text + "','" +
                       ((TextBox)grdDetail.Rows[i].FindControl("txtTotal2")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtSecond")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFinal")).Text + "','" + ViewState["UserID"].ToString() + "','" + ((Label)grdDetail.Rows[i].FindControl("lblItemID")).Text + "','" + ((Label)grdDetail.Rows[i].FindControl("lblItemName")).Text + "','" + ((Label)grdDetail.Rows[i].FindControl("lblrequestId")).Text + "')";
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

                }
            }
            Tranx.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
           BindGridview1(txtUHId.Text);
           grdDetailSearch(txtSetId.Text, txtRequestId.Text, txtUHId.Text);

            
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
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