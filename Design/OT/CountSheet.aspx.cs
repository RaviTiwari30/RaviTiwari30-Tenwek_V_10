using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OT_Post_CountSheet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString(); ;
         
            string TID = Request.QueryString["TID"].ToString();
            string PID = Request.QueryString["PID"].ToString();
            ViewState["PID"] = PID;
            ViewState["TransID"] = TID;
            search();
        }
    }
    private void search()
    {
        string userid = ViewState["UserID"].ToString();
        StringBuilder sb = new StringBuilder();

        DataTable dtDetails = StockReports.GetDataTable("SELECT pcm.id AS SurgeonID , IFNULL(pcd.SurgeonName,pcm.Surgeon)Surgeon,pcm.Surgeon AS surgeonmaster,pcd.* FROM ot_Post_CountSheet_master pcm LEFT JOIN ot_Post_Countsheet_Detail pcd ON pcd.SurgeonID=pcm.ID AND pcd.TransactionID='" + ViewState["TransID"].ToString() + "' ");
        if (dtDetails.Rows.Count > 0)
        {
            grdDetail.DataSource = dtDetails;
            grdDetail.DataBind();
        }
    }
    protected void grdDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            ((TextBox)e.Row.FindControl("txtTotal2")).Attributes.Add("readonly", "readonly");
            ((TextBox)e.Row.FindControl("txtTotal1")).Attributes.Add("readonly", "readonly");
            ((TextBox)e.Row.FindControl("txtFinal")).Attributes.Add("readonly", "readonly");
            if (((TextBox)e.Row.FindControl("txtFinal")).Text != "" || ((TextBox)e.Row.FindControl("txtTotal1")).Text != "" || ((TextBox)e.Row.FindControl("txtTotal2")).Text !="")
            {
                ((CheckBox)e.Row.FindControl("chk")).Checked = true;
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            }
            else
            {
                ((CheckBox)e.Row.FindControl("chk")).Checked = false;
            }
            if (((Label)e.Row.FindControl("lblSurgeon")).Text != ((Label)e.Row.FindControl("lblSurgeonMaster")).Text || ((Label)e.Row.FindControl("lblSurgeon")).Text == "Additional")
            {
                ((TextBox)e.Row.FindControl("txtSurgeon")).Visible = true;
                ((Label)e.Row.FindControl("lblSurgeon")).Visible = false;
                if (((TextBox)e.Row.FindControl("txtSurgeon")).Text == "Additional")
                {
                    ((TextBox)e.Row.FindControl("txtSurgeon")).Text = "";
                }
                else { }
            }
            else
            {
                ((Label)e.Row.FindControl("lblSurgeon")).Visible = true;
               ((TextBox)e.Row.FindControl("txtSurgeon")).Visible = false;

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
           int count = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete From ot_Post_Countsheet_Detail where  TransactionID='" + ViewState["TransID"].ToString() + "' ");

           for (int i = 0; i < grdDetail.Rows.Count; i++)
           {
               if (((CheckBox)grdDetail.Rows[i].FindControl("chk")).Checked == true)
               {
                   ((TextBox)grdDetail.Rows[i].FindControl("txtTotal1")).Attributes.Add("readonly", "false");
                   ((TextBox)grdDetail.Rows[i].FindControl("txtTotal2")).Attributes.Add("readonly", "false");
                   ((TextBox)grdDetail.Rows[i].FindControl("txtFinal")).Attributes.Add("readonly", "false");

                   string additional = "";
                   if (((Label)grdDetail.Rows[i].FindControl("lblSurgeon")).Text == "Additional" && ((TextBox)grdDetail.Rows[i].FindControl("txtSurgeon")).Text == "")
                   {
                       additional = ((Label)grdDetail.Rows[i].FindControl("lblSurgeon")).Text;
                   }
                   else
                   {
                       additional = ((TextBox)grdDetail.Rows[i].FindControl("txtSurgeon")).Text;
                   }

                   str = "Insert Into ot_Post_Countsheet_Detail(TransactionID,PatientID,SurgeonID,SurgeonName,initial,addInitial1,addInitial2,addInitial3,addInitial4,addInitial5,Total1,CountFirst,FistAdd1,FistAdd2,FistAdd3,FistAdd4,Total2,CountSecond,Final,Entry_By) Values('" + ViewState["TransID"].ToString() + "','" + ViewState["PID"].ToString() + "','" + ((Label)grdDetail.Rows[i].FindControl("lblSurgeonID")).Text + "','" + additional + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtinitial")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtaddInitial1")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtaddInitial2")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtaddInitial3")).Text + "','" +
                       ((TextBox)grdDetail.Rows[i].FindControl("txtaddInitial4")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtaddInitial5")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txttotal1")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFirst")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFistAdd1")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFistAdd2")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFistAdd3")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFistAdd4")).Text + "','" +
                      ((TextBox)grdDetail.Rows[i].FindControl("txtTotal2")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtSecond")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtFinal")).Text + "','" + ViewState["UserID"].ToString() + "')";
                   a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

               }
           }
            Tranx.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            search();
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