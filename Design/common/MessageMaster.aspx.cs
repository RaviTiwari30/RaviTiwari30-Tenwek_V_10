using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_common_MessageMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
        }

    }

    protected void BindGrid()
    {
        DataTable dtSympton = All_LoadData.message();
        grdMessage.DataSource = dtSympton;
        grdMessage.DataBind();

    }
    
    //protected void grdMessage_RowCommand(object sender, GridViewCommandEventArgs e)
    //{
    //    if (e.CommandName == "Insert")
    //    {
    //        try
    //        {
    //            lblMsg.Text = "";
    //            TextBox txtmsg = (TextBox)grdMessage.FooterRow.FindControl("txtMessage");
    //            if (txtmsg.Text.Trim() != "")
    //            {
    //                  if (ValidateMessage(txtmsg.Text.Trim().ToString()))
    //                       StockReports.ExecuteDML("INSERT INTO Message_master (msgcode,Message) VALUES('" + txtmsg.Text.Trim() + "','" +    Session["ID"].ToString() + "')");
    //            }
    //            else
    //            {
    //                ScriptManager.RegisterStartupScript(this, this.GetType(), "", "alert('Message Already Exists ....');", true);
    //            }
    //            BindGrid();
    //        }
    //        catch (Exception ex)
    //        {
    //            lblMsg.Text = ex.Message;
    //            ClassLog c1 = new ClassLog();
    //            c1.errLog(ex);
    //        }
    //    }
    //}
    protected void grdMessage_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        Label lblMSGCODE = (Label)grdMessage.Rows[e.RowIndex].FindControl("lblMSGCODE");
        TextBox txtmessage = (TextBox)grdMessage.Rows[e.RowIndex].FindControl("txtmessage");
        ViewState["message"] = txtmessage.Text;
        StockReports.ExecuteDML("update message_master SET message='" + txtmessage.Text.Trim() + "' where msgcode= '" + lblMSGCODE.Text + "'");
        grdMessage.EditIndex = -1;
        BindGrid();



    }
    protected void grdMessage_RowEditing(object sender, GridViewEditEventArgs e)
    {
        grdMessage.EditIndex = e.NewEditIndex;
        BindGrid();
    }
    protected void grdMessage_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        grdMessage.EditIndex = -1;
        BindGrid();
    }
    protected bool ValidateMessage(string msgcode)
         {
         int i=0;
             i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Message_master where message='" + msgcode + "' "));
             if (i > 0)
             { return false; }
             else
             { return true; }
         }
    protected bool ValidateMessageUpdate(string msgcode)
    {
        int i = 0;
        i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Message_master where message='" + ViewState["Message"].ToString() + "' "));
        if (i > 0)
        { return false; }
        else
        { return true; }
    }
    protected void btnGenerateFunction_Click(object sender, EventArgs e)

    {
        try
        {
     
            DataTable dt = StockReports.GetDataTable("SELECT MsgCode,Message FROM message_master");
            StringBuilder sb = new StringBuilder();

            if (dt.Rows.Count > 0)
            {
                sb.Append(" function DisplayMsg(_Code, _ControlID) { ");
                sb.Append(" switch (_Code) { ");
                foreach (DataRow row in dt.Rows)
                {
                    sb.Append(" case '" + row["MsgCode"].ToString() + "': ");
                    sb.Append(" document.getElementById(_ControlID).innerHTML = '" + row["Message"].ToString() + "'; ");
                    sb.Append(" break; ");

                    
                }
                sb.Append(" default: ");
                sb.Append(" document.getElementById(_ControlID).innerHTML = ''; ");
                sb.Append(" break; ");
                sb.Append(" } ");
                sb.Append(" } ");
            }
            File.WriteAllText(Server.MapPath("~/Scripts/Message.js"), sb.ToString().Replace("\r\n", ""));
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
        }
    }
}